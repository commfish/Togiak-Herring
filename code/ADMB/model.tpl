// ----------------------------------------------------------------------------- //
//               Age-structured model for Alaska herring stocks                  //
//                                                                               //
//                               VERSION 0.1                                     //
//                                Jan  2015                                      //
//                                                                               //
//                                 AUTHORS                                       //
//                              Sherri Dressel                                   //                                 
//                        sherri.dressel@alaska.gov                              //
//                               Sara Miller                                     //
//                          sara.miller@alaska.gov                               //
//                               Kray Van Kirk                                   //
//                          kray.vankirk@alaska.gov                              //
//                                                                               //
//                   Built on code developed by Peter Hulson                     //
//                            pete.hulson@noaa.gov                               //
//                                                                               //
//                           Layout and references                               //
//                              Steven Martell                                   //
//                          martell.steve@gmail.com                              //
//                                                                               //
// CONVENTIONS: Formatting conventions are based on                              //
//              The Elements of C++ Style (Misfeldt et al. 2004)                 //
//                                                                               //
//                                                                               //
// NAMING CONVENTIONS:                                                           //
//             Macros       -> UPPERCASE                                         //
//             Constants    -> UpperCamelCase                                    //
//             Functions    -> lowerCamelCase                                    //
//             Variables    -> lowercase                                         //
//                                                                               //
//                                                                               //
//                                                                               //
// ----------------------------------------------------------------------------- //
//-- CHANGE LOG:                                                               --//
//--  Jan 2015 - revision of legacy code::                                     --//
//--               :variable naming conventions                                --//
//--               :intra-annual calendar                                      --//
//--               :standardization of units across stocks                     --//
//--               :modification for potential code distribution               --//
//--                                                                           --//
//--                                                                           --//
// ----------------------------------------------------------------------------- //


DATA_SECTION

  // |--------------------------------------------------------------------------|
  // |MCMC OUTPUT FILE
  // |--------------------------------------------------------------------------|

     !!CLASS ofstream evalout("evalout.prj");

  // |--------------------------------------------------------------------------|
  // | STRINGS FOR INPUT FILES                                                  |
  // |--------------------------------------------------------------------------|
  // |- The files below are listed in the 'model.dat' file;
  // |   nothing else should be in the 'model.dat' file
  // |- These files should be named by the stock they are modeling;
  // |   example: "sitka.dat", "seymour.dat"
  // |- DO NOT use two word names such as "seymour cove.dat"
  // |
  // | DataFile               : data to condition the assessment model    
  // | ControlFile            : controls for years, phases, and block options 
  // | Graphics               : vectors for some stock assessment graphics

  init_adstring DataFile;      
  init_adstring ControlFile;
  init_adstring LoopFile;
  init_adstring Graphics; 

  // | BaseFileName           : file prefix used for all  model output
  // | ReportFileName         : file name to which report file is printed

  !! BaseFileName = stripExtension(DataFile);  
  !! ReportFileName = BaseFileName + adstring(".rep");

  !! cout<<"You are modeling the "<<BaseFileName<<" stock of herring"<<endl;
  !! cout<<""<<endl;
  !! time(&start);

  !! ad_comm::change_datafile_name(DataFile);

  // |--------------------------------------------------------------------------|
  // | MODEL STRUCTURAL DIMENSIONS                                              |
  // |--------------------------------------------------------------------------|
  // | 
  // |-nages      -> number of ages
  // |-dat_styr   -> data start year
  // |-dat_nyr  -> data end year
  // |-mod_syr   -> model start year
  // |-mod_nyr  -> model end year
  // |-dyrs       -> data year index
  // |-myrs       -> model year index
  // |-md_offset  -> offset data to model
  // |-Year       -> year sequence for graphics (model + 1)
  // | 
  // | year         i
  // | age          j
  // | 

     init_int dat_syr;
     init_int dat_nyr;
     init_int mod_syr;
     init_int mod_nyr;
     init_int sage;
     init_int nage;
     init_int nages;
     int rec_syr;
	!!  rec_syr = mod_syr + sage;

	vector age(sage,nage);
	!! age.fill_seqadd(sage,1);
        

        int dyrs
        int myrs
        int md_offset
        vector Year(mod_syr,mod_nyr+1);       

     int i;
     int j;

 LOCAL_CALCS

  dyrs=dat_nyr-dat_syr+1;
  myrs=mod_nyr-mod_syr+1;
  md_offset=mod_syr-dat_syr;
  Year.fill_seqadd(mod_syr,1);   

 END_CALCS 


  
  // |--------------------------------------------------------------------------|
  // | FORECASTING WEIGHT                                                       |
  // |--------------------------------------------------------------------------|
  // | //biomass by year from ASA excel output
     init_vector threshold(1,myrs)
     init_vector fw_a_a(1,nages);

  // |---------------------------------------------------------------------------|
  // | Time series data.  Catch in short tons. Comps in proportions.
  // |---------------------------------------------------------------------------|
  
     init_vector  tot_obs_catch(1,myrs);
     init_vector  tot_obs_aerial(1,myrs);
     init_vector  tot_obs_aerial_tuned(1,myrs);

     init_matrix  obs_catch_naa(1,myrs,1,nages);
     init_matrix  obs_c_waa(1,myrs,1,nages);
     init_matrix  obs_seine_comp(1,myrs,1,nages);
     init_matrix  obs_mat_comp(1,myrs,1,nages);

                
     vector  tot_obs_aerial_tons(1,myrs)
     vector  tot_obs_aerial_tuned_tons(1,myrs)
  // |--------------------------------------------------------------------------|
  // | END OF FILE MARKER                                                       |
  // |--------------------------------------------------------------------------|
     init_number eof2


 LOCAL_CALCS

    if(eof2==42) cout << BaseFileName<<".dat has been read correctly!"<<endl;
    else 
    {       
         cout <<"|----------------------------------------------------------------------|"<<endl;   
         cout <<"|   ** Red alert! Captain to bridge! The .dat file is compromised! **  |"<<endl;
         cout <<"|----------------------------------------------------------------------|"<<endl; 
	 cout <<"|      Last integer read is "<<eof2<<", but the file *should* end with 42      |"<<endl;
         cout <<"| Please check the .dat file for errors and make sure the above calls  |"<<endl;
         cout <<"|              are matched exactly by the file's contents              |"<<endl;
         cout <<"|----------------------------------------------------------------------|"<<endl;
    exit(1); 
    }



     for (int i=1;i<=myrs;i++)
       {
     if (tot_obs_aerial(i)<0)
       {
     tot_obs_aerial_tons(i)=0;
       }
     else
       {
     tot_obs_aerial_tons(i)=tot_obs_aerial(i)*2204.62/2000;
       }
       }

     for (int i=1;i<=myrs;i++)
       {
     if (tot_obs_aerial_tuned(i)<0)
       {
     tot_obs_aerial_tuned_tons(i)=0;
       }
     else
       {
     tot_obs_aerial_tuned_tons(i)=tot_obs_aerial_tuned(i)*2204.62/2000;
       }
       }
 END_CALCS


  // |--------------------------------------------------------------------------|
  // | MODEL DATA FROM CONTROL FILE                                             |
  // |--------------------------------------------------------------------------|
  // | This calls the control file
  // | This file controls model years, estimation phases, blocks for
  // | selectivity, maturity, and mortality (and fecundity if needed)
  // | and anything else that is NOT observed data (catch, weight, eggs, etc.)

  !! ad_comm::change_datafile_name(ControlFile);
  

  // |--------------------------------------------------------------------------|
  // | ESTIMATION PHASES                                                        |
  // |--------------------------------------------------------------------------|
  // |
  // | These govern the phases in which given parameters are estimated.
  // | While these should likely not need adjusting, if you encounter problems,
  // | you might explore some changes. A parameter whose estimation phase
  // | is > 1 remains at its starting value for all phases < estimation phase.
  // | A parameter with a negative phase is not estimated.
  // |
  // | Phase 1: -ph_Int    -> initial population
  // |          -ph_S      -> natural mortality
  // |          -ph_mat_a  -> maturity inflection
  // |          -ph_gs_a   -> gear selectivity inflection
  // |          -ph_gs_b   -> gear selectivity slope
  // | Phase 2: -ph_mat_b  -> maturity slope
  // | Phase 3: -ph_Rec    -> recruitment (age 3)
  // |          -ph_Ric    -> Ricker function
  // |          -ph_md    -> mile-days  coefficient

  init_number ph_Int
  init_number ph_S
  init_number ph_mat_a
  init_number ph_gs_a
  init_number ph_gs_b
  init_number ph_mat_b
  init_number ph_Rec
  init_number ph_Ric
  init_number ph_md		


  // |--------------------------------------------------------------------------|
  // | OBJECTIVE FUNCTION WEIGHTS                                               |
  // |--------------------------------------------------------------------------|
  // |//overall weight of dataset

  init_number lR                          //Purse Seine--catcha ge composition
  init_number lM                          //Total Run--mature age composition
  init_number lA                          //aerial survey

     //weights on yearly data
  init_vector wt_aerial(1,dyrs)          //aerial survey       
  init_vector wt_mat(1,dyrs)             //total run--mature age composition
  

  // |--------------------------------------------------------------------------|
  // | END OF FILE MARKER                                                       |
  // |--------------------------------------------------------------------------|
  init_number eof1


 LOCAL_CALCS

    if(eof1==42) cout << BaseFileName<<".ctl has been read correctly!"<<endl;
    else 
    {    
         cout <<"|----------------------------------------------------------------------|"<<endl;   
         cout <<"|      Red alert! Captain to bridge! The .ctl file is compromised!     |"<<endl;
         cout <<"|----------------------------------------------------------------------|"<<endl; 
	 cout <<"|      Last integer read is "<<eof1<<", but the file *should* end with 42      |"<<endl;
         cout <<"| Please check the .ctl file for errors and make sure the above calls  |"<<endl;
         cout <<"|              are matched exactly by the file's contents              |"<<endl;
         cout <<"|----------------------------------------------------------------------|"<<endl;
    exit(1); 
    }


 END_CALCS

   !! ad_comm::change_datafile_name(LoopFile);
  
  // |--------------------------------------------------------------------------|
  // | ARRAY LOOP INDEXING                                                      |
  // |--------------------------------------------------------------------------|
  // | 
  // | These are the points at which the model allows natural mortality (M),
  // | maturity-at-age (mat), gear selectivity-at-age (gs) to change based on
  // | climate changes indicated by shifts in the Pacific Decadal Oscillation. 
  // | Fecundity, at this point, remains stable with one estimate 
  // |  
  // | -mat_Bk     ->  number of maturity blocks (1 split = 2 blocks)
  // | -mat_Bk_Yrs ->  specific years in which maturity-at-age changes
 

  init_number mat_Bk
  init_vector mat_Bk_Yrs(1,mat_Bk+1)
  vector mat_Bk_Idx(1,mat_Bk+1)



  // |--------------------------------------------------------------------------|
  // | END OF FILE MARKER                                                       |
  // |--------------------------------------------------------------------------|
  init_number eof4

 LOCAL_CALCS

    if(eof1==42) cout << BaseFileName<<".ctl has been read correctly!"<<endl;
    else 
    {    
         cout <<"|----------------------------------------------------------------------|"<<endl;   
         cout <<"|      Red alert! Captain to bridge! The loop.ctl file is compromised!     |"<<endl;
         cout <<"|----------------------------------------------------------------------|"<<endl; 
	 cout <<"|      Last integer read is "<<eof4<<", but the file *should* end with 42      |"<<endl;
         cout <<"| Please check the .ctl file for errors and make sure the above calls  |"<<endl;
         cout <<"|              are matched exactly by the file's contents              |"<<endl;
         cout <<"|----------------------------------------------------------------------|"<<endl;
    exit(1); 
    }



   // | The lines below populate the indices for fecundity, mortality,
   // | selectivity and maturity



   for (int i=1;i<=mat_Bk+1;i++)
     {
       mat_Bk_Idx(i)=mat_Bk_Yrs(i)-mod_syr+1;
     }



 END_CALCS

