/**
 * EasyRaceLapTimer - Copyright 2015-2016 by airbirds.de, a project of polyvision UG (haftungsbeschränkt)
 *
 * This file is part of EasyRaceLapTimer.
 *
 * EasyRaceLapTimer is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 * EasyRaceLapTimer is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License along with Foobar. If not, see http://www.gnu.org/licenses/.
 **/

var moment = require('moment');
var util = require('util');
var	request = require('request');

var vtx_sensor = {};

const API_WEB_HOST = 'http://localhost/';
const MIN_LAP_TIME = 5000;
const MAX_LAP_TIME = 90000;

procesLapTime = function(pinGPIO, delta) {
	curDate = moment();
	var lapTimeMillis = curDate.diff(pinGPIO.lapTime);
	if(lapTimeMillis > 5000) {
		if(lapTimeMillis > 90000) {
			console.log("Lap detected, but is too long. Starting new lap instead.");
		} else {
			console.log("New Lap in ", pinGPIO.name, ' Lap Time: ', lapTimeMillis);
			var url = ("%s/api/v1/lap_track/create?transponder_token=%s&lap_time_in_ms=%s", API_WEB_HOST, pinGPIO.name, lapTimeMillis);
			var apiNewLap = util.format()
			request({
			    url: util.format("%s/api/v1/lap_track/create", API_WEB_HOST), //URL to hit
			    qs: {transponder_token: pinGPIO.name, lap_time_in_ms: lapTimeMillis}, //Query string data
			    method: 'GET'
			}, function(error, response, body){
			    if(error) {
			        console.log(error);
			    } else {
			        console.log(response.statusCode, body);
			    }
			});			
		}
		pinGPIO.lapTime = curDate;
	}
}

vtx_sensor.lapTimes = { // lapTime = 0 forces stat new lap time with first gpio read
        gpio25: {name: 'VTX_1', lapTime: 0},
        gpio24: {name: 'VTX_2', lapTime: 0},
        gpio23: {name: 'VTX_3', lapTime: 0},
        gpio22: {name: 'VTX_4', lapTime: 0},
        gpio21: {name: 'VTX_5', lapTime: 0},
        gpio3: {name: 'VTX_6', lapTime: 0},
        gpio2: {name: 'VTX_7', lapTime: 0},
        gpio0: {name: 'VTX_8', lapTime: 0}
    };

vtx_sensor.setup = function(wpi){
    this.wpi = wpi;

    this.wpi.pinMode(25, this.wpi.INPUT);
    this.wpi.pullUpDnControl(25, this.wpi.PUD_UP);
    this.wpi.wiringPiISR(25, this.wpi.INT_EDGE_RISING, function(delta) {
    procesLapTime(this.lapTimes.gpio25, delta)
    }.bind(this));

    this.wpi.pinMode(24, this.wpi.INPUT);
    this.wpi.pullUpDnControl(24, this.wpi.PUD_UP);
    this.wpi.wiringPiISR(24, this.wpi.INT_EDGE_RISING, function(delta) {
    procesLapTime(this.lapTimes.gpio24, delta)
    }.bind(this));

    this.wpi.pinMode(23, this.wpi.INPUT);
    this.wpi.pullUpDnControl(23, this.wpi.PUD_UP);
    this.wpi.wiringPiISR(23, this.wpi.INT_EDGE_RISING, function(delta) {
    procesLapTime(this.lapTimes.gpio23, delta)
    }.bind(this));

    this.wpi.pinMode(22, this.wpi.INPUT);
    this.wpi.pullUpDnControl(22, this.wpi.PUD_UP);
    this.wpi.wiringPiISR(22, this.wpi.INT_EDGE_RISING, function(delta) {
    procesLapTime(this.lapTimes.gpio22, delta)
    }.bind(this));

    this.wpi.pinMode(21, this.wpi.INPUT);
    this.wpi.pullUpDnControl(21, this.wpi.PUD_UP);
    this.wpi.wiringPiISR(21, this.wpi.INT_EDGE_RISING, function(delta) {
    procesLapTime(this.lapTimes.gpio21, delta)
    }.bind(this));

    this.wpi.pinMode(3, this.wpi.INPUT);
    this.wpi.pullUpDnControl(3, this.wpi.PUD_UP);
    this.wpi.wiringPiISR(3, this.wpi.INT_EDGE_RISING, function(delta) {
    procesLapTime(this.lapTimes.gpio3, delta)
    }.bind(this));

    this.wpi.pinMode(2, this.wpi.INPUT);
    this.wpi.pullUpDnControl(25, this.wpi.PUD_UP);
    this.wpi.wiringPiISR(2, this.wpi.INT_EDGE_RISING, function(delta) {
    procesLapTime(this.lapTimes.gpio2, delta)
    }.bind(this));

    this.wpi.pinMode(0, this.wpi.INPUT);
    this.wpi.pullUpDnControl(0, this.wpi.PUD_UP);
    this.wpi.wiringPiISR(0, this.wpi.INT_EDGE_RISING, function(delta) {
    procesLapTime(this.lapTimes.gpio0, delta)
    }.bind(this));

   console.log("VTX_Sensor started PE ready");
}

vtx_sensor.resetLapTimes = function () {
	console.log("VTX_SENSOR::resetLapTimes");
	var curDate = moment();
	this.lapTimes = {
		gpio25: {name: 'VTX_1', lapTime: curDate},
		gpio24: {name: 'VTX_2', lapTime: curDate},
		gpio23: {name: 'VTX_3', lapTime: curDate},
		gpio22: {name: 'VTX_4', lapTime: curDate},
		gpio21: {name: 'VTX_5', lapTime: curDate},
		gpio3: {name: 'VTX_6', lapTime: curDate},
		gpio2: {name: 'VTX_7', lapTime: curDate},
		gpio0: {name: 'VTX_8', lapTime: curDate}
	}
}

module.exports = vtx_sensor;
