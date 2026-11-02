local mod = FiendFolio

local Settings = {
	PlayerOffset = Vector(0, -20),
	StartingDistance = 60,
	MoveSpeed = 7.5,

	DamageMulti = 0.1,
	DamageBonus = 0.5,
	CarBatteryMulti = 2,

	Distraction = {
		SpeedThreshold = 0.4,
		Interval = 15,
		Range = 3 * 40,
		Duration = 30,
		MaxBossDuration = 5 * 30,
		BossCooldown = 5 * 30,
	},
	Wisps = {
		Count = 3,
		Layer = 6,
		AdjustDuration = 10,
		DamageMulti = 0.1,
		DamageBonus = 1,
	},
	JudasBirthright = {
		Duration = 2,
		Damage = 0.6,
	},
	Electrum = {
		Interval = 20,
		Range = 3 * 40,
		DamageMulti = 0.1,
		DamageBonus = 1,
	},
}



function mod:UseLaserPointer(id, rng, player, flags, slot, varData)
	local data = mod:GetEntityData(player)

	-- Create the laser if it doesn't exist
	if not data.LaserPointer or not data.LaserPointer.Laser or not data.LaserPointer.Laser:Exists() then
		local laser = EntityLaser.ShootAngle(2, player.Position, 0, -1, Vector.Zero, player)
		mod:GetEntityData(laser).LaserPointer = true
		laser.ParentOffset = Settings.PlayerOffset
		laser.Mass = 0

		-- Get the starting position
		local vector = mod:GetRoomCenter() - player.Position
		local startPos = player.Position + vector:Resized(Settings.StartingDistance)

		-- Create the tracker
		data.LaserPointer = {
			Laser = laser,
			Position = startPos,
			Velocity = Vector.Zero,
		}

		mod:PlaySoundCool(nil, SoundEffect.SOUND_BUTTON_PRESS, 1, 1.2)
	end

	-- Hold the item
	player:AnimateCollectible(mod.ITEM.COLLECTIBLE.LASER_POINTER, "LiftItem", "PlayerPickup")
	player:SetItemState(mod.ITEM.COLLECTIBLE.LASER_POINTER)
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.UseLaserPointer, mod.ITEM.COLLECTIBLE.LASER_POINTER)



-- Remove the laser and reset the item state
function mod:RemoveLaserPointer(player)
	local data = mod:GetEntityData(player)
	local laserPointer = data.LaserPointer

	-- Remove the laser
	if laserPointer and laserPointer.Laser and laserPointer.Laser:Exists() then
		laserPointer.Laser:Remove()
		mod:PlaySoundCool(nil, SoundEffect.SOUND_BUTTON_PRESS, 1, 1.1)
	end

	data.LaserPointer = nil

	-- Reset the item state
	if player:GetItemState() == mod.ITEM.COLLECTIBLE.LASER_POINTER then
		player:ResetItemState()
		player:AnimateCollectible(mod.ITEM.COLLECTIBLE.LASER_POINTER, "HideItem", "PlayerPickup")
		mod:playerCheckM(player, mod.ITEM.COLLECTIBLE.LASER_POINTER)
	end
end

-- Remove the laser alongside the item
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.RemoveLaserPointer, mod.ITEM.COLLECTIBLE.LASER_POINTER)



