# |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# ------------------------------------------------
# description: start run with default.cfg with new pre-processing data settings
# position: 1
# ------------------------------------------------



# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")
source("config/default.cfg")

# short description of the actual run
cfg$title <- "lpjml5_test0104"

# which input data sets should be used?

cfg$input <- c("rev4.59vartika_preprocessing_magpie.tgz_h12_024608f1_cellularmagpie.tgz",
               "rev4.59vartika_preprocessing_magpie.tgz_h12_magpie.tgz",
               "rev4.59vartika_preprocessing_magpie.tgz_h12_validation.tgz",
               "calibration_H12_c200_23Feb21.tgz",
               "additional_data_rev3.99.tgz")



#start MAgPIE run
start_run(cfg=cfg)
