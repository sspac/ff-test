local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local STUCK_KNIFE_DAMAGE_MULT = 0.2

local BAYONETTE_OFFSET = {
	DEFAULT = Vector(45, 30),
	--["gfx/effects/guns/guns_revolver_middle.anm2"] = Vector(34, 26),
	--["gfx/effects/guns/guns_revolver_middle_right.anm2"] = Vector(45, 26),
}

local KNIFE_OFFSET = Vector(9, 2)
local SPEAR_OFFSET = Vector(15, 2)

local SPEAR_ANM2 = string.lower(EntityConfig.GetEntity(EntityType.ENTITY_EFFECT, EffectVariant.SPEAR_OF_DESTINY):GetAnm2Path())

local function GetBayonette(gun)
	local ptr = mod:GetEntityData(gun).FriendBayonette
	if ptr and ptr.Ref and ptr.Ref:Exists() then
		return ptr.Ref
	end
end

local function GetBayonetteGun(bayonette)
	local ptr = mod:GetEntityData(bayonette).FriendBayonetteGun
	if ptr and ptr.Ref and ptr.Ref:Exists() then
		return ptr.Ref:ToEffect()
	end
end

mod:AddCallback("POST_GUN_UPDATE", function(_, gun, player)
	local bayonetteType = nil
	
	local hasSpearOfDestiny = player:HasCollectible(CollectibleType.COLLECTIBLE_SPEAR_OF_DESTINY, false, true)
	
	if mod:GetFriendWeaponType(player, gun) ~= WeaponType.WEAPON_SPIRIT_SWORD then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
			bayonetteType = EntityType.ENTITY_KNIFE
		elseif hasSpearOfDestiny then
			bayonetteType = EntityType.ENTITY_EFFECT
		end
	end

	local bayonette = GetBayonette(gun)

	if bayonette and bayonette.Type ~= bayonetteType then
		bayonette:Remove()
		bayonette = nil
	end

	if bayonetteType and not bayonette then
		if bayonetteType == EntityType.ENTITY_KNIFE then
			bayonette = player:FireKnife(gun, 0, true, 0, 0)
		elseif bayonetteType == EntityType.ENTITY_EFFECT then
			bayonette = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPEAR_OF_DESTINY, 0, gun.Position, mod.nilvector, player):ToEffect()
			bayonette:FollowParent(gun)
		end
		if bayonette then
			mod:GetEntityData(gun).FriendBayonette = EntityPtr(bayonette)
			mod:GetEntityData(bayonette).FriendBayonetteGun = EntityPtr(gun)
		end
	end

	if bayonette and bayonetteType == EntityType.ENTITY_KNIFE then
		local sprite = bayonette:GetSprite()
		local hasSpearAnm2 = string.lower(sprite:GetFilename()) == SPEAR_ANM2
		if hasSpearOfDestiny and not hasSpearAnm2 then
			sprite:Load(SPEAR_ANM2, true)
		elseif not hasSpearOfDestiny and hasSpearAnm2 then
			sprite:Load(EntityConfig.GetEntity(bayonette.Type, bayonette.Variant, bayonette.SubType):GetAnm2Path(), true)
		end
	end
end)

local function MakeGibs(pos, vel, source)
	for i=1, 3 do
		local angleRange = 35
		local angle = mod:RandomInt(angleRange) - angleRange*0.5
		local speedRange = 4
		local speed = 5 + mod:RandomInt(speedRange) - speedRange*0.5
		vel = vel:Rotated(angle):Resized(speed)
		local gib = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_PARTICLE, 0, pos, vel, source):ToEffect()
		if source then
			gib.Color = source.SplatColor
		end
		gib.SpriteScale = Vector(0.75, 0.75)
	end
end

