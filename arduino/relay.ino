#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>

 
const char* ssid = "Thomson0D0380"; // fill in here your router or wifi SSID
const char* password = "FC7C51EC56"; // fill in here your router or wifi password
 #define RELAY 0 // relay connected to  GPIO0
int state = HIGH;

ESP8266WebServer server(80);
 
void setup() {
  
  Serial.begin(115200);
  Serial.println("");
  Serial.println("Relay Module");
      
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  pinMode(RELAY,OUTPUT);
  digitalWrite(RELAY, HIGH);
 
  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  server.on("/", [](){
      String msg = state == HIGH ? "off" : "on";
      server.send(200, "application/json", "{\"state\": \""+ msg +"\"}");
  });

  server.on("/on", [](){
      state = LOW;
      digitalWrite(RELAY,state);
      server.send(200, "application/json", "{\"state\": \"on\" }");
  });
  
  server.on("/off", [](){
      state = HIGH;
      digitalWrite(RELAY,state);
      server.send(200, "application/json", "{\"state\": \"off\"}");
  });
        
  // Start the server
  server.begin();
  Serial.println("HTTP server started");

}
 
void loop() {
  server.handleClient();
}