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

class GPIOReader{
    
public:
    GPIOReader(int num_sensors);

    void setSensor(int,int);
    void setDebug(bool);
    void update();
    //unsigned int num_ones_in_buffer(QList<int> &list);
    //void print_binary_list(QList<int> &list);
    //void push_to_service(int sensor_i,QList<int> &list, int control_bit);
    void push_bit_to_sensor_data(unsigned int pulse_width, int sensor_i);
    void reset();


private:
    int m_sensorCount;
    bool m_bDebugMode;
    int *mp_iSensorState;
    int *mp_iSensorPin;
    unsigned int *mp_uiSensorPulse;
    
};

#endif // GPIOREADER_H

