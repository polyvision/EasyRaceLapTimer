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

#include "restart_button_input.h"
#include <stdio.h>
#include <curl/curl.h>
#include <QtConcurrent>
#include "buzzer.h"
#include "wiring_pi.h"
#include "logger.h"

RestartButtonInput::RestartButtonInput(QObject *parent) : QObject(parent){
	m_uiPushedButtonTime = 0;
	m_uiPushedButtonLastAt = 0;
	m_bActive = false;
}

void RestartButtonInput::setPin(int pin){
    LOG_INFO(LOG_FACILTIY_COMMON, "restart button using pin %i", pin);
    this->m_iInputPin = pin;
    pinMode(this->m_iInputPin,INPUT);
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
        Q_EMIT restartEvent();
	}

}
