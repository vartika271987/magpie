# |  (C) 2008-2019 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de


######################################
#### Script to start a MAgPIE run ####
######################################



source("scripts/start_functions.R")
source("config/default.cfg")

# short description of the actual run
cfg$title <- "0311_default"

#Using new preprocessed data with higher number of cells for India

cfg$input <- c("rrev4.64_0311_default__h12_477f2095_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-4b917a03.tgz",
                "rev4.64_0311_default__h12_magpie.tgz",
                 "rev4.64_0311_default__h12_validation.tgz",
                 "calibration_H12_c200_23Feb21.tgz",
                 "additional_data_rev4.04.tgz",
                 "patch_cropland.tgz")

cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL,"./patch_inputdata"=NULL),
                           getOption("magpie_repos"))

# Should input data be downloaded from source even if cfg$input did not chan
cfg$force_download <- TRUE

#recalibrating as new input files are used
cfg$recalibrate <- "TRUE"     # def = "ifneeded"

#start MAgPIE run
start_run(cfg)

##########################################################################################
source("scripts/start_functions.R")
source("config/default.cfg")

# short description of the actual run
cfg$title <- "0311_indiamapping"

#UDefault input files

cfg$input <- c("rev4.64_0311_india__d55d81d9_477f2095_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-4b917a03.tgz",
                "rev4.64_0311_india__d55d81d9_magpie.tgz",
                "rev4.64_0311_india__d55d81d9_validation.tgz",
               "calibration_H12_c200_23Feb21.tgz",
               "additional_data_rev4.04.tgz",
               "patch_cropland.tgz")

cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL,"./patch_inputdata"=NULL),
                           getOption("magpie_repos"))

# Should input data be downloaded from source even if cfg$input did not change?
cfg$force_download <- TRUE

cfg$recalibrate <- "TRUE"     # def = "ifneeded"

#start MAgPIE run
start_run(cfg)

##########################################################################################
source("scripts/start_functions.R")
source("config/default.cfg")

# short description of the actual run
cfg$title <- "0311_indiamapping_weighted"

#UDefault input files

cfg$input <- c("rev4.64_0311_india_weighted__d55d81d9_a44fce12_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-4b917a03_clusterweight-e12c6af2.tgz",
                "rev4.64_0311_india_weighted__d55d81d9_magpie.tgz",
                 "rev4.64_0311_india_weighted__d55d81d9_validation.tgz",
                 "calibration_H12_c200_23Feb21.tgz",
                 "additional_data_rev4.04.tgz",
                 "patch_cropland.tgz")

cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL,"./patch_inputdata"=NULL),
                           getOption("magpie_repos"))

# Should input data be downloaded from source even if cfg$input did not change?
cfg$force_download <- TRUE

cfg$recalibrate <- "TRUE"     # def = "ifneeded"

#start MAgPIE run
start_run(cfg)

##########################################################################################
