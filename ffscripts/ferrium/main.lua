local fenemy = "ffscripts.ferrium.enemies."
local fitems = "ffscripts.ferrium.items.collectibles."
local ftrinkets = "ffscripts.ferrium.items.trinkets."
local fgolem = "ffscripts.ferrium.items.golem."
local fspells = "ffscripts.ferrium.spells."
local fguns = "ffscripts.ferrium.guns."
local fmisc = "ffscripts.ferrium.misc."
local fpick = "ffscripts.ferrium.items.pickups."
local fcards = "ffscripts.ferrium.items.consumables."
local fslots = "ffscripts.ferrium.items.slots."
local fgrids = "ffscripts.ferrium.grids."
FiendFolio.LoadScripts({
	--Standard enemies
	fenemy .. "benign",
	fenemy .. "dewdrop",
	fenemy .. "connipshit",
	fenemy .. "tango",
	fenemy .. "bellow",
	fenemy .. "floodface",
	fenemy .. "frowny",
	fenemy .. "psystalk",
	fenemy .. "crucible",
	fenemy .. "fount",
	fenemy .. "drillbit",
	fenemy .. "minimoon",
	fenemy .. "bladder",
	fenemy .. "heartbeat",
	fenemy .. "ignis",
	fenemy .. "globlet",
	fenemy .. "crotchety",
	fenemy .. "gabber",
	fenemy .. "stalagnaught",
	fenemy .. "antigolem",
	fenemy .. "torment",
	fenemy .. "zissuru",
	fenemy .. "wheezer",
	fenemy .. "gritty",
	fenemy .. "psyclopia",
	fenemy .. "peepisser",
	fenemy .. "brood",
	fenemy .. "alderman",
	fenemy .. "unshornz",
	fenemy .. "dreadmaw",
	--fenemy .. "bluemaw",
	fenemy .. "specturn",
	fenemy .. "quaker",
	fenemy .. "shaker",
	fenemy .. "brisket",
	fenemy .. "accursed",
	fenemy .. "shellmet",
	fenemy .. "nematode",
	fenemy .. "g_host",
	fenemy .. "skullcap",
	fenemy .. "chummer",
	fenemy .. "hangman",
	fenemy .. "slimer",
	fenemy .. "fracture",
	fenemy .. "congaskuzz",
	fenemy .. "ringskuzz",
	fenemy .. "flailer",
	fenemy .. "holywobbles",
	fenemy .. "firewhirl",
	fenemy .. "whale",
	fenemy .. "clam",
	fenemy .. "lunksack",
	fenemy .. "coloscope",
	fenemy .. "putrefatty",
	fenemy .. "musk",
	fenemy .. "spanky",
	fenemy .. "spiroll",
	fenemy .. "thwammy",
	fenemy .. "acolyte",
	fenemy .. "edema",
	fenemy .. "forgottenfetus",
	fenemy .. "anode",
	fenemy .. "laideronnette",
	fenemy .. "cubert", --idk if this is counts as a joke
	fenemy .. "badbag",
	fenemy .. "thecolorred",
	fenemy .. "jugular",
	fenemy .. "puffball",
	fenemy .. "cochlea",
	fenemy .. "shader",
	fenemy .. "toad",
	fenemy .. "devourer",
	fenemy .. "indulger",
	fenemy .. "ruiner",
	fenemy .. "calsiketic",
	fenemy .. "levelpoofly",
	fenemy .. "hunkofgunk",
	fenemy .. "bloomer",
	fenemy .. "hazy",
	fenemy .. "excluder",
	fenemy .. "fogspawn",
	fenemy .. "writhe",
	fenemy .. "strand",
	fenemy .. "freethinker",
	fenemy .. "meatsack",
	fenemy .. "soulmatesoulmite",
	fenemy .. "rabbit",
	fenemy .. "sphere",

	--Vanilla variants
	fenemy .. "scowlcreep",
	fenemy .. "cellulitis",
	fenemy .. "floaty",
	fenemy .. "psychoknight",
	fenemy .. "seacucumber",
	fenemy .. "scopecreep",
	fenemy .. "grievance",
	fenemy .. "casted",
	fenemy .. "alfil",
	fenemy .. "stiffany",
	fenemy .. "soulspooter",
	fenemy .. "dreadpin",

	--Jokes and Misc
	fenemy .. "mouse",
	fenemy .. "murasa",
	fenemy .. "k3miku",
	fenemy .. "waiting",
	fenemy .. "custommoter",
	fenemy .. "shadyhost",
	fenemy .. "mawmr",
	fenemy .. "shinespit",
	fenemy .. "kablammer",

	--Bosses
	"ffscripts.ferrium.bosses.warpzone",
	"ffscripts.ferrium.bosses.corruptedcontusion",
	"ffscripts.ferrium.bosses.corruptedsuture",
	"ffscripts.ferrium.bosses.corruptedlarry",
	"ffscripts.ferrium.bosses.corruptedmonstro",
	"ffscripts.ferrium.bosses.deluge",

	--Items
	fitems .. "dicegoblin",
	fitems .. "cherrybomb",
	fitems .. "astropulvis",
	fitems .. "fistfulofash",
	fitems .. "goldshilunch",
	fitems .. "spellingbee",
	fitems .. "warfarin",
	fitems .. "mtndew",
	fitems .. "bloodthirstyblade",
	fitems .. "asteroidbelt",
	fitems .. "sweetred",
	fitems .. "humandomesticationguide", --I didn't expect this item out of any would become an uplifted joke item but here we are
	fitems .. "sidewaysonion",
	fitems .. "huitlacoche",
	fitems .. "spacefood",
	fitems .. "chemicalcookie",
	fitems .. "spiritofnightmare",
	fitems .. "impcurse",
	fitems .. "copperchunk",
	fitems .. "badblood",
	fitems .. "chaoticcarving",
	fitems .. "clownmeat",
	fitems .. "efficiencymodule",
	fitems .. "eighteenfootleash",
	fitems .. "bullethell",
	--fitems .. "catnip",
	fitems .. "raildriver",
	fitems .. "queensfruit",
	fitems .. "strangeeye",
	fitems .. "ceilingpopcorn",
	fitems .. "executioner",
	fitems .. "darkbargain",
	fitems .. "eternalpendant",
	fitems .. "babybell",
	fitems .. "blackcandelabra",
	fitems .. "infuser",
	fitems .. "hyperfixation",
	fitems .. "shadowrabbits",

	fitems .. "lethalinjection",

	ftrinkets .. "autopsykit",
	ftrinkets .. "fleacircus",
	ftrinkets .. "spiregrowth",
	ftrinkets .. "sharppenny",
	ftrinkets .. "angryfaic",
	ftrinkets .. "pocketdice",
	ftrinkets .. "lockedshackle",
	ftrinkets .. "theshampoobottle",
	ftrinkets .. "theshampoobottletext",
	ftrinkets .. "bombtoken",
	ftrinkets .. "cerberusorb",
	ftrinkets .. "bonelordstablet",
	ftrinkets .. "charredcard",
	ftrinkets .. "jokers",
	ftrinkets .. "eviolite",
	ftrinkets .. "sleepydust",
	ftrinkets .. "earthimpale",
	ftrinkets .. "comfortfood",
	ftrinkets .. "sproutingseed",
	ftrinkets .. "joybuzzer",
	ftrinkets .. "internalizedhatred",
	ftrinkets .. "clottytrinket",
	ftrinkets .. "bonuspennies",
	ftrinkets .. "hollowmoon",
	ftrinkets .. "linkcable",
	ftrinkets .. "fadedcard",
	ftrinkets .. "stitchedcard",
	ftrinkets .. "stainedcard",
	ftrinkets .. "crowdedcard",
	ftrinkets .. "spadeofclubs",
	ftrinkets .. "miniaturecard",
	ftrinkets .. "strangecocoon",
	ftrinkets .. "inkpot",
	ftrinkets .. "loosefilament",
	ftrinkets .. "smallbandaid",
	ftrinkets .. "hinge",
	ftrinkets .. "lifeinsurance",
	ftrinkets .. "goldleaf",
	ftrinkets .. "beatencross",
	ftrinkets .. "googlyeyes",

	fgolem .. "scentedrock",
	fgolem .. "arcaderock",
	fgolem .. "tintedheart",
	fgolem .. "warmgeode",
	fgolem .. "rosequartz",
	fgolem .. "hailstone",
	fgolem .. "ramblinopal",
	fgolem .. "chaingeode",
	fgolem .. "sanddollar",
	fgolem .. "fishfossil",
	fgolem .. "runicfossil",
	fgolem .. "saltlamp",
	fgolem .. "moltenslag",
	fgolem .. "cannedfossil",
	fgolem .. "sandstone",
	fgolem .. "fakerock",
	fgolem .. "citrinepulp",
	fgolem .. "bloodstone",
	fgolem .. "rustygeode",
	fgolem .. "fragmentedonyxgeode",
	fgolem .. "emeticantimony",
	fgolem .. "rockfromanabyss",
	fgolem .. "constantrockshooter",
	fgolem .. "robotrock",
	fgolem .. "rockcandy",
	fgolem .. "keystone",
	fgolem .. "meatslab",
	fgolem .. "sheeprock",
	fgolem .. "rebellionrock",
	fgolem .. "dadslegendarygoldenrock",
	fgolem .. "bedsheet",
	fgolem .. "fetalstone",
	fgolem .. "grimaces",
	fgolem .. "quantumgeode",
	fgolem .. "technologicalgeode",
	fgolem .. "buriedfossil",
	fgolem .. "focuscrystal",
	fgolem .. "trippyfossil",
	fgolem .. "maxsfossil",
	fgolem .. "bombsackfossil",
	fgolem .. "deathcapfossil",
	fgolem .. "explosivefossil",
	fgolem .. "oddlysmoothstone",
	fgolem .. "moonstone",
	fgolem .. "limestone",
	fgolem .. "carnalcarnelian",
	fgolem .. "rebarrock",
	fgolem .. "dogrockrock",
	fgolem .. "stalactite",
	fgolem .. "skuzzfossil",
	fgolem .. "shardofgolgotha",
	fgolem .. "petrifiedsock",
	fgolem .. "smokyquartz",
	fgolem .. "charcoal",
	fgolem .. "achillesrock",
	fgolem .. "rubbergeode",
	fgolem .. "valuefossil",
	fgolem .. "electrum",
	fgolem .. "purequartz",
	fgolem .. "amazonite",
	fgolem .. "starsapphire",
	fgolem .. "gravestone",
	fgolem .. "calzonegeode",
	fgolem .. "sandcastle",
	fgolem .. "guardedgarnet",
	fgolem .. "shamrock",
	fgolem .. "gaspocket",
	fgolem .. "coralfossil",
	fgolem .. "tipsygeode",
	fgolem .. "vinylgeode",
	fgolem .. "soapstone",
	fgolem .. "spiriturn",
	fgolem .. "necromanticfossil",
	fgolem .. "brainfossil",
	fgolem .. "sunshard",
	fgolem .. "steadfaststone",
	fgolem .. "insatiableapatite",
	fgolem .. "raistone",
	fgolem .. "orepenny",
	fgolem .. "prismaticgeode",
	fgolem .. "heavymetal",
	fgolem .. "grossular",
	fgolem .. "sulfurcrystal",
	fgolem .. "fractalgeode",
	fgolem .. "throwlomite",
	fgolem .. "hearthstone",
	fgolem .. "gmogeode",
	fgolem .. "magneticsand",
	fgolem .. "swallowedgeode",
	fgolem .. "leftfossil",
	fgolem .. "powerrock",
	fgolem .. "tigerseye",
	fgolem .. "smallerrock",
	fgolem .. "voodoogeode",
	fgolem .. "umbilicalgeode",
	fgolem .. "hiddenite",
	fgolem .. "pocketrockit",
	fgolem .. "homoeroticruby",
	fgolem .. "gaygarnet",
	fgolem .. "lithopedian",
	fgolem .. "jesusrock",
	fgolem .. "chunkofgallium",
	fgolem .. "onionrock",
	fgolem .. "aaageode",
	fgolem .. "libertygeode",
	fgolem .. "paperweight",
	fgolem .. "shroomite",
	fgolem .. "azerite",
	fgolem .. "gravel",
	fgolem .. "doublerubble", --moving some stuff around, old content
	fgolem .. "rockcake",
	fgolem .. "pigiron", --okay back to new stuff
	fgolem .. "elephantfossil",
	fgolem .. "fulgurite",
	fgolem .. "furnacerock",
	fgolem .. "malachite",
	fgolem .. "nonagongeode",
	fgolem .. "devouringgeode",
	fgolem .. "fishrock",
	fgolem .. "hellvite",
	fgolem .. "boosterrock",
	fgolem .. "rockettedragoon",
	fgolem .. "triangulargem",
	fgolem .. "noneuclideanrock",
	fgolem .. "quicksilver",
	fgolem .. "mirrorslate",
	fgolem .. "hammerhead",
	fgolem .. "colossalfossil",
	fgolem .. "fossilizedeye",

	--Pickups
	fpick .. "enginechest",
	fpick .. "thepenny",

	--Cards/Consumables
	fcards .. "misprintedgish",
	fcards .. "diceshards",
	fcards .. "pinkcow",
	fcards .. "aberrantcards",
	fcards .. "shadowversecards",

	--Grids
	fgrids .. "eggweb",

	--Guns
	fguns .. "cosmetic",
	fguns .. "camoundies",
	fguns .. "9volt",
	fguns .. "technology",
	fguns .. "monstroslung",
	fguns .. "techx",

	--Spells
	--Am I really doing this for a joke
	fspells .. "main",
	fspells .. "moonbeam",

	--Joke Items
	fitems .. "eternalclicker",
	fitems .. "d122",
	fitems .. "fiendsthirdleg",
	fitems .. "girldinner",
	fitems .. "infestedpipeline",
	fitems .. "eraser2",
	fitems .. "cacepi",
	fitems .. "golemswishlist",


	--Slots/Beggars
	fslots .. "cellgame",
	fslots .. "dicedispenser",
	fslots .. "pennypress",

	
	--Non Enemy Shenanigans
	fmisc .. "launchedStuff", --code shell for jumping enemies
	fmisc .. "rockshadows", --flashing shadows for rock projectiles
	fmisc .. "customProjectile", --code shell for custom projectiles
	fmisc .. "trinketFamiliarGameInit", --prevents duplicating trinket familiars
	fmisc .. "heldActives", --set data when players fire stuff like the candle
	--fmisc .. "renderSpells", --rendering for spell slots
	fmisc .. "customSmoke", --special smoke behavior for stuff like astropulvis
	fmisc .. "chargecircle", --custom charge bar
	fmisc .. "placedbomb", -- detecting when the player places a bomb through the button
	fmisc .. "gridprojectiles", --miscellaneous gridproj stuff, main function in _shared
	fmisc .. "dingleberryfix", --allows dingle berry to spawn ff dips too

	"ffscripts.ferrium.movementfuncs",
	"ffscripts.ferrium.maths", --various helper funcs for non gameplay stuff
	"ffscripts.ferrium.whatremains", --everything left over and random stuff
})

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local placeHolderRNG = RNG()

