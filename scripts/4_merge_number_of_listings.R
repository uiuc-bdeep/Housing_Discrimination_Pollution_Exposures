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
#saveRDS(plants_buffer,"stores/zipcodes_within_1_mile_plant.rds")
plants_buffer_data<-plants_buffer@data

plants_buffer_data<-plants_buffer_data[is.na(plants_buffer_data$ZCTA5CE10)==FALSE,]
colnames(plants_buffer_data)[colnames(plants_buffer_data)=="ZCTA5CE10"]<-"zipcode"

plants_buffer_data<-left_join(plants_buffer_data,plants1)

#On site releases https://www.epa.gov/toxics-release-inventory-tri-program/descriptions-tri-data-terms
plants1_q<-plants1 %>% filter(on.site_release_total>=quantile(on.site_release_total,.8))


plants_buffer_data<-plants_buffer_data %>% mutate(plants_top_80_percentile_on_site_releases=ifelse(zip_plant%in%plants1_q$zip_plant,1,0))

zips_priority<- plants_buffer_data %>% filter(plants_top_80_percentile_on_site_releases==1)

number_of_listings<-read.csv("stores/num_listings_per_zip.csv")
colnames(number_of_listings)[1]<-"zipcode"
number_of_listings$zipcode<-as.character(number_of_listings$zipcode)
table(str_length(number_of_listings$zipcode))
number_of_listings<- number_of_listings %>% mutate(zipcode=ifelse(str_length(zipcode)==3,paste0("00",zipcode),
                                                          ifelse(str_length(zipcode)==4,paste0("0",zipcode),zipcode)))
table(str_length(number_of_listings$zipcode))

# zips_by_plants<- zips_priority %>% group_by(zipcode,st) %>% summarize(number_of_plants=n())
# zips_by_plants<-left_join(zips_by_plants,number_of_listings)
# quantile(number_of_listings$num_listings)


zips_priority$zipcode<-as.character(zips_priority$zipcode)
table(str_length(zips_priority$zipcode))
zips_priority<- zips_priority %>% mutate(zipcode=ifelse(str_length(zipcode)==3,paste0("00",zipcode),
                                                                  ifelse(str_length(zipcode)==4,paste0("0",zipcode),zipcode)))





listings_by_plant<- merge(number_of_listings,zips_priority)
#write.csv(listings_by_plant,"stores/listings_by_plant.csv")


quantile(number_of_listings$num_listings)
no_botom_20<-number_of_listings %>% filter(num_listings>0)
quantile(no_botom_20$num_listings)
no_botom_20<-no_botom_20 %>% filter(num_listings>=quantile(num_listings,.5))



listings_by_plant <-listings_by_plant %>% mutate(top_80_listings=ifelse(zipcode%in%no_botom_20$zipcode,1,0))
listings_by_plant <-listings_by_plant %>% filter(top_80_listings==1)



listings_by_plant<- listings_by_plant %>% distinct(zipcode)

require("zipcode")
data(zipcode)
zipcode

listings_by_plant<-left_join(listings_by_plant,zipcode,by=c("zipcode" = "zip")) 
listings_by_plant<-listings_by_plant[,1:3]
listings_by_plant<- merge(listings_by_plant,number_of_listings)
df2 <- slice(listings_by_plant, sample(1:n()))
df2$order<-rownames(df2)
write.csv(df2,"zipcodes_treated_control.csv")
