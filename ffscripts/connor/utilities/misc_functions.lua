local mod = FiendFolio
local game = Game()

-- Hi
-- 		-- Connor

function mod:AddInnateCollectibleForRoom(player, collectible, count, addcostume)
	player:AddInnateCollectible(collectible, count or 1, "FF_ROOM", -1, addcostume ~= false)
end
function mod:AddInnateTrinketForRoom(player, trinket, count, addcostume)
	player:AddInnateTrinket(trinket, count or 1, "FF_ROOM", -1, addcostume ~= false)
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_ROOM_EXIT, CallbackPriority.IMPORTANT, function(_, player)
	player:ClearInnateItemGroup("FF_ROOM")
end)

function mod:AddInnateCollectibleForFloor(player, collectible, count, addcostume)
	player:AddInnateCollectible(collectible, count or 1, "FF_LEVEL", -1, addcostume ~= false)
end
function mod:AddInnateTrinketForFloor(player, trinket, count, addcostume)
	player:AddInnateTrinket(trinket, count or 1, "FF_LEVEL", -1, addcostume ~= false)
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_LEVEL_INIT, CallbackPriority.IMPORTANT, function()
	for _, player in ipairs(PlayerManager.GetPlayers()) do
		player:ClearInnateItemGroup("FF_LEVEL")
	end
end)

function mod.HasSoyOrAlmondMilk(player)
	return player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) or player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK)
end

-- mod:RandomFloat() -> 0.0 ~ 1.0
-- mod:RandomFloat(a) -> 0.0 ~ a
-- mod:RandomFloat(a, b) -> a ~ b
function mod:RandomFloat(a, b, rng)
	local rand = rng and rng:RandomFloat() or (Random() / (2^32))
	if a and b then
		return mod:Lerp(a, b, rand)
	elseif a then
		return a * rand
	end
	return rand
end

function mod:WeightedRound(value, rng)
	if mod:RandomFloat(nil, nil, rng) > value % 1 then
		return math.ceil(value)
	end
	return math.floor(value)
end

-- Has support for Boiler
function FiendFolio:IsMirrorWorld(room)
    room = room or game:GetRoom()
    local isMirror = room:IsMirrorWorld()

    if not isMirror then
        if FFGRACE and FFGRACE:IsBoilerMirrorWorld() then
            isMirror = true
        end
    end

    return isMirror
end

function mod:GetMousePosition(gameCoords)
	local pos = Input.GetMousePosition(gameCoords)
	if gameCoords and mod:IsMirrorWorld() then
		-- `Isaac.ScreenToWorld(StageAPI.GetScreenCenterPosition())` doesn't seem to work but this does? IDK
		local center = Isaac.ScreenToWorld(Vector.Zero) + Isaac.ScreenToWorldDistance(StageAPI.GetScreenCenterPosition())
		pos.X = 2*center.X - pos.X
	end
	return pos
end

local CAST_FUNC = {
	[EntityType.ENTITY_PLAYER] =	 function(ent) return ent:ToPlayer() end,
	[EntityType.ENTITY_TEAR] =		 function(ent) return ent:ToTear() end,
	[EntityType.ENTITY_FAMILIAR] =	 function(ent) return ent:ToFamiliar() end,
	[EntityType.ENTITY_BOMB] =		 function(ent) return ent:ToBomb() end,
	[EntityType.ENTITY_PICKUP] =	 function(ent) return ent:ToPickup() end,
	[EntityType.ENTITY_SLOT] =		 function(ent) return ent:ToSlot() end,
	[EntityType.ENTITY_LASER] =		 function(ent) return ent:ToLaser() end,
	[EntityType.ENTITY_KNIFE] =		 function(ent) return ent:ToKnife() end,
	[EntityType.ENTITY_PROJECTILE] = function(ent) return ent:ToProjectile() end,
	[EntityType.ENTITY_EFFECT] =	 function(ent) return ent:ToEffect() end,
}

-- Automatically casts the provided entity to the appropriate subclass.
function mod:CastEntity(ent)
	local castFunc = CAST_FUNC[ent.Type]
	return castFunc and castFunc(ent) or ent:ToNPC() or ent
end

-- Provided an EntityPtr (or nil) returns the pointed-at entity (or nil).
-- As a bonus, it pre-casts the entity to the appropriate type for you! :)
function mod:GetPointee(ptr, allowRemoved)
	if ptr and ptr.Ref and (ptr.Ref:Exists() or allowRemoved) then
		return mod:CastEntity(ptr.Ref)
	end
end

-- mathe
function mod:CalculateTravelTimeSpeed(heightOffset, maxHeight, fallAccel, distance)
	local travelTime = math.sqrt(2*(maxHeight - heightOffset) / fallAccel) + math.sqrt(2*maxHeight / fallAccel)
	local speed = distance / travelTime
	return travelTime, speed
