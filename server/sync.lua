local arresting = {}
local arrested = {}

RegisterServerEvent("COPArrestingPed")
AddEventHandler("COPArrestingPed", function(ped)
	if(ped ~= nil and arresting[ped] == nil)then
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
		
		TriggerClientEvent("arrestPed", -1, source)
		TriggerClientEvent("notify", source, "Arrested, walk to them and press E for more options.")
	end
end)

RegisterServerEvent("releasePed")
AddEventHandler("releasePed", function(ent)
	TriggerClientEvent("releasePed", -1, ent)
	TriggerClientEvent("pulloverCanceled", -1, source)
end)

RegisterServerEvent("selectedVehicle")
AddEventHandler("selectedVehicle", function()
	TriggerClientEvent("selectedVehicle", -1, source)
end)

RegisterServerEvent("pulloverCanceled")
AddEventHandler("pulloverCanceled", function()
	TriggerClientEvent("pulloverCanceled", -1, source)
end)

RegisterServerEvent("pulloverVehicle")
AddEventHandler("pulloverVehicle", function(x, y, z)
	TriggerClientEvent("notify", source, "Vehicle pulling over.")	
	TriggerClientEvent("pullingOver", -1, source, x, y, z)
	
	SetTimeout(3500, function()
		TriggerClientEvent("notify", source, "Not happy with the position? Press L-SHIFT to enable manual movement or press E to cancel pullover.")
		TriggerClientEvent("pulledOver", -1, source, x, y, z)
	end)
end)

RegisterServerEvent("print")
AddEventHandler("print", function(t)
	print(""..t)
end)

RegisterServerEvent("droveOff")
AddEventHandler("droveOff", function(ent)
	print("Cancelled")
	TriggerClientEvent("droveOff", -1, source)
end)

RegisterServerEvent("moveVehicle")
AddEventHandler("moveVehicle", function(x, y, z, yaw)
	TriggerClientEvent("pulledOverMoveVehicle", -1, source, x, y, z, yaw)
end)

RegisterServerEvent("COPUnarrestPed")
AddEventHandler("COPUnarrestPed", function(ped)
	if(ped ~= nil)then
		arresting[ped] = nil
		TriggerClientEvent("unarrestingPed", -1, ped)
	end
end)