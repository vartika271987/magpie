#################################################
#### Preprocessing for MAgPIE 4.0 test runs  ####
#################################################

source("preprocessing.R")

#set defaults
source("config/default.cfg")

cfg$low_res <- "h200"
cfg$regionmapping <- "config/regionmappingH12.csv"

cfg$input <- "isimip_rcp/IPSL_CM5A_LR/rcp2p6/noco2"
start_preprocessing(cfg)

cfg$input <- "isimip_rcp/IPSL_CM5A_LR/rcp2p6/co2"
start_preprocessing(cfg)

cfg$input <- "isimip_rcp/IPSL_CM5A_LR/rcp6p0/noco2"
start_preprocessing(cfg)

cfg$input <- "isimip_rcp/IPSL_CM5A_LR/rcp6p0/co2"
start_preprocessing(cfg)
