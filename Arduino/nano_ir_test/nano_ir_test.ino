/**
 * EasyRaceLapTimer - Copyright 2015-2016 by airbirds.de, a project of polyvision UG (haftungsbeschränkt)
 *
 * Author: Alexander B. Bierbrauer
 *
 * This file is part of EasyRaceLapTimer.
 * 
 * Arduino testing code, e.g. Nano
 * 
 * Vresion: 0.2
 *
 * OpenRaceLapTimer is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 * OpenRaceLapTimer is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License along with Foobar. If not, see http://www.gnu.org/licenses/.
 **/
#include <IRremote.h>
#include <IRremoteInt.h>

IRsend irsend;

#define BIT_SET(a,b) ((a) |= (1<<(b)))
#define BIT_CLEAR(a,b) ((a) &= ~(1<<(b)))
#define BIT_FLIP(a,b) ((a) ^= (1<<(b)))
#define BIT_CHECK(a,b) ((a) & (1<<(b)))

#define TRANSPONDER_ID 2
#define NUM_BITS  9
#define ZERO 250
#define ONE  650

unsigned int buffer[NUM_BITS];
unsigned int num_one_pulses = 0;

unsigned int get_pulse_width_for_buffer(int bit){
  if(BIT_CHECK(TRANSPONDER_ID,bit)){
    return ONE;
  }

  return ZERO;
}

unsigned int control_bit(){
  if(num_one_pulses % 2 >= 1){
    return ONE;  
  }else{
    return ZERO;
  }
}

void setup() {
  pinMode(13, OUTPUT);
  Serial.begin(9600);
  
  buffer[0] = ZERO;    
  buffer[1] = ZERO;    
  buffer[2] = get_pulse_width_for_buffer(5);
  buffer[3] = get_pulse_width_for_buffer(4);
  buffer[4] = get_pulse_width_for_buffer(3);
  buffer[5] = get_pulse_width_for_buffer(2);
  buffer[6] = get_pulse_width_for_buffer(1);
  buffer[7] = get_pulse_width_for_buffer(0);
  buffer[8] = control_bit();  
  

  for(int i= 0; i < NUM_BITS; i++){
    Serial.println(buffer[i],DEC);
  }
  Serial.println(TRANSPONDER_ID,BIN);
}

void loop() {
   for(int i = 0; i < 3; i++){
    irsend.sendRaw(buffer,NUM_BITS,38);
    digitalWrite(13, HIGH);   // turn the LED on (HIGH is the voltage level)
    delay(20 + random(0, 5));
    digitalWrite(13, LOW);    // turn the LED off by making the voltage LOW
   }
}
