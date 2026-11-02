local mod = FiendFolio
local game = Game()
local rng = RNG()
local sfx = SFXManager()

FiendFolio.LoadScripts({
    "ffscripts.guwah.enemies.blasted",
    "ffscripts.guwah.enemies.zealot",
    "ffscripts.guwah.enemies.skulltist",
    "ffscripts.guwah.enemies.ringleader",
    "ffscripts.guwah.enemies.cherub",
    "ffscripts.guwah.enemies.dungeonmaster",
    "ffscripts.guwah.enemies.coconut",
    "ffscripts.guwah.enemies.ashtray",
    "ffscripts.guwah.enemies.clogmo",
    "ffscripts.guwah.enemies.mayfly",
    "ffscripts.guwah.enemies.fishy",
    "ffscripts.guwah.enemies.catfish",
    "ffscripts.guwah.enemies.squid",
    "ffscripts.guwah.enemies.bub",
    "ffscripts.guwah.enemies.molly",
    "ffscripts.guwah.enemies.shirk",
    "ffscripts.guwah.enemies.roasty",
    "ffscripts.guwah.enemies.lurch",
    "ffscripts.guwah.enemies.jammed",
    "ffscripts.guwah.enemies.glorf",
    "ffscripts.guwah.enemies.rotdrink",
    "ffscripts.guwah.enemies.gutknight",
    "ffscripts.guwah.enemies.kukodemon",
    "ffscripts.guwah.enemies.mazerunner",
    "ffscripts.guwah.enemies.bunkter",
    "ffscripts.guwah.enemies.weeper",
    "ffscripts.guwah.enemies.tommy",
    "ffscripts.guwah.enemies.shockcollar",
    "ffscripts.guwah.enemies.cathy",
    "ffscripts.guwah.enemies.shotfly",
    "ffscripts.guwah.enemies.arcanecreep",
    "ffscripts.guwah.enemies.nihilist",
    "ffscripts.guwah.enemies.molarsystem",
    "ffscripts.guwah.enemies.puffer",
    "ffscripts.guwah.enemies.dolphin",
    "ffscripts.guwah.enemies.fleshsistern",
    "ffscripts.guwah.enemies.madhat",
    "ffscripts.guwah.enemies.grimoire",
    "ffscripts.guwah.enemies.resident",
    "ffscripts.guwah.enemies.ztewie",
    "ffscripts.guwah.enemies.droolie",
    "ffscripts.guwah.enemies.jokes",
    "ffscripts.guwah.enemies.sizzle",
    "ffscripts.guwah.enemies.glob",
    "ffscripts.guwah.enemies.marlin",
    "ffscripts.guwah.enemies.mightfly",
    "ffscripts.guwah.enemies.tricko",
    "ffscripts.guwah.enemies.dollop",
    "ffscripts.guwah.enemies.apega",
    "ffscripts.guwah.enemies.molargan",
    "ffscripts.guwah.enemies.steralis",
    "ffscripts.guwah.enemies.dogrock",
    "ffscripts.guwah.enemies.cherubskull",
    "ffscripts.guwah.enemies.mothman",
    "ffscripts.guwah.enemies.astroskull",
    "ffscripts.guwah.enemies.quitter",
    "ffscripts.guwah.enemies.rufus",
    "ffscripts.guwah.enemies.toothache",
    "ffscripts.guwah.enemies.retch",
    "ffscripts.guwah.enemies.observer",
    "ffscripts.guwah.enemies.aleya",
    "ffscripts.guwah.enemies.thumper",
    "ffscripts.guwah.enemies.chunky",
    "ffscripts.guwah.enemies.buttfly",
    "ffscripts.guwah.enemies.drumstick",
    "ffscripts.guwah.enemies.sponge",
    "ffscripts.guwah.enemies.hermit",
    "ffscripts.guwah.enemies.briar",
    "ffscripts.guwah.enemies.grazer",
    "ffscripts.guwah.enemies.plexus",
    "ffscripts.guwah.enemies.infectedmushroom",
    "ffscripts.guwah.enemies.cairn",
    "ffscripts.guwah.enemies.blare",
    "ffscripts.guwah.enemies.potluck",
    "ffscripts.guwah.enemies.casualty",
    "ffscripts.guwah.enemies.shrunkenhead",
    "ffscripts.guwah.enemies.dim",
    "ffscripts.guwah.enemies.trailblazer",
    "ffscripts.guwah.enemies.gamper",
    "ffscripts.guwah.enemies.wailer",
    "ffscripts.guwah.enemies.speleo",
    "ffscripts.guwah.enemies.craig",
    "ffscripts.guwah.enemies.idpd",
    "ffscripts.guwah.enemies.chili",
    "ffscripts.guwah.enemies.goldenflybomb",
    "ffscripts.guwah.enemies.nailhead",
    "ffscripts.guwah.enemies.vacuole",
    "ffscripts.guwah.enemies.bamboocutter",
    "ffscripts.guwah.enemies.contestant",
    "ffscripts.guwah.enemies.skitterskull",
    "ffscripts.guwah.enemies.wasty",
    "ffscripts.guwah.enemies.temptress",
    "ffscripts.guwah.enemies.dumptruck",
    "ffscripts.guwah.enemies.pillarjohn",
    "ffscripts.guwah.enemies.zephyr",
    "ffscripts.guwah.enemies.flagpole",
    "ffscripts.guwah.enemies.firefly",
    "ffscripts.guwah.enemies.conjoinedcreep",
    "ffscripts.guwah.enemies.clod",
    "ffscripts.guwah.enemies.antifiend",
    "ffscripts.guwah.enemies.ghastly",
    "ffscripts.guwah.enemies.bellboy",
    "ffscripts.guwah.enemies.mirage",
    "ffscripts.guwah.enemies.imperialist",
    "ffscripts.guwah.enemies.buddybag",
    "ffscripts.guwah.enemies.hyperbole",
    "ffscripts.guwah.enemies.premonition",
    "ffscripts.guwah.enemies.thresher",
    "ffscripts.guwah.enemies.partyball",
    "ffscripts.guwah.enemies.suave",
    "ffscripts.guwah.enemies.cheeky",
    "ffscripts.guwah.enemies.techneedle",
    "ffscripts.guwah.enemies.kriegsheld",
    "ffscripts.guwah.enemies.redbony",
    "ffscripts.guwah.enemies.skullshroom",
    "ffscripts.guwah.enemies.carvecreep",
    "ffscripts.guwah.enemies.earsplitter",
    "ffscripts.guwah.enemies.drownedspitty",
    "ffscripts.guwah.enemies.rosieposie",
    "ffscripts.guwah.enemies.blubbie",
    "ffscripts.guwah.enemies.atomicgaper",
    "ffscripts.guwah.enemies.soothsayer",
    "ffscripts.guwah.enemies.falseidol",

    "ffscripts.guwah.bosses.basco",
    "ffscripts.guwah.bosses.junkstrap",
    "ffscripts.guwah.bosses.rainbowragman",

    "ffscripts.guwah.grids.spidernest",
    "ffscripts.guwah.grids.evilpoop",
    "ffscripts.guwah.grids.flippedbucket",
    "ffscripts.guwah.grids.aleyafireplace",
    "ffscripts.guwah.grids.trashbag",
    "ffscripts.guwah.grids.totems",

    "ffscripts.guwah.items.excelsior",
    "ffscripts.guwah.items.eternald10",
    "ffscripts.guwah.items.shredder",
    "ffscripts.guwah.items.errorscrazyslots",

    "ffscripts.guwah.trinkets.hector",

    "ffscripts.guwah.consumables.brickseperator",

    "ffscripts.guwah.utilities.wallmovement",

    "ffscripts.players.craig",
})

mod.GuwahAIReload = false
mod.GatheringProjectiles = false
mod.MusicTampered = false
mod.TargetRoomColor = nil
mod.CurrentRoomColor = nil
mod.DogrockIntensity = 0
mod.TearFountains = {}
mod.FireShockwaves = {}
mod.RufusRings = {}
mod.ClogmoGroups = {}
mod.ShirkSpots = {}
mod.OccupiedGrids = {}
mod.JamDeletions = {}
mod.SkyCrackins = {}
mod.ZtewieGroups = {}
mod.ShrunkenHeadGroups = {}
mod.GatheredProjectiles = {}
mod.GridPaths = {}
mod.NervieData = {}
mod.ActiveNervieGroups = {}
mod.FartWaves = {}
mod.GoldenFlyBombSpawnpoints = {}
mod.LittleJohnData = {}
mod.ActiveLittleJohnGroups = {}

function mod:ClearGuwahTables()
    mod.GatheringProjectiles = false
    mod.MusicTampered = false
    mod.TargetRoomColor = nil
    mod.CurrentRoomColor = nil
    mod.DogrockIntensity = 0
    mod.TearFountains = {}
    mod.FireShockwaves = {}
    mod.RufusRings = {}
    mod.ClogmoGroups = {}
    mod.ShirkSpots = {}
    mod.OccupiedGrids = {}
    mod.JamDeletions = {}
    mod.SkyCrackins = {}
    mod.ZtewieGroups = {}
    mod.ShrunkenHeadGroups = {}
    mod.GatheredProjectiles = {}
    mod.GridPaths = {}
    mod.NervieData = {}
    mod.ActiveNervieGroups = {}
    mod.FartWaves = {}
    mod.GoldenFlyBombSpawnpoints = {}
    mod.LittleJohnData = {}
    mod.ActiveLittleJohnGroups = {}
end

