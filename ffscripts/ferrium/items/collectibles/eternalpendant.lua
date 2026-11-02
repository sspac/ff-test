local mod = FiendFolio
local game = Game()

local delayedEternalShields = {}
function mod:EternalPendantOnHeal(player, key, hp, info)
	if game:GetFrameCount() <= 10 then return end
    if key == "ETERNAL_HEART" and player:HasCollectible(mod.ITEM.COLLECTIBLE.ETERNAL_PENDANT) then
        if player:GetEternalHearts() == 0 then --Eternal hearts are removed before this triggers fully
			local data = CustomHealthAPI.Helper.GetOtherData(player)
			if data and data.IsResyncing then
				delayedEternalShields[GetPtrHash(player)] = true
			else
				mod:AddEternalShield(player)
			end
        end
    end
end
mod:AddCollectibleCallback(CustomHealthAPI.Enums.Callbacks.POST_ADD_HEALTH, mod.ITEM.COLLECTIBLE.ETERNAL_PENDANT, mod.EternalPendantOnHeal)

function mod:EternalPendantOnHealDelayed(player)
	local ptrhash = GetPtrHash(player)
	if delayedEternalShields[ptrhash] then
		mod:AddEternalShield(player)
	end
	delayedEternalShields[ptrhash] = nil
end
mod:AddPriorityCallback(CustomHealthAPI.Enums.Callbacks.POST_RESYNC_PLAYER, CallbackPriority.EARLY, mod.EternalPendantOnHealDelayed)

function mod:EternalPendantNewLevel(player, d)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.ETERNAL_PENDANT) then
        player:AddEternalHearts(1)
    end
end
mod:AddCollectibleCallback("FF_NEW_LEVEL_PLAYER_FERRIUM", mod.ITEM.COLLECTIBLE.ETERNAL_PENDANT, mod.EternalPendantNewLevel)

mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, function(_, type, charge, first, slot, var, player)
    if first then
        player:AddEternalHearts(1)
    end
end, mod.ITEM.COLLECTIBLE.ETERNAL_PENDANT)