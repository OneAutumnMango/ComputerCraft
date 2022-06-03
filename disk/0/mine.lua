forward = arg[1]
right = arg[2]
down = arg[3]

function safe_dig()
    while turtle.detect() do
        turtle.dig()
        os.sleep(0.5)
    end
end

left = false

safe_dig()


for i=1,down-1 do
    for k=1,forward-1 do   
            if turtle.getFuelLevel() < 20 then
                turtle.refuel()
                print("Refueled!")
            end

            
            safe_dig()

            if not turtle.forward() then
                print("Cannot Mine This!")
                exit()
            end

        end

    for j=1,right-1 do
        if left then 
            turtle.turnLeft()
            safe_dig()
            turtle.forward()
            turtle.turnLeft()

            left = false
        else 
            turtle.turnRight()
            safe_dig()
            turtle.forward()
            turtle.turnRight()

            left = true
        end

        for k=1,forward-1 do   
            if turtle.getFuelLevel() < 20 then
                turtle.refuel()
                print("Refueled!")
            end

            safe_dig()

            if not turtle.forward() then
                print("Cannot Mine This!")
                exit()
            end
        end
    end

    turtle.digDown()
    turtle.down()

    if right % 2 == 0 then
        turtle.turnRight()
        left = false
    else
        turtle.turnLeft()
        left = true
    end
end
