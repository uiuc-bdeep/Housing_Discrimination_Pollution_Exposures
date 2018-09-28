##########################################################
# author: Ignacio Sarmiento-Barbieri
# based on Peter Christensen's code
##########################################################

#Clean the workspace
rm(list=ls())
cat("\014")
local({r <- getOption("repos"); r["CRAN"] <- "http://cran.r-project.org"; options(repos=r)}) #set repo


#Load Packages
pkg<-c("survival","dplyr","doMC","rgeos","spdep","sp","stargazer", "pwr","ggplot2")
lapply(pkg, require, character.only=T)
rm(pkg)

#Set WD local
setwd("~/Dropbox/Research/Toxic_Discrimination/")

#Load Data Shared Drive
matchedinquiries <- readRDS("stores/matchedinquiries_HOU.rds")

 



############################################################
# proximity to TRI
############################################################

#Generate a variable that takes 1 if it is within the 1 mile buffer
#matchedinquiries<-matchedinquiries %>% mutate(toxic=ifelse(is.na(within_mile)==FALSE,1,0))
#with(matchedinquiries,tapply(RSEI,toxic,mean)) #higher RSEI within 1 mile

#Generate a variable that takes 1 if it is TRInon0count >0
matchedinquiries<- matchedinquiries %>% mutate(near_plant=ifelse(TRInon0count>0,1,0))
prop.table(table(matchedinquiries$near_plant,useNA = 'always'))
rsei_db<-with(matchedinquiries,tapply(RSEI,near_plant,mean)) #higher RSEI within 1 mile
rsei_db<-rbind(rsei_db,with(matchedinquiries,tapply(RSEI,near_plant,sd)))
coef(summary(lm(RSEI~near_plant,matchedinquiries)))[2,1]

rsei_db<-data.frame(rsei_db)
colnames(rsei_db)<-c("Outside 1 mile", "Within 1 mile")
rsei_db$diff<-NA
rsei_db$diff[1]<-coef(summary(lm(RSEI~near_plant,matchedinquiries)))[2,1]
rsei_db$diff[2]<-coef(summary(lm(RSEI~near_plant,matchedinquiries)))[2,2]

summary(lm(RSEI~near_plant,matchedinquiries))
rownames(rsei_db)<-c("mean","sd")
stargazer(rsei_db,summary=FALSE,type="text")

matchedinquiries<- matchedinquiries %>% mutate(non_white=ifelse(race=="white",0,1),
                                               non_whiteRSEI=non_white*RSEI)
table(matchedinquiries$race,matchedinquiries$non_white)


############################################################
# Use non whites
############################################################
CS10 <- clogit( choice ~  non_white + gender + education_level + as.factor(as.numeric(inquiry_order)) + strata(Address), data = matchedinquiries)
summary(CS10)

CS10 <- clogit( choice ~  non_whiteRSEI + gender + education_level + as.factor(as.numeric(inquiry_order)) + strata(Address), data = matchedinquiries)
summary(CS10)
summary(matchedinquiries$RSEI)

############################################################
# Simulations
############################################################

matchedinquiries$index<- matchedinquiries %>% group_indices(Address)


set.seed(10101)
sim<-matrix(NA,nrow=400,ncol=5)
sim<-data.frame(sim)
colnames(sim)<-c("coef.interaction",
                 "odds.ratio.interaction",
                 "se.interaction",
                 "p.val.interaction",
                 "N")

#Subset of sample



i<-1
dta_near_plant<- matchedinquiries %>% filter(near_plant==1)
count_near_plant<-round(dim(dta_near_plant)[1]/2)

dta_far_plant<- matchedinquiries %>% filter(near_plant==0)
count_far_plant<-round(dim(dta_far_plant)[1]/2)


counter<-count_near_plant+count_far_plant


