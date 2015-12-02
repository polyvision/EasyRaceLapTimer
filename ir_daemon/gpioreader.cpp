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
	this->sensor_pins[0] = Configuration::instance()->sensorPin(0);
	this->sensor_pins[1] = Configuration::instance()->sensorPin(1);
	this->sensor_pins[2] = Configuration::instance()->sensorPin(2);

	printf("GPIOReader:: sensor pin 1: %i\n",this->sensor_pins[0]);
	printf("GPIOReader:: sensor pin 2: %i\n",this->sensor_pins[1]);
	printf("GPIOReader:: sensor pin 3: %i\n",this->sensor_pins[2]);

    this->m_bDebugMode = false;
    pinMode(this->sensor_pins[0],INPUT);
    pinMode(this->sensor_pins[1],INPUT);
    pinMode(this->sensor_pins[2],INPUT);

    for(int sensor_i = 0; sensor_i < 3; sensor_i++){
        this->sensor_state[sensor_i] = 0;
        this->sensor_pulse[sensor_i] = 0;
        this->sensor_start_lap_time[sensor_i] = 0;
    }
}

void GPIOReader::reset(){
    for(int sensor_i = 0; sensor_i < 3; sensor_i++){
        this->sensor_state[sensor_i] = 0;
        this->sensor_pulse[sensor_i] = 0;
        this->sensor_start_lap_time[sensor_i] = 0;
        this->sensor_data[sensor_i].clear();
    }
    printf("GPIOReader::resetted\n");
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
            printf("1");
        }else{
            printf("0");
        }
    }
    printf("\n");
}

void GPIOReader::push_to_service(int sensor_i,QList<int>& list,unsigned int delta_time,int control_bit){
    unsigned int val_to_push = 0;
    print_binary_list(list);

    list.removeFirst();
    list.removeFirst();
    list.removeLast();
    //printf("list length: %i\n",list.length());
    for(int i=0; i < list.length(); i++){
        if(list[i] == 1){
            BIT_SET(val_to_push,list.length() - i -1);
        }else{
            BIT_CLEAR(val_to_push,list.length() -i - 1 );
        }
    }

    //printf("after: ");
    //print_binary_list(list);
    //qDebug() << "result binary:" << QString::number(val_to_push,2) << "\n";
    //qDebug() << "ones in buffer " << num_ones_in_buffer(list) << "\n";
    int own_control_bit = (int)num_ones_in_buffer(list) % 2;

    if(control_bit == own_control_bit){
        printf("sensor: %i token: %u time: %u\n",sensor_i,val_to_push,delta_time);
        Buzzer::instance()->activate(BUZZER_ACTIVE_TIME_IN_MS);
        emit newLapTimeEvent(QString("%1").arg(val_to_push),delta_time);
    }else{
        printf("sensor: %i control bit wrong: %i own_control_bit: %i, token: %u\n",sensor_i,control_bit,own_control_bit,val_to_push);
    }
}

void GPIOReader::push_bit_to_sensor_data(unsigned int pulse_width,int sensor_i){
    if(pulse_width >= PULSE_ONE){

        sensor_data[sensor_i] << 1;
        //printf("ONE %i\n",pulse_width);
    }else{

        //printf("ZERO %i\n",pulse_width);
        sensor_data[sensor_i] << 0;
    }

    if(sensor_data[sensor_i].length() == DATA_BIT_LENGTH){
        // first two bytes have to be zero
        if(sensor_data[sensor_i][0] == 0 && sensor_data[sensor_i][1] == 0){
            //print_binary_list(sensor_data[sensor_i]);


            // check if there's a tracked time for the current sensor_data
            // if yes, push it
            if(sensor_start_lap_time[sensor_i] != 0)
            {
                unsigned int diff = millis() - sensor_start_lap_time[sensor_i];
                if(diff > 1000){ // only push if there's difference of 2 seconds between tracking
                    push_to_service(sensor_i,sensor_data[sensor_i],diff,sensor_data[sensor_i].last());
                    sensor_start_lap_time[sensor_i] = 0;
                }
            }
            else
            {
                sensor_start_lap_time[sensor_i] = millis();
            }

            sensor_data[sensor_i].clear();
        }else{
            sensor_data[sensor_i].removeFirst();
        }
    }
}

void GPIOReader::update(){
    for(int sensor_i = 0; sensor_i < 3; sensor_i++){

        int pid_input = this->sensor_pins[0];
        switch(sensor_i){
            case 0:
                pid_input = this->sensor_pins[0];
                break;
            case 1:
                pid_input = this->sensor_pins[1];
                break;
            case 2:
                pid_input = this->sensor_pins[2];
                break;
        }

        int state = digitalRead(pid_input);

        if(state != sensor_state[sensor_i]){
            sensor_state[sensor_i] = state;
            unsigned int c_time = micros();
            unsigned int c_pulse = c_time - sensor_pulse[sensor_i];

            if(this->m_bDebugMode){
                printf("sensor %i(%i): pulse %i\n",sensor_i,pid_input,c_pulse);
            }
            if(c_pulse >= PULSE_MIN && c_pulse <= PULSE_MAX){
                push_bit_to_sensor_data(c_pulse,sensor_i);
            }else{
                sensor_data[sensor_i].clear();
            }
            sensor_pulse[sensor_i] = c_time;
        }
    }
}
