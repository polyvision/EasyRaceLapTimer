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

#ifndef BUZZER_H
#define BUZZER_H

#include "singleton.h"
#include "logger.h"
#include <QObject>

class Buzzer: public Singleton<Buzzer> {
    Q_DISABLE_COPY(Buzzer)
public:
    Buzzer();
    ~Buzzer();
    void setPin(int);
    void activate(unsigned int ms);
    void update();

private:
    int mi_outputPin;
    unsigned int mui_activeTime;
    unsigned int mui_buzzerStartTime;

    friend class Singleton<Buzzer>;
};
#endif

