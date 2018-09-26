#Intersect zip codes

# identifier<-plant_name_list[[3]]
# db<-plants1
# zipshape<-zip
long2UTM <- function(long) {
  #gets utm zone: https://stackoverflow.com/questions/9186496/determining-utm-zone-to-convert-from-longitude-latitude
  (floor((long + 180)/6) %% 60) + 1
}




intersect_zip_codes<-function(identifier,db,zipshape){
  ##########################################################
  #The funciton takes the plantname from the data set db
  # generates a 1 mile buffer
  # intersects the zipcodes in that buffer
  ##########################################################
  
  db<- db %>% filter(id==identifier)
  db<-data.frame(db)
  lmat <- db[,c("longitude","latitude")]
  spdata <- SpatialPointsDataFrame(lmat,lmat)
  proj4string(spdata)<-CRS("+proj=longlat +datum=WGS84")
  
  
  # Define the Proj.4 spatial reference 
  # http://spatialreference.org/ref/epsg/26915/proj4/
  sr <- CRS(paste0("+proj=utm +zone=",long2UTM(db$longitude)," +ellps=GRS80 +datum=NAD83 +units=m +no_defs" ))
  spdata_mts<-spTransform(spdata,CRS=sr)
  meters<-1*1609.34
  gb<-gBuffer(spdata_mts,width=meters, byid=TRUE )
  
  gb<-spTransform(gb,CRS=proj4string(zipshape))
  
  gb_int<-raster::intersect(gb,zipshape)
  if(is.null(gb_int)){
    gb_int<-gb
    gb_int@data$intersection<-FALSE
  } else{
    gb_int@data$intersection<-TRUE
  }
  gb_int@data$id<-identifier  
  
  return(gb_int)
  
  
}

#end2
