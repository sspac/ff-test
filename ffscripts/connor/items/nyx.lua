local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local kZeroVector = Vector.Zero
local kNormalVector = Vector(1,1)

local kFlatDamageBonus = 2
local kGemFireCooldown = 10
local kMaximumStickTime = 30 * 8
local kShieldedRadius = 30

local kTargetingRadius = 150
local kTargetChangeThreshold = 100
local kStickDistMult = 0.9

local kGemMaxFlightTime = 300  -- After this, turning rate starts to degrade.
local kGemTurningRate = 0.45
local kGemTurningRateDegradation = 0.01

local NyxCastGemState = {
	IDLE = 0,
	ATTACK = 1,
	STUCK = 2,
	FALLING = 3,
	FALLEN = 4,
}

local function IsValidVulnerableEnemy(entity)
	return entity and entity:Exists() and (entity:IsVulnerableEnemy() or not mod.IsEnemyReallyInvulnerable(entity)) and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
end

local function HasFlag(flags, flagToCheck)
	return flags & flagToCheck == flagToCheck
end

local function GetGemColor(gem, alpha)
	local data = mod:GetEntityData(gem)
	if data.nyxGemColor == "PURPLE" then
		return Color(1, 0, 1, alpha)
	elseif data.nyxGemColor == "GREEN" then
		return Color(0, 1, 0, alpha)
	elseif data.nyxGemColor == "ORANGE" then
		return Color(1, 0.5, 0.5, alpha)
	elseif data.nyxGemColor == "RED" then
		return Color(1, 0, 0, alpha)
	else
		return Color.Default
	end
end

-- Nyx can sometimes have some funny behaviour when switching between Tainted Lazarus forms.
-- This helps alleviate that.
local flipBuffer = 0
--
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, _, _, player)
	flipBuffer = 5
end, CollectibleType.COLLECTIBLE_FLIP)
--
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	if flipBuffer > 0 then
		flipBuffer = flipBuffer - 1
	end
end)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, function(_, player, _, value)
	local numTrinket = player:GetTrinketMultiplier(FiendFolio.ITEM.ROCK.CAST_GEM)
	local numItem = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.NYX)

	if player:GetPlayerType() == mod.PLAYER.BRIEND then
		local twin = player:GetOtherTwin()
		if mod:IsBriendTwin(player) then
			numTrinket = 0
			numItem = 0
		elseif twin then
			numTrinket = numTrinket + twin:GetTrinketMultiplier(FiendFolio.ITEM.ROCK.CAST_GEM)
			numItem = numItem + twin:GetCollectibleNum(mod.ITEM.COLLECTIBLE.NYX)
		end
	end

	local pData = mod:GetEntityData(player)
	pData.numRedNyxGems = numTrinket
	pData.numNyxGems = 3 * numItem + numTrinket
	return pData.numNyxGems
end, "ff_nyx")

