import React, { createRef, useEffect } from "react";
import { MapContainer, TileLayer, Marker, GeoJSON, useMapEvents, useMap } from "react-leaflet";
import 'leaflet/dist/leaflet.css';
import MDdata from "../data/GeoJson_Files/sim_MD_Bound_Coord.json"
import MDdata1 from "../data/MD_cornsoybean_pixel1.json"
import 'materialize-css'
import { Row, Col, TextInput, Button, Icon, Preloader, Select } from 'react-materialize';
import L from 'leaflet';
import '../index.css';
import icon from 'leaflet/dist/images/marker-icon.png'; 
import iconShadow from 'leaflet/dist/images/marker-shadow.png';
import { Link } from 'react-router-dom';
import { io } from 'socket.io-client';
import { icon_location, header, formDataS, largeFont, mapStyle, mapStyleLarge, mapData, countyMapStyle, legend, navBar } from './IconFactory';
import "leaflet-geosearch/dist/geosearch.css";
import { GeoSearchControl, OpenStreetMapProvider } from "leaflet-geosearch";

const socket = io('http://localhost:4000')


socket.on("connect", () => {
  console.log(`you connected with id: ${socket.id}`)
})

let DefaultIcon = L.icon({
  iconUrl: icon,
  shadowUrl: iconShadow
});

L.Marker.prototype.options.icon = DefaultIcon;
const mapPosition = [38.9869, -76.0413];
const zoom = 8;


let mapValues = {
  bounds: {
    _southWest: null,
    _northEast: null
  },
  center: {
    lat: null,
    lng: null
  },
  zoom: null,
}

let AddNewMarker = {
  lat: null,
  lng: null
}

function SendMapValuesToServer() {
  useMapEvents({
    moveend: (e) => {
      mapValues.center = e.target.getCenter()
      mapValues.bounds = e.target.getBounds()
      mapValues.zoom = e.target.getZoom()
      socket.emit('sendMapvalues', mapValues, message => {
      })
    }
  });
  return null;
}


function AddMarkerToClick() {
  useMapEvents({
    click(e) {
      const newMarker = e.latlng
      AddNewMarker.lat = newMarker.lat
      AddNewMarker.lng = newMarker.lng
      socket.emit('sendMarker', AddNewMarker, message => {
        // console.log("sending marker", AddNewMarker)
      })
    },
  })
  return null
}

function LeafletgeoSearch() {
  const map = useMap();
  useEffect(() => {
    const provider = new OpenStreetMapProvider();

    const searchControl = new GeoSearchControl({
      provider,
      marker: {
        icon_location
      },
      showMarker: false,
      animateZoom: true,
    });

    map.addControl(searchControl);

    return () => map.removeControl(searchControl);
  }, [map]);

  return null;
}



class Home extends React.Component {
  constructor(props) {
    super(props);
    this.mapRef = createRef();
    this.state = {
      showOverlay: true,
      pointer: null,
      overlayData: [],
      showMarker: false,
      areaID: true,
      resultProcessId: false,
      showLoader: false,
      marker: {
        lat: mapPosition[0],
        lng: mapPosition[1]
      },
      centerState: {
        lat: null,
        lng: null
      },
      boundsState: {
        _southWest: null,
        _northEast: null
      },
      mapStyleChange: mapStyleLarge,
      showCountyOverlay: true,
      countyMap: countyMapStyle,
      //zoomLevelControl: data,
      zoomLevelControl: MDdata1,
      isMarch2016: false,
      isMarch2017: false,
      isMarch2018: false,
      isMarch2019: false,
      isMarch2020: false,
      csccs: false,
      show1KM: true,
      show500m: false,
      show120m: false,
      showLegends: true,
      cc: false,
      cs: false,
      pid: null,
      cornType: null,
      planting: null,
      fertpl: null,
      tillage:null,
      simls: null,
      reqObject: {
        pid: null,
        cornType: null,
        planting: null,
        tillage: null,
        fertpl: null,
        simls: null
      },
    };
  }

  componentDidMount() {
    socket.on('getMapvalues', (mapValues, cb) => {
      this.onMove(mapValues)
    })

    socket.on('getMarker', (obj, cb) => {
      console.log("got marker back", obj.markerValue, obj.areaID)
      setTimeout(() => {
        this.setState({ marker: obj.markerValue, showMarker: true, areaID: parseInt(obj.areaID) })
      }, 10);
    })
    //this.setState({ overlayData: dataMax.features })
    this.setState({ overlayData: MDdata1.features })
  }


  getBoundstoJson = (e) => {
    console.log("loading ....");
  }

  startOverlay = (e) => {
    console.log("start: " + this.state.showOverlay)
    let value = e.target.checked
    this.setState({ showOverlay: value })
  }

