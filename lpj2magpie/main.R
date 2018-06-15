# (C) 2008-2016 Potsdam Institute for Climate Impact Research (PIK),
# authors, and contributors see AUTHORS file
# This file is part of MAgPIE and licensed under GNU AGPL Version 3
# or later. See LICENSE file or go to http://www.gnu.org/licenses/
# Contact: magpie@pik-potsdam.de

##########################################
#### Converts data from LPJ to MAgPIE ####
##########################################

lpj2magpie <- function(input_folder  = "/p/projects/landuse/data/input/lpj_input/GLUES2/sresa2/constant_co2/miub_echo_g",
                       input2_folder = "/p/projects/landuse/data/input/other/rev22/",
                       output_file ="test.tgz",
                       rev = 22,
                       sLAI = 4,        # LAImax for pasture, begr and betr
                       avg_range = 8,   # Number of years used for averaging
                       lai_range = 1:7,
                       years = seq(1995,2095,by=5),
                       debug = FALSE){

  require(lucode)
  require(ludata)

  umask <- Sys.umask("2")
  on.exit(Sys.umask(umask))

  #Determine the start year of LPJ simulations from the .out files
  getLPJstartYear <- function(input_folder) {
    out_files<-grep("*.\\.out",list.files(input_folder),value=TRUE)
    #Sometimes grid.out files are present. They should not be included
    bad_files<-grep("grid(_lai[0-9])?.out",out_files)
    if(length(bad_files)>0) out_files<-out_files[-bad_files]
    if(length(out_files)==0) stop("No LPJ simulation protocol (.out) has been found to determine the start year of the simulation.")
    start_years<-rep(NA,length(out_files))
    for(i in 1:length(out_files)){
      start_years[i]<-as.numeric(gsub("^[^0-9]*","",grep("First year:",readLines(path(input_folder,out_files[i])),value=TRUE)))
    }
    start_year <- unique(start_years)
    if(length(start_year)!=1) stop("Different LPJ runs seem to start at different points in time.")
    if(start_year>1990) stop("The LPJ simulation has to start before 1990. This simulation starts in ",start_year)
    cat("As Start year of LPJ input data following year was detected:",start_year,"\n\n")
    return(start_year)
  }
  start_year <- getLPJstartYear(input_folder)

  if(rev < 24) stop('Converter is only available for revisions >= 24!')

  #create output folder
  output_folder <- paste0("tmp/lpj2magpie_",format(Sys.time(),"%Y%m%d%H%M%S"))
  dir.create(output_folder,recursive=TRUE)
  cat("Use temp dir ",output_folder,".\n")

  writeInfo <- function(file_name,input_folder,input2_folder, rev) {
    functioncall <- paste(deparse(sys.call(-1)), collapse = "")
    info <- c('lpj2magpie settings:',
              paste('* LPJmL data folder:',input_folder),
              paste('* Additional input folder:',input2_folder),
              paste('* Revision:', rev),
              paste('* Call:', functioncall))
    cat(info,file=file_name,sep='\n')
  }
  writeInfo(file_name=path(output_folder,'info.txt'), input_folder=input_folder, input2_folder=input2_folder, rev=rev)

  ### copy files from other input folder ###
  cat("copy files from additional input\n")
  copyOtherInputs <- function(input2_folder, output_folder,rev) {
    if(!dir.exists(input2_folder)) stop("Additional input folder for given revision does not exist! (",input2_folder,")")
    files2copy <- NULL
    # USAGE:
    # f[<name of file after copying>]       <- <name of file to be copied>
    files2copy["avl_irrig_0.5.mz"]          <- "avl_irrig_0.5.mz"
    files2copy["transport_distance_0.5.mz"] <- "transport_distance_0.5.mz"
    files2copy["calibrated_area_0.5.mz"]    <- "calibrated_area_0.5.mz"
    files2copy["protect_area_0.5.mz"]       <- "protect_area_0.5.mz"
    files2copy["avl_land_si_0.5.mz"]        <- "avl_land_si_0.5.mz"
    files2copy["aff_unrestricted_0.5.mz"]   <- "aff_unrestricted_0.5.mz"
    files2copy["aff_noboreal_0.5.mz"]       <- "aff_noboreal_0.5.mz"
    files2copy["aff_onlytropical_0.5.mz"]   <- "aff_onlytropical_0.5.mz"
    files2copy["koeppen_geiger_0.5.mz"]     <- "koeppen_geiger_0.5.mz"
    files2copy["f59_som_initialisation_pools_0.5.mz"]      <- "f59_som_initialisation_pools_0.5.mz"
    
    if (rev >= 25) {
      files2copy["rr_layer_0.5.mz"]           <- "rr_layer_0.5.mz"
      files2copy["luh2_side_layers_0.5.mz"]   <- "luh2_side_layers_0.5.mz"
    }  
    if (rev >= 26) {
      files2copy["f38_croparea_initialisation_0.5.mz"]      <- "f38_croparea_initialisation_0.5.mz"
    }		
    if (rev >= 29) {
      files2copy["forestageclasses_0.5.mz"]   <- "forestageclasses_0.5.mz"
    }
    if (rev >= 31) {
      files2copy["avl_land_t_0.5.mz"]         <- "avl_land_t_0.5.mz"
    } else {
      files2copy["avl_land_0.5.mz"]           <- "avl_land_0.5.mz"
    }
		if (rev >= 32) {
			files2copy["npi_ndc_ad_aolc_pol_0.5.mz"] <- "npi_ndc_ad_aolc_pol_0.5.mz"
			files2copy["npi_ndc_aff_pol_0.5.mz"]       <- "npi_ndc_aff_pol_0.5.mz"
		} else if (rev >= 28) {
			files2copy["npi_ndc_ad_pol_0.5.mz"]        <- "npi_ndc_ad_pol_0.5.mz"
			files2copy["npi_ndc_aff_pol_0.5.mz"]       <- "npi_ndc_aff_pol_0.5.mz"
			files2copy["npi_ndc_emis_pol_0.5.mz"]      <- "npi_ndc_emis_pol_0.5.mz"
		} else {
			files2copy["indc_ad_pol_0.5.mz"]        <- "indc_ad_pol_0.5.mz"
			files2copy["indc_aff_pol_0.5.mz"]       <- "indc_aff_pol_0.5.mz"
			files2copy["indc_emis_pol_0.5.mz"]      <- "indc_emis_pol_0.5.mz"
		}
		
    for(i in 1:length(files2copy)) file.copy(path(input2_folder,files2copy[i]),path(output_folder,names(files2copy[i])),copy.mode=FALSE)
  }
  copyOtherInputs(input2_folder, output_folder,rev)

  cat("calibrate LAI\n")
  source("calibrate_lai.R")
  calibrate_lai(input_file = path(input_folder,'pft_harvest.pft'),
                area_file = path(input2_folder,'calibrated_area_0.5.mz'),
                cntr_LAI_file = path(output_folder,"cntr.LAI.RData"),
                start_year = start_year,
                nbands = 32,
                avg_range = avg_range,
                lai_range = lai_range)


  cat("yields\n")
  source("yields.R")
  yields(input_file =  path(input_folder,'pft_harvest.pft'),
         cntr_LAI_file = path(output_folder,"cntr.LAI.RData"),
         output_file = path(output_folder,'lpj_yields_0.5.mz'),
         ndigits = 2,                    # Number of digits in output file
         start_year = start_year,              # Start year of data set
         years = years,    # Vector of years that should be exported
         nbands = 32,                    # Number of bands in the .bin file
         avg_range = avg_range,         # Number of years used for averaging
         lai_range = lai_range,                # possible LAImax values
         sLAI = sLAI)


  cat("growing period\n")
  source("grow_period.R")
  
  if(rev >= 31){
    write.magpie(setYears(read.magpie(path(output_folder,"avl_land_t_0.5.mz"))[,"y1995",],NULL),
                 "avl_land_y1995_0.5.mz", file_folder = output_folder)
    avl_land <- "avl_land_y1995_0.5.mz"
  } else{
    avl_land <- "avl_land_0.5.mz"
  }
  
  grow_period(sowd_file   = path(input_folder,'sdate.bin'),
              hard_file   = path(input_folder,'hdate.bin'),
              yield_file  = path(output_folder,'lpj_yields_0.5.mz'),
              area_file   = path(output_folder, avl_land),
              damfile     = path(input2_folder,'dams_0.5.mz'),
              yield_ratio = 0.1, # threshold for cell yield over global average. crops in cells below threshold will be ignored
              grday_file  = path(output_folder,'mean_grdays_per_month_0.5.mz'),
              start_year  = start_year,                  #Start year of data set
              years       = years,        #Vector of years that should be exported
              nbands      = 24,                         # Number of bands in the .bin file
              avg_range   = avg_range)

  cat("water\n")
  source("water.R")
  water(discharge_file      = path(input_folder,'mdischarge_natveg.bin'),
        runoff_file         = path(input_folder,'mrunoff_natveg.bin'),
        watdem_nonagr_file  = path(input2_folder,'watdem_nonagr_0.5.mz'),
        basin_file          = path(input2_folder,'rivers.RData'),
        grday_file              = path(output_folder,'mean_grdays_per_month_0.5.mz'),
        out_watavail_grper_file = path(output_folder,'lpj_watavail_grper_0.5.mz'),
        out_watavail_total_file = path(output_folder,'lpj_envflow_total_0.5.mz'),
        out_envflow_grper_file  = path(output_folder,'lpj_envflow_grper_0.5.mz'),
        out_envflow_total_file  = path(output_folder,'lpj_envflow_total_0.5.mz'),
        out_watdem_nonagr_grper_file = path(output_folder,'watdem_nonagr_grper_0.5.mz'),
        out_watdem_nonagr_total_file = path(output_folder,'watdem_nonagr_total_0.5.mz'),
        LFR_val        = 0.1, # Strictness of flow requirements.
        HFR_LFR_less10 = 0.2,  # High flow requirements in share of total water for cells with LFR<10% of total water
        HFR_LFR_10_20  = 0.15,  # High flow requirements in share of total water for cells with 10% < LFR < 20 % of total water
        HFR_LFR_20_30  = 0.07,  # High flow requirements in share of total water for cells with 20% < LFR < 30 % of total water
        HFR_LFR_more30 = 0.00,  # High flow requirements in share of total water for cells with LFR> 30 % of total water
        ndigits        = 0,                     #Number of digits in output file
        start_year     = start_year,                  #Start year of data set
        years          = years,          #Vector of years that should be exported
        nbands         = 1,                     # Number of bands in the .bin file
        avg_range      = avg_range)


  cat("carbon\n")
  source("carbon.R")
  carbon(natveg_vegc_file       = path(input_folder,'vegc_natveg.bin'),
         natveg_soilc_file      = path(input_folder,'soilc_natveg.bin'),
         natveg_litc_file       = path(input_folder,'litc_natveg.bin'),
         c_share_released_file  = path(input2_folder,'cshare_released_0.5.mz'),
         pastc_file             = path(input2_folder,'lpj_carbon_pasture_0.5.mz'),
         out_carbon_stocks_file = path(output_folder,'lpj_carbon_stocks_0.5.mz'),
         ndigits     = 2,                    # Number of digits in output file
         start_year  = start_year,                 # Start year of data set
         years       = years,         # Vector of years that should be exported
         nbands      = 1,                    # Number of bands in the .bin file
         avg_range   = avg_range)


  cat("irrigation\n")
  source("irrigation.R")
  irrigation(input_file    = path(input_folder,'pft_airrig.pft'),
             output_file   = path(output_folder,'lpj_airrig_0.5.mz'),
             cntr_LAI_file = path(output_folder,"cntr.LAI.RData"),
             ndigits     = 0,                     # Number of digits in output file
             start_year  = start_year,                  # Start year of data set
             years       = years,  # Vector of years that should be exported
             nbands      = 32,                    # Number of bands in the .bin file
             avg_range   = avg_range,             # Number of years used for averaging
             lai_range   = lai_range,                   # possible LAImax values
             sLAI        = sLAI)

  cwd <- getwd()
  setwd(output_folder)
  trash <- system("tar -czf data.tgz *", intern = TRUE)
  setwd(cwd)
  if(!dir.exists(dirname(output_file))) dir.create(dirname(output_file),recursive = TRUE)
  file.copy(paste0(output_folder,"/data.tgz"),output_file)
  unlink(paste0(output_folder,"/data.tgz"))
  if(!debug) unlink(output_folder, recursive = TRUE, force = TRUE)
}
