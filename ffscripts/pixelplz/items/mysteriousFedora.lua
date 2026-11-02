local mod = FiendFolio
local game = Game()
local id = mod.ITEM.COLLECTIBLE.MYSTERIOUS_FEDORA

local Settings = {
	SpawnChance = 20,
	SpawnDelay = 15,
	SpawnOffset = {80, 160},

	BaseAmmo = 6,
	IdleDuration = 20,
	ShotCooldown = 5,
	ShotSpeed = 20,
	Damage = 20,
	HeadLockDuration = 20,
	LeaveDelay = 10,

	HeldOffset = 12,
	BarrelOffset = Vector(25, 7),
}

mod.MysteriousStrangerState = {
	Idle 		 = 0,
	Shooting 	 = 1,
	Disappearing = 2,
}

local gunState = {
	ToIdle 		 = 0,
	Idle 		 = 1,
	Disappearing = 2,
}



-- Appear / disappear effects
local function teleportPoof(entity)
	mod:PlaySoundCool(nil, SoundEffect.SOUND_BLACK_POOF)

	for j = 1, 2 do
		local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, j, entity.Position, Vector.Zero, entity):GetSprite()
		poof.Color = Color(1,1,1, 1, 0,0,0, 0.2,0.2,0.2, 1)

		if j == 2 then
			poof.Scale = Vector.One * 0.9
			poof.Offset = Vector(0, -10)
		else
			poof.Scale = Vector.One * 0.8
		end
	end
end



-- Try to spawn the mysterious stranger for every player that has the item
local queuedWaveStrangers = false

function mod:TrySpawnMysteriousStrangers()
	local room = game:GetRoom()

	if not room:IsClear() and Isaac.CountEnemies() > 0 then
		-- Get the wave offset
		local level = game:GetLevel()
		local waveOffset = Ambush.GetCurrentWave()

		if game:IsGreedMode() and level:GetCurrentRoomIndex() == level:GetStartingRoomIndex() then
			waveOffset = level.GreedModeWave
		end

		-- Go through every player that has the item
		for i, player in pairs( PlayerManager.GetPlayers() ) do
			if player:HasCollectible(id) then
				local playerOffset = player:GetCollectibleRNG(id):GetSeed()
				local rng = RNG(room:GetSpawnSeed() + playerOffset)

				-- Offset the seed so different waves get different outcomes
				for j = 1, waveOffset do
					rng:Next()
				end

				if mod:Random(nil, nil, rng) <= Settings.SpawnChance / 100 then
					local func = function()
						if not room:IsClear() and Isaac.CountEnemies() > 0 then -- Don't spawn if the room was cleared during the delay
							local distance = mod:Random(Settings.SpawnOffset[1], Settings.SpawnOffset[2])
							local pos = player.Position + mod:RandomVector(distance)
							pos = room:FindFreePickupSpawnPosition(pos, 0, true)
							Isaac.Spawn(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.MYSTERIOUS_STRANGER, 0, pos, Vector.Zero, player)
						end
					end
					mod.scheduleForUpdate(func, Settings.SpawnDelay, ModCallbacks.MC_POST_UPDATE, true)
				end
			end
		end
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_NEW_ROOM, id, mod.TrySpawnMysteriousStrangers)

-- Wait for the spawn pentagrams before trying to spawn the strangers
function mod:MysteriousFedoraNewWave(effect)
	if not queuedWaveStrangers and effect.Variant == EffectVariant.SPAWN_PENTAGRAM then
		mod:TrySpawnMysteriousStrangers()
		queuedWaveStrangers = true

		local func = function()
			queuedWaveStrangers = false
		end
		mod.scheduleForUpdate(func, 0, ModCallbacks.MC_POST_UPDATE, true)
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, id, mod.MysteriousFedoraNewWave, EntityType.ENTITY_EFFECT)



-- Remove existing strangers when exiting a room
function mod:RemoveMysteriousStrangers()
	local strangers = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.MYSTERIOUS_STRANGER)

	for i, stranger in pairs(strangers) do
		if stranger.Child then
			stranger.Child:Remove()
		end
		stranger:Remove()
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_PRE_ROOM_EXIT, id, mod.RemoveMysteriousStrangers)
mod:AddCollectibleCallback(ModCallbacks.MC_PRE_GAME_EXIT, id, mod.RemoveMysteriousStrangers)





