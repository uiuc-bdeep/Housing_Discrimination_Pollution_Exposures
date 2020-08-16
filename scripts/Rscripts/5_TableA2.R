##########################################################
# author: Ignacio Sarmiento-Barbieri
# based on Peter Christensen's code
##########################################################

#Clean the workspace
rm(list=ls())
cat("\014")
local({r <- getOption("repos"); r["CRAN"] <- "http://cran.r-project.org"; options(repos=r)}) #set repo


#Load Packages
pkg<-c("survival","dplyr","doMC","rgeos","spdep","sp","fastDummies","tidyr","stargazer")
lapply(pkg, require, character.only=T)
rm(pkg)

#
#Set WD local
setwd("~/Dropbox/Research/Toxic_Discrimination/github/Toxic_Discrimination/")

#Descriptive
dta_desc<-read.csv("views/descriptive_RSEI.csv")
dta_desc<-dta_desc[,2:4]
dta_desc[c(1,2,7,8),]<-dta_desc[c(1,2,7,8),]/1000

colnames(dta_desc)<-c("Q1","Q2-Q3","Q4")
#dta_desc<-round(dta_desc,2)
dta_desc<-format(round(dta_desc, digits=3), nsmall = 3) 

for(j in 1:3) dta_desc[,j]<-trimws(dta_desc[,j])

dta_desc[2,] <-paste0("(",dta_desc[2,] ,")")
dta_desc[4,] <-paste0("(",dta_desc[4,] ,")")
dta_desc[6,] <-paste0("(",dta_desc[6,] ,")")
dta_desc[8,] <-paste0("(",dta_desc[8,] ,")")
dta_desc[10,]<-paste0("(",dta_desc[10,],")")
dta_desc[12,]<-paste0("(",dta_desc[12,],")")
dta_desc[14,]<-paste0("(",dta_desc[14,],")")
dta_desc[16,]<-paste0("(",dta_desc[16,],")")
dta_desc[18,]<-paste0("(",dta_desc[18,],")")
dta_desc[20,]<-paste0("(",dta_desc[20,],")")
dta_desc[22,]<-paste0("(",dta_desc[22,],")")
dta_desc[24,]<-paste0("(",dta_desc[24,],")")
dta_desc[26,]<-paste0("(",dta_desc[26,],")")
dta_desc[28,]<-paste0("(",dta_desc[28,],")")
dta_desc[30,]<-paste0("(",dta_desc[30,],")")
dta_desc[32,]<-paste0("(",dta_desc[32,],")")
dta_desc[34,]<-paste0("(",dta_desc[34,],")")
dta_desc[36,]<-paste0("(",dta_desc[36,],")")
dta_desc[38,]<-paste0("(",dta_desc[38,],")")

dta_desc$names<-NA
dta_desc$names[1]<-"Toxic Concentration (K)"
dta_desc$names[2]<-""
dta_desc$names[3]<-"Cancer Score"
dta_desc$names[4]<-""
dta_desc$names[5]<-"Non Cancer Score"
dta_desc$names[6]<-""
dta_desc$names[7]<-"Rent (K)"
dta_desc$names[8]<-""
dta_desc$names[9]<-"Single Family Home"
dta_desc$names[10]<-""
dta_desc$names[11]<-"Apartment"
dta_desc$names[12]<-""
dta_desc$names[13]<-"Multi Family"
dta_desc$names[14]<-""
dta_desc$names[15]<-"Other Bldg. Type"
dta_desc$names[16]<-""
dta_desc$names[17]<-"Bedrooms"
dta_desc$names[18]<-""
dta_desc$names[19]<-"Bathrooms"
dta_desc$names[20]<-""
dta_desc$names[21]<-"Sqft."
dta_desc$names[22]<-""
dta_desc$names[23]<-"Assault"
dta_desc$names[24]<-""
dta_desc$names[25]<-"Groceries"
dta_desc$names[26]<-""
dta_desc$names[27]<-"Share of Hispanics"
dta_desc$names[28]<-""
dta_desc$names[29]<-"Share of African American"
dta_desc$names[30]<-""
dta_desc$names[31]<-"Share of Whites"
dta_desc$names[32]<-""
dta_desc$names[33]<-"Poverty Rate"
dta_desc$names[34]<-""
dta_desc$names[35]<-"Unemployment Rate"
dta_desc$names[36]<-""
dta_desc$names[37]<-"Share of College Educated"
dta_desc$names[38]<-""

dta_desc<- dta_desc[,c("names","Q1","Q2-Q3","Q4")]


# # -----------------------------------------------------------------------
#Ttest
# # -----------------------------------------------------------------------

dta<-read.csv("views/descriptive_RSEI_ttest.csv")

colnames(dta)<-c("0th-25th","25th-75th","75th-100th")
dta<-round(dta, 4)


dta<-format(round(dta, digits=3), nsmall = 3) 

for(j in 1:3) dta[,j]<-trimws(dta[,j])
dta


for(j in seq(1,37,by=2)){
  for(k in 1:3){
    
    value<-dta[j,k] #format(round(, 2), nsmall = 2, big.mark=",")
    tscore<-abs(as.numeric(dta[j,k])/as.numeric(dta[j+1,k]))
    
    dta[j,k] <-ifelse(tscore>=2.576, paste0(value,"***"),
                      ifelse(tscore>=1.96 & tscore<2.576, paste0(value ,"**"),
                             ifelse(tscore>=1.645 & tscore<1.96, paste0(value,"*"),paste0(value ))))
    dta[j+1,k] <-paste0("(",dta[j+1,k],")") #for standard errors
  }
  
}

dta<-dta[,c(2,3)]


# Bind rows ----------------------------------------------------------------
dta_bind<-bind_cols(dta_desc,dta)
stargazer(dta_bind,summary=FALSE,type="text", rownames = FALSE,out="views/descriptive_RSEI.tex")
