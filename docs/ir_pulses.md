![alt text](http://www.airbirds.de/wp-content/uploads/2015/11/logo_big.png "EasyRaceLapTimer")

# EasyRaceLapTimer - IR Pulses

9 bits are getting used for sending the transponder id (token). There's one thing to know in our approach. IR space pulses are also bits!
With 9 bits, we have 6 data bits, so 63 transponder IDs in total.

## the format

the length of a ZERO and ONE pulse can be found for example in


    Arduino/TransmitterAttiny85v0.2

*remember that each second pulse is actual a space for the ir receiver*

    1 PULSE | 2 PULSE | 3 PULSE | 4 PULSE | 5 PULSE | 6 PULSE | 7 PULSE | 8 PULSE | 9 PULSE

**1 PULSE | 2 PULSE**

  both must be set zero, it's our header

**3 PULSE | 4 PULSE | 5 PULSE | 6 PULSE | 7 PULSE | 8 PULSE**

  the actual data bits for representing our integer val or better said the id of the transponder

**9 PULSE**

  checksum bit. Set it to 1 if the number of ONES in the data bits is uneven


## example

    id 14: ZERO | ZERO | ZERO | ZERO | ONE | ONE | ONE | ZERO | ZERO
    id  3: ZERO | ZERO | ZERO | ZERO| ZERO | ZERO | ONE | ONE | ONE


if you log the output of your IR receiver you would get something like this for the above examples

    id 14: PULSE 300 | SPACE 300 | SPACE 300 | SPACE 300 | PULSE 600 | SPACE 600 | PULSE 600 | SPACE 300 | PULSE 300
    id  3: PULSE 300 | SPACE 300 | SPACE 300 | SPACE 300 | PULSE 300 | SPACE 300 | PULSE 600 | SPACE 600 | PULSE 600

please keep in mind that the pulse length differs a lot when using IR receivers, so they won't be 100% accurate
