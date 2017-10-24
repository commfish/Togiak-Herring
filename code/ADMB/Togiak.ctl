## -------------------------------------------------------------------------- ##
##
## THIS IS THE CONTROL FILE
## 
## -------------------------------------------------------------------------- ##

## -------------------------------------------------------------------------- ##
## This file controls estimation phases, model years, and blocks for changes 
## to fecundity, maturity-at-age, natural mortality, and gear selectivity.
## -------------------------------------------------------------------------- ##


#Parameter phases
#Initial population (ph_Int)*
1
#Maturity inflection age (ph_mat_a)
1
#Gear selectivity inflection age (ph_gs_a)
1
#Survival (ph_Sur_a)
2
#Maturity slope (ph_mat_b)
2
#Gear selectivity slope age (ph_gs_b)
2
#Survival slope (ph_Sur_b)
3
#Recruitment (ph_Rec)
3

#Ricker spawner-recruit (ph_Ric)
3
#Mile-days coefficient
-3
#

#Objective function weighting (overall weights)
#Purse Seine--catch age comp (lR)
1
#Total Run (lM)
0.5
#Aerial Survey (lA)
0.25

#weights on individual years
# wt_aerial
#
0
1
0
1
0
0
0
0
0
0
0
0
1
1
1
0
0
1
0
1
0
1
0
0
0
1
1
1
1
1
1
0
1
1
1
1
0
0.0000001

#EOF
42


