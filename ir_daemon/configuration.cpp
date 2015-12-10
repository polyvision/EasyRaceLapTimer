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
 #include "configuration.h"
 #include <QSettings>
 #include <stdio.h>
#include <QDebug>

 Configuration::Configuration(){
   mp_Settings = new QSettings("/etc/ir_daemon.ini",QSettings::IniFormat);
   qDebug() << "Configuration using file " << mp_Settings->fileName();
 }

 void Configuration::setComPortIndex(int index){
 	mp_Settings->setValue("serial_connection/com_port_index", index);
  mp_Settings->sync();
 	printf("Configuration::setComPortIndex: %i\n",comPortIndex());
 }

 int Configuration::comPortIndex(){
 	 return mp_Settings->value("serial_connection/com_port_index",0).toInt();
 }

 void Configuration::setSensorPin(int sensor,int pin){
 	mp_Settings->setValue(QString("gpio_reader/pin_%1").arg(sensor), pin);
  mp_Settings->sync();
 	printf("Configuration::setSensorPin: sensor: %i pin: %i\n",sensor+1,sensorPin(sensor));
 }

 int  Configuration::sensorPin(int sensor){
 	return mp_Settings->value(QString("gpio_reader/pin_%1").arg(sensor),0).toInt();
 }

 void Configuration::setBuzzerPin(int pin){
 	mp_Settings->setValue("buzzer/pin", pin);
  mp_Settings->sync();
 	printf("Configuration::setBuzzerPin: %i\n",buzzerPin());
 }

 int Configuration::buzzerPin(){
	return mp_Settings->value("buzzer/pin",6).toInt(); // 6 is the default pin
 }

 void Configuration::setRestartButtonPin(int pin){
 	mp_Settings->setValue("buttons/restart_button_pin", pin);
  mp_Settings->sync();
 	printf("Configuration::setRestartButtonPin: %i\n",restartButtonPin());
 }

int Configuration::restartButtonPin(){
	return mp_Settings->value("buttons/restart_button_pin",14).toInt(); // 14 is the default pin
}

QString Configuration::webHost(){
	return mp_Settings->value("urls/webhost","http://localhost/").toString();
}

void Configuration::setWebHost(QString v){
 	mp_Settings->setValue("urls/webhost", v);
  mp_Settings->sync();
 	printf("Configuration::setWebHost: %s\n",webHost().toStdString().c_str());
}

void Configuration::setSatelliteMode(bool v){
 	mp_Settings->setValue("mode/satellite", v);
  mp_Settings->sync();
 	printf("Configuration::setSatelliteMode: %i\n",satelliteMode());
}

bool Configuration::satelliteMode(){
	return mp_Settings->value("mode/satellite",false).toBool();
}
