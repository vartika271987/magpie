#################################################
#### Preprocessing for MAgPIE 4.0 test runs  ####
#################################################

source("preprocessing.R")

#set defaults
source("config/default.cfg")
def_input <- cfg$input

for (resolution in c("h200")) {
  for (climatescen in c("rcp2p6","rcp4p5","rcp6p0","rcp8p5")){
    for (climatemodel in c("IPSL_CM5A_LR")) {
      for (co2 in c("co2")) {
        cfg$input         <- paste("isimip_rcp", climatemodel, climatescen, co2, sep="/")
        cfg$low_res       <- resolution
        cfg$regionmapping <- "H12"
        start_preprocessing(cfg)
      }
    }
  }
}

#FABLE
cfg$input <- def_input
cfg$low_res       <- "h200"
cfg$cluster_weight <- 4
for(reg in c("AUS","BRA2","CHA","ETH","IDN","IND","USA")) {
  cfg$regionmapping <- reg
  names(cfg$cluster_weight) <- substr(reg,1,3)
  start_preprocessing(cfg)
}

#MAgPIE-Brazil
cfg$input <- def_input
cfg$regionmapping <- "TRADEBRA"
cfg$low_res       <- "n500"
cfg$cluster_weight <- c(BRA=18, LAM=2.6, ROW=0.1)
start_preprocessing(cfg)
cfg$low_res       <- "h500"
cfg$cluster_weight <- c(BRA=6, ROW=0.7)
start_preprocessing(cfg)
