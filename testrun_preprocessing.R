#################################################
#### Preprocessing for MAgPIE 4.0 test runs  ####
#################################################

source("preprocessing.R")

#set defaults
source("config/default.cfg")

#cellular data
cfg$revision <- 23.1
#regional data (moinput)
cfg$revision2 <- 2.5

cfg$regionmapping <- "config/regionmappingH11.csv"
cfg$low_res <- "h200"
start_preprocessing(cfg)

cfg$regionmapping <- "config/regionmappingH12.csv"
start_preprocessing(cfg)

cfg$regionmapping <- "config/regionmappingMAgPIE.csv"
start_preprocessing(cfg)

cfg$regionmapping <- "config/regionmappingH11.csv"
cfg$low_res <- "n200"
start_preprocessing(cfg)

cfg$regionmapping <- "config/regionmappingH11.csv"
cfg$low_res <- "n100"
start_preprocessing(cfg)

cfg$regionmapping <- "config/regionmappingH11.csv"
cfg$low_res <- "h100"
start_preprocessing(cfg)

