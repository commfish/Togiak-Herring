###############################################################################
###############################################################################
#
# HERRING GRAPHICS FOR LOOP (some mods made from primary)
#
# Created and maintained by Sara Miller Alaska Department of Fish & Game 
#  (sara.miller@alaska.gov) (October 20, 2017)
#------------------------------------------------------------------------------
# Libraries
#------------------------------------------------------------------------------
library(plyr)
library(reshape2)
library(lattice)
library(latticeExtra)
library(gridExtra)
library(ggplot2)
library(Hmisc)
library(grid)
library(scales)
library(extrafont)
library(xlsx)
library(RColorBrewer)
library(cowplot)
# font_import() #only do this one time - it takes a while
# loadfonts(device="win")
# load ----
source("./code/R/functions.R")
source("./code/R/sit.gz")
A = reptoRlist(fn='code/admb/model.rep') 
FIGDATA<- read.csv("code/ADMB/FIGDATA.dat", header=TRUE, sep="") 
write.csv(FIGDATA, "code/ADMB/FIGDATA.csv")  
FIGDATA<- read.csv("code/ADMB/FIGDATA.csv", header=TRUE, stringsAsFactors = FALSE) 
FIGDATA[FIGDATA==-9] <- NA
FIGDATA["Year"]<-seq(1980,2017,by=1) #model years
FIGDATAAGE<- read.csv("code/ADMB/FIGDATAAGE.dat", header=TRUE, sep="") 
write.csv(FIGDATAAGE, "code/ADMB/FIGDATAAGE.csv")  
FIGDATAAGE["Age"] <- c(4,5,6,7,8,9,10,11,12)#ages 3-12
FIGDATAAGE["Age2"] <- ifelse(FIGDATAAGE$Age>=12,"12+",FIGDATAAGE$Age) #add ages 12+
FIGDATAAGE["for_mat_baa_tons"]<-FIGDATAAGE$for_mat_baa/0.90718 #convert to tons
#------------------------------------------------------------------------------
# Figure 1a: Survey- and model-estimated aerial survey biomass (tons).
#------------------------------------------------------------------------------
y<-A$for_mat_B_st#forecast mature biomass (tons)
x<-subset(FIGDATA, select=c(Year, tot_obs_aerial_tons,tot_mat_B_tons, tot_obs_aerial_tuned_tons))
Y<-c(max(x$Year)+1)
B<- data.frame(Y)  
B["Year"]<-B$Y
B["tot_obs_aerial_tons"]<-0
B["tot_mat_B_tons"]<-0
B["tot_obs_aerial_tuned_tons"]<-0
B<-subset(B, select=c(Year, tot_obs_aerial_tons,tot_mat_B_tons,tot_obs_aerial_tuned_tons))
C<-rbind(x,B) #to create x axis with a greater x value than max(Year)
C[C==0] <- NA
options(scipen=999)
windowsFonts(A = windowsFont("Times New Roman"))
png(file='figures/Figure 1a.png', res=200, width=8, height=4, units ="in")  
op <- par(family = "Times New Roman")
yticks <- seq(0, 400000, 50000)
plot(C$Year,C$tot_obs_aerial_tons,pch=21,col="black",xaxt="n", bg="blue",cex=1.2,lwd=1,
     ylab="Biomass (tons)",xlab="Year",#options(scipen=4),
     cex.axis=1.2,cex.lab=1.2, family="A",ylim=c(0, 400000))
lines(C$Year,C$tot_obs_aerial_tons,lty=2,lwd=1,col="black") #observed
lines(C$Year,C$tot_mat_B_tons,lwd=3,col="black") #predicted
points(C$Year,C$tot_obs_aerial_tons,pch=21,col="black", bg="blue", cex=1.3) #observed
points(C$Year,C$tot_obs_aerial_tuned_tons,pch=21,col="black", bg="green", cex=1.3) #observed
points(max(FIGDATA$Year)+1,y,pch=8,col="black",cex=1)
lines(FIGDATA$Year,FIGDATA$threshold,col="grey",lty=1, lwd=2)
axis(side=1,at=seq(min(C$Year),max(C$Year),1),cex.axis=1, las=2)
legend("topright",c("Survey-estimated aerial biomass","Survey-estimated aerial biomass (tuned to model)","Model-estimated mature biomass (ADMB)",
                    "Mature biomass forecast (ADMB)"),
       pch=c(16,16, NA, 8),lty=c(2,2,1,NA), col=c("blue", "green", "black","black"),bg="black", cex=0.7, bty="n", 
       lwd=c(NA,NA,2,NA))
dev.off()
Figure_1a_data<-C
rm (C)

#------------------------------------------------------------------------------
# Figure 1b: Survey- and model-estimated aerial survey biomass (tons) with historical runs.
#------------------------------------------------------------------------------
excel_2016<-c(77980,135211,209852,254955,267237,327852,340136,350373, 288862,
              241975,205330,197715,193639,175370,193292,179832, 175108,154537,148286,122684,
              116472,125157,137273,163266,165144, 162426,167738, 149640,133204,135304,155786,166383,
              174124,200752,190640,178368,NA,NA,NA)
excel_2016_pred<-162244
excel_2015<-c(58888,109638,197028,274969,315702,385749,
              398561,415923,351064,301590,259619,244676,233700,192144,201351,
              183803,175855,152810,146454,123202,120139,131665,140088,160914,
              160237,156850,159776,141509,128276,134670, 157687,167234,171880,
              194771,181296,NA,NA,NA,NA)
excel_2015_pred<-163480
excel_2014<-c(57682,109128,196858,274695,314097,381140,392668,
              410451,347585,299163,258337,243909,233392,192006,201513,183058,175017,152349,
              146437,123387,120141,131167,140202,161616,160528,156462,
              159718,142351,129926,137082,160164,166664,163898,176898,NA,NA,NA,NA,NA)
excel_2014_pred<-157448
excel_2017_pred<-130852
y<-A$for_mat_B_st#forecast mature biomass (tons)

x<-subset(FIGDATA, select=c(Year, tot_obs_aerial_tons,tot_mat_B_tons, tot_obs_aerial_tuned_tons))
Y<-c(max(x$Year)+1)
B<- data.frame(Y)  
B["Year"]<-B$Y
B["tot_obs_aerial_tons"]<-0
B["tot_mat_B_tons"]<-0
B["tot_obs_aerial_tuned_tons"]<-0
B<-subset(B, select=c(Year, tot_obs_aerial_tons,tot_mat_B_tons,tot_obs_aerial_tuned_tons))
C<-rbind(x,B) #to create x axis with a greater x value than max(Year)
C[C==0] <- NA
C<-cbind(C,excel_2016, excel_2015, excel_2014) 

windowsFonts(A = windowsFont("Times New Roman"))
png(file='figures/Figure 1b.png', res=200, width=9, height=6, units ="in")  
op <- par(family = "Times New Roman")
yticks <- seq(0, 500000, 50000)
plot(C$Year,C$tot_obs_aerial_tons,pch=21,col="black",xaxt="n", bg="blue",cex=1.2,lwd=1,
     ylab="Biomass (tons)",xlab="Year",#options(scipen=4),
     cex.axis=1.2,cex.lab=1.2, family="A",ylim=c(0, 500000))
lines(C$Year,C$tot_obs_aerial_tons,lty=2,lwd=1,col="black") #observed
lines(C$Year,C$tot_mat_B_tons,lwd=2,col="black") #predicted
lines(C$Year,C$excel_2016,lwd=2,col="purple") #predicted
lines(C$Year,C$excel_2015,lwd=2,col="red") #predicted
lines(C$Year,C$excel_2014,lwd=2,col="orange") #predicted
points(C$Year,C$tot_obs_aerial_tons,pch=21,col="black", bg="blue", cex=1) #observed
points(C$Year,C$tot_obs_aerial_tuned_tons,pch=21,col="black", bg="green", cex=1) #observed
points(max(FIGDATA$Year)+1,y,pch=8,col="black",cex=1)
points(max(FIGDATA$Year)-1,excel_2016_pred,pch=8,col="purple",cex=1)
points(max(FIGDATA$Year)-2,excel_2015_pred,pch=8,col="red",cex=1)
points(max(FIGDATA$Year)-3,excel_2014_pred,pch=8,col="orange",cex=1)
points(max(FIGDATA$Year),excel_2017_pred,pch=8,col="blue",cex=1)
lines(FIGDATA$Year+1,FIGDATA$threshold,col="grey",lty=1, lwd=2)
#textxy(max(FIGDATA$Year)+1, y,round2(y), pos=3, cex=0.6)
axis(side=1,at=seq(min(C$Year),max(C$Year)+1,1),cex.axis=1, las=2)
legend("topright",c("Survey-estimated aerial biomass",
                    "Survey-estimated aerial biomass (tuned to model)",
                    "2018 Model-estimated (ADMB)",
                    "2018 forecast (ADMB)",
                    "2017 forecast (excel)",
                    "2016 Model estimated (excel)",
                    "2016 forecast (excel)",
                    "2015 Model estimated (excel)",
                    "2015 forecast (excel)",
                    "2014 Model estimated (excel)",
                    "2014 forecast (excel)",
                    "Threshold"),
       pch=c(16,16, NA, 8, 8, NA,8,NA,8,NA,8,NA),
       lty=c(NA,NA,1,NA,NA,1,NA,1,NA,1,NA,1), 
       col=c("blue", "green", "black","black","blue","purple", "purple","red",
             "red", "orange", "orange","grey"),bg="black", cex=0.75, bty="n",
       lwd=1)
