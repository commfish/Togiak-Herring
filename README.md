# Togiak-Herring
Age-structured Togiak herring stock assessment for forecasting biomass.
**Tasks**:  
-[ ] tot-obs-catch is only seine catch; need to add observed gillnet catch  
-[ ] Missing 2016 observed weight at age for purse seine/total run [take average of 2015 and 2017 for value]   -[ ] obs_c_waa: Add 2017 observed weight at age for purse seine/total run to model after provided by Greg  
-[ ] 2016 gillnet age comp missing; Sherri followed pattern down to calculate (can’t just take average from         prior years since strong age classes go through population)  
-[ ] 2018 forecast weight at age (population) [take average of last 2 years]  
-[ ] Method to forecast recruits; Recommend to use the median of last 10 years  
-[ ] Gear selectivity; Need a split between 2000 and 2005 (look at opening schedules to determine when set openings of 20 minutes to unlimited term); one split since the change in fishery was slow; look for most dramatic change in fishery based on data  
-[x] Remove 2000 aerial survey value from model data  
-[x] need to change report output to init_age_4 from init_age_3  
-[x] Average weight across all ages instead of average weight at age for forecast figure  
-[x] Need to differentiate btw parameter estimates and observed data in report so it is easy to tell what is input and output data  
-[x] delete residual output in report but keep residual figures  
-[x] add observed aerial surveys tuned to model in report with column of weighting by year  
-[x] Seine (weight=1); pop. age comp (weight=0.5); aerial (weight=0.25) [new agreed upon weightings for 2018 forecast]  
-[x] Allow gear selectivity in the 2000s and set age-9+=1  
-[x] Maturity; 1992/1993 split and fix age 8+=1 [for 2018 forecast]  
-[x] Survival; Estimate max survival then linear slope decline (current method) and estimate one survival across all years and ages.   
-[x] Estimate gear selectivity as matrix in model instead of vectors  
-[x] Estimate survival as matrix in model instead of vectors  
-[x] Add past forecasts to graphics file  
-[x] Fix excel report with figures and data output  