mod.GuwahEnemies = {
    [EntityType.ENTITY_HORF] = {
        [mod.FF.Trihorf.Var] = {
            Update = mod.TrihorfAI,
        },
    },
    [EntityType.ENTITY_FLY] = {
        [mod.FF.ThumbsUpFly.Var] = {
            Coll = mod.ThumbsUpFlyColl,
            Death = mod.ThumbsUpFlyDeath,
        },
    },
    [EntityType.ENTITY_CLOTTY] = {
        [mod.FF.Drumstick.Var] = {
            Update = mod.DrumstickAI,
            Hurt = mod.DrumstickHurt,
        },
        [mod.FF.HolyDrumstick.Var] = {
            Update = mod.DrumstickAI,
            Hurt = mod.DrumstickHurt,
        },
    },
    [EntityType.ENTITY_MAGGOT] = {
        [mod.FF.Retch.Var] = {
            Update = mod.RetchAI,
        },
    },
    [EntityType.ENTITY_BOOMFLY] = {
        [mod.FF.Droolie.Var] = {
            PreUpdate = mod.DroolieAI,
            Update = mod.DroolieAITwo,
        },
        [mod.FF.Mightfly.Var] = {
            Update = mod.MightflyAI
        },
        [mod.FF.GoldenMightfly.Var] = {
            Update = mod.MightflyAI
        },
        [mod.FF.Posie.Var] = {
            Update = mod.PosieAI,
            PostColl = mod.PosieColl,
        }
    },
    [EntityType.ENTITY_HOST] = {
        [mod.FF.Hostlet.Var] = {
            [mod.FF.Hostlet.Sub] = {
                Update = mod.HostletAI,
            },
        },
        [mod.FF.RedHostlet.Var] = {
            [mod.FF.RedHostlet.Sub] = {
                Update = mod.HostletAI,
            },
        },
    },
    [EntityType.ENTITY_HOPPER] = {
        [mod.FF.Imperialist.Var] = {
            [mod.FF.Imperialist.Sub] = {
                Update = mod.ImperialistAI,
            },
        },
    },
    [EntityType.ENTITY_SPITTY] = {
        [mod.FF.DrownedSpitty.Var] = {
            Update = mod.DrownedSpittyAI,
        },
    },
    [EntityType.ENTITY_FIREPLACE] = {
        [mod.FF.AleyaFirePlace.Var] = {
            [mod.FF.AleyaFirePlace.Sub] = {
                Init = mod.AleyaFirePlaceInit,
                --PreUpdate = mod.AleyaFirePlaceAI,
                Hurt = mod.AleyaFirePlaceHurt,
            },
        },
    },
    [EntityType.ENTITY_SUCKER] = {
        [mod.FF.TaintedSpit.Var] = {
            [mod.FF.TaintedSpit.Sub] = {
                Update = mod.TaintedSpitAI,
                Remove = mod.TaintedSpitKill,
            },
        },
        [mod.FF.Mayfly.Var] = {
            Update = mod.MayflyAI,
        },
        [mod.FF.Hyperbole.Var] = {
            Update = mod.HyperboleAI,
        },
        [mod.FF.Partyball.Var] = {
            PreUpdate = mod.PartyballPreUpdate,
            Update = mod.PartyballAI,
            Hurt = mod.PartyballHurt,
        },
    },
    [EntityType.ENTITY_KNIGHT] = {
        [mod.FF.GutKnight.Var] = {
            Update = mod.GutKnightAI,
        },
    },
    [EntityType.ENTITY_POKY] = {
        [mod.FF.ClogmoPipe.Var] = {
            PreUpdate = mod.ClogmoPipeAI,
            Hurt = mod.ClogmoGridHurt,
            Remove = mod.ClogmoGridRemove,
        },
        [mod.FF.ClogmoTunnelHori.Var] = {
            PreUpdate = mod.ClogmoTunnelAI,
            Hurt = mod.ClogmoGridHurt,
            Remove = mod.ClogmoGridRemove,
        },
        [mod.FF.ClogmoTunnelVerti.Var] = {
            PreUpdate = mod.ClogmoTunnelAI,
            Hurt = mod.ClogmoGridHurt,
            Remove = mod.ClogmoGridRemove,
        },
    },
    [EntityType.ENTITY_SPIDER] = {
        [mod.FF.GoldenSpider.Var] = {
            Update = mod.GoldenSpiderAI,
        },
    },
    [mod.FFID.Blor] = {
        [mod.FF.EarSplitter.Var] = {
            Update = mod.EarSplitterAI,
            Coll = mod.EarSplitterColl,
        },
        [mod.FF.EarSplitterBlade.Var] = {
            Update = mod.EarSplitterBladeAI,
            Coll = mod.EarSplitterColl,
        },
    },
    [mod.FFID.Tech] = {
        [mod.FF.BlastedMine.Var] = {
            Update = mod.BlastedMineAI,
            Hurt = mod.BlastedMineHurt,
        },
        [mod.FF.ShirkSpot.Var] = {
            Update = mod.ShirkSpotAI,
        },
        [mod.FF.DungeonLocker.Var] = {
            Update = mod.DungeonLocking,
        },
        [mod.FF.LurchGutTip.Var] = {
            Update = mod.LurchGutTipAI,
            Coll = mod.LurchGutTipColl,
        },
        [mod.FF.MolarOrbital.Var] = {
            Update = mod.MolarOrbitalAI,
            Death = mod.MolarOrbitalDeath,
        },
        [mod.FF.KeyFiend.Var] = {
            Update = mod.KeyFiendAI,
            Hurt = mod.KeyFiendHurt,
            Coll = mod.KeyFiendColl,
        },
        [mod.FF.ZtewieStinger.Var] = {
            Update = mod.ZtewieStingerAI,
            Coll = mod.ZtewieStingerColl,
        },
        [mod.FF.CherubskullHand.Var] = {
            Update = mod.CherubskullHandAI,
            Hurt = mod.IgnoreDamage,
        },
        [mod.FF.LilJunkie.Var] = {
            Update = mod.LilJunkieAI,
            Hurt = mod.IgnoreDamage,
            Death = mod.LilJunkieDeath,
        },
        [mod.FF.ScrewProjectile.Var] = {
            Update = mod.ScrewProjectile,
            Hurt = mod.IgnoreDamage,
            Coll = mod.ScrewProjectileCollision,
            Death = mod.ScrewProjectileDeath,
        },
        [mod.FF.DoorCloser.Var] = {
            Init = mod.DoorCloserInit,
            Update = mod.DoorCloserUpdate,
            Hurt = mod.IgnoreDamage,
        },
    },
    [mod.FFID.Erfly] = {
        [mod.FF.Resident.Var] = {
            Update = mod.ResidentAI,
            Hurt = mod.ResidentHurt,
        },
        [mod.FF.ResidentBody.Var] = {
            Update = mod.ResidentBodyAI,
        },
        [mod.FF.Glob.Var] = {
            Update = mod.GlobAI,
            Hurt = mod.GlobHurt,
        },
        [mod.FF.Sizzle.Var] = {
            Update = mod.SizzleAI,
            Hurt = mod.IgnoreFireDamage,
        },
    },
    [EntityType.ENTITY_NEST] = {
        [mod.FF.Jammed.Var] = {
            Update = mod.JammedAI,
        },
        [mod.FF.Molargan.Var] = {
            Update = mod.MolarganAI,
        },
    },
    [EntityType.ENTITY_BABY_LONG_LEGS] = {
        [mod.FF.Tommy.Var] = {
            Update = mod.TommyAI,
        },
    },
    [EntityType.ENTITY_CRAZY_LONG_LEGS] = {
        [mod.FF.Benny.Var] = {
            PreUpdate = mod.BennyAI,
            Hurt = mod.BennyHurt,
        },
    },
    [EntityType.ENTITY_DEATHS_HEAD] = {
        [mod.FF.Cherubskull.Var] = {
            Init = mod.CherubskullInit,
            Update = mod.CherubskullAI,
            Render = mod.CherubskullRender,
        },
        [mod.FF.Astroskull.Var] = {
            Update = mod.AstroskullAI,
            Render = mod.AstroskullRender,
        },
    },
    [EntityType.ENTITY_BONY] = {
        [mod.FF.RedBony.Var] = {
            Update = mod.RedBonyAI,
        },
    },
    [EntityType.ENTITY_WALL_CREEP] = {
        [mod.FF.ArcaneCreep.Var] = {
            Update = mod.ArcaneCreepAI,
        },
        [mod.FF.ConjoinedCreep.Var] = {
            Update = mod.ConjoinedCreepAI,
            Hurt = mod.ConjoinedCreepHurt,
        },
        [mod.FF.CarveCreep.Var] = {
            Update = mod.CarveCreepAI,
        },
    },
    [EntityType.ENTITY_CONJOINED_SPITTY] = {
        [mod.FF.DrownedConjoinedSpitty.Var] = {
            Update = mod.DrownedSpittyAI,
        },
    },
    [EntityType.ENTITY_BLACK_GLOBIN_HEAD] = {
        [mod.FF.SlothsHead.Var] = {
            Update = mod.SlothsHeadAI,
        },
    },
    [EntityType.ENTITY_DUKIE] = {
        [mod.FF.Blubbie.Var] = {
            Update = mod.BlubbieAI,
        },
    },
    [EntityType.ENTITY_MUSHROOM] = {
        [mod.FF.Skullshroom.Var] = {
            Update = mod.SkullshroomAI,
        },
    },
    [EntityType.ENTITY_LEPER] = {
        [mod.FF.Molly.Var] = {
            Init = mod.MollyInit,
        },
    },
    [mod.FFID.GuwahJoke] = {
        [mod.FF.IDPDGrunt.Var] = {
            Update = mod.IDPDGruntAI,
            Hurt = mod.IDPDHurt,
            Coll = mod.IDPDColl,
            Death = mod.IDPDDeath,
        },
        [mod.FF.IDPDInspector.Var] = {
            Update = mod.IDPDInspectorAI,
            Hurt = mod.IDPDHurt,
            Coll = mod.IDPDColl,
            Death = mod.IDPDDeath,
        },
        [mod.FF.IDPDShielder.Var] = {
            Update = mod.IDPDShielderAI,
            Hurt = mod.IDPDHurt,
            Coll = mod.IDPDColl,
            Death = mod.IDPDDeath,
        },
        [mod.FF.IDPDGrenade.Var] = {
            Update = mod.IDPDGrenade,
        },
        [mod.FF.TheTerribleOni.Var] = {
            Update = mod.TheTerribleOni,
        },
        [mod.FF.HomonculusLoxodontus.Var] = {
            Update = mod.HomonculusLoxodontusAI,
        },
    },
    [mod.FFID.Guwah] = {
        [mod.FF.Zealot.Var] = {
            Update = mod.ZealotAI,
        },
        [mod.FF.Skulltist.Var] = {
            Update = mod.SkulltistAI,
        },
        [mod.FF.RingLeader.Var] = {
            Update = mod.RingLeaderAI,
        },
        [mod.FF.Cherub.Var] = {
            Update = mod.CherubAI,
        },
        [mod.FF.Glorf.Var] = {
            Update = mod.GlorfAI,
            Hurt = mod.GlorfHurt,
        },
        [mod.FF.Thumper.Var] = {
            [0] = {
                Update = mod.ThumperAI,
            },
            [mod.FF.Nubert.Sub] = {
                Update = mod.NubertAI,
            },
        },
        [mod.FF.Coconut.Var] = {
            Update = mod.CoconutAI,
        },
        [mod.FF.Ashtray.Var] = {
            Update = mod.AshtrayAI,
        },
        [mod.FF.Clogmo.Var] = {
            Update = mod.ClogmoAI,
            Remove = mod.ClogmoRemove,
        },
        [mod.FF.Fishy.Var] = {
            [0] = {
                Update = mod.FishyAI,
            },
            [mod.FF.Necrotic.Sub] = {
                Update = mod.NecroticAI,
            },
            [mod.FF.Fish.Sub] = {
                Update = mod.FishAI,
            },
        },
        [mod.FF.Catfish.Var] = {
            Update = mod.CatfishAI,
            Remove = mod.ClearOccupiedIndex,
        },
        [mod.FF.Squid.Var] = {
            Update = mod.SquidAI,
        },
        [mod.FF.Bub.Var] = {
            Update = mod.BubAI,
        },
        [mod.FF.Shirk.Var] = {
            Update = mod.ShirkAI,
            Hurt = mod.ShirkHurt,
            Remove = mod.ShirkRemove,
        },
        [mod.FF.Roasty.Var] = {
            Update = mod.RoastyAI,
            Render = mod.RoastyRender,
            Hurt = mod.IgnoreFireDamage,
            Remove = mod.ClearOccupiedIndex,
        },
        [mod.FF.Lurch.Var] = {
            Update = mod.LurchAI,
        },
        [mod.FF.Rotdrink.Var] = {
            [0] = {
                Update = mod.RotdrinkAI,
            },
            [mod.FF.Rotskull.Sub] = {
                Update = mod.RotskullAI,
            },
        },
        [mod.FF.Kukodemon.Var] = {
            Update = mod.KukodemonAI,
        },
        [mod.FF.MazeRunner.Var] = {
            Update = mod.MazeRunnerAI,
        },
        [mod.FF.Bunkter.Var] = {
            Update = mod.BunkterAI,
            Hurt = mod.BunkterHurt,
        },
        [mod.FF.Weeper.Var] = {
            Update = mod.WeeperAI,
        },
        [mod.FF.ShockCollar.Var] = {
            Update = mod.ShockCollarAI,
        },
        [mod.FF.Cathy.Var] = {
            Update = mod.CathyAI,
        },
        [mod.FF.ShotFly.Var] = {
            Update = mod.ShotFlyAI,
            Hurt = mod.ShotFlyHurt,
        },
        [mod.FF.Shoter.Var] = {
            Update = mod.ShotFlyAI,
            Hurt = mod.ShotFlyHurt,
        },
        [mod.FF.Nihilist.Var] = {
            Update = mod.NihilistAI,
        },
        [mod.FF.MolarSystem.Var] = {
            Update = mod.MolarSystemAI,
            Hurt = mod.MolarSystemHurt,
        },
        [mod.FF.Puffer.Var] = {
            Update = mod.PufferAI,
        },
        [mod.FF.Dolphin.Var] = {
            Update = mod.DolphinAI,
            Remove = mod.ClearOccupiedIndex,
        },
        [mod.FF.Madhat.Var] = {
            Update = mod.MadhatAI,
        },
        [mod.FF.Grimoire.Var] = {
            Update = mod.GrimoireAI,
            Hurt = mod.IgnoreFireDamage,
            Death = mod.GrimoireDeath,
        },
        [mod.FF.Ztewie.Var] = {
            Update = mod.ZtewieAI,
            Remove = mod.ZtewieRemove,
        },
        [mod.FF.Marlin.Var] = {
            Update = mod.MarlinAI,
            Coll = mod.MarlinColl,
        },
        [mod.FF.Tricko.Var] = {
            Update = mod.TrickoAI,
            Hurt = mod.TrickoHurt,
        },
        [mod.FF.Dollop.Var] = {
            Update = mod.DollopAI,
        },
        [mod.FF.Apega.Var] = {
            Update = mod.ApegaAI,
            Hurt = mod.ApegaHurt,
            Death = mod.ApegaDeath,
        },
        [mod.FF.Steralis.Var] = {
            Update = mod.SteralisAI,
        },
        [mod.FF.Dogrock.Var] = {
            Update = mod.DogrockAI,
            Render = mod.DogrockRender,
        },
        [mod.FF.Mothman.Var] = {
            Update = mod.MothmanAI,
        },
        [mod.FF.Quitter.Var] = {
            Update = mod.QuitterAI,
            Coll = mod.QuitterColl,
            Hurt = mod.QuitterHurt,
        },
        [mod.FF.Rufus.Var] = {
            Update = mod.RufusAI,
            Hurt = mod.RufusHurt,
        },
        [mod.FF.Toothache.Var] = {
            Update = mod.ToothacheAI,
        },
        [mod.FF.Aleya.Var] = {
            Update = mod.AleyaAI,
            Coll = mod.AleyaColl,
            Hurt = mod.IgnoreFireDamage,
            Remove = mod.AleyaRemove,
        },
        [mod.FF.Chunky.Var] = {
            Update = mod.ChunkyAI,
            Hurt = mod.ChunkyHurt,
        },
        [mod.FF.ButtFly.Var] = {
            Update = mod.ButtFlyAI,
        },
        [mod.FF.Sponge.Var] = {
            Update = mod.SpongeAI,
            Coll = mod.SpongeColl,
            Hurt = mod.SpongeHurt,
            Remove = mod.SpongeRemove,
        },
        [mod.FF.Hermit.Var] = {
            Update = mod.HermitAI,
            Render = mod.HermitRender,
            Hurt = mod.HermitHurt,
        },
        [mod.FF.DungeonMaster.Var] = {
            Update = mod.DungeonMasterAI,
            Hurt = mod.DungeonMasterHurt,
        },
        [mod.FF.Observer.Var] = {
            Update = mod.ObserverAI,
            Hurt = mod.ObserverHurt,
            Remove = mod.ObserverRemove,
        },
    },
    [mod.FFID.Guwah2] = {
        [mod.FF.Briar.Var] = {
            Update = mod.BriarAI,
        },
        [mod.FF.Grazer.Var] = {
            Update = mod.GrazerAI,
        },
        [mod.FF.Plexus.Var] = {
            Update = mod.PlexusAI,
        },
        [mod.FF.Nervie.Var] = {
            Update = mod.NervieAI,
            Coll = mod.NervieColl,
            Hurt = mod.IgnoreDamage,
        },
        [mod.FF.NerviePoint.Var] = {
            Update = mod.NerviePointSetup,
            Hurt = mod.IgnoreDamage,
        },
        [mod.FF.InfectedMushroom.Var] = {
            Update = mod.InfectedMushroomAI,
        },
        [mod.FF.Coalby.Var] = {
            Update = mod.CairnAI,
            Coll = mod.DealFireCollisionDamage,
            Hurt = mod.IgnoreFireDamage,
        },
        [mod.FF.Coupile.Var] = {
            Update = mod.CairnAI,
            Coll = mod.DealFireCollisionDamage,
            Hurt = mod.IgnoreFireDamage,
        },
        [mod.FF.Cairn.Var] = {
            Update = mod.CairnAI,
            Coll = mod.DealFireCollisionDamage,
            Hurt = mod.IgnoreFireDamage,
        },
        [mod.FF.CoalscoopCoal.Var] = {
            Update = mod.CoalscoopCoalUpdate,
            Render = mod.CoalscoopCoalRender,
            Coll = mod.DealFireCollisionDamage,
            Hurt = mod.CoalscoopCoalHurt,
        },
        [mod.FF.Blare.Var] = {
            Update = mod.BlareAI,
        },
        [mod.FF.Potluck.Var] = {
            Update = mod.PotluckAI,
            Remove = mod.ClearOccupiedIndex,
        },
        [mod.FF.Casualty.Var] = {
            Update = mod.CasualtyAI,
        },
        [mod.FF.ShrunkenHead.Var] = {
            Update = mod.ShrunkenHeadAI,
        },
        [mod.FF.Premonition.Var] = {
            Update = mod.PremonitionAI,
        },
        [mod.FF.Apocalypse.Var] = {
            Update = mod.ApocalypseAI,
            Render = mod.ApocalypseRender,
        },
        [mod.FF.Dim.Var] = {
            Update = mod.DimAI,
        },
        [mod.FF.DimGhost.Var] = {
            Update = mod.DimGhostAI,
            Hurt = mod.IgnoreDamage,
        },
        [mod.FF.Trailblazer.Var] = {
            Update = mod.TrailblazerAI,
            Render = mod.TrailblazerRender,
            Coll = mod.TrailblazerColl,
            Hurt = mod.TrailblazerHurt,
        },
        [mod.FF.Gamper.Var] = {
            Update = mod.GamperAI,
            Hurt = mod.IgnoreDamage,
        },
        [mod.FF.GamperGuts.Var] = {
            Update = mod.GamperGutsAI,
        },
        [mod.FF.Wailer.Var] = {
            Init = mod.WailerInit,
            Update = mod.WailerAI,
            Render = mod.WailerRender,
            Hurt = mod.IgnoreDamage,
        },
        [mod.FF.Speleo.Var] = {
            Update = mod.SpeleoAI,
            Hurt = mod.IgnoreCrushDamage,
        },
        [mod.FF.Craig.Var] = {
            Update = mod.CraigAI,
            Hurt = mod.CraigHurt,
        },
        [mod.FF.TaintedCraig.Var] = {
            Update = mod.TaintedCraigAI,
            Hurt = mod.CraigHurt,
            Remove = mod.TaintedCraigRemove,
        },
        [mod.FF.Chili.Var] = {
            Update = mod.ChiliAI,
            Hurt = mod.IgnoreFireDamage,
        },
        [mod.FF.Litling.Var] = {
            Update = mod.LitlingAI,
            Render = mod.LitlingRender,
            Coll = mod.DieOnPlayerCollision,
            Hurt = mod.IgnoreFireDamage,
        },
        [mod.FF.Nailhead.Var] = {
            Update = mod.NailheadAI,
        },
        [mod.FF.Vacuole.Var] = {
            Update = mod.VacuoleAI,
            Remove = mod.VacuoleRemove,
        },
        [mod.FF.FrayedNerve.Var] = {
            Update = mod.FrayedNerveAI,
            Hurt = mod.FrayedNerveHurt,
        },
        [mod.FF.Contestant.Var] = {
            Update = mod.ContestantAI,
        },
        [mod.FF.SkitterSkull.Var] = {
            Update = mod.SkitterSkullAI,
        },
        [mod.FF.Wasty.Var] = {
            Update = mod.WastyAI,
        },
        [mod.FF.Temptress.Var] = {
            Update = mod.TemptressAI,
            Render = mod.TemptressRender,
        },
        [mod.FF.Dumptruck.Var] = {
            Update = mod.DumptruckAI,
            Hurt = mod.DumptruckHurt,
        },
        [mod.FF.PillarJohn.Var] = {
            Update = mod.PillarJohnAI,
            Hurt = mod.IgnoreDamage,
        },
        [mod.FF.LittleJohn.Var] = {
            Update = mod.LittleJohnAI,
            Hurt = mod.LittleJohnHurt,
        },
        [mod.FF.PillarJohnQuake.Var] = {
            Update = mod.PillarJohnQuake,
            Hurt = mod.IgnoreDamage,
        },
        [mod.FF.LittleJohnPoint.Var] = {
            Update = mod.LittleJohnPointSetup,
            Hurt = mod.IgnoreDamage,
        },
        [mod.FF.Zephyr.Var] = {
            Update = mod.ZephyrAI,
        },
        [mod.FF.FlagpoleHead.Var] = {
            Update = mod.FlagpoleHeadAI,
            Death = mod.FlagpoleDeath,
        },
        [mod.FF.FlagpoleBody.Var] = {
            Update = mod.FlagpoleBodyAI,
            Death = mod.FlagpoleDeath,
        },
        [mod.FF.FireFly.Var] = {
            Update = mod.FireFlyAI,
            Coll = mod.FireFlyColl,
            Hurt = mod.IgnoreFireDamage,
        },
        [mod.FF.Clod.Var] = {
            Update = mod.ClodAI,
            Coll = mod.ClodColl,
        },
        [mod.FF.AntiFiend.Var] = {
            Update = mod.AntiFiendAI,
            Hurt = mod.IgnoreFireDamage,
        },
        [mod.FF.Ghastly.Var] = {
            Update = mod.GhastlyAI,
            Render = mod.GhastlyRender,
        },
        [mod.FF.BellBoy.Var] = {
            Update = mod.BellBoyAI,
            Hurt = mod.BellBoyHurt,
        },
        [mod.FF.Mirage.Var] = {
            Init = mod.MirageInit,
            Update = mod.MirageAI,
            Render = mod.MirageRender,
            Hurt = mod.MirageHurt,
            Coll = mod.MirageColl,
            Death = mod.MirageDeath,
        },
        [mod.FF.Buddybag.Var] = {
            Update = mod.BuddybagAI,
        },
        [mod.FF.Suave.Var] = {
            Update = mod.SuaveAI,
        },
        [mod.FF.Urbane.Var] = {
            Update = mod.UrbaneAI,
            Hurt = mod.IgnoreDamage,
        },
        [mod.FF.Cheeky.Var] = {
            Update = mod.CheekyAI,
        },
        [mod.FF.Rashy.Var] = {
            Update = mod.CheekyAI,
            Hurt = mod.IgnoreRedPoopDamage,
        },
        [mod.FF.Kriegsheld.Var] = {
            Update = mod.KriegsheldAI,
        },
        [mod.FF.Rosie.Var] = {
            Update = mod.RosieAI,
        },
        [mod.FF.AtomicGaper.Var] = {
            Update = mod.AtomicGaperAI,
            Hurt = mod.AtomicGaperHurt,
        },
        [mod.FF.Soothsayer.Var] = {
            Update = mod.SoothsayerAI,
            Hurt = mod.SoothsayerHurt,
            Regen = mod.SoothsayerRegen,
        },
        [mod.FF.FalseIdol.Var] = {
            Update = mod.FalseIdolAI,
        },
    },
    [EntityType.ENTITY_FLY_BOMB] = {
        [mod.FF.GoldenFlyBomb.Var] = {
            Update = mod.GoldenFlyBombAI,
        },
    },
    [EntityType.ENTITY_MOLE] = {
        [mod.FF.Blasted.Var] = {
            Update = mod.BlastedAI,
            Coll = mod.BlastedColl,
            Hurt = mod.BlastedHurt,
        },
    },
    [EntityType.ENTITY_WHIPPER] = {
        [mod.FF.BambooCutter.Var] = {
            Update = mod.BambooCutterAI,
        },
        [mod.FF.Thresher.Var] = {
            Update = mod.ThresherAI,
        },
    },
    [EntityType.ENTITY_EVIS] = {
        [mod.FF.LurchGuts.Var] = {
            Update = mod.LurchGutsAI,
        },
    },
    [EntityType.ENTITY_FLESH_MAIDEN] = {
        [mod.FF.FleshSistern.Var] = {
            PreUpdate = mod.FleshSisternAI,
        },
    },
    [EntityType.ENTITY_NEEDLE] = {
        [mod.FF.Techneedle.Var] = {
            Update = mod.TechneedleAI,
        },
    },
    [mod.FF.Cheekadee.ID] = {
        [mod.FF.Cheekadee.Var] = {
            Update = mod.CheekyAI,
        },
    },
}

