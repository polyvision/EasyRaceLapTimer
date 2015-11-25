![alt text](http://www.airbirds.de/wp-content/uploads/2015/11/logo_big.png "EasyRaceLapTimer")

# EasyRaceLapTimer

EasyRaceLapTimer is a complete open source IR lap time tracker all-in-one solution for FPV racing quads.

[![Circle CI](https://circleci.com/gh/polyvision/EasyRaceLapTimer.svg?style=svg)](https://circleci.com/gh/polyvision/EasyRaceLapTimer)

What you get with EasyRaceLaptimer:

**Features:**

* host system for tracking the laps
* IR transponders (code & schematic files for building them) with a transmitting range of 2 to 4 meters
* 63 available transponder IDs when using the project transponders
* update transponders with new code (Arduino hardware needed)
* setup guide for building your Raspberry PI host station
* the host station is also a WiFi access point to change configs etc on the fly
* monitoring mode, you can watch the stats with your mobile phones
* add your own team logo to the monitoring mode
* detailed stats about pilots and races
* sound effects for various events in a race
* TCP/IP and serial connections support for receiving lap times and commands from other time tracking systems
* and much more comming soon

**Important notices**

EasyRaceLapTimer works basicly with any IR transponder, as long as you provide code for interpreting the IR pulses. Just have a look at the *ir_daemon* tool.

Be sure to use the full size of your SD card on the Raspberry PI

    sudo raspi-config

# Stable Version 0.3

You can download a SD card image for the PI of EasyRaceLapTimer on the following pages:

http://www.airbirds.de
http://www.easyracelaptimer.com

There's also an introduction video to the system.

# file structure

**/docs**
  documentation of nearly every part of the package

**/web**

the rails application

**/Arduino**

all arduino sketches

**/ir_daemon**

the cpp daemon for receiving the IR pulses

**/datasheets**

schematic files and more for transponders etc.


# Installation

fetch the source via git with the following command

    git clone git@github.com:polyvision/EasyRaceLapTimer.git

more details of each indivial package can be found in the *docs* folder


# Contributors
 * [Peter Provost](https://github.com/PProvost)
# license

The complete project uses the [GPL V3 license](http://www.gnu.org/licenses/gpl-3.0.de.html)

**development and sponsoring by [AirBirds](http://www.airbirds.de)**

![alt text](http://www.airbirds.de/wp-content/uploads/2015/08/airbirds_weblogo_200.png "Logo Title Text 1")
