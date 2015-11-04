# EasyRaceLapTimer - IR Pulses

7 bits are getting used for sending the transponder id (token). There's one thing to know in our approach. IR space pulses are also bits!

## the format

the length of a ZERO and ONE pulse can be found for example in


    Arduino/nano_ir_test/nano_ir_test.ino

*remember that each second pulse is actual a space for the ir receiver*

    1 PULSE | 2 PULSE | 3 PULSE | 4 PULSE | 5 PULSE | 6 PULSE | 7 PULSE

**1 PULSE | 2 PULSE**

  both must be set zero, it's our header

**3 PULSE | 4 PULSE | 5 PULSE | 6 PULSE**

  the actual data bits for representing our integer val or better said the id of the transponder

**7 PULSE**

  checksum bit. Set it to 1 if the id is even otherwise not


## example

    id 14: ZERO | ZERO | ONE | ONE | ONE | ZERO | ZERO
    id  3: ZERO | ZERO | ZERO | ZERO | ONE | ONE | ONE


if you log the output of your IR receiver you would get something like this for the above examples

    id 14: PULSE 300 | SPACE 300 | PULSE 600 | SPACE 600 | PULSE 600 | SPACE 300 | PULSE 300
    id  3: PULSE 300 | SPACE 300 | PULSE 300 | SPACE 300 | PULSE 600 | SPACE 600 | PULSE 600

please keep in mind that the pulse length differs a lot when using IR receivers, so they won't be 100% accurate