mod:AddCallback(ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, function(type, var, sub, index, seed)
    mod:ClearGuwahTables()
end)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
    mod:ClearGuwahTables()
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local room = game:GetRoom()
    for i = 1, game:GetNumPlayers() do
        local player = Isaac.GetPlayer(i - 1)
        local data = mod:GetEntityData(player)
        data.SpongeAngle = 0
        if data.BrickSeperatorBuff then
            data.BrickSeperatorBuff = false
            player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG | CacheFlag.CACHE_TEARCOLOR)
            player:EvaluateItems()
        end
    end
    if mod.roomBackdrop == 10 or mod.GetEntityCount(150,1000,10) > 0 then

    elseif room:GetBackdropType() == BackdropType.CORPSE or room:GetBackdropType() == BackdropType.CORPSE2 then --Fix bloody corpse rooms
        if room:HasWater() then
			game:ShowHallucination(0, BackdropType.CORPSE3)
            StageAPI.ChangeGrids(mod.BloodyCorpseGrid)
			sfx:Stop(SoundEffect.SOUND_DEATH_CARD)
		end
    elseif room:GetBackdropType() == BackdropType.CORPSE3 then --Fix bloodless corpse rooms
        if not room:HasWater() then
            game:ShowHallucination(0, BackdropType.CORPSE)
            StageAPI.ChangeGrids(mod.DryCorpseGrid)
			sfx:Stop(SoundEffect.SOUND_DEATH_CARD)
        end
    end

    if mod.ModeEnabled == 4 and not room:IsClear() then
        rng:SetSeed(room:GetDecorationSeed() + 1, 0)
        if rng:RandomFloat() <= 0.2 then
            for i = 1, 2 do
                local spawnpos = mod:FindSafeSpawnSpot(Isaac.GetPlayer().Position, 400, 999, true)
                Isaac.Spawn(mod.FF.IDPDPortal.ID, mod.FF.IDPDPortal.Var, mod.FF.IDPDPortal.Sub, spawnpos, Vector.Zero, nil)
            end
        end
    end

    for _, wisp in pairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, mod.ITEM.COLLECTIBLE.FLIP_PHONE)) do
        wisp:Remove()
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local room = game:GetRoom()
    --print(room:GetGridWidth().." "..room:GetGridHeight().." "..room:GetGridSize())
    for _, shower in pairs(mod.TearFountains) do
        mod:TearFountainUpdate(shower)
    end
    for _, wave in pairs(mod.FireShockwaves) do
        mod:FireShockwaveUpdate(wave)
    end
    for _, pos in pairs(mod.JamDeletions) do
        mod:JamDeletion(pos)
    end
    for _, beams in pairs(mod.SkyCrackins) do
        mod:CrackingTheSky(beams)
    end
    for _, groups in pairs(mod.ZtewieGroups) do
        mod:ZtewieGroupControl(groups)
    end
    for _, groups in pairs(mod.ShrunkenHeadGroups) do
        mod:ShrunkenHeadGroupControl(groups)
    end
    for _, ring in pairs(mod.RufusRings) do
        mod:RufusRingUpdate(ring)
    end
    for _, wave in pairs(mod.FartWaves) do
        mod:FartWaveUpdate(wave)
    end
    for _, spawnpoint in pairs(mod.GoldenFlyBombSpawnpoints) do
        mod:GoldenFlyBombRespawning(spawnpoint)
    end
    for _, loopingSound in pairs(mod.LoopingSoundEntries) do
        mod:LoopingSoundEntryUpdate(loopingSound)
    end
    mod:DogrockLogic()
end)

FiendFolio.FilterFunny = false

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    if FiendFolio.FilterFunny and Options.Filter then
        Options.Filter = false
    end
end)

mod:AddPriorityCallback(ModCallbacks.MC_POST_ROOM_RENDER_ENTITIES or ModCallbacks.MC_POST_RENDER, CallbackPriority.LATE+1, function()
    local room = game:GetRoom()
    mod:EvilPoopRenderLogic(room)
end)


mod:AddCallback(ModCallbacks.MC_PRE_UPDATE, function()
    if mod:HandleFalseIdolTimestop() then
        return true
    end
end)

local function GetGuwahEnemyTable(npc) --Assumes they have a table for their type
    if mod.GuwahEnemies[npc.Type] then
        local variantTable = mod.GuwahEnemies[npc.Type][npc.Variant]
        if variantTable then
            if variantTable[npc.SubType] then
                return variantTable[npc.SubType]
            else
                return variantTable
            end
        end
    end
end

function mod:GuwahEnemyInit(npc)
    local table = GetGuwahEnemyTable(npc)
    if table and table.Init then
        table.Init(_, npc)
    end
end
function mod:GuwahEnemyUpdate(npc)
    local table = GetGuwahEnemyTable(npc)
    if table and table.Update then
        table.Update(_, npc, npc:GetSprite(), mod:GetEntityData(npc))
    end
end
function mod:GuwahEnemyPreUpdate(npc)
    local table = GetGuwahEnemyTable(npc)
    if table and table.PreUpdate then
        return table.PreUpdate(_, npc, npc:GetSprite(), mod:GetEntityData(npc))
    end
