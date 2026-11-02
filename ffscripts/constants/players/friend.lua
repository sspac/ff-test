local mod = FiendFolio
--[[

== TECHINCAL ==
Priority: How important the gun is.
    -1: Base. If anything exists, it should overwrite this.
    100: Most guns, can be overwritten.
    400: If the gun is not using this the world will end.
    1000000: We are all going to die immediately.
CustomFiring: If this is set to true, the gun will not run ANY of its firing code and must be done separately.
ActiveEffect: If this is set to true, the gun will only appear if the collectible effect is present instead of just when you have the item.

== VISUAL ==
HeldOffset: How far out it is held, effects how far out the tear is spawned.
VerticalOffset: Offset vertically of how the gun is held, changes how high up the tear is spawned.
TearHeight: How high up tears are fired
MuzzleOffset: Needed for cosmetic effects+certain attachments
BayonetteOffset: For fine-tuning the position of the bayonette for Mom's Knife / Spear of Destiny
CustomAnim: If this is set to true, the gun will not do any of its animation related code and will need to be done by itself in callbacks
ReplaceAnim: New anm2 file
ReplaceSprite: New spritesheet
SpriteType: What premade animation to use for the gun.
    Default: Switches to a different sprite when reloading. Suitable for revolvers and guns that have a magazine
    Nothing: Uses just one sprite.
    Shoot: Switches to a different sprite when shooting and reloading. Suitable for semiautomatic pistols and pump-action rifles.
Casing: Sets a casing to a certain type.
    Caliber, Shell, Battery, Tooth, None
CasingScale: Scales the sprite of the casing that ejects from the gun when reloading.
Ejection: If set to true the casing gets ejected from the gun when a bullet gets shot, if false the bullet gets manually removed by Friend when reloading (default).
BulletVariant: Set to a tear variant's enum to change the appearance.
BulletSubType: Tear subtype to use
BulletAnim: Anm2 to use for the tear
BulletSprite: Spritesheet to use for the tear
BulletSpriteGold: If set uses custom bullet sprite for the golden briend gun, otherwise use the regular bullet sprite with _gold suffix.
UseDefaultTears: Set to true, and the gun will not try to use the bullet tear variant.

== BRIEND ==
DoesntPreventAlternateFiring: If Briend should be able to use both guns at the same time when this gun is equipped
GoldenValueThreshold: Value amount in HSV colour space above which colours are turned golden for Briend's deagle. Negative values flip the threshold from being above to below the value. (default = 0.2)
GoldenBrightnessTint: Multiplier used on brightness of colours when being turned gold. Higher values turn colors more golden, lower values turn colors more coppery. (Default = 1.0)
GoldenBrightnessOffset: Offset used on brightness of colours when being turned gold. Higher values turn colors more golden, lower values turn colors more coppery. (Default = 0.0)
GoldenSaturationMult: Multiplier (absolute value) used on saturation of colours when being turned gold. Less saturated colours become more golden; negative values flip this so more saturated colours become more golden. (Default = 1.0)
NoBriendHandOffset: Makes the gun not use the hand offsets for the gun (literally only used by Polyphemus)

== SOUL OF FRIEND ==
NoFriendSoul: If set, gun cannot be chosen by Soul of Friend. Fully cosmetic guns should have this as true.
WeaponType: If set, the gun will use this weapon type for Soul of Friend.
MaxLimitedAmmo: If set, changes the maximum ammo the gun will have for Soul of Friend from DefaultMaxLimitedAmmo to this number.
DefaultBulletColor: If set, chooses this bullet color for Soul of Friend.
]]
local gun = "gfx/effects/guns/"
local bullet = "gfx/projectiles/guns/"

-- Default maximum ammo for Soul of Friend
mod.DefaultMaxLimitedAmmo = 20

-- Special fixed subtypes for special guns :0
mod.SpecialFriendGunSubtypes = {
    DAD_TRANSFORMATION = 41400,
    BRIEND_DEAGLE = 41500,
    BRIEND_BIRTHRIGHT = 41600,
}

mod.FriendBulletSubTypes = {
    STAY_VERTICALLY_UPRIGHT = 1
}

