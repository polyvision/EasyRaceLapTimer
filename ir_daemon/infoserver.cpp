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
#include "infoserver.h"
#include "logger.h"
#include "hoststation.h"

InfoServer::InfoServer() : QObject(0)
{
	this->m_pTcpServer = new QTcpServer(this);
    this->m_pTcpServer->listen(QHostAddress::Any,3007);
    connect(m_pTcpServer, SIGNAL(newConnection()), this, SLOT(newConnection()));
    LOG_INFOS(LOG_FACILTIY_COMMON, "InfoServer startup done, listening on port 3007\n");
}

void InfoServer::newConnection(){
	
	NetworkConnection *clientConnection = new NetworkConnection(this->m_pTcpServer->nextPendingConnection(),this);
    connect(clientConnection, SIGNAL(incommingCommand(QString)), this, SLOT(incommingCommand(QString)));
    connect(clientConnection, SIGNAL(disconnectedSignal(NetworkConnection*)),this, SLOT(disconnectedClient(NetworkConnection*)));

	this->m_pClientConnections.append(clientConnection);
}

void InfoServer::broadcastMessage(QString msg){
	for (int i = 0; i < this->m_pClientConnections.size(); ++i) {
		m_pClientConnections[i]->write(QString("%1#\n").arg(msg));
	}
}

void InfoServer::incommingCommand(QString data){
    if(data.compare("LAST_SCANNED_TOKEN#") == 0){
        this->broadcastMessage(QString("%1").arg(HostStation::instance()->lastScannedToken()));
        return;
    }
}

void InfoServer::disconnectedClient(NetworkConnection* client){
	this->m_pClientConnections.removeOne(client);
	delete client;
}