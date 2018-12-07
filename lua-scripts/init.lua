-- uart.setup(0,9600,8,uart.PARITY_NONE,1,0)
-- server listens on 80, if data received, print data to console and send "hello world" back to caller
-- 30s time out for a inactive client

i2c.setup(0, 4, 3, i2c.SLOW)
lcd = dofile("lcd1602.lua")()
lcd:clear()
lcd:put(lcd:locate(0, 0), "Initialising...")
-- lcd:run(0, 0, 16, "Hello, how are you?", 200, 1)
-- lcd:put(lcd:locate(1, 0), "Testing 123")


sv = net.createServer(net.TCP, 30)

if sv then
  print "Starting Listener on port 80"
  sv:listen(80, function(conn)
    conn:on("receive", function(sck, data)
      -- print "Got connection"
      if string.find(data, "GET /api/relay/on HTTP") then
        print "Turning Relay ON"
        -- uart.write(0, string.char(0xA0,0x01,0x01,0xA2))
        conn:send(response(200, "{\"status\":\"ok\",\"message\":\"Relay ON\"}\r\n"), function() 
            sck:close()
        end)
      elseif string.find(data, "GET /api/relay/off HTTP") then
        print "Turning Relay OFF"
        -- uart.write(0, string.char(0xA0,0x01,0x00,0xA1))
        conn:send(response(200, "{\"status\":\"ok\",\"message\":\"Relay OFF\"}\r\n"), function() 
            sck:close()
        end)
     elseif string.find(data, "GET /api/lcd/clear HTTP") then
        lcd:clear()
        conn:send(response(200, "{\"status\":\"ok\",\"message\":\"LCD Cleared\"}\r\n"), function() 
            sck:close()
        end)
     elseif string.find(data, "PUT /api/lcd/message HTTP") then
        msg, x, y = string.match(data, "\r\n\r\n{\"message\":\"(.*)\",\"coord\":\"(%d),(%d)\"}")
        if msg then
            -- if x then coord_x = x else coord_x = 0 end
            -- if y then coord_y = y else coord_y = 0 end
            print("Printing: '" .. msg .. "' at " .. x .. ',' .. y)
            lcd:put(lcd:locate(tonumber(x), tonumber(y)), msg)
            conn:send(response(200, "{\"status\":\"ok\",\"message\":\"LCD Message Updated\"}\r\n"), function() 
                sck:close()
            end)
        else
            print("Error Getting Message")
            conn:send(response(422, "{\"status\":\"err\",\"message\":\"Invalid Message\"}\r\n"), function()
                sck:close()
            end)
        end
        -- uart.write(0, string.char(0xA0,0x01,0x00,0xA1))
      else
        -- print "Default catch-all"
        conn:send(response(404, "{\"status\":\"err\",\"message\":\"File Not Found\"}\r\n"), function() 
            sck:close()
        end)
      end
      
    end)
    -- conn:send("hello world")
  end)
end

function response(code, body)
    local header = "OK"
    if code == 404 then header = "404 Not Found"
    elseif code == 200 then header = "200 OK"
    elseif code == 422 then header = "422 Unprocessable Entity"
    end
    return "HTTP/1.0 " .. header .. "\r\nServer: NodeMCU\r\nContent-type: application/json\r\nConnection: close\r\n\r\n" .. body
end
