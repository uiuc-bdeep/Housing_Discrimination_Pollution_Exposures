##########################################################
# author: Ignacio Sarmiento-Barbieri
#
##########################################################

#Clean the workspace
rm(list=ls())
cat("\014")
local({r <- getOption("repos"); r["CRAN"] <- "http://cran.r-project.org"; options(repos=r)}) #set repo



#Load Packages
pkg<-list("dplyr","leaflet","rgeos","sp","doMC","rgdal","raster")
lapply(pkg, require, character.only=T)
rm(pkg)


setwd("~/Dropbox/Research/toxic_discrimination")

##########################################################
#read zipcodes shapefile
# shapefile from Census
# https://www.census.gov/geo/maps-data/data/cbf/cbf_zcta.html
##########################################################
zip<-rgdal::readOGR("stores/zipcodes/cb_2017_us_zcta510_500k.shp", layer="cb_2017_us_zcta510_500k")
zip@data<-zip@data %>% mutate_all(as.character)
zip@data<-data.frame(zip@data)

plants1<-readRDS("stores/firms_example_1_mile.rds")
plants1<- plants1 %>% distinct(tri_facility_id,frs_id, facility_name, street_address, city, county, st, zip_plant,  latitude, longitude,federal_facility, industry_sector_code, industry_sector,.keep_all = TRUE)
plants1<- plants1 %>% group_by(facility_name) %>% mutate(n=n()) %>% ungroup()

plants1<-plants1 %>% mutate(id=paste0(facility_name,"_",latitude,"_",longitude))



plants1$latitude<-as.numeric(plants1$latitude)
plants1$longitude<-as.numeric(plants1$longitude)
# identifier<-plants1$id[1]
# db<-plants1
plant_name_list<-as.list(unique(plants1$id))
# identifier<-plant_name_list[[1]]
# db<-plants1
# zipshape<-zip

source("scripts/0_helper/1_intersect_zip.R")

cores<-4
r<-mclapply(plant_name_list,intersect_zip_codes,db=plants1,zipshape=zip ,mc.cores=cores)

#save.image("stores/test.rda")

z<-do.call(rbind,r)




zip_subset<-zip[zip$ZCTA5CE10%in%z@data$ZCTA5CE10,]

zip_subset<-spTransform(zip_subset,CRS=CRS("+proj=longlat +datum=WGS84"))


leaflet(data=plants1) %>%
  addTiles(group = "OSM") %>%  # Add default OpenStreetMap map tiles
  addTiles() %>%
  addMarkers( ~longitude, ~latitude, popup = ~as.character(plants1$facility_name), label = ~as.character(paste0(plants1$facility_name,plants1$total_releases))) %>%
  addPolygons(data=zip_subset,color = "grey", weight = 1, smoothFactor = 0.5, opacity = 1.0, fillOpacity = 0.5, popup =  ~as.character(zip_subset$ZCTA5CE10)) %>%
  addPolygons(data=z,color = "red", weight = 1, smoothFactor = 0.5, opacity = 1.0, fillOpacity = 0.5, popup =  ~as.character(z$facility_name)) %>%
  addPolygons(data=zip,color = "blue", weight = 1, smoothFactor = 0.5, opacity = 1.0, fillOpacity = 0.5, popup =  ~as.character(zip$ZCTA5CE10))

# end2

