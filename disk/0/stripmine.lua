--Stripmines for ores
-- goes to optimal level for the ore, digs in a straight line for how ever many blocks are specified,
-- comes back and checks the sides and above, if it finds an ore, dig it, move into the location,
-- check all the sides for another ore, loop until no more ores are found, go back

ore = tonumber(arg[1]) -- 1 is diamond, 2 is gold, 3 is redstone?
startHeight = tonumber(arg[2])
length = tonumber(arg[3])

oreLevel = {[1]=-54,
            [2]=-16}

coord = {x = 0,
         y = 0,
         z = 0}

function safeDigDown()
    turtle.digDown()
    turtle.down()
end

function getToY(startHeight, ore)
    height = startHeight
    while oreLevel[ore] < height do
        safeDigDown()
        height = height - 1
    end
end

function safeDigLine(length)
    for i=0, length do
        while turtle.detect() do
            turtle.dig()
        end
    end
end
print("brian farts hah!")

function main(ore, startHeight, length)
    safeDigLine(length)
end

main(ore, startHeight, length)
