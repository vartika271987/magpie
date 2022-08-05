# |  (C) 2008-2019 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de


# ------------------------------------------------
# description: India tests with input data and water scenarios
# ------------------------------------------------

library(gms)
source("scripts/start_functions.R")
source("config/default.cfg")

# Set defaults
codeCheck <- FALSE

cfg$input <- c(cellular = "rev4.732706_indiaYields_h12_fd712c0b_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1.tgz",
        regional = "rev4.732706_indiaYields_h12_magpie.tgz",
        validation = "rev4.732706_indiaYields_h12_validation.tgz",
        calibration = "calibration_Indiacalibration_473_27Jun22.tgz",
        additional = "additional_data_rev4.26.tgz")

# General settings:
general_settings <- function(title) {

  source("config/default.cfg")

  cfg$info$flag <- "0508"
  cfg$title       <- paste(cfg$info$flag,title,sep="_")
  cfg$results_folder <- "output/:title:"
  cfg$recalibrate <- FALSE
  cfg$qos         <- "priority_"

#Download input data
cfg$force_download <- FALSE

#Setting pumping to 1
cfg$gms$s42_pumping <- 1
#Setting start year as 1995 in default so that the values are set for India
cfg$gms$s42_start_multiplier <- 1995
##Pumping cost value to  0.005
cfg$gms$s42_multiplier <- 1

return(cfg)
}

####################################################################333
###BAU

cfg <- general_settings(title = "BAU")
start_run(cfg = cfg, codeCheck = codeCheck)

####################################################################333
##iCOST 1 CENT

cfg <- general_settings(title = "cost1cent")

cfg$gms$s42_start_multiplier <- 2020
##Pumping cost value to  1 cent
cfg$gms$s42_multiplier <- 2

start_run(cfg, codeCheck=FALSE)

####################################################################333
##iCOST 2 CENT

cfg <- general_settings(title = "cost2cent")

cfg$gms$s42_start_multiplier <- 2020
##Pumping cost value to  1 cent
cfg$gms$s42_multiplier <- 4

start_run(cfg, codeCheck=FALSE)


####################################################################333
##EFP50

cfg <- general_settings(title = "efp50")

cfg$gms$c42_env_flow_policy <- "on"             # def = "off"
cfg$gms$EFP_countries <- "IND" # def = all_iso_countries
cfg$gms$s42_env_flow_scenario <- 1            # def = 2
cfg$gms$s42_env_flow_fraction_new <- 0.5           # def = 0.2
cfg$gms$s42_efp_startyear <- 1995


start_run(cfg, codeCheck=FALSE)

####################################################################333
##EFP60

cfg <- general_settings(title = "efp60")

cfg$gms$c42_env_flow_policy <- "on"             # def = "off"
cfg$gms$EFP_countries <- "IND" # def = all_iso_countries
cfg$gms$s42_env_flow_scenario <- 1            # def = 2
cfg$gms$s42_env_flow_fraction_new <- 0.6           # def = 0.2
cfg$gms$s42_efp_startyear <- 1995


start_run(cfg, codeCheck=FALSE)
