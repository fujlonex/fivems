ESX = exports["es_extended"]:getSharedObject()

-- 📌 Funkcja logowania do bazy
local function logToDB(source, action, details)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    MySQL.insert(
        "INSERT INTO admin_logs (identifier, name, action, details, time) VALUES (?, ?, ?, ?, NOW())",
        { xPlayer.identifier, xPlayer.getName(), action, details }
    )
end

RegisterNetEvent("esx_admin:logAction", function(action, details)
    logToDB(source, action, details or "")
end)

-- 📌 Sprawdzenie hasła i grupy
RegisterNetEvent("esx_admin:checkPassword", function(password)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local group = xPlayer.getGroup()

    if password == Config.AdminPassword and (Config.AllowedGroups[group] or false) then
        TriggerClientEvent("esx_admin:openMenu", source)
    else
        DropPlayer(source, "❌ Wrong admin password.")
    end
end)

-- 📌 Dodawanie broni
RegisterNetEvent("esx_admin:addWeapon", function(weapon)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        xPlayer.addWeapon(weapon, 250)
        logToDB(source, "addWeapon", weapon)
    end
end)

-- 📌 Dodawanie itemów
RegisterNetEvent("esx_admin:addItem", function(item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        xPlayer.addInventoryItem(item, count or 1)
        logToDB(source, "addItem", item .. " x" .. (count or 1))
    end
end)

-- 📌 Pogoda i czas
RegisterNetEvent("esx_admin:setWeatherTime", function(weather, hour)
    TriggerClientEvent("esx_admin:syncWeatherTime", -1, weather, hour)
    logToDB(source, "setWeatherTime", weather .. " " .. tostring(hour))
end)

RegisterNetEvent("esx_admin:syncWeatherTime", function(weather, hour)
    SetWeatherTypeNowPersist(weather)
    NetworkOverrideClockTime(hour, 0, 0)
end)

-- 📌 Teleportacja
RegisterNetEvent("esx_admin:teleport", function(targetId, option)
    local src = source
    local target = GetPlayerPed(targetId)
    if not target then return end

    local srcPed = GetPlayerPed(src)
    local coords = GetEntityCoords(srcPed)
    local targetCoords = GetEntityCoords(target)

    if option == "tome" then
        TriggerClientEvent("esx_admin:doTeleport", targetId, coords)
        logToDB(src, "teleport", "Player " .. targetId .. " -> Admin")
    elseif option == "toplayer" then
        TriggerClientEvent("esx_admin:doTeleport", src, targetCoords)
        logToDB(src, "teleport", "Admin -> Player " .. targetId)
    end
end)

-- 📌 Revive / Heal
RegisterNetEvent("esx_admin:reviveHeal", function(targetId, option)
    if option == "revive" then
        TriggerClientEvent("esx_admin:reviveClient", targetId)
        logToDB(source, "revive", "Target: " .. targetId)
    elseif option == "heal" then
        TriggerClientEvent("esx_admin:healClient", targetId)
        logToDB(source, "heal", "Target: " .. targetId)
    end
end)

-- 📌 Spawn pojazdu
RegisterNetEvent("esx_admin:spawnVehicle", function(model)
    TriggerClientEvent("esx_admin:spawnVehicleClient", source, model)
    logToDB(source, "spawnVehicle", model)
end)

-- 📌 Kick / Ban
RegisterNetEvent("esx_admin:kickBan", function(targetId, option, reason)
    if option == "kick" then
        DropPlayer(targetId, "Kicked by admin. Reason: " .. (reason or "None"))
        logToDB(source, "kick", "Target: " .. targetId .. " Reason: " .. (reason or "None"))
    elseif option == "ban" then
        -- ❗ Podłącz swój system banów tutaj
        DropPlayer(targetId, "Banned by admin. Reason: " .. (reason or "None"))
        logToDB(source, "ban", "Target: " .. targetId .. " Reason: " .. (reason or "None"))
    end
end)
