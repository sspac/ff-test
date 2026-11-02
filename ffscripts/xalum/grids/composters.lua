local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

mod.ComposterSubType = {
	DEFAULT		= 0,
	POISON		= 1,
	CHARMING	= 2,
	UNSTABLE	= 3,
	BRUISING	= 4,
	HOLY		= 5,
}

mod.composterBehaviour = {}
mod.composterSkin = {}
mod.composterIdFromPath = {}

mod.ComposterSpellBaseDamage = {
	[mod.ComposterSubType.DEFAULT] 	= 22, -- 5 points to the first person who can figure out why
	[mod.ComposterSubType.POISON] 	= 15,
	[mod.ComposterSubType.CHARMING] = 15,
	[mod.ComposterSubType.UNSTABLE] = 30,
	[mod.ComposterSubType.BRUISING] = 15,
	[mod.ComposterSubType.HOLY] 	= 15, 
}

function mod.RegisterComposter(variant, skin, onBreak)
	mod.composterBehaviour[tostring(variant)] = onBreak
	mod.composterSkin[tostring(variant)] = skin
	mod.composterIdFromPath[skin] = variant
end

function mod.GetComposterSkin(subtype)
	return mod.composterSkin[tostring(subtype)] or mod.composterSkin["0"]
end

function mod.ComposterCommonBreak(entity, fromProjectile)
	local savedata = FiendFolio.savedata.run
	sfx:Play(SoundEffect.SOUND_MUSHROOM_POOF, 2, 0, false, 1.5)

	-- Check for Rainbow Bean unlock/drop
	if mod.CanRunUnlockAchievements() and not mod:GetEntityData(entity).popCountedForAchieve then
		mod.savedata.compostBinsPopped = mod.savedata.compostBinsPopped + 1
		mod:GetEntityData(entity).popCountedForAchieve  = true
		if not FiendFolio.ACHIEVEMENT.RAINBOW_BEAN:IsUnlocked(true) and mod.savedata.compostBinsPopped >= 50 then
			FiendFolio.ACHIEVEMENT.RAINBOW_BEAN:Unlock()

			if not FiendFolio.ACHIEVEMENT.MAGNA_FARTA:IsUnlocked(true) and Isaac.GetPersistentGameData():Unlocked(Achievement.TAINTED_BLUE_BABY) then
				FiendFolio.ACHIEVEMENT.MAGNA_FARTA:Unlock()
			end

			Isaac.Spawn(5, 350, mod.ITEM.TRINKET.RAINBOW_BEAN, entity.Position + Vector(0,10), Vector.Zero, nil)
			savedata.SpawnedRainbowBean = true
		end
	end

	local rng = entity:GetDropRNG()
	if rng:GetSeed() == 0 then
		rng:SetSeed(math.min(1, mod.savedata.run.compostsThrown))
	end

	if FiendFolio.ACHIEVEMENT.RAINBOW_BEAN:IsUnlocked() and entity:GetDropRNG():RandomInt(50) == 0 then
		savedata.ComposBarrelBeanFloor = savedata.ComposBarrelBeanFloor or entity:GetDropRNG():RandomInt(5)
		if savedata.ComposBarrelBeanFloor == 1 and not savedata.SpawnedRainbowBean then
			Isaac.Spawn(5, 350, mod.ITEM.TRINKET.RAINBOW_BEAN, entity.Position + Vector(0, 10), Vector.Zero, nil)
			savedata.SpawnedRainbowBean = true
		end
	end

	-- Spawn particle effects
	for i = 1, 6 do
		local particle = Isaac.Spawn(1000, 27, 0, entity.Position, RandomVector() * math.random(5, 30) / 10, entity)
		local sprite = particle:GetSprite()
		local skin = mod.GetComposterSkin(entity.SubType)
		if fromProjectile then skin = entity:GetSprite():GetFilename() end

		sprite:Load(skin, true)
		sprite:Play("Gib" .. math.random(4), true)
		mod:GetEntityData(particle).turnedIntoCoolBetterParticles = true
		particle:Update()
	end

	-- Safe remove
	mod:GetEntityData(entity).dontDoAnything = true
	entity:GetSprite():Play("Blown")
	entity:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR)
end

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.LATE, function(_, entity, amount, flags)
	if entity.Variant == 752 then -- Composter
		local realAmount = math.min(math.max(math.floor(amount / 15), 1), 3)
		if entity.HitPoints - realAmount <= 1 or flags & (DamageFlag.DAMAGE_TNT | DamageFlag.DAMAGE_EXPLOSION) ~= 0 or entity:IsDead() then
			(mod.composterBehaviour[tostring(entity.SubType)] or mod.composterBehaviour["0"])(entity)
			mod.ComposterCommonBreak(entity)
		else	
			entity.HitPoints = entity.HitPoints - realAmount
		end

		return false
	end
end, 292) -- Pushable TNT

mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, function(_, tear)
	local composter = mod.composterIdFromPath[tear:GetSprite():GetFilename()]
	if composter then
		mod.composterBehaviour[tostring(composter)](tear, true)
		mod.ComposterCommonBreak(tear, true)
	end
end, TearVariant.GRIDENT)

