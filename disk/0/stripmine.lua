--Stripmines for ores
-- goes to optimal level for the ore, digs in a straight line for how ever many blocks are specified,
-- comes back and checks the sides and above, if it finds an ore, dig it, move into the location,
-- check all the sides for another ore, loop until no more ores are found, go back

local ore = tonumber(arg[1]) -- 1 is diamond, 2 is gold, 3 is starting position. might add more
local startHeight = tonumber(arg[2])
local branches = tonumber(arg[3])
local length = tonumber(arg[4])

local pokeholeSpacing = 4

local oreLevel = {[1]=-54,
                  [2]=-16,
                  [3]=startHeight}

local coord =  {x = 0,
                y = startHeight,
                z = 0,
                dir = 1}

local oreList =    {["minecraft:deepslate_diamond_ore"]=1,
                    ["minecraft:diamond_ore"]=1,
                    ["minecraft:deepslate_gold_ore"]=2,
                    ["minecraft:gold_ore"]=2,
                    ["minecraft:deepslate_redstone_ore"]=3,
                    ["minecraft:redstone_ore"]=3,
                    ["minecraft:deepslate_emerald_ore"]=4,
                    ["minecraft:emerald_ore"]=4,
                    ["minecraft:deepslate_coal_ore"]=5,
                    ["minecraft:coal_ore"]=5}

local valuables =  {["minecraft:diamond"]=1,
                    ["minecraft:raw_gold"]=2,
                    ["minecraft:redstone"]=3,
                    ["minecraft:emerald"]=4,
                    ["minecraft:coal"]=5,
                    ["minecraft:flint"]=6}

local function setContains(set, key) -- checks if a key is in a set, returns true if it is, returns false if not
    return set[key] ~= nil
end

local function correctDir(coord)
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

local function turnRight(coord) -- turns turtle right and updates coord
    turtle.turnRight()
    coord.dir = (coord.dir + 1) % 4
end

local function turnLeft(coord) -- turns turtle left and updates coord
    turtle.turnLeft()
    coord.dir = (coord.dir - 1) % 4
end

local function turnAround(coord)
    turtle.turnRight()
    turtle.turnRight()
    coord.dir = (coord.dir + 2) % 4
end

local function safeDigDown(coord)
    turtle.digDown()
    turtle.down()
    coord.y = coord.y - 1
end

local function safeDigForward(coord) -- safely digs forward checking for falling blocks
    while not turtle.forward() do
        turtle.dig()
    end
    correctDir(coord)
end

local function safeDigUp(coord) -- safely digs upwards checking for falling blocks
    while not turtle.up() do
        turtle.digUp()
    end
    coord.y = coord.y + 1
end

local function safeDigLine(length,coord)    -- digs forward length number of blocks
    for i=0, length do
        while not turtle.forward() do
            turtle.dig()
        end
        correctDir(coord)
    end
end

local function getToY(height, ore) -- moves the turtle to the desired y layer
    while oreLevel[ore] < height do
        safeDigDown(coord)
        height = height - 1
    end
    while oreLevel[ore] > coord.y do
        safeDigUp(coord)
        height = height + 1
    end
end

local function oreForward(coord)  -- mines the block infront, moves forward, checks for ores 
    safeDigForward(coord)
    checkAllSides(coord)
    turnAround(coord)
    safeDigForward(coord)
    turnAround(coord)
end

local function oreUp(coord)
    safeDigUp(coord)
    checkAllSides(coord)
    safeDigDown(coord)
end

local function oreDown(coord)
    safeDigDown(coord)
    checkAllSides(coord)
    safeDigUp(coord)
end

local function check()
    isBlock,data = turtle.inspect()
    if isBlock then
        if setContains(oreList,data.name) then
            safeDigForward(coord)
            checkAllSides(coord)
            turnAround(coord)
            safeDigForward(coord)
            turnAround(coord)
        end
    end
end

local function checkUp()
    isBlock,data = turtle.inspectUp()
    if isBlock then
        if setContains(oreList,data.name) then
            safeDigUp(coord)
            checkAllSides(coord)
            safeDigDown(coord)
        end
    end
end

local function checkDown()
    isBlock,data = turtle.inspectDown()
    if isBlock then
        if setContains(oreList,data.name) then
            safeDigDown(coord)
            checkAllSides(coord)
            safeDigUp(coord)
        end
    end
end

local function checkAllSides(coord) -- checks if there is a block in oreList on any side of the turtle
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
            turnAround(coord)
            safeDigForward(coord)
            turnAround(coord)
        end
    end

    turnRight(coord)

    --check()
    isBlock,data = turtle.inspect()
    if isBlock then
        if setContains(oreList,data.name) then
            safeDigForward(coord)
            checkAllSides(coord)
            turnAround(coord)
            safeDigForward(coord)
            turnAround(coord)
        end
    end

    turnRight(coord)

    --check()
    isBlock,data = turtle.inspect()
    if isBlock then
        if setContains(oreList,data.name) then
            safeDigForward(coord)
            checkAllSides(coord)
            turnAround(coord)
            safeDigForward(coord)
            turnAround(coord)
        end
    end

    turnRight(coord)

    --check()
    isBlock,data = turtle.inspect()
    if isBlock then
        if setContains(oreList,data.name) then
            safeDigForward(coord)
            checkAllSides(coord)
            turnAround(coord)
            safeDigForward(coord)
            turnAround(coord)
        end
    end

    turnRight(coord)            
end

local function dropJunk() -- cycles through all inventory slots and drops anything not on the "valuables" list
    for i=1, 16 do
        turtle.select(((turtle.getSelectedSlot())%16)+1)
        local data = turtle.getItemDetail()
        if data then
            if not setContains(valuables,data.name) then
                turtle.drop()
            end
        end
    end
end

local function pokehole(length, coord)
    dropJunk()
    safeDigLine(length,coord)
    turnAround(coord)
    for i=0, length do
        checkAllSides(coord)
        safeDigForward(coord)
    end
    turnAround(coord)
end

local function main(ore, startHeight, branches, length)
    getToY(coord.y,ore)
    safeDigLine(pokeholeSpacing*(branches-1),coord)
    turnAround(coord)
    safeDigLine(pokeholeSpacing*(branches-1),coord)
    turnAround(coord)
    for i=1, branches do
        turnLeft(coord)
        pokehole(length, coord)
        turnAround(coord)
        pokehole(length, coord)
        turnLeft(coord)
        for i=1, pokeholeSpacing do
            turtle.forward()
            correctDir(coord)
        end
    end
    turnAround(coord)
    safeDigLine(pokeholeSpacing*(branches-1),coord)
    turnAround(coord)
    getToY(coord.y,3)
end

main(ore, startHeight, branches, length)