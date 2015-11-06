![alt text](http://www.airbirds.de/wp-content/uploads/2015/11/logo_big.png "EasyRaceLapTimer")

# EasyRaceLapTimer

EasyRaceLapTimer is a complete open source IR lap time tracker all-in-one solution for FPV racing quads.

What you get with EasyRaceLaptimer:

**Features:**

* host system for tracking the laps
* IR transponders (code & schematic files for building them)
* setup guide for building your Raspberry PI host station
* monitoring mode, you can watch the stats with your mobile phones
* and much more comming soon!


**Important notice**

EasyRaceLapTimer works basicly with any IR transponder, as long as you provide code for interpreting the IR pulses. Just have a look at the *ir_daemon* tool.

# file structure

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
