local menuOpen = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustReleased(0, 51) then	

			if(pulledOverPed == nil)then
			
				for key,value in pairs(arrested)do	
					if(IsPedDeadOrDying(key, 1) == 1)then
						TriggerServerEvent("COPUnarrestPed", key)
					else							
						if(GetEntityType(key) == 1 and IsPedInAnyVehicle(GetPlayerPed(-1), false) == false)then	
							local pedLoc = GetEntityCoords(key)
							local playerLoc = GetEntityCoords(GetPlayerPed(-1))
							if(Vdist(pedLoc['x'], pedLoc['y'], pedLoc['z'], playerLoc['x'], playerLoc['y'], playerLoc['z']) < 2.0)then
									
								SetNuiFocus(true)
								SendNUIMessage({
									open_talk = 1,
									sex = IsPedMale(key),
									t = "arrested",
									ped = tostring(key),
									arrested = true,
								})
								break
							end
						end
					end
				end
			else
				if(GetEntityType(pulledOverPed) == 1 and IsPedInAnyVehicle(GetPlayerPed(-1), false) == false)then
					if(IsPedFatallyInjured(pulledOverPed) == 1)then
						TriggerServerEvent("COPUnarrestPed", pulledOverPed)
					else					
						if(IsPedInAnyVehicle(pulledOverPed, false) == 1)then
							local pedLoc = GetEntityCoords(pulledOverPed)
							local playerLoc = GetEntityCoords(GetPlayerPed(-1))
							if(Vdist(pedLoc['x'], pedLoc['y'], pedLoc['z'], playerLoc['x'], playerLoc['y'], playerLoc['z']) < 2.0)then	
								SendNUIMessage({
									open_talk = 1,
									sex = IsPedMale(pulledOverPed),
									t = "arrested",
									ped = tostring(pulledOverPed),
								})
								SetNuiFocus(true)
							end
						end
					end
				end
			end
		end
	end
end)