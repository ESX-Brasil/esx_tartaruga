resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Tartaruga'

version '1.0.1'

server_scripts {

  '@es_extended/locale.lua',
	'locales/br.lua',
	'locales/fr.lua',
  'server/esx_tartaruga_sv.lua',
  'config.lua'

}

client_scripts {

  '@es_extended/locale.lua',
	'locales/br.lua',
	'locales/fr.lua',
  'config.lua',
  'client/esx_tartaruga_cl.lua'

}
