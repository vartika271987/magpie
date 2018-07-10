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

for (resolution in c("h200", "h500", "n500")) {
  for (climatescen in c("rcp2p6","rcp4p5","rcp6p0","rcp8p5")){
    for (climatemodel in c("IPSL_CM5A_LR")) {
      for (co2 in c("co2")) {
        cfg$input         <- paste("isimip_rcp", climatemodel, climatescen, co2, sep="/")
        cfg$low_res       <- resolution
          
        cfg$regionmapping <- "H12"
        start_preprocessing(cfg)
        
        cfg$regionmapping <- "H11"
        start_preprocessing(cfg)
          
        cfg$regionmapping <- "CAPRI18"
        start_preprocessing(cfg)
          
        cfg$regionmapping <- "SIM4NEXUS"
        start_preprocessing(cfg)
        
        cfg$regionmapping <- "TRADEBRA"
        cfg$cluster_weight <- c(BRA=18, LAM=2.6, ROW=0.1)
        start_preprocessing(cfg)
        
        cfg$regionmapping <- "TRADEBRA"
        cfg$cluster_weight <- c(BRA=6, ROW=0.7)
        start_preprocessing(cfg)
      }
    }
  }
}





