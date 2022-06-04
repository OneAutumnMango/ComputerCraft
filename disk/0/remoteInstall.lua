rednet.open("top")

local function getFileTxt(filePath)
    print(filePath)
    local f = fs.open(filePath, "r")
    return f.readAll()
end

local function split(s)
    local out = {}
    for match in (s.." "):gmatch("(.-)".." ") do
        table.insert(out, match)
    end
    return out
end

local function sendFile(path, senderID)
    if fs.exists(path) then
        local f = getFileTxt(path)
        rednet.send(senderID, f, "install")
        print("file sent to "..senderID)
        return true
    else return false end
end

local function getFileNames(path)
	local path = path or "."
	files = fs.find(path.."/*.lua")
	if path == "." then
		return files
	end

	for i, file in ipairs(files) do
		files[i] = files[i]:sub(#path+1)
	end
	return files
end

while true do
    local senderID, msg, proto = rednet.receive()
    print("Message recieved from "..senderID)

    -- msg =  all, update, list   (continue after these)
    -- if msg == "update" then files = getFileNames() end
	-- if msg == "all" then files = getFileNames(root) end

	if proto == "list" then 
        local f = textutils.serialize(getFileNames("disk"))
		rednet.send(senderID, f, "list")
    elseif proto == "install" then
        for _, fName in ipairs(msg) do
            filePath = "disk/"..fName
            if not sendFile(filePath, senderID) then
                rednet.send(senderID, "AHHHH", "FNF")
            end
        end
    end
end
