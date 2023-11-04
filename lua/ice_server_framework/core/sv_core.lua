function IceConsolePrint(str)
    print("["..IceModulesConfig.ServerName.." - Server] "..str)
end 

function IceDevMessage(str, type)
    if !(IceModulesConfig.DebugMessages) then return end
    local type = type or "good"
    local strColor = Color(171,171,171)

    if type == "bad" then
        strColor = Color(251,61,61)
    end 

    for _, pl_ in pairs(player.GetAll()) do 
        if pl_:IsSuperAdmin() then
            chat.AddText(pl_, Color(0,155,255), "[-ICE- Modules - Debug] ", strColor, str)
        end
    end

    IceConsolePrint(str)
end

function IceChatMessage(str, ply, module, type)
    local strColor = Color(255,255,255)
    local modulePrefix = "Server"

    if module != nil then
        modulePrefix = module
    end

    if type == 1 then
        strColor = Color(251,61,61)
    end 

    if ply then
        chat.AddText(ply, Color(251,61,61), "["..IceModulesConfig.ServerName.." - "..modulePrefix.."] ", strColor, str)
    else
        for _, pl_ in pairs(player.GetAll()) do 
            chat.AddText(pl_, Color(251,61,61), "["..IceModulesConfig.ServerName.." - "..modulePrefix.."] ", strColor, str)
        end
    end
end 
