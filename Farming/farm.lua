length = tonumber(arg[1])
width = tonumber(arg[2])

coord = {x = 0, -- length
         y = 0}  -- width

seedType = {["minecraft:wheat"]=1,
            ["minecraft:carrots"]=2,
            ["minecraft:potatoes"]=3}

function replant(slot)
    turtle.select(1)
    turtle.digDown()
    turtle.select(slot)
    turtle.placeDown()
end

function replantIfGrown()
    isBlock, data = turtle.inspectDown()

    if isBlock then
        if data.state.age == 7 then
            replant(seedType[data.name])
        end
    end
end

function unload()
    turtle.turnLeft()
    for i=1, coord.y+2 do
        turtle.forward()
    end
    
    for slot=4,16 do
        turtle.select(slot)
        turtle.dropDown()
    end
    turtle.turnRight()
    turtle.turnRight()
    turtle.forward()
    turtle.forward()
    turtle.turnLeft()
end

function farm()
    while width > 0 do
        for j=1, length do
            replantIfGrown()
                
            turtle.forward()
            coord.x = coord.x + 1
        end

        turtle.turnRight()
        turtle.turnRight()

        while coord.x > 0 do
            turtle.forward()
            coord.x = coord.x - 1
        end
        turtle.turnLeft()
        turtle.forward()
        turtle.turnLeft()
        width = width - 1
        coord.y = coord.y + 1
    end

    unload()
end


while true do
    farm()
    os.sleep(20*60)
end