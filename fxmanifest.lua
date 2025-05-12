fx_version 'cerulean'
game 'gta5'
author 'poorcuz'

shared_script '@es_extended/imports.lua'
shared_script 'config.lua'
client_scripts {
    'client/client.lua',
    'client/utils.lua'
}
server_scripts {
    'server/sv_config.lua',
    'server/server.lua'
}

ui_page 'html/index.html'
file 'html/**/*.*'