#Full sample
dta<-matchedinquiries
CS10 <- clogit( choice ~  non_whiteRSEI + gender + education_level + as.factor(as.numeric(inquiry_order)) + strata(Address), data = dta)
y<-summary(CS10)
sim[i,1:4]<-coefficients(y)[rownames(coefficients(y))=="non_whiteRSEI"][-4]
sim[i,5]<-dim(dta)[1]
rm(CS10,y,dta)
sim[i,]

#Increase sample
i<-sum(!is.na(sim[,1]))+1
Nsample<-200
dta<-matchedinquiries
while(counter<(2.5*dim(matchedinquiries)[1])){
  #Sample and generates new addresses near plant
  dta1_add<-dta_near_plant[dta_near_plant$index%in%sample(dta_near_plant$index,Nsample),] 
  dta1_add<- dta1_add %>% mutate(rnum=rnorm(length(index)))
  dta1_add<- dta1_add %>% group_by(Address) %>% mutate(rnum=sum(rnum)) %>% ungroup()
  dta1_add<- dta1_add %>% group_by(Address) %>% mutate(index=index+rnum) %>% ungroup()
  dta1_add$rnum<-NULL
  
  #Sample and generates new addresses far from plant
  dta2_add<-dta_far_plant[dta_far_plant$index%in%sample(dta_far_plant$index,Nsample),] 
  dta2_add<- dta2_add %>% mutate(rnum=rnorm(length(index)))
  dta2_add<- dta2_add %>% group_by(Address) %>% mutate(rnum=sum(rnum)) %>% ungroup()
  dta2_add<- dta2_add %>% group_by(Address) %>% mutate(index=index+rnum) %>% ungroup()
  dta2_add$rnum<-NULL
  
  
  
  dta<-rbind(dta,dta1_add,dta2_add)
  dta$index<-round(dta$index,4)
  dta$Address<-paste0(dta$Address,"_",dta$index)
  #table(dta$index)
  #check<- dta %>% group_by(Address) %>% summarize(n=n())
  #table(check$n)
  # rm(check)

  CS10 <- clogit( choice ~  non_whiteRSEI + gender + education_level + as.factor(as.numeric(inquiry_order)) + strata(Address), data = dta)
  y<-summary(CS10)
  y
  sim[i,1:4]<-coefficients(y)[rownames(coefficients(y))=="non_whiteRSEI"][-4]
  sim[i,5]<-dim(dta)[1]
  rm(CS10,y)
  
  counter<-dim(dta)[1] 
  i<-i+1
  # print(i)
  # print("\br")
  print(counter)
}


############################################################
# Plot Power
############################################################
dim(matchedinquiries)[1]/3
sim2<-na.omit(sim)


colnames(sim2)<-c("coef","odds.ratio","se","p.val","N")

sim3<-rbind(sim2)
sim3$inquiries<-sim3$N/3


View(sim3[sim3$p.val<=0.05,])
View(sim3)
ggplot(sim3) +
  geom_line(aes(x=inquiries,y=p.val), position=position_jitter(w=10, h=0)) +
  geom_hline(yintercept=c(0.05,.10), linetype="dotted") +
  geom_vline(xintercept=c(dim(matchedinquiries)[1]/3), linetype="dotted") +
  scale_y_continuous("P-value", breaks=seq(0,.9,.05)) +
  scale_x_continuous("Number of Listings", breaks=seq(dim(matchedinquiries)[1]/3,max(sim3$inquiries),150)) +
  ggtitle("Power Calculations Non Whites*RSEI") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5)) 
  

ggsave("views/power_calculation_plot_only_non_white_rsei.pdf")



ggplot(sim3) +
  geom_line(aes(x=inquiries,y=coef), position=position_jitter(w=10, h=0)) +
  scale_y_continuous("Coefficient") +
  scale_x_continuous("Number of Listings", breaks=seq(dim(matchedinquiries)[1]/3,max(sim3$inquiries),150)) +
  geom_vline(xintercept=c(2905), linetype="dotted") +
  ggtitle("Coef. Non white*RSEI") +
  theme_bw()


ggsave("views/coef_rsei.pdf")
