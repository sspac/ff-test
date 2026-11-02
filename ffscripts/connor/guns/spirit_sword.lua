local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local FRIEND_SPIRIT_SWORD = {
	SwingDamageMult = 2,  -- 3
	SwingFlatDamage = 3.5,  -- 3.5

	ChargeDamageMult = 4,
	ChargeFlatDamage = 7,

	ChargeBulletScaleMult = 1.5,
	ChargeBulletDamageMult = 2,

	SpinDamageMult = 6,  -- 8
	SpinFlatDamage = 10,  -- 10

	ExplosionSpriteScale = Vector(0.65, 0.65),
	ExplosionRadius = 40,
	ExplosionDamageMult = 1,
	ExplosionFlatDamage = 3.5,
}

local SWING_ANIM = "AttackRight"
local SPIN_ANIM = "SpinRight"

-- Frames required for a Lv1 charge attack.
local function GetSwordLv1Charge(player)
	return 40
end

-- Frames required for a Lv2 charge attack (spin).
local function GetSwordLv2Charge(player)
	return 120
end

local function ResetChargeBar(player)
	local pd = mod:GetEntityData(player)

	if pd.customChargeBarSprites then
		local chargeBarSpriteExists = pd.customChargeBarSprites[CollectibleType.COLLECTIBLE_SPIRIT_SWORD] or pd.customChargeBarSprites[CollectibleType.COLLECTIBLE_BERSERK]
		if not chargeBarSpriteExists then
			mod:EvaluateExtraChargeBar(player)
		end
		if chargeBarSpriteExists and pd.customChargeBarTable then
			for key,entry in pairs(pd.customChargeBarTable) do
				if entry.id == CollectibleType.COLLECTIBLE_SPIRIT_SWORD or entry.id == CollectibleType.COLLECTIBLE_BERSERK then
					entry.spriteFrame = 0
				end
			end
		end
	end
end

--[[mod:AddCallback("POST_GUN_UPDATE", function(_, gun, player)
	local gd = mod:GetEntityData(gun)
	
	if not gd.KNIFE or not gd.KNIFE:Exists() then
		local knife = player:FireKnife(gun, 0, true, 0, 0)
		gd.KNIFE = knife
	end
	local knife = gd.KNIFE
	local spr = knife:GetSprite()
	knife.Rotation = gun.SpriteRotation
	spr.FlipX = gun:GetSprite().FlipX
end)

mod:AddCallback("POST_GUN_FIRE", function(_, gun, player)
	local gd = mod:GetEntityData(gun)
	
	if gd.KNIFE and gd.KNIFE:Exists() then
		gd.KNIFE:Shoot(1, 100)
	end
end)]]

function mod:FriendSpiritSwordTriggerSlash(gun, spinAttack)
	local player, parent = mod:GetFriendGunPlayer(gun)

	local gd = mod:GetEntityData(gun)

	local sprite = gun:GetSprite()

	if spinAttack then
		sprite:Play(SPIN_ANIM, true)
		gd.MeleeSwingAngle = gd.CurrentAngle
	else
		if gd.state == "Reload" and gd.FriendSpiritSwordReloadFlipped then
			sprite.FlipY = true
		elseif sprite:GetAnimation() == SWING_ANIM then
			sprite.FlipY = not sprite.FlipY
		end
		sprite:Play(SWING_ANIM, true)
	end
	if spinAttack then
		sfx:Play(SoundEffect.SOUND_SWORD_SPIN, 1.0, 0, false, mod:RandomFloat(0.9, 1.1))
	else
		sfx:Play(SoundEffect.SOUND_SHELLGAME, 1.0, 0, false, mod:RandomFloat(1.1, 1.3))
	end
	gd.state = "MeleeAttack"
	mod:GunMovement(gun, true)

	mod:SubtractLimitedAmmo(gd)

	mod:GetEntityData(player).FriendHeldGuns[gun.InitSeed].LastFrameFired = gun.FrameCount
end

