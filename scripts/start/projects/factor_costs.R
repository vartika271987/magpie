# |  (C) 2008-2019 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de


######################################
#### Script to start a MAgPIE run ####
######################################


# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")
source("config/default.cfg")

# short description of the actual run
cfg$title <- "fc_default"

# which input data sets should be used?

cfg$input <- c("isimip_rcp-IPSL_CM5A_LR-rcp2p6-co2_rev48_c200_690d3718e151be1b450b394c1064b1c5.tgz",
         "rev4.52_h12_magpie.tgz",
         "rev4.52_h12_validation.tgz",
         "calibration_H12_c200_26Feb20.tgz",
         "additional_data_rev3.86.tgz",
         "patch_f38_fac_req_reg.tgz")

 cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL,
                                "./patch_inputdata"=NULL),
                           getOption("magpie_repos"))

# Should an existing output folder be replaced if a new run with the same name is started?
#cfg$force_replace <- TRUE

# Settings for the yield calibration
# * (TRUE): Yield calibration will be performed
# * (ifneeded): Yield calibration will only be executed if input data is
# *             downloaded from repository
# * (FALSE): Yield calibration will not be performed
cfg$recalibrate <- "ifneeded"     # def = "ifneeded"

#Using sticky scenario for factor costs
cfg$gms$factor_costs <- "sticky_feb18"

# * available for agriculture (only affects agr_sector_aug13 realization)
#Changing value to ensure 80% water is available for agriculture for India (and all regions)
cfg$gms$s42_reserved_fraction <- 0.2        # def = 0.5


#start MAgPIE run
start_run(cfg)

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
