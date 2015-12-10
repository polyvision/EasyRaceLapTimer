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

#include <QtCore/QCoreApplication>
#include <stdio.h>
#include <QProcess>
#include <QTextStream>
#include <QtConcurrent>
#include <curl/curl.h>
#include "restart_button_input.h"
#include "buzzer.h"
#include "gpioreader.h"
#include "networkserver.h"
#include "hoststation.h"
#include "serialconnection.h"
#include "configuration.h"
#include "infoserver.h"
#include "logger.h"

#define VERSION "0.4"

#include <wiring_pi.h>

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    QCoreApplication::setOrganizationName("polyvision UG");
    QCoreApplication::setOrganizationDomain("polyvision.org");
    QCoreApplication::setApplicationName("ir_daemon");

    curl_global_init(CURL_GLOBAL_ALL);

    Logger::instance()->init();
	
    LOG_INFO(LOG_FACILTIY_COMMON, "starting ir_daemon v%s\n", VERSION);

	if(a.arguments().count() > 1){
        if(a.arguments().at(1).compare("--debug") == 0){
            Configuration::instance()->setDebug(true);
            LOG_DBGS(LOG_FACILTIY_COMMON, "enabled debug mode");
		}

        if(a.arguments().at(1).compare("--list_serial_ports") == 0){
            SerialConnection::listAvailablePorts();
            return 0;
        }

        if(a.arguments().at(1).compare("--set_com_port_index") == 0){
            Configuration::instance()->setComPortIndex(a.arguments().at(2).toInt());
            return 0;
        }

        if(a.arguments().at(1).compare("--set_web_host") == 0){
            Configuration::instance()->setWebHost(a.arguments().at(2));
            return 0;
        }

        if(a.arguments().at(1).compare("--set_buzzer_pin") == 0){
            Configuration::instance()->setBuzzerPin(a.arguments().at(2).toInt());
            return 0;
        }

        if(a.arguments().at(1).compare("--enable_satellite_mode") == 0){
            Configuration::instance()->setSatelliteMode(true);
            return 0;
        }

        if(a.arguments().at(1).compare("--disable_satellite_mode") == 0){
            Configuration::instance()->setSatelliteMode(false);
            return 0;
        }

        if(a.arguments().at(1).compare("--use_standard_gpio_sensor_pins") == 0){
            Configuration::instance()->setSensorCount(3);
            Configuration::instance()->setSensorPin(0,1);
            Configuration::instance()->setSensorPin(1,4);
            Configuration::instance()->setSensorPin(2,5);
            Configuration::instance()->setBuzzerPin(6);
            Configuration::instance()->setRestartButtonPin(14);
            return 0;
        }

        if(a.arguments().at(1).compare("--use_dot3k_hat_pin_setup") == 0){
            Configuration::instance()->setSensorCount(3);
            Configuration::instance()->setSensorPin(0,21);
            Configuration::instance()->setSensorPin(1,22);
            Configuration::instance()->setSensorPin(2,23);
            Configuration::instance()->setBuzzerPin(24);
            Configuration::instance()->setRestartButtonPin(25);
            return 0;
        }
	}

    //initialization
    wiringPiSetup ();
    HostStation::instance()->setup();
    Buzzer::instance()->setPin(Configuration::instance()->buzzerPin());
    RestartButtonInput::instance()->setPin(Configuration::instance()->restartButtonPin());
    InfoServer::instance();

    SerialConnection::instance()->setup();

    if(!GPIOReader::instance()->init()) {
        return -1;
    }

	while(1){
        GPIOReader::instance()->update();
		Buzzer::instance()->update();
        RestartButtonInput::instance()->update();
        a.processEvents();
	}

    curl_global_cleanup();
    return a.exec();
}
