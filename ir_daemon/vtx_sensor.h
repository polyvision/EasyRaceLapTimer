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

#ifndef VTX_SENSOR_H
#define VTX_SENSOR_H
#include <QObject>
#include "singleton.h"
#include <QHash>

class VTXSensor: public QObject, public Singleton<VTXSensor> {
    Q_OBJECT
    Q_DISABLE_COPY(VTXSensor)
public:
    VTXSensor();

    bool init();
    void update();
    void reset();
Q_SIGNALS:
    void newLapTimeEvent(QString,unsigned int);

private:
    void processSensor(unsigned int sensor);
    unsigned int m_iSensorPins[8];
    unsigned int m_iSensorStates[8];
    unsigned int m_iSensorHighTimes[8];
    unsigned int m_iSensorLastTrackedTime[8];
};
#endif
