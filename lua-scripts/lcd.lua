i2c.setup(0, 4, 3, i2c.SLOW)

lcd = dofile("lcd1602.lua")()
lcd:clear()
-- lcd:put(lcd:locate(0, 2), "Hello, world!")
lcd:run(0, 0, 16, "Hello, how are you?", 200, 1)
lcd:put(lcd:locate(1, 0), "Sleepy time")
-- lcd:clear()
-- lcd:define_char(0, { 10, 0, 14, 17, 17, 17, 14, 0 }) -- custom char o umlaut
-- lcd:put(lcd:locate(0, 0), "\000!"); lcd:put(lcd:locate(0, 14), "!\000")
-- lcd:run(0, 4, 8, "It's time! Skushai tvoroj\000k!", 150, 1)