PARAMETER_SECTION

  // |---------------------------------------------------------------------------------|
  // | INITIAL POPULATION PARAMETERS
  // |---------------------------------------------------------------------------------|
  // | 
  // |- initial age 3 abundance
  // |- initial population abundance (ages 4 - 12+)
	
     init_bounded_vector init_age_4(1,myrs,5,2500,ph_Rec)
     init_bounded_vector init_pop(1,8,1,2200,ph_Int)


  // |---------------------------------------------------------------------------------|
  // | SELECTIVITY  PARAMETERS
  // |---------------------------------------------------------------------------------|
  // | 
  // |- age at 50% selectivity
  // |- selectivity-at-age slope
  // |
  // | - Note that there are THREE selectivity values: early, late, and seine
  // |   seine selectivity is constant over all years, varying by age
  // |   early-late fishery selectivities change in 1993

     init_bounded_vector mat_a(1,mat_Bk,5,7,ph_mat_a)
     init_bounded_vector mat_b(1,mat_Bk,0,2,ph_mat_b)
     matrix maturity(1,myrs,1,nages)

     init_bounded_number gs_seine_a(5,7,ph_gs_a)
     init_bounded_number gs_seine_b(0,2,ph_gs_b)
     vector GS_seine(1,nages)


  // |---------------------------------------------------------------------------------|
  // | Summations of estimated catch at age
  // |  AC56:AC93
  // |  AD56:AD93
  // |---------------------------------------------------------------------------------|
  // | 
  // |- Inter-Med. Total
  // |- Est. Total Catch x 106 

     matrix sel_naa(1,myrs,1,nages);
     matrix mat_naa(1,myrs,1,nages)

     vector tot_sel_N(1,myrs)
     vector tot_mat_N(1,myrs)

     matrix sel_baa(1,myrs,1,nages)
     vector tot_sel_B(1,myrs)

    

  // |---------------------------------------------------------------------------------|
  // | ESTIMATED AND DERIVED POPULATION MATRICES
  // |---------------------------------------------------------------------------------|
  // |- tot_post_N   total population [mature+ immature] - catch [millions]
  // |- N            total abundance (mature + immature)         [millions]
  // |- tot_sp_N     total spawning abundance                    [millions]
  // |- est_sp_naa     spawning numbers-at-age[millions]
  // |- tot_mat_B     tota mature biomass [tonnes]
     init_bounded_number max_Sur(0.5,1)
     init_bounded_number slope(0.01,1)
     vector Sur(1,nages)
     number S_for
     
     matrix est_mat_baa(1,myrs,1,nages)
     vector tot_mat_B(1,myrs)
     vector tot_mat_B_tons(1,myrs)
     matrix naa(1,myrs,1,nages)
     
     matrix post_naa(1,myrs,1,nages)
     matrix est_seine_comp(1,myrs,1,nages)
     matrix est_seine_naa(1,myrs,1,nages)  
     matrix est_mat_comp(1,myrs,1,nages) 
     matrix est_catch_comp(1,myrs,1,nages)
     matrix est_tot_catch(1,myrs,1,nages)
     matrix est_sp_naa(1,myrs,1,nages)
     vector tot_sp_N(1,myrs)  
     vector tot_post_N(1,myrs)
     vector N(1,myrs)

