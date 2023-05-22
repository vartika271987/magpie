
# ------------------------------------------------
# description: test for NIN settings implementation
# position: 1
# ------------------------------------------------

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")
source("config/default.cfg")


cfg$title <- "2205_eatall"

#Download input data
cfg$force_download <- TRUE

#setting exogenous food demand scenario to zero
cfg$gms$c15_exo_foodscen <- "lin_zero_20_30"                    # def = lin_zero_20_50
#kcal target
cfg$gms$c15_kcal_scen <- "2100kcal"       # def = healthy_BMI
#food specific diet scenario
cfg$gms$c15_EAT_scen <- "FLX_hmilk"                # def = FLX

##All regions switch to EAT
cfg$gms$s15_exo_diet <- 1               # def = 0
#start MAgPIE run
start_run(cfg)

#########################################################
#########################################################
#########################################################


source("config/default.cfg")
cfg$title <- "2205_ninindia_eatothers"

#setting exogenous food demand scenario to zero
cfg$gms$c15_exo_foodscen <- "lin_zero_20_30"                    # def = lin_zero_20_50
#kcal target
cfg$gms$c15_kcal_scen <- "2100kcal"       # def = healthy_BMI
#food specific diet scenario
cfg$gms$c15_EAT_scen <- "FLX_hmilk"                # def = FLX

##India switches to NIN others EAT
cfg$gms$s15_exo_diet <- 2               # def = 0
#start MAgPIE run
start_run(cfg)


#########################################################
#########################################################
#########################################################

source("config/default.cfg")

cfg$title <- "2205_ninindia_endoothers"
#setting exogenous food demand scenario to zero
cfg$gms$c15_exo_foodscen <- "lin_zero_20_30"                    # def = lin_zero_20_50
#kcal target
cfg$gms$c15_kcal_scen <- "2100kcal"       # def = healthy_BMI
#food specific diet scenario
cfg$gms$c15_EAT_scen <- "FLX_hmilk"                # def = FLX

##Only India switches to NIN, others endo
cfg$gms$s15_exo_diet <- 2               # def = 0
#Exogenous scenario applied only for India
cfg$gms$scen_countries15  <- "IND"

#start MAgPIE run
start_run(cfg)


#########################################################
#########################################################
#########################################################

source("config/default.cfg")

cfg$title <- "2205_endoall"

#setting exogenous food demand scenario to zero
cfg$gms$c15_exo_foodscen <- "lin_zero_20_30"                    # def = lin_zero_20_50
#kcal target
cfg$gms$c15_kcal_scen <- "2100kcal"       # def = healthy_BMI
#food specific diet scenario
cfg$gms$c15_EAT_scen <- "FLX_hmilk"                # def = FLX


#start MAgPIE run
start_run(cfg)
