##########################################################
# author: Ignacio Sarmiento-Barbieri
# based on Peter Christensen's code
##########################################################

#Clean the workspace
rm(list=ls())
cat("\014")
local({r <- getOption("repos"); r["CRAN"] <- "http://cran.r-project.org"; options(repos=r)}) #set repo


#Load Packages
pkg<-c("survival","dplyr","doMC","rgeos","spdep","sp","stargazer", "pwr")
lapply(pkg, require, character.only=T)
rm(pkg)

#Set WD local
setwd("~/Dropbox/Research/Toxic_Discrimination/")

#Load Data Shared Drive
matchedinquiries <- readRDS("/Volumes/share/projects/Trulia/stores/matchedinquiries_HOU.rds")


### Test Heterogeneity by Gender & education_level & inquiry_order
CS4 <- clogit( choice ~ race + gender + education_level + as.factor(as.numeric(inquiry_order)) + strata(Address), data = matchedinquiries)
stargazer(CS4,omit="strata*",type="text")   
summary(CS4)


#Load shapefile with 1 mile buffers
plants_buffer<-readRDS("stores/zipcodes_within_1_mile_plant.rds")
plants_buffer_data<-plants_buffer@data
plants_buffer_data<-plants_buffer_data[is.na(plants_buffer_data$ZCTA5CE10)==FALSE,]
colnames(plants_buffer_data)[colnames(plants_buffer_data)=="ZCTA5CE10"]<-"zipcode"

#Add all the relevant info from plants
plants1<-readRDS("stores/plants_colapsed.rds")
plants_buffer_data<-left_join(plants_buffer_data,plants1)

#Keep matched inquires in zipcodes that are within 1 mile of a toxic plant
matchedinquiries <-matchedinquiries %>% mutate(zip_near_plant=ifelse(Zip_Code%in%plants_buffer_data$zipcode,1,0))
matchedinquiries <- matchedinquiries %>% filter(zip_near_plant==1)

#Identify listings in zipcodes within 1 mile of a toxic plant
lmat <- matchedinquiries[,c("Longitude","Latitude")]
spdata <- SpatialPointsDataFrame(lmat,lmat)
proj4string(spdata)<-CRS("+proj=longlat +datum=WGS84")
plants_buffer<-spTransform(plants_buffer,CRS("+proj=longlat +datum=WGS84"))
matchedinquiries$within_mile<-sp::over(spdata,plants_buffer)$id


#Generate a variable that takes 1 if it is within the 1 mile buffer
matchedinquiries<-matchedinquiries %>% mutate(toxic=ifelse(is.na(within_mile)==FALSE,1,0))
prop.table(table(matchedinquiries$toxic,useNA = 'always'))
with(matchedinquiries,tapply(RSEI,toxic,mean)) #higher RSEI within 1 mile

############################################################
# Slides JPAL
############################################################

#Response rates by race
stargazer(data.frame(response.rates=with(matchedinquiries,tapply(response,race,mean))),type="text",summary=FALSE)

matchedinquiries<- matchedinquiries %>% mutate(no_white=ifelse(race=="white",0,1))
N<-dim(matchedinquiries)[1]/3
N
summary(lm(response~no_white,matchedinquiries))
sigma_b<-coef(summary(lm(response~no_white,matchedinquiries)))[2,2]
b<-coef(summary(lm(response~no_white,matchedinquiries)))[2,1]
#d<-b/sigma_b

MDE<-abs(qt(.025,1263)+qt(.1,1263))*sigma_b
MDE

power.t.test(n = , delta = b, sd=sigma_b, sig.level = .05, power = .9, type = c('paired'), alternative = c("two.sided"))
pwr.t.test(n = , d = MDE, sig.level = .05, power = .9, type = c('paired'), alternative = c("two.sided"))

############################################################
# proximity to TRI
############################################################
stargazer(data.frame(proximity.to.tri=with(matchedinquiries[matchedinquiries$race=="white",],mean(toxic))),type="text",summary=FALSE)

############################################################
# Approach 2 use the coef of the regressions
############################################################

############################################################
# Approach 2a use the smallest
############################################################


CS4 <- clogit( choice ~ race + gender + education_level + as.factor(as.numeric(inquiry_order)) + strata(Address), data = matchedinquiries)
CS5 <- clogit( choice ~ race + toxic + gender + education_level + as.factor(as.numeric(inquiry_order)) + strata(Address), data = matchedinquiries) 
CS6 <- clogit( choice ~ race + race:toxic + gender + education_level + as.factor(as.numeric(inquiry_order)) + strata(Address), data = matchedinquiries)
stargazer(CS4,CS5,CS6,omit="strata*",type="text")   #CS5 drops toxic bc it's a property fixed effects model

#Reorder race factor to get something that makes more sense, still won't reorder for baseline
matchedinquiries$racereorder<-factor(matchedinquiries$race,levels(matchedinquiries$race)[c(3,2,1)])
CS7 <- clogit( choice ~ racereorder + toxic:racereorder + gender + education_level + as.factor(as.numeric(inquiry_order)) + strata(Address), data = matchedinquiries)
stargazer(CS4,CS5,CS6,CS7,omit="strata*",type="text")   


d= 0.380/0.427 #coef black*toxic
pwr.t.test(n = , d =d , sig.level = .05, power = .9, type = c('paired'), alternative = c("two.sided"))

d=0.159/0.428 #coef hispanic*toxic
pwr.t.test(n = , d = d, sig.level = .05, power = .9, type = c('paired'), alternative = c("two.sided"))


#Separate regressions for within 1 mile and outside
CS8<-clogit( choice ~ race  + gender + education_level + as.factor(as.numeric(inquiry_order)) + strata(Address), data = matchedinquiries %>% filter(toxic==1))
CS9<-clogit( choice ~ race  + gender + education_level + as.factor(as.numeric(inquiry_order)) + strata(Address), data = matchedinquiries %>% filter(toxic==0))
stargazer(CS8,CS9,omit="strata*",column.labels=c("Within 1 mile","outside 1 mile"),type="text")
summary(CS8)
summary(CS9)


d=0.1028/0.4073 #min between black or hispanic within 1 mile
pwr.t.test(n = , d = d, sig.level = .05, power = .9, type = c('paired'), alternative = c("two.sided"))


d=0.232/0.206 #min between black or hispanic ouside 1 mile
pwr.t.test(n = , d = d, sig.level = .05, power = .9, type = c('paired'), alternative = c("two.sided"))


############################################################
# Approach 2b use non whites
############################################################
CS10 <- clogit( choice ~ no_white + toxic:no_white + gender + education_level + as.factor(as.numeric(inquiry_order)) + strata(Address), data = matchedinquiries)
stargazer(CS10,omit="strata*",type="text")   


d=0.271/0.373 #interaction non white x within 1 mile
pwr.t.test(n = , d = d, sig.level = .05, power = .9, type = c('paired'), alternative = c("two.sided"))
