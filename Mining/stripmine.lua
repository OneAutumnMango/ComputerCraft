--Stripmines for ores
-- goes to optimal level for the ore, digs in a straight line for how ever many blocks are specified,
-- comes back and checks the sides and above, if it finds an ore, dig it, move into the location,
-- check all the sides for another ore, loop until no more ores are found, go back

ore = tonumber(arg[1]) -- 1 is diamond, 2 is gold, 3 is redstone?
startHeight = tonumber(arg[2])
length = tonumber(arg[3])

oreLevel = {[1]=-54,
            [2]=-16}

coord = {x = 0,
         y = startHeight,
         z = 0,
         dir = 1}

oreList={["minecraft:deepslate_diamond_ore"]=1,
         ["minecraft:diamond_ore"]=1,
         ["minecraft:deepslate_gold_ore"]=2,
         ["minecraft:gold_ore"]=2,
         ["minecraft:deepslate_redstone_ore"]=3,
         ["minecraft:redstone_ore"]=3,
         ["minecraft:deepslate_emerald_ore"]=4,
         ["minecraft:emerald_ore"]=4,
         ["minecraft:deepslate_coal_ore"]=5,
         ["minecraft:coal_ore"]=5,
         ["minecraft:deepslate_lapis_ore"]=6,
         ["minecraft:lapis_ore"]=6}

function setContains(set, key) -- checks if a key is in a set, returns true if it is, returns false if not
    return set[key] ~= nil
end

function turnRight(coord) -- turns turtle right and updates coords
    turtle.turnRight()
    coord.dir = (coord.dir + 1) % 4
end

function turnLeft(coord) -- turns turtle left and updates coords
    turtle.turnLeft()
    coord.dir = (coord.dir - 1) % 4
end
    
function safeDigDown(coord)
    turtle.digDown()
    turtle.down()
    coord.y = coord.y - 1
end

function safeDigForward(coord) -- safely digs forward checking for falling blocks
    while turtle.detect() do
        turtle.dig()
        os.sleep(.3)
    end
    turtle.forward()

    if coord.dir == 1 then
        coord.x = coord.x + 1
    end

    if coord.dir == 2 then
        coord.z = coord.z + 1
    end

    if coord.dir == 3 then
        coord.x = coord.x - 1
    end

    if coord.dir == 0 then
        coord.z = coord.z - 1
    end
end

function safeDigUp(coord) -- safely digs upwards checking for falling blocks
    while turtle.detectUp() do
        turtle.digUp()
        os.sleep(.3)
    end
    turtle.up()
    coord.y = coord.y + 1
end

function oreForward(coord)  -- mines the block infront, moves forward, checks for ores 
    safeDigForward(coord)
    checkAllSides(coord)
    turnRight(coord)
    turnRight(coord)
    safeDigForward(coord)
    turnRight(coord)
    turnRight(coord)
    if coord.dir == 1 then
        coord.x = coord.x - 1
    end

    if coord.dir == 2 then
        coord.z = coord.z - 1
    end

    if coord.dir == 3 then
        coord.x = coord.x + 1
    end

    if coord.dir == 0 then
        coord.z = coord.z + 1
    end

end

function oreUp(coord)
    safeDigUp(coord)
    checkAllSides(coord)
    safeDigDown(coord)
end

function oreDown(coord)
    safeDigDown(coord)
    checkAllSides(coord)
    safeDigUp(coord)
end

function check()
    isBlock,data = turtle.inspect()
    if isBlock then
        if setContains(oreList,data.name) then
            safeDigForward(coord)
            checkAllSides(coord)
            turnRight(coord)
            turnRight(coord)
            safeDigForward(coord)
            turnRight(coord)
            turnRight(coord)
            if coord.dir == 1 then
                coord.x = coord.x - 1
            end

            if coord.dir == 2 then
                coord.z = coord.z - 1
            end

            if coord.dir == 3 then
                coord.x = coord.x + 1
            end

            if coord.dir == 0 then
                coord.z = coord.z + 1
            end
                end
            end
end

function checkUp()
    isBlock,data = turtle.inspectUp()
    if isBlock then
        if setContains(oreList,data.name) then
            safeDigUp(coord)
            checkAllSides(coord)
            safeDigDown(coord)
        end
    end
