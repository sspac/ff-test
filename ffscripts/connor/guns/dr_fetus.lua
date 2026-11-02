local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local function UpdateBombHeight(bomb)
	local data = TearFlagsLib.GetTearFlagParams(bomb, mod.FriendBulletFlags.GRENADE)
	
	if data and data.Height then
		bomb.SpriteOffset = Vector(0, data.Height)
	end
end

mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, function(_, bomb)
	if TearFlagsLib.HasTearFlags(bomb, mod.FriendBulletFlags.GOLD) then
		if bomb.FrameCount % 6 == 0 then
			local sparkle = Isaac.Spawn(1000, 1727, 0, bomb.Position+mod:shuntedPosition(10, bomb:GetDropRNG()), Vector.Zero, bomb):ToEffect()
			sparkle.SpriteOffset = bomb.SpriteOffset
			sparkle.PositionOffset = bomb.PositionOffset
			sparkle.SpriteScale = Vector(0.8, 0.8)
			sparkle:SetColor(Color(1,1,1,1,1,1,0), 100, 1, false, false)
			sparkle:Update()
		end
	end

	mod:UpdateFriendEternalHeartHalo(bomb)

	if TearFlagsLib.HasTearFlags(bomb, mod.FriendBulletFlags.GRENADE | mod.FriendBulletFlags.BLACK) and bomb:CollidesWithGrid() then
		bomb:SetExplosionCountdown(0)
	end

	if not TearFlagsLib.HasTearFlags(bomb, mod.FriendBulletFlags.GRENADE) then return end
	local data = TearFlagsLib.GetTearFlagParams(bomb, mod.FriendBulletFlags.GRENADE)

	UpdateBombHeight(bomb)

	if TearFlagsLib.GetTearFlagParams(bomb, mod.FriendBulletFlags.GRENADE).FlatStone then
		local minSpeed = data.InitialSpeed * 0.75
		if bomb.Velocity:Length() < minSpeed then
			bomb.Velocity = bomb.Velocity:Resized(data.InitialSpeed)
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_BOMB_RENDER, function(_, bomb)
	if not TearFlagsLib.HasTearFlags(bomb, mod.FriendBulletFlags.GRENADE) then return end
	local data = TearFlagsLib.GetTearFlagParams(bomb, mod.FriendBulletFlags.GRENADE)
	
	local currentFrame = Isaac.GetFrameCount()

	if not game:IsPaused() and (data.LastUpdate or 0) < currentFrame then
		data.LastUpdate = currentFrame

		local sprite = bomb:GetSprite()
		if sprite:IsPlaying("Appear") and sprite:GetFrame() == 24 then
			sprite:Play("Pulse", true)
		end

		local fallingSpeed = data.FallingSpeed or 0
		data.Height = data.Height + fallingSpeed

		local floorHeight = 0

		local gridCol = game:GetRoom():GetGridCollisionAtPos(bomb.Position)
		if gridCol == GridCollisionClass.COLLISION_OBJECT or gridCol == GridCollisionClass.COLLISION_SOLID then
			floorHeight = -20
		end

		if data.Height >= floorHeight and fallingSpeed > 0 then
			data.Height = floorHeight
			if data and TearFlagsLib.HasTearFlags(bomb, mod.FriendBulletFlags.BLACK) then
				bomb:SetExplosionCountdown(0)
			elseif TearFlagsLib.GetTearFlagParams(bomb, mod.FriendBulletFlags.GRENADE).FlatStone then
				fallingSpeed = -fallingSpeed * 0.9
				local pos = bomb.Position + Vector(0, -1)
				local splash = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.RIPPLE_POOF, 0, pos, mod.nilvector, bomb):ToEffect()
				--splash.SortingLayer = SortingLayer.SORTING_NORMAL -- for some reason setting this causes creep to also change their sortinglayer and idk why
				splash.SpriteScale = Vector(0.8, 0.8)
				splash.Color = bomb.Color
				mod:PlaySound(SoundEffect.SOUND_TEARIMPACTS)
			elseif fallingSpeed < 1.1 then
				fallingSpeed = 0
			else
				fallingSpeed = -fallingSpeed * 0.75
				if not data.Landed and not bomb:HasTearFlags(TearFlags.TEAR_HOMING) then
					local speed = bomb.Velocity:Length() * 0.75
					local rot = mod:RandomInt(160)
					if Random() % 2 == 0 then
						rot = -rot
					end
					bomb.Velocity = bomb.Velocity:Rotated(rot):Resized(speed)
				end
			end
			mod.scheduleForUpdate(function()
				mod:tryLeakySplat(bomb, nil, pos)
			end, 1)
			data.Landed = true
		else
			fallingSpeed = fallingSpeed + data.FallingAcceleration
		end
		data.FallingSpeed = fallingSpeed
	end
	TearFlagsLib.SetTearFlagParams(bomb, mod.FriendBulletFlags.GRENADE, data)
	UpdateBombHeight(bomb)
