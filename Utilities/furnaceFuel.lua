furnaceCount = 18

coord = {x = 0,
         y = 0,
         z = 0}

--start beneath chest
function toFurnaces() -- starts facing north
    for i=1,3 do  -- down 3
        turtle.down()
        coord.y = coord.y - 1
    end

    for i=1,10 do -- across 10
        turtle.forward()
        coord.x = coord.x + 1
    end

    turtle.turnRight()
    for i=1,4 do -- out 4
        turtle.forward()
        coord.z = coord.z + 1
    end
end

function rtrn()
    while coord.z > 0 do
        turtle.forward()
        coord.z = coord.z - 1
    end
    turtle.turnLeft()
    while coord.x > 0 do
        turtle.forward()
        coord.x = coord.x - 1
    end
    while coord.y < 0 do
        turtle.up()
        coord.y = coord.y + 1
    end
    turtle.turnRight()
    turtle.turnRight()
end

function countItems()
    items = 0
    for i=1,16 do
        items = items + turtle.getItemCount(i)
    end
    return items
end


function load()
    for i=1,16 do
        turtle.suckUp()
    end
end

function unload(amount)  -- max 64
    local itemCount = turtle.getItemCount()
    if itemCount < amount then
        turtle.dropDown(itemCount)
        turtle.select(turtle.getSelectedSlot() % 16 + 1)  -- cycle once hit 16
        turtle.dropDown(amount - itemCount)
    else
        turtle.dropDown(amount)
    end
end


function main()
    load()
    toFurnaces()
    items = countItems()
    for furnace=1,furnaceCount do
        unload(items/furnaceCount+1)
        turtle.forward()
        coord.z = coord.z + 1
    end
    turtle.turnLeft()
    turtle.turnLeft()
    rtrn()
end

while true do
    if turtle.suckUp(1) then
        main()
    else
        os.sleep(30)
    end
end