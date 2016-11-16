function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function IsPedPlayerPed(ped)
	for i = 0, 200 do
		if(GetPlayerPed(i) == ped)then
			return true
		end
	end
	return false
end