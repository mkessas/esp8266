sv = net.createServer(net.TCP, 30)

if sv then
  print "Starting Listener on port 80"
  sv:listen(80, function(conn)
    conn:on("receive", function(sck, data)
      -- print "Got connection"
      if string.find(data, "GET /api/relay/on HTTP") then
	print "Turning Relay ON"
	-- uart.write(0, string.char(0xA0,0x01,0x01,0xA2))
	conn:send("HTTP/1.0 200 OK\r\nServer: NodeMCU\r\nContent-type: application/json\r\nConnection: close\r\n\r\n{\"status\":\"ok\",\"message\":\"Relay ON\"}\r\n", function() 
	    sck:close()
	end)
      elseif string.find(data, "GET /api/relay/off HTTP") then
	print "Turning Relay OFF"
	-- uart.write(0, string.char(0xA0,0x01,0x00,0xA1))
	conn:send("HTTP/1.0 200 OK\r\nServer: NodeMCU\r\nContent-type: application/json\r\nConnection: close\r\n\r\n{\"status\":\"ok\",\"message\":\"Relay OFF\"}\r\n", function() 
	    sck:close()
	end)
      else
	-- print "Default catch-all"
	conn:send("HTTP/1.0 404 Not Found\r\nServer: NodeMCU\r\nContent-type: application/json\r\n\r\n{\"status\":\"err\",\"message\":\"File Not Found\"}\r\n", function() 
	    sck:close()
	end)
      end
      
    end)
    -- conn:send("hello world")
  end)
end
