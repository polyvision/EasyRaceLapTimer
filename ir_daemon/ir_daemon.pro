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


SOURCES += main.cpp restart_button_input.cpp buzzer.cpp \
    hoststation.cpp \
    gpioreader.cpp \
    networkconnection.cpp \
    networkserver.cpp \
    qextserialport/qextserialenumerator.cpp \
    qextserialport/qextserialport.cpp \
    serialconnection.cpp \
    configuration.cpp \
    infoserver.cpp \
    logger.cpp
    
HEADERS += restart_button_input.h buzzer.h \
    hoststation.h \
    gpioreader.h \
    wiring_pi.h \
    networkconnection.h \
    networkserver.h \
    qextserialport/qextserialenumerator.h \
    qextserialport/qextserialenumerator_p.h \
    qextserialport/qextserialport.h \
    qextserialport/qextserialport_global.h \
    qextserialport/qextserialport_p.h \
    singleton.h \
    serialconnection.h \
    configuration.h \
    infoserver.h \
    logger.h

macx {
  SOURCES += qextserialport/qextserialenumerator_osx.cpp \
            qextserialport/qextserialport_unix.cpp

  LIBS = -lcurl
  LIBS += -framework IOKit -framework CoreFoundation
}

QMAKE_CFLAGS += -fno-strict-aliasing -pipe
QMAKE_CXXFLAGS += -fno-strict-aliasing -pipe -std=c++11  #-save-temps
QMAKE_CXXFLAGS_DEBUG += -fstack-protector-all

unix {
  SOURCES += qextserialport/qextserialport_unix.cpp qextserialport/qextserialenumerator_linux.cpp
  LIBS= -lcurl -lwiringPi -ludev

  target.path = /usr/bin

  config.path = /etc/
  config.files += $$PWD/ir_daemon.ini

  INSTALLS += target config
}

OTHER_FILES += \
    ir_daemon.ini