// |---------------------------------------------------------------------------------|
  // | FORECAST QUANTITIES
  // |---------------------------------------------------------------------------------|
  // | 
  // |- for_naa         forecast numbers-at-age  [mature + immature]       [millions]
  // |- for_mat_naa     forecast mature numbers-at-age                     [millions]
  // |- for_mat_baa     forecast mature biomass-at-age                     [metric tons]  
  // |- for_mat_prop    forecast mature proportion-at-age [by number]      [proportion]
  // |- for_mat_b_prop  forecast mature proportion-at-age [by biomass]      [proportion]
  // |- for_mat_B       total forecast mature biomass                      [metric tons]
  // |- for_mat_B_st    total forecast mature biomass            [short dweeby US tons]  
  // |- for_tot_mat_N   total mature numbers-at-age                   
  // |- HR              harvest rate                                 
  // |- HR_p            harvest rate sliding proportion               
  // |- GHL             general harvest limit                         

  vector for_naa(1,nages)
  //vector sortx(1,nages)
  vector for_mat_naa(1,nages)        
  vector for_mat_baa(1,nages)      
  vector for_mat_prop(1,nages)
  vector for_mat_b_prop(1,nages)
  number for_mat_B                  
  number for_mat_B_st		  
  number for_tot_mat_N
                 


   // |---------------------------------------------------------------------------------|
  // | GRAPHICAL CONSTRUCTS
  // |---------------------------------------------------------------------------------|
  // | 
  // |- These matrices are read in R for standardized graphical analyses and figures
  // |- FIGDATA
  // |- FIGDATAAGE
  // |- FIGDATA2

   matrix FIGDATA(1,myrs,1,46)
   matrix FIGDATAAGE(1,nages,1,5)

  // |---------------------------------------------------------------------------------|
  // | OBJECTIVE FUNCTION COMPONENTS
  // |---------------------------------------------------------------------------------|
  // | 
  // |* Residuals *
  // |- catch age composition      
  // |- spawner age composition
  // |- egg deposition
  // |- spawner-recruit function
  // |
  // |* Sums of squares *
  // |- catch age composition
  // |- spawner age composition
  // |- weighted egg deposition vector
  // |- egg deposition
  // |- spawner-recruit
  // |- Mile-days of milt vector
  // |- MD SSM
  // |
  // |- ADMB minimization target f

  matrix res_c_comp(1,myrs,1,nages);
  matrix res_mat_comp(1,myrs,1,nages);
  vector res_aerial(1,myrs);
  
  number Purse_Seine;
  number Total_Run;
  number Aerial_Biomass;


          

  objective_function_value f;




PRELIMINARY_CALCS_SECTION

         mat_a(1)=6;
         mat_a(2)=6;
         mat_b(1)=1.2;
         mat_b(2)=1.1;
         gs_seine_a=6;
         gs_seine_b=1;

         init_age_4(1)=	820.29;
         init_age_4(2)=	820.29;
         init_age_4(3)=	820.29;
         init_age_4(4)= 325.86;
         init_age_4(5)=	92.36;
         init_age_4(6)=	207.91;
         init_age_4(7)=	41.87;
         init_age_4(8)=	173.60;
         init_age_4(9)=	150.15;
         init_age_4(10)=45.15;
         init_age_4(11)=84.02;
         init_age_4(12)=426.13;
         init_age_4(13)=298.21;
         init_age_4(14)=141.24;
         init_age_4(15)=153.80;
         init_age_4(16)=162.43;
         init_age_4(17)=120.8;
         init_age_4(18)=212.98;
         init_age_4(19)=44.04;
         init_age_4(20)=51.59;
         init_age_4(21)=278.19;
         init_age_4(22)=410.2;
         init_age_4(23)=185.27;
         init_age_4(24)=65.94;
         init_age_4(25)=63.06;
         init_age_4(26)=139.82;
         init_age_4(27)=130.66;
         init_age_4(28)=124.13;
         init_age_4(29)=209.88;
         init_age_4(30)=355.12;
         init_age_4(31)=256.23;
         init_age_4(32)=201.13;
         init_age_4(33)=95.07;
         init_age_4(34)=96.37;
         init_age_4(35)=111.46;
         init_age_4(36)=111.46;

    init_pop(1) = 1021;
    init_pop(2) = 50;
    init_pop(3) = 24;
    init_pop(4) = 59;
    init_pop(5) = 23;
    init_pop(6) = 4;
    init_pop(7) = 2;
    init_pop(8) = 2;
    

PROCEDURE_SECTION

  get_parameters();
  Time_Loop();
  get_residuals();
  evaluate_the_objective_function();
  if(last_phase())
    {
      get_forecast();
    } 

   if(sd_phase())
    {
     get_FIGDATA();
     output_FIGDATA();
     get_FIGDATAAGE();
     output_FIGDATAAGE();
     get_report();
    }

  if(mceval_phase())
    {
     evalout<<for_mat_B_st<<" "
          <<init_age_4<<" "
          <<init_pop<<" "<<endl;
    }

FUNCTION get_parameters

  maturity.initialize();
  GS_seine.initialize();
  Sur.initialize();
  S_for.initialize();

  // Seine fishery-unconstrained then fix at age 9
   for (int j=1;j<=5;j++)
     {
            GS_seine(j)=1/(1+exp(-1.0*gs_seine_b*((j+3)-gs_seine_a)));
  
    for (int j=6;j<=nages;j++) 
      {
           GS_seine(j)=1;
           }
           }
  // Early late Maturity time periods &  fix 8+=1

  for (int t=1;t<=mat_Bk;t++)
  {
    for (int i=mat_Bk_Idx(t);i<=mat_Bk_Idx(t+1);i++)
       {
         for (int j=1;j<=nages;j++)
          {
          if (j<=4)
          {
            maturity(i,j)=1/(1+exp(-1.0*mat_b(t)*((j+2)-mat_a(t))));
          }
          else
          {
          maturity(i,j)=1;
          }
       }
   }
  }         
  //Survival
  Sur = max_Sur;
  S_for = max_Sur;