--[[ Stranger ]]--
function mod:MysteriousStrangerInit(familiar)
	familiar.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	familiar.FireCooldown = Settings.IdleDuration

	familiar:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	familiar:GetSprite():PlayOverlay("HeadDown", true)
	teleportPoof(familiar)

	-- Set the ammo
	local multi = familiar.Player and familiar.Player:GetCollectibleNum(id) or 1
	familiar.Coins = math.max(1, multi) * Settings.BaseAmmo
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.MysteriousStrangerInit, mod.ITEM.FAMILIAR.MYSTERIOUS_STRANGER)

function mod:MysteriousStrangerUpdate(familiar)
	local sprite = familiar:GetSprite()
	local data = mod:GetEntityData(familiar)

	familiar.Velocity = mod:StopLerp(familiar.Velocity)
	mod.QuickSetEntityGridPath(familiar, 900, true)


	-- Create the gun if it doesn't exist
	if not familiar.Child or not familiar.Child:ToEffect() then
		local gun = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.ITEM.FAMILIAR.MYSTERIOUS_STRANGER_GUN, 0, familiar.Position, Vector.Zero, familiar):ToEffect()
		gun.Parent = familiar
		familiar.Child = gun
	end

	local gun = familiar.Child:ToEffect()
	local gunSprite = gun:GetSprite()



	--[[ Appear delay ]]--
	if familiar.State == mod.MysteriousStrangerState.Idle then
		mod:LoopingAnim(sprite, "BodyIdle")
		mod:LoopingOverlay(sprite, "HeadDown")

		if familiar.FireCooldown <= 0 then
			familiar.State = mod.MysteriousStrangerState.Shooting
		else
			familiar.FireCooldown = familiar.FireCooldown - 1
		end



	--[[ Fucking shit up ]]--
	elseif familiar.State == mod.MysteriousStrangerState.Shooting then
		local shouldLeave = game:GetRoom():IsClear()

		-- Update the animations
		mod:LoopingAnim(sprite, "BodyIdle")

		if familiar.HeadFrameDelay <= 0 then
			mod:LoopingOverlay(sprite, "HeadDown")
			gun.State = gunState.Idle
		else
			familiar.HeadFrameDelay = familiar.HeadFrameDelay - 1
		end


		if familiar.FireCooldown <= 0 or shouldLeave then
			-- Leave if out of bullets or the room is cleared
			if familiar.Coins <= 0 or shouldLeave then
				familiar.State = mod.MysteriousStrangerState.Disappearing
				sprite:Play("Leave", true)
				sprite:RemoveOverlay()

				gun.State = gunState.Disappearing
				gunSprite:Play("BeginReload", true)


			else
				-- Get all valid targets
				local bestTargets = {}
				local backupTargets = {}

				for i, enemy in ipairs( Isaac.GetRoomEntities() ) do
					if enemy:IsActiveEnemy(false) and not enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
					and enemy:IsVulnerableEnemy() and not enemy:IsInvincible() and mod:IsTangible(enemy) and not enemy:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) then
						table.insert(backupTargets, enemy)

						-- Prioritize targets that haven't been shot yet
						if not data.UsedTargets or not data.UsedTargets[enemy.InitSeed] then
							table.insert(bestTargets, enemy)
						end
					end
				end

				-- Reset the tracker if all targets have been shot
				if #bestTargets <= 0 then
					data.UsedTargets = nil
				end


				-- Shoot a random target
				local targetsToUse = #bestTargets > 0 and bestTargets or backupTargets

				if #targetsToUse > 0 then
					familiar.Coins = familiar.Coins - 1
					familiar.FireCooldown = familiar.Coins <= 0 and Settings.LeaveDelay or Settings.ShotCooldown
					mod:PlaySoundCool(nil, mod.Sounds.MagnumShoot, 0.6)

					local target = mod:RandomIndex(targetsToUse)
					local targetVector = target.Position - familiar.Position
					local targetAngle = targetVector:GetAngleDegrees() % 360

					-- Create the shot tracker and the target to it
					if not data.UsedTargets then
						data.UsedTargets = {}
					end
					data.UsedTargets[target.InitSeed] = true


					-- Set the head direction
					local suffixes = { "Right", "Down", "Left", "Up", }
					local suffix = mod:GoRoundNumber(targetAngle / 90) % #suffixes
					sprite:PlayOverlay("Head" .. suffixes[suffix + 1], true)
					familiar.HeadFrameDelay = Settings.HeadLockDuration


					-- Shoot da boolet
					local bulletPos = target.Position + targetVector:Resized(-1)
					local velocity = targetVector:Resized(Settings.ShotSpeed)

					local bullet = Isaac.Spawn(EntityType.ENTITY_TEAR, mod.TEAR.M90_BULLET, 0, bulletPos, velocity, familiar):ToTear()
					bullet:SetInitSound(SoundEffect.SOUND_NULL)
					bullet.CollisionDamage = familiar:GetMultiplier() * Settings.Damage
					bullet:AddTearFlags(TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_PIERCING | TearFlags.TEAR_NO_GRID_DAMAGE | TearFlags.TEAR_EXTRA_GORE)
					bullet.Height = -16
					bullet:ForceCollide(target, true)
					bullet:Die()


					-- Update the gun
					gun.State = gunState.ToIdle
					gunSprite:Play("Shoot", true)
					gun.Rotation = targetAngle
					gun:Update()

					-- Get the barrel position
					local barrelLengthOffset = targetVector:Resized(Settings.BarrelOffset.X / 0.65)
					local barrelHeightOffset = Settings.BarrelOffset.Y - math.abs(gunSprite.Offset.X)
					local spriteOffset = Vector(0, gunSprite.Offset.Y - barrelHeightOffset) / 0.65
					local barrelPos = gun.Position + gun.PositionOffset + barrelLengthOffset + spriteOffset


					-- Create the bullet trail
					local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPRITE_TRAIL, 0, barrelPos, Vector.Zero, familiar):ToEffect()
					trail.Parent = bullet
					trail:SetRadii(0.15, 0.15)
					trail:GetSprite().Color = Color(0.75,0.5,0, 1)
					trail:Update()
					trail.Velocity = (bullet.Position + bullet.PositionOffset) - barrelPos


					-- Create the muzzle flash
					local flash = Isaac.Spawn(mod.FF.MuzzleFlash.ID, mod.FF.MuzzleFlash.Var, mod.FF.MuzzleFlash.Sub, barrelPos, Vector.Zero, gun):ToEffect()
					flash.Parent = gun
					flash.DepthOffset = 75

					local flashSprite = flash:GetSprite()
					flashSprite.Color = mod:ColorHSV(0.0, 0.0, 1.0, 1, 0.1, 1.0, 0.9)
					flashSprite.PlaybackSpeed = math.random(50, 150) / 100

					if targetAngle > 90 or targetAngle < -90 then
						targetAngle = (-targetAngle) % 360
						flash:GetSprite().FlipY = true
					end
					flashSprite.Rotation = targetAngle
				end
			end

		else
			familiar.FireCooldown = familiar.FireCooldown - 1
		end



	--[[ Leaving ]]--
	elseif familiar.State == mod.MysteriousStrangerState.Disappearing then
		if sprite:IsEventTriggered("Sound") then
			mod:PlaySoundCool(nil, SoundEffect.SOUND_FETUS_JUMP, 0.75)

		elseif sprite:IsFinished() then
			teleportPoof(familiar)
			familiar:Remove()

			-- Extra pickup
			local player = familiar.Player

			local pickups = {
				{ Current = player:GetNumBombs(), Variant = PickupVariant.PICKUP_BOMB, },
				{ Current = player:GetNumCoins(), Variant = PickupVariant.PICKUP_COIN, },
				{ Current = player:GetNumKeys(),  Variant = PickupVariant.PICKUP_KEY,  },
			}

			-- Get the pickup type the player has the least of
			local sortFunc = function(k1, k2)
				return k1.Current < k2.Current
			end
			table.sort(pickups, sortFunc)

			-- Give one of that pickup type
			local velocity = EntityPickup.GetRandomPickupVelocity(familiar.Position)
			Isaac.Spawn(EntityType.ENTITY_PICKUP, pickups[1].Variant, 1, familiar.Position, velocity, familiar)
			mod:PlaySoundCool(nil, SoundEffect.SOUND_FETUS_LAND, 0.75, 1.1)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.MysteriousStrangerUpdate, mod.ITEM.FAMILIAR.MYSTERIOUS_STRANGER)





