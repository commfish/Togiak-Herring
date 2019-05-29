source("code/R/helper.R")

#setwd(file.path(getwd(), "2019_forecast/Results/model.6_122_best/Ricker_weights/Ricker_0.0001/ADMB"))
setwd("S:/Region1Shared-DCF/Research/Herring-Dive Fisheries/Herring/Togiak/Togiak Stock Assessment/2018 forecast/code/ADMB")
# Running model in R
setup_admb("c:/admb/admb120-gcc493-win64")
compile_admb("model", verbose = TRUE)
run_admb("model", verbose = TRUE) 

## compile model
compile_admb("model", verbose=TRUE)
## run MAP
run_admb("model")

# Running her model in command line
# 1) Open command prompt ("C:/ADMB/ADMB Command Prompt (MinGW 64Bit)")
# 2) Navigate to AlaskaHerring deep inside S drive using 
# > cd ../..
# > S:
# > cd "S:\Region1Shared-DCF\Research\Herring-Dive Fisheries\Herring\ADMB Rudd Workshop 2018\AlaskaHerring\HER"
# Compile
# > admb her 
# Run
# > her