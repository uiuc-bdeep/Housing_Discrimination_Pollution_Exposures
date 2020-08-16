##########################################################################################################
#Replication Files for Housing Discrimination and the Toxics Exposure Gap in the United States: 
#Evidence from the Rental Market  by Peter Christensen, Ignacio Sarmiento-Barbieri and Christopher Timmins
##########################################################################################################

#Clean the workspace
rm(list=ls())
cat("\014")
local({r <- getOption("repos"); r["CRAN"] <- "http://cran.r-project.org"; options(repos=r)}) #set repo


#Load Packages
pkg<-c("dplyr","ggthemes","ggplot2")
lapply(pkg, require, character.only=T)
rm(pkg)



source("Rscripts/aux/plot_fct_tox_conc_n_distance.R")

#############################################################################################################################################################
#Figure 3
#############################################################################################################################################################
plot_tox_conc("../stores/aux/interquartile_toxconc_minority_bootcl","../views/fig3_a",gRp = "Minority",label=FALSE,ht=4,wd=6,grangeymin=0.35,grangeymax=1.61, lresty=1.75, yccartmin=0.4,yccartmax=1.75, bks=c(0.4,0.6,.8,1,1.2,1.4,1.6),uts="in")

#Race
plot_tox_conc("../stores/aux/interquartile_toxconc_AA_bootcl","../views/fig3_ba",gRp = "Minority",label=FALSE,ht=3.5,wd=5.3,grangeymin=0.15,grangeymax=2.05, lresty=2.3, yccartmin=0.2,yccartmax=2.4, bks=c(0.2,0.4,0.6,.8,1,1.2,1.4,1.6,1.8,2.0))
plot_tox_conc("../stores/aux/interquartile_toxconc_Hisp_bootcl","../views/fig3_bb",gRp = "Hispanics",label=FALSE,ht=3.5,wd=5.3,grangeymin=0.15,grangeymax=2.05, lresty=2.3, yccartmin=0.2,yccartmax=2.4, bks=c(0.2,0.4,0.6,.8,1,1.2,1.4,1.6,1.8,2.0))



#Gender
plot_tox_conc("../stores/aux/interquartile_toxconc_minority_male_bootcl","../views/fig3_ca",gRp = "Minority",label=FALSE,ht=3.5,wd=5.3,grangeymin=0.15,grangeymax=2.05, lresty=2.3, yccartmin=0.2,yccartmax=2.4, bks=c(0.2,0.4,0.6,.8,1,1.2,1.4,1.6,1.8,2.0))
plot_tox_conc("../stores/aux/interquartile_toxconc_minority_female_bootcl","../views/fig3_cb",gRp = "Minority",label=FALSE,ht=3.5,wd=5.3,grangeymin=0.15,grangeymax=2.05, lresty=2.3, yccartmin=0.2,yccartmax=2.4, bks=c(0.2,0.4,0.6,.8,1,1.2,1.4,1.6,1.8,2.0))


#############################################################################################################################################################
#Figure 4
#############################################################################################################################################################

plot_distance("../stores/aux/distance_minority_bootcl","../views/fig4_a",ht=4,wd=6,grangeymin=0.37,grangeymax=1.41,lbetay=1.6, lresty=1.53, ccartmin=0.4,ccartmax=1.6, bks=c(0.4,0.6,.8,1,1.2,1.4))
plot_distance("../stores/aux/distance_race_afam_bootcl","../views/fig4_ba",ht=4,wd=6,grangeymin=0.37,grangeymax=1.41,lbetay=1.6, lresty=1.53,  ccartmin=0.4,ccartmax=1.6, bks=c(0.4,0.6,.8,1,1.2,1.4))
plot_distance("../stores/aux/distance_race_hispanic_bootcl","../views/fig4_bb",ht=4,wd=6,grangeymin=0.37,grangeymax=1.41,lbetay=1.6, lresty=1.53,  ccartmin=0.4,ccartmax=1.6, bks=c(0.4,0.6,.8,1,1.2,1.4))



#############################################################################################################################################################
# Figure 5
#############################################################################################################################################################

hTg<-3.5
wDt<-5.3



#White share
plot_tox_conc("../stores/aux/interquartile_toxconc_minority_w_share_low_bootcl","../views/fig5_aa",gRp = "Minority",label=FALSE,ht=hTg,wd=wDt,grangeymin=0.15,grangeymax=2.05, lresty=2.3, yccartmin=0.2,yccartmax=2.4, bks=c(0.2,0.4,0.6,.8,1,1.2,1.4,1.6,1.8,2.0))
plot_tox_conc("../stores/aux/interquartile_toxconc_minority_w_share_high_bootcl","../views/fig5_ab",gRp = "Minority",label=FALSE,ht=hTg,wd=wDt,grangeymin=0.15,grangeymax=2.05, lresty=2.3, yccartmin=0.2,yccartmax=2.4, bks=c(0.2,0.4,0.6,.8,1,1.2,1.4,1.6,1.8,2.0))


#Rent
plot_tox_conc("../stores/aux/interquartile_toxconc_minority_rent_high_bootcl","../views/fig5_ba",gRp = "Minority",label=FALSE,ht=hTg,wd=wDt,grangeymin=0.15,grangeymax=2.05, lresty=2.3, yccartmin=0.2,yccartmax=2.4, bks=c(0.2,0.4,0.6,.8,1,1.2,1.4,1.6,1.8,2.0))
plot_tox_conc("../stores/aux/interquartile_toxconc_minority_rent_low_bootcl","../views/fig5_bb",gRp = "Minority",label=FALSE,ht=hTg,wd=wDt,grangeymin=0.15,grangeymax=2.05, lresty=2.3, yccartmin=0.2,yccartmax=2.4, bks=c(0.2,0.4,0.6,.8,1,1.2,1.4,1.6,1.8,2.0))

#Matched
plot_tox_conc("../stores/aux/interquartile_toxconc_minority_bootcl","../views/fig5_ca",gRp = "Minority",label=FALSE,ht=hTg,wd=wDt,grangeymin=0.15,grangeymax=2.05, lresty=2.3, yccartmin=0.2,yccartmax=2.4, bks=c(0.2,0.4,0.6,.8,1,1.2,1.4,1.6,1.8,2.0))
plot_tox_conc("../stores/aux/interquartile_toxconc_minority_matched_bootcl","../views/fig5_cb",gRp = "Minority",label=FALSE,ht=hTg,wd=wDt,grangeymin=0.15,grangeymax=2.05, lresty=2.3, yccartmin=0.2,yccartmax=2.4, bks=c(0.2,0.4,0.6,.8,1,1.2,1.4,1.6,1.8,2.0))



