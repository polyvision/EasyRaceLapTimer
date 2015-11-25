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
#include <QtConcurrent>
#include "hoststation.h"
#include "gpioreader.h"
#include "networkserver.h"
#include "restart_button_input.h"
#include "serialconnection.h"
#include "gpioreader.h"
#include <curl/curl.h>

HostStation::HostStation(QObject *parent) : QObject(parent)
{

}

void HostStation::eventStartNewRace(){
    GPIOReader::instance()->reset();
    QtConcurrent::run(this, &HostStation::webRequestStartNewRace);
    SerialConnection::instance()->write("RESET#\n");
    printf("HostStation::eventStartNewRace\n");
}

void HostStation::eventReset(){
    GPIOReader::instance()->reset();
    printf("HostStation::eventReset\n");
}

void HostStation::setup(){
    NetworkServer *pNetworkServer = NetworkServer::instance();
    SerialConnection *pSerialConnection = SerialConnection::instance();
    GPIOReader *pGPIOReader = GPIOReader::instance();

    // network connection signals
    connect(pNetworkServer,SIGNAL(startNewRaceEvent()),this,SLOT(eventStartNewRace()));
    connect(pNetworkServer,SIGNAL(resetEvent()),this,SLOT(eventReset()));
    connect(pNetworkServer,SIGNAL(newLapTimeEvent(QString,unsigned int)),this,SLOT(eventNewLapTime(QString,unsigned int)));

    // serial connection signals
    connect(pSerialConnection,SIGNAL(startNewRaceEvent()),this,SLOT(eventStartNewRace()));
    connect(pSerialConnection,SIGNAL(resetEvent()),this,SLOT(eventReset()));
    connect(pSerialConnection,SIGNAL(newLapTimeEvent(QString,unsigned int)),this,SLOT(eventNewLapTime(QString,unsigned int)));

    //gpio reader connection signals
    connect(pGPIOReader,SIGNAL(newLapTimeEvent(QString,unsigned int)),this,SLOT(eventNewLapTime(QString,unsigned int)));

    connect(RestartButtonInput::instance(),SIGNAL(restartEvent()),this,SLOT(eventStartNewRace()));

    printf("HostStation setup done\n");
}

void HostStation::eventNewLapTime(QString token, unsigned int ms){
    printf("HostStation::eventNewLapTime %s %u\n",token.toStdString().c_str(),ms);
    QtConcurrent::run(this, &HostStation::webRequestLapTimeTracked,token,ms);
}

void HostStation::webRequestLapTimeTracked(QString token,unsigned int ms){
    CURL *curl;
    CURLcode res;

    curl = curl_easy_init();
      if(curl) {
        /* First set the URL that is about to receive our POST. This URL can
           just as well be a https:// URL if that is what should receive the
           data. */
        curl_easy_setopt(curl, CURLOPT_URL, QString("http://localhost/api/v1/lap_track/create?transponder_token=%1&lap_time_in_ms=%2").arg(token).arg(ms).toStdString().c_str());



        /* Perform the request, res will get the return code */
        res = curl_easy_perform(curl);
        /* Check for errors */
        if(res != CURLE_OK){
            fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
        }


        /* always cleanup */
        curl_easy_cleanup(curl);
      }
}

void HostStation::webRequestStartNewRace(){
    CURL *curl;
    CURLcode res;

    curl = curl_easy_init();
      if(curl) {
        /* First set the URL that is about to receive our POST. This URL can
           just as well be a https:// URL if that is what should receive the
           data. */
        curl_easy_setopt(curl, CURLOPT_URL, QString("http://localhost/api/v1/race_session/new").toStdString().c_str());



        /* Perform the request, res will get the return code */
        res = curl_easy_perform(curl);
        /* Check for errors */
        if(res != CURLE_OK){
            fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
        }


        /* always cleanup */
        curl_easy_cleanup(curl);
      }
}
