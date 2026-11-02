-- Toy Piano --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local duration = 180
local countdown = 3
local damageMulti = 4

local chanceDivider = 10
local baseChanceVal = 2
local maxChanceAtLuck = 34
local scaledChanceMult = (chanceDivider - baseChanceVal) / maxChanceAtLuck

local tearcolor = Color(0.30, 0.30, 0.30, 1.0, 10/255, -25/255, -25/255, 0.75, 0.5, 0.5, 1.0)
local lasercolor = Color(1.0, 1.0, 1.0, 1.0, 0/255, 0/255, 0/255, 1.0, 0.1, 0.1, 1)

function mod:toyPianoLaserColor(player, flag)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.TOY_PIANO) then
		player.TearColor = tearcolor
		player.LaserColor = player.LaserColor * lasercolor
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_CACHE, FiendFolio.ITEM.COLLECTIBLE.TOY_PIANO, mod.toyPianoLaserColor, CacheFlag.CACHE_TEARCOLOR)

function mod:toyPianoFlagGeneric(entity, player, weaponFlag)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.TOY_PIANO) then
		local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
		FiendFolio.FlagDoom(entity, 
		                    duration * secondHandMultiplier, 
		                    countdown, 
		                    player.Damage * damageMulti, 
		                    (baseChanceVal + player.Luck * scaledChanceMult) / chanceDivider)
	end
end
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.COLLECTIBLE.TOY_PIANO, mod.toyPianoFlagGeneric)

function mod:toyPianoFlagLocust(entity, player)
	if player:GetCollectibleRNG(FiendFolio.ITEM.COLLECTIBLE.TOY_PIANO):RandomFloat() < 0.2 then
		local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
		FiendFolio.FlagDoom(entity, 
		                    duration * secondHandMultiplier, 
		                    countdown, 
		                    player.Damage * damageMulti, 
		                    (baseChanceVal + player.Luck * scaledChanceMult) / chanceDivider)
	end
end
mod:AddEntityCallback(TearFlagsLib.Callback.POLL_LOCUST_TEARFLAGS, EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, 
                      FiendFolio.ITEM.COLLECTIBLE.TOY_PIANO, mod.toyPianoFlagLocust, FiendFolio.ITEM.COLLECTIBLE.TOY_PIANO)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.TOY_PIANO] = {
	TearColor = tearcolor,
	BodyColor = Color(1,1,1,1,-24.009/255,-26.522/255,-27.265/255,0.345,0.363,0.354,1),
	EyeAColor = Color(1,1,1,1,-93.699/255,-51.805/255,-31.699/255,1.265,0.407,0.265,1),
	EyeBColor = Color(1,1,1,1,-47.035/255,-119.575/255,-70.938/255,0.381,1.434,0.584,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	local player = familiar.Player
	local secondHandMultiplier = ((player and player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND)) or 0) + 1
	FiendFolio.FlagDoom(tear, 180 * secondHandMultiplier, 3, player.Damage * 5,  2 / 9)
end, FiendFolio.ITEM.COLLECTIBLE.TOY_PIANO)