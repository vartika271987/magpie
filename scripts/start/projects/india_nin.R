
# ------------------------------------------------
# description: start run with default.cfg settings
# position: 1
# ------------------------------------------------

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")
source("config/default.cfg")


cfg$title <- "India_nin"

##Input data that contain NIN input files for India
cfg$input <- c(regional    = "rev4.73_3006_indiafood_h12_magpie.tgz",
               cellular    = "rev4.73_3006_indiafood_h12_fd712c0b_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1.tgz",
               validation  = "rev4.73_3006_indiafood_h12_validation.tgz",
               additional  = "additional_data_rev4.25.tgz",
               calibration = "calibration_H12_per_ton_fao_may22_28May22.tgz")
#Download input data
cfg$force_download <- TRUE

#setting exogenous food demand scenario to zero
cfg$gms$c15_exo_foodscen <- "lin_zero_10_50"                    # def = lin_zero_20_50
#switch towards exogenous diet scenario
cfg$gms$s15_exo_diet <- 1               # def = 0

#kcal target
cfg$gms$c15_kcal_scen <- "2100kcal"       # def = healthy_BMI

#food specific diet scenario
cfg$gms$c15_EAT_scen <- "FLX_hmilk"                # def = FLX

#Exogenous scenario applied only for India
cfg$gms$scen_countries15  <- "IND"

#start MAgPIE run
start_run(cfg)
