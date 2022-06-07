local args = {...}
-- ore = args[]
-- curHeight = args[]

local heights = {
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


function isIn(table, index) -- checks if a key is in a set, returns true if it is, returns false if not
    return table[index] ~= nil
end


function isOre(data) 
    if string.match(data.name, "_ore$") then -- looks for "_ore" at the end of the string
        return true
    end 
    return false
end





miner = {
    coord = vector.new(0, 0, 0),
    facing = 0,
    
    oresToMine = {},


    dig = {
        f = function()
            while not turtle.forward() do
                turtle.dig()
            end
            miner.coord = miner.coord + dirTable[facing]
        end,
        u = function()
            while not turtle.up() do
                turtle.digUp()
            end
            miner.coord = miner.coord + dir.up
        end,
        d = function()
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
    local check = check or true  -- check = false if you dont want to check
    local dif = miner.coord - oreV
    if dif:dot(dirTable[miner.facing]) < 0 then 
        miner.dig.f()
        if check then miner:checkAll() end
        return
    elseif dif:dot(dir.up) < 0 then 
        miner.dig.u()
        if check then miner:checkAll() end
        return
    elseif dif:dot(dir.down) < 0 then 
        miner.dig.d()
        if check then miner:checkAll() end
        return
    else 
        miner:turnRight()
        if dif:dot(dirTable[miner.facing]) < 0 then 
            miner.dig.f()
            if check then miner:checkAll() end
            return
        else 
            miner:turnRight()
            if dif:dot(dirTable[miner.facing]) < 0 then 
                miner.dig.f()
                return
                if check then miner:checkAll() end
            else
                miner:turnRight()
                miner.dig.f()
                if check then miner:checkAll() end
                return
            end
        end
    end
end

-- miner:checkAll()
-- print(textutils.serialize(miner.oresToMine))
-- print(textutils.serialize(miner:getClosest()))

miner:stepToCoord(vector.new(1, -3, 0))
