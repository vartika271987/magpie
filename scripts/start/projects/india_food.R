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
cfg$title <- "3008_indiafoodbaseline"

#New input files from lpjml_addon used
cfg$input <- c(cellular = "isimip_rcp-IPSL_CM5A_LR-rcp2p6-co2_rev52_c200_690d3718e151be1b450b394c1064b1c5.tgz",
         regional = "rev4.61_h12_magpie.tgz",
         validation = "rev4.61_h12_validation.tgz",
         calibration = "calibration_H12_c200_23Feb21.tgz",
         additional = "additional_data_rev4.04.tgz",
         patch = "patch_land_iso.tgz",
          patch = "patch_f38_fac_req_reg.tgz")

cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL,"./patch_inputdata"=NULL),
                                  getOption("magpie_repos"))

# Should input data be downloaded from source even if cfg$input did not change?
  cfg$force_download <- TRUE


  #start MAgPIE run
  start_run(cfg)

##########################################################################################

##Adding a run to restrict water availability in the model for India overall (not including sticky now)
source("scripts/start_functions.R")
source("config/default.cfg")

# short description of the actual run
cfg$title <- "3008_indiafoodssp1"

#New input files from lpjml_addon used
cfg$input <- c(cellular = "isimip_rcp-IPSL_CM5A_LR-rcp2p6-co2_rev52_c200_690d3718e151be1b450b394c1064b1c5.tgz",
         regional = "rev4.61_h12_magpie.tgz",
         validation = "rev4.61_h12_validation.tgz",
         calibration = "calibration_H12_c200_23Feb21.tgz",
         additional = "additional_data_rev4.04.tgz",
         patch = "patch_land_iso.tgz",
          patch = "patch_f38_fac_req_reg.tgz")

cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL,"./patch_inputdata"=NULL),
                                  getOption("magpie_repos"))

# Should input data be downloaded from source even if cfg$input did not change?
  cfg$force_download <- TRUE

  # ***---------------------    09_drivers   ----------------------------------------

  cfg$gms$c09_pop_scenario  <- "SSP1"    # def = SSP2
  cfg$gms$c09_gdp_scenario  <- "SSP1"    # def = SSP2

  #Using SSP1 food scenario only for India hence setting the country name here- this would affect c15_food_scenario_noselect below
  cfg$gms$scen_countries15  <- "IND"

  # * food scenario for selected (and respectively not selected) countries
  # * in scen_countries15
  # *   options:   SSP: "SSP1", "SSP2", "SSP3", "SSP4", "SSP5"
  # *             SRES: "A1", "A2", "B1", "B2"
  # *            OTHER: "PB" (planetary boundaries)
  cfg$gms$c15_food_scenario <- "SSP2"                 # def = SSP2
  cfg$gms$c15_food_scenario_noselect <- "SSP1"        # def = SSP2

  #Setting reduced food waste scenario
  cfg$gms$s15_exo_waste <-1               # def = 0
  cfg$gms$s15_waste_scen <- 1.1          # def = 1.2


  #start MAgPIE run
  start_run(cfg)

##########################################################################################