dev.off()
Figure_1b_data<-C
rm (C)
#------------------------------------------------------------------------------
# Figure 2: Residuals from model fits to aerial survey biomass
#------------------------------------------------------------------------------
detach(package:Hmisc, unload = TRUE) 
windowsFonts(A = windowsFont("Times New Roman"))
g2a <- ggplot() +geom_bar(data=FIGDATA, mapping=aes(x=Year, y=res_aerial),
                          stat='identity', position='dodge', fill="#E69F00") +
                          ylab("Aerial survey residuals")
g2a<-g2a+scale_y_continuous(labels = fmt())+
     scale_x_continuous(breaks=seq(min(FIGDATA$Year),max(FIGDATA$Year)+1,1))+
     theme(axis.text.x = element_text(size=15,colour="black"),
        axis.title.x = element_text(size=15, colour="black"))+
     theme(axis.text.y = element_text(size=15,colour="black"),
        axis.title.y = element_text(size=15,colour="black"))+
     theme(panel.border = element_rect(colour = "black"))+
     theme(legend.position="none")+
     theme(panel.grid.major = element_line(colour="white"))+
     theme(strip.text.x = element_text(size=14,face="bold"))
g2a<-g2a+theme_set(theme_bw(base_size=12,base_family=
                     'Times New Roman')+
            theme(panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank()))
cutoff <- data.frame(yintercept=0)
g2a<-g2a + geom_hline(aes(yintercept=yintercept), data=cutoff, show.legend=FALSE, 
                      colour="black", size=0.55)
g2a<-g2a+theme(axis.text.x=element_text(angle=-90))

png(file='figures/Figure 2.png', res=200, width=8, height=5, units ="in")  
grid.newpage()
pushViewport(viewport(layout=grid.layout(1,1)))
vplayout<-function(x,y) viewport (layout.pos.row=x, layout.pos.col=y)
print(g2a,vp=vplayout(1,1:1)) 
dev.off()
C<-subset(FIGDATA, select=c(Year, res_aerial))
Figure_2_data<-C
rm(B,g2a,C, cutoff)
#------------------------------------------------------------------------------
# Figure 3: Model estimates of age-4 recruit strength (numbers of age-4 mature 
#             and immature fish).
#------------------------------------------------------------------------------
B<-subset(FIGDATA, select=c(Year, init_age_4))
maxY<-max(B$init_age_4,na.rm=TRUE)*1.3
g3 <- ggplot() +geom_bar(data=B, mapping=aes(x=Year, y=init_age_4),stat='identity', 
                         position='dodge', fill="#56B4E9") +
  ylab("Number of age-4 recruits (millions)")

g3 <- g3 +theme(legend.position="none") +scale_x_continuous(breaks=seq(min(B$Year),
                                                                       max(B$Year+1),1))+coord_cartesian(ylim=c(0,maxY))+
  theme(axis.text.x = element_text(size=14, colour="black"),
        axis.title.x = element_text(size=14, colour="black"))+theme_bw()+
  theme(axis.text.y = element_text(size=14,colour="black"),
        axis.title.y = element_text(size=14,colour="black"))+
  theme(panel.background = element_rect(colour="white"))+
  theme(legend.position="none")+
  theme(panel.border = element_rect(colour = "black"))

g3 <- g3+theme_set(theme_bw(base_size=14,base_family='Times New Roman')+
                     theme(panel.grid.major = element_blank(),
                           panel.grid.minor = element_blank()))
g3 <- g3+theme(axis.text.x=element_text(angle=-90))

png(file='figures/Figure 3.png', res=200, width=10, height=6, units ="in")
pushViewport(viewport(layout=grid.layout(1,1)))
vplayout<-function(x,y) viewport (layout.pos.row=x, layout.pos.col=y)
print(g3,vp=vplayout(1,1:1))
dev.off()
C<-subset(FIGDATA, select=c(Year, init_age_4))
Figure_3_data<-C
rm(B,g3,C, maxY)
#------------------------------------------------------------------------------
# Figure 4: Spawning population abundance (blue bars;middle figure), population abundance 
#            (immature and spawning abundance) (blue bars;bottom figure), and 
#            commercial fishery harvest (yellow bars) over time. 
# The combination of the blue and yellow bars (total height of each bar) is the 
# mature biomass, mature population abundance, or total population abundance.
#------------------------------------------------------------------------------
#detach(package:Hmisc, unload = TRUE)
png(file='figures/Figure 4.png', res=200, width=13, height=10, units ="in") 
B<-subset(FIGDATA, select=c(Year, N, tot_post_N)) 
B["Catch"]<-B$N-B$tot_post_N
B["postfishery"]<-B$tot_post_N
maxY<-max(B$postfishery,na.rm=TRUE)*1.5
B<-subset(B, select=c(Year,Catch,postfishery)) 
B <- melt(B, id=c("Year"), na.rm=TRUE)
B<- B[order(B$Year, -B$value) , ]
#Total population abundance (N)
g4b<-ggplot()+geom_bar(data=B, mapping=aes(x = Year,y=value, fill = variable),stat='identity') + 
  ylab("Mature + Immature Abundance (millions)")+xlab("Year")+
  scale_fill_manual(values=c("#E69F00", "#0072B2"))

g4b<-g4b+theme(panel.grid.major = element_blank(),
               panel.grid.minor = element_blank())+  
  theme(axis.text.x = element_text(size=12,colour="black", family="Times New Roman"),
        axis.title.x = element_text(size=14, colour="black",family="Times New Roman"))+
  theme(axis.text.y = element_text(size=12,colour="black",family="Times New Roman"),
        axis.title.y = element_text(size=14,colour="black",family="Times New Roman"))+
  theme(panel.background = element_rect(colour="white"))+
  theme(panel.border = element_rect(colour = "black"))+
  theme(strip.text.x = element_text(size=14,face="bold", family="Times New Roman"))

g4b<-g4b+coord_cartesian(ylim=c(0,maxY))+scale_x_continuous(breaks=seq(min(B$Year),max(B$Year+1),1))+                  
  theme(legend.position="none")
g4b<-g4b+theme(axis.text.x=element_text(angle=-90))
rm(B,maxY)

#Mature Abundance
B<-subset(FIGDATA, select=c(Year, tot_sp_N, tot_mat_N)) 
B["Catch"]<-B$tot_mat_N-B$tot_sp_N
B["postfishery"]<-B$tot_sp_N
maxY<-max(B$postfishery,na.rm=TRUE)*1.5
B<-subset(B, select=c(Year,Catch,postfishery)) 
B<- melt(B, id=c("Year"), na.rm=TRUE)
B<- B[order(B$Year, -B$value) , ]

g4c<-ggplot()+geom_bar(data=B, mapping=aes(x = Year,y=value, fill = variable),stat='identity') + 
  ylab("Mature Abundance (millions)")+xlab("Year")+
  scale_fill_manual(values=c("#E69F00", "#0072B2"))

g4c<-g4c+theme(panel.grid.major = element_blank(),
               panel.grid.minor = element_blank())+  
  theme(axis.text.x = element_text(size=12,colour="black", family="Times New Roman"),
        axis.title.x = element_text(size=14, colour="black",family="Times New Roman"))+
  theme(axis.text.y = element_text(size=12,colour="black",family="Times New Roman"),
        axis.title.y = element_text(size=14,colour="black",family="Times New Roman"))+
  theme(panel.background = element_rect(colour="white"))+
  theme(panel.border = element_rect(colour = "black"))+
  theme(strip.text.x = element_text(size=14,face="bold", family="Times New Roman"))

g4c<-g4c+coord_cartesian(ylim=c(0,maxY))+scale_x_continuous(breaks=seq(min(B$Year),max(B$Year+1),1))+                  
  theme(legend.position="none")
g4c<-g4c+theme(axis.text.x=element_text(angle=-90))

library(grid)
g4<-arrange_ggplot2(g4c,g4b, ncol=1)
dev.off()
B<-subset(FIGDATA, select=c(Year, N, tot_post_N,tot_sp_N, tot_mat_N)) 
B["Catch1"]<-B$tot_mat_N-B$tot_sp_N
B["Catch2"]<-B$N-B$tot_post_N
Figure_4_data<-B

