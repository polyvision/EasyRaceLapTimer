#-------------------------------------------------
#
# Project created by QtCreator 2015-08-27T10:44:29
#
#-------------------------------------------------

QT       += core network

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = ir_daemon
CONFIG   += console
CONFIG   -= app_bundle


SOURCES += main.cpp
HEADERS +=

LIBS= -lcurl
#unix:LIBS = -lwiringPi
