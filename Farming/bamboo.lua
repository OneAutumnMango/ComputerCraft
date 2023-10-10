times = tonumber(arg[1])
width = 10
    
function safeSuckForwardDig()
    while turtle.detect() do
        turtle.dig()
    end
    turtle.forward()
    turtle.suckUp()
    turtle.suckDown()
end

function reset()
    turtle.turnLeft()

    for i=1, width do
        turtle.forward()
        turtle.suck()
    end
    turtle.turnRight()
end

while times > 0 do
    if turtle.getFuelLevel() < 300 then
        turtle.select(15)
        turtle.refuel(64)
        turtle.select(16)
        turtle.refuel(64)
        print("Refueled!")
    end

    for slot=1, 14 do -- leave some slots for fuel
        turtle.select(slot)
        turtle.dropDown()
    end
    turtle.select(15)

    for i=1, width  do
        for j=1, width do
            safeSuckForwardDig()
        end

        turtle.turnLeft()
        turtle.turnLeft()

        for j=1, width do
            safeSuckForwardDig()
        end

        turtle.turnLeft()
        turtle.forward()
        turtle.turnLeft()

    end

    reset()

    times = times-1
end