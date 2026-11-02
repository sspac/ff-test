local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local cursedUrn = mod.ITEM.TRINKET.CURSED_URN
local urnShards	= mod.ITEM.TRINKET.SHATTERED_CURSED_URN

function mod.MorphTrinketEx(pickup, trinketID, noGold, noBlasphemous)
	local isGolden = pickup.SubType & TrinketType.TRINKET_GOLDEN_FLAG > 0
	local isBlasphemous = mod:IsPickupTrinketBlasphemous(pickup)
	pickup:Morph(5, 350, trinketID)

	if isGolden and not noGold then
		pickup.SubType = pickup.SubType | TrinketType.TRINKET_GOLDEN_FLAG
	end

	if isBlasphemous and not noBlasphemous then
		mod:MakePickupTrinketBlasphemous(pickup)
	end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if player:HasTrinket(cursedUrn) or player:HasTrinket(urnShards) then
		player.TearColor = mod.ColorChinaYellow
	end
end, CacheFlag.CACHE_TEARCOLOR)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	--player.MaxFireDelay = player.MaxFireDelay * (0.75 ^ player:GetTrinketMultiplier(cursedUrn)) -- direct maxfiredelay multipliers break at negative firedelay values
	player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, mod:convertTearMultABPToRep(0.75 ^ player:GetTrinketMultiplier(cursedUrn)))
	--player.MaxFireDelay = player.MaxFireDelay * (0.90 ^ player:GetTrinketMultiplier(urnShards)) -- direct maxfiredelay multipliers break at negative firedelay values
	player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, mod:convertTearMultABPToRep(0.90 ^ player:GetTrinketMultiplier(urnShards)))
end, CacheFlag.CACHE_FIREDELAY)

local function shouldCursedUrnBreak(pickup)
	local data = mod:GetEntityData(pickup)
	return (
		data.WasDroppedByPlayer
		and pickup:GetSprite():IsEventTriggered("DropSound")
	)
end

local function breakCursedUrn(pickup)
	local sprite = pickup:GetSprite()
	local frameCache = sprite:GetFrame()
	local animCache = sprite:GetAnimation()

	if pickup.SubType & TrinketType.TRINKET_GOLDEN_FLAG > 0 then
		sfx:Play(SoundEffect.SOUND_GOLD_HEART_DROP)
		sfx:Play(SoundEffect.SOUND_ULTRA_GREED_COIN_DESTROY)
		mod.MorphTrinketEx(pickup, cursedUrn, true)

		for i = 30, 360, 30 do
			local offset = Vector(0, 3):Rotated(i)
			local sparkle = Isaac.Spawn(1000, 1727, 0, pickup.Position + offset:Resized(20), offset, pickup)
			sparkle.SpriteOffset = Vector(1, -8)
		end
	else
		sfx:Play(SoundEffect.SOUND_MIRROR_BREAK, 0.8, 0, false, 1)
		mod.MorphTrinketEx(pickup, urnShards)

		for i = 1, 3 do
			local dust = Isaac.Spawn(1000, 59, 0, pickup.Position, Vector(math.random(-5, 5), math.random(-1, 3)), pickup):ToEffect()
			dust:SetTimeout(60)
			mod.SpawnGunpowder(pickup, pickup.Position + Vector.FromAngle(i * 120) * 15, 900, 30)
		end
	end

	-- Fix an issue where blowing up the urn would make it unable to be picked up
	if animCache ~= "Idle" then
		sprite:Play(animCache)
		sprite:SetFrame(frameCache)
	else
		sprite:SetLastFrame()
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_DROP_TRINKET, function (_, _, _, player, _, _, trinket)
	local data = mod:GetEntityData(trinket)
	data.WasDroppedByPlayer = true
end, mod.ITEM.TRINKET.CURSED_URN)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	if mod.PickupIsTrinket(pickup, cursedUrn) and shouldCursedUrnBreak(pickup) then
		breakCursedUrn(pickup)
	end
end, 350)

-- Priority:
--[[
	Held Golden Cursed Urn
	Held Cursed Urn
	Held Shattered Cursed Urn 	 -- Only if player has Mom's Box
	Smelted Golden Cursed Urn
	Smelted Cursed Urn
	Smelted Shattered Cursed Urn -- Only if player has Mom's Box
]]

function mod.CanPlayerReviveWithCursedUrn(player)
	return player:HasTrinket(cursedUrn) or (player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) and player:HasTrinket(urnShards)) or player:HasGoldenTrinket(urnShards)
