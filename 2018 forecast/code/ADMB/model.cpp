#ifdef DEBUG
  #ifndef __SUNPRO_C
    #include <cfenv>
    #include <cstdlib>
  #endif
#endif
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
#include <admodel.h>
#include <contrib.h>

  extern "C"  {
    void ad_boundf(int i);
  }
#include <model.htp>

model_data::model_data(int argc,char * argv[]) : ad_comm(argc,argv)
{
  pad_evalout = new ofstream("evalout.prj");;
  DataFile.allocate("DataFile");
  ControlFile.allocate("ControlFile");
  LoopFile.allocate("LoopFile");
  Graphics.allocate("Graphics");
 BaseFileName = stripExtension(DataFile);  
 ReportFileName = BaseFileName + adstring(".rep");
 cout<<"You are modeling the "<<BaseFileName<<" stock of herring"<<endl;
 cout<<""<<endl;
 time(&start);
 ad_comm::change_datafile_name(DataFile);
  dat_syr.allocate("dat_syr");
  dat_nyr.allocate("dat_nyr");
  mod_syr.allocate("mod_syr");
  mod_nyr.allocate("mod_nyr");
  sage.allocate("sage");
  nage.allocate("nage");
  nages.allocate("nages");
  rec_syr = mod_syr + sage;
  age.allocate(sage,nage);
 age.fill_seqadd(sage,1);
  Year.allocate(mod_syr,mod_nyr+1);
  dyrs=dat_nyr-dat_syr+1;
  myrs=mod_nyr-mod_syr+1;
  md_offset=mod_syr-dat_syr;
  Year.fill_seqadd(mod_syr,1);   
  threshold.allocate(1,myrs,"threshold");
  fw_a_a.allocate(1,nages,"fw_a_a");
  tot_obs_catch_seine.allocate(1,myrs,"tot_obs_catch_seine");
  tot_obs_aerial.allocate(1,myrs,"tot_obs_aerial");
  tot_obs_aerial_tuned.allocate(1,myrs,"tot_obs_aerial_tuned");
  obs_catch_naa.allocate(1,myrs,1,nages,"obs_catch_naa");
  obs_c_waa.allocate(1,myrs,1,nages,"obs_c_waa");
  obs_seine_comp.allocate(1,myrs,1,nages,"obs_seine_comp");
  obs_mat_comp.allocate(1,myrs,1,nages,"obs_mat_comp");
  tot_obs_catch_gillnet.allocate(1,myrs,"tot_obs_catch_gillnet");
  tot_obs_aerial_tons.allocate(1,myrs);
  tot_obs_aerial_tuned_tons.allocate(1,myrs);
  tot_obs_catch.allocate(1,myrs);
  tot_obs_catch_seine_tons.allocate(1,myrs);
  tot_obs_catch_gillnet_tons.allocate(1,myrs);
  tot_obs_catch_tons.allocate(1,myrs);
  eof2.allocate("eof2");
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
     tot_obs_aerial_tons(i)=tot_obs_aerial(i)*1.102311;
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
     tot_obs_aerial_tuned_tons(i)=tot_obs_aerial_tuned(i)*1.102311;
       }
       }
       
     for (int i=1;i<=myrs;i++)
       {    
     tot_obs_catch(i)=tot_obs_catch_seine(i)+tot_obs_catch_gillnet(i);
     tot_obs_catch_seine_tons(i)=tot_obs_catch_seine(i)*1.102311;
     tot_obs_catch_gillnet_tons(i)=tot_obs_catch_gillnet(i)*1.102311;
        }
        
      for (int i=1;i<=myrs;i++)
       {    
     tot_obs_catch_tons(i)=tot_obs_catch(i)*1.102311;
      }
 ad_comm::change_datafile_name(ControlFile);
  ph_Int.allocate("ph_Int");
  ph_mat_a.allocate("ph_mat_a");
  ph_gs_a.allocate("ph_gs_a");
  ph_Sur_a.allocate("ph_Sur_a");
  ph_mat_b.allocate("ph_mat_b");
  ph_gs_b.allocate("ph_gs_b");
  ph_Sur_b.allocate("ph_Sur_b");
  ph_Rec.allocate("ph_Rec");
  ph_Ric.allocate("ph_Ric");
  ph_md.allocate("ph_md");
  lR.allocate("lR");
  lM.allocate("lM");
  lA.allocate("lA");
  wt_aerial.allocate(1,dyrs,"wt_aerial");
  eof1.allocate("eof1");
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
 ad_comm::change_datafile_name(LoopFile);
  mat_Bk.allocate("mat_Bk");
  mat_Bk_Yrs.allocate(1,mat_Bk+1,"mat_Bk_Yrs");
  mat_Bk_Idx.allocate(1,mat_Bk+1);
  gs_Bk.allocate("gs_Bk");
  gs_Bk_Yrs.allocate(1,gs_Bk+1,"gs_Bk_Yrs");
  gs_Bk_Idx.allocate(1,gs_Bk+1);
  S_Bk.allocate("S_Bk");
  S_Bk_Yrs.allocate(1,S_Bk+1,"S_Bk_Yrs");
  S_Bk_Idx.allocate(1,S_Bk+1);
  eof4.allocate("eof4");
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
   // | The lines below populate the indices for maturity, selectivity, and survival
   for (int i=1;i<=mat_Bk+1;i++)
     {
       mat_Bk_Idx(i)=mat_Bk_Yrs(i)-mod_syr+1;
     }
   for (int i=1;i<=gs_Bk+1;i++)
     {
       gs_Bk_Idx(i)=gs_Bk_Yrs(i)-mod_syr+1;
     }
   for (int i=1;i<=S_Bk+1;i++)
     {
       S_Bk_Idx(i)=S_Bk_Yrs(i)-mod_syr+1;
     }
 ad_comm::change_datafile_name(Graphics);
  mod_yrs.allocate(1,myrs,"mod_yrs");
  yminusfour.allocate(1,myrs,"yminusfour");
  yminusthree.allocate(1,myrs,"yminusthree");
  yminustwo.allocate(1,myrs,"yminustwo");
  yminusone.allocate(1,myrs,"yminusone");
  past_forecasts.allocate(1,myrs,"past_forecasts");
  yminusfourFOR.allocate("yminusfourFOR");
  yminusthreeFOR.allocate("yminusthreeFOR");
  yminustwoFOR.allocate("yminustwoFOR");
  yminusoneFOR.allocate("yminusoneFOR");
  eof3.allocate("eof3");
    if(eof3==42) cout << BaseFileName<<"_graphics.ctl has been read correctly!"<<endl;
    else 
    {       
         cout <<"|----------------------------------------------------------------------|"<<endl;   
         cout <<"|   Red alert! Captain to bridge! The graphics file is compromised!    |"<<endl;
         cout <<"|----------------------------------------------------------------------|"<<endl; 
	 cout <<"|      Last integer read is "<<eof3<<", but the file *should* end with 42      |"<<endl;
         cout <<"|  Please check the graphics file for errors and make sure the above   |"<<endl;
         cout <<"|          calls are matched exactly by the file's contents            |"<<endl;
         cout <<"|----------------------------------------------------------------------|"<<endl;
    exit(1); 
    }
   
}

