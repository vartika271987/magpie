# (C) 2008-2016 Potsdam Institute for Climate Impact Research (PIK),
# authors, and contributors see AUTHORS file
# This file is part of MAgPIE and licensed under GNU AGPL Version 3
# or later. See LICENSE file or go to http://www.gnu.org/licenses/
# Contact: magpie@pik-potsdam.de

# *********************************************************************
# *** This script calculates low resolution input data under use of ***
# ***             a high resolution base data set                   ***
# *********************************************************************


aggregation <- function(input_file    = "path/input.tgz",      # path to the data that should be used for aggregation
                        regionmapping = "../config/regionmappingH12.csv", # path to regionmapping
                        output_file   = "path/output.tgz",     # file path to which the data should be written
                        rev           = 23,                    # MAgPIE revision
                        res_high      = 0.5,                   # Input high resolution
                        res_low       = "n100",                # input low resolution
                        hcells        = NULL,
                        weight        = NULL,
                        nrepeat       = 5,
                        nredistribute = 0,
                        sum_spam_file = NULL,
                        debug         = FALSE) {

  require(magclass)
  require(luscale)
  require(lucode)
  require(luplot)
  require(digest)
  require(tools)
  require(moinput)

  cat("Aggregate data:\n")
  umask <- Sys.umask("2")
  on.exit(Sys.umask(umask))

  # read spatial header information (spatial_header and corresponding regionscode)
  spatial_header <- spatial_header(regionmapping)
  regionscode    <- regionscode(regionmapping)

  wkey <- ifelse(is.null(weight), "", gsub(".","",paste0("_",names(weight),weight,collapse=""),fixed=TRUE))
  res_out <- paste0(res_low,ifelse(is.null(hcells),"",digest(hcells)),wkey)

  #########################################################################################

  if(rev<24) stop('Converter is not written for revisions < 24. Please use an older revision of the script instead!')

  if(is.numeric(res_out)) stop('Resolution "',res_out, '" is currently not supported as only cluster based aggregation is available (e.g. "n100").')

  res_high <- format(as.numeric(res_high), nsmall = 1)

  finput <- paste0("tmp/input_",format(Sys.time(),"%Y%m%d%H%M%S"))
  dir.create(finput,recursive=TRUE)
  cat("Extract inputs to ",finput,".\n")
  file.copy(input_file,paste0(finput,"/data.tgz"))
  cwd <- getwd()
  setwd(finput)
  trash <- system("tar -xvf data.tgz", intern = TRUE)
  unlink("data.tgz")
  setwd(cwd)

  foutput <- paste0("tmp/aggregation_",format(Sys.time(),"%Y%m%d%H%M%S"))
  dir.create(foutput,recursive=TRUE)
  cat("Use temp dir ",foutput,".\n")

  # create info file
  writeInfo <- function(f_in, f_out, res_high, res_out, regionscode, nrepeat, nredistribute, input_file, output_file) {
    functioncall <- paste(deparse(sys.call(-1)), collapse = "")
    info <- readLines(f_in)
    info <- c(info,'','aggregation settings:',
              paste('* Input resolution:',res_high),
              paste('* Output resolution:',res_out),
              paste('* Input file:',input_file),
              paste('* Output file:',output_file),
              paste('* Regionscode:',regionscode),
              paste('* (clustering) n-repeat:',nrepeat),
              paste('* (clustering) n-redistribute:',nredistribute),
              paste('* Call:', functioncall),
              '')
    cat(info,file=f_out,sep='\n')
  }
  writeInfo(path(finput,'info.txt'),path(foutput,'info.txt'), res_high, res_out, regionscode, nrepeat, nredistribute, input_file, output_file)


  # Create new grid
  if(is.null(sum_spam_file)){
    spam <- clusterspam(lr=res_low,hr=res_high,ifolder=finput,ofolder=foutput,cfiles=c("lpj_yields_0.5", "lpj_airrig", "transport_distance"),spatial_header=spatial_header, weight=weight)
  } else {
    if(!file.exists(sum_spam_file)) stop("Spam file", sum_spam_file," not found")
    file.copy(sum_spam_file,sub("res_in",res_high,sub("res_out",res_low,path(foutput,"res_in-to-res_out_sum.spam"))))
  }

  # Create new grid combining low_res and high_res if necessary
  if(exists("hcells")) if(!is.null(hcells)) {
    source_include <- TRUE
    input_spam_file<-sub("res_in",res_high,sub("res_out",res_low,"res_in-to-res_out_sum.spam"))
    output_spam_file<-sub("res_in",res_high,sub("res_out",res_out,"res_in-to-res_out_sum.spam"))
    folder<-foutput
    sys.source("combine.resolutions.R",envir=new.env())
    write.magpie(as.magpie(hcells),path(foutput,"highres_cells.mz"))
    file.remove(path(foutput,input_spam_file))
  }

  #plotspam(sub("res_in",res_high,sub("res_out",res_out,path(foutput,"res_in-to-res_out_sum.spam"))),name="spamplot",folder=foutput)


  ################################# Create SPAM files #####################################
  f <- list()

  #file name templates (just replace fname and fspam to get the right file name)
  tinput <- sub("res_in",res_high,path(finput,"fname_res_in.mz"))
  tspam  <- sub("res_in",res_high,sub("res_out",res_out,path(foutput,"res_in-to-res_out_fspam.spam")))

  ### area_weighted_mean ###
  x <- rowSums(read.magpie(sub("fname","avl_land",tinput)))
  rel <- sub("fspam","sum",tspam)
  fname <- sub("fspam","area_weighted_mean",tspam)
  create_spam(x,rel,fname=fname)
  cat("SPAM area_weighted_mean created!\n")

  ### crop_area_weighted_mean ###
  x <- rowSums(read.magpie(sub("fname","avl_land",tinput))[,1,"crop"])
  rel <- sub("fspam","sum",tspam)
  fname <- sub("fspam","crop_area_weighted_mean",tspam)
  create_spam(x,rel,fname=fname)
  cat("SPAM crop_area_weighted_mean created!\n")

  ### soilc_weighted_mean ###
  x <- read.magpie(sub("fname","lpj_carbon_stocks",tinput))[,1,"other.soilc"]
  rel <- sub("fspam","sum",tspam)
  fname <- sub("fspam","soilc_weighted_mean",tspam)
  create_spam(x,rel,fname=fname)
  cat("SPAM soilc_weighted_mean created!\n")



  ################################### Aggregate data ######################################

  f <- NULL
  # USAGE:
  # f[<name of data set>] <- <aggregation to use>

  f["aff_unrestricted"]             <- "area_weighted_mean"
  f["aff_noboreal"]                 <- "area_weighted_mean"
  f["aff_onlytropical"]             <- "area_weighted_mean"
  f["koeppen_geiger"]               <- "area_weighted_mean"
  f["avl_land"]                     <- "sum"
  f["avl_land_si"]                  <- "sum"
  f["avl_irrig"]                    <- "sum"
  f["protect_area"]                 <- "sum"
  f["lpj_airrig"]                   <- "crop_area_weighted_mean"
  f["lpj_yields"]                   <- "crop_area_weighted_mean"
  f["transport_distance"]           <- "area_weighted_mean"
  f["lpj_carbon_stocks"]            <- "area_weighted_mean"
  f["lpj_watavail_grper"]           <- "sum"
  f["lpj_envflow_grper"]            <- "sum"
  f["watdem_nonagr_grper"]          <- "sum"
  f["f59_som_initialisation_pools"]  <- "sum"
  
  if (rev >= 25) {
    f["rr_layer"]                      <- "area_weighted_mean"
    f["luh2_side_layers"]              <- "area_weighted_mean"
  }
  if (rev >= 26) {
    f["f38_croparea_initialisation"]   <- "sum"
  }
	if (rev >= 28) {
		f["npi_ndc_ad_pol"]               <- "sum"
		f["npi_ndc_aff_pol"]              <- "sum"
		f["npi_ndc_emis_pol"]             <- "sum"
	} else {
		f["indc_ad_pol"]                  <- "sum"
		f["indc_aff_pol"]                 <- "sum"
		f["indc_emis_pol"]                <- "sum"
	}
  if (rev >= 29) {
    f["forestageclasses"]   <- "sum"
  }
  

  for(n in names(f)) {
    input_file <- path(finput,paste(n,"_",res_high,".mz",sep=""))
    spam_file <- path(foutput,paste(res_high,
                                    "-to-", res_out,
                                    "_",f[n],".spam", sep = ""))
    outfile <- path(foutput,paste(n,"_",res_out,".mz",sep=""))

    # replace spatial names with spatial header (to make sure that the right region names are used)
    input <- read.magpie(input_file)
    if(!is.null(spatial_header)) getCells(input) <- spatial_header

    if (n == "aff_unrestricted" | n == "aff_noboreal" | n == "aff_onlytropical") {
      write.magpie(round(speed_aggregate(input,spam_file,fname=NULL)),file_name=outfile)
    } else speed_aggregate(input,spam_file,fname=outfile)
  }
  cat(paste("aggregated", res_low, "data\n"))

  ################################### Copy data ######################################

  f <- c("avl_land_0.5.mz","lpj_yields_0.5.mz","lpj_carbon_stocks_0.5.mz")
  file.copy(paste(finput,f,sep="/"),paste(foutput,f,sep="/"))
  cat(paste("copied required high res data\n"))


  cwd <- getwd()
  setwd(foutput)
  trash <- system("tar -czf data.tgz *", intern = TRUE)
  setwd(cwd)
  # create output folder
  if(!dir.exists(dirname(output_file))) dir.create(dirname(output_file),recursive=TRUE)
  file.copy(paste0(foutput,"/data.tgz"),output_file)
  unlink(paste0(foutput,"/data.tgz"))

  if(!debug) {
    unlink(finput, recursive = TRUE)
    unlink(foutput, recursive = TRUE)
  }

}
