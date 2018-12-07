#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <DHT.h>
#include <DHT_U.h>
#define DHTTYPE DHT11
#define DHTPIN  2

const char* ssid     = "Thomson0D0380";
const char* password = "FC7C51EC56";

ESP8266WebServer server(80);

DHT_Unified dht(DHTPIN, DHTTYPE);
 
float humidity, temp_f;
unsigned long previousMillis = 0;        // will store last temp was read
const long interval = 10000;              // interval at which to read sensor
sensors_event_t event;

void setup(void) {
  
  Serial.begin(115200);  // Serial connection from ESP-01 via 3.3v console cable
  Serial.println("");
  Serial.println("DHT Weather Reading Server");
  
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  dht.begin();

  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
   
  server.on("/", [](){

    unsigned long currentMillis = millis();
   
    if(currentMillis - previousMillis >= interval) {
      previousMillis = currentMillis;   
  
      dht.temperature().getEvent(&event);
      if (isnan(event.temperature)) {
        Serial.println("Error reading temperature!");
      }
      else {
        Serial.print("Temperature: ");
        Serial.print(event.temperature);
        Serial.println(" *C");
        temp_f = event.temperature;
      }
  
      dht.humidity().getEvent(&event);
      if (isnan(event.relative_humidity)) {
        Serial.println("Error reading humidity!");
      }
      else {
        Serial.print("Humidity: ");
        Serial.print(event.relative_humidity);
        Serial.println("%");
        humidity = event.relative_humidity;
      }
    }
    
    server.send(200, "application/json", "{\"temperature\": "+String((int)temp_f)+", \"humidity\": " + String((int)humidity)+"}");
  });

  server.begin();
  Serial.println("HTTP server started");
}
 
void loop(void)
{
  server.handleClient();
} 
