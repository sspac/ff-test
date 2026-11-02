local mod = FiendFolio
local game = Game()

local Constants = {
    GLEAMING_LENGTH = 150,

    RA_MAX_LUCK = 20,
    RA_MIN_CHANCE = 0.1,
    RA_MAX_CHANCE = 0.5,
}

function mod:RadianceFlagGeneric(entity, player, weaponFlag)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.RADIANCE) then
        local chance = TearFlagsLib.GetChance(player.Luck, Constants.RA_MIN_CHANCE, Constants.RA_MAX_CHANCE, Constants.RA_MAX_LUCK)
        local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.RADIANCE)
        if rng:RandomFloat() < chance then
            local chosenStatus = mod.GleamStatusEffects.BURNING
            local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
			FiendFolio.FlagGleaming(entity, Constants.GLEAMING_LENGTH * secondHandMultiplier, chosenStatus)

            if weaponFlag == TearFlagsLib.WeaponFlag.TEAR then
                mod:CreateGleamAura(chosenStatus, entity)
            end
        end
    end
end
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.COLLECTIBLE.RADIANCE, mod.RadianceFlagGeneric)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.RADIANCE] = {
	BodyColor = Color(1,1,1,1,72.6875/255,-41.031/255,-34.531/255,0.688,0.969,0.469,1),
	EyeAColor = Color(1,1,1,1,240.031/255,18.734/255,-70.391/255,0.031,0.734,0.609,1),
	EyeBColor = Color(1,1,1,1,240.031/255,18.734/255,-70.391/255,0.031,0.734,0.609,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	local chance = TearFlagsLib.GetChance(0, 0.1, 0.5, 20)
	local rng = familiar.Player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.RADIANCE)
	if rng:RandomFloat() < chance then
		local player = familiar.Player
		local secondHandMultiplier = ((player and player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND)) or 0) + 1
		local chosenStatus = mod.GleamStatusEffects.BURNING
		FiendFolio.FlagGleaming(tear, 150 * secondHandMultiplier, chosenStatus)
		mod:CreateGleamAura(chosenStatus, tear)
	end
end, FiendFolio.ITEM.COLLECTIBLE.RADIANCE)