model_parameters::model_parameters(int sz,int argc,char * argv[]) : 
 model_data(argc,argv) , function_minimizer(sz)
{
  initializationfunction();
  init_age_4.allocate(1,myrs,5,2500,ph_Rec,"init_age_4");
  init_pop.allocate(1,8,1,2200,ph_Int,"init_pop");
  mat_a.allocate(1,mat_Bk,1,10,ph_mat_a,"mat_a");
  mat_b.allocate(1,mat_Bk,0,5,ph_mat_b,"mat_b");
  maturity.allocate(1,myrs,1,nages,"maturity");
  #ifndef NO_AD_INITIALIZE
    maturity.initialize();
  #endif
  for_mat.allocate(1,nages,"for_mat");
  #ifndef NO_AD_INITIALIZE
    for_mat.initialize();
  #endif
  gs_a.allocate(1,gs_Bk,1,10,ph_mat_a,"gs_a");
  gs_b.allocate(1,gs_Bk,0,5,ph_mat_b,"gs_b");
  gs_seine.allocate(1,myrs,1,nages,"gs_seine");
  #ifndef NO_AD_INITIALIZE
    gs_seine.initialize();
  #endif
  for_gs_seine.allocate(1,nages,"for_gs_seine");
  #ifndef NO_AD_INITIALIZE
    for_gs_seine.initialize();
  #endif
  Sur_a.allocate(1,S_Bk,0.3,1,ph_Sur_a,"Sur_a");
  Sur_b.allocate(1,S_Bk,0.01,0.2,ph_Sur_b,"Sur_b");
  Sur.allocate(1,myrs,1,nages,"Sur");
  #ifndef NO_AD_INITIALIZE
    Sur.initialize();
  #endif
  for_sur.allocate(1,nages,"for_sur");
  #ifndef NO_AD_INITIALIZE
    for_sur.initialize();
  #endif
  sel_naa.allocate(1,myrs,1,nages,"sel_naa");
  #ifndef NO_AD_INITIALIZE
    sel_naa.initialize();
  #endif
  mat_naa.allocate(1,myrs,1,nages,"mat_naa");
  #ifndef NO_AD_INITIALIZE
    mat_naa.initialize();
  #endif
  tot_sel_N.allocate(1,myrs,"tot_sel_N");
  #ifndef NO_AD_INITIALIZE
    tot_sel_N.initialize();
  #endif
  tot_mat_N.allocate(1,myrs,"tot_mat_N");
  #ifndef NO_AD_INITIALIZE
    tot_mat_N.initialize();
  #endif
  sel_baa.allocate(1,myrs,1,nages,"sel_baa");
  #ifndef NO_AD_INITIALIZE
    sel_baa.initialize();
  #endif
  tot_sel_B.allocate(1,myrs,"tot_sel_B");
  #ifndef NO_AD_INITIALIZE
    tot_sel_B.initialize();
  #endif
  est_mat_baa.allocate(1,myrs,1,nages,"est_mat_baa");
  #ifndef NO_AD_INITIALIZE
    est_mat_baa.initialize();
  #endif
  tot_mat_B.allocate(1,myrs,"tot_mat_B");
  #ifndef NO_AD_INITIALIZE
    tot_mat_B.initialize();
  #endif
  tot_mat_B_tons.allocate(1,myrs,"tot_mat_B_tons");
  #ifndef NO_AD_INITIALIZE
    tot_mat_B_tons.initialize();
  #endif
  naa.allocate(1,myrs,1,nages,"naa");
  #ifndef NO_AD_INITIALIZE
    naa.initialize();
  #endif
  post_naa.allocate(1,myrs,1,nages,"post_naa");
  #ifndef NO_AD_INITIALIZE
    post_naa.initialize();
  #endif
  est_seine_comp.allocate(1,myrs,1,nages,"est_seine_comp");
  #ifndef NO_AD_INITIALIZE
    est_seine_comp.initialize();
  #endif
  est_seine_naa.allocate(1,myrs,1,nages,"est_seine_naa");
  #ifndef NO_AD_INITIALIZE
    est_seine_naa.initialize();
  #endif
  est_mat_comp.allocate(1,myrs,1,nages,"est_mat_comp");
  #ifndef NO_AD_INITIALIZE
    est_mat_comp.initialize();
  #endif
  est_catch_comp.allocate(1,myrs,1,nages,"est_catch_comp");
  #ifndef NO_AD_INITIALIZE
    est_catch_comp.initialize();
  #endif
  est_tot_catch.allocate(1,myrs,1,nages,"est_tot_catch");
  #ifndef NO_AD_INITIALIZE
    est_tot_catch.initialize();
  #endif
  est_sp_naa.allocate(1,myrs,1,nages,"est_sp_naa");
  #ifndef NO_AD_INITIALIZE
    est_sp_naa.initialize();
  #endif
  tot_sp_N.allocate(1,myrs,"tot_sp_N");
  #ifndef NO_AD_INITIALIZE
    tot_sp_N.initialize();
  #endif
  tot_post_N.allocate(1,myrs,"tot_post_N");
  #ifndef NO_AD_INITIALIZE
    tot_post_N.initialize();
  #endif
  N.allocate(1,myrs,"N");
  #ifndef NO_AD_INITIALIZE
    N.initialize();
  #endif
  sortx.allocate(1,10,"sortx");
  #ifndef NO_AD_INITIALIZE
    sortx.initialize();
  #endif
  for_naa.allocate(1,nages,"for_naa");
  #ifndef NO_AD_INITIALIZE
    for_naa.initialize();
  #endif
  for_mat_naa.allocate(1,nages,"for_mat_naa");
  #ifndef NO_AD_INITIALIZE
    for_mat_naa.initialize();
  #endif
  for_mat_baa.allocate(1,nages,"for_mat_baa");
  #ifndef NO_AD_INITIALIZE
    for_mat_baa.initialize();
  #endif
  for_mat_baa_st.allocate(1,nages,"for_mat_baa_st");
  #ifndef NO_AD_INITIALIZE
    for_mat_baa_st.initialize();
  #endif
  for_mat_prop.allocate(1,nages,"for_mat_prop");
  #ifndef NO_AD_INITIALIZE
    for_mat_prop.initialize();
  #endif
  for_mat_b_prop.allocate(1,nages,"for_mat_b_prop");
  #ifndef NO_AD_INITIALIZE
    for_mat_b_prop.initialize();
  #endif
  for_mat_w.allocate(1,nages,"for_mat_w");
  #ifndef NO_AD_INITIALIZE
    for_mat_w.initialize();
  #endif
  for_seine_w.allocate(1,nages,"for_seine_w");
  #ifndef NO_AD_INITIALIZE
    for_seine_w.initialize();
  #endif
  for_mat_B.allocate("for_mat_B");
  #ifndef NO_AD_INITIALIZE
  for_mat_B.initialize();
  #endif
  for_mat_B_st.allocate("for_mat_B_st");
  #ifndef NO_AD_INITIALIZE
  for_mat_B_st.initialize();
  #endif
  for_tot_mat_N.allocate("for_tot_mat_N");
  #ifndef NO_AD_INITIALIZE
  for_tot_mat_N.initialize();
  #endif
  for_mat_weighted.allocate("for_mat_weighted");
  #ifndef NO_AD_INITIALIZE
  for_mat_weighted.initialize();
  #endif
  for_seine_weighted.allocate("for_seine_weighted");
  #ifndef NO_AD_INITIALIZE
  for_seine_weighted.initialize();
  #endif
  medianx.allocate("medianx");
  #ifndef NO_AD_INITIALIZE
  medianx.initialize();
  #endif
  for_seine_prop.allocate(1,nages,"for_seine_prop");
  #ifndef NO_AD_INITIALIZE
    for_seine_prop.initialize();
  #endif
  for_seine_naa.allocate(1,nages,"for_seine_naa");
  #ifndef NO_AD_INITIALIZE
    for_seine_naa.initialize();
  #endif
  for_tot_seine_N.allocate("for_tot_seine_N");
  #ifndef NO_AD_INITIALIZE
  for_tot_seine_N.initialize();
  #endif
  FIGDATA.allocate(1,myrs,1,53,"FIGDATA");
  #ifndef NO_AD_INITIALIZE
    FIGDATA.initialize();
  #endif
  FIGDATAAGE.allocate(1,nages,1,4,"FIGDATAAGE");
  #ifndef NO_AD_INITIALIZE
    FIGDATAAGE.initialize();
  #endif
  res_c_comp.allocate(1,myrs,1,nages,"res_c_comp");
  #ifndef NO_AD_INITIALIZE
    res_c_comp.initialize();
  #endif
  res_mat_comp.allocate(1,myrs,1,nages,"res_mat_comp");
  #ifndef NO_AD_INITIALIZE
    res_mat_comp.initialize();
  #endif
  res_aerial.allocate(1,myrs,"res_aerial");
  #ifndef NO_AD_INITIALIZE
    res_aerial.initialize();
  #endif
  Purse_Seine.allocate("Purse_Seine");
  #ifndef NO_AD_INITIALIZE
  Purse_Seine.initialize();
  #endif
  Total_Run.allocate("Total_Run");
  #ifndef NO_AD_INITIALIZE
  Total_Run.initialize();
  #endif
  Aerial_Biomass.allocate("Aerial_Biomass");
  #ifndef NO_AD_INITIALIZE
  Aerial_Biomass.initialize();
  #endif
  f.allocate("f");
  prior_function_value.allocate("prior_function_value");
  likelihood_function_value.allocate("likelihood_function_value");
  n_obs_seine_comp.allocate(1,myrs,1,nages,"n_obs_seine_comp");
  #ifndef NO_AD_INITIALIZE
    n_obs_seine_comp.initialize();
  #endif
  n_obs_mat_comp.allocate(1,myrs,1,nages,"n_obs_mat_comp");
  #ifndef NO_AD_INITIALIZE
    n_obs_mat_comp.initialize();
  #endif
  n_tot_obs_aerial.allocate(1,myrs,"n_tot_obs_aerial");
  #ifndef NO_AD_INITIALIZE
    n_tot_obs_aerial.initialize();
  #endif
  n_d.allocate(1,3,"n_d");
  #ifndef NO_AD_INITIALIZE
    n_d.initialize();
  #endif
  w_d.allocate(1,3,"w_d");
  #ifndef NO_AD_INITIALIZE
    w_d.initialize();
  #endif
  lnL_d.allocate(1,3,"lnL_d");
  #ifndef NO_AD_INITIALIZE
    lnL_d.initialize();
  #endif
  n_R.allocate("n_R");
  #ifndef NO_AD_INITIALIZE
  n_R.initialize();
  #endif
  n_M.allocate("n_M");
  #ifndef NO_AD_INITIALIZE
  n_M.initialize();
  #endif
  n_A.allocate("n_A");
  #ifndef NO_AD_INITIALIZE
  n_A.initialize();
  #endif
  n.allocate("n");
  #ifndef NO_AD_INITIALIZE
  n.initialize();
  #endif
  sig_1.allocate("sig_1");
  #ifndef NO_AD_INITIALIZE
  sig_1.initialize();
  #endif
  lnL.allocate("lnL");
  #ifndef NO_AD_INITIALIZE
  lnL.initialize();
  #endif
  AIC.allocate("AIC");
  #ifndef NO_AD_INITIALIZE
  AIC.initialize();
  #endif
  AICc.allocate("AICc");
  #ifndef NO_AD_INITIALIZE
  AICc.initialize();
  #endif
  p.allocate("p");
  #ifndef NO_AD_INITIALIZE
  p.initialize();
  #endif
}

