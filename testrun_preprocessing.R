#################################################
#### Preprocessing for MAgPIE 4.0 test runs  ####
#################################################

source("preprocessing.R")

#set defaults
source("config/default.cfg")

#cellular data
cfg$revision <- 26.2
#regional data (moinput)
cfg$revision2 <- 3.8

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
