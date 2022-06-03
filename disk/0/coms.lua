rednet.open("right")

while true do
    local senderID, msg, proto = rednet.receive()

    if msg == "w" then
        turtle.forward()
    end
    if msg == "a" then
        turtle.turnLeft()
    end
    if msg == "s" then
        turtle.turnLeft()
        turtle.turnLeft()
    end
    if msg == "d" then
        turtle.turnRight()
    end

    if msg == "break" then
        turtle.dig()
    end
    if msg == "space" then
        turtle.digUp()
        turtle.up()
    end
    if msg == "leftShift" then
        turtle.digDown()
        turtle.down()
    end

    if msg == "exit" then
        print("exiting.")
        break
    end
end