void model_parameters::preliminary_calculations(void)
{

#if defined(USE_ADPVM)

  admaster_slave_variable_interface(*this);

#endif
         mat_a(1)=6;
         mat_a(2)=6;
         mat_b(1)=1.2;
         mat_b(2)=1.1;
         gs_a=6;
         gs_b=1;
         Sur_a=0.8;
         Sur_b=0.03;
}

void model_parameters::userfunction(void)
{
  f =0.0;
  ofstream& evalout= *pad_evalout;
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
     compute_AICc();
     get_report();
    }
  if(mceval_phase())
    {
     evalout<<for_mat_B_st<<" "
          <<init_age_4<<" "
          <<init_pop<<" "<<endl;
    }
}

void model_parameters::get_parameters(void)
{
  ofstream& evalout= *pad_evalout;
  gs_seine.initialize();
  for_gs_seine.initialize();
  maturity.initialize();
  for_mat.initialize();
  Sur.initialize();
  for_sur.initialize();
  // Seine fishery-unconstrained then fix at age 9
  for (int t=1;t<=gs_Bk;t++)
  {
    for (int i=gs_Bk_Idx(t);i<=gs_Bk_Idx(t+1);i++)
       {
         for (int j=1;j<=nages;j++)
          {
          if (j<=5)
          {
            gs_seine(i,j)=1/(1+exp(-1.0*gs_b(t)*((j+3)-gs_a(t))));//changed j+2 to j+3 so recruit is age-4
          }
          else
          {
          gs_seine(i,j)=1;
          }
       }
   }
  }  
   for_gs_seine=gs_seine(myrs);//last year of maturity matrix is used as forecast
  // Early/late Maturity time periods unconstrained &  then fix ages 8+=1
  for (int t=1;t<=mat_Bk;t++)
  {
    for (int i=mat_Bk_Idx(t);i<=mat_Bk_Idx(t+1);i++)
       {
         for (int j=1;j<=nages;j++)
          {
          if (j<=4)
          {
            maturity(i,j)=1/(1+exp(-1.0*mat_b(t)*((j+3)-mat_a(t))));//changed j+2 to j+3 so recruit is age-4
          }
          else
          {
          maturity(i,j)=1;
          }
       }
   }
  }         
  for_mat = maturity(myrs);//last year of maturity matrix is used as forecast
  //Survival (linear regression)
  //Survival; to make survival the same for all ages and years, change (j<=5) to (j<=9)
   for (int t=1;t<=S_Bk;t++)
  {
    for (int i=S_Bk_Idx(t);i<=S_Bk_Idx(t+1);i++)
       {
         for (int j=1;j<=nages;j++)
          {
          if (j<=5)
          {
            Sur(i,j)=Sur_a(t);
          }
          else
          {
          Sur(i,j) = Sur_a(t) - Sur_b(t)*((j+3)-(8));
          }
       }
   }
  }         
  for_sur=Sur(myrs); //last year of survival matrix is used as forecast
}

