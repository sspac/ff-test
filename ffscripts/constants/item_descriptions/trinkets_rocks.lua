local mod = FiendFolio

FiendFolio.ExternalDescriptions.Rocks = {
	{
        ID = FiendFolio.ITEM.ROCK.DIRT_CLUMP,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{ffGrind}} {{ColorTransform}}Grind effect",
                "Can be grinded in the Mining Machine for free"
            },
            NoOverclockEffect = true
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.ROLLING_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↑ +0.05 Speed after clearing a room without taking damage",
                "Taking damage resets this bonus"
            },
            Golden = {
                TargetMultipliers = {
                    0.05
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.POCKET_SAND,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Does nothing"
            },
            NoOverclockEffect = true
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.ROUGH_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{ffGrind}} {{ColorTransform}}Grind effect",
                "Grinding this rock in the Mining Machine gives a rarer rock trinket"
            },
            Golden = {
                Description = {
                    "Given rock trinket is Golden"
                },
                GoldOnly = true
            },
            NoOverclockEffect = true,
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.BLOODY_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Every 4th tear fired becomes a double damage blood tear"
            },
            Golden = {
                TargetStrings = {
                    "4th", -- String to replace
                    -- Below are the strings for each multiplier
                    "2nd",
                    "2nd",
                    "1st",
                    "1st"
                },
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.SPIKED_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Deals damage to Isaac upon first pickup",
                "{{Warning}} This damage will not kill Isaac",
                "Blocks damage from spikes and spiked chests"
            },
            NoOverclockEffect = true,
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.SLIPPY_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↑ +0.15 Speed",
                "Friction down"
            },
            Golden = {
                TargetMultipliers = {
                    0.15
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.ARCANE_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "5% chance for tears to turn into high damaging homing shots",
                "{{Luck}} 20% chance at 8 luck"
            },
            Golden = {
                TargetMultipliers = {
                    20
                },
                Description = {
                    "Tears deal even more damage"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.MINERAL_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "When pressing against a rock:",
                "↑ +0.2 Speed",
                "↑ +1.5 Damage",
                "↑ +0.72 Tears",
                "↑ +1 Range",
                "↑ +0.2 Shot speed",
                "↑ +4 Luck"
            },
            Golden = {
                TargetMultipliers = {
                    0.2,
                    1.5,
                    0.72,
                    1,
                    0.2,
                    4,
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.THORNY_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Spawns a radial shockwave when Isaac is damaged"
            },
            Golden = {
                Description = {
                    "Shockwave radius is increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.TIME_LOST_DIAMOND,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Collectible422}} Brings Isaac back to the previous room and reverses all actions done in the room when they are hit",
                "If hit in the same room again, the rock trinket will not activate"
            },
            NoOverclockEffect = true
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.OBSIDIAN_GRINDSTONE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↑ +2.5 Damage",
                "↑ +0.36 Tears",
                "Stats double when holding another rock trinket",
                "Every 10 tears shot will reroll the other held rock trinket, if applicable",
                "{{Trinket" ..
                    FiendFolio.ITEM.ROCK.POCKET_SAND ..
                        "}} 15% chance for the other held trinket to turn into Pocket Sand"
            },
            Golden = {
                TargetMultipliers = {
                    2.5,
                    0.36,
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.GODS_MARBLE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "3% chance to shoot a yellow spectral tear that leaves a holy aura on the ground",
                "When an enemy touches the aura, 9 light beams damage them",
                "{{Damage}} The beams deals 2.5 damage per tick",
                "{{Luck}} 40% chance at 37 luck"
            },
            Golden = {
                TargetMultipliers = {
                    40,
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.TWENTY_SIDED_EMERALD,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Timer}} Standing still near a pickup rerolls it every 3 seconds",
                "Any individual pickup can only be rerolled up to 3 times"
            },
            Golden = {
                TargetStrings = {
                    "3 times", -- String to replace
                    -- Below are the strings for each multiplier
                    "4 times",
                    "5 times",
                    "6 times",
                    "7 times",
                },
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.TECHNOLOGICAL_RUBY_2,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Grants 2 laser rings at Isaac's position",
                "The inner ring deals 0.1x Isaac's damage",
                "The outer ring deals 0.25x Isaac's damage"
            },
            Golden = {
                -- Using TargetStrings here because TargetNumbers just can't work with how EID sets up Golden trinkets.
                TargetStrings = {
                    "2", -- String to replace
                    -- Below are the strings for each multiplier
                    "3", -- 2x
                    "3", -- 3x
                    "3", -- 4x
                    "3", -- 5x (max, only visible with Mom's Box held + Golden trinket + Overclock held)
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.LEAKY_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Isaac leaves a trail of stationary tears while they move"
            },
            Golden = {
                Description = {
                    "Stationary tears appear more often"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.TWIN_TUFFS,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "25% chance to turn pickups into their doubled equivalent",
                "{{Luck}} 100% chance at 30 luck",
                "15% chance to double room rewards",
                "{{Luck}} 100% chance at 57 luck"
            },
            Golden = {
                TargetMultipliers = {25}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.WETSTONE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Spawns 7 bubbles when entering a room",
                "Taking damage spawns 10 more bubbles"
            },
            Golden = {
                TargetAdditives = {
                    TargetNumbers = {7, 10},
                    AdditiveValues = {1, 2, 3, 4},
                },
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.STROMATOLITE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{HalfHeart}} Rocks have a 2.5% chance to drop a half heart when broken",
                "{{HalfSoulHeart}} Tinted rocks have a 25% chance to drop an additional half soul heart"
            },
            Golden = {
                TargetMultipliers = {
                    2.5,
                    25
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.RIBBED_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{EmptyBoneHeart}} Grants a bone heart on first pickup",
                "{{BoneHeart}} Health upgrades grant bone hearts instead of heart containers"
            },
            Golden = {
                Description = {
                    "Health upgrades grant an additional bone heart"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.FIENDISH_AMETHYST,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Spawns 4 Amethyst Fiend Minions when entering an uncleared room"
            },
            Golden = {
                TargetAdditives = {
                    TargetNumbers = {4},
                    AdditiveValues = {2, 4, 6, 8},
                },
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.STURDY_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{SoulHeart}} +1 Soul Heart when entering a new floor"
            },
            Golden = {
                TargetStrings = {
                    "+1 Soul Heart",
                    "+2 Soul Hearts",
                    "+2 Soul Hearts",
                    "+2 Soul Hearts",
                    "+2 Soul Hearts",
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.BRICK_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Lets Isaac fire a 15 damage brick tear when picked up",
                "Isaac can pick it up after firing and throw it again"
            },
            Golden = {
                TargetMultipliers = {
                    "15"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.SAPPHIC_SAPPHIRE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Charm}} Charms female enemies",
                "{{Freezing}} 8% chance to fire slowing and freezing tears",
                "{{Luck}} 33% chance at 8 luck"
            },
            Golden = {
                TargetMultipliers = {8}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.BLOOD_DIAMOND,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Spawns blood creep when Isaac takes damage",
                "{{BleedingOut}} 10% chance to fire tears that inflict bleed",
                "{{Luck}} 40% chance at 8 luck",
            },
            Golden = {
                TargetStrings = {
                    "10",
                    "20",
                    "30",
                    "40",
                    "50"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.SCENTED_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Charm}} Charms enemies in a short radius around Isaac"
            },
            Golden = {
                Description = {
                    "Charm radius and duration increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.ARCADE_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Slotmachine}} 25% chance for slot machines to be free",
                "{{Luck}} 66% chance at 17 luck"
            },
            Golden = {
                TargetStrings = {
                    "25",
                    "50",
                    "75",
                    "100",
                    "100"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.TINTED_HEART,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Heart}} 20% chance to drop a red heart when taking damage",
                "When taking explosive damage, 35% chance to drop a:",
                "{{SoulHeart}} Soul heart",
                "{{Bomb}} Bomb",
                "{{Key}} Key",
                "{{Chest}} Chest"
            },
            Golden = {
                TargetStrings = {
                    "20",
                    "40",
                    "60",
                    "80",
                    "100"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.ROSE_QUARTZ,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Taking damage grants a temporary shield for 6 seconds that can block one projectile",
                "Taking contact damage refreshes the duration"
            },
            Golden = {
                TargetMultipliers = {
                    "6"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.HAILSTONE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Slow}} Enemies near Isaac are slowed",
                "{{Freezing}} Enemies within a short radius of Isaac freeze when killed"
            },
            Golden = {
                Description = {
                    "Slowness radius and strength increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.RAMBLIN_OPAL,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Charm}} Spawns friendly Shiitake Spores in uncleared rooms, with a maximum of 3 out at a time"
            },
            Golden = {
                TargetAdditives = {
                    TargetNumbers = {3},
                    AdditiveValues = {1,2,3,4},
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.SAND_DOLLAR,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Coin}} Dropping the trinket in a {{Shop}} Shop exchanges it for 10-20 coins"
            },
            Golden = {
                Description = {
                    "Drops extra coins"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.HENGE_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Trinket}} Increases the power of held Rock Trinkets by 30%"
            },
            Golden = {
                TargetStrings = {
                    "30",
                    "60",
                    "90",
                    "120",
                    "150"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.SALT_LAMP,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Repels nearby enemies and projectiles, but slowly drains in power over time",
                "{{Battery}} Can be recharged with batteries",
                "Recharges on new floors"
            },
            Golden = {
                Description = {
                    "Repelling aura duration increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.MOLTEN_SLAG,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Burning}} 2% chance to burn nearby enemies every frame",
                "{{ffGrind}} {{ColorTransform}}Grind effect",
                "When grinded in the Mining Machine, smelts other held trinket"
            },
            Golden = {
                Description = {
                    "Increased burn chance, radius, damage, and duration"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.THUNDER_EGG,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↓ -0.1 Speed",
                "Each room has a 6% chance for the Thunder Egg to crack open into another a higher quality rock",
                "The chance increases each room, up to 50%",
            },
            Golden = {
                Description = {
                    "Increased chance and quality"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.UNOBTAINIUM,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Completely unobtainable, don't even try!"
            },
            Golden = {
                Description = {
                    "Even more unobtainable!"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.SANDSTONE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Confusion}} 20% chance to fire a rock that inflicts confusion and does x4 damage, but shrinks over time",
                "{{Luck}} 100% chance at 27 luck",
                "{{Trinket" ..
                    FiendFolio.ITEM.ROCK.POCKET_SAND .. "}} Turns into Pocket Sand when taking explosive damage"
            },
            Golden = {
                TargetStrings = {
                    "20",
                    "30",
                    "40",
                    "50",
                    "60"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.FAKE_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Key}} Spawns a key on pickup",
                "If there is a locked door in the room, the first broken rock drops a key"
            },
            Golden = {
                TargetStrings = {
                    "drops a key",
                    "drops a keyring",
                    "drops a keyring",
                    "drops a keyring",
                    "drops a keyring",
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.CITRINE_PULP,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "20% chance to fire a short ranged splash of tears",
                "{{Luck}} 50% chance at 15 luck",
                "When enemies are close, small chance to create a puddle of creep"
            },
            Golden = {
                Description = {
                    "Increased chance and amount for splashes of tears"
                },
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.BLOODSTONE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↑ +0.2 Damage for each enemy killed in the room",
                "↑ +1 Damage when taking damage",
                "Damage bonuses decay over time"
            },
            Golden = {
                TargetMultipliers = {0.2, 1}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.EMETIC_ANTIMONY,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Collectible149}} Isaac can fire an Ipecac shot every 15 seconds"
            },
            Golden = {
                TargetAdditives = {
                    TargetNumbers = {15},
                    AdditiveValues = {-2, -4, -6, -8},
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.DOUBLE_RUBBLE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{ffGrind}} {{ColorTransform}}Grind effect",
                "Grinding this rock in the Mining Machine gives two common or rare rocks"
            },
            Golden = {
                Description = {
                    "Rocks are golden"
                },
                GoldOnly = true,
            },
            NoOverclockEffect = true
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.ROCK_FROM_AN_ABYSS,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "20% chance to apply Doom to 3 enemies at the start of the room",
                "{{Luck}} 100% chance at 27 luck",
            },
            StatusEffects = {mod.DescriptionStatuses.DOOM},
            Golden = {
                TargetStrings = {
                    "20",
                    "40",
                    "60",
                    "80",
                    "100"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.HECTOR,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↑ +1 Damage",
                "↑ +0.27 Tears",
                "↓ -0.1 Speed",
                "Forcibly dropped when taking damage"
            },
            Golden = {
                TargetMultipliers = {1, 0.27, 0.1}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.VESSEL_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{EmptyHeart}} Stores an extra heart",
                "{{DevilChance}} Does not count against Devil Deal chance",
                "Breaks when taking damage while empty"
            }
        },
        NoOverclockEffect = true,
    },
    {
        ID = FiendFolio.ITEM.ROCK.HALF_VESSEL_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{HalfHeart}} Stores an extra heart",
                "{{DevilChance}} Does not count against Devil Deal chance",
                "Breaks when taking damage while empty"
            }
        },
        NoOverclockEffect = true,
    },
    {
        ID = FiendFolio.ITEM.ROCK.FULL_VESSEL_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Heart}} Stores an extra heart",
                "{{DevilChance}} Does not count against Devil Deal chance",
                "Breaks when taking damage while empty"
            }
        },
        NoOverclockEffect = true,
    },
    {
        ID = FiendFolio.ITEM.ROCK.CONSTANT_ROCK_SHOOTER,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↑ +0.8 Tears",
                "Isaac never stops firing"
            },
            Golden = {
                Description = {
                    "Tears increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.ROBOT_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Grants Isaac 2 short ranged spinning lasers that inflict random status effects"
            },
            Golden = {
                TargetAdditives = {
                    TargetNumbers = {2},
                    AdditiveValues = {0, 1, 2, 3},
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.ROCK_CANDY,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "15% chance to fire a crystal tear that charms and deal x1.5 damage",
                "{{Luck}} 100% chance at 27 luck",
                "{{HalfHeart}} Enemies have a 15% chance to drop a pink half red heart on death that disappears after 2 seconds",
                "{{Luck}} 40% chance at 25 luck"
            },
            Golden = {
                Description = {
                    "Increased chance for crystal tears and pink half red hearts",
                    "Pink half red hearts last longer"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.KEYSTONE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Key}} Whenever Isaac uses a key:",
                "↑ +0.1 Speed",
                "↑ +0.1 Tears",
                "Stats disappears upon entering a new floor"
            },
            Golden = {
                TargetMultipliers = {0.1}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.SILVER_TONGUE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{ffGrind}} The Mining Machine costs 1 less cent"
            },
            Golden = {
                TargetMultipliers = {1}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.MEAT_SLAB,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Isaac constantly sweats out arced tears",
                "{{Heart}} Sweating rate increases based on how low Isaac's HP is"
            },
            Golden = {
                Description = {
                    "Sweat damage is increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.SHEEP_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "7% chance to fire a tear that decelerates and inflicts Drowsy",
                "{{Luck}} 100% chance at 47 luck",
			},
            Golden = {
                TargetMultipliers = {7}
            },
			StatusEffects = { FiendFolio.DescriptionStatuses.DROWSY_AND_SLEEP },
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.REBELLION_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Taking damage knocks away nearby enemies and deals 2x Isaac's damage",
                "Enemies knocked away also become Bruised",
            },
            StatusEffects = {
                mod.DescriptionStatuses.BRUISE
            },
            Golden = {
                TargetMultipliers = {2}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.DADS_LEGENDARY_GOLDEN_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{ffGrind}} {{ColorTransform}}Grind effect",
                "Always spawns a rare or better golden trinket when grinded in the Mining Machine"
            },
            NoOverclockEffect = true
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.BEDROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "33% chance for a bed to spawn at the start of every floor"
            },
            Golden = {
                TargetMultipliers = {"33"}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.SHEETROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Heart}} Heals 2 hearts at the start of each floor",
                "{{SoulHeart}} Sleeping in a bed grants 2 extra Soul Hearts"
            },
            Golden = {
                TargetAdditives = {
                    AdditiveValues = {2, 4, 6, 8},
                    TargetNumbers = {2},
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.FETAL_STONE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Spawns a Golem baby familiar",
                "Deals 5 damage per tear",
                "{{Confusion}} These tears have increased knockback and a 20% chance to confuse enemies"
            },
            Golden = {
                TargetMultipliers = {5},
                Description = {
                    "Familiar shoots faster"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.GRIMACE_ROCK1,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Fires tears at nearby enemies",
                "Tears deal Isaac's damage",
                "Still fires tears when dropped on the ground"
            },
            Golden = {
                Description = {
                    "Tears damage is increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.GRIMACE_ROCK2,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Fires powerful explosive shots at nearby enemies that deal 10 + Isaac's damage",
                "Still fires tears when dropped on the ground",
                "Explosive shots don't hurt Isaac"
            },
            Golden = {
                Description = {
                    "Tears damage is increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.GRIMACE_ROCK3,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Passively spawns small bubbles that block projectiles",
                "Bubbles do 2.62 damage",
                "Still fires bubbles when dropped on the ground"
            },
            Golden = {
                Description = {
                    "Bubble rate is increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.GRIMACE_ROCK4,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Constantly fires tears in a random cardinal direction that deal Isaac's damage",
                "Still fires tears when dropped on the ground"
            },
            Golden = {
                Description = {
                    "Tears damage is increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.GRIMACE_ROCK5,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Sucks in all enemies towards Isaac every 2 seconds",
                "Still sucks when dropped on the ground"
            },
            NoOverclockEffect = true
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.GRIMACE_ROCK6,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Periodically fires brimstone beams in a random cardinal direction that deal 0.66x Isaac's damage",
                "Still fires beams when dropped on the ground"
            },
            Golden = {
                TargetMultipliers = {66}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.GRIMACE_ROCK7,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Constantly fires tears in + and x shaped pattern that deal Isaac's damage",
                "Still fires tears when dropped on the ground"
            },
            Golden = {
                Description = {
                    "Tears damage is increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.GRIMACE_ROCK8,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Constantly fires a rotating laser that deals 0.66x Isaac's damage",
                "Still fires lasers when dropped on the ground"
            },
            Golden = {
                TargetMultipliers = {66}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.GRIMACE_ROCK9,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Charm}} Spawns a friendly copy of an enemy in the room",
                "Copied enemies disappear upon leaving the room",
                "Still spawns copies when dropped on the ground"
            },
            Golden = {
                Description = {
                    "Copied enemy health is increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.GRIMACE_ROCK10,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Constantly sucks in pickups",
                "Still sucks in pickups when dropped on the ground"
            },
            NoOverclockEffect = true
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.GRIMACE_ROCK11,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Fires a triple shot at nearby enemies that deals Isaac's damage",
                "Still fires tears when dropped on the ground"
            },
            Golden = {
                Description = {
                    "Tears damage is increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.GRIMACE_ROCK12,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Walking in a set direction causes the grimace to fire in that direction",
                "Tears scale with Isaac's damage",
                "Still fires tears when dropped on the ground"
            },
            Golden = {
                Description = {
                    "Tears damage is increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.FOCUS_CRYSTAL,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Enemies that are within {{ColorYellow}} 2.5 tiles {{ColorWhite}}take{{ColorYellow}} 20%{{ColorWhite}} extra damage {{ColorGray}}(+20% per stack)"
            },
            Golden = {
                TargetMultipliers = {20}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.ODDLY_SMOOTH_STONE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Start each combat with {{ColorCyan}}1{{CR}} {{ColorYellow}}Dexterity{{CR}}",
                "{{Heart}} All Red Hearts heal an additional half a heart"
            },
            Golden = {
                Description = {
                    "Healing is increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.MOONSTONE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "When entering any type of {{SecretRoom}} Secret Room, Isaac gains one of the following chosen at random:",
                "↑ +0.3 Tears",
                "↑ +0.38 Range",
                "↑ +0.3 Shot speed",
                "↑ +1 Luck"
            },
            Golden = {
                TargetMultipliers = {0.3, 0.38, 0.3, 1}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.LIMESTONE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Leaves a trail of lime creep that deals 0.5x Isaac's damage",
                "Permanently charms citrus related enemies",
                "33% chance for Sourpatch enemies to be replaced with Limepatches"
            },
            Golden = {
                TargetMultipliers = {33, 50}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.CARNAL_CARNELIAN,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↑ Gain damage and speed that scales with how close Isaac is to enemies"
            },
            Golden = {
                Description = {
                    "Increased damage, speed, and area of effect"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.REBAR_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Heart}} 25% chance to block Red Heart damage",
                "{{HalfHeart}} Red Heart damage is always half a heart"
            },
            Golden = {
                TargetStrings = {
                    "25",
                    "50",
                    "50",
                    "50",
                    "50"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.DOGROCK_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↓ -100 Luck",
                "Distorts the screen and music",
                "{{Slow}} Slows enemies in a small radius around Golem"
            },
            Golden = {
                TargetMultipliers = {
                    "100"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.STALACTITE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Explosions will cause rocks to fall from the ceiling",
                "Ceiling rocks deal 2x Isaac's damage",
                "Prevents damage from falling projectiles"
            },
            Golden = {
                Description = {
                    "Amount of falling rocks increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.CAST_GEM,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Grants a homing gem that can be cast while attacking that sticks to enemies, inflicting damage and bruising",
            },
            StatusEffects = {
                mod.DescriptionStatuses.BRUISE
            },
            Golden = {
                TargetStrings = {
                    "a homing gem",
                    "2 homing gems",
                    "3 homing gems",
                    "4 homing gems",
                    "5 homing gems"
                },
            },
            NoOverclockEffect = true,
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.SHARD_OF_GOLGOTHA,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Collectible722}} Chains the enemy with the highest health at the start of every room for 7 seconds",
                "Chained enemies cannot move or attack"
            },
            Golden = {
                TargetMultipliers = {7}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.SMOKY_QUARTZ,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Timer}} Taking damage grants a temporary speed boost and confuses nearby enemies for 7 seconds"
            },
            Golden = {
                Description = {
                    "Area of effect increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.TWINKLING_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{ffGrind}} {{ColorTransform}}Grind effect",
                "Grinding this rock in the Mining Machine gives a common or rare geode"
            },
            Golden = {
                Description = {
                    "Given rock trinket is Golden"
                },
                GoldOnly = true
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.ROCK_CAKE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{ffGrind}} {{ColorTransform}}Grind effect",
                "Grinding other rocks in the Mining Machine heals a half Red Heart"
            },
            Golden = {
                TargetStrings = {
                    "a half Red Heart",
                    "one Red Heart",
                    "one and a half Red Hearts",
                    "2 Red Hearts",
                    "2 and a half Red Hearts"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.CHARCOAL,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "15% chance to fire a very slow tear that deals more damage the further it travels",
                "{{Luck}} 50% chance at 43 luck"
            },
            Golden = {
                TargetAdditives = {
                    TargetNumbers = {15},
                    AdditiveValues = {5, 10, 15, 20}
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.KNIFE_PEBBLE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↑ +1 Damage"
            },
            Golden = {
                TargetMultipliers = {1}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.TEARDROP_PEBBLE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↑ +0.4 Tears"
            },
            Golden = {
                TargetMultipliers = {0.4}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.ARROW_PEBBLE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↑ +1.25 Range",
                "↑ +0.2 Shot speed"
            },
            Golden = {
                TargetMultipliers = {1.25, 0.2}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.CLOVER_PEBBLE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↑ +2 Luck"
            },
            Golden = {
                TargetMultipliers = {2}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.SHOE_PEBBLE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↑ +0.3 Speed"
            },
            Golden = {
                TargetMultipliers = {0.3}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.FRUITY_PEBBLE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↑ +0.15 Speed",
                "↑ +0.15 Tears",
                "↑ +0.3 Damage",
                "↑ +0.75 Range",
                "↑ +0.18 Shot speed",
                "↑ +1 Luck"
            },
            Golden = {
                TargetMultipliers = {0.15, 0.3, 0.75, 0.18, 1}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.MIXED_PEBBLE_1,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↑ +0.15 Speed",
                "↑ +0.5 Damage"
            },
            Golden = {
                TargetMultipliers = {0.15, 0.5}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.MIXED_PEBBLE_2,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↑ +0.15 Speed",
                "↑ +1 Luck"
            },
            Golden = {
                TargetMultipliers = {0.15, 1}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.MIXED_PEBBLE_3,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↑ +0.15 Tears",
                "↑ +1 Luck"
            },
            Golden = {
                TargetMultipliers = {0.15, 1}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.MIXED_PEBBLE_4,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↑ +0.75 Range",
                "↑ +0.5 Damage"
            },
            Golden = {
                TargetMultipliers = {0.75, 0.5}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.MIXED_PEBBLE_5,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↑ +0.75 Range",
                "↑ +1 Luck"
            },
            Golden = {
                TargetMultipliers = {0.75, 1}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.MIXED_PEBBLE_6,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↑ +0.15 Speed",
                "↑ +0.75 Range"
            },
            Golden = {
                TargetMultipliers = {0.15, 0.75}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.ACHILLES_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Enemies gain a random weak point aligned with a random direction",
                "When damaged from that direction, they take x1.5 damage"
            },
            Golden = {
                TargetAdditives = {
                    AdditiveValues = {0.5, 1, 1.5, 2},
                    TargetNumbers = {1.5},
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.ELECTRUM,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Using an active item shocks nearby enemies",
                "Damage scales with charge amount and Isaac's damage",
                "Effects vary on Isaac's active item"
            },
            Golden = {
                Description = {
                    "Shock damage increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.PURE_QUARTZ,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{SoulHeart}} If Isaac loses all of his Soul Hearts:",
                "{{Collectible313}} Gain a Holy Mantle shield",
                "{{Timer}} Become invincible for 10 seconds"
            },
            Golden = {
                TargetMultipliers = {10}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.AMAZONITE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "The first purchase in a {{Shop}} Shop is heavily discounted",
                "After purchasing an item, it will disappear and spawn on the next floor"
            },
            Golden = {
                TargetStrings = {
                    "first purchase",
                    "first and second purchase",
                    "first, second, and third purchase",
                    "first, second, third, and fourth purchase",
                }
            },
            NoOverclockEffect = true
        },
    },
    {
        ID = FiendFolio.ITEM.ROCK.STAR_SAPPHIRE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Spawns a wobbly orbital familiar that points towards the nearest enemy or projectile",
                "Blocks shots and deals 0.5x Isaac's damage"
            },
            Golden = {
                TargetMultipliers = {0.5}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.GRAVESTONE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Taking damage spawns either:",
                "{{Collectible634}} A homing exploding ghost",
                "{{Collectible684}} A ghost which chases enemies, dealing contact damage and exploding after 3 seconds",
                "15% chance for either ghost to appear when destroying rocks"
            },
            Golden = {
                -- A long description like this is not ideal, but you can't replace strings and do additive values and multipliers with EID :(
                Description = {
                    "More homing ghosts are spawned at once",
                    "Chasing ghosts last longer",
                    "Higher chance for either ghost to appear when breaking rocks"
                },
                TargetMultipliers = {3},
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.SAND_CASTLE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Trinket" ..
                    FiendFolio.ITEM.ROCK.POCKET_SAND .. "}} Negates 3 hits of damage before turning into Pocket Sand"
            },
            Golden = {
                TargetAdditives = {
                    AdditiveValues = {1, 1, 1, 1},
                    TargetNumbers = {3}
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.DAMAGED_SAND_CASTLE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Trinket" ..FiendFolio.ITEM.ROCK.POCKET_SAND .. "}} Negates 2 hits of damage before turning into Pocket Sand"
            },
            Golden = {
                TargetAdditives = {
                    AdditiveValues = {1, 1, 1, 1},
                    TargetNumbers = {2}
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.BROKEN_SAND_CASTLE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Trinket" ..FiendFolio.ITEM.ROCK.POCKET_SAND .. "}} Negates 1 hit of damage before turning into Pocket Sand",
            },
            Golden = {
                TargetAdditives = {
                    AdditiveValues = {1, 1, 1, 1},
                    TargetNumbers = {1}
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.GUARDED_GARNET,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "30% chance to gain a shield on damage that lasts for a room and blocks one hit",
                "{{Luck}} 100% chance at 35 luck",
                "Enemies are knocked back when the shield is broken"
            },
            Golden = {
                TargetAdditives = {
                    AdditiveValues = {10, 20, 30, 40},
                    TargetNumbers = {30}
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.SHAMROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↑ +5 Luck",
                "↓ When taking damage, Isaac loses 1 luck for the floor"
            },
            Golden = {
                Description = {
                    "Damage required to lose luck is increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.GAS_POCKET,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Poison}} Rocks have a 10% chance to spawn poisonous gas every 4 seconds",
                "35% chance for rocks to spawn large poison gas clouds when broken",
                "{{Luck}} 100% chance at 65 luck",
                "The poison gas can't hurt Isaac"
            },
            Golden = {
                Description = {
                    "Poison gas lasts longer"
                },
                TargetAdditives = {
                    AdditiveValues = {10, 20, 30, 40},
                    TargetNumbers = {35}
                },
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.SOAP_STONE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Clears all projectiles on room clear and when taking damage",
                "Spawns 3 bubbles upon taking damage"
            },
            Golden = {
                TargetAdditives = {
                    AdditiveValues = {1, 2, 3, 4},
                    TargetNumbers = {3},
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.SPIRIT_URN,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Spawns 3 wisps when entering a {{BossRoom}} Boss or {{MiniBoss}} Miniboss room",
                "Spawns 3 wisps when starting a {{ChallengeRoom}} Challenge Room"
            },
            Golden = {
                TargetAdditives = {
                    AdditiveValues = {1, 2, 3, 4},
                    TargetNumbers = {3}
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.SUN_SHARD,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Spawns a random organ orbital each room that deals 0.5x Isaac's damage and blocks shots",
                "Organs have special effects when hit by projectiles"
            },
            Golden = {
                TargetStrings = {
                    "a random organ orbital",
                    "2 random organ orbitals",
                    "3 random organ orbitals",
                    "4 random organ orbitals",
                    "5 random organ orbitals",
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.STEADFAST_STONE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "When taking fatal damage, Isaac crushes another rock trinket they are holding to prevent death",
                "Also spawns a Soul heart"
            },
            Golden = {
                TargetStrings = {
                    "a Soul heart",
                    "2 Soul hearts",
                    "3 Soul hearts",
                    "4 Soul hearts",
                    "5 Soul hearts"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.RAI_STONE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Coin}} 15% chance for enemies to drop a stone penny on death",
                "The stone pennies disappear after 2.5 seconds"
            },
            Golden = {
                TargetMultipliers = {15}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.ORE_PENNY,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Coin}} Picking up a coin has a 50% chance to add another coin to the counter",
                "3% chance to convert normal rocks into Fool's Gold rocks"
            },
            Golden = {
                TargetMultipliers = {3},
                TargetStrings = {
                    "another coin",
                    "another 2 coins",
                    "another 3 coins",
                    "another 4 coins",
                    "another 5 coins"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.HEAVY_METAL,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↓ -0.15 Speed",
                "Grants damage and a chance to prevent damage depending on how slow Isaac is"
            },
            Golden = {
                Description = {
                    "More damage",
                    "Higher chance to prevent damage"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.GROSSULAR,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Periodically fire a pulse that either {{Fear}} Fears, {{Poison}} Poisons, or {{Confusion}} Confuses nearby enemies"
            },
            Golden = {
                Description = {
                    "Enemies are inflicted with more status effects at once"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.SULFUR_CRYSTAL,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Timer}} {{Collectible118}} Grants Brimstone at the start of every 4th room"
            },
            Golden = {
                TargetStrings = {
                    "4th room",
                    "3rd room",
                    "other room",
                    "single room",
                    "single room"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.TROLLITE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "We do a little trolling"
            },
            Golden = {
                Description = {
                    "It's called we do a little bit of trolling"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.THROWLOMITE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Every 1.67 seconds, throws a stone at a nearby enemy that scales with Isaac's damage"
            },
            Golden = {
                Description = {
                    "Throws more often for more damage"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.HEARTHSTONE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Triggers a random beneficial effect whenever a card is used"
            },
            Golden = {
                TargetStrings = {
                    "a random beneficial effect",
                    "2 random beneficial effects",
                    "3 random beneficial effects",
                    "4 random beneficial effects",
                    "5 random beneficial effects"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.MAGNETIC_SAND,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↑ +0.45 Tears",
                "↓ -0.35 Damage",
                "{{Magnetize}} 10% chance to shoot magnetizing tears",
                "{{Luck}} 50% chance at 20 luck"
            },
            Golden = {
                TargetAdditives = {
                    TargetNumbers = {10},
                    AdditiveValues = {10, 20, 30, 40}
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.INSATIABLE_APATITE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↑ Gain a temporary damage up when picking up hearts",
                "{{Heart}} Hearts can be consumed while at full health to increase the damage",
                "Certain types of hearts have additional effects when consumed"
            },
            NoOverclockEffect = true
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.POWER_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Battery}} Breaking rocks has a 5% chance to add 1 charge to the active item",
                "{{Luck}} 25% chance at 20 luck"
            },
            Golden = {
                TargetAdditives = {
                    TargetNumbers = {5},
                    AdditiveValues = {2.5, 5, 7.5, 10},
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.TIGERS_EYE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Spawns an eye familiar that bounces across the room, dealing contact damage and blocking shots",
                "The eye bounces towards enemies that are closest to it",
                "Deals 0.66x Isaac's Damage"
            },
            Golden = {
                TargetMultipliers = {0.66},
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.SMALLER_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Whenever a Tinted Rock is destroyed:",
                "↑ +0.33 Damage",
                "↓ -0.06 Speed"
            },
            Golden = {
                TargetMultipliers = {0.33, 0.06},
            },
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.NITRO_CRYSTAL,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Coin}} Picking up coins gives Isaac a boost to Tears and speed"
            },
            Golden = {
                Description = {
                    "Grants a greater boost to Tears and speed"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.SHARD_OF_GOLEM,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Overhealing charges a secondary health bar",
                "{{Damage}} Filling this health bar accumulates a damage boost up to +1.8 Damage for each heart filled",
                "Once all hearts are filled all held trinkets are smelted",
                "This health bar can be viewed by viewing the map"
            },
            Golden = {
                TargetMultipliers = {1.8}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.ROCK_WORM,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↑ +0.4 Tears",
                "↑ +0.4 Damage",
                "Grants a random worm trinket effect at the start of the floor for the duration of the floor"
            },
            Golden = {
                TargetMultipliers = {0.4},
                TargetStrings = {
                    "a random worm trinket effect",
                    "2 random worm trinket effects",
                    "3 random worm trinket effects",
                    "4 random worm trinket effects",
                    "5 random worm trinket effects",
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.FOOLS_UNOBTAINIUM,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Supposedly unobtainable, but it's not hard to actually get"
            },
            Golden = {
                Description = {
                    "Slightly harder to obtain"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.MINICHIBISIDIAN,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "10% chance to randomly transform a enemy in a room into a Bony every 3 seconds"
            },
            Golden = {
                TargetMultipliers = {10}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.FRIENDLY_RAPID_FIRE_OPAL,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Gain a limited ammo assault rifle when entering a room that has:",
                "↑ 0.5x Fire rate multiplier",
                "↑ +6.25 Range",
                "↑ +1.0 Shot speed",
                "Piercing tears"
            },
            Golden = {
                Description = {
                    "Rifle has increased ammo"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.HIDDENITE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Confusion}} Entering then breaking the line of sight from an enemy for the first time confuses them for 2.67 seconds"
            },
            Golden = {
                TargetMultipliers = {2.67}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.POCKET_ROCKIT,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "10% chance to fire a rocket tear that homes in on enemies",
                "{{Luck}} 25% chance at 10 luck",
                "Rockets shoot low damage tears when close to enemies",
                "Rockets pop into a tear pattern on impact, depending on its color"
            },
            Golden = {
                TargetMultipliers = {10}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.WORMHOLE_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Spawns two wormholes",
                "Tears and projectiles that enter a portal will emerge from the other",
                "Tears shot through portals will aim towards enemies and have additional effects",
                "The wormholes will occasionally burst into tears and change positions"
            },
            Golden = {
                Description = {
                    "Shot tears deal extra damage"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.ATLAS_BURDEN,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↓ -0.15 Speed",
                "25% chance for a boulder to drop on enemies",
                "{{Luck}} 50% chance at 3 luck",
                "{{Slow}} The boulder slows enemies down and can instantly kill non-boss enemies over time"
            },
            Golden = {
                TargetAdditives = {
                    TargetNumbers = {25},
                    AdditiveValues = {5, 10, 15, 20},
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.ARACHNITE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Blue spiders are replaced with friendly rock spiders",
                "Chance to replace with tinted or coal rock spiders"
            },
            Golden = {
                Description = {
                    "Friendly rock spiders deal extra chance",
                    "Chance to replace is increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.HOMOEROTIC_RUBY,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "15% chance to fire flaming tears that inflict Burn",
                "{{Luck}} 50% chance at 35 luck",
                "Female enemies have a 10% chance to randomly go Berserk",
            },
            StatusEffects = {mod.DescriptionStatuses.BERSERK},
            Golden = {
                TargetAdditives = {
                    TargetNumbers = {10, 15},
                    AdditiveValues = {5, 10, 15, 20},
                }
            },
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.GAY_GARNET,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Charm}} Charms female enemies",
                "{{Collectible" .. mod.ITEM.COLLECTIBLE.PEPPERMINT .. "}} "
                    .. "20% chance to shoot a fire that damages and freezes enemies",
                "{{Luck}} 50% chance at 30 luck",
                "Female enemies have a 15% chance to randomly go Berserk",
            },
            StatusEffects = {mod.DescriptionStatuses.BERSERK},
            Golden = {
                TargetAdditives = {
                    TargetNumbers = {20, 15},
                    AdditiveValues = {5, 10, 15, 20},
                }
            },
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.LITHOPEDIAN,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Spawns a Stoney Gaper familiar that pushes enemies around and blocks shots"
            },
            Golden = {
                Description = {
                    "Stoney Gaper familiar now deals contact damage that scales with Isaac's damage"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.JESUS_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↑ +1 Life",
                "{{Heart}} On death, Isaac respawns in the current room with 6 hearts added to the health bar"
            },
            Golden = {
                Description = {
                    "When revived:",
                    "Health bar is fully filled with hearts and soul hearts",
                    "Grants a shield for 10 seconds"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.LOST_ARTIFACT,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "1-3 Fairy flies spawn upon room clear",
                "Fairy flies deal contact damage to enemies, and die after some time",
                "Fairy flies come in three different sizes, and all have different effects",
                "Fairy fly names can be shown by viewing the map"
            },
            Golden = {
                Description = {
                    "Higher chance for large fairy flies to appear",
                    "More fairy flies are able to appear upon room clear"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.RIDICULOUS_METAL,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Isaac is prompted with a rhythm minigame upon entering a room with enemies",
                "Firing tears with the correct timing will deal damage to all enemies in the room",
                "{{Damage}} The more successful notes hit, the more damage it will do"
            },
            Golden = {
                Description = {
                    "Damage is increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.TOP_ROCK,
        Description = {
            Description = {
				"↑ +0.2 Speed",
                "↑ +0.14 Tears",
                "↑ +0.5 Damage",
                "↑ +1.25 Range",
                "↑ +0.5 Shot speed",
                "↑ +2 Luck",
                "↓ Prevents stats from being increased while held"
			},
			PlayerSpecificDescription = {
				Players = { mod.PLAYER.GOLEM, mod.PLAYER.BOLEM },
				Description = {
                    "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                    "↑ +0.2 Speed",
                    "↑ +0.14 Tears",
                    "↑ +0.5 Damage",
                    "↑ +1.25 Range",
                    "↑ +0.5 Shot speed",
                    "↑ +2 Luck",
                    "↓ Prevents stats from being increased while held"
				},
			},
            NoOverclockEffect = true
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.CHUNK_OF_GALLIUM,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "15% chance to fire a grey tear that leaves behind a trail of slowing creep",
                "{{Luck}} 45% chance at 20 luck"
            },
            Golden = {
                TargetAdditives = {
                    AdditiveValues = {15, 30, 45, 60},
                    TargetNumbers = {15},
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.ONION_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Spawns Brickmin familiars that can be aimed and launched while nearby",
                "There are 3 different Brickmin which have different effects and behaviors",
                "Brickmin will be gained every 4 rooms cleared"
            },
            Golden = {
                Description = {
                    "Maximum number of Brickmin per floor increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.PAPERWEIGHT,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Grants the ability to bash open chests without paying any costs",
                "{{Trinket" ..
                    FiendFolio.ITEM.ROCK.POCKET_SAND .. "}} 10% chance to break into Pocket Sand after using 5 times"
            },
            Golden = {
                Description = {
                    "Never breaks"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.SHROOMITE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Periodically fires wavy tears at random enemies",
                "{{Confusion}} 20% chance for these tears to inflict Confusion"
            },
            Golden = {
                TargetMultipliers = {20}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.AZERITE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{ffGrind}} {{ColorTransform}}Grind effect",
                "Grinding other held rocks in the Mining Machine grants a minor stat up",
                "Isaac can be granted stats up to 20 times",
            },
            Golden = {
                TargetMultipliers = {20}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.GRAVEL,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{ffGrind}} {{ColorTransform}}Grind effect",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "Grinding or Crushing other held rocks grants a rock spray attack",
                "The rock spray attack stacks the more rocks Crushed or Grinded",
                "Rock spray resets each floor"
            },
            Golden = {
                Description = {
                    "Rock spray deals more damage"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.PIG_IRON,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Coin}} Buying an item from the shop will refund back 25% of its cost"
            },
            Golden = {
                -- Do this instead of a mult so that we can set a cap
                TargetAdditives = {
                    AdditiveValues = {25, 50, 50, 50},
                    TargetNumbers = {25}
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.ROCKY,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "0.3% chance every tick in an uncleared room for a random enemy to glow",
                "{{Damage}} While looking at a glowing enemy:",
                "↑ x1.5 Damage",
                "↑ x0.85 Fire rate",
                "↑ +3 Luck"
            },
            Golden = {
                TargetAdditives = {
                    AdditiveValues = {0.1, 0.2, 0.3, 0.4},
                    TargetNumbers = {0.3},
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.FULGURITE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Collectible494}} 20% chance to fire electric tears that spawn a spark of electricity on impact",
                "{{Luck}} 50% chance at 25 luck",
                "{{ffGrind}} {{ColorTransform}}Grind effect",
                "Grinding this rock in the Mining Machine will overcharge all held actives"
            },
            Golden = {
                TargetMultipliers = {20}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.FURNACE_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Collectible289}} 6% chance to shoot a red fire that blocks enemy shots and deals contact damage",
                "{{Luck}} 50% chance at 16 luck"
            },
            Golden = {
                Description = {
                    "Fire damage is increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.MALACHITE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Champion enemies take 1.5x damage"
            },
            Golden = {
                TargetAdditives = {
                    TargetNumbers = {1.5},
                    AdditiveValues = {0.5, 1, 1.5, 2}
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.ONYX,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{BlackHeart}} 60% chance for Soul Hearts to become Black Hearts",
                "{{SoulHeart}} 20% chance for Red Hearts to become Soul Hearts",
                "!!! Red Hearts disappear if not converted"
            },
            Golden = {
                Description = {
                    "Chances are increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.FISH_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "35% chance to spawn a blue fly upon breaking a rock",
                "35% chance to double any blue flies spawned"
            },
            Golden = {
                TargetAdditives = {
                    AdditiveValues = {15, 30, 45, 60},
                    TargetNumbers = {35},
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.HELLVITE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↑ +0.02 Damage whenever Isaac kills an enemy",
                "Taking damage will cause the rock to disappear",
                "Smelting the rock will prevent the rock from disappearing, but also prevent gaining further damage"
            },
            Golden = {
                TargetMultipliers = {0.02}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.BOOSTER_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↑ Grants a randomly chosen stat buff each room"
            },
            Golden = {
                Description = {
                    "Stat buffs are increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.ROCKETTE_DRAGOON,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Chargeable}} Gain a charge attack that fires 2 bullets at the nearest enemy"
            },
            Golden = {
                TargetAdditives = {
                    AdditiveValues = {1, 2, 3, 4},
                    TargetNumbers = {2}
                },
                Description = {
                    "Bullet damage increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.ETERNAL_CRYSTAL,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "While Isaac has an Eternal Heart:",
                "↑ +1 Damage",
                "↑ +0.5 Tears",
                "{{EternalHeart}} Spawns an Eternal Heart at the start of every second floor"
            },
            Golden = {
                TargetMultipliers = {1, 0.5}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.TRIANGULAR_GEM,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Every 3rd hit on an enemy, 33% chance to spawn 3 rotating tears around it that deal 1.33x Isaac's damage"
            },
            Golden = {
                TargetMultipliers = {33}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.QUICKSILVER,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{Timer}} When entering a room, for the first 4 seconds, Isaac has:",
                "↑ +0.55 Tears",
                "↑ +2 Speed"
            },
            Golden = {
                TargetMultipliers = {4}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.NON_EUCLIDEAN_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "{{CurseMazeSmall}} Guarantees Curse of the Maze on the next floor",
                "When Isaac is moved by Curse of the Maze, he gains:",
                "↑ +0.4 Damage for the floor",
                "↑ +0.4 Tears for the room",
                "{{Damage}} Damage bonus is multiplied by 2 for the room",
                "Either a penny, bomb, key, or half a red heart if Isaac can be healed"
            },
            Golden = {
                TargetMultipliers = {0.4}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.BOOSTER_ROCK,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↑ Grants a randomly chosen stat buff each room"
            },
            Golden = {
                Description = {
                    "Stat buffs are increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.MIRROR_SLATE,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Deals 40 damage to all enemies when dropped",
                "Has a 66% chance to break when dropped and spawn a black heart"
            },
            Golden = {
                Description = {
                    "Damage is increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.HAMMER_HEAD,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↑ +0.3 Damage for the room when a rock is destroyed",
                "Rocks will break into low ranged rock tears when destroyed"
            },
            Golden = {
                Description = {
                    "Damage bonus is increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.URANIUM,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Taking damage has a 25% chance to drop a temporary heart",
                "{{ffRadiation}} Increased resistance to radiation"
            },
            Golden = {
                TargetAdditives = {
                    AdditiveValues = {15, 30, 45, 60},
                    TargetNumbers = {25}
                },
                Description = {
                    "Resistance to radiation is increased further"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.SACRED_SOIL,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "Dropping the trinket creates a white aura",
                "While inside the aura:",
                "↑ x2.5 Fire rate multiplier",
                "↑ x1.2 Damage multiplier",
                "Homing tears",
                "Chance to block damage",
                "{{ffGrind}} {{ColorTransform}}Grind effect",
                "Always spawns a rare trinket when grinded in the Mining Machine"
            },
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.ANCIENT_EFFIGY,
        Description = {
            Description = {
                "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)",
                "↑ +1 Damage",
                "{{Speed}} Automatically smelts if Isaac has 1.6 or higher speed",
                "Ignores smelting penalties"
            },
            Golden = {
                TargetMultipliers = {1}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.BREAKFAST_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "↑ +1 Health when crushed by the Bismuth Beggar"
            },
            NoOverclockEffect = true
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.SACK_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "{{GrabBag}} 10% chance for random pickups to become sacks",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "{{GrabBag}} Spawns a sack when crushed by the Bismuth Beggar",
            },
            Golden = {
                TargetMultipliers = {10}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.COPROLITE_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "Spawns a 1 blue fly for each new room entered",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "Spawns 12 blue flies when crushed by the Bismuth Beggar",
            },
            Golden = {
                TargetMultipliers = {1}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.BEETER_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "Every tear fired fires an additional weaker tear that spreads evenly around Isaac",
                "This tear deals 0.3x Isaac's damage",
                "Extra tears fire in a clockwise angle everytime Isaac shoots",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "{{Charm}} Spawns a friendly Beeter enemy when crushed by the Bismuth Beggar",
            },
            Golden = {
                TargetStrings = {
                    "an additional weaker tear",
                    "2 additional weaker tears",
                    "3 additional weaker tears",
                    "4 additional weaker tears",
                    "5 additional weaker tears",
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.FLY_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "Spawns a Famine Locust for each new room entered",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "Gives a Pretty Fly when crushed by the Bismuth Beggar"
            },
            Golden = {
                TargetStrings = {
                    "a Famine Locust",
                    "2 Famine Locusts",
                    "3 Famine Locusts",
                    "4 Famine Locusts",
                    "5 Famine Locusts",
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.GMO_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "{{Pill}} Isaac is forced to consume 2 random pills after beating a boss",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "{{Pill}} Consume 3 random pills when crushed by the Bismuth Beggar"
            },
            Golden = {
                TargetMultipliers = {2}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.SWORD_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "↑ +1 Damage",
                "↑ +0.27 Tears",
                "↑ +0.75 Range",
                "↑ +0.20 Shot speed",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "When crushed by the Bismuth Beggar, you gain 50% of the stats from Sword Fossil permanently"
            },
            Golden = {
                TargetMultipliers = {1, 0.27, 0.75},
                TargetStrings = { -- Shot speed is capped
                    "0.20",
                    "0.40",
                    "0.40",
                    "0.40",
                    "0.40",
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.FORTUNE_WORM_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "↑ +0.2 Shot speed",
                "↑ +2 Luck",
                "1% chance to fire a fortune worm tear that does x1.05 damage",
                "{{Luck}} 33% chance at 18 luck",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "{{SoulHeart}} Spawns an extra soul heart and displays 3 random fortunes when crushed by the Bismuth Beggar"
            },
            Golden = {
                -- Stat changes are too complicated for EID since you cant do additive + multiplicative + appended descriptions :(
                Description = {
                    "Increased chances and stats"
                },
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.PRIMORDIAL_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "{{Collectible317}} 7% chance to fire a small barrage of Mysterious Liquid tears",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "Grants Golem's starting rocks when crushed ({{Trinket" ..
                    FiendFolio.ITEM.ROCK.DIRT_CLUMP ..
                        "}} + {{Trinket" .. FiendFolio.ITEM.ROCK.ROLLING_ROCK .. "}}) by the Bismuth Beggar"
            },
            Golden = {
                TargetMultipliers = {7}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.REROLLIGAN_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "10% chance to shoot a dice tear that rerolls enemies",
                "{{Luck}} 40% chance at 8 luck",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "Spawns 3 random Glass Die when crushed by the Bismuth Beggar"
            },
            Golden = {
                TargetMultipliers = {10}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.FOSSILIZED_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "Fossil crushing effects activate twice",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "Activates the effect of another held fossil when crushed by the Bismuth Beggar"
            },
            Golden = {
                TargetStrings = {
                    "twice",
                    "3 times",
                    "4 times",
                    "5 times",
                    "6 times",
                },
                OverclockOnly = true,
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.FISH_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "Taking damage spawns 1 to 4 blue flies",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "{{Charm}} Spawns a friendly Portal when crushed by the Bismuth Beggar"
            },
            Golden = {
                TargetAdditives = {
                    AdditiveValues = {1, 2, 3, 4},
                    TargetNumbers = {4}
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.RUNIC_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "{{Rune}} Runes are more common",
                "Using runes or soul stones drops a rune shard",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "Drops 4 rune shards when crushed by the Bismuth Beggar"
            },
            Golden = {
                TargetStrings = {
                    "a rune shard",
                    "2 rune shards",
                    "3 rune shards",
                    "4 rune shards",
                    "5 rune shards",
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.CANNED_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "Isaac farts a random fart when taking damage",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "{{Charm}} Spawns a friendly Charmed Litter bug when crushed by the Bismuth Beggar"
            },
            Golden = {
                Description = {
                    "Fart radius of effect increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.BALANCED_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "50% chance for the room clear reward to be a pickup Isaac has none of",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "Grants 3 of the lowest owned pickups when crushed by the Bismuth Beggar"
            },
            Golden = {
                TargetStrings = {
                    "none of",
                    "a small amount of",
                    "a small amount of",
                    "a small amount of",
                    "a small amount of",
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.BURIED_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "Each floor has a marked spot that can be bombed to spawn a fossil",
                "Dirt patches can be bombed open",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "Gives a random fossil when crushed by the Bismuth Beggar"
            },
            Golden = {
                TargetStrings = {
                    "a marked spots",
                    "2 marked spots",
                    "3 marked spots",
                    "4 marked spots",
                    "5 marked spots"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.TRIPPY_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "{{Collectible398}} 13% chance to fire tears that can shrink enemies",
                "{{Luck}} 100% chance at 44 luck",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "Shrinks Isaac when crushed by the Bismuth Beggar"
            },
            Golden = {
                TargetAdditives = {
                    TargetNumbers = {13},
                    AdditiveValues = {18, 23, 28, 33}
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.MAXS_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "{{Collectible445}} A wolf howls in rooms adjacent to a Secret/Super Secret Room",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "When crushed by the Bismuth Beggar, the next tinted rock Isaac encounters is revealed"
            },
            NoOverclockEffect = true
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.BOMB_SACK_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "{{Bomb}} Bombs create a ring of rock waves",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "{{Bomb}} Spawns 3 bombs when crushed by the Bismuth Beggar"
            },
            NoOverclockEffect = true
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.DEATH_CAP_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "↓ Minor stats down on each room cleared",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "↑ All stats up when crushed by the Bismuth Beggar",
                "↑ Stats ups are proportional to how many rooms cleared, up to 30 rooms"
            },
            Golden = {
                Description = {
                    "Stats are increased or decreased more"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.EXPLOSIVE_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "{{Bomb}} 13% chance for an extra bomb to drop on room clear",
                "20% chance for rocks to be replaced with bomb rocks",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "{{Collectible483}} When crushed by the Bismuth Beggar, the next 3 uncleared rooms will be affected by a Mama Mega explosion"
            },
            Golden = {
                TargetAdditives = {
                    TargetNumbers = {13},
                    AdditiveValues = {5, 10, 15, 20}
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.COLOSSAL_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "↑ Doubles tear size",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "Activates 3 random fossil effects when crushed by the Bismuth Beggar"
            },
            NoOverclockEffect = true
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.SKUZZ_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "Spawn 2 to 3 purple skuzzes each time an active room is entered",
                "{{Slow}} This skuzz deals 3x Isaac's damage and slows enemies",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "Spawns 5 to 7 blue skuzzes when crushed by the Bismuth Beggar"
            },
            Golden = {
                TargetAdditives = {
                    TargetNumbers = {2, 3},
                    AdditiveValues = {1}
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.FOSSILIZED_BLESSING,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "↑ +0.4 Tears",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "Grants a random rock trinket at the start of the next run when crushed by the Bismuth Beggar"
            },
            Golden = {
                TargetMultipliers = {0.4}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.PETRIFIED_SOCK,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "10% chance to shoot petrifying tears",
                "{{Luck}} 100% chance at 45 luck",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "Grants a random baby familiar when crushed by the Bismuth Beggar"
            },
            Golden = {
                TargetAdditives = {
                    AdditiveValues = {5, 10, 15, 20},
                    TargetNumbers = {10}
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.MOLTEN_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "↑ Improves the effectiveness of smelted rock trinkets by 15%",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "Grants and smelts a random common rock when crushed by the Bismuth Beggar"
            },
            Golden = {
                Description = {
                    "Improves effectiveness of smelted rock trinkets even more"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.VALUE_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "{{Coin}} Shop items are one cent cheaper",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "{{Coin}} Spawns 3 pennies when crushed by the Bismuth Beggar"
            },
            Golden = {
                TargetStrings = {
                    "one cent",
                    "2 cents",
                    "3 cents",
                    "4 cents",
                    "5 cents"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.CORAL_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "25% chance to fire 4 tears in an X shape",
                "{{Luck}} 100% chance at 75 luck",
                "{{Heart}} Heals 1 Red Heart on pickup",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "{{Charm}} Spawns 3 friendly drowned chargers and heals a heart when crushed by the Bismuth Beggar"
            },
            Golden = {
                TargetAdditives = {
                    AdditiveValues = {10, 20, 30, 40},
                    TargetNumbers = {25}
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.NECROMANTIC_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "20% to spawn a bone orbital when killing an enemy",
                "{{Luck}} 40% chance at 20 luck",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "Grants a fossil that has been crushed this run when crushed by the Bismuth Beggar"
            },
            TargetMultipliers = {20}
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.BRAIN_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "Tears fired briefly have homing",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "{{Card}} Spawns a Magician card when crushed by the Bismuth Beggar"
            },
            Golden = {
                Description = {
                    "Homing lasts longer"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.REFUND_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "{{Trinket" ..FiendFolio.ITEM.ROCK.POCKET_SAND .."}} Crushing other fossils in the Bismuth Beggar spawns Pocket Sand",
                "{{ffGrind}} {{ColorTransform}}Grind effect",
                "Pocket Sand can be grinded for free in the Mining Machine when holding this fossil",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "Spawns 2 Pocket Sands when crushed by the Bismuth Beggar"
            },
            Golden = {
                TargetMultipliers = {2},
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.LEFT_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "{{RedChest}} Turns all chests into Red Chests",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "{{RedChest}} Spawns a Red Chest when crushed by the Bismuth Beggar"
            },
            NoOverclockEffect = true
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.THANK_YOU_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "{{Beggar}} Beggars pay out their rewards twice",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "{{Card}} Spawns a Judgement card when crushed by the Bismuth Beggar"
            },
            Golden = {
                TargetStrings = {
                    "twice",
                    "3 times",
                    "4 times",
                    "5 times",
                    "6 times",
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.HOLLOW_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "↑ +1.35 Damage",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "Guarantees a Devil/Angel Room and spawns a Black Heart when crushed by the Bismuth Beggar"
            },
            Golden = {
                TargetMultipliers = {1.35}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.ELEPHANT_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "{{EmptyBoneHeart}} Bone hearts take one extra hit before breaking",
                "This hit is restored whenever the bone heart is filled",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "{{Charm}} Spawns a giant friendly bony when crushed by the Bismuth Beggar"
            },
            Golden = {
                TargetStrings = {
                    "one extra hit",
                    "2 extra hits",
                    "3 extra hits",
                    "4 extra hits",
                    "5 extra hits"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.GOLDEN_FOSSIL,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "{{GoldenChest}} Replaces all chests with golden chests",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "{{GoldenChest}} Spawns a golden chest when crushed by the Bismuth Beggar"
            },
            NoOverclockEffect = true
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.FOSSILIZED_COIN,
        Description = {
            Description = {
                "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)",
                "{{Coin}} 15% chance to upgrade pennies to nickels",
                "7% chance to upgrade to dimes",
                "{{ColorTransform}}{{ffCrush}} Crush effect",
                "Spawns a shop chest when crushed by the Bismuth Beggar"
            },
            Golden = {
                Description = {
                    "Increased chances"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.CURVED_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "↑ +1 Damage",
                "↑ Bonus +0.5 Damage if holding another Geode"
            },
            Golden = {
                TargetMultipliers = {1}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.HAUNTED_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "20% chance to fire a spectral and piercing tear",
                "{{Luck}} 100% chance at 40 luck",
                "↑ Increased chance if holding another Geode"
            },
            Golden = {
                TargetMultipliers = {20}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.HEALTH_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "{{Heart}} When Isaacs drops to 1 red heart or less, heals red hearts and breaks",
                "{{SoulHeart}} +1 Soul Heart when the rock breaks if holding another Geode"
            },
            Golden = {
                TargetStrings = {
                    "+1 Soul Heart",
                    "+2 Soul Hearts",
                    "+3 Soul Hearts",
                    "+4 Soul Hearts",
                    "+5 Soul Hearts",
                },
                GoldOnly = true
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.LITTLE_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "Decreases Isaac's size",
                "↑ Bonus size down if holding another Geode"
            },
            Golden = {
                Description = {
                    "Size decreased further"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.QUICK_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "↑ Boosts Speed to 1.75 in cleared rooms",
                "↑ Bonus +0.10 Speed if holding another Geode"
            },
            Golden = {
                TargetStrings = {
                    "1.75",
                    "1.85",
                    "1.85",
                    "1.85",
                    "1.85",
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.WEBBY_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "{{Slow}} 20% chance to shoot slowing tears",
                "{{Luck}} 100% chance at 40 luck",
                "↑ Enemies hit by slowing tears leave white slowing creep if holding another Geode"
            },
            Golden = {
                TargetMultipliers = {20}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.LUCKY_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "↑ +1 Luck",
                "↑ Bonus +2 Luck if holding another Geode"
            },
            Golden = {
                TargetMultipliers = {2}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.PHLEGMY_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "10% chance to shoot a sticky booger tear",
                "{{Luck}} 100% chance at 90 luck",
                "{{Slow}} Booger tears slow down enemies if holding another Geode"
            },
            Golden = {
                TargetMultipliers = {10}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.LOB_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "↑ +1 Range",
                "Tears are now shot in an arc",
                "↑ Bonus +0.5 Range if holding another Geode"
            },
            Golden = {
                TargetMultipliers = {1}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.SODALITE_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "4% chance to shoot purple critical tears that deal x5 damage",
                "{{Luck}} 33% chance at 11 luck",
                "↑ Increased chance if holding another Geode"
            },
            Golden = {
                TargetMultipliers = {4}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.PLACEBEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "Removes the requirement for Geodes to be held in both trinket slots if smelted"
            },
            NoOverclockEffect = true
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.WARM_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "When near a fireplace:",
                "↑ +4 Damage",
                "↑ +0.2 Shot speed",
                "Warm floors give:",
                "↑ +2 Damage",
                "↑ +0.2 Shot speed",
                "↑ Bonus +5 Damage and fire tears when standing next to a fireplace if holding another Geode"
            },
            Golden = {
                TargetMultipliers = {
                    "4",
                    "0.2",
                    "2",
                    "5"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.CHAIN_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "Rocks that are destroyed have a 40% chance to break adjacent rocks",
                "↑ Increased chance to 70% when holding another Geode",
                "↑ Pits adjacent to other rocks also have a 20% chance to be filled in if holding another Geode"
            },
            Golden = {
                Description = {
                    "Chances increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.RUSTY_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "↑ +8 Damage",
                "The damage wears off over 2 minutes and 13 seconds",
                "↑ The damage decays at a slower rate if holding another Geode"
            },
            Golden = {
                TargetMultipliers={8}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.FRAGMENTED_ONYX_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "{{Fear}} 10% chance to shoot fear tears",
                "{{Luck}} 100% chance at 26 luck",
                "↑ Increased chance if holding another Geode",
                "{{DevilRoom}} Enemies inflicted with fear take extra damage based on the Devil Deal chance if holding another Geode"
            },
            Golden = {
                TargetAdditives = {
                    AdditiveValues={5, 10, 15, 20},
                    TargetNumbers={10},
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.QUANTUM_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "Isaac shoots 3 tears at once",
                "Once a tear hits an enemy, the other 2 tears will vanish",
                "↑ Two tears can land on an enemy if holding another Geode"
            },
            Golden = {
                TargetAdditives = {
                    AdditiveValues = {1, 2, 3, 5},
                    TargetNumbers = {3, 2}
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.TECHNOLOGICAL_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "Fires a short ranged laser that deals 30% damage while firing",
                "↑ Fires 2 beams if holding another Geode"
            },
            Golden = {
                Description = {
                    "Laser has increased range"
                },
                TargetMultipliers = {30},
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.RUBBER_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "15% chance to fire a bouncing tennis ball tear that inflicts Bruise",
                "{{Luck}} 50% chance at 18 luck",
                "↑ Increased chance and knockback if holding another Geode"
            },
            StatusEffects = {
                mod.DescriptionStatuses.BRUISE
            },
            Golden = {
                TargetAdditives = {
                    TargetNumbers = {15},
                    AdditiveValues = {5, 10, 15, 20}
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.CALZONE_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "5% chance to fire a piercing maggot that charges forward",
                "{{Luck}} 50% chance at 9 luck",
                "{{Bait}} The maggot marks enemies",
                "Marked enemies are targeted by other enemies",
                "↑ Increased chance to fire if holding another Geode"
            },
            Golden = {
                TargetAdditives = {
                    AdditiveValues = {5, 10, 15, 20},
                    TargetNumbers = {5}
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.TOUGH_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "{{ffCrush}} 20% chance to not destroy a geode when crushed by the Bismuth Beggar",
                "↑ Increased chance if holding another Geode"
            },
            NoOverclockEffect = true
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.TIPSY_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "↑ +2 Damage",
                "Isaac's movement shifts around erratically",
                "↑ Bonus +1.5 Damage and more intense movements if holding another Geode"
            },
            Golden = {
                TargetMultipliers = {2}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.VINYL_GEODE_A,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "↑ +1 Damage",
                "↑ +0.24 Shot speed",
                "Flips to the B Side on the first floor of a chapter",
                "↑ Bonus +0.07 Speed and +0.2 Tears if holding another Geode"
            },
            Golden = {
                TargetMultipliers = {1, 0.24, 0.07, 0.2}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.VINYL_GEODE_B,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "↑ +0.2 Speed",
                "↑ +0.66 Tears",
                "Flips to the A Side on the second floor of a chapter",
                "↑ Bonus +0.3 Damage and +0.08 Shot speed if holding another Geode"
            },
            Golden = {
                TargetMultipliers = {0.2, 0.66, 0.3, 0.08}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.PRISMATIC_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "12% chance for enemies to drop Prism Shards on death",
                "↑ Prism Shards boost a random stat for 10 seconds",
                "25% chance for a Prism Shard to appear on room clear",
                "↑ Stat boosts are doubled and duration is increased if holding another geode"
            },
            Golden = {
                TargetMultipliers = {12, 25}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.FRACTAL_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "15% chance to shoot a spiraling shot that inflicts Drowsy",
                "{{Luck}} 45% chance at 20 luck",
                "↑ Increased chance and enemies have a 33% chance to instantly fall asleep if holding another Geode"
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.DROWSY_AND_SLEEP },
            Golden = {
                TargetAdditives = {
                    AdditiveValues = {15, 30, 45, 60},
                    TargetNumbers = {15},
                },
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.GMO_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "{{Pill}} Taking a pill will force Isaac to take another pill",
                "↑ Isaac takes an additional positive pill if holding another Geode"
            },
            Golden = {
                TargetStrings = {
                    "another pill",
                    "2 more pills",
                    "3 more pills",
                    "4 more pills",
                    "5 more pills",
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.SWALLOWED_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "{{Coin}} Taking damage spawns 1 coin",
                "↑ 33% chance to spawn a double penny instead if holding another Geode"
            },
            Golden = {
                Description = {
                    "Chance to spawn a double penny instead even if not holding another Geode"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.VOODOO_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "↑ +1.5 Damage when a curse is present on the floor",
                "↑ +0.35 Damage for the floor when entering a curse room for the first time",
                "{{Damage}} Increases damage bonus by 1.5x if holding another Geode"
            },
            Golden = {
                Description = {
                    "Damage bonus is increased"
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.UMBILICAL_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "{{HalfHeart}} Having half a Red Heart or less grants {{Collectible100}} Little Steven",
                "{{Collectible318}} Taking damage has a 30% chance to spawn a Gemini familiar for the room",
                "{{Luck}} 100% chance at 35 luck",
                "↑ Base Gemini spawn chances are improved if holding another Geode",
                "↑ Little Steven can spawn at one heart or less if holding another Geode"
            },
            Golden = {
                TargetAdditives = {
                    TargetNumbers = {30},
                    AdditiveValues = {15, 30, 45, 60}
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.AAA_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "{{Battery}} -1 charge needed for active items",
                "↑ -2 charge needed for active items if holding another Geode"
            },
            Golden = {
                TargetAdditives = {
                    AdditiveValues = {1, 2, 3, 4},
                    TargetNumbers = {1, 2}
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.LIBERTY_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "25% chance for a random mushroom effect per room",
                "↑ Increased chance to grant a mushroom effect if holding another Geode",
                "↑ Can gain an additional mushroom effect if holding another Geode"
            },
            Golden = {
                TargetMultipliers = {25}
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.NONAGON_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "{{Battery}} 25% chance to spawn a random battery when using an active item",
                "↑ Increased chance if holding another Geode"
            },
            Golden = {
                TargetAdditives = {
                    AdditiveValues = {10, 20, 30, 40},
                    TargetNumbers = {25},
                }
            }
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.DEVOURING_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "{{DevilRoom}} Allows Isaac to take a free devil deal",
                "!!! Destroys itself when one is taken",
                "↑ If another geode is held, it will be taken instead"
            },
            NoOverclockEffect = true
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.THE_STRONGEST_GEODE,
        Description = {
            Description = {
                "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)",
                "Picking up Rare or Fiendish rocks crushes it and turns them into a Common rock",
                "{{HalfSoulHeart}} Crushing rocks spawns a Half Soul Heart"
            },
            NoOverclockEffect = true
        }
    },
    {
        ID = FiendFolio.ITEM.ROCK.GEODE_FOSSIL,
        Description = {
            Description = {
                "{{ffGeodeFossil}} {{ColorTransform}}Rock Trinket (Geode x Fossil)",
                "↑ +1.5 Range",
                "↑ Bonus +0.75 Range if holding another Geode",
                "{{ffCrush}} Gives a common or rare Geode trinket when crushed",
                "{{ffCrush}} Gives an additional common or rare Geode trinket when crushed if holding another Geode"
            },
            Golden = {
                TargetMultipliers = {1.5}
            }
        }
    },
}

--ENCYCLOPEDIA
if Encyclopedia then
	--Trinkets
	local EncycloTrinkets = {
		{ID = FiendFolio.ITEM.ROCK.DIRT_CLUMP},
		{ID = FiendFolio.ITEM.ROCK.ROLLING_ROCK},
		{ID = FiendFolio.ITEM.ROCK.POCKET_SAND},
		{ID = FiendFolio.ITEM.ROCK.ROUGH_ROCK},
		{ID = FiendFolio.ITEM.ROCK.BLOODY_ROCK},
		{ID = FiendFolio.ITEM.ROCK.SPIKED_ROCK},
		{ID = FiendFolio.ITEM.ROCK.SLIPPY_ROCK},
		{ID = FiendFolio.ITEM.ROCK.ARCANE_ROCK},
		{ID = FiendFolio.ITEM.ROCK.MINERAL_ROCK},
		{ID = FiendFolio.ITEM.ROCK.THORNY_ROCK},
		{ID = FiendFolio.ITEM.ROCK.TIME_LOST_DIAMOND},
		{ID = FiendFolio.ITEM.ROCK.OBSIDIAN_GRINDSTONE},
		{ID = FiendFolio.ITEM.ROCK.GODS_MARBLE},
		{ID = FiendFolio.ITEM.ROCK.TWENTY_SIDED_EMERALD},
		{ID = FiendFolio.ITEM.ROCK.TECHNOLOGICAL_RUBY_2},
		{ID = FiendFolio.ITEM.ROCK.LEAKY_ROCK},
		{ID = FiendFolio.ITEM.ROCK.TWIN_TUFFS},
		{ID = FiendFolio.ITEM.ROCK.WETSTONE},
		{ID = FiendFolio.ITEM.ROCK.STROMATOLITE},
		{ID = FiendFolio.ITEM.ROCK.RIBBED_ROCK},
		{ID = FiendFolio.ITEM.ROCK.FIENDISH_AMETHYST},
		{ID = FiendFolio.ITEM.ROCK.STURDY_ROCK},
		{ID = FiendFolio.ITEM.ROCK.BRICK_ROCK},
		{ID = FiendFolio.ITEM.ROCK.SAPPHIC_SAPPHIRE},
		{ID = FiendFolio.ITEM.ROCK.BLOOD_DIAMOND},
		{ID = FiendFolio.ITEM.ROCK.SCENTED_ROCK},
		{ID = FiendFolio.ITEM.ROCK.ARCADE_ROCK},
		{ID = FiendFolio.ITEM.ROCK.TINTED_HEART},
		{ID = FiendFolio.ITEM.ROCK.ROSE_QUARTZ},
		{ID = FiendFolio.ITEM.ROCK.HAILSTONE},
		{ID = FiendFolio.ITEM.ROCK.RAMBLIN_OPAL},
		{ID = FiendFolio.ITEM.ROCK.SAND_DOLLAR},
		{ID = FiendFolio.ITEM.ROCK.HENGE_ROCK},
		{ID = FiendFolio.ITEM.ROCK.SALT_LAMP},
		{ID = FiendFolio.ITEM.ROCK.MOLTEN_SLAG},
		{ID = FiendFolio.ITEM.ROCK.THUNDER_EGG},
		{ID = FiendFolio.ITEM.ROCK.SANDSTONE},
		{ID = FiendFolio.ITEM.ROCK.FAKE_ROCK},
		{ID = FiendFolio.ITEM.ROCK.CITRINE_PULP},
		{ID = FiendFolio.ITEM.ROCK.BLOODSTONE},
		{ID = FiendFolio.ITEM.ROCK.EMETIC_ANTIMONY},
		{ID = FiendFolio.ITEM.ROCK.DOUBLE_RUBBLE},
		{ID = FiendFolio.ITEM.ROCK.ROCK_FROM_AN_ABYSS},
		{ID = FiendFolio.ITEM.ROCK.VESSEL_ROCK},
		{ID = FiendFolio.ITEM.ROCK.HALF_VESSEL_ROCK, Hide = true},
		{ID = FiendFolio.ITEM.ROCK.FULL_VESSEL_ROCK, Hide = true},
		{ID = FiendFolio.ITEM.ROCK.CONSTANT_ROCK_SHOOTER},
		{ID = FiendFolio.ITEM.ROCK.ROBOT_ROCK},
		{ID = FiendFolio.ITEM.ROCK.ROCK_CANDY},
		{ID = FiendFolio.ITEM.ROCK.KEYSTONE},
		{ID = FiendFolio.ITEM.ROCK.SILVER_TONGUE},
		{ID = FiendFolio.ITEM.ROCK.MEAT_SLAB},
		{ID = FiendFolio.ITEM.ROCK.SHEEP_ROCK},
		{ID = FiendFolio.ITEM.ROCK.REBELLION_ROCK},
		{ID = FiendFolio.ITEM.ROCK.HECTOR},
		{ID = FiendFolio.ITEM.ROCK.DADS_LEGENDARY_GOLDEN_ROCK},
		{ID = FiendFolio.ITEM.ROCK.BEDROCK},
		{ID = FiendFolio.ITEM.ROCK.SHEETROCK},
		{ID = FiendFolio.ITEM.ROCK.FETAL_STONE},
		{ID = FiendFolio.ITEM.ROCK.FOCUS_CRYSTAL},
		{ID = FiendFolio.ITEM.ROCK.ODDLY_SMOOTH_STONE},
		{ID = FiendFolio.ITEM.ROCK.MOONSTONE},
		{ID = FiendFolio.ITEM.ROCK.LIMESTONE},
		{ID = FiendFolio.ITEM.ROCK.CARNAL_CARNELIAN},
		{ID = FiendFolio.ITEM.ROCK.REBAR_ROCK},
		{ID = FiendFolio.ITEM.ROCK.DOGROCK_ROCK},
		{ID = FiendFolio.ITEM.ROCK.CAST_GEM},
		{ID = FiendFolio.ITEM.ROCK.STALACTITE},
		{ID = FiendFolio.ITEM.ROCK.SHARD_OF_GOLGOTHA},
		{ID = FiendFolio.ITEM.ROCK.SMOKY_QUARTZ},
		{ID = FiendFolio.ITEM.ROCK.TWINKLING_ROCK},
		{ID = FiendFolio.ITEM.ROCK.ROCK_CAKE},
		{ID = FiendFolio.ITEM.ROCK.CHARCOAL},
		{ID = FiendFolio.ITEM.ROCK.ACHILLES_ROCK},
		{ID = FiendFolio.ITEM.ROCK.ELECTRUM},
		{ID = FiendFolio.ITEM.ROCK.PURE_QUARTZ},
		{ID = FiendFolio.ITEM.ROCK.AMAZONITE},
		{ID = FiendFolio.ITEM.ROCK.STAR_SAPPHIRE},
		{ID = FiendFolio.ITEM.ROCK.GRAVESTONE},
		{ID = FiendFolio.ITEM.ROCK.SAND_CASTLE},
		{ID = FiendFolio.ITEM.ROCK.DAMAGED_SAND_CASTLE, Hide = true},
		{ID = FiendFolio.ITEM.ROCK.BROKEN_SAND_CASTLE, Hide = true},
		{ID = FiendFolio.ITEM.ROCK.GUARDED_GARNET},
		{ID = FiendFolio.ITEM.ROCK.SHAMROCK},
		{ID = FiendFolio.ITEM.ROCK.GAS_POCKET},
		{ID = FiendFolio.ITEM.ROCK.SOAP_STONE},
		{ID = FiendFolio.ITEM.ROCK.SPIRIT_URN},
		{ID = FiendFolio.ITEM.ROCK.SUN_SHARD},
		{ID = FiendFolio.ITEM.ROCK.STEADFAST_STONE},
		{ID = FiendFolio.ITEM.ROCK.INSATIABLE_APATITE},
		{ID = FiendFolio.ITEM.ROCK.RAI_STONE},
		{ID = FiendFolio.ITEM.ROCK.ORE_PENNY},
		{ID = FiendFolio.ITEM.ROCK.HEAVY_METAL},
		{ID = FiendFolio.ITEM.ROCK.GROSSULAR},
		{ID = FiendFolio.ITEM.ROCK.SULFUR_CRYSTAL},
		{ID = FiendFolio.ITEM.ROCK.THROWLOMITE},
		{ID = FiendFolio.ITEM.ROCK.HEARTHSTONE},
		{ID = FiendFolio.ITEM.ROCK.MAGNETIC_SAND},
		{ID = FiendFolio.ITEM.ROCK.POWER_ROCK},
		{ID = FiendFolio.ITEM.ROCK.TIGERS_EYE},
		{ID = FiendFolio.ITEM.ROCK.SMALLER_ROCK},
		{ID = FiendFolio.ITEM.ROCK.SHARD_OF_GOLEM},
		{ID = FiendFolio.ITEM.ROCK.ROCK_WORM},
		{ID = FiendFolio.ITEM.ROCK.NITRO_CRYSTAL},
		{ID = FiendFolio.ITEM.ROCK.FOOLS_UNOBTAINIUM},
		{ID = FiendFolio.ITEM.ROCK.MINICHIBISIDIAN},
		{ID = FiendFolio.ITEM.ROCK.FRIENDLY_RAPID_FIRE_OPAL},
		{ID = FiendFolio.ITEM.ROCK.HIDDENITE},
		{ID = FiendFolio.ITEM.ROCK.LOST_ARTIFACT},
		{ID = FiendFolio.ITEM.ROCK.ATLAS_BURDEN},
		{ID = FiendFolio.ITEM.ROCK.POCKET_ROCKIT},
		{ID = FiendFolio.ITEM.ROCK.WORMHOLE_ROCK},
		{ID = FiendFolio.ITEM.ROCK.RIDICULOUS_METAL},
		{ID = FiendFolio.ITEM.ROCK.TOP_ROCK},
		{ID = FiendFolio.ITEM.ROCK.ARACHNITE},
		{ID = FiendFolio.ITEM.ROCK.HOMOEROTIC_RUBY},
		{ID = FiendFolio.ITEM.ROCK.GAY_GARNET},
		{ID = FiendFolio.ITEM.ROCK.LITHOPEDIAN},
		{ID = FiendFolio.ITEM.ROCK.JESUS_ROCK},
		
		{ID = FiendFolio.ITEM.ROCK.REROLLIGAN_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.BREAKFAST_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.SACK_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.COPROLITE_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.BEETER_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.FLY_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.GMO_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.SWORD_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.FORTUNE_WORM_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.PRIMORDIAL_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.FOSSILIZED_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.FISH_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.RUNIC_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.CANNED_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.BALANCED_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.BURIED_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.TRIPPY_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.MAXS_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.BOMB_SACK_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.DEATH_CAP_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.EXPLOSIVE_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.COLOSSAL_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.SKUZZ_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.MOLTEN_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.VALUE_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.CORAL_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.NECROMANTIC_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.BRAIN_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.PETRIFIED_SOCK},
		{ID = FiendFolio.ITEM.ROCK.REFUND_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.LEFT_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.FOSSILIZED_BLESSING},
		{ID = FiendFolio.ITEM.ROCK.THANK_YOU_FOSSIL},
		{ID = FiendFolio.ITEM.ROCK.HOLLOW_FOSSIL},
		
		{ID = FiendFolio.ITEM.ROCK.CURVED_GEODE},
		{ID = FiendFolio.ITEM.ROCK.HAUNTED_GEODE},
		{ID = FiendFolio.ITEM.ROCK.HEALTH_GEODE},
		{ID = FiendFolio.ITEM.ROCK.LITTLE_GEODE},
		{ID = FiendFolio.ITEM.ROCK.QUICK_GEODE},
		{ID = FiendFolio.ITEM.ROCK.WEBBY_GEODE},
		{ID = FiendFolio.ITEM.ROCK.LUCKY_GEODE},
		{ID = FiendFolio.ITEM.ROCK.PHLEGMY_GEODE},
		{ID = FiendFolio.ITEM.ROCK.LOB_GEODE},
		{ID = FiendFolio.ITEM.ROCK.SODALITE_GEODE},
		{ID = FiendFolio.ITEM.ROCK.PLACEBEODE},
		{ID = FiendFolio.ITEM.ROCK.WARM_GEODE},
		{ID = FiendFolio.ITEM.ROCK.CHAIN_GEODE},
		{ID = FiendFolio.ITEM.ROCK.RUSTY_GEODE},
		{ID = FiendFolio.ITEM.ROCK.FRAGMENTED_ONYX_GEODE},
		{ID = FiendFolio.ITEM.ROCK.QUANTUM_GEODE},
		{ID = FiendFolio.ITEM.ROCK.TECHNOLOGICAL_GEODE},
		{ID = FiendFolio.ITEM.ROCK.RUBBER_GEODE},
		{ID = FiendFolio.ITEM.ROCK.CALZONE_GEODE},
		{ID = FiendFolio.ITEM.ROCK.TOUGH_GEODE},
		{ID = FiendFolio.ITEM.ROCK.TIPSY_GEODE},
		{ID = FiendFolio.ITEM.ROCK.VINYL_GEODE_A},
		{ID = FiendFolio.ITEM.ROCK.VINYL_GEODE_B, Hide = true},
		{ID = FiendFolio.ITEM.ROCK.PRISMATIC_GEODE},
		{ID = FiendFolio.ITEM.ROCK.GMO_GEODE},
		{ID = FiendFolio.ITEM.ROCK.FRACTAL_GEODE},
		{ID = FiendFolio.ITEM.ROCK.SWALLOWED_GEODE},
		{ID = FiendFolio.ITEM.ROCK.VOODOO_GEODE},
		{ID = FiendFolio.ITEM.ROCK.UMBILICAL_GEODE},
		{ID = FiendFolio.ITEM.ROCK.GEODE_FOSSIL},
		
		{ID = FiendFolio.ITEM.ROCK.KNIFE_PEBBLE},
		{ID = FiendFolio.ITEM.ROCK.TEARDROP_PEBBLE},
		{ID = FiendFolio.ITEM.ROCK.ARROW_PEBBLE},
		{ID = FiendFolio.ITEM.ROCK.CLOVER_PEBBLE},
		{ID = FiendFolio.ITEM.ROCK.SHOE_PEBBLE},
		{ID = FiendFolio.ITEM.ROCK.FRUITY_PEBBLE},
		
		{ID = FiendFolio.ITEM.ROCK.GRIMACE_ROCK1},
		{ID = FiendFolio.ITEM.ROCK.GRIMACE_ROCK2},
		{ID = FiendFolio.ITEM.ROCK.GRIMACE_ROCK3},
		{ID = FiendFolio.ITEM.ROCK.GRIMACE_ROCK4},
		{ID = FiendFolio.ITEM.ROCK.GRIMACE_ROCK5},
		{ID = FiendFolio.ITEM.ROCK.GRIMACE_ROCK6},
		{ID = FiendFolio.ITEM.ROCK.GRIMACE_ROCK7},
		{ID = FiendFolio.ITEM.ROCK.GRIMACE_ROCK8},
		{ID = FiendFolio.ITEM.ROCK.GRIMACE_ROCK9},
		{ID = FiendFolio.ITEM.ROCK.GRIMACE_ROCK10},
		{ID = FiendFolio.ITEM.ROCK.GRIMACE_ROCK11},
		{ID = FiendFolio.ITEM.ROCK.GRIMACE_ROCK12},
		
		{ID = FiendFolio.ITEM.ROCK.TROLLITE, Hide = true},
		{ID = FiendFolio.ITEM.ROCK.UNOBTAINIUM, Hide = true},
	}

	for _, info in pairs(EncycloTrinkets) do
		local desc = __eidTrinketDescriptions[info.ID]
		if not desc and EID then
			local eidDesc = EID:getDescriptionEntryEnglish("custom", "5.350."..info.ID)
			if eidDesc then
				desc = eidDesc[3]
			end
		end
		Encyclopedia.AddTrinket({
			Class = "Golem's Rocks",
			ID = info.ID,
			WikiDesc = Encyclopedia.EIDtoWiki(desc or "???"),
			--UnlockFunc = EncycloItems[id].Unlock,
			Hide = info.Hide,
			ModName = "Fiend Folio",
		})
	end
end