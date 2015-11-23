#-------------------------------------------------
#
# Project created by QtCreator 2015-08-27T10:44:29
#
#-------------------------------------------------

QT       += core network concurrent

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = ir_daemon
CONFIG   += console
CONFIG   -= app_bundle


SOURCES += main.cpp restart_button_input.cpp buzzer.cpp
HEADERS += restart_button_input.h buzzer.h

LIBS= -lcurl -lwiringPi
