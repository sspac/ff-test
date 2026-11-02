local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local flag = TearFlagsLib.RegisterTearFlag("FORTUNE")

local tearcolor = Color(1.0, 0.2, 1.0, 1.0, 65/255, 15/255, 10/255, 1.82, 1.62, 1.2675, 1)

FiendFolio.FortuneTearCooldown = 0
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	if FiendFolio.FortuneTearCooldown > 0 then
		FiendFolio.FortuneTearCooldown = FiendFolio.FortuneTearCooldown - 1
	end
end)

function mod:PreventRemovingFortuneFlag(entity, player, flag)
	local params = TearFlagsLib.GetTearFlagParams(entity, flag)
	if params.NoRemove then
		return true
	end
end
mod:AddCallback(TearFlagsLib.Callback.PRE_REMOVE_TEARFLAG, mod.PreventRemovingFortuneFlag, flag)

function mod:fortuneFlagGeneric(entity, player, weaponFlag)
	if weaponFlag == TearFlagsLib.WeaponFlag.DARK_ARTS then return end
	if weaponFlag == TearFlagsLib.WeaponFlag.OCULAR_RIFT then return end
	
	local baseFortuneOdds = 0
	if player:HasTrinket(mod.ITEM.TRINKET.FORTUNE_WORM) or player:HasTrinket(FiendFolio.ITEM.ROCK.FORTUNE_WORM_FOSSIL) then
		local fortuneWormOdds = player:GetPlayerType() == FiendFolio.PLAYER.FIEND and 5 or 1
		fortuneWormOdds = fortuneWormOdds * (player:GetTrinketMultiplier(mod.ITEM.TRINKET.FORTUNE_WORM) + FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.FORTUNE_WORM_FOSSIL))
		baseFortuneOdds = baseFortuneOdds + fortuneWormOdds
	end
	if FiendFolio.GreatFortune then
		baseFortuneOdds = baseFortuneOdds + 3
	end
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.LEFTOVER_TAKEOUT) then
		baseFortuneOdds = baseFortuneOdds + 17
	end

	if baseFortuneOdds > 0 then
		local freq = math.min(math.max(math.floor(22 - baseFortuneOdds - player.Luck), 3), 25)
		if math.random(freq) == 1 then
			TearFlagsLib.AddTearFlags(entity, flag)
			
			if weaponFlag == TearFlagsLib.WeaponFlag.TEAR or weaponFlag == TearFlagsLib.WeaponFlag.LUDOVICO_TEAR then
				if FiendFolio.HasCetusFlag(entity) then
					entity.Color = tearcolor
				else
					mod:changeTearVariant(entity, mod.TEAR.FORTUNE_COOKIE)
					if FiendFolio.HasBeansFlag(entity) then
						entity.Color = tearcolor
					end
				end
				entity.CollisionDamage = entity.CollisionDamage * 1.05
			elseif weaponFlag == TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD then
				mod.scheduleForUpdate(function()
					entity.CollisionDamage = (entity.CollisionDamage - 185) * 1.05 + 185
				end, 1)
			elseif weaponFlag == TearFlagsLib.WeaponFlag.SHARP_KEY then
				mod.scheduleForUpdate(function()
					entity.CollisionDamage = (entity.CollisionDamage - 30) * 1.05 + 30
				end, 1)
			elseif weaponFlag == TearFlagsLib.WeaponFlag.DR_FETUS then
				entity.Color = tearcolor
				
				local bomb = entity:ToBomb()
				bomb.ExplosionDamage = bomb.ExplosionDamage * 1.05
			elseif weaponFlag == TearFlagsLib.WeaponFlag.AQUARIUS then
				mod:GetEntityData(entity).FFAquariusTearColor = tearcolor
			elseif weaponFlag == TearFlagsLib.WeaponFlag.EPIC_FETUS or weaponFlag == TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS then
				mod:GetEntityData(entity).FFExplosionColor = tearcolor
			elseif weaponFlag == TearFlagsLib.WeaponFlag.SWORD then
				entity.Color = tearcolor
				entity.CollisionDamage = entity.CollisionDamage * 1.05
			elseif weaponFlag == TearFlagsLib.WeaponFlag.LASER or 
			       weaponFlag == TearFlagsLib.WeaponFlag.ANTI_GRAV_LASER or 
			       weaponFlag == TearFlagsLib.WeaponFlag.KNIFE or
			       weaponFlag == TearFlagsLib.WeaponFlag.DARK_ARTS or
			       weaponFlag == TearFlagsLib.WeaponFlag.LOCUST or
			       weaponFlag == TearFlagsLib.WeaponFlag.UMBILICAL_WHIP or
			       weaponFlag == TearFlagsLib.WeaponFlag.BRIMSTONE_BALL or
			       weaponFlag == TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD or
			       weaponFlag == TearFlagsLib.WeaponFlag.SHARP_KEY or
			       weaponFlag == TearFlagsLib.WeaponFlag.OCULAR_RIFT or
			       weaponFlag == TearFlagsLib.WeaponFlag.HEMOPTYSIS
			then
				return
			else
				entity.Color = tearcolor
				entity.CollisionDamage = entity.CollisionDamage * 1.05
			end
		end
	end
