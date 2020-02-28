##########################################################
# Replication files for "Housing Discrimination and the Pollution Exposure Gap in the United States" 
##########################################################

#Clean the workspace
rm(list=ls())
cat("\014")
local({r <- getOption("repos"); r["CRAN"] <- "http://cran.r-project.org"; options(repos=r)}) #set repo


#Load Packages
pkg<-c("dplyr","dggplot2","ggthemes")
lapply(pkg, require, character.only=T)
rm(pkg)


# Load matched inquiries data ---------------------------------------------
matchedinquiries<-haven::read_dta("stores/toxic_discrimination_data.dta")


matchedinquiries$ToxQ<-NA
matchedinquiries$ToxQ[matchedinquiries$quartileZIP_property==2]<-"0-25"
matchedinquiries$ToxQ[matchedinquiries$quartileZIP_property==3]<-"25-75"
matchedinquiries$ToxQ[matchedinquiries$quartileZIP_property==4]<-"75-100"

matchedinquiries<-matchedinquiries %>% distinct(Address,sample_round,Zip_Code,.keep_all = TRUE)
dta<-matchedinquiries[,c("dist","ToxQ","Zip_Code","toxconc")]

dta$ToxQ<-factor(dta$ToxQ, levels=c("75-100","25-75","0-25"))
name_output<-"distance_concentration"
ht<-4
wd<-6
#table(dta$Zip_Code)

colors <- tibble::deframe(ggthemes::ggthemes_data[["fivethirtyeight"]])
base_size = 4
base_family = "sans"
require(grid)

p<-ggplot(dta,aes(x=dist)) +
  geom_histogram( colour="black", fill=colors["Medium Gray"], binwidth = .3) + #
  theme_bw() +
  theme_fivethirtyeight() + scale_color_fivethirtyeight("cyl") +
  facet_grid(ToxQ~.) +
  geom_vline(aes(xintercept=1), colour="royalblue4", linetype="twodash") +
  scale_x_continuous("Distance to TRI plant",breaks=c(0,1,2,3,4,5,6),limits=c(-0.25,6)) +
  #coord_cartesian(xlim = c(-0.25,6), clip = 'on') +
  xlab("Distance to TRI facility (miles)") +
  ylab("Number of Listings") +
  # annotate("text",x= 8, y = 200, 
  #          label = ,  
  #          size= base_size-1, family=base_family, color=colors["Dark Gray"], angle=360) +
  theme(legend.title= element_blank() ,
        legend.position="none",
        legend.justification=c(1,1),
        legend.direction="vertical",
        legend.box="horizontal",
        legend.box.just = c("top"),
        legend.background = element_rect(fill='transparent'),
        axis.text.x =element_text( angle=0),
        rect = element_rect(colour = "transparent", fill = "white"),
        axis.title = element_text(), plot.margin = unit(c(2,2,1,1), "lines"))


p
grid.text(unit(0.98,"npc"),gp=gpar(fontsize=11,fontfamily=base_family),0.5,label = "Percentile of Within-Zip Toxic Concentration", rot = 270) # right
#has to be saved manually with export, width=1000, height=410