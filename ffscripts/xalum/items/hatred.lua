local mod = FiendFolio
local sfx = SFXManager()

local hatred = mod.ITEM.TRINKET.HATRED
local hatredFamiliar = mod.ITEM.FAMILIAR.HATRED

local RECOVER_COOLDOWN = 30
local REFORM_COOLDOWN = 9

TearFlagsLib.RegisterWeapon("FF_HATRED")
TearFlagsLib.RegisterWeaponIdentityFunction(TearFlagsLib.WeaponFlag.FF_HATRED, function(entity)
	return entity.Type == 3 and entity.Variant == hatredFamiliar
end)

mod.CAN_OF_BEANS.FART_COOLDOWN_PER_ENEMY = mod.CAN_OF_BEANS.FART_COOLDOWN_PER_ENEMY | TearFlagsLib.WeaponFlag.FF_HATRED
mod.GAY_GARNET.DO_APPLY_EFFECTS = mod.GAY_GARNET.DO_APPLY_EFFECTS | TearFlagsLib.WeaponFlag.FF_HATRED
mod.CHEMICAL_COOKIE.ROLL_ON_HIT = mod.CHEMICAL_COOKIE.ROLL_ON_HIT | TearFlagsLib.WeaponFlag.FF_HATRED
mod.CHEMICAL_COOKIE.PER_ENTITY_COOLDOWN = mod.CHEMICAL_COOKIE.PER_ENTITY_COOLDOWN | TearFlagsLib.WeaponFlag.FF_HATRED

local function RecalcThresholds(familiar)
	local data = mod:GetEntityData(familiar)
	data.fireCooldown = math.floor(familiar.Player.MaxFireDelay)
	data.fireFrameThreshold = data.fireCooldown - 2
	data.lookFrameThreshold = data.fireCooldown - 12
end

local function getHatredCollisionDamage(player) -- BFFS! is handled automatically, but if anything else should increase this it can be handled here
	return 15
end

function mod.TryLaunchHatredFamiliars(player)
	local fireDirection = mod.GetCorrectedFiringInput(player)

	if fireDirection:Length() > 0.5 then
		for _, familiar in pairs(Isaac.FindByType(3, hatredFamiliar)) do
			local data = mod:GetEntityData(familiar)

			if not data.isFlying and not data.recovering and not data.reforming and GetPtrHash(familiar.SpawnerEntity) == GetPtrHash(player) then
				data.isFlying = fireDirection:Normalized()
				familiar.Velocity = data.isFlying * 9
				familiar.CollisionDamage = getHatredCollisionDamage(player)
				familiar.GridCollisionClass = player.CanFly and EntityGridCollisionClass.GRIDCOLL_WALLS or EntityGridCollisionClass.GRIDCOLL_NOPITS
				sfx:Play(mod.Sounds.FireballLaunch, 0.4, 0, false, math.random(90, 110)/100)
			end
		end
	end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if player.Variant == 0 then
		player:CheckFamiliar(hatredFamiliar, player:GetTrinketMultiplier(hatred) + player:GetEffects():GetTrinketEffectNum(hatred), player:GetTrinketRNG(hatred), Isaac.GetItemConfig():GetTrinket(hatred))
	end
end, CacheFlag.CACHE_FAMILIAR)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, familiar)
	familiar:GetSprite():Play("IdleDown")

	local data = mod:GetEntityData(familiar)
	data.cachedFiringDirection = "Down"
	data.cachedMovementDirection = "Down"

	RecalcThresholds(familiar)
