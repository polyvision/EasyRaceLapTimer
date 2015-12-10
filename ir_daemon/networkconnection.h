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
#ifndef NETWORKCONNECTION_H
#define NETWORKCONNECTION_H

#include <QObject>
#include <QTcpSocket>

class NetworkConnection : public QObject {
    Q_OBJECT
    Q_DISABLE_COPY(NetworkConnection)
public:
    explicit NetworkConnection(QTcpSocket *socket,QObject *parent = 0);

signals:
    void incommingCommand(QString);

public Q_SLOTS:
    void readyRead();

private:
    QTcpSocket *m_pSocketConnection;
};

#endif // NETWORKCONNECTION_H