function mod:nyxPlayerUpdate(player, pData)
	local numGems = pData.numNyxGems or 0
	
	if numGems == 0 then return end
	
	local redGems = pData.numRedNyxGems or 0
	
	if not pData.nyxGems then
		pData.nyxGems = {}
	end
	
	local currentGems = 0
	for _, gemPtr in pairs(pData.nyxGems) do
		if mod:GetPointee(gemPtr) then
			currentGems = currentGems + 1
		end
	end
	
	-- Spawn gems as needed.
	if flipBuffer <= 0 and numGems ~= currentGems then
		for i=0, numGems-1 do
			local gem = mod:GetPointee(pData.nyxGems[i])
			
			local color
			local spritesheet
			
			if i >= numGems - redGems then
				spritesheet = "gfx/familiar/nyx/familiar_castgem_red.png"
				color = "RED"
			elseif i % 3 == 1 then
				spritesheet = "gfx/familiar/nyx/familiar_castgem_green.png"
				color = "GREEN"
			elseif i % 3 == 2 then
				spritesheet = "gfx/familiar/nyx/familiar_castgem_orange.png"
				color = "ORANGE"
			else
				spritesheet = "gfx/familiar/nyx/familiar_castgem_purple.png"
				color = "PURPLE"
			end
			
			if not gem or not gem:Exists() then
				gem = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.NYX_CAST_GEM, 0, player.Position, kZeroVector, player):ToFamiliar()
				pData.nyxGems[i] = EntityPtr(gem)
				mod:GetEntityData(gem).nyxIndex = i
			end
			
			local gemData = mod:GetEntityData(gem)
			
			if gemData.nyxGemColor ~= color then
				gem:GetSprite():ReplaceSpritesheet(0, spritesheet)
				gem:GetSprite():LoadGraphics()
				gemData.nyxGemColor = color
			end
		end
	end
	
	local aimDirection = player:GetAimDirection()
	
	-- Fire a gem
	if pData.nyxCooldown and pData.nyxCooldown > 0 then
		pData.nyxCooldown = pData.nyxCooldown - 1
	end
	if aimDirection:Length() > 0.1 and (pData.nyxCooldown or 0) <= 0 then
		for _, gemPtr in pairs(pData.nyxGems) do
			local gem = mod:GetPointee(gemPtr)
			if gem and mod:GetEntityData(gem).nyxState == NyxCastGemState.IDLE then
				local gemData = mod:GetEntityData(gem)
				local sprite = gem:GetSprite()
				
				local tearParams = player:GetTearHitParams(WeaponType.WEAPON_TEARS)
				gemData.nyxTearFlags = tearParams.TearFlags
				gemData.nyxDamage = tearParams.TearDamage + kFlatDamageBonus
				
				gemData.nyxFlood = mod:nyxShouldDoFloodEffect(player, gemData.nyxTearFlags)
				gemData.nyxDoom = mod:nyxShouldDoAresEffect(player)
				if mod:canCritialHit(player) then
					gemData.nyxCrit = mod:shouldCriticalHit(player) or (gem:GetDropRNG():RandomFloat() < 0.1) -- Bonus 10% crit roll
					if gemData.nyxCrit then
						gemData.nyxDamage = gemData.nyxDamage * mod.CritDamageMult
					end
				end
				gemData.nyxPoison = HasFlag(gemData.nyxTearFlags, TearFlags.TEAR_POISON)
						or player:HasCollectible(CollectibleType.COLLECTIBLE_DEAD_TOOTH)
				gemData.nyxShielded = HasFlag(gemData.nyxTearFlags, TearFlags.TEAR_SHIELDED)
				gemData.nyxPierce = HasFlag(gemData.nyxTearFlags, TearFlags.TEAR_PIERCING) or HasFlag(gemData.nyxTearFlags, TearFlags.TEAR_PERSISTENT)
				
				gemData.nyxSpeed = player.ShotSpeed * 15
				gemData.nyxTurningRate = kGemTurningRate
				gemData.nyxFlyingFrames = 0
				
				--[[if gemData.nyxShielded then
					gemData.nyxSpeed = gemData.nyxSpeed * 0.5
				end]]
				
				local vel = aimDirection:Resized(gemData.nyxSpeed)
				gem.Velocity = vel
				gemData.nyxTargetVelocity = vel + player:GetTearMovementInheritance(vel)
				
				pData.nyxCooldown = kGemFireCooldown
				
				gem.Position = game:GetRoom():GetClampedPosition(gem.Position, 10)
				
				sprite:Play("Shooting", true)
				gemData.nyxState = NyxCastGemState.ATTACK
				
				gemData.nyxTarget = nil
				
				local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_ATTRACT, 10, gem.Position + gem.SpriteOffset, kZeroVector, gem):ToEffect()
				eff.MinRadius = 1
				eff.MaxRadius = 8
				eff.LifeSpan = 10
				eff.Timeout = 10
				eff.Color = GetGemColor(gem, 1.0)
				eff.Visible = false
				eff:Update()
				eff.Visible = true
				
				-- sfx:Play(???) sound pending
				
				local b = 0.75
				local color = Color(1,1,1,1, b,b,b)
				gem:SetColor(color, 10, 1, true, true)
				break
			end
		end
	end
end

local function GemIsOnFloor(gem)
	return mod:GetEntityData(gem).nyxState == NyxCastGemState.FALLEN or (mod:GetEntityData(gem).nyxState == NyxCastGemState.FALLING and gem:GetSprite():WasEventTriggered("Land"))
end

-- Higher value is a more desirable target.
local function CalcGemTargetValue(gem, entity)
	local dist = gem.Position:Distance(entity.Position)
	local dir = (entity.Position - gem.Position):Normalized()
	
	local angle1 = gem.Velocity:GetAngleDegrees() % 360
	local angle2 = dir:GetAngleDegrees() % 360
	
	local diff1 = math.abs(angle1 - angle2)
	local diff2
	
	if angle2 > angle1 then
		diff2 = math.abs(angle1 - (angle2 - 360))
	else
		diff2 = math.abs((angle1 - 360) - angle2)
	end
	
	local angleDiff = math.min(diff1, diff2)
	
	return - dist - angleDiff * 2
end

