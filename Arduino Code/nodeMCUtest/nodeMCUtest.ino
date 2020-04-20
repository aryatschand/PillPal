#include <Arduino.h>
#include <Servo.h>
#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClient.h>

// Set WiFI and servo object
ESP8266WiFiMulti WiFiMulti;
Servo myservo;

float oldvolume = 0;
int pos = 0;

// RGB LED pins
int red_light_pin= D7;
int green_light_pin = D5;
int blue_light_pin = D6;

// Functiont to update RGB LED color to desired color
void RGB_color(int red_light_value, int green_light_value, int blue_light_value)
{
  analogWrite(red_light_pin, red_light_value);
  analogWrite(green_light_pin, green_light_value);
  analogWrite(blue_light_pin, blue_light_value);
}

// Run once in the beginning of program
void setup() 
{
  // Initialize LED and servo
  RGB_color(255, 0, 0);
  myservo.attach(2);
  Serial.begin(115200);

  // Begin Wifi setup procedure
  for (uint8_t t = 4; t > 0; t--) 
  {
    Serial.printf("[SETUP] WAIT %d...\n", t);
    Serial.flush();
    delay(1000);
  }

  // Indicate that connection is underway
  RGB_color(0, 0, 255); // Blue

  // Set LAN network credentials
  WiFi.mode(WIFI_STA);
  WiFiMulti.addAP("Football on your phone", "football123");

}

// Run in infinite loop
void loop() 
{
  String result = "";

  // If connection with LAN network was successful
  if ((WiFiMulti.run() == WL_CONNECTED)) 
  {
    // Set up Wifi and HTTP request clients
    WiFiClient client;
    HTTPClient http;

    // HTTP request procedure to server
    Serial.print("[HTTP] begin...\n");

    // Begin request to local ip and port
    if (http.begin(client, "http://d7d59928.ngrok.io/arduino")) 
    {
      Serial.print("[HTTP] GET...\n");

      // Start connection and send HTTP header
      int httpCode = http.GET();

      // If the request was successful
      if (httpCode > 0) 
      {
        RGB_color(0, 255, 0);
        Serial.printf("[HTTP] GET... code: %d\n", httpCode);

        // Check response
        if (httpCode == HTTP_CODE_OK || httpCode == HTTP_CODE_MOVED_PERMANENTLY) 
        {
          String payload = http.getString();
          Serial.println(payload.toInt()*10);
          myservo.write(payload.toInt()*10);
          delay(500);
          // If correct response was returned, set value of variable to returned
        }
      } else {
        Serial.printf("[HTTP] GET... failed, error: %s\n", http.errorToString(httpCode).c_str());
      }  
      http.end();
    } else {
      Serial.printf("[HTTP} Unable to connect\n");
    }
  }

  RGB_color(0, 0, 255);
    delay(1000);
}
