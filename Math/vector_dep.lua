local vector3 = {}
local vectorMeta = {}  -- metatable


function vector3.new(x, y, z)
    local v = {x, y, z}
    return v
end

function vector3.add(v1, v2)
    return {v1.x + v2.x, v1.y + v2.y, v1.z + v2.z}
end

-- function vector3.dot(v1, v2)
--     return 
-- end

setmetatable(vector3, {
    __call = function(...) return vector3.new(...) end,
    __index = function(vector3, key)
        if key == "x" then return vector3[1] end
        if key == "y" then return vector3[2] end
        if key == "z" then return vector3[3] end
    end
})