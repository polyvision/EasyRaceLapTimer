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
#ifndef CONFIGURATION_H
#define CONFIGURATION_H

#include <QString>
#include <QSettings>
#include "singleton.h"
#include "logger.h"

class Configuration: public Singleton<Configuration> {
    Q_DISABLE_COPY(Configuration)
public:
    Configuration();

    void setLogSeverity(Severity sev);
    Severity logSeverity();

    void setLogLocations(quint8 loc);
    quint8 logLocations();

    void setDebug(bool debug);
    bool debug();

    void setComPortIndex(int);
    int comPortIndex();

    void setSensorCount(int);
    int sensorCount();

    void setSensorPin(int,int);
    int  sensorPin(int);

    void setBuzzerPin(int);
    int buzzerPin();

    void setRestartButtonPin(int);
    int restartButtonPin();

    QString webHost();
    void setWebHost(const QString &);
    void setSatelliteMode(bool);
    bool satelliteMode();
private:
    QSettings *mp_settings;

    friend class Singleton<Configuration>;
};
#endif

