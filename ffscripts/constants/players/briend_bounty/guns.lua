local mod = FiendFolio



-- Enums for enemy gunslinger guns
---@enum BountyGunTypes
mod.BountyGunTypes = {
	-- Tier 1 - Revolvers
	REVOLVER_BASIC 	   = 10,
	REVOLVER_SNUB_NOSE = 11,

	-- Tier 2 - Shotguns
	SHOTGUN_PUMP_ACTION   = 20,
	SHOTGUN_DOUBLE_BARREL = 21,
	SHOTGUN_COMBAT 		  = 22,

	-- Tier 3 - SMGs
	SMG_MAC = 30,
	SMG_MP 	= 31,
	SMG_UZI	= 32,

	-- Tier 4 - Rifles
	RIFLE_AK  = 40,
	RIFLE_M16 = 41,
	NEGEV 	  = 42,

	-- Tier 5 - Launchers
	GRENADE_LAUNCHER = 50,
	ROCKET_LAUNCHER  = 51,

	-- Special
	REVOLVER_ETERNAL = 60,
}

local gunTypes = mod.BountyGunTypes



mod.BountyGunData = {
	DetectionRange = 8 * 40,
	FireAngleLimit = 20, -- The max difference between the gun's angle and the angle to the target, uses the gun's spread angle instead if it's higher
	ForgetTime = 60, -- How long it takes for the enemy to reload and stop aiming at the last position if the target is out of sight
	MinAlpha = 0.1, -- Minimum alpha required for guns to be able to shoot
	ReappearCooldown = 15, -- How long until guns can shoot again after re-appearing
	MaxBulletAirTime = 5 * 30, -- How long before the default bullet variant starts falling down

	-- State enums for the gun entity
	States = {
		Appear = 0,
		ToIdle = 1,
		Idle   = 2,
		Disappear = 10,
		Transfer  = 11,
		Disable  = 20,
		Disabled = 21,
		Shooting = 30,
		ReloadStart  = 40,
		ReloadWait 	 = 41,
		ReloadBullet = 42,
	},

	-- Speed values for the transferring state of Eternal Revolvers
	EternalTransferSpeed = {
		Increase = 1.25,
		Max 	 = 30,
	},



	-- Default values to use if not defined for the gun type
	Defaults = {
		-- Sprite
		ReplaceAnim = nil, -- The anm2 to use (starting from gfx/effects/guns)
		ReplaceSprite = nil, -- The spritesheet to use (starting from gfx/effects/guns)
		BarrelOffset = Vector(19, 5), -- In sprite coordinates! X: How far bullets spawn from the gun's position, Y: How far the gun is offset horizontally when aiming up or down
		PickupSize = Vector(1.4, 1), -- Multiplier for the pickup version's collision and shadow size
		PickupOffset = Vector(-2, 0), -- Offset for the pickup version's sprite

		-- Aiming
		HeldOffset = 12, -- How far out the gun is held
		RotationLerp = 0.1,
		MaxRotationSpeed = 20,
		ShootingRotationMulti = 0.5, -- Multiplier of RotationLerp and MaxRotationSpeed for automatic guns while they're shooting

		-- Shooting
		Ammo = 6,
		FireCooldown = { Min = 20, Max = 40, }, -- Delay between each attack
		Automatic = false, -- If true, the gun will only stop if its ammo runs out after it starts shooting
		Burst = false, -- If set to a number value, the gun will shoot that many times in a single attack
		BulletDelay = 0, -- Delay between each individual shot (for automatic weapons)
		CustomFiring = nil, -- The function to run instead of the normal firing method (params: owner, gun, gunTypeData, firingDirection, barrelPos)
		BirthrightWeaponType = nil, -- The weapon type to use for the player version of the gun

		-- Bullet parameters
		ProjectileCount = 1,
		SpreadOffset = 0, -- The angle difference between each bullet in a spread
		BulletOffset = 3, -- Applied to each bullet individually
		ShotSpeed = { Min = 10, Max = 10, },
		ProjectileVariant = mod.FF.BountyBullet.Var,
		ProjectileSubType = 0,
		ProjectileScale = 1,
		ProjectileFlags = 0,
		ProjectileHeight = -20, -- Basically the same as Friend's tear height but tears and projectile use the Height variable differently
		CustomData = {}, -- Custom data to add using GetData, for example: { CriticalHit = true, }

		-- Reloading
		ReloadAllAmmo = false, -- If true, the gun reloads all of its ammo at once instead of reloading them individually
		ReloadBulletDelay = 8, -- The time between each reloaded bullet

		-- Visuals
		NoMuzzle = false,
		MuzzleColor = mod:ColorHSV(0.0, 0.0, 1.0, 1, 0.1, 1.0, 0.9),
		MuzzleScale = 1,
		Ejection = false, -- If true, casings get ejected when the gun fires, not when it reloads
		Casing = "Bullet", -- Other types include: Caliber, Shell, Battery, Tooth, None

		-- Sounds (Set to false to never play that sound)
		Sounds = {
			Equip = { Id = mod.Sounds.GunDraw,
				VolMin = 0.5, VolMax = 0.5, PitchMin = 0.95, PitchMax = 1.05,
			},
			Shoot = { Id = mod.Sounds.RevolverShoot,
				VolMin = 0.5, VolMax = 0.7, PitchMin = 0.95, PitchMax = 1.0,
			},
			ReloadStart = false,
			ReloadClick = { Id = mod.Sounds.RevolverReload,
				VolMin = 0.8, VolMax = 0.8, PitchMin = 1.0, PitchMax = 1.1,
			},
			ReloadFinish = { Id = mod.Sounds.RevolverReloadFinish,
				VolMin = 0.5, VolMax = 0.5, PitchMin = 1.0, PitchMax = 1.0,
			},
			Drop = { Id = SoundEffect.SOUND_CHEST_DROP,
				VolMin = 1.0, VolMax = 1.0, PitchMin = 1.9, PitchMax = 2.1,
			},
		},
	},



	-- The data for each gun type
	TypeData = {
		--[[ Tier 1 ]]--
		-- Basic Revolver
		[ gunTypes.REVOLVER_BASIC ] = {
			ReplaceSprite = "bounty/revolver_basic",
		},

		-- Snub-Nose Revolver
		[ gunTypes.REVOLVER_SNUB_NOSE ] = {
			ReplaceSprite = "bounty/revolver_snub",
			BarrelOffset = Vector(12, 5),
			PickupSize = Vector(1.1, 1),
			PickupOffset = Vector(0, 0),

			Ammo = 5,

			BulletOffset = 5,
			ShotSpeed = { Min = 8, Max = 8, },
			ProjectileScale = 1.25,

			MuzzleScale = 1.15,
		},



		--[[ Tier 2 ]]--
		-- Pump Action Shotgun
		[ gunTypes.SHOTGUN_PUMP_ACTION ] = {
			ReplaceAnim = "guntype_shoot",
			ReplaceSprite = "bounty/shotgun_pump",
			BarrelOffset = Vector(25, 4),
			PickupSize = Vector(1.8, 1),
			PickupOffset = Vector(-5, 0),

			Ammo = 4,
			FireCooldown = { Min = 40, Max = 60, },

			ProjectileCount = 3,
			SpreadOffset = 25,
			BulletOffset = 0,
			ShotSpeed = { Min = 9, Max = 9, },
			ProjectileSubType = mod.FF.BountyBullet.BuckshotSub,

			MuzzleScale = 1.25,
			Ejection = true,
			Casing = "Shell",

			Sounds = {
				Shoot = { Id = mod.Sounds.ShotgunShoot,
					VolMin = 0.75, VolMax = 0.75, PitchMin = 0.9, PitchMax = 0.95,
				},
				ReloadClick = { Id = mod.Sounds.ShotgunReload,
					VolMin = 0.65, VolMax = 0.7, PitchMin = 1.2, PitchMax = 1.2,
				},
				ReloadFinish = { Id = mod.Sounds.ShotgunReloadFinish,
					VolMin = 1.0, VolMax = 1.0, PitchMin = 1.3, PitchMax = 1.3,
				},
			},
		},

		-- Double-Barrel Shotgun
		[ gunTypes.SHOTGUN_DOUBLE_BARREL ] = {
			ReplaceSprite = "bounty/shotgun_double",
			BarrelOffset = Vector(26, 6),
			PickupSize = Vector(1.8, 1),
			PickupOffset = Vector(-5, 0),

			ShootingRotationMulti = 0.2,

			Ammo = 2,
			FireCooldown = { Min = 50, Max = 70, },
			Automatic = true,
			BulletDelay = 20,

			ProjectileCount = 4,
			SpreadOffset = 25,
			BulletOffset = 10,
			ShotSpeed = { Min = 6, Max = 8, },
			ProjectileSubType = mod.FF.BountyBullet.BuckshotSub,

			ReloadAllAmmo = true,

			MuzzleScale = 1.5,
			Casing = "Shell",

			Sounds = {
				Shoot = { Id = mod.Sounds.ShotgunShoot,
					VolMin = 0.75, VolMax = 0.75, PitchMin = 0.9, PitchMax = 0.95,
				},
				ReloadClick = { Id = mod.Sounds.ShotgunReload,
					VolMin = 0.65, VolMax = 0.7, PitchMin = 1.2, PitchMax = 1.2,
				},
				ReloadFinish = { Id = mod.Sounds.FlareReloadFinish,
					VolMin = 1.0, VolMax = 1.0, PitchMin = 0.9, PitchMax = 1.1,
				},
			},
		},

		-- Combat Shotgun
		[ gunTypes.SHOTGUN_COMBAT ] = {
			ReplaceAnim = "guntype_shoot",
			ReplaceSprite = "bounty/shotgun_combat",
			BarrelOffset = Vector(22, 6),
			PickupSize = Vector(1.6, 1),
			PickupOffset = Vector(-5, 0),

			Ammo = 1,
			FireCooldown = { Min = 50, Max = 70, },

			ProjectileCount = 4,
			SpreadOffset = 30,
			BulletOffset = 0,
			ShotSpeed = { Min = 8, Max = 8, },
			ProjectileSubType = mod.FF.BountyBullet.BuckshotSub,

			MuzzleScale = 1.25,
			Ejection = true,
			Casing = "Shell",

			Sounds = {
				Shoot = { Id = mod.Sounds.ShotgunShoot,
					VolMin = 0.75, VolMax = 0.75, PitchMin = 0.9, PitchMax = 0.95,
				},
				ReloadClick = { Id = mod.Sounds.ShotgunReload,
					VolMin = 0.65, VolMax = 0.7, PitchMin = 1.2, PitchMax = 1.2,
				},
				ReloadFinish = { Id = mod.Sounds.ShotgunReloadFinish,
					VolMin = 1.0, VolMax = 1.0, PitchMin = 1.3, PitchMax = 1.3,
				},
			},
		},



		--[[ Tier 3 ]]--
		-- MAC10
		[ gunTypes.SMG_MAC ] = {
			ReplaceSprite = "bounty/smg_mac",
			BarrelOffset = Vector(11, 4),
			PickupSize = Vector(1, 1),
			PickupOffset = Vector(4, -3),

			Ammo = 10,
			Automatic = true,
			Burst = 5,
			BulletDelay = 3,

			BulletOffset = 15,

			ReloadAllAmmo = true,

			MuzzleScale = 0.85,
			Ejection = true,

			Sounds = {
				Shoot = { Id = mod.Sounds.SMGShoot,
					VolMin = 1.0, VolMax = 1.0, PitchMin = 0.85, PitchMax = 1.15,
				},
				ReloadFinish = { Id = mod.Sounds.SMGReloadFinish,
					VolMin = 0.8, VolMax = 0.8, PitchMin = 1.0, PitchMax = 1.1,
				},
			},
		},

		-- MP7
		[ gunTypes.SMG_MP ] = {
			ReplaceSprite = "bounty/smg_mp",
			BarrelOffset = Vector(21, 4),
			PickupSize = Vector(1.4, 1),
			PickupOffset = Vector(-4, -1),

			Ammo = 12,
			Automatic = true,
			Burst = 4,
			BulletDelay = 5,

			BulletOffset = 8,

			ReloadAllAmmo = true,

			MuzzleScale = 0.85,
			Ejection = true,

			Sounds = {
				Shoot = { Id = mod.Sounds.SMGShoot,
					VolMin = 1.0, VolMax = 1.0, PitchMin = 0.85, PitchMax = 1.15,
				},
				ReloadFinish = { Id = mod.Sounds.SMGReloadFinish,
					VolMin = 0.8, VolMax = 0.8, PitchMin = 1.0, PitchMax = 1.1,
				},
			},
		},

		-- Uzi
		[ gunTypes.SMG_UZI ] = {
			ReplaceSprite = "bounty/smg_uzi",
			BarrelOffset = Vector(16, 3),
			PickupSize = Vector(1.4, 1),
			PickupOffset = Vector(2, -4),

			Ammo = 9,
			FireCooldown = { Min = 20, Max = 30, },
			Automatic = true,
			Burst = 3,
			BulletDelay = 4,

			BulletOffset = 10,

			ReloadAllAmmo = true,

			MuzzleScale = 0.85,
			Ejection = true,

			Sounds = {
				Shoot = { Id = mod.Sounds.SMGShoot,
					VolMin = 1.0, VolMax = 1.0, PitchMin = 0.85, PitchMax = 1.15,
				},
				ReloadFinish = { Id = mod.Sounds.SMGReloadFinish,
					VolMin = 0.8, VolMax = 0.8, PitchMin = 1.0, PitchMax = 1.1,
				},
			},
		},



		--[[ Tier 4 ]]--
		-- AK47
		[ gunTypes.RIFLE_AK ] = {
			ReplaceSprite = "bounty/rifle_ak",
			BarrelOffset = Vector(24, 4),
			PickupSize = Vector(1.8, 1),
			PickupOffset = Vector(-1, -1),

			Ammo = 16,
			FireCooldown = { Min = 20, Max = 30, },
			Automatic = true,
			Burst = 4,
			BulletDelay = 4,

			BulletOffset = 6,
			ProjectileHeight = -19,

			ReloadAllAmmo = true,

			Ejection = true,

			Sounds = {
				ReloadFinish = { Id = mod.Sounds.SMGReloadFinish,
					VolMin = 0.8, VolMax = 0.8, PitchMin = 1.0, PitchMax = 1.1,
				},
			},
		},

		-- M16
		[ gunTypes.RIFLE_M16 ] = {
			ReplaceSprite = "bounty/rifle_m16",
			BarrelOffset = Vector(25, 5),
			PickupSize = Vector(1.8, 1),
			PickupOffset = Vector(-1, -1),

			Ammo = 15,
			Automatic = true,
			Burst = 5,
			BulletDelay = 5,

			BulletOffset = 4,

			ReloadAllAmmo = true,

			Ejection = true,

			Sounds = {
				ReloadFinish = { Id = mod.Sounds.SMGReloadFinish,
					VolMin = 0.8, VolMax = 0.8, PitchMin = 1.0, PitchMax = 1.1,
				},
			},
		},

		-- Negev
		[ gunTypes.NEGEV ] = {
			ReplaceSprite = "bounty/negev",
			BarrelOffset = Vector(28, 5),
			PickupSize = Vector(2, 1),
			PickupOffset = Vector(-2, -2),

			ShootingRotationMulti = 0.2,

			Ammo = 20,
			Automatic = true,
			BulletDelay = 4,

			BulletOffset = 4,

			ReloadAllAmmo = true,
			ReloadBulletDelay = 40,

			Ejection = true,
			Casing = "Caliber",

			Sounds = {
				ReloadFinish = { Id = mod.Sounds.SMGReloadFinish,
					VolMin = 0.8, VolMax = 0.8, PitchMin = 1.0, PitchMax = 1.1,
				},
			},
		},



		--[[ Tier 5 ]]--
		-- Grenade Launcher
		[ gunTypes.GRENADE_LAUNCHER ] = {
			ReplaceSprite = "bounty/grenade_launcher",
			BarrelOffset = Vector(23, 6),
			PickupSize = Vector(1.8, 1),
			PickupOffset = Vector(-2, 0),

			Ammo = 1,
			FireCooldown = { Min = 80, Max = 100, },
			BirthrightWeaponType = WeaponType.WEAPON_BOMBS,

			ProjectileHeight = -15,

			NoMuzzle = true,
			Casing = "None",

			CustomFiring = function(owner, gun, gunTypeData, direction, barrelPos)
				local bulletHeight = gun.PositionOffset.Y + gunTypeData.ProjectileHeight
				local bulletPos = barrelPos + Vector(0, -bulletHeight)
				local velocity = direction:Resized(10)

				local bomb = Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_TROLL, 0, bulletPos, velocity, owner):ToBomb()
				bomb.PositionOffset = Vector(0, bulletHeight)
				bomb:GetSprite():Play("Pulse", true)
				bomb:SetExplosionCountdown(mod:Random(30, 45, RNG(bomb.InitSeed)))
				mod:GetEntityData(bomb).BountyGunBomb = owner
			end,

			Sounds = {
				Shoot = { Id = mod.Sounds.GrenadeLauncherFire,
					VolMin = 0.75, VolMax = 0.75, PitchMin = 0.9, PitchMax = 1.0,
				},
				ReloadStart = { Id = mod.Sounds.GrenadeLauncherReloadStart,
					VolMin = 1.0, VolMax = 1.0, PitchMin = 1.0, PitchMax = 1.0,
				},
				ReloadClick = { Id = mod.Sounds.GrenadeLauncherReload,
					VolMin = 1.0, VolMax = 1.0, PitchMin = 0.85, PitchMax = 1.15,
				},
				ReloadFinish = { Id = mod.Sounds.GrenadeLauncherReloadEnd,
					VolMin = 1.0, VolMax = 1.0, PitchMin = 1.0, PitchMax = 1.0,
				},
			},
		},

		-- Rocket Launcher
		[ gunTypes.ROCKET_LAUNCHER ] = {
			ReplaceAnim = "bounty/guntype_rocket_launcher",
			BarrelOffset = Vector(9, 6),
			PickupSize = Vector(2, 1),
			PickupOffset = Vector(5, 0),

			Ammo = 1,
			FireCooldown = { Min = 80, Max = 100, },
			BirthrightWeaponType = WeaponType.WEAPON_ROCKETS,

			ProjectileHeight = -20,

			NoMuzzle = true,
			Casing = "None",

			CustomFiring = function(owner, gun, gunTypeData, direction, barrelPos)
				local bulletHeight = gun.PositionOffset.Y + gunTypeData.ProjectileHeight
				local bulletPos = barrelPos + Vector(0, -bulletHeight)
				local angle = direction:GetAngleDegrees()

				local rocket = Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_ROCKET, 0, bulletPos, Vector.Zero, owner):ToBomb()
				rocket.PositionOffset = Vector(0, bulletHeight)
				rocket:SetRocketAngle(angle)
				rocket.RadiusMultiplier = 0.75
				rocket:GetSprite():Load("gfx/items/pick ups/bombs/gunslinger_rocket.anm2", true)
				mod:GetEntityData(rocket).BountyGunBomb = owner
				rocket:Update()

				-- Knockback
				local velocity = -direction:Resized(10)
				owner:AddVelocity(velocity)

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
			end,

			Sounds = {
				Shoot = { Id = mod.Sounds.LauncherShoot,
					VolMin = 0.8, VolMax = 0.85, PitchMin = 0.95, PitchMax = 1.05,
				},
				ReloadStart = { Id = mod.Sounds.LauncherReloadStart,
					VolMin = 0.8, VolMax = 0.8, PitchMin = 0.95, PitchMax = 1.05,
				},
				ReloadClick = { Id = mod.Sounds.LauncherReload,
					VolMin = 0.8, VolMax = 0.8, PitchMin = 0.95, PitchMax = 1.05,
				},
				ReloadFinish = { Id = mod.Sounds.LauncherReloadFinish,
					VolMin = 0.9, VolMax = 0.9, PitchMin = 1.0, PitchMax = 1.0,
				},
			},
		},



		--[[ Special ]]--
		-- Eternal Revolver
		[ gunTypes.REVOLVER_ETERNAL ] = {
			ReplaceAnim = "bounty/guntype_eternal",
			BarrelOffset = Vector(21, 6),
		},
	},
}



-- Copy a table's contents
---@param table table
---@return table
function FiendFolio:CopyTable(table)
	local copy = {}

	for i, entry in pairs(table) do
		if type(entry) == "table" then
			copy[i] = mod:CopyTable(entry)
		else
			copy[i] = entry
		end
	end

	return copy
end



-- Get the data for a gun type and substitue undefined entries with their defaults
---@param gunType integer
---@return table
function mod:GetBountyGunData(gunType)
	local finalData = mod:CopyTable(mod.BountyGunData.Defaults)
	local gunTypeData = mod.BountyGunData.TypeData[gunType]

	if gunTypeData then
		for variable, entry in pairs(gunTypeData) do
			-- Sounds
			if variable == "Sounds" then
				for id, settings in pairs(entry) do
					finalData[variable][id] = settings
				end

			-- Everything else
			else
				finalData[variable] = entry
			end
		end
	end
	return finalData
end