local function UpdateBayonette(bayonette, gun, preRender)
	local data = mod:GetEntityData(bayonette)
	local gunData = mod:GetEntityData(gun)
	local player = mod:GetFriendGunPlayer(gun)
	local shotspeed = player and player.ShotSpeed or 1

	local bayoSprite = bayonette:GetSprite()
	local gunSprite = gun:GetSprite()

	local isKnife = bayonette:ToKnife() ~= nil
	local spearAnm2 = string.lower(bayoSprite:GetFilename()) == SPEAR_ANM2

	bayoSprite:SetFrame("Idle", 0)

	local bayonetteSpritesheetPos = (BAYONETTE_OFFSET[gunSprite:GetFilename()] or BAYONETTE_OFFSET.DEFAULT) + ((isKnife and not spearAnm2) and KNIFE_OFFSET or SPEAR_OFFSET)

	local gunInfo = mod.FriendGunInfo[gun.SubType]
	if gunInfo and gunInfo.BayonetteOffset then
		bayonetteSpritesheetPos = bayonetteSpritesheetPos + gunInfo.BayonetteOffset
	end

	local offset, scale, rotation, color = mod:GetSpritesheetTransform(gunSprite, 0, false, bayonetteSpritesheetPos, not preRender)

	if not offset then return end

	if game:GetRoom():GetFrameCount() <= 1 and data.BayonetteFlying then
		data.BayonetteFlying = nil
	end

	bayonette.PositionOffset = gun.PositionOffset
	bayonette.Rotation = rotation - 90
	bayoSprite.Rotation = rotation - 90

	if not isKnife then
		bayoSprite.FlipX = gunSprite.FlipX
		if bayoSprite.FlipX then
			bayonette.Rotation = -bayonette.Rotation
			bayoSprite.Rotation = -bayoSprite.Rotation
		end
	end

	bayoSprite.Scale = Vector(scale.Y, scale.X)  -- Because of how the sprite on the knife/spear anm2 is rotated.
	bayoSprite.Color = color * player.TearColor

	if not data.BayonetteFlying then
		if spearAnm2 then
			data.BayonetteFlipX = false
			data.BayonetteFlipY = gunSprite.FlipX and isKnife
		else
			data.BayonetteFlipX = gunSprite.FlipX
			data.BayonetteFlipY = false
		end

		bayoSprite.Offset = mod.nilvector
		if preRender then
			bayoSprite.Offset = offset
			bayonette.Position = gun.Position
		else
			if isKnife then
				bayonette.Position = gun.Position + offset
			else
				bayonette.ParentOffset = offset
			end
		end
	else
		local tab = data.BayonetteFlying
		if not tab.Init then
			tab.Origin = gun.Position + offset
			tab.Pos = tab.Origin
			tab.Rotation = rotation
			tab.Init = true
		end
		local currentFrame = Isaac.GetFrameCount()
		if not game:IsPaused() and tab.LastUpdate < currentFrame then
			local lastPos = tab.Pos
			if tab.Return then
				local targetPos = gun.Position + offset
				if tab.Stuck then
					if tab.Stuck.Ref and tab.Stuck.Ref:Exists() and not tab.Stuck.Ref:IsDead() and not tab.Stuck.Ref:HasMortalDamage() then
						mod:makeEnemyGib(tab.Stuck.Ref)
					end
					sfx:Play(SoundEffect.SOUND_KNIFE_PULL, 0.8, 0, false, mod:RandomFloat(0.9, 1.1))
					MakeGibs(tab.Pos, (targetPos - tab.Pos):Resized(10), tab.Stuck.Ref)
					tab.Stuck = nil
				end
				tab.Lerp = (tab.Lerp or 0.05) + 0.01
				tab.Pos = mod:Lerp(tab.Pos, targetPos, tab.Lerp)
				local dist = tab.Pos:Distance(targetPos)
				if dist < 100 then
					tab.Rotation = tab.Rotation + mod.RotateTowardsTarget(tab.Rotation, rotation, 0.15)
					tab.KillRopes = true
				end
				if dist < 7.5 then
					bayonette.Position = targetPos
					data.BayonetteFlying = nil
				end
			elseif tab.Stuck then
				if not tab.Stuck.Ref or not tab.Stuck.Ref:Exists() or tab.Stuck.Ref:IsDead() then
					tab.Return = true
				else
					local stuck = tab.Stuck.Ref
					if not tab.StuckOffset then
						tab.StuckOffset = tab.Pos - stuck.Position
					end
					tab.Pos = stuck.Position + tab.StuckOffset
				end
			else
				tab.Pos = tab.Pos + tab.Aim:Resized(shotspeed * 6)
				local hitWall = game:GetRoom():GetGridCollisionAtPos(tab.Pos) >= GridCollisionClass.COLLISION_WALL
				if hitWall then
					local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.IMPACT, 0, tab.Pos, mod.nilvector, nil):ToEffect()
					eff.SpriteScale = eff.SpriteScale * 0.6
					sfx:Play(SoundEffect.SOUND_SCYTHE_BREAK, 0.75, 0, false, mod:RandomFloat(1.75, 1.8))
				end
				if hitWall or tab.Pos:Distance(tab.Origin) > 500 then
					tab.Return = true
				end
			end
			tab.LastUpdate = currentFrame
			tab.Vel = tab.Pos - lastPos
		end
		bayonette.Rotation = tab.Rotation
		bayoSprite.Rotation = tab.Rotation - 90
		bayonette.Position = tab.Pos
		bayonette.Velocity = tab.Vel
	end

	if not preRender then
		local killRopes = not data.BayonetteFlying or data.BayonetteFlying.KillRopes

		if data.BayonetteRopeHandler then
			local handler = data.BayonetteRopeHandler.Ref
			if killRopes or not handler then
				if handler then
					if handler.Child then
						handler.Child:Remove()
					end
					handler:Remove()
				end
				data.BayonetteRopeHandler = nil
			else
				handler:ToEffect().ParentOffset = Vector(0, 20) + Vector(20, 0):Rotated(bayoSprite.Rotation - 90)
			end
		end

		if gunData.BayonetteRopeHandler then
			local handler = gunData.BayonetteRopeHandler.Ref
			if killRopes or not handler then
				if handler then
					if handler.Child then
						handler.Child:Remove()
					end
					handler:Remove()
				end
				gunData.BayonetteRopeHandler = nil
			else
				local newOffset = mod:GetSpritesheetTransform(gunSprite, 0, false, bayonetteSpritesheetPos + Vector(-15, -2), true)
				if newOffset then
					handler:ToEffect().ParentOffset = newOffset + Vector(0, 20)
				end
			end
		end
	end

	local layerState = bayoSprite:GetLayer(0)
	if layerState.SetFlipX then
		layerState:SetFlipX(data.BayonetteFlipX or false)
		layerState:SetFlipY(data.BayonetteFlipY or false)
	end