mod.FerriumEffects = {
	[mod.FF.TangoAfterimage.Sub] = {
		Update = mod.tangoafterimageAI,
	},
	[mod.FF.TangoAfterimage2.Sub] = {
		Update = mod.tangoafterimageAI,
	},
	[mod.FF.MurasaAnchorTrail.Sub] = {
		Update = mod.anchorAfterimageAI,
	},
	[mod.FF.MurasaEffects.Sub] = {
		Update = mod.murasaEffects,
	},
	[mod.FF.PissDroplets.Sub] = {
		Update = mod.pissDropletsEffect,
	},
	[mod.FF.RoseQuartzShield.Sub] = {
		Update = mod.roseQuartzShieldEffect,
	},
	[mod.FF.SaltLampAura.Sub] = {
		Update = mod.saltLampAuraEffect,
	},
	[mod.FF.FocusCrystalRing.Sub] = {
		Update = mod.focusCrystalRingEffect,
	},
	[mod.FF.FocusCrystalPoof.Sub] = {
		Disappear = "bang"
	},
	[mod.FF.MaxFossilGhost.Sub] = {
		Update = mod.dogFossilEffect,
	},
	[mod.FF.WarpZoneParticle.Sub] = {
		Update = mod.warpZoneParticleEffect,
	},
	[mod.FF.CharmHearts.Sub] = {
		Update = mod.charmHeartsEffect,
	},
	[mod.FF.GuardedGarnetShield.Sub] = {
		Update = mod.guardedGarnetShieldEffect,
	},
	[mod.FF.ShadowlessRockShadow.Sub] = {
		Update = mod.shadowlessRockShadowEffect,
	},
	[mod.FF.AstropulvisGhost.Sub] = {
		Update = mod.astropulvisGhostEffect,
		Init = mod.astropulvisGhostInit,
	},
	[mod.FF.HolyWobblesBeam.Sub] = {
		Update = mod.holyWobblesBeamEffect,
	},
	[mod.FF.LunksackNeedle.Sub] = {
		Update = mod.lunksackNeedleEffect,
	},
	[mod.FF.ChorusAfterimage.Sub] = {
		Update = mod.chorusAfterimageEffect,
	},
	[mod.FF.MoonbeamTarget.Sub] = {
		Update = mod.moonbeamTargetEffect,
	},
	[mod.FF.MoonbeamLight.Sub] = {
		Update = mod.moonbeamLightEffect,
	},
	[mod.FF.WomanIndicator.Sub] = {
		Disappear = "Woman"
	},
	[mod.FF.GenericAfterimage.Sub] = {
		Update = mod.genericAfterimageEffect,
	},
	[mod.FF.TheColorRedSplash.Sub] = {
		Update = mod.theColorRedSplashes,
	},
	[mod.FF.BloodthirstyBlade.Sub] = {
		Update = mod.BloodthirstyBladeEffect,
	},
	[mod.FF.WhiteTrailEffect.Sub] = {
		Update = mod.WhiteTrailEffect,
	},
	[mod.FF.MalachiteFlash.Sub] = {
		Disappear = "Flash"
	},
	[mod.FF.ChaoticCarving.Sub] = {
		Update = mod.ChaoticCarvingEffect,
	},
	[mod.FF.CerberusOrbExplosion.Sub] = {
		Disappear = "Explode"
	},
	[mod.FF.StrandSack.Sub] = {
		Update = mod.StrandSackEffect,
	},
	[mod.FF.BulletHellTarget.Sub] = {
		Update = mod.BulletHellEffect,
	},
	[mod.FF.QueensFruitHandler.Sub] = {
		Update = mod.QueensFruitHandlerEffect,
	},
	[mod.FF.QueensFruitSplash.Sub] = {
		Update = mod.QueensFruitSplashEffect,
	},
	[mod.FF.DarkBargainFakeItem.Sub] = {
		Update = mod.DarkBargainFakeItem,
	},
	[mod.FF.InfuserTiles.Sub] = {
		Update = mod.InfuserTileEffect,
	},
	[mod.FF.GooglyEyesEffect.Sub] = {
		Update = mod.GooglyEyesEffect,
	},
	[mod.FF.RaildriverCrack.Sub] = {
		Update = mod.RaildriverCrackUpdate,
	},
	[mod.FF.SweetRedDirt.Sub] = {
		Update = mod.SweetRedDirtEffect,
	},
	[mod.FF.ToadFearWisps.Sub] = {
		Update = mod.ToadFearWispsEffect,
	},
}