mod:AddCallback(ModCallbacks.MC_PRE_TEAR_GRID_COLLISION, function(_, tear)
	local composter = mod.composterIdFromPath[tear:GetSprite():GetFilename()]
	if composter then
		mod.composterBehaviour[tostring(composter)](tear, true)
		mod.ComposterCommonBreak(tear, true)
	end
end, TearVariant.GRIDENT)

mod:AddCallback(ModCallbacks.MC_PRE_TEAR_UPDATE, function(_, tear) -- Why no PRE_TEAR_FLOOR_COLLISION :(
	if tear.Height + tear.FallingSpeed > 0 and not tear:IsDead() then
		local composter = mod.composterIdFromPath[tear:GetSprite():GetFilename()]
		if composter then
			mod.composterBehaviour[tostring(composter)](tear, true)
			mod.ComposterCommonBreak(tear, true)
			return true
		end
	end
end, TearVariant.GRIDENT)

mod.RegisterComposter(mod.ComposterSubType.DEFAULT, "gfx/grid/composter/composter_knockback.anm2", function(entity, fromProjectile, unstable)
	game:ButterBeanFart(entity.Position, 280, entity, true, false)
	for _, enemy in pairs(Isaac.FindInRadius(entity.Position, 120, 0xffffffff)) do
		if enemy:IsEnemy() or enemy.Type == 1 then
			local enemyvec = (enemy.Position - entity.Position)
			local distance = 80 - enemyvec:Length()

			if enemy:IsEnemy() and not enemy:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
				enemy:AddConfusion(EntityRef(entity), math.ceil(30 + distance), false)
			end

			if not enemy:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK) then
				if enemy.Type ~= 1 then
					if enemy:ToNPC() and fromProjectile and unstable then
						enemy:ToNPC():ApplyTearflagEffects(entity.Position, TearFlags.TEAR_PUNCH, entity, 3.5)
					else
						enemy.Velocity = enemy.Velocity + enemyvec:Resized(15)
					end
				end
			end
		end
	end
end)

mod.RegisterComposter(mod.ComposterSubType.POISON, "gfx/grid/composter/composter_poison.anm2", function(entity)
	game:Fart(entity.Position, 80, entity, 1, 0)
	mod:FakeFart(entity, entity.Position)
end)

mod.RegisterComposter(mod.ComposterSubType.CHARMING, "gfx/grid/composter/composter_charm.anm2", function(entity)
	game:CharmFart(entity.Position, 120, entity)
end)

mod.RegisterComposter(mod.ComposterSubType.UNSTABLE, "gfx/grid/composter/composter_unstable.anm2", function(entity, fromProjectile)
	mod.composterBehaviour["0"](entity, fromProjectile, true)
end)

mod.RegisterComposter(mod.ComposterSubType.BRUISING, "gfx/grid/composter/composter_bruise.anm2", function(entity)
	for _, enemy in ipairs(Isaac.FindInRadius(entity.Position, 9999, EntityPartition.ENEMY | EntityPartition.PLAYER)) do
		if enemy:ToNPC() and mod:checkIfStatusLogicIsApplied(enemy, false) and not enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
			if enemy.Position:Distance(entity.Position) < enemy.Size * math.max(enemy.SizeMulti.X, enemy.SizeMulti.Y) + 120 then
				FiendFolio.AddBruise(enemy, entity, 120, 1, 1)
			end
		elseif enemy.Type == 1 and enemy.Position:Distance(entity.Position) < enemy.Size * math.max(enemy.SizeMulti.X, enemy.SizeMulti.Y) + 120 then
			local data = mod:GetEntityData(enemy)
			data.lastComposterBruise = enemy.FrameCount
		end
	end

	game:ButterBeanFart(entity.Position, 120, entity, false, false)
	local fartCloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 0, entity.Position, Vector.Zero, entity)
	local fartSprite = fartCloud:GetSprite()
	fartSprite.Color = Color(0.4, 0.4, 0.4, 1.0, 40/255, 0/255, 40/255, 1.0, 1.0, 1.0, 1)
end)

mod.RegisterComposter(mod.ComposterSubType.HOLY, "gfx/grid/composter/composter_excommunicate.anm2", function(entity, fromProjectile)
	if not game:GetRoom():IsClear() then
		for _, enemy in ipairs(Isaac.FindInRadius(entity.Position, 9999, EntityPartition.ENEMY)) do
			if enemy:IsVulnerableEnemy() and mod:checkIfStatusLogicIsApplied(enemy, false) and not enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
				if enemy.Position:Distance(entity.Position) < enemy.Size * math.max(enemy.SizeMulti.X, enemy.SizeMulti.Y) + 120 then
					FiendFolio.AddExcommunicated(enemy, entity, 90, (fromProjectile and entity.CollisionDamage) or 40, nil, true, true)
				end
			end
		end
	end

	game:ButterBeanFart(entity.Position, 120, entity, false, false)
	local fartCloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 0, entity.Position, Vector.Zero, entity)
	local fartSprite = fartCloud:GetSprite()
	fartSprite.Color = Color(1.3, 1.3, 1.3, 1.0, 0/255, 30/255, 45/255, 1.0, 1.0, 1.0, 1)
end)