local function preGunFire(_, gun, player, aim, held)
	local pd = mod:GetEntityData(player)
	local gd = mod:GetEntityData(gun)

	if player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) and not gd.IsFriendSoulGun then
		return
	end

	if gd.FriendSwordChargeAttack then
		if gd.state == "Idle" or gd.state == "Reload" then
			gd.FriendSwordChargeAttack = nil
		else
			return true
		end
	end

	local gunTable = pd.FriendHeldGuns[gun.InitSeed]

	local marked = mod.IsPlayerMarkedFiring(player)

	if held or marked then
		pd.FriendSwordHeld = true
		if #gunTable.Ammo > 0 then
			if not pd.FriendSwordCharge then
				pd.FriendSwordCharge = 0
				ResetChargeBar(player)
			end
		else
			pd.FriendSwordCharge = nil
		end
	end

	if not held or marked then
		mod:FriendSpiritSwordTriggerSlash(gun)
		local _, _, owner = mod:GetFriendGunPlayer(gun)
		mod:FriendSecondaryFire(player, aim, 1, owner, gun, {{Index = 1, HeartKey = "RED_HEART", LastInHeart = true, HealthPosition = {1, 1}, HeartType = "Red"}})
		pd.FriendSwordReleased = not held
	end

	return true
end
mod:AddPriorityCallback("PRE_GUN_FIRE", CallbackPriority.EARLY-1, preGunFire, CollectibleType.COLLECTIBLE_SPIRIT_SWORD)
mod:AddPriorityCallback("PRE_GUN_FIRE", CallbackPriority.EARLY-1, preGunFire, CollectibleType.COLLECTIBLE_BERSERK)

local function preGunFireSound(_, gun, player)
	return true
end
mod:AddCallback("PRE_GUN_FIRE_SOUND", preGunFireSound, CollectibleType.COLLECTIBLE_SPIRIT_SWORD)
mod:AddCallback("PRE_GUN_FIRE_SOUND", preGunFireSound, CollectibleType.COLLECTIBLE_BERSERK)