rm(g4b,B,g4c,maxY)
#------------------------------------------------------------------------------
# Figure 5: Model estimates of survival (a), maturity at age (b), 
#           and gear selectivity at age (c) by year.
#------------------------------------------------------------------------------
#Figure 5a: Model estimates of survival
B<-subset(FIGDATAAGE, select=c(Age2, Survival)) #predicted
B$Age2<-as.factor(B$Age2)
B$Age2 <- factor(B$Age2, as.character(B$Age2))
g5a <- ggplot() +geom_bar(data=B, mapping=aes(x=Age2, y=Survival),stat='identity', 
                          position='dodge', fill="#56B4E9")+ylab("Proportion-at-age")+
  xlab("Age")+geom_line(data=B,aes(x=Age2,y=Survival),show.legend=FALSE,size=2,colour="black") 

g5a<-g5a+coord_cartesian(ylim=c(0,1))+  
  theme(axis.text.x = element_text(size=12,colour="black",family="Times New Roman"),
        axis.title.x = element_text(size=14, colour="black",family="Times New Roman"))+
  theme(axis.text.y = element_text(size=12,colour="black",family="Times New Roman"),
        axis.title.y = element_text(size=14,colour="black",family="Times New Roman"))+
  theme(plot.title=element_text(size=rel(1.5),colour="black",vjust =1))+
  theme(strip.text.x = element_text(size=14,face="bold", family="Times New Roman"))+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())
g5a<-g5a + ggtitle("Survival") + 
  theme(plot.title = element_text(lineheight=.8, face="bold"))
png(file='figures/Figure 5a.png', res=200, width=9, height=6, units ="in")
pushViewport(viewport(layout=grid.layout(1,1)))
vplayout<-function(x,y) viewport (layout.pos.row=x, layout.pos.col=y)
print(g5a,vp=vplayout(1,1:1))
Figure_5a_data<-B
dev.off()
rm(B,g7b)

#Figure 5b: Model estimates of maturity
y<-as.data.frame(A$maturity)
B<-subset(FIGDATA, select=c(Year)) #predicted
C <- cbind(y,B)
C <- merge(FIGDATA,C,by=c("Year"), all=TRUE)
C["Age4"]<-C$V1
C["Age5"]<-C$V2
C["Age6"]<-C$V3
C["Age7"]<-C$V4
C["Age8"]<-C$V5
C["Age9"]<-C$V6
C["Age10"]<-C$V7
C["Age11"]<-C$V8
C["Age12"]<-C$V9
C<-subset(C, select=c(Year, Age4, Age5, Age6, Age7, Age8, Age9, Age10, Age11, Age12))
C<- melt(C, id=c("Year"), na.rm=TRUE)
C["Age"] <- ifelse(C$variable=="Age4","4", ifelse (C$variable=="Age5","5",
                                                   ifelse (C$variable=="Age6","6",
                                                           ifelse (C$variable=="Age7","7",
                                                                   ifelse (C$variable=="Age8","8",
                                                                           ifelse (C$variable=="Age9","9",
                                                                                   ifelse (C$variable=="Age10","10",
                                                                           ifelse (C$variable=="Age11","11","12+"))))))))

C["MAT"]<-C$value
C<-subset(C, select=c(Year, Age, MAT))
C$Age <- factor(C$Age, levels=c("4", "5", "6", "7", "8", "9", "10","11", "12+"))
g5b<-ggplot(data=C,aes(x=Age, y=MAT,fill=Age))+facet_wrap(~Year,ncol=8,as.table=TRUE)+
     geom_bar(stat="identity")+
     geom_line(data=C,aes(x=Age,y=MAT,group=Year),show.legend=FALSE,size=1,colour="black")+ 
     theme_bw()+
     xlab ("Age")+ylab("Proportion-at-age")+
     theme(text=element_text(family="Times New Roman", face="bold", size=12))

g5b<-g5b+coord_cartesian(ylim=c(0,1))+
  theme(axis.text.x = element_text(size=8,colour="black",family="Times New Roman"),
        axis.title.x = element_text(size=14, colour="black",family="Times New Roman"))+
  theme(axis.text.y = element_text(size=12,colour="black",family="Times New Roman"),
        axis.title.y = element_text(size=14,colour="black",family="Times New Roman"))+
  theme(plot.title=element_text(size=rel(1.5),colour="black",vjust =1))+
  theme(strip.text.x = element_text(size=14,face="bold",family="Times New Roman"))+
  theme(panel.grid.major = element_blank(),
      panel.grid.minor = element_blank())
g5c<-g5c + ggtitle("Maturity") + 
  theme(plot.title = element_text(lineheight=.8, face="bold"))

png(file='figures/Figure 5b.png', res=200, width=11, height=6, units ="in")
pushViewport(viewport(layout=grid.layout(1,1)))
vplayout<-function(x,y) viewport (layout.pos.row=x, layout.pos.col=y)
print(g5c,vp=vplayout(1,1:1))
dev.off()
Figure_5b_data<-C
rm(y,B,C,g5c)

# Figure 5c: Model estimates of gear selectivity at age.
y<-as.data.frame(A$gs_seine)
B<-subset(FIGDATA, select=c(Year)) #predicted
C <- cbind(y,B)
C <- merge(FIGDATA,C,by=c("Year"), all=TRUE)
C["Age4"]<-C$V1
C["Age5"]<-C$V2
C["Age6"]<-C$V3
C["Age7"]<-C$V4
C["Age8"]<-C$V5
C["Age9"]<-C$V6
C["Age10"]<-C$V7
C["Age11"]<-C$V8
C["Age12"]<-C$V9
C<-subset(C, select=c(Year, Age4, Age5, Age6, Age7, Age8, Age9, Age10, Age11, Age12))
C<- melt(C, id=c("Year"), na.rm=TRUE)
C["Age"] <- ifelse(C$variable=="Age4","4", ifelse (C$variable=="Age5","5",
                                                   ifelse (C$variable=="Age6","6",
                                                           ifelse (C$variable=="Age7","7",
                                                                   ifelse (C$variable=="Age8","8",
                                                                           ifelse (C$variable=="Age9","9",
                                                                                   ifelse (C$variable=="Age10","10",
                                                                                           ifelse (C$variable=="Age11","11","12+"))))))))

C["GS"]<-C$value
C<-subset(C, select=c(Year, Age, GS))
C$Age <- factor(C$Age, levels=c("4", "5", "6", "7", "8", "9", "10","11", "12+"))
g5c<-ggplot(data=C,aes(x=Age, y=GS,fill=Age))+facet_wrap(~Year,ncol=8,as.table=TRUE)+
  geom_bar(stat="identity")+
  geom_line(data=C,aes(x=Age,y=GS,group=Year),show.legend=FALSE,size=1,colour="black")+ 
  theme_bw()+
  xlab ("Age")+ylab("Proportion-at-age")+
  theme(text=element_text(family="Times New Roman", face="bold", size=12))

g5c<-g5c+coord_cartesian(ylim=c(0,1))+
  theme(axis.text.x = element_text(size=8,colour="black",family="Times New Roman"),
        axis.title.x = element_text(size=14, colour="black",family="Times New Roman"))+
  theme(axis.text.y = element_text(size=12,colour="black",family="Times New Roman"),
        axis.title.y = element_text(size=14,colour="black",family="Times New Roman"))+
  theme(plot.title=element_text(size=rel(1.5),colour="black",vjust =1))+
  theme(strip.text.x = element_text(size=14,face="bold",family="Times New Roman"))+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())
g5c<-g5c + ggtitle("Gear Selectivity") + 
  theme(plot.title = element_text(lineheight=.8, face="bold"))

png(file='figures/Figure 5c.png', res=200, width=11, height=6, units ="in")
pushViewport(viewport(layout=grid.layout(1,1)))
vplayout<-function(x,y) viewport (layout.pos.row=x, layout.pos.col=y)
print(g5c,vp=vplayout(1,1:1))
dev.off()
Figure_5b_data<-C
rm(y,B,C,g5c)png(file='Figure 5c.png', res=200, width=9, height=6, units ="in")
pushViewport(viewport(layout=grid.layout(1,1)))
vplayout<-function(x,y) viewport (layout.pos.row=x, layout.pos.col=y)
print(g5a,vp=vplayout(1,1:1))
Figure_5c_data<-B
dev.off()
rm(B,C,y,g7a)
#------------------------------------------------------------------------------
# Figure 6: Observed seine  (bar) and model-estimated (red line with square points) 
#catch-age composition.
#------------------------------------------------------------------------------
# detach(package:Hmisc, unload = TRUE)
D<-subset(FIGDATA, select=c(Year,est_seine_comp4, est_seine_comp5, est_seine_comp6,
                            est_seine_comp7,est_seine_comp8,est_seine_comp9,
                            est_seine_comp10,est_seine_comp11,est_seine_comp12)) #estimated
