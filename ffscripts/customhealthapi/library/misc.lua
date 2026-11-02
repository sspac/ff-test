function CustomHealthAPI.Library.ResetPlayerData(player, includeOtherData)
	CustomHealthAPI.Helper.ClearSavedata(player)
	
	if includeOtherData then
		CustomHealthAPI.Helper.ClearOtherData(player)
	end
	
	local i = CustomHealthAPI.Helper.GetPlayerIndex(player)
	CustomHealthAPI.PersistentData.HiddenPlayerHealthBackup[i] = nil
	
	local subPlayer = player:GetSubPlayer()
	
	if subPlayer ~= nil then
		CustomHealthAPI.Helper.ClearSavedata(subPlayer)
		if includeOtherData then
			CustomHealthAPI.Helper.ClearOtherData(subPlayer)
		end
	end
end

function CustomHealthAPI.Library.PlayHealthCollectSound(key)
	local def = CustomHealthAPI.PersistentData.HealthDefinitions[key]
	if def then
		return CustomHealthAPI.Helper.PlaySound(def.CollectSound)
	end
end

function CustomHealthAPI.Library.PlayCustomPickupCollectSound(pickupVar, pickupSubt)
	local def = CustomHealthAPI.Library.GetPickupDefinition(pickupVar, pickupSubt)
	if def then
		return CustomHealthAPI.Helper.PlaySound(def.CollectSound)
	end
end

function CustomHealthAPI.Library.PlayCollectSoundFromPickup(pickup)
	local def = pickup ~= nil and CustomHealthAPI.Library.GetPickupDefinition(pickup.Variant, pickup.SubType)
	if def then
		return CustomHealthAPI.Helper.PlaySound(def.CollectSound)
	end
end
