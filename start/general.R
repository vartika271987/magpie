#################################################
#### Preprocessing for MAgPIE 4.0 test runs  ####
#################################################

source("preprocessing.R")

#set defaults
source("config/default.cfg")

#cellular data
cfg$revision <- 30
#regional data (moinput)
cfg$revision2 <- 4.00

for (resolution in c("h200")) {
  for (regionmapping in c("H11","CAPRI18", "SIM4NEXUS")) {
    for (climatescen in c("rcp2p6","rcp4p5","rcp6p0","rcp8p5")){
      for (climatemodel in c("IPSL_CM5A_LR")) {
        for (co2 in c("noco2","co2")) {
          cfg$low_res       <- resolution
          cfg$regionmapping <- paste0("config/regionmapping", regionmapping, ".csv")
          cfg$input         <- paste("isimip_rcp", climatemodel, climatescen, co2, sep="/")
          start_preprocessing(cfg)
        }
      }
    }
  }
}





