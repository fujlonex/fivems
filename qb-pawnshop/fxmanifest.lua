fx_version 'cerulean'
game 'gta5'

author 'fujlonex'
description 'QBCore Pawnshop z NUI i tłumaczeniami'
version '4.0.5'

shared_scripts {
    'config.lua',
    'locales/*.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/style.css',
    'html/script.js'
}
