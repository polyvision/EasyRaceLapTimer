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
#ifndef GPIOREADER_H
#define GPIOREADER_H

#include <QObject>
#include "singleton.h"
#include <QHash>

class GPIOReader: public QObject, public Singleton<GPIOReader> {
    Q_OBJECT
    Q_DISABLE_COPY(GPIOReader)
public:
    GPIOReader();

    bool init();

    void setDebug(bool);
    void update();
    unsigned int num_ones_in_buffer(QList<int> &list);
    void print_binary_list(QList<int> &list);
    void push_to_service(int sensor_i,QList<int> &list, int control_bit);
    void push_bit_to_sensor_data(unsigned int pulse_width, int sensor_i);
    void reset();

Q_SIGNALS:
    void newLapTimeEvent(QString,unsigned int);

private:
    int m_sensorCount;
    bool m_bDebugMode;
    QList<int> m_sensorState;
    QList<int> m_sensorPins;
    QList<unsigned int> m_sensorPulse;
    QHash<QString, unsigned int> m_sensoredTimes;
    QList<QList<int> > m_sensorData;

    friend class Singleton<GPIOReader>;
};

#endif // GPIOREADER_H

