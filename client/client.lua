local QBCore = exports['qb-core']:GetCoreObject()

-- List of common bin prop hashes
local binProps = {
    "prop_bin_01a",
    "prop_bin_02a",
    "prop_bin_03a",
    "prop_bin_04a",
    "prop_bin_05a",
    "prop_bin_06a",
    "prop_bin_07a",
    "prop_bin_07b",
    "prop_bin_07c",
    "prop_bin_07d",
    "prop_bin_08a",
    "prop_bin_08open",
    "prop_bin_09a",
    "prop_bin_10a",
    "prop_bin_10b",
    "prop_bin_11a",
    "prop_bin_12a",
    "prop_bin_13a",
    "prop_bin_14a",
    "prop_bin_14b",
    "prop_bin_beach_01a",
    "prop_bin_beach_01d",
    "prop_bin_delpiero",
    "prop_bin_delpiero_b",
    "prop_bin_14a"
}

-- Function to start the bin search
local function StartBinSearch()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local bin = nil

    for _, binProp in ipairs(binProps) do
        bin = GetClosestObjectOfType(playerCoords, 1.5, GetHashKey(binProp), false, false, false)
        if DoesEntityExist(bin) then
            break
        end
    end

    if DoesEntityExist(bin) then
        QBCore.Functions.Progressbar("bin_search", "Searching the bin...", 10000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "amb@prop_human_bum_bin@base",
            anim = "base",
            flags = 49,
        }, {}, {}, function() -- On success
            ClearPedTasks(PlayerPedId())
            TriggerServerEvent('bin-search:giveReward')
        end, function() -- On cancel
            ClearPedTasks(PlayerPedId())
            QBCore.Functions.Notify("Bin search canceled.", "error")
        end)
    else
        QBCore.Functions.Notify("No bin nearby.", "error")
    end
end

-- Register qb-target interactions for bin props
CreateThread(function()
    for _, binProp in ipairs(binProps) do
        exports['qb-target']:AddTargetModel(GetHashKey(binProp), {
            options = {
                {
                    type = "client",
                    event = "bin-search:startSearch",
                    icon = "fas fa-search",
                    label = "Search Bin",
                },
            },
            distance = 1.5
        })
    end
end)

-- Register the event to start the bin search
RegisterNetEvent('bin-search:startSearch', function()
    StartBinSearch()
end)