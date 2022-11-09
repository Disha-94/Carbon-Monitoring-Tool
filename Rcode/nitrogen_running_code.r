#Update fertilizer rates in management file
setwd("/web/data/runsNew/KSOKruns/")
rates=c(1, 5, 15,30,45,60,75,90,105,120,135,150,165,180,195,210,225,240)# #rates=c(15,30,45,60)
args <- commandArgs(trailingOnly = TRUE)
weatherTable=read.csv('/web/data/runsNew/KSOKruns/Weather.csv')
# nam= 28843523
nam = strtoi(args[1], base=0L)
rotation="cntwht" #three rotations cntwht, whtfl, whtsgfl
# planting="10/25"
planting = args[2]
# fertpl=10
fertpl = strtoi(args[3], base=0L)
mnth=substr(planting, 1,2)
day=substr(planting, 4,5)
# simls=c("March2019")
simls = args[4]
price=4
price = strtoi(args[5], base=0L)
price1=36.76*price
# Nprice=0.35
Nprice = strtoi(args[6], base=0L)
Nprice1=Nprice*2.205

#rates=c(15,30,45,60)
# weatherTable=read.csv('/web/data/runsNew/KSOKruns/Weather.csv')
# nam= 33082006
# rotation="cntwht" #three rotations cntwht, whtfl, whtsgfl
# planting="10/25"
# fertpl=10
# mnth=substr(planting, 1,2)
# day=substr(planting, 4,5)
# simls=c("March2019")
# price=4
# price1=36.76*price
# Nprice=0.35
# Nprice1=Nprice*2.205