local storedGun, storedAmmoUsed
function mod:FriendSpiritSwordTriggerChargedAttack(gun, aim)
	local player, parent = mod:GetFriendGunPlayer(gun)

	local pd = mod:GetEntityData(player)
	local gd = mod:GetEntityData(gun)

	local gunTable = pd.FriendHeldGuns[gun.InitSeed]

	local spinAttack = pd.FriendSwordCharge and pd.FriendSwordCharge >= GetSwordLv2Charge(player) and #gunTable.Ammo > 1
	local ammoToUse = spinAttack and 2 or 1
	local ammoUsed = {}

	for i=1, ammoToUse do
		local shot = mod:GetFriendGunNextShot(gun)
		table.insert(ammoUsed, shot)
	end

	local flipped = gun:GetSprite().FlipY
	local numShots = spinAttack and 6 or 1
	local soulGun = mod:IsFriendSoulGun(gun)
	local doExplosions = (pd.FriendsRevolver and gun.InitSeed == pd.FriendsRevolver.InitSeed) or gd.OwnedByFetus or soulGun

	local _, _, owner = mod:GetFriendGunPlayer(gun)
	local isFetusGun = gun.Parent and gun.Parent.Type == EntityType.ENTITY_TEAR and gun.Parent.Variant == TearVariant.FETUS
	local beeSkinMult = (isFetusGun and TearFlagsLib.HasTearFlags(gun.Parent, TearFlagsLib.Flag.BEE_SKIN) and 0.3) or 1
	for i=0, numShots-1 do
		local shotAim = aim:Rotated((360 * i / numShots + (spinAttack and (-360/numShots*0) or 0)) * (flipped and -1 or 1))
		local delay = 1 + i * 2
		local shot = ammoUsed[(i % #ammoUsed) + 1]
		mod.scheduleForUpdate(function()
			if doExplosions then
				sfx:Play(SoundEffect.SOUND_GFUEL_GUNSHOT_SPREAD, 1.0, 0, false, mod:RandomFloat(0.85, 1.15))
				local explosionPos = mod:GetFriendGunShootPos(gun, shotAim)
				local explosion = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, explosionPos, mod.nilvector, nil):ToEffect()
				explosion.SpriteScale = FRIEND_SPIRIT_SWORD.ExplosionSpriteScale
				for _, enemy in ipairs(Isaac.FindInRadius(explosionPos, FRIEND_SPIRIT_SWORD.ExplosionRadius, EntityPartition.ENEMY)) do
					if enemy:IsActiveEnemy() and not mod:isFriend(enemy) and not mod.IsEnemyReallyInvulnerable(enemy) then
						local damage = (player.Damage * FRIEND_SPIRIT_SWORD.ExplosionDamageMult + FRIEND_SPIRIT_SWORD.ExplosionFlatDamage) * ((isFetusGun and mod.FRIEND_C_SECTION.DAMAGE_MULT) or 1) * beeSkinMult
						enemy:TakeDamage(damage, DamageFlag.DAMAGE_EXPLOSION, EntityRef(player), 0)
					end
				end
				--game:BombExplosionEffects(explosionPos, player.Damage, TearFlags.TEAR_NORMAL, Color.Default, player, 0.65, false, false, DamageFlag.DAMAGE_EXPLOSION)
			end
			mod.IgnoreStardust = true
			mod.SecondaryFireTearEffectFriendGun = gun
			mod.SecondaryFireTearEffectFriendAmmoUsed = ammoUsed
			local bullet = mod:FireFriendTear(gun, player, shotAim, mod.nilvector, shotAim:Resized(player.ShotSpeed * 10), shot, false, nil, false)
			mod.IgnoreStardust = false
			mod.SecondaryFireTearEffectFriendGun = nil
			mod.SecondaryFireTearEffectFriendAmmoUsed = nil
			bullet.CollisionDamage = bullet.CollisionDamage * FRIEND_SPIRIT_SWORD.ChargeBulletDamageMult * ((isFetusGun and mod.FRIEND_C_SECTION.DAMAGE_MULT) or 1) * beeSkinMult
			bullet.Scale = bullet.Scale * FRIEND_SPIRIT_SWORD.ChargeBulletScaleMult

			mod:FriendSecondaryFire(player, shotAim, 1, owner, gun, ammoUsed, {IsFriendChargedSlash = true, IsSpinAttack = spinAttack, FriendChargedSlashIndex = i})
		end, delay)
	end

	mod:FriendSpiritSwordTriggerSlash(gun, spinAttack)
	gd.FriendSwordChargeAttack = true
end

local function gunHoldRelease(_, gun, player, aim)
	local pd = mod:GetEntityData(player)

	if pd.FriendSwordHeld and pd.FriendSwordCharge and pd.FriendSwordCharge >= GetSwordLv1Charge(player) then
		mod:FriendSpiritSwordTriggerChargedAttack(gun, aim)
	end

	pd.FriendSwordReleased = true
end
mod:AddCallback("GUN_HOLD_RELEASE", gunHoldRelease, CollectibleType.COLLECTIBLE_SPIRIT_SWORD)
mod:AddCallback("GUN_HOLD_RELEASE", gunHoldRelease, CollectibleType.COLLECTIBLE_BERSERK)

mod:AddCallback(ModCallbacks.MC_PRE_KNIFE_UPDATE, function(_, knife)
	local data = mod:GetEntityData(knife)

	if not data.FriendGun then return end

	local gun = mod:GetPointee(data.FriendGun)

	if not gun then
		knife:Remove()
		return
	end

	if gun.Parent and gun.Parent.Type == EntityType.ENTITY_TEAR and gun.Parent:ToTear():HasTearFlags(TearFlags.TEAR_LUDOVICO) then
		gun.Parent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	end

	local gunSpr = gun:GetSprite()
	local spr = knife:GetSprite()

	knife.Position = gun.Position + gunSpr.Offset
	local anim = gunSpr:GetAnimation()
	spr:Play(anim, true)
	spr:SetFrame(gunSpr:GetFrame())
	spr.PlaybackSpeed = 0
	spr.FlipX = gunSpr.FlipX
	spr.FlipY = gunSpr.FlipY
	spr.Scale = gunSpr.Scale
	spr.Rotation = gunSpr.Rotation
	if anim == SPIN_ANIM then
		spr.Rotation = spr.Rotation - 180  -- Animation is rotated 180 degrees at the root but the spirit sword hitboxes don't respect that.
	end

	if spr.FlipY ~= spr.FlipX then
		spr.Rotation = -spr.Rotation
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, function(_, knife)
	local data = mod:GetEntityData(knife)

	if not data.FriendGun then return end

	local gun = mod:GetPointee(data.FriendGun)

	if not gun then
		knife:Remove()
		return
	end

	if gun.Parent and gun.Parent.Type == EntityType.ENTITY_TEAR and gun.Parent:ToTear():HasTearFlags(TearFlags.TEAR_LUDOVICO) then
		gun.Parent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
	end

	local spr = knife:GetSprite()

	local nullFrame = spr:GetNullFrame("Hit")
	if nullFrame and nullFrame:IsVisible() then
		local capsule = knife:GetNullCapsule("Hit")
		local player = mod:GetFriendGunPlayer(gun)
		if player then
			for i, fireball in pairs(mod:GetEntityData(player).friendFireballs or {}) do
				if capsule:Collide(fireball:GetCollisionCapsule(), Vector(0,0)) then
					fireball.Velocity = (fireball.Position - player.Position):Resized(50)
					local d = mod:GetEntityData(fireball)
					d.SuperExplode = true
					d.HitDirection = (fireball.Position - player.Position):Normalized()
				end
			end
		end
	end
end)

mod:AddPriorityCallback("POST_GUN_UPDATE", CallbackPriority.IMPORTANT, function(_, gun, player)
	local pd = mod:GetEntityData(player)
	local gd = mod:GetEntityData(gun)

	if gun.SubType == CollectibleType.COLLECTIBLE_SPIRIT_SWORD or gun.SubType == CollectibleType.COLLECTIBLE_BERSERK then
		local sprite = gun:GetSprite()
		if gd.state == "MeleeAttack" then
			if not sprite:IsPlaying(SWING_ANIM) and not sprite:IsPlaying(SPIN_ANIM) then
				if sprite:IsFinished(SWING_ANIM) then
					sprite.FlipY = not sprite.FlipY
					sprite.Rotation = -sprite.Rotation
				end
				gd.state = "Idle"
				mod:spritePlay(sprite, "Idle")
				gd.CurrentAngle = gd.MeleeSwingAngle
				gd.MeleeSwingAngle = nil
				if gd.SwordSwing then
					gd.SwordSwing:Remove()
					gd.SwordSwing = nil
				end
			elseif sprite:GetFrame() == 0 or (gd.OwnedByFetus and sprite:GetFrame() == 1) then
				if gd.SwordSwing then
					gd.SwordSwing:Remove()
				end
				local knife = Isaac.Spawn(EntityType.ENTITY_KNIFE, KnifeVariant.SPIRIT_SWORD, KnifeSubType.CLUB_HITBOX, gun.Position, mod.nilvector, player):ToKnife()
				knife:GetSprite():Load(gun:GetSprite():GetFilename(), true)
				knife:GetSprite().PlaybackSpeed = 0
				knife.Visible = false
				knife:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				-- The melee hit will pass this Parent as the damage source, which is relevant if the parent is not the player.
				-- I don't think this is actually a problem, just taking note of it. It still seems to correctly inherent player attributes so long as it has a player SpawnerEntity?
				knife.Parent = gun.Parent
				knife.SpawnerEntity = player
				mod:GetEntityData(knife).FriendGun = EntityPtr(gun)
				knife:SetIsSwinging(true)
				
				local params = player:GetTearHitParams(WeaponType.WEAPON_SPIRIT_SWORD)
				local isSpinAttacking = sprite:IsPlaying(SPIN_ANIM)
				local isFetusGun = gun.Parent and gun.Parent.Type == EntityType.ENTITY_TEAR and gun.Parent.Variant == TearVariant.FETUS
				local beeSkinMult = (isFetusGun and TearFlagsLib.HasTearFlags(gun.Parent, TearFlagsLib.Flag.BEE_SKIN) and 0.3) or 1
				if sprite:IsPlaying(SPIN_ANIM) then
					knife:SetIsSpinAttack(true)
					local targetDamage = params.TearDamage * FRIEND_SPIRIT_SWORD.SpinDamageMult + FRIEND_SPIRIT_SWORD.SpinFlatDamage
					knife.CollisionDamage = (targetDamage * ((isFetusGun and mod.FRIEND_C_SECTION.DAMAGE_MULT) or 1) * beeSkinMult - 10) / 8
				else
					local targetDamage
					if gd.FriendSwordChargeAttack then
						targetDamage = params.TearDamage * FRIEND_SPIRIT_SWORD.ChargeDamageMult + FRIEND_SPIRIT_SWORD.ChargeFlatDamage
					else
						targetDamage = params.TearDamage * FRIEND_SPIRIT_SWORD.SwingDamageMult + FRIEND_SPIRIT_SWORD.SwingFlatDamage
					end
					knife.CollisionDamage = (targetDamage * ((isFetusGun and mod.FRIEND_C_SECTION.DAMAGE_MULT) or 1) * beeSkinMult - 3.5) / 3
				end
				knife.TearFlags = params.TearFlags
				TearFlagsLib.CallPollTearFlagCallback(knife, player, TearFlagsLib.WeaponFlag.SWORD)
				knife.Color = Color()

				gd.SwordSwing = knife
			elseif sprite:IsPlaying(SPIN_ANIM) then
				gd.PreviousFireFrame = gun.FrameCount
			end
		end

		if gd.FriendSwordChargeAttack and (gd.state == "Idle" or gd.state == "Reload") then
			gd.FriendSwordChargeAttack = nil
		end

		if gd.FriendSpiritSwordReloadStarted then
			if sprite.FlipY ~= (gd.CurrentAngle > 90 and gd.CurrentAngle <= 270) and gd.state == "Reload" and gd.substate == "Begin" then
				sprite.FlipY = not sprite.FlipY
				gd.substate = "Begin_SpiritSwordFlipped"
				sprite:Play("BeginReloadFlipped", true)
				mod:GunMovement(gun, false)
				gd.FriendSpiritSwordReloadFlipped = true
			end
			gd.FriendSpiritSwordReloadStarted = nil
		end

		if gd.FriendSpiritSwordReloadFlipped then
			if gd.state ~= "Reload" then
				gd.FriendSpiritSwordReloadFlipped = nil
			elseif sprite:IsFinished("BeginReloadFlipped") then
				gd.substate = "Begin"
				sprite:Play("BeginReload", true)
				sprite:SetLastFrame()
			end
		end

		if gd.isFriendMultishotGun and pd.FriendsRevolver and pd.FriendsRevolver:Exists() and pd.FriendsRevolver:GetSprite().FlipY ~= sprite.FlipY then
			sprite.FlipY = not sprite.FlipY
			sprite.Rotation = -sprite.Rotation
		end
	else
		if gd.state == "MeleeAttack" then
			gd.state = "Idle"
		end
		if gd.SwordSwing then
			gd.SwordSwing:Remove()
			gd.SwordSwing = nil
		end
		--[[if pd.FriendSwordHeld or pd.FriendSwordCharge then
			pd.FriendSwordHeld = nil
			pd.FriendSwordCharge = nil
		end]]
	end
end)

local function preGunStartReload(_, gun, player)
	local gd = mod:GetEntityData(gun)
	gd.FriendSpiritSwordReloadStarted = true
end
mod:AddCallback("PRE_GUN_START_RELOAD", preGunStartReload, CollectibleType.COLLECTIBLE_SPIRIT_SWORD)
mod:AddCallback("PRE_GUN_START_RELOAD", preGunStartReload, CollectibleType.COLLECTIBLE_BERSERK)

local function preReloadShot(_, gun, player)
	local gd = mod:GetEntityData(gun)
	gd.FriendSpiritSwordReloadStarted = nil
	gd.FriendSpiritSwordReloadFlipped = nil
end
mod:AddCallback("GUN_RELOAD_SHOT", preReloadShot, CollectibleType.COLLECTIBLE_SPIRIT_SWORD)
mod:AddCallback("GUN_RELOAD_SHOT", preReloadShot, CollectibleType.COLLECTIBLE_BERSERK)

local function postGunFinishedReload(_, gun, player)
	local gd = mod:GetEntityData(gun)
	gd.FriendSpiritSwordReloadStarted = nil
	gd.FriendSpiritSwordReloadFlipped = nil
	if gd.CurrentAngle > 90 and gd.CurrentAngle <= 270 then
		local sprite = gun:GetSprite()
		mod:spritePlay(sprite, "Idle")
		sprite.FlipY = true
		mod:GunMovement(gun, false)
	end
end
mod:AddCallback("POST_GUN_FINISHED_RELOAD", postGunFinishedReload, CollectibleType.COLLECTIBLE_SPIRIT_SWORD)
mod:AddCallback("POST_GUN_FINISHED_RELOAD", postGunFinishedReload, CollectibleType.COLLECTIBLE_BERSERK)

function mod:FriendSwordPeffect(player, pd)
	if pd.FriendSwordReleased then
		pd.FriendSwordReleased = nil
		pd.FriendSwordHeld = nil
		pd.FriendSwordCharge = nil
	end
end

--[[local function GetHitCapsule(ent, layer)
	layer = layer or "Hit"

	local sprite = ent:GetSprite()

	-- Don't return anything if there is no NullFrame on the current frame.
	local nullFrame = sprite:GetNullFrame(layer)
	if not nullFrame or not nullFrame:IsVisible() then return end

	local flipRotation = sprite.FlipY ~= sprite.FlipX
	local offset = sprite.Offset

	-- Adjust a couple of values before getting the capsule since at time of writing I can't tweak the capsule manually.
	if flipRotation then
		sprite.Rotation = -sprite.Rotation
	end
	ent.Position = ent.Position + offset

	local capsule = ent:GetNullCapsule(layer)

	-- Reverse the adjustments we made
	ent.Position = ent.Position - offset
	if flipRotation then
		sprite.Rotation = -sprite.Rotation
	end

	if capsule and game:GetDebugFlags() & DebugFlag.HITSPHERES ~= 0 then
		--local d = DebugRenderer.Get(ent.InitSeed)
		--d:Capsule(capsule)
	end

	return capsule
end]]

function mod.FriendSwordBarConditionFunc(player, d, entry)
	local anySoul = false
	
	local guns = mod:MergeArrays(
		mod:GetGunsOfSubtype(player, CollectibleType.COLLECTIBLE_SPIRIT_SWORD),
		mod:GetGunsOfSubtype(player, CollectibleType.COLLECTIBLE_BERSERK)
	)
	for _, gun in ipairs(guns) do
		if mod:IsFriendSoulGun(gun.Gun) then
			anySoul = true
			break
		end
	end
	
	return (
		mod.IsPlayerShootingOrMarked(player)
		and #guns > 0
		and d.FriendSwordHeld
		and d.FriendSwordCharge
		and (not player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION) or anySoul)
	)