mod.FriendGunInfo = {
    [mod.FF.FriendsRevolver.Sub] = {
        Priority = -1,
		NoGolden = true,
        Sounds = { -- Omit any of these tables in a custom gun to just use the defaults. Set to false to never play that sound.
            Equip = { -- Gun equipped after picking up item etc
                {Id=mod.Sounds.GunDraw, VolMin=0.5, VolMax=0.5, PitchMin=0.95, PitchMax=1.05}
            },
            Bullet = { -- Shoot
                {Id=mod.Sounds.RevolverShoot, VolMin=0.5, VolMax=0.7, PitchMin=0.95, PitchMax=1.0}
            },
            BulletMega = { -- Shoot with mega mush (omitting uses gun's Bullet sound but pitched down)
                {Id=SoundEffect.SOUND_GFUEL_GUNSHOT_SPREAD, VolMin=1, VolMax=1, PitchMin=0.9, PitchMax=1.0}
            },
            Rocket = { -- Rocket shoot
                {Id=SoundEffect.SOUND_ROCKET_LAUNCH, VolMin=0.75, VolMax=0.75, PitchMin=0.9, PitchMax=1.0},
            },
            Bomb = { -- Bomb shoot
                {Id=mod.Sounds.GrenadeLauncherFire, VolMin=0.75, VolMax=0.75, PitchMin=0.9, PitchMax=1.0},
            },
            BombCrit = { -- Bomb shoot with crit
                {Id=mod.Sounds.GrenadeLauncherFireCrit, VolMin=0.75, VolMax=0.75, PitchMin=0.9, PitchMax=1.0},
            },
            ReloadStart = false,
            ReloadClick = { -- Reload single bullet
                {Id=mod.Sounds.RevolverReload, VolMin=0.8, VolMax=0.8, PitchMin=1.0, PitchMax=1.1},
            },
            ReloadFinish = { -- Reload finish with sparkles
                {Id=mod.Sounds.RevolverReloadFinish, VolMin=0.5, VolMax=0.5, PitchMin=1.0, PitchMax=1.0},
            },
        }
    },
    [mod.SpecialFriendGunSubtypes.BRIEND_DEAGLE] = { -- Briend's Deagle
        ReplaceSprite = gun .. "desert_eagle.png",
        SpriteType = "Shoot",
        Ejection = true,
        SpriteOffset = Vector(0, -3),
        MuzzleScale = 1.2,
        Priority = -1,
		NoGolden = true,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.MagnumShoot, VolMin=0.5, VolMax=0.7, PitchMin=0.95, PitchMax=1.05}
            },
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=0.9, PitchMax=1.0},
            }
        }
    },
    [mod.SpecialFriendGunSubtypes.DAD_TRANSFORMATION] = { --Dad Transformation Gun
        ReplaceSprite = gun .. "desert_eagle.png",
        SpriteType = "Shoot",
        Ejection = true,
        SpriteOffset = Vector(0, -3),
        MuzzleScale = 1.2,
        Priority = 100,
		NoGolden = true,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.MagnumShoot, VolMin=0.5, VolMax=0.7, PitchMin=0.95, PitchMax=1.05}
            },
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=0.9, PitchMax=1.0},
            }
        }
    },
    -- [Isaac.GetItemIdByName("Grandpa's Gatling Gun")] = {ReplaceSprite = gun .. "minigun.png", VerticalOffset = 8, SpriteType = "Long", Priority = 400, Casing="Caliber"},
    --Vanilla items
    [CollectibleType.COLLECTIBLE_SPIRIT_SWORD] = {
        WeaponType = WeaponType.WEAPON_SPIRIT_SWORD,
        ReplaceAnim = gun .. "guns_angelblade.anm2",
        Priority = 1000000,
        MuzzleOffset = Vector(60, -20),
        DoesntPreventAlternateFiring = true,
    },
    [CollectibleType.COLLECTIBLE_BERSERK] = {
        NoFriendSoul = true,
        WeaponType = WeaponType.WEAPON_SPIRIT_SWORD,
        ReplaceAnim = gun .. "guns_berserkblade.anm2",
        Priority = 2000000,
        ActiveEffect = true,
        MuzzleOffset = Vector(60, -20),
        DoesntPreventAlternateFiring = true,
    },
    [CollectibleType.COLLECTIBLE_EPIC_FETUS] = {
        MaxLimitedAmmo = 10,
        WeaponType = WeaponType.WEAPON_ROCKETS,
        ReplaceSprite = gun .. "m202flash_v2.png",
        TearHeight = -20,
        Priority = 400,
        SpriteOffset = Vector(-16, 3),
        Casing = "None",
        NoMuzzle = true,
        GoldenValueThreshold = 0.02,
		GoldenBrightnessTint = 1.5266,
		GoldenBrightnessOffset = 0.1652,
		GoldenSaturationMult = -6.1,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.LauncherShoot, VolMin=0.8, VolMax=0.85, PitchMin=0.95, PitchMax=1.05}
            },
            ReloadStart = {
                {Id=mod.Sounds.LauncherReloadStart, VolMin=0.8, VolMax=0.8, PitchMin=0.95, PitchMax=1.05},
            },
            ReloadClick = {
                {Id=mod.Sounds.LauncherReload, VolMin=0.6, VolMax=0.7, PitchMin=0.95, PitchMax=1.05},
            },
            ReloadFinish = {
                {Id=mod.Sounds.LauncherReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=1.0, PitchMax=1.0},
            }
        }
    },
    [CollectibleType.COLLECTIBLE_DR_FETUS] = {
        MaxLimitedAmmo = 10,
        WeaponType = WeaponType.WEAPON_BOMBS,
        ReplaceSprite = gun .. "grenade_launcher.png",
        GoldenSprite = gun .. "grenade_launcher_australium.png",
        Priority = 350,
        Casing = "None",
        SpriteOffset = Vector(-8,0),
        BayonetteOffset = Vector(-1,3),
        Sounds = {
            ReloadStart = {
                {Id=mod.Sounds.GrenadeLauncherReloadStart, VolMin=1.0, VolMax=1.0, PitchMin=1.0, PitchMax=1.0}
            },
            ReloadClick = {
                {Id=mod.Sounds.GrenadeLauncherReload, VolMin=1.0, VolMax=1.0, PitchMin=0.85, PitchMax=1.15}
            },
            ReloadFinish = {
                {Id=mod.Sounds.GrenadeLauncherReloadEnd, VolMin=1.0, VolMax=1.0, PitchMin=1.0, PitchMax=1.0}
            }
        },
    },
    [CollectibleType.COLLECTIBLE_TECH_X] = {
        WeaponType = WeaponType.WEAPON_TECH_X,
        ReplaceSprite = gun .. "bfg.png",
        SpriteOffset = Vector(-18,0),
        Priority = 300,
        CasingScale = 2.0,
        Casing = "Battery",
		GoldenValueThreshold = 0.08,
    },
    [CollectibleType.COLLECTIBLE_BRIMSTONE] = {
        WeaponType = WeaponType.WEAPON_BRIMSTONE,
        ReplaceSprite = gun .. "brimstone_gun.png",
        SpriteType = "Nothing",
        SpriteOffset = Vector(-16,-2),
        MuzzleOffset = Vector(50, -16),
        Priority = 250,
        Casing = "None",
		GoldenValueThreshold = -0.48,
		GoldenBrightnessTint = 1.1687,
		GoldenBrightnessOffset = 0.0765,
    },
    [CollectibleType.COLLECTIBLE_MONSTROS_LUNG] = {
        WeaponType = WeaponType.WEAPON_MONSTROS_LUNGS,
        ReplaceSprite = gun .. "shotgun.png",
        BulletSprite = bullet .. "bullet_pellet.png",
        Priority = 200,
        SpriteOffset = Vector(-8,0),
        Ejection = true,
        Casing = "Shell",
		GoldenValueThreshold = 0.11,
		GoldenBrightnessTint = 1.1992,
		GoldenBrightnessOffset = 0.1402,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.ShotgunShoot, VolMin=0.75, VolMax=0.75, PitchMin=0.9, PitchMax=0.95}
            },
            ReloadClick = {
                {Id=mod.Sounds.ShotgunReload, VolMin=0.65, VolMax=0.7, PitchMin=1.2, PitchMax=1.2}
            },
            ReloadFinish = {
                {Id=mod.Sounds.ShotgunReloadFinish, VolMin=1.0, VolMax=1.0, PitchMin=1.3, PitchMax=1.3}
            },
        }
    },
    -- Weezer gun should be below anything that changes how firing works or makes its innate quadshot not make sense, but preferably above anything else.
    [CollectibleType.COLLECTIBLE_MUTANT_SPIDER] = {
        ReplaceSprite = gun .. "weezer.png",
        Priority = 100,
        TearHeight = -12,
        MultiShot = 4
    },
    [CollectibleType.COLLECTIBLE_MARKED] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "marked_gun.png",
        GoldenSprite = gun .. "marked_gun_golden.png",
        SpriteOffset = Vector(-4,0),
        MuzzleOffset = Vector(40, -17),
        Priority = 100,
        SpriteType = "Nothing",
        Ejection = true,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.SMGShoot, VolMin=1.0, VolMax=1.0, PitchMin=0.85, PitchMax=1.15}
            },
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.7, VolMax=0.7, PitchMin=1.0, PitchMax=1.1}
            },
        }
    },
    [CollectibleType.COLLECTIBLE_CURSED_EYE] = {
        WeaponType = WeaponType.WEAPON_TEARS,
        ReplaceSprite = gun .. "cursedeye_gun.png",
        Priority = 200,
        SpriteOffset = Vector(-6,0),
        MuzzleOffset = Vector(44, -17),
        TearHeight = -7,
        MuzzleScale = 0.75,
		GoldenValueThreshold = 0.09,
		GoldenBrightnessTint = 2.0769,
		GoldenBrightnessOffset = 0.1423,
        Ejection = true,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.SMGShoot, VolMin=1.0, VolMax=1.0, PitchMin=0.85, PitchMax=1.15}
            },
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.7, VolMax=0.7, PitchMin=1.0, PitchMax=1.1}
            },
        }
    },
    [CollectibleType.COLLECTIBLE_TECHNOLOGY] = {
        WeaponType = WeaponType.WEAPON_LASER,
        ReplaceSprite = gun .. "laser_gun.png",
        Priority = 300,
        SpriteType = "Nothing",
        SpriteOffset = Vector(-2,0),
        Casing = "Battery",
        MuzzleOffset =  Vector(40, -20),
        BayonetteOffset = Vector(-3,3)
    },
    [CollectibleType.COLLECTIBLE_MYSTERIOUS_LIQUID] = {
        DefaultBulletColor = mod.ColorRainbowGreen,
        ReplaceSprite = gun .. "splattershot_jr.png",
        Priority = 100,
        Casing = "None",
        NoMuzzle = true,
        MuzzleColor = mod:ColorHSV(0.2, 0.5, 0.5, 0.5, 0.15, 1.0, 0.5),
		GoldenBrightnessTint = 0.6837,
		GoldenBrightnessOffset = 0.1,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.SplattershotJrFire, VolMin=1.0, VolMax=1.0, PitchMin=0.85, PitchMax=1.15}
            },
            ReloadFinish = {
                {Id=mod.Sounds.WatergunReloadFinish, VolMin=0.7, VolMax=0.7, PitchMin=1.1, PitchMax=1.1}
            },
        }
    },
    [CollectibleType.COLLECTIBLE_NUMBER_ONE] = {
        ReplaceSprite = gun .. "numberone_gun.png",
		GoldenSprite = gun .. "numberone_gun_golden.png",
        BulletSprite = bullet .. "bullet_pellet.png",
        BayonetteOffset = Vector(-3, 3),
        Priority = 100,
        Casing = "None",
        SpriteType = "Nothing",
        SpriteOffset = Vector(-2,-2),
        MuzzleColor = mod:ColorHSV(0.2, 0.5, 0.5, 0.5, 0.15, 1.0, 0.5),
        DefaultBulletColor = Color.TearNumberOne,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.WatergunShoot, VolMin=1.0, VolMax=1.0, PitchMin=0.90, PitchMax=1.02}
            },
            ReloadClick = {
                {Id=mod.Sounds.WatergunReload, VolMin=0.55, VolMax=0.6, PitchMin=0.9, PitchMax=1.0}
            },
            ReloadFinish = {
                {Id=mod.Sounds.WatergunReloadFinish, VolMin=0.7, VolMax=0.7, PitchMin=1.2, PitchMax=1.2}
            },
        }
    },
    [CollectibleType.COLLECTIBLE_TOUGH_LOVE] = {
        ReplaceAnim = gun .. "guns_teeth.anm2",
		GoldenSprite = gun .. "teeth_gun_golden.png",
        BayonetteOffset = Vector(-25, -20),
        SpriteType = "Large",
        Priority = 100,
        Casing = "Tooth",
        CasingScale = 1.5,
        NoMuzzle = true,
        Sounds = {
            --Bullet = {
            --    {Id=mod.Sounds.WatergunShoot, VolMin=1.0, VolMax=1.0, PitchMin=0.5, PitchMax=0.5}
            --},
            ReloadClick = {
                {Id=mod.Sounds.WatergunShoot, VolMin=0.2, VolMax=0.4, PitchMin=1.5, PitchMax=1.7}
            },
            ReloadFinish = false
        }
    },
    [CollectibleType.COLLECTIBLE_PARASITE] = {
        NoFriendSoul = true,
        ReplaceAnim = gun .. "guns_parasite.anm2",
        TearHeight = -12,
        Priority = 100,
        Casing = "None",
        NoMuzzle = true,
		GoldenSaturationMult = 0.1,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.IrisSpit, VolMin=0.4, VolMax=0.4, PitchMin=1.2, PitchMax=1.4}
            },
            ReloadClick = {
                {Id=mod.Sounds.WatergunReload, VolMin=0.55, VolMax=0.6, PitchMin=0.6, PitchMax=1.7}
            },
            ReloadFinish = {
                {Id=mod.Sounds.WatergunShoot, VolMin=0.7, VolMax=0.7, PitchMin=0.65, PitchMax=0.7}
            },
        }
    },
    [CollectibleType.COLLECTIBLE_CAMO_UNDIES] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "parasonic_d2.png",
        BulletSprite = bullet .. "bullet_hollowpoint.png",
        BayonetteOffset = Vector(-3, 3),
        Priority = 100,
        SpriteType = "Nothing",
        Ejection = true,
        MuzzleOffset = Vector(64, -16),
        MuzzleScale = 0.8,
        NoMuzzle = true,
		GoldenValueThreshold = 0.07,
		GoldenBrightnessTint = 1.8,
		GoldenBrightnessOffset = 0.116,
		GoldenSaturationMult = 0.5,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.SilencedPistolFire, VolMin=0.45, VolMax=0.55, PitchMin=0.9, PitchMax=1.0}
            }
        }
    },
    [CollectibleType.COLLECTIBLE_9_VOLT] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "battery_gun.png",
        BayonetteOffset = Vector(-3, 3),
        Ejection = true,
        SpriteOffset = Vector(0,-3),
        Priority = 100,
        SpriteType = "Nothing",
        Sounds = {
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=1.4, PitchMax=1.4},
            }
        }
    },
	[CollectibleType.COLLECTIBLE_BACKSTABBER] = {
        ReplaceSprite = gun .. "ambassador.png",
		GoldenSprite = gun .. "ambassador_australium.png",
        BulletSprite = bullet .. "projectile_golem_ar_bullet_friend.png",
        BulletSpriteGold = bullet .. "projectile_golem_ar_bullet_friend_gold.png",
        Priority = 100,
        SpriteOffset = Vector(-1,-2),
        MuzzleOffset = Vector(58, -20),
        MuzzleScale = 1.3,
        BulletVariant = mod.TEAR.GOLEMS_AR_BULLET,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.AmbassadorFire, VolMin=0.1, VolMax=0.2, PitchMin=1.7, PitchMax=1.9}
            }
        }
    },
	[CollectibleType.COLLECTIBLE_NEPTUNUS] = {
        ReplaceSprite = gun .. "minishark.png",
        Priority = 100,
        SpriteType = "Nothing",
        SpriteOffset = Vector(-2,0),
        MuzzleOffset = Vector(50, -16),
        BayonetteOffset = Vector(-3, 6),
        TearHeight = -6,
        MuzzleScale = 0.9,
		GoldenValueThreshold = 0.07,
		GoldenBrightnessTint = 1.8363,
		GoldenBrightnessOffset = 0.1166,
        Ejection = true,
        DoesntPreventAlternateFiring = true,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.MinisharkFire, VolMin=1.0, VolMax=1.0, PitchMin=0.85, PitchMax=1.15}
            },
            ReloadFinish = {
                {Id=mod.Sounds.RevolverReloadFinish, VolMin=0.4, VolMax=0.4, PitchMin=0.55, PitchMax=0.55},
            }
        }
    },
    [CollectibleType.COLLECTIBLE_TREASURE_MAP] = {
        NoFriendSoul = true,
        ReplaceAnim = gun .. "guns_map.anm2",
        BayonetteOffset = Vector(-6, 32),
        SpriteType = "Large",
        SpriteOffset = Vector(-2, 4),
        NoMuzzle = true,
        Casing = "None",
        Priority = 100,
    },
	--[[[CollectibleType.COLLECTIBLE_TRISAGION] = { --this doesn't freaking work, needs to be set in cosmetic.lua
        ReplaceSprite = gun .. "airzooka.png",
        SpriteType = "Nothing",
        Priority = 100,
        NoMuzzle = true,
        Casing = "None"
    },]]
	[CollectibleType.COLLECTIBLE_LEAD_PENCIL] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "leadpencil_gun.png",
        BulletSprite = bullet .. "bullet_pellet.png",
        Priority = 100,
        SpriteOffset = Vector(-4, -1),
        MuzzleOffset = Vector(52, -20),
        BayonetteOffset = Vector(-2, 4),
        SpriteType = "Shoot",
		GoldenValueThreshold = 0.11,
		GoldenBrightnessTint = 1.5097,
		GoldenBrightnessOffset = 0.0753,
        Ejection = true,
        Casing = "Shell",
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.RevolverShoot, VolMin=0.6, VolMax=0.65, PitchMin=0.7, PitchMax=0.8}
            },
            ReloadFinish = {
                {Id=mod.Sounds.ShotgunReloadFinish, VolMin=1.0, VolMax=1.0, PitchMin=1.4, PitchMax=1.4}
            },
        }
    },
    [CollectibleType.COLLECTIBLE_DEAD_EYE] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "deadeye_gun.png",
        MuzzleOffset = Vector(54, -19),
        Priority = 100,
		GoldenValueThreshold = 0.15,
		GoldenBrightnessTint = 1.5097,
		GoldenBrightnessOffset = 0.0753,
    },
    [CollectibleType.COLLECTIBLE_SAD_ONION] = {
        NoFriendSoul = true,
        --ReplaceAnim = gun .. "guns_pistol.anm2",
        ReplaceSprite = gun .. "1911.png",
        SpriteType = "Shoot",
        BayonetteOffset = Vector(-4, 2),
        SpriteOffset = Vector(0, -3),
        Ejection = true,
        Priority = 100,
		GoldenValueThreshold = 0.25,
        Sounds = {
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=1.1, PitchMax=1.2},
            }
        }
    },
    [CollectibleType.COLLECTIBLE_GODHEAD] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "1911_holy.png",
        SpriteType = "Shoot",
        BayonetteOffset = Vector(-4, 2),
        SpriteOffset = Vector(0, -3),
        Ejection = true,
        MuzzleScale = 1.2,
        Priority = 100,
		GoldenValueThreshold = -0.99,
		GoldenBrightnessTint = 0.8350,
		GoldenBrightnessOffset = 0.0350,
		GoldenSaturationMult = 0.01,
         Sounds = {
            Bullet = {
                {Id=mod.Sounds.MagnumShoot, VolMin=0.55, VolMax=0.7, PitchMin=1.25, PitchMax=1.35}
            },
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=1.0, PitchMax=1.1},
            }
        }
    },
    [CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "revolver_golden.png",
        GoldenValueThreshold = 0.0,
        GoldenBrightnessTint = 0.75,
		GoldenBrightnessOffset = 0.1,
		GoldenSaturationMult = 0.02,
        Priority = 100,
    },
    [CollectibleType.COLLECTIBLE_STEVEN] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "revolver_steven.png",
        Priority = 100,
    },
    [CollectibleType.COLLECTIBLE_EYE_OF_GREED] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "revolver_golden.png",
        GoldenValueThreshold = 0.0,
        GoldenBrightnessTint = 0.75,
		GoldenBrightnessOffset = 0.1,
		GoldenSaturationMult = 0.02,
        Priority = 100,
    },
    [CollectibleType.COLLECTIBLE_MARK] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "desert_eagle_normal.png",
		GoldenSprite = gun .. "desert_eagle.png",
        BayonetteOffset = Vector(-3, 2),
        SpriteType = "Shoot",
        Ejection = true,
        SpriteOffset = Vector(0, -3),
        MuzzleScale = 1.2,
        Priority = 100,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.MagnumShoot, VolMin=0.5, VolMax=0.7, PitchMin=0.95, PitchMax=1.05}
            },
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=0.9, PitchMax=1.0},
            }
        }
    },
    [CollectibleType.COLLECTIBLE_SPOON_BENDER] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "spoonbender_gun.png",
        GoldenSprite = gun .. "spoonbender_gun_golden.png",
        BayonetteOffset = Vector(5, -1),
        Ejection = true,
        SpriteOffset = Vector(-4, 2),
        MuzzleOffset = Vector(54, -24),
        MuzzleScale = 0.9,
        Priority = 100,
        MuzzleColor = mod:ColorHSV(0.8, 0.5, 1.0, 1.0, 0.8, 1.0, 0.85),
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.SMGShoot, VolMin=1.0, VolMax=1.0, PitchMin=0.85, PitchMax=1.15}
            },
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.8, VolMax=0.8, PitchMin=1.0, PitchMax=1.1}
            },
        }
    },
    [CollectibleType.COLLECTIBLE_SOY_MILK] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "thompson.png",
        BayonetteOffset = Vector(0, 3),
        SpriteType = "Shoot",
        SpriteOffset = Vector(-8, -1),
        Ejection = true,
        MuzzleScale = 0.75,
        Priority = 100,
		GoldenValueThreshold = 0.12,
		GoldenBrightnessTint = 1.5097,
		GoldenBrightnessOffset = 0.07533,
        Sounds = {
            --Bullet = {
            --    {Id=mod.Sounds.SMGShoot, VolMin=1.0, VolMax=1.0, PitchMin=0.85, PitchMax=1.15}
            --},
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.8, VolMax=0.8, PitchMin=1.0, PitchMax=1.1}
            },
        }
    },
    [CollectibleType.COLLECTIBLE_JACOBS_LADDER] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "lightgun_85.png",
        GoldenSprite = gun .. "lightgun_89.png",
        BulletSprite = bullet .. "bullet_blaster.png",
        SpriteType = "Nothing",
        SpriteOffset = Vector(-4, -2),
        Ejection = true,
        Casing = "Battery",
        NoMuzzle = true,
        Priority = 100,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.SMGShoot, VolMin=1.0, VolMax=1.0, PitchMin=0.85, PitchMax=1.15}
            },
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.8, VolMax=0.8, PitchMin=1.0, PitchMax=1.1}
            },
        }
    },
    [CollectibleType.COLLECTIBLE_POLYPHEMUS] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "",
        BulletSprite = bullet .. "bullet_slug.png",
        Ejection = true,
        CasingScale = 2.0,
        MuzzleOffset = Vector(20, -40),
        MuzzleScale = 1.5,
        NoBriendHandOffset = true,
        Priority = 100,
        Sounds = {
             Bullet = {
                {Id=mod.Sounds.HandcannonShoot, VolMin=0.6, VolMax=0.65, PitchMin=0.9, PitchMax=1.0}
            },
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=0.9, PitchMax=1.0},
            }
        }
    },
    [CollectibleType.COLLECTIBLE_EYE_OF_THE_OCCULT] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "emperor.png",
        BulletSprite = bullet .. "bullet_armorpiercing.png",
        BayonetteOffset = Vector(-3, 2),
        SpriteOffset = Vector(-3, 0),
        Casing = "None",
        MuzzleColor = mod:ColorHSV(0.8, 0.5, 0.7, 1.0, 0.8, 1.0, 0.5),
        Priority = 100,
		GoldenSaturationMult = 0.01,
    },
    [CollectibleType.COLLECTIBLE_CHOCOLATE_MILK] = {
        WeaponType = WeaponType.WEAPON_TEARS,
        DefaultBulletColor = Color.TearChocolate,
        ReplaceSprite = gun .. "cannon_v2.png",
        BulletSprite = bullet .. "bullet_pellet.png",
        BayonetteOffset = Vector(-3, 10),
        SpriteOffset = Vector(-15, 0),
        MuzzleOffset = Vector(44, -10),
        Casing = "None",
        MuzzleScale = 1.4,
        Priority = 200,
		GoldenValueThreshold = 0.02,
		GoldenBrightnessTint = 1.9778,
		GoldenBrightnessOffset = 0.2924,
        Sounds = {
             Bullet = {
                {Id=mod.Sounds.HandcannonShoot, VolMin=0.6, VolMax=0.65, PitchMin=0.9, PitchMax=1.0}
            },
            ReloadStart = {
                {Id=mod.Sounds.LauncherReloadStart, VolMin=0.8, VolMax=0.8, PitchMin=0.95, PitchMax=1.05},
            },
            ReloadClick = {
                {Id=mod.Sounds.LauncherReload, VolMin=0.8, VolMax=0.8, PitchMin=0.95, PitchMax=1.05},
            },
            ReloadFinish = {
                {Id=mod.Sounds.LauncherReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=1.0, PitchMax=1.0},
            }
        }
    },
    [CollectibleType.COLLECTIBLE_FIRE_MIND] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "birds_eye_gun.png",
        SpriteOffset = Vector(-1, 0),
        MuzzleOffset = Vector(56, -20),
        Priority = 100,
		GoldenValueThreshold = 0.15,
		GoldenBrightnessTint = 0.8575,
		GoldenBrightnessOffset = 0.2063,
        Sounds = {
             Bullet = {
                {Id=mod.Sounds.FlareShoot, VolMin=0.7, VolMax=0.75, PitchMin=0.95, PitchMax=1.1}
            },
        }
    },
    [CollectibleType.COLLECTIBLE_BIRDS_EYE] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "flare_gun.png",
        Casing = "Shell",
        SpriteOffset = Vector(-4, 0),
        NoMuzzle = true,
        Priority = 100,
		GoldenValueThreshold = 0.37,
		GoldenBrightnessTint = 1.2371,
		GoldenBrightnessOffset = -0.2112,
		GoldenSaturationMult = 0.1,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.FlareShoot, VolMin=0.7, VolMax=0.75, PitchMin=0.95, PitchMax=1.1}
            },
            ReloadStart = {
                {Id=mod.Sounds.FlareReloadFinish, VolMin=0.5, VolMax=0.5, PitchMin=1.3, PitchMax=1.4},
            },
            ReloadFinish = {
                {Id=mod.Sounds.FlareReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=0.9, PitchMax=1.1},
            }
        }
    },
    [CollectibleType.COLLECTIBLE_GHOST_PEPPER] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "flare_gun_blue.png",
        Casing = "Shell",
        SpriteOffset = Vector(-4, 0),
        NoMuzzle = true,
        Priority = 100,
		GoldenValueThreshold = 0.37,
		GoldenBrightnessTint = 1.2371,
		GoldenBrightnessOffset = -0.2112,
		GoldenSaturationMult = 0.25,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.FlareShoot, VolMin=0.7, VolMax=0.75, PitchMin=0.95, PitchMax=1.1}
            },
            ReloadStart = {
                {Id=mod.Sounds.FlareReloadFinish, VolMin=0.5, VolMax=0.5, PitchMin=1.3, PitchMax=1.4},
            },
            ReloadFinish = {
                {Id=mod.Sounds.FlareReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=0.9, PitchMax=1.1},
            }
        }
    },
    [CollectibleType.COLLECTIBLE_PEPPERMINT] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "flare_gun_blue.png",
        Casing = "Shell",
        SpriteOffset = Vector(-4, 0),
        NoMuzzle = true,
        Priority = 100,
		GoldenValueThreshold = 0.37,
		GoldenBrightnessTint = 1.2371,
		GoldenBrightnessOffset = -0.2112,
		GoldenSaturationMult = 0.25,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.FlareShoot, VolMin=0.7, VolMax=0.75, PitchMin=0.95, PitchMax=1.1}
            },
            ReloadStart = {
                {Id=mod.Sounds.FlareReloadFinish, VolMin=0.5, VolMax=0.5, PitchMin=1.3, PitchMax=1.4},
            },
            ReloadFinish = {
                {Id=mod.Sounds.FlareReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=0.9, PitchMax=1.1},
            }
        }
    },
    [CollectibleType.COLLECTIBLE_PUPULA_DUPLEX] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "pupuladuplex_gun.png",
        UseDefaultTears = true,
        Casing = "None",
        SpriteType = "Nothing",
        SpriteOffset = Vector(-4, -1),
        MuzzleScale = 1.1,
        MuzzleColor = mod:ColorHSV(0.0, 0.0, 1.0, 1, 0.5, 1.0, 0.8),
        Priority = 100,
		GoldenValueThreshold = -0.82,
		GoldenBrightnessTint = 1.1304,
		GoldenBrightnessOffset = -0.2157,
		GoldenSaturationMult = 0.01,
    },
    [CollectibleType.COLLECTIBLE_EUTHANASIA] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "syringe_gun.png",
        BulletSprite = bullet .. "bullet_flechette.png",
        SpriteOffset = Vector(-1, 0),
        NoMuzzle = true,
        Casing = "None",
        Priority = 100,
		GoldenValueThreshold = 0.15,
		GoldenBrightnessTint = 1.8333,
		GoldenBrightnessOffset = -0.0250,
		GoldenSaturationMult = 2.0,
    },
    [CollectibleType.COLLECTIBLE_PARASITOID] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "hivehand.png",
        UseDefaultTears = true,
        SpriteOffset = Vector(-3, -4),
        Casing = "None",
        NoMuzzle = true,
        Priority = 100,
		GoldenValueThreshold = 0.1,
		GoldenBrightnessTint = 0.9474,
		GoldenBrightnessOffset = 0.3358,
		GoldenSaturationMult = 1.2,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.WatergunShoot, VolMin=0.5, VolMax=0.6, PitchMin=1.2, PitchMax=1.4}
            },
            ReloadClick = {
                {Id=mod.Sounds.WatergunReload, VolMin=0.55, VolMax=0.6, PitchMin=0.6, PitchMax=1.7}
            },
            ReloadFinish = {
                {Id=mod.Sounds.WatergunShoot, VolMin=0.7, VolMax=0.7, PitchMin=0.65, PitchMax=0.7}
            },
        }
    },
    [CollectibleType.COLLECTIBLE_MULLIGAN] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "hivehand.png",
        UseDefaultTears = true,
        SpriteOffset = Vector(-3, -4),
        Casing = "None",
        NoMuzzle = true,
        Priority = 100,
		GoldenValueThreshold = 0.1,
		GoldenBrightnessTint = 0.9474,
		GoldenBrightnessOffset = 0.3358,
		GoldenSaturationMult = 1.2,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.WatergunShoot, VolMin=0.5, VolMax=0.6, PitchMin=1.2, PitchMax=1.4}
            },
            ReloadClick = {
                {Id=mod.Sounds.WatergunReload, VolMin=0.55, VolMax=0.6, PitchMin=0.6, PitchMax=1.7}
            },
            ReloadFinish = {
                {Id=mod.Sounds.WatergunShoot, VolMin=0.7, VolMax=0.7, PitchMin=0.65, PitchMax=0.7}
            },
        }
    },
    [CollectibleType.COLLECTIBLE_RUBBER_CEMENT] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "glooga_dualie.png",
		GoldenSprite = gun .. "glooga_dualie_deco.png",
        BulletSprite = bullet .. "bullet_pellet.png",
        SpriteType = "Nothing",
        SpriteOffset = Vector(-3, 0),
        MuzzleOffset = Vector(33, -20),
        Casing = "None",
        MuzzleColor = mod:ColorHSV(0.3, 0.2, 1.0, 1, 0.4, 0.6, 0.6),
        Priority = 100,
        Sounds = {
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=1.3, PitchMax=1.4},
            }
        }
    },
    [CollectibleType.COLLECTIBLE_SINUS_INFECTION] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "glooga_dualie.png",
		GoldenSprite = gun .. "glooga_dualie_deco.png",
        BulletSprite = bullet .. "bullet_pellet.png",
        SpriteType = "Nothing",
        SpriteOffset = Vector(-3, 0),
        MuzzleOffset = Vector(33, -20),
        Casing = "None",
        MuzzleColor = mod:ColorHSV(0.3, 0.2, 1.0, 1, 0.4, 0.6, 0.6),
        Priority = 100,
        Sounds = {
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=1.3, PitchMax=1.4},
            }
        }
    },
    [CollectibleType.COLLECTIBLE_EXPLOSIVO] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "zhukovnuk17.png",
        BulletSprite = bullet .. "bullet_hollowpoint.png",
        BayonetteOffset = Vector(0, 3),
        SpriteOffset = Vector(-3, 0),
        MuzzleOffset = Vector(40, -20),
        Ejection = true,
        --MuzzleColor = mod:ColorHSV(0.3, 0.2, 1.0, 1, 0.4, 0.6, 0.6),
        MuzzleColor = mod:ColorHSV(0.4, 0.0, 0.7, 1, 0.5, 1.0, 0.7),
        GoldenValueThreshold = 0.2,
        GoldenBrightnessTint = 0.65,
        GoldenBrightnessOffset = 0.27,
        GoldenSaturationMult = 0.0,
        Priority = 100,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.SMGShoot, VolMin=0.6, VolMax=0.7, PitchMin=1.35, PitchMax=1.5}
            },
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=1.3, PitchMax=1.4},
            }
        }
    },
    [CollectibleType.COLLECTIBLE_SACRED_HEART] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "holy_shotgun.png",
        BulletSprite = bullet .. "bullet_slug.png",
        BayonetteOffset = Vector(4, 2),
        SpriteOffset = Vector(-6, 0),
        Ejection = true,
        Casing = "Shell",
        MuzzleScale = 1.2,
        Priority = 100,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.ShotgunShoot, VolMin=0.5, VolMax=0.6, PitchMin=1.05, PitchMax=1.1}
            },
            ReloadStart = {
                {Id=mod.Sounds.LauncherReloadStart, VolMin=0.8, VolMax=0.8, PitchMin=0.95, PitchMax=1.05},
            },
            ReloadClick = {
                {Id=mod.Sounds.ShotgunReload, VolMin=0.8, VolMax=0.8, PitchMin=0.95, PitchMax=1.05},
            },
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=1.0, PitchMax=1.1},
            }
        }
    },
    [CollectibleType.COLLECTIBLE_IPECAC] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "toxbomblauncher.png",
        BulletAnim = bullet .. "bullet_gyrojet.anm2",
        BayonetteOffset = Vector(-6, 0),
        SpriteOffset = Vector(-12, 3),
        Casing = "Shell",
        CasingScale = 1.5,
        Ejection = true,
        MuzzleColor = mod:ColorHSV(0.2, 0.0, 0.7, 1, 0.3, 1.0, 0.7),
        MuzzleScale = 0.65,
        Priority = 100,
		GoldenValueThreshold = 0.02,
		GoldenBrightnessTint = 1.2266,
		GoldenBrightnessOffset = 0.0652,
		GoldenSaturationMult = 2.1,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.LauncherShoot, VolMin=0.8, VolMax=0.85, PitchMin=0.95, PitchMax=1.15}
            },
            ReloadStart = {
                {Id=mod.Sounds.LauncherReloadStart, VolMin=0.8, VolMax=0.8, PitchMin=0.95, PitchMax=1.05},
            },
            ReloadClick = {
                {Id=mod.Sounds.LauncherReload, VolMin=0.8, VolMax=0.8, PitchMin=1.15, PitchMax=1.25},
            },
            ReloadFinish = {
                {Id=mod.Sounds.LauncherReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=1.0, PitchMax=1.0},
            }
        }
    },
    [CollectibleType.COLLECTIBLE_MY_REFLECTION] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "my_reflection.png",
        MuzzleOffset = Vector(17, -24),
        SpriteOffset = Vector(-6, 8),
        Priority = 100,
    },
    [CollectibleType.COLLECTIBLE_3_DOLLAR_BILL] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "pink_m16.png",
        SpriteType = "Bolt",
        SpriteOffset = Vector(-12, 0),
        Ejection = true,
        MuzzleScale = 0.9,
        Priority = 100,
        MuzzleColor = mod:ColorHSV(0.0, 0.0, 1.0, 1, 0.7, 0.8, 0.9),
        MuzzleOffset = Vector(45, -18),
		GoldenBrightnessTint = 1.3684,
		GoldenBrightnessOffset = -0.5726,
		GoldenSaturationMult = 0.1,
        Sounds = {
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=1.0, PitchMax=1.1},
            }
        }
    },
    [CollectibleType.COLLECTIBLE_URANUS] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "freezeray.png",
        BulletSprite = bullet .. "bullet_blaster_green.png",
        BulletSpriteGold = bullet .. "bullet_blaster_gold.png",
        Priority = 100,
        SpriteOffset = Vector(-2,0),
        Casing = "Battery",
        NoMuzzle = true,
        BayonetteOffset = Vector(-3,3),
		GoldenValueThreshold = 0.13,
		GoldenBrightnessOffset = 1.6299,
		GoldenBrightnessTint = 0.0320,
    },
    [CollectibleType.COLLECTIBLE_EVES_MASCARA] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "lawgiver.png",
        BulletSprite = bullet .. "bullet_armorpiercing.png",
        BayonetteOffset = Vector(4, 2),
        Priority = 100,
        MuzzleColor = mod:ColorHSV(0.0, 0.2, 1.0, 1, 0.05, 1.0, 0.85),
        SpriteOffset = Vector(-3,0),
		GoldenBrightnessTint = 1.625,
		GoldenBrightnessOffset = 0.03375,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.MagnumShoot, VolMin=0.55, VolMax=0.6, PitchMin=0.9, PitchMax=0.95}
            },
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=1.0, PitchMax=1.1},
            }
        }
    },
    [CollectibleType.COLLECTIBLE_KNOCKOUT_DROPS] = {
        NoFriendSoul = true,
        ReplaceAnim = gun .. "guns_kodrops.anm2",
		GoldenSprite = gun .. "kodropsgun_golden.png",
        BulletSprite = bullet .. "bullet_pellet.png",
        BayonetteOffset = Vector(-16, -10),
        Priority = 100,
        SpriteOffset = Vector(-4,0),
        Casing = "None",
        NoMuzzle = true,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.NTPistolShoot, VolMin=0.35, VolMax=0.45, PitchMin = 1.55, PitchMax = 2.05}
            },
            ReloadClick = {
                {Id=mod.Sounds.RevolverShoot, VolMin=0.3, VolMax=0.4, PitchMin=2.0, PitchMax=2.55},
            },
            ReloadFinish = {
                {Id=mod.Sounds.ShotgunReloadFinish, VolMin=1.0, VolMax=1.0, PitchMin=1.9, PitchMax=2.0},
            },
        }
    },
    [CollectibleType.COLLECTIBLE_GODS_FLESH] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "godsflesh.png",
        BayonetteOffset = Vector(8, 5),
        SpriteOffset = Vector(-12, 0),
        Ejection = true,
        MuzzleScale = 0.9,
        Priority = 100,
        MuzzleOffset = Vector(50, -18),
		GoldenValueThreshold = 0.06,
		GoldenBrightnessTint = 2.8516,
		GoldenBrightnessOffset = 0.0225,
		GoldenSaturationMult = 1.25,
        Sounds = {
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=1.0, PitchMax=1.1},
            }
        }
    },
    [CollectibleType.COLLECTIBLE_ROTTEN_TOMATO] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "rottentomato.png",
        UseDefaultTears = true,
        SpriteOffset = Vector(-12, 0),
        Ejection = true,
        MuzzleScale = 0.9,
        Priority = 100,
        NoMuzzle = true,
		GoldenValueThreshold = 0.155,
		GoldenBrightnessTint = 0.8429,
		GoldenBrightnessOffset = 0.1594,
		GoldenSaturationMult = 0.4,
        Sounds = {
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=1.0, PitchMax=1.1},
            }
        }
    },
    [CollectibleType.COLLECTIBLE_DEATHS_TOUCH] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "rsh12.png",
        BulletSprite = bullet .. "bullet_armorpiercing.png",
        BayonetteOffset = Vector(4, 2),
        SpriteType = "Bolt",
        SpriteOffset = Vector(-4, 0),
        MuzzleOffset = Vector(44, -18),
        MuzzleColor = mod:ColorHSV(0.0, 0.0, 1.0, 1, 0.05, 0.85, 0.9),
        MuzzleScale = 1.2,
        CasingScale = 1.3,
        Priority = 100,
		GoldenValueThreshold = 0.04,
		GoldenBrightnessTint = 2.2657,
		GoldenBrightnessOffset = -0.0373,
        Sounds = {
             Bullet = {
                {Id=mod.Sounds.MagnumShoot, VolMin=0.6, VolMax=0.65, PitchMin=0.95, PitchMax=1.05}
            },
        }
    },
    [CollectibleType.COLLECTIBLE_8_INCH_NAILS] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "nailer.png",
        BulletSprite = bullet .. "bullet_flechette.png",
        Casing = "None",
        Priority = 100,
		GoldenSaturationMult = 0.1,
		GoldenBrightnessTint = 0.6207,
		GoldenBrightnessOffset = 0.1172,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.SilencedPistolFire, VolMin=0.45, VolMax=0.55, PitchMin=1.1, PitchMax=1.6}
            }
        }

    },
    [CollectibleType.COLLECTIBLE_SAGITTARIUS] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "fiveseven.png",
        BulletSprite = bullet .. "bullet_armorpiercing.png",
        BayonetteOffset = Vector(-3, 3),
        SpriteType = "Shoot",
        Ejection = true,
        Priority = 100,
		GoldenValueThreshold = 0.07,
		GoldenBrightnessTint = 2.3636,
		GoldenBrightnessOffset = 0.0164,
        Sounds = {
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=1.0, PitchMax=1.1},
            }
        }
    },
    [CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "revolver_carbine.png",
        MuzzleOffset = Vector(48, -20),
        Priority = 100,
    },
    [CollectibleType.COLLECTIBLE_PROPTOSIS] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "judge.png",
        BulletSprite = bullet .. "bullet_slug.png",
        SpriteOffset = Vector(-4, 0),
        MuzzleOffset = Vector(38, -20),
        Priority = 100,
        Casing = "Shell",
		GoldenValueThreshold = 0.04,
		GoldenBrightnessTint = 2.2657,
		GoldenBrightnessOffset = -0.0373,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.ShotgunShoot, VolMin=0.75, VolMax=0.75, PitchMin=1.25, PitchMax=1.3}
            },
        }
    },
    [CollectibleType.COLLECTIBLE_BODY] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "big_cylinder.png",
        BayonetteOffset = Vector(0, -4),
        MuzzleOffset = Vector(44, -24),
        TearHeight = -19,
        Priority = 100,
    },
    [CollectibleType.COLLECTIBLE_MAXS_HEAD] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "mateba.png",
        BulletSprite = bullet .. "bullet_hollowpoint.png",
        SpriteOffset = Vector(-2, 0),
        MuzzleScale = 1.1,
        Priority = 100,
		GoldenBrightnessTint = 1.2817,
		GoldenBrightnessOffset = -0.0143,
        Sounds = {
             Bullet = {
                {Id=mod.Sounds.RevolverShoot, VolMin=0.6, VolMax=0.8, PitchMin=0.75, PitchMax=0.8}
            },
        }
    },
    [CollectibleType.COLLECTIBLE_TOOTH_PICKS] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "mauser.png",
        Ejection = true,
        Priority = 100,
		GoldenBrightnessTint = 1.1186,
		GoldenBrightnessOffset = -0.0427,
        Sounds = {
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.8, VolMax=0.8, PitchMin=1.0, PitchMax=1.1}
            },
        }
    },
    [CollectibleType.COLLECTIBLE_MONEY_EQUALS_POWER] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "transactionalrifle.png",
        BayonetteOffset = Vector(6, 2),
        SpriteOffset = Vector(-16, 0),
        Ejection = true,
        Priority = 100,
        MuzzleScale = 0.8,
		GoldenValueThreshold = 0.11,
		GoldenBrightnessTint = 1.3549,
		GoldenBrightnessOffset = 0.1263,
        Sounds = {
            ReloadStart = {
                {Id=mod.Sounds.GarandPing, VolMin=0.05, VolMax=0.5, PitchMin=0.90, PitchMax=1.05},
            },
            ReloadFinish = {
                {Id=mod.Sounds.ShotgunReloadFinish, VolMin=0.85, VolMax=0.90, PitchMin=1.90, PitchMax=2.05},
            },
        }
    },
    [CollectibleType.COLLECTIBLE_CUPIDS_ARROW] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "xbow_gun.png",
        BulletSprite = bullet .. "bullet_arrow.png",
        BayonetteOffset = Vector(0, 3),
        Casing = "None",
        SpriteOffset = Vector(-7, 0),
        NoMuzzle = true,
        SpriteType = "Shoot",
        Priority = 100,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.SplattershotJrFire, VolMin=1.0, VolMax=1.0, PitchMin=1.0, PitchMax=1.35}
            },
            ReloadClick = {
                {Id=mod.Sounds.RevolverShoot, VolMin=0.3, VolMax=0.4, PitchMin=2.0, PitchMax=2.55},
            },
            ReloadFinish = {
                {Id=mod.Sounds.ShotgunReloadFinish, VolMin=1.0, VolMax=1.0, PitchMin=1.9, PitchMax=2.0},
            },
        }
    },
    [CollectibleType.COLLECTIBLE_ALMOND_MILK] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "micro_uzi.png",
        BayonetteOffset = Vector(-2, 0),
        --SpriteType = "Shoot",
        SpriteOffset = Vector(-2, -1),
        MuzzleOffset = Vector(40, -20),
        Ejection = true,
        MuzzleScale = 0.75,
        Priority = 100,
		GoldenValueThreshold = 0.08,
		GoldenBrightnessTint = 1.8569,
		GoldenBrightnessOffset = -0.0474,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.SMGShoot, VolMin=0.5, VolMax=0.9, PitchMin=0.75, PitchMax=1.95}
            },
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.8, VolMax=0.8, PitchMin=1.0, PitchMax=1.1}
            },
        }
    },
    [CollectibleType.COLLECTIBLE_SKELETON_KEY] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "service_with_a_smile.png",
        SpriteOffset = Vector(-7, 0),
        MuzzleColor = mod:ColorHSV(0.05, 0.5, 0.7, 0.75, 0.1, 0.8, 0.5),
        SpriteType = "Nothing",
        Priority = 100,
    },
    -- this gun appears too often, maybe i will change my mind later
    --[[
    [CollectibleType.COLLECTIBLE_MOMS_KEY] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "service_with_a_smile.png",
        SpriteOffset = Vector(-7, 0),
        MuzzleColor = mod:ColorHSV(0.05, 0.5, 0.7, 0.75, 0.1, 0.8, 0.5),
        SpriteType = "Nothing",
        Priority = 100,
    },
    [CollectibleType.COLLECTIBLE_LATCH_KEY] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "service_with_a_smile.png",
        SpriteOffset = Vector(-7, 0),
        MuzzleColor = mod:ColorHSV(0.05, 0.5, 0.7, 0.75, 0.1, 0.8, 0.5),
        SpriteType = "Nothing",
        Priority = 100,
    },
    ]]
    [CollectibleType.COLLECTIBLE_CHAOS] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "chaos.png",
        BulletSprite = bullet .. "bullet_pellet.png",
        BayonetteOffset = Vector(-4, -8),
        MuzzleOffset = Vector(40, -25),
        SpriteType = "Nothing",
        Priority = 100,
        Casing = "None",
    },
    [CollectibleType.COLLECTIBLE_BLACK_BEAN] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "killer_pistol.png",
        BayonetteOffset = Vector(-4, 2),
        SpriteType = "Shoot",
        MuzzleOffset = Vector(44, -25),
        SpriteOffset = Vector(0, -3),
        Ejection = true,
        Priority = 100,
		GoldenValueThreshold = -0.5,
		GoldenBrightnessTint = 1.0,
		GoldenBrightnessOffset = 0.1,
		GoldenSaturationMult = 0.7,
        Sounds = {
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=1.1, PitchMax=1.2},
            }
        }
    },
    [CollectibleType.COLLECTIBLE_LINGER_BEAN] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "killer_pistol.png",
        BayonetteOffset = Vector(-4, 2),
        SpriteType = "Shoot",
        MuzzleOffset = Vector(44, -25),
        SpriteOffset = Vector(0, -3),
        Ejection = true,
        Priority = 100,
		GoldenValueThreshold = -0.5,
		GoldenBrightnessTint = 1.0,
		GoldenBrightnessOffset = 0.1,
		GoldenSaturationMult = 0.7,
        Sounds = {
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=1.1, PitchMax=1.2},
            }
        }
    },
    [CollectibleType.COLLECTIBLE_STEVEN] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "steven_revolver.png",
        Priority = 100,
    },
    [CollectibleType.COLLECTIBLE_HOLY_LIGHT] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "angelicrifle.png",
        Priority = 100,
        Ejection = true,
        SpriteOffset = Vector(-5, 3),
        GoldenValueThreshold = -2.5,
        GoldenBrightnessTint = 3.0,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.MagnumShoot, VolMin=0.5, VolMax=0.7, PitchMin=0.95, PitchMax=1.05}
            },
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=1.1, PitchMax=1.2},
            }
        }
    },
    [CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "backlace_powered.png",
        Priority = 100,
        Ejection = true,
        SpriteOffset = Vector(-5, 3),
        GoldenValueThreshold = .4,
        GoldenBrightnessTint = 0.7,
		GoldenBrightnessOffset = 0.0,
        GoldenSaturationMult = 0.1,
        MuzzleColor = mod:ColorHSV(0.4, 0.0, 1.0, 1, 0.5, 1.0, 0.9),
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.MagnumShoot, VolMin=0.5, VolMax=0.7, PitchMin=0.95, PitchMax=1.05}
            },
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=1.1, PitchMax=1.2},
            }
        }
    },
    [CollectibleType.COLLECTIBLE_EPIPHORA] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "bigbanditrifle.png",
        SpriteType = "Shoot",
        Priority = 100,
        Ejection = true,
        SpriteOffset = Vector(-8, -3),
        MuzzleOffset = Vector(44, -22),
        BayonetteOffset = Vector(4, 2),
        GoldenValueThreshold = -2.5,
        GoldenBrightnessTint = 1.0,
		GoldenBrightnessOffset = 0.1,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.MagnumShoot, VolMin=0.5, VolMax=0.7, PitchMin=0.75, PitchMax=0.95}
            },
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=1.1, PitchMax=1.2},
            }
        }
    },
    [CollectibleType.COLLECTIBLE_SMALL_ROCK] = {
        ReplaceSprite = gun .. "bulldogrevolver.png",
        BulletSprite = bullet .. "bullet_armorpiercing.png",
        BayonetteOffset = Vector(4, 2),
        SpriteOffset = Vector(-4, 0),
        MuzzleOffset = Vector(44, -18),
        MuzzleScale = 1.2,
        CasingScale = 1.3,
        Priority = 100,
        GoldenValueThreshold = -2.5,
        GoldenBrightnessTint = 1.0,
		GoldenBrightnessOffset = 0.1,
        Sounds = {
             Bullet = {
                {Id=mod.Sounds.MagnumShoot, VolMin=0.6, VolMax=0.65, PitchMin=0.95, PitchMax=1.05}
            },
            ReloadStart = {
                {Id=mod.Sounds.FlareReloadFinish, VolMin=0.5, VolMax=0.5, PitchMin=1.3, PitchMax=1.4},
            },
            ReloadFinish = {
                {Id=mod.Sounds.FlareReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=0.9, PitchMax=1.1},
            }
        }
    },
    [FiendFolio.ITEM.COLLECTIBLE.BIG_ROCK] = {
        ReplaceSprite = gun .. "bulldogrevolver.png",
        BulletSprite = bullet .. "bullet_armorpiercing.png",
        BayonetteOffset = Vector(4, 2),
        SpriteOffset = Vector(-4, 0),
        MuzzleOffset = Vector(44, -18),
        MuzzleScale = 1.2,
        CasingScale = 1.3,
        Priority = 100,
        GoldenValueThreshold = -2.5,
        GoldenBrightnessTint = 3.0,
        GoldenBrightnessTint = 1.0,
		GoldenBrightnessOffset = 0.1,
        Sounds = {
             Bullet = {
                {Id=mod.Sounds.MagnumShoot, VolMin=0.6, VolMax=0.65, PitchMin=0.95, PitchMax=1.05}
            },
            ReloadStart = {
                {Id=mod.Sounds.FlareReloadFinish, VolMin=0.5, VolMax=0.5, PitchMin=1.3, PitchMax=1.4},
            },
            ReloadFinish = {
                {Id=mod.Sounds.FlareReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=0.9, PitchMax=1.1},
            }
        }
    },
    [CollectibleType.COLLECTIBLE_MOMS_EYESHADOW] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "cupidsbowandarrow_v2.png",
        BulletSprite = bullet .. "bullet_cupidarrow_v2.png",
        BayonetteOffset = Vector(0, 3),
        Casing = "None",
        SpriteOffset = Vector(-18, -6),
        NoMuzzle = true,
        SpriteType = "Shoot",
        Priority = 100,
        GoldenValueThreshold = .2,
        GoldenBrightnessTint = 1.2,
		GoldenBrightnessOffset = -0.15,
        GoldenSaturationMult = 0.1,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.SplattershotJrFire, VolMin=1.0, VolMax=1.0, PitchMin=1.0, PitchMax=1.35}
            },
            ReloadClick = {
                {Id=mod.Sounds.RevolverShoot, VolMin=0.3, VolMax=0.4, PitchMin=2.0, PitchMax=2.55},
            },
            ReloadFinish = {
                {Id=mod.Sounds.LauncherReload, VolMin=1.0, VolMax=1.0, PitchMin=1.9, PitchMax=3.0},
            },
        }
    },
    [CollectibleType.COLLECTIBLE_DARK_MATTER] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "calaber.png",
        BayonetteOffset = Vector(6, 2),
        SpriteOffset = Vector(-16, 0),
        Ejection = true,
        Priority = 100,
        MuzzleScale = 0.8,
		GoldenValueThreshold = 0.11,
		GoldenBrightnessTint = 1.3549,
		GoldenBrightnessOffset = 0.1263,
        Sounds = {
            ReloadStart = {
                {Id=mod.Sounds.GarandPing, VolMin=0.05, VolMax=0.5, PitchMin=0.90, PitchMax=1.05},
            },
            ReloadFinish = {
                {Id=mod.Sounds.ShotgunReloadFinish, VolMin=0.85, VolMax=0.90, PitchMin=1.90, PitchMax=2.05},
            },
        }
    },
    [CollectibleType.COLLECTIBLE_GROWTH_HORMONES] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "fivehundredmagnum.png",
        BulletSprite = bullet .. "bullet_armorpiercing.png",
        BayonetteOffset = Vector(4, 2),
        SpriteOffset = Vector(-4, 0),
        MuzzleOffset = Vector(48, -18),
        MuzzleColor = mod:ColorHSV(0.0, 0.3, 1.0, 1, 0.05, 0.95, 0.9),
        MuzzleScale = 1.2,
        CasingScale = 1.3,
        Priority = 100,
		GoldenValueThreshold = 0.04,
		GoldenBrightnessTint = 1.2657,
		GoldenBrightnessOffset = -0.0373,
        Sounds = {
             Bullet = {
                {Id=mod.Sounds.MagnumShoot, VolMin=0.6, VolMax=0.65, PitchMin=0.95, PitchMax=1.05}
            },
        }
    },
    [CollectibleType.COLLECTIBLE_IRON_BAR] = {
        WeaponType = WeaponType.WEAPON_MONSTROS_LUNGS,
        ReplaceSprite = gun .. "fnhtacticalpoliceshotgun.png",
        BulletSprite = bullet .. "bullet_slugrubber.png",
        Priority = 200,
        SpriteOffset = Vector(-8,0),
        MuzzleOffset = Vector(48, -18),
        BayonetteOffset = Vector(4, 2),
        Ejection = true,
        Casing = "ShellBlue",
		GoldenValueThreshold = 0.01,
		GoldenBrightnessTint = 1.8,
		GoldenBrightnessOffset = 0.2,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.ShotgunShoot, VolMin=0.75, VolMax=0.75, PitchMin=0.9, PitchMax=0.95}
            },
            ReloadClick = {
                {Id=mod.Sounds.ShotgunReload, VolMin=0.65, VolMax=0.7, PitchMin=1.2, PitchMax=1.2}
            },
            ReloadFinish = {
                {Id=mod.Sounds.ShotgunReloadFinish, VolMin=1.0, VolMax=1.0, PitchMin=1.3, PitchMax=1.3}
            },
        }
    },
    [CollectibleType.COLLECTIBLE_MINI_MUSH] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "kolibri.png",
        BayonetteOffset = Vector(-4, 2),
        SpriteOffset = Vector(-4,2),
        SpriteType = "Shoot",
        Ejection = true,
        Priority = 100,
        MuzzleOffset = Vector(36, -15),
        MuzzleScale = 0.7,
		GoldenValueThreshold = 0.05,
		GoldenBrightnessTint = 2.2,
		GoldenBrightnessOffset = 0.0891,
        Sounds = {
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=1.1, PitchMax=1.2},
            }
        }
    },
    [CollectibleType.COLLECTIBLE_ABADDON] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "skullcrusher.png",
        BulletSprite = bullet .. "bullet_skullfragment.png",
        Priority = 100,
        Ejection = true,
        SpriteType = "Shoot",
        SpriteOffset = Vector(-5, 3),
        BayonetteOffset = Vector(0, 3),
		GoldenValueThreshold = 0.01,
		GoldenBrightnessTint = 1.23,
		GoldenBrightnessOffset = 0.15,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.MagnumShoot, VolMin=0.5, VolMax=0.7, PitchMin=0.95, PitchMax=1.05}
            },
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=1.1, PitchMax=1.2},
            }
        }
    },
    --[[
    [CollectibleType.COLLECTIBLE_SPEAR_OF_DESTINY] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "lancerriflemk2.png",
        Priority = 100,
        Ejection = true,
        SpriteOffset = Vector(-5, 3),
        GoldenValueThreshold = -2.5,
        GoldenBrightnessTint = 3.0,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.MagnumShoot, VolMin=0.5, VolMax=0.7, PitchMin=0.95, PitchMax=1.05}
            },
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=1.1, PitchMax=1.2},
            }
        }
    },
    ]]
    [CollectibleType.COLLECTIBLE_FRUIT_CAKE] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "moesfivegun.png",
        Priority = 100,
        Ejection = true,
        SpriteOffset = Vector(-5, 3),
        GoldenBrightnessOffset = 0.05,
        GoldenBrightnessTint = 1.1,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.MagnumShoot, VolMin=1.0, VolMax=1.0, PitchMin=0.5, PitchMax=2.05}
            },
            ReloadClick = {
                {Id=mod.Sounds.LauncherReload, VolMin=0.6, VolMax=1.7, PitchMin=0.5, PitchMax=2.15},
            },
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=0.5, PitchMax=2.2},
            }
        }
    },
    [CollectibleType.COLLECTIBLE_LODESTONE] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "ultrakillnailgun.png",
        BulletSprite = bullet .. "bullet_flechette.png",
        Casing = "None",
        Priority = 100,
        SpriteOffset = Vector(-8, 0),
        BayonetteOffset = Vector(3, 5),
		GoldenValueThreshold = 0.01,
		GoldenBrightnessTint = 1.53,
		GoldenBrightnessOffset = 0.25,
        MuzzleColor = mod:ColorHSV(0.0, 0.3, 1.0, 1, 0.05, 0.95, 0.9),
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.SilencedPistolFire, VolMin=0.45, VolMax=0.55, PitchMin=0.8, PitchMax=0.9}
            },
            ReloadClick = {
                {Id=mod.Sounds.GrenadeLauncherReload, VolMin=0.8, VolMax=0.8, PitchMin=0.95, PitchMax=1.05},
            },
            ReloadStart = {
                {Id=mod.Sounds.LauncherReloadStart, VolMin=0.8, VolMax=0.8, PitchMin=0.95, PitchMax=1.15},
            },
        }

    },
    [CollectibleType.COLLECTIBLE_MUCORMYCOSIS] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "videodromegun.png",
        GoldenSprite = gun .. "videodromegun_golden.png",
        SpriteType = "Shoot",
        Ejection = true,
        Priority = 100,
        BayonetteOffset = Vector(-4,1),
        Sounds = {
            ReloadClick = {
                {Id=mod.Sounds.WatergunReload, VolMin=0.55, VolMax=0.6, PitchMin=0.6, PitchMax=1.0}
            },
            ReloadFinish = {
                {Id=mod.Sounds.FlareReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=0.9, PitchMax=1.1},
            },
        }
    },
    [CollectibleType.COLLECTIBLE_CRICKETS_BODY] = {
        ReplaceSprite = gun .. "flakcannon.png",
        BulletSprite = bullet .. "bullet_pellet.png",
        Priority = 200,
        SpriteOffset = Vector(-8,3),
        BayonetteOffset = Vector(4, 3),
        Casing = "Shell",
        CasingScale = 1.5,
		GoldenValueThreshold = 0.11,
		GoldenBrightnessTint = 1.3,
		GoldenBrightnessOffset = 0.2,
        MuzzleOffset = Vector(48, -20),
        MuzzleScale = 1.2,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.ShotgunShoot, VolMin=0.75, VolMax=0.85, PitchMin=0.8, PitchMax=0.85}
            },
            ReloadClick = {
                {Id=mod.Sounds.ShotgunReload, VolMin=0.65, VolMax=0.7, PitchMin=1.2, PitchMax=1.2}
            },
            ReloadFinish = {
                --{Id=mod.Sounds.ShotgunReloadFinish, VolMin=1.0, VolMax=1.0, PitchMin=1.0, PitchMax=1.3}
                {Id=mod.Sounds.NTPistolSwap, VolMin=0.45, VolMax=0.45, PitchMin=1.2, PitchMax=1.2}
            },
        }
    },
    --FF Items
    [FiendFolio.ITEM.COLLECTIBLE.STRANGE_RED_OBJECT] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "strange_red_revolver.png",
        BulletSprite = bullet .. "bullet_strange_and_red.png",
        BulletSpriteGold = bullet .. "bullet_default_gold.png",
        Priority = 100,
        MuzzleColor = Color(170/255, 49/255, 26/255, 1, 0, 0, 0),
        Casing = "None",
		GoldenBrightnessTint = 0.6984,
		GoldenSaturationMult = 0.07,
        BulletSubType = mod.FriendBulletSubTypes.STAY_VERTICALLY_UPRIGHT,
    },
    [FiendFolio.ITEM.COLLECTIBLE.HOW_TO_ROLL] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "revolver_nuclearthrone.png",
        BulletSprite = bullet .. "bullet_pellet.png",
        BayonetteOffset = Vector(-4, 2),
        SpriteType = "Nothing",
        Priority = 100,
        SpriteOffset = Vector(-4, 0),
        MuzzleOffset = Vector(28, -18),
		GoldenBrightnessTint = 1.7632,
		GoldenBrightnessOffset = -0.3732,
        Sounds = {
            Equip = {
                {Id=mod.Sounds.NTPistolSwap, VolMin=0.75, VolMax=0.75, PitchMin=1.0, PitchMax=1.0}
            },
            Bullet = {
                {Id=mod.Sounds.NTPistolShoot, VolMin=0.35, VolMax=0.45, PitchMin = 0.95, PitchMax = 1.05}
            },
            ReloadFinish = {
                {Id=mod.Sounds.NTPistolSwap, VolMin=0.7, VolMax=0.7, PitchMin=1.2, PitchMax=1.2}
            },
        }
    },
    [FiendFolio.ITEM.COLLECTIBLE.IMP_SODA] = {
        NoFriendSoul = true,
        ReplaceAnim = gun .. "guns_sodapopper.anm2",
		GoldenSprite = gun .. "sodapopper_golden.png",
        BayonetteOffset = Vector(-20, -14),
        MuzzleColor = mod:ColorHSV(0.0, 0.0, 1.0, 1, 0.95, 1.0, 0.9),
        Priority = 100,
		GoldenValueThreshold = 0.14,
    },
    [FiendFolio.ITEM.COLLECTIBLE.IMP_SODA_TRICKY_CHERRY] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "trickycherry.png",
        MuzzleColor = mod:ColorHSV(0.0, 0.0, 1.0, 1, 0.0, 1.0, 0.9),
        Priority = 100,
		GoldenValueThreshold = 0.14,
        GoldenBrightnessTint = 0.8,
        GoldenBrightnessOffset = 0.35,
        BayonetteOffset = Vector(0, 0),
    },
    [FiendFolio.ITEM.COLLECTIBLE.RUBBER_BULLETS] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "rubberbullets_gun.png",
        BulletSprite = bullet .. "bullet_slugrubber.png",
        MuzzleOffset = Vector(42, -21),
        Priority = 100,
		GoldenValueThreshold = 0.15,
		GoldenBrightnessTint = 1.2790,
		GoldenBrightnessOffset = 0.2680,
    },
    [FiendFolio.ITEM.COLLECTIBLE.THE_DELUXE] = {
        ReplaceSprite = gun .. "dinner_gun.png",
        BulletSprite = bullet .. "bullet_burger.png",
        BulletSpriteGold = bullet .. "bullet_burger_gold.png",
        TearHeight = -20,
        SpriteType = "Nothing",
        Priority = 100,
        Casing = "None",
        BayonetteOffset = Vector(3, 2),
        MuzzleOffset = Vector(48,-23),
        BulletSubType = mod.FriendBulletSubTypes.STAY_VERTICALLY_UPRIGHT,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.LauncherShoot, VolMin=0.6, VolMax=0.65, PitchMin=2.95, PitchMax=2.6}
            },
            ReloadClick = {
                {Id=mod.Sounds.LauncherReloadFinish, VolMin=0.8, VolMax=0.8, PitchMin=3.95, PitchMax=3.05},
            },
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=1.0, PitchMax=1.1},
            }
        },
    },
    [FiendFolio.ITEM.COLLECTIBLE.BRICK_FIGURE] = {
        NoFriendSoul = true,
        ReplaceAnim = gun .. "guns_lego.anm2",
        BulletSprite = bullet .. "bullet_blaster.png",
        BayonetteOffset = Vector(-16, -4),
        Priority = 100,
        Casing = "None",
        SpriteType = "Large",
        NoMuzzle = true,
		GoldenValueThreshold = -0.17,
		GoldenBrightnessTint = 3.2333,
		GoldenBrightnessOffset = 0.1827,
		GoldenSaturationMult = 0.33,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.SplattershotJrFire, VolMin=1.0, VolMax=1.0, PitchMin=1.15, PitchMax=1.35}
            },
            ReloadClick = {
                {Id=mod.Sounds.BeggarbazookaReload, VolMin=0.25, VolMax=0.35, PitchMin=1.4, PitchMax=1.6}
            },
            ReloadFinish = {
                {Id=mod.Sounds.BeggarbazookaReload, VolMin=0.75, VolMax=0.75, PitchMin=1.0, PitchMax=1.0}
            }
        }
    },
    [FiendFolio.ITEM.COLLECTIBLE.COMMUNITY_ACHIEVEMENT] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "mariasmashtrophy_gun.png",
        SpriteType = "Nothing",
        Casing = "None",
        MuzzleScale = 0.8,
        MuzzleOffset = Vector(44, -15),
        Priority = 100,
        Sounds = {
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.8, VolMax=0.8, PitchMin=1.0, PitchMax=1.1}
            },
        }
    },
    [FiendFolio.ITEM.COLLECTIBLE.SMASH_TROPHY] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "smashraygun.png",
        BulletSprite = bullet .. "bullet_blaster_green.png",
        BulletSpriteGold = bullet .. "bullet_blaster_gold.png",
        MuzzleColor = mod:ColorHSV(0.4, 0.2, 0.95, 1, 0.4, 0.8, 0.8),
        SpriteType = "Nothing",
        Casing = "Battery",
        MuzzleScale = 0.65,
        Priority = 100,
		GoldenValueThreshold = 0.31,
		GoldenBrightnessTint = 0.6167,
		GoldenBrightnessOffset = 0.2680,
		GoldenSaturationMult = 0.6,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.SMGShoot, VolMin=1.0, VolMax=1.0, PitchMin=0.85, PitchMax=1.15}
            },
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.8, VolMax=0.8, PitchMin=1.0, PitchMax=1.1}
            },
        }
    },
    [FiendFolio.ITEM.COLLECTIBLE.MARIAS_IPAD] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "maria_gun.png",
        SpriteType = "Nothing",
        Priority = 100,
    },
    [FiendFolio.ITEM.COLLECTIBLE.CHEMICAL_COOKIE] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "maria_gun.png",
        SpriteType = "Nothing",
        Priority = 100,
    },
    [FiendFolio.ITEM.COLLECTIBLE.HORSE_PASTE] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "glooga_dualie.png",
		GoldenSprite = gun .. "glooga_dualie_deco.png",
        BulletSprite = bullet .. "bullet_pellet.png",
        SpriteType = "Nothing",
        SpriteOffset = Vector(-3, 0),
        MuzzleOffset = Vector(33, -20),
        Casing = "None",
        MuzzleColor = mod:ColorHSV(0.3, 0.2, 1.0, 1, 0.4, 0.6, 0.6),
        Priority = 100,
        Sounds = {
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=1.3, PitchMax=1.4},
            }
        }
    },
    [FiendFolio.ITEM.COLLECTIBLE.YAAI] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "duedly_firearm.png",
        SpriteType = "Nothing",
        Priority = 100,
    },
    [FiendFolio.ITEM.COLLECTIBLE.TIME_ITSELF] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "revolver_goner.png",
        Priority = 100,
    },
    [FiendFolio.ITEM.COLLECTIBLE.STEVEN_SANDWICH] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "steven_revolver.png",
        Priority = 100,
    },
    [FiendFolio.ITEM.COLLECTIBLE.EMOJI_GLASSES] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "emoji_gun.png",
        BayonetteOffset = Vector(0, 3),
        Priority = 100,
		GoldenBrightnessTint = 1.1523,
		GoldenBrightnessOffset = -0.3709
    },
    [mod.ITEM.COLLECTIBLE.EMPTY_GAZE] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "glock.png",
        BayonetteOffset = Vector(-2, 3),
        SpriteOffset = Vector(-4,-4),
        SpriteType = "Shoot",
        Ejection = true,
        Priority = 100,
        MuzzleOffset = Vector(36, -20),
        MuzzleScale = 0.8,
		GoldenValueThreshold = 0.05,
		GoldenBrightnessTint = 2.5177,
		GoldenBrightnessOffset = 0.0891,
        Sounds = {
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=1.1, PitchMax=1.2},
            }
        }
    },
    [mod.ITEM.COLLECTIBLE.MODEL_ROCKET] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "bolter.png",
        BulletAnim = bullet .. "bullet_gyrojet.anm2",
        SpriteType = "Bolt",
        SpriteOffset = Vector(-12, 0),
        Ejection = true,
        Priority = 100,
        MuzzleScale = 1.1,
        MuzzleColor = mod:ColorHSV(0.0, 0.0, 1.0, 1, 0.7, 0.8, 0.9),
        --MuzzleColor = mod:ColorHSV(0.0, 0.0, 1.0, 1, 0.7, 0.8, 0.9),
        --MuzzleOffset = Vector(45, -18),
		GoldenValueThreshold = 0.09,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.MagnumShoot, VolMin=0.45, VolMax=0.5, PitchMin=0.85, PitchMax=0.95}
            },
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=1.0, PitchMax=1.1},
            }
        }
    },
    [FiendFolio.ITEM.COLLECTIBLE.PINHEAD] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "needler.png",
        GoldenSprite = gun .. "needler_golden.png",
        BulletSprite = bullet .. "bullet_needler.png",
        BulletSpriteGold = bullet .. "bullet_needler_gold.png",
        Priority = 100,
        TearHeight = -7,
        SpriteOffset = Vector(-8, 0),
        MuzzleColor = mod:ColorHSV(0.9, 0.5, 1.0, 1, 0.8, 0.8, 0.9),
        MuzzleOffset = Vector(36, -15),
        Casing = "None",
		--GoldenValueThreshold = 0.09,
		--GoldenSaturationMult = 0.75,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.LauncherShoot, VolMin=0.6, VolMax=0.65, PitchMin=2.95, PitchMax=2.6}
            },
            ReloadClick = {
                {Id=mod.Sounds.LauncherReloadFinish, VolMin=0.4, VolMax=0.5, PitchMin=3.95, PitchMax=3.05},
            },
            ReloadFinish = {
                {Id=mod.Sounds.LauncherReload, VolMin=0.9, VolMax=0.9, PitchMin=1.0, PitchMax=1.0},
            }
        }
    },
    [FiendFolio.ITEM.COLLECTIBLE.CLUTCHS_CURSE] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "chips.png",
        GoldenSprite = gun .. "chips_golden.png",
        BulletSprite = bullet .. "bullet_pringles.png",
        BulletSpriteGold = bullet .. "bullet_pringles_gold.png",
        BayonetteOffset = Vector(0, 2),
        Priority = 100,
        SpriteOffset = Vector(-8, 0),
        MuzzleColor = mod:ColorHSV(0.1, 0.8, 1.0, 1, 0.1, 0.8, 0.9),
        MuzzleOffset = Vector(36, -20),
        MuzzleScale = 0.6,
        Casing = "None",
        SpriteType = "Shoot",
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.LauncherShoot, VolMin=0.6, VolMax=0.65, PitchMin=2.95, PitchMax=2.6}
            },
            ReloadClick = {
                {Id=mod.Sounds.LauncherReloadFinish, VolMin=0.4, VolMax=0.5, PitchMin=3.95, PitchMax=3.05},
            },
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=1.0, PitchMax=1.1},
            }
        }
    },
    [FiendFolio.ITEM.COLLECTIBLE.PRANK_COOKIE] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "finger.png",
        GoldenSprite = gun .. "finger_golden.png",
        SpriteType = "Shoot",
        Priority = 100,
        SpriteOffset = Vector(-8.5, 0),
        NoMuzzle = true,
        Casing = "None",
    },
    [FiendFolio.ITEM.COLLECTIBLE.ZERO_POINT_REACTOR] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "vector.png",
        BulletSprite = bullet .. "bullet_blaster.png",
        BayonetteOffset = Vector(0, 4),
        Priority = 100,
        SpriteOffset = Vector(-8,-3),
        MuzzleOffset = Vector(44, -17),
        TearHeight = -7,
        MuzzleScale = 0.75,
        Ejection = true,
		GoldenValueThreshold = 0.06,
		GoldenBrightnessTint = 1.2,
		GoldenBrightnessOffset = 0.272,
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.SMGShoot, VolMin=1.0, VolMax=1.0, PitchMin=0.85, PitchMax=1.15}
            },
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.7, VolMax=0.7, PitchMin=1.0, PitchMax=1.1}
            },
        }
    },
    [FiendFolio.ITEM.COLLECTIBLE.GRANDPAS_WHISKEY] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "revolver_ancient.png",
        Priority = 100,
		GoldenValueThreshold = 0.24,
		GoldenSaturationMult = 0.25,
        Sounds = {
            ReloadStart = {
                {Id=mod.Sounds.FlareReloadFinish, VolMin=0.5, VolMax=0.5, PitchMin=1.3, PitchMax=1.4},
            },
            ReloadFinish = {
                {Id=mod.Sounds.FlareReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=0.9, PitchMax=1.1},
            }
        }
    },
    [FiendFolio.ITEM.COLLECTIBLE.CAN_OF_BEANS] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "fartgun.png",
        SpriteType = "Shoot",
        SpriteOffset = Vector(-7, 0),
        Ejection = true,
        Priority = 100,
		GoldenValueThreshold = -0.5,
		GoldenBrightnessTint = 1.3,
		GoldenBrightnessOffset = 0.3,
		GoldenSaturationMult = 0.4,
        MuzzleColor = mod:ColorHSV(0.05, 0.3, 1.0, 1, 0.05, 0.4, 0.75),
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.BeggarbazookaReload, VolMin=3.5, VolMax=3.5, PitchMin=1.4, PitchMax=1.6}
            },
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=1.1, PitchMax=1.2},
            },
        }
    },
    [FiendFolio.ITEM.COLLECTIBLE.BLACK_MOON] = {
        NoFriendSoul = true,
        ReplaceAnim = gun .. "gun_blackmoon.anm2",
        Casing = "None",
        Priority = 100,
		GoldenValueThreshold = 0.24,
		GoldenSaturationMult = 0.25,
        GoldenBrightnessTint = 0.9,
		GoldenBrightnessOffset = -0.4,
        MuzzleColor = mod:ColorHSV(0.0, 0.8, 1.0, 1, 0.0, 1.0, 0.75),
        MuzzleScale = 1.5,
        MuzzleOffset = Vector(44, -22),
        Sounds = {
            Bullet = {
                {Id=mod.Sounds.SMGShoot, VolMin=1.0, VolMax=1.0, PitchMin=0.85, PitchMax=1.15}
            },
            ReloadFinish = {
                {Id=mod.Sounds.SMGReloadFinish, VolMin=0.7, VolMax=0.7, PitchMin=1.0, PitchMax=1.1}
            },
        }
    },
    [FiendFolio.ITEM.COLLECTIBLE.SMALL_WOOD] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "gunshapedstick.png",
        Casing = "None",
        Priority = 100,
        NoMuzzle = true,
        GoldenValueThreshold = -1.5,
        GoldenSaturationMult = 0.2,
        GoldenBrightnessTint = 2.0,
		GoldenBrightnessOffset = -0.15,
        Sounds = {
            ReloadFinish = {
                {Id=mod.Sounds.FlareReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=0.9, PitchMax=1.1},
            }
        }
    },
    [FiendFolio.ITEM.COLLECTIBLE.BIG_WOOD] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "gunshapedstick.png",
        Casing = "None",
        Priority = 100,
        NoMuzzle = true,
        GoldenValueThreshold = -1.5,
        GoldenSaturationMult = 0.2,
        GoldenBrightnessTint = 2.0,
		GoldenBrightnessOffset = -0.15,
        Sounds = {
            ReloadFinish = {
                {Id=mod.Sounds.FlareReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=0.9, PitchMax=1.1},
            }
        }
    },
    [FiendFolio.ITEM.COLLECTIBLE.ICE_IX] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "cryocannon.png",
        --BulletSprite = bullet .. "bullet_blaster_green.png",
        --BulletSpriteGold = bullet .. "bullet_blaster_gold.png",
        Priority = 100,
        SpriteOffset = Vector(-8,0),
        Casing = "Battery",
        NoMuzzle = true,
        BayonetteOffset = Vector(0,8),
        GoldenValueThreshold = -1.5,
        GoldenSaturationMult = 0.2,
        GoldenBrightnessTint = 1.0,
		GoldenBrightnessOffset = -0.1,
        Sounds = {
            ReloadStart = {
                {Id=mod.Sounds.LauncherReloadStart, VolMin=0.8, VolMax=0.8, PitchMin=0.95, PitchMax=1.15},
            },
            ReloadClick = {
                {Id=mod.Sounds.LauncherReload, VolMin=0.6, VolMax=0.7, PitchMin=0.95, PitchMax=1.15},
            },
            ReloadFinish = {
                {Id=mod.Sounds.LauncherReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=1.0, PitchMax=1.1},
            }
        }
    },
    [FiendFolio.ITEM.COLLECTIBLE.LEFTOVER_TAKEOUT] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "fortunecookiegun.png",
        Casing = "None",
        Priority = 100,
        NoMuzzle = true,
        GoldenValueThreshold = -1.5,
        GoldenSaturationMult = 0.01,
        GoldenBrightnessTint = 1.1,
		GoldenBrightnessOffset = -0.4,
        BayonetteOffset = Vector(-4,1),
        Sounds = {
            ReloadFinish = {
                {Id=mod.Sounds.FlareReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=0.9, PitchMax=1.1},
            }
        }
    },
    [FiendFolio.ITEM.COLLECTIBLE.HYPNO_RING] = {
        NoFriendSoul = true,
        ReplaceSprite = gun .. "videodromegun.png",
        GoldenSprite = gun .. "videodromegun_golden.png",
        SpriteType = "Shoot",
        Ejection = true,
        Priority = 100,
        BayonetteOffset = Vector(-4,1),
        Sounds = {
            ReloadClick = {
                {Id=mod.Sounds.WatergunReload, VolMin=0.55, VolMax=0.6, PitchMin=0.6, PitchMax=1.0}
            },
            ReloadFinish = {
                {Id=mod.Sounds.FlareReloadFinish, VolMin=0.9, VolMax=0.9, PitchMin=0.9, PitchMax=1.1},
            },
        }
    },
}