years=c(2002:2017)
#Preprocessing
td=NULL
if (simls=="March2019"){
con = file('/web/data/runsNew/KSOKruns/EPICRUN.DAT',open =  'w')
text = sprintf('%10d%10d%10d%6d%6d%10d%10d%10d  0   0  25   1995   10.00   2.50  2.50  0.1' , nam , nam, nam, 0, 1, nam, 1, nam)
writeLines(text, con)
close(con)
} else {
con = file('/web/data/runsNew/KSOKruns/EPICRUN.DAT',open =  'w')
text = sprintf('%10d%10d%10d%6d%6d%10d%10d%10d  0   0  25   1996   10.00   2.50  2.50  0.1' , nam , nam, nam, 0, 1, nam, 1, nam)
writeLines(text, con)
close(con)
}
for (yr in years){
 template=readLines('/web/data/runsNew/KSOKruns/ieWedlst.DAT')
 id <- grep(pattern = nam, x = template)
 whrId=subset(weatherTable, weatherTable$pid==nam)
 file=paste0(nam,  '   "../../common_inputfiles/',simls,'/2019/',whrId$climate, '.DLY"')
  template[id]=file
 con = file('ieWedlst.DAT',open =  'w')
 writeLines(template, con)
 close(con)
 #Creating new daily weather file
widths = c(6, 4, 4, rep(6, times = 6))
wead = read.fwf(paste0("/web/data/common_inputfiles/", simls, "/2019/",whrId$climate,".DLY"), header = FALSE, widths = widths)
st=which(wead$V1==yr&wead$V2==3&wead$V3==27)
en=which(wead$V1==yr&wead$V2==12&wead$V3==31)
sub=wead[st:en,]
en=which(wead$V1==yr&wead$V2==12&wead$V3==31)
sub=wead[st:en,]
newWeatherFile <- read.csv(file = '/web/data/Test/All_Files/final_values.csv', stringsAsFactors = TRUE)
sub$V4 = newWeatherFile$srad
sub$v5 = newWeatherFile$temp
sub$V6 = newWeatherFile$temp.1
sub$V7 = newWeatherFile$prcp
if(simls=="March2019"){
sub$V1=2019
wead[13965:14244,]=sub #March2019
} else {
sub$V1=2020
wead[14331:14610,]=sub #March2020
}
con = file(paste0('/web/data/common_inputfiles/',simls,'/2019/',whrId$climate,'.DLY'),open =  'w')
text = sapply(1:nrow(wead), function(cur_row){
      sprintf("  %4d%4d%4d%6.1f%6.1f%6.1f%6.1f%6.1f%6.1f", 
              wead[cur_row,1], wead[cur_row, 2], wead[cur_row, 3],
              wead[cur_row, 4], wead[cur_row, 5], wead[cur_row, 6],
              wead[cur_row, 7], wead[cur_row, 8], wead[cur_row, 9] )
    })
  writeLines(text, con)
  close(con)

for (r in rates) {
 for (n in nam){
 if (rotation=="cntwht"){
  template=readLines('/web/data/runsNew/KSOKruns/opc/CntWht.OPC')
  substr(template[188], 5, 9)=sprintf('%2s%3s', mnth, day)
  substr(template[189], 5, 9)=sprintf('%2s%3s', mnth, day)
  substr(template[191], 30, 37)=sprintf('%8.3f', r)
  if (fertpl==0){
  substr(template[188], 30, 37)=sprintf('%8.3f', 0.2)
       } else {
  substr(template[188], 30, 37)=sprintf('%8.3f', fertpl)
	   }
   con = file(paste0('/web/data/runsNew/KSOKruns/opc/CntWht.OPC'),open =  'w')
   writeLines(template, con)
   close(con)
#Modifying ieOp file   
 template=readLines('/web/data/runsNew/KSOKruns/ieOplist.DAT')
 file=paste0(1,  '   "opc/CntWht.OPC"')
  template[1]=file
 con = file('ieOplist.DAT',open =  'w')
 writeLines(template, con)
 close(con)
 } else if (rotation=="whtfl"){
  template=readLines('/web/data/runsNew/KSOKruns/opc/WhtFall.OPC')
  substr(template[133], 5, 9)=sprintf('%2s%3s', mnth, day)
  substr(template[134], 5, 9)=sprintf('%2s%3s', mnth, day)
  substr(template[136], 30, 37)=sprintf('%8.3f', r)
  if (fertpl==0){
  substr(template[133], 30, 37)=sprintf('%8.3f', 0.2)
       } else {
  substr(template[133], 30, 37)=sprintf('%8.3f', fertpl)
	   }
   con = file(paste0('/web/data/runsNew/KSOKruns/opc/WhtFall.OPC'),open =  'w')
   writeLines(template, con)
   close(con)
#Modifying ieOp file   
 template=readLines('/web/data/runsNew/KSOKruns/ieOplist.DAT')
 file=paste0(1,  '   "opc/WhtFall.OPC"')
  template[1]=file
 con = file('ieOplist.DAT',open =  'w')
 writeLines(template, con)
 close(con)
 } else {
  template=readLines('/web/data/runsNew/KSOKruns/opc/WhtFallSrg.OPC')
  substr(template[153], 5, 9)=sprintf('%2s%3s', mnth, day)
  substr(template[154], 5, 9)=sprintf('%2s%3s', mnth, day)
  substr(template[156], 30, 37)=sprintf('%8.3f', r)
  if (fertpl==0){
  substr(template[153], 30, 37)=sprintf('%8.3f', 0.2)
       } else {
  substr(template[153], 30, 37)=sprintf('%8.3f', fertpl)
	   }
   con = file(paste0('/web/data/runsNew/KSOKruns/opc/WhtFallSrg.OPC'),open =  'w')
   writeLines(template, con)
   close(con)
 #Modifying ieOp file   
 template=readLines('/web/data/runsNew/KSOKruns/ieOplist.DAT')
 file=paste0(1,  '   "opc/WhtFallSrg.OPC"')
  template[1]=file
 con = file('ieOplist.DAT',open =  'w')
 writeLines(template, con)
 close(con)
 }

#running the model
#system("EPIC1102_20180413.exe")
system("/web/data/runsNew/KSOKruns/EPIC1102Versions_20201015")
#post processing
widths = c(5, 5, 5, 9, rep(9, times = 35))
data = read.fwf(paste0("/web/data/runsNew/KSOKruns/",n,".ACY"), skip = 11, header = FALSE, widths = widths)

if (rotation=="cntwht"){
ds=data.frame(trt=paste0(r),rep=paste0(yr), yld=data[48,4])
} else if (rotation=="whtfl"){
ds=data.frame(trt=paste0(r),rep=paste0(yr), yld=data[26,4])
} else {
ds=data.frame(trt=paste0(r),rep=paste0(yr), yld=data[26,4])
}
td=rbind(td,ds)
 }
}
}
#write.csv(td, "nitrogenlevels.csv")
options(scipen=999)
td$yld=td$yld*1.30
options(scipen=999)
x=rep(1:length(years), times=18)
x1=x[order(x)]
x1=paste0("ensmb",x1)
td$rep=x1
td$trt=c(0, 5, 15,30,45,60,75,90,105,120,135,150,165,180,195,210,225,240)
library(ggplot2)
library(tidyr)
wide_td <- td %>% spread(rep, yld) 