end, hatredFamiliar)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
	local data = mod:GetEntityData(familiar)
	local sprite = familiar:GetSprite()
	local player = familiar.Player

	familiar.FireCooldown = familiar.FireCooldown - 1
	familiar.SpriteOffset = Vector(0, -7)

	if not data.recovering and not data.reforming then
		if data.isFlying --[[or familiar.FrameCount % 3 == 1]] then
			local creep = Isaac.Spawn(1000, 45, 0, familiar.Position, Vector.Zero, familiar):ToEffect()
			creep.Scale = 0.65
			creep:SetTimeout(15)
			creep:Update()
		end
	end

	if not data.isFlying then
		familiar.GridCollisionClass = player.CanFly and EntityGridCollisionClass.GRIDCOLL_WALLS or EntityGridCollisionClass.GRIDCOLL_GROUND
	end

	if data.isFlying then
		familiar.Velocity = familiar.Velocity + data.isFlying

		TearFlagsLib.WipeTearFlags(familiar)

		local vanillaFlags, damage = TearFlagsLib.PollVanillaTearFlags(player)
		familiar.CollisionDamage = getHatredCollisionDamage(player) * (damage / player.Damage)
		TearFlagsLib.AddCustomVanillaTearFlags(familiar, vanillaFlags)
		TearFlagsLib.SetCustomVanillaTearFlagParams(familiar, {
			DamageOverride = player.Damage * 0.55 * familiar:GetMultiplier(),
			ScaleOverride = 0.5,
			ColorOverride = mod.ColorDankBlackReal,
		})

		local colorBefore = familiar.Color
		TearFlagsLib.CallPollTearFlagCallback(familiar, player, TearFlagsLib.WeaponFlag.FF_HATRED)
		familiar.Color = colorBefore

		local flightDirection = mod.GetStringDirectionFromVector(familiar.Velocity)
		sprite:Play("Fly" .. flightDirection)

		if familiar:CollidesWithGrid() then
			data.recovering = true
			data.isFlying = nil
			familiar.Visible = false
			familiar.FireCooldown = RECOVER_COOLDOWN
			familiar.CollisionDamage = 0

			local creep = Isaac.Spawn(1000, 45, 0, familiar.Position, Vector.Zero, familiar):ToEffect()
			creep.SpriteScale = creep.SpriteScale * 1.5
			creep:SetTimeout(45)
			creep:Update()

			local malicePoof = Isaac.Spawn(mod.FF.BallOfMalice.ID, mod.FF.BallOfMalice.Var, mod.FF.BallOfMalice.Sub, familiar.Position, Vector.Zero, familiar)
			mod:GetEntityData(malicePoof).HatredHijacked = true
			malicePoof:GetSprite():Play("Poof")
			malicePoof.SpriteScale = malicePoof.SpriteScale / 2
			malicePoof.SpriteOffset = familiar.SpriteOffset + Vector(0, -8)

			sfx:Play(SoundEffect.SOUND_MEATY_DEATHS, 0.6, 0, false, 0.8)
		end
	elseif data.recovering or data.reforming then
		familiar.Visible = false
		familiar:FollowParent()

		sprite:Play("IdleDown")

		if data.malicePoof then
			data.malicePoof.Velocity = familiar.Position - data.malicePoof.Position
		end

		if familiar.FireCooldown < 0 then
			if data.recovering then
				data.recovering = false
				data.reforming = true
				familiar.FireCooldown = REFORM_COOLDOWN

				local malicePoof = Isaac.Spawn(mod.FF.BallOfMalice.ID, mod.FF.BallOfMalice.Var, mod.FF.BallOfMalice.Sub, familiar.Position, Vector.Zero, familiar):ToEffect()
				mod:GetEntityData(malicePoof).HatredHijacked = true
				malicePoof:GetSprite():Play("PoofReverse")
				malicePoof.SpriteScale = malicePoof.SpriteScale / 2
				malicePoof.SpriteOffset = familiar.SpriteOffset + Vector(0, -8)

				data.malicePoof = malicePoof
			elseif data.reforming then
				data.reforming = false
				data.malicePoof = nil
				familiar.Visible = true
			end
		end
	else
		local movement = player:GetMovementVector():Normalized()
		local shooting = mod.GetCorrectedFiringInput(player)
		local movementAnimDirection = mod.GetStringDirectionFromVector(movement)
		local shootingAnimDirection = mod.GetStringDirectionFromVector(shooting)

		local myAnimation = "Idle"
		local myAnimationDirection = "Down"

		if mod.IsPlayerTryingToShoot(player) then
			myAnimationDirection = shootingAnimDirection
			if shootingAnimDirection ~= data.cachedFiringDirection then
				data.cachedFiringDirection = shootingAnimDirection
			end

			if familiar.FireCooldown < 0 then
				RecalcThresholds(familiar)
				familiar.FireCooldown = data.fireCooldown

				-- local tear = familiar:FireProjectile(shooting * player.ShotSpeed)
				mod.IsHatredTear = familiar
				local tear = player:FireTear(familiar.Position, shooting * player.ShotSpeed * 10 + player:GetTearMovementInheritance(shooting), false, true, false, familiar)
				mod.IsHatredTear = nil
				tear.CollisionDamage = tear.CollisionDamage * 0.55 * familiar:ToFamiliar():GetMultiplier()
				tear:AddTearFlags(TearFlags.TEAR_SLOW | TearFlags.TEAR_GISH)

				mod:makeTearBloody(tear)
				tear.Color = mod.ColorDankBlackReal

				mod:SecondaryFire(player, shooting, 1, familiar, {DoBasegameEffects = true, Hatred = familiar})

				data.cachedFiringDirection = myAnimationDirection
			end
		end

		familiar.Velocity = familiar.Velocity * 0.8
		if movement:Length() > 0 and not Input.IsActionPressed(ButtonAction.ACTION_DROP, player.ControllerIndex) then
			myAnimation = "Walk"
			myAnimationDirection = movementAnimDirection

			familiar.Velocity = familiar.Velocity + movement * 1.75 * player.MoveSpeed
		end

		for _, other in pairs(Isaac.FindByType(3, hatredFamiliar)) do
			if other.Position:Distance(familiar.Position) < familiar.Size + other.Size then
				local push = (familiar.Position - other.Position):Normalized()
				familiar.Velocity = familiar.Velocity + push
				other.Velocity = other.Velocity + push
			end
		end

		local oldAnim = sprite:GetAnimation()
		local oldFrame = sprite:GetFrame()
		local myAnim = myAnimation

		if familiar.FireCooldown > data.lookFrameThreshold then
			myAnim = myAnim .. data.cachedFiringDirection
		else
			myAnim = myAnim .. myAnimationDirection
		end

		if familiar.FireCooldown > data.fireFrameThreshold then
			myAnim = myAnim .. "Shoot"
		end

		sprite:Play(myAnim)
		if myAnim ~= oldAnim then
			sprite:SetFrame(oldFrame)
		end
	end
