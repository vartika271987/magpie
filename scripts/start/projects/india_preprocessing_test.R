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
cfg$title <- "india_preprocessing_test"

#Using new preprocessed data with higher number of cells for India

cfg$input <- c("rev4.590806india_test400_4_h12_e9ca3869_cellularmagpie_c400_GFDL-ESM4-ssp370_lpjml-994edd25.tgz",
         "rev4.590806india_test400_4_h12_magpie.tgz",
         "rev4.590806india_test400_4_h12_validation.tgz",
         "calibration_H12_c200_23Feb21.tgz",
         "additional_data_rev4.04.tgz")

 cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL),
                                    getOption("magpie_repos"))

# Should input data be downloaded from source even if cfg$input did not change?
  cfg$force_download <- TRUE

  #start MAgPIE run
  start_run(cfg)

##########################################################################################
