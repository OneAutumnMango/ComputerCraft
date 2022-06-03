rednet.open("right")

while true do
    local senderID, msg, proto = rednet.receive()

    if msg == "coms" then
        print("initiating coms")
        shell.run("coms")
    end
    
end