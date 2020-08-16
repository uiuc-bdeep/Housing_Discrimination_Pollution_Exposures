##########################################################################################################
#Replication Files for Housing Discrimination and the Toxics Exposure Gap in the United States: 
#Evidence from the Rental Market  by Peter Christensen, Ignacio Sarmiento-Barbieri and Christopher Timmins
##########################################################################################################

#Clean the workspace
rm(list=ls())
cat("\014")
local({r <- getOption("repos"); r["CRAN"] <- "http://cran.r-project.org"; options(repos=r)}) #set repo


#Load Packages
pkg<-list("dplyr","ggplot2","haven","ggpubr")
lapply(pkg, require, character.only=T)
rm(pkg)


# # -----------------------------------------------------------------------
# Panel A -----------------------------------------------------------------
# # -----------------------------------------------------------------------

dta0<-haven::read_dta("../stores/aux/ACS_coefficients.dta")

dta<-dta0
dta$n<-as.character(dta$n)

dta<- dta %>% mutate(lci=coef-1.645*std_err,
                     uci=coef+1.645*std_err)
  
dta$ToxConc_bin<-factor(dta$ToxConc_bin,levels=c("0-25","25-75","75-100"),ordered=TRUE)

dta$group = "Minority"

dta$race<-factor(dta$race,levels=c("White","Black","Hispanic"),labels=c("White","African American", "Hispanic/LatinX"),ordered=TRUE)


dta$n[dta$n==2 & dta$race=="White"]<-9
dta$n[dta$n==5 & dta$race=="African American"]<-10
dta$n[dta$n==8 & dta$race=="Hispanic/LatinX"]<-11

dta$n[dta$n==3 & dta$race=="White"]<-17
dta$n[dta$n==6 & dta$race=="African American"]<-18
dta$n[dta$n==9 & dta$race=="Hispanic/LatinX"]<-19


dta$n[dta$n==1 & dta$race=="White"]<-2
dta$n[dta$n==4 & dta$race=="African American"]<-3
dta$n[dta$n==7 & dta$race=="Hispanic/LatinX"]<-4

dta$n<-as.character(dta$n)

