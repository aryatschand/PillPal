#include <Arduino.h>
#include <Servo.h>
#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClient.h>

// Set WiFI and servo object
ESP8266WiFiMulti WiFiMulti;
Servo myservo;
Servo openservo;

int locations[] = {10, 50, 130, 170};

// Run once in the beginning of program
void setup() 
{
  // Initialize LED and servo
  myservo.attach(2);
  openservo.attach(0);
  Serial.begin(115200);

  // Begin Wifi setup procedure
  for (uint8_t t = 4; t > 0; t--) 
  {
    Serial.printf("[SETUP] WAIT %d...\n", t);
    Serial.flush();
    delay(1000);
  }

  // Set LAN network credentials
  WiFi.mode(WIFI_STA);
  WiFiMulti.addAP("rrcus3-Guest", "0123456789");

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
    if (http.begin(client, "http://pillpal.macrotechsolutions.us/arduino/dispense")) 
    {
      Serial.print("[HTTP] GET...\n");

      // Start connection and send HTTP header
      int httpCode = http.GET();

      // If the request was successful
      if (httpCode > 0) 
      {
        Serial.printf("[HTTP] GET... code: %d\n", httpCode);

        // Check response
        if (httpCode == HTTP_CODE_OK || httpCode == HTTP_CODE_MOVED_PERMANENTLY) 
        {
          String payload = http.getString();
          result=payload;
          Serial.println(payload);
        }
      } else {
        Serial.printf("[HTTP] GET... failed, error: %s\n", http.errorToString(httpCode).c_str());
      }  
      http.end();
    } else {
      Serial.printf("[HTTP} Unable to connect\n");
    }
  }

  // If a new irrigation value was collected, update micropiece
  if (result.toInt() > 3) {
    result = "3";
  }
  if (result != "5")
  {
    // Move position of servo motor
      myservo.write(locations[result.toInt()]);
      delay(1000);
      openservo.write(180);
      delay(1000);
      openservo.write(0);
      delay(1000);
      myservo.write(90);
  }
    delay(1000);
}