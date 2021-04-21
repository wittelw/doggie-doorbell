EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L NODE_MCU_Module:NodeMCU_ESP-12E U?
U 1 1 606294D0
P 5200 3750
F 0 "U?" H 5200 4831 50  0000 C CNN
F 1 "NodeMCU_ESP-12E" H 5200 4740 50  0000 C CNN
F 2 "Module:NodeMCU_ESP-12E" H 4450 2900 50  0001 C CNN
F 3 "https://github.com/KiCad/kicad-symbols/pull/1426/files" H 5000 2600 50  0001 C CNN
	1    5200 3750
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 60638866
P 6650 3650
F 0 "R?" V 6443 3650 50  0000 C CNN
F 1 "220" V 6534 3650 50  0000 C CNN
F 2 "" V 6580 3650 50  0001 C CNN
F 3 "~" H 6650 3650 50  0001 C CNN
	1    6650 3650
	0    1    1    0   
$EndComp
$Comp
L Device:LED_RGBC D?
U 1 1 6063680C
P 7600 3650
F 0 "D?" H 7600 3183 50  0000 C CNN
F 1 "LED_RGBC" H 7600 3274 50  0000 C CNN
F 2 "" H 7600 3600 50  0001 C CNN
F 3 "~" H 7600 3600 50  0001 C CNN
	1    7600 3650
	-1   0    0    1   
$EndComp
$Comp
L Device:R R?
U 1 1 6063BC00
P 7050 3850
F 0 "R?" V 6843 3850 50  0000 C CNN
F 1 "220" V 6934 3850 50  0000 C CNN
F 2 "" V 6980 3850 50  0001 C CNN
F 3 "~" H 7050 3850 50  0001 C CNN
	1    7050 3850
	0    1    1    0   
$EndComp
$Comp
L Device:R R?
U 1 1 6063F726
P 7050 3450
F 0 "R?" V 6843 3450 50  0000 C CNN
F 1 "220" V 6934 3450 50  0000 C CNN
F 2 "" V 6980 3450 50  0001 C CNN
F 3 "~" H 7050 3450 50  0001 C CNN
	1    7050 3450
	0    1    1    0   
$EndComp
$Comp
L Isolator:4N35 U?
U 1 1 60642B69
P 7700 4450
F 0 "U?" H 7700 4775 50  0000 C CNN
F 1 "4N35" H 7700 4684 50  0000 C CNN
F 2 "Package_DIP:DIP-6_W7.62mm" H 7500 4250 50  0001 L CIN
F 3 "https://www.vishay.com/docs/81181/4n35.pdf" H 7700 4450 50  0001 L CNN
	1    7700 4450
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 6064E00E
P 7200 4350
F 0 "R?" V 6993 4350 50  0000 C CNN
F 1 "220" V 7084 4350 50  0000 C CNN
F 2 "" V 7130 4350 50  0001 C CNN
F 3 "~" H 7200 4350 50  0001 C CNN
	1    7200 4350
	0    1    1    0   
$EndComp
Wire Wire Line
	7400 4550 7000 4550
Wire Wire Line
	7200 3850 7400 3850
Wire Wire Line
	6800 3650 7400 3650
Wire Wire Line
	7200 3450 7400 3450
Wire Wire Line
	6900 3850 6300 3850
Wire Wire Line
	6300 3850 6300 3650
Wire Wire Line
	6300 3650 6200 3650
Wire Wire Line
	6500 3650 6400 3650
Wire Wire Line
	6400 3650 6400 3550
Wire Wire Line
	6400 3550 6200 3550
Wire Wire Line
	6900 3450 6200 3450
Wire Wire Line
	5400 2850 5400 2600
Wire Wire Line
	5400 2600 8100 2600
Wire Wire Line
	8100 2600 8100 3650
Wire Wire Line
	8100 3650 7800 3650
Wire Wire Line
	8100 3650 8100 4050
Wire Wire Line
	8100 4050 7050 4050
Connection ~ 8100 3650
Wire Wire Line
	5400 4650 6850 4650
Wire Wire Line
	8000 4550 8000 4650
Connection ~ 8000 4650
Text GLabel 8450 4450 2    50   UnSpc ~ 0
DoorbellButton
Text GLabel 8450 4650 2    50   UnSpc ~ 0
DoorbellGND
Wire Wire Line
	8000 4450 8450 4450
Wire Wire Line
	8000 4650 8450 4650
$Comp
L power:GND #PWR?
U 1 1 606819E4
P 8000 4850
F 0 "#PWR?" H 8000 4600 50  0001 C CNN
F 1 "GND" H 8005 4677 50  0000 C CNN
F 2 "" H 8000 4850 50  0001 C CNN
F 3 "" H 8000 4850 50  0001 C CNN
	1    8000 4850
	1    0    0    -1  
$EndComp
Wire Wire Line
	8000 4850 8000 4650
Wire Notes Line
	10750 3250 10750 4800
Wire Notes Line
	10750 4800 8400 4800
Wire Notes Line
	8400 4800 8400 3250
Text Notes 8750 4000 0    50   ~ 0
Existing circa 1983 electronic doorbell.\nDoorbellButton is normally held high (5V),\nand when pulled low then released rings\nfollowing the low to high transition.\nPowered separately.
Wire Notes Line
	8400 3250 10750 3250
$Comp
L Switch:SW_SPST SW?
U 1 1 6069DEEB
P 6650 4300
F 0 "SW?" H 6650 4535 50  0000 C CNN
F 1 "SW_SPST" H 6650 4444 50  0000 C CNN
F 2 "" H 6650 4300 50  0001 C CNN
F 3 "~" H 6650 4300 50  0001 C CNN
	1    6650 4300
	1    0    0    -1  
$EndComp
Wire Wire Line
	7350 4350 7400 4350
Wire Wire Line
	7050 4050 7050 4350
Wire Wire Line
	7000 4550 7000 3950
Wire Wire Line
	6200 3950 7000 3950
Wire Wire Line
	6850 4300 6850 4650
Connection ~ 6850 4650
Wire Wire Line
	6850 4650 8000 4650
Wire Wire Line
	6200 4050 6450 4050
Wire Wire Line
	6450 4050 6450 4300
$Comp
L Connector:USB_B_Micro J?
U 1 1 606A9943
P 3450 3050
F 0 "J?" H 3507 3517 50  0000 C CNN
F 1 "USB_B_Micro" H 3507 3426 50  0000 C CNN
F 2 "" H 3600 3000 50  0001 C CNN
F 3 "~" H 3600 3000 50  0001 C CNN
	1    3450 3050
	1    0    0    -1  
$EndComp
Wire Wire Line
	3750 2850 5100 2850
Wire Wire Line
	5100 2900 5100 2850
Connection ~ 5100 2850
Wire Wire Line
	3450 3450 3450 4650
Wire Wire Line
	3450 4650 5100 4650
$EndSCHEMATC
