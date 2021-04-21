#!/usr/bin/env python3

import os
import logging
import logging.handlers
import paho as paho
import paho.mqtt.client as mqtt
import RPi.GPIO as GPIO
from time import sleep
from datetime import datetime
from datetime import timedelta
from datetime import timezone
import re
from astral.geocoder import database, lookup
from astral.sun import sun
import pytz

logger = None
logdir = os.path.expanduser('~/log/pir_sensor')
# Red and Green LEDs used only on solderless prototype board during development
redLedPin = 11       # define ledPin GPIO17 is pin 11
grnLedPin = 13       # GPIO27 is pin 13
sensorPin = 12       # define sensorPin GPIO18 is pin 12
pirState = -1

# Modify for local environment
mqttHost = '192.168.0.100'
mqttPort = 1883

mqttKeepAlive = 1
mqttClientId = 'PirSense'
mqttClient = None
mqttSwitchStateON = False
humanOverride = None
doorbellRingTopic = 'cmnd/pir_sense/doorbell/ring'
porchLightPowerTopic = 'cmnd/tasmota_6FE5C3/porchLightSwitch/POWER'
lightOnTimeout = None
logTimePirHigh = None
needLight = None
enablePorchLightOff = False

# 'stat/tasmota_6FE5C3/porchLightSwitch/POWER'
powerRegex = r"(stat/.*POWER)"
powerStates = {
    b"OFF": False,
    b"ON": True
}

def publish_light_off():
    if enablePorchLightOff == True:
        publish_mqtt_topic(porchLightPowerTopic, 'OFF')
    else:
        logger.debug('enablePorchLightOff != True, NOP')


def getPorchLightStatus():
    # Get status from switch
    publish_mqtt_topic(porchLightPowerTopic, '')

class NeedLight():
    global logger
    def __init__(self):
        self.sanDiego = lookup("San Diego", database())
        self.tz_sd = pytz.timezone(str(self.sanDiego.tzinfo))

    def updateNow(self):
        self.now = datetime.now(pytz.UTC)
        self.sun = sun(self.sanDiego.observer, date=self.now.astimezone(self.tz_sd))
        # sun returns datetime in UTC
        self.dayOn = self.sun["sunrise"]
        self.dayOff = self.sun["sunset"]

    def isDark(self):
        self.updateNow()
        logger.info('Current time in San Diego: {0}'.format(self.now.astimezone(self.tz_sd)))
        if self.now < self.dayOn or self.now > self.dayOff:
            logger.info('Before {0} or after {1}, therefore isDark returning True'.format(self.dayOn.astimezone(self.tz_sd), self.dayOff.astimezone(self.tz_sd)))
            return True
        else:
            logger.info('After {0} and before {1}, therefore isDark returning False'.format(self.dayOn.astimezone(self.tz_sd), self.dayOff.astimezone(self.tz_sd)))
            return False

class PirLightOnTimeout():
    def __init__(self, timeoutSeconds):
        self.timeoutSeconds = timeoutSeconds
        logger.debug('PirLightOnTimeout timeoutSeconds: ' + str(self.timeoutSeconds))
        self.timeOff = datetime.min
        self.isEnabled = False

    def start(self):
        self.timeOff = datetime.now() + timedelta(seconds = self.timeoutSeconds)
        logger.debug('timeOff reset to: ' + self.timeOff.isoformat())
        self.isEnabled = True

    def timedOut(self):
        if self.isEnabled == False:
            return True
        else:
            if self.timeOff > datetime.now():
                return False
            else:
                logger.debug('PirLightOnTimeout has expired.')
                self.isEnabled = False
                return True

class TimePirHigh():
    def __init__(self):
        self.startTime = datetime.now()

    def start(self):
        self.startTime = datetime.now()

    def stop(self):
        logger.debug('Time PIR was HIGH: ' + str(datetime.now() - self.startTime))

