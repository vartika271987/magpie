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
cfg$title <- "BAU_lesswater_nosticky"

#New input files from lpjml_addon used
cfg$input <- c(cellular = "isimip_rcp-IPSL_CM5A_LR-rcp2p6-co2_rev52_c200_690d3718e151be1b450b394c1064b1c5.tgz",
         regional = "rev4.58_h12_magpie.tgz",
         validation = "rev4.58_h12_validation.tgz",
         calibration = "calibration_H12_c200_23Feb21.tgz",
         additional = "additional_data_rev4.04.tgz",
         patch = "patch_land_iso.tgz")

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
cfg$title <- "BAU_lesswater_sticky"

#New input files from lpjml_addon used
cfg$input <- c(cellular = "isimip_rcp-IPSL_CM5A_LR-rcp2p6-co2_rev52_c200_690d3718e151be1b450b394c1064b1c5.tgz",
         regional = "rev4.58_h12_magpie.tgz",
         validation = "rev4.58_h12_validation.tgz",
         calibration = "calibration_H12_c200_23Feb21.tgz",
         additional = "additional_data_rev4.04.tgz",
         patch = "patch_land_iso.tgz")

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
###Factor cost runs with updated irrigation costs

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")
source("config/default.cfg")


# which input data sets should be used?
#New input files from lpjml_addon used
cfg$input <- c(cellular = "isimip_rcp-IPSL_CM5A_LR-rcp2p6-co2_rev52_c200_690d3718e151be1b450b394c1064b1c5.tgz",
         regional = "rev4.58_h12_magpie.tgz",
         validation = "rev4.58_h12_validation.tgz",
         calibration = "calibration_H12_c200_23Feb21.tgz",
         additional = "additional_data_rev4.04.tgz",
         patch = "patch_land_iso.tgz")


#  cfg$input <- c("isimip_rcp-IPSL_CM5A_LR-rcp2p6-co2_rev52_c200_690d3718e151be1b450b394c1064b1c5.tgz",
#                 "rev4.61_h12_magpie.tgz",
#                 "rev4.61_h12_validation.tgz",
#                 "calibration_H12_c200_23Feb21.tgz",
#                 "additional_data_rev4.04.tgz",
#                 "patch_land_iso.tgz",
#                 "patch_f38_fac_req_reg.tgz")

  cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL,"./patch_inputdata"=NULL),
                             getOption("magpie_repos"))

  # Should input data be downloaded from source even if cfg$input did not change?
  cfg$force_download <- TRUE


#Using sticky scenario for factor costs
cfg$gms$factor_costs <- "mixed_feb17"

#Creating a loop to include various iterations of the factor costs increase for all crops


for(i in 1:3) {
  cfg$gms$s38_factor <- i
  cfg$title <- paste0("factor",i,"_","BAU_mixed_fc")
  cfg$results_folder = "output/:title:"
  start_run(cfg)
}