end
function mod:GuwahEnemyRender(npc, offset)
    local table = GetGuwahEnemyTable(npc)
    if table and table.Render then
        table.Render(_, npc, npc:GetSprite(), mod:GetEntityData(npc), game:IsPaused(), (game:GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT), offset)
    end
end
function mod:GuwahEnemyHurt(npc, damage, flags, source)
    local table = GetGuwahEnemyTable(npc)
    if table and table.Hurt then
        return table.Hurt(_, npc:ToNPC(), damage, flags, source)
    end
end
function mod:GuwahEnemyColl(npc, collider)
    local table = GetGuwahEnemyTable(npc)
    if table and table.Coll then
        return table.Coll(_, npc, collider)
    end
end
function mod:GuwahEnemyPostColl(npc, collider)
    local table = GetGuwahEnemyTable(npc)
    if table and table.PostColl then
        table.PostColl(_, npc, collider)
    end
end
function mod:GuwahEnemyDeath(npc)
    local table = GetGuwahEnemyTable(npc)
    if table and table.Death then
        table.Death(_, npc)
    end
end
function mod:GuwahEnemyRemove(npc)
    local table = GetGuwahEnemyTable(npc)
    if table and table.Remove then
        table.Remove(_, npc:ToNPC(), mod:GetEntityData(npc))
    end
end
function mod:GuwahEnemyRegen(npc)
    local table = GetGuwahEnemyTable(npc)
    if table and table.Regen then
        table.Regen(_, npc, npc:GetSprite(), mod:GetEntityData(npc))
    end
end
for id, _ in pairs(mod.GuwahEnemies) do
    mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.GuwahEnemyInit, id)
    mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.GuwahEnemyUpdate, id)
    mod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.GuwahEnemyPreUpdate, id)
    mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.GuwahEnemyRender, id)
    mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.GuwahEnemyHurt, id)
    mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, mod.GuwahEnemyColl, id)
    mod:AddCallback(ModCallbacks.MC_POST_NPC_COLLISION, mod.GuwahEnemyPostColl, id)
    mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.GuwahEnemyDeath, id)
    mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, mod.GuwahEnemyRemove, id)
    mod:AddCallback(ModCallbacks.MC_POST_NPC_DARK_RED_CHAMPION_REGEN, mod.GuwahEnemyRegen, id)
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
    local data = mod:GetEntityData(npc)
    local sprite = npc:GetSprite()
    mod:SkulltistWhitelistCheck(npc)
    if npc.SpawnerEntity then
        if npc.SpawnerEntity.Type == EntityType.ENTITY_PORTAL and mod:GetEntityData(npc.SpawnerEntity).Gehenna then
            local fadeDuration = 30
            for i = 1, fadeDuration do
                local mult = fadeDuration - i
                mod.scheduleForUpdate(function()
                    if npc:Exists() then
                        npc:SetColor(Color(1,1,1,1,(0.7/fadeDuration)*mult),2,1,true,false)
                    end
                end, i)
            end
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
    if npc.Variant == 1 and mod:CheckStage("Gehenna", {47}) then
        npc:GetSprite():Load("gfx/monsters/repentance/lil_portal_red.anm2", true)
        mod:GetEntityData(npc).Gehenna = true
        npc.SplatColor = Color(1, 0.95, 0.95, 0.5, 0.5, 0.2, 0.2)
        mod.scheduleForUpdate(function()
            if npc:Exists() then
                npc.SplatColor = Color(1, 0.95, 0.95, 0.5, 0.5, 0.2, 0.2)
            end
        end, 1)
    end
end, EntityType.ENTITY_PORTAL)

function mod:BlacklistedChampionCheck(npc)
    if npc:IsChampion() then
        local check, entry = mod:CheckIDInTable(npc, mod.BlacklistedChampions)
        if check and entry then 
            local enforcehealth = npc.MaxHitPoints --Bc champion conversions double health each time, yipee
            while entry[npc:GetChampionColorIdx()] do
                local rng = npc:GetDropRNG()
				local championType = npc:GetChampionColorIdx()
				local championID = -1
				if championType == ChampionColor.YELLOW or championType == ChampionColor.RAINBOW then --Speed modifier is still there after the champion type is changed
					championID = ChampionColor.BLUE
                elseif championType == ChampionColor.TINY then
					npc.Size = npc:GetEntityConfigEntity():GetCollisionRadius()
					championID = ChampionColor.GREY
                elseif championType == ChampionColor.WHITE then
					npc:SetInvincible(false)
                end

                -- Remove "pulling effect" from certain champions
                for _, swirl in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.PULLING_EFFECT)) do
                    if swirl.SpawnerEntity and GetPtrHash(swirl.SpawnerEntity) == GetPtrHash(npc) then
                        swirl:Remove()
                    end 
                end

                npc:MakeChampion(rng:Next(), championID, true)
				npc.MaxHitPoints = enforcehealth --It isnt perfect but it prevents super wackies
				npc.HitPoints = npc.MaxHitPoints
            end
        end
    end
    --mod:GetEntityData(npc).FFCheckedBlacklistedChampion = true
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.FrameCount <= 1 then
        mod:BlacklistedChampionCheck(npc)
        if mod.roomBackdrop == 10 or mod.GetEntityCount(150,1000,10) > 0 then --Morbus skins
            if npc.Type == EntityType.ENTITY_SPIKEBALL then
                local sprite = npc:GetSprite()
                sprite:ReplaceSpritesheet(0, "gfx/monsters/repentance/852.000_spikeball_morbus.png")
                sprite:LoadGraphics()
            end
        end

        if mod:CheckStage("Corpse", {34,43,44}) then --Stage skins
            if npc.Type == EntityType.ENTITY_WHIPPER and npc.Variant == 2 then
                mod:ReplaceEnemySpritesheet(npc, "gfx/monsters/repentance/834.002_lunatic_body_corpse", 0)
                mod:ReplaceEnemySpritesheet(npc, "gfx/monsters/repentance/834.002_lunatic_head_corpse", 1)
                mod:ReplaceEnemySpritesheet(npc, "gfx/monsters/repentance/834.002_lunatic_body_corpse", 2)
            elseif npc.Type == EntityType.ENTITY_BLACK_GLOBIN_BODY then
                mod:ReplaceEnemySpritesheet(npc, "gfx/monsters/afterbirth/280.000_blackglobinbody_corpse", 0)
            end
        elseif npc.Type == EntityType.ENTITY_CONJOINED_FATTY and npc.Variant == 1 and mod:CheckStage("Chest", {17}) then
            for i = 0, 1 do
                mod:ReplaceEnemySpritesheet(npc, "gfx/enemies/blueconjoinedfatties/257.001_blueconjoinedfatty", i)
            end
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if mod:GetEntityData(npc).SoundmakerFly then
        npc.State = 3
        if npc.Parent and npc.Parent:Exists() then
            npc.Velocity = Vector.Zero
            npc.Position = npc.Parent.Position
        else
            npc:Remove()
        end
    end
end, EntityType.ENTITY_ATTACKFLY)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if mod:GetEntityData(npc).SoundmakerFly then
        npc.State = 3
        if npc.Parent and npc.Parent:Exists() then
            npc.Velocity = Vector.Zero
            npc.Position = npc.Parent.Position
        else
            npc:Remove()
        end
    end
end, EntityType.ENTITY_FLY)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if mod:GetEntityData(npc).RestoreGroundCollision then
        if npc.PositionOffset.Y >= 0 then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            mod:GetEntityData(npc).RestoreGroundCollision = false
        end
    end
end, EntityType.ENTITY_SPIDER)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == 11 then --Coals
        if mod:GetEntityData(npc).forceSplatColor then
            npc.SplatColor = mod:GetEntityData(npc).forceSplatColor
        end

        --[[if mod:GetEntityData(npc).SpecilCoal then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
            if npc.FrameCount > 30 or game:GetRoom():GetGridCollisionAtPos(npc.Position) == GridCollisionClass.COLLISION_NONE then
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
                mod:GetEntityData(npc).SpecilCoal = false
            end
        end]]
        if mod:GetEntityData(npc).StayHereDamnIt then
            npc.Position = mod:GetEntityData(npc).StayHereDamnIt
        end
    end
end, EntityType.ENTITY_FIREPLACE)

mod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, function(_, npc)
    local data = mod:GetEntityData(npc)
    if data.RingLeader and not data.RingLeader:IsDead() and not mod:isStatusCorpse(data.RingLeader) then
        mod:RingWilloAI(npc, npc:GetSprite(), data)
        return true
    else
        data.RingLeader = nil
    end
end, EntityType.ENTITY_WILLO)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, amount, damageFlags, source, iFrames)
    if npc:ToNPC() then
        if source and source.Entity then
            if source.Type == 1 then
                local player = source.Entity:ToPlayer()
                if mod:HasDamageFlag(DamageFlag.DAMAGE_LASER, damageFlags) and not mod:GetEntityData(player).FiringCraigLaser then
                    mod:TryAddCraigBatteryCharge(player, mod.CraigOnHitCharge)
                end
            elseif source.Type == 3 then
                if source.Variant == FamiliarVariant.DIP then
                    if source.Entity.SubType == 670 then
                        npc:AddSlowing(source, 60, 0.5, Color(1,1,1,1,0.3,0.3,0.3))
                    end
                end
            elseif mod:GetEntityData(source.Entity).projType == "awesomeCoin" then
                return false
            elseif mod:GetEntityData(source.Entity).IsAleyaFire then
                return false
            end
        end
    end
end)

function mod:IsStompy(entity)
    if entity.Type == 1 then
        entity = entity:ToPlayer()
        if entity:HasCollectible(CollectibleType.COLLECTIBLE_LEO) or entity:HasCollectible(CollectibleType.COLLECTIBLE_THUNDER_THIGHS) or entity:HasPlayerForm(PlayerForm.PLAYERFORM_STOMPY) then
            return true
        end
    elseif entity.Type == 2 then
        entity = entity:ToTear()
        if entity.Variant == 43 or entity.Variant == 44 or entity:HasTearFlags(TearFlags.TEAR_ACID) or entity:HasTearFlags(TearFlags.TEAR_ROCK) then
            return true
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, function(_, npc, collider)
    if mod.GridLikeEntities[npc.Type.." "..npc.Variant.." "..-1] or mod.GridLikeEntities[npc.Type.." "..npc.Variant.." "..npc.SubType] then
        if mod:IsStompy(collider) then
            if npc.Type ~= EntityType.ENTITY_MOVABLE_TNT then
                npc:Die()
                return true
            end
        elseif collider:IsFlying() then
            return true
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, function(_, npc, collider)
    if mod:GetEntityData(npc).RingLeader then
        if collider.Type == 1 or collider.Type == 4 or collider:ToNPC() then
            return true
        end
    end
end, EntityType.ENTITY_WILLO)

mod.GuwahEffects = {
    [mod.FFID.GuwahJoke] = {
        [mod.FF.IDPDPortal.Sub] = {
            Update = mod.IDPDPortal,
        },
        [mod.FF.IDPDExplosion.Sub] = {
            Update = mod.IDPDExplosion,
        },
        [mod.FF.IDPDParticle.Sub] = {
            Update = mod.IDPDParticle,
        },
        [mod.FF.IDPDSlugPoof.Sub] = {
            Update = mod.IDPDSlugPoof,
        },
        [mod.FF.IDPDGun.Sub] = {
            Update = mod.IDPDGun,
        },
    },
    [mod.FFID.Guwah] = {
        [mod.FF.ZealotCrosshair.Sub] = {
            Update = mod.ZealotCrosshairAI,
        },
        [mod.FF.ZealotBeam.Sub] = {
            Init = mod.ZealotBeamInit,
            Update = mod.ZealotBeamAI,
        },
        [mod.FF.DungeonLock.Sub] = {
            Update = mod.DungeonLockAI,
        },
        [mod.FF.LargeWaterRipple.Sub] = {
            Init = mod.LargeWaterRippleInit,
            Update = mod.LargeWaterRippleAI,
        },
        [mod.FF.SlimShadyNova.Sub] = {
            Update = mod.SlimShadyNovaAI,
        },
        [mod.FF.NihilistAura.Sub] = {
            Update = mod.NihilistAuraAI,
        },
        [mod.FF.GrimoireFlame.Sub] = {
            Update = mod.GrimoireFlameAI,
        },
        [mod.FF.PaperGib.Sub] = {
            Update = mod.PaperGibAI,
        },
        [mod.FF.ShadowShield.Sub] = {
            Update = mod.ShadowShieldAI,
        },
        [mod.FF.DummyEffect.Sub] = {
            Init = mod.DummyEffectInit,
            Update = mod.DummyEffectAI,
        },
        [mod.FF.FlyingDrip.Sub] = {
            Render = mod.FlyingDripRender,
        },
        [mod.FF.FlyingOralid.Sub] = {
            Render = mod.FlyingOralidRender,
        },
        [mod.FF.CherubskullChain.Sub] = {
            Update = mod.CherubskullChainAI,
        },
        [mod.FF.FlyingSpicyDip.Sub] = {
            Render = mod.FlyingSpicyDipRender,
        },
        [mod.FF.ReverseBloodPoof.Sub] = {
            Update = mod.ReverseBloodPoofAI,
        },
        [mod.FF.CustomTracer.Sub] = {
            Update = mod.CustomTracerUpdate,
            Render = mod.CustomTracerRender,
        },
        [mod.FF.BriarStingerPoof.Sub] = {
            Update = mod.BriarStingerPoof,
        },
        [mod.FF.InfectedGrowth.Sub] = {
            Update = mod.InfectedGrowthUpdate,
        },
        [mod.FF.InfectedRing.Sub] = {
            Update = mod.InfectedRingUpdate,
        },
        [mod.FF.TemporarySpikes.Sub] = {
            Update = mod.TemporarySpikes,
        },
        [mod.FF.PigskinTarget.Sub] = {
            Update = mod.PigskinTarget,
        },
        [mod.FF.GamperChain.Sub] = {
            Update = mod.GamperChain,
        },
        [mod.FF.NailheadNail.Sub] = {
            Update = mod.NailheadNail,
            Render = mod.NailheadNailRender,
        },
        [mod.FF.ZephyrLightning.Sub] = {
            Update = mod.ZephyrLightning,
        },
        [mod.FF.AntiFiendWisp.Sub] = {
            Update = mod.AntiFiendWisp,
        },
        [mod.FF.GhastlyClone.Sub] = {
            Update = mod.GhastlyClone,
        },
        [mod.FF.BulbPlant.Sub] = {
            Update = mod.BulbPlant,
        },
        [mod.FF.CharacterControls.Sub] = {
            Init = mod.CharacterControlsEffect,
        },
        [mod.FF.PartyOrb.Sub] = {
            Update = mod.PartyOrb,
        },
        [mod.FF.DungeonMasterTarget.Sub] = {
            Update = mod.DungeonMasterTarget,
        },
        [mod.FF.FalseIdolAfterimage.Sub] = {
            Update = mod.FalseIdolAfterimage,
        },
    },
}


