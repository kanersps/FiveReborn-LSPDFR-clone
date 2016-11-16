-- Sync
server_script 'server/sync.lua'

client_script 'client/utils.lua'
client_script 'client/functions/arrest_ped.lua'
client_script 'client/functions/pull_over.lua'
client_script 'client/functions/talk_menu.lua'

-- UI
ui_page 'cef/index.html'

files {
    'cef/index.html',
    'cef/jquery.js',
    'cef/profile.js',
}