D["Age4"]<-D$est_seine_comp4
D["Age5"]<-D$est_seine_comp5
D["Age6"]<-D$est_seine_comp6
D["Age7"]<-D$est_seine_comp7
D["Age8"]<-D$est_seine_comp8
D["Age9"]<-D$est_seine_comp9
D["Age10"]<-D$est_seine_comp10
D["Age11"]<-D$est_seine_comp11
D["Age12"]<-D$est_seine_comp12

D["SUM"]<-sum(D$Age4, D$Age5, D$Age6, D$Age7, D$Age8, D$Age9, D$Age10, D$Age11, D$Age12)
D<-subset(D, select=c(Year,Age4, Age5, Age6, Age7, Age8, Age9, Age10, Age11, Age12))
D<- melt(D, id=c("Year"), na.rm=TRUE)
D["Age"] <- ifelse(D$variable=="Age4","4", ifelse (D$variable=="Age5","5",
                                                   ifelse (D$variable=="Age6","6",
                                                           ifelse (D$variable=="Age7","7",
                                                                   ifelse (D$variable=="Age8","8",
                                                                           ifelse (D$variable=="Age9","9",
                                                                                   ifelse (D$variable=="Age10","10",     
                                                                           ifelse (D$variable=="Age11","11","12+"))))))))

D["EST"]<-D$value
D<-subset(D, select=c(Year,Age, EST))
B<-subset(FIGDATA, select=c(Year,obs_seine_comp4, obs_seine_comp5, obs_seine_comp6, 
                            obs_seine_comp7, obs_seine_comp8, obs_seine_comp9, obs_seine_comp10,
                            obs_seine_comp11, obs_seine_comp12))#observed
B["Age4"]<-B$obs_seine_comp4
B["Age5"]<-B$obs_seine_comp5
B["Age6"]<-B$obs_seine_comp6
B["Age7"]<-B$obs_seine_comp7
B["Age8"]<-B$obs_seine_comp8
B["Age9"]<-B$obs_seine_comp9
B["Age10"]<-B$obs_seine_comp10
B["Age11"]<-B$obs_seine_comp11
B["Age12"]<-B$obs_seine_comp12

B["SUM"]<-sum(B$Age4, B$Age5, B$Age6, B$Age7, B$Age8,B$Age9, B$Age10, B$Age11, B$Age12)
B<-subset(B, select=c(Year,Age4, Age5, Age6, Age7, Age8, Age9, Age10, Age11, Age12))
B<- melt(B, id=c("Year"), na.rm=TRUE)
B["Age"] <- ifelse(B$variable=="Age4","4", ifelse (B$variable=="Age5","5",
                                                   ifelse (B$variable=="Age6","6",
                                                           ifelse (B$variable=="Age7","7",
                                                                   ifelse (B$variable=="Age8","8",
                                                                           ifelse (B$variable=="Age9","9",
                                                                                   ifelse (B$variable=="Age10","10",     
                                                                           ifelse (B$variable=="Age11","11","12+"))))))))

B["OBS"]<-B$value
B<-subset(B, select=c(Year,Age, OBS))
C <- merge(D,B,by=c("Year", "Age"), all=TRUE)
C$Age <- factor(C$Age, levels=c("4", "5", "6", "7", "8", "9", "10","11", "12+"))
C <- rbind(C,data.frame(Year=2016,Age=4,EST=NA, OBS=NA))
C <- rbind(C,data.frame(Year=2017,Age=4,EST=NA, OBS=NA))
C <- rbind(C,data.frame(Year=2018,Age=4,EST=NA, OBS=NA))
C <- rbind(C,data.frame(Year=2019,Age=4,EST=NA, OBS=NA))


C$Year<-factor(C$Year,levels=c(
  "1980",	"1984",	"1988",	"1992",	"1996",	"2000",	"2004",	"2008",	"2012",	"2016",
  "1981",	"1985",	"1989",	"1993",	"1997",	"2001",	"2005",	"2009",	"2013","2017",
  "1982",	"1986",	"1990",	"1994",	"1998",	"2002",	"2006",	"2010",	"2014",	"2018",
  "1983",	"1987",	"1991",	"1995",	"1999",	"2003",	"2007",	"2011",	"2015",	"2019"
))

g6<-ggplot(data=C,aes(x=Age, y=OBS,fill=Age))+
    facet_wrap(~Year,nrow=4, ncol=10)+ 
    geom_bar(stat="identity")+
    geom_line(data=C,aes(x=Age,y=EST,group=Year),show.legend=FALSE,size=1,colour="red")+
    geom_point(data = C,aes(x=Age,y=EST,group=Year),show.legend=FALSE,size=2,shape=22,fill="red")+ 
    theme_bw()+
    xlab ("Age")+ylab("Commercial catch proportion-at-age")+ 
    theme(text=element_text(family="Times New Roman", face="bold", size=12))

#g6<-g6+coord_cartesian(ylim=c(0,1))+ #uncomment and comment out next line if one y axis from 0 to 1
g6<-g6+coord_cartesian(ylim=c(0,0.75))+
  theme(axis.text.x = element_text(size=10,colour="black",family="Times New Roman"),
        axis.title.x = element_text(size=14, colour="black",family="Times New Roman"))+
  theme(axis.text.y = element_text(size=12,colour="black",family="Times New Roman"),
        axis.title.y = element_text(size=14,colour="black",family="Times New Roman"))+
  theme(plot.title=element_text(size=rel(1.5),colour="black",vjust =1,family="Times New Roman"))+
  theme(strip.text.x = element_text(size=14,face="bold"))+
  theme(panel.grid.major = element_blank(),
      panel.grid.minor = element_blank())

png(file='figures/Figure 6.png', res=200, width=15, height=7, units ="in")
pushViewport(viewport(layout=grid.layout(1,1)))
vplayout<-function(x,y) viewport (layout.pos.row=x, layout.pos.col=y)
print(g6,vp=vplayout(1,1:1))
dev.off()

Figure_6_data<-C
rm(B,C,g6,D)
#------------------------------------------------------------------------------
# Figure 7: Model-estimated mature composition (red line with square points) and 
#observed (bars); pre-fishery, mature age composition
#------------------------------------------------------------------------------
# detach(package:Hmisc, unload = TRUE)
D<-subset(FIGDATA, select=c(Year,est_mat_comp4, est_mat_comp5, est_mat_comp6,
                            est_mat_comp7,est_mat_comp8,est_mat_comp9,
                            est_mat_comp10,est_mat_comp11,est_mat_comp12)) #estimated
D["Age4"]<-D$est_mat_comp4
D["Age5"]<-D$est_mat_comp5
D["Age6"]<-D$est_mat_comp6
D["Age7"]<-D$est_mat_comp7
D["Age8"]<-D$est_mat_comp8
D["Age9"]<-D$est_mat_comp9
D["Age10"]<-D$est_mat_comp10
D["Age11"]<-D$est_mat_comp11
D["Age12"]<-D$est_mat_comp12

D["SUM"]<-sum(D$Age4, D$Age5, D$Age6, D$Age7, D$Age8, D$Age9, D$Age10, D$Age11, D$Age12)
D<-subset(D, select=c(Year,Age4, Age5, Age6, Age7, Age8, Age9, Age10, Age11, Age12))
D<- melt(D, id=c("Year"), na.rm=TRUE)
D["Age"] <- ifelse(D$variable=="Age4","4", ifelse (D$variable=="Age5","5",
                                                   ifelse (D$variable=="Age6","6",
                                                           ifelse (D$variable=="Age7","7",
                                                                   ifelse (D$variable=="Age8","8",
                                                                           ifelse (D$variable=="Age9","9",
                                                                                   ifelse (D$variable=="Age10","10",     
                                                                                           ifelse (D$variable=="Age11","11","12+"))))))))

D["EST"]<-D$value
D<-subset(D, select=c(Year,Age, EST))
B<-subset(FIGDATA, select=c(Year,obs_mat_comp4, obs_mat_comp5, obs_mat_comp6, 
                            obs_mat_comp7, obs_mat_comp8, obs_mat_comp9, obs_mat_comp10,
                            obs_mat_comp11, obs_mat_comp12))#observed
B["Age4"]<-B$obs_mat_comp4
B["Age5"]<-B$obs_mat_comp5
B["Age6"]<-B$obs_mat_comp6
B["Age7"]<-B$obs_mat_comp7
B["Age8"]<-B$obs_mat_comp8
B["Age9"]<-B$obs_mat_comp9
B["Age10"]<-B$obs_mat_comp10
B["Age11"]<-B$obs_mat_comp11
B["Age12"]<-B$obs_mat_comp12