mod.FerriumEnemies = {
	[mod.FF.Benign.Var] = {
		Update = mod.benignAI,
		Hurt = mod.benignHurt,
	},
	[mod.FF.Dewdrop.Var] = {
		Update = mod.dewdropAI,
	},
	[mod.FF.Connipshit.Var] = {
		Update = mod.connipshitAI,
		Hurt = mod.connipshitHurt,
	},
	[mod.FF.Tango.Var] = {
		Update = mod.tangoAI,
		Death = mod.tangoDeath,
	},
	[mod.FF.Bellow.Var] = {
		Update = mod.bellowAI,
	},
	[mod.FF.Floodface.Var] = {
		Update = mod.floodfaceAI,
	},
	[mod.FF.Frowny.Var] = {
		Update = mod.frownyAI,
		Hurt = mod.frownyHurt,
	},
	[mod.FF.Psystalk.Var] = {
		Update = mod.psykerAI,
	},
	[mod.FF.Crucible.Var] = {
		Update = mod.crucibleAI,
		Hurt = mod.crucibleHurt,
		Coll = mod.crucibleColl,
	},
	[mod.FF.Fount.Var] = {
		--Update = mod.fountAI,
	},
	[mod.FF.Drillbit.Var] = {
		Update = mod.drillbitAI,
	},
	[mod.FF.Minimoon.Var] = {
		Update = mod.minimoonAI,
	},
	[mod.FF.Bladder.Var] = {
		Update = mod.bladderAI,
		Hurt = mod.bladderHurt,
	},
	[mod.FF.Heartbeat.Var] = {
		Update = mod.heartbeatAI,
		Hurt = mod.heartbeatHurt,
	},
	[mod.FF.Ignis.Var] = {
		Update = mod.ignisAI,
	},
	[mod.FF.Globlet.Var] = {
		Update = mod.globletAI,
		Kill = mod.globletKill,
		Death = mod.globletDeath,
	},
	[mod.FF.Crotchety.Var] = {
		Update = mod.crotchetyAI,
		Hurt = mod.crotchetyHurt,
		Kill = mod.crotchetyKill,
		Death = mod.crotchetyDeath,
	},
	[mod.FF.Gabber.Var] = {
		Update = mod.gabberAI,
	},
	[mod.FF.Stalagnaught.Var] = {
		Update = mod.stalagnaughtAI,
	},
	[mod.FF.AntiGolem.Var] = {
		Update = mod.antiGolemAI,
		Hurt = mod.antiGolemHurt,
	},
	[mod.FF.Torment.Var] = {
		Update = mod.tormentAI,
	},
	[mod.FF.Zissuru.Var] = {
		Update = mod.zissuruAI,
	},
	[mod.FF.Wheezer.Var] = {
		Update = mod.wheezerAI,
		Hurt = mod.wheezerHurt,
	},
	[mod.FF.Gritty.Var] = {
		Update = mod.grittyAI,
		Hurt = mod.grittyHurt,
	},
	[mod.FF.Psyclopia.Var] = {
		Update = mod.psyclopiaAI,
	},
	[mod.FF.Peepisser.Var] = {
		Update = mod.peepisserAI,
		Hurt = mod.peepisserHurt,
	},
	[mod.FF.Brood.Var] = {
		Update = mod.broodAI,
	},
	[mod.FF.Alderman.Var] = {
		Update = mod.aldermanAI,
		Hurt = mod.aldermanHurt,
	},
	[mod.FF.Unshornz.Var] = {
		Update = mod.unshornzAI,
		Coll = mod.unshornzColl,
	},
	[mod.FF.DreadMaw.Var] = {
		Update = mod.dreadMawAI,
		Hurt = mod.dreadMawHurt,
	},
	--[[[mod.FF.BlueMaw.Var] = {
		Update = mod.blueConjoinedMawAI,
	},]]
	[mod.FF.Quaker.Var] = {
		Update = mod.quakerAI,
	},
	[mod.FF.Shaker.Var] = {
		Update = mod.shakerAI,
	},
	[mod.FF.Brisket.Var] = {
		Update = mod.brisketAI,
	},
	[mod.FF.Accursed.Var] = {
		Update = mod.accursedAI,
		Hurt = mod.accursedHurt,
	},
	[mod.FF.Murmur.Var] = {
		Update = mod.murmurAI,
		Coll = mod.murmurColl,
	},
	[mod.FF.Shellmet.Var] = {
		Update = mod.shellmetAI,
		Coll = mod.shellmetColl,
	},
	[mod.FF.Nematode.Var] = {
		Update = mod.nematodeAI,
		Hurt = mod.nematodeHurt,
	},
	[mod.FF.G_Host.Var] = {
		Update = mod.g_HostAI,
		Hurt = mod.g_HostHurt,
		Coll = mod.g_HostColl,
	},
	[mod.FF.Skullcap.Var] = {
		Update = mod.skullcapAI,
		Hurt = mod.skullcapHurt,
	},
	[mod.FF.Chummer.Var] = {
		Update = mod.chummerAI,
		Hurt = mod.chummerHurt,
	},
	[mod.FF.Hangman.Var] = {
		Update = mod.hangmanAI,
	},
	[mod.FF.Slimer.Var] = {
		Update = mod.slimerAI,
	},
	[mod.FF.Fracture.Var] = {
		Update = mod.fractureAI,
		Hurt = mod.fractureHurt,
	},
	[mod.FF.CongaSkuzz.Var] = {
		Update = mod.congaSkuzzAI,
	},
	[mod.FF.RingSkuzz.Var] = {
		Update = mod.ringSkuzzAI,
	},
	[mod.FF.FlailerBody.Var] = {
		Update = mod.flailerAI,
		Render = mod.flailerRender,
		Coll = mod.flailerColl,
	},
	[mod.FF.HolyWobbles.Var] = {
		Update = mod.holyWobblesAI,
	},
	[mod.FF.Firewhirl.Var] = {
		Update = mod.firewhirlAI,
	},
	[mod.FF.Whale.Var] = {
		Update = mod.whaleAI,
		Hurt = mod.whaleHurt,
	},
	[mod.FF.Clam.Var] = {
		Update = mod.clamAI,
		Hurt = mod.clamHurt,
	},
	[mod.FF.Lunksack.Var] = {
		Update = mod.lunksackAI,
	},
	[mod.FF.Coloscope.Var] = {
		Update = mod.coloscopeAI,
	},
	[mod.FF.Putrefatty.Var] = {
		Update = mod.putrefattyAI,
		Coll = mod.putrefattyColl,
	},
	[mod.FF.Musk.Var] = {
		Update = mod.muskAI,
	},
	[mod.FF.Spanky.Var] = {
		Update = mod.spankyAI,
		Coll = mod.spankyColl,
	},
	[mod.FF.Spiroll.Var] = {
		Update = mod.spirollAI,
		Coll = mod.spirollColl,
	},
	[mod.FF.Thwammy.Var] = {
		Update = mod.thwammyAI,
		Hurt = mod.thwammyHurt,
		Coll = mod.thwammyColl,
	},
	[mod.FF.Acolyte.Var] = {
		Update = mod.acolyteAI,
	},
	[mod.FF.ForgottenFetus.Var] = {
		Update = mod.forgottenFetusAI,
		Coll = mod.forgottenFetusColl,
	},
	[mod.FF.LilAl.Var] = {
		Update = mod.lilAlAI,
	},
	[mod.FF.ForgottenFetusHitbox.Var] = {
		Update = mod.forgottenFetusHitboxAI,
		Hurt = mod.forgottenFetusHitboxHurt,
	},
	[mod.FF.Anode.Var] = {
		Update = mod.anodeAI,
	},
	[mod.FF.Chorus.Var] = {
		--Update = mod.chorusAI,
	},
	[mod.FF.Laideronnette.Var] = {
		Update = mod.laideronnetteAI,
		Hurt = mod.laideronnetteHurt,
	},
	[mod.FF.Cubert.Var] = {
		Update = mod.cubertAI,
	},
	[mod.FF.BadBag.Var] = {
		Update = mod.badBagAI,
	},
	[mod.FF.TheColorRed.Var] = {
		Update = mod.theColorRedAI,
	},
	[mod.FF.Jugular.Var] = {
		Update = mod.jugularAI,
	},
	[mod.FF.Puffball.Var] = {
		Update = mod.puffballAI,
		--Coll = mod.puffballColl,
		--ok coll for this one doesn't work
	},
	[mod.FF.Cochlea.Var] = {
		Update = mod.cochleaAI,
	},
	[mod.FF.Shader.Var] = {
		Update = mod.shaderAI,
	},
	[mod.FF.Toad.Var] = {
		Update = mod.toadAI,
	},
	[mod.FF.Devourer.Var] = {
		Update = mod.devourerAI,
	},
	[mod.FF.Indulger.Var] = {
		Update = mod.indulgerAI,
	},
	[mod.FF.Ruiner.Var] = {
		Update = mod.ruinerAI,
		Hurt = mod.ruinerHurt,
	},
	[mod.FF.Calsiketic.Var] = {
		Update = mod.calsiketicAI,
	},
	[mod.FF.LevelPooFly.Var] = {
		Update = mod.levelPooFlyAI,
	},
	[mod.FF.Bloomer.Var] = {
		Update = mod.bloomerAI,
		Render = mod.bloomerRender,
		Coll = mod.bloomerColl,
	},
	[mod.FF.Excluder.Var] = {
		Update = mod.excluderAI,
		--Render = mod.excluderRender,
	},
	[mod.FF.Fogspawn.Var] = {
		Update = mod.fogspawnAI,
		Coll = mod.fogspawnColl,
	},
	[mod.FF.Writhe.Var] = {
		Update = mod.writheAI,
		Coll = mod.writheColl,
		Hurt = mod.writheHurt,
		Render = mod.writheRender,
	},
	[mod.FF.FreeThinker.Var] = {
		Update = mod.freeThinkerAI,
		Hurt = mod.freeThinkerMaskHurt,
	},
	[mod.FF.Meatsack.Var] = {
		Update = mod.meatsackAI,
	},
	[mod.FF.Soulmate.Var] = {
		Update = mod.soulmateAI,
		Hurt = mod.SoulmateMiteOnHurt,
	},
	[mod.FF.Soulmite.Var] = {
		Update = mod.soulmiteAI,
		Hurt = mod.SoulmateMiteOnHurt,
	},
	[mod.FF.Rabbit.Var] = {
		Update = mod.RabbitAI,
		Coll = mod.RabbitColl,
	},
	[mod.FF.Compass.Var] = {
		Update = mod.CompassAI,
	},


	--Jokes/misc
	[mod.FF.Mouse.Var] = {
		Update = mod.mouseAI,
		Hurt = mod.mouseHurt,
	},
	[mod.FF.Murasa.Var] = {
		Update = mod.murasaAI,
		Hurt = mod.murasaHurt,
	},
	[mod.FF.MurasaAnchor.Var] = {
		Update = mod.murasaAnchorAI,
	},
	[mod.FF.K3Miku.Var] = {
		Update = mod.k3MikuAI,
	},
	[mod.FF.FerrWaiting.Var] = {
		Update = mod.ferrWaiting,
	},
	[mod.FF.PeeBucket.Var] = {
		Update = mod.peeBucketAI,
		Hurt = mod.peeBucketHurt,
		Coll = mod.peeBucketCollision,
	},
	[mod.FF.BuriedFossilCrack.Var] = {
		Update = mod.buriedFossilCrackUpdate,
	},
	[mod.FF.ChummerPathfinder.Var] = {
		Update = mod.chummerPathfinderAI,
		Hurt = mod.chummerPathfinderHurt,
		Render = mod.chummerPathfinderRender,
	},
	[mod.FF.ShadyHost.Var] = {
		Update = mod.shadyHostAI,
		Hurt = mod.shadyHostHurt,
	},
	[mod.FF.MawMr.Var] = {
		Update = mod.mawMrUpdate,
		Render = mod.mawMrRender,
		Coll = mod.mawMrColl,
	},
	[mod.FF.MrPsychicMaw.Var] = {
		Update = mod.mrPsychicMawUpdate,
		Render = mod.mrPsychicMawRender,
		Coll = mod.mawMrColl,
	},
	[mod.FF.Kablammer.Var] = {
		Update = mod.kablammerAI,
	},
	[mod.FF.BendyPeashooter.Var] = {
		Update = mod.BendyPeashooterAI,
	}
}

