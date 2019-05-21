description 'esx_tartaruga'

version '1.0.0'

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
