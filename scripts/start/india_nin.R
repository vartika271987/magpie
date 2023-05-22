
# ------------------------------------------------
# description: test for NIN settings implementation
# position: 1
# ------------------------------------------------

# Load start_run(cfg) function which is needed to start MAgPIE runs
library(gms)
source("scripts/start_functions.R")
source("config/default.cfg")
codeCheck <- FALSE

general_settings <- function(title) {
  source("config/default.cfg")
  ##Downloading new input data
  cfg$force_download <- TRUE
  cfg$info$flag <- "2205"
  cfg$title       <- paste(cfg$info$flag,title,sep="_")
  cfg$results_folder <- "output/:title:"
  cfg$recalibrate <- FALSE

#  cfg$qos         <- "priority_"
  cfg$gms$food <- "anthro_iso_jun22"            # def = anthropometrics_jan18
  #setting exogenous food demand scenario to zero
  cfg$gms$c15_exo_foodscen <- "lin_zero_20_30"                    # def = lin_zero_20_50
  #kcal target
  cfg$gms$c15_kcal_scen <- "2100kcal"       # def = healthy_BMI
  #food specific diet scenario
  cfg$gms$c15_EAT_scen <- "FLX_hmilk"                # def = FLX

return(cfg)
}

#########################################################
#########################################################

cfg <- general_settings(title = "eatall")
##All regions switch to EAT
cfg$gms$s15_exo_diet <- 1               # def = 0
start_run(cfg, codeCheck=FALSE)


#########################################################
#########################################################
cfg <- general_settings(title = "ninindia_eatothers")
##India switches to NIN others EAT
cfg$gms$s15_exo_diet <- 2               # def = 0
start_run(cfg, codeCheck=FALSE)


#########################################################
#########################################################
cfg <- general_settings(title = "ninindia_endoothers")
##India switches to NIN others EAT
cfg$gms$s15_exo_diet <- 2               # def = 0
#Exogenous scenario applied only for India
cfg$gms$scen_countries15  <- "IND"
start_run(cfg, codeCheck=FALSE)

#########################################################
#########################################################
cfg <- general_settings(title = "endoall")
##default settings used
start_run(cfg, codeCheck=FALSE)


#############################################################
#################Trade Scenarios#############################
#############################################################

cfg <- general_settings(title = "High_lib_trade")
cfg$gms$c21_trade_liberalization  <- "l908080r807070"     # def = l909090r808080
start_run(cfg, codeCheck=FALSE)

#########################################################
#########################################################

cfg <- general_settings(title = "NIN_India_EAT_others_High_lib_trade")

cfg$gms$c21_trade_liberalization  <- "l908080r807070"     # def = l909090r808080
cfg$gms$s15_exo_diet <- 2               # def = 0

start_run(cfg, codeCheck=FALSE)

#########################################################
#########################################################

cfg <- general_settings(title = "NIN_India_SSP2_others_High_lib_trade")

cfg$gms$c21_trade_liberalization  <- "l908080r807070"     # def = l909090r808080
cfg$gms$s15_exo_diet <- 2               # def = 0
#Exogenous scenario applied only for India
cfg$gms$scen_countries15  <- "IND"

start_run(cfg, codeCheck=FALSE)

#########################################################
#########################################################


cfg <- general_settings(title = "restricted_trade")
cfg$gms$c21_trade_liberalization  <- "l909595r809090"     # def = l909090r808080
start_run(cfg, codeCheck=FALSE)

#########################################################
#########################################################

cfg <- general_settings(title = "NIN_India_EAT_others_restricted_trade")

cfg$gms$c21_trade_liberalization  <- "l909595r809090"     # def = l909090r808080
cfg$gms$s15_exo_diet <- 2               # def = 0

start_run(cfg, codeCheck=FALSE)

#########################################################
#########################################################

cfg <- general_settings(title = "NIN_India_SSP2_others_restricted_trade")

cfg$gms$c21_trade_liberalization  <- "l909595r809090"     # def = l909090r808080
cfg$gms$s15_exo_diet <- 2               # def = 0
#Exogenous scenario applied only for India
cfg$gms$scen_countries15  <- "IND"

start_run(cfg, codeCheck=FALSE)
