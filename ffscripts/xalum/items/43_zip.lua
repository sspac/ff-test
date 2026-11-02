local mod = FiendFolio
local game = Game()

local zipBombs = mod.ITEM.COLLECTIBLE.ZIP_43
local flag = TearFlagsLib.RegisterTearFlag("FF_ZIP_BOMB")
mod.ReducedZipBombEffect = {
	[mod.BombFlagSource.DR_FETUS] = true,
	[mod.BombFlagSource.EPIC_FETUS] = true,
	[mod.BombFlagSource.LOCUST_OF_WAR] = true,
	[mod.BombFlagSource.ANARCHISTS_EASY_BAKE] = true,
    [mod.BombFlagSource.MINESWEEPER] = true,
	[mod.BombFlagSource.CLUB_EPIC_FETUS] = true,
}

local function canNpcGetOverloaded(npc)
	return (
		npc and
		npc:IsVulnerableEnemy() and
		not npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and
		not npc:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) and
		not npc:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
	)
end

function FiendFolio:canNpcGetDownloadFaliure(npc)
	return (
		npc and
		npc:IsVulnerableEnemy() and
		not npc:IsBoss() and
		not mod.DownloadFailureBlacklist[npc.Type] and
		not npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and
		not npc:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) and
		not npc:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
	)
end

function mod:zipBombsFlag(entity, player)
	if player:HasCollectible(zipBombs) then
		TearFlagsLib.AddTearFlags(entity, flag)
	end
end
mod:AddCollectibleCallback(FiendFolio.CALLBACK.FF_POLL_BOMBFLAGS, zipBombs, mod.zipBombsFlag)

function mod:zipBombsVariant(bomb, player)
	if player:HasCollectible(zipBombs) then
		local var = bomb.Variant
		if mod:isReplaceableBombVariant(var) then
			if mod:isCopperVariant(var) then
				bomb.Variant = mod.BOMB.ZIP_COPPER
				bomb.Flags = bomb.Flags
			else
				bomb.Variant = mod.BOMB.ZIP
				bomb.Flags = bomb.Flags
			end
		end
	end
end
mod:AddCollectibleCallback(FiendFolio.CALLBACK.FF_SET_BOMB_VARIANT, zipBombs, mod.zipBombsVariant)

mod:AddCallback(FiendFolio.CALLBACK.FF_POST_BOMBFLAG_EFFECTS, function(_, pos, radius, tearflags, src, radiusMult, player, sourceFlag, tearFlagParams)
	local bombData = mod:GetEntityData(src)
	local frame = game:GetFrameCount()
	if bombData.lastFrame43Zipped == frame then
		return
	end
	
	local rng = player:GetCollectibleRNG(zipBombs)
	local chance = mod.ReducedZipBombEffect[sourceFlag] and 0.2 or 1
	
	for _, entity in pairs(Isaac.FindInRadius(pos, 10000, EntityPartition.ENEMY)) do
		entity = entity:ToNPC()
		if entity and rng:RandomFloat() < chance then
			if rng:RandomFloat() < 0.05 and canNpcGetOverloaded(entity) then
				mod.AddOverloaded(entity, player, 0, 7, player.Damage * 0.4, 45, 15, true)
			elseif mod:canNpcGetDownloadFaliure(entity) then
				mod:GetEntityData(entity).DownloadFailuredManually = true
			end
		end
	end

	bombData.lastFrame43Zipped = frame
end, flag)