function mod:nyxCastGemUpdate(gem)
	local data = mod:GetEntityData(gem)
	local sprite = gem:GetSprite()
	
	if not gem.Player then
		gem.Player = Isaac.GetPlayer(0)
	end
	local player = gem.Player
	local pData = mod:GetEntityData(player)
	
	if not data.nyxIndex or data.nyxIndex >= pData.numNyxGems then
		gem:Remove()
		return
	end
	
	-- Init
	if not data.nyxState or game:GetRoom():GetFrameCount() <= 1 then
		data.nyxState = NyxCastGemState.IDLE
		gem.Position = player.Position
	end
	
	if data.nyxState ~= NyxCastGemState.STUCK then
		gem.Mass = 3
		gem.Friction = 1
	end
	
	-- Floating around the player.
	if data.nyxState == NyxCastGemState.IDLE then
		if sprite:IsFinished("Pickup") or (sprite:GetAnimation() ~= "Pickup" and sprite:GetAnimation() ~= "Floating") then
			sprite:Play("Floating", true)
		end
		
		-- Orbit
		local orbitSpeed = 5
		local t = (player.FrameCount * orbitSpeed) % 360
		local orbitDist = 40
		
		-- Offset t for each individual gem
		if pData.numNyxGems > 1 then
			t = t + (data.nyxIndex / pData.numNyxGems) * 360
		end
		
		-- Circular orbit
		local targetPos = player.Position + Vector(orbitDist, 0):Rotated(t)
		
		-- Squish orbit (make it oval shaped)
		local orbitSquish = 0.75
		targetPos.Y = mod:Lerp(targetPos.Y, player.Position.Y, orbitSquish)
		
		-- Rotate entire orbit
		--[[local orbitMaxAngle = 25
		local orbitAngle = orbitMaxAngle * math.sin(player.FrameCount / 20)
		--targetPos = (targetPos - player.Position):Rotated(orbitAngle) + player.Position
		local thing = (targetPos - player.Position):Rotated(orbitAngle)
		data.nyxHeightOffset = thing.Y * 0.5]]
		
		-- "Tilt" the orbit by adjusting the height offsets of the gems.
		local orbitTiltChangeSpeed = 3
		local tiltTimeOffset = (player.FrameCount * orbitTiltChangeSpeed) % 360
		local t2 = (t + tiltTimeOffset) % 360
		local maxTilt = 7.5
		data.nyxHeightOffset = maxTilt * math.sin(math.pi * t2 / 180)
		
		-- Lerp to target position.
		local posDiff = targetPos - gem.Position
		local targetVel = posDiff:Resized(math.min(15, posDiff:Length()))
		gem.Velocity = mod:Lerp(gem.Velocity, targetVel, 0.5)
	end
	
	-- Gem was shot out / is flying
	if data.nyxState == NyxCastGemState.ATTACK then
		local clamped = game:GetRoom():GetClampedPosition(gem.Position, 10)
		if clamped.X ~= gem.Position.X or clamped.Y ~= gem.Position.Y then
			sprite:Play("Fall", true)
			data.nyxState = NyxCastGemState.FALLING
			gem.Position = clamped
			sfx:Play(SoundEffect.SOUND_GOLD_HEART_DROP, 0.6, 0, false, 1.25)
		else
			data.nyxFlyingFrames = (data.nyxFlyingFrames or 0) + 1
			
			local target = data.nyxTarget
			
			if not IsValidVulnerableEnemy(target) then
				target = nil
			end
			
			-- Allow choosing new target.
			if not target or (target.Position:Distance(gem.Position) >= 2 * kTargetingRadius and gem.FrameCount % 10 == 0) then
				local nearby = Isaac.FindInRadius(gem.Position + gem.Velocity:Resized(kTargetingRadius), kTargetingRadius, EntityPartition.ENEMY)
				local currentTargetValue
				if target then
					currentTargetValue = CalcGemTargetValue(gem, target)
				else
					currentTargetValue = -99999
				end
				for _, ent in pairs(nearby) do
					if IsValidVulnerableEnemy(ent) and ent.MaxHitPoints > 1 then
						local value = CalcGemTargetValue(gem, ent)
						if value > currentTargetValue + kTargetChangeThreshold then
							target = ent
							currentTargetValue = value
						end
					end
				end
			end
			
			if IsValidVulnerableEnemy(target) then
				local newTargetVel = (target.Position - gem.Position):Resized(data.nyxSpeed)
				
				local currentAngle = gem.Velocity:GetAngleDegrees() % 360
				
				local leftTarget = newTargetVel:GetAngleDegrees() % 360
				while leftTarget > currentAngle do
					leftTarget = leftTarget - 360
				end
				
				local rightTarget = newTargetVel:GetAngleDegrees() % 360
				while rightTarget < currentAngle do
					rightTarget = rightTarget + 360
				end
				
				local targetAngle
				
				if math.abs(currentAngle - leftTarget) < math.abs(currentAngle - rightTarget) then
					targetAngle = leftTarget
				else
					targetAngle = rightTarget
				end
				
				data.nyxTargetVelocity = Vector.FromAngle(mod:Lerp(currentAngle, targetAngle, data.nyxTurningRate)):Resized(data.nyxSpeed)
				if data.nyxFlyingFrames > kGemMaxFlightTime then
					data.nyxTurningRate = math.max(data.nyxTurningRate - kGemTurningRateDegradation, 0)
				end
			end
			
			data.nyxTarget = target
			
			if data.nyxTargetVelocity then
				gem.Velocity = mod:Lerp(gem.Velocity, data.nyxTargetVelocity, 0.3)
			end
			
			-- Trail
			if not data.nyxTrail then
				local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPRITE_TRAIL, 0, gem.Position, kZeroVector, player):ToEffect()
				trail.MinRadius = 0.1
				trail.SpriteScale = Vector(1.5 ,1)
				trail:FollowParent(gem)
				trail.ParentOffset = Vector(0, -22)
				trail.Color = GetGemColor(gem, 0.35)
				
				data.nyxTrail = trail
			end
			
			-- Shielded
			if data.nyxShielded then
				if not data.nyxShield or not data.nyxShield:Exists() then
					data.nyxShield = Isaac.Spawn(mod.FF.ShadowShield.ID, mod.FF.ShadowShield.Var, mod.FF.ShadowShield.Sub, gem.Position, kZeroVector, gem):ToEffect()
					data.nyxShield:FollowParent(gem)
					data.nyxShield.ParentOffset = Vector(0,1)
					--data.nyxShield.SpriteScale = Vector(0.75, 0.75)
				end
				data.nyxShield:SetTimeout(data.nyxShield.FrameCount + 10)
				for _, proj in pairs(Isaac.FindInRadius(gem.Position, kShieldedRadius, EntityPartition.BULLET)) do
					--proj:Die()
					proj = proj:ToProjectile()
					if proj and not proj:HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) then
						proj:AddProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES)
						proj.Velocity = proj.Velocity:Rotated(180)
					end
				end
			end
		end
	end
	
	if data.nyxState ~= NyxCastGemState.ATTACK and data.nyxTrail then
		data.nyxTrail.Parent = nil
		data.nyxTrail = nil
	end
	
	if data.nyxState ~= NyxCastGemState.ATTACK and data.nyxShield then
		data.nyxShield:Remove()
		data.nyxShield = nil
	end
	
	-- Stuck into an enemy.
	if data.nyxState == NyxCastGemState.STUCK then
		if not data.nyxStickTarget or not data.nyxStickTarget:Exists() or data.stickTime > kMaximumStickTime or not IsValidVulnerableEnemy(data.nyxStickTarget) or not data.nyxStickTarget.Visible or data.nyxStickTarget:IsDead() then
			if data.nyxStickTarget then
				mod:GetEntityData(data.nyxStickTarget).nyxGemAttached = nil
			end
			data.nyxState = NyxCastGemState.FALLING
			sprite:Play("Fall", true)
		else
			-- Poison cloud
			if data.nyxPoison and not data.nyxPoisonCloud then
				data.nyxPoisonCloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 4, gem.Position, kZeroVector, player):ToEffect()
				data.nyxPoisonCloud.CollisionDamage = 0
				data.nyxPoisonCloud:FollowParent(gem)
				data.nyxPoisonCloud:ClearEntityFlags(EntityFlag.FLAG_PERSISTENT)
			end
			
			mod.AddBruise(data.nyxStickTarget, player, 1, 1, 1)
			data.stickTime = data.stickTime + 1
		end
	end
	
	if data.nyxState ~= NyxCastGemState.STUCK and data.nyxPoisonCloud then
		data.nyxPoisonCloud.Timeout = 60
		data.nyxPoisonCloud.Parent = nil
		data.nyxPoisonCloud = nil
	end
	
	-- Collisions
	if data.nyxState == NyxCastGemState.FALLEN then
		gem.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
	else
		gem.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
	end
	
	-- Falling onto the ground.
	if data.nyxState == NyxCastGemState.FALLING then
		if not data.nyxFallTargetPos then
			data.nyxFallTargetPos = Isaac.GetFreeNearPosition(gem.Position, 0)
		end
		
		if gem.Position:Distance(data.nyxFallTargetPos) < 1 then
			data.nyxState = NyxCastGemState.FALLEN
		else
			local posDiff = data.nyxFallTargetPos - gem.Position
			local targetVel = posDiff:Resized(math.min(10, posDiff:Length()) * 0.5)
			gem.Velocity = mod:Lerp(gem.Velocity, targetVel, 0.5)
		end
	elseif data.nyxFallTargetPos then
		data.nyxFallTargetPos = nil
	end
	
	-- On the ground, waiting to be picked up.
	if data.nyxState == NyxCastGemState.FALLEN then
		-- Push away from other gems.
		local nearby = Isaac.FindInRadius(gem.Position, gem.Size * 0.3, EntityPartition.FAMILIAR)
		local targetVel = kZeroVector
		for _, fam in pairs(nearby) do
			if fam.Variant == mod.ITEM.FAMILIAR.NYX_CAST_GEM and fam.InitSeed ~= gem.InitSeed and GemIsOnFloor(fam) then
				if gem.Position:Distance(fam.Position) == 0 then
					targetVel = RandomVector()
				else
					targetVel = (gem.Position - fam.Position):Normalized()
				end
			end
		end
		gem.Velocity = mod:Lerp(gem.Velocity, targetVel, 0.2)
		
		if player.Position:Distance(gem.Position) <= player.Size + gem.Size then
			sprite:Play("Pickup")
			data.nyxState = NyxCastGemState.IDLE
			sfx:Play(SoundEffect.SOUND_SOUL_PICKUP)
		end
	end
	
	if sprite:IsPlaying("Fall") and sprite:IsEventTriggered("Land") then
		sfx:Play(SoundEffect.SOUND_URN_CLOSE, 0.85, 0, false, 2.0)
	end
	
	-- While flying towards enemies, point in the direction of movement.
	if data.nyxState == NyxCastGemState.ATTACK then
		sprite.Rotation = gem.Velocity:GetAngleDegrees()
	else
		sprite.Rotation = 0
	end
	
	-- Gem floating height.
	local baseHeight = -15
	local targetOffset
	if data.nyxState == NyxCastGemState.IDLE then
		targetOffset = Vector(0, baseHeight + data.nyxHeightOffset)
	elseif data.nyxState == NyxCastGemState.FALLING or data.nyxState == NyxCastGemState.FALLEN then
		targetOffset = kZeroVector
	else
		targetOffset = Vector(0, baseHeight)
	end
	gem.SpriteOffset = mod:Lerp(gem.SpriteOffset, targetOffset, 0.2)
	
	-- Tech Zero Lasers to connect gems.
	if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY_ZERO) or data.nyxTechZeroLaser then
		local nextGem = mod:GetPointee(pData.nyxGems[data.nyxIndex + 1] or pData.nyxGems[0])
		local nextGemState = nextGem and mod:GetEntityData(nextGem).nyxState
		local canConnectLaser = nextGem and data.nyxState ~= NyxCastGemState.IDLE and nextGemState ~= NyxCastGemState.IDLE
				and (data.nyxState == NyxCastGemState.ATTACK or nextGemState == NyxCastGemState.ATTACK)
		if canConnectLaser then
			if not data.nyxTechZeroLaser or not data.nyxTechZeroLaser:Exists() then
				local laser = EntityLaser.ShootAngle(LaserVariant.ELECTRIC, gem.Position, 0, -1, kZeroVector, player)
				laser.CollisionDamage = player.Damage * 0.3
				laser.Parent = gem
				laser.Target = nextGem
				mod:GetEntityData(laser).isNyxChainLightning = true
				mod:GetEntityData(laser).nyxChainLightningPlayer = player
				data.nyxTechZeroLaser = laser
				mod:nyxChainLightningUpdate(laser)
				laser:Update()
			end
		elseif data.nyxTechZeroLaser then
			data.nyxTechZeroLaser:Remove()
			data.nyxTechZeroLaser = nil
		end
	end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.nyxCastGemUpdate, mod.ITEM.FAMILIAR.NYX_CAST_GEM)

