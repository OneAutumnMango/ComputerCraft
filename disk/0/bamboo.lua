times = tonumber(arg[1])
width = 10
length = 10

function safeSuckForwardDig()
    turtle.suckDown()
    while turtle.detect() do
        turtle.dig()
    end
    turtle.forward()
    turtle.suckDown()
    turtle.suckUp()        
end

function reset()
    turtle.turnLeft()

    for i=1, 10 do
        turtle.forward()
        turtle.suck()
    end
    turtle.turnRight()
end

function emptyInv()
    for slot=1, 14 do -- leave some slots for fuel
        turtle.select(slot)
        turtle.dropDown()
    end
    turtle.select(1)
end

while times > 0 do
    if turtle.getFuelLevel() < 500 then
        turtle.select(15)
        turtle.refuel(64)
        turtle.select(16)
        turtle.refuel(64)
        print("Refueled!")
    end

    emptyInv()

    for i=1, width/2  do
        for j=1, length do
            safeSuckForwardDig()
        end

        turtle.turnRight()
        safeSuckForwardDig()
        turtle.turnRight()

        for j=1, length do
            safeSuckForwardDig()
        end

        turtle.turnLeft()
        turtle.forward()
        turtle.turnLeft()

    end

    reset()
    emptyInv()

    times = times-1
end