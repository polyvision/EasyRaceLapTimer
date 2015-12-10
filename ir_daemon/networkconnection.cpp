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

#include "networkconnection.h"

NetworkConnection::NetworkConnection(QTcpSocket *socket,QObject *parent) : QObject(parent)
{
    this->m_pSocketConnection = socket;
    connect(m_pSocketConnection, SIGNAL(disconnected()),this, SLOT(deleteLater()));
    connect(m_pSocketConnection,SIGNAL(readyRead()),this,SLOT(readyRead()));
}

void NetworkConnection::readyRead(){
    if(this->m_pSocketConnection->canReadLine()){
        QString data = m_pSocketConnection->readAll();

        data = data.replace("\n","").replace("\r","");
        emit incommingCommand(data);
    }
}

