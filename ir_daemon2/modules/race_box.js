/**
 * EasyRaceLapTimer - Copyright 2015-2016 by airbirds.de, a project of polyvision UG (haftungsbeschränkt)
 *
 * This file is part of EasyRaceLapTimer.
 *
 * EasyRaceLapTimer is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 * EasyRaceLapTimer is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License along with Foobar. If not, see http://www.gnu.org/licenses/.
 **/

const API_WEB_HOST = 'http://localhost:8080/';

var moment = require('moment');
var util = require('util');
var	request = require('request');
var SerialPort = require('serialport');

var race_box = {};
race_box.port = null;
race_box.setup_done = false;

race_box.list_ports = function(){
    SerialPort.list(function (err, ports) {
        ports.forEach(function(port) {
            console.log(port.comName);
        });
        process.exit();
    });
}

race_box.setup = function(port_id){
    this.port = new SerialPort(port_id, {
        parser: SerialPort.parsers.readline('\n'),
        baudRate: 115200
    });

    this.port.on('data',this.receive_data.bind(this));

    this.setup_done = true;
    console.log("RaceBox started on ported " + port_id);
}

race_box.receive_data = function(data){
    console.log('RaceBox.receive_data: ' + data);

    if(data.startsWith("TT_CH")){ // incoming timing data
        this.process_new_lap(data);
        return;
    }

    if(data.startsWith("GRSSIS")){ // incomming saved rssi data
        this.process_saved_rssi(data);
        return;
    }

    if(data.startsWith("CRSSIS")){ // incomming current rssi data
        this.process_current_rssi(data);
        return;
    }
}

race_box.process_current_rssi = function(msg){
    console.log("RaceBox.process_current_rssi:" + msg);
    msg = msg.replace("#","");
    msg = msg.split(" ");
    console.log("VTX channel: " + msg[1]);
    console.log("RSSI: " + msg[2]);
    var token = "VTX_" + msg[1];

    var url = ("%s/api/v1/race_box/update_receiver", API_WEB_HOST);
    var apiNewLap = util.format()
    request({
        url: util.format("%s/api/v1/race_box/update_receiver", API_WEB_HOST), //URL to hit
        qs: {vtx: token, crssi: msg[2]}, //Query string data
        method: 'POST'
    }, function(error, response, body){
        if(error) {
            console.log(error);
        } else {
            console.log(response.statusCode, body);
        }
    });	
}

race_box.process_saved_rssi = function(msg){
    console.log("RaceBox.process_saved_rssi:" + msg);
    msg = msg.replace("#","");
    msg = msg.split(" ");
    console.log("VTX channel: " + msg[1]);
    console.log("RSSI: " + msg[2]);
    var token = "VTX_" + msg[1];

    var url = ("%s/api/v1/race_box/update_receiver", API_WEB_HOST);
    var apiNewLap = util.format()
    request({
        url: util.format("%s/api/v1/race_box/update_receiver", API_WEB_HOST), //URL to hit
        qs: {vtx: token, srssi: msg[2]}, //Query string data
        method: 'POST'
    }, function(error, response, body){
        if(error) {
            console.log(error);
        } else {
            console.log(response.statusCode, body);
        }
    });	
}

race_box.process_new_lap = function(msg){
    console.log("RaceBox.process_new_lap:" + msg);
    msg = msg.replace("#","");
    msg = msg.split(" ");
    console.log("VTX channel: " + msg[1]);
    console.log("MS: " + msg[2]);
    var token = "VTX_" + msg[1];

    var url = ("%s/api/v1/lap_track/create?transponder_token=%s&lap_time_in_ms=%s", API_WEB_HOST, token, msg[2]);
    var apiNewLap = util.format()
    request({
        url: util.format("%s/api/v1/lap_track/create", API_WEB_HOST), //URL to hit
        qs: {transponder_token: token, lap_time_in_ms: msg[2]}, //Query string data
        method: 'GET'
    }, function(error, response, body){
        if(error) {
            console.log(error);
        } else {
            console.log(response.statusCode, body);
        }
    });			
}

race_box.set_channel_rssi = function(msg){
    console.log("RaceBox.set_channel_rssi:" + msg);
    msg = msg.replace("#","");
    msg = msg.split(" ");
    this.write_to_rb("S_VTX_STR " + msg[1] + " "+ msg[2] +  "\n");
}   

race_box.reset_timing = function(){
  this.write_to_rb("RST_TIMING\n");
}

race_box.read_saved_rssi = function(){
  this.write_to_rb("SLAVES_RSSI_STRENGTH\n");
}

race_box.read_current_rssi = function(){
  this.write_to_rb("SLAVES_CRSSI_STRENGTH\n");
}

race_box.write_to_rb = function(msg){
    if(this.setup_done == false){
        return;
    }
    
    this.port.write(msg, function(err) {
        if (err) {
        return console.log('Error on write: ', err.message);
        }
        console.log('message written');
    });
}

module.exports = race_box;
