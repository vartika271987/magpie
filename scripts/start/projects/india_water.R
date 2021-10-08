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
#cfg$title <- "2408_BAU_80_water_baseline"

#New input data as of 8th October used
cfg$input <- c(cellular = "rev4.63_h12_a3fb0fc7_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-066f36d1.tgz",
         regional = "rev4.63_h12_magpie.tgz",
         validation = "rev4.63_h12_validation.tgz",
         calibration = "calibration_H12_sticky_feb18_free_31Aug21.tgz",
         additional = "additional_data_rev4.04.tgz",
         patch = "patch_land_iso.tgz",
          patch = "patch_f38_fac_req_reg.tgz")

cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL,"./patch_inputdata"=NULL),
                                  getOption("magpie_repos"))

# Should input data be downloaded from source even if cfg$input did not change?
  cfg$force_download <- TRUE

  #Using mixed regional scenario for factor costs
  cfg$gms$factor_costs <- "mixed_reg_feb17"

## 3 different water levels with ssp2 food demand
  for (i in 0:2) {
    cfg$gms$reg_water_switch <- i

    if (i ==0) {
      cfg$title <- "0810_baseline"
    }

    else if (i ==1) {
    cfg$title <- "0810_reduced_water70"
    }

    else if (i ==2) {
    cfg$title <- "0810_reduced_water60"
    }
    start_run(cfg)
  }

  ## 3 different water levels with ssp1 food demand, gdp, population and reduced waste

  for (i in 0:2) {

    cfg$gms$c09_pop_scenario  <- "SSP1"    # def = SSP2
    cfg$gms$c09_gdp_scenario  <- "SSP1"    # def = SSP2

    #Using SSP1 food scenario only for India hence setting the country name here- this would affect c15_food_scenario_noselect below
    cfg$gms$scen_countries15  <- "IND"
    cfg$gms$c15_food_scenario <- "SSP2"                 # def = SSP2
    cfg$gms$c15_food_scenario_noselect <- "SSP1"        # def = SSP2

    #Setting reduced food waste scenario
    cfg$gms$s15_exo_waste <-1               # def = 0
    cfg$gms$s15_waste_scen <- 1.1          # def = 1.2

    cfg$gms$reg_water_switch <- i
    if (i ==0) {
      cfg$title <- "0810_baseline_ssp1"
    }

    else if (i ==1) {
    cfg$title <- "0810_reduced_water70_ssp1"
    }

    else if (i ==2) {
    cfg$title <- "0810_reduced_water60_ssp1"
    }
    start_run(cfg)
  }



####################################
###Factor cost runs with updated irrigation costs


# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")
source("config/default.cfg")

cfg$input <- c(cellular = "rev4.63_h12_a3fb0fc7_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-066f36d1.tgz",
         regional = "rev4.63_h12_magpie.tgz",
         validation = "rev4.63_h12_validation.tgz",
         calibration = "calibration_H12_sticky_feb18_free_31Aug21.tgz",
         additional = "additional_data_rev4.04.tgz",
         patch = "patch_land_iso.tgz",
          patch = "patch_f38_fac_req_reg.tgz")


# which input data sets should be used?
#New input files from lpjml_addon used
#cfg$input <- c(cellular = "isimip_rcp-IPSL_CM5A_LR-rcp2p6-co2_rev52_c200_690d3718e151be1b450b394c1064b1c5.tgz",
#         regional = "rev4.61_h12_magpie.tgz",
#         validation = "rev4.61_h12_validation.tgz",
#         calibration = "calibration_H12_c200_23Feb21.tgz",
#         additional = "additional_data_rev4.04.tgz",
#         patch = "patch_land_iso.tgz",
#          patch = "patch_f38_fac_req_reg.tgz")



  cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL,"./patch_inputdata"=NULL),
                             getOption("magpie_repos"))

  # Should input data be downloaded from source even if cfg$input did not change?
  cfg$force_download <- TRUE


#Using sticky scenario for factor costs
cfg$gms$factor_costs <- "mixed_reg_feb17"

# * available for agriculture (only affects agr_sector_aug13 realization)
#Changing value to ensure 80% water is available for agriculture for India (and all regions)
cfg$gms$reg_water_switch <- 0        # def = 0 where it will take 0.8 for India


#Iterations of factor costs in ssp2 food demand setting
for(i in seq(1, 2, by = 0.5)) {
  cfg$gms$s38_factor <- i
  cfg$title <- paste0("0810","_","factor",i,"_","ssp2")
  cfg$results_folder = "output/:title:"
  start_run(cfg)
}

#Iterations of factor costs in ssp1 food, gdp, population demand setting
for(i in seq(1, 2, by = 0.5)) {

  cfg$gms$c09_pop_scenario  <- "SSP1"    # def = SSP2
  cfg$gms$c09_gdp_scenario  <- "SSP1"    # def = SSP2

  #Using SSP1 food scenario only for India hence setting the country name here- this would affect c15_food_scenario_noselect below
  cfg$gms$scen_countries15  <- "IND"
  cfg$gms$c15_food_scenario <- "SSP2"                 # def = SSP2
  cfg$gms$c15_food_scenario_noselect <- "SSP1"        # def = SSP2

  #Setting reduced food waste scenario
  cfg$gms$s15_exo_waste <-1               # def = 0
  cfg$gms$s15_waste_scen <- 1.1          # def = 1.2

  #Varying values of factor_costs
  cfg$gms$s38_factor <- i
  cfg$title <- paste0("0810","_","factor",i,"_","ssp1")
  cfg$results_folder = "output/:title:"
  start_run(cfg)
}
