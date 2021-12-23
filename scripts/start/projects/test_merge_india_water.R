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
cfg$title <- "2312_testrun_indiawater"

#New input data as of 8th October used
cfg$input <- c(regional    = "rev4.65_h12_magpie.tgz",
               cellular    = "rev4.65_h12_1998ea10_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1.tgz",
               validation  = "rev4.65_h12_validation.tgz",
               additional  = "additional_data_rev4.07.tgz",
               calibration = "calibration_H12_sticky_feb18_free_30Nov21.tgz",
                patch = "patch_land_iso.tgz",
                patch = "patch_f38_fac_req_reg.tgz")

cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL,"./patch_inputdata"=NULL),
                                  getOption("magpie_repos"))

# Should input data be downloaded from source even if cfg$input did not change?
  cfg$force_download <- TRUE

  #Using mixed regional scenario for factor costs
  cfg$gms$factor_costs <- "mixed_reg_feb17"

# Test if irrigation settings are applied for India, before and after shock year
  cfg$gms$s42_shock_year <- 2020

#Test for scalar factor for factor costs if it is applied for India
  cfg$gms$s38_shock_year <- 2020
  cfg$gms$s38_factor <- 2

  #loading libraries to run manipulate file function
  library('magpie4')
  library('lucode2')
  manipulateFile("/p/projects/landuse/users/vasingh/develop/magpie/modules/38_factor_costs/mixed_reg_feb17/presolve.gms",
                c("p38_fac_req(i,kcr,w) = f38_fac_req(i,kcr,w) * s38_factor;" , "p38_fac_req(\"IND\",kcr,w) = f38_fac_req(\"IND\",kcr,w) * s38_factor;"), fixed=T)


start_run(cfg)
