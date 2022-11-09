/**
import React from "react";
import { Map, TileLayer, Marker, GeoJSON } from "react-leaflet";
import 'leaflet/dist/leaflet.css';
import data from "../data/GeoJson_Files/500m.json";
import L from 'leaflet';
import '../index.css';
import icon from 'leaflet/dist/images/marker-icon.png';
import iconShadow from 'leaflet/dist/images/marker-shadow.png';
import { Form } from 'react-bootstrap';
import 'bootstrap/dist/css/bootstrap.min.css';


let DefaultIcon = L.icon({
  iconUrl: icon,
  shadowUrl: iconShadow
});

L.Marker.prototype.options.icon = DefaultIcon;
const mapPosition = [36.7844521, -102.5487837];
const zoom = 14;


const mapStyle = {
  fillColor: "red",
  fillOpacity: 0.5,
  opacity: 1,
  color: "black",
  weight: 2,
}

const mapData = {
  position: 'absolute',
  zIndex: 5
};

const formDataS = {
  position: 'absolute',
  left: '65vw',
  top: '5vh',
  height: '90vh',
  width: '30vw',
  backgroundColor: 'white',
  borderRadius: '10px',
  zIndex: 20
};

class Home extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      showOverlay: false,
      showMarker: false,
      areaID: null,
      marker: {
        lat: mapPosition[0],
        lng: mapPosition[1]
      },
    };
  }

  startOverlay = (e) => {
    console.log("start: " + this.state.showOverlay)
    let value = e.target.checked
    this.setState({ showOverlay: value })
  }

  addMarker = (e) => {
    console.log(this.state.marker);
    this.setState({ marker: e.latlng, showMarker: true })
    console.log(e.latlng.lat.toFixed(4) + ", " + e.latlng.lng.toFixed(4));
  }

  updateInput(e) {
    this.setState({
      input: e.target.value
    });
  }

  onEachFeature = (feature, layer) => {
    layer.on("click", L.bind(this.toggleMarker, null, feature));
  }

  toggleMarker = (feature) => {
    this.setState({ areaID: feature.properties.OK_wh_4 })
    console.log("Printing areaID below: " + this.state.areaID)
  }

  render() {

    return (
      <div className="map-container">
        <div className="mapData" style={mapData}>
          <Map
            center={mapPosition}
            zoom={zoom}
            scrollWheelZoom={false}
            onClick={this.addMarker}>
            <TileLayer
              url="https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}"
              attribution='&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
            />
            {this.state.marker && this.state.showMarker &&
              <Marker key={`marker`} position={this.state.marker} />
            }
            {this.state.showOverlay && <GeoJSON
              style={mapStyle}
              data={data.features}
              onEachFeature={this.onEachFeature}
            />}
          </Map>
        </div>
        <div className="formData" style={formDataS}>
          <Form>
            {['checkbox', 'radio'].map((type) => (
              <div key={`inline-${type}`} className="mb-3">
                <Form.Check
                  inline
                  label="1"
                  name="group1"
                  type={type}
                  id={`inline-${type}-1`}
                />
                <Form.Check
                  inline
                  label="2"
                  name="group1"
                  type={type}
                  id={`inline-${type}-2`}
                />
                <Form.Check
                  inline
                  disabled
                  label="3 (disabled)"
                  type={type}
                  id={`inline-${type}-3`}
                />
              </div>
            ))}
          </Form>
        </div>
      </div>
    );
  }
}

export default Home;
 */