void model_parameters::Time_Loop(void)
{
  ofstream& evalout= *pad_evalout;
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
         sel_naa(i,j)  = naa(i,j) * gs_seine(i,j);
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
         est_seine_naa(i,j) = (tot_obs_catch_seine(i) / tot_sel_B(i))*est_seine_comp(i,j);
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
      naa(i,j)=post_naa(i-1,j-1)*Sur(i-1,j-1);  //naa: (numbers-catch)*survival
      }
    for(int j=nages;j<=nages;j++)
      {
        naa(i,j)=post_naa(i-1,j-1)*Sur(i-1,j-1)+post_naa(i-1,j)*Sur(i-1,j); //+ class, naa
      }
     for(int j=1;j<=nages;j++)
       {
         sel_naa(i,j)  = naa(i,j) * gs_seine(i,j);//naa vulnerable to gear
         mat_naa(i,j)  = naa(i,j) * maturity(i,j); 
       }
   tot_sel_N = rowsum(sel_naa);//total selected by gear (abundance)
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
         est_seine_naa(i,j) = (tot_obs_catch_seine(i) / tot_sel_B(i))*est_seine_comp(i,j);
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
 for (int i=1;i<=myrs;i++)
    {
      for(int j=1;j<=nages;j++)
        {
          est_sp_naa(i,j)=(maturity(i,j)*naa(i,j))-est_seine_naa(i,j)-obs_catch_naa(i,j);          //spawning numbers-at-age (differs for stocks) For Craig should be Mat *(naa-est_c_naa)
        }}
    tot_sp_N=rowsum(est_sp_naa);                                       //total spawning numbers
}

void model_parameters::get_residuals(void)
{
  ofstream& evalout= *pad_evalout;
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
         if (obs_seine_comp(i,j)<0)
            {
              res_c_comp(i,j)=0;
            }
            else
            {
               res_c_comp(i,j)=obs_seine_comp(i,j)-est_seine_comp(i,j);
             }
        }
   }
  //----------------------------------------------------------------------------
  // MATURE AGE COMPOSITION--Total Run
  //----------------------------------------------------------------------------
  for (int i=1;i<=myrs;i++)
    {
     for (int j=1;j<=nages;j++)
       {
         if (obs_mat_comp(i,j)<0)
            {
              res_mat_comp(i,j)=0;
            }
            else
            {
              res_mat_comp(i,j)=(obs_mat_comp(i,j)-est_mat_comp(i,j));
       }
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
              res_aerial(i)=(log(tot_obs_aerial(i))-log(tot_mat_B(i))) * sqrt(wt_aerial(i));
            }
        }
  //WSSQM=sum(wSSQM);
  Purse_Seine  = norm2(res_c_comp);
  Total_Run = norm2(res_mat_comp);
  Aerial_Biomass = norm2(res_aerial);
}

void model_parameters::evaluate_the_objective_function(void)
{
  ofstream& evalout= *pad_evalout;
  f=lR*Purse_Seine+lM*Total_Run+lA*Aerial_Biomass;
}

void model_parameters::get_forecast(void)
{
  ofstream& evalout= *pad_evalout;
   dvector rtemp(1,10);
   for (int j=1; j<=10; j++)
      {
        rtemp(j) = value(naa(myrs-j-1,1));
      }
  sortx = sort(rtemp);
  medianx = (sortx(5)+sortx(6))/2; 
  for (int j=1;j<=1;j++)
    {
      for_naa(j)=medianx;     //forecast age 4 //numbers; 10-yr median prior to the last 2 yrs
    }
  for (int j=2;j<=nages-1;j++)
    {
      for_naa(j)=post_naa(myrs,j-1)*for_sur(j-1);                           //forecast naa, ages 5 - 11
    }
  for (int j=nages;j<=nages;j++)
    {
      for_naa(j)=post_naa(myrs,j-1)*for_sur(j-1)+post_naa(myrs,j)*for_sur(j);    //forecast naa, age 12+
    }
  for (int j=1;j<=nages;j++)
    {
      for_mat_naa(j)=for_naa(j)*for_mat(j);    //forecast mature numbers at age
    }
  for_tot_mat_N=sum(for_mat_naa);
    for (int j=1;j<=nages;j++)
    {
      for_seine_naa(j)=for_naa(j)*for_gs_seine(j);    //forecast mature numbers at age
    }
  for_tot_seine_N=sum(for_seine_naa);
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
      for_mat_w(j)=for_mat_prop(j)*fw_a_a(j);  //forecast weight of the mature pop.
    }
      for_mat_weighted=sum(for_mat_w);
 for (int j=1;j<=nages;j++)
    {
      for_seine_prop(j)=for_seine_naa(j)/for_tot_seine_N;  //forecast % mature at age
    }
  for (int j=1;j<=nages;j++)
    {
      for_seine_w(j)=for_seine_prop(j)*fw_a_a(j);  //forecast weight of seine harvested fish
    }
      for_seine_weighted=sum(for_seine_w);
  for (int j=1;j<=nages;j++)
    {
      for_mat_b_prop(j) = for_mat_baa(j)/for_mat_B;  //forecast % mature at age biomass
    }
  for_mat_B_st=for_mat_B*1.102311;                   //RETURN TO SHORT TONS
  for (int j=1;j<=nages;j++)
    {
     for_mat_baa_st(j)=for_mat_baa(j)*1.102311;  //forecast % mature at age biomass
    }
}

void model_parameters::get_FIGDATA(void)
{
  ofstream& evalout= *pad_evalout;
  FIGDATA.initialize();
  for (int i=1;i<=myrs;i++){
  for (int j=1;j<=1;j++){FIGDATA(i,j)=tot_mat_B_tons(i);}// total mature biomass (tons) 
  for (int j=2;j<=2;j++){FIGDATA(i,j)=tot_obs_aerial_tons(i);}//total observed aerial biomass (tons) 
  for (int j=3;j<=3;j++){FIGDATA(i,j)=res_aerial(i);}//aerial survey residuals 
  for (int j=4;j<=4;j++){FIGDATA(i,j)=init_age_4(i);}//age-3 recruit strength 
  for (int j=5;j<=13;j++){FIGDATA(i,j)=est_seine_comp(i,j-4);}//proportion of N selected by gear (estimated) 
  for (int j=14;j<=22;j++){FIGDATA(i,j)=obs_seine_comp(i+md_offset,j-13);}//observed catch compostion
  for (int j=23;j<=31;j++){FIGDATA(i,j)=est_mat_comp(i,j-22);}//estimated mature  age composition 
  for (int j=32;j<=40;j++){FIGDATA(i,j)=obs_mat_comp(i+md_offset,j-31);}//observed mature  age composition 
  for (int j=41;j<=41;j++){FIGDATA(i,j)=tot_post_N(i);}// total population [mature+ immature] - catch [millions]   
  for (int j=42;j<=42;j++){FIGDATA(i,j)=N(i);}// total abundance (mature + immature [millions] 
  for (int j=43;j<=43;j++){FIGDATA(i,j)=tot_sp_N(i);} // total spawning abundance [millions]
  for (int j=44;j<=44;j++){FIGDATA(i,j)=tot_mat_N(i);} // total mature abundance[millions] 
  for (int j=45;j<=45;j++){FIGDATA(i,j)=tot_obs_aerial_tuned_tons(i);} // total observed aerial biomass-tuned to model (tons) 
  for (int j=46;j<=46;j++){FIGDATA(i,j)=threshold(i);}// threshold
  for (int j=47;j<=47;j++){FIGDATA(i,j)=yminusfour(i);} //mature biomass (tons) 
  for (int j=48;j<=48;j++){FIGDATA(i,j)=yminusthree(i);} //mature biomass (tons) 
  for (int j=49;j<=49;j++){FIGDATA(i,j)=yminustwo(i);} //mature biomass (tons) 
  for (int j=50;j<=50;j++){FIGDATA(i,j)=yminusone(i);} //mature biomass  (tons)
  for (int j=51;j<=51;j++){FIGDATA(i,j)=mod_yrs(i);}//model years
  for (int j=52;j<=52;j++){FIGDATA(i,j)=past_forecasts(i);}//prior forecasts
  for (int j=53;j<=53;j++){FIGDATA(i,j)=tot_obs_catch_tons(i);}}//total observed catch in tons
}

