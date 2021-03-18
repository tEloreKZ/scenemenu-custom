resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_script '@NativeUI/NativeUI.lua'
client_script 'config.lua'
client_script 'client.lua'


data_file 'DLC_ITYP_REQUEST' 'stream/props.ytyp'

server_scripts {

    'server.lua',
    'versioncheck.lua',

}
