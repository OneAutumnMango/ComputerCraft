local args = {...}
local length = args[1]
local width = args[2]
local depth = args[3]

dirTable = {
    [0] = vector.new(1, 0, 0),
    [1] = vector.new(0, 0, 1),
    [2] = vector.new(-1, 0, 0),
    [3] = vector.new(0, 0, -1)
}

dir = {
    up = vector.new(0, 1, 0),
    down = vector.new(0, -1, 0)
}

miner = {
    coord = vector.new(0, 0, 0),
    facing = 0,

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
    }
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

function miner:isFull()
    for i=1, 16 do
        if turtle.getItemCount(i) == 0 then
            return false
        end
    end
    return true
end

function miner:returnToChest()
    while miner.coord ~= vector.new(0, 0, 0) do
        miner:stepToCoord(vector.new(0, 0, 0))
    end
    miner:face(0)
end

function miner:depositAll()
    for i=1, 16 do 
        turtle.select(i)
        turtle.dropUp()
    end
end

function miner:stepToCoord(coord)
    if coord:dot(dirTable[miner.facing]) < 0 then -- If direction * direction < 0 directions are opposing -> if miner.coord between 2 dirs * direction -> directions are aligned
        miner.dig.forward()
        return
    elseif coord:dot(dir.up) < 0 then 
        miner.dig.up()
        return
    elseif coord:dot(dir.down) < 0 then 
        miner.dig.down()
        return
    else
        miner:turnRight()
        if coord:dot(dirTable[miner.facing]) < 0 then 
            miner.dig.forward()
            return
        else
            miner:turnRight()
            if coord:dot(dirTable[miner.facing]) < 0 then 
                miner.dig.forward()
                return
            else
                miner:turnRight()
                miner.dig.forward()
                return
            end
        end
    end
end

function miner:quarry()
    local turnRight = true

    for i = 0, depth do
        miner.dig.down()
        for j = 0, width do
            for k = 0, length do
                miner.dig.forward()
            end

            if turnRight then
                miner:turnRight()
            else
                miner:turnLeft()
            end
            turnRight = not turnRight
        end

        if miner:isFull() then
            miner:returnToChest()
            miner:depositAll()
        end

        while miner.coord ~= vector.new(0, -i-1, 0) do
            miner:stepToCoord(vector.new(0, -i-1, 0))
        end
        miner:face(0)
    end
end

miner:quarry()
