local function isIn(tbl, index) -- checks if a key is in a set
    return tbl[index] ~= nil
end

local function isOre(data) 
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

Miner = {}
Miner.__index = {
    facing = 0;                  -- current facing direction
    coord = vector.new(0, 0, 0); -- currect coord
    oresToMine = {};

    dir = {
        [0]  = vector.new(1, 0, 0),
        [1]  = vector.new(0, 0, 1),
        [2]  = vector.new(-1, 0, 0),
        [3]  = vector.new(0, 0, -1),
        up   = vector.new(0, 1, 0),
        down = vector.new(0, -1, 0)
    };


    dig = function (self)
        while not turtle.forward() do
            turtle.dig()
        end
        self.coord = self.coord + self.dir[self.facing]
    end,
    digUp = function (self)
        while not turtle.up() do
            turtle.digUp()
        end
        self.coord = self.coord + self.dir.up
    end,
    digDown = function (self)
        while not turtle.down() do
            turtle.digDown()
        end
        self.coord = self.coord + self.dir.down
    end,


    turnLeft = function (self)
        turtle.turnLeft()
        self.facing = (self.facing - 1) % 4
    end,

    turnRight = function (self)
        turtle.turnRight()
        self.facing = (self.facing + 1) % 4
    end,

    face = function (self, dirToFace)  -- faces the given direction (0, 1, 2, 3)
        if (dirToFace == self.facing) then return
        elseif (dirToFace == (self.facing - 1) % 4) then self:turnLeft()
        elseif (dirToFace == (self.facing + 1) % 4) then self:turnRight()
        else self:turnRight(); self:turnRight() end
    end;


    check = function(self)
        local isBlock, data = turtle.inspect()
        if isBlock then
            if isOre(data) then
                local oreCoord = self.coord + self.dir[self.facing]
                if not isIn(self.oresToMine, oreCoord) then
                    table.insert(self.oresToMine, oreCoord)
                end
            end
        end
    end,
    checkUp = function(self)
        local isBlock, data = turtle.inspectUp()
        if isBlock then
            if isOre(data) then
                local oreCoord = self.coord + self.dir.up
                if not isIn(self.oresToMine, oreCoord) then
                    table.insert(self.oresToMine, oreCoord)
                end
            end
        end
    end,
    checkDown = function(self)
        local isBlock, data = turtle.inspectDown()
        if isBlock then
            if isOre(data) then
                local oreCoord = self.coord + self.dir.down
                if not isIn(self.oresToMine, oreCoord) then
                    table.insert(self.oresToMine, oreCoord)
                end
            end
        end
    end,
    checkAll = function (self)
        self:check()
        self:checkUp()
        self:checkDown()
    end,
    checkAllSides = function (self)
        self:check()
        self:checkUp()
        self:checkDown()
        self:turnRight()
        self:check()
        self:turnRight()
        self:check()
        self:turnRight()
        self:check()
        self:turnRight()  -- faces original dir
    end,



    getClosest = function (self)  -- returns closest ore to miner  (unless of course it is greater than 10mil blocks away)
        local min = 10000000
        local minV = nil
        for i, v in ipairs(self.oresToMine) do
            local l = (self.coord - v):length()
            if l < min then min = l; minV = v end
        end
        return minV
    end;


    stepToCoord = function (self, oreV, check)  -- takes one step towards the desired location
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
        if check then self:checkAllSides() end
    end,


    mineToDest = function (self, dest)
        local rtrn = self.coord

        while self.coord ~= dest do
            self:stepToCoord(dest)

            if next(self.oresToMine) ~= nil then
                local wasAt = self.coord
                local wasFacing = self.facing

                while next(self.oresToMine) ~= nil do  -- while there are known ores to mine
                    local closest = self:getClosest()  -- pick closest ore
                    print("finding "..closest:tostring())

                    while self.coord ~= closest do
                        self:stepToCoord(closest)  -- step to ore and mine it
                    end
                    table.remove(self.oresToMine, getIndex(self.oresToMine, closest))  -- remove value when mined
                end

                -- return to original pos and orientation
                print("coming back...")
                while self.coord ~= wasAt do
                    self:stepToCoord(wasAt)
                end
                self:face(wasFacing)
            end
        end

        print("coming back...")
        while self.coord ~= rtrn do
            self:stepToCoord(rtrn, false) -- no need to check since youve already done that
        end
    end,


    mineLine = function (self, length)  -- mines a line of length length forward
        local wasFacing = self.facing
        local dest = self.coord + self.dir[self.facing]:mul(length)

        self:mineToDest(dest)
        self:face(wasFacing)  -- face original dir
    end,
}

-- function Miner:new(obj)
--     obj = obj or {}  -- allow previous metatable entries
--     setmetatable(obj, self)
--     --self.__call = function(...) return Miner.new(...) end  -- so you can call Miner() instead of Miner.new()   (i hope)
--     self.__index = self
--     return self
-- end


function Miner.new()
    return setmetatable({}, Miner)
end