![alt text](http://www.airbirds.de/wp-content/uploads/2015/11/logo_big.png "EasyRaceLapTimer")

# EasyRaceLapTimer

EasyRaceLapTimer is a complete open source IR lap time tracker all-in-one solution for FPV racing quads.

What you get with EasyRaceLaptimer:

**Features:**

* host system for tracking the laps
* IR transponders (code & schematic files for building them)
* 63 available transponder IDs when using the project transponders
* update transponders with new code (Arduino hardware needed)
* setup guide for building your Raspberry PI host station
* the host station is also a WiFi access point to change configs etc on the fly
* monitoring mode, you can watch the stats with your mobile phones
* add your own team logo to the monitoring mode
* detailed stats about pilots and races
* and much more comming soon

**Important notices**

EasyRaceLapTimer works basicly with any IR transponder, as long as you provide code for interpreting the IR pulses. Just have a look at the *ir_daemon* tool.

Be sure to use the full size of your SD card on the Raspberry PI

    sudo raspi-config

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


**development and sponsoring by [AirBirds](http://www.airbirds.de)**

![alt text](http://www.airbirds.de/wp-content/uploads/2015/08/airbirds_weblogo_200.png "Logo Title Text 1")
