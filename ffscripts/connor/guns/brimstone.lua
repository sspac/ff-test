local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local LASER_TIMEOUT = 4

local BASE_CHARGE_FRAMES = 60
local CHARGE_FRAMES_PER_HEART = 0

local function GetMaxBrimCharge(player)
	return BASE_CHARGE_FRAMES
end

local function ResetChargeBar(player)
	local pd = mod:GetEntityData(player)

	if pd.customChargeBarSprites then
		if not pd.customChargeBarSprites[CollectibleType.COLLECTIBLE_BRIMSTONE] then
			mod:EvaluateExtraChargeBar(player)
		end
		if pd.customChargeBarSprites[CollectibleType.COLLECTIBLE_BRIMSTONE] and pd.customChargeBarTable then
			for key,entry in pairs(pd.customChargeBarTable) do
				if entry.id == CollectibleType.COLLECTIBLE_BRIMSTONE then
					entry.spriteFrame = 0
				end
			end
		end
	end
end

local function ResetBrimstone(gun, player)
	local pd = mod:GetEntityData(player)
	local gd = mod:GetEntityData(gun)
	
	pd.FriendBrimstoneCharge = nil
	gd.FriendBrimstoneActive = nil

	if #pd.FriendHeldGuns[gun.InitSeed].Ammo < #mod:GetFriendAmmo(gun) and gd.state ~= "Reload" then
		gd.state = "Reload"
		gd.substate = "Begin"
		gd.reloadOverride = true
	end

	if gd.FriendBrimstoneLastShotWasFree then
		mod:GetFriendGunNextShot(gun)
		gd.FriendBrimstoneLastShotWasFree = nil
	end

	ResetChargeBar(player)
end

