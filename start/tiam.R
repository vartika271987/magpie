#################################################
#### Script to start a MAgPIE preprocessing  ####
#################################################

library(lucode)

source("preprocessing.R")

#set defaults
source("config/default.cfg")

cfg$regionmapping <- "config/regionmappingTIAMVE.csv"


#start MAgPIE run
start_preprocessing(cfg)
