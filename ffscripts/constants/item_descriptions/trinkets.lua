local mod = FiendFolio

FiendFolio.ExternalDescriptions.Trinkets = {
	{
		ID = FiendFolio.ITEM.TRINKET.SHARD_OF_CHINA,
		Description = {
			Description = {
				"Overhealing charges a secondary health bar",
				"{{Damage}} Filling this health bar accumulates a damage boost up to +1.5 Damage for each heart filled",
				"Auto-smelts once the bar is completely filled",
				"This health bar can be viewed by viewing the map"
			},
			Golden = {
				TargetMultipliers = {
					1.5,
				}
			}
		},
	},
	{
		ID = FiendFolio.ITEM.TRINKET.BIFURCATED_STARS,
		Description = {
			Description = {
				"Reveals the {{BossRoom}} Boss Room on the map",
				"The Boss Room exit door is replaced with a door to the {{TreasureRoom}} Treasure Room or {{Planetarium}} Planetarium after the room is cleared"
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.FORTUNE_WORM,
		Description = {
			Description = {
				"↑ +0.2 Shot speed",
				"↑ +2 Luck",
				"1% chance to fire a fortune worm tear that does x1.05 damage",
				"{{Luck}} 33% chance at 18 luck"
			},
			Golden = {
				TargetMultipliers = {
					0.2,
					2,
					1,
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.FOOLS_GOLD,
		Description = {
			Description = {
				"{{ffCursedPenny}} 7% chance for Cursed Pennies to drop on room clear",
				"{{Luck}} 100% chance at 14 luck"
			},
			PlayerSpecificDescription = {
				Players = { mod.PLAYER.GOLEM, mod.PLAYER.BOLEM },
				Description = {
					"{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
					"{{ffCursedPenny}} 7% chance for Cursed Pennies to drop on room clear",
					"{{Luck}} 100% chance at 14 luck"
				},
			},
			Golden = {
				TargetMultipliers = {
					7
				},
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.EXTRA_VESSEL,
		Description = {
			Description = {
				"{{EmptyHeart}} Stores an extra heart",
				"{{DevilChance}} Does not count against Devil Deal chance"
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.HALF_VESSEL,
		Description = {
			Description = {
				"{{HalfHeart}} Stores an extra heart",
				"{{DevilChance}} Does not count against Devil Deal chance"
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.FULL_VESSEL,
		Description = {
			Description = {
				"{{Heart}} Stores an extra heart",
				"{{DevilChance}} Does not count against Devil Deal chance"
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.CHILI_POWDER,
		Description = {
			Description = {
				"{{ffSpicyKey}} Key pickups are turned into spicy keys",
				"{{Warning}} Spicy keys are doubled, but damage Isaac"
			},
			Golden = {
				FullReplace = {
					"{{ffSpicyKey}} Key pickups are turned into spicy keys#{{ColorGold}}{{Warning}} Spicy Keys transform into Super Spicy Keys which give three keys, but damage Isaac for a full heart#{{ColorGold}}{{ffSpicyKey}} Super Spicy Keys transform into Quadruple Super Spicy Keys",
				},
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.GMO_PENNY,
		Description = {
			Description = {
				"Picking up a coin has a 5% chance to consume a pill",
				"{{Luck}} 100% chance at 95 luck"
			},
			Golden = {
				TargetMultipliers = {
					5,
				},
				TargetStrings = {
					"a pill",
					"2 pills",
					"3 pills",
					"4 pills",
				},
			},
		},
	},
	{
		ID = FiendFolio.ITEM.TRINKET.MOLTEN_PENNY,
		Description = {
			Description = {
				"Picking up a coin has a 2% chance to smelt a trinket",
				"{{Luck}} 100% chance at 196 luck"
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.BLOODY_SANDPAPER,
		Description = {
			Description = {
				"Isaac no longer has movement momentum",
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.RIGHT_HAND,
		Description = {
			Description = {
				"{{HolyChestRoomIcon}} Chests have a 33% chance of becoming Eternal Chests"
			},
			Golden = {
				TargetStrings = {
					"33",
					"50",
					"50",
					"50",
				},
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.RED_RIBBON,
		Description = {
			Description = {
				"{{ffFullEternalHeart}} Half Eternal Hearts become Full Eternal Hearts"
			},
			Golden = {
				FullReplace = {
					"{{ffFullEternalHeart}} {{ColorGold}} All Eternal Hearts become Double Full Eternal Hearts"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.FLEA_MELTDOWN,
		Description = {
			Description = {
				"Entering a hostile room spawns an Orange Skuzz",
				"{{Burning}} This skuzz does 3x Isaac's damage and will ignite enemies"
			},
			Golden = {
				TargetStrings = {
					"an Orange Skuzz",
					"2 Orange Skuzzes",
					"3 Orange Skuzzes",
					"4 Orange Skuzzes",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.FLEA_DELUGE,
		Description = {
			Description = {
				"Entering a hostile room spawns a Cyan Skuzz",
				"This skuzz does 3x Isaac's damage and will leave damaging creep"
			},
			Golden = {
				TargetStrings = {
					"an Cyan Skuzz",
					"2 Cyan Skuzzes",
					"3 Cyan Skuzzes",
					"4 Cyan Skuzzes",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.FLEA_POLLUTION,
		Description = {
			Description = {
				"Entering a hostile room spawns a Purple Skuzz",
				"{{Slow}} This skuzz does 3x Isaac's damage and will slow enemies"
			},
			Golden = {
				TargetStrings = {
					"an Purple Skuzz",
					"2 Purple Skuzzes",
					"3 Purple Skuzzes",
					"4 Purple Skuzzes",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.FLEA_PROPAGANDA,
		Description = {
			Description = {
				"Entering a hostile room spawns a Beige Skuzz",
				"{{Charm}} This skuzz does 3x Isaac's damage and will charm enemies"
			},
			Golden = {
				TargetStrings = {
					"an Beige Skuzz",
					"2 Beige Skuzzes",
					"3 Beige Skuzzes",
					"4 Beige Skuzzes",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.FUZZY_PENNY,
		Description = {
			Description = {
				"Picking up a coin spawns a Blue Skuzz"
			},
			Golden = {
				TargetStrings = {
					"a Blue Skuzz",
					"2 Blue Skuzzes",
					"3 Blue Skuzzes",
					"4 Blue Skuzzes"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.CHUNK_OF_TAR,
		Description = {
			Description = {
				"Spawns 3 friendly Blots when entering a room with enemies"
			},
			Golden = {
				TargetStrings = {
					"3",
					"5",
					"7",
					"9",
				},
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.FORTUNE_GRUB,
		Description = {
			Description = {
				"↑ +1 Luck",
				"All beggars and slot machines will display a fortune alongside their possible payouts"
			},
			Golden = {
				TargetStrings = {
					"1",
					"2",
					"3",
					"4",
				},
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.JIGSAW_PUZZLE_BOX,
		Description = {
			Description = {
				FiendFolio.DescriptionIcons.PuzzlePiece .. "Only once, drops a Puzzle Piece at the start of the next floor",
				"20% chance to replace card spawns with a Puzzle Piece if one is used",
				"{{Warning}} This trinket is removed whenever a puzzle is completed"
			},
			Golden = {
				TargetMultipliers = {
					"20",
				},
				TargetStrings = {
					"a Puzzle Piece",
					"2 Puzzle Pieces",
					"3 Puzzle Pieces",
					"4 Puzzle Pieces",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.YIN_YANG_ORB,
		Description = {
			Description = {
				"17% chance to fire a homing tear that deals x1.25 your damage",
				"{{Luck}} 64% chance at 7 luck"
			},
			Golden = {
				TargetStrings = {
					"x1.25",
					"x1.75",
					"x2.25",
					"x2.75",
				},
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.SWALLOWED_M90,
		Description = {
			Description = {
				"On hit, Isaac pulls out an M90, causing his next shot to be a fast, piercing bullet that does x3.50 damage with self-knockback"
			},
			Golden = {
				TargetStrings = {
					"x3.50",
					"x4.50",
					"x5.50",
					"x6.50",
				},
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.TRINITY_WORM,
		Description = {
			Description = {
				"↑ +0.4 Tears",
				"↑ +12.5 Range",
				"Spectral tears",
				"Tears move in a holy trinity-style pattern",
			},
			Golden = {
				TargetMultipliers = {
					12.5
				},
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.IOU,
		Description = {
			Description = {
				"15% chance for a trinket to be dropped on room clear",
				"{{Luck}} 90% chance at 30 luck",
				"{{Trinket}} If held at the end of your run, spawns a random trinket at the start of your next run"
			},
			Golden = {
				TargetMultipliers = {
					15,
				},
			},
			Conditional = function(descObj)
				if descObj.ObjSubType == mod.ITEM.TRINKET.IOU + TrinketType.TRINKET_GOLDEN_FLAG then
					local description = descObj.Description
					descObj.Description = string.gsub(description, "random trinket", "random {{ColorGold}}golden trinket{{ColorText}}")
					descObj.Description = description .. "#{{ColorGold}}10% chance for trinkets to spawn golden"
				end
			end,
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.AUTOPSY_KIT,
		Description = {
			Description = {
				"{{Heart}} Bombed Shopkeepers will drop Red Hearts and rarely Bone Hearts instead of coins",
				"The chance of getting higher-quality hearts increases with the quality of coins replaced"
			},
			Golden = {
				Description = {
					"Bone hearts have a higher chance of dropping"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.SPIRE_GROWTH,
		Description = {
			Description = {
				"{{Timer}} Using a card grants a damage up that scales with the number of the card, if applicable"
			},
			Golden = {
				Description = {
					"{{Damage}} Increased damage when using cards with numbers"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.FLEA_CIRCUS,
		Description = {
			Description = {
				"20% chance to spawn a random friendly Flea when an enemy is killed"
			},
			Golden = {
				TargetMultipliers = {
					20,
				},
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.SHARP_PENNY,
		Description = {
			Description = {
				"Picking up a coin has a 17% chance to hurt Isaac without removing health"
			},
			Golden = {
				Description = {
					"Higher chance to hurt Isaac without removing health"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.ANGRY_FAIC,
		Description = {
			Description = {
				"Bosses and Minibosses fought in the {{BossRoom}} Boss Room will start with 10% more health",
				"{{Heart}} Bosses and Minibosses in the {{BossRoom}} will also drop additional hearts when defeated"
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {5, 10, 15, 20},
					TargetNumbers = {10},
				},
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.ETERNAL_CAR_BATTERY,
		Description = {
			Description = {
				"{{Battery}} Active items are triggered 4-6 times, but have a 1/2 chance to disappear on use"
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.POCKET_DICE,
		Description = {
			Description = {
				"Drops 2 random Glass Die and a coin at the start of each floor"
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.LOCKED_SHACKLE,
		Description = {
			Description = {
				"↑ +0.35 Tears",
				"↑ +0.35 Damage",
				"↑ +1 Range",
				"↑ +0.16 Shot speed",
				"↑ +1 Luck",
				"Picking up keys has a 25% chance to destroy the trinket and use a key",
				"{{Warning}} Can't be dropped"
			},
			Golden = {
				TargetMultipliers = {
					"0.35",
					"1",
					"0.16",
				},
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.SOLEMN_VOW,
		Description = {
			Description = {
				"Displays tear damage and health bars of all enemies"
			},
			PlayerSpecificDescription = {
				Players = { mod.PLAYER.GOLEM, mod.PLAYER.BOLEM },
				Description = {
					"{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
					"Displays tear damage and health bars of all enemies"
				},
			},
		},
	},
	{
		ID = FiendFolio.ITEM.TRINKET.DEALMAKERS,
		Description = {
			Description = {
				"{{Shop}}{{DevilChance}} Randomizes Shop and Devil Deal prices",
				"20% chance for Shop and Devil Deal items to have constantly shifting prices"
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {12, 12, 12, 12},
					TargetNumbers = {20},
				},
				Description = {
					"Shifting prices are faster"
				},
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.JEVILSTAIL,
		Description = {
			Description = {
				"Entering a room gives Isaac a random effect in a rotating list that can either be harmful or helpful"
			},
			Golden = {
				TargetStrings = {
					"a random effect",
					"2 random effects",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.PETRIFIED_GEL,
		Description = {
			Description = {
				"20% chance for Poops to be replaced with Shampoo",
				"You get better drops from destroying Shampoos"
			},
			Golden = {
				TargetMultipliers = {
					20,
				},
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.HATRED,
		Description = {
			Description = {
				"Slime familiar that mimics Isaac's movement",
				"Copies Isaac's tear effects and fire-rate at 40% damage",
				"{{Slow}} Fired tears also inflict Slowness",
				"Can be fired as a piercing projectile by double tapping, also applying tear effects",
				"{{Timer}} Respawns after a second"
			},
			Golden = {
				Description = {
					"Spawns additional familiars",
				},
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.FROG_PUPPET,
		Description = {
			Description = {
				"↑ +1 Life",
				"{{Player" .. FiendFolio.PLAYER.SLIPPY .. "}} On death, Isaac revives as Slippy"
			},
			Golden = {
				TargetStrings = {
					"1 Life",
					"2 Lives",
					"3 Lives",
					"4 Lives",
				},
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.TATTERED_FROG_PUPPET,
		Description = {
			Description = {
				"↑ +1 Life",
				"{{Player" .. FiendFolio.PLAYER.SLIPPY .. "}} On death, Isaac revives as Slippy"
			},
			Golden = {
				TargetStrings = {
					"1 Life",
					"2 Lives",
					"3 Lives",
					"4 Lives",
				},
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.CURSED_URN,
		Description = {
			Description = {
				"↑ x0.75 Fire rate multiplier",
				"↑ +1 Life",
				"{{Player" .. FiendFolio.PLAYER.CHINA .. "}} On death, Isaac revives as China",
				"{{Warning}} Dropping or exploding the trinket breaks it"
			},
			Golden = {
				TargetMultipliers = {
					"0.75", "1",
				},
			},
			Conditional = function(descObj) -- This suuucks... but it's the best I could do
				local split = mod:SplitString(descObj.Description, "#")
				local lastValidLine = #split + 1

				for i, line in ipairs(split) do
					if i == 1 then
						split[i] = string.gsub(line, "%d*%.?%d+", function(s)
							local values = {-0.19, -0.33, -0.43, -0.51}
							local multiplier = (tonumber(s) / 0.75) - 1

							if multiplier > 0 then
								return tostring(0.75 + values[multiplier])
							end
						end)
					end

					for _, blacklistedPrefix in ipairs(mod.EIDBlacklistedPrefix) do
						if line:sub(1, blacklistedPrefix:len()) == blacklistedPrefix then
							lastValidLine = i
							break
						end
					end
				end

				if descObj.ObjSubType == mod.ITEM.TRINKET.CURSED_URN + TrinketType.TRINKET_GOLDEN_FLAG then
					table.insert(split, lastValidLine, "{{ColorGold}}Can be dropped once without shattering, no longer being gilded")
				end
				descObj.Description = table.concat(split, "#")
			end,
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.SHATTERED_CURSED_URN,
		Description = {
			Description = {
				"↑ x0.9 Fire rate multiplier",
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {-0.09, -0.17, -0.24, -0.30},
					TargetNumbers = {0.9},
				},
				Description = {
					"↑ +1 Life",
					"{{Player" .. FiendFolio.PLAYER.CHINA .. "}} {{ColorGold}}On death, Isaac revives as China"
				},
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.CRAIGS_PIPE,
		Description = {
			Description = {
				"↑ +1 Life",
				"{{Player" .. FiendFolio.PLAYER.CRAIG .. "}} On death, Isaac revives as Craig"
			},
			Golden = {
				TargetStrings = {
					"1 Life",
					"2 Lives",
					"3 Lives",
					"4 Lives",
				},
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.CONJOINED_CARD,
		Description = {
			Description = {
				"{{MiniBoss}} 1 additional Miniboss Room will generate on every floor"
			},
			Golden = {
				TargetStrings = {
					"1 additional Miniboss Room",
					"2 additional Miniboss Rooms",
					"3 additional Miniboss Rooms",
					"4 additional Miniboss Rooms",
				},
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.LOST_FLOWER_CROWN,
		Description = {
			Description = {
				"{{Collectible638}} Once a floor, a random enemy will get erased"
			},
			Golden = {
				TargetStrings = {
					"a random enemy",
					"2 random enemies",
					"3 random enemies",
					"4 random enemies",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.WACKEY,
		Description = {
			Description = {
				"{{Key}} All key drops have an equal chance to become any of the possible key types",
			},
			Golden = {
				Description = {
					"Keys cannot be replaced with low value keys", -- Could elaborate more if the system allowed it
				}
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.MASSIVE_AMETHYST,
		Description = {
			Description = {
				"Shopkeepers in secret rooms are replaced by rune clusters",
				"{{Rune}} Blowing up a rune cluster causes it to drop:",
				"1-3 Rune Shards",
				"One to two random Runes"
			},
			PlayerSpecificDescription = {
				Players = { mod.PLAYER.GOLEM, mod.PLAYER.BOLEM },
				Description = {
					"{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
					"Shopkeepers in secret rooms are replaced by rune clusters",
					"{{Rune}} Blowing up a rune cluster causes it to drop:",
					"1-3 Rune Shards",
					"One to two random Runes"
				},
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {1, 2, 3, 4},
					TargetNumbers = {1, 3},
				},
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.HEARTACHE,
		Description = {
			Description = {
				"{{BrokenHeart}} All damage taken is negated, and instead +1 Broken Heart is gained when taking damage"
			},
			Golden = {
				TargetStrings = {
					"1 Broken Heart",
					"2 Broken Hearts",
					"3 Broken Hearts",
					"4 Broken Hearts"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.REDHAND,
		Description = {
			Description = {
				"Spawns 2 Red Hand familiars that fly from off-screen",
				"These familiars drag Isaac, pickups, and enemies around"
			},
			Golden = {
				TargetStrings = {
					"2",
					"3",
					"4",
					"5"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.MIDDLE_HAND,
		Description = {
			Description = {
				"50% chance for any {{Chest}} Chest or {{GoldenChest}} Golden Chest to be replaced by a {{ffDireChest}} Dire Chest"
			},
			Golden = {
				TargetStrings = {
					"50",
					"100",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.RAINBOW_BEAN,
		Description = {
			Description = {
				"5% chance to expell a random fart when near enemies",
				"{{Luck}} 100% chance at 48 luck"
			},
			Golden = {
				Description = {
					"Increased radius at which farts expell",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.FAULTY_FUSE,
		Description = {
			Description = {
				"{{Bomb}} 40% for random Bomb drops to be replaced by Copper Bombs",
				"{{ffCopperBomb}} 5% chance for a Copper Bomb to be dropped on room clear"
			},
			Golden = {
				TargetMultipliers = {
					"40",
					"5",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.ENERGY_SEARCHER,
		Description = {
			Description = {
				"5% chance for an Energy Card to be dropped on room clear",
				"Using an Energy Card has a 33% chance to spawn another random Energy Card"
			},
			Golden = {
				TargetMultipliers = {
					"5",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.BROKEN_RECORD,
		Description = {
			Description = {
				"30% chance for newly-spawned item pedestals to be replaced with an passive item you already have",
				"Will not provide you with useless duplicates"
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {21, 36, 46, 53},
					TargetNumbers = {30},
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.FUSHIGI,
		Description = {
			Description = {
				"{{Collectible572}} 5% chance to fire a metal Eye of the Occult tear with increased range and double damage",
				"{{Luck}} 50% chance at 9 luck"
			},
			Golden = {
				TargetMultipliers = {
					"5",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.NESTING_DOLL,
		Description = {
			Description = {
				"{{Beggar}} 80% chance for another, smaller beggar to appear when blowing up a beggar"
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.EGG_PENNY,
		Description = {
			Description = {
				"Picking up a coin has a 17% chance to spawn a Fragile Bobby",
				"{{Collectible8}} Fragile bobbies are similar to Brother Bobby but can die"
			},
			Golden = {
				Description = {
					"Higher chance to spawn a Fragile Bobby"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.LEFTOVERS,
		Description = {
			Description = {
				"{{HalfHeart}} Overhealed health gained from heart pickups will be left on the ground for later use"
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.FUZZY_PICKLE,
		Description = {
			Description = {
				"↑ +0.25 Damage",
				"{{Damage}} +0.1 Damage up for each reference item Isaac has",
				"{{Damage}} Trinkets grant +0.25 Damage",
				"{{Damage}} Active items grant +0.5 Damage",
				"Loose references only grant half of the corresponding damage"
			},
			Golden = {
				TargetMultipliers = {
					"0.25",
					"0.1",
					"0.5",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.DUDS_FLOWER,
		Description = {
			Description = {
				"{{ffCopperBomb}} All bombs placed by Isaac will become Copper Bombs"
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.BOMB_TOKEN,
		Description = {
			Description = {
				"{{Bomb}} Increases the flat damage dealt by bombs spawned by Isaac by 50",
				"{{Collectible52}} Grants a 1.25x damage multiplier to Dr. Fetus bombs"
			},
			Golden = {
				TargetMultipliers = {
					"50",
					"1.25",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.QUALITY_ASSURANCE,
		Description = {
			Description = {
				"10% chance for enemies to spawn in with the Glitched status effect",
				"{{Card" .. FiendFolio.ITEM.CARD.DOWNLOAD_FAILURE .. "}} Glitched enemies slide around the room",
				"Glitched enemies spawn 3 blue bugs on death"
			},
			Golden = {
				TargetMultipliers = {
					"10",
					"3",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.CERBERUS_ORB,
		Description = {
			Description = {
				"After not firing for 2.5 seconds, the next shot will deal double damage and have increased velocity",
				"This shot will deal base damage in a small radius around itself on impact"
			},
			Golden = {
				TargetStrings = {
					"double damage",
					"triple damage",
					"quadruple damage",
					"quintuple damage",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.BONE_LORDS_TABLET,
		Description = {
			Description = {
				"Using a card will grant 4-5 bone orbitals"
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {4, 5, 6, 4},
					TargetNumbers = {4, 5},
				},
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.SCARAB_PENNY,
		Description = {
			Description = {
				"Picking up a coin spawns a Blue Beetle",
				"Blue Beetles are friendly creatures that shield Isaac from oncoming attacks and projectiles"
			},
			Golden = {
				TargetStrings = {
					"a Blue Beetle",
					"2 Blue Beetles",
					"3 Blue Beetles",
					"4 Blue Beetles",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.STACK_OF_PENNY,
		Description = {
			Description = {
				"{{ffLilPenny}} Picking up a coin spawns 1-4 Lil' Pennies"
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {1, 2, 3, 4},
					TargetNumbers = {1, 4},
				},
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.PINCUSHION,
		Description = {
			Description = {
				"25% chance to shoot sewing needle tears that pierce and inflict enemies with Sewn",
				"{{Luck}} 100% chance at 6 luck",
				"{{ffSew}} Sewn enemies reflect damage taken onto all other enemies inflicted with Sewn"
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {13, 25, 38, 50},
					TargetNumbers = {25},
				},
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.WAVEBREAKER,
		Description = {
			Description = {
				"Wave 2 enemies no longer appear",
				"Does not affect multi-wave room types like {{BossRushRoom}} Boss Rush or {{ChallengeRoom}} Challenge Rooms"
			},
			PlayerSpecificDescription = {
				Players = { mod.PLAYER.GOLEM, mod.PLAYER.BOLEM },
				Description = {
					"{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
					"Wave 2 enemies no longer appear",
					"Does not affect multi-wave room types like {{BossRushRoom}} Boss Rush or {{ChallengeRoom}} Challenge Rooms"
				},
			},
		},
	},
	{
		ID = FiendFolio.ITEM.TRINKET.CHARRED_CARD,
		Description = {
			Description = {
				"{{Bomb}} Placing a bomb will also place a Troll Bomb in the room",
				"Troll bombs avoid Isaac and prioritize enemies"
			},
			Golden = {
				TargetStrings = {
					"a Troll Bomb",
					"2 Troll Bombs",
					"3 Troll Bombs",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.GLUTTONOUS_JOKER,
		Description = {
			Description = {
				"{{Bomb}} Converts all suit cards to Club cards, if possible"
			},
			Golden = {
				Description = {
					"2 of Clubs cards are converted into 3 of Clubs"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.WRATHFUL_JOKER,
		Description = {
			Description = {
				"{{Key}} Converts all suit cards to Spade cards, if possible"
			},
			Golden = {
				Description = {
					"2 of Spades cards are converted into 3 of Spades"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.GREEDY_JOKER,
		Description = {
			Description = {
				"{{Coin}} Converts all suit cards to Diamond cards, if possible"
			},
			Golden = {
				Description = {
					"2 of Diamonds cards are converted into 3 of Diamonds"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.LUSTY_JOKER,
		Description = {
			Description = {
				"{{Heart}} Converts all suit cards to Heart cards, if possible"
			},
			Golden = {
				Description = {
					"2 of Hearts cards are converted into 3 of Hearts"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.EVIOLITE,
		Description = {
			Description = {
				"↑ Large all stats up",
				"↓ Stat increase reduces with each owned item, degrading to 0 at 10 items"
			},
			PlayerSpecificDescription = {
				Players = { mod.PLAYER.GOLEM, mod.PLAYER.BOLEM },
				Description = {
					"{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
					"↑ Large all stats up",
					"↓ Stat increase reduces with each owned item, degrading to 0 at 10 items"
				},
			},
			Golden = {
				TargetMultipliers = {
					"10"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.SLEEPY_DUST,
		Description = {
			Description = {
				"15% chance to fire tears that inflict enemies with Drowsy",
				"{{Luck}} 30% chance at 25 luck",
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.DROWSY_AND_SLEEP },
			Golden = {
				TargetMultipliers = {
					"15"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.EARTH_IMPALE,
		Description = {
			Description = {
				"{{Chargeable}} Gain a charged attack to make a rock spike in the cardinal directions",
				"The rock spike attack scales with Isaac's damage",
			},
			Golden = {
				Description = {
					"Rock spike attack does more damage"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.COMFORT_FOOD,
		Description = {
			Description = {
				"{{HalfHeart}} 50% chance to heal half a heart if a room clear reward does not spawn"
			},
			Golden = {
				TargetStrings = {
					"half a heart",
					"a heart",
					"a heart and a half",
					"two hearts",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.SPROUTING_SEED,
		Description = {
			Description = {
				"Dropping this trinket in an uncleared room will grow a vine that snares nearby enemies",
				"Taking damage will drop the trinket automatically"
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.JOY_BUZZER,
		Description = {
			Description = {
				"{{Battery}} All batteries are replaced by virtuous, cursed, or firework batteries",
				"{{Coin}} 50% chance to replace cards in shops with batteries"
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {25, 50, 50, 50},
					TargetNumbers = {50},
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.INTERNALIZED_HATRED,
		Description = {
			Description = {
				"{{BlackHeart}} ↑ Grants a Damage Up whenever a Black Heart is depleted",
				"Black Hearts no longer deal damage to enemies"
			},
			Golden = {
				Description = {
					"Greater damage up when a Black Heart is depleted"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.DELIGHTFUL_DRUMSTICK,
		Description = {
			Description = {
				"25% chance to fire in a cross shape whenever shooting",
				"{{Luck}} 45% chance at 15 luck",
				"{{Charm}} Acts like a friendly Drumstick when dropped on the ground"
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {10, 20, 30, 40},
					TargetNumbers = {25},
				},
				Description = {
					"Drumstick tears deal increased damage"
				},
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.PROJECTILE_TRINKET,
		Description = {
			Description = {
				"Is a projectile",
				"You shouldn't have this"
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.IMP_FINGER,
		Description = {
			Description = {
				"One orbital fireball can frequently spawn around Isaac",
				"{{Collectible" ..FiendFolio.ITEM.COLLECTIBLE.PYROMANCY .."}} Spawns fireballs at 3x slower rate compared to Pyromancy"
			},
			Golden = {
				TargetStrings = {
					"One orbital fireball",
					"Two orbital fireballs",
					"Three orbital fireballs",
					"Four orbital fireballs",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.GODHEADJR,
		Description = {
			Description = {
				"{{Collectible331}} 10% chance to shoot a godhead tear",
				"{{Luck}} 40% chance at 8 luck"
			},
			Golden = {
				TargetMultipliers = {
					"10"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.FLAMING_PENNY,
		Description = {
			Description = {
				"Picking up a coin spawns an orbital fireball"
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.TAN_WORM,
		Description = {
			Description = {
				"↑ +0.4 Tears",
				"↑ +18 Range",
				"Spectral tears",
				"Isaac's tears move in a tangent wave"
			},
			Golden = {
				TargetMultipliers = {
					"18"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.ADBLOCKER,
		Description = {
			Description = {
				"Removes all fortune popups",
				"Will notify Isaac when a popup is blocked"
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.THE_SHAMPOO_BOTTLE,
		Description = {
			Description = {
				"↑ +0.1 Damage",
				"Provides insightful commentary on many things",
				"Points out missed tinted rocks"
			},
			Golden = {
				TargetMultipliers = {
					"0.1"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.BUTTON_MASHER,
		Description = {
			Description = {
				"Automatically uses your active item and any consumables held",
				"Starts automatically using your active item on room entry",
				"Chargeless items are automatically used"
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.PENNY_PACK,
		Description = {
			Description = {
				"Picking up a coin has a 8% chance to spawn a penny trinket"
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.ORIGINAL_EGGPLANT,
		Description = {
			Description = {
				"Prevents reference items from spawning"
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.CHEMISTRY_KIT,
		Description = {
			Description = {
				"All fires are replaced by Champion Fires",
				"7% chance for grids to turn into Champion Fires",
				"Champion Fires have effects similar to enemy champions when destroyed"
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {6, 13, 20, 26},
					TargetNumbers = {7},
				},
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.FADED_CARD,
		Description = {
			Description = {
				"All non-story {{BossRoom}} Boss Rooms will be skipped, granting no rewards and deleting the boss instantly"
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.STITCHED_CARD,
		Description = {
			Description = {
				"Isaac starts each floor in a random special room"
			},
			Golden = {
				Description = {
					"The random special room Isaac spawns in is better"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.STAINED_CARD,
		Description = {
			Description = {
				"↑ +2.5 Damage",
				"Taking damage will steadily lower this damage bonus"
			},
			Golden = {
				Description = {
					"The amount of damage bonus lost is lowered"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.CROWDED_CARD,
		Description = {
			Description = {
				"{{Heart}} 10% chance to spawn a heart of a random type when picking up a heart"
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {5, 10, 15, 20},
					TargetNumbers = {10},
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.HOLLOW_CARD,
		Description = {
			Description = {
				"All {{SecretRoom}} Secret Rooms are replaced by {{SuperSecretRoom}} Super Secret Rooms instead"
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.SPADE_OF_CLUBS,
		Description = {
			Description = {
				"Bomb and key pickups will periodically swap between each other while on the ground"
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.MINIATURE_CARD,
		Description = {
			Description = {
				"Reveals rooms in a 5x5 radius upon starting a new floor",
				"{{Heart}} Heals 1 hearts on the start of a new floor",
				"Isaac will deal 40 damage to all enemies in the first 1 rooms he enters each floor"
			},
			Golden = {
				TargetMultipliers = {
					"1",
				}
			},
			Conditional = function(descObj) -- This suuucks... but it's the best I could do
				descObj.Description = string.gsub(descObj.Description, "1 hearts", "1 heart")
				descObj.Description = string.gsub(descObj.Description, "1 rooms", "room")
			end,
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.HONEYED_PENNY,
		Description = {
			Description = {
				FiendFolio.DescriptionIcons.Honey ..  "Picking up a coin has a 50% chance to grant a slowing trail and slowing tears for a period"
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {25, 50, 50, 50},
					TargetNumbers = {50},
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.LINK_CABLE,
		Description = {
			Description = {
				"20% chance upon entering a new room to pause all enemies in the room until Isaac attacks or enough time passes"
			},
			Golden = {
				TargetMultipliers = {
					"20"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.TOKEN_ON_A_STRING,
		Description = {
			Description = {
				FiendFolio.DescriptionIcons.Token .. "Spawns a Token on the next floor",
				"Tokens mimic the effect of the previous pickup collected",
				"Trinket destroys itself on the next floor"
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.INFESTATION_ONE_POINT_FIVE,
		Description = {
			Description = {
				"Killing an enemy spawns a Blue Baby Spider"
			},
			Golden = {
				TargetStrings = {
					"a Blue Baby Spider",
					"2 Blue Baby Spiders",
					"3 Blue Baby Spiders",
					"4 Blue Baby Spiders",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.SHOOTING_STAR,
		Description = {
			Description = {
				"{{TreasureRoom}} When skipping a Treasure Room on a floor:",
				"↑ +1 Damage"
			},
			Golden = {
				TargetMultipliers = {1},
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.LONGTIME_FIEND,
		Description = {
			Description = {
				"↑ +0.1 Damage on first pickup",
				"↑ +0.33 Damage when entering a new floor"
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.VANILLA_EXTRACT,
		Description = {
			Description = {
				"Only classic floors can appear (Basement, Caves, Depths, Womb)",
				"Does nothing beyond Womb",
				"Does nothing on the alternate path (Downpour, Dross, Mines, Ashpit, Mausoleum, Gehenna, Corpse)"
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.OLD_SHELL,
		Description = {
			Description = {
				"{{Luck}} 10% chance to fire 1 quadruple-shot",
				"{{Damage}} Quadruple shot tears deal x0.7 damage each"
			},
			Golden = {
				TargetMultipliers = {
					1,
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.BREAKPOINT,
		Description = {
			Description = {
				"{{Collectible" .. CollectibleType.COLLECTIBLE_PAUSE .. "}} Taking damage pauses every enemy in the room for up to 5 seconds",
				" Attacking will break the pause early"
			},
			Golden = {
				TargetMultipliers = {
					5
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.CONTRA_BAND,
		Description = {
			Description = {
				"50% chance for Beggars to be replaced with Fake Beggars"
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {25, 50, 50, 50},
					TargetNumbers = {50},
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.PLUSH_LAMB,
		Description = {
			Description = {
				"Whenever you would next lose an item for any reason, Plush Lamb will be removed instead"
			},
			Golden = {
				Description = {
					"Plush Lamb will de-gild instead of being lost and can be used a second time"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.LIMITED_TIME_OFFER,
		Description = {
			Description = {
				"{{Collectible" .. CollectibleType.COLLECTIBLE_STEAM_SALE .. "}} For up to 2 minutes after entering a floor, some items in the shop will be half price"
			},
			Golden = {
				TargetMultipliers = {
					2
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.FIENDISH_LADYBUG,
		Description = {
			Description = {
				"Entering a hostile room spawns a Purple Beetle",
				"This beetle reflects projectiles with a 50% chance for them to deal 5x damage"
			},
			Golden = {
				TargetStrings = {
					"a Purple Beetle",
					"2 Purple Beetles",
					"3 Purple Beetles",
					"4 Purple Beetles",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.BASTARDLY_LADYBUG,
		Description = {
			Description = {
				"Entering a hostile room spawns a Black Beetle",
				"{{Slow}} This beetle reflects projectiles that slow enemies and leave a slowing puddle on impact"
			},
			Golden = {
				TargetStrings = {
					"a Black Beetle",
					"2 Black Beetles",
					"3 Black Beetles",
					"4 Black Beetles",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.FRIENDLY_LADYBUG,
		Description = {
			Description = {
				"Entering a hostile room spawns a Red Beetle",
				"This beetle reflects projectiles that deal 1.5x damage and cause enemies to drop temporary hearts on kill"
			},
			Golden = {
				TargetStrings = {
					"a Red Beetle",
					"2 Red Beetles",
					"3 Red Beetles",
					"4 Red Beetles",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.SKELETAL_LADYBUG,
		Description = {
			Description = {
				"Entering a hostile room spawns a Grey Beetle",
				"This beetle reflects projectiles that split into two bone tears on impact"
			},
			Golden = {
				TargetStrings = {
					"a Grey Beetle",
					"2 Grey Beetles",
					"3 Grey Beetles",
					"4 Grey Beetles",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.CLUMP_OF_LADYBUGS,
		Description = {
			Description = {
				"20% chance to spawn a random Ladybug when an enemy is killed"
			},
			Golden = {
				TargetMultipliers = {
					20,
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.STRANGE_COCOON,
		Description = {
			Description = {
				"Blue flies, spiders, skuzzes, and beetles are converted to another type when spawned"
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.INK_POT,
		Description = {
			Description = {
				"Gaining black hearts will also convert up to 2 soul hearts to black hearts"
			},
			Golden = {
				TargetMultipliers = {
					"2"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.LOOSE_FILAMENT,
		Description = {
			Description = {
				"Grants a bulb familiar that attacks enemies after Isaac uses an active item",
				"Bulb familiar does 2.75 damage",
				"Active period scales with active charge"
			},
			Golden = {
				TargetMultipliers = {
					"2.75"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.SMALL_BANDAID,
		Description = {
			Description = {
				"25% chance to heal 1 damaged heart after clearing a room"
			},
			Golden = {
				TargetMultipliers = {
					"25"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.SPECTRAL_KEYCHAIN,
		Description = {
			Description = {
				"{{Key}} Picking up keys does not give you a key, but instead gives you a grey key wisp",
				"Key wisps will automatically spend themselves to unlock whatever is closest to Isaac",
				"Picking up a key has a 25% chance to spawn two grey key wisps"
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {25, 50, 75, 75},
					TargetNumbers = {25},
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.SISYPHEAN_BOULDER,
		Description = {
			Description = {
				"↓ -0.1 Speed",
				"Gives Isaac a boulder he can push",
				"The boulder deals 60 damage per second and can block shots",
				"{{Damage}} The boulder becomes more powerful the more kills you get with it",
				"{{Speed}} The more kills Isaac gets with the boulder, the slower he moves"
			},
			PlayerSpecificDescription = {
				Players = { mod.PLAYER.GOLEM, mod.PLAYER.BOLEM },
				Description = {
					"{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
					"↓ -0.1 Speed",
					"Gives Isaac a boulder he can push",
					"The boulder deals 60 damage per second and can block shots",
					"{{Damage}} The boulder becomes more powerful the more kills you get with it",
					"{{Speed}} The more kills Isaac gets with the boulder, the slower he moves"
				},
			},
			Golden = {
				TargetMultipliers = {
					"60"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.TIMES_ARROW,
		Description = {
			Description = {
				"Automatically skips the first floor in the first 4 chapters"
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.CORRUPTED_LARVA,
		Description = {
			Description = {
				"Spawns 1 mini Level 0 Fly upon entering an uncleared room",
				"{{Collectible285}} The mini Level 0 Fly devolves enemies it touches"
			},
			Golden = {
				TargetStrings = {
					"1 mini Level 0 Fly",
					"2 mini Level 0 Flies",
					"3 mini Level 0 Flies",
					"4 mini Level 0 Flies",
				},
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.HINGE,
		Description = {
			Description = {
				"{{Collectible" .. FiendFolio.ITEM.COLLECTIBLE.LIL_FIEND .. "}} Grants Lil Fiend or Lil Friend",
				"{{Collectible" .. FiendFolio.ITEM.COLLECTIBLE.LIL_FRIEND .. "}} Swaps every room"
			},
			Golden = {
				TargetStrings = {
					"Lil Fiend or Lil Friend",
					"2 Lil Fiends or 2 Lil Friends",
					"3 Lil Fiends or 3 Lil Friends",
					"4 Lil Fiends or 4 Lil Friends"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.WANTED_POSTER,
		Description = {
			Description = {
				"Once per floor, an enemy will be marked",
				"{{ffMarked}} Marked enemies are bigger, have more health, and spew tears out",
				"{{Coin}} Killing a marked enemy drops 1 nickel"
			},
			Golden = {
				TargetMultipliers = {
					1
				}
			},
			Conditional = function (descObj)
				local save = mod.getFieldInit(FiendFolio.savedata, 'run', {})

				if save.SpecialWantedPosterSpawned then
					local prefix = "#{{Player" .. mod.PLAYER.FRIEND .. "}} "
					local SPECIAL_LINE = "It states that the fugitive was last seen in a Secret room..."
					descObj.Description = descObj.Description .. prefix .. SPECIAL_LINE
				end

				return descObj
			end
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.FIENDS_LOST_FRIEND,
		Description = {
			Description = {
				"Spawns a permanent Fiend Minion that helps you in the next room Isaac goes to"
			},
			Golden = {
				TargetStrings = {
					"a permanent Fiend Minion",
					"two permanent Fiend Minions",
					"three permanent Fiend Minions",
					"four permanent Fiend Minions",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.PSYCHOLOGICAL_TORTURE,
		Description = {
			Description = {
				"{{Damage}} Count with your tears for an increasing damage and tears up",
				"{{Tears}} Counting counts as firing a certain amount of tears and stopping",
				"Damage and tears increase stops if you fail to count properly"
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.NOTABLE_ALBUM,
		Description = {
			Description = {
				"Isaac can fire a quadruple-shot once per room"
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.FIVE_LEAF_CLOVER,
		Description = {
			Description = {
				"{{Damage}} Damage increased by 0.1x Isaac's luck"
			},
			Golden = {
				TargetMultipliers = {
					0.1
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.CIRCADIAN_RHYTHM,
		Description = {
			Description = {
				"During the day (6:00 to 18:00):",
				"↑ +0.6 Tears",
				"↑ +0.2 Speed",
				"During the night (18:00 to 6:00):",
				"↑ +0.6 Damage",
				"↑ +1 Luck"
			},
			Golden = {
				TargetMultipliers = {
					0.6, 0.2, 1
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.SHAMROCK_SHOE,
		Description = {
			Description = {
				"↑ +1 Luck",
				"↑ +0.1 Speed",
			},
			Golden = {
				TargetMultipliers = {
					1, 0.1
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.WET_WELLY,
		Description = {
			Description = {
				"↑ +0.4 Fire rate",
				"↑ +0.1 Speed",
			},
			Golden = {
				TargetMultipliers = {
					0.4, 0.1
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.CLOVERED_EPEE,
		Description = {
			Description = {
				"↑ +0.3 Damage",
				"↑ +1 Luck",
			},
			Golden = {
				TargetMultipliers = {
					0.3, 1
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.TOY_SPEAR,
		Description = {
			Description = {
				"↑ +0.3 Damage",
				"↑ +1.25 Range",
			},
			Golden = {
				TargetMultipliers = {
					0.3, 1.25
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.BLOODY_BLADE,
		Description = {
			Description = {
				"↑ +0.4 Fire rate",
				"↑ +0.3 Damage",
			},
			Golden = {
				TargetMultipliers = {
					0.4, 0.3
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.TATTY_CLEAT,
		Description = {
			Description = {
				"↑ +0.1 Speed",
				"↑ +0.3 Damage",
			},
			Golden = {
				TargetMultipliers = {
					0.1, 0.3
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.LIFE_INSURANCE,
		Description = {
			Description = {
				"All leftover money at the end of the run is added to the donation machine"
			},
			Golden = {
				TargetStrings = {
					"added",
					"doubled and added",
					"tripled and added",
					"quadrupled and added",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.GOLD_LEAF,
		Description = {
			Description = {
				"Gold pickups no longer have special effects and give you the normal pickup",
				"{{Coin}} Gold pickups also give +9 Coins"
			},
			Golden = {
				TargetMultipliers = {
					"9"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.BEATEN_CROSS,
		Description = {
			Description = {
				"{{Collectible108}} Reduces most damage taken to half a heart when Isaac has 3 hearts or less"
			},
			Golden = {
				TargetMultipliers = {
					"3"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.VICODIN,
		Description = {
			Description = {
				"{{Pill}} Reduces most damage taken to half a heart when taking a pill"
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.RUNIC_CUBE,
		Description = {
			Description = {
				"{{Rune}} 18% chance to spawn a random rune upon taking damage"
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.ZZZZZZ_MAGNET,
		Description = {
			Description = {
				"{{AngelDevilChance}} Turns all doors to Devil Rooms and Angel Rooms into doors to the Error Room"
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.OWL_FEATHER,
		Description = {
			Description = {
				"{{Trinket113}} Blue Flies have a 20% chance to turn into Locusts of War on spawn"
			},
			Golden = {
				TargetMultipliers = {
					"20"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.POPPET,
		Description = {
			Description = {
				"{{Collectible462}} 20% chance to shoot a piercing Eye of Belial tear",
				"Hitting an enemy makes the tear homing and double its damage"
			},
			Golden = {
				TargetMultipliers = {
					"20"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.POWER_INVERTER,
		Description = {
			Description = {
				"{{Battery}} Batteries give +0.9 Damage for the current floor",
				"Batteries can be picked up at full item charge or with no active item"
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.BABY_BOTTLE,
		Description = {
			StatusEffects = { mod.DescriptionStatuses.PACIFIED },
			Description = {
				"On hit, nearby enemies are Pacified for 4 seconds",
				"{{HalfSoulHeart}} Pacified enemies have a 20% chance to drop a half soul heart"
			},
			Golden = {
				TargetMultipliers = {
					4
				},
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.ONE_OF_YOUR_BOMBS,
		Description = {
			Description = {
				"{{Warning}} {{Bomb}} It's An Item Now! {{Bomb}} {{Warning}}",
			},
			Golden = {
				Description = {
					"{{Warning}} {{Bomb}} It's Golden Now! {{Bomb}} {{Warning}}"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.TWEEZERS,
		Description = {
			Description = {
				"30% chance to fire tears that release a piercing, homing tear on hit",
				"{{Luck}} 75% chance at 6 luck",
			},
			Golden = {
				Description = {
					"Piercing, homing tears split into more tears on hit"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.SEWING_MANUAL_3_USE,
		Description = {
			Description = {
				"Turns the next 3 tear effect items collected into familiars that shoot that item's effect",
			},
			Golden = {
				TargetStrings = {
					"into familiars",
					"into 2 familiars",
					"into 3 familiars",
					"into 4 familiars",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.SEWING_MANUAL_2_USE,
		Description = {
			Description = {
				"Turns the next 2 tear effect items collected into familiars that shoot that item's effect",
			},
			Golden = {
				TargetStrings = {
					"into familiars",
					"into 2 familiars",
					"into 3 familiars",
					"into 4 familiars",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.SEWING_MANUAL_1_USE,
		Description = {
			Description = {
				"Turns the next tear effect item collected into a familiar that shoots that item's effect",
			},
			Golden = {
				TargetStrings = {
					"into familiars",
					"into 2 familiars",
					"into 3 familiars",
					"into 4 familiars",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.SANGUINE_SALIVATION,
		Description = {
			Description = {
				"Bosses below 30% health take 30% extra damage",
				"{{Heart}} On clearing a boss room, heals 1 heart",
			},
			Golden = {
				TargetStrings = {
					"heals 1 heart",
					"heals 2 hearts",
					"heals 3 hearts",
					"heals 4 hearts",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.LUNATIC_EYE,
		Description = {
			Description = {
				"7% chance to shoot tears that inflict enemies with Berserk",
				"{{Luck}} 20% chance at 16 luck",
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.BERSERK },
			Golden = {
				TargetAdditives = {
					AdditiveValues = {3, 6, 9, 12},
					TargetNumbers = {7},
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.CHARACTER_SELECT,
		Description = {
			Description = {
				"5% chance for the room clear reward to be a soulstone",
				"Consumed upon using a soulstone, granting Isaac a revive as the corresponding character"
			},
			Golden = {
				Description = {
					"Isaac revives with full health on death"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.SHADOW_MANTLE,
		Description = {
			Description = {
				"{{Collectible313}} Negates 6 hits of damage before breaking",
			},
			Golden = {
				TargetMultipliers = {
					6
				},
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.DADS_USB,
		Description = {
			Description = {
				"25% chance for a random Technlogy item effect each room",
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {25, 75, 75, 75},
					TargetNumbers = {25},
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.GOOGLY_EYES,
		Description = {
			Description = {
				"Grants most non-shooting familiars googly eyes which let them fire tears",
				"The tears deal 3.5 damage"
			},
			Golden = {
				TargetMultipliers = {
					"3.5"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.AMMO_CLIP,
		Description = {
			Description = {
				"17% chance to fire an Ammo Heart bullet",
				"Ammo Hearts correspond to the type of health Isaac has",
				"{{Luck}} 100% chance to fire at 20 luck"
			},
			Golden = {
				TargetMultipliers = {
					"17"
				}
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.JUSTICE_AXE,
		Description = {
			Description = {
				"When Isaac shoots, he throws a curved hammer projectile that deals 15 in a radius and 35 damage on a direct hit",
				"When the hammer grazes enemies, it does 2 damage",
				"Can be fired every 9 seconds"
			},
			Golden = {
				TargetStrings = {
					"9 seconds",
					"4.5 seconds",
					"3 seconds",
					"2.25 seconds",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.DADS_HOME,
		Description = {
			Description = {
				"20% chance to clear all enemies and pickups from a room, causing them to spawn in the next room",
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {5, 13, 30, 30},
					TargetNumbers = {20},
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.STEVENS_BOX,
		Description = {
			Description = {
				"{{Damage}} Steven heart bullets do 2x as much damage",
				"{{ffStevenHeart}} 10% chance for the room clear award to be a Steven Heart",
				"Hearts have a rare chance to be replaced by Steven Hearts",
				"Steven hearts go over other hearts and shoot at enemies from the HUD",
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {1, 2, 3, 4},
					TargetNumbers = {2, 10},
				},
				TargetMultipliers = {
					"10",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.FOSSILIZED_EYE,
		Description = {
			Description = {
				"Card fronts will be visible even when dropped",
			},
			PlayerSpecificDescription = {
				Players = { mod.PLAYER.GOLEM, mod.PLAYER.BOLEM },
				Description = {
					"{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
					"Card fronts will be visible even when dropped",
					"{{ColorTransform}}{{ffCrush}} Crush effect",
					"Spawns a friendly bloodshot eye",
				},
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.DAMAGE_PENNY,
		Description = {
			Description = {
				"{{Damage}} Picking up a coin gives a flat +0.3 fading Damage for the next 30 seconds"
			},
			Golden = {
				TargetMultipliers = {
					"0.3", "30",
				},
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.TEARS_PENNY,
		Description = {
			Description = {
				"{{Tears}} Picking up a coin gives a flat +0.2 fading Tears for the next 30 seconds"
			},
			Golden = {
				TargetMultipliers = {
					"0.2", "30",
				},
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.LUCK_PENNY,
		Description = {
			Description = {
				"{{Luck}} Picking up a coin gives +0.5 fading Luck for the next 30 seconds"
			},
			Golden = {
				TargetMultipliers = {
					"0.5", "30",
				},
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.CONSTELLATION_PENNY,
		Description = {
			Description = {
				"{{Planetarium}} Picking up a coin gives +0.4% Planetarium chance"
			},
			Golden = {
				TargetMultipliers = {
					"0.4",
				},
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.PLUSHIE_SLOTH,
		Description = {
			Description = {
				"{{Collectible"..FiendFolio.ITEM.COLLECTIBLE.SNOOZE_BUTTON.."}} 33% chance to clear the room of all obstacles, pick-ups, and enemies"
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {22, 44, 66, 67},
					TargetNumbers = {33},
				},
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.PLUSHIE_LUST,
		Description = {
			Description = {
				"{{Friendly}} 50% chance to turn enemies friendly when Isaac takes contact damage with them",
				"{{Charm}} 50% chance to charm bosses when Isaac takes contact damage with them",
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {25, 50, 50, 50},
					TargetNumbers = {50},
				},
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.PLUSHIE_WRATH,
		Description = {
			Description = {
				"{{Bomb}} 50% chance for enemies to leave behind a bomb on death",
				"The size of the bomb scales with the size of the enemy",
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {25, 50, 50, 50},
					TargetNumbers = {50},
				},
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.PLUSHIE_GLUTTONY,
		Description = {
			Description = {
				"{{Heart}} Red Hearts disappear after a couple of seconds, depending on their value",
				"85% chance to spawn a half red heart somewhere in the room when collecting a red heart",
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {5, 10, 15, 15},
					TargetNumbers = {85},
				},
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.PLUSHIE_GREED,
		Description = {
			Description = {
				"{{Warning}} Coins you pick up will not be added to your coin count and are instead stored by this trinket",
				"{{Coin}} After collecting at least 10 cents worth of Coins, this trinket will double their value and add them to your coin count",
			},
			Golden = {
				Description = {
					"Further increases Coin value"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.PLUSHIE_ENVY,
		Description = {
			Description = {
				"{{Collectible631}} 15% chance to split enemies into 2 smaller versions with 40% health on hit",
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {10, 20, 30, 40},
					TargetNumbers = {15},
				},
			},
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.PLUSHIE_PRIDE,
		Description = {
			Description = {
				"{{Collectible65}} Whenever Isaac uses an active item with charges, Troll Bombs spawn near the center of the room",
				"{{Battery}} The amount of Troll Bombs spawned scales with the active item's max charges"
			},
			Golden = {
				Description = {
					"More troll bombs spawn when using an active item"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.KALUS_CLAW,
		Description = {
			Description = {
				"When an enemy is inflicted with a status effect, they are struck with a scratching effect that does 2x Isaac's damage",
			},
		},
	},
	{
		ID = FiendFolio.ITEM.TRINKET.KALUS_TONGUE,
		Description = {
			Description = {
				"{{DevilChance}} Picking up a Red Heart gives 1.5% Devil Deal chance for the floor, up to 15%"
			},
			Golden = {
				Description = {
					"More devil chance"
				}
			}
		}
	},


	-- Bonus Pennies
	{
		ID = FiendFolio.ITEM.TRINKET.BENT_PENNY,
		Description = {
			Description = {
				"Picking up a coin has a 50% chance to either double its value or grant zero cents"
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {25, 50, 50, 50},
					TargetNumbers = {50},
				},
			},
		},
	},
	{
		ID = FiendFolio.ITEM.TRINKET.TROLL_PENNY,
		Description = {
			Description = {
				"Picking up a coin has a 50% chance to spawn a troll bomb nearby enemies"
			},
			Golden = {
				TargetStrings = {
					"a troll bomb",
					"2 troll bombs",
					"3 troll bombs",
					"4 troll bombs",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.AIRBAG_PENNY,
		Description = {
			Description = {
				"Picking up a coin knocks Isaac backwards"
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.MICRO_PENNY,
		Description = {
			Description = {
				"Picking up a coin has a 15% chance to decrease Isaac's size"
			},
			Golden = {
				TargetMultipliers = {
					"15"
				},
			},
		},
	},
	{
		ID = FiendFolio.ITEM.TRINKET.MAP_PENNY,
		Description = {
			Description = {
				"Picking up a coin has a 33% chance to reveal a random room on the map",
				"Higher value coins will reveal more rooms"
			},
			Golden = {
				TargetStrings = {
					"a random room",
					"2 random rooms",
					"3 random rooms",
					"4 random rooms",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.PRETTY_PENNY,
		Description = {
			Description = {
				"Picking up a coin has a 33% chance to spawn a Fairy Fly"
			},
			Golden = {
				TargetMultipliers = {
					"33"
				},
			},
		},
	},
	{
		ID = FiendFolio.ITEM.TRINKET.FACEBOOK_PENNY,
		Description = {
			Description = {
				"Picking up a coin has a 15% chance to grant a random familiar for the floor"
			},
			Golden = {
				TargetMultipliers = {
					"15"
				},
			},
		},
	},
	{
		ID = FiendFolio.ITEM.TRINKET.CHARITABLE_PENNY,
		Description = {
			Description = {
				"Picking up a coin has a 50% chance to add its value to the donation machine"
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {25, 50, 50, 50},
					TargetNumbers = {50},
				},
			},
		},
	},
	{
		ID = FiendFolio.ITEM.TRINKET.DEVIOUS_PENNY,
		Description = {
			Description = {
				"Picking up a coin has a 50% chance to spawn an Immoral Heart, a Spicy Key, a Copper bomb, or a Cursed Penny"
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {25, 50, 50, 50},
					TargetNumbers = {50},
				},
			},
		},
	},
	{
		ID = FiendFolio.ITEM.TRINKET.SWITCH_PENNY,
		Description = {
			Description = {
				"{{Collectible" .. FiendFolio.ITEM.COLLECTIBLE.AVGM .. "}} Picking up a coin uses A.V.G.M"
			},
			Golden = {
				TargetStrings = {
					"A.V.G.M",
					"A.V.G.M two times",
					"A.V.G.M three times",
					"A.V.G.M four times",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.POOP_PENNY,
		Description = {
			Description = {
				"Picking up a coin has a 50% chance to spawn a random Dip Familiar"
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {25, 50, 50, 50},
					TargetNumbers = {50},
				},
			},
		},
	},
	{
		ID = FiendFolio.ITEM.TRINKET.SLIPPERY_PENNY,
		Description = {
			Description = {
				"Picking up a coin causes Isaac to drop a key or bomb if owned"
			},
			Golden = {
				TargetStrings = {
					"drop a key or bomb",
					"drop a key or bomb twice",
					"drop a key or bomb three times",
					"drop a key or bomb four times",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.CANADIAN_PENNY,
		Description = {
			Description = {
				"Picking up a coin will increase its value by the Canadian exchange rate",
			},
			Conditional = function (descObj)
				local split = mod:SplitString(descObj.Description, "#")
				local lastValidLine = #split + 1

				for i, line in ipairs(split) do
					for _, blacklistedPrefix in ipairs(mod.EIDBlacklistedPrefix) do
						if line:sub(1, blacklistedPrefix:len()) == blacklistedPrefix then
							lastValidLine = i
							break
						end
					end
				end

				table.insert(split, lastValidLine, "Current rate is x" .. FiendFolio.CanadianExchangeRate)
				descObj.Description = table.concat(split, "#")
			end
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.ALPHA_PENNY,
		Description = {
			Description = {
				"{{Collectible" .. FiendFolio.ITEM.COLLECTIBLE.ALPHA_COIN .. "}} Picking up a coin has a 20% chance to use Alpha Coin"
			},
			Golden = {
				TargetMultipliers = {
					"20"
				},
			},
		},
	},
	{
		ID = FiendFolio.ITEM.TRINKET.STONE_PENNY,
		Description = {
			Description = {
				"Picking up a coin destroys a random obstacle in the room",
				"Higher value coins will break more obstacles"
			},
			Golden = {
				TargetStrings = {
					"a random obstacle",
					"2 random obstacles",
					"3 random obstacles",
					"4 random obstacles",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.RED_PENNY,
		Description = {
			Description = {
				"Picking up a coin has a 20% chance to open a random adjacent red room"
			},
			Golden = {
				TargetStrings = {
					"a random adjacent red room",
					"2 random adjacent red rooms",
					"3 random adjacent red rooms",
					"4 random adjacent red rooms",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.PUCK_PENNY,
		Description = {
			Description = {
				"Touching coins in active rooms will slide them around and cause them to do Isaac's damage to enemies"
			},
			Golden = {
				TargetStrings = {
				"to do Isaac's damage",
				"to do double Isaac's damage",
				"to do triple Isaac's damage",
				"to do quadruple Isaac's damage",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.PRISM_PENNY,
		Description = {
			Description = {
				"Picking up a coin has a 50% chance to spawn a Prism Shard that temporarily boosts a stat"
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {25, 50, 50, 50},
					TargetNumbers = {50},
				},
			},
		},
	},
	{
		ID = FiendFolio.ITEM.TRINKET.BERRY_PENNY,
		Description = {
			Description = {
				"Picking up a coin has a 50% chance to spawn a Berry pickup that grants a single use Ipecac shot"
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.CALCIUM_PENNY,
		Description = {
			Description = {
				"Picking up a coin spawns bone shards and has a 40% chance to grant a bone orbital"
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {20, 40, 80, 100},
					TargetNumbers = {40},
				},
				Description = {
					"Spawns more bone shards"
				}
			},
		},
	},
	{
		ID = FiendFolio.ITEM.TRINKET.DOG_PENNY,
		Description = {
			Description = {
				"Picking up a coin has a 15% chance to reveal the next tinted rock encountered",
				"There is another 50% chance to spawn a cosmetic dog"
			},
			Golden = {
				TargetStrings = {
				"the next tinted rock",
				"the next 2 tinted rocks",
				"the next 3 tinted rocks",
				"the next 4 tinted rocks",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.DADS_LOST_PENNY,
		Description = {
			Description = {
				"{{Collectible" .. CollectibleType.COLLECTIBLE_DADS_LOST_COIN .. "}} Picking up a coin grants +1 Luck and +2.5 Range for the room"
			},
			Golden = {
				TargetMultipliers = {
					"1",
					"2.5"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.LOADED_PENNY,
		Description = {
			Description = {
				"{{Collectible" .. FiendFolio.ITEM.COLLECTIBLE.IMP_SODA .. "}} Picking up a coin makes the next tear fired deal x3 damage"
			},
			Golden = {
				TargetStrings = {
					"next tear",
					"next two tears",
					"next three tears",
					"next four tears",
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.SUNDIAL_PENNY,
		Description = {
			Description = {
				"Picking up a coin decreases the score timer by 2 seconds",
				"The amount of seconds subtracted scales with the value of the coin"
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {1, 2, 3, 4},
					TargetNumbers = {2},
				},
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.SUICIDAL_PENNY,
		Description = {
			Description = {
				"Picking up a coin explodes Isaac"
			},
			Golden = {
				Description = {
					"Picking up a coin removes Isaac"
				}
			}
		}
	},
	{
		ID = FiendFolio.ITEM.TRINKET.BRAZILIAN_PENNY,
		Description = {
			Description = {
				"Picking up a coin has a 75% chance to spawn 3 soccer balls for a short period"
			},
			Golden = {
				TargetAdditives = {
					AdditiveValues = {25, 25, 25, 25},
					TargetNumbers = {75},
				},
			},
		},
	},

	-- Cursed Trinkets
	{
		ID = FiendFolio.ITEM.TRINKET.WIFE_HAT,
		Description = {
			Description = {
				"\2 Grants the Curse of the Veil"
			}
		}
	}
}

local function GetEidDesc(pickupVariant, id)
	if EID then
		local eidDesc = EID:getDescriptionEntryEnglish("custom", "5."..pickupVariant.."."..id)
		if eidDesc then
			return eidDesc[3]
		end
	end
end

if Encyclopedia then
	--Trinkets
	local EncycloTrinkets = {
		{ID = FiendFolio.ITEM.TRINKET.SHARD_OF_CHINA},
		{ID = FiendFolio.ITEM.TRINKET.BIFURCATED_STARS},
		{ID = FiendFolio.ITEM.TRINKET.FORTUNE_WORM},
		{ID = FiendFolio.ITEM.TRINKET.FOOLS_GOLD},
		{ID = FiendFolio.ITEM.TRINKET.EXTRA_VESSEL},
		{ID = FiendFolio.ITEM.TRINKET.HALF_VESSEL, Hide = true},
		{ID = FiendFolio.ITEM.TRINKET.FULL_VESSEL, Hide = true},
		{ID = FiendFolio.ITEM.TRINKET.CHILI_POWDER},
		{ID = FiendFolio.ITEM.TRINKET.GMO_PENNY},
		{ID = FiendFolio.ITEM.TRINKET.MOLTEN_PENNY},
		{ID = FiendFolio.ITEM.TRINKET.BLOODY_SANDPAPER},
		{ID = FiendFolio.ITEM.TRINKET.RIGHT_HAND},
		{ID = FiendFolio.ITEM.TRINKET.RED_RIBBON},
		{ID = FiendFolio.ITEM.TRINKET.FLEA_MELTDOWN},
		{ID = FiendFolio.ITEM.TRINKET.FLEA_DELUGE},
		{ID = FiendFolio.ITEM.TRINKET.FLEA_POLLUTION},
		{ID = FiendFolio.ITEM.TRINKET.FLEA_PROPAGANDA},
		{ID = FiendFolio.ITEM.TRINKET.FUZZY_PENNY},
		{ID = FiendFolio.ITEM.TRINKET.FORTUNE_GRUB},
		{ID = FiendFolio.ITEM.TRINKET.CHUNK_OF_TAR},
		{ID = FiendFolio.ITEM.TRINKET.YIN_YANG_ORB},
		{ID = FiendFolio.ITEM.TRINKET.SWALLOWED_M90},
		{ID = FiendFolio.ITEM.TRINKET.TRINITY_WORM},
		{ID = FiendFolio.ITEM.TRINKET.JIGSAW_PUZZLE_BOX},
		{ID = FiendFolio.ITEM.TRINKET.IOU},
		{ID = FiendFolio.ITEM.TRINKET.AUTOPSY_KIT},
		{ID = FiendFolio.ITEM.TRINKET.SPIRE_GROWTH},
		{ID = FiendFolio.ITEM.TRINKET.FLEA_CIRCUS},
		{ID = FiendFolio.ITEM.TRINKET.SHARP_PENNY},
		{ID = FiendFolio.ITEM.TRINKET.ANGRY_FAIC},
		{ID = FiendFolio.ITEM.TRINKET.POCKET_DICE},
		{ID = FiendFolio.ITEM.TRINKET.LOCKED_SHACKLE},
		{ID = FiendFolio.ITEM.TRINKET.JEVILSTAIL},
		{ID = FiendFolio.ITEM.TRINKET.DEALMAKERS},
		{ID = FiendFolio.ITEM.TRINKET.SOLEMN_VOW},
		{ID = FiendFolio.ITEM.TRINKET.MASSIVE_AMETHYST},
		{ID = FiendFolio.ITEM.TRINKET.LOST_FLOWER_CROWN},
		{ID = FiendFolio.ITEM.TRINKET.ETERNAL_CAR_BATTERY},
		{ID = FiendFolio.ITEM.TRINKET.PETRIFIED_GEL},
		{ID = FiendFolio.ITEM.TRINKET.HATRED},
		{ID = FiendFolio.ITEM.TRINKET.FROG_PUPPET},
		{ID = FiendFolio.ITEM.TRINKET.TATTERED_FROG_PUPPET, Hide = true},
		{ID = FiendFolio.ITEM.TRINKET.WACKEY},
		{ID = FiendFolio.ITEM.TRINKET.HEARTACHE},
		{ID = FiendFolio.ITEM.TRINKET.REDHAND},
		{ID = FiendFolio.ITEM.TRINKET.MIDDLE_HAND},
		{ID = FiendFolio.ITEM.TRINKET.RAINBOW_BEAN},
		{ID = FiendFolio.ITEM.TRINKET.FAULTY_FUSE},
		{ID = FiendFolio.ITEM.TRINKET.CURSED_URN},
		{ID = FiendFolio.ITEM.TRINKET.SHATTERED_CURSED_URN, Hide = true},
		{ID = FiendFolio.ITEM.TRINKET.CONJOINED_CARD},
		{ID = FiendFolio.ITEM.TRINKET.ENERGY_SEARCHER},
		{ID = FiendFolio.ITEM.TRINKET.BROKEN_RECORD},
		{ID = FiendFolio.ITEM.TRINKET.FUZZY_PICKLE},
		{ID = FiendFolio.ITEM.TRINKET.FUSHIGI},
		{ID = FiendFolio.ITEM.TRINKET.NESTING_DOLL},
		{ID = FiendFolio.ITEM.TRINKET.EGG_PENNY},
		{ID = FiendFolio.ITEM.TRINKET.LEFTOVERS},
		{ID = FiendFolio.ITEM.TRINKET.DUDS_FLOWER},
		{ID = FiendFolio.ITEM.TRINKET.BOMB_TOKEN},
		{ID = FiendFolio.ITEM.TRINKET.QUALITY_ASSURANCE},
		{ID = FiendFolio.ITEM.TRINKET.CERBERUS_ORB},
		{ID = FiendFolio.ITEM.TRINKET.BONE_LORDS_TABLET},
		{ID = FiendFolio.ITEM.TRINKET.SCARAB_PENNY},
		{ID = FiendFolio.ITEM.TRINKET.TAN_WORM},
		{ID = FiendFolio.ITEM.TRINKET.PINCUSHION},
		{ID = FiendFolio.ITEM.TRINKET.ADBLOCKER},
		{ID = FiendFolio.ITEM.TRINKET.GODHEADJR},
		{ID = FiendFolio.ITEM.TRINKET.BUTTON_MASHER},
		{ID = FiendFolio.ITEM.TRINKET.FLAMING_PENNY},
		{ID = FiendFolio.ITEM.TRINKET.PENNY_PACK},
		{ID = FiendFolio.ITEM.TRINKET.IMP_FINGER},
		{ID = FiendFolio.ITEM.TRINKET.STACK_OF_PENNY},
	}

	for _, info in pairs(EncycloTrinkets) do
		Encyclopedia.AddTrinket({
			Class = "Fiend Folio",
			ID = info.ID,
			WikiDesc = Encyclopedia.EIDtoWiki(__eidTrinketDescriptions[info.ID] or GetEidDesc(PickupVariant.PICKUP_TRINKET, info.ID) or "???"),
			UnlockFunc = function(self)
				if FiendFolio.IsTrinketLocked(info.ID) then
					self.Desc = "Locked!"
					return self
				end
			end,
			Hide = info.Hide,
			ModName = "Fiend Folio",
		})
	end
end