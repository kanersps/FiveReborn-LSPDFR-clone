arresting = {}
arrested = {}

local first = true
local firstTimer = nil

Citizen.CreateThread(function()

	while true do
		Citizen.Wait(1)
		
		local entity = Citizen.InvokeNative(0x2975C866E6713290, PlayerId(), Citizen.PointerValueInt(), Citizen.ResultAsInteger(entity))
		
		if IsControlJustReleased(0, 51) then
			if(arresting[entity] == true)then
				TriggerServerEvent("COPArrestedPed", entity)
			else
				if(GetEntityType(entity) == 1)then	
					if(IsPedPlayerPed(entity) == true)then
						return
					end
					TriggerServerEvent("COPArrestingPed", entity)
				end
			end
		end
		if(first == true and GetEntityType(entity) == 1)then
			if(IsPedPlayerPed(entity) == true)then
				return
			end
			first = false
			TriggerEvent("notify", "Press E to attempt to intimidate.")
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
AddEventHandler("arrestPed", function(entity)	
	SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(entity), false)
	if(IsPedPlayerPed(entity) == true)then
		return
	end
	arresting[entity] = nil
	arrested[entity] = true
	
	playAnim(entity, "random@arrests@busted","enter")
	Citizen.CreateThread(function()
		Citizen.Wait(1600)
		playAnim(entity, "random@arrests@busted","idle_a", true)
		Citizen.Wait(1600)
		FreezeEntityPosition(entity, true)
	end)
end)

RegisterNetEvent("unarrestingPed")
AddEventHandler("unarrestingPed", function(entity)
	arresting[entity] = nil
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
		
		local flag = 0

		TaskPlayAnim(ped, animdict, anim,8, -4, -1, 0, 0, false, false, true)
	end)
end