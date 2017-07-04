# (C) 2008-2016 Potsdam Institute for Climate Impact Research (PIK),
# authors, and contributors see AUTHORS file
# This file is part of MAgPIE and licensed under GNU AGPL Version 3
# or later. See LICENSE file or go to http://www.gnu.org/licenses/
# Contact: magpie@pik-potsdam.de

####################################################
#### Exports Irrigation data from LPJ to MAgPIE ####
####################################################

irrigation <- function(input_file    = "/iplex/01/landuse/data/input/lpj_input/GLUES2/sresa2/constant_co2/miub_echo_g/pft_airrig.pft",
                       output_file   = "/iplex/01/landuse/data/input/raw_data/GLUES2-sresa2-constant_co2-miub_echo_g_rev16.895/0.5_set/lpj_airrig_0.5.mz",
                       cntr_LAI_file = '/iplex/01/landuse/data/input/raw_data/GLUES2-sresa2-constant_co2-miub_echo_g_rev16.895/0.5_set/cntr.LAI.RData',
                       ndigits     = 2,                     # Number of digits in output file
                       start_year  = 1950,                  # Start year of data set
                       years       = seq(1995,2005,by=10),  # Vector of years that should be exported
                       nbands      = 32,                    # Number of bands in the .bin file
                       avg_range   = 8,                     # Number of years used for averaging
                       lai_range   = 1:7,                   # possible LAImax values
                       sLAI        = 4){
  require(lpjclass)
  require(magclass)
  require(lucode)
  require(ludata)

  # load the cntr LAI information from yields.R
  load(cntr_LAI_file)

  names(lai_range)<-lai_range
  #load lai 1 input data just as a template for the array containing all lai's
  tmp  <- readLPJ(paste(input_file,"_lai",lai_range[1],".bin",sep=""),wyears=years,syear=start_year,averaging_range=avg_range,bands=nbands,soilcells=TRUE, ncells=67420)
  tmp <-cft.transform(as.magpie(tmp),na.value=10000)[,,"irrigated"]*10
  getNames(tmp) <- sub("\\.irrigated","",getNames(tmp))
  airrig_magpie<-as.array(tmp)
  airrig_magpie[,,]<-NA
  rm(tmp)
  gc()

  #loop over the lais and fill the array
  for(lai in lai_range){
    tmp_magpie <- readLPJ(paste(input_file,"_lai",lai,".bin",sep=""),wyears=years,syear=start_year,averaging_range=avg_range,bands=nbands,soilcells=TRUE, ncells=67420)
    #mm per year -> m^3 per ha per year
    tmp_magpie<-cft.transform(as.magpie(tmp_magpie),na.value=10000)[,,"irrigated"]*10
    getNames(tmp_magpie) <- sub("\\.irrigated","",getNames(tmp_magpie))
    tmp_magpie<-as.array(tmp_magpie)
    gc()
    # Now use cntr.LAI to determine the LAIcalibrated airrig_magpie
    #Determine those countries, that have this laimax value somewhere
    countries<-unique(names(which(cntr.LAI==lai,arr.ind=T)[,1]))
    #fill airrig_magpie with the correct values from airrig_lai
    for(cntr in countries){
      #get the code of that country and all the cells belonging to it
      cntr.code<-ludata$countryregions$country.code[which(ludata$countryregions$country.name==cntr)]
      cntr.cells<-which(ludata$cellbelongings$country.code==cntr.code)
      if(length(cntr.cells)>0){
        for(crop in dimnames(cntr.LAI)[[2]]){
          if(cntr.LAI[cntr,crop] == lai){
            # fill the cells for that country and crop with the correct LAI values
            airrig_magpie[cntr.cells,,crop]<-tmp_magpie[cntr.cells,,crop]
          }
        }
      }
    }
    if(lai==sLAI){
      # use predefined LAI for pasture, begr and betr in all countries. Data is lacking
      airrig_magpie[,,"pasture"]<-tmp_magpie[,,"pasture"]
      airrig_magpie[,,"begr"]<-tmp_magpie[,,"begr"]
      airrig_magpie[,,"betr"]<-tmp_magpie[,,"betr"]
    }
    rm(tmp_magpie)
    gc()
  }

  if(any(is.na(airrig_magpie)) ) stop("Error: produced NA water demand, probably no LAImax calculated for some countries")

  comment <- c(paste("input_file: ", input_file),
               paste("creation date:",date()))

  airrig_magpie<-as.magpie(airrig_magpie)
  write.magpie(round(airrig_magpie,ndigits),output_file, comment=comment)
}
