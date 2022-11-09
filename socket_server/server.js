const { exec } = require('child_process');


const io = require('socket.io')(4000, {
    cors: {
        origin: ['https://localhost:3000/'],
    },
})

io.on('connection', socket => {
    console.log("Connection to socket id: ", socket.id)
    let file_value = null
    let zoom = null
    let filepath = null
    socket.on('runcode', (obj, cb) => {
        {
            console.log(obj)
            var execution = 'Rscript nitrogen_running_code.r ' + obj.pid + " " + "'" + obj.planting + "'" + " " + obj.fertpl + " " + "'" + obj.simls + "'" + " " + obj.price + " " + obj.Nprice

            // Executing the weather Generator
            var execte_weather = 'Rscript weather_generator.r ' +  obj.lat + " " +  obj.lng 
            var combine = execte_weather + " ; "+ execution
            // var execution = "Rscript run_Rcode.r"
            console.log(execte_weather)
            modelPath = "/web/data/nitrogen_recommendation_tool/Rcode/"
            exec(combine, { maxBuffer: 1024 * 10000, cwd: modelPath }, function (err, stdout, status) {
                console.log("Status code: " + status)
                if (err) {
                    if (status.includes('Warning messages:')) {
                        console.log(`stdout: ${stdout}`);
                        cb(`Result success`)
                    } else {
                        console.error(`exec error: ${err}`);
                        cb(`Result failed`)
                    }
                    return;
                } else {
                    console.log(`stdout: ${stdout}`);
                    cb(`Result success`)
                }
            });

                // // Executing the Nitrogen Recomendation Code
                // var execution = 'Rscript nitrogen_running_code.r ' + obj.pid + " " + "'" + obj.planting + "'" + " " + obj.fertpl + " " + "'" + obj.simls + "'" + " " + obj.price + " " + obj.Nprice
                // // var execution = "Rscript run_Rcode.r"
                // console.log(execution)
                // modelPath = "../../"
                // exec(execution, { maxBuffer: 1024 * 10000, cwd: modelPath }, function (err, stdout, status) {
                //     console.log("Status code: " + status)
                //     if (err) {
                //         if (status.includes('Warning messages:')) {
                //             console.log(`stdout: ${stdout}`);
                //             cb(`Result success`)
                //         } else {
                //             console.error(`exec error: ${err}`);
                //             cb(`Result failed`)
                //         }
                //         return;
                //     } else {
                //         console.log(`stdout: ${stdout}`);
                //         cb(`Result success`)
                //     }
                // });
            
            // testing code for 10 mintues
            /** setTimeout(() => {
                console.log("running for 10 min")
                cb(`Result success`)
            }, 3000); **/

        }
    })

    // Sending Json File Values to the webserver
    socket.on('returnjson', (obj, cb) => {
        console.log(JSON.stringify(obj))
        file_value = obj.json
        //filepath = "../react_leaflet/src/data/MD_pixels2/MD_cornsoybean_pixel" + obj.json + ".json"
        filepath = "../react_leaflet/src/data/json_120m/json_" + obj.json + ".json"
        // filepath = "../react_leaflet/src/data/GeoJson_Files/1km.json"
        const res = require(filepath)
        var jsonData = []
        for (let i = 0; i < res.features.length; i++) {
            if (res.features[i].geometry.coordinates[0][0][0] > obj.swlng
                && res.features[i].geometry.coordinates[0][4][0] < obj.nelng
                && res.features[i].geometry.coordinates[0][0][1] > obj.swlat
                && res.features[i].geometry.coordinates[0][4][1] < obj.nelat)
                //   console.log("print value" + JSON.stringify(res.features[i]))
                jsonData.push(res.features[i])
        }
        cb(jsonData)
    })

    socket.on('sendMapvalues', (a, cb) => {
        console.log(a)
        zoom = a.zoom
        cb(socket.emit('getMapvalues', a, message => {
            // console.log(a)
        }))
    })

    let markerResp = {
        markerValue: null,
        areaID: null
    }

    socket.on('sendMarker', (a, cb) => {
        console.log(a.lat, a.lng, file_value, zoom)
        let pid = null
        let path = null
      /*if (zoom != null && zoom > 8) {
            path = filepath
            const res = require(path)
            for (let i = 0; i < res.features.length; i++) {
                if (res.features[i].geometry.coordinates[0][0][0] < a.lng
                    && res.features[i].geometry.coordinates[0][2][0] > a.lng
                    && res.features[i].geometry.coordinates[0][0][1] > a.lat
                    && res.features[i].geometry.coordinates[0][2][1] < a.lat
                ) {
                    let str = res.features[i].properties
                    pid = JSON.stringify(str).toString().substring(22, 30)
                    console.log(pid)
                }
            }
          } /* else if (zoom != null && zoom > 11) {
            path = "../react_leaflet/src/data/GeoJson_Files/500m.json"
            const res = require(path)
            for (let i = 0; i < res.features.length; i++) {
                if (res.features[i].geometry.coordinates[0][0][0] < a.lng
                    && res.features[i].geometry.coordinates[0][2][0] > a.lng
                    && res.features[i].geometry.coordinates[0][0][1] > a.lat
                    && res.features[i].geometry.coordinates[0][2][1] < a.lat
                ) {
                    let str = res.features[i].properties
                    pid = JSON.stringify(str).toString().substring(15, 23)
                    console.log(JSON.stringify(str).toString())
                    console.log(pid)
                }
            }

        } else { 
            path = "../react_leaflet/src/data/GeoJson_Files/1km.json"
            const res = require(path)
            for (let i = 0; i < res.features.length; i++) {
                if (res.features[i].geometry.coordinates[0][0][0] < a.lng
                    && res.features[i].geometry.coordinates[0][2][0] > a.lng
                    && res.features[i].geometry.coordinates[0][0][1] > a.lat
                    && res.features[i].geometry.coordinates[0][2][1] < a.lat
                ) {
                    let str = res.features[i].properties
                    pid = JSON.stringify(str).toString().substring(12, 20)
                    console.log(JSON.stringify(str).toString())
                    console.log(pid)
                }
            }

        } 
        else { */path = "../react_leaflet/src/data/GeoJson_Files/sim_MD_Bound_Coord.json"
            const res = require(path)
            for (let i = 0; i < res.features.length; i++) {
                if (res.features[i].geometry.coordinates[0][0][0] < a.lng
                    && res.features[i].geometry.coordinates[0][2][0] > a.lng
                    && res.features[i].geometry.coordinates[0][0][1] > a.lat
                    && res.features[i].geometry.coordinates[0][2][1] < a.lat
                ) {
                    let str = res.features[i].properties
                    pid = JSON.stringify(str).toString().substring(12, 20)
                    console.log(JSON.stringify(str).toString())
                    console.log(pid)
                }
            }
        //} 
        markerResp = {
            markerValue: a,
            areaID: pid
        }
        cb(socket.emit('getMarker', markerResp, message => {
            // console.log(a)
        }))
    })
})