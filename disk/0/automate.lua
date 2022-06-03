rednet.open("top")  -- modem location
local monitor = peripheral.wrap("right")

while true do
    local event, key = os.pullEvent("key")
    
    if key == keys.c then
    	monitor.write("running coms...\n")
    	rednet.broadcast("coms")
    	shell.run("coms")
    end
end