function mod:nyxStickToEnemy(gem)
	local data = mod:GetEntityData(gem)
	local sprite = gem:GetSprite()
	
	if data.nyxState == NyxCastGemState.STUCK then
		gem.Mass = data.nyxStickTarget.Mass
		gem.Friction = data.nyxStickTarget.Friction
		gem.Velocity = data.nyxStickTarget.Velocity
		gem.Position = data.nyxStickTarget.Position - data.nyxStickOffset
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_UPDATE, mod.nyxStickToEnemy, mod.ITEM.FAMILIAR.NYX_CAST_GEM)

function mod:nyxEnemyUpdate(entity, data)
	mod:nyxFloodKnockbackHandler(entity, data)
	mod:nyxChainLightningHandler(entity, data)
end

function mod:nyxCastGemCollision(gem, collider)
	local data = mod:GetEntityData(gem)
	local sprite = gem:GetSprite()
	
	if IsValidVulnerableEnemy(collider) and data.nyxState == NyxCastGemState.ATTACK then
		local player = gem.Player or Isaac.GetPlayer(0)
		local damage = data.nyxDamage or (player.Damage + kFlatDamageBonus)
		
		collider:TakeDamage(damage, 0, EntityRef(player), 0)
		
		if collider.MaxHitPoints <= 1 or (data.nyxPierce and collider.HitPoints <= damage) then
			-- Don't stick.
			return true
		end
		
		-- STICK
		data.nyxStickTarget = collider
		data.nyxStickOffset = (collider.Position - gem.Position):Resized(collider.Size * kStickDistMult)
		mod:GetEntityData(collider).nyxGemAttached = gem
		data.nyxState = NyxCastGemState.STUCK
		data.stickTime = 0
		sprite:Play("Embedded")
		sfx:Play(SoundEffect.SOUND_GOOATTACH0, 1, 0, false, 1.2)
		sfx:Play(SoundEffect.SOUND_BULB_FLASH, 1, 0, false, 1.0)
		
		mod.AddBruise(collider, player, 1, 1, 1)
		
		if data.nyxFlood then
			mod:nyxFlood(gem)
		else
			local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.IMPACT, 0, gem.Position + gem.SpriteOffset, kZeroVector, nil):ToEffect()
			eff:FollowParent(gem)
			eff.SpriteScale = Vector(0.9, 0.9)
		end
		
		if data.nyxDoom then
			mod:nyxSpawnAresBladeRift(gem, collider)
		end
		
		local chainLightningItems = mod:getNumChainLightningItems(player)
		if chainLightningItems > 0 then
			mod:GetEntityData(collider).nyxChainLightningCountdown = 0
			mod:GetEntityData(collider).nyxChainLightningRemaining = chainLightningItems + 1
		end
		
		if data.nyxCrit then
			mod:doCriticalHitFx(gem.Position, collider, gem)
		end
		
		local color = Color(1,1,1,1)
		color:SetColorize(2,0,0,1)
		gem:SetColor(color, 10, 1, true, true)
	else
		return true
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, mod.nyxCastGemCollision, mod.ITEM.FAMILIAR.NYX_CAST_GEM)