end, hatredFamiliar)

function mod:handleHatredSecondaryFireTearEffects(tear)
	if mod.IsHatredTear then
		tear.CollisionDamage = tear.CollisionDamage * 0.75 * 0.55 * mod.IsHatredTear:ToFamiliar():GetMultiplier()
		tear:AddTearFlags(TearFlags.TEAR_SLOW | TearFlags.TEAR_GISH)
		mod:makeTearBloody(tear)
		tear.Color = mod.ColorDankBlackReal
	end
end
mod:AddCallback(FiendFolio.CALLBACK.FF_POST_FIRE_SECONDARY_TEAR, mod.handleHatredSecondaryFireTearEffects)

mod:AddPriorityTrinketCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -1 * math.huge, hatred, function(_, entity, amount, flags, source, cooldown)
	if TearFlagsLib.AntiRecursion then return end

	if source.Type == 3 and source.Variant == hatredFamiliar then
		local data = mod:GetEntityData(source.Entity)
		if not data.isFlying then return end

		local damageFlags = TearFlagsLib.GetVanillaTearFlagDamageFlags(source.Entity)
		local damageMult = 1
		local damageAdd = 0
		local damageFlat = 0

		TearFlagsLib.GetTearFlags(source.Entity):ForEach(function(flag)
			local params = TearFlagsLib.GetTearFlagParams(source.Entity, flag)
			if params.DamageParams then
				damageFlags	= damageFlags 	| (params.DamageParams.DamageFlags or 0)
				damageMult 	= damageMult 	* (params.DamageParams.DamageMult or 1)
				damageAdd 	= damageAdd 	+ (params.DamageParams.ExtraDamage or 0)
				damageFlat 	= damageFlat 	+ (params.DamageParams.ExtraDamageFlat or 0)
			end
		end)

		return {
			Damage = (amount + damageAdd) * damageMult + damageFlat,
			DamageFlags = flags | damageFlags
		}
	end
end)

mod:AddTrinketCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, hatred, function(_, entity, amount, flags, source, cooldown)
	if TearFlagsLib.AntiRecursion then return end

	if source.Type == 3 and source.Variant == hatredFamiliar then
		local data = mod:GetEntityData(source.Entity)
		if not data.isFlying then return end
		local player = source.Entity:ToFamiliar().Player

		local recursionKey = TearFlagsLib.SetAntiRecursion()
		TearFlagsLib.CallTearFlagCallback(entity, player, source.Entity, TearFlagsLib.WeaponFlag.FF_HATRED, true)
		TearFlagsLib.ClearAntiRecursion(recursionKey)
	end
end)