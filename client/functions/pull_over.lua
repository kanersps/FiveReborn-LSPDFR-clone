selectedVehicle = nil
local pulledOver = false
pulledOverPed = nil
local pulledOverVehicles = {}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		if IsControlJustReleased(0, 51) then
			if(IsPedInAnyVehicle(GetPlayerPed(-1), false))then
				if(selectedVehicle ~= nil)then
					FreezeEntityPosition(selectedVehicle, false)
					TriggerServerEvent("pulloverCanceled", selectedVehicle)
					selectedVehicle = nil
					ShowNotification("Pullover cancelled.")
					
					pulledOverPed = nil
					pulledOver = false
				else
					local pc = GetEntityCoords(GetPlayerPed(-1))
					local closest = GetClosestVehicle(pc['x'], pc['y'], pc['z'], 20.0, 0, 70)
					if(IsVehicleSeatFree(closest, -1) == false)then
						pulledOver = false
						pulledOverPed = nil
						if(closest ~= nil and closest ~= false)then
							if(selectedVehicle ~= nil)then
								selectedVehicle = nil
							end
							selectedVehicle = closest
							ShowNotification("Vehicle selected, press L-SHIFT to pullover or E to cancel pullover.")
						end
					else
					end
				end
			end
		end
		if IsControlJustReleased(0, 21)then
			if(selectedVehicle ~= nil)then
				
				if(IsPedInAnyVehicle(GetPlayerPed(-1), false))then
					if(pulledOver == true)then
						ShowNotification("Arrow keys to move vehicle and { or } to rotate, press L-SHIFT to exist manual movement mode.")
						SetNuiFocus(true)
						SendNUIMessage({
							move_vehicle = 1
						})
					else
						TriggerServerEvent("pulloverVehicle", selectedVehicle)
					end
				end
			end
		end
	end
end)

RegisterNetEvent("pulledOver")
AddEventHandler("pulledOver", function(entity)	
	local park = GetOffsetFromEntityInWorldCoords(entity, 4.0, 15.0, 0.0)
	if(GetEntitySpeed(entity) > 25)then
		park = GetOffsetFromEntityInWorldCoords(entity, 4.0, 65.0, 0.0)
	end
	local heading = GetEntityHeading(entity)
	TaskVehiclePark(GetPedInVehicleSeat(entity, -1), entity, park.x, park.y, park.z, 1, 0, 30.0, true)
	Citizen.CreateThread(function()
		Citizen.Wait(3500)
		SetEntityCoords(entity, park.x, park.y, park.z)
		SetEntityHeading(entity, heading)
		SetVehicleOnGroundProperly(entity)
		FreezeEntityPosition(entity, true)
		pulledOverPed = GetPedInVehicleSeat(entity, -1)
	end)
end)

RegisterNetEvent("pulloverDone")
AddEventHandler("pulloverDone", function(entity)	
	pulledOverVehicles[entity] = true
end)		

RegisterNetEvent("pulloverCanceled")
AddEventHandler("pulloverCanceled", function(entity)
	pulledOverVehicles[entity] = nil
	SetVehicleEngineOn(entity, true, true, true)
	TaskSetBlockingOfNonTemporaryEvents(GetPedInVehicleSeat(entity, -1), false)
	SetVehicleSteerBias(entity, 0.0)
end)

RegisterNetEvent("pulledOverOwner")
AddEventHandler("pulledOverOwner", function()
	pulledOver = true
	pulledOverPed = GetPedInVehicleSeat(selectedVehicle, -1)
end)

RegisterNetEvent("droveOff")
AddEventHandler("droveOff", function(e)
	FreezeEntityPosition(e, false)
end)

RegisterNetEvent("droveOffOwner")
AddEventHandler("droveOffOwner", function()
	selectedVehicle = nil
	pulledOverPed = nil
	pulledOver = false
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)		
		if(selectedVehicle ~= nil)then
			local playerLoc = GetEntityCoords(GetPlayerPed(-1))
			local vehLoc = GetEntityCoords(selectedVehicle)
			if(Vdist(vehLoc['x'], vehLoc['y'], vehLoc['z'], playerLoc['x'], playerLoc['y'], playerLoc['z']) > 100.0)then
				TriggerServerEvent("droveOff", selectedVehicle)
			end
		end
		for k,v in pairs(pulledOverVehicles) do
			SetVehicleEngineOn(k, false, true, true)
			TaskSetBlockingOfNonTemporaryEvents(GetPedInVehicleSeat(k, -1), true)
			SetVehicleSteerBias(k, 0.0)
			FreezeEntityPosition(k, true)
		end
	end
end)

RegisterNUICallback('move', function(data, cb)
	if(pulledOver == false or selectedVehicle == false or IsPedInAnyVehicle(GetPlayerPed(-1)) == false)then
	else
		local newYaw = GetEntityHeading(selectedVehicle)
		local park = GetOffsetFromEntityInWorldCoords(selectedVehicle, 0.0, 0.0, 0.0)
		if(data.direction == "left")then
			park = GetOffsetFromEntityInWorldCoords(selectedVehicle, -0.5, 0.0, 0.0)
		elseif(data.direction == "right")then
			park = GetOffsetFromEntityInWorldCoords(selectedVehicle, 0.5, 0.0, 0.0)
		elseif(data.direction == "forward")then
			park = GetOffsetFromEntityInWorldCoords(selectedVehicle, 0.0, 0.5, 0.0)		
		elseif(data.direction == "backward")then
			park = GetOffsetFromEntityInWorldCoords(selectedVehicle, 0.0, -0.5, 0.0)
		elseif(data.direction == "rotate")then
			newYaw = GetEntityHeading(selectedVehicle) + data.amount
		end

		TriggerServerEvent("moveVehicle", selectedVehicle, park.x, park.y, park.z, newYaw)
	end
end)

RegisterNetEvent("pulledOverMoveVehicle")
AddEventHandler("pulledOverMoveVehicle", function(ent, x, y, z, yaw)
	SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(ent), false)
	FreezeEntityPosition(ent, false)
	SetEntityCoords(ent, x, y, z)
	SetVehicleOnGroundProperly(ent)
	SetEntityHeading(ent, yaw)
	FreezeEntityPosition(ent, true)
end)

RegisterNUICallback('close', function(data, cb)
	if(data.message == false)then
		SetNuiFocus(false)
		return
	end

	ShowNotification("" .. data.message)
	SetNuiFocus(false)
end)