void model_parameters::output_FIGDATA(void)
{
  ofstream& evalout= *pad_evalout;
 ofstream figdata("FIGDATA.dat");
 figdata<<"tot_mat_B_tons tot_obs_aerial_tons res_aerial init_age_4 est_seine_comp4 est_seine_comp5 est_seine_comp6 est_seine_comp7 est_seine_comp8 est_seine_comp9 est_seine_comp10 est_seine_comp11 est_seine_comp12 obs_seine_comp4 obs_seine_comp5 obs_seine_comp6 obs_seine_comp7 obs_seine_comp8 obs_seine_comp9 obs_seine_comp10 obs_seine_comp11 obs_seine_comp12 est_mat_comp4 est_mat_comp5 est_mat_comp6 est_mat_comp7 est_mat_comp8 est_mat_comp9 est_mat_comp10 est_mat_comp11 est_mat_comp12 obs_mat_comp4 obs_mat_comp5 obs_mat_comp6 obs_mat_comp7 obs_mat_comp8 obs_mat_comp9 obs_mat_comp10 obs_mat_comp11 obs_mat_comp12 tot_post_N N tot_sp_N tot_mat_N tot_obs_aerial_tuned_tons threshold yminusfour yminusthree yminustwo yminusone Year past_forecasts tot_obs_catch_tons"<<endl;
 figdata<<FIGDATA<<endl;
}

void model_parameters::get_FIGDATAAGE(void)
{
  ofstream& evalout= *pad_evalout;
  FIGDATAAGE.initialize();
  for (int i=1;i<=nages;i++){
 //Mature biomass at age (forecasted; tons)
  for (int j=1;j<=1;j++){FIGDATAAGE(i,j)=for_mat_baa_st(i);}
 //Mature numbers at age (forecasted; proportion)
  for (int j=2;j<=2;j++){FIGDATAAGE(i,j)=for_mat_prop(i);}
 //Forecasted weight at age
  for (int j=3;j<=3;j++){FIGDATAAGE(i,j)=fw_a_a(i);}
  //Mature biomass at age (forecasted; proportion)
  for (int j=4;j<=4;j++){FIGDATAAGE(i,j)=for_mat_b_prop(i);}}
}

void model_parameters::output_FIGDATAAGE(void)
{
  ofstream& evalout= *pad_evalout;
 ofstream figdataage("FIGDATAAGE.dat");
 figdataage<<"for_mat_baa_st for_mat_prop fw_a_a for_mat_b_prop"<<endl;
 figdataage<<FIGDATAAGE<<endl;
}

void model_parameters::compute_AICc(void)
{
  ofstream& evalout= *pad_evalout;
  n_obs_seine_comp.initialize();
  n_R.initialize();
  n_obs_mat_comp.initialize();
  n_M.initialize();
  n_tot_obs_aerial.initialize();
  n_A.initialize();
  n_d.initialize();
  n.initialize();
  sig_1.initialize();
  w_d.initialize();
  lnL_d.initialize();
  lnL.initialize();
  AIC.initialize();
  AICc.initialize();
  p.initialize();
  //Compute sample sizes
   //Catch age comp-Purse seine
  for (int i=1;i<=myrs;i++)
    {
      for (int j=1;j<=nages;j++)
        {
          if (obs_seine_comp(i+md_offset,j)<0)
            {
              n_obs_seine_comp(i,j)=0;
            }
          else
            {
              n_obs_seine_comp(i,j)=1;
            }
        }
    }
  n_R=sum(n_obs_seine_comp);
  cout <<n_R<<endl; 
  //Mature Age Composision-Total Run
  for (int i=1;i<=myrs;i++)
    {
      for (int j=1;j<=nages;j++)
        {
          if (obs_mat_comp(i+md_offset,j)<0)
            {
              n_obs_mat_comp(i,j)=0;
            }
          else
            {
              n_obs_mat_comp(i,j)=1;
            }
        }
     }
  n_M=sum(n_obs_mat_comp);
 cout <<n_M<<endl; 
  //Aerial Survey
  for (int i=1;i<=myrs;i++)
        {
          if (wt_aerial(i)<=0)
            {
              n_tot_obs_aerial(i)=0;
            }
          else
            {
              n_tot_obs_aerial(i)=1;
            }
        }
  n_A=sum(n_tot_obs_aerial);
  cout <<n_A<<endl; 
  //Set up sample size vector
  n_d(1)=n_R;
  n_d(2)=n_M;
  n_d(3)=n_A;
  n=sum(n_d);
  //Set up weighting vector
  w_d(1)=lR;
  w_d(2)=lM;
  w_d(3)=lA;
  //Set up sigma vector
  sig_1=f/n;
  cout <<sig_1<<endl; 
    //Calculate log likelihood
  for (int i=1;i<=3;i++){ 
  if(w_d(i)>0){
   lnL_d(i)=-n_d(i)/2*(log(2*3.141593*sig_1/w_d(i))+1);}
  else{
   lnL_d(i)=0;}}
  cout <<lnL_d<<endl;
  lnL=sum(lnL_d);
  cout <<lnL<<endl; 
  //Compute AIC and AICc
  p=initial_params::nvarcalc();
  AIC=-2*lnL+2*p;
  AICc=AIC+2*p*(p+1)/(n-p-1);
}

