# (C) 2008-2016 Potsdam Institute for Climate Impact Research (PIK),
# authors, and contributors see AUTHORS file
# This file is part of MAgPIE and licensed under GNU AGPL Version 3 
# or later. See LICENSE file or go to http://www.gnu.org/licenses/
# Contact: magpie@pik-potsdam.de

########################################################
####Calculates carbon contents for topsoil          ####
####natveg land pool based on LPJ carbon stocks     ####       
########################################################

topsoil <- function(natveg_soilc_layer_file = "/iplex/01/landuse/data/input/lpj_input/GLUES2/sresa2/constant_co2/miub_echo_g/soilc_layer_natveg.bin",
                    out_carbon_topsoil_file = "lpj_carbon_topsoil_0.5.mz",
                    ndigits     = 0,                    # Number of digits in output file
                    start_year  = 1901,                 # Start year of data set
                    years       = c(1995,2005),         # Vector of years that should be exported          
                    nbands      = 5,                    # Number of bands in the .bin file
                    avg_range   = 8){
  require(lpjclass)
  require(magclass)
  require(lucode)
  
  #############################################
  #Read the necessary inputs
  #############################################
  # Transformation factor gC/m^2 --> t/ha
  unit_transform <-0.01
  
  
  ### LPJ Soil layers natveg ###
  natveg_soilc_layer <- readLPJ(file_name=natveg_soilc_layer_file,wyears=years,syear=start_year,averaging_range=avg_range,bands=5,soilcells=TRUE, ncells=67420)
  natveg_soilc_layer <- as.magpie(natveg_soilc_layer)
  natveg_soilc_layer <- natveg_soilc_layer * unit_transform
  natveg_soilc_layer <- natveg_soilc_layer[,,1] + 1/3 * natveg_soilc_layer[,,2]
  getNames(natveg_soilc_layer) <- "soilc_0-30"
  if(any(natveg_soilc_layer<0)){
    natveg_soilc_layer[natveg_soilc_layer<0]<-0
    warning("Some negative soilc_layer values set to 0.")
  } 
  
  
  ####################################################
  #Write the output
  ####################################################
  
  comment <- c(paste("natveg_soilc_layer_file: ", natveg_soilc_layer_file))
  write.magpie(natveg_soilc_layer,file_name=out_carbon_topsoil_file, comment=comment)

}