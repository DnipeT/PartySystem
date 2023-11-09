local function findPlayerByName(name, players)
    name = name:lower()
    for _, player in pairs(players) do
        if player.Name:lower() == name then
            return player
        end
    end
end

local function sendInvitation(sender, receiver)
    local group = sender:FindFirstChild("Group")
    if group and not group:FindFirstChild(receiver.Name) then
        local teammate = Instance.new("StringValue", group)
        teammate.Name = receiver.Name
    end
end

local function acceptInvitation(receiver, sender)
    local group = receiver:FindFirstChild("Group")
    if group and not group:FindFirstChild(sender.Name) then
        local teammate = group:FindFirstChild(receiver.Name)
        if teammate then
            teammate.Value = sender.Name
        end
    end
end

local function leaveGroup(player)
    local group = player:FindFirstChild("Group")
    if group then
        group:ClearAllChildren()
    end
end

local debounce = {}  -- Use a table to track debouncing per player

game.Players.PlayerAdded:Connect(function(player)
    debounce[player] = {}

    player.Chatted:Connect(function(msg)
        if msg:match("!inv") and not debounce[player]["inv"] then
            local targetPlayer = findPlayerByName(msg:sub(6), game.Players:GetPlayers())
            if targetPlayer and targetPlayer ~= player then
                sendInvitation(player, targetPlayer)
            end
            debounce[player]["inv"] = true
            wait(1)
            debounce[player]["inv"] = false
        elseif msg:match("!acc") and not debounce[player]["acc"] then
            local sender = findPlayerByName(msg:sub(6), game.Players:GetPlayers())
            if sender and sender ~= player then
                acceptInvitation(player, sender)
            end
            debounce[player]["acc"] = true
            wait(1)
            debounce[player]["acc"] = false
        elseif msg:match("!leave") and not debounce[player]["leave"] then
            leaveGroup(player)
            debounce[player]["leave"] = true
            wait(1)
            debounce[player]["leave"] = false
        end
    end)
end)
