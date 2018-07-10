#################################################
#### Script to start a MAgPIE preprocessing  ####
#################################################


library(moinput)
retrieveData(model="MAgPIE", regionmapping="config/regionmappingH11.csv", rev=2.07)
retrieveData(model="MAgPIE", regionmapping="config/regionmappingH12.csv", rev=2.07)
retrieveData(model="MAgPIE", regionmapping="config/regionmappingMAgPIE.csv", rev=2.07)
