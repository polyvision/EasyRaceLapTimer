![alt text](http://www.easyracelaptimer.com/wp-content/uploads/2016/01/easy_race_lap_timer_logo-1.png "EasyRaceLapTimer")

# Hardware

## IR Transponder

    1x Infrared LED 950nm (Example: LD 274-3 or TSUS5202)
    1x Resistor 33 Ohm
    1x Resistor 330 Ohm
    1x Transistor NPN TO-92 45V 0,1A 0,5W (Example: 2N2222)
    1x ATTINY 85-20 PU, DIP-8
    1x IC socket for the ATTINY

You will need a solder pad for each transponder, on which you will solder everything on to.

**important notice**
Transponder version 0.2 & 0.3.1 are both compatible with ERLT. You can use both at the same time with ERLT. The only difference between 0.2 & 0.3.1 is the way you change the ID of the transonder.

## Transponder 0.3.1
Have a look at the [transponder datasheet](/datasheets/easy_race_lap_timer_transponder_attiny85_rev3_schematic.png) to see how all these parts are getting soldered.

## Transponder 0.2
Have a look at the [transponder datasheet](/datasheets/easy_race_lap_timer_transponder_attiny85_schematic.png) to see how all these parts are getting soldered.

## Programmer

You will need a programmer for the ATTINY85 if you want to upload the software on your own. Either use an Arduino as an ISP to accomplish this or get [this programmer](https://www.sparkfun.com/products/11801).

If you choose the Arduino ISP solution, here's an example [how to accomplish this](http://highlowtech.org/?p=1695).

## Host Station

    3x TSOP 31238 38kHz
    1x Raspberry Pi 2 (Raspberry Pi 1 is not officially supported)
    long wires to connect the TSOP IR sensors to the Raspberry GPIO ports
    1x USB WiFi stick (Example: Edimax EW-7811Un)
    5V micro USB power supply for the Raspberry Pi, eg: a powerbank

    optional, a buzzer: CPM 121, but any other buzzer which can stand 5V will make it too.
