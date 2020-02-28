##########################################################
# author: Ignacio Sarmiento-Barbieri
##########################################################

#Clean the workspace
rm(list=ls())
cat("\014")
local({r <- getOption("repos"); r["CRAN"] <- "http://cran.r-project.org"; options(repos=r)}) #set repo


#Load Packages
pkg<-c("dplyr","MatchIt")
lapply(pkg, require, character.only=T)
rm(pkg)


set.seed(1010101)

# Load matched inquiries data ---------------------------------------------
dta0<-haven::read_dta("stores/toxic_discrimination_data.dta")
dta0<- dta0 %>% filter(sample==1)
dta0<- dta0 %>% mutate(Address_ZIP=paste0(Address,"_",Zip_Code,"_",sample_round))

vars<-c("choice","quartileZIP_property","White","Black", "Hispanic","Minority","dec2" ,"dec3" ,"dec4", "Minority_dec2","Minority_dec3","Minority_dec4","Hispanic_dec2", "Hispanic_dec3", "Hispanic_dec4",
        "Black_dec2", "Black_dec3", "Black_dec4", "gender", "education_level","inquiry_order","Address","treated","rent","type","bedroom_max","bathroom_max","sqft","assault","groceries","hispanicshare","blackshare","whiteshare","povrate","college","Zip_Code","unemployed","sample_round","Address_ZIP")
drm<-0
Sys.sleep(drm)
dta0$treated<-NA
dta0<-dta0[,vars]
dta0$treated<-NULL

dta<- dta0 %>% distinct(Address,sample_round,Zip_Code,.keep_all = TRUE)



# Match 75-100 to 25-75 --------------------------------------------------------
dta1<-dta %>% filter(quartileZIP_property%in%c(4,3))

dta1 <-dta1 %>% mutate(treated=ifelse(quartileZIP_property==4,1,0))

dta1<-dta1[,vars]
dta1<-na.omit(dta1)

zips<-as.list(unique(dta$Zip_Code))

#db<-dta1 %>% filter(Zip_Code==zips[[5]])
matcher<-function(zip, db){
            db<- db %>% filter(Zip_Code==zip)
            mod_match1 <- matchit(treated~rent+type+bedroom_max+bathroom_max+sqft+assault+groceries+hispanicshare+blackshare+whiteshare+povrate+unemployed+college, 
                          method = "nearest", data = db)
    
            dta_m1 <- match.data(mod_match1)
            
            mat_matched<-cbind(db[row.names(mod_match1$match.matrix),"Address"], db[mod_match1$match.matrix,"Address"])
            colnames(mat_matched)<-c("Address","matched_Address"  )
            
            dta_m1<-left_join(dta_m1,mat_matched)  
            dta_m1
    }

matched<-lapply(zips, matcher,dta1)   
matched<-do.call(rbind,matched)


#keep matched Addresses
matched<-matched[,c("Address","matched_Address")]
matched<-matched[!is.na(matched$matched_Address),]
matched <- matched %>% group_by(matched_Address) %>% mutate(n=n()) %>% ungroup() #matching to unique
table(matched$n)
matched$n<-NULL

#start building the data set
dta1<-dta0 %>% filter(quartileZIP_property%in%c(4,3)) #keeps treated 4 and control 3
dta1<-left_join(dta1,matched) #matches to addreses matched
dta1<- dta1 %>% mutate(matched_Address=ifelse(is.na(matched_Address),Address,matched_Address)) #asigns to matched adrress the control address
dta1<- dta1 %>% group_by(matched_Address) %>% mutate(match=n()) #makes sure there are 6 observations per match
table(dta1$match)
dta1<-dta1 %>% filter(match==6) #keeps only 6
dta1$match<-NULL

#creates the Address treated so we can cluster on that
temp<-dta1[dta1$quartileZIP_property==4,c("Address","matched_Address")]
temp<- temp %>% distinct(.keep_all = TRUE)
colnames(temp)[1]<-"Address_treated"

dta1<-left_join(dta1,temp)

dta1<-dta1[order(dta1$matched_Address,-dta1$quartileZIP_property),]
#View(dta1[,c("quartileZIP_property","Address","matched_Address","Address_treated")])
rm(temp)
# # -----------------------------------------------------------------------


#Match 75-100 to 0-25
dta2<-dta %>% filter(quartileZIP_property%in%c(4,2))

dta2 <-dta2 %>% mutate(treated=ifelse(quartileZIP_property==4,1,0))

dta2<-dta2[,vars]
dta2<-na.omit(dta2)


matched_2<-lapply(zips, matcher,dta2)   
matched_2<-do.call(rbind,matched_2)


#keep matched Addresses
matched_2<-matched_2[,c("Address","matched_Address")]
matched_2<-matched_2[!is.na(matched_2$matched_Address),]

matched_2 <- matched_2 %>% group_by(matched_Address) %>% mutate(n=n()) %>% ungroup() #matching to unique
table(matched_2$n)

#start building the data set
dta2<-dta0 %>% filter(quartileZIP_property%in%c(4,2)) #keeps treated 4 and control 2
dta2<-left_join(dta2,matched_2) #matches to addreses matched
dta2<- dta2 %>% mutate(matched_Address=ifelse(is.na(matched_Address),Address,matched_Address)) #asigns to matched adrress the control address
dta2<- dta2 %>% group_by(matched_Address) %>% mutate(match=n()) #makes sure there are 6 observations per match
dta2<-dta2 %>% filter(match==6) #keeps only 6
dta2$match<-NULL

#dta2 <- dta2 %>% group_by(matched_Address) %>% mutate(n=n()) %>% ungroup() #matching to unique
#table(dta2$n)

#creates the Address treated so we can cluster on that
temp<-dta2[dta2$quartileZIP_property==4,c("Address","matched_Address")]
temp<- temp %>% distinct(.keep_all = TRUE)
colnames(temp)[1]<-"Address_treated"

dta2<-left_join(dta2,temp)

dta2<-dta2[order(dta2$matched_Address,-dta2$quartileZIP_property),]
rm(temp)
#View(dta2[,c("quartileZIP_property","Address","matched_Address","Address_treated")])
# # -----------------------------------------------------------------------

dta2<-dta2 %>% filter(quartileZIP_property!=4) #drop treated (otherwise when I bind the dbs are going to be duplicated)

dta_matched<-rbind(dta1,dta2)
dta_matched<- dta_matched %>% group_by(Address_treated) %>% mutate(match=n()) #makes sure there are 9 observations per match
table(dta_matched$match)


dta_matched<-dta_matched[order(dta_matched$Address_treated,-dta_matched$quartileZIP_property),]
#View(dta_matched[,c("quartileZIP_property","Address","matched_Address","match","Address_treated")])

dta_matched<-dta_matched %>% filter(match==9) #keeps only 9
table(dta_matched$Minority_dec2)
table(dta_matched$Minority_dec3)
table(dta_matched$Minority_dec4)

haven::write_dta(dta_matched,"stores/toxic_discrimination_matched_data.dta")
