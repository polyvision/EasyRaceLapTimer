/**
 * EasyRaceLapTimer - Copyright 2015-2016 by airbirds.de, a project of polyvision UG (haftungsbeschränkt)
 *
 * This file is part of EasyRaceLapTimer.
 *
 * EasyRaceLapTimer is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 * EasyRaceLapTimer is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License along with Foobar. If not, see http://www.gnu.org/licenses/.
 **/

var request = require('request')

var ir_sensor = {};
var laptime = {}
var last_token

ir_sensor.NUM_BITS = 9;
ir_sensor.ZERO_BIT_PULSE_WIDTH =  250;
ir_sensor.ONE_BIT_PULSE_WIDTH =   650;
ir_sensor.PULSE_WIDTH_TOLERANCE =   150;
ir_sensor.PULSE_WIDTH_MIN =   100;
ir_sensor.PULSE_WIDTH_MAX =   1000;

ir_sensor.process_signal = function(pin,delta){

    //console.log("IR_SENSOR.process_signal pin: " + pin + " delta:" + delta);
    if(delta < ir_sensor.PULSE_WIDTH_MIN){
        //console.log("IR_SENSOR.process_signal pin: " + pin + "MIN PULSE WIDTH");
        return;
    };

    if(delta > ir_sensor.PULSE_WIDTH_MAX){
        //console.log("IR_SENSOR.process_signal pin: " + pin + "MAX PULSE WIDTH");
        ir_sensor.reset_bits_for_pin(pin);
        return;
    };

    // checking for one bit
    if(delta > (ir_sensor.ONE_BIT_PULSE_WIDTH - ir_sensor.PULSE_WIDTH_TOLERANCE)){
        //console.log("IR_SENSOR.process_signal pin: " + pin + " ONE BIT");
        ir_sensor.push_bit(pin,1);
        return;
    }else{
        //console.log("IR_SENSOR.process_signal pin: " + pin + " ZERO BIT");
        ir_sensor.push_bit(pin,0);
    }
};

ir_sensor.push_bit = function(pin,bit){
    if (typeof(this.sensor_bits[pin]) == "undefined"){
        this.sensor_bits[pin] = [];
    }
    this.sensor_bits[pin].push(bit);
    //console.log("length:" + this.sensor_bits[pin]);
    if (this.sensor_bits[pin].length == ir_sensor.NUM_BITS){
        //console.log("PIN" + pin + " BITS: " + this.sensor_bits[pin]);
        var code = 0; var sum = 0
        for(i = 0; i < 6; i++) {
          code = (code << 1) | this.sensor_bits[pin][2 + i]
          sum += this.sensor_bits[pin][2 + i]
        }
        sum = sum & 1;
        if(sum == this.sensor_bits[pin][ir_sensor.NUM_BITS - 1]) {
                //console.log("code " + code + " sum " + sum)
                last_token = code
                trap(code)
        }
    }
}

trap = function(code) {
    var now = process.hrtime();
    var tnow = now[0] * 1000 + now[1] / 1000000
    t_time = laptime[code] || { enter: tnow, exit: tnow }
    if(tnow - t_time.exit > 5000) {
      result = tnow - t_time.enter
      t_time.enter = tnow
      console.log("lap time " + result)
      postlaptime(code, result)
    }
    t_time.exit = tnow
    laptime[code] = t_time
    //console.log(t_time)
}

postlaptime = function(token, time) {
  request({
    url: "http://localhost/api/v1/lap_track/create", //URL to hit
    qs: {transponder_token: token, lap_time_in_ms: Math.round(time)}, //Query string data
    method: 'GET'
  }, function(error, response, body){
      if(error) {
     console.log(error);
     } else {
     console.log(response.statusCode, body);
     }
    });
}

ir_sensor.reset_bits_for_pin = function(pin){
    this.sensor_bits[pin] = [];
}

ir_sensor.last_token = function() {
        return last_token
}

ir_sensor.reset = function() {
        laptime = {}
}

ir_sensor.setup = function(wpi){
    this.wpi = wpi;

    this.sensor_bits = {};

    this.wpi.pinMode(1, this.wpi.INPUT);
    this.wpi.pullUpDnControl(1, this.wpi.PUD_UP);
    this.wpi.wiringPiISR(1, this.wpi.INT_EDGE_BOTH, function(delta) {
        ir_sensor.process_signal(1, delta)
    }.bind(this));

    console.log("IR_Sensor started, IR ready");
};

module.exports = ir_sensor;