B["SUM"]<-sum(B$Age4, B$Age5, B$Age6, B$Age7, B$Age8,B$Age9, B$Age10, B$Age11, B$Age12)
B<-subset(B, select=c(Year,Age4, Age5, Age6, Age7, Age8, Age9, Age10, Age11, Age12))
B<- melt(B, id=c("Year"), na.rm=TRUE)
B["Age"] <- ifelse(B$variable=="Age4","4", ifelse (B$variable=="Age5","5",
                                                   ifelse (B$variable=="Age6","6",
                                                           ifelse (B$variable=="Age7","7",
                                                                   ifelse (B$variable=="Age8","8",
                                                                           ifelse (B$variable=="Age9","9",
                                                                                   ifelse (B$variable=="Age10","10",     
                                                                                           ifelse (B$variable=="Age11","11","12+"))))))))

B["OBS"]<-B$value
B<-subset(B, select=c(Year,Age, OBS))
C <- merge(D,B,by=c("Year", "Age"), all=TRUE)
C$Age <- factor(C$Age, levels=c("4", "5", "6", "7", "8", "9", "10","11", "12+"))
C <- rbind(C,data.frame(Year=2016,Age=4,EST=NA, OBS=NA))
C <- rbind(C,data.frame(Year=2017,Age=4,EST=NA, OBS=NA))
C <- rbind(C,data.frame(Year=2018,Age=4,EST=NA, OBS=NA))
C <- rbind(C,data.frame(Year=2019,Age=4,EST=NA, OBS=NA))
C$Year<-factor(C$Year,levels=c(
  "1980",	"1984",	"1988",	"1992",	"1996",	"2000",	"2004",	"2008",	"2012",	"2016",
  "1981",	"1985",	"1989",	"1993",	"1997",	"2001",	"2005",	"2009",	"2013","2017",
  "1982",	"1986",	"1990",	"1994",	"1998",	"2002",	"2006",	"2010",	"2014",	"2018",
  "1983",	"1987",	"1991",	"1995",	"1999",	"2003",	"2007",	"2011",	"2015",	"2019"
))


g7<-ggplot(data=C,aes(x=Age, y=OBS,fill=Age))+
  facet_wrap(~Year,nrow=4, ncol=10)+ 
  geom_bar(stat="identity")+
  geom_line(data=C,aes(x=Age,y=EST,group=Year),show.legend=FALSE,size=1,colour="red")+
  geom_point(data = C,aes(x=Age,y=EST,group=Year),show.legend=FALSE,size=2,shape=22,fill="red")+ 
  theme_bw()+
  xlab ("Age")+ylab("Mature proportion-at-age")+ 
  theme(text=element_text(family="Times New Roman", face="bold", size=12))

#g7<-g7+coord_cartesian(ylim=c(0,1))+ #uncomment and comment out next line if one y axis from 0 to 1
g7<-g7+coord_cartesian(ylim=c(0,0.75))+
  theme(axis.text.x = element_text(size=10,colour="black",family="Times New Roman"),
        axis.title.x = element_text(size=14, colour="black",family="Times New Roman"))+
  theme(axis.text.y = element_text(size=12,colour="black",family="Times New Roman"),
        axis.title.y = element_text(size=14,colour="black",family="Times New Roman"))+
  theme(plot.title=element_text(size=rel(1.5),colour="black",vjust =1,family="Times New Roman"))+
  theme(strip.text.x = element_text(size=14,face="bold"))+
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())

png(file='figures/Figure 7.png', res=200, width=15, height=7, units ="in")
pushViewport(viewport(layout=grid.layout(1,1)))
vplayout<-function(x,y) viewport (layout.pos.row=x, layout.pos.col=y)
print(g7,vp=vplayout(1,1:1))
dev.off()

Figure_7_data<-C
rm(B,C,D)

#------------------------------------------------------------------------------
# Figure 7a: Mature age composition by year (bubble plots)
#------------------------------------------------------------------------------
# detach(package:Hmisc, unload = TRUE)

B<-subset(FIGDATA, select=c(Year,obs_mat_comp4, obs_mat_comp5, obs_mat_comp6, 
                            obs_mat_comp7, obs_mat_comp8, obs_mat_comp9, obs_mat_comp10,
                            obs_mat_comp11, obs_mat_comp12))#observed
B["Age4"]<-B$obs_mat_comp4
B["Age5"]<-B$obs_mat_comp5
B["Age6"]<-B$obs_mat_comp6
B["Age7"]<-B$obs_mat_comp7
B["Age8"]<-B$obs_mat_comp8
B["Age9"]<-B$obs_mat_comp9
B["Age10"]<-B$obs_mat_comp10
B["Age11"]<-B$obs_mat_comp11
B["Age12"]<-B$obs_mat_comp12

B["SUM"]<-sum(B$Age4, B$Age5, B$Age6, B$Age7, B$Age8,B$Age9, B$Age10, B$Age11, B$Age12)
B<-subset(B, select=c(Year,Age4, Age5, Age6, Age7, Age8, Age9, Age10, Age11, Age12))
B<- melt(B, id=c("Year"), na.rm=TRUE)
B["Age"] <- ifelse(B$variable=="Age4","4", ifelse (B$variable=="Age5","5",
                                                   ifelse (B$variable=="Age6","6",
                                                           ifelse (B$variable=="Age7","7",
                                                                   ifelse (B$variable=="Age8","8",
                                                                           ifelse (B$variable=="Age9","9",
                                                                                   ifelse (B$variable=="Age10","10",     
                                                                                           ifelse (B$variable=="Age11","11","12+"))))))))

B["OBS"]<-B$value
B<-subset(B, select=c(Year,Age, OBS))

B$Age <- factor(B$Age, levels=c("4", "5", "6", "7", "8", "9", "10","11", "12+"))

p6 <- ggplot(B, aes(x = B$Year, y = B$Age, size = B$OBS)) +
  geom_point(shape = 21, colour = "#000000", fill = "#40b8d0") 
p6 <- p6 + scale_x_continuous(breaks = seq(1980, 2017, 1))+ggtitle("Age Composition (pre-fishery)") +
  labs(x = "Year", y = "Age") +theme(legend.position="none",panel.grid.major = element_blank(),plot.title = element_text(hjust = 0.5),
panel.grid.minor = element_blank(),
panel.background = element_blank(),axis.line = element_line(size=1, colour = "black"))
p6<-p6 + theme(axis.text.x = element_text(angle = 90, hjust = 1))

png(file='figures/Figure 7a.png', res=200, width=9, height=6, units ="in")
pushViewport(viewport(layout=grid.layout(1,1)))
vplayout<-function(x,y) viewport (layout.pos.row=x, layout.pos.col=y)
print(p6,vp=vplayout(1,1:1))
dev.off()

rm(B)

#------------------------------------------------------------------------------
# Figure 7b: Mature age composition by year (bubble plots) 15+
#------------------------------------------------------------------------------
# detach(package:Hmisc, unload = TRUE)
B<- read.csv("data/obs_mat_comp_15plus.csv", header=TRUE, stringsAsFactors = FALSE) 
B[B==-9] <- NA
B<- melt(B, id=c("Year"), na.rm=TRUE)
B["Age"] <- ifelse(B$variable=="Age4","4", ifelse (B$variable=="Age5","5",
                                                   ifelse (B$variable=="Age6","6",
                                                           ifelse (B$variable=="Age7","7",
                                                                   ifelse (B$variable=="Age8","8",
                                                                           ifelse (B$variable=="Age9","9",
                                                                                   ifelse (B$variable=="Age10","10",     
                                                                                           ifelse (B$variable=="Age11","11",
                                                                                                   ifelse (B$variable=="Age12","12", 
                                                                                                           ifelse (B$variable=="Age13","13",
                                                                                                                   ifelse (B$variable=="Age14","14","15+")))))))))))

B["OBS"]<-B$value
B<-subset(B, select=c(Year,Age, OBS))

B$Age <- factor(B$Age, levels=c("4", "5", "6", "7", "8", "9", "10","11", "12","13","14","15+"))

p6 <- ggplot(B, aes(x = B$Year, y = B$Age, size = B$OBS)) +
  geom_point(shape = 21, colour = "#000000", fill = "#40b8d0") 
p6 <- p6 + scale_x_continuous(breaks = seq(1980, 2017, 1))+ggtitle("Age Composition (pre-fishery)") +
  labs(x = "Year", y = "Age") +theme(legend.position="none",panel.grid.major = element_blank(),plot.title = element_text(hjust = 0.5),
                                     panel.grid.minor = element_blank(),
                                     panel.background = element_blank(),axis.line = element_line(size=1, colour = "black"))
p6<-p6 + theme(axis.text.x = element_text(angle = 90, hjust = 1))

