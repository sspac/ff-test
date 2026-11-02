local mod = FiendFolio
local flag = TearFlagsLib.RegisterTearFlag("PARALLEL_BOMB")
local shaderPath = "shaders/fiendfolio/coloroffset_parallel"



-- Set the bomb variant
function mod:SetParallelBombVariant(bomb)
	local var = bomb.Variant

	if mod:isCopperVariant(var) then
		bomb.Variant = mod.BOMB.PARALLEL_COPPER

	elseif mod:isReplaceableBombVariant(var) then
		bomb.Variant = mod.BOMB.PARALLEL
	end

	bomb:SetLoadCostumes(true)
end

-- Create the clone
function mod:CreateParallelBombClone(bomb)
	local data = mod:GetEntityData(bomb)

	if not data.ParallelBombParent and not data.IsFireworkExplosion then
		local pos = mod:GetMirroredPosition(bomb.Position)
		local clone = Game():Spawn(bomb.Type, bomb.Variant, pos, -bomb.Velocity, bomb.SpawnerEntity, bomb.SubType, bomb.InitSeed):ToBomb()
		mod:GetEntityData(clone).ParallelBombParent = bomb

		-- Set the shader
		mod.scheduleForUpdate(function()
			local sprite = clone:GetSprite()

			if TearFlagsLib.HasTearFlags(clone, mod.FriendBulletFlags.STEVEN) and sprite:HasCustomShader(shaderPath) then
				sprite:ClearCustomShader()
			else
				sprite:SetCustomShader(shaderPath)
			end
		end, 1, ModCallbacks.MC_PRE_RENDER)

		-- Set rocket variables
		clone:SetRocketAngle( bomb:GetRocketAngle() + 180 )
		clone:SetRocketSpeed( bomb:GetRocketSpeed() )

		-- Copy over some data
		clone.IsFetus = bomb.IsFetus
		clone.Flags = bomb.Flags
		clone.ExplosionDamage = bomb.ExplosionDamage
		clone.RadiusMultiplier = bomb.RadiusMultiplier
		clone:SetScale( bomb:GetScale() )
		clone.Color = bomb.Color

		-- Set TearFlagsLib stuff
		TearFlagsLib.AddTearFlags(clone, TearFlagsLib.GetTearFlags(bomb))
		TearFlagsLib.SetTearFlagParams(clone, nil, TearFlagsLib.GetTearFlagParams(bomb), true)
		TearFlagsLib.AddTearFlags(bomb, flag)
		TearFlagsLib.AddTearFlags(clone, flag)

		-- Poof
		local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, clone.Position, Vector.Zero, clone):GetSprite()
		effect.Color = clone.Color * Color(1,1,1, 0.5)
		effect.PlaybackSpeed = 1.5
		effect.Scale = Vector.One * clone:GetScale() * 0.75

		clone:Update()
		data.ParallelBombClone = clone
		return clone
	end
end



-- Only take effect whenever Ring Cap also would
function mod:PlaceParellelBombs(player, bomb)
	if player and player:HasCollectible(mod.ITEM.COLLECTIBLE.PARALLEL_BOMBS) then
		mod:SetParallelBombVariant(bomb)
		local clone = mod:CreateParallelBombClone(bomb)

		if clone then
			Isaac.RunCallback(ModCallbacks.MC_POST_PLAYER_USE_BOMB, player, clone)
		end
	end
end
mod:AddPriorityCollectibleCallback(ModCallbacks.MC_POST_PLAYER_USE_BOMB, CallbackPriority.LATE * 10, mod.ITEM.COLLECTIBLE.PARALLEL_BOMBS, mod.PlaceParellelBombs)

-- Except in the case of Dr. Fetus
function mod:FireParellelBombs(bomb)
	local player = bomb.SpawnerEntity and bomb.SpawnerEntity:ToPlayer()

	if player and player:HasCollectible(mod.ITEM.COLLECTIBLE.PARALLEL_BOMBS) then
		TearFlagsLib.AddTearFlags(bomb, flag)
		mod:SetParallelBombVariant(bomb)
		local clone = mod:CreateParallelBombClone(bomb)

		if clone then
			TearFlagsLib.AddTearFlags(clone, flag)
			Isaac.RunCallback(ModCallbacks.MC_POST_FIRE_BOMB, clone)
		end
	end