-- Update the laser
function mod:UpdateLaserPointer(player)
	local data = mod:GetEntityData(player)
	local laserPointer = data.LaserPointer

	if laserPointer then
		local laser = laserPointer.Laser
		local velocity = Vector.Zero


		-- Handle held controls
		if player:GetItemState() == mod.ITEM.COLLECTIBLE.LASER_POINTER then
			-- Remove the laser
			if Input.IsActionTriggered(ButtonAction.ACTION_DROP, player.ControllerIndex) then
				mod:RemoveLaserPointer(player)

			-- Mouse controls
			elseif Options.MouseControl and Input.IsMouseBtnPressed(Mouse.MOUSE_BUTTON_LEFT) then
				velocity = Input.GetMousePosition(true) - laserPointer.Position

			-- Shooting controls
			else
				for i = ButtonAction.ACTION_SHOOTLEFT, ButtonAction.ACTION_SHOOTDOWN do
					local multi = mod:GetSign(i % 2)
					local value = Input.GetActionValue(i, player.ControllerIndex)
					local direction = i <= ButtonAction.ACTION_SHOOTRIGHT and Vector(1, 0) or Vector(0, 1)
					velocity = velocity + (direction * value * multi)
				end
			end

			-- Reverse left and right in the mirror world
			if Game():GetRoom():IsMirrorWorld() then
				velocity = velocity * Vector(-1, 1)
			end

		else
			mod:playerCheckM(player, mod.ITEM.COLLECTIBLE.LASER_POINTER)
		end


		if laser and laser:Exists() then
			if not laser.Parent then
				laser.Parent = player
			end

			-- Handle the movement
			laserPointer.Velocity = mod:Lerp(laserPointer.Velocity, velocity:Resized(Settings.MoveSpeed), 0.25)
			laserPointer.Position = laserPointer.Position + laserPointer.Velocity
			laserPointer.Position = Game():GetRoom():GetClampedPosition(laserPointer.Position, 1)


			-- Set the angle and length
			local startPos = laser.Parent.Position + laser.ParentOffset
			local vector = (laserPointer.Position - startPos)
			laser.Angle = vector:GetAngleDegrees()

			local length = math.max(1, vector:Length() - 18)
			laser:SetMaxDistance(length)


			-- Set the damage
			local hasCarBattery = player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY)
			local synergyMulti = hasCarBattery and Settings.CarBatteryMulti or 1
			laser.CollisionDamage = (player.Damage * Settings.DamageMulti) + (Settings.DamageBonus * synergyMulti)


			-- Zap nearby enemies with Electrum
			if player:HasTrinket(mod.ITEM.ROCK.ELECTRUM) then
				local currentFrame = Game():GetFrameCount()

				if not laserPointer.ElectrumFrame or currentFrame >= laserPointer.ElectrumFrame + Settings.Electrum.Interval then
					local rng = laser:GetDropRNG()
					local electrumMulti = player:GetTrinketMultiplier(mod.ITEM.ROCK.ELECTRUM)
					local damage = (player.Damage * Settings.Electrum.DamageMulti) + (Settings.Electrum.DamageBonus * electrumMulti)
					mod:alternateElectrumShock(player, rng, damage, laserPointer.Position, 1, nil, nil, electrumMulti, nil, Settings.Electrum.Range)
					laserPointer.ElectrumFrame = currentFrame
				end
			end


			if laser.Child then
				-- Create the Book of Virtues wisps
				if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) and not laserPointer.Wisps then
					laserPointer.Wisps = {}
					mod:PlaySoundCool(nil, SoundEffect.SOUND_CANDLE_LIGHT)

					for i = 1, Settings.Wisps.Count do
						local wisp = player:AddWisp(mod.ITEM.COLLECTIBLE.LASER_POINTER, laser.Child.Position, false, true)
						wisp.Parent = laser.Child
						wisp:AddToOrbit(Settings.Wisps.Layer)
						wisp:Update()
						table.insert(laserPointer.Wisps, wisp)
					end
				end


				-- Distract nearby enemies
				if laser:IsFrame(Settings.Distraction.Interval, 0) and laserPointer.Velocity:Length() >= Settings.Distraction.SpeedThreshold then
					local enemies = Isaac.FindInRadius(laserPointer.Position, Settings.Distraction.Range, EntityPartition.ENEMY)

					for i, enemy in pairs(enemies) do
						local npc = enemy:ToNPC() -- Gotta make sure it's not a bomb :-)

						if npc and npc:IsActiveEnemy(false) then
							local distract = true

							-- Check the limit for bosses
							if npc:IsBoss() and not npc:HasEntityFlags(EntityFlag.FLAG_CHARM) then
								local npcData = mod:GetEntityData(npc)
								local distractionData = npcData.LaserPointer

								-- Create the tracker if it doesn't exist
								if not distractionData then
									npcData.LaserPointer = {
										Focused = false,
										Curiosity = Settings.Distraction.MaxBossDuration,
										ResetCooldown = Settings.Distraction.BossCooldown,
									}
									distractionData = npcData.LaserPointer

								-- Update the distraction limit
								elseif not distractionData.Focused then
									distractionData.Curiosity = distractionData.Curiosity - Settings.Distraction.Interval
								end

								distract = not distractionData.Focused
							end

							-- Can be distracted
							if distract then
								npc:TryForceTarget(laser.Child, Settings.Distraction.Duration)
							end
						end
					end
				end
			end
		end
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.ITEM.COLLECTIBLE.LASER_POINTER, mod.UpdateLaserPointer)



