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
    vector.new(1, 0, 0),
    vector.new(0, 0, 1),
    vector.new(-1, 0, 0),
    vector.new(0, 0, -1)
}

local dir = {
    up = vector.new(0, 1, 0),
    down = vector.new(0, -1, 0) 
}


function isIn(table, index) -- checks if a key is in a set, returns true if it is, returns false if not
    return table[index] ~= nil
end


local dig = {}
dig.f = function()
    while not turtle.forward() do
        turtle.dig()
    end
    return true
end
dig.u = function()
    while not turtle.up() do
        turtle.digUp()
    end
    return true
end
dig.d = function()
    while not turtle.down() do
        turtle.digDown()
    end
    return true
end


function isOre(data) 
    if string.match(data.name, "_ore$") then 
        return true
    end 
    return false
end





miner = {
    coord = vector.new(0, 0, 0),
    facing = 1,
    
    oresToMine = {},


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
        end,
    },
}

print(miner.coord)
miner.check.front()
miner.check.up()
miner.check.down()
print(textutils.serialize(miner.oresToMine))

