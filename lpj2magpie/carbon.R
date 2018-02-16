# (C) 2008-2016 Potsdam Institute for Climate Impact Research (PIK),
# authors, and contributors see AUTHORS file
# This file is part of MAgPIE and licensed under GNU AGPL Version 3 
# or later. See LICENSE file or go to http://www.gnu.org/licenses/
# Contact: magpie@pik-potsdam.de

########################################################
####Calculates maximum carbon contents for          ####
####all magpie land pools based on LPJ carbon stocks####       
########################################################

carbon <- function(natveg_vegc_file       = "/iplex/01/landuse/data/input/lpj_input/GLUES2/sresa2/constant_co2/miub_echo_g/vegc_natveg.bin",
                   natveg_soilc_file      = "/iplex/01/landuse/data/input/lpj_input/GLUES2/sresa2/constant_co2/miub_echo_g/soilc_natveg.bin",
                   natveg_soilc_layer_file = "/iplex/01/landuse/data/input/lpj_input/GLUES2/sresa2/constant_co2/miub_echo_g/soilc_layer_natveg.bin",
                   natveg_litc_file       = "/iplex/01/landuse/data/input/lpj_input/GLUES2/sresa2/constant_co2/miub_echo_g/litc_natveg.bin",
                   c_share_released_file  = "/iplex/01/landuse/data/input/other/rev17/cshare_released_0.5.mz",
                   pastc_file             = "/iplex/01/landuse/data/input/other/rev17/lpj_carbon_pasture_0.5.mz",
                   out_carbon_stocks_file = "lpj_carbon_stocks_0.5.mz",
                   ndigits     = 0,                    # Number of digits in output file
                   start_year  = 1901,                 # Start year of data set
                   years       = c(1995,2005),         # Vector of years that should be exported          
                   nbands      = 1,                    # Number of bands in the .bin file
                   avg_range   = 8){
  require(lpjclass)
  require(magclass)
  require(lucode)
  

  #############################################
  #Read the necessary inputs
  #############################################
  # Transformation factor gC/m^2 --> t/ha
  unit_transform <-0.01
  
  
  ### LPJ nat_vegc ###
  natveg_vegc<-readLPJ(file_name=natveg_vegc_file,wyears=years,syear=start_year,averaging_range=avg_range,bands=nbands,soilcells=TRUE, ncells=67420)
  natveg_vegc<-as.magpie(natveg_vegc)
  getNames(natveg_vegc)<-"vegc"
  natveg_vegc<-natveg_vegc*unit_transform
  if(any(natveg_vegc<0)){
    natveg_vegc[natveg_vegc<0]<-0
    warning("Some negative vegc values set to 0.")
  }
  
  
  if(file.exists(natveg_soilc_layer_file)){
    ### LPJ Soil layers natveg ###
    natveg_soilc_layer <- readLPJ(file_name=natveg_soilc_layer_file,wyears=years,syear=start_year,averaging_range=avg_range,bands=5,soilcells=TRUE, ncells=67420)
    natveg_soilc_layer <- as.magpie(natveg_soilc_layer)
    natveg_soilc_layer <- natveg_soilc_layer * unit_transform
    natveg_soilc_layer <- natveg_soilc_layer[,,1] + 1/3 * natveg_soilc_layer[,,2]
    getNames(natveg_soilc_layer) <- "soilc"
    if(any(natveg_soilc_layer<0)){
      natveg_soilc_layer[natveg_soilc_layer<0]<-0
      warning("Some negative soilc_layer values set to 0.")
    }
    
    natveg<-mbind(natveg_vegc,natveg_soilc_layer)
    rm(natveg_vegc,natveg_soilc)
    gc()
    
    topsoil <- TRUE
    
  } else {
    
    ### LPJ nat_soilc ###
    natveg_soilc<-readLPJ(file_name=natveg_soilc_file,wyears=years,syear=start_year,averaging_range=avg_range,bands=nbands,soilcells=TRUE, ncells=67420)
    natveg_soilc<-as.magpie(natveg_soilc)
    getNames(natveg_soilc)<-"soilc"
    natveg_soilc<-natveg_soilc*unit_transform
    if(any(natveg_soilc<0)){
      natveg_soilc[natveg_soilc<0]<-0
      warning("Some negative soilc values set to 0.")
    }
    
    natveg<-mbind(natveg_vegc,natveg_soilc)
    rm(natveg_vegc,natveg_soilc)
    gc()
    
    topsoil <- FALSE
  }
  
  
  ###LPJ  nat_litc ###
  natveg_litc<-readLPJ(file_name=natveg_litc_file,wyears=years,syear=start_year,averaging_range=avg_range,bands=nbands,soilcells=TRUE, ncells=67420)
  natveg_litc<-as.magpie(natveg_litc)
  getNames(natveg_litc)<-"litc"
  natveg_litc<-natveg_litc*unit_transform
  if(any(natveg_litc<0)){
    natveg_litc[natveg_litc<0]<-0
    warning("Some negative litc values set to 0.")
  }
  
  natveg<-mbind(natveg,natveg_litc)
  rm(natveg_litc)
  gc()
  
  #Cshare released (used to modify cropland soilc)
  cshare_released<-read.magpie(c_share_released_file)
  
  #Carbon stocks of pasture under different management options
  past<-read.magpie(pastc_file)
  past<-past*unit_transform
  if(any(past<0)){
    past[past<0]<-0
    warning("Some negative pasture carbon values set to 0.")
  }
  ####################################################
  #Create the output file
  ####################################################
  
  carbon_stocks <- new.magpie(cells_and_regions=getCells(natveg),
                            years=years,
                            names=c("vegc","soilc","litc"))
  
  carbon_stocks <- add_dimension(carbon_stocks, dim = 3.1, add = "landtype",
                                 nm = c("crop","past","forestry","primforest","secdforest", "urban", "other"))
  
  
  ####################################################
  #Calculate the appropriate values for all land types and carbon types.
  ####################################################
  #Factor 0.012 is based on the script subversion/svn/tools/carbon_cropland, executed at 30.07.2013
  carbon_stocks[,,"crop.vegc"]       <- 0.012*natveg[,,"vegc"]
  carbon_stocks[,,"crop.litc"]       <- 0
  carbon_stocks[,,"crop.soilc"]      <- (1-cshare_released)*natveg[,,"soilc"]
  carbon_stocks[,,"past.vegc"]       <- setYears(past[,,"default.vegc"],NULL)
  carbon_stocks[,,"past.litc"]       <- setYears(past[,,"default.litc"],NULL)
  carbon_stocks[,,"past.soilc"]      <- natveg[,,"soilc"]
  carbon_stocks[,,"forestry"]        <- natveg
  carbon_stocks[,,"primforest"]      <- natveg
  carbon_stocks[,,"secdforest"]      <- natveg
  carbon_stocks[,,"urban"]           <- 0
  carbon_stocks[,,"other"]           <- natveg
  
  ####################################################
  #Write the output
  ####################################################
  
  if(topsoil){
    
    comment <- c(paste("natveg_vegc_file: ", natveg_vegc_file),
                 paste("natveg_soilc_layer_file: ", natveg_soilc_layer_file),
                 paste("natveg_litc_file: ", natveg_litc_file),
                 paste("creation date:",date()))
  } else {
    
    comment <- c(paste("natveg_vegc_file: ", natveg_vegc_file),
                 paste("natveg_soilc_file: ", natveg_soilc_file),
                 paste("natveg_litc_file: ", natveg_litc_file),
                 paste("creation date:",date()))
  }
  
  write.magpie(carbon_stocks,file_name=out_carbon_stocks_file, comment=comment)
}


