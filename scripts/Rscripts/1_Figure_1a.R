##########################################################################################################
#Replication Files for Housing Discrimination and the Toxics Exposure Gap in the United States: 
#Evidence from the Rental Market  by Peter Christensen, Ignacio Sarmiento-Barbieri and Christopher Timmins
##########################################################################################################

#Clean the workspace
rm(list=ls())
cat("\014")
local({r <- getOption("repos"); r["CRAN"] <- "http://cran.r-project.org"; options(repos=r)}) #set repo


#Load Packages
pkg<-c("dplyr","rgdal","ggmap","maps","ggthemes")
lapply(pkg, require, character.only=T)
rm(pkg)

# load data sets ----------------------------------------------------------
dta<-read.csv("../stores/Potential_zips.csv")

zip<-rgdal::readOGR("../stores/zipcodes/cb_2017_us_zcta510_500k.shp", layer="cb_2017_us_zcta510_500k")
zip@data<-zip@data %>% mutate_all(as.character)
zip@data<-data.frame(zip@data)


zip_subset<-zip[zip@data$ZCTA5CE10%in%dta$zipcodes,]
zip_subset<-spTransform(zip_subset,CRS=CRS("+proj=longlat +datum=WGS84"))


us_states <- map_data("state")


ggplot(data = us_states, mapping = aes(x = long, y = lat, group = group)) +
  geom_polygon(color = "gray48", fill="white", size = 0.2) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45)  +
  geom_polygon(data=zip_subset, aes(x=long, y=lat, group=group), color="black", alpha=1) +
  theme_map() +
  theme(plot.margin=grid::unit(c(0,0,0,0), "cm"), 
        #legend.justification=c(.95,.95), 
        legend.position="right",#c(.95,.95), 
        legend.key = element_rect(fill = "white"),
        text = element_text(size=10),
        axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank()) 
ggsave("../views/fig1a.pdf")


