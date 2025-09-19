local QBCore = exports['qb-core']:GetCoreObject()

local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

-- 🔹 Tworzenie blipa
CreateThread(function()
    local loc = Config.PawnLocation

    local blip = AddBlipForCoord(loc.coords.x, loc.coords.y, loc.coords.z)
    SetBlipSprite(blip, 770) -- 💰 pawnshop / sklepik
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 5) -- zielony
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Lombard")
    EndTextCommandSetBlipName(blip)
end)

-- 🔹 Marker i otwieranie menu
CreateThread(function()
    local loc = Config.PawnLocation
    while true do
        local sleep = 1500
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local dist = #(pos - vector3(loc.coords.x, loc.coords.y, loc.coords.z))

        if dist < 3.0 then
            sleep = 0
            DrawText3D(loc.coords.x, loc.coords.y, loc.coords.z + 0.2, Locales[Config.Locale].open_shop)
            if IsControlJustPressed(0, 38) then -- E
                TriggerServerEvent('pawnshop:tryOpen')
            end
        end
        Wait(sleep)
    end
end)

-- 🔹 Otwieranie NUI
RegisterNetEvent('pawnshop:openMenu', function(data)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "open",
        pawnItems = data.pawnItems,
        meltItems = data.meltItems
    })
end)

-- 🔹 Zamknięcie NUI
RegisterNUICallback("close", function(_, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)

-- 🔹 Sprzedaż
RegisterNUICallback("sellItem", function(data, cb)
    TriggerServerEvent("pawnshop:sellItem", data.item)
    cb("ok")
end)

-- 🔹 Przetapianie
RegisterNUICallback("meltItem", function(data, cb)
    TriggerServerEvent("pawnshop:meltItem", data.item)
    cb("ok")
end)
