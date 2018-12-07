# NodeMCU LUA Scripts of the ESP8266

A collection of scripts used for the NodeMCU firmware often used on the ESP8266 and variants.

## wifi.lua

Used to initialise a new ESP device with the base WiFi information (ie: the home network SSID and password).  Only needs to be run once as it will write the details to the flash.

## lcd.lua

Used to interact with an I2C LCD screen.  The address defaults to `0x27`.  The `SLA` and `SDC` connectors need to be attached to `GPIO0` and `GPIO2` on the ESP-01.

## lcd1602.lua

An awesome library used to simplify the I2C interaction with the LCD screen.  The `lcd.lua` makes use of this library.

## api.lua

A rudimentary web server.  Listens on port `80` and accepts a set of pre-determined URIs or it will return a `404 - File not found` error.
