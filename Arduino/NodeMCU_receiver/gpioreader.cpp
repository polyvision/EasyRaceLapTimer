/**
 * EasyRaceLapTimer - Copyright 2015-2016 by airbirds.de, a project of polyvision UG (haftungsbeschränkt)
 *
 * Author: Alexander B. Bierbrauer
 *
 * This file is part of EasyRaceLapTimer.
 *
 * EasyRaceLapTimer is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 * EasyRaceLapTimer is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License along with Foobar. If not, see http://www.gnu.org/licenses/.
 **/
#include "gpioreader.h"
#include "Arduino.h"


GPIOReader::GPIOReader()
{
  m_bDebugMode = false;

  for(int i = 0; i < NUM_MAX_SENSORS; i++){
    m_iSensorState[i] = 0;
    m_uiSensorPulse[i] = 0;
    for(int t = 0; t < DATA_BIT_LENGTH; t++){
      m_uiSensorData[i][t] = 0;
    }
    m_uiSensorDataCount[i] = 0;
  }
}

void GPIOReader::setDebug(bool v){
  m_bDebugMode = v;
  if(m_bDebugMode){
    Serial.println("GPIOReader enabled debugging mode");
  }
}

void GPIOReader::setSensor(int sensor_i,int pin){
  m_iSensorPin[sensor_i] = pin;
  pinMode(m_iSensorPin[sensor_i], INPUT);
}

void GPIOReader::resetSensor(int v){
  //mp_iSensorState[v] = 0;
  m_uiSensorPulse[v] = 0;
}

void GPIOReader::update(){
  for(int sensor_i = 0; sensor_i < NUM_MAX_SENSORS; sensor_i++){
    int current_sensor_pin = m_iSensorPin[sensor_i];
    int t_state = digitalRead(current_sensor_pin);

    if(t_state != m_iSensorState[sensor_i]){
            m_iSensorState[sensor_i] = t_state;
            unsigned long c_time = micros();
            unsigned long c_pulse = c_time - m_uiSensorPulse[sensor_i];

            // filter
            if(this->m_bDebugMode){
                Serial.print("sensor ");
                Serial.print(" i: ");
                Serial.print(sensor_i,DEC);
                Serial.print(" p: ");
                Serial.print(current_sensor_pin,DEC);
                Serial.print( " pulse: ");
                Serial.println(c_pulse,DEC);
            }
            if(c_pulse >= PULSE_MIN && c_pulse <= PULSE_MAX){
                this->pushBitToSensorData(c_pulse,sensor_i);
            }else{
                this->resetSensor(sensor_i);
            }
            
            m_uiSensorPulse[sensor_i] = c_time;
    }
  }
}

void GPIOReader::pushBitToSensorData(unsigned long pulse_width, int sensor_i){
  unsigned int bit = 0;
  if(pulse_width >= PULSE_ONE){
    bit = 1;
  }

  if(this->m_bDebugMode){
    Serial.print("sensor: ");
    Serial.print(sensor_i,DEC);
    Serial.print(" bit: ");
    Serial.println(bit,DEC);
  }
}