  addMarker = (e) => {
    console.log(this.state.marker);
    if (!this.state.showLoader) {
      this.setState({ marker: e.latlng, showMarker: true })
    }
    console.log(e.latlng.lat.toFixed(4) + ", " + e.latlng.lng.toFixed(4));
  }

  updateInput(e) {
    this.setState({
      input: e.target.value
    });
  }

  onEachFeature = (feature, layer) => {
    layer.on({
      click: this.toggleMarker.bind(this)
    });
  }

  toggleMarker = (feature) => {
    console.log("event handling")
    console.log(feature.properties)
    let val = JSON.stringify(feature.properties).toString()
    console.log(val.substring(22, 30))
    this.setState({ areaID: parseInt(val.substring(22, 30)) })
    console.log("Printing areaID below: " + JSON.stringify(this.state.areaID))
  }

  handleChange = (e) => {
    console.log(e)
    switch(e){
      case "March2016": console.log("If case March2016 ...")
                        this.setState({ 
                          isMarch2016: true,
                          isMarch2017: false,
                          isMarch2018: false,
                          isMarch2019: false, 
                          isMarch2020: false, 
                          simls: "March2016" })
                        break;
      case "March2017": console.log("If case March2017 ...")
                        this.setState({ 
                          isMarch2016: false,
                          isMarch2017: true,
                          isMarch2018: false,
                          isMarch2019: false, 
                          isMarch2020: false, 
                          simls: "March2017" })
                        break;
      case "March2018": console.log("If case March2018 ...")
                        this.setState({ 
                          isMarch2016: false,
                          isMarch2017: false,
                          isMarch2018: true,
                          isMarch2019: false, 
                          isMarch2020: false, 
                          simls: "March2018" })
                        break;
      case "March2019": console.log("If case March2019 ...")
                        this.setState({ 
                          isMarch2016: false,
                          isMarch2017: false,
                          isMarch2018: false,
                          isMarch2019: true, 
                          isMarch2020: false, 
                          simls: "March2019" })
                        break;
      case "March2020": console.log("If case March2020 ...")
                        this.setState({ 
                          isMarch2016: false,
                          isMarch2017: false,
                          isMarch2018: false,
                          isMarch2019: false, 
                          isMarch2020: true, 
                          simls: "March2020" })
                        break;
    }
  };

  handleRotation = (e) => {
    console.log(e)
    switch(e){
      case "csccs": console.log("If case csccs ...")
                     this.setState({ 
                      csccs: true,
                      cc: false,
                      cs: false })
                      break;
      case "cc": console.log("Else if case cc ...")
                    this.setState({ 
                      csccs: false,
                      cc: false,
                      cs: true })
                      break;
      case "cs": console.log("Else if case cs ...")
                      this.setState({ 
                        csccs: false,
                        cc: true,
                        cs: false })
                        break;
    }
  };

