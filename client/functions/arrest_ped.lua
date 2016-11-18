arresting = {}
arrested = {}
hostile = {}

local first = true
local firstTimer = nil

Citizen.CreateThread(function()

	while true do
		Citizen.Wait(1)
		
		local entity = Citizen.InvokeNative(0x2975C866E6713290, PlayerId(), Citizen.PointerValueInt(), Citizen.ResultAsInteger(entity))
		
			
		
		if IsControlJustReleased(0, 51) then
			if(IsPedDeadOrDying(entity, 1) ~= 1)then
				if(arresting[entity] == true)then
					TriggerServerEvent("COPArrestedPed", entity)
					
				else
					if(GetEntityType(entity) == 1)then	
						if(IsPedPlayerPed(entity) ~= true)then
							TriggerServerEvent("COPArrestingPed", entity)
						end
					end
				end
			end
		end
		if(first == true and GetEntityType(entity) == 1)then
			if(IsPedDeadOrDying(entity, 1) ~= 1)then
				if(IsPedPlayerPed(entity) ~= true)then
					first = false
					TriggerEvent("notify", "Press E to attempt to intimidate.")
				end
			end
		else
			if(GetEntityType(entity) ~= 1 and first == false and firstTimer == nil)then
				firstTimer = true
				Citizen.CreateThread(function()
					Citizen.Wait(5000)
					first = true
					firstTimer = nil
				end)
			end
		end
	end
end)

-- Event handlers
RegisterNetEvent("arrestingPed")
AddEventHandler("arrestingPed", function(entity)
	if(chanceBecomeHostile(entity) == true)then
		hostile[entity] = true
		ShowNotification("Suspect became hostile!")
		return
	end
	
	ShowNotification("Press E to arrest.")

	if(IsPedPlayerPed(entity) == true)then
		return
	end
	
	if(GetEntityType(entity) == 1)then	
		if(arresting[entity] == nil and arrested[entity] == nil)then
			arresting[entity] = true						
			pedArresting(entity)
		end
	end
end)

RegisterNetEvent("notify")
AddEventHandler("notify", function(msg)
	ShowNotification(msg)
end)

RegisterNetEvent("arrestPed")
AddEventHandler("arrestPed", function(owner)	
	if(hostile[entity] == true)then
		return
	end
	
	local entity = Citizen.InvokeNative(0x2975C866E6713290, GetPlayerFromServerId(owner), Citizen.PointerValueInt(), Citizen.ResultAsInteger(entity))
	if(IsPedPlayerPed(entity) == true)then
		return
	end
	arresting[entity] = nil
	arrested[entity] = true
	
	TaskSetBlockingOfNonTemporaryEvents(entity, true)
	playAnim(entity, "random@arrests@busted","enter")
	Citizen.CreateThread(function()
		Citizen.Wait(1600)
		playAnim(entity, "random@arrests@busted","idle_a", true)
		Citizen.Wait(1600)
	end)
end)

RegisterNetEvent("unarrestingPed")
AddEventHandler("unarrestingPed", function(entity)
	arresting[entity] = nil
	
end)

RegisterNetEvent("releasePed")
AddEventHandler("releasePed", function(ent)
	arrested[tonumber(ent)] = nil
	arresting[tonumber(ent)] = nil
	
	TaskSetBlockingOfNonTemporaryEvents(tonumber(ent), true)
	
	ClearPedTasksImmediately(tonumber(ent))
	TaskPlayAnim(tonumber(ent), "random@arrests@busted","idle_a", 8, -4, 100, 0.1, 0, false, false, true)
	
	if(selectedVehicle[myPlayer] ~= nil)then
		TriggerServerEvent("pulloverCanceled")
	else
		
	end
	
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		for k, v in pairs(arresting) do
			if(GetEntityType(k) == 1)then	
				if(not IsPedFatallyInjured(k))then
					
					TaskStandStill(k, 2000)
					TaskHandsUp(k, 2000, GetPlayerPed(-1), -1,true)
				end
			end
		end
		for k, v in pairs(arrested) do
			if(GetEntityType(k) == 1)then	
				if(not IsPedFatallyInjured(k))then					
					TaskStandStill(k, 2000)
				end
			end
		end
	end
end)

function pedArresting(ped)
	arresting[ped] = true
	if(not IsPedFatallyInjured(ped))then
		Citizen.CreateThread(function()
			Citizen.Wait(7000)
			if(Citizen.InvokeNative(0x2975C866E6713290, PlayerId(), Citizen.PointerValueInt(), Citizen.ResultAsInteger(entity)) == ped)then
				pedArresting(ped)
			else
				if(IsPedPlayerPed(ped) == false)then
					TriggerServerEvent("COPUnarrestPed", ped)
				end
			end
		end)
	end
end

function playAnim(ped, animdict, anim, infinite)
	Citizen.CreateThread(function()
		while(not HasAnimDictLoaded(animdict))do
			RequestAnimDict(animdict)
			Citizen.Wait(0)
			
		end
		
						
		TaskPlayAnim(tonumber(ped), animdict, anim, 8.0, 0.0, -1, 0, 0, 1, 1, 1)
	end)
end

RegisterNUICallback('release_ped', function(data, cb)
	TriggerServerEvent("releasePed", data.ped)
	SetNuiFocus(false)
end)

RegisterNUICallback('arrest_ped', function(data, cb)
	TriggerServerEvent("releasePed", data.ped)
	SetEntityCoords(tonumber(data.ped), 0.0, 0.0, 0.0)
	ShowNotification("Suspect has been picked up.")
	SetNuiFocus(false)
end)