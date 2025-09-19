Config = {}

-- 📍 Lokalizacja lombardu
Config.PawnLocation = {
    coords = vector4(-269.9672, 235.4811, 90.5746, 225.4308),
    openHour = 7,   -- godzina otwarcia
    closeHour = 20  -- godzina zamknięcia
}

-- 💰 Itemy do sprzedaży
Config.PawnItems = {
    { item = 'goldchain',     price = math.random(50,100) },
    { item = 'diamond_ring',  price = math.random(50,100) },
    { item = 'rolex',         price = math.random(50,100) },
    { item = 'tenkgoldchain', price = math.random(50,100) },
    { item = 'tablet',        price = math.random(50,100) },
    { item = 'iphone',        price = math.random(50,100) },
    { item = 'samsungphone',  price = math.random(50,100) },
    { item = 'laptop',        price = math.random(50,100) }
}

-- 🔥 Itemy do przetapiania
Config.MeltingItems = {
    [1] = {
        item = 'goldchain',
        rewards = {
            { item = 'goldbar', amount = 2 }
        },
        meltTime = 0.15 -- minuty
    },
    [2] = {
        item = 'diamond_ring',
        rewards = {
            { item = 'diamond', amount = 1 },
            { item = 'goldbar', amount = 1 }
        },
        meltTime = 0.15
    },
    [3] = {
        item = 'rolex',
        rewards = {
            { item = 'diamond', amount = 1 },
            { item = 'goldbar', amount = 1 },
            { item = 'electronickit', amount = 1 }
        },
        meltTime = 0.15
    },
    [4] = {
        item = 'tenkgoldchain',
        rewards = {
            { item = 'diamond', amount = 5 },
            { item = 'goldbar', amount = 1 }
        },
        meltTime = 0.15
    }
}

-- 🌐 Język (pl / en)
Config.Locale = 'pl'
