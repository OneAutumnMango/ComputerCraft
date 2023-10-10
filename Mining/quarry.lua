os.loadAPI("Miner")
local miner = Miner.Miner.new()

local args = {...}
local curHeight = args[1]
local length = args[2] or 10
local width = args[3] or 6  -- please only even numbers (itll round down to nearest even number)
local depth = args[4] or -59

function miner:stepToCoordQuarry(oreV, check)  -- takes one step towards the desired location
    local default = true  -- required if want to allow bool false
    check = (check==nil and default) or check  -- check = false if you dont want to check the surrounding blocks

    local dif = self.coord - oreV
    if dif:dot(self.dir[self.facing]) < 0 then -- If direction * direction < 0 directions are opposing -> if diff between 2 dirs * direction -> directions are aligned
        self:dig()
    elseif dif:dot(self.dir.up) < 0 then
        self:digUp()
    elseif dif:dot(self.dir.down) < 0 then
        self:digDown()
    else
        self:turnRight()
        if dif:dot(self.dir[self.facing]) < 0 then  -- can use the principal of miner.face() to determine which dir to turn to 
            self:dig()
        else
            self:turnRight()
            if dif:dot(self.dir[self.facing]) < 0 then
                self:dig()
            else
                self:turnRight()
                self:dig()
            end
        end
    end
    if check then self:checkAll() end
end


function miner:mineToDestQuarry(dest)
    while self.coord ~= dest do
        self:stepToCoordQuarry(dest)

        if next(self.oresToMine) ~= nil then
            local wasAt = self.coord
            local wasFacing = self.facing

            while next(self.oresToMine) ~= nil do  -- while there are known ores to mine
                local closest = self:getClosest()  -- pick closest ore
                print("finding "..closest:tostring())

                while self.coord ~= closest do
                    self:stepToCoord(closest)  -- step to ore and mine it
                end
                table.remove(self.oresToMine, Miner.getIndex(self.oresToMine, closest))  -- remove value when mined
            end

            -- return to original pos and orientation
            print("coming back...")
            while self.coord ~= wasAt do
                self:stepToCoordQuarry(wasAt)
            end
            self:face(wasFacing)
        end
    end
end

function miner:mineLine(len)  -- mines a line of length length forward
    local wasFacing = self.facing
    local dest = self.coord + self.dir[self.facing]:mul(len)

    self:mineToDestQuarry(dest)
    self:face(wasFacing)  -- face original dir
end




local function mineLayer()
    for line = 1, width, 2 do -- two lines at a time
        miner:mineLine(length)
        miner:turnRight()
        miner:dig()
        miner:turnRight()

        miner:mineLine(length)
        miner:turnLeft()
        if line ~= width then
            miner:dig()
        end
        miner:turnLeft()
    end
end

local function mineLayers()
    for i = 1, (curHeight - depth), 3 do
        miner:digDown()
        miner:digDown()
        miner:digDown()
        mineLayer()
        miner:turnLeft()
        for j = 1, width do
            miner:dig()
        end
        miner:turnRight()
    end

    local dest = vector.new(0,0,0)
    while miner.coord ~= dest do
        miner:stepToCoordQuarry(dest)
    end
end

mineLayers()
