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
#ifndef INFOSERVER_H
#define INFOSERVER_H

#include <QObject>
#include <QTcpSocket>
#include <QTcpServer>
#include <QList>
#include "singleton.h"

class InfoServer: public QObject,public Singleton<InfoServer> {
    Q_OBJECT
    Q_DISABLE_COPY(InfoServer)
public:
    InfoServer();
    void broadcastMessage(QString);

public Q_SLOTS:
    void newConnection();

private:
    QTcpServer *m_pTcpServer;
    QList<QTcpSocket*>m_pClientConnections;

    friend class Singleton<InfoServer>;
};
#endif
