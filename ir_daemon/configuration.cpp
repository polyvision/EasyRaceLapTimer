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

 Configuration::Configuration(){

 }

 void Configuration::setComPortIndex(int index){
 	QSettings settings;
 	settings.setValue("serial_connection/com_port_index", index);
 	printf("Configuration::setComPortIndex: %i\n",comPortIndex());
 }

 int Configuration::comPortIndex(){
 	 QSettings settings;
 	 return settings.value("serial_connection/com_port_index",0).toInt();
 }

 void Configuration::setSensorPin(int sensor,int pin){
 	QSettings settings;
 	settings.setValue(QString("gpio_reader/pin_%1").arg(sensor), pin);
 	printf("Configuration::setSensorPin: sensor: %i pin: %i\n",sensor+1,sensorPin(sensor));
 }

 int  Configuration::sensorPin(int sensor){
 	QSettings settings;
 	return settings.value(QString("gpio_reader/pin_%1").arg(sensor),0).toInt();
 }

 void Configuration::setBuzzerPin(int pin){
 	QSettings settings;
 	settings.setValue("buzzer/pin", pin);
 	printf("Configuration::setBuzzerPin: %i\n",buzzerPin());
 }

 int Configuration::buzzerPin(){
	QSettings settings;
	return settings.value("buzzer/pin",6).toInt(); // 6 is the default pin
 }

 void Configuration::setRestartButtonPin(int pin){
 	QSettings settings;
 	settings.setValue("buttons/restart_button_pin", pin);
 	printf("Configuration::setRestartButtonPin: %i\n",restartButtonPin());
 }

int Configuration::restartButtonPin(){
	QSettings settings;
	return settings.value("buttons/restart_button_pin",14).toInt(); // 14 is the default pin	
}

QString Configuration::webHost(){
	QSettings settings;
	return settings.value("urls/webhost","http://localhost/").toString();
}

void Configuration::setWebHost(QString v){
	QSettings settings;
 	settings.setValue("urls/webhost", v);
 	printf("Configuration::setWebHost: %s\n",webHost().toStdString().c_str());
}

void Configuration::setSatelliteMode(bool v){
	QSettings settings;
 	settings.setValue("mode/satellite", v);
 	printf("Configuration::setSatelliteMode: %i\n",satelliteMode());
}

bool Configuration::satelliteMode(){
	QSettings settings;
	return settings.value("mode/satellite",false).toBool();
}
