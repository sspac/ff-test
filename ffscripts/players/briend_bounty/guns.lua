local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local states = mod.BountyGunData.States
local gfxPath = "gfx/effects/guns/"



-- Create a tracker for the given gun type
---@param gunType BountyGunTypes
---@return table
function mod:CreateBountyGunTracker(gunType)
	local gunTypeData = mod:GetBountyGunData(gunType)

	return {
		Type = gunType,
		Ammo = gunTypeData.Ammo,
		FireCooldown = mod:Random(gunTypeData.FireCooldown.Min, gunTypeData.FireCooldown.Max), -- Delay before it can start shooting 
		BulletDelay = 0, -- Delay between each shot if the gun is automatic
		Burst = 0, -- The amount of shots left in the current attack if burst firing
		ReloadDelay = 0, -- Delay between each inserted ammo
		ReloadOffset = 1, -- Multiplies the held offset, decreases while reloading
	}
end

-- Spawn a bounty gun with the given type
---@param owner Entity
---@param gunType BountyGunTypes
---@param side? integer Should be either `1` or `-1`! Affects which side of the owner the gun should start on.
---@return EntityEffect?
function mod:CreateBountyGun(owner, gunType, side)
	local gunTypeData = mod:GetBountyGunData(gunType)
	local gun = Isaac.Spawn(mod.FF.BountyGun.ID, mod.FF.BountyGun.Var, gunType, owner.Position, Vector.Zero, owner):ToEffect()
	gun.Parent = owner

	-- Set the starting side
	side = side or mod:RandomSign()
	gun.Rotation = 90 + (side * 90)

	-- Set the sprite
	local sprite = gun:GetSprite()

	if gunTypeData.ReplaceAnim then
		sprite:Load(gfxPath .. gunTypeData.ReplaceAnim .. ".anm2", true)
	end
	if gunTypeData.ReplaceSprite then
		sprite:ReplaceSpritesheet(0, gfxPath .. gunTypeData.ReplaceSprite .. ".png", true)
	end

	-- Start disabled if the owner is intangible
	if not mod:IsTangible(owner) then
		gun.State = states.Disabled
		gun.Visible = false

	-- Don't do the draw animation when Delirium transforms
	elseif owner:ToDelirium() then
		sprite:Stop()
	else
		sprite:Play("ReloadFinish", true)
		mod:PlayBountyGunSound(gunType, "Equip")
	end

	return gun
end



-- Play the given sound of a bounty gun
---@param gunType BountyGunTypes
---@param sound string
function mod:PlayBountyGunSound(gunType, sound)
	local gunTypeData = mod:GetBountyGunData(gunType)
	sound = gunTypeData.Sounds[sound]

	if sound then
		local volume = mod:Random(math.floor(sound.VolMin * 100), math.floor(sound.VolMax * 100)) / 100
		local pitch = mod:Random(math.floor(sound.PitchMin * 100), math.floor(sound.PitchMax * 100)) / 100
		sfx:Play(sound.Id, volume, 0, false, pitch)
	end
end



-- Spawn a muzzle flash for a bounty gun
---@param gun Entity
---@param pos Vector
---@param height number
---@param angle number
function mod:SpawnBountyMuzzleFlash(gun, pos, angle)
	local gunTypeData = mod:GetBountyGunData(gun.SubType)

	if not gunTypeData.NoMuzzle then
		local flash = Isaac.Spawn(mod.FF.MuzzleFlash.ID, mod.FF.MuzzleFlash.Var, mod.FF.MuzzleFlash.Sub, pos, Vector.Zero, gun):ToEffect()
		flash.Parent = gun
		flash.DepthOffset = 75

		-- Set the sprite stuff
		local flashSprite = flash:GetSprite()
		flashSprite.Color = gunTypeData.MuzzleColor
		flashSprite.Scale = Vector.One * gunTypeData.MuzzleScale
		flashSprite.PlaybackSpeed = math.random(50, 150) / 100

		-- Set the rotation
		if angle > 90 or angle < -90 then
			angle = (-angle) % 360
			flash:GetSprite().FlipY = true
		end
		flashSprite.Rotation = angle
	end
end