end

function mod:CursedUrnRenderLives(player, lives)
	local t0 = player:GetTrinket(0)
	local t1 = player:GetTrinket(1)
	local smeltedTrinkets = player:GetSmeltedTrinkets({cursedUrn, urnShards})
	local momsBoxFactor = (player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) and 1) or 0
	
	-- local urnMultiplier = math.max(0, player:GetTrinketMultiplier(cursedUrn) - momsBoxFactor)
	-- local numUrnTrinkets = ((t0 % TrinketType.TRINKET_GOLDEN_FLAG == cursedUrn and 1) or 0) + ((t1 % TrinketType.TRINKET_GOLDEN_FLAG == cursedUrn and 1) or 0) + smeltedTrinkets[cursedUrn].trinketAmount + smeltedTrinkets[cursedUrn].goldenTrinketAmount
	-- local numUrnShardsTrinkets = ((t0 % TrinketType.TRINKET_GOLDEN_FLAG == urnShards and 1) or 0) + ((t1 % TrinketType.TRINKET_GOLDEN_FLAG == urnShards and 1) or 0) + smeltedTrinkets[urnShards].trinketAmount + smeltedTrinkets[urnShards].goldenTrinketAmount

	local livesFromUrns = player:GetTrinketMultiplier(cursedUrn)
	local livesFromShards = momsBoxFactor == 1 and (
		(t0 &~ TrinketType.TRINKET_GOLDEN_FLAG == urnShards and 1 or 0) + (t1 &~ TrinketType.TRINKET_GOLDEN_FLAG == urnShards and 1 or 0) + smeltedTrinkets[urnShards].trinketAmount + smeltedTrinkets[urnShards].goldenTrinketAmount
	) or (
		(t0 & TrinketType.TRINKET_GOLDEN_FLAG == TrinketType.TRINKET_GOLDEN_FLAG and 1 or 0) + (t1 & TrinketType.TRINKET_GOLDEN_FLAG == TrinketType.TRINKET_GOLDEN_FLAG and 1 or 0) + smeltedTrinkets[urnShards].goldenTrinketAmount
	)
	
	local urnLives = livesFromUrns + livesFromShards
	if urnLives > 0 then
		return {Lives = lives + urnLives}
	end
end
mod:AddTrinketCallback(CustomHealthAPI.Enums.Callbacks.PRE_RENDER_LIVES, cursedUrn, mod.CursedUrnRenderLives)
mod:AddTrinketCallback(CustomHealthAPI.Enums.Callbacks.PRE_RENDER_LIVES, urnShards, mod.CursedUrnRenderLives)

function mod.DowngradeCursedUrn(player)
	mod.DowngradeTrinket(player, cursedUrn, urnShards, true)
end

-- Called from `ffscripts/revives.lua`
function mod.TryCursedUrnRevive(player)
	if not mod.CanPlayerReviveWithCursedUrn(player) then return end

	mod.DowngradeCursedUrn(player)
	player:Revive()

	-- Transform the main twin.
	if player:GetMainTwin() and GetPtrHash(player) ~= GetPtrHash(player:GetMainTwin()) then
		player = player:GetMainTwin()
		player:Revive()
	end

	local alreadyChina = player:GetPlayerType() == mod.PLAYER.CHINA

	if alreadyChina then
		player:AddBrokenHearts(-12)
	else
		local twin = player:GetOtherTwin()
		player:ChangePlayerType(mod.PLAYER.CHINA)
		player:AddCacheFlags(CacheFlag.CACHE_TEARCOLOR | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_SIZE)
	end

	player:AddMaxHearts(player:GetMaxHearts())
	player:AddBoneHearts(1-player:GetBoneHearts())
	player:AddSoulHearts(-player:GetSoulHearts())
	player:AddRottenHearts(-player:GetRottenHearts())
	player:AddHearts(-99) -- clearing out custom hp
	player:AddHearts(2)

	player:AddBrokenHearts(-6)

	mod:explodePlayer(player, true)
	player:SetMinDamageCooldown(90)
end

mod:AddCallback(ModCallbacks.MC_POST_BOMB_DAMAGE, function(_, position, damage, radius, lineCheck, source, tearFlags, damageFlags, canDamageSource)
	for _, pickup in pairs(Isaac.FindInRadius(position, radius, EntityPartition.PICKUP)) do
		if mod.PickupIsTrinket(pickup, cursedUrn) then
			breakCursedUrn(pickup:ToPickup())
		end
	end
end)