local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

function mod:swallowedM90Drawn(player, d)
	if d.drawnSwallowedM90 then
		if d.drawnSwallowedM90 == "Remove" then
			d.drawnSwallowedM90 = nil
		else
			if (not d.M90Gun) or (d.M90Gun and (not d.M90Gun:Exists())) then
				local gun = Isaac.Spawn(1000, mod.FF.SwallowedM90Gun.Var, mod.FF.SwallowedM90Gun.Sub, player.Position, nilvector, player)
				d.M90Gun = gun
				gun.SpawnerEntity = player
				gun.Parent = player
				if game:GetRoom():GetFrameCount() > 0 then
					sfx:Play(mod.Sounds.GunDraw,0.7,0,false,math.random(90,110)/100)
				end
			end
            player.FireDelay = math.max(player.MaxFireDelay, 1)
            local aim = player:GetAimDirection()
			if d.MaliceMinion then
				if aim:Length() < 0.1 then
					aim = RandomVector()
				end
			end
            if mod:canUseDrawnItem(player, mod.DrawnItemTypes.SwallowedM90, aim) then
				d.FFdrawnItemCooldown = player.MaxFireDelay
                --Actual tear
                local vec = aim:Resized(10 * (1 + mod.FriendBalancing.Shotspeed))
				vec = vec + player:GetTearMovementInheritance(vec)
                local tear = Isaac.Spawn(2, mod.TEAR.M90_BULLET, 0, player.Position, vec, player):ToTear()
                tear.SpawnerEntity = player
                --tear:GetSprite():Load("gfx/projectiles/guns/bullet_default.anm2", true)
                --tear:GetSprite():Play("RegularTear", true)
                tear.TearFlags = tear.TearFlags | TearFlags.TEAR_PIERCING
                --mod:GetEntityData(tear).customtype = "M90Bullet"
                tear.CollisionDamage = math.max(player.Damage, 3.5) * (d.swallowedM90Multi or 3.5)
				TearFlagsLib.AddTearFlags(tear, mod.FriendBulletFlags.NO_FALL_TEAR)

				-- Synergy babyyyyyyyyyy
				if player:HasCollectible(mod.ITEM.COLLECTIBLE.RUBBER_BULLETS) then
					local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
					FiendFolio.FlagBruise(tear, mod.RubberBulletsBal.BaseDuration * secondHandMultiplier, 1, 1)
					tear.Color = Color(0.5, 0.3, 0.5, 1.0, 40/255, 0/255, 40/255)
				end
				if player:HasTrinket(mod.ITEM.ROCK.SHROOMITE) then
					tear.CollisionDamage = tear.CollisionDamage*2
				end

                tear:Update()
                --Fancy smoke
                for i = -30, 30, 30 do
                    local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, tear.Position, tear.Velocity:Resized(20):Rotated(i), npc)
                    --smoke.SpriteScale = Vector(1,1)
                    smoke.SpriteOffset = Vector(0, -10)
                    smoke:Update()
                end
                --What the gun doin
                if d.M90Gun then
                    mod:GetEntityData(d.M90Gun).firingDir = tear.Velocity
                    d.M90Gun:GetSprite():Play("Shoot", true)
                end
                sfx:Play(mod.Sounds.SniperRifleFire,0.37,0,false,math.random(90,110)/100)
                game:ShakeScreen(15)
                player.Velocity = player.Velocity + tear.Velocity:Resized(-10)
				local case = Isaac.Spawn(1000, mod.FF.GolemsARBulletCase.Var, mod.FF.GolemsARBulletCase.Sub, player.Position, (player.Velocity * 1.2):Rotated(-50 + math.random(100)), player)
				case:GetSprite():ReplaceSpritesheet(0, "gfx/effects/effect_bulletcase_m90.png")
                case:GetSprite():LoadGraphics()
				case.Color = tear.Color
				case.SpriteScale = tear.SpriteScale
				local anim
				local scale = tear.Scale
				if scale <= 0.3 then
					anim = "RegularTear1"
				elseif scale <= 0.55 then
					anim = "RegularTear2"
				elseif scale <= 0.675 then
					anim = "RegularTear3"
				elseif scale <= 0.8 then
					anim = "RegularTear4"
				elseif scale <= 0.925 then
					anim = "RegularTear5"
				elseif scale <= 1.05 then
					anim = "RegularTear6"
				elseif scale <= 1.175 then
					anim = "RegularTear7"
				elseif scale <= 1.425 then
					anim = "RegularTear8"
				elseif scale <= 1.675 then
					anim = "RegularTear9"
				elseif scale <= 1.925 then
					anim = "RegularTear10"
				elseif scale <= 2.175 then
					anim = "RegularTear11"
				elseif scale <= 2.55 then
					anim = "RegularTear12"
				else
					anim = "RegularTear13"
				end
				case:GetSprite():Play(anim)
                if tear.Velocity.X < 0 then
                    case:GetSprite().FlipX = true
                end
                case:Update()
                d.drawnSwallowedM90 = "Remove"

				mod:SecondaryFire(player, aim, 1, player, {DoBasegameEffects = true, SwallowedM90 = true})
            end
		end
	end
