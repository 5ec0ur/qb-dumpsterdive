local QBCore = exports['qb-core']:GetCoreObject()

-- List of possible rewards with their respective chances (percentage)
local rewards = {
    { item = "lockpick", chance = 0 },
    { item = "bread", chance = 0 },
    { item = "water", chance = 0 },
    { item = "phone", chance = 0 },
    { item = "radio", chance = 0 }
}

-- Event to give the player a reward for successfully searching the bin
RegisterNetEvent('bin-search:giveReward')
AddEventHandler('bin-search:giveReward', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    local foundReward = false

    for _, reward in ipairs(rewards) do
        local chance = math.random(1, 100)
        if chance <= reward.chance then
            Player.Functions.AddItem(reward.item, 1)
            TriggerClientEvent('QBCore:Notify', src, "You found a " .. reward.item .. " in the bin.", "success")
            foundReward = true
            break
        end
    end

    if not foundReward then
        TriggerClientEvent('QBCore:Notify', src, "You did not find anything in the bin.", "error")
        TriggerClientEvent('hud:client:UpdateStress', src, 20)
        TriggerClientEvent('QBCore:Notify', src, "You Feel More Stressed.", "error")
    end
end)