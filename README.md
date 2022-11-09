#Cropland Carbon Tracking System

The purpose of this tool is to collect information from the user interface and pass it to an R script to run simulations and return png images that will be shown on /results page.
backend side, results will be shown on the webserver

nitrogen recommendation script
yield calculator: how much amount of fertilizer you need for the crops for good yield for each month

ptython scripts: tif files cant be read by react leaflet. so convert tif to json
overlay is not tif 

To convert GeoTiff or Shape file, you need geojsonio package in R
To install geojsonio in R, you first need to install rgeos
install.packages("rgeos", type = "source")
then do
install.packages("geojsonio")

Run https://github.com/mrlancelot/nitrogen_recommendation_tool/blob/main/python_scripts/run_120m_script.r
this script will do the conversion from tif to geojson (it will take some time for conversion to finish)

then run https://github.com/mrlancelot/nitrogen_recommendation_tool/blob/main/python_scripts/retile.py
This script is to divide the resulting huge geojson file into equal parts, which can then be loaded into your application

For shape files, do the below

library(rgdal)
library(geojsonio)
library(spdplyr)
library(rmapshaper)
# Import Shapefile into R. if your file is in current directory, then just give dsn="." else give absolute path. layer should be file name without extension
county <- readOGR(dsn = ".", layer = "Maryland_county", verbose = FALSE)
# Rename a column name GEOID to county_id.
county <- county %>% rename(county_id = GEOID)
# Convert SP Data Frame to GeoJSON.
county_json <- geojson_json(county)
# Simplify the geometry information of GeoJSON.
county_sim <- ms_simplify(county_json)
# Save it to a local file system.
geojson_write(county_json, file = "MD_boundaryCoord.geojson")
geojson_write(county_sim, file = "MD_boundaryCoord_simplified.geojson")