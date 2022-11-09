library('raster')
opath = '/gpfs/data1/cmongp/pridhviM/HLS/Data'
setwd(opath)

fyr <- c('2015', '2016', '2017', '2018', '2019', '2020' )
# fyr <- c('2019', '2020' )

fpL30 <- c()
fpS30 <- c()

flist = list.files()
for (val in flist){
	fpath=paste0('/gpfs/data1/cmongp/pridhviM/HLS/Data/',val)
	for(yr in fyr){
		finL30 = paste0(fpath,"/",yr,'/L30')
		finS30 = paste0(fpath,"/",yr,'/S30')
		fpL30 <- c(fpL30, finL30)
		fpS30 <- c(fpS30, finS30)
	}
}

print(fpL30)
print(fpS30)


for(i in fpL30){
	setwd(i)
    inlist = list.files(pattern='*_ndvi.tif')
    rm = 'rm -r corn'
    system(rm)
    mk = 'mkdir corn'
    system(mk)
    print(inlist[1])
    l = raster(inlist[1])
    xmin = extent(l)[1]
    xmax = extent(l)[2]
    ymin = extent(l)[3]
    ymax = extent(l)[4]
    yr = substr(i, 44,47)
    # yr = substr(i, 45,48)
    print(yr)
    ex_cdl = paste0("gdalwarp -tr 30 -30 -te  " , xmin , " " , ymin , " " , xmax , " " ,ymax , " -t_srs '+proj=utm +zone=14 +ellps=WGS84 +units=m +no_defs' /gpfs/data1/cmongp/pridhviM/CDL/CDL_",yr,"_19.tif " , i ,"/corn/CDL_",yr,".tif")
    print(ex_cdl)
    system(ex_cdl)
    cpath = paste0(i,'/corn/CDL_',yr,'.tif')
	for(f in inlist){
        fName = paste0(substr(f, 1,18),"_corn")
        corn_run = paste0("gdal_calc.py -A ", f, " -B ",cpath," --outfile ", i,"/corn/",fName, ".tif"," --calc='A*(B==1)' --NoDataValue=0")
        print(corn_run)
        system(corn_run)
    }
}

for(i in fpS30){
	setwd(i)
    inlist = list.files(pattern='*_ndvi.tif')
    mk = 'mkdir corn'
    system(mk)
    l = raster(inlist[1])
    xmin = extent(l)[1]
    xmax = extent(l)[2]
    ymin = extent(l)[3]
    ymax = extent(l)[4]
    yr = substr(i, 44,47)
    # yr = substr(i, 45,48)
    ex_cdl = paste0("gdalwarp -tr 30 -30 -te  " , xmin , " " , ymin , " " , xmax , " " ,ymax , " -t_srs '+proj=utm +zone=14 +ellps=WGS84 +units=m +no_defs' /gpfs/data1/cmongp/pridhviM/CDL/CDL_",yr,"_19.tif " , i ,"/corn/CDL_",yr,".tif")
    print(ex_cdl)
    system(ex_cdl)
    cpath = paste0(i,'/corn/CDL_',yr,'.tif')
	for(f in inlist){
        fName = paste0(substr(f, 1,18),"_corn")
        corn_run = paste0("gdal_calc.py -A ", f, " -B ",cpath," --outfile ", i,"/corn/",fName, ".tif"," --calc='A*(B==1)' --NoDataValue=0")
        system(corn_run)
    }
}

