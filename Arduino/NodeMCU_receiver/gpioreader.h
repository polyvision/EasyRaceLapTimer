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
#ifndef GPIOREADER_H
#define GPIOREADER_H

#define NUM_MAX_SENSORS 1
#define PULSE_ONE  500
#define PULSE_MIN 100
#define PULSE_MAX 1000

#define DATA_BIT_LENGTH 9

class GPIOReader{
    
public:
    GPIOReader();

    void setSensor(int,int);
    void setDebug(bool);
    void update();
    //unsigned int num_ones_in_buffer(QList<int> &list);
    //void print_binary_list(QList<int> &list);
    //void push_to_service(int sensor_i,QList<int> &list, int control_bit);
    void pushBitToSensorData(unsigned long pulse_width, int sensor_i);
    void reset();


private:
    void resetSensor(int);
    bool m_bDebugMode;
    int m_iSensorState[NUM_MAX_SENSORS];
    int m_iSensorPin[NUM_MAX_SENSORS];
    unsigned long m_uiSensorPulse[NUM_MAX_SENSORS];
    unsigned int m_uiSensorData[NUM_MAX_SENSORS][DATA_BIT_LENGTH];
    unsigned int m_uiSensorDataCount[NUM_MAX_SENSORS];
    
};

#endif // GPIOREADER_H

