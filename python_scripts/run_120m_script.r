#load libraries
library(rgdal)
library(raster)
library(geojsonio)
#raster data is in float so need to change it to integer
#system("gdal_translate -of GTiff -ot Int32 KS_OK_base120m.tif KS_OK_base_poly_120m.tif")
#read in raster
te=raster('Data_Cluster/retile/raster_translate10.tif')
#convert raster to polygon
te1=rasterToPolygons(te, na.rm=TRUE, dissolve=FALSE)
#write shapefile
li#convert polygon features to geoJson file
te2=geojson_json(te1)
#write geoJSON file
geojson_write(te2, file="Data_Cluster/new_json/raster_translate10.geojson") 