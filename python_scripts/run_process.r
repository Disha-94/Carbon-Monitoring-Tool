library(parallel)
library(doMC)
registerDoMC(45)

opath = '/gpfs/data1/cmongp/pridhviM/HLS/sample'
setwd(opath)
# mk = 'mkdir trash'
# rm = 'mv *.hdr trash/'

fyr <- c('2015', '2016', '2017', '2018', '2019', '2020', '2021' )
# fyr <- c('2019', '2020' )

fpL30 <- c()
fpS30 <- c()

flist = list.files()
for (val in flist){
	fpath=paste0('/gpfs/data1/cmongp/pridhviM/HLS/sample/',val)
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
	print(i)
	setwd(i)
	mk = 'mkdir trash'
	rm = 'mv *.hdr trash/'
	system(mk)
	system(rm)
	inlist = list.files(pattern='*.hdf')
	for(f in inlist){
		st = f
		nameB5=paste0("L30_",substr(st, 9,14),"_",substr(st, 16,22),"_B5.tif")
		nameB4=paste0("L30_",substr(st, 9,14),"_",substr(st, 16,22),"_B4.tif")
		nameB6=paste0("L30_",substr(st, 9,14),"_",substr(st, 16,22),"_B6.tif")
		nameB7=paste0("L30_",substr(st, 9,14),"_",substr(st, 16,22),"_B7.tif")
		namendvi=paste0("L30_",substr(st, 9,14),"_",substr(st, 16,22),"_ndvi.tif")
		namendti=paste0("L30_",substr(st, 9,14),"_",substr(st, 16,22),"_ndti.tif")
		B4=paste0('gdal_translate -of GTiff HDF4_EOS:EOS_GRID:"',st,'":Grid:band04 ',nameB4)
		print(B4)
		system(B4)
		B5=paste0('gdal_translate -of GTiff HDF4_EOS:EOS_GRID:"',st,'":Grid:band05 ',nameB5)
		print(B5)
		system(B5)
		B6=paste0('gdal_translate -of GTiff HDF4_EOS:EOS_GRID:"',st,'":Grid:band06 ',nameB6)
		print(B6)
		system(B6)
		B7=paste0('gdal_translate -of GTiff HDF4_EOS:EOS_GRID:"',st,'":Grid:band07 ',nameB7)
		print(B7)
		system(B7)
		#ndvi code for landsat
		ndvi=paste0("gdal_calc.py -A ", nameB5, " -B ", nameB4," --outfile=",namendvi, " --calc='((A.astype(float32)-B)/(A.astype(float32)+B))*10000' --NoDataValue=0")
		print(ndvi)
		system(ndvi, intern=TRUE)
		#ndti code for landsat
		ndti=paste0("gdal_calc.py -A ", nameB6, " -B ", nameB7," --outfile=",namendti, " --calc='((A.astype(float32)-B)/(A.astype(float32)+B))*10000' --NoDataValue=0")
		print(ndti)
		system(ndti, intern=TRUE)
	}
}

for(i in fpS30){
	setwd(i)
	mk = 'mkdir trash'
	rm = 'mv *.hdr trash/'
	system(mk)
	system(rm)
	inlist = list.files(pattern='*.hdf')
	for(f in inlist){
		st = f
		nameB8A=paste0("S30_",substr(st, 9,14),"_",substr(st, 16,22),"_8A.tif")
		nameB4=paste0("S30_",substr(st, 9,14),"_",substr(st, 16,22),"_B4.tif")
		nameB11=paste0("S30_",substr(st, 9,14),"_",substr(st, 16,22),"_B11.tif")
		nameB12=paste0("S30_",substr(st, 9,14),"_",substr(st, 16,22),"_B12.tif")
		namendvi=paste0("S30_",substr(st, 9,14),"_",substr(st, 16,22),"_ndvi.tif")
		namendti=paste0("S30_",substr(st, 9,14),"_",substr(st, 16,22),"_ndti.tif")
		B4=paste0('gdal_translate -of GTiff HDF4_EOS:EOS_GRID:"',st,'":Grid:B04 ',nameB4)
		system(B4)
		B8A=paste0('gdal_translate -of GTiff HDF4_EOS:EOS_GRID:"',st,'":Grid:B8A ',nameB8A)
		system(B8A)
		B11=paste0('gdal_translate -of GTiff HDF4_EOS:EOS_GRID:"',st,'":Grid:B11 ',nameB11)
		system(B11)
		B12=paste0('gdal_translate -of GTiff HDF4_EOS:EOS_GRID:"',st,'":Grid:B12 ',nameB12)
		system(B12)
		#ndvi code for landsat
		ndvi=paste0("gdal_calc.py -A ", nameB8A, " -B ", nameB4," --outfile=",namendvi, " --calc='((A.astype(float32)-B)/(A.astype(float32)+B))*10000' --NoDataValue=0")
		system(ndvi, intern=TRUE)
		#ndti code for landsat
		ndti=paste0("gdal_calc.py -A ", nameB11, " -B ", nameB12," --outfile=",namendti, " --calc='((A.astype(float32)-B)/(A.astype(float32)+B))*10000' --NoDataValue=0")
		system(ndti, intern=TRUE)
	}
}

