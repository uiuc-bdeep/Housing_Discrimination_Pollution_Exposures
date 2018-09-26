##########################################################
# author: Ignacio Sarmiento-Barbieri
#
##########################################################

#Clean the workspace
rm(list=ls())
cat("\014")
local({r <- getOption("repos"); r["CRAN"] <- "http://cran.r-project.org"; options(repos=r)}) #set repo



#Load Packages
pkg<-list("dplyr","rgeos","sp","doMC","rgdal","stringr")
lapply(pkg, require, character.only=T)
rm(pkg)
require("leaflet")

setwd("~/Dropbox/Research/Toxic_Discrimination/")

load("stores/zipcoder_1_mile_raster.RData")

#get data from spatialPolygon
cores<-4
plants_buffer<-list()


xtr_fix<-function(db){if(is.null(db@data$ZCTA5CE10[1])==FALSE){ 
  db}else{
    db@data$ZCTA5CE10<-NA
    db@data$AFFGEOID10<-NA
    db@data$GEOID10<-NA
    db@data$ALAND10<-NA
    db@data$AWATER10<-NA
    db@data<-db@data[,c("longitude", "latitude", "ZCTA5CE10", "AFFGEOID10", "GEOID10", "ALAND10", "AWATER10", "intersection", "id")]
    return(db)}}

plants_buffer<-mclapply(r,xtr_fix,mc.cores=cores) #get the data frame
plants_buffer<-do.call(rbind,plants_buffer)
plants_buffer_data<-plants_buffer@data

plants_buffer_data<-plants_buffer_data[is.na(plants_buffer_data$ZCTA5CE10)==FALSE,]
colnames(plants_buffer_data)[colnames(plants_buffer_data)=="ZCTA5CE10"]<-"zipcode"

plants_buffer_data<-left_join(plants_buffer_data,plants1)

#On site releases https://www.epa.gov/toxics-release-inventory-tri-program/descriptions-tri-data-terms
plants1_q<-plants1 %>% filter(on.site_release_total>=quantile(on.site_release_total,.8))


plants_buffer_data<-plants_buffer_data %>% mutate(plants_top_80_percentile_on_site_releases=ifelse(zip_plant%in%plants1_q$zip_plant,1,0))

zips_priority<- plants_buffer_data %>% filter(plants_top_80_percentile_on_site_releases==1)
zips_priority_csv<- zips_priority %>% distinct(st,zipcode)

#zipcodes priority
zip_subset<-zip[zip$ZCTA5CE10%in%zips_priority$zipcode,]
zip_subset_data<-zip_subset@data
head(zip_subset_data)

# pdf("zip_99.pdf")
# plot(zip_subset)
# dev.off()

colnames(zip_subset_data)[colnames(zip_subset_data)=="ZCTA5CE10"]<-"zipcode"
zip_subset_data<-zip_subset_data[,c("zipcode")]


write.csv(zips_priority_csv,"stores/zipcodes_to_scrape_listings.csv")