function mod:nyxCastGemSirenImmunity(sirenHelper)
	if sirenHelper.FrameCount == 0 and sirenHelper.Target and sirenHelper.Target.Variant == mod.ITEM.FAMILIAR.NYX_CAST_GEM then
		sirenHelper:Remove()
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.nyxCastGemSirenImmunity, EntityType.ENTITY_SIREN_HELPER)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.nyxCastGemSirenImmunity, EffectVariant.CHARM_EFFECT)

--------------------------------------------------
-- FLOOD SHOT (Knockback / water synergy)
--------------------------------------------------

local kFloodKnockbackForce = 20
local kFloodKnockbackForceWaterBonus = 10
local kFloodKnockbackDuration = 5

local FloodItems = {
	CollectibleType.COLLECTIBLE_KNOCKOUT_DROPS,
	CollectibleType.COLLECTIBLE_PISCES,
	CollectibleType.COLLECTIBLE_NEPTUNUS,
}

function mod:nyxShouldDoFloodEffect(player, tearFlags)
	if HasFlag(tearFlags, TearFlags.TEAR_KNOCKBACK) or player:HasTrinket(TrinketType.TRINKET_BLISTER) then
		return true
	end
	
	for _, item in pairs(FloodItems) do
		if player:HasCollectible(item) then
			return true
		end
	end