# st = 'HLS.L30.T14TQN.2015359.v1.4.hdf'

# nameB5=paste0("L30_",substr(st, 9,14),"_",substr(st, 16,22),"_B5.tif")
# nameB4=paste0("L30_",substr(st, 9,14),"_",substr(st, 16,22),"_B4.tif")
# namendvi=paste0("L30_",substr(st, 9,14),"_",substr(st, 16,22),"_ndvi.tif")
# B4=paste0('gdal_translate -of GTiff HDF4_EOS:EOS_GRID:"',st,'":Grid:band04 ',nameB4)
# system(B4)
# B5=paste0('gdal_translate -of GTiff HDF4_EOS:EOS_GRID:"',st,'":Grid:band05 ',nameB5)
# system(B5)

# #Sentinel
# ndvi=paste0("gdal_calc.py -A trash1/", file,"B8A.tif -B trash1/", file,"B4.tif --outfile=NDVI/ndvi_", t,"_", yr, "_", doy, ".tif --calc='((A.astype(float32)-B)/(A.astype(float32)+B))*1000' --NoDataValue=0")
# system(ndvi, intern=TRUE)
# ndti=paste0("gdal_calc.py -A trash1/", file,"B11.tif -B trash1/", file,"B12.tif --outfile=NDTI/ndti_", t,"_", yr, "_", doy, ".tif --calc='((A.astype(float32)-B)/(A.astype(float32)+B))*1000' --NoDataValue=0")
# system(ndti, intern=TRUE)

# #Landsat
# ndvi=paste0("gdal_calc.py -A ", nameB5, " -B ", nameB4," --outfile=",namendvi, " --calc='((A.astype(float32)-B)/(A.astype(float32)+B))*1000' --NoDataValue=0")
# system(ndvi, intern=TRUE)
# ndti=paste0("gdal_calc.py -A trash1/", file,"B6.tif -B trash1/", file,"B7.tif --outfile=NDTI/ndti_", t,"_", yr, "_", doy, ".tif --calc='((A.astype(float32)-B)/(A.astype(float32)+B))*1000' --NoDataValue=0")
# system(ndti, intern=TRUE)


# 	#foreach(d=doy) %dopar% {
# 			for(t in tiles){
# 			dat=as.Date(as.numeric(d)-1, origin=paste0(yr,"-01-01"))
# 			dt=gsub('-', '.', dat)
# 			aa=paste0('wget --user koutilya --password Compilers@123 -r --no-parent --cut-dirs=100 -A MOD09Q1.A',yr,d,'.',substr(st, 9,14),'.006*.hdf https://e4ftl01.cr.usgs.gov/MOLT/MOD09Q1.006/',dt,'/')
# 			system(aa, intern=TRUE)
# 			flst=list.files('./e4ftl01.cr.usgs.gov/', pattern=paste0('A', yr,d,'.',t))
# 			b1=paste0('gdal_translate -of GTiff HDF4_EOS:EOS_GRID:"e4ftl01.cr.usgs.gov/',flst,'":MOD_Grid_250m_Surface_Reflectance:sur_refl_b01 A',yr,'_',d,'_',substr(st, 9,14),'_b1.tif')
# 			system(b1, intern=TRUE)
# 			b2=paste0('gdal_translate -of GTiff HDF4_EOS:EOS_GRID:"e4ftl01.cr.usgs.gov/',flst,'":MOD_Grid_250m_Surface_Reflectance:sur_refl_b02 A',yr,'_',d,'_',substr(st, 9,14),'_b2.tif')
# 			system(b2, intern=TRUE)
# 			b1=paste0("gdalwarp -tr 231.656358263889 -231.656358263889 -t_srs '+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +datum=NAD83 +units=m +no_defs +ellps=GRS80 +towgs84=0,0,0' -overwrite A",yr,"_",d,"_",substr(st, 9,14),"_b1.tif new_A",yr, "_", d,"_",substr(st, 9,14),"_b1.tif")
# 			system(b1, intern=TRUE)
# 			b2=paste0("gdalwarp -tr 231.656358263889 -231.656358263889 -t_srs '+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +datum=NAD83 +units=m +no_defs +ellps=GRS80 +towgs84=0,0,0' -overwrite A",yr, "_",d,"_",substr(st, 9,14),"_b2.tif new_A",yr, "_", d,"_",substr(st, 9,14),"_b2.tif")
# 			system(b2, intern=TRUE)
# 			ndvi=paste0("gdal_calc.py -A new_A",yr, "_",d,"_",substr(st, 9,14),"_b2.tif -B new_A",yr, "_", d,"_",substr(st, 9,14),"_b1.tif --outfile=", t, "_",yr,"_ndvi_A",d,".tif --calc='((A.astype(float)-B)/(A.astype(float)+B))*10000' --NoDataValue=0")
# 			system(ndvi, intern=TRUE)
# 		}
# }