png(file='figures/Figure 7b.png', res=200, width=9, height=6, units ="in")
pushViewport(viewport(layout=grid.layout(1,1)))
vplayout<-function(x,y) viewport (layout.pos.row=x, layout.pos.col=y)
print(p6,vp=vplayout(1,1:1))
dev.off()

rm(B)

#------------------------------------------------------------------------------
# Figure 8: Projected mature biomass at age (tons) for forecast year.
#------------------------------------------------------------------------------
#detach(package:Hmisc, unload = TRUE)
MAXy<-max(FIGDATAAGE$for_mat_baa_tons,na.rm=TRUE)*1.5 # set y max. limit
FIGDATAAGE["for_mat_baa_tons"]<-as.numeric(FIGDATAAGE$for_mat_baa_tons)
#Check to make sure that the numbers on top of bar sum to to forecasted biomass
#If they don't enter the % manually below
FIGDATAAGE$Age2<-as.factor(FIGDATAAGE$Age2)
FIGDATAAGE$Age2 <- factor(FIGDATAAGE$Age2, as.character(FIGDATAAGE$Age2))

g8<-ggplot(FIGDATAAGE, aes(x=Age2, y=for_mat_baa_tons)) +  
  ylab("Forecasted Biomass (tons)")+
  xlab("Age")+
  theme(text=element_text(family="Times New Roman", size=12))+
  geom_bar(stat="identity",position="dodge" ,fill="#E69F00")

g8<-g8+geom_text(data=FIGDATAAGE,aes(label=round2(for_mat_baa_tons), cex=1),
                   vjust=-1)
g8<-g8+coord_cartesian(ylim=c(0,MAXy))

g8<-g8 + theme(legend.position="none")+
  theme(axis.text.x = element_text(size=14,colour="black",family="Times New Roman"),
        axis.title.x = element_text(size=14, colour="black",family="Times New Roman"))+
  theme(axis.text.y = element_text(size=14,colour="black",family="Times New Roman"),
        axis.title.y = element_text(size=14,colour="black",family="Times New Roman"))+
  theme(strip.text.x = element_text(size=14,family="Times New Roman"))+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))

png(file='figures/Figure 8.png', res=200, width=6, height=4, units ="in")
pushViewport(viewport(layout=grid.layout(1,1)))
vplayout<-function(x,y) viewport (layout.pos.row=x, layout.pos.col=y)
print(g8,vp=vplayout(1,1:1))
dev.off()

C<-subset(FIGDATAAGE, select=c(Age2, for_mat_baa_tons))
Figure_8_data<-C
rm(MAXy,g8)

#------------------------------------------------------------------------------
# Figure 9: Projected percentage of mature numbers at age for forecast year.
# *Check to make sure that the numbers on top of bar sum to 100!!!!
#------------------------------------------------------------------------------
#detach(package:Hmisc, unload = TRUE)
FIGDATAAGE["fw_a_a"]<-round(FIGDATAAGE$fw_a_a,0)
FIGDATAAGE$Age2<-as.factor(FIGDATAAGE$Age2)
FIGDATAAGE$Age2 <- factor(FIGDATAAGE$Age2, as.character(FIGDATAAGE$Age2))
D<-subset(FIGDATAAGE, select=c(for_mat_prop))
D["Percentage"]<-round(D$for_mat_prop,2)
D<-subset(D, select=c(Percentage))
x<-(colSums(D))
D["Percentage1"]<-round(D$Percentage/x,2)
D["Percentage2"]<-D$Percentage1
D<-subset(D, select=c(Percentage2))
Check<-sum(D$Percentage2)
#Check to make sure that the numbers on top of bar sum to 100!!!!
#If they don't enter the % manually below
Check<-sum(D$Percentage2)
Check
C<-cbind(FIGDATAAGE, D)
C<-cbind(FIGDATAAGE, D)
#Check to make sure that the numbers on top of bar sum to 100!!!!
C$Age <- factor(C$Age)
g9<-ggplot(C, aes(x=Age2, y=Percentage2*100, fill=Age)) + 
  ylab("Forecasted Percentage")+xlab("Age")+
  theme(text=element_text(family="Times New Roman", size=12))+
  geom_bar(stat="identity",position="dodge")
g9<-g9+scale_fill_manual(values=c("#FF0000","#3A5FCD", "#3A5FCD", "#3A5FCD","#3A5FCD", "#3A5FCD","#3A5FCD", "#3A5FCD", "#3A5FCD"))
g9<-g9+coord_cartesian(ylim=c(0,30))+
  geom_text(data=C,aes(label=paste(C$fw_a_a, "g", sep=""),cex=1),
            vjust=-1, family="Times New Roman") + #add prop. on top of bars
  theme(axis.text.x = element_text(size=14,colour="black",family="Times New Roman"),
        axis.title.x = element_text(size=14, colour="black",family="Times New Roman"))+
  theme(axis.text.y = element_text(size=14,colour="black",family="Times New Roman"),
        axis.title.y = element_text(size=14,colour="black",family="Times New Roman"))+
  theme(legend.position="none")+
  theme(strip.text.x = element_text(size=14,face="bold",family="Times New Roman"))+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))
png(file='figures/Figure 9a.png', res=200, width=6, height=4, units ="in")
pushViewport(viewport(layout=grid.layout(1,1)))
vplayout<-function(x,y) viewport (layout.pos.row=x, layout.pos.col=y)
print(g9,vp=vplayout(1,1:1))
dev.off()
rm(g9, D, x, C, Check)

FIGDATAAGE$Age2<-as.factor(FIGDATAAGE$Age2)
FIGDATAAGE$Age2 <- factor(FIGDATAAGE$Age2, as.character(FIGDATAAGE$Age2))
D<-subset(FIGDATAAGE, select=c(for_mat_prop))
D["Percentage"]<-round(D$for_mat_prop,2)
D<-subset(D, select=c(Percentage))
x<-(colSums(D))
D["Percentage1"]<-round(D$Percentage/x,2)
D["Percentage2"]<-D$Percentage1
D<-subset(D, select=c(Percentage2))
Check<-sum(D$Percentage2)
#Check to make sure that the numbers on top of bar sum to 100!!!!
#If they don't enter the % manually below
Check<-sum(D$Percentage2)
Check
C<-cbind(FIGDATAAGE, D)
C<-cbind(FIGDATAAGE, D)
#Check to make sure that the numbers on top of bar sum to 100!!!!
C$Age <- factor(C$Age)
g9<-ggplot(C, aes(x=Age2, y=Percentage2*100, fill=Age)) + 
  ylab("Forecasted Percentage")+xlab("Age")+
  theme(text=element_text(family="Times New Roman", size=12))+
  geom_bar(stat="identity",position="dodge")
g9<-g9+scale_fill_manual(values=c("#FF0000","#3A5FCD", "#3A5FCD", "#3A5FCD","#3A5FCD", "#3A5FCD","#3A5FCD", "#3A5FCD", "#3A5FCD"))
g9<-g9+coord_cartesian(ylim=c(0,30))+
  geom_text(data=C,aes(label=paste(C$Percentage2*100, "%", sep=""),cex=1),
            vjust=-1, family="Times New Roman") + #add prop. on top of bars
  theme(axis.text.x = element_text(size=14,colour="black",family="Times New Roman"),
        axis.title.x = element_text(size=14, colour="black",family="Times New Roman"))+
  theme(axis.text.y = element_text(size=14,colour="black",family="Times New Roman"),
        axis.title.y = element_text(size=14,colour="black",family="Times New Roman"))+
  theme(legend.position="none")+
  theme(strip.text.x = element_text(size=14,face="bold",family="Times New Roman"))+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))
png(file='figures/Figure 9b.png', res=200, width=6, height=4, units ="in")
pushViewport(viewport(layout=grid.layout(1,1)))
vplayout<-function(x,y) viewport (layout.pos.row=x, layout.pos.col=y)
print(g9,vp=vplayout(1,1:1))
dev.off()

C<-subset(FIGDATAAGE, select=c(Age2, for_mat_prop, fw_a_a))
Figure_9_data<-C

rm(g9, D, x, C, Check)
#------------------------------------------------------------------------------
# Figure 10: Forecasted weight-at-age. 
#------------------------------------------------------------------------------
MAXy<-max(FIGDATAAGE$fw_a_a,na.rm=TRUE)*1.5 # set y max. limit
FIGDATAAGE["fw_a_a"]<-round(FIGDATAAGE$fw_a_a,0)

g10<-ggplot(FIGDATAAGE, aes(x=Age2, y=fw_a_a)) +  
  ylab("Forecasted Weight (g)")+
  xlab("Age")+
  theme(text=element_text(family="Times New Roman", size=12))+
  geom_bar(stat="identity",position="dodge" ,fill="#56B4E9")

