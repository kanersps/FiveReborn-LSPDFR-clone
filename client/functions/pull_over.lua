selectedVehicle = {}
local pulledOver = false
pulledOverPed = nil
local pulledOverVehicles = {}
myPlayer = GetPlayerId()

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if(myPlayer == -1)then
			myPlayer = GetPlayerId()
		end
		
		if IsControlJustReleased(0, 51) then	
			
			if(IsPedInAnyVehicle(GetPlayerPed(-1), false))then
				if(selectedVehicle[myPlayer] ~= nil)then
					TriggerServerEvent("pulloverCanceled")
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
							TriggerServerEvent("selectedVehicle")
							ShowNotification("Vehicle selected, press L-SHIFT to pullover or E to cancel pullover.")
						end
					else
					end
				end
			end
		end
		if IsControlJustReleased(0, 21)then
			if(selectedVehicle[myPlayer] ~= nil)then
				
				if(IsPedInAnyVehicle(GetPlayerPed(-1), false))then
					if(pulledOver == true)then
						ShowNotification("Arrow keys to move vehicle and { or } to rotate, press L-SHIFT to exist manual movement mode.")
						SetNuiFocus(true)
						SendNUIMessage({
							move_vehicle = 1
						})
					else
						local pc = GetOffsetFromEntityInWorldCoords(selectedVehicle[myPlayer], 5.0, 35.0, 0.0)
						TriggerServerEvent("pulloverVehicle", pc['x'], pc['y'], pc['z'])
					end
				end
			end
		end
	end
end)

RegisterNetEvent("selectedVehicle")
AddEventHandler("selectedVehicle", function(owner)
	local pc = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(owner)))
	local entity = GetClosestVehicle(pc['x'], pc['y'], pc['z'], 20.0, 0, 70)
	
	TriggerServerEvent("print", "Myplayer: " .. tostring(myPlayer) .. ", " .. tostring(owner))
	
	selectedVehicle[owner] = entity
end)

RegisterNetEvent("pullingOver")
AddEventHandler("pullingOver", function(owner, x, y, z)		
	local entity = selectedVehicle[owner]
	
	TaskVehicleDriveToCoord(GetPedInVehicleSeat(entity, -1), entity, x, y, z, 40, 1, GetEntityModel(entity), 2883621, 0, -1)
end)

RegisterNetEvent("pulledOverOwner")
AddEventHandler("pulledOverOwner", function(owner, x, y, z)		
	local entity = selectedVehicle[myPlayer]
	local pc = GetOffsetFromEntityInWorldCoords(selectedVehicle[myPlayer], 5.0, 25.0, 0.0)
	SetEntityCoords(entity, pc.x, pc.y, pc.z)
	SetVehicleOnGroundProperly(selectedVehicle[myPlayer])
	FreezeEntityPosition(selectedVehicle[myPlayer], true)
	
		pulledOverVehicles[selectedVehicle[myPlayer]] = true
	
	pulledOverPed = GetPedInVehicleSeat(selectedVehicle[myPlayer], -1)
end)

RegisterNetEvent("pulledOver")
AddEventHandler("pulledOver", function(owner, x, y, z)
	if(owner == myPlayer)then
		SetEntityCoords(selectedVehicle[owner], x, y, z)
		pulledOver = true
		pulledOverPed = GetPedInVehicleSeat(selectedVehicle[myPlayer], -1)
	end

	FreezeEntityPosition(selectedVehicle[owner], true)
	pulledOverVehicles[selectedVehicle[owner]] = true
	
	FreezeEntityPosition(selectedVehicle[owner], true)
end)		

RegisterNetEvent("pulloverCanceled")
AddEventHandler("pulloverCanceled", function(owner)
	pulledOverVehicles[selectedVehicle[owner]] = nil
	SetVehicleEngineOn(selectedVehicle[owner], true, true, true)
	TaskSetBlockingOfNonTemporaryEvents(GetPedInVehicleSeat(selectedVehicle[owner], -1), false)
	SetVehicleSteerBias(selectedVehicle[owner], 0.0)
	FreezeEntityPosition(selectedVehicle[owner], false)
	selectedVehicle[owner] = nil
end)	

RegisterNetEvent("droveOff")
AddEventHandler("droveOff", function(owner)
	FreezeEntityPosition(selectedVehicle[owner], false)
	selectedVehicle[owner] = nil
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)		
		if(selectedVehicle[myPlayer] ~= nil)then
			local playerLoc = GetEntityCoords(GetPlayerPed(-1))
			local vehLoc = GetEntityCoords(selectedVehicle[myPlayer])
			if(Vdist(vehLoc['x'], vehLoc['y'], vehLoc['z'], playerLoc['x'], playerLoc['y'], playerLoc['z']) > 100.0)then
				TriggerServerEvent("droveOff", selectedVehicle[myPlayer])
			end
			
			DrawMarker(0, vehLoc['x'], vehLoc['y'], vehLoc['z'] + 1.8, 0, 0, 0, 0, 0, 0, 0.5001, 0.5001, 0.5001, 255,255,0,255, 0,0, 0,0)
		end
		for k,v in pairs(pulledOverVehicles) do
			FreezeEntityPosition(k, true)
			SetVehicleEngineOn(k, false, true, true)
			TaskSetBlockingOfNonTemporaryEvents(GetPedInVehicleSeat(k, -1), true)
		end
	end
end)

RegisterNUICallback('move', function(data, cb)
	if(pulledOver == false or selectedVehicle == false or IsPedInAnyVehicle(GetPlayerPed(-1)) == false)then
	else
		if(data.amount == nil)then
			data.amount = 0
		end
		
		local park = GetOffsetFromEntityInWorldCoords(selectedVehicle[myPlayer], 0.0, 0.0, 0.0)
		local yaw = GetEntityHeading(selectedVehicle[myPlayer])
		local direction = data.direction
		if(direction == "forward")then
			park = GetOffsetFromEntityInWorldCoords(selectedVehicle[myPlayer], 0.0, 0.5, 0.0)
		elseif(direction == "backward")then
			park = GetOffsetFromEntityInWorldCoords(selectedVehicle[myPlayer], 0.0, -0.5, 0.0)
		elseif(direction == "left")then
			park = GetOffsetFromEntityInWorldCoords(selectedVehicle[myPlayer], -0.5, 0.0, 0.0)
		elseif(direction == "right")then
			park = GetOffsetFromEntityInWorldCoords(selectedVehicle[myPlayer], 0.5, 0.0, 0.0)
		elseif(direction == "rotate")then
			yaw = yaw + data.amount
		end
		
		TriggerServerEvent("moveVehicle", park.x, park.y, park.z, yaw)
	end
end)

RegisterNetEvent("pulledOverMoveVehicle")
AddEventHandler("pulledOverMoveVehicle", function(owner, x, y, z, yaw)
	pulledOverVehicles[selectedVehicle[owner]] = nil
	FreezeEntityPosition(selectedVehicle[owner], false)
	SetEntityCoords(selectedVehicle[owner], x, y, z)
	SetEntityHeading(selectedVehicle[owner], yaw)
	FreezeEntityPosition(selectedVehicle[owner], true)
	pulledOverVehicles[selectedVehicle[owner]] = true
end)

RegisterNUICallback('close', function(data, cb)
	if(data.message == false)then
		SetNuiFocus(false)
		return
	end

	ShowNotification("" .. data.message)
	SetNuiFocus(false)
end)