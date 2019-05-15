#################################################
#### Preprocessing for MAgPIE 4.0 test runs  ####
#################################################

source("preprocessing.R")

#set defaults
source("config/default.cfg")
def_input <- cfg$input

resolutions<- c("c200")

cfg$regionmapping <- "config/regionmappingSIM4NEXUS_reduced.csv"
for (resolution in resolutions) {
  for (climatescen in c("rcp2p6","rcp4p5","rcp6p0","rcp8p5")){
    for (climatemodel in c("IPSL_CM5A_LR", "GFDL_ESM2M","HadGEM2_ES","MIROC_ESM_CHEM","MIROC5","NorESM1_M")) {
      for (co2 in c("co2","noco2")) {
        cfg$input         <- paste("isimip_rcp", climatemodel, climatescen, co2, sep="/")
        cfg$low_res       <- resolution
        start_preprocessing(cfg)
      }
    }
  }
}

cfg$regionmapping <- "config/regionmappingINMS3.csv"
for (resolution in resolutions) {
  for (climatescen in c("rcp2p6","rcp4p5","rcp6p0","rcp8p5")){
    for (climatemodel in c("IPSL_CM5A_LR")) {
      for (co2 in c("co2")) {
        cfg$input         <- paste("isimip_rcp", climatemodel, climatescen, co2, sep="/")
        cfg$low_res       <- resolution
        start_preprocessing(cfg)
      }
    }
  }
}