void model_parameters::get_report(void)
{
  ofstream& evalout= *pad_evalout;
       ofstream Report("Report (Togiak Stock).csv");
           int vsize = Year.size();
    Report << "MODEL RESULTS:" <<endl;
    Report<<"Objective function value:"<<","<<f<<endl;
    Report<<"AICc"<<","<<AICc<<endl;
    Report<<"AIC"<<","<<AIC<<endl;
    Report<<"  "<<endl;
    Report<<"Dataset Components (unweighted):"<<endl;
    Report<<"Catch SSQ"<<","<<Purse_Seine<<endl;
    Report<<"Total Run"<<","<<Total_Run<<endl;
    Report<<"Aerial Biomass"<<","<<Aerial_Biomass<<endl;
    Report<<"  "<<endl;
    Report<<"Sample Sizes:"<<endl;
    Report<<"Catch SSQ"<<","<<n_R<<endl;
    Report<<"Total Run"<<","<<n_M<<endl;
    Report<<"Aerial Biomass"<<","<<n_A<<endl;
    Report<<"  "<<endl;
    Report<<"Log Likehoods:"<<endl;
    Report<<"Catch SSQ"<<","<<lnL_d[1]<<endl;
    Report<<"Total Run"<<","<<lnL_d[2]<<endl;
    Report<<"Aerial Biomass"<<","<<lnL_d[3]<<endl;
    Report<<"Total Log Likelihood"<<","<<lnL<<endl;
    Report<<"Number of parameters"<<","<<p<<endl;
    Report<<"  "<<endl;
    Report<<"Data Weights:"<<endl;
    Report<<"Catch SSQ"<<","<<lR<<endl;
    Report<<"Total Run"<<","<<lM<<endl;
    Report<<"Aerial Biomass"<<","<<lA<<endl;
    Report<<"  "<<endl;
    Report<<"FORECASTED INFORMATION:"<<endl;
    Report<<"Forecast Mature Biomass (tons)"<<","<<for_mat_B_st<<endl;
    Report<<"Forecast Mature Numbers-at-age (millions)"<<","<<for_tot_mat_N<<endl;
    Report<<"  "<<endl;
    Report<<","<<"Age 4"<<","<<"Age 5"<<","<<"Age 6"<<","<<"Age 7"<<","<<"Age 8"<<","<<"Age 9 "<<","<<"Age 10"<<","<<"Age 11"<<","<<"Age 12+"<<endl;
    Report<<"Forecasted numbers-at-age (millions)"<<","<<for_naa[1]<<","<<for_naa[2]<<","<<for_naa[3]<<","<<for_naa[4]<<","<<for_naa[5]<<","<<for_naa[6]<<","<<for_naa[7]<<","<<for_naa[8]<<","<<for_naa[9]<<endl;
    Report<<"Forecasted mature numbers-at-age (millions)"<<","<<for_mat_naa[1]<<","<<for_mat_naa[2]<<","<<for_mat_naa[3]<<","<<for_mat_naa[4]<<","<<for_mat_naa[5]<<","<<for_mat_naa[6]<<","<<for_mat_naa[7]<<","<<for_mat_naa[8]<<","<<for_mat_naa[9]<<endl;
  Report<<"Forecasted mature biomass-at-age (tons)"<<","<<for_mat_baa_st[1]<<","<<for_mat_baa_st[2]<<","<<for_mat_baa_st[3]<<","<<for_mat_baa_st[4]<<","<<for_mat_baa_st[5]<<","<<for_mat_baa_st[6]<<","<<for_mat_baa_st[7]<<","<<for_mat_baa_st[8]<<","<<for_mat_baa_st[9]<<endl;
    Report<<"Forecasted mature prop. at age (by number)"<<","<<for_mat_prop[1]<<","<<for_mat_prop[2]<<","<<for_mat_prop[3]<<","<<for_mat_prop[4]<<","<<for_mat_prop[5]<<","<<for_mat_prop[6]<<","<<for_mat_prop[7]<<","<<for_mat_prop[8]<<","<<for_mat_prop[9]<<endl;
    Report<<"Forecasted mature prop. at age (by biomass)"<<","<<for_mat_b_prop[1]<<","<<for_mat_b_prop[2]<<","<<for_mat_b_prop[3]<<","<<for_mat_b_prop[4]<<","<<for_mat_b_prop[5]<<","<<for_mat_b_prop[6]<<","<<for_mat_b_prop[7]<<","<<for_mat_b_prop[8]<<","<<for_mat_b_prop[9]<<endl;
    Report<<"  "<<endl;
    Report << "ESTIMATED BY MODEL (PARAMETERS):" <<endl;
    Report<<"init_age_4:"<<","<<"Estimated mature and immature age-3 abundance (recruitment in milllions)"<<endl;
    Report<<"Year"<<","<<"init_age_4"<<endl;
    for(int n; n<=vsize-2; n++)
    Report<<Year[n+mod_syr]<<","<<init_age_4[n+1]<<endl;
    Report<<"  "<<endl;
    Report<<","<<"Age 5"<<","<<"Age 6"<<","<<"Age 7"<<","<<"Age 8"<<","<<"Age 9"<<","<<"Age 10 "<<","<<"Age 11"<<","<<"Age 12+"<<endl;
    Report<<"initial population (1980; millions of fish)"<<","<<init_pop[1]<<","<<init_pop[2]<<","<<init_pop[3]<<","<<init_pop[4]<<","<<init_pop[5]<<","<<init_pop[6]<<","<<init_pop[7]<<","<<init_pop[8]<<endl;
    Report<<"  "<<endl;
    Report<<"Estimated Gear Selectivity"<<endl;
    Report<<"Year"<<","<<"Age 4"<<","<<"Age 5"<<","<<"Age 6"<<","<<"Age 7"<<","<<"Age 8"<<","<<"Age 9 "<<","<<"Age 10"<<","<<"Age 11"<<","<<"Age12+"        <<endl;
    for(int n; n<=vsize-2; n++)
    Report<<Year[n+mod_syr]<<","<<gs_seine(n+1,1)<<","<<gs_seine(n+1,2)<<","<<gs_seine(n+1,3)<<","<<gs_seine(n+1,4)<<","<<gs_seine(n+1,5)<<","<<gs_seine     (n+1,6)<<","<<gs_seine(n+1,7)<<","<<gs_seine(n+1,8)<<","<<gs_seine(n+1,9)<<endl;
    Report<<"  "<<endl;
    Report<<"Estimated Maturity"<<endl;
    Report<<"Year"<<","<<"Age 4"<<","<<"Age 5"<<","<<"Age 6"<<","<<"Age 7"<<","<<"Age 8"<<","<<"Age 9 "<<","<<"Age 10"<<","<<"Age 11"<<","<<"Age12+"        <<endl;
    for(int n; n<=vsize-2; n++)
    Report<<Year[n+mod_syr]<<","<<maturity(n+1,1)<<","<<maturity(n+1,2)<<","<<maturity(n+1,3)<<","<<maturity(n+1,4)<<","<<maturity(n+1,5)<<","<<maturity     (n+1,6)<<","<<maturity(n+1,7)<<","<<maturity(n+1,8)<<","<<maturity(n+1,9)<<endl;
    Report<<"  "<<endl;
    Report<<"Estimated Survival"<<endl;
    Report<<"Year"<<","<<"Age 4"<<","<<"Age 5"<<","<<"Age 6"<<","<<"Age 7"<<","<<"Age 8"<<","<<"Age 9 "<<","<<"Age 10"<<","<<"Age 11"<<","<<"Age12     +"<<endl;
    for(int n; n<=vsize-2; n++)
    Report<<Year[n+mod_syr]<<","<<Sur(n+1,1)<<","<<Sur(n+1,2)<<","<<Sur(n+1,3)<<","<<Sur(n+1,4)<<","<<Sur(n+1,5)<<","<<Sur(n+1,6)<<","<<Sur(n+1,7)<<","     <<Sur(n+1,8)<<","<<Sur(n+1,9)<<endl;
    Report<<"  "<<endl;
     Report<<"  "<<endl;
    Report << "ESTIMATED BY MODEL:" <<endl;
    Report<<"tot_sel_N:"<<","<<"Estimated pre-fishery numbers (naa) x estimated gear selectivity; Estimated total abundance selected by gear (millions)"<<endl;
    Report<<"tot_mat_N:"<<","<<"Estimated total mature abundance (millions)"<<endl;
    Report<<"tot_sel_B:"<<","<<"Observed weight-at-age x estimated age composition of catch"<<endl;
    Report<<"tot_sp_N:"<<","<<"Estimated total spawning abundance (millions)"<<endl;
    Report<<"N:"<<","<<"Estimated pre-fishery total abundance (millions)"<<endl;
    Report<<"tot_mat_B_tons:"<<","<<"Estimated total mature biomass (tons)"<<endl;
    Report<<"tot_post_N:"<<","<<"Estimated post fishery total abundance (millions)"<<endl;
    Report<<"  "<<endl;
    Report<<"Year"<<","<<"tot_sel_N"<<","<<"tot_mat_N"<<","<<"tot_sel_B"<<","<<"tot_sp_N"<<","<<"N"<<","<<"tot_mat_B_tons"<<","<<"tot_post_N"<<endl;
    for(int n; n<=vsize-2; n++)
    Report<<Year[n+mod_syr]<<","<<tot_sel_N[n+1]<<","<<tot_mat_N[n+1]<<","<<tot_sel_B[n+1]<<","<<tot_sp_N[n+1]<<","<<N[n+1]<<","<<tot_mat_B_tons[n+1]<<"     ,"<<tot_post_N[n+1]<<endl;
    Report<<"  "<<endl;
    Report<<"Estimated pre-fishery total abundance (millions); naa"<<endl;
    Report<<"*Note: initial population in year 1980 and init_age_4 are estimated parameters"<<endl;
    Report<<"Year"<<","<<"Age 4"<<","<<"Age 5"<<","<<"Age 6"<<","<<"Age 7"<<","<<"Age 8"<<","<<"Age 9 "<<","<<"Age 10"<<","<<"Age 11"<<","<<"Age 12+"       <<endl;
    for(int n; n<=vsize-2; n++)
    Report<<Year[n+mod_syr]<<","<<naa(n+1,1)<<","<<naa(n+1,2)<<","<<naa(n+1,3)<<","<<naa(n+1,4)<<","<<naa(n+1,5)<<","<<naa(n+1,6)<<","<<naa(n+1,7)<<","     <<naa(n+1,8)<<","<<naa(n+1,9)<<endl;
    Report<<"  "<<endl;
    Report<<"Estimated post-fishery total abundance (millions); post_naa"<<endl;
    Report<<"Year"<<","<<"Age 4"<<","<<"Age 5"<<","<<"Age 6"<<","<<"Age 7"<<","<<"Age 8"<<","<<"Age 9 "<<","<<"Age 10"<<","<<"Age 11"<<","<<"Age 12+"       <<endl;
    for(int n; n<=vsize-2; n++)
    Report<<Year[n+mod_syr]<<","<<post_naa(n+1,1)<<","<<post_naa(n+1,2)<<","<<post_naa(n+1,3)<<","<<post_naa(n+1,4)<<","<<post_naa(n+1,5)<<","<<post_naa     (n+1,6)<<","<<post_naa(n+1,7)<<","<<post_naa(n+1,8)<<","<<post_naa(n+1,9)<<endl;
    Report<<"  "<<endl;
    Report<<"Estimated mature numbers-at-age (pre-fishery); mat_naa"<<endl;
    Report<<"Year"<<","<<"Age 4"<<","<<"Age 5"<<","<<"Age 6"<<","<<"Age 7"<<","<<"Age 8"<<","<<"Age 9 "<<","<<"Age 10"<<","<<"Age 11"<<","<<"Age 12+"       <<endl;
    for(int n; n<=vsize-2; n++)
    Report<<Year[n+mod_syr]<<","<<mat_naa(n+1,1)<<","<<mat_naa(n+1,2)<<","<<mat_naa(n+1,3)<<","<<mat_naa(n+1,4)<<","<<mat_naa(n+1,5)<<","<<mat_naa(n+1,6     )<<","<<mat_naa(n+1,7)<<","<<mat_naa(n+1,8)<<","<<mat_naa(n+1,9)<<endl;
    Report<<"  "<<endl;
    Report<<"Estimated pre-fishery total abundance x estimated gear selectivity; sel_naa"<<endl;
    Report<<"Year"<<","<<"Age 4"<<","<<"Age 5"<<","<<"Age 6"<<","<<"Age 7"<<","<<"Age 8"<<","<<"Age 9 "<<","<<"Age 10"<<","<<"Age 11"<<","<<"Age 12+"       <<endl;
    for(int n; n<=vsize-2; n++)
    Report<<Year[n+mod_syr]<<","<<sel_naa(n+1,1)<<","<<sel_naa(n+1,2)<<","<<sel_naa(n+1,3)<<","<<sel_naa(n+1,4)<<","<<sel_naa(n+1,5)<<","<<sel_naa(n+1,6     )<<","<<sel_naa(n+1,7)<<","<<sel_naa(n+1,8)<<","<<sel_naa(n+1,9)<<endl;
    Report<<"  "<<endl;
    //Report<<"Estimated mature biomass-at-age (tonnes); est_mat_baa"<<endl;
    //Report<<"Year"<<","<<"Age 4"<<","<<"Age 5"<<","<<"Age 6"<<","<<"Age 7"<<","<<"Age 8"<<","<<"Age 9 "<<","<<"Age 10"<<","<<"Age 11"<<","<<"Age 12+"     <<endl;
    //for(int n; n<=vsize-2; n++)
    //Report<<Year[n+mod_syr]<<","<<est_mat_baa(n+1,1)<<","<<est_mat_baa(n+1,2)<<","<<est_mat_baa(n+1,3)<<","<<est_mat_baa(n+1,4)<<","<<est_mat_baa(n+1     ,5)<<","<<est_mat_baa(n+1,6)<<","<<est_mat_baa(n+1,7)<<","<<est_mat_baa(n+1,8)<<","<<est_mat_baa(n+1,9)<<endl;
    //Report<<"  "<<endl;
    Report<<"obs_c_waa (observed commercial catch weight at age) x est_seine_comp (estimated seine age composition); sel_baa"<<endl;
    Report<<"Year"<<","<<"Age 4"<<","<<"Age 5"<<","<<"Age 6"<<","<<"Age 7"<<","<<"Age 8"<<","<<"Age 9 "<<","<<"Age 10"<<","<<"Age 11"<<","<<"Age 12+"       <<endl;
    for(int n; n<=vsize-2; n++)
    Report<<Year[n+mod_syr]<<","<<sel_baa(n+1,1)<<","<<sel_baa(n+1,2)<<","<<sel_baa(n+1,3)<<","<<sel_baa(n+1,4)<<","<<est_mat_baa(n+1,5)<<","<<sel_baa(n     +1,6)<<","<<sel_baa(n+1,7)<<","<<sel_baa(n+1,8)<<","<<sel_baa(n+1,9)<<endl;
    Report<<"  "<<endl;
    Report<<"Estimated age composition of catch; est_seine_comp"<<endl;
    Report<<"Year"<<","<<"Age 4"<<","<<"Age 5"<<","<<"Age 6"<<","<<"Age 7"<<","<<"Age 8"<<","<<"Age 9 "<<","<<"Age 10"<<","<<"Age 11"<<","<<"Age 12+"       <<endl;
    for(int n; n<=vsize-2; n++)
    Report<<Year[n+mod_syr]<<","<<est_seine_comp(n+1,1)<<","<<est_seine_comp(n+1,2)<<","<<est_seine_comp(n+1,3)<<","<<est_seine_comp(n+1,4)<<","            <<est_seine_comp(n+1,5)<<","<<est_seine_comp(n+1,6)<<","<<est_seine_comp(n+1,7)<<","<<est_seine_comp(n+1,8)<<","<<est_seine_comp(n+1,9)<<endl;
    Report<<"  "<<endl;
    Report<<"Estimated mature age compostion of total run (pre-fishery); est_mat_comp"<<endl;
    Report<<"Year"<<","<<"Age 4"<<","<<"Age 5"<<","<<"Age 6"<<","<<"Age 7"<<","<<"Age 8"<<","<<"Age 9 "<<","<<"Age 10"<<","<<"Age 11"<<","<<"Age 12+"       <<endl;
    for(int n; n<=vsize-2; n++)
    Report<<Year[n+mod_syr]<<","<<est_mat_comp(n+1,1)<<","<<est_mat_comp(n+1,2)<<","<<est_mat_comp(n+1,3)<<","<<est_mat_comp(n+1,4)<<","<<est_mat_comp(n     +1,5)<<","<<est_mat_comp(n+1,6)<<","<<est_mat_comp(n+1,7)<<","<<est_mat_comp(n+1,8)<<","<<est_mat_comp(n+1,9)<<endl;
    Report<<"  "<<endl;
    Report<<"Estimated spawning numbers-at-age (post-fishery); est_sp_naa"<<endl;
    Report<<"Year"<<","<<"Age 4"<<","<<"Age 5"<<","<<"Age 6"<<","<<"Age 7"<<","<<"Age 8"<<","<<"Age 9 "<<","<<"Age 10"<<","<<"Age 11"<<","<<"Age 12+"       <<endl;
    for(int n; n<=vsize-2; n++)
    Report<<Year[n+mod_syr]<<","<<est_sp_naa(n+1,1)<<","<<est_sp_naa(n+1,2)<<","<<est_sp_naa(n+1,3)<<","<<est_sp_naa(n+1,4)<<","<<est_sp_naa(n+1,5)<<","     <<est_sp_naa(n+1,6)<<","<<est_sp_naa(n+1,7)<<","<<est_sp_naa(n+1,8)<<","<<est_sp_naa(n+1,9)<<endl;
    Report<<"  "<<endl;
    Report << "OBSERVED DATA:" <<endl;
    Report<<"tot_obs_catch_tons:"<<","<<"Total observed catch (tons); seine and gillnet harvest combined"<<endl;
    Report<<"tot_obs_catch_seine_tons:"<<","<<"Total observed catch (tons); seine harvest"<<endl;
    Report<<"tot_obs_catch_gillnet_tons:"<<","<<"Total observed catch (tons); gillnet harvest"<<endl;
    Report<<"tot_obs_aerial_tons:"<<","<<"Observed aerial biomass (tons)"<<endl;
    Report<<"tot_obs_aerial_tuned_tons:"<<","<<"Observed aerial biomass (tons)-used in model"<<endl;
    Report<<"wt_aerial:"<<","<<"Observed aerial survey weights"<<endl;
    Report<<"  "<<endl;
    Report<<"Year"<<","<<"tot_obs_catch_tons"<<","<<"tot_obs_catch_seine_tons"<<","<<"tot_obs_catch_gillnet_tons"<<","<<"tot_obs_aerial_tons"<<","<<"tot_obs_aerial_tuned_tons"<<","<<"wt_aerial"<<endl;
    for(int n; n<=vsize-2; n++)
    Report<<Year[n+mod_syr]<<","<<tot_obs_catch_tons[n+1]<<","<<tot_obs_catch_seine_tons[n+1]<<","
    <<tot_obs_catch_gillnet_tons[n+1]<<","<<tot_obs_aerial_tons[n+1]<<","<<tot_obs_aerial_tuned_tons[n+1]<<","<<wt_aerial[n+1]<<endl;
    Report<<"  "<<endl;
    Report.close();
}