end

function mod:nyxFloodKnockbackHandler(entity, data)
	if data.nyxKnockback then
		if not data.nyxKnockbackDuration or data.nyxKnockbackDuration < 1 then
			data.nyxKnockback = nil
			return
		end
		local scale = (data.nyxKnockbackDuration / kFloodKnockbackDuration) * 0.9
		entity.Velocity = mod:Lerp(entity.Velocity, data.nyxKnockback, scale)
		data.nyxKnockbackDuration = data.nyxKnockbackDuration - 1
	end
end

function mod:nyxFlood(gem)
	local player = gem.Player or Isaac.GetPlayer(0)
	
	local force = kFloodKnockbackForce
	local damage = 0
	
	if player:HasCollectible(CollectibleType.COLLECTIBLE_PISCES) or player:HasCollectible(CollectibleType.COLLECTIBLE_NEPTUNUS) then
		-- Special water splash effects
		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_SPLASH, 0, gem.Position, kZeroVector, nil)
		local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 2, gem.Position, kZeroVector, nil):ToEffect()
		local c = Color(1,1,1,1, 0.25, 0.8, 0.8)
		splat.Color = c
		splat:SetTimeout(5)
		sfx:Play(SoundEffect.SOUND_BOSS2_DIVE, 1, 2, false, 1.0)
		force = force + kFloodKnockbackForceWaterBonus
		damage = (mod:GetEntityData(gem).nyxDamage or (player.Damage + kFlatDamageBonus)) * 0.2
	else
		local impact = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.IMPACT, 0, gem.Position + gem.SpriteOffset, kZeroVector, nil):ToEffect()
		impact.SpriteScale = Vector(1.2, 1.2)
	end
	
	sfx:Play(SoundEffect.SOUND_EXPLOSION_WEAK, 1, 2, false, 2.0)
	
	local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_ATTRACT, 10, gem.Position + gem.SpriteOffset, kZeroVector, gem):ToEffect()
	eff.MinRadius = 5
	eff.MaxRadius = 20
	eff.LifeSpan = 15
	eff.Timeout = 15
	eff.Visible = false
	eff:Update()
	eff.Visible = true
	
	for _, entity in pairs(Isaac.FindInRadius(gem.Position, 75, EntityPartition.ENEMY)) do
		if mod.CanKnockbackEntity(entity) then
			local push = (entity.Position - player.Position):Resized(force)
			mod:GetEntityData(entity).nyxKnockback = push
			mod:GetEntityData(entity).nyxKnockbackDuration = kFloodKnockbackDuration
		end
		if damage > 0 then
			entity:TakeDamage(damage, 0, EntityRef(player), 0)
		end
	end
end

--------------------------------------------------
-- ELECTRIC SHOT (Chain lighting, tech synergy)
--------------------------------------------------

local kChainLightningDelay = 6
local kChainLightningRange = 150
local kChainLightningLaserTimeout = 3

local ChainLightningItems = {
	CollectibleType.COLLECTIBLE_JACOBS_LADDER,
	CollectibleType.COLLECTIBLE_TECHNOLOGY,
	CollectibleType.COLLECTIBLE_TECHNOLOGY_2,
	CollectibleType.COLLECTIBLE_TECH_5,
	CollectibleType.COLLECTIBLE_TECH_X,
}

