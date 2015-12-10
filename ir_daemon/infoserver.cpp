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
#include "infoserver.h"
#include "logger.h"

InfoServer::InfoServer() : QObject(0)
{
	this->m_pTcpServer = new QTcpServer(this);
    this->m_pTcpServer->listen(QHostAddress::Any,3007);
    connect(m_pTcpServer, SIGNAL(newConnection()), this, SLOT(newConnection()));
    LOG_INFOS(LOG_FACILTIY_COMMON, "InfoServer startup done, listening on port 3007\n");
}

void InfoServer::newConnection(){
	this->m_pClientConnections.append(this->m_pTcpServer->nextPendingConnection());
}

void InfoServer::broadcastMessage(QString msg){
	for (int i = 0; i < this->m_pClientConnections.size(); ++i) {
		if(m_pClientConnections[i]->state() == QAbstractSocket::ConnectedState){
			m_pClientConnections[i]->write(QString("%1#\n").arg(msg).toLocal8Bit());
    		m_pClientConnections[i]->flush();
    		m_pClientConnections[i]->waitForBytesWritten(1000);
		}
	}
}

