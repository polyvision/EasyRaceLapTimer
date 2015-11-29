![alt text](http://www.airbirds.de/wp-content/uploads/2015/11/logo_big.png "EasyRaceLapTimer")

# EasyRaceLapTimer IR_DAEMON

The ir_daemon is a C++ daemon running in the background of your Raspberry PI. It's responsible for decoding IR data, receiving and sending commands from and to various sources etc.

## requirements

    sudo apt-get install  qt5-default libcurl4-openssl-dev libudev-dev

## compilation

    cd ir_daemon
    qmake ir_daemon.pro
    make
    sudo ./ir_daemon [for starting]


## command line options

show some debug output

    --debug

listing available serial ports

    --listserialports

## data sources

   The ir_daemon can read data from TCP/IP sockets, serial connections and of course from the GPIO interface of the Raspberry PI.

## TCP Connection

The ir_daemon is listening on port 3006 for incomming connections. All commands need
a \n behind the #.



## commands

The following commands are available for serial and TCP/IP connections

*starting a new race*

    START_NEW_RACE#

*resetting*    

    RESET#

*tracking a new lap time*

    LAP_TIME <TOKEN/ID> <MILLISECONDS>#
