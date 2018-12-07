-- Used to initialise a new ESP8266 to connect to the home WiFi network as a station
-- https://nodemcu.readthedocs.io/en/master/en/modules/wifi/

wifi.setmode(wifi.STATION)
wifi.sta.autoconnect(1)
wifi.sta.config({ ["ssid"]= "Thomson0D0380", ["pwd"]= "FC7C51EC56" , ["save"] = true, ["auto"] = true })
