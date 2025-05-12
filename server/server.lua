local treasureTable = {}
local locationStateTable = {}
local cooldownTable = {}


ESX.RegisterUsableItem(Config.Item, function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    if treasureTable[source] ~= nil then
        exports["bc_hud"]:sendNotification(source, 0, Config.Locale["Schatzkarte"], Config.Locale["AlreadySearching"], 5)
        return
    end

    -- Schatzkarte entfernen
    xPlayer.removeInventoryItem(Config.Item, 1)

    -- Random Schatz Spot abfragen
    local _location = getRandomTreasureLocation()
    treasureTable[source] = _location

    SvConfig.functions.SendNotification(source, 2, Config.Locale["Schatzkarte"], Config.Locale["TreasureMarked"], 10)
    TriggerClientEvent('bc_schatz:setWaypoint', source, _location)
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000) -- 2 sek warten

        for source, location in pairs(treasureTable) do
            local xPlayer = ESX.GetPlayerFromId(source)
            if xPlayer then
                local ped = GetPlayerPed(source)
                local playerCoords = GetEntityCoords(ped)
                local distance = _vdist(playerCoords, location)

                if distance < 200.0 and not locationStateTable[source] then
                    TriggerClientEvent('bc_schatz:displayTreasure', source, location)
                    locationStateTable[source] = "STATE_DIG"
                end
            end
        end
    end
end)

RegisterNetEvent("bc_schatz:digTreasure", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return end

    local currentTime = os.time()
    if cooldownTable[_source] and (currentTime - cooldownTable[_source] < 10) then
        exports["bc_hud"]:sendNotification(source, 0, Config.Locale["Schatzkarte"], Config.Locale["WaitBeforeDigging"], 5)
        return
    end
    cooldownTable[_source] = currentTime

    if not treasureTable[_source] or locationStateTable[source] ~= "STATE_DIG" then 
        TriggerClientEvent("bc_schatz:endTreasure", _source)
        return
    end

    local playerCoords = GetEntityCoords(GetPlayerPed(_source))
    local treasureCoords = treasureTable[_source]

    local distance = _vdist(playerCoords, treasureCoords)
    if distance < 3.0 then
        locationStateTable[_source] = "STATE_DIGGING"
        TriggerClientEvent("bc_schatz:doDigTreasure", _source, SvConfig.interactionTimer)

        SetTimeout(SvConfig.interactionTimer + 6000, function()
            handleReward(_source)
            TriggerClientEvent("bc_schatz:endTreasure", _source)
            treasureTable[_source] = nil
        end)
    end
end)