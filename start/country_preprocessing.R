#################################################
#### Preprocessing for MAgPIE 4.0 test runs  ####
#################################################

source("preprocessing.R")

#set defaults
source("config/default.cfg")

cfg$nocores <- 10

#cellular data
cfg$revision <- 30
#regional data (moinput)
cfg$revision2 <- 3.19

cfg$regionmapping <- "config/regionmappingCHA.csv"
cfg$cluster_weight <- c(CHA=3)
start_preprocessing(cfg)

cfg$regionmapping <- "config/regionmappingIND.csv"
cfg$cluster_weight <- c(IND=3)
start_preprocessing(cfg)

cfg$regionmapping <- "config/regionmappingAUS.csv"
cfg$cluster_weight <- c(AUS=3)
start_preprocessing(cfg)

cfg$regionmapping <- "config/regionmappingUSA.csv"
cfg$cluster_weight <- c(USA=3)
start_preprocessing(cfg)

cfg$regionmapping <- "config/regionmappingBRA2.csv"
cfg$cluster_weight <- c(BRA=3)
start_preprocessing(cfg)

cfg$regionmapping <- "config/regionmappingETH.csv"
cfg$cluster_weight <- c(ETH=3)
start_preprocessing(cfg)