end
mod:AddPriorityCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, -350, mod.fortuneFlagGeneric)

function mod:fortuneFlagLocust(entity, player, weaponFlag)
	if player:GetCollectibleRNG(FiendFolio.ITEM.COLLECTIBLE.LEFTOVER_TAKEOUT):RandomFloat() < 0.2 then
		TearFlagsLib.AddTearFlags(entity, flag)
	end
end
mod:AddEntityCallback(TearFlagsLib.Callback.POLL_LOCUST_TEARFLAGS, EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, 
                      FiendFolio.ITEM.COLLECTIBLE.LEFTOVER_TAKEOUT, mod.fortuneFlagLocust, FiendFolio.ITEM.COLLECTIBLE.LEFTOVER_TAKEOUT)

mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, function(_, entity, player, source)
	if FiendFolio.FortuneTearCooldown <= 0 then
		--game:ShowFortune()
		mod:ShowFortune(false, true)
		FiendFolio.FortuneTearCooldown = 20
	end
end, flag)

function mod:handleAquariusFortuneDamage(creep)
	if TearFlagsLib.HasTearFlags(creep, flag) then
		creep.CollisionDamage = creep.CollisionDamage * 1.05
	end
end

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -350, function(_, entity, amount, flags, source, cooldown, extraSource)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not entity:ToNPC() then return end
	
	if source.Type ~= 1000 or (source.Variant ~= EffectVariant.TECH_DOT and source.Variant ~= EffectVariant.BRIMSTONE_SWIRL) or not source.Entity or 
	   not TearFlagsLib.HasTearFlags(source.Entity, flag)
	then 
		return
	end

	local player = TearFlagsLib.GetTearPlayer(source.Entity)
	if player then
		return {Damage = amount * 1.05}
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -350, function(_, entity, amount, flags, source, cooldown)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not entity:ToNPC() then return end
	
	if source.Type ~= 1000 or (source.Variant ~= EffectVariant.ROCKET and source.Variant ~= EffectVariant.SMALL_ROCKET) or not source.Entity or 
	   not TearFlagsLib.HasTearFlags(source.Entity, flag)
	then 
		return
	end

	if flags & DamageFlag.DAMAGE_EXPLOSION > 0 then
		local player = TearFlagsLib.GetTearPlayer(source.Entity)
		if player then
			return {Damage = amount * 1.05}
		end
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -350, function(_, entity, amount, flags, source, cooldown, extraSource)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not entity:ToNPC() then return end
	
	if extraSource == nil or extraSource.Type ~= 3 or extraSource.Variant ~= FamiliarVariant.UMBILICAL_BABY or not extraSource.Entity or 
	   not TearFlagsLib.HasTearFlags(extraSource.Entity, flag)
	then 
		return 
	end

	local player = TearFlagsLib.GetTearPlayer(extraSource.Entity)
	if player then
		return {Damage = amount * 1.05}
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -350, function(_, entity, amount, flags, source, cooldown, extraSource)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not entity:ToNPC() then return end
	
	local source = extraSource or source
	if source.Entity and TearFlagsLib.IsEntitySpiritSword(source.Entity) then
		return
	end
	if source.Type ~= 8 or not source.Entity or 
	   not TearFlagsLib.HasTearFlags(source.Entity, flag)
	then 
		return 
	end

	local player = TearFlagsLib.GetTearPlayer(source.Entity)
	if player then
		return {Damage = amount * 1.05}
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -350, function(_, entity, amount, flags, source, cooldown, extraSource)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not entity:ToNPC() then return end
	
	local source = extraSource or source
	if (source.Type ~= EntityType.ENTITY_LASER and not (source.Type == EntityType.ENTITY_EFFECT and source.Variant == EffectVariant.BRIMSTONE_BALL)) or not source.Entity or 
	   not TearFlagsLib.HasTearFlags(source.Entity, flag)
	then 
		return 
	end

	local player = TearFlagsLib.GetTearPlayer(source.Entity)
	if player then
		return {Damage = amount * 1.05}
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -350, function(_, entity, amount, flags, source, cooldown, extraSource)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not entity:ToNPC() then return end
	
	local source = extraSource or source
	if not (source.Type == 1 and TearFlagsLib.hemoptysisDummy and TearFlagsLib.HasTearFlags(TearFlagsLib.hemoptysisDummy, flag)) then 
		return 
	end

	local player = TearFlagsLib.GetTearPlayer(source.Entity)
	if player then
		return {Damage = amount * 1.05}
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -350, function(_, entity, amount, flags, source, cooldown, extraSource)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not entity:ToNPC() then return end
	
	local source = extraSource or source
	local hitter = nil
	if source.Type == 0 and flags & DamageFlag.DAMAGE_LASER > 0 then
		local potential = mod.CheckingForDmg[#mod.CheckingForDmg]
		if potential and TearFlagsLib.IsEntityOcularRift(potential) then
			hitter = potential
		end
	elseif source.Entity and TearFlagsLib.IsEntityOcularRift(source.Entity) then
		hitter = source.Entity
	elseif source.Type == EntityType.ENTITY_EFFECT and source.Variant == EffectVariant.DARK_SNARE and source.Entity and source.Entity.SpawnerEntity then
		hitter = source.Entity
	else
		return
	end
	if hitter == nil then return end
	
	-- this is technically not accurate for ocular rift since it rolls every hit instead of every frame but idc
	-- this functions nicer for can of beans purposes
	-- i'll leave tearflagslib generally as it is but for weird stuff like this imma do this instead
	local player = TearFlagsLib.GetTearPlayer(hitter)
	if not player then return end
	
	local data = mod:GetEntityData(hitter)
	local frame = game:GetFrameCount()
	if data.RolledForFortune ~= frame then
		TearFlagsLib.SetTearFlagParams(hitter, flag, {NoRemove = false})
		TearFlagsLib.ClearTearFlags(hitter, flag)
		
		local baseFortuneOdds = 0
		if player:HasTrinket(mod.ITEM.TRINKET.FORTUNE_WORM) or player:HasTrinket(FiendFolio.ITEM.ROCK.FORTUNE_WORM_FOSSIL) then
			local fortuneWormOdds = player:GetPlayerType() == FiendFolio.PLAYER.FIEND and 5 or 1
			fortuneWormOdds = fortuneWormOdds * (player:GetTrinketMultiplier(mod.ITEM.TRINKET.FORTUNE_WORM) + FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.FORTUNE_WORM_FOSSIL))
			baseFortuneOdds = baseFortuneOdds + fortuneWormOdds
		end
		if FiendFolio.GreatFortune then
			baseFortuneOdds = baseFortuneOdds + 3
		end
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.LEFTOVER_TAKEOUT) then
			baseFortuneOdds = baseFortuneOdds + 17
		end

		if baseFortuneOdds > 0 then
			local freq = math.min(math.max(math.floor(22 - baseFortuneOdds - player.Luck), 3), 25)
			if math.random(freq) == 1 then
				TearFlagsLib.AddTearFlags(hitter, flag)
				TearFlagsLib.SetTearFlagParams(hitter, flag, {NoRemove = true})
			end
		end
		data.RolledForFortune = frame
	end
	if TearFlagsLib.HasTearFlags(hitter, flag) then
		return {Damage = amount * 1.05}
	end
