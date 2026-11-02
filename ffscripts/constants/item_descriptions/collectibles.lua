local mod = FiendFolio

--The item description mines are intense

FiendFolio.ExternalDescriptions.Collectibles = {
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PYROMANCY,
		Description = {
			Description = {
				"Orbital fireballs frequently spawn around Isaac, up to three",
				"Double-tap the shoot button to shoot out a fireball, leaving a trail of flames and exploding on contact"
			},
			Abyss = {
				"Inflicts Burn"
			}
		},
		EncyclopediaPools = Encyclopedia and {
			Encyclopedia.ItemPools.POOL_DEVIL,
			Encyclopedia.ItemPools.POOL_GREED_DEVIL
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.FIEND_FOLIO,
		Description = {
			Description = {
				"Summons a Fiend Folio helper to assist you in the room",
			},
			Virtues = {
				"Spawns rare " .. mod.DescriptionIconsCards.GrottoBeast .. "Grotto Beast charmed monster when destroyed"
			},
			CarBattery = {
				PartialReplace = {
					[" a "] = " 2 ",
					["Fiend Folio helper"] = "{{CR}}Fiend Folio helpers",
				},
			},
			Abyss = {
				"No effect"
			}
		},
		Encyclopedia = Encyclopedia and {
			Encyclopedia.ItemPools.POOL_TREASURE,
			Encyclopedia.ItemPools.POOL_GREED_TREASURE,
			Encyclopedia.ItemPools.POOL_LIBRARY
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.D2,
		Description = {
			Description = {
				"Throws a spinning purple coin on the floor temporarily",
				"Any pickups, enemies and tears that touch it will be rerolled"
			},
			CarBattery = {
				PartialReplace = {
					[" a "] = " 2 ",
					["spinning purple coin"] = "{{CR}}spinning purple coins",
				},
			},
			Abyss = {
				"20% chance to devolve enemies"
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_SHOP,
				Encyclopedia.ItemPools.POOL_CRANE_GAME
			}
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.STORE_WHISTLE,
		Description = {
			Description = {
				"Spawns a Shop Chest",
				"Shop Chests need a key to open, and when opened, turn into a portable shop",
			},
			CarBattery = {
				PartialReplace = {
					[" a "] = " 2 ",
					["Shop Chest"] = "{{CR}}Shop Chests",
				},
			},
			Abyss = {
				"10% chance to drop a penny on kill"
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_SHOP,
				Encyclopedia.ItemPools.POOL_BEGGAR,
				Encyclopedia.ItemPools.POOL_CRANE_GAME
			}
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DICE_BAG,
		Description = {
			Description = {
				"Spawn 1 Glass Die every 8 rooms#Glass Dice mimic a die and break after use",
			},
			BFFs = {
				TargetNumbers = {
					{ 8, 4 }
				},
			},
			Abyss = {
				"20% chance to devolve enemies"
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_SECRET,
				Encyclopedia.ItemPools.POOL_GREED_SECRET,
				Encyclopedia.ItemPools.POOL_CRANE_GAME,
				Encyclopedia.ItemPools.POOL_ULTRA_SECRET
			}
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.LIL_FIEND,
		Description = {
			Description = {
				"Flies diagonally across the room#Has a chance to drop a Fiend Minion when colliding with an enemy or tear",
				"Minions attack enemies and will disappear on room clear",
			},
			BFFs = {
				Description = {
					"Increases the hitbox and chance of dropping a minion",
				},
			},
			Abyss = {
				"No effect"
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_DEVIL,
				Encyclopedia.ItemPools.POOL_GREED_DEVIL,
				Encyclopedia.ItemPools.POOL_DEMON_BEGGAR,
				Encyclopedia.ItemPools.POOL_BABY_SHOP
			}
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BABY_CRATER,
		Description = {
			Description = {
				"{{Chargeable}} While shooting, Baby Crater creates a circle of tears",
				"Tears are released when Isaac stops firing",
				"3.5 damage per tear",
			},
			BFFs = {
				TargetNumbers = {
					{ 3.5, 7 }
				},
			},
			Abyss = {
				"No effect"
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_BABY_SHOP
			}
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.MAMA_SPOOTER,
		Description = {
			Description = {
				"Blue tinted Spooter that pursues enemies",
				"Periodically fires tears at targets",
				"3.5 damage per tear",
			},
			BFFs = {
				TargetNumbers = {
					{3.5, 7},
				},
			},
			Abyss = {
				"No effect",
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_BABY_SHOP
			}
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.RANDY_THE_SNAIL,
		Description = {
			Description = {
				"Snail familiar that retracts into its shell when hit by a projectile",
				"Randy can be bounced around the room through repeated projectile collisions",
			},
			BFFs = {
				Description = {
					"Contact damage doubled"
				}
			},
			Abyss = {
				"No effect",
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_BABY_SHOP
			}
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.CORN_KERNEL,
		Description = {
			Description = {
				"Lv1: Wavy orbital",
				"Lv2: Orbital that shoots weak explosions",
				"Lv3: Familiar that teleports and chases enemies",
				"Lv4: Familiar that teleports and shoots explosive corn"
			},
			BFFs = {
				"Damage doubled"
			},
			Abyss = {
				"Blocks enemy shots",
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_BOSS,
				Encyclopedia.ItemPools.POOL_GREED_SHOP
			}
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GMO_CORN,
		Description = {
			Description = {
				"{{Warning}} Isaac is immobilized and forced to consume 7 random pills",
				"{{Heart}} +1 Health",
				"↑ +1 Damage"
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_BOSS,
				Encyclopedia.ItemPools.POOL_GREED_BOSS,
				Encyclopedia.ItemPools.POOL_GREED_SHOP,
				Encyclopedia.ItemPools.POOL_BEGGAR
			}
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.COOL_SUNGLASSES,
		Description = {
			Description = {
				"{{Coin}} +6 Coins",
				"{{Speed}} Walking near coins grants a Speed up",
				"Collecting coins damages all enemies in the room",
				"{{Warning}} Upon entering an occupied room, 3 cents are taken from you and strewn across the room"
			},
			Abyss = {
				"10% chance to drop a penny on kill"
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_SHOP,
				Encyclopedia.ItemPools.POOL_GREED_SHOP,
				Encyclopedia.ItemPools.POOL_CRANE_GAME
			}
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.FIENDS_HORN,
		Description = {
			Description = {
				"Enemies have a 5% chance to drop a Fiend Minion on death",
				"{{Luck}} 20% chance at 14 luck",
				"Minions attack enemies and disappear on room clear",
				"{{ffImmoralHeart}} A bonus chance is applied for any Immoral Hearts you have"
			},
			Abyss = {
				"No effect"
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_DEVIL,
				Encyclopedia.ItemPools.POOL_GREED_DEVIL,
				Encyclopedia.ItemPools.POOL_DEMON_BEGGAR
			}
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.RISKS_REWARD,
		Description = {
			Description = {
				"Can be used to reroll an item in a {{TreasureRoom}} Treasure Room into one of a higher quality",
				"This is achieved by traversing a unique Psionic Zone and fighting Hermit, a mini boss",
				"{{Warning}} Can only be used in {{TreasureRoom}} Treasure Rooms",
			},
			Belial = {
				"Rerolls {{TreasureRoom}} Treasure Room items into {{DevilRoom}} Devil Room items"
			},
			Virtues = {
				"High HP, high damage wisp"
			},
			CarBattery = false
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_DEVIL,
				Encyclopedia.ItemPools.POOL_CURSE
			}
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SPARE_RIBS,
		Description = {
			Description = {
				"{{EmptyBoneHeart}} +1 Bone Heart",
				"Taking damage has a chance to fire out rib projectiles in a circle around you",
				"Rib projectiles return to their sender and are destroyed only on contact with what fired them",
				"Rib projectiles can destroy enemy projectiles"
			},
			Abyss = {
				"When the locust hits an enemy, rib projectiles fire in a circle"
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_DEVIL,
				Encyclopedia.ItemPools.POOL_GREED_DEVIL
			}
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BACON_GREASE,
		Description = {
			Description = {
				"{{EmptyHeart}} +1 Empty heart container",
				"↑ +0.15 Shot speed",
				"!!! Removes a Red Heart from your health, but will not kill you"
			},
			AbyssSpecial = {
				"1 big slightly faster locust (0.5x Isaac's damage)"
			},
			Conditional = function (descObj)
				if REPENTANCE_PLUS then
					local split = mod:SplitString(descObj.Description, "#")
					local lastValidLine = #split
					for i, line in ipairs(split) do
						for _, blacklistedPrefix in ipairs(mod.EIDBlacklistedPrefix) do
							if line:sub(1, blacklistedPrefix:len()) == blacklistedPrefix then
								lastValidLine = i
								break
							end
						end
					end

					table.insert(split, lastValidLine, "#{{Trinket122}} Drops Butter")

					descObj.Description = table.concat(split, "#")
				end
			end
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_BOSS,
					Encyclopedia.ItemPools.POOL_GREED_BOSS,
					Encyclopedia.ItemPools.POOL_GREED_SHOP,
					Encyclopedia.ItemPools.POOL_GOLDEN_CHEST,
					Encyclopedia.ItemPools.POOL_BEGGAR
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DEVILS_UMBRELLA,
		Description = {
			Description = {
				"{{HalfSoulHeart}} +1 Half Soul Heart",
				"20% chance to fire a flurry of weak tears that spawn yellow creep"
			},
			Abyss = {
				"Creates a small trail of yellow creep that does 10% of Isaac's damage"
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.NUGGET_BOMBS,
		Description = {
			Description = {
				"{{Bomb}} +5 Bombs",
				"Bombs spawn a Pooter familiar when they explode"
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_SHOP,
					Encyclopedia.ItemPools.POOL_BOMB_BUM
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BEE_SKIN,
		Description = {
			Description = {
				"Every tear fired triggers 3 weaker tears spread evenly around Isaac",
				"These tears do 30% of your damage",
				"Each time this effect triggers, the angle of all tears is incremented clockwise",
				"{{Warning}} Does not give you flight"
			},
			Abyss = {
				"Fires tears while charging that deal 10% Isaac's damage"
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.ALPHA_COIN,
		Description = {
			Description = {
				"{{Coin}} 25% chance to spawn a coin",
				"{{Card}} {{Pill}}25% to spawn a card/pill",
				"A variety of effects based on the current room and exploration"
			},
			CarBattery = {
				Description = {
					"Activates the item twice"
				},
			},
			Abyss = {
				"A variety of effects based on the current room and exploration"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PLANET_BADGE,
		Description = {
			Description = {
				"↑ +0.1 Damage",
				"{{Warning}} Collect all 6 for a surprise!"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.MARIAS_IPAD,
		Description = {
			Description = {
				"Moves all entities to the bottom of the room"
			},
			Virtues = {
				"Can only shoot tears downwards"
			},
			Abyss = {
				"Can only shoot downwards"
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.HAUNTED_BADGE,
		Description = {
			Description = {
				"↑ +0.1 Damage",
				"{{Warning}} Collect all 6 for a surprise!"
			},
			AbyssSpecial = {
				"1 locust (0.2x Isaac's damage)"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BABY_BADGE,
		Description = {
			Description = {
				"↑ +0.1 Damage",
				"{{Warning}} Collect all 6 for a surprise!"
			},
			AbyssSpecial = {
				"1 locust (0.2x Isaac's damage)"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.COMMISSIONED_BADGE,
		Description = {
			Description = {
				"↑ +0.1 Damage",
				"{{Warning}} Collect all 6 for a surprise!"
			},
			AbyssSpecial = {
				"1 locust (0.2x Isaac's damage)"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DRIPPING_BADGE,
		Description = {
			Description = {
				"↑ +0.1 Damage",
				"{{Warning}} Collect all 6 for a surprise!"
			},
			AbyssSpecial = {
				"1 locust (0.2x Isaac's damage)"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.MYSTERY_BADGE,
		Description = {
			Description = {
				"↑ +0.1 Damage",
				"{{Warning}} Collect all 6 for a surprise!"
			},
			AbyssSpecial = {
				"1 locust (0.2x Isaac's damage)"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SPATULA_BADGE,
		Description = {
			Description = {
				"↑ +0.1 Damage",
				"{{Warning}} Collect all 6 for a surprise!"
			},
			AbyssSpecial = {
				"1 locust (0.2x Isaac's damage)"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.YOUR_ETERNAL_REWARD,
		Description = {
			Description = {
				"↑ +0.1 Damage"
			},
			AbyssSpecial = {
				"1 locust (0.2x Isaac's damage)"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GOLEMS_ROCK,
		Description = {
			Description = {
				"Spawns a Golem trinket on pickup",
				"{{Trinket}} On use, grinds your current trinket into a rock trinket",
				"{{Trinket}} Can reroll rock trinkets when used whilst carrying one"
			},
			Virtues = {
				"Rock wisp with tears that destroys obstacles"
			},
			CarBattery = false,
			AbyssSpecial = {
				"Bigger slower locust (1.5x Isaac's damage)"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PINHEAD,
		Description = {
			Description = {
				"Grants sewing needle tears that pierce and inflict enemies with {{ffSew}} Sewn"
			},
			AbyssSpecial = {
				"2 locusts (0.75x Isaac's damage)"
			},
			Abyss = {
				"20% chance to inflict enemies with Sewn",
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.SEW }
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.LIL_LAMB,
		Description = {
			Description = {
				"{{Chargeable}} Familiar that charges to shoot explosive shots",
				"When Isaac is damaged, has a chance to drop on the floor and target enemies automatically",
				"{{Warning}} Ipecac shots can do damage to Isaac"
			},
			BFFs = {
				Description = {
					"Damage doubled",
				}
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL,
					Encyclopedia.ItemPools.POOL_CURSE,
					Encyclopedia.ItemPools.POOL_GREED_CURSE,
					Encyclopedia.ItemPools.POOL_BABY_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GRAPPLING_HOOK,
		Description = {
			Description = {
				"Throwable hook that can be used to quickly travel",
				"Can be used to climb onto rocks",
				"{{Warning}} Isaac can take damage by falling into pits"
			},
			CarBattery = false,
			Abyss = {
				"No effect"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP,
					Encyclopedia.ItemPools.POOL_CRANE_GAME
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GRABBER,
		Description = {
			Description = {
				"Familiar based on Grabber from hit video game Grabber",
				"Mirrors your movements and grabs things in front of him",
				"Deals 5 damage a second"
			},
			BFFs = {
				TargetNumbers = {
					{ 5, 10 }
				},
			},
			Abyss = {
				"No effect",
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_BABY_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.IMP_SODA,
		Description = {
			Description = {
				"4% chance to shoot purple critical tears that deal x5 damage",
				"{{Luck}} 33% chance at 11 luck"
			},
			Abyss = {
				"4% chance to deal x5 damage"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL,
					Encyclopedia.ItemPools.POOL_DEMON_BEGGAR
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DADS_WALLET,
		Description = {
			Description = {
				"{{Coin}} Items and pickups for sale can be purchased even if unaffordable",
				"↓ If Isaac buys an item that he cannot afford, he gets a temporary multiplicative damage down",
				"Damage returns to normal when Isaac pays back his debt",
			},
			Conditional = function (descObj)
				local data = Isaac.GetPersistentGameData()
				if data:Unlocked(Achievement.CREDIT_CARD) then
					local split = mod:SplitString(descObj.Description, "#")
					local lastValidLine = #split
					for i, line in ipairs(split) do
						for _, blacklistedPrefix in ipairs(mod.EIDBlacklistedPrefix) do
							if line:sub(1, blacklistedPrefix:len()) == blacklistedPrefix then
								lastValidLine = i
								break
							end
						end
					end

					table.insert(split, lastValidLine, "#{{Card43}} Drops a credit card on pickup")

					descObj.Description = table.concat(split, "#")
				end
			end,
			Abyss = {
				"No effect"
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_OLD_CHEST
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BEGINNERS_LUCK,
		Description = {
			Description = {
				"↑ +5 Luck up",
				"↓ -0.5 Luck based on how many floors Isaac has progressed down to, to a minimum of 0.5 Luck"
			},
			Abyss = {
				"No effect"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DICHROMATIC_BUTTERFLY,
		Description = {
			Description = {
				"{{ffHitbox}} Hitbox size is reduced and indicated by a marker",
				"{{Damage}} Grants +0.2 Damage for the current room for narrowly avoiding a projectile, capping at +3 Damage",
				"17% chance to fire a homing tear that deals x1.25 your damage",
				"{{Luck}} 64% chance at 7 luck"
			},
			Abyss = {
				"Homing"
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_ANGEL,
					Encyclopedia.ItemPools.POOL_GREED_ANGEL,
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET,
					Encyclopedia.ItemPools.POOL_ULTRA_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SLIPPYS_GUTS,
		Description = {
			Description = {
				"{{Poison}} Enemies have a chance to spawn a lingering poison cloud on death",
				"{{Luck}} Chance scales with Luck, and is proportionate to enemy's Max HP",
				"{{Bomb}} Bombs spawn a lingering poison cloud on explosion"
			},
			Abyss = {
				"20% chance to spawn a knockback or poisonous fart when dealing damage"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SLIPPYS_HEART,
		Description = {
			Description = {
				"{{Luck}} Isaac will pulse red and have a Luck based chance to fart while near enemies",
				"20% chance to do a little fart",
				"{{Confusion}} 40% chance to do a normal fart that confuses enemies",
				"{{Poison}} 38% chance to fart a poisonous fart cloud",
				"{{Poison}} 2% chance to fart multiple poisonous farts"
			},
			Abyss = {
				"20% chance to spawn a knockback or poisonous fart when dealing damage"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.COMMUNITY_ACHIEVEMENT,
		Description = {
			Description = {
				"{{Damage}} Damage up scales with the current records in the Fiend Folio Community Discord counting channels"
			},
			AbyssSpecial = {
				"1 locust (4.41x Isaac's damage)"
			},
			Conditional = function (descObj)
				descObj.Description = "↑ " .. string.format("%.2f", FiendFolio:GetCommunityAchievementDamage()) .. " Damage#" .. descObj.Description
			end
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET
				},
			},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.CHIRUMIRU,
		Description = {
			Description = {
				"{{SoulHeart}} +1 Soul Heart",
				"↑ +0.9 Damage",
				"Upon entering a room, all enemies are frozen for 0.9 seconds"
			},
			Abyss = {
				"18% chance to petrify enemies"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_BOSS,
					Encyclopedia.ItemPools.POOL_GREED_BOSS
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GOLEMS_ORB,
		Description = {
			Description = {
				"↑ +0.23 Shot speed",
				"↑ +0.2 Speed",
				"↑ +1 Luck",
				"{{SoulHeart}} +2 Soul Hearts"
			},
			AbyssSpecial = {
				"1 big and fast locust (1.5x Isaac's damage)"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_BOSS,
					Encyclopedia.ItemPools.POOL_GREED_BOSS
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.LEFTOVER_TAKEOUT,
		Description = {
			Description = {
				"↑ +1 Health",
				"{{HealingRed}} Heals 1 heart",
				"↑ +0.3 Speed",
				"↑ x1.5 Damage multiplier",
				"↑ x1.1 Fire rate multiplier",
				"↑ +1.5 Range",
				"↑ +1 Luck",
				"20% chance to fire a fortune worm tear that does x1.05 damage",
				"{{Luck}} 33% chance at 2 luck"
			},
			AbyssSpecial = {
				"1 big locust (2x Isaac's damage)"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_CURSE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.MODERN_OUROBOROS,
		Description = {
			Description = {
				"{{Slow}} Tears leave slowing oil creep upon impact",
				"Walking over oil creep will ignite it",
				"Flames can ignite other oil puddles close by"
			},
			Abyss = {
				"20% chance to leave igniting slowing oil creep"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.FROG_HEAD,
		Description = {
			Description = {
				"Holding down the USE ({{ButtonLT}}) button forces you to stand still",
				"Letting go of the USE ({{ButtonLT}}) button makes Isaac fart, the fart getting more powerful the longer you hold it down"
			},
			CarBattery = {
				Description = {
					"Isaac holds his farts down twice as fast"
				}
			},
			Abyss = {
				"20% chance to spawn a knockback or poisonous fart when dealing damage"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_CRANE_GAME
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SANGUINE_HOOK,
		Description = {
			Description = {
				"Throwable hook that pulls in enemies/pickups",
				"Enemies are bruised while hooked and hemorrhaged upon release"
			},
			StatusEffects = {
				FiendFolio.DescriptionStatuses.BRUISE,
				FiendFolio.DescriptionStatuses.HEMORRHAGE
			},
			Virtues = {
				"4 Temporary wisps whenever an enemy is hooked",
			},
			Belial = {
				"↑ +2 Damage while an enemy is hooked"
			},
			Abyss = {
				"10% chance to inflict enemies with Bruised",
				"10% chance to inflict enemies with Hemorrhage",
			},
			CarBattery = false
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_DEVIL
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PEACH_CREEP,
		Description = {
			Description = {
				"Wall Creep familiar that tries to line up with enemies and shoots bursts of tears",
				"Shoots a barrage of 4 tears that do 2 damage per tear"
			},
			BFFs = {
				TargetNumbers = {
					{ 2, 4 }
				},
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_SHOP,
					Encyclopedia.ItemPools.POOL_BABY_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GORGON,
		Description = {
			Description = {
				"Stationary familiar that spawns in the center of the room",
				"If there are enemies in the room, Gorgoneion will stare at them and petrify them"
			},
			BFFs = false,
			Abyss = {
				"25% chance to petrify enemies"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_CRANE_GAME,
					Encyclopedia.ItemPools.POOL_BABY_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.FIDDLE_CUBE,
		Description = {
			Description = {
				"{{Damage}} Grants an increasing amount of Damage and Tears when used multiple times",
				"{{Tears}} Damage and Tears gradually go away if the item is not being used"
			},
			Virtues = {
				"Gain wisps the more you use Fiddle Cube",
				"Wisps gradually go away if the item is not being used"
			},
			Belial = {
				"↑ Doubles damage boost from Fiddle Cube"
			},
			CarBattery = {
				Description = {
					"Maximum tears and damage gained is given sooner"
				}
			},
			Abyss = {
				"No effect"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP,
					Encyclopedia.ItemPools.POOL_CRANE_GAME
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.AVGM,
		Description = {
			Description = {
				"{{Coin}} Pays out with coins after using an increasing amount of times",
				"After enough uses, you will prestige, causing A.V.G.M to spawn an item pedestal"
			},
			Virtues = {
				"When a coin pays out, you also get a wisp"
			},
			Abyss = {
				"When the locust flies into a wall, it changes color",
				"{{Coin}} When changing color, the locust pays out with coins after enough time",
			},
			Belial = {
				"↑ +2 Damage for the room everytime A.V.G.M pays out"
			},
			CarBattery = {
				Description = {
					"Amount of uses needed for paying out halved"
				}
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GOLDEN_CHEST,
					Encyclopedia.ItemPools.POOL_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.OPHIUCHUS,
		Description = {
			Description = {
				"Wiggly snake familiar that chases after enemies, inflicting poison and dealing damage on contact",
				"{{Poison}} Prioritizes chasing after enemies that are not currently inflicted with poison",
			},
			BFFs = {
				Description = {
					"Poison damage doubled"
				}
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.CETUS,
		Description = {
			Description = {
				"Spews out a large number of tears that leave creep when Isaac takes damage"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DEIMOS,
		Description = {
			Description = {
				"Familiar that hooks in enemies/pickups",
				"Enemies are bruised while hooked and hemorrhaged upon release"
			},
			StatusEffects = {
				FiendFolio.DescriptionStatuses.BRUISE,
				FiendFolio.DescriptionStatuses.HEMORRHAGE
			},
			BFFs = false,
			Abyss = {
				"No effect"
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_PLANETARIUM
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.MALICE,
		Description = {
			Description = {
				"Use to turn into a malicious fireball that charges across the room",
				"{{HalfBlackHeart}} Enemies killed in this state have a 35% chance to drop Half Black Hearts if you are Tainted Fiend"
			},
			CarBattery = false,
			AbyssSpecial = {
				"1 fast locust (1x Isaac's damage)"
			},
			Abyss = {
				"Creates a small trail of slowing black creep"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PET_ROCK,
		Description = {
			Description = {
				"Pet rock familiar that can be pushed around and blocks shots",
				"Fills pits when pushed into them",
			},
			BFFs = {
				Description = {
					"Size and hitbox increased"
				}
			},
			AbyssSpecial = {
				"1 very slow locust (0.5x Isaac's damage)",
			},
			Abyss = {
				"Blocks enemy shots"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_BABY_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BIRTHDAY_GIFT,
		Description = {
			Description = {
				"{{Collectible515}} Replaces all found items with Mystery Gift",
				"Does not affect story mode items, special drops, or items spawned by Mystery Gift"
			},
			Abyss = {
				"No effect"
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_CURSE,
					Encyclopedia.ItemPools.POOL_ULTRA_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.CONTRABAND,
		Description = {
			Description = {
				"Better hold onto this!",
				"{{Warning}} I heard a shady guy next floor is looking for it..."
			},
			Belial = {
				"Permanent ↑ damage up based on the highest number of times the effect has been stacked"
			},
			AbyssSpecial = {
				"1 slow locust (0.5x Isaac's damage)"
			},
			Abyss = {
				"Attacks very fast"
			},
			CarBattery = false
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BLACK_LANTERN,
		Description = {
			Description = {
				"{{BlackHeart}} +1 Black Heart",
				"Guarantees a curse on every floor",
				"{{ffCursesBlackLantern}} Replaces curses with special new kinds of potentially beneficial curses"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_CURSE
				},
				Wiki =
				"\1 +1 black heart#Guarantees a curse on every floor#Replaces curses with special new kinds of potentially beneficial curses#Curse of the Imp: Heart pickups have a chance to be replaced with Fiend's minions#Curse of the Stone: Your speed is increased or lowered depending on how many trinkets and pocket items you are carrying#Curse of the Sun: All stats up. If you get hit, all stats down. After clearing 3 rooms without taking damage, the buff will be restored#Curse of the Swine: Enemies have a chance to drop pennies on death, but all pennies fade away after some time#Curse of the Ghost: Raindrops that hurt both you and enemies fall from the sky. Drops will often spawn close to enemies and home in on them. Rain intensity increases as your health decreases#Curse of the Scythe: Hurting enemies builds rage. Once rage reaches a certain level, you enter rage mode which greatly increases your fire rate but also applies the Bruised status effect, reducing your invincibility frames.#Curse of the Master: Hurting enemies without getting hurt yourself causes your style level to increase. A high style level will make all pickups and items you find more valuable. A low style level will do the opposite"
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.CLEAR_CASE,
		Description = {
			Description = {
				"The next active item you pick up will be assigned to your pocket active slot"
			},
			Abyss = {
				"No effect"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_CURSE,
					Encyclopedia.ItemPools.POOL_GREED_CURSE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.CLEAR_CASE_PASSIVE,
		Description = {
			Description = { "" },
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {},
				Hide = true
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.CRUCIFIX,
		Description = {
			Description = {
				"Enemies killed by tears will turn into Martyrs"
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.MARTYR },
			Abyss = {
				"Turn enemies into Martyrs upon kill"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_ANGEL,
					Encyclopedia.ItemPools.POOL_GREED_ANGEL
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BEDTIME_STORY,
		Description = {
			Description = {
				"Inflicts all enemies with Drowsy for 6 seconds"
			},
			Virtues = {
				"{{ffSleeping}} Drowsy for the whole room when destroyed",
			},
			CarBattery = {
				TargetNumbers = {
					{ 6, 12 }
				},
			},
			Abyss = {
				"20% chance to inflict Drowsy when dealing damage"
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.DROWSY_AND_SLEEP }
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_LIBRARY,
					Encyclopedia.ItemPools.POOL_GOLDEN_CHEST
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PRANK_COOKIE,
		Description = {
			Description = {
				"Grants multi-coloured tears that have different Fiend Folio effects"
			},
			Abyss = {
				"Chance to apply random status effects on enemies"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL,
					Encyclopedia.ItemPools.POOL_DEMON_BEGGAR
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DEVILS_HARVEST,
		Description = {
			Description = {
				"↑ +1 Life ",
				"{{Player" .. FiendFolio.PLAYER.FIEND .. "}} On death, Isaac respawns as Fiend in the previous room"
			},
			Abyss = {
				"No effects"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL,
					Encyclopedia.ItemPools.POOL_CURSE,
					Encyclopedia.ItemPools.POOL_GREED_CURSE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.ETERNAL_D12,
		Description = {
			Description = {
				"Switches between two modes",
				"Has a high chance to reroll grids and a low chance to wipe away grids"
			},
			Virtues = {
				"10% chance for tears to reroll rocks, urns, skulls or mushrooms"
			},
			CarBattery = false,
			Abyss = {
				"20% chance to devolve enemies"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_CRANE_GAME
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.RUBBER_BULLETS,
		Description = {
			Description = {
				"{{ffBruise}} 20% chance to fire bullet tears that inflict enemies with Bruised",
				"{{Luck}} 50% chance at 10 luck"
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.BRUISE
			},
			Abyss = {
				"20% chance to inflict enemies with Bruised"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.THE_DELUXE,
		Description = {
			Description = {
				"{{EmptyBoneHeart}} +1 Bone Heart",
				"{{ffMorbidHeart}} +1 Morbid Heart",
				"{{GoldenHeart}} +1 Golden Heart",
				"{{EternalHeart}} +1 Eternal Heart"
			},
			AbyssSpecial = {
				"1 big and slow locust (1.5x Isaac's damage)"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET,
					Encyclopedia.ItemPools.POOL_ROTTEN_BEGGAR
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.LIL_MINX,
		Description = {
			Description = {
				"Familiar that charges at enemies",
				"{{ffBerserk}} Double-tapping the fire button possesses the nearest enemy and inflicts them with Berserk",
				"Double-tapping again makes the familiar exit the enemy, shooting tears out"
			},
			BFFs = {
				"Damage doubled"
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.BERSERK },
			Abyss = {
				"20% chance to inflict Berserk when dealing damage"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL,
					Encyclopedia.ItemPools.POOL_BABY_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PURPLE_PUTTY,
		Description = {
			Description = {
				"{{ffImmoralHeart}} +1 Immoral Heart"
			},
			Virtues = {
				"Spawns a Fiend Minion when destroyed",
				"4% chance for Critical tears"
			},
			CarBattery = {
				TargetNumbers = {
					{ 1, 2 }
				},
			},
			Abyss = {
				"No effect"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL,
					Encyclopedia.ItemPools.POOL_DEMON_BEGGAR
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.FETAL_FIEND,
		Description = {
			Description = {
				"↑ +1.4 Damage",
				"{{ffImmoralHeart}} Converts all Soul and Black Hearts into Immoral Hearts",
				"{{Heart}} Replaces all Red Hearts with Immoral Hearts"
			},
			Abyss = {
				"No effect"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL,
					Encyclopedia.ItemPools.POOL_DEMON_BEGGAR
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.FIEND_MIX,
		Description = {
			Description = {
				"{{EmptyHeart}} On use, transforms half your health into Fiend Minions"
			},
			Virtues = {
				"Spawns a Fiend Minion when destroyed"
			},
			CarBattery = {
				Description = {
					"Uses the item twice"
				}
			},
			AbyssSpecial = {
				"1 small locust (0.75x Isaac's damage)"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SECRET_STASH,
		Description = {
			Description = {
				"Spawns a random set of pickups",
				"At the start of your next run, spawns the consumable Isaac is holding and 10% of your pickups at the end of this run"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GLIZZY,
		Description = {
			Description = {
				"{{HalfHeart}} +1 Half-filled heart container",
				"↑ +0.1 Speed",
				"↑ +0.1 Tears",
				"↑ +0.1 Damage",
				"↑ +0.1 Range",
				"↑ +0.1 Shot speed",
				"↑ +0.1 Luck",
				"{{Coin}} +0.1 Coins"
			},
			AbyssSpecial = {
				"1 slightly fast locust (1.1x Isaac's damage)"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.FIEND_HEART,
		Description = {
			Description = {
				"{{ffImmoralHeart}} +3 Immoral Hearts"
			},
			Abyss = {
				"No effect"
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_BOSS,
					Encyclopedia.ItemPools.POOL_GREED_BOSS,
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL,
					Encyclopedia.ItemPools.POOL_DEMON_BEGGAR
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DEVILLED_EGG,
		Description = {
			Description = {
				"{{ffImmoralHeart}} +2 Immoral Hearts",
				"↑ +0.3 Tears"
			},
			Abyss = {
				"No effect"
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_BOSS,
					Encyclopedia.ItemPools.POOL_GREED_BOSS,
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL,
					Encyclopedia.ItemPools.POOL_DEMON_BEGGAR
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.TEA,
		Description = {
			Description = {
				"↑ +1 Health",
				"{{HealingRed}} Heals 1 heart"
			},
			Abyss = {
				"No effect"
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_BOSS,
					Encyclopedia.ItemPools.POOL_GREED_BOSS
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.FRAUDULENT_FUNGUS,
		Description = {
			Description = {
				"{{RottenHeart}} +1 Rotten Heart",
				"↑ +0.2 Speed",
				"↑ +0.3 Damage",
				"↑ +2.5 Range"
			},
			Abyss = {
				"5% chance to poison enemies"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_BOSS,
					Encyclopedia.ItemPools.POOL_GREED_BOSS,
					Encyclopedia.ItemPools.POOL_ROTTEN_BEGGAR
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SMALL_PIPE,
		Description = {
			Description = {
				"↑ +0.2 Damage",
				"↑ +0.2 Tears",
				"↑ +0.2 Shot speed",
				"↑ +0.2 Speed"
			},
			AbyssSpecial = {
				"1 slightly faster locust (1x Isaac' damage)"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SMALL_WOOD,
		Description = {
			Description = {
				"↑ +0.7 Tears",
				"↑ +0.2 Damage",
				"↓ -0.2 Shot speed"
			},
			AbyssSpecial = {
				"1 slightly slower locust (1.5x Isaac' damage)"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_WOODEN_CHEST
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.WHITE_PEPPER,
		Description = {
			Description = {
				"On use, shoots 5 flames in a ring around you"
			},
			VirtuesSingleRoom = true,
			CarBattery = {
				TargetNumbers = {
					{ 5, 10 }
				},
			},
			AbyssSpecial = {
				"5 locusts (0.27x Isaac's damage)"
			},
			Abyss = {
				"5% chance to Burn enemies"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PEPPERMINT,
		Description = {
			Description = {
				"{{Freezing}} 8% chance to shoot a freezing fire that blocks enemy shots and deals contact damage",
				"{{Luck}} 50% chance at 10 luck",
				"Fires disappear after blocking 4 shots, dealing damage 4 times or after 10 seconds"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BLACK_MOON,
		Description = {
			Description = {
				"On death, enemies spawn a cross that damages enemies in an area of effect",
				"The aura scales with Isaac's damage and fire rate",
				"Enemies killed by the cross don't spawn another cross"
			},
			Abyss = {
				"Enemies spawn a cross that damages enemies on kill"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL,
					Encyclopedia.ItemPools.POOL_ANGEL,
					Encyclopedia.ItemPools.POOL_GREED_ANGEL,
					Encyclopedia.ItemPools.POOL_ULTRA_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PERFECTLY_GENERIC_OBJECT_1,
		Description = {
			Description = {
				"{{ffObject}} Spawns 1 object on pickup",
				"{{ffObject}} Triggers the effect of the object Isaac holds without using it"
			},
			Virtues = {
				"15% chance for enemies to drop an {{ffObject}} object on kill",
				"Drops an {{ffObject}} object when destroyed"
			},
			CarBattery = {
				Description = {
					"Triggers it twice"
				}
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET
				},
				Hide = true
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PERFECTLY_GENERIC_OBJECT_2,
		Description = {
			Description = {
				"{{ffObject}} Spawns 1 object on pickup",
				"{{ffObject}} Triggers the effect of the object Isaac holds without using it"
			},
			Virtues = {
				"15% chance for enemies to drop an {{ffObject}} object on kill",
				"Drops an {{ffObject}} object when destroyed"
			},
			CarBattery = false
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET
				},
				Hide = true
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PERFECTLY_GENERIC_OBJECT_3,
		Description = {
			Description = {
				"{{ffObject}} Spawns 1 object on pickup",
				"{{ffObject}} Triggers the effect of the object Isaac holds without using it"
			},
			Virtues = {
				"15% chance for enemies to drop an {{ffObject}} object on kill",
				"Drops an {{ffObject}} object when destroyed"
			},
			CarBattery = false
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET
				},
				Hide = true
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PERFECTLY_GENERIC_OBJECT_4,
		Description = {
			Description = {
				"{{ffObject}} Spawns 1 object on pickup",
				"{{ffObject}} Triggers the effect of the object Isaac holds without using it"
			},
			Virtues = {
				"15% chance for enemies to drop an {{ffObject}} object on kill",
				"Drops an {{ffObject}} object when destroyed"
			},
			CarBattery = false
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PERFECTLY_GENERIC_OBJECT_5,
		Description = {
			Description = {
				"{{ffObject}} Spawns 1 object on pickup",
				"{{ffObject}} Triggers the effect of the object Isaac holds without using it"
			},
			Virtues = {
				"15% chance for enemies to drop an {{ffObject}} object on kill",
				"Drops an {{ffObject}} object when destroyed"
			},
			CarBattery = false
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET
				},
				Hide = true
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PERFECTLY_GENERIC_OBJECT_6,
		Description = {
			Description = {
				"{{ffObject}} Spawns 1 object on pickup",
				"{{ffObject}} Triggers the effect of the object Isaac holds without using it"
			},
			Virtues = {
				"15% chance for enemies to drop an {{ffObject}} object on kill",
				"Drops an {{ffObject}} object when destroyed"
			},
			CarBattery = false
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET
				},
				Hide = true
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PERFECTLY_GENERIC_OBJECT_8,
		Description = {
			Description = {
				"{{ffObject}} Spawns 1 object on pickup",
				"{{ffObject}} Triggers the effect of the object Isaac holds without using it"
			},
			Virtues = {
				"15% chance for enemies to drop an {{ffObject}} object on kill",
				"Drops an {{ffObject}} object when destroyed"
			},
			CarBattery = false
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET
				},
				Hide = true
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PERFECTLY_GENERIC_OBJECT_12,
		Description = {
			Description = {
				"{{ffObject}} Spawns 1 object on pickup",
				"{{ffObject}} Triggers the effect of the object Isaac holds without using it"
			},
			Virtues = {
				"15% chance for enemies to drop an {{ffObject}} object on kill",
				"Drops an {{ffObject}} object when destroyed"
			},
			CarBattery = false
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET
				},
				Hide = true
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PAGE_OF_VIRTUES,
		Description = {
			Description = {
				"Gives a random wisp",
				"Whenever one of these wisps is destroyed, grants you a new random wisp"
			},
			AbyssSpecial = {
				"2 locusts (0.5x Isaac's damage)"
			},
			Abyss = {
				"25% chance to Burn enemies"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_ANGEL,
					Encyclopedia.ItemPools.POOL_GREED_ANGEL
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BRIDGE_BOMBS,
		Description = {
			Description = {
				"{{Bomb}} +5 Bombs",
				"Bombs fill pits when they explode"
			},
			Abyss = {
				"20% chance to explode"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_BOMB_BUM
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.LAWN_DARTS,
		Description = {
			Description = {
				"25% chance to fire tears that inflict enemies with Hemorrhage",
				"{{Luck}} 100% chance at 15 luck"
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.HEMORRHAGE
		 	},
			Abyss = {
				"20% chance to inflict enemies with Hemorrhage"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.TOY_PIANO,
		Description = {
			Description = {
				"20% chance to fire tears that inflict enemies with Doom",
				"{{Luck}} 100% chance at 34 luck"
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.DOOM },
			Abyss = {
				"20% chance to inflict enemies Doom"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL,
					Encyclopedia.ItemPools.POOL_CRANE_GAME
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.HYPNO_RING,
		Description = {
			Description = {
				"20% chance to fire tears that inflict enemies with Drowsy",
				"{{Luck}} 33% chance at 10 luck"
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.DROWSY_AND_SLEEP
		 	},
			Abyss = {
				"20% chance to inflict enemies with Drowsy"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_ULTRA_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.MUSCA,
		Description = {
			Description = {
				"{{Bomb}} +3 Bombs",
				"Bombs spawn three random locusts when they explode",
				"Enemies not killed by locusts have a luck-based chance to spawn a random locust on death",
				"{{Luck}} 100% chance at 113 luck"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.MODEL_ROCKET,
		Description = {
			Description = {
				"↑ x2 Shot speed",
				"↑ +1.5 Range",
				"Tears accelerate up from zero movement speed to normal movement speed on firing",
				"{{Damage}} Tears deal bonus damage based on their movement speed upon impact"
			},
			Abyss = {
				"Locust accelerates up from zero movement speed to very fast"
			},
			AbyssSpecial = {
				"1 locust (1.5x Isaac's damage)"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_ULTRA_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SIBLING_SYL,
		Description = {
			Description = {
				"Shoots normal tears",
				"Deals 4.75 damage per tear"
			},
			BFFs = {
				TargetNumbers = {
					{ 4.75, 9.50 }
				},
			},
			Abyss = {
				"No effect"
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_BABY_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.WRONG_WARP,
		Description = {
			Description = {
				"{{Warning}} SINGLE USE {{Warning}}",
				"On use, teleports you to a random floor"
			},
			CarBattery = false,
			AbyssSpecial = {
				"1 erratic moving locust (1.5x Isaac's damage)"
			},
			Virtues = {
				"Wisp that regenerates when extinguished"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET,
					Encyclopedia.ItemPools.POOL_ULTRA_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GREG_THE_EGG,
		Description = {
			Description = {
				"Familiar that has a 35% chance to drop a pickup after clearing a room",
				"After being shot by enough projectiles, Greg has a chance to crack and spawn another familiar",
				"{{Warning}} Greg gets removed from your inventory when cracked"
			},
			BFFs = false,
			AbyssSpecial = {
				"1 slow locust (1x Isaac's damage)"
			},
			Abyss = {
				"Blocks enemy shots"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP,
					Encyclopedia.ItemPools.POOL_CRANE_GAME,
					Encyclopedia.ItemPools.POOL_BABY_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.FAMILIAR_FLY,
		Description = {
			Description = {
				"Orbiting boom fly familiar that does 30 damage a second",
				"Will explode and later respawn when close to enemies for long enough",
				"{{Charm}} Explosion releases 10 charming tears that do 3.5 damage",
				"{{Charm}} Can charm flies",
			},
			BFFs = {
				TargetNumbers = {
					{ 30, 60 },
					{ 3.5, 7 },
				},
			},
			Abyss = {
				"10% chance to charm enemies"
			},
			AbyssSpecial = {
				"1 big locust (1x Isaac's damage)"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_KEY_MASTER,
					Encyclopedia.ItemPools.POOL_BABY_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.MONAS_HIEROGLYPHICA,
		Description = {
			Description = {
				"{{Planetarium}} Gives you a random Planetarium item effect every floor"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_PLANETARIUM
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.CYANIDE_DEADLY_DOSE,
		Description = {
			Description = {
				"Cyanide pills can now frequently spawn alongside pickups",
				"{{Warning}} Cyanide pills give Isaac a big stat boost, but can kill him after 60 seconds",
				"{{Pill}} Spawns a Cyanide pill"
			},
			Abyss = {
				"No effect"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_CURSE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GOLDEN_PLUM_FLUTE,
		Description = {
			Description = {
				"{{Timer}} Summons a friendly Golden Baby Plum in the room for 10 seconds"
			},
			CarBattery = {
				PartialReplace = {
					[" a "] = " 2 ",
					["Plum"] = "{{CR}}Plums"
				},
				TargetNumbers = {
					{ 1, 2 }
				},
			},
			Abyss = {
				"No effect"
			},
			Virtues = {
				"When Golden Baby Plum bounces diagonally, all Golden Plum Flute wisps are invincible and do so as well"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DOGBOARD,
		Description = {
			-- NO DESC
			Description = {
				""
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {},
				Hide = true
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DADS_POSTICHE,
		Description = {
			Description = {
				"{{ffMorbidHeart}} +1 Morbid Heart",
				"5% chance to spawn blue skuzzes when shooting tears",
				"{{Luck}} 100% chance at 10 luck",
				"Blue Skuzzes are friendly creatures that hop towards nearby enemies and do x3 Isaac's damage",
				"{{ffMorbidHeart}} Morbid hearts have a slightly higher chance to appear"
			},
			Abyss = {
				"No effect"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_OLD_CHEST
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.EXCELSIOR,
		Description = {
			Description = {
				"{{Battery}} Active items when used will shoot fireworks, based on the amount of item charge"
			},
			Abyss = {
				"20% chance to explode"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_ANGEL,
					Encyclopedia.ItemPools.POOL_GREED_ANGEL
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GRIDDLED_CORN,
		Description = {
			Description = {
				"↑ +0.3 Damage",
				"{{HalfBlackHeart}} +1 Half Black Heart",
				"{{ffSpicyKey}} Drops a Spicy Key",
				"{{Charm}} Spawns 3 friendly Coal Spiders on pickup"
			},
			Abyss = {
				"25% chance to Burn enemies"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_BOSS,
					Encyclopedia.ItemPools.POOL_GREED_BOSS
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.ETERNAL_D10,
		Description = {
			Description = {
				"Rerolls enemies in the current room",
				"Enemies have a 33% chance to disappear",
			},
			CarBattery = false,
			Abyss = {
				"70% chance to devolve enemies"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_CRANE_GAME
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.TOY_CAMERA,
		Description = {
			Description = {
				"Create a camera flash that destroys projectiles and stuns enemies",
				"{{Tears}} Grants a temporary tears up when you flash yourself",
				"If enough enemies are caught, spawns a Cool Photo",
			},
			Belial = {
				"Enemies caught in the flash take damage equivalent to Judas's damage",
			},
			CarBattery = {
				Description = {
					"Creates two camera flashes next to eachother"
				},
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP,
					Encyclopedia.ItemPools.POOL_CRANE_GAME
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.HAPPYHEAD_AXE,
		Description = {
			Description = {
				"Periodically fires a piercing axe towards the closest enemy",
				"The axe boomerangs back shortly after launch"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_ANGEL,
					Encyclopedia.ItemPools.POOL_GREED_ANGEL,
					Encyclopedia.ItemPools.POOL_CRANE_GAME
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.THE_BROWN_HORN,
		Description = {
			Description = {
				"Causes all enemies to defecate violently, confusing them while pushing them away from Isaac",
				"{{Collectible576}} When used, spawns friendly Dip familiars",
				"Certain enemies have unique interactions when using Brown Horn"
			},
			CarBattery = {
				Description = {
					"Doubles duration of defecation",
					"Enemies spawn 1 more friendly dip",
				},
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PENNY_ROLL,
		Description = {
			Description = {
				"{{Coin}} Spawns a penny trinket, a Golden Penny and 4 random pennies"
			},
			Abyss = {
				"No effect"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_BOSS
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.EVIL_STICKER,
		Description = {
			Description = {
				"Increases the chance for {{ffCursedPenny}} coins, {{ffSpicyKey}} keys, {{ffCopperBomb}} bombs, {{ffImmoralHeart}} hearts, and {{ffCursedBattery}} batteries, and {{ffDireChest}} chests to become their cursed variants",
				"{{ffCursedPenny}} Spawns 6 Cursed Pennies",
			},
			Abyss = {
				"No effect"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_CURSE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.WIMPY_BRO,
		Description = {
			Description = {
				"Slammer familiar that jumps on and crushes enemies",
			},
			BFFs = {
				Description = {
					"Damage doubled"
				}
			},
			Abyss = {
				"No effect"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_BABY_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.ETERNAL_CLICKER,
		Description = {
			Description = {
				"50% chance to change your character to another character",
				"Removes the most recent item collected"
			},
			Virtues = {
				"Spawns a random wisp",
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.ROBOBABY3,
		Description = {
			Description = {
				"Familiar that moves diagonally in the direction you move",
				"Can block projectiles, and fires 8 lasers doing 3.5 damage around itself when colliding with an enemy",
			},
			BFFs = {
				TargetNumbers = {
					{ 3.5, 7 },
				},
			},
			Abyss = {
				"Electricity on hit"
			},
			AbyssSpecial = {
				"1 erratic moving locust (0.5x Isaac's damage)"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_CRANE_GAME,
					Encyclopedia.ItemPools.POOL_BABY_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SNOW_GLOBE,
		Description = {
			Description = {
				"Causes an earthquake that flings most grids and obstacles to a random spot nearby",
			},
			Virtues = {
				"Spawns a stationary wisp whenever a rock is broken",
			},
			Belial = {
				"Gives a fading damage up based on the amount of obstacles moved",
			},
			CarBattery = false,
			Abyss = {
				"No effect"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.NYX,
		Description = {
			Description = {
				"Grants 3 homing gems that can be cast while attacking that sticks to enemies, inflicting damage and bruising"
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.BRUISE },
			AbyssSpecial = {
				"3 large locusts (0.5x Isaac's damage)"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_PLANETARIUM
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.TELEBOMBS,
		Description = {
			Description = {
				"{{Bomb}} +5 Bombs",
				"A target follows behind you at a delay",
				"When placing a bomb, Isaac teleports back to the marker, and the bomb instantly explodes"
			},
			Abyss = {
				"20% chance to explode"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_BOMB_BUM
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DICE_GOBLIN,
		Description = {
			Description = {
				"Spawns 3 random objects on pickup",
				"Spawns 1 object at the start of every floor",
				"{{ffObject}} Objects are consumable pickups that don't fall into the same category as pills, cards, and runes"
			},
			Abyss = {
				"No effect"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_BOSS,
					Encyclopedia.ItemPools.POOL_GREED_BOSS,
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.CHERRY_BOMB,
		Description = {
			Description = {
				"On use, Isaac picks up a cherry bomb that can be thrown to hurt enemies",
				"The bombs can't break rocks or hurt Isaac"
			},
			Virtues = {
				"Wisp blows up when a cherry bomb blows up"
			},
			Belial = {
				"Cherry bombs explode into {{Collectible684}} Hungry Soul explosions"
			},
			CarBattery = {
				Description = {
					"Spawns a cherry bomb ontop of Isaac on use"
				},
			},
			Abyss = {
				"10% chance to explode"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_BOMB_BUM,
					Encyclopedia.ItemPools.POOL_ULTRA_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.ASTROPULVIS,
		Description = {
			Description = {
				"On use, destroys the closest rock and turns it into a large ghost",
				"Using the active again will detonate all large ghosts in the room"
			},
			Virtues = {
				"Only one wisp can be spawned",
				"Wisp detonates when an active item is used to blow up a ghost"
			},
			Belial = {
				"Detonated ghosts create a ring of 3 smaller explosions that scale with Judas's damage"
			},
			CarBattery = false
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL,
					Encyclopedia.ItemPools.POOL_ULTRA_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SPINDLE,
		Description = {
			Description = {
				"{{ffDisc}} Spawns 3 Discs",
				"{{Timer}} Discs grant the effects of a few random passive items for 1 minute",
				"{{BossRoom}} Spawns a Disc when entering a Boss Room"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.AZURITE_SPINDOWN,
		Description = {
			Description = {
				"{{Trinket}} Rerolls all trinkets in the room by decreasing their internal ID number by one"
			},
			CarBattery = {
				PartialReplace = {
					[" one"] = " two"
				},
			},
			Abyss = {
				"20% chance to devolve enemies"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET,
					Encyclopedia.ItemPools.POOL_CRANE_GAME
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.KING_WORM,
		Description = {
			Description = {
				"Grants the effect of 1 random worm trinket for the current room"
			},
			Virtues = {
				"Wisps inherit your worm trinket effect"
			},
			VirtuesSingleRoom = true,
			CarBattery = {
				TargetNumbers = {
					{ 1, 2 }
				},
			},
			Abyss = {
				"Wiggles while charging"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DEVILS_DAGGER,
		Description = {
			Description = {
				"Isaac fires daggers alongside his tears",
				"Enemies drop gems when killed that can power up Isaac's daggers",
				"The power of Isaac's daggers reset when entering a new floor"
			},
			Abyss = {
				"33% chance to Burn enemies"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.STRANGE_RED_OBJECT,
		Description = {
			Description = {
				"↑ +1 Health",
				"↑ +0.3 Damage",
				"↑ +0.05 Speed",
				"↑ +2 Luck"
			},
			AbyssSpecial = {
				"1 slightly faster locust (1x Isaac's damage)"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_ULTRA_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.D3,
		Description = {
			Description = {
				"Orbital familiar that rerolls tears",
				"{{Warning}} Wacky"
			},
			BFFs = false,
			Abyss = {
				"30% chance to devolve enemies"
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET,
					Encyclopedia.ItemPools.POOL_CRANE_GAME
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.EMOJI_GLASSES,
		Description = {
			Description = {
				"Isaac's tears turn into Emojis that each have a unique effect"
			},
			Abyss = {
				"Fires tears while charging that deal 10% Isaac's damage"
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_CRANE_GAME
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SACK_OF_SPICY,
		Description = {
			Description = {
				"{{ffSpicyKey}} Spawns a set of Spicy Keys every 7 rooms"
			},
			BFFs = {
				Description = {
					"Drops a set of Super Spicy Keys instead"
				},
			},
			Abyss = {
				"Inflicts Burns"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_CURSE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.HEART_OF_CHINA,
		Description = {
			Description = {
				"↑ +1 Health",
				"{{Heart}} Overhealing charges a secondary health bar",
				"{{EmptyHeart}} Filling this bar grants an empty heart container",
				"The number of slots in the secondary bar scales with how many heart containers you have",
				"This health bar can be viewed by viewing the map"
			},
			Abyss = {
				"No effect"
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_CURSE,
					Encyclopedia.ItemPools.POOL_GREED_CURSE,
					Encyclopedia.ItemPools.POOL_ULTRA_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DEVILS_ABACUS,
		Description = {
			Description = {
				"{{Damage}} Count with your tears for an increasing damage and tears up for the room",
				"{{Tears}} Counting counts as firing a certain amount of tears and stopping",
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_WOODEN_CHEST
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DAZZLING_SLOT,
		Description = {
			Description = {
				"{{Coin}} Spend 5 coins to turn an enemy into a one use Golden Slot Machine"
			},
			CarBattery = false
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_CRANE_GAME
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.KALUS_HEAD,
		Description = {
			Description = {
				"A dark cone of vision appears when held above Isaac's head",
				"{{Petrify}} Enemies in the cone are petrified and take a minor amount of damage",
				"{{Petrify}} Enemies killed while petrified burst into tears"
			},
			CarBattery = {
				Description = {
					"Petrification damage and duration doubled"
				},
			},
			Abyss = {
				"Petrifies enemies"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL,
					Encyclopedia.ItemPools.POOL_CRANE_GAME
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.X10KACHING,
		Description = {
			Description = {
				"{{Coin}} +10 Coins"
			},
			AbyssSpecial = {
				"10 locusts (x0.05 Isaac's damage)"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.X10BATOOMKLING,
		Description = {
			Description = {
				"{{Key}} +10 Keys"
			},
			AbyssSpecial = {
				"10 locusts (x0.075 Isaac's damage)"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.X10BADUMP,
		Description = {
			Description = {
				"{{Heart}} +10 Hearts"
			},
			AbyssSpecial = {
				"10 locusts (x0.05 Isaac's damage)"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.X10BZZT,
		Description = {
			Description = {
				"{{Battery}} +10 Pips of charge"
			},
			AbyssSpecial = {
				"10 locusts (x0.05 Isaac's damage)"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.X10CHOMPCHOMP,
		Description = {
			Description = {
				"{{Collectible" .. FiendFolio.ITEM.COLLECTIBLE.GLIZZY .. "}} +10 Glizzies"
			},
			AbyssSpecial = {
				"10 slightly fast and bigger locusts (x0.2 Isaac's damage)"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.INFINITY_VOLT,
		Description = {
			Description = {
				"Double tap to link to an enemy",
				"Linked enemies are overloaded and explode"
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.OVERLOADED },
			Abyss = {
				"Fires a continuous laser when charging"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_CRANE_GAME
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.RAT_POISON,
		Description = {
			Description = {
				"{{Warning}} When used in a room with a visible creator, all future rooms by that person will be removed from the run, including rewards",
				"Room names and the creator are shown at the bottom of the screen if the option in the Dead Sea Scrolls menu is enabled"
			},
			CarBattery = false,
			Abyss = {
				"1% chance to erase an enemy for the rest of the run"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.ANGELIC_LYRE_B,
		Description = {
			Description = {
				"{{Tears}} Can be used to change into a unique tear mode with upsides and downsides",
				"Resets tear delay on use",
				"↑ x1.3 Fire rate multiplier",
				"↑ +0.2 Speed",
				"↑ +3 Luck",
				"↓ -0.2 Shot speed",
				"Isaac's tears are fired in a 3-step cycling sequence"
			},
			CarBattery = false,
			AbyssSpecial = {
				"1 fast locust (0.75x Isaac's damage)"
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_ANGEL,
					Encyclopedia.ItemPools.POOL_GREED_ANGEL
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.ANGELIC_LYRE_R,
		Description = {
			Description = {
				"{{Tears}} Can be used to change into a unique tear mode with upsides and downsides",
				"Resets tear delay on use",
				"↑ x2 Damage multiplier",
				"↓ x0.18 Fire rate multiplier",
				"Lets Isaac fire 4 spectral tears"
			},
			CarBattery = false,
			AbyssSpecial = {
				"1 slow locust (1.5x Isaac's damage)"
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {},
				Hide = true
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.ANGELIC_LYRE_Y,
		Description = {
			Description = {
				"{{Tears}} Can be used to change into a unique tear mode with upsides and downsides",
				"Resets tear delay on use",
				"↓ x0.2 Damage multiplier",
				"↑ x4.4 Fire rate multiplier",
				"↑ +2.5 Range",
				"Homing tears",
				"Isaac fires a barrage of 10 tears, stops, and then continues"
			},
			CarBattery = false,
			AbyssSpecial = {
				"1 very fast locust (0.5x Isaac's damage)"
			},
			Abyss = {
				"Homing"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {},
				Hide = true
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.HORSE_PASTE,
		Description = {
			Description = {
				"{{BrokenHeart}} Heals 1 Broken Heart",
				FiendFolio.DescriptionIcons.China .. "Granted only by China's birthright"
			},
			CarBattery = {
				TargetNumbers = {
					{ 1, 2 }
				},
			},
			Virtues = {
				"{{Slow}} Wisp tears inflict Slowness"
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.LEMON_MISHUH,
		Description = {
			Description = {
				"{{Collectible56}} A throwable Lemon Mishap",
				"Spills a pool of creep",
				"The creep deals 24 contact damage per second",
				"Creep persists until you exit the room"
			},
			Virtues = {
				"Rapid, low range tears",
				"Wisp drips yellow creep",
			},
			CarBattery = {
				Description = {
					"Throws out 2 lemons"
				}
			},
			Abyss = {
				"50% chance to spawn yellow creep when dealing damage"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.MIME_DEGREE,
		Description = {
			Description = {
				"Summons 3-5 mime blocks in the room that enemies cannot pass through",
				"Touch the block to relocate it"
			},
			Abyss = {
				"Invisible"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.CRAZY_JACKPOT,
		Description = {
			Description = {
				"On hit, Isaac rolls for a unique effect",
				"{{Luck}} 100% chance to get three matching symbols at 10 luck"
			},
			Abyss = {
				"No effect"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.NIL_PASTA,
		Description = {
			Description = {
				"Captures nearby enemies with spaghetti ropes to hold them in place",
				"Pulling out the spaghetti causes enemies to become glitched, periodically disabling their AI"
			},
			CarBattery = {
				Description = {
					"Shoots out double the spaghetti ropes"
				},
			},
			Virtues = {
				"{{Petrify}} 20% chance to petrify enemies",
				"Lags behind" --idk
			},
			Abyss = {
				"3% chance to make enemies become glitched"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.CLUTCHS_CURSE,
		Description = {
			Description = {
				"Familiar that possesses Isaac occasionally",
				"When possessed, Isaac can fire a homing explosive tear that scales with his damage",
				"{{Warning}} Rocks occasionally glow purple and shoot fire on destruction that hurt Isaac",
			},
			BFFs = {
				Description = {
					"Damage doubled"
				}
			},
			Abyss = {
				"Homing locust"
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_CURSE,
					Encyclopedia.ItemPools.POOL_RED_CHEST
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PET_PEEVE,
		Description = {
			Description = {
				"Grudge familiar that moves around like a Poky",
				"Charges on double tap",
			},
			BFFs = {
				Description = {
					"Damage doubled"
				}
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL,
					Encyclopedia.ItemPools.POOL_CRANE_GAME,
					Encyclopedia.ItemPools.POOL_BABY_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.MOMS_STOCKINGS,
		Description = {
			Description = {
				"↑ +2.5 Range",
				"Spawns 3-9 blue skuzzes",
				"Blue Skuzzes are friendly creatures that hop towards nearby enemies and do x3 Isaac's damage"
			},
			Abyss = {
				"No effect",
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_BOSS,
					Encyclopedia.ItemPools.POOL_GREED_BOSS,
					Encyclopedia.ItemPools.POOL_OLD_CHEST
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GOLDEN_POPSICLE,
		Description = {
			Description = {
				"{{SoulHeart}} +1 Soul Heart",
				"{{Luck}} +1 Luck",
				"Spawns a random golden pickup"
			},
			Abyss = {
				"No effect"
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_BOSS
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.TIME_ITSELF,
		Description = {
			Description = {
				"25% chance to fire multi-euclidean tears",
				"{{Luck}} 100% chance at 15 luck"
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.MULTIEUCLIDEAN
			},
			Abyss = {
				"20% to inflict an enemy with multi-euclidean",
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.HORNCOB,
		Description = {
			Description = {
				"25% chance to take a random pill when you kill an enemy",
				"{{Luck}} 100% chance at 15 luck"
			},
			Abyss = {
				"10% chance to use a pill when killing an enemy"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.EMPTY_BOOK,
		Description = {
			Description = {
				"Customizable active item",
				"Does a variety of effects depending on what you choose"
			},
			CarBattery = {
				Description = {
					"Doubles effects of what you choose"
				},
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP,
					Encyclopedia.ItemPools.POOL_LIBRARY
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.MY_STORY_2,
		Description = {
			Description = {
				"Customizable active item",
				"Does a variety of effects depending on what you choose"
			},
			CarBattery = {
				Description = {
					"Doubles effects of what you choose"
				},
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {},
				Hide = true
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.MY_STORY_4,
		Description = {
			Description = {
				"Customizable active item",
				"Does a variety of effects depending on what you choose"
			},
			CarBattery = {
				Description = {
					"Doubles effects of what you choose"
				},
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {},
				Hide = true
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.MY_STORY_6,
		Description = {
			Description = {
				"Customizable active item",
				"Does a variety of effects depending on what you choose"
			},
			CarBattery = {
				Description = {
					"Doubles effects of what you choose"
				},
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {},
				Hide = true
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.MY_STORY_NULL_TEARS,
		Description = {
			Description = { "" },
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {},
				Hide = true
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.HOST_ON_TOAST,
		Description = {
			Description = {
				"↑ +0.5 Damage",
				"↑ +1.5 Range"
			},
			AbyssSpecial = {
				"1 fast locust (1x Isaac's damage)"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_BOSS,
					Encyclopedia.ItemPools.POOL_GREED_BOSS
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BAG_OF_BOBBIES,
		Description = {
			Description = {
				"Has a chance to spawn a Fragile Bobby on room clear",
				"{{Collectible8}} Fragile bobbies are similar to Brother Bobby but can die"
			},
			BFFs = {
				Description = {
					"Damage doubled"
				}
			},
			AbyssSpecial = {
				"3 locusts (0.5x Isaac's damage)"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_CRANE_GAME,
					Encyclopedia.ItemPools.POOL_BABY_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BOX_TOP,
		Description = {
			Description = {
				"{{SoulHeart}} +1 Soul Heart",
				"↑ +2 Luck",
				FiendFolio.DescriptionIcons.PuzzlePiece .. "Spawns a Puzzle Piece"
			},
			Abyss = {
				"No effect",
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_BOSS
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.KINDA_EGG,
		Description = {
			Description = {
				"↑ +1 Health",
				"{{HealingRed}} Heals 1 heart",
				"{{ffObject}} Spawns a random object"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_BOSS,
					Encyclopedia.ItemPools.POOL_GREED_BOSS
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DADS_DIP,
		Description = {
			Description = {
				"↑ +1 Health",
				"{{ffMorbidHeart}} +1 Morbid Heart",
				"Morbid Hearts take 3 hits of damage to be depleted",
				"When depleted, Morbid Hearts spawn a temporary orbital familiar"
			},
			Abyss = {
				"No effect",
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_BOSS,
					Encyclopedia.ItemPools.POOL_GREED_BOSS,
					Encyclopedia.ItemPools.POOL_OLD_CHEST
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.YICK_HEART,
		Description = {
			Description = {
				"{{ffMorbidHeart}} +1 Morbid Heart",
				"Morbid Hearts take 3 hits of damage to be depleted",
				"When depleted, Morbid Hearts spawn a temporary orbital familiar"
			},
			Abyss = {
				"No effect"
			},
			CarBattery = {
				TargetNumbers = {
					{ 1, 2 }
				},
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_ROTTEN_BEGGAR
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SMASH_TROPHY,
		Description = {
			Description = {
				"↑ +1 Health",
				"{{HealingRed}} Heals 1 heart",
				"↑ +1 Damage",
				"Enemies receive more knockback the less health they have"
			},
			Abyss = {
				"Enemies receive more knockback the less health they have"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BOTTLE_OF_WATER,
		Description = {
			Description = {
				"{{SoulHeart}} +2 Soul Hearts",
				"{{Trinket}} Consumes Isaac's trinket and grants its effects permanently",
				"{{Pill}} Spawns a pill"
			},
			Abyss = {
				"No effect"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_BOSS,
					Encyclopedia.ItemPools.POOL_GREED_BOSS
				}
			}
	},
	{
		ID = Isaac.GetItemIdByName(" Hold"),
		Description = {
			Description = {
				"Using the item when empty stores the next poop inside",
				"Using the item with a poop inside uses that poop"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {},
				Hide = true
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GAMMA_GLOVES,
		Description = {
			Description = {
				"Creates a small shockwave around Isaac, pushing nearby enemies away",
				"{{Warning}} Does not push away enemy projectiles"
			},
			Virtues = {
				"Cannot shoot tears",
				"Wisps dissipate after a second"
			},
			Belial = {
				"Enemies can be pushed towards walls, dealing damage to them, scaling with Judas's damage",
			},
			CarBattery = {
				Description = {
					"Increases the push force applied to enemies"
				},
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP,
					Encyclopedia.ItemPools.POOL_CRANE_GAME
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SHREDDER,
		Description = {
			Description = {
				"Destroys all item pedestals in the room and turns them into random pickups",
				"Pickups spawned from converted items varies based on the current room",
				"Items held up above Isaac's head will also be destroyed",
				"{{Trinket}} Trinkets held up above Isaac's head can be destroyed"
			},
			Virtues = {
				"Wisp only spawns whenever an item is shredded"
			},
			CarBattery = {
				Description = {
					"Double the amount of pickups spawned"
				},
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.FISTFUL_OF_ASH,
		Description = {
			Description = {
				"{{Bomb}} +3 Bombs",
				"Tinted rocks have out of place visuals and spawn more often",
				"Breaking tinted rocks spawns half a heart and grants a fading damage up",
				"{{BrokenHeart}} Breaking tinted rocks also has a 50% chance to remove a broken heart",
				"{{Warning}} Gain a broken heart each floor"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_CURSE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.FIENDS_THIRD_LEG,
		Description = {
			Description = {
				"↑ x3.33 Damage",
				"↑ x1.5 Fire rate multiplier",
				"Homing tears",
				"Tears leave a trail of damaging creep and leave a Fiend Minion on impact"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {},
				Hide = true
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.LOADED_D6,
		Description = {
			Description = {
				"Rerolls pedestal items in the current room into copies of items you're already holding",
				"Will prioritize items that aren't useless when stacked"
			},
			CarBattery = {
				Description = {
					"No effect"
				},
			},
			Abyss = {
				"Turns into other copies of locusts, if available"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_SHOP,
					Encyclopedia.ItemPools.POOL_CRANE_GAME,
					Encyclopedia.ItemPools.POOL_ULTRA_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.ISAAC_DOT_CHR,
		Description = {
			Description = {
				"↑ +1 Life ",
				"{{Collectible721}} On death, Isaac respawns with some of his items replaced with glitched items"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET,
					Encyclopedia.ItemPools.POOL_ULTRA_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.WORM_INSIGNIA,
		Description = {
			Description = {
				"↑ +0.02 Speed"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DADS_BATTERY,
		Description = {
			Description = {
				"{{Battery}} Allows you to use your active item without having enough charge, resulting in negative charge",
				"↓ Having negative charge reduces your Speed and Shot speed, and persists even if you switch active items"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP,
					Encyclopedia.ItemPools.POOL_BATTERY_BUM
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.TORTURE_COOKIE,
		Description = {
			Description = {
				"{{HalfHeart}} Deals half a red heart of damage to Isaac",
				"Grants one of the following rewards:",
				"An evil fortune",
				"{{BlackHeart}} A Black Heart",
				"{{Card}} A Reverse Tarot Card",
				"{{Trinket}} An evil-themed trinket"
			},
			Virtues = {
				"↑ +0.1 Damage per Torture Cookie wisp"
			},
			CarBattery = false
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_CURSE,
					Encyclopedia.ItemPools.POOL_RED_CHEST
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.ISAACD_EULOGY,
		Description = {
			Description = {
				"10% chance to activate a Dice item (D6, D20, etc) upon killing an enemy",
				"{{Luck}} 100% chance at 36 luck"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET,
					Encyclopedia.ItemPools.POOL_ULTRA_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BRICK_FIGURE,
		Description = {
			Description = {
				FiendFolio.DescriptionIcons.Stud .. "Spawns a Brick Separator and 4 Studs",
				"{{Coin}} Pennies have a 20% chance to be converted into Studs"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.MOONBEAM,
		Description = {
			Description = {
				""
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {},
				Hide = true
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GOLDSHI_LUNCH,
		Description = {
			Description = {
				"↑ +1 Health",
				"{{HealingRed}} Heals 1 heart",
				"↑ +0.1 Speed",
				"↑ +0.2 Shot speed",
				"{{Speed}} In cleared rooms, this increases to +0.85 Speed and +0.4 Shot speed"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_BOSS,
					Encyclopedia.ItemPools.POOL_GREED_BOSS
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.TWINKLE_OF_CONTAGION,
		Description = {
			Description = {
				"50% chance for an enemy in a room to glow",
				"{{Damage}} Looking at a glowing enemy gives you x1.5 Damage, x0.85 Fire Rate, and +3 Luck",
				"The glowing effect will jump from Isaac to a random enemy after awhile"
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DUSTY_D10,
		Description = {
			Description = {
				"Rerolls all enemies in the room into different enemies from anywhere in the game",
				"Attempts to reroll enemies into those with similar max HP"
			},
			Virtues = {
				"10% chance for tears to reroll enemies into enemies with similar max HP"
			},
			CarBattery = false
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_SHOP,
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_CRANE_GAME
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.TOKEN_BAG,
		Description = {
			Description = {
				mod.DescriptionIcons.Token .. "Spawns 1 Token every 10 rooms",
				"Tokens mimic the pickup Isaac has last collected"
			},
			BFFs = {
				TargetNumbers = {
					{ 10, 8}
				},
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET,
					Encyclopedia.ItemPools.POOL_CRANE_GAME
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GREEN_ORANGE,
		Description = {
			Description = {
				"↑ +0.7 Damage",
				"↑ +0.5 Tears",
				"{{SoulHeart}} Spawns a Soul Heart"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_BOSS,
					Encyclopedia.ItemPools.POOL_GREED_BOSS
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.REHEATED_PIZZA,
		Description = {
			Description = {
				"↑ +1 Health",
				"{{HealingRed}} Heals 1 heart",
				"At the start of each floor a pizza box will open and spawn a random heart"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.HEDONISTS_COOKBOOK,
		Description = {
			Description = {
				"On use, causes the enemy type with the lowest max HP in the room to explode in a shower of projectiles"
			},
			CarBattery = {
				Description = {
					"Explodes two enemy types"
				}
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_LIBRARY
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.ERRORS_CRAZY_SLOTS,
		Description = {
			Description = {
				"{{Warning}} SINGLE USE {{Warning}}",
				"When used, slots appear above Isaac's head",
				"Using the item locks in a number and speeds up",
				"Gives Isaac an item based on the internal item-ID of the number they rolled",
				"Invalid IDs teleport Isaac to the Error Room"
			},
			Virtues = {
				"4 wisps that shoot {{Collectible369}} Continuum tears that travel between sides of the screen"
			},
			Belial = {
				"{{Damage}} Grants a permanent damage up depending on what number you roll"
			},
			CarBattery = {
				Description = {
					"Gives Isaac two copies of the item he chooses"
				},
			},
			Abyss = {
				"50% chance to have a random effect when hitting an enemy"
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SPELLING_BEE,
		Description = {
			Description = {
				"↑ Gives stat boosts depending on the letters of the current run's seed",
				"{{Damage}} If a letter is from a stat word like DAMAGE, it grants those stats",
				"The same is true for pickups",
				"↓ Numbers will grant a minor all stats down"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SCULPTED_PEPPER,
		Description = {
			Description = {
				"Spawns a stone block that Isaac can break",
				"Fully chiseled stone blocks produce an aura that gives status effects to enemies and buffs to Isaac"
			},
			Virtues = {
				"Wisps are created around statues while they are chiseled",
			},
			Belial = {
				"Spawned statues will always try to crush enemies if possible",
			},
			CarBattery = {
				Description = {
					"Spawns two statues at once",
				},
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.TOO_MANY_OPTIONS,
		Description = {
			Description = {
				"Special room doors cycle between 3 random special room types until unlocked or entered"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP,
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET,
					Encyclopedia.ItemPools.POOL_ULTRA_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.LARGE_DOSE,
		Description = {
			Description = {
				"↑ Grants a very minor all stats up and a moderate increase to one random stat"
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_BOSS,
					Encyclopedia.ItemPools.POOL_GREED_BOSS
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.CROWN_INSIGNIA,
		Description = {
			Description = {
				"↑ +0.02 Speed"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GAPER_IN_A_JAR,
		Description = {
			Description = {
				"If empty, Isaac can swing the jar to place an enemy into the jar",
				"If an enemy is in the jar, Isaac can throw the enemy as a projectile that deals damage equal to the enemy's HP",
				"Can also trigger enemy on-death effects",
				"Bosses cannot be put into the jar"
			},
			CarBattery = false
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.ANATHEMA,
		Description = {
			Description = {
				"Every 7th tear fired inflicts enemies with excommunication"
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.EXCOMMUNICATED
		 	},
			Abyss = {
				"20% chance to inflict enemies with excommunication"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_ANGEL,
					Encyclopedia.ItemPools.POOL_GREED_ANGEL
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.WARFARIN,
		Description = {
			Description = {
				"{{Heart}} High chance for enemies to drop red hearts",
				"{{Warning}} Taking damage causes 1-3 additional red hearts to fly out",
				"These can be recollected, but disappear if left alone",
				"When expiring, hearts release a highly damaging blood explosion"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_CURSE,
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.MTN_DEW,
		Description = {
			Description = {
				"{{Chargeable}} Firing charges up an extended volley of tears",
				"{{ffRadiation}} At the end of the volley, Isaac launches 3 large radiation shots that leave an aura that harms both you and enemies",
				"{{Warning}} Radiation will cause Isaac to drop hearts if stayed in for too long"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DOG_WHISTLE,
		Description = {
			Description = {
				mod.DescriptionIcons.Berserk .. "Inflicts all enemies with Berserk"
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.BERSERK },
			CarBattery = false,
			Abyss = {
				"20% chance to inflict Berserk when dealing damage"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DOOMSDAY_CLOCK,
		Description = {
			Description = {
				"Inflicts all enemies with Doom"
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.DOOM },
			CarBattery = false,
			Abyss = {
				"20% chance to inflict Doom when dealing damage"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SHOCK_IMAGE,
		Description = {
			Description = {
				"16% chance to fire tears that inflict enemies with Overloaded",
				"{{Luck}} 33% chance at 12 luck"
			},
			Abyss = {
				"20% chance to inflict enemies with Overloaded"
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.OVERLOADED }
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.STRING_THEORY,
		Description = {
			Description = {
				"Applies Sewn to enemies in a small radius around Isaac"
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.SEW },
			Abyss = {
				"20% chance to inflict enemies with Sewn"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.LEVEL_2_BREAKFAST,
		Description = {
			Description = {
				"Placeholder description"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.STRANGE_MATTER,
		Description = {
			Description = {
				"3% chance to fire an insta-kill tear that leaves behind mysterious liquid creep on kill",
				"{{Luck}} 25% chance at 13 luck"
			},
			Abyss = {
				"3% chance to to instantly kill enemies"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_DEVIL
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.ANTISAAC,
		Description = {
			Description = {
				"Familiar that sits horizontally aligned with Isaac on the opposite side of the room",
				"Fires piercing spectral tears that deal 3.5 damage",
				"When antisaac's tears collide with Isaac's they explode",
				"Explosion damage scales with Isaac's damage",
				"{{Warning}} Exploding tears do not harm Isaac",
			},
			BFFs = {
				TargetNumbers = {
					{ 3.5, 7}
				},
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_BABY_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.OVERCLOCK,
		Description = {
			Description = {
				"{{Trinket}} Doubles the power of held rocks and removes the power penalty of smelted rocks for 20 seconds"
			},
			CarBattery = {
				TargetNumbers = {
					{ 20, 40 }
				},
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GOLEMS_SUB,
		Description = {
			Description = {
				"{{SoulHeart}} +2 Soul Hearts",
				"{{Trinket}} Drops a random pebble or mixed pebble on pickup"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_BOSS,
					Encyclopedia.ItemPools.POOL_GREED_BOSS
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BLOODTHIRSTY_BLADE,
		Description = {
			Description = {
				"Periodically fires 3 piercing blades that fire towards random enemies, dealing damage and inflicting Hemorrhaging",
				"If Isaac is hit by a blade, it instead bursts into blood tears in the same direction"
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.HEMORRHAGE }
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.ASTEROID_BELT,
		Description = {
			Description = {
				"Grants rock orbitals that block shots upon dealing damage and clearing rooms",
				"Rock orbitals will break after taking enough damage",
				"Rock orbitals can be launched by double tapping a direction to clear projectiles in its path, deal damage, and confuse enemies"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SWEET_RED,
		Description = {
			Description = {
				"{{Chargeable}} Enemies drop berries that give Isaac a chargeable ipecac tear",
				"Rooms can drop berry bunches that upgrade the ipecac tear with extra effects once enough are gained"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_ULTRA_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.HUMAN_DOMESTICATION_GUIDE,
		Description = {
			Description = {
				"{{Charm}} Makes the nearest enemy permanently friendly and snared to Isaac",
				"Item recharges once the snared enemy is killed",
				"{{Heart}} Restoring health also heals snared enemies to full health"
			},
			Virtues = {
				"Wisp surrounds friendly ensnared enemy",
			},
			Belial = {
				"When your charmed enemy dies, they explode into a {{Collectible684}} Hungry Soul explosion",
			},
			CarBattery = {
				Description = {
					"Can ensare two enemies"
				},
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_LIBRARY
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SIDEWAYS_ONION,
		Description = {
			Description = {
				"↑ +1.2 Flat tears when firing to the left or right"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.INFESTED_PIPELINE,
		Description = {
			Description = {
				"Chance to pheromone fart periodically",
				"At the start of every floor, Isaac will fart 53 times and spawn 100 decoration worms"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {},
				Hide = true
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.HUITLACOCHE,
		Description = {
			Description = {
				"{{ffImmoralHeart}} +2 Immoral Hearts",
				"Whenever a Fiend Minion spawns or kills an enemy, it spawns a friendly Shiitake spore with increased health and damage"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SPACE_FOOD,
		Description = {
			Description = {
				"↑ +1 Health",
				"{{HealingRed}} Heals 1 heart",
				"{{Planetarium}} +10% Planetarium chance",
				"50% chance to gain status immunity for 3 minutes"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.CHEMICAL_COOKIE,
		Description = {
			Description = {
				"Every 2 seconds, the next tear Isaac shoots is colored and spawns a puddle of creep on impact",
				"The color of the creep determines its effects"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SPIRIT_OF_NIGHTMARE,
		Description = {
			Description = {
				"15% chance to fire tears that inflict enemies with Drowsy",
				"Sleeping enemies gain a counter that counts down over time",
                "Upon reaching zero, the enemy takes a large amount of damage",
				"{{Luck}} 50% chance at 25 luck",
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.DROWSY_AND_SLEEP },
			Abyss = {
				"20% chance to inflict enemies with Drowsy"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_DEMON_BEGGAR
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.IMP_CURSE,
		Description = {
			Description = {
				"{{HalfHeart}} 25% chance to spawn 5 Fiend Minions and lose half a heart when entering a combat room",
				"{{ffHalfImmoralHeart}} Chance for one of these minions to drop half an Immoral heart",
				"This prioritizes Red Hearts before Soul Hearts"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_RED_CHEST
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.COPPER_CHUNK,
		Description = {
			Description = {
				"Chance for enemies to gain x1.5 health and become bigger or halve their health and become smaller",
				"{{ffCopperBomb}} Increased chance for bombs and troll bombs to become copper",
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_CURSE,
					Encyclopedia.ItemPools.POOL_GREED_CURSE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BAD_BLOOD,
		Description = {
			Description = {
				"When Isaac is at 6 hearts or lower, enemies will take extra damage from all sources",
				"{{Damage}} The damage multiplier will increase as Isaac's health decreases"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.CHAOTIC_CARVING,
		Description = {
			Description = {
				"{{Chargeable}} Grants a 3 stage charge bar that will place down a statue that inflicts debuffs in an aura",
				"Stage 1 applies Charm, Berserk, or Confuse",
				"Stage 2 Petrifies",
				"Stage 3 Petrifies and deals heavy damage in a radius upon expiring",
				"{{Warning}} Stage 3 can only be used once per room"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.CLOWN_MEAT,
		Description = {
			Description = {
				"{{Chargeable}} Moving charges up an invincible dash that activates upon stopping",
				"Overcharging the bar increases the charge's damage and duration",
				"The dash can be canceled by holding a movement direction while using it"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.FUN_PIZZA,
		Description = {
			Description = {
				"↑ +1 Health",
				"↑ +0.35 Tears",
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_BOSS,
					Encyclopedia.ItemPools.POOL_GREED_BOSS
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.TIME_IS_MONEY,
		Description = {
			Description = {
				"{{ffLilPenny}} Gives Isaac a lil' penny every 4 seconds"
			},
			BFFs = false
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_CRANE_GAME
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.LOADSAMONEY,
		Description = {
			Description = {
				"25% chance to fire tears that inflict Mugged",
				"{{Luck}} 100% chance at 25 luck"
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.MUGGED
		 	},
			Abyss = {
				"20% chance to inflict enemies with Mugged"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BIG_ROCK,
		Description = {
			Description = {
				"↑ +0.4 Tears",
				"↑ +2 Damage",
				"↓ -0.4 Speed"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BIG_WOOD,
		Description = {
			Description = {
				"↑ +1.4 Tears",
				"↑ +0.4 Damage",
				"↓ -0.4 Shot speed"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_WOODEN_CHEST
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BIG_PIPE,
		Description = {
			Description = {
				"↑ +0.4 Damage",
				"↑ +0.4 Tears ",
				"↑ +0.4 Shot speed",
				"↑ +0.4 Speed"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.HOW_TO_ROLL,
		Description = {
			Description = {
				"Allows Isaac to dodge roll, allowing him to move quickly"
			},
			CarBattery = false
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP,
					Encyclopedia.ItemPools.POOL_CRANE_GAME
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.LE_CAT,
		Description = {
			Description = {
				"↑ +1 Health",
				"{{HealingRed}} Heals 1 heart",
				"↑ +0.5 Damage",
				"↑ +0.1 Tears",
				"↑ +0.1 Speed",
				"↑ +1 Luck",
				"{{Coin}} Spawns 5 random coins",
				"Spawns a fortune paper"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BONE_HURTING_JUICE,
		Description = {
			Description = {
				"{{Damage}} Turns bone orbitals into Damage",
				"The more bone orbitals you have, the more Damage you will receive",
				"{{Timer}} Damage from bone orbitals wears off over time"
			},
			CarBattery = false
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GRANDPAS_WHISKEY,
		Description = {
			Description = {
				"↑ +1 Tears",
				"↓ Tear accuracy down"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_OLD_CHEST
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.ORGAN_DONOR,
		Description = {
			Description = {
				"↑ +3 Health",
				"{{HealingRed}} Full health",
				"{{Warning}} Turns all heart drops in the run into Red Hearts"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_CURSE,
					Encyclopedia.ItemPools.POOL_GREED_CURSE,
					Encyclopedia.ItemPools.POOL_ULTRA_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GREEN_CANDLE,
		Description = {
			Description = {
				"{{Poison}} Throws a green poisonous flame",
				"The flame leaves a trail of poison gas, blocks projectiles, and despawns after 2 seconds or after damaging an enemy"
			},
			CarBattery = false,
			Virtues = {
				"Leaves behind a poisonous gas trail"
			},
			VirtuesSingleRoom = true
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.JUMBO_JOSH,
		Description = {
			Description = {
				"↑ x2 Damage",
				"Size up",
				"Green up",
				"{{Warning}} Real item"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {},
				Hide = true
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.THE_LAST_BLACK_HEART,
		Description = {
			Description = {
				"{{BlackHeart}} +1 Black Heart",
				"{{Warning}} Turns all Black Heart drops in the run into other hearts"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.HUNDRED_PERCENT_ORANGE_JUICE,
		Description = {
			Description = {
				"Causes colorful floor tiles that Isaac can step on to appear in rooms",
				"These tiles do different things depending on their color"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BOMB_COLLAR,
		Description = {
			Description = {
				"{{Tears}} Flat tears up that gets stronger based on how low your health is",
				"{{Warning}} Isaac explodes and dies if he takes damage with 2 Hearts or less"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_CURSE,
					Encyclopedia.ItemPools.POOL_GREED_CURSE,
					Encyclopedia.ItemPools.POOL_RED_CHEST,
					Encyclopedia.ItemPools.POOL_BOMB_BUM
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.HOT_SHOT,
		Description = {
			Description = {
				"Friend throws a purple fire which can be shot to explode enemies",
				"{{Burning}} The flame inflicts Burning on enemies and deals twice your damage",
				"{{HalfHeart}} 30% chance for enemies to drop half red hearts when killed by Hot Shot's explosion",
				"{{Warning}} The explosion from the purple flame can hurt you"
			},
			CarBattery = {
				Description = {
					"A smaller, second fireball gets shot out when Friend throws the purple fire"
				},
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.INFESTATION_3,
		Description = {
			Description = {
				"Spawns a Blue Skuzz after walking 50 steps",
				"Blue Skuzzes are friendly creatures that hop towards nearby enemies and do x3 Isaac's damage"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.INFESTATION_4,
		Description = {
			Description = {
				"Spawns a Blue Beetle after dealing 50 damage",
				"Blue Beetles are friendly creatures that shield Isaac from oncoming attacks and projectiles"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.UTILITY_POLE,
		Description = {
			Description = {
				"Spawns a crow with a gift at the start of every second floor",
				"Walking into the gift will open it, spawning 2-4 random consumables"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.LIL_FRIEND,
		Description = {
			Description = {
				"Shoots bullets from her gun that deal 4.9 Damage",
				"Can only shoot 6 bullets before reloading",
				"Homes in on enemies",
			},
			BFFs = {
				TargetNumbers = {
					{4.90, 9.8}
				},
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL,
					Encyclopedia.ItemPools.POOL_DEMON_BEGGAR,
					Encyclopedia.ItemPools.POOL_BABY_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.TRICOLOR_KEY,
		Description = {
			Description = {
				"{{Key}} All colored locks are free to open",
				"Has a chance to randomly replace rocks with a colored lock in a room"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_KEY_MASTER
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.D5,
		Description = {
			Description = {
				"Dice that can be picked up and thrown around",
				"When it lands, it does an effect depending on the side"
			},
			BFFs = {
				Description = {
					"Damage doubled"
				}
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_CRANE_GAME,
					Encyclopedia.ItemPools.POOL_ULTRA_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.TELEPORT_ALPHA,
		Description = {
			Description = {
				"Teleports Isaac to a random position in a room",
				"Teleporting directly on an enemy does 50 Damage"
			},
			CarBattery = {
				Description = {
					"Teleports Isaac twice"
				},
			},
			Virtues = {
				"Leaves a stationary wisp where Isaac teleports from"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_CRANE_GAME
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SPINACH_PIE,
		Description = {
			Description = {
				"15% chance to fire tears that leave a trail of green damaging creep",
				"{{Luck}} 45% chance at 20 luck"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PAGEANT_BOY_2,
		Description = {
			Description = {
				"{{Coin}} Spawns 7 random coins"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DRIED_PAINT,
		Description = {
			Description = {
				"Killing an enemy spawns an abstract art piece which does not deal contact damage",
				"Killing the art piece spawns a barrage of colorful tears that scale with your damage"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL,
					Encyclopedia.ItemPools.POOL_ULTRA_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GIRL_DINNER,
		Description = {
			Description = {
				"↑ +1 Health",
				"{{HealingRed}} Heals 1 heart",
				"{{Warning}} Girls only"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {},
				Hide = true
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.EMPTY_GAZE,
		Description = {
			Description = {
				"↑ +0.3 Damage",
				"When an enemy dies, they shoot out bones and more gore particles",
				"Killing enemies pushes other enemies away"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.CRAIGS_BATTERY,
		Description = {
			Description = {
				"Bulb lanterns spawn in rooms with enemies",
				"{{Battery}} Picking up lanterns and hurting enemies fills up the charge bar",
				"When used, Craig can shoot out a big laser",
				"Laser size depends on how much charge this item has",
				"Needs 1/3 charge at minimum to use",
				"{{Warning}} Explodes if overcharged fully"
			},
			Virtues = {
				"{{Shotspeed}} Piercing tears"
			},
			Abyss = {
				"Electricity on hit"
			},
			CarBattery = false,
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.EFFICIENCY_MODULE,
		Description = {
			Description = {
				"{{Battery}} After using an active item, Isaac will gain back 0-50% of its charge"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.RED_NO_3,
		Description = {
			Description = {
				"↑ +0.7 Tears",
				"{{ffMorbidHeart}} +1 Morbid Heart"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_BOSS,
					Encyclopedia.ItemPools.POOL_GREED_BOSS,
					Encyclopedia.ItemPools.POOL_ULTRA_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BABY_FORMULA,
		Description = {
			Description = {
				"↑ +1 Health",
				"{{HealingRed}} Heals 1 heart",
				"↑ Size down",
				"↑ +0.05 Speed"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_BOSS,
					Encyclopedia.ItemPools.POOL_GREED_BOSS
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.FLIP_PHONE,
		Description = {
			Description = {
				"Using the item and firing in a direction fires a giant piercing electric tear",
				"The shocks from the electric tear do 1.8 Damage",
				"Isaac can control this tear",
				"The more you change the direction of the tear, the faster it becomes"
			},
			Virtues = {
				"{{Shotspeed}} Piercing tears"
			},
			Abyss = {
				"Electricity on hit"
			},
			AbyssSpecial = {
				"1 very fast locust (0.75x Isaac's damage)"
			},
			CarBattery = false
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP,
					Encyclopedia.ItemPools.POOL_GOLDEN_CHEST,
					Encyclopedia.ItemPools.POOL_CRANE_GAME,
					Encyclopedia.ItemPools.POOL_BATTERY_BUM
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DOUBLE_DOG,
		Description = {
			Description = {
				"↑ +0.5 Damage",
				"↑ +3 Range",
				"↑ +0.2 Shot speed",
				"The next item Isaac picks up will be replaced by a dog familiar",
				"This dog familiar is based on the current room type you pick up the item in"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DEFAULT_DOG,
		Description = {
			Description = {
				"Shoots normal tears",
				"Does 3.5 damage per tear",
				"{{TreasureRoom}} Gained by picking up an item in the Treasure Rooms and {{BossRoom}} Boss Rooms"
			},
			BFFs = {
				TargetNumbers = {
					{ 3.5, 7 }
				},
			},
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DEVIL_DOG,
		Description = {
			Description = {
				"↑ +1 Damage",
				"Does 6.66 damage per tear",
				"{{DevilRoom}} Gained by picking up an item in Devil Rooms",
				"{{ffDoom}} Tears inflict enemies with Doom",
			},
			BFFs = {
				TargetNumbers = {
					{ 6.66, 13.32 }
				},
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.DOOM},
			Abyss = {
				"20% chance to inflict enemies with Doom"
			}
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DIVINE_DOG,
		Description = {
			Description = {
				"↑ +0.7 Tears",
				"Does 5 damage per tear",
				"{{AngelRoom}} Gained by picking up an item in Angel Rooms",
				"Enemies killed by tears will turn into Martyrs",
			},
			BFFs = {
				TargetNumbers = {
					{ 5, 10 }
				},
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.MARTYR},
			Abyss = {
				"20% chance to turn enemies into Martyrs upon kill"
			}
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DEAD_DOG,
		Description = {
			Description = {
				"↑ +1 Life",
				"Does 4 damage per tear",
				"{{Collectible453}} Tears shatter into 1-3 bone shards upon hitting everything",
				"{{SecretRoom}} {{SuperSecretRoom}} Gained by picking up an item in Secret Rooms",
			},
			BFFs = {
				TargetNumbers = {
					{ 4, 8 }
				},
			},
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DISCOUNT_DOG,
		Description = {
			Description = {
				"Does 3.5 damage per tear",
				"A random assortment of bombs, coins, and keys spawn",
				"{{Shop}} Shop items cost 25% less",
				"{{Shop}} Gained by picking up an item in Shops",
			},
			BFFs = {
				TargetNumbers = {
					{ 3.5, 7 }
				},
			},
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.KALU,
		Description = {
			Description = {
				"Does 7 damage per tear",
				"{{Petrify}} 30% chance to petrify enemies",
				"{{Petrify}} Enemies killed while petrified burst into tears",
				"{{CursedRoom}} Gained by picking up an item in Curse Rooms",
			},
			BFFs = {
				TargetNumbers = {
					{ 7, 14 }
				},
			},
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DOG_DOG_DOG_DOG,
		Description = {
			Description = {
				"Spawns 5 dogs from the dog folder",
				"The tears shot by the dogs have different effects",
				"{{ErrorRoom}} Gained by picking up an item in Error Rooms",
			},
			BFFs = {
				Description = {
					"Double damage"
				},
			},
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.FABERGE_BOMBS,
		Description = {
			Description = {
				"{{Coin}} +6 Coins",
				"{{Coin}} If Isaac has no bombs, he can still place one at the cost of 3 Coins",
				"{{ffLilPenny}} Bombs explode into a radial scattershot of damaging lil' pennies"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_CRANE_GAME,
					Encyclopedia.ItemPools.POOL_BOMB_BUM
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.HYDROKINESIS,
		Description = {
			Description = {
				"↓ x0.5 Fire rate multiplier",
				"↓ -0.2 Shot speed",
				"Many tears spawn around Isaac when he shoots that fire towards enemies",
			},
			Abyss = {
				"Tears occasionally spawn around the locust while charging that fire towards enemies"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.FRIENDS_FIREBALL_FORMULA,
		Description = {
			Description = {
				"{{Burning}} 5% chance to shoot out a purple tear that inflicts Burning on enemies",
				"Burned enemies burst into purple flame jets when killed",
				"{{Luck}} 100% chance at 20 luck"
			},
			Abyss = {
				"Inflicts Burn"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DAYDREAM,
		Description = {
			Description = {
				"When in an active room, a thought bubble appears beside Isaac every 15-30 seconds",
				"Thought bubbles have two timed prompts that you can choose from using the up and down keys",
				"Pressing the drop button ({{ButtonRT}}) ends the prompt early, granting you the reward"
			},
			Abyss = {
				"33% chance to have a random effect when hitting an enemy"
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.THE_WAR_HORN,
		Description = {
			Description = {
				'When used:',
				"↑ +0.25 Speed",
				"{{Damage}} Combat familiars deal x3 Damage",
				"{{Battery}} Deactivating incurrs a 15 second recharge time",
				"↓ Taking damage while in the frenzy state forcibly cancels it, doubles the amount of damage taken, and kills all frenzied familiars",
				"{{Collectible11}} One killed familiar is revived each room",
				"{{Collectible8}} Summons a Brother Bobby style familiar if Isaac owns no permanent combat familiars"
			},
			Belial = {
				"{{Damage}} Familiar damage mult increased to x3.33",
				"{{Burning}} 26.66% chance for familiars tears to light enemies on fire",
			},
			Virtues = {
				"{{Slow}} Wisp tears inflict Slowness"
			},
			CarBattery = false,
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_RED_CHEST,
					Encyclopedia.ItemPools.POOL_ULTRA_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.THE_WAR_HORN_CHARGING,
		Description = {
			Description = {
				'Toggles a "familiar frenzy" state on use:',
				"{{Damage}} Combat-familiars deal x3 Damage, except blue bugs",
				"↑ +0.25 Speed",
				"{{Battery}} Deactivating incurrs a 15 second recharge time",
				"↓ Taking damage while in the frenzy state forcibly cancels it, doubles the amount of damage taken, and kills all frenzied familiars",
				"{{Collectible11}} One killed familiar is revived each room",
				"{{Collectible8}} Summons a Brother Bobby style familiar if Isaac owns no permanent combat familiars"
			},
			Belial = {
				"{{Damage}} Familiar damage mult increased to x3.33",
				"{{Burning}} 26.66% chance for familiars tears to light enemies on fire",
			},
			CarBattery = false,
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_RED_CHEST,
					Encyclopedia.ItemPools.POOL_ULTRA_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.ZIP_43,
		Description = {
			Description = {
				"{{Bomb}} +5 Bombs",
				" Bombs apply Download Failure to every enemy in the room when they explode",
				"{{ffOverloaded}} 5% chance to apply Overloaded instead"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET,
					Encyclopedia.ItemPools.POOL_BOMB_BUM
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.FETAL_FRIEND,
		Description = {
			Description = {
				"{{Heart}} Converts Isaac's health into Ammo Hearts, which decrement when shooting and reload when not",
				"Ammo Hearts correspond to the type of health Isaac has",
				"↑ +0.8 Damage",
				"{{Damage}} +0.8 Damage while above zero ammo",
				"↑ +0.3 Shot speed while above zero ammo",
				"↓ -0.3 Tears while at zero ammo"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL,
					Encyclopedia.ItemPools.POOL_DEMON_BEGGAR
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.IMP_SODA_TRICKY_CHERRY,
		Description = {
			Description = {
				"{{Timer}} Every 20 seconds in an uncleared room:",
				"Isaac gets a 100% chance to shoot out red critical tears that do x5 damage for 3 seconds"
			},
			Abyss = {
				"4% chance to deal x5 damage"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL,
					Encyclopedia.ItemPools.POOL_DEMON_BEGGAR
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SHUFFLE_TIME,
		Description = {
			Description = {
				"63% chance to grant a reward upon completing rooms without taking damage"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.EIGHTEEN_FOOT_LEASH,
		Description = {
			Description = {
				"Periodically in active rooms, Isaac will poop 3-7 times in a row",
				"These poops have a 50% chance to have Drug Baggies",
				"Drug baggies grant:",
				"↑ +2 Tears",
				"↑ +0.8 Speed",
				"↓ {{Collectible582}} A wavy cap screen distortion",
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.VOYAGER_VENDOR,
		Description = {
			Description = {
				"Spawns a vending machine in the room",
				"{{Coin}} This vending machine always contains an active item, and the cost ranges from 0-10 coins"
			},
			CarBattery = {
				PartialReplace = {
					["a vending machine"] = "2 vending machines",
				}
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.WARDENS_CROWN,
		Description = {
			Description = {
				"5% chance to fire a Warding tear",
				"{{Luck}} 20% chance at 7 luck",
				"Warding tears trap enemies in a ring of stars for 10 seconds",
				"Any other enemies that enter the ring are also trapped"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_ANGEL,
					Encyclopedia.ItemPools.POOL_GREED_ANGEL
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DYNAMITE_PACK,
		Description = {
			Description = {
				"{{Bomb}} On use, spawns 3 throwable red bombs"
			},
			CarBattery = {
				TargetNumbers = {
					{ 3, 6 }
				},
			},
			Virtues = {
				"Red wisp"
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_BOMB_BUM,
					Encyclopedia.ItemPools.POOL_ULTRA_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.THE_FINAL_OPTION,
		Description = {
			Description = {
				"Teleport to a special room containing 8 items from curated item pools",
				"{{Warning}} Taking {{ColorRed}}ANY {{ColorWhite}}items causes these certain special rooms to no longer generate in this run: ",
				"{{TreasureRoom}} Treasure Rooms",
				"{{Shop}} Shops",
				"{{Library}} Libraries",
				"{{DevilRoom}} Devil Deals",
				"{{AngelRoom}} Angel Deals",
				"{{Planetarium}} Planetariums",
				"{{UltraSecretRoom}} Ultra Secret Rooms"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PAK_CHOI,
		Description = {
			Description = {
				"↑ 1.09x multipliers for:",
				"{{Tears}} Tears",
				"{{Damage}} Damage",
				"{{Speed}} Speed",
				"{{Luck}} Luck",
				"{{Shotspeed}} Shot speed",
				"{{Range}} Range",
				"{{Range}} Tear Height",
				"{{DevilChance}} Devil/Angel deal chance",
				"{{PlanetariumChance}} Planetarium chance",
				"{{Collectible11}} Extra lives",
				"{{Heart}} Heart Container limit",
				"{{Coin}} Current coin count",
				"{{Coin}} Coin capacity",
				"{{Bomb}} Current bomb count",
				"{{Bomb}} Bomb capacity ",
				"{{Key}} Current key count",
				"{{Key}} Key capacity",
				"{{Trinket81}} Invulnerability duration",
				"{{Collectible58}} Shield duration",
				"{{Collectible308}} Player creep lifespan",
				"{{Battery}} Timed active charge rate ",
				"{{Speed}} Player friction",

				-- Beyond this point the description extends off of the screen at default Description scale, start describing the mildly niche stuff now
				"{{ffHitbox}} Player hitbox size",
				"{{Trinket" .. mod.ITEM.ROCK.HEAVY_METAL .. "}} Player collision mass",
				"{{Collectible300}} Player collision damage",
				"{{Bomb}} Bomb placement rate",
				"{{Bomb}} Bomb damage",
				"{{Tearsize}} Tear size",
				"{{Trinket45}} Poker Table odds",
				"{{BlackHeart}} Black Heart damage",

				-- Beyond this point the description extends off of the screen at x0.75 Description scale, start describing the really niche stuff now
				"{{Player18}} Soul Gauge charge",
				"{{Player36}} Blood Gauge charge",
				"{{Player25}} Current mana count",
				"{{Player" .. mod.PLAYER.GOLEM .. "}} Rock power",
				"{{Collectible" .. mod.ITEM.COLLECTIBLE.PYROMANCY .. "}} Fireball generation rate",
				"{{Collectible412}} Cambion gestation rate",
				"{{Collectible413}} Immaculate gestation rate",
				"{{Collectible206}} Head orbit speed",
				"{{Collectible206}} Head orbit distance",
				"{{Collectible725}} IBS charge rate",
				"{{Collectible441}} Mega Blast duration",
				"{{Collectible621}} Damage boost duration",
				"{{Collectible625}} Mega Mush duration",
				"{{Collectible674}} Slo-mo duration",
				"{{Collectible77}} Invincibility duration",
				"{{Collectible497}} Stat boost duration",
				"{{Collectible295}} Magic Fingers damage",
				"{{Collectible507}} Sharp Straw damage",
				"{{Collectible136}} Best Friend damage",
				"{{Collectible37}} Mr. Boom damage",

				-- I'm just taking the piss here, it buffs every chance based tear effect's chance
				"{{Collectible103}} Common Cold poison chance",
				"{{Collectible257}} Fire Mind burn chance",
				"{{Collectible496}} Euthanasia needle chance",
				"{{Collectible398}} God's Flesh shrink chance",
				"{{Collectible150}} Tough Love tooth chance",
				"{{Collectible443}} Apple! razor chance",
				"{{Collectible553}} Mucormycosis tear chance",
				"{{Collectible459}} Sinus Infection chance",
				"{{Trinket98}} Nose Goblin chance",
				"{{Collectible637}} Knockout Drops fist chance",
				"{{Collectible618}} Rotten Tomato bait chance",
				"{{Collectible617}} Lodestone magnetic chance",
				"{{Collectible461}} Parasitoid egg tear chance",
				"{{Collectible200}} Mom's Eyeshadow chance",
				"{{Collectible460}} Glaucoma confusion chance",
				"{{Collectible259}} Dark Matter fear chance",
				"{{Collectible228}} Mom's Perfume fear chance",
				"{{Collectible393}} Serpent's Kiss chance",
				"{{Trinket30}} Pinky Eye poison chance",
				"{{Collectible231}} Ball of Tar slow chance",
				"{{Collectible89}} Spider Bite slow chance",
				"{{Trinket130}} Chewed Pen slow chance",
				"{{Collectible" .. FiendFolio.ITEM.COLLECTIBLE.STRANGE_MATTER .. "}} Strange Matter chance",
				"{{Collectible" .. FiendFolio.ITEM.COLLECTIBLE.IMP_SODA .. "}} Imp Soda crit rate",

				-- This shit sucks hide it as far as possible
				"{{Guppy}} Guppy fly chance",
				"{{Collectible640}} Current souls (floored)",
				"{{Collectible434}} Current flies (floored)",
				"{{Heart}} Heart containers (floored)",
				"{{Heart}} Health (floored)",
				"{{SoulHeart}} Soul health (floored)",
				"{{GoldenHeart}} Golden health (floored)",
				-- Beyond this point who cares man
				"{{ffWitherSkull}} Wither Skull drop rate"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.MAMMONITE_CODEX,
		Description = {
			Description = {
				"{{Warning}} SINGLE USE {{Warning}}",
				"{{Player" .. mod.PLAYER.GOLEM .. "}} Teleports Isaac to a crawlspace that contains every Golem rock in the game",
				"Choosing three rocks smelts them onto Isaac and teleports him back to the room he came from"
			},
			CarBattery = false
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.MOMS_HEART,
		Description = {
			Description = {
				"↑ +125 Health",
				"{{HealingRed}} Full Health"
			}
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GRANDPAS_GATLING_GUN,
		Description = {
			Description = {
				"{{Timer}} Gives Isaac a giant minigun, allowing him to rapidly fire bullets for up to 9 seconds",
				"Bullets deal x2 Isaac's damage and break rocks and doors",
				"Isaac can stop shooting anytime he wants",
				"Minigun ammo replenishes every floor"
			},
			Belial = {
				"Bullets light enemies on fire and have a 10% chance to explode on enemy impact"
			},
			CarBattery = false,
			Abyss = {
				"Breaks grids while charging"
			},
			AbyssSpecial = {
				"1 slow locust (2x Isaac's damage)"
			},
			Virtues = {
				"6 wisps that shoot bullets when the minigun is firing",
				"Wisps dissipate the more Isaac uses the item"
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_OLD_CHEST,
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SHADOW_CLUSTER,
		Description = {
			Description = {
				"Isaac leaves a trail of purple creep that doesn't harm enemies",
				"When Isaac uses the item, he shoots out a ring of purple creep",
				"After using the item, long spikes appear from the purple creep that damage enemies",
				"Spikes copy Isaac's tear effects"
			},
			Virtues = {
				"Wisps shoot tears that spawn purple creep",
			},
			Belial = {
				"Increased size and damage",
			},
			Abyss = {
				"25% chance to spawn a spike when dealing damage"
			},
			CarBattery = {
				Description = {
					"Doubled duration of spikes"
				},
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SHUFFLE_BOMBS,
		Description = {
			Description = {
				"{{Bomb}} +5 Bombs",
				"Isaac's bombs have three different effects when placed",
				"These effects randomize every floor"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BULLET_HELL,
		Description = {
			Description = {
				"Two targets periodically spawn in active rooms",
				"Stepping on a target causes Isaac to shoot a radial bullet pattern"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GUPPYS_HEART,
		Description = {
			Description = {
				"{{ffMorbidHeart}} Replaces all Soul and Black Heart pickups with Morbid Hearts",
				"Morbid chunks spawn 1-3 blue flies when destroyed",
				"{{SoulHeart}} Heart replacement doesn't happen for soul heart only characters"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL,
					Encyclopedia.ItemPools.POOL_CURSE,
					Encyclopedia.ItemPools.POOL_GREED_CURSE,
					Encyclopedia.ItemPools.POOL_RED_CHEST
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.RAILDRIVER,
		Description = {
			Description = {
				"Grants a one shot railgun at the start of each room that fires a piercing shot",
				"If the shot hits a wall to an adjacent room, it will continue into that room as well",
				"Shot damage scales with Isaac's damage"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DESTINED_DOG,
		Description = {
			Description = {
				"Does 4 damage per tear",
				"{{UltraSecretRoom}} Gained by picking up an item in an Ultra Secret Room",
				"Chance to shoot random red tear effects",
			},
			BFFs = {
				TargetNumbers = {
					{ 4, 8 }
				},
			},
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.REPENTANCE_PLUS,
		Description = {
			Description = {
				"Pressing the ALT key creates a wheel of emotes",
				"Pressing ALT again makes Isaac emote"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.QUEENS_FRUIT,
		Description = {
			Description = {
				"{{Damage}} Chance for enemies to spawn a bloody aura that grants damage while Isaac stands inside",
				"{{HalfHeart}} When the aura expires when inside, Isaac heals half a red heart once per room",
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				},
				Hide = true,
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.STRANGE_EYE,
		Description = {
			Description = {
				"Stat tracks every single monster Isaac kills",
				"↑ +0.1 Damage for the left eye if you have 0 kills",
				"{{Damage}} Damage increases the more enemies Isaac kills",
				"{{Luck}} Chance to shoot a purple critical tear that deals x5 damage",
				"Critical tear chance increases the more enemies Isaac kills",
				"{{Warning}} Kill count does not reset on new runs",
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SNAGS,
		Description = {
			Description = {
				"Grants a Snagger familiar that picks up nearby coins, keys, and bombs",
				"Pick ups are turned miniature and are thrown at nearby enemies",
				"{{Heart}} Hearts can be collected and thrown at Isaac if he needs healing",
				"Can only hold a certain amount of each pick up at once"
			},
			BFFs = {
				Description = {
					"Can hold more of each pick up"
				}
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.CEILING_POPCORN,
		Description = {
			Description = {
				"↑ +0.7 Damage",
				"{{ffMorbidHeart}} +1 Morbid Heart"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_BOSS,
					Encyclopedia.ItemPools.POOL_GREED_BOSS
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.EXECUTIONER,
		Description = {
			Description = {
				"Executes enemies that are damaged enough after 4 seconds in a room",
				"Bosses are executed if under 35% health, normal enemies if under 75%"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GIZMO_BOOTS,
		Description = {
			Description = {
				"↑ +0.3 Speed",
				"Flight only in cleared rooms",
			},
			AbyssSpecial = {
				"1 faster locust (1x Isaac's damage)"
			},
			Abyss = {
				"10% chance to burn enemies"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.ELECTRIC_DICE,
		Description = {
			Description = {
				"{{Battery}} 66% chance to use an active item 1-2 more times on use"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP
				}
			},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PRODUCTIVITY_MODULE,
		Description = {
			Description = {
				"{{Battery}} Supercharges every Xth use of an active item, where X is the amount of charges the active has",
				"When buffed, causes the active to be used 3 more times"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SPEED_MODULE,
		Description = {
			Description = {
				"{{Battery}} Actives will refund 50% of their charge if used within 5 seconds of being charged"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PLASMA_BALL,
		Description = {
			Description = {
				"",
				"Gives Isaac a plasma ball that he can roll around",
				"Touching the ball zaps nearby enemies for Isaac's damage",
				"Ball will occasionally zap nearby enemies passively"
			},
			BFFs = {
				Description = {
					"Zaps more often with longer range"
				}
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_CRANE_GAME
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.LOURDES_WATER,
		Description = {
			Description = {
				"Every room, a random rock will turn into an angellic statue",
				"This statue emanates an aura",
				"While inside the statue's aura:",
				"↑ {{Tears}} x2.5 Fire rate multiplier",
				"↑ {{Damage}} x1.2 Damage multiplier",
				"Homing tears",
				"Chance to block damage"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_ANGEL,
					Encyclopedia.ItemPools.POOL_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DECK_BOX,
		Description = {
			Description = {
				"Must be charged by picking up cards",
				"{{Card}} Using the item while Isaac is holding a card over his head will store it",
				"Activates all stored cards on use",
				"{{Luck}} 15% chance for enemies drop cards with offensive effects on death",
				"{{Timer}} Enemy-dropped cards disappear quickly"
			},
			CarBattery = {
				Description = {
					"Activated cards are doubled"
				},
			},
			Belial = {
				"Stored cards will turn into their reversed counterparts"
			},
			Virtues = {
				"{{Card}} A card is dropped when the wisp kills an enemy"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_GOLDEN_CHEST
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DEVI,
		Description = {
			Description = {
				"{{Battery}} Every 2 times you use your active item, decrease its maximum charge for the current floor",
				"Cannot go below 1 charge or 1 second",
				"Timed actives have their maximum charge reset on new room"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_ANGEL,
					Encyclopedia.ItemPools.POOL_GREED_ANGEL
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DOUBLES,
		Description = {
			Description = {
				"↓ x0.46 Fire rate multiplier",
				"Isaac shoots 1-6 tears at once",
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_CRANE_GAME,
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DISCIPLINE,
		Description = {
			Description = {
				"{{SacrificeRoom}} Entering the Sacrifice Room for the first time triggers the spikes 4 times for free",
				"{{SacrificeRoom}} 33% chance to generate a Sacrifice Room on entering a floor, if there is not already on there"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_ANGEL
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.EYE_OF_PROVIDENCE,
		Description = {
			Description = {
				"Tears that hit enemies fire a homing beam towards Isaac that deals x0.25 of his damage"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_ANGEL,
					Encyclopedia.ItemPools.POOL_GREED_ANGEL
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.STORY_OF_UNDERTALE,
		Description = {
			Description = {
				"{{Charm}} Spawns 2 friendly Goats, Bonies, a friendly Fishface, and 1 charmed Bloomer for the room"
			},
			CarBattery = {
				TargetNumbers = {
					{ 2, 4 },
					{ 1, 2 }
				},
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.WNIC,
		Description = {
			Description = {
				"Tears that hit enemies are fired again, starting from where they were initially fired and following the path they took",
				"↓ x0.85 Damage"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_CRANE_GAME,
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.ZERO_POINT_REACTOR,
		Description = {
			Description = {
				"Tears fire additional orbital spectral tears upon hitting anything"
			},
			Abyss = {
				"Spawns orbital spectral tears when hitting an enemy"
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GANYMEDE,
		Description = {
			Description = {
				"Isaac fires a burst of 4 stationary tears every 5 shots",
				"If the stationary tears are near other tears, they will orbit those tears and home towards enemies",
				"Spectral tears"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_PLANETARIUM
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.HELLFIRE,
		Description = {
			Description = {
				"{{Collectible118}} On death, enemies have a 13% chance to stay alive for a second longer, then fire 4 brimstone lasers in the cardinal directions",
				"{{Luck}} 33% chance at 10 luck"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL,
					Encyclopedia.ItemPools.POOL_CURSE,
					Encyclopedia.ItemPools.POOL_ULTRA_SECRET
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.CHERUB_CHUBBY,
		Description = {
			Description = {
				"Charges forward and then sideways in the direction Isaac is shooting",
				"Deals 52.5 contact damage per second"
			},
			BFFs = {
				TargetNumbers = {
					{ 52.5, 105 }
				},
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_ANGEL,
					Encyclopedia.ItemPools.POOL_GREED_ANGEL,
					Encyclopedia.ItemPools.POOL_BABY_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.CARELESS_WHISPERS,
		Description = {
			Description = {
				"Spawns three mini Whisper familiars that orbit around Isaac when he shoots",
				"Deals 75 contact damage a second"
			},
			BFFs = {
				TargetNumbers = {
					{ 75, 150 }
				},
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_BABY_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DARK_BARGAIN,
		Description = {
			Description = {
				"↑ +1 Damage",
				"{{Coin}} Drops 4 pennies",
				"Another Dark Bargain appears at the start of each floor as a devil deal and forces Isaac to take it",
				"{{Warning}} Dark Bargain cannot kill Isaac"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.APOTHEOSIS,
		Description = {
			Description = {
				"{{SoulHeart}} +2 Soul Hearts",
				"For every {{SoulHeart}} Soul Heart,{{BlackHeart}} Black Heart, or {{ffImmoralHeart}} Immoral Heart, gain a long range orbital",
				"Blocks enemy shots",
				"The orbitals deal 30 contact damage per second"
			},
			BFFs = {
				TargetNumbers = {
					{ 30, 60 }
				},
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_ANGEL,
					Encyclopedia.ItemPools.POOL_GREED_ANGEL
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.TOYBOX,
		Description = {
			Description = {
				"{{Warning}} SINGLE USE {{Warning}}",
				"{{Trinket}} Smelts 4 random trinkets onto Isaac"
			},
			Virtues = {
				"4 wisps","20% chance to spawn Neighbours from Hell when destroyed"
			},
			CarBattery = false
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.TEFILLIN,
		Description = {
			Description = {
				"{{AngelRoom}} On pickup, guarantees an Angel Room to spawn after the next valid boss"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SUN_CROSS,
		Description = {
			Description = {
				"{{Burning}} Spawns a sun familiar at the top of every room which pulls in enemies and pickups, and applies Burning to nearby enemies"
			},
			BFFs = false
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_ANGEL
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DADS_HALF,
		Description = {
			Description = {
				"↑ 0.7 Tears",
				"{{BlackHeart}} +1 Black Heart"
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_BOSS,
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.STARDUST,
		Description = {
			Description = {
				"25% chance to fire a big star that splits into 7 miniature stars",
				"These stars rain down on enemies and deal 33% of Isaac's damage",
				"{{Luck}} 40% chance at 16 luck"
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_ANGEL,
					Encyclopedia.ItemPools.POOL_GREED_ANGEL,
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.TOWER_OF_HEAVEN,
		Description = {
			Description = {
				"One random special room on the floor gets barred off at floor start, excluding {{BossRoom}} Boss Rooms, {{TreasureRoom}} Treasure Rooms",
				"↑ +0.3 Speed",
				"↑ +0.3 Damage",
				"↑ x1.2 Tears",
				"↑ +1 Luck",
				"↑ +1 Health",
				"{{HealingRed}} Heals 1 heart",
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_CURSE,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.RED_NIGHTMARE,
		Description = {
			Description = {
				"{{UltraSecretRoom}} Adds an extra Ultra Secret Room to each floor",
				"{{Card78}} Spawns 1-3 Cracked Keys",
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_ULTRA_SECRET
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.HOT_POTATO_BOOK,
		Description = {
			Description = {
				"↑ +5% Damage permanently on use",
				"!!! Does not charge on room clear, can only be charged through batteries, items or other similar methods",
				"Increases the chance for Potato Sacks to spawn"
			},
			CarBattery = {
				TargetNumbers = {
					{ 5, 10 }
				},
			},
			Virtues = {
				"High HP wisp, that increases Damage by an additional 5% while alive"
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_LIBRARY,
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GOLDEN_WATCH,
		Description = {
			Description = {
				"{{Beggar}} Give this to beggars in exchange for their life savings",
				"{{Shop}} Once given, various shops will try to sell it back at inflated prices",
				"{{Damage}} Becomes a damage multiplier based on how many coins you spent to buy it",
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_CRANE_GAME
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DIS,
		Description = {
			Description = {
				"↑ Picking up an item grants the effect of a random item",
				"!!! Taking damage removes the oldest item effect granted by Dis"
			},
			BFFs = false
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_DEVIL,
				Encyclopedia.ItemPools.POOL_CURSE,
				Encyclopedia.ItemPools.POOL_GREED_DEVIL,
				Encyclopedia.ItemPools.POOL_GREED_CURSE,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.ACHERON,
		Description = {
			Description = {
				"{{Timer}} Killing enemies has a chance to give the effect of a random {{DevilRoom}} Devil Room item for 90 seconds",
				"Chance scales with enemy health"
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_DEVIL,
				Encyclopedia.ItemPools.POOL_GREED_DEVIL,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.ACTIVATED_CHARCOAL,
		Description = {
			Description = {
				"{{Timer}} Receive for the current room:",
				"{{Collectible149}} ↑ {{Damage}} +40 Damage",
				"↓ {{Tears}} x0.33 Fire rate multiplier",
				"↓ {{Range}} x0.8 Range multiplier",
				"↓ {{Shotspeed}} x0.8 Shot speed multiplier",
				"Isaac's tears are fired in an arc",
				"{{Poison}} The tears explode and poison enemies where they land",
			},
			CarBattery = {
				Description = {
					"↑ +1 Damage"
				}
			},
			Virtues = {
				"Slow-firing explosive wisp"
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.AIR_FRESHENER,
		Description = {
			Description = {
				"While in combat, spawns tears around you which home onto nearby enemies",
				"The tears deal 13 damage"
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
			}
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PLANET_X,
		Description = {
			Description = {
				"Orbital familiar that copies tear effects",
				"Deals x1.5 Isaac's damage on contact"
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_PLANETARIUM
			},
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GKUNHOMDIMA,
		Description = {
			Description = {
				"{{Chargeable}} Chargeable nimbus cloud that can fire alongside tears",
				"Nimbus clouds scale with tear effects and damage"
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_PLANETARIUM
			},
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.NENDOROID,
		Description = {
			Description = {
				"It's time to repent! Isaac has joined the Nendoroid line, ready to escape the terrifying clutches of his mother's wrath! Preorder now & receive an exclusive GSUS Bonus Background Sheet & The Binding of Isaac: Four Souls playing cards! Shop: https://s.goodsmile.link/jU8 #Goodsmile",
			},
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GLITCHCITY,
		Description = {
			Description = {
				"Periodically spawns \"Glitched Tiles\" while held, which destroy rocks, block projectiles and deal 60 damage to enemies",
        		"!!! While held, every minute and a half, another random held item will turn into GLITCHCITY",
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_SECRET,
				Encyclopedia.ItemPools.POOL_GREED_SECRET,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GOLDEN_SPIKES,
		Description = {
			Description = {
				"9% chance for rocks to turn into Golden Spiked Rocks upon entering the room for the first time",
                "Golden Spiked Rocks drop 1-3 coins upon being destroyed",
                "!!! Golden Spiked Rocks hurt Isaac when touched"
			},
			Abyss = {
				"10% chance to drop a penny on kill"
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_CURSE,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.FORTUNE_TELLER,
		Description = {
			Description = {
				"↑ +1 Luck up",
				"↑ +0.1 Speed up",
				"On pickup, rerolls all pedestal items on the floor",
				"{{AngelDevilChanceSmall}} Does not affect the Devil/Angel Room or {{Crawlspace}} crawlspaces"
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_BOSS,
				Encyclopedia.ItemPools.POOL_GREED_BOSS,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PLANCHETTE,
		Description = {
			Description = {
				"Grants invulnerability to Isaac for 90 seconds on pickup",
				"This carries between rooms",
				"Grants an additional 36 seconds of invulnerability on entering a new floor",
				"{{AngelDevilChance}} +10% Devil Deal Chance",
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_SHOP,
				Encyclopedia.ItemPools.POOL_GREED_SHOP,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.RESURRECTION,
		Description = {
			Description = {
				"All temporary familiars that died this floor (Blue Flies, Blue Spiders, etc.) are respawned on use", --im not sure if i like the use of the etcetera here but also listing all of the familiars would be very ugly and messy
				"Does not count familiars spawned by this item",
				"Spawns a Blue Beetle if no familiars were spawned",
			},
			CarBattery = {
				Description = {
					"Spawned temporary familiars are doubled"
				},
			},
			Virtues = {
				 "Low HP, high damage wisp"
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BURGLAR_BABY,
		Description = {
			Description = {
				"Shoots tears that inflict Mugged",
				"Deals 3.5 damage per tear"
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.MUGGED },
			BFFs = {
				TargetNumbers = {
					{ 3.5, 7.0 }
				},
			},
			Abyss = {
				"20% chance to inflict Mugged when dealing damage"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_BABY_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PAPAL_PAL,
		Description = {
			Description = {
				"Shoots tears that inflict enemies with Excommunication",
				"Deals 3.5 damage per tear"
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.EXCOMMUNICATED },
			BFFs = {
				TargetNumbers = {
					{ 3.5, 7.0 }
				},
			},
			Abyss = {
				"20% chance to inflict enemies with Excommunication"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_BABY_SHOP,
					Encyclopedia.ItemPools.POOL_ANGEL,
					Encyclopedia.ItemPools.POOL_GREED_ANGEL,
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.OUTLET_BABY,
		Description = {
			Description = {
				"Shoots tears that inflict enemies with Overloaded",
				"Deals 3.5 damage per tear"
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.OVERLOADED },
			BFFs = {
				TargetNumbers = {
					{ 3.5, 7.0 }
				},
			},
			Abyss = {
				"20% chance to inflict enemies with Overloaded"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_BABY_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.CYBORG_BABY,
		Description = {
			Description = {
				"{{Collectible"..FiendFolio.ITEM.COLLECTIBLE.WNIC.."}} Shoots tears that are fired again following the same path if they hit an enemy",
				"Deals 3.5 damage per tear"
			},
			BFFs = {
				TargetNumbers = {
					{ 3.5, 7.0 }
				},
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_BABY_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.MOTOR_SPIRIT,
		Description = {
			Description = {
				"{{Burning}} Isaac spawns fires behind him while moving#{{Burning}} Charging into enemies creates a ring of fire jets"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.NAGA_VIPER,
		Description = {
			Description = {
				"10% chance to shoot fires that explode on contact#{{Luck}} 50% chance at 8 luck#{{Warning}} The explosion can hurt Isaac"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_ANGEL,
					Encyclopedia.ItemPools.POOL_GREED_ANGEL,
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.CREATION_OF_MAN,
		Description = {
			Description = {
				"Entering {{BossRoom}} Boss Rooms spawns a unique Minisaac that blocks all incoming damage for Isaac#Damage Isaac takes is transferred to the Minisaac#Minisaacs chase and shoot at nearby enemies"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_RED_CHEST,
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GREEN_APPLE,
		Description = {
			Description = {
				"↑ +1 Health",
				"{{HealingRed}} Heals 1 heart",
				"7.5% chance to inflict enemies with Nursing upon entering rooms",
				"{{Luck}} 15% chance at 20 luck",
				"1% chance to fire tears that inflict Nursing",
				"{{Luck}} 5% chance at 20 luck",
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.NURSING },
			Abyss = {
				"10% chance to inflict enemies with Nursing"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.ETERNAL_PENDANT,
		Description = {
			Description = {
				"{{EternalHeart}} +1 Eternal Heart",
				"Gives an Eternal Heart at the start of each floor",
				"{{ffShieldHeart}} Eternal Hearts also give a 3 hit shield heart when completed",
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BABY_BELL,
		Description = {
			Description = {
				"Orbital that rings for a period when hit by enemies",
				"While ringing, fears nearby enemies and pushes enemies and bullets away"
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
				Encyclopedia.ItemPools.POOL_BABY_SHOP,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BLACK_CANDELABRA,
		Description = {
			Description = {
				"↑ +1.6 Damage",
				"Clears all natural curses",
				"!!! Every quarter of the floor's rooms cleared, one flame goes out, lowering the damage bonus",
				"The first flame reveals the Boss, the second reveals the Treasure Room, and the third adds 2 random curses"
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_CURSE,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.TECH_MODULO,
		Description = {
			Description = {
				"↓ 0.66x Damage",
				"Whenever you fire tears, fire a screen-wide laser perpendicular to your tears wherever it would land"
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.FRUIT_MILK,
		Description = {
			Description = {
				"↓ x0.2 Damage multiplier",
				"Each of Isaac's tears have 3 different random effects"
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_GREED_SECRET,
				Encyclopedia.ItemPools.POOL_SECRET,
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DEVILSKNIFE,
		Description = {
			Description = {
				"Orbital",
				"Blocks enemy shots",
				"!!! Moves back and forth from Isaac",
				"Deals 225 contact damage per second",
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_CURSE,
				Encyclopedia.ItemPools.POOL_GREED_CURSE,
				Encyclopedia.ItemPools.POOL_DEVIL,
				Encyclopedia.ItemPools.POOL_GREED_DEVIL,
				Encyclopedia.ItemPools.POOL_BABY_SHOP,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.EDENS_HEAD,
		Description = {
			Description = {
				"Uses a random throwable active item on use"
			},
		Virtues = {
			"Spawns the wisps of the used item"
		}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.YAAI,
		Description = {
			Description = {
				"Every 3rd tear fired splits into 6 half damage tears upon hitting anything"
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SOLAR_TABLET,
		Description = {
			Description = {
				"{{Timer}} For the current room:",
				"{{Burning}} Spawns a sun familiar at the top of the room which pulls in enemies and pickups, and applies Burning to nearby enemies"
			},
			Virtues = {
				"Wisp that burns nearby enemies"
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BRILLIANCE,
		Description = {
			StatusEffects = { FiendFolio.DescriptionStatuses.GLEAMING },
			Description = {
				"{{ffGleaming}} 10% chance to shoot tears which inflict Gleaming",
				"Gleaming auras can inflict Fear, Charm, Slowness, or Bruised",
				"{{Luck}} 50% chance at 20 luck"
			},
			Abyss = {
				"20% chance to inflict either Fear, Charm, or Slowness"
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_SECRET,
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.RADIANCE,
		Description = {
			StatusEffects = { FiendFolio.DescriptionStatuses.GLEAMING },
			Description = {
				"{{ffGleaming}} 10% chance to shoot tears which inflict Gleaming",
				"Gleaming auras inflict Burning",
				"{{Luck}} 50% chance at 20 luck"
			},
			Abyss = {
				"20% chance to inflict Burning"
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DARKNESS,
		Description = {
			Description = {
				"While firing tears, your tears become temporarily intangible, unable to hit any enemies",
				"Enemies take damage over time while you are firing tears",
				"↑ +0.3 Damage",
				"↑ +0.1 Shot speed"
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_DEVIL,
				Encyclopedia.ItemPools.POOL_GREED_DEVIL,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BOTTLE_CAP,
		Description = {
			Description = {
				"{{ffCursedPenny}} Spawns a Cursed Penny on use"
			},
			Virtues = {
				"80% chance to spawn a {{ffCursedPenny}} cursed penny when destroyed",
				"2.5% chance to fire exploding tears"
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_SHOP,
				Encyclopedia.ItemPools.POOL_GREED_SHOP,
				Encyclopedia.ItemPools.POOL_CURSE,
				Encyclopedia.ItemPools.POOL_GREED_CURSE,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.OLD_TESTAMENT,
		Description = {
			Description = {
				"{{Battery}} Upon use, your held active items are replaced with another random active item for the rest of the floor",
				"Swapping out this item while its effect is active will still have your active replaced",
				"Does not affect pocket active items"
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_LIBRARY,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.CROSS_NECKLACE,
		Description = {
			Description = {
				"Enemies with a low amount of max health instantly die",
				"Max health threshold scales with the stage Isaac is in",
				"↑ +1 Luck"
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.MARK_OF_PAIN,
		Description = {
			Description = {
				"Every second in combat:",
				"↑ +0.1 Damage",
				"↓ -0.04 Speed",
				"Resets outside of combat",
				"This item will not set your Speed below 0.6",
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_DEVIL,
				Encyclopedia.ItemPools.POOL_GREED_DEVIL,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BOOK_OF_LEVIATHAN,
		Description = {
			Description = {
				"{{CurseBlind}} Cannot be charged on floors without curses",
				"{{BlackHeart}} +1 Black Heart",
				"↓ x0.8 Tears if not used this floor",
				"↓ -0.2 Speed if not used this floor",
			},
			Virtues = {
				"Passively applies bruise to random enemies while alive"
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_CURSE,
				Encyclopedia.ItemPools.POOL_GREED_CURSE,
				Encyclopedia.ItemPools.POOL_LIBRARY,
				Encyclopedia.ItemPools.POOL_DEVIL,
				Encyclopedia.ItemPools.POOL_GREED_DEVIL,
			}
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SCOUTS_BADGE,
		Description = {
			Description = {
				"↑ +0.1 Damage, aswell as +0.3 Damage for every {{SecretRoom}} Secret Room found on this floor",
				"{{SecretRoom}} Reveals and opens all Secret Rooms on this floor"
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_BOSS,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.MOMS_PENDANT,
		Description = {
			Description = {
				"↑ +1 Damage",
				"{{BlackHeart}} +1 Black Heart",
				"!!! Guarantees a curse on the next floor"
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_BOSS,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BLASTULATION,
		Description = {
			Description = {
				"↑ +0.1 Damage for every friendly Embryo",
				"{{Charm}} Chance to spawn a random friendly Embryo variant when killing an enemy",
				"Guaranteed when killing a boss",
				"Chance scales with luck",
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_SECRET,
				Encyclopedia.ItemPools.POOL_TREASURE,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.THE_PYX,
		Description = {
			Description = {
				"Inflicts Excommunicated on all enemies but the one with the highest health",
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.EXCOMMUNICATED },
			CarBattery = {
				Description = {
					"Excommunicated timer is doubled"
				},
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.HOLY_BEAN,
		Description = {
			Description = {
				"Inflicts Excommunicated to enemies in range",
			},
			Virtues = {
				"Excommunicating fart when destroyed"
			},
			VirtuesSingleRoom = true,
			StatusEffects = { FiendFolio.DescriptionStatuses.EXCOMMUNICATED },
			CarBattery = {
				Description = {
					"Excommunicated timer is doubled"
				},
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.APPENDIX,
		Description = {
			Description = {
				"+2 Leaky Hearts",
				"Leaky hearts slowly drain, leaving red creep on the floor",
				"{{AngelDevilChance}} Damage taken to draining hearts doesn't affect Devil Deal chance",
			}, -- needs different descriptions for soul heart characters, and eid icon
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_BOSS,
				Encyclopedia.ItemPools.POOL_GREED_BOSS,
				Encyclopedia.ItemPools.POOL_SECRET,
				Encyclopedia.ItemPools.POOL_GREED_SECRET,
				Encyclopedia.ItemPools.POOL_LIBRARY,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.CAN_OF_BEANS,
		Description = {
			Description = {
				"↑ +1 Damage",
				"↑ x1.35 Damage multiplier",
				"↓ x0.5 Fire rate multiplier",
				"↓ x0.8 Range multiplier",
				"Isaac's tears fly into an arc and explode into a fart",
				"Holding different beans give different fart effects"
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BLACK_EYED_PEA,
		Description = {
			Description = {
				"Inflicts 3 stacks of Bruised to enemies in range",
			},
			Virtues = {
				"Bruising fart when destroyed"
			},
			VirtuesSingleRoom = true,
			StatusEffects = { FiendFolio.DescriptionStatuses.BRUISE },
			CarBattery = {
				PartialReplace = {
					[" 3 "] = " 5 ",
				},
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.ECHOLILAC,
		Description = {
			StatusEffects = { mod.DescriptionStatuses.PACIFIED },
			Description = {
				"Pacifies all enemies of a random type in the room for 6 seconds",
			},
			Abyss = {
				"10% chance to inflict Pacified"
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PARALLEL_BOMBS,
		Description = {
			Description = {
				"{{Bomb}} +5 Bombs",
				"Bombs are placed alongside an intangible copy that mirrors the original's position",
				"The mirrored bombs do 50% the damage of the original bomb",
			},
			AbyssSpecial = {
				"1 white locust (0.5x Isaac's damage)",
				"{{Collectible706}} {{ColorRed}}1 black locust (1x Isaac's damage)",
			},
			Abyss = {
				"Spawns two locusts that are mirrored"
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_SECRET,
				Encyclopedia.ItemPools.POOL_GREED_SECRET,
				Encyclopedia.ItemPools.POOL_BOMB_BUM
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SNOOZE_BUTTON,
		Description = {
			Description = {
				"Clears the room of all obstacles, pick-ups, and enemies",
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.STAR_TREAT,
		Description = {
			Description = {
				"↑ +0.1 Speed",
				"↑ +1 Health",
				"{{HealingRed}} Heals 1 heart",
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_BOSS,
				Encyclopedia.ItemPools.POOL_GREED_BOSS,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.EARTH_OF_ADAM,
		Description = {
			Description = {
				"{{Warning}} SINGLE USE {{Warning}}",
				"Gives you two copies of a random familiar you own",
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.LASER_POINTER,
		Description = {
			Description = {
				"When held up, Isaac can aim a laser at a specific point",
				"The laser stays aimed at its last point after putting the item away",
				"The laser's damage scales with Isaac's damage",
				"Nearby enemies target the laser when Isaac is moving it",
			},
			Virtues = {
				"3 wisps surround the laser"
			},
			Abyss = {
				"Electricity on hit"
			},
			Belial = {
				"↑ +0.6 Damage per enemy hit with the laser"
			},
			CarBattery = {
				Description = {
					"The laser's damage is increased"
				},
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_CRANE_GAME,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BOUNCING_BALL_2,
		Description = {
			Description = {
				"{{SoulHeart}} +1 Soul Heart",
				"{{SoulHeart}} If It's Tuesday, +3 Soul Hearts",
				"↑ +0.3 Damage Or ↓ -0.5 Range At Random",
				"↑ +3 Damage On Corpse I, Ashpit II, And Knife Piece 2 Chase Sequence",
				"↑ +0.66 Tears If The Filter Is On",
				"Balls Will Burst From Enemies Upon Defeat, Which Will Bounce Up And Down",
				"The Balls Have No Effect Towards Anything",
				"+20% Planetarium Chance If You Press G",
				"{{Pill}} Bosses On Scarred Womb II Can Only Die If You Use 10 Pills That Floor, But Pills Will Spawn Very Constantly During That Floor",
				"{{Damage}} Quest Items Cannot Be Picked Up +7 Damage When Trying To Pick One Up",
				"{{Bomb}} Gulps One Of Your Bombs",
				"{{Warning}} Its An Item Now",
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
				Encyclopedia.ItemPools.POOL_DEVIL,
				Encyclopedia.ItemPools.POOL_SUPER_SECRET,
				Encyclopedia.ItemPools.POOL_WOODEN_CHEST,
				Encyclopedia.ItemPools.POOL_GREEN_SILVER_TREASURE,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PLATINUM_CREST,
		Description = {
			Description = {
				"↑ +0.025 Damage upon clearing an active room",

			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.ANARCHISTS_EASY_BAKE,
		Description = {
			Description = {
				"Spawns a Troll Bomb in a random position of the room",
			},
			CarBattery = {
				PartialReplace = {
					[" a "] = " 2 ",
					["Troll Bomb"] = "{{CR}}Troll Bombs"
				},
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_CRANE_GAME,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SOAPSUDS,
		Description = {
			Description = {
				"Isaac fires soapsud tears that turn champion enemies into non-champions, dropping their champion loot",
			},
			Abyss = {
				"40% chance to turn champion enemies into non-champions, dropping their champion loot"
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.CRY_BABY,
		Description = {
			StatusEffects = { mod.DescriptionStatuses.PACIFIED },
			Description = {
				"Throws a tantrum after absorbing 10 enemy tears",
				"While throwing a tantrum, deflects enemy tears, pushes enemies away, and inflicts Pacified to nearby enemies",
			},
			Abyss = {
				"10% chance to inflict Pacified"
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_BABY_SHOP
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.ERASER_TWO,
		Description = {
			Description = {
				"Isaac's tears turn into erasers that instantly kill enemies",
				"Erased enemies are prevented from spawning during the rest of the run",
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PARANOIA,
		Description = {
			Description = {
				"20% chance to fire a tear that releases a ring of piercing, reflecting tears on hit",
				"{{Luck}} 100% chance at 8 luck",
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_DEVIL,
				Encyclopedia.ItemPools.POOL_GREED_DEVIL,
				Encyclopedia.ItemPools.POOL_ULTRA_SECRET
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PHOENIX_ELIXIR,
		Description = {
			Description = {
				"{{EmptyHeart}} +1 Empty heart container",
				"{{Collectible289}} On death, Isaac respawns, explodes, burns nearby enemies and releases a ring of fires",
				"{{Heart}} Once revived, heals half a heart once per room if below 2 red hearts",
				"{{Burning}} Once revived, +1 Damage and burning tears when on 1 red heart or less",
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
				Encyclopedia.ItemPools.POOL_ULTRA_SECRET
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BEREAVEMENT,
		Description = {
			Description = {
				"Tears cycle between multiple tear effects",
				"29% chance for tears to inflict status effects",
				"{{Luck}} 100% chance at 7 luck",
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_SECRET,
				Encyclopedia.ItemPools.POOL_GREED_SECRET
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SERTRALINE,
		Description = {
			Description = {
				"On use, destroys all enemy tears and briefly prevents new ones from spawning",
			},
			CarBattery = {
				Description = {
					"{{Timer}} Time in which enemy tears are destroyed lasts longer"
				},
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_SHOP,
				Encyclopedia.ItemPools.POOL_GREED_SHOP
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.ISOLATED,
		Description = {
			Description = {
				"Orbital familiar that blocks projectiles",
				"{{Freezing}} Fires ice tears that deal 3.5 damage in cardinal directions away from the player",
				"On fire, aligns itself to cardinal directions in orbit",
				"Increases orbit distance of all orbitals",
			},
			BFFs = {
				TargetNumbers = {
					{ 3.5, 7 }
				},
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_BABY_SHOP
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.ACUPUNCTURE_NEEDLES,
		Description = {
			Description = {
				"33% chance to fire 3 tears in a very tight spread",
				"Each tear does 65% of Isaac's damage",
				"{{Luck}} 100% chance at 10 luck",
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BOUNDLESS_PARASOL,
		Description = {
			Description = {
				"Spawns doors in cleared rooms that connect rooms by skipping over gaps in the map",
				"Reveals connected rooms on the map",
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_SHOP,
				Encyclopedia.ItemPools.POOL_SECRET,
				Encyclopedia.ItemPools.POOL_ULTRA_SECRET
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.HYPERFIXATION,
		Description = {
			Description = {
				"Attacking enemies indicated by the mark above them redirects all player and enemy tears in the room towards them",
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.HARE_TRIGGER,
		Description = {
			Description = {
				"Seeks out nearby enemies, and rapidly shoots tears at them",
				"Deals 0.66 damage per tear",
			},
			BFFs = {
				TargetNumbers = {
					{ 0.66, 1.32 }
				},
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_BABY_SHOP
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.REPRESSION,
		Description = {
			Description = {
				"Orbital familiar that blocks projectiles",
				"Fires lasers that deal 3.5 damage",
				"33% chance to charge up a thick laser on blocking projectiles",
			},
			BFFs = {
				TargetNumbers = {
					{ 3.5, 7 }
				},
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DUMB_BUNNY,
		Description = {
			Description = {
				"Shoots spectral tears backwards while moving",
				"Deals 2 damage per tear",
			},
			BFFs = {
				TargetNumbers = {
					{ 2, 4 }
				},
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_CRANE_GAME,
				Encyclopedia.ItemPools.POOL_BABY_SHOP
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.RABBITS_FOOT,
		Description = {
			Description = {
				"↑ +1 Luck",
				"{{Luck}} Increases Luck to 4 on first pickup",
				"If Luck is greater than 0 upon taking fatal damage, lose 4 Luck to destroy all enemy tears, briefly prevent new ones from spawning, and allow Isaac to continue to fight with half a heart",
				"Restore lost Luck by 1 each room",
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_ANGEL
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GREEN_BOMBS,
		Description = {
			Description = {
				"{{Bomb}} +5 Bombs",
				"Isaac's bombs explode faster",
				"Bombs placed by Isaac no longer damage him",
				"Bombs destroy all enemy tears and briefly prevent new ones from spawning when they explode",
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_BOMB_BUM
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.CRUSHING_ANXIETY,
		Description = {
			Description = {
				"10% chance on fire to drop a boulder on the closest enemy aligned with the shooting direction",
				"{{Luck}} 20% chance at 15 luck",
				"Deals damage that scales with Isaac's damage in a radius upon impact",
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.OCULAR_SPECTRUM,
		Description = {
			Description = {
				"While held, grants a satellite familiar",
				"Satellites scale with tear effects and damage",
				"On use, spins satellites around Isaac, spraying tears outwards",
			},
			BFFs = {
				Description = {
					"Tear damage doubled"
				}
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_ULTRA_SECRET
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DADS_SHORTS,
		Description = {
			Description = {
				"↑ +0.2 Speed",
				"{{Key}} Spawns a key",
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_BOSS,
				Encyclopedia.ItemPools.POOL_GREED_BOSS,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SHADOW_RABBITS,
		Description = {
			Description = {
				"placeholder",
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.EXTENSION,
		Description = {
			Description = {
				"Gives Isaac the effect of a random 100% Orange Juice card",
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.TECH_ULTIMA,
		Description = {
			Description = {
				"placeholder",
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DAUNTING_DOG,
		Description = {
			Description = {
				"↑ +1 Damage",
				"Does 5 damage per tear",
				"{{BossRoom}}{{MiniBoss}} Gained by picking up an item in the Boss Room or Mini-Boss Room",
				"{{ffBruise}} Tears inflict enemies with Bruised"
			},
			BFFs = {
				TargetNumbers = {
					{ 5, 10 }
				},
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.BRUISE},
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DEWEY_DECIMAL_DOG,
		Description = {
			Description = {
				"↑ +0.5 Fire rate",
				"Does 3.5 damage per tear",
				"{{Library}} Gained by picking up an item in a Library",
				"25% chance to fire 2 tears at once",
				"Tears turn 90 degrees to target enemies that they have missed"
			},
			BFFs = {
				TargetNumbers = {
					{ 3.5, 7 }
				},
			},
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DWARF_DOG,
		Description = {
			Description = {
				"↑ +1 Luck",
				"Does 3 damage per tear",
				"{{Planetarium}} Gained by picking up an item in a Planetarium",
				"The dog's tears orbit around it while shooting"
			},
			BFFs = {
				TargetNumbers = {
					{ 3, 6 }
				},
			},
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.ONION_DISC,
		Description = {
			Description = {
				"↑ +0.1 Tears",
				"{{Timer}} Killing enemies has a 10% chance to give the effect of a random Onion item for 30 seconds",
				"{{Luck}} 100% chance at 45 luck"
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_SECRET,
				Encyclopedia.ItemPools.POOL_GREED_SECRET
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.THE_HAPPY_GO_LUCKY_ONION,
		Description = {
			Description = {
				"↑ +0.15 Speed",
				"↑ +0.15 Shot speed",
				"↑ +1.5 Luck",
				"{{Collectible1}} 3% chance to reroll item pedestals into Onion items when entering a room"
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_SECRET,
				Encyclopedia.ItemPools.POOL_GREED_SECRET
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.MAGIC_BULLET,
		Description = {
			Description = {
				"After every 7th tear fired, an explosive bullet can fire from either the left or right of the screen",
				"The bullet scales with Isaac's damage, and fires from the side of the screen furthest from Isaac",
				"{{Warning}} The bullet can collide with and damage Isaac",
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_DEVIL,
				Encyclopedia.ItemPools.POOL_GREED_DEVIL
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BAD_DATA,
		Description = {
			Description = {
				"Familiar that teleports and glitches around the room",
				"When the familiar bumps into enemies, it does a random amount of damage and applies a random status effect"
			},
			BFFs = {
				Description = {
					"Damage doubled"
				}
			}
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_SECRET,
				Encyclopedia.ItemPools.POOL_GREED_SECRET,
				Encyclopedia.ItemPools.POOL_BABY_SHOP,
				Encyclopedia.ItemPools.POOL_ULTRA_SECRET,
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.LIL_INABA,
		Description = {
			Description = {
				"Shoots tears from eye satellites that deal 1.25 damage",
				"Levels up from Anxiety Residue orbs that appear when killing enemies",
				"Leveling up grants the familiar more eye satellites"
			},
			BFFs = {
				TargetNumbers = {
					{ 1.25, 2.5 }
				},
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_DEVIL,
				Encyclopedia.ItemPools.POOL_GREED_DEVIL,
				Encyclopedia.ItemPools.POOL_DEMON_BEGGAR,
				Encyclopedia.ItemPools.POOL_BABY_SHOP
			}
		},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.CACEPI,
		Description = {
			Description = {
				"↑ +40 Damage",
				"↓ x0.33 Fire rate multiplier",
				"↓ x0.8 Range multiplier",
				"↓ x0.8 Shot speed multiplier",
				"Isaac's tears are fired underground and into a lobbed angle",
				"The tears explode and poison enemies where they land",
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GREEN_LEAF,
		Description = {
			Description = {
				"Image's special little item",
				"Please take good care of it",
				"Good luck in this challenge",
				"{{Heart}} I love you",
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SHADOW_RABBITS,
		Description = {
			Description = {
				"Spawns 6 rabbit familiars that seek out enemies and attack, scaling with Isaac's damage",
				"Isaac can possess large rabbits to control them and boost their damage",
				"While the rabbits are active, Isaac cannot shoot and is intangible",
				"Lasts for around 45 seconds or 4 uncleared rooms",
				"33% chance to passively spawn a small rabbit familiar each room"
			},
			CarBattery = {
				Description = {
					"Doubles the amount of large rabbits"
				},
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL,
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GUNSLINGERS_GRIT,
		Description = {
			Description = {
				"{{Burning}} Creates a ring of fire that blocks projectiles, deals damage, and inflicts Burning on enemies",
				"↑ Fading +7 Tears up",
			},
			PlayerSpecificDescription = {
				Players = { mod.PLAYER.BRIEND, },
				Description = {
					"Tainted Friend swaps her guns",
					"{{Burning}} Creates a ring of fire that blocks projectiles, deals damage, and inflicts Burning on enemies",
					"↑ Fading +7 Tears up",
					"{{HalfHeart}} {{HalfSoulHeart}} Chance for enemies to drop half red and soul hearts when under the Tears up boost and when killed by the ring of fire",
				},
			},
			CarBattery = {
				Description = {
					"Increases the range of the ring of fire"
				},
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.STEVEN_SANDWICH,
		Description = {
			Description = {
				"{{Heart}} +1 Health",
				"{{HealingRed}} Heals 1 heart",
				"{{ffStevenHeart}} +3 Steven Hearts",
				"Steven hearts go over other hearts and shoot at enemies from the HUD",
			},
			Abyss = {
				"Locust will travel through one side of the screen and come out the other side"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET,
					Encyclopedia.ItemPools.POOL_CRANE_GAME,
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.YCUK_HEART,
		Description = {
			Description = {
				"{{ffStevenHeart}} +1 Steven Heart",
				"Steven hearts go over other hearts and shoot at enemies from the HUD",
			},
			Abyss = {
				"Locust will travel through one side of the screen and come out the other side"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET,
					Encyclopedia.ItemPools.POOL_CRANE_GAME,
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DEAL_OF_THE_DEMONS,
		Description = {
			Description = {
				"↑ +0.5 Damage",
				"↑ +1.5 Shot speed",
				"Weak homing",
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET,
					Encyclopedia.ItemPools.POOL_CRANE_GAME,
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SOUL_EXTRACTION_BUM,
		Description = {
			Description = {
				"Goes to nearby enemies and extracts their souls",
				"{{Slow}} Enemies that have their soul extracted are affected with Slowness",
				"Summons a variety of effects every 3-5 souls extracted",
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_DEMON_BEGGAR,
					Encyclopedia.ItemPools.POOL_BABY_SHOP,
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.MYSTERIOUS_FEDORA,
		Description = {
			Description = {
				"20% chance for a mysterious stranger to appear in a room",
				"The stranger fires 6 shots from a gun that do 20 damage",
				"When they disappear, they leave behind either a bomb, key or coin",
				"The stranger gives you the consumable you have less of"
			},
			BFFs = {
				Description = {
					"Gun deals double damage"
				},
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_SECRET,
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.BAPHOMETS_EXCHANGE,
		Description = {
			Description = {
				"{{Coin}} Spend 5 coins to get a random stat milk",
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SKIBIDI_BABY,
		Description = {
			Description = {
				"{{Collectible291}} 10% chance to use Flush! when it is hit by an enemy tear",
			},
		},
		Encyclopedia = Encyclopedia and {
			Pools = {
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_BABY_SHOP
			}
		}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.COOL_SKULL_INSIGNIA,
		Description = {
			Description = {
				"↑ +0.02 Speed"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.GOLEMS_WISHLIST,
		Description = {
			Description = {
				"{{Warning}} SINGLE USE {{Warning}}",
				"{{Heart}} Used to write a letter to Santa",
				"When Isaac finishes writing his letter, three Golem rocks spawn"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SWORD_OF_FRACTURED_MODS,
		Description = {
			Description = {
				"{{Warning}} Prevents all modded code from running {{Warning}}",
				"Requires a full game restart to fix",
				"↑ +0.3 Damage",
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.LANKY_MUSHROOM,
		Description = {
			Description = {
        		"↑ +0.7 Damage",
				"↓ -0.4 Tears",
				"↑ +0.75 Range ",
				"Makes Isaac 50% taller and 25% thinner",
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET,
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.MINESWEEPER,
		Description = {
			Description = {
				"↑ +0.01 Damage for the room when walking onto a new tile",
        		"16% chance to spawn a Troll Bomb when walking onto a new tile",
				"Will not spawn Troll Bombs or give Damage ups on tiles that have been walked on already",
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.DSTOCK,
		Description = {
			Description = {
        		"{{Shop}} Restocks the current shop if used inside a shop",
				"Will also restock {{DevilRoom}} Devil Deals and {{Collectible586}} Stairway shops"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP,
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET,
				}
			}

	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.ICE_IX,
		Description = {
			Description = {
        		"{{Chargeable}} Firing charges a radial burst that freezes enemies and destroys projectiles",
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET,
				}
			}

	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.STEVENS_HAT,
		Description = {
			Description = {
        		"Pickups, slot machines, and enemies have a chance to spawn with a Steven Hat on them",
				"These hats shoot at nearby enemies with homing tears"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_SECRET,
					Encyclopedia.ItemPools.POOL_GREED_SECRET,
					Encyclopedia.ItemPools.POOL_CRANE_GAME,
					Encyclopedia.ItemPools.POOL_WOODEN_CHEST,
				}
			}

	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.SEVEN_SEALS_2,
		Description = {
			Description = {
        		"Spawns a small modern horseman familiar that spawns fleas",
        		"The horseman and its flea changes every 10 seconds",
			},
			BFFs = {
				Description = {
					"Horseman contact damage is doubled",
				},
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL,
					Encyclopedia.ItemPools.POOL_ANGEL,
					Encyclopedia.ItemPools.POOL_GREED_ANGEL,

				}
			}

	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.CLOWN_HORN,
		Description = {
			Description = {
        		"{{Card1}} Teleports Isaac to the first room of the floor",
			},
			CarBattery = false
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP,

				}
			}

	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PALINSOPIA,
		Description = {
			Description = {
        		"↑ +0.3 Damage",
				"↓ -0.3 Tears",
				"Tears leave behind a trail that damages all enemies nearby"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				}
			}

	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.COPPER_WRENCH,
		Description = {
			Description = {
				"{{ffCopperBomb}} Spawns 3 Copper Bombs and makes them 20% more common",
				"{{ffCopperBomb}} Copper Bomb duds become {{Collectible629}} Copper Bot Flies that shoot shielded tears at enemy projectiles",
				"{{Collectible629}} Copper Bot Flies will prime after 60 seconds,",
				"{{Collectible313}} allowing them to prevent one hit before exploding",
				"{{Warning}} Primed Bot Flies may eventually break",
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP,
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.KALUS_EYE,
		Description = {
			Description = {
        		"↑ +0.2 Tears",
				"{{ffAfterImage}} 15% chance to fire a tear that makes enemies leave afterimages",
				"{{Luck}} 50% chance at 17 Luck",
				"Enemy afterimages can be attacked to damage the enemy",
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_CURSE,
					Encyclopedia.ItemPools.POOL_GREED_CURSE,
				}
			},
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.LIL_GOLEM,
		Description = {
			Description = {
				"{{Trinket}} Spawns a Golem trinket",
				"Picks up and holds a single trinket, granting its effect at double power",
				"Drops its held trinket when bombed",
				"{{Warning}} Ignores trinkets with fancy modifiers"
			},
			BFFs = {
				Description = {
					"Trinket effect is tripled",
				},
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_BABY_SHOP
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.FIND_IT,
		Description = {
			Description = {
				"{{ffObject}} Spawns 1 object"
			},
			CarBattery = {
				PartialReplace = {
					[" a "] = " 2 ",
					["object"] = "{{CR}}objects"
				},
				TargetNumbers = {
					{ 1, 2 }
				},
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP,
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.KALUS_HARVESTED_NOSE,
		Description = {
			Description = {
				"↑ +1 Luck",
				"↑ Opening a chest gives +0.1 Luck"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL,
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.KALUS_WICKED_PAW,
		Description = {
			Description = {
				"{{ffMorbidHeart}} Turns two full red hearts into one full morbid heart"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL,
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.KALUS_HEART,
		Description = {
			Description = {
				"↑ +1 Health",
				"{{RottenHeart}} +1 Rotten Heart",
				"{{Poison}} For every Rotten Heart you have, gain a 17% chance to shoot poison tears",
				"{{RottenHeart}} 12% chance to replace Red Hearts with Rotten Hearts"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL,
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.KALUS_TAIL,
		Description = {
			Description = {
				"Spawns a familiar that orbits the center of the room",
				"Enemies near this familiar will target it and take damage over time",
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL,
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.PENNY_ALBUM,
		Description = {
			Description = {
				"Any penny trinkets Isaac picks up will be stored",
				"{{Trinket}} Increases the spawn rate of penny trinkets",
				"{{ffPennyPress}} Spawns a Penny Press at the start of every floor",
				"Using the item drops all penny trinkets",
			},
			CarBattery = {
				Description = {
					"Stored penny trinkets have their trinket power doubled"
				},
			},
			Virtues = {
				"{{Coin}} 15% chance to spawn wisps when picking up coins"
			},
			Belial = {
				"{{Damage}} Picking up a coin gives a flat +0.3 fading Damage for the next 30 seconds"
			},
			Abyss = {
				"10% chance to drop a penny on kill"
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SHOP,
					Encyclopedia.ItemPools.POOL_GREED_SHOP,
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.ROLANDS_BAD_END_MEAL,
		Description = {
			Description = {
				"{{EmptyHeart}} +1 Empty heart container",
				"Deals fake damage to Isaac 9 times on pickup",
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL,
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.KNIFE_BLOCK,
		Description = {
			Description = {
				"{{Collectible114}} Upon use, Isaac's next shot is replaced by 3 Mom's Knife projectiles",
			},
			CarBattery = {
				PartialReplace = {
					[" 3 "] = " 5 ",
				},
			},
			Abyss = {
				"Knife spinning around locust when its attacking"
			},
			Virtues = {
				"Red wisp with lower health"
			},
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_TREASURE,
					Encyclopedia.ItemPools.POOL_GREED_TREASURE,
					Encyclopedia.ItemPools.POOL_DEVIL,
					Encyclopedia.ItemPools.POOL_GREED_DEVIL,
					Encyclopedia.ItemPools.POOL_WOODEN_CHEST,
				}
			}
	},
	{
		ID = FiendFolio.ITEM.COLLECTIBLE.INFESTATION_0,
		Description = {
			Description = {
				"10% chance to fire an aberrated tear which teleports enemies into the previous room",
				"Spawns a mini Level 0 Fly whenever an enemy is teleported",
				"{{Collectible285}} The mini Level 0 Fly devolves enemies it touches",
			}
		},
		Encyclopedia = Encyclopedia and
			{
				Pools = {
					Encyclopedia.ItemPools.POOL_SECRET,
				}
			}
	},
}

local itemConfig = Isaac.GetItemConfig()
local function getEidDesc(itemEntry)
	local name = itemConfig:GetCollectible(itemEntry.ID)
	local desc = table.concat(itemEntry.Description.Description, "#")
	desc = desc:gsub("%b{} ", "")
	return Encyclopedia.EIDtoWiki(desc, name.Name)
end

-- Encyclopedia support (i dont think anyone uses this mod anymore but it would be silly to drop support at this point)
if Encyclopedia then
	for _, itemEntry in ipairs(FiendFolio.ExternalDescriptions.Collectibles) do
		if itemEntry.Encyclopedia then
			Encyclopedia.AddItem({
				Class = "Fiend Folio",
				ID = itemEntry.ID,
				WikiDesc = getEidDesc(itemEntry),
				Pools = itemEntry.Encyclopedia.Pools,
				UnlockFunc = function(self)
					if FiendFolio.IsCollectibleLocked(itemEntry.ID) then
						self.Desc = "Locked!"
						return self
					end
				end,
				Hide = itemEntry.Encyclopedia.Hide,
				ModName = "Fiend Folio",
			})
		end
	end
end
