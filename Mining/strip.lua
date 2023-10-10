local args = {...}
local curHeight = args[1]
local oreType = args[2]

local oreTable = {
    ["diamond"] = -58,
    ["iron"] = 16,
    ["lapis"] = 0,
    ["gold"] = -16,
    ["redstone"] = -58,
    ["copper"] = 48
}

local dirTable = {
    [0] = vector.new(1, 0, 0),
    [1] = vector.new(0, 0, 1),
    [2] = vector.new(-1, 0, 0),
    [3] = vector.new(0, 0, -1)
}

local dir = {
    up = vector.new(0, 1, 0),
    down = vector.new(0, -1, 0)
}


function isIn(tbl, index) -- checks if a key is in a set, returns true if it is, returns false if not
    return tbl[index] ~= nil
end


function isOre(data) 
    if string.match(data.name, "_ore$") then -- looks for "_ore" at the end of the string
        return true
    end 
    return false
end


function getIndex(tbl, val)
    for i, v in pairs(tbl) do
        if v == val then return i end
    end
end


function send(msg)
    rednet.broadcast(msg, "miner")
end




miner = {
    coord = vector.new(0, 0, 0),
    facing = 0,
    
    oresToMine = {},


    dig = {
        forward = function()
            while not turtle.forward() do
                turtle.dig()
            end
            miner.coord = miner.coord + dirTable[miner.facing]
        end,
        up = function()
            while not turtle.up() do
                turtle.digUp()
            end
            miner.coord = miner.coord + dir.up
        end,
        down = function()
            while not turtle.down() do
                turtle.digDown()
            end
            miner.coord = miner.coord + dir.down
        end
    },

    check = {
        front = function()
            local isBlock, data = turtle.inspect()
            if isBlock then
                if isOre(data) then
                    local oreCoord = miner.coord + dirTable[miner.facing]
                    if not isIn(miner.oresToMine, oreCoord) then
                        table.insert(miner.oresToMine, oreCoord)
                    end
                end
            end
        end,
        up = function()
            local isBlock, data = turtle.inspectUp()
            if isBlock then
                if isOre(data) then
                    local oreCoord = miner.coord + dir.up
                    if not isIn(miner.oresToMine, oreCoord) then
                        table.insert(miner.oresToMine, oreCoord)
                    end
                end
            end
        end,
        down = function()
            local isBlock, data = turtle.inspectDown()
            if isBlock then
                if isOre(data) then
                    local oreCoord = miner.coord + dir.down
                    if not isIn(miner.oresToMine, oreCoord) then
                        table.insert(miner.oresToMine, oreCoord)
                    end 
                end
            end
        end
    },
}


function miner:turnLeft()
    turtle.turnLeft()
    miner.facing = (miner.facing - 1) % 4
end

function miner:turnRight()
    turtle.turnRight()
    miner.facing = (miner.facing + 1) % 4
end

function miner:face(dirToFace)
    if dirToFace == (miner.facing - 1) % 4 then miner:turnLeft()
    elseif dirToFace == (miner.facing + 1) % 4 then miner:turnRight()
    else miner:turnRight(); miner:turnRight() end
end


function miner:checkAll()
    miner.check.up()
    miner.check.down()
    miner.check.front()
    miner:turnRight()
    miner.check.front()
    miner:turnRight()
    miner.check.front()
    miner:turnRight()
    miner.check.front()
    miner:turnRight()  -- faces original dir
end

function miner:getClosest()
    local min = 10000000
    local minV = nil
    for i, v in ipairs(miner.oresToMine) do
        local l = (miner.coord - v):length()
        if l < min then min = l; minV = v end
    end
    return minV
end

function miner:stepToCoord(oreV, check)
    local default = true  -- required if want to allow bool false
    local check = (check==nil and default) or check  -- check = false if you dont want to check

    local dif = miner.coord - oreV
    if dif:dot(dirTable[miner.facing]) < 0 then -- If direction * direction < 0 directions are opposing -> if diff between 2 dirs * direction -> directions are aligned
        miner.dig.forward()
        if check then miner:checkAll() end
        return
    elseif dif:dot(dir.up) < 0 then 
        miner.dig.up()
        if check then miner:checkAll() end
        return
    elseif dif:dot(dir.down) < 0 then 
        miner.dig.down()
        if check then miner:checkAll() end
        return
    else 
        miner:turnRight()
        if dif:dot(dirTable[miner.facing]) < 0 then 
            miner.dig.forward()
            if check then miner:checkAll() end
            return
        else 
            miner:turnRight()
            if dif:dot(dirTable[miner.facing]) < 0 then 
                miner.dig.forward()
                if check then miner:checkAll() end
                return
            else
                miner:turnRight()
                miner.dig.forward()
                if check then miner:checkAll() end
                return
            end
        end
    end
end

function miner:mineToDest(dest)
    local rtrn = miner.coord

    while miner.coord ~= dest do
        miner:stepToCoord(dest)

        if next(miner.oresToMine) ~= nil then
            local wasAt = miner.coord
            local wasFacing = miner.facing

            while next(miner.oresToMine) ~= nil do  -- while there are known ores to mine
                local closest = miner:getClosest()  -- pick closest ore
                print("finding "..closest:tostring())

                while miner.coord ~= closest do
                    miner:stepToCoord(closest)  -- step to ore and mine it
                end
                table.remove(miner.oresToMine, getIndex(miner.oresToMine, closest))  -- remove value when mined
            end

            -- return to original pos and orientation
            print("coming back...")
            while miner.coord ~= wasAt do
                miner:stepToCoord(wasAt)
            end
            miner:face(wasFacing)
        end
    end

    print("coming back...")
    while miner.coord ~= rtrn do
        miner:stepToCoord(rtrn, false) -- no need to check since youve already done that
    end
end

function miner:minePokeHoles(len)  -- len of pokehole
    local dest 
    dest = miner.coord + vector.new(0, 0, len)
    miner:mineToDest(dest)  -- mine right
    dest = miner.coord + vector.new(0, 0, -len)
    miner:mineToDest(dest)  -- mine left
    miner:face(0)  -- face original dir
end

function miner:mine(offset, len, ore)
    local offset = offset or 4
    local len = len or 64
    local ore = ore or "diamond"

    local h = vector.new(0, oreTable[ore], 0)
    while miner.coord ~= h do  -- go down to correct height
        miner:stepToCoord(h, false)   -- maybe dont check for ores??
    end

    for hole=1, len/offset do
        send("mining pokeholes")
        miner:minePokeHoles(len)  -- mine poke holes

        local dest = miner.coord + vector.new(offset, 0, 0)
        while miner.coord ~= dest do  -- step forward offset
            send("mining hole "..hole)
            miner:stepToCoord(dest)
        end
    end

    send("coming home")
    while miner.coord ~= h do  -- return to below hole
        miner:stepToCoord(h, false)   
    end

    local start = vector.new(0, curHeight, 0)
    while miner.coord ~= start do  -- return to start
        miner:stepToCoord(start, false)   
    end
end


local s = os.clock()
miner.coord.y = curHeight
miner:mine(4, 64, oreType)
print(s)
print(os.clock())
print("this took"..(os.clock()-s))