mod.FerriumEnemies2 = {
	[mod.FF.Specturn.Var] = {
		Update = mod.specturnAI,
	},
	[mod.FF.Edema.Var] = {
		Update = mod.edemaAI,
	},
	[mod.FF.Redema.Var] = {
		Update = mod.edemaAI,
	},
}

mod.FerriumAddTrinket = {
	[mod.ITEM.ROCK.CHAIN_GEODE] = mod.setRockTable,
	[mod.ITEM.ROCK.CORAL_FOSSIL] = mod.CoralFossilOnAdd,
	[mod.ITEM.ROCK.FAKE_ROCK] = mod.FakeRockOnAdd,
	[mod.ITEM.ROCK.GAS_POCKET] = mod.setRockTable,
	[mod.ITEM.ROCK.GRAVESTONE] = mod.setRockTable,
	[mod.ITEM.ROCK.KEYSTONE] = mod.KeystoneOnAdd,
	[mod.ITEM.ROCK.POWER_ROCK] = mod.setRockTable,
	[mod.ITEM.ROCK.ROBOT_ROCK] = mod.RobotRockOnAdd,
	[mod.ITEM.ROCK.RUSTY_GEODE] = mod.RustyGeodeOnAdd,
	[mod.ITEM.ROCK.SMALLER_ROCK] = mod.setRockTable,
	[mod.ITEM.TRINKET.BOMB_TOKEN] = mod.BombTokenOnAdd,
	[mod.ITEM.ROCK.AMAZONITE] = mod.AmazoniteOnAdd,
	[mod.ITEM.ROCK.BURIED_FOSSIL] = mod.BuriedFossilOnAdd,
	[mod.ITEM.ROCK.CALZONE_GEODE] = mod.CalzoneGeodeOnAdd,
	[mod.ITEM.ROCK.ONION_ROCK] = mod.OnionRockOnAdd,
	[mod.ITEM.ROCK.SUN_SHARD] = mod.SunShardOnTrinketStuffWhatever,
}
mod.FerriumRemoveTrinket = {
	[mod.ITEM.ROCK.AMAZONITE] = mod.AmazoniteOnRemove,
	[mod.ITEM.ROCK.ACHILLES_ROCK] = mod.AchillesRockOnRemove,
	[mod.ITEM.ROCK.CALZONE_GEODE] = mod.CalzoneGeodeOnRemove,
	[mod.ITEM.ROCK.INSATIABLE_APATITE] = mod.InsatiableApatiteOnRemove,
	[mod.ITEM.ROCK.SUN_SHARD] = mod.SunShardOnTrinketStuffWhatever,
	[mod.ITEM.TRINKET.LOCKED_SHACKLE] = mod.LockedShackleOnRemove,
}

function mod.ferriumProj(v, d)
	mod.dewdropProj(v, d)
	mod.psykerProj(v, d)
	mod.scowlCreepProj(v, d)
	mod.ignisProj(v, d)
	mod.gabberProj(v, d)
	mod.murasaProj(v, d)
	mod.k3MikuProj(v, d)
	mod.psyclopiaProj(v, d)
	mod.peepisserProj(v, d)
	mod.broodProj(v, d)
	mod.dreadMawProj(v, d)
	--mod.blueMawProj(v, d)
	mod.shakerProj(v, d)
	mod.accursedProj(v, d)
	mod.warpZoneProj(v, d)
	mod.sutureShrapnelProj(v, d)
	mod.slimerProj(v, d)
	mod.ashSpawnProj(v, d)
	mod.shadyHostProj(v, d)
	mod.pointedProjectile(v, d)
	mod.coloscopeProj(v, d)
	mod.laideronnetteProj(v, d)
	mod:puffballProj(v, d)
	mod:excluderProj(v, d)
	mod:CompassProj(v, d)
	mod:DwellerSinus(v, d)
	mod:WrenchProj(v, d)

	mod.collideWithPillarProj(v, d)
	mod.customProjectileBehavior(v, d)
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_,proj1)
	local data = mod:GetEntityData(proj1)
	local proj = proj1:ToProjectile()
	mod.psyclopiaProjRemove(proj, data)
	mod.reheatedHostProj(proj, data)
	mod.laideronnetteProjRemove(proj, data)

	mod.customProjectileRemove(proj, data)
end, 9)

function mod:ferriumOnRender()
	--[[for i = 1, game:GetNumPlayers() do
		local p = Isaac.GetPlayer(i - 1)
		local d = mod:GetEntityData(p)
		local s = p:GetSprite()
		mod:extraChargeCircleRender(p, d)
		mod:StrangeEyeRender(p, d, s)
	end]]
end

function mod.ferriumPreProjectileCollision(proj, npc, bool)
	local d = mod:GetEntityData(proj)
	mod.murasaProjColl(proj, d)
	--mod.psyclopiaProjColl(proj, d, npc)
	mod.peepisserProjColl(proj, d)
	mod.chaosCardProjColl(proj, npc)

	if mod:puffballProjColl(proj, npc, bool) then
		return true
	elseif mod:DwellerSinusProjColl(proj, npc, bool) then
		return true
	elseif mod:WrenchProjColl(proj, npc, bool) then
		return true
	end
end

function mod.ferriumTear(v, d)
	mod.fractalTear(v, d)
	mod.dontHitAbove(v, d)
	mod:fiendsThirdLegGenericUpdate(v)
	mod.chubberTear(v)
	mod.pocketRocketTear(v, d)
	mod.dontHitImmediatelyTear(v, d)
	mod:shroomiteTearUpdate(v, d)
	mod:puffballTearUpdate(v, d)

	mod.customTearBehavior(v, d)
end

mod.madeEternal = {}
mod.brisketPowder = {}
mod.activeZissurus = {}
mod.sutureRockSpawns = {}
mod.angryFaicedBosses = {}
mod.ringSkuzzGroups = {}
mod.astropulvisRocks = {}
mod.colorRedDeathBurst = {}
mod.jugularRain = {}
mod.mtnDewAuras = {}
mod.toadCurseAuras = {}
mod.DidRoomSpawnReward = nil
mod.DidRoomRewardInfo = {}
mod.RabbitsToEnter = {Queue = {}, Delay = 0}

--Rock breaking
mod.roomRockTable = {}
mod.roomRockPitTable = {}
mod.chainGeodeRocks = {}
mod.chainGeodeScheduled = {}
mod.fakeRockRocks = {}
mod.fakeRockRooms = {}
mod.gravestoneRocks = {}
mod.gasPocketRocks = {}
mod.powerRockRocks = {}
mod.smallerRockRocks = {}
mod.perfectVermin = {}
mod.shampooBottleRocks = {}