-- Spawn a casing for a bounty gun
---@param gun Entity
---@param owner Entity
function mod:SpawnBountyCasing(gun, owner)
	local gunTypeData = mod:GetBountyGunData(gun.SubType)

	if gunTypeData.Casing ~= "None" and gun.Visible then
		local rng = gun:GetDropRNG()

		-- Get the velocity
		local angle = owner.Velocity:GetAngleDegrees()
		local speed = owner.Velocity:Length() * 1.2

		if speed < 1 then
			angle = mod:RandomInt(0, 359, rng)
		else
			angle = angle + mod:RandomInt(-50, 50, rng)
		end

		speed = mod:ClampNumber(speed, 1, 6)
		local velocity = Vector.FromAngle(angle):Resized(speed)


		local case = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.FF.FriendCasing.Var, mod.FF.FriendCasing.Sub, gun.Position, velocity, owner):ToEffect()
		local data = mod:GetEntityData(case)

		case:GetSprite():Play(gunTypeData.Casing, true)
		case.SpriteScale = Vector(0.7, 0.5)
		case.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS


		-- bruh
		if game:GetRoom():GetType() ~= RoomType.ROOM_DUNGEON then
			data.launchedEnemyInfo = {
				zVel = -5, height = -2,
				landFunc = function()
					sfx:Play(mod.Sounds.D2Toss, 0.06, 0, false, mod:RandomInt(95, 115, rng) / 100)
					case.SpriteOffset = Vector(0, -2)

					data.launchedEnemyInfo = {
						zVel = -2.5, height = -2,
						landFunc = function()
							sfx:Play(mod.Sounds.D2Toss, 0.04, 0, false, mod:RandomInt(130, 145, rng) / 100)
							case.SpriteOffset = Vector(0, -2)

							data.launchedEnemyInfo = {
								zVel = -1, height = -2,
								landFunc = function()
									sfx:Play(mod.Sounds.D2Toss, 0.01, 0, false, mod:RandomInt(160, 170, rng) / 100)
									data.FinishedBouncing = true
								end
							}
						end
					}
				end
			}
		end
	end
end



-- Check if the given entity can have an Eternal Revolver transferred to it
---@param entity Entity
---@return boolean
function mod:CanGetEternalRevolver(entity)
	if entity:Exists() and mod:IsValidBountyEnemy(entity, true) then
		local targetData = mod:GetEntityData(entity)

		-- Doesn't have more than 1 gun
		return not targetData.GunslingerData or not targetData.GunslingerData.Guns
		or #targetData.GunslingerData.Guns <= 1
	end
	return false
end

-- Get the list of valid entities Eternal Revolvers can transfer to
---@return table
function mod:GetEternalRevolverTargets()
	local highPriority = {}
	local mediumPriority = {}
	local lowPriority = {}

	-- Find all valid enemies to transfer to
	for i, entity in pairs( Isaac.GetRoomEntities() ) do
		if entity:Exists() and mod:IsValidBountyEnemy(entity, true) then
			local targetData = mod:GetEntityData(entity)

			-- Doesn't have any guns
			if not targetData.GunslingerData
			or not targetData.GunslingerData.Guns or #targetData.GunslingerData.Guns <= 0 then
				table.insert(highPriority, entity)

			-- Boss / enemy with only 1 gun
			elseif #targetData.GunslingerData.Guns == 1 then
				local priority = entity:IsBoss() and mediumPriority or lowPriority
				table.insert(priority, entity)
			end
		end
	end

	-- Choose the highest priority list
	local tableToUse = lowPriority

	if #highPriority > 0 then
		tableToUse = highPriority

	elseif #mediumPriority > 0 then
		tableToUse = mediumPriority
	end

	return tableToUse
end



-- Check if a gun should be dropped as a pickup
---@param owner? Entity
---@return boolean
function mod:ShouldDropBountyGun(owner)
	local fromDelirium = owner and owner:ToDelirium()

	if PlayerManager.AnyPlayerTypeHasBirthright(mod.PLAYER.BRIEND) and not fromDelirium then
		local player = PlayerManager.FirstBirthrightOwner(mod.PLAYER.BRIEND)
		local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
		return mod:Random(nil, nil, rng) <= mod.BriendBirthrightData.DropChance / 100
	end

	return false
end





--[[ Update the owner ]]--
function mod:QueueGunslingerUpdate(entity)
	local data = mod:GetEntityData(entity)

	if data.GunslingerData then
		data = data.GunslingerData

		-- Create the tracker if it doesn't exist
		if not data.Entity then
			data.Entity = {
				LastUpdateFrame = -1,
				ForgetTime = 0,
			}
		end


		-- Update the gun tracker
		if data.Guns then
			local dualWielding = #data.Guns >= 2

			for i, gunData in pairs(data.Guns) do
				local modulo = (i - 1) % 2
				local sign = mod:GetSign(modulo)

				-- Create the gun entity if it doesn't exist
				if not gunData.Entity or not gunData.Entity:Exists() then
					local startingSide = dualWielding and sign
					local gun = mod:CreateBountyGun(entity, gunData.Type, startingSide)
					gunData.Entity = gun
				end

				-- Assign the tracker to it
				mod:GetEntityData(gunData.Entity).GunTracker = gunData

				-- Set the side to use
				if dualWielding then
					gunData.Side = sign == -1 and "Left" or "Right"
				elseif gunData.Side then
					gunData.Side = nil
				end

				-- Flag the entity's guns to be updated
				-- (This way they won't act on their own if the entity is eg. petrified)
				gunData.Update = true
			end
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_NPC_UPDATE, CallbackPriority.IMPORTANT * 1000, mod.QueueGunslingerUpdate)