mod:AddCallback("PRE_GUN_FIRE", function(_, gun, player, aim, held)
	if mod:GetFriendWeaponType(player, gun) ~= WeaponType.WEAPON_BRIMSTONE then return end

	local pd = mod:GetEntityData(player)
	local gd = mod:GetEntityData(gun)

	local gunTable = pd.FriendHeldGuns[gun.InitSeed] or pd.FriendHeldGuns[pd.FriendsRevolver.InitSeed]
	local rng = gun:GetDropRNG()
	local maxCharge = GetMaxBrimCharge(player)

	if held and #gunTable.Ammo > 0 then
		if gd.state == "Reload" then
			gd.state = "Idle"
		end

		gd.FriendBrimstoneActive = true

		if not pd.FriendBrimstoneCharge then
			pd.FriendBrimstoneCharge = 0
			sfx:Play(mod.Sounds.ShockerCharge, 1.0, 0, false, 0.8)
			ResetChargeBar(player)
		end

		if pd.FriendBrimstoneCharge >= maxCharge then
			local mainLaser = mod:GetPointee(gd.FriendBrimstoneLaser)

			local shouldUpdateShot = true
			if mainLaser then
				local ld = mod:GetEntityData(mainLaser)
				local swirl = ld.FriendLaserSwirl
				if swirl and swirl:GetSprite():IsPlaying("Idle") and not swirl:GetSprite():WasEventTriggered("Shoot") then
					shouldUpdateShot = false
					ld.WasSwirlPreventingFetalFriendFiring = true
				elseif ld.WasSwirlPreventingFetalFriendFiring then
					shouldUpdateShot = false
					ld.WasSwirlPreventingFetalFriendFiring = nil
					gunTable.LastFrameFired = gun.FrameCount
				end
			end

			if shouldUpdateShot then
				sfx:Play(SoundEffect.SOUND_SCAMPER, 0.5, 0, false, mod:RandomInt(120,130,rng)/100)

				-- If the player has Anti-Gravity, don't consume ammo when the laser is first fired (because there will be a delay before the laser actually fires)
				local antiGravFreeStart = not mainLaser and player:HasCollectible(CollectibleType.COLLECTIBLE_ANTI_GRAVITY)
				local shot = mod:GetFriendGunNextShot(gun, antiGravFreeStart)
				gd.FriendBrimstoneLastShotWasFree = antiGravFreeStart

				mod:SubtractLimitedAmmo(gd)

				gunTable.LastFrameFired = gun.FrameCount

				local firedLaser = false

				if not mainLaser then
					mainLaser = mod:FireFriendLaser(gun, player, aim, Vector.Zero, aim, shot, true)
					mainLaser.Timeout = LASER_TIMEOUT
					gd.FriendBrimstoneLaser = EntityPtr(mainLaser)
					firedLaser = true
					mainLaser:Update()
					local ld = mod:GetEntityData(mainLaser)
					if ld.FriendLaserSwirl then
						local spr = ld.FriendLaserSwirl:GetSprite()
						local anim = spr:GetAnimation()
						spr:Load("gfx/effects/inaba_brimstoneswirl.anm2", true)
						spr:Play(anim, true)
						spr:SetOverlayRenderPriority(true)
					end
				end

				if not firedLaser then
					-- Update the ongoing brimstone laser for the current ammo.
					local flat, mult, crit = mod:GetFriendShotDamageBonus(gun, player, shot)
					local newDamage = (player.Damage + flat)*mult
					local damMult = newDamage/player.Damage
					mainLaser:SetDamageMultiplier(damMult)

					mod:ApplyFriendLaserShotEffects(mainLaser, player, shot, crit, true)
					local ld = mod:GetEntityData(mainLaser)
					if ld.FriendLaserSwirl and ld.FriendLaserSwirl:Exists() then
						local swirl = ld.FriendLaserSwirl
						mod:ApplyFriendGenericShotEffects(swirl, player, shot, shot.Crit, true, true)
						swirl.Color = mod:GetFriendShotLaserColor(swirl, player)
					end
				end

				local extraLasers = 0
				local extraLaserArc = 45
				local extraLaserScale = mainLaser:GetScale() * 0.5

				if player:HasCollectible(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) then
					local minimum = 2 + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MONSTROS_LUNG)
					local maximum = 3 + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MONSTROS_LUNG) * 2
					extraLasers = extraLasers + mod:RandomInt(minimum, maximum)
				end

				if player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_SORE) then
					local toadd = mod:RandomInt(-3,3)
					if toadd > 0 then
						extraLasers = extraLasers + toadd
						extraLaserArc = 180
					end
				end

				extraLasers = math.ceil(extraLasers / mod:GetRawMultiShotTearCount(player))

				if extraLasers > 0 then
					sfx:Play(SoundEffect.SOUND_BLOOD_LASER_SMALL, 0.5, 0, false, 1.0)
					for i=1, extraLasers do
						local angle = mod:RandomFloat(-extraLaserArc, extraLaserArc)
						local laser = mod:FireFriendLaser(gun, player, aim, Vector.Zero, aim:Rotated(angle), shot)

						laser:SetDamageMultiplier(laser:GetDamageMultiplier() * 0.5)
						laser.Timeout = 4
						laser:SetScale(extraLaserScale)
						mod:GetEntityData(laser).friendExtraBrimstoneAngle = angle
					end
				end

				-- Blue Lyre Tweak
				if (player:HasCollectible(mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_B) or (player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and pd.ffsavedata.VoidedLyre == 1)) and math.floor(pd.BlueLyreShot or 0) == 0 then
					local cloud = Isaac.Spawn(1000, mod.FF.FFWhiteSmoke.Var, mod.FF.FFWhiteSmoke.Sub, mainLaser.Position, aim:Resized(10), player)
					mod:GetEntityData(cloud).longonly = true
					cloud.SpriteOffset = Vector(0, -8)
					--cloud.SpriteScale = Vector(extraLaserScale, extraLaserScale)
					cloud.Color = mainLaser.Color
					cloud:Update()
					mainLaser:Remove()
				end
				
				local _, _, owner = mod:GetFriendGunPlayer(gun)
				mod:FriendSecondaryFire(player, aim, 1, owner, gun, {shot}, {NumTears = 1 + extraLasers})
				
				if not (mod:GetEntityData(gun).isTemporaryGun or mod:IsFriendSoulGun(gun, mod:GetEntityData(gun))) then
					mod:fireBeeSkinBrimstone(player, LASER_TIMEOUT, 1, {FriendGun = gun, FriendShot = shot})
				end

				Isaac.RunCallbackWithParam("POST_GUN_FIRE", gun.SubType, gun, player, aim, {shot}, true, {mainLaser})
			end
		elseif gd.FriendBrimstoneLaser then
			if gd.FriendBrimstoneLaser.Ref and gd.FriendBrimstoneLaser.Ref:Exists() then
				gd.FriendBrimstoneLaser.Ref:Remove()
			end
			gd.FriendBrimstoneLaser = nil
		end
	elseif gd.FriendBrimstoneActive then
		ResetBrimstone(gun, player)
		gunTable.LastFrameFired = gun.FrameCount
	end

	return true
end)

mod:AddCallback("GUN_HOLD_RELEASE", function(_, gun, player, aim)
	if mod:GetFriendWeaponType(player, gun) == WeaponType.WEAPON_BRIMSTONE then
		ResetBrimstone(gun, player)
	end
end)

