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


##Default run with default input data
source("scripts/start_functions.R")
source("config/default.cfg")

# short description of the actual run
cfg$title <- "1802_defaultinputdata"

#New input data as of 8th October used
cfg$input <- c(cellular = "rev4.67_1802_default__h12_fd712c0b_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1.tgz",
         regional = "rev4.67_1802_default__h12_magpie.tgz",
         validation = "rev4.67_1802_default__h12_validation.tgz",
         calibration = "calibration_H12_mixed_feb17_18Jan22.tgz",
         additional = "additional_data_rev4.08.tgz")

cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL),
                                    getOption("magpie_repos"))

# Should input data be downloaded from source even if cfg$input did not change?
  cfg$force_download <- TRUE

start_run(cfg, codeCheck=F)

####Test run with new input data

source("scripts/start_functions.R")
source("config/default.cfg")

# short description of the actual run
cfg$title <- "1802_newinputdata"

#New input data as of 8th October used
cfg$input <- c(cellular = "rev4.67_1802_indiaYields__h12_fd712c0b_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1.tgz",
         regional = "rev4.67_1802_indiaYields__h12_magpie.tgz",
         validation = "rev4.67_1802_indiaYields__h12_validation.tgz",
         calibration = "calibration_H12_mixed_feb17_18Jan22.tgz",
         additional = "additional_data_rev4.08.tgz")

cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL),
                                    getOption("magpie_repos"))

# Should input data be downloaded from source even if cfg$input did not change?
  cfg$force_download <- TRUE

start_run(cfg, codeCheck=F)

##Test run with new input data and new water setting for India
####Test run with new input data

source("scripts/start_functions.R")
source("config/default.cfg")

# short description of the actual run
cfg$title <- "1802_newinputdata_water"

#New input data as of 8th October used
cfg$input <- c(cellular = "rev4.67_1802_indiaYields__h12_fd712c0b_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1.tgz",
         regional = "rev4.67_1802_indiaYields__h12_magpie.tgz",
         validation = "rev4.67_1802_indiaYields__h12_validation.tgz",
         calibration = "calibration_H12_mixed_feb17_18Jan22.tgz",
         additional = "additional_data_rev4.08.tgz")

cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL),
                                    getOption("magpie_repos"))

# Should input data be downloaded from source even if cfg$input did not change?
  cfg$force_download <- TRUE

  cfg$gms$water_demand<- "agr_sector_aug13" # def = all_sectors_aug13
  cfg$gms$c42_watdem_scenario  <- "nocc"   # def = "cc"
  cfg$gms$c42_rf_policy <- "mixed"             # def = "off"
  cfg$gms$s42_shock_year <- 2020                #def = 1995
  cfg$gms$s42_shock_scalar<- 0.4                #def = 0.4

start_run(cfg, codeCheck=F)
