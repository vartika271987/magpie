# |  (C) 2008-2019 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de


######################################
#### Script to start a MAgPIE run ####
######################################


##Adding a run to check food demand scenarios 

source("scripts/start_functions.R")
source("config/default.cfg")


# Should input data be downloaded from source even if cfg$input did not change?
cfg$force_download <- TRUE



for (pol in c("baseline","ssp1")) {
  if (pol == "baseline") {
  cfg$title <- "baseline"
  } else if (pol == "ssp1") {
    cfg$gms$c09_pop_scenario  <- "SSP1"    # def = SSP2
    cfg$gms$c09_gdp_scenario  <- "SSP1"    # def = SSP2
    
    #Using SSP1 food scenario only for India hence setting the country name here- this would affect c15_food_scenario_noselect below
    cfg$gms$scen_countries15  <- "IND"
    cfg$gms$c15_food_scenario <- "SSP2"                 # def = SSP2
    cfg$gms$c15_food_scenario_noselect <- "SSP1"        # def = SSP2
    
    #Setting reduced food waste scenario
    cfg$gms$s15_exo_waste <-1               # def = 0
    cfg$gms$s15_waste_scen <- 1.1          # def = 1.2
    cfg$title <- "india_ssp1"
  } 
 
  start_run(cfg,codeCheck=FALSE)
}



