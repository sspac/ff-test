local mod = FiendFolio

local Settings = {
	InitialZapCooldown = {20, 40},
	FurtherZapCooldown = {10, 20},
	ZapDistance = 8 * 40,
	LaserDuration = 5,
	LaserOffset = Vector(0, -20),
	Jumps = {5, 6},
	JumpCooldown = 25,
	MaxElectricitySize = 3,
}

local ElectricityStates = {
	Appear 	  = 0,
	Idle 	  = 1,
	Disappear = 2,
}



-- Find the nearest valid zap target
local function getZapTarget(spawner, previous, nearestToPlayer)
	local nearest
	local nearestDistance = 9999

	local target = nearestToPlayer and Game():GetNearestPlayer(spawner.Position) or spawner
	local others = Isaac.FindInRadius(spawner.Position, Settings.ZapDistance, EntityPartition.ENEMY)
	local isSpawnerFriendly = spawner:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)


	for i, other in pairs(others) do
		local data = mod:GetEntityData(other)

		if other.Index ~= spawner.Index -- Not the spawner
		and (not previous or not nearest or other.Index ~= previous.Index) -- Not the previous entity in the chain
		and not data.AnglerZapped and not data.AnglerZapQueued -- Not already zapped / queued to be zapped
		and isSpawnerFriendly == other:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) -- On the same team
		and other:IsActiveEnemy(false) and mod:IsTangible(other) then -- Is a tangible enemy
			local valid = true
			local distance = other.Position:Distance(target.Position)

			-- Check for blacklisted entities
			for j, entry in pairs( mod.blacklistedPrimeMind ) do -- They're similar enough to use the same list
				local blacklist = { Type = entry[1], Variant = entry[2], SubType = entry[3] }

				if other.Type == blacklist.Type
				and (not blacklist.Variant or other.Variant == blacklist.Variant)
				and (not blacklist.SubType or other.SubType == blacklist.SubType) then
					valid = false
					break
				end
			end

			if valid and distance < nearestDistance then
				nearest = other
				nearestDistance = distance
			end
		end
	end

	return nearest
end



-- Create the laser connection between entities
local function createChainLaser(spawner, target, offset)
	offset = offset or Vector.Zero

	local laser = EntityLaser.ShootAngle(2, spawner.Position + offset, 0, Settings.LaserDuration, Settings.LaserOffset, spawner)
	laser.Mass = 0
	laser:SetScale(1.25)
	laser.ParentOffset = offset
	laser.DepthOffset = spawner.DepthOffset - offset.Y + 10

	-- Don't deal damage to friends
	if not spawner:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
		laser.CollisionDamage = 0
	end

	-- Set the angle and length
	mod:GetEntityData(laser).AnglerLaser = target
	mod:AnglerLaserUpdate(laser)

	-- Stinky winky Even Playfield stuff
	if EvenPlayfield then
		EvenPlayfield:GetData(laser).NoItems = true
	end

	return laser
end





function mod:AnglerInit(entity)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	entity.ProjectileCooldown = mod:Random(Settings.InitialZapCooldown[1], Settings.InitialZapCooldown[2])
	entity.TargetPosition = entity.Position
	entity:GetSprite().FlipX = math.random(1, 2) == 1

	-- Enable those silly freakin' callbacks
	mod:EnableManualCallback(ModCallbacks.MC_PRE_NPC_UPDATE, 	mod.AnglerZapped)
	mod:EnableManualCallback(ModCallbacks.MC_POST_LASER_UPDATE, mod.AnglerLaserUpdate)
	mod:EnableManualCallback(ModCallbacks.MC_PRE_ROOM_EXIT, 	mod.DisableAnglerCallbacks)
end

