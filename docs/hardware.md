![alt text](http://www.airbirds.de/wp-content/uploads/2015/11/logo_big.png "EasyRaceLapTimer")

# Hardware

## IR Transponder

    1x Infrared LED 950nm (example: LD 274-3)
    1x Resistor 56 Ohm
    1x Resistor 330 Ohm
    1x Transistor NPN TO-92 45V 0,1A 0,5W
    1x ATTINY 85-20 PU, DIP-8
    1x IC socket for the ATTINY

You will need a solder pad for each transponder, on which you will solder everything on to.

Have a look at datasheets/easy_race_lap_timer_transponder_attiny85_schematic.png to see how all these parts are getting soldered.

## Programmer

You will need a programmer for the ATTINY85 if you want to upload the software on your own. Either use an Arduino as an ISP to accomplish this or get [this programmer](https://www.sparkfun.com/products/11801).

If you choose the Arduino ISP solution, here's an example [how to accomplish this](http://highlowtech.org/?p=1695).

## Host Station

    3x TSOP 31238 38kHz
    1x Raspberry PI 2 (Raspberry PI 1 should also work)
    long wires to connect the TSOP IR sensors to the Raspberry GPIO ports
    1x WiFi stick
    power supply for the Raspberry PI, eg: a powerbank

    optional, a buzzer: CPM 121, but any other buzzer which can stand 5V will make it too.
