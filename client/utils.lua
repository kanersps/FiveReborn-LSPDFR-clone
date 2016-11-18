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

function maybe(x) 
	if math.random() < x then 
		return true 
	else 
		return false 
	end 
end

function chanceBecomeHostile(entity)
	if(maybe(0.05))then
		TaskSetBlockingOfNonTemporaryEvents(entity, true)
		GiveWeaponToPed(entity, GetHashKey("WEAPON_PISTOL"), 500, true, true)
		TaskShootAtEntity(entity, GetPlayerPed(-1), 15000,  GetHashKey("FIRING_PATTERN_FULL_AUTO"))
		return true
	end
	return false
end

function IsPedPlayerPed(ped)
	for i = 0, 200 do
		if(GetPlayerPed(i) == ped)then
			return true
		end
	end
	return false
end