function mod:refreshFerriumTables()
	mod.madeEternal = {}
	mod.brisketPowder = {}
	mod.activeZissurus = {}
	mod.chainGeodeScheduled = {}
	mod.sutureRockSpawns = {}
	mod.angryFaicedBosses = {}
	mod.ringSkuzzGroups = {}
	mod.astropulvisRocks = {}
	mod.acolyteTelInfo = nil
	mod.colorRedDeathBurst = {}
	mod.jugularRain = {}
	mod.mtnDewAuras = {}
	mod.toadCurseAuras = {}
	mod.RabbitsToEnter = {Queue = {}, Delay = 0}
end
mod:AddCallback(ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, mod.refreshFerriumTables)
--mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.refreshFerriumTables)

function mod:checkFerriumTables()
	for key, eternal in pairs(mod.madeEternal) do
        mod:madeEternalEnemies(eternal, key)
    end
	for _, brisket in pairs(mod.brisketPowder) do
		mod:spreadBrisketSeasoning(brisket)
	end
	for _, grid in pairs(mod.chainGeodeScheduled) do
		mod:chainGeodeDestroy(grid)
	end
	for _, grid in pairs(mod.sutureRockSpawns) do
		mod:sutureRockSpawn(grid)
	end
	for key, boss in pairs(mod.angryFaicedBosses) do
		mod:checkForAngryFaicDeath(boss, key)
	end
	for _, grid in pairs(mod.astropulvisRocks) do
		mod:astropulvisRockDestroy(grid)
	end
	for key,entry in pairs(mod.colorRedDeathBurst) do
		mod:colorRedDeathBurstEffect(entry, key)
	end
	for key,entry in pairs(mod.jugularRain) do
		mod:jugularRainEffect(entry, key)
	end
	for key,entry in pairs(mod.mtnDewAuras) do
		mod:mtnDewAuraUpdate(entry, key)
	end
	for key,entry in pairs(mod.toadCurseAuras) do
		mod:toadCurseAuraUpdate(entry, key)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.checkFerriumTables)

function mod:ferriumPeffectUpdate(player, data)
	mod:trinketFamiliarGameInit(player, data) --man this updating before ffsavedata does is annoying
	mod:overheadHeldActiveUpdate(player, data)

	if mod.DidRoomSpawnReward then --Fake room clear, has to trigger after rewards spawned
		--mod.DidRoomSpawnReward.SpawnedCheck, true or false if it spawned or not
		--mod.DidRoomSpawnReward.Pickup, returns a pickup if one did spawn
		mod:ComfortFoodRoomClear(player, data, mod.DidRoomSpawnReward.SpawnedCheck)
	end

	--Isaac.RunCallbackWithParam("FF_P_EFFECT_FERRIUM", _, player, data)

	--mod:grimaceRockUpdate(player, data)
	mod:playFossilSound(player, data)
	mod:firewhirlPullUpdate(player, data)
	mod:thwammyPlayerUpdate(player, data)
	mod:extraChargeCircleUpdate(player, data)
	mod:sweetRedUpdate(player, data)
	mod:HumanDomesticationGuideUpdate(player, data)
	mod:FloodedStatusUpdate(player, data)
	--mod:SpaceFoodUpdate(player, data)
	mod:ClownMeatSafety(player, data)
	mod:AberrantSunUpdate(player, data)
	mod:prismaticGeodeUpdate(player, data)
	--mod:ShadowRabbitPEffectUpdate(player, data)
	--mod:emeticAntimonyUpdate(player, data)
	--mod:ProjectileTrinketUpdate(player)
	
	mod:d122Update(player, data)
	--mod:spireGrowthUpdate(player, data)
	mod:eternalClickerUpdate(player, data)
	mod:kablammerPlayerUpdate(player, data)

	if data.HasFiredMomsKnife and not data.HasFiredMomsKnife[1]:Exists() then
		data.HasFiredMomsKnife = nil
	end

	if player:HasCurseMistEffect() and not data.FFCurseMistCheck then
		data.FFCurseMistCheck = true
		Isaac.RunCallbackWithParam("FF_CURSE_MIST_ADDED", _, player, data)
		--GOHERE
	elseif data.FFCurseMistCheck and not player:HasCurseMistEffect() then
		data.FFCurseMistCheck = nil
		Isaac.RunCallbackWithParam("FF_CURSE_MIST_CLEARED", _, player, data)
	end

	--[[for _,laser in ipairs(Isaac.FindByType(7, -1, -1, false, false)) do
		laser = laser:ToLaser()
		print(laser:GetScale())
	end]]

	--[[for _,grid in ipairs(mod.GetGridEntities()) do
		if grid:GetType() == GridEntityType.GRID_TELEPORTER then
			print(grid.State)
		end
	end]]
	
	--mod:marioMode(player)
	
	--[[local tempEffs = player:GetEffects()
	local tempEffects = player:GetEffects():GetEffectsList()
	for i=1,tempEffects.Size do
		local effect = tempEffects:Get(i-1)
		local item = effect.Item
		print(item.ID, effect.Count, effect.Cooldown)
		--print(tempEffs:GetCollectibleEffectNum(326))
	end]]
end

--[[
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
	local data = mod:GetEntityData(player)

	--Isaac.RunCallbackWithParam("FF_POST_PLAYER_UPDATE_FERRIUM", _, player, data)
	--mod:jesusRockSuperUpdate(player, data)
	--mod:ferriumPlaceBombTrigger(player)
	--mod:StrangeEyeUpdate(player, data)
end)
]]

function mod:ferriumPostPlayerRender(player, d)
	mod:friendFireballRender(player, d)
	mod:FloodedStatusRender(player, d)
	mod:extraChargeCircleRender(player, d)
end
--mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.ferriumPostPlayerRender)

function mod:ferriumPrePlayerRender(player, offset) --The player does not render when invisible/taking damage so this is needed
	mod:LaunchedEffectRender(player)
	--mod:extraChargeCircleRender(player)
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_RENDER, mod.ferriumPrePlayerRender)

function mod:ferriumOnAddItem(id, charge, firstTime, slot, varData, player)
	--mod:SpaceFoodOnAdd(player, id)
end
--mod:AddCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, mod.ferriumOnAddItem)

local hasStartedWaves
function mod:ferriumPostUpdate()
	local room = game:GetRoom()
	Isaac.RunCallbackWithParam("FF_POST_UPDATE_FERRIUM", _, room)

	mod:CheckIfRoomRewardExists()
	mod.TrashBagDipSpawns = {}
	mod:RabbitUpdate(room)
	--mod:EighteenFootLeashPoopCheck()

	if room:IsAmbushActive() then --this is delayed by ~30 frames
		if not hasStartedWaves then
			for _,marker in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, 203, -1, true, false)) do --spawn pentagrams, I don't think the enums are updated
				mod:GetEntityData(marker).FFCheckedForChallengeRoom = true
				hasStartedWaves = true
			end
		else
			local new
			for _,marker in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, 203, -1, true, false)) do
				local mData = mod:GetEntityData(marker)
				if not mData.FFCheckedForChallengeRoom == true then
					new = true
					mData.FFCheckedForChallengeRoom = true
				else
					break
				end
			end
			if new then
				mod:ferriumRoomClear(nil, nil, "Challenge")
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.ferriumPostUpdate)

function mod:ferriumPostTearRemove(tear, data)
	mod:electrumTearRemove(tear, data)

	mod.customTearRemove(tear, data)
end

function mod:ferriumPreTearCollision(tear, coll, low)
	if mod:puffballTearColl(tear, coll, low) then
		return true
	end
end

function mod:ferriumPrePlayerCollision(player, collider, low)
	mod:electrumCollision(player, collider, low)

	if mod:ClownMeatCollision(player, collider) == true then
		return true
	end
	
end

mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, function(_, player, damage, flag, source)
	local data = mod:GetEntityData(player)

	if mod:blockExplosiveTearDamage(player, damage, flag, source) == false then
		return false
	end
	if mod:ClownMeatHurt(player, flag, source) == false then
		return false
	end
	if mod:RoseQuartzTakeDamage(player, source) == false then
		return false
	end
end)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, damage, flag, source)
	local player = ent:ToPlayer()
	local data = mod:GetEntityData(player)

	mod:fishFossilDamage(player)
	mod:cannedFossilDamage(player)
	mod:tintedHeartDamage(player, damage, flag, source)
	mod:sandstoneDamage(player, damage, flag, source)
	mod:bloodstoneDamage(player)
	mod:rebellionRockDamage(player, damage, flag, source)
	mod:smokyQuartzHurt(player)
	mod:pureQuartzHurt(player, damage, flag)
	mod:gravestoneHurt(player, damage, flag)
	mod:shamrockHurt(player, flag, source)
	mod:soapStoneHurt(player)
	mod:swallowedGeodeHurt(player)
	mod:umbilicalGeodeHurt(player)
	mod:warfarinHurt(player, damage, flag, source)
	mod:shampooBottlePlayerHurt(player, damage, flag, source)
	mod:SproutingSeedHurt(player)
	mod:HellviteHurt(player, damage, flag, source)
	mod:StainedCardHurt(player, damage, flag, source)
	
	if mod:heavyMetalHurt(player, flag, source) == false then
		return false
	end
	if not (data.MaliceMinion or data.MaliceHidden) and mod:sandCastleHurt(player, flag, source) == false then
		return false
	end
	if mod:guardedGarnetHurt(player, flag, source) == false then
		return false
	end
	if mod:elephantFossilHurt(player, damage, flag, source) == false then
		return false
	end
	if mod:steadfastStoneHurt(player, damage) == false then
		return false
	end

	mod:InternalizedHatredDamage(player, damage, flag, source)
end, 1)

function mod:goAwayEffect(e, anim)
	local sprite = e:GetSprite()
	if sprite:IsFinished(anim) then
		e:Remove()
	end
