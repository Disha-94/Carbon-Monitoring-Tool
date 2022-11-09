setwd("/web/data/Test/All_Files")
rm_test = "rm -r /web/data/Test/All_Files/*"
system(rm_test)
args <- commandArgs(trailingOnly = TRUE)
a <- args[1]
b <- args[2]

print(paste0(a,b))
dwn1 = paste0("curl -J 'https://daymet.ornl.gov/single-pixel/api/data?lat=",a,"&lon=",b,"&vars=tmax,tmin&start=2010-01-01&end=2019-12-31' -O")
system(dwn1)
l = list.files()[1]
rename1 = paste0("mv ",l," tmin_tmax_daymet.csv")
system(rename1)
dwn2 = paste0("curl -J 'https://daymet.ornl.gov/single-pixel/api/data?lat=",a,"&lon=",b,"&vars=prcp&start=2010-01-01&end=2019-12-31' -O")
system(dwn2)
l = list.files()[1]
rename2 = paste0("mv ",l," prcp.csv")
system(rename2)
dwn3 = paste0("curl -J 'https://daymet.ornl.gov/single-pixel/api/data?lat=",a,"&lon=",b,"&vars=srad&start=2010-01-01&end=2019-12-31' -O")
system(dwn3)
l = list.files()[1]
rename3 = paste0("mv ",l," srad.csv")
system(rename3)


rmfiles = list.files()

for (i in rmfiles){
	delfiles = paste0("sed -i '1,7d' ",i)
	system(delfiles)
}


#Tempareture
set.seed(1323)
rm(list=ls())
library(RMAWGEN)
data(trentino)
set.seed(1222)

library(doMC)
library(parallel)

registerDoMC(50)

year_min <- 2017
year_max <- 2018
year_min_sim <- 2019
year_max_sim <- 2019
n_GPCA_iter <- 5
n_GPCA_iteration_residuals <- 5
p <- 1



vstation <- c("Test")
for(v in 1:1000){
  nums = paste0("Test",v)
  vstation <- append(vstation, nums)
}

default <- read.csv(file = '/web/data/Test/default_2000_2009.csv', stringsAsFactors = TRUE)
month <- default$month
day <- default$day

setwd("/web/data/Test/All_Files")
lst = 'tmin_tmax.csv'


gpath <- paste0("/web/data/Test/All_Files/tmin_tmax_daymet.csv")
print("1")
minpath <- paste0("/web/data/Test/All_Files/tmin.csv")
maxpath <- paste0("/web/data/Test/All_Files/tmax.csv")
print("2")
tmp <- c()
tmp <- read.csv(file = gpath, stringsAsFactors = TRUE)
print("3")
print(tail(tmp))
tmp$day <- day
tmp$month <- month
print("4")
final_tmax <- tmp[,c(5,6,1,3)]
final_tmin <- tmp[,c(5,6,1,4)]
names(final_tmax)[names(final_tmax) == 'tmax..deg.c.'] <- 'temp'
names(final_tmin)[names(final_tmin) == 'tmin..deg.c.'] <- 'temp'
print("5")	

#generating Tmax and Tmin values and saving them in a dataframe 
tmin_out <- data.frame(matrix(ncol = 1, nrow = 365))
tmax_out <- data.frame(matrix(ncol = 1, nrow = 365))
for(v in 1:1){
  np = paste0("temp")
  generation00 <-ComprehensiveTemperatureGenerator(station="temp",Tx_all=final_tmax,Tn_all=final_tmin,year_min=year_min,year_max=year_max,p=p,n_GPCA_iteration=n_GPCA_iter,n_GPCA_iteration_residuals=n_GPCA_iteration_residuals,sample="monthly",year_min_sim=year_min_sim,year_max_sim=year_max_sim)
  tmin_out[np] <- generation00$output$Tn_gen
  tmax_out[np] <- generation00$output$Tx_gen
}

tmin_out$matrix.ncol...1..nrow...365. <- NULL
tmax_out$matrix.ncol...1..nrow...365. <- NULL

print("6")

write.csv(tmin_out, file = minpath)
write.csv(tmax_out, file = maxpath)



#precipitation
set.seed(1323)
year_min <- 2010
year_max <- 2018

year_min_sim <- 2019
year_max_sim <- 2019

n_GPCA_iter <- 5 
n_GPCA_iteration_residuals <- 5
p <- 1
nscenario=0

station <- c("prcp","prcp")

default <- read.csv(file = '/web/data/Test/default_2000_2009.csv', stringsAsFactors = TRUE)
month <- default$month
day <- default$day

setwd("/web/data/Test/All_Files/")


gpath <- paste0("/web/data/Test/All_Files/prcp.csv")
print("1")
spath <- paste0("/web/data/Test/All_Files/prcp_pred.csv")
print("2")
tmp <- c()
tmp <- read.csv(file = gpath, stringsAsFactors = TRUE)
print("3")
print(tail(tmp))
tmp$day <- day
tmp$month <- month
print("4")
final <- tmp[,c(4,5,1,3)]
names(final)[names(final) == 'prcp..mm.day.'] <- 'prcp'
print("5")	
generation01<-ComprehensivePrecipitationGenerator(station=station,prec_all=final,year_min=year_min,year_max=year_max,year_min_sim=year_min_sim,year_max_sim=year_max_sim,p=p,n_GPCA_iteration=n_GPCA_iter,n_GPCA_iteration_residuals=0,sample="monthly",nscenario=nscenario,no_spline=TRUE)
print("6")
prcp_predict = generation01$prec_gen[1]
write.csv(generation01$prec_gen[1], file = spath)




#short wave radiation 
set.seed(1323)
year_min <- 2010
year_max <- 2018

year_min_sim <- 2019
year_max_sim <- 2019

n_GPCA_iter <- 5 
n_GPCA_iteration_residuals <- 5
p <- 1
nscenario=0
station <- c("srad","srad")

default <- read.csv(file = '/web/data/Test/default_2000_2009.csv', stringsAsFactors = TRUE)
month <- default$month
day <- default$day

setwd("/web/data/Test/All_Files/")

gpath <- paste0("/web/data/Test/All_Files/srad.csv")
print("1")
spath <- paste0("/web/data/Test/All_Files/srad_pred.csv")
print("2")
tmp <- c()
tmp <- read.csv(file = gpath, stringsAsFactors = TRUE)
print("3")
print(tail(tmp))
tmp$day <- day
tmp$month <- month
print("4")
final <- tmp[,c(4,5,1,3)]
names(final)[names(final) == 'srad..W.m.2.'] <- 'srad'
print("5")	
generation01<-ComprehensivePrecipitationGenerator(station=station,prec_all=final,year_min=year_min,year_max=year_max,year_min_sim=year_min_sim,year_max_sim=year_max_sim,p=p,n_GPCA_iteration=n_GPCA_iter,n_GPCA_iteration_residuals=0,sample="monthly",nscenario=nscenario,no_spline=TRUE)
print("6")
a = generation01$prec_gen[1]
srad_predict = (a*300)/5000
write.csv(srad_predict, file = spath)



finRes <- c(tail(srad_predict,280),tail(tmax_out,280),tail(tmin_out,280), tail(prcp_predict,280))
fin_path <- paste0("/web/data/Test/All_Files/final_values.csv")
write.csv(finRes, file = fin_path)