--EFFECT_INIT
function mod:GetGuwahEffectFunctions(effect)
    local table = mod.GuwahEffects
    if table[effect.Variant] then
        table = table[effect.Variant]
        if table[effect.SubType] then
            return table[effect.SubType]
        end
    end
end

function mod:GuwahEffectInit(effect)
    local data = mod:GetEntityData(effect)
    data.GuwahFunctions = mod:GetGuwahEffectFunctions(effect)
    local datatable = data.GuwahFunctions
    if datatable then
        local funct = datatable.Init
        if funct then
            funct(_, effect)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.GuwahEffectInit, mod.FFID.Guwah)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.GuwahEffectInit, mod.FFID.GuwahJoke)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, effect)
    if effect.SpawnerEntity then
        if effect.SubType == 65537 and effect.SpawnerEntity:ToNPC() then
            if effect.SpawnerType == 915 and effect.SpawnerVariant == 1 and mod.IsCustomRockBall(effect.SpawnerEntity) then
                effect:Remove()
            else
                mod:GetEntityData(effect).changespritesheet = "gfx/grid/rocks_vanilla.png"
            end
        end
    end
end, EffectVariant.ROCK_PARTICLE)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, effect)
    if effect.SpawnerEntity then
        if effect.SpawnerType == mod.FF.Drumstick.ID and effect.SpawnerVariant == mod.FF.Drumstick.Var then
            mod:GetEntityData(effect).SpriteScaleSet = Vector(0.75,0.75)
        elseif effect.SpawnerType == mod.FF.SlothsHead.ID and effect.SpawnerVariant == mod.FF.SlothsHead.Var then
            effect.Color = mod.ColorGurgleGibs
        end
    end
end, EffectVariant.BLOOD_SPLAT)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, effect)
    if effect.SpawnerEntity then
        if effect.SpawnerType == mod.FF.SlothsHead.ID and effect.SpawnerVariant == mod.FF.SlothsHead.Var then
            local creep = Isaac.Spawn(1000, EffectVariant.CREEP_GREEN, 0, effect.Position, effect.Velocity, effect.SpawnerEntity)
            creep:Update()
            effect.Visible = false
            effect:Remove()
        end
    end
end, EffectVariant.CREEP_RED)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, effect)
    if effect.SubType == mod.FF.LemonMishapEnemy.Sub then
        mod:LemonMishapEnemyInit(effect)
    end
end, EffectVariant.CREEP_YELLOW)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, effect)
    if effect.SpawnerEntity then
        if mod:GetEntityData(effect.SpawnerEntity).IsAleyaFire then
            mod:GetEntityData(effect).AleyaEmber = true
            effect.Visible = false
        end
    end
end, EffectVariant.EMBER_PARTICLE)

function mod:AddDummyEffect(npc, offset)
    local effect = Isaac.Spawn(mod.FF.DummyEffect.ID, mod.FF.DummyEffect.Var, mod.FF.DummyEffect.Sub, npc.Position, Vector.Zero, npc):ToEffect()
    effect:FollowParent(npc)
    if npc:GetSprite().FlipX then
        offset = Vector(-offset.X, offset.Y)
    end
    effect.ParentOffset = offset
    return effect
end

--EFFECT_UPDATE
function mod:GuwahEffectUpdate(effect)
    local data = mod:GetEntityData(effect)
    local datatable = data.GuwahFunctions
    if datatable then
        local funct = datatable.Update
        if funct then
            funct(_, effect, effect:GetSprite(), data)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.GuwahEffectUpdate, mod.FFID.Guwah)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.GuwahEffectUpdate, mod.FFID.GuwahJoke)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    if effect.FrameCount <= 1 and effect.SpawnerEntity then
        if mod:CheckIDInTable(effect.SpawnerEntity, mod.TomaEnemies) then
            effect.Color = mod.ColorDankBlackReal
        end
    end
end, EffectVariant.BLOOD_PARTICLE)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    if effect.FrameCount <= 1 then
        local data = mod:GetEntityData(effect)
        if data.SpriteScaleSet then
            effect.SpriteScale = data.SpriteScaleSet
        end
    end
end, EffectVariant.BLOOD_SPLAT)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    local data = mod:GetEntityData(effect)
    if data.ParentOffsetAdjust and not (data.ParentOffsetTarget and effect.ParentOffset:Length() >= data.ParentOffsetTarget:Length()) then
        effect.ParentOffset = effect.ParentOffset + data.ParentOffsetAdjust
    end
end, EffectVariant.BLOOD_EXPLOSION)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    if effect.FrameCount <= 1 then
        local data = mod:GetEntityData(effect)
        local sprite = effect:GetSprite()
        if data.changespritesheet then
            sprite:ReplaceSpritesheet(0, data.changespritesheet)
            sprite:LoadGraphics()
        end
    end
end, EffectVariant.ROCK_PARTICLE)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    if effect.FrameCount <= 1 and effect.SpawnerEntity then
        if effect.SpawnerType == EntityType.ENTITY_MONSTRO and effect.SpawnerEntity:ToNPC():GetBossColorIdx() == mod.FF.MucusMonstro.IDx  then --Mucus Monstro effect re-coloring
            effect.Color = mod.ColorSpittyGreen
        end
    end
end, EffectVariant.POOF02)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    if effect.SubType == mod.FF.LemonMishapEnemy.Sub then
        mod:LemonMishapEnemyAI(effect, effect:GetSprite(), mod:GetEntityData(effect))
    end
end, EffectVariant.CREEP_YELLOW)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    if effect.FrameCount <= 1 then
        local data = mod:GetEntityData(effect)
        if data.AleyaEmber then
            effect.Color = mod.ColorMinMinFire
            effect.Visible = true
        end
    end
end, EffectVariant.EMBER_PARTICLE)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    local data = mod:GetEntityData(effect)
    if data.LeaveOnRoomClear and game:GetRoom():IsClear() then
        effect:SetTimeout(30)
        data.LeaveOnRoomClear = nil
    end
end, EffectVariant.SMOKE_CLOUD)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
    local data = mod:GetEntityData(effect)
    if data.HeartCollect and effect.FrameCount > 4 then
        effect.Visible = false
        effect:Remove()
    end
end, 7000)


--EFFECT_RENDER
function mod:GuwahEffectRender(effect)
    local room = game:GetRoom()
    local isPaused = game:IsPaused()
    local isReflected = (room:GetRenderMode() == RenderMode.RENDER_WATER_REFLECT)
    local data = mod:GetEntityData(effect)
    local datatable = data.GuwahFunctions
    if datatable then
        local funct = datatable.Render
        if funct then
            funct(_, effect, effect:GetSprite(), data, isPaused, isReflected)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, mod.GuwahEffectRender, mod.FFID.Guwah)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, mod.GuwahEffectRender, mod.FFID.GuwahJoke)

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_INIT, function(_, projectile)
    local data = mod:GetEntityData(projectile)
    if mod.GatheringProjectiles then
        table.insert(mod.GatheredProjectiles, projectile)
    end
end)

function mod:SetGatheredProjectiles()
    mod.GatheredProjectiles = {}
    mod.GatheringProjectiles = true
end

function mod:GetGatheredProjectiles()
    mod.GatheringProjectiles = false
    return mod.GatheredProjectiles
end

function mod:FireProjectiles(npc, pos, vec, mode, params)
	mod:SetGatheredProjectiles()
	npc:FireProjectiles(pos, vec, mode, params)
	if mode == 0 then
		return mod:GetGatheredProjectiles()[1]
	else
		return mod:GetGatheredProjectiles()
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, projectile)
    local data = mod:GetEntityData(projectile)
    local sprite = projectile:GetSprite()
    mod:GuwahProjectileUpdate(projectile, sprite, data)
    --mod:PrintColor(projectile.Color)
    --print(projectile.Variant)
end)

function mod:GuwahProjectileUpdate(projectile, sprite, data)
    local projType = data.projType
    if projType then
        if projType == "akeldama" then
            mod:AkeldamaProjectile(projectile, data)
        elseif projType == "arcaneCreep" then
            mod:ArcaneCreepProjectile(projectile, data)
        elseif projType == "BigBunkerShot" then
            mod:BigBunkerProjectile(projectile, data)
        elseif projType == "LilBunkerShot" then
            mod:LilBunkerProjectile(projectile, data)
        elseif projType == "Kukodemon" then
            mod:KukodemonProjectile(projectile, data)
        elseif projType == "skipInk" then
            mod:SkippingInkProjectile(projectile, data)
        elseif projType == "stolas" then
            mod:StolasProjectile(projectile, data)
        elseif projType == "Dolphin" then
            mod:DolphinProjectile(projectile, data)
        elseif projType == "wigglyWorm" then
            mod:WigglyWormProjectile(projectile, data)
        elseif projType == "LostContact" then
            mod:LostContactProjectile(projectile, data)
        elseif projType == "Grimoire" then
            mod:GrimoireProjectile(projectile, data)
        elseif projType == "Apega" then
            mod:ApegaProjectile(projectile, data)
        elseif projType == "Basco" then
            mod:BascoProjectile(projectile, data)
        elseif projType == "corpseCluster" then
            mod:CorpseClusterProjectile(projectile, data)
        elseif projType == "cursedPoop" then
            mod:CursedPoopProjectile(projectile, data)
        elseif projType == "Chunky" then
            mod:ChunkyProjectile(projectile, data)
        elseif projType == "drumstickBone" then
            mod:DrumstickBoneProjectile(projectile, data)
        elseif projType == "drumstickHomingBone" then
            mod:DrumstickHomingBoneProjectile(projectile, data)
        elseif projType == "diagetic" then
            mod:DiageticProjectile(projectile, data)
        elseif projType == "skipVenom" then
            mod:SkippingVenomProjectile(projectile, data)
        elseif projType == "Temptress" then
            mod:TemptressProjectile(projectile, data)
        elseif projType == "Premonition" or projType == "Apocalypse" then
            mod:PremonitionProjectile(projectile, data)
        elseif projType == "Kriegsheld" then
            mod:KriegsheldProjectile(projectile, data)
        elseif projType == "RedBony" then
            mod:RedBonyProjectile(projectile, data)
        elseif projType == "CarveCreep" then
            mod:CarveCreepProjectile(projectile, data)
        end
    end

    if projectile.Variant == mod.FF.BriarThistle.Var then
        mod:BriarThistleProjectile(projectile, sprite, data)
    elseif projectile.Variant == mod.FF.BriarStinger.Var then
        data.RotationUpdate = true
        data.RotationOffset = 180
        mod:spritePlay(sprite, "Idle")
    elseif projectile.Variant == mod.FF.TrashbagProjectile.Var then
        mod:spritePlay(sprite, "Move")
    elseif projectile.Variant == mod.FF.FrogProjectile.Var or projectile.Variant == mod.FF.FrogProjectileBlood.Var then
        mod:FrogProjectile(projectile, sprite, data)
    elseif projectile.Variant == mod.FF.BetterCoinProjectile.Var then
        mod:BetterCoinProjectile(projectile, sprite, data)
    elseif projectile.Variant == mod.FF.IDPDProjectile.Var then
        mod:IDPDProjectile(projectile, sprite, data)
    elseif projectile.Variant == mod.FF.IDPDSlugProjectile.Var then
        mod:IDPDSlugProjectile(projectile, sprite, data)
    elseif projectile.Variant == mod.FF.PigskinProjectile.Var then
        mod:PigskinProjectile(projectile, sprite, data)
    elseif projectile.Variant == mod.FF.AntiFiendProjectile.Var then
        mod:AntiFiendFireball(projectile, sprite, data)
    end

    if data.Nihilism then
        mod:NihilismProjectile(projectile, data)
    end
    if data.RainbowCycle then
        mod:RainbowProjectile(projectile, data)
    end
    if data.RotationUpdate then
        local angle = projectile.Velocity:GetAngleDegrees()
        if data.RotationOffset then
            angle = angle + data.RotationOffset
        end
        projectile:GetSprite().Rotation = angle
    end
    if data.Wobblin then
        projectile.Velocity = projectile.Velocity * 0.9
        if projectile.FrameCount % 30 == 0 then
            if data.Switch then
                projectile.FallingAccel = -0.05
                data.Switch = false
            else
                projectile.FallingAccel = -0.15
                data.Switch = true
            end
        end
        if mod:IsReallyDead(projectile.Parent) and not data.WobblinTimer then
            projectile.FallingAccel = 1
            data.Wobblin = nil
        elseif data.WobblinTimer then
            data.WobblinTimer = data.WobblinTimer - 1
            if data.WobblinTimer <= 0 or game:GetRoom():IsClear() then
                projectile.FallingAccel = 1
                data.Wobblin = nil
            end
        end
    end
    if data.FlamethrowerFire then
        projectile:GetSprite().Color = Color.Default
        --[[if projectile.SpriteOffset.Y < 18 then
            projectile.SpriteOffset = Vector(0,math.min(18, projectile.SpriteOffset.Y + 2))
        end]]
    end

    if not data.GuwahProjInit then
        data.GuwahProjInit = true
        if projectile.SpawnerEntity then
            if mod:GetEntityData(projectile.SpawnerEntity).IsBlueWillo then
                projectile.Color = Color(1,1,1,1,64/255, 89/255, 128/255)
            elseif mod:GetEntityData(projectile.SpawnerEntity).IsAleyaFire then
                local proj = Isaac.Spawn(9,4,0,projectile.Position,projectile.Velocity,nil):ToProjectile()
                proj.Color = mod.ColorMinMinFire
                proj.Velocity = proj.Velocity * 1.2
                proj:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
                projectile:Remove()
            end
            if mod:GetEntityData(projectile.SpawnerEntity).ClodParent then
                projectile.Height = projectile.Height - 15
                projectile:AddProjectileFlags(ProjectileFlags.ANY_HEIGHT_ENTITY_HIT)
                projectile:Update()
            end
        end
    end