end)

local function AllowIgnoreCollision(data, size)
	return data and not data.Landed and (data.FallingSpeed < 0 or data.Height < -size)
end

mod:AddCallback(ModCallbacks.MC_PRE_BOMB_GRID_COLLISION, function(_, bomb, gridIndex, gridEntity)
	if TearFlagsLib.HasTearFlags(bomb, mod.FriendBulletFlags.GRENADE) and AllowIgnoreCollision(TearFlagsLib.GetTearFlagParams(bomb, mod.FriendBulletFlags.GRENADE), 20) and game:GetRoom():GetGridCollision(gridIndex) < GridCollisionClass.COLLISION_WALL then
		return true
	elseif TearFlagsLib.HasTearFlags(bomb, mod.FriendBulletFlags.GRENADE | mod.FriendBulletFlags.BLACK) then
		bomb:SetExplosionCountdown(0)
	end
end)

function mod:PreFriendBombCollision(bomb, collider)
	if collider.Type == mod.FF.FriendFireball.ID and collider.Variant == mod.FF.FriendFireball.Var and collider.SubType == mod.FF.FriendFireball.Sub and not mod:GetEntityData(collider).SuperExplode then
		bomb:SetExplosionCountdown(0)
		local d = mod:GetEntityData(collider)
		d.HitDirection = bomb.Velocity:Normalized()
		d.SuperExplode = true
	elseif not mod:isFriend(collider) and (collider:IsVulnerableEnemy() or not mod.IsEnemyReallyInvulnerable(collider)) then
		bomb:SetExplosionCountdown(0)
	elseif TearFlagsLib.HasTearFlags(bomb, mod.FriendBulletFlags.GRENADE) and AllowIgnoreCollision(TearFlagsLib.GetTearFlagParams(bomb, mod.FriendBulletFlags.GRENADE), collider.Size) then
		return true
	end
end

local function isRocket(bomb)
	local var = bomb.Variant
	return var == BombVariant.BOMB_ROCKET or var == BombVariant.BOMB_ROCKET_GIGA
end

mod:AddPriorityCallback(ModCallbacks.MC_PRE_BOMB_COLLISION, CallbackPriority.EARLY, function(_, bomb, collider)
	if TearFlagsLib.HasTearFlags(bomb, mod.FriendBulletFlags.GRENADE) or (TearFlagsLib.HasTearFlags(bomb, mod.FriendBulletFlags.FRIEND) and isRocket(bomb)) then
		return mod:PreFriendBombCollision(bomb, collider)
	elseif TearFlagsLib.HasTearFlags(collider, mod.FriendBulletFlags.GRENADE) then
		return mod:PreFriendBombCollision(collider, bomb)
	end
end)

mod:AddPriorityCallback("PRE_GUN_START_RELOAD", CallbackPriority.LATE, function(_, gun, player)
	--if gun.SubType == CollectibleType.COLLECTIBLE_DR_FETUS then
	--	sfx:Play(mod.Sounds.GrenadeLauncherReloadStart, 1.0, 0, false, 1.0)
	--end
end)

mod:AddPriorityCallback("GUN_RELOAD_SHOT", CallbackPriority.LATE, function(_, gun, player)
	--if gun.SubType == CollectibleType.COLLECTIBLE_DR_FETUS then
	--	sfx:Play(mod.Sounds.GrenadeLauncherReload, 1.0, 0, false, mod:RandomFloat(0.85, 1.15))
	--end
end)

mod:AddPriorityCallback("POST_GUN_RELOAD", CallbackPriority.LATE, function(_, gun, player)
	--if gun.SubType == CollectibleType.COLLECTIBLE_DR_FETUS then
	--	sfx:Play(mod.Sounds.GrenadeLauncherReloadEnd, 1.0, 0, false, 1.0)
	--end
end)