end

function mod.FriendSwordBarAnimFunc(player, pd, sprite, entry)
	if entry then
		if not entry.timer then
			entry.timer = 0
			entry.initialDelay = 0
			entry.chargeLayer = 1
		end

		if entry.timer < 0 and mod.IsPlayerShootingOrMarked(player) then
			entry.timer = 0
		end

		local guns = mod:MergeArrays(
			mod:GetGunsOfSubtype(player, CollectibleType.COLLECTIBLE_SPIRIT_SWORD),
			mod:GetGunsOfSubtype(player, CollectibleType.COLLECTIBLE_BERSERK)
		)
		local highestAmmo = 0
		for _, gun in ipairs(guns) do
			local ammo = #gun.Ammo

			if highestAmmo < ammo then
				highestAmmo = ammo
			end
		end

		local levelOne = GetSwordLv1Charge(player)
		local levelTwo = GetSwordLv2Charge(player)

		local lastCharge = pd.FriendSwordCharge
		pd.FriendSwordCharge = pd.FriendSwordCharge + 1
		if highestAmmo >= 2 then
			pd.FriendSwordCharge = math.min(pd.FriendSwordCharge, levelTwo)
		elseif highestAmmo == 1 then
			pd.FriendSwordCharge = math.min(pd.FriendSwordCharge, levelOne)
		else
			pd.FriendSwordCharge = 0
		end
		local charge = pd.FriendSwordCharge

		if charge >= levelTwo then
			if lastCharge ~= levelTwo then
				sprite:SetOverlayRenderPriority(false)
				sprite:PlayOverlay("StartCharged2", true)
			end
			mod:spritePlay(sprite, "Charged2")
		elseif charge == levelOne then
			if lastCharge ~= levelOne then
				sprite:SetOverlayRenderPriority(false)
				sprite:PlayOverlay("StartCharged1", true)
			end
			mod:spritePlay(sprite, "Charged1")
		elseif entry.timer > 0 then
			local n = 0
			local anim
			if charge > levelOne then
				n = (charge - levelOne) / (levelTwo - levelOne)
				anim = "Charging2"
			else
				n = charge / levelOne
				anim = "Charging1"
			end
			entry.spriteFrame = math.min(math.ceil(n * 100), 100)
			sprite:SetFrame(anim, entry.spriteFrame or 0)
			entry.charged = nil
		end

		if entry.timer >=0 and entry.timer < 10 then
			entry.timer = 100
		end
	end
