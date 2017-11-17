#################################################
#### Preprocessing for MAgPIE 4.0 test runs  ####
#################################################

source("preprocessing.R")

#set defaults
source("config/default.cfg")


#cellular data
cfg$revision <- 24.1
#regional data (moinput)
cfg$revision2 <- 2.2


'select_resolution = c("h200")
select_regionmapping = c("H11")
select_climatescen = c("a1b","a2","b1")
select_climatemodel = c("miub_echo_g","mpi_echam5","ukmo_hadcm3")

for (select_resolution_x in select_resolution) {
  cfg$low_res <- select_resolution_x
  for (select_regionmapping_x in select_regionmapping) {
    cfg$regionmapping <- paste0("config/regionmapping",select_regionmapping_x,".csv")
    for (select_climatescen_x in select_climatescen){
      for (select_climatemodel_x in select_climatemodel) {
        for (select_co2_x in c("constant_co2","dynamic_co2")) {
          
          cfg$input <- paste0(
            "glues2_sres","/",
            select_climatemodel_x,"/",
            select_climatescen_x,"/",
            select_co2_x
            
          )
          start_preprocessing(cfg)
        }
      }
    }
  }
}'



#select_resolution = c("h50","h200","h300")
select_resolution = c("h200")
select_regionmapping = c("H11","AgMIP")
select_climatescen = c("rcp2p6","rcp4p5","rcp6p0","rcp8p5")
#select_climatemodel = c("IPSL_CM5A_LR","GFDL_ESM2M","HadGEM2_ES","MIROC_ESM_CHEM","MIROC5","NorESM1_M")
select_climatemodel = c("IPSL_CM5A_LR")


for (select_resolution_x in select_resolution) {
  cfg$low_res <- select_resolution_x
  for (select_regionmapping_x in select_regionmapping) {
    cfg$regionmapping <- paste0("config/regionmapping",select_regionmapping_x,".csv")
    for (select_climatescen_x in select_climatescen){
      for (select_climatemodel_x in select_climatemodel) {
        for (select_co2_x in c("noco2","co2")) {
          cfg$input <- paste0(
            "isimip_rcp","/",
            select_climatemodel_x,"/",
            select_climatescen_x,"/",
            select_co2_x
          )
          start_preprocessing(cfg)
        }
      }
    }
  }
}