end

function mod:GatherProjectiles(npc)
    local projtable = {}
    for _, projectile in pairs(Isaac.FindByType(9, -1, -1)) do
        if projectile.FrameCount <= 1 and projectile.SpawnerType == npc.Type and projectile.SpawnerVariant == npc.Variant then
            table.insert(projtable, projectile)
        end
    end
    return projtable
end

function mod:LostContactProjectile(projectile, data)
	for _, tear in pairs(Isaac.FindInRadius(projectile.Position, projectile.Size, EntityPartition.TEAR)) do
		if tear:ToTear() then
            if not mod:IsTearPiercing(tear) then
			    tear:Die()
            end
			projectile:Die()
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, projectile)
    mod:GuwahProjectileRemove(projectile:ToProjectile())
end, 9)

function mod:GuwahProjectileRemove(projectile)
    projectile = projectile:ToProjectile()
    local data = mod:GetEntityData(projectile)
    local sprite = projectile:GetSprite()
    local projType = data.projType
    local room = game:GetRoom()
    if projType == "akeldama" then
        mod:AkeldamaProjectileRemove(projectile, data)
    elseif projType == "coalBall" then
        mod:CoalBallBreak(projectile, data)
    elseif projType == "Grimoire" then
        mod:GrimoireProjDeath(projectile, data)
    elseif projType == "purpleFlameCross" then
        mod:PurpleFlameCrossProjDeath(projectile, data)
    elseif projType == "bobsRottenHead" then
        mod:BobsRottenHeadDeath(projectile, data)
    elseif projType == "Basco" then
        mod:BascoProjectileDeath(projectile, data)
    elseif projType == "awesomeCoin" then
        mod:AwesomeCoinGet(projectile, data)
    elseif projType == "drumstickBone" then
        mod:DrumstickBoneDeath(projectile, data)
    elseif projType == "miniExplosion" then
        mod:MiniExplodeProjDeath(projectile, data)
    elseif projType == "taintedSpit" then
        mod:TaintedSpitProjDeath(projectile, data)
    end

    if projectile.Variant == mod.FF.BriarThistle.Var then
        mod:BriarThistleDeath(projectile, sprite)
    elseif projectile.Variant == mod.FF.BriarStinger.Var then
        mod:BriarStingerDeath(projectile, sprite)
    elseif projectile.Variant == mod.FF.TrashbagProjectile.Var then
        mod:TrashbagProjectileDeath(projectile, sprite)
    elseif projectile.Variant == mod.FF.FrogProjectile.Var or projectile.Variant == mod.FF.FrogProjectileBlood.Var then
        mod:FrogProjectileDeath(projectile, sprite)
    elseif projectile.Variant == mod.FF.BetterCoinProjectile.Var then
        mod:BetterCoinDeath(projectile, sprite)
    elseif projectile.Variant == mod.FF.IDPDProjectile.Var then
        mod:IDPDProjectileDeath(projectile, sprite)
    elseif projectile.Variant == mod.FF.IDPDSlugProjectile.Var then
        mod:IDPDSlugDeath(projectile, sprite)
    elseif projectile.Variant == mod.FF.AntiFiendProjectile.Var then
        mod:AntiFiendFireballDeath(projectile, sprite)
    end

    if data.massCreep then
        mod:LagFriendlyCreep(projectile.Position, 10, data.massCreep)
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, function(_, projectile, collider)
    if projectile.Variant == mod.FF.IDPDProjectile.Var or projectile.Variant == mod.FF.IDPDSlugProjectile.Var then
        if collider.Type == mod.FFID.GuwahJoke or (collider.Type == mod.FF.Gary.ID and collider.Variant == mod.FF.Gary.Var and collider.SubType == 1716) then
            return false
        end
    elseif collider.Type == mod.FFID.GuwahJoke and mod:GetEntityData(collider).ShieldActive then
        if not mod:GetEntityData(projectile).ShielderDeflected then
            mod:PlaySound(mod.Sounds.IDPDShieldDeflect,npc)
            projectile.Velocity = projectile.Velocity:Rotated(180):Resized(10)
            projectile:AddProjectileFlags(ProjectileFlags.HIT_ENEMIES)
            mod:GetEntityData(projectile).ShielderDeflected = true
        end
        return false
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, function(_, laser)
    local data = mod:GetEntityData(laser)
    if data.CherubRotation then
        mod:CherubLaser(laser, data)
    elseif data.OwlTechZero then
        mod:UpdateTechZeroLaser(laser, data)
    elseif data.ShockCollar then
        mod:ShockCollarTechRing(laser, data)
    elseif data.Weeper then
        mod:WeeperLaser(laser, data)
    elseif data.ZephyrRing then
        mod:ZephyrRing(laser, data)
    elseif data.CraigRing then
        mod:CraigRing(laser, data)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_BOMB_INIT, function(_, bomb)
    mod:GoldenFlyBombInitCheck(bomb)
end)

function mod:guwahPeffectUpdate(player, data)
    data.SpongeAngle = data.SpongeAngle or 0
    data.SpongeAngle = mod:NormalizeDegrees(data.SpongeAngle + 2)
    mod:ExcelsiorPlayerLogic(player, data)
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function(_, player)
    if not player:Exists() then return end
    local data = mod:GetEntityData(player)
    local sdata = data.ffsavedata
    if sdata.CrazyErrorDuration then
        mod:CrazyErrorSlotRender(player)
    end
    mod:TotemPlayerLaunchLogic(player)
end)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
    local data = mod:GetEntityData(player)
    data.DogrockDebuff = data.DogrockDebuff or 0
    if data.DogrockDebuff > 0 then
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            player.Damage = math.max(0.1, player.Damage * (1 - (0.5 * data.DogrockDebuff)))
        elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
            --player.MaxFireDelay = math.max(0.1, player.MaxFireDelay * (1 + (data.DogrockDebuff * 1.2))) -- direct maxfiredelay multipliers break at negative firedelay values
			player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, mod:convertTearMultABPToRep(1 + (data.DogrockDebuff * 1.2)))
        elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
            player.ShotSpeed = math.max(0.1, player.ShotSpeed - (data.DogrockDebuff * 0.6))
        elseif cacheFlag == CacheFlag.CACHE_RANGE then
            player.TearRange = math.max(100, player.TearRange - (data.DogrockDebuff * 150))
        elseif cacheFlag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = math.max(0.1, player.MoveSpeed - (data.DogrockDebuff * 0.7))
        elseif cacheFlag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck - (data.DogrockDebuff * 100)
        end
    end
    if cacheFlag == CacheFlag.CACHE_TEARFLAG then
        if data.BrickSeperatorBuff then
            player.TearFlags = player.TearFlags | TearFlags.TEAR_PIERCING
            player.TearColor = mod.ColorLegoOrange
        end
    elseif cacheFlag == CacheFlag.CACHE_TEARCOLOR then
        if data.BrickSeperatorBuff then
            player.TearColor = mod.ColorLegoOrange
        end
    elseif cacheFlag == CacheFlag.CACHE_FLYING then
        if data.TotemUpward then
            player.CanFly = false
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, player, amount, damageFlags, source, iFrames)
    player = player:ToPlayer()
    local data = mod:GetEntityData(player)
    mod:HectorDamageCheck(player)
    if source and source.Entity then
        if source.Type == mod.FFID.Tech then
            if source.Variant == mod.FF.DangerousDisc.Var or source.Variant == mod.FF.DangerousDiscGuide.Var then
                sfx:Play(mod.Sounds.SawImpact, 0.5)
                mod:PlaySound(SoundEffect.SOUND_DEATH_BURST_LARGE, nil, 1.2, 2)
                player:BloodExplode()
                for _ = 0, 5 do
                    Isaac.Spawn(1000, 5, 0, player.Position, Vector.One:Resized(rng:RandomFloat()*6):Rotated(mod:RandomAngle()), player)
                end
            end
        elseif mod:GetEntityData(source.Entity).IsFireworkExplosion then
            return false
        elseif mod:GetEntityData(source.Entity).projType == "awesomeCoin" then
            return false
        end
    end
end, EntityType.ENTITY_PLAYER)

mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, function(_, itemID, itemRNG, player, useFlags, slot, varData)
    local data = mod:GetEntityData(player)
    if data.TotemUpward or data.TotemDownward then
        return true
    end
    mod:ExcelsiorActiveLogic(player, data, itemID, useFlags, slot)
end)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
    local data = mod:GetEntityData(tear)
    local sprite = tear:GetSprite()
    if tear.Variant == mod.FF.FireworkRocket.Var or data.IsFireworkRocket then
        mod:FireworkRocketAI(tear, data, sprite)
    end
end)

mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, function(_, tear, collider, low)
    local data = mod:GetEntityData(tear)
    if tear.Variant == mod.FF.FireworkRocket.Var or data.IsFireworkRocket then
        return mod:FireworkRocketColl(tear, collider)
    end
    if collider.Type == mod.FF.Apega.ID and collider.Variant == mod.FF.Apega.Var and not (mod:GetEntityData(collider).opened or tear:HasTearFlags(TearFlags.TEAR_EXPLOSIVE) or mod:isFriend(collider)) then
        if not data.apegaReflected then
            sfx:Play(SoundEffect.SOUND_BEEP, 1, 0, false, 0.1 * mod:RandomInt(6,8))
            tear.Velocity = (tear.Position - collider.Position):Resized(tear.Velocity:Length() * 0.8)
            data.apegaReflected = true
        end
        return false
    end
end)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
    local data = mod:GetEntityData(familiar)
    local sprite = familiar:GetSprite()
    if familiar.Variant == FamiliarVariant.DIP then
        if familiar.SubType == 670 then
            mod:SpiderDipUpdate(familiar, data, sprite)
        elseif familiar.SubType == 671 then
            mod:EvilDipUpdate(familiar, data, sprite)
        elseif familiar.SubType == 672 then
            familiar.SplatColor = mod.ColorPoop
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, function(_, familiar)
    local data = mod:GetEntityData(familiar)
    local sprite = familiar:GetSprite()
    if familiar.Variant == FamiliarVariant.DIP then
        if familiar.SubType == 671 then
            mod:EvilDipRender(familiar, data, sprite)
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, familiar, amount, damageFlags, source, iFrames)
    local familiar = familiar:ToFamiliar()
    local player = familiar.Player
    local data = mod:GetEntityData(familiar)
    if familiar.Variant == FamiliarVariant.DIP then
        if familiar.SubType == 670 then
            mod:SpiderDipHurt(familiar, source, data)
        end
    end
end, EntityType.ENTITY_FAMILIAR)

-----------------   Here's all my functionssssssssssssssssssssssss  ----------------------
function mod:RandomInt(min, max, customRNG)
    if type(min) == "table" then
        customRNG = max
        max = min[2]
        min = min[1]
    end
    if not max then
        customRNG = max
        max = min
        min = 0
    end
    if min > max then
        local temp = min
        min = max
        max = temp
    end
    local rand = customRNG or rng
    return min + (rand:RandomInt(max - min + 1))
end

function mod:IsTrinketGulped(player, trinketId)
    local bool = false
    if player:HasTrinket(trinketId) then
        bool = true
        for i = 0, 1 do
            local trinket = player:GetTrinket(i)
            if trinket == trinketId or trinket == trinketId + TrinketType.TRINKET_GOLDEN_FLAG then
                bool = false
            end
        end
    end
    return bool
end

function mod:IsTearPiercing(tear)
    tear = tear:ToTear()
    local check = (tear:HasTearFlags(TearFlags.TEAR_PIERCING) or tear:HasTearFlags(TearFlags.TEAR_BELIAL) or tear:HasTearFlags(TearFlags.TEAR_LASERSHOT) or tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) or tear.Variant == TearVariant.CHAOS_CARD)
    return check
end

function mod.ClearOccupiedIndex(npc, data)
    if data.Index then
        mod.OccupiedGrids[data.Index] = "Open"
    end
end

function mod:RandomAngle(customRNG)
    local rand = customRNG or rng
    return mod:RandomInt(0,359,rand)
end