end
mod:AddPriorityCollectibleCallback(ModCallbacks.MC_POST_FIRE_BOMB, CallbackPriority.LATE * 10, mod.ITEM.COLLECTIBLE.PARALLEL_BOMBS, mod.FireParellelBombs)



-- Update the clone
function mod:UpdateParallelBombs(bomb)
	local parent = mod:GetEntityData(bomb).ParallelBombParent

	if parent then
		local parentExists = false

		if parent:Exists() then
			parentExists = true
			bomb:SetExplosionCountdown( parent:GetExplosionCountdown() )

			-- Mirror the parent's position
			bomb.Position = mod:GetMirroredPosition(parent.Position)
			bomb.Velocity = -parent.Velocity
			bomb:SetRocketAngle( parent:GetRocketAngle() + 180 )
			bomb:SetRocketSpeed( parent:GetRocketSpeed() )

			-- Copy height
			bomb.PositionOffset = Vector(parent.PositionOffset.X, parent.PositionOffset.Y)
			bomb:SetFallSpeed( parent:GetFallSpeed() )
			bomb:SetFallAcceleration( parent:GetFallAcceleration() )

			-- Copy sprite stuff
			bomb.Visible = parent.Visible

			local cloneSprite = bomb:GetSprite()
			local parentSprite = parent:GetSprite()
			cloneSprite:Play(parentSprite:GetAnimation(), true)
			cloneSprite:SetFrame(parentSprite:GetFrame())
		end

		-- Stay intangible
		bomb.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		bomb.GridCollisionClass = parentExists and EntityGridCollisionClass.GRIDCOLL_NONE or EntityGridCollisionClass.GRIDCOLL_WALLS
	end
end
mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, mod.UpdateParallelBombs)

-- Apply the shader to the explosion
function mod:ParallelBombExplosion(effect)
	if effect.SpawnerType == EntityType.ENTITY_BOMB then
		local spawner = effect.SpawnerEntity

		if spawner and spawner:GetSprite():HasCustomShader(shaderPath) then
			effect:GetSprite():SetCustomShader(shaderPath)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.ParallelBombExplosion, EffectVariant.BOMB_EXPLOSION)

-- Reduce clone damage (It's done like this because ExplosionDamage also affects the explosion radius)
function mod:ParallelBombDamage(entity, damageAmount)
	if entity and mod:GetEntityData(entity).ParallelBombParent then
		return { Damage = damageAmount / 2, }
	end
end



-- Pointless Future compatibility
function mod:SwapParallelBombs()
	for i, bomb in ipairs( Isaac.FindByType(EntityType.ENTITY_BOMB) ) do
		local parent = mod:GetEntityData(bomb).ParallelBombParent

		if parent and parent:Exists() then
			parent.Position = mod:GetMirroredPosition(parent.Position)
		end
	end
end
mod:AddCallback("POST_MANTIS_CLAP", mod.SwapParallelBombs)



-- Handle the Abyss Locusts
function mod:ParallelBombLocustUpdate(familiar)
	if familiar.Coins == 1 then
		local data = mod:GetEntityData(familiar)
		local parent = data.ParallelBombParent


		-- Update the clone
		if parent and parent:Exists() then
			local pos = mod:GetMirroredPosition(parent.Position, familiar.Player.Position)
			familiar.Velocity = pos - familiar.Position

			-- Copy state and collision
			familiar.State = parent.State
			familiar.FireCooldown = parent.FireCooldown
			familiar.EntityCollisionClass = parent.EntityCollisionClass
			familiar.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE


		-- Get the parent locust
		else
			local hasParent = false
			local others = Isaac.FindByType(familiar.Type, familiar.Variant, familiar.SubType)

			for i, other in pairs(others) do
				other = other:ToFamiliar()
				local otherData = mod:GetEntityData(other)

				-- Look for Locusts belonging to the same player and item but not the same subtype within the item
				if other.Coins == 0 and other.Player:GetPlayerIndex() == familiar.Player:GetPlayerIndex()
				and (not otherData.ParallelBombClone or not otherData.ParallelBombClone:Exists()) then
					data.ParallelBombParent = other
					otherData.ParallelBombClone = familiar

					familiar:RemoveFromOrbit()
					familiar:Update()

					hasParent = true
					break
				end
			end

			-- Failsafe
			if not hasParent then
				familiar:Remove()
			end
		end
	end
end
mod.ErflyLocustDict[mod.ITEM.COLLECTIBLE.PARALLEL_BOMBS] = { Update = mod.ParallelBombLocustUpdate, }