  onMove(mapValues) {
    console.log("loading ...." + JSON.stringify(mapValues.bounds));
    console.log("center ...." + JSON.stringify(mapValues.center));
    console.log("zoom ...." + JSON.stringify(mapValues.zoom));
   // console.log("printing data: " + JSON.stringify(data.features[0].geometry.coordinates[0]))
    console.log("printing data: " + JSON.stringify(MDdata1.features[0].geometry.coordinates[0]))
    var filenum = 0
    let zoomlvl = mapValues.zoom
    if (parseInt(zoomlvl) > 9) {
      this.setState({ mapStyleChange: mapStyle, showCountyOverlay: false, showLegends: false })
    } else {
      this.setState({ mapStyleChange: mapStyleLarge, showCountyOverlay: true })
    }

    if (parseInt(zoomlvl) > 8) {
      this.setState({ showLegends: false })
    } else {
      this.setState({ showLegends: true })
    }

   /* if (parseInt(zoomlvl) < 14) {
      for (let i = 0; i < MDdata1.filelist.length; i++) {
        var filevalue = null
        if (MDdata1.filelist[i]
          && MDdata1.filelist[i].ne[1] < mapValues.center.lng
          && MDdata1.filelist[i].ne[0] > mapValues.center.lat
          && MDdata1.filelist[i].sw[1] > mapValues.center.lng
          && MDdata1.filelist[i].sw[0] < mapValues.center.lat) {
          console.log("onMove: " + i)
          filenum = i
          filevalue = MDdata1.filelist[i].file
          break
        }
      }
      this.setState({reqObject: {
        json: filenum,
        swlng: mapValues.bounds._southWest.lng,
        nelng: mapValues.bounds._northEast.lng,
        swlat: mapValues.bounds._southWest.lat,
        nelat: mapValues.bounds._northEast.lat,
      } })
      this.setState({ pointer: filevalue })

      socket.emit('returnjson', this.state.reqObject, message => {
        console.log("Message Received")
        this.setState({ overlayData: message })
        if (this.state.showOverlay === true) {
          this.setState({ showOverlay: false, showCountyOverlay: false })
          setTimeout(() => {
            this.setState({ showOverlay: true, showCountyOverlay: true })
          }, 10);
        }
      })
    } else if (zoomlvl < 11) {
      console.log("Zoom < 14 Using 500m Json")
      var jsonData = []
      for (let i = 0; i < MDdata1.features.length; i++) {
        if (MDdata1.features[i].geometry.coordinates[0][0][0] > mapValues.bounds._southWest.lng
          && MDdata1.features[i].geometry.coordinates[0][4][0] < mapValues.bounds._northEast.lng
          && MDdata1.features[i].geometry.coordinates[0][0][1] > mapValues.bounds._southWest.lat
          && MDdata1.features[i].geometry.coordinates[0][4][1] < mapValues.bounds._northEast.lat)
          jsonData.push(MDdata1.features[i])
      }
      this.setState({ overlayData: jsonData })
      if (this.state.showOverlay === true) {
        this.setState({ showOverlay: false, showCountyOverlay: false })
        setTimeout(() => {
          this.setState({ showOverlay: true, showCountyOverlay: true })
        }, 10);
      }
    } else { 
      console.log("Zoom < 11 Using 1km Json")*/
      var jsonData = []
      for (let i = 0; i < MDdata1.features.length; i++) {
        if (MDdata1.features[i].geometry.coordinates[0][0][0] > mapValues.bounds._southWest.lng
          && MDdata1.features[i].geometry.coordinates[0][4][0] < mapValues.bounds._northEast.lng
          && MDdata1.features[i].geometry.coordinates[0][0][1] > mapValues.bounds._southWest.lat
          && MDdata1.features[i].geometry.coordinates[0][4][1] < mapValues.bounds._northEast.lat)
          jsonData.push(MDdata1.features[i])
          console.log('test1',jsonData)
      }
      this.setState({ overlayData: jsonData })
      if (this.state.showOverlay === true) {
        this.setState({ showOverlay: false, showCountyOverlay: false })
        setTimeout(() => {
          this.setState({ showOverlay: true, showCountyOverlay: true })
        }, 10);
      }
  }

  validator = () => {
    let plantingerr = true; let fertplerr = true; let simlserr = true;
    let croperr = true; let tillerr = true; let piderr = true
    if (this.state.planting && typeof (this.state.planting) == "string") {
      plantingerr = false
    }
    if (this.state.cornType && typeof (this.state.cornType) == "string") {
      croperr = false
    }
    if (this.state.fertpl && typeof (this.state.fertpl) == "string") {
      fertplerr = false
    }
    if (this.state.tillage && typeof (this.state.tillage) == "string") {
      tillerr = false
    }
    if (this.state.simls && typeof (this.state.simls) == "string") {
      simlserr = false
    }
    if (this.state.areaID && typeof (this.state.areaID) == "number") {
      piderr = false
    } else {
      alert("Please select a tile.")
      return false
    }

    console.log(plantingerr, fertplerr, simlserr, croperr, tillerr)
    if (plantingerr || fertplerr || simlserr || croperr || tillerr) {
      alert("Please fill the details")
      return false
    } else {
      return true
    }
  }

  runModel = () => {
    let runCode = this.validator()
    if (runCode) {
      this.setState({ reqObject: {
        pid: this.state.areaID,
        planting: this.state.planting,
        fertpl: this.state.fertpl,
        tillage: this.state.tillage,
        simls: this.state.simls,
        lat: this.state.marker.lat,
        lng: this.state.marker.lng
      } })
      this.setState({ areaID: null, showLoader: true })
      console.log(JSON.stringify(this.state.reqObject))
      socket.emit('runcode', this.state.reqObject, message => {
        console.log(message)
        if (message && message === 'Result failed') {
          console.log("printing Req status if")
          this.setState({ resultProcessId: false, showLoader: false })
        } else {
          console.log("printing Req status else")
          this.setState({ resultProcessId: true, showLoader: false })
        }
      })
    }
  }

