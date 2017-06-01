# (C) 2008-2016 Potsdam Institute for Climate Impact Research (PIK),
# authors, and contributors see AUTHORS file
# This file is part of MAgPIE and licensed under GNU AGPL Version 3 
# or later. See LICENSE file or go to http://www.gnu.org/licenses/
# Contact: magpie@pik-potsdam.de


calibrate_lai <- function(input_file = "/p/projects/landuse/data/input/lpj_input/GLUES2/sresa2/constant_co2/miub_echo_g/pft_harvest.pft", 
                          area_file = "/p/projects/landuse/data/input/raw_data/GLUES2-sresa2-constant_co2-miub_echo_g_rev21.1001/0.5_set/calibrated_area_0.5.mz",
                          cntr_LAI_file = "cntr.LAI.RData",
                          start_year = 1901, nbands = 32, avg_range = 8, lai_range = 1:7) {

  #########################################################
  #### Determines for each country and each crop the best fitting LAI max value ####
  #########################################################
  
  ####################################################################################
  #load LPJ inputs for all seven LAI, convert tem to MAgPIe objects, convert to MAgPIE structure (crops and cellbelongings), convert to tdm/ha and store them in a list
  
  
  require(lpjclass)
  require(magclass)
  require(lucode)
  
  keepObjects<-c(ls(),"keepObjects")
  
  LPJ.yields<-list()
  Warnings<-list()
  names.lai<-vector()
  for(lai in lai_range){
    
      names.lai<-c(names.lai,paste("LAI_",lai,sep=""))
      laiyield<-readLPJ(paste(input_file,"_lai",lai,".bin",sep=""),wyears=1995,syear=start_year,averaging_range=avg_range,bands=nbands,soilcells=TRUE,  ncells = 67420)
      #transform it to a MAgPIe object and change cellordering
      #get correct MAGPie crops including surrogates
      #gC/m? -> tDM/ha
      laiyield<-cft.transform(as.magpie(laiyield),rev=rev,na.value=1)*0.01/0.45
      
      # Check for yields below 0 and set them to 0
      if(any(laiyield<0)){
        Warnings[[lai]]<-which(laiyield<0,arr.ind=T)
        laiyield[laiyield<0]<-0
        warning(paste("Some negative yields set to 0."))
      }
      
      LPJ.yields[[lai]]<-list(rainfed=laiyield[,,"rainfed"],irrigated=laiyield[,,"irrigated"])
      getNames(LPJ.yields[[lai]]$rainfed) <- sub("\\.rainfed$","",getNames(LPJ.yields[[lai]]$rainfed))
      getNames(LPJ.yields[[lai]]$irrigated) <- sub("\\.irrigated$","",getNames(LPJ.yields[[lai]]$irrigated))
  }
  names(LPJ.yields)<-names.lai
  rmAllbut(LPJ.yields,names.lai,input_file,list=keepObjects)
  ####################################################################################
  ####################################################################################
  
  ####################################################################################
  # load the area dataset for aggregation
  
  cell.area <-read.magpie(area_file)
  cell.area_rf<-as.array(cell.area[,,"rainfed"])[,1,]
  cell.area_ir<-as.array(cell.area[,,"irrigated"])[,1,]
  dimnames(cell.area_rf)[[2]] <- sub(".rainfed","",dimnames(cell.area_rf)[[2]],fixed=TRUE)
  dimnames(cell.area_ir)[[2]] <- sub(".irrigated","",dimnames(cell.area_ir)[[2]],fixed=TRUE)
  rmAllbut("LPJ.yields","cell.area_rf","cell.area_ir","cell.area",input_file,names.lai,list=keepObjects)
  ####################################################################################
  ####################################################################################
  
  
  ####################################################################################
  #calculate the country mean of the yield for all crops using the cell.area as a weight.
  
  #get all MAgPIE crops except for bioenergy crops
  require(ludata)
  magpie.crops<-as.vector(ludata$cftrel$magpie)
  magpie.crops<-magpie.crops[-which(magpie.crops=="pasture")]
  magpie.crops<-magpie.crops[-which(magpie.crops=="begr")]
  magpie.crops<-magpie.crops[-which(magpie.crops=="betr")]
  
  #rainfed, irrigated and total harvested area in each country for each magpie cft according to MIRCA harmonized with FAO
  cntr.area_rf<-array(NA,dim=c(length(getCountries()),length(magpie.crops)),dimnames=list(getCountries(),magpie.crops))
  cntr.area_ir<-array(NA,dim=c(length(getCountries()),length(magpie.crops)),dimnames=list(getCountries(),magpie.crops))
  cntr.area<-array(NA,dim=c(length(getCountries()),length(magpie.crops)),dimnames=list(getCountries(),magpie.crops))
  #mean LPJ yield for each country for all LAI's
  cntr.LPJyield<-array(NA,dim=c(length(getCountries()),length(magpie.crops),length(names.lai)),dimnames=list(getCountries(),magpie.crops,names.lai))
  
  for(cntr in getCountries()){  
    
    #get the code of that country
    cntr.code<-ludata$countryregions$country.code[which(ludata$countryregions$country.name==cntr)]
    #get all cells belonging to that country
    cntr.cells<-which(ludata$cellbelongings$country.code==cntr.code)
    if(length(cntr.cells)==0){ # no area in this country
      cntr.area_rf[cntr,crop]<-NA
      cntr.area_ir[cntr,crop]<-NA
      cntr.area[cntr,]<-NA #no harvested area possible
      cntr.LPJyield[cntr,,]<-NA #no yield possible
    }
    else{
      for(crop in magpie.crops){
        #calculate total harvested area of all mirca crops belonging to the cft.
        cntr.area_rf[cntr,crop]<-sum(cell.area_rf[cntr.cells,crop])
        cntr.area_ir[cntr,crop]<-sum(cell.area_ir[cntr.cells,crop])
        cntr.area[cntr,crop]<-(cntr.area_rf+cntr.area_ir)[cntr,crop]
        #calculate the yield on country level
        if(cntr.area[cntr,crop]>0){
          for(lai in names.lai){
            cntr.LPJyield[cntr,crop,lai]<-sum(cell.area_rf[cntr.cells,crop]*LPJ.yields[[lai]][["rainfed"]][cntr.cells,"y1995",crop]+cell.area_ir[cntr.cells,crop]*LPJ.yields[[lai]][["irrigated"]][cntr.cells,"y1995",crop])/cntr.area[cntr,crop]
          }
        }
        else{
          cntr.LPJyield[cntr,crop,]<--1
        }
      }    
    }  
  }
  rmAllbut("cntr.LPJyield","cntr.area",input_file,magpie.crops,list=keepObjects)
  ##########################################################################################
  ##########################################################################################
  
  ###########################################################################################
  # Determine the best LAI max on country level .
  
  # If there is no data available, take the (rounded) regional average calculated with cell.area area as weight.
  # If no data for the region is available, take the world average.
  cntr.LAI<-array(NA,dim=c(length(getCountries()),length(magpie.crops)),dimnames=list(getCountries(),magpie.crops))
  
  #load fao yields on country level
  cntr.FAOyield<-as.matrix(getYields(level="country",physical_area=TRUE))
  for(cntr in getCountries()){
    #get the code of that country
    cntr.code<-ludata$countryregions$country.code[which(ludata$countryregions$country.name==cntr)]
    #get all cells belonging to that country
    cntr.cells<-which(ludata$cellbelongings$country.code==cntr.code)
    if(length(cntr.cells)==0){ # no area in this country
      cntr.LAI[cntr,]=NA #no LAImax to be determined
    }
    else{
      for(crop in magpie.crops){
        if(!(is.na(cntr.FAOyield[cntr,crop]))&&!(-1 %in% cntr.LPJyield[cntr,crop,])){ #fao as well as MIRCA data are present
          #determine the lai from the difference between fao and lpj
          lai<-as.numeric(which.min(abs(cntr.LPJyield[cntr,crop,]-cntr.FAOyield[cntr,crop])))
          cntr.LAI[cntr,crop]<-lai
        }
        else{
          cntr.LAI[cntr,crop]<-0
        }
      }
    }
  }
  rmAllbut("cntr.area","cntr.LAI",input_file,magpie.crops,list=keepObjects)
  ################################################################################################
  # determine the region averages and world average of LAImax
  
  magpie.regions<-as.vector(sort(unique(ludata$countryregions$MAgPIE.Region)))
  reg.LAI<-array(NA,dim=c(length(magpie.regions)+1,length(magpie.crops)),dimnames=list(c(magpie.regions,"WORLD"), magpie.crops))
  for(crop in magpie.crops){
    for(region in magpie.regions){
      #determine all countries in that region which have a calibrated LAImax
      countries<-as.vector(ludata$countryregions$country.name[which(ludata$countryregions$MAgPIE.Region==region)])
      countries<-countries[which(cntr.LAI[countries,crop] %in% 1:7)]
      if(length(countries)>0){
        reg.LAI[region,crop]<-round(sum(cntr.LAI[countries,crop]*cntr.area[countries,crop])/sum(cntr.area[countries,crop]),digits=0)
      }
      else{
        # where no data is available in the region, fill with NA's, -1's respectively
        reg.LAI[region,crop]<-0
      }
    }
    # now determine the world average
    #determine all countries in the world which have a calibrated LAImax
    countries<-getCountries()[which(cntr.LAI[getCountries(),crop] %in% 1:7)]
    reg.LAI["WORLD",crop]<-round(sum(cntr.LAI[countries,crop]*cntr.area[countries,crop])/sum(cntr.area[countries,crop]),digits=0)
  }
  
  rmAllbut(cntr.LAI,reg.LAI,magpie.crops,input_file,list=keepObjects)
  ################################################################################################
  # replace the missing values in cntr.LAI by region (if available) or world average.
  
  for(cntr in getCountries()){
    region<-as.vector(ludata$countryregions$MAgPIE.Region[which(ludata$countryregions$country.name==cntr)])
    for(crop in magpie.crops){
      if(is.na(cntr.LAI[cntr,crop])==FALSE && cntr.LAI[cntr,crop]==0){
        if(reg.LAI[region,crop] %in% 1:7){ # if there is regional data present, us that
          cntr.LAI[cntr,crop]<-reg.LAI[region,crop]
        }
        else{ #use world average
          cntr.LAI[cntr,crop]<-reg.LAI["WORLD",crop]
        }
      }
    }
  }
  attr(cntr.LAI, "input_file") <- input_file
  attr(cntr.LAI, "creation date") <- date()
  save(cntr.LAI,file=cntr_LAI_file)
  ###########################################################################################
  ###########################################################################################
}