function mod:AnglerUpdate(entity)
	local sprite = entity:GetSprite()
	local data = mod:GetEntityData(entity)


	-- Always stay in the spawn position
	entity.Velocity = Vector.Zero
	entity.Position = entity.TargetPosition
	mod.NegateKnockoutDrops(entity)
	mod.QuickSetEntityGridPath(entity)



	mod:ChangeFromInit(entity)

	--[[ Idle ]]--
	if entity.State == NpcState.STATE_IDLE then
		mod:LoopingAnim(sprite, "Idle")

		-- Don't try to zap if there is one active already
		if data.HasActiveZap then
			data.HasActiveZap = nil

		else
			if entity.ProjectileCooldown <= 0 and getZapTarget(entity) then
				entity.State = NpcState.STATE_ATTACK
				sprite:Play("Attack", true)
				mod:PlaySoundCool(nil, SoundEffect.SOUND_LASERRING_WEAK, 0.9)

				entity.ProjectileCooldown = mod:Random(Settings.FurtherZapCooldown[1], Settings.FurtherZapCooldown[2])
			else
				entity.ProjectileCooldown = entity.ProjectileCooldown - 1
			end
		end



	--[[ Zap! ]]--
	elseif entity.State == NpcState.STATE_ATTACK then
		if not sprite:WasEventTriggered("Shoot") or sprite:IsEventTriggered("Shoot") then
			local hasTarget = data.ZapTarget and mod:IsTangible(data.ZapTarget)
			local targetData = hasTarget and mod:GetEntityData(data.ZapTarget)


			-- Has a target, set it as queued
			if hasTarget then
				targetData.AnglerZapQueued = true

			-- No target, try to find a new one
			else
				local target = getZapTarget(entity)

				-- Found one :)
				if target then
					data.ZapTarget = target
					hasTarget = true
					targetData = mod:GetEntityData(target)

				-- Couldn't find one :(
				else
					entity.State = NpcState.STATE_STOMP
					sprite:Play("Cancel", true)
				end
			end


			-- Zappity zap
			if hasTarget and sprite:IsEventTriggered("Shoot") then
				local offset = entity:GetNullOffset("*0") - Settings.LaserOffset
				createChainLaser(entity, data.ZapTarget, offset)
				mod:PlaySoundCool(entity, SoundEffect.SOUND_MONSTER_GRUNT_4)

				targetData.AnglerZapped = {
					Cooldown = Settings.JumpCooldown,
					JumpsLeft = mod:Random(Settings.Jumps[1], Settings.Jumps[2]),
					Previous = entity,
					Source = entity,
				}
				data.ZapTarget = nil
			end

		elseif sprite:IsFinished() then
			entity.State = NpcState.STATE_IDLE
		end



	--[[ Zap #cancelled ]]--
	elseif entity.State == NpcState.STATE_STOMP then
		if sprite:IsFinished() then
			entity.State = NpcState.STATE_IDLE
		end
	end
end





-- Zapped enemy logic
function mod:AnglerZapped(entity, offset)
	local data = mod:GetEntityData(entity)


	-- About to be zapped
	if data.AnglerZapQueued and mod:IsNormalRender() then
		data.AnglerZapQueued = nil
	end


	-- Zapped up
	local zap = data.AnglerZapped

	if zap and mod:IsNormalRender() and mod:IsTangible(entity) then
		-- Prevent the source Angler from zapping
		if zap.Source and zap.Source:Exists() then
			mod:GetEntityData(zap.Source).HasActiveZap = true
		end


		-- Create the electricity effect
		if not zap.Effect or not zap.Effect:Exists() then
			local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.FF.Angler.ElectricityVar, 0, entity.Position, Vector.Zero, entity):ToEffect()
			effect.Parent = entity
			effect:FollowParent(entity)
			effect:Update()
			zap.Effect = effect
		end


		-- Has a target
		if zap.Target and mod:IsTangible(zap.Target) then
			local targetData = mod:GetEntityData(zap.Target)

			-- Jump to it
			if zap.Cooldown <= 0 then
				createChainLaser(entity, zap.Target)

				-- Transfer the zap data if there are jumps left
				if zap.JumpsLeft - 1 > 0 and not targetData.AnglerZapped then
					targetData.AnglerZapped = {
						Cooldown = Settings.JumpCooldown,
						JumpsLeft = zap.JumpsLeft - 1,
						Previous = entity,
						Source = zap.Source,
					}
				end

				if zap.Effect then
					zap.Effect.State = ElectricityStates.Disappear
					zap.Effect:GetSprite():Play("Disappear", true)
				end
				data.AnglerZapped = nil

			-- Set it as queued
			else
				targetData.AnglerZapQueued = true
				zap.Cooldown = zap.Cooldown - 1
			end


		-- No target, try to find a new one
		else
			local target = getZapTarget(entity, zap.Previous, true)

			if target then
				zap.Target = target
				zap.Cooldown = Settings.JumpCooldown
			end
		end

		zap.Effect.Target = zap.Target
	end
end
mod:AddManualCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.AnglerZapped)



-- Keep the laser connected to the target
function mod:AnglerLaserUpdate(laser)
	local data = mod:GetEntityData(laser)

	if data.AnglerLaser then
		if data.AnglerLaser:Exists() and laser.Parent and laser.Parent:Exists() then
			local vector = (data.AnglerLaser.Position - laser.Position)
			laser.Angle = vector:GetAngleDegrees()

			local length = math.max(1, vector:Length())
			laser:SetMaxDistance(length)

		else
			laser:SetDead(true)
		end
	end
end
mod:AddManualCallback(ModCallbacks.MC_POST_LASER_UPDATE, mod.AnglerLaserUpdate, 2)



