function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function GetPlayerId()
	return GetPlayerServerId(PlayerId())
end

function Chat(t)
	TriggerEvent("chatMessage", '', { 0, 0x99, 255}, "" .. tostring(t))
end

function IsPedPlayerPed(ped)
	for i = 0, 200 do
		if(GetPlayerPed(i) == ped)then
			return true
		end
	end
	return false
end