if SERVER then
    util.AddNetworkString("AddText")

    function chat.AddText(...)
        local args = {...}
        local ply = table.remove(args, 1)
        local rf = RecipientFilter()

        if ply then
            if type(ply) == "Player" then
                rf:AddPlayer(ply)
            elseif type(ply) == "table" then
                for k, v in pairs(ply) do
                    if type(v) == "Player" then
                        rf:AddPlayer(v)
                    end
                end
            end
        else
            rf:AddAllPlayers()
        end

        net.Start("AddText")
        net.WriteInt(#args, 32)

        for _, v in pairs(args) do
            if type(v) == "string" then
                net.WriteInt(0, 2)
                net.WriteString(v)
            elseif type(v) == "table" and v.r and v.g and v.b then
                net.WriteInt(1, 2)
                net.WriteUInt(v.r, 8)
                net.WriteUInt(v.g, 8)
                net.WriteUInt(v.b, 8)
            elseif type(v) == "Player" then
                net.WriteInt(2, 2)
                net.WriteInt(v:EntIndex(), 10)
            elseif type(v) == "number" then
                if math.floor(v) ~= v then
                    net.WriteInt(3, 2)
                    net.WriteFloat(v)
                else
                    net.WriteInt(4, 2)
                    net.WriteInt(v, 32)
                end
            end
        end

        net.Send(rf)
    end
else
    net.Receive("AddText", function()
        local argc = net.ReadInt(32)
        local args = {}

        for i = 1, argc do
            local t = net.ReadInt(2)

            if t == 0 then
                table.insert(args, net.ReadString())
            elseif t == 1 then
                table.insert(args, Color(net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8)))
            elseif t == 2 then
                local entIndex = net.ReadInt(10)
                local ent = Entity(entIndex)
                if IsValid(ent) then
                    table.insert(args, ent:Nick())
                end
            elseif t == 3 then
                table.insert(args, tostring(net.ReadFloat()))
            elseif t == 4 then
                table.insert(args, tostring(net.ReadInt(32))
                )
            end
        end

        chat.AddText(unpack(args))
    end)
end
