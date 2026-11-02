local mod = FiendFolio
local gfxPath = "gfx/effects/guns/"



mod.BriendBirthrightData = {
	DropChance = 65, -- The chance for a gun to be dropped as a pickup
	Clips = 3, -- Multiplies the clip size of the gun by this to get the total ammo count
	OneAmmoMulti = 2, -- Multiplies the total ammo count if the clip size is 1
	SpreadMulti = 0.75, -- Multiplier of the spread when used by a player
	BulletOffsetMulti = 0.75, -- Multiplier of the bullet offset when used by a player

	-- Sound IDs to use for different weapon types' shooting sounds
	WeaponTypeToSound = {
		[ WeaponType.WEAPON_BOMBS ]   = "Bomb",
		[ WeaponType.WEAPON_ROCKETS ] = "Rocket",
	},
}

local birthrightData = mod.BriendBirthrightData





--[[ Create the player data for the gun types ]]--
for gunType, gunTypeData in pairs( mod.BountyGunData.TypeData ) do
	local enemyGunData = mod:GetBountyGunData(gunType)

	-- Get the muzzle offset based on the barrel offset
	local muzzleOffsetX =  20 + enemyGunData.BarrelOffset.X / 0.65
	local muzzleOffsetY = -24 + enemyGunData.BarrelOffset.Y

	local playerGunData = {
		BountyGunType = gunType,
		Priority = -1,

		-- Blacklists
		NoFriendSoul = true,
		NoGolden = true,
		NoGoldenBullet = true,
		NoBombShrink = true,

		-- Positioning
		HeldOffset = enemyGunData.HeldOffset * 2,
		MuzzleOffset = Vector(muzzleOffsetX, muzzleOffsetY),

		-- Shooting / reloading
		WeaponType = enemyGunData.BirthrightWeaponType,
		TearHeight = enemyGunData.ProjectileHeight,
		ReloadAllAmmo = enemyGunData.ReloadAllAmmo,

		-- Visuals
		NoMuzzle = enemyGunData.NoMuzzle,
		MuzzleColor = enemyGunData.MuzzleColor,
		MuzzleScale = enemyGunData.MuzzleScale,
		Ejection = enemyGunData.Ejection,
		Casing = enemyGunData.Casing,

		-- Sounds
		Sounds = {},
	}

	-- Get the ANM2
	if enemyGunData.ReplaceAnim then
		if enemyGunData.ReplaceAnim == "guntype_shoot" then
			playerGunData.SpriteType = "Shoot"
		else
			playerGunData.ReplaceAnim = gfxPath .. enemyGunData.ReplaceAnim .. ".anm2"
		end
	end

	-- Get the gun sprite
	if enemyGunData.ReplaceSprite then
		playerGunData.ReplaceSprite = gfxPath .. enemyGunData.ReplaceSprite .. ".png"
	end

	-- Get the multishot data
	if enemyGunData.ProjectileCount > 1 then
		playerGunData.MultiShot = enemyGunData.ProjectileCount
		playerGunData.MultiShotSpread = enemyGunData.SpreadOffset * birthrightData.SpreadMulti
	end

	-- Get the fire rate
	if enemyGunData.Automatic then
		playerGunData.HoldCooldown = enemyGunData.BulletDelay
	else
		local default = mod.BountyGunData.Defaults.FireCooldown.Min
		local holdCooldown = (enemyGunData.FireCooldown.Min / default) * mod.FriendBalancing.HoldFireCooldown
		playerGunData.HoldCooldown = holdCooldown
		playerGunData.TapCooldown = holdCooldown / 2
	end

	-- Get the bullet sprite
	if enemyGunData.ProjectileVariant  == mod.FF.BountyBullet.Var
	and enemyGunData.ProjectileSubType == mod.FF.BountyBullet.BuckshotSub then
		playerGunData.BulletSprite = "gfx/projectiles/guns/bullet_pellet.png"
	end

	-- Get the sounds
	for soundID, soundData in pairs( enemyGunData.Sounds ) do
		if soundID == "Shoot" then
			local entry = birthrightData.WeaponTypeToSound[ enemyGunData.BirthrightWeaponType ]
			soundID = entry or "Bullet"
		end

		if soundData == false then
			playerGunData.Sounds[soundID] = false
		else
			playerGunData.Sounds[soundID] = { soundData, }
		end
	end

	-- Add the data
	local subType = mod.SpecialFriendGunSubtypes.BRIEND_BIRTHRIGHT + gunType
	mod.FriendGunInfo[subType] = playerGunData
end





--[[ Gun pickup ]]--
function mod:BountyGunPickupInit(pickup)
	local sprite = pickup:GetSprite()
	local gunTypeData = mod:GetBountyGunData(pickup.SubType)
	local sheet

	-- Get the spritesheet from ReplaceSprite
	if gunTypeData.ReplaceSprite then
		sheet = gfxPath .. gunTypeData.ReplaceSprite .. ".png"

	-- Get the spritesheet from ReplaceAnim
	elseif gunTypeData.ReplaceAnim then
		local helper = Sprite(gfxPath .. gunTypeData.ReplaceAnim .. ".anm2")
		sheet = helper:GetLayer(0):GetSpritesheetPath()
	end

	-- Load the spritesheet
	if sheet then
		sprite:ReplaceSpritesheet(0, sheet, true)
	end

	-- Set the collision and shadow size
	local sizeMulti = gunTypeData.PickupSize
	pickup.SizeMulti = sizeMulti

	local shadowLayer = sprite:GetLayer("shadow")
	shadowLayer:SetSize(sizeMulti)

	-- Set the sprite offset and shadow size
	local gunLayer = sprite:GetLayer("body")
	gunLayer:SetPos(gunTypeData.PickupOffset)
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.BountyGunPickupInit, mod.PICKUP.VARIANT.BRIEND_BIRTHRIGHT_GUN)



