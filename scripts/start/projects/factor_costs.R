# |  (C) 2008-2019 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de


######################################
#### Script to start a MAgPIE run ####
######################################


##Adding a run to restrict water availability in the model for India overall (not including sticky now)
source("scripts/start_functions.R")
source("config/default.cfg")

# short description of the actual run
cfg$title <- "1106_india_lesswater_nosticky"

cfg$input <- c("isimip_rcp-IPSL_CM5A_LR-rcp2p6-co2_rev52_c200_690d3718e151be1b450b394c1064b1c5.tgz",
         "rev4.58_h12_magpie.tgz",
         "rev4.58_h12_validation.tgz",
         "calibration_H12_c200_23Feb21.tgz",
         "additional_data_rev4.04.tgz",
         "patch_f38_fac_req_reg.tgz")

cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL,"./patch_inputdata"=NULL),
                                  getOption("magpie_repos"))

# Should input data be downloaded from source even if cfg$input did not change?
  cfg$force_download <- TRUE

  # * available for agriculture (only affects agr_sector_aug13 realization)
  #Changing value to ensure 80% water is available for agriculture for India (and all regions)
  cfg$gms$s42_reserved_fraction <- 0.3        # def = 0.5

  #start MAgPIE run
  start_run(cfg)

##########################################################################################


##Adding a run to restrict water availability in the model for India overall (with sticky)
source("scripts/start_functions.R")
source("config/default.cfg")

# short description of the actual run
cfg$title <- "1106_india_lesswater_sticky"

cfg$input <- c("isimip_rcp-IPSL_CM5A_LR-rcp2p6-co2_rev52_c200_690d3718e151be1b450b394c1064b1c5.tgz",
         "rev4.58_h12_magpie.tgz",
         "rev4.58_h12_validation.tgz",
         "calibration_H12_c200_23Feb21.tgz",
         "additional_data_rev4.04.tgz",
         "patch_f38_fac_req_reg.tgz")

cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL,"./patch_inputdata"=NULL),
                                  getOption("magpie_repos"))

# Should input data be downloaded from source even if cfg$input did not change?
  cfg$force_download <- TRUE

  #Using sticky scenario for factor costs
  cfg$gms$factor_costs <- "sticky_feb18"


  # * available for agriculture (only affects agr_sector_aug13 realization)
  #Changing value to ensure 80% water is available for agriculture for India (and all regions)
  cfg$gms$s42_reserved_fraction <- 0.3        # def = 0.5

  #start MAgPIE run
  start_run(cfg)

##########################################################################################
####################################
###OLD FACTOR COST RUNS but with changed input file #####

# Load start_run(cfg) function which is needed to start MAgPIE runs
#source("scripts/start_functions.R")
#source("config/default.cfg")

# short description of the actual run
#cfg$title <- "2704_fc_mixed_default_plus300_exotc"

# which input data sets should be used?


#cfg$input <- c("isimip_rcp-IPSL_CM5A_LR-rcp2p6-co2_rev52_c200_690d3718e151be1b450b394c1064b1c5.tgz",
#         "rev4.58_h12_magpie.tgz",
#         "rev4.58_h12_validation.tgz",
#         "calibration_H12_c200_23Feb21.tgz",
#         "additional_data_rev4.04.tgz",
#         "patch_f38_fac_req_reg.tgz")
#

  # cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL),
  #                               getOption("magpie_repos"))


#  cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL,"./patch_inputdata"=NULL),
#                           getOption("magpie_repos"))


# Should input data be downloaded from source even if cfg$input did not change?
#
# Should an existing output folder be replaced if a new run with the same name is started?
#cfg$force_replace <- TRUE

# Settings for the yield calibration
# * (TRUE): Yield calibration will be performed
# * (ifneeded): Yield calibration will only be executed if input data is
# *             downloaded from repository
# * (FALSE): Yield calibration will not be performed
#cfg$recalibrate <- "TRUE"     # def = "ifneeded"

#Selection of QOS to be used for submitted runs on cluster.
#cfg$qos <- NULL

#Using sticky scenario for factor costs
#cfg$gms$factor_costs <- "mixed_feb17"

# * available for agriculture (only affects agr_sector_aug13 realization)
#Changing value to ensure 80% water is available for agriculture for India (and all regions)
#cfg$gms$s42_reserved_fraction <- 0.2        # def = 0.5

#Changing tc scenario to exogenous
#cfg$gms$tc <- "exo"              # def = endo_jun18


#start MAgPIE run
#start_run(cfg)

##Plus 80% run##
#
# cfg$title <- "fc_plus80_0109"
#
# #Changing the correct input file here
# file.copy("./modules/38_factor_costs/input/f38_fac_req_reg1.csv", "./modules/38_factor_costs/input/f38_fac_req_reg.csv", overwrite = TRUE)
#
# cfg$recalibrate <- "FALSE"     # def = "ifneeded"
#
#
# #start MAgPIE run
# start_run(cfg)

# ##Minus 80% run##
#
# cfg$title <- "fc_minus80_0109"
#
# #Changing the correct input file here
# file.copy("./modules/38_factor_costs/input/f38_fac_req_reg2.csv", "./modules/38_factor_costs/input/f38_fac_req_reg1.csv", overwrite = TRUE)
#
# cfg$recalibrate <- "FALSE"     # def = "ifneeded"
#
#
#
# #start MAgPIE run
# start_run(cfg)
