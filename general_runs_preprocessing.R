#################################################
#### Preprocessing for MAgPIE 4.0 test runs  ####
#################################################

source("preprocessing.R")

#set defaults
source("config/default.cfg")


#cellular data
cfg$revision <- 24
#regional data (moinput)
cfg$revision2 <- 2.2


select_resolution = c("h200")
select_regionmapping = c("H11")
select_climatescen = c("a2")
select_climatemodel = c("miub_echo_g")

for (select_resolution_x in select_resolution) {
  cfg$low_res <- select_resolution_x
  for (select_regionmapping_x in select_regionmapping) {
    cfg$regionmapping <- paste0("config/regionmapping",select_regionmapping_x,".csv")
    for (select_climatescen_x in select_climatescen){
      for (select_climatemodel_x in select_climatemodel) {
        for (select_co2_x in c("constant_co2","dynamic_co2")) {
          
          cfg$input <- paste0(
            "glues2_sres","/",
            select_climatescen_x,"/",
            select_co2_x,"/",
            select_climatemodel_x,"/"
          )
          start_preprocessing(cfg)
        }
      }
    }
  }
}



select_resolution = c("h200")
select_regionmapping = c("AgMIP")
select_climatescen = c("rcp2p6")
select_climatemodel = c("IPSL_CM5A_LR")

for (select_resolution_x in select_resolution) {
  cfg$low_res <- select_resolution_x
  for (select_regionmapping_x in select_regionmapping) {
    cfg$regionmapping <- paste0("config/regionmapping",select_regionmapping_x,".csv")
    for (select_climatescen_x in select_climatescen){
      for (select_climatemodel_x in select_climatemodel) {
        for (select_co2_x in c("constant_co2","dynamic_co2")) {
          
          cfg$input <- paste0(
            "isimip_rcp","/",
            select_climatescen_x,"/",
            select_co2_x,"/",
            select_climatemodel_x,"/"
          )
          start_preprocessing(cfg)
        }
      }
    }
  }
}