function mod:GetRandomElem(table, customRNG)
    local rand = customRNG or rng
    if table and #table > 0 then
        return table[mod:RandomInt(1,#table,rand)]
    end
end

function mod:Contains(table, elem)
    for _, e in pairs(table) do
        if e == elem then
            return true
        end
    end
end

function mod:IsPlayerDamage(source)
    if source.Entity ~= nil then
        return (source.Entity.Type == 1 or source.Entity.Type == 3 or source.Entity.SpawnerType == 1 or source.Entity.SpawnerType == 3)
    else
        return false
    end
end

function mod:GetPlayerSource(source)
    if source and source.Entity then
        if source.Entity:ToPlayer() ~= nil then
            return source.Entity:ToPlayer()
        elseif source.Entity:ToFamiliar() ~= nil then
            return source.Entity:ToFamiliar().Player
        elseif source.Entity.SpawnerEntity ~= nil then
            if source.Entity.SpawnerEntity:ToPlayer() ~= nil then
                return source.Entity.SpawnerEntity:ToPlayer()
            elseif source.Entity.SpawnerEntity:ToFamiliar() ~= nil then
                return source.Entity.SpawnerEntity:ToFamiliar().Player
            else
                return nil
            end
        else
            return nil
        end
    else
        return nil
    end
end

function mod:HasDamageFlag(damageFlag, damageFlags)
    return damageFlags & damageFlag ~= 0
end

function mod:CheckStage(stagename, backdroptypes)
    local level = game:GetLevel()
    local room = game:GetRoom()
    local levelname = level:GetName()
    if levelname == stagename or levelname == stagename.." I" or levelname == stagename.." II" then
        return true
    elseif backdroptypes then
        for _, backdrop in pairs(backdroptypes) do
            if room:GetBackdropType() == backdrop then
                return true
            end
        end
    end
    return false
end

function mod:GetNearestEnemy(position, radius, filter)
    local nearest = nil
    local nearDist = 10000
    radius = radius or 10000
    for _, enemy in ipairs(Isaac.GetRoomEntities()) do
        if enemy:IsEnemy() then
            enemy = enemy:ToNPC()
            if radius then
                if position:Distance(enemy.Position) > radius then
                    goto GuwahGetNearestEnemyContinue
                end
            end
            if filter then
                if not filter(position, enemy) then
                    goto GuwahGetNearestEnemyContinue
                end
            end
            nearest = mod:DistanceCompare(nearDist, nearest, enemy, position)
            nearDist = nearest.Position:Distance(position)
        end
        ::GuwahGetNearestEnemyContinue::
    end
    return nearest
end

function mod:GetAllEnemies(filter)
    local returntable = {}
    for _, enemy in ipairs(Isaac.GetRoomEntities()) do
        if enemy:IsEnemy() then
            enemy = enemy:ToNPC()
            if filter then
                if filter(_, enemy) then
                    table.insert(returntable, enemy)
                end
            else
                table.insert(returntable, enemy)
            end
        end
    end
    return returntable
end

function mod:GetAnyEnemy(filter)
    for _, enemy in ipairs(Isaac.GetRoomEntities()) do
        if enemy:Exists() and enemy:IsEnemy() then
            enemy = enemy:ToNPC()
            if filter then
                if filter(position, enemy) then
                    return enemy
                end
            else
                return enemy
            end
        end
    end
end

function mod:GetNearestThing(position, type, variant, subtype, filter)
    local nearest = nil
    local nearDist = 10000
    variant = variant or -1
    subtype = subtype or -1
    for _, entity in ipairs(Isaac.FindByType(type, variant, subtype, false, false)) do
        if filter then
            if not filter(position, entity) then
                goto GuwahGetNearestThingContinue
            end
        end
        nearest = mod:DistanceCompare(nearDist, nearest, entity, position)
        nearDist = nearest.Position:Distance(position)
        ::GuwahGetNearestThingContinue::
    end
    return nearest
end

function mod:FindAndFilter(filter, type, variant, subtype)
    local returntable = {}
    variant = variant or -1
    subtype = subtype or -1
    for _, entity in pairs(Isaac.FindByType(type, variant, subtype, false, false)) do
        if filter then
            if filter(entity) then
                table.insert(returntable, entity)
            end
        else
            table.insert(returntable, entity)
        end
    end
    return returntable
end

function mod:GetFirstThing(type, variant, subtype, filter)
    variant = variant or -1
    subtype = subtype or -1
    for _, entity in pairs(Isaac.FindByType(type, variant, subtype, false, false)) do
        if filter then
            if filter(entity) then
                return entity
            end
        else
            return entity
        end
    end
    return nil
end

function mod:GetRandomThing(type, variant, subtype, filter)
    local choices = {}
    variant = variant or -1
    subtype = subtype or -1
    for _, entity in pairs(Isaac.FindByType(type, variant, subtype, false, false)) do
        if filter then
            if filter(entity) then
                table.insert(choices, entity)
            end
        else
            table.insert(choices, entity)
        end
    end
    return mod:GetRandomElem(choices)
end

function mod:FindSafeSpawnSpot(position, radius, fallbackRadius, fallbackToPos, avoidPlayer, checkGridPath)
    radius = radius or 9999
    local room = game:GetRoom()
    local pathfinder = Isaac.Spawn(150,20,0,position,Vector.Zero,nil):ToNPC() --Spawns a Chain Ball, teleports it around for pathfinding checks. Shopkeeper didnt work for some reason. I hate this.
    pathfinder:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    pathfinder:AddEntityFlags(EntityFlag.FLAG_NO_QUERY)
    pathfinder.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    pathfinder.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
    pathfinder.Visible = false
    local valids1 = {}
    local valids2 = {}

    for i = 0, room:GetGridSize() do
        local gridpos = room:GetGridPosition(i)
        local gridDist = gridpos:Distance(position)
        if gridDist <= radius and (checkGridPath == nil or room:GetGridPath(i) <= 900) and room:GetGridCollision(i) <= GridCollisionClass.COLLISION_NONE then
            if gridDist <= radius then
                pathfinder.Position = gridpos
                pathfinder:Update()
                if not (mod:AmISoftlocked(pathfinder, true) or (avoidPlayer and gridpos:Distance(game:GetNearestPlayer(gridpos).Position) < avoidPlayer)) then
                    table.insert(valids1, gridpos)
                end
            elseif fallbackRadius and gridDist <= fallbackRadius then
                pathfinder.Position = gridpos
                pathfinder:Update()
                if not (mod:AmISoftlocked(pathfinder, true) or (avoidPlayer and gridpos:Distance(game:GetNearestPlayer(gridpos).Position) < avoidPlayer)) then
                    table.insert(valids2, gridpos)
                end
            end
        end
    end
    pathfinder:Remove()

    local spawnpos = mod:GetRandomElem(valids1)
    if fallbackRadius and not spawnpos then
        spawnpos = mod:GetRandomElem(valids2)
    end
    if fallbackToPos and not spawnpos then
        spawnpos = position
    end
    return spawnpos
end

function mod:AmISoftlocked(npc, allowLineOfSight)
    local room = game:GetRoom()
    npc = npc:ToNPC()
    for i = 0, game:GetNumPlayers() do
        local playerpos = game:GetPlayer(i).Position
        if npc.Pathfinder:HasPathToPos(playerpos) or (allowLineOfSight and room:CheckLine(npc.Position, playerpos, 3, 0, false, false)) then
            return false
        end
    end
    return true
end

function mod:GetAngleDegreesButGood(vec)
    local angle = (vec):GetAngleDegrees()
    if angle < 0 then
        return 360 + angle
    else
        return angle
    end
end

function mod:GetAngleDifference(vec1, vec2) --Keeping this one here so old stuff wont break
    local angleDifference = mod:GetAngleDegreesButGood(vec1) - mod:GetAngleDegreesButGood(vec2)
    while angleDifference < 0 do
        angleDifference = angleDifference + 360
    end
    return angleDifference
end

--From Dead
function mod:GetAngleDifferenceDead(a1, a2)
    if type(a1) ~= "number" then
        a1 = mod:GetAngleDegreesButGood(a1)
    end
    if type(a2) ~= "number" then
        a2 = mod:GetAngleDegreesButGood(a2)
    end
    local sub = a1 - a2
    return (sub + 180) % 360 - 180
end

--Also from Dead, might come in handy eventually
function mod:LerpAngleDegrees(aStart, aEnd, percent)
    return mod:GetAngleDegreesButGood(aStart) + mod:GetAngleDifferenceDead(aEnd, aStart) * percent
end

function mod:NormalizeDegrees(a)
    return -((-a + 180) % 360) + 180
end

function mod:NormalizeDegreesTo360(a)
    return a % 360
end

function mod:GetAbsoluteAngleDifference(vec1, vec2)
    local val = math.abs(mod:NormalizeDegrees(mod:NormalizeDegrees(mod:GetAngleDegreesButGood(vec1)) - mod:NormalizeDegrees(mod:GetAngleDegreesButGood(vec2))))
    return val
end

function mod:DistanceCompare(nearDist, nearest, new, position)
    local furthest = new
    if new then
        nearDist = nearDist or 10000
        local newDist = new.Position:Distance(position)
        if newDist and newDist < nearDist then
            nearDist = newDist
            furthest = nearest
            nearest = new
        end
    end
    return nearest, nearDist
end

function mod:DistanceComparePoses(nearDist, nearest, new, position)
    if new then
        local newDist = new:Distance(position)
        if newDist < nearDist then
            nearDist = newDist
            nearest = new
        end
    end
    return nearest, nearDist
end

function mod:CheckIDInTable(entity, table)
    for _, entry in pairs(table) do
        if mod:CheckID(entity, entry) then
            return true, entry[4]
        end
    end
    return false
end

function mod:CheckID(entity, entry)
    if entity.Type == entry[1] then
        if entry[2] then
            if entry[2] == -1 or entity.Variant == entry[2] then
                if entry[3] then
                    if entry[3] == -1 or entity.SubType == entry[3] then
                        return true
                    end
                else
                    return true
                end
            end
        else
            return true
        end
    end
end

function mod:DamagePlayersInRadius(pos, radius, damage, source, flags, ignoreFlying)
    flags = flags or 0
    local did = false
    for i = 0, game:GetNumPlayers() do
        local player = game:GetPlayer(i)
        if player.Position:Distance(pos) <= player.Size + radius and not (ignoreFlying and player:IsFlying()) then
            if player:GetDamageCooldown() == 0 then
                did = true
            end
            player:TakeDamage(damage, flags, EntityRef(source), 0)
        end
    end
    return did
end

function mod:DamageEnemiesInRadius(pos, radius, damage, source)
    local did = false
    for _, enemy in pairs(Isaac.FindInRadius(pos, radius, EntityPartition.ENEMY)) do
        enemy:TakeDamage(damage, 0, EntityRef(source), 0)
        did = true
    end
    return did
end

function mod:IsNPCFlickerspiritable(npc)
    local etype = npc.Type
    local evar = npc.Variant
    local badent = false
    for _, v in ipairs(mod.effigyBlacklist) do
        if v[3] then if etype == v[1] and evar == v[2] and esub == v[3] then badent = true end
        elseif v[2] then if etype == v[1] and evar == v[2] then badent = true end
        elseif etype == v[1] then badent = true end
    end
    for _, v in ipairs(mod.HidingUnderwaterEnts) do
        if v[3] then if etype == v[1] and evar == v[2] and esub == v[3] then badent = true end
        elseif v[2] then if etype == v[1] and evar == v[2] then badent = true end
        elseif etype == v[1] then badent = true end
    end
    return not badent
end

--Adapted from Flooded Caves Overhaul, alot of stuff could use this
function mod:AddSoundmakerFly(npc)
    local anyBeelzebub
    for i = 0, game:GetNumPlayers() - 1 do
        local thisPlayer = Isaac.GetPlayer(i)
        if thisPlayer:HasPlayerForm(PlayerForm.PLAYERFORM_LORD_OF_THE_FLIES) then
            anyBeelzebub = true
            break
        end
    end
    if not anyBeelzebub then
        local fly = Isaac.Spawn(18, 0, 250, npc.Position, Vector.Zero, npc):ToNPC() -- (not) Fuck messin with that looping fly sound shit
        fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        fly:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_HIDE_HP_BAR | EntityFlag.FLAG_NO_REWARD | EntityFlag.FLAG_NO_DEATH_TRIGGER)
        fly.CanShutDoors = false
        fly.Visible = false
        fly.SplatColor = mod.ColorInvisible
        fly.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        mod:GetEntityData(fly).SoundmakerFly = true
        fly.Parent = npc
    end
end

function mod:ProjectileFriendCheck(npc, projectile)
    projectile = projectile:ToProjectile()
    if mod:isFriend(npc) then
        projectile:AddProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER + ProjectileFlags.HIT_ENEMIES)
    elseif mod:isCharm(npc) then
        projectile:AddProjectileFlags(ProjectileFlags.HIT_ENEMIES)
    end
end

function mod:PlaySound(soundID, npc, pitch, volume, isLooping, frameDelay, pan)
    pitch = pitch or 1
    volume = volume or 1
    frameDelay = frameDelay or 2
    pan = pan or 0
    if npc and npc:ToNPC() then
        npc:ToNPC():PlaySound(soundID, volume, frameDelay, isLooping, pitch)
    else
        sfx:Play(soundID, volume, frameDelay, isLooping, pitch, pan)
    end
end

function mod:PlayInitSound(soundID, npc, pitch, volume, isLooping, frameDelay, pan)
    mod.scheduleForUpdate(function()
        if npc and npc:Exists() then
            mod:PlaySound(soundID, npc, pitch, volume, isLooping, frameDelay, pan)
        end
    end, 0, ModCallbacks.MC_POST_UPDATE, true)
end

mod.SpritesheetlessChamps = {
    [ChampionColor.FLICKER] = true,
    [ChampionColor.CAMO] = true,
    [ChampionColor.TINY] = true,
    [ChampionColor.GIANT] = true,
    [ChampionColor.SIZE_PULSE] = true,
    [ChampionColor.KING] = true,
}

function mod:ReplaceEnemySpritesheet(npc, filepath, layer, loadGraphics) --Leave the ".png" OUT!!!
    layer = layer or 0
    loadGraphics = loadGraphics or true
    npc = npc:ToNPC()
    local sprite = npc:GetSprite()
    if npc:IsChampion() and not mod.SpritesheetlessChamps[npc:GetChampionColorIdx()] then
        filepath = filepath.."_champion"
    end
    filepath = filepath..".png"
    sprite:ReplaceSpritesheet(layer, filepath)
    if loadGraphics then
        sprite:LoadGraphics()
    end
