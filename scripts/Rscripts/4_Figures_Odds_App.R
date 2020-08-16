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
#Figure Appendix A1
#############################################################################################################################################################
plot_tox_conc("../stores/aux/interquartile_toxconc_minority_full_set_bootcl","../views/figA1_a",gRp = "Minority",label=FALSE,ht=4,wd=6,grangeymin=0.35,grangeymax=1.61, lresty=1.75, yccartmin=0.4,yccartmax=1.75, bks=c(0.4,0.6,.8,1,1.2,1.4,1.6),uts="in")

#Race
plot_tox_conc("../stores/aux/interquartile_toxconc_AA_full_set_bootcl","../views/figA1_ba",gRp = "African American",label=FALSE,ht=3.5,wd=5.3,grangeymin=0.15,grangeymax=2.05, lresty=2.3, yccartmin=0.2,yccartmax=2.4, bks=c(0.2,0.4,0.6,.8,1,1.2,1.4,1.6,1.8,2.0))
plot_tox_conc("../stores/aux/interquartile_toxconc_Hisp_full_set_bootcl","../views/figA1_bb",gRp = "Hispanics",label=FALSE,ht=3.5,wd=5.3,grangeymin=0.15,grangeymax=2.05, lresty=2.3, yccartmin=0.2,yccartmax=2.4, bks=c(0.2,0.4,0.6,.8,1,1.2,1.4,1.6,1.8,2.0))


#############################################################################################################################################################
#Figure Appendix A2
#############################################################################################################################################################
plot_distance("../stores/aux/distance_minority_full_set_bootcl","../views/figA2_a",ht=4,wd=6,grangeymin=0.37,grangeymax=1.41,lbetay=1.6, lresty=1.53, ccartmin=0.4,ccartmax=1.6, bks=c(0.4,0.6,.8,1,1.2,1.4))
plot_distance("../stores/aux/distance_race_afam_full_set_bootcl","../views/figA2_ba",ht=4,wd=6,grangeymin=0.37,grangeymax=1.41,lbetay=1.6, lresty=1.53,  ccartmin=0.4,ccartmax=1.6, bks=c(0.4,0.6,.8,1,1.2,1.4))
plot_distance("../stores/aux/distance_race_hispanic_full_set_bootcl","../views/figA2_bb",ht=4,wd=6,grangeymin=0.37,grangeymax=1.41,lbetay=1.6, lresty=1.53,  ccartmin=0.4,ccartmax=1.6, bks=c(0.4,0.6,.8,1,1.2,1.4))

dev.off()