FUNCTION Time_Loop

  naa.initialize();
  est_mat_comp.initialize();
  mat_naa.initialize();
  sel_naa.initialize();
  tot_sel_N.initialize();
  est_seine_comp.initialize();
  est_mat_comp.initialize();
  



  //----------------------------------------------------------------------------
  // YEAR ONE
  //----------------------------------------------------------------------------

  for(int i=1;i<=1;i++)
   {
        naa(i,1)=init_age_4(i);              //recruitment vector - year 1
     for(int j=2;j<=nages;j++)
       {
 
         naa(i,j)=init_pop(j-1);              //initial population - year 1
       }
   


     for(int j=1;j<=nages;j++)
       {
         sel_naa(i,j)  = naa(i,j) * GS_seine(j);
         mat_naa(i,j)  = naa(i,j) * maturity(i,j); 
       }
   


   tot_sel_N = rowsum(sel_naa);
   tot_mat_N = rowsum(mat_naa);
   


     for(int j=1;j<=nages;j++)
       {
         est_seine_comp(i,j) = sel_naa(i,j)/tot_sel_N(i);
         est_mat_comp(i,j)   = mat_naa(i,j)/tot_mat_N(i);
       }
   
  


     for(int j=1;j<=nages;j++)
       {
         sel_baa(i,j) = obs_c_waa(i,j) * est_seine_comp(i,j);
       }
   

   
   tot_sel_B = rowsum(sel_baa);
  


     for(int j=1;j<=nages;j++)
       {
         est_seine_naa(i,j) = (tot_obs_catch(i) / tot_sel_B(i))*est_seine_comp(i,j);
       }
   

   for(int j=1;j<=nages;j++)
     {
       post_naa(i,j)=naa(i,j)-obs_catch_naa(i,j)-(est_seine_naa(i,j)); //numbers - catch
     }
   }


  //----------------------------------------------------------------------------
  // END FIRST YEAR LOOP
  //----------------------------------------------------------------------------


  //----------------------------------------------------------------------------
  // ALL OTHER YEARS
  //----------------------------------------------------------------------------


  for(int i=2;i<=myrs;i++)
    {
    
    for(int j=2;j<=nages;j++)
      {
      naa(i,1)=init_age_4(i);
      naa(i,j)=post_naa(i-1,j-1)*Sur(j-1);  //naa: (numbers-catch)*survival
      }
      
    for(int j=nages;j<=nages;j++)
      {
        naa(i,j)=post_naa(i-1,j-1)*Sur(j-1)+post_naa(i-1,j)*Sur(j); //+ class, naa
      }



     for(int j=1;j<=nages;j++)
       {
         sel_naa(i,j)  = naa(i,j) * GS_seine(j);//naa vulnerable to gear
         mat_naa(i,j)  = naa(i,j) * maturity(i,j); 
       }
       


   tot_sel_N = rowsum(sel_naa);//total selected by gear (abundance(
   tot_mat_N = rowsum(mat_naa);//total mature abundance
   


     for(int j=1;j<=nages;j++)
       {
         est_seine_comp(i,j) = sel_naa(i,j)/tot_sel_N(i);//prop. at age; gear
         est_mat_comp(i,j)   = mat_naa(i,j)/tot_mat_N(i);
       }
   



     for(int j=1;j<=nages;j++)
       {
         sel_baa(i,j) = obs_c_waa(i,j) * est_seine_comp(i,j);
       }
   

   
   tot_sel_B = rowsum(sel_baa);
  


     for(int j=1;j<=nages;j++)
       {
         est_seine_naa(i,j) = (tot_obs_catch(i) / tot_sel_B(i))*est_seine_comp(i,j);
       }
   

   for(int j=1;j<=nages;j++)
     {
        post_naa(i,j)=naa(i,j)-obs_catch_naa(i,j)-(est_seine_naa(i,j)); //numbers - catch//post fishery abundance
     }
   }
   
    N=rowsum(naa);                  // total abundance (millions)
    tot_post_N = rowsum(post_naa);  // total abundance [numbers - catch] (millions)

   for(int i=1;i<=myrs;i++)
     {
       for(int j=1;j<=nages;j++)
         {
           est_mat_baa(i,j) = naa(i,j) * maturity(i,j) * obs_c_waa(i,j);
         }
     }

  tot_mat_B = rowsum(est_mat_baa);//total mature biomass (tonnes)
  tot_mat_B_tons = tot_mat_B*2204.62/2000;//total mature biomass (tons)


  //----------------------------------------------------------------------------
  // SPAWNERS & MATURE
  //----------------------------------------------------------------------------
//added this section 3/17/2017 (not sure if correct
 for (int i=1;i<=myrs;i++)
    {
      
      for(int j=1;j<=nages;j++)
        {
          est_sp_naa(i,j)=(maturity(i,j)*naa(i,j))-est_seine_naa(i,j)-obs_catch_naa(i,j);          //spawning numbers-at-age (differs for stocks) For Craig should be Mat *(naa-est_c_naa)
        }}

    tot_sp_N=rowsum(est_sp_naa);                                       //total spawning numbers
  

 
FUNCTION get_residuals

  res_c_comp.initialize();
  res_mat_comp.initialize();
  res_aerial.initialize();



  //----------------------------------------------------------------------------
  // CATCH AGE COMPOSITION--Purse Seine
  //----------------------------------------------------------------------------

  for (int i=1;i<=myrs;i++) 
    {
      for (int j=1;j<=nages;j++)
        {
               res_c_comp(i,j)=obs_seine_comp(i,j)-est_seine_comp(i,j);
             }
        }
   

  //----------------------------------------------------------------------------
  // MATURE AGE COMPOSITION--Total Run
  //----------------------------------------------------------------------------

  for (int i=1;i<=myrs;i++)
    {
     for (int j=1;j<=nages;j++)
       {
            
              res_mat_comp(i,j)=(obs_mat_comp(i,j)-est_mat_comp(i,j))*wt_mat(i);
            
       }
    }



  //----------------------------------------------------------------------------
  // AERIAL SURVEY
  //----------------------------------------------------------------------------

  for (int i=1;i<=myrs;i++) 
    {
          if (tot_obs_aerial(i)<0)
            {
              res_aerial(i)=0;
            }
          else
            {
              res_aerial(i)=(log(tot_obs_aerial(i))-log(tot_mat_B(i))) * wt_aerial(i);
            }
        }




  //WSSQM=sum(wSSQM);
  Purse_Seine  = lR*norm2(res_c_comp);
  Total_Run = lM*norm2(res_mat_comp);
  Aerial_Biomass = lA*norm2(res_aerial);


FUNCTION evaluate_the_objective_function

  f=Purse_Seine+Total_Run+Aerial_Biomass;

