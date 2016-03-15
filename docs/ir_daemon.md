![alt text](http://www.easyracelaptimer.com/wp-content/uploads/2016/01/easy_race_lap_timer_logo-1.png "EasyRaceLapTimer")

# EasyRaceLapTimer IR_DAEMON

## IR_DAEMON V2

To use, you will some Perl dependencies.  Start by installing cpanm:

    apt-get install cpanminus

Then, from the ir_daemon_v2/ directory, do:

    cpanm --installdeps .

You will also need to setup LIRC.  See:

http://alexba.in/blog/2013/01/06/setting-up-lirc-on-the-raspberrypi/

**be aware that V2 is in testing phase**

## IR_DAEMON V1
The ir_daemon is a C++ daemon running in the background of your Raspberry PI. It's responsible for decoding IR data, receiving and sending commands from and to various sources etc.

## requirements

    sudo apt-get install  qt5-default libcurl4-openssl-dev libudev-dev

## compilation

    cd ir_daemon
    qmake ir_daemon.pro
    make
    sudo ./ir_daemon --use_standard_gpio_sensor_pins
    sudo ./ir_daemon [for starting]


## command line options

show some debug output

    --debug

listing available serial ports

    --list_serial_ports

set serial port

        --set_com_port_index INDEX

set buzzer pin

        --set_buzzer_pin PIN

use standard pin layout

        --use_standard_gpio_sensor_pins

use pin layout for displayotron 3k HATs

        --use_dot3k_hat_pin_setup

enable satellite mode

        --enable_satellite_mode

disable satellite mode

        --disable_satellite_mode

set web host URL, used for the satellite to set the right IP of the main station

        --set_web_host http://<IP>/

        default:

        --set_web_host http://localhost/

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

* getting the last scanned token by the ir_daemon *

    LAST_SCANNED_TOKEN#
