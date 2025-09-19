local QBCore = exports['qb-core']:GetCoreObject()

-- Sprawdzenie godzin otwarcia
RegisterNetEvent("pawnshop:tryOpen", function()
    local src = source
    local hour = tonumber(os.date("%H"))
    if hour >= Config.PawnLocation.openHour and hour < Config.PawnLocation.closeHour then
        TriggerClientEvent("pawnshop:openMenu", src, {
            pawnItems = Config.PawnItems,
            meltItems = Config.MeltingItems
        })
    else
        TriggerClientEvent('QBCore:Notify', src, 
            string.format(Locales[Config.Locale].closed, Config.PawnLocation.openHour, Config.PawnLocation.closeHour), 
            'error')
    end
end)

-- Sprzedaż
RegisterNetEvent("pawnshop:sellItem", function(item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    for _, v in pairs(Config.PawnItems) do
        if v.item == item then
            local count = Player.Functions.GetItemByName(item)
            if count and count.amount > 0 then
                Player.Functions.RemoveItem(item, 1)
                Player.Functions.AddMoney('cash', v.price)
                TriggerClientEvent('QBCore:Notify', src, 
                    string.format(Locales[Config.Locale].sold, 1, item, v.price), 
                    'success')
            else
                TriggerClientEvent('QBCore:Notify', src, Locales[Config.Locale].no_items, 'error')
            end
        end
    end
end)

-- Przetapianie
RegisterNetEvent("pawnshop:meltItem", function(item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    for _, v in pairs(Config.MeltingItems) do
        if v.item == item then
            local count = Player.Functions.GetItemByName(item)
            if count and count.amount > 0 then
                Player.Functions.RemoveItem(item, 1)
                -- nagrody
                for _, reward in pairs(v.rewards) do
                    Player.Functions.AddItem(reward.item, reward.amount)
                end
                TriggerClientEvent('QBCore:Notify', src, Locales[Config.Locale].melted, 'success')
            else
                TriggerClientEvent('QBCore:Notify', src, Locales[Config.Locale].no_items, 'error')
            end
        end
    end
end)