FUNCTION get_forecast

  for (int j=1;j<=1;j++)
  {
     for_naa(j)=(naa(myrs,j)+naa(myrs-1,j)+naa(myrs-2,j)+naa(myrs-3,j)+naa(myrs-4,j)+naa(myrs-5,j)+naa(myrs-6,j)+naa(myrs-7,j)+naa(myrs-8,j)+naa(myrs-9,j))/10; //forecast age 4 numbers;mean last 10 yrs
      // sortx(j)=sort(naa(i,j));
      //  for_naa(j) = sortx(10/2+1);      

     
  }
  for (int j=2;j<=nages-1;j++)
    {
      for_naa(j)=post_naa(myrs,j-1)*S_for;                           //forecast naa, ages 5 - 11
    }

  for (int j=nages;j<=nages;j++)
    {
      for_naa(j)=post_naa(myrs,j-1)*S_for+post_naa(myrs,j)*S_for;    //forecast naa, age 12+
    }


  for (int j=1;j<=nages;j++)
    {
      for_mat_naa(j)=for_naa(j)*maturity(myrs,j);    //forecast mature numbers at age
    }

  for_tot_mat_N=sum(for_mat_naa);

  for (int j=1;j<=nages;j++)
    {
      for_mat_baa(j)=for_mat_naa(j)*fw_a_a(j);  //forecast mature biomass at age
    }

  for_mat_B=sum(for_mat_baa);

  for (int j=1;j<=nages;j++)
    {
      for_mat_prop(j)=for_mat_naa(j)/for_tot_mat_N;  //forecast % mature at age
    }



  for (int j=1;j<=nages;j++)
    {
      for_mat_b_prop(j) = for_mat_baa(j)/for_mat_B;  //forecast % mature at age biomass
    }

  for_mat_B_st=for_mat_B*2204.62/2000;                   //RETURN TO SHORT TONS

FUNCTION get_FIGDATA
  FIGDATA.initialize();
  for (int i=1;i<=myrs;i++){
  for (int j=1;j<=1;j++){FIGDATA(i,j)=tot_mat_B_tons(i);}// total mature biomass (tons) (Figure 1)
  for (int j=2;j<=2;j++){FIGDATA(i,j)=tot_obs_aerial_tons(i);}//total observed aerial biomass (tons) (Figure 1)
  for (int j=3;j<=3;j++){FIGDATA(i,j)=res_aerial(i);}//aerial survey residuals (Figure 4)
  for (int j=4;j<=4;j++){FIGDATA(i,j)=init_age_4(i);}//age-3 recruit strength (Figure 5)
  for (int j=5;j<=13;j++){FIGDATA(i,j)=est_seine_comp(i,j-4);}//proportion of N selected by gear (estimated) (Figure 8)
  for (int j=14;j<=22;j++){FIGDATA(i,j)=obs_seine_comp(i+md_offset,j-13);}//observed catch compostion (Figure 8)
  for (int j=23;j<=31;j++){FIGDATA(i,j)=est_mat_comp(i,j-22);}//estimated mature  age composition (Figure 9)
  for (int j=32;j<=40;j++){FIGDATA(i,j)=obs_mat_comp(i+md_offset,j-31);}//observed mature  age composition (Figure 9)
  for (int j=41;j<=41;j++){FIGDATA(i,j)=tot_post_N(i);}// total population [mature+ immature] - catch [millions](Figure 6)    
  for (int j=42;j<=42;j++){FIGDATA(i,j)=N(i);}// total abundance (mature + immature [millions] (Figure 6)
  for (int j=43;j<=43;j++){FIGDATA(i,j)=tot_sp_N(i);} // total spawning abundance [millions](Figure 6)
  for (int j=44;j<=44;j++){FIGDATA(i,j)=tot_mat_N(i);} // total mature abundance[millions] (Figure 6)
  for (int j=45;j<=45;j++){FIGDATA(i,j)=tot_obs_aerial_tuned_tons(i);} // total observed aerial biomass-tuned to model (tons) (Figure 1)
  for (int j=46;j<=46;j++){FIGDATA(i,j)=threshold(i);} // threshold
  }

FUNCTION output_FIGDATA

 ofstream figdata("FIGDATA.dat");
 figdata<<"tot_mat_B_tons tot_obs_aerial_tons res_aerial init_age_4 est_seine_comp4 est_seine_comp5 est_seine_comp6 est_seine_comp7 est_seine_comp8 est_seine_comp9 est_seine_comp10 est_seine_comp11 est_seine_comp12 obs_seine_comp4 obs_seine_comp5 obs_seine_comp6 obs_seine_comp7 obs_seine_comp8 obs_seine_comp9 obs_seine_comp10 obs_seine_comp11 obs_seine_comp12 est_mat_comp4 est_mat_comp5 est_mat_comp6 est_mat_comp7 est_mat_comp8 est_mat_comp9 est_mat_comp10 est_mat_comp11 est_mat_comp12 obs_mat_comp4 obs_mat_comp5 obs_mat_comp6 obs_mat_comp7 obs_mat_comp8 obs_mat_comp9 obs_mat_comp10 obs_mat_comp11 obs_mat_comp12 tot_post_N N tot_sp_N tot_mat_N tot_obs_aerial_tuned_tons threshold"<<endl;
 figdata<<FIGDATA<<endl;

FUNCTION get_FIGDATAAGE
  FIGDATAAGE.initialize();
  for (int i=1;i<=nages;i++){
 //Gear_Selectivity
  for (int j=1;j<=1;j++){FIGDATAAGE(i,j)=GS_seine(i);}
 //Survival
  for (int j=2;j<=2;j++){FIGDATAAGE(i,j)=Sur(i);}
 //Mature biomass at age (forecasted; metric tons)
  for (int j=3;j<=3;j++){FIGDATAAGE(i,j)=for_mat_baa(i);}
 //Mature biomass at age (forecasted; metric tons)
  for (int j=4;j<=4;j++){FIGDATAAGE(i,j)=for_mat_prop(i);}
 //Forecasted weight at age
  for (int j=5;j<=5;j++){FIGDATAAGE(i,j)=fw_a_a(i);}}
FUNCTION output_FIGDATAAGE

 ofstream figdataage("FIGDATAAGE.dat");
 figdataage<<"GS_seine Survival for_mat_baa for_mat_prop fw_a_a"<<endl;
 figdataage<<FIGDATAAGE<<endl;
 
