/**


import { Dropdown } from 'react-bootstrap';
import React from 'react'

const returndata = () => {
    console.log(JSON.stringify(data1.features))
    return data1.features
}

export default returndata





import React from 'react'
import { Button, Icon } from 'react-materialize';
import { Link } from 'react-router-dom';
import { io } from 'socket.io-client';

const socket = io('http://localhost:4000')


socket.on("connect", () => {
    console.log(`you connected with id: ${socket.id}`)
})


export default class socketio extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            reqObject: {
                pid: 32562931,
                planting: '10/25',
                fertpl: 10,
                simls: 'March2019',
                price: 4,
                Nprice: 0.35
            },
        };
    }



    sendData = () => {
        console.log(JSON.stringify(this.state.reqObject))
        socket.emit('runcode', this.state.reqObject, message => {
            console.log(message)
        })
    }

    render() {
        const { classes } = this.props;
        return (
            <div>
                <div style={{ position: 'absolute', top: '5vh', left: '5vw' }}>
                    <Link to="/" style={{ textDecoration: 'none' }}>
                        <Button node="button" type="submit" waves="light">
                            Map View
                    <Icon left> map  </Icon>
                        </Button>
                    </Link>
                    <h1>Here is the plot</h1>
                    <Button node="button" type="submit" waves="light" onClick={this.sendData}>
                        Print Socket ID
                    <Icon left> map  </Icon>
                    </Button>
                </div>
            </div>
        );

    }
}
 */