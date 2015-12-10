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
#ifndef SERIALCONNECTION_H
#define SERIALCONNECTION_H

#include <QObject>
#include <singleton.h>
#include "qextserialport/qextserialport.h"

class SerialConnection : public QObject, public Singleton<SerialConnection> {
    Q_OBJECT
    Q_DISABLE_COPY(SerialConnection)
public:
    explicit SerialConnection(QObject *parent = 0);

    static void listAvailablePorts();
    void setup();
    void setDebug(bool);
    void write(QString);

Q_SIGNALS:
    void startNewRaceEvent();
    void resetEvent();
    void newLapTimeEvent(QString,unsigned int);

public Q_SLOTS:
    void onReadyRead();
    void onDsrChanged(bool);

private:
    QString m_strIncommingData;
    QextSerialPort *m_pSerialPort;
    bool m_bDebug;

private:
    void processCmdString(QString);

    friend class Singleton<SerialConnection>;
};

#endif // SERIALCONNECTION_H

