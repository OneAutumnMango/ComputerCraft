local width = tonumber(arg[1])
local height = tonumber(arg[2])

local function line()
    for block=1,width-1 do
        while turtle.getItemCount(turtle.getSelectedSlot()) == 0 do
            turtle.select(turtle.getSelectedSlot() % 16 + 1)  -- cycle slot until not empty (will get stuck if out of blocks)
        end
        turtle.placeDown()
        turtle.forward()
    end
    turtle.turnRight()
end

local function row()
    turtle.up()
    line()
    line()
    line()
    line()
end

while height > 0 do
    row()
    print("placed layer "..height)
    height = height - 1
end