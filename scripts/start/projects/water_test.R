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
cfg$title <- "2101_default"


cfg$gms$water_demand<- "agr_sector_aug13"           

cfg$gms$s42_reserved_fraction <- 0.5        


start_run(cfg)
 
##New run with reduced water availability

source("scripts/start_functions.R")
source("config/default.cfg")


# short description of the actual run
cfg$title <- "2101_water_test_global"


cfg$gms$water_demand<- "agr_sector_aug13"           

cfg$gms$s42_reserved_fraction <- 0.2         


start_run(cfg)