-- Update data that is shared between every gun
function mod:UpdateGunslinger(entity)
	local data = mod:GetEntityData(entity)
	data = data.GunslingerData.Entity

	local target = entity:GetPlayerTarget()
	local confused = mod:isConfuse(entity)
	local room = game:GetRoom()


	-- Check if the target is in range
	local sizeOffset = entity.Size * mod:Lerp(entity.SizeMulti.X, entity.SizeMulti.Y, 0.5)
	local startPos = entity.Position + (target.Position - entity.Position):Resized(sizeOffset)
	local inRange = target.Position:Distance(entity.Position) <= mod.BountyGunData.DetectionRange

	-- Check if there is line of sight to the target
	local clampedTargetPos = room:GetClampedPosition(target.Position, target.Size + 5)
	local hasLineOfSight = room:CheckLine(startPos, clampedTargetPos, LineCheckMode.PROJECTILE)


	-- Get the position to aim at
	local targetVisible = inRange and hasLineOfSight
	local aimVector = entity.Velocity
	local targetPos

	-- Aim at the target if it's visible
	if targetVisible and not confused then
		targetPos = target.Position
		data.LastTargetPos = targetPos
		data.ForgetTime = mod.BountyGunData.ForgetTime

	else
		data.ForgetTime = math.max(0, data.ForgetTime - 1)

		-- Aim at the last seen location of the target
		if data.LastTargetPos then
			if data.ForgetTime <= 0 or confused then
				data.LastTargetPos = nil
			else
				targetPos = data.LastTargetPos
			end
		end
	end

	-- Store the aim direction
	if targetPos or aimVector:Length() > 0.1 then
		if targetPos then
			aimVector = targetPos - entity.Position
		end
		data.AimAngle = aimVector:GetAngleDegrees()
	end


	data.IsTangible = data.IgnoreTangibility or (mod:IsTangible(entity) and not data.ForceDisable)
	data.IsConfused = confused
	data.IsTargetVisible = targetVisible
	data.LastUpdateFrame = entity.FrameCount
end





--[[ Enemy gun ]]--
function mod:BountyGunInit(effect)
	effect.SpriteOffset = Vector(0, -8)
	effect:AddEntityFlags(EntityFlag.FLAG_DONT_OVERWRITE)
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.BountyGunInit, mod.FF.BountyGun.Var)

