if Encyclopedia then
	-- Character
	Encyclopedia.AddCharacter({
		ModName = "Fiend Folio",
		Name = "Fiend",
		ID = FiendFolio.PLAYER.FIEND,
		Sprite = Encyclopedia.RegisterSprite(FiendFolio.path .. "content-repentogon/gfx/characterportraits.anm2", "Fiend", 0),
		WikiDesc = {
			{ -- Start Data
				{str = "Start Data", fsize = 2, clr = 3, halign = 0},
				{str = "Items:"},
				{str = "- XVII - The Stars"},
				{str = "HP: 2 Black Hearts, 1 Immoral Heart."},
				{str = "Speed: 1.20."},
				{str = "Tears: 2.14."},
				{str = "- x1.3 Max Fire Delay Multiplier."},
				{str = "Damage: 4.20."},
				{str = "- x1.2 Damage Multiplier."},
				{str = "Range: 6.50."},
				{str = "Shotspeed: 1.25."},
				{str = "Luck: -1."},
			},
			{ -- Traits
				{str = "Traits", fsize = 2, clr = 3, halign = 0},
				{str = "Fiend can only use Black Hearts and Immoral Hearts."},
				{str = "- Most heart pickups are converted into immoral heart pickups."},
				{str = "- Red heart containers are converted into immoral hearts when obtained."},
				{str = "- Soul hearts are converted into black hearts when obtained."},
				{str = "- Bone Hearts are converted into bone orbitals when obtained."},
				{str = "When taking damage in an uncleared room, all hearts of the same type adjacent to the damaged heart turn into minions."},
				{str = "- Minions chase after enemies, dealing damage with a chance to crit."},
				{str = "- Minions turn back into hearts upon room clear."},
				{str = "- Black heart minions deal more damage and have a higher chance to crit, but half black heart minions disappear on room clear."},
				{str = "Orbital fireballs spawn around Isaac after dealing enough damage to enemies, up to three at a time."},
				{str = "- Double-tap the shoot button to shoot out a fireball, leaving a trail of flames and exploding on contact."},
				{str = "- Enemies killed by fireballs drop half immoral hearts that quickly disappear if not picked up."},
				{str = "- Fireballs can also spawn when enemies are damaged by minions."},
				{str = "Fiend has a higher chance for cursed pennies to spawn."},
			},
			{ -- Birthright
				{str = "Birthright", fsize = 2, clr = 3, halign = 0},
				{str = "Gives Fiend's fireballs increased homing and a chance to spawn immoral heart minions that disappear on room clear, in addition to their usual effects."},
			},
		},
	})

	Encyclopedia.AddCharacterTainted({
		ModName = "Fiend Folio",
		Name = "Fiend",
		Description = "The Bastard",
		ID = FiendFolio.PLAYER.BIEND,
		Sprite = Encyclopedia.RegisterSprite(FiendFolio.path .. "content-repentogon/gfx/CharacterPortraitsAlt.anm2", "Fiend", 0),
		WikiDesc = {
			{ -- Start Data
				{str = "Start Data", fsize = 2, clr = 3, halign = 0},
				{str = "Items:"},
				{str = "- Malice"},
				{str = "HP: 2 Black Hearts."},
				{str = "Speed: 1.00."},
				{str = "Tears: 3.05."},
				{str = "Damage: 2.80."},
				{str = "- x0.8 Damage Multiplier."},
				{str = "Range: 5.85."},
				{str = "- x0.9 Range Multiplier."},
				{str = "Shotspeed: 1.00."},
				{str = "Luck: 0."},
			},
			{ -- Traits
				{str = "Traits", fsize = 2, clr = 3, halign = 0},
				{str = "Tainted Fiend can only use Black Hearts, and can only have a maximum of 6 hearts at a time."},
				{str = "- Most heart pickups are converted into black heart pickups."},
				{str = "- Most types of health are converted into black hearts when obtained."},
				{str = "Upon using Malice, Tainted Fiend charges forward as a ball of tar in the direction they are firing (or moving) in."},
				{str = "- Tainted Fiend cannot fire tears, use actives or use pocket items while charging."},
				{str = "- Tainted Fiend cannot take damage while charging."},
				{str = "- Tainted Fiend deals contact damage to enemies while charging, and enemies killed by the charge have a chance to drop a half black heart."},
				{str = "Upon colliding with a grid while charging, Tainted Fiend will split apart into several minions."},
				{str = "- The number of minions split into depends on the number of hearts Tainted Fiend has (at least 2 minions)."},
				{str = "- Tainted Fiend controls all minions simultaneously as if they were regular players, with the minions moving together as a unit."},
				{str = "- Tainted Fiend's damage is split amongst his minions, with the sum of all their damage having a multiplier higher than that of their base form."},
				{str = "-- The damage multiplier increases based on the number of minions Tainted Fiend initially split into."},
				{str = "- Each minion dies in a single hit, and all damage taken is reflected onto the base form."},
				{str = "- Tainted Fiend automatically dies if all their minions are killed."},
				{str = "- Bombs used while split will be split into several smaller bombs."},
				{str = "- All passive effects are transferred from the base form onto the minions."},
				{str = "- Only one minion uses active items / pocket items at a time."},
				{str = "Using Malice whilst split reforms all of Tainted Fiend's minions back into the original form."},
				{str = "- Tainted Fiend cannot fire tears, use actives or use pocket items while reforming."},
				{str = "- Tainted Fiend cannot take damage while reforming."},
			},
			{ -- Birthright
				{str = "Birthright", fsize = 2, clr = 3, halign = 0},
				{str = "Increases the chance of enemies dropping half black hearts when killed by the Malice charge attack."},
				{str = "Fiend's minions are randomly assigned hats upon spawning, each granting its wearer a differing amount of damage, tears, luck and tear size."},
			},
		},
	})

	Encyclopedia.AddCharacter({
		ModName = "Fiend Folio",
		Name = "Golem",
		ID = Isaac.GetPlayerTypeByName("Golem"),
		Sprite = Encyclopedia.RegisterSprite(FiendFolio.path .. "content-repentogon/gfx/characterportraits.anm2", "Golem", 0),
		WikiDesc = {
			{ -- Start Data
				{str = "Start Data", fsize = 2, clr = 3, halign = 0},
				{str = "Items:"},
				{str = "- Dirt Clump"},
				{str = "- Rolling Rock"},
				{str = "HP: 1 Heart, 1 Soul Heart."},
				{str = "Speed: 0.85."},
				{str = "Tears: 2.73."},
				{str = "Damage: 3.50."},
				{str = "Range: 6.00."},
				{str = "Shotspeed: 1.0."},
				{str = "Luck: -1."},
			},
			{ -- Traits
				{str = "Traits", fsize = 2, clr = 3, halign = 0},
				{str = "Golem can naturally hold two trinkets at a time."},
				{str = "Golem has a unique pool of rock-themed trinkets he can obtain."},
				{str = "- Rock trinkets can be found naturally, in Secret Rooms, or by beating bosses."},
				{str = "- Rock trinkets cannot normally spawn for other players."},
				{str = "- Smelted rock trinkets have reduced effects."},
				{str = "- Non-rock trinkets can no longer appear for Golem."},
				{str = "Golem has access to a special Subway room via a unique trapdoor, allowing fast travel between various rooms once they have been explored, including:"},
				{str = "- Starting rooms"},
				{str = "- Treasure rooms"},
				{str = "- Secret rooms"},
				{str = "- Shops"},
				{str = "- Boss rooms"},
				{str = "Subways contain machines unique to Golem:"},
				{str = "- Bismuth Beggar: Crushes rock trinkets in exchange for soul hearts."},
				{str = "- Mining Machine: Exchanges a rock trinket for another at the cost of three coins."},
				{str = "- Unfinished Golem: Drops a random rock trinket when bombed. Only appears on the first floor of a chapter."},
				{str = "- Sourpuss: Smelts a rock trinket at the cost of one-and-a-half soul hearts. Only appears on the second floor of a chapter."},
				{str = "- Geode Golem: Splits the first rock trinket given into two random rock trinkets at no cost. Duplicates geode rock trinkets instead. Only appears on the second floor of a chapter."},
				{str = "Special Types of Rock Trinkets:"},
				{str = "- Geodes: Have boosted/unique effects when holding another geode rock trinket."},
				{str = "- Fossils: Have unique effects when crushed."},
			},
			{ -- Birthright
				{str = "Birthright", fsize = 2, clr = 3, halign = 0},
				{str = "+2 luck up."},
				{str = "Tinted rocks now drop rock trinkets instead of soul hearts."},
			},
		},
	})

	Encyclopedia.AddCharacterTainted({
		ModName = "Fiend Folio",
		Name = "Golem",
		Description = "The Artisan",
		ID = Isaac.GetPlayerTypeByName("Golem", true),
		Sprite = Encyclopedia.RegisterSprite(FiendFolio.path .. "content-repentogon/gfx/CharacterPortraitsAlt.anm2", "Golem", 0),
		Hide = true
	})

	Encyclopedia.AddCharacter({
		ModName = "Fiend Folio",
		Name = "Friend",
		ID = FiendFolio.PLAYER.FRIEND,
		Sprite = Encyclopedia.RegisterSprite(FiendFolio.path .. "content-repentogon/gfx/characterportraits.anm2", "Friend", 0),
		Hide = true
	})
	Encyclopedia.AddCharacterTainted({
		ModName = "Fiend Folio",
		Name = "Friend",
		Description = "The Wanted",
		ID = FiendFolio.PLAYER.BRIEND,
		Sprite = Encyclopedia.RegisterSprite(FiendFolio.path .. "content-repentogon/gfx/CharacterPortraitsAlt.anm2", "Friend", 0),
		Hide = true
	})


	Encyclopedia.AddCharacter({
		ModName = "Fiend Folio",
		Name = "Slippy",
		ID = FiendFolio.PLAYER.SLIPPY,
		Sprite = Encyclopedia.RegisterSprite(FiendFolio.path .. "content-repentogon/gfx/characterportraits.anm2", "Slippy", 0),
		WikiDesc = {
			{ -- Start Data
				{str = "Start Data", fsize = 2, clr = 3, halign = 0},
				{str = "Items:"},
				{str = "- Golden Frog Head"},
				{str = "HP: 3 Hearts."},
				{str = "Speed: 1.00."},
				{str = "Tears: 1.88."},
				{str = "- x1.5 Max Fire Delay Multiplier."},
				{str = "Damage: 3.50."},
				{str = "Range: 6.50."},
				{str = "Shotspeed: 1.0."},
				{str = "Luck: 0."},
			},
			{ -- Traits
				{str = "Traits", fsize = 2, clr = 3, halign = 0},
				{str = "All tears Slippy fires are split into three."},
				{str = "Slippy moves automatically without player input."},
				{str = "- Slippy is normally incapable of standing still."},
				{str = "Upon using Golden Frog Head, Slippy stands in place for as long as the button is held."},
				{str = "- While held, Slippy will charge up a fart attack, capable of knocking back enemies and projectiles."},
				{str = "- The radius and damage of the fart attack increases with charge, with higher levels of charge also being capable of damaging and poisoning enemies."},
			},
			{ -- Birthright
				{str = "Birthright", fsize = 2, clr = 3, halign = 0},
				{str = "Slippy now spawns lingering poison gas clouds when using the Golden Frog Head fart attack, in addition to the usual effects."},
			},
		},
	})

	Encyclopedia.AddCharacter({
		ModName = "Fiend Folio",
		Name = "China",
		ID = FiendFolio.PLAYER.CHINA,
		Sprite = Encyclopedia.RegisterSprite(FiendFolio.path .. "content-repentogon/gfx/characterportraits.anm2", "China", 0),
		WikiDesc = {
			{ -- Start Data
				{str = "Start Data", fsize = 2, clr = 3, halign = 0},
				{str = "HP: None."},
				{str = "Speed: 1.00."},
				{str = "Tears: 3.53."},
				{str = "- x0.75 Max Fire Delay Multiplier."},
				{str = "Damage: 3.50."},
				{str = "Range: 6.50."},
				{str = "Shotspeed: 1.0."},
				{str = "Luck: 0."},
			},
			{ -- Traits
				{str = "Traits", fsize = 2, clr = 3, halign = 0},
				{str = "China passively has a x0.8 hitbox size multiplier."},
				{str = "China starts with no regular health, and is incapable of obtaining any."},
				{str = "- China instead gains a broken heart whenever she would normally take damage."},
				{str = "- China automatically dies upon obtaining 12 broken hearts."},
				{str = "- China can take devil deals for free. All other devil deals in the room disappear upon taking any."},
				{str = "China takes damage upon colliding with grids and walls."},
				{str = "- China also falls into pits upon touch, taking damage and reappearing in a different place in the room."},
				{str = "China has a chance to find Horse Push-Pops upon clearing rooms."},
				{str = "- On use, Horse Push-Pops heal one broken heart."},
			},
			{ -- Birthright
				{str = "Birthright", fsize = 2, clr = 3, halign = 0},
				{str = "Grants China the Horse Paste item."},
				{str = "- On use, Horse Paste heals one broken heart."},
			},
		},
	})

	Encyclopedia.AddCharacter({
		ModName = "Fiend Folio",
		Name = "Fient",
		Description = "",
		ID = Isaac.GetPlayerTypeByName("Fient"),
		Sprite = Encyclopedia.RegisterSprite(FiendFolio.path .. "content-repentogon/gfx/characterportraits.anm2", "Fient", 0),
		Hide = true
	})

	Encyclopedia.AddCharacter({
		ModName = "Fiend Folio",
		Name = "Fend",
		Description = "",
		ID = Isaac.GetPlayerTypeByName("Fend"),
		Sprite = Encyclopedia.RegisterSprite(FiendFolio.path .. "content-repentogon/gfx/characterportraits.anm2", "Fend", 0),
		Hide = true
	})

	Encyclopedia.AddCharacter({
		ModName = "Fiend Folio",
		Name = "Peat",
		Description = "",
		ID = Isaac.GetPlayerTypeByName("Peat"),
		Sprite = Encyclopedia.RegisterSprite(FiendFolio.path .. "content-repentogon/gfx/characterportraits.anm2", "Peat", 0),
		Hide = true
	})
end