local mod = FiendFolio
local game = Game()

local antisaacItem = mod.ITEM.COLLECTIBLE.ANTISAAC
local antisaacFamiliar = mod.ITEM.FAMILIAR.ANTISAAC
local antisaacColour = Color(0, 0, 0, 1, 0.18, 0, 0.36)

local FIRE_COOLDOWN = 16
local FIRE_ANIM_DURATION = 8
local FLOAT_ANIM_DURATION = 16

TearFlagsLib.RegisterTearFlag("FF_ANTISAAC")

local function getTargetPosition(familiar)
	local data = mod:GetEntityData(familiar)
	local centrePosition = game:GetRoom():GetCenterPos()
	local playerPosition = familiar.Player.Position
	local targetPosition = Vector((2 * centrePosition - playerPosition).X, playerPosition.Y)
	local positionOffset = Vector((centrePosition - playerPosition).X, 0):Resized(data.trainPosition * 30)
	positionOffset = mod.XalumLerp(data.lastPositionOffset, positionOffset, 0.2)
	data.lastPositionOffset = positionOffset
	targetPosition = targetPosition + positionOffset

	if not data.hasReachedPosition then
		if familiar.Position:Distance(targetPosition) > 2.5 then
			targetPosition = mod.XalumLerp(familiar.Position, targetPosition, 0.5)
		else
			data.hasReachedPosition = true
		end
	end

	return targetPosition
end

local function spawnTrail(position, spawnerEntity)
	local trail = Isaac.Spawn(1000, 111, 0, position, RandomVector(), spawnerEntity):ToEffect()
	trail:Update()
	trail.Color = antisaacColour
	trail.PositionOffset = spawnerEntity.PositionOffset
	trail.DepthOffset = -1000
	trail.SpriteScale = Vector.One * 0.75
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	mod.QuickCheckFamiliar(player, antisaacItem, antisaacFamiliar)
end, CacheFlag.CACHE_FAMILIARS)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, familiar)
	local data = mod:GetEntityData(familiar)
	data.animDirection = "Down"
	data.animPrefix = "Float"
	data.tearsCache = {}
	data.trainPosition = Isaac.CountEntities(familiar.Player, EntityType.ENTITY_FAMILIAR, antisaacFamiliar, -1)
	data.lastPositionOffset = Vector.Zero
	data.hasReachedPosition = false

	familiar:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	familiar:GetSprite().FlipY = true
	familiar.SpriteOffset = Vector(0, 30)
end, antisaacFamiliar)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
	local data = mod:GetEntityData(familiar)
	local sprite = familiar:GetSprite()

	local targetPosition = getTargetPosition(familiar)
	familiar.Velocity = targetPosition - familiar.Position
	familiar.FireCooldown = familiar.FireCooldown - 1
	spawnTrail(familiar.Position + Vector(0, -20), familiar)

	if mod.IsPlayerTryingToShoot(familiar.Player) then
		local playerFiringVector = mod.GetCorrectedFiringInput(familiar.Player)
		local myFiringVector = Vector(-playerFiringVector.X, playerFiringVector.Y)
		sprite.FlipX = myFiringVector.X < 0
		data.animDirection = mod.GetNearestDirectionStringFromAngle(myFiringVector:GetAngleDegrees(), "Side")

		if familiar.FireCooldown <= 0 then
			data.animPrefix = "FloatShoot"
			mod.SetFamiliarFireCooldown(familiar, FIRE_COOLDOWN)

			local tear = familiar:FireProjectile(myFiringVector)
			local playerInheritance = familiar.Player:GetTearMovementInheritance(myFiringVector)
			local realInheritance = Vector(-playerInheritance.X, playerInheritance.Y)
			local speed = tear.Velocity:Length()

			tear.Velocity = (myFiringVector:Resized(speed) + realInheritance):Resized(speed)
			tear:AddTearFlags(TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_PIERCING)
			tear.Color = Color(1.5, 2, 2, 0.5, 0, 0, 0)

			local tearSprite = tear:GetSprite()
			tearSprite:ReplaceSpritesheet(0, "gfx/projectiles/projectile_antisaactears.png")
			tearSprite:LoadGraphics()

			TearFlagsLib.AddTearFlags(tear, TearFlagsLib.Flag.FF_ANTISAAC, true)
			TearFlagsLib.SetTearFlagParams(tear, TearFlagsLib.Flag.FF_ANTISAAC, {
				Target = familiar.Player
			})
		end
	elseif familiar.FireCooldown < 0 then
		data.animDirection = "Down"
	end

	sprite:SetFrame(data.animPrefix .. data.animDirection, familiar.FrameCount % FLOAT_ANIM_DURATION)

	if data.animPrefix == "FloatShoot" and familiar.FireCooldown < FIRE_COOLDOWN - FIRE_ANIM_DURATION then
		data.animPrefix = "Float"
	end
end, antisaacFamiliar)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
	if TearFlagsLib.HasTearFlags(tear, TearFlagsLib.Flag.FF_ANTISAAC) then
		for _, collider in pairs(Isaac.FindInRadius(tear.Position, tear.Size, EntityPartition.TEAR)) do
			if not mod.AreEntitiesSame(collider, tear) and mod.AreEntitiesSame(TearFlagsLib.GetTearPlayer(collider), TearFlagsLib.GetTearFlagParams(tear, TearFlagsLib.Flag.FF_ANTISAAC).Target) then
				game:BombExplosionEffects((collider.Position + tear.Position) / 2, 10 * tear.CollisionDamage, 0, Color.Default, tear.SpawnerEntity or TearFlagsLib.GetTearPlayer(tear), 0.5)
				tear:Remove()
			end
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, function(_, player, damage, flags, source, cooldown)
	if flags & DamageFlag.DAMAGE_EXPLOSION == DamageFlag.DAMAGE_EXPLOSION and source.Entity and source.Entity.Type == 3 and source.Entity.Variant == antisaacFamiliar then
		return false
	end
end)