EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A 11000 8500
encoding utf-8
Sheet 1 1
Title "Hat for 5V PIR"
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Connector:Raspberry_Pi_2_3 J?
U 1 1 6033F69C
P 8150 3450
F 0 "J?" H 8150 4931 50  0000 C CNN
F 1 "Raspberry_Pi_2_3" H 8150 4840 50  0000 C CNN
F 2 "" H 8150 3450 50  0001 C CNN
F 3 "https://www.raspberrypi.org/documentation/hardware/raspberrypi/schematics/rpi_SCH_3bplus_1p0_reduced.pdf" H 8150 3450 50  0001 C CNN
	1    8150 3450
	1    0    0    -1  
$EndComp
$Comp
L PirSensor_Library:Level-Shifter LS??
U 1 1 60346352
P 3800 4300
F 0 "LS??" H 4600 4415 50  0000 C CNN
F 1 "Level-Shifter" H 4600 4324 50  0000 C CNN
F 2 "" H 3800 4300 50  0001 C CNN
F 3 "" H 3800 4300 50  0001 C CNN
	1    3800 4300
	1    0    0    -1  
$EndComp
$Comp
L PirSensor_Library:PIR-Sensor PIR??
U 1 1 60347C54
P 3450 1650
F 0 "PIR??" H 3200 1800 50  0000 C CNN
F 1 "PIR-Sensor" H 3200 1700 50  0000 C CNN
F 2 "" H 3450 1650 50  0001 C CNN
F 3 "" H 3450 1650 50  0001 C CNN
	1    3450 1650
	1    0    0    -1  
$EndComp
$Comp
L 74xx_IEEE:7408 U?
U 1 1 60348D78
P 4650 3350
F 0 "U?" H 4650 3766 50  0000 C CNN
F 1 "7408" H 4650 3675 50  0000 C CNN
F 2 "" H 4650 3350 50  0001 C CNN
F 3 "" H 4650 3350 50  0001 C CNN
	1    4650 3350
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 60353507
P 2950 4750
F 0 "#PWR?" H 2950 4500 50  0001 C CNN
F 1 "GND" H 2955 4577 50  0000 C CNN
F 2 "" H 2950 4750 50  0001 C CNN
F 3 "" H 2950 4750 50  0001 C CNN
	1    2950 4750
	1    0    0    -1  
$EndComp
Wire Wire Line
	8450 4750 8350 4750
Connection ~ 7750 4750
Wire Wire Line
	7750 4750 4350 4750
Connection ~ 7850 4750
Wire Wire Line
	7850 4750 7750 4750
Connection ~ 7950 4750
Wire Wire Line
	7950 4750 7850 4750
Connection ~ 8050 4750
Wire Wire Line
	8050 4750 7950 4750
Connection ~ 8150 4750
Wire Wire Line
	8150 4750 8050 4750
Connection ~ 8250 4750
Wire Wire Line
	8250 4750 8150 4750
Connection ~ 8350 4750
Wire Wire Line
	8350 4750 8250 4750
$Comp
L power:GND #PWR?
U 1 1 603562D0
P 7750 4750
F 0 "#PWR?" H 7750 4500 50  0001 C CNN
F 1 "GND" H 7755 4577 50  0000 C CNN
F 2 "" H 7750 4750 50  0001 C CNN
F 3 "" H 7750 4750 50  0001 C CNN
	1    7750 4750
	1    0    0    -1  
$EndComp
Wire Wire Line
	7950 2150 6350 2150
Wire Wire Line
	6350 2150 6350 1800
Wire Wire Line
	6350 1800 3550 1800
Wire Wire Line
	3550 1900 6250 1900
Wire Wire Line
	6250 1900 6250 2550
$Comp
L power:GND #PWR?
U 1 1 603634F7
P 6250 2550
F 0 "#PWR?" H 6250 2300 50  0001 C CNN
F 1 "GND" H 6255 2377 50  0000 C CNN
F 2 "" H 6250 2550 50  0001 C CNN
F 3 "" H 6250 2550 50  0001 C CNN
	1    6250 2550
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 60364878
P 4100 3750
F 0 "#PWR?" H 4100 3500 50  0001 C CNN
F 1 "GND" H 4105 3577 50  0000 C CNN
F 2 "" H 4100 3750 50  0001 C CNN
F 3 "" H 4100 3750 50  0001 C CNN
	1    4100 3750
	1    0    0    -1  
$EndComp
Wire Wire Line
	6350 2150 6350 3100
Wire Wire Line
	6350 3100 4650 3100
Wire Wire Line
	4650 3100 4650 3150
Connection ~ 6350 2150
Wire Wire Line
	3550 2000 6150 2000
Wire Wire Line
	6150 2000 6150 2650
Wire Wire Line
	6150 2650 4100 2650
Wire Wire Line
	4100 2650 4100 3250
Connection ~ 4100 3250
Wire Wire Line
	4100 3250 4100 3450
$Comp
L Device:R R?
U 1 1 60366D1D
P 4100 3600
F 0 "R?" H 4030 3554 50  0000 R CNN
F 1 "330" H 4030 3645 50  0000 R CNN
F 2 "" V 4030 3600 50  0001 C CNN
F 3 "~" H 4100 3600 50  0001 C CNN
	1    4100 3600
	-1   0    0    1   
$EndComp
Connection ~ 4100 3450
Wire Wire Line
	4100 3750 4650 3750
Wire Wire Line
	4650 3750 4650 3600
Connection ~ 4100 3750
Wire Wire Line
	3300 4750 3050 4750
Wire Wire Line
	3050 4750 3050 5100
Wire Wire Line
	3050 5100 4350 5100
Wire Wire Line
	4350 5100 4350 4750
Connection ~ 3050 4750
Wire Wire Line
	3050 4750 2950 4750
Connection ~ 4350 4750
Wire Wire Line
	4350 4750 4300 4750
Wire Wire Line
	4150 4750 4350 4750
Wire Wire Line
	5200 3350 5200 4450
Wire Wire Line
	5200 4450 4150 4450
Text Notes 4300 2850 0    50   ~ 0
1 gate of 74C08 or 74HC08
Wire Wire Line
	8350 2150 9400 2150
Wire Wire Line
	9400 2150 9400 5350
Wire Wire Line
	9400 5350 2050 5350
Wire Wire Line
	2050 4650 3300 4650
Wire Wire Line
	2050 4650 2050 5350
Wire Wire Line
	6350 3100 6350 4650
Wire Wire Line
	6350 4650 4150 4650
Connection ~ 6350 3100
Wire Wire Line
	7350 3050 6850 3050
Wire Wire Line
	6850 4050 3100 4050
Wire Wire Line
	3100 4050 3100 4450
Wire Wire Line
	3100 4450 3300 4450
Wire Wire Line
	6850 3050 6850 4050
Wire Notes Line
	4550 1750 4550 2050
Wire Notes Line
	4550 2050 4750 2050
Wire Notes Line
	4750 2050 4750 1750
Wire Notes Line
	4750 1750 4550 1750
Text Notes 4150 1700 0    50   ~ 0
Aproximately 40 feet CAT-6 
$EndSCHEMATC
