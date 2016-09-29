/**
 * EasyRaceLapTimer - Copyright 2015-2016 by airbirds.de, a project of polyvision UG (haftungsbeschränkt)
 *
 * This file is part of EasyRaceLapTimer.
 *
 * EasyRaceLapTimer is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 * EasyRaceLapTimer is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License along with Foobar. If not, see http://www.gnu.org/licenses/.
 **/

var ir_sensor = {};


ir_sensor.NUM_BITS = 9;
ir_sensor.ZERO_BIT_PULSE_WIDTH =  250;
ir_sensor.ONE_BIT_PULSE_WIDTH =   650;
ir_sensor.PULSE_WIDTH_TOLERANCE =   150;
ir_sensor.PULSE_WIDTH_MIN =   100;
ir_sensor.PULSE_WIDTH_MAX =   1000;

ir_sensor.process_signal = function(pin,delta){

    console.log("IR_SENSOR.process_signal pin: " + pin + " delta:" + delta);
    if(delta < ir_sensor.PULSE_WIDTH_MIN){
        console.log("IR_SENSOR.process_signal pin: " + pin + "MIN PULSE WIDTH");
        return;
    };

    if(delta > ir_sensor.PULSE_WIDTH_MAX){
        //console.log("IR_SENSOR.process_signal pin: " + pin + "MAX PULSE WIDTH");
        ir_sensor.reset_bits_for_pin(pin);
        return;
    };

    

    // checking for one bit
    if(delta > (ir_sensor.ONE_BIT_PULSE_WIDTH - ir_sensor.PULSE_WIDTH_TOLERANCE)){
        console.log("IR_SENSOR.process_signal pin: " + pin + " ONE BIT");
        ir_sensor.push_bit(pin,1);
        return;
    }else{
        console.log("IR_SENSOR.process_signal pin: " + pin + " ZERO BIT");
        ir_sensor.push_bit(pin,0);
    }
};

ir_sensor.push_bit = function(pin,bit){
    if (typeof(this.sensor_bits[pin]) == "undefined"){
        this.sensor_bits[pin] = [];    
    }
    this.sensor_bits[pin].push(bit);
    console.log("length:" + this.sensor_bits[pin]);
    if (this.sensor_bits[pin].length == ir_sensor.NUM_BITS){
        console.log("PIN" + pin + " BITS: " + this.sensor_bits[pin]);
    }
}

ir_sensor.reset_bits_for_pin = function(pin){
    this.sensor_bits[pin] = [];
}

ir_sensor.setup = function(wpi){
    this.wpi = wpi;

    this.sensor_bits = {};

    this.wpi.pinMode(1, this.wpi.INPUT);
    this.wpi.pullUpDnControl(1, this.wpi.PUD_UP);
    this.wpi.wiringPiISR(1, this.wpi.INT_EDGE_FALLING, function(delta) {
        ir_sensor.process_signal(1, delta)
    }.bind(this));

    console.log("IR_Sensor started, IR ready");
};

module.exports = ir_sensor;