end
function mod:CalculateFallSpeedAccel(heightOffset, maxHeight, travelTime)
	local fallAccel = (4 * math.sqrt(maxHeight^2 * travelTime^4 - maxHeight * heightOffset * travelTime^4) + 4 * maxHeight * travelTime^2 - heightOffset * travelTime^2) / travelTime^4
	local fallSpeed = -math.sqrt(2 * fallAccel * maxHeight)
	return fallSpeed, fallAccel
end

-- Returns something from a nested table, or nil if any point in the specific path doesn't exist.
-- For example, `mod:Access(tab, 1, 2, 3)` will return the value at `tab[1][2][3]`, or nil if any of those subtables are missing.
function mod:Access(tab, key, ...)
	if tab[key] then
		if #{...} == 0 then
			return tab[key]
		elseif type(tab[key]) == "table" then
			return mod:Access(tab[key], ...)
		end
	end
end

function mod:AddSamaelAngerBonus(amount)
	if SamaelMod and SamaelMod.IncreaseAngerBonus then
		SamaelMod.IncreaseAngerBonus(amount)
	end
end

-- If a sprite has an Offset AND its X or Y axis flipped, rotations get wacky.
-- Basically, the origin point used for rotation is still offset by the Offset value, but if an axis is flipped,
-- the sprite visually is rendered at the inverted offset, so rotations look much different than you'd expect.
-- So for example, with FlipX and Offset=(10,0), the sprite will be visually offset by (-10,0) but still rotates around (10,0).
-- I dunno for sure if this is WRONG, but personally I'd prefer for flipping to not change the root point for transformations like this.
--
-- This function calculates an additional offset to reverse the wonky effects of the Rotation on the Offset, to be returned in REPENTOGON's MC_PRE_X_RENDER callbacks.
-- Note that you'll likely still need to adjust your Rotation values elsewhere to account for FlipX/FlipY - this function is just for correcting the Offset getting handled weirdly.
--
-- unflipOffset: Additionally reverses the Offset being flipped at all (looks as if the sprite was flipped AFTER applying the offset).
function mod:GetSpriteFlippedAxisCorrectionOffset(sprite, unflipOffset)
	if sprite.FlipX or sprite.FlipY then
		local base = sprite.Offset * Vector(sprite.FlipX and -2 or 0, sprite.FlipY and -2 or 0)
		local rot = -sprite.Rotation
		if sprite.FlipX and sprite.FlipY then
			rot = -rot
		end
		local correctionOffset = -base:Rotated(rot)
		if not unflipOffset then
			correctionOffset = correctionOffset + base
		end
		return correctionOffset
	end
	return mod.nilvector
end

-- Returns a value that can be multiplied to sprite coordinates to get an equivalent distance in world coordinates.
-- In theory, anyway. Not extensively tested.
function mod:GetSpriteToWorldScaleFactor()
	return 100 / Isaac.WorldToScreen(Vector(100,0)):Distance(Isaac.WorldToScreen(Vector(0,0)))
end

-- Returns (pos, scale, rotation, color) for a sprite in the current anm2 frame, relative to the anm2 root.
-- Intended for trying to position/render something at a specific spot on a sprite without a NullFrame.
-- WARNING - Will return nil if the sprite has no animation set yet!
--   `usePivot`: If true, returned pos is based on the pivot point. If false, returned value is based on the top-left corner of the sprite.
--   `offset`: Can be provided to offset your target point on the sprite from the pivot or top-left.
--   `inWorldCoords`: Converts the returned pos to world scale, to instead be added to an entity's Position or PositionOffset.
--     (By default, the returned pos would be expected to be used as a sprite offset.)
-- May not work perfectly in all situations - let me know if you find anything weird so I can improve this!
-- Returns: offset, scale, rotation
function mod:GetSpritesheetTransform(sprite, layer, usePivot, offset, inWorldCoords, overlay)
	offset = offset or mod.nilvector
	local animData = sprite:GetCurrentAnimationData()
	if not animData then return end

	local frameData = overlay and sprite:GetOverlayLayerFrameData(layer) or sprite:GetLayerFrameData(layer)

	local scale = frameData:GetScale() * sprite.Scale

	local frameOffset = offset * scale
	if not usePivot then
		frameOffset = frameOffset - frameData:GetPivot() * scale
	end
	local framePos = frameData:GetPos() * scale + frameOffset:Rotated(frameData:GetRotation())
	local pos = sprite.Offset + framePos:Rotated(sprite.Rotation) * Vector(sprite.FlipX and -1 or 1, sprite.FlipY and -1 or 1)

	if inWorldCoords then
		pos = pos * mod:GetSpriteToWorldScaleFactor()
	end

	local rotation = frameData:GetRotation() + sprite.Rotation

	if sprite.FlipX ~= sprite.FlipY then
		rotation = -rotation
	end
	if sprite.FlipX then
		rotation = rotation + 180
	end

	return pos, scale, rotation, frameData:GetColor()