#BoxPlot#
png(paste0("/web/data/nitrogen_recommendation_tool/react_leaflet/public/Nitrogen_Results/boxplot.png"),width = 1000, height = 900)
par( mar=c(4.7, 4.7, 2.3, 1.5)) # parameters for margins for four sides (1=bottom, 2=left, 3=top and 4=right)
new_order=factor(td$trt, levels=unique(td$trt))
means <- aggregate(yld ~  trt, td, mean)
boxplot(td$yld ~ new_order , ylab="Yields(Mg/ha)" ,xlab="Nitrogen rate (Kg/ha)", col="#2c7370", cex.axis=1.8, cex.lab=2.3, boxwex=0.4 , main="")
points(1:18, means$yld, col="darkred", pch=18)
dev.off()

#mode function
getmode <- function(v) {
   uniqv <- unique(v)
   uniqv[which.max(tabulate(match(v, uniqv)))]
}

#Pearson distribution
library(PearsonDS)
len=1:18
skw=NULL
for (ln in len){
x=as.numeric(wide_td[ln,-1]) #extract row of n rate and use as.numeric to convert to vector
moments=empMoments(x)
sko=data.frame(trt=wide_td$trt[ln],mean=moments[1], skew=moments[3], var=moments[2], mode=getmode(x), sd=sqrt(abs(moments[2])))
skw=rbind(skw,sko)
}

#plot mean vs standard deviation, scale_colour_gradient2(),scale_colour_gradientn(colours = terrain.colors(5))
png(paste0("/web/data/nitrogen_recommendation_tool/react_leaflet/public/Nitrogen_Results/var_sd.png"),width = 1000, height = 1000)
ggplot(skw, aes(sd, mean)) +
  geom_point(size = 6, aes(colour = trt)) +
 scale_color_gradient(low = "green", high = "orange")   +
  labs(x = "Standard Deviation (Mg/ha)", y = "Mean Yield (Mg/ha)") + theme_bw() +
  theme(legend.position = "top", legend.text = element_text(size = 20),
        legend.title = element_text(size = 22)) +
        	theme_grey(base_size = 24)
dev.off()
####################################################
####################################################
#Return to Nitrogen (RTN)#
#Wheat price - 4$/bushel (27.2 kg/bushel so 1 Mg - 1000/27.2*4 = $147/Mg
#Nitrogen price - $0.35/lb ($0.77/kg)
#RTN=change in yield from zero N *147 - N rate*0.77
td1=subset(td, td$trt==0)
td2=subset(td, td$trt!=0)
tn=NULL
reps=unique(td$rep)
for (rp in reps){
tdyr1=subset(td1, td1$rep==rp)
tdyr2=subset(td2, td2$rep==rp)
tdyr2$ychng=tdyr2$yld-tdyr1$yld
tdyr2$rtn=(tdyr2$ychng*price1)-(tdyr2$trt*Nprice1)
tn=rbind(tn,tdyr2)
}
tn1=tn[c(1,2,5)]
wide_tn <- tn1 %>% spread(rep, rtn) 
png(paste0("/web/data/nitrogen_recommendation_tool/react_leaflet/public/Nitrogen_Results/boxplotRTN.png"),width = 1000, height = 900)
par( mar=c(4.7, 4.7, 2.3, 1.5)) # parameters for margins for four sides (1=bottom, 2=left, 3=top and 4=right)
new_order=factor(tn$trt, levels=unique(tn$trt))
means <- aggregate(rtn ~  trt, tn, mean)
boxplot(tn$rtn ~ new_order , ylab="Return to Nitrogen (RTN) ($)" ,xlab="Nitrogen rate (Kg/ha)", col="#33732c", cex.axis=1.8, cex.lab=2.3, boxwex=0.4 , main="")
points(1:17, means$rtn, col="darkred", pch=16)
dev.off()