for subt, gunInfo in pairs(mod.FriendGunInfo) do
	if Isaac.GetItemConfig():GetCollectible(subt) then
		gunInfo.IsCollectible = true
	end
end

--Does nothing at the moment, will check if the player has these guns to override current gun with later on.
--In case the gun needs the animation/etc other stuff to be used.
mod.FriendGunsHighPriority = {

}

-- If Friend obtains these WeaponTypes, they are removed on CacheFlag.CACHE_WEAPON evaluation.
-- This is primarily to cancel out the fire rate penalties of these weapon types, but also helps with custom interactions like C-Section/Ludo.
-- You can check if Friend currently WOULD have had the weapon type by checking this data table:
-- local friendHadMonstrosLungs = mod:GetEntityData(player).FriendBlockedWeaponTypes[WeaponType.WEAPON_MONSTROS_LUNGS]
-- Though in general, if you want to check Friends current "Weapon Type", check this instead:
-- `mod:GetFriendWeaponType(player) == WeaponType.WEAPON_BRIMSTONE`
mod.FriendWeaponTypeBlacklist = {
	WeaponType.WEAPON_BRIMSTONE,
	WeaponType.WEAPON_LASER,
	WeaponType.WEAPON_KNIFE,
	WeaponType.WEAPON_BOMBS,
	WeaponType.WEAPON_ROCKETS,
	WeaponType.WEAPON_MONSTROS_LUNGS,
	WeaponType.WEAPON_TECH_X,
	WeaponType.WEAPON_SPIRIT_SWORD,
}

