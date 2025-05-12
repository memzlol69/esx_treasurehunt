local displayTreasure = false
local treasureState = {}

RegisterNetEvent("bc_schatz:setWaypoint", function(location)
    if not location then return end
    SetNewWaypoint(location.x, location.y, location.z)
end)

RegisterNetEvent("bc_schatz:displayTreasure", function(location)
    treasureState.location = location

    displayTreasure = true
    Citizen.CreateThread(function()
        while displayTreasure do
            Citizen.Wait(1)

            local markerPos = vector3(location.x, location.y, location.z + 1.0)
            DrawMarker(32, markerPos.x, markerPos.y, markerPos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 255, 165, 0, 200, false, true, 2, false, nil, nil, false)
            
            local playerPos = GetEntityCoords(GetPlayerPed(-1))
            if #(playerPos - location) < 3.0 then
                Config.functions.ShowHelpNotification(Config.Locale["PressToDig"])

                if IsControlJustReleased(0, 38) then
                    TriggerServerEvent("bc_schatz:digTreasure")
                    displayTreasure = false
                end
            end
        end
    end)
end)

RegisterNetEvent("bc_schatz:endTreasure", function()
    treasureState = {}
    displayTreasure = false
end)

RegisterNetEvent("bc_schatz:doDigTreasure", function(timer)
    startShovelSequence(timer, function()
        openChestSequence()

    end)
end)

--[[ UTILS ]]--
function LoadAnimationDictionary(animationD)
    RequestAnimDict(animationD)
    while not HasAnimDictLoaded(animationD) do
        Wait(1)
    end
end

function LoadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
end

function startShovelSequence(timer, cb)
    local ped         = PlayerPedId()
    local shovelModel = GetHashKey(Config.PropShovel)
    local animDict    = Config.Anims.ShovelDict
    local animLoop    = Config.Anims.ShovelAnim
    local animStop    = Config.Anims.ShovelStop

    LoadAnimationDictionary(animDict)
    LoadModel(shovelModel)

    local shovel = CreateObject(shovelModel, GetEntityCoords(ped), false, false, false)
    Wait(50)
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(shovel), false)
    SetCurrentPedWeapon(ped, GetHashKey("weapon_unarmed"), true)

    TaskPlayAnim(ped, animDict, animLoop, 8.0, -4.0, -1, 1, 0, false, false, false)
    AttachEntityToEntity(shovel, ped, GetPedBoneIndex(ped, 28422), 0,0,0, 0,0,0, false, false, false, false, 2, true)
    SetBlockingOfNonTemporaryEvents(ped, 0)

    Citizen.Wait(timer)

    CreateThread(function()
        TaskPlayAnim(ped, animDict, animStop, 8.0, -4.0, 2000, 0, 0, false, false, false)

        while GetEntityAnimCurrentTime(ped, animDict, animStop) < 0.355 do
            Wait(0)
        end

        DetachEntity(shovel, false, false)
        SetEntityAsNoLongerNeeded(shovel)

        ClearPedTasksImmediately(ped)
        if cb then cb() end
    end)
end

function openChestSequence(cb)
    Wait(500)
    local ped        = PlayerPedId()
    local chestModel = GetHashKey(Config.PropTreasure)
    local animDict   = Config.Anims.ChestOpenDict
    local moneyModel = GetHashKey("bkr_prop_money_wrapped_01")

    LoadAnimationDictionary(animDict)
    LoadModel(chestModel)
    LoadModel(moneyModel)

    local chestCoords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.8, -1.0)
    local chest       = CreateObject(chestModel, chestCoords, false, false, false)
    SetEntityHeading(chest, GetEntityHeading(ped))

    local money = CreateObjectNoOffset(moneyModel, chestCoords + vector3(0.0, 0.0, 0.1), false, false, false)

    local pickDict, pickAnim = Config.Anims.PickupDict, Config.Anims.PickupAnim
    ESX.Streaming.RequestAnimDict(pickDict, function()
        TaskPlayAnim(ped, pickDict, pickAnim, 3.0, 3.0, 5000, 0, 1, false, false, false)
    end)

    Wait(2300)
    PlayEntityAnim(chest, Config.Anims.ChestOpenAnim, animDict, 900.0, false, 1, 0, 0, 0)
    Wait(1500)
    AttachEntityToEntity(money, ped, GetPedBoneIndex(ped, 57005),
        0.16, 0.08, 0.0,
        0.0, 270.0, 60.0,
        true, true, false, true, 1, true
    )
    Wait(1500)

    FreezeEntityPosition(chest, true)
    SetEntityAsNoLongerNeeded(chest)
    SetEntityVisible(money, false, 0)
    DeleteEntity(money)
    RemoveAnimDict(animDict)
    ClearPedTasksImmediately(ped)


    if cb then cb() end
end
