##########################################################################################################
#Replication Files for Housing Discrimination and the Toxics Exposure Gap in the United States: 
#Evidence from the Rental Market  by Peter Christensen, Ignacio Sarmiento-Barbieri and Christopher Timmins
##########################################################################################################


plot_tox_conc<-function(name_dta,location_output,gRp="Minority",label=TRUE,ht=3,wd=10,eps=-0.01,grangeymin=0.15,grangeymax=2.1,lbetay=2.47, lresty=2.3, yccartmin=0.2,yccartmax=2.4,xccartmin=0.95,xccartmax=3.2, bks=c(0.2,0.4,0.6,.8,1,1.2,1.4,1.6,1.8,2.0),uts="in"){

dta<-haven::read_dta(paste0(name_dta,".dta"))


  
  colnames(dta)<-c("lci","or","uci","obs","c_mean","deciles")
  dta$group = gRp
  
colors <- tibble::deframe(ggthemes::ggthemes_data[["fivethirtyeight"]])
base_size = 4
base_family = "sans"
plot_label_mean <- sprintf("\n Mean Response (White) = %#.2f", dta$c_mean)
plot_label_N<- paste0("\n N = ",format(dta$obs,big.mark=","))

p<-ggplot(data=dta, aes(x=deciles, y=or, group=group))+
  geom_line( size=.5)+
  geom_ribbon(aes(ymin=lci, ymax=uci, lty=group),alpha=0.2)+
  geom_line(data=dta,aes(x=deciles, y=lci),alpha=0.5, linetype="dashed")+
  geom_line(data=dta,aes(x=deciles, y=uci),alpha=0.5, linetype="dashed")+
  geom_hline(aes(yintercept=1), colour="royalblue4", linetype="twodash") +
  scale_y_continuous("Odds Ratio",breaks=bks) + #, limits = c(0.2,2.1))+
  coord_cartesian(ylim = c(yccartmin,yccartmax), clip = 'off') +
  theme_bw() +
  theme_fivethirtyeight() + scale_color_fivethirtyeight("cyl") +
   annotate("text", x = 1:3, y = lresty, 
            label = as.character(paste0(plot_label_mean,
                                        plot_label_N)),  
                                        size= base_size-1, family=base_family, color=colors["Dark Gray"], angle=0) +
  scale_x_continuous(name="Percentile of Within-Zip Toxic Concentration", breaks=c(1,2,3), labels=c("0-25","25-75","75-100")) +
  geom_linerange(ymin = grangeymin, ymax = grangeymax, color = colors["Medium Gray"]) +
  theme(axis.title = element_text()) + 
  xlab("Percentile of Within-Zip Toxic Concentration") + ylab('Odds Ratio') +
  theme(legend.title= element_blank() ,
        legend.position="none",
        legend.justification=c(1,1),
        legend.direction="vertical",
        legend.box="horizontal",
        legend.box.just = c("top"),
        panel.grid.major.x = element_blank(),
        legend.background = element_rect(fill='transparent'),
        axis.text.x =element_text( angle=45),
        rect = element_rect(colour = "transparent", fill = "white"),
        plot.margin = unit(c(2,3.5,1,1), "lines")) 
  p


  if(label==TRUE){
    p<- p + facet_grid(~group) + theme(strip.placement = "outside")
  }else{
    p
  }
  ggsave(filename=paste0(location_output,".png"), height = ht, width = wd,units=uts)
  p
}






plot_distance<-function(name_dta,location_output,gRp="Minority",ht=3,wd=10,grangeymin=0.75,grangeymax=1.7,lbetay=1.6, lresty=1.53, ccartmin=0.4,ccartmax=1.6, bks=c(0.4,0.6,.8,1,1.2,1.4,1.6)){
  
  dta<-haven::read_dta(paste0(name_dta,".dta"))
  
  dta$group = gRp
  
  colors <- tibble::deframe(ggthemes::ggthemes_data[["fivethirtyeight"]])
  base_size = 4
  base_family = "sans"
  #plot_label_coef <- sprintf("Likelihood of Response = %#.2f", dta$or)
  plot_label_mean <- sprintf("\n Mean Response (White) = %#.2f", dta$c_mean)
  plot_label_N<- paste0("\n N = ",format(dta$obs,big.mark=","))
  
  
  p<-ggplot(data=dta, aes(x=distance, y=or, group=group))+
    geom_linerange(ymin = grangeymin, ymax = grangeymax, color = colors["Medium Gray"]) +
    geom_point(size=2, position=position_dodge(width = .2))+
    geom_errorbar(aes(ymin=lci, ymax=uci, lty=group), width=.025, position=position_dodge(width = .2)) +
    geom_hline(aes(yintercept=1), colour="royalblue4", linetype="twodash") +
    scale_y_continuous("Odds Ratio",breaks=bks)+
    theme_bw() +
    coord_cartesian(ylim = c(ccartmin,ccartmax), clip = 'off') +
    theme_fivethirtyeight() + scale_color_fivethirtyeight("cyl") +
    annotate("text", x = 1:2, y = lresty, 
             label = as.character(paste0(plot_label_mean,
                                         plot_label_N)),  
             size= base_size-1, family=base_family, color=colors["Dark Gray"], angle=0) +
     #xlab('') +
    scale_x_continuous(name="Distance to TRI plant", breaks=c(1,2), labels=c("< 1 mile","> 1 mile"), trans="reverse") +
    theme(legend.title= element_blank() ,
          legend.position="none",
          legend.justification=c(1,1),
          legend.direction="vertical",
          legend.box="horizontal",
          legend.box.just = c("top"),
          axis.title = element_text(),
          panel.grid.major.x = element_blank(),
          legend.background = element_rect(fill='transparent'),
          axis.text.x =element_text( angle=45),
          rect = element_rect(colour = "transparent", fill = "white")
    )
  p
  
  ggsave(filename=paste0(location_output,".png"), height = ht, width = wd)
  
  p
}





