/**
 * EasyRaceLapTimer - Copyright 2015-2016 by airbirds.de, a project of polyvision UG (haftungsbeschränkt)
 *
 * Author: Alexander B. Bierbrauer
 *
 * This file is part of EasyRaceLapTimer.
 *
 * OpenRaceLapTimer is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 * OpenRaceLapTimer is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License along with Foobar. If not, see http://www.gnu.org/licenses/.
 **/
#include "gpioreader.h"
#include "Arduino.h"

#define PULSE_ONE	500
#define PULSE_MIN 100
#define PULSE_MAX 1000

#define DATA_BIT_LENGTH 9


GPIOReader::GPIOReader(int num_sensors)
{
  m_sensorCount  = num_sensors;
  mp_iSensorState = new int[num_sensors];
  mp_iSensorPin = new int[num_sensors];
  mp_uiSensorPulse = new unsigned int[num_sensors];

  for(int i = 0; i < m_sensorCount; i++){
    mp_iSensorState[i] = 0;
    mp_uiSensorPulse[i] = 0;
  }
}

void GPIOReader::setSensor(int sensor_i,int pin){
  mp_iSensorPin[sensor_i] = pin;
  pinMode(mp_iSensorPin[sensor_i], INPUT);
}

void GPIOReader::update(){
  for(int sensor_i = 0; sensor_i < m_sensorCount; sensor_i++){
    int current_sensor_pin = mp_iSensorPin[sensor_i];
    int t_state = digitalRead(current_sensor_pin);

    if(t_state != mp_iSensorState[sensor_i]){
            mp_iSensorState[sensor_i] = t_state;
            unsigned int c_time = micros();
            unsigned int c_pulse = c_time - mp_uiSensorPulse[sensor_i];

            // filter
            if(this->m_bDebugMode){
                //LOG_DBG(LOG_FACILTIY_COMMON, "sensor %i(%i): pulse %i",sensor_i, current_sensor_pin, c_pulse);
            }
            if(c_pulse >= PULSE_MIN && c_pulse <= PULSE_MAX){
              
                //push_bit_to_sensor_data(c_pulse,sensor_i);
            }else{
                // TODO //m_sensorData[sensor_i].clear();
            }
            
            mp_uiSensorPulse[sensor_i] = c_time;
    }
  }
}

