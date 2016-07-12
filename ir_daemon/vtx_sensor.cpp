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
#include "vtx_sensor.h"
#include <wiringPi.h>
#include "buzzer.h"
#include "configuration.h"

#define VTX_SENSOR_PIN_1 25
#define VTX_SENSOR_PIN_2 24
#define VTX_SENSOR_PIN_3 23
#define VTX_SENSOR_PIN_4 22
#define VTX_SENSOR_PIN_5 21
#define VTX_SENSOR_PIN_6 3
#define VTX_SENSOR_PIN_7 2
#define VTX_SENSOR_PIN_8 0

#define VTX_MIN_UP_TIME 25

#define BUZZER_ACTIVE_TIME_IN_MS 100

void vtxInterruptSensor1 (void) {
  LOG_INFO(LOG_FACILTIY_COMMON, "VTXSensor:: interrupt 1 PIN %i",VTX_SENSOR_PIN_1);
}

void vtxInterruptSensor2 (void) {
}

void vtxInterruptSensor3 (void) {
}

void vtxInterruptSensor4 (void) {
}

void vtxInterruptSensor5 (void) {
}

void vtxInterruptSensor6 (void) {
}

void vtxInterruptSensor7 (void) {
}

void vtxInterruptSensor8 (void) {
}

VTXSensor::VTXSensor(){
 m_iSensorPins[0] = VTX_SENSOR_PIN_1;
 m_iSensorPins[1] = VTX_SENSOR_PIN_2;
 m_iSensorPins[2] = VTX_SENSOR_PIN_3;
 m_iSensorPins[3] = VTX_SENSOR_PIN_4;
 m_iSensorPins[4] = VTX_SENSOR_PIN_5;
 m_iSensorPins[5] = VTX_SENSOR_PIN_6;
 m_iSensorPins[6] = VTX_SENSOR_PIN_7;
 m_iSensorPins[7] = VTX_SENSOR_PIN_8;


 for(int i = 0; i < 8; i++){
   m_iSensorStates[i] = 0;
   m_iSensorHighTimes[i] = 0;
   m_iSensorLastTrackedTime[i] = 0;
 }
}


void VTXSensor::reset(){
  for(int i = 0; i < 8; i++){
    m_iSensorStates[i] = 0;
    m_iSensorHighTimes[i] = 0;
    m_iSensorLastTrackedTime[i] = 0;
  }
}

 bool VTXSensor::init(){
    for(int i = 0; i < 8; i++){
      pinMode(m_iSensorPins[i],INPUT);
      pullUpDnControl(m_iSensorPins[i],PUD_UP);
    }


    LOG_INFOS(LOG_FACILTIY_COMMON, "VTXSensor:: initialized VTX sensoring");
    return true;
 }

 void VTXSensor::update(){
    for(int i = 0; i < 8; i++){
      this->processSensor(i);
    }
 }

 void VTXSensor::processSensor(unsigned int s_index){
   unsigned int pin = m_iSensorPins[s_index];

   if(digitalRead(pin) == 1 && m_iSensorStates[s_index] == 0){
     m_iSensorStates[s_index] = 1;
     m_iSensorHighTimes[s_index] = millis();
   }else if(digitalRead(pin) == 0){
     if(m_iSensorStates[s_index] == 1){
       unsigned int up_time = millis() - m_iSensorHighTimes[s_index];
       //LOG_INFO(LOG_FACILTIY_COMMON, "VTXSensor:: switched %i",up_time);
       if( up_time >= VTX_MIN_UP_TIME){

         if(m_iSensorLastTrackedTime[s_index] > 0){
           unsigned long l_time = m_iSensorLastTrackedTime[s_index];
           m_iSensorLastTrackedTime[s_index] = millis();

           unsigned long tracked_time = m_iSensorLastTrackedTime[s_index] - l_time;

           if(tracked_time > 1000){
              LOG_INFO(LOG_FACILTIY_COMMON, "VTXSensor:: triggered sensor %i PIN %i LAP_TIME %i",s_index,pin,tracked_time);
              Buzzer::instance()->activate(BUZZER_ACTIVE_TIME_IN_MS);
            	emit newLapTimeEvent(QString("VTX_%1").arg(s_index+1),tracked_time);
           }

         }else{
           m_iSensorLastTrackedTime[s_index] = millis();
           LOG_INFO(LOG_FACILTIY_COMMON, "VTXSensor:: triggered sensor %i PIN %i",s_index,pin);
         }

       }
     }

     // resetting
     m_iSensorStates[s_index] = 0;
     m_iSensorHighTimes[s_index] = 0;
   }
 }
