local arresting = {}
local arrested = {}

RegisterServerEvent("COPArrestingPed")
AddEventHandler("COPArrestingPed", function(ped)
	if(ped ~= nil and arresting[ped] == nil)then
		TriggerClientEvent("notify", source, "Press E to arrest.")
		TriggerClientEvent("arrestingPed", -1, ped)
		SetTimeout(1500, function()
			arresting[ped] = true
		end)
	end
end)

RegisterServerEvent("COPArrestedPed")
AddEventHandler("COPArrestedPed", function(ped)
	if(ped ~= nil and arresting[ped] ~= nil)then
		arresting[ped] = nil
		arrested[ped] = true
		
		TriggerClientEvent("arrestPed", -1, ped)
		TriggerClientEvent("notify", source, "Arrested, walk to them and press E for more options.")
	end
end)

RegisterServerEvent("pulloverCanceled")
AddEventHandler("pulloverCanceled", function(ent)
	TriggerClientEvent("pulloverCanceled", -1, ent)
end)

RegisterServerEvent("pulloverVehicle")
AddEventHandler("pulloverVehicle", function(ent)
	TriggerClientEvent("notify", source, "Vehicle pulling over.")
	TriggerClientEvent("pulledOver", -1, ent)
	
	SetTimeout(3500, function()
		TriggerClientEvent("pulledOverOwner", source)
		TriggerClientEvent("notify", source, "Not happy with the position? Press L-SHIFT to enable manual movement or press E to cancel pullover.")
		TriggerClientEvent("pulloverDone", -1, ent)
	end)
end)

RegisterServerEvent("droveOff")
AddEventHandler("droveOff", function(ent)
	TriggerClientEvent("droveOff", -1, ent)
	TriggerClientEvent("droveOffOwner", source)
end)

RegisterServerEvent("moveVehicle")
AddEventHandler("moveVehicle", function(ent, x, y, z, ya)
	TriggerClientEvent("pulledOverMoveVehicle", -1, ent, x, y, z, ya)
end)

RegisterServerEvent("COPUnarrestPed")
AddEventHandler("COPUnarrestPed", function(ped)
	if(ped ~= nil)then
		arresting[ped] = nil
		TriggerClientEvent("unarrestingPed", -1, ped)
	end
end)