function mod:BountyGunUpdate(effect)
	local sprite = effect:GetSprite()
	local gunTypeData = mod:GetBountyGunData(effect.SubType)
	local myData = mod:GetEntityData(effect).GunTracker
	local owner = effect.Parent and effect.Parent:ToNPC()


	--[[ Owner-dependant update ]]--
	if owner and owner:Exists() then
		local ownerData = mod:GetEntityData(owner).GunslingerData

		if not owner:IsDead() and ownerData and ownerData.Entity
		and myData and myData.Update then
			myData.Update = false

			-- Update shared owner data
			if ownerData.Entity.LastUpdateFrame ~= owner.FrameCount then
				mod:UpdateGunslinger(owner)
			end


			-- Get the current aim angle
			local targetAngle = ownerData.Entity.AimAngle or effect.Rotation

			if effect.State ~= states.Appear then
				local targetPos = ownerData.Entity.LastTargetPos

				if myData.Side and targetPos then
					targetAngle = (targetPos - effect.Position):GetAngleDegrees()
				end

				-- Rotate to the target angle
				local shootingMulti = (effect.State == states.Shooting and gunTypeData.Automatic) and gunTypeData.ShootingRotationMulti or 1
				local rotationSpeed = mod:GetAngleDifferenceDead(targetAngle, effect.Rotation) * gunTypeData.RotationLerp * shootingMulti
				local maxSpeed = gunTypeData.MaxRotationSpeed * shootingMulti
				rotationSpeed = mod:ClampNumber(rotationSpeed, -maxSpeed, maxSpeed)
				effect.Rotation = (effect.Rotation + rotationSpeed) % 360
			end


			-- Re-enable the gun if tangible
			if ownerData.Entity.IsTangible then
				if effect.State == states.Disabled then
					effect.Visible = true
					effect.State = states.ToIdle
					sprite:Play("Appear", true)
				end

			-- Disable the gun if intangible
			elseif effect.State ~= states.Disable and effect.State ~= states.Disabled then
				effect.State = states.Disable
				sprite:Play("Disappear", true)
			end



			--[[ Appear / transition to idle ]]--
			if effect.State == states.Appear or effect.State == states.ToIdle then
				if sprite:IsFinished() then
					effect.State = states.Idle
				end

			--[[ Disable ]]--
			elseif effect.State == states.Disable then
				if sprite:IsFinished() then
					effect.State = states.Disabled
					effect.Visible = false
				end
			end


			--[[ Idle ]]--
			if effect.State == states.Idle then
				local shouldReload = false
				local shouldShoot = false

				myData.FireCooldown = math.max(0, myData.FireCooldown - 1)
				mod:LoopingAnim(sprite, "Idle")


				-- Reload if empty
				if myData.Ammo <= 0 then
					shouldReload = true

				-- Shoot if aiming at the target
				elseif ownerData.Entity.IsTargetVisible or ownerData.Entity.IsConfused then
					local angleLimit = (gunTypeData.ProjectileCount / 2 - 0.5) * gunTypeData.SpreadOffset
					angleLimit = math.max(angleLimit, mod.BountyGunData.FireAngleLimit)

					local angleDifference = mod:GetAngleDifferenceDead(effect.Rotation, targetAngle)
					local meetsAngleLimit = math.abs(angleDifference) <= angleLimit
					shouldShoot = myData.FireCooldown <= 0 and (ownerData.Entity.IsConfused or meetsAngleLimit)

				-- Reload if the target is out of sight
				elseif myData.Ammo < math.floor(gunTypeData.Ammo / 2) then
					shouldReload = ownerData.Entity.ForgetTime <= 0
				end


				-- Reload
				if shouldReload then
					effect.State = states.ReloadStart
					sprite:Play("BeginReload", true)
					mod:PlayBountyGunSound(effect.SubType, "ReloadStart")
					myData.FireCooldown = mod:Random(gunTypeData.FireCooldown.Min, gunTypeData.FireCooldown.Max)

				-- Shoot
				elseif shouldShoot
				and (effect.PositionOffset.Y + gunTypeData.ProjectileHeight) >= -50 -- If not too high up
				and effect.Color.A >= mod.BountyGunData.MinAlpha and sprite.Color.A >= mod.BountyGunData.MinAlpha then -- If visible enough
					effect.State = states.Shooting
					myData.BulletDelay = 0
					myData.FireCooldown = mod.BountyGunData.ReappearCooldown
					myData.Burst = gunTypeData.Burst
				end
			end


			--[[ Pew pew ]]--
			if effect.State == states.Shooting then
				myData.BulletDelay = math.max(0, myData.BulletDelay - 1)

				if not sprite:IsPlaying("Shoot") then
					local anim = sprite:GetAnimationData("ShootLoop") and "ShootLoop" or "Idle"
					mod:LoopingAnim(sprite, anim)
				end

				if myData.BulletDelay <= 0 then
					sprite:Play("Shoot", true)
					mod:PlayBountyGunSound(effect.SubType, "Shoot")

					-- Update the ammo count
					myData.Ammo = math.max(0, myData.Ammo - 1)

					if myData.Burst then
						myData.Burst = math.max(0, myData.Burst - 1)
					end


					-- Get the barrel position
					local direction = Vector.FromAngle(effect.Rotation)
					local barrelLengthOffset = direction:Resized(gunTypeData.BarrelOffset.X / 0.65)
					local barrelHeightOffset = gunTypeData.BarrelOffset.Y - math.abs(sprite.Offset.X)
					local spriteOffset = Vector(0, sprite.Offset.Y - barrelHeightOffset) / 0.65
					local barrelPos = effect.Position + effect.PositionOffset + barrelLengthOffset + spriteOffset


					-- Custom firing method
					if gunTypeData.CustomFiring then
						gunTypeData.CustomFiring(owner, effect, gunTypeData, direction, barrelPos)

					-- Good old-fashioned lead to the face
					else
						local bulletCount = gunTypeData.ProjectileCount
						local half = (bulletCount / 2) - 0.5

						for i = -half, half do
							-- Get the bullet position
							local bulletHeight = effect.PositionOffset.Y + gunTypeData.ProjectileHeight
							local bulletPos = barrelPos + Vector(0, -bulletHeight) --* (barrelHeightOffset / gunTypeData.BarrelOffset.Y)

							-- Get the bullet velocity
							local spreadOffset = i * gunTypeData.SpreadOffset
							local bulletOffset = mod:Random(-gunTypeData.BulletOffset, gunTypeData.BulletOffset)
							local shotSpeed = mod:Random(gunTypeData.ShotSpeed.Min, gunTypeData.ShotSpeed.Max)
							local velocity = direction:Rotated(spreadOffset + bulletOffset):Resized(shotSpeed)

							-- Create the bullet
							local projectile = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, gunTypeData.ProjectileVariant, gunTypeData.ProjectileSubType, bulletPos, velocity, owner):ToProjectile()
							projectile.Scale = gunTypeData.ProjectileScale
							projectile.ProjectileFlags = gunTypeData.ProjectileFlags

							-- Set the height and falling speed
							mod:GetEntityData(projectile).BountyBulletHeight = bulletHeight
							projectile.Height = bulletHeight
							projectile.FallingSpeed = 0
							projectile.FallingAccel = 0

							-- Set the damage
							local championID = owner:GetChampionColorIdx()

							if championID ~= -1 and championID ~= ChampionColor.TINY then
								projectile.CollisionDamage = 2
							end

							-- Set the projectile flags
							if mod:isFriend(owner) then
								projectile:AddProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES)
							elseif mod:isCharmOrBerserk(owner) then
								projectile:AddProjectileFlags(ProjectileFlags.HIT_ENEMIES)
							end

							-- Add custom data
							local projectileData = mod:GetEntityData(projectile)
							projectileData.customSpawn = true

							for j, entry in pairs(gunTypeData.CustomData) do
								projectileData[j] = entry
							end
						end


						-- Create the muzzle flash
						mod:SpawnBountyMuzzleFlash(effect, barrelPos, effect.Rotation)

						-- Create the casing in ejection mode
						if gunTypeData.Ejection then
							mod:SpawnBountyCasing(effect, owner)
						end
					end


					-- Continue shooting
					if gunTypeData.Automatic and myData.Ammo > 0 and (not myData.Burst or myData.Burst > 0) then
						myData.BulletDelay = gunTypeData.BulletDelay

					-- Finish shooting
					else
						effect.State = states.ToIdle
						myData.FireCooldown = mod:Random(gunTypeData.FireCooldown.Min, gunTypeData.FireCooldown.Max)
					end
				end
			end


			if effect.State == states.ReloadStart or effect.State == states.ReloadWait or effect.State == states.ReloadBullet then
				myData.ReloadOffset = math.max(0.5, myData.ReloadOffset - 0.1)

				--[[ Start reloading ]]--
				if effect.State == states.ReloadStart then
					if sprite:IsFinished() then
						effect.State = states.ReloadWait
						myData.ReloadDelay = gunTypeData.ReloadBulletDelay
					end
				end

				--[[ Waiting to reload ]]--
				if effect.State == states.ReloadWait then
					myData.ReloadDelay = math.max(0, myData.ReloadDelay - 1)
					mod:LoopingAnim(sprite, "ReloadIdle")

					if myData.ReloadDelay <= 0 then
						effect.State = states.ReloadBullet
						sprite:Play("ReloadBullet", true)

						-- Add the ammo
						local add = gunTypeData.ReloadAllAmmo and gunTypeData.Ammo or 1
						myData.Ammo = math.min(gunTypeData.Ammo, myData.Ammo + add)
						mod:PlayBountyGunSound(effect.SubType, "ReloadClick")

						-- Eject casings
						if not gunTypeData.Ejection then
							for i = 1, add do
								mod:SpawnBountyCasing(effect, owner)
							end
						end
					end
				end

				--[[ Reloading ]]--
				if effect.State == states.ReloadBullet then
					if sprite:IsFinished() then
						-- Fully loaded
						if myData.Ammo >= gunTypeData.Ammo then
							effect.State = states.ToIdle
							sprite:Play("ReloadFinish", true)
							mod:PlayBountyGunSound(effect.SubType, "ReloadFinish")

						-- Continue reloading
						else
							effect.State = states.ReloadWait
							myData.ReloadDelay = gunTypeData.ReloadBulletDelay
						end
					end
				end

			else
				myData.ReloadOffset = math.min(1, myData.ReloadOffset + 0.1)
			end
		end





		-- Get the held offset
		local sizeOffset = owner.Size * mod:Lerp(owner.SizeMulti.X, owner.SizeMulti.Y, 0.5)
		local horizontalOffset = (myData.ReloadOffset * gunTypeData.HeldOffset) + sizeOffset

		-- Poop from a butt
		if effect.Rotation > 0 and effect.Rotation < 180 then
			local real = (90 - math.abs(90 - effect.Rotation)) / 90
			horizontalOffset = horizontalOffset - horizontalOffset * 0.25 * real
		end
		local heldOffset = Vector(horizontalOffset, 0):Rotated(effect.Rotation)


		-- Get the side offset when dual wielding
		local sideOffset = Vector.Zero

		if myData.Side then
			local sideSign = mod:GetSign(myData.Side == "Right")
			local add = Vector(-sideSign * sizeOffset * 0.75, 0)
			local product = Vector.FromAngle(effect.Rotation):Dot(Vector(sideSign, 0))
			sideOffset = add + Vector(add.X * product, 0)

			-- Make the gun layering look good when aiming downwards left or right
			local dotRight = Vector.FromAngle(effect.Rotation):Dot(Vector(1, 0))
			local depthOffsetMulti = mod:GetSign(dotRight > 0) * sideSign
			effect.DepthOffset = depthOffsetMulti * 5

		else
			effect.DepthOffset = 5
		end


		-- Set the position
		effect.Position = owner.Position + heldOffset + sideOffset
		effect.Velocity = Vector.Zero


		-- Set the height
		local overlay = owner:GetNullOffset("OverlayEffect")
		local posOffsetY = 0

		if overlay:Length() > 0 then
			local height = math.min(0, overlay.Y + 40)
			posOffsetY = height / 6
		end

		effect.PositionOffset = owner.PositionOffset + Vector(0, posOffsetY)
		effect.PositionOffset.Y = math.min(0, effect.PositionOffset.Y)


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
		local posOffsetX = upDownMulti * gunTypeData.BarrelOffset.Y
		sprite.Offset.X = mod:GetSign(sprite.FlipX) * mod:GetSign(effect.Rotation < 180) * posOffsetX


		-- Set the color
		effect.Color = owner.Color
		sprite.Color = owner:GetSprite().Color





	--[[ Disappear / transfer if the owner is gone ]]--
	elseif effect.State ~= states.Disappear and effect.State ~= states.Transfer then
		effect.Color = Color.Default
		sprite.Color = Color.Default

		-- Start transferring if Eternal
		if effect.SubType == mod.BountyGunTypes.REVOLVER_ETERNAL and #mod:GetEternalRevolverTargets() > 0 then
			effect.State = states.Transfer
			effect.Visible = true
			effect.DepthOffset = 0

			-- Fly out of the dead guy's hand
			local angle = math.random(-80, 80)
			local speed = math.random(12, 18)
			effect.Velocity = Vector.FromAngle(effect.Rotation + angle):Resized(speed)

			effect.Position = effect.Position + effect.PositionOffset
			effect.PositionOffset = Vector.Zero
			sprite.Offset.X = 0


		-- Have a chance to drop as a pickup if Briend has Birthright
		elseif mod:ShouldDropBountyGun(owner) then
			local angle = math.random(-20, 20)
			local speed = math.random(4, 6)
			local velocity = Vector.FromAngle(effect.Rotation + angle):Resized(speed)
			Isaac.Spawn(EntityType.ENTITY_PICKUP, mod.PICKUP.VARIANT.BRIEND_BIRTHRIGHT_GUN, effect.SubType, effect.Position, velocity, owner)
			effect:Remove()


		-- Remove immediately if not visible
		elseif not effect.Visible then
			effect:Remove()

		-- Start disappearing
		else
			effect.State = states.Disappear
			effect.Velocity = Vector.Zero

			if not sprite:IsPlaying("Disappear") then
				sprite:Play("Disappear", true)
			end
		end
	end



	--[[ Transferring ]]--
	if effect.State == states.Transfer then
		-- Find a valid enemy to transfer to
		if not effect.Target or not mod:CanGetEternalRevolver(effect.Target) then
			local targets = mod:GetEternalRevolverTargets()

			-- Pick the closest target from the list
			if #targets > 0 then
				local sortFunc = function(k1, k2)
					return k1.Position:Distance(effect.Position) < k2.Position:Distance(effect.Position)
				end
				table.sort(targets, sortFunc)
				effect.Target = targets[1]


			-- Have a chance to drop as a pickup if Briend has Birthright
			elseif mod:ShouldDropBountyGun(owner) then
				local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, mod.PICKUP.VARIANT.BRIEND_BIRTHRIGHT_GUN, effect.SubType, effect.Position, effect.Velocity, owner)
				pickup:GetSprite():SetFrame(5)

				sfx:Stop(SoundEffect.SOUND_ULTRA_GREED_SPINNING)
				effect:Remove()


			-- Disappear if no valid enemies are found
			else
				effect.State = states.Disappear
				sprite:Play("Disappear", true)

				effect.Target = nil
				effect.Velocity = Vector.Zero
				sfx:Stop(SoundEffect.SOUND_ULTRA_GREED_SPINNING)
			end
		end


		-- Fly to the target if there is one
		if effect.Target and mod:CanGetEternalRevolver(effect.Target) then
			mod:LoopingAnim(sprite, "Transferring")
			sprite.Rotation = 0
			sprite.FlipX = false

			-- Speen sound
			if not sfx:IsPlaying(SoundEffect.SOUND_ULTRA_GREED_SPINNING) then
				sfx:Play(SoundEffect.SOUND_ULTRA_GREED_SPINNING, 0.25, 0, true, 1.2)
			end


			-- Increase speed over time
			local speedValues = mod.BountyGunData.EternalTransferSpeed
			local currentSpeed = math.min(speedValues.Max, effect.TargetPosition.X + speedValues.Increase)
			effect.TargetPosition = Vector(currentSpeed, effect.TargetPosition.Y)

			local vector = (effect.Target.Position - effect.Position):Resized(effect.TargetPosition.X)
			effect.Velocity = mod:Lerp(effect.Velocity, vector, 0.1)


			-- Get picked up if it collides with the target
			local gunCapsule = effect:GetCollisionCapsule(Vector.Zero)
			local targetCapsule = effect.Target:GetCollisionCapsule(Vector.Zero)

			-- Debug render
			if game:GetDebugFlags() & DebugFlag.HITSPHERES > 0 then
				DebugRenderer.Get(effect.Index, true):Capsule(gunCapsule)
			end

			if targetCapsule:Collide(gunCapsule, Vector.Zero) then
				effect.Parent = effect.Target
				local targetData = mod:GetEntityData(effect.Target)

				-- Create the tracker if it doesn't exist
				if not targetData.GunslingerData then
					targetData.GunslingerData = {}
				end
				targetData = targetData.GunslingerData

				-- Add the gun
				if not targetData.Guns then
					targetData.Guns = {}
				end
				table.insert(targetData.Guns, myData)


				-- Add the costume
				if not targetData.Costume then
					targetData.Costume = {
						Sprite = Sprite(mod.GunslingerCostumes.Filepath, true),
					}
				end
				if not targetData.Costume.IsSteven then
					targetData.Costume.Animation = "Eternal"
					targetData.Costume.LastUpdateFrame = -1

					if not targetData.Costume.Sprite:IsPlaying("Eternal") then
						targetData.Costume.Sprite:Play("EternalAppear", true)
					end
				end


				-- Stop spinning
				effect.State = states.Appear
				sprite:Play("ReloadFinish", true)
				mod:PlayBountyGunSound(effect.SubType, "Equip")

				effect.Rotation = (effect.Position - effect.Target.Position):GetAngleDegrees() % 360
				effect.TargetPosition = Vector.Zero
				sfx:Stop(SoundEffect.SOUND_ULTRA_GREED_SPINNING)
			end
		end
	end

	--[[ Disappearing ]]--
	if effect.State == states.Disappear and sprite:IsFinished() then
		effect:Remove()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.BountyGunUpdate, mod.FF.BountyGun.Var)