#Pearson distribution
library(PearsonDS)
len=1:17
skwRN=NULL
for (ln in len){
x=as.numeric(wide_tn[ln,-1]) #extract row of n rate and use as.numeric to convert to vector
moments1=empMoments(x)
sko=data.frame(trt=wide_tn$trt[ln],mean=moments1[1], skew=moments1[3], var=moments1[2], mode=getmode(x), sd=sqrt(abs(moments1[2])))
skwRN=rbind(skw,sko)
}

#plot mean vs standard deviation, scale_colour_gradient2(),scale_colour_gradientn(colours = terrain.colors(5))
png(paste0("/web/data/nitrogen_recommendation_tool/react_leaflet/public/Nitrogen_Results/var_sdRN.png"),width = 1000, height = 1000)
ggplot(skwRN, aes(sd, mean)) +
  geom_point(size = 6, aes(colour = trt)) +
 scale_color_gradient(low = "green", high = "orange")   +
  labs(x = "Standard Deviation (Mg/ha)", y = "Mean Yield (Mg/ha)") + theme_bw() +
  theme(legend.position = "top", legend.text = element_text(size = 20),
        legend.title = element_text(size = 22)) +
        	theme_grey(base_size = 24)
dev.off()

skw$rtn=skw$mean*price1
skw$sd1=skw$sd*price1
skw$retrn=skw$mean-(skw$trt*(Nprice1/price1))
skw$rtn=skw$mean*price1
cfn=NULL
Nrate=NULL
Nrate1=NULL
cfn1=NULL
for (b in 1:6)
{
cf=(1*skw$rtn)-(b*skw$sd1)
cf1=(1*skw$retrn)-(b*skw$sd)
frm=data.frame(trt=skw$trt,m=b,cf=cf)
frm1=data.frame(trt=skw$trt,m=b,cf=cf1)
mx=which(cf==max(cf))
mx1=which(cf1==max(cf1))
rate=data.frame(Nitrogen_Rate=skw[mx,1],Risk_Tolerance_Level=b,Criterion_Function=cf[mx])
rate1=data.frame(Nitrogen_Rate=skw[mx1,1],Risk_Tolerance_Level=b,Criterion_Function=cf1[mx1])
cfn=rbind(cfn,frm)
cfn1=rbind(cfn1,frm1)
Nrate=rbind(Nrate,rate)
Nrate1=rbind(Nrate1,rate1)
}
write.csv(Nrate, paste0('/web/data/nitrogen_recommendation_tool/react_leaflet/public/Nitrogen_Results/RiskNrate.csv'))
library(gridExtra)
png("/web/data/nitrogen_recommendation_tool/react_leaflet/public/Nitrogen_Results/RiskNrate.png", height = 25*nrow(Nrate), width = 125*ncol(Nrate))
grid.table(Nrate)
dev.off()
write.csv(Nrate1, paste0('/web/data/nitrogen_recommendation_tool/react_leaflet/public/Nitrogen_Results/RiskNrate_new.csv'))
png("/web/data/nitrogen_recommendation_tool/react_leaflet/public/Nitrogen_Results/RiskNrate_new.png", height = 25*nrow(Nrate1), width = 125*ncol(Nrate1))
grid.table(Nrate1)
dev.off()
cfn$m=as.character(cfn$m)
cfn1$m=as.character(cfn1$m)

p=ggplot(cfn, aes(trt, cf, colour = m, linetype=m, shape=m)) + geom_line() + 
               geom_point() + xlab('Nitrogen rate (kg/ha)') + ylab('Criterion function')+
			    labs (title='Assessment of Risk Tolerance')  + labs(fill = "Risk tolerance")
			 
ggsave(paste0('/web/data/nitrogen_recommendation_tool/react_leaflet/public/Nitrogen_Results/Criterion.png'), p, device = "png", dpi = 200)


p1=ggplot(cfn1, aes(trt, cf, colour = m, linetype=m, shape=m)) + geom_line() + 
               geom_point() + xlab('Nitrogen rate (kg/ha)') + ylab('Criterion function')+
			    labs (title='Assessment of Risk Tolerance')  + labs(fill = "Risk tolerance")
			 
ggsave(paste0('/web/data/nitrogen_recommendation_tool/react_leaflet/public/Nitrogen_Results/Criterion_new.png'), p1, device = "png", dpi = 200)





