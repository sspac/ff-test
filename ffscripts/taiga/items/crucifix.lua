-- Crucifix --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local tearcolor = Color(1.0, 1.0, 1.0, 1.0, 50/255, 120/255, 160/255, 0.75, 0.7, 1, 1)
local lasercolor = Color(1.0, 1.0, 1.0, 1.0, 0/255, 0/255, 0/255, 3.75, 5.25, 6, 1)

function mod:updateCrucifixTearLaserColor(player)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.CRUCIFIX) then
		player.TearColor = player.TearColor * tearcolor
		player.LaserColor = player.LaserColor * lasercolor
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_CACHE, FiendFolio.ITEM.COLLECTIBLE.CRUCIFIX, mod.updateCrucifixTearLaserColor, CacheFlag.CACHE_TEARCOLOR)

local function getStackedCrucifixDuration(player, secondHandMultiplier)
	local base = 150 
	local result = math.ceil(base * (math.log(math.max(1, player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.CRUCIFIX)), 5) + 1))
	return result * secondHandMultiplier
end

function mod:crucifixFlagGeneric(entity, player, weaponFlag)
	if weaponFlag == TearFlagsLib.WeaponFlag.DARK_ARTS or weaponFlag == TearFlagsLib.WeaponFlag.OCULAR_RIFT then return end
	
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.CRUCIFIX) then
		local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
		FiendFolio.FlagMartyr(entity, getStackedCrucifixDuration(player, secondHandMultiplier))
	end
end
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.COLLECTIBLE.CRUCIFIX, mod.crucifixFlagGeneric)
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_CHANCELESS_TEARFLAGS, FiendFolio.ITEM.COLLECTIBLE.CRUCIFIX, mod.crucifixFlagGeneric)

function mod:crucifixFlagLocust(entity, player, weaponFlag)
	local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
	FiendFolio.FlagMartyr(entity, 150 * secondHandMultiplier)
end
mod:AddEntityCallback(TearFlagsLib.Callback.POLL_LOCUST_TEARFLAGS, EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, 
                      FiendFolio.ITEM.COLLECTIBLE.CRUCIFIX, mod.crucifixFlagLocust, FiendFolio.ITEM.COLLECTIBLE.CRUCIFIX)

function mod:crucifixFlagOnDamage(entity)
	local data = mod:GetEntityData(entity)
	local frame = game:GetFrameCount()
	if data.RolledForCrucifix ~= frame then
		data.RolledForCrucifix = frame
		
		local player = TearFlagsLib.GetTearPlayer(entity)
		if player and player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.CRUCIFIX) then
			local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
			FiendFolio.FlagMartyr(entity, getStackedCrucifixDuration(player, secondHandMultiplier))
		end
	end
end

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.CRUCIFIX] = {
	TearColor = tearcolor,
	BodyColor = Color(1,1,1,1,-2.407/255,-36.637/255,-29.062/255,0.876,0.850,0.416,1),
	EyeAColor = Color(1,1,1,1,139.912/255,67.699/255,-132.956/255,0.451,0.735,1.274,1),
	EyeBColor = Color(1,1,1,1,139.912/255,67.699/255,-132.956/255,0.451,0.735,1.274,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	local player = familiar.Player
	local secondHandMultiplier = ((player and player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND)) or 0) + 1
	FiendFolio.FlagMartyr(tear, 150 * secondHandMultiplier)
end, FiendFolio.ITEM.COLLECTIBLE.CRUCIFIX)