end

function mod:swallowedM90PlayerHurt(player)
	if player:HasTrinket(mod.ITEM.TRINKET.SWALLOWED_M90) then
		mod:GetEntityData(player).drawnSwallowedM90 = true
		mod:GetEntityData(player).swallowedM90Multi = 2.5 + player:GetTrinketMultiplier(mod.ITEM.TRINKET.SWALLOWED_M90)
	end
end

--Currently unused
--[[function mod:swallowedm90(player, tear, rng, pdata, tdata)
    if mod:GetEntityData(player).drawnSwallowedM90 then
		for i = -30, 30, 30 do
			local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, tear.Position, tear.Velocity:Resized(20):Rotated(i), npc)
			--smoke.SpriteScale = Vector(1,1)
			smoke.SpriteOffset = Vector(0, -10)
			smoke:Update()
		end
		local replaced = false
		if (not haemoTears[tear.Variant]) and tear.Variant ~= 13 then
			tear.Variant = 13
		end
		if tear.Variant == 13 then
			tear:GetSprite():Load("gfx/projectiles/guns/bullet_default.anm2", true)
			tear:GetSprite():Play("RegularTear", true)
		end
		tear.TearFlags = tear.TearFlags | TearFlags.TEAR_PIERCING
		mod:GetEntityData(tear).customtype = "M90Bullet"
		tear.CollisionDamage = math.max(tear.CollisionDamage, 3.5)
		tear.CollisionDamage = tear.CollisionDamage * 3.5
		tear.Velocity = tear.Velocity:Resized(20)
		tear:Update()
	end
end]]

--Cool effect
function mod:m90GunAI(e)
	local parent = e.Parent
	local sprite = e:GetSprite()
	local d = mod:GetEntityData(e)

	if not parent then
		e:Remove()
	else
		local rot = parent.Velocity
		if d.firingDir then
			rot = d.firingDir
		end
		if rot.X < 0 then
			sprite.FlipX = true
			e.RenderZOffset = 5100
		else
			sprite.FlipX = false
			e.RenderZOffset = -5100
		end
		rot = math.floor(rot:GetAngleDegrees())
		if sprite.FlipX then
			rot = (rot * -1) + 180
		end
		e.SpriteRotation = rot

		local vec = (parent.Position + Vector(0, -10) - e.Position)
		e.Velocity = mod:Lerp(e.Velocity, vec, 0.6)
		if sprite:IsFinished("Shoot") then
			e:Remove()
		end
	end
end

