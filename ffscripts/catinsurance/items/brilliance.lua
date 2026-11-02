local mod = FiendFolio

local Constants = {
    GLEAMING_LENGTH = 150,

    BR_MAX_LUCK = 20,
    BR_MIN_CHANCE = 0.1,
    BR_MAX_CHANCE = 0.5,
}

function mod:BrillianceFlagGeneric(entity, player, weaponFlag)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.BRILLIANCE) then
        local chance = TearFlagsLib.GetChance(player.Luck, Constants.BR_MIN_CHANCE, Constants.BR_MAX_CHANCE, Constants.BR_MAX_LUCK)
        local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.BRILLIANCE)
        if rng:RandomFloat() < chance then
            local chosenStatus = rng:RandomInt(mod.GleamStatusEffects.FEAR, mod.GleamStatusEffects.BRUISED)
            local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
			FiendFolio.FlagGleaming(entity, Constants.GLEAMING_LENGTH * secondHandMultiplier, chosenStatus)

            if weaponFlag == TearFlagsLib.WeaponFlag.TEAR then
                mod:CreateGleamAura(chosenStatus, entity)
            end
        end
    end
end
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.COLLECTIBLE.BRILLIANCE, mod.BrillianceFlagGeneric)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.BRILLIANCE] = {
	BodyColor = Color(1,1,1,1,72.6875/255,-41.031/255,-34.531/255,0.688,0.969,0.469,1),
	EyeAColor = Color(1,1,1,1,103.918/255,-51.204/255,12.235/255,0.684,0.959,0.847,1),
	EyeBColor = Color(1,1,1,1,-93.184/255,-46.418/255,-34.786/255,1.163,1.316,1.143,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	local chance = TearFlagsLib.GetChance(0, 0.1, 0.5, 20)
	local rng = familiar.Player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.BRILLIANCE)
	if rng:RandomFloat() < chance then
		local player = familiar.Player
		local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
		local chosenStatus = rng:RandomInt(mod.GleamStatusEffects.FEAR, mod.GleamStatusEffects.BRUISED)
		FiendFolio.FlagGleaming(tear, 150 * secondHandMultiplier, chosenStatus)
		mod:CreateGleamAura(chosenStatus, tear)
	end
end, FiendFolio.ITEM.COLLECTIBLE.BRILLIANCE)

-- cool costume colors...
local function getRGB(value)
	return math.sin(value / 15) / 4
end

function mod:UpdateBrillianceCostume(player)
	if player:GetPlayerType() ~= PlayerType.PLAYER_BLACKJUDAS and player:GetPlayerType() ~= PlayerType.PLAYER_JUDAS_B then
		for i, desc in pairs( player:GetCostumeSpriteDescs() ) do
			if desc:GetItemConfig().ID == mod.ITEM.COLLECTIBLE.BRILLIANCE then
				local base = player.FrameCount + player.InitSeed
				local r = getRGB(base)
				local g = getRGB(base + 40)
				local b = getRGB(base + 80)
				local color = Color(1,1,1, 1, r,g,b)
				desc:GetSprite():GetLayer(0):SetColor(color)
			end
		end
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.BRILLIANCE, mod.UpdateBrillianceCostume)