end

function mod:ferriumPlayerOnNewRoom()
	local room = game:GetRoom()
	local level = game:GetLevel()
	mod.scheduleForUpdate(function()
		mod.setRockTable()
	end, 1)
	mod.DidRoomSpawnReward = nil
	mod.DidRoomRewardInfo = {}
	hasStartedWaves = nil
	local notDoneWaiting = false

	mod:RabbitNewRoom(room) --This one activates before cause of shadow rabbits

	for i = 1, game:GetNumPlayers() do
		local player = Isaac.GetPlayer(i-1)
		local data = mod:GetEntityData(player)
		--the oily torment machine
		local invalid = true
		if not invalid and not notDoneWaiting and not game:GetRoom():IsClear() then
			notDoneWaiting = true
			if invalid then
				local ch1 = {{151, 0, 1}, {151, 1, 1}, {150, 16, 12}, {150, 16, 1}, {150, 16, 3}, {150, 16, 3}, {150, 16, 4}, {150, 16, 9}, {150, 16, 3}, {450, 23, 1}, {450, 24, 1}, 
				{150, 10, 6}, {150, 10, 0}, {150, 10, 1}, {150, 10, 2}, {150, 10, 3}, {150, 10, 4}, {150, 10, 5}, }
				mod.scheduleForUpdate(function()
					local testNPC = Isaac.Spawn(mod.FF.ChummerPathfinder.ID, mod.FF.ChummerPathfinder.Var, 0, player.Position, Vector.Zero, nil):ToNPC()
					testNPC.Visible = false
					testNPC:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					testNPC.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
					testNPC:AddEntityFlags(EntityFlag.FLAG_NO_REWARD)
					for j=1,2 do
						local id = ch1[placeHolderRNG:RandomInt(#ch1)+1]
						local pos = mod:FindRandomValidPathPosition(testNPC)
						local npc = Isaac.Spawn(id[1], id[2], id[3], pos, Vector.Zero, nil)
						npc:Update()
					end
					testNPC:Remove()
				end, 1)
			end
		end

		mod:GunNewRoom(player, data)
		mod:BriendNewRoom(player, data) -- hi -cat
		
		data.hangmanPositions = nil
		if data.overheadActiveItemID and data.overheadActiveItemID == CollectibleType.COLLECTIBLE_NOTCHED_AXE then
		else
			data.overheadActiveItem = nil
			data.overheadActiveItemID = nil
		end
		if data.belialD122 then
			data.belialD122 = nil
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
   			player:EvaluateItems()
		end
		data.UsingInfuser = nil

		Isaac.RunCallbackWithParam("FF_NEW_ROOM_PLAYER_FERRIUM", _, player, data, room, level)
		mod:electrumNewRoom(player, data)
		mod:lockedShackleNewRoom(player, data)
		mod:theShampooBottleNewRoom(player, data)
		mod:HumanDomesticationGuideNewRoom(player, data)
		mod:ChaoticCarvingNewRoom(player, data)
		mod:PinkCowNewRoom(player, data)
		mod:EighteenFootLeashNewRoom(player, data)
		mod:BulletHellItemNewRoom(player, data)
		mod:BonusPenniesNewRoom(player, data, room)
		mod:QueensFruitNewRoom(player, data)
		mod:ShadowRabbitsNewRoom(player, data)
	end
	mod:angryFaicNewRoom()
	mod:buriedFossilNewRoom()
	mod:maxFossilNewRoom()
	mod:moonstoneNewRoom()
	mod:rockFromAnAbyssNewRoom()
	mod:shardOfGolgothaNewRoom()
	mod:skuzzFossilNewRoom()
	mod:fistfulOfAshNewRoom()
	mod.lithopedianNewRoom()
	mod:onionRockNewRoom()
	mod:ProjectileTrinketNewRoom()
	--mod:EighteenFootLeashGridNewRoom()
	mod:BulletHellNewRoom()
	mod:RaildriverNewRoom(room)
	mod:AsteroidBeltNewRoom()
	mod:InfuserNewRoom()
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.ferriumPlayerOnNewRoom)

mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, function(_, player, id, first)
	local trueID = mod:GetRealTrinketId(id)
	if mod.FerriumAddTrinket[trueID] then
		mod.FerriumAddTrinket[trueID](_, player, first, id)
	end
end)
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, function(_, player, id)
	local trueID = mod:GetRealTrinketId(id)
	if mod.FerriumRemoveTrinket[trueID] then
		mod.FerriumRemoveTrinket[trueID](_, player, id)
	end
end)

function mod:ferriumPlayerOnNewLevel()
	local room = game:GetRoom()
	local level = game:GetLevel()
	mod:amazoniteNewLevelGeneric()
	for i = 1, game:GetNumPlayers() do
		local player = Isaac.GetPlayer(i - 1)
		local data = mod:GetEntityData(player)
		Isaac.RunCallbackWithParam("FF_NEW_LEVEL_PLAYER_FERRIUM", _, player, data, room, level)
		mod:fakeRockNewLevel(player, data)
		mod:spellsNewLevel(player, data)
		mod:vinylGeodeNewLevel(player, data, room, level)
		mod:amazoniteNewLevel(player, data, room)
	end
	Isaac.RunCallbackWithParam("FF_NEW_LEVEL_FERRIUM")
	mod:buriedFossilNewLevel()
	mod:bedsheetNewLevelGeneric()
	mod:onionRockNewLevel()
	--mod:EighteenFootLeashNewLevel()
	mod.RaildriverRails = {}
	mod:DarkBargainNewLevel(room, level)
	mod.savedata.run.BlackCandelabraActivatedThisFloor = nil
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.ferriumPlayerOnNewLevel)

function mod:ferriumPreRoomExit(player, newLevel)
	if not newLevel then --Doesn't work for exiting game or new level
		mod:DarkBargainPreRoomExit()
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_ROOM_EXIT, mod.ferriumPreRoomExit)

function mod:ferriumPlayerOnNewLevelEarly()
	for i = 1, game:GetNumPlayers() do
		local player = Isaac.GetPlayer(i - 1)
		mod:StitchedCardNewLevel(player)
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_LEVEL, CallbackPriority.EARLY, mod.ferriumPlayerOnNewLevelEarly)

function mod:GenericRockBreakCheck(grid, type, immediate) --Break Rock triggers
	for i = 1, game:GetNumPlayers() do
		local player = Isaac.GetPlayer(i - 1)
		local d = mod:GetEntityData(player)
		mod:FishRockBreakRock(player, grid)
		mod:HammerHeadBreakRock(player, grid, d)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GRID_ROCK_DESTROY, mod.GenericRockBreakCheck)

function mod:ferriumRoomClear(posRNG, spawnPos, waves) --posRNG does not exist!!
	waves = waves or nil
	--if not waves and game:IsGreedMode() then return end

	for i = 1, game:GetNumPlayers() do
		local player = Isaac.GetPlayer(i - 1)
		local data = mod:GetEntityData(player)

		mod:aaaGeodeRoomClear(player, data, waves)
		mod:AsteroidBeltRoomClear(player, data, waves)
		mod:HumanDomesticationGuideRoomClear(player, data)
		mod:SmallBandaidRoomClear(player, data)
		mod:DingleBerryFFRoomClear(player, waves)
		mod:DireBondRoomClear(player, data)

		if not waves then --Does not trigger when clearing Challenge Rooms or Greed Waves
		end
	end
	Isaac.RunCallbackWithParam("FF_ROOM_CLEAR_FERRIUM", _, waves)
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, CallbackPriority.EARLY, mod.ferriumRoomClear)
mod:AddCallback(mod.CALLBACK.FF_POST_START_GREED_WAVE, function()
	mod:ferriumRoomClear(nil, nil, "Greed")
end)

function mod:ferriumPlayerInit(player, data, continue)
	if continue then
		mod:HumanDomesticationGuideFloretCheck(player, data)
	end
end

function mod:ferriumOnGrind(player, grinder, grinderData, trinket, price)
	mod:moltenSlagOnGrind(player, grinder, grinderData)
	mod:doubleRubbleOnGrind(trinket, grinderData, player)
	mod:rockCakeOnGrind(player)
	mod:azeriteOnGrind(player)
	mod:gravelOnGrind(player)
	mod:FulguriteOnGrind(player, trinket)
end

function mod:ferriumOnFireTear(player, tear, secondHandMultiplier, isLudo, ignorePlayerEffects)
	mod:fragmentedOnyxOnFireTear(player, tear, secondHandMultiplier)
	mod:trippyFossilOnFireTear(player, tear, secondHandMultiplier)
	mod:charcoalOnFireTear(player, tear)
	mod:EraserTwoOnFireTear(player, tear)
	mod:CacepiOnFireTear(player, tear)
end

function mod:ferriumOnFireLaser(player, laser)
	mod:emeticAntimonyOnFireLaser(player, laser)
end

function mod:ferriumOnFireBomb(player, bomb, secondHandMultiplier)
	mod:fragmentedOnyxOnFireBomb(player, bomb, secondHandMultiplier)
	mod:trippyFossilOnFireBomb(player, bomb, secondHandMultiplier)
end

function mod:ferriumPostBombUpdate(bomb, data)
	mod:fiendsThirdLegGenericUpdate(bomb)
end

function mod:ferriumOnKnifeDamage(player, ent, secondHandMultiplier, currDamage)
	mod:fragmentedOnyxOnKnifeDamage(player, ent, secondHandMultiplier)
	mod:trippyFossilOnKnifeDamage(player, ent, secondHandMultiplier)
end

function mod:ferriumOnFireRocket(player, target, secondHandMultiplier)
	mod:fragmentedOnyxOnFireRocket(player, target, secondHandMultiplier)
	mod:trippyFossilOnFireRocket(player, target, secondHandMultiplier)
