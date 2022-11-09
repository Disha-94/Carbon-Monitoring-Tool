import os
from os import listdir
from os.path import isfile, join
mypath = "C:/Users/pmeduri/Documents/Data_Cluster/retile"
onlyfiles = [f for f in listdir(mypath) if isfile(join(mypath, f))]
# print(onlyfiles)

file = open("execute.txt", "w")

count = 0
for i in onlyfiles:
    filepath = "'Data_Cluster/retile/" + i + "'"
    newpath = "'Data_Cluster/new_json/json_" + str(count) + ".json'"

    func1 = "te1=raster(" + filepath + ")"
    func2 = "te2=rasterToPolygons(te1, na.rm=TRUE, dissolve=FALSE)"
    func3 = "te3=geojson_json(te2)"
    func4 = "geojson_write(te3, file="+ newpath + ")"
    # print(filepath)
    file.write("\n" + func1 + "\n"+ func2 + "\n"+ func3 + "\n"+ func4 + "\n")
    count+=1

