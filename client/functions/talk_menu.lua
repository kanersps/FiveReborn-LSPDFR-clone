local menuOpen = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		if IsControlJustReleased(0, 51) then
			if(pulledOverPed == nil)then
				for key,value in pairs(arrested)do
					if(GetEntityType(key) == 1)then	
						local pedLoc = GetEntityCoords(key)
						local playerLoc = GetEntityCoords(GetPlayerPed(-1))
						if(Vdist(pedLoc['x'], pedLoc['y'], pedLoc['z'], playerLoc['x'], playerLoc['y'], playerLoc['z']) < 5.0)then
								
								
							SendNUIMessage({
								open_talk = 1,
								sex = IsPedMale(key),
								t = "arrested",
							})
							SetNuiFocus(true)
							break
						end
					end
				end
			else
				if(GetEntityType(pulledOverPed) == 1)then
					if(IsPedInAnyVehicle(pulledOverPed) == 1)then
						local pedLoc = GetEntityCoords(pulledOverPed)
						local playerLoc = GetEntityCoords(GetPlayerPed(-1))
						if(Vdist(pedLoc['x'], pedLoc['y'], pedLoc['z'], playerLoc['x'], playerLoc['y'], playerLoc['z']) < 5.0)then	
							SendNUIMessage({
								open_talk = 1,
								sex = IsPedMale(pulledOverPed),
								t = "arrested",
							})
							SetNuiFocus(true)
						end
					end
				end
			end
		end
	end
end)