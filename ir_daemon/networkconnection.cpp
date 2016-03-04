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

#include "networkconnection.h"

NetworkConnection::NetworkConnection(QTcpSocket *socket,QObject *parent) : QObject(parent)
{
    this->m_pSocketConnection = socket;
    connect(m_pSocketConnection, SIGNAL(disconnected()),this, SLOT(disconnected()));
    connect(m_pSocketConnection,SIGNAL(readyRead()),this,SLOT(readyRead()));
}

NetworkConnection::~NetworkConnection(){
    delete m_pSocketConnection;
}

void NetworkConnection::readyRead(){
    if(this->m_pSocketConnection != NULL && this->m_pSocketConnection->canReadLine()){
        QString data = m_pSocketConnection->readAll();

        data = data.replace("\n","").replace("\r","");
        emit incommingCommand(data);
    }
}

void NetworkConnection::write(QString data){
	if(m_pSocketConnection->state() == QAbstractSocket::ConnectedState){
		m_pSocketConnection->write(data.toLocal8Bit());
    	m_pSocketConnection->flush();
    	m_pSocketConnection->waitForBytesWritten(1000);
	}
}

void NetworkConnection::disconnected(){
    emit disconnectedSignal(this);
}