end

--[[mod:AddCallback("POST_GUN_UPDATE", function(_, gun, player)
	if gun.SubType ~= CollectibleType.COLLECTIBLE_SPIRIT_SWORD then return end

	local pd = mod:GetEntityData(player)
	local gd = mod:GetEntityData(gun)

	local currentAngle = (gd.TargetAngle or 0) % 360  -- CurrentAngle
	currentAngle = gd.CurrentAngle - mod:GetAngleDifferenceDead(gd.CurrentAngle, gd.TargetAngle) * 0.99
	local lastAngle = (gd.LastAngle or currentAngle) % 360

	local diff1 = math.abs(currentAngle - lastAngle)
	local diff2
	
	if currentAngle > lastAngle then
		diff2 = math.abs(lastAngle - (currentAngle - 360))
	else
		diff2 = math.abs((lastAngle - 360) - currentAngle)
	end

	local angleDiff = math.min(diff1, diff2)

	if angleDiff >= 90 then
		if not gd.trail or not gd.trail:Exists() then
			local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPRITE_TRAIL, 0, gun.Position, mod.nilvector, player):ToEffect()
			trail.IsFollowing = false
			trail.SpriteScale = Vector(7, 1)
			trail.MinRadius = 0.05
			gd.trail = trail
		end

		gd.trail.Parent = player
		gd.trail.MinRadius = 0.00

		local numUpdates = 30
		local fadeThreshold = 0.8
		local baseAlpha = 0.8

		for i=0, numUpdates do
			local n = i / numUpdates
			local e = currentAngle - mod:GetAngleDifferenceDead(currentAngle, lastAngle) * n
			gd.trail.Position = player.Position + Vector.FromAngle(e):Resized(60) + Vector(0, -15)
			gd.trail.SpriteScale = Vector(7 * n, 1)
			
			local a = baseAlpha
			if n >= fadeThreshold then
				a = baseAlpha * (1 - (n-fadeThreshold) / (1.0-fadeThreshold))
			end
			
			gd.trail:GetSprite().Color.A = a
			
			gd.trail:Update()
		end

		gd.trail.Parent = nil
		gd.trail.MinRadius = 0.05
	else
		gd.trail = nil
	end

	gd.LastAngle = currentAngle
end)

function TESTSLASH(minRadius, maxRadius)
	local player = Isaac.GetPlayer()

	local slash = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPRITE_TRAIL, 0, player.Position, mod.nilvector, player):ToEffect()
	slash.Parent = player
	slash.IsFollowing = false
	slash.SpriteScale = Vector(7, 1)
	slash.MinRadius = minRadius or 0.05
	slash.MaxRadius = maxRadius or slash.MaxRadius

	for i=1, 180, 10 do
		local pos = player.Position + Vector(40, 0):Rotated(i)
		slash.Position = pos
		slash:Update()
	end

	slash.Parent = nil
end]]
