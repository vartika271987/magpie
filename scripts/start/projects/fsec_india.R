# |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

################################################################################
# Define internal functions
################################################################################

library(gms)
source("scripts/start_functions.R")
source("scripts/projects/fsec.R")

codeCheck <- FALSE


for (scenarioName in c(
  # Scenario combination runs
  "c_BAU",   "e_FSDP", "b_WaterSoil",  "b_AllClimate",  "b_AllEnvironment", "b_AllHealth", "b_AllInclusion",
  "b_Efficiency")) {

    # Start runs
    cfg <- fsecScenario(scenario = scenarioName)
    start_run(cfg = cfg, codeCheck = codeCheck)

  }