end

function mod:ferriumOnLaserDamage(player, ent, secondHandMultiplier, currDamage)
	mod:fragmentedOnyxOnLaserDamage(player, ent, secondHandMultiplier)
	mod:robotRockOnLaserDamage(player, ent, secondHandMultiplier)
	mod:trippyFossilOnLaserDamage(player, ent, secondHandMultiplier)
end

function mod:ferriumOnFireAquarius(player, creep, secondHandMultiplier)
	mod:fragmentedOnyxOnFireAquarius(player, creep, secondHandMultiplier)
	mod:trippyFossilOnFireAquarius(player, creep, secondHandMultiplier)
end

function mod:ferriumOnDarkArtsDamage(player, ent, secondHandMultiplier)
	mod:fragmentedOnyxOnDarkArtsDamage(player, ent, secondHandMultiplier)
	mod:trippyFossilOnDarkArtsDamage(player, ent, secondHandMultiplier)
end

function mod:FerriumGlobalUseItem(item, rng, player, useFlags, activeSlot, var)
	local data = mod:GetEntityData(player)
	mod:overheadHeldActive(item, rng, player, useFlags, activeSlot)
	mod:electrumUseActive(item, rng, player, activeSlot)
	if not mod.OverheadHeldActives[item] then
		mod:NonagonGeodeUseActive(item, rng, player, activeSlot)
		mod:LooseFilamentUseActive(item, rng, player, activeSlot)
		mod:EfficiencyModuleUseActive(item, rng, player, useFlags, activeSlot)
		mod:ProductivityModuleUseActive(item, rng, player, useFlags, activeSlot)
		mod:SpeedModuleUseActive(item, rng, player, useFlags, activeSlot, data)
	end
end

function mod:FerriumGlobalThrownActive(item, rng, player, useFlags, activeSlot)
	local data = mod:GetEntityData(player)
	mod:NonagonGeodeUseActive(item, rng, player, activeSlot)
	mod:LooseFilamentUseActive(item, rng, player, activeSlot)
	mod:EfficiencyModuleUseActive(item, rng, player, useFlags, activeSlot)
	--Productivity Module is weird with these
	mod:SpeedModuleUseActive(item, rng, player, useFlags, activeSlot, data)
end

function mod:ferriumGenericNPCUpdate(npc, data)
	--Isaac.RunCallbackWithParam("FF_GENERIC_NPC_UPDATE_FERRIUM", _, npc, data)

	mod:electrumNPCUpdate(npc, data) --Some other stuff uses the electrumDeath thing so dont put it into the callback stuff
	mod:cochleaDeathEffectUpdate(npc, data)
	--mod:SpiritOfNightmareUpdates(npc, data)

	--[[if npc.FrameCount % 30 == 0 then
		for i=1,8 do
			Isaac.Spawn(1000, 12, 0, npc.Position+Vector(0,180):Rotated(i*45), Vector.Zero, npc)
		end
	end]]
end

--[[function mod:ferriumGenericNPCInit(npc)
	for i = 1, game:GetNumPlayers() do
		local player = Isaac.GetPlayer(i - 1)
		mod:CatnipNPCInit(npc, player)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.ferriumGenericNPCInit)]]

--[[function mod:ferriumGenericEffectInit(effect)
	for i = 1, game:GetNumPlayers() do
		local player = Isaac.GetPlayer(i - 1)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.ferriumGenericEffectInit)]]

--[[function mod:ferriumProjInit(proj)
	for i = 1, game:GetNumPlayers() do
		local player = Isaac.GetPlayer(i - 1)
		mod:CatnipProjInit(proj, player)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_INIT, mod.ferriumProjInit)]]

function mod:ferriumGenericPlayerDamage(ent, damage, flags, source, sourceData)
	if ent and ent:ToNPC() then
		local npc = ent:ToNPC()
		local d = mod:GetEntityData(npc)
		mod:TriangleGemDamage(npc, flags, source, d)
	end
end

function mod:ferriumGenericEverythingDamage(ent, damage, flags, source, sourceData)
	if ent and ent:ToNPC() then
		local npc = ent:ToNPC()
		local d = mod:GetEntityData(npc)
		mod:ExecutionerEntDamage(npc, d, damage)
	end
end

function mod:ferriumGenericMiscDamage(ent, damage, flags, source, sourceData)
	local returnData = {}
	local tempReturnData = {newDamage = damage}
	if ent and ent:ToNPC() then
		local npc = ent:ToNPC()
		mod:ChemicalCookieEntDamage(npc, tempReturnData, flags, source, sourceData)
	end

	if tempReturnData.sendNewDamage then
		returnData = mod:makeCopiedTable(tempReturnData)
	end
	return returnData
end

--[[function mod:ferriumGenericNPCRender(npc, data)
	mod:LaunchedEnemyRender(npc, data)
	--mod:electrumRender(npc, data)
end]]

function mod:ferriumWisps(wisp)
	if wisp.SubType == FiendFolio.ITEM.COLLECTIBLE.CHERRY_BOMB then
		mod:cherryBombWisp(wisp)
	elseif wisp.SubType == mod.ITEM.COLLECTIBLE.HUMAN_DOMESTICATION_GUIDE then
		mod:HumanDomesticationGuideWisp(wisp)
	end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.ferriumWisps, FamiliarVariant.WISP)

function mod:ferriumTrinketUpdate(trinket)
	local d = mod:GetEntityData(trinket)

	if d.BlockPickup then
		d.BlockPickup = (d.BlockPickup > 0 and d.BlockPickup-1) or nil
	end

	mod:dadsLegendaryGoldenRockUpdate(trinket)
	mod:dogrockRockTrinketUpdate(trinket, d)
	mod:fractalGeodeTrinketUpdate(trinket)
	mod:grimlinTrinketUpdate(trinket, d)
	mod:sandDollarTrinketUpdate(trinket, d)
	mod:homoeroticRubyTrinketUpdate(trinket, d)
	mod:theShampooBottleTrinketUpdate(trinket, d)
	mod:SproutingSeedTrinketUpdate(trinket, d)
	mod:ProjectileTrinketTrinketUpdate(trinket, d)
	mod:DelightfulDrumstickTrinketUpdate(trinket, d)
	mod:DogPennyTrinketUpdate(trinket)
	mod:MirrorSlateTrinketUpdate(trinket, d)
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.ferriumTrinketUpdate, 350)

function mod:ferriumTrinketInit(trinket)
	mod:DelightfulDrumstickTrinketInit(trinket)
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.ferriumTrinketInit, 350)

function mod:ferriumTrinketColl(trinket, coll, low)
	if mod:ProjectileTrinketColl(trinket, coll) == true then
		return true
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.ferriumTrinketColl, 350)

function mod:ferriumFamiliarCache(player, data)
	mod:lithopedianFamiliar(player)
	mod:fetalStoneFamiliar(player)
	mod:starSapphireFamiliar(player)
	mod:tigersEyeFamiliar(player)
	mod:sunShardFamiliar(player)
	mod:onionRockFamiliar(player)
	mod:AsteroidBeltCache(player)
	mod:LooseFilamentCache(player)
	mod:HingeCache(player, data)
end

function mod:ferriumOnDoubleTap(player, data, sdata)
	mod:asteroidBeltDoubleTap(player, sdata)
end

function mod:FerriumOnPressFire(player, IsFiring, ButtonAction, Mouse)
	mod:onionRockFire(player, IsFiring)
	if IsFiring then
		mod:RaildriverFire(player)
	end
end

--function mod:ferriumBombInit(player, bomb)
--	mod:ferriumPlacedBombCheck(player, bomb)
--end

function mod:FerriumPostNPCDeath(npc)
	local data = mod:GetEntityData(npc)
	for i = 1, game:GetNumPlayers() do
		local player = Isaac.GetPlayer(i - 1)
		local d = mod:GetEntityData(player)
		mod:HellviteDeathCheck(npc, player)
	end
	Isaac.RunCallbackWithParam("FF_POST_NPC_DEATH_FERRIUM", _, npc, data)
	--mod:HuitlacocheDeathCheck(npc)
	mod:HauntedHouseDeathCheck(npc, data)
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.FerriumPostNPCDeath)

--Checks Membrain/Mama Guts alts
function mod:checkMembrain(npc)
	if npc.Variant == 114 then -- Cellulitis
		mod:cellulitisAI(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkMembrain, 57)

--Checks Attack Fly alts
function mod:checkAttackFlyEnemy(npc)
	if npc.Variant == 114 then -- Custom Moter
		mod:customMoterAI(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkAttackFlyEnemy, 18)

--Singe's Balls
function mod:checkSingeBalls(npc)
	if npc.Variant == 1 then
		mod:singeBallsAI(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkSingeBalls, EntityType.ENTITY_SINGE)

--[[function mod:singeBallRender(npc)
	if npc.Variant == 1 then
		mod:singeBallRenderGritty(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.singeBallRender, EntityType.ENTITY_SINGE)]]--

--Sub Horfs
function mod:checkSubHorfs(npc)
	if npc.Variant == 0 and npc.SubType == mod.FF.Floaty.Sub then -- Floaty
		mod:floatyAI(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkSubHorfs, 812)

--Knights
function mod:checkKnights(npc)
	if npc.Variant == mod.FF.PsychoKnight.Var then -- PsychoKnight
		mod:psychoKnightAI(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkKnights, 41)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
	local data = FiendFolio.savedata.run
	data.invisibleDecor = {}
	data.currentRoomTempRock = {}
	data.perfectVerminRocks = {}
end)