function mod:BountyGunRender(effect, offset)
	local sprite = effect:GetSprite()
	local renderMode = game:GetRoom():GetRenderMode()

	-- Render the detection cone
	if game:GetDebugFlags() & DebugFlag.HITSPHERES > 0 and effect.Visible and effect.Parent then
		local startPos = effect.Parent.Position
		startPos = Isaac.WorldToRenderPosition(startPos) + offset

		local gunTypeData = mod:GetBountyGunData(effect.SubType)
		local angleLimit = (gunTypeData.ProjectileCount / 2 - 0.5) * gunTypeData.SpreadOffset
		angleLimit = math.max(angleLimit, mod.BountyGunData.FireAngleLimit)

		for i = -1, 1, 2 do
			local rotation = effect.Rotation + (i * angleLimit)
			local vector = Vector.FromAngle(rotation):Resized(mod.BountyGunData.DetectionRange)
			local endPos = Isaac.WorldToRenderPosition(effect.Parent.Position + vector) + offset
			Isaac.DrawLine(startPos, endPos, KColor(0,0,1, 0.5), KColor(0,0,0, 0), 1)
		end
	end

	-- Don't render its reflection
	if renderMode == RenderMode.RENDER_WATER_REFRACT or renderMode == RenderMode.RENDER_WATER_REFLECT then
		return false

	-- IDK if this is really needed but Friend's guns do it too
	elseif sprite.FlipX or sprite.FlipY then
		return mod:GetSpriteFlippedAxisCorrectionOffset(sprite, true)
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_EFFECT_RENDER, mod.BountyGunRender, mod.FF.BountyGun.Var)