end

-- Wrote this and then didn't need it
--[[function mod:GetCollectiblePickupSound()
	local roomDesc = game:GetLevel():GetCurrentRoomDesc()
	local roomType = roomDesc.Data and roomDesc.Data.Type or 1
	if roomType == RoomType.ROOM_BOSS or roomType == RoomType.ROOM_MINIBOSS then
		return SoundEffect.SOUND_POWERUP2
	elseif roomType == RoomType.ROOM_TREASURE or roomType == RoomType.ROOM_LIBRARY then
		return SoundEffect.SOUND_POWERUP1
	elseif roomType == RoomType.ROOM_SHOP then
		return SoundEffect.SOUND_POWERUP3
	elseif roomType == RoomType.ROOM_DEVIL or roomType == RoomType.ROOM_BLACK_MARKET or roomDesc.Flags & RoomDescriptor.FLAG_DEVIL_TREASURE ~= 0 then
		return SoundEffect.SOUND_DEVILROOM_DEAL
	end
	return SoundEffect.SOUND_CHOIR_UNLOCK
end]]

-- This function was made as a drop-in replacement for `Isaac.Spawn(EntityType.ENTITY_PROJECTILE`,
-- to ensure that things like projectile flags are passed along correctly for cases like friendly enemies.
-- Please don't use this function for new code!
function mod:LazySpawnProjectile(var, subt, pos, vel, entity)
	local npc = entity and entity:ToNPC()
	local origProj = entity and entity:ToProjectile()
	-- Got odd behaviour with some projectile variants, likely due to a difference in how they are initialized.
	-- So we'll keep using Isaac.Spawn BUT are still making sure that flags are handled correctly.
	--[[if npc and subt == 0 then
		local params = ProjectileParams()
		params.Variant = var
		params.FallingAccelModifier = -0.1
		params.FallingSpeedModifier = 3
		params.CurvingStrength = 0.015
		return npc:FireProjectilesEx(pos, vel, 0, params)[1]
	end]]
	local spawner = entity 
	if origProj then
		spawner = nil --Passing a projectile as the spawner entity causes friendly projectiles to hurt you idk why
	end
	local newProj = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, var, subt, pos, vel, spawner):ToProjectile()
	if npc then
		mod:makeCharmProj(npc, newProj)
	elseif origProj then
		newProj.Color = origProj.Color
		local flagsToInherit = origProj.ProjectileFlags & (ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES)
		newProj:AddProjectileFlags(flagsToInherit)
	end
	return newProj
end

-- Returns a list of players that would be present on the boss VS screen. Primarily just excluding twins.
-- The indexes in the returned table correspond to the layers in the vs screen anm2, IE `PlayerPortraitAlt_3`.
function mod:GetVsScreenPlayers()
	local out = {}

	for _, player in ipairs(PlayerManager.GetPlayers()) do
		local twin = player:GetOtherTwin()
		if not twin or twin:GetPlayerIndex() == -1 or player:GetPlayerIndex() <= twin:GetPlayerIndex() or GetPtrHash(player) == GetPtrHash(twin) then
			table.insert(out, player)
			if not REPENTANCE_PLUS or #out >= 4 then
				break
			end
		end
	end

	return out
end

local WEAPON_TYPES_THAT_CAN_CHANGE_SPREAD_ANGLE_DID_THIS_REALLY_NEED_TO_TRIGGER_A_LUA_ERROR_GUYS = {
	[WeaponType.WEAPON_TEARS] = true,
	[WeaponType.WEAPON_BOMBS] = true,
	[WeaponType.WEAPON_BRIMSTONE] = true,
	[WeaponType.WEAPON_LASER] = true,
	[WeaponType.WEAPON_KNIFE] = true,
	[WeaponType.WEAPON_TECH_X] = true,
	[WeaponType.WEAPON_FETUS] = true,
	[WeaponType.WEAPON_BONE] = true,
	[WeaponType.WEAPON_NOTCHED_AXE] = true,
}
function mod:WeaponTypeCanChangeSpreadAngle(weaponType)
	return WEAPON_TYPES_THAT_CAN_CHANGE_SPREAD_ANGLE_DID_THIS_REALLY_NEED_TO_TRIGGER_A_LUA_ERROR_GUYS[weaponType]
end