dta2<-data.frame(n=c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"))

dta<-left_join(dta2,dta)



dta$n<-factor(dta$n,levels=c("1","2","3","4","5","6","7","8","9","10",
                                                                             "11","12","13","14","15","16","17","18","19","20"),
                                      labels=c("5","10","15","20",
                                               "25","30","35","40",
                                               "45","50","55","60",
                                               "65","70","75","80",
                                               "85","90","95","100"
                                      ),ordered=TRUE)

colors <- tibble::deframe(ggthemes::ggthemes_data[["fivethirtyeight"]])
base_size = 4
base_family = "times"


scale_colour_grey(3, start = 0.2, end = 0.8, na.value = "red",
                 aesthetics = "colour")

#data_seg_horiz<-data.frame(yinit=c(rep(0,20))

panelA<-ggplot(data=dta, aes(x=n, y=coef, group=race, color=race)) +
  geom_errorbar(aes(ymin=lci, ymax=uci), width=.025, position=position_dodge(width = .2)) +
  geom_point(aes(shape=race),size=2, position=position_dodge(width = .2))+
  scale_x_discrete(breaks=c("15","55","90"),labels=c("0-25","25-75","75-100")) +
  scale_shape_manual(values=c(15,16, 17),na.translate = F) +
  scale_colour_manual(values=c("#C0C0C0", "#000000","#808080"),na.translate = F) +
  theme_bw() +
  #ggtitle("Panel A: Renter Population Share Relative to Lowest Quartile of Exposure") +
  ylab("Coefficient") +
  xlab("") +
  geom_vline(xintercept = 5+.5, col="grey40")+ 
  geom_vline(xintercept = 15+.5, col="grey40")+
  #theme_fivethirtyeight() + #+ scale_color_fivethirtyeight("cyl") +
  theme(#panel.grid.major = element_blank(),
    panel.background = element_rect(fill="white"),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    strip.background = element_blank(),
    #panel.border = element_rect(colour = "black"),
    panel.border = element_blank(),
    plot.title = element_text(hjust = 0.5),
    text = element_text(size=12),
    strip.placement = "outside",
    strip.text.x = element_text(size=14),
    legend.position = "top",
    legend.title = element_blank(),
    panel.spacing = unit(2, "lines")
  )

 
panelA




# # -----------------------------------------------------------------------
# Panel B -----------------------------------------------------------------
# # -----------------------------------------------------------------------

dtaB<-haven::read_dta("~/Dropbox/Research/Toxic_Discrimination/stores/ACS_population_modified.dta")
dtaB$quartileZIP_property_10[dtaB$quartileZIP_property_10==13 & dtaB$quartileZIP_property==4]<-18
dtaB$quartileZIP_property_10[dtaB$quartileZIP_property_10==14 & dtaB$quartileZIP_property==4]<-20

dtaB_s0<- dtaB %>% dplyr::group_by(ZIP,quartileZIP_property_10,race) %>% dplyr::summarize(within_zip_quartile_population=sum(population_renters)) %>% ungroup()
dtaB_s02<- dtaB %>% dplyr::group_by(ZIP,race) %>% dplyr::summarize(within_zip_population=sum(population_renters)) %>% ungroup()
dtaB_s0<-left_join(dtaB_s0,dtaB_s02)
dtaB_s0<- dtaB_s0 %>% mutate(within_zip_share_race=within_zip_quartile_population/within_zip_population)

dtaB_s0<- dtaB_s0[order(dtaB_s0$ZIP,dtaB_s0$quartileZIP_property_10,dtaB_s0$race),]

dtaB_s0<- dtaB_s0 %>% dplyr::group_by(ZIP,race) %>% mutate(total=sum(within_zip_share_race)) %>% ungroup()
table(dtaB_s0$total)


dtaB_s<- dtaB_s0 %>% group_by(quartileZIP_property_10,race) %>% summarise(renters=mean(within_zip_share_race,na.rm=T))
rm(dtaB_s02)

dtaB_s$quartileZIP_property_10<-as.character(dtaB_s$quartileZIP_property_10)


dtaB_s$quartileZIP_property_10<-factor(dtaB_s$quartileZIP_property_10,levels=c("1","2","3","4","5","6","7","8","9","10",
                                                                             "11","12","13","14","15","16","17","18","19","20"),
                                      labels=c("5","10","15","20",
                                               "25","30","35","40",
                                               "45","50","55","60",
                                               "65","70","75","80",
                                               "85","90","95","100"
                                      ),ordered=TRUE)
dtaB_s$race<-factor(dtaB_s$race,levels=c("White","Black","Hispanic"),labels=c("White","African American", "Hispanic/LatinX"),ordered=TRUE)




panelBa<-ggplot(dtaB_s %>% filter(race=="White"),aes(quartileZIP_property_10,renters))+
  geom_bar(stat="identity", colour="black", fill="#C0C0C0",width = 1) +
  ylab("Within-Zip Renter White Population Share") +
  #xlab("Percentile of Toxic Concentration (RSEI)") +
  xlab("") +
  theme_bw() +
  geom_vline(xintercept = 5+.5, col="grey40")+ 
  geom_vline(xintercept = 15+.5, col="grey40")+
  theme(
    panel.background = element_rect(fill="white"),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    strip.background = element_blank(),
    
    panel.border = element_blank(),
    plot.title = element_text(hjust = 0.5),
    text = element_text(size=12),
    strip.placement = "outside",
    strip.text.x = element_blank(),
    legend.position = "none",
    panel.spacing = unit(2, "lines")
  )
panelBa

panelBb<-ggplot(dtaB_s %>% filter(race=="African American"),aes(quartileZIP_property_10,renters))+
  geom_bar(stat="identity", colour="black", fill="#000000",width = 1) +
  ylab("Within-Zip Renter African American Population Share") +
  xlab("") +
  theme_bw() +
  geom_vline(xintercept = 5+.5, col="grey40")+ 
  geom_vline(xintercept = 15+.5, col="grey40")+
  theme(panel.background = element_rect(fill="white"),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    strip.background = element_blank(),
    panel.border = element_blank(),
    plot.title = element_text(hjust = 0.5),
    text = element_text(size=12),
    strip.placement = "outside",
    strip.text.x = element_blank(),
    legend.position = "none",
    panel.spacing = unit(2, "lines")
  )
panelBb



panelBc<-ggplot(dtaB_s %>% filter(race=="Hispanic/LatinX"),aes(quartileZIP_property_10,renters))+
  geom_bar(stat="identity", colour="black", fill="#808080",width = 1) +
  ylab("Within-Zip Renter Hispanic/LatinX Population Share") +
  xlab("Percentile of Toxic Concentration (RSEI)") +
  theme_bw() +
  geom_vline(xintercept = 5+.5, col="grey40")+ 
  geom_vline(xintercept = 15+.5, col="grey40")+
  theme(panel.background = element_rect(fill="white"),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    strip.background = element_blank(),
    panel.border = element_blank(),
    plot.title = element_text(hjust = 0.5),
    text = element_text(size=12),
    strip.placement = "outside",
    strip.text.x = element_blank(),
    legend.position = "none",
    panel.spacing = unit(2, "lines")
  )
panelBc
# # -----------------------------------------------------------------------
# Merge Panels -----------------------------------------------------------------
# # -----------------------------------------------------------------------


ggarrange(
  panelA,
  panelBa,
  panelBb,
  panelBc,
  nrow = 4,
  heights=c(4,3,3,3)
  
)
ggsave(filename="../views/fig2.png",height=18,width = 8)
