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


library(gms)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")
source("config/default.cfg")

# short description of the actual run
cfg$title <- "default_lpjtest"

# which input data sets should be used?


#Input files from Edna's script
cfg$input <- c("rev4.58+mrmagpie_LPJmL_new_h12_ee4336a969c590c612a80f2a9db04bdc_cellularmagpie_debug.tgz",
               "rev4.58+mrmagpie_LPJmL_new_h12_magpie_debug.tgz",
               "rev4.58_h12_validation.tgz",
               "additional_data_rev3.99.tgz")

#Input files from Kristine's script
 #cfg$input <- c("rev4.47+mrmagpie7_h12_magpie_debug.tgz",
#                              "rev4.47+mrmagpie7_h12_238dd4e69b15586dde74376b6b84cdec_cellularmagpie_debug.tgz",
#                              "rev4.47+mrmagpie7_h12_validation_debug.tgz",
#                              "additional_data_rev3.85.tgz")

#cfg$recalibrate <- TRUE
cfg$force_download <- TRUE

#cfg$recalc_npi_ndc <- FALSE


#priority
cfg$qos <- "priority"
cfg$output <- c("rds_report")


#start MAgPIE run
start_run(cfg)