FUNCTION get_report
       ofstream Report("Report (Togiak Stock).csv");

    int vsize = Year.size();

    Report << "MODEL RESULTS" <<endl;
 
    Report<<"Objective function value:"<<","<<f<<endl;
    Report<<"  "<<endl;

    Report<<"Dataset Components:"<<endl;
    Report<<"Catch SSQ"<<","<<Purse_Seine<<endl;
    Report<<"Total Run"<<","<<Total_Run<<endl;
    Report<<"Aerial Biomass"<<","<<Aerial_Biomass<<endl;
    Report<<"  "<<endl;
    Report<<"  "<<endl;
   
    Report<<"FORECAST INFORMATION:"<<endl;
    Report<<"Mature Biomass Forecast (tons)"<<","<<for_mat_B_st<<endl;
    Report<<"Mature Biomass Forecast (tonnes)"<<","<<for_mat_B<<endl;
    Report<<"Mature Numbers-at-age (millions)"<<","<<for_tot_mat_N<<endl;
    Report<<"  "<<endl;
    Report<<","<<"Age 4"<<","<<"Age 5"<<","<<"Age 6"<<","<<"Age 7"<<","<<"Age 8"<<","<<"Age 9 "<<","<<"Age 10"<<","<<"Age 11"<<","<<"Age 12+"<<endl;
    Report<<"Forecast numbers-at-age (millions)"<<","<<for_naa[1]<<","<<for_naa[2]<<","<<for_naa[3]<<","<<for_naa[4]<<","<<for_naa[5]<<","<<for_naa[6]<<","<<for_naa[7]<<","<<for_naa[8]<<","<<for_naa[9]<<endl;
    Report<<"Forecast mature numbers-at-age (millions)"<<","<<for_mat_naa[1]<<","<<for_mat_naa[2]<<","<<for_mat_naa[3]<<","<<for_mat_naa[4]<<","<<for_mat_naa[5]<<","<<for_mat_naa[6]<<","<<for_mat_naa[7]<<","<<for_mat_naa[8]<<","<<for_mat_naa[9]<<endl;
    Report<<"Forecast mature biomass-at-age (metric tonnes)"<<","<<for_mat_baa[1]<<","<<for_mat_baa[2]<<","<<for_mat_baa[3]<<","<<for_mat_baa[4]<<","<<for_mat_baa[5]<<","<<for_mat_baa[6]<<","<<for_mat_baa[7]<<","<<for_mat_baa[8]<<","<<for_mat_baa[9]<<endl;
    Report<<"Forecast mature prop. at age (by number)"<<","<<for_mat_prop[1]<<","<<for_mat_prop[2]<<","<<for_mat_prop[3]<<","<<for_mat_prop[4]<<","<<for_mat_prop[5]<<","<<for_mat_prop[6]<<","<<for_mat_prop[7]<<","<<for_mat_prop[8]<<","<<for_mat_prop[9]<<endl;
    Report<<"Forecast mature prop. at age (by biomass)"<<","<<for_mat_b_prop[1]<<","<<for_mat_b_prop[2]<<","<<for_mat_b_prop[3]<<","<<for_mat_b_prop[4]<<","<<for_mat_b_prop[5]<<","<<for_mat_b_prop[6]<<","<<for_mat_b_prop[7]<<","<<for_mat_b_prop[8]<<","<<for_mat_b_prop[9]<<endl;


    Report<<"tot_sel_N:"<<","<<"pre-fishery numbers (naa) x gear selectivity; total abundance selected by gear (millions)"<<endl;
    Report<<"tot_mat_N:"<<","<<"Total mature abundance (millions)"<<endl;
    Report<<"tot_sel_B:"<<","<<"Observed weight-at-age x estimated age composition of catch"<<endl;
    Report<<"init_age_4:"<<","<<"Mature and immature age-3 abundance (recruitment in milllions)"<<endl;
    Report<<"tot_sp_N:"<<","<<"Total spawning abundance (millions)"<<endl;
    Report<<"tot_obs_catch:"<<","<<"Total observed catch (tonnes)"<<endl;
    Report<<"tot_obs_aerial_tons:"<<","<<"Observed aerial biomass (tons)"<<endl;
    Report<<"N:"<<","<<"Pre-fishery total abundance (millions)"<<endl;
    Report<<"tot_mat_B_tons:"<<","<<"Total mature biomass (tons)"<<endl;
    Report<<"tot_post_N:"<<","<<"Post fishery total abundance (millions)"<<endl;

    Report<<"Year"<<","<<"tot_sel_N"<<","<<"tot_mat_N"<<","<<"tot_sel_B"<<","<<"init_age_4"<<","<<"tot_sp_N"<<","<<"tot_obs_catch"<<","<<"tot_obs_aerial_tons"<<","<<"N"<<","<<"tot_mat_B_tons"<<","<<"tot_post_N"<<endl;
    for(int n; n<=vsize-2; n++)
    Report<<Year[n+mod_syr]<<","<<tot_sel_N[n+1]<<","<<tot_mat_N[n+1]<<","<<tot_sel_B[n+1]<<","<<init_age_4[n+1]<<","<<tot_sp_N[n+1]<<","<<tot_obs_catch[n+1]<<","<<tot_obs_aerial_tons[n+1]<<","<<N[n+1]<<","<<tot_mat_B_tons[n+1]<<","<<tot_post_N[n+1]<<endl;
    Report<<"  "<<endl;

    Report<<","<<"Age 4"<<","<<"Age 5"<<","<<"Age 6"<<","<<"Age 7"<<","<<"Age 8"<<","<<"Age 9 "<<","<<"Age 10"<<","<<"Age 11"<<","<<"Age 12+"<<endl;
    Report<<"Survival"<<","<<Sur[1]<<","<<Sur[2]<<","<<Sur[3]<<","<<Sur[4]<<","<<Sur[5]<<","<<Sur[6]<<","<<Sur[7]<<","<<Sur[8]<<","<<Sur[9]<<endl;
    Report<<"  "<<endl;

    Report<<","<<"Age 4"<<","<<"Age 5"<<","<<"Age 6"<<","<<"Age 7"<<","<<"Age 8"<<","<<"Age 9 "<<","<<"Age 10"<<","<<"Age 11"<<","<<"Age 12+"<<endl;
    Report<<"Gear Selectivity"<<","<<GS_seine[1]<<","<<GS_seine[2]<<","<<GS_seine[3]<<","<<GS_seine[4]<<","<<GS_seine[5]<<","<<GS_seine[6]<<","<<GS_seine[7]<<","<<GS_seine[8]<<","<<GS_seine[9]<<endl;
    Report<<"  "<<endl;

    Report<<"Maturity"<<endl;
    Report<<"Year"<<","<<"Age 4"<<","<<"Age 5"<<","<<"Age 6"<<","<<"Age 7"<<","<<"Age 8"<<","<<"Age 9 "<<","<<"Age 10"<<","<<"Age 11"<<","<<"Age12+"<<endl;
    for(int n; n<=vsize-2; n++)
    Report<<Year[n+mod_syr]<<","<<maturity(n+1,1)<<","<<maturity(n+1,2)<<","<<maturity(n+1,3)<<","<<maturity(n+1,4)<<","<<maturity(n+1,5)<<","<<maturity(n+1,6)<<","<<maturity(n+1,7)<<","<<maturity(n+1,8)<<","<<maturity(n+1,9)<<endl;
    Report<<"  "<<endl;
  
    Report<<"Pre-fishery total abundance (millions); naa"<<endl;
    Report<<"Year"<<","<<"Age 4"<<","<<"Age 5"<<","<<"Age 6"<<","<<"Age 7"<<","<<"Age 8"<<","<<"Age 9 "<<","<<"Age 10"<<","<<"Age 11"<<","<<"Age 12+"<<endl;
    for(int n; n<=vsize-2; n++)
    Report<<Year[n+mod_syr]<<","<<naa(n+1,1)<<","<<naa(n+1,2)<<","<<naa(n+1,3)<<","<<naa(n+1,4)<<","<<naa(n+1,5)<<","<<naa(n+1,6)<<","<<naa(n+1,7)<<","<<naa(n+1,8)<<","<<naa(n+1,9)<<endl;
    Report<<"  "<<endl;

    Report<<"Post-fishery total abundance (millions); post_naa"<<endl;
    Report<<"Year"<<","<<"Age 4"<<","<<"Age 5"<<","<<"Age 6"<<","<<"Age 7"<<","<<"Age 8"<<","<<"Age 9 "<<","<<"Age 10"<<","<<"Age 11"<<","<<"Age 12+"<<endl;
    for(int n; n<=vsize-2; n++)
    Report<<Year[n+mod_syr]<<","<<post_naa(n+1,1)<<","<<post_naa(n+1,2)<<","<<post_naa(n+1,3)<<","<<post_naa(n+1,4)<<","<<post_naa(n+1,5)<<","<<post_naa(n+1,6)<<","<<post_naa(n+1,7)<<","<<post_naa(n+1,8)<<","<<post_naa(n+1,9)<<endl;
    Report<<"  "<<endl;

    Report<<"Mature numbers-at-age (pre-fishery); mat_naa"<<endl;
    Report<<"Year"<<","<<"Age 4"<<","<<"Age 5"<<","<<"Age 6"<<","<<"Age 7"<<","<<"Age 8"<<","<<"Age 9 "<<","<<"Age 10"<<","<<"Age 11"<<","<<"Age 12+"<<endl;
    for(int n; n<=vsize-2; n++)
    Report<<Year[n+mod_syr]<<","<<mat_naa(n+1,1)<<","<<mat_naa(n+1,2)<<","<<mat_naa(n+1,3)<<","<<mat_naa(n+1,4)<<","<<mat_naa(n+1,5)<<","<<mat_naa(n+1,6)<<","<<mat_naa(n+1,7)<<","<<mat_naa(n+1,8)<<","<<mat_naa(n+1,9)<<endl;
    Report<<"  "<<endl;

    Report<<"Pre-fishery total abundance x gear selectivity; sel_naa"<<endl;
    Report<<"Year"<<","<<"Age 4"<<","<<"Age 5"<<","<<"Age 6"<<","<<"Age 7"<<","<<"Age 8"<<","<<"Age 9 "<<","<<"Age 10"<<","<<"Age 11"<<","<<"Age 12+"<<endl;
    for(int n; n<=vsize-2; n++)
    Report<<Year[n+mod_syr]<<","<<sel_naa(n+1,1)<<","<<sel_naa(n+1,2)<<","<<sel_naa(n+1,3)<<","<<sel_naa(n+1,4)<<","<<sel_naa(n+1,5)<<","<<sel_naa(n+1,6)<<","<<sel_naa(n+1,7)<<","<<sel_naa(n+1,8)<<","<<sel_naa(n+1,9)<<endl;
    Report<<"  "<<endl;

    Report<<"Estimated mature biomass-at-age (tonnes); est_mat_baa"<<endl;
    Report<<"Year"<<","<<"Age 4"<<","<<"Age 5"<<","<<"Age 6"<<","<<"Age 7"<<","<<"Age 8"<<","<<"Age 9 "<<","<<"Age 10"<<","<<"Age 11"<<","<<"Age 12+"<<endl;
    for(int n; n<=vsize-2; n++)
    Report<<Year[n+mod_syr]<<","<<est_mat_baa(n+1,1)<<","<<est_mat_baa(n+1,2)<<","<<est_mat_baa(n+1,3)<<","<<est_mat_baa(n+1,4)<<","<<est_mat_baa(n+1,5)<<","<<est_mat_baa(n+1,6)<<","<<est_mat_baa(n+1,7)<<","<<est_mat_baa(n+1,8)<<","<<est_mat_baa(n+1,9)<<endl;
    Report<<"  "<<endl;
    
    Report<<"obs_c_waa x est_seine_comp; sel_baa"<<endl;
    Report<<"Year"<<","<<"Age 4"<<","<<"Age 5"<<","<<"Age 6"<<","<<"Age 7"<<","<<"Age 8"<<","<<"Age 9 "<<","<<"Age 10"<<","<<"Age 11"<<","<<"Age 12+"<<endl;
    for(int n; n<=vsize-2; n++)
    Report<<Year[n+mod_syr]<<","<<sel_baa(n+1,1)<<","<<sel_baa(n+1,2)<<","<<sel_baa(n+1,3)<<","<<sel_baa(n+1,4)<<","<<est_mat_baa(n+1,5)<<","<<sel_baa(n+1,6)<<","<<sel_baa(n+1,7)<<","<<sel_baa(n+1,8)<<","<<sel_baa(n+1,9)<<endl;
    Report<<"  "<<endl;

    Report<<"Estimated age compostion of catch; est_seine_comp"<<endl;
    Report<<"Year"<<","<<"Age 4"<<","<<"Age 5"<<","<<"Age 6"<<","<<"Age 7"<<","<<"Age 8"<<","<<"Age 9 "<<","<<"Age 10"<<","<<"Age 11"<<","<<"Age 12+"<<endl;
    for(int n; n<=vsize-2; n++)
    Report<<Year[n+mod_syr]<<","<<est_seine_comp(n+1,1)<<","<<est_seine_comp(n+1,2)<<","<<est_seine_comp(n+1,3)<<","<<est_seine_comp(n+1,4)<<","<<est_seine_comp(n+1,5)<<","<<est_seine_comp(n+1,6)<<","<<est_seine_comp(n+1,7)<<","<<est_seine_comp(n+1,8)<<","<<est_seine_comp(n+1,9)<<endl;
    Report<<"  "<<endl;

    Report<<"Estimated mature age compostion of total run (pre-fishery); est_mat_comp"<<endl;
    Report<<"Year"<<","<<"Age 4"<<","<<"Age 5"<<","<<"Age 6"<<","<<"Age 7"<<","<<"Age 8"<<","<<"Age 9 "<<","<<"Age 10"<<","<<"Age 11"<<","<<"Age 12+"<<endl;
    for(int n; n<=vsize-2; n++)
    Report<<Year[n+mod_syr]<<","<<est_mat_comp(n+1,1)<<","<<est_mat_comp(n+1,2)<<","<<est_mat_comp(n+1,3)<<","<<est_mat_comp(n+1,4)<<","<<est_mat_comp(n+1,5)<<","<<est_mat_comp(n+1,6)<<","<<est_mat_comp(n+1,7)<<","<<est_mat_comp(n+1,8)<<","<<est_mat_comp(n+1,9)<<endl;
    Report<<"  "<<endl;

    Report<<"Estimated spawning numbers-at-age (post-fishery); est_sp_naa"<<endl;
    Report<<"Year"<<","<<"Age 4"<<","<<"Age 5"<<","<<"Age 6"<<","<<"Age 7"<<","<<"Age 8"<<","<<"Age 9 "<<","<<"Age 10"<<","<<"Age 11"<<","<<"Age 12+"<<endl;
    for(int n; n<=vsize-2; n++)
    Report<<Year[n+mod_syr]<<","<<est_sp_naa(n+1,1)<<","<<est_sp_naa(n+1,2)<<","<<est_sp_naa(n+1,3)<<","<<est_sp_naa(n+1,4)<<","<<est_sp_naa(n+1,5)<<","<<est_sp_naa(n+1,6)<<","<<est_sp_naa(n+1,7)<<","<<est_sp_naa(n+1,8)<<","<<est_sp_naa(n+1,9)<<endl;
    Report<<"  "<<endl;
    
    Report<<"Pre-fishery age composition residuals; res_mat_comp"<<endl;
    Report<<"Year"<<","<<"Age 4"<<","<<"Age 5"<<","<<"Age 6"<<","<<"Age 7"<<","<<"Age 8"<<","<<"Age 9 "<<","<<"Age 10"<<","<<"Age 11"<<","<<"Age 12+"<<endl;
    for(int n; n<=vsize-2; n++)
    Report<<Year[n+mod_syr]<<","<<res_mat_comp(n+1,1)<<","<<res_mat_comp(n+1,2)<<","<<res_mat_comp(n+1,3)<<","<<res_mat_comp(n+1,4)<<","<<res_mat_comp(n+1,5)<<","<<res_mat_comp(n+1,6)<<","<<res_mat_comp(n+1,7)<<","<<res_mat_comp(n+1,8)<<","<<res_mat_comp(n+1,9)<<endl;
    Report<<"  "<<endl;

    Report<<"Catch-age composition residuals; res_c_comp"<<endl;
    Report<<"Year"<<","<<"Age 4"<<","<<"Age 5"<<","<<"Age 6"<<","<<"Age 7"<<","<<"Age 8"<<","<<"Age 9 "<<","<<"Age 10"<<","<<"Age 11"<<","<<"Age 12+"<<endl;
    for(int n; n<=vsize-2; n++)
    Report<<Year[n+mod_syr]<<","<<res_c_comp(n+1,1)<<","<<res_c_comp(n+1,2)<<","<<res_c_comp(n+1,3)<<","<<res_c_comp(n+1,4)<<","<<res_c_comp(n+1,5)<<","<<res_c_comp(n+1,6)<<","<<res_c_comp(n+1,7)<<","<<res_c_comp(n+1,8)<<","<<res_c_comp(n+1,9)<<endl;
    Report<<"  "<<endl;

    Report.close();
 

