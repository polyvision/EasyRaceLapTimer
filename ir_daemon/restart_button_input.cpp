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
#include <QDebug>
#include <wiringPi.h>
#include "restart_button_input.h"
#include <curl/curl.h>
#include <QtConcurrent>
#include "buzzer.h"

void fireEventStartNewRace(){
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
	  printf("requested new race\n");
	  Buzzer::instance()->activate(1000);
}

RestartButtonInput::RestartButtonInput(int pin){
	this->m_iInputPin = pin;
	pinMode(this->m_iInputPin,INPUT);
	m_uiPushedButtonTime = 0;
	m_uiPushedButtonLastAt = 0;
	m_bActive = false;
}

void RestartButtonInput::update(){
	if(m_uiPushedButtonLastAt + 6000 > millis()){
		return;
	}
	
	int state = digitalRead(this->m_iInputPin);
	if(m_bActive == false && state == 1){
		m_bActive = true;
		m_uiPushedButtonTime = millis();
	}
	
	
	if(m_bActive && m_uiPushedButtonTime + 1000 < millis()){
		m_bActive = false;
		m_uiPushedButtonTime = 0;
		m_uiPushedButtonLastAt = millis();
		printf("requesting new race\n");
		QtConcurrent::run(fireEventStartNewRace);
	}
	
}