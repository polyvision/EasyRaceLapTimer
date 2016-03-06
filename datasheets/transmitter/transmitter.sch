EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:transmitter-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "Transmitter"
Date ""
Rev "1"
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L GND #PWR01
U 1 1 56C0E1A9
P 4000 4050
F 0 "#PWR01" H 4000 3800 50  0001 C CNN
F 1 "GND" H 4000 3900 50  0000 C CNN
F 2 "" H 4000 4050 50  0000 C CNN
F 3 "" H 4000 4050 50  0000 C CNN
	1    4000 4050
	1    0    0    -1  
$EndComp
$Comp
L ATTINY85-P IC1
U 1 1 56C0E20D
P 6000 3750
F 0 "IC1" H 4850 4150 50  0000 C CNN
F 1 "ATTINY85-P" H 7000 3350 50  0000 C CNN
F 2 "Housings_DIP:DIP-8_W7.62mm" H 7000 3750 50  0000 C CIN
F 3 "" H 6000 3750 50  0000 C CNN
	1    6000 3750
	-1   0    0    -1  
$EndComp
$Comp
L LED D1
U 1 1 56C0E26F
P 8700 3700
F 0 "D1" H 8700 3800 50  0000 C CNN
F 1 "IR LED" H 8700 3600 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x02" H 8700 3700 50  0001 C CNN
F 3 "" H 8700 3700 50  0000 C CNN
	1    8700 3700
	0    -1   -1   0   
$EndComp
$Comp
L R R2
U 1 1 56C0E2F4
P 8700 4250
F 0 "R2" V 8780 4250 50  0000 C CNN
F 1 "56" V 8700 4250 50  0000 C CNN
F 2 "Resistors_ThroughHole:Resistor_Horizontal_RM7mm" V 8630 4250 50  0001 C CNN
F 3 "" H 8700 4250 50  0000 C CNN
	1    8700 4250
	1    0    0    -1  
$EndComp
$Comp
L Q_NPN_EBC Q1
U 1 1 56C0E336
P 8600 3150
F 0 "Q1" H 8900 3200 50  0000 R CNN
F 1 "Q_NPN_EBC" H 9200 3100 50  0000 R CNN
F 2 "TO_SOT_Packages_THT:TO-92_Inline_Narrow_Oval" H 8800 3250 50  0001 C CNN
F 3 "" H 8600 3150 50  0000 C CNN
	1    8600 3150
	1    0    0    -1  
$EndComp
$Comp
L R R1
U 1 1 56C0E393
P 8050 3150
F 0 "R1" V 8130 3150 50  0000 C CNN
F 1 "330" V 8050 3150 50  0000 C CNN
F 2 "Resistors_ThroughHole:Resistor_Horizontal_RM7mm" V 7980 3150 50  0001 C CNN
F 3 "" H 8050 3150 50  0000 C CNN
	1    8050 3150
	0    1    1    0   
$EndComp
Wire Wire Line
	4000 3500 4650 3500
Wire Wire Line
	4000 3500 4000 3450
Wire Wire Line
	4000 4000 4650 4000
Wire Wire Line
	4000 4000 4000 4050
Wire Wire Line
	4400 2950 8700 2950
Wire Wire Line
	4400 2950 4400 3500
Connection ~ 4400 3500
Wire Wire Line
	8200 3150 8400 3150
Wire Wire Line
	7900 3150 7700 3150
Wire Wire Line
	8700 3500 8700 3350
Wire Wire Line
	8700 3900 8700 4100
Wire Wire Line
	4400 4400 8700 4400
Wire Wire Line
	4400 4400 4400 4000
Connection ~ 4400 4000
$Comp
L AVR-ISP-6 CON1
U 1 1 56C0E8D5
P 8150 4000
F 0 "CON1" H 8045 4240 50  0000 C CNN
F 1 "AVR-ISP-6" H 7885 3770 50  0000 L BNN
F 2 "Pin_Headers:Pin_Header_Straight_2x03" V 7630 4040 50  0001 C CNN
F 3 "" H 8125 4000 50  0000 C CNN
	1    8150 4000
	1    0    0    -1  
$EndComp
Wire Wire Line
	8000 3900 7550 3900
Wire Wire Line
	7550 3900 7550 3600
Wire Wire Line
	7350 3600 7700 3600
Wire Wire Line
	8000 4000 7450 4000
Wire Wire Line
	7450 4000 7450 3700
Wire Wire Line
	7450 3700 7350 3700
Wire Wire Line
	8000 4100 7350 4100
Wire Wire Line
	7350 4100 7350 4000
Wire Wire Line
	8250 3900 8350 3900
Wire Wire Line
	8350 3900 8350 2950
Connection ~ 8350 2950
Wire Wire Line
	8250 4000 8450 4000
Wire Wire Line
	8450 4000 8450 3500
Wire Wire Line
	8450 3500 7350 3500
Wire Wire Line
	8250 4100 8250 4400
Connection ~ 8250 4400
NoConn ~ 7350 3900
Wire Wire Line
	7700 3600 7700 3150
Connection ~ 7550 3600
$Comp
L VCC #PWR?
U 1 1 56C27B48
P 4000 3450
F 0 "#PWR?" H 4000 3300 50  0001 C CNN
F 1 "VCC" H 4000 3600 50  0000 C CNN
F 2 "" H 4000 3450 50  0000 C CNN
F 3 "" H 4000 3450 50  0000 C CNN
	1    4000 3450
	1    0    0    -1  
$EndComp
NoConn ~ 7350 3800
$EndSCHEMATC
