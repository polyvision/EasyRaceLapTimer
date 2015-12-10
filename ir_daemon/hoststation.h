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
#ifndef HOSTSTATION_H
#define HOSTSTATION_H

#include <QObject>
#include <QHash>
#include "singleton.h"

class HostStation : public QObject, public Singleton<HostStation> {
    Q_OBJECT
    Q_DISABLE_COPY(HostStation)
public:
    explicit HostStation(QObject *parent = 0);
    void setDebug(bool);
    void setup();

public Q_SLOTS:
    void eventStartNewRace();
    void eventReset();
    void eventNewLapTime(QString token, unsigned int ms);

private:
    void webRequestSatelliteTracked(QString token,unsigned int ms);
    void webRequestLapTimeTracked(QString token,unsigned int ms);
    void webRequestStartNewRace();

private:
    QHash<QString, unsigned int> m_hashLastTokenPush;
    bool m_bDebug;
    bool m_bSatelliteMode;

    friend class Singleton<HostStation>;
};

#endif // HOSTSTATION_H

