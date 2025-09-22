fx_version 'cerulean'
game 'gta5'

author 'fujlonex'
description 'Admin Panel with DB Logs & Translations'
version '1.2.0'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
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

lua54 'yes'
