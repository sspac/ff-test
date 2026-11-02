local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

-- Eternal D12
-- 2 charges
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, id, rng, player, useflags, activeslot, customvardata)
	if useflags == useflags | UseFlag.USE_CARBATTERY then
        return {Discharge = false, Remove = false, ShowAnim = false}
    end
	local data = mod:GetEntityData(player)
	local save = data.ffsavedata
	local maxCharge = 2
	if save.EternalD12SingleUseMode then
		maxCharge = 1
	end

	if not (useflags == useflags | UseFlag.USE_OWNED) then
		maxCharge = mod.ForceED12Number or (1 + rng:RandomInt(2))
	end

    if rng:RandomFloat() <= maxCharge/3 then
      mod.reroll_grids({2, 3, 4, 5, 6, 11, 12, 14, 22, 24, 25, 27}, false, false, false)
      mod:ChangeD12Grids(mod.ED12Grid)
	  mod:RegisterD12UsedRoom(2)
    else
      mod.wipe_grids({2, 4, 6, 14, 22, 27}, false)
      sfx:Play(SoundEffect.SOUND_DEATH_CARD, 1, 0, false, 1)
    end
	--[[if activeslot and activeslot >= 0 then
		player:RemoveCollectible(id, true, activeslot)
		player:AddCollectible(mod.ITEM.COLLECTIBLE.ETERNAL_D12_ALT, 0, false, activeslot)
    end]]
	if useflags == useflags | UseFlag.USE_OWNED then
		if save.EternalD12SingleUseMode then
			save.EternalD12SingleUseMode = false
		else
			save.EternalD12SingleUseMode = true
		end
	end
	return true
end, mod.ITEM.COLLECTIBLE.ETERNAL_D12)

mod:AddCallback(ModCallbacks.MC_PLAYER_GET_ACTIVE_MAX_CHARGE, function(_, id, player, VarData, currentMax)
	local data = mod:GetEntityData(player)
	local save = data.ffsavedata
	if save.EternalD12SingleUseMode then
		return 1
	end
end, mod.ITEM.COLLECTIBLE.ETERNAL_D12)