-- Let CHAPI do the heavy lifting for pickup handling
CustomHealthAPI.Library.RegisterPickupEntity(mod.PICKUP.VARIANT.BRIEND_BIRTHRIGHT_GUN, -1, {
	OnDrop = function(pickup)
		mod:PlayBountyGunSound(pickup.SubType, "Drop")
	end,

	OnCollect = function(player, pickup)
		local gunType = mod.SpecialFriendGunSubtypes.BRIEND_BIRTHRIGHT + pickup.SubType
		local gunTypeData = mod:GetBountyGunData(pickup.SubType)

		-- Create the ammo table with only red hearts
		local ammoTable = {}
		local defaultAmmo = gunTypeData.Ammo
		local clipSize = defaultAmmo

		-- Have more ammo for guns with a clip size of 1
		if defaultAmmo <= 1 then
			defaultAmmo = defaultAmmo * birthrightData.OneAmmoMulti
			clipSize = defaultAmmo * birthrightData.Clips
		end
		for i = 1, clipSize do
			table.insert(ammoTable, { HeartKey = "RED_HEART" })
		end

		local ammoCount = defaultAmmo * birthrightData.Clips
		mod:AddFriendSoulGun(player, gunType, ammoTable, ammoCount)
	end,
})





--[[ Gun type handling ]]--

-- Handle bullet spread and varrying shot speeds
function mod:BirthrightBountyGunTears(gun, player, tear, heldOrTapped)
	local gunTypeData = mod.FriendGunInfo[gun.SubType]

	if gunTypeData and gunTypeData.BountyGunType then
		gunTypeData = mod:GetBountyGunData(gunTypeData.BountyGunType)

		-- Get the angle offset
		local bulletOffset = mod:Random(-gunTypeData.BulletOffset, gunTypeData.BulletOffset)
		bulletOffset = bulletOffset * birthrightData.BulletOffsetMulti

		-- Get the shot speed multiplier
		local shotSpeed = mod:Random(gunTypeData.ShotSpeed.Min, gunTypeData.ShotSpeed.Max)
		local default = mod.BountyGunData.Defaults.ShotSpeed.Min
		local shotSpeedMulti = shotSpeed / default

		tear.Velocity = tear.Velocity:Rotated(bulletOffset) * shotSpeedMulti
	end
end
mod:AddCallback("POST_GUN_FIRE_TEAR", mod.BirthrightBountyGunTears)



-- Rocket Launcher stuff
function mod:BirthrightBountyGunRocketLauncherFire(gun, player, direction, ammoUsed, heldOrTapped, fired)
	local gunTypeData = mod:GetBountyGunData(mod.BountyGunTypes.ROCKET_LAUNCHER)

	-- Set the rocket sprite and height
	for i, entity in pairs(fired) do
		local bomb = entity:ToBomb()

		if bomb and bomb.Variant == BombVariant.BOMB_ROCKET then
			bomb.PositionOffset = Vector(0, gunTypeData.ProjectileHeight)
			bomb:GetSprite():Load("gfx/items/pick ups/bombs/gunslinger_rocket.anm2", true)
		end
	end

	-- Knockback
	local velocity = -direction:Resized(5)
	player:AddVelocity(velocity)

	-- Create the exhaust smoke
	local sprite = gun:GetSprite()
	local barrelLengthOffset = direction:Resized(-27 / 0.65)
	local barrelHeightOffset = gunTypeData.BarrelOffset.Y - math.abs(sprite.Offset.X)
	local spriteOffset = Vector(0, sprite.Offset.Y - barrelHeightOffset) / 0.65
	local smokePos = gun.Position + gun.PositionOffset + barrelLengthOffset + spriteOffset

	for i = 1, 4 do
		local offset = math.random(-30, 30)
		local speed = math.random(6, 10)
		local vector = direction:Rotated(180 + offset):Resized(speed)
		local smoke = mod:SpawnDust(smokePos, vector, 0.5, Color(0.75,0.75,0.75, 0.5))
		smoke:SetColor(Color(1,1,1, 1, 1,0.5,0), 4, 1, true, false)
	end
end
mod:AddCallback("POST_GUN_FIRE", mod.BirthrightBountyGunRocketLauncherFire, mod.SpecialFriendGunSubtypes.BRIEND_BIRTHRIGHT + mod.BountyGunTypes.ROCKET_LAUNCHER)



-- Eternal Revolver transferring
function mod:BirthrightBountyGunEternalRevolverDisappear(gun, player)
	if #mod:GetEternalRevolverTargets() > 0 then
		gun:Remove()

		-- Create the new gun
		local newGun = mod:CreateBountyGun(player, mod.BountyGunTypes.REVOLVER_ETERNAL)
		local vector = gun.Position - player.Position
		newGun.Rotation = vector:GetAngleDegrees() % 360

		-- Create its tracker
		local gunTracker = mod:CreateBountyGunTracker(mod.BountyGunTypes.REVOLVER_ETERNAL)
		gunTracker.Entity = newGun
		mod:GetEntityData(newGun).GunTracker = gunTracker
	end
end
mod:AddCallback("GUN_START_DISAPPEARING", mod.BirthrightBountyGunEternalRevolverDisappear, mod.SpecialFriendGunSubtypes.BRIEND_BIRTHRIGHT + mod.BountyGunTypes.REVOLVER_ETERNAL)