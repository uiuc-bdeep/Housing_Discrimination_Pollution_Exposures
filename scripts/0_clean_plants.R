##########################################################
# author: Ignacio Sarmiento-Barbieri
#
##########################################################

#Clean the workspace
rm(list=ls())
cat("\014")
local({r <- getOption("repos"); r["CRAN"] <- "http://cran.r-project.org"; options(repos=r)}) #set repo



#Load Packages
pkg<-list("dplyr","leaflet","rgeos","sp","doMC","rgdal")
lapply(pkg, require, character.only=T)
rm(pkg)


setwd("~/Dropbox/Research/Toxic_Discrimination")


##########################################################
#read plants shapefile
##########################################################
# plants00<-read.csv("/Volumes/share/projects/Trulia/stores/TRI_Data/TRI_2016_US.csv",stringsAsFactors = FALSE)
# saveRDS(plants00,"stores/plants.rds")
plants0<-readRDS("stores/plants.rds")
plants<-plants0
colnames(plants)<-tolower(colnames(plants)) #colnames to lowercase


#clean missing langitude and longitude
plants<-plants[!is.na(plants$latitude),]
plants<-plants[!is.na(plants$longitude),]


plants<-plants %>% filter(!(st%in%c("AS","GU","MP"))) #get rid those not in US


plants<-plants %>% dplyr::select(tri_facility_id,frs_id, facility_name, street_address, city, county, st, zip,  latitude, longitude,federal_facility, industry_sector_code, industry_sector, unit_of_measure,starts_with("x5"), on.site_release_total,total_releases)


#Express everything on grams
plants<-plants %>% 
  mutate_at(vars(starts_with("x5"), on.site_release_total,total_releases),funs(ifelse(unit_of_measure=="Grams",.*0.00220462,.)))


#Collapse the data
plants<-plants %>%  group_by(tri_facility_id,frs_id, facility_name, street_address, city, county, st, zip,  latitude, longitude,federal_facility, industry_sector_code, industry_sector) %>% summarise_if(is.numeric, sum, na.rm = TRUE) %>% ungroup()

colnames(plants)[colnames(plants)=="zip"]<-"zip_plant"
plants<- plants[order(-plants$total_releases),]

saveRDS(plants,"stores/plants_colapsed.rds")
