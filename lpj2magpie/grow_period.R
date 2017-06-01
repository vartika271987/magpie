# (C) 2008-2016 Potsdam Institute for Climate Impact Research (PIK),
# authors, and contributors see AUTHORS file
# This file is part of MAgPIE and licensed under GNU AGPL Version 3 
# or later. See LICENSE file or go to http://www.gnu.org/licenses/
# Contact: magpie@pik-potsdam.de

#########################################################
#### Determine a mean sowing date and a mean growing ####
#### period for each cell in order to determine when ####
#### irrigation can take place.                      ####
#########################################################

grow_period <- function(sowd_file  = "/iplex/01/landuse/data/input/lpj_input/GLUES2/sresa2/constant_co2/miub_echo_g/sdate.bin",
                        hard_file  = "/iplex/01/landuse/data/input/lpj_input/GLUES2/sresa2/constant_co2/miub_echo_g/hdate.bin",
                        yield_file = "/iplex/01/landuse/data/input/raw_data/GLUES2-sresa2-constant_co2-miub_echo_g_rev16.895/0.5_set/lpj_yields_0.5.mz",
                        area_file  = "/iplex/01/landuse/data/input/other/rev16/avl_land_0.5.mz",
                        damfile = "/iplex/01/landuse/data/input/other/rev16/dams_0.5.mz",
                        yield_ratio = 0.1, # threshold for cell yield over global average. crops in cells below threshold will be ignored
                        grday_file = "/iplex/01/landuse/data/input/raw_data/GLUES2-sresa2-constant_co2-miub_echo_g_rev16.895/0.5_set/mean_grdays_per_month_0.5.mz",
                        start_year  = 1901,                  #Start year of data set
                        years = seq(1995,2005,by=10),        #Vector of years that should be exported          
                        nbands = 24,                         # Number of bands in the .bin file  
                        avg_range = 8) {
  require(magclass)
  require(lpjclass)
  require(luscale)
  require(lucode)
  
  ####################################################################################
  #Goal: calculate mean sowing date and growing period
  #Step 1 Take care of inconsistencies (harvest date or sowing date ==0 etc)and convert to magpie cfts.
  #Step 2 remove wintercrops from both calculations for the northern hemisphere: sowd>180, hard<sowd
  #Step 3 remove crops that have an irrigated yield below 10% of global average (total cell area as aggregation weight for global value)
  #Step 4 Calculate growing period with the remaining crops
  #Step 5 remove sowd1 for sowing date calculation
  #Step 6 Calculate mean sowing date
  #Step 7 Set the sowd to 1 and growing period to 365 where dams are present and where they are NA (reflecting that all crops have been eliminated)
  #Step 8 Calculate the growing days per month for each cell and each year
  
  
  ####################################################################################
  #Useful functions
  ####################################################################################
  #Funktion f?r Varianz (wie rowMeans):
  rowVars <- function(x, na.rm=FALSE, dims=1, unbiased=TRUE,
                      SumSquares=FALSE, twopass=FALSE) {
    if (SumSquares) return(rowSums(x^2, na.rm, dims))
    N <- rowSums(!is.na(x), FALSE, dims)
    Nm1 <- if (unbiased) N-1 else N
    if (twopass) {x <- if (dims==0) x - mean(x, na.rm=na.rm) else
      sweep(x, 1:dims, rowMeans(x,na.rm,dims))}
    (rowSums(x^2, na.rm, dims) - rowSums(x, na.rm, dims)^2/N) / Nm1
  }
  ####################################################################################
  
  ####################################################################################
  #Read sowing and harvest date input for the correct LAImaxinput
  ####################################################################################
  bad_crops<-vector()
  
  sowd<-readLPJ(sowd_file,wyears=years,syear=start_year,averaging_range=avg_range,bands=nbands,soilcells=TRUE,datatype=integer(),bytes=2, ncells=67420)
  sowd<-as.magpie(sowd)[,,"rainfed"]
  getNames(sowd) <- sub("\\.rainfed","",getNames(sowd))
  good_crops<-as.vector(ludata$cftrel$magpie[which(ludata$cftrel$lpj%in%dimnames(sowd)[[3]])])
  bad_crops<-c(bad_crops,as.vector(ludata$cftrel$magpie[which(!ludata$cftrel$lpj%in%dimnames(sowd)[[3]])]))
  sowd<-suppressWarnings(cft.transform(as.magpie(sowd)))
  sowd<-sowd[,,good_crops]
  
  hard<-readLPJ(hard_file,wyears=years,syear=start_year,averaging_range=avg_range,bands=nbands,soilcells=TRUE,datatype=integer(),bytes=2, ncells=67420)
  hard<-as.magpie(hard)[,,"rainfed"]
  getNames(hard) <- sub("\\.rainfed","",getNames(hard))
  good_crops<-as.vector(ludata$cftrel$magpie[which(ludata$cftrel$lpj%in%dimnames(hard)[[3]])])
  bad_crops<-c(bad_crops,as.vector(ludata$cftrel$magpie[which(!ludata$cftrel$lpj%in%dimnames(hard)[[3]])]))
  hard<-suppressWarnings(cft.transform(as.magpie(hard)))
  hard<-hard[,,good_crops]
  
  sowd<-ceiling(sowd)
  hard<-ceiling(hard)
  gc()
  if(length(bad_crops)>0) warning("No information on the growing period found for those crops: ",paste(unique(bad_crops),collapse=", "))
  
  
  #####################################################################################
  
  ####################################################################################
  #Step 1 Take care of inconsistencies (hard==0 etc)#Read input
  ####################################################################################
  #Set sowd to 1 and hard to 365 where either sowd or hard are 0
  tmp_sowd<-as.array(sowd)
  tmp_sowd[which(hard==0|sowd==0)]<-1
  tmp_hard<-as.array(hard)
  tmp_hard[which(hard==0|sowd==0)]<-365
  sowd<-as.magpie(tmp_sowd)
  hard<-as.magpie(tmp_hard)
  #Set hard to sowd -1 where sowd and hard are equal
  tmp_sowd<-as.array(sowd)
  tmp_hard<-as.array(hard)
  tmp_hard[which(hard==sowd&sowd>1)]<-tmp_sowd[which(hard==sowd)]-1
  tmp_hard[which(hard==sowd&sowd==1)]<-365
  hard<-as.magpie(tmp_hard)
  rm(tmp_sowd,tmp_hard)
  gc()
  
  ####################################################################################
  
  ####################################################################################
  #Step 2 remove wintercrops from both calculations for the northern hemisphere: sowd>180, hard>365
  ####################################################################################
  cells_northern_hemisphere<-which(getCoordinates(degree=T)[,2]>0)
  rm_wintercrops<-new.magpie(dimnames(sowd)[[1]],dimnames(sowd)[[2]],dimnames(sowd)[[3]])
  rm_wintercrops[,,]<-1
  # soll sowd>180 Bedingung sein?-->Ja, Definition macht Sinn. Besser nicht zu viele rausschmeissen.
  rm_wintercrops[cells_northern_hemisphere,,]<-ifelse(as.array(sowd[cells_northern_hemisphere,,])>180 & as.array(hard[cells_northern_hemisphere,,]<sowd[cells_northern_hemisphere,,]),NA,1)#
  n_wintercrops<-ndata(sowd)-rowSums(rm_wintercrops,dims=2,na.rm=T)
  rm(cells_northern_hemisphere)
  gc()
  ####################################################################################
  # 
  # ####################################################################################
  # #Step 3 remove crops that have an irrigated yield below 10% of global average (total cell area as aggregation weight)
  # ####################################################################################
  tmp<-rowSums(read.magpie(area_file),dims=2)
  memCheck()
  cell_yield_ir<-read.magpie(yield_file)[,paste("y",years,sep=""),paste(good_crops,"irrigated",sep=".")]
  memCheck()
  dimnames(cell_yield_ir)[[3]] <- sub(".irrigated","",getNames(cell_yield_ir),fixed=TRUE)
  area<-cell_yield_ir
  for(t in getYears(area)){
    for(crop in getNames(area)){
      area[,t,crop]<-tmp
    }
  }
  glo_yield_ir<-superAggregate(cell_yield_ir,aggr_type="weighted_mean",weight=area,level="glo")
  cell_yield_ratio_ir<-cell_yield_ir
  for(crop in getNames(cell_yield_ratio_ir)){
    for(t in getYears(cell_yield_ratio_ir)){
      cell_yield_ratio_ir[,t,crop]<-cell_yield_ir[,t,crop]/as.numeric(glo_yield_ir[1,1,crop])
    }
  }
  rm(cell_yield_ir,area,tmp,glo_yield_ir)
  gc()
  rm_lowyield<-as.array(sowd)
  rm_lowyield[,,]<-1
  rm_lowyield[cell_yield_ratio_ir<yield_ratio]<-NA
  n_lowyield<-ndata(sowd)-rowSums(rm_lowyield,dims=2,na.rm=T)
  rm(cell_yield_ratio_ir)
  gc()
  # ####################################################################################
  # 
  # ####################################################################################
  # #Step 4 Calculate mean growing period with the remaining crops
  # ####################################################################################
  # #calculate growing period:
  hard<-as.magpie(hard)
  sowd<-as.magpie(sowd)
  grow_per <- new.magpie(dimnames(hard)[[1]],getYears(hard),getNames(hard))
  for(t in getYears(grow_per)){
    for (i in 1:dim(grow_per)[3]) {
      ii <- which(hard[,t,i] < sowd[,t,i])
      grow_per[,t,i] <- hard[,t,i] - sowd[,t,i]
      grow_per[ii,t,i] <- 365 + grow_per[ii,t,i]
    }
  }
  #Calculate the mean after removing the before determined cell,crop combinations
  mean_grper<-rowMeans(grow_per*rm_wintercrops*rm_lowyield,na.rm=T,dims=2)
  sd_grper<-sqrt(rowVars(as.array(grow_per*rm_wintercrops*rm_lowyield),na.rm=T,dims=2))
  ####################################################################################
  
  ####################################################################################
  #Step 5 remove sowd1 for sowing date calculation
  ####################################################################################
  rm_sowd1<-as.array(sowd)
  rm_sowd1[,,]<-1
  rm_sowd1[sowd==1]<-NA
  n_sowd1<-ndata(sowd)-rowSums(rm_sowd1,dims=2,na.rm=T)
  ####################################################################################
  
  ####################################################################################
  #Step 6 Calculate mean sowing date
  ####################################################################################
  mean_sowd<-rowMeans(sowd*rm_wintercrops*rm_lowyield*rm_sowd1,na.rm=T,dims=2)
  sd_sowd<-sqrt(rowVars(as.array(sowd*rm_wintercrops*rm_lowyield*rm_sowd1),na.rm=T,dims=2))
  ####################################################################################
  
  ####################################################################################
  #Step 7 Set the sowd to 1 and growing period to 365 where dams are present and where they are NA (reflecting that all crops have been eliminated).
  ####################################################################################
  dams<-read.magpie(damfile)
  for(t in getYears(mean_sowd)){
    mean_sowd[which(dams==1),t]<-1
    mean_grper[which(dams==1),t]<-365
  }
  mean_sowd[is.na(mean_sowd)]<-1
  mean_grper[is.na(mean_grper)]<-365
  mean_sowd<-round(as.magpie(mean_sowd))
  mean_grper<-round(as.magpie(mean_grper))
  ####################################################################################
  
  ####################################################################################
  #Step 8 Calculate the growing days per month for each cell and each year
  ####################################################################################
  months<-c("jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec")
  month_length<-c(31,28,31,30,31,30,31,31,30,31,30,31)
  names(month_length)<-months
  
  #Determine which day belongs to which month
  days_months<-1:365
  names(days_months)<-1:365
  before<-0
  for(i in 1:length(month_length)){
    days_months[(before+1):(before+month_length[i])]<-i
    names(days_months)[(before+1):(before+month_length[i])]<-names(month_length)[i]
    before<-before+month_length[i]
  }
  rm(before)
  
  #Array for the growing days per month 
  grow_days_per_month<-new.magpie(dimnames(mean_sowd)[[1]],dimnames(mean_sowd)[[2]],months)
  grow_days_per_month[,,]<-0
  
  #determine the harvest day, take care if it is greater than 365
  mean_hard<-mean_sowd+mean_grper-1
  mean_hard<-mean_hard%%365
  
  mean_hard<-as.array(mean_hard)
  mean_sowd<-as.array(mean_sowd)
  
  mean_hard[mean_hard==0]<-365
  
  #Loop over the months to set the number of days that the growing period lasts in each month
  for(t in getYears(mean_sowd)){
    #goodcells are cells in which harvest date is after sowing date, i.e. the cropping period does not cross the beginning of the year
    goodcells<-ifelse(mean_hard[,t,]>=mean_sowd[,t,],1,0)
    badcells<-ifelse(mean_hard[,t,]>=mean_sowd[,t,],0,1)
    for(month in 1:12){
      last_monthday<-which(days_months==month)[length(which(days_months==month))]
      first_monthday<-which(days_months==month)[1]
      test_harvest_goodcells<-as.array(mean_hard[,t,]-first_monthday+1)
      days_in_this_month_goodcells<-as.array(last_monthday-mean_sowd[,t,]+1)
      days_in_this_month_goodcells[days_in_this_month_goodcells<0]<-0 #Month before sowing date
      days_in_this_month_goodcells[days_in_this_month_goodcells>month_length[month]]<-month_length[month] # Month is completely after sowing date
      days_in_this_month_goodcells[test_harvest_goodcells<0]<-0 #Month lies after harvest date
      days_in_this_month_goodcells[test_harvest_goodcells>0 & test_harvest_goodcells<month_length[month]]<-days_in_this_month_goodcells[test_harvest_goodcells>0 & test_harvest_goodcells<month_length[month]]-(last_monthday-mean_hard[test_harvest_goodcells>0 & test_harvest_goodcells<month_length[month],t,]) # Harvest date lies in the month. cut off the end of the month after harvest date
      days_in_this_month_goodcells<-days_in_this_month_goodcells<-days_in_this_month_goodcells*goodcells
      days_in_this_month_badcells_firstyear<-as.array(last_monthday-mean_sowd[,t,]+1)
      days_in_this_month_badcells_firstyear[days_in_this_month_badcells_firstyear<0]<-0 #Month before sowing date
      days_in_this_month_badcells_firstyear[days_in_this_month_badcells_firstyear>month_length[month]]<-month_length[month] # Month is completely after sowing date
      days_in_this_month_badcells_secondyear<-as.array(mean_hard[,t,]-first_monthday+1)
      days_in_this_month_badcells_secondyear[days_in_this_month_badcells_secondyear<0]<-0 #Month lies completely after harvest day
      days_in_this_month_badcells_secondyear[days_in_this_month_badcells_secondyear>month_length[month]]<-month_length[month] #Month lies completely before harvest day
      days_in_this_month_badcells<-(days_in_this_month_badcells_firstyear+days_in_this_month_badcells_secondyear)*badcells
      grow_days_per_month[,t,month]<-days_in_this_month_goodcells+days_in_this_month_badcells
    }
  }
  
  ####################################################################################
  comment <- c(paste("sowd_file: ", sowd_file),
               paste("hard_file: ", hard_file),
               paste("yield_file: ", yield_file),
               paste("creation date:",date()))
  
  write.magpie(grow_days_per_month,grday_file, comment=comment)
}