-- Disable the zap callbacks when exiting the room
function mod:DisableAnglerCallbacks()
	mod:DisableManualCallback(ModCallbacks.MC_PRE_NPC_UPDATE, 	 mod.AnglerZapped)
	mod:DisableManualCallback(ModCallbacks.MC_POST_LASER_UPDATE, mod.AnglerLaserUpdate)
	mod:DisableManualCallback(ModCallbacks.MC_PRE_ROOM_EXIT, 	 mod.DisableAnglerCallbacks)
end
mod:AddManualCallback(ModCallbacks.MC_PRE_ROOM_EXIT, mod.DisableAnglerCallbacks)





-- Electricity overlay
function mod:AnglerElectricityUpdate(effect)
	local sprite = effect:GetSprite()
	local parent = effect.Parent


	-- Disappearing
	if effect.State == ElectricityStates.Disappear then
		if sprite:IsFinished() then
			effect:Remove()
		end

	-- Start disappearing without a valid parent
	elseif not parent or not mod:IsTangible(parent) or not mod:GetEntityData(parent).AnglerZapped then
		effect.State = ElectricityStates.Disappear
		sprite:Play("Disappear", true)


	else
		local parentSprite = parent:GetSprite()

		sprite.Scale = parentSprite.Scale
		sprite.Offset = parentSprite.Offset
		effect.DepthOffset = parent.DepthOffset + 10


		-- Get the size based on the parent's size
		local size = parent.Size * mod:Lerp(parent.SizeMulti.X, parent.SizeMulti.Y, 0.5)
		local scale = math.min(1 + (size / 35), Settings.MaxElectricitySize)

		-- Get the offset based on the OverlayEffect layer
		local overlay = parentSprite:GetNullFrame("OverlayEffect")
		local newOffset

		if overlay and overlay:IsVisible() then
			newOffset = mod:Lerp(overlay:GetPos(), Vector.Zero, 0.5)
		end

		-- Update the layers
		for i, layer in pairs( sprite:GetAllLayers() ) do
			layer:SetSize(Vector.One * scale)

			if newOffset then
				layer:SetPos(newOffset)
			end
		end


		-- Appearing
		if effect.State == ElectricityStates.Appear then
			if sprite:IsFinished() then
				effect.State = ElectricityStates.Idle
			end

		-- Idle
		elseif effect.State == ElectricityStates.Idle then
			mod:LoopingAnim(sprite, "Idle")
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.AnglerElectricityUpdate, mod.FF.Angler.ElectricityVar)

function mod:AnglerElectricityRender(effect, offset)
	local sprite = effect:GetSprite()
	local target = effect.Target

	if not sprite:IsPlaying("Disappear") and target and mod:IsTangible(target) then
		local data = mod:GetEntityData(effect)

		-- Create the beam
		if not data.AnglerBeam then
			local beamSprite = Sprite("gfx/1000.175_kineti beam.anm2", true)
			beamSprite:Play("Idle", true)

			-- Set the blend and wrap modes
			beamSprite:GetLayer(0):GetBlendMode():SetMode(BlendType.ADDITIVE)
			beamSprite:GetLayer(0):SetWrapSMode(1)
			beamSprite:GetLayer(0):SetWrapTMode(0)

			data.AnglerBeam = Beam(beamSprite, 0, false, false)
		end

		local beam = data.AnglerBeam
		local beamSprite = beam:GetSprite()


		-- Get the overall alpha
		local maxAlphaTime = math.floor(Settings.JumpCooldown / 2)
		local overallAlpha = math.min(effect.FrameCount / maxAlphaTime, 1)

		-- Get the beam points
		local vector = target.Position - effect.Position
		local lengthMultis = { 0, 0.25, 0.75, 1, }

		for pointIndex, multi in pairs(lengthMultis) do
			local pointDistance = vector * multi

			-- Get the point position
			local pos = effect.Position + pointDistance
			pos = Isaac.WorldToRenderPosition(pos) + offset

			-- Get the spritesheet coordinate
			local coord = pointDistance:Length() + effect.FrameCount

			-- Get the point alpha
			local firstOrLast = pointIndex == 1 or pointIndex == #lengthMultis
			local pointAlpha = firstOrLast and 0 or overallAlpha

			-- Add the alpha
			local point = Point(pos, coord, 1.25, Color(1,0,0, pointAlpha))
			beam:Add(point)
		end


		-- Render the beam with repeating wrap mode (why do I have to set it here...)
		beamSprite:GetLayer(0):SetWrapSMode(1)
		beamSprite:GetLayer(0):SetWrapTMode(0)
		beam:Render()
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_EFFECT_RENDER, mod.AnglerElectricityRender, mod.FF.Angler.ElectricityVar)