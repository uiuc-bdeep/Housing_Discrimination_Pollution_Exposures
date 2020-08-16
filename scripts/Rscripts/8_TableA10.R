##########################################################################################################
#Replication Files for Housing Discrimination and the Toxics Exposure Gap in the United States: 
#Evidence from the Rental Market  by Peter Christensen, Ignacio Sarmiento-Barbieri and Christopher Timmins
##########################################################################################################

#Clean the workspace
rm(list=ls())
cat("\014")
local({r <- getOption("repos"); r["CRAN"] <- "http://cran.r-project.org"; options(repos=r)}) #set repo


#Load Packages
pkg<-c("dplyr","haven","xtable")
lapply(pkg, require, character.only=T)
rm(pkg)

minority_dta<-read_dta("../stores/aux/interquartile_toxconc_minority_bootcl.dta")
colnames(minority_dta)<-c("lci","or","uci","obs","c_mean","deciles")
minority_dta$race = "minority"

black_dta<-read_dta("../stores/aux/interquartile_toxconc_AA_bootcl.dta")
colnames(black_dta)<-c("lci","or","uci","obs","c_mean","deciles")
black_dta$race = "black"

hispanic_dta<-read_dta("../stores/aux/interquartile_toxconc_Hisp_bootcl.dta")
colnames(hispanic_dta)<-c("lci","or","uci","obs","c_mean","deciles")
hispanic_dta$race = "hispanic"

dta<-bind_rows(minority_dta,black_dta,hispanic_dta)

rel_risk<-read_dta("../stores/aux/rel_risk_quartile.dta")
rel_risk<-zap_formats(rel_risk)
colnames(rel_risk)[1]<-"relative_risk"
colnames(rel_risk)[3]<-"deciles"
rel_risk$deciles<-rep(c(1,2,3),3)
dta<-left_join(dta,rel_risk)


#dta$relative_risk<-c(0.67864963 , 0.7870416, 1.1063163)

dta<- dta %>% mutate(mean_r_white=1/c_mean)
dta<- dta %>% mutate(inq_per_response=mean_r_white/relative_risk)

dta_mean_r_white<-dta %>% dplyr::select(race,mean_r_white)
dta_mean_r_white<-dta_mean_r_white[c(1:3),]
dta_mean_r_white$race<-"White"
colnames(dta_mean_r_white)[2]<-"inq_per_response"

dta_wide<-dta %>% dplyr::select(race,inq_per_response)
dta_wide<-bind_rows(dta_mean_r_white,dta_wide)
dta_wide$deciles<-rep(c(1,2,3),4)


dta_wide<-dta_wide %>% tidyr::pivot_wider(names_from=deciles,values_from=inq_per_response)
dta_wide<-dta_wide %>% mutate(dif=`1`-`3`)
dta_wide$race<-c("White","Minority","African American","Hispanic/LatinX ")


print(xtable(dta_wide), include.rownames = FALSE, include.colnames = FALSE, sanitize.text.function = I, file="../views/tableA10_a.tex")




# # -----------------------------------------------------------------------
# # -----------------------------------------------------------------------
# Distance ----------------------------------------------------------------
# # -----------------------------------------------------------------------
# # -----------------------------------------------------------------------




minority_dta<-read_dta("../stores/aux/distance_minority_bootcl.dta")
colnames(minority_dta)<-c("lci","or","uci","obs","c_mean","deciles")
minority_dta$race = "minority"

black_dta<-read_dta("../stores/aux/distance_race_afam_bootcl.dta")
colnames(black_dta)<-c("lci","or","uci","obs","c_mean","deciles")
black_dta$race = "black"

hispanic_dta<-read_dta("../stores/aux/distance_race_hispanic_bootcl.dta")
colnames(hispanic_dta)<-c("lci","or","uci","obs","c_mean","deciles")
hispanic_dta$race = "hispanic"

dta<-bind_rows(minority_dta,black_dta,hispanic_dta)

rel_risk<-read_dta("../stores/aux/rel_risk_distance.dta")
rel_risk<-zap_formats(rel_risk)
colnames(rel_risk)[1]<-"relative_risk"
colnames(rel_risk)[3]<-"deciles"
rel_risk$deciles<-rep(c(1,2),3)
dta<-left_join(dta,rel_risk)


#dta$relative_risk<-c(0.67864963 , 0.7870416, 1.1063163)

dta<- dta %>% mutate(mean_r_white=1/c_mean)
dta<- dta %>% mutate(inq_per_response=mean_r_white/relative_risk)

dta_mean_r_white<-dta %>% dplyr::select(race,mean_r_white)
dta_mean_r_white<-dta_mean_r_white[c(1:2),]
dta_mean_r_white$race<-"White"
colnames(dta_mean_r_white)[2]<-"inq_per_response"

dta_wide<-dta %>% dplyr::select(race,inq_per_response)
dta_wide<-bind_rows(dta_mean_r_white,dta_wide)
dta_wide$deciles<-rep(c(1,2),4)


dta_wide<-dta_wide %>% tidyr::pivot_wider(names_from=deciles,values_from=inq_per_response)
dta_wide<-dta_wide %>% mutate(dif=`2`-`1`)
dta_wide$race<-c("White","Minority","African American","Hispanic/LatinX ")
colnames(dta_wide)<-c("race","less1","more1","dif")
dta_wide<- dta_wide[,c("race","more1","less1","dif")]

print(xtable(dta_wide), include.rownames = FALSE, include.colnames = FALSE, sanitize.text.function = I, file="../views/tableA10_b.tex")
