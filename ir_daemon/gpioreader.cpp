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
#include <wiring_pi.h>
#include "buzzer.h"
#include "configuration.h"
#include <stdio.h>

//#define	IR_LED_1	1
//#define	IR_LED_2	4
//#define	IR_LED_3	5

#define PULSE_ONE	500
#define PULSE_MIN 100
#define PULSE_MAX 1000

#define DATA_BIT_LENGTH 9

#define BUZZER_ACTIVE_TIME_IN_MS 100

GPIOReader::GPIOReader()
{
    m_sensorCount = Configuration::instance()->sensorCount();
    for(int i = 0; i < m_sensorCount; i++) {

    }
}

bool GPIOReader::init()
{
    for(int i = 0; i < m_sensorCount; i++) {
        m_sensorPins.append(Configuration::instance()->sensorPin(i));
        if(this->m_sensorPins[i] < 0) {
            LOG_ERROR(LOG_FACILTIY_COMMON, "GPIOReader:: invalid sensor pin configuration at gpio_reader/pin_%d", i);
            return false;
        }
    }

    for(int i = 0; i < m_sensorCount; i++)
        LOG_INFO(LOG_FACILTIY_COMMON, "GPIOReader:: sensor pin %d: %i",this->m_sensorPins[i], i+1);

    this->m_bDebugMode = false;
    for(int i = 0; i < m_sensorCount; i++)
        pinMode(this->m_sensorPins[i],INPUT);

    for(int sensor_i = 0; sensor_i < m_sensorCount; sensor_i++){
        m_sensorState.append(sensor_i);
        m_sensorPulse.append(sensor_i);

        this->m_sensorState[sensor_i] = 0;
        this->m_sensorPulse[sensor_i] = 0;

        m_sensorData.append(QList<int>());
    }

    return true;
}

void GPIOReader::reset(){
    for(int sensor_i = 0; sensor_i < m_sensorCount; sensor_i++){
        this->m_sensorState[sensor_i] = 0;
        this->m_sensorPulse[sensor_i] = 0;
        this->m_sensorData[sensor_i].clear();
    }
    m_sensoredTimes.clear();
    LOG_INFOS(LOG_FACILTIY_COMMON, "GPIOReader::resetted");
}

void GPIOReader::setDebug(bool v){
    this->m_bDebugMode = v;
}

unsigned int GPIOReader::num_ones_in_buffer(QList<int>& list){
    unsigned int t= 0;
    for(int i=0; i < list.length(); i++){ // -1 because we don't count the last bit.. it's the checksum bit!
        if(list[i] == 1){
            t += 1;
        }
    }
    return t;
}


void GPIOReader::print_binary_list(QList<int>& list){
    for(int i=0; i < list.length(); i++){
        if(list[i] == 1){
            LOG_DBGS(LOG_FACILTIY_COMMON, "1");
        }else{
            LOG_DBGS(LOG_FACILTIY_COMMON, "0");
        }
    }
}

void GPIOReader::push_to_service(int sensor_i,QList<int>& list,int control_bit){
    unsigned int val_to_push = 0;
    if(this->m_bDebugMode){
    	print_binary_list(list);
    }

    list.removeFirst();
    list.removeFirst();
    list.removeLast();

    for(int i=0; i < list.length(); i++){
        if(list[i] == 1){
            BIT_SET(val_to_push,list.length() - i -1);
        }else{
            BIT_CLEAR(val_to_push,list.length() -i - 1 );
        }
    }

    int own_control_bit = (int)num_ones_in_buffer(list) % 2;

    if(control_bit == own_control_bit){
        QString token = QString("%1").arg(val_to_push);

        if(m_sensoredTimes[token] == 0){
        	m_sensoredTimes[token] = millis();
        }else if(m_sensoredTimes[token] + 1000 < millis()){
        	unsigned int delta_time = millis() - m_sensoredTimes[token];
        	Buzzer::instance()->activate(BUZZER_ACTIVE_TIME_IN_MS);
        	emit newLapTimeEvent(token,delta_time);
        	m_sensoredTimes[token] = millis();
        }
        
    }else{
        LOG_WARN(LOG_FACILTIY_COMMON, "sensor: %i control bit wrong: %i own_control_bit: %i, token: %u",sensor_i,control_bit,own_control_bit,val_to_push);
    }
}

void GPIOReader::push_bit_to_sensor_data(unsigned int pulse_width,int sensor_i){
    if(pulse_width >= PULSE_ONE){
        m_sensorData[sensor_i] << 1;
    } else {
        m_sensorData[sensor_i] << 0;
    }

    if(m_sensorData[sensor_i].length() == DATA_BIT_LENGTH){
        // first two bytes have to be zero
        if(m_sensorData[sensor_i][0] == 0 && m_sensorData[sensor_i][1] == 0){
            //print_binary_list(sensor_data[sensor_i]);
            push_to_service(sensor_i,m_sensorData[sensor_i],m_sensorData[sensor_i].last());
            m_sensorData[sensor_i].clear();
        }else{
            m_sensorData[sensor_i].removeFirst();
        }
    }
}

void GPIOReader::update(){
    for(int sensor_i = 0; sensor_i < m_sensorCount; sensor_i++){

        int pid_input = this->m_sensorPins[sensor_i];

        int state = digitalRead(pid_input);

        if(state != m_sensorState[sensor_i]){
            m_sensorState[sensor_i] = state;
            unsigned int c_time = micros();
            unsigned int c_pulse = c_time - m_sensorPulse[sensor_i];

            if(this->m_bDebugMode){
                LOG_DBG(LOG_FACILTIY_COMMON, "sensor %i(%i): pulse %i",sensor_i, pid_input, c_pulse);
            }
            if(c_pulse >= PULSE_MIN && c_pulse <= PULSE_MAX){
                push_bit_to_sensor_data(c_pulse,sensor_i);
            }else{
                m_sensorData[sensor_i].clear();
            }
            m_sensorPulse[sensor_i] = c_time;
        }
    }
}
