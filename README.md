# EasyRaceLapTimer

EasyRaceLapTimer is a complete open source IR lap time tracker all-in-one solution for FPV racing quads.

What you get with EasyRaceLaptimer:

**Features:**

* host system for tracking the laps
* IR transponders (code & schematic files for building them)
* setup guide for building your Raspberry PI host station
* monitoring mode, you can watch the stats with your mobile phones
* and many more comming soon!


# file structure

**/web**

the rails application

**/Arduino**

all arduino sketches

**/ir_daemon**

the cpp daemon for receiving the IR pulses

# API

**tracking a lap**

    POST http://localhost:3000/api/v1/lap_track

or

    GET http://localhost:3000/api/v1/lap_track/create

needed params
 * transponder_token
 * lap_time_in_ms


## Rails Webapp setup

    rake db:create
    rake db:migrate
    rake db:seed

default credentials are:

    user: admin@easyracelaptimer.com
    password: defaultpw


## Rails Webapp development
for running rails in dev mode, you need to run these two commands in seperate processes (e.g. terminal windows). The app uses sqlite for it's database

    ./bin/cable
    rails s

## ir_daemon compilation
QT5 & libCurl is required for compilation

**ir_daemon**

    qmake ir_daemon.pro
    make
    ./ir_daemon
