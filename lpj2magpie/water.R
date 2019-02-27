# (C) 2008-2016 Potsdam Institute for Climate Impact Research (PIK),
# authors, and contributors see AUTHORS file
# This file is part of MAgPIE and licensed under GNU AGPL Version 3 
# or later. See LICENSE file or go to http://www.gnu.org/licenses/
# Contact: magpie@pik-potsdam.de

############################################
####    Calculats Environmental flows   ####
####    non agricultural water demand   ####
####    and available water             ####
############################################

water <- function(discharge_file  = "/iplex/01/landuse/data/input/lpj_input/GLUES2/sresa2/constant_co2/miub_echo_g/mdischarge_natveg.bin",
                  runoff_file  = "/iplex/01/landuse/data/input/lpj_input/GLUES2/sresa2/constant_co2/miub_echo_g/mdischarge_natveg.bin",
                  watdem_nonagr_file  = "bla",
                  basin_file   = "/iplex/01/landuse/data/input/lpj_input/additional_input/rivers.RData",
                  grday_file   = "/iplex/01/landuse/data/input/raw_data/GLUES2-sresa2-constant_co2-miub_echo_g_rev16.895/0.5_set/mean_grdays_per_month_0.5.mz",
                  out_watavail_grper_file = "/iplex/01/landuse/data/input/raw_data/GLUES2-sresa2-constant_co2-miub_echo_g_rev16.895/0.5_set/lpj_watavail_grper_new_0.5.mz",
                  out_watavail_total_file = "/iplex/01/landuse/data/input/raw_data/GLUES2-sresa2-constant_co2-miub_echo_g_rev16.895/0.5_set/lpj_watavail_total_new_0.5.mz",
                  out_envflow_grper_file ="/iplex/01/landuse/data/input/raw_data/GLUES2-sresa2-constant_co2-miub_echo_g_rev16.895/0.5_set/lpj_envflow_grper_0.5.mz",
                  out_envflow_total_file ="/iplex/01/landuse/data/input/raw_data/GLUES2-sresa2-constant_co2-miub_echo_g_rev16.895/0.5_set/lpj_envflow_total_0.5.mz",
                  out_watdem_nonagr_grper_file ="/iplex/01/landuse/data/input/raw_data/GLUES2-sresa2-constant_co2-miub_echo_g_rev16.895/0.5_set/watdem_nonagr_grper_0.5.mz",
                  out_watdem_nonagr_total_file ="/iplex/01/landuse/data/input/raw_data/GLUES2-sresa2-constant_co2-miub_echo_g_rev16.895/0.5_set/watdem_nonagr_total_0.5.mz",
                  out_runoff_file ="/iplex/01/landuse/data/input/raw_data/GLUES2-sresa2-constant_co2-miub_echo_g_rev16.895/0.5_set/runoff_0.5.mz", 
                  LFR_val     =0.1, # Strictness of flow requirements.
                  HFR_LFR_less10 = 0.2,  # High flow requirements in share of total water for cells with LFR<10% of total water
                  HFR_LFR_10_20 = 0.15,  # High flow requirements in share of total water for cells with 10% < LFR < 20 % of total water
                  HFR_LFR_20_30 = 0.07,  # High flow requirements in share of total water for cells with 20% < LFR < 30 % of total water
                  HFR_LFR_more30 = 0.00,  # High flow requirements in share of total water for cells with LFR> 30 % of total water
                  ndigits     = 0,                     #Number of digits in output file
                  start_year  = 1950,                  #Start year of data set
                  years       = c(1995,2000),   #Vector of years that should be exported          
                  nbands      = 1,                     # Number of bands in the .bin file  
                  avg_range   = 8){
  require(lpjclass)
  require(magclass)
  require(lucode)

  #Goal: calculate water availability, environmental flows and non agricultural water demand for the growing period and the whole year
  #Step 1 Determine monthly discharge low flow requirements (LFR_monthly discharge).
  #Step 2 Determine monthly water availability (avl_water_month) and low flow requirements (LFR) from discharge weighted runoff
  #Step 3 Determie monthly high flow requirements (HFR) based on the ratio between LFR and avl_water_month.
  #Step 4 Get growing days per month to determine available water, environmental flow requirements( EFR=LFR+HFR) and non agricultural water demand in the growing period
  
  ####################################################################################
  #Step 1 Determine monthly discharge low flow requirements (LFR_monthly_discharge).
  ####################################################################################
  if(round(avg_range/2)==avg_range/2){
    needed_years<-seq(years[1]-avg_range/2,years[length(years)]+avg_range/2-1,by=1)
  } else{
    needed_years<-seq(years[1]-as.integer(avg_range/2),years[length(years)]+as.integer(avg_range/2),by=1)
  }
  
  #read monthly discharge
  monthly_discharge_magpie  <- readLPJ(discharge_file,wyears=needed_years,syear=start_year,averaging_range=NULL,monthly=TRUE,bands=nbands,soilcells=TRUE, ncells=67420)
  memCheck()
  monthly_discharge_magpie <- as.magpie(monthly_discharge_magpie)
  memCheck()
  getNames(monthly_discharge_magpie) <- sub("\\.data","",getNames(monthly_discharge_magpie))
  monthly_discharge_magpie <- as.array(monthly_discharge_magpie)
  gc()
  
  # discharge from 1.000.000 m^3 / day to mio m^3 
  month_days<-c(31,28,31,30,31,30,31,31,30,31,30,31)
  names(month_days)<-dimnames(monthly_discharge_magpie)[[3]]
  for(month in names(month_days)){
    monthly_discharge_magpie[,,month]<-monthly_discharge_magpie[,,month]*month_days[month]
  }
  memCheck()
  LFR_quant<-array(NA,dim=c(dim(monthly_discharge_magpie)[1],length(years)),dimnames=list(dimnames(monthly_discharge_magpie)[[1]],paste("y",years,sep="")))
  for(year in years){
    # years to take into account in calculation
    if(round(avg_range/2)==avg_range/2){
      n_years<-seq(year-avg_range/2,year+avg_range/2-1,by=1)
    } else{
      n_years<-seq(year-as.integer(avg_range/2),year+as.integer(avg_range/2),by=1)
    }
    #Get the LFR_val quantile for all cells for all months in the averaging range
    LFR_quant[,paste("y",year,sep="")]<-apply(monthly_discharge_magpie[,paste("y",n_years,sep=""),],MARGIN=c(1),quantile,probs=LFR_val)
  }
  memCheck()
  rm(monthly_discharge_magpie)
  gc()
  
  #Now use this LFR_annual discharge to calculate LFRs based on basin discharge and basin runoff
  
  #read discharge
  monthly_discharge_lpj  <- readLPJ(discharge_file,wyears=years,syear=start_year,averaging_range=avg_range,monthly=TRUE,bands=nbands,soilcells=TRUE, ncells=67420)
  monthly_discharge_magpie <- as.magpie(monthly_discharge_lpj)
  getNames(monthly_discharge_magpie) <- sub("\\.data","",getNames(monthly_discharge_magpie))
  monthly_discharge_magpie <- as.array(monthly_discharge_magpie)
  
  
  # discharge from 1.000.000 m^3 / day to mio m^3 
  month_length<-c(31,28,31,30,31,30,31,31,30,31,30,31)
  names(month_length)<-dimnames(monthly_discharge_magpie)[[3]]
  for(month in names(month_length)){
    monthly_discharge_magpie[,,month]<-monthly_discharge_magpie[,,month]*month_length[month]
  }
  rm(monthly_discharge_lpj)
  
  #read runoff
  monthly_runoff_lpj  <- readLPJ(runoff_file,wyears=years,syear=start_year,averaging_range=avg_range,monthly=TRUE,bands=nbands,soilcells=TRUE, ncells=67420)
  monthly_runoff_magpie <- as.magpie(monthly_runoff_lpj)
  getNames(monthly_runoff_magpie) <- sub("\\.data","",getNames(monthly_runoff_magpie))
  annual_runoff_magpie <- dimSums(monthly_runoff_magpie,dim=3)
  monthly_runoff_magpie <- as.array(monthly_runoff_magpie)
  
  
  #runoff from l/m^2 to l
  cb <- ludata$cellbelongings
  cb$xlon <- (cb$lon-1)/2 - 180
  cb$ylat <- (cb$lat-1)/2 - 90
  cell_area <- (111e3*0.5)*(111e3*0.5)*cos(cb$ylat/180*pi)
  monthly_runoff_magpie<-monthly_runoff_magpie*cell_area
  # from l to mio m^3
  monthly_runoff_magpie<-monthly_runoff_magpie/(1000*1000000)
  rm(monthly_runoff_lpj)
  
  #Get LFR discharge values for each month. If LFR_quant <magpie_discharge, take LFR_quant, else take magpie_discharge
  LFR_monthly_discharge<-monthly_runoff_magpie
  for(month in 1:12){
    tmp1<-as.vector(LFR_quant)
    tmp2<-as.vector(monthly_discharge_magpie[,,month])
    LFR_monthly_discharge[,,month]<-pmin(tmp1,tmp2)
  }
  rm(LFR_quant)
  gc()
  ####################################################################################
  
  ####################################################################################
  #Step 2 Determine monthly water availability (avl_water_month) and low flow requirements (LFR) from discharge weighted runoff
  ####################################################################################
  LFR<-monthly_runoff_magpie
  LFR[,,]<- NA
  avl_water_month<-monthly_runoff_magpie
  avl_water_month[,,]<- NA
  
  load(basin_file)
  rm(calcorder,dsclist)
  gc()
  #Sum the runoff in all basins, and allocate it to the basin cells with discharge as weight for total water available.
  
  for(basin in unique(basin_code)){
    basin_cells<-which(basin_code==basin)
    basin_runoff<-colSums(monthly_runoff_magpie[basin_cells,,,drop=FALSE])
    basin_discharge<-colSums(monthly_discharge_magpie[basin_cells,,,drop=FALSE])
    for(month in dimnames(avl_water_month)[[3]]){
      avl_water_month[basin_cells,,month]<-t(basin_runoff[,month]*t(monthly_discharge_magpie[basin_cells,,month])/basin_discharge[,month])
    }
  }
  rm(basin_discharge,basin_runoff)
  gc()
  #Determine Low flow requirements
  LFR<-avl_water_month*LFR_monthly_discharge/monthly_discharge_magpie
  # LFR contains nans wherever basin_discharge was 0. --> Replace all NA's by 0
  LFR[is.nan(LFR)]<-0
  avl_water_month[is.nan(avl_water_month)]<-0
  ####################################################################################
  
  ####################################################################################
  #Step 3 Determie monthly high flow requirements (HFR) based on the ratio between LFR_month andavl_water_month.
  ####################################################################################
  HFR<-LFR
  HFR[,,]<-NA
  HFR[LFR<0.1*avl_water_month]<-HFR_LFR_less10*avl_water_month[LFR<0.1*avl_water_month]
  HFR[LFR>=0.1*avl_water_month]<-HFR_LFR_10_20*avl_water_month[LFR>=0.1*avl_water_month]
  HFR[LFR>=0.2*avl_water_month]<-HFR_LFR_20_30*avl_water_month[LFR>=0.2*avl_water_month]
  HFR[LFR>=0.3*avl_water_month]<-HFR_LFR_more30*avl_water_month[LFR>=0.3*avl_water_month]
  HFR[avl_water_month<=0]<-0
  
  EFR<-LFR+HFR
  ####################################################################################
  
  ####################################################################################
  #Step 4 Get growing days per month to determine available water and environmental flow requirements( EFR=LFR+HFR) in the growing period
  ####################################################################################
  grow_days<-read.magpie(grday_file)[,paste("y",years,sep=""),]
  
  #Calculate daily water availability and environmental flow requirements in each month
  tmp<-vector()
  nrep<-ncells(EFR)*nyears(EFR)
  for(i in 1:ndata(EFR)){
    tmp<-c(tmp,as.vector(rep(month_days[i],nrep)))
  }
  month_day_array<-EFR
  month_day_array[,,]<-tmp
  EFR_day<-EFR/month_day_array
  avl_water_day<-avl_water_month/month_day_array
  
  avl_water_grper<-rowSums(avl_water_day*grow_days,dims=2)
  EFR_grper<-rowSums(EFR_day*grow_days,dims=2)
  avl_water_total<-rowSums(avl_water_month,dims=2)
  EFR_total<-rowSums(EFR,dims=2)
  avl_water_grper<-as.magpie(avl_water_grper)
  avl_water_total<-as.magpie(avl_water_total)
  EFR_total<-as.magpie(EFR_total)
  EFR_grper<-as.magpie(EFR_grper)
  
  #reduce EFR to 50% of available water where it exceeds this threshold (according to smakhtin 2004)
  EFR_total[which(EFR_total/avl_water_total>0.5)]<-0.5*avl_water_total[which(EFR_total/avl_water_total>0.5)]
  EFR_grper[which(EFR_grper/avl_water_grper>0.5)]<-0.5*avl_water_grper[which(EFR_grper/avl_water_grper>0.5)]
  
  comment <- c(paste("discharge_file: ", discharge_file),
               paste("runoff_file: ", runoff_file),
               paste("watdem_nonagr_file: ", watdem_nonagr_file),
               paste("script_file (preprocessing): lpj2magpie/water.R"),
               paste("creation date:",date()))
  
  write.magpie(avl_water_grper,out_watavail_grper_file, comment=comment)
  write.magpie(avl_water_total,out_watavail_total_file, comment=comment)
  write.magpie(EFR_grper,out_envflow_grper_file, comment=comment)
  write.magpie(EFR_total,out_envflow_total_file, comment=comment)
  write.magpie(annual_runoff_magpie,out_runoff_file, comment=comment)
  
  rm(avl_water_grper,avl_water_total,EFR_grper,EFR_total,avl_water_day,EFR_day)
  gc()
  
  watdem_nonagr_total<-read.magpie(watdem_nonagr_file)[,paste("y",years,sep=""),]
  watdem_nonagr_grper<-watdem_nonagr_total*(rowSums(grow_days,dim=2)/365)
  write.magpie(watdem_nonagr_grper,out_watdem_nonagr_grper_file, comment=comment)
  write.magpie(watdem_nonagr_total,out_watdem_nonagr_total_file, comment=comment)
}



