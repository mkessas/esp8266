#include <Wire.h> 
#include <LiquidCrystal_I2C.h>
#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>

// Set the LCD address to 0x27 for a 16 chars and 2 line display
LiquidCrystal_I2C lcd(0x27, 16, 2);
const char* ssid = "Thomson0D0380"; // fill in here your router or wifi SSID
const char* password = "FC7C51EC56"; // fill in here your router or wifi password

ESP8266WebServer server(80);

void setup() {

    Serial.begin(115200);
    Serial.println("");
    Serial.println("LCD Module");
        
    WiFi.mode(WIFI_STA);
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }

    Serial.print("Connected to ");
    Serial.println(ssid);
    Serial.print("IP address: ");
    Serial.println(WiFi.localIP());


    lcd.begin(0,2);  // sda=0, scl=2
    lcd.backlight();
    lcd.print(WiFi.localIP());

    server.on("/", HTTP_POST, [](){
        if (server.hasArg("plain")== false){
            server.send(422, "application/json", "{ \"status\": \"err\", \"message\": \"Missing body\"}");
            return;
        }
        lcd.clear();
        lcd.print(server.arg("plain"));
        server.send(200, "application/json", "{\"status\": \"ok\"}");
    });
            
    // Start the server
    server.begin();
    Serial.println("HTTP server started");
    
}

void loop() {
    server.handleClient();
}