g10<-g10+geom_text(data=FIGDATAAGE,aes(label=paste(FIGDATAAGE$fw_a_a,"g", sep=""), 
                                       cex=1),vjust=-1) #add prop. on top of bars
g10<-g10+coord_cartesian(ylim=c(0,MAXy))
g10<-g10 + theme(legend.position="none")+
  theme(axis.text.x = element_text(size=14,colour="black",family="Times New Roman"),
        axis.title.x = element_text(size=14, colour="black",family="Times New Roman"))+
  theme(axis.text.y = element_text(size=14,colour="black",family="Times New Roman"),
        axis.title.y = element_text(size=14,colour="black",family="Times New Roman"))+
  theme(strip.text.x = element_text(size=14,face="bold",family="Times New Roman"))+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))

png(file='figures/Figure 10.png', res=200, width=6, height=4, units ="in")
pushViewport(viewport(layout=grid.layout(1,1)))
vplayout<-function(x,y) viewport (layout.pos.row=x, layout.pos.col=y)
print(g10,vp=vplayout(1,1:1))
dev.off()

C<-subset(FIGDATAAGE, select=c(Age2, fw_a_a))
Figure_10_data<-C
rm(MAXy,g10,C)

#------------------------------------------------------------------------------
# Figure 11: Mature Age Composition residuals.
#------------------------------------------------------------------------------
x<-as.data.frame(A$res_mat_comp)
x["Age4"]<-x$V1
x["Age5"]<-x$V2
x["Age6"]<-x$V3
x["Age7"]<-x$V4
x["Age8"]<-x$V5
x["Age9"]<-x$V6
x["Age10"]<-x$V7
x["Age11"]<-x$V8
x["Age12"]<-x$V9
y<-subset(FIGDATA, select=c(Year))
C <-cbind(x,y)
C<-subset(C, select=c(Year, Age4, Age5,Age6,Age7, Age8, Age9, Age10, Age11, Age12))
C<- melt(C, id=c("Year"), na.rm=TRUE)
C["Age"] <- ifelse(C$variable=="Age4","4", ifelse (C$variable=="Age5","5",
                                                   ifelse (C$variable=="Age6","6",
                                                           ifelse (C$variable=="Age7","7",
                                                                   ifelse (C$variable=="Age8","8",
                                                                           ifelse (C$variable=="Age9","9",
                                                                                   ifelse (C$variable=="Age10","10",    
                                                                           ifelse (C$variable=="Age11","11","12+"))))))))

C["FREQ"]<-C$value
C["Variable"]<-"Estimated"
C<-subset(C, select=c(Year,Age, FREQ, Variable))
C$Age <- factor(C$Age, levels=c("4", "5", "6", "7", "8", "9", "10","11", "12+"))
g11<-ggplot(data=C,aes(x=Age, y=FREQ, fill=Variable))+
     facet_wrap(~Year,nrow=7, ncol=6)+
     geom_bar(stat="identity", position="dodge")+
     theme_bw()+xlab ("Age")+
     ylab("Mature age composition residuals")+
     scale_fill_manual(values=c("#E69F00", "#0072B2"))+
     theme(legend.title=element_blank())+
     theme(text=element_text(family="Times New Roman", size=12))

g11<-g11+ theme(axis.text.x = element_text(size=10,colour="black", family="Times New Roman"),
        axis.title.x = element_text(size=14, colour="black", family="Times New Roman"))+
     theme(axis.text.y = element_text(size=12,colour="black", family="Times New Roman"),
        axis.title.y = element_text(size=14,colour="black" ,family="Times New Roman"))+
    theme(plot.title=element_text(size=rel(1.5),colour="black",vjust =1,family="Times New Roman" ))+
    theme(strip.text.x = element_text(size=14,face="bold", family="Times New Roman"))+theme(legend.position="none")+
    theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())

png(file='figures/Figure 11.png', res=200, width=10, height=9, units ="in")
pushViewport(viewport(layout=grid.layout(1,1)))
vplayout<-function(x,y) viewport (layout.pos.row=x, layout.pos.col=y)
print(g11,vp=vplayout(1,1:1))
dev.off() 
Figure_11_data<-C
rm(x,y,C,g11)

#------------------------------------------------------------------------------
# Figure 12: Catch Age Composition residuals.
#------------------------------------------------------------------------------
x<-as.data.frame(A$res_c_comp)
x["Age4"]<-x$V1
x["Age5"]<-x$V2
x["Age6"]<-x$V3
x["Age7"]<-x$V4
x["Age8"]<-x$V5
x["Age9"]<-x$V6
x["Age10"]<-x$V7
x["Age11"]<-x$V8
x["Age12"]<-x$V9
y<-subset(FIGDATA, select=c(Year))
C <-cbind(x,y)
C<-subset(C, select=c(Year, Age4, Age5,Age6,Age7, Age8, Age9, Age10, Age11, Age12))
C<- melt(C, id=c("Year"), na.rm=TRUE)
C["Age"] <- ifelse(C$variable=="Age4","4", ifelse (C$variable=="Age5","5",
                                                   ifelse (C$variable=="Age6","6",
                                                           ifelse (C$variable=="Age7","7",
                                                                   ifelse (C$variable=="Age8","8",
                                                                           ifelse (C$variable=="Age9","9",
                                                                                   ifelse (C$variable=="Age10","10",    
                                                                                           ifelse (C$variable=="Age11","11","12+"))))))))

C["FREQ"]<-C$value
C["Variable"]<-"Estimated"
C<-subset(C, select=c(Year,Age, FREQ, Variable))
C$Age <- factor(C$Age, levels=c("4", "5", "6", "7", "8", "9", "10","11", "12+"))
g12<-ggplot(data=C,aes(x=Age, y=FREQ, fill=Variable))+
  facet_wrap(~Year,nrow=7, ncol=6)+
  geom_bar(stat="identity", position="dodge")+
  theme_bw()+xlab ("Age")+
  ylab("Catch age composition residuals")+
  scale_fill_manual(values=c("#E69F00", "#0072B2"))+
  theme(legend.title=element_blank())+
  theme(text=element_text(family="Times New Roman", size=12))

g12<-g12+ theme(axis.text.x = element_text(size=10,colour="black", family="Times New Roman"),
                axis.title.x = element_text(size=14, colour="black", family="Times New Roman"))+
  theme(axis.text.y = element_text(size=12,colour="black", family="Times New Roman"),
        axis.title.y = element_text(size=14,colour="black" ,family="Times New Roman"))+
  theme(plot.title=element_text(size=rel(1.5),colour="black",vjust =1,family="Times New Roman" ))+
  theme(strip.text.x = element_text(size=14,face="bold", family="Times New Roman"))+theme(legend.position="none")+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())

png(file='figures/Figure 12.png', res=200, width=10, height=9, units ="in")
pushViewport(viewport(layout=grid.layout(1,1)))
vplayout<-function(x,y) viewport (layout.pos.row=x, layout.pos.col=y)
print(g12,vp=vplayout(1,1:1))
dev.off() 
Figure_12_data<-C
rm(x,y,C,g12)

#------------------------------------------------------------------------------
# Figure 13a: Spawning age composition figure for model analysis only.
#------------------------------------------------------------------------------

my.col <- colorRampPalette(brewer.pal(9,"RdYlGn"))

# THESE COMMANDS CAN BE RUN AND THE COLOR SCHEME MODIFIED; IF SO, THEN I'D
# RECOMMEND EXPLICITLY INCLUDING THE CODE AS WRITTEN SO THE MODS DON'T
# HAVE TO BE REDONE - KVK
#plot.table.helper.color <- edit(plot.table.helper.color)
#plot.table.helper.colorbar <- edit(plot.table.helper.colorbar)

x<-as.data.frame(A$res_mat_comp, round=4)
x<-round(x,4)
options(scipen=999)
x$Year<-FIGDATA$Year

temp<-as.matrix(x)

colnames(temp)<-c(paste('Age',4:11,sep=' '), "Age 12+","Year")
temp<-subset(temp,select=c("Year", "Age 4", "Age 5", "Age 6","Age 7","Age 8", "Age 9","Age 10","Age 11","Age 12+"))

# plot temp with colorbar, display Correlation in (top, left) cell
png(file='figures/Figure 13a.png', res=200, width=9, height=9, units ="in")
plot.table(temp, smain='Maturity Residuals', highlight = TRUE, colorbar = TRUE)

dev.off()
rm(x)

#------------------------------------------------------------------------------
# Figure 13b: Catch age composition figure for model analysis only.
#------------------------------------------------------------------------------
 my.col <- colorRampPalette(brewer.pal(9,"RdYlGn"))