function mod:m90BulletTearRender(tear, tvar, data, offset)
	local sprite = tear:GetSprite()
	local scale = tear.Scale
	local flags = tear.TearFlags

	local anim
	if scale <= 0.3 then
		anim = "RegularTear1"
	elseif scale <= 0.55 then
		anim = "RegularTear2"
	elseif scale <= 0.675 then
		anim = "RegularTear3"
	elseif scale <= 0.8 then
		anim = "RegularTear4"
	elseif scale <= 0.925 then
		anim = "RegularTear5"
	elseif scale <= 1.05 then
		anim = "RegularTear6"
	elseif scale <= 1.175 then
		anim = "RegularTear7"
	elseif scale <= 1.425 then
		anim = "RegularTear8"
	elseif scale <= 1.675 then
		anim = "RegularTear9"
	elseif scale <= 1.925 then
		anim = "RegularTear10"
	elseif scale <= 2.175 then
		anim = "RegularTear11"
	elseif scale <= 2.55 then
		anim = "RegularTear12"
	else
		anim = "RegularTear13"
	end

	if not sprite:IsPlaying(anim) then
		local frame = sprite:GetFrame()
		sprite:Play(anim, true)
		sprite:SetFrame(frame)
	end

	local spritescale = mod:getTearScale13(tear)
	local layers = sprite:GetAllLayers()
	for _, layer in ipairs(layers) do
		layer:SetSize(spritescale)
	end

	local adjustedVelocity = tear.Velocity
	if tear.WaitFrames > 0 then
		adjustedVelocity = tear.ContinueVelocity
	elseif (tear.FallingSpeed < 0 or 0.2 < tear.FallingSpeed) and
	   flags & TearFlags.TEAR_LUDOVICO ~= TearFlags.TEAR_LUDOVICO and
	   ((flags & TearFlags.TEAR_ABSORB ~= TearFlags.TEAR_ABSORB and flags & TearFlags.TEAR_POP ~= TearFlags.TEAR_POP) or tear.Velocity:Length() <= 0.1)
	then
		adjustedVelocity = adjustedVelocity + Vector(0, tear.FallingSpeed)
	end

	local flipOverride = false
	-- anti grav rotation stuff
	local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
	if player
	and (TearFlagsLib.HasTearFlags(tear, mod.FriendBulletFlags.FRIEND) or TearFlagsLib.HasTearFlags(tear, mod.FriendBulletFlags.AMMO_CLIP) or TearFlagsLib.HasTearFlags(tear, mod.FriendBulletFlags.NO_FALL_TEAR))
	and not data.BulletAntiGravFixed
	and player:HasCollectible(CollectibleType.COLLECTIBLE_ANTI_GRAVITY) then
		if player:GetFireDirection() == Direction.NO_DIRECTION then
			data.BulletAntiGravFixed = true
		else
			sprite.Rotation = data.BulletOriginalAim and data.BulletOriginalAim:GetAngleDegrees() or 0
		end
	elseif not data.NoFallRotation then
		sprite.Rotation = adjustedVelocity:GetAngleDegrees()
		if tear.SubType == mod.FriendBulletSubTypes.STAY_VERTICALLY_UPRIGHT then
			if tear.Velocity.X < 0 then
				flipOverride = true
				sprite.Rotation = 180 - sprite.Rotation
			end
		end
	elseif tear.Velocity:Length() > 0 then
		sprite.Rotation = tear.Velocity:GetAngleDegrees()
	end

	sprite.FlipX = flipOverride
	sprite.FlipY = false
end
mod:AddCallback("FF_CUSTOM_TEAR_RENDER", mod.m90BulletTearRender, FiendFolio.TEAR.M90_BULLET)
mod:AddCallback("FF_CUSTOM_TEAR_RENDER", mod.m90BulletTearRender, FiendFolio.TEAR.GOLEMS_AR_BULLET)
mod:AddCallback("FF_CUSTOM_TEAR_RENDER", mod.m90BulletTearRender, FiendFolio.TEAR.FRIEND_BULLET)

function mod:m90BulletTearSplat(tear, var, data)
	-- hi erfly im making number one do it's thing as friend
	if var == mod.TEAR.FRIEND_BULLET then
		local player = tear.SpawnerEntity
		if player and player:ToFamiliar() then
			player = player:ToFamiliar().Player
		end
		player = player and player:ToPlayer()
		if player and player:HasCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE) then
			return
		end
	end
	local vol = data.CustomBulletVolume or 0.15
	--sfx:Play(SoundEffect.SOUND_POT_BREAK, vol, 0, false, 3)
	sfx:Play(FiendFolio.Sounds.BulletImpact, vol, 0, false, mod:RandomFloat(0.9, 1.1))

	if tear.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE then return end

	local scale = tear.Scale
	local color = tear:GetSprite().Color

	local poof = Isaac.Spawn(1000, EffectVariant.IMPACT, 0, tear.Position, nilvector, tear)
	poof:GetSprite().Color = color
	poof.SpriteScale = Vector(scale * 0.8, scale * 0.8)
	poof.PositionOffset = tear.PositionOffset

	for i = 1, 5 do
		local gib = Isaac.Spawn(1000, EffectVariant.NAIL_PARTICLE, 0, tear.Position, RandomVector()*2, tear):ToEffect()
		gib.m_Height = math.min(-5, tear.Height)
		gib:GetSprite().Color = color
		gib.State = 2
	end
end
mod:AddCallback("FF_CUSTOM_TEAR_SPLAT", mod.m90BulletTearSplat, FiendFolio.TEAR.M90_BULLET)
mod:AddCallback("FF_CUSTOM_TEAR_SPLAT", mod.m90BulletTearSplat, FiendFolio.TEAR.GOLEMS_AR_BULLET)
mod:AddCallback("FF_CUSTOM_TEAR_SPLAT", mod.m90BulletTearSplat, FiendFolio.TEAR.FRIEND_BULLET)