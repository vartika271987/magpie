start_preprocessing <- function(cfg, debug=FALSE){
  require(gms)
  require(madrat)
  require(mrland)
  require(mrmagpie)
  require(mrvalidation)
 
  ### check and clean settings ###
  cfg <- gms::check_config(cfg, modulepath = NULL)
  if(!grepl(".csv$",cfg$regionmapping)) cfg$regionmapping <- paste0("regionmapping", cfg$regionmapping, ".csv")
  if(!file.exists(cfg$regionmapping))   cfg$regionmapping <- paste0("config/",cfg$regionmapping)
  if(is.null(cfg$dev)) cfg$dev <- ""
  
  message(paste0("Start preprocessing for \n climatescenario: ",cfg$climatetype, "\n rev: ",cfg$revision,
                 "\n regionmapping: ", cfg$regionmapping, "\n clustertype: ",cfg$ctype,
                 "\n LPJmL-Versions: ", paste(names(cfg$lpjml), cfg$lpjml, sep = "->", collapse = ", "),
                 "\n clusterweight: ", paste(names(cfg$clusterweight), cfg$clusterweight, sep = ":", collapse = ", ")))

  madrat::setConfig(regionmapping=cfg$regionmapping, nocores=cfg$nocores, debug=debug) 
  madrat::retrieveData(model="MAgPIE",         rev=cfg$revision, dev=cfg$dev)
  madrat::retrieveData(model="CellularMAgPIE", rev=cfg$revision, dev=cfg$dev, 
                                               ctype=cfg$ctype, lpjml=cfg$lpjml, 
                                               climatetype=cfg$climatetype, clusterweight=cfg$clusterweight)
  madrat::retrieveData(model="Validation",     rev=cfg$revision, dev=cfg$dev)
}