--[[mod:AddCallback(ModCallbacks.MC_INPUT_ACTION, function(_, entity, hook, buttonAction)
    local game = Game()
	if buttonAction ~= ButtonAction.ACTION_DROP then return end

    if hook ~= InputHook.IS_ACTION_TRIGGERED or game:IsPaused() then return end

    local player = entity and entity:ToPlayer()
    if not player then return end
	
	local controllerIndex = player.ControllerIndex
    local isDropping = Input.IsActionTriggered(buttonAction, controllerIndex)

    if not isDropping then return end
	
	local data = mod:GetEntityData(player)
	if not data.animatedTimes then
		data.animatedTimes = 0
	end
	data.animatedTimes = data.animatedTimes+1
	if data.animatedTimes > 10 then
		player:SetColor(Color(1,1,1,0,0,0,0), 999, 999, false, false)
		Isaac.Explode(player.Position, player, 0)
		for i=1,20 do
			Isaac.Spawn(1000, 5, 0, player.Position, RandomVector()*math.random(1,15), nil)
		end
		for i=1,5 do
			local smoke = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, 0, player.Position, RandomVector()*math.random(1,5), nil):ToEffect()
			smoke.Color = Color(158/255, 11/255, 15/255, 67/255, 0, 0, 0)
			smoke:SetTimeout(50 + math.random(15))
			smoke:Update()
		end
		player:Kill()
	end
	player:AnimateHappy()
end)]]

--[[mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, damage, flag, source)
	local player
	if source.Entity then
		player = source.Entity:ToPlayer()
	end
	if player then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MARS) then
			local tempEffects = player:GetEffects()
			if tempEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_MARS) then
				local dir = (player.Velocity*0.6):Rotated(math.random(-20,20))
				local proj = mod:turnEntitytoProjectile(player, ent, dir, false, nil, nil, nil, nil, nil, function(e,p) local spawn = Isaac.Spawn(e.Type, e.Variant, e.SubType, room:GetGridPosition(room:GetGridIndex(p.Position)), Vector.Zero, p) spawn:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM) spawn:Kill() end)
				if proj then
					proj.FallingSpeed = -math.random(5,10)
					proj.FallingAcceleration = 0.95
					SFXManager():Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 0.4, 0, false, 1.7)
				end
			end
		end
	end
end)]]

function mod:check114Hurt(npc, damage, flag, source)
	if mod.FerriumEnemies[npc.Variant] and mod.FerriumEnemies[npc.Variant].Hurt then
		return mod.FerriumEnemies[npc.Variant].Hurt(_,npc, damage, flag, source)
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.check114Hurt, mod.FFID.Ferrium)

function mod:check114Kill(npc)
    if mod.FerriumEnemies[npc.Variant] and mod.FerriumEnemies[npc.Variant].Kill then
		mod.FerriumEnemies[npc.Variant].Kill(_,npc, npc.Variant)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.check114Kill, mod.FFID.Ferrium)

function mod:check114Death(npc)
	if mod.FerriumEnemies[npc.Variant] and mod.FerriumEnemies[npc.Variant].Death then
		mod.FerriumEnemies[npc.Variant].Death(_,npc, npc.Variant)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.check114Death, mod.FFID.Ferrium)

function mod:check114(npc)
	if mod.FerriumEnemies[npc.Variant] and mod.FerriumEnemies[npc.Variant].Update then
		mod.FerriumEnemies[npc.Variant].Update(_, npc, npc.SubType, npc.Variant)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.check114, mod.FFID.Ferrium)

function mod:check114Collision(npc, collider, bool)
	if mod.FerriumEnemies[npc.Variant] and mod.FerriumEnemies[npc.Variant].Coll then
		return mod.FerriumEnemies[npc.Variant].Coll(_, npc, collider, bool)
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, mod.check114Collision, mod.FFID.Ferrium)

function mod:check114Render(npc, offset)
	if mod.FerriumEnemies[npc.Variant] and mod.FerriumEnemies[npc.Variant].Render then
		return mod.FerriumEnemies[npc.Variant].Render(_, npc, offset)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.check114Render, mod.FFID.Ferrium)


function mod:check115Hurt(npc, damage, flag, source)
	if mod.FerriumEnemies2[npc.Variant] and mod.FerriumEnemies2[npc.Variant].Hurt then
		return mod.FerriumEnemies2[npc.Variant].Hurt(_,npc, damage, flag, source)
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.check115Hurt, mod.FFID.Ferrium2)

function mod:check115Kill(npc)
    if mod.FerriumEnemies2[npc.Variant] and mod.FerriumEnemies2[npc.Variant].Kill then
		mod.FerriumEnemies2[npc.Variant].Kill(_,npc, npc.Variant)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.check115Kill, mod.FFID.Ferrium2)

function mod:check115Death(npc)
	if mod.FerriumEnemies2[npc.Variant] and mod.FerriumEnemies2[npc.Variant].Death then
		mod.FerriumEnemies2[npc.Variant].Death(_,npc, npc.Variant)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.check115Death, mod.FFID.Ferrium2)

function mod:check115(npc)
	if mod.FerriumEnemies2[npc.Variant] and mod.FerriumEnemies2[npc.Variant].Update then
		mod.FerriumEnemies2[npc.Variant].Update(_, npc, npc.SubType, npc.Variant)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.check115, mod.FFID.Ferrium2)

function mod:check115Collision(npc, collider, bool)
	if mod.FerriumEnemies2[npc.Variant] and mod.FerriumEnemies2[npc.Variant].Coll then
		return mod.FerriumEnemies2[npc.Variant].Coll(_, npc, collider, bool)
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, mod.check115Collision, mod.FFID.Ferrium2)

function mod:check115Render(npc, offset)
	if mod.FerriumEnemies2[npc.Variant] and mod.FerriumEnemies2[npc.Variant].Render then
		return mod.FerriumEnemies2[npc.Variant].Render(_, npc, offset)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.check115Render, mod.FFID.Ferrium2)


function mod:checkEffect1750(npc)
	if mod.FerriumEffects[npc.SubType] and mod.FerriumEffects[npc.SubType].Update then
		mod.FerriumEffects[npc.SubType].Update(_, npc, npc.SubType, npc.Variant)
	end
	
	if mod.FerriumEffects[npc.SubType] and mod.FerriumEffects[npc.SubType].Disappear then
		mod:goAwayEffect(npc, mod.FerriumEffects[npc.SubType].Disappear)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.checkEffect1750, 1750)

function mod:checkEffectInit1750(effect)
	if mod.FerriumEffects[effect.SubType] and mod.FerriumEffects[effect.SubType].Init then
		mod.FerriumEffects[effect.SubType].Init(_, effect)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.checkEffectInit1750, 1750)

local blacklist = {[7] = true,[66] = true,[87] = true,[12] = true,[15] = true,[21] = true, [12548] = true, [68] = true, [33] = true, [121] = true, [5] = true, [64] = true, [41] = true}
local blacklistTemp = {[141] = true, [46] = true, [450] = true, [133] = true}
function mod:printEffects(npc)
	local sprite = npc:GetSprite()
	local d = mod:GetEntityData(npc)
	--fuck off decoration insects
	if blacklist[npc.Variant] == true or blacklistTemp[npc.Variant] == true then
	else
		--print(npc.Timeout)

		--[[if not d.checked then
			print("hi, " .. npc.Variant, npc.SubType)
			d.checked = true
		end]]
	end
	--mod:PrintColor(npc:GetColor())
	--print(npc:GetSprite():GetFilename())
	if npc.TargetPosition then
		--print(npc.TargetPosition.X)
		--print(npc.Color)
	end
	--print(npc.Color)
	--print(npc.Parent)

end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.printEffects, 16)

mod.FerriumTempColor = Color(1, 1, 1, 1, 0, 0, 0)
FiendFolio.FerriumTestFunc = function(player) end
function mod:ferriumPressButtonLogic(player, ci)
	mod:CheckForMouseGun(player, ci)
	if mod.AnyKeyboardTriggered(Keyboard.KEY_K, ci) then
		mod:GetEntityData(player).DisplayingStrangeEyeMenu = nil
	end
	--DEBUG KEY PRESS
	if mod.AnyKeyboardTriggered(Keyboard.KEY_L, ci) then
		local room = game:GetRoom()
		local d = mod:GetEntityData(player)

		mod.FerriumTestFunc(player)


		--[[local order = CustomHealthAPI.Library.GetHealthInOrder(player, false)
		for key1,entry1 in pairs(order) do
			print("LAYER 1: ", key1, entry1)
			for key,entry in pairs(entry1) do
				print("LAYER 2: ", key, entry)
				for realKey,realEntry in pairs(entry) do
					print(realKey, realEntry)
				end
			end
		end]]

		--[[local heart = Isaac.Spawn(5, 10, 1, Vector(200, 200), Vector.Zero, player):ToPickup()
		mod:GetEntityData(heart).warfarinHeart = {player = player, damage = player.Damage}
		heart.Timeout = 40]]

		--[[local sapph = Isaac.Spawn(5, 350, mod.ITEM.ROCK.SAPPHIC_SAPPHIRE, room:GetCenterPos()+Vector(-80,-80), Vector.Zero, nil)
		local rub = Isaac.Spawn(5, 350, mod.ITEM.ROCK.HOMOEROTIC_RUBY, room:GetCenterPos()+Vector(80,80), Vector.Zero, nil)
		player:AddCacheFlags(CacheFlag.CACHE_ALL)
		player:EvaluateItems()]]
	end
end

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, coll)
	if coll:ToPlayer() and mod:GetEntityData(pickup).DarkBargainedMovement then
		local player = coll:ToPlayer()
		if player:IsExtraAnimationFinished() then
			mod:GetEntityData(player).ffsavedata.RunEffects.DarkBargainInfo = nil
		else
			return true
		end
	end
end, PickupVariant.PICKUP_COLLECTIBLE)