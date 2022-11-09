import pandas as pd
import glob, os, json


#json_dir = '../react_leaflet/src/data/GeoJson_Files/MD_pixels3'
json_dir = './'

json_pattern = os.path.join(json_dir, '*.json')
file_list = glob.glob(json_pattern)


print(file_list)

dfs = []
for file in file_list:
    with open(file) as f:
        json_data = pd.json_normalize(json.loads(f.read()))
        json_data['site'] = file.rsplit("/", 1)[-1]
    dfs.append(json_data)
df = pd.concat(dfs)


print(df)
out = df.to_json(orient='records')[1:-1].replace('},{', '} {')

with open('file_name.txt', 'w') as f:
    f.write(out)