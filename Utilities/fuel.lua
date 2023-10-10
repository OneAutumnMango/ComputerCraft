len = tonumber(arg[1]) or 100 -- 100 is max distance needed to refuel

function isLava(data) 
    if string.match(data.name, "lava$") then
        return true
    end 
    return false
end


slurp = function()
		_, data = turtle.inspect()
		if isLava(data) then
			turtle.place()
			turtle.refuel()
		end
		_, data = turtle.inspectDown()
		if isLava(data) then
			turtle.placeDown()
			turtle.refuel()
		end
	end


refuel = {
	x = 0,

	checkFuel = function()
		print(turtle.getFuelLevel())
		if turtle.getFuelLevel() > 99000 then
			return false
		end
		return true
	end
}

function refuel:forward()
	refuel.x = refuel.x + 1
	turtle.forward()
end

function refuel:rtrn()
	while refuel.x ~= 0 do
		turtle.back()
		refuel.x = refuel.x - 1
	end
end

function refuel:getFuel(len)
	while refuel.x < len and refuel.checkFuel() do
		slurp()
		refuel:forward()
	end
	refuel:rtrn()
end

refuel:getFuel(len)

