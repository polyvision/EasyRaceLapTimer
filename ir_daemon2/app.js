/**
 * EasyRaceLapTimer - Copyright 2015-2016 by airbirds.de, a project of polyvision UG (haftungsbeschränkt)
 *
 *
 * This file is part of EasyRaceLapTimer.
 *
 * EasyRaceLapTimer is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 * EasyRaceLapTimer is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License along with Foobar. If not, see http://www.gnu.org/licenses/.
 **/

var wpi = require('wiring-pi');
var	net = require('net');
var util = require('util');
var vtx_sensor = require('./modules/vtx_sensor.js');
var race_box = require('./modules/race_box.js');
var fs = require('fs');

wpi.setup('wpi');
vtx_sensor.setup(wpi);

const SOCKET_PORT = 3006;

function readConfigVal(key){
  try
    {
        var configuration = JSON.parse(fs.readFileSync("/etc/ir_daemon2.json"));
        return configuration[key];
    }
    catch (err)
    {
        return false;
    }
}

function setConfigVal(key,val){
  var configuration = JSON.parse(fs.readFileSync("/etc/ir_daemon2.json"));
  configuration[key] = val;
  fs.writeFileSync("/etc/ir_daemon2.json",JSON.stringify(configuration));
}

if(process.argv[2] === "list_race_box_ports"){
  race_box.list_ports();
  process.exit(1);
}

if(process.argv[2] === "set_race_box_port"){
  setConfigVal("race_box_com_port",process.argv[3]);
  process.exit(1);
}

if(process.argv[2] === "enable_race_box"){
  setConfigVal("race_box_enabled",true);
  process.exit(1);
}

if(process.argv[2] === "disable_race_box"){
  setConfigVal("race_box_enabled",false);
  process.exit(1);
}

var rb_port = readConfigVal('race_box_com_port');
var rb_enabled = readConfigVal("race_box_enabled");
if(rb_enabled === true){
  if (rb_port !== undefined && rb_port != false) {
    try{
      race_box.setup(readConfigVal('race_box_com_port'));
    }
    catch(err){
      console.log(err);
    } 
  }
}else{
  console.log("race_box is disabled");
}

function process_cmd(cmd){
	cmd = cmd.toString().trim();
	console.log("Received command '%s' ", cmd);
  	switch(cmd) {
  		case "RESET#":
  			vtx_sensor.resetLapTimes();
        race_box.reset_timing();
  			break;
      case "RB_RST_TIMING#":
  			race_box.reset_timing();
  			break;
      case "RB_SRSSI#":
  			race_box.read_saved_rssi();
  			break;
      case "RB_CRSSI#":
  			race_box.read_current_rssi();
  			break;
  	}

    if(cmd.startsWith("RB_SC_RSSI")){
      race_box.set_channel_rssi(cmd);
      return;
    }

    if(cmd.startsWith("RB_ILT")){
     race_box.invalidate_last_tracking(cmd);
     return; 
    }
}

// Socket SERVER
net.createServer(function (socket) {

  // Identify this client
  socket.name = socket.remoteAddress + ":" + socket.remotePort;
  // console.log("New connection from %s", socket.name);

  // Handle incoming messages from clients.
  socket.on('data', function (data) {
    processData(socket.name, data, socket);
  });

  // Remove the client from the list when it leaves
  socket.on('end', function () {
  	// console.log("Client %s close connection", socket.name);
  });
  
  // Send a message to all clients
  function processData(socket_name, data, sender) {
    process_cmd(data);
    sender.end();
  }

}).listen(SOCKET_PORT);

// Put a friendly message on the terminal of the server.
console.log("IR_DAEMON2 running at port %s\n", SOCKET_PORT);