RUNTIME_SECTION
  maximum_function_evaluations 5000 5000 5000 5000
  convergence_criteria 0.0001


TOP_OF_MAIN_SECTION
  arrmblsize=5000000;
  gradient_structure::set_MAX_NVAR_OFFSET(5000);
  gradient_structure::set_GRADSTACK_BUFFER_SIZE(800000);
  gradient_structure::set_CMPDIF_BUFFER_SIZE(800000);
  gradient_structure::set_NUM_DEPENDENT_VARIABLES(5000);


GLOBALS_SECTION
	#include <admodel.h>
	#include <string.h>
	#include <time.h>
        adstring model_name;
        adstring data_file;


	time_t start,finish;
	long hour,minute,second;
	double elapsed_time;

	adstring BaseFileName;
	adstring ReportFileName;
	adstring NewFileName;

	adstring stripExtension(adstring fileName)
	{
		/*
		This function strips the file extension
		from the fileName argument and returns
		the file name without the extension.
		*/
		const int length = fileName.size();
		for (int i=length; i>=0; --i)
		{
			if (fileName(i)=='.')
			{
				return fileName(1,i-1);
			}
		}
		return fileName;
	}


  #undef REPORT
  #define REPORT(object) report << #object "\n" << setw(8) \
  << setprecision(4) << setfixed() << object << endl;

