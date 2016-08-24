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

wpi.setup('wpi');
vtx_sensor.setup(wpi);

const SOCKET_PORT = 3006;


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
  	cmd = data.toString().trim();
	console.log("Received command '%s' ", cmd);
  	switch(cmd) {
  		case "RESET#":
  			vtx_sensor.resetLapTimes();
  			break;
  	}
  }

}).listen(SOCKET_PORT);

// Put a friendly message on the terminal of the server.
console.log("IR_DAEMON2 running at port %s\n", SOCKET_PORT);