mod:AddCallback("POST_GUN_UPDATE", function(_, gun, player)
	local pd = mod:GetEntityData(player)
	local gd = mod:GetEntityData(gun)

	if mod:GetFriendWeaponType(player, gun) ~= WeaponType.WEAPON_BRIMSTONE then
		return
	end

	local laser = mod:GetPointee(gd.FriendBrimstoneLaser)
	if laser then
		local ld = mod:GetEntityData(laser)
		local aiming = pd.FriendHeldGuns[gun.InitSeed] and pd.FriendHeldGuns[gun.InitSeed].HeldDown and gd.state ~= "Reload"
		and (player:IsExtraAnimationFinished() or player:GetSprite():IsPlaying("Hit"))

		local swirl = ld.FriendLaserSwirl
		local swirlPending = false

		if swirl then
			local spr = swirl:GetSprite()
			swirlPending = spr:IsPlaying("Idle") and not spr:WasEventTriggered("Shoot")
			if aiming and spr:IsEventTriggered("Shoot") then
				spr:Play("FireLoop")
				spr:PlayOverlay("SpiralDisappear")
				local aim, isMouseAim = mod:GetFriendGunAim(gun)
				if isMouseAim then
					laser.AngleDegrees = (mod:GetMousePosition(true) - laser.Position):GetAngleDegrees()
				else
					laser.AngleDegrees = aim:GetAngleDegrees()
				end
				laser:RecalculateSamplesNextUpdate()
			end
			if not aiming and spr:IsPlaying("FireLoop") and swirl.FrameCount > 35 then
				spr:Play("Disappear")
			end
		end

		if aiming or swirlPending then
			laser.Timeout = LASER_TIMEOUT
			if mod:GetEntityData(player).BeeSkinBrimstone then
				mod:fireBeeSkinBrimstone(player, LASER_TIMEOUT, 1, {FriendGun = gun})
			end
		end
	end
end)

mod:AddCallback("GUN_START_DISAPPEARING", function (_, gun, player)
	if player:Exists() then
		ResetBrimstone(gun, player)
	end
end)

local CHARGE_SPRITE = Sprite()
CHARGE_SPRITE:Load("gfx/effects/guns/guns_brimstone_charge.anm2", true)
CHARGE_SPRITE:Play("Idle", true)
local CHARGE_ANIM_LENGTH = CHARGE_SPRITE:GetCurrentAnimationData():GetLength()

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_, gun)
	-- Esau Jr protection (for some reason the SpawnerEntity goes nil for a few frames idk)
	if not gun.SpawnerEntity then
		return
	end

	local player = mod:GetFriendGunPlayer(gun)
	local pd = mod:GetEntityData(player)
	local gd = mod:GetEntityData(gun)

	local maxCharge = GetMaxBrimCharge()

	if pd and gun.Visible and gd.FriendBrimstoneActive and pd.FriendBrimstoneCharge and pd.FriendBrimstoneCharge < maxCharge then
		local aim = aiming and mod:GetFriendGunAim(gun) or Vector.FromAngle(gd.CurrentAngle or 0)

		local n = pd.FriendBrimstoneCharge / maxCharge
		local scale = mod:Lerp(1.0, 0.4, n)
		local a = mod:Lerp(0.0, 1.0, n)

		CHARGE_SPRITE:SetFrame((gun.FrameCount + gun.InitSeed) % CHARGE_ANIM_LENGTH)
		CHARGE_SPRITE.Color = gun.SpawnerEntity:ToPlayer().LaserColor
		CHARGE_SPRITE.Color.A = a
		CHARGE_SPRITE.Scale = Vector(scale, scale)

		local pos = Isaac.WorldToScreen(mod:GetFriendGunShootPos(gun, aim) + Vector(0, mod:GetFriendGunMuzzleOffset(gun).Y))
		CHARGE_SPRITE:Render(pos)
	end
end, mod.FF.FriendsRevolver.Var)

function mod.FriendBrimstoneBarConditionFunc(player, d, entry)
	local guns = mod:GetGunsWithSynergy(player, CollectibleType.COLLECTIBLE_BRIMSTONE)
	return (
		mod.IsPlayerShootingOrMarked(player)
		and #guns > 0
		and d.FriendBrimstoneCharge
		and d.FriendBrimstoneCharge < GetMaxBrimCharge(player)
	)
end

function mod.FriendBrimstoneBarAnimFunc(player, pd, sprite, entry)
	if entry then
		if not entry.timer then
			entry.timer = 0
			entry.initialDelay = 0
			entry.chargeLayer = 1
		end

		local shooting = mod.IsPlayerShootingOrMarked(player)

		if entry.timer < 0 and shooting then
			entry.timer = 0
		end

		if shooting then
			if pd.FriendBrimstoneCharge then
				pd.FriendBrimstoneCharge = pd.FriendBrimstoneCharge + 1
				entry.spriteFrame = math.min(math.ceil(pd.FriendBrimstoneCharge / GetMaxBrimCharge(player) * 100), 100)
			end
		end

		if entry.spriteFrame and entry.spriteFrame == 100 then
			if not entry.charged then
				sprite:Play("StartCharged", true)
				entry.charged = true
			elseif sprite:IsFinished("StartCharged") then
				mod:spritePlay(sprite, "Charged")
			end
		elseif entry.timer > 0 then
			sprite:Play("Charging")
			sprite:SetFrame(entry.spriteFrame or 0)
			entry.charged = nil
		end

		if entry.timer >=0 and entry.timer < 10 then
			entry.timer = 100
		end
	end
end