mod.FriendBlockedCollectibles = {
	CollectibleType.COLLECTIBLE_SPEAR_OF_DESTINY,
}

mod.FriendCallbacks = {
    "POST_GUN_INIT", --Called once when the gun first spawns.
        --(gun, player)
    "PRE_GUN_REPLACE", --Called before the gun is replaced. Return true to stop it from replacing
        --(gun, player)
    "POST_GUN_REPLACE", --Called after the gun is replaced
        --(gun, player)
    "PRE_GUN_UPDATE", --Called every time the gun updates, before the baked in code.
        --(gun, player)
    "POST_GUN_UPDATE", --Same as above, but after.
        --(gun, player)
    "PRE_GUN_FIRE", --Called before any of the fire functions are done. Return true to cancel the standard firing.
        --(gun, player, aim, is the gun being held down or tapped)
    "PRE_GUN_FIRE_SOUND", --Return true to stop the default fire sound.
        --(gun, player, is the gun being held down or tapped)
    "POST_GUN_FIRE", -- Called ONCE after the gun is fired, even if multiple projectiles were shot.
        --(gun, player, aim, table of ammo used (usually just one), is the gun being held down or tapped, entities fired)
    "POST_GUN_FIRE_TEAR", --Called for each tear fired by guns.
        --(gun, player, tear, is the gun being held down or tapped)
    "POST_GUN_FIRE_LASER", --I hate you lasers.
         --(gun, player, laser, is the gun being held down or tapped)
    "POST_GUN_FIRE_BOMB",
         --(gun, player, bomb, is the gun being held down or tapped)
    "GUN_HOLD_RELEASE", --Called after a fire direction is released.
        --(gun, player)
    "PRE_GUN_START_RELOAD", --Called once when the gun starts the reloading process.
        --(gun, player)
    "GUN_PRE_RELOAD_SHOT", --Called every frame before the gun reloads. Only runs when the gun is below max ammo. Return true to override reloading.
        --(gun, player)
    "GUN_RELOAD_SHOT", --Called right before a single ammo is reloaded. Return true to prevent the ammo from being reloaded.
        --(gun, player)
    "POST_GUN_RELOAD", --Called as soon as the gun reloads to full, not after the reload animation.
        --(gun, player, was the full clip reloaded)
    "POST_GUN_FINISHED_RELOAD", --Called when the reloading process/animation finishes completely uninterrupted.
        --(gun, player)
    "POST_GUN_NEW_ROOM", --Called when the gun enters a new room.
        --(gun, player)
    "MUZZLE_FLASH", --Called when the muzzle flash fires, return true to
        --(gun, player)
    "PRE_GUN_FIRE_LATE", --Called after PRE_GUN_FIRE if it isn't cancelled, and only if the player is actually going to shoot. Return a Vector for a new aim direction
        --(gun, player, aim)
    "PRE_GUN_FIRE_CONSUME_AMMO", --Called before the shoot function is about to use ammo. Return true to cancel ammo consumption.

    "PRE_GUN_APPLY_SHOT_EFFECT", -- Called right before special heart effects are applied to a laser/bomb/tear, return true to cancel application (used by Chocolate Milk)
        --(laser or bomb or tear, player, shot, isCrit)

    "GUN_START_DISAPPEARING", -- Called when the gun enters its Disappearing state
}