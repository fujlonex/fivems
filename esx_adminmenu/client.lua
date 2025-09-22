local isGodmode = false
local isInvisible = false
local L = Locales[Config.Locale]

-- 📌 Otwieranie panelu admina
RegisterCommand("adminmenu", function()
    local input = lib.inputDialog(L.menu_title, {
        { type = "input", label = "Hasło / Password", password = true }
    })

    if not input then return end
    local password = input[1]

    TriggerServerEvent("esx_admin:checkPassword", password)
end)

-- 📌 Otwieranie menu (jeśli hasło poprawne)
RegisterNetEvent("esx_admin:openMenu", function()
    lib.registerContext({
        id = 'admin_panel',
        title = L.menu_title,
        options = {
            {
                title = L.godmode,
                description = L.godmode_desc,
                icon = "shield",
                onSelect = function()
                    isGodmode = not isGodmode
                    SetEntityInvincible(PlayerPedId(), isGodmode)
                    lib.notify({ title = L.menu_title, description = "Godmode: " .. tostring(isGodmode), type = "success" })
                    TriggerServerEvent("esx_admin:logAction", "godmode", tostring(isGodmode))
                end
            },
            {
                title = L.invis,
                description = L.invis_desc,
                icon = "eye-off",
                onSelect = function()
                    isInvisible = not isInvisible
                    SetEntityVisible(PlayerPedId(), not isInvisible, 0)
                    lib.notify({ title = L.menu_title, description = "Invis: " .. tostring(isInvisible), type = "success" })
                    TriggerServerEvent("esx_admin:logAction", "invisible", tostring(isInvisible))
                end
            },
            {
                title = L.weapon,
                description = L.weapon_desc,
                icon = "gun",
                onSelect = function()
                    local input = lib.inputDialog(L.weapon, {
                        { type = "input", label = "Weapon name (weapon_...)" }
                    })
                    if input then
                        TriggerServerEvent("esx_admin:addWeapon", input[1])
                        TriggerServerEvent("esx_admin:logAction", "addWeapon", input[1])
                    end
                end
            },
            {
                title = L.item,
                description = L.item_desc,
                icon = "package",
                onSelect = function()
                    local input = lib.inputDialog(L.item, {
                        { type = "input", label = "Item name" },
                        { type = "number", label = "Count", default = 1 }
                    })
                    if input then
                        TriggerServerEvent("esx_admin:addItem", input[1], input[2])
                        TriggerServerEvent("esx_admin:logAction", "addItem", input[1] .. " x" .. input[2])
                    end
                end
            },
            {
                title = L.weather,
                description = L.weather_desc,
                icon = "cloud-sun",
                onSelect = function()
                    local input = lib.inputDialog(L.weather, {
                        { type = "input", label = "Weather (EXTRASUNNY, RAIN...)" },
                        { type = "number", label = "Hour (0-23)" }
                    })
                    if input then
                        TriggerServerEvent("esx_admin:setWeatherTime", input[1], input[2])
                        TriggerServerEvent("esx_admin:logAction", "setWeatherTime", input[1] .. " " .. input[2])
                    end
                end
            },
            {
                title = L.tp,
                description = L.tp_desc,
                icon = "map-pin",
                onSelect = function()
                    local input = lib.inputDialog(L.tp, {
                        { type = "number", label = "Player ID" },
                        { type = "select", label = "Option", options = {
                            { value = "tome", label = "TP Player to me" },
                            { value = "toplayer", label = "TP me to player" }
                        }}
                    })
                    if input then
                        TriggerServerEvent("esx_admin:teleport", input[1], input[2])
                        TriggerServerEvent("esx_admin:logAction", "teleport", input[2] .. " -> " .. input[1])
                    end
                end
            },
            {
                title = L.revive,
                description = L.revive_desc,
                icon = "heart-pulse",
                onSelect = function()
                    local input = lib.inputDialog(L.revive, {
                        { type = "number", label = "Player ID" },
                        { type = "select", label = "Option", options = {
                            { value = "revive", label = "Revive" },
                            { value = "heal", label = "Heal" }
                        }}
                    })
                    if input then
                        TriggerServerEvent("esx_admin:reviveHeal", input[1], input[2])
                        TriggerServerEvent("esx_admin:logAction", input[2], "Target: " .. input[1])
                    end
                end
            },
            {
                title = L.car,
                description = L.car_desc,
                icon = "car",
                onSelect = function()
                    local input = lib.inputDialog(L.car, {
                        { type = "input", label = "Vehicle model (e.g. adder)" }
                    })
                    if input then
                        TriggerServerEvent("esx_admin:spawnVehicle", input[1])
                        TriggerServerEvent("esx_admin:logAction", "spawnVehicle", input[1])
                    end
                end
            },
            {
                title = L.punish,
                description = L.punish_desc,
                icon = "ban",
                onSelect = function()
                    local input = lib.inputDialog(L.punish, {
                        { type = "number", label = "Player ID" },
                        { type = "select", label = "Option", options = {
                            { value = "kick", label = "Kick" },
                            { value = "ban", label = "Ban" }
                        }},
                        { type = "input", label = "Reason" }
                    })
                    if input then
                        TriggerServerEvent("esx_admin:kickBan", input[1], input[2], input[3])
                        TriggerServerEvent("esx_admin:logAction", input[2], "Target: " .. input[1] .. " Reason: " .. (input[3] or "None"))
                    end
                end
            }
        }
    })
    lib.showContext("admin_panel")
end)

-- 📌 Teleportacja
RegisterNetEvent("esx_admin:doTeleport", function(coords)
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false)
end)

-- 📌 Spawn pojazdu
RegisterNetEvent("esx_admin:spawnVehicleClient", function(model)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)

    local vehicleHash = GetHashKey(model)
    RequestModel(vehicleHash)
    while not HasModelLoaded(vehicleHash) do Wait(10) end

    local veh = CreateVehicle(vehicleHash, coords.x, coords.y, coords.z, heading, true, false)
    TaskWarpPedIntoVehicle(playerPed, veh, -1)
    SetVehicleNumberPlateText(veh, "ADMIN")
    SetEntityAsMissionEntity(veh, true, true)
end)

-- 📌 Revive
RegisterNetEvent("esx_admin:reviveClient", function()
    local ped = PlayerPedId()
    SetEntityHealth(ped, 200)
    ClearPedTasksImmediately(ped)
    lib.notify({ title = L.menu_title, description = L.notify_revive, type = "success" })
end)

-- 📌 Heal
RegisterNetEvent("esx_admin:healClient", function()
    local ped = PlayerPedId()
    SetEntityHealth(ped, 200)
    lib.notify({ title = L.menu_title, description = L.notify_heal, type = "success" })
end)