end

function mod:FriendBayonetteDamage(npc, data, damage, damageFlags, sourceEnt, sourceData, sourceRef)
	if sourceData.BayonetteFlying and sourceData.BayonetteFlying.Stuck then
		return {Damage = damage * STUCK_KNIFE_DAMAGE_MULT}
	end
end
mod:AddPreNpcTakeDmgFromSourceCallback(mod.FriendBayonetteDamage, EntityType.ENTITY_KNIFE, 0, 0)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, function(_, entity, damage, flags, source)
	if entity:IsVulnerableEnemy() and not entity:IsDead() and not entity:HasMortalDamage() and source and source.Entity and GetBayonetteGun(source.Entity) then
		local data = mod:GetEntityData(source.Entity)
		if data.BayonetteFlying and not data.BayonetteFlying.Return and not data.BayonetteFlying.Stuck then
			data.BayonetteFlying.Stuck = EntityPtr(entity)
			local offset = source.Entity.Position - entity.Position
			local maxDist = entity.Size + source.Entity.Size - 5
			if offset:Length() > maxDist then
				offset = offset:Resized(maxDist)
			end
			data.BayonetteFlying.StuckOffset = offset
			mod:makeEnemyGib(entity)
			sfx:Play(SoundEffect.SOUND_MEATY_DEATHS, 0.8, 0, false, mod:RandomFloat(0.9, 1.1))
		end
	end
end)

local function InitRopeHandler(entity)
	local existing = mod:GetEntityData(entity).BayonetteRopeHandler
	if not existing or not existing.Ref or not existing.Ref:Exists() then
		local handler = Isaac.Spawn(1000, 1749, 164, entity.Position, mod.nilvector, entity):ToEffect()
		handler:FollowParent(entity)
		handler.Parent = entity
		handler.Visible = false
		handler:Update()
		mod:GetEntityData(entity).BayonetteRopeHandler = EntityPtr(handler)
	elseif existing.Child then
		existing.Child:Remove()
	end
	return mod:GetEntityData(entity).BayonetteRopeHandler.Ref
end

local function SpawnRope(bayonette, gun)
	local bayonetteHandler = InitRopeHandler(bayonette)
	local gunHandler = InitRopeHandler(gun)

	local rope = Isaac.Spawn(EntityType.ENTITY_EVIS, 10, 24, gun.Position, mod.nilvector, bayonette)
	bayonetteHandler.Child = rope
	gunHandler.Child = rope

	rope.Parent = bayonetteHandler
	rope.Target = gunHandler

	rope:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	rope:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	rope.DepthOffset = -20

	rope:GetSprite():Play("Idle", true)
	rope:GetSprite():SetFrame(100)
	rope:Update()

	rope.SplatColor = Color(1,1,1,0,0,0,0)
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, handler)
	if handler.SubType == 164 then
		if not handler.Parent or not handler.Parent:Exists() then
			handler:Remove()
		elseif mod:GetEntityData(handler.Parent).BayonetteFlying and mod:GetEntityData(handler.Parent).BayonetteFlying.Return then
			-- This sucks but update the rope more on the return trip because it helps it freak out slightly less.
			handler.Child:Update()
			handler.Child:Update()
		end
	end
end, 1749)

