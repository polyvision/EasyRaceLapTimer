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

#include "networkserver.h"
#include "networkconnection.h"
#include <QTcpSocket>
#include <QProcess>
#include "logger.h"
 
NetworkServer::NetworkServer(QObject *parent) : QObject(parent)
{
    this->m_pTcpServer = new QTcpServer(this);
    this->m_pTcpServer->listen(QHostAddress::Any,3006);
    connect(m_pTcpServer, SIGNAL(newConnection()), this, SLOT(incommingConnection()));
    LOG_INFOS(LOG_FACILTIY_COMMON, "NetworkServer startup done, listening on port 3006\n");
}

void NetworkServer::incommingConnection(){
    NetworkConnection *clientConnection = new NetworkConnection(this->m_pTcpServer->nextPendingConnection(),this);
    connect(clientConnection, SIGNAL(incommingCommand(QString)), this, SLOT(incommingCommand(QString)));
}

void NetworkServer::incommingCommand(QString data){
    LOG_DBG(LOG_FACILTIY_COMMON, "incommingCommand: %s", qPrintable(data));

    if(data.compare("SHUTDOWN#") == 0){
      QString program = "shutdown";
      QStringList arguments;
      arguments << "-h" << "now";

      QProcess *myProcess = new QProcess(this);
      myProcess->start(program, arguments);
      return;
    }

    // we shall start a new race
    if(data.compare("START_NEW_RACE#") == 0){
        Q_EMIT startNewRaceEvent();
        return;
    }

    //we shall reset
    if(data.compare("RESET#") == 0){
        emit resetEvent();
        return;
    }

    // LAPTIME <TOKEN> <MS>
    if(data.contains("LAP_TIME")){
        QStringList list = data.split(" ");
        if(list.length() == 3){
            QString token = list[1];
            unsigned int ms = (unsigned int)list[2].replace("#","").toInt();
            emit newLapTimeEvent(token,ms);
        }
    }
}
