ESX 						   = nil
local CopsConnected       	   = 0
local PlayersHarvestingTartaruga     = {}
local PlayersTransformingTartaruga   = {}
local PlayersSellingTartaruga        = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function CountCops()

	local xPlayers = ESX.GetPlayers()

	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(5000, CountCops)

end

CountCops()

--Tartaruga
local function HarvestTartaruga(source)

	if CopsConnected < Config.RequiredCopsTartaruga then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police') .. CopsConnected .. '/' .. Config.RequiredCopsTartaruga)
		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingTartaruga[source] == true then

			local _source = source
			local xPlayer  = ESX.GetPlayerFromId(_source)

			local tartaruga = xPlayer.getInventoryItem('tartaruga')
--weight
			--if tartaruga.limit ~= -1 and tartaruga.count >= tartaruga.limit then
			if tartaruga.weight ~= -1 and tartaruga.count >= tartaruga.weight then
				TriggerClientEvent('esx:showNotification', source, _U('inv_full_tartaruga'))
			else
				xPlayer.addInventoryItem('tartaruga', 1)
				HarvestTartaruga(source)
			end

		end
	end)
end

RegisterServerEvent('esx_tartaruga:startHarvestTartaruga')
AddEventHandler('esx_tartaruga:startHarvestTartaruga', function()

	local _source = source

	PlayersHarvestingTartaruga[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('pickup_in_prog'))

	HarvestTartaruga(_source)

end)

RegisterServerEvent('esx_tartaruga:stopHarvestTartaruga')
AddEventHandler('esx_tartaruga:stopHarvestTartaruga', function()

	local _source = source

	PlayersHarvestingTartaruga[_source] = false

end)

local function TransformTartaruga(source)

	if CopsConnected < Config.RequiredCopsTartaruga then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police') .. CopsConnected .. '/' .. Config.RequiredCopsTartaruga)
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingTartaruga[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local tartarugaQuantity = xPlayer.getInventoryItem('tartaruga').count
			local meatQuantity = xPlayer.getInventoryItem('tartaruga_meat').count

			if meatQuantity > 50 then
				TriggerClientEvent('esx:showNotification', source, _U('too_many_meat'))
			elseif tartarugaQuantity < 5 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_tartaruga'))
			else
				xPlayer.removeInventoryItem('tartaruga', 5)
				xPlayer.addInventoryItem('tartaruga_meat', 1)

				TransformTartaruga(source)
			end

		end
	end)
end

RegisterServerEvent('esx_tartaruga:startTransformTartaruga')
AddEventHandler('esx_tartaruga:startTransformTartaruga', function()

	local _source = source

	PlayersTransformingTartaruga[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('packing_in_prog'))

	TransformTartaruga(_source)

end)

RegisterServerEvent('esx_tartaruga:stopTransformTartaruga')
AddEventHandler('esx_tartaruga:stopTransformTartaruga', function()

	local _source = source

	PlayersTransformingTartaruga[_source] = false

end)

local function SellTartaruga(source)

	if CopsConnected < Config.RequiredCopsTartaruga then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police') .. CopsConnected .. '/' .. Config.RequiredCopsTartaruga)
		return
	end

	SetTimeout(Config.TimeToSell, function()

		if PlayersSellingTartaruga[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local meatQuantity = xPlayer.getInventoryItem('tartaruga_meat').count

			if meatQuantity == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_meat_sale'))
			else
				xPlayer.removeInventoryItem('tartaruga_meat', 1)
				if CopsConnected == 0 then
					xPlayer.addAccountMoney('black_money', 35)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_tartaruga'))
                elseif CopsConnected == 1 then
					xPlayer.addAccountMoney('black_money', 45)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_tartaruga'))
                elseif CopsConnected == 2 then
					xPlayer.addAccountMoney('black_money', 60)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_tartaruga'))
                elseif CopsConnected == 3 then
					xPlayer.addAccountMoney('black_money', 75)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_tartaruga'))
                elseif CopsConnected == 4 then
					xPlayer.addAccountMoney('black_money', 90)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_tartaruga'))
                elseif CopsConnected >= 5 then
					xPlayer.addAccountMoney('black_money', 105)
                    TriggerClientEvent('esx:showNotification', source, _U('sold_one_tartaruga'))
                end

				SellTartaruga(source)
			end

		end
	end)
end

RegisterServerEvent('esx_tartaruga:startSellTartaruga')
AddEventHandler('esx_tartaruga:startSellTartaruga', function()

	local _source = source

	PlayersSellingTartaruga[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))

	SellTartaruga(_source)

end)

RegisterServerEvent('esx_tartaruga:stopSellTartaruga')
AddEventHandler('esx_tartaruga:stopSellTartaruga', function()

	local _source = source

	PlayersSellingTartaruga[_source] = false

end)


-- RETURN INVENTORY TO CLIENT
RegisterServerEvent('esx_tartaruga:GetUserInventory')
AddEventHandler('esx_tartaruga:GetUserInventory', function(currentZone)
	local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
    TriggerClientEvent('esx_tartaruga:ReturnInventory',
    	_source,
		xPlayer.getInventoryItem('tartaruga').count,
		xPlayer.getInventoryItem('tartaruga_meat').count,
		xPlayer.job.name,
		currentZone
    )
end)

--Que mais scripts acessem https://forum.esxbrasil.website/