void model_parameters::set_runtime(void)
{
  dvector temp1("{5000 5000 5000 5000}");
  maximum_function_evaluations.allocate(temp1.indexmin(),temp1.indexmax());
  maximum_function_evaluations=temp1;
  dvector temp("{0.0001}");
  convergence_criteria.allocate(temp.indexmin(),temp.indexmax());
  convergence_criteria=temp;
}

void model_parameters::report(const dvector& gradients)
{
 adstring ad_tmp=initial_params::get_reportfile_name();
  ofstream report((char*)(adprogram_name + ad_tmp));
  if (!report)
  {
    cerr << "error trying to open report file"  << adprogram_name << ".rep";
    return;
  }
  REPORT(gs_seine);
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
  REPORT(tot_obs_catch_tons);
  REPORT(wt_aerial);
  REPORT(obs_catch_naa);
  REPORT(obs_c_waa);
  REPORT(obs_seine_comp);
  REPORT(tot_obs_catch_seine);
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
  REPORT(for_mat_baa_st);
  REPORT(for_mat_prop);
  REPORT(for_mat_b_prop);
  REPORT(for_mat_B);
  REPORT(for_mat_B_st);
  REPORT(for_tot_mat_N);
  REPORT(yminusfourFOR);
  REPORT(yminusthreeFOR);
  REPORT(yminustwoFOR);
  REPORT(yminusoneFOR);
  REPORT(for_mat_weighted);
  REPORT(for_seine_weighted);
  REPORT(Sur_a);
  REPORT(Sur_b);
  REPORT(AICc);
  REPORT(n_R);
  REPORT(n_M);
  REPORT(n_A);
  REPORT(n);
  REPORT(w_d);
  REPORT(sig_1);
  REPORT(lnL);
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
}

