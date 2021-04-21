// Based on Tutorials at https://vimalb.github.io/IoT-ESP8266-Starter/

#include <ESP8266WiFi.h>
WiFiClient WIFI_CLIENT;
// MQTT
#include <PubSubClient.h>
PubSubClient MQTT_CLIENT;
 
#define LIGHT_SENSOR A0
#define OPTO   5    // D1
#define R_LED 13    // D7
#define G_LED 12    // D6
#define B_LED 14    // D5
#define BUTTON 4    // D2

enum RGB_Bits {
  Black   = 0x00000000,
  Red     = 0x00000001,
  Green   = 0x00000002,
  Blue    = 0x00000004,
  Cyan    = Green | Blue,
  Magenta = Red | Blue,
  Yellow  = Red | Green,
  White   = Red | Green | Blue
};

// Replace with values for your environment
char mqtt_client_name[] = "ESP-123ABC";
char mqtt_server[] = "192.168.0.122";
bool doorbellSoundOn = true;

////////////////////////////////////////////////
//
// Setup
//
////////////////////////////////////////////////

void setup() {

  // Initialize the serial port
  Serial.begin(115200);

  pinMode(R_LED, OUTPUT);
  pinMode(G_LED, OUTPUT);
  pinMode(B_LED, OUTPUT);
  pinMode(OPTO, OUTPUT);
  pinMode(BUTTON, INPUT_PULLUP);

// Replace with values for your environment
  WiFi.begin("YourWiFiName", "YourWiFiPassword");

  while (WiFi.status() != WL_CONNECTED) {
    Serial.println("WiFi not connected, try again in 500ms");
    delay(500);
  }

  // HIGH is OPTO off (LED connected to VCC)
  digitalWrite(OPTO, HIGH);
  setLEDColorToSoundEnabled(doorbellSoundOn); 
}

////////////////////////////////////////////////
//
// Functions
//
////////////////////////////////////////////////

void setLEDColorToSoundEnabled(bool soundOn) {
  soundOn == true ? setLEDColor(Green) : setLEDColor(Red);
}

// Set RGB bits
void setLEDColor(RGB_Bits color) {
  // Invert color bits since LEDs common cathode connected to VCC
  digitalWrite(R_LED, !(color & Red));
  digitalWrite(G_LED, !(color & Green));
  digitalWrite(B_LED, !(color & Blue));
}

// Read the current RGB LED color
RGB_Bits getRGBColor() {
  int color = Black;
  if (digitalRead(R_LED) == 0) {
    color |= Red;
  }
  if (digitalRead(G_LED) == 0) {
    color |= Green; 
  }
  if (digitalRead(B_LED) == 0) {
    color |= Blue;
  }
  Serial.print("getRGBColor returns: ");
  Serial.println(color, HEX);
  return static_cast<RGB_Bits>(color);
}

// Blink the LED
void blinkLED(int milliseconds, int cycles, RGB_Bits color) {
  RGB_Bits currentColor = getRGBColor();
  Serial.print("blinkLED currentColor = ");
  Serial.println(currentColor, HEX);
  for (int i = 0; i < cycles; i++) {
    setLEDColor(color);
    delay(milliseconds);
    setLEDColor(Black);
    delay(milliseconds);    
  }

  setLEDColor(currentColor);
}

// Ring the doorbell
void ringDoorbell() {
  Serial.println("Enter ringDoorBell");
  
  if (doorbellSoundOn == true) {
    Serial.println("Write OPTO LOW for 250 ms");
    // Pull opto output low
    digitalWrite(OPTO, LOW);
    delay(250);
    digitalWrite(OPTO, HIGH);    
  }
    
  blinkLED(250, 10, White);
}

// This function handles received messages
void mqttSubscriptionCallback(char* topic, byte* payload, unsigned int length) {

  // Convert the message payload from bytes to a string
  String message = "";
  for (unsigned int i=0; i< length; i++) {
    message = message + (char)payload[i];
  }
   
  // Print the message to the serial port
  Serial.print("mqtt message: ");
  Serial.println(message);

  ringDoorbell();
}

// This function connects to the MQTT broker
void reconnect() {
  // Set our MQTT broker address and port
  MQTT_CLIENT.setServer(mqtt_server , 1883);
  MQTT_CLIENT.setClient(WIFI_CLIENT);

  // Loop until we're reconnected
  while (!MQTT_CLIENT.connected()) {
    // Attempt to connect
    Serial.println("Attempt to connect to MQTT broker");
    MQTT_CLIENT.connect(mqtt_client_name);

    // Wait some time to space out connection requests
    delay(3000);
  }

  Serial.println("MQTT connected");

  // Subscribe to the topic where our web page is publishing messages
  MQTT_CLIENT.subscribe("cmnd/pir_sense/doorbell/ring");
  // MQTT_CLIENT.subscribe("cmnd/#");

  // Set the message received callback
  MQTT_CLIENT.setCallback(mqttSubscriptionCallback);
}

////////////////////////////////////////////////
//
// Main Loop
//
////////////////////////////////////////////////

void loop() {
  // Check if we're connected to the MQTT broker
  if (!MQTT_CLIENT.connected()) {
    // If we're not, attempt to reconnect
    reconnect();
  }

  if(digitalRead(BUTTON) == LOW) {

    // Debounce
    while(digitalRead(BUTTON) == LOW) {
      delay(100);
    }

    Serial.println("Button pressed, toggle doorbellSoundOn");
    doorbellSoundOn = !doorbellSoundOn;
    setLEDColorToSoundEnabled(doorbellSoundOn);
    
    if (doorbellSoundOn == true) {
      Serial.println("doorbellSoundOn == true, publish cmnd/pir_sense/doorbell/ring");
      MQTT_CLIENT.publish("cmnd/pir_sense/doorbell/ring", "Button push on esp8266");
    }
  }
  
  // Check for incoming MQTT messages
  MQTT_CLIENT.loop();
}