  render() {

    return (
      <div className="map-container">
        { this.state.showLegends && <div style={header}>
          <Row>
          <Col style={navBar}><img alt="" src="/images/nav_bar.png"/></Col>
          </Row>
        </div>}
        {this.state.showLegends && <div style={legend}>
          <Row>
          <Col><img alt="" src="/images/Legend.png"/></Col>
          </Row>
        </div>}
        {/*this.state.show1KM && <div style={Label_1km}><strong><h6>1KM</h6></strong></div>}
        {this.state.show120m && <div style={Label_120}><strong><h6>120m</h6></strong></div>}
    {this.state.show500m && <div style={Label_500}><strong><h6>500m</h6></strong></div>*/}
        <div className="mapData" style={mapData}>
          <MapContainer
            whenCreated={mapInstance => {
              this.mapRef.current = mapInstance
            }}
            center={mapPosition}
            zoom={zoom}
            scrollWheelZoom={false}
            onClick={this.addMarker}
            onMoveEnd={this.onMove.bind(this)}
          >
            <TileLayer
              url="https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}"
              attribution='&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
            />
            <SendMapValuesToServer />
            {this.state.marker && this.state.showMarker &&
              <Marker key={`marker`} position={this.state.marker} icon={icon_location} />
            }
            {this.state.showOverlay && <GeoJSON
              style={this.state.mapStyleChange}
              data={this.state.overlayData}
              // data={this.state.zoomLevelControl.features}
              onEachFeature={this.onEachFeature.bind(this)}
              eventHandlers={{
                click: () => {
                  console.log('marker clicked')
                },
              }}
            />}
            {this.state.showCountyOverlay && <GeoJSON
              style={this.state.countyMap}
              //data={ksok.features}
              data={MDdata.features}
            />}
            <AddMarkerToClick />
            <LeafletgeoSearch />
          </MapContainer>
        </div>
        <div className="formData" style={formDataS}>
          <Row>
            <Col className="teal white-text" s={12}>
              <h3 style={{ textAlign: 'center' }} >Crop Information</h3>
            </Col>
          </Row>
          <Row>
            <Col s={1} ></Col>
            <Col s={5} >
              <strong><TextInput style={largeFont} disabled label="Latitude"
                value={this.state.marker && this.state.marker.lat.toFixed(8)} />
              </strong>
            </Col>
            <Col s={5} >
              <strong><TextInput style={largeFont} disabled label="Longitude"
                value={this.state.marker && this.state.marker.lng.toFixed(7)} />
              </strong>
            </Col>
          </Row>
          <Row>
            <Col s={1} ></Col>
            <Col s={5} >
            <Select multiple={false} onChange={(e) => this.setState({ cornType: e.target.value })} value="">
                <option disabled value=""> Choose Crop Type </option>
                <option value="Corn"> Corn </option>
                <option value="Soybean"> Soybean </option>
              </Select>
              {/* <label>Crop Type</label> */}
            </Col>
            <Col s={5} >
              <TextInput id="TextInput-1" label="Date (MM/DD)" onChange={(e) => this.setState({ planting: e.target.value })} />
            </Col>
          </Row>
          <Row>
            <Col s={1} ></Col>
            <Col s={5} >
              <Select multiple={false} onChange={(e) => this.handleChange(e.target.value)} value="">
                <option disabled value=""> Choose Year </option>
                <option value="March2016"> March2016 </option>
                <option value="March2017"> March2017 </option>
                <option value="March2018"> March2018 </option>
                <option value="March2019"> March2019 </option>
                <option value="March2020"> March2020 </option>
              </Select>
              {/* <label>Year</label> */}
            </Col>
            <Col s={5} >
              <Select multiple={false} onChange={(e) => this.handleRotation(e.target.value)} value="">
                <option disabled value=""> Choose Crop Rotation </option>
                <option value="csccs"> Corn Soybean and Corn-Corn-Soybean, </option>
                <option value="cc"> Continuous Corn </option>
                <option value="cs"> Continuous Soybeans </option>
              </Select>
             {/* <label>Crop Rotation</label> */}
            </Col>
          </Row>
          <Row>
            <Col s={1} ></Col>
            <Col s={5} >
              <TextInput id="TextInput-2" label="Fertilizer Amount" onChange={(e) => this.setState({ fertpl: e.target.value })} />
            </Col>
            <Col s={5} >
            <Select multiple={false} onChange={(e) => this.setState({ tillage: e.target.value })} value="">
                <option disabled value=""> Choose Tillage Type </option>
                <option value="intersive"> Intensive Tillage </option>
                <option value="reduced"> Reduced Tillage </option>
                <option value="conservation"> Conservation Tillage </option>
                <option value="notillage"> No Tillage </option>
              </Select>
            </Col>
          </Row>
          <Row>
            <Col s={1} ></Col>
            <Col s={5} >
              <Button node="button" type="submit" waves="light" disabled={(this.state.areaID && !this.state.showLoader) ? false : true} onClick={this.runModel}>
                Run Model
                <Icon right> send  </Icon>
              </Button></Col>
            <Col s={2} >
              {this.state.showLoader && <Preloader
                active
                color="blue"
                flashing={false}
                size="small"
              />}
            </Col>
            <Col s={5} >
              <Link to="/results" style={{ textDecoration: 'none' }}>
                {this.state.resultProcessId && <Button node="button" type="submit" waves="light">
                  View Results
                  <Icon right> insert_chart  </Icon>
                </Button>}</Link></Col>
          </Row>
        </div>
      </div>
    );
  }
}

export default Home;
