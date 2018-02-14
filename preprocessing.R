start_preprocessing <- function(cfg){

  require(digest)
  require(lucode)
  require(magclass)
  require(tools)
  require(moinput)
  require(mrvalidation)
  require(ludata)

  cfg <- check_config(cfg, modulepath = NULL)

  set_folder <- paste(gsub("/","-",cfg$input),"_rev",cfg$revision,sep="")
  cat(paste0("Start preprocessing for ",set_folder))

  retrieveData(model="MAgPIE",     regionmapping=cfg$regionmapping, rev=cfg$revision2)
  retrieveData(model="Validation", regionmapping=cfg$regionmapping, rev=cfg$revision2)

  source_include <- TRUE

  if(!dir.exists(cfg$base_folder)) dir.create(cfg$base_folder, recursive = TRUE)

  wkey <- ifelse(is.null(cfg$cluster_weight), "", gsub(".","",paste0("_",names(cfg$cluster_weight),cfg$cluster_weight,collapse=""),fixed=TRUE))

  lpj2magpie_file <- paste0(cfg$base_folder,"/",set_folder,"_",cfg$high_res,".tgz")
  aggregation_file <- paste0(cfg$base_folder,"/",set_folder,"_",cfg$low_res,wkey,"_",regionscode(cfg$regionmapping),"_soillayertest.tgz")

  if(cfg$force_preprocessing | !file.exists(lpj2magpie_file)){
    cat("Data is converted first from LPJ output format to MAgPIE input format!\n")
    convert_data 	 <- TRUE
    aggregate_data <- TRUE
  } else if(!file.exists(aggregation_file)){
    cat(paste("Data set exists in",cfg$high_res,"resolution, but the requested",cfg$low_res,"resolution is missing!\n"))
    convert_data   <- FALSE
    aggregate_data <- TRUE
  } else {
    cat(paste("Needed data exists in",cfg$low_res,"resolution and just has to be downloaded from archive!\n"))
    return()
  }

  if(convert_data) {
    cat("Needed data is now extracted from LPJ output!\n")
    setwd("lpj2magpie")
    source("main.R")
    lpj2magpie(input_folder  = path(cfg$lpj_input_folder,gsub('-','/',cfg$input)),
               input2_folder = path(cfg$additional_input_folder ,paste("rev",floor(cfg$revision),sep="")),
               output_file   = lpj2magpie_file,
               rev = cfg$revision)
    setwd("..")
  }

  if(aggregate_data) {
    cat("Data is now aggregated!\n")
    setwd("aggregation")
    source("main.R")
    aggregation(input_file    = lpj2magpie_file,      # path to the data that should be used for aggregation
                regionmapping = paste0("../",cfg$regionmapping), # path to regionmapping
                output_file   = aggregation_file,       # file path to which the data should be written
                rev           = cfg$revision,               # MAgPIE revision
                res_high      = cfg$high_res,               # Input high resolution
                res_low       = cfg$low_res,                # input low resolution
                hcells        = cfg$highres_cells,
                weight        = cfg$cluster_weight,
                nrepeat       = cfg$nrepeat,
                nredistribute = cfg$nredistribute,
                sum_spam_file = NULL,
                debug         = FALSE)
    setwd("..")
    cat("aggregated data written to ",aggregation_file,"\n")
  }
}
