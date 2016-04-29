#!/bin/bash
# This script can set the ID in the EEPROM on a transponder directly.
# You will need an AVR programmer. By default, this is setup for a 
# usbasp programmer.
#
# Pass an ID after converting to a two-byte hex value, and appending "0x". For
# instance, transponder ID 16 would be sent as "0x0010", like:
#
#    set_transponder.sh 0x0010
#
ID=$1
avrdude -v -pattiny85 -cusbasp -Pusb -U eeprom:w:${ID}:m