--[[ Enemy bullet ]]--
function mod:GunslingerBulletInit(projectile)
	local prefix = projectile.SubType == mod.FF.BountyBullet.BuckshotSub and "pellet" or "default"
	projectile:GetSprite():ReplaceSpritesheet(0, "gfx/projectiles/guns/bullet_" .. prefix .. "_enemy.png", true)
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_INIT, mod.GunslingerBulletInit, mod.FF.BountyBullet.Var)

function mod:GunslingerBulletUpdate(projectile)
	local sprite = projectile:GetSprite()

	-- Set the scale
	projectile.SizeMulti = Vector.One * projectile.Scale

	-- Set the shadow size
	local baseShadowSize = projectile:GetEntityConfigEntity():GetShadowSize()
	local shadowScale = 1 + (projectile.Scale - 1) / 10
	projectile:SetShadowSize(baseShadowSize * shadowScale)


	-- Set the rotation
	if projectile.SubType ~= mod.FF.BountyBullet.BuckshotSub then
		local pos = projectile.Position + projectile.PositionOffset
		local trueVelocity = projectile.Velocity + Vector(0, projectile.FallingSpeed)
		sprite.Rotation = (pos + trueVelocity - pos):GetAngleDegrees()
	end


	-- Set the animation
	local suffix = 1
	local threshold = 0.3

	for i = 1, 12 do
		local extra = i >= 12 and 0.375 or i >= 8 and 0.25 or 0.125
		threshold = threshold + extra

		if projectile.Scale >= threshold then
			suffix = suffix + 1
		else
			break
		end
	end
	mod:LoopingAnim(sprite, "RegularTear" .. suffix)


	-- Do the flashing
	local animData = sprite:GetAnimationData("FlashOverlay")
	local flashFrame = projectile.FrameCount % animData:GetLength()
	local color = animData:GetLayer(0):GetFrame(flashFrame):GetColor()

	for i, layer in pairs( sprite:GetAllLayers() ) do
		layer:SetColor(color)
	end


	-- Don't fall down
	local data = mod:GetEntityData(projectile)

	if data.BountyBulletHeight and projectile.FrameCount <= mod.BountyGunData.MaxBulletAirTime then
		projectile.Height = data.BountyBulletHeight
		projectile.FallingSpeed = 0
		projectile.FallingAccel = 0
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.GunslingerBulletUpdate, mod.FF.BountyBullet.Var)