-- Handle the distraction limit for bosses
function mod:LaserPointerDistractionLimit(entity)
	local data = mod:GetEntityData(entity)
	local laserPointer = data.LaserPointer

	if laserPointer then
		-- Locked in
		if laserPointer.Focused then
			laserPointer.ResetCooldown = laserPointer.ResetCooldown - 1

			if laserPointer.ResetCooldown <= 0 then
				data.LaserPointer = nil
			end

		-- Lock in after being distracted for long enough
		elseif laserPointer.Curiosity <= 0 then
			laserPointer.Focused = true
		end
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_NPC_UPDATE, mod.ITEM.COLLECTIBLE.LASER_POINTER, mod.LaserPointerDistractionLimit)





-- Handle the Book of Virtues wisps
function mod:LaserPointerWispUpdate(familiar)
	if familiar.SubType == mod.ITEM.COLLECTIBLE.LASER_POINTER then
		if familiar.Parent and familiar.Parent:Exists() then
			local orbitPos = familiar:GetOrbitPosition(Vector.Zero)

			-- Smoothly move to the orbit position after spawning
			if familiar.FrameCount < Settings.Wisps.AdjustDuration then
				local multi = familiar.FrameCount / Settings.Wisps.AdjustDuration
				orbitPos = orbitPos * multi
			end

			-- Keep up with the laser
			local targetPos = familiar.Parent.Position + orbitPos
			familiar.Velocity = targetPos - familiar.Position


			-- Set the damage
			if familiar.Player then
				local player = familiar.Player
				familiar.CollisionDamage = (player.Damage * Settings.Wisps.DamageMulti) + (Settings.Wisps.DamageBonus * familiar:GetMultiplier())
				familiar.Mass = 0
			end


		-- Get removed if the laser is gone
		elseif Game():GetRoom():GetFrameCount() <= 0 then
			familiar:Remove()
		else
			familiar:Kill()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.LaserPointerWispUpdate, FamiliarVariant.WISP)

-- Make them invincible
function mod:LaserPointerWispDMG(entity, damageAmount, damageFlags, damageSource, damageCountdownFrames)
	if entity.Variant == FamiliarVariant.WISP and entity.SubType == mod.ITEM.COLLECTIBLE.LASER_POINTER then
		return false
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.LaserPointerWispDMG, EntityType.ENTITY_FAMILIAR)





-- Increase damage for every enemy in the laser with Judas' Birthright
function mod:LaserPointerEnemyCollision(laser, target)
	if mod:GetEntityData(laser).LaserPointer and target:ToNPC() and target:IsActiveEnemy(false) then
		local player = laser.Parent and laser.Parent:ToPlayer()

		if player and mod:playerIsBelialMode(player) then
			player:AddNullItemEffect(mod.ITEM.NULL.JUDAS_LASER_POINTER, false, Settings.JudasBirthright.Duration, false)
		end
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_LASER_COLLISION, mod.ITEM.COLLECTIBLE.LASER_POINTER, mod.LaserPointerEnemyCollision, 2)

-- Add the damage bonus
function mod:LaserPointerCache(player, cacheFlags)
	local count = player:GetEffects():GetNullEffectNum(mod.ITEM.NULL.JUDAS_LASER_POINTER)
	local bonus = count * Settings.JudasBirthright.Damage
	player.Damage = player.Damage + bonus
end

local config = Isaac.GetItemConfig():GetNullItem(mod.ITEM.NULL.JUDAS_LASER_POINTER)
mod:AddPlayerTempEffectCallback(ModCallbacks.MC_EVALUATE_CACHE, config, mod.LaserPointerCache, CacheFlag.CACHE_DAMAGE)