# |  (C) 2008-2019 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de


# ------------------------------------------------
# description: India tests with input data and water scenarios
# ------------------------------------------------

######################################
#### Script to start a MAgPIE run ####
######################################

##Tests as of 7 July

####################################################################333
##Default India data run

source("scripts/start_functions.R")
source("config/default.cfg")

# short description of the actual run
cfg$title <- "0707_default"

#Input data files to be used for India-specific analysis
cfg$input <- c(cellular = "rev4.732706_indiaYields_h12_fd712c0b_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1.tgz",
        regional = "rev4.732706_indiaYields_h12_magpie.tgz",
        validation = "rev4.732706_indiaYields_h12_validation.tgz",
        calibration = "calibration_Indiacalibration_473_27Jun22.tgz",
        additional = "additional_data_rev4.26.tgz")


cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL),
                           getOption("magpie_repos"))

#Download input data
cfg$force_download <- TRUE

#Setting pumping to 1
cfg$gms$s42_pumping <- 1
#Setting shock years from when policy shocks will be implemented
cfg$gms$s42_multiplier_startyear <- 2020
##Pumping cost value to  0.005
cfg$gms$s42_multiplier <- 1

start_run(cfg, codeCheck=FALSE)


##iCOST 1 CENT
source("scripts/start_functions.R")
source("config/default.cfg")

# short description of the actual run
cfg$title <- "0707_cost1cent"

#Input data files to be used for India-specific analysis
cfg$input <- c(cellular = "rev4.732706_indiaYields_h12_fd712c0b_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1.tgz",
        regional = "rev4.732706_indiaYields_h12_magpie.tgz",
        validation = "rev4.732706_indiaYields_h12_validation.tgz",
        calibration = "calibration_Indiacalibration_473_27Jun22.tgz",
        additional = "additional_data_rev4.26.tgz")


cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL),
                           getOption("magpie_repos"))


#Setting pumping to 1
cfg$gms$s42_pumping <- 1
#Setting shock years from when policy shocks will be implemented
 cfg$gms$s42_multiplier_startyear <- 2020
##Pumping cost value to  1 cent
cfg$gms$s42_multiplier <- 2

start_run(cfg, codeCheck=FALSE)


####################################################################333
##iCOST 2 CENT
source("scripts/start_functions.R")
source("config/default.cfg")

# short description of the actual run
cfg$title <- "0707_cost2cent"

#Input data files to be used for India-specific analysis
cfg$input <- c(cellular = "rev4.732706_indiaYields_h12_fd712c0b_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1.tgz",
        regional = "rev4.732706_indiaYields_h12_magpie.tgz",
        validation = "rev4.732706_indiaYields_h12_validation.tgz",
        calibration = "calibration_Indiacalibration_473_27Jun22.tgz",
        additional = "additional_data_rev4.26.tgz")


cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL),
                           getOption("magpie_repos"))


#Setting pumping to 1
cfg$gms$s42_pumping <- 1
#Setting shock years from when policy shocks will be implemented
 cfg$gms$s42_multiplier_startyear <- 2020
##Pumping cost value to  1 cent
cfg$gms$s42_multiplier <- 4

start_run(cfg, codeCheck=FALSE)

####################################################################333
##EFP 20% with pumping cost to check if this can be made default

source("scripts/start_functions.R")
source("config/default.cfg")

# short description of the actual run
cfg$title <- "0707_efp20_costhalfcent"

#Setting shock years from when policy shocks will be implemented
cfg$gms$s42_shockyear <- 2020

cfg$gms$c42_env_flow_policy <- "mixed"             # def = "off"
cfg$gms$EFP_countries <- "IND" # def = all_iso_countries
cfg$gms$s42_env_flow_scenario <- 1            # def = 2
cfg$gms$s42_env_flow_fraction <- 0.2           # def = 0.2


#Input data files to be used for India-specific analysis
cfg$input <- c(cellular = "rev4.732706_indiaYields_h12_fd712c0b_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1.tgz",
        regional = "rev4.732706_indiaYields_h12_magpie.tgz",
        validation = "rev4.732706_indiaYields_h12_validation.tgz",
        calibration = "calibration_Indiacalibration_473_27Jun22.tgz",
        additional = "additional_data_rev4.26.tgz")


cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL),
                           getOption("magpie_repos"))

start_run(cfg, codeCheck=FALSE)

####################################################################333
##EFP 50%

source("scripts/start_functions.R")
source("config/default.cfg")

# short description of the actual run
cfg$title <- "0707_efp_50percent"

#Setting shock years from when policy shocks will be implemented
cfg$gms$s42_shockyear <- 2020

cfg$gms$c42_env_flow_policy <- "mixed"             # def = "off"
cfg$gms$EFP_countries <- "IND" # def = all_iso_countries
cfg$gms$s42_env_flow_scenario <- 1            # def = 2
cfg$gms$s42_env_flow_fraction <- 0.5           # def = 0.2


#Input data files to be used for India-specific analysis
cfg$input <- c(cellular = "rev4.732706_indiaYields_h12_fd712c0b_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1.tgz",
        regional = "rev4.732706_indiaYields_h12_magpie.tgz",
        validation = "rev4.732706_indiaYields_h12_validation.tgz",
        calibration = "calibration_Indiacalibration_473_27Jun22.tgz",
        additional = "additional_data_rev4.26.tgz")


cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL),
                           getOption("magpie_repos"))

start_run(cfg, codeCheck=FALSE)

####################################################################333
##EFP 60%

source("scripts/start_functions.R")
source("config/default.cfg")

# short description of the actual run
cfg$title <- "0707_efp_60percent"

#Setting shock years from when policy shocks will be implemented
cfg$gms$s42_shockyear <- 2020

cfg$gms$c42_env_flow_policy <- "mixed"             # def = "off"
cfg$gms$EFP_countries <- "IND" # def = all_iso_countries
cfg$gms$s42_env_flow_scenario <- 1            # def = 2
cfg$gms$s42_env_flow_fraction <- 0.6           # def = 0.2

#Input data files to be used for India-specific analysis
cfg$input <- c(cellular = "rev4.732706_indiaYields_h12_fd712c0b_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1.tgz",
        regional = "rev4.732706_indiaYields_h12_magpie.tgz",
        validation = "rev4.732706_indiaYields_h12_validation.tgz",
        calibration = "calibration_Indiacalibration_473_27Jun22.tgz",
        additional = "additional_data_rev4.26.tgz")

cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL),
                           getOption("magpie_repos"))

start_run(cfg, codeCheck=FALSE)