function mod:getNumChainLightningItems(player)
	local num = 0
	for _, item in pairs(ChainLightningItems) do
		num = num + player:GetCollectibleNum(item)
	end
	return num
end

function mod:getChainLightningVariant(player)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_JACOBS_LADDER) or player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY_ZERO) then
		return 10
	end
	return 2
end

function mod:nyxChainLightningHandler(entity, data)
	if data.nyxChainLightningCountdown then
		if data.nyxChainLightningCountdown <= 0 or entity:IsDead() then
			local possibleTargets = {}
			for _, ent in pairs(Isaac.FindInRadius(entity.Position, kChainLightningRange, EntityPartition.ENEMY)) do
				if IsValidVulnerableEnemy(ent) then
					if GetPtrHash(ent) ~= GetPtrHash(entity)
							and (not data.nyxChainLightningSource or GetPtrHash(data.nyxChainLightningSource) ~= GetPtrHash(ent)) then
						table.insert(possibleTargets, ent)
					end
				end
			end
			if #possibleTargets > 0 then
				local player = Isaac.GetPlayer(0)
				if data.nyxGemAttached then
					player = data.nyxGemAttached.player or player
				end
				
				local choice = (Random() % #possibleTargets) + 1
				local target = possibleTargets[choice]
				
				local laser = EntityLaser.ShootAngle(mod:getChainLightningVariant(player), entity.Position, 0, kChainLightningLaserTimeout, kZeroVector, nil)
				laser.CollisionDamage = player.Damage
				laser.DisableFollowParent = true
				mod:GetEntityData(laser).nyxChainLightningAnchor = entity
				laser.Target = target
				mod:GetEntityData(laser).isNyxChainLightning = true
				mod:GetEntityData(laser).nyxChainLightningPlayer = player
				mod:nyxChainLightningUpdate(laser)
				
				local remaining = (data.nyxChainLightningRemaining or 1) - 1
				
				if remaining > 0 then
					mod:GetEntityData(target).nyxChainLightningSource = entity
					mod:GetEntityData(target).nyxChainLightningCountdown = kChainLightningDelay
					mod:GetEntityData(target).nyxChainLightningRemaining = remaining
				end
			end
			data.nyxChainLightningSource = nil
			data.nyxChainLightningCountdown = nil
			data.nyxChainLightningRemaining = nil
		else
			data.nyxChainLightningCountdown = data.nyxChainLightningCountdown - 1
		end
	end
end

function mod:nyxChainLightningUpdate(laser)
	local data = mod:GetEntityData(laser)
	if data.isNyxChainLightning then
		local offset
		if laser.Parent and laser.Parent:Exists() then
			offset = laser.Parent.SpriteOffset
			--laser.Position = laser.Parent.Position + offset
		end
		if data.nyxChainLightningAnchor and data.nyxChainLightningAnchor:Exists() then
			offset = data.nyxChainLightningAnchor.SpriteOffset
			laser.Position = data.nyxChainLightningAnchor.Position + offset
		end
		laser.ParentOffset = kZeroVector
		laser.PositionOffset = offset or kZeroVector
		
		if laser.Target and laser.Target:Exists() then
			local targetPos = laser.Target.Position + laser.Target.SpriteOffset - (offset or kZeroVector)
			laser.AngleDegrees = (targetPos - laser.Position):GetAngleDegrees()
			laser:SetMaxDistance(laser.Position:Distance(targetPos) + 1)
		end
		
		if (not laser.Target or not laser.Target:Exists() or not offset) and laser.Timeout > 1 then
			laser.Timeout = 1
		end
	end
end

function mod:nyxDamage(entity, damage, damageFlags, damageSourceRef, damageCountdown)
	if damageSourceRef.Type == EntityType.ENTITY_LASER and damageSourceRef.Entity then
		local data = mod:GetEntityData(damageSourceRef.Entity)
		if data.isNyxChainLightning then
			if entity:IsEnemy() and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and not (data.nyxChainLightningAnchor and GetPtrHash(entity) == GetPtrHash(data.nyxChainLightningAnchor)) then
				entity:TakeDamage(damage, damageFlags, EntityRef(data.nyxChainLightningPlayer or Isaac.GetPlayer(0)), damageCountdown)
			end
			return false
		end
	end
end

function mod:nyxLaserDamage(npc, data, damage, damageFlags, sourceEnt, sourceData, sourceRef, damageCountdown)
	if sourceData.isNyxChainLightning then
		if not npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and not (sourceData.nyxChainLightningAnchor and GetPtrHash(npc) == GetPtrHash(sourceData.nyxChainLightningAnchor)) then
			npc:TakeDamage(damage, damageFlags, EntityRef(sourceData.nyxChainLightningPlayer or Isaac.GetPlayer(0)), damageCountdown)
		end
		return false
	end
end
mod:AddPreNpcTakeDmgFromSourceCallback(mod.nyxLaserDamage, EntityType.ENTITY_LASER, LaserVariant.ELECTRIC)

--------------------------------------------------
-- SLICING SHOT (Doom synergy)
--------------------------------------------------

function mod:nyxShouldDoAresEffect(player)
	return player:HasCollectible(mod.ITEM.COLLECTIBLE.TOY_PIANO)
		or player:HasCollectible(CollectibleType.COLLECTIBLE_MARS)
		or (player:HasCollectible(mod.ITEM.COLLECTIBLE.PRANK_COOKIE) and player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.PRANK_COOKIE):RandomInt(9) == 0)
