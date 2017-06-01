# (C) 2008-2016 Potsdam Institute for Climate Impact Research (PIK),
# authors, and contributors see AUTHORS file
# This file is part of MAgPIE and licensed under GNU AGPL Version 3 
# or later. See LICENSE file or go to http://www.gnu.org/licenses/
# Contact: magpie@pik-potsdam.de

###########################################
#### Exports yields from LPJ to MAgPIE ####
###########################################



yields <- function(input_file =  "/p/projects/landuse/data/input/lpj_input/GLUES2/sresa2/constant_co2/miub_echo_g/pft_harvest.pft",
                   cntr_LAI_file = "cntr.LAI.RData",
                   output_file = "test/lpj_yields_0.5_newest.csv",
                   ndigits = 2,                    # Number of digits in output file
                   start_year = 1950,              # Start year of data set
                   years = seq(1995,2035,by=5),    # Vector of years that should be exported          
                   nbands = 32,                    # Number of bands in the .bin file  
                   avg_range = 8,                  # Number of years used for averaging
                   lai_range = 1:7,                # possible LAImax values
                   sLAI = 4) {
  
  require(ludata)
  require(magclass)
  require(lpjclass)
  require(lucode)
  
  keepObjects<-list()
  keepObjects<-ls()
  
  load(cntr_LAI_file)
  magpie.crops<-as.vector(ludata$cftrel$magpie)
  magpie.crops<-magpie.crops[-which(magpie.crops=="pasture")]
  magpie.crops<-magpie.crops[-which(magpie.crops=="begr")]
  magpie.crops<-magpie.crops[-which(magpie.crops=="betr")]
  lpj_yields<-readLPJ(paste(input_file,"_lai1.bin",sep=""),wyears=years,syear=start_year,averaging_range=avg_range,bands=nbands,soilcells=TRUE,ncells=67420)
  lpj_yields<-as.magpie(lpj_yields)
  
  #get correct MAGPie crops including surrogates
  lpj_yields<-cft.transform(lpj_yields,rev=rev,na.value=1)
  lpj_yields[,,] <- NA
  
  memCheck()
  
  for(lai in lai_range){
      cat("LAI = ",lai)
      laiyield<-readLPJ(paste(input_file,"_lai",lai,".bin",sep=""),wyears=years,syear=start_year,averaging_range=avg_range,bands=nbands,soilcells=TRUE,ncells=67420)
      memCheck()
      #transform it to a MAgPIe object and change cellordering, convert to MAgPIE crops and change unit gC/m²-> tDM/ha
      laiyield<-cft.transform(as.magpie(laiyield),rev=rev,na.value=1)*0.01/0.45
      memCheck()
      for(crop in magpie.crops) {
        #Determine those countries, that have this laimax value somewhere
        countries <- names(which(cntr.LAI[,crop]==lai))
        cntr.cells <- countrycells(countries)
        if(length(cntr.cells)>0) {
          lpj_yields[cntr.cells,,crop]<-laiyield[cntr.cells,,crop]
        }
      }
      if(lai==sLAI){
        # use predefined LAI for pasture, begr and betr in all countries. Data is lacking
        lpj_yields[,,"pasture"] <- laiyield[,,"pasture"]
        lpj_yields[,,"begr"]    <- laiyield[,,"begr"]
        lpj_yields[,,"betr"]    <- laiyield[,,"betr"]  
      }
      memCheck()
      rm(laiyield)
      gc()
  }
  
  #file.remove(path(output_folder,"tmp.RData"))
  rmAllbut(lpj_yields,ndigits,output_file,input_file,cntr_LAI_file)
  
  # Remove negative yields
  lpj_yields[lpj_yields<0] <- 0
  memCheck()
  
  if(any(is.na(lpj_yields))) stop("produced NA yields, probably no LAImax calculated for some countries")
  
  comment <- c(paste("input_file: ", input_file),
  						paste("cntr_LAI_file: ", cntr_LAI_file),
               paste("creation date:",date()))
  
  write.magpie(round(lpj_yields,digits=ndigits),output_file, comment=comment)
}