def init_mqtt():
    global mqttClient
    # Don't provide a client_id to be sure a unique one is created on this broker
    mqttClient = mqtt.Client()
    mqttClient.on_connect = on_connect
    mqttClient.on_message = on_message
    mqttClient.on_disconnect = on_disconnect
    mqttClient.connect_async(host = mqttHost, port = mqttPort, keepalive = mqttKeepAlive)

    # Uncomment to enable mqttClient logging
    # mqttClient.enable_logger(logger)

    # Blocking call that processes network traffic, dispatches callbacks and
    # handles reconnecting.
    mqttClient.loop_start()

    while mqttClient.is_connected() == False:
        logger.debug('mqttClient waiting for connection')
        sleep(0.1)

def init_logger():
    global logger
    logger = logging.getLogger('pir_sense')
    logger.setLevel(logging.DEBUG)
    if not os.path.exists(logdir):
        os.makedirs(logdir)
    # create file handler
    fh = logging.handlers.RotatingFileHandler(os.path.join(logdir, 'pir_sense.log'), maxBytes=1048576, backupCount=5)
    fh.setLevel(logging.DEBUG)
    # create console handler
    ch = logging.StreamHandler()
    ch.setLevel(logging.DEBUG)
    # create formatter and add it to the handlers
    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    fh.setFormatter(formatter)
    ch.setFormatter(formatter)
    # add the handlers to the logger
    logger.addHandler(fh)
    logger.addHandler(ch)

    logger.debug('logger initialized')


def setup():
    global logger, lightOnTimeout, logTimePirHigh, needLight

    # setup logging
    init_logger()

    # Set up the GPIO pins
    GPIO.setmode(GPIO.BOARD)           # use PHYSICAL GPIO Numbering
    GPIO.setup(redLedPin, GPIO.OUT)    # set redLedPin to OUTPUT mode
    GPIO.setup(grnLedPin, GPIO.OUT)    # set grLedPin to OUTPUT mode
    GPIO.setup(sensorPin, GPIO.IN)     # set sensorPin to INPUT mode

    # Default to OFF
    GPIO.output(redLedPin,GPIO.LOW)
    GPIO.output(grnLedPin,GPIO.LOW)

    # Create global classes
    lightOnTimeout = PirLightOnTimeout(60)
    logTimePirHigh = TimePirHigh()
    needLight = NeedLight()

    # Initialize mqtt client
    init_mqtt()

    getPorchLightStatus()


def loop():
    global pirState, humanOverride, lightOnTimeout, logTimePirHigh, needLight
    while True:
        if GPIO.input(sensorPin) == GPIO.HIGH:
            if pirState < 0 or pirState == 0:
                # PIR low to high transition
                pirState = 1
                GPIO.output(redLedPin,GPIO.HIGH)
                logger.info('pirState: ' + str(pirState))
                if lightOnTimeout.timedOut() == True:
                    # first pirState = 1 since previous timedOut / light off
                    publish_mqtt_topic(doorbellRingTopic, datetime.now().isoformat())
                if mqttSwitchStateON == True and (humanOverride == False or humanOverride == None) and lightOnTimeout.timedOut() == True:
                    # A human turned it on while there was no motion detected
                    humanOverride = True
                    logger.warning('humanOverride set True during PIR low to high transition and timedOut() == True (mqttSwitchStateON was True); light will not be switched on / off')
                else:
                    if mqttSwitchStateON == False and humanOverride == True:
                        # CR: can this ever be reached? Maybe first loop through?
                        humanOverride = False
                        logger.warning('humanOverride set False during PIR low to high transition (mqttSwitchStateON was False)')
                    if (mqttSwitchStateON == False or mqttSwitchStateON == None) and needLight.isDark() == True:
                        publish_mqtt_topic(porchLightPowerTopic, 'ON')
                        GPIO.output(grnLedPin,GPIO.HIGH)
                    else:
                        logger.warning('It is daylight, so porch light not turned on')

                lightOnTimeout.start()
                logTimePirHigh.start()
                logger.info('humanOverride: ' + str(humanOverride))
        else:
            if pirState < 0 or pirState == 1:
                # PIR high to low transition
                pirState = 0
                GPIO.output(redLedPin,GPIO.LOW)
                logTimePirHigh.stop()
                logger.info('pirState: ' + str(pirState))

                if mqttSwitchStateON == True and (humanOverride == False or humanOverride == None) and lightOnTimeout.timedOut() == True:
                    publish_light_off()
                    GPIO.output(grnLedPin,GPIO.LOW)
                else:
                    logger.debug('PIR high to low, nothing to do (has not timedOut or humanOverride is true)')

        # No PIR state change, but light on timed out
        if lightOnTimeout.timedOut() == True and mqttSwitchStateON == True and (humanOverride == False or humanOverride == None):
                logger.debug('Turning off light after timeout.')
                publish_light_off()
                GPIO.output(grnLedPin,GPIO.LOW)

        sleep(.1)

