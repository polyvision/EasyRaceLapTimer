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
#ifndef NETWORKSERVER_H
#define NETWORKSERVER_H

#include <QObject>
#include <QTcpServer>
#include "singleton.h"

class NetworkServer : public QObject, public Singleton<NetworkServer>
{
    friend class Singleton<NetworkServer>;
    Q_OBJECT
    
public:
    explicit NetworkServer(QObject *parent = 0);

signals:
    void    startNewRaceEvent();
    void    resetEvent();
    void    newLapTimeEvent(QString,unsigned int);

public slots:
    void    incommingConnection();
    void    incommingCommand(QString);
private:
    QTcpServer  *m_pTcpServer;
};

#endif // NETWORKSERVER_H
