local basalt = dofile("/disk/basalt.lua")

local mainFrame = basalt.createFrame("mainFrame"):show()
local monitor = mainFrame:addMonitor("right"):show()

local button = monitor 
        :addButton("clickableButton")
        :setPosition(4,4) 
        :setText("Click me!")
        :onClick(
            function() 
                basalt.debug("I got clicked!") 
            end
        )
        :show()

basalt.autoUpdate()