end

local function AddAresDoom(player, enemy)
	local ptrhash = GetPtrHash(enemy)
	mod.QueuedStatusApply[ptrhash] = mod.QueuedStatusApply[ptrhash] or {}
	table.insert(mod.QueuedStatusApply[ptrhash], function()
		if mod:CanApplyDoom(enemy, player) then
			local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
			mod.AddDoom(enemy, player, 120 * secondHandMultiplier, 3, player.Damage * 4)
		end
	end)
end

local kBladeRiftDuration = 25

local kBladeRiftStartScale = Vector(0.5, 0.5)
local kBladeRiftMaxScale = Vector(1.2, 1.2)
local kBladeRiftStartRate = 0.3

local kBladeRiftEndScale = Vector(0.8, 0.8)
local kBladeRiftFadeRate = 0.2

local kBladeRiftSize = 70
local kBladeRiftDamageMult = 1.0

function mod:nyxSpawnAresBladeRift(gem, enemy)
	local rift = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.FF.NyxBladeRift.Var, 0, gem.Position, kZeroVector, gem):ToEffect()
	rift:FollowParent(gem)
	rift.ParentOffset = gem.SpriteOffset
	rift:SetTimeout(kBladeRiftDuration)
	rift.SpriteScale = kBladeRiftStartScale
	mod:GetEntityData(rift).nyxBladeRiftTargetScale = kBladeRiftMaxScale
	mod:GetEntityData(rift).nyxBladeRiftEnemy = enemy
	sfx:Play(SoundEffect.SOUND_SWORD_SPIN, 0.8, 0, false, 0.5)
	sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT, 1.2, 0, false, 0.75)
	
	AddAresDoom(gem.Player or Isaac.GetPlayer(0), enemy)
end

function mod:nyxBladeRift(rift)
	local data = mod:GetEntityData(rift)
	
	rift.DepthOffset = -10
	
	if not data.nyxBladeRiftHit then
		data.nyxBladeRiftHit = {}
		if data.nyxBladeRiftEnemy then
			data.nyxBladeRiftHit[data.nyxBladeRiftEnemy.InitSeed] = true
		end
	end
	
	if not rift.Parent or not rift.Parent:Exists() then
		data.nyxBladeRiftTargetScale = kBladeRiftEndScale
		data.nyxBladeRiftDone = true
	end
	
	if data.nyxBladeRiftDone then
		local c = rift.Color
		local alpha = mod:Lerp(c.A, 0, kBladeRiftFadeRate)
		c:SetTint(c.R, c.G, c.B, alpha)
		rift.Color = c
		
		rift.SpriteScale = rift.SpriteScale * 0.95
		
		if alpha <= 0.1 then
			rift:Remove()
			return
		end
	else
		local targetScale = data.nyxBladeRiftTargetScale or kNormalVector
		rift.SpriteScale = mod:Lerp(rift.SpriteScale, targetScale, kBladeRiftStartRate)
		
		if rift.SpriteScale:Distance(targetScale) < 0.1 then
			data.nyxBladeRiftTargetScale = kNormalVector
		end
	end
	
	if rift.Timeout == 0 then
		data.nyxBladeRiftTargetScale = kBladeRiftEndScale
		data.nyxBladeRiftDone = true
	end
	
	local player = data.nyxPlayer or Isaac.GetPlayer(0)
	local appliedDoom = data.nyxAppliedDoom
	
	if not data.nyxBladeRiftDone and (rift.FrameCount - 1) % 5 == 0 then
		for _, entity in pairs(Isaac.FindInRadius(rift.Position, kBladeRiftSize, EntityPartition.ENEMY)) do
			local sameEntity = data.nyxBladeRiftEnemy and GetPtrHash(entity) == GetPtrHash(data.nyxBladeRiftEnemy)
			
			if not sameEntity and IsValidVulnerableEnemy(entity) and not data.nyxBladeRiftHit[entity.InitSeed] then
				entity:TakeDamage(math.max(player.Damage * kBladeRiftDamageMult, 1), 0, EntityRef(player), 0)
				AddAresDoom(player, entity)
				local eff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, entity.Position, kZeroVector, entity)
				eff.Color = entity.SplatColor
				data.nyxBladeRiftHit[entity.InitSeed] = true
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.nyxBladeRift, mod.FF.NyxBladeRift.Var)