REPORT_SECTION 
  REPORT(GS_seine);
  REPORT(sel_naa);
  REPORT(tot_sel_N);
  REPORT(est_seine_comp);
  REPORT(res_c_comp);

  REPORT(est_mat_comp);
  REPORT(res_mat_comp)
  REPORT(naa);
  REPORT(post_naa);
  REPORT(Sur);

  REPORT(mat_naa);
  REPORT(maturity);

  REPORT(sel_baa);
  REPORT(tot_sel_B);

  REPORT(est_seine_naa);
  REPORT(res_aerial);
  REPORT(est_mat_baa);
  REPORT(tot_mat_B);
  REPORT(Aerial_Biomass);
  REPORT(Total_Run);
  REPORT(Purse_Seine);


  REPORT(obs_catch_naa);
  REPORT(obs_c_waa);
  REPORT(obs_seine_comp);

  REPORT(tot_obs_catch);
  REPORT(tot_mat_N);
  REPORT(f);
  REPORT(Purse_Seine);
  REPORT(Total_Run);
  REPORT(Aerial_Biomass);
  REPORT(tot_sp_N);
  REPORT(N);
 
  REPORT(for_naa);
  REPORT(for_mat_naa);
  REPORT(for_mat_baa);
  REPORT(for_mat_prop);
  REPORT(for_mat_b_prop);
  REPORT(for_mat_B);
  REPORT(for_mat_B_st);
  REPORT(for_tot_mat_N);
 

	//  Print run time statistics to the screen.
	time(&finish);
	elapsed_time=difftime(finish,start);
	hour=long(elapsed_time)/3600;
	minute=long(elapsed_time)%3600/60;
	second=(long(elapsed_time)%3600)%60;
	cout<<endl<<endl<<"*******************************************"<<endl;
	cout<<"--Start time: "<<ctime(&start)<<endl;
	cout<<"--Finish time: "<<ctime(&finish)<<endl;
	cout<<"--Runtime: ";
	cout<<hour<<" hours, "<<minute<<" minutes, "<<second<<" seconds"<<endl;
        cout<<""<<endl;
	cout<<"--Objective function value: "<<f<<endl;
        cout<<""<<endl;
        cout<<""<<endl;
	cout<<"--Maximum gradient component: "<<objective_function_value::gmax<<endl;
        cout<<""<<endl;
	cout<<"*******************************************"<<endl;

        cout<<""<<endl;
        cout<< "O frabjous day!"<<endl;
        cout<< "The sheep frolic!"<<endl;
        cout<<""<<endl;
        cout<<"        ...moo..."<<endl;
        cout<<"            | "<<endl;
        cout<<"            | "<<endl;
        cout<<"            | "<<endl;
        cout<<"             _.%%%%%%%%%%%%%             " <<endl;
        cout<<"            //-_%%%%%%%%%%%%%            " <<endl;
        cout<<"           (_ %\\%%%%%%%%%%%%%%~             "<<endl;
        cout<<"               %%%%%%%%%%%%%%             "<<endl;
        cout<<"                 %%%%%*%%%%              "<<endl;
        cout<<"            ,,,,,,||,,,,||,,,,,         "<<endl;
        cout<<""<<endl;
