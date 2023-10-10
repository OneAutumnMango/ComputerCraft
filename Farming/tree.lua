local depth = tonumber(arg[1])
local width = tonumber(arg[2])

os.loadAPI("Miner.lua")
local miner = Miner.Miner.new()



local function isLog(data)
    if string.match(data.name, "_log$") then -- looks for "_ore" at the end of the string
        return true
    end
    return false
end


while miner.coord.z < width do
    while miner.coord.x < depth do -- go forward
        print("z="..miner.coord.z.." x="..miner.coord.x)
        miner:dig()

        local isBlock, data = turtle.inspectUp()
        while isBlock do
            if not isLog(data) then  -- go up until no logs
                break
            end
            miner:digUp()
            isBlock, data = turtle.inspectUp()
        end


        while miner.coord.y > 0 do  -- go down
            miner:digDown()
        end
    end


    miner:turnLeft()
    miner:turnLeft()
    while miner.coord.x > 0 do  -- back to (0, x, x)
        miner:dig()
    end

    miner:turnLeft()
    miner:dig()
    miner:turnLeft()
end

print("Returning to (0, 0, 0)...")
local dest = vector.new(0,0,0)
while miner.coord ~= dest do
    miner:stepToCoord(dest, false)
end