--[[ Gun ]]--
function mod:MysteriousStrangerGunInit(effect)
	effect.SpriteOffset = Vector(0, -8)
	effect:AddEntityFlags(EntityFlag.FLAG_DONT_OVERWRITE)
	effect.DepthOffset = 5

	effect.Rotation = 90 + mod:RandomSign() * 90
	effect.TargetPosition = Vector(1, 0)
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.MysteriousStrangerGunInit, mod.ITEM.FAMILIAR.MYSTERIOUS_STRANGER_GUN)

function mod:MysteriousStrangerGunUpdate(effect)
	local sprite = effect:GetSprite()
	local owner = effect.Parent and effect.Parent:ToFamiliar()


	if owner and owner:Exists() then
		-- Appearing / pew pew
		if effect.State == gunState.ToIdle then
			if sprite:IsEventTriggered("Sound") then
				mod:PlaySoundCool(nil, mod.Sounds.RevolverReloadFinish, 0.5)
			end

			if sprite:IsFinished() then
				sprite:Play("Idle", true)
			end


		-- Idle / Disappearing
		elseif effect.State == gunState.Idle or effect.State == gunState.Disappearing then
			local targetAngle = 90 + mod:GetSign(sprite.FlipX) * 90
			local rotationSpeed = mod:GetAngleDifferenceDead(targetAngle, effect.Rotation) * 0.15
			effect.Rotation = (effect.Rotation + rotationSpeed) % 360

			-- Disappearing
			if effect.State == gunState.Disappearing then
				effect.TargetPosition.X = mod:Lerp(effect.TargetPosition.X, 0, 0.25)

				if sprite:IsFinished() then
					effect.Visible = false
				end
			end
		end


		-- Get the held offset
		local sizeOffset = owner.Size * mod:Lerp(owner.SizeMulti.X, owner.SizeMulti.Y, 0.5)
		local horizontalOffset = effect.TargetPosition.X * (Settings.HeldOffset + sizeOffset)

		-- Poop from a butt
		if effect.Rotation > 0 and effect.Rotation < 180 then
			local real = (90 - math.abs(90 - effect.Rotation)) / 90
			horizontalOffset = horizontalOffset - horizontalOffset * 0.25 * real
		end
		local heldOffset = Vector(horizontalOffset, 0):Rotated(effect.Rotation)


		-- Set the position
		effect.Position = owner.Position + heldOffset
		effect.Velocity = Vector.Zero
		effect.PositionOffset = owner.PositionOffset


		-- Set the rotation
		sprite.Rotation = effect.Rotation

		if effect.Rotation > 90 and effect.Rotation <= 270 then
			sprite.FlipX = true
			sprite.Rotation = 180 - effect.Rotation
		else
			sprite.FlipX = false
		end


		-- Offset to make the barrel line up better with the bullets
		local upDownFunkYouUp = math.abs(effect.Rotation) % 180
		local difference = mod:GetAngleDifferenceDead(upDownFunkYouUp, 90)
		local upDownMulti = (90 - math.abs(difference)) / 90
		local posOffsetX = upDownMulti * Settings.BarrelOffset.Y
		sprite.Offset.X = mod:GetSign(sprite.FlipX) * mod:GetSign(effect.Rotation < 180) * posOffsetX


		-- Set the color
		effect.Color = owner.Color
		sprite.Color = owner:GetSprite().Color

	else
		effect:Remove()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.MysteriousStrangerGunUpdate, mod.ITEM.FAMILIAR.MYSTERIOUS_STRANGER_GUN)

function mod:MysteriousStrangerGunRender(effect, offset)
	local sprite = effect:GetSprite()
	local renderMode = game:GetRoom():GetRenderMode()

	-- Don't render its reflection
	if renderMode == RenderMode.RENDER_WATER_REFRACT or renderMode == RenderMode.RENDER_WATER_REFLECT then
		return false

	-- IDK if this is really needed but Friend's guns do it too
	elseif sprite.FlipX or sprite.FlipY then
		return mod:GetSpriteFlippedAxisCorrectionOffset(sprite, true)
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_EFFECT_RENDER, mod.MysteriousStrangerGunRender, mod.ITEM.FAMILIAR.MYSTERIOUS_STRANGER_GUN)