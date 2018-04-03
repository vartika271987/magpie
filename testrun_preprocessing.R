#################################################
#### Preprocessing for MAgPIE 4.0 test runs  ####
#################################################

source("preprocessing.R")

#set defaults
source("config/default.cfg")

cfg$nocores <- 10

#cellular data
cfg$revision <- 29
#regional data (moinput)
cfg$revision2 <- 3.13

cfg$regionmapping <- "config/regionmappingH11.csv"
cfg$low_res <- "h200"
start_preprocessing(cfg)

cfg$regionmapping <- "config/regionmappingH12.csv"
start_preprocessing(cfg)

cfg$regionmapping <- "config/regionmappingMAgPIE.csv"
start_preprocessing(cfg)

cfg$regionmapping <- "config/regionmappingBRA.csv"
start_preprocessing(cfg)

cfg$regionmapping <- "config/regionmappingH11.csv"

for(i in c("h100","h600","h1000","h2000","n200","n100")){
  cfg$low_res <- i
  start_preprocessing(cfg)
}

cfg$input <- "isimip_rcp/IPSL_CM5A_LR/rcp2p6/co2"
start_preprocessing(cfg)


