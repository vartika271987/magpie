#################################################
#### Script to start a MAgPIE preprocessing  ####
#################################################

library(lucode)

source("preprocessing.R")

#set defaults
config <- "default.cfg"

#defaults are overwritten if specified as argument
readArgs("config")

#start MAgPIE run
start_preprocessing(cfg=config,debug=TRUE)
