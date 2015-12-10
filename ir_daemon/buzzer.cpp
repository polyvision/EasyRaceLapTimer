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
#include <wiring_pi.h>
#include <stdio.h>
#include "buzzer.h"

Buzzer::Buzzer() {
    mui_activeTime = 0;
    mui_buzzerStartTime = 0;
    mi_outputPin = 0;
}

Buzzer::~Buzzer() {
}

void Buzzer::setPin(int p) {
    LOG_DBG(LOG_FACILTIY_COMMON, "Buzzer using pin %i\n",p);
    mi_outputPin = p;
    pinMode(mi_outputPin,OUTPUT);
    digitalWrite(mi_outputPin,LOW);
}

void Buzzer::activate(unsigned int ms) {
    mui_buzzerStartTime = millis();
    mui_activeTime = ms;
    digitalWrite(mi_outputPin,HIGH);
}

void Buzzer::update() {
    if(mui_activeTime == 0) {
        return;
    }

    if(mui_buzzerStartTime +  mui_activeTime < millis()) {
        digitalWrite(mi_outputPin,LOW);
        mui_activeTime = 0;
    } else {
        digitalWrite(mi_outputPin,HIGH);
    }
}

