local args = {...}  --> file names to install

local function getSide()  --> search for drive periferal 
	local sides = peripheral.getNames()
	for _, side in ipairs(sides) do
		if peripheral.getType(side) == "drive" then
			return side
		end
	end
	print("Drive not found.")
	fs.exit()  --> if no drive found
end

local function getDiskPath()
	local side = getSide()
	if not disk.isPresent(side) then  --> validate connection to disk
		print("Disk not found.")
		shell.exit()
	end
	return disk.getMountPath(side)
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


local function install(files)
	local root = getDiskPath()
	if files[1] == "update" then files = getFileNames() end
	if files[1] == "all" then files = getFileNames(root) end
	if files[1] == "list" then 
		for _, file in ipairs(getFileNames(root)) do print(file) end
		return
	end

	for _, file in ipairs(files) do
		local path = root.."/"..file
		if not fs.exists(path) then 
			print("File not found at: "..path)
			return
		end
		if fs.exists(file) then fs.delete(file) end
		fs.copy(path, file)
	end
end


install(args)