function mod:GunslingerBulletPop(projectile)
	sfx:Play(SoundEffect.SOUND_POT_BREAK, 0.3, 2, false, math.random(280, 320) / 100)

	-- Gibs
	for i = 2, 2 + mod:GoRoundNumber(projectile.Scale) do
		local vector = mod:RandomVector(math.random(2, 4))
		local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.NAIL_PARTICLE, 0, projectile.Position, vector, projectile):ToEffect()
		effect.m_Height = projectile.PositionOffset.Y
		effect.Color = projectile.Color
		effect:GetSprite():ReplaceSpritesheet(0, "gfx/effects/effect_086__nailgibs_red.png", true)
		effect:Update()
		effect.State = 2
	end

	-- Poof
	local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.IMPACT, 0, projectile.Position, Vector.Zero, projectile):GetSprite()
	poof.Offset = projectile.PositionOffset * 0.65
	poof.Scale = projectile:GetSprite().Scale
	poof.Rotation = math.random(359)
	poof.Color = projectile.Color
	poof:Play("Red", true)
	poof:Update()
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_DEATH, mod.GunslingerBulletPop, mod.FF.BountyBullet.Var)





--[[ Enemy bomb / rocket ]]--
function mod:GunslingerBombCollision(bomb, collider, bool)
	local data = mod:GetEntityData(bomb)

	if data.BountyGunBomb then
		-- Don't collide with the owner
		if bomb.PositionOffset.Y < 0 and collider.Index == data.BountyGunBomb.Index then
			return false

		-- Explode when colliding with a player
		elseif bomb.Variant == BombVariant.BOMB_ROCKET and collider.Type == EntityType.ENTITY_PLAYER then
			bomb:SetExplosionCountdown(0)
			return false
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_BOMB_COLLISION, mod.GunslingerBombCollision)