end

function checkDown()
    isBlock,data = turtle.inspectDown()
    if isBlock then
        if setContains(oreList,data.name) then
            safeDigDown(coord)
            checkAllSides(coord)
            safeDigUp(coord)
        end
    end
end

function getToY(startHeight, ore) -- moves the turtle to the desired y layer
    height = startHeight
    while oreLevel[ore] < height do
        safeDigDown()
        height = height - 1
    end
end

function safeDigLine(length)    -- digs forward length number of blocks
    for i=0, length do
        while turtle.detect() do
            turtle.dig()
            os.sleep(.3)
        end
        turtle.forward()
        coord.x = coord.x + 1
    end
end


function checkAllSides(coord) -- checks if there is a block in oreList on any side of the turtle
    --checkUp()
    isBlock,data = turtle.inspectUp()
    if isBlock then
        if setContains(oreList,data.name) then
            safeDigUp(coord)
            checkAllSides(coord)
            safeDigDown(coord)
        end
    end

    --checkDown()
    isBlock,data = turtle.inspectDown()
    if isBlock then
        if setContains(oreList,data.name) then
            safeDigDown(coord)
            checkAllSides(coord)
            safeDigUp(coord)
        end
    end

    --check()
    isBlock,data = turtle.inspect()
    if isBlock then
        if setContains(oreList,data.name) then
            safeDigForward(coord)
            checkAllSides(coord)
            turnRight(coord)
            turnRight(coord)
            safeDigForward(coord)
            turnRight(coord)
            turnRight(coord)
            if coord.dir == 1 then
                coord.x = coord.x - 1
            end

            if coord.dir == 2 then
                coord.z = coord.z - 1
            end

            if coord.dir == 3 then
                coord.x = coord.x + 1
            end

            if coord.dir == 0 then
                coord.z = coord.z + 1
            end
        end
    end

    turnRight(coord)

    --check()
    isBlock,data = turtle.inspect()
    if isBlock then
        if setContains(oreList,data.name) then
            safeDigForward(coord)
            checkAllSides(coord)
            turnRight(coord)
            turnRight(coord)
            safeDigForward(coord)
            turnRight(coord)
            turnRight(coord)
            if coord.dir == 1 then
                coord.x = coord.x - 1
            end

            if coord.dir == 2 then
                coord.z = coord.z - 1
            end

            if coord.dir == 3 then
                coord.x = coord.x + 1
            end

            if coord.dir == 0 then
                coord.z = coord.z + 1
            end
        end
    end

    turnRight(coord)

    --check()
    isBlock,data = turtle.inspect()
    if isBlock then
        if setContains(oreList,data.name) then
            safeDigForward(coord)
            checkAllSides(coord)
            turnRight(coord)
            turnRight(coord)
            safeDigForward(coord)
            turnRight(coord)
            turnRight(coord)
            if coord.dir == 1 then
                coord.x = coord.x - 1
            end

            if coord.dir == 2 then
                coord.z = coord.z - 1
            end

            if coord.dir == 3 then
                coord.x = coord.x + 1
            end

            if coord.dir == 0 then
                coord.z = coord.z + 1
            end
        end
    end

    turnRight(coord)

    --check()
    isBlock,data = turtle.inspect()
    if isBlock then
        if setContains(oreList,data.name) then
            safeDigForward(coord)
            checkAllSides(coord)
            turnRight(coord)
            turnRight(coord)
            safeDigForward(coord)
            turnRight(coord)
            turnRight(coord)
            if coord.dir == 1 then
                coord.x = coord.x - 1
            end

            if coord.dir == 2 then
                coord.z = coord.z - 1
            end

            if coord.dir == 3 then
                coord.x = coord.x + 1
            end

            if coord.dir == 0 then
                coord.z = coord.z + 1
            end
        end
    end

    turnRight(coord)            
end



function main(ore, startHeight, length)
    getToY(startHeight,ore)
    safeDigLine(length)
    turnRight(coord)
    turnRight(coord)
    for i=1, length do
        checkAllSides(coord)
        safeDigForward(coord)
        coord.x = coord.x - 1
    end
    turnRight(coord)
    turnRight(coord)
end

main(ore, startHeight, length)
