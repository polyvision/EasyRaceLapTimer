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
#include "serialconnection.h"
#include "qextserialport/qextserialenumerator.h"
#include <QDebug>

SerialConnection::SerialConnection(QObject *parent) : QObject(parent)
{
    m_pSerialPort = NULL;
    m_bDebug= false;
}

void SerialConnection::setDebug(bool v){
    this->m_bDebug = v;
}

void SerialConnection::listAvailablePorts(){
    QList<QextPortInfo> portList = QextSerialEnumerator::getPorts();
    for(int i = 0; i < portList.size(); i++){
        printf("%i\t%s\t%s\n",i,portList.at(i).portName.toStdString().c_str(),portList.at(i).friendName.toStdString().c_str());
    }
}

void SerialConnection::setup(){
    QList<QextPortInfo> portList = QextSerialEnumerator::getPorts();

    this->m_pSerialPort = new QextSerialPort(portList[1].portName, QextSerialPort::EventDriven);
    m_pSerialPort->setBaudRate(BAUD115200);
    m_pSerialPort->setFlowControl(FLOW_OFF);
    m_pSerialPort->setParity(PAR_NONE);
    m_pSerialPort->setDataBits(DATA_8);
    m_pSerialPort->setStopBits(STOP_2);

    if (m_pSerialPort->open(QIODevice::ReadWrite) == true) {
        connect(m_pSerialPort, SIGNAL(readyRead()), this, SLOT(onReadyRead()));
        connect(m_pSerialPort, SIGNAL(dsrChanged(bool)), this, SLOT(onDsrChanged(bool)));

        if (!(m_pSerialPort->lineStatus() & LS_DSR)){
           qDebug() << "warning: device is not turned on";
        }
        qDebug() << "listening for data on" << m_pSerialPort->portName();

    }
    else {
        qDebug() << "device failed to open:" << m_pSerialPort->errorString();
    }
}

void SerialConnection::onReadyRead()
{
    QByteArray bytes;
    int a = this->m_pSerialPort->bytesAvailable();
    bytes.resize(a);
    this->m_pSerialPort->read(bytes.data(), bytes.size());

    if(this->m_bDebug){
        qDebug() << "bytes read:" << bytes.size();
        qDebug() << "bytes:" << bytes;
    }

    m_strIncommingData.append(QString(bytes).replace("\r","").replace("\n",""));
    //qDebug() << "before m_strIncommingData: " << m_strIncommingData;

    if(m_strIncommingData.contains("#")){
        QStringList list = m_strIncommingData.split("#");
        for(int i=0; i < list.length(); i++){
          QString t = list[i];
          if(t.length() > 0){
              this->processCmdString(t);
              m_strIncommingData = m_strIncommingData.remove(0,t.length()+1);
          }
        }

    }
    //qDebug() << "after m_strIncommingData: " << m_strIncommingData;
}

void SerialConnection::write(QString data){
  if(this->m_pSerialPort->isWritable()){
      this->m_pSerialPort->write(data.toLatin1());
  }
}

void SerialConnection::processCmdString(QString data){
  //qDebug() << "SerialConnection::processCmdString: " << data;

  if(data.compare("START_NEW_RACE") == 0){
      emit startNewRaceEvent();
      return;
  }

  if(data.compare("RESET") == 0){
      emit resetEvent();
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

void SerialConnection::onDsrChanged(bool status)
{
    if (status)
        qDebug() << "device was turned on";
    else
        qDebug() << "device was turned off";
}
