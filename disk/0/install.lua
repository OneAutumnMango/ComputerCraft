local args = {...}  --> file names to install

local function getSide()  --> search for drive periferal 
	local sides = peripheral.getNames()
	for _, side in ipairs(sides) do
		if peripheral.getType(side) == "drive" then
			return side
		end
	end
	print("Drive not found.")
	os.exit()  --> if no drive found
end

local function getDiskPath()
	local side = getSide()
	if not disk.isPresent(side) then  --> validate connection to disk
		print("Disk not found.")
		os.exit()
	end
	return disk.getMountPath(side)
end


local function install(files)
	local root = getDiskPath()

	for _, file in ipairs(files) do
		local path = root.."/"..file
		if not fs.exists(path) then 
			print("File not found at: "..path)
			os.exit()
		end
		if fs.exists(file) then fs.delete(file) end
		fs.copy(path, file)
	end
end

install(args)
