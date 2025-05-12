SvConfig = {
    functions = {
        SendNotification = function(source, _type, title, message, duration)
            -- duration is measured in seconds
            exports["bc_hud"]:sendNotification(source, _type, title, message, duration)
        end
    },

    interactionTimer = 8000,

    treasureLocations = {
        vector3(2472.3735, 3453.5667, 50.0267),
        vector3(1667.3020, 5153.4136, 152.0659),
        vector3(-1286.3278, 4496.0322, 14.5123),
        vector3(-1021.1111, 2895.6663, 5.7745),
        vector3(-2086.9431, 2658.5332, 2.8392),
        
        -- Beach locations
        vector3(-1851.9731, -1231.4746, 13.0171),
        vector3(-1475.1505, -1486.5790, 2.0912),
        
        -- Mountain locations
        vector3(501.8876, 5604.7651, 797.9103),
        vector3(-748.5427, 4831.1182, 228.3071),
        vector3(1561.2341, 6447.8912, 23.8723),
        
        -- Forest locations
        vector3(-578.9123, 5321.4521, 69.2145),
        vector3(-1978.2341, 2789.1234, 32.8172),
        vector3(2101.4521, 3478.9123, 45.2341),
        
        -- Desert locations
        vector3(2901.4521, 4089.1234, 50.4521),
        vector3(1123.4521, 3045.1234, 40.4521),
        vector3(2478.9123, 3789.1234, 41.2341),
        
        -- City locations
        vector3(120.0167, -1088.9601, 29.2347),
        vector3(-578.9123, -998.4521, 22.2341),
        vector3(864.9115, -2196.0425, 30.4831),
        
        -- Landmark locations
        vector3(-1841.6724, 3354.6328, 31.9330),
        vector3(1134.2014, -2605.5039, 15.9340),
        vector3(-1089.0148, 4890.2969, 214.7991),
        vector3(2081.0457, 1795.1200, 91.4818),
        
        -- Hidden spots
        vector3(2836.4658, -691.3817, 1.1490),
        vector3(-1054.1848, 4933.5273, 210.3641) 
    },

    rewards = {
        { type = "item", name = "case", amount = 1, percentage = 6, label = "Case"},
        { type = "money", name = "cash", amount = 35000, percentage = 11 },
        { type = "weapon", name = "weapon_switchblade", label = "Klappmesser", amount = 1, percentage = 3 },
        { type = "item", name = "stone", label = "Stein", amount = 1, percentage = 5 },
        { type = "money", name = "cash", amount = 10000, percentage = 20 },
        { type = "item", name = "weste", label = "Weste", amount = 5, percentage = 10 },
        { type = "item", name = "medikit", label = "Medikit", amount = 5, percentage = 12 },
        { type = "weapon", name = "weapon_pistol50", label = "50er Pistole", amount = 1, percentage = 5 },
        { type = "item", name = "case", amount = 1, percentage = 5, label = "Case" },
        { type = "item", name = "repairkit", label = "Reparaturkasten", amount = 5, percentage = 13 },
        { type = "item", name = "ammo", label = "Munition", amount = 5, percentage = 10 }
    }
}


function getRandomTreasureLocation()
    local locations = SvConfig.treasureLocations
    local randomIndex = math.random(1, #locations) -- Pick a random index
    return locations[randomIndex] -- Return the selected vector3
end

function getTreasureReward()
    local totalPercentage = 0
    for _, reward in ipairs(SvConfig.rewards) do
        totalPercentage = totalPercentage + reward.percentage
    end

    local randomValue = math.random(1, totalPercentage)
    local cumulative = 0

    for _, reward in ipairs(SvConfig.rewards) do
        cumulative = cumulative + reward.percentage
        if randomValue <= cumulative then
            return reward
        end
    end
end

function handleReward(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local rewardData = getTreasureReward()

    if rewardData.type == "money" then
        xPlayer.addMoney(rewardData.amount)
        exports["bc_hud"]:sendNotification(source, 2, "Schatzkarte", "Du hast $"..rewardData.amount.." gefunden!", 5)
        exports["bc_log"]:sendLog(GetCurrentResourceName(), xPlayer, ("Der Spieler hat einen Schatz gefunden und **$%s** erhalten!"):format(tostring(rewardData.amount)))

    elseif rewardData.type == "weapon" then
        xPlayer.addWeapon(rewardData.name, 30)
        xPlayer.addInventoryItem(rewardData.name, rewardData.amount)

        exports["bc_hud"]:sendNotification(source, 2, "Schatzkarte", "Du hast " .. rewardData.amount .. "x " .. rewardData.label .. " gefunden!" , 5)
        exports["bc_log"]:sendLog(GetCurrentResourceName(), xPlayer, ("Der Spieler hat einen Schatz gefunden und **%sx %s** erhalten!"):format(tostring(rewardData.amount), rewardData.label))
    elseif rewardData.type == "item" then
        xPlayer.addInventoryItem(rewardData.name, rewardData.amount)
        exports["bc_hud"]:sendNotification(source, 2, "Schatzkarte", "Du hast " .. rewardData.amount .. "x " .. rewardData.label .. " gefunden!" , 5)
        exports["bc_log"]:sendLog(GetCurrentResourceName(), xPlayer, ("Der Spieler hat einen Schatz gefunden und **%sx %s** erhalten!"):format(tostring(rewardData.amount), rewardData.label))
    end
end

-- Function to calculate Euclidean distance between two vectors
function _vdist(vec1, vec2)
    local dx = vec1.x - vec2.x
    local dy = vec1.y - vec2.y
    local dz = vec1.z - vec2.z
    return math.sqrt(dx * dx + dy * dy + dz * dz) -- Distance formula
end