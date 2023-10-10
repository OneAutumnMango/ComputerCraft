
function isObs(data) 
    if string.match(data.name, "obsidian$") then
        return true
    end 
    return false
end


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


function getIndex(tbl, val)
    for i, v in pairs(tbl) do
        if v == val then return i end
    end
end



miner = {
    coord = vector.new(0, 0, 0),
    facing = 0,
    
    oresToMine = {vector.new(1, 0, 0)},


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
                if isObs(data) then
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
                if isObs(data) then
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
                if isObs(data) then
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
    if dif:dot(dirTable[miner.facing]) < 0 then 
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

function miner:mine(dest)
    local rtrn = miner.coord
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
            if next(miner.oresToMine) ~= nil then
                if miner.check.up() then
                    miner.dig.up()
                end
            end
        end

        -- return to original pos and orientation
        
    end
    

    print("coming back...")
    while miner.coord ~= rtrn do
        miner:stepToCoord(rtrn, false) -- no need to check since youve already done that
    end
    miner:face(0)
end



local s = os.clock()

miner:mine()

print("This took "..(os.clock()-s).."s")