mod:AddCallback("POST_GUN_FIRE", function(_, gun, player, aim)
	local bayonette = GetBayonette(gun)
	if not bayonette or not bayonette:ToKnife() then return end

	local data = mod:GetEntityData(bayonette)

	if not data.BayonetteFlying then
		SpawnRope(bayonette, gun)
		sfx:Play(SoundEffect.SOUND_GFUEL_GUNSHOT_LARGE, 0.8, 0, false, mod:RandomFloat(0.9, 1.1))
		data.BayonetteFlying = {
			Aim = aim,
			LastUpdate = 0,
			Distance = 0,
		}
	end
end)

mod:AddCallback("POST_GUN_RELOAD", function(_, gun, player)
	local bayonette = GetBayonette(gun)
	if not bayonette or not bayonette:ToKnife() then return end

	local data = mod:GetEntityData(bayonette)

	if data.BayonetteFlying then
		data.BayonetteFlying.Return = true
	end
end)


-- Render bayonettes specifically right before the gun renders.

local renderingBayonette = false

mod:AddCallback(ModCallbacks.MC_PRE_EFFECT_RENDER, function(_, gun)
	local bayonette = GetBayonette(gun)
	if bayonette and not mod:GetEntityData(bayonette).BayonetteFlying then
		renderingBayonette = true
		bayonette:Render(game:GetRoom():GetRenderScrollOffset())
		renderingBayonette = false
	end
end)


-- Mom's Knife Bayonette Handling

mod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, function(_, knife)
	local gun = GetBayonetteGun(knife)
	if not gun then return end

	knife.PathOffset = 0
	knife.RotationOffset = 0

	local gunData = mod:GetEntityData(gun)
	local player = mod:GetFriendGunPlayer(gun)
	local tearFlags = player and player:GetTearHitParams(WeaponType.WEAPON_KNIFE).TearFlags or knife.TearFlags

	if string.lower(knife:GetSprite():GetFilename()) == SPEAR_ANM2 then
		knife.SizeMulti = Vector(1,2)
		tearFlags = tearFlags | TearFlags.TEAR_FEAR
	else
		knife.SizeMulti = Vector(1,1)
	end

	knife.TearFlags = tearFlags

	UpdateBayonette(knife, gun, false)
end)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_KNIFE_RENDER, CallbackPriority.IMPORTANT, function(_, knife)
	local gun = GetBayonetteGun(knife)
	if not gun then return end

	if not mod:GetEntityData(knife).BayonetteFlying and (not renderingBayonette or not gun.Visible) then
		return false
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_KNIFE_RENDER, CallbackPriority.LATE, function(_, knife)
	local gun = GetBayonetteGun(knife)
	if not gun then return end

	UpdateBayonette(knife, gun, true)
end)

mod:AddPriorityCallback(ModCallbacks.MC_POST_KNIFE_RENDER, CallbackPriority.IMPORTANT, function(_, knife)
	local gun = GetBayonetteGun(knife)
	if not gun then return end

	UpdateBayonette(knife, gun, false)
end)


-- Spear of Destiny Bayonette Handling

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, spear)
	if spear.SubType == 0 and spear.Parent and spear.Parent:ToPlayer() and spear.Parent:ToPlayer():GetPlayerType() == mod.PLAYER.FRIEND and mod:GetEntityData(spear.Parent).FriendsRevolver then
		local gun = mod:GetEntityData(spear.Parent).FriendsRevolver
		spear:FollowParent(mod:GetEntityData(spear.Parent).FriendsRevolver)
		mod:GetEntityData(spear).FriendBayonetteGun = EntityPtr(gun)
		mod:GetEntityData(gun).FriendBayonetteSpear = EntityPtr(spear)
	end

	local gun = GetBayonetteGun(spear)
	if not gun then return end

	UpdateBayonette(spear, gun, false)
end, EffectVariant.SPEAR_OF_DESTINY)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_EFFECT_RENDER, CallbackPriority.IMPORTANT, function(_, spear)
	local gun = GetBayonetteGun(spear)
	if not gun then return end

	if not mod:GetEntityData(spear).BayonetteFlying and (not renderingBayonette or not gun.Visible) then
		return false
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_EFFECT_RENDER, CallbackPriority.LATE, function(_, spear)
	local gun = GetBayonetteGun(spear)
	if not gun then return end

	UpdateBayonette(spear, gun, true)
	return mod:GetSpriteFlippedAxisCorrectionOffset(spear:GetSprite(), true)
end)

mod:AddPriorityCallback(ModCallbacks.MC_POST_EFFECT_RENDER, CallbackPriority.IMPORTANT, function(_, knife)
	local gun = GetBayonetteGun(knife)
	if not gun then return end

	UpdateBayonette(knife, gun, false)
end)