def destroy():
    GPIO.output(redLedPin,GPIO.LOW)
    GPIO.output(grnLedPin,GPIO.LOW)
    GPIO.cleanup()                     # Release GPIO resource

# The callback for when the client receives a CONNACK response from the server.
def on_connect(client, userdata, flags, rc):
    global mqttClient
    if rc != mqtt.MQTT_ERR_SUCCESS:
        logger.warning("Connected with result code " + paho.mqtt.client.error_string(rc))
    else:
        logger.debug("Connected with result code " + paho.mqtt.client.error_string(rc))

    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
#    client.subscribe("stat/tasmota_6F35C3/porchLightSwitch")
    client.subscribe("stat/#")

def on_disconnect(client, userdata, rc):
    global mqttClient
    if rc != mqtt.MQTT_ERR_SUCCESS:
        logger.warning("Disconnected with result code " + paho.mqtt.client.error_string(rc))
    else:
        logger.debug("Disconnected with result code " + paho.mqtt.client.error_string(rc))

# The callback for when a PUBLISH message is received from the server.
def on_message(client, userdata, msg):
    global mqttSwitchStateON, humanOverride
    message = msg.payload.decode('UTF8')
    logger.info('on_message: ' + msg.topic + " " + message)

    match = re.search(powerRegex, msg.topic)
    if (match != None):
            mqttSwitchStateON = powerStates.get(msg.payload, None)
            logger.info("on_message: mqttSwitchStateON == " + str(mqttSwitchStateON))

            # TODO: Race condition here?
            if  mqttSwitchStateON == True:
                if pirState == 0:
                    if (humanOverride == False or humanOverride == None):
                        logger.warning("humanOverride set True in on_message when mqttSwitchState True and pirState False")
                        humanOverride = True
                    else:
                        logger.warning("humanOverride set False in on_message when mqttSwitchState False and pirState True")
                        humanOverride = False                        


def publish_mqtt_topic(topic, payload = None):
    global mqttClient, mqttSwitchStateON
    while mqttClient.is_connected() == False:
        logger.debug('waiting for mqttClient to connect...')
    logger.info('publish ' + topic + ' ' + str(payload or ''))
    info = mqttClient.publish(topic = topic, payload = payload, qos=0, retain=False)
    # info.wait_for_publish()
    if info.rc != mqtt.MQTT_ERR_SUCCESS:
        logger.error('mqttClient rc returned from publish is: ' + paho.mqtt.client.error_string(info.rc))
    else:
        logger.debug('mqttClient rc returned from publish is: MQTT_ERR_SUCCESS')

    if topic.endswith("POWER"):
        if payload == "ON":
            mqttSwitchStateON = True
        else:
            mqttSwitchStateON = False

if __name__ == '__main__':     # Program entrance
    print('='*80)
    print('Program is starting...')
    print('='*80)
    setup()

    try:
        loop()
    except KeyboardInterrupt:  # Press ctrl-c to end the program.
        logger.error('KeyboardInterrupt caught!')
    except Exception as Argument:
        # logger.critical('Exception caught!: ' + str(Argument))
        logger.exception(Argument)
    finally:
        logger.debug('Exiting PirSense')
        destroy()
        mqttClient.loop_stop(force = False)
        mqttClient.disconnect()
        exit()
