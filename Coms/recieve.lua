local args = {...}
rednet.open("right")

if args[1] == "list" then
    rednet.broadcast(args, "list")
else 
    rednet.broadcast(args, "install")
end

for _, arg in ipairs(args) do
    local senderID, msg, proto = rednet.receive()
    print("Message recieved from "..senderID)

    if proto == "FNF" then 
        print("File not found") 
    elseif proto == "list" then
        print(msg)
    elseif proto == "install" then
        local f = fs.open(arg, "w")
        f.write(msg)
        f.close()
    end
end