end

function mod:RandomColor(maxoffset, mincolor, alpha, customRNG)
    maxoffset = maxoffset or 0
    mincolor = mincolor or 0
    alpha = alpha or 1
    maxoffset = math.floor((maxoffset / 0.1) * 100)
    mincolor = math.floor((mincolor / 0.1) * 100)
    return Color(mod:RandomInt(mincolor,1,customRNG)/100,mod:RandomInt(mincolor,1,customRNG)/100,mod:RandomInt(mincolor,1,customRNG)/100,alpha,mod:RandomInt(0,maxoffset,customRNG)/100,mod:RandomInt(0,maxoffset,customRNG)/100,mod:RandomInt(0,maxoffset,customRNG)/100)
end

function mod:GetUnoccupiedPit(fallback)
    local opens = {}
    local pits = mod:GetAllGridIndexOfType(GridEntityType.GRID_PIT, GridCollisionClass.COLLISION_PIT)
    for _, index in pairs(pits) do
        if mod.OccupiedGrids[index] ~= "Closed" then
            table.insert(opens, index)
        end
    end
    local new = mod:GetRandomElem(opens)
    if new then
        return new
    else
        return fallback
    end
end

function mod:GetAllGridIndexOfType(type, collisionclass)
    local gridtable = {}
    local room = game:GetRoom()
    for i = 0, room:GetGridSize() - 1 do
        local grid = room:GetGridEntity(i)
        if grid and grid:GetType() == type then
            if room:GetGridCollisionAtPos(grid.Position) == collisionclass then
                table.insert(gridtable, grid:GetGridIndex())
            end
        end
    end
    return gridtable
end

function mod:CheckIndexForGrid(index, type, collisionclass)
    local room = game:GetRoom()
    local grid = room:GetGridEntity(index)
    if grid and grid:GetType() == type then
        if room:GetGridCollisionAtPos(grid.Position) == collisionclass then
            return true
        end
    end
end

function mod:GetNearestGridIndexOfType(type, collisionclass, position)
    local room = game:GetRoom()
    local nearest = nil --room:GetGridEntity(16)
    local nearDist = 10000
    for _, index in pairs(mod:GetAllGridIndexOfType(type, collisionclass)) do
        local grid = room:GetGridEntity(index)
        nearest = mod:DistanceCompare(nearDist, nearest, grid, position)
        nearDist = nearest.Position:Distance(position)
    end
    if nearest then
        return nearest:GetGridIndex()
    end
end

function mod:GetNearestRock(position)
    local room = game:GetRoom()
    local nearest = nil
    local nearDist = 10000
    for index = 0, room:GetGridSize() - 1 do
        local grid = room:GetGridEntity(index)
        if grid and grid:ToRock() and room:GetGridCollision(index) == GridCollisionClass.COLLISION_SOLID then
            nearest = mod:DistanceCompare(nearDist, nearest, grid, position)
            nearDist = nearest.Position:Distance(position)
        end
    end
    return nearest
end

function mod:GetNearestPosOfCollisionClass(position, collisionClass)
    local indextable = {}
    local room = game:GetRoom()
    for i = 0, room:GetGridSize() - 1 do
        if room:GetGridCollision(i) == collisionClass then
            table.insert(indextable, i)
        end
    end
    local nearest = nil
    local nearDist = 10000
    for _, index in pairs(indextable) do
        local pos = room:GetGridPosition(index)
        nearest = mod:DistanceComparePoses(nearDist, nearest, pos, position)
        nearDist = nearest:Distance(position)
    end
    return nearest or position
end

function mod:GetNearestPosOfCollisionClassOrLess(position, collisionClass)
    local indextable = {}
    local room = game:GetRoom()
    for i = 0, room:GetGridSize() - 1 do
        if room:GetGridCollision(i) <= collisionClass then
            table.insert(indextable, i)
        end
    end
    local nearest = nil
    local nearDist = 10000
    for _, index in pairs(indextable) do
        local pos = room:GetGridPosition(index)
        nearest = mod:DistanceComparePoses(nearDist, nearest, pos, position)
        nearDist = nearest:Distance(position)
    end
    return nearest or position
end

function mod:GetNearestPosOfCollisionClassOrGreater(position, collisionClass)
    local indextable = {}
    local room = game:GetRoom()
    for i = 0, room:GetGridSize() - 1 do
        if room:GetGridCollision(i) >= collisionClass then
            table.insert(indextable, i)
        end
    end
    local nearest = nil
    local nearDist = 10000
    for _, index in pairs(indextable) do
        local pos = room:GetGridPosition(index)
        nearest = mod:DistanceComparePoses(nearDist, nearest, pos, position)
        nearDist = nearest:Distance(position)
    end
    return nearest or position
end

function mod:FlipSprite(sprite, pos1, pos2)
    if pos1.X > pos2.X then
        sprite.FlipX = true
    else
        sprite.FlipX = false
    end
end

function mod:PrintEntityId(entity)
    print(entity.Type.." "..entity.Variant.." "..entity.SubType)
end

function mod:PrintColor(color)
    print(color.R.." "..color.G.." "..color.B.." "..color.A.." "..color.RO.." "..color.GO.." "..color.BO)
end

function mod:PrintTable(table)
    for index, entry in pairs(table) do
        print(index.." "..entry)
    end
end

function mod:IsReallyDead(npc)
    if npc and npc:Exists() and npc:ToNPC() ~= nil then
        npc = npc:ToNPC()
        return(npc:IsDead() or mod:isLeavingStatusCorpse(npc) or mod:isStatusCorpse(npc) or npc.State == 18)
    else
        return true
    end
end

function mod:IsNormalRender(allowPaused)
    local isReflected = (game:GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT or game:GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFRACT)
    if allowPaused then
        return not isReflected
    else
        local isPaused = game:IsPaused()
        return not (isPaused or isReflected)
    end
end

function mod:MakeAfterimage(entity, extraFunc, alpha, fadeAlpha)
    alpha = alpha or 0.5
    fadeAlpha = fadeAlpha or 0
    local sprite = entity:GetSprite()
    local effect = Isaac.Spawn(mod.FF.DummyEffect.ID, mod.FF.DummyEffect.Var, mod.FF.DummyEffect.Sub, entity.Position, Vector.Zero, entity)
    local sprite2 = effect:GetSprite()

    mod:GetEntityData(effect).afterImage = true
    sprite2:Load(sprite:GetFilename(), true)
    sprite2:Play(sprite:GetAnimation())
    sprite2:SetFrame(sprite:GetAnimation(), sprite:GetFrame())
    sprite2:SetOverlayFrame(sprite:GetOverlayAnimation(), sprite:GetOverlayFrame())
    sprite2.FlipX = sprite.FlipX
    sprite2.Scale = sprite.Scale
    effect.Color = Color(entity.Color.R, entity.Color.G, entity.Color.B, fadeAlpha, entity.Color.RO, entity.Color.BO, entity.Color.GO)
    effect:SetColor(Color(entity.Color.R, entity.Color.G, entity.Color.B, alpha, entity.Color.RO, entity.Color.BO, entity.Color.GO), 5, 1, true, false)
    effect.SpriteOffset = entity.SpriteOffset
    effect.DepthOffset = -500
    effect.Visible = true

    if extraFunc then
        extraFunc(entity, effect, sprite, sprite2)
    end
end

function mod:BoundValue(val, lowerbound, upperbound)
    if lowerbound then
        val = math.max(val, lowerbound)
    end
    if upperbound then
        val = math.min(val, upperbound)
    end
    return val
end

function mod:DamageInRadius(pos, radius, damage, source, flags, ignoreFlying, doFriendlyFire, enemyDamage, enemyDmgInterval, alwaysGatherEnemies, checkSelf, ignorePlayer)
    local hurtPlayers = true
    local hurtEnemies = false
    local did = false
    local playersHit = {}
    local enemiesHit = {}

    if source then
        if source:ToNPC() then
            hurtPlayers = not mod:isFriend(source)
            hurtEnemies = mod:isCharm(source)
            if checkSelf == nil then checkSelf = true end
        elseif source:ToProjectile() then
            hurtPlayers = not source:ToProjectile():HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER)
            hurtEnemies = source:ToProjectile():HasProjectileFlags(ProjectileFlags.HIT_ENEMIES)
        end
    end

    if doFriendlyFire then
        hurtEnemies = true
    end

    if ignorePlayer then
        hurtPlayers = false
    end

    damage = damage or 1
    flags = flags or 0
    enemyDamage = enemyDamage or damage
    enemyDmgInterval = enemyDmgInterval or 1

    if hurtPlayers then
        for i = 0, game:GetNumPlayers() do
            local player = game:GetPlayer(i)
            if player:Exists() and player.Position:Distance(pos) <= player.Size + radius and not (ignoreFlying and player:IsFlying()) then
                if player:GetDamageCooldown() == 0 then
                    did = true
                end
                player:TakeDamage(damage, flags, EntityRef(source), 0)
                table.insert(playersHit, player:ToPlayer())
            end
        end
    end

    if game:GetFrameCount() % enemyDmgInterval == 0 then
        for _, enemy in pairs(Isaac.FindInRadius(pos, radius * 2, EntityPartition.ENEMY)) do
            if enemy.Position:Distance(pos) <= enemy.Size + radius and not ((ignoreFlying and enemy:IsFlying()) or (checkSelf and source.Type == enemy.Type and source.Variant == enemy.Variant)) then
                if hurtEnemies and not mod:isFriend(enemy) then
                    enemy:TakeDamage(enemyDamage, flags, EntityRef(source), 0)
                    table.insert(enemiesHit, enemy:ToNPC())
                    did = true
                elseif hurtPlayer and mod:isFriend(enemy) then
                    enemy:TakeDamage(enemyDamage, flags, EntityRef(source), 0)
                    table.insert(enemiesHit, enemy:ToNPC())
                    did = true
                elseif alwaysGatherEnemies then
                    table.insert(enemiesHit, enemy:ToNPC())
                end
            end
        end
    end

    return did, hurtPlayers, playersHit, hurtEnemies, enemiesHit
end

function mod:FadeIn(ent, length)
    length = length or 4
    local color = ent.Color
    ent:SetColor(mod:CloneColor(color,0),length,1,true,true)
end

function mod:FadeOut(ent, length)
    length = length or 12
    local color = ent.Color
    ent.Color = mod:CloneColor(color,0)
    ent:SetColor(color,length,1,true,true)
end

function mod:CloneColor(color, alpha)
    local newColor = Color.Lerp(color, Color.Default, 0)
    newColor.A = alpha or 1
    return newColor
end

function mod:ShouldEntBeBlockedByKnight(ent)
    if ent:ToTear() then
        return not mod:IsTearPiercing(ent)
    elseif ent:ToFamiliar() then
        return (ent.Variant == FamiliarVariant.BLUE_FLY or ent.Variant == FamiliarVariant.BLUE_SPIDER)
    end
    return false
end

function mod:KnightDamageBlocking(npc, source, vulnerableAngle, angleBlockWidth)
    angleBlockWidth = angleBlockWidth or 90
    if vulnerableAngle and source and source.Entity and source.Entity:Exists() and mod:ShouldEntBeBlockedByKnight(source.Entity) then
        if source.Entity.Velocity:Length() > 0.1 and mod:GetAbsoluteAngleDifference(vulnerableAngle, source.Entity.Position - npc.Position - source.Entity.Velocity) > angleBlockWidth then
            if source.Entity:ToTear() then
                local tear = source.Entity:ToTear()
                if tear:HasTearFlags(TearFlags.TEAR_PERSISTENT) then
                    tear:Die()
                end
            end
            return true
        end
    end
    return false
end

function mod:IsDarkRedChampionGoo(npc)
    return npc:GetChampionColorIdx() == ChampionColor.DARK_RED and npc:GetDarkRedChampionRegenTimer() > 0
end

mod.LoopingSoundEntries = {}

function mod:AddLoopingSoundEntry(soundID, volume, pitch, duration)
    volume = volume or 1
    pitch = pitch or 1
    duration = duration or 3
    local entry
    local isNew = true
    for _, loopingSound in pairs(mod.LoopingSoundEntries) do
        if loopingSound.Sound == soundID then
            entry = loopingSound
            isNew = false
            break
        end
    end
    entry = entry or {}
    entry.Volume = volume
    entry.Pitch = pitch
    entry.Active = true
    if isNew then
        entry.Sound = soundID
        entry.Duration = duration
        table.insert(mod.LoopingSoundEntries, entry)
    else
        entry.Duration = math.max(duration, entry.Duration)
    end
    mod:LoopingSoundEntryUpdate(entry)
end

function mod:LoopingSoundEntryUpdate(loopingSound)
    if loopingSound.Active then
        loopingSound.Duration = loopingSound.Duration - 1
        if loopingSound.Duration <= 0 then
            sfx:Stop(loopingSound.Sound)
            loopingSound.Active = false
        else
            if not sfx:IsPlaying(loopingSound.Sound) then
                sfx:Play(loopingSound.Sound, loopingSound.Volume, 0, true, loopingSound.Pitch)
            end
            sfx:SetAmbientSound(loopingSound.Sound, loopingSound.Volume, loopingSound.Pitch)
        end
    end
end

mod.AltRockTypeToBreakSound = { --Unused for now
    [1] = SoundEffect.SOUND_POT_BREAK_2,
    [2] = SoundEffect.SOUND_MUSHROOM_POOF_2,
    [3] = SoundEffect.SOUND_ROCK_CRUMBLE,
    [4] = SoundEffect.SOUND_MEATY_DEATHS,
    [5] = SoundEffect.SOUND_POT_BREAK,
}