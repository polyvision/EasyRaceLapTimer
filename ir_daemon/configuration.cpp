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
    mp_settings = new QSettings("/etc/ir_daemon.ini",QSettings::IniFormat);
    LOG_DBG(LOG_CONFIG_FACILITY, "Configuration using file %s", qPrintable(mp_settings->fileName()));
}

void Configuration::setLogSeverity(Severity sev)
{
    mp_settings->setValue("logging/severity", sev);
    mp_settings->sync();
    LOG_DBG(LOG_CONFIG_FACILITY, "Configuration::setLogSeverity: %d", logSeverity());
}

Severity Configuration::logSeverity()
{
    return (Severity)mp_settings->value("logging/severity", INFO).toInt();
}

void Configuration::setLogLocations(quint8 loc)
{
    mp_settings->setValue("logging/location", loc);
    mp_settings->sync();
    LOG_DBG(LOG_CONFIG_FACILITY, "Configuration::setLogLocation: %d", logLocations());
}

quint8 Configuration::logLocations()
{
    return mp_settings->value("logging/location", 3).toUInt();
}

void Configuration::setDebug(bool dbg)
{
    mp_settings->setValue("debug/debug", dbg);
    mp_settings->sync();
    LOG_DBG(LOG_CONFIG_FACILITY, "Configuration::debug: %d", debug());
}

bool Configuration::debug()
{
    return mp_settings->value("debug/debug", false).toBool();
}

void Configuration::setComPortIndex(int index){
    mp_settings->setValue("serial_connection/com_port_index", index);
    mp_settings->sync();
    LOG_DBG(LOG_CONFIG_FACILITY, "Configuration::setComPortIndex: %i",comPortIndex());
}

int Configuration::comPortIndex(){
    return mp_settings->value("serial_connection/com_port_index",0).toInt();
}

void Configuration::setSensorCount(int sensorCount)
{
    mp_settings->setValue(QString("gpio_reader/sensorCount"), sensorCount);
    mp_settings->sync();
    LOG_DBG(LOG_CONFIG_FACILITY, "Configuration::setSensorCount: sensorCount: %i",sensorCount);
}

int Configuration::sensorCount()
{
    return mp_settings->value("gpio_reader/sensorCount").toInt();
}

void Configuration::setSensorPin(int sensor,int pin){
    mp_settings->setValue(QString("gpio_reader/pin_%1").arg(sensor), pin);
    mp_settings->sync();
    LOG_DBG(LOG_CONFIG_FACILITY, "Configuration::setSensorPin: sensor: %i pin: %i",sensor+1,sensorPin(sensor));
}

int  Configuration::sensorPin(int sensor){
    return mp_settings->value(QString("gpio_reader/pin_%1").arg(sensor),-1).toInt();
}

void Configuration::setBuzzerPin(int pin){
    mp_settings->setValue("buzzer/pin", pin);
    mp_settings->sync();
    LOG_DBG(LOG_CONFIG_FACILITY, "Configuration::setBuzzerPin: %i",buzzerPin());
}

int Configuration::buzzerPin(){
    return mp_settings->value("buzzer/pin",6).toInt(); // 6 is the default pin
}

void Configuration::setRestartButtonPin(int pin){
    mp_settings->setValue("buttons/restart_button_pin", pin);
    mp_settings->sync();
    LOG_DBG(LOG_CONFIG_FACILITY, "Configuration::setRestartButtonPin: %i",restartButtonPin());
}

int Configuration::restartButtonPin(){
    return mp_settings->value("buttons/restart_button_pin",14).toInt(); // 14 is the default pin
}

QString Configuration::webHost(){
    return mp_settings->value("urls/webhost","http://localhost/").toString();
}

void Configuration::setWebHost(const QString & v){
    mp_settings->setValue("urls/webhost", v);
    mp_settings->sync();
    LOG_DBG(LOG_CONFIG_FACILITY, "Configuration::setWebHost: %s",webHost().toStdString().c_str());
}

void Configuration::setSatelliteMode(bool v){
    mp_settings->setValue("mode/satellite", v);
    mp_settings->sync();
    LOG_DBG(LOG_CONFIG_FACILITY, "Configuration::setSatelliteMode: %i",satelliteMode());
}

bool Configuration::satelliteMode(){
    return mp_settings->value("mode/satellite",false).toBool();
}