end)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.LEFTOVER_TAKEOUT] = {
	FireCooldown = 19,
	TearDamage = 5.25,
	TearFallingSpeed = -0.444,
	BodyColor = Color(1,1,1,1,-30.841/255,-30.841/255,-30.841/255,0.788,0.788,0.788,1),
	EyeAColor = Color(1,1,1,1,57.641/255,29.406/255,-2.875/255,0.641,0.406,0.125,1),
	EyeBColor = Color(1,1,1,1,57.641/255,29.406/255,-2.875/255,0.641,0.406,0.125,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	if math.random(5) == 1 then
		TearFlagsLib.AddTearFlags(tear, flag)
		mod:changeTearVariant(tear, mod.TEAR.FORTUNE_COOKIE)
		tear.CollisionDamage = tear.CollisionDamage * 1.05
	end
end, FiendFolio.ITEM.COLLECTIBLE.LEFTOVER_TAKEOUT)

function mod:fortuneCookieTearRender(tear, var, data, offset)
	local sprite = tear:GetSprite()
	local scale = tear.Scale
	local flags = tear.TearFlags

	local anim
	if scale <= 0.675 then
		anim = "Stone1Move"
	elseif scale <= 0.925 then
		anim = "Stone2Move"
	elseif scale <= 1.175 then
		anim = "Stone3Move"
	elseif scale <= 1.675 then
		anim = "Stone4Move"
	elseif scale <= 2.175 then
		anim = "Stone5Move"
	else
		anim = "Stone6Move"
	end

	if not sprite:IsPlaying(anim) then
		local frame = sprite:GetFrame()
		sprite:Play(anim, true)
		sprite:SetFrame(frame)
	end

	local spritescale = mod:getTearScale6(tear)
	local layers = sprite:GetAllLayers()
	for _, layer in ipairs(layers) do
		layer:SetSize(spritescale)
	end

	if flags & TearFlags.TEAR_FLAT == TearFlags.TEAR_FLAT then
		local adjustedVelocity = tear.Velocity
		if tear.WaitFrames > 0 then
			adjustedVelocity = tear.ContinueVelocity
		elseif (tear.FallingSpeed < 0 or 0.2 < tear.FallingSpeed) and
		       flags & TearFlags.TEAR_LUDOVICO ~= TearFlags.TEAR_LUDOVICO and
		       ((flags & TearFlags.TEAR_ABSORB ~= TearFlags.TEAR_ABSORB and flags & TearFlags.TEAR_POP ~= TearFlags.TEAR_POP) or tear.Velocity:Length() <= 0.1)
		then
			adjustedVelocity = adjustedVelocity + Vector(0, tear.FallingSpeed)
		end

		sprite.Rotation = adjustedVelocity:GetAngleDegrees()
		sprite.FlipX = false
		sprite.FlipY = false
	else
		sprite.Rotation = 0
		sprite.FlipX = false
		sprite.FlipY = false
	end
end
mod:AddCallback("FF_CUSTOM_TEAR_RENDER", mod.fortuneCookieTearRender, FiendFolio.TEAR.FORTUNE_COOKIE)

function mod:fortuneCookieTearSplat(tear, var, data)
	sfx:Play(SoundEffect.SOUND_BONE_SNAP, 0.5, 0, false, math.random() + 0.5)

	if tear.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE then return end

	local scale = tear.Scale
	local color = tear:GetSprite().Color

	local poof = Isaac.Spawn(1000, EffectVariant.IMPACT, 0, tear.Position, Vector.Zero, tear)
	poof:GetSprite().Color = color
	poof.SpriteScale = Vector(scale * 0.8, scale * 0.8)
	poof.PositionOffset = tear.PositionOffset

	for i = 1, 5 do
		local gib = Isaac.Spawn(1000, EffectVariant.TOOTH_PARTICLE, 920, tear.Position, RandomVector()*2, tear):ToEffect()
		gib.m_Height = math.min(-5, tear.Height)
		gib:GetSprite().Color = color
		gib.State = 2
	end
end
mod:AddCallback("FF_CUSTOM_TEAR_SPLAT", mod.fortuneCookieTearSplat, FiendFolio.TEAR.FORTUNE_COOKIE)

