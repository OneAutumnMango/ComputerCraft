depth = tonumber(arg[1])
width = tonumber(arg[2])

coord = {x = 0, -- forward`
         y = 0, -- up
         z = 0} -- right



function isWood()
    if turtle.compare() then
        return true
    end
    return false
end

function isWoodUp()
    if turtle.compareUp() then
        return true
    end
    return false
end


while width > 0 do
    while coord.x < depth do -- go forward
        turtle.dig()
        turtle.forward()
        coord.x = coord.x + 1

        while isWoodUp() do  -- go up
            turtle.digUp()
            turtle.up()
            coord.y = coord.y + 1 -- increment up 
        end

        while not turtle.detectDown() do  -- go down
            turtle.down()
            coord.y = coord.y + 1
        end
    end


    turtle.turnLeft()
    turtle.turnLeft()
    while coord.x > 0 do
        coord.x = coord.x - 1
        turtle.forward()
    end
    turtle.turnLeft()
    turtle.dig()
    turtle.forward()
    turtle.turnLeft()
    width = width - 1
end

    


