import React from 'react';
import Map from './components/Map';
import FormData from './components/FormData';
// import Home from './components/Socket';
import './App.css';
import { Route } from 'react-router-dom'


function App() {
  return (
    <div className="App">
      <Route exact path="/" component={Map} />
      <Route exact path="/results" component={FormData} />
      {/* <Route exact path="/socket" component={Socketio} /> */}
      {/* <Map/> */}
    </div>
  );
}
export default App;
