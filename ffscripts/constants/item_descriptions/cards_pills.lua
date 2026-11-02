__eidCardDescriptions = __eidCardDescriptions or {}
__eidPillDescriptions = __eidPillDescriptions or {}

local mod = FiendFolio

FiendFolio.ExternalDescriptions.Cards = {
	{
        ID = FiendFolio.ITEM.CARD.PLUS_3_FIREBALLS,
        Description = {
            Description = {
                "Spawns 3 orbital fireballs",
                "Double-tap the shoot button to launch a fireball"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.REVERSE_3_FIREBALLS,
        Description = {
            Description = {
                "{{Collectible" .. FiendFolio.ITEM.COLLECTIBLE.MALICE .. "}} Transform Isaac into a Malice ball",
                "{{HalfBlackHeart}} Enemies killed have a chance to drop Half Black Hearts"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.IMPLOSION,
        Description = {
            Description = {
                "Throws 3 green fireballs in perpendicular directions away from Isaac",
                "The fireballs summon Hollow Minions on impact"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.CALLING_CARD,
        Description = {
            Description = {
                "{{Charm}} Spawns a friendly Psi Hunter"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.PLAGUE_OF_DECAY,
        Description = {
            Description = {
                "{{RottenHeart}} +5 Rotten Hearts",
                "Fills empty heart containers first, and then replaces existing hearts"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.GROTTO_BEAST,
        Description = {
            Description = {
                "{{Charm}} Spawns a friendly Fiend Folio monster"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.DEFUSE,
        Description = {
            Description = {
                "{{Bomb}} Transforms bomb rocks, troll bombs, and explosive enemies into bomb pickups"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.POT_OF_GREED,
        Description = {
            Description = {
                "Spawns 2 random cards"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.DARK_HOLE,
        Description = {
            Description = {
                "{{Collectible512}} Lets Isaac throw a Black Hole, which sucks in everything"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.EYE_OF_TRUTH,
        Description = {
            Description = {
                "{{Collectible665}} Grants Isaac Guppy's Eye for a room, revealing the contents of chests, sacks, shopkeepers, and fireplaces"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.DESTINY_BOARD,
        Description = {
            Description = {
                "{{Warning}} Isaac consumes a deadly cyanide pill",
                "{{Timer}} While active:",
                "↑ x1.5 Damage multiplier",
                "↑ x1.5 Fire rate multiplier",
                "↑ +0.05 Speed",
                "↑ +0.62 Range",
                "High chance of pills spawning on room clear",
                "{{Warning}} Kills Isaac after 60 seconds",
                "{{Pill}} Death can be prevented by taking a pill"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.DOWNLOAD_FAILURE,
        Description = {
            Description = {
                "Causes all enemies in a room to become glitched",
                "{{Card" .. FiendFolio.ITEM.CARD.DOWNLOAD_FAILURE .. "}} Glitched enemies slide around the room"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.SMALL_CONTRABAND,
        Description = {
            Description = {
                "Better hold onto this!",
                "{{Warning}} I heard a shady guy next floor is looking for it..."
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.SKIP_CARD,
        Description = {
            Description = {
                "Clears the room of all obstacles, pick-ups, and enemies"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.SORRY,
        Description = {
            Description = {
                "{{Collectible422}} Brings Isaac back to the previous room and reverses all actions done in the room the item was used in"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.CARDJITSU_SOCCER,
        Description = {
            Description = {
                "Spawns a soccer ball that can be knocked around to damage enemies"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.CARDJITSU_FLOORING_UPGRADE,
        Description = {
            Description = {
                "Fills the floor of the room with a random creep type"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.CARDJITSU_AC_3000,
        Description = {
            Description = {
                "{{Freezing}} Inflicts all enemies in the room with Freeze"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.MISPRINTED_GISH,
        Description = {
            Description = {
                "Summons a friendly Gish to land on an enemy and fire a tar shot before leaving"
            }
        }
    },
   {
        ID = FiendFolio.ITEM.CARD.SEAL_OF_ORICHALCOS,
        Description = {
            Description = {
                "Creates a huge glyph on the floor for the room",
                "{{Collectible584}} Killing enemies in the glyph gives Isaac an orbital wisp familiar"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.FRIENDLY_FIRE,
        Description = {
            Description = {
                "{{Collectible" ..
                    FiendFolio.ITEM.COLLECTIBLE.FRIENDS_FIREBALL_FORMULA ..
                        "}} Grants Friend's Fireball Formula for a room",
                "{{Burning}} 5% chance to shoot out a purple tear that inflicts Burning on enemies",
                "Burned enemies burst into purple flame jets when killed"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.NEKO_NYAN_QUIZ_CARD,
        Description = {
            Description = {
                "{{Timer}} Transforms Isaac into Goby for 30 seconds",
                "Goby has Flight, and can spawn Blue Beetles that can shield you whenever you damage enemies"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.REDACTED_TRIANGLE,
        Description = {
            Description = {
                "Mimics every active item in the room",
                "Grants temporary copies of every passive item in the room",
                "Temporary passive items are removed when moving to the next floor"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.DRACONIC_FERVOR,
        Description = {
            Description = {
                "When used:",
                "{{Card}} Spawns 2 random cards",
                "{{Heart}} Heals 1 and a half red hearts",
                "{{Battery}} Charges Isaac's active by 2"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.TRIBUNAL_OF_GOOD_AND_EVIL,
        Description = {
            Description = {
                "{{Collectible" .. FiendFolio.ITEM.COLLECTIBLE.EXECUTIONER .."}} Kills a random enemy in the room and marks another enemy to die in 3 seconds",
                "If targeting a boss, damages 20% of its health instead"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.DANCE_OF_USURPATION,
        Description = {
            Description = {
                "Deals moderate damage to all enemies in a room",
                "Damage scales between floors",
                "Enemies killed by this effect drop a random pickup"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.HAUNTED_HOUSE,
        Description = {
            Description = {
                "{{Charm}} When used, all non-boss enemies killed in an active room spawn a temporary friendly copy",
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.DIRE_BOND,
        Description = {
            Description = {
                "{{Warning}} Isaac takes 3 non-lethal damage",
                "{{HalfHeart}} At the end of the next 3 rooms, heals half a heart and grants a random card",
                "{{HalfSoulHeart}} If red hearts are full, grants half a soul heart instead"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.ELF_SONG,
        Description = {
            Description = {
                "Spawns 2 medium fairy flies and 2 blue flies",
                "{{Collectible248}} Blue spiders and flies deal double damage for a room"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.NEIGHBOURS_FROM_HELL,
        Description = {
            Description = {
                "{{Trinket}} Adds a random smelted trinket onto Isaac"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.CREATIVE_AI,
        Description = {
            Description = {
				"Upon use, your main active item is replaced with another random active item for the rest of the floor",
				"Swapping out your item while its effect is active will still have your active replaced",
				"Your active will be returned to you at the start of next floor",
                "!!! Does nothing if you do not have an active item"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.CORRUPTION,
        Description = {
            Description = {
                "{{Battery}} For the rest of this floor, ALL active items that charge on room clear and are not in your pocket slot have a maximum charge of 1",
                "!!! These active items will be removed at the start of next floor",
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.BLASPHEMY,
        Description = {
            Description = {
                "{{Collectible577}} Gain the effect of Damocles for the rest of the current floor",
				"{{HalfHeart}} Deals half a heart of damage to Isaac",
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.ABERRANT_LOVERS,
        Description = {
            Description = {
                "Drops 2 Morbid Hearts but makes Isaac lose half his red health"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.ABERRANT_DEATH,
        Description = {
            Description = {
                "Respawns all enemies in the room but with a 50% chance for any to be friendly instead"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.ABERRANT_TOWER,
        Description = {
            Description = {
                "Spawns 3 reticles on the floor that Isaac can control",
                "After a short delay, 4 missiles will drop on each one"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.ABERRANT_STARS,
        Description = {
            Description = {
                "Fills any empty consumable and trinket slots that Isaac has"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.ABERRANT_MOON,
        Description = {
            Description = {
                "Reveals the secret and super secret rooms and opens any adjacent red rooms"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.ABERRANT_SUN,
        Description = {
            Description = {
                "Isaac will heal half a red heart every 15 seconds, to a total of 6 hearts",
                "Soul heart characters will get 2 total soul hearts instead"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.HAPPY_SQUIRREL,
        Description = {
            Description = {
                "{{ArcadeRoom}} Teleports Isaac to a special Arcade room"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.THE_INVISIBLE_MOON,
        Description = {
            Description = {
                "{{ffBerserk}} Inflicts all enemies in a room with Berserk for 15 seconds",
                "Effect persists between multiple rooms"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.ENERGY_GRASS,
        Description = {
            Description = {
                "{{Poison}} Inflicts all enemies in a room with Poison"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.ENERGY_FIRE,
        Description = {
            Description = {
                "{{Burning}} Inflicts all enemies in a room with Burning"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.ENERGY_WATER,
        Description = {
            Description = {
                "Causes all enemies in the room to periodically fire tears" -- "Inflicts all enemies in the room with bloating.",
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.ENERGY_LIGHTNING,
        Description = {
            Description = {
                "{{ffOverloaded}} Inflicts all enemies in a room with Overloaded",
                "{{ffOverloaded}} Overloaded enemies short-circuit and fire short-ranged lasers around themselves",
                "Enemies hit by the lasers have a chance to become overloaded"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.ENERGY_FIGHTING,
        Description = {
            Description = {
                "{{ffBruise}} Inflicts all enemies in a room with Bruising",
                "{{ffBruise}} Bruised enemies take bonus damage per stack applied"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.ENERGY_PSYCHIC,
        Description = {
            Description = {
                "{{Confusion}} Inflicts all enemies in a room with Confusion"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.ENERGY_COLORLESS,
        Description = {
            Description = {
                "{{ffMultieuclidean}} Inflicts all enemies in a room with Multi-Euclidean"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.ENERGY_DARKNESS,
        Description = {
            Description = {
                "{{Fear}} Inflicts all enemies in a room with Fear"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.ENERGY_METAL,
        Description = {
            Description = {
                "{{ffHemorrhage}} Inflicts all enemies in a room with Hemorrhaging",
                "{{ffHemorrhage}} Hemorrhaged enemies constantly take damage and spew blood creep and tears"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.ENERGY_FAIRY,
        Description = {
            Description = {
                "{{Charm}} Inflicts all enemies in a room with Charm"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.ENERGY_DRAGON,
        Description = {
            Description = {
                "Triggers two random Energy Cards"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.TRAINER_CARD,
        Description = {
            Description = {
                "Using the card throws it in the direction Isaac is facing",
                "{{Charm}} Instantly charms all enemies and bosses it touches"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.OJ_BUSINESS,
        Description = {
            Description = {
                "{{ffLilPenny}} Inflicts all enemies in the room with Mugged"
            },
            StatusEffects = { FiendFolio.DescriptionStatuses.MUGGED },
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.OJ_STRONGER,
        Description = {
            Description = {
                "{{Timer}} Receive for the room:",
                "↑ +1 Damage",
                "Gives double the damage if you've taken damage this room",
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.OJ_PRESENT,
        Description = {
            Description = {
                "Spawns 2 random 100% Orange Juice cards",
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.OJ_SEAGULLS,
        Description = {
            Description = {
                "Deals damage to a random enemy or player in the room",
                "{{Collectible486}} Players take fake damage instead"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.OJ_FIRE_SUPPORT,
        Description = {
            Description = {
                "{{Collectible47}} Fires 4 low damage rockets at random enemies"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.OJ_SERENE_HUSH,
        Description = {
            Description = {
                "Pacifies all enemies in the room",
                "{{ffPacified}} Pacified enemies are unable to deal damage to Isaac"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.OJ_MIX_PHENOMENON,
        Description = {
            Description = {
                "{{Collectible" .. tostring(FiendFolio.ITEM.COLLECTIBLE.HUNDRED_PERCENT_ORANGE_JUICE) ..
                    "}} If there are less than 3 Orange Juice tiles, spawns up to 3",
                "Also rerolls any Orange Juice tiles in the room"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.OJ_JONATHAN_RUSH,
        Description = {
            Description = {
                "Teleports Isaac to an enemy and explodes while becoming invulnerable for a period",
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.OJ_ENCHANTMENT,
        Description = {
            Description = {
                "↑ +0.15 Speed for the room"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.OJ_HINDENPEATER,
        Description = {
            Description = {
                "{{Collectible108}} All damage is reduced to half a heart",
                "↑ All stats up for the room"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.GLASS_D6,
        Description = {
            Description = {
                "{{Collectible105}} Activates the D6 effect, rerolling pedestal items in the room"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.GLASS_D4,
        Description = {
            Description = {
                "{{Collectible284}} Activates the D4 effect, rerolling Isaac's passive items"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.GLASS_D8,
        Description = {
            Description = {
                "{{Collectible406}} Activates the D8 effect, rerolling Isaac's stats"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.GLASS_D100,
        Description = {
            Description = {
                "{{Collectible283}} Activates the D100 effect, activating the effects of the D1, D4, D6, D7, D8, D10, D12 and D20 at once"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.GLASS_D10,
        Description = {
            Description = {
                "{{Collectible285}} Activates the D10 effect, devolving all enemies in the room"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.GLASS_D20,
        Description = {
            Description = {
                "{{Collectible166}} Activates the D20 effect, rerolling all pickups in the room"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.GLASS_D12,
        Description = {
            Description = {
                "{{Collectible386}} Activates the D12 effect, rerolling all obstacles in a room"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.GLASS_SPINDOWN,
        Description = {
            Description = {
                "{{Collectible723}} Activates the Spindown Dice effect, rerolling all items in the room by decreasing their internal ID number by one"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.GLASS_AZURITE_SPINDOWN,
        Description = {
            Description = {
                "{{Collectible" ..
                    tostring(FiendFolio.ITEM.COLLECTIBLE.AZURITE_SPINDOWN) ..
                        "}} Activates the Azurite Spindown Dice effect, rerolling all trinkets in the room by decreasing their internal ID number by one"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.GLASS_D2,
        Description = {
            Description = {
                "{{Collectible" ..
                    tostring(FiendFolio.ITEM.COLLECTIBLE.D2) ..
                        "}} Activates the D2 effect, throwing it onto the floor temporarily",
                "Any pickups, enemies and tears touching it will be rerolled"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.GLASS_D3,
        Description = {
            Description = {
                "{{Collectible" ..
                    tostring(FiendFolio.ITEM.COLLECTIBLE.D3) ..
                        "}} Activates the D3 effect for the room, spawning an orbital familiar that rerolls tears"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.GLASS_D5,
        Description = {
            Description = {
                "{{Collectible" ..
                    tostring(FiendFolio.ITEM.COLLECTIBLE.D5) ..
                        "}} Activates the D5 effect for the room, spawning a dice that can be thrown around",
                "When it lands, it does an effect depending on the side"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.D10_SHARD,
        Description = {
            Description = {
                "{{Collectible285}} Activates the D10 and D12 effects, rerolling grids and devolving enemies in the room"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.ETERNAL_SHARD,
        Description = {
            Description = {
                "{{Collectible609}} Activates the Eternal D6, D10, and D12 effects which rerolls all pedestals, enemies, and grids in the room",
                "There is a 50% chance to delete the targets instead"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.D8_SHARD,
        Description = {
            Description = {
                "{{Collectible284}} Activates the D4 and D8 effects, rerolling Isaac's stats and passive items"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.GREEN_HOUSE,
        Description = {
            Description = {
                "Clears all enemies and pickups from a room, causing them to spawn in the next room"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.BRICK_SEPERATOR,
        Description = {
            Description = {
                "Splits all enemies in the room into 2 smaller versions of themselves with less health",
                "Grants piercing tears for the room"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.PUZZLE_PIECE,
        Description = {
            Description = {
                "Completes 1/3 of a puzzle fortune",
                "When the fortune is completed, a reward is spawned",
                "The prize spawned is related to the fortune created"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.COOL_PHOTO,
        Description = {
            Description = {
                "{{Coin}} Spawns 1-2 coins"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.BLANK_LETTER_TILE,
        Description = {
            Description = {
                "The next button Isaac presses will grant a stat boost:",
                "↑ +1 Damage",
                "↑ +1 Tears",
                "This effect ends upon leaving the floor"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.HORSE_PUSHPOP,
        Description = {
            Description = {
                "{{BrokenHeart}} Heals 1 Broken Heart"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.TOP_HAT,
        Description = {
            Description = {
                "Summons an opened Shop Chest"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.GIFT_CARD,
        Description = {
            Description = {
                "{{Collectible515}} Rerolls item pedestals into Mystery Gift"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.STUD,
        Description = {
            Description = {
                FiendFolio.DescriptionIcons.Stud .. "Spawns a Stud penny on the ground",
                "{{Coin}} Stud pennies are worth 1 coin and deal contact damage to enemies",
                "{{Collectible486}} Stud pennies deal fake damage to Isaac on pickup",
                "Up to 6 stud objects can be stacked in the same card slot"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.STUD_2,
        Description = {
            Description = {
                FiendFolio.DescriptionIcons.Stud .. "Spawns a Stud penny on the ground",
                "{{Coin}} Stud pennies are worth 1 coin and deal contact damage to enemies",
                "{{Collectible486}} Stud pennies deal fake damage to Isaac on pickup",
                "Up to 6 stud objects can be stacked in the same card slot"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.STUD_3,
        Description = {
            Description = {
                FiendFolio.DescriptionIcons.Stud .. "Spawns a Stud penny on the ground",
                "{{Coin}} Stud pennies are worth 1 coin and deal contact damage to enemies",
                "{{Collectible486}} Stud pennies deal fake damage to Isaac on pickup",
                "Up to 6 stud objects can be stacked in the same card slot"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.STUD_4,
        Description = {
            Description = {
                FiendFolio.DescriptionIcons.Stud .. "Spawns a Stud penny on the ground",
                "{{Coin}} Stud pennies are worth 1 coin and deal contact damage to enemies",
                "{{Collectible486}} Stud pennies deal fake damage to Isaac on pickup",
                "Up to 6 stud objects can be stacked in the same card slot"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.STUD_5,
        Description = {
            Description = {
                FiendFolio.DescriptionIcons.Stud .. "Spawns a Stud penny on the ground",
                "{{Coin}} Stud pennies are worth 1 coin and deal contact damage to enemies",
                "{{Collectible486}} Stud pennies deal fake damage to Isaac on pickup",
                "Up to 6 stud objects can be stacked in the same card slot"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.STUD_6,
        Description = {
            Description = {
                FiendFolio.DescriptionIcons.Stud .. "Spawns a Stud penny on the ground",
                "{{Coin}} Stud pennies are worth 1 coin and deal contact damage to enemies",
                "{{Collectible486}} Stud pennies deal fake damage to Isaac on pickup",
                "Up to 6 stud objects can be stacked in the same card slot"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.CHRISTMAS_CRACKER,
        Description = {
            Description = {
                "Explodes without hurting you",
                "{{ffObject}} Spawns a random object",
                "Tells a hilarious joke!"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.PINK_COW,
        Description = {
            Description = {
                "One enemy in the next 4 rooms is Pacified for a long duration",
                "{{ffPacified}} Pacified enemies are unable to deal damage to Isaac"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.YELLOW_CAR,
        Description = {
            Description = {
                "↑ +1 Speed",
                "Speed bonus goes down by 0.15 after clearing a room"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.LUCKY_DUCK,
        Description = {
            Description = {
                "{{Timer}} Receive for the room:",
                "↑ +7.77 Luck"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.COMICAL_ROUND_GLASSES,
        Description = {
            Description = {
                "{{Timer}} Receive for the room:",
                "↓ x0.8 Damage multiplier",
                "{{Collectible245}} Isaac shoots 2 tears at once",
                "↑ +2.5 Range"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.EGG_SACK,
        Description = {
            Description = {
                "Spawns 3 blue spiders, 3 blue flies, 3 blue skuzzes, 3 blue beetles, and 3 blue baby spiders"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.TREASURE_DISC,
        Description = {
            Description = {
                "{{ffDisc}} Isaac receives 3-5 random Treasure Room items",
                "{{Timer}} These items last for 60 seconds"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.SHOP_DISC,
        Description = {
            Description = {
                "{{ffDisc}} Isaac receives 3-5 random Shop items",
                "{{Timer}} These items last for 60 seconds"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.BOSS_DISC,
        Description = {
            Description = {
                "{{ffDisc}} Isaac receives 3-5 random Boss Room items",
                "{{Timer}} These items last for 60 seconds"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.SECRET_DISC,
        Description = {
            Description = {
                "{{ffDisc}} Isaac receives 3-5 random Secret Room items",
                "{{Timer}} These items last for 60 seconds"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.DEVIL_DISC,
        Description = {
            Description = {
                "{{ffDisc}} Isaac receives 3-5 random Devil Room items",
                "{{Timer}} These items last for 60 seconds"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.ANGEL_DISC,
        Description = {
            Description = {
                "{{ffDisc}} Isaac receives 3-5 random Angel Room items",
                "{{Timer}} These items last for 60 seconds"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.PLANETARIUM_DISC,
        Description = {
            Description = {
                "{{ffDisc}} Isaac receives 3-5 random Planetarium items",
                "{{Timer}} These items last for 60 seconds"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.CHAOS_DISC,
        Description = {
            Description = {
                "{{ffDisc}} Isaac receives 3-5 random items",
                "{{Timer}} These items last for 60 seconds"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.BROKEN_DISC,
        Description = {
            Description = {
                "{{ffDisc}} Isaac receives 3-5 copies of a single random item",
                "{{Timer}} These items last for 60 seconds"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.TAINTED_TREASURE_DISC,
        Description = {
            Description = {
                "{{ffDisc}} Isaac receives 3-5 random Tainted Treasure Room items",
                "{{Timer}} These items last for 60 seconds"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.MISPRINTED_JACK_OF_CLUBS,
        Description = {
            Description = {
                "{{GoldenBomb}} Spawns a golden troll bomb",
                "{{Bomb}} Converts all bombs in the room into troll bombs"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.MISPRINTED_TWO_OF_CLUBS,
        Description = {
            Description = {
                "{{Bomb}} Doubles Isaac's number of bombs",
                "{{ffCopperBomb}} All held bombs are converted into copper bombs"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.MISPRINTED_THREE_OF_DIAMONDS,
        Description = {
            Description = {
                "{{Trinket}} Spawns 3 penny trinkets",
                "Once one is taken, the others despawn"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.THREE_OF_DIAMONDS,
        Description = {
            Description = {
                "{{Coin}} Spawns 3 random coins"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.THREE_OF_CLUBS,
        Description = {
            Description = {
                "{{Bomb}} Spawns 3 random bombs",
                ""
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.THREE_OF_SPADES,
        Description = {
            Description = {
                "{{Key}} Spawns 3 random keys"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.THREE_OF_HEARTS,
        Description = {
            Description = {
                "{{Heart}} Spawns 3 random hearts"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.JACK_OF_DIAMONDS,
        Description = {
            Description = {
                "{{ffCursedPenny}} Spawns 2-4 cursed pennies",
                "Converts all coins in the room into cursed pennies"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.JACK_OF_CLUBS,
        Description = {
            Description = {
                "{{ffCopperBomb}} Spawns 2-3 copper bombs",
                "Converts all bombs in the room into copper bombs"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.JACK_OF_SPADES,
        Description = {
            Description = {
                "{{ffSpicyKey}} Spawns 1-2 spicy keys",
                "Converts all keys in the room into spicy keys"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.JACK_OF_HEARTS,
        Description = {
            Description = {
                "{{ffImmoralHeart}} Converts all of Isaac's held Soul Hearts into Immoral Hearts",
                "{{ffImmoralHeart}} Turns all hearts in the room into Immoral Hearts",
                "Spawns an Immoral Heart if Isaac doesn't have one"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.QUEEN_OF_DIAMONDS,
        Description = {
            Description = {
                "{{Coin}} Converts all obstacles in a room into coins",
                "{{Timer}} Coins spawned this way disappear after 5 seconds"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.QUEEN_OF_CLUBS,
        Description = {
            Description = {
                "{{Collectible52}} Grants Dr. Fetus for the room, replacing Isaac's tears with bombs"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.QUEEN_OF_SPADES,
        Description = {
            Description = {
                "{{Key}} Spawns 1-10 keys"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.KING_OF_DIAMONDS,
        Description = {
            Description = {
                "{{Collectible202}} Turns all enemies in the room into gold statues",
                "Converts 25% of rocks in the room into Fool's Gold rocks"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.KING_OF_CLUBS,
        Description = {
            Description = {
                "{{GigaBomb}} Spawns an unprimed Giga Bomb pickup"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.KING_OF_SPADES,
        Description = {
            Description = {
                "{{Key}} +1 Key",
                "{{Collectible623}} Player tears will be converted into Sharp Key tears for the duration of the room",
                "!!! If you have no keys, tears will not be converted"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.ACE_OF_WANDS,
        Description = {
            Description = {
                "{{Battery}} Turns all pickups, chests and non-boss enemies into random batteries",
                "!!! Batteries disappear after 2 seconds"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.TWO_OF_WANDS,
        Description = {
            Description = {
                "{{Battery}} Doubles the current charge of active items held by Isaac",
                "{{Collectible63}} Can be used to overcharge active items"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.THREE_OF_WANDS,
        Description = {
            Description = {
                "{{Battery}} Spawns 3 random batteries",
                "!!! Batteries disappear after 3 seconds"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.KING_OF_WANDS,
        Description = {
            Description = {
                "{{Battery}} Upgrades batteries in the room to their next tier"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.ACE_OF_PENTACLES,
        Description = {
            Description = {
                "{{Trinket}} Turns all pickups, chests and non-boss enemies into trinkets"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.TWO_OF_PENTACLES,
        Description = {
            Description = {
                "{{Trinket}} Doubles all trinkets currently held by Isaac",
                "Spawns a random trinket if no trinkets are currently held",
                "!!! Does not spawn duplicates of gulped trinkets"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.THREE_OF_PENTACLES,
        Description = {
            Description = {
                "{{Trinket}} Spawns 3 random trinkets",
            },
			Conditional = function (descObj)
				local data = Isaac.GetPersistentGameData()
				if data:Unlocked(Achievement.GOLDEN_TRINKET) then
					local split = mod:SplitString(descObj.Description, "#")

					table.insert(split, "#These trinkets have a 50% chance of being golden")

					descObj.Description = table.concat(split, "#")
				end
			end
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.KING_OF_PENTACLES,
        Description = {
            Description = {
                "{{Trinket}} Converts all trinkets in the room and held by Isaac into golden trinkets",
                "!!! Has no effect on gulped trinkets"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.REVERSE_KING_OF_PENTACLES,
        Description = {
            Description = {
                "{{Trinket}} Converts all trinkets in the room and held by Isaac into rock trinkets",
                "!!! Has no effect on gulped trinkets"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.MISPRINTED_KING_OF_PENTACLES,
        Description = {
            Description = {
                "{{Trinket}} Converts all trinkets in the room and held by Isaac into Blasphemous trinkets",
                "{{Damage}} Blasphemous trinkets grant +1 Damage if you hold or smelt them",
                "!!! Has no effect on gulped trinkets"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.ACE_OF_SWORDS,
        Description = {
            Description = {
                "Turns all pickups, chests and non-boss enemies into friendly blue flies, spiders, skuzzes, dips, beetles, minisaacs, fragile bobbies, blue baby spiders, ladybirds, fairy flies, and mini Level 0 Flies"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.TWO_OF_SWORDS,
        Description = {
            Description = {
                "Doubles all blue flies, spiders, skuzzes, friendly dips, and beetles in the room",
                "{{Collectible357}} Activates Box of Friends"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.THREE_OF_SWORDS,
        Description = {
            Description = {
                "Spawns 3 random blue flies, locusts, blue spiders, blue skuzzes, fleas, blue beetles, dip familiars, minisaacs, fragile bobbies, blue baby spiders, ladybirds, fairy flies, or mini Level 0 Flies"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.KING_OF_SWORDS,
        Description = {
            Description = {
                "{{Collectible247}} Grants the effects of BFFS! for the remainder of the floor"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.ACE_OF_CUPS,
        Description = {
            Description = {
                "{{Pill}} Turns all pickups, chests and non-boss enemies into pills"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.TWO_OF_CUPS,
        Description = {
            Description = {
                "{{Pill}} Doubles all pills in the room and held by Isaac",
                "Spawns 2 random pills if Isaac is holding none"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.THREE_OF_CUPS,
        Description = {
            Description = {
                "{{Pill}} Spawns 3 random pills",
                "These pills have a 50% chance of being horse pills"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.KING_OF_CUPS,
        Description = {
            Description = {
                "{{Pill}} Converts all pills in the room and held by Isaac into horse pills"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.MISPRINTED_JOKER,
        Description = {
            Description = {
                "Rerolls items in the room into Devil or Angel items",
                "{{Warning}} Has a small chance to convert items in the room into holy or devilish-themed hearts/chests"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.THIRTEEN_OF_STARS,
        Description = {
            Description = {
                "{{Collectible721}} Spawns a glitched item"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.REVERSE_KING_OF_CLUBS,
        Description = {
            Description = {
                "{{GigaBomb}} Causes a Giga Bomb explosion on top of Isaac"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.MISPRINTED_JUSTICEJACK,
        Description = {
            Description = {
                "{{ffImmoralHeart}} Spawns an Immoral Heart",
                "{{ffCopperBomb}} Spawns a Copper Bomb",
                "{{ffSpicyKey}} Spawns a pair of Spicy Keys",
                "{{ffCursedPenny}} Spawns a Cursed Penny"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.RUNE_ANSUS,
        Description = {
            Description = {
                "{{Timer}} Full mapping effect for the floor."
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.SOUL_OF_FIEND,
        Description = {
            Description = {
                "Spawns 5-8 Fiend Minions and 0-2 Black Heart Minions"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.SOUL_OF_GOLEM,
        Description = {
            Description = {
                "{{Trinket}} Spawns 3 Golem trinkets"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.SOUL_OF_RANDOM,
        Description = {
            Description = {
                "Triggers a random soulstone effect"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.SOUL_OF_CRAIG,
        Description = {
            Description = {
                "{{Battery}} Overcharges Isaac's active item up to two full charges",
                "{{Collectible" ..
                    tostring(FiendFolio.ITEM.COLLECTIBLE.EXCELSIOR) ..
                        "}} Using your active item will shoot fireworks based on the amount of item charge",
                "{{Collectible584}} Using your active item activates Book of Virtues",
                ""
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.SOUL_OF_INABA,
        Description = {
            Description = {
                "Activates Migraine Mode, granting Isaac two Inaba satellites"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.STORAGE_BATTERY_0,
        Description = {
            Description = {
                "{{Battery}} Stores charge from Isaac's active item",
                "Activate again to recharge active item",
                "{{Collectible63}} Can be used to overcharge active items",
                "{{Card" .. tostring(FiendFolio.ITEM.CARD.CORRODED_BATTERY_0) .. "}} Becomes corroded on floor start"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.STORAGE_BATTERY_1,
        Description = {
            Description = {
                "{{Battery}} Stores charge from Isaac's active item",
                "Activate again to recharge active item",
                "{{Collectible63}} Can be used to overcharge active items",
                "{{Card" .. tostring(FiendFolio.ITEM.CARD.CORRODED_BATTERY_1) .. "}} Becomes corroded on floor start"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.STORAGE_BATTERY_2,
        Description = {
            Description = {
                "{{Battery}} Stores charge from Isaac's active item",
                "Activate again to recharge active item",
                "{{Collectible63}} Can be used to overcharge active items",
                "{{Card" .. tostring(FiendFolio.ITEM.CARD.CORRODED_BATTERY_2) .. "}} Becomes corroded on floor start"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.STORAGE_BATTERY_3,
        Description = {
            Description = {
                "{{Battery}} Stores charge from Isaac's active item",
                "Activate again to recharge active item",
                "{{Collectible63}} Can be used to overcharge active items",
                "{{Card" .. tostring(FiendFolio.ITEM.CARD.CORRODED_BATTERY_3) .. "}} Becomes corroded on floor start"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.CORRODED_BATTERY_0,
        Description = {
            Description = {
                "{{Battery}} Stores charge from Isaac's active item",
                "Activate again to recharge active item",
                "{{Collectible63}} Can be used to overcharge active items",
                "!!! After recharging active items, explodes after a short delay"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.CORRODED_BATTERY_1,
        Description = {
            Description = {
                "{{Battery}} Stores charge from Isaac's active item",
                "Activate again to recharge active item",
                "{{Collectible63}} Can be used to overcharge active items",
                "!!! After recharging active items, explodes after a short delay"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.CORRODED_BATTERY_2,
        Description = {
            Description = {
                "{{Battery}} Stores charge from Isaac's active item",
                "Activate again to recharge active item",
                "{{Collectible63}} Can be used to overcharge active items",
                "!!! After recharging active items, explodes after a short delay"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.CORRODED_BATTERY_3,
        Description = {
            Description = {
                "{{Battery}} Stores charge from Isaac's active item",
                "Activate again to recharge active item",
                "{{Collectible63}} Can be used to overcharge active items",
                "!!! After recharging active items, explodes after a short delay"
            }
        }
    },
    {
        ID = FiendFolio.ITEM.CARD.SOUL_OF_FRIEND,
        Description = {
            Description = {
                "Grants Isaac a random gun with limited ammo",
                "Gun fires along with Isaac's tears",
                "Disappears after running out of ammo"
            }
        }
    },
}

FiendFolio.ExternalDescriptions.Pills = {
	{
        ID = FiendFolio.ITEM.PILL.CYANIDE,
        Description = {
            Description = {
                "{{Timer}} While active:",
                "↑ x1.5 Damage multiplier",
                "↑ x1.3 Fire rate multiplier",
                "↑ +0.05 Speed",
				"↑ +0.62 Range",
				"High chance of pills spawning on room clear",
				"{{Warning}} Kills Isaac after 60 seconds",
				"{{Pill}} Death can be prevented by taking a pill",
            }
        }
    },
	{
        ID = FiendFolio.ITEM.PILL.MELATONIN,
        Description = {
            Description = {
                "Makes enemies Drowsy",
			},
			StatusEffects = { FiendFolio.DescriptionStatuses.DROWSY_AND_SLEEP },
        }
    },
	{
        ID = FiendFolio.ITEM.PILL.HOLY_SHIT,
        Description = {
            Description = {
                "Spawns a Holy Poop",
            }
        }
    },
	{
        ID = FiendFolio.ITEM.PILL.HAEMORRHOIDS,
        Description = {
            Description = {
                "Spawns a Red Poop",
            }
        }
    },
	{
        ID = FiendFolio.ITEM.PILL.FISH_OIL,
        Description = {
            Description = {
                "Increases tear size",
            }
        }
    },
	{
        ID = FiendFolio.ITEM.PILL.LEMON_JUICE,
        Description = {
            Description = {
                "Reduces tear size",
            }
        }
    },
	{
        ID = FiendFolio.ITEM.PILL.EPIDERMOLYSIS,
        Description = {
            Description = {
                "Decreases invincibility frames when hit",
            }
        }
    },
	{
        ID = FiendFolio.ITEM.PILL.CLAIRVOYANCE,
        Description = {
            Description = {
                "Removes floor curses",
                "{{Collectible287}} Actives Book of Secrets on use"
            }
        }
    },
	{
        ID = FiendFolio.ITEM.PILL.SPIDER_UNBOXING,
        Description = {
            Description = {
                "Spawns 2 blue spiders and 10 blue baby spiders",
            }
        }
    },
	{
        ID = FiendFolio.ITEM.PILL.MORNING_AFTER_PILL,
        Description = {
            Description = {
                "Spawns 1 Fragile Bobby",
				"{{Collectible8}} Fragile bobbies are similar to Brother Bobby but can die"
            }
        }
    },
	{
        ID = FiendFolio.ITEM.PILL.BRIMSTONE,
        Description = {
            Description = {
                "{{Collectible118}} Gives you Brimstone forever!!!! XD",
            }
        }
    },
	{
        ID = FiendFolio.ITEM.PILL.SERTRALINE,
        Description = {
            Description = {
                "{{Collectible" .. FiendFolio.ITEM.COLLECTIBLE.SERTRALINE .. "}} Destroys all enemy tears and briefly prevents new ones from spawning",
            }
        }
    },
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
	--Cards
	local EncycloCards = {
		{ID = FiendFolio.ITEM.CARD.PLUS_3_FIREBALLS},
		{ID = FiendFolio.ITEM.CARD.IMPLOSION},
		{ID = FiendFolio.ITEM.CARD.CALLING_CARD},
		{ID = FiendFolio.ITEM.CARD.GROTTO_BEAST},
		{ID = FiendFolio.ITEM.CARD.DOWNLOAD_FAILURE},
		{ID = FiendFolio.ITEM.CARD.PUZZLE_PIECE},
		{ID = FiendFolio.ITEM.CARD.PLAGUE_OF_DECAY},
		{ID = FiendFolio.ITEM.CARD.DEFUSE},
		{ID = FiendFolio.ITEM.CARD.POT_OF_GREED},
		{ID = FiendFolio.ITEM.CARD.SMALL_CONTRABAND},
		{ID = FiendFolio.ITEM.CARD.SKIP_CARD},
		{ID = FiendFolio.ITEM.CARD.THREE_OF_CLUBS},
		{ID = FiendFolio.ITEM.CARD.JACK_OF_CLUBS},
		{ID = FiendFolio.ITEM.CARD.QUEEN_OF_CLUBS},
		{ID = FiendFolio.ITEM.CARD.KING_OF_CLUBS},
		{ID = FiendFolio.ITEM.CARD.THREE_OF_DIAMONDS},
		{ID = FiendFolio.ITEM.CARD.JACK_OF_DIAMONDS},
		{ID = FiendFolio.ITEM.CARD.QUEEN_OF_DIAMONDS},
		{ID = FiendFolio.ITEM.CARD.KING_OF_DIAMONDS},
		{ID = FiendFolio.ITEM.CARD.THREE_OF_SPADES},
		{ID = FiendFolio.ITEM.CARD.JACK_OF_SPADES},
		{ID = FiendFolio.ITEM.CARD.QUEEN_OF_SPADES},
		{ID = FiendFolio.ITEM.CARD.KING_OF_SPADES},
		{ID = FiendFolio.ITEM.CARD.THREE_OF_HEARTS},
		{ID = FiendFolio.ITEM.CARD.JACK_OF_HEARTS},
		{ID = FiendFolio.ITEM.CARD.MISPRINTED_JOKER},
		{ID = FiendFolio.ITEM.CARD.THIRTEEN_OF_STARS},
		{ID = FiendFolio.ITEM.CARD.ACE_OF_WANDS},
		{ID = FiendFolio.ITEM.CARD.ACE_OF_PENTACLES},
		{ID = FiendFolio.ITEM.CARD.ACE_OF_SWORDS},
		{ID = FiendFolio.ITEM.CARD.ACE_OF_CUPS},
		{ID = FiendFolio.ITEM.CARD.TWO_OF_WANDS},
		{ID = FiendFolio.ITEM.CARD.TWO_OF_PENTACLES},
		{ID = FiendFolio.ITEM.CARD.TWO_OF_SWORDS},
		{ID = FiendFolio.ITEM.CARD.TWO_OF_CUPS},
		{ID = FiendFolio.ITEM.CARD.THREE_OF_WANDS},
		{ID = FiendFolio.ITEM.CARD.THREE_OF_PENTACLES},
		{ID = FiendFolio.ITEM.CARD.THREE_OF_SWORDS},
		{ID = FiendFolio.ITEM.CARD.THREE_OF_CUPS},
		{ID = FiendFolio.ITEM.CARD.KING_OF_WANDS},
		{ID = FiendFolio.ITEM.CARD.KING_OF_PENTACLES},
		{ID = FiendFolio.ITEM.CARD.KING_OF_SWORDS},
		{ID = FiendFolio.ITEM.CARD.KING_OF_CUPS},
		{ID = FiendFolio.ITEM.CARD.REVERSE_KING_OF_CLUBS},
		{ID = FiendFolio.ITEM.CARD.GLASS_D6},
		{ID = FiendFolio.ITEM.CARD.GLASS_D4},
		{ID = FiendFolio.ITEM.CARD.GLASS_D8},
		{ID = FiendFolio.ITEM.CARD.GLASS_D100},
		{ID = FiendFolio.ITEM.CARD.GLASS_D10},
		{ID = FiendFolio.ITEM.CARD.GLASS_D20},
		{ID = FiendFolio.ITEM.CARD.GLASS_D12},
		{ID = FiendFolio.ITEM.CARD.GLASS_SPINDOWN},
		{ID = FiendFolio.ITEM.CARD.GLASS_AZURITE_SPINDOWN},
		{ID = FiendFolio.ITEM.CARD.GLASS_D2},
		{ID = FiendFolio.ITEM.CARD.GLASS_D5},
		{ID = FiendFolio.ITEM.CARD.GLASS_D3},
		{ID = FiendFolio.ITEM.CARD.STORAGE_BATTERY_0},
		{ID = FiendFolio.ITEM.CARD.STORAGE_BATTERY_1, Hide = true},
		{ID = FiendFolio.ITEM.CARD.STORAGE_BATTERY_2, Hide = true},
		{ID = FiendFolio.ITEM.CARD.STORAGE_BATTERY_3, Hide = true},
		{ID = FiendFolio.ITEM.CARD.CORRODED_BATTERY_0, Hide = true},
		{ID = FiendFolio.ITEM.CARD.CORRODED_BATTERY_1, Hide = true},
		{ID = FiendFolio.ITEM.CARD.CORRODED_BATTERY_2, Hide = true},
		{ID = FiendFolio.ITEM.CARD.CORRODED_BATTERY_3, Hide = true},
		{ID = FiendFolio.ITEM.CARD.GREEN_HOUSE},
		{ID = FiendFolio.ITEM.CARD.BRICK_SEPERATOR},
		{ID = FiendFolio.ITEM.CARD.BLANK_LETTER_TILE},
		{ID = FiendFolio.ITEM.CARD.TOP_HAT},
		{ID = FiendFolio.ITEM.CARD.CHRISTMAS_CRACKER},
		{ID = FiendFolio.ITEM.CARD.STUD},
		{ID = FiendFolio.ITEM.CARD.STUD_2, Hide = true},
		{ID = FiendFolio.ITEM.CARD.STUD_3, Hide = true},
		{ID = FiendFolio.ITEM.CARD.STUD_4, Hide = true},
		{ID = FiendFolio.ITEM.CARD.STUD_5, Hide = true},
		{ID = FiendFolio.ITEM.CARD.STUD_6, Hide = true},
		{ID = FiendFolio.ITEM.CARD.TREASURE_DISC},
		{ID = FiendFolio.ITEM.CARD.SHOP_DISC},
		{ID = FiendFolio.ITEM.CARD.BOSS_DISC},
		{ID = FiendFolio.ITEM.CARD.SECRET_DISC},
		{ID = FiendFolio.ITEM.CARD.DEVIL_DISC},
		{ID = FiendFolio.ITEM.CARD.ANGEL_DISC},
		{ID = FiendFolio.ITEM.CARD.PLANETARIUM_DISC},
		{ID = FiendFolio.ITEM.CARD.CHAOS_DISC},
		{ID = FiendFolio.ITEM.CARD.BROKEN_DISC},
		{ID = FiendFolio.ITEM.CARD.TAINTED_TREASURE_DISC},
		{ID = FiendFolio.ITEM.CARD.REVERSE_3_FIREBALLS},
		{ID = FiendFolio.ITEM.CARD.CARDJITSU_SOCCER},
		{ID = FiendFolio.ITEM.CARD.CARDJITSU_FLOORING_UPGRADE},
		{ID = FiendFolio.ITEM.CARD.CARDJITSU_AC_3000},
		{ID = FiendFolio.ITEM.CARD.GIFT_CARD},
		{ID = FiendFolio.ITEM.CARD.MISPRINTED_JACK_OF_CLUBS},
		{ID = FiendFolio.ITEM.CARD.MISPRINTED_TWO_OF_CLUBS},
		{ID = FiendFolio.ITEM.CARD.ENERGY_GRASS},
		{ID = FiendFolio.ITEM.CARD.ENERGY_FIRE},
		{ID = FiendFolio.ITEM.CARD.ENERGY_WATER},
		{ID = FiendFolio.ITEM.CARD.ENERGY_LIGHTNING},
		{ID = FiendFolio.ITEM.CARD.ENERGY_FIGHTING},
		{ID = FiendFolio.ITEM.CARD.ENERGY_PSYCHIC},
		{ID = FiendFolio.ITEM.CARD.ENERGY_COLORLESS},
		{ID = FiendFolio.ITEM.CARD.ENERGY_DARKNESS},
		{ID = FiendFolio.ITEM.CARD.ENERGY_METAL},
		{ID = FiendFolio.ITEM.CARD.ENERGY_DRAGON},
		{ID = FiendFolio.ITEM.CARD.ENERGY_FAIRY},
		{ID = FiendFolio.ITEM.CARD.TRAINER_CARD, Hide = true},
		{ID = FiendFolio.ITEM.CARD.COOL_PHOTO},
		{ID = FiendFolio.ITEM.CARD.HORSE_PUSHPOP},
	}

	for _, info in pairs(EncycloCards) do
		Encyclopedia.AddCard({
			Class = "Fiend Folio",
			ID = info.ID,
			WikiDesc = Encyclopedia.EIDtoWiki(__eidCardDescriptions[info.ID] or GetEidDesc(PickupVariant.PICKUP_TAROTCARD, info.ID) or "???"),
			UnlockFunc = function(self)
				if FiendFolio.IsCardLocked(info.ID) then
					self.Desc = "Locked!"
					return self
				end
			end,
			Hide = info.Hide,
			ModName = "Fiend Folio",
		})
	end

	--Runes
	local EncycloRunes = {
		{ID = FiendFolio.ITEM.CARD.RUNE_ANSUS, Hide = true},
	}

	for _, info in pairs(EncycloRunes) do
		Encyclopedia.AddRune({
			Class = "Fiend Folio",
			ID = info.ID,
			WikiDesc = Encyclopedia.EIDtoWiki(__eidCardDescriptions[info.ID] or GetEidDesc(PickupVariant.PICKUP_TAROTCARD, info.ID) or "???"),
			--UnlockFunc = EncycloItems[id].Unlock,
			Hide = info.Hide,
			ModName = "Fiend Folio",
		})
	end

	--Soulstones
	local EncycloSouls = {
		{ID = FiendFolio.ITEM.CARD.SOUL_OF_FIEND},
		{ID = FiendFolio.ITEM.CARD.SOUL_OF_GOLEM},
		{ID = FiendFolio.ITEM.CARD.SOUL_OF_RANDOM},
	}

	for _, info in pairs(EncycloSouls) do
		Encyclopedia.AddSoul({
			Class = "Fiend Folio",
			ID = info.ID,
			WikiDesc = Encyclopedia.EIDtoWiki(__eidCardDescriptions[info.ID] or GetEidDesc(PickupVariant.PICKUP_TAROTCARD, info.ID) or "???"),
			UnlockFunc = function(self)
				if FiendFolio.IsCardLocked(info.ID) then
					self.Desc = "Locked!"
					return self
				end
			end,
			Hide = info.Hide,
			ModName = "Fiend Folio",
		})
	end

	--Pills
	local EncycloPills = {
		{ID = FiendFolio.ITEM.PILL.FF_UNIDENTIFIED, Hide = true},
		{ID = FiendFolio.ITEM.PILL.CYANIDE},
		{ID = FiendFolio.ITEM.PILL.MELATONIN},
		{ID = FiendFolio.ITEM.PILL.HOLY_SHIT},
		{ID = FiendFolio.ITEM.PILL.HAEMORRHOIDS},
		{ID = FiendFolio.ITEM.PILL.FISH_OIL},
		{ID = FiendFolio.ITEM.PILL.LEMON_JUICE},
		{ID = FiendFolio.ITEM.PILL.EPIDERMOLYSIS},
		{ID = FiendFolio.ITEM.PILL.CLAIRVOYANCE},
		{ID = FiendFolio.ITEM.PILL.SPIDER_UNBOXING},
	}

	for _, info in pairs(EncycloPills) do
		Encyclopedia.AddPill({
			Class = "Fiend Folio",
			ID = info.ID,
			WikiDesc = Encyclopedia.EIDtoWiki(__eidPillDescriptions[info.ID] or GetEidDesc(PickupVariant.PICKUP_PILL, info.ID+1) or "???"),
			--UnlockFunc = EncycloItems[id].Unlock,
			Hide = info.Hide,
			ModName = "Fiend Folio",
		})
	end
end