# THESE COMMANDS CAN BE RUN AND THE COLOR SCHEME MODIFIED; IF SO, THEN I'D
# RECOMMEND EXPLICITLY INCLUDING THE CODE AS WRITTEN SO THE MODS DON'T
# HAVE TO BE REDONE - KVK
#plot.table.helper.color <- edit(plot.table.helper.color)
#plot.table.helper.colorbar <- edit(plot.table.helper.colorbar)

x<-as.data.frame(A$res_c_comp, round=4)
x<-round(x,4)
options(scipen=999)
x$Year<-FIGDATA$Year

temp<-as.matrix(x)

colnames(temp)<-c(paste('Age',4:11,sep=' '), "Age 12+","Year")
temp<-subset(temp,select=c("Year", "Age 4", "Age 5", "Age 6","Age 7","Age 8", "Age 9","Age 10","Age 11","Age 12+"))

# plot temp with colorbar, display Correlation in (top, left) cell
png(file='figures/Figure 13b.png', res=200, width=9, height=9, units ="in")
plot.table(temp, smain='Catch Residuals', highlight = TRUE, colorbar = TRUE)

dev.off()
# #################################################################################################################
# #SECTION III - OUTPUT FILES TO ONE EXCEL WORKBOOK & FORMAT
# #################################################################################################################
wb <- createWorkbook()         # create blank workbook
sheet1 <- createSheet(wb, sheetName="Figure 1")
sheet2 <- createSheet(wb, sheetName="Figure 2")
sheet3 <- createSheet(wb, sheetName="Figure 3")
sheet4 <- createSheet(wb, sheetName="Figure 4")
sheet5 <- createSheet(wb, sheetName="Figure 5")
sheet6 <- createSheet(wb, sheetName="Figure 6")
sheet7 <- createSheet(wb, sheetName="Figure 7") 
sheet8 <- createSheet(wb, sheetName="Figure 8")
sheet9 <- createSheet(wb, sheetName="Figure 9")
sheet10 <- createSheet(wb, sheetName="Figure 10")
sheet11 <- createSheet(wb, sheetName="Figure 11")
sheet12 <- createSheet(wb, sheetName="Figure 12")
sheet13 <- createSheet(wb, sheetName="Figure 13")

setColumnWidth(sheet1, colIndex=1:40, colWidth=20)
setColumnWidth(sheet2, colIndex=1:40, colWidth=20)
setColumnWidth(sheet3, colIndex=1:40, colWidth=20)
setColumnWidth(sheet4, colIndex=1:40, colWidth=20)
setColumnWidth(sheet5, colIndex=1:40, colWidth=20)
setColumnWidth(sheet6, colIndex=1:40, colWidth=20)
setColumnWidth(sheet7, colIndex=1:40, colWidth=20)
setColumnWidth(sheet8, colIndex=1:40, colWidth=20)
setColumnWidth(sheet9, colIndex=1:40, colWidth=20)
setColumnWidth(sheet10, colIndex=1:40, colWidth=20)
setColumnWidth(sheet11, colIndex=1:40, colWidth=20)
setColumnWidth(sheet12, colIndex=1:40, colWidth=20)
setColumnWidth(sheet13, colIndex=1:40, colWidth=20)
# 
rows <- createRow(sheet4,rowIndex=51)
sheetTitle <- createCell(rows, colIndex=1)
setCellValue(sheetTitle[[1,1]], "Figure 4b and 4c: Spawning population abundance (blue bars;top figure; tot_sp_N), population abundance (immature and spawning abundance) (blue bars;bottom figure; tot_post_N), and")
csSheetTitle <- CellStyle(wb) + Font(wb,isBold=FALSE, heightInPoints=12, name="Cambria")
setCellStyle(sheetTitle[[1,1]], csSheetTitle)

rows <- createRow(sheet4,rowIndex=52)
sheetTitle <- createCell(rows, colIndex=1)
setCellValue(sheetTitle[[1,1]], "commercial fishery harvest (yellow bars) over time. The combination of the blue and yellow bars (total height of each bar) is the mature population abundance (tot_mat_N),")
csSheetTitle <- CellStyle(wb) + Font(wb,isBold=FALSE, heightInPoints=12, name="Cambria")
setCellStyle(sheetTitle[[1,1]], csSheetTitle)

rows <- createRow(sheet4,rowIndex=53)
sheetTitle <- createCell(rows, colIndex=1)
setCellValue(sheetTitle[[1,1]], " or total population abundance (N).")
csSheetTitle <- CellStyle(wb) + Font(wb,isBold=FALSE, heightInPoints=12, name="Cambria")
setCellStyle(sheetTitle[[1,1]], csSheetTitle)
cs1 <- CellStyle(wb) + Font(wb, heightInPoints=10, name="Cambria") +
  Alignment(h="ALIGN_CENTER")
addDataFrame(Figure_1_data, sheet1, startRow=1, startColumn=7,row.names=FALSE, colnamesStyle=cs1, rownamesStyle=cs1, colStyle=cs1)
addDataFrame(Figure_2_data, sheet2, startRow=1, startColumn=7,row.names=FALSE, colnamesStyle=cs1, rownamesStyle=cs1, colStyle=cs1)
addDataFrame(Figure_3_data, sheet3, startRow=1, startColumn=8,row.names=FALSE, colnamesStyle=cs1, rownamesStyle=cs1, colStyle=cs1)
addDataFrame(Figure_4_data, sheet4, startRow=1, startColumn=10,row.names=FALSE, colnamesStyle=cs1, rownamesStyle=cs1, colStyle=cs1)
addDataFrame(Figure_5a_data, sheet5, startRow=1, startColumn=8,row.names=FALSE, colnamesStyle=cs1, rownamesStyle=cs1, colStyle=cs1)
addDataFrame(Figure_5b_data, sheet5, startRow=1, startColumn=11,row.names=FALSE, colnamesStyle=cs1, rownamesStyle=cs1, colStyle=cs1)
addDataFrame(Figure_5c_data, sheet5, startRow=1, startColumn=14,row.names=FALSE, colnamesStyle=cs1, rownamesStyle=cs1, colStyle=cs1)
addDataFrame(Figure_6_data, sheet6, startRow=1, startColumn=8,row.names=FALSE, colnamesStyle=cs1, rownamesStyle=cs1, colStyle=cs1)
addDataFrame(Figure_7_data, sheet7, startRow=1, startColumn=8,row.names=FALSE, colnamesStyle=cs1, rownamesStyle=cs1, colStyle=cs1)
addDataFrame(Figure_8_data, sheet8, startRow=1, startColumn=6,row.names=FALSE, colnamesStyle=cs1, rownamesStyle=cs1, colStyle=cs1)
addDataFrame(Figure_9_data, sheet9, startRow=1, startColumn=6,row.names=FALSE, colnamesStyle=cs1, rownamesStyle=cs1, colStyle=cs1)
addDataFrame(Figure_10_data, sheet10, startRow=1, startColumn=6,row.names=FALSE, colnamesStyle=cs1, rownamesStyle=cs1, colStyle=cs1)
addDataFrame(Figure_11_data, sheet11, startRow=1, startColumn=8,row.names=FALSE, colnamesStyle=cs1, rownamesStyle=cs1, colStyle=cs1)
addDataFrame(Figure_12_data, sheet12, startRow=1, startColumn=8,row.names=FALSE, colnamesStyle=cs1, rownamesStyle=cs1, colStyle=cs1)

# 
# #replace with correct stock
addPicture("Figure 1.png", sheet1, startRow=1, startColumn=1)
addPicture("Figure 2.png", sheet2, startRow=1, startColumn=1)
addPicture("Figure 3.png", sheet3, startRow=1, startColumn=1)
addPicture("Figure 4.png", sheet4, startRow=1, startColumn=1)
addPicture("Figure 5a.png", sheet5, startRow=1, startColumn=1)
addPicture("Figure 5b.png", sheet5, startRow=36, startColumn=1)
addPicture("Figure 5c.png", sheet5, startRow=71, startColumn=1)
addPicture("Figure 6.png", sheet6, startRow=1, startColumn=1)
addPicture("Figure 7.png", sheet7, startRow=1, startColumn=1)
addPicture("Figure 8.png", sheet8, startRow=1, startColumn=1)
addPicture("Figure 9a.png", sheet9, startRow=1, startColumn=1)
addPicture("Figure 9b.png", sheet9, startRow=22, startColumn=1)
addPicture("Figure 10.png", sheet10, startRow=1, startColumn=1)
addPicture("Figure 11.png", sheet11, startRow=1, startColumn=1)
addPicture("Figure 12.png", sheet12, startRow=1, startColumn=1)
addPicture("Figure 13a.png", sheet13, startRow=1, startColumn=1)
addPicture("Figure 13b.png", sheet13, startRow=46, startColumn=1)
# 
# 
 saveWorkbook(wb, "Figures and Data (Togiak Stock).xlsx")
# #remove unneeded files from H drive






