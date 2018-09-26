##########################################################
# author: Ignacio Sarmiento-Barbieri
#
##########################################################

#Clean the workspace
rm(list=ls())
cat("\014")
local({r <- getOption("repos"); r["CRAN"] <- "http://cran.r-project.org"; options(repos=r)}) #set repo



#Load Packages
pkg<-list("dplyr","rgeos","sp","doMC","rgdal","raster")
lapply(pkg, require, character.only=T)
rm(pkg)


setwd("~/Dropbox/Research/Toxic_Discrimination")

##########################################################
#read zipcodes shapefile
# shapefile from Census
# https://www.census.gov/geo/maps-data/data/cbf/cbf_zcta.html
##########################################################
zip<-rgdal::readOGR("stores/zipcodes/cb_2017_us_zcta510_500k.shp", layer="cb_2017_us_zcta510_500k")
zip@data<-zip@data %>% mutate_all(as.character)
zip@data<-data.frame(zip@data)

plants1<-readRDS("stores/plants_colapsed.rds")
plants1<-plants1 %>% mutate(id=paste0(facility_name,"_",latitude,"_",longitude))
saveRDS(plants1,"stores/plants_colapsed.rds")
# plants1$latitude<-as.numeric(plants1$latitude)
# plants1$longitude<-as.numeric(plants1$longitude)

plant_name_list<-as.list(unique(plants1$id))

source("scripts/0_helper/1_intersect_zip.R")

cores<-20
r<-mclapply(plant_name_list,intersect_zip_codes,db=plants1,zipshape=zip ,mc.cores=cores)

save.image("stores/zipcoder_1_mile_raster.RData")


#end3

