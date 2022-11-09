import L from 'leaflet';
//import { withRouter } from 'react-router-dom';

const icon_location = new L.Icon({
  iconSize: [50, 50],
  iconAnchor: [25, 45],
  popupAnchor: [2, -40],
  iconUrl: "https://image.flaticon.com/icons/png/512/4318/4318048.png",
//   shadowUrl: "https://unpkg.com/leaflet@1.6/dist/images/marker-shadow.png"
});

const mapStyle = {
  fillColor: "#fdcb6e",
  fillOpacity: 0.8,
  opacity: 1,
  color: "#636e72",
  weight: 2,
  zIndex: 1
}

const mapStyleLarge = {
  fillColor: "#fdcb6e",
  fillOpacity: 1,
  opacity: 0,
  color: "#636e72",
  weight: 2,
  zIndex: 0
}

const countyMapStyle = {
  fillOpacity: 0,
  opacity: 1,
  // color: "#2c3e50",
  color: "white",
  weight: 2,
  zIndex: 5
}

const mapData = {
  position: 'absolute',
  zIndex: 5
};

const largeFont = {
  fontSize: 25,
  color: "#16a085"
}

const smallFont = {
  fontSize: 15,
  color: "#16a085"
}
const formDataS = {
  position: 'absolute',
  left: '67vw',
  top: '5vh',
  height: '90vh',
  width: '30vw',
  backgroundColor: 'white',
  borderRadius: '10px',
  zIndex: 20
};

const header = {
  position: 'absolute',
  // textAlign: 'center',
  // top: '1vh',
  // left: '15vw',
  // height: '9vh',
  // width: '48vw',
  // backgroundColor: 'white',
  // color: 'teal',
  borderRadius: '50px',
  zIndex: 20
};

const navBar = {
  position: 'absolute',
  height:'20vh',
  width: '30vw',
  top: '1vh',
  borderRadius: '50px',
  left: '20vw',
}

const alignCenter = {
  textAlign: "center"
}

const legend = {
  position: 'absolute',
  top: '80vh',
  color:"white",
  left: '1vw',
  zIndex: 20,
  // backgroundColor:"teal"
};
const county = {
  position: 'relative',
  top: '1vh',
  left: '1vw',
  height: '0.5vh',
  width: '3vw',
  backgroundColor: 'white',
  zIndex: 20
};
const wht = {
  position: 'relative',
  top: '1vh',
  left: '1vw',
  height: '1.5vh',
  width: '3vw',
  backgroundColor: '#fdcb6e',
  zIndex: 20
};

const legLabels = {
  position: 'relative',
  width: '10vw',
  left: '1vw',
  zIndex: 20
};

const Label_120 = {
  bottom: '2vw',
  position: 'absolute',
  left: '3vh',
  height: '0.5vh',
  width: '4vw',
  textAlign: 'center',
  color:"white",
  backgroundColor: 'white',
  zIndex: 20
};
const Label_500 = {
  bottom: '2vw',
  position: 'absolute',
  left: '3vh',
  height: '0.5vh',
  width: '4vw',
  textAlign: 'center',
  color:"white",
  backgroundColor: 'white',
  zIndex: 20
};
const Label_1km = {
  bottom: '2vw',
  position: 'absolute',
  left: '3vh',
  height: '0.5vh',
  width: '4vw',
  textAlign: 'center',
  color:"white",
  backgroundColor: 'white',
  zIndex: 20
};

export { icon_location, header, formDataS, smallFont, largeFont, mapStyle, mapStyleLarge, mapData, countyMapStyle, legend,wht, county,legLabels };
export { Label_120, Label_1km, Label_500,alignCenter, navBar};