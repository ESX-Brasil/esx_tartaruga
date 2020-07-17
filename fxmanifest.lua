fx_version 'adamant'

game 'gta5'

description 'ESX Tartaruga'

version '1.0.2'

server_scripts {

  '@es_extended/locale.lua',
	'locales/br.lua',
  'server/main.lua',
  'config.lua'

}

client_scripts {

  '@es_extended/locale.lua',
	'locales/br.lua',
  'config.lua',
  'client/main.lua'

}

--Que mais scripts acessem https://forum.esxbrasil.website/