model_data::~model_data()
{}

model_parameters::~model_parameters()
{
  delete pad_evalout;
  pad_evalout = NULL;
}

void model_parameters::final_calcs(void){}

#ifdef _BORLANDC_
  extern unsigned _stklen=10000U;
#endif


#ifdef __ZTC__
  extern unsigned int _stack=10000U;
#endif

  long int arrmblsize=0;

int main(int argc,char * argv[])
{
    ad_set_new_handler();
  ad_exit=&ad_boundf;
  arrmblsize=5000000;
  gradient_structure::set_MAX_NVAR_OFFSET(5000);
  gradient_structure::set_GRADSTACK_BUFFER_SIZE(800000);
  gradient_structure::set_CMPDIF_BUFFER_SIZE(800000);
  gradient_structure::set_NUM_DEPENDENT_VARIABLES(5000);
    gradient_structure::set_NO_DERIVATIVES();
#ifdef DEBUG
  #ifndef __SUNPRO_C
std::feclearexcept(FE_ALL_EXCEPT);
  #endif
#endif
    gradient_structure::set_YES_SAVE_VARIABLES_VALUES();
    if (!arrmblsize) arrmblsize=15000000;
    model_parameters mp(arrmblsize,argc,argv);
    mp.iprint=10;
    mp.preliminary_calculations();
    mp.computations(argc,argv);
#ifdef DEBUG
  #ifndef __SUNPRO_C
bool failedtest = false;
if (std::fetestexcept(FE_DIVBYZERO))
  { cerr << "Error: Detected division by zero." << endl; failedtest = true; }
if (std::fetestexcept(FE_INVALID))
  { cerr << "Error: Detected invalid argument." << endl; failedtest = true; }
if (std::fetestexcept(FE_OVERFLOW))
  { cerr << "Error: Detected overflow." << endl; failedtest = true; }
if (std::fetestexcept(FE_UNDERFLOW))
  { cerr << "Error: Detected underflow." << endl; }
if (failedtest) { std::abort(); } 
  #endif
#endif
    return 0;
}

extern "C"  {
  void ad_boundf(int i)
  {
    /* so we can stop here */
    exit(i);
  }
}
