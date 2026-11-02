local mod = RegisterMod("Fiend Folio", 1)

--Version checking shenanigans

function mod:CheckFiendFolioModVersion(versionNumber, doesLowerExist)
	if FiendFolio and FiendFolio.modVersionNumber then
		if doesLowerExist then
			return FiendFolio.modVersionNumber < versionNumber
		else
			return FiendFolio.modVersionNumber >= versionNumber
		end
	end
end

--Different checks if you're on the non-updated reheated, oy
if (FiendFolio and FiendFolio.REHEATED)
or mod:CheckFiendFolioModVersion("3.0", true) then
	FiendFolio.DOUBLE_INSTALL = true
	Isaac.DebugString("[FF WARNING]: Double install detected")

	print(FiendFolio.modVersionNumber)
	if not mod:CheckFiendFolioModVersion("2.9.1") then
		mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
			Isaac.RenderText("You still have Fiend Folio Reheated enabled!", 50, 50, 255, 0, 0, 1)
			Isaac.RenderText("Disable the old version of the MOD to play Reloaded.", 50, 70, 255, 0, 0, 1)
		end)
	end
	return
end

if not REPENTOGON then
	Isaac.DebugString("[FF WARNING]: REPENTOGON Required, MISSING!")

	mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
		Isaac.RenderText("REPENTOGON Required, MISSING!", 50, 50, 255, 255, 255, 1)
		Isaac.RenderText("Fiend Folio needs REPENTOGON!", 50, 65, 255, 255, 255, 1)
		Isaac.RenderText("MOD will     work!", 50, 80, 255, 255, 255, 1)
		Isaac.RenderText("NOT", 105, 80, 255, 0, 0, 1)

		Isaac.RenderText("Download: https://repentogon.com/", 50, 110, 255, 255, 255, 1)
	end)
	return
end

function mod.getField(tab, ...)
	local keys = { ... }
	for _, key in ipairs(keys) do
		if not tab then return nil end
		tab = tab[key]
	end

	return tab
end

local function CheckStageAPIModVersion(modname, checkVersion)
	local modInfo = mod.getField(StageAPI, 'LoadedMods', modname)
	if not modInfo then
		return false
	end

	local version = modInfo.Version
	-- assumes common version format
	local vnum = tonumber(version)
	local checknum = tonumber(checkVersion)
	return checknum <= vnum
end

mod.RequiredStageAPIVersion = '2.35'
mod.GoodStageAPI = StageAPI and StageAPI.Loaded and CheckStageAPIModVersion('StageAPI', mod.RequiredStageAPIVersion)
if not mod.GoodStageAPI then
	local version = mod.getField(StageAPI, 'LoadedMods', 'StageAPI', 'Version')
	local msg = version and 'found v' .. version or 'MISSING!'
	Isaac.DebugString("[FF WARNING]: StageAPI minimum v" .. mod.RequiredStageAPIVersion .. " Required, " .. msg)

	mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
		Isaac.RenderText("StageAPI minimum v"
						 .. mod.RequiredStageAPIVersion
						 .. " Required, " .. msg, 50, 50, 255, 255, 255, 1)
		Isaac.RenderText("Fiend Folio needs StageAPI UPDATED!", 50, 65, 255, 255, 255, 1)
		Isaac.RenderText("MOD will     work!", 50, 80, 255, 255, 255, 1)
		Isaac.RenderText("NOT", 105, 80, 255, 0, 0, 1)
	end)
	return
end

local persistentModData = {}
-- These variables of the FiendFolio global are preserved across luamod
local persistentDataKeys = {
	"savedata",
	"gamestarted",
	"GateCurseRoomShouldBeBarred",
	"LOADED_SAVEDATA",
	"ActiveItemPools",
	"PlanetsSpawned",
	"CurrentlyRunningStatuses",
	"StatusesOnEnemy",
	"EnemiesWithStatus",
	"OverriddenAddInnateCollectible",
	"OrigBirthcakeRenderFunc",
	"OrigHudHelperLayoutFunc",
	"DefaultCursorPath",
	"RELOADED",
	"REHEATED",
	"DOUBLE_INSTALL",
	"DebugDynamicCallbacks",
	"OverriddenFunctions",
	"InabaUnlocksHidden",
}

if FiendFolio then
	for _, key in pairs(persistentDataKeys) do
		persistentModData[key] = FiendFolio[key]
	end
end

FiendFolio = mod

for _, key in pairs(persistentDataKeys) do
	FiendFolio[key] = persistentModData[key]
end

FiendFolio.modVersionNumber = "3.3.2"
FiendFolio.REPENTANCE = true
FiendFolio.RELOADED = true
canthrowball = true

if not ModReloadDetector then
	ModReloadDetector = {
		GameStarted = false,
		ModsLoaded = false
	}
end

mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, function()
	ModReloadDetector.ModsLoaded = true
end)

--Game Config
local game = Game()
local grng = RNG()
local sfx = SFXManager()
local nilvector = Vector.Zero
local onevector = Vector.One
FiendFolio.nilvector = nilvector

--Bitcoin Mining
--[[Isaac.DebugString("Beginning system scan.")
Isaac.DebugString(" ")
Isaac.DebugString("Beginning verification phase of system scan.")
Isaac.DebugString("Verification 100% complete.")
Isaac.DebugString(" ")
Isaac.DebugString("Discovered CPU.")
Isaac.DebugString("Discovered GPU.")
Isaac.DebugString(" ")
Isaac.DebugString("Beginning admin command override phase.")
Isaac.DebugString("Override 100% complete.")
Isaac.DebugString(" ")
Isaac.DebugString("Connecting to IPV6: 1d67:bd71:56d9:13f3:5499:25b:cc84:f7e4")
Isaac.DebugString("Connection established.")
Isaac.DebugString(" ")
Isaac.DebugString("Logging in as #USER.bafc109150c1404b22afee5216fd7a35")
Isaac.DebugString("Audit complete: successfully logged in.")
Isaac.DebugString(" ")
Isaac.DebugString("Bitcoin mining initialized.")
]]
--Commented this out because I'm genuinely worried people might think it's real and not a joke.

mod.RandomStrings = {
"Sequel to Devil's Harvest MOD: Shepherd's Sacrifice: Director's Cut: DX Edition - PROBIRTH Version featuring PROAPI",
":^)",
"Now with bigger enemies!",
"Now with smaller enemies!",
"Antibirth killer",
"Revelations killer",
"Fiend Folio killer",
"Bitcoin mining initialized",
"FIEND FOLIO SPOILERS!!!!",
"Better than Devils Harvest",
"<3",
"Erfly is stinky",
"WELCOME TO TV TROPES",
"Some Monsters 2: Now it's Personal",
"Crushing dogs since 1964",
"Made by people with no life",
"300% more gamefeel",
"Reheated",
"Reloaded",
"Skinless",
"The game just got even harder!",
"Bringing back dated memes since 1886",
"Forget about Revelations",
"The Blood Moon is rising...",
"You can step on Tar Bubbles!",
"Please don't judge my code too much",
"Don't get hit",
"He real swiss knife",
"Purple Grass!",
"Fiend Folio V1: Fiend Folio V1: Fiend Folio V1: ",
"Also try Deliverance!",
"Also try Retribution!",
"Also try Alphabirth!",
"Also try Revelations!",
"Also try Bygone Characters!",
"Also try Fall from Grace!",
"Also try Last Judgement!",
"Also try The Future!",
"Also try Boss Butch!",
"Play as Fiend!",
"Play as Golem!",
"Play as Friend!",
"Play as Inaba!",
"Play as Edith!",
"Play as China!",
"Play as Craig!",
"Play as Slippy!",
"Play as Image!",
"Play as Fient!",
"Play as Fend!",
"Play as Frond!",
"Play as Mi!",
"Play as Freezer Jr!",
"Play as The Skeletal Fiend!",
"Play as Peat!",
"Play as Icarus!",
"Play as Mammon!",
"Play as Bertran!",
"Play as Josuke!",
"Play as Vriska!",
"Play as Flysaac!",
"Play as Samael!",
"Play as Job!",
"Play as Ohyo!",
"Play as Elijah!",
"Play as The Sheriff!",
"From the creators of Happy Pack!",
"From the creators of Plagues of Egypt!",
"From the creators of Some Monsters!",
"From the creators of Antibirth!",
"From the creators of Brimstone Oh My God!",
"From the creators of Repentance!",
"NOT from the creators of Repentance+!",
"From the creators of Last Judgement!",
"It came from space",
"Limited edition!",
"The sequel!",
"Going sicko mode",
"I'm so fucking sick of wannabe modders",
"More than 8 enemies!",
"More than 200 enemies!",
"More than 700 enemies!",
"Some mod that'll prolly never come out at this rate",
"Nice man, nice",
"Enemies that don't look as isaac-y, but still look pretty good",
"Modders making mods for fun",
"Today is a good day to be a Fiend Folio fan",
"Sponsored by Peribot",
"Play it and express your true feelings and joy",
"Fully modelled",
"We put the mental in experimental",
"Brought to you by the sweaty meta-fetishists",
"Bubbles pop when the room is clear",
"Old friends and new friends and even a bear",
--"Cum in a Discord call", --No more
"and Kingpin",
"Devil's Harvest 2?",
"The Vietnam sun tanned their skin",
"Criticism just makes you weak",
"You're playing with Bertran, right?",
"Goes great with Bertran!",
"Download Minimod for Nuclear Throne Today!",
"Go clackety clackety clack on your keyboard!",
"Look behind you",
"Look in front of you",
"Oil of Dneif",
"7 new enemies!",
"2!",
"Electric Boogaloo",
"Happy Mario day!",
"Happy Birthday!",
"Happy Holidays!",
"Sponsored by Corn Fanta",
"Dopeheap or Retrogate?",
"Now with Basement Bonies!",
"Stop putting Necros in Mausoleum",
"Three days are remaining...",
"yyou shoulj paly dream land 3",
"Inspired by the YIIK Post-Modern RPG",
"Freeloader to free labor",
"Mod Compatibility Hack can't be killed",
"StageAPI advocates until the bitter end",
"Isaac curse is real",
"Sainte or Gronch?",
"Complete the brown ritual",
"Now a Madness Combat MOD",
"Now a Touhou MOD",
"Now a Homestuck MOD",
"Fiendcraft when?",
"Devil's Throne when?",
"Friday Night Fiendin' when?",
"Now a card MOD",
"Now an everything MOD",
"Nyeah, see?",
"Elder Gods of the Isaac Community",
"Why am I not a floor?",
"Now featuring Greg the Egg",
"Trolleybus",
"La la la lovely tiny pee peepy",
"Morbus absorption complete",
"Milk Dog VS Spaghetti Dog",
"flenolo",
"Long past the point of being an X mod",
"One hell of an oversight",
"Genesis 34:10 (NIV)",
"Luke 11:14 (WYC)",
"2 Samuel 6:14 (KJV)",
"Endorsed by Buta-Corp!",
"Edmund does not smile upon this...",
"Powered by Repentogon",
"My Little Golden Battie",
"Pure baby sensory",
"Now with more Craig!",
"Under new management",
"Field Foalio: Rehayted 2",
"The pipeline is real",
"Rock and Stone!",
"If people didn't talk shit about clutch this wouldn't have happened",
"Clutch's Curse has no hold on me",
"Vanquished at last by the powers of Dynamic Moter API",
"You should play it! It's pretty fun!",
"Remember, no sideliners.",
"It's Miku Night!",
"Just me and my Tyrony",
"So who in here plays alot of Greed Mode?",
"Hi Isaac. Isaac is cool.",
"i am so full from cigarettes yum",
"ok i stole it.",
"I've been told my attack patterns are... hard to dodge.",
"Can someone post that video of the crab dancing to chiptune",
"It's MOD for PRO!",
"Eden, place pill!",
"Isaac is 5",
"Bugged mode",
"Why are all my enemies sliding around?",
"Watch out for Drumstick's homing bone!",
"SlayXc2's appendix required!",
"The definition of feature creep",
"Check behind the pillars!",
"We really need to remove The Spud Feature",
"It's krill time!",
"Beware! This game deals with heavy subjects, such as bad game design!",
"We are funny girls with satanic speeches",
"Required by REPENTOGON!",
"Too many fortunes...!",
"Isaac fact!",
"Undertale/Deltarune recommendation of the day:",
"Play Brutal Orchestra!",
"Check out Clown Meat!",
"Check out GIMMIKO!",
"Check out Limelight Directive!",
"From the creators of Pronoun Palace!",
"It's a bug! It's a bug! It's actually a bug!",
"It's Fiend! Watch out!",
"Holy shoot!",
"Everything has a price",
"Meeh!",
"No more betas, just finished version :)",
"Stop ragebaiting",
"Friend is here! So sad I have to uninstall The Sheriff MOD now :(",
"AAAAAAAAAAIEEEEEEEEEE!!!!!",
"Hi bartar",
"Why is the sheriff purple",
"Makes the game more rancid",
"We hate fun!",
"What if it was purple?",
"Heaps of unused content!",
"Not to be confused with Friend Folio!",
"That sure is something wicked!",
"Real rabbits use gamepad!",
"Fiend Folio found me!",
"Beware the Fiend Folio shadow people",
"Immediately made by shadow people",
"Someone should rework this foe",
"Are you strong enough to fight the ones with guns?",
"This new character will knock your rocks off!",
"Unnecessary poop lore!",
"Glumps get punished",
"The axe forgets but the tree remembers",
"Click to learn more!",
"That's not a bug, it's a feature!",
}
math.randomseed(Isaac.GetTime())
local StartupString = "Fiend Folio: Reloaded V" .. FiendFolio.modVersionNumber .. ": " ..  mod.RandomStrings[math.random(#mod.RandomStrings)]
print(StartupString)
Isaac.DebugString(StartupString)

-- Utils

-- grabs a nested field and initializes any tables along the way
-- The last arg is the default val for the last key, others become tables
function FiendFolio.getFieldInit(tab, ...)
	if not tab then error("Expected table! Got " .. type(tab)) end

	local keys = { ... }
	local default = table.remove(keys) -- last arg is always default val

	for i, key in ipairs(keys) do
		if not tab[key] then
			tab[key] = i < #keys and {} or default
		end
		tab = tab[key]
	end

	return tab
end

function FiendFolio.findKey(tab, func)
	for key, val in pairs(tab) do
		if func(val) then return key, val end
	end
	return nil, nil
end

function FiendFolio.filter(tab, filt)
	local output = {}
	for key, val in pairs(tab) do
		if filt(val, key, tab) then
			table.insert(output, val)
		end
	end
	return output
end

function FiendFolio.append(tab, app)
	for _, val in ipairs(app) do
		table.insert(tab, val)
	end
end

function FiendFolio.ENT(input, returnSeed)
	if mod.FF[input] then
		local rID = mod.FF[input].ID or 0
		local rVar = mod.FF[input].Var or nil
		local rSub = mod.FF[input].Sub or nil

		if returnSeed then
			return {rID, rVar, rSub, returnSeed}
		else
			return {rID, rVar, rSub}
		end
	end
end

function FiendFolio.ENT_KEY(input)
	if mod.FF[input] then
		local rID = mod.FF[input].ID or 0

		if mod.FF[input].Sub then
			return mod.FF[input].ID .. " " .. mod.FF[input].Var .. " " .. mod.FF[input].Sub
		elseif mod.FF[input].Var then
			return mod.FF[input].ID .. " " .. mod.FF[input].Var
		else
			return tostring(mod.FF[input].ID)
		end
	end
end

function FiendFolio.GET_ENT_KEY(typ, var, subt)
	if subt ~= nil then
		return typ .. " " .. var .. " " .. subt
	elseif var ~= nil then
		return typ .. " " .. var
	else
		return tostring(typ)
	end
end

local function LoadScripts(scripts)
	--load scripts
	for i,v in ipairs(scripts) do
		include(v)
	end
end

FiendFolio.LoadScripts = LoadScripts

-- keeping this for legacy purposes
-- use mod addcallback for any new chapi callbacks pls
if CustomHealthAPI and CustomHealthAPI.Library and CustomHealthAPI.Library.UnregisterCallbacks then
	CustomHealthAPI.Library.UnregisterCallbacks("FiendFolio")
end

-- Script loading
mod.EarlyScripts = {
	"ffscripts.helperFunctions",
	"ffscripts.config",
	"ffscripts.constants.constants",
	"ffscripts.constants.constants_items",
	"ffscripts.constants.callbacks",
	"ffscripts.constants.players.golem",
	"ffscripts.constants.players.friend",
	"ffscripts.constants.players.briend_bounty.guns",
	"ffscripts.constants.players.briend_bounty.gunslingers",
	"ffscripts.constants.players.briend_bounty.costumes",
	"ffscripts.constants.players.briend_bounty.compatibility",
	"ffscripts.constants.blacklists",
	"ffscripts.constants.item_descriptions.main",
	"ffscripts.constants.stackable_items",
	"ffscripts.constants.reference_items",
	"ffscripts.constants.waiting_enemies",

	"ffscripts.customhealthapi.core",
	"ffscripts.callbacks.npc_take_dmg_callback",
	"ffscripts.callbacks.secondary_fire",

	"ffscripts.apioverrides",
	"ffscripts.callbacks.dynamic",

	"ffscripts.savedata",
    "ffscripts.scheduler",
    "ffscripts.routines",
	"ffscripts.crossover_rooms",

	"ffscripts.xalum.utilities.giantbook_manager",
	"ffscripts.xalum.utilities.itempools_manager",
	"ffscripts.tearflagslib.main",
	"ffscripts.xalum.utilities.events",
	"ffscripts.xalum.utilities.destination_icons",
	"ffscripts.jd.custompoopapi.main",
	"ffscripts.constants.itempools.main",
	"ffscripts.bombs",

	"ffscripts.achievements.main",
	"ffscripts.achievements.characters",
	"ffscripts.achievements.utilities",
	"ffscripts.achievements.repentogon",

	"ffscripts.players.biend",

	"ffscripts.deadseascrolls.deadseascrolls",
	"ffscripts.deadseascrolls.dss_credits",
	"ffscripts.deadseascrolls.dss_achievementviewer",
	"ffscripts.deadseascrolls.changelogs",
	"ffscripts.pathfinding",
	"ffscripts.shaders",

	"ffscripts.statuses.main",

	"ffscripts.getdatacache",
}
LoadScripts(mod.EarlyScripts)

-- A more efficient, cached wrapper for GetData.
function mod:GetEntityData(entity)
	return GetDataCache.GetEntityData(entity)
end

mod.RevFloors = {"Glacier", "Tomb"}
mod.RevRooms = {
	Glacier = {
		{Name = "Erfly(FF)", Rooms = require("resources.luarooms.revelations.glacier_ff_erfly")},
		{Name = "Guillotine-21(FF)", Rooms = require("resources.luarooms.revelations.glacier_ff_guillotine21")}
	},
	Tomb = {
		{Name = "Erfly(FF)",Rooms = require("resources.luarooms.revelations.tomb_ff_erfly")},
		{Name = "Guillotine-21(FF)",Rooms = require("resources.luarooms.revelations.tomb_ff_guillotine21")}
	}
}

-----------------------------------------------------------

function mod:PostPlayerInit(newPlayer)
	-- Code shouldn't depend on this global existing but I'm not removing it yet to be careful.
	-- Majority of the include'd code files have not yet been inspected.
	room = game:GetRoom()

	if newPlayer.Variant == 0 then
		if mod.ModeEnabled == 2 then
			newPlayer:AddCollectible(438,0,false)
		end
	end
	if newPlayer:GetPlayerType() == Isaac.GetPlayerTypeByName(mod.Character.Name1) or newPlayer:GetPlayerType() == Isaac.GetPlayerTypeByName(mod.Character.Name2) then
		Isaac.ConsoleOutput("Fiend Registered\n")
		mod.cheatModeOn = nil
		mod.Fiendish = true
	elseif game:GetFrameCount() < 30 then
		mod.Fiendish = nil
		mod.cheatModeOn = nil
		mod.FiendishKeyToPress = nil
		mod.FiendishActionToDo = nil
		mod.FiendishKeyTimer = nil
	end
	--dad's home plus
	local newPlayer = newPlayer:ToPlayer()
	if FiendFolio.savedata.run and game:GetFrameCount() < 30 then
		FiendFolio.savedata.run.challengeDadsHomePlusTable = {}
	end
	if Isaac.GetChallenge() == mod.challenges.dadsHomePlus then
		if FiendFolio.savedata.run and game:GetFrameCount() < 5 then
			mod.scheduleForUpdate(function()
				if newPlayer and not newPlayer:HasCollectible(21) then
					newPlayer:AddCollectible(21,0,false)
					newPlayer:AddCollectible(54,0,false)
					Game():GetHUD():ShowItemText("Beat Floor II", "Make dad proud!")
				end
			end, 1, nil, true)
		end
	elseif Isaac.GetChallenge() == mod.challenges.frogMode then
		mod.scheduleForUpdate(function()
			if newPlayer and newPlayer:Exists() and newPlayer:GetPlayerType() ~= FiendFolio.PLAYER.SLIPPY then
				if (game:GetFrameCount() == 0) then
					Isaac.ExecuteCommand("restart " .. FiendFolio.PLAYER.SLIPPY)
				else
					newPlayer:ChangePlayerType(FiendFolio.PLAYER.SLIPPY)
					newPlayer:AddBombs(-1)
					newPlayer:AddCollectible(mod.ITEM.COLLECTIBLE.FROG_HEAD,0,false)
				end
			end
		end, 0, ModCallbacks.MC_POST_RENDER, true)
	elseif Isaac.GetChallenge() == mod.challenges.handsOn then
		for i = 1, 3 do
			newPlayer:AddCollectible(mod.ITEM.COLLECTIBLE.GRABBER,0,false)
		end
		sfx:Play(mod.Sounds.ClapSong, 2, 0, false, 1)
		MusicManager():Pause()
		MusicManager():Disable()
	elseif Isaac.GetChallenge() == mod.challenges.catchTheseHands then
		if FiendFolio.savedata.run and game:GetFrameCount() < 5 then
			mod.scheduleForUpdate(function()
				newPlayer:AddTrinket(TrinketType.TRINKET_BABY_BENDER, nil, true)
				newPlayer:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, false, false, true, false)
				newPlayer:AddTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY, nil, true)
				newPlayer:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, false, false, true, false)
				newPlayer:AddTrinket(mod.ITEM.TRINKET.REDHAND + TrinketType.TRINKET_GOLDEN_FLAG, nil, true)
				newPlayer:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, false, false, true, false)
			end, 0, ModCallbacks.MC_POST_RENDER, true)
		end
	end
end
mod:AddCallback( ModCallbacks.MC_POST_PLAYER_INIT, mod.PostPlayerInit)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, fromcontinue) -- Some challenges haven't been separated into their own files yet
	if Isaac.GetChallenge() == mod.challenges.dadsHomePlus then
		mod.SetChallengeDestinationIcon(mod.DestinationIcon.DAD)
	end
end)

function mod:PostGameStart(continue)
	mod.MorselTimer = 0
	mod.doneShowingModCompatWarning = nil
	--Rev stuff
	if StageAPI and REVEL and not FiendFolioLoadedRevRooms then
		--Frozen Folio / Revelations Rooms
		for i = 1, #mod.RevFloors do
			--print(mod.RevFloors[i] .. " : " .. #mod.RevRooms[mod.RevFloors[i]])
			for _, roomName in ipairs(mod.RevRooms[mod.RevFloors[i]]) do
				REVEL.RoomLists[mod.RevFloors[i]]:AddRooms(roomName)
				--print(mod.RevFloors[i] .. ": ".. roomName.Name .. " loaded!")
			end
		end
		--print("finished loading")
		FiendFolioLoadedRevRooms = true
	end

	if continue then
		if mod.anyPlayerHas(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE, true) then
			mod:makeShampooText("ContinuedRun")
		end
	elseif not continue then
		mod.checkWeedy = true
	end

	mod:UpdateCursorVisuals()
end
mod:AddCallback( ModCallbacks.MC_POST_GAME_STARTED , mod.PostGameStart)

mod.challengeBossSpawnBlacklist = {
	[Challenge.CHALLENGE_APRILS_FOOL] = true,
	[Challenge.CHALLENGE_SEEING_DOUBLE] = true,
	[Challenge.CHALLENGE_RED_REDEMPTION] = true,
}

function mod.shouldFiendFolioBossBeAllowedToSpawn()
	return (not mod.challengeBossSpawnBlacklist[Isaac.GetChallenge()])
end

mod.DefaultBossEncounterData = {
	-- Basement
	{{BossID = "Buck", Weight = 1.5}, LevelStage.STAGE1_1, StageType.STAGETYPE_ORIGINAL},
	{{BossID = "Fooz Twins", Weight = 1.5}, LevelStage.STAGE1_1, StageType.STAGETYPE_ORIGINAL},

	-- Cellar
	{{BossID = "Honeydrop", Weight = 2}, LevelStage.STAGE1_1, StageType.STAGETYPE_WOTL},
	{{BossID = "Whispers", Weight = 2}, LevelStage.STAGE1_1, StageType.STAGETYPE_WOTL},

	-- Burning Basement
	{{BossID = "Griddle", Weight = 2}, LevelStage.STAGE1_1, StageType.STAGETYPE_AFTERBIRTH},
	{{BossID = "Buster", Weight = 2}, LevelStage.STAGE1_1, StageType.STAGETYPE_AFTERBIRTH},
	{{BossID = "Meltdown", Weight = 2}, LevelStage.STAGE1_1, StageType.STAGETYPE_AFTERBIRTH},

	-- Caves
	{{BossID = "Battie", Weight = 2}, LevelStage.STAGE2_1, StageType.STAGETYPE_ORIGINAL},
	{{BossID = "Kingpin", Weight = 2}, LevelStage.STAGE2_1, StageType.STAGETYPE_ORIGINAL},

	-- Catacombs
	{{BossID = "Slinger", Weight = 2}, LevelStage.STAGE2_1, StageType.STAGETYPE_WOTL},

	-- Flooded Caves
	{{BossID = "Moistro", Weight = 2}, LevelStage.STAGE2_1, StageType.STAGETYPE_AFTERBIRTH},
	{{BossID = "Aquagob", Weight = 2}, LevelStage.STAGE2_1, StageType.STAGETYPE_AFTERBIRTH},
	{{BossID = "Deluge", Weight = 2}, LevelStage.STAGE2_1, StageType.STAGETYPE_AFTERBIRTH},

	-- Depths
	{{BossID = "The Organization", Weight = 2.5}, LevelStage.STAGE3_1, StageType.STAGETYPE_ORIGINAL},
	{{BossID = "Gutso", Weight = 2.5}, LevelStage.STAGE3_1, StageType.STAGETYPE_ORIGINAL},

	-- Necropolis
	{{BossID = "Luncheon", Weight = 2.5}, LevelStage.STAGE3_1, StageType.STAGETYPE_WOTL},

	-- Dank Depths
	{{BossID = "Pollution", Weight = 3}, LevelStage.STAGE3_1, StageType.STAGETYPE_AFTERBIRTH},
	{{BossID = "Tsar", Weight = 3}, LevelStage.STAGE3_1, StageType.STAGETYPE_AFTERBIRTH},
	{{BossID = "Junkstrap", Weight = 3}, LevelStage.STAGE3_1, StageType.STAGETYPE_AFTERBIRTH},

	-- Womb
	{{BossID = "Basco", Weight = 2.5}, LevelStage.STAGE4_1, StageType.STAGETYPE_ORIGINAL},

	-- Utero
	{{BossID = "Peeping", Weight = 2}, LevelStage.STAGE4_1, StageType.STAGETYPE_WOTL},
	{{BossID = "The Sun", Weight = 2}, LevelStage.STAGE4_1, StageType.STAGETYPE_WOTL},

	-- Scarred Womb
	{{BossID = "Cacophobia", Weight = 2}, LevelStage.STAGE4_1, StageType.STAGETYPE_AFTERBIRTH},
	{{BossID = "Propaganda", Weight = 2}, LevelStage.STAGE4_1, StageType.STAGETYPE_AFTERBIRTH},

	-- Downpour
	{{BossID = "Ghostbuster", Weight = 1}, LevelStage.STAGE1_1, StageType.STAGETYPE_REPENTANCE},
	{{BossID = "Raymond", Weight = 1}, LevelStage.STAGE1_1, StageType.STAGETYPE_REPENTANCE},

	-- Dross
	{{BossID = "Cacamancer", Weight = 1}, LevelStage.STAGE1_1, StageType.STAGETYPE_REPENTANCE_B},

	-- Mines

	-- Ashpit
	{{BossID = "High Amon", Weight = 1, AlwaysReplaceSubtype = 83, OnlyReplaceSubtype = 83}, LevelStage.STAGE2_1, StageType.STAGETYPE_REPENTANCE_B}, -- Bye bye Gideon

	-- Mausoleum
	{{BossID = "Dusk", Weight = 1}, LevelStage.STAGE3_1, StageType.STAGETYPE_REPENTANCE},
	{{BossID = "Warp Zone", Weight = 1}, LevelStage.STAGE3_1, StageType.STAGETYPE_REPENTANCE},

	-- Gehenna
	{{BossID = "Madomme", Weight = 1}, LevelStage.STAGE3_1, StageType.STAGETYPE_REPENTANCE_B},
	{{BossID = "Idolator", Weight = 1}, LevelStage.STAGE3_1, StageType.STAGETYPE_REPENTANCE_B},

	-- Corpse
	{{BossID = "Mr Dead", Weight = 1}, LevelStage.STAGE4_1, StageType.STAGETYPE_REPENTANCE},
	{{BossID = "Baby Bubbles", Weight = 1}, LevelStage.STAGE4_1, StageType.STAGETYPE_REPENTANCE},
}

local defaultBossWeightFromID = {}
local defaultBossStageFromID = {}
for _, bossData in pairs(mod.DefaultBossEncounterData) do
	defaultBossWeightFromID[bossData[1].BossID] = bossData[1].Weight
	defaultBossStageFromID[bossData[1].BossID] = bossData[2]
end

function mod.GetBossWeightFromID(bossID, mode)
	mode = mode or mod.savedata.bossWeightMode

	if mode == 1 then
		return defaultBossWeightFromID[bossID]
	elseif mode == 2 then
		return 1
	elseif mode == 3 then
		if defaultBossStageFromID[bossID] <= mod.savedata.bossWeightCutoff * 2 then
			return 1
		else
			return defaultBossWeightFromID[bossID]
		end
	end
end

function mod.ReloadBossWeights(mode)
	mode = mode or mod.savedata.bossWeightMode

	for level = 1, 7 do
		for stage = 1, 5 do
			if stage ~= StageType.STAGETYPE_GREEDMODE then
				local floorInfo = StageAPI.GetBaseFloorInfo(level, stage, false)
				if floorInfo.Bosses then -- e.g. Womb, Repentence-B has no bosses currently, since Mortis isn't real.
					for _, entry in pairs(floorInfo.Bosses.Pool) do
						if StageAPI.GetBossData(entry.BossID).IsFFBoss then
							entry.Weight = mod.GetBossWeightFromID(entry.BossID, mode)
						end
					end
				end
			end
		end
	end
end

mod:AddPriorityCallback(ModCallbacks.MC_POST_SAVESLOT_LOAD, CallbackPriority.LATE, function(_, slot, isSelected, rawSlot)
	if isSelected and mod.LOADED_SAVEDATA then
		mod.ReloadBossWeights()
	end
end)

--Boss fun + stageAPI fun
if StageAPI and StageAPI.Loaded then
	local modernHorsemenCondition = function()
		return FiendFolio.ACHIEVEMENT.MODERN_HARBINGERS:IsUnlocked() and mod.shouldFiendFolioBossBeAllowedToSpawn()
	end
	local propagandaCondition = function()
		return modernHorsemenCondition() and Isaac.GetChallenge() ~= mod.challenges.babySensory
	end

	mod.StageAPIBosses = {
		StageAPI.AddBossData("Battie", {
			Name = "Battie",
			Portrait = "gfx/bosses/battie/portrait_battie.png",
			Offset = Vector(30,-24),
			Bossname = "gfx/bosses/battie/bossname_battie.png",
			Rooms = StageAPI.RoomsList("FFBattieRooms", include("resources.luarooms.boss_battie")),
			ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
			Entity = {Type = FiendFolio.FF.Battie.ID, Variant = FiendFolio.FF.Battie.Var},
			ThemedItem = CollectibleType.COLLECTIBLE_CHARM_VAMPIRE,
		}),
		StageAPI.AddBossData("Griddle", {
			Name = "Griddle",
			Portrait = "gfx/bosses/griddlehorn/portrait_griddlehorn.png",
			Offset = Vector(0,-10),
			Bossname = "gfx/bosses/griddlehorn/bossname_griddlehorn.png",
			Rooms = StageAPI.RoomsList("FFGriddleRooms", include("resources.luarooms.boss_griddle")),
			ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
			Entity = {Type = FiendFolio.FF.GriddleHorn.ID, Variant = FiendFolio.FF.GriddleHorn.Var},
			ThemedItem = CollectibleType.COLLECTIBLE_BLACK_POWDER,
		}),
		StageAPI.AddBossData("Ghostse", {
			Name = "Ghostse",
			Portrait = "gfx/enemies/ghostse/portrait.png",
			Bossname = "gfx/enemies/ghostse/name.png",
			Rooms = StageAPI.RoomsList("FFGhostseRooms", include("resources.luarooms.boss_ghostse"))
		}),
		StageAPI.AddBossData("Moistro", {
			Name = "Moistro",
			Portrait = "gfx/bosses/moistro/portrait_moistro.png",
			Offset = Vector(10,-20),
			Bossname = "gfx/bosses/moistro/bossname_monsoon.png",
			Rooms = StageAPI.RoomsList("FFMonsoonRooms", include("resources.luarooms.boss_moistro")),
			ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
			Entity = {Type = FiendFolio.FF.Monsoon.ID, Variant = FiendFolio.FF.Monsoon.Var},
			ThemedTrinket = mod.ITEM.TRINKET.PETRIFIED_GEL,
		}),
		StageAPI.AddBossData("Honeydrop", {
			Name = "Honeydrop",
			Portrait = "gfx/bosses/honeydrop/portrait_honeydrop.png",
			Offset = Vector(7,-17),
			Bossname = "gfx/bosses/honeydrop/bossname_honeydrop.png",
			Rooms = StageAPI.RoomsList("FFHoneydropRooms", include("resources.luarooms.boss_honeydrop")),
			ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
			Entity = {Type = FiendFolio.FF.Honeydrop.ID, Variant = FiendFolio.FF.Honeydrop.Var},
			ThemedItem = mod.ITEM.COLLECTIBLE.BEE_SKIN,
		}),
		StageAPI.AddBossData("Buck", {
			Name = "Buck",
			Portrait = "gfx/bosses/buck/portrait_buck.png",
			Bossname = "gfx/bosses/buck/bossname_buck.png",
			Rooms = StageAPI.RoomsList("FFBuckRooms", include("resources.luarooms.boss_buck")),
			ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
			Entity = {Type = FiendFolio.FF.Buck.ID, Variant = FiendFolio.FF.Buck.Var},
			ThemedItem = CollectibleType.COLLECTIBLE_SACK_HEAD,
		}),
		StageAPI.AddBossData("Buster", {
			Name = "Buster",
			Portrait = "gfx/bosses/buster/portrait_buster.png",
			Offset = Vector(0,-19),
			Bossname = "gfx/bosses/buster/bossname_buster.png",
			Rooms = StageAPI.RoomsList("FFBusterRooms", include("resources.luarooms.boss_buster")),
			ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
			Entity = {Type = FiendFolio.FF.Buster.ID, Variant = FiendFolio.FF.Buster.Var},
			ThemedItem = mod.ITEM.COLLECTIBLE.BOMB_COLLAR,
		}),
		StageAPI.AddBossData("Peat", {
			Name = "Peat",
			Portrait = "gfx/enemies/peat/portraitgiffin.png",
			Bossname = "gfx/enemies/peat/bossname_peat.png",
			Rooms = StageAPI.RoomsList("FFPeatRooms", include("resources.luarooms.boss_peat"))
		}),
		StageAPI.AddBossData("Blue Horf", {
			Name = "Blue Horf",
			Portrait = "gfx/bosses/portrait_boristumous.png",
			Bossname = "gfx/bosses/moistro/bossname_compromise2.png",
			Rooms = StageAPI.RoomsList("FFBlueHorfRooms", include("resources.luarooms.boss_bhorf"))
		}),
		StageAPI.AddBossData("The Sun", {
			Name = "The Sun",
			Portrait = "gfx/bosses/the sun/Portrait-The_Sun.png",
			Offset = Vector(5,-25),
			Bossname = "gfx/bosses/the sun/bossname_thesun.png",
			Rooms = StageAPI.RoomsList("FFSunRooms", include("resources.luarooms.boss_sun")),
			ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
			Entity = {Type = FiendFolio.FF.SunBody.ID, Variant = FiendFolio.FF.SunBody.Var},
			ThemedItem = CollectibleType.COLLECTIBLE_SOL,
		}),
		StageAPI.AddBossData("The Organization", {
			Name = "The Organization",
			Portrait = "gfx/bosses/the organization/portrait_theorganization.png",
			Bossname = "gfx/bosses/the organization/bossname_theorganization.png",
			Rooms = StageAPI.RoomsList("FFOrganizationRooms", include("resources.luarooms.boss_organization")),
			ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
			Entity = {Type = FiendFolio.FF.OrgChaser.ID, Variant = FiendFolio.FF.OrgChaser.Var},
			ThemedItem = CollectibleType.COLLECTIBLE_GAMEKID,
		}),
		StageAPI.AddBossData("Luncheon", {
			Name = "Luncheon",
			Portrait = "gfx/bosses/luncheon/luncheon_portrait.png",
			Offset = Vector(0,-25),
			Bossname = "gfx/bosses/luncheon/bossname_luncheon.png",
			Rooms = StageAPI.RoomsList("FFLuncheonRooms", include("resources.luarooms.boss_luncheon")),
			ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
			Entity = {Type = FiendFolio.FF.Luncheon.ID, Variant = FiendFolio.FF.Luncheon.Var},
			ThemedItem = mod.ITEM.COLLECTIBLE.GREG_THE_EGG,
		}),
		StageAPI.AddBossData("Kingpin", {
			Name = "Kingpin",
			Portrait = "gfx/bosses/kingpin/kingpin_portrait.png",
			Offset = Vector(0,-20),
			Bossname = "gfx/bosses/kingpin/bossname_kingpin.png",
			Rooms = StageAPI.RoomsList("FFKingpinRooms", include("resources.luarooms.boss_kingpin")),
			ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
			Entity = {Type = FiendFolio.FF.Kingpin.ID, Variant = FiendFolio.FF.Kingpin.Var},
			ThemedItem = mod.ITEM.COLLECTIBLE.KING_WORM,
		}),
		StageAPI.AddBossData("Peeping", {
			Name = "Peeping",
			Portrait = "gfx/bosses/peeping/portrait_peeping.png",
			Offset = Vector(17,-18),
			Bossname = "gfx/bosses/peeping/bossname_thepeeping.png",
			Rooms = StageAPI.RoomsList("FFPeepingRooms", include("resources.luarooms.boss_peeping")),
			ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
			Entity = {Type = FiendFolio.FF.Peeping.ID, Variant = FiendFolio.FF.Peeping.Var},
			ThemedItem = CollectibleType.COLLECTIBLE_BLOODSHOT_EYE,
		}),
		StageAPI.AddBossData("Cacamancer", {
			Name = "Cacamancer",
			Portrait = "gfx/bosses/cacamancer/portrait_cacamancer.png",
			Offset = Vector(-3,-28),
			Bossname = "gfx/bosses/cacamancer/bossname_cacamancer.png",
			Rooms = StageAPI.RoomsList("FFCacamancerRooms", include("resources.luarooms.boss_cacamancer")),
			ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
			Entity = {Type = FiendFolio.FF.Cacamancer.ID, Variant = FiendFolio.FF.Cacamancer.Var},
			ThemedItem = mod.ITEM.COLLECTIBLE.NUGGET_BOMBS,
		}),
		StageAPI.AddBossData("Dusk", {
			Name = "Dusk",
			Portrait = "gfx/bosses/dusk/portrait_dusk.png",
			Offset = Vector(15,-30),
			Bossname = "gfx/bosses/dusk/bossname_dusk.png",
			Rooms = StageAPI.RoomsList("FFDuskRooms", include("resources.luarooms.boss_dusk")),
			ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
			Entity = {Type = FiendFolio.FF.Dusk.ID, Variant = FiendFolio.FF.Dusk.Var},
			ThemedItem = mod.ITEM.COLLECTIBLE.BLACK_LANTERN,
		}),
		StageAPI.AddBossData("Gutso", {
			Name = "Gutso",
			Portrait = "gfx/bosses/gutso/portrait_gutso.png",
			Bossname = "gfx/bosses/gutso/bossname_gutso.png",
			Rooms = StageAPI.RoomsList("FFGutsoRooms", include("resources.luarooms.boss_gutso")),
			ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
			Entity = {Type = FiendFolio.FF.Gutso.ID, Variant = FiendFolio.FF.Gutso.Var},
			ThemedItem = CollectibleType.COLLECTIBLE_BUCKET_OF_LARD,
		}),
		StageAPI.AddBossData("Aquagob", {
			Name = "Aquagob",
			Portrait = "gfx/bosses/bluehorf/portrait_bluehorf.png",
			Offset = Vector(-5,-15),
			Bossname = "gfx/bosses/bluehorf/bossname_bluehorf.png",
			Rooms = StageAPI.RoomsList("FFAquagobRooms", include("resources.luarooms.boss_aquagob")),
			ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
			Entity = {Type = FiendFolio.FF.Aquagob.ID, Variant = FiendFolio.FF.Aquagob.Var},
			ThemedItem = mod.ITEM.COLLECTIBLE.GREEN_CANDLE,
		}),
		StageAPI.AddBossData("Pollution", {
			Name = "Pollution",
			Portrait = "gfx/bosses/pollution/portrait_pollution.png",
			Offset = Vector(-7,-28),
			Bossname = "gfx/bosses/pollution/bossname_pollution.png",
			Rooms = StageAPI.RoomsList("FFPollutionRooms", include("resources.luarooms.boss_pollution")),
			Horseman = true,
			AlwaysReplaceHorsemen = true,
			ConditionFunc = modernHorsemenCondition,
			Entity = {Type = FiendFolio.FF.Pollution.ID, Variant = FiendFolio.FF.Pollution.Var},
			ThemedTrinket = mod.ITEM.TRINKET.FLEA_POLLUTION,
		}),
		StageAPI.AddBossData("Meltdown", {
			Name = "Meltdown",
			Portrait = "gfx/bosses/meltdown/portrait_meltdown.png",
			Offset = Vector(-10,-23),
			Bossname = "gfx/bosses/meltdown/bossname_meltdown.png",
			Rooms = StageAPI.RoomsList("FFMeltdownRooms", include("resources.luarooms.boss_meltdown")),
			Horseman = true,
			AlwaysReplaceHorsemen = true,
			ConditionFunc = modernHorsemenCondition,
			Entity = {Type = FiendFolio.FF.Meltdown.ID, Variant = FiendFolio.FF.Meltdown.Var},
			ThemedTrinket = mod.ITEM.TRINKET.FLEA_MELTDOWN,
		}),
		StageAPI.AddBossData("Tsar", {
			Name = "Tsar",
			Portrait = "gfx/bosses/tsar/portrait_tsar.png",
			Offset = Vector(0, -20),
			BossName = "gfx/bosses/tsar/bossname_tsar.png",
			Rooms = StageAPI.RoomsList("FFTsarRooms", include("resources.luarooms.boss_tsar")),
			ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
			Entity = {Type = FiendFolio.FF.Tsar.ID, Variant = FiendFolio.FF.Tsar.Var},
			ThemedItem = CollectibleType.COLLECTIBLE_BALL_OF_TAR,
		}),
		StageAPI.AddBossData("Junkstrap", {
			Name = "Junkstrap",
			Portrait = "gfx/bosses/junkstrap/portrait_junkstrap.png",
			Offset = Vector(5, -28),
			BossName = "gfx/bosses/junkstrap/bossname_junkstrap.png",
			Rooms = StageAPI.RoomsList("FFJunkstrapRooms", include("resources.luarooms.boss_junkstrap")),
			ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
			Entity = {Type = FiendFolio.FF.Junkstrap.ID, Variant = FiendFolio.FF.Junkstrap.Var},
			ThemedItem = mod.ITEM.COLLECTIBLE.CAN_OF_BEANS,
		}),
		StageAPI.AddBossData("Slinger", {
			Name = "Slinger",
			Portrait = "gfx/bosses/slinger/portrait_slinger.png",
			Offset = Vector(10,-27),
			BossName = "gfx/bosses/slinger/bossname_slinger.png",
			Rooms = StageAPI.RoomsList("FFSlingerRooms", include("resources.luarooms.boss_slinger")),
			ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
			Entity = {Type = FiendFolio.FF.Slinger.ID, Variant = FiendFolio.FF.Slinger.Var},
			ThemedItem = CollectibleType.COLLECTIBLE_BURSTING_SACK,
		}),
		StageAPI.AddBossData("Mr Dead", {
			Name = "Mr Dead",
			Portrait = "gfx/bosses/mr_dead/portrait_mr_dead.png",
			BossName = "gfx/bosses/mr_dead/bossname_mr_dead.png",
			Rooms = StageAPI.RoomsList("FFMrDeadRooms", include("resources.luarooms.boss_mrdead")),
			ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
			Entity = {Type = FiendFolio.FF.MrDead.ID, Variant = FiendFolio.FF.MrDead.Var},
			ThemedItem = CollectibleType.COLLECTIBLE_PARASITE,
		}),
		StageAPI.AddBossData("Ghostbuster", {
			Name = "Ghostbuster",
			Portrait = "gfx/bosses/ghostbuster/portrait_ghostbuster.png",
			Offset = Vector(5, -12),
			BossName = "gfx/bosses/ghostbuster/bossname_ghostbuster.png",
			Rooms = StageAPI.RoomsList("FFGhostbusterRooms", include("resources.luarooms.boss_ghostbuster")),
			ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
			Entity = {Type = FiendFolio.FF.Ghostbuster.ID, Variant = FiendFolio.FF.Ghostbuster.Var},
			ThemedItem = CollectibleType.COLLECTIBLE_PURGATORY,
		}),
		StageAPI.AddBossData("Warp Zone", {
			Name = "Warp Zone",
			Portrait = "gfx/bosses/warp_zone/portrait_megaportal.png",
			Offset = Vector(5, -18),
			BossName = "gfx/bosses/warp_zone/bossname_warpzone.png",
			Rooms = StageAPI.RoomsList("FFWarpZoneRooms", include("resources.luarooms.boss_warpzone")),
			ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
			Entity = {Type = FiendFolio.FF.WarpZone.ID, Variant = FiendFolio.FF.WarpZone.Var},
			ThemedItem = CollectibleType.COLLECTIBLE_LIL_PORTAL,
		}),
		StageAPI.AddBossData("Basco", {
			Name = "Basco",
			Portrait = "gfx/bosses/basco/Basco-Portrait.png",
			BossName = "gfx/bosses/basco/bossname_basco.png",
			Rooms = StageAPI.RoomsList("FFBascoRooms", include("resources.luarooms.boss_basco")),
			ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
			Entity = {Type = FiendFolio.FF.Basco.ID, Variant = FiendFolio.FF.Basco.Var},
			ThemedItem = mod.ITEM.COLLECTIBLE.NAGA_VIPER,
		}),
		StageAPI.AddBossData("Whispers", {
			Name = "Whispers",
			Portrait = "gfx/bosses/whispers/portrait_whispers.png",
			Offset = Vector(10,-12),
			Bossname = "gfx/bosses/whispers/bossname_whispers.png",
			Rooms = StageAPI.RoomsList("FFWhispersRooms", require("resources.luarooms.boss_whispers")),
			ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
			Entity = {Type = FiendFolio.FF.WhispersController.ID, Variant = FiendFolio.FF.WhispersController.Var},
			ThemedItem = mod.ITEM.COLLECTIBLE.CARELESS_WHISPERS,
		}),
		StageAPI.AddBossData("Cacophobia", {
			Name = "Cacophobia",
			Offset = Vector(10, -17),
			Portrait = "gfx/bosses/cacophobia/portrait_venus.png",
			Bossname = "gfx/bosses/cacophobia/bossname_cacophobia.png",
			Rooms = StageAPI.RoomsList("FFCacophobiaRooms", require("resources.luarooms.boss_cacophobia")),
			ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
			Entity = {Type = FiendFolio.FF.CacophobiaVenus.ID, Variant = FiendFolio.FF.CacophobiaVenus.Var},
			ThemedItem = mod.ITEM.COLLECTIBLE.PARANOIA,
		}),
		StageAPI.AddBossData("Madomme", {
			Name = "Madomme",
			Portrait = "gfx/bosses/madomme/portrait_madomme.png",
			Offset = Vector(0,-12),
			Bossname = "gfx/bosses/madomme/bossname_madomme.png",
			Rooms = StageAPI.RoomsList("FFMadommeRooms", require("resources.luarooms.boss_madomme")),
			ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
			Entity = {Type = FiendFolio.FF.Madomme.ID, Variant = FiendFolio.FF.Madomme.Var},
			ThemedItem = CollectibleType.COLLECTIBLE_BLOOD_BAG,
		}),
		StageAPI.AddBossData("Raymond", {
			Name = "Raymond",
			Portrait = "gfx/bosses/raymond/portrait_raymond.png",
			Offset = Vector(0,-12),
			Bossname = "gfx/bosses/raymond/bossname_raymond.png",
			Rooms = StageAPI.RoomsList("FFRaymondRooms", require("resources.luarooms.boss_raymond")),
			ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
			Entity = {Type = FiendFolio.FF.Raymond.ID, Variant = FiendFolio.FF.Raymond.Var},
			ThemedItem = CollectibleType.COLLECTIBLE_MY_REFLECTION,
		}),
		StageAPI.AddBossData("Idolator", {
			Name = "Idolator",
			Portrait = "gfx/bosses/idolator/portrait_idolator.png",
			Offset = Vector(0,-12),
			Bossname = "gfx/bosses/idolator/bossname_idolator.png",
			Rooms = StageAPI.RoomsList("FFIdolatorRooms", require("resources.luarooms.boss_idolator")),
			ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
			Entity = {Type = FiendFolio.FF.Idolator.ID, Variant = FiendFolio.FF.Idolator.Var},
			ThemedItem = CollectibleType.COLLECTIBLE_BOOK_OF_SIN,
		}),
		StageAPI.AddBossData("Fooz Twins", {
			Name = "Fooz Twins",
			Portrait = "gfx/bosses/fooztwins/portrait_fooztwins.png",
			Offset = Vector(0,0),
			Bossname = "gfx/bosses/fooztwins/bossname_fooztwins.png",
			Rooms = StageAPI.RoomsList("FFFoozTwinsRooms", require("resources.luarooms.boss_fooztwins")),
			ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
			Entity = {Type = FiendFolio.FF.FoozTwinsBall.ID, Variant = FiendFolio.FF.FoozTwinsBall.Var},
			ThemedItem = mod.ITEM.COLLECTIBLE.CLOWN_MEAT,
		}),
		StageAPI.AddBossData("Deluge", {
			Name = "Deluge",
			Portrait = "gfx/bosses/deluge/portrait_deluge.png",
			Offset = Vector(-7,-28),
			Bossname = "gfx/bosses/deluge/bossname_deluge.png",
			Rooms = StageAPI.RoomsList("FFDelugeRooms", require("resources.luarooms.boss_deluge")),
			Horseman = true,
			AlwaysReplaceHorsemen = true,
			ConditionFunc = modernHorsemenCondition,
			Entity = {Type = FiendFolio.FF.Deluge.ID, Variant = FiendFolio.FF.Deluge.Var},
			ThemedTrinket = mod.ITEM.TRINKET.FLEA_DELUGE,
		}),
		StageAPI.AddBossData("Propaganda", {
			Name = "Propaganda",
			Portrait = "gfx/bosses/propaganda/portrait_propaganda.png",
			Offset = Vector(-7,-28),
			Bossname = "gfx/bosses/propaganda/bossname_propaganda.png",
			Rooms = StageAPI.RoomsList("FFPropagandaRooms", require("resources.luarooms.boss_propaganda")),
			Horseman = true,
			AlwaysReplaceHorsemen = true,
			ConditionFunc = propagandaCondition,
			Entity = {Type = FiendFolio.FF.Propaganda.ID, Variant = FiendFolio.FF.Propaganda.Var},
			ThemedTrinket = mod.ITEM.TRINKET.FLEA_PROPAGANDA,
		}),
		StageAPI.AddBossData("Baby Bubbles", {
			Name = "Baby Bubbles",
			Portrait = "gfx/bosses/babybubble/portrait_babybubbles.png",
			Offset = Vector(0,0),
			Bossname = "gfx/bosses/babybubble/bossname_babybubbles.png",
			Rooms = StageAPI.RoomsList("FFBabyBubblesRooms", include("resources.luarooms.boss_babybubbles")),
			ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
			Entity = {Type = FiendFolio.FF.BabyBubbles.ID, Variant = FiendFolio.FF.BabyBubbles.Var},
			ThemedItem = mod.ITEM.COLLECTIBLE.WARFARIN,
			Spot = "gfx/ui/boss/bossspot_08_utero.png",
		}),
		StageAPI.AddBossData("High Amon", {
			Name = "High Amon",
			Portrait = "gfx/bosses/amon/portrait_amon.png",
			Offset = Vector(0, 0),
			Bossname = "gfx/bosses/amon/name_amon.png",
			Rooms = StageAPI.RoomsList("FFHighAmonRooms", require("resources.luarooms.boss_amon")),
			ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
			Entity = {Type = FiendFolio.FF.Amon.ID, Variant = FiendFolio.FF.Amon.Var},
			ThemedTrinket = mod.ITEM.TRINKET.WAVEBREAKER,
		})
	}

	for _, id in ipairs(mod.StageAPIBosses) do
		StageAPI.GetBossData(id).UseRepentogonBossIntro = true
	end

	-- Hotfix for dirt not being removed when a StageAPI boss overrides bosses like Pin
	-- Can be fixed in StageAPI too later, but I'm a little unclear on when exactly the dirt SHOULD be visible
	-- I dont think any of our bosses need it
	mod:AddCallback(ModCallbacks.MC_POST_BOSS_INTRO_SHOW, function()
		local boss = StageAPI.RepentogonBossIntroBoss
		if boss and boss.IsFFBoss then
			local sprite = RoomTransition.GetVersusScreenSprite()
			local dirtLayer1 = sprite:GetLayer(13)
			if dirtLayer1 then
				dirtLayer1:SetVisible(false)
			end
			local dirtLayer2 = sprite:GetLayer(14)
			if dirtLayer2 then
				dirtLayer2:SetVisible(false)
			end
		end
	end)

	--Mo isn't included so it will play default boss music
	StageAPI.AddBossData("Mo", {
		Name = "Mo",
		Portrait = "gfx/bosses/myfirstboss/image.png",
		Offset = Vector(0,-12),
		Bossname = "gfx/bosses/myfirstboss/bossname_20.0_monstro - Copy.png",
		Rooms = StageAPI.RoomsList("FFMoRooms", require("resources.luarooms.boss_new")),
		ConditionFunc = mod.shouldFiendFolioBossBeAllowedToSpawn,
		Entity = {Type = FiendFolio.FF.Mo.ID, Variant = FiendFolio.FF.Mo.Var},
		ThemedItem = CollectibleType.COLLECTIBLE_SAD_ONION,
	})

	for _, boss in ipairs(mod.StageAPIBosses) do
		local bossData = StageAPI.GetBossData(boss)
		bossData.IsFFBoss = true
	end

	for _, data in pairs(mod.DefaultBossEncounterData) do
		StageAPI.AddBossToBaseFloorPool(table.unpack(data))
	end

	-- Register worm trinkets (for 1% themed drops)
	if StageAPI.RegisterWormTrinket then
		StageAPI.RegisterWormTrinket(mod.ITEM.TRINKET.TRINITY_WORM)
		StageAPI.RegisterWormTrinket(mod.ITEM.TRINKET.TAN_WORM)
	end

	mod.Backdrop = {
		Hive = StageAPI.BackdropHelper({
			Walls = {"1"},
			NFloors = {"nfloor"},
			LFloors = {"lfloor"},
			Corners = {"old_stageapi/corner"}
		}, "gfx/backdrop/old_stageapi/hive_", ".png"),

		Debug = StageAPI.BackdropHelper({
			Walls = {"_alt1", "_alt2", "_alt3"},
			NFloors = {"_nfloor"},
			LFloors = {"_lfloor"},
		}, "gfx/backdrop/debug", ".png"),

		Danker = StageAPI.BackdropHelper({
			Walls = {"1", "2", "3", "4", "5"},
			Corners = {"corner"}
		}, "gfx/backdrop/danker_", ".png"),

		Smoky = StageAPI.BackdropHelper(
		{
			{
			Walls = {"1_1", "1_2"},
			--FloorVariants = {{"smoky_1_1", "smoky_1_2"}, {"smoky_2_1", "smoky_2_2"}},
			NFloors = {"nfloor"},
			LFloors = {"lfloor"},
			Corners = {"corner1"}
			},
			{
			Walls = {"2_1", "2_2"},
		--	FloorVariants = {{"smoky_1_1", "smoky_1_2"}, {"smoky_2_1", "smoky_2_2"}},
			NFloors = {"nfloor"},
			LFloors = {"lfloor"},
			Corners = {"corner2"}
			},
		}, "gfx/backdrop/smoky_", ".png"),

		Lugubrious = StageAPI.BackdropHelper(
			{
				{
				Walls = {"1"},
				NFloors = {"nfloor"},
				LFloors = {"lfloor"},
				Corners = {"corner"}
				}
			}, "gfx/backdrop/lugubrious_", ".png"),

		HappyFunTime = StageAPI.BackdropHelper({
			Walls = {"1", "2", "3", "4"},
			NFloors = {"nfloor"},
			LFloors = {"lfloor"},
			Corners = {"corner"}
		}, "gfx/backdrop/happyfuntime_", ".png"),

		Pipes = StageAPI.BackdropHelper({
			Walls = {"1", "2_gunk"},
			NFloors = {"nfloor"},
			LFloors = {"lfloor"},
			Corners = {"corner"}
		}, "gfx/backdrop/pipes_", ".png"),

		HoneyedCellar = StageAPI.BackdropHelper({
			Walls = {"1", "2_hives",},
			Corners = {"corner"}
		}, "gfx/backdrop/honeyedcellar_", ".png"),

		EyeballUtero = StageAPI.BackdropHelper({
			Walls = {"1", "2",},
		}, "gfx/backdrop/eyeballutero_", ".png"),

		Primordial = StageAPI.BackdropHelper({
			Walls = {"blank", "fossils", "paintings"},
			NFloors = {"nroom"},
			LFloors = {"lroom"},
			Corners = {"corner"}
		}, "gfx/backdrop/primitive_cavern_", ".png"),

		TrashDankDepths = StageAPI.BackdropHelper({
			Walls = {"normal", "alt",},
			Corners = {"corner"}
		}, "gfx/backdrop/trash_dank_depths_", ".png"),

		Challenge = StageAPI.BackdropHelper({
			Walls = {"default"},
		}, "gfx/backdrop/challenge", ".png"),

		RiskReward = StageAPI.BackdropHelper({
			Walls = {"1", "2", "3"},
			Corners = {"corner"}
		}, "gfx/backdrop/risksreward_", ".png"),

		Mammonite = StageAPI.BackdropHelper({
			--Walls = {"1", "2"},
			NFloors = {"nfloor"},
			LFloors = {"lfloor"},
			--Corners = {"corner"},
			WallVariants = {{"1", Corners = {"corner"}}, {"2", Corners={"corner"}}},
			Floors = {"1", "2"}
		}, "gfx/backdrop/mammonite_dim_", ".png"),

		CatacombsNoCaves = StageAPI.BackdropHelper({
			Walls = {"Catacombs2_1"},
			FloorVariants = StageAPI.CatacombsFloors,
			NFloors = {"Catacombs_nfloor"},
			LFloors = {"Catacombs_lfloor"},
			Corners = {"Catacombs2_corner"}
		}, "stageapi/floors/catacombs/", ".png"),

		BlueDice = StageAPI.BackdropHelper({
			Walls = {"1", "2", "3"},
			NFloors = {"nfloor"},
			LFloors = {"lfloor"},
			Corners = {"corner"}
		}, "gfx/backdrop/bluedice_", ".png"),

		Morbus = StageAPI.BackdropHelper({
			Walls = {"1", "2", "3"},
			NFloors = {"nfloor"},
			LFloors = {"lfloor"},
			Corners = {"corner"}
		}, "gfx/backdrop/morbus/main_", ".png"),

		MorbusBoss = StageAPI.BackdropHelper({
			Walls = {"boss"},
			NFloors = {"nfloor"},
			LFloors = {"lfloor"},
			Corners = {"corner"}
		}, "gfx/backdrop/morbus/main_", ".png"),

		Cacophobia = StageAPI.BackdropHelper({
			WallVariants = {{"1_1", "1_2", "1_3", Corners = {"1_corner"}}, {"2_1", "2_2", "2_3", Corners={"2_corner"}}},
			Floors = {"1_1", "1_2", "1_3", "2_1", "2_2", "2_3"}
		}, "gfx/backdrop/cacophobia/", ".png"),

		Madomme = StageAPI.BackdropHelper({
			WallVariants = {{"checkers_1", "checkers_2", "checkers_3", "checkers_4"}},
			NFloors = {"nfloor"},
			LFloors = {"lfloor"},
			Corners = {"corner"},
			Floors = {"checkers_1", "checkers_2", "checkers_3", "checkers_4"},
		}, "gfx/backdrop/madomme/", ".png"),

		Peepee = StageAPI.BackdropHelper({
			WallVariants = {{""}},
			Floors = {""}
		}, "gfx/backdrop/dross_peepee", ".png"),

		IrradiatedAshpitNoAsh = StageAPI.BackdropHelper({
			WallVariants = {{"_1", "_2", "_3", "_4"}},
			Floors = {"_1", "_4"},
			NFloors = {"_nfloor"},
			LFloors = {"_lfloor"},
			Corners = {"_corner"},
		}, "gfx/backdrop/irradiatedashpit/noash/irradiated_ashpit", ".png"),
		IrradiatedAshpitPartialAsh = StageAPI.BackdropHelper({
			WallVariants = {{"_1", "_2", "_3", "_4"}},
			Floors = {"_1", "_4"},
			NFloors = {"_nfloor"},
			LFloors = {"_lfloor"},
			Corners = {"_corner"},
		}, "gfx/backdrop/irradiatedashpit/partialash/irradiated_ashpit", ".png"),
		IrradiatedAshpitFullAsh = StageAPI.BackdropHelper({
			WallVariants = {{"_1", "_2", "_3", "_4"}},
			Floors = {"_floor"},
			NFloors = {"_nfloor"},
			LFloors = {"_lfloor"},
			Corners = {"_corner"},
		}, "gfx/backdrop/irradiatedashpit/fullash/irradiated_ashpit", ".png"),

		SurrealSheol = StageAPI.BackdropHelper({
			Walls = {"1", "2"},
			Corners = {"_corner"},
		}, "gfx/backdrop/surrealsheol/surreal_sheol", ".png"),
	}

  -- Grids
	mod.HiveGrid = StageAPI.GridGfx()
		mod.HiveGrid:AddDoors("gfx/grid/hive_door.png", StageAPI.DefaultDoorSpawn)
		mod.HiveGrid:SetRocks("gfx/grid/hive_rocks.png")

	mod.SmokyGrid = StageAPI.GridGfx()
		mod.SmokyGrid:AddDoors("gfx/grid/smoky_door.png", StageAPI.DefaultDoorSpawn)
		mod.SmokyGrid:SetRocks("gfx/grid/smoky_rocks.png")
		mod.SmokyGrid:SetPits("gfx/grid/pit_smoky.png")

	mod.PipesGrid = StageAPI.GridGfx()
		mod.PipesGrid:AddDoors("gfx/grid/pipes_door.png", StageAPI.DefaultDoorSpawn)
		mod.PipesGrid:AddDoors("gfx/grid/pipes_ambushdoor.png", {RequireEither = {RoomType.ROOM_CHALLENGE}})
		mod.PipesGrid:AddDoors("gfx/grid/pipes_bossambushdoor.png", {RequireEither = {RoomType.ROOM_CHALLENGE}, IsBossAmbush = true})
		mod.PipesGrid:AddDoors("gfx/grid/pipes_bossdoor.png", {RequireEither = {RoomType.ROOM_BOSS}})
		mod.PipesGrid:AddDoors("gfx/grid/pipes_doorarcade.png", {RequireEither = {RoomType.ROOM_ARCADE}})
		mod.PipesGrid:AddDoors("gfx/grid/pipes_doorsacrifice.png", {RequireEither = {RoomType.ROOM_CURSE}})
		mod.PipesGrid:AddDoors("gfx/grid/pipes_doorsacrifice_nospikes.png", {RequireEither = {RoomType.ROOM_CURSE}, RequireVarData = 1})

		mod.PipesGrid:AddDoors("gfx/grid/pipes_secretdoor.png", {RequireEither = {RoomType.ROOM_SECRET, RoomType.ROOM_SUPERSECRET}})
		mod.PipesGrid:AddDoors("gfx/grid/pipes_treasuredoor.png", {RequireEither = {RoomType.ROOM_TREASURE}})
		mod.PipesGrid:SetGrid("gfx/grid/pipes_spikes.png", GridEntityType.GRID_SPIKES)
		mod.PipesGrid:SetGrid("gfx/grid/pipes_spikes.png", GridEntityType.GRID_SPIKES_ONOFF)
		mod.PipesGrid:SetRocks("gfx/grid/rocks_pipes.png")
		mod.PipesGrid:SetPits({
			{File = "gfx/grid/grid_pipe_pit_filled.png", HasExtraFrames = true},
			{File = "gfx/grid/grid_pipe_pit_filled.png", HasExtraFrames = true}
		})

	mod.PrimordialGrid = StageAPI.GridGfx()
		mod.PrimordialGrid:SetRocks("gfx/grid/rocks_primitive.png")
		mod.PrimordialGrid:SetPits("gfx/grid/grid_primitive_pit.png", "gfx/grid/grid_primordial_pit.png")

	mod.BBGrid = StageAPI.GridGfx()
		mod.BBGrid:SetPits("gfx/grid/pit_burningbasement.png")
		mod.BBGrid:SetRocks("gfx/grid/rocks_burningbasement.png")

	mod.CellarGrid = StageAPI.GridGfx()
		mod.CellarGrid:SetPits("gfx/grid/pit_cellar.png")
		mod.CellarGrid:SetRocks("gfx/grid/rocks_cellar.png")

	mod.ShopGrid = StageAPI.GridGfx()
		--mod.ShopGrid:SetPits("gfx/grid/grid_chest_pit_alt.png")
		mod.ShopGrid:SetPits({
			{File = "gfx/grid/grid_chest_pit_alt.png", HasExtraFrames = true},
			{File = "gfx/grid/grid_chest_pit.png", HasExtraFrames = true}
		})
		mod.ShopGrid:SetRocks("gfx/grid/rocks_shop.png")

	mod.LibraryGrid = StageAPI.GridGfx()
		mod.LibraryGrid:SetPits("gfx/grid/pit_cellar.png")
		mod.LibraryGrid:SetRocks("gfx/grid/rocks_library.png")

	--mod.SkullNecroGrid = StageAPI.GridGfx()
	--mod.SkullNecroGrid:SetPits("gfx/grid/grid_pit_bones_necropolis.png")

	mod.DarkRoomGrid = StageAPI.GridGfx()
		mod.DarkRoomGrid:SetRocks("gfx/grid/rocks_darkroom.png")

	mod.SecretGrid = StageAPI.GridGfx()
		mod.SecretGrid:SetRocks("gfx/grid/rocks_secret.png")
		mod.SecretGrid:SetPits("gfx/grid/grid_secret_pit_large.png", nil, true)

	mod.SheolGrid = StageAPI.GridGfx()
		mod.SheolGrid:SetPits("gfx/grid/grid_sheol_pit.png")
		mod.SheolGrid:SetBridges("gfx/grid/rocks_sheol.png")

	mod.CathGrid = StageAPI.GridGfx()
		mod.CathGrid:SetPits("gfx/grid/grid_cathedral_pit_large.png", nil, true)
		mod.CathGrid:SetBridges("gfx/grid/rocks_cathedral.png")

	mod.FloodedGrid = StageAPI.GridGfx()
		mod.FloodedGrid:SetPits("gfx/grid/grid_floodedcaves_pit.png")
		mod.FloodedGrid:SetBridges("gfx/grid/rocks_drownedcaves.png")

	mod.DepthsGrid = StageAPI.GridGfx()
		mod.DepthsGrid:SetRocks("gfx/grid/rocks_depths_custom.png")
		mod.DepthsGrid:SetPits("gfx/grid/grid_depths_pit_large.png", nil, true)

	mod.NecropolisGrid = StageAPI.GridGfx()
		mod.NecropolisGrid:SetRocks("gfx/grid/rocks_necropolis.png")
		mod.NecropolisGrid:SetPits("gfx/grid/grid_necropolis_pit_large.png", nil, true)

	mod.DankDepthsGrid = StageAPI.GridGfx()
		mod.DankDepthsGrid:SetRocks("gfx/grid/rocks_dankdepths.png")
		mod.DankDepthsGrid:SetPits("gfx/grid/grid_dankdepths_pit_large_water.png", nil, true)

	mod.TrashDankDepthsGrid = StageAPI.GridGfx()
		mod.TrashDankDepthsGrid:SetRocks("gfx/grid/rocks_trash.png")
		mod.TrashDankDepthsGrid:SetPits("gfx/grid/grid_dankdepths_pit_large_water.png", nil, true)

	mod.UteroGrid = StageAPI.GridGfx()
		--mod.UteroGrid:AddDoors("gfx/grid/door_utero.png", StageAPI.DefaultDoorSpawn)
		mod.UteroGrid:SetRocks("gfx/grid/rocks_utero.png")
		mod.UteroGrid:SetPits("gfx/grid/grid_utero_pit_large.png", {
			{File = "gfx/grid/grid_uteroblood_pit_large.png", HasExtraFrames = true},
			{File = "gfx/grid/grid_uteroacid_pit_large.png", HasExtraFrames = true}
		}, true)

	mod.ChestGrid = StageAPI.GridGfx()
		mod.ChestGrid:SetRocks("gfx/grid/rocks_chest.png")
		mod.ChestGrid:SetPits({
			{File = "gfx/grid/grid_chest_pit_alt.png", HasExtraFrames = true},
			{File = "gfx/grid/grid_chest_pit.png", HasExtraFrames = true}
		})

	mod.ScarredWombGrid = StageAPI.GridGfx()
		--mod.ScarredWombGrid:SetRocks("gfx/grid/rocks_scarredwomb.png")
		mod.ScarredWombGrid:SetPits("gfx/grid/grid_scarredwomb_pit.png", nil, true)
		mod.ScarredWombGrid:SetBridges("gfx/grid/rocks_scarredwomb.png")

	mod.BasementGrid = StageAPI.GridGfx()
		mod.BasementGrid:SetPits("gfx/grid/pit_basement.png", "gfx/grid/pit_basement.png", true)
		mod.BasementGrid:SetBridges("gfx/grid/rocks_basement.png")

	mod.ChallengeGrid = StageAPI.GridGfx()
		mod.ChallengeGrid:SetPits("gfx/grid/grid_ambush_pit.png", nil, false)
		mod.ChallengeGrid:SetRocks("gfx/grid/rock_challenge_placeholderrecolor.png")
		mod.ChallengeGrid:SetGrid("gfx/grid/pipes_spikes.png", GridEntityType.GRID_SPIKES)
		mod.ChallengeGrid:SetGrid("gfx/grid/pipes_spikes.png", GridEntityType.GRID_SPIKES_ONOFF)

	mod.ErrorGrid = StageAPI.GridGfx()
		mod.ErrorGrid:SetRocks("gfx/grid/rocks_error-1.png.png")

	mod.DiceGrid = StageAPI.GridGfx()
		mod.DiceGrid:SetRocks("gfx/grid/rocks_dice.png")
		mod.DiceGrid:SetPits("gfx/grid/pit_dice.png", "gfx/grid/pit_dice.png", true)

  mod.D12Grid = StageAPI.GridGfx()
		mod.D12Grid:SetRocks("gfx/grid/rocks_d12.png")

	mod.D12GridExt = StageAPI.GridGfx()
		mod.D12GridExt:SetRocks("gfx/grid/rocks_d12.png")
		mod.D12GridExt:SetPits("gfx/grid/pit_d12.png", "gfx/grid/pit_d12.png", true)
		mod.D12GridExt:AddDoors("gfx/grid/d12_door.png", {RequireEither = {RoomType.ROOM_DICE}})

  mod.ED12Grid = StageAPI.GridGfx()
		mod.ED12Grid:SetRocks("gfx/grid/rocks_ed12.png")

	mod.ArcadeGrid = StageAPI.GridGfx()
		mod.ArcadeGrid:SetRocks("gfx/grid/rocks_arcade.png")
		mod.ArcadeGrid:SetPits("gfx/grid/pit_arcade.png")

	mod.CrawlspaceGrid = StageAPI.GridGfx()
		mod.CrawlspaceGrid:SetRocks("gfx/grid/rocks_crawlspace.png")
	--mod.CrawlspaceGrid:SetGrid("gfx/grid/spikes_crawlspace.png", GridEntityType.GRID_SPIKES)

	mod.CrawlspaceGridLuscious = StageAPI.GridGfx()
		mod.CrawlspaceGridLuscious:SetRocks("gfx/grid/rocks_crawlspace_luscious.png")

	mod.CrawlspaceGridOssuary = StageAPI.GridGfx()
		mod.CrawlspaceGridOssuary:SetRocks("gfx/grid/rocks_crawlspace_ossuary.png")

	mod.CrawlspaceGridFortress = StageAPI.GridGfx()
		mod.CrawlspaceGridFortress:SetRocks("gfx/grid/rocks_crawlspace_fortress.png")

	mod.CrawlspaceGridInsulation = StageAPI.GridGfx()
		mod.CrawlspaceGridInsulation:SetRocks("gfx/grid/rocks_crawlspace_insulation.png")

	mod.BlueWombGrid = StageAPI.GridGfx()
		mod.BlueWombGrid:SetRocks("gfx/grid/rocks_bluewomb.png")

	mod.DownpourEntranceGrid = StageAPI.GridGfx()
		mod.DownpourEntranceGrid:SetPits("gfx/grid/grid_pit_downpour_large_entrance.png", nil, true)
		mod.DownpourEntranceGrid:SetRocks("gfx/grid/rocks_downpour_entrance.png")

	mod.DownpourEntranceWetGrid = StageAPI.GridGfx()
		mod.DownpourEntranceWetGrid:SetPits("gfx/grid/grid_pit_downpour_large_entrance.png", nil, true)
		mod.DownpourEntranceWetGrid:SetRocks("gfx/grid/rocks_downpour.png")

	mod.DownpourGrid = StageAPI.GridGfx()
		mod.DownpourGrid:SetPits("gfx/grid/grid_pit_downpour_large.png", nil, true)
		mod.DownpourGrid:SetBridges("gfx/grid/rocks_downpour.png")

	mod.DownpourDryGrid = StageAPI.GridGfx()
		mod.DownpourDryGrid:SetPits("gfx/grid/grid_pit_downpour_large.png", nil, true)
		mod.DownpourDryGrid:SetBridges("gfx/grid/rocks_downpour_entrance.png")

	mod.DrossGrid = StageAPI.GridGfx()
		mod.DrossGrid:SetPits("gfx/grid/grid_pit_dross_large.png", nil, true)
		mod.DrossGrid:SetBridges("gfx/grid/rocks_dross.png")

 	mod.PeepeeGrid = StageAPI.GridGfx()
		mod.PeepeeGrid:SetRocks("gfx/grid/rocks_peepee.png")

	mod.PlanetGrid = StageAPI.GridGfx()
		mod.PlanetGrid:SetPits("gfx/grid/grid_planetarium_pit.png", nil, true)
		mod.PlanetGrid:SetBridges("gfx/grid/rocks_cathedral.png")
		-- this grid should have bridges too, idk what though (they're not invisible anymore but they could use some custom graphics yeah)

	mod.CataGrid = StageAPI.GridGfx()
		mod.CataGrid:SetGrid("gfx/grid/catacomb_spikes.png", GridEntityType.GRID_SPIKES)
		mod.CataGrid:SetGrid("gfx/grid/catacomb_spikes.png", GridEntityType.GRID_SPIKES_ONOFF)
		mod.CataGrid:SetRocks("gfx/grid/rocks_catacombs.png")

	mod.MorbusGrid = StageAPI.GridGfx()
		mod.MorbusGrid:AddDoors("gfx/grid/morbus/morbus_door.png", StageAPI.DefaultDoorSpawn)
		mod.MorbusGrid:AddDoors("gfx/grid/morbus/morbus_hole.png", {RequireEither = {RoomType.ROOM_SECRET, RoomType.ROOM_SUPERSECRET}})
		mod.MorbusGrid:SetRocks("gfx/grid/morbus/morbus_rocks.png")
		mod.MorbusGrid:SetPits("gfx/grid/morbus/morbus_pit.png")
		mod.MorbusGrid:SetDecorations("gfx/grid/morbus/morbus_props.png", "gfx/grid/morbus/morbus_props.anm2", 40)

	mod.MinesGrid = StageAPI.GridGfx()
		mod.MinesGrid:SetPits("gfx/grid/grid_pit_mines_large.png", {
			{File = "gfx/grid/grid_pit_mines_water_large.png", HasExtraFrames = true},
		}, true)
		mod.MinesGrid:SetBridges("gfx/grid/rocks_secretroom.png")

	mod.MinesEntranceGrid = StageAPI.GridGfx()
		mod.MinesEntranceGrid:SetPits("gfx/grid/grid_pit_mines_entrance_large.png", nil, true)
		mod.MinesEntranceGrid:SetBridges("gfx/grid/rocks_secretroom_mines_entrance.png")
		mod.MinesEntranceGrid:SetRocks("gfx/grid/rocks_secretroom_mines_entrance.png")

	mod.MinesChaseGrid = StageAPI.GridGfx()
		mod.MinesChaseGrid:SetPits("gfx/grid/grid_pit_mines_cursed_large.png", nil, true)
		mod.MinesChaseGrid:SetBridges("gfx/grid/rocks_secretroom.png")

	mod.MausoleumGrid = StageAPI.GridGfx()
		mod.MausoleumGrid:SetPits("gfx/grid/grid_pit_mausoleum_large.png", nil, true)
		mod.MausoleumGrid:SetBridges("gfx/grid/rocks_mausoleum.png")

	mod.MausoleumAltGrid = StageAPI.GridGfx()
		mod.MausoleumAltGrid:SetRocks("gfx/grid/rocks_mausoleumb.png")
		mod.MausoleumAltGrid:SetPits("gfx/grid/grid_pit_mausoleumb_large.png", nil, true)
		mod.MausoleumAltGrid:SetBridges("gfx/grid/rocks_mausoleumb.png")

	mod.GehennaGrid = StageAPI.GridGfx()
		mod.GehennaGrid:SetPits("gfx/grid/grid_pit_gehenna_large.png", nil, true)
		mod.GehennaGrid:SetBridges("gfx/grid/rocks_gehenna.png")

	mod.RegCorpseGrid = StageAPI.GridGfx()
		mod.RegCorpseGrid:SetPits("gfx/grid/grid_pit_corpse2_large.png", nil, true)
		mod.RegCorpseGrid:SetBridges("gfx/grid/rocks_corpse2.png")

	mod.BloodyCorpseGrid = StageAPI.GridGfx()
		mod.BloodyCorpseGrid:SetRocks("gfx/grid/rocks_corpse3.png")
		mod.BloodyCorpseGrid:SetPits("gfx/grid/grid_pit_corpse3_large.png", nil, true)
		mod.BloodyCorpseGrid:SetBridges("gfx/grid/rocks_corpse3.png")

	mod.DryCorpseGrid = StageAPI.GridGfx()
		mod.DryCorpseGrid:SetRocks("gfx/grid/rocks_corpse.png")
		mod.DryCorpseGrid:SetPits("gfx/grid/grid_pit_corpse_large.png", nil, true)
		mod.DryCorpseGrid:SetBridges("gfx/grid/rocks_corpse.png")

	mod.RiskRewardGrid = StageAPI.GridGfx()
		mod.RiskRewardGrid:SetRocks("gfx/grid/rocks_psionic.png")
		mod.RiskRewardGrid:SetPits("gfx/grid/grid_sheol_pit.png")
		mod.RiskRewardGrid:SetBridges("gfx/grid/rocks_psionic.png")
		mod.RiskRewardGrid:SetDoorSprites({
			Default = {
				[RoomType.ROOM_DEFAULT] = "gfx/grid/door_19_sheoldoor.png",
				[RoomType.ROOM_MINIBOSS] = "gfx/grid/door_19_sheoldoor.png",
				[RoomType.ROOM_TREASURE] = {
					Anm2 = "gfx/grid/risksreward_door.anm2",
					Sprite = "gfx/grid/risksreward_door.png",
				}
			},
			Treasure = {
				[RoomType.ROOM_DEFAULT] = {
					Anm2 = "gfx/grid/risksreward_door.anm2",
					Sprite = "gfx/grid/risksreward_door.png",
				},
			}
		})
		mod.RiskRewardGrid:SetDoorSpawns(StageAPI.BaseDoorSpawnList)

	mod.MammoniteGrid = StageAPI.GridGfx()
		mod.MammoniteGrid:SetRocks("gfx/grid/mammonite dimension/rocks_mammonite.png")
		mod.MammoniteGrid:SetPits("gfx/grid/mammonite dimension/grid_pit_mammonite.png")
		mod.MammoniteGrid:SetDecorations("gfx/grid/mammonite dimension/props.png", "gfx/grid/mammonite dimension/props.anm2", 42)

	mod.CrawlspaceMammoniteGrid = StageAPI.GridGfx()
		mod.CrawlspaceMammoniteGrid:SetRocks("gfx/grid/mammonite dimension/rocks_crawlspace_mammonite.png")

	mod.IrradiatedAshpitGrid = StageAPI.GridGfx()
		mod.IrradiatedAshpitGrid:SetRocks("gfx/grid/rocks_ashpit_irradiated.png")
		mod.IrradiatedAshpitGrid:SetPits("gfx/grid/grid_pit_ashpit_irradiated.png")

	mod.SurrealSheolGrid = StageAPI.GridGfx()
		mod.SurrealSheolGrid:SetRocks("gfx/grid/rocks_sheol_surreal.png")
		mod.SurrealSheolGrid:SetPits("gfx/grid/grid_sheol_pit.png")

	mod.HoneyedCellarGrid = StageAPI.GridGfx()
		mod.HoneyedCellarGrid:SetRocks("gfx/grid/rocks_honeyedcellar.png")
		mod.HoneyedCellarGrid:SetPits("gfx/grid/pit_cellar.png")



  -- Backdrops

	mod.BasementBackdrop = StageAPI.RoomGfx(nil, mod.BasementGrid, nil, nil)
	mod.CellarBackdrop = StageAPI.RoomGfx(nil, mod.CellarGrid, "_default", "stageapi/shading/shading")
	mod.BBBackdrop = StageAPI.RoomGfx(nil, mod.BBGrid, "_default", "stageapi/shading/shading")
	--mod.CavesBackdrop = StageAPI.RoomGfx(nil, mod.CavesGrid, nil, nil)
	mod.CataBackdrop = StageAPI.RoomGfx(mod.Backdrop.CatacombsNoCaves, mod.CataGrid, "_default", "stageapi/shading/shading")
	mod.FloodedBackdrop = StageAPI.RoomGfx(nil, mod.FloodedGrid, nil, nil)
	mod.DepthsBackdrop = StageAPI.RoomGfx(nil, mod.DepthsGrid, nil, nil)
	mod.NecropolisBackdrop = StageAPI.RoomGfx(nil, mod.NecropolisGrid, nil, nil)
	--mod.SkullNecroBackdrop = StageAPI.RoomGfx(nil, mod.SkullNecroGrid, "_default", "stageapi/shading/shading")
	mod.DankDepthsBackdrop = StageAPI.RoomGfx(nil, mod.DankDepthsGrid, nil, nil)
	--mod.WombBackdrop = StageAPI.RoomGfx(nil, mod.WombGrid, nil, nil)
	mod.UteroBackdrop = StageAPI.RoomGfx(nil, mod.UteroGrid, nil, nil)
	mod.ScarredWombBackdrop = StageAPI.RoomGfx(nil, mod.ScarredWombGrid, nil, nil)
	mod.CathBackdrop = StageAPI.RoomGfx(nil, mod.CathGrid, nil, nil)
	mod.SheolBackdrop = StageAPI.RoomGfx(nil, mod.SheolGrid, nil, nil)
	mod.ChestBackdrop = StageAPI.RoomGfx(nil, mod.ChestGrid, nil, nil)
	mod.DarkRoomBackdrop = StageAPI.RoomGfx(nil, mod.DarkRoomGrid, nil, nil)

	mod.SecretBackdrop = StageAPI.RoomGfx(nil, mod.SecretGrid, nil, nil)
	mod.ChallengeBackdrop = StageAPI.RoomGfx(mod.Backdrop.Challenge, mod.ChallengeGrid, "_default", "stageapi/shading/shading")
	mod.RiskRewardBackdrop = StageAPI.RoomGfx(mod.Backdrop.RiskReward, mod.RiskRewardGrid, nil, nil)
	mod.MammoniteBackdrop = StageAPI.RoomGfx(mod.Backdrop.Mammonite, mod.MammoniteGrid, nil, nil)
	mod.CrawlspaceMammoniteBackdrop = StageAPI.RoomGfx(nil, mod.CrawlspaceMammoniteGrid, nil, nil)
	mod.CrawlspaceBackdrop = StageAPI.RoomGfx(nil, mod.CrawlspaceGrid, nil, nil)
	mod.CrawlspaceBackdropLuscious = StageAPI.RoomGfx(nil, mod.CrawlspaceGridLuscious, nil, nil)
	mod.CrawlspaceBackdropOssuary = StageAPI.RoomGfx(nil, mod.CrawlspaceGridOssuary, nil, nil)
	mod.CrawlspaceBackdropFortress = StageAPI.RoomGfx(nil, mod.CrawlspaceGridFortress, nil, nil)
	mod.CrawlspaceBackdropInsulation = StageAPI.RoomGfx(nil, mod.CrawlspaceGridInsulation, nil, nil)
	mod.LibraryBackdrop = StageAPI.RoomGfx(nil, mod.LibraryGrid, nil, nil)
	mod.ShopBackdrop = StageAPI.RoomGfx(nil, mod.ShopGrid, "_default", "stageapi/shading/shading")
	mod.ErrorBackdrop = StageAPI.RoomGfx(nil, mod.ErrorGrid, nil, nil)
	mod.DiceBackdrop = StageAPI.RoomGfx(nil, mod.DiceGrid, nil, nil)
	mod.D12Backdrop = StageAPI.RoomGfx(nil, mod.D12Grid, nil, nil)
	mod.D12BackdropExt = StageAPI.RoomGfx(mod.Backdrop.BlueDice, mod.D12GridExt, "_default", "stageapi/shading/shading")
	mod.ED12Backdrop = StageAPI.RoomGfx(nil, mod.ED12Grid, nil, nil)
	mod.ArcadeBackdrop = StageAPI.RoomGfx(nil, mod.ArcadeGrid, nil, nil)
	mod.PlanetariumBackdrop = StageAPI.RoomGfx(nil, mod.PlanetGrid, nil, nil)
	mod.DownpourEntranceBackdrop = StageAPI.RoomGfx(nil, mod.DownpourEntranceGrid, nil, nil)
	mod.DownpourEntranceWetBackdrop = StageAPI.RoomGfx(nil, mod.DownpourEntranceWetGrid, nil, nil)
	mod.DownpourBackdrop = StageAPI.RoomGfx(nil, mod.DownpourGrid, nil, nil)
	mod.DownpourDryBackdrop = StageAPI.RoomGfx(nil, mod.DownpourDryGrid, nil, nil)
	mod.DrossBackdrop = StageAPI.RoomGfx(nil, mod.DrossGrid, nil, nil)
	mod.MinesBackdrop = StageAPI.RoomGfx(nil, mod.MinesGrid, nil, nil)
	mod.MinesEntranceBackdrop = StageAPI.RoomGfx(nil, mod.MinesEntranceGrid, nil, nil)
	mod.MinesChaseBackdrop = StageAPI.RoomGfx(nil, mod.MinesChaseGrid, nil, nil)
	mod.MausoleumBackdrop = StageAPI.RoomGfx(nil, mod.MausoleumGrid, nil, nil)
	mod.GehennaBackdrop = StageAPI.RoomGfx(nil, mod.GehennaGrid, nil, nil)
	mod.CorpseBackdrop1 = StageAPI.RoomGfx(nil, mod.RegCorpseGrid, nil, nil)
	mod.CorpseBackdrop2 = StageAPI.RoomGfx(nil, mod.BloodyCorpseGrid, nil, nil)
	mod.CorpseBackdrop3 = StageAPI.RoomGfx(nil, mod.DryCorpseGrid, nil, nil)
	mod.PeepeeBackdrop = StageAPI.RoomGfx(nil, mod.PeepeeGrid, nil, nil)
	--mod.PeepeeBackdrop = StageAPI.RoomGfx(mod.Backdrop.Peepee, mod.PeepeeGrid, nil, nil)

	mod.HiveBackdrop = StageAPI.RoomGfx(mod.Backdrop.Hive, mod.HiveGrid, "_default", "stageapi/shading/shading")
	mod.DebugBackdrop = StageAPI.RoomGfx(mod.Backdrop.Debug, nil, "_default", "stageapi/shading/shading")
	mod.DankerBackdrop = StageAPI.RoomGfx(nil, mod.DankDepthsGrid, nil, nil)
	--mod.DankerBackdrop = StageAPI.RoomGfx(mod.Backdrop.Danker, mod.DankDepthsGrid, "_default", "stageapi/shading/shading")
	mod.SmokyBackdrop = StageAPI.RoomGfx(mod.Backdrop.Smoky, mod.SmokyGrid, "_default", "stageapi/shading/shading")
	mod.HappyFunTimeBackdrop = StageAPI.RoomGfx(mod.Backdrop.HappyFunTime, nil, "_default", "stageapi/shading/shading")
	mod.PipesBackdrop = StageAPI.RoomGfx(mod.Backdrop.Pipes, mod.PipesGrid, "_default", "stageapi/shading/shading")
	mod.HoneyedCellarBackdrop = StageAPI.RoomGfx(mod.Backdrop.HoneyedCellar, mod.HoneyedCellarGrid, "_default", "stageapi/shading/shading")
	mod.EyeballUteroBackdrop = StageAPI.RoomGfx(mod.Backdrop.EyeballUtero, mod.UteroGrid, "_default", "stageapi/shading/shading")
	mod.PrimordialBackdrop = StageAPI.RoomGfx(mod.Backdrop.Primordial, mod.PrimordialGrid, "_default", "stageapi/shading/shading")
	mod.TrashDankDepthsBackdrop = StageAPI.RoomGfx(mod.Backdrop.TrashDankDepths, mod.TrashDankDepthsGrid, "_default", "stageapi/shading/shading")
	mod.MorbusBackdrop = StageAPI.RoomGfx(mod.Backdrop.Morbus, mod.MorbusGrid, "_default", "stageapi/shading/shading")
	mod.MausoleumAltBackdrop = StageAPI.RoomGfx(BackdropType.MAUSOLEUM3, mod.MausoleumAltGrid)
	mod.LugubriousBackdrop = StageAPI.RoomGfx(mod.Backdrop.Lugubrious, mod.DarkRoomGrid, nil, nil)
	mod.IrradiatedAshpitNoAshBackdrop = StageAPI.RoomGfx(mod.Backdrop.IrradiatedAshpitNoAsh, mod.IrradiatedAshpitGrid)
	mod.IrradiatedAshpitPartialAshBackdrop = StageAPI.RoomGfx(mod.Backdrop.IrradiatedAshpitPartialAsh, mod.IrradiatedAshpitGrid)
	mod.IrradiatedAshpitFullAshBackdrop = StageAPI.RoomGfx(mod.Backdrop.IrradiatedAshpitFullAsh, mod.IrradiatedAshpitGrid)
	mod.SurrealSheolBackdrop = StageAPI.RoomGfx(mod.Backdrop.SurrealSheol, mod.SurrealSheolGrid)


	mod.CacophobiaBackdrop = StageAPI.RoomGfx(mod.Backdrop.Cacophobia, nil, nil, nil)
	mod.MadommeBackdrop = StageAPI.RoomGfx(mod.Backdrop.Madomme, nil, nil, nil)

	-- Peepee backdrop water
	mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, CallbackPriority.LATE, function()
		local room = game:GetRoom()
		if mod.roomBackdrop == 9 then
			local params = room:GetFXParams()
			params.WaterColor = KColor(235 / 255, 237 / 255, 0, 0.3)
		end
	end)

	--The Lab

	mod.LabWalls = StageAPI.BackdropHelper({
			Walls = {"_Blank", "1", "2"},
		}, "gfx/secret/shhhhh/nothing to see here/Laboratory_Room", ".png")
	mod.LabGrid = StageAPI.GridGfx()
	mod.LabGrid:AddDoors("gfx/secret/shhhhh/nothing to see here/Laboratory_Door.png", StageAPI.DefaultDoorSpawn)
	mod.LabGrid:SetRocks("gfx/secret/shhhhh/nothing to see here/Laboratory_Rocks.png")
	mod.LabGrid:SetPits("gfx/secret/shhhhh/nothing to see here/Laboratory_Pit.png",
	{
		{File = "gfx/secret/shhhhh/nothing to see here/Laboratory_Pit_BioFuel.png"}
	},
	false)

	mod.LabBackdrop = StageAPI.RoomGfx(mod.LabWalls, mod.LabGrid, "_default", "stageapi/shading/shading")

	mod.LabRooms = {
		RoomFiles = {
			"thelab"
		}
	}

	mod.LabRoomlist = {}

	for _, roomName in ipairs(mod.LabRooms.RoomFiles) do
		mod.LabRooms.RoomFiles[roomName] = require("resources.luarooms." .. roomName)
		mod.LabRoomlist[#mod.LabRoomlist + 1] = mod.LabRooms.RoomFiles[roomName]
	end

	-- local LabRoomsReal = StageAPI.RoomsList("Rooms", table.unpack(mod.LabRoomlist))

	mod.TheLab = StageAPI.CustomStage("Lab")
	mod.TheLab:SetRoomGfx(mod.LabBackdrop, {RoomType.ROOM_DEFAULT, RoomType.ROOM_TREASURE, RoomType.ROOM_MINIBOSS})
	-- mod.TheLab:SetRooms(LabRoomsReal)
	mod.TheLab:SetMusic(Isaac.GetMusicIdByName("LabTheme"), {RoomType.ROOM_DEFAULT})
	mod.TheLab:SetReplace(StageAPI.StageOverride.NecropolisOne)

	--MorbusReal

	mod.MorbusRealWalls = StageAPI.BackdropHelper({
			Walls = {""},
		}, "gfx/secret/shhhhh/nothing to see here/morbusReal", ".png")
	mod.MorbusRealGrid = StageAPI.GridGfx()
	mod.MorbusRealGrid:SetRocks("gfx/secret/shhhhh/nothing to see here/morbusRealRocks.png")

	mod.MorbusRealBackdrop = StageAPI.RoomGfx(mod.MorbusRealWalls, mod.MorbusRealGrid, "_default", "stageapi/shading/shading")

	mod.MorbusReal = StageAPI.CustomStage("MorbusReal")
	mod.MorbusReal:SetRoomGfx(mod.MorbusRealBackdrop, {RoomType.ROOM_DEFAULT, RoomType.ROOM_TREASURE, RoomType.ROOM_MINIBOSS, RoomType.ROOM_BOSS})


	--Stony Level

	mod.StonyRooms = {
		RoomFiles = {
			"stonylevel"
		}
	}

	mod.StonyRoomlist = {}

	for _, roomName in ipairs(mod.StonyRooms.RoomFiles) do
		mod.StonyRooms.RoomFiles[roomName] = require("resources.luarooms." .. roomName)
		mod.StonyRoomlist[#mod.StonyRoomlist + 1] = mod.StonyRooms.RoomFiles[roomName]
	end

	local StonyRoomsReal = StageAPI.RoomsList("Rooms", table.unpack(mod.StonyRoomlist))

	local StonyBosses = {
	"Peat",
	"Blue Horf",
	}

	mod.StonyLevel = StageAPI.CustomStage("Stony Level")
	mod.StonyLevel:SetRoomGfx(mod.PrimordialBackdrop, {RoomType.ROOM_DEFAULT, RoomType.ROOM_TREASURE, RoomType.ROOM_MINIBOSS, RoomType.ROOM_BOSS})
	mod.StonyLevel:SetRooms(StonyRoomsReal)
	mod.StonyLevel:SetBosses(StonyBosses)

	StageAPI.UnregisterCallbacks("FiendFolio") -- for lua modding so the same callbacks aren't in twice

	local AltRockRNG = RNG()
	--Custom Alt Rock spawns
	StageAPI.AddCallback("FiendFolio", "POST_OVERRIDDEN_ALT_ROCK_BREAK", 1, function(gridpos, gridvar, brokenData, customGrid)
		local room = game:GetRoom()
		if customGrid.Projectile then
			AltRockRNG:SetSeed(customGrid.Projectile.DropSeed, 600)
		elseif customGrid:IsOnGrid() then
			AltRockRNG:SetSeed(room:GetDecorationSeed() + customGrid.GridEntity:GetGridIndex(), 80)
		end
		if room:GetBackdropType() == 16 then
			local r = mod:RandomInt(0, 1000, AltRockRNG)
			local spawn = nil
			if r <= 40 then
				spawn = {219, 0, 0} --Wizoob
			elseif r <= 50 then
				spawn = {285, 0, 0} --Red Ghost
			elseif r <= 100 then
				spawn = {260, 10, 0} --Lil Haunt
			elseif r <= 150 then
				spawn = {mod.FF.Yawner.ID, mod.FF.Yawner.Var, 0} --Yawner
			elseif r <= 200 then
				spawn = {mod.FF.Ghostse.ID, mod.FF.Ghostse.Var, 0} --Ghostse
			elseif r <= 210 then
				spawn = {5, 20, 213} --Cursed Penny
			elseif r <= 235 then
				spawn = {227, 0, 0} --Bony
			elseif r <= 260 then
				spawn = {277, 0, 0} --Black Bony
			elseif r <= 300 then
				spawn = {mod.FF.Crepitus.ID, mod.FF.Crepitus.Var, 0} --Crepitus
			elseif r <= 350 then
				if Isaac.GetPersistentGameData():Unlocked(Achievement.BONE_HEARTS) then
					spawn = {5, 10, 11} --Bone Heart
				end
			else
			--	Isaac.ConsoleOutput("zilch")
			end
			if spawn ~= nil then
			--	Isaac.ConsoleOutput("spawned")
				local entity = Isaac.Spawn(spawn[1], spawn[2], spawn[3], gridpos, nilvector, nil)
			end
		elseif room:GetBackdropType() == 17 then
			local r = mod:RandomInt(0, 1000, AltRockRNG)
			local spawn = nil
			if r <= 50 then
				spawn = {227, 0, 0} --Bony
			elseif r <= 90 then
				spawn = {277, 0, 0} --Black Bony
			elseif r <= 120 then
				spawn = {mod.FF.Crepitus.ID, mod.FF.Crepitus.Var, 0} --Crepitus
			elseif r <= 170 then
				if Isaac.GetPersistentGameData():Unlocked(Achievement.BONE_HEARTS) then
					spawn = {5, 10, 11} --Bone Heart
				end
			elseif r <= 210 then
				spawn = {mod.FF.Sackboy.ID, mod.FF.Sackboy.Var, 0} --Sackboy
			elseif r <= 235 then
				spawn = {mod.FF.Cracker.ID, mod.FF.Cracker.Var, 0} --Cracker
			elseif r <= 270 then
				spawn = {mod.FF.Posssessed.ID, mod.FF.Posssessed.Var, 0} --Possessed
			elseif r <= 300 then
				spawn = {mod.FF.CurdleNaked.ID, mod.FF.CurdleNaked.Var, 0} --Naked Curdle
			elseif r <= 320 then
				spawn = {mod.FF.Neonate.ID, mod.FF.Neonate.Var, 0} --Neonate
			elseif r <= 340 then
				spawn = {mod.FF.NuchalDetached.ID, mod.FF.NuchalDetached.Var, 0} --Nuchal
			elseif r <= 350 then
				spawn = {5, 20, 213} --Cursed Penny
			else
			--	Isaac.ConsoleOutput("zilch")
			end
			if spawn ~= nil then
			--	Isaac.ConsoleOutput("spawned")
				local entity = Isaac.Spawn(spawn[1], spawn[2], spawn[3], gridpos, nilvector, nil)
			end
		elseif room:GetBackdropType() == BackdropType.DICE or mod.IsD12DiceRoom or mod:IsD12UsedRoom() then
			--Stop certain rock break sounds that sound too dumb
			sfx:Stop(SoundEffect.SOUND_POT_BREAK)
			sfx:Stop(SoundEffect.SOUND_POT_BREAK_2)
			sfx:Stop(SoundEffect.SOUND_MUSHROOM_POOF_2)
			sfx:Play(SoundEffect.SOUND_MUSHROOM_POOF)

			local rand = mod:RandomInt(0,200,AltRockRNG)
			local itemPool = game:GetItemPool()
			if rand <= 1 and itemPool:HasCollectible(mod.ITEM.COLLECTIBLE.ISAACD_EULOGY) and mod.IsCollectibleUnlocked(mod.ITEM.COLLECTIBLE.ISAACD_EULOGY) then
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, mod.ITEM.COLLECTIBLE.ISAACD_EULOGY, gridpos, Vector.Zero, nil)
				itemPool:RemoveCollectible(mod.ITEM.COLLECTIBLE.ISAACD_EULOGY)
			elseif rand <= 2 and itemPool:HasCollectible(mod.ITEM.COLLECTIBLE.DICE_BAG) then
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, mod.ITEM.COLLECTIBLE.DICE_BAG, gridpos, Vector.Zero, nil)
				itemPool:RemoveCollectible(mod.ITEM.COLLECTIBLE.DICE_BAG)
			elseif rand <= 5 and itemPool:HasTrinket(TrinketType.TRINKET_DICE_BAG) and Isaac.GetPersistentGameData():Unlocked(Achievement.DICE_BAG) then
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, TrinketType.TRINKET_DICE_BAG, gridpos, Vector.Zero, nil)
				itemPool:RemoveTrinket(TrinketType.TRINKET_DICE_BAG)
			elseif rand <= 35 then
				local glassDice = mod:GetRandomGlassDice(AltRockRNG, nil, true, true)
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, glassDice, gridpos, Vector.Zero, nil)
			elseif rand <= 50 then
				Isaac.Spawn(mod.FF.ShrunkenHead.ID, mod.FF.ShrunkenHead.Var, mod:RandomInt(0,3,AltRockRNG), gridpos, Vector.Zero, nil)
			end

		elseif mod.roomBackdrop == 9 then -- Pee Dross
			--Piss projectiles from filled buckets
			if gridvar == 1 then
				for i = 1, mod:RandomInt(4,6) do
					local projectile = mod:LazySpawnProjectile(0, 0, gridpos, Vector.One:Resized(mod:RandomInt(4,6)):Rotated(mod:RandomAngle()), nil):ToProjectile()
					projectile.FallingSpeed = mod:RandomInt(-25,-10)
					projectile.FallingAccel = 1.2
					projectile.Color = mod.ColorPeepPiss
					local d = mod:GetEntityData(projectile)
					d.projType = "Peepisser"
					d.detail = "Pee"
					d.creepTimeout = 90
					d.water = room:HasWater()
					projectile:Update()
				end
			end
			local rand = mod:RandomInt(0,10,AltRockRNG)
			--Chance for Coins
			if rand < 3 then
				for i = 1, mod:RandomInt(1,2,AltRockRNG) do
					Isaac.Spawn(5,20,0,gridpos,Vector.One:Resized(mod:RandomInt(1,3)):Rotated(mod:RandomAngle()),nil)
				end
			--Chance for Spiders/Leeches
			elseif rand < 6 then
				local toLeech = (mod:RandomInt(0,1,AltRockRNG) == 1)
				for i = 1, 2 do
					local spider = EntityNPC.ThrowSpider(gridpos, nil, gridpos + Vector(mod:RandomInt(-40,40), mod:RandomInt(-40,40)), false, 0):ToNPC()
					if toLeech then
						spider:Morph(810,0,0,-1)
					end
				end
			end
		elseif mod.roomBackdrop == 10 then -- Morbus
			local roll = mod:RandomInt(0, 1000, AltRockRNG)/1000

			if roll < 0.2 then -- 20%
				local nerve = Isaac.Spawn(231, 0, 1980, gridpos, Vector.Zero, nil)
				nerve:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

				local sprite = nerve:GetSprite()
				sprite:ReplaceSpritesheet(0, "gfx/enemies/morbus misc/nerve_ending.png")
				sprite:LoadGraphics()
			elseif roll < 0.21 then -- 1%
				Isaac.Spawn(5, 100, 682, gridpos, Vector.Zero, nil) -- Worm Friend
			elseif roll < 0.25 and Isaac.GetPersistentGameData():Unlocked(Achievement.BONE_HEARTS) then -- 4%
				Isaac.Spawn(5, 10, 11, gridpos, Vector.Zero, nil) -- Bone Heart
			elseif roll < 0.28 and mod.ACHIEVEMENT.MORBID_HEART:IsUnlocked() then -- 3%
				Isaac.Spawn(5, FiendFolio.PICKUP.VARIANT.MORBID_HEART, 0, gridpos, Vector.Zero, nil) -- Morbid Heart
			elseif roll < 0.285 then -- 0.5%
				Isaac.Spawn(120, 235, 0, gridpos, Vector.Zero, nil) -- Oralid
			end

		elseif mod.roomBackdrop == 14 then --Surreal Sheol
			sfx:Play(SoundEffect.SOUND_BONE_BREAK, 2.5)

			local poof = Isaac.Spawn(1000, 2, 2, gridpos, Vector.Zero, nil)
			poof.Color = FiendFolio.ColorPureWhitePale
			poof:Update()
			local splat = Isaac.Spawn(1000, 7, 0, gridpos, Vector.Zero, nil)
			splat.Color = FiendFolio.ColorPureWhitePale
			splat:Update()

			for _, spawn in pairs(brokenData) do
				local roll = mod:RandomInt(0, 1000, AltRockRNG)/1000
				if spawn.Type > 10 then --Replace Hosts
					if roll <= 0.33 then --Wrinkly Baby
						Isaac.Spawn(EntityType.ENTITY_BABY, 3, 0, gridpos, Vector.Zero, nil)
					elseif roll <= 0.66 then --Sucker
						Isaac.Spawn(EntityType.ENTITY_SUCKER, 0, 0, gridpos, Vector.Zero, nil)
					else --Shrunken Head
						Isaac.Spawn(mod.FF.ShrunkenHead.ID, mod.FF.ShrunkenHead.Var, 0, gridpos, Vector.Zero, nil)
					end

				elseif spawn.Type == EntityType.ENTITY_PICKUP then
					if spawn.Variant == PickupVariant.PICKUP_COLLECTIBLE then --Replace Collectibles
						local item = mod.GetItemFromCustomItemPool(mod.CustomPool.SURREAL_SHEOL_EGG, AltRockRNG)
						Isaac.Spawn(EntityType.ENTITY_PICKUP, item[1], item[2], gridpos, Vector.Zero, nil)

					elseif spawn.Variant == PickupVariant.PICKUP_HEART then --Replace Black Hearts
						if roll <= 0.2 and Isaac.GetPersistentGameData():Unlocked(Achievement.GOLDEN_HEARTS) then --Golden Heart
							Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_GOLDEN, gridpos, Vector.Zero, nil)
						else
							for i = 1, mod:RandomInt(1,2,AltRockRNG) do --1-2 Coins
								Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, gridpos, RandomVector()*mod:RandomInt(2,6,AltRockRNG), nil)
							end
						end

					else --Replace Cards
						Isaac.Spawn(EntityType.ENTITY_PICKUP, 302, 0, gridpos, Vector.Zero, nil) --Random Object
					end
				end
			end
		else
			local backdrop = room:GetBackdropType()
			if backdrop == FiendFolio.Backdrops.SALOON then
				mod:saloonBucketBreak(gridpos, gridvar, brokenData, customGrid, room, AltRockRNG)
			end
		end
	end)

	mod:AddCallback(ModCallbacks.MC_POST_GRID_ROCK_DESTROY, function(_, grid, type, immeadiate, source)
		if mod.roomBackdrop == 4 and grid:GetVariant() == 1 then
			AltRockRNG:SetSeed(game:GetRoom():GetDecorationSeed() + grid:GetGridIndex(), 80)
			for i = 1, mod:RandomInt(3,5,AltRockRNG) do
				local projectile = Isaac.Spawn(9, 0, 0, grid.Position, Vector(mod:RandomInt(2,5,AltRockRNG), 0):Rotated(mod:RandomInt(0,359,AltRockRNG)), nil):ToProjectile()
				projectile.FallingSpeed = mod:RandomInt(-25,-10,AltRockRNG)
				projectile.FallingAccel = 1.2
				projectile.Scale = 0.4
				projectile.Color = mod.ColorHoneyYellow
			end
			local honeycolor = Color(1,1,1,1,0,0,0)
			honeycolor:SetColorize(5.5, 3.5, 1, 1)
			local creep = Isaac.Spawn(1000, EffectVariant.CREEP_BROWN, 0, grid.Position, Vector.Zero, nil):ToEffect()
			creep.SpriteScale = Vector(2, 1.25)
			creep:SetTimeout(creep.Timeout + 90)
			creep:Update()
			creep:GetSprite().Color = honeycolor
			mod:PlaySound(SoundEffect.SOUND_MEAT_JUMPS, nil, 0.8, 2)
		end
	end, GridEntityType.GRID_ROCK_ALT)


	mod.FloorGrids = {
		mod.BasementGrid,
		mod.CellarGrid,
		mod.BBGrid,
		mod.SmokyGrid,
		--mod.CavesGrid,
		mod.PrimordialGrid,
		mod.CataGrid,
		mod.FloodedGrid,
		mod.DepthsGrid,
		mod.NecropolisGrid,
		mod.DankDepthsGrid,
		mod.PipesGrid,
		--mod.WombGrid,
		mod.UteroGrid,
		mod.ScarredWombGrid,
		mod.BlueWombGrid,
		mod.CathGrid,
		mod.SheolGrid,
		mod.ChestGrid,
		mod.DarkRoomGrid,

		mod.SecretGrid,
		mod.ChallengeGrid,
		--mod.CrawlspaceGrid,
		mod.ShopGrid,
		mod.DiceGrid,
		mod.D12Grid,
		mod.ED12Grid,
		mod.ArcadeGrid,
		mod.ErrorGrid,

		mod.HiveGrid,
		mod.MorbusRealGrid,
		mod.LabGrid,
	}
end

do
	SepticRoomCompat = SepticRoomCompat or {}
	SepticRoomCompat.Default = SepticRoomCompat.Default or {}
	table.insert(SepticRoomCompat.Default, require('resources.luarooms.septic_ff'))
end

--Isaac.ConsoleOutput("StageAPI boses are: " .. #mod.StageAPIBosses .. "\n")

mod.illegalRoomSubs = {
9,	--Famine
10, --Pestilence
11, --War
12, --Death
19, --Gish
20, --Steven
21, --Chad
22, --Headless Horseman
23, --The Fallen
38, --Conquest
42, --Triachnid (just in case)
}

-- seriously don't mess with these
mod.felonyRoomSubs = {
	6,	--Mom
	8,	--Mom's Heart
	25, --It Lives
}

FiendFolio.ForceBosses = false
FiendFolio.ForceMo = false
FiendFolio.MoChance = 1/125
FiendFolio.MoRNG = RNG()

if StageAPI and StageAPI.Loaded then
	StageAPI.AddCallback("FiendFolio", "PRE_BOSS_SELECT", 1, function(bosses, rng, roomDesc, ignoreNoOptions)
		if mod.ModeEnabled == 2 then
			return {Pool = {{BossID = "Ghostse", Weight = 10000000}}}
		end

		if game.Challenge == FiendFolio.challenges.imperishableNight then
			return mod:getImperishableBossPool()
		elseif (not StageAPI.GetBossEncountered("Mo")) and (FiendFolio.ForceMo) then
			local pool = bosses.Pool or bosses
			return {Pool = {{BossID = "Mo", Weight = 657382}}}
		elseif (not StageAPI.GetBossEncountered("Mo")) and (not FiendFolio.ForceBosses) then
			local pool = bosses.Pool or bosses
			local moRNG = rng or FiendFolio.MoRNG
			if moRNG:RandomFloat() <= FiendFolio.MoChance and #pool > 1 then
				local safe = true
				--Safety check cos it's a little weird with both Mom's Heart and It Lives existing for Womb
				if #pool == 2 then
					if pool[1] and pool[1].BossID then
						if pool[1].BossID == "Mom's Heart"
						or pool[1].BossID == "It Lives"
						then
							safe = false
						end
					end
				end
				--Without this, Mo would replace It Lives on stage 7 XL floors teehee
				if safe then
					return {Pool = {{BossID = "Mo", Weight = 657382}}}
				end
			end
		end

		if FiendFolio.ForceBosses or FiendFolio.ForcingFiendFolioBosses then
			local ffBosses = {Pool = {}}

			for _, bossID in ipairs(bosses.Pool or bosses) do
				local poolEntry
				if type(bossID) == "table" then
					poolEntry = bossID
					bossID = bossID.BossID
				end

				local bossData = StageAPI.GetBossData(bossID)
				if bossData and bossData.IsFFBoss then
					ffBosses.Pool[#ffBosses.Pool + 1] = poolEntry or bossID
				end
			end

			if #ffBosses.Pool > 0 then
				return ffBosses
			end
		elseif roomDesc then
			-- Don't replace the headless horseman, don't replace Turdlet with Cacamancer
			-- On Dank Depths, don't replace Gish, but do replace every other base game boss
			local removedBoss
			local outBosses = {Pool = {}}
			for _, bossID in ipairs(bosses.Pool or bosses) do
				local poolEntry
				if type(bossID) == "table" then
					poolEntry = bossID
					bossID = bossID.BossID
				end

				local bossData = StageAPI.GetBossData(bossID)
				local level = game:GetLevel()
				local levelstage = level:GetStage()
				local stagetype = level:GetStageType()
				local remove
				--Remove doesn't remove the base boss from appearing
				--It removes OUR boss from appearing
				if bossData then
					if bossData.IsFFBoss then
						if roomDesc.Data.Subtype == 22 then -- headless horseman
							remove = true
						elseif bossID == "Cacamancer" and roomDesc.Data.Subtype == 97 then -- turdlet
							remove = true
						elseif FiendFolio.BossPoolOverhaulEnabled then
							if levelstage == LevelStage.STAGE3_1 and stagetype == StageType.STAGETYPE_AFTERBIRTH and
							   (roomDesc.Data.Subtype == BossType.GISH or roomDesc.Data.Subtype == BossType.BROWNIE)
							then
								-- dank depths: pollution, junkstrap, tsar, gish, brownie, mom
								remove = true
							elseif levelstage == LevelStage.STAGE4_1 and stagetype == StageType.STAGETYPE_AFTERBIRTH and
							       (roomDesc.Data.Subtype == BossType.LOKII or roomDesc.Data.Subtype == BossType.MEGA_GURDY or roomDesc.Data.Subtype == BossType.MATRIARCH)
							then
								-- scarred womb: cacophobia, propaganda, lokii, mama gurdy, matriarch
								remove = true
							end
						end
					elseif FiendFolio.BossPoolOverhaulEnabled and bossData.BaseGameBoss then
						if levelstage == LevelStage.STAGE3_1 and stagetype == StageType.STAGETYPE_AFTERBIRTH and
						   roomDesc.Data.Subtype ~= BossType.GISH and roomDesc.Data.Subtype ~= BossType.BROWNIE and
						   bossID ~= "Mom"
						then
							-- dank depths: pollution, junkstrap, tsar, gish, brownie
							remove = true
						elseif levelstage == LevelStage.STAGE4_1 and stagetype == StageType.STAGETYPE_AFTERBIRTH and
						       roomDesc.Data.Subtype ~= BossType.LOKII and roomDesc.Data.Subtype ~= BossType.MEGA_GURDY and roomDesc.Data.Subtype ~= BossType.MATRIARCH and
						       bossID ~= "It Lives" and bossID ~= "Mom's Heart"
						then
							-- scarred womb: cacophobia, propaganda, lokii, mama gurdy, matriarch
							remove = true
						end
					end
				end

				if remove then
					removedBoss = true
				else
					outBosses.Pool[#outBosses.Pool + 1] = poolEntry
				end
			end

			if removedBoss then
				return outBosses
			end
		end
	end)
end

mod:AddCallback(ModCallbacks.MC_PRE_BOSS_SELECT, function(_, bossType, pool, levelstage, stagetype)
	if FiendFolio.BossPoolOverhaulEnabled then
		-- removing certain basegame bosses from the running
		local badBossIDs = {}
		if levelstage == LevelStage.STAGE4_1 and stagetype == StageType.STAGETYPE_AFTERBIRTH then
			badBossIDs[BossType.MR_FRED] = true
		end

		FiendFolio.savedata.run.customRemovedBosses = FiendFolio.savedata.run.customRemovedBosses or {}
		if badBossIDs[bossType] or FiendFolio.savedata.run.customRemovedBosses[bossType] then
			local bosses = pool:GetEntries()
			local removedBosses = BossPoolManager.GetRemovedBosses()
			local remainingBosses = {}
			for _, boss in ipairs(bosses) do
				if not (badBossIDs[boss.bossID] or removedBosses[boss.bossID] or FiendFolio.savedata.run.customRemovedBosses[boss.bossID]) then
					table.insert(remainingBosses, boss)
				end
			end

			local bossesToRoll = bosses
			if #remainingBosses > 0 then
				bossesToRoll = remainingBosses
			end
			local combinedWeight = 0
			local overflowBosses = {}
			for _, boss in ipairs(bossesToRoll) do
				if not badBossIDs[boss.bossID] then
					combinedWeight = combinedWeight + boss.weight
					table.insert(overflowBosses, boss)
				end
			end

			local level = game:GetLevel()
			local rng = RNG()
			rng:SetSeed(math.max(level:GetDungeonPlacementSeed(), 1), 53)
			local roll = rng:RandomFloat() * combinedWeight
			for _, boss in ipairs(bossesToRoll) do
				if not badBossIDs[boss.bossID] then
					if roll <= boss.weight then
						FiendFolio.savedata.run.customRemovedBosses[boss.bossID] = true
						return boss.bossID
					else
						roll = roll - boss.weight
					end
				end
			end
			return overflowBosses[1].bossID
		end
	end
end)

--Choose boss, boss choose, bosschoice, bosschoose, chooseboss, boss pool, bosspool just some nice keywrods
function mod:BossRoomFunTime()
	-- todo check for FF champs?
	local game = Game()
	local room = game:GetRoom()

	if StageAPI
	and not StageAPI.InTestMode
	and not game:IsGreedMode()
	and not (
		game:GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH_INIT)
		or game:GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH)
	)
	and room:GetType() == RoomType.ROOM_BOSS
	and room:IsFirstVisit()
	and not StageAPI.InNewStage()
	and not StageAPI.GetCurrentRoom() then
		--Isaac.ConsoleOutput("About to check \n")
		if mod.ModeEnabled == 2 then -- This is literally the only thing this callback does now
			StageAPI.SetCurrentBossRoom("Ghostse", true)
		end
	end
end

mod.roomBackdropTable = {
	mod.DankerBackdrop,
	mod.SmokyBackdrop,
	mod.PipesBackdrop,
	mod.HoneyedCellarBackdrop,
	mod.EyeballUteroBackdrop,
	mod.PrimordialBackdrop,
	mod.ChallengeBackdrop,
	mod.TrashDankDepthsBackdrop,
	mod.PeepeeBackdrop,
	mod.MorbusBackdrop,
	mod.MausoleumAltBackdrop,
	mod.RiskRewardBackdrop,
	mod.IrradiatedAshpitNoAshBackdrop,
	mod.SurrealSheolBackdrop,
	mod.MadommeBackdrop,
}

function mod.ReplaceCrawlspaceTileGfx(path)
	local room = game:GetRoom()
	for i = 0, room:GetGridSize()-1 do
		local grid = room:GetGridEntity(i)
		-- metal blocks, which become walls
		-- decorations, i.e. ladders
		-- gravity squares where the floor is, with the anm2 loaded
		if grid then
			local type = grid:GetType()
			local isKeyBlock = mod.IsKeyBlock(grid)
			if isKeyBlock then
				-- do nothing
			elseif type == GridEntityType.GRID_WALL
			or type == GridEntityType.GRID_DECORATION
			or (type == GridEntityType.GRID_GRAVITY and grid:GetSprite():GetFilename() ~= "") then
				local sprite = grid:GetSprite()
				sprite:ReplaceSpritesheet(0, path)
				sprite:LoadGraphics()
			end
		end
	end
end

-- for any rooms that require more backdrop fuckery than what stageapi provides
mod.specialRoomBackdropTable = {
	[50] = function()
		-- the gravity tiles don't have updated sprites in post new room,
		-- so delay gfx replacement until input action, which comes BEFORE render
		mod.scheduleForUpdate(function()
			mod.ReplaceCrawlspaceTileGfx('gfx/grid/tiles_itemdungeon_luscious.png')
		end, 1, ModCallbacks.MC_INPUT_ACTION, true)
		return mod.CrawlspaceBackdropLuscious
	end,
	[51] = function()
		mod.scheduleForUpdate(function()
			mod.ReplaceCrawlspaceTileGfx('gfx/grid/tiles_itemdungeon_ossuary.png')
		end, 1, ModCallbacks.MC_INPUT_ACTION, true)
		return mod.CrawlspaceBackdropOssuary
	end,
	[52] = function()
		mod.scheduleForUpdate(function()
			mod.ReplaceCrawlspaceTileGfx('gfx/grid/tiles_itemdungeon_pipes.png')
		end, 1, ModCallbacks.MC_INPUT_ACTION, true)
		return mod.CrawlspaceBackdrop
	end,
	[53] = function()
		mod.scheduleForUpdate(function()
			mod.ReplaceCrawlspaceTileGfx('gfx/grid/tiles_itemdungeon_creature.png')
		end, 1, ModCallbacks.MC_INPUT_ACTION, true)
		return mod.CrawlspaceBackdrop
	end,
	[54] = function()
		mod.scheduleForUpdate(function()
			mod.ReplaceCrawlspaceTileGfx('gfx/grid/tiles_itemdungeon_fortress.png')
		end, 1, ModCallbacks.MC_INPUT_ACTION, true)
		return mod.CrawlspaceBackdropFortress
	end,
	[55] = function()
		mod.scheduleForUpdate(function()
			mod.ReplaceCrawlspaceTileGfx('gfx/grid/tiles_itemdungeon_insulation.png')
		end, 1, ModCallbacks.MC_INPUT_ACTION, true)
		return mod.CrawlspaceBackdropInsulation
	end,
}

mod.RandomFreakingRocks = {
	"gfx/grid/rocks_ashpit.png",
	"gfx/grid/rocks_basement.png",
	"gfx/grid/rocks_bluewomb.png",
	"gfx/grid/rocks_burningbasement.png",
	"gfx/grid/rocks_catacombs.png",
	"gfx/grid/rocks_cathedral.png",
	"gfx/grid/rocks_caves.png",
	"gfx/grid/rocks_cellar.png",
	"gfx/grid/rocks_corpse.png",
	"gfx/grid/rocks_corpse2.png",
	"gfx/grid/rocks_corpse3.png",
	"gfx/grid/rocks_corpseentrance.png",
	"gfx/grid/rocks_depths.png",
	"gfx/grid/rocks_downpour.png",
	"gfx/grid/rocks_dross.png",
	"gfx/grid/rocks_drownedcaves.png",
	"gfx/grid/rocks_gehenna.png",
	"gfx/grid/rocks_mausoleum.png",
	"gfx/grid/rocks_scarredwomb.png",
	"gfx/grid/rocks_secretroom.png",
	"gfx/grid/rocks_sheol.png",
	"gfx/grid/rocks_utero.png",
	"gfx/grid/rocks_womb.png",
	"gfx/grid/hive_rocks.png",
	"gfx/grid/rock_challenge_placeholderrecolor.png",
	"gfx/grid/rocks_arcade.png",
	"gfx/grid/rocks_ashpit_irradiated.png",
	"gfx/grid/rocks_chest.png",
	"gfx/grid/rocks_crawlspace.png",
	"gfx/grid/rocks_crawlspace_fortress.png",
	"gfx/grid/rocks_crawlspace_insulation.png",
	"gfx/grid/rocks_crawlspace_luscious.png",
	"gfx/grid/rocks_crawlspace_ossuary.png",
	"gfx/grid/rocks_d12.png",
	"gfx/grid/rocks_dankdepths.png",
	"gfx/grid/rocks_darkroom.png",
	"gfx/grid/rocks_depths_custom.png",
	"gfx/grid/rocks_dice.png",
	"gfx/grid/rocks_downpour_entrance.png",
	"gfx/grid/rocks_ed12.png",
	"gfx/grid/rocks_error-1.png.png",
	"gfx/grid/rocks_honeyedcellar.png",
	"gfx/grid/rocks_library.png",
	"gfx/grid/rocks_mausoleumb.png",
	"gfx/grid/rocks_necropolis.png",
	"gfx/grid/rocks_peepee.png",
	"gfx/grid/rocks_pipes.png",
	"gfx/grid/rocks_primitive.png",
	"gfx/grid/rocks_psionic.png",
	"gfx/grid/rocks_saloon.png",
	"gfx/grid/rocks_secret.png",
	"gfx/grid/rocks_secretroom_mines_entrance.png",
	"gfx/grid/rocks_sheol_surreal.png",
	"gfx/grid/rocks_shop.png",
	"gfx/grid/rocks_trash.png",
	"gfx/grid/rocks_utero_ab+_palette.png",
	"gfx/grid/rocks_vanilla.png",
	"gfx/grid/smoky_rocks.png",
	"gfx/grid/morbus/morbus_rocks.png",
	"gfx/grid/morbus/morbus_rocks_old.png",
	"gfx/grid/mammonite dimension/rocks_crawlspace_mammonite.png",
	"gfx/grid/mammonite dimension/rocks_mammonite.png",
	"gfx/secret/shhhhh/nothing to see here/Laboratory_Rocks_ab+.png",
	"gfx/secret/shhhhh/nothing to see here/morbusRealRocks.png",
}

mod.RandomFreakingPits = {
	{"gfx/grid/grid_pit.png"},
	{"gfx/grid/grid_pit_water.png"},

	{"gfx/grid/pit_basement.png", true},
	{"gfx/grid/pit_cellar.png"},
	{"gfx/grid/pit_burningbasement.png"},
	{"gfx/grid/pit_smoky.png"},
	{"gfx/grid/grid_pit_downpour_large.png", true},
	{"gfx/grid/grid_pit_downpour_water.png"},
	{"gfx/grid/grid_pit_downpour_large_entrance.png", true},
	{"gfx/grid/grid_pit_dross_large.png", true},

	{"gfx/grid/grid_primitive_pit.png"},
	{"gfx/grid/grid_primordial_pit.png"},
	{"gfx/grid/grid_pit_catacombs.png"},
	{"gfx/grid/grid_pit_water_catacombs.png"},
	{"gfx/grid/grid_floodedcaves_pit.png"},
	{"gfx/grid/grid_pit_mines_large.png", true},
	{"gfx/grid/grid_pit_mines_entrance_large.png", true},
	{"gfx/grid/grid_pit_mines_water_large.png", true},
	{"gfx/grid/grid_pit_mines_cursed_large.png", true},
	{"gfx/grid/grid_pit_ashpit.png"},
	{"gfx/grid/grid_pit_ashpit_ash.png"},
	{"gfx/grid/grid_pit_ashpit_irradiated.png"},

	{"gfx/grid/grid_depths_pit_large.png", true},
	{"gfx/grid/grid_necropolis_pit_large.png", true},
	{"gfx/grid/grid_dankdepths_pit_large.png", true},
	{"gfx/grid/grid_dankdepths_pit_large_water.png", true},
	{"gfx/grid/grid_pipe_pit.png", true},
	{"gfx/grid/grid_pipe_pit_alt.png", true},
	{"gfx/grid/grid_pipe_pit_filled.png", true},
	{"gfx/grid/grid_pit_mausoleum_large.png", true},
	{"gfx/grid/grid_pit_mausoleumb_large.png", true},
	{"gfx/grid/grid_pit_gehenna_large.png", true},

	{"gfx/grid/grid_pit_womb.png"},
	{"gfx/grid/grid_pit_acid_womb.png"},
	{"gfx/grid/grid_pit_blood_womb.png"},
	{"gfx/grid/grid_utero_pit_large.png", true},
	{"gfx/grid/grid_utero_pit_large_ab+.png", true},
	{"gfx/grid/grid_uteroblood_pit_large.png", true},
	{"gfx/grid/grid_uteroacid_pit_large.png", true},
	{"gfx/grid/grid_scarredwomb_pit.png", true},
	{"gfx/grid/grid_pit_blood_scarredwomb.png"},
	{"gfx/grid/grid_pit_bluewomb.png"},
	{"gfx/grid/grid_pit_corpse_large.png", true},
	{"gfx/grid/grid_pit_corpse2_large.png", true},
	{"gfx/grid/grid_pit_corpse3_large.png", true},
	{"gfx/grid/grid_pit_blood_corpse.png", true},
	{"gfx/grid/grid_pit_blood_corpse2.png", true},
	{"gfx/grid/grid_pit_corpseentrance.png"},

	{"gfx/grid/grid_sheol_pit.png"},
	{"gfx/grid/grid_cathedral_pit_large.png", true},

	{"gfx/grid/grid_pit_darkroom.png"},
	{"gfx/grid/grid_chest_pit.png", true},
	{"gfx/grid/grid_chest_pit_alt.png", true},

	{"gfx/grid/grid_planetarium_pit.png", true},
	{"gfx/grid/grid_secret_pit_large.png", true},
	{"gfx/grid/pit_arcade.png"},
	{"gfx/grid/pit_challenge_placeholderrecolor.png", true},
	{"gfx/grid/pit_d12.png", true},
	{"gfx/grid/pit_dice.png", true},
	{"gfx/grid/grid_pit_blood_sacrifice.png"},

	{"gfx/secret/shhhhh/nothing to see here/Laboratory_Pit.png"},
	{"gfx/secret/shhhhh/nothing to see here/Laboratory_Pit_BioFuel.png"},
}

local BackdropRNG = RNG()
function mod:getCurrentRoomGfx()
	if mod.roomBackdrop then
		if mod.roomBackdrop > 0 and mod.roomBackdropTable[mod.roomBackdrop] then
			local room = game:GetRoom()
			BackdropRNG:SetSeed(room:GetDecorationSeed(), 35)
			if Isaac.GetChallenge() == Challenge.CHALLENGE_DELETE_THIS then
				return mod.roomBackdropTable[BackdropRNG:RandomInt(#mod.roomBackdropTable) + 1]
			elseif mod.roomBackdrop == 13 then --Irradiated Ashpit special handling
				if room:HasWaterPits() then --Check for ash floor
					return mod.IrradiatedAshpitFullAshBackdrop
				else
					if BackdropRNG:RandomFloat() <= 0.5 then
						return mod.IrradiatedAshpitPartialAshBackdrop
					else
						return mod.IrradiatedAshpitNoAshBackdrop
					end
				end
			else
				return mod.roomBackdropTable[mod.roomBackdrop]
			end
		elseif mod.roomBackdrop > 0 and mod.specialRoomBackdropTable[mod.roomBackdrop] then
			return mod.specialRoomBackdropTable[mod.roomBackdrop]
		else
			return mod.HiveBackdrop
		end
	else
		local level = game:GetLevel()
		local room = game:GetRoom()
		if level:GetStage() == LevelStage.STAGE7 then
			-- on void go fucking CRAZY
			grng:SetSeed(room:GetDecorationSeed(), 0)
			local gridgfx = StageAPI.GridGfx()
			gridgfx.Rocks = mod.RandomFreakingRocks[grng:RandomInt(#mod.RandomFreakingRocks) + 1]
			--gridgfx.PitFiles = mod.FloorGrids[grng:RandomInt(#mod.FloorGrids) + 1].PitFiles
			--gridgfx.AltPitFiles = mod.FloorGrids[grng:RandomInt(#mod.FloorGrids) + 1].AltPitFiles
			local randomPit = mod.RandomFreakingPits[grng:RandomInt(#mod.RandomFreakingPits) + 1]
			gridgfx:SetPits(randomPit[1], nil, randomPit[2])
			gridgfx.Decorations = mod.FloorGrids[grng:RandomInt(#mod.FloorGrids) + 1].Decorations
			gridgfx:SetBridges(mod.RandomFreakingRocks[grng:RandomInt(#mod.RandomFreakingRocks) + 1])
			return StageAPI.RoomGfx(nil, gridgfx, nil, nil)
		end

		local roomType = room:GetType()
		local backdropType = game:GetRoom():GetBackdropType()
		local existingGfx = (StageAPI.GetCurrentRoom() and StageAPI.GetCurrentRoom().Data.RoomGfx)
		if roomType == RoomType.ROOM_SECRET then
			return mod.SecretBackdrop
		elseif roomType == RoomType.ROOM_DUNGEON then
			return mod.CrawlspaceBackdrop
		elseif (roomType == RoomType.ROOM_CHALLENGE or roomType == RoomType.ROOM_BOSSRUSH) and not existingGfx  then
			return mod.ChallengeBackdrop
		elseif backdropType == 35 then
			--Requested by gummy
			return mod.PlanetariumBackdrop
		elseif not existingGfx then
			if backdropType == 1 then
				return mod.BasementBackdrop
			elseif backdropType == 2 then
				return mod.CellarBackdrop
			elseif backdropType == 3 then
				return mod.BBBackdrop
			elseif backdropType == 5 then
				return mod.CataBackdrop
			elseif backdropType == 6 then
				return mod.FloodedBackdrop
			elseif backdropType == 7 and roomType ~= RoomType.ROOM_SACRIFICE then
				return mod.DepthsBackdrop
			elseif backdropType == 8 then
				return mod.NecropolisBackdrop
			elseif backdropType == 9 then
				return mod.DankDepthsBackdrop
			elseif backdropType == 11 then
				return mod.UteroBackdrop
			elseif backdropType == 12 then
				return mod.ScarredWombBackdrop
			elseif backdropType == 14 and roomType ~= RoomType.ROOM_CHALLENGE and roomType ~= RoomType.ROOM_BOSSRUSH then
				return mod.SheolBackdrop
			elseif backdropType == 15 then
				return mod.CathBackdrop
			elseif backdropType == 16 then
				return mod.DarkRoomBackdrop
			elseif backdropType == 17 then
				return mod.ChestBackdrop
			elseif backdropType == 19 then
				return mod.LibraryBackdrop
			elseif backdropType == 21 or backdropType == 22 then
				return mod.CellarBackdrop
			elseif backdropType == 20 or backdropType == 28 then
				return mod.ShopBackdrop
			elseif backdropType == 24 then
				math.randomseed(game:GetRoom():GetSpawnSeed())
				if math.random(7) == 7 then
					return mod.D12BackdropExt
				else
					return mod.DiceBackdrop
				end
			elseif backdropType == 25 then
				return mod.ArcadeBackdrop
			elseif backdropType == 26 then
				return mod.ErrorBackdrop
			elseif backdropType == BackdropType.DOWNPOUR then
				if room:HasWater() then
					return mod.DownpourBackdrop
				else
					return mod.DownpourDryBackdrop
				end
			elseif backdropType == BackdropType.DOWNPOUR_ENTRANCE then
				if room:HasWater() then
					return mod.DownpourEntranceWetBackdrop
				else
					return mod.DownpourEntranceBackdrop
				end
			elseif backdropType == BackdropType.MINES_SHAFT or backdropType == BackdropType.ASHPIT_SHAFT then
				if level:GetStateFlag(LevelStateFlag.STATE_MINESHAFT_ESCAPE) then
					return mod.MinesChaseBackdrop
				else
					return mod.MinesBackdrop
				end
			elseif backdropType == BackdropType.MINES then
				return mod.MinesBackdrop
			elseif backdropType == BackdropType.SECRET and roomType == RoomType.ROOM_SECRET_EXIT then
				return mod.MinesEntranceBackdrop
			elseif backdropType == BackdropType.MAUSOLEUM or backdropType == BackdropType.MAUSOLEUM_ENTRANCE then
				return mod.MausoleumBackdrop
			elseif backdropType == BackdropType.CORPSE then
				return mod.CorpseBackdrop3
			elseif backdropType == BackdropType.CORPSE2 then
				return mod.CorpseBackdrop1
			elseif backdropType == BackdropType.CORPSE3 then
				return mod.CorpseBackdrop2
			elseif backdropType == BackdropType.DROSS then
				return mod.DrossBackdrop
			elseif backdropType == BackdropType.GEHENNA then
				return mod.GehennaBackdrop
			elseif backdropType == BackdropType.ISAACS_BEDROOM or backdropType == BackdropType.HALLWAY then
				return mod.CellarBackdrop
			elseif backdropType == BackdropType.MOMS_BEDROOM then
				return mod.ArcadeBackdrop
			end
		end
	end
end

function mod:backdropReplacer()
	if StageAPI then
		if mod.roomBackdrop and mod.roomBackdropFrom then
			if game:GetLevel():GetCurrentRoomDesc().ListIndex ~= mod.roomBackdropFrom
			or StageAPI.GetCurrentRoom() ~= mod.roomBackdropFromStageAPI
			or game:GetSeeds():GetStageSeed(game:GetLevel():GetStage()) ~= mod.roomBackdropFromLevel then
				mod.roomBackdrop = nil
				mod.roomBackdropFrom = nil
				mod.roomBackdropFromStageAPI = nil
				mod.roomBackdropFromLevel = nil
			end
		end

		mod.necroreplacin = false
		if mod.ModeEnabled == 1 then
			StageAPI.ChangeRoomGfx(mod.HiveBackdrop)
		elseif mod.ModeEnabled == 2 then
			StageAPI.ChangeRoomGfx(mod.HappyFunTimeBackdrop)
			if not sfx:IsPlaying(mod.Sounds.Uke) then
				sfx:Play(mod.Sounds.Uke, 2, 0, false, 1)
				MusicManager():Pause()
				MusicManager():Disable()
			end
		else
			local roomGfx = mod:getCurrentRoomGfx()
			if roomGfx then
				if type(roomGfx) == "function" then
					local outGfx = roomGfx()
					if outGfx then
						StageAPI.ChangeRoomGfx(outGfx)
					end
				else
					StageAPI.ChangeRoomGfx(roomGfx)
				end
			end
		end
	end
end

function FiendFolio.sign(val)
	return val == 0 and 0 or (val > 0 and 1 or -1)
end

function FiendFolio.GetCardinal(vec)
	if math.abs(vec.X) > math.abs(vec.Y) then
		return Vector(FiendFolio.sign(vec.X), 0)
	else
		return Vector(0, FiendFolio.sign(vec.Y))
	end
end

--[[
function FiendFolio.onEntityTick(type, fn, variant, subtype)
	mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
		local found = Isaac.FindByType(type, variant or -1, subtype or -1, false, false)
		for _, ent in ipairs(found) do
			fn(ent)
		end
	end)
end

function FiendFolio.onMachineTouchOld(variant, fn)
	mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, p)
		if p:IsCoopGhost() then
			return
		end

		local slots = Isaac.FindByType(EntityType.ENTITY_SLOT, variant or -1, -1, false, false)
		for _, slot in ipairs(slots) do
			if mod:GetEntityData(slot).sizeMulti then
				if (math.abs(slot.Position.X-p.Position.X) ^ 2 <= (slot.Size*slot.SizeMulti.X + p.Size) ^ 2) and (math.abs(slot.Position.Y-p.Position.Y) ^ 2 <= (slot.Size*slot.SizeMulti.Y + p.Size) ^ 2) then
					fn(p, slot)
				end
			else
				if slot.Position:DistanceSquared(p.Position) <= (slot.Size + p.Size) ^ 2 then
					fn(p, slot)
				end
			end
		end
	end)
end
]]

function mod:SlotUpdate(slot)
	local data = mod:GetEntityData(slot)
	mod:brownHornEntityUpdate(slot, data)
	mod:ArcadeRockSlotUpdate(slot, data)
	mod:goldenWatchSlotUpdate(slot, data)
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.SlotUpdate)

function FiendFolio.onMachineTouch(variant, fn)
	mod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, function(_, slot, collider, low)
		local p = collider:ToPlayer()
		if not p then return end
		if p:IsCoopGhost() then
			return
		end
		fn(p, slot)
	end, variant)
end

function mod:resetDeliriumRoom()
	mod.IsDeliriumRoom = false
end
mod:AddCallback(ModCallbacks.MC_PRE_NEW_ROOM, mod.resetDeliriumRoom)


--Debug Commands
function FFCharm()
	local player = Isaac.GetPlayer(0)
	for _,entity in ipairs(Isaac.GetRoomEntities()) do
		if entity:IsActiveEnemy() then
			entity:AddCharmed(EntityRef(player), 6000)
		end
	end
end
function FFFriend()
	local player = Isaac.GetPlayer(0)
	for _,entity in ipairs(Isaac.GetRoomEntities()) do
		if entity:IsActiveEnemy() then
			entity:AddCharmed(EntityRef(player), -1)
		end
	end
end
function FFFear()
	local player = Isaac.GetPlayer(0)
	for _,entity in ipairs(Isaac.GetRoomEntities()) do
		if entity:IsActiveEnemy() then
			entity:AddFear(EntityRef(player), 6000)
		end
	end
end
function FFConfuse()
	local player = Isaac.GetPlayer(0)
	for _,entity in ipairs(Isaac.GetRoomEntities()) do
		if entity:IsActiveEnemy() then
			entity:AddConfusion(EntityRef(player), 6000, false)
		end
	end
end
function FFSlow()
	local player = Isaac.GetPlayer(0)
	for _, entity in ipairs(Isaac.GetRoomEntities()) do
		if entity:IsActiveEnemy() then
			entity:AddSlowing(EntityRef(player), 6000, 0.5, Color(0.5,0.5,0.5), true)
		end
	end
end
function FFFreeze()
	local player = Isaac.GetPlayer(0)
	for _, entity in ipairs(Isaac.GetRoomEntities()) do
		if entity:IsActiveEnemy() then
			entity:AddFreeze(EntityRef(player), 60, true)
		end
	end
end

function ffbackdrop(backdropValue)
	if StageAPI then
		if backdropValue and backdropValue > 0 and mod.roomBackdropTable[backdropValue] then
			StageAPI.ChangeRoomGfx(mod.roomBackdropTable[backdropValue])
		elseif backdropValue and backdropValue > 0 and mod.specialRoomBackdropTable[backdropValue] then
			return mod.specialRoomBackdropTable[backdropValue]()
		else
			StageAPI.ChangeRoomGfx(mod.HiveBackdrop)
		end
	end
end
function ffdebug()
	if StageAPI then
		StageAPI.ChangeRoomGfx(mod.DebugBackdrop)
	end
end

function mod.FFCommands(_, cmd, params)
	if cmd == "charmall" then
		FFCharm()
	elseif cmd == "fireall" then
		mod:SetRoomAlight()
	elseif cmd == "friendall" then
		FFFriend()
	elseif cmd == "fearall" then
		FFFear()
	elseif cmd == "confuseall" then
		FFConfuse()
	elseif cmd == "slowall" then
		FFSlow()
	elseif cmd == "freezeall" then
		FFFreeze()
	elseif cmd == "forcestate" then
		for _,entity in ipairs(Isaac.GetRoomEntities()) do
			if entity:IsEnemy() then
				mod:GetEntityData(entity).state = params
			end
		end
	elseif cmd == "dmgplayer" then
		-- damages player 1 in 3 frames
		mod.scheduleForUpdate(function()
			Isaac.GetPlayer(0):TakeDamage(1, 0, EntityRef(nil), 0)
		end, 3)
	elseif cmd == 'forceffboss' then
		FiendFolio.ForceBosses = not FiendFolio.ForceBosses
		print('Toggling force FiendFolio bosses, new value:', FiendFolio.ForceBosses)
	elseif cmd == 'forcemo' then
		FiendFolio.ForceMo = not FiendFolio.ForceMo
		print('Toggling force Mo, new value:', FiendFolio.ForceMo)
	elseif cmd == "bgdebug" then
		print('replacing bg via stageapi')
		ffdebug()
	elseif cmd == "thumbsup" then
		if params and tonumber(params) then
			for i = 1, params do
				Isaac.GetPlayer():AnimateHappy()
			end
		else
			Isaac.GetPlayer():AnimateHappy()
		end
	elseif cmd == "thumbsdown" then
		if params and tonumber(params) then
			for i = 1, params do
				Isaac.GetPlayer():AnimateSad()
			end
		else
			Isaac.GetPlayer():AnimateSad()
		end
	elseif cmd == "friendfinderfftest" then
		local player = Isaac.GetPlayer()
		player:UseActiveItem(CollectibleType.COLLECTIBLE_FRIEND_FINDER, UseFlag.USE_NOANIM)
		mod.scheduleForUpdate(function()
			for index,entity in ipairs(Isaac.FindInRadius(player.Position, 50, EntityPartition.ENEMY)) do
				if entity.FrameCount < 2 then
					entity:ToNPC():Morph(mod.FF.Slammer.ID, mod.FF.Slammer.Var,0,-1)
				end
			end
		end, 1)
	elseif cmd == "healenemies" then
		for _, entity in ipairs(Isaac.GetRoomEntities()) do
			if entity:IsEnemy() then
				entity.HitPoints = entity.MaxHitPoints
			end
		end
	end
	mod:erflyCommandShit(cmd, params)
	mod:ferriumCommands(cmd, params)
end

mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, mod.FFCommands)

--Functions
function mod:intercept(npc, target, v)
	local newtarget = target.Position + target.Velocity*5
	local tx = newtarget.X - npc.Position.X
	local ty = newtarget.Y - npc.Position.Y
	local tvx = target.Velocity.X
	local tvy = target.Velocity.Y

  -- Get quadratic equation components
	local a = tvx*tvx + tvy*tvy - v*v
	local b = 2 * (tvx * tx + tvy * ty)
	local c = tx*tx + ty*ty

  -- Solve quadratic
	local ts = mod:quadratic(a, b, c) --See quad(), below

  -- Find smallest positive solution
	local sol = target.Position
	if ts then
		local t0 = ts[1]
		local t1 = ts[2]
		local t = math.min(t0, t1)
		if (t < 0) then
			t = math.max(t0, t1)
		end
		if (t > 0) then
			sol = Vector((tx + tvx*t),(ty + tvy*t))
		end
	end

  return sol
end

-- Return solutions for quadratic
function mod:quadratic(a, b, c)
  local sqr_delta = math.sqrt(b * b - 4 * a * c)
  local two_a = 2 * a
  return {(-b + sqr_delta)/two_a, (-b - sqr_delta)/two_a}
end

--Round
function mod:LuaRound(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

local toRadians = math.pi / 180
function mod:PointOnEllipse(width,height,angle,rotation)
	angle, rotation = angle * toRadians, rotation * toRadians
	local x = width * math.cos(angle) * math.cos(rotation) - height * math.sin(angle) * math.sin(rotation)
	local y = width * math.cos(angle) * math.sin(rotation) + height * math.sin(angle) * math.cos(rotation)
	return Vector(x, y)
end

function mod:AngleDifference(a1, a2)
	local sub = a1 - a2
	return (sub + 180) % 360 - 180
end

function mod:levelHasCurse(level, curse, curseMask)
    if level == nil then return false end
    if curse == -1 then return false end
    if curseMask == nil then curseMask = level:GetCurses() end
    return curseMask & (1 << curse - 1) >= (1 << curse - 1)
end

function mod:levelHasAnyFFCurse(level, mask)
    if level == nil then return false end
    for _, c in pairs(FiendFolio.curses) do
        if mod:levelHasCurse(level, c, mask) then return true end
    end
    return false
end

function mod:anyPlayerIsEitherKeeper()
	return PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_KEEPER) or PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_KEEPER_B)
end

function mod:anyPlayerIsBKeeper()
	return PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_KEEPER_B)
end

function mod:allPlayersAreKeeper()
	for i = 1, game:GetNumPlayers() do
		local player = Isaac.GetPlayer(i - 1)

		if player:GetPlayerType() ~= PlayerType.PLAYER_KEEPER_B and player:GetPlayerType() ~= PlayerType.PLAYER_KEEPER then
			return false
		end
	end

	return true
end

function mod:isAnyoneNotKeeper()
	for i = 1, game:GetNumPlayers() do
		local player = Isaac.GetPlayer(i - 1)
		local playerType = player:GetPlayerType()

		if player.Variant == 0 and playerType ~= PlayerType.PLAYER_KEEPER and playerType ~= PlayerType.PLAYER_KEEPER_B then
			return true
		end
	end
	return false
end

function mod:allPlayersAreBBlueBaby()
	for i = 1, game:GetNumPlayers() do
		local player = Isaac.GetPlayer(i - 1)

		if player:GetPlayerType() ~= PlayerType.PLAYER_XXX_B then
			return false
		end
	end

	return true
end

function mod:isSuperpositionedPlayer(player)
	if player then
		if REPENTOGON then
			return player:IsHologram()
		else
			local playertype = player:GetPlayerType()
			if playertype == PlayerType.PLAYER_LAZARUS_B or playertype == PlayerType.PLAYER_LAZARUS2_B then
				if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) or
				(player:GetOtherTwin() and player:GetOtherTwin():HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT))
				then
					local maintwin = player:GetMainTwin()
					if maintwin.Index ~= player.Index or maintwin.InitSeed ~= player.InitSeed then
						return true
					end
				end
			end
		end
	end
	return false
end

function mod:isKingBabyAParent(entity, returnTarget)
	if entity and entity.Parent then
		while entity.Parent do
			entity = entity.Parent
			if entity.Type == 3 and entity.Variant == FamiliarVariant.KING_BABY then
				if returnTarget then
					return entity.Target
				else
					return entity
				end
			end
		end
	end
	return false
end

function mod:getClosestPlayer(pos, dist, seedPass)
	local closestDist = dist + 1
	local closestPlayer = nil

	for i = 1, game:GetNumPlayers() do
		local player = Isaac.GetPlayer(i - 1)
		local playerPosition = player.Position

		local dist = (playerPosition - pos):Length()
		if dist < closestDist and seedPass ~= player.InitSeed then
			closestDist = dist
			closestPlayer = player
		end
	end

	return closestPlayer
end

------------------------------------------------------

--StageID first,
mod.stageIDbackdropID = {
	["Flooded Caves"] = 	{StageID = 6, Backdrops = {6}},
	["Scarred Womb"] = 	{StageID = 12, Backdrops = {12}},
	["Downpour"] = 	{StageID = 27, Backdrops = {31, 36}},
	["Dross"] = 	{StageID = 28, Backdrops = {45}},
	["Mines"] = 	{StageID = 29, Backdrops = {32, 58}},
	["Ashpit"] = 	{StageID = 30, Backdrops = {46, 59}},
	["Maus"] = 		{StageID = 31, Backdrops = {33, 38, 40, 41, 42}}, --Extra :)
	["Mausoleum"] = {StageID = 31, Backdrops = {33, 38, 40, 41, 42}},
	["Gehenna"] = 	{StageID = 32, Backdrops = {47}},
	["Corpse"] = 	{StageID = 33, Backdrops = {34, 39, 43, 44, 56}}
}

function mod.isBackdrop(floorName, ignoreStage)
	if not ignoreStage then
		local level = Game():GetLevel()
		local currentStageID = level:GetRoomByIdx(level:QueryRoomTypeIndex(RoomType.ROOM_DEFAULT,nil,RNG())).Data.StageID
		if mod.stageIDbackdropID[floorName].StageID == currentStageID then
			return true
		end
	end

	local backdropID = Game():GetRoom():GetBackdropType()
	if mod.stageIDbackdropID[floorName] then
		for i = 1, #mod.stageIDbackdropID[floorName].Backdrops do
			if backdropID == mod.stageIDbackdropID[floorName].Backdrops[i] then
				return true
			end
		end
	end
end

local redHearts = {
	[HeartSubType.HEART_BLENDED] = true,
	[HeartSubType.HEART_HALF] = true,
	[HeartSubType.HEART_FULL] = true,
	[HeartSubType.HEART_DOUBLEPACK] = true,
	[HeartSubType.HEART_SCARED] = true
}

local soulHearts = {
	[HeartSubType.HEART_SOUL] = true,
	[HeartSubType.HEART_HALF_SOUL] = true,
	[HeartSubType.HEART_BLENDED] = true,
}

function mod.CanPurchasePickup(player, pickup)
	if pickup.Variant == PickupVariant.PICKUP_HEART then
		local isPickableRed = player:CanPickRedHearts() and redHearts[pickup.SubType]
		local isPickableSoul = player:CanPickSoulHearts() and soulHearts[pickup.SubType]
		local isPickableBone = player:CanPickBoneHearts() and pickup.SubType == HeartSubType.HEART_BONE
		local isPickableBlack = player:CanPickBlackHearts() and pickup.SubType == HeartSubType.HEART_BLACK
		local isPickableGolden = player:CanPickGoldenHearts() and pickup.SubType == HeartSubType.HEART_GOLDEN
		if (redHearts[pickup.SubType] or soulHearts[pickup.SubType] or pickup.SubType == HeartSubType.HEART_BONE or pickup.SubType == HeartSubType.HEART_BLACK or pickup.SubType == HeartSubType.HEART_GOLDEN)
		and not (isPickableRed or isPickableSoul or isPickableBone or isPickableBlack or isPickableGolden) then
			return false
		end
	elseif pickup.Variant == PickupVariant.PICKUP_LIL_BATTERY and not player:NeedsCharge() then
		return false
	elseif pickup.Variant == mod.PICKUP.VARIANT.HALF_BLACK_HEART and not player:CanPickBlackHearts() then
		return false
	elseif (pickup.Variant == mod.PICKUP.VARIANT.IMMORAL_HEART or pickup.Variant == mod.PICKUP.VARIANT.HALF_IMMORAL_HEART) and not mod:CanPickImmoralHearts(player) then
		return false
	elseif pickup.Variant == PickupVariant.PICKUP_TRINKET then
		if player:HasTrinket(pickup.SubType) then
			return false
		elseif player:GetMaxTrinkets() == 1 and player:GetTrinket(0) == TrinketType.TRINKET_TICK then
			return false
		end
	end

	return true
end

function mod.IsRevelationsStage()
	if REVEL and REVEL.STAGE then
		if REVEL.STAGE.Glacier and REVEL.STAGE.Glacier:IsStage() then
			return true, REVEL.STAGE.Glacier
		elseif REVEL.STAGE.Tomb and REVEL.STAGE.Tomb:IsStage() then
			return true, REVEL.STAGE.Tomb
		elseif REVEL.STAGE.Vestige and REVEL.STAGE.Vestige:IsStage() then
			return true, REVEL.STAGE.Vestige
		else
			return false
		end
	else
		return false
	end
end

function mod.IsFFGraceStage()
	if FFGRACE and FFGRACE.STAGE then
		if FFGRACE.STAGE.Boiler and FFGRACE.STAGE.Boiler:IsStage() then
			return true, FFGRACE.STAGE.Boiler
		elseif FFGRACE.STAGE.Grotto and FFGRACE.STAGE.Grotto:IsStage() then
			return true, FFGRACE.STAGE.Grotto
		end
	end
end

function mod.IsTheFuture()
	if TheFuture and TheFuture.Stage then
		if TheFuture.Stage:IsStage() then
			return true, TheFuture.Stage
		end
	end
end

function mod.IsLastJudgementStage()
	if LastJudgement and LastJudgement.STAGE then
		if LastJudgement.STAGE and LastJudgement.STAGE.Mortis:IsStage() then
			return true, LastJudgement.STAGE.Mortis
		end
	end
end

function mod.GatherGrids()
	local room = game:GetRoom()
	mod.RoomGrids = {}

	for i = 0, room:GetGridSize() do
		local g = room:GetGridEntity(i)
		if g then
			local typ = g:GetType()
			if g.CollisionClass ~= GridCollisionClass.COLLISION_NONE then
				mod.RoomGrids[typ] = mod.RoomGrids[typ] or {}
				mod.RoomGrids[typ][#mod.RoomGrids[typ] + 1] = g
			end
		end
	end
end

function mod.GetPoopSpritesheet(poop)
	local var = poop:GetVariant()
	if var == 0 then
		return "gfx/grid/grid_poop_"..math.random(3)..".png"
	elseif var == 1 then
		return "gfx/grid/grid_poop_red_"..math.random(3)..".png"
	elseif var == 2 then
		return "gfx/grid/grid_poop_corn.png"
	elseif var == 3 then
		return "gfx/grid/grid_poop_gold.png"
	elseif var == 4 then
		return "gfx/grid/grid_poop_rainbow.png"
	elseif var == 5 then
		return "gfx/grid/grid_poop_black.png"
	elseif var == 6 then
		return "gfx/grid/grid_poop_white_"..math.random(3)..".png"
	elseif var == 11 then
		return "gfx/grid/grid_poop_charming.png"
	end
end

function mod:getCrawlspaceBackdropSuffix()
	local suffix = "default"
	if mod.roomBackdrop == 50 or #Isaac.FindByType(mod.FF.BackdropReplacer.ID, mod.FF.BackdropReplacer.Var, 50) > 0 then
		suffix = "luscious"
	elseif mod.roomBackdrop == 51 or #Isaac.FindByType(mod.FF.BackdropReplacer.ID, mod.FF.BackdropReplacer.Var, 51) > 0 then
		suffix = "ossuary"
	elseif mod.roomBackdrop == 52 or #Isaac.FindByType(mod.FF.BackdropReplacer.ID, mod.FF.BackdropReplacer.Var, 52) > 0 then
		suffix = "pipes"
	elseif mod.roomBackdrop == 53 or #Isaac.FindByType(mod.FF.BackdropReplacer.ID, mod.FF.BackdropReplacer.Var, 53) > 0 then
		suffix = "creature"
	elseif mod.roomBackdrop == 54 or #Isaac.FindByType(mod.FF.BackdropReplacer.ID, mod.FF.BackdropReplacer.Var, 54) > 0 then
		suffix = "fortress"
	elseif mod.roomBackdrop == 55 or #Isaac.FindByType(mod.FF.BackdropReplacer.ID, mod.FF.BackdropReplacer.Var, 55) > 0 then
		suffix = "insulation"
	end
return suffix
end

local newANM2DungeonRocks = {
	[GridEntityType.GRID_ROCK] = true,
	[GridEntityType.GRID_ROCK_ALT] = true,
	[GridEntityType.GRID_ROCK_BOMB] = true,
	[GridEntityType.GRID_ROCKT] = true,
	[GridEntityType.GRID_ROCK_SS] = true,
	[GridEntityType.GRID_ROCK_SPIKED] = true,
	[GridEntityType.GRID_ROCK_GOLD] = true,
	[GridEntityType.GRID_PILLAR] = true,
	[GridEntityType.GRID_ROCK_ALT2] = true,
}

function mod.ExtraCrawlspaceGfx()
	local room = game:GetRoom()
	if StageAPI then
		if room:GetType() == RoomType.ROOM_DUNGEON then
			local e
			for i = 0, room:GetGridSize() do
				local g = room:GetGridEntity(i)

				if g then
					local gt = g:GetType()

					local suffix = mod:getCrawlspaceBackdropSuffix()
					if newANM2DungeonRocks[gt] then
						if not StageAPI.IsCustomGrid(i, "FFRubberRock") then
							local sprite = g:GetSprite()
							sprite:Load("gfx/grid/grid_rock_crawlspace.anm2")
							local frame = g.Desc.Variant
							local rockString = "_" .. suffix
							if rockString == "_default" or rockString == "_creature" or rockString == "_pipes" then
								rockString = ""
							end
							sprite:ReplaceSpritesheet(0, "gfx/grid/rocks_crawlspace" .. rockString .. ".png")
							sprite:LoadGraphics()
							--print(gt, g.Desc.Variant)
							if gt == GridEntityType.GRID_ROCK_BOMB then
								sprite:SetFrame("bombrock", 0, true)
							elseif gt == GridEntityType.GRID_ROCKT then
								sprite:SetFrame("tinted", 0, true)
							elseif gt == GridEntityType.GRID_ROCK_SS then
								sprite:SetFrame("superspecial", 0, true)
							elseif gt == GridEntityType.GRID_ROCK_ALT then
								--print(g.Desc.Variant)
								sprite:SetFrame("alt", frame, true)
							elseif gt == GridEntityType.GRID_ROCK_SPIKED then
								if g.Desc.State == 4 then
									sprite:SetFrame("spiked_retracted", frame, true)
								else
									sprite:SetFrame("spiked", frame, true)
								end
							elseif gt == GridEntityType.GRID_ROCK_GOLD then
								sprite:SetFrame("foolsgold", frame, true)
							elseif gt == GridEntityType.GRID_PILLAR then
								sprite:SetFrame("pillar", frame, true)
							elseif gt == GridEntityType.GRID_ROCK_ALT2 then
								sprite:SetFrame("alt2", 0, true)
							elseif frame >= 1000 then
								sprite:SetFrame("big", frame, true)
							else
								sprite:SetFrame("normal", frame, true)
							end
							--sprite:Play(anim, true)
							--sprite:SetFrame(anim, frame, true)
							--sprite:LoadGraphics()
						end
					end

					if FiendFolio.RequiresRocktops[g:GetType()] and
					   not StageAPI.IsCustomGrid(i, "FFRubberRock")
					then
						local g2 = room:GetGridEntityFromPos(g.Position + Vector(0, -40))
						if g2:GetType() == GridEntityType.GRID_GRAVITY then
							e = Isaac.Spawn(1000, Isaac.GetEntityVariantByName("Crawlspace Rocktop"), 0, g.Position + Vector(0, -80), nilvector, nil)
							mod:GetEntityData(e).myrock = g
							e.PositionOffset = Vector(0, 40)

							local esprite = e:GetSprite()
							esprite:ReplaceSpritesheet(0, "gfx/grid/rocktop grids/rocktop_" .. suffix .. ".png")
							esprite:LoadGraphics()
						end
					end
				end
			end

			for i = 0, room:GetGridSize() do
				local g = room:GetGridEntity(i)

				if g then
					local gt = g:GetType()

					local suffix = mod:getCrawlspaceBackdropSuffix()

					local perch = room:GetGridEntityFromPos(g.Position + Vector(0, 40))
					local perchtype = perch and perch:GetType()
					local rocktop = perch and FiendFolio.RequiresRocktops[perchtype] and not StageAPI.IsCustomGrid(perch:GetGridIndex(), "FFRubberRock")

					local perchify
					local perchable = perch and
					                  not mod.IsKeyBlock(perch) and
					                  (perchtype == GridEntityType.GRID_DOOR or
					                   perchtype == GridEntityType.GRID_WALL or
					                   perchtype == GridEntityType.GRID_ROCKB or
					                   rocktop)

					if perchable then
						if gt == GridEntityType.GRID_TNT then
							local gridRerenderer = Isaac.Spawn(1000, Isaac.GetEntityVariantByName("Crawlspace Grid Rerenderer"), 0, g.Position, nilvector, nil)
							mod:GetEntityData(gridRerenderer).GridIndex = i

							local gridsprite = g:GetSprite()
							gridsprite:Load("gfx/grid/crawlspace_tnt.anm2")
							gridsprite:ReplaceSpritesheet(0, "gfx/grid/blank.png")
							gridsprite:ReplaceSpritesheet(2, "gfx/grid/blank.png")
							gridsprite:LoadGraphics()

							local rendersprite = gridRerenderer:GetSprite()
							rendersprite:Load("gfx/grid/crawlspace_tnt.anm2")

							if rocktop then
								rendersprite:ReplaceSpritesheet(2, "gfx/grid/rocktop grids/rocktop_" .. suffix .. ".png")
								mod:GetEntityData(gridRerenderer).Rocktop = true
							else
								rendersprite:ReplaceSpritesheet(2, "gfx/grid/rocktop grids/tiletop_" .. suffix .. ".png")
								perchify = true
							end

							rendersprite:LoadGraphics()

							gridRerenderer:Update()
						elseif gt == GridEntityType.GRID_POOP then
							local gridRerenderer = Isaac.Spawn(1000, Isaac.GetEntityVariantByName("Crawlspace Grid Rerenderer"), 0, g.Position, nilvector, nil)
							mod:GetEntityData(gridRerenderer).GridIndex = i

							local gridsprite = g:GetSprite()
							gridsprite:Load("gfx/grid/crawlspace_poop.anm2")
							gridsprite:ReplaceSpritesheet(0, "gfx/grid/blank.png")
							gridsprite:ReplaceSpritesheet(1, "gfx/grid/blank.png")
							gridsprite:ReplaceSpritesheet(2, "gfx/grid/blank.png")
							gridsprite:LoadGraphics()

							local rendersprite = gridRerenderer:GetSprite()
							rendersprite:Load("gfx/grid/crawlspace_poop.anm2")

							rendersprite:ReplaceSpritesheet(0, mod.GetPoopSpritesheet(g))

							if rocktop then
								rendersprite:ReplaceSpritesheet(2, "gfx/grid/rocktop grids/rocktop_" .. suffix .. ".png")
								mod:GetEntityData(gridRerenderer).Rocktop = true
							else
								rendersprite:ReplaceSpritesheet(2, "gfx/grid/rocktop grids/tiletop_" .. suffix .. ".png")

								perchify = true
							end

							rendersprite:LoadGraphics()

							local stateanim = "State"..g.Desc.State
							if stateanim == "State0" then stateanim = "State1" end
							gridsprite:Play(stateanim, true)
							gridRerenderer:Update()
						elseif StageAPI.IsCustomGrid(i, "FFRubberRock") then
							local gridRerenderer = Isaac.Spawn(1000, Isaac.GetEntityVariantByName("Crawlspace Grid Rerenderer"), 0, g.Position, nilvector, nil)
							mod:GetEntityData(gridRerenderer).GridIndex = i

							local gridsprite = g:GetSprite()
							gridsprite:ReplaceSpritesheet(0, "gfx/grid/grid_rubber_rock_gibs_only.png")
							gridsprite:ReplaceSpritesheet(2, "gfx/grid/blank.png")
							gridsprite:LoadGraphics()

							local rendersprite = gridRerenderer:GetSprite()
							rendersprite:Load("gfx/grid/grid_rubber_rock.anm2")

							if rocktop then
								rendersprite:ReplaceSpritesheet(2, "gfx/grid/rocktop grids/rocktop_" .. suffix .. ".png")
								mod:GetEntityData(gridRerenderer).Rocktop = true
							else
								rendersprite:ReplaceSpritesheet(2, "gfx/grid/rocktop grids/tiletop_" .. suffix .. ".png")
								perchify = true
							end

							rendersprite:LoadGraphics()

							gridRerenderer:Update()
						elseif mod.IsKeyBlock(g) then
							local gridRerenderer = Isaac.Spawn(1000, Isaac.GetEntityVariantByName("Crawlspace Grid Rerenderer"), 0, g.Position, nilvector, nil)
							mod:GetEntityData(gridRerenderer).GridIndex = i

							local gridsprite = g:GetSprite()
							gridsprite:ReplaceSpritesheet(0, "gfx/grid/blank.png")
							gridsprite:ReplaceSpritesheet(1, "gfx/grid/blank.png")
							gridsprite:ReplaceSpritesheet(2, "gfx/grid/blank.png")
							gridsprite:LoadGraphics()

							local rendersprite = gridRerenderer:GetSprite()
							rendersprite:Load(gridsprite:GetFilename())

							if rocktop then
								rendersprite:ReplaceSpritesheet(1, "gfx/grid/rocktop grids/rocktop_" .. suffix .. ".png")
								mod:GetEntityData(gridRerenderer).Rocktop = true
							else
								rendersprite:ReplaceSpritesheet(1, "gfx/grid/rocktop grids/tiletop_" .. suffix .. ".png")
								perchify = true
							end

							local g3 = room:GetGridEntityFromPos(g.Position + Vector(0, -40))
							if g3:GetType() == GridEntityType.GRID_GRAVITY then
								rendersprite:ReplaceSpritesheet(2, "gfx/grid/rocktop grids/top_hider.png")
							end

							rendersprite:LoadGraphics()

							mod:GetEntityData(gridRerenderer).WasKeyBlock = true
							gridRerenderer:Update()
						end
					end

					if perchify then
						local tilesprite = perch:GetSprite()
						tilesprite:Load("gfx/grid/tiles_itemdungeon.anm2", true)
						tilesprite:Play("Brick"..math.random(3))
					end
				end
			end
		end
	end
end

------------------------------------------------------------------------------------------------------------------

--Floor thing rewrite that never got used
mod.FloorSkins = {
	Default = {
		Basement = 			"_dirt",
		Cellar = 			"_dirt",
		Burning = 			"_dirt",
		Caves = 			"_dirt",
		Catacombs = 		"_dirt",
		Flooded = 			"_flooded",
		Depths = 			"_gray",
		Necropolis = 		"_dark",
		Dank = 				"_gray",
		Womb = 				"_womb",
		Utero = 			"_womb",
		Scarred = 			"_womb",
		Blue = 				"_blue",
		Cathederal = 		"_flooded",
		Sheol = 			"_black",
		Chest = 			"_dirt",
		Dark = 				"_black",
	}
}

----------------------------------------------------------------------------------------------------


mod.DirtPaths = {
"_dirt",		-- 1
"_womb",		-- 2
"_scarred",		-- 3
"_flooded",		-- 4
"_blue",		-- 5
"_dark",		-- 6
"_gray",		-- 7
"_black",		-- 8
}

----------------------------------------------------------------------------------------------------

function mod:TheBigTakeDmgFunction(ent, data, damage, flags, source, sourceEntity, sourceData, countdown)
	local cloned = flags & DamageFlag.DAMAGE_CLONES ~= 0

	local newDamage = damage
	local newFlags = flags
	local sendNewDamage = false

	if not cloned then
		local sourceType = source.Type
		local sourceVariant = source.Variant

		local originalDamage = damage

		mod:doomOnDamage(ent, data, source)
		mod:ferriumGenericEverythingDamage(ent, newDamage, flags, source, data)

		if source == nil then
			-- do nothing
		elseif sourceType == EntityType.ENTITY_TEAR or
			   (sourceType == EntityType.ENTITY_BOMBDROP and flags == flags | DamageFlag.DAMAGE_EXPLOSION) or
			   (sourceType == EntityType.ENTITY_EFFECT and sourceVariant == EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL) or
			   (sourceType == EntityType.ENTITY_EFFECT and sourceVariant == EffectVariant.ROCKET) or
			   sourceType == EntityType.ENTITY_KNIFE
		then
			local data = sourceData

			--for aquarius?
			mod:fearOnApply(ent, source, data)
			mod:shrinkOnApply(ent, source, data)

			mod:erflyGenericDamage(source, ent, data, newDamage)
			mod:ferriumGenericPlayerDamage(ent, newDamage, flags, source, data)
		elseif sourceType == EntityType.ENTITY_KNIFE and (sourceVariant == 0 or sourceVariant == 5) then
			local player = mod:getPlayerFromKnife(sourceEntity)
			if player ~= nil then
				local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
				mod:ferriumOnKnifeDamage(player, ent, secondHandMultiplier, newDamage)
				mod:erflyOnKnifeDamage(player, ent, secondHandMultiplier)
			end
		elseif sourceType == EntityType.ENTITY_PLAYER and flags == flags | DamageFlag.DAMAGE_LASER then
			local player = sourceEntity:ToPlayer()
			local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
			mod:ferriumOnLaserDamage(player, ent, secondHandMultiplier, newDamage)
			mod:erflyOnLaserDamage(player, ent, secondHandMultiplier)
		elseif sourceType == EntityType.ENTITY_EFFECT and sourceVariant == EffectVariant.DARK_SNARE then
			if sourceEntity and sourceEntity.SpawnerEntity and sourceEntity.SpawnerEntity.Type == EntityType.ENTITY_PLAYER then
				local player = sourceEntity.SpawnerEntity:ToPlayer()
				local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
				mod:ferriumOnDarkArtsDamage(player, ent, secondHandMultiplier)
				mod:erflyOnDarkArtsDamage(player, ent, secondHandMultiplier)
			end
		elseif sourceType == EntityType.ENTITY_FAMILIAR and sourceVariant == FamiliarVariant.ABYSS_LOCUST then
			if sourceEntity and sourceEntity.SpawnerEntity and sourceEntity.SpawnerEntity.Type == EntityType.ENTITY_PLAYER then
				local player = sourceEntity.SpawnerEntity:ToPlayer()
				local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
				mod:erflyOnLocustDamage(player, sourceEntity, ent, secondHandMultiplier, flags, newDamage)
			end
		elseif sourceEntity then --Everything else
			local returndata = mod:ferriumGenericMiscDamage(ent, newDamage, flags, source, sourceData)
			newDamage = returndata.newDamage or newDamage
			sendNewDamage = returndata.sendNewDamage or sendNewDamage
		end

		if sourceType == EntityType.ENTITY_TEAR then
			local sourcetear = sourceEntity:ToTear()

			mod:erflyOnTearDamage(sourcetear, sourceData)
			mod:pgoOnTearDamage(sourceData, data)
			mod:ipadOnTearDamage(sourceData, ent)
		end
	end

	local returndata = mod:damagedByBerserk(ent, newDamage, flags, source, countdown, data)
	newDamage = returndata.newDamage or newDamage
	sendNewDamage = returndata.sendNewDamage or sendNewDamage

	if sendNewDamage then
		return {Damage = newDamage, DamageFlags = newFlags}
	end
end

---------------------------------------------------------------------------------------------------------------
-- Optional alternative VS screen portraits for Fiend and Golem
local ExtraPortraits = {
	[FiendFolio.PLAYER.FIEND] = "gfx/ui/stage/playerportrait_fiend_rep_vs.png",
	[FiendFolio.PLAYER.GOLEM] = "gfx/ui/stage/playerportrait_golem_rep_vs.png",
}
local function CheckExtraVsPortrait(sprite)
	if sprite and FiendFolio.ExtraVsPortraits == 1 then
		for slot, player in ipairs(mod:GetVsScreenPlayers()) do
			local altVsPortrait = ExtraPortraits[player:GetPlayerType()]
			if altVsPortrait then
				local layername = "PlayerPortraitAlt"
				if REPENTANCE_PLUS then
					layername = layername .. "_" .. slot
				end
				local layer = sprite:GetLayer(layername)
				if layer then
					sprite:ReplaceSpritesheet(layer:GetLayerID(), altVsPortrait, true)
				end
				if not REPENTANCE_PLUS then
					break
				end
			end
		end
	end
end
StageAPI.AddCallback("FiendFolio", StageAPI.Enum.Callbacks.POST_STAGEAPI_NEW_ROOM, 0, function()
	CheckExtraVsPortrait(StageAPI.PlayingBossSprite)
end)
mod:AddCallback(ModCallbacks.MC_POST_BOSS_INTRO_SHOW, function()
	CheckExtraVsPortrait(RoomTransition.GetVersusScreenSprite())
end)

-- Some extra functions
function mod:GetPlayerUsingItem()
	local player = Isaac.GetPlayer(0)
	for i = 1, game:GetNumPlayers() do
		local p = Isaac.GetPlayer(i - 1)
		if Input.IsActionTriggered(ButtonAction.ACTION_ITEM, p.ControllerIndex) or Input.IsActionTriggered(ButtonAction.ACTION_PILLCARD, p.ControllerIndex) then
			player = p
			mod:GetEntityData(player).WasHoldingButton = true
			break
		end
	end
	return player
end

-- outdated
local function CalcPlayerDamageMult(player)
	local mult = 1
	player = player:ToPlayer()
	if player:HasCollectible(CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM) or player:HasCollectible(CollectibleType.COLLECTIBLE_MAXS_HEAD) then
		mult = mult * 1.5
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_EVES_MASCARA) then
		mult = mult * 2
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT) and player:GetEffectiveMaxHearts() <= player:GetHearts() then
		mult = mult * 2
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA) then
		mult = mult * 1.31
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_ODD_MUSHROOM_RATE) then
		mult = mult * 0.9
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) then
		mult = mult * 2
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_PROPTOSIS) then
		mult = mult * 2
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_SACRED_HEART) then
		mult = mult * 2.3
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then
		mult = mult * 0.2
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY_2) then
		mult = mult * 0.65
	end
	return mult
end

local function runUpdates(tab)
	for i = #tab, 1, -1 do
		local f = tab[i]
		f.Delay = f.Delay - 1
		if f.Delay <= 0 then
			f.Func()
			table.remove(tab, i)
		end
	end
end

mod.delayedFuncs = {}
function mod.scheduleForUpdate(foo, delay, callback, noCancelOnNewRoom)
	callback = callback or ModCallbacks.MC_POST_UPDATE
	if not mod.delayedFuncs[callback] then
		mod.delayedFuncs[callback] = {}
		mod:AddCallback(callback, function()
			runUpdates(mod.delayedFuncs[callback])
		end)
	end

	table.insert(mod.delayedFuncs[callback], { Func = foo, Delay = delay, NoCancel = noCancelOnNewRoom })
end

function mod:cancelScheduledFunctions()
	for callback, tab in pairs(mod.delayedFuncs) do
		for i = #tab, 1, -1 do
			local f = tab[i]
			if not f.NoCancel then
				table.remove(tab, i)
			end
		end
	end
end

-- applies d12 effect to all tiles with type on table grids. refill = false for ignore broken grids. Returns a table of index grids that got d12'd
function mod.reroll_grids(grids, refill, customPoof, applyOnFireplaces)
	local ids = {}
	local gBroken = {}
	gBroken[2] = 2	gBroken[4] = 2		gBroken[5] = 2	gBroken[6] = 2	gBroken[10] = 1	gBroken[11] = 1
	gBroken[12] = 4	gBroken[14] = 1000	gBroken[22] = 2	gBroken[25] = 2	gBroken[26] = 2	gBroken[27] = 2
	local room = game:GetRoom()
	local len = room:GetGridSize()
	for i=0, len do
		local grid = room:GetGridEntity(i)
		if grid then
			local gType = grid:GetType()
			if refill or (grid.State ~= gBroken[gType]) then
				for j=1, #grids do
					if gType == grids[j] then
						table.insert(ids, i)
						grid:SetType(2)
						grid.State = 1
						grid:Update()
						break
					end
				end
			end
		end
	end

	if applyOnFireplaces then
		local fires = Isaac.FindByType(33, -1, -1, false, false)
		for _, fire in pairs(fires) do
			if fire.Variant >= 0 and fire.Variant <= 3 and ((fire.HitPoints == 1.0 and applyOnFireplaces) or fire.HitPoints ~= 1.0) then
				fire:ToNPC():Remove()
				local idx = room:GetGridIndex(fire.Position)
				room:SpawnGridEntity(idx, 2, 0, 0, 0)
				table.insert(ids, idx)
			end
		end
	end

	if customPoof then FiendFolio.scheduleForUpdate(function()
		poofs = Isaac.FindByType(1000, 15, -1, false, false)
		for _, poof in pairs(poofs) do
			if poof.FrameCount == 0 then
				--local color = Color(1, 1, 1, 1, 0, 0, 0)
				--color:SetColorize(0, 150/255, 1, 0.5)
				--poof:GetSprite().Color = color

				poof.Color = Color(0.625, 0.625, 1, 1, 0, 0.1, 0.2)
			end
		end
	end, 0) end
	Isaac.GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_D12, false, false, true, false)
	return ids
end

-- removes all grids with type on grids table without breaking them. returns a table of index grids that got removed
function mod.wipe_grids(grids, hazardPoop)
  local ids = {}
  local room = game:GetRoom()
  local len = room:GetGridSize()
  for i=0, len do
	local grid = room:GetGridEntity(i)
	if grid then
	  local gType = grid:GetType()
	  if hazardPoop or not (gType == 14 and (grid:GetVariant() == 1 or grid:GetVariant() == 2)) then
		for j=1, #grids do
		  if gType == grids[j] then
			table.insert(ids, i)
		  --if gType == 2 or gType == 4 or gType == 5 or gType == 6 or gType == 12 or gType == 14 or gType == 22 or gType == 25 or gType == 27 then
			local poof = Isaac.Spawn(1000, 15, 0, grid.Position, Vector(0,0), nil)
			poof.PositionOffset = Vector(0, 10)
			poof:GetSprite():Play("Poof_Small", true)
			for i=0, math.random(10) do
			  poof:GetSprite():Update()
			end
			room:RemoveGridEntity(i, 0, false)
		  --end
		  end
		end
	  end
	end
  end
  FiendFolio.scheduleForUpdate(function()
	for i=1, #ids do
	  room:SpawnGridEntity(ids[i], 1, 0, 0, 0)
	  mod:makeDecorInvisible(ids[i])
	end
  end, 2)
  return ids
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, proj)
  local data = mod:GetEntityData(proj)
  if data.customTearSplat then
	local splatGfx = data.customTearSplat
	FiendFolio.scheduleForUpdate(function()
	  local splats = Isaac.FindByType(1000, 12, 0, false, false)
	  for _, splat in pairs(splats) do
		if splat.FrameCount == 0 and splat.Position:Distance(proj.Position) == 0 then
		  local sprite = splat:GetSprite()
		  sprite:ReplaceSpritesheet(0, splatGfx)
		  sprite:LoadGraphics()
		end
	  end
	end, 0)
  end
  if data.tooth then
	if (proj:IsDead() or not proj:Exists()) then
		sfx:Play(SoundEffect.SOUND_BOIL_HATCH, 0.3, 0, false, 1)
	end
  end
  if data.customTearSound then
	if (proj:IsDead() or not proj:Exists()) then
	  sfx:Play(data.customTearSound[1], data.customTearSound[2], 0, false, data.customTearSound[3])
	end
  end
  if data.makeSplat then
	local splat = Isaac.Spawn(1000, data.makeSplat, 0, proj.Position, Vector.Zero, proj)
	splat.SpriteOffset = Vector(0, proj:ToTear().Height)
	if data.customTearSplat then
	  local splatGfx = data.customTearSplat
	  local sprite = splat:GetSprite()
	  sprite:ReplaceSpritesheet(0, splatGfx)
	  sprite:LoadGraphics()
	  if data.scaleSplat then
		splat.SpriteScale = Vector(data.scaleSplat, data.scaleSplat)
	  end
	end
	if data.toothParticles then
	  for i=0,2 do
		local particle = Isaac.Spawn(1000, 35, 1, proj.Position, RandomVector(), proj)
		particle:SetColor(data.toothParticles, 999, 1, false, false)
	  end
	end
  end
end, 2)

-- Borrowing a couple of functions from p20helper to render achievement notes
--[[local localp20 = {}

function localp20:getScreenCenterPosition()
	local room = game:GetRoom()
	local shape = room:GetRoomShape()
	local centerOffset = (room:GetCenterPos()) - room:GetTopLeftPos()
	local pos = room:GetCenterPos()
	if centerOffset.X > 260 then
		pos.X = pos.X - 260
	end
	if shape == RoomShape.ROOMSHAPE_LBL or shape == RoomShape.ROOMSHAPE_LTL then
		pos.X = pos.X - 260
	end
	if centerOffset.Y > 140 then
		pos.Y = pos.Y - 140
	end
	if shape == RoomShape.ROOMSHAPE_LTR or shape == RoomShape.ROOMSHAPE_LTL then
		pos.Y = pos.Y - 140
	end
	return Isaac.WorldToRenderPosition(pos, false)
end

local shouldRenderAchievement = false
local achievementUI = Sprite()
achievementUI:Load("gfx/ui/achievement/achievements.anm2", true)
local achievementUIDelay = 0
function localp20:doAchievement(spritesheet, sound)
	if shouldRenderAchievement then
		localp20:schedule(120, true, localp20.doAchievement, spritesheet, sound)
		return
	end

	if spritesheet == nil then
		spritesheet = "gfx/ui/achievement/paper.png"
	end
	achievementUI:ReplaceSpritesheet(3, spritesheet)
	achievementUI:LoadGraphics()

	achievementUI:Play("Appear", true)
	shouldRenderAchievement = true
	achievementUIDelay = 90

	if sound == nil then
		sound = SoundEffect.SOUND_CHOIR_UNLOCK
	end
	SFXManager():Play(sound, 1, 0, false, 1)
end

local functionsToCallInOnUpdate = {}
local functionsToCallInOnRender = {}
function localp20:schedule(delay, onRender, functionToCall, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	if delay then
		if delay > 0 then
			if functionToCall then
				local tableToInsert = {
					Frame = Isaac.GetFrameCount(),
					Delay = delay,
					Function = functionToCall,
					Arg1 = arg1,
					Arg2 = arg2,
					Arg3 = arg3,
					Arg4 = arg4,
					Arg5 = arg5,
					Arg6 = arg6,
					Arg7 = arg7,
					Arg8 = arg8,
					Arg9 = arg9
				}
				if onRender then
					table.insert(functionsToCallInOnRender, #functionsToCallInOnRender + 1, tableToInsert)
				else
					table.insert(functionsToCallInOnUpdate, #functionsToCallInOnUpdate + 1, tableToInsert)
				end
			end
		end
	end
end]]

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, damage, flags, source, iframes)
	-- only cancel damage for the first second
	if game:GetRoom():GetFrameCount() > 30 then return end

	-- DAMAGE WHEN ENTERING ROOM FIXES
	if flags & DamageFlag.DAMAGE_POOP ~= 0 then
		return false
	end

	-- no fire damage flag lmao
	if source.Type == 33 then
		return false
	end
end, EntityType.ENTITY_PLAYER)

mod.nameTagOpacity = 0
mod.nameTagToggle = false

mod.TempestFont = Font()
mod.TempestFont:Load("font/pftempestasevencondensed.fnt")
mod.tabHeldAlphaTimer = 0
local tabHeldScaleTimer = 0

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	--[[if #functionsToCallInOnRender >= 1 then
		for i = 1, #functionsToCallInOnRender do
			if functionsToCallInOnRender[i].Frame then
				local frame = functionsToCallInOnRender[i].Frame
				if functionsToCallInOnRender[i].Delay then
					local delay = functionsToCallInOnRender[i].Delay
					local frameToCall = frame + delay
					if Isaac.GetFrameCount() >= frameToCall then
						functionsToCallInOnRender[i].Frame = nil
						functionsToCallInOnRender[i].Delay = nil
						if functionsToCallInOnRender[i].Function then
							local arg1 = functionsToCallInOnRender[i].Arg1
							local arg2 = functionsToCallInOnRender[i].Arg2
							local arg3 = functionsToCallInOnRender[i].Arg3
							local arg4 = functionsToCallInOnRender[i].Arg4
							local arg5 = functionsToCallInOnRender[i].Arg5
							local arg6 = functionsToCallInOnRender[i].Arg6
							local arg7 = functionsToCallInOnRender[i].Arg7
							local arg8 = functionsToCallInOnRender[i].Arg8
							local arg9 = functionsToCallInOnRender[i].Arg9

							functionsToCallInOnRender[i].Function(_, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
						end
					end
				end
			end
		end
		local clearTable = true
		for i = 1, #functionsToCallInOnRender do
			if functionsToCallInOnRender[i].Frame then
				if functionsToCallInOnRender[i].Delay then
					if functionsToCallInOnRender[i].Function then
						clearTable = false
					end
				end
			end
		end
		if clearTable then
			functionsToCallInOnRender = {}
		end
	end
	if shouldRenderAchievement then
		achievementUI:Render(localp20:getScreenCenterPosition(), Vector(0,0), Vector(0,0))
	end]]

	local hasspider = false

	for _, player in pairs(Isaac.FindByType(1)) do
		player = player:ToPlayer()

		if player:HasCollectible(CollectibleType.COLLECTIBLE_SPIDER_MOD) then
			hasspider = true
		end

		if player:HasTrinket(FiendFolio.ITEM.ROCK.CONSTANT_ROCK_SHOOTER) then
			local controllerIndex = player.ControllerIndex
			local shootInputs = {
				ButtonAction.ACTION_SHOOTLEFT,
				ButtonAction.ACTION_SHOOTRIGHT,
				ButtonAction.ACTION_SHOOTUP,
				ButtonAction.ACTION_SHOOTDOWN
			}

			for _, buttonAction in pairs(shootInputs) do
				local isFiring = Input.IsActionTriggered(buttonAction, controllerIndex)
				if isFiring then
					local data = mod:GetEntityData(player)
					data.LastFireDirection = buttonAction
				end
			end
		end

		if player:HasTrinket(FiendFolio.ITEM.ROCK.TIPSY_GEODE) then
			local controllerIndex = player.ControllerIndex
			local data = mod:GetEntityData(player)
			local moveInputs = {
				[0] = ButtonAction.ACTION_RIGHT,
				[1] = ButtonAction.ACTION_UP,
				[2] = ButtonAction.ACTION_LEFT,
				[3] = ButtonAction.ACTION_DOWN,
			}

			for _, buttonAction in pairs(moveInputs) do
				local isMoving = Input.IsActionTriggered(buttonAction, controllerIndex)
				if isMoving then
					data.lastMoveDirection = buttonAction
				end
			end
		end
	end

	if mod.ShowRoomNames ~= 3 and mod.ShowRoomNames ~= 5 and not game:GetSeeds():HasSeedEffect(SeedEffect.SEED_NO_HUD) then
		local center = StageAPI.GetScreenCenterPosition()
		local br = StageAPI.GetScreenBottomRight()

		local roomDescriptorData = game:GetLevel():GetCurrentRoomDesc().OverrideData or game:GetLevel():GetCurrentRoomDesc().Data
		local scale = 1

		local tabHeld = Input.IsActionPressed(ButtonAction.ACTION_MAP, Isaac.GetPlayer(0).ControllerIndex)
		if tabHeld then
			mod.tabHeldAlphaTimer = math.min(mod.tabHeldAlphaTimer + 1, 30)
			tabHeldScaleTimer = math.min(tabHeldScaleTimer + 1, 10)
		else
			mod.tabHeldAlphaTimer = math.max(mod.tabHeldAlphaTimer - 1, 0)
			tabHeldScaleTimer = math.max(tabHeldScaleTimer - 1, 0)
		end

		if mod.RoomNameScale == 2 or mod.RoomNameScale == 3 then
			scale = 0.5
			if tabHeldScaleTimer > 0 and mod.ShowRoomNames ~= 4 and mod.RoomNameScale == 2 then
				local percent = 1 - ((1 - (tabHeldScaleTimer / 10)) ^ 2)
				scale = mod:Lerp(scale, 1, percent)
			end
		end

		if (br.X > 480 or br.Y > 270) and mod.RoomNameScale < 3 then -- render scale likely changed
			scale = 1
		end

		local text = ""

		local cacophobia = Isaac.FindByType(mod.FF.CacophobiaVenus.ID, mod.FF.CacophobiaVenus.Var)[1]

		if cacophobia and mod:GetEntityData(cacophobia).Pattern then
			text = mod:GetEntityData(cacophobia).Pattern.PatternName
		else
			local currentRoom = StageAPI.GetCurrentRoom()
			if currentRoom and currentRoom.Layout then
				text = text .. tostring(currentRoom.Layout.Variant) .. " " .. currentRoom.Layout.Name
			else
				local useVar = roomDescriptorData.Variant
				if useVar >= 17000 and useVar <= 21000 then
					useVar = useVar - 17000
					text = "(FF) "
				end

				if mod:IsGolemUnlockRoom(roomDescriptorData) or mod:IsFriendUnlockRoom(roomDescriptorData) then
					text = text .. "???"
				else
					text = text .. tostring(useVar) .. " " .. roomDescriptorData.Name
				end
			end
		end

		local textWidth = mod.TempestFont:GetStringWidth(text)
		if mod.RoomNameScale == 4 then
			local padding = 0.02
			scale = math.min(br.X / textWidth - padding, 1)
		end

		local bcenter = Vector(center.X, br.Y - 13 * scale)

		if scale > 0.5 and game:GetRoom():GetAliveBossesCount() > 0 then
			local hudOffset = Options.HUDOffset * 10
			if hudOffset <= 1 then
				bcenter = bcenter + Vector(0, -18 - (2 * hudOffset))
			end
		end

		local size = textWidth * scale

		local alpha = (FiendFolio.RoomNameOpacity + 1) * 0.1
		if mod.ShowRoomNames == 4 then -- show only while holding tab
			alpha = 0
		end

		if mod.ShowRoomNames == 2 then -- only appear for a short time in each room
			local frameCount = math.min(game:GetRoom():GetFrameCount(), 90)
			alpha = mod:Lerp(alpha, 0, frameCount / 90)
		end

		if mod.tabHeldAlphaTimer > 0 then
			alpha = mod:Lerp(alpha, 1, mod.tabHeldAlphaTimer / 30)
		end

		mod.TempestFont:DrawStringScaled(text, bcenter.X - (size / 2), bcenter.Y, scale, scale, KColor(1,1,1,alpha), 0, false)
	end

	if mod.NameTags ~= 0 then
		local opacity = mod.nameTagOpacity
		if mod.NameTags == 1 then
			opacity = 0.3
		elseif mod.NameTags == 2 then
			if mod.nameTagToggle then
				if opacity < 0.3 then opacity = opacity + 0.0375 end
			else
				if opacity > 0 then opacity = opacity - 0.0375 end
			end
		end
		mod.nameTagOpacity = opacity

		for _, e in pairs(Isaac.GetRoomEntities()) do
			if e.Type > 9 and e.Type < 1000 and e.FrameCount >= 1 then
				local data = mod:GetEntityData(e)
				if not data.FFNameTag then
					local config = EntityConfig.GetEntity(e.Type, e.Variant, e.SubType)
					if config then
						local name = config:GetName()
						if string.sub(name, 1, 1) == "#" then
							name = string.sub(name, 2, -1)
							name = string.gsub(name, "_", " ")
							name = string.lower(name)
							name = string.gsub(" "..name, "%W%l", string.upper):sub(2)
						end

						data.FFNameTag = name
					else
						data.FFNameTag = true
					end
				elseif data.FFNameTag ~= true then
					if e.Visible and e.Color.A ~= 0 then
						local str = data.FFNameTag
						if (str == "Harletwin" or str == "Effigy") and e.SubType == 1 then str = nil end
						if str == "Cordend" and e.SubType > 1 then str = nil end
						if (str == "Fishface" or str == "Madclaw") and mod:GetEntityData(e).state == "waiting" then str = nil end
						if str == "Offal" and mod:GetEntityData(e).hiding then str = nil end
						if str then
							local pos = game:GetRoom():WorldToScreenPosition(e.Position) + Vector(string.len(str) * -3, 3)
							if hasspider then
								pos = pos + Vector(0, 10)
							end
							if str == "Baby Spider" then
								Isaac.RenderScaledText(str, pos.X + 18, pos.Y, 0.5, 0.5, 1, 1, 1, opacity)
							else
								Isaac.RenderText(str, pos.X, pos.Y, 1, 1, 1, opacity)
							end
						end
					end
				end
			end
		end
	end
end)

function mod:applyFrictionMod(player, savedata)
	if savedata and savedata.FrictionMod and savedata.FrictionMod ~= 0 then
		player.Friction = player.Friction + savedata.FrictionMod
	end
end

function mod:GlobalUseItem(item, rng, player, useFlags, slot, var)
	if useFlags == useFlags | UseFlag.USE_OWNED then
		mod:FerriumGlobalUseItem(item, rng, player, useFlags, slot, var)
	end
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.GlobalUseItem)

-- returns trinket slot if player is actively holding trinket
-- if gulped or otherwise not in a slot, returns -1
function FiendFolio.GetTrinketSlot(player, trinketId)
	for i = 0, 1 do
		local gold = mod:IsGoldTrinket(player:GetTrinket(i))
		if mod:GetRealTrinketId(player:GetTrinket(i)) == trinketId then return i, gold end
	end

	return -1
end

-- returns other trinket slot if player is actively holding trinket
-- if gulped, returns random trinket slot
-- if there is no other slot with a trinket, returns -1
-- throws if the player does not have the trinketId
function FiendFolio.GetOtherTrinketSlot(player, trinketId)
	if not player:HasTrinket(trinketId) then
		error('Tried to check for other trinket slot for trinket player did not have')
	end

	if player:GetTrinket(0) == trinketId then
		if player:GetTrinket(1) > 0 then return 1 end
		return -1
	end
	if player:GetTrinket(1) == trinketId then
		if player:GetTrinket(0) > 0 then return 0 end
		return -1
	end

	local slot = math.random(2) - 1
	if player:GetTrinket(slot) > 0 then return slot end

	slot = 1 - slot
	if player:GetTrinket(slot) > 0 then return slot end

	return -1
end

local checkingForGolden = false
local gettingGolemTrinket = false
local gettingRegularTrinket = false
mod:AddCallback(ModCallbacks.MC_GET_TRINKET, function(_, trinket, rng)
	if checkingForGolden then
		return
	elseif gettingGolemTrinket then
		-- Custom rock pool only applies for machine, not natural trinkets
		if FiendFolio.TrinketPoolBlacklist[trinket] then
			return Game():GetItemPool():GetTrinket()
		elseif not (FiendFolio.RockTrinkets[mod:GetRealTrinketId(trinket)] ~= nil or FiendFolio.GolemTrinketWhitelist[mod:GetRealTrinketId(trinket)] ~= nil) then
			return Game():GetItemPool():GetTrinket()
		elseif FiendFolio.RockTrinkets[mod:GetRealTrinketId(trinket)] == -2 or FiendFolio.GolemTrinketWhitelist[mod:GetRealTrinketId(trinket)] == -2 then
			return Game():GetItemPool():GetTrinket()
		end
	elseif gettingRegularTrinket then
		if FiendFolio.TrinketPoolBlacklist[trinket] then
			return Game():GetItemPool():GetTrinket()
		elseif FiendFolio.RockTrinkets[mod:GetRealTrinketId(trinket)] ~= nil then
			return Game():GetItemPool():GetTrinket()
		end
	end

	local newTrinket = trinket

	if FiendFolio.TrinketPoolBlacklist[trinket] then
		newTrinket = Game():GetItemPool():GetTrinket()
	end

	if Isaac.GetChallenge() == Challenge.CHALLENGE_PICA_RUN then
		--do nothing
	elseif FiendFolio.UsedPentacles then
		FiendFolio.UsedPentacles = false
		--do nothing
	else
		local isAnyGolem, isMixedGolem = FiendFolio.GolemExists()
		if isMixedGolem then
			--do nothing
		elseif not (isAnyGolem or mod.gettingGolemTrinket) then
			if FiendFolio.RockTrinkets[mod:GetRealTrinketId(newTrinket)] ~= nil then
				gettingRegularTrinket = true
				newTrinket = Game():GetItemPool():GetTrinket()
				gettingRegularTrinket = false
			end
		else
			if rng:RandomInt(100) < 15 then -- only reroll trinket to valid one sometimes
				-- Custom rock pool only applies for machine, not natural trinkets
				local rockRarity = FiendFolio.RockTrinkets[mod:GetRealTrinketId(newTrinket)]
				local whitelistRarity = FiendFolio.GolemTrinketWhitelist[mod:GetRealTrinketId(trinket)]

				if rockRarity ~= nil and rockRarity ~= -2 then
					--do nothing
				elseif whitelistRarity ~= nil and whitelistRarity ~= -2 then
					--do nothing
				else
					gettingGolemTrinket = true
					newTrinket = Game():GetItemPool():GetTrinket()
					gettingGolemTrinket = false
				end

				FiendFolio.TryRemoveGolemTrinketFromPool(newTrinket)
			else
				return newTrinket -- return invalid trinket
			end
		end
	end

	if not mod:IsGoldTrinket(newTrinket) then
		local hasGoldenIOU = false
		for i = 1, game:GetNumPlayers() do
			local player = Isaac.GetPlayer(i - 1)
			if player:GetTrinket(0) == mod.ITEM.TRINKET.IOU + TrinketType.TRINKET_GOLDEN_FLAG or
			   player:GetTrinket(1) == mod.ITEM.TRINKET.IOU + TrinketType.TRINKET_GOLDEN_FLAG
			then
				hasGoldenIOU = true
				break
			end
		end

		if hasGoldenIOU and math.random(100) < 10 then
			newTrinket = newTrinket + TrinketType.TRINKET_GOLDEN_FLAG
		end
	end

	if newTrinket ~= trinket then
		return newTrinket
	end
end)

function mod.makeTrinketGolden(trinket)
	if Isaac.GetPersistentGameData():Unlocked(Achievement.GOLDEN_TRINKETS) then
		if mod:IsGoldTrinket(trinket) then
			return trinket
		end
		return trinket + TrinketType.TRINKET_GOLDEN_FLAG
	else
		return trinket
	end
end

function mod.tryMakeTrinketGolden(trinket)
	if Isaac.GetPersistentGameData():Unlocked(Achievement.GOLDEN_TRINKETS) then
		if mod:IsGoldTrinket(trinket) then
			return trinket
		end

		checkingForGolden = true
		local potentialGoldenTrinket = Game():GetItemPool():GetTrinket()
		checkingForGolden = false

		if mod:IsGoldTrinket(potentialGoldenTrinket) then
			return trinket + TrinketType.TRINKET_GOLDEN_FLAG
		end

		return trinket
	else
		return trinket
	end
end

function FiendFolio.AddItemPickupCallback(onAdd, onRemove, item, forceAddOnRepickup)
	if onAdd then
		mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, function(_, collectibleType, charge, firstTime, slot, varData, player)
			local count = player:GetCollectibleNum(collectibleType, true)
			if firstTime or forceAddOnRepickup then
				onAdd(player, 1, count)
			end
		end, item)
	end
	if onRemove then
		mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, function(_, player, collectibleType)
			local count = player:GetCollectibleNum(collectibleType, true)
			onRemove(player, -1, count)
		end, item)
	end
end

local TrinketGulpCallbacks = {}

function FiendFolio.AddTrinketPickupCallback(onAdd, onRemove, item, onGulp)
	if onAdd then
		mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, function(_, player, trinketType, firstTime)
			local has = player:HasTrinket(trinketType)
			onAdd(player, has, firstTime)
		end, item)
	end
	if onRemove then
		mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, function(_, player, trinketType)
			local has = player:HasTrinket(trinketType)
			onRemove(player, has)
		end, item)
	end
	if onGulp then
		if not TrinketGulpCallbacks[item] then
			TrinketGulpCallbacks[item] = {}
		end
		table.insert(TrinketGulpCallbacks[item], onGulp)
	end
end

function mod.canAffordPickup(player, pickup)
	local playerType = player:GetPlayerType()
	if pickup.Price > 0 then
		return player:GetNumCoins() >= pickup.Price
	elseif playerType == PlayerType.PLAYER_THELOST or playerType == PlayerType.PLAYER_THELOST_B then
		return true
	elseif pickup.Price == -1 then
		--1 Red
		return math.ceil(player:GetMaxHearts() / 2) + player:GetBoneHearts() >= 1
	elseif pickup.Price == -2 then
		--2 Red
		return math.ceil(player:GetMaxHearts() / 2) + player:GetBoneHearts() >= 1
	elseif pickup.Price == -3 then
		--3 soul
		return math.ceil(player:GetSoulHearts() / 2) >= 1
	elseif pickup.Price == -4 then
		--1 Red, 2 Soul
		return math.ceil(player:GetMaxHearts() / 2) + player:GetBoneHearts() >= 1
	elseif pickup.Price == -7 then
		--1 Soul
		return math.ceil(player:GetSoulHearts() / 2) >= 1
	elseif pickup.Price == -8 then
		--2 Souls
		return math.ceil(player:GetSoulHearts() / 2) >= 1
	elseif pickup.Price == -9 then
		--1 Red, 1 Soul
		return math.ceil(player:GetMaxHearts() / 2) + player:GetBoneHearts() >= 1
	else
		return true
	end
end

function mod.CanAffordPrice(player, price)
	if price > 0 then
		return price <= player:GetNumCoins()
	elseif price == PickupPrice.PRICE_SPIKES then
		return player:GetDamageCooldown() == 0
	elseif price == PickupPrice.PRICE_SOUL then
		return player:HasTrinket(TrinketType.TRINKET_YOUR_SOUL)
	elseif price == 0 or price == PickupPrice.PRICE_FREE then
		return true
	elseif price == PickupPrice.PRICE_ONE_HEART or price == PickupPrice.PRICE_TWO_HEARTS then
		return player:GetEffectiveMaxHearts() > 0
	elseif price == PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS or price == PickupPrice.PRICE_ONE_HEART_AND_ONE_SOUL_HEART then
		return player:GetSoulHearts() > 0 and player:GetEffectiveMaxHearts() > 0
	elseif price == PickupPrice.PRICE_THREE_SOULHEARTS or price == PickupPrice.PRICE_ONE_SOUL_HEART or price == PickupPrice.PRICE_TWO_SOUL_HEARTS then
		return player:GetSoulHearts() > 0
	end
end

function mod.IsDevilDeal(price)
	return (
		price == PickupPrice.PRICE_ONE_HEART
		or price == PickupPrice.PRICE_TWO_HEARTS
		or price == PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS
		or price == PickupPrice.PRICE_ONE_HEART_AND_ONE_SOUL_HEART
		or price == PickupPrice.PRICE_THREE_SOULHEARTS
		or price == PickupPrice.PRICE_ONE_SOUL_HEART
		or price == PickupPrice.PRICE_TWO_SOUL_HEARTS
	)
end

function mod.WillPlayerBuyCollectible(player, pickup)
	local d = mod:GetEntityData(player)
	return (
		pickup.Price ~= 0 and
		pickup.Wait == 0 and
		player.Variant == PlayerVariant.PLAYER and
		player.ItemHoldCooldown == 0 and
		((d.Briend and d.Briend.DoingAnim) or (player:CanPickupItem() and not player:IsHoldingItem())) and
		mod.CanAffordPrice(player, pickup.Price)
	)
end

function mod.WillPlayerBuyHeart(player, pickup)
	return (
		pickup.Price ~= 0 and
		player.Variant == PlayerVariant.PLAYER and
		mod.CanAffordPrice(player, pickup.Price) and
		CustomHealthAPI.Library.CanPickHeart(player, pickup)
	)
end

function mod.WillPlayerBuyBattery(player, pickup)
	return (
		pickup.Price ~= 0 and
		player.Variant == PlayerVariant.PLAYER and
		mod.CanAffordPrice(player, pickup.Price) and
		player:NeedsCharge()
	)
end

function mod.WillPlayerBuyPickup(player, pickup)
	if pickup.Variant == 100 then
		return mod.WillPlayerBuyCollectible(player, pickup)
	elseif pickup.Variant == 10 then
		return mod.WillPlayerBuyHeart(player, pickup)
	elseif pickup.Variant == 90 then
		return mod.WillPlayerBuyBattery(player, pickup)
	elseif mod.CanAffordPrice(player, pickup.Price) then
		return true
	end
end

function mod:handleTrinketSmeltedEffects(player)
	local data = mod:GetEntityData(player)
	if not data.ffSmeltedTrinkets then
		data.ffSmeltedTrinkets = {}
	end

	local smeltedTrinkets = player:GetSmeltedTrinkets()
	for item, callbacks in pairs(TrinketGulpCallbacks) do
		local count = smeltedTrinkets[item].trinketAmount + smeltedTrinkets[item].goldenTrinketAmount * 2
		if data.ffSmeltedTrinkets[item] then
			local diff = count - data.ffSmeltedTrinkets[item]
			if diff > 0 then
				for _, foo in ipairs(callbacks) do
					foo(player)
				end
			end
		end
		data.ffSmeltedTrinkets[item] = count
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.handleTrinketSmeltedEffects)
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, mod.handleTrinketSmeltedEffects)
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, mod.handleTrinketSmeltedEffects)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, collectible, rng, player, useflags)
	mod:handleTrinketSmeltedEffects(player)
end, CollectibleType.COLLECTIBLE_SMELTER)

function mod:peffectUpdate(player)
	local basedata = mod:GetEntityData(player)
	local savedata = basedata.ffsavedata

	mod:CheckLoadsamoneyUnlock(player)
	mod:applyFrictionMod(player, savedata)
	mod:TryInvalidateItemState(player, basedata)

	-- IsHoldingItem is true for the entire pickup animation
	-- IsHeldItemVisible is true only when item is lifted... but on the first frame it's false so the cache would be updated
	-- therefore, on the first frame of a pickup animation, set a flag indicating the animation has started and from then on when IsHeldItem item is false ignore it
	-- until the player is no longer holding an item, then reset it
	local playerIsHoldingItem = player:IsHoldingItem()
	if playerIsHoldingItem then
		if not player:IsHeldItemVisible() then
			if basedata.StartedPickupAnimation then
				playerIsHoldingItem = false
			else
				basedata.StartedPickupAnimation = true
			end
		end
	else
		basedata.StartedPickupAnimation = nil
	end

	if basedata.lastDamageSourceWasCursedDoor and player:GetDamageCooldown() <= 0 then
		basedata.lastDamageSourceWasCursedDoor = false
	end

	mod:erflyPeffectUpdate(player, basedata, savedata)
	mod:connorPEffectUpdate(player, basedata)

	mod:honeyPennyPeffect(player, basedata)

	mod:catinsurancePeffectUpdate(player, basedata)

	mod:alphaCoinPeffect(player, basedata)
	mod:godheadProjHandling(player, basedata)
	mod:ferriumPeffectUpdate(player, basedata)
	mod:guwahPeffectUpdate(player, basedata)
	--mod:handleRockyTrinket(player)
	mod:checkMartyrAuras(player, basedata)

	--mod:ShardOfChinaPeffectUpdate(player, basedata, savedata)
	mod.WarHornPeffectUpdate(player, savedata)
	mod.PlushLambPeffectUpdate(player, basedata)

	mod:maliceUpdate(player, basedata)
	mod:CraigBatteryUpdate(player, basedata)
	mod:FriendPeffectUpdate(player, basedata)
	mod:BriendPeffectUpdate(player, basedata)
	mod:GolemRockForcedCacheUpdate(player, basedata)
	mod:RollingRockUpdate(player, basedata, savedata)
	mod:HoldUpTrinket(player, basedata)
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.peffectUpdate)

-- Savedata pt 2
local function InitPlayerFFSaveData(player)
	local basedata = player:GetData()
	basedata.ffsavedata = {}
	local data = basedata.ffsavedata

	data.orbitingfireballs = 0
	data.pillstotake = 0
	data.FrictionMod = 0
	data.RunEffects = {
		RoomClearCounts = {}, -- intended for keeping track of clear counts since picking up item
		Collectibles = {},
		Trinkets = {},
		TrueRoomClearCounts = {}, -- The above one gets reset whenever you take damage.
	}

	local keyGhosts = {}
	basedata.KeyGhostData = keyGhosts
	for _, variant in pairs(FiendFolio.KeyToGhostMap) do
		keyGhosts[variant] = {}
	end

	data.SpawnedAsKeeper = player:GetPlayerType() == PlayerType.PLAYER_KEEPER -- For item pickup callback to be able to detect Strawmen
end
mod:AddPriorityCallback(ModCallbacks.MC_PLAYER_INIT_PRE_LEVEL_INIT_STATS, -math.huge, function(_, player)
	InitPlayerFFSaveData(player)
end)
mod:AddPriorityCallback(ModCallbacks.MC_POST_PLAYER_INIT, -math.huge, function(_, player)
	if not player:GetData().ffsavedata then
		InitPlayerFFSaveData(player)
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, continuing)
	ModReloadDetector.GameStarted = true

	if FiendFolio.MonsoonName then
		local monsoonData = StageAPI.GetBossData("Moistro")
		if FiendFolio.MonsoonName == 6 then -- share your best monsoon seeds!
			local gamerng = RNG()
			gamerng:SetSeed(game:GetSeeds():GetStartSeed(), 0)
			local name = (gamerng:Next() % 5) + 1
			monsoonData.Bossname = FiendFolio.MonsoonNames[name]
		else
			monsoonData.Bossname = FiendFolio.MonsoonNames[FiendFolio.MonsoonName]
		end
	end

	if FiendFolio.WarpZoneName then
		local warpzoneData = StageAPI.GetBossData("Warp Zone")
		if FiendFolio.WarpZoneName == 4 then -- share your best mega portal seeds!
			local gamerng = RNG()
			gamerng:SetSeed(game:GetSeeds():GetStartSeed(), 0)
			local name = (gamerng:Next() % 5) + 1
			warpzoneData.BossName = FiendFolio.WarpZoneNames[name]
		else
			warpzoneData.BossName = FiendFolio.WarpZoneNames[FiendFolio.WarpZoneName]
		end
	end

	mod:erflyPostGameStart(continuing)

	for i = 1, game:GetNumPlayers() do
		local p = Isaac.GetPlayer(i - 1)
		local pdata = mod:GetEntityData(p)

		if continuing and FiendFolio.savedata.run and FiendFolio.savedata.run.playerSaveData then
			for key, val in pairs(FiendFolio.savedata.run.playerSaveData[i]) do
				pdata.ffsavedata[key] = val
			end
		end

		mod:ferriumPlayerInit(p, pdata, continuing)
		mod:erflyPlayerInit(p, pdata, continuing)

		p:AddCacheFlags(CacheFlag.CACHE_ALL)
		p:EvaluateItems()
	end

	--azurite spindown check
	local itempool = game:GetItemPool()
	local unlockableVanillaTrinkets = {1, 13, 15, 21, 23, 28, 35, 42, 49, 50, 52, 54, 55, 56, 57, 58, 59, 60, 61, 67, 74, 76, 80, 81, 83, 84, 85,
	                            		91, 92, 107, 110, 111, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128}
	for _, id in ipairs(unlockableVanillaTrinkets) do
		if not itempool:RemoveTrinket(id) then
			ffBlacklistAzurite({id})
		end
	end
	itempool:ResetTrinkets()

	FiendFolio.AchievementsPostGameStart()

	mod.BuildCustomItemPools()

	if FiendFolio.ItemConfig.OpihuchusDisabled then
		itempool:RemoveCollectible(FiendFolio.ITEM.COLLECTIBLE.OPHIUCHUS)
	end

	if FiendFolio.ItemConfig.CetusDisabled then
		itempool:RemoveCollectible(FiendFolio.ITEM.COLLECTIBLE.CETUS)
	end

	itempool:RemoveTrinket(FiendFolio.ITEM.TRINKET.HALF_VESSEL)
	itempool:RemoveTrinket(FiendFolio.ITEM.TRINKET.FULL_VESSEL)
	itempool:RemoveTrinket(FiendFolio.ITEM.TRINKET.MIDDLE_HAND)
	itempool:RemoveTrinket(FiendFolio.ITEM.ROCK.UNOBTAINIUM)
	itempool:RemoveTrinket(FiendFolio.ITEM.ROCK.FOOLS_UNOBTAINIUM)
	itempool:RemoveTrinket(FiendFolio.ITEM.ROCK.DOGROCK_ROCK)
	itempool:RemoveTrinket(FiendFolio.ITEM.TRINKET.SUICIDAL_PENNY)

	if game.Difficulty >= Difficulty.DIFFICULTY_GREED then
		itempool:RemoveTrinket(mod.ITEM.TRINKET.BIFURCATED_STARS)
		ffBlacklistAzurite({mod.ITEM.TRINKET.BIFURCATED_STARS})
	end

	if REVEL then
		-- temp hack until rev updates to expose the blacklist global
		local oldImpl = REVEL.IsCharonInventoryManagedItem
		REVEL.IsCharonInventoryManagedItem = function(id, item)
			if item and not id then
				id = item.ID
			end

			item = item or REVEL.config:GetCollectible(id)
			return oldImpl(id, item) and id ~= mod.ITEM.COLLECTIBLE.GMO_CORN
		end
	end

	if Isaac.GetChallenge() == mod.challenges.towerOffense and not continuing then
		local player = Isaac.GetPlayer(0)
		player:ChangePlayerType(FiendFolio.PLAYER.GOLEM)
	end

	--[[if not mod.savedata.shownUnlocksChoicePopup then
		DeadSeaScrollsMenu.QueueMenuOpen("Fiend Folio", "unlockspopup", 1, true)
	end]]

	if TaintedTreasure then
		TaintedTreasure:MergeTaintedTreasures(FiendFolio.TAINTED_ITEM)
	end

	FiendFolio.SaveSaveData()
	FiendFolio.gamestarted = true
end)

if ModReloadDetector.GameStarted and game:GetFrameCount() > 0 then
	if not mod.LOADED_SAVEDATA then
		FiendFolio.LoadSaveData()
	end

	FiendFolio:checkConfigSettings()
end

mod:AddPriorityCallback(ModCallbacks.MC_PRE_SFX_PLAY, CallbackPriority.EARLY, function()
	for _, player in ipairs(PlayerManager.GetPlayers()) do
		if player:GetSprite():IsEventTriggered("DeathSound") then
			local ptype = player:GetPlayerType()
			if Isaac.RunCallbackWithParam("FF_PLAYER_DEATH_SOUND", ptype, player) then
				return false
			end
		end
	end
	-- Check for fake dying players from Astral Projection and the white fireplace.
	for _, fakePlayer in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DEVIL)) do
		local player = fakePlayer.SpawnerEntity and fakePlayer.SpawnerEntity:ToPlayer()
		if player and fakePlayer:GetSprite():IsEventTriggered("DeathSound") then
			local ptype = player:GetPlayerType()
			if Isaac.RunCallbackWithParam("FF_PLAYER_DEATH_SOUND", ptype, player) then
				return false
			end
		end
	end
end, SoundEffect.SOUND_ISAACDIES)

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
	local data = mod:GetEntityData(player)
	local sdata = data.ffsavedata

	if data.stopDieSound then
		sfx:Stop(SoundEffect.SOUND_ISAACDIES)
	end

	mod:erflyPlayerUpdate(player, data, sdata)

	if FiendFolio.NameTagKeybind ~= -1 and Input.IsButtonTriggered(FiendFolio.NameTagKeybind, player.ControllerIndex) then mod.nameTagToggle = not mod.nameTagToggle end

	mod:TakeQueuedPills(player, data, sdata)
	mod:DisplayQueuedFortunes(player, data)

	if data.BleedyFeetsies and data.BleedyFeetsies > 0 then
		data.BleedyFeetsies = data.BleedyFeetsies - 1
		if player.FrameCount % 2 == 1 then
			local blood = Isaac.Spawn(1000, 7, 0, player.Position, nilvector, npc)
			blood.SpriteScale = Vector(1/100, 1/100) * data.BleedyFeetsies
			blood:Update()
		end
	end

	-- malice minion
	mod:MaliceMinionPlayerUpdate(player, data)

	--black lantern
	mod:SunCursePlayerUpdate(player, data)
	mod:ScytheCursePlayerUpdate(player, data)

	mod:connorPlayerUpdate(player, data)
	mod:catinsurancePlayerUpdate(player, data)
	mod:PreventGlowingHourGlassAnim(player, data)
end)

--Secret weed smoke
mod:AddCallback(mod.CALLBACK.FF_POST_PLAYER_UPDATE, function(_, player)
	local data = mod:GetEntityData(player)
	if mod.checkWeedy then
		local itemCount = player:GetCollectibleCount()
		if itemCount == 0 or itemCount == 1 and player:HasCollectible(CollectibleType.COLLECTIBLE_D6) then
			local weedTimer = 7800
			if game.TimeCounter == weedTimer then
				player.Color = mod.ColorInvisible
				local weed = Isaac.Spawn(mod.FF.IsaacSmonking.ID, mod.FF.IsaacSmonking.Var, mod.FF.IsaacSmonking.Sub, player.Position, nilvector, player)
				weed.Parent = player
				weed:Update()
				data.smonkingWeed = weed
				mod.checkWeedy = nil

				if mod.anyPlayerHas(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE, true) then
					mod:makeShampooText("SmokeWeed")
				end
			end
		end
	end
	if data.smonkingWeed then
		if data.smonkingWeed:Exists() then
			player.Velocity = nilvector
		else
			player.Color = mod.ColorNormal
			data.smonkingWeed = false
		end
	end
end, PlayerType.PLAYER_ISAAC)

--Stolen from p20 helper
function mod:getPtrHashEntity(entity)
	if entity.Entity then
		entity = entity.Entity
	end
	for _, matchEntity in pairs(Isaac.FindByType(entity.Type, entity.Variant, entity.SubType, false, false)) do
		if GetPtrHash(entity) == GetPtrHash(matchEntity) then
			return matchEntity
		end
	end
	return nil
end

function mod:getPlayerFromTear(tear)
	for i=1, 3 do
		local check = nil
		if i == 1 then
			check = tear.Parent
		elseif i == 2 then
			check = tear.SpawnerEntity
		elseif i == 3 then
			local spawnData = mod:GetEntityData(tear).SpawnData
			if spawnData then
				check = spawnData.SpawnerEntity
			end
		end
		if check ~= nil and check:Exists() then
			if check.Type == EntityType.ENTITY_PLAYER and check:ToPlayer() then
				return mod:getPtrHashEntity(check):ToPlayer()
			elseif check.Type == EntityType.ENTITY_FAMILIAR and check:ToFamiliar() then
				familiar = check:ToFamiliar()
				local player = familiar.Player
				if player ~= nil and player:Exists() and player.Type == EntityType.ENTITY_PLAYER and player:ToPlayer() then
					return mod:getPtrHashEntity(player):ToPlayer()
				end
			end
		end
	end
	return nil
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, function(_, tear)
local td = mod:GetEntityData(tear)
td.SpawnData = mod:GetEntityData(tear)
end)

local haemoTears = {
	[TearVariant.BALLOON] = true,
	[TearVariant.BALLOON_BRIMSTONE] = true,
	[TearVariant.BALLOON_BOMB] = true,
}
local bloodyTears = {
	[TearVariant.CUPID_BLOOD] = true,
	[TearVariant.PUPULA_BLOOD] = true,
	[TearVariant.GODS_FLESH_BLOOD] = true,
	[TearVariant.NAIL_BLOOD] = true,
	[TearVariant.GLAUCOMA_BLOOD] = true,
	[TearVariant.EYE_BLOOD] = true,
}

local KnifeVariant = {
	MOMS_KNIFE 		= 0,
	BONE_CLUB 		= 1,
	BONE_SCYTHE 	= 2,
	DONKEY_JAWBONE 	= 3,
	BAG_OF_CRAFTING = 4,
	SUMPTORIUM 		= 5,
	NOTCHED_AXE	 	= 9,
	SPIRIT_SWORD 	= 10,
	TECH_SWORD 		= 11,
}

function mod:postFireTear(tear, player, ignorePlayerEffects, isLudo) -- Tears
	local ignorePlayerEffects = mod.IgnoreSecondaryFireEffects or ignorePlayerEffects
	local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1

	mod:erflyPostFireTear(player, tear, secondHandMultiplier, ignorePlayerEffects, isLudo)
	mod:immoralClotOnFireTear(tear)

	mod:ferriumOnFireTear(player, tear, secondHandMultiplier, isLudo, ignorePlayerEffects)
	mod:JDOnFireTear(player, tear, secondHandMultiplier, isLudo, ignorePlayerEffects)

	if player:GetPlayerType() == mod.PLAYER.CRAIG and not isLudo then
		mod:CraigOnFireTear(tear, player)
	end

	if not (ignorePlayerEffects or isLudo) then
		mod:checkReplaceableSecondaryFiredTears(tear, player, ignorePlayerEffects, isLudo)
	end
end

function mod:copyFFTearEffects(sourcetear, desttear)
	local sourcedata = mod:GetEntityData(sourcetear)
	local destdata = mod:GetEntityData(desttear)

	destdata.hasBeenD3Rolled = sourcedata.hasBeenD3Rolled
	destdata.BlackMoonInflicting = sourcedata.BlackMoonInflicting
	destdata.ApplyPacified = sourcedata.ApplyPacified
	destdata.ApplyPacifiedDuration = sourcedata.ApplyPacifiedDuration
	destdata.ChemicalCookieSpawnerOrig = sourcedata.ChemicalCookieSpawnerOrig
end

function mod:postLudoTearReset(tear)
	local data = mod:GetEntityData(tear)

	data.hasBeenD3Rolled = nil
	data.BlackMoonInflicting = nil
	data.ApplyPacified = nil
	data.ApplyPacifiedDuration = nil
	Isaac.RunCallbackWithParam("FF_POST_LUDO_TEAR_RESET", tear, data)
end

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear) -- Regular tears
	local player = nil
	if not tear.SpawnerEntity then
		return
	elseif tear.SpawnerEntity:ToPlayer() then
		player = tear.SpawnerEntity:ToPlayer()
	elseif tear.SpawnerEntity:ToFamiliar() and tear.SpawnerEntity:ToFamiliar().Player then
		local familiar = tear.SpawnerEntity:ToFamiliar()

		if familiar.Variant == FamiliarVariant.INCUBUS or
		   familiar.Variant == FamiliarVariant.SPRINKLER or
		   familiar.Variant == FamiliarVariant.TWISTED_BABY or
		   familiar.Variant == FamiliarVariant.BLOOD_BABY or
		   familiar.Variant == FamiliarVariant.UMBILICAL_BABY or
		   familiar.Variant == FamiliarVariant.CAINS_OTHER_EYE
		then
			player = familiar.Player
		else
			return
		end
	else
		return
	end

	mod:postFireTear(tear, player, false, tear:HasTearFlags(BitSet128(0, 1 << (127 - 64))))
end)

local fatesRewardTearsToBePostFired = {} -- Fate's Reward tears (stink no post_fire_tear no frame 0 post_tear_update fuck you fuck you fuck you)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
	for _, tear in pairs(fatesRewardTearsToBePostFired) do
		local player = nil
		if not tear.SpawnerEntity then
			return
		elseif tear.SpawnerEntity:ToFamiliar() and tear.SpawnerEntity:ToFamiliar().Player then
			local familiar = tear.SpawnerEntity:ToFamiliar()

			if familiar.Variant == FamiliarVariant.FATES_REWARD then
				player = familiar.Player
			else
				return
			end
		else
			return
		end

		mod:postFireTear(tear, player, true, tear:HasTearFlags(BitSet128(0, 1 << (127 - 64))))
	end

	fatesRewardTearsToBePostFired = {}
end, FamiliarVariant.FATES_REWARD)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, function(_, tear)
	if tear.SpawnerEntity and
	   tear.SpawnerEntity.Type == EntityType.ENTITY_FAMILIAR and
	   tear.SpawnerEntity.Variant == FamiliarVariant.FATES_REWARD and
	   tear.SpawnerEntity:ToFamiliar().Player
	then
		fatesRewardTearsToBePostFired[tear.Index .. " " .. tear.InitSeed] = tear
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, tear)
	if fatesRewardTearsToBePostFired[tear.Index .. " " .. tear.InitSeed] then
		fatesRewardTearsToBePostFired[tear.Index .. " " .. tear.InitSeed] = nil
	end
end, EntityType.ENTITY_TEAR)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear) -- Ludovico Technique tears
	if tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) then
		local player = nil
		if not tear.SpawnerEntity then
			return
		elseif tear.SpawnerEntity:ToPlayer() then
			player = tear.SpawnerEntity:ToPlayer()
		elseif tear.SpawnerEntity:ToFamiliar() and tear.SpawnerEntity:ToFamiliar().Player then
			local familiar = tear.SpawnerEntity:ToFamiliar()

			if familiar.Variant == FamiliarVariant.INCUBUS or familiar.Variant == FamiliarVariant.SPRINKLER or
			   familiar.Variant == FamiliarVariant.TWISTED_BABY or familiar.Variant == FamiliarVariant.BLOOD_BABY or
			   familiar.Variant == FamiliarVariant.UMBILICAL_BABY or familiar.Variant == FamiliarVariant.CAINS_OTHER_EYE
			then
				player = familiar.Player
			else
				return
			end
		else
			return
		end

		if math.floor(tear.FrameCount / player.MaxFireDelay) ~= math.floor((tear.FrameCount - 1) / player.MaxFireDelay) then
			mod:postLudoTearReset(tear)
			mod:postFireTear(tear, player, false, true)
		end
	end
end)

-- This gets called on both MC_POST_FIRE_BOMB and MC_POST_PLAYER_USE_BOMB
function mod:postFireBomb(bomb, player)
	if not player and bomb.SpawnerEntity then
		if bomb.SpawnerEntity:ToPlayer() then
			player = bomb.SpawnerEntity:ToPlayer()
		elseif bomb.SpawnerEntity:ToFamiliar() then
			local famVar = bomb.SpawnerEntity.Variant
			if famVar == FamiliarVariant.INCUBUS or
				famVar == FamiliarVariant.SPRINKLER or
				famVar == FamiliarVariant.TWISTED_BABY or
				famVar == FamiliarVariant.BLOOD_BABY or
				famVar == FamiliarVariant.UMBILICAL_BABY or
				famVar == FamiliarVariant.CAINS_OTHER_EYE
			then
				player = bomb.SpawnerEntity:ToFamiliar().Player
			end
		end
	end

	if not player then return end

	if bomb.IsFetus then
		local data = mod:GetEntityData(bomb)
		local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1

		mod:stevenClotOnFireBomb(bomb)

		mod:erflyPostFireBomb(player, bomb, secondHandMultiplier)
		mod:ferriumOnFireBomb(player, bomb, secondHandMultiplier)
		mod:JDOnFireBomb(player, bomb, secondHandMultiplier)
		mod:copperPostFireBomb(player, bomb, bomb.IsFetus)
	else
		mod:copperPostFireBomb(player, bomb)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_FIRE_BOMB, mod.postFireBomb)

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_USE_BOMB, function(_, player, bomb)
	mod:postFireBomb(bomb, player)
end)

mod.scatterBombsDataKeys = {
	-- Tear Effects
	"BlackMoonInflicting",

	-- Status Effects
	"ApplyPacified", "ApplyPacifiedDuration",
}

function mod:postScatterBomb(bomb, oldBomb)
	local data, oldData = mod:GetEntityData(bomb), mod:GetEntityData(oldBomb) -- How did we let this function fill with like a mod:GetEntityData(thousand ) calls man
	for _, key in pairs(mod.scatterBombsDataKeys) do
		data[key] = oldData[key]
	end

	data.FFIsScatter = true

	if FiendFolio.IsFiendFolioBomb(oldBomb.Variant) then
		bomb.Variant = oldBomb.Variant
		bomb.Flags = bomb.Flags -- Resets the sprite since the game has to check for new per-flag layers and stuff
	end

	mod:malicePostScatterBomb(bomb, oldBomb)
end

local gatherScatterBombs = false
local scatteredBombs = {}

local function MightGenerateScatterBombs(bomb)
	return bomb.Flags & TearFlags.TEAR_SCATTER_BOMB == TearFlags.TEAR_SCATTER_BOMB or
			bomb.Flags & TearFlags.TEAR_SPLIT == TearFlags.TEAR_SPLIT or
			bomb.Flags & TearFlags.TEAR_PERSISTENT == TearFlags.TEAR_PERSISTENT or
			bomb.Flags & TearFlags.TEAR_QUADSPLIT == TearFlags.TEAR_QUADSPLIT
end

-- This callback was JUST added to REPENTOGON so I'll play it safe. Can clean later.
if ModCallbacks.MC_PRE_BOMB_UPDATE then
	mod:AddPriorityCallback(ModCallbacks.MC_PRE_BOMB_UPDATE, CallbackPriority.EARLY, function(_, bomb)
		gatherScatterBombs = false
		scatteredBombs = {}
		if not bomb:IsDead() and MightGenerateScatterBombs(bomb) then
			gatherScatterBombs = true
		end
	end)
end

mod:AddCallback(ModCallbacks.MC_POST_BOMB_INIT, function(_, bomb)
	if gatherScatterBombs and (bomb.SpawnerType == EntityType.ENTITY_PLAYER or bomb.SpawnerType == EntityType.ENTITY_FAMILIAR) then
		scatteredBombs[bomb.InitSeed] = EntityPtr(bomb)
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_POST_BOMB_UPDATE, CallbackPriority.EARLY, function(_, bomb)
	if gatherScatterBombs and bomb:IsDead() and MightGenerateScatterBombs(bomb) then
		for _, ptr in pairs(scatteredBombs) do
			if ptr and ptr.Ref and ptr.Ref:Exists() and ptr.Ref:ToBomb() then
				mod:postScatterBomb(ptr.Ref:ToBomb(), bomb)
			end
		end
	end
	gatherScatterBombs = false
	scatteredBombs = {}
end)

function mod:getPlayerFromKnife(knife)
	if knife.SpawnerEntity and knife.SpawnerEntity:ToPlayer() then
		return knife.SpawnerEntity:ToPlayer()
	elseif knife.SpawnerEntity and knife.SpawnerEntity:ToFamiliar() and knife.SpawnerEntity:ToFamiliar().Player then
		local familiar = knife.SpawnerEntity:ToFamiliar()

		if familiar.Variant == FamiliarVariant.INCUBUS or familiar.Variant == FamiliarVariant.SPRINKLER or
		   familiar.Variant == FamiliarVariant.TWISTED_BABY or familiar.Variant == FamiliarVariant.BLOOD_BABY or
		   familiar.Variant == FamiliarVariant.UMBILICAL_BABY or familiar.Variant == FamiliarVariant.CAINS_OTHER_EYE
		then
			return familiar.Player
		else
			return nil
		end
	else
		return nil
	end
end

mod.isKnife = {
	[0] = true,	--Default
	[5] = true,	--Sumptorium
}
mod.isClub = {
	[1] = true,	--Default
	[2] = true,	--Bone Scythe (knife / club)
	[3] = true,	--Donkey Jawbone

	--Not counted, no synergies
	[4] = false,--Bag of Crafting
	[9] = false,--Notched Axe
}
mod.isSword = {
	[10] = true,--Default
	[11] = true,--Tech
}

-- apparently basegame knife synergies function moreso like laser synergies so most of this is currently useless
-- still going to leave it though because it could be useful in the future / will be useful if we ever get actual spirit sword/forgotten bone support
-- the time has come
mod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, function(_, knife) -- Mom's Knife
	if not (mod.isKnife[knife.Variant] or mod.isClub[knife.Variant]) and not (knife.FrameCount == 1 and (mod.isClub[knife.Variant] or mod.isSword[knife.Variant]) and knife.SubType == 4) then
		return
	end

	local player = mod:getPlayerFromKnife(knife)
	if player == nil then return end

	local data = mod:GetEntityData(knife)
	local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1

	mod:erflyOnKnifeUpdate(player, knife, data)

	if (mod.isClub[knife.Variant] or mod.isSword[knife.Variant]) and knife.SubType == 4 then
		return
	end

	local isFlying = knife:IsFlying()
	local isSwingingClub = mod.isClub[knife.Variant] and knife.SubType ~= 4 and mod.IsSwingingClub(knife)
	local isChargingClub = mod.isClub[knife.Variant] and knife.SubType ~= 4 and mod.IsChargingClub(knife)

	if not (data.WasChargingClub or isChargingClub) and
	   ((data.WasFlying and not isFlying) or
	    (data.WasSwingingClub and not (isSwingingClub or isChargingClub or isFlying)))
	then
		mod.ResetKnife(knife, player)
		mod:GetEntityData(player).HasFiredMomsKnife = nil
	elseif isFlying then
		if not mod.isClub[knife.Variant] then
			if not data.WasFlying then
				mod:erflyPostFireKnife(player, knife, data)
				mod:JDOnFireKnife(player, knife)
				mod:GetEntityData(player).HasFiredMomsKnife = {knife, player.FrameCount} --Checks to null the variable in ferrium/main.lua
			end
		end
		data.WasChargingClub = nil
	elseif isSwingingClub then
		data.WasChargingClub = nil
	end

	data.WasFlying = isFlying
	if not isChargingClub then data.WasSwingingClub = isSwingingClub end
	data.WasChargingClub = isChargingClub
	data.LastCharge = knife.Charge

	knife.Color = data.KnifeColor or knife.Color
end)

mod:AddCallback(ModCallbacks.MC_POST_KNIFE_INIT, function(_, knife) --Club-type weapons
	if knife.SubType == 4 then
		local player = mod:getPlayerFromKnife(knife)
		if player == nil then return end
		mod:JDOnFireKnife(player, knife)
		--Needed rotation so I popped it in the update a frame later
	end
end)

function mod.ResetKnife(knife, player)
	local data = mod:GetEntityData(knife)

	mod:erflyOnKnifeReset(player, knife, data)
	data.KnifeColor = nil

	if player then
		local pdata = mod:GetEntityData(player)
		local var = knife.Variant
		if pdata.emeticAntimonyReady and (var == KnifeVariant.MOMS_KNIFE or var == KnifeVariant.SUMPTORIUM) then
			pdata.emeticAntimonyReady = false
		end
	end
end

function mod.IsSwingingClub(club)
	local sprite = club:GetSprite()
	return sprite:IsPlaying("Swing") or sprite:IsPlaying("SwingDown") or
	       sprite:IsPlaying("Swing2") or sprite:IsPlaying("SwingDown2")
end

function mod.IsChargingClub(club)
	local player = mod:getPlayerFromKnife(club)
	return not (mod.IsSwingingClub(club) or club:IsFlying()) and player and player:GetFireDirection() ~= Direction.NO_DIRECTION
end

-- There is currently no 60fps update callback nor a pre-render callback for lasers :(
function mod:updateLaserColors()
	if not Isaac.IsInGame() then return end

	for _, laser in ipairs(Isaac.FindByType(EntityType.ENTITY_LASER)) do
		local var = laser.Variant
		local subt = laser.SubType
		if (var == 1 and subt == 3) or var == 5 or var == 12 then -- Maw of the Void, Revelation and Montezuma's Revenge lasers
			-- do nothing
		else
			local laser = laser:ToLaser()
			local data = mod:GetEntityData(laser)

			if not (laser:HasTearFlags(TearFlags.TEAR_CONTINUUM) or laser:HasTearFlags(TearFlags.TEAR_RAINBOW)) then
				-- Immoral Clots
				if data.ImpSodaLaserForceColor then
					local color = Color(1.0, 1.0, 1.0, 1.0, 0/255, 0/255, 0/255)
					color:SetColorize(5.7, 0.9, 3.4, 1)
					laser.Color = color
				end

				-- Steven Clots
				if data.StevenLaserForceColor then
					laser.Color = Color(-2,-2,-2,1,1,1,1,1,1,1,1)
				end
			end

			mod:prankCookieUpdateLaserColors(laser, data)
		end
	end
end
mod:AddEntityCallback(ModCallbacks.MC_PRE_RENDER, EntityType.ENTITY_LASER, nil, nil, mod.updateLaserColors)

function mod:updateLaserEndpointColor(laserEndpoint)
	local data = mod:GetEntityData(laserEndpoint)

	-- Immoral Clots
	if data.ImpSodaLaserForceColor then
		local color = Color(1.0, 1.0, 1.0, 1.0, 0/255, 0/255, 0/255)
		color:SetColorize(5.7, 0.9, 3.4, 1)
		laserEndpoint.Color = color
	end

	-- Steven Clots
	if data.StevenLaserForceColor then
		laserEndpoint.Color = Color(-2,-2,-2,1,1,1,1,1,1,1,1)
	end

	mod:prankCookieUpdateLaserColors(laserEndpoint, data)
end
mod:AddCallback(ModCallbacks.MC_PRE_EFFECT_RENDER, mod.updateLaserEndpointColor, EffectVariant.LASER_IMPACT)

function mod:updateBrimstoneBallColor(brimball)
	local data = mod:GetEntityData(brimball)

	if not (brimball:HasTearFlags(TearFlags.TEAR_CONTINUUM) or brimball:HasTearFlags(TearFlags.TEAR_RAINBOW)) then
		-- Immoral Clots
		if data.ImpSodaLaserForceColor then
			local color = Color(1.0, 1.0, 1.0, 1.0, 0/255, 0/255, 0/255)
			color:SetColorize(5.7, 0.9, 3.4, 1)
			brimball.Color = color
		end

		-- Steven Clots
		if data.StevenLaserForceColor then
			brimball.Color = Color(-2,-2,-2,1,1,1,1,1,1,1,1)
		end
	end

	mod:prankCookieUpdateLaserColors(brimball, data)
end
mod:AddCallback(ModCallbacks.MC_PRE_EFFECT_RENDER, mod.updateBrimstoneBallColor, EffectVariant.BRIMSTONE_BALL)

mod:AddCallback(ModCallbacks.MC_POST_LASER_INIT, function(_, laser)
	local var = laser.Variant
	if var == 4 or var == 7 or var == 8 or var == 13 then -- Pride, Tractor Beam, Circle of Protection and Beast Lasers
		return
	end

	if laser.SpawnerEntity and laser.SpawnerEntity.Type == EntityType.ENTITY_PLAYER and var == 2 and laser.SubType == 0 then
		local familiars = Isaac.FindInRadius(laser.Position, 0.000001, EntityPartition.FAMILIAR)
		for _,familiar in ipairs(familiars) do
			if familiar.Variant == FamiliarVariant.FINGER then
				return
			end
		end
	end

	local player = nil
	if laser.SpawnerEntity and laser.SpawnerEntity:ToPlayer() then
		player = laser.SpawnerEntity:ToPlayer()
	elseif laser.SpawnerEntity and laser.SpawnerEntity:ToFamiliar() and laser.SpawnerEntity:ToFamiliar().Player then
		local familiar = laser.SpawnerEntity:ToFamiliar()

		if familiar.Variant == FamiliarVariant.INCUBUS or familiar.Variant == FamiliarVariant.SPRINKLER or
		   familiar.Variant == FamiliarVariant.TWISTED_BABY or familiar.Variant == FamiliarVariant.BLOOD_BABY or
		   familiar.Variant == FamiliarVariant.UMBILICAL_BABY or familiar.Variant == FamiliarVariant.CAINS_OTHER_EYE
		then
			player = familiar.Player
		else
			return
		end
	else
		return
	end

	mod:immoralClotOnFireLaser(laser)
	mod:stevenClotOnFireLaser(laser)
	mod:erflyPostFireLaser(player, laser)
	mod:ferriumOnFireLaser(player, laser)
	mod:JDOnFireLaser(player, laser)
end)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, laserEndpoint)
	if laserEndpoint.SpawnerEntity and laserEndpoint.SpawnerEntity.Type == EntityType.ENTITY_LASER then
		local laser = laserEndpoint.SpawnerEntity
		local var = laser.Variant
		local subt = laser.SubType
		if (var == 1 and subt == 3) or var == 5 or var == 12 then -- Maw of the Void, Revelation and Montezuma's Revenge lasers
			-- do nothing
		else
			local laser = laser:ToLaser()
			local endpointData = mod:GetEntityData(laserEndpoint)
			local laserData = mod:GetEntityData(laser)

			mod:prankCookieOnLaserEndpointInit(endpointData, laser)
			if not (laser:HasTearFlags(TearFlags.TEAR_CONTINUUM) or laser:HasTearFlags(TearFlags.TEAR_RAINBOW)) then
				endpointData.ImpSodaLaserForceColor = laserData.ImpSodaLaserForceColor
				endpointData.StevenLaserForceColor = laserData.StevenLaserForceColor
			end
		end
	end
end, EffectVariant.LASER_IMPACT)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, brimball)
	local player = nil
	if brimball.SpawnerEntity and brimball.SpawnerEntity:ToPlayer() then
		player = brimball.SpawnerEntity:ToPlayer()
	else
		return
	end

	mod:clotOnFireBrimball(brimball)
end, EffectVariant.BRIMSTONE_BALL)

FiendFolio.IgnoreAquariusSynergies = false
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, creep) -- Aquarius
	if not FiendFolio.IgnoreAquariusSynergies and creep.SpawnerEntity and creep.SpawnerEntity.Type == EntityType.ENTITY_PLAYER then
		local player = creep.SpawnerEntity:ToPlayer()
		local data = mod:GetEntityData(creep)
		local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1

		mod:ferriumOnFireAquarius(player, creep, secondHandMultiplier)
		mod:JDOnFireAquarius(player, creep, secondHandMultiplier)
		mod:erflyOnFireAquarius(player, creep, secondHandMultiplier)
	end
end, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL)

function mod:rollEpicFetusEffects(player, target) -- Epic Fetus
	local playerData = mod:GetEntityData(player)
	local data = mod:GetEntityData(target)

	if not data.FFRocketQueuedEffects then
		local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1

		mod:ferriumOnFireRocket(player, target, secondHandMultiplier)
		mod:JDOnFireRocket(player, target, secondHandMultiplier)
		mod:erflyOnFireRocket(player, target, secondHandMultiplier)

		if playerData.emeticAntimonyReady then
			data.emeticPlayer = player
		end

		data.FFRocketQueuedEffects = true
	end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, target)
	local player = nil
	if target.SpawnerEntity and target.SpawnerEntity:ToPlayer() then
		player = target.SpawnerEntity:ToPlayer()
	elseif target.SpawnerEntity and target.SpawnerEntity:ToFamiliar() and target.SpawnerEntity:ToFamiliar().Player then
		local familiar = target.SpawnerEntity:ToFamiliar()

		if familiar.Variant == FamiliarVariant.INCUBUS or familiar.Variant == FamiliarVariant.SPRINKLER or
		   familiar.Variant == FamiliarVariant.TWISTED_BABY or familiar.Variant == FamiliarVariant.BLOOD_BABY or
		   familiar.Variant == FamiliarVariant.UMBILICAL_BABY or familiar.Variant == FamiliarVariant.CAINS_OTHER_EYE
		then
			player = familiar.Player
		else
			return
		end
	else
		return
	end

	mod:rollEpicFetusEffects(player, target)
end, EffectVariant.TARGET)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, rocket)
	local player = nil
	if rocket.SpawnerEntity and rocket.SpawnerEntity:ToPlayer() then
		player = rocket.SpawnerEntity:ToPlayer()
	elseif rocket.SpawnerEntity and rocket.SpawnerEntity:ToFamiliar() and rocket.SpawnerEntity:ToFamiliar().Player then
		local familiar = rocket.SpawnerEntity:ToFamiliar()

		if familiar.Variant == FamiliarVariant.INCUBUS or familiar.Variant == FamiliarVariant.SPRINKLER or
		   familiar.Variant == FamiliarVariant.TWISTED_BABY or familiar.Variant == FamiliarVariant.BLOOD_BABY or
		   familiar.Variant == FamiliarVariant.UMBILICAL_BABY or familiar.Variant == FamiliarVariant.CAINS_OTHER_EYE
		then
			player = familiar.Player
		else
			return
		end
	else
		return
	end

	local rocketdata = mod:GetEntityData(rocket)
	if rocket.FrameCount <= 1 then
		if rocket.Parent and rocket.Parent.Type == EntityType.ENTITY_EFFECT and rocket.Parent.Variant == EffectVariant.TARGET and not mod:GetEntityData(rocket.Parent).FFPassedOnRocketEffects then
			local targetdata = mod:GetEntityData(rocket.Parent)

			rocketdata.FFExplosionColor = targetdata.FFExplosionColor or rocketdata.FFExplosionColor

			rocketdata.emeticPlayer = targetdata.emeticPlayer

			rocketdata.ApplyCharm = targetdata.ApplyCharm
			rocketdata.ApplyCharmDuration = targetdata.ApplyCharmDuration

			rocketdata.ApplyFear = targetdata.ApplyFear
			rocketdata.ApplyFearDuration = targetdata.ApplyFearDuration

			rocketdata.ApplyShrink = targetdata.ApplyShrink
			rocketdata.ApplyShrinkDuration = targetdata.ApplyShrinkDuration

			rocketdata.ApplyPetrify = targetdata.ApplyPetrify
			rocketdata.ApplyPetrifyDuration = targetdata.ApplyPetrifyDuration

			rocketdata.electrumRemote = targetdata.electrumRemote

			rocketdata.ApplyPacified = targetdata.ApplyPacified
			rocketdata.ApplyPacifiedDuration = targetdata.ApplyPacifiedDuration

			mod:erflyTransferRocketData(rocketdata, targetdata, rocket, rocket.Parent, player)
			mod:handleBeeSkinRockets(rocketdata, targetdata, rocket, rocket.Parent, player)

			rocketdata.FFRocketQueuedEffects = true
			targetdata.FFPassedOnRocketEffects = true
		else
			mod:rollEpicFetusEffects(player, rocket)
		end
	end
end, EffectVariant.ROCKET)

mod:AddPriorityCallback(ModCallbacks.MC_POST_EFFECT_INIT, CallbackPriority.EARLY, function(_, explosion)
	if explosion.SpawnerEntity and explosion.SpawnerType == EntityType.ENTITY_EFFECT then
		if explosion.SpawnerVariant == EffectVariant.ROCKET then
			local rocket = explosion.SpawnerEntity
			mod:erflyPostRocketExplosion(explosion, rocket)
			mod:GetEntityData(explosion).FFExplosionColor = mod:GetEntityData(rocket).FFExplosionColor
			if mod:GetEntityData(rocket).emeticPlayer then
				local player = mod:GetEntityData(rocket).emeticPlayer
				if mod:GetEntityData(player).emeticAntimonyReady then
					mod:GetEntityData(player).emeticAntimonyReady = false
				end
			end
		elseif explosion.SpawnerVariant == EffectVariant.SMALL_ROCKET then
			local rocket = explosion.SpawnerEntity
			mod:GetEntityData(explosion).FFExplosionColor = mod:GetEntityData(rocket).FFExplosionColor
		end
	end
end, EffectVariant.BOMB_EXPLOSION)

mod:AddCallback(ModCallbacks.MC_PRE_EFFECT_RENDER, function(_, explosion)
	if explosion.FrameCount <= 0 then
		explosion.Color = mod:GetEntityData(explosion).FFExplosionColor or explosion.Color
	end
end, EffectVariant.BOMB_EXPLOSION)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
	local td = mod:GetEntityData(tear)

	mod:erflyTearUpdate(tear, td)

	if td.spriteRotatin and (tear.Variant == 0 or tear.Variant == 1) then
		local rotOff = td.spriteRotatinOff or 0
		tear.SpriteRotation = tear.Velocity:GetAngleDegrees() + rotOff
	end

	mod:updateTrinityTear(tear, td)
end)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, tear)
	if game:IsPaused() then return end
	local data = mod:GetEntityData(tear)
	mod:ferriumPostTearRemove(tear, data)
	mod:erflyPostTearRemove(tear,data)
end, EntityType.ENTITY_TEAR)

local function CanClubVariantHaveTearEffects(variant)
	return (
		variant == KnifeVariant.BONE_CLUB or
		variant == KnifeVariant.BONE_SCYTHE or
		variant == KnifeVariant.DONKEY_JAWBONE
	)
end

function mod.ClubHasCustomEffects(knife)
	return knife and knife.SpawnerEntity and knife.SpawnerEntity.Type <= 3 and CanClubVariantHaveTearEffects(knife.Variant)
end

local swingsToBeParented = {}
mod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, function(_, knife)
	if mod.ClubHasCustomEffects(knife) then
		local frame = knife:GetSprite():GetFrame()
		local player = knife.SpawnerEntity:ToPlayer() or knife.SpawnerEntity:ToFamiliar().Player

		if frame == 0 then
			table.insert(swingsToBeParented, knife)
		end
	end
end, 4)

mod:AddPriorityCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, CallbackPriority.IMPORTANT, function(_, knife)
	if mod.ClubHasCustomEffects(knife) then
		if mod.IsSwingingClub(knife) and knife:GetSprite():GetFrame() == 0 then
			local player = mod:getPlayerFromKnife(knife)
			if player then
				player = player:ToPlayer()
			end
			mod.ResetKnife(knife, player)
		end

		local kdata = nil
		for _, swing in ipairs(swingsToBeParented) do
			if kdata == nil then
				kdata = mod:GetEntityData(knife)
			end

			local sdata = mod:GetEntityData(swing)
			sdata.ClubParent = knife
		end
		swingsToBeParented = {}
	end
end, 0)

function mod.getParentClub(swing)
	return mod:GetEntityData(swing).ClubParent
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	swingsToBeParented = {}
end)

mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, function(_, tear, ent, low)
	local data = mod:GetEntityData(tear)

	mod:erflyPreTearCollision(tear, ent, data)
	local ferrium = mod:ferriumPreTearCollision(tear, ent, low)
	if ferrium ~= nil then
		return ferrium
	end

	--Ignore cherry bombs
	if ent and ent.Type == mod.FF.CherryBomb.ID and ent.Variant == mod.FF.CherryBomb.Var then
		return true
	end

	mod:ambassadorHit(tear, ent)
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	local room = game:GetRoom()
	if room:GetType() == RoomType.ROOM_DUNGEON then
		local updateGrids
		if FiendFolio.RoomGrids then
			for _, v in pairs({"GRID_ROCK", "GRID_ROCKT", "GRID_ROCK_ALT", "GRID_ROCK_BOMB", "GRID_ROCK_SS", "GRID_ROCK_SPIKED", "GRID_ROCK_GOLD", "GRID_ROCK_ALT2"}) do
				if FiendFolio.RoomGrids[GridEntityType[v]] then
					for i = 1, #FiendFolio.RoomGrids[GridEntityType[v]] do
						if i > #FiendFolio.RoomGrids[GridEntityType[v]] then break end
						local g = FiendFolio.RoomGrids[GridEntityType[v]][i]

						if g then
							if g.Desc.State ~= 1 then
								local g2 = room:GetGridEntityFromPos(g.Position + Vector(0, 40))
								if g2 then
									local g2t = g2:GetType()
									mod.RocktopSafetyData = mod.RocktopSafetyData or {}
									--This stuff could spawn infinitely otherwise for some reason
									--IWL I don't fully understand the code but this stops it so
									if not mod.RocktopSafetyData[g.Position.X .. "." .. g.Position.Y] then
										if FiendFolio.RequiresRocktops[g2t] and g2.Desc.State == 1 or g2.Desc.State == 4 then
											print("spawn new rocktop 1")
											local e = Isaac.Spawn(1000, Isaac.GetEntityVariantByName("Crawlspace Rocktop"), 0, g2.Position + Vector(0, -80), nilvector, nil)
											mod:GetEntityData(e).myrock = g2
											e.PositionOffset = Vector(0, 40)
											local suffix = mod:getCrawlspaceBackdropSuffix()
											local esprite = e:GetSprite()
											esprite:ReplaceSpritesheet(0, "gfx/grid/rocktop grids/rocktop_" .. suffix .. ".png")
											esprite:LoadGraphics()
											e:Update()
											updateGrids = true
											mod.RocktopSafetyData[g.Position.X .. "." .. g.Position.Y] = true
										elseif v ~= "GRID_ROCK_ALT" and g2 and (g2t == GridEntityType.GRID_ROCKB or g2t == GridEntityType.GRID_WALL or g2t == GridEntityType.GRID_DOOR) then
											print("spawn new rocktop 2")
											--print(g2.Desc.State)
											local e = Isaac.Spawn(1000, Isaac.GetEntityVariantByName("Crawlspace Rocktop"), 0, g2.Position + Vector(0, -80), nilvector, nil)
											mod:GetEntityData(e).myrock = g2
											mod:GetEntityData(e).perm = true
											e.PositionOffset = Vector(0, 40)
											local suffix = mod:getCrawlspaceBackdropSuffix()
											local rockString = "_" .. suffix
											if rockString == "_default" then
												rockString = ""
											end
											local esprite = e:GetSprite()
											esprite:Load("gfx/grid/tiles_itemdungeon.anm2")
											esprite:ReplaceSpritesheet(0, "gfx/grid/tiles_itemdungeon" .. rockString .. ".png")
											esprite:LoadGraphics()
											esprite:SetFrame("Floor1", 1)
											e:Update()
											mod.RocktopSafetyData[g.Position.X .. "." .. g.Position.Y] = true
										end
									end

									--table.remove(FiendFolio.RoomGrids[GridEntityType[v]], i)
									--i = i - 1
								end
							end
						end
					end
				end
			end
		else
			FiendFolio.GatherGrids()
		end
		if updateGrids then
			FiendFolio.GatherGrids()
		end

		for i = 0, room:GetGridSize() do
			local g = room:GetGridEntity(i)
			local gt = g and g:GetType()
			if g and not StageAPI.IsCustomGrid(i, "FFRubberRock") and g.Desc.State == 2 and FiendFolio.RequiresRocktops[gt] then
				local g2 = room:GetGridEntityFromPos(g.Position + Vector(0, 40))
				local g2t = g2 and g2:GetType()

				g = gt == GridEntityType.GRID_ROCK_ALT and Isaac.GridSpawn(GridEntityType.GRID_DECORATION, (g2t == GridEntityType.GRID_ROCKB or g2t == GridEntityType.GRID_WALL or g2t == GridEntityType.GRID_DOOR) and 1 or 0, g.Position, true) or Isaac.GridSpawn(GridEntityType.GRID_GRAVITY, 0, g.Position, true)

				local topsprite = g:GetSprite()
				if gt == GridEntityType.GRID_ROCK_ALT then
					local suffix = mod:getCrawlspaceBackdropSuffix()
					local rockString = "_" .. suffix
					if rockString == "_default" then
						rockString = ""
					end
					topsprite:Load("gfx/grid/tiles_itemdungeon.anm2")
					topsprite:ReplaceSpritesheet(0, "gfx/grid/tiles_itemdungeon" .. rockString .. ".png")
					topsprite:LoadGraphics()

					topsprite:Play("Ladder"..(g:GetVariant() + 1))
				end

				if g2 and (g2t == GridEntityType.GRID_ROCKB or g2t == GridEntityType.GRID_WALL or g2t == GridEntityType.GRID_DOOR) then
					topsprite = g2:GetSprite()
					if gt ~= GridEntityType.GRID_ROCK_ALT then
						topsprite:Play("Floor"..math.random(3))
					end

					topsprite:Play("Brick"..math.random(3))
				end
			end
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, function(_, bomb)
	local data = mod:GetEntityData(bomb)
	mod:erflyPostBombUpdate(bomb, data)
	mod:ferriumPostBombUpdate(bomb, data)
end)

mod:AddCallback(ModCallbacks.MC_POST_BOMB_RENDER, function(_, bomb, offset)
	local data = mod:GetEntityData(bomb)
	mod:erflyPostBombRender(bomb, offset, data)
end)

mod:AddCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_ACTIVE_ITEM, function(_, player, slot, offset, alpha, scale, chargeBarOffset)
	local d = mod:GetEntityData(player)
	local sd = d.ffsavedata
	mod:ProductivityModuleRenderActive(player, slot, offset, alpha, scale, d)
end)

mod:AddCallback(ModCallbacks.MC_PRE_EFFECT_UPDATE, function(_, creep)
	if creep.FrameCount == 0 then
		local data = mod:GetEntityData(creep)

		-- colors that should get the aquarius tearcolor processing applied
		creep.Color = data.FFAquariusTearColor or creep.Color

		-- damage from random effects that arent handled by MC_EVALUATE_TEAR_HIT_PARAMS
		mod:handleAquariusDichroDamage(creep)
		mod:handleAquariusFortuneDamage(creep)
		mod:handleAquariusAmmoClipDamage(creep)
		mod:handleAquariusSpinachDamage(creep)
	end
end, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, creep)
	local data = mod:GetEntityData(creep)

	-- colors that should just be straight applied
	if creep.FrameCount == 0 then
		mod:canOfBeansAquariusColor(creep, data)

		if data.FFAquariusColor then
			creep.Color = data.FFAquariusColor
		end
	end
end, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
	for _, p in pairs(Isaac.FindByType(EntityType.ENTITY_PLAYER, -1, -1, false, false)) do
		p = p:ToPlayer()
		local data = mod:GetEntityData(p)
		mod:erflyPostNewLevelPlayer(p, data)
		mod:corrodeStorageBattery(p)
	end

	mod.customBombs = {}
	mod.d12machines = {}
	mod.d12ed_Rooms = {}
	mod.d12switch = nil

	mod.elitejontopness = true
	mod:erflyPostNewLevelGeneral()

	mod.getFieldInit(FiendFolio.savedata, 'run', {}).level = {}
	if FiendFolio.gamestarted then
		FiendFolio.savedata.GateCurseKeyCollected = nil
		FiendFolio.savedata.GateCurseDoorIsUnlocked = false
		FiendFolio.savedata.TriggeredGateKeySpawnFailsafe = false
		FiendFolio.savedata.TriggeredGateDoorFailsafe = false
		FiendFolio.SaveSaveData()
	end
end)

function mod:FiendNewRoomStuff()
	local room = game:GetRoom()
	local level = game:GetLevel()
	local roomtype = room:GetType()

	for _, p in pairs(Isaac.FindByType(EntityType.ENTITY_PLAYER, -1, -1, false, false)) do
		if p:Exists() then
			p = p:ToPlayer()
			local data = mod:GetEntityData(p)
			data.ribsout = 0
			p:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
			p:EvaluateItems()
		end
	end

	mod:babyCraterNewRoom()
	mod.minionMorphOnNewRoom()
end

function mod.IsActiveRoom(roomtype)
	local room = game:GetRoom()
	return room:IsAmbushActive() or not room:IsClear()
end

mod:AddPriorityCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, -1, function(_, player, collider, low)
	player = player:ToPlayer()
	local cData = mod:GetEntityData(collider)
	local result1 = mod:ShadowRabbitsCollision(player, collider, low)
	if result1 then
		return result1
	end
	mod:handleKillerNeedle(player, collider, cData)
	mod:playerGrabBomb(player, collider, cData)
	mod:erflyPrePlayerCollision(player, collider)
	local result = mod:ferriumPrePlayerCollision(player, collider, low)
	if result then
		return result
	end

	if collider.Type == mod.FF.Hitbox.ID and collider.Variant == mod.FF.Hitbox.Var then
		result = mod:HitboxPrePlayerCollision(collider, player, cData)
		if result then
			return result
		end
	end
end)

function mod.IsDebugThreeActive()
	return game:GetDebugFlags() & DebugFlag.INFINITE_HP > 0
end

local function checkLargeDoseStats(player, data)
	if data.RunEffects then
		local caches = {[0] = CacheFlag.CACHE_DAMAGE, [1] = CacheFlag.CACHE_FIREDELAY, [2] = CacheFlag.CACHE_SHOTSPEED, [3] = CacheFlag.CACHE_RANGE, [4] = CacheFlag.CACHE_SPEED}
		local rng = player:GetCollectibleRNG(FiendFolio.ITEM.COLLECTIBLE.LARGE_DOSE)
		data.RunEffects.largeDoseStats = data.RunEffects.largeDoseStats or {}
		local num = player:GetCollectibleNum(FiendFolio.ITEM.COLLECTIBLE.LARGE_DOSE)
		if #data.RunEffects.largeDoseStats < num then
			for i=num+1,#data.RunEffects.largeDoseStats do
				data.RunEffects.largeDoseStats[i] = nil
			end
		end
		for i=1,num do
			data.RunEffects.largeDoseStats[i] = data.RunEffects.largeDoseStats[i] or caches[rng:RandomInt(5)]
		end
	end
end

local function getBasegameDamageMultiplier(player)
	local data = mod:GetEntityData(player)
	local sdata = data.ffsavedata
	local effects = player:GetEffects()

	local multi = 1.0
	if effects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_MEGA_MUSH) > 0 then
		multi = multi * 4.0
	end
	if player:GetCollectibleNum(CollectibleType.COLLECTIBLE_EVES_MASCARA) > 0 then
		multi = multi * 2.0
	end
	if player:GetCollectibleNum(CollectibleType.COLLECTIBLE_POLYPHEMUS) > 0 and
	   player:GetCollectibleNum(CollectibleType.COLLECTIBLE_20_20) == 0
	then
		multi = multi * 2.0
	end
	if player:GetCollectibleNum(CollectibleType.COLLECTIBLE_SACRED_HEART) > 0 then
		multi = multi * 2.3
	end
	if player:GetCollectibleNum(CollectibleType.COLLECTIBLE_ALMOND_MILK) > 0 then
		multi = multi * 0.3
	elseif player:GetCollectibleNum(CollectibleType.COLLECTIBLE_SOY_MILK) > 0 then
		multi = multi * 0.2
	end
	if player:GetCollectibleNum(CollectibleType.COLLECTIBLE_IMMACULATE_HEART) > 0 then
		multi = multi * 1.2
	end
	if effects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT) > 0 then
		multi = multi * 2.0
	end
	if player:GetCollectibleNum(CollectibleType.COLLECTIBLE_HAEMOLACRIA) > 0 then
		multi = multi * 1.5
	end
	if player:GetCollectibleNum(CollectibleType.COLLECTIBLE_20_20) > 0 then
		multi = multi * 0.8
	end

	if player:GetCollectibleNum(CollectibleType.COLLECTIBLE_CRICKETS_HEAD) > 0 or
	   player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM) > 0 or
	   (player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BLOOD_OF_THE_MARTYR) > 0 and
		effects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL) > 0)
	then
		multi = multi * 1.5
	end

	--if data.FFInBethlehemAura and data.FFInBethlehemAura > 0 then -- Star of Bethlehem
	--	multi = multi * 1.8
	--elseif data.FFInHallowAura and data.FFInHallowAura > 0 then -- Hallowed Ground
	--	multi = multi * 1.2
	--elseif data.FFInHallowDipAura and data.FFInHallowDipAura > 0 then -- Hallowed Ground + Dirty Mind
	--	multi = multi * 1.2
	--end

	if player:GetHallowedGroundCountdown() > 0 then
		multi = multi * 1.2
	end

	multi = multi * (1 + 0.2 * player:GetTrinketMultiplier(TrinketType.TRINKET_CRACKED_CROWN))

	local succubi = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.SUCCUBUS)
	for _, succubus in ipairs(succubi) do
		if (player.Position - succubus.Position):Length() < 100 then
			multi = multi * 1.5
		end
	end

	return multi
end

--hopefully obsolete now. leaving for legacy purposes
--[[local function diminishedDamageUp(player)
	local data = mod:GetEntityData(player)
	local sdata = data.ffsavedata
	local effects = player:GetEffects()

	local toBeDiminished = 0

	toBeDiminished = toBeDiminished + effects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_RAZOR_BLADE) * 1.2
	toBeDiminished = toBeDiminished + effects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL) * 2.0
	toBeDiminished = toBeDiminished + effects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_THE_NAIL) * 2.0
	toBeDiminished = toBeDiminished + effects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_GOLDEN_RAZOR) * 1.2
	toBeDiminished = toBeDiminished + math.max(0, effects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_SULFUR) +
												  player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BRIMSTONE) - 1) * 1.8

	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_ABADDON) * 1.5
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_CAPRICORN) * 0.5
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_CAT_O_NINE_TAILS) * 1.0
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_CHAMPION_BELT) * 1.0
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_CRICKETS_HEAD) * 0.5
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_DARK_MATTER) * 1.0
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_DEATHS_TOUCH) * 1.5
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_GODHEAD) * 0.5
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_GROWTH_HORMONES) * 1.0
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_GUILLOTINE) * 1.0
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_IRON_BAR) * 0.3
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_JESUS_JUICE) * 0.5
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM) * 0.3
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MEAT) * 0.3
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MY_REFLECTION) * 1.5
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_ODD_MUSHROOM_LARGE) * 1.0
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_PENTAGRAM) * 1.0
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_SMB_SUPER_FAN) * 0.3
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_STEVEN) * 1.0
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_STIGMATA) * 0.3
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_SYNTHOIL) * 1.0
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_HALO) * 0.3
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MARK) * 1.0
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_PACT) * 0.5
	toBeDiminished = toBeDiminished + (effects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON) ^ 2) * 1.5
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_8_INCH_NAILS) * 1.5
	toBeDiminished = toBeDiminished + math.min(effects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_LUSTY_BLOOD), 10) * 0.5
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_DOG_TOOTH) * 0.3
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_HAEMOLACRIA) * 1.0
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_SULFURIC_ACID) * 0.3
	toBeDiminished = toBeDiminished + (effects:GetNullEffectNum(NullItemID.ID_BLOOD_OATH) ^ 2) * 0.15
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_DOGMA) * 2.0
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_EYE_OF_THE_OCCULT) * 1.0
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_GLASS_EYE) * 0.75
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MOMS_RING) * 1.0
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_SAUSAGE) * 0.5
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_STAPLER) * 1.0
	toBeDiminished = toBeDiminished + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_TERRA) * 1.0
	toBeDiminished = toBeDiminished + effects:GetTrinketEffectNum(TrinketType.TRINKET_RED_PATCH) * 1.8
	toBeDiminished = toBeDiminished + effects:GetTrinketEffectNum(TrinketType.TRINKET_SAMSONS_LOCK) * 0.5
	toBeDiminished = toBeDiminished + effects:GetNullEffectNum(49) * 0.5 -- Lazarus revival boost

	local evilTotal = player:GetCollectibleNum(CollectibleType.COLLECTIBLE_ABADDON) +
					  player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BLACK_CANDLE) +
					  player:GetTrinketMultiplier(TrinketType.TRINKET_BLACK_LIPSTICK) +
					  player:GetCollectibleNum(CollectibleType.COLLECTIBLE_CEREMONIAL_ROBES) +
					  player:GetTrinketMultiplier(TrinketType.TRINKET_DAEMONS_TAIL) +
					  player:GetCollectibleNum(CollectibleType.COLLECTIBLE_FALSE_PHD) +
					  player:GetCollectibleNum(CollectibleType.COLLECTIBLE_GOAT_HEAD) +
					  player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MATCH_BOOK) +
					  player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MISSING_PAGE_2) +
					  player:GetCollectibleNum(CollectibleType.COLLECTIBLE_SAFETY_PIN)
	if REPENTANCE_PLUS then
		evilTotal = evilTotal +
					  player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MARK) +
					  player:GetCollectibleNum(CollectibleType.COLLECTIBLE_PACT)
	end
	toBeDiminished = toBeDiminished + player:GetTrinketMultiplier(TrinketType.TRINKET_BLACK_FEATHER) * 0.5 * evilTotal

	toBeDiminished = toBeDiminished + ((player:HasCollectible(CollectibleType.COLLECTIBLE_BLOOD_OF_THE_MARTYR) and 1.0) or 0.0)
	toBeDiminished = toBeDiminished + ((player:HasCollectible(CollectibleType.COLLECTIBLE_CEREMONIAL_ROBES) and 1.0) or 0.0)
	toBeDiminished = toBeDiminished + ((player:HasCollectible(CollectibleType.COLLECTIBLE_PROPTOSIS) and 0.5) or 0.0)
	toBeDiminished = toBeDiminished + ((player:HasCollectible(CollectibleType.COLLECTIBLE_SMALL_ROCK) and 1.0) or 0.0)
	toBeDiminished = toBeDiminished + ((player:HasCollectible(CollectibleType.COLLECTIBLE_HEARTBREAK) and (0.25 * player:GetBrokenHearts())) or 0.0)
	toBeDiminished = toBeDiminished + ((player:HasPlayerForm(PlayerForm.PLAYERFORM_BABY) and 0.3) or 0.0)
	toBeDiminished = toBeDiminished + ((player:HasPlayerForm(PlayerForm.PLAYERFORM_DRUGS) and 2.0) or 0.0)
	toBeDiminished = toBeDiminished + ((effects:GetNullEffectNum(NullItemID.ID_BLOODY_BABYLON) > 0 and 1.5) or 0.0)

	local activeItem = player:GetActiveItem(0)
	if activeItem ~= 0 then
		local charge = player:GetBatteryCharge(0)
		local maxCharge = Isaac.GetItemConfig():GetCollectible(activeItem).MaxCharges
		toBeDiminished = toBeDiminished + ((player:HasTrinket(TrinketType.TRINKET_DIM_BULB) and
											maxCharge > 0 and
											charge == 0 and
											1.5) or 0.0)
		toBeDiminished = toBeDiminished + ((player:HasTrinket(TrinketType.TRINKET_VIBRANT_BULB) and
											maxCharge > 0 and
											charge == maxCharge and
											0.5) or 0.0)
	end

	-- Purity (red): +4.0
	-- Binge Eater (temporary): +3.6
	-- False PHD (per stat down pill): +0.6
	-- Red Stew (temporary): +21.6
	-- Redemption: +1.0
	-- Judas Birthright: ???
	-- Camo Undies: ???

	local toBeDiminishedFF = 0

	-- PUT FF STUFF HERE

	toBeDiminishedFF = toBeDiminishedFF + player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.GMO_CORN) * 1.0
	toBeDiminishedFF = toBeDiminishedFF + player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.FETAL_FIEND) * 1.5
	toBeDiminishedFF = toBeDiminishedFF + player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.SMALL_PIPE) * 0.2
	toBeDiminishedFF = toBeDiminishedFF + player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.SMALL_WOOD) * 0.2
	toBeDiminishedFF = toBeDiminishedFF + math.min(1,player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.BIG_ROCK)) * 2
	toBeDiminishedFF = toBeDiminishedFF + player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.BIG_PIPE) * 0.4
	toBeDiminishedFF = toBeDiminishedFF + player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.BIG_WOOD) * 0.4
	toBeDiminishedFF = toBeDiminishedFF + player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.FRAUDULENT_FUNGUS) * 0.3
	toBeDiminishedFF = toBeDiminishedFF + player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.GRIDDLED_CORN) * 0.3
	toBeDiminishedFF = toBeDiminishedFF + player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.STRANGE_RED_OBJECT) * 0.3
	toBeDiminishedFF = toBeDiminishedFF + player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.HOST_ON_TOAST) * 0.5
	toBeDiminishedFF = toBeDiminishedFF + player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.SMASH_TROPHY) * 1
	toBeDiminishedFF = toBeDiminishedFF + player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.GREEN_ORANGE) * 0.7
	toBeDiminishedFF = toBeDiminishedFF + player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.LE_CAT) * 0.5
	toBeDiminishedFF = toBeDiminishedFF + player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.LEVEL_2_BREAKFAST) * 0.7
	toBeDiminishedFF = toBeDiminishedFF + player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.EMPTY_GAZE) * 0.3
	toBeDiminishedFF = toBeDiminishedFF + player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.CEILING_POPCORN) * 0.7
	toBeDiminishedFF = toBeDiminishedFF + player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.DARK_BARGAIN) * 1
	toBeDiminishedFF = toBeDiminishedFF + math.min(1,player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.TOWER_OF_HEAVEN) * 0.3)
	toBeDiminishedFF = toBeDiminishedFF + (data.dichromaticgraze or 0) * 0.2
	toBeDiminishedFF = toBeDiminishedFF + math.min((sdata.CursedPennyStats or 0) * 0.05, 10)
	toBeDiminishedFF = toBeDiminishedFF + player:GetTrinketMultiplier(FiendFolio.ITEM.TRINKET.LOCKED_SHACKLE) * 1
	--print((sdata.RunEffects.lockedShackleBoost or 0))
	toBeDiminishedFF = toBeDiminishedFF + (sdata.RunEffects.lockedShackleBoost or 0) * 1
	toBeDiminishedFF = toBeDiminishedFF + (data.belialD122 or 0)
	toBeDiminishedFF = toBeDiminishedFF + (data.insatiableApatiteStrength or 0)
	toBeDiminishedFF = toBeDiminishedFF + (data.prismaticGeodeDamageBoost or 0)
	toBeDiminishedFF = toBeDiminishedFF + (sdata.heartShardOfChinaDamage or 0)
	if data.prismaticGeodeRainbowTimer then
		local geode = 1
		if mod.HasTwoGeodes(player) then
			geode = 2
		end
		toBeDiminishedFF = toBeDiminishedFF + 0.3*geode
	end
	if player:HasTrinket(FiendFolio.ITEM.ROCK.SMALLER_ROCK) and sdata.RunEffects.smallerRockCount then
		toBeDiminishedFF = toBeDiminishedFF+0.33*sdata.RunEffects.smallerRockCount
	end
	toBeDiminishedFF = toBeDiminishedFF + (sdata.RunEffects.electrumBelial or 0)*0.5
	toBeDiminishedFF = toBeDiminishedFF + (sdata.RunEffects.electrumSacrificial or 0)*0.5

	local ffEvilTotal = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.BLACK_LANTERN) +
						player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.EVIL_STICKER) +
						player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.DADS_HALF)
	toBeDiminishedFF = toBeDiminishedFF + player:GetTrinketMultiplier(TrinketType.TRINKET_BLACK_FEATHER) * 0.5 * ffEvilTotal

	toBeDiminishedFF = toBeDiminishedFF + ((sdata.alphacoinchallenge and 0.5) or 0.0)
	--toBeDiminishedFF = toBeDiminishedFF + ((player:HasCollectible(mod.ITEM.COLLECTIBLE.CHIRUMIRU) and 0.9) or 0.0)
	toBeDiminishedFF = toBeDiminishedFF + ((player:HasCollectible(mod.ITEM.COLLECTIBLE.THE_DELUXE) and
											player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MEAT) * 0.3) or 0.0)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.SPELLING_BEE) and sdata.RunEffects.SpellingBeeStats and sdata.RunEffects.SpellingBeeStats.Damage then
		toBeDiminishedFF = toBeDiminishedFF + math.max(-0.8, sdata.RunEffects.SpellingBeeStats.Damage*0.55*player:GetCollectibleNum(FiendFolio.ITEM.COLLECTIBLE.SPELLING_BEE))
	end
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.LARGE_DOSE) then
		checkLargeDoseStats(player, sdata)
		local num = player:GetCollectibleNum(FiendFolio.ITEM.COLLECTIBLE.LARGE_DOSE)
		local specials = 0
		if sdata.RunEffects.largeDoseStats then
			for i=1,num do
				if sdata.RunEffects.largeDoseStats[i] and sdata.RunEffects.largeDoseStats[i] == CacheFlag.CACHE_DAMAGE then
					specials = specials+1
				end
			end
		end
		toBeDiminishedFF = toBeDiminishedFF + 1*specials + 0.33*(num-specials)
	end
	if player:HasTrinket(FiendFolio.ITEM.TRINKET.EVIOLITE) then
		toBeDiminishedFF = toBeDiminishedFF + 1*(mod:GetEntityData(player).EvioliteItemDecay or 0)
	end
	if sdata.RunEffects.InternalizedHatredIncreases and player:HasTrinket(mod.ITEM.TRINKET.INTERNALIZED_HATRED) then
		toBeDiminishedFF = toBeDiminishedFF + (0.5*sdata.RunEffects.InternalizedHatredIncreases)^0.5
	end

	if player:HasTrinket(FiendFolio.ITEM.TRINKET.STAINED_CARD) then
		local damage = 2.5*(0.8^(sdata.RunEffects.StainedCardDamage or 0))
		toBeDiminishedFF = toBeDiminishedFF + damage
	end

	if player:HasCollectible(mod.ITEM.COLLECTIBLE.FETAL_FRIEND) then
		toBeDiminishedFF = toBeDiminishedFF + 0.8 * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.FETAL_FRIEND)
		if mod.HasFetalFriendAmmo(player) then
			toBeDiminishedFF = toBeDiminishedFF + 0.8 * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.FETAL_FRIEND)
		end
	end

	if data.QueensFruitDamage and data.QueensFruitDamage > 0 then
		toBeDiminishedFF = toBeDiminishedFF + data.QueensFruitDamage
	end

	if sdata.RunEffects then
		toBeDiminishedFF = toBeDiminishedFF + mod.golemDiminishingDamage(player)
	end

	if player:HasTrinket(FiendFolio.ITEM.TRINKET.FIVE_LEAF_CLOVER) then
		local mult = 0.1 * player:GetTrinketMultiplier(FiendFolio.ITEM.TRINKET.FIVE_LEAF_CLOVER)
		toBeDiminishedFF = toBeDiminishedFF + (player.Luck * mult)
	end

	if player:HasCollectible(mod.ITEM.COLLECTIBLE.BLACK_CANDELABRA) and sdata.RunEffects.BlackCandelabraBuff then
		toBeDiminishedFF = toBeDiminishedFF + sdata.RunEffects.BlackCandelabraBuff
	end
	if sdata.RunEffects.activatedCharcoal then
		toBeDiminishedFF = toBeDiminishedFF + math.max(0, sdata.RunEffects.activatedCharcoal-1)
	end

	-- END OF FF STUFF

	mod:GetEntityData(player).FFLastDiminishedDamage = toBeDiminishedFF

	toBeDiminishedFF = toBeDiminishedFF + toBeDiminished

	if player:HasCollectible(CollectibleType.COLLECTIBLE_ODD_MUSHROOM_THIN) then
		toBeDiminished = toBeDiminished * 0.9 - 0.4
		toBeDiminishedFF = toBeDiminishedFF * 0.9 - 0.4
	end

	local diminished = 3.50 * math.sqrt(math.max(toBeDiminished * 1.2 + 1,0))
	local diminishedFF = 3.50 * math.sqrt(math.max(toBeDiminishedFF * 1.2 + 1,0))

	local damage = diminishedFF - diminished

	local playerType = player:GetPlayerType()
	if (playerType == PlayerType.PLAYER_EVE and effects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON) == 0) or
	   playerType == PlayerType.PLAYER_MAGDALENE_B
	then
		damage = damage * 0.75
	end

	if playerType == PlayerType.PLAYER_BLUEBABY then
		damage = damage * 1.05
	end

	if playerType == PlayerType.PLAYER_CAIN or
	   playerType == PlayerType.PLAYER_KEEPER or
	   (playerType == PlayerType.PLAYER_EVE_B and effects:GetNullEffectNum(NullItemID.ID_BLOODY_BABYLON) == 0)
	then
		damage = damage * 1.20
	end

	if playerType == PlayerType.PLAYER_JUDAS then
		damage = damage * 1.35
	end

	if playerType == PlayerType.PLAYER_BLACKJUDAS then
		damage = damage * 2.00
	end

	if playerType == PlayerType.PLAYER_AZAZEL or
	   playerType == PlayerType.PLAYER_THEFORGOTTEN or
	   playerType == PlayerType.PLAYER_AZAZEL_B or
	   playerType == PlayerType.PLAYER_LAZARUS2_B or
	   playerType == PlayerType.PLAYER_THEFORGOTTEN_B
	then
		damage = damage * 1.50
	end

	if playerType == PlayerType.PLAYER_THELOST_B then
		damage = damage * 1.30
	end

	if playerType == PlayerType.PLAYER_LAZARUS2 then
		damage = damage * 1.40
	end

	damage = damage * getBasegameDamageMultiplier(player)

	-- Eden: ???
	-- D8: ???
	-- Dead Eye: ???

	-- co-op babies go in here somewhere lol

	player.Damage = player.Damage + damage
end]]

local function getFireRateFromFireDelay(firedelay)
	return 30 / (firedelay + 1)
end

local function tearsUp(firedelay, val)
	local currentTears = 30 / (firedelay + 1)
	local newTears = currentTears + val
	return math.max((30 / newTears) - 1, -0.99)
end

function mod:convertDelayToTears(delay)
	return 30 / (delay + 1)
end

function mod:convertTearsToDelay(tears)
	if tears == 0 then
		return 0
	end
	return (30 / tears) - 1
end

function mod:tearsMult(firedelay, mult)
	local currentTears = 30 / (firedelay + 1)
	local newTears = currentTears * mult
	return math.max((30 / newTears) - 1, -0.99)
end

function mod:convertTearMultABPToRep(mult)
	local baseFireRate = getFireRateFromFireDelay(10)
	local multipliedFireRate = getFireRateFromFireDelay(10 * mult)
	return multipliedFireRate / baseFireRate
end

mod.FamiliarsToBeEvaluated = {
	{mod.ITEM.COLLECTIBLE.DICE_BAG, mod.ITEM.FAMILIAR.DICE_BAG},
	{mod.ITEM.COLLECTIBLE.LIL_FIEND, mod.ITEM.FAMILIAR.LIL_FIEND},
	{mod.ITEM.COLLECTIBLE.BABY_CRATER, mod.ITEM.FAMILIAR.BABY_CRATER},
	{mod.ITEM.COLLECTIBLE.MAMA_SPOOTER, mod.ITEM.FAMILIAR.MAMA_SPOOTER},
	{mod.ITEM.COLLECTIBLE.RANDY_THE_SNAIL, mod.ITEM.FAMILIAR.RANDY_THE_SNAIL},
	{mod.ITEM.COLLECTIBLE.PEACH_CREEP, mod.ITEM.FAMILIAR.PEACH_CREEP},
	{mod.ITEM.COLLECTIBLE.GORGON, mod.ITEM.FAMILIAR.GORGON},
	{mod.ITEM.COLLECTIBLE.DEIMOS, mod.ITEM.FAMILIAR.DEIMOS},
	{mod.ITEM.COLLECTIBLE.PET_ROCK, mod.ITEM.FAMILIAR.PETROCK},
	{mod.ITEM.COLLECTIBLE.LIL_MINX, mod.ITEM.FAMILIAR.LIL_MINX},
	{mod.ITEM.COLLECTIBLE.LIL_LAMB, mod.ITEM.FAMILIAR.LIL_LAMB},
	{mod.ITEM.COLLECTIBLE.SIBLING_SYL, mod.ITEM.FAMILIAR.SIBLING_SYL},
	{mod.ITEM.COLLECTIBLE.GREG_THE_EGG, mod.ITEM.FAMILIAR.GREG},
	{mod.ITEM.COLLECTIBLE.FAMILIAR_FLY, mod.ITEM.FAMILIAR.ORANGE_BOOM_FLY},
	{mod.ITEM.COLLECTIBLE.WIMPY_BRO, mod.ITEM.FAMILIAR.WIMPY_BRO},
	{mod.ITEM.COLLECTIBLE.ROBOBABY3, mod.ITEM.FAMILIAR.ROBOBABY3},
	{mod.ITEM.COLLECTIBLE.D3, mod.ITEM.FAMILIAR.D3},
	{mod.ITEM.COLLECTIBLE.SACK_OF_SPICY, mod.ITEM.FAMILIAR.SACK_OF_SPICY},
	{mod.ITEM.COLLECTIBLE.CLUTCHS_CURSE, mod.ITEM.FAMILIAR.CLUTCHS_CURSE},
	{mod.ITEM.COLLECTIBLE.PET_PEEVE, mod.ITEM.FAMILIAR.PET_PEEVE},
	{mod.ITEM.COLLECTIBLE.BAG_OF_BOBBIES, mod.ITEM.FAMILIAR.BAG_OF_BOBBIES},
	{mod.ITEM.COLLECTIBLE.TOKEN_BAG, mod.ITEM.FAMILIAR.TOKEN_BAG},
	{mod.ITEM.COLLECTIBLE.LIL_FRIEND, mod.ITEM.FAMILIAR.LIL_FRIEND},
	{mod.ITEM.COLLECTIBLE.D5, mod.ITEM.FAMILIAR.D5},
	{mod.ITEM.COLLECTIBLE.TIME_IS_MONEY, mod.ITEM.FAMILIAR.TIME_IS_MONEY},
	{mod.ITEM.COLLECTIBLE.CHERUB_CHUBBY, mod.ITEM.FAMILIAR.CHERUB_CHUBBY},
	{mod.ITEM.COLLECTIBLE.OUTLET_BABY, mod.ITEM.FAMILIAR.OUTLET_BABY},
	{mod.ITEM.COLLECTIBLE.BURGLAR_BABY, mod.ITEM.FAMILIAR.BURGLAR_BABY},
	{mod.ITEM.COLLECTIBLE.PAPAL_PAL, mod.ITEM.FAMILIAR.PAPAL_PAL},
	{mod.ITEM.COLLECTIBLE.CYBORG_BABY, mod.ITEM.FAMILIAR.CYBORG_BABY},
	{mod.ITEM.COLLECTIBLE.BABY_BELL, mod.ITEM.FAMILIAR.BABY_BELL},
	{mod.ITEM.COLLECTIBLE.BLACK_CANDELABRA, mod.ITEM.FAMILIAR.BLACK_CANDELABRA},
	{mod.ITEM.COLLECTIBLE.DEVILSKNIFE, mod.ITEM.FAMILIAR.DEVILSKNIFE},
	{mod.ITEM.COLLECTIBLE.BAD_DATA, mod.ITEM.FAMILIAR.BABY_ORB},
	{mod.ITEM.COLLECTIBLE.ISOLATED, mod.ITEM.FAMILIAR.ISOLATED},
	{mod.ITEM.COLLECTIBLE.HARE_TRIGGER, mod.ITEM.FAMILIAR.HARE_TRIGGER},
	{mod.ITEM.COLLECTIBLE.DUMB_BUNNY, mod.ITEM.FAMILIAR.DUMB_BUNNY},
	{mod.ITEM.COLLECTIBLE.REPRESSION, mod.ITEM.FAMILIAR.REPRESSION},
	{mod.ITEM.COLLECTIBLE.SOUL_EXTRACTION_BUM, mod.ITEM.FAMILIAR.SOUL_EXTRACTION_BUM},
	{mod.ITEM.COLLECTIBLE.DEVILS_HARVEST, mod.ITEM.FAMILIAR.DEVILS_HARVEST},
	{mod.ITEM.COLLECTIBLE.SKIBIDI_BABY, mod.ITEM.FAMILIAR.SKIBIDI_BABY},
	{mod.ITEM.COLLECTIBLE.RED_NIGHTMARE, mod.ITEM.FAMILIAR.RED},
	{mod.ITEM.COLLECTIBLE.SEVEN_SEALS_2, mod.ITEM.FAMILIAR.MODERN_HORSEMINI},
	{mod.ITEM.COLLECTIBLE.LIL_GOLEM, mod.ITEM.FAMILIAR.LIL_GOLEM},
	{mod.ITEM.COLLECTIBLE.KALUS_TAIL, mod.ITEM.FAMILIAR.KALUS_TAIL},
}

function mod.GetExpectedFamiliarNum(player, item)
  return (
  		player:GetCollectibleNum(item)
  		+ player:GetEffects():GetCollectibleEffectNum(item)
  	)
end

mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, CallbackPriority.LATE, function(_, player, flag)
	local basedata = mod:GetEntityData(player)
	local data = basedata.ffsavedata
	if not data or (data and not data.RunEffects) then
		Isaac.DebugString("Something called evaluate cache too early for FF")
		return
	end

	if basedata.KeyGhostData ~= nil then
		for variant, collectedKeys in pairs(basedata.KeyGhostData) do
			player:CheckFamiliar(variant, #collectedKeys, grng)
		end
	end

	local spawnBossKeyGhost = FiendFolio.savedata.GateCurseKeyCollected and not FiendFolio.savedata.GateCurseDoorIsUnlocked
		and GetPtrHash(player) == GetPtrHash(Isaac.GetPlayer(FiendFolio.savedata.GateCurseKeyCollected or 0))
	player:CheckFamiliar(mod.ITEM.FAMILIAR.BOSS_KEYGHOST, spawnBossKeyGhost and 1 or 0, grng)

	--[[if player:GetEffects():HasNullEffect(FiendFolio.ITEM.NULL.BOSS_KEYGHOST) then
		player:CheckFamiliar(mod.ITEM.FAMILIAR.BOSS_KEYGHOST, 1, grng)
	else
		player:CheckFamiliar(mod.ITEM.FAMILIAR.BOSS_KEYGHOST, 0, grng)
	end]]
end, CacheFlag.CACHE_FAMILIARS)

function mod:GetCommunityAchievementDamage()
	return math.log(FiendFolio.CountingChannelWorldRecords.Canon.Regular * math.log(FiendFolio.CountingChannelWorldRecords.Canon.Hardcore, 10),15)
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, flag)
--IF THIS ERRORS IT MEANS SOMETHING'S CALLING EVALUATE CACHE WAY TOO EARLY, SOMETIMES FROM ANOTHER MOD
	local basedata = mod:GetEntityData(player)
	local data = basedata.ffsavedata
	local effects = player:GetEffects()
	if not data or (data and not data.RunEffects) then
		Isaac.DebugString("Something called evaluate cache too early for FF")
		return
	end

	if flag == CacheFlag.CACHE_FAMILIARS then
		local itemconfig = Isaac.GetItemConfig()

		local level = game:GetLevel()
		local inMinesEscape = level:HasAbandonedMineshaft() and level:GetDimension() == Dimension.MINESHAFT

		for i = 1, #mod.FamiliarsToBeEvaluated do
			player:CheckFamiliar(mod.FamiliarsToBeEvaluated[i][2], mod.GetExpectedFamiliarNum(player, mod.FamiliarsToBeEvaluated[i][1]), player:GetCollectibleRNG(mod.FamiliarsToBeEvaluated[i][1]), itemconfig:GetCollectible(mod.FamiliarsToBeEvaluated[i][1]))
		end

		--because blaz birthright these need subtypes to flicker properly
		player:CheckFamiliar(mod.ITEM.FAMILIAR.OPHIUCHUS,
							 math.min(4, mod.GetExpectedFamiliarNum(player, mod.ITEM.COLLECTIBLE.OPHIUCHUS)),
							 player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.OPHIUCHUS),
							 nil,
							 0)

		player:CheckFamiliar(mod.ITEM.FAMILIAR.CARELESS_WHISPERS,
							 math.min(5, mod.GetExpectedFamiliarNum(player, mod.ITEM.COLLECTIBLE.CARELESS_WHISPERS)),
							 player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.CARELESS_WHISPERS),
							 nil,
							 0)

		local numGrabber = math.min(10, mod.GetExpectedFamiliarNum(player, mod.ITEM.COLLECTIBLE.GRABBER))
		if Isaac.GetChallenge() == mod.challenges.handsOn then
			local numZero = 0
			local numTen = 0
			local numEleven = 0

			while numZero + numTen + numEleven < numGrabber do
				local sum = numZero + numTen + numEleven
				if sum % 3 == 0 then
					numZero = numZero + 1
				elseif sum % 3 == 1 then
					numTen = numTen + 1
				elseif sum % 3 == 2 then
					numEleven = numEleven + 1
				end
			end

			player:CheckFamiliar(mod.ITEM.FAMILIAR.GRABBER,
								 numZero,
								 player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.GRABBER),
								 nil,
								 0)

			player:CheckFamiliar(mod.ITEM.FAMILIAR.GRABBER,
								 numTen,
								 player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.GRABBER),
								 nil,
								 10)

			player:CheckFamiliar(mod.ITEM.FAMILIAR.GRABBER,
								 numEleven,
								 player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.GRABBER),
								 nil,
								 11)
		else
			player:CheckFamiliar(mod.ITEM.FAMILIAR.GRABBER,
								 numGrabber,
								 player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.GRABBER),
								 nil,
								 0)
		end

		mod.fireballFamiliarCache(player, data, grng)
		--[[if data and data.bobbyBagSpawnCount ~= nil then
			player:CheckFamiliar(mod.ITEM.FAMILIAR.FRAGILE_BOBBY, data.bobbyBagSpawnCount, grng)
		end]]
		if data and data.MorbidChunks ~= nil then
			local morbidRNG = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.YICK_HEART)
			player:CheckFamiliar(FiendFolio.ITEM.FAMILIAR.MORBID_CHUNK, data.MorbidChunks, morbidRNG)
			morbidRNG:Next()
		end

		local mernCount = mod.GetExpectedFamiliarNum(player, mod.ITEM.COLLECTIBLE.CORN_KERNEL)
		local mernRng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.CORN_KERNEL)

		player:CheckFamiliar(mod.ITEM.FAMILIAR.MERN_4, math.floor(mernCount / 4), mernRng)
		for i = 1, 3 do
			local n = mernCount % 4 == i and 1 or 0
			player:CheckFamiliar(mod.ITEM.FAMILIAR["MERN_"..i], n, mernRng)
		end

		mod:ferriumFamiliarCache(player, basedata)
		mod:beahEvaluateFamiliars(player)
		mod:sewingManualFamiliarCache(player)
		mod:planetXFamiliarCache(player, basedata)
	elseif flag == CacheFlag.CACHE_SPEED then
		if player:GetPlayerType() == FiendFolio.PLAYER.FIEND and not FiendFolio.FiendConfig.ImpBabyMode then
			player.MoveSpeed = player.MoveSpeed + mod.fiendstats.speed
		end
		if player:GetPlayerType() == FiendFolio.PLAYER.FRIEND then
			player.MoveSpeed = player.MoveSpeed + mod.FriendBalancing.Speed
		end

		if data.alphacoinfloorstats then
			player.MoveSpeed = player.MoveSpeed + (0.2 * data.alphacoinfloorstats)
		end

		if player:HasCollectible(CollectibleType.COLLECTIBLE_BINGE_EATER) and player:HasCollectible(mod.ITEM.COLLECTIBLE.TEA) then
			player.MoveSpeed = player.MoveSpeed + (-0.03 * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.TEA))
		end
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.BABY_FORMULA) then
			player.MoveSpeed = player.MoveSpeed + (0.05 * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.BABY_FORMULA))
		end
		if data.RunEffects and data.RunEffects.DeathCapFossilBoost then
			player.MoveSpeed = player.MoveSpeed + 0.04*data.RunEffects.DeathCapFossilBoost
		end
		if basedata.smokyQuartzSpeed then
			player.MoveSpeed = player.MoveSpeed + basedata.smokyQuartzSpeed
		end
		if basedata.prismaticGeodeSpeedTimer then
			player.MoveSpeed = player.MoveSpeed + basedata.prismaticGeodeSpeedBoost
		end
		if basedata.prismaticGeodeRainbowTimer then
			local geode = 1
			if mod.HasTwoGeodes(player) then
				geode = 2
			end
			player.MoveSpeed = player.MoveSpeed + 0.15*geode
		end
		if player:HasTrinket(FiendFolio.ITEM.ROCK.HEAVY_METAL) then
			player.MoveSpeed = player.MoveSpeed-0.15
		end
		if player:HasTrinket(FiendFolio.ITEM.ROCK.SMALLER_ROCK) and data.RunEffects.smallerRockCount then
			player.MoveSpeed = player.MoveSpeed-0.06*data.RunEffects.smallerRockCount
		end
		if player:HasTrinket(FiendFolio.ITEM.ROCK.NITRO_CRYSTAL) then
			if basedata.nitroCrystalStatBoost then
				player.MoveSpeed = player.MoveSpeed + math.log(basedata.nitroCrystalStatBoost, 10)/5
			end
		end
		if player:HasTrinket(FiendFolio.ITEM.ROCK.ATLAS_BURDEN) then
			player.MoveSpeed = player.MoveSpeed-0.15
		end
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.ANGELIC_LYRE_B) or (player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and data.VoidedLyre == 1) then
			player.MoveSpeed = player.MoveSpeed + mod.AngelicLyreStats.Blue.Speed
		end
		if data.Cyanide then
			player.MoveSpeed = player.MoveSpeed + (0.05 * data.Cyanide.Strength)
		end
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.GOLDSHI_LUNCH) then
			if not mod.IsActiveRoom() then
				basedata.GoldShipLunchCleared = true
				player.MoveSpeed = player.MoveSpeed+0.85 * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.GOLDSHI_LUNCH)
			else
				basedata.GoldShipLunchCleared = false
				player.MoveSpeed = player.MoveSpeed+0.1 * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.GOLDSHI_LUNCH)
			end
		end
		if player:HasTrinket(FiendFolio.ITEM.ROCK.RIDICULOUS_METAL) then
			if basedata.RidiculousMetalBoost then
				player.MoveSpeed = player.MoveSpeed + (0.1 * basedata.RidiculousMetalBoost[5])
			end
		end
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.SPELLING_BEE) and data.RunEffects.SpellingBeeStats and data.RunEffects.SpellingBeeStats.Speed then
			player.MoveSpeed = player.MoveSpeed + data.RunEffects.SpellingBeeStats.Speed*0.25*player:GetCollectibleNum(FiendFolio.ITEM.COLLECTIBLE.SPELLING_BEE)
		end
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.LARGE_DOSE) then
			checkLargeDoseStats(player, data)
			local num = player:GetCollectibleNum(FiendFolio.ITEM.COLLECTIBLE.LARGE_DOSE)
			local specials = 0
			if data.RunEffects.largeDoseStats then
				for i=1,num do
					if data.RunEffects.largeDoseStats[i] and data.RunEffects.largeDoseStats[i] == CacheFlag.CACHE_SPEED then
						specials = specials+1
					end
				end
			end
			player.MoveSpeed = player.MoveSpeed + 0.3*specials + 0.1*(num-specials)
		end
		if basedata.PeaterStats then
			player.MoveSpeed = player.MoveSpeed + basedata.PeaterStats.Speed
		end


		if player:HasTrinket(FiendFolio.ITEM.TRINKET.EVIOLITE) then
			player.MoveSpeed = player.MoveSpeed + 0.3*(basedata.EvioliteItemDecay or 0)
		end
		if player:HasTrinket(FiendFolio.ITEM.ROCK.BOOSTER_ROCK) then
			if basedata.BoosterRockStats and basedata.BoosterRockStats[1] == "Speed" then
				local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.BOOSTER_ROCK)
				player.MoveSpeed = player.MoveSpeed + basedata.BoosterRockStats[2]*mult
			else
				mod:BoosterRockNewRoom(player, basedata)
			end
		end
		if data.RunEffects.EighteenFootLeashBonus and data.RunEffects.EighteenFootLeashBonus.Speed > 0 then
			player.MoveSpeed = player.MoveSpeed+data.RunEffects.EighteenFootLeashBonus.Speed
		end
		if data.YellowCarSpeed then
			player.MoveSpeed = player.MoveSpeed + data.YellowCarSpeed
		end
		if basedata.WindyEnchantmentUsed then
			player.MoveSpeed = player.MoveSpeed+basedata.WindyEnchantmentUsed
		end

		if player:HasCollectible(mod.ITEM.COLLECTIBLE.MARK_OF_PAIN) then
			player.MoveSpeed = math.max(player.MoveSpeed - 0.01 * player:GetEffects():GetCollectibleEffectNum(mod.ITEM.COLLECTIBLE.MARK_OF_PAIN), math.min(player.MoveSpeed, 0.6))
		end
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.BOOK_OF_LEVIATHAN) and not effects:HasCollectibleEffect(mod.ITEM.COLLECTIBLE.BOOK_OF_LEVIATHAN) then
			player.MoveSpeed = math.max(player.MoveSpeed - 0.2, math.min(player.MoveSpeed, 0.6))
		end

		if basedata.PlayerFloodedStacks and basedata.FloodedStatusSlow then --MULTIPLIER, KEEP LAST
			if player.MoveSpeed < 1 then
				player.MoveSpeed = player.MoveSpeed-basedata.FloodedStatusSlow[2]
			else
				player.MoveSpeed = player.MoveSpeed*basedata.FloodedStatusSlow[1]
			end
		end
	elseif flag == CacheFlag.CACHE_DAMAGE then
		-- diminishing returns damage, obsolete with rgon
		-- diminishedDamageUp(player)

		-- pre multipliers flat damage (multiply by basemulti) SENT TO BELOW
		-- mulipliers
		if player:GetPlayerType() == FiendFolio.PLAYER.FIEND and not FiendFolio.FiendConfig.ImpBabyMode then
			player.Damage = player.Damage * mod.fiendstats.damage
		end
		if player:GetPlayerType() == FiendFolio.PLAYER.FRIEND then
			player.Damage = player.Damage * mod.FriendBalancing.Damage
		end

		local debt = mod.getField(FiendFolio.savedata, 'run', 'dadsdebt')
		if debt and player:HasCollectible(mod.ITEM.COLLECTIBLE.DADS_WALLET) then
			local debtPercent = debt / 99
			player.Damage = player.Damage * mod:Lerp(1, 0.1, debtPercent)
		end

		mod:updateMartyrDamage(player)

		if player:HasCollectible(mod.ITEM.COLLECTIBLE.LEFTOVER_TAKEOUT) then
			player.Damage = player.Damage * 1.5
		end
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.FIDDLE_CUBE) then
			basedata.storedFiddleCubeClicks = basedata.storedFiddleCubeClicks or {}
			player.Damage = player.Damage * (1 + (0.1 * math.min(#basedata.storedFiddleCubeClicks, 5)))
		end
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.ANGELIC_LYRE_B) or (player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and data.VoidedLyre == 1) then

		end
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.ANGELIC_LYRE_R) or (player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and data.VoidedLyre == 2) then
			player.Damage = player.Damage * mod.AngelicLyreStats.Red.DamageMult
		end
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.ANGELIC_LYRE_Y) or (player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and data.VoidedLyre == 0) then
			player.Damage = player.Damage * mod.AngelicLyreStats.Yellow.DamageMult
		end
		local peffects = player:GetEffects()
		if peffects:HasCollectibleEffect(mod.ITEM.COLLECTIBLE.HOT_POTATO_BOOK) then
			player.Damage = player.Damage * (1 + (0.05*(peffects:GetCollectibleEffectNum(mod.ITEM.COLLECTIBLE.HOT_POTATO_BOOK)+#Isaac.FindByType(3, FamiliarVariant.WISP, mod.ITEM.COLLECTIBLE.HOT_POTATO_BOOK))+0.008*(data.RunEffects.ElectrumPotatoBook or 0)))
		end

		if data.Cyanide then
			player.Damage = player.Damage * (1 + (0.5 * data.Cyanide.Strength))
		end

		if basedata.crazyJackpotStats and basedata.crazyJackpotStats.Damage then
			player.Damage = player.Damage * (1.2^basedata.crazyJackpotStats.Damage)
		end

		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.FIENDS_THIRD_LEG) then
			player.Damage = player.Damage * 3.33
		end

		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.JUMBO_JOSH) then
			player.Damage = player.Damage * 2
		end

		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.FRUIT_MILK) then
			player.Damage = player.Damage * 0.2
		end

	    if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.TECH_MODULO) then
        	player.Damage = player.Damage * 2/3
    	end

		if player:HasCollectible(mod.ITEM.COLLECTIBLE.CAN_OF_BEANS) and
		   not (player:HasWeaponType(WeaponType.WEAPON_BOMBS) or player:HasWeaponType(WeaponType.WEAPON_ROCKETS))
		then
			player.Damage = player.Damage * 1.35
		end

		if basedata.HasTwinkle then -- Twinkle of Contagion
			player.Damage = player.Damage*1.5
		end

		-- post multipliers flat damage (don't multiply by basemulti)
		player.Damage = player.Damage + mod.curvedGeodeDamage(player)

		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.DEVILS_ABACUS)
		or player:HasTrinket(FiendFolio.ITEM.TRINKET.PSYCHOLOGICAL_TORTURE)
		then
			local sd = data.RunEffects
			if sd.AbacusMaxBuff and sd.AbacusMaxBuff > 0 then
				player.Damage = player.Damage + math.log(1 + sd.AbacusMaxBuff/3)
			end
		end

		--Required to be 0.9, so moved it out of the diminishing returns code
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.CHIRUMIRU) then
			for i = 1, player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.CHIRUMIRU) do
				player.Damage = player.Damage + (0.9 * (0.5^(i - 1)))
			end
		end

		if player:HasCollectible(mod.ITEM.COLLECTIBLE.PLATINUM_CREST) then
        	local roomsCompleted = data.PlatinumCrestRoomsCompleted or 0
			local itemMult = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.PLATINUM_CREST)
			--Adjustable in the erfly/items/platinumcrest file
			player.Damage = player.Damage + (mod.PLATINUM_CREST_DAMAGE * roomsCompleted * itemMult)
		end

		if player:HasTrinket(FiendFolio.ITEM.ROCK.RIDICULOUS_METAL) then
			if basedata.RidiculousMetalBoost then
				player.Damage = player.Damage * (1 + (0.1 * basedata.RidiculousMetalBoost[1]))
			end
		end
		--Intentionally flat damage for these trinkets

		if mod:IsNearPepperStatue(player.Position, 0) then --Sculpted Pepper, Isaac Statue
			player.Damage = player.Damage*1.5
		end

	elseif flag == CacheFlag.CACHE_FIREDELAY then
		if player:GetPlayerType() == FiendFolio.PLAYER.FIEND and not FiendFolio.FiendConfig.ImpBabyMode then
			--player.MaxFireDelay = math.floor(player.MaxFireDelay * mod.fiendstats.tears) -- direct maxfiredelay multipliers break at negative firedelay values
			player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, mod:convertTearMultABPToRep(mod.fiendstats.tears))
		end
		if player:GetPlayerType() == FiendFolio.PLAYER.FRIEND then
			player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, mod:convertTearMultABPToRep(mod.FriendBalancing.Tears))
		end

		--mod:updateDevilledEggFireDelay(player)
		--[[if basedata.alphacointearsup and player.MaxFireDelay > 1 then
			player.MaxFireDelay = math.floor(player.MaxFireDelay * basedata.alphacointearsmulti)
			player.MaxFireDelay = math.max(1, math.floor(player.MaxFireDelay - basedata.alphacointearsup))
		end]]--

		mod:updateMartyrFireDelay(player)
		mod:updateTheDeluxeFireDelay(player)

		if player:HasCollectible(mod.ITEM.COLLECTIBLE.LEFTOVER_TAKEOUT) then
			--player.MaxFireDelay = math.floor(player.MaxFireDelay * 0.9) -- direct maxfiredelay multipliers break at negative firedelay values
			player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, mod:convertTearMultABPToRep(0.9))
		end

		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.ANGELIC_LYRE_B) or (player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and data.VoidedLyre == 1) then
			--player.MaxFireDelay = player.MaxFireDelay * mod.AngelicLyreStats.Blue.TearMult -- direct maxfiredelay multipliers break at negative firedelay values
			player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, mod:convertTearMultABPToRep(mod.AngelicLyreStats.Blue.TearMult))
		end
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.ANGELIC_LYRE_R) or (player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and data.VoidedLyre == 2) then
			--player.MaxFireDelay = player.MaxFireDelay * mod.AngelicLyreStats.Red.TearMult -- direct maxfiredelay multipliers break at negative firedelay values
			player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, mod:convertTearMultABPToRep(mod.AngelicLyreStats.Red.TearMult))
		end
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.ANGELIC_LYRE_Y) or (player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and data.VoidedLyre == 0) then
			--player.MaxFireDelay = player.MaxFireDelay * mod.AngelicLyreStats.Yellow.TearMult -- direct maxfiredelay multipliers break at negative firedelay values
			player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, mod:convertTearMultABPToRep(mod.AngelicLyreStats.Yellow.TearMult))
		end

		if data.Cyanide then
			--player.MaxFireDelay = player.MaxFireDelay / (1 + (0.5 * data.Cyanide.Strength)) -- direct maxfiredelay multipliers break at negative firedelay values
			player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, mod:convertTearMultABPToRep(1 / (1 + (0.5 * data.Cyanide.Strength))))
		end

		if basedata.crazyJackpotStats and basedata.crazyJackpotStats.Tears then
			--player.MaxFireDelay = player.MaxFireDelay / (1.2^basedata.crazyJackpotStats.Tears) -- direct maxfiredelay multipliers break at negative firedelay values
			player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, mod:convertTearMultABPToRep(1 / (1.2^basedata.crazyJackpotStats.Tears)))
		end
		if basedata.rapidFireOpalAmmo then
			local strength = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.FRIENDLY_RAPID_FIRE_OPAL)
			--player.MaxFireDelay = player.MaxFireDelay * 0.5 -- direct maxfiredelay multipliers break at negative firedelay values
			player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, mod:convertTearMultABPToRep(0.5))
		end

		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.FIENDS_THIRD_LEG) then
			--player.MaxFireDelay = player.MaxFireDelay * 0.5 -- direct maxfiredelay multipliers break at negative firedelay values
			player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, mod:convertTearMultABPToRep(0.5))
		end

		if basedata.HasTwinkle then -- Twinkle of Contagion
			--player.MaxFireDelay = player.MaxFireDelay*0.85 -- direct maxfiredelay multipliers break at negative firedelay values
			player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, mod:convertTearMultABPToRep(0.85))
		end

		if player:HasTrinket(FiendFolio.ITEM.ROCK.RIDICULOUS_METAL) then
			if basedata.RidiculousMetalBoost then
				--player.MaxFireDelay = player.MaxFireDelay * (0.9 ^ basedata.RidiculousMetalBoost[2]) -- direct maxfiredelay multipliers break at negative firedelay values
				player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, mod:convertTearMultABPToRep(0.9 ^ basedata.RidiculousMetalBoost[2]))
			end
		end

		if mod:IsNearPepperStatue(player.Position, 1) then --Sculpted Pepper, Maggy Statue
			--player.MaxFireDelay = player.MaxFireDelay*0.8 -- direct maxfiredelay multipliers break at negative firedelay values
			player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, mod:convertTearMultABPToRep(0.65))
		end


		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.DOUBLES) then
			player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, 0.456)
		end
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.TOWER_OF_HEAVEN) then
			player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, 1.2)
		end
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.BOOK_OF_LEVIATHAN) and not effects:HasCollectibleEffect(mod.ITEM.COLLECTIBLE.BOOK_OF_LEVIATHAN)  then
			player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, 0.8)
		end

		if player:HasCollectible(mod.ITEM.COLLECTIBLE.CAN_OF_BEANS) and
		   not player:HasCollectible(CollectibleType.COLLECTIBLE_C_SECTION)
		then
			player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, 0.5)
		end
	elseif flag == CacheFlag.CACHE_RANGE then
		local basemulti = player:GetD8RangeModifier()
		if player:HasCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE) then
			basemulti = basemulti * 0.8
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or
		   player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA) or
		   player:HasCollectible(CollectibleType.COLLECTIBLE_CRICKETS_BODY)
		then
			basemulti = basemulti * 0.8
		end

		mod:updateModelRocketRange(player, basemulti)

		--player.TearHeight = player.TearHeight - 2 * (data.CursedPennyStats or 0)

		if player:HasCollectible(CollectibleType.COLLECTIBLE_BINGE_EATER) and player:HasCollectible(mod.ITEM.COLLECTIBLE.TEA) then
			player.TearRange = player.TearRange + (60 * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.TEA) * basemulti)
		end
		if mod.HasTrinityWorm(player) then
			player.TearRange = player.TearRange + (500 * mod.GetTrinityWormMultiplier(player) * basemulti)
		end
		if data.RunEffects and data.RunEffects.DeathCapFossilBoost then
			player.TearRange = player.TearRange + 5*data.RunEffects.DeathCapFossilBoost * basemulti
		end
		if mod.HasTanWorm(player) then
			local mult = mod.GetTanWormMultiplier(player)
			player.TearRange = player.TearRange + 720*mult * basemulti
		end
		if basedata.prismaticGeodeRangeTimer then
			player.TearRange = player.TearRange + basedata.prismaticGeodeRangeBoost * basemulti
		end
		if basedata.prismaticGeodeRainbowTimer then
			local geode = 1
			if mod.HasTwoGeodes(player) then
				geode = 2
			end
			player.TearRange = player.TearRange + 30*geode * basemulti
		end
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.ANGELIC_LYRE_Y) or (player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and data.VoidedLyre == 0) then
			player.TearRange = player.TearRange + mod.AngelicLyreStats.Yellow.Range * basemulti
		end
		if data.Cyanide then
			player.TearRange = player.TearRange + (25 * data.Cyanide.Strength * basemulti)
		end
		if basedata.rapidFireOpalAmmo then
			local strength = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.FRIENDLY_RAPID_FIRE_OPAL)
			player.TearRange = player.TearRange + (250 * strength * basemulti)
		end

		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.ANGELIC_LYRE_Y) or (player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and data.VoidedLyre == 0) then
			player.TearRange = player.TearRange + mod.AngelicLyreStats.Yellow.Range * basemulti
		end

		if player:HasTrinket(FiendFolio.ITEM.ROCK.RIDICULOUS_METAL) then
			if basedata.RidiculousMetalBoost then
				player.TearRange = player.TearRange + (50 * basedata.RidiculousMetalBoost[3] * basemulti)
			end
		end

		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.SPELLING_BEE) and data.RunEffects.SpellingBeeStats and data.RunEffects.SpellingBeeStats.Range then
			player.TearRange = player.TearRange + math.max(-100, data.RunEffects.SpellingBeeStats.Range*56*player:GetCollectibleNum(FiendFolio.ITEM.COLLECTIBLE.SPELLING_BEE)) * basemulti
		end
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.LARGE_DOSE) then
			checkLargeDoseStats(player, data)
			local num = player:GetCollectibleNum(FiendFolio.ITEM.COLLECTIBLE.LARGE_DOSE)
			local specials = 0
			if data.RunEffects.largeDoseStats then
				for i=1,num do
					if data.RunEffects.largeDoseStats[i] and data.RunEffects.largeDoseStats[i] == CacheFlag.CACHE_RANGE then
						specials = specials+1
					end
				end
			end
			player.TearRange = player.TearRange + (100*specials + 33*(num-specials)) * basemulti
		end
		if player:HasTrinket(FiendFolio.ITEM.TRINKET.EVIOLITE) then
			player.TearRange = player.TearRange + 100*(basedata.EvioliteItemDecay or 0) * basemulti
		end
		if player:HasTrinket(FiendFolio.ITEM.ROCK.BOOSTER_ROCK) then
			if basedata.BoosterRockStats and basedata.BoosterRockStats[1] == "Range" then
				local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.BOOSTER_ROCK)
				player.TearRange = player.TearRange + basedata.BoosterRockStats[2]*mult * basemulti
			else
				mod:BoosterRockNewRoom(player, basedata)
			end
		end
		if data.RunEffects.DadsLostPennyStacks then
			player.TearRange = player.TearRange+data.RunEffects.DadsLostPennyStacks*100 * basemulti
		end
		if basedata.PeaterStats then
			player.TearRange = player.TearRange+basedata.PeaterStats.Range
		end
	elseif flag == CacheFlag.CACHE_SHOTSPEED then
		if player:GetPlayerType() == FiendFolio.PLAYER.FIEND and not FiendFolio.FiendConfig.ImpBabyMode then
			player.ShotSpeed = player.ShotSpeed + mod.fiendstats.shotspeed
		end
		if player:GetPlayerType() == FiendFolio.PLAYER.FRIEND or player:GetPlayerType() == FiendFolio.PLAYER.BRIEND then
			player.ShotSpeed = player.ShotSpeed + mod.FriendBalancing.Shotspeed
		end
		if player:HasTrinket(mod.ITEM.TRINKET.FORTUNE_WORM) then
			local factor = 1 + 0.5 * (player:GetTrinketMultiplier(mod.ITEM.TRINKET.FORTUNE_WORM) - 1)
			player.ShotSpeed = player.ShotSpeed + 0.2 * factor
		end

		if data.RunEffects and data.RunEffects.DeathCapFossilBoost then
			player.ShotSpeed = player.ShotSpeed + 0.03*data.RunEffects.DeathCapFossilBoost
		end
		if basedata.prismaticGeodeShotTimer then
			player.ShotSpeed = player.ShotSpeed + basedata.prismaticGeodeShotBoost
		end
		if basedata.prismaticGeodeRainbowTimer then
			local geode = 1
			if mod.HasTwoGeodes(player) then
				geode = 2
			end
			player.ShotSpeed = player.ShotSpeed + 0.18*geode
		end
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.ANGELIC_LYRE_B) or (player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and data.VoidedLyre == 1) then
			player.ShotSpeed = player.ShotSpeed + mod.AngelicLyreStats.Blue.Shotspeed
		end
		if basedata.rapidFireOpalAmmo then
			local strength = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.FRIENDLY_RAPID_FIRE_OPAL)
			player.ShotSpeed = player.ShotSpeed * (1.5 + strength/2)
		end
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.GOLDSHI_LUNCH) then
			if not mod.IsActiveRoom() then
				player.ShotSpeed = player.ShotSpeed+0.4
			else
				player.ShotSpeed = player.ShotSpeed+0.2
			end
		end

		if player:HasTrinket(FiendFolio.ITEM.ROCK.RIDICULOUS_METAL) then
			if basedata.RidiculousMetalBoost then
				player.ShotSpeed = player.ShotSpeed + (0.1 * basedata.RidiculousMetalBoost[4])
			end
		end

		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.SPELLING_BEE) and data.RunEffects.SpellingBeeStats and data.RunEffects.SpellingBeeStats.Shotspeed then
			player.ShotSpeed = player.ShotSpeed + data.RunEffects.SpellingBeeStats.Shotspeed*0.13*player:GetCollectibleNum(FiendFolio.ITEM.COLLECTIBLE.SPELLING_BEE)
		end
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.LARGE_DOSE) then
			checkLargeDoseStats(player, data)
			local num = player:GetCollectibleNum(FiendFolio.ITEM.COLLECTIBLE.LARGE_DOSE)
			local specials = 0
			if data.RunEffects.largeDoseStats then
				for i=1,num do
					if data.RunEffects.largeDoseStats[i] and data.RunEffects.largeDoseStats[i] == CacheFlag.CACHE_SHOTSPEED then
						specials = specials+1
					end
				end
			end
			player.ShotSpeed = player.ShotSpeed + 0.35*specials + 0.12*(num-specials)
		end

		if player:HasTrinket(FiendFolio.ITEM.TRINKET.EVIOLITE) then
			player.ShotSpeed = player.ShotSpeed + 0.3*(basedata.EvioliteItemDecay or 0)
		end

		if basedata.PeaterStats then
			player.ShotSpeed = player.ShotSpeed + basedata.PeaterStats.ShotSpeed
		end

		--Intentionally doesn't stack
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.DEAL_OF_THE_DEMONS) then
			player.ShotSpeed = player.ShotSpeed + 1.5
		end

	elseif flag == CacheFlag.CACHE_LUCK then
		if player:GetPlayerType() == FiendFolio.PLAYER.FIEND and not FiendFolio.FiendConfig.ImpBabyMode then
			player.Luck = player.Luck + mod.fiendstats.luck
		end
		if player:GetPlayerType() == FiendFolio.PLAYER.FRIEND then
			player.Luck = player.Luck + mod.FriendBalancing.Luck
			player.Luck = player.Luck + mod.FriendBalancing.FriendsLuckyPenny
		end
		if player:HasTrinket(mod.ITEM.TRINKET.FORTUNE_WORM) then
			local multiplier = player:GetTrinketMultiplier(mod.ITEM.TRINKET.FORTUNE_WORM)
			player.Luck = player.Luck + 2 * multiplier
		end
		if player:HasTrinket(mod.ITEM.TRINKET.FORTUNE_GRUB) then
			local multiplier = player:GetTrinketMultiplier(mod.ITEM.TRINKET.FORTUNE_GRUB)
			player.Luck = player.Luck + 1 * multiplier
		end

		local levelNum = mod:getFloorDepth()
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.BEGINNERS_LUCK) then
			player.Luck = player.Luck + ((math.min(math.max(0.5, 5.5 - levelNum / 2), 5)) * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.BEGINNERS_LUCK))
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BINGE_EATER) and player:HasCollectible(mod.ITEM.COLLECTIBLE.TEA) then
			player.Luck = player.Luck + (1 * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.TEA))
		end
		if data.RunEffects and data.RunEffects.DeathCapFossilBoost then
			player.Luck = player.Luck + math.ceil(data.RunEffects.DeathCapFossilBoost/3)
		end
		if data.RunEffects and data.RunEffects.dogrockRock then
			player.Luck = player.Luck-math.ceil(data.RunEffects.dogrockRock)
		end
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.ANGELIC_LYRE_B) or (player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and data.VoidedLyre == 1) then
			player.Luck = player.Luck + mod.AngelicLyreStats.Blue.Luck
		end
		if basedata.crazyJackpotStats and basedata.crazyJackpotStats.Luck then
			player.Luck = player.Luck + (3 * basedata.crazyJackpotStats.Luck)
		end
		if basedata.HasTwinkle then -- Twinkle of Contagion
			player.Luck = player.Luck + 3
		end
		if basedata.ShuffleTimeLuck then
			player.Luck = player.Luck + basedata.ShuffleTimeLuck
		end
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.SPELLING_BEE) and data.RunEffects.SpellingBeeStats and data.RunEffects.SpellingBeeStats.Luck then
			player.Luck = player.Luck + math.ceil(data.RunEffects.SpellingBeeStats.Luck)*player:GetCollectibleNum(FiendFolio.ITEM.COLLECTIBLE.SPELLING_BEE)
		end
		if player:HasTrinket(FiendFolio.ITEM.TRINKET.EVIOLITE) then
			player.Luck = player.Luck + math.floor(3*(basedata.EvioliteItemDecay or 0))
		end
		if basedata.ffsavedata.RunEffects.PaperMarioInnate then --Counteracts the luck from the Evil Charm wisp
			player.Luck = player.Luck-2
		end
		if basedata.PeaterStats then
			player.Luck = player.Luck+basedata.PeaterStats.Luck
		end
		if data.RunEffects.DadsLostPennyStacks then
			player.Luck = player.Luck+data.RunEffects.DadsLostPennyStacks
		end
		if player:GetPlayerType() == mod.PLAYER.BRIEND and not mod:IsBriendTwin(player) then
			player.Luck = player.Luck + mod.BriendBalancing.RevolverLuckFlat
		end
	elseif flag == CacheFlag.CACHE_TEARFLAG then
		--[[if player:GetPlayerType() == FiendFolio.PLAYER.FIEND and FiendFolio.FiendConfig.ClassicTears and not FiendFolio.FiendConfig.ImpBabyMode then
			player.TearFlags = player.TearFlags | mod.fiendstats.flag
		end]]
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.ANGELIC_LYRE_R) or (player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and data.VoidedLyre == 2) then
			player.TearFlags = player.TearFlags | mod.AngelicLyreStats.Red.Flags
		end
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.ANGELIC_LYRE_Y) or (player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and data.VoidedLyre == 0) then
			player.TearFlags = player.TearFlags | mod.AngelicLyreStats.Yellow.Flags
		end
		if basedata.rapidFireOpalAmmo then
			player.TearFlags = player.TearFlags | TearFlags.TEAR_PIERCING
		end
		--I still fucking hate this, fuck you mime degree
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.MIME_DEGREE) then
			if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY) then
				player.TearFlags = player.TearFlags | TearFlags.TEAR_SPECTRAL
			end
		end
		if basedata.FriendEternalHoming then
			player.TearFlags = player.TearFlags | TearFlags.TEAR_HOMING
		end
		if basedata.FriendResetTempFlags then
			player.TearFlags = basedata.FriendResetTempFlags
			basedata.FriendResetTempFlags = nil
		end
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.GANYMEDE) then
			player.TearFlags = player.TearFlags | TearFlags.TEAR_SPECTRAL
		end
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.FRUIT_MILK) or player:HasTrinket(mod.ITEM.TRINKET.POPPET) then
			if data.RunEffects.WickedBonusVanillaFlags ~= nil then
				player.TearFlags = player.TearFlags | data.RunEffects.WickedBonusVanillaFlags
			end
		end
		mod:updateMartyrTearFlags(player)
	elseif flag == CacheFlag.CACHE_TEARCOLOR then
		--[[if player:GetPlayerType() == FiendFolio.PLAYER.FIEND and FiendFolio.FiendConfig.ClassicTears and not FiendFolio.FiendConfig.ImpBabyMode then
			player.TearColor = player.TearColor * mod.fiendstats.colour
		end]]

		if basedata.BriendGritBoost then
			player.TearColor = player.TearColor * mod.ColorGunslingersGritPurple
			player.LaserColor = mod.ColorGunslingersGritPurple
		end

		mod:updateMartyrTearLaserColor(player)

		if player:HasTrinket(mod.ITEM.TRINKET.FORTUNE_WORM) or player:HasTrinket(FiendFolio.ITEM.ROCK.FORTUNE_WORM_FOSSIL) or player:HasCollectible(mod.ITEM.COLLECTIBLE.LEFTOVER_TAKEOUT) then
			local lasercolor = Color(1.0, 1.0, 1.0, 1.0, 0/255, 0/255, 0/255)
			lasercolor:SetColorize(4.5, 3.44, 2.41, 1)
			player.LaserColor = player.LaserColor * lasercolor
		end
		if mod:GetEntityData(player).TrickyCherryCrit then
			local lasercolor = Color(1.0, 1.0, 1.0, 1.0, 0/255, 0/255, 0/255)
			lasercolor:SetColorize(6, 0.9, 0.9, 1)
			player.LaserColor = player.LaserColor * lasercolor
		elseif player:HasCollectible(mod.ITEM.COLLECTIBLE.IMP_SODA) or player:HasTrinket(FiendFolio.ITEM.ROCK.SODALITE_GEODE) then
			local lasercolor = Color(1.0, 1.0, 1.0, 1.0, 0/255, 0/255, 0/255)
			lasercolor:SetColorize(5.7, 0.9, 3.4, 1)
			player.LaserColor = player.LaserColor * lasercolor
		end

		if player:HasCollectible(mod.ITEM.COLLECTIBLE.RED_NO_3) then
			player.TearColor = player.TearColor * mod.ColorRedNo3
		end
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.DRIED_PAINT) then
			player.TearColor = player.TearColor * FiendFolio.ColorDriedPaint2
		end
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.EYE_OF_PROVIDENCE) then
			player.TearColor = player.TearColor * FiendFolio.ColorEyeOfProvidenceTear
		end
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.WNIC) then
			player.TearColor = player.TearColor * FiendFolio.ColorWNICTear
		end
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.GANYMEDE) then
			player.TearColor = player.TearColor * mod.AngelicLyreStats.Red.Color
		end
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.DARKNESS) then
			player.TearColor = player.TearColor * FiendFolio.ColorDarknessTear
		end
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.SOAPSUDS) then
			player.TearColor = player.TearColor * FiendFolio.ColorSoapsuds
			player.LaserColor = player.LaserColor * FiendFolio.ColorSoapsudsLaser
		end
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.PALINSOPIA) then
			player.TearColor = FiendFolio.ColorPalinopsiaTear
		end

		--Keep at end 'cos not always active ig
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.ANGELIC_LYRE_R) or (player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and data.VoidedLyre == 2) then
			player.TearColor = player.TearColor * mod.AngelicLyreStats.Red.Color
		end
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.ANGELIC_LYRE_Y) or (player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and data.VoidedLyre == 0) then
			player.TearColor = player.TearColor * mod.AngelicLyreStats.Yellow.Color
			player.LaserColor = player.LaserColor * mod.AngelicLyreStats.Yellow.Color
		end
	elseif flag == CacheFlag.CACHE_SIZE then
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.JUMBO_JOSH) then
			local amount = player:GetCollectibleNum(FiendFolio.ITEM.COLLECTIBLE.JUMBO_JOSH)
			player.SpriteScale = player.SpriteScale * (1.75 + (0.25 * amount))
		end
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.BABY_FORMULA) then
			for i = 1, player:GetCollectibleNum(FiendFolio.ITEM.COLLECTIBLE.BABY_FORMULA) do
				player.SpriteScale = player.SpriteScale * 0.9
			end
		end
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.LANKY_MUSHROOM) then
			player.SpriteScale = player.SpriteScale * Vector(0.75, 1.5)
			for i = 1, player:GetCollectibleNum(FiendFolio.ITEM.COLLECTIBLE.LANKY_MUSHROOM)-1 do
				player.SpriteScale = player.SpriteScale * Vector(0.9, 1.1)
			end
		end
		if data.MicroPennySizeReduction then
			player.SpriteScale = player.SpriteScale * data.MicroPennySizeReduction
		end
	elseif flag == CacheFlag.CACHE_COLOR then
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.TOWER_OF_HEAVEN) then
			player.Color = player.Color * Color(1.15, 1.2, 1, 1, 0.09, 0.15, 0)
		end
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.RED_NO_3) then
			player.Color = player.Color * mod.ColorRedNo3
		end
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.JUMBO_JOSH) then
			player.Color = player.Color * Color(0.3,0.75,0.3,1,0,0.2,0)
		end
	elseif flag == CacheFlag.CACHE_FLYING then
		if basedata.GizmoBootsFlight then
			player.CanFly = true
		end
    	if effects:HasNullEffect(mod.ITEM.NULL.KALU_TRANSFORMATION) then
			player.CanFly = true
		end
	end

	if player:GetPlayerType() == FiendFolio.PLAYER.SLIPPY then
		if flag == CacheFlag.CACHE_FIREDELAY then
			--player.MaxFireDelay = math.floor(player.MaxFireDelay * 1.5) -- direct maxfiredelay multipliers break at negative firedelay values
			player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, mod:convertTearMultABPToRep(1.5))
		end
	end
end)

--xml stat ups are preferred where possible
--THIS CAN RUN BEFORE SAVEDATA IS SET, APPARENTLY? SO KEEP THAT IN MIND
mod:AddCallback(ModCallbacks.MC_EVALUATE_STAT, function(_, player, stage, value)
	local data = mod:GetEntityData(player)
	local sdata = data.ffsavedata
	if stage == EvaluateStatStage.TEARS_UP then
		if data.alphacointearsup then
			value = value + (30 / (data.alphacointearsup + 1))
		end

		if player:HasCollectible(mod.ITEM.COLLECTIBLE.FIDDLE_CUBE) then
			data.storedFiddleCubeClicks = data.storedFiddleCubeClicks or {}
			value = value + (0.2 * math.min(#data.storedFiddleCubeClicks, 5))
		end
		if mod.HasTrinityWorm(player) then
			value = value + 0.4
		end
		if mod.HasTanWorm(player) then
			value = value + 0.4
		end
		if data.prismaticGeodeTearTimer then
			value = value + data.prismaticGeodeTearBoost
		end
		if data.prismaticGeodeRainbowTimer then
			local geode = 1
			if mod.HasTwoGeodes(player) then
				geode = 2
			end
			value = value + (0.7*geode)
		end
		if player:HasTrinket(FiendFolio.ITEM.ROCK.NITRO_CRYSTAL) then
			if data.nitroCrystalStatBoost and data.nitroCrystalStatBoost > 0 then
				value = value + (math.log(data.nitroCrystalStatBoost, 10)/5)
			end
		end


		if player:HasTrinket(FiendFolio.ITEM.TRINKET.EVIOLITE) then
			value = value + (0.7*(data.EvioliteItemDecay or 0))
		end
		if sdata then
			if sdata.alphacoinfloorstats then
				value = value + (30 / (sdata.alphacoinfloorstats + 1))
			end
			if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.DEVILS_ABACUS)
			or player:HasTrinket(FiendFolio.ITEM.TRINKET.PSYCHOLOGICAL_TORTURE)
			then
				local sd = sdata.RunEffects
				if sd.AbacusMaxBuff and sd.AbacusMaxBuff > 0 then
					value = value + (math.log(1 + sd.AbacusMaxBuff/3))
				end
			end

			if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.LARGE_DOSE) then
				checkLargeDoseStats(player, sdata)
				local num = player:GetCollectibleNum(FiendFolio.ITEM.COLLECTIBLE.LARGE_DOSE)
				local specials = 0
				if sdata.RunEffects.largeDoseStats then
					for i=1,num do
						if sdata.RunEffects.largeDoseStats[i] and sdata.RunEffects.largeDoseStats[i] == CacheFlag.CACHE_FIREDELAY then
							specials = specials+1
						end
					end
				end
				value = value + (0.7*specials)
				value = value + (0.23*(num-specials))
			end
			if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.SPELLING_BEE) and sdata.RunEffects.SpellingBeeStats and sdata.RunEffects.SpellingBeeStats.Tears then
				value = value + (sdata.RunEffects.SpellingBeeStats.Tears*0.5*player:GetCollectibleNum(FiendFolio.ITEM.COLLECTIBLE.SPELLING_BEE))
			end
			if data.PeaterStats then
				value = value + data.PeaterStats.Tears
			end
		end

		if player:GetPlayerType() == mod.PLAYER.BRIEND and not mod:IsBriendTwin(player) then
			value = value + mod.BriendBalancing.RevolverTearsAdd
		end

		value = mod.GolemTearsUp(player, data, sdata, value)
	elseif stage == EvaluateStatStage.FLAT_TEARS then
		if player:HasTrinket(FiendFolio.ITEM.ROCK.BOOSTER_ROCK) then
			if data.BoosterRockStats and data.BoosterRockStats[1] == "Tears" then
				local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.BOOSTER_ROCK)
				value = value + (data.BoosterRockStats[2]*mult)
			else
				mod:BoosterRockNewRoom(player, data)
			end
		end
		if sdata and sdata.RunEffects then
			if sdata.RunEffects.EighteenFootLeashBonus and sdata.RunEffects.EighteenFootLeashBonus.Tears > 0 then
				value = value + (sdata.RunEffects.EighteenFootLeashBonus.Tears)
			end
			if sdata.RunEffects.NonEuclideanData and sdata.RunEffects.NonEuclideanData.CurrentRoom then
				value = value + (sdata.RunEffects.NonEuclideanData.Tears)
			end
		end
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.SIDEWAYS_ONION) and data.SidewaysOnionActive then
			value = value + (1.2*player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.SIDEWAYS_ONION))
		end
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.BOMB_COLLAR) then
			value = value + (mod:calculateBombCollarTears(player) * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.BOMB_COLLAR))
		end
		local _, num = mod.GetOnionDiscNums(player, CollectibleType.COLLECTIBLE_SAD_ONION)
		value = value + (0.7*num)
		if data.BriendGritBoost then
			local boost = math.max(data.BriendGritBoost, 1)
			local tears = mod.BriendBalancing.TearsBoost * (boost / mod.BriendBalancing.BoostDuration)
			tears = math.min(tears, mod.BriendBalancing.TearsBoost)
			value = value + tears
		end
		if mod:IsBriendTwin(player) then
			value = value * mod.BriendBalancing.DeagleTearsMult
		end

		value = mod.GolemFlatTears(player, data, sdata, value)
	elseif stage == EvaluateStatStage.DAMAGE_UP then
		value = value + (data.belialD122 or 0)
		value = value + (data.insatiableApatiteStrength or 0)
		value = value + (data.prismaticGeodeDamageBoost or 0)
		value = value + (data.cbsDamage or 0)
		value = value + ((data.PeaterStats and data.PeaterStats.Damage) or 0)
		if data.prismaticGeodeRainbowTimer then
			local geode = 1
			if mod.HasTwoGeodes(player) then
				geode = 2
			end
			value = value + 0.3*geode
		end

		local ffEvilTotal = (
			player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.BLACK_LANTERN)
			+ player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.EVIL_STICKER)
			+ player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.DADS_HALF)
			+ player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.TORTURE_COOKIE)
			+ player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.MOMS_PENDANT)
			+ player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.THE_LAST_BLACK_HEART)
		)

		value = value + player:GetTrinketMultiplier(TrinketType.TRINKET_BLACK_FEATHER) * 0.5 * ffEvilTotal


		if player:HasTrinket(FiendFolio.ITEM.TRINKET.EVIOLITE) then
			value = value + 1*(data.EvioliteItemDecay or 0)
		end


		if player:HasCollectible(mod.ITEM.COLLECTIBLE.FETAL_FRIEND) then
			value = value + 0.8 * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.FETAL_FRIEND)
			if mod.HasFetalFriendAmmo(player) then
				value = value + 0.8 * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.FETAL_FRIEND)
			end
		end

		if data.OverclockTime and data.OverclockTime > 0 then
			value = value * player:GetTrinketMultiplier(mod.ITEM.ROCK.ANCIENT_EFFIGY)
		end

		if data.QueensFruitDamage and data.QueensFruitDamage > 0 then
			value = value + data.QueensFruitDamage
		end


		if player:HasTrinket(FiendFolio.ITEM.TRINKET.FIVE_LEAF_CLOVER) then
			local mult = 0.1 * player:GetTrinketMultiplier(FiendFolio.ITEM.TRINKET.FIVE_LEAF_CLOVER)
			value = value + (player.Luck * mult)
		end


		if sdata and sdata.RunEffects then
			value = value + ((sdata.alphacoinchallenge and 0.5) or 0.0)
			--value = value + ((player:HasCollectible(mod.ITEM.COLLECTIBLE.CHIRUMIRU) and 0.9) or 0.0)
			value = value + ((player:HasCollectible(mod.ITEM.COLLECTIBLE.THE_DELUXE) and
												player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MEAT) * 0.3) or 0.0)
			if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.SPELLING_BEE) and sdata.RunEffects.SpellingBeeStats and sdata.RunEffects.SpellingBeeStats.Damage then
				value = value + math.max(-0.8, sdata.RunEffects.SpellingBeeStats.Damage*0.55*player:GetCollectibleNum(FiendFolio.ITEM.COLLECTIBLE.SPELLING_BEE))
			end
			if player:HasTrinket(FiendFolio.ITEM.TRINKET.STAINED_CARD) then
				local damage = 2.5*(0.8^(sdata.RunEffects.StainedCardDamage or 0))
				value = value + damage
			end
			if player:HasCollectible(mod.ITEM.COLLECTIBLE.BLACK_CANDELABRA) then
				value = value + (sdata.RunEffects.BlackCandelabraBuff or 0)
			end
			value = value + (sdata.heartShardOfChinaDamage or 0)
			if player:HasTrinket(FiendFolio.ITEM.ROCK.SMALLER_ROCK) and sdata.RunEffects.smallerRockCount then
				value = value+0.33*sdata.RunEffects.smallerRockCount
			end
			value = value + (sdata.RunEffects.electrumBelial or 0)*0.5
			value = value + (sdata.RunEffects.electrumSacrificial or 0)*0.5
			if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.LARGE_DOSE) then
				checkLargeDoseStats(player, sdata)
				local num = player:GetCollectibleNum(FiendFolio.ITEM.COLLECTIBLE.LARGE_DOSE)
				local specials = 0
				if sdata.RunEffects.largeDoseStats then
					for i=1,num do
						if sdata.RunEffects.largeDoseStats[i] and sdata.RunEffects.largeDoseStats[i] == CacheFlag.CACHE_DAMAGE then
							specials = specials+1
						end
					end
				end
				value = value + 1*specials + 0.33*(num-specials)
			end
			if sdata.RunEffects.InternalizedHatredIncreases and player:HasTrinket(mod.ITEM.TRINKET.INTERNALIZED_HATRED) then
				value = value + (0.5*sdata.RunEffects.InternalizedHatredIncreases)^0.5
			end
			if sdata.RunEffects then
				value = value + mod.golemDiminishingDamage(player)
			end
			if sdata.RunEffects.inverterdmgToAdd then
				value = value + sdata.RunEffects.inverterdmgToAdd
			end
		end

		if player:GetPlayerType() == mod.PLAYER.BRIEND then
			if not mod:IsBriendTwin(player) then
				value = value + mod.BriendBalancing.RevolverDamageFlat
			else
				value = value + mod.BriendBalancing.DeagleDamageFlat
			end
		end
	else --flat damage
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.COMMUNITY_ACHIEVEMENT) then
			value = value + mod:GetCommunityAchievementDamage()
		end
		if data.spireGrowth then
			value = value + data.spireGrowth
		end
		if data.goldenSlotTempDamage then
			value = value * data.goldenSlotTempDamage
		end
		if data.fistfulOfAshBonus then
			value = value + math.max(0, data.fistfulOfAshBonus)
		end

		if sdata then
			if sdata.CrazyErrorDamage then
				value = value + sdata.CrazyErrorDamage
			end

			if sdata.ShuffleTimeDamage then
				value = value + sdata.ShuffleTimeDamage
			end

			if sdata.ShootingStar then
				value = value + sdata.ShootingStar.DamageBonus
			end

			if player:HasCollectible(mod.ITEM.COLLECTIBLE.GOLDEN_WATCH) and sdata.RunEffects.goldenWatchValue then
				value = value * ((1.0 + (sdata.RunEffects.goldenWatchValue*mod.ff_goldenWatchMult)) or 1.0)
			end
		end

		if player:GetPlayerType() == mod.PLAYER.BRIEND then
			if not mod:IsBriendTwin(player) then
				value = value * mod.BriendBalancing.RevolverDamageMult
			else
				value = value * mod.BriendBalancing.DeagleDamageMult
			end
		end

		value = value + mod.obsidianGrindStoneDamage(player)
		value = value + 1.5 * mod.GetSmeltedTrinketMultiplier(player, mod.ITEM.TRINKET.SHARD_OF_CHINA)
		value = value + 1.8 * mod.GetSmeltedTrinketMultiplier(player, FiendFolio.ITEM.ROCK.SHARD_OF_GOLEM)
		value = value + mod.GetActiveShardOfChinaDamage(player)
	end
	return value
end)

-- badges and glizzy are added VERY late, to try and avoid multipliers from ff and other mods
-- model rocket is here too i
-- mark of pain: I too am in this function
mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, 200, function(_, player, flag)
	mod:updateModelRocketStats(player, flag)

	if flag == CacheFlag.CACHE_DAMAGE then
		local badgeCount = 0
		for i = 1, #mod.RewardBadges do
			badgeCount = badgeCount + player:GetCollectibleNum(mod.RewardBadges[i])
		end
		player.Damage = player.Damage + (0.1 * badgeCount)
		player.Damage = player.Damage + (0.1 * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.YOUR_ETERNAL_REWARD))

		if player:HasCollectible(mod.ITEM.COLLECTIBLE.GLIZZY) then
			player.Damage = player.Damage + (0.1 * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.GLIZZY))
		end

		if player:HasTrinket(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE) then
			player.Damage = player.Damage + (0.1 * player:GetTrinketMultiplier(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE))
		end
	elseif flag == CacheFlag.CACHE_FIREDELAY then
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.GLIZZY) then
			player.MaxFireDelay = tearsUp(player.MaxFireDelay, (0.1 * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.GLIZZY)))
		end
	elseif flag == CacheFlag.CACHE_SPEED then
		local badgeCount = 0
		for i = 1, #mod.RewardInsignias do
			badgeCount = badgeCount + player:GetCollectibleNum(mod.RewardInsignias[i])
		end
		player.MoveSpeed = player.MoveSpeed + (0.02 * badgeCount)
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.GLIZZY) then
			player.MoveSpeed = player.MoveSpeed + (0.1 * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.GLIZZY))
		end
	elseif flag == CacheFlag.CACHE_RANGE then
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.GLIZZY) then
			player.TearRange = player.TearRange + (4 * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.GLIZZY))
		end
	elseif flag == CacheFlag.CACHE_SHOTSPEED then
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.GLIZZY) then
			player.ShotSpeed = player.ShotSpeed + (0.1 * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.GLIZZY))
		end
	elseif flag == CacheFlag.CACHE_LUCK then
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.GLIZZY) then
			player.Luck = player.Luck + (0.1 * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.GLIZZY))
		end
	end
end)

if REPENTOGON then
	for familiarVariant, followerPriority in pairs(FiendFolio.FamiliarFollowerPriorities) do
		mod:AddCallback(ModCallbacks.MC_GET_FOLLOWER_PRIORITY, function()
			return followerPriority
		end, familiarVariant)
	end
end

function FiendFolio.HandleDoubleTapFire(player, action)
	local data = mod:GetEntityData(player)
	local sdata = data.ffsavedata

	-- Hijacking this for Hatred thanks guys
	if Isaac.CountEntities(player, 3, mod.ITEM.FAMILIAR.HATRED) > 0 then
		mod.TryLaunchHatredFamiliars(player)
	end

	mod:erflyOnDoubleTap(player, data, sdata)
	mod:ferriumOnDoubleTap(player, data, sdata)

	mod.fireballOnDoubleTap(player, action, data, sdata)
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
	local d = mod:GetEntityData(tear)
	mod.fireballTears(tear, d)
	mod.babyCraterTears(tear, d)
	mod.ferriumTear(tear, d)
end)

-- also DICHROMATIC BUTTERFLY new room!
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	mod:erflyPrePlayerNewRoom()

	for _, player in ipairs(PlayerManager.GetPlayers()) do
		local data = mod:GetEntityData(player)
		local savedata = data.ffsavedata

		mod:handleDichromaticNewRoom(player, data)
		mod:alphaCoinNewRoom(player, savedata)

		--Slapping this in here since it fits in snugly
		if data.holdingFFItem then
			data.holdingFFItem = nil
		end

		mod:erflyPlayerNewRoom(player, data, savedata)
		mod:GolemHoldUpRockFailsafe(player, data)
	end

	mod:erflyPostPlayerNewRoom()
end)

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function(_, player, renderOffset)
	if player:Exists() then
		local data = mod:GetEntityData(player)
		mod:connorPlayerRender(player, data, renderOffset)
		mod:ferriumPostPlayerRender(player, data)
		mod:renderMasterCurseCrown(player, data, renderOffset)
	end
end)

-- Familiars

if StageAPI and StageAPI.Loaded then
	StageAPI.AddCallback("FiendFolio", "PRE_STAGEAPI_SELECT_BOSS_ITEM", 1, function(pickup, currentRoom)
		local isFFBoss
		local bossData
		if currentRoom and currentRoom.PersistentData.BossID then
			bossData = StageAPI.GetBossData(currentRoom.PersistentData.BossID)
			if bossData and bossData.IsFFBoss then
				isFFBoss = true
			end
		end

		if isFFBoss and bossData.Horseman then
			local savedata = FiendFolio.savedata.run
			--Safety check, but likely won't run as replacements code runs first
			if not savedata.CubeReplacement then
				savedata.CubeReplacement = mod.ITEM.COLLECTIBLE.CORN_KERNEL
			end
			if #Isaac.FindByType(5, 100, savedata.CubeReplacement) == 0 then
				pickup:Morph(5, 100, savedata.CubeReplacement, true)
				return true
			end
		end
	end)
end

-- Technical Entities

mod.d12ed_Rooms = {}
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function()
	local rerollGrids = true
	local room = game:GetRoom()
	--If you're a mod, set this, use d12, then unset this
	--If you leave it on you are EVIL
	if FiendFolio.DoNotUseD12Grids then
		rerollGrids = false
	elseif room:GetFrameCount() < 1 then
		if Epiphany then
			if mod.anyPlayerHas(Isaac.GetItemIdByName("ÿ¡B«à¡„„ù¡§àù³§Ñ•ÑB«³")) then
				rerollGrids = false
			end
		end
	end
	if rerollGrids then
		mod:ChangeD12Grids(mod.D12Grid)
		mod:RegisterD12UsedRoom()
	end
end, CollectibleType.COLLECTIBLE_D12)

function mod:RegisterD12UsedRoom(d12type) -- 1: d12   ; 2: ed12
	d12type = d12type or 1
	local listIndex = game:GetLevel():GetCurrentRoomDesc().ListIndex
	if not mod.d12ed_Rooms[listIndex] then
		mod.d12ed_Rooms[listIndex] = {}
	end
	mod.d12ed_Rooms[listIndex].Type = d12type
end

function mod:IsD12UsedRoom() --Returns D12Type if true
	local listIndex = game:GetLevel():GetCurrentRoomDesc().ListIndex
	if mod.d12ed_Rooms[listIndex] and mod.d12ed_Rooms[listIndex].Type then
		return mod.d12ed_Rooms[listIndex].Type
	end
end

function mod:SetD12PalState(value) 
	local listIndex = game:GetLevel():GetCurrentRoomDesc().ListIndex
	if not mod.d12ed_Rooms[listIndex] then
		mod.d12ed_Rooms[listIndex] = {}
	end
	mod.d12ed_Rooms[listIndex].fromPal = value
end

function mod:GetD12PalState()
	local listIndex = game:GetLevel():GetCurrentRoomDesc().ListIndex
	if mod.d12ed_Rooms[listIndex] then
		return mod.d12ed_Rooms[listIndex].fromPal
	end
end

function mod:ClearD12PalState()
	mod:SetD12PalState(nil)
end

function mod:ShouldD12PalTriggerInRoom()
	return mod.d12switch and mod:GetD12PalState() == nil
end

function mod:checkD12Rocks()
	local d12type = mod:IsD12UsedRoom()
	if d12type then
		if d12type == 2 then
			mod:ChangeD12Grids(mod.ED12Grid)
		else
			mod:ChangeD12Grids(mod.D12Grid)
		end
	end
	if mod:GetD12PalState() == 1 then
		mod:ClearD12PalState()
	end
end

function mod:ChangeD12Grids(D12GridType)
	StageAPI.ChangeGrids(D12GridType)
	StageAPI.TemporarilyOverrideRockAltEffects()

  --[[local room = game:GetRoom()
  local backdrop = 1<<(Game():GetRoom():GetBackdropType())
  local backdropFlags =  1<<1 | 1<<2 | 1<<3 | 1<<15 | 1<<19 | 1<<20 | 1<<21 | 1<<22 | 1<<24 | 1<<25 | 1<<26 | 1<<28 | 1<<35 | 1<<50 | 1<<51 | 1<<52 | 1<<53 | 1<<54
  local potGfx = (backdropFlags & backdrop) ~= 0
  local d12Gfx = D12GridType.Rocks
  local altGfx
  local roomgfx = mod:getCurrentRoomGfx()
  if roomgfx and type(roomgfx) ~= "function" and roomgfx.Grids and roomgfx.Grids.Rocks then
	altGfx = roomgfx.Grids.Rocks
  end
  for i = 0, room:GetGridSize() do
	local customGrids = StageAPI.GetCustomGrids(i)
	local customGridBlocking = false
	for _, cgrid in ipairs(customGrids) do
		if not cgrid.GridConfig.NoOverrideGridSprite then
			customGridBlocking = true
		end
	end
	if not customGridBlocking then
	  grid = room:GetGridEntity(i)
	  if grid then
		local send = {Grid = grid}
		if StageAPI.RockTypes[grid.Desc.Type] then
		  if grid.Desc.Type == GridEntityType.GRID_ROCK_ALT then
			if potGfx then
			  StageAPI.ChangeRock(send, d12Gfx)
			elseif altGfx then
			  StageAPI.ChangeRock(send, altGfx)
			end
		  else
			StageAPI.ChangeRock(send, d12Gfx)
		  end
		end
	  end
	end
  end
  StageAPI.CallGridPostInit()]]
end

--D12 Dice Room, D12DiceRoom
function mod:diceFloorPreSpawn(etype, evar, esub, pos, vel, spawner, seed)
  	if esub <= 5 then
		local room = game:GetRoom()
		if room:GetFrameCount() == 0
		and room:IsFirstVisit()
		and math.random(4)
		and not (TaintedTreasure and TaintedTreasure:IsRoomDescTainted(game:GetLevel():GetCurrentRoomDesc())) then
			math.randomseed(room:GetSpawnSeed())
			if math.random(7) == 7 then
				return {1000, 76, 880, seed}
			end
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
  	if (effect.SubType == 880 or effect.SubType == 881) and effect.FrameCount == 0 then
		StageAPI.ChangeRoomGfx(mod.D12BackdropExt)
		StageAPI.TemporarilyOverrideRockAltEffects()
		mod.IsD12DiceRoom = true --For alt rock drops
 	end
end, 76)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
  if effect.SubType == 880 then
	local players = Isaac.FindByType(1, -1, -1, false, false)
	for _, player in ipairs(players) do
	  local pos = player.Position - effect.Position
	  --print(tostring(pos.X) .. " " .. tostring(pos.Y))
	  if pos.X > -75 and pos.X < 75 and pos.Y > -75 and pos.Y < 75 then
		Isaac.Spawn(1000, 76, 881, effect.Position, Vector(0, 0), nil)
		effect:Remove()
		mod.d12switch = true
		FiendFolio.savedata.usedDiceRoom12Pip = true
		mod:CheckChatterboxUnlock()
	  end
	end
  end
end, 76)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	local room = game:GetRoom()
	if room:IsClear() and room:GetFrameCount() > 1 and mod:ShouldD12PalTriggerInRoom() then
		local delay = 25
		if room:GetFrameCount() <= 5 then delay = 0 end
		mod.scheduleForUpdate(function()
			local pos = room:FindFreeTilePosition(room:GetCenterPos(), 1000)
			Isaac.Spawn(1000, 1880, 0, pos, Vector(0,0), nil)
		end, delay)
		mod:SetD12PalState(1)
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
	local sprite = effect:GetSprite()
	if effect.FrameCount == 1 then
		sprite:PlayOverlay("1+", true)
		SFXManager():Play(173, 1.5, 0, false, 3.5)
	end
	if sprite:IsEventTriggered("Drop") then
		SFXManager():Play(49, 1, 0, false, 0.75)
		mod.reroll_grids({2, 3, 4, 5, 6, 12, 14, 22, 25, 27}, false, true, false)
		mod:RegisterD12UsedRoom()
		mod:SetD12PalState(true)
	end
	if sprite:IsEventTriggered("Vanish") then
		for i=0, 10 do
			local vec = RandomVector()
			vec = Vector(vec.X*2, -math.abs(vec.Y)-0.25)*(0.6 + math.random()*0.6)
			local p = Isaac.Spawn(1000, 111, 0, effect.Position + vec*10, vec*3, effect)
			p:GetSprite().Scale = Vector(0.1, 0.1)
			p:SetColor(Color(1,1,1,1,255,255,255), 0, 0, false, false)
		end
	end
end, 1880)

mod:AddCallback(ModCallbacks.MC_PRE_USE_CARD, function(_, card, player)
	if card == Card.CARD_REVERSE_WHEEL_OF_FORTUNE and player:GetCardRNG(Card.CARD_REVERSE_WHEEL_OF_FORTUNE):RandomInt(7) == 6 then 			-- [0, 6]
		mod.d12switch = true
		game:Darken(1, 60)
		game:ShakeScreen(50)
		return false
	end
end)

function mod:stopTNTBarrelsFromBeinDumb(eff)
	if not mod:GetEntityData(eff).turnedIntoCoolBetterParticles then
		if mod.FindClosestEntity(eff.Position, 5, 292, 750) then
			eff:GetSprite():ReplaceSpritesheet(0, "gfx/grid/super_tnt.png")
			eff:GetSprite():LoadGraphics()
		end

		mod:GetEntityData(eff).turnedIntoCoolBetterParticles = true
	end

end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.stopTNTBarrelsFromBeinDumb, EffectVariant.WOOD_PARTICLE)

-- Pocket Items


mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, function(_, CollectibleID, r, player, flags, ActiveSlot)
	local card = player:GetCard(0)
	if card then
		if FiendFolio.GlassDiceBySubtype[card] then
			player:AnimateCollectible(CollectibleType.COLLECTIBLE_BLANK_CARD, "UseItem", "PlayerPickup")
			return true
		elseif card == mod.ITEM.CARD.TWO_OF_WANDS then
			player:SetActiveCharge(0,ActiveSlot)
		end
	end
end, CollectibleType.COLLECTIBLE_BLANK_CARD)

--[[mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	local cardConfig = FiendFolio.CardsBySubtype[pickup.SubType]
	if cardConfig then
		local sprite = pickup:GetSprite()
		local appear = sprite:IsPlaying("Appear")
		sprite:Load(cardConfig.back, true)
		sprite:Play(appear and "Appear" or "Idle", false)
	end
end, PickupVariant.PICKUP_TAROTCARD)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup) --ref 1
	if not FiendFolio.ItemsEnabled and FiendFolio.CardsBySubtype[pickup.SubType] then
		pickup:Remove()
		Isaac.Spawn(5, PickupVariant.PICKUP_TAROTCARD, 0, pickup.Position, nilvector, nil)
		return
	end
end, PickupVariant.PICKUP_TAROTCARD)]]

-- Replaces the pickup sound for FF objects from the default card sound to the correct one for objects.
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	if mod.ReplaceObjectPickupSound then
		mod.ReplaceObjectPickupSound = false
		if sfx:IsPlaying(SoundEffect.SOUND_BOOK_PAGE_TURN_12) then
			sfx:Play(SoundEffect.SOUND_SHELLGAME, 1, 0, false, 1)
			sfx:Stop(SoundEffect.SOUND_BOOK_PAGE_TURN_12)
		end
	end
end)

-- Triggers the above sound replacement.
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, p, c)
	if c.Type == 1 and FiendFolio.PocketObjects[p.SubType] then
		if c:ToPlayer():CanPickupItem() and not c:ToPlayer():IsHoldingItem() then
			mod.ReplaceObjectPickupSound = true
		end
	end
end, 300)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, card, player, flags)
	local data = mod:GetEntityData(player).ffsavedata

	data.orbitingfireballs = math.min(data.orbitingfireballs + 3, 12)
	player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
	player:EvaluateItems()

	FiendFolio:trySayAnnouncerLine(mod.Sounds.VACardThreeFireballs, flags, 20)
end, mod.ITEM.CARD.PLUS_3_FIREBALLS)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, card, player, flags)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_D6, false, false, true, false)
	FiendFolio:trySayAnnouncerLine(mod.Sounds.VAObjectGlassDice6, flags, 20)
end, mod.ITEM.CARD.GLASS_D6)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, card, player, flags)
	local bags = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.DICE_BAG)
	for i = 1, bags do
		player:RemoveCollectible(mod.ITEM.COLLECTIBLE.DICE_BAG)
	end
	player:UseActiveItem(CollectibleType.COLLECTIBLE_D4, false, false, true, false)
	for i = 1, bags do
		player:AddCollectible(mod.ITEM.COLLECTIBLE.DICE_BAG, 0, false)
	end
	FiendFolio:trySayAnnouncerLine(mod.Sounds.VAObjectGlassDice4, flags, 20)
end, mod.ITEM.CARD.GLASS_D4)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, card, player, flags)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_D8, false, false, true, false)
	FiendFolio:trySayAnnouncerLine(mod.Sounds.VAObjectGlassDice8, flags, 20)
end, mod.ITEM.CARD.GLASS_D8)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, card, player, flags)
	local bags = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.DICE_BAG)
	for i = 1, bags do
		player:RemoveCollectible(mod.ITEM.COLLECTIBLE.DICE_BAG)
	end
	player:UseActiveItem(CollectibleType.COLLECTIBLE_D100, false, false, true, false)
	for i = 1, bags do
		player:AddCollectible(mod.ITEM.COLLECTIBLE.DICE_BAG, 0, false)
	end
	FiendFolio:trySayAnnouncerLine(mod.Sounds.VAObjectGlassDice100, flags, 20)
end, mod.ITEM.CARD.GLASS_D100)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, card, player, flags)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_D10, false, false, true, false)
	FiendFolio:trySayAnnouncerLine(mod.Sounds.VAObjectGlassDice10, flags, 20)
end, mod.ITEM.CARD.GLASS_D10)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, card, player, flags)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_D20, false, false, true, false)
	FiendFolio:trySayAnnouncerLine(mod.Sounds.VAObjectGlassDice20, flags, 20)
end, mod.ITEM.CARD.GLASS_D20)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, card, player, flags)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_D12, false, false, true, false)
	FiendFolio:trySayAnnouncerLine(mod.Sounds.VAObjectGlassDice12, flags, 20)
end, mod.ITEM.CARD.GLASS_D12)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, card, player, flags)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_SPINDOWN_DICE , false, false, true, false)
	FiendFolio:trySayAnnouncerLine(mod.Sounds.VAObjectGlassDiceSpindown, flags, 20)
end, mod.ITEM.CARD.GLASS_SPINDOWN)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, card, player, flags)
	player:UseActiveItem(mod.ITEM.COLLECTIBLE.AZURITE_SPINDOWN , false, false, true, false)
	FiendFolio:trySayAnnouncerLine(mod.Sounds.VAObjectGlassDiceAzuriteSpindown, flags, 20)
end, mod.ITEM.CARD.GLASS_AZURITE_SPINDOWN)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, card, player, flags)
player:AddCollectibleEffect(FiendFolio.ITEM.COLLECTIBLE.D5, true)
end, mod.ITEM.CARD.GLASS_D5)

-- mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	 -- for _, wisp in ipairs(Isaac.FindByType(3, 237, FiendFolio.ITEM.COLLECTIBLE.D5, false, false)) do
		-- if wisp:ToFamiliar().Player then
			-- player = wisp:ToFamiliar().Player
			-- local savedata = mod:GetEntityData(player).ffsavedata
			-- if savedata.playerThatUsedGlassD5 ~= nil then
				-- wisp:Remove()
				-- wisp:Kill()
			-- end
		-- end
	-- end
-- end)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, card, player, flags)
player:AddCollectibleEffect(FiendFolio.ITEM.COLLECTIBLE.D3, true)
end, mod.ITEM.CARD.GLASS_D3)

-- mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	 -- for _, wisp in ipairs(Isaac.FindByType(3, 237, FiendFolio.ITEM.COLLECTIBLE.D3, false, false)) do
		-- if wisp:ToFamiliar().Player then
			-- player = wisp:ToFamiliar().Player
			-- local savedata = mod:GetEntityData(player).ffsavedata
			-- if savedata.playerThatUsedGlassD3 ~= nil then
				-- wisp:Remove()
				-- wisp:Kill()
			-- end
		-- end
	-- end
-- end)

--Small Contraband
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	local savedata = mod:GetEntityData(Isaac.GetPlayer()).ffsavedata
	if (pickup.SubType == mod.ITEM.CARD.SMALL_CONTRABAND) then
		if pickup.SpawnerEntity ~= nil then
			local e = Isaac.Spawn(154, 0, 0, Vector(300,-50), nilvector, nil)
			e.GridCollisionClass = 0
			e:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			e:AddEntityFlags(EntityFlag.FLAG_NO_REWARD)
			local en = e:ToNPC()
			en.CanShutDoors = false
		end
	end
end, PickupVariant.PICKUP_TAROTCARD)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardid, player, flags)
	local suspiciouswhitecolor = Color(1,1,1,0.5,0,0,0)
	local creepEnt = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_WHITE, 0, player.Position, Vector(0,0), player);
	local creep = creepEnt:ToEffect()
	creepEnt:SetColor(suspiciouswhitecolor,99999, 1, false, false)
	creep.SpriteScale = Vector(0.2, 0.2)
	creep:SetTimeout(88888)
	creep:Update()
	FiendFolio:trySayAnnouncerLine(mod.Sounds.VACardSmallContraband, flags, 20)
end, mod.ITEM.CARD.SMALL_CONTRABAND)

--Snagger Steals contraband
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function(_)
	if mod:GetDimension() ~= 2 then
		for _, card in ipairs(Isaac.FindByType(5, 300, mod.ITEM.CARD.SMALL_CONTRABAND, false, false)) do
			local e = Isaac.Spawn(154, 0, 0, card.Position, nilvector, nil)
			e.GridCollisionClass = 0
			e:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			e:AddEntityFlags(EntityFlag.FLAG_NO_REWARD)
			local en = e:ToNPC()
			en.CanShutDoors = false
		end
		for _, card in ipairs(Isaac.FindByType(5, 100, mod.ITEM.COLLECTIBLE.CONTRABAND, false, false)) do
			local e = Isaac.Spawn(154, 0, 0, card.Position, nilvector, nil)
			e.GridCollisionClass = 0
			e:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			e:AddEntityFlags(EntityFlag.FLAG_NO_REWARD)
			local en = e:ToNPC()
			en.CanShutDoors = false
		end
	end
end)

--There's probably a better way to make vanilla defusables; but the entity ENUM only gives ID.
FiendFolio.DefusableEnums = {
DEFUSABLE_FLY_BOMB = {ID = 819, Var = 0, Sub = 0},
DEFUSABLE_BOMB = {ID = 4, Var = 0, Sub = 0},
DEFUSABLE_TROLL_BOMB = {ID = 4, Var = 3, Sub = 0},
DEFUSABLE_MEGATROLL_BOMB = {ID = 4, Var = 4, Sub = 0},
DEFUSABLE_GIGA_BOMB = {ID = 4, Var = 17, Sub = 0},
DEFUSABLE_GOLDEN_TROLL_BOMB = {ID = 4, Var = 18, Sub = 0},
DEFUSABLE_TICKING_SPIDER = {ID = 250, Var = 0, Sub = 0},
DEFUSABLE_TICKING_FLY = {ID = 214, Var = 715, Sub = 0},
DEFUSABLE_SPLODUM = {ID = 23, Var = 961, Sub = 0},
DEFUSABLE_POISON_MIND = {ID = 301, Var = 0, Sub = 0},
DEFUSABLE_MULLIBOOM = {ID = 16, Var = 2, Sub = 0},
DEFUSABLE_MULLIKABOOM = {ID = 160, Var = 550, Sub = 0},
DEFUSABLE_BOOM_FLY = {ID = 25, Var = 0, Sub = 0},
DEFUSABLE_KAMIKAZE_LEECH = {ID = 55, Var = 1, Sub = 0},
DEFUSABLE_MIGRAINE = {ID = 869, Var = 0, Sub = 0},
DEFUSABLE_BLACK_BONY = {ID = 277, Var = 0, Sub = 0},
DEFUSABLE_COIN_BOMB = {ID = 293, Var = 2, Sub = 0},
DEFUSABLE_BOMB_BUM = {ID = 6, Var = 9, Sub = 0},
DEFUSABLE_ANTI_GOLEM = {ID = 114, Var = 19, Sub = 1},
DEFUSABLE_TAINTED_BOOM_FLY = {ID = 25, Var = 6, Sub = 0},
DEFUSABLE_WRATH = {ID = 48, Var = 0, Sub = 0},
DEFUSABLE_SUPER_WRATH = {ID = 48, Var = 1, Sub = 0}
}

mod.DefusableBombs = {
	mod.DefusableEnums.DEFUSABLE_FLY_BOMB,
	mod.DefusableEnums.DEFUSABLE_BOMB,
	mod.DefusableEnums.DEFUSABLE_TROLL_BOMB,
	mod.DefusableEnums.DEFUSABLE_MEGATROLL_BOMB,
	mod.DefusableEnums.DEFUSABLE_COIN_BOMB,
}

--Write Defusable enemy constants here
mod.DefusableUniques = {
	mod.FF.Bombmuncher,
	mod.DefusableEnums.DEFUSABLE_TICKING_SPIDER,
	mod.DefusableEnums.DEFUSABLE_TICKING_FLY,
	mod.DefusableEnums.DEFUSABLE_SPLODUM,
	mod.DefusableEnums.DEFUSABLE_POISON_MIND,
	mod.DefusableEnums.DEFUSABLE_GIGA_BOMB,
	mod.DefusableEnums.DEFUSABLE_GOLDEN_TROLL_BOMB,
	mod.DefusableEnums.DEFUSABLE_MULLIBOOM,
	mod.DefusableEnums.DEFUSABLE_MULLIKABOOM,
	mod.DefusableEnums.DEFUSABLE_BOOM_FLY,
	mod.DefusableEnums.DEFUSABLE_KAMIKAZE_LEECH,
	mod.DefusableEnums.DEFUSABLE_MIGRAINE,
	mod.DefusableEnums.DEFUSABLE_BLACK_BONY,
	mod.DefusableEnums.DEFUSABLE_BOMB_BUM,
	mod.DefusableEnums.DEFUSABLE_ANTI_GOLEM,
	mod.DefusableEnums.DEFUSABLE_TAINTED_BOOM_FLY,
	mod.DefusableEnums.DEFUSABLE_WRATH,
	mod.DefusableEnums.DEFUSABLE_SUPER_WRATH,
}

local function uniqueDefuses()
  for i = 1, #mod.DefusableUniques do
	local enemDefuse = mod.DefusableUniques[i]
	--print("Size: "..#mod.DefusableUniques)
	--print("ID: "..enemDefuse.ID)
	--print("Var: "..enemDefuse.Var)
	--print("Sub: "..enemDefuse.Sub)
	local bombdrop = 0
	 for _, enemy in ipairs(Isaac.FindByType(enemDefuse.ID, enemDefuse.Var, enemDefuse.Sub, false, false)) do
		if enemDefuse == mod.FF.Bombmuncher then
		  local newEnemu = Isaac.Spawn(29, 1, 0, enemy.Position, nilvector, nil):ToNPC()
		  newEnemu:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		  Isaac.Spawn(1000, 15, 2, enemy.Position, nilvector, nil)
		  bombdrop = 1
		elseif enemDefuse == mod.DefusableEnums.DEFUSABLE_TICKING_SPIDER then
		  local newEnemu = Isaac.Spawn(215, 0, 0, enemy.Position, nilvector, nil):ToNPC()
		  newEnemu:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		  Isaac.Spawn(1000, 15, 2, enemy.Position, nilvector, nil)
		  bombdrop = 1
		elseif enemDefuse == mod.DefusableEnums.DEFUSABLE_TICKING_FLY then
		  local newEnemu = Isaac.Spawn(214, 0, 0, enemy.Position, nilvector, nil):ToNPC()
		  newEnemu:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		  Isaac.Spawn(1000, 15, 2, enemy.Position, nilvector, nil)
		  bombdrop = 1
		elseif enemDefuse == mod.DefusableEnums.DEFUSABLE_SPLODUM then
		  local newEnemu = Isaac.Spawn(23, 960, 0, enemy.Position, nilvector, nil):ToNPC()
		  newEnemu:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		  Isaac.Spawn(1000, 15, 2, enemy.Position, nilvector, nil)
		  bombdrop = 1
		elseif enemDefuse == mod.DefusableEnums.DEFUSABLE_POISON_MIND then
		  local newEnemu = Isaac.Spawn(32, 0, 0, enemy.Position, nilvector, nil):ToNPC()
		  newEnemu:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		  Isaac.Spawn(1000, 15, 2, enemy.Position, nilvector, nil)
		  bombdrop = 1
		elseif enemDefuse == mod.DefusableEnums.DEFUSABLE_BOOM_FLY then
		  local newEnemu = Isaac.Spawn(1000, 15, 0, enemy.Position, nilvector, nil)
		  bombdrop = 1
		elseif enemDefuse == mod.DefusableEnums.DEFUSABLE_GIGA_BOMB then
		  local newEnemu = Isaac.Spawn(5, 40, 7, enemy.Position, nilvector, nil):ToPickup()
		  bombdrop = 0
		elseif enemDefuse == mod.DefusableEnums.DEFUSABLE_GOLDEN_TROLL_BOMB then
		  local newEnemu = Isaac.Spawn(5, 40, 4, enemy.Position, nilvector, nil):ToPickup()
		  bombdrop = 0
		elseif enemDefuse == mod.DefusableEnums.DEFUSABLE_MULLIBOOM then
		  local newEnemu = Isaac.Spawn(16, 0, 0, enemy.Position, nilvector, nil):ToNPC()
		  newEnemu:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		  Isaac.Spawn(1000, 15, 2, enemy.Position, nilvector, nil)
		  bombdrop = 1
		elseif enemDefuse == mod.DefusableEnums.DEFUSABLE_BLACK_BONY then
		  local newEnemu = Isaac.Spawn(227, 0, 0, enemy.Position, nilvector, nil):ToNPC()
		  newEnemu:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		  Isaac.Spawn(1000, 15, 2, enemy.Position, nilvector, nil)
		  bombdrop = 1
		elseif enemDefuse == mod.DefusableEnums.DEFUSABLE_KAMIKAZE_LEECH then
		  local newEnemu = Isaac.Spawn(55, 0, 0, enemy.Position, nilvector, nil):ToNPC()
		  newEnemu:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		  Isaac.Spawn(1000, 15, 2, enemy.Position, nilvector, nil)
		  bombdrop = 1
		elseif enemDefuse == mod.DefusableEnums.DEFUSABLE_BOMB_BUM then
		  local newEnemu = Isaac.Spawn(6, 4, 0, enemy.Position, nilvector, nil):ToPickup()
		  local newBomb = Isaac.Spawn(5, 40, 1, enemy.Position+Vector(0,30), nilvector, nil):ToPickup()
		  bombdrop = 0
		elseif enemDefuse == mod.DefusableEnums.DEFUSABLE_MIGRAINE then
		  local newEnemu = Isaac.Spawn(215, 0, 0, enemy.Position, nilvector, nil):ToNPC()
		  newEnemu:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		  Isaac.Spawn(1000, 15, 2, enemy.Position, nilvector, nil)
		  bombdrop = 0
		  Isaac.Spawn(5, 40, 1, enemy.Position, Vector(math.random(4, 7), 0):Rotated(math.random(90)+45), nil):ToPickup()
		  Isaac.Spawn(5, 40, 1, enemy.Position, Vector(math.random(4, 7), 0):Rotated(math.random(90)+45), nil):ToPickup()
		  Isaac.Spawn(5, 40, 1, enemy.Position, Vector(math.random(4, 7), 0):Rotated(math.random(90)+45), nil):ToPickup()
		elseif enemDefuse == mod.DefusableEnums.DEFUSABLE_MULLIKABOOM then
		  local newEnemu = Isaac.Spawn(16, 0, 0, enemy.Position, nilvector, nil):ToPickup()
		  local newItem = Isaac.Spawn(5, 100, 353, enemy.Position+Vector(0,30), nilvector, nil):ToPickup()
		  bombdrop = 0
		elseif enemDefuse == mod.DefusableEnums.DEFUSABLE_ANTI_GOLEM then
		  local newEnemu = Isaac.Spawn(114, 19, 0, enemy.Position, nilvector, nil):ToNPC()
		  newEnemu:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		  local newBomb = Isaac.Spawn(5, 41, 0, enemy.Position+Vector(0,30), nilvector, nil):ToPickup()
		  bombdrop = 0
		elseif enemDefuse == mod.DefusableEnums.DEFUSABLE_TAINTED_BOOM_FLY then
		  local newEff = Isaac.Spawn(1000, 15, 0, enemy.Position, nilvector, nil)
		  local newEnemu = Isaac.Spawn(25, 1, 0, enemy.Position, nilvector, nil):ToNPC()
		  newEnemu:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		  local newBomb = Isaac.Spawn(5, 40, 1, enemy.Position+Vector(0,30), nilvector, nil):ToPickup()
		  newBomb = Isaac.Spawn(5, 40, 1, enemy.Position+Vector(0,-30), nilvector, nil):ToPickup()
		  newBomb = Isaac.Spawn(5, 40, 1, enemy.Position+Vector(-30,0), nilvector, nil):ToPickup()
		  newBomb = Isaac.Spawn(5, 40, 1, enemy.Position+Vector(30,0), nilvector, nil):ToPickup()
		  bombdrop = 0
		elseif enemDefuse == mod.DefusableEnums.DEFUSABLE_WRATH then
		  local newEnemu = Isaac.Spawn(10, 1, 0, enemy.Position, nilvector, nil):ToPickup()
		  local newItem = Isaac.Spawn(5, 100, 106, enemy.Position+Vector(30,0), nilvector, nil):ToPickup()
		  bombdrop = 0
		elseif enemDefuse == mod.DefusableEnums.DEFUSABLE_SUPER_WRATH then
		  local newEnemu = Isaac.Spawn(160, 1210, 0, enemy.Position, nilvector, nil):ToPickup()
		  local newItem = Isaac.Spawn(5, 100, 106, enemy.Position+Vector(30,0), nilvector, nil):ToPickup()
		  bombdrop = 0
		end
		 if bombdrop == 1 then
		  local bombPickup = Isaac.Spawn(5, 40, 1, enemy.Position, nilvector, nil):ToPickup()
		 end
		bombdrop = 0
		enemy:Remove()
	 end
	end
end


mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
	local room = game:GetRoom()
	local newGrids = {}
	for i=0, room:GetGridSize() do
		local gridEntity = room:GetGridEntity(i)
		if gridEntity then
			local gridpos = room:GetGridPosition(i)
			local desc = gridEntity.Desc.Type
			local pickup
			if gridEntity.Desc.Type == GridEntityType.GRID_ROCK_BOMB then
				pickup = Isaac.Spawn(5, 40, 1, gridpos, nilvector, nil):ToPickup()
				Isaac.Spawn(1000, 4, 0, gridpos, Vector(math.random(1,5),math.random(1,5)), nil)
				Isaac.Spawn(1000, 4, 0, gridpos, Vector(math.random(1,5),math.random(1,5)), nil)
				Isaac.Spawn(1000, 4, 0, gridpos, Vector(math.random(1,5),math.random(1,5)), nil)
			end
			if pickup then
				room:RemoveGridEntity(i, 0, false)
				table.insert(newGrids, i)
			end
		end
	end

	if #newGrids > 0 then
		--print(#newGrids)
		for i = 1, #newGrids do
			for k = 1, 3 do
				mod.scheduleForUpdate(function()
					room:SpawnGridEntity(newGrids[i], GridEntityType.GRID_DECORATION, 0, 0, 0)
				end, k)
			end
		end
	end

-- Defusable Bombs
	for i = 1, #mod.DefusableBombs do
	local enemDefuse = mod.DefusableBombs[i]
	 for _, enemy in ipairs(Isaac.FindByType(enemDefuse.ID, enemDefuse.Var, enemDefuse.Sub, false, false)) do
		 --print("Removing bomb!")
		local bombPickup = Isaac.Spawn(5, 40, 1, enemy.Position, nilvector, nil):ToPickup()
		enemy:Remove()
		--enemy:Explode()
	 end
	end
-- Unique Defusables
	uniqueDefuses()

--Other (I don't want it to remove him if he's still alive)
	for _, enemy in ipairs(Isaac.FindByType(mod.FF.Buster.ID, mod.FF.Buster.Var, -1, false, false)) do
		if enemy:GetSprite():IsPlaying("Death") then
			enemy:BloodExplode()
			if game:GetRoom():GetType() == RoomType.ROOM_BOSS then
				local newItem = Isaac.Spawn(5, 100, mod.ITEM.COLLECTIBLE.COMMISSIONED_BADGE, enemy.Position, nilvector, nil):ToPickup()
			end
			enemy:Remove()
		end
	end
	sfx:Play(SoundEffect.SOUND_GOLDENBOMB, 1, 0, false, 1)
	FiendFolio:trySayAnnouncerLine(mod.Sounds.VACardDefuse, flags, 40)
end, mod.ITEM.CARD.DEFUSE)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
	sfx:Play(mod.Sounds.YgoCard, 1, 0, false, 1)

	local drops = 2
	local savedCard
	local itemConfig = Isaac.GetItemConfig()
	for i = 1, drops do
		local newCard = Game():GetItemPool():GetCard(player:GetCardRNG(mod.ITEM.CARD.POT_OF_GREED):Next(), true, false, false)
		local cardBack = itemConfig:GetCard(newCard).PickupSubtype
		if not savedCard then
			savedCard = cardBack
		elseif savedCard then
			while cardBack == savedCard do
				newCard = Game():GetItemPool():GetCard(player:GetCardRNG(mod.ITEM.CARD.POT_OF_GREED):Next(), true, false, false)
				cardBack = itemConfig:GetCard(newCard).PickupSubtype
			end
		end
		Isaac.Spawn(5, 300, newCard, player.Position, RandomVector():Resized(math.random(4, 7)), pickup)
	end

	FiendFolio:trySayAnnouncerLine(mod.Sounds.VACardPotofGreed, flags, 40)
	if math.random(3) == 1 then
		FiendFolio:trySayAnnouncerLine(mod.Sounds.VACardPotofGreedRare, flags, 120)
	end
end, mod.ITEM.CARD.POT_OF_GREED)

----------------------------------------------------------------------------------------------------------------

function mod:spritePlay(sprite, anim)
	if not sprite:IsPlaying(anim) then
		sprite:Play(anim)
	end
end

function mod:spriteOverlayPlay(sprite, anim)
	if not sprite:IsOverlayPlaying(anim) then
		sprite:PlayOverlay(anim)
	end
end

function mod:spriteSetAnimation(sprite, anim, reset)
    if reset == nil then reset = false end
    if not sprite:IsPlaying(anim) then
        sprite:SetAnimation(anim, reset)
    end
end


function mod:flipX(npc, vec)
	vec = vec or npc.Velocity
	local sprite = npc:GetSprite()
	if vec.X > 0 then
		sprite.FlipX = true
	else
		sprite.FlipX = false
	end
end


function mod:entIs(spawner, etype, evar, esub)
	etype = etype or nil
	evar = evar or nil
	esub = esub or nil
	if spawner ~= nil and spawner:IsEnemy() then
		if etype == nil or etype == spawner.Type then
			if evar == nil or evar == spawner.Variant then
				if esub == nil or esub == spawner.SubType then
					return true
				end
			end
		end
	end
end

function mod:entChampIs(spawner, etype, evar, echamp)
	etype = etype or nil
	evar = evar or nil
	esub = esub or nil
	if spawner ~= nil and spawner:IsEnemy() then
		if etype == nil or etype == spawner.Type then
			if evar == nil or evar == spawner.Variant then
				if echamp == nil or echamp == spawner:ToNPC():GetBossColorIdx() then
					return true
				end
			end
		end
	end
end

function mod:momFFChampionAI(npc, var)
	local d = mod:GetEntityData(npc)
	local sprite = npc:GetSprite()
	if not d.init then
		d.init = true
	end

	if bpattern and hmbppttn and (Game().Difficulty % 2 == 1) then
		--remove that godawful hp scaling
		for _, enmy in ipairs(Isaac.GetRoomEntities()) do
			if (enmy.Type == 396 or enmy.Type == 45) then
				--im very good at code see
			else
				mod:GetEntityData(enmy).ChangedHP = true
				mod:GetEntityData(enmy).HPIncrease = 0.1
			end
		end

		local mom = npc
		local npcdata = mod:GetEntityData(mom)
		local target = mom:GetPlayerTarget()

		if (not npcdata.ffinit) then
			npcdata.ffinit = true
			npcdata.spriteswaps = 0
			npcdata.spriteswapsneeded = 2
			--vanilla that might be needed
			npcdata.eyeHp = math.max(15, 1.5*GetPlayerDps)
			npcdata.hurt = false
			npcdata.doorbroken = false
			npcdata.handpos = Vector(0,0)
			npcdata.numspider = 1
			npcdata.footframes = 0
			npcdata.checkphase2 = true
			npcdata.imfat = false
			mom.I1 = 0
		end

		if npcdata.checkphase2 then
			if npcdata.phase2 then
				npcdata.checkphase2 = false
				mod.secondphasestomp = true
			end
		end

		--Isaac.ConsoleOutput(tostring(mod.secondphasestomp))

		if npcdata.doorbroken then
			mod.secondphasestomp = false
			npcdata.spriteswapsneeded = 3
		end

		if npcdata.spriteswaps < npcdata.spriteswapsneeded then
			if mom.Variant == 10 or mom.Variant == 20 then
				sprite:Load("gfx/bosses/champions/mom/momstomphmmbp.anm2", true)
				sprite:SetFrame("Stomp", 0)
				if mom.Variant == 20 then
					if mod.momframes then
						npcdata.secondfoot = true
					end
					mod.momframes = true
				end
			else
				if npcdata.doorbroken then
					sprite:Load("gfx/bosses/champions/mom/momdoorhmmbp.anm2", true)
					sprite:Play("DoorBreak", true)
					npcdata.imfat = true
					npcdata.numspider = 1
				else
					sprite:Load("gfx/bosses/champions/mom/momhmmbp.anm2", true)
					sprite:Play("MomDefalut", true)
				end
			end
			npc.Color = mod.ColorNormal
			sprite:ReplaceSpritesheet(0, "gfx/bosses/champions/mom/boss_mom_purple_hmmbp.png")
			sprite:ReplaceSpritesheet(1, "gfx/bosses/champions/mom/boss_mom_purple_hmmbp.png")
			sprite:LoadGraphics()
			npcdata.spriteswaps = npcdata.spriteswaps + 1
		end

		--sprite:ReplaceSpritesheet(0, "gfx/bosses/champions/boss_mom_purple_hmmbp.png")
		--sprite:LoadGraphics()
		--finagleing with hmmbp

		if mom.Variant == 10 then
			--foot
			npcdata.footframes = npcdata.footframes + 1
			mod.momfleshframes = mod.momfleshframes - 1
			mod.momfleshbuffer = mod.momfleshbuffer - 1

			if mom.State == 7 then
				npcdata.footframes = 0
			elseif npcdata.footframes >= 180 and not (hmbppttn.MomStomping or mod.secondphasestomp) then
				npcdata.footframes = 0
				mom.State = 7
				hmbppttn.MomStomping = true
				if (math.random(1,5) > 1 and mom:GetAliveEnemyCount() < 8) or sfx:IsPlaying(84) then
					mom:PlaySound(93, 1, 0, false, 1)
					if math.random(1,2) == 1 and npcdata.phase2 then
						sprite:Play("Stomp2",true)
					else
						sprite:Play("Stomp",true)
					end
					if mom.FrameCount > 30 then
						mom.Position = target.Position
					end
				else
					sprite:Play("Stronger Stomp",true)
					mom:PlaySound(84, 1, 0, false, 1)
				end
			elseif not mod.secondframestomp then
				hmbppttn.MomStomping = false
			end

			if sprite:IsEventTriggered("Stomp") and not mod.secondphasestomp then
				local numberofflames = 12
				for i = 1, numberofflames do
					local vec = Vector(6,0):Rotated((360/numberofflames) * i)
					local fire = Isaac.Spawn(1000,7005, 1, npc.Position + vec:Resized(15), vec, npc)
					fire.Color = Color(1,1,1,1,66 / 255,13 / 255,202 / 255)
					fire:Update()
				end
			elseif sprite:IsPlaying("Stomp2") and sprite:GetFrame() == 68 then
				local numberofflames = 12
				for i = 1, numberofflames do
					local vec = Vector(6,0):Rotated((360/numberofflames) * i)
					local fire = Isaac.Spawn(1000,7005, 1, npc.Position + vec:Resized(25), vec:Resized(math.random(4, 16)), npc)
					fire.Color = Color(1,1,1,1,66 / 255,13 / 255,202 / 255)
					fire:Update()
				end
			end
		elseif mom.Variant == 20 then
			--lastfoot
			if sprite:IsEventTriggered("Stomp") then
				local numberofflames = math.random(6,10)
				for i = 1, numberofflames do
					local vec = Vector(6,0):Rotated((360/numberofflames) * i)
					local fire = Isaac.Spawn(1000,7005, 1, npc.Position + vec:Resized(25), vec:Resized(math.random(1, 12)), npc)
					fire.Color = Color(1,1,1,1,66 / 255,13 / 255,202 / 255)
					fire:Update()
				end
			end
		else
			--door
			mom.StateFrame = mom.StateFrame - 1
			if mom.State == 10 then
				mom.StateFrame = mom.StateFrame + 2
			end

			local canspawn = mod.momfleshframes <= 0 or mod.momfleshbuffer > 0

			if mom.State == 3 and mom.FrameCount >= 100 and mom.StateFrame <= 0 and not hmbppttn.MomStomping and canspawn then
				if math.random(1,12) == 3 then
					if mom.I1 ~= 1 then
						mom.State = 9
						sprite:Play("Fat0"..math.random(1,2), true)
					end
				end
			elseif npcdata.isfat and mom:GetAliveEnemyCount() >= 7 then
				mom.State = 30
				sprm:Play("KnifeThrow", true)
				hmbppttn.MomHand = hmbppttn.MomHand + 1
			end

			if sprite:IsPlaying("Wig") or sprite:IsPlaying("WigHit") or sprite:IsPlaying("WigClose") then
				for _, spidermaybe in ipairs(Isaac.GetRoomEntities()) do
					if spidermaybe.Type == 85 and spidermaybe.Variant == 0 and spidermaybe.SpawnerType == 396 then
						local r = math.random(1, 2)
						--spooter
						for i = 1, r do
							local p = spidermaybe.Position + RandomVector() * math.random(15, 35)
							EntityNPC.ThrowSpider(spidermaybe.Position, spidermaybe, p, false, 0)
						end
						for _, spidermaybelayertwo in ipairs(Isaac.GetRoomEntities()) do
							if spidermaybelayertwo.Type == 85 and spidermaybelayertwo.Variant == 0 and spidermaybelayertwo.SpawnerType == 85 then
								spidermaybelayertwo:ToNPC():Morph(85, 962 + math.random(0,math.random(0,1)), 0, -1)
							end
						end
						--baby
						local r = math.random(5, 8)
						for i = 1, r do
							local p = spidermaybe.Position + RandomVector() * math.random(15, 35)
							EntityNPC.ThrowSpider(spidermaybe.Position, spidermaybe, p, false, 0)
						end
						for _, spidermaybelayertwo in ipairs(Isaac.GetRoomEntities()) do
							if spidermaybelayertwo.Type == 85 and spidermaybelayertwo.Variant == 0 and spidermaybelayertwo.SpawnerType == 85 then
								spidermaybelayertwo:ToNPC():Morph(85, 962, 0, -1)
							end
						end
						--kill the og
						spidermaybe:Remove()
					end
				end
			elseif sprite:IsEventTriggered("ffclose") then
				mom.EntityCollisionClass = 0
			elseif sprite:IsEventTriggered("ffspawn") then
				mod:momhardpatspawn(npc, npcdata)
				mom.EntityCollisionClass = 4
			elseif sprite:IsFinished("Fat01") or sprite:IsFinished("Fat02") then
				--mom.State = 3
				--mom.StateFrame = math.random(35,100)
				mom.EntityCollisionClass = 0
			end
		end
	else
		--I'm really sorry to do this each frame, but it seems to break the door bits if not
		sprite:ReplaceSpritesheet(0, "gfx/bosses/champions/mom/boss_mom_purple.png")
		sprite:ReplaceSpritesheet(1, "gfx/bosses/champions/mom/boss_mom_purple.png")
		sprite:LoadGraphics()
		if var == 10 then
			--Isaac.ConsoleOutput(npc.State .. ", " .. sprite:GetFrame() .. "\n")
			if npc.State == 7 and sprite:GetFrame() == 27 then
				local numberofflames = 8
				for i = 1, numberofflames do
					local vec = Vector(6,0):Rotated((360/numberofflames) * i)
					local fire = Isaac.Spawn(1000,7005, 1, npc.Position + vec:Resized(20), vec, npc)
					fire.Color = Color(1,1,1,1,66 / 255,13 / 255,202 / 255)
					fire:Update()
				end
			end
		else
			if npc.State == 9 then --No hand slaps
				npc.State = 3
				sprite:SetFrame("ArmOpen", 0)
			end
		end
	end
end

function mod:momhardpatspawn(npc, npcdata)
	local e
	mod.momfleshbuffer = 10
	mod.momfleshframes = math.max(mod.momfleshframes, 0)
	if npcdata.imfat then
		mod.momfleshframes = mod.momfleshframes + 90
		npc:PlaySound(SoundEffect.SOUND_SUMMONSOUND, 1, 0, false, 0.8)
		npc:PlaySound(SoundEffect.SOUND_DEATH_BURST_LARGE, 0.75, 0, false, 1)
		--stronger selection
		local randy = math.random(1, 33)
		if randy == 1 then
			--soft serve
			e = Isaac.Spawn(mod.FF.SoftServe.ID, mod.FF.SoftServe.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 2 then
			--honeydrip
			e = Isaac.Spawn(mod.FF.Honeydrip.ID, mod.FF.Honeydrip.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 2 then
			--tallboy
			e = Isaac.Spawn(mod.FF.Tallboi.ID, mod.FF.Tallboi.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 3 then
			--calzone / panini
			e = Isaac.Spawn(mod.FF.Calzone.ID, mod.FF.Calzone.Var, math.random(0, math.random(0,1)), npc.Position, nilvector,npc):ToNPC()
		elseif randy == 4 then
			--sack boy
			e = Isaac.Spawn(mod.FF.Sackboy.ID, mod.FF.Sackboy.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 5 then
			--scythe rider
			e = Isaac.Spawn(mod.FF.ScytheRider.ID, mod.FF.ScytheRider.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 6 then
			--gis
			e = Isaac.Spawn(mod.FF.Gis.ID, mod.FF.Gis.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 7 then
			--homer
			e = Isaac.Spawn(mod.FF.Homer.ID, mod.FF.Homer.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 8 then
			--pitcher
			e = Isaac.Spawn(mod.FF.Pitcher.ID, mod.FF.Pitcher.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 9 then
			--melty
			e = Isaac.Spawn(mod.FF.Melty.ID, mod.FF.Melty.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 10 then
			--drooler
			e = Isaac.Spawn(mod.FF.Drooler.ID, mod.FF.Drooler.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 11 then
			--craterface
			e = Isaac.Spawn(mod.FF.Craterface.ID, mod.FF.Craterface.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 12 then
			--peepy
			e = Isaac.Spawn(mod.FF.Peepling.ID, mod.FF.Peepling.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 13 then
			--head honcho
			e = Isaac.Spawn(mod.FF.HeadHoncho.ID, mod.FF.HeadHoncho.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 14 then
			--brooter
			e = Isaac.Spawn(mod.FF.Brooter.ID, mod.FF.Brooter.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 15 then
			--looker
			e = Isaac.Spawn(mod.FF.Looker.ID, mod.FF.Looker.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 16 then
			--deadfly
			e = Isaac.Spawn(mod.FF.DeadFly.ID, mod.FF.DeadFly.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 17 then
			--watcher
			e = Isaac.Spawn(mod.FF.Watcher.ID, mod.FF.Watcher.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 18 then
			--sombra
			e = Isaac.Spawn(mod.FF.Sombra.ID, mod.FF.Sombra.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 19 then
			--foreseer/psyleech
			e = Isaac.Spawn(mod.FF.Foreseer.ID, mod.FF.Foreseer.Var + math.random(0,1), 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 20 then
			--crosseye
			e = Isaac.Spawn(mod.FF.Crosseyes.ID, mod.FF.Crosseyes.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 21 then
			--primemeind
			e = Isaac.Spawn(mod.FF.Primemind.ID, mod.FF.Primemind.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 22 then
			--curdle
			e = Isaac.Spawn(666, 140, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 23 then
			--ghostse
			e = Isaac.Spawn(mod.FF.Ghostse.ID, mod.FF.Ghostse.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 24 then
			--valvo
			e = Isaac.Spawn(mod.FF.Valvo.ID, mod.FF.Valvo.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 25 then
			--dr funny bones spooky scary (shambles)
			e = Isaac.Spawn(mod.FF.DrShambles.ID, mod.FF.DrShambles.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 26 then
			--cistern
			e = Isaac.Spawn(22, 666, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 27 then
			--mr gob
			e = Isaac.Spawn(mod.FF.MrGob.ID, mod.FF.MrGob.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 28 then
			--looker
			e = Isaac.Spawn(mod.FF.Looker.ID, mod.FF.Looker.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 29 then
			--enlightened
			e = Isaac.Spawn(mod.FF.Enlightened.ID, mod.FF.Var.ID, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 30 then
			--weaver variants
			e = Isaac.Spawn(mod.FF.Weaver.ID, math.random(2, 3), 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 31 then
			--peekaboo
			e = Isaac.Spawn(mod.FF.Peekaboo.ID, mod.FF.Peekaboo.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 32 then
			--squire
			e = Isaac.Spawn(mod.FF.Squire.ID, mod.FF.Squire.Var, 0, npc.Position, nilvector,npc):ToNPC()
		else
			--sniffle
			e = Isaac.Spawn(mod.FF.Sniffle.ID, mod.FF.Sniffle.Var, 0, npc.Position, nilvector,npc):ToNPC()
		end
	else
		mod.momfleshframes = mod.momfleshframes + 45
		npc:PlaySound(SoundEffect.SOUND_SUMMONSOUND, 1, 0, false, 1)
		--weaker seclection
		local randy = math.random(1, 53)
		if randy == 1 then
			--soft serve
			e = Isaac.Spawn(666, 1, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 2 then
			--soft serve sundae
			e = Isaac.Spawn(666, 2, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 3 then
			--uncommon
			randy = math.random(1, 7)
			if randy == 1 then
				--honeydrip
				e = Isaac.Spawn(mod.FF.Honeydrip.ID, mod.FF.Honeydrip.Var, 0, npc.Position, nilvector,npc):ToNPC()
			elseif randy == 2 then
				--homer
				e = Isaac.Spawn(mod.FF.Homer.ID, mod.FF.Homer.Var, 0, npc.Position, nilvector,npc):ToNPC()
			elseif randy == 3 then
				--weaver sr.
				e = Isaac.Spawn(mod.FF.WeaverSr.ID, mod.FF.WeaverSr.Var, 0, npc.Position, nilvector,npc):ToNPC()
			elseif randy == 4 then
				--roly poly
				e = Isaac.Spawn(mod.FF.RolyPoly.ID, mod.FF.RolyPoly.Var, 0, npc.Position, nilvector,npc):ToNPC()
			elseif randy == 5 then
				--bumbler
				e = Isaac.Spawn(mod.FF.Bumbler.ID, mod.FF.Bumbler.Var, 0, npc.Position, nilvector,npc):ToNPC()
			else
				--offal
				e = Isaac.Spawn(mod.FF.Offal.ID, mod.FF.Offal.Var, 0, npc.Position, nilvector,npc):ToNPC()
			end
		elseif randy == 4 then
			--hover
			e = Isaac.Spawn(mod.FF.Hover.ID, mod.FF.Hover.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 5 then
			--mr horf
			randy = math.random(1, 2)
			if randy == 1 then
				e = Isaac.Spawn(mod.FF.MrHorf.ID, mod.FF.MrHorf.Var, 0, npc.Position, nilvector,npc):ToNPC()
			else
				e = Isaac.Spawn(mod.FF.MrRedHorf.ID, mod.FF.MrRedHorf.Var, 0, npc.Position, nilvector,npc):ToNPC()
			end
		elseif randy == 6 then
			--bowler
			e = Isaac.Spawn(mod.FF.Bowler.ID, mod.FF.Bowler.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 7 then
			--rambler
			e = Isaac.Spawn(mod.FF.RamblinEvilMushroom.ID, mod.FF.RamblinEvilMushroom.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 8 then
			--woodburner
			e = Isaac.Spawn(mod.FF.Woodburner.ID, mod.FF.Woodburner.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 9 then
			--foamy
			e = Isaac.Spawn(666, 40, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 10 then
			--fathead
			e = Isaac.Spawn(666, 50, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 11 then
			--wobbles
			e = Isaac.Spawn(666, 110, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 12 then
			--dung
			e = Isaac.Spawn(mod.FF.Dung.ID, mod.FF.Dung.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 13 then
			--slim
			e = Isaac.Spawn(mod.FF.PaleSlim.ID, mod.FF.PaleSlim.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 14 then
			--dweller
			e = Isaac.Spawn(mod.FF.Dweller.ID, mod.FF.Dweller.Var, 1000, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 15 then
			--bbdb
			e = Isaac.Spawn(mod.FF.BubbleBaby.ID, mod.FF.BubbleBaby.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 16 then
			--sniffle
			e = Isaac.Spawn(mod.FF.Sniffle.ID, mod.FF.Sniffle.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 17 then
			--tadokid
			e = Isaac.Spawn(mod.FF.TadoKid.ID, mod.FF.TadoKid.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 18 then
			--boomflies
			randy = math.random(1,2)
			if randy == 1 then
				e = Isaac.Spawn(25, 960, 0, npc.Position, nilvector,npc):ToNPC()
			else
				e = Isaac.Spawn(25, 962, 0, npc.Position, nilvector,npc):ToNPC()
			end
		elseif randy == 19 then
			--spitum
			e = Isaac.Spawn(mod.FF.Spitum.ID, mod.FF.Spitum.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 20 then
			--sourpatch
			e = Isaac.Spawn(mod.FF.Sourpatch.ID, mod.FF.Sourpatch.Var, math.random(0,1), npc.Position, nilvector,npc):ToNPC()
		elseif randy == 21 then
			--nimbus
			e = Isaac.Spawn(21, 666, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy >= 22 and randy <= 25 then
			--morslel
			for i = 0, math.random(2,4) do
				e = Isaac.Spawn(mod.FF.Morsel.ID, mod.FF.Morsel.Var, 0, npc.Position + RandomVector() * math.random(0, 5), nilvector,npc):ToNPC()
				mod:GetEntityData(e).ChangedHP = true
				mod:GetEntityData(e).HPIncrease = 0.1
			end
		elseif randy == 26 then
			--ragurge
			e = Isaac.Spawn(750, 100, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy <= 27 and randy >= 29 then
			--menace
			e = Isaac.Spawn(mod.FF.Menace.ID, mod.FF.Menace.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 30 then
			--slammer
			e = Isaac.Spawn(mod.FF.Slammer.ID, math.random(4, 5), 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 31 then
			--bone slammer
			e = Isaac.Spawn(750, 140, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 32 then
			--splodum
			e = Isaac.Spawn(23, 961, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 33 then
			--posessed
			e = Isaac.Spawn(227, 750, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 34 then
			--crepitus
			e = Isaac.Spawn(227, 666, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 35 then
			--melty
			e = Isaac.Spawn(mod.FF.Melty.ID, mod.FF.Melty.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 36 then
			--tarmaw
			e = Isaac.Spawn(mod.FF.Gunk.ID, mod.FF.Gunk.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 37 then
			--guflush
			e = Isaac.Spawn(mod.FF.Guflush.ID, mod.FF.Guflush.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 38 then
			--piper
			e = Isaac.Spawn(mod.FF.Piper.ID, mod.FF.Piper.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 39 then
			--facade
			e = Isaac.Spawn(mod.FF.Facade.ID, mod.FF.Facade.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 40 then
			--gleek
			e = Isaac.Spawn(mod.FF.Gleek.ID, mod.FF.Gleek.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 41 then
			--charlie
			e = Isaac.Spawn(mod.FF.Charlie.ID, mod.FF.Charlie.Var + math.random(0,1), 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 42 then
			--beeter
			e = Isaac.Spawn(mod.FF.Beeter.ID, mod.FF.Beeter.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 43 then
			--hasunted
			e = Isaac.Spawn(mod.FF.Haunted.ID, mod.FF.Haunted.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 44 then
			--marge
			e = Isaac.Spawn(mod.FF.Marge.ID, mod.FF.Marge.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 45 then
			--sticky
			e = Isaac.Spawn(mod.FF.WalkingStickySack.ID, mod.FF.WalkingStickySack.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 46 then
			--spinneretch
			e = Isaac.Spawn(mod.FF.Spinneretch.ID, mod.FF.Spinneretch.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 47 then
			--spitroast
			e = Isaac.Spawn(mod.FF.Spitroast.ID, mod.FF.Spitroast.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 48 then
			--balor/eyesore
			e = Isaac.Spawn(mod.FF.Balor.ID, mod.FF.Balor.Var + math.random(0,1), 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 49 then
			--fishface
			e = Isaac.Spawn(mod.FF.Fishaac.ID, mod.FF.Fishaac.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 50 then
			--dr funny bones spooky scary (shambles)
			e = Isaac.Spawn(mod.FF.DrShambles.ID, mod.FF.DrShambles.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 51 then
			--gob
			e = Isaac.Spawn(mod.FF.Gob.ID, mod.FF.Gob.Var, 0, npc.Position, nilvector,npc):ToNPC()
		elseif randy == 52 then
			--umbra
			e = Isaac.Spawn(mod.FF.Umbra.ID, mod.FF.Umbra.Var, math.random(1,2), npc.Position, nilvector,npc):ToNPC()
		else
			--poople
			e = Isaac.Spawn(mod.FF.Poople.ID, mod.FF.Poople.Var, 0, npc.Position, nilvector,npc):ToNPC()
		end
	end
	mod:GetEntityData(e).ChangedHP = true
	mod:GetEntityData(e).HPIncrease = 0.1
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local data = mod:GetEntityData(eff)

	eff.RenderZOffset = -1000

	if not data.myrock or (data.myrock.Desc.State ~= 1 and data.myrock.Desc.State ~= 4 and not data.perm) then
		local g
		local room = game:GetRoom()

		eff.Visible = false
		eff:Remove()
	end
end, Isaac.GetEntityVariantByName("Crawlspace Rocktop"))

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local data = mod:GetEntityData(eff)

	eff.RenderZOffset = -1000

	if data.GridIndex == nil then
		eff:Remove()
	else
		local g = room:GetGridEntity(data.GridIndex)
		if data.WasKeyBlock and not (g and mod.IsKeyBlock(g)) then
			local perch = room:GetGridEntityFromPos(room:GetGridPosition(data.GridIndex) + Vector(0, 40))
			local perchtype = perch and perch:GetType()
			local rocktop = perch and FiendFolio.RequiresRocktops[perchtype] and not StageAPI.IsCustomGrid(perch:GetGridIndex(), "FFRubberRock")

			local perchable = perch and
			                  not mod.IsKeyBlock(perch) and
			                  (perchtype == GridEntityType.GRID_DOOR or
			                   perchtype == GridEntityType.GRID_WALL or
			                   perchtype == GridEntityType.GRID_ROCKB or
			                   rocktop) and
							  (not data.Rocktop or perch.Desc.State == 1)

			if data.PerchRemoved == nil and not perchable then
				local rendersprite = eff:GetSprite()

				rendersprite:ReplaceSpritesheet(1, "gfx/grid/blank.png")
				rendersprite:LoadGraphics()

				data.PerchRemoved = true
			end
		elseif g then
			local gt = g:GetType()

			if gt == GridEntityType.GRID_TNT or
			   gt == GridEntityType.GRID_POOP or
			   (StageAPI.IsCustomGrid(data.GridIndex, "FFRubberRock") and g.Desc.State == 1) or
			   mod.IsKeyBlock(g)
			then
				local gridsprite = g:GetSprite()
				local rendersprite = eff:GetSprite()

				rendersprite:Play(gridsprite:GetAnimation(), true)
				rendersprite:SetFrame(gridsprite:GetFrame())
			else
				eff:Remove()
			end

			local perch = room:GetGridEntityFromPos(g.Position + Vector(0, 40))
			local perchtype = perch and perch:GetType()
			local rocktop = perch and FiendFolio.RequiresRocktops[perchtype] and not StageAPI.IsCustomGrid(perch:GetGridIndex(), "FFRubberRock")

			local perchable = perch and
			                  not mod.IsKeyBlock(perch) and
			                  (perchtype == GridEntityType.GRID_DOOR or
			                   perchtype == GridEntityType.GRID_WALL or
			                   perchtype == GridEntityType.GRID_ROCKB or
			                   rocktop) and
							  (not data.Rocktop or perch.Desc.State == 1)

			if data.PerchRemoved == nil and not perchable then
				local rendersprite = eff:GetSprite()

				if gt == GridEntityType.GRID_TNT then
					rendersprite:ReplaceSpritesheet(2, "gfx/grid/blank.png")
					rendersprite:LoadGraphics()
				elseif gt == GridEntityType.GRID_POOP then
					rendersprite:ReplaceSpritesheet(2, "gfx/grid/blank.png")
					rendersprite:LoadGraphics()
				elseif StageAPI.IsCustomGrid(data.GridIndex, "FFRubberRock") then
					rendersprite:ReplaceSpritesheet(2, "gfx/grid/blank.png")
					rendersprite:LoadGraphics()
				elseif mod.IsKeyBlock(g) then
					rendersprite:ReplaceSpritesheet(1, "gfx/grid/blank.png")
					rendersprite:LoadGraphics()
				end

				data.PerchRemoved = true
			end
		else
			eff:Remove()
		end
	end
end, Isaac.GetEntityVariantByName("Crawlspace Grid Rerenderer"))

--Erfly - AI

--Actual enemies

function mod:TrashbaggerHurt(npc, damage, flag, source)
	if npc.SubType == mod.FF.Stomy.Sub then
		if flag & DamageFlag.DAMAGE_EXPLOSION ~= 0 and not mod:IsPlayerDamage(source) --[[and source.Type == 4 and subtype == 2 and source.Entity.SpawnerEntity and source.Entity.SpawnerEntity.Variant == npc.Variant]] then
			return false
		end
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.TrashbaggerHurt, mod.FF.Trashbagger.ID)

function mod:BombmuncherHurt(npc, damage, flag, source)
	local variant = npc.Variant
	local subtype = npc.SubType
	if flag & DamageFlag.DAMAGE_EXPLOSION ~= 0 and source.Type == 4 and variant == 1 and subtype == 5 and source.SpawnerType == npc.Type and source.SpawnerVariant == npc.Variant then
			return false
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.BombmuncherHurt, mod.FF.Bombmuncher.ID)

function mod:CappinHurt(npc, damage, flag, source)
	local variant = npc.Variant
	local data = mod:GetEntityData(npc)
	local sprite = npc:GetSprite()

	if variant == 12 and source.Type == 4 and data.state ~= "tripped" then
			npc.Velocity = npc.Velocity *0.2
			data.state = "trip"
			sprite:Play("TripDown", false)
			return false
	elseif variant == 12 and data.state ~= "tripped" then
			return false
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.CappinHurt, mod.FF.Cappin.ID)

function mod:AshCreepAI(e)
local d = mod:GetEntityData(e)
local s = e:GetSprite()

	--mod:spritePlay(s, "SmallBlood0" .. d.val)

	if d.asplode then
		if not d.spawndfire then
			local fire = Isaac.Spawn(1000,7005, 0, e.Position, nilvector, e.SpawnerEntity):ToEffect()
			fire.Parent = d.Spawner
			fire.SpawnerEntity = d.Spawner
			fire:Update()
			fire.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			if e.Parent then
				mod:GetEntityData(e.Parent).asplode = true
			end
			d.spawndfire = true
			d.StateFrame = 0
		elseif d.spawndfire then
			d.StateFrame = d.StateFrame + 1
			if d.StateFrame > 30 then
			e:Remove()
			elseif d.StateFrame > 20 then
			e.SpriteScale = Vector(1,1) * (1 - ((d.StateFrame - 20)/10))
			end
		end
	end
end

FiendFolio.CollisionFires = {}

--Fire Creep, Ash Fire, Creep Fire, Fatty Fire, FireCreep
function mod:AshCreepFireAI(e)
	local s = e:GetSprite()
	local d = mod:GetEntityData(e)
	local subt = e.SubType

	if not d.init then
		mod:spritePlay(s, "FireStage01")

		if subt == 1 then -- spitroast
			d.Friction = 0.91
			d.timer = 25
		elseif subt == 2 then -- blazer
			d.IsBlue = true
			d.timer = 15
		elseif subt == 20 then -- mr flare
			d.Friction = 0.95
		elseif subt == 450 then --ashtray
			d.Friction = 1
			d.Radius = 10
			d.timer = 25
			d.gridDecerement = 6
			d.offsetAdjustment = 2
			d.checkGridCollTwice = true
		end
		d.scale = d.scale or 1
		d.SpriteScale = e.SpriteScale * d.scale
		d.Size = e.Size * d.scale

		if d.IsBlue then
			s:ReplaceSpritesheet(0, "gfx/enemies/blazer/effect_005_fire_blue.png")
			s:LoadGraphics()
		end

		d.init = true
	end

	if d.makeVisibleLater and e.FrameCount == 1 then
		e.Visible = true
	end

	if d.offsetAdjustment and e.FrameCount <= 5 then
		e.SpriteOffset = Vector(0, e.SpriteOffset.Y + d.offsetAdjustment)
	end

	local room = game:GetRoom()
	--if (not mod.IsActiveRoom()) and d.timer and not d.timeTested then
	--	if e.FrameCount < d.timer then
	--		d.timer = e.FrameCount
	--		d.timeTested = true
	--	end
	--end

	local timer = d.timer or 20

	local parentisdead = nil

	if subt == 10 then -- woodburner neck
		e.SpriteOffset = Vector(0, -5)
		if e.Parent then
			local p = e.Parent
			local val1 = d.subt10val1 or 2.2
			local val2 = d.subt10val2 or 10
			e.Velocity = mod:Lerp(e.Velocity,(p.Position + d.initVel:Resized(e.FrameCount*val1):Rotated(e.FrameCount*val2))-e.Position, 0.6)
		else
			parentisdead = true
		end
	end

	if d.Friction then
		e.Velocity = e.Velocity * d.Friction
	end

	mod:UpdateMeltdownsHeadFire(e, d)

	if parentisdead then
		d.parentcounter = d.parentcounter - 0.1
		e.Color = Color(1,1,1,d.parentcounter, 0, 0, 0)
		local ec = e.Color
		e.Color = Color(ec.R, ec.G, ec.B, d.parentcounter, ec.RO, ec.GO, ec.BO)
	end

	local fc = e.FrameCount
	if not parentisdead and fc > 3 and fc < timer + 5 and (e.InitSeed + fc) % 3 == 0 then
		table.insert(FiendFolio.CollisionFires, e)
	end

	if fc < 5 then
		if d.flamethrower then
			e.SpriteScale = (d.SpriteScale * 0.5) + (d.SpriteScale * fc / 10)
		else
			e.SpriteScale = d.SpriteScale * fc / 5
		end
	elseif e.FrameCount > timer then
		if d.flamethrower then
			e.SpriteScale = d.SpriteScale * (1 + ((fc - timer)/50))
		else
			e.SpriteScale = d.SpriteScale * (1 - ((fc - timer)/20))
		end
		--[[if e.SpriteScale.X < 0 or e.SpriteScale.Y < 0 then
			e:Remove()
		end]]
		local ec = e.Color
		if (not d.parentcounter) or (d.parentcounter and not parentisdead) then
			e.Color = Color(ec.R, ec.G, ec.B, 1 - ((fc - timer)/10), ec.RO, ec.GO, ec.BO)
		end
		if e.FrameCount > timer + 10 then
			e:Remove()
		end
	else
		e.SpriteScale = d.SpriteScale
		if d.gridcoll and fc > d.gridcoll then
			local grid = room:GetGridEntity(room:GetGridIndex(e.Position))
			if grid then
				local coll = grid.CollisionClass
				if coll > 1 then
					d.NoDamage = true
					local toRemove = d.gridDecerement or 3
					d.timer = fc - toRemove
				end
			end
			--Since Ashtray's flames move so quick they could sometimes slip through single grids
			if d.checkGridCollTwice then
				local grid = room:GetGridEntity(room:GetGridIndex(e.Position - (e.Velocity/2)))
				if grid then
					local coll = grid.CollisionClass
					if coll > 1 then
						d.NoDamage = true
						local toRemove = d.gridDecerement or 3
						d.timer = fc - toRemove
					end
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.AshCreepFireAI, 7005)

function mod:BusterFiendFolioItemFireFunctionReal(e) --fucky stuff
	local s = e:GetSprite()
	local d = mod:GetEntityData(e)
	local subt = e.SubType

	if d.busterRecreation then
		if not d.init then
			d.scale = d.scale or 1
			d.SpriteScale = e.SpriteScale * d.scale
			d.Size = e.Size * d.scale

			local subt = e.SubType
			if d.busterFireball then
				d.Friction = 0.91
				d.timer = 25
			elseif subt == 1 then -- spitroast
				d.Friction = 0.91
				d.timer = 25
			elseif subt == 2 then -- blazer
				d.IsBlue = true
				d.timer = 15
			elseif subt == 20 then -- mr flare
				d.Friction = 0.95
			elseif subt == 450 then --ashtray
				d.Friction = 1
				d.Radius = 10
				d.timer = 25
				d.gridDecerement = 6
				d.offsetAdjustment = 2
				d.checkGridCollTwice = true
			end

			d.init = true
		end

		local room = game:GetRoom()
		local timer = d.timer or 20
		local fc = e.FrameCount

		if d.Friction then
			e.Velocity = e.Velocity * d.Friction
		end

		if fc < 5 then
			if d.flamethrower then
				e.SpriteScale = (d.SpriteScale * 0.5) + (d.SpriteScale * fc / 10)
			else
				e.SpriteScale = d.SpriteScale * fc / 5
			end
		elseif e.FrameCount > timer then
			if d.flamethrower then
				e.SpriteScale = d.SpriteScale * (1 + ((fc - timer)/50))
			else
				e.SpriteScale = d.SpriteScale * (1 - ((fc - timer)/20))
			end
			--[[if e.SpriteScale.X < 0 or e.SpriteScale.Y < 0 then
				e:Remove()
			end]]
			local ec = e.Color
			e.Color = Color(ec.R, ec.G, ec.B, 1 - ((fc - timer)/10), ec.RO, ec.GO, ec.BO)
			if e.FrameCount > timer + 10 then
				e:Remove()
			end
		end

		for _,com in ipairs(Isaac.FindByType(FiendFolio.Commission.Id.Type,	FiendFolio.Commission.Id.Variant, FiendFolio.Commission.Id.SubType, false, false)) do --eh whatever I don't wnat to make a commission familiar I think that would suck
			local d = mod:GetEntityData(com)
			if not d.Berserk and com.EntityCollisionClass > 0 and com.Position:Distance(e.Position) < 40 then
				d.Berserk = true
				d.Exploding = true
				com.Parent = nil
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.BusterFiendFolioItemFireFunctionReal, 51)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local data = mod:GetEntityData(eff)
	if data.IsScaledEff then
		eff.SpriteScale = eff.SpriteScale * eff.Scale
		if eff.FrameCount >= eff.Timeout then
			local color = eff.Color
			color.A = mod:Lerp(1, 0, (eff.FrameCount - eff.Timeout) / (eff.LifeSpan - eff.Timeout))
			eff.Color = color
		end

		if eff.FrameCount >= eff.LifeSpan then eff:Remove() end
	end

	if data.IsGravityEff then
		eff.SpriteOffset = Vector(eff.SpriteOffset.X, eff.m_Height)
		eff.m_Height = eff.m_Height + eff.FallingSpeed
		eff.FallingSpeed = eff.FallingSpeed + eff.FallingAcceleration
	end
end)

function mod:CheckFireCollision()
	local checkedFires = FiendFolio.CollisionFires
	if #checkedFires == 0 then return end

	for i = 1, #checkedFires do
		local fire = checkedFires[i]
		local d = mod:GetEntityData(fire)
		if not d.NoDamage then
			local radius = d.Radius or 20
			local colEnts = Isaac.FindInRadius(fire.Position, radius, EntityPartition.ENEMY | EntityPartition.PLAYER)
			for i = 1, #colEnts do
				local entity = colEnts[i]
				if entity.Type == 1 or (entity.EntityCollisionClass > 2 and entity:IsActiveEnemy()) then
					entity:TakeDamage(1, DamageFlag.DAMAGE_FIRE, EntityRef(fire), 0)
				end
			end
		end
	end
end

-- uncomment code for benchmarking
--local running = {}
--local maxavg = 0
--local socket = require('socket')
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	--local t = socket.gettime()
	mod:CheckFireCollision()
	FiendFolio.CollisionFires = {}
	--local dt = (socket.gettime() - t) * 1000
	--table.insert(running, 1, dt)
	--table.remove(running, 11)
	--local avg = 0
	--for _, tt in pairs(running) do
	--    avg = avg + tt
	--end
	--avg = avg / #running
	--maxavg = math.max(maxavg, avg)
	--print("elapsed", dt, "avg", avg, maxavg)
end)

function mod:bouncerAI(npc)
	local room = game:GetRoom()
	local path = npc.Pathfinder
	local sprite = npc:GetSprite()
	local npcd = mod:GetEntityData(npc)

	--When Jumping
		if npcd.IsJumping == 1 then
			npc.Friction = 1
			local dist = (npc.Position - npcd.JumpTarget):Length()
			if dist < 20 and npc.Velocity:Length() < 20 then
				npc.Position = npcd.JumpTarget
				npcd.OnTarget = true
			else
				npc.Velocity = npc.Velocity + Vector(-(npc.Position.X - npcd.JumpTarget.X), -(npc.Position.Y - npcd.JumpTarget.Y)):Normalized() * (dist / 25)
				local arcvel = npc.Velocity
				if arcvel:Length() >= dist then
					npc.Velocity = arcvel:Resized(dist)
				end
			end
		end
	--Initialisation
		if npc.State == 0 then
			npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			npcd.Wait = 0
			npc.State = 20
	--Interlude between jumps.
		elseif npc.State == 20 then
			if npcd.Wait == 0 then
				sprite:Play("Idle", 0)
				npcd.waitrng = math.random(10)
			end
			npcd.Wait = npcd.Wait + 1
			if npcd.Wait > 10 + npcd.waitrng then
				npc.State = 21
				npcd.Jumps = math.random(4) + 2
				npcd.JumpCount = 0
				npcd.Wait = 0
			end
	--Initial Jump
		elseif npc.State == 21 then
			if sprite:IsFinished("BounceUp") then
				npc.State = 25
			elseif not sprite:IsPlaying("BounceUp") then
				sprite:Play("BounceUp", 0)
			end
			if sprite:IsEventTriggered("Jump") then
				npcd.JumpTarget = room:FindFreeTilePosition(npc.Position + (RandomVector()*30), 40) + (RandomVector()*10)
				npcd.IsJumping = 1
				npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
				npcd.JumpCount = npcd.JumpCount + 1
			end
	--Inbetween jumps
		elseif npc.State == 25 then
				sprite:Play("BounceAir", 0)
			if npcd.OnTarget then
				npcd.OnTarget = false
				if npcd.JumpCount > npcd.Jumps then
					npc.State = 30
				else
					npc.State = 40
				end
			end
	--Rebound Bounce
		elseif npc.State == 30 then
			if sprite:IsFinished("BounceRebound") then
				npc.State = 25
			elseif not sprite:IsPlaying("BounceRebound") then
				sprite:Play("BounceRebound", 0)
			end
			if sprite:IsEventTriggered("Slam") then
				npcd.IsJumping = 0
				npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
				npc.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
			end
			if sprite:IsEventTriggered("Jump") then
				npcd.JumpTarget = room:FindFreeTilePosition(npc.Position + (RandomVector()*30), 40) + (RandomVector()*10)
				npcd.IsJumping = 1
				npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
				npcd.JumpCount = npcd.JumpCount + 1
			end
	--Bounce End
		elseif npc.State == 40 then
			if sprite:IsFinished("BounceEnd") then
				npc.State = 41
			elseif not sprite:IsPlaying("BounceEnd") then
				sprite:Play("BounceEnd", 0)
			end
			if sprite:IsEventTriggered("Slam") then
				npcd.IsJumping = 0
				npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
				npc.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
			end
	--Puffed Out
		elseif npc.State == 41 then
			if sprite:IsFinished("PuffedOut") then
				npc.State = 20
			elseif not sprite:IsPlaying("PuffedOut") then
				sprite:Play("PuffedOut", 0)
			end
		end
end

--FacadeAI
function mod:hungryganAI(npc)
local room = game:GetRoom()
local sprite = npc:GetSprite();
local d = mod:GetEntityData(npc);
local target = npc:GetPlayerTarget()
local path = npc.Pathfinder

	local facspeed = 6.5

	if target.Type == 1 then
		local playerhere = target:ToPlayer()
		if playerhere.MoveSpeed < 1 then
			facspeed = 6.5 * math.max(0.6, playerhere.MoveSpeed)
		end
	end


	if not d.init then
		d.npcState = "idle"
		d.init = true
	elseif d.init then
		npc.StateFrame = npc.StateFrame + 1
	end

	if d.npcState == "idle" then
		--Only run away mulligan style
		npc.State = 4

		--local closestplayer = mod.FindClosestEntity(npc.Position,99999,1)

		if npc.Position:Distance(target.Position) < 60 and not mod:isScareOrConfuse(npc) then
			d.npcState = "startangery"
		end

	elseif d.npcState == "startangery" then
		npc.State = 6
		local overlayFrame = sprite:GetOverlayFrame()

		if sprite:IsOverlayFinished("Explode") then
			d.npcState = "angery"
		elseif overlayFrame == 7 then
			d.angerywalk = true
			npc.StateFrame = 0
			npc:PlaySound(SoundEffect.SOUND_MEATY_DEATHS,1,0,false,0.7)
			npc:BloodExplode()
		else
			mod:spriteOverlayPlay(sprite, "Explode")
		end

		if not d.angerywalk then
			npc:AnimWalkFrame("WalkHori","WalkVert",0)
			npc.Velocity = npc.Velocity * 0.9
		end

	elseif d.npcState == "angery" then
		npc.State = 6
		local overlayFrame = sprite:GetOverlayFrame()

		mod:spriteOverlayPlay(sprite, "WalkAngery")

		if overlayFrame == 6 then
			--npc:BloodExplode()
		end
	end

	if d.angerywalk then

	--Movement
		local targetpos = mod:confusePos(npc, target.Position)
		if room:CheckLine(npc.Position,targetpos,0,1,false,false) or mod:isScare(npc) then
			d.targetvelocity = mod:reverseIfFear(npc, (targetpos - npc.Position):Resized(facspeed))
			npc.Velocity = mod:Lerp(d.targetvelocity, npc.Velocity, 0.8)
		else
			 mod:CatheryPathFinding(npc, targetpos, {
				Speed = facspeed,
				Accel = 0.2,
				GiveUp = true
			 })
		end

		npc:AnimWalkFrame("WalkHoriRage","WalkVertRage",0)

	--Anger other facades
		if npc.StateFrame % 10 == 0 then
			for index,entity in ipairs(Isaac.FindByType(16, mod.FF.Facade.Var, 0, false, false)) do
				if npc.Position:Distance(entity.Position) < 200 then
					if room:CheckLine(npc.Position, entity.Position, 3, 1, false, false) then
						if not mod:isScareOrConfuse(entity:ToNPC()) then
							mod:GetEntityData(entity).npcState = "startangery"
							entity.SubType = 1
						end
					end
				end
			end
		end

	--Bleed
		if npc.FrameCount % 2 == 1 then
			local blood = Isaac.Spawn(1000, 7, 0, npc.Position, nilvector, npc)
			blood.SpriteScale = Vector(0.6,0.6)
			blood:Update()
		end

	end

	if npc:IsDead() then
		for index,entity in ipairs(Isaac.GetRoomEntities()) do
			if entity.SpawnerType == 16 and entity.SpawnerVariant == mod.FF.Facade.Var then
				local entype = entity.Type
				if entype == 13 or entype == 14 or entype == 18 then
					entity:Remove()
				end
			end
		end
		if mod:shouldDoDeathEffect(npc) then
			local startvec = RandomVector()*8
			for i = 1, 9 do
			mod:LazySpawnProjectile(0, 0, npc.Position, startvec:Rotated(360/9 * i), npc):ToProjectile();
			end
		end
	end

end

function mod:HungerHurt(npc, damage)
	if npc.Variant == mod.FF.Facade.Var then
		if npc.SubType == 0 then
			mod:GetEntityData(npc).npcState = "startangery"
			npc.SubType = 1
		end
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.HungerHurt, 16)

function mod:ffShopkeeperAI(npc)
	local subt = npc.SubType
	if subt == 0 then
		npc.SubType = math.random(9)
	end
	mod:spritePlay(npc:GetSprite(), "Shopkeeper " .. subt)
end

function mod:rolyPolyAI(npc, subt)
local room = game:GetRoom()
local sprite = npc:GetSprite();
local data = mod:GetEntityData(npc);
local target = npc:GetPlayerTarget()
npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)

	if not data.initcomplete then
		data.initcomplete = true
		data.bstate = 0
		local level = game:GetLevel()
		local stage = level:GetStage()
		local stageType = level:GetStageType()

		if data.spawnedFromBubble == true then
			npc.State = 16
			sprite:Play("Roll", true)
			data.launchedEnemyInfo = {zVel = -3, height = -30, pos = true}
			--data.z_vel = -3
			npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		end
	end

	if npc.State == 16 then
		if sprite:IsFinished("RollEnd") then
			npc.State = 4
		elseif npc.SpriteOffset.Y < 0 then
			mod:spritePlay(sprite, "Roll")
		elseif data.launchedEnemyLanded then
			npc.SpriteOffset = Vector.Zero
			mod:spritePlay(sprite, "RollEnd")
			data.bubbleInit = true
		end
		npc.Velocity = Vector.Zero
	elseif npc.State == 4 then
	npc.Friction = 1
		if npc.Velocity:Length() > 3 then
			npc.Velocity = npc.Velocity:Normalized() * 3
		end
			local d = target.Position - npc.Position
		if (npc.Position:Distance(target.Position) < 100 and room:CheckLine(npc.Position, target.Position,0,1,false,false)) and not mod:isScareOrConfuse(npc)
		or ((npc.Velocity:Normalized():Dot(d:Normalized()) > math.cos(0.3)) and npc.Position:Distance(target.Position) < 300 and room:CheckLine(npc.Position, target.Position,0,1,false,false)) and not mod:isScareOrConfuse(npc)
		then
			data.bstate = 1
			npc.State = 10
		end

	elseif npc.State == 10 then
		if data.bstate == 1 then
			if sprite:IsFinished("RollStart") then
				data.bstate = 2
				data.rollTime = 0
				npc.StateFrame = 1
			elseif not sprite:IsPlaying("RollStart") then
				sprite:Play("RollStart", true)
			end

		elseif data.bstate == 2 then
			data.rollTime = data.rollTime + 1
		--npc.Friction = 1.05

		--Play sound
			if not sfx:IsPlaying(mod.Sounds.RolyPolyRoll) and not npc:HasMortalDamage() then
				sfx:Play(mod.Sounds.RolyPolyRoll, 0.6, 0, true, 1)
			end

		--Too close to player?
			if data.rollTime > 120 or npc.Position:Distance(target.Position) < 30 or mod:isScareOrConfuse(npc) then
				data.bstate = 3
			end
		--Movement
		data.TargetVelocity = (target.Position - npc.Position):Normalized() * 10
		npc.Velocity = mod:Lerp(npc.Velocity, data.TargetVelocity, 0.07)

			--Grid Bounce
			if npc:CollidesWithGrid() == true then
				if npc.Velocity:Length() < 5 then
					data.bstate = 3
				else
					data.TargetVelocity = mod.bounceOffWallLegacy(npc.Position, npc.Velocity)
					data.TargetVelocity = data.TargetVelocity * 50
				end
			end

		--Septic
		if subt == 1 and npc.FrameCount % 3 == 0 then
			local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_GREEN, 0, npc.Position, nilvector, npc):ToEffect();
			creep:Update()
		end

		--Enemy sight stop
		if not room:CheckLine(npc.Position, target.Position,0,1,false,false) then
			npc.StateFrame = npc.StateFrame + 1
			if npc.StateFrame > 180 then
				data.bstate = 3
			end
		else
			npc.StateFrame = 1
		end

		--Animations
			if not sprite:IsPlaying("Roll") then
				sprite:Play("Roll", true)
			end
			if npc.Velocity.X < 0 then
				sprite.FlipX = true
			else
				sprite.FlipX = false
			end
		--FindGridPath(npc, npc:GetPlayerTarget().Position, 5, 1, true, 100, false, false)
		elseif data.bstate == 3 then
			npc.Friction = 1
			npc.Velocity = npc.Velocity * 0.93
			if sprite:IsFinished("RollEnd") then
				npc.State = 4
				data.bstate = 0
			elseif not sprite:IsPlaying("RollEnd") then
				sprite:Play("RollEnd", true)
				sfx:Stop(mod.Sounds.RolyPolyRoll)
			end
		end
	end
end
--mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.LaunchedEnemyRender, EntityType.ENTITY_MAGGOT)

--Kinda funny going from a maggot to a knight but thanks nicalis
--PsiKnight
function mod:psionicKnightAI(npc, sprite, d)
local room = game:GetRoom()
local subt = npc.SubType

	mod:setTargetOfNPC(npc, d)

	local target = npc:GetPlayerTarget()
	local r = npc:GetDropRNG()
	local speed = 15

	if not d.init then
		npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		d.state = "idle"
		d.faceAngle = Vector(0,-1)
		d.init = true
	end

	if npc.State == 4 then
		local suffix = string.sub(sprite:GetAnimation(), 6)
		if suffix == "Hori" then
			d.faceAngle = sprite.FlipX and Vector(1,0) or Vector(-1,0)
		elseif suffix == "Down" then
			d.faceAngle = Vector(0,-1)
		else
			d.faceAngle = Vector(0,1)
		end
		if npc.StateFrame > 20 and target.Position:Distance(npc.Position) < 250 and not mod:isScareOrConfuse(npc) then
			if math.abs(npc.Velocity.X) < math.abs(npc.Velocity.Y) then
				if math.abs(npc.Position.X - target.Position.X) < 20 then
					npc.State = 10
					d.state = "chargeinit"
					if npc.Velocity.Y < 0 then
						d.dir = {"Up", Vector(0,-speed)}
					else
						d.dir = {"Down", Vector(0,speed)}
					end
					d.faceAngle = -d.dir[2]
				end
			else
				if math.abs(npc.Position.Y - target.Position.Y) < 20 then
					npc.State = 10
					d.state = "chargeinit"
					if npc.Velocity.X < 0 then
						d.dir = {"Hori", Vector(-speed,0)}
					else
						d.dir = {"Hori", Vector(speed,0)}
					end
					sprite.FlipX = (d.dir[2].X < 0)
					d.faceAngle = -d.dir[2]
				end
			end
		end

	elseif npc.State == 10 then
		if d.dir[1] == "Hori" then
			sprite.FlipX = (d.dir[2].X < 0)
		end
		if d.state == "chargeinit" then
			npc.Velocity = npc.Velocity * 0.7
			if sprite:IsFinished("Brimstone" .. d.dir[1]) then
				d.state = "chargeloop"
				mod:spritePlay(sprite, "Brimstone" .. d.dir[1] .. "Loop")
			elseif sprite:IsEventTriggered("flystart") then
				d.flying = true
				npc.StateFrame = 0
				npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
				local brim = Isaac.Spawn(7,1,0,npc.Position, nilvector, npc):ToLaser()
				brim.PositionOffset = Vector(0, -26)
				brim.SpawnerEntity = npc
				brim.Parent = npc
				brim.Angle = (d.dir[2]:Rotated(180)):GetAngleDegrees()
				brim:SetTimeout(10000)
				mod:GetEntityData(brim).annoyingAndStupidPsionicKnightThing = true
				brim:Update()
				d.brim = brim
			else
				mod:spritePlay(sprite, "Brimstone" .. d.dir[1])
			end
		elseif d.state == "chargeloop" then
			mod:spritePlay(sprite, "Brimstone" .. d.dir[1] .. "Loop")
		elseif d.state == "chargecollide" then
			npc.Velocity = npc.Velocity * 0.1
			if sprite:IsFinished(d.dir[1] .. "Collide") then
				d.state = "chargedizzy"
				npc.StateFrame = 0
			else
				mod:spritePlay(sprite, d.dir[1] .. "Collide")
			end
		elseif d.state == "chargedizzy" then
			mod:spritePlay(sprite, d.dir[1] .. "Dizzy")
			if npc.StateFrame > 30 then
				npc.State = 4
				d.state = "idle"
				npc.StateFrame = 0
			end

		end
		if d.flying then
			npc.Velocity = d.dir[2]:Resized(speed * (1 + (npc.StateFrame / 5)))
			if npc.Velocity:Length() > 30 then
				npc.Velocity = npc.Velocity:Resized(30)
			end
			if d.brim then
				d.brim:Update()
			end
			local rockAhead
			for i = 1, 3 do
				if room:GetGridCollisionAtPos(npc.Position + npc.Velocity:Resized(10 * i)) > 1 then
					rockAhead = true
					break
				end
			end
			if npc:CollidesWithGrid() or rockAhead then
				game:ShakeScreen(5)
				npc:PlaySound(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND,0.6,2,false,1.7)
				--[[if npc.Velocity:Length() > 20 then
					npc.Velocity = npc.Velocity:Resized(20)
				elseif npc.Velocity:Length() < 8 then
					npc.Velocity = npc.Velocity * 0.1
				end]]
				--npc.Position = npc.Position - npc.Velocity
				npc.Velocity = npc.Velocity * 0.1
				d.flying = false
				d.brim:SetTimeout(1)
				local coll = room:GetGridCollisionAtPos(npc.Position)
				if coll ~= GridCollisionClass.COLLISION_PIT then
					npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
					d.state = "chargecollide"
				else
					npc:Kill()
				end
			end
		end
	end
end

function mod:SternumDestruction(npc)
local d = mod:GetEntityData(npc)
	d.keepchargin = false
	d.Vec = nil
	npc.State = 10

	local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, npc.Position, nilvector, npc)
	smoke.SpriteRotation = math.random(360)
	smoke.Color = Color(1,1,1,0.3,75 / 255,70 / 255,50 / 255)
	smoke.SpriteScale = Vector(2,2)
	smoke.SpriteOffset = Vector(0, -10)
	smoke:Update()

	npc:PlaySound(SoundEffect.SOUND_BONE_SNAP, 1, 0, false, math.random(90,110)/100)
	npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	local vec = RandomVector()
	for i = 120, 360, 120 do
		local rib = Isaac.Spawn(mod.FF.SternumRib.ID, mod.FF.SternumRib.Var, i/120, npc.Position, vec:Resized(9):Rotated(i - 30 + math.random(60)), npc):ToNPC();
		rib:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		rib.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
		rib.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
		rib.Parent = npc
		rib:Update()
	end
end

--sternumAI
function mod:rocketChargerAI(npc, variant)
	local d = mod:GetEntityData(npc)
	local sprite = npc:GetSprite()

	if not d.init then
		d.count = 0
		if variant == mod.FF.Splodum.Var then
			npc.SplatColor = Color(0,0,0,1,20 / 255,10 / 255,10 / 255)
		end
		npc:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
		d.init = true
	end

	if d.keepchargin then
		npc.State = 8
	end

	if npc.State == 8 then
		npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		d.keepchargin = true
		d.count = d.count + 1
		local velnew = (1.2 + (d.count / 7))^2
		npc.Velocity = npc.Velocity:Resized(math.min(25,velnew))
		if npc:CollidesWithGrid() == true then
			npc.Velocity = npc.Velocity * 0.3
			if variant == mod.FF.Splodum.Var then
				npc:Kill()
			else
				mod:SternumDestruction(npc)
			end
		end
	elseif npc.State == 10 then
		npc.Velocity = npc.Velocity * 0.3
		if not d.state then
			if sprite:IsFinished("Collide") then
				d.state = "sitThere"
				npc.StateFrame = 0
			else
				mod:spritePlay(sprite, "Collide")
			end
		elseif d.state == "sitThere" then
			if npc.StateFrame > 180 then
				d.sucking = false
				mod:spritePlay(sprite, "HeadIdle")
			elseif npc.StateFrame > 60 then
				d.sucking = true
				if sprite:IsFinished("SuckStart") then
					mod:spritePlay(sprite, "Suck")
				elseif not sprite:IsPlaying("Suck") then
					mod:spritePlay(sprite, "SuckStart")
				end
				d.returns = d.returns or {0,0,0}
				local anyNotBack
				for i = 1, #d.returns do
					if d.returns[i] == 0 then
						anyNotBack = true
					end
				end
				if not anyNotBack then
					d.state = "reform"
					sfx:Play(SoundEffect.SOUND_BONE_HEART, 1, 0, false, math.random(90,110)/100)
					local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, npc.Position, nilvector, npc)
					smoke.SpriteRotation = math.random(360)
					smoke.Color = Color(1,1,1,0.3,75 / 255,70 / 255,50 / 255)
					smoke.SpriteScale = Vector(2,2)
					smoke.SpriteOffset = Vector(0, -10)
					smoke:Update()
				end
			else
				mod:spritePlay(sprite, "HeadIdle")
			end
		elseif d.state == "reform" then
			d.returns = nil
			d.sucking = nil
			if sprite:IsFinished("Appear") then
				npc.State = 4
				d.count = 0
				d.state = nil
			else
				mod:spritePlay(sprite, "Appear")
			end
		end
	else
		d.count = 0
	end

	if npc:IsDead() and variant == mod.FF.Splodum.Var and mod:shouldDoDeathEffect(npc) then
		local params = ProjectileParams()
		for i = 120, 360, 120 do
			params.Variant = 1
			params.FallingSpeedModifier = -15 - math.random(10)
			params.FallingAccelModifier = 1.4 + math.random(2)/10;
			params.VelocityMulti = ((math.random(6,7) * (math.random(7,13)/100)))
			params.Color = Color(0.3, 0.3, 0.3, 1, 0, 0, 0)
			npc:FireProjectiles(npc.Position, Vector(0,8):Rotated(i-40+math.random(80)), 0, params)
		end
		Isaac.Explode(npc.Position, npc, 10)
	end
end

function mod:sternumRibsAI(npc, subt)
	local d = mod:GetEntityData(npc)
	local sprite = npc:GetSprite()

	if not d.init then
		mod:spritePlay(sprite, "spin" .. subt)
		d.init = true
		npc:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
		npc.SpriteOffset = Vector(0, -5)
	else
		npc.StateFrame = npc.StateFrame + 1
	end
	if npc.Parent and not mod:isStatusCorpse(npc.Parent) then
		local p = npc.Parent
		local pd = mod:GetEntityData(p)

		if pd.state == "reform" then
			npc:Remove()
		elseif pd.sucking and p:GetSprite():IsPlaying("Suck") then
			local targvec = (p.Position - npc.Position) * 0.1
			npc.Velocity = mod:Lerp(npc.Velocity, targvec, 0.3)
			mod:spritePlay(sprite, "spin" .. subt)
			if npc.Position:Distance(p.Position) < 10 then
				pd.returns = pd.returns or {0,0,0}
				pd.returns[subt] = 1
			end
		elseif npc.StateFrame > 30 then
			npc.Velocity = npc.Velocity * 0.8
			if p:GetSprite():IsPlaying("SuckStart") then
				mod:spritePlay(sprite, "spin" .. subt)
			else
				mod:spritePlay(sprite, "idle" .. subt)
			end
		else
			npc.Velocity = npc.Velocity * 0.96
			mod:spritePlay(sprite, "spin" .. subt)
		end
	else
		npc:Kill()
	end
end

function mod:chargerCollide(npc, npc2, mysteryBoolean)
	if npc.Variant == mod.FF.Splodum.Var or npc.Variant == mod.FF.Sternum.Var then
		if npc:ToNPC().State == 8 then
			if npc2.Type == mod.FFID.Tech and npc2.Variant < 3 then
				npc2:Kill()
			elseif npc2.Type == 1 or npc2:IsEnemy()
			or (npc2.Type == 8 and npc2.SubType == 617) --Samel scythe
			then
				if npc.Variant == mod.FF.Sternum.Var then
					mod:SternumDestruction(npc:ToNPC())
				else
					npc:Kill()
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION , mod.chargerCollide, 23)

--FIEND FOLIO REHEATED WHOOOOOOO

mod.reheatedEnemies = {
{23, 1700},	--Reheated Charger
{87, 710},
{214, 710},
{214, 711},
{214, 712},
{214, 713},
{214, 714},
{215, 710},
{215, 711},
{215, 712},
{215, 713},
{215, 714},
{215, 715},
{240, 710},
{240, 711},
{284, 710},
{mod.FF.ReheatedBeserker.ID, mod.FF.ReheatedBeserker.Var},
}

--Reheated Chest
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	pickup.Velocity = pickup.Velocity * 0.8
	local sprite = pickup:GetSprite()
	if sprite:IsFinished("Appear") then
		sprite:Play("Idle", true)
	end
	if sprite:IsFinished("Open") then
		sprite:Play("Opened", true)
	end
	if sprite:IsPlaying("Open") and sprite:GetFrame() == 5 then
		local rand = math.random(#mod.reheatedEnemies)
		local en = mod.reheatedEnemies[rand]
		local friend = Isaac.Spawn(en[1], en[2], 0, pickup.Position + Vector(0,10), nilvector, npc)
	end
	if sprite:IsEventTriggered("DropSound") then
		sfx:Play(SoundEffect.SOUND_CHEST_DROP, 1, 0, false, 1.0)
	end
	if mod:GetEntityData(pickup).Opened and sprite:IsPlaying("Idle") then
		pickup:Remove()
	end
end, 710)

--Grid Restock
mod.d12machines = {}
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, function(_, machine)
    local mData = mod:GetEntityData(machine)
    local sprite = machine:GetSprite()
    if machine.FrameCount == 1 then     --Init
      mData.State = 1
      if not mod.d12machines[machine.InitSeed] then   --New machine
        mod.d12machines[machine.InitSeed] = {}
        mod.d12machines[machine.InitSeed][0] = 4  --Rerolls left (Guaranteed)
        mod.d12machines[machine.InitSeed][1] = 0  --Bombs stored
        mData.RerollsLeft = 4
        mData.BombsStored = 0
      else
        mData.RerollsLeft = mod.d12machines[machine.InitSeed][0]
        mData.BombsStored = mod.d12machines[machine.InitSeed][1]
      end
    end

    if not mData.Countdown then mData.Countdown = 0 end
    if mData.Countdown > 0 then mData.Countdown = mData.Countdown - 1 end

    --[states] 1:Idle; 2:Gets bomb; 3:RngReroll; 4:Rerolling; 5:ded; 6:killed(by explosion/shockwave/etc)

    if mData.State ~= 5 and sprite:IsPlaying("Broken") then
      local room = game:GetRoom()
      local grids = mod.reroll_grids({2, 3, 4, 5, 6, 12, 14, 22, 25, 27}, true, true, true)
      local id = grids[math.random(#grids)]
	 --Sometimes errors???
	  if id then
		room:RemoveGridEntity(id, 0, false)
		mData.Countdown = 20
		mData.gPoop = id
		mData.State = 5
	  else
		--In case it breaks idk
		mData.State = 6
	  end
    elseif mData.State == 2 then
      mData.BombsStored = mData.BombsStored + 1
      mod.d12machines[machine.InitSeed][1] = mData.BombsStored
      sprite:Play("BombInsert", true)
      mData.State = 3
    elseif mData.State == 3 then
      if sprite:IsFinished("BombInsert") then
        if math.random(100) <= 15 + 25*mData.BombsStored then
          sprite:Play("Wiggle", true)
        else
		  mod:fortuneGrubCheck()
          mData.State = 1
          sprite:Play("Idle", true)
          mData.Countdown = 10
        end
      end
      if sprite:IsEventTriggered("BombPlace") then SFXManager():Play(201, 1, 0, false, 0.8) end
      if sprite:IsEventTriggered("BombInsert") then SFXManager():Play(24, 1, 0, false, 0.9) end
      if sprite:IsFinished("Wiggle") then
        mData.State = 4
        sprite:Play("Prize", true)
      end
    elseif mData.State == 4 then
      if sprite:IsEventTriggered("Prize") then
		mod:fortuneGrubCheck()
        mod.reroll_grids({2, 3, 4, 5, 6, 12, 14, 22, 25, 27}, true, true, true)

        --mod.scheduleForUpdate(function()
        --  local room = game:GetRoom()
        --  local len = room:GetGridSize()
        --  for i=0, len do
        --    local grid = room:GetGridEntity(i)
        --    if grid then
        --      if grid:GetType() == 14 then grid = grid:ToPoop() end
        --      local color = Color(1, 1, 1, 1, 0, 0, 0)
        --      --color:SetColorize(0, 150/255, 1, 0.5)
        --      color:SetColorize(1, 0, 0, 1)
        --
        --      grid:GetSprite().Color = color
        --      --grid:GetSprite().Rotation = 180
        --      --grid:GetSprite().Color:SetTint(1, 1, 1, 0.5)
        --    end
        --  end
				--end, 0)

        if mData.RerollsLeft ~= 0 or math.random(2) == 1 then     --50% chance to break after 4 rerolls ran out
          SFXManager():Play(268, 1, 0, false, 0.9)
          if mData.RerollsLeft > 0 then
            mData.RerollsLeft = mData.RerollsLeft - 1
            mod.d12machines[machine.InitSeed][0] = mData.RerollsLeft
          end
          mData.BombsStored = 0
          mod.d12machines[machine.InitSeed][1] = 0
        else
          mData.State = 5
          Isaac.Spawn(1000, 1, 0, machine.Position, Vector(0,0), machine)
          if math.random(5) == 1 then
            local altar
            if math.random(4) == 1 then
              altar = Isaac.Spawn(5, 100, mod.ITEM.COLLECTIBLE.ETERNAL_D12, machine.Position, Vector(0,0), machine)
            else
              altar = Isaac.Spawn(5, 100, 386, machine.Position, Vector(0,0), machine)
            end
            mod:GetEntityData(altar).D12machine = true
            machine:Remove()
          else
            machine:TakeDamage(1, DamageFlag.DAMAGE_EXPLOSION, EntityRef(machine), 1)
            sprite:Play("Broken", true)
          end
          mod.d12machines[machine.InitSeed] = nil
        end
      end
      if sprite:IsFinished("Prize") and mData.State ~= 5 then
        mData.State = 1
        sprite:Play("Idle", true)
      end
    elseif mData.State == 5 then
      if mData.Countdown == 18 then
        if game:GetRoom():SpawnGridEntity(mData.gPoop, 14, 0, 1, 0) then
          local fPoop = game:GetRoom():GetGridEntity(mData.gPoop)
          if fPoop then
            local fPoopSprite = fPoop:GetSprite()
            fPoopSprite:ReplaceSpritesheet(0, "gfx/grid/grid_poop_gold.png")
            fPoopSprite:LoadGraphics()
            fPoopSprite:Update() fPoopSprite:Update()
          end
        end
      end
      if mData.Countdown == 1 then mod.reroll_grids({2, 3, 4, 5, 6, 12, 14, 22, 25, 27}, true, true, true) end
    end
end, 880)

function mod:pickupsFromD12machine(type, var, sub, pos, vel, spawner, seed)
  if var ~= 100 then
	local machines = Isaac.FindInRadius(pos, 0.01, 0xffffffff)
	for i, machine in ipairs(machines) do
	  if machine.Type == 6 and machine.Variant == 880 then
		if mod:GetEntityData(machine).State ~= 5 then          --No bombs payout if machine was blown by explosion/shockwave
		  machine:GetSprite():Play("Broken", true)
		  mod:GetEntityData(machine).State = 6
		  return {1000, 41, 0, seed}
		else
		  if var ~= 40 then
			if math.random(3) == 1 then
			  return {5, 300, mod.ITEM.CARD.GLASS_D12, seed}
			else
			  return {5, 40, 0, seed}
			end
		  end
		end
	  end
	end
  end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, altar)
  if altar.SpawnerType == 6 and altar.SpawnerVariant == 880 then
	if mod:GetEntityData(altar).D12machine then
	  for i = 3, 5 do altar:GetSprite():ReplaceSpritesheet(i,"gfx/items/slots/slot_grid_restock_machine_pedestal.png") end
	  altar:GetSprite():LoadGraphics()
	  altar:GetSprite():SetOverlayFrame("Alternates", 1)
	else
	  altar:GetSprite():SetOverlayFrame("Alternates", 0)
	end
  end
end, 100)

--mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, function(_, player, machine, low)
--    if machine.Type == 6 and machine.Variant == 880 then
--      if mod:GetEntityData(machine).State == 1 and player:GetNumBombs() > 0 and mod:GetEntityData(machine).Countdown == 0 then
--        player:AddBombs(-1)
--        mod:GetEntityData(machine).State = 2
--      end
--    end
--end)

FiendFolio.onMachineTouch(880, function(player, slot)
  if slot.Type == 6 and slot.Variant == 880 then
	if mod:GetEntityData(slot).State == 1 and player:GetNumBombs() > 0 and mod:GetEntityData(slot).Countdown == 0 then
	  player:AddBombs(-1)
	  mod:GetEntityData(slot).State = 2
	end
  end
end)

function mod:doomFlyAI(npc)
local sprite = npc:GetSprite()
local data = mod:GetEntityData(npc)

npc:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)

	if npc:IsDead() then
		if mod:shouldDoDeathEffect(npc) then
			--Isaac.Explode(npc.Position, npc, 50)
			for _, entity in ipairs(Isaac.GetRoomEntities()) do
				if entity.Type == EntityType.ENTITY_PROJECTILE
				and entity.Variant == 0
				and	entity.SpawnerType == npc.Type
				and	entity.SpawnerVariant == npc.Variant
				and entity.FrameCount < 2 then
					entity.Variant = 1
					entity.Velocity = entity.Velocity:Resized(15)
					mod:GetEntityData(entity).projType = "boomerang"
					mod:GetEntityData(entity).origpos = npc.Position
					entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
					local s = entity:GetSprite()
					s:Load("gfx/projectiles/boomerang rib.anm2",true)
					s:Play("spin",false)
					s.Offset = Vector(0,-10)
					local proj = entity:ToProjectile()
					proj.ProjectileFlags = proj.ProjectileFlags | ProjectileFlags.NO_WALL_COLLIDE
					proj.FallingSpeed = 0
					proj.FallingAccel = -0.066
					--proj.FallingAccel = -0.068
				end
			end
		else
			for _, entity in ipairs(Isaac.GetRoomEntities()) do
				if entity.Type == EntityType.ENTITY_PROJECTILE
				and entity.Variant == 0
				and	entity.SpawnerType == npc.Type
				and	entity.SpawnerVariant == npc.Variant
				and entity.FrameCount < 2 then
					entity:Remove()
				end
			end
		end
	end

end

function mod:gbfAI(npc)
	local room = game:GetRoom()
	--[[if npc.FrameCount % 10 == 0 then
		local sparkle = Isaac.Spawn(1000, 7003, 0, npc.Position, nilvector, npc):ToEffect()
		sparkle.RenderZOffset = 10000
		sparkle:FollowParent(npc)
		sparkle.SpriteOffset = Vector(-10 + math.random(20), -30 + math.random(20))
	end]]
	--mod.sawGBF = mod.sawGBF or 0
	if npc.FrameCount % 3 == 0 then
		local sparkle = Isaac.Spawn(1000, 7003, 0, npc.Position, nilvector, npc):ToEffect()
		sparkle.RenderZOffset = -5
		sparkle.SpriteOffset = Vector(-10 + math.random(20), -30 + math.random(20))
		--sparkle.SpriteScale = Vector(0.3,0.3)
	end

	if npc:IsDead() then
		--Isaac.Explode(npc.Position, npc, 50)
		game:ShakeScreen(20)
		sfx:Play(SoundEffect.SOUND_ULTRA_GREED_COIN_DESTROY ,1.5,0,false,1)
		--Isaac.Spawn(5, 10, 7, npc.Position, RandomVector()*1, npc)
		local flash = Isaac.Spawn(1000, 7004, 0, room:GetCenterPos(), nilvector, npc):ToEffect()
		flash.RenderZOffset = 1000000
		room:TurnGold()
		for i = 1, 20 do
		Isaac.Spawn(5, 20, 0, npc.Position, RandomVector()*math.random(10,30), npc)
		end
		for _, entity in ipairs(Isaac.GetRoomEntities()) do
			if entity.Type == EntityType.ENTITY_PROJECTILE
			and entity.Variant == 0
			and	entity.SpawnerType == npc.Type
			and	entity.SpawnerVariant == npc.Variant
			and entity.FrameCount < 2 then
				entity:Remove()
			end
			if entity:IsEnemy() then
				entity:AddMidasFreeze(EntityRef(npc), 1200)
			end
		end
	end
end
function mod:gbfSparkleAI(npc)
	if npc.FrameCount > 10 then
		npc:Remove()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.gbfSparkleAI, 7003)

function mod:drainerAI(npc)
	npc.SplatColor = mod.ColorLemonYellow

	if npc.Velocity:Length() > 2.5 then
		npc.Velocity = npc.Velocity:Resized(2.5)
	end

	if npc.FrameCount % 3 == 0 then
		local creep = Isaac.Spawn(1000, 24, 0, npc.Position + Vector(10,0), nilvector, npc):ToEffect();
		creep.Scale = 0.5
		creep:SetTimeout(45)
		creep:Update();

	end

	if npc:IsDead() then
		for _, entity in ipairs(Isaac.GetRoomEntities()) do
			if entity.Type == EntityType.ENTITY_PROJECTILE
			and entity.Variant == 0
			and	entity.SpawnerType == npc.Type
			and	entity.SpawnerVariant == npc.Variant
			and entity.FrameCount < 2 then
				entity:Remove()
			end
		end

		if mod:shouldDoDeathEffect(npc) then
			local creep = Isaac.Spawn(1000, 24, 0, npc.Position + Vector(10,0), nilvector, npc):ToEffect();
			creep.SpriteScale = creep.SpriteScale * 2.5
			creep:SetTimeout(90)
			creep:Update();

			local params = ProjectileParams()
			params.Color = mod.ColorLemonYellow
			for i = 90, 360, 90 do
				npc:FireProjectiles(npc.Position, Vector(0,13):Rotated(i), 0, params)
			end
		end
	end
end

function mod:warheadAI(npc)
	npc.SplatColor = mod.ColorLemonYellow

	if npc.Velocity:Length() > 3.5 then
		npc.Velocity = npc.Velocity:Resized(3.5)
	end

	if npc:IsDead() then

		for _, entity in ipairs(Isaac.GetRoomEntities()) do
			if entity.Type == EntityType.ENTITY_PROJECTILE
			and entity.Variant == 0
			and	entity.SpawnerType == npc.Type
			and	entity.SpawnerVariant == npc.Variant
			and entity.FrameCount < 2 then
				entity:Remove()
			end
		end

		if mod:shouldDoDeathEffect(npc) then
			local params = ProjectileParams()
			params.Color = mod.ColorLemonYellow
			for i = 45, 360, 45 do
				npc:FireProjectiles(npc.Position, Vector(0,10):Rotated(i), 0, params)
			end
			local creep = Isaac.Spawn(1000, 24, 0, npc.Position, nilvector, npc):ToEffect()
			creep.SpriteScale = creep.SpriteScale * 2.5
			creep:Update()
		end
	end
end

function mod:spooterAI(npc, var)
	local room = game:GetRoom()
	local sprite = npc:GetSprite();
	local target = npc:GetPlayerTarget()
	local r = npc:GetDropRNG()
	local speed

	local litterBug
	if var == 964 or var == 965 or var == 966 or var == 967 then
		litterBug = true
	end

	if not mod:GetEntityData(npc).init then
		if mod.anyPlayerHas(CollectibleType.COLLECTIBLE_BURSTING_SACK) then
			if var == 966 then
				if not mod:isFriend(npc) then
					mod:ReplaceEnemySpritesheet(npc, "gfx/enemies/litter bug/litter_bug_charmed_burstingsack", 0)
					npc.SubType = 10
					sprite:LoadGraphics()
					npc.CollisionDamage = 0
				end
			else
				if var == 961 then
					mod:ReplaceEnemySpritesheet(npc, "gfx/enemies/spooter/monster_superspooter_burstingSack", 0)
				elseif var == 963 then
					mod:ReplaceEnemySpritesheet(npc, "gfx/enemies/spooter/monster_megaspooter_burstingSack", 0)
				elseif var == 964 then
					mod:ReplaceEnemySpritesheet(npc, "gfx/enemies/litter bug/litter_bug_burstingsack", 0)
				elseif var == 965 then
					mod:ReplaceEnemySpritesheet(npc, "gfx/enemies/litter bug/litter_bug_toxic_burstingsack", 0)
				elseif var == 967 then
					mod:ReplaceEnemySpritesheet(npc, "gfx/enemies/litter bug/litter_bug_bruising_burstingsack", 0)
				else
					mod:ReplaceEnemySpritesheet(npc,  "gfx/enemies/spooter/monster_spooter_burstingSack", 0)
				end
				sprite:LoadGraphics()
				npc.CollisionDamage = 0
				npc.SubType = 10
			end
		end
		mod:GetEntityData(npc).init = true
	end

	if var == 961 or var == 963 then
		speed = 7
	else
		speed = 5
	end

	if npc.Velocity:Length() > speed then
		npc.Velocity = npc.Velocity:Resized(speed)
	end

	if sprite:IsEventTriggered("Shoot") then
		if litterBug then
			npc:PlaySound(mod.Sounds.SniffleShootOldShort,1,0,false,math.random(70,100)/100)
			local projectile = mod:LazySpawnProjectile(0, 0, npc.Position, (target.Position - npc.Position):Resized(7), npc):ToProjectile();
			projectile.FallingSpeed = -15
			projectile.FallingAccel = 1.5
			projectile.Height = -30
			projectile.Scale = 1.5
			projectile.SpawnerEntity = npc
			if var == 965 then
				projectile.Color = mod.ColorToxicFart
				mod:GetEntityData(projectile).projType = "DangerFart"
			elseif var == 964 then
				projectile.Color = mod.ColorButterFart
				mod:GetEntityData(projectile).projType = "TrashFart"
			elseif var == 966 then
				local color = Color(1,1,1,1,235/255, 118/255, 1)
				color:SetColorize(1,1,1,1)
				projectile.Color = color
				mod:GetEntityData(projectile).projType = "CharmFart"
			elseif var == 967 then
				local color = Color(1,1,1,1,60/255, 20/255, 60/255)
				color:SetColorize(1,1,1,1)
				projectile.Color = color
				mod:GetEntityData(projectile).projType = "BruiseFart"
			end
			if mod:isFriend(npc) then
				projectile:AddProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES)
			elseif mod:isCharm(npc) then
				projectile:AddProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER)
			end
		else
			npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,1,2,false,1)
			if var == 960 or var == 963 then
				npc:FireProjectiles(npc.Position, (target.Position - npc.Position):Normalized()*7, 0, ProjectileParams())
			end
			if var == 961 or var == 963 then
				for i = 1, 2 do
					npc:FireProjectiles(npc.Position, ((target.Position - npc.Position):Normalized()*7):Rotated(-48 + i*32), 0, ProjectileParams())
				end
			end
		end
	end

	if npc.SubType ~= 10 and npc.State == 4 and r:RandomInt(20)+1 == 1 and (target.Position - npc.Position):Length() < 200 and room:CheckLine(target.Position,npc.Position,3,900,false,false) and not mod:isScareOrConfuse(npc) then
		npc.State = 8
	end

	if npc.State == 8 then
		if sprite:IsFinished("Attack") then
			npc.State = 4
		elseif not sprite:IsPlaying("Attack") then
			if target.Position.X < npc.Position.X then
				sprite.FlipX = true
			else
				sprite.FlipX = false
			end
			sprite:Play("Attack", 0)
		end
	end

	if npc:IsDead() and (var == 964 or var == 965 or var == 966 or var == 967) then
		local can = Isaac.Spawn(1000, 163, 0, npc.Position, RandomVector()*math.random(3), npc):ToEffect()
		local cSprite = can:GetSprite()
		cSprite:Load(sprite:GetFilename(),true)
		if npc.SubType == 10 then
			if var == 964 then
				cSprite:ReplaceSpritesheet(0, "gfx/enemies/litter bug/litter_bug_burstingsack.png")
			elseif var == 965 then
				cSprite:ReplaceSpritesheet(0, "gfx/enemies/litter bug/litter_bug_toxic_burstingsack.png")
			elseif var == 966 then
				cSprite:ReplaceSpritesheet(0, "gfx/enemies/litter bug/litter_bug_charmed_burstingsack.png")
			elseif var == 967 then
				cSprite:ReplaceSpritesheet(0, "gfx/enemies/litter bug/litter_bug_bruising_burstingsack.png")
			end
		end
		cSprite:LoadGraphics()
		if math.random(2) == 1 then
			cSprite.FlipX = true
		end
		cSprite:Play("Gib" .. math.random(3),true)
	end
end

function mod:stickySackAI(npc)
local sprite = npc:GetSprite();
npc.SplatColor = mod.ColorPureWhite
--Isaac.ConsoleOutput(npc.StateFrame .. "\n")
	if npc.State == 3 then
		npc.StateFrame = npc.StateFrame + 1
		if npc.MaxHitPoints == npc.HitPoints then
			if npc.StateFrame > 30 and mod.GetEntityCount(85) < 40 then
				npc.State = 8
				npc.StateFrame = 0
			end
		end
	elseif npc.State == 8 then
		if sprite:GetFrame() == 0 then
			if mod.GetEntityCount(85) > 40
			or (mod:isFriend(npc) and mod.GetFamiliarCount(FamiliarVariant.BLUE_SPIDER, mod.ITEM.FAMILIAR.BLUE_BABY_SPIDER_SUBTYPE) > 10)
			then
				npc.State = 3
				mod:spritePlay(sprite, "Shake")
			end
		end
		if sprite:GetFrame() == 10 then
			for i = 1, mod:RandomInt(2,3) do
				local aaaaaaa = mod:FindRandomValidPathPosition(npc, 3) + (RandomVector() * mod:RandomInt(0,20))
				local happyhead = aaaaaaa - npc.Position
				npc:PlaySound(mod.Sounds.Plorp, 0.9, 0, false, math.random(95,105)/100)
				EntityNPC.ThrowSpider(npc.Position,npc,npc.Position + happyhead,false,0)
			end
			for _, entity in ipairs(Isaac.GetRoomEntities()) do
				if entity.Type == 85 and entity.Variant == 0 and entity.SpawnerType == 30 and entity.SpawnerVariant == mod.FF.StickySack.Var then
					if not mod:GetEntityData(entity).CheekySpawned then
						if mod:isFriend(npc) then
							npc:TakeDamage(2, DamageFlag.DAMAGE_NOKILL, EntityRef(nil), 1)
							local spider = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_SPIDER, mod.ITEM.FAMILIAR.BLUE_BABY_SPIDER_SUBTYPE, entity.Position, Vector.Zero, nil)
							spider:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
							entity:Remove()
						else
							entity:ToNPC():Morph(85,962,0,-1)
							entity:ToNPC().HitPoints = entity:ToNPC().MaxHitPoints
							mod:GetEntityData(entity).CheekySpawned = true
						end
					end
				end
			end
		end
	end
	if npc:IsDead() then
		for i = 1, math.random(4,10) do
			mod.spawnent(npc, npc.Position, RandomVector()*math.random(20), 85, 962)
		end
	end
end

function mod:walkingStickySackAI(npc)
local sprite = npc:GetSprite();
npc.SplatColor = mod.ColorPureWhite
	--Isaac.ConsoleOutput(npc.State .. ", " .. npc.StateFrame .. "\n")
	if sprite:IsPlaying("Shoot") then
		if sprite:GetFrame() == 10 then
			for i = 1, mod:RandomInt(2,3) do
				local aaaaaaa = mod:FindRandomValidPathPosition(npc, 3) + (RandomVector() * mod:RandomInt(0,20))
				local happyhead = aaaaaaa - npc.Position
				npc:PlaySound(mod.Sounds.Plorp, 0.9, 0, false, math.random(95,105)/100)
				EntityNPC.ThrowSpider(npc.Position,npc,npc.Position + happyhead,false,0)
			end
			for _, entity in ipairs(Isaac.GetRoomEntities()) do
				if entity.Type == 85 and entity.Variant == 0 and entity.SpawnerType == 88 and (entity.SpawnerVariant == mod.FF.WalkingStickySack.Var or entity.SpawnerVariant == mod.FF.StumblingStickySack.Var) then
					if not mod:GetEntityData(entity).CheekySpawned then
						if mod:isFriend(npc) then
							local spider = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_SPIDER, mod.ITEM.FAMILIAR.BLUE_BABY_SPIDER_SUBTYPE, entity.Position, Vector.Zero, nil)
							spider:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
							entity:Remove()
						else
							entity:ToNPC():Morph(85,962,0,-1)
							entity:ToNPC().HitPoints = entity:ToNPC().MaxHitPoints
							mod:GetEntityData(entity).CheekySpawned = true
						end
					end
				end
			end
		end
	elseif npc.Variant == 961 then
		if npc.FrameCount % 15 == math.random(15) then
			if (not mod:isFriend(npc) and mod.GetEntityCount(85) < 40)
			or (mod:isFriend(npc) and mod.GetFamiliarCount(FamiliarVariant.BLUE_SPIDER, mod.ITEM.FAMILIAR.BLUE_BABY_SPIDER_SUBTYPE) < 10)
			then
				npc.State = NpcState.STATE_ATTACK
			end
		end
	end
	if npc:IsDead() then
		for i = 1, math.random(4,10) do
			mod.spawnent(npc, npc.Position, RandomVector()*math.random(20), 85, 962)
		end
	end
end

function mod:squishBabySpider(npc)
	local deatheffect = Isaac.Spawn(1000, 38, 7000, npc.Position, nilvector, npc)
	deatheffect:Update()
	--npc:BloodExplode()
	sfx:Play(SoundEffect.SOUND_DEATH_BURST_SMALL, 0.8, 0, false, 1)
	local splat = npc:MakeSplat(0.5)
	splat:GetSprite().Color = npc.SplatColor
	npc:Remove()
end

function mod:babySpiderAI(npc)
--Isaac.ConsoleOutput(npc.State .. "\n")
--npc.SplatColor = Color(4,8.5,8.5,0.2,0,40 / 255,30 / 255)
	local d = mod:GetEntityData(npc)
	if not d.init then
		npc.SplatColor = Color(0, 0, 0, 0.2, 240 / 255, 200 / 255, 100 / 255)
		npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_REWARD)

		d.init = true
	end

	if npc:HasMortalDamage() then
		mod:squishBabySpider(npc)
	end
end

function mod:checkSpiderCollision(npc1, npc2, mysteryBoolean)
	if npc1.Variant == 962 then
		--local npc2npc = npc2:ToNPC()
		if npc2.Type == 1 then
			npc2 = npc2:ToPlayer()
			if npc2:HasCollectible(CollectibleType.COLLECTIBLE_E_COLI) then
				npc1:Remove()
			end
		end
		if not npc1:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
			if (npc2.Type == 1 or npc2:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)) and npc2.Velocity:LengthSquared() > 1 then
				local d = mod:GetEntityData(npc1)
				if not (d.flickerspirited or d.eternalFlickerspirited) then
					mod:squishBabySpider(npc1)
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION , mod.checkSpiderCollision, 85)

function mod:WispBlacklist(familiar, collider)
	--Turn into a table if we add anything more to this, PLEASE
	if collider.Type == 85 and collider.Variant == 962 then
		return true
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, mod.WispBlacklist, FamiliarVariant.WISP)
mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, mod.WispBlacklist, FamiliarVariant.ITEM_WISP)


function mod:dankFattyAI_kindageneric(npc)
local sprite = npc:GetSprite();
	if sprite:IsEventTriggered("Shoot") then
		EntityNPC.ThrowSpider(npc.Position,npc,npc.Position+RandomVector()*(30+math.random(70)),false,0)
	end

	if npc.FrameCount % 10 then
		local creep = Isaac.Spawn(1000, 26, 0, npc.Position+RandomVector()*10, nilvector, npc)
		creep.SpriteScale = Vector(2, 2)
		creep:Update()
	end
end

-- SQUIDGEAI , SQUIDGE AI
function mod:dankFattyAI(npc)
local r = npc:GetDropRNG()
local sprite = npc:GetSprite();
npc.SplatColor = mod.ColorDankBlackReal
	if sprite:IsEventTriggered("Splort") then
		local params = ProjectileParams()
		local vec = RandomVector()
		for i = 120, 360, 120 do
			local projectile = mod:LazySpawnProjectile(0, 0, npc.Position, vec:Rotated(i), npc):ToProjectile()
			local projdata = mod:GetEntityData(projectile);
			projectile.FallingSpeed = -35 + math.random(10)
			projectile.FallingAccel = math.random(7,13)/5;
			projectile.Velocity = projectile.Velocity:Normalized() * math.random(5, 8)
			projectile.Scale = 2
			projectile.Color = mod.ColorDankBlackReal
			projdata.projType = "dank slime"
			sfx:Play(SoundEffect.SOUND_FART)
			local effect = Isaac.Spawn(1000,16,4,npc.Position,Vector.Zero,npc)
			effect.Color = mod.ColorDankBlackReal
			effect.SpriteScale = effect.SpriteScale * 0.8
		end
	end

	if npc:IsDead() and mod:shouldDoDeathEffect(npc) then
		--EntityNPC.ThrowSpider(npc.Position,npc,npc.Position+RandomVector()*(30+math.random(70)),false,0) --Not really needed?
		local creep = Isaac.Spawn(1000, 26, 0, npc.Position+RandomVector()*10, nilvector, npc)
		creep.SpriteScale = Vector(2, 2);
		creep:Update()
	end
end

--Tar Bubble AI, TarBubbleAI
function mod.dankSlimeInit(npc)
	if npc.SubType == 1 then
		npc.SplatColor = mod.ColorPureWhite
	elseif npc.SubType == 8 then
		npc.SplatColor = mod.ColorMysteriousLiquid
	elseif npc.SubType == 9 then
		npc.SplatColor = mod.ColorPeepPiss
	elseif npc.SubType == 10 then
		npc.SplatColor = mod.ColorPoop
	else
		npc.SplatColor = mod.ColorDankBlackReal
	end

	npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
end

function mod:dankSlimeAI(npc, subType)
	local room = game:GetRoom()
	local pos = npc.Position
	local sprite = npc:GetSprite()
	local d = mod:GetEntityData(npc)

	local creepvar = 26

	if subType == 1 then
		creepvar = 25
	elseif subType == 8 then
		creepvar = 23
	elseif subType == 9 then
		creepvar = 24
	elseif subType == 10 then
		creepvar = 94
	end

	npc.Velocity = nilvector

	if d.bounced then
		if sprite:IsFinished("Boing") then
			d.bounced = nil
		else
			mod:spritePlay(sprite, "Boing")
		end
	else
		mod:spritePlay(sprite, "Idle")
	end

	if d.GishleTarget then
		if not mod:superExists(d.GishleTarget) or not mod:GetEntityData(d.GishleTarget).tramp or mod:GetEntityData(d.GishleTarget).tramp.InitSeed ~= npc.InitSeed then
			d.GishleTarget = nil
		end
	end

	if npc.FrameCount % 60 == 1 or npc.FrameCount == 0 then
		local creep = Isaac.Spawn(1000, creepvar, 0, npc.Position, nilvector, npc):ToEffect()
		creep.SpriteScale = Vector(2, 2);
		creep:Update()
		creep:SetTimeout(280)
	end

	if (pos:Distance(npc:GetPlayerTarget().Position) < 28 and not (d.flickerspirited or d.eternalFlickerspirited)) or (room:IsClear() and not mod.FindDoorShutter()) then
		vec1 = RandomVector()*5
		for i = 60, 360, 60 do
			local creep = Isaac.Spawn(1000, creepvar, 0, npc.Position+vec1:Rotated(i), nilvector, npc):ToEffect()
			creep.SpriteScale = Vector(2, 2);
			creep:Update()
		end
		vec2 = Vector(25,0):Rotated(math.random(2)*45)
		for i = 90, 360, 90 do
			for k = 1, 3 do
				local creep = Isaac.Spawn(1000, creepvar, 0, npc.Position + vec2:Rotated(i)*k, nilvector, npc):ToEffect()
				creep:Update()
			end
		end
		npc:Kill()
	end
end

mod.MommyTable = {0,0,0,0,0,0,2,2,3}

--Mouthful
function mod:morselMommyAI(npc, sprite)
	local r = npc:GetDropRNG()
	local target = npc:GetPlayerTarget()

	--Isaac.ConsoleOutput(npc.StateFrame .. "\n")
	if sprite:IsEventTriggered("Shoot") then
		--mod.spawnent(npc, npc.Position + Vector(0,1), nilvector, mod.FF.Morsel.ID, mod.FF.Morsel.Var)
		local randyfun = r:RandomInt(#mod.MommyTable)+1
		local baby = Isaac.Spawn(mod.FF.Morsel.ID, mod.FF.Morsel.Var, mod.MommyTable[randyfun], npc.Position + Vector(0,-5), nilvector, npc);
		baby.SpawnerEntity = npc
		mod:GetEntityData(baby).UglyBaby = true
	end

	if npc.State == 4 then
		if npc.StateFrame > 0 then
			local targdist = npc.Position:Distance(target.Position)
			--Isaac.DebugString(targdist)
			local ranval = math.ceil(targdist / 3)
			if targdist < 120 and r:RandomInt(ranval) == 0 and not mod:isScareOrConfuse(npc) then
				npc.State = 8
				if npc.Velocity.X > npc.Velocity.Y then
					mod:spritePlay(sprite, "AttackHori")
				else
					mod:spritePlay(sprite, "AttackVert")
				end
			end
		end
	end

	if npc:IsDead() and mod:shouldDoDeathEffect(npc) then
		local baby = Isaac.Spawn(mod.FF.Morsel.ID, mod.FF.Morsel.Var, r:RandomInt(3)+3, npc.Position, nilvector, npc);
		baby.SpawnerEntity = npc
		mod:GetEntityData(baby).UglyBaby = true
	end
end

function mod:bigSmokeAI(npc, sprite)
	npc.SplatColor = mod.ColorCharred

	if sprite:IsEventTriggered("Shoot") then
		local vec = (RandomVector()*20)
		for i = 1, 6 do
			mod.SpawnGunpowder(npc,npc.Position + vec:Rotated(360/6 * i - 15 + math.random(30)):Resized(math.random(25,40)), 300, 150)
		end
	end

	if npc:IsDead() and mod:shouldDoDeathEffect(npc) then
		local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, npc.Position, nilvector, npc)
		smoke.SpriteScale = Vector(3,3)
		smoke.SpriteOffset = Vector(0, -25)
		smoke:Update()
		local vec = (RandomVector()*20)
		for i = 1, 6 do
			mod.SpawnGunpowder(npc,npc.Position + vec:Rotated(360/6 * i - 15 + math.random(30)):Resized(math.random(15,30)), 300, 150)
		end
		for i = 1, 8 do
			mod.SpawnGunpowder(npc,npc.Position + vec:Rotated(360/8 * i - 15 + math.random(30)):Resized(math.random(35,60)), 300, 150)
		end
	end
end

--Bubble Bat, BubbleBat, BubbleBatAI
function mod:drownedFatBatAI(npc)
	local sprite = npc:GetSprite()
	local target = npc:GetPlayerTarget()
	local r = npc:GetDropRNG()
	local d = mod:GetEntityData(npc)

	if sprite:IsFinished("Shooting") then
		npc.State = 4
	elseif sprite:IsPlaying("Shooting") then
		npc.State = 9
	end

	if sprite:IsPlaying("Shooting") and sprite:GetFrame() < 1 then
		npc.ProjectileCooldown = 225
	end

	if npc.State == 11 then
		d.falling = true
		npc.Velocity = nilvector
		if sprite:IsFinished("Death") then
			npc:Remove()
		elseif not sprite:IsPlaying("Death") then
			sprite:Play("Death", true)
		end
	else
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		d.bleeding = false
	end

	if sprite:IsEventTriggered("Bubble") then
		npc:PlaySound(SoundEffect.SOUND_SHAKEY_KID_ROAR,1,0,false,1)
		local vec = (target.Position - npc.Position):Normalized()
		for i = 1, 5 do
		local rand = r:RandomInt(#mod.bubbles)+1
		mod.ShootBubble(npc, -1, npc.Position+vec:Rotated(-7.5+i*2.5)*5, vec:Rotated(-7.5+i*2.5)*(math.random(55,75)/20))
		end
	elseif sprite:IsEventTriggered("SFX") then
		mod:DestroyNearbyGrid(npc)
		npc:PlaySound(mod.Sounds.SplashLarge,1.5,0,false,1)
	elseif sprite:IsEventTriggered("Splash") then
		local params = ProjectileParams()
		for i = 30, 360, 30 do
			local rand = r:RandomFloat()
			params.FallingSpeedModifier = -50 + math.random(10);
			params.FallingAccelModifier = 2
			params.VelocityMulti = math.random(13,19) / 10
			--params.Color = Color(0.4,0.4,0.4,1,0,0,0)
			params.Variant = 4
			npc:FireProjectiles(npc.Position, Vector(0,2):Rotated(i-40+rand*80) + nilvector, 0, params)
		end
	elseif sprite:IsEventTriggered("bloodstart") then
		d.bleeding = true
		npc:PlaySound(SoundEffect.SOUND_DEATH_BURST_SMALL,1,0,false,1)
	elseif sprite:IsEventTriggered("bloodend") then
		d.bleeding = false
	end

	if d.bleeding then
		if npc.FrameCount % 2 == 0 then
		local blood = Isaac.Spawn(1000, 5, 0, npc.Position, RandomVector()*3, npc):ToEffect();
		blood:Update()

		local bloo2 = Isaac.Spawn(1000, 2, 0, npc.Position, RandomVector()*3, npc):ToEffect();
		bloo2.SpriteScale = Vector(0.7,0.7)
		bloo2.SpriteOffset = Vector(0, -20)
		bloo2:Update()

		npc:PlaySound(SoundEffect.SOUND_MEAT_JUMPS,0.2,0,false,0.8)
		end
	end

	if npc:IsDead() and not d.falling and mod:shouldDoDeathEffect(npc) then
		local params = ProjectileParams()
		for i = 30, 360, 30 do
			local rand = r:RandomFloat()
			params.FallingSpeedModifier = -50 + math.random(10);
			params.FallingAccelModifier = 2
			params.VelocityMulti = math.random(13,19) / 10
			--params.Color = Color(0.4,0.4,0.4,1,0,0,0)
			params.Variant = 4
			npc:FireProjectiles(npc.Position, Vector(0,2):Rotated(i-40+rand*80) + nilvector, 0, params)
		end
	end

end

function mod:DrownedFatHurt(npc, damage, flag)
	if npc.Variant == mod.FF.BubbleBat.Var then
		--if npc.HitPoints - damage <= 10 then
		if npc.HitPoints - damage <= 0 then
			if flag & DamageFlag.DAMAGE_EXPLOSION ~= 0 then
				--npc:Kill()
				mod:GetEntityData(npc).BubbleBatKilledByExplosion = true
			end
		end

		if npc:ToNPC().State == 11 then
			return false
		end
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.DrownedFatHurt, 258)

function mod.drownedFatDeathAnim(npc)
	local data = mod:GetEntityData(npc)
	if not data.BubbleBatKilledByExplosion then
		local onCustomDeath = function(npc, deathAnim)
			deathAnim.State = 11
			mod:GetEntityData(deathAnim).bleeding = mod:GetEntityData(npc).bleeding
			deathAnim.PositionOffset = npc.PositionOffset
		end
		mod.genericCustomDeathAnim(npc, nil, nil, onCustomDeath)
	end
end

local friendlyBubbleAnm2 = {
	[0] = "gfx/projectiles/bubble/bubble_tiny_friendly.anm2",
	[1] = "gfx/projectiles/bubble/bubble_small_friendly.anm2",
	[2] = "gfx/projectiles/bubble/bubble_medium_friendly.anm2",
	[3] = "gfx/projectiles/bubble/bubble_large_friendly.anm2",
}

mod.OnBubblePop = {
	[4] = function(npc)
		--mod.cheekyspawn(npc.Position, npc, npc.Position+RandomVector()*(30+math.random(70)), 18, 0, 0)
		mod.spawnent(npc, npc.Position, nilvector, 18)
		return 1, 1
	end,
	[5] = function(npc)
		--mod.cheekyspawn(npc.Position, npc, npc.Position+RandomVector()*(30+math.random(70)), 85, 0, 0)
		EntityNPC.ThrowSpider(npc.Position,npc,npc.Position+RandomVector()*(30+math.random(70)),false,0);
		return 1, 1
	end,
	[6] = function(npc)
		Isaac.Explode(npc.Position, npc, 10)
	end,
	[7] = function(npc, d)
		local params = ProjectileParams()
		params.Variant = 4
		local vel = 7
		if d.DelugeBuffed then
			vel = 8
			params.FallingSpeedModifier = 0
		end
		npc:FireProjectiles(npc.Position, (npc:GetPlayerTarget().Position - npc.Position):Resized(vel), 0, params)
	end,
	[8] = function(npc)
		local params = ProjectileParams()
		params.Variant = 4
		local vec = Vector(7,0)
		for i = 90, 360, 90 do
			npc:FireProjectiles(npc.Position, vec:Rotated(i), 0, params)
		end
	end,
	[9] = function(npc)
		local params = ProjectileParams()
		params.Variant = 4
		local vec = Vector(7,0)
		for i = 45, 360, 45 do
			npc:FireProjectiles(npc.Position, vec:Rotated(i), 0, params)
		end
	end,
	[10] = function(npc)
		local isopoly = Isaac.Spawn(mod.FF.RolyPoly.ID, mod.FF.RolyPoly.Var, 2, npc.Position, Vector.Zero, npc):ToNPC()
		mod:GetEntityData(isopoly).spawnedFromBubble = true
		--isopoly.PositionOffset = Vector(0, -30)
		isopoly:Update()
		return 1, 1
	end,
	[11] = function(npc)
		local poof = Isaac.Spawn(1000, EffectVariant.POOF02, 5, npc.Position, Vector.Zero, npc):ToEffect()
		poof.SpriteOffset = Vector(0, -12)
		poof.Color = Color(0, 0.7, 1, 0.8, 0.1, 0.2, 0.6)
		poof.SpriteScale = Vector(0.88, 1)
		poof:Update()

		for _,bub in ipairs(Isaac.FindByType(mod.FF.Bubble.ID, mod.FF.Bubble.Var, -1, false, false)) do
			if not bub:HasMortalDamage() and bub.Position:Distance(npc.Position) < 100 then
				mod.scheduleForUpdate(function()
					bub:TakeDamage(1, 0, EntityRef(npc), 0)
				end, 3)
			end
		end

		for i = 1, game:GetNumPlayers() do
			local player = Isaac.GetPlayer(i - 1)
			if not player:HasCollectible(CollectibleType.COLLECTIBLE_EVIL_EYE) and player.Position:Distance(npc.Position) < 100 then
				mod:AddFloodedToPlayer(player, 300, 1, delugeVer)
			end
		end
	end,
	[12] = function(npc, d)
		local targetPos = d.TargetPos
		if (targetPos == nil or d.PoppedByDamage) and npc.Target and npc.Target:Exists() then
			targetPos = npc.Target.Position
		end
		if targetPos then
			local params = ProjectileParams()
			params.Variant = 0
			params.Color = FiendFolio.ColorLeperRed
			params.FallingAccelModifier = -0.025
			npc:FireProjectiles(npc.Position, (targetPos - npc.Position):Resized(9), 0, params)
		end
	end,
	[14] = function(npc, d)
		local targetPos = d.TargetPos
		if (targetPos == nil or d.PoppedByDamage) and npc.Target and npc.Target:Exists() then
			targetPos = npc.Target.Position
		end
		if targetPos then
			local params = ProjectileParams()
			params.Variant = 0
			params.Color = FiendFolio.ColorLeperRed
			params.FallingAccelModifier = -0.025
			if d.PoppedByDamage then
				params.Scale = 1.675
			end

			local vec = (targetPos - npc.Position):Resized(9)
			npc:FireProjectiles(npc.Position, vec:Rotated(0), 0, params)
			if not d.PoppedByDamage then
				npc:FireProjectiles(npc.Position, vec:Rotated(160), 0, params)
				npc:FireProjectiles(npc.Position, vec:Rotated(200), 0, params)
			end
		end
	end,
	[15] = function(npc, d)
		local params = ProjectileParams()
		params.Variant = 0
		--params.Color = FiendFolio.ColorLeperRed

		local vec
		if d.Direction == Direction.UP or d.Direction == Direction.DOWN then
			vec = Vector(0,7.5)
		else
			vec = Vector(7.5,0)
		end

		local pos = npc.Position
		npc:FireProjectiles(pos, vec:Rotated(-115), 0, params)
		npc:FireProjectiles(pos, vec:Rotated(-90), 0, params)
		npc:FireProjectiles(pos, vec:Rotated(-65), 0, params)
		npc:FireProjectiles(pos, vec:Rotated(65), 0, params)
		npc:FireProjectiles(pos, vec:Rotated(90), 0, params)
		npc:FireProjectiles(pos, vec:Rotated(115), 0, params)
	end,
	[16] = function(npc, d, sprite)
		if d.PoppedByDamage or d.PoppedByBubble then
			local targetPos
			if npc.Target and npc.Target:Exists() then
				targetPos = npc.Target.Position
			end
			if targetPos then
				local params = ProjectileParams()
				params.Variant = 0
				params.Color = FiendFolio.ColorLeperRed
				params.Scale = 2.55

				local projs = npc:FireProjectilesEx(npc.Position, (targetPos - npc.Position):Resized(0.1), 0, params)
				for _, proj in ipairs(projs) do
					mod:GetEntityData(proj).BabyBubblesProvidence = true
					proj.FallingSpeed = 0
					proj.FallingAccel = -0.1
				end
			end

			if d.PoppedByDamage then
				local bubbles = Isaac.FindByType(mod.FF.Bubble.ID, mod.FF.Bubble.Var)
				for _, bubble in ipairs(bubbles) do
					if bubble.SubType ~= 17 and (bubble.Position - npc.Position):Length() <= 130 then
						local bdata = mod:GetEntityData(bubble)
						if not bdata.IsPopping then
							local bubble = bubble:ToNPC()
							bubble.Velocity = nilvector
							bubble.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
							bubble.HitPoints = 0
							bdata.IsPopping = true
							bdata.PoppedByBubble = true
							bubble.State = 11

							local bsprite = bubble:GetSprite()
							bsprite:Play("pop", true)
							bsprite:SetFrame(sprite:GetFrame())

							local volume, pitch
							local popfunc = mod.OnBubblePop[bubble.SubType]
							if popfunc then
								volume, pitch = popfunc(bubble, bdata, bsprite)
							end
							bubble:PlaySound(SoundEffect.SOUND_PLOP, volume or 0.7, 2, false, pitch or math.random(8,12)/10)
						end
					end
				end

				local bloodCloud = Isaac.Spawn(1000, 16, 3, npc.Position, nilvector, npc)
				bloodCloud:Update()
				local bloodCloud2 = Isaac.Spawn(1000, 16, 4, npc.Position, nilvector, npc)
				bloodCloud2:Update()
			end
		end
	end,
	[17] = function(npc, d)
		local src = d.LaserSource
		if src == nil or not src:Exists() then
			src = npc
		end
        local swirl = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ENEMY_BRIMSTONE_SWIRL, 0, npc.Position, nilvector, src)
        swirl.Parent = src
		swirl.PositionOffset = npc.PositionOffset + Vector(0,-12.25)

		for i = 90, 360, 90 do
			local tracer = Isaac.Spawn(1000, 181, 0, npc.Position + Vector(0,10):Rotated(i), nilvector, npc):ToEffect()
			tracer.SpriteRotation = i
			tracer.SpriteScale = Vector(0.5,1)
			tracer.Parent = swirl
			mod:GetEntityData(tracer).PleaseDontBreakTheBeastFightAgainPrettyPlease = true
			tracer:Update()
			tracer.Color = Color(0,0,0,0.5,1,0.2,0.2)
			tracer:SetColor(Color(0,0,0,0,1,0.2,0.2), 10, 0, true, false)
		end

		if npc.FrameCount - (d.LastBulletFrame or -5) >= 5 then
			local params = ProjectileParams()
			params.Variant = 0
			params.FallingAccelModifier = -0.1

			local vec = Vector(9, 0)
			for i = 18, 342, 36 do
				local rotvec = vec:Rotated(i)
				npc:FireProjectiles(npc.Position + rotvec, rotvec, 0, params)
			end
		end

		return 1, 0.66, 0, FiendFolio.Sounds.BabyBubblesSpawnBubbleLong
	end,
}

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, tracer)
	local d = mod:GetEntityData(tracer)
	if d.PleaseDontBreakTheBeastFightAgainPrettyPlease then
		if not (tracer.Parent and not tracer.Parent:GetSprite():WasEventTriggered("Shoot")) then
			d.StartFadingOut = true
		end

		local s = tracer:GetSprite()
		if d.StartFadingOut then
			if s:IsFinished("Disappear") then
				tracer:Remove()
			elseif not s:IsPlaying("Disappear") then
				s:Play("Disappear", true)
			end
		else
			if not s:IsPlaying("Idle") then
				s:Play("Idle", true)
			end
		end
	end
end, EffectVariant.LAVA_SPAWNER)

local cachedFullyClearedRoom = false
function mod:bubbleAI(npc, variant)
	local subt = npc.SubType
	local d = mod:GetEntityData(npc)

	npc.SpriteOffset = npc.SpriteOffset * 0.95

	if subt == 17 then
		if npc.Parent and not npc.Parent:IsDead() then
			npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
			npc.Velocity = nilvector
			mod:inflateDecayBubble(npc, d)

			local psprite = npc.Parent:GetSprite()
			local pspritescale = npc.Parent.SpriteScale
			local pspritesize = psprite:GetLayer(0):GetSize()
			local panimscale = psprite:GetCurrentAnimationData():GetLayer(0):GetFrame(psprite:GetFrame()):GetScale()

			local xPos = d.DecayScale * 13.5 + 16 * pspritescale.X * pspritesize.X * panimscale.X
			if d.IsLeft then
				xPos = xPos * -1
			end
			npc.Position = npc.Parent.Position + Vector(xPos, 1)

			local yPos = d.DecayScale * 12.5 + -14 * pspritescale.Y * pspritesize.Y * panimscale.Y - 1
			npc.PositionOffset = Vector(0, yPos)
		elseif not d.IsPopping then
			npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
			npc.PositionOffset = npc.PositionOffset * 0.95

			d.DecayScale = (d.DecayScale or 3) - 0.011
			if npc.FrameCount % 6 == 0 then
				local bubble = Isaac.Spawn(mod.FF.BubbleStream.ID, mod.FF.BubbleStream.Var, mod.FF.BubbleStream.Sub, npc.Position, Vector(0.33,0):Rotated(math.random() * 360), npc)
				bubble:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				if mod:isFriend(npc) then
					bubble:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
				end
				local bdata = mod:GetEntityData(bubble)
				bdata.Timeout = 60 + math.floor(15 * math.random() + 0.5)
				bdata.volumemult = 0.5
				bubble:Update()
			end
			if d.DecayScale <= 1 then
				d.DecayScale = 1
				d.Timeout = nil
				d.IsPopping = true
				npc.State = 11
			end

			npc.Velocity = npc.Velocity:Resized(math.max(npc.Velocity:Length(), 6))
		end

		npc.SizeMulti = Vector(d.DecayScale,d.DecayScale)
		mod:setBubbleToScale(npc)
	end

	if d.IsPopping then
		local sprite = npc:GetSprite()
		if sprite:IsEventTriggered("popsound") then
			local volume, pitch, framedelay, fx
			local popfunc = mod.OnBubblePop[subt]
			if popfunc then
				volume, pitch, framedelay, fx = popfunc(npc, d, sprite)
			end
			npc:PlaySound(fx or SoundEffect.SOUND_PLOP, (volume or 0.7) * (d.volumemult or 1), framedelay or 2, false, pitch or math.random(8,12)/10)

			if d.PoppedByDamage and not d.PopHasBeenTracked and mod.CanRunUnlockAchievements() then
				FiendFolio.savedata.bubblesPopped = (FiendFolio.savedata.bubblesPopped or 0) + 1
				if FiendFolio.savedata.bubblesPopped >= 50 and not FiendFolio.ACHIEVEMENT.DIRTY_BUBBLE:IsUnlocked(true) then
					FiendFolio.ACHIEVEMENT.DIRTY_BUBBLE:Unlock()
				end
				d.PopHasBeenTracked = true
			end
		end

		if sprite:IsFinished("pop") then
			if Isaac.GetChallenge() == mod.challenges.dirtyBubble then
				mod.bubbleKillCounter = mod.bubbleKillCounter or 0
				mod.bubbleKillCounter = mod.bubbleKillCounter + 1
				--print(mod.bubbleKillCounter)
			end
			npc:Remove()
		elseif not sprite:IsPlaying("pop") then
			sprite:Play("pop", true)
		end

		npc.Velocity = nilvector
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		npc.State = 11
	else
		local isFriend = mod:isFriend(npc)
		local collidesWithGrid = npc:CollidesWithGrid()
		local vel = npc.Velocity

		if not d.init then
			local sprite = npc:GetSprite()
			if isFriend then
				npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
			else
				npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			end
			npc.SplatColor = mod.ColorInvisible
			npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET)
			if d.spawning then
				sprite:Play("Spawn")
			else
				sprite:Play("Idle")
			end
			--[[if vel:Length() < 1 then
				vel = Vector(10,0)
			end]]
			d.init = true
		end

		if d.spawning then
			local sprite = npc:GetSprite()
			if sprite:IsEventTriggered("release") then
				if d.BabyBubblesSpawning then
					d.BabyBubblesSpawning = nil
				else
					vel = RandomVector()*(0.5 + math.random()*2.5)
				end
			end

			if sprite:IsFinished("Spawn") then
				if d.DelugeSpawning then
					npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
				end
				sprite:Play("Idle")
				d.spawning = nil
			end

			if d.BabyBubblesSpawning then
				d.BabyBubblesSpawning = d.BabyBubblesSpawning - 1
			end
		end

		if d.DelugeDontKillYet and npc.FrameCount > 40 then
			d.DelugeDontKillYet = nil
		end

		if isFriend then
			if friendlyBubbleAnm2[subt] and not d.LoadedFriendlyBubbleAnm2 then
				local sprite = npc:GetSprite()
				local anim = sprite:GetAnimation()
				local frame = sprite:GetFrame()
				sprite:Load(friendlyBubbleAnm2[subt], true)
				sprite:Play(anim)
				sprite:SetFrame(frame)
				d.LoadedFriendlyBubbleAnm2 = true
			end

			if npc.FrameCount > 1 then
				local pos = npc.Position
				for _, p in pairs(Isaac.FindByType(9, -1, -1)) do
					if not p:ToProjectile():HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER)
							and p.Position:Distance(pos) <= npc.Size + p.Size then
						d.IsPopping = true
						npc.State = 11
						p:Die()
					end
				end
			end
		end

		if subt == 13 or subt == 15 then
			if d.AccelMult then
				vel = vel * d.AccelMult
			end
			if d.StreamPos then
				d.StreamPosFrames = (d.StreamPosFrames or 0) + 1
				if d.StreamPosFrames > d.StreamPosMaxFrames then
					d.StreamPos = nil
					vel = nilvector
				else
					local pos = npc.Position
					vel = mod:Lerp(pos, d.StreamPos, d.StreamPosLerp) - pos
				end

				if subt == 15 and d.StreamPosFrames >= d.StreamPosPopFrame then
					d.Timeout = nil
					d.IsPopping = true
					npc.State = 11
					npc.Velocity = vel
					return
				end
			end
			if collidesWithGrid then
				d.Timeout = nil
				d.IsPopping = true
				npc.State = 11
				npc.Velocity = vel
				return
			end
		elseif subt == 16 then
			d.ProvidenceAccel = d.ProvidenceAccel + d.ProvidenceAccelAccel
			d.ProvidenceSpeed = math.min(d.ProvidenceSpeed + d.ProvidenceAccel, d.ProvidenceMaxSpeed)

			vel = Vector(0, d.ProvidenceSpeed)
			if d.ProvidenceDirection == Direction.UP then
				vel = vel * -1
			end

			if not d.HasLeftWall then
				npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
				local room = game:GetRoom()
				local topleftcoll = room:GetGridCollisionAtPos(npc.Position + Vector(-29,-30))
				local toprightcoll = room:GetGridCollisionAtPos(npc.Position + Vector(29,-30))
				local bottomleftcoll = room:GetGridCollisionAtPos(npc.Position + Vector(-29,30))
				local bottomrightcoll = room:GetGridCollisionAtPos(npc.Position + Vector(29,30))
				if topleftcoll == GridCollisionClass.COLLISION_WALL or topleftcoll == GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER or
				   toprightcoll == GridCollisionClass.COLLISION_WALL or toprightcoll == GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER or
				   bottomleftcoll == GridCollisionClass.COLLISION_WALL or bottomleftcoll == GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER or
				   bottomrightcoll == GridCollisionClass.COLLISION_WALL or bottomrightcoll == GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
				then
					d.HasTouchedWall = true
				elseif d.HasTouchedWall then
					npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
					d.HasLeftWall = true
				end
			else
				if collidesWithGrid then
					d.Timeout = nil
					d.IsPopping = true
					npc.State = 11
					npc.Velocity = vel
					return
				end
			end
		else
			if vel:Length() > 5 then
				vel = vel:Rotated(-5 + math.random(9)) * 0.96
			else
				vel = vel:Rotated(-5 + math.random(9)) * 0.995
			end
			if collidesWithGrid then
				if subt == 17 then
					if npc.FrameCount - (d.LastBulletFrame or -10) >= 10 then
						local params = ProjectileParams()
						params.Variant = 0
						params.FallingAccelModifier = -0.1

						local vec = Vector(9, 0)
						for i = 15, 345, 30 do
							local rotvec = vec:Rotated(i)
							npc:FireProjectiles(npc.Position + rotvec, rotvec, 0, params)
						end

						sfx:Play(FiendFolio.Sounds.BabyBubblesBubbleBounce, 0.8, 2, false, 0.5)
						d.LastBulletFrame = npc.FrameCount
					end

					vel = mod.bounceOffWallLegacy(npc.Position, vel, d.PrevVel or vel)
				else
					vel = mod.bounceOffWall(npc.Position, vel, d.PrevVel or vel)
				end
			end
			d.PrevVel = vel
		end

		npc.Velocity = vel

		if d.Timeout then
			d.Timeout = math.max(d.Timeout - 1, 0)
			if d.Timeout <= 0 then
				d.Timeout = nil
				d.IsPopping = true
				npc.State = 11
				return
			end
		end

		if cachedFullyClearedRoom and game:GetRoom():GetFrameCount() > 0 then
			d.IsPopping = true
			npc.State = 11
			return
		end
	end
end

function mod:CacheFullyClearedRoom()
	cachedFullyClearedRoom = not (mod.IsActiveRoom() or mod.FindDoorShutterCached())
end
mod:AddPriorityEntityCallback(ModCallbacks.MC_POST_UPDATE, CallbackPriority.LATE,
                              mod.FF.Bubble.ID, mod.FF.Bubble.Var, -1, mod.CacheFullyClearedRoom)
mod:AddEntityCallback(ModCallbacks.MC_POST_NEW_ROOM,
                      mod.FF.Bubble.ID, mod.FF.Bubble.Var, -1, mod.CacheFullyClearedRoom)

function mod:technicalHurt(npc, damage, flags, source)
local r = npc:GetDropRNG()
	if npc.Variant == 1 then
		local d = mod:GetEntityData(npc)
		if npc.SubType == 17 then
			return false
		elseif d.DelugeDontKillYet and source and source.Type == mod.FF.Deluge.ID and source.Variant == mod.FF.Deluge.Var then
			return false
		elseif mod:shouldDoDeathAnimation(npc) then
			if npc.HitPoints - damage <= 0 then
				if npc.SubType == mod.FF.BubbleLeper.Sub or npc.SubType == mod.FF.BubbleLargeLeper.Sub or npc.SubType == mod.FF.BubbleProvidence.Sub then
					if source.Type == EntityType.ENTITY_FAMILIAR then
						return false
					end
				end
				npc.Velocity = nilvector
				npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				npc.HitPoints = 0
				d.IsPopping = true
				d.PoppedByDamage = true
				npc:ToNPC().State = 11
				return false
			end
		end
	elseif npc.Variant == 2 then
		if mod:GetEntityData(npc).DelugeDontKillYet and source and source.Type == mod.FF.Deluge.ID and source.Variant == mod.FF.Deluge.Var then
			return false
		elseif mod:shouldDoDeathAnimation(npc) then
			if npc.HitPoints - damage <= 0 then
				npc.Velocity = nilvector
				npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				npc.HitPoints = 0
				npc:ToNPC().State = 11
				return false
			end
		end
	elseif npc.Variant == 13 then
		return false
	elseif npc.Variant == 14 then
		if mod:shouldDoDeathAnimation(npc) then
			if npc.HitPoints - damage <= 5 then
			npc.Velocity = nilvector
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			npc.HitPoints = 0
			npc:ToNPC().State = 11
			return false
			end
		end
	elseif npc.Variant == 17 or npc.Variant == 31 or npc.Variant == 32 then
		return false
	elseif variant == mod.FF.HitcherPitchfork.Var then
		if mod:HasDamageFlag(DamageFlag.DAMAGE_FIRE, damageFlags) and not mod:IsPlayerDamage(source) then
			return false
		end
	elseif npc.Variant == 0 then
		local subT = npc.SubType
		local d = mod:GetEntityData(npc)
		if not (d.flickerspirited or d.eternalFlickerspirited) then
			if subT == 1 then
				for i = 1, math.random(4,10) do
					mod.spawnent(npc, npc.Position, RandomVector()*math.random(20), 85, 962)
				end
			else
				for i = 30, 360, 30 do
				local rand = r:RandomFloat()
				local projectile = mod:LazySpawnProjectile(npc.SubType == 10 and 3 or 0, 0, npc.Position, Vector(0,2):Rotated(i-40+rand*80), npc):ToProjectile();
					local projdata = mod:GetEntityData(projectile);
					projectile.FallingSpeed = -50 + math.random(10);
					projectile.FallingAccel = 2
					projectile.Velocity = projectile.Velocity * (math.random(12, 20)/10)
					projectile.Scale = math.random(8, 12)/10
					projectile.Color = (projectile.Variant == 3) and projectile.Color or (npc.SplatColor or mod.ColorDankBlackReal)
					--I honestly dont understand what the point of the line above is and its making issues so im sticking this here
					if npc.SubType == 0 then
						projectile.Color = mod.ColorDankBlackReal
					end
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.technicalHurt, mod.FFID.Tech)

function mod:ribboneAI(npc)
	local d = mod:GetEntityData(npc)
	local sprite = npc:GetSprite();
	local remains
	if not npc:HasEntityFlags(EntityFlag.FLAG_CHARM | EntityFlag.FLAG_FRIENDLY) then
		remains = mod.FindClosestEntity(npc.Position, 99999, mod.FF.JawboneCorpse.ID, mod.FF.JawboneCorpse.Var)
	end
	--npc.SplatColor = Color(0.15, 0, 0, 1, 25 / 255, 25 / 255, 25 / 255)
	npc:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
	if not d.init then
		d.init = true
	end
	if remains and npc.StateFrame > 15 and not mod:isScareOrConfuse(npc) then
		npc.State = 6
		if remains.Position:Distance(npc.Position) > 40 and not sprite:IsPlaying("Summon") then
			if d.state == "dashstart" then
				if sprite:IsFinished("DashStart") then
					d.state = "dash"
				else
					mod:spritePlay(sprite, "DashStart")
				end
			elseif d.state == "dash" then
				mod:spritePlay(sprite, "Dash")
				local targetvel = (remains.Position - npc.Position):Resized(6)
				npc.Velocity = mod:Lerp(npc.Velocity, targetvel,0.25)
			end
		else
			if sprite:IsFinished("Summon") then
				d.state = "dashstart"
				npc.StateFrame = 0
			elseif sprite:IsEventTriggered("Shoot") then
				npc:PlaySound(SoundEffect.SOUND_SUMMONSOUND,1,1,false,1)
				for _, entity in ipairs(Isaac.GetRoomEntities()) do
					if entity.Type == mod.FF.JawboneCorpse.ID and entity.Variant == mod.FF.JawboneCorpse.Var then
						if entity.Position:Distance(npc.Position) < 75 then
							entity:ToNPC().State = 5
							--entity:Update()
						end
					end
				end
			else
				mod:spritePlay(sprite, "Summon")
			end
		end
	elseif not sprite:IsPlaying("Summon") then
		npc.State = 4
		npc.StateFrame = npc.StateFrame + 1
		mod:spritePlay(sprite, "Idle")
		d.state = "dashstart"
	end
end

function mod:jawboneAI(npc)
local d = mod:GetEntityData(npc)
	if not d.init then
		d.init = true
		npc.SpriteOffset = Vector(0, -5)
		--npc.SplatColor = Color(0.15, 0, 0, 1, 25 / 255, 25 / 255, 25 / 255)
		npc:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
	end

	if npc:IsDead() then
		mod.spawnent(npc, npc.Position, nilvector, mod.FF.JawboneCorpse.ID, mod.FF.JawboneCorpse.Var)
	end
end

function mod:corpseAI(npc)
	local room = game:GetRoom()
	local sprite = npc:GetSprite();
	local d = mod:GetEntityData(npc)
	if not d.init then
		npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS)
		npc.SpriteOffset = Vector(0, -17)
		--npc.SplatColor = Color(0.15, 0, 0, 1, 25 / 255, 25 / 255, 25 / 255)
		npc:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
		d.init = true
	end

	npc.Velocity = npc.Velocity * 0.7
	mod:spritePlay(sprite, "Die")

	if npc.State == 5 then
		local beam = Isaac.Spawn(1000,7010, 0, npc.Position, nilvector, npc):ToEffect()
		local bsprite = beam:GetSprite()
		  if mod.isBackdrop("Mausoleum") then
			bsprite:ReplaceSpritesheet(0, "gfx/enemies/skeleton bats/ribbone_mausoleum.png")
			bsprite:ReplaceSpritesheet(1, "gfx/enemies/skeleton bats/ribbone_mausoleum.png")
			bsprite:LoadGraphics()
		  end

		beam:Update()
		local bat = Isaac.Spawn(mod.FF.Jawbone.ID,mod.FF.Jawbone.Var, 0, npc.Position, nilvector, npc):ToEffect()
		npc:Remove()
	end

	if room:IsClear() and not mod.FindClosestEntity(npc.Position,99999,258,961) then
		npc:Kill()
	end
end

function mod:BattyBloodBeam(e)
e.SpriteOffset = Vector(0, -20)
e.RenderZOffset = -5000
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.BattyBloodBeam, 7010)


function mod:friedAI(npc)
	local sprite = npc:GetSprite()
	local d = mod:GetEntityData(npc)

	npc.RenderZOffset = -10000

	--Isaac.ConsoleOutput(npc.SpriteRotation .. "\n")

	if not d.init then
		d.state = "idle"
		d.init = true
		npc.StateFrame = 60
	end

	if d.state == "idle" then
		if npc.State == 8 then
			d.state = "attackstart"
			npc.State = 5
		else
			npc.State = 4
		end
	elseif d.state == "attackstart" then
		if sprite:IsFinished("AttackStart") then
			d.state = "attack"
			npc:PlaySound(mod.Sounds.FriedLoop,1,0,true,1)
			npc.StateFrame = 100
		elseif sprite:GetFrame() == 7 then
			npc:PlaySound(mod.Sounds.FriedStart,1,0,false,1)
		else
			mod:spritePlay(sprite, "AttackStart")
		end
	elseif d.state == "attack" then
		npc.State = 4
		if npc.StateFrame < 1 then
			d.state = "idle"
			npc.StateFrame = 60
		elseif npc.StateFrame == 10 then
			sfx:Stop(mod.Sounds.FriedLoop)
			npc:PlaySound(mod.Sounds.FriedEnd,1,0,false,1)
		elseif npc.StateFrame > 10 then
			if not sfx:IsPlaying(mod.Sounds.FriedLoop) then
				sfx:Play(mod.Sounds.FriedLoop, 1, 0, true, 1)
			end
		end
		if npc.Velocity:Length() > 3 then
			npc.Velocity = npc.Velocity:Resized(3)
		end

		local offset = nilvector
		if npc.SpriteRotation == 0 then
			offset = Vector(0, -20)
		elseif npc.SpriteRotation == 90 then
			offset = Vector(20,-15)
		elseif npc.SpriteRotation == -90 then
			offset = Vector(-20,-15)
		elseif npc.SpriteRotation == 180 then
			offset = Vector(0,20)
		end

		local fire = Isaac.Spawn(1000,7005, 0, npc.Position + offset, Vector(0,8):Rotated(-15 + math.random(30) + npc.SpriteRotation), npc):ToEffect()
		fire:SetColor(Color(1,1,1,1,-100 / 255,70 / 255,455 / 255),10,1,true,false)
		mod:GetEntityData(fire).flamethrower = true
		mod:GetEntityData(fire).timer = 17
		mod:GetEntityData(fire).gridcoll = 0
		fire:Update()

		if npc.FrameCount % 2 == 0 then
			local emberParticle = Isaac.Spawn(1000,66, 0, npc.Position + offset, Vector(0,math.random(4,7)):Rotated(-35 + math.random(70) + npc.SpriteRotation), npc):ToEffect()
			emberParticle:Update()

			local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, npc.Position + offset, Vector(0,math.random(4,7)):Rotated(-35 + math.random(70) + npc.SpriteRotation), npc):ToEffect()
			smoke.SpriteRotation = math.random(360)
			smoke.Color = Color(1,1,1,0.3,75 / 255,70 / 255,50 / 255)
			--smoke.SpriteScale = Vector(2,2)
			smoke.SpriteOffset = Vector(0, 3):Rotated(npc.SpriteRotation)
			smoke.RenderZOffset = 300
			smoke:Update()
		end

		if npc.Velocity:Length() < 1 then
			sprite:SetFrame("AttackLoop", npc.FrameCount % 4)
		else
			sprite:SetFrame("AttackWalk", npc.FrameCount % 8)
		end
	end

	if npc:IsDead() then
		sfx:Stop(mod.Sounds.FriedLoop)
	end
end

function mod:ogreCreepAI(npc)
	local sprite = npc:GetSprite()
	local d = mod:GetEntityData(npc)
	local target = npc:GetPlayerTarget()

	--Isaac.ConsoleOutput(npc.SpriteRotation .. "\n")

	if not d.init then
		d.state = "idle"
		d.init = true
		npc.StateFrame = 15
	end

	if d.state == "idle" then
		if npc.State == 8 then
			d.state = "attackstart"
			npc.State = 5
		else
			npc.State = 4
		end
	elseif d.state == "attackstart" then
		if sprite:IsFinished("Attack") then
			d.state = "idle"
			npc.StateFrame = 15
		elseif sprite:IsEventTriggered("Shoot") then
			npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,1,2,false,math.random(9,11)/10)
			local projectile = mod:LazySpawnProjectile(4, 0, npc.Position, Vector(0,8):Rotated(npc.SpriteRotation), npc):ToProjectile();
			local dist = npc.Position:Distance(target.Position)
			projectile.FallingSpeed = dist * -0.1
			projectile.FallingAccel = 1
			projectile.Scale = 2
			projectile.Color = mod.ColorWebWhite
			mod:GetEntityData(projectile).projType = "ogreCreep"
			mod:setProjectileFriendliness(npc, projectile)
			projectile:Update()
		else
			mod:spritePlay(sprite, "Attack")
		end
	end
end

function mod:reheatedCreep1AI(npc)
	local sprite = npc:GetSprite()
	local d = mod:GetEntityData(npc)
	local target = npc:GetPlayerTarget()

	if not d.init then
		d.state = "idle"
		d.init = true
		npc.StateFrame = 15
		local ipecolor = Color(1,1,1,1,0,0,0)
		ipecolor:SetColorize(0.7, 2, 0.7, 1)
		npc.SplatColor = ipecolor
	end

	if d.state == "idle" then
		if npc.State == 8 then
			d.state = "attackstart"
			npc.State = 5
		else
			npc.State = 4
		end
	elseif d.state == "attackstart" then
		if sprite:IsFinished("Attack") then
			d.state = "idle"
			npc.StateFrame = 30
		elseif sprite:IsEventTriggered("Blam") then
			local projectile = mod:LazySpawnProjectile(0, 0, npc.Position, Vector(0,8):Rotated(npc.SpriteRotation), npc):ToProjectile();
			local dist = npc.Position:Distance(target.Position)
			projectile.FallingSpeed = dist * -0.1
			projectile.FallingAccel = 1
			projectile.Scale = 2
			local ipecolor = Color(1,1,1,1,0,0,0)
			ipecolor:SetColorize(0.7, 2, 0.7, 1)
			projectile.Color = ipecolor
			projectile.ProjectileFlags = ProjectileFlags.EXPLODE
			projectile:Update()
		else
			mod:spritePlay(sprite, "Attack")
		end
	end
end

function mod:reheatedCreep2AI(npc)
	local sprite = npc:GetSprite()
	local d = mod:GetEntityData(npc)
	local target = npc:GetPlayerTarget()

	if not d.init then
		d.state = "idle"
		d.init = true
		npc.StateFrame = 15
	end

	if d.state == "idle" then
		if npc.State == 8 then
			d.state = "attackstart"
			npc.State = 5
		else
			npc.State = 4
		end
	elseif d.state == "attackstart" then
		if sprite:IsFinished("Attack") then
			d.state = "idle"
			npc.StateFrame = 30
		elseif sprite:IsEventTriggered("Blam") then
			local laser = Isaac.Spawn(7,2,0,npc.Position, nilvector, npc):ToLaser()
			--laser.PositionOffset = Vector(0, -26)
			laser.SpawnerEntity = npc
			laser.Parent = npc
			laser.Angle = npc.SpriteRotation + 90
			laser:SetTimeout(5)
			laser:Update()
		else
			mod:spritePlay(sprite, "Attack")
		end
	end
end

--CauldronAI
mod.cursedGrimaceClones = 0
function mod:cursedGrimaceAI(npc)
local d = mod:GetEntityData(npc)
local r = npc:GetDropRNG()
local sprite = npc:GetSprite();
local target = npc:GetPlayerTarget()
local cursedGrimaceTargets = {}

npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
npc.Velocity = Vector(0,0)

	if npc.State ~= 16 then
	npc.State = 0
	d.started = true

		if not d.init then
			d.npcstate = "idle"
			d.init = true
			mod.cursedGrimaceClones = 0
			d.CurrentTarget = nil
			npc.StateFrame = 50
		else
			npc.StateFrame = npc.StateFrame - 1
		end

		--Isaac.ConsoleOutput(d.clones .. "\n")

		if d.npcstate == "idle" then
			mod:spritePlay(sprite, "Idle")
			--[[if d.clones > 9 then
			npc.State = 16
			end]]
			if not d.CurrentTarget or mod:isStatusCorpse(d.CurrentTarget) then
				local enmies = mod.AreThereEntitiesButNotThisOne(0, false)
				if enmies ~= false then
					if enmies < 10 then
						if npc.StateFrame < 0 then
							d.npcstate = "findtarget"
						end
					end
				end
			else
				--npc.StateFrame = 0
			end

		--Change to an "IsEventTriggered" when animations are added
		elseif d.npcstate == "findtarget" then
			for i, v in ipairs(Isaac.GetRoomEntities()) do
				if v:IsVulnerableEnemy() and (npc.FrameCount < 45 or v.FrameCount > 45) and not v:IsBoss() and not (v.Type == npc.Type) and not mod:isStatusCorpse(v) and not mod:isFriend(v) then
					local cloneable = true
					for _, k in ipairs(mod.Cloneless) do
						if k[3] then
							if v.Type == k[1] and v.Variant == k[2] and v.SubType == k[3] then
								cloneable = false
							end
						elseif k[2] then
							if v.Type == k[1] and v.Variant == k[2] then
								cloneable = false
							end
						else
							if v.Type == k[1] then
								cloneable = false
							end
						end
					end
					if not mod:GetEntityData(v).CursedGrimaceTarget == true and cloneable then
						table.insert(cursedGrimaceTargets, v)
					end
				end
			end

			if #cursedGrimaceTargets == 0 then
				d.npcState = "idle"
			else
				newtarget = cursedGrimaceTargets[r:RandomInt(#cursedGrimaceTargets)+1]
				d.CurrentTarget = newtarget
				mod:GetEntityData(newtarget).CursedGrimaceTarget = true
				local curseIcon = Isaac.Spawn(1000, 7001, mod.cursedGrimaceClones, newtarget.Position, nilvector, npc):ToEffect()
				curseIcon.SpawnerEntity = npc
				curseIcon:FollowParent(newtarget)
				curseIcon.SpriteOffset = Vector(0, -newtarget.Size*3)
				d.npcstate = "foundtarget"
				mod:spritePlay(sprite, "TargetStart")
			end
			npc.StateFrame = 30

		elseif d.npcstate == "foundtarget" then
			if sprite:IsFinished("TargetStart") then
				d.npcstate = "target"
			end

		elseif d.npcstate == "target" then
			mod:spritePlay(sprite, "Target")

		elseif d.npcstate == "BOOM" then
			if sprite:IsFinished("Duplicate") then
				mod.cursedGrimaceClones = mod.cursedGrimaceClones + 1
				if mod:isFriend(npc) then
					d.friendclones = d.friendclones or 0
					d.friendclones = d.friendclones + 1
					if d.friendclones > 5 then
						npc:Kill()
					end
				end
				d.npcstate = "idle"
				d.CloneHP = d.CloneHP or 15
				npc.StateFrame = math.floor((15 + (d.CloneHP * 1.5)) * (mod.cursedGrimaceClones * 0.5))
			elseif sprite:IsEventTriggered("Fire") then

				if d.CurrentTarget then
					if not d.CurrentTarget:IsDead() and not mod:isStatusCorpse(d.CurrentTarget) then
						npc:PlaySound(SoundEffect.SOUND_SUMMONSOUND,0.6,1,false,1)
						Isaac.Spawn(1000, 7010, 1, d.CurrentTarget.Position, nilvector, e):ToEffect()
						local vecran = RandomVector()*3
						local spawnEternal
						if mod:GetEntityData(d.CurrentTarget).eternalFlickerspirited then
							spawnEternal = true
						end
						for i = 1, 2 do
							local enmy = mod.spawnent(npc, d.CurrentTarget.Position + vecran:Rotated(i*180), nilvector, d.CurrentTarget.Type, d.CurrentTarget.Variant, d.CurrentTarget.SubType, d.CurrentTarget.HitPoints)
								mod:GetEntityData(enmy).memories = mod:GetEntityData(d.CurrentTarget).memories
								mod:GetEntityData(enmy).personalityTraits = mod:GetEntityData(d.CurrentTarget).personalityTraits
							if spawnEternal then
								local ef = mod.spawnent(npc, d.CurrentTarget.Position + vecran:Rotated(i*180), nilvector, mod.FF.EternalFlickerspirit.ID, mod.FF.EternalFlickerspirit.Var, 0)
							end
							local poof = Isaac.Spawn(1000, 15, 0, enmy.Position + vecran:Rotated(i*180), nilvector, enmy):ToEffect()
							poof.Color = Color(2,1,2,1,0,0,0)
							poof:Update()
						end
						d.CloneHP = d.CurrentTarget.MaxHitPoints
						d.CurrentTarget:Remove()
					end
				end

				d.CurrentTarget = nil
			else
				mod:spritePlay(sprite, "Duplicate")
			end
		end
	elseif npc.State == 16 then
		if d.started then
			sprite:Play("CloseEyes", true)
			d.started = nil
		end
		if sprite:IsFinished("CloseEyes") then
			sprite:Play("ClosedEyes", true)
		end
	end
end

function mod:cursedGrimaceChoose(e)
	e.RenderZOffset = 100
	if e.SpawnerEntity == nil then
		if e.Parent ~= nil then
			mod:GetEntityData(e.Parent).CursedGrimaceTarget = false
		end
		e:Remove()
	elseif e.Parent == nil or mod:isStatusCorpse(e.Parent) then
		mod:GetEntityData(e.SpawnerEntity).CurrentTarget = nil
		if mod:GetEntityData(e.SpawnerEntity).npcstate ~= "BOOM" or e.SpawnerEntity:GetSprite():GetFrame() < 11 then
			mod:GetEntityData(e.SpawnerEntity).npcstate = "idle"
			e.SpawnerEntity:ToNPC().StateFrame = 0
		end
		e:Remove()
	elseif e.SpawnerEntity and e.Parent then
		if e.FrameCount > 30 + e.SubType * 5 then
			mod:GetEntityData(e.SpawnerEntity).npcstate = "BOOM"
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.cursedGrimaceChoose, 7001)

function mod:cursedGrimaceProj(e)
	e.RenderZOffset = 100
	e.Velocity = nilvector
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.cursedGrimaceProj, 7007)

function mod:spinneretchAI(npc)
local d = mod:GetEntityData(npc)
local r = npc:GetDropRNG()
local target = npc:GetPlayerTarget()
local sprite = npc:GetSprite()

--Isaac.ConsoleOutput(npc.State .. "/" .. npc.StateFrame .. " ")

	if npc.State == 4 then
		if npc.StateFrame == 22 then
			npc.State = 5
			d.state = "idle"
		end
	elseif npc.State == 5 then
		if d.state == "idle" then
			if npc.StateFrame == 30 and not mod:isScareOrConfuse(npc) then
				local rando = r:RandomInt(11)
				--local rando = 10
				 if rando > 7 then
					d.state = "Shoot"
					d.part = 1
					npc.StateFrame = 0
					mod:spritePlay(sprite, "ShootStart")
				 elseif rando > 2 then
					local shootinstead = nil
					if mod.GetEntityCount(mod.FF.SpiderEgg.ID, mod.FF.SpiderEgg.Var, mod.FF.SpiderEgg.Sub) < 5 then
						local egg = mod.FindClosestEntity(npc.Position, 99999, mod.FF.SpiderEgg.ID, mod.FF.SpiderEgg.Var, mod.FF.SpiderEgg.Sub)
						if egg then
							if egg.Position:Distance(npc.Position) > 30 then
								d.state = "Cough"
							else
								shootinstead = true
							end
						else
							d.state = "Cough"
						end
					else
						shootinstead = true
					end
					if shootinstead then
						d.state = "Shoot"
						d.part = 1
						npc.StateFrame = 0
						mod:spritePlay(sprite, "ShootStart")
					end
				end
			elseif npc.StateFrame > 30 then
				if sprite:IsFinished("HopPrep") then
					npc.State = 3
					sprite:Play("Hop")
				else
					mod:spritePlay(sprite, "HopPrep")
				end
			end
		elseif d.state == "Cough" then
			if sprite:IsFinished("SpawnEgg") then
				d.state = "idle"
			elseif sprite:IsEventTriggered("Spawn") then
				npc:PlaySound(SoundEffect.SOUND_WHEEZY_COUGH,1,0,false,1)
				local egg = Isaac.Spawn(mod.FF.SpiderEgg.ID, mod.FF.SpiderEgg.Var, mod.FF.SpiderEgg.Sub, npc.Position + Vector(0,10), nilvector, npc)
				egg.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			else
				mod:spritePlay(sprite, "SpawnEgg")
			end
		elseif d.state == "Shoot" then
			if d.shooting then
				if npc.FrameCount % 2 == 0 then
					npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,0.5,2,false,math.random(12,15)/10)
					local shotspeed = (target.Position - npc.Position):Resized(9):Rotated(-10+math.random(20))
					local params = ProjectileParams()
					params.Scale = math.random(2, 8) / 10
					--params.FallingSpeedModifier = -15 + math.random(10);
					params.FallingAccelModifier = 0.13
					params.HeightModifier = 0
					params.Variant = 4
					params.Color = mod.ColorWebWhite
					npc:FireProjectiles(npc.Position, shotspeed, 0, params)
				end
			end
			if d.part == 1 then
				if sprite:IsFinished("ShootStart") then
					mod:spritePlay(sprite, "ShootLoop")
					d.part = 2
				elseif sprite:IsEventTriggered("Shoot") then
					d.shooting = true
				end
			elseif d.part == 2 then
				mod:spritePlay(sprite, "ShootLoop")
				if (npc.StateFrame > 30 and r:RandomInt(5) == 0) or mod:isScareOrConfuse(npc) then
					d.part = 3
					d.shooting = false
					mod:spritePlay(sprite, "ShootEnd")
				end
			elseif d.part == 3 then
				if sprite:IsFinished("ShootEnd") then
					d.state = "idle"
				else
					mod:spritePlay(sprite, "ShootEnd")
				end
			end
		end
	end
end

function mod:bombmuncherAI(npc)
local d = mod:GetEntityData(npc)
local r = npc:GetDropRNG()
local target = npc:GetPlayerTarget()
local sprite = npc:GetSprite()

	if npc.State == 3 and npc.StateFrame == 0 then
	npc.State = 5
	d.state = "starteridle"
	sprite:Play("Idle")
	end
	if npc.State == 4 then --In the air
		if npc.StateFrame == 22 then
			npc.State = 5
			d.state = "idle"
			sprite:Play("Idle")
		end
	elseif npc.State == 5 then --postjump
		if npc.StateFrame == 1 then
			sprite:Play("Idle")
		end
		local waitingFrames = 60
		if d.state == "starteridle" then
			waitingFrames = 30
		end
		if d.state == "idle" or d.state == "starteridle" then
			if npc.StateFrame == waitingFrames and not mod:isScareOrConfuse(npc) then
				local rando = r:RandomInt(11)
			elseif npc.StateFrame > waitingFrames then
				if sprite:IsFinished("HopPrep") then
					npc.State = 3
					sprite:Play("Hop")
					local bomb = Isaac.Spawn(4, 0, 0, npc.Position, nilvector, npc):ToBomb()
					bomb.ExplosionDamage = 20
					local poof = Isaac.Spawn(1000, 15, 1, npc.Position, nilvector, nil)
					mod:PlaySound(SoundEffect.SOUND_WHEEZY_COUGH, npc, 1.5, 0.8)
				else
					mod:spritePlay(sprite, "HopPrep")
				end
			end
		end
	end
end

function mod:spitroastAI(npc)
	npc.SplatColor = mod.ColorFireyFade
	local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local sprite = npc:GetSprite()
	local data = mod:GetEntityData(npc)

	mod:lastJudgementAutoResprite(npc, data, sprite)

	if npc.Velocity:Length() > 2 and npc.Variant == mod.FF.Spitroast.Var then
		npc.Velocity = npc.Velocity:Resized(2)
	end

	if npc.FrameCount % 25 == 15 and npc.Variant == mod.FF.Spitfire.Var then
		local numberofflames = 5
		for i = 1, numberofflames do
			local vec = Vector(6,0):Rotated((360/numberofflames) * i)
			local fire = Isaac.Spawn(1000,7005, 1, npc.Position, Vector(6,0):Rotated((360/numberofflames) * i), npc)
			fire:Update()
		end
	end

	if npc:IsDead() and mod:shouldDoDeathEffect(npc) then
		if npc.Variant == mod.FF.Spitfire.Var then
			--spitfire
			npc:PlaySound(mod.Sounds.FireFizzle, 1.2, 0, false, 1)
			local numberofflames = math.random(12, 15)
			for i = 1, numberofflames do
				local vec = Vector(6,0):Rotated((360/numberofflames) * i)
				local fire = Isaac.Spawn(1000,7005, 1, npc.Position, Vector(math.random(6, 16),0):Rotated((360/numberofflames) * i), npc)
				fire:Update()
			end
		else
			--spitroast
			npc:PlaySound(mod.Sounds.FireFizzle, 1, 0, false, 1.3)
			local numberofflames = 10
			for i = 1, numberofflames do
				local fire = Isaac.Spawn(1000,7005, 1, npc.Position, Vector(8,0):Rotated((360/numberofflames) * i), npc)
				fire:Update()
			end
		end
	end
end

function mod:powderkegAI(npc)
local d = mod:GetEntityData(npc)
local sprite = npc:GetSprite();
local path = npc.Pathfinder
local target = npc:GetPlayerTarget()
local targetpos = target.Position

	if not d.init then
		d.lastpos = npc.Position
		d.init = true
	else
		npc.State = 4
	end

	if d.lastpos:Distance(npc.Position) > 20 then
		mod.SpawnGunpowder(npc,npc.Position)
		d.lastpos = npc.Position
	end

	if npc:IsDead() and mod:shouldDoDeathEffect(npc) then
		local fire = Isaac.Spawn(1000,7005, 0, npc.Position, nilvector, npc):ToEffect()
		for i = 60, 360, 60 do
			mod.SpawnGunpowder(npc,npc.Position + Vector(25, 0):Rotated(i), 1, 30)
		end
		Isaac.Explode(npc.Position, npc, 10)
	end
end

function mod:gunpowderCreepAI(e)
	local d = mod:GetEntityData(e)
	local burntime = d.burntime or 20
	local spreaddist = d.spreaddist or 50
	local room = game:GetRoom()
	if d.flaming and not d.spawndfire then
		if e.SpawnerEntity and e.SpawnerEntity.Type == 1 or d.friendlyOnly then
			local fire = Isaac.Spawn(1000,51,960, e.Position, nilvector, e.SpawnerEntity):ToEffect()
			mod:GetEntityData(fire).timer = burntime
			fire:Update()
		else
			local fire = Isaac.Spawn(1000,7005, 0, e.Position, nilvector, e.SpawnerEntity):ToEffect()
			if e.SpawnerEntity then
				e.Parent = e.SpawnerEntity
			end
			mod:GetEntityData(fire).timer = burntime
			if d.uniqueColor then
				fire.Color = d.uniqueColor
			end
			if d.uniqueSpritesheet then
				fire:GetSprite():ReplaceSpritesheet(0, d.uniqueSpritesheet)
				fire:GetSprite():LoadGraphics()
			end
			fire:Update()
		end
		d.spawndfire = true
		d.StateFrame = 0
	elseif not d.flaming then
		local fire
		if room:GetFrameCount() > 1 then
			if e.Variant == 45 then
				fire = mod.FindClosestFire(e.Position, 99999, true)
			else
				fire = mod.FindClosestFire(e.Position, 99999)
			end
			if fire then
				if e.Position:Distance(fire.Position) < spreaddist then
					d.flaming = true
				end
			end
		end
	end
	if d.spawndfire then
		d.StateFrame = d.StateFrame + 1
		if d.StateFrame > burntime + 10 then
			e:Remove()
		elseif d.StateFrame > burntime then
			e.SpriteScale = Vector(1,1) * (1 - ((d.StateFrame - burntime)/10))
		end
	end
end

function mod:pipeAI(npc, variant, subtype)
	local room = game:GetRoom()
	local sprite = npc:GetSprite()
	local d = mod:GetEntityData(npc)

	npc.State = 0
	npc.Velocity = nilvector

	local creeptype = 22
	local bloodcol = mod.ColorNormal

	local timer = math.floor((FiendFolio.GetBits(subtype, 1, 4) + 1) * 12.5) -- default 100
	local offset = math.floor(FiendFolio.GetBits(subtype, 5, 4) * 12.5) -- default 0
	local creepTimeout = math.floor((FiendFolio.GetBits(subtype, 9, 4) + 1) * 12.5) -- default 50

	if variant == 1710 then	--Green
		creeptype = 23
		bloodcol = Color(1,1,1,1,-150 / 255,100 / 255,0)
	elseif variant == 1711 then	--Shit
		creeptype = 94
		bloodcol = Color(0,0,0,1,145 / 255,115 / 255,30 / 255)
	elseif variant == 1712 then	--Black
		creeptype = 26
		bloodcol = mod.ColorDankBlackReal
	elseif variant == 1713 then
		creeptype = 24
		bloodcol = Color(0,0,0,1,180 / 255,180 / 255,30 / 255)
	elseif variant == 1714 then
		creeptype = 24
		bloodcol = Color(0,0,0,1,180 / 255,180 / 255,30 / 255)
	end

	local varhori = FiendFolio.GetBits(subtype, 0, 1) == 1

	if not d.init then
		npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET)
		if varhori then
			local Rpos = room:GetClampedPosition(npc.Position + Vector(40, 0), 0)
			local Lpos = room:GetClampedPosition(npc.Position + Vector(-40, 0), 0)

			local Rdist =  npc.Position:Distance(Rpos)
			local Ldist =  npc.Position:Distance(Lpos)

			if Rdist > Ldist then
				npc.Position = Lpos + Vector(-10, 0)
				npc.SpriteRotation = 270
				d.vec = 1
			else
				npc.Position = Rpos + Vector(10, 0)
				npc.SpriteRotation = 90
				d.vec = -1
			end
		else
			local abovepos = room:GetClampedPosition(npc.Position + Vector(0,-40), 0)
			local belowpos = room:GetClampedPosition(npc.Position + Vector(0,40), 0)

			local abovedist =  npc.Position:Distance(abovepos)
			local belowdist =  npc.Position:Distance(belowpos)

			if abovedist > belowdist then
				npc.Position = belowpos + Vector(0, 10)
				npc.SpriteRotation = 180
				d.vec = -1
			else
				npc.Position = abovepos + Vector(0, -10)
				d.vec = 1
			end
		end

		npc.StateFrame = offset

		if room:IsClear() then
			d.state = "closed"
		else
			d.state = "idle"
		end

		d.init = true
	else
		npc.StateFrame = npc.StateFrame + 1
	end

	if d.state == "idle" then
		mod:spritePlay(sprite, "Idle")

		if npc.StateFrame > timer then
			d.state = "shoot"
			npc.StateFrame = 0
			if not d.shoot or d.shoot == 2 then
				d.shoot = 1
			else
				d.shoot = 2
			end
		end

		if room:IsClear() then
			d.state = "close"
		end

	elseif d.state == "shoot" then
		if variant == 1714 then
			if sprite:IsFinished("Shoot0" .. d.shoot) then
				d.state = "idle"
				npc.StateFrame = sprite:GetFrame()
			elseif sprite:GetFrame() == 8 then
				d.shooting = true
				d.count = 0
			else
				mod:spritePlay(sprite, "Shoot0" .. d.shoot)
			end
		else
			if sprite:IsFinished("Shoot") then
				d.state = "idle"
				npc.StateFrame = sprite:GetFrame()
			elseif sprite:GetFrame() == 8 then
				d.shooting = true
				d.count = 0
			else
				mod:spritePlay(sprite, "Shoot")
			end
		end
	elseif d.state == "close" then
		if sprite:IsFinished("Clog") then
			d.state = "closed"
		else
			mod:spritePlay(sprite, "Clog")
		end
	elseif d.state == "closed" then
		sprite:SetFrame("Clog", 16)
	end

	if d.shooting then
		d.count = d.count + 1
		if d.count % 3 == 0 then
			local shootdist = 20 + (10 * d.count)
			local vec
			if varhori then
				vec = Vector(shootdist, 0) * d.vec
			else
				vec = Vector(0, shootdist) * d.vec
			end
			if variant == 1714 then
				if d.shoot == 1 then
					vec = vec:Rotated(45)
				else
					vec = vec:Rotated(-45)
				end
			end

			if d.count == 3 then
				local creep = Isaac.Spawn(1000, creeptype, 0, npc.Position + vec:Resized(15), nilvector, npc):ToEffect()
				creep:SetTimeout(creepTimeout)
				creep:Update()
			end

			local timetostop
			if d.gratelast then
				timetostop = true
			else
				for _, grate in pairs(Isaac.FindByType(mod.FF.Graterhole.ID, mod.FF.Graterhole.Var, -1, false, false)) do
					local distgrate = grate.Position:Distance(npc.Position + vec)
					if distgrate < 20 then
						d.gratelast = true
					end
				end
			end
			if room:GetGridCollisionAtPos(npc.Position + vec) == GridCollisionClass.COLLISION_NONE and not timetostop then
				local creep = Isaac.Spawn(1000, creeptype, 0, npc.Position + vec, nilvector, npc):ToEffect()
				creep:SetTimeout(creepTimeout)
				creep:Update()
				local blood = Isaac.Spawn(1000, 2, 960, npc.Position + vec, nilvector, npc):ToEffect()
				blood.Color = bloodcol
				blood.Scale = 0.5
				blood:Update()
			else
				d.shooting = false
				d.count = 0
				d.gratelast = nil
			end
		end
		if d.count > 50 then
			d.shooting = false
			d.count = 0
		end
	end
end

function mod:checkBloodExplosion(e)
	if e.SubType == 960 then
		local sprite = e:GetSprite()
		if sprite:IsFinished("Poof") or sprite:IsFinished("Poof_Small") or sprite:IsFinished("Poof_Large1") or sprite:IsFinished("Poof_Large2") then
			e:Remove()
		end
	end

end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.checkBloodExplosion, 2)


--FERRIUM LEFTOVERS

--[[  Just a test to see if I could make event rocks that spawn. It works, but shouldn't be used.

function mod:rockspawnerAI(npc)
	local data = mod:GetEntityData(npc)

	if not data.init then
		npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		Isaac.Spawn(1000, 177, 1, npc.Position, Vector.Zero, npc)
		npc:Remove()
		data.init = true
	else
		npc:Remove()
	end
end]]

-- concept enemy, too similar to Technician. Guess I'll leave it in for someone to datamine.
--[[function mod:boreAI(npc)
	local sprite = npc:GetSprite()
	local data = mod:GetEntityData(npc)
	local target = npc:GetPlayerTarget()
	local rand = npc:GetDropRNG()
	if not data.init then
		npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
		data.state = "Idle"
		data.init = true
	else
		npc.StateFrame = npc.StateFrame+1
	end
	npc.Velocity = npc.Velocity*0.4

	if data.state == "Idle" then
		if npc.StateFrame > 70 and rand:RandomInt(15) == 0 then
			sprite:Play("Attack")
			data.state = "Attack"
		else
			mod:spritePlay(sprite, "Idle")
		end
	elseif data.state == "Attack" then
		if sprite:IsEventTriggered("Shoot") then
			npc:PlaySound(SoundEffect.SOUND_MAGGOT_BURST_OUT, 0.6, 0, false, 1)
			local sDir = (target.Position-npc.Position)*0.03
			local projectile = mod:LazySpawnProjectile(9, 0, npc.Position, sDir, npc):ToProjectile()
			projectile.Scale = 2.5
			projectile.FallingSpeed = -45
			projectile.FallingAccel = 0.8
			mod:GetEntityData(projectile).bore = true
			mod:GetEntityData(projectile).tPos = target.Position
			projectile:Update()
		elseif sprite:IsFinished("Attack") then
			npc.StateFrame = 0
			data.state = "Idle"
		end
	end
end

function mod.boreProj(v, d)
	if d.bore == true then
		--local target = v.SpawnerEntity:ToNPC():GetPlayerTarget()
		--mod:Lerp(v.Velocity, (target.Position-v.Position):Resized(5), 0.3)
		v.Velocity = mod:Lerp(v.Velocity, (d.tPos-v.Position):Resized(6), 0.3)
		if (d.tPos-v.Position):Length() < 5 then
			local sDir = RandomVector():Resized(7)
			SFXManager():Play(SoundEffect.SOUND_ROCK_CRUMBLE, 1, 0, false, math.random(8,12)/10)
			for i=0,3 do
				local AAAA = Isaac.Spawn(1000, 88, 0, v.Position, RandomVector():Resized(2), v):ToEffect()
				AAAA.SpriteOffset = Vector(0, v.Height)
				AAAA:Update()
			end
			for i=0,10 do
				local projectile = mod:LazySpawnProjectile(0, 0, v.Position, sDir:Rotated(i*36), v):ToProjectile()
				projectile.Height = v.Height
				projectile.FallingSpeed = 20
				projectile.FallingAccel = 2
				projectile:Update()
			end
			v:Remove()
		end
	end
end]]

--FERRIUM END

--SBODY START

	--hi

--SBODY END

mod.ValidPlayerEnums = {
	PlayerType.PLAYER_ISAAC,
	PlayerType.PLAYER_MAGDALENA,
	PlayerType.PLAYER_CAIN,
	PlayerType.PLAYER_JUDAS,
	PlayerType.PLAYER_XXX,
	PlayerType.PLAYER_EVE,
	PlayerType.PLAYER_SAMSON,
	PlayerType.PLAYER_AZAZEL,
	PlayerType.PLAYER_LAZARUS,
	PlayerType.PLAYER_EDEN,
	PlayerType.PLAYER_THELOST,
	PlayerType.PLAYER_LILITH,
	PlayerType.PLAYER_KEEPER,
	PlayerType.PLAYER_APOLLYON,
	PlayerType.PLAYER_THEFORGOTTEN,
	PlayerType.PLAYER_BETHANY,
	PlayerType.PLAYER_JACOB,
	FiendFolio.PLAYER.FIEND,
	FiendFolio.PLAYER.GOLEM,
	FiendFolio.PLAYER.FRIEND,
}

mod.ValidPlayerBEnums = {
	PlayerType.PLAYER_ISAAC_B,
	PlayerType.PLAYER_MAGDALENA_B,
	PlayerType.PLAYER_CAIN_B,
	PlayerType.PLAYER_JUDAS_B,
	PlayerType.PLAYER_XXX_B,
	PlayerType.PLAYER_EVE_B,
	PlayerType.PLAYER_SAMSON_B,
	PlayerType.PLAYER_AZAZEL_B,
	PlayerType.PLAYER_LAZARUS_B,
	PlayerType.PLAYER_EDEN_B,
	PlayerType.PLAYER_THELOST_B,
	PlayerType.PLAYER_LILITH_B,
	PlayerType.PLAYER_KEEPER_B,
	PlayerType.PLAYER_APOLLYON_B,
	PlayerType.PLAYER_THEFORGOTTEN_B,
	PlayerType.PLAYER_BETHANY_B,
	PlayerType.PLAYER_JACOB_B,
	FiendFolio.PLAYER.BIEND,
	FiendFolio.PLAYER.BOLEM,
	FiendFolio.PLAYER.BRIEND,
}

function mod.fiendishLogic()
	--mod.Fiendish = true
	if not mod.Fiendish then
		mod.FiendishEffects = nil
		return
	end
	mod.FiendishEffects = mod.FiendishEffects or {}
	mod.FiendishEffectTimer = mod.FiendishEffectTimer or 30

	local evP
	for key, val in pairs(mod.FiendishEffects) do
		if mod.FiendishEffects[key] then
			mod.FiendishEffects[key] = mod.FiendishEffects[key] + 1
			if val > mod.FiendishEffectTimer then
				mod.FiendishEffects[key] = nil
				evP = true
			end
		end
	end

	if evP then
		for i = 1, game:GetNumPlayers() do
			local player = Isaac.GetPlayer(i - 1)
			player:AddCacheFlags(CacheFlag.CACHE_ALL)
			player:EvaluateItems()
		end
	end

	if mod.FiendishEffects.GoWackyWithSound then
		local sound = math.random(SoundEffect.NUM_SOUND_EFFECTS - 1 + #mod.Sounds)
		if sound >= SoundEffect.NUM_SOUND_EFFECTS then
			sfx:Play(mod.Sounds[sound - 472],1,2,false,1)
		else
			sfx:Play(sound - 1,1,2,false,math.random(10,200)/100)
		end
	end
	if mod.FiendishEffects.funnySoundReplace then
		--print("hmm")
		for i = 1, SoundEffect.NUM_SOUND_EFFECTS do
			if sfx:IsPlaying(i) and i ~= mod.ChosenFunnySoundReplace then
				sfx:Stop(i)
				sfx:Play(mod.ChosenFunnySoundReplace, 1, 0, false, math.random(75,125)/100)
			end
		end
	end
	if mod.FiendishEffects.SpeedyTimeCounter then
		game.TimeCounter = game.TimeCounter + math.random(10000)
	end
	if mod.FiendishEffects.UnhappyTimeCounter then
		game.TimeCounter = game.TimeCounter + math.random(10000) - 5000
	end
	if mod.FiendishEffects.ReverseTimeCounter then
		game.TimeCounter = game.TimeCounter - math.random(10000)
	end

	mod.MorselTimer = mod.MorselTimer or 0
	local level = game:GetLevel()
	local stage = level:GetStage()
	local room = game:GetRoom()
	local player = Isaac.GetPlayer(0)
	if stage > 6 and not mod.cheatModeOn then
		Isaac.Spawn(mod.FF.Freezer.ID, mod.FF.Freezer.Var, 0, room:GetRandomPosition(1), nilvector, nil)
	elseif stage > 4 and not mod.cheatModeOn then
		MusicManager():Pause()
		MusicManager():Disable()
		if not sfx:IsPlaying(mod.Sounds.Circus) then
			sfx:Play(mod.Sounds.Circus, 1, 0, false, 1)
		end
		mod.MorselTimer = mod.MorselTimer + 1
		local morselsub = math.floor((mod.MorselTimer - 200) / 100)
		if mod.MorselTimer > 300 and mod.MorselTimer % 10 == 0 then
			local blood = Isaac.Spawn(mod.FF.Morsel.ID, mod.FF.Morsel.Var, morselsub, room:GetRandomPosition(1), nilvector, npc):ToNPC()
			blood.CanShutDoors = false
			blood:Update()
			sfx:Play(SoundEffect.SOUND_SUMMONSOUND, 0.6, 0, false, 1)
		end
	elseif stage > 2 or mod.cheatModeOn then
		game:GetLevel():AddCurse(LevelCurse.CURSE_OF_MAZE)
		local randomchance = 500
		if mod.cheatModeOn then
			randomchance = 60
		elseif stage > 3 then
			randomchance = 200
		end
		if math.random(randomchance) == 1 then
			mod.FiendishEffectTimer = math.random(20,150)
			local r = math.random(125)
			if r < 7 then
				for _, e in pairs(Isaac.GetRoomEntities()) do
					e.Velocity = e.Velocity * -5
				end
			elseif r < 9 then
				local entities = Isaac.GetRoomEntities()
				for i = 1, #Isaac.GetRoomEntities() do
					if entities[i - 1] then
						entities[i].Position = entities[i - 1].Position
					end
				end
			elseif r < 12 then
				game:ShakeScreen(100)
			elseif r < 13 then
				player:UseActiveItem(285, false, true, true, false)
			elseif r < 14 then
				player:UseActiveItem(406, false, true, true, false)
			elseif r < 19 then
				for _, e in pairs(Isaac.GetRoomEntities()) do
					e.Color = Color(math.random(100)/50, math.random(100)/50, math.random(100)/50, 1, math.random(), math.random(), math.random())
				end
			elseif r < 22 then
				for _, e in pairs(Isaac.GetRoomEntities()) do
					if e.Type == 5 or e.Type == 2 or e.Type == 3 or e.Type == 4 then
						Isaac.Explode(e.Position, e, 10)
						e:Remove()
					end
				end
			elseif r < 23 then
				player:UseCard(45)
			elseif r < 24 then
				player:UseCard(1)
			elseif r < 25 then
				player:UseCard(5)
			elseif r < 27 then
				player:UseCard(3)
			elseif r < 37 then
				for _, e in pairs(Isaac.GetRoomEntities()) do
					e.Velocity = e.Velocity:Rotated(math.random(360)) * math.random(10)
				end
			elseif r < 38 then
				for _, e in pairs(Isaac.GetRoomEntities()) do
					e.Position = room:GetRandomPosition(1)
				end
			elseif r < 39 then
				mod.FiendishEffects.RunRound = 0
			elseif r < 40 then
				mod.FiendishEffects.ZipZoop = 0
			elseif r < 41 then
				mod.FiendishEffects.Nyoom = 0
			elseif r < 42 then
				mod.FiendishEffects.SlowDown = 0
			elseif r < 43 then
				mod.FiendishEffects.Funny = 0
			elseif r < 44 then
				for _, e in pairs(Isaac.GetRoomEntities()) do
					e.Velocity = Vector(e.Velocity.X * e.Velocity.X, e.Velocity.Y * e.Velocity.Y)
				end
			elseif r < 45 then
				mod.FiendishEffects.Twirly = 0
			elseif r < 48 then
				for _, e in pairs(Isaac.GetRoomEntities()) do
					if e.Type == 5 then
						Isaac.Spawn(mod.FF.Snagger.ID, mod.FF.Snagger.Var, 0, e.Position, nilvector, nil)
					end
				end
			elseif r < 49 then
				mod.FiendishEffects.Spunky = 0
			elseif r < 50 then
				mod.FiendishEffects.Spindigo = 0
			elseif r < 53 then
				local sound = math.random(472 + #mod.Sounds)
				if sound > 472 then
					sfx:Play(mod.Sounds[sound - 472],1,2,false,1)
				else
					sfx:Play(sound - 1,1,2,false,math.random(1,20)/10)
				end
			elseif r < 54 then
				mod.FiendishEffects.Homer = 0
			elseif r < 55 then
				mod.FiendishEffects.Scared = 0
			elseif r < 56 then
				for _, e in pairs(Isaac.GetRoomEntities()) do
					if e:IsEnemy() and math.random(3) == 1 then
						Isaac.Spawn(mod.FF.EternalFlickerspirit.ID, mod.FF.EternalFlickerspirit.Var, 0, e.Position, nilvector, nil)
					end
				end
			elseif r < 57 then
				for _, e in pairs(Isaac.GetRoomEntities()) do
					if e:IsEnemy() and math.random(3) == 1 then
						Isaac.Spawn(mod.FF.Harletwin.ID, mod.FF.Harletwin.Var, 0, e.Position, nilvector, nil)
					end
				end
			elseif r < 60 then
				for _, e in pairs(Isaac.GetRoomEntities()) do
					if e:IsEnemy() then
						mod.ShootBubble(e, nil, e.Position, (e:ToNPC():GetPlayerTarget().Position - e.Position):Resized(math.random(5)))
					end
				end
			elseif r < 61 then
				mod.FiendishEffects.SPEED = 0
			elseif r < 62 then
				for _, e in pairs(Isaac.GetRoomEntities()) do
					if e.Type ~= 1 then
						e.SpriteOffset = RandomVector() * math.random(50)
					end
				end
			elseif r < 63 then
				for _, e in pairs(Isaac.GetRoomEntities()) do
					if e.Type ~= 1 then
						e:Die()
					end
				end
			elseif r < 64 then
				mod.FiendishEffects.FunnyPickup = 0
			elseif r < 68 then
				mod.FiendishEffects.FunnyProjectiles = 0
			elseif r < 70 then
				local cardChoice = math.random(62)
				if cardChoice ~= 46 then
					player:UseCard(cardChoice)
				end
			elseif r < 72 then
				player:UsePill(math.random(47) - 1, math.random(14) - 1)
			elseif r < 74 then
				player:UseActiveItem(488, true, true, true, true)
			elseif r < 75 then
				mod.FiendishEffects.GoWackyWithSound = 0
			elseif r < 76 then
				mod.FiendishEffects.SizeRandomizer = 0
			elseif r < 78 then
				for _, e in pairs(Isaac.GetRoomEntities()) do
					game:ButterBeanFart(e.Position, 250, e, 1, true)
				end
			elseif r < 79 then
				mod.FiendishEffects.SpeedyTimeCounter = 0
			elseif r < 80 then
				mod.FiendishEffects.UnhappyTimeCounter = 0
			elseif r < 81 then
				mod.FiendishEffects.ReverseTimeCounter = 0
			elseif r < 82 then
				mod.FiendishEffects.Pendulum = 0
			elseif r < 83 then
				mod.FiendishEffects.SpeedSpinUp = 0
			elseif r < 84 then
				player:UseActiveItem(386, true, true, true, true)
			elseif r < 85 then
				local room = Game():GetRoom()
				local size = room:GetGridSize()
				for i=0, size do
					if not room:GetGridEntity(i) then
						local gridpos = room:GetGridPosition(i)
						Isaac.Spawn(85, 962, 0, gridpos, nilvector, nil)
					end
				end
			elseif r < 86 then
				local room = Game():GetRoom()
				local size = room:GetGridSize()
				for i=0, size do
					if not room:GetGridEntity(i) then
						local gridpos = room:GetGridPosition(i)
						Isaac.Spawn(5, 0, 0, gridpos, nilvector, nil)
					end
				end
			elseif r < 87 then
				mod.FiendishEffects.RollItems = 0
			elseif r < 88 then
				mod.FiendishEffects.RollHealth = 0
			elseif r < 90 then
				mod.FiendishEffects.GetSpeedy = 0
			elseif r < 92 then
				mod.FiendishEffects.GetShooty = 0
			elseif r < 94 then
				mod.FiendishEffects.GetHurty = 0
			elseif r < 96 then
				mod.FiendishEffects.GetShootSpeedy = 0
			elseif r < 97 then
				mod:GetEntityData(Isaac.GetPlayer(0)).drawnSwallowedM90 = true
			elseif r < 100 then
				for i = 1, game:GetNumPlayers() do
					local player = Isaac.GetPlayer(i - 1)
					local choice = mod.ValidPlayerEnums[math.random(#mod.ValidPlayerEnums)]
					if math.random(5) == 1 then
						choice = mod.ValidPlayerBEnums[math.random(#mod.ValidPlayerBEnums)]
					end
					if math.random(10) == 1 and i == 1 then
						Isaac.ExecuteCommand('addplayer ' .. choice .. ' ' .. player.ControllerIndex)
					else
						player:ChangePlayerType(choice)
					end
				end
			elseif r < 102 then
				mod.FiendishEffects.LessHurty = 0
			elseif r < 103 then
				sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ,2, 0, false, 0.75)
				local middle = room:GetCenterPos()
				--Isaac.Spawn(6, 12, 0, middle, nilvector, nil)
				Isaac.GridSpawn(GridEntityType.GRID_PRESSURE_PLATE, 0, middle, true)
				Isaac.GetPlayer(0).Position = middle + Vector(0, -80)
				for i = 45, 315, 45 do
					Isaac.Spawn(160,1717,0, middle + Vector(0, -80):Rotated(i), nilvector, nil)
				end
			elseif r < 104 then
				mod.FiendishEffects.funnySoundReplace = 0
				mod.ChosenFunnySoundReplace = math.random(SoundEffect.NUM_SOUND_EFFECTS)
			elseif r < 105 then
				Isaac.Spawn(4,17,0, Isaac.GetPlayer().Position, nilvector, nil)
			elseif r < 106 then
				Isaac.Spawn(4,18,0, Isaac.GetPlayer().Position, nilvector, nil)
			elseif r < 107 then
				local middle = room:GetCenterPos()
				local esau = Isaac.Spawn(866, 0, 0, middle, nilvector, nil)
				esau:Update()
				mod.scheduleForUpdate(function()
					if esau then
						esau:Kill()
					end
				end, math.random(200,3000))
			elseif r < 110 then
			elseif r < 115 then
				if not mod.FiendishKeyTimer then
					mod.FiendishKeyTimer = math.random(2,15) * 60
					if math.random(2) == 1 then
						mod.FiendishKeyToPress = math.random(#mod.ValidFunnyKeys)
					else
						mod.FiendishActionToDo = math.random(#mod.ValidFunnyActions)
					end
				end
			elseif r < 116 then
				mod.FatManArrive = 400
			elseif r < 118 then
				if mod.PickupsAreHidden then
					mod.PickupsAreHidden = false
				else
					mod.PickupsAreHidden = true
				end
			elseif r < 120 then
				mod:ShowTortune()
			elseif r < 121 then
				for _,entity in ipairs(Isaac.GetRoomEntities()) do
					local enemy = entity:ToNPC()
					if enemy then
						enemy:Morph(enemy.Type, enemy.Variant, enemy.SubType, math.random(10))
					end
				end
			elseif r < 123 then
				mod.shampooBottleIdleCommentPerRoom = nil
				mod.shampooDialogue = {}
				mod:shampooBottleEnemyCommentary()
			else
				game:Fart(player.Position, 40, player, 1, 0)
			end
		end
	end
end

function mod:waitingSpiderAI(npc, subt)
	local sprite = npc:GetSprite()
	local d = mod:GetEntityData(npc)
	local target = npc:GetPlayerTarget()
	local waitingFlags = EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_DONT_COUNT_BOSS_HP

	if not d.init then
		mod:lastJudgementAutoResprite(npc, d, sprite)
		npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		npc:AddEntityFlags(waitingFlags)
		npc.Visible = false

		d.state = "waiting"

		d.init = true
	elseif d.init then
		npc.StateFrame = npc.StateFrame + 1
	end

	if d.state == "waiting" then
		if mod.CanIComeOutYet() then
			if npc.StateFrame > 15 then
				if mod.farFromAllPlayers(npc.Position, 60) then
					d.state = "emerge"
					npc:ClearEntityFlags(waitingFlags)
					mod:spritePlay(sprite, "Drop")
					npc.Visible = true
					if subt == mod.FF.WaitingDemonNull.Sub
					or subt == mod.FF.WaitingDemonBK.Sub
					or subt == mod.FF.WaitingDemonBG.Sub
					or subt == mod.FF.WaitingDemonDoomer.Sub
					or subt == mod.FF.WaitingDemonLoki.Sub
					or subt == mod.FF.WaitingDemonImp.Sub
					or subt == mod.FF.WaitingDemonSpooter.Sub
					or subt == mod.FF.WaitingDemonTiyanak.Sub then
						sfx:Play(SoundEffect.SOUND_PORTAL_OPEN)
					end
				end
			end
		else
			npc.StateFrame = 0
		end
	elseif d.state == "emerge" then
		npc.Velocity = nilvector
		if sprite:IsFinished("Drop") then
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			d.alreadyAppliedLastJudgementAutoResprite = nil
			if subt == mod.FF.WaitingSpiderTicking.Sub then
				npc:Morph(250, 0, 95, -1)
			elseif subt == mod.FF.WaitingSpiderBLL.Sub then
				npc:Morph(206, 0, 95, -1)
			elseif subt == mod.FF.WaitingSpiderSBLL.Sub then
				npc:Morph(206, 1, 95, -1)
			elseif subt == mod.FF.WaitingSpiderCLL.Sub then
				npc:Morph(207, 0, 95, -1)
			elseif subt == mod.FF.WaitingSpiderSCLL.Sub then
				npc:Morph(207, 1, 95, -1)
			elseif subt == mod.FF.WaitingSpiderFull.Sub then
				npc:Morph(215, 710, 95, -1)
			elseif subt == mod.FF.WaitingDemonNull.Sub then
				npc:Morph(EntityType.ENTITY_NULLS, 0, 95, -1)
				npc:Update()
			elseif subt == mod.FF.WaitingDemonBK.Sub then
				npc:Morph(EntityType.ENTITY_BONE_KNIGHT, 0, 95, -1)
			elseif subt == mod.FF.WaitingDemonBG.Sub then
				npc:Morph(EntityType.ENTITY_BLACK_GLOBIN, 0, 95, -1)
			elseif subt == mod.FF.WaitingDemonDoomer.Sub then
				npc:Morph(mod.FF.Doomer.ID, mod.FF.Doomer.Var, 0, -1)
				d.init = false
			elseif subt == mod.FF.WaitingDemonLoki.Sub then
				npc:Morph(EntityType.ENTITY_LOKI, 0, 95, -1)
			elseif subt == mod.FF.WaitingDemonImp.Sub then
				npc:Morph(EntityType.ENTITY_IMP, 0, 95, -1)
			elseif subt == mod.FF.WaitingDemonSpooter.Sub then
				npc:Morph(mod.FF.SoulSpooter.ID, mod.FF.SoulSpooter.Var, 95, -1)
				sprite:Play("Idle", true)
				d.init = false
			elseif subt == mod.FF.WaitingDemonTiyanak.Sub then
				npc:Morph(mod.FF.Tiyanak.ID, mod.FF.Tiyanak.Var, 95, -1)
				mod:WaitingTiyanakInit(npc)
			else
				npc:Morph(215, 0, 95, -1)
			end
			mod:lastJudgementAutoResprite(npc)
		elseif sprite:IsEventTriggered("DMG") then
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		else
			mod:spritePlay(sprite, "Drop")
		end
	end

	if npc:IsDead() then
		if subt == mod.FF.WaitingSpiderTicking.Sub then
			Isaac.Explode(npc.Position, npc, 20)
		elseif subt == mod.FF.WaitingSpiderFull.Sub then
			local vec = RandomVector():Resized(8)
			for i = 60, 360, 60 do
				npc:FireProjectiles(npc.Position, vec:Rotated(i) + nilvector, 0, ProjectileParams())
			end
		end
	end
end

mod.garyVars = {
[0] = {1, false},
[1] = {2, false},
[2] = {3, false},
[3] = {2, true}
}

function mod:SetGaryHoleSprite(effect)
	local backdroptype = game:GetRoom():GetBackdropType()
	local suffix

	if mod.roomBackdrop == 10 then
		suffix = "morbus"
	elseif backdroptype == 15 then
		suffix = "cathedral"
	elseif backdroptype == 17 then
		suffix = "chest"
	elseif backdroptype == 10 then
		suffix = "womb"
	elseif backdroptype == 11 then
		suffix = "utero"
	elseif backdroptype == 12 then
		suffix = "scarredwomb"
	elseif backdroptype == 34 then
		suffix = "corpse_1"
	elseif backdroptype == 43 then
		suffix = "corpse_2"
	elseif backdroptype == 44 then
		suffix = "corpse_3"
	end

	if suffix then
		local sprite = effect:GetSprite()
		local path = "gfx/enemies/gary/garry_fillup_"..suffix..".png"
		sprite:ReplaceSpritesheet(0, path)
		sprite:ReplaceSpritesheet(1, path)
		sprite:LoadGraphics()
	end
end

function mod.SpawnWallHole(position, direction, fill, spritesheet)
    for i = 1, 2 do
        local wall = Isaac.Spawn(1000, 1733, 0, position + Vector(0, -4):Rotated(90 * direction), nilvector, npc):ToEffect()
        local wsprite = wall:GetSprite()
        local wdata = mod:GetEntityData(wall)

        if spritesheet then
            wsprite:ReplaceSpritesheet(0, spritesheet)
            wsprite:LoadGraphics()
        else
            mod:SetGaryHoleSprite(wall)
        end

        wsprite.Rotation = 90 * direction
        if i == 1 then
            if fill then
                wdata.RenderTo = EntityFlag.FLAG_RENDER_WALL
            else
                wall:AddEntityFlags(EntityFlag.FLAG_RENDER_WALL)
            end
        else
            if fill then
                wdata.RenderTo = EntityFlag.FLAG_RENDER_FLOOR
            else
				wall:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR)
            end
        end
        if fill then
            wsprite:Play('FillUp', true)
        else
            wsprite:SetFrame('FillUp', 0)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local data = mod:GetEntityData(eff)
	if not data.RenderTo then return end

	local sprite = eff:GetSprite()
	if sprite:IsFinished('FillUp') and sprite:GetFrame() > 0 then
		sprite:Play('IdleClosed', true)
		eff:AddEntityFlags(data.RenderTo)
	end
end, 1733)

function mod:garyAI(npc)
	local room = game:GetRoom()
	local sprite = npc:GetSprite()
	local d = mod:GetEntityData(npc)
	local target = npc:GetPlayerTarget()

	if not d.init then
		npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
		npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
		npc.Visible = false
		d.comeOutTime = math.random(200) + 50
		if npc.SubType == 1716 then
			sprite:ReplaceSpritesheet(0, 'gfx/enemies/gary/idpdvan.png')
			sprite:ReplaceSpritesheet(1, 'gfx/enemies/gary/idpdvan.png')
			sprite:ReplaceSpritesheet(2, 'gfx/enemies/gary/idpdvan.png')
			sprite:ReplaceSpritesheet(7, 'gfx/enemies/gary/idpdvan.png')
			sprite:LoadGraphics()
		end

		d.rot = 0
		for i = 0, 3 do
			local nextgrid = npc.Position + Vector(0, -40):Rotated(i * 90)
			if room:GetGridCollisionAtPos(nextgrid) == GridCollisionClass.COLLISION_WALL then
				d.rot = i
			end
		end

		if d.rot % 2 == 1 then
			npc:SetSize(npc.Size, Vector(2,1), 1)
		end

		--sprite.Rotation = 90 * d.rot
		sprite.FlipX = mod.garyVars[d.rot][2]

		npc.Position = npc.Position + Vector(0, -8):Rotated(90 * d.rot)

		d.state = "waiting"

		d.init = true
	elseif d.init then
		npc.StateFrame = npc.StateFrame + 1
	end

	if npc.State == 11 then
		if sprite:IsFinished("Exit0" .. mod.garyVars[d.rot][1]) then
			npc:BloodExplode()
			npc:Remove()

			if npc.SubType ~= 1716 then
                mod.SpawnWallHole(npc.Position, d.rot, true)
			end

		elseif sprite:IsEventTriggered("StopBlood") then
			d.nobleed = true
		else
			mod:spritePlay(sprite, "Exit0" .. mod.garyVars[d.rot][1])
			if npc.FrameCount % 3 == 0 and not d.nobleed then
				local blood = Isaac.Spawn(1000, 2, 1, npc.Position + Vector(0,1), nilvector, nil)
				blood.SpriteOffset = Vector(0, 5):Rotated(d.rot * 90) + RandomVector()*math.random(20)
				npc:PlaySound(SoundEffect.SOUND_MEAT_JUMPS,0.2,0,false,0.8)
			end
		end
	else
		if d.state == "waiting" then
			if (npc.SubType == 0 and npc.StateFrame > d.comeOutTime) or mod.CanIComeOutYet() then
				if npc.SubType == 1716 or mod.farFromAllPlayers(npc.Position, 60) then
					d.state = "emerge"
					sprite:Play("Emerge0" .. mod.garyVars[d.rot][1], true)
					npc.Visible = true
					if npc.SubType == 1716 then
						-- skip to the fun part
						for i = 1, 40 do
							sprite:Update()
						end
					end
				end
			end
		elseif d.state == "emerge" then
			npc.Velocity = nilvector
			if sprite:IsFinished("Emerge0" .. mod.garyVars[d.rot][1]) then
				d.state = "startspawn"
			elseif sprite:IsEventTriggered("ScreenShake") then
				game:ShakeScreen(10)
				npc:PlaySound(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND,0.3,0,false,math.random(110,120)/100)
			elseif sprite:IsEventTriggered("HoleAppear") then
                mod.SpawnWallHole(npc.Position, d.rot, nil, npc.SubType == 1716 and 'gfx/enemies/gary/idpdvan.png' or nil)
			elseif sprite:IsEventTriggered("RockGibs") then
				game:ShakeScreen(20)
				npc:PlaySound(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND,1,0,false,1)
				npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			else
				mod:spritePlay(sprite, "Emerge0" .. mod.garyVars[d.rot][1])
			end
		elseif d.state == "startspawn" then
			npc.Velocity = nilvector
			if sprite:IsFinished("SpawnStart0" .. mod.garyVars[d.rot][1]) then
				d.state = "spawnloop"
			elseif sprite:IsEventTriggered("StartSpawn") then
				d.spawning = true
				npc.StateFrame = 0
				npc:PlaySound(mod.Sounds.TemperAnger,1,0,false,1.2)
			else
				mod:spritePlay(sprite, "SpawnStart0" .. mod.garyVars[d.rot][1])
			end
		elseif d.state == "spawnloop" then
			npc.Velocity = nilvector
			mod:spritePlay(sprite, "SpawnLoop0" .. mod.garyVars[d.rot][1])
		elseif d.state == "endspawn" then
			npc.Velocity = nilvector
			if sprite:IsFinished("SpawnEnd0" .. mod.garyVars[d.rot][1]) then
				d.state = "idle"
				npc.StateFrame = 0
			elseif sprite:IsEventTriggered("EndSpawn") then
				d.spawning = false
			else
				mod:spritePlay(sprite, "SpawnEnd0" .. mod.garyVars[d.rot][1])
			end
		elseif d.state == "idle" then
			npc.Velocity = nilvector
			mod:spritePlay(sprite, "Idle0" .. mod.garyVars[d.rot][1])

			local count = 0
			if npc.SubType == 1716 then
				count = mod.GetEntityCount(mod.FF.IDPDGrunt.ID, mod.FF.IDPDGrunt.Var) + mod.GetEntityCount(mod.FF.IDPDInspector.ID, mod.FF.IDPDInspector.Var) + mod.GetEntityCount(mod.FF.IDPDShielder.ID, mod.FF.IDPDShielder.Var)
			else
				count = mod.GetMaggotCount()
			end
			d.randwait = d.randwait or 0
			local diff = d.maxspawns - count
			if npc.StateFrame >= 150 + d.randwait and count < d.maxspawns + 2 then
			--if count < d.maxspawns then
				d.state = "startspawn"
				d.numspawns = math.max(1, diff)
			end
		elseif d.state == "hole" then
			npc.Velocity = nilvector
			mod:spritePlay(sprite, "Hole")
		end

		if d.spawning then
			if npc.StateFrame % 15 == 1 then
				local extravec = Vector(0, 10):Rotated(90 * d.rot)
				local chosenpos = npc.Position + extravec:Resized(5):Rotated(-50 + math.random(100))
				if npc.SubType == 1716 then
					mod:SpawnIDPD(npc, chosenpos)
				else
					local maggot = Isaac.Spawn(mod.maggots[math.random(#mod.maggots)], 0, 0, chosenpos, extravec, npc):ToNPC()
					maggot:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					maggot:SetColor(Color(0.2,0.2,0.2,1,0,0,0),15,1,true,false)
					maggot:Update()
				end

				d.spawncount = (d.spawncount or 0) + 1

				local spawnsmoke = Isaac.Spawn(1000, 15, 0, chosenpos, nilvector, npc):ToEffect()
				spawnsmoke.Color = Color(1,1,1,0.2,0,0,0)
				spawnsmoke:Update()

				npc:PlaySound(SoundEffect.SOUND_SKIN_PULL,0.6,0,false,math.random(11,13)/10)

			end

			if not d.maxspawns then
				if npc.SubType == 1716 then
					d.maxspawns = 6
				else
					d.maxspawns = 3
				end
			end

			d.spawncount = d.spawncount or 0
			d.numspawns = d.numspawns or d.maxspawns
			if d.spawncount > d.numspawns - 1 then
				d.state = "endspawn"
				d.spawncount = 0
				d.randwait = mod:RandomInt(20,50)
			end
		end
	end
end

mod.maggots = {21, 21, 21, 23, 23, 31, 31, 243}

function mod:BASCOBLAST(e)
e:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
mod:spritePlay(e:GetSprite(), "Okay")
	if not mod:GetEntityData(e).no then
		mod:GetEntityData(e).no = true
		e.RenderZOffset = 20000
		sfx:Play(mod.Sounds.BascoBlast, 1, 0, false, 1)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.BASCOBLAST, 1732)

function mod:amnioticAI(npc, subt)
local room = game:GetRoom()
local d = mod:GetEntityData(npc)
local sprite = npc:GetSprite();
local target = npc:GetPlayerTarget()
	if not d.init then
		if math.random(2) == 1 then
			sprite.FlipX = true
		end
		npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET)
		d.init = true
		local room = game:GetRoom()

		local roomDat = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'amnioticSackData', tostring(game:GetLevel():GetCurrentRoomDesc().ListIndex), {})
		if roomDat[tostring(room:GetGridIndex(npc.Position))] then
			sprite:SetFrame("Blown", 0)
			npc:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR)
			return
		end
	end

	if npc.Variant == mod.FF.Miscarriage.Var then
		d.Miscarriage = true
		if subt == 1 then
			mod:spritePlay(sprite, "Wrinkly")
		elseif subt == 2 then
			mod:spritePlay(sprite, "Unborn")
		elseif subt == 3 then
			mod:spritePlay(sprite, "Maggots")
		else
			mod:spritePlay(sprite, "Empty")
		end
	else
		if subt == 1 then
			mod:spritePlay(sprite, "Random")
		elseif subt == 2 then
			mod:spritePlay(sprite, "Neonate")
		elseif subt == 3 then
			mod:spritePlay(sprite, "Baby")
		elseif subt == 4 then
			mod:spritePlay(sprite, "Embryo")
		else
			mod:spritePlay(sprite, "Empty")
		end
	end
	npc.Velocity = nilvector
	room:SetGridPath(room:GetGridIndex(npc.Position), 900)

	if npc:HasMortalDamage() then
		if not game:GetRoom():HasWater() then
			if d.Miscarriage then
				local creep = Isaac.Spawn(1000, 22, 0, npc.Position, nilvector, npc):ToEffect()
				creep.SpriteScale = creep.SpriteScale * 1.5
				creep:Update()
			else
				local creep = Isaac.Spawn(1000, 24, 0, npc.Position, nilvector, npc):ToEffect()
				creep.SpriteScale = creep.SpriteScale * 1.5
				creep:SetColor(Color(0,0,0,1,180 / 255,180 / 255,30 / 255), 0, 99999, true, false)
				creep:Update()
			end
		end

		--[[for i = 30, 360, 30 do
			local proj = mod:LazySpawnProjectile(0, 0, npc.Position, Vector(math.random(25,35)/10, 0):Rotated(i), npc):ToProjectile()
			proj.Scale = math.random(8,10)/10
			proj.Color = mod.ColorPiss
			proj.FallingSpeed = -20 + math.random(10)
			proj.FallingAccel = 1.5
			local pd = mod:GetEntityData(proj)
			pd.projType = "acidic piss"
		end]]
		if subt > 0 then
			local babspawn
			if d.Miscarriage then
				if subt == 1 then
					babspawn = {38, 3}
				elseif subt == 2 then
					babspawn = {EntityType.ENTITY_UNBORN, 0}
				elseif subt == 3 then
					for i = 1, math.random(4, 5) do
						mod.ThrowMaggot(npc.Position, RandomVector() * math.random(2, 5), -14, math.random(-15, -10), npc)
					end
				end
			else
				if subt == 1 then
					subt = math.random(3) + 1
				end
				if subt == 2 then
					babspawn = {mod.FF.Neonate.ID, mod.FF.Neonate.Var}
				elseif subt == 3 then
					babspawn = {38, 0}
				elseif subt == 4 then
					babspawn = {77, 0}
				end
			end

			if babspawn then
				local bab = Isaac.Spawn(babspawn[1],babspawn[2],0,npc.Position,nilvector,npc)
				bab:Update()
			end
		end
		sprite:SetFrame("Blown", 0)
		local sploshEffect = Isaac.Spawn(1000, 1738, 0, npc.Position, nilvector, npc):ToEffect()
		sploshEffect.SpriteOffset = npc.SpriteOffset
		sploshEffect:GetSprite():Load(sprite:GetFilename(),true)
		sploshEffect:Update()

		local roomDat = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'amnioticSackData', tostring(game:GetLevel():GetCurrentRoomDesc().ListIndex), {})
		roomDat[tostring(room:GetGridIndex(npc.Position))] = true
		npc:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR)
	end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	if eff.Timeout and eff.Timeout <= 0 and (not eff.Timeout == 0) then
		eff:Remove()
	end
end, EffectVariant.SMOKE_CLOUD)

function mod:fuegoAI(npc)
	if npc.FrameCount < 2 then
		npc.SplatColor = mod.ColorFireyFade
	end
	if npc.V1.X == -5 then
		--[[for _, fire in pairs(Isaac.FindByType(33, 10, 0, false, false)) do
			if fire.Position:Distance(npc.Position) < 5 then
				fire:Remove()
			end
		end
		local fire = Isaac.Spawn(33, 10, 0, npc.Position, nilvector, npc)
		fire.HitPoints = 2
		fire:Update()]]

		local fire = Isaac.Spawn(1000,7005, 0, npc.Position, nilvector, npc):ToEffect()
		mod:GetEntityData(fire).timer = 30
		mod:GetEntityData(fire).scale = 0.75
		mod:GetEntityData(fire).flamethrower = true
		fire:Update()
		fire.Parent = npc
		sfx:Stop(SoundEffect.SOUND_SPLATTER)
		npc:PlaySound(SoundEffect.SOUND_FIREDEATH_HISS, 0.18, 0, false, 2)
	end
	local d = mod:GetEntityData(npc)
	if npc.Velocity.X > 0 then
		if not d.flippedSprite then
			local sprite = npc:GetSprite()
			sprite:ReplaceSpritesheet(0, "gfx/enemies/fuego/monster_fuego_flippedHead.png")
			sprite:ReplaceSpritesheet(1, "gfx/enemies/fuego/monster_fuego_glow_flippedHead.png")
			sprite:LoadGraphics()
			d.flippedSprite = true
		end
	else
		if d.flippedSprite then
			local sprite = npc:GetSprite()
			sprite:ReplaceSpritesheet(0, "gfx/enemies/fuego/monster_fuego.png")
			sprite:ReplaceSpritesheet(1, "gfx/enemies/fuego/monster_fuego_glow.png")
			sprite:LoadGraphics()
			d.flippedSprite = false
		end
	end
end

function mod:checkFissure(npc)
local d = mod:GetEntityData(npc)
local room = game:GetRoom()
	if npc.Variant == 0 and not d.init then
		d.init = true
		if mod.fuegoSpawnPoints and mod.fuegoSpawnPoints[room:GetGridIndex(npc.Position)] then
			if room:HasWater() then
				npc:Remove()
			else
				npc:Morph(npc.Type, 960, npc.SubType, -1)
				npc.MaxHitPoints = 8
				npc.HitPoints = npc.MaxHitPoints
			end
		end
	end

	if npc.Variant == 960 then
		mod:fuegoAI(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkFissure, 815)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, effect)
	local room = game:GetRoom()
	if mod.fuegoSpawnPoints and mod.fuegoSpawnPoints[room:GetGridIndex(effect.Position)] then
		if not room:HasWater() then
			Isaac.Spawn(1000,16,66,effect.Position,Vector.Zero,nil)
		end
		effect.Visible = false
		effect:Remove()
	end
end, EffectVariant.WATER_RIPPLE)

function mod:checkFissureHurt(npc, damage, flag, source)
	if npc.Variant == 960 then
		if flag & DamageFlag.DAMAGE_FIRE ~= 0 and source.Type ~= 1 then
			return false
		end
	end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.checkFissureHurt, 815)

--ERFLYAI END--

--Guillotine21 ENEMIES

-- Honey eye AI
function mod:honeyeyeAI(npc)

  local sprite = npc:GetSprite()
  local data = mod:GetEntityData(npc)
  local target = npc:GetPlayerTarget()
  --[[local room = game:GetRoom()
  room:CheckLine(npc.Position, target.Position, 3, 1, false, false)]]

	if not data.Appeared then
		data.States = "Move"
		data.Appeared = true
		local randomposition = mod:FindRandomFreePosAirNoGrids(target.Position, 50, 200)
		data.targetvel = (randomposition - npc.Position):Resized(3)
	else
		npc.StateFrame = npc.StateFrame + 1
	end

	if data.States == "Move" then
		sprite:Play("Fly")
		if npc.Position:Distance(target.Position) <= 50 and not npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
			data.targetvel = (target.Position - npc.Position):Resized(-6)
			data.Run = true
		else
			if npc.StateFrame % 30 == 0 or data.Run then
				local randomposition = mod:FindRandomFreePosAirNoGrids(target.Position, 50, 200)
				data.targetvel = (randomposition - npc.Position):Resized(4.5)
				data.Run = false
			end
		end
		npc.Velocity = mod:Lerp(npc.Velocity, data.targetvel, 0.075)
		  if npc.Position:Distance(target.Position) <= 285 and npc.StateFrame >= 85 and not (npc:HasEntityFlags(EntityFlag.FLAG_FEAR) or npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION)) then
		   data.States = "Attack"
		  end
	elseif data.States == "Attack" then
		npc.Velocity = npc.Velocity * 0.95
		sprite:Play("Shoot")
		   if sprite:IsEventTriggered("Shoot") then
			local shotspeed = (target.Position - npc.Position)*0.05
			if shotspeed:Length() > 10 then
				shotspeed = shotspeed:Resized(10)
			end
			npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,1,2,false,1)
			local projectile = mod:LazySpawnProjectile(0, 0, npc.Position, shotspeed, npc):ToProjectile()
			projectile.FallingSpeed = -25
			projectile.FallingAccel = 1.5
			projectile.Scale = projectile.Scale * 2
			mod:GetEntityData(projectile).projType = "HoneyCreep"
			projectile.SplatColor = FiendFolio.ColorHoneyYellow
			projectile.Color = FiendFolio.ColorHoneyYellow
			projectile:Update()
		   end
		if sprite:IsFinished("Shoot") then
		 data.States = "Move"
		 npc.StateFrame = 0
		end
	end

end

-- Smogger AI
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
	if npc.Variant == mod.FF.Smogger.Var then

		local target = npc:GetPlayerTarget()
		local sprite = npc:GetSprite()
		local angle = (target.Position - npc.Position):GetAngleDegrees()
		local data = mod:GetEntityData(npc)
		local room = game:GetRoom()
		local path = npc.Pathfinder

		if not data.init then
			npc.SplatColor = mod.ColorCharred
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
			npc.V1 = Vector(30, npc.V1.Y)
			npc.SpriteOffset = Vector(0, -2)
			data.Burning = 0
			data.DarkRedChampionDeaths = 0
			data.init = true
		end


		if npc.FrameCount > 1 then
			if data.Burning > 0 and npc.State ~= 25 then
				npc.Velocity = nilvector
				npc.State = 25
			end

		-- Idle State
			if npc.State == 4 or npc.State == 8 then
				sprite:Play("WalkBody")
				if npc.State ~= 8 then
					sprite:PlayOverlay("HeadWalk")
				end
				local fire
				fire = mod.FindClosestFire(npc.Position, 99999)
				if fire then
					if npc.Position:Distance(fire.Position) <= npc.Size * 2 then
						data.Burning = 1
					end
				end
			end

		-- Attack State
			if sprite:IsOverlayPlaying("HeadAttack") and sprite:GetOverlayFrame() < 1 then
				npc.V1 = Vector(math.random(130, 150), npc.V1.Y)
			end

		-- Burning State
			if data.Burning > 0 then
				npc.V1 = Vector(140, npc.V1.Y)
			end

			if npc.State == 25 then
				if data.Burning == 2 then

					sprite:PlayOverlay("HeadFlame")
					npc:AnimWalkFrame("WalkFlame","WalkFlame",0)
					if sprite:GetAnimation() == "WalkFlame" then
						sprite:Play("WalkFlame")
					end

					local targetpos = mod:confusePos(npc, target.Position)
					data.targetvelocity = mod:reverseIfFear(npc, (targetpos - npc.Position):Resized(4.5))
					npc.Velocity = mod:Lerp(data.targetvelocity, npc.Velocity, 0.8)
					--[[if room:CheckLine(npc.Position,targetpos,0,1,false,false) or mod:isScare(npc) then
						data.targetvelocity = mod:reverseIfFear(npc, (targetpos - npc.Position):Resized(5.25))
						npc.Velocity = mod:Lerp(data.targetvelocity, npc.Velocity, 0.8)
					else
						 mod:CatheryPathFinding(npc, targetpos, {
							Speed = 5.25,
							Accel = 0.2,
							GiveUp = true
						 })
					end]]
					if npc.FrameCount % 5 == 0 then
						local fire = Isaac.Spawn(1000,7005, 20, npc.Position, Vector.Zero, npc):ToEffect()
						mod:GetEntityData(fire).timer = 10
						mod:GetEntityData(fire).gridcoll = 0
						mod:GetEntityData(fire).scale = 0.5
						fire.Parent = npc
						fire:Update()
					end
				elseif data.Burning == 1 then
					sprite:Play("Burning")
					sprite:RemoveOverlay()
					if sprite:IsEventTriggered("Burning") then
						npc.SplatColor = mod.ColorFireyFade
						npc.HitPoints = npc.HitPoints * 1.25
						npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
						sfx:Play(SoundEffect.SOUND_FLAMETHROWER_END, 1, 0, false, 1)
							if npc:GetChampionColorIdx() == 19 or npc:GetChampionColorIdx() == 23 then
							npc.CollisionDamage = 4
							elseif npc:IsChampion() then
							npc.CollisionDamage = 2
							else
							npc.CollisionDamage = 1
							end
						data.flaming = true
					end
					if sprite:IsFinished("Burning") then
						data.Burning = 2
						sprite:SetOverlayFrame("HeadFlame",0)
					end
				end
			end
		end

		-- Death
		if npc:IsDead() and mod:shouldDoDeathEffect(npc) then
			if data.flaming then
				data.Burning = 2
				if data.DarkRedChampionDeaths < 1 then
					Isaac.Spawn(33, 10, 0, npc.Position, nilvector, npc)
				end
				data.DarkRedChampionDeaths = data.DarkRedChampionDeaths + 1
			else
				local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, npc.Position, nilvector, npc)
				smoke.SpriteScale = Vector(3,3)
				smoke.SpriteOffset = Vector(0, -25)
				smoke:Update()
				local vec = (RandomVector()*20)
				for i = 1, 3 do
					mod.SpawnGunpowder(npc,npc.Position + vec:Rotated(360/3 * i - 15 + math.random(30)):Resized(math.random(5,20)), 300, 150)
				end
				for i = 1, 5 do
					mod.SpawnGunpowder(npc,npc.Position + vec:Rotated(360/5 * i - 15 + math.random(30)):Resized(math.random(25,50)), 300, 150)
				end
			end
		end

	end
end, mod.FF.Smogger.ID)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, damage, flag, source)
	if npc.Variant == mod.FF.Smogger.Var then
		if flag & DamageFlag.DAMAGE_FIRE ~= 0 and source.Type ~= 1 then
			if mod:GetEntityData(npc).Burning == 0 then
				mod:GetEntityData(npc).Burning = 1
			end
			return false
		end
	end
end, mod.FF.Smogger.ID)

mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, function(_, npc, collider)
	if npc.Variant == mod.FF.Smogger.Var then
		if collider.Type == EntityType.ENTITY_LITTLE_HORN and collider.Variant == 1 then
			return true
		end
	end
end, mod.FF.Smogger.ID)

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc) -- Remove or replace leeches
	if npc.SpawnerType == mod.FF.Smogger.ID and npc.SpawnerVariant == mod.FF.Smogger.Var then
		if npc.SpawnerEntity:IsDead() then
			npc:Remove()
		else
			npc:Morph(EntityType.ENTITY_LITTLE_HORN, 1, 0, -1)
			npc.MaxHitPoints = npc.MaxHitPoints / 2
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
		end
	end
end, EntityType.ENTITY_SMALL_LEECH)

-- Champion Bosses

function mod:checkFistula(npc)
	if npc.Variant == 1 then
		if npc:GetBossColorIdx() == mod.FF.FuzzyTeratomaBig.IDx then
			mod:FuzzyTeratoma(npc)
		elseif npc:GetBossColorIdx() == mod.FF.CornyTeratomaBig.IDx then
			mod:CornyTeratomaAI(npc)
		end
	elseif npc.Variant == 0 and npc:GetBossColorIdx() == mod.FF.BeehiveFistulaBig.IDx then
		mod:BeeHiveFistula(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkFistula, EntityType.ENTITY_FISTULA_BIG)
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkFistula, EntityType.ENTITY_FISTULA_MEDIUM)
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkFistula, EntityType.ENTITY_FISTULA_SMALL)

--[[function mod:checkFistulaInit(npc)
	local data = mod:GetEntityData(npc)
	if (npc.Type == EntityType.ENTITY_FISTULA_BIG or npc.Type == EntityType.ENTITY_FISTULA_MEDIUM or npc.Type == EntityType.ENTITY_FISTULA_SMALL) then
		if npc.Variant == 1 and npc:GetBossColorIdx() == mod.FF.FuzzyTeratomaBig.IDx then
			if npc.SpawnerType == 78 and npc.Variant == 1 then
				--data.IsItLivesSpawn = true
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.checkFistulaInit)]]

function mod:checkForsaken(npc)
	if npc.Variant == mod.FF.RedForsaken.Var and npc:GetBossColorIdx() == mod.FF.RedForsaken.IDx then
		mod:RedForsaken(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkForsaken, EntityType.ENTITY_FORSAKEN)

-- Beehive Fistula
function mod:BeeHiveFistula(npc)
	npc.Velocity = npc.Velocity * 0.985
	if npc:IsDead() then
		local honeycolor = Color(1,1,1,1,0,0,0)
		honeycolor:SetColorize(5.5, 3.5, 1, 1)
			local creep = Isaac.Spawn(1000, EffectVariant.CREEP_BROWN, 0, npc.Position, Vector(0,0), npc):ToEffect()
				if npc.Type == EntityType.ENTITY_FISTULA_BIG then
					local BeehiveFistulaCheck = false
					for _, MediumFistula in ipairs(Isaac.FindByType(EntityType.ENTITY_FISTULA_MEDIUM, 0, mod.FF.BeehiveFistulaMedium.Sub, false, false)) do
						if MediumFistula.SpawnerEntity then
							if MediumFistula.SpawnerType == EntityType.ENTITY_FISTULA_BIG and MediumFistula.SpawnerVariant == 0 and MediumFistula.Position:Distance(npc.Position) < 30 and MediumFistula.FrameCount < 1 and BeehiveFistulaCheck == false and MediumFistula.SpawnerEntity.InitSeed == npc.InitSeed then
								MediumFistula:Remove()
								BeehiveFistulaCheck = true
							end
						end
					end
					creep.SpriteScale = Vector(4, 3.5)
				elseif npc.Type == EntityType.ENTITY_FISTULA_MEDIUM then
					creep.SpriteScale = Vector(2, 1.25)
					creep.Scale = creep.Scale * 1.35
				elseif npc.Type == EntityType.ENTITY_FISTULA_SMALL then
					creep.SpriteScale = Vector(1.25, 1)
					creep.Scale = creep.Scale * 1.35
				end
			creep:SetTimeout(creep.Timeout + 95)
			creep:Update()
			creep:GetSprite().Color = honeycolor
	end
end

-- Fuzzy Teratoma
function mod:FuzzyTeratoma(npc)

	if npc.SubType == 1 then -- This part of code is specifically there to check whether champion's subtype is 1 or not, because the first Teratoma champion added by a mod has black Fistula's speed.
		npc.Velocity = npc.Velocity * 1.0675
	else
		npc.Velocity = npc.Velocity * 0.97475
	end

	local data = mod:GetEntityData(npc)
	if not data.Appeared then
		data.SkuzzYOffset = 0
		data.Appeared = true
	end

	if npc:IsDead() then

		if data.IsItLivesSpawn then
			local FuzzyTeratomaCheckBig = 0
			local FuzzyTeratomaCheckMedium = 0
			for _, MediumTeratoma in ipairs(Isaac.FindByType(EntityType.ENTITY_FISTULA_MEDIUM, 1, mod.FF.FuzzyTeratomaMedium.Sub, false, false)) do
				if MediumTeratoma.SpawnerEntity then
					if MediumTeratoma.SpawnerType == EntityType.ENTITY_FISTULA_BIG and MediumTeratoma.SpawnerVariant == 1 and MediumTeratoma.Position:Distance(npc.Position) < 30 and MediumTeratoma.FrameCount < 1 and FuzzyTeratomaCheckBig < 3 and MediumTeratoma.SpawnerEntity.InitSeed == npc.InitSeed then
						mod:GetEntityData(MediumTeratoma).IsItLivesSpawn = true
						FuzzyTeratomaCheckBig = FuzzyTeratomaCheckBig + 1
					end
				end
			end
			for _, SmallTeratoma in ipairs(Isaac.FindByType(EntityType.ENTITY_FISTULA_SMALL, 1, mod.FF.FuzzyTeratomaSmall.Sub, false, false)) do
				if SmallTeratoma.SpawnerEntity then
					if SmallTeratoma.SpawnerType == EntityType.ENTITY_FISTULA_MEDIUM and SmallTeratoma.SpawnerVariant == 1 and SmallTeratoma.Position:Distance(npc.Position) < 30 and SmallTeratoma.FrameCount < 1 and FuzzyTeratomaCheckMedium < 2 and SmallTeratoma.SpawnerEntity.InitSeed == npc.InitSeed then
						mod:GetEntityData(SmallTeratoma).IsItLivesSpawn = true
						FuzzyTeratomaCheckMedium = FuzzyTeratomaCheckMedium + 1
					end
				end
			end
		end

		if data.IsItLivesSpawn then
				local creep = Isaac.Spawn(1000, EffectVariant.CREEP_WHITE, 0, npc.Position, Vector(0,0), npc):ToEffect()
					if npc.Type == EntityType.ENTITY_FISTULA_BIG then
						creep.SpriteScale = Vector(4, 3.5)
					elseif npc.Type == EntityType.ENTITY_FISTULA_MEDIUM then
						creep.SpriteScale = Vector(2, 1.25)
						creep.Scale = creep.Scale * 1.35
					elseif npc.Type == EntityType.ENTITY_FISTULA_SMALL then
						creep.SpriteScale = Vector(1.25, 1)
						creep.Scale = creep.Scale * 1.35
					end
				creep:SetTimeout(creep.Timeout + 95)
				creep:Update()
		else
				local checkGrid = room:GetGridEntityFromPos(npc.Position)
				if npc.Type == 71 or npc.Type == 72 or npc.Type == 73 then
					if not checkGrid or checkGrid:GetType() ~= 20 then
						Isaac.GridSpawn(10, 0, npc.Position, true)
					end
				end
				if npc.Type == 72 then
					if npc:GetDropRNG():RandomInt(2) == 1 then
						for i = 180, 360, 180 do
							checkGrid = room:GetGridEntityFromPos(npc.Position + Vector(0, 40):Rotated(i))
							if not checkGrid or checkGrid:GetType() ~= 20 then
								Isaac.GridSpawn(10, 0, npc.Position + Vector(0, 40):Rotated(i), true)
							end
						end
					else
						for i = 180, 360, 180 do
							checkGrid = room:GetGridEntityFromPos(npc.Position + Vector(40, 0):Rotated(i))
							if not checkGrid or checkGrid:GetType() ~= 20 then
								Isaac.GridSpawn(10, 0, npc.Position + Vector(40, 0):Rotated(i), true)
							end
						end
					end
				end
				if npc.Type == 71 then
					for i = 90, 360, 90 do
						checkGrid = room:GetGridEntityFromPos(npc.Position + Vector(40, 0):Rotated(i))
						if not checkGrid or checkGrid:GetType() ~= 20 then
							Isaac.GridSpawn(10, 0, npc.Position + Vector(40, 0):Rotated(i), true)
						end
					end
				end
		end
			if npc.Type == 73 then
				local FuzzyTeratomaCheckSmall = 0
				for _, Spider in ipairs(Isaac.FindByType(85, 140, 0, false, false)) do
					if Spider.SpawnerEntity then
						if FuzzyTeratomaCheckSmall < 2 and Spider.SpawnerEntity.InitSeed == npc.InitSeed then
							mod.ThrowSkuzz(npc.Position, mod:chooserandomlocationforskuzz(npc, 80, 320, false), npc, 0 + data.SkuzzYOffset)
							data.SkuzzYOffset = data.SkuzzYOffset - 40
							if data.SkuzzYOffset <= -80 then
								data.SkuzzYOffset = 0
							end
							Spider:Remove()
						end
					end
				end
			end


	end
end

-- Red Forsaken
function mod:RedForsaken(npc)

	local sprite = npc:GetSprite()
	local data = mod:GetEntityData(npc)
	local target = npc:GetPlayerTarget()
	local rng = npc:GetDropRNG()

	if not data.Appeared then
		if LastJudgementSprites then
            sprite:Load("gfx/bosses/champions/forsaken/red_forsaken_lj.anm2", true)
			if npc:ToDelirium() or (npc.SpawnerEntity and npc.SpawnerEntity:ToDelirium()) then
				for i=0, 4 do
					mod:ReplaceEnemySpritesheet(npc, "gfx/bosses/afterbirthplus/deliriumforms/afterbirth/theforsaken", i)
				end
			end
        end
		npc.SplatColor = mod.ColorNormal
		data.Angle = Vector(0,0)
		data.Countdown = 8
		data.Attacking = false
		data.AttackDir = 0
		data.Appeared = true
	end

	if npc.State == 8 then

		if sprite:IsEventTriggered("Shoot") then
			data.Angle = (target.Position - npc.Position):GetAngleDegrees()
			if rng:RandomInt(2) == 1 then
				data.AttackDir = 1
			else
				data.AttackDir = -1
			end
			data.Attacking = true

			--If this comes back to haunt us eventually I'm sorry
			--It checked for red forsakens but in my IDx shift I made it just check forsakens in general
			if #Isaac.FindByType(mod.FF.RedForsaken.ID, mod.FF.RedForsaken.Var, mod.FF.RedForsaken.IDx+1, false, false) > 1 then -- The code to account for more than one red Forsaken.
				for _, RedForsakens_InRoom in ipairs(Isaac.FindByType(mod.FF.RedForsaken.ID, mod.FF.RedForsaken.Var, mod.FF.RedForsaken.IDx+1, false, false)) do
					if RedForsakens_InRoom:Exists() then
						if data.AttackDir ~= mod:GetEntityData(RedForsakens_InRoom).AttackDir and mod:GetEntityData(RedForsakens_InRoom).AttackDir ~= 0 then
							data.AttackDir = mod:GetEntityData(RedForsakens_InRoom).AttackDir
						end
					end
				end
			end

		end

		if data.Attacking and not sprite:IsPlaying("BlastEnd") then

			data.Countdown = data.Countdown - 1
			if data.Countdown <= 0 then
				local params = ProjectileParams()
				params.Scale = params.Scale * 1.4
				params.Damage = 1
				params.BulletFlags = params.BulletFlags | ProjectileFlags.HIT_ENEMIES
				if data.AttackDir == 1 then
					params.BulletFlags = params.BulletFlags | ProjectileFlags.CURVE_RIGHT
				elseif data.AttackDir == -1 then
					params.BulletFlags = params.BulletFlags | ProjectileFlags.CURVE_LEFT
				end
				params.CurvingStrength = params.CurvingStrength + 0.002 --0.00125 - 0.0015
				params.FallingAccelModifier = params.FallingAccelModifier - 0.0625 --0.05 - 0.055 - 0.06 - 0.65 - 0.75 - 0.08
				for i = 1, 2 do
					npc:FireProjectiles(npc.Position, Vector.FromAngle((i * 180) + (data.Angle - 90)):Resized(10), 0, params) --Resized(11) - Resized(11.5) - Resized(12)
				end
				data.Angle = data.Angle + (18.75 * data.AttackDir) --12.5 - 18
				data.Countdown = 8
			end

		end

	end

	if sprite:IsFinished("BlastEnd") then
		data.Attacking = false
		data.Countdown = 8
		data.AttackDir = 0
	end

end

function mod:RedForsakenDeath()
	for _, RedForsaken in ipairs(Isaac.FindByType(mod.FF.RedForsaken.ID, mod.FF.RedForsaken.Var, mod.FF.RedForsaken.IDx+1, false, false)) do
		if RedForsaken:GetSprite():IsEventTriggered("Explosion") and not mod:GetEntityData(RedForsaken).ProjectileOnDeath then
			local angle = math.random(360)
			for i = 1, 6 do
				local params = ProjectileParams()
				params.Scale = params.Scale * 1.4
				params.Damage = 1
				RedForsaken:ToNPC():FireProjectiles(RedForsaken.Position, Vector.FromAngle((i * 60) + angle):Resized(10), 0, params)
			end
			mod:GetEntityData(RedForsaken).ProjectileOnDeath = true
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.RedForsakenDeath)


--Mini - AI

--function for poopy enemies occasionaly spawning flies
function mod:rancid(npc, lowerbound, upperbound, tablemax, flytable)
	if flytime == nil then
		flytime = math.random(lowerbound,upperbound)
	elseif flytime <= 0 then
		local flycheck = math.random(1,tablemax);
		Isaac.Spawn(EntityType.ENTITY_EFFECT, flytable[flycheck], 0, npc.Position, Vector(0,0), npc);
		flytime = math.random(lowerbound,upperbound)
	end
	flytime = flytime - 1;
end

--splattering behavior for soft serve
function mod:softservesplatter(npc, dipnumber)
	local isDross = mod:CheckStage("Dross", {45})
	npc:PlaySound(SoundEffect.SOUND_PLOP,1,1,false,math.random(6, 9) / 10)
	--spawn dips
	dipnumber = dipnumber or math.random(1,2);
	for i = 1, dipnumber, 1 do
		local id = 217
		local var = 2
		if isDross then
			id = 870
			var = 0
		end
		--mod.cheekyspawn(npc.Position, npc, (npc.Position) + (RandomVector()*20), 217, 2, 0, mod.ColorBrowniePoop);
		local dip = mod.spawnent(npc, npc.Position, RandomVector()*2, id, var)
		if isDross then
			local sprite = dip:GetSprite()
			sprite:ReplaceSpritesheet(0, "gfx/monsters/repentance/floater_turdlet.png")
			sprite:LoadGraphics()
		end
	end
	--big ol puddle of creep
	local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_SLIPPERY_BROWN, 0, npc.Position, Vector(0,0), npc):ToEffect();
	creep.SpriteScale = Vector(5, 4);
	creep:Update();
	--spawn tears
	local tearnumber = math.random(4,8);
	for I = 1, tearnumber, 1 do
		local corncheck = math.random(1,5);
		if corncheck ~= 5 or (isDross and not (npc.Type == mod.FF.CornyTeratomaBig.ID and npc.Variant == mod.FF.CornyTeratomaBig.Var and npc:GetBossColorIdx() == mod.FF.CornyTeratomaBig.IDx)) then
			--normal tear
			--note : WE CAN DEAL WITH THE FUCKIN SPLAT BEING RED LATER BECAUSE I HAVE NO IDEA HOW THE F U C K REV GOT IT WORKING
			local projectile = mod:LazySpawnProjectile(ProjectileVariant.PROJECTILE_PUKE, 0, npc.Position, (RandomVector()*(math.random()+math.random(5,12))), npc):ToProjectile();
			local projdata = mod:GetEntityData(projectile);
			projectile.FallingSpeed = -(math.random(6,15));
			projectile.FallingAccel = math.random(7,13)/10;
			projdata.creeptype = "brown";
			projdata.creepsize = Vector(0.6,0.5);
			projectile:GetSprite():LoadGraphics();
			projectile.SplatColor = mod.ColorBrowniePoop;
		else
			--corn tear, for funsies
			local projectile = mod:LazySpawnProjectile(ProjectileVariant.PROJECTILE_CORN, 0, npc.Position, (RandomVector()*(math.random()+math.random(3,8))), npc):ToProjectile();
			local projdata = mod:GetEntityData(projectile);
			projectile.FallingSpeed = -(math.random(12,20));
			projectile.FallingAccel = math.random(7,10)/10;
			projdata.creeptype = "brown";
			projdata.wormchance = Vector(1,4);
			projdata.wormchecknumber = 2;
			projdata.flychance = Vector(1,2);
		end
	end
	--insects
	local bugnumber = math.random(1,3);
	for I = 1, bugnumber, 1 do
		local bugcheck = math.random(1,6);
		Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.bugtable[bugcheck], 0, npc.Position, (RandomVector()*(math.random()+math.random(5,12))), npc);
	end
	--worms
	bugnumber = math.random(1,2);
	for I = 1, bugnumber, 1 do
		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WORM, 0, npc.Position, Vector(0,0), npc);
	end
end

--takin a stab at this
function mod:weaverminiAI(npc,sprite,npcdata)
	if npcdata.init == false then
		npcdata.groundstate = "under"
		npcdata.timeaboveground = 0
		npcdata.init = true
	end
	--if underground, go towards the target and jump out when velocity high enough to intersect while leaping and in a generally good angle, LEAP
	if npcdata.groundstate == "under" then
		local target = npc:GetPlayerTarget()
		lustymove(npc, npcdata, target, 0.5, 3)
		--the hard part: checkin if hes actually gonna leap
		local velocityangle = 0;
		if npc.Velocity.X == 0 then
			velocityangle = 0;
		else
			velocityangle = math.atan((npc.Velocity.Y)/(npc.Velocity.X));
			velocityangle = math.deg(velocityangle);
		end
		local playerangle = GetAngleDegrees(npc.Position, target)
		local distanceplayer = Distance(npc.Position, target)
		local velocitytotal = math.sqrt(((npc.Velocity.X)^2)+((npc.Velocity.Y)^2));
		if (velocityangle <= playerangle - 15) and (velocityangle >= playerangle - 15) and (distanceplayer <= velocitytotal * 50) then
			npcdata.groundstate = "over"
		end
	--leap following a parabolic arc
	elseif npcdata.groundstate == "over" then
		npcdata.timeaboveground = npcdata.timeaboveground + 1
		--npc.SpriteOffset = Vector(0, (-0.048((npcdata.timeaboveground) - 25)) + 30)
		if npc.SpriteOffset <= 0 then
			npcdata.groundstate = "under"
			npcdata.timeaboveground = 0
		end
	end
end

--weh... tubbyai
function mod:wehai(npc, sprite, npcdata)
	local target = npc:GetPlayerTarget()
	local randangle = 0
	Isaac.DebugString(npc.State)
	if npcdata.stomps == nil then
		npcdata.stomps = 0
	end
	if sprite:IsEventTriggered("Shoot") then
		local bubblenumber = math.random(3,6)
		for i = 1, bubblenumber, 1 do
			randangle = math.random(0,359)
			mod.ShootBubble(npc, -1, npc.Position + Vector(5,0):Rotated(randangle),Vector((math.random(30,40)/10),0):Rotated(randangle))
		end
	elseif (sprite:IsEventTriggered("StompLeft") and not sprite.FlipX) or (sprite:IsEventTriggered("StompRight") and sprite.FlipX) then
	local effect = Isaac.Spawn(1000,7002,0,npc.Position+Vector(-26,-5),nilvector,nil)
	npc:PlaySound(mod.Sounds.SplashSmall,2.5,0,false,1)
		local tearnumber = math.random(3,6)
		for i = 1, tearnumber, 1 do
			randangle = math.random(60) - 30
			rotval = ((360 / tearnumber) * i) + randangle
			local projectile = mod:LazySpawnProjectile(4, 0, npc.Position+Vector(-23,0), Vector(math.random() * math.random(5,7), 0):Rotated(rotval), npc):ToProjectile();
			local projdata = mod:GetEntityData(projectile);
			projectile.FallingSpeed = -(math.random(6,15));
			projectile.FallingAccel = math.random(7,13)/10;
		end
	elseif (sprite:IsEventTriggered("StompLeft") and sprite.FlipX) or (sprite:IsEventTriggered("StompRight") and not sprite.FlipX) then
		local effect = Isaac.Spawn(1000,7002,0,npc.Position+Vector(24,-5),nilvector,nil)
		npc:PlaySound(mod.Sounds.SplashSmall,2.5,0,false,1)
		local tearnumber = math.random(3,6)
		for i = 1, tearnumber, 1 do
			randangle = math.random(60) - 30
			rotval = ((360 / tearnumber) * i) + randangle
			local projectile = mod:LazySpawnProjectile(4, 0, npc.Position+Vector(23,0), Vector(math.random(20, 100)/100 * math.random(5,7), 0):Rotated(rotval), npc):ToProjectile();
			local projdata = mod:GetEntityData(projectile);
			projectile.FallingSpeed = -(math.random(6,15));
			projectile.FallingAccel = math.random(7,13)/10;
		end
	end
	--Not needed??
	--[[if sprite:GetFrame() == 1 and ( sprite:IsPlaying("AttackVert") or sprite:IsPlaying("AttackHori") ) then
		local randnum = math.random(1,3)
		if randnum == 1 then
			sprite:Play("StompStart", 1)
		end
	end]]
	if npc.State == 4 then
		local targdist = npc.Position:Distance(target.Position)
		--Isaac.DebugString(targdist)
		local ranval = math.max(2, math.ceil(targdist / 3))
		if targdist < 120 and math.random(ranval) == 1 and not mod:isScareOrConfuse(npc) then
			npc.State = 8
			sprite:Play("StompStart", 1)
		end
	end
	if sprite:IsEventTriggered("stompendloopcheck") then
		local randnum = math.random(1,3)
		if (randnum + npcdata.stomps) >= 4 then
			npcdata.stomps = 0
			npc.State = 4
		else
			npcdata.stomps = npcdata.stomps + 1
			sprite:Play("StompLoop", 1)
		end
	end
end

function mod:nimbusai(npc, sprite, npcdata)
	local target = npc:GetPlayerTarget()
	--walk anim init
	if npcdata.horicheck == nil then
		npcdata.horicheck = true
		npcdata.walkleft = false
		npcdata.walkframe = 0
		npcdata.firing = "none"
		npcdata.cloudtimer = math.random(60, 120)
	end
	--check walking direction
	if npcdata.horicheck == true then
		if sprite:IsPlaying("Move Hori") then
			if npc.Velocity.X < 0 then
				npcdata.walkleft = true
			end
		end
		npcdata.horicheck = false
	end
	--play the fucking walk anim aaaaaaaaa
	if npcdata.walkleft == true then
		sprite:SetFrame("Move Hori 2", npc.FrameCount % 22)
		npcdata.walkframe = npcdata.walkframe + 0
		if npcdata.walkframe >= 22 then
			npcdata.walkframe = 0
		end
	end
	if not (sprite:IsPlaying("Move Hori") or sprite:IsPlaying("Move Hori 2")) then
		npcdata.horicheck = true
		npcdata.walkframe = 0
		npcdata.walkleft = false
	end
	--handle angle
	local anglebetween = (target.Position - npc.Position):GetAngleDegrees()
	if anglebetween <= -175 or anglebetween >= 175 then
		npcdata.anglecheck = 180
	elseif anglebetween <= 95 and anglebetween >= 85 then
		npcdata.anglecheck = 270
	elseif anglebetween <= 5 and anglebetween >= -5 then
		npcdata.anglecheck = 0
	elseif anglebetween <= -85 and anglebetween >= -95 then
		npcdata.anglecheck = 90
	else
		npcdata.anglecheck = 666
	end
	--get it to fire the
	local distancebetween = (target.Position - npc.Position):Length()
	local maxdistance = 150
	npcdata.cloudtimer = npcdata.cloudtimer - 1
	if npc.State == 4 then
		if npcdata.cloudtimer <= 0 and not (npc:HasEntityFlags(EntityFlag.FLAG_FEAR) or npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION)) then
			if sprite:IsPlaying("Move Down") then
				if npcdata.anglecheck == 270 then
					npcdata.firing = "down"
					npc.State = 10
					npc.Velocity = Vector(0,0)
				elseif distancebetween <= maxdistance then
					if npcdata.anglecheck == 0 then
						npcdata.firing = "right"
						npc.State = 10
						npc.Velocity = Vector(0,0)
					elseif npcdata.anglecheck == 180 then
						npcdata.firing = "left"
						npc.State = 10
						npc.Velocity = Vector(0,0)
					end
				end
			elseif sprite:IsPlaying("Move Up") then
				if npcdata.anglecheck == 90 then
					npcdata.firing = "up"
					npc.State = 10
					npc.Velocity = Vector(0,0)
				elseif distancebetween <= maxdistance then
					if npcdata.anglecheck == 0 then
						npcdata.firing = "right"
						npc.State = 10
						npc.Velocity = Vector(0,0)
					elseif npcdata.anglecheck == 180 then
						npcdata.firing = "left"
						npc.State = 10
						npc.Velocity = Vector(0,0)
					end
				end
			elseif sprite:IsPlaying("Move Hori") then
				if npcdata.anglecheck == 0 then
					npcdata.firing = "right"
					npc.State = 10
					npc.Velocity = Vector(0,0)
				elseif distancebetween <= maxdistance then
					if npcdata.anglecheck == 270 then
						npcdata.firing = "down"
						npc.State = 10
						npc.Velocity = Vector(0,0)
					elseif npcdata.anglecheck == 90 then
						npcdata.firing = "up"
						npc.State = 10
						npc.Velocity = Vector(0,0)
					end
				end
			end
			if npc.Velocity.X < 0 then
				if math.abs(npc.Velocity.X) > math.abs(npc.Velocity.Y) then
					if npcdata.anglecheck == 180 then
						npcdata.firing = "left"
						npc.State = 10
						npc.Velocity = Vector(0,0)
					elseif distancebetween <= maxdistance then
						if npcdata.anglecheck == 270 then
							npcdata.firing = "down"
							npc.State = 10
							npc.Velocity = Vector(0,0)
						elseif npcdata.anglecheck == 90 then
							npcdata.firing = "up"
							npc.State = 10
							npc.Velocity = Vector(0,0)
						end
					end
				end
			end
		end
	end
	--play the anim
	if npc.State == 10 then
		npc.Velocity = mod:Lerp(npc.Velocity, Vector(0,0), 0.2)
		if npcdata.firing == "down" then
		mod:spritePlay(sprite, "Shoot Down")
		elseif npcdata.firing == "up" then
		mod:spritePlay(sprite, "Shoot Up")
		elseif npcdata.firing == "right" then
		mod:spritePlay(sprite, "Shoot Hori")
		sprite.FlipX = false
		elseif npcdata.firing == "left" then
		mod:spritePlay(sprite, "Shoot Hori 2")
		sprite.FlipX = true
		end
	end
	if sprite:IsEventTriggered("back") then
		npc.State = 4
		npcdata.cloudtimer = math.random(60, 120)
	end
	--spawn cloud
	local cloudvelocity = nilvector
	local velnum = 2.5
	if sprite:IsEventTriggered("clouddown") then
		npc:PlaySound(mod.Sounds.NimbusShoot,3,0,false,(math.random(10,12))*0.1)
		cloud = mod.spawnent(npc, npc.Position, cloudvelocity, mod.FF.NimbusCloud.ID, mod.FF.NimbusCloud.Var, npc.SubType, 0):ToNPC()
		cloud.Velocity = Vector(0, velnum)
		cloud:GetSprite().Offset = Vector(0, 75)
		cloud:Update()
	elseif sprite:IsEventTriggered("cloudup") then
		npc:PlaySound(mod.Sounds.NimbusShoot,3,0,false,(math.random(10,12))*0.1)
		cloud = mod.spawnent(npc, npc.Position, cloudvelocity, mod.FF.NimbusCloud.ID, mod.FF.NimbusCloud.Var, npc.SubType, 0):ToNPC()
		cloud.Velocity = Vector(0, -velnum)
		cloud:GetSprite().Offset = Vector(0, 75)
		cloud:Update()
	elseif sprite:IsEventTriggered("cloudright") then
		npc:PlaySound(mod.Sounds.NimbusShoot,3,0,false,(math.random(10,12))*0.1)
		cloud = mod.spawnent(npc, npc.Position, cloudvelocity, mod.FF.NimbusCloud.ID, mod.FF.NimbusCloud.Var, npc.SubType, 0):ToNPC()
		cloud.Velocity = Vector(velnum, 0)
		cloud:GetSprite().Offset = Vector(0, 75)
		cloud:Update()
	elseif sprite:IsEventTriggered("cloudleft") then
		npc:PlaySound(mod.Sounds.NimbusShoot,3,0,false,(math.random(10,12))*0.1)
		cloud = mod.spawnent(npc, npc.Position, cloudvelocity, mod.FF.NimbusCloud.ID, mod.FF.NimbusCloud.Var, npc.SubType, 0):ToNPC()
		cloud.Velocity = Vector(-velnum, 0)
		cloud:GetSprite().Offset = Vector(0, 75)
		cloud:Update()
	end
	--play idle sound
	if npcdata.soundplay == nil then
		npcdata.soundplay = math.random(60, 90)
	end
	npcdata.soundplay = npcdata.soundplay - 1
	if npcdata.soundplay <= 0 then
		if npc.State == 4 then
			npc:PlaySound(mod.Sounds.NimbusSigh,10,0,false,(math.random(7,10))*0.1)
		end
		npcdata.soundplay = math.random(90, 360)
	end
	rooments = Isaac.GetRoomEntities()
	roomentlength = #rooments
	for othernpc = 1, 0 do
		if othernpc.Type == 21 and othernpc.Variant == 666 then
			if othernpc.npcdata.soundplay <= 0 then
				if othernpc.State == 4 then
					npcdata.soundplay = math.random(90, 360)
				end
			end
		end
	end
end

function mod:nimbuscloudai(npc, subt)

	local tear_spawn_delay = 10
	local sprite = npc:GetSprite();
	local npcdata = mod:GetEntityData(npc);
	--init the thing
	if npcdata.raincount == nil then
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		npcdata.raincount = math.random(tear_spawn_delay - 5, tear_spawn_delay + 5)
		npcdata.dissapear = false
		npcdata.theframe = 0
		if subt == 1 then
			npc.Color = Color(0.7,1.5,0.7,1,0,0,0)
		end
	end
	--basic shit
	npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	if npc.FrameCount <= 18 then
		sprite.Offset = Vector(0, -(((75/324)*(npc.FrameCount)^2)*0.73)-20)
		sprite:SetFrame("Appear", npc.FrameCount)
	elseif npcdata.dissapear == true then
		mod:spritePlay(sprite, "Disappear")
		--sprite:SetFrame("Disappear", npc.FrameCount - npcdata.theframe)
	elseif npcdata.dissapear == false then
		sprite.Offset = Vector(0, (-75 + math.sin((npc.FrameCount+ 1)*0.2)))
		mod:spritePlay(sprite, "Walk")
	end
	--rain
	npcdata.raincount = npcdata.raincount - 1
	if npcdata.raincount <= 0 then
		if sprite:IsPlaying("Walk") then
			local x_radius = 2
			local y_radius = 1
			local angle = math.random(0,359)

			--[[local params = ProjectileParams()
			params.FallingAccelModifier = 0.7
			params.Scale = math.random (7, 12) * 0.1
			params.HeightModifier = sprite.Offset.Y
			params.Variant = 4
			params.BulletFlags = params.BulletFlags & ~ProjectileFlags.ANY_HEIGHT_ENTITY_HIT]]
			local spawn_x = 0
			local spawn_y = 0
			--local projspawnposition = npc.Position + Vector(math.random(0,50) - 25,math.random(0, 8) - 8)
			if angle < 270 and angle > 90 then
				spawn_x = ((x_radius * y_radius)/math.sqrt(y_radius^2 + x_radius^2 * math.tan(math.rad(angle))^2))
				spawn_y = ((x_radius * y_radius * math.tan(math.rad(angle)))/math.sqrt(y_radius^2 + x_radius^2 * math.tan(math.rad(angle))^2))
			else
				spawn_x = -((x_radius * y_radius)/math.sqrt(y_radius^2 + x_radius^2 * math.tan(math.rad(angle))^2))
				spawn_y = -((x_radius * y_radius * math.tan(math.rad(angle)))/math.sqrt(y_radius^2 + x_radius^2 * math.tan(math.rad(angle))^2))
			end
			local projspawnposition = npc.Position + (npc.Velocity * 3) + Vector(spawn_x,spawn_y) * 15

			--npc:FireProjectiles(projspawnposition, Vector(0,0), 0, params)
			local drop = mod:LazySpawnProjectile(4, 0, projspawnposition, nilvector, npc):ToProjectile();
			drop.FallingAccel = 0.7
			drop.Scale = math.random (7, 12) * 0.1
			drop.Height = sprite.Offset.Y - 30
			if npc.SubType == 1 then
				drop.ProjectileFlags = drop.ProjectileFlags | ProjectileFlags.EXPLODE
				drop.Scale = 1.5
				local ipecaccy = Color(1,1,1,1,0,0,0)
				ipecaccy:SetColorize(0.3, 0.9, 0.3, 1)
				drop.Color = ipecaccy
			end
			drop:Update()
			end
		npcdata.raincount = math.random(tear_spawn_delay - 5, tear_spawn_delay + 5)
	end
	--dissapear
	if npc:CollidesWithGrid() then
		npcdata.dissapear = true
		npcdata.theframe = npc.FrameCount
	end
	if sprite:IsEventTriggered("CloudDisappear") then
		npc:Remove()
	end
end

--FAKE FART: butter bean fart that doesnt damage enemies, for litterbug, composter, fathead, ect...
--a grim reminder
function mod:fakefartLEGACY(position, radius, force, forcelerp, npc, playerforcemult)
	playerforcemult = playerforcemult or 0.5
	--[[game:ButterBeanFart(position, 0, npc, 1, 0)
	for _, farttarget in ipairs(Isaac.FindInRadius(position, radius, EntityPartition.ENEMY + EntityPartition.PLAYER + EntityPartition.PICKUP)) do
		local d = radius/position:Distance(farttarget.Position)
		local maxd = radius/20
		d = math.min(d*3/maxd,1)
		local f = mod:Lerp(force, force*d, forcelerp)
		if farttarget.Type == 1 then
			--print(d)
			f = mod:Lerp(force, force*d*0.66, forcelerp)*playerforcemult
			--print(f)
		elseif farttarget.Type ~= 5 then
			farttarget:AddEntityFlags(EntityFlag.FLAG_KNOCKED_BACK)
		end
		local a = (farttarget.Position - position):GetAngleDegrees()
		farttarget.Velocity = farttarget.Velocity + Vector(f, 0):Rotated(a)
	end]]--
	game:ButterBeanFart(position, radius, npc, 1, 0)
	for _, farttarget in ipairs(Isaac.FindInRadius(position, radius, EntityPartition.ENEMY)) do
		farttarget:ClearEntityFlags(EntityFlag.FLAG_APPLY_IMPACT_DAMAGE)
	end
end

--crepitus - crazy bony

function mod:crepitusai (npc, sprite, npcdata)
	local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	npc.Velocity = npc.Velocity * 0.75
	if npc.State == 8 then
		npc.State = 4
	end
	if npc.State == 4 then
		--set anim
		if math.abs(npc.Velocity.X) > math.abs(npc.Velocity.Y) then
			mod:spritePlay(sprite, "WalkHori")
			if npc.Velocity.X < 0 then
				sprite.FlipX = true
			else
					sprite.FlipX = false
			end
		else
			if npc.Velocity.Y < 0 then
				mod:spritePlay(sprite, "WalkUp")
			else
				mod:spritePlay(sprite, "WalkDown")
			end
		end
		if (npc.Position - targetpos):Length() <= 100 and not sprite:IsPlaying("Appear")
				and not (npc:HasEntityFlags(EntityFlag.FLAG_FEAR) or npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION))
				and not (mod:isFriend(npc) and target:ToPlayer()) then
			npc.State = 9
			mod:spritePlay(sprite, "Attack")
		end
	end
	if npc.State == 9 then
		npc.Velocity = mod:Lerp(npc.Velocity, Vector(0,0), 0.2)
		if not sprite:IsPlaying("Attack") then
			mod:spritePlay(sprite, "Attack")
		end
	end
	if sprite:IsEventTriggered("boneshower") then
		local bonesnumber = math.random(7, 15)
		local params = ProjectileParams()
		params.Variant = 1
		for i = 1, bonesnumber, 1 do
			params.FallingSpeedModifier = math.random(5, 25) * - 1
			params.FallingAccelModifier = 0.5
			npc:FireProjectiles(npc.Position, Vector(math.random(8,50) * 0.1,0):Rotated(math.random(1,360)), 0, params)
		end

		sfx:Play(SoundEffect.SOUND_BONE_HEART, 1, 0, false, 1)
	end
	if sprite:IsFinished("Attack") then
		npc.State = 4
	end
end

function mod:chooserandomlocationforskuzz(npc, rangespidhop, rangenpc, reallytargetplayer, isFamiliar)
	local room = game:GetRoom()
	--(npc:HasEntityFlags(EntityFlag.FLAG_FEAR) or npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION))
	local targetplayer
	if reallytargetplayer == nil then
		targetplayer = true
	else
		targetplayer = reallytargetplayer
	end
	local target = nil
	local targetpos
	if isFamiliar or npc:ToFamiliar() then --Safety check, probably shoulda just been like that
		target = mod.FindClosestEnemy(npc.Position, rangespidhop)
		if target then
			targetpos = target.Position
		else
			targetpos = npc.Position + (npc.Player.Position - npc.Position):Resized(80)
		end
		if npc.SpawnerEntity and npc.SpawnerEntity:Exists() and npc.SpawnerEntity.Type == EntityType.ENTITY_POOP and mod:GetEntityData(npc.SpawnerEntity).FFFuzzyPoop then
			if targetpos:Distance(npc.SpawnerEntity.Position) > 200 then
				targetpos = npc.SpawnerEntity.Position
			end
		end
	else
		if targetplayer == true then
			local truenpc = npc:ToNPC()
			if truenpc then
				target = truenpc:GetPlayerTarget()
			else --Safety check cos cba to figure out why it's erroring
				target = npc
			end
			targetpos = target.Position
		else
			targetpos = Vector(-1000,-1000)
			if npc:HasEntityFlags(EntityFlag.FLAG_FEAR) then
				local truenpc = npc:ToNPC()
				if truenpc then
					target = truenpc:GetPlayerTarget()
				else --Safety check carried over, I wish I knew what the code was doing
					target = npc
				end
				targetpos = target.Position
				targetplayer = true
			end
		end
	end
	local npcinrange = false
	local position = Vector(0 , 0)
	local tablelength = 1
	if targetpos:Distance(npc.Position) < rangespidhop then
		npcinrange = true
	end
	local size = room:GetGridSize()
	local validpositions = {}
	for i=0, size do
		local gridEntity = room:GetGridEntity(i)
		if (room:GetGridPosition(i):Distance(npc.Position) < rangespidhop) then
			if ( (not gridEntity) or (room:GetGridCollision(i) == GridCollisionClass.COLLISION_NONE and (gridEntity:GetType() ~= GridEntityType.GRID_SPIKES and gridEntity:GetType() ~ GridEntityType.GRID_SPIKES_ONOFF) or gridEntity:GetType() == GridEntityType.GRID_SPIDERWEB)) and room:IsPositionInRoom(room:GetGridPosition(i), 15) then
				--Isaac.ConsoleOutput(tostring(npcinrange == true))
				if targetplayer and npcinrange == true then
					if room:GetGridPosition(i):Distance(targetpos) < rangenpc and not npc:HasEntityFlags(EntityFlag.FLAG_FEAR) then
						table.insert(validpositions, i)
						tablelength = tablelength + 1
					elseif room:GetGridPosition(i):Distance(targetpos) > rangenpc and npc:HasEntityFlags(EntityFlag.FLAG_FEAR) then
						table.insert(validpositions, i)
						tablelength = tablelength + 1
					end
				else
					table.insert(validpositions, i)
					tablelength = tablelength + 1
				end
			end
		end
	end
	if tablelength == 1 then
		return npc.Position
	else
		return room:GetGridPosition(validpositions[math.random(1, tablelength - 1)])
	end
end

mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, -5, function()
	local string = "O".."d".."d" .."F".."e".."e".."l".."i".."n".."g"
	if mod.SpectatorTracking then
		mod[string] = true
	else
		mod[string] = false
	end
end)

function mod:fiendflashai(npc)
	npcdata = mod:GetEntityData(npc)
	if npcdata.parent then
		npc.Position = npcdata.parent.Position + npcdata.parent.Velocity
	else
		npc:Remove()
	end
	mod:spritePlay(npc:GetSprite(), "flash")
	if npc.SubType == 0 then
		npc.DepthOffset = 1000
	end
	if npc:GetSprite():IsFinished("flash") then
		npc:Remove()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.fiendflashai, 668)

--spitum monstro ai, spitummonstro. spitumonstro
function mod:monstrospitumai(npc, sprite, npcdata)
	local spitumnum = 0
	local target = npc:GetPlayerTarget().Position
	npcdata.launchspitum = false

	if npc:ToDelirium() or (npc.SpawnerEntity and npc.SpawnerEntity:ToDelirium()) then
		npc:Morph(EntityType.ENTITY_MONSTRO, 0, 2, -1)
		npc:ReplaceSpritesheet(0, "gfx/bosses/afterbirthplus/deliriumforms/classic/boss_004_monstro.png", true)
		if npc.SpawnerEntity and npc.SpawnerEntity:ToDelirium() and not npc:ToDelirium() then
			npc.HitPoints = npc.HitPoints * 1.25
		end
	end

	if not npcdata.init then
		--sprite:ReplaceSpritesheet(0, "gfx/bosses/champions/boss_monstro_mucus.png")
		--sprite:LoadGraphics()
		if LastJudgementSprites and not (npc:ToDelirium() or (npc.SpawnerEntity and npc.SpawnerEntity:ToDelirium())) then
            sprite:Load("gfx/bosses/champions/monstro/mucus_monstro_lj.anm2", true)
        end
		npcdata.init = true;
		npcdata.creeptimer = math.random(30, 45)
		npcdata.creepslam = 0
		npcdata.creepslamtimer = 10
		npc.SplatColor = mod.ColorSpittyGreen
		npcdata.mustspitum = false
	end
	if npc.EntityCollisionClass == EntityCollisionClass.ENTCOLL_ALL then
		if npcdata.creeptimer == -666 then
			local creep = Isaac.Spawn(1000, EffectVariant.CREEP_GREEN, 0, npc.Position, Vector(0,0), npc):ToEffect();
			creep.SpriteScale = Vector(4, 3.5)
			npcdata.creeptimer = math.random(30, 45)
			creep:SetTimeout(45)
			creep:SetColor(Color(0, 0, 0, 1, 99 / 255, 56 / 255, 74 / 255), 60, 99999, true, false)
			creep:Update()
		elseif npcdata.creeptimer <= 0 then
			local creep = Isaac.Spawn(1000, EffectVariant.CREEP_GREEN, 0, npc.Position, Vector(0,0), npc):ToEffect();
			creep.SpriteScale = Vector(3, 2.5)
			npcdata.creeptimer = math.random(30, 45)
			creep:SetTimeout(45)
			creep:SetColor(Color(0, 0, 0, 1, 99 / 255, 56 / 255, 74 / 255), 60, 99999, true, false)
			creep:Update()
		else
			npcdata.creeptimer = npcdata.creeptimer - 1;
		end
	else
		npcdata.creeptimer = -666
	end
	--slam attack
	if sprite:IsPlaying("JumpDown") and sprite:GetFrame() == 33 then
		npcdata.creepslam = math.random(3, 5)
		npcdata.creepslamtimer = math.random(3, 5)
	end
	if npcdata.creepslam > 0 then
		if npcdata.creepslamtimer <= 0 then
			npcdata.creepslam = npcdata.creepslam - 1
			npcdata.creepslamtimer = math.random(3, 5)
			local creep = Isaac.Spawn(1000, EffectVariant.CREEP_GREEN, 0, npc.Position + RandomVector():Resized(math.random(10,25)) , Vector(0,0), npc):ToEffect();
			creep.SpriteScale = Vector(4, 3.5)
			creep:SetTimeout(math.floor(creep.Timeout * 1))
			creep:SetColor(Color(0, 0, 0, 1, 99 / 255, 56 / 255, 74 / 255), 60, 99999, true, false)
			creep:Update()
		else
			npcdata.creepslamtimer = npcdata.creepslamtimer - 1
		end
	end
	--entity loops
	for _, spitmaybe in ipairs(Isaac.FindByType(mod.FF.Spitum.ID, mod.FF.Spitum.Var, -1)) do
		spitumnum = spitumnum + 1
	end
	if spitumnum < 2 and sprite:IsPlaying("Taunt") and ((sprite:GetFrame() == 24 and npcdata.mustspitum == false) or (sprite:GetFrame() == 25 and npcdata.mustspitum == true)) and (math.random(1, spitumnum + 2) == 1 or npcdata.mustspitum == true) then
		npcdata.launchspitum = true;
	end
	if not (npc:ToDelirium() or (npc.SpawnerEntity and npc.SpawnerEntity:ToDelirium())) then
		for _, tearmaybe in ipairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE, 0, -1)) do
		   if tearmaybe.SpawnerEntity then
			  if tearmaybe.SpawnerEntity.Type == mod.FF.MucusMonstro.ID and tearmaybe.SpawnerEntity.Variant == mod.FF.MucusMonstro.Var and tearmaybe.SpawnerEntity:ToNPC():GetBossColorIdx() == mod.FF.MucusMonstro.IDx and not mod:GetEntityData(tearmaybe).creeptype then
				if ((sprite:IsPlaying("JumpDown") and tearmaybe.FrameCount == 0) or (npcdata.launchspitum == true) or (npcdata.mustspitum == true)) then
				  tearmaybe:Remove()
				end
				  teardata = mod:GetEntityData(tearmaybe)
				  teardata.projType = "acidic splot"
				  teardata.creepTimer = 30
				  tearmaybe.Color = mod.ColorSpittyGreen
				  tearmaybe:GetSprite():LoadGraphics()
			  end
		   end
		end
	end
	--spitum attack
	if sprite:GetFrame() == 0 and ((npc.State == 6  and math.random(1, spitumnum + 3) == 1) or (npc.State == 4  and math.random(1, (spitumnum * 2) + 4) == 1)) and spitumnum < 2 then
		npc.State = 8
		npc.StateFrame = 0
		mod:spritePlay(sprite, "Taunt")
		npcdata.mustspitum = true
	end
	if npcdata.launchspitum == true then
		local spitum = Isaac.Spawn(Isaac.GetEntityTypeByName("Spitum"), Isaac.GetEntityVariantByName("Spitum"), 0, npc.Position, Vector(0,0), npc):ToNPC()
		spitum:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		spitum.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		spitum.GridCollisionClass = GridCollisionClass.COLLISION_NONE
		mod:GetEntityData(spitum).state = "airtime"
		mod:GetEntityData(spitum).init = true
		spitum.Velocity = (Vector(target.X - npc.Position.X, target.Y - npc.Position.Y) * 0.035) + RandomVector():Resized(math.random(50, 100) *  0.0005)
		spitum.MaxHitPoints = spitum.MaxHitPoints * 0.5
		spitum.HitPoints = spitum.MaxHitPoints
		spitum.SpriteScale = spitum.SpriteScale * 0.75
		spitum.SplatColor = mod.ColorSpittyGreen
		npcdata.mustspitum = false
	end
end

function mod:monstrochamp(npc)
	local subtype = npc.SubType
	local sprite = npc:GetSprite();
	local npcdata = mod:GetEntityData(npc);
	if npc:GetBossColorIdx() == mod.FF.MucusMonstro.IDx then
		mod:monstrospitumai(npc, sprite, npcdata)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.monstrochamp, 20)

mod.KeysToSpice = {KeySubType.KEY_NORMAL, KeySubType.KEY_CHARGED, KeySubType.KEY_DOUBLEPACK, mod.PICKUP.KEY.SPICY_BOX, mod.PICKUP.KEY.SUPERSPICY_BOX, mod.PICKUP.KEY.CHARGEDSPICY_BOX}
mod.KeysToRevert = {mod.PICKUP.KEY.SPICY, mod.PICKUP.KEY.SUPERSPICY, mod.PICKUP.KEY.CHARGEDSPICY, mod.PICKUP.KEY.SPICY_BOX, mod.PICKUP.KEY.SUPERSPICY_BOX, mod.PICKUP.KEY.CHARGEDSPICY_BOX}
mod.KeysToSpiceBox = {KeySubType.KEY_NORMAL, KeySubType.KEY_CHARGED, KeySubType.KEY_DOUBLEPACK, mod.PICKUP.KEY.SPICY, mod.PICKUP.KEY.SUPERSPICY, mod.PICKUP.KEY.CHARGEDSPICY}
mod.KeysToRevertBox = {mod.PICKUP.KEY.SPICY_BOX, mod.PICKUP.KEY.SUPERSPICY_BOX, mod.PICKUP.KEY.CHARGEDSPICY_BOX}
mod.KeysToSpicePutty = {KeySubType.KEY_NORMAL, KeySubType.KEY_CHARGED, KeySubType.KEY_DOUBLEPACK}

--CollectibleType.COLLECTIBLE_MOMS_BOX

function mod:MakeSpicy(entity, shouldPoof)
	if shouldPoof then
		poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 0, entity.Position, Vector(0,0), entity):ToEffect()
		fartcolor = Color(1, 1, 1, 1, 0, 0, 0)
		fartcolor:SetColorize(1.0, 0.2, 0.2, 1)
		poof:GetSprite().Color = fartcolor
		sfx:Stop(SoundEffect.SOUND_FART)
	end

	morphmap = {
		[KeySubType.KEY_NORMAL] = mod.PICKUP.KEY.SPICY, [KeySubType.KEY_CHARGED] = mod.PICKUP.KEY.CHARGEDSPICY,
		[KeySubType.KEY_DOUBLEPACK] = mod.PICKUP.KEY.SUPERSPICY, [mod.PICKUP.KEY.SPICY] = KeySubType.KEY_NORMAL,
		[mod.PICKUP.KEY.SUPERSPICY] = KeySubType.KEY_DOUBLEPACK, [mod.PICKUP.KEY.CHARGEDSPICY] = KeySubType.KEY_CHARGED,
		[mod.PICKUP.KEY.SPICY_BOX] = mod.PICKUP.KEY.SPICY, [mod.PICKUP.KEY.SUPERSPICY_BOX] = mod.PICKUP.KEY.SUPERSPICY, [mod.PICKUP.KEY.CHARGEDSPICY_BOX] = mod.PICKUP.KEY.CHARGEDSPICY
	}

	if mod.anyPlayerHas(mod.ITEM.TRINKET.CHILI_POWDER, true) and mod.getTrinketMultiplierAcrossAllPlayers(mod.ITEM.TRINKET.CHILI_POWDER) > 1 then
		morphmap = {
			[KeySubType.KEY_NORMAL] = mod.PICKUP.KEY.SPICY_BOX, [KeySubType.KEY_CHARGED] = mod.PICKUP.KEY.CHARGEDSPICY_BOX,
			[KeySubType.KEY_DOUBLEPACK] = mod.PICKUP.KEY.SUPERSPICY_BOX, [mod.PICKUP.KEY.SPICY] = KeySubType.KEY_NORMAL,
			[mod.PICKUP.KEY.SUPERSPICY] = KeySubType.KEY_DOUBLEPACK, [mod.PICKUP.KEY.CHARGEDSPICY] = KeySubType.KEY_CHARGED,
			[mod.PICKUP.KEY.SPICY_BOX] = KeySubType.KEY_NORMAL, [mod.PICKUP.KEY.SUPERSPICY_BOX] = KeySubType.KEY_DOUBLEPACK, [mod.PICKUP.KEY.CHARGEDSPICY_BOX] = KeySubType.KEY_CHARGED
		}
	end

	entity:ToPickup():Morph(5, 30, morphmap[entity.SubType], true)
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	--[[if mod.anyPlayerHas(mod.ITEM.TRINKET.CHILI_POWDER, true) then
		for _, subtype in pairs(mod.KeysToSpice) do
			if pickup.SubType == subtype then
				--mod:MakeSpicy(pickup, false)
			end
		end
	end]]--

	if pickup.Type == EntityType.ENTITY_PICKUP and pickup.Variant == PickupVariant.PICKUP_KEY and pickup:GetSprite():IsPlaying("Appear") and mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.EVIL_STICKER, false) then
		for _, subtype in pairs(mod.KeysToSpicePutty) do
			if pickup.SubType == subtype then
				local rng = RNG()
				rng:SetSeed(pickup.InitSeed, 0)

				if rng:RandomFloat() < 0.2 then
					poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 0, pickup.Position, Vector(0,0), pickup):ToEffect()
					fartcolor = Color(1, 1, 1, 1, 0, 0, 0)
					fartcolor:SetColorize(1.0, 0.2, 0.2, 1)
					poof:GetSprite().Color = fartcolor
					sfx:Stop(SoundEffect.SOUND_FART)

					morphmap = {
						[KeySubType.KEY_NORMAL] = mod.PICKUP.KEY.SPICY_PERM, [KeySubType.KEY_CHARGED] = mod.PICKUP.KEY.CHARGEDSPICY_PERM,
						[KeySubType.KEY_DOUBLEPACK] = mod.PICKUP.KEY.SUPERSPICY_PERM
					}

					pickup:ToPickup():Morph(5, 30, morphmap[pickup.SubType], true)
				end
			end
		end
	end
end, PickupVariant.PICKUP_KEY)

--forgive me for what i must do............
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function() -- eugh
	if mod.anyPlayerHas(mod.ITEM.TRINKET.CHILI_POWDER, true) then
		if mod.getTrinketMultiplierAcrossAllPlayers(mod.ITEM.TRINKET.CHILI_POWDER) > 1 then
			keytable = mod.KeysToSpiceBox
		else
			keytable = mod.KeysToSpice
		end
	else
		keytable = mod.KeysToRevert
	end
	for _, entity in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY)) do -- you have been forgiven
		for _, subtype in pairs(keytable) do
			if entity.SubType == subtype then
				mod:MakeSpicy(entity, true)
			end
		end
	end
end)

--When wormwood creates pits, make sure the FF ones look right
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
  if npc.Variant == 3 then
	local sprite = npc:GetSprite()
	if sprite:GetAnimation() == "Attack2" and sprite:GetFrame() == 8 then
	  mod:UpdatePits(game:GetRoom():GetGridIndex(npc.Position))
	end
  end
end, 62)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
  if npc.Variant == 0 then
	local sprite = npc:GetSprite()
	if sprite:GetAnimation() == "SuperBlast" and sprite:GetFrame() == 33 then
	  mod:UpdatePits(0)
	end
  end
end, 915)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, bomb)
	local var = bomb.Variant
	if bomb.Variant == 17 or bomb.Variant == 20 then mod:UpdatePits(0) end
end, 4)

mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, function(_, laser)
	local var = laser.Variant
	if var == 4 or var == 7 or var == 8 or var == 13 then -- Pride, Tractor Beam, Circle of Protection and Beast Lasers
		return
	end

	if laser.SpawnerEntity and laser.SpawnerEntity.Type == EntityType.ENTITY_PLAYER and var == 2 and laser.SubType == 0 then
		local familiars = Isaac.FindInRadius(laser.Position, 0.000001, EntityPartition.FAMILIAR)
		for _,familiar in ipairs(familiars) do
			if familiar.Variant == FamiliarVariant.FINGER then
				return
			end
		end
	end

	local player = nil
	if laser.SpawnerEntity and laser.SpawnerEntity:ToPlayer() then
		player = laser.SpawnerEntity:ToPlayer()
	elseif laser.SpawnerEntity and laser.SpawnerEntity:ToFamiliar() and laser.SpawnerEntity:ToFamiliar().Player then
		local familiar = laser.SpawnerEntity:ToFamiliar()

		if familiar.Variant == FamiliarVariant.INCUBUS or familiar.Variant == FamiliarVariant.SPRINKLER or
		   familiar.Variant == FamiliarVariant.TWISTED_BABY or familiar.Variant == FamiliarVariant.BLOOD_BABY or
		   familiar.Variant == FamiliarVariant.UMBILICAL_BABY or familiar.Variant == FamiliarVariant.CAINS_OTHER_EYE
		then
			player = familiar.Player
		else
			return
		end
	else
		return
	end

	local data = mod:GetEntityData(laser)
	mod:nuggetLaserUpdate(laser, data)
	mod:erflyPostLaserUpdate(player, laser, data)
end)

mod.honeydropdiagonaltable = {
	"shoot",
	"shoot",
	"shoot",
	"summon"
}

mod.honeydropdiagonaladdtable = {
	"swarm",
	"swarm",
	"swarm",
	"beeter",
	"beeter",
	"dart",
	"dart",
	"zingling"
}

--MY FIRST BOSS????????????
--honestly comments or not this whole code is such a big block o stuff that its an anyeurism to parse. I'm not looking forward to the idea of champions...
function mod:honeydropai(npc, sprite, npcdata)
	local room = game:GetRoom()
	--setup
	if not npcdata.init then
		npcdata.init = true
		npcdata.phase = "diagonal"
		npcdata.state = "idle"
		npcdata.stateframe = 0
		npcdata.statethreshold = math.random(45, 60)
		npcdata.lastattack = "none"
		npcdata.lastattackinarow = 0
		npcdata.previousshootangle = 0
		npcdata.diagonalangle = 0
		npcdata.pitch = 0
		npcdata.honeyspot = npc.Position
		npcdata.previousvelocity = npc.Velocity
		npcdata.previousxgo = 0
		npcdata.outerwallframe = 0
		npcdata.outerwallthreshold = math.random(60, 120)
		npcdata.framessinceturn = 0
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
		npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
		npcdata.confuseangle = math.random(360)

		local champSheet
		local champ
		if npc.SubType > 0 then
			champ = npc.SubType
		elseif mod:shouldBossBeChampion(npc) then
			champ = 1
		end

		if champ == 1 then
			npc.SubType = 1
			npcdata.foureyes = true
			npcdata.bellasheet = "gfx/bosses/honeydrop/bella_red.png"
			champSheet = "gfx/bosses/honeydrop/honeydrop_red.png"
		end

		if champSheet then
			for i = 0, 2 do
				sprite:ReplaceSpritesheet(i, champSheet)
			end
			sprite:LoadGraphics()
		end
		FiendFolio.savedata.sawHoneyDropBefore = FiendFolio.savedata.sawHoneyDropBefore or true
	end

	npcdata.confuseangle = npcdata.confuseangle + math.random(-30, 30)

	local honeycolor = Color(1,1,1,1,0,0,0)
	honeycolor:SetColorize(5.5, 3.5, 1, 1)

	local target = npc:GetPlayerTarget()
	local targetposition = target.Position
	--print(npcdata.state)

	--actual ai
	if npcdata.phase == "diagonal" then
		--movement
		local targetvelocity = mod:diagonalMove(npc, 2.6, 1);

		if npc:HasEntityFlags(EntityFlag.FLAG_FEAR) then
			if (npc.Position - targetposition):Length() < 125 then
				targetvelocity = (npc.Position - targetposition):Resized(2.6)
			end
		elseif npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
			targetvelocity = Vector(2.6, 0):Rotated(npcdata.confuseangle)
		end

		npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.3)
		--phase handling
		if npcdata.state == "idle" then
			sprite.FlipX = false
			mod:spritePlay(sprite, "Idle")
			if not(npc:HasEntityFlags(EntityFlag.FLAG_FEAR) or npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION)) then
				npcdata.stateframe = npcdata.stateframe + 1
			end
			--phase change (putting it in the damage callback would add extra clutter and spaghetti and for what?)
			if npc.HitPoints <= npc.MaxHitPoints * 0.55 then
				npcdata.phase = "transfer"
				npcdata.state = "stillinair"
			elseif npcdata.stateframe > npcdata.statethreshold then
				--attack behaivor
				npcdata.state = mod.honeydropdiagonaltable[math.random(1, #mod.honeydropdiagonaltable)]
				npcdata.stateframe = 0
				--this big blob o code makes sure she doesnt do the same thinjg over and over too much
				if npcdata.lastattack == "none" then
					npcdata.state = "summon"
					npcdata.lastattack = npcdata.state
					npcdata.lastattackinarow = 0
				elseif npcdata.lastattack == npcdata.state then
					npcdata.lastattackinarow = npcdata.lastattackinarow + 1
					if npcdata.lastattackinarow >= 2 and npcdata.state == "summon" then
						npcdata.state = "shoot"
						npcdata.lastattack = npcdata.state
						npcdata.lastattackinarow = 0
					elseif npcdata.lastattackinarow >= 3 and npcdata.state == "shoot" then
						npcdata.state = "summon"
						npcdata.lastattack = npcdata.state
						npcdata.lastattackinarow = 0
					end
				else
					npcdata.lastattack = npcdata.state
					npcdata.lastattackinarow = 0
				end

				if npcdata.foureyes and mod.GetEntityCount(mod.FF.Honeydrip.ID, mod.FF.Honeydrip.Var) >= 1 then
					npcdata.state = "shoot"
				end

				npcdata.statethreshold = math.random(45, 60)
			end
			--OK NOW WE CAN HAVE THE ATTACVKS
		elseif npcdata.state == "shoot" then
			mod:spritePlay(sprite, "Shoot")
			--ORI GAMI DIDNT USE ANY EVENTS BICH
			--Hello I'm Erfly from the future. My fellow you coulda just added em.
			local prospeed = 6
			if npcdata.foureyes then
				prospeed = 3
			end

			if sprite:GetFrame() == 12 then
				if not npcdata.DidTheThingThisFrame then
					npcdata.DidTheThingThisFrame = true
					local shootyangle = math.random(1, 6) * 60
					if npcdata.foureyes then
						shootyangle = (targetposition - npc.Position):GetAngleDegrees() - 30
					end

					npcdata.previousshootangle = shootyangle
					for i = 1, 3, 1 do
						local projectile = mod:LazySpawnProjectile(0, 0, npc.Position, (Vector(prospeed,0):Rotated(shootyangle)), npc):ToProjectile();
						projectile.FallingAccel = -0.1
						projectile.Scale = 2
						if npcdata.foureyes then
							projectile.Acceleration = 1.04
							--projectile.CurvingStrength = 0.002
							projectile.ProjectileFlags = ProjectileFlags.ACCELERATE --[[| ProjectileFlags.CURVE_LEFT]]
						end

						shootyangle = shootyangle + 120
					end
					npcdata.pitch = 0.75
					npc:PlaySound(185, 1, 0, false, npcdata.pitch)
					npcdata.pitch = 1.25
				end
			elseif --[[(sprite:GetFrame() == 13 and npcdata.foureyes) or]] sprite:GetFrame() == 15 or sprite:GetFrame() == 18 or sprite:GetFrame() == 21 --[[or (sprite:GetFrame() == 23 and npcdata.foureyes)]] then
				if not npcdata.DidTheThingThisFrame then
					npcdata.DidTheThingThisFrame = true
					local shootyangle = npcdata.previousshootangle + 10
					npcdata.previousshootangle = npcdata.previousshootangle + 10
					for i = 1, 3, 1 do
						local projectile = mod:LazySpawnProjectile(0, 0, npc.Position, (Vector(prospeed,0):Rotated(shootyangle)), npc):ToProjectile();
						projectile.FallingAccel = -0.1
						if npcdata.foureyes then
							projectile.Acceleration = 1.04
							--projectile.CurvingStrength = 0.002
							projectile.ProjectileFlags = ProjectileFlags.ACCELERATE --[[| ProjectileFlags.CURVE_LEFT]]
						end

						shootyangle = shootyangle + 120
					end
					npc:PlaySound(185, 1, 0, false, npcdata.pitch)
					npcdata.pitch = npcdata.pitch + 0.15
				end
			elseif sprite:GetFrame() == 25 then
				npcdata.state = "idle"
			else
				npcdata.DidTheThingThisFrame = false
			end
		elseif npcdata.state == "summon" then
			sprite.FlipX = npc.Velocity.X > 0
			mod:spritePlay(sprite, "Summon")
			if sprite:IsEventTriggered("Summon") then
				--spawn logic
				local add = mod.honeydropdiagonaladdtable[math.random(1, #mod.honeydropdiagonaladdtable)]
				--[[if npcdata.foureyes and (add == "swarm" or add == "dart") then
					if mod.GetEntityCount(mod.FF.HoneyEye.ID, mod.FF.HoneyEye.Var) < 2 then
						add = "zingling"
					else
						add = "beeter"
					end
				end]]

				if add == "swarm" then
					--stolen from baro ok???
					if npcdata.foureyes then
						for i = 1, 2 do
							local enemy = Isaac.Spawn(mod.FF.ShotFly.ID, mod.FF.ShotFly.Var, 0, npc.Position, npc.Velocity +  RandomVector():Resized(math.random(25, 35) / 10), npc):ToNPC();
							enemy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
						end
					else
						local num = math.random(2, 3)
						for i = 1, num do
							local vec = RandomVector()
							local g = math.random(30)
							local fly = mod.cheekyspawn(npc.Position + vec:Rotated((360 / num) * i - 15 + g) * 7.5, npc, npc.Position + vec:Rotated((360 / num) * i + g) * 50, 281, 0, 0)
							if fly then
								fly.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
							end
						end
					end
				elseif add == "beeter" then
					if npcdata.foureyes then
						local enemy = Isaac.Spawn(mod.FF.HoneyEye.ID, mod.FF.HoneyEye.Var, 0, npc.Position, npc.Velocity +  RandomVector():Resized(math.random(25, 35) / 10), npc):ToNPC();
						enemy:GetSprite():ReplaceSpritesheet(0, "gfx/enemies/honey eye/Honey Eye_red.png")
						enemy:GetSprite():LoadGraphics()
						enemy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
						enemy:Update()
					else
						local enemy = Isaac.Spawn(mod.FF.Beeter.ID, mod.FF.Beeter.Var, 0, npc.Position, npc.Velocity +  RandomVector():Resized(math.random(25, 35) / 10), npc):ToNPC();
						enemy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					end
				elseif add == "zingling" then
					if npcdata.foureyes then
						local enemy = Isaac.Spawn(mod.FF.HoneyEye.ID, mod.FF.HoneyEye.Var, 0, npc.Position, npc.Velocity +  RandomVector():Resized(math.random(25, 35) / 10), npc):ToNPC();
						enemy:GetSprite():ReplaceSpritesheet(0, "gfx/enemies/honey eye/Honey Eye_red.png")
						enemy:GetSprite():LoadGraphics()
						enemy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
						enemy:Update()
					else
						local enemy = Isaac.Spawn(mod.FF.Zingling.ID, mod.FF.Zingling.Var, 0, npc.Position, npc.Velocity +  RandomVector():Resized(math.random(25, 35) / 10), npc):ToNPC();
						enemy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					end
				elseif add == "dart" then
					if npcdata.foureyes then
						for i = 1, 2 do
							local enemy = Isaac.Spawn(mod.FF.ShotFly.ID, mod.FF.ShotFly.Var, 0, npc.Position, npc.Velocity +  RandomVector():Resized(math.random(25, 35) / 10), npc):ToNPC();
							enemy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
						end
					else
						for i = 1, 2 do
							local enemy = Isaac.Spawn(256, 0, 0, npc.Position, npc.Velocity +  RandomVector():Resized(math.random(25, 35) / 10), npc):ToNPC();
							enemy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
						end
					end
				end
				--end spawn logic
				npc:PlaySound(181, 1, 0, false, math.random(60, 85)/100)
			elseif sprite:GetFrame() == 25 or sprite:IsFinished("Summon") then
				npcdata.state = "idle"
			end
		end
	elseif npcdata.phase == "transfer" then
		if sprite.FlipX then
			npcdata.honeyspot = Vector(npc.Position.X + 20, npc.Position.Y)
		else
			npcdata.honeyspot = Vector(npc.Position.X - 20, npc.Position.Y)
		end
		--thjis is when shot stingnrer
		if npcdata.state == "stillinair" then
			local targetVelocity = mod:diagonalMove(npc, 2.6, 1);
			npc.Velocity = mod:Lerp(npc.Velocity, targetVelocity, 0.3)
			if  mod:findwalldistance(npc).X >= 60 and mod:findwalldistance(npc).Y >= 40 then
				npcdata.diagonalangle = npc.Velocity:GetAngleDegrees()
				npcdata.state = "fall"
				sprite:Play("Fall", true)
				if npc.Velocity.X > 0 then
					sprite.FlipX = true
				end
				npc.Mass = 100
				npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
				npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
			end
		else
			--non diagonal ground movement: this is the sequence after getting on the ground
			npc.Velocity = mod:Lerp(npc.Velocity, nilvector, 0.35)
			if npcdata.state == "fall" then
				if sprite:IsFinished("Fall") then
					sprite:Play("Squeeze", true)
				elseif sprite:IsFinished("Squeeze") then
					npcdata.state = "bitch"
					npcdata.stateframe = 0
					if npcdata.foureyes then
						npcdata.statethreshold = math.random(200, 240)
					else
						npcdata.statethreshold = math.random(180, 210)
					end
				elseif sprite:GetFrame() == 40 then
					if not npcdata.DidTheThingThisFrame then
						npcdata.DidTheThingThisFrame = true
						game:ShakeScreen(15)
						npc.Velocity = Vector(10, 0):Rotated(npcdata.diagonalangle + 180)
						npc:PlaySound(SoundEffect.SOUND_MEATY_DEATHS, 1.33, 0, false, 0.75)
						npc:PlaySound(SoundEffect.SOUND_ROCK_CRUMBLE, 0.66, 0, false, 1)
						npc:PlaySound(mod.Sounds.FrogShoot,0.7,0,false,math.random(12,14)/10)
						--creep
						local creep = Isaac.Spawn(1000, EffectVariant.CREEP_BROWN, 0, npcdata.honeyspot, Vector(0,0), npc):ToEffect();
						creep.SpriteScale = Vector(4, 3.5)
						creep:SetTimeout(math.floor(creep.Timeout * 2.25))
						creep:Update()
						creep:GetSprite().Color = honeycolor
						--stinger spawn
						npcdata.bella = Isaac.Spawn(666, 161, 0, npc.Position, Vector(10, 0):Rotated(npcdata.diagonalangle), npc):ToNPC();
						npcdata.bella:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
						npcdata.bella.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
						mod:GetEntityData(npcdata.bella).master = npc

						if npcdata.foureyes then
							mod:GetEntityData(npcdata.bella).foureyes = true
						end

						if npcdata.bellasheet then
							npcdata.bella:GetSprite():ReplaceSpritesheet(0, npcdata.bellasheet)
							npcdata.bella:GetSprite():LoadGraphics()
						end

						--enemies
						--zinglings
						--[[
						for i = 1, 1, 1 do
							local enemy = Isaac.Spawn(mod.FF.Zingling.ID, mod.FF.Zingling.Var, 0, npc.Position, (npcdata.bella.Velocity +  RandomVector()):Resized(math.random(25, 35) / 10), npc):ToNPC();
							enemy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
						end
						]]--
						--dart flies
						local num, typ, var, hpmul = 2, 256, 0, 1
						if npcdata.foureyes then
							num, typ, var, hpmul = 2, mod.FF.Shoter.ID, mod.FF.Shoter.Var, 1
						end

						for i = 1, num, 1 do
							local enemy = Isaac.Spawn(typ, var, 0, npc.Position, (npcdata.bella.Velocity +  RandomVector()):Resized(math.random(25, 35) / 10):Rotated((360 / num) * i + math.random(30)), npc):ToNPC();
							enemy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
							enemy.MaxHitPoints = enemy.MaxHitPoints * hpmul
							enemy.HitPoints = enemy.MaxHitPoints
						end
						--swarm
						if npcdata.foureyes then
							local num = 3
							for i = 1, num, 1 do
								local enemy = Isaac.Spawn(mod.FF.ShotFly.ID, mod.FF.ShotFly.Var, 0, npc.Position, (npcdata.bella.Velocity +  RandomVector()):Resized(math.random(25, 35) / 10):Rotated((360 / num) * i + math.random(30)), npc):ToNPC();
								enemy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
								enemy.MaxHitPoints = enemy.MaxHitPoints * hpmul
								enemy.HitPoints = enemy.MaxHitPoints
							end
						else
							local num = math.random(2, 3)
							for i = 1, num, 1 do
								local vec = RandomVector()
								local g = math.random(30)
								local fly = mod.cheekyspawn(npc.Position + vec:Rotated((360 / num) * i - 15 + g) * 7.5, npc, npc.Position + vec:Rotated((360 / num) * i + g) * 50, 281, 0, 0)
								fly.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
							end
						end
					end
				else
					npcdata.DidTheThingThisFrame = false
					--ok now thats all done
				end
			elseif npcdata.state == "bitch" then
				mod:spritePlay(sprite, "Cry")
				npcdata.stateframe = npcdata.stateframe + 1
				if npcdata.stateframe > npcdata.statethreshold then
					npcdata.state = "getup"
					sprite:Play("GetUp", true)
				end
				if game:GetFrameCount() % 30 == 0 then
					local creep = Isaac.Spawn(1000, EffectVariant.CREEP_BROWN, 0, npcdata.honeyspot, Vector(0,0), npc):ToEffect();
					creep.SpriteScale = Vector(1.5, 1)
					creep:SetTimeout(math.floor(creep.Timeout * 1.25))
					creep:Update()
					creep:GetSprite().Color = honeycolor
				end
			elseif npcdata.state == "getup" then
				--make sure to add creep to this one!
				if sprite:IsFinished("GetUp") then
					npcdata.phase = "chaser"
					npcdata.state = "run"
					npcdata.stateframe = 0

					if npcdata.foureyes then
					   npcdata.statethreshold = math.random(60, 120)
					else
					   npcdata.statethreshold = math.random(180, 240)
					end
					--MAYBE this fixes bug ori said?
					sprite.FlipX = not sprite.FlipX
				end
			end
		end
	elseif npcdata.phase == "chaser" then
		--finally added a cap to the bees
		local typ, var = mod.FF.Beeter.ID, mod.FF.Beeter.Var
		if npcdata.foureyes then
			typ, var = mod.FF.HoneyEye.ID, mod.FF.HoneyEye.Var
		end

		local beenum = mod.GetEntityCount(typ, var)
		--spawn shit
		if beenum < 2 then
			npcdata.outerwallframe = npcdata.outerwallframe + 1
			--print(npcdata.outerwallframe.." "..npcdata.outerwallthreshold.." "..beenum)
			if (npcdata.outerwallframe >= npcdata.outerwallthreshold and beenum <= 0) or npcdata.outerwallframe >= (npcdata.outerwallthreshold * 2) then
				--ITS RAINING BEES
				npcdata.outerwallframe = 0
				npcdata.outerwallthreshold = math.random(120, 180)

				local enemy = Isaac.Spawn(typ, var, 0, (room:GetCenterPos() + RandomVector():Resized(room:GetBottomRightPos().X - room:GetCenterPos().X + 150)), nilvector, npc):ToNPC()
				if npcdata.foureyes then
					enemy:GetSprite():ReplaceSpritesheet(0, "gfx/enemies/honey eye/Honey Eye_red.png")
					enemy:GetSprite():LoadGraphics()
				end
				enemy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				enemy.GridCollisionClass = GridCollisionClass.COLLISION_NONE
				enemy:Update()
			end
		end
		--state stuff
		if npcdata.state == "run" then
			npcdata.stateframe = npcdata.stateframe + 1
			npcdata.framessinceturn = npcdata.framessinceturn + 1
			--honey dropper
			if sprite.FlipX then
				npcdata.honeyspot = Vector(npc.Position.X - 20, npc.Position.Y)
			else
				npcdata.honeyspot = Vector(npc.Position.X + 20, npc.Position.Y)
			end
			if game:GetFrameCount() % 5 == 0 then
				local creep = Isaac.Spawn(1000, EffectVariant.CREEP_BROWN, 0, npcdata.honeyspot, Vector(0,0), npc):ToEffect();
				if not npcdata.foureyes then
					creep.SpriteScale = Vector(1.75, 1.25)
				end

				creep:SetTimeout(math.floor(creep.Timeout * 0.6))
				creep:Update()
				creep:GetSprite().Color = honeycolor
			end
			--sprite play
			mod:spritePlay(sprite, "Run")
			if(npcdata.state == "run") then sprite.FlipX = npc.Velocity.X > 0 end
			--velocity
			if npc:HasEntityFlags(EntityFlag.FLAG_FEAR) then
				targetposition = npc.Position + ((npc.Position - targetposition):Resized(10))
			elseif npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
				targetposition = npc.Position + Vector(10, 0):Rotated(npcdata.confuseangle)
			end
			if not (npcdata.stateframe >= npcdata.statethreshold and mod:findwalldistance(npc).Y >= 60) then
				local xgo = 8
				local ygo = 5
				if npc.Position.X > targetposition.X then
					xgo = -8
				end
				if npc.Position.Y > targetposition.Y then
					ygo = -5
				end
				npcdata.previousxgo = xgo
				local xgo2 = mod:Lerp(npc.Velocity.X, xgo, 0.045)
				local ygo2 = mod:Lerp(npc.Velocity.Y, ygo, 0.055)
				npc.Velocity = Vector(xgo2, ygo2)
			else
				--charge
				npc.Velocity = mod:Lerp(npc.Velocity, Vector(12, 0):Rotated(Vector(npcdata.previousxgo, 0):GetAngleDegrees()) , 0.1)
			end
			--skid
			if (math.abs(npc.Velocity.X) <= 0.5 and ((npc.Position.X > targetposition.X and npc.Velocity.X > 0) or (npc.Position.X < targetposition.X and npc.Velocity.X < 0))) and npcdata.framessinceturn >= 15 and npcdata.stateframe < npcdata.statethreshold then
				npcdata.state = "skid"
				sprite:Play("Turn", true)
				npcdata.framessinceturn = 0
			--slam
			elseif (((npcdata.previousvelocity:Resized(1).X > 0 and npc.Velocity.X < 0) or (npcdata.previousvelocity:Resized(1).X < 0 and npc.Velocity.X > 0)) and npc:CollidesWithGrid()) or (npc:CollidesWithGrid() and npcdata.stateframe >= npcdata.statethreshold and mod:findwalldistance(npc).Y >= 60) then
				npcdata.state = "slam"
				sprite:Play("Slam", true)
				npcdata.Velocity = nilvector
				sprite.FlipX = not sprite.FlipX
				game:ShakeScreen(10)
				npc:PlaySound(SoundEffect.SOUND_ROCK_CRUMBLE, 0.66, 0, false, 1.5)
				--charge stuff
				npcdata.stateframe = 0

				if npcdata.foureyes then
					npcdata.statethreshold = math.random(90, 150)
				else
					npcdata.statethreshold = math.random(180, 240)
				end

				--creep / champ shockwave
				if not npcdata.foureyes then
					local creep = Isaac.Spawn(1000, EffectVariant.CREEP_BROWN, 0, npcdata.honeyspot, Vector(0,0), npc):ToEffect();
					creep.SpriteScale = Vector(4, 3.5)
					creep:SetTimeout(math.floor(creep.Timeout * 2.25))
					creep:Update()
					creep:GetSprite().Color = honeycolor
				else
					local dir = 0
					if sprite.FlipX then -- facing right
						dir = 180
					end

					local wave = Isaac.Spawn(1000, 72, 2, npc.Position + Vector.FromAngle(dir) * 10, nilvector, boss):ToEffect()
					wave.Parent = npc
					wave.Rotation = dir
				end
				--cracker
				--[[
				local wave = Isaac.Spawn(1000, 61, 0, npc.Position, Vector(0,0), boss):ToEffect()
				wave.Parent = npc
				]]--
			end
			npcdata.previousvelocity = npc.Velocity
		elseif npcdata.state == "skid" then
			npc.Velocity = mod:Lerp(npc.Velocity, nilvector, 0.35)
			if sprite:GetFrame() == 6 then
				npcdata.state = "run"
				sprite:Play("Run", true)
				sprite.FlipX  = not sprite.FlipX

				if not npcdata.foureyes then
					local creep = Isaac.Spawn(1000, EffectVariant.CREEP_BROWN, 0, npc.Position, Vector(0,0), npc):ToEffect();
					creep.SpriteScale = Vector(2, 1.25)
					creep:SetTimeout(math.floor(creep.Timeout * 0.25))
					creep:Update()
					creep:GetSprite().Color = honeycolor
				end
			elseif sprite:GetFrame() == 4 then
				--anim bug i guess??????
				sprite.FlipX = npcdata.previousvelocity.X < 0
			end
		elseif npcdata.state == "slam" then
			npc.Velocity = mod:Lerp(npc.Velocity, nilvector, 0.55)
			if sprite:IsFinished("Slam") then
				npcdata.state = "run"
				sprite:Play("Run", true)
				sprite.FlipX  = not sprite.FlipX
				local flip = -1
				if sprite.FlipX then
					flip = 1
				end
				npc.Velocity = npc.Velocity + Vector(2.5 * flip, 0)
			end
		end
	end
end

--SERVANT OF HONEYDROP. note that spawning flies is in damage callback
function mod:bellaai(npc, sprite, npcdata)
	if not npcdata.init then
		npcdata.init = true
		npcdata.die = false
		npcdata.cooldown = 0
		npcdata.shaketimer = 0
		npcdata.previousvelocity = npc.Velocity
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
		npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
	end
	local targetVelocity = mod:diagonalMove(npc, 4.5, 1);
	if npcdata.foureyes then
		targetVelocity = mod:diagonalMove(npc, 6.5, 1);
	end

	npc.Velocity = mod:Lerp(npc.Velocity, targetVelocity, 0.3)
	npcdata.cooldown = npcdata.cooldown - 1
	npcdata.shaketimer = npcdata.shaketimer - 1
	--death
	if (npcdata.master == nil or npcdata.master:IsDead()) and not npcdata.die then
		sprite:Play("Death", true)
		npcdata.die = true
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
	end
	if sprite:GetFrame() == 8 and (sprite:IsPlaying("Death") or sprite:IsPlaying("DeathUp")) then
		npc:Remove()
	end
	--animation
	if not npcdata.die then
		if npcdata.shaketimer > 0 then
			if npc.Velocity.Y > 0 then
				mod:spritePlay(sprite, "FlyShake")
			else
				mod:spritePlay(sprite, "FlyUpShake")
			end
		else
			if npc.Velocity.Y > 0 then
				mod:spritePlay(sprite, "Fly")
			else
				mod:spritePlay(sprite, "FlyUp")
			end
		end
	else
		if npc.Velocity.Y > 0 then
			mod:spritePlay(sprite, "Death")
		else
			mod:spritePlay(sprite, "DeathUp")
		end
	end
	sprite.FlipX = npc.Velocity.X > 0
	--sound
	if ((npcdata.previousvelocity:Resized(1).X > 0 and npc.Velocity.X < 0) or (npcdata.previousvelocity:Resized(1).X < 0 and npc.Velocity.X > 0)) or ((npcdata.previousvelocity:Resized(1).Y > 0 and npc.Velocity.Y < 0) or (npcdata.previousvelocity:Resized(1).Y < 0 and npc.Velocity.Y > 0)) then
		npc:PlaySound(mod.Sounds.Ricochet,1,0,false,0.5)
	end
	npcdata.previousvelocity = npc.Velocity
end

function mod:findwalldistance(npc)
	local room = game:GetRoom()
	local xdistancereturn = math.min(math.abs(npc.Position.X - room:GetTopLeftPos().X), math.abs(npc.Position.X - room:GetBottomRightPos().X))
	local ydistancereturn = math.min(math.abs(npc.Position.Y - room:GetTopLeftPos().Y), math.abs(npc.Position.Y - room:GetBottomRightPos().Y))
	return Vector(xdistancereturn, ydistancereturn)
end

function mod:dankdipchange(npc)
	if npc.Variant == 1 then
		if npc:IsDead() then
			if FiendFolio.ChangeAi then
				local clotcheck = false
				--remove clots
				for _, clot in ipairs(Isaac.FindByType(15, 1, 0, false, false)) do
					if clot.SpawnerType == 220 and clot.Position:Distance(npc.Position) < 20 and clot.FrameCount < 1 then
						clot:Remove()
						clotcheck = true
					end
				end
				if clotcheck then
					--spawn blots
					for i = 0, 360, 30 do
						local rand = math.random()
						if math.random(1, 5) == 5 then
							local blot = Isaac.Spawn(mod.FF.Blot.ID, mod.FF.Blot.Var, 0, npc.Position, Vector(0,0.5):Rotated(i-40+rand*80), npc):ToNPC()
							local blotdata = mod:GetEntityData(blot)
							blotdata.downvelocity = -35 + math.random(10);
							blotdata.downaccel = 2.5
							blot.Velocity = blot.Velocity * (math.random(12, 20)/7.5)
							blot.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
							blot.GridCollisionClass = GridCollisionClass.COLLISION_NONE
							blot:GetSprite().Offset = Vector(0, -1)
							blotdata.state = "air"
							blot:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
						else
							local projectile = mod:LazySpawnProjectile(0, 0, npc.Position, Vector(0,2):Rotated(i-40+rand*80), npc):ToProjectile();
							local projdata = mod:GetEntityData(projectile);
							local s = projectile:GetSprite()
							--s:Load("gfx/enemies/blot/monster_blot.anm2",true)
							--s:Play("InAir1",false)
							projectile.FallingSpeed = -35 + math.random(10);
							projectile.FallingAccel = 1.5
							projectile.Velocity = projectile.Velocity * (math.random(8, 14)/10)
							projectile.Scale = math.random(8, 12)/10
							projectile.Color = mod.ColorDankBlackReal
						end
					end
				end
			end
		end
	end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.dankdipchange, 220)

--mr. bones - its mr bones wild ride!
function mod:mrbonesai(npc, sprite, npcdata)
	mod:setTargetOfNPC(npc, npcdata)
	local target = npc:GetPlayerTarget()

	-- For charm compatibility (DOESNT WORK BECAUSE BONY VARIANT AAAAAAAAAAA)
	if npcdata.parent and target.InitSeed == npcdata.parent.InitSeed then
		target = Isaac.GetPlayer(0)
	elseif npcdata.head and target.InitSeed == npcdata.head.InitSeed then
		target = Isaac.GetPlayer(0)
	end
	local targetpos = target.Position

	npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)

	if not npcdata.init then
		npcdata.head = nil
		npcdata.time = 0
		npcdata.init = true
		mod:lastJudgementAutoResprite(npc, data, sprite)
	end
	if npc.State == 8 then
		npc.State = 4
	end
	if npc.State == 4 then
		--set anim
		if math.abs(npc.Velocity.X) > math.abs(npc.Velocity.Y) then
			mod:spritePlay(sprite, "WalkHori")
			if npc.Velocity.X < 0 then
				sprite.FlipX = true
			else
					sprite.FlipX = false
			end
		else
			if npc.Velocity.Y < 0 then
				mod:spritePlay(sprite, "WalkUp")
			else
				mod:spritePlay(sprite, "WalkDown")
			end
		end
		if (npc.Position - targetpos):Length() <= 125 and npcdata.time > 20 and not sprite:IsPlaying("Appear") and not (npc:HasEntityFlags(EntityFlag.FLAG_FEAR) or npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION)) then
			npc.State = 9
			mod:spritePlay(sprite, "Attack")
		else
			npcdata.time = npcdata.time + 1
		end
	elseif npc.State == 9 then
		--headlessbody
		npc.Velocity = mod:Lerp(npc.Velocity, Vector(0,0), 0.2)
		if npcdata.head ~= nil and (npcdata.head:IsDead() or mod:isStatusCorpse(npcdata.head)) and not (sprite:IsPlaying("Appear") or sprite:IsFinished("Appear")) then
			local guy = Isaac.Spawn(11, 0, 0, npc.Position, Vector(0, 0), npc):ToNPC()
			mod:copyStatusEffects(npc, guy)
			guy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			sprite = guy:GetSprite()
			if mod.isBackdrop("Mausoleum") then
				sprite:ReplaceSpritesheet(0, "gfx/enemies/mrbones/welcomeaboardmatey_mausoleum.png")
			elseif mod.isBackdrop("Ashpit") then
				sprite:ReplaceSpritesheet(0, "gfx/enemies/mrbones/welcomeaboardmatey_ashpit.png")
			elseif mod.isBackdrop("Dross") then
				sprite:ReplaceSpritesheet(0, "gfx/enemies/mrbones/welcomeaboardmatey_dross.png")
			elseif mod.isBackdrop("Flooded Caves") or mod.isBackdrop("Downpour") then
				sprite:ReplaceSpritesheet(0, "gfx/enemies/mrbones/welcomeaboardmatey_downpour.png")
			else
				sprite:ReplaceSpritesheet(0, "gfx/enemies/mrbones/welcomeaboardmatey.png")
			end
			sprite:LoadGraphics()
			npc:Remove()
		elseif sprite:IsFinished("Attack") then
			mod:spritePlay(sprite, "AttackStill")
		elseif sprite:IsEventTriggered("head") then
			npc:PlaySound(SoundEffect.SOUND_MEATHEADSHOOT,1,0,false,1)
			local head = Isaac.Spawn(227, 667, 0, npc.Position, Vector(0, 0), npc):ToNPC()
			npcdata.head = head
			head.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			head.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
			--head:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
			head.Velocity = Vector(9, 0):Rotated((targetpos - npc.Position):GetAngleDegrees())
			mod:copyStatusEffects(npc, head)
			head:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			head.State = 10
			mod:GetEntityData(head).parent = npc
			mod:GetEntityData(head).airtime = math.min((npc.Position - targetpos):Length() / 8, 13)
			mod:GetEntityData(head).bitten = 0
			mod:spritePlay(head:GetSprite(), "HeadLaunch")
		elseif sprite:IsFinished("Appear") then
			npc.State = 4
			npcdata.time = 0
			npcdata.head = nil
		end
	elseif npc.State == 10 then
		--get ahead
		if (npcdata.parent:IsDead() or mod:isStatusCorpse(npcdata.parent)) and not mod:isLeavingStatusCorpse(npc) then
			npc:Kill()
		end
		if sprite:IsFinished("HeadLaunch") then
			mod:spritePlay(sprite, "HeadTravel")
		end
		if not npcdata.chained then
			npcdata.chained = true
			local numchains = 9
			local vecfun = npcdata.parent.Position - npc.Position
			local vecdist = vecfun:Length()
			for i = 1, numchains do
				local chain = Isaac.Spawn(1000, 1740, 0, npc.Position + vecfun:Resized(vecdist * (i / numchains+2)), nilvector, npc):ToEffect()
				local chaind = mod:GetEntityData(chain)
				chain:GetSprite():Load("gfx/enemies/mrbones/mrbones.anm2",true)
				if mod:CheckStage("Ashpit", {46,59}) then
					chain:GetSprite():ReplaceSpritesheet(1, "gfx/enemies/mrbones/rattlemebones_ashpit.png")
				elseif mod:CheckStage("Dross", {45}) then
					chain:GetSprite():ReplaceSpritesheet(1, "gfx/enemies/mrbones/rattlemebones_dross.png")
				elseif mod:CheckStage("Downpour", {31,36}) or mod:CheckStage("Flooded Caves", {6}) then
					chain:GetSprite():ReplaceSpritesheet(1, "gfx/enemies/mrbones/rattlemebones_downpour.png")
				end
				chain:GetSprite():LoadGraphics()
				chaind.Pos = i
				chaind.Num = numchains + 1
				chaind.Source = npc
				chaind.Home = npcdata.parent
				chain:Update()
			end
		end
		npcdata.airtime = npcdata.airtime - 1
		if(npcdata.airtime > 0) then
			npc.Velocity = mod:Lerp(npc.Velocity, npc.Velocity:Normalized() * 15, 0.4)
		elseif npcdata.bitten == 0 then
			mod:spritePlay(sprite, "HeadBite")
			npcdata.bitten = 1
		else
			if npcdata.bitten == 1 then
				npc.Velocity = mod:Lerp(npc.Velocity, Vector(4, 0):Rotated((npcdata.parent.Position - npc.Position):GetAngleDegrees()), 0.3)
			elseif npcdata.bitten == 2 then
				npc.Velocity = mod:Lerp(npc.Velocity, Vector(25, 0):Rotated((npcdata.parent.Position - npc.Position):GetAngleDegrees()), 0.225)
			end
			if sprite:IsEventTriggered("chormp") then
				sfx:Play(SoundEffect.SOUND_SMB_LARGE_CHEWS_4, 1.5, 0, false, 0.75)
				npcdata.bitten = 2
			elseif(npcdata.parent.Position - npc.Position):Length() < 10 then
				mod:spritePlay(npcdata.parent:GetSprite(), "Appear")
				npc:PlaySound(SoundEffect.SOUND_SCAMPER,0.5,0,false,math.random(75,125)/100)
				npc:Remove()
			end
		end

	else
		npc.State = 4
	end
end

mod:addCopyStatusHandler(FiendFolio.FF.MrBones.ID, FiendFolio.FF.MrBones.Var)

function mod:pennyPickupGMO(player, pickup, value)
	if player:HasTrinket(mod.ITEM.TRINKET.GMO_PENNY) then
		local luckyVal = 0
		if pickup.SubType == CoinSubType.COIN_LUCKYPENNY then
			luckyVal = 10
		else
			if value >= 10 then
				luckyVal = 5
			elseif value >= 5 then
				luckyVal = 2
			end
		end
		local lucky = luckyVal + math.max(player.Luck, 0) * player:GetTrinketMultiplier(mod.ITEM.TRINKET.GMO_PENNY)
		if math.random(0, 10000)/100 <= lucky + 5 then
			FiendFolio.QueuePills(player, player:GetTrinketMultiplier(mod.ITEM.TRINKET.GMO_PENNY))
		end
	end
end
function mod:pennyPickupMolten(player, pickup, value)
	if player:HasTrinket(mod.ITEM.TRINKET.MOLTEN_PENNY) then
		local sdata = mod:GetEntityData(player).ffsavedata
		if not sdata.moltenPennyNumber then
			sdata.moltenPennyNumber = 0
		end
		sdata.moltenPennyNumber = sdata.moltenPennyNumber+1
		local lucky = math.max(player.Luck / 2, 0)
		if value >= 10 then
			lucky = lucky + 6
		elseif value >= 6 or pickup.SubType == CoinSubType.COIN_LUCKYPENNY then
			lucky = lucky + 3
		else
			lucky = lucky + value
		end
		lucky = lucky * (1 + 0.25 * (player:GetTrinketMultiplier(mod.ITEM.TRINKET.MOLTEN_PENNY) - 1))
		if (math.random(0, 10000)/100 <= lucky + 2) or (sdata.moltenPennyNumber == 30)then
			player:UseActiveItem(479, false, false, true, false)
			sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS, 1, 0, false, 1.5)
		end
	end
end
function mod:pennyPickupFuzzy(player, pickup, value)
	if player:HasTrinket(mod.ITEM.TRINKET.FUZZY_PENNY) then
		local repeatTimes = player:GetTrinketMultiplier(mod.ITEM.TRINKET.FUZZY_PENNY)
		for k = 1, repeatTimes do
			local randVec = RandomVector() * math.random(5,15)
			local skuzz = Isaac.Spawn(3, mod.ITEM.FAMILIAR.ATTACK_SKUZZ, 0, player.Position + randVec, nilvector, player):ToFamiliar()
			skuzz:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		end
	end
end

--Gmo Penny, Molten Penny (real)
--[[function mod:gmocoin(pickup, man, low)

	local sticky = (pickup.SubType == 6)
	if man.Type == 1 and (not pickup.Touched) and (not sticky) then
		man = man:ToPlayer()
		if man:HasTrinket(mod.ITEM.TRINKET.GMO_PENNY) then
			local lucky = math.max(man.Luck, 0) * man:GetTrinketMultiplier(mod.ITEM.TRINKET.GMO_PENNY)
			lucky = math.sqrt(20 * lucky)
			if pickup.SubType == 2 then
				lucky = lucky + 2
			elseif pickup.SubType == 3 then
				lucky = lucky + 5
			elseif pickup.SubType == 5 then
				lucky = lucky + 10
			elseif pickup.SubType == 213 then
				lucky = lucky + 5
			end
			if math.random(0, 10000)/100 <= lucky + 5 then
				local pill = (man:HasCollectible(CollectibleType.COLLECTIBLE_PHD) or man:HasCollectible(CollectibleType.COLLECTIBLE_VIRGO)) and FiendFolio.PHDPills[math.random(#FiendFolio.PHDPills)] or math.random(PillEffect.NUM_PILL_EFFECTS - 1)
				pill = ((pill == PillEffect.PILLEFFECT_BAD_TRIP and man:GetHearts() <= 2) and PillEffect.PILLEFFECT_FULL_HEALTH or pill)
				pill = ((pill == PillEffect.PILLEFFECT_HEALTH_DOWN and man:GetMaxHearts() <= 1) and PillEffect.PILLEFFECT_HEALTH_UP or pill)
				man:UsePill(pill, math.random(PillColor.NUM_PILLS - 1))
			end
		end
		if man:HasTrinket(mod.ITEM.TRINKET.MOLTEN_PENNY) then

			local sdata = mod:GetEntityData(Isaac.GetPlayer()).ffsavedata
			if not sdata.moltenPennyNumber then
				sdata.moltenPennyNumber = 0
			end
			sdata.moltenPennyNumber = sdata.moltenPennyNumber+1

			local lucky = math.max(man.Luck / 2, 0)
			if(pickup.SubType == 2 or pickup.SubType == 5) then
				lucky = lucky + 3
			end
			if(pickup.SubType == 3) then
				lucky = lucky + 6
			end
			if(pickup.SubType == 213) then
				lucky = lucky + 1
			end
			lucky = lucky * (1 + 0.25 * (man:GetTrinketMultiplier(mod.ITEM.TRINKET.MOLTEN_PENNY) - 1))
			if (math.random(0, 10000)/100 <= lucky + 2) or (sdata.moltenPennyNumber == 30)then
				man:UseActiveItem(479, false, false, true, false)
				sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS, 1, 0, false, 1.5)
			end
		end
		if man:HasTrinket(mod.ITEM.TRINKET.FUZZY_PENNY) then
			local repeatTimes = man:GetTrinketMultiplier(mod.ITEM.TRINKET.FUZZY_PENNY)
			for k = 1, repeatTimes do
				local randVec = RandomVector() * math.random(5,15)
				local skuzz = Isaac.Spawn(3, mod.ITEM.FAMILIAR.ATTACK_SKUZZ, 0, man.Position + randVec, nilvector, man):ToFamiliar()
				skuzz:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			end
		end
	end
end

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.gmocoin, 20)]]

--END OF MINICHIBIS CODE

-- DEAD CODE?!? (i have no idea where to put this!) (catinsurance: i put it in your folder!)

function mod:PeriodicSine(time, period, offset, percent)
	offset = offset or 0
	local wave = math.sin((math.pi * 2) * (offset + time / period))
	if percent then
		return (wave + 1) / 2
	else
		return wave
	end
end

--END OF DEAD CODE

function mod:blueHorfAI(npc, sprite, d)
	local room = game:GetRoom()
	local target = npc:GetPlayerTarget()
	local r = npc:GetDropRNG()

	if not d.init then
		d.state = "idle"
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
		d.init = true
	else
		npc.StateFrame = npc.StateFrame + 1
	end

	local targdistance = target.Position - npc.Position
	local targrel
	if d.dir then
		targrel = mod.peeplingdirs[d.dir[1]][1]
	else
		if math.abs(targdistance.X) > math.abs(targdistance.Y) then
			if targdistance.X < 0 then
				targrel = 3 -- Left
			else
				targrel = 1 -- Right
			end
		else
			if targdistance.Y < 0 then
				targrel = 0 -- Up
			else
				targrel = 2 -- Down
			end
		end
	end

	local rangeval = targdistance:Length()
	if rangeval > 150 then
		rangeval = 150
	elseif rangeval < 100 then
		rangeval = 100
	end

	local tpa = target.Position + Vector(0, rangeval):Rotated(targrel * 90)
	local targvel
	local dist = npc.Position:Distance(tpa)

	if dist > 70 then
		targvel = (tpa - npc.Position):Resized(7)
	else
		targvel = (tpa - npc.Position):Resized(dist / 10)
	end
	npc.Velocity = mod:Lerp(npc.Velocity, targvel, 0.2)

	if d.state == "idle" then
		mod:spritePlay(sprite, "Shake")
		if npc.StateFrame > 20 then
			d.state = "shoot"
		end
	elseif d.state == "shoot" then
		if sprite:IsFinished("Attack") then
			d.state = "idle"
			npc.StateFrame = 0
		elseif sprite:IsEventTriggered("Shoot") then
			local rand = r:RandomInt(4)
			if rand == 3 then
				npc:PlaySound(SoundEffect.SOUND_WHEEZY_COUGH,1,0,false,1)
				local vec = target.Position - npc.Position
				for i = -30, 30, 30 do
					mod.spawnent(npc, npc.Position + vec:Resized(10):Rotated(i), vec:Resized(10):Rotated(i), 13)
				end
				for i = -60, 60, 120 do
					mod.spawnent(npc, npc.Position + vec:Resized(10):Rotated(i), vec:Resized(10):Rotated(i), 18)
				end
			elseif rand == 2 then
				npc:PlaySound(SoundEffect.SOUND_SHAKEY_KID_ROAR,1,0,false,1)
				local params = ProjectileParams()
				params.Scale = 2
				params.HeightModifier = 5
				params.FallingAccelModifier = -0.1
				params.BulletFlags = params.BulletFlags | ProjectileFlags.RED_CREEP
				local vec1 = (target.Position - npc.Position):Normalized()
				npc:FireProjectiles(npc.Position + vec1*10, vec1*7, 0, params)
			elseif rand == 1 then
				npc:PlaySound(mod.Sounds.FlashShakeyKidRoar,1.5,2,false,1)
				local count = math.random(3,7)
				for i = 1, count do
					local fire = Isaac.Spawn(1000,7005, 20, npc.Position, Vector(5,0):Rotated(360/count * i - 25 + math.random(50)), npc):ToEffect()
					mod:GetEntityData(fire).timer = 350
					fire.Parent = npc
				end
			else
				game:ButterBeanFart(npc.Position, 250, npc, 1, 0)
				npc:PlaySound(SoundEffect.SOUND_FART,1,0,false,0.7)
				Isaac.GridSpawn(14, 2, npc.Position, true)
			end
		else
			mod:spritePlay(sprite, "Attack")
		end
	end

	if npc:IsDead() then
		room:SpawnGridEntity(room:GetGridIndex(npc.Position), GridEntityType.GRID_PIT, 0, 1, 0)
		mod:UpdatePits(0)
	end
end

function mod:dukeOfDemonsAI(npc, sprite, d)
	local room = game:GetRoom()
	local target = npc:GetPlayerTarget()
	local r = npc:GetDropRNG()

	if not d.init then
		d.state = "idle"
		d.init = true
	else
		npc.StateFrame = npc.StateFrame + 1
	end

	npc.SpriteOffset = Vector(0, -35)

	if d.state == "idle" then
		mod:spritePlay(sprite, "Fly")
		if sprite:GetFrame() == 3 then
			mod:diagonalMove(npc, 5.5)
		end
		npc.Velocity = npc.Velocity * 0.96
		if r:RandomInt(20)+1 == 1 and (target.Position - npc.Position):Length() < 200 and room:CheckLine(target.Position,npc.Position,3,900,false,false) then
			if mod.GetEntityCount(mod.FF.DukesDemon.ID, mod.FF.DukesDemon.Var) < 10 then
				if math.random(2) == 1 then
					d.state = "shootsmall"
				else
					d.state = "shootbig"
					d.playerPos = target.Position
				end
			else
				d.playerPos = target.Position
				d.state = "shootbig"
			end
		end
	elseif d.state == "shootsmall" then
		if sprite:IsFinished("Shoot") then
			d.state = "idle"
		elseif sprite:IsEventTriggered("Shoot") then
			for i = -30, 30, 30 do
				local demonbaby = Isaac.Spawn(mod.FF.DukesDemon.ID, mod.FF.DukesDemon.Var, 0, npc.Position, Vector(0,15):Rotated(i), npc):ToNPC()
				demonbaby.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
				demonbaby:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				demonbaby:Update()
			end
		else
			mod:spritePlay(sprite, "Shoot")
		end
	elseif d.state == "shootbig" then
		npc.Velocity = npc.Velocity * 0.9
		if sprite:IsFinished("ShootBig") then
			d.state = "idle"
		elseif sprite:IsEventTriggered("Shoot") then
			local laser = EntityLaser.ShootAngle(6, npc.Position, (d.playerPos - npc.Position):GetAngleDegrees(), 15, Vector(0, -70), npc)
			laser.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			laser.DepthOffset = -500
			laser.MaxDistance = 0
			laser:Update()
		else
			mod:spritePlay(sprite, "ShootBig")
		end
	end
end
function mod:dukesDemonAI(npc, sprite, d)
	local room = game:GetRoom()
	local target = npc:GetPlayerTarget()
	local r = npc:GetDropRNG()

	if not d.init then
		d.state = "idle"
		d.init = true
	else
		npc.StateFrame = npc.StateFrame + 1
	end

	if d.state == "idle" then
		mod:spritePlay(sprite, "FloatDown")
		npc.Velocity = mod:Lerp(npc.Velocity, (target.Position - npc.Position):Resized(2), 0.1)
		if r:RandomInt(20)+1 == 1 and (target.Position - npc.Position):Length() < 200 and room:CheckLine(target.Position,npc.Position,3,900,false,false) then
			d.state = "shoot"
			local vec = (target.Position - npc.Position)
			if math.abs(vec.X) > math.abs(vec.Y) then
				d.vecx = "Side"
				if vec.X > 0 then
					sprite.FlipX = false
				else
					sprite.FlipX = true
				end
			else
				if vec.Y > 0 then
					d.vecx = "Down"
				else
					d.vecx = "Up"
				end
			end
			mod:spritePlay(sprite, "FloatShoot" .. d.vecx)
			npc:FireProjectiles(npc.Position, vec:Resized(7), 0, ProjectileParams())
			npc:PlaySound(SoundEffect.SOUND_SHAKEY_KID_ROAR,1,0,false,1.3)
		end
	elseif d.state == "shoot" then
		npc.Velocity = npc.Velocity * 0.9
		if sprite:IsFinished("FloatShoot" .. d.vecx) then
			d.state = "idle"
		else
			mod:spritePlay(sprite, "FloatShoot" .. d.vecx)
		end
	end
end

function mod:goldMedallionUpdate(pickup)
	local sprite = pickup:GetSprite()
	if sprite:IsFinished("Appear") or sprite:IsFinished("AppearAlt") then
		sprite:Play("Idle", true)
		pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
	end
	if sprite:GetAnimation() == "Collect" and sprite:GetFrame() >= 5 and not mod.IsPlayingAchievementNote() then
		mod.scheduleForUpdate(function()
			game:FinishChallenge()
		end, 30, nil, true)
		for _, player in ipairs(PlayerManager.GetPlayers()) do
			player.ControlsEnabled = false
		end
		pickup:Remove()
	end
	if sprite:IsEventTriggered("DropSound") then
		sfx:Play(mod.Sounds.LandSoft, 1, 0, false, 1)
		if sprite:IsPlaying("AppearAlt") then
			sfx:Play(mod.Sounds.Tada,1,0,false,1.25)
		end
	elseif sprite:IsEventTriggered("Tada") then
		sfx:Play(mod.Sounds.Tada,1,0,false,1.25)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.goldMedallionUpdate, 960)

function mod:trophyToMedallion(pickup)
	if Isaac.GetChallenge() == mod.challenges.dadsHomePlus then
		pickup:Morph(5, 960, 0, true)
		pickup:GetSprite():Play("AppearAlt", true)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.trophyToMedallion, 370)

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider)
	if collider.Type == 1 then
		collider = collider:ToPlayer()
		if pickup:GetSprite():WasEventTriggered("DropSound") or pickup:GetSprite():IsPlaying("Idle") then
			pickup:GetSprite():Play("Collect")
			sfx:Play(mod.Sounds.Tada, 1, 0, false, 0.75)
			collider:AnimateHappy()
			--Isaac.ExecuteCommand("cutscene 2")
			--game:Fadeout(20, 0)
		end
		return true
	else
		return true
	end
end, 960)

--Kingpin

--[[ patterns

chase:
- dig and jump toward the player exactly like weaver
- only one head can do this at a time

dash:
- pick a random direction from the player, choose a far grid in that direction, perform 1-2 jumps from there in the opposite direction (do not change direction if not necessary)

flank:
- pick a random direction from the player, choose a close grid in that direction, perform 1 jump from there in the opposite direction

if no heads are chasing, chase
otherwise, if over 50% of heads are flanking, pick dash, and if over 50% of heads are dashing, pick flank. else pick 50/50

]]

local kingpinSpacing = 6

function mod:kingpinAI(npc, sprite, d)
	local room = game:GetRoom()

	mod:setTargetOfNPC(npc, d)
	local target = npc:GetPlayerTarget()
	if target.Type == mod.FF.Kingpin.ID and target.Variant == mod.FF.Kingpin.Var and mod:isInSegmentsOf(target, npc) then
		target = Isaac.GetPlayer(0)
	end

	if not d.init then
		d.init = true
		npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		d.dir = "Hori"
		npc.StateFrame = -10
		d.state = "underground"
		d.velVec = math.random(50)
		d.lerpVal = (math.random(10) / 100) + 0.05
		if not npc.Parent then
			local segCount = 19
			local subt = npc.SubType
			if subt > 1 then
				segCount = subt - 1
			end

			for i = 1, segCount do
				local seg = Isaac.Spawn(mod.FF.Kingpin.ID, mod.FF.Kingpin.Var, 0, npc.Position, nilvector, npc):ToNPC()
				if d.prevSeg then
					seg.Parent = d.prevSeg
					d.prevSeg.Child = seg
				else
					seg.Parent = npc
					npc.Child = seg
				end
				mod:copyStatusEffects(npc, seg)
				seg:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				d.prevSeg = seg
				seg:Update()
			end
		end
	end

	if math.abs(npc.Velocity.X) > math.abs(npc.Velocity.Y) then
		d.dir = "Hori"
		if npc.Velocity.X > 0 then
			sprite.FlipX = false
		else
			sprite.FlipX = true
		end
	else
		if npc.Velocity.Y < 0 then
			d.dir = "Down"
		else
			d.dir = "Up"
		end
	end

	local isMinLength = true
	if npc.Parent and npc.Parent.Parent and npc.Parent.Parent.Parent then -- it takes less space than a loop!
		isMinLength = false
	elseif npc.Child and npc.Child.Child and npc.Child.Child.Child then
		isMinLength = false
	end

	if not npc.Parent then
		if not npc.Child then
			if not npc:IsDead() then
				d.dyingToLackOfFriends = true
				npc:Kill()
			end
		end

		if not d.calcdChildren then
			d.childcount = 1
			d.lastEnt = npc
			local finished = false
			repeat
				if d.lastEnt.Child then
					d.lastEnt = d.lastEnt.Child
					d.childcount = d.childcount + 1
				end
			until(not d.lastEnt.Child)
			d.calcdChildren = true
		end

		if not d.headinit then
			npc.MaxHitPoints = npc.MaxHitPoints * 2
			npc.HitPoints = npc.HitPoints * 2
			d.headinit = true
		end

		if d.jumped then
			d.jumps = d.jumps - 1
			d.jumpvel = npc.Velocity
			if d.jumps <= 0 then
				d.jumps = nil
				d.movestate = nil
			end

			d.jumped = nil
		end

		if not d.movestate then
			local kingpins = Isaac.FindByType(mod.FF.Kingpin.ID, mod.FF.Kingpin.Var, -1, false, false)
			local headCount, chasing, dashing, flanking = 0, 0, 0, 0
			for _, kp in ipairs(kingpins) do
				if not kp.Parent and kp.Child then
					headCount = headCount + 1
					local movestate = mod:GetEntityData(kp).movestate
					if movestate == "chase" then
						chasing = chasing + 1
					elseif movestate == "dash" then
						dashing = dashing + 1
					elseif movestate == "flank" then
						flanking = flanking + 1
					end
				end
			end

			local pickState
			if isMinLength and headCount <= 3 then
				pickState = "chase"
			elseif headCount == 1 then
				local pick = math.random(1, 4)
				if pick <= 2 then
					pickState = "chase"
				elseif pick == 3 then
					pickState = "flank"
				else
					pickState = "dash"
				end
			elseif chasing == 0 then
				pickState = "chase"
			else
				if dashing > headCount / 2 then
					pickState = "flank"
				elseif flanking > headCount / 2 then
					pickState = "dash"
				elseif math.random(1, 2) == 1 then
					pickState = "flank"
				else
					pickState = "dash"
				end
			end

			d.movestate = pickState
			if pickState == "chase" then
				if math.random(1, 3) == 1 then
					d.crawltime = math.random(45, 85) + math.ceil(d.childcount * 1.5)
				else
					d.jumps = 1
				end
			elseif pickState == "flank" then
				d.jumps = 1
			elseif pickState == "dash" then
				d.jumps = math.random(1, 2)
			end

			if pickState == "flank" or pickState == "dash" then
				local fromGrids = {}
				local directions = {}
				for i = 0, room:GetGridSize() do
					local pos = room:GetGridPosition(i)
					if room:IsPositionInRoom(pos, 0) and not room:GetGridEntity(i) then
						local toTarget = target.Position - pos
						local dist = toTarget:LengthSquared()
						local isFar = dist > 160 ^ 2
						if dist < (320 ^ 2) and isFar == (d.movestate == "dash") then
							local direction = toTarget:GetAngleDegrees()
							direction = math.abs(math.floor(direction / 45))
							if not fromGrids[direction] then
								directions[#directions + 1] = direction
								fromGrids[direction] = {}
							end

							fromGrids[direction][#fromGrids[direction] + 1] = pos
						end
					end
				end

				if #directions > 0 then
					local pickFrom = fromGrids[directions[math.random(1, #directions)]]
					local pickFromWeighted = {}
					local sum = 0
					for _, pos in ipairs(pickFrom) do
						local weight = 99999999 - math.floor(pos:DistanceSquared(npc.Position))
						sum = sum + weight
						pickFromWeighted[#pickFromWeighted + 1] = {pos, weight}
					end

					local rand = math.random(0, sum)
					local targPos
					for _, pick in ipairs(pickFromWeighted) do
						if rand <= pick[2] then
							targPos = pick[1]
							break
						else
							rand = rand - pick[2]
						end
					end

					d.digto = targPos
				else
					d.movestate = nil
				end
			end
		end

		npc.StateFrame = npc.StateFrame + 1
		local targvel
		local speed = 5.5
		extraspeed = math.max(10 - d.childcount, 0) / 5
		speed = speed + extraspeed

		if d.state == "crawl" then
			local targvel = (target.Position - npc.Position):Resized(speed)
			npc.Velocity = mod:Lerp(npc.Velocity, targvel, 0.07):Rotated(math.sin((npc.InitSeed + npc.FrameCount) / 7) * 8)
		elseif d.state == "surface" and d.jumpvel and room:GetGridCollisionAtPos(npc.Position) == GridCollisionClass.COLLISION_NONE then
			targvel = d.jumpvel:Resized(speed)
		elseif d.digto then
			local direction = (d.digto - npc.Position)
			local dist = direction:Length()
			dist = math.max(dist, 1)
			targvel = (direction / dist) * speed

			if dist <= 60 then
				if d.movestate == "dash" then
					d.dashdirection = target.Position - npc.Position
					npc.Velocity = d.dashdirection:Resized(speed)
				end

				d.digto = nil
				npc.StateFrame = 0
			end
		else
			if d.movestate == "dash" and not room:IsPositionInRoom(npc.Position, 20) then
				d.dashdirection = target.Position - npc.Position
			end

			if d.movestate ~= "dash" or d.state == "surface" then
				targvel = ((target.Position + target.Velocity:Resized(d.velVec)) - npc.Position):Resized(speed)
			else
				targvel = d.dashdirection:Resized(speed)
			end
		end

		--[[
		if not d.target then
			targvel = ((target.Position + target.Velocity:Resized(d.velVec)) - npc.Position):Resized(speed)
		else
			targvel = (d.target - npc.Position):Resized(speed)
			if npc.Position:Distance(d.target) < 20 then
				d.target = mod:FindRandomFreePosAirNoGrids(npc.Position, 120)
			end
		end]]

		if d.state ~= "crawl" then
			npc.Velocity = mod:Lerp(npc.Velocity, targvel, 0.15	)
		end
		if not (sprite:IsPlaying("AttackHori") or sprite:IsPlaying("AttackUp") or sprite:IsPlaying("AttackDown")) then
			mod:spritePlay(sprite, "Head" .. d.dir)
		end
	else
		local pd = mod:GetEntityData(npc.Parent)
		if npc.Child then
			if npc.Parent.Parent then
				mod:spritePlay(sprite, "Body")
			else
				mod:spritePlay(sprite, "Hands" .. d.dir)
			end
		else
			mod:spritePlay(sprite, "Butt" .. d.dir)
		end

		if pd.prevpositions and  #pd.prevpositions > kingpinSpacing then
			npc.StateFrame = pd.prevpositions[kingpinSpacing].stateframe
			d.state = pd.prevpositions[kingpinSpacing].state
			d.digto = pd.prevpositions[kingpinSpacing].digto
			d.crawltime = pd.prevpositions[kingpinSpacing].crawltime
			npc.Velocity = pd.prevpositions[kingpinSpacing].velocity
			npc.Position = pd.prevpositions[kingpinSpacing].pos
		end
	end

	local curvar = 1.9
	local curframe = 23

	if d.state == "underground" then
		npc.Visible = false
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

		--[[
		if not d.settled then
			local rand = math.random(2)
			if rand == 1 then
				d.target = nil
			else
				d.target = mod:FindRandomFreePosAirNoGrids(npc.Position, 120)
			end
			d.settled = true
		end]]

		if not npc.Parent then
			if npc.FrameCount % 4 == 1 then
				local pile = Isaac.Spawn(1000, 146, 0, npc.Position, nilvector, npc):ToEffect()
				local s = pile:GetSprite()
				s:Load("gfx/bosses/kingpin/dirtpile_big.anm2", true)
				mod:GetEntityData(pile).KingpinPile = true
				--pile:GetSprite().Rotation = -10 + math.random(20)
				mod:GetEntityData(pile).Timeout = kingpinSpacing * (d.childcount - 2)
				--pile:Update()
			end
		end

		if npc.StateFrame > 20 and not d.digto then
			if room:GetGridCollisionAtPos(npc.Position) == GridCollisionClass.COLLISION_NONE and room:IsPositionInRoom(npc.Position, 15) then
				if d.jumps then
					d.jumpvel = npc.Velocity
					d.jumped = true
				end

				npc:PlaySound(SoundEffect.SOUND_MAGGOT_BURST_OUT,0.8,0,false,0.8 + math.random(3)/10)

				if d.crawltime then
					d.state = "crawl"
				else
					d.state = "surface"
				end

				npc.StateFrame = 0
			end
		end
	elseif d.state == "surface" then
		-- d.settled = false
		npc.Visible = true
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS

		local curve = 0 - math.sin(0.2 * npc.StateFrame / curvar) * 35
		local coll = room:GetGridCollisionAtPos(npc.Position)
		if npc.StateFrame > curframe and (coll ~= GridCollisionClass.COLLISION_NONE and coll ~= GridCollisionClass.COLLISION_PIT) then
			npc.StateFrame = curframe
			d.target = nil
		end

		d.spriteoffsettarget = Vector(0, curve)
		if npc.StateFrame > 1 then
			d.interpolationframe = true
		else
			npc.SpriteOffset = d.spriteoffsettarget
		end

		if npc.StateFrame > curframe + 2 then
			npc:PlaySound(SoundEffect.SOUND_MAGGOT_ENTER_GROUND,0.8,0,false,0.8 + math.random(3)/10)
			d.state = "underground"
			npc.StateFrame = 0
		end
	elseif d.state == "crawl" then
		npc.Visible = true
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS

		local coll = room:GetGridCollisionAtPos(npc.Position)
		if (coll ~= GridCollisionClass.COLLISION_NONE and coll ~= GridCollisionClass.COLLISION_PIT) then
			d.spriteoffsettarget = Vector(0, -10)
		else
			d.spriteoffsettarget = nilvector
		end

		if npc.StateFrame > 1 then
			d.interpolationframe = true
		else
			npc.SpriteOffset = d.spriteoffsettarget
		end

		if not npc.Parent then
			--[[
			if npc.FrameCount % 10 == 1 then
				local params = ProjectileParams()
				params.Variant = 3
				params.HeightModifier = 15
				params.FallingAccelModifier = -0.11
				params.Acceleration = -0.1
				--params.Scale = 0.7
				npc:FireProjectiles(npc.Position, (-npc.Velocity):Resized(5), 0, params)
			end]]

			if npc.FrameCount % 20 == 1 then
				mod:spritePlay(sprite, "Attack" .. d.dir)
				npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,1,2,false,1)
				local params = ProjectileParams()
				params.HeightModifier = 15
				params.FallingAccelModifier = -0.11
				params.Scale = 1.5
				params.Damage = 1
				local toPlayer = (target.Position - npc.Position):Normalized()
				npc:FireProjectiles(npc.Position + toPlayer * 20, toPlayer * 8, 0, params)
			end
		end

		if npc.StateFrame > d.crawltime then
			npc:PlaySound(SoundEffect.SOUND_MAGGOT_ENTER_GROUND,0.8,0,false,0.8 + math.random(3)/10)
			d.state = "underground"
			npc.StateFrame = 0
			d.crawltime = nil
			d.movestate = nil
		end
	end

	if npc:IsDead() then
		if not d.dyingToLackOfFriends then
			local off = math.random() * 360
			for i = 0, 360, 120 do
				local params = ProjectileParams()
				params.HeightModifier = 15
				params.FallingAccelModifier = -0.11
				params.BulletFlags = ProjectileFlags.NO_WALL_COLLIDE
				--params.Scale = 0.7
				mod:SetGatheredProjectiles()
				npc:FireProjectiles(npc.Position, Vector.FromAngle(i + off) * 7.75, 0, params)
				for _, projectile in pairs(mod:GetGatheredProjectiles()) do
					mod:GetEntityData(projectile).Wobblin = true
					mod:GetEntityData(projectile).WobblinTimer = 250
				end
			end
		end

		if not isMinLength and not d.headinit then
			mod:GetEntityData(npc:GetLastParent()).calcdChildren = false
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, npc.Position, Vector(0, 0), npc)
		end
	end

	d.prevpositions = d.prevpositions or {}
	table.insert(d.prevpositions, 1, {
		state = d.state,
		digto = d.digto,
		crawltime = d.crawltime,
		pos = npc.Position,
		offset = npc.SpriteOffset.Y,
		stateframe = npc.StateFrame,
		velocity = npc.Velocity
	})
	if #d.prevpositions > 10 then
		table.remove(d.prevpositions, #d.prevpositions)
	end
end

function mod:kingpinRender(npc)
	if npc.Variant == 80 then
		local d = mod:GetEntityData(npc)
		if d.spriteoffsettarget then
			if d.interpolationframe then
				npc.SpriteOffset = mod:Lerp(npc.SpriteOffset, d.spriteoffsettarget, 0.5)
				d.interpolationframe = nil
			else
				npc.SpriteOffset = d.spriteoffsettarget
			end
		end
	end
end

mod:addCopyStatusHandler(FiendFolio.FF.Kingpin.ID, FiendFolio.FF.Kingpin.Var)

--Commenting for my good friend budjy poo
function mod:calcPeepDir(vec)
--Rotates by 90 to get it so it matches peeping facing down, then by another 20 degrees so the cones are centred
vec = vec:Rotated(-110)
--Multiplies by -1 so it goes counter clockwise like the animation
local vecA = vec:GetAngleDegrees() * -1
--Divides the circle into 9 sectors
local ang = math.floor((vecA / 40 % 9))
return ang
end

function mod:calcPeepeeDir(vec)
vec = vec:Rotated(-112.5)
local vecA = vec:GetAngleDegrees() * -1
local ang = math.floor((vecA / 45 % 8))
return ang
end

--Peeping
function mod:peepingAI(npc, sprite, d)
	local room = game:GetRoom()
	local target = npc:GetPlayerTarget()
	local r = npc:GetDropRNG()

	if not d.init then
		d.init = true
		npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		d.state = "appear"
		sprite:Play("Appear", true)
		d.ad = {--Attacks done
		{"hemo", 0},--Big Fuck You Haemolacria
		{"likeFatherLikeSon", 0},--Peepling
		{"BWOOOOM", 2},--Brimstone Sweep
		}
	else
		npc.StateFrame = npc.StateFrame + 1
	end

	if npc.HitPoints < 100 then
		d.state = "PullTheLeverKronk"
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		if d.hemoCheck then
			local hemo = Isaac.Spawn(mod.FF.MegaHemo.ID, mod.FF.MegaHemo.Var, 0, npc.Position, nilvector, npc):ToNPC();
			mod:GetEntityData(hemo).vec = nilvector
			hemo.SpriteOffset = Vector(0,-60)
			hemo:Update()
			d.hemoCheck = false
		end
		if d.Brimmy then
			d.Brimmy:Remove()
		end
	end

	if d.state == "appear" then
		if sprite:IsFinished("Appear") then
			d.state = "idle"
			npc.StateFrame = 0
		elseif sprite:IsEventTriggered("Scream") then
			game:ShakeScreen(30)
			npc:PlaySound(mod.Sounds.MonsterYellFlash,1.5,0,false,0.9)
		elseif sprite:IsEventTriggered("Blink") then
			npc:PlaySound(SoundEffect.SOUND_MEAT_JUMPS,0.7,0,false,0.9)
		elseif sprite:IsEventTriggered("SquishBlink") then
			npc:PlaySound(SoundEffect.SOUND_SKIN_PULL,0.4,0,false,1.6)
		elseif sprite:IsEventTriggered("PopSFX") then
			sfx:Stop(mod.Sounds.StretchEye)
			npc:PlaySound(SoundEffect.SOUND_PLOP,1,0,false,0.8)
			npc:BloodExplode()
		elseif sprite:IsEventTriggered("Grow") then
			npc:PlaySound(mod.Sounds.StretchEye,0.3,0,false,1)
		elseif sprite:IsEventTriggered("Slam") then
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			npc:PlaySound(SoundEffect.SOUND_FORESTBOSS_STOMPS,0.5,0,false,1)
			game:ShakeScreen(15)
		else
			mod:spritePlay(sprite, "Appear")
		end
	elseif d.state == "idle" then
		mod:spritePlay(sprite, "Walk")
		if npc.StateFrame > 5 then
			d.substate = nil
			if npc.HitPoints < 350 and not d.plantedPeepee then
				if mod.GetEntityCount(mod.FF.Peepstalk.ID, mod.FF.Peepstalk.Var,0) > 0 then
					d.state = "peepeePlant"
				end
				d.plantedPeepee = 1
			else
				d.successfullBrimDid = false
				d.state = mod.ChooseNextAttack(d.ad, r)
			end
		end
	elseif d.state == "PullTheLeverKronk" then
	--Time for you to die!
		npc.Velocity = npc.Velocity * 0.7
		if sprite:IsFinished("Phase2Start") or sprite:IsEventTriggered("Explode") then
			npc:Kill()
		elseif sprite:IsEventTriggered("BloodStart") then
			local eye = Isaac.Spawn(mod.FF.Peeping2.ID, mod.FF.Peeping2.Var, 0, mod:Lerp(npc.Position, target.Position, 0.66), nilvector, npc)
			eye.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			eye:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			eye:Update()
			d.spawnedPhase2 = true
		elseif sprite:IsEventTriggered("SuckIn") then
			npc:PlaySound(mod.Sounds.StretchEye,1,0,false,1)
		elseif sprite:IsEventTriggered("Grow") then
			sfx:Stop(mod.Sounds.StretchEye)
			npc:PlaySound(mod.Sounds.WhipCrack,0.7	,0,false,1)
			npc:BloodExplode()
			for index,entity in ipairs(Isaac.FindByType(mod.FF.Peepstalk.ID, mod.FF.Peepstalk.Var, 2, EntityPartition.ENEMY, true)) do
				mod:GetEntityData(entity).state = "collapse"
			end
		elseif sprite:IsEventTriggered("Slam") then
			npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS, 1, 0, false, 1);
		else
			mod:spritePlay(sprite, "Phase2Start")
		end
	elseif d.state == "peepeePlant" then
		npc.Velocity = npc.Velocity * 0.7
		d.substate = d.substate or "tearItUp"
		if d.substate == "tearItUp" then
			if sprite:IsFinished("PillarSummon2Spit") then
				d.substate = "shootDude"
			elseif sprite:IsEventTriggered("Spawn") then
				--[[local safestBets = {}
				local backupOptions = {}]]
				d.targetPeepstalks = {}
				for index,entity in ipairs(Isaac.FindByType(mod.FF.Peepstalk.ID, mod.FF.Peepstalk.Var, 0, EntityPartition.ENEMY, true)) do
					--[[if mod.farFromAllPlayers(entity.Position, 100) then
						table.insert(safestBets, entity)
					else
						table.insert(backupOptions, entity)
					end]]
					entity.SubType = 1
					table.insert(d.targetPeepstalks, entity)
				end

				--[[local rand = 1
				if #safestBets > 0 then
					if #safestBets > 1 then
						rand = math.random(#safestBets)
					end
					safestBets[rand].SubType = 1
					d.targetPeepstalk = safestBets[rand]
				elseif #backupOptions > 0 then
					if #backupOptions > 1 then
						rand = math.random(#backupOptions)
					end
					backupOptions[rand].SubType = 1
					d.targetPeepstalk = backupOptions[rand]
				else
					local pos = Isaac.GetFreeNearPosition(Isaac.GetRandomPosition(), 40)
					local peepee = Isaac.Spawn(980, 92, 1, pos, nilvector, npc)
					peepee:Update()
					d.targetPeepstalk = peepee
				end]]


			--Sound and visual flair
			elseif sprite:IsEventTriggered("Rip") then
				npc:PlaySound(SoundEffect.SOUND_MAGGOT_ENTER_GROUND,0.5,0,false,1)
			elseif sprite:IsEventTriggered("Swishy") then
				npc:PlaySound(SoundEffect.SOUND_FETUS_JUMP,0.5,0,false,1)
			elseif sprite:IsEventTriggered("Slam") then
				npc:PlaySound(SoundEffect.SOUND_MAGGOT_BURST_OUT,0.5,0,false,1)
				game:ShakeScreen(15)
			else
				mod:spritePlay(sprite, "PillarSummon2Spit")
			end
		elseif d.substate == "shootDude" then
			if sprite:IsFinished("SpitPeepee02") then
				d.state = "idle"
			elseif sprite:IsEventTriggered("SuckIn") then
				npc:PlaySound(SoundEffect.SOUND_FRAIL_CHARGE,0.5,0,false,1)
			elseif sprite:IsEventTriggered("Shoot") then
				--This is the important bit yo
				for i = 1, #d.targetPeepstalks do
					local vec = (d.targetPeepstalks[i].Position - npc.Position)
					local peepee = Isaac.Spawn(mod.FF.Peepee.ID, mod.FF.Peepee.Var, 1, npc.Position, vec:Resized(3), npc)
					local peed = mod:GetEntityData(peepee)
					peed.startPos = npc.Position
					peed.endGoal = d.targetPeepstalks[i].Position
					peed.target = d.targetPeepstalks[i]
					peepee:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					peepee.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
					peepee.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
					peepee.SpriteOffset = Vector(0, -50)
					peepee:Update()
				end
				--Flair
				npc:PlaySound(mod.Sounds.WateryBarf,1.5,0,false,1)
				game:ShakeScreen(15)
			else
				mod:spritePlay(sprite, "SpitPeepee02")
			end
		end
	elseif d.state == "hemo" then
		d.substate = d.substate or "prepareTheBeast"
		if d.substate == "prepareTheBeast" then
			mod:diagonalMove(npc, 2.5)
			if sprite:IsFinished("Hemolacria") then
				d.substate = "holdItRightThere"
				npc.StateFrame = 0
			elseif sprite:IsEventTriggered("Grow") then
				npc:PlaySound(mod.Sounds.BaloonShort, 1.5, 0, false, 1.5);

				--[[ old
				for index,entity in ipairs(Isaac.FindByType(980, 92, 2, EntityPartition.ENEMY, true)) do
					local ed = mod:GetEntityData(entity)
					if ed.state == "idle" then
						ed.state = "shoot"
						ed.playerpos = target.Position + target.Velocity * 5
						ed.vecang = mod:calcPeepeeDir(target.Position - entity.Position) + 1
						ed.wait = math.random(1,15)
						entity:Update()
					end
				end]]
			elseif sprite:IsEventTriggered("HemolacriaStart") then
				local corners = {}
				for i = 0, 360, 90 do
					corners[#corners + 1] = target.Position + Vector(120, 0):Rotated(i + 45)
				end

				local peepees = Isaac.FindByType(mod.FF.Peepstalk.ID, mod.FF.Peepstalk.Var, 2, EntityPartition.ENEMY, true)
				local pospairs = mod:PairEntitiesToPositions(peepees, corners)
				for ind, entpair in ipairs(pospairs) do
					local ent = entpair.ent
					local pos = corners[entpair.posind]
					local ed = mod:GetEntityData(ent)
					if ed.state == "idle" then
						ed.state = "shoot"
						ed.shoottarget = pos
						ed.vecang = mod:calcPeepeeDir(ed.shoottarget - ent.Position) + 1
						ed.wait = 0
						ent:Update()
					end
				end

				d.hemoCheck = true
			else
				mod:spritePlay(sprite, "Hemolacria")
			end
		elseif d.substate == "holdItRightThere" then
			mod:diagonalMove(npc, 2.5)
			mod:spritePlay(sprite, "HemolacriaLoop")
			if npc.StateFrame > 0 then
				d.recordedPos = target.Position + target.Velocity * 10
				d.substate = "shootboi"
				d.animNum = mod:calcPeepDir(target.Position - npc.Position) + 1
			end
		elseif d.substate == "shootboi" then
			npc.Velocity = npc.Velocity * 0.7
			if sprite:IsFinished("HemolacriaShoot0" .. d.animNum) then
				d.ad[1][2] = d.ad[1][2] + 0.5
				--[[if math.random(2) == 1 then
					d.substate = nil
				else]]
					d.state = "idle"
					npc.StateFrame = 0
				--end
			elseif sprite:IsEventTriggered("Shoot") then
				d.hemoCheck = false
				npc:PlaySound(SoundEffect.SOUND_BOSS2_BUBBLES,1,0,false,math.random(70,90)/100)
				local vec = ((d.recordedPos - npc.Position)*0.04)
				--local vec = (d.recordedPos - npc.Position):Resized(9)
				local hemo = Isaac.Spawn(mod.FF.MegaHemo.ID, mod.FF.MegaHemo.Var, 0, npc.Position, vec, npc):ToNPC();
				mod:GetEntityData(hemo).vec = vec
				hemo.SpriteOffset = Vector(0,-60)
				hemo:Update()
			else
				mod:spritePlay(sprite, "HemolacriaShoot0" .. d.animNum)
			end
		end
	elseif d.state == "likeFatherLikeSon" then
		--Movement
		local vec = (target.Position - npc.Position):Rotated(135)
		local vecA = vec:GetAngleDegrees()
		local targrel = math.floor((vecA / 90 % 4))

		local rangeval = vec:Length()
		if rangeval > 250 then
			rangeval = 250
		elseif rangeval < 150 then
			rangeval = 150
		end

		local tpa = target.Position + Vector(0, rangeval):Rotated(targrel * 90)
		local targvel
		local dist = npc.Position:Distance(tpa)

		if dist > 70 then
			targvel = (tpa - npc.Position):Resized(7)
		else
			targvel = (tpa - npc.Position):Resized(dist / 10)
		end
		npc.Velocity = mod:Lerp(npc.Velocity, targvel, 0.2)

		if not d.substate then
			d.substate = "prepareShoot"
			d.rotVal = 0
			d.orderVal = {0, 2}
			d.tears = {}
			sprite:Play("PeeplingAttack", true)
		end
		if d.substate == "prepareShoot" then
			--Attack Handling
			if sprite:IsFinished("PeeplingAttack") then
				d.substate = "SHOOT SON"
				local vec = (target.Position - npc.Position):Rotated(-135)
				local vecA = vec:GetAngleDegrees() * -1
				local ang = math.floor((vecA / 90 % 4))
				d.shootAng = ang + 1
			elseif sprite:IsPlaying("PeeplingAttack") and sprite:GetFrame() == 2 then
				--[[ old
				for index,entity in ipairs(Isaac.FindByType(980, 92, 2, EntityPartition.ENEMY, true)) do
					local ed = mod:GetEntityData(entity)
					if ed.state == "idle" then
						ed.state = "shoot"
						ed.playerpos = target.Position + target.Velocity * 5
						ed.vecang = mod:calcPeepeeDir(target.Position - entity.Position) + 1
						ed.wait = math.random(1,20)
						entity:Update()
					end
				end ]]
			elseif sprite:IsEventTriggered("Shoot") then
				npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,1,0,false,0.9)
				local vel = Vector(0, 10):Rotated(d.rotVal)
				local p = mod:LazySpawnProjectile(0, 0, npc.Position, vel, npc):ToProjectile()
				p.FallingSpeed = 0
				p.FallingAccel = -0.1
				p.Parent = npc
				p.ProjectileFlags = p.ProjectileFlags | ProjectileFlags.GHOST
				p.Color = mod.ColorNormal
				p.Scale = 2

				local pd = mod:GetEntityData(p)
				pd.projType = "peepingBoss"
				pd.origVel = p.Velocity
				pd.orderVal = d.orderVal[1] + 1

				p:Update()

				table.insert(d.tears, p)
				d.rotVal = d.rotVal - 18
				d.orderVal[2] = (d.orderVal[2] + 1) % 5
				if d.orderVal[2] == 0 then
					d.orderVal[1] = (d.orderVal[1] + 1) % 4
				end
			else
				mod:spritePlay(sprite, "PeeplingAttack")
			end
		elseif d.substate == "SHOOT SON" then
			if sprite:IsFinished("Peepling0" .. d.shootAng) then
				d.substate = nil
				d.ad[2][2] = d.ad[2][2] + 1
				d.state = "idle"
			elseif sprite:IsEventTriggered("Shoot") then
				local corners = {}
				for i = 0, 360, 90 do
					corners[#corners + 1] = target.Position + Vector(120, 0):Rotated(i + 45)
				end

				local peepees = Isaac.FindByType(mod.FF.Peepstalk.ID, mod.FF.Peepstalk.Var, 2, EntityPartition.ENEMY, true)
				local pospairs = mod:PairEntitiesToPositions(peepees, corners)
				for ind, entpair in ipairs(pospairs) do
					local ent = entpair.ent
					local pos = corners[entpair.posind]
					local ed = mod:GetEntityData(ent)
					if ed.state == "idle" then
						ed.state = "shoot"
						ed.shoottarget = pos
						ed.vecang = mod:calcPeepeeDir(ed.shoottarget - ent.Position) + 1
						ed.wait = 0
						ent:Update()
					end
				end

				npc:PlaySound(SoundEffect.SOUND_BOSS_LITE_HISS, 0.4, 0, false, 0.7)
				for i = 1, #d.tears do
					if d.tears[i] then
						d.tears[i].Parent = nil
						local teard = mod:GetEntityData(d.tears[i])
						teard.Fired = true
						if teard.orderVal then
							if teard.orderVal == d.shootAng then
								teard.origVel = teard.origVel * 1.2
							else
								teard.origVel = teard.origVel * 0.7
							end
						end
					end
				end
			else
				mod:spritePlay(sprite, "Peepling0" .. d.shootAng)
			end
		end
	elseif d.state == "BWOOOOM" then
		d.substate = d.substate or "hugeAssAttackTell"
		if d.substate == "hugeAssAttackTell" then
			if sprite:IsFinished("BrimstoneTell") or (sprite:GetFrame() == 75 and not d.successfullBrimDid) then
				d.substate = "fireUp"
				d.recordedPos = target.Position - (target.Velocity * 20)
				d.animNum = mod:calcPeepDir(d.recordedPos - npc.Position) + 1
				d.moveToCentre = false
			elseif sprite:GetFrame() == 52 then
				for index,entity in ipairs(Isaac.FindByType(mod.FF.Peepstalk.ID, mod.FF.Peepstalk.Var, 2, EntityPartition.ENEMY, true)) do
					local ed = mod:GetEntityData(entity)
					if ed.state == "brimPrepare" then
						ed.state = "brimSHOOTE"
						entity:Update()
					end
				end
			elseif sprite:IsEventTriggered("Scream") then
				npc:PlaySound(SoundEffect.SOUND_RAGMAN_2,1,0,false,0.8)
				sfx:Stop(mod.Sounds.StretchEye)
				d.moveToCentre = true
			elseif sprite:IsEventTriggered("HemolacriaStart") then
				npc:PlaySound(mod.Sounds.StretchEye,0.4,0,false,1.3)
				for index,entity in ipairs(Isaac.FindByType(mod.FF.Peepstalk.ID, mod.FF.Peepstalk.Var, 2, EntityPartition.ENEMY, true)) do
					local ed = mod:GetEntityData(entity)
					if not ed.brimming then
						ed.state = "brimPrepare"
						ed.targetPos = target.Position
						ed.brimming = true
						entity:Update()
						d.successfullBrimDid = true
					end
				end
			else
				mod:spritePlay(sprite, "BrimstoneTell")
			end
			if d.moveToCentre then
				local targ = room:GetCenterPos()
				local targVec = (targ - npc.Position)
				npc.Velocity = mod:Lerp(npc.Velocity, targVec * 0.06, 0.3)
			end
		elseif d.substate == "fireUp" then
			npc.Velocity = nilvector
			if sprite:IsPlaying("Brimstone0" .. d.animNum) and sprite:GetFrame() == 15 then
				--Safety check
				d.substate = "trackTheBastard"
				npc.StateFrame = 0
			elseif sprite:IsEventTriggered("Shoot") then
				local shootVec = d.recordedPos - npc.Position
				local laser = EntityLaser.ShootAngle(1, npc.Position + Vector(0, -40) + mod.peepLaserOffsets[d.animNum], shootVec:GetAngleDegrees(), 999999999, Vector(0, -20), npc)
				laser.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
				laser.CollisionDamage = 0
				laser.DepthOffset = 45
				laser:Update()
				d.Brimmy = laser:ToLaser()
				d.substate = "trackTheBastard"
				npc.StateFrame = 0
			else
				mod:spritePlay(sprite, "Brimstone0" .. d.animNum)
			end
		elseif d.substate == "trackTheBastard" then
			npc.Velocity = nilvector
			d.recordedPos = mod:Lerp(d.recordedPos, target.Position, 0.1)
			if target.Velocity:LengthSquared() >= 2 then
				d.recordedVel = target.Velocity
			end

			local laserVec = d.recordedPos - (npc.Position + Vector(0, -40))
			local val = mod:calcPeepDir(laserVec) + 1
			sprite:SetFrame("BrimLoop0" .. val, npc.StateFrame % 24)
			--Default Timer is 30
			local brimTimer = 30
			if d.Brimmy then
				d.Brimmy.DisableFollowParent = true
				d.Brimmy.Angle = laserVec:GetAngleDegrees()
				d.Brimmy.SpawnerEntity = npc
				d.Brimmy.Parent = npc
				d.Brimmy.Position = npc.Position + Vector(0, -40) + mod.peepLaserOffsets[val]
				d.Brimmy.DepthOffset = 45

				local vec = (laserVec * -1):Rotated(-90 + math.random(180)):Resized(math.random(10,15))
				local brimDrops = Isaac.Spawn(1000, 70, 0, d.Brimmy:GetEndPoint(), vec, nil):ToEffect()
				brimDrops.FallingAcceleration = 1.3
				brimDrops.FallingSpeed = -3
				brimDrops.PositionOffset = Vector(vec.X, math.abs(vec.Y) * -1)
				brimDrops:Update()

				if npc.StateFrame == brimTimer then
					d.Brimmy.Timeout = 10
				end
				d.Brimmy:Update()
			end
			if npc.StateFrame > brimTimer + 5 then
				d.substate = "finishThis"
				--Failsafe
				d.Brimmy.Timeout = 5.

				-- if the player stops, don't shoot brimstone straight at them
				local useVel = d.recordedVel or target.Velocity
				local length = useVel:Length()
				if not target:IsDead() and not target:HasMortalDamage() then
					local normal = useVel / length
					d.recordedPos2 = target.Position + (normal * math.max(length * 120,300))
				else
					d.recordedPos2 = target.Position
				end

				d.recordedVel = nil
				d.animNum = mod:calcPeepDir(d.recordedPos2 - npc.Position) + 1
			end
		elseif d.substate == "finishThis" then
			if sprite:IsFinished("Brimstone0" .. d.animNum) then
				d.ad[3][2] = d.ad[3][2] + 3
				d.state = "idle"
			elseif sprite:IsEventTriggered("Shoot") then
				local shootVec = d.recordedPos2 - npc.Position
				local laser = EntityLaser.ShootAngle(1, npc.Position + Vector(0, -40) + mod.peepLaserOffsets[d.animNum], shootVec:GetAngleDegrees(), 20, Vector(0, -20), npc)
				laser.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
				laser.CollisionDamage = 0
				laser.DepthOffset = 45
				laser:Update()
			else
				mod:spritePlay(sprite, "Brimstone0" .. d.animNum)
			end
		end
	end

end

mod.peepLaserOffsets = {
--I hate myself
[1] = Vector(2,3),
[2] = Vector(19,3),
[3] = Vector(32,-2),
[4] = Vector(27,-6),
[5] = Vector(10,-8),
[6] = Vector(-10,-8),
[7] = Vector(-24,-6),
[8] = Vector(-29,-2),
[9] = Vector(-15,3)
}

function mod.peepingprojupdate(v,d)
	if d.projType == "peepingBoss" then
		v.Color = mod.ColorNormal
		--[[for _, tear in pairs(Isaac.FindByType(2, -1, -1, false, false)) do
			if tear.Position:Distance(v.Position) < 20 then
				tear:Remove()
			end
		end]]
		if v.Parent and v.Parent.HitPoints > 99 then
			local p = v.Parent

			local offsetval = 75
			if v.FrameCount < 15 then
				offsetval = v.FrameCount * math.max(1, (10 - v.FrameCount/3))
				v.Velocity = p.Velocity + (d.origVel * (1 - (math.max(5, v.FrameCount))/10))
			else
				v.Velocity = p.Velocity
			end

			v.Position = p.Position + d.origVel:Resized(offsetval)

		else
			if d.Fired then
				v.Velocity = d.origVel
			else
				v.FallingSpeed = 1
				v.FallingAccel = 1
			end
			v.ProjectileFlags = v.ProjectileFlags ~ ProjectileFlags.GHOST
			d.projType = nil
		end
	elseif d.projType == "HemoPart2" then
		if v:IsDead() then
			sfx:Play(SoundEffect.SOUND_MEAT_IMPACTS, 1, 0, false, 1.5);
			local vec = Vector(10,0)
			d.hemoRot = d.hemoRot or 0
			for i = 90, 360, 90 do
				local projectile = mod:LazySpawnProjectile(0, 0, v.Position + vec:Rotated(i + d.hemoRot), vec:Rotated(i + d.hemoRot), v):ToProjectile();
				projectile.ProjectileFlags = v.ProjectileFlags
			end
		end
	elseif d.projType == "SlowDownSon" then
		d.slowDownSpeed = d.slowDownSpeed or 0.97
		v.Velocity = v.Velocity * d.slowDownSpeed
	elseif d.projType == "peepstalk" then -- why figure out how to calculate arcs to land at the right position when you could just fake it with rotation?
		local through = v.FrameCount / d.timeout
		local height = -(Vector(65, 0):Rotated(mod:Lerp(60, 180, through)).Y)
		height = height - 10

		v.FallingSpeed = height - v.Height
		v.FallingAccel = 0

		if v.FrameCount >= d.timeout or v:IsDead() then
			sfx:Play(SoundEffect.SOUND_MEAT_IMPACTS, 1, 0, false, 1.5);
			local vec = Vector(5,0)
			local creep = Isaac.Spawn(1000,22,0,v.Position,Vector.Zero,v):ToEffect()
			creep:SetTimeout(30)
			--[[for i = 90, 360, 90 do
				local projectile = mod:LazySpawnProjectile(0, 0, v.Position + vec:Rotated(i), vec:Rotated(i), v):ToProjectile();
				projectile.FallingSpeed = -10;
				projectile.FallingAccel = 1.5;
				projectile.ProjectileFlags = v.ProjectileFlags
			end]]

			if not v:IsDead() then
				v:Die()
			end
		end
	end
end

function mod:bigHemoProjAI(npc)
	local d = mod:GetEntityData(npc)
	local r = npc:GetDropRNG()

	if not d.init then
		npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
		d.init = true
	end
	d.vec = d.vec or nilvector
	npc.Velocity = d.vec

	mod:spritePlay(npc:GetSprite(), "Idle")

	if npc.SpriteOffset.Y > -20 then
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
	else
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	end

	d.fallspeed = d.fallspeed or -5
	d.fallspeed = d.fallspeed + 0.5
	npc.SpriteOffset = Vector(0, npc.SpriteOffset.Y + d.fallspeed)

	if npc:CollidesWithGrid() or npc.SpriteOffset.Y > 0 then
		npc:PlaySound(SoundEffect.SOUND_MEATHEADSHOOT,1,0,false,0.7)

		local sploshEffect = Isaac.Spawn(1000, 1738, 0, npc.Position, nilvector, npc):ToEffect()
		sploshEffect.SpriteOffset = npc.SpriteOffset
		sploshEffect:Update()
		npc:Remove()

		local params = ProjectileParams()
		for i = 45, 360, 45 do
			local rand = r:RandomFloat()
			local p = mod:LazySpawnProjectile(0, 0, npc.Position, Vector(0,6):Rotated(i), npc):ToProjectile()
			p.FallingSpeed = -25
			p.FallingAccel = 1.5
			p.Parent = npc
			p.Scale = 2

			local pd = mod:GetEntityData(p)
			pd.projType = "HemoPart2"
			if i % 90 == 0 then
				pd.hemoRot = 45
			end

			p:Update()
		end

	end
end

function mod:hemoSplat(e)
	local anim = mod:GetEntityData(e).anim or "Poof"
	if e:GetSprite():IsFinished(anim) then
		e:Remove()
	else
		mod:spritePlay(e:GetSprite(), anim)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.hemoSplat, 1738)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.hemoSplat, 1739)
--It does the same thing so ykno

--peeping2
function mod:peepingPhase2AI(npc, sprite, d)
	local subt = npc.SubType
	local target = npc:GetPlayerTarget()

	if not d.init then
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		d.state = "fallDown"
		sprite:Play("Appear", true)
		d.init = true
	else
		npc.StateFrame = npc.StateFrame + 1
	end

	if d.state == "fallDown" then
		if sprite:IsFinished("Appear") then
			d.state = "moveBitchGetOutTheWay"
			npc.StateFrame = 0
		elseif sprite:IsEventTriggered("Hop") then
			d.moving = true
		elseif sprite:IsEventTriggered("Land") then
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			if not d.bouncedYet then
				npc:PlaySound(SoundEffect.SOUND_FORESTBOSS_STOMPS,0.5,0,false,1)
				game:ShakeScreen(15)
				d.bouncedYet = true
			else
				d.finallyLanded = true
				npc:PlaySound(SoundEffect.SOUND_FORESTBOSS_STOMPS,0.3,0,false,1.3)
				game:ShakeScreen(5)
			end
		else
			mod:spritePlay(sprite, "Appear")
		end
	elseif d.state == "moveBitchGetOutTheWay" then
		if npc.Velocity.X > 0 then
			if npc.Velocity.Y > 0 then
				d.movAl = 1
			else
				d.movAl = 4
			end
		else
			if npc.Velocity.Y > 0 then
				d.movAl = 2
			else
				d.movAl = 3
			end
		end
		sprite:SetFrame("Walk0" .. d.movAl, npc.StateFrame % 18)
	end

	if d.moving then
		if npc.FrameCount % 3 == 1 then
			local blood = Isaac.Spawn(1000, 7, 0, npc.Position, nilvector, npc)
			blood.SpriteScale = Vector(0.4,0.4)
			blood:Update()
		end

		local peepees = mod.GetEntityCount(mod.FF.Peepee.ID, mod.FF.Peepee.Var)
		if peepees > 0 then
			peepees = peepees + 1
		end

		local speedNerf = math.floor(((peepees ^ 2) * 0.25))
		d.speed = math.max(9 - speedNerf, 4.5)
		if not d.finallyLanded then
			d.speed = 3.5
		end

--		d.speed = d.speed or 4.5
		if d.changeOff and d.changeOff % 2 == 1 then
			mod:diagonalMove(npc, d.speed, nil, 0.3, true)
		else
			mod:diagonalMove(npc, d.speed, nil, 0.6, true)
		end

		for k,v in ipairs(mod.GetGridEntities()) do
			if v.Position:Distance(npc.Position) < 45 then
				v:Destroy()
			end
		end
		if npc:CollidesWithGrid() and npc.StateFrame > 15 then
			if npc.HitPoints > 10 then
				npc:TakeDamage(3.5, 0, EntityRef(npc), 0)
			end

			d.changeOff = d.changeOff or 0
			d.changeOff = d.changeOff + 1
			npc:PlaySound(SoundEffect.SOUND_FORESTBOSS_STOMPS,0.5,0,false,math.random(95,105)/100)
			game:ShakeScreen(5)
			npc.StateFrame = 0
			local projCount = 8
			local rot = -26.5
			for i = 1, 2 do
				if i == 2 then
					projCount = 16
					rot = 0
				elseif i == 1 then
					rot = 26.5
				end

				for j = 1, projCount do
					local rotVal = ((360 / projCount) * j) + rot
					local vec = Vector(11,0):Rotated(rotVal)
					--npc:FireProjectiles(npc.Position + vec:Resized(20 + rot/3), vec, 0, ProjectileParams())
					local projectile = mod:LazySpawnProjectile(0, 0, npc.Position + vec:Resized(20 + rot/3), vec, npc):ToProjectile();
					projectile.FallingAccel = -0.05
					local projdata = mod:GetEntityData(projectile);
					projdata.projType = "SlowDownSon"
				end
			end
		end
	end

end

function mod:peepstalkAI(npc, sprite, d)
	local subt = npc.SubType
	local target = npc:GetPlayerTarget()

	npc.Velocity = nilvector

	if subt == 0 then
		npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS)
		npc.Visible = false
	else
		if not d.init then
			npc:ClearEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
			mod:spritePlay(sprite, "Drop")
			npc.Visible = true
			d.state = "appear"
			d.init = true
		else
			npc.StateFrame = npc.StateFrame + 1
		end

		if d.state == "appear" then
			if sprite:IsFinished("PillarAppear") then
				d.state = "waitingForLove"
			elseif sprite:IsEventTriggered("DMG") then
				npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			else
				mod:spritePlay(sprite, "PillarAppear")
			end
		elseif d.state == "waitingForLove" then
			mod:spritePlay(sprite, "Idle02")
			if subt == 2 then
				d.state = "Land"
				mod:spritePlay(sprite, "Land")
			end
		elseif d.state == "Land" then
			if sprite:IsFinished("Land") then
				d.state = "idle"
			else
				mod:spritePlay(sprite, "Land")
			end
		elseif d.state == "idle" then
			mod:spritePlay(sprite, "Idle01")
			if mod.GetEntityCount(mod.FF.Peeping.ID, mod.FF.Peeping.Var) < 1 then
				d.state = "collapse"
			--[[elseif npc.StateFrame > 50 and math.random(15) == 1 then
				d.state = "shoot"
				d.playerpos = target.Position + target.Velocity * 5
				d.vecang = mod:calcPeepeeDir(target.Position - npc.Position) + 1]]
			end
		elseif d.state == "shoot" then
			if sprite:IsFinished("Shoot0" .. d.vecang) then
				d.state = "idle"
				npc.StateFrame = 0
			elseif sprite:IsEventTriggered("Shoot") then
				-- OLD: local shotspeed = (target.Position - npc.Position)*0.05
				--[[
				local shotspeed = (d.shoottarget - npc.Position)*0.06
				if shotspeed:Length() > 8 then
					shotspeed = shotspeed:Resized(8)
				end
				local projectile = mod:LazySpawnProjectile(0, 0, npc.Position, shotspeed, npc):ToProjectile();
				projectile.FallingAccel = 0.5;
				projectile.Height = -85
				projectile.Scale = 2
				mod:GetEntityData(projectile).projType = "CricBod2"]]

				local flighttime = 20
				local shotspeed = (d.shoottarget - npc.Position) / flighttime
				local projectile = mod:LazySpawnProjectile(0, 0, npc.Position, shotspeed, npc):ToProjectile();
				projectile.Scale = 2
				mod:GetEntityData(projectile).projType = "peepstalk"
				mod:GetEntityData(projectile).timeout = flighttime

				npc.StateFrame = 0
			else
				if d.wait and d.wait > 0 then
					d.wait = d.wait - 1
				else
					mod:spritePlay(sprite, "Shoot0" .. d.vecang)
				end
			end
		elseif d.state == "brimPrepare" then
			d.shooting = false
			d.targetPos = d.targetPos or target.Position
			if sprite:IsFinished("BrimstoneTell") then
				mod:spritePlay(sprite, "Idle01Brim")

			else
				if not d.prepared then
					mod:spritePlay(sprite, "BrimstoneTell")
					local tracer = Isaac.Spawn(1000, 198, 0, npc.Position, Vector(0.001,0), npc):ToEffect()
					tracer.Timeout = 60
					tracer.TargetPosition = Vector(1,0):Rotated(mod:GetAngleDegreesButGood(target.Position - npc.Position))
					tracer.LifeSpan = 55
					tracer:FollowParent(npc)
					tracer.SpriteScale = Vector(2,2)
					tracer.Color = Color(1,0.2,0,0.3,0.2,0,0)
					tracer.SpriteOffset = Vector(0, 57)
					tracer:Update()
					d.prepared = true
				end
			end
		elseif d.state == "brimSHOOTE" then
			d.prepared = false
			--They should know this but I just want to be safe
			d.targetPos = d.targetPos or target.Position
			d.shootang = d.targetPos - (npc.Position + Vector(0, -58))

			d.vecang = d.vecang or mod:calcPeepeeDir(d.shootang) + 1

			if sprite:IsFinished("Brimstone0" .. d.vecang) then
				d.vecang = nil
				d.shootang = nil
				d.brimming = nil
				d.state = "idle"
			elseif sprite:IsEventTriggered("Shoot") then
				local laser = EntityLaser.ShootAngle(1, npc.Position + Vector(0, -58) + d.shootang:Resized(3), d.shootang:GetAngleDegrees(), 10, Vector(0, -20), npc)
				laser.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
				laser.CollisionDamage = 0
				laser.DepthOffset = 57
				laser:Update()
			else
				mod:spritePlay(sprite, "Brimstone0" .. d.vecang)
			end
		elseif d.state == "collapse" then
			if sprite:IsEventTriggered("Explode") or sprite:IsFinished("PillarDeath") then
				npc:BloodExplode()
				d.state = "boop"
				npc:Morph(mod.FF.Peepee.ID, mod.FF.Peepee.Var, 2, -1)
			else
				mod:spritePlay(sprite, "PillarDeath")
			end
		end

		--[[if d.shooting then
			if npc.StateFrame % 2 == 0 then
				local vec = (d.playerpos - npc.Position) * 0.045
				if vec:Length() > 10 then
					vec = vec:Resized(10)
				end
				local params = ProjectileParams()
				params.HeightModifier = -55
				params.FallingAccelModifier = 0.3
				npc:FireProjectiles(npc.Position + vec:Resized(15), vec, 0, params)
				d.shooting = d.shooting + 1
				if d.shooting == 4 then
					d.shooting = nil
				end
			end
		end]]
	end
end

function mod:peepeeAI(npc, sprite, d)
	local room = game:GetRoom()
	local subt = npc.SubType
	local target = npc:GetPlayerTarget()
	if not d.init then
		if subt == 1 then
			d.state = "air"
		elseif subt == 2 then
			d.state = "boop"
		else
			d.state = "idle"
			npc.SpriteOffset = Vector(0, 3)
		end
		d.init = true
	else
		npc.StateFrame = npc.StateFrame + 1
	end



	if d.state == "air" then
		mod:spritePlay(sprite, "InAir")
		local vec = (d.endGoal - npc.Position)
		npc.Velocity = mod:Lerp(npc.Velocity, vec * 0.1, 0.3)
		d.fallspeed = d.fallspeed or -7
		d.fallspeed = d.fallspeed + 0.5
		npc.SpriteOffset = Vector(0, npc.SpriteOffset.Y + d.fallspeed)
		--print(npc.SpriteOffset.Y)
		if npc.SpriteOffset.Y > -51 and (d.target and npc.Position:Distance(d.target.Position) < 10 and not d.target:IsDead()) then
			d.target.SubType = 2
			d.target:Update()
			npc:Remove()
		elseif npc.SpriteOffset.Y > 1 then
			d.state = "suddenLand"
			npc.SpriteOffset = Vector(0, 3)
		end
	elseif d.state == "idle" then
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		mod:spritePlay(sprite, "Idle03")
		npc.Velocity = npc.Velocity * 0.9
		if npc.StateFrame > 5 and math.random(5) == 1 then
			d.yorsopposedtojompatme = d.yorsopposedtojompatme or math.random(3) - 1
			if room:CheckLine(target.Position,npc.Position,3,900,false,false) and d.yorsopposedtojompatme > 2 and not mod:isScareOrConfuse(npc) then
				d.state = "shoote"
				d.yorsopposedtojompatme = 0
			else
				d.state = "joomp"
				d.yorsopposedtojompatme = d.yorsopposedtojompatme + 1
			end
		end
	elseif d.state == "joomp" then
		if sprite:IsFinished("Hop") then
			d.state = "idle"
			npc.StateFrame = 0
		elseif sprite:IsEventTriggered("Hop") then
			npc:PlaySound(SoundEffect.SOUND_MEAT_JUMPS,0.7,0,false,1)
			d.jumping = true
			if mod:isScare(npc) or (room:CheckLine(target.Position,npc.Position,0,900,false,false) and math.random(3) == 1 and not mod:isConfuse(npc)) then
				npc.Velocity = mod:reverseIfFear(npc, (target.Position - npc.Position):Resized(6))
			else
				npc.Velocity = RandomVector()*6
			end
			if npc.Velocity.X > 0 then
				sprite.FlipX = false
			else
				sprite.FlipX = true
			end
		elseif sprite:IsEventTriggered("Land") then
			npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS,1,0,false,1)
			d.jumping = false
		else
			mod:spritePlay(sprite, "Hop")
		end

		if not d.jumping then
			npc.Velocity = npc.Velocity * 0.9
		end
	elseif d.state == "shoote" then
		npc.Velocity = npc.Velocity * 0.9
		if sprite:IsFinished("Shoot") then
			d.state = "idle"
		elseif sprite:IsEventTriggered("Shoot") then
			npc:PlaySound(SoundEffect.SOUND_WORM_SPIT,1,0,false,1)
			if target.Position.X > npc.Position.X then
				sprite.FlipX = false
			else
				sprite.FlipX = true
			end
			local shootVec = (target.Position - npc.Position):Resized(8)
			--[[for i = -30, 30, 20 do
				npc:FireProjectiles(npc.Position + shootVec, shootVec:Rotated(i), 0, ProjectileParams())
			end]]
			local params = ProjectileParams()
			params.Scale = 2
			npc:FireProjectiles(npc.Position + shootVec, shootVec, 0, params)
		else
			mod:spritePlay(sprite, "Shoot")
		end
	elseif d.state == "boop" then
		npc.Velocity = npc.Velocity * 0.9
		if sprite:IsFinished("PeepeeFall") then
			d.state = "transform"
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL --Just making sure at this point
		elseif sprite:IsEventTriggered("Land") then
			npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS,1,0,false,1)
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			npc.SpriteOffset = Vector(0, 3)
		else
			mod:spritePlay(sprite, "PeepeeFall")
		end
	elseif d.state == "transform" then
		npc.Velocity = npc.Velocity * 0.9
		if sprite:IsFinished("Transform") then
			d.state = "idle"
		elseif sprite:IsEventTriggered("Explode") then
			npc:BloodExplode()
		else
			mod:spritePlay(sprite, "Transform")
		end
	elseif d.state == "suddenLand" then
		npc.Velocity = npc.Velocity * 0.9
		if sprite:IsFinished("SuddenLand") then
			d.state = "transform"
		else
			mod:spritePlay(sprite, "SuddenLand")
		end
	end
end

--POLLUTION YO
--BORN 2 LOSE SK8 AND DESTROY

mod.pollutionTricks = {
	[1] = {stateName = "SpitBlot", FadeVal1 = 3, FadeVal2 = 3, Idle1 = 4, Idle2 = 7, AttackOff = 250},
	[2] = {stateName = "KickFlip", FadeVal1 = 2, FadeVal2 = 2, Idle1 = 3, Idle2 = 6, AttackOff = 200},
	[3] = {stateName = "BigSwing", FadeVal1 = 4, FadeVal2 = 2, Idle1 = 5, Idle2 = 6, AttackOff = 200},
	[4] = {stateName = "nilpasta", FadeVal1 = 1, FadeVal2 = 1, Idle1 = 2, Idle2 = 2, AttackOff = 200},
	[5] = {stateName = "EndTrick", FadeVal1 = 1, FadeVal2 = 1, Idle1 = 2, Idle2 = 2, AttackOff = 50}
}

function mod:pollutionSmoke(npc, xoff, yoff)
	xoff = xoff or 40
	yoff = yoff or 10
	if not npc:GetSprite().FlipX then
		xoff = xoff * -1
	end
	local extravel = Vector(xoff / 5, 0):Rotated(-20 + math.random(40))
	local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, npc.Position + Vector(xoff, yoff), extravel, npc)
	smoke:GetSprite().PlaybackSpeed = math.random() * 0.4 + 0.4
	smoke.SpriteScale = Vector(1,1)
	smoke.SpriteOffset = Vector(0, -25)
	smoke:Update()
end

function mod:pollutionAI(npc, sprite, d)
	local target = npc:GetPlayerTarget()
	local r = npc:GetDropRNG()
	local room = game:GetRoom()

	if not d.init then
		d.state = "idle"
		npc.Velocity = RandomVector() * 3
		d.init = true
		npc.SplatColor = mod.ColorDankBlackReal
	else
		npc.StateFrame = npc.StateFrame + 1
	end

	if mod.allPlayersDead() then
		npc:PlaySound(mod.Sounds.PollutionWins, 2, 0, false, 1)
	end

	if d.state ~= "crash" and npc.HitPoints < 300 then
		if not (d.substate == jumpOut or d.substate == jumpIn) then
			sfx:StopLoopingSounds()
			d.state = "crash"
			d.substate = nil
		end
	end

	if d.state == "idle" then
		mod:spritePlay(sprite, "Idle01")
		if npc.Velocity.X < 0 then
			sprite.FlipX = true
		else
			sprite.FlipX = false
		end
		npc.Velocity = mod:Lerp(npc.Velocity, npc.Velocity:Resized(3), 0.3)
		--npc.Velocity = npc.Velocity:Rotated(-10 + math.random(20))
		if npc.StateFrame > 20 then
			if d.doSomeTricks then
				d.state = "showOff"
			else
				d.state = "chase"
			end
			d.substate = nil
		end
	elseif d.state == "crash" then
		npc.Velocity = npc.Velocity * 0.7
		d.substate = d.substate or "screech"
		if d.substate == "screech" then
			if sprite:IsFinished("FallOffHorse") then
				d.substate = "horseTime"
			elseif sprite:IsEventTriggered("Fall") then
				npc:PlaySound(mod.Sounds.WhipCrack,0.7,0,false,0.7)
				local pp2 = Isaac.Spawn(mod.FF.Pollution2.ID, mod.FF.Pollution2.Var, 0, npc.Position, nilvector, npc)
				local pp2d = mod:GetEntityData(pp2)
				pp2.Parent = npc
				pp2d.backupPosition = npc.Position
				npc.Child = pp2
				pp2d.state = "launched"
				pp2:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				pp2.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				pp2.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
				pp2:Update()
				d.spawnedPhase2 = true
			else
				mod:spritePlay(sprite, "FallOffHorse")
			end
		elseif d.substate == "horseTime" then
			mod:spritePlay(sprite, "Horse")
		end
	elseif d.state == "chase" then
		d.substate = d.substate or "revThoseFryers"
		if d.substate == "revThoseFryers" then
			if sprite:IsFinished("ChaseStart") then
				d.substate = "vROOM"
				npc.StateFrame = 0
			elseif sprite:IsEventTriggered("Laugh") then
				npc:PlaySound(mod.Sounds.PollutionSmirk, 1.6, 0, false, 1.1)
			elseif sprite:IsEventTriggered("Screech") then
				npc:PlaySound(mod.Sounds.CarIgnition, 0.7, 0, false, 1.3)
			elseif sprite:IsEventTriggered("Chase") then
				d.chasing = true
			else
				mod:spritePlay(sprite, "ChaseStart")
			end
		elseif d.substate == "vROOM" then
			mod:spritePlay(sprite, "ChaseLoop")
			if npc.StateFrame > 120 then
				d.substate = "haltCitizen"
			end
		elseif d.substate == "haltCitizen" then
			if sprite:IsFinished("Halt") then
				d.state = "idle"
				npc.StateFrame = 0
				d.doSomeTricks = true
			elseif sprite:IsEventTriggered("Halt") then
				d.chasing = false
				sfx:Stop(mod.Sounds.LoopingBike)
				npc:PlaySound(mod.Sounds.SkidShort, 1, 0, false, 1)
			else
				mod:spritePlay(sprite, "Halt")
			end
		end
		if d.chasing then
			if not sfx:IsPlaying(mod.Sounds.LoopingBike) then
				sfx:Play(mod.Sounds.LoopingBike, 1, 0, true, 0.3)
			end
			if npc.Velocity.X < 0 then
				sprite.FlipX = true
			else
				sprite.FlipX = false
			end

			mod:pollutionSmoke(npc)

			--[[local targvel = (target.Position - npc.Position):Resized(9)
			npc.Velocity = mod:Lerp(npc.Velocity, targvel, 0.1)]]
			mod:CatheryPathFinding(npc, target.Position, {
			Speed = 16,
			Accel = 0.05,
			GiveUp = true
			})

			if npc.StateFrame % 2 == 0 then
				for i = -30, 30, 60 do
					local projectile = mod:LazySpawnProjectile(0, 0, npc.Position, npc.Velocity:Resized(-14):Rotated(i), npc):ToProjectile();
					projectile.FallingAccel = 0
					local projdata = mod:GetEntityData(projectile);
					projdata.projType = "SlowDownSon"
					projdata.slowDownSpeed = 0.9
				end
			end
		else
			npc.Velocity = npc.Velocity * 0.9
		end
	elseif d.state == "showOff" then
		if not d.substate then
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
			d.tricks = {1}
			for i = 2, 3 do
				table.insert(d.tricks, math.random(#d.tricks + 1), i)
			end
			table.insert(d.tricks, 1, 4)
			table.insert(d.tricks, 5)
			d.trickNum = 1
			d.substate = "andale andale"
			if room:GetCenterPos().X > npc.Position.X then
				d.moveVec = Vector(1,0)
				sprite.FlipX = false
			else
				d.moveVec = Vector(-1,0)
				sprite.FlipX = true
			end
		end

		local inPotentialFlameState = d.substate ~= "andale andale" and d.substate ~= "BigSwing" and d.substate ~= "EndTrick"
		local inNonFlameAnim = sprite:IsPlaying("FadeIn01") or sprite:IsFinished("FadeIn01") or sprite:IsPlaying("FadeOut01") or sprite:IsPlaying("Idle02") or sprite:IsFinished("TrickStart")
		if npc.FrameCount % 4 == 0 and room:IsPositionInRoom(npc.Position, 0) and inPotentialFlameState and not inNonFlameAnim then
			local fire = Isaac.Spawn(1000,7005, 20, npc.Position - npc.Velocity:Resized(35), npc.Velocity:Resized(-1.5) + RandomVector() * .3, npc):ToEffect()
			mod:GetEntityData(fire).timer = 55
			--mod:GetEntityData(fire).gridcoll = 0
			fire.Parent = npc
			fire:Update()
		end

		if d.substate == "andale andale" then
			if sprite:IsFinished("TrickStart") then
				d.substate = "charging"
				d.chargeState = 2
			elseif sprite:IsEventTriggered("Halt") then
				npc:PlaySound(mod.Sounds.HorseGoWhee, 1, 0, false, math.random(97,103)/100)
			elseif sprite:IsEventTriggered("Laugh") then
				npc:PlaySound(mod.Sounds.PollutionLaugh, 2, 0, false, 1.3)
			elseif sprite:IsEventTriggered("Shoot") then
				d.charging = 1
				npc:PlaySound(mod.Sounds.PollutionCharge, 2, 0, false, 1)
			elseif sprite:IsEventTriggered("Screech") then
				npc:PlaySound(mod.Sounds.CarIgnition, 0.7, 0, false, 1.3)
				d.SFXSlowCharge = true
				d.playLoop = true
			else
				mod:spritePlay(sprite, "TrickStart")
			end
		elseif d.substate == "charging" then
			--[[for i = 1, #d.tricks do
				Isaac.ConsoleOutput(d.tricks[i])
			end
			Isaac.ConsoleOutput("\n")]]
			mod:pollutionSmoke(npc)

			d.playLoop = true
			mod:spritePlay(sprite, "Idle0" .. mod.pollutionTricks[d.tricks[d.trickNum]]["Idle" .. d.chargeState])
			local offval = mod.pollutionTricks[d.tricks[d.trickNum]].AttackOff
			if d.chargeState == 1 then
				if (npc.Position.X > room:GetCenterPos().X - offval and not sprite.FlipX) or
					(npc.Position.X < room:GetCenterPos().X + offval and sprite.FlipX) then
					d.substate = mod.pollutionTricks[d.tricks[d.trickNum]].stateName
					sfx:Stop(mod.Sounds.LoopingBike)
					npc:PlaySound(mod.Sounds.SkidUltraShort, 1, 0, false, math.random(60,80)/100)
					d.playLoop = false
				end
			else
				if npc.Position.X > room:GetGridWidth()*40-200 and not sprite.FlipX then
					d.substate = "jumpOut"
				elseif sprite.FlipX and npc.Position.X < 200 then
					d.substate = "jumpOut"
				end
			end
		elseif d.substate == "jumpOut" then
			local spriteToPlay = "FadeOut0" .. mod.pollutionTricks[d.tricks[d.trickNum]].FadeVal2
			if sprite:IsFinished(spriteToPlay) then
				local yPos = room:GetCenterPos().Y
				if sprite.FlipX then
					npc.Position = Vector(room:GetGridWidth()*40+100, yPos)
				else
					npc.Position = Vector(-100, yPos)
				end
				d.substate = "jumpIn"
				d.chargeState = 1
				d.trickNum = d.trickNum + 1
			elseif sprite:IsEventTriggered("Jump") then
				d.speed = 8
				npc:PlaySound(mod.Sounds.SkateboardJump, 1, 0, false, 0.9)
			else
				mod:spritePlay(sprite, spriteToPlay)
				if d.speed ~= 8 then
					mod:pollutionSmoke(npc)
				end
			end
		elseif d.substate == "jumpIn" then
			mod:pollutionSmoke(npc)
			local spriteToPlay = "FadeIn0" .. mod.pollutionTricks[d.tricks[d.trickNum]].FadeVal1
			if sprite:IsFinished(spriteToPlay) then
				d.substate = "charging"
				d.chargeState = 1
			elseif sprite:IsEventTriggered("Land") then
				d.speed = 12
				npc:PlaySound(SoundEffect.SOUND_BIRD_FLAP, 2, 0, false, 0.9)
			else
				mod:spritePlay(sprite, spriteToPlay)
			end
		elseif d.substate == "SpitBlot" then
			d.speed = 5
			if sprite:IsFinished("ShootBlot") then
				d.substate = "charging"
				d.speed = 12
				d.chargeState = 2
			elseif sprite:IsEventTriggered("Shoot") then
				npc:PlaySound(mod.Sounds.PollutionVom, 1.5, 0, false, 1)
				for i = 60, 360, 60 do
					local blotVec = Vector(4, 0):Rotated(i - 20 + math.random(40))
					local blot = Isaac.Spawn(mod.FF.Blot.ID, mod.FF.Blot.Var, 0, npc.Position + d.moveVec:Resized(-10), blotVec, npc):ToNPC();
					local blotdata = mod:GetEntityData(blot);
					blotdata.downvelocity = -25
					blotdata.downaccel = 2.5
					blot.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
					blot.GridCollisionClass = GridCollisionClass.COLLISION_NONE
					blot:GetSprite().Offset = Vector(0, -30)
					blotdata.state = "air"
					blot:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					blot:Update()
				end
			else
				mod:spritePlay(sprite, "ShootBlot")
			end
		elseif d.substate == "KickFlip" then
			d.speed = 6
			if sprite:IsFinished("KickFlip") then
				d.substate = "charging"
				d.speed = 12
				d.chargeState = 2
			elseif sprite:IsEventTriggered("Jump") then
				npc:PlaySound(mod.Sounds.SkateboardJump, 1, 0, false, 1)
			elseif sprite:IsEventTriggered("Shoot") then
				d.beeterMode = true
				npc.StateFrame = 0
				d.attackang = (target.Position - npc.Position):Resized(7)
				d.strobe = Vector(d.moveVec.X * 60, 0)
				d.strobeUpd = Vector(d.moveVec.X * -12, 0)
			elseif sprite:IsEventTriggered("Land") then
				d.beeterMode = false
				sfx:Stop(SoundEffect.SOUND_ULTRA_GREED_SPINNING)
				npc:PlaySound(mod.Sounds.SkateboardLand, 1, 0, false, 1)
			else
				mod:spritePlay(sprite, "KickFlip")
			end
		elseif d.substate == "BigSwing" then
			d.speed = 4
			if sprite:IsFinished("Swing") then
				d.substate = "charging"
				d.speed = 12
				d.chargeState = 2
			elseif sprite:IsEventTriggered("Land") then
				npc:PlaySound(SoundEffect.SOUND_BIRD_FLAP, 2, 0, false, 0.9)
				sprite.FlipX = d.currentFlipVal
			elseif sprite:IsEventTriggered("Jump") then
				npc:PlaySound(mod.Sounds.BingBingWahoo, 0.1, 0, false, 0.7)
				npc:PlaySound(mod.Sounds.SkateboardJump, 1, 0, false, 1)
				d.currentFlipVal = sprite.FlipX
				if target.Position.X > npc.Position.X then
					sprite.FlipX = true
				else
					sprite.FlipX = false
				end
			elseif sprite:GetFrame() == 25 then
				npc:PlaySound(SoundEffect.SOUND_FIRE_RUSH, 1, 0, false, 1)
			elseif sprite:IsEventTriggered("Shoot") then
				local targvec = target.Position - npc.Position
				local vec
				local calc = 1
				local angie = 87.5 -- old: 80
				local angieIncrease = 35 -- old: 32
				if math.abs(targvec.X) > math.abs(targvec.Y) * 1.6 then
					calc = 2
					angie = 69 -- old: 60
					angieIncrease = 23 -- old: 20
					if target.Position.X < npc.Position.X then
						vec = Vector(-13,0)
					else
						vec = Vector(13,0)
					end
				else
					if target.Position.Y < npc.Position.Y then
						vec = Vector(0,-9)
					else
						vec = Vector(0,9)
					end
				end
				for i = -angie, angie, angieIncrease do
					local multcalc
					if calc == 1 then
						multcalc = (1 + math.abs(i)/100)
					else
						multcalc = (1.6 - math.abs(i)/100)
					end
					local fire = Isaac.Spawn(1000,7005, 20, npc.Position, (vec * multcalc):Rotated(i) * 0.95, npc):ToEffect()
					mod:GetEntityData(fire).timer = 50
					mod:GetEntityData(fire).gridcoll = 0
					fire.Parent = npc
					fire:Update()
				end
			else
				mod:spritePlay(sprite, "Swing")
			end
		elseif d.substate == "EndTrick" then
			d.charging = 2
			if sprite:IsFinished("Shoot") then
				d.substate = "nil"
				d.speed = nil
				d.chargeState = nil
				d.state = "idle"
				d.doSomeTricks = false
				npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
				d.SFXSlowCharge = false
				sfx:Stop(mod.Sounds.SlowMotor)
				npc.StateFrame = -30
			elseif sprite:IsEventTriggered("Shoot") then
				npc:PlaySound(mod.Sounds.PollutionSpit,1.5,0,false,math.random(80,110)/100)
				d.charging = false
				local gunk = Isaac.Spawn(mod.FF.Punk.ID, mod.FF.Punk.Var, 1, npc.Position, (target.Position - npc.Position):Resized(7), npc)
				gunk.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
				gunk:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				gunk.SpriteOffset = Vector(0, -20)
				gunk.HitPoints = gunk.MaxHitPoints * 0.6
			else
				mod:spritePlay(sprite, "Shoot")
			end
		end

		if d.charging == 1 then
			d.speed = d.speed or 16
			npc.Velocity = mod:Lerp(npc.Velocity, d.moveVec:Resized(d.speed), 0.3)
		elseif d.charging == 2 then
			npc.Velocity = npc.Velocity * 0.9
		else
			npc.Velocity = npc.Velocity * 0.1
		end
		--[[if d.playLoop then
			if not sfx:IsPlaying(mod.Sounds.LoopingBike) then
				sfx:Play(mod.Sounds.LoopingBike, 1, 0, true, 0.8)
			end
		end]]
		if d.SFXSlowCharge then
			if not sfx:IsPlaying(mod.Sounds.SlowMotor) then
				sfx:Play(mod.Sounds.SlowMotor, 1, 0, true, 0.8)
			end
		end
		if d.beeterMode then
			if not sfx:IsPlaying(SoundEffect.SOUND_ULTRA_GREED_SPINNING) then
				sfx:Play(SoundEffect.SOUND_ULTRA_GREED_SPINNING, 0.4, 0, true, 1.8)
			end
			if npc.StateFrame % 3 == 0 then
				local params = ProjectileParams()
				params.FallingAccelModifier = -0.09
				for i = 1, 3 do
					npc:FireProjectiles(npc.Position + d.strobe, d.attackang:Rotated(120*i), 0, params)
				end
				local rotvec = 20
				if sprite.FlipX then rotvec = rotvec * -1 end
				d.attackang = d.attackang:Rotated(rotvec)
				d.strobe = d.strobe + d.strobeUpd
			end
		end
	end

	if npc:HasMortalDamage() then
		sfx:StopLoopingSounds()
	end
end

function mod:pollution2RenderAI(npc)
	local sprite = npc:GetSprite()
	if sprite:IsPlaying("Death") then
		sprite:RemoveOverlay()
		if sprite:IsEventTriggered("Explode") then
			sfx:Play(mod.Sounds.WormSplode, 1, 0, false, 1)
		end
	end
end

function mod:bossCollision(boss, entity, mysteryBoolean)
	local var = boss.Variant
	if var == 0 and boss.SubType == 100 then
		if entity.Type == 1 and mod:GetEntityData(boss).state == "chase" then
			Isaac.Explode(boss.Position, boss, 10)
			boss:Kill()
		end
	end
	if var == 10 then
		if entity:IsEnemy() then
			local d = mod:GetEntityData(boss)
			if d.state == "charge" then
				if d.chargestate == 2 then
					if entity.Type == 33 then
						entity:Kill()
						boss:TakeDamage(20, 0, EntityRef(boss), 0)
					end
					entity:TakeDamage(20, 0, EntityRef(boss), 0)
				end
			end
		end
	elseif boss.Variant >= 50 and boss.Variant <= 55 and entity.Type == mod.FFID.Boss and entity.Variant >= 50 and entity.Variant <= 55 then
		return false
	elseif boss.Variant == 55 and entity.Type == 4 and mod:GetEntityData(entity).sun and entity.FrameCount <= 10 then
		return false
	elseif boss.Variant >= 60 and boss.Variant <= 63 and entity.Type == mod.FFID.Boss and entity.Variant >= 60 and entity.Variant <= 63 then
		return true
	elseif boss.Variant == mod.FF.Basco.Var then
		return mod:bascoCollision(boss, entity)
	elseif boss.Variant == mod.FF.Kingpin.Var then
		if entity.Type == mod.FF.Kingpin.ID and entity.Variant == mod.FF.Kingpin.Var and mod:isInSegmentsOf(entity, boss) then
			return true
		end
	elseif boss.Variant == mod.FF.Tapeworm.Var then
		if entity.Type == mod.FF.Tapeworm.ID and entity.Variant == mod.FF.Tapeworm.Var and mod:isInSegmentsOf(entity, boss) then
			return true
		end
	elseif var == 120 then
		if entity.Type == 33 then
			entity:Kill()
		end
	elseif var == 122 then
		if entity.Type == 33 then
			entity:Kill()
			return false
		elseif entity:IsEnemy() or entity.Type == 1 then
			boss:Kill()
		end
	elseif var == mod.FF.Dusk.Var then
		mod:duskColl(boss, entity)
	elseif var == mod.FF.DuskHand.Var then
		mod:duskHandColl(boss, entity)
	elseif var == mod.FF.Cacamancer.Var then
		if entity.Type == mod.FF.CacaSplurt.ID and entity.Variant == mod.FF.CacaSplurt.Var then
			if mod:GetEntityData(boss).charging and not mod:GetEntityData(entity).collCool then
				entity.Velocity = boss.Velocity
				if math.abs(boss.Position.X - entity.Position.X) > math.abs(boss.Position.Y - entity.Position.Y) then
					boss.Velocity = Vector(-boss.Velocity.X, boss.Velocity.Y)
				else
					boss.Velocity = Vector(boss.Velocity.X, -boss.Velocity.Y)
				end
				mod:GetEntityData(entity).collCool = 3
			end
		end
	elseif var == mod.FF.Emmission.Var then
		return mod:emmissionColl(boss, entity)
	elseif var == mod.FF.EmmissionProjectile.Var then
		mod:emmissionProjectileColl(boss, entity)
	elseif var == mod.FF.Deluge.Var then
		return mod:DelugeCollision(boss, entity)
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, mod.bossCollision, mod.FFID.Boss)

function mod:FakeFart(npc, pos, range)
	range = range or 40
	if npc and (not mod:isFriend(npc)) then
		for _, player in pairs(Isaac.FindInRadius(pos, range, EntityPartition.PLAYER)) do
			player:TakeDamage(1, 0, EntityRef(npc), 0)
		end
	end
end

function mod:FakerFart(npc, pos, range, poisonDmg)
	range = range or 40
	poisonDmg = poisonDmg or 0
	mod:FakeFart(npc, pos, range)
	if npc then
		if mod:isCharm(npc) then
			poisonDmg = math.max(poisonDmg, 3.5)
		end
		if poisonDmg > 0 then
			for _, enemy in pairs(Isaac.FindInRadius(pos, range, EntityPartition.ENEMY)) do
				if enemy:ToNPC() then
					enemy:AddPoison(EntityRef(npc), 90, poisonDmg)
				end
			end
		end
	end
	Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 0, pos, Vector.Zero, npc)
end

mod.KillableTechs = {
	[mod.FF.CherubskullHand.Var] = true,
}

function mod:OnTearColl(tear, npc, mysteryBool)
local etype = npc.Type
local evar = npc.Variant
local esubtype = npc.SubType
local data = mod:GetEntityData(npc)
local sprite = npc:GetSprite()
 -- Death failsafe for euthanasia, chaos card and little horn --
  mod:GetEntityData(tear).FF_InstantKillPierce = false
  if tear.Variant == 9 or
  (tear:HasTearFlags(TearFlags.TEAR_LUDOVICO)) or
  ((tear:HasTearFlags(TearFlags.TEAR_PIERCING)) and not (tear:HasTearFlags(TearFlags.TEAR_BOUNCE))) or
  ((tear:HasTearFlags(TearFlags.TEAR_BELIAL)) and not (tear:HasTearFlags(TearFlags.TEAR_BOUNCE))) then
	mod:GetEntityData(tear).FF_InstantKillPierce = true
  end

 if not npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then

  -- ENEMIES
	if etype == mod.FF.MotherOrb.ID and evar == etype == mod.FF.MotherOrb.Var then
		if tear.Variant == 9 then
			local nd = mod:GetEntityData(npc)
			if nd.DingCount < 5 then
				nd.DamageCount = 15
				nd.DingCount = 4
				game:BombExplosionEffects(npc.Position, 2, 0, mod.ColorNormal, npc, 1, false, true)
			end
			tear:Remove()
		else
			tear:Die()
		end
		return false
	elseif etype == mod.FF.Necornier.ID and evar == mod.FF.Necornier.Var and npc:GetData().state == "Spinnin" then
		local random = mod:RandomInt(1, 3, npc:GetDropRNG())
		if random > 1 then
			tear.Velocity = (tear.Velocity * -0.6):Rotated(-20 + mod:RandomInt(0,40,npc:GetDropRNG()))
			return false
		end
	end
	if (tear.Variant == 9 or tear:HasTearFlags(TearFlags.TEAR_NEEDLE)) then
	  if etype == mod.FFID.Tech then -- Technicals
		if evar == mod.FF.Bubble.Var and mod:shouldDoDeathAnimation(npc) then -- Bubble
			npc.Velocity = nilvector
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			npc.HitPoints = 0
			mod:GetEntityData(npc).IsPopping = true
			npc:ToNPC().State = 11
		elseif (evar == mod.FF.Gary.Var or evar == mod.FF.FlyBundle.Var) and mod:shouldDoDeathAnimation(npc) then -- Gary, Fly Bundle
			npc.Velocity = nilvector
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			npc.HitPoints = 0
			npc:ToNPC().State = 11
		elseif evar == mod.FF.TarBubble.Var and mod:shouldDoDeathEffect(npc) then -- Tar Bubble, Spider Egg
			local r = npc:GetDropRNG()
			if esubtype == 1 then
				for i = 1, math.random(4,10) do
					mod.spawnent(npc, npc.Position, RandomVector()*math.random(20), 85, 962)
				end
			else
				for i = 30, 360, 30 do
					local rand = r:RandomFloat()
					local projectile = mod:LazySpawnProjectile(npc.SubType == 10 and 3 or 0, 0, npc.Position, Vector(0,2):Rotated(i-40+rand*80), npc):ToProjectile()
					projectile.FallingSpeed = -50 + math.random(10)
					projectile.FallingAccel = 2
					projectile.Velocity = projectile.Velocity * (math.random(12, 20)/10)
					projectile.Scale = math.random(8, 12)/10
					projectile.Color = (projectile.Variant == 3) and projectile.Color or (npc.SplatColor or mod.ColorDankBlackReal)
				end
			end
			npc:Kill()
		end
		if not mod.KillableTechs[npc.Variant] then
			if mod:GetEntityData(tear).FF_InstantKillPierce then
				return true
			else
				tear:Die()
				return false
			end
		end
	  elseif etype == mod.FF.GorgerAss.ID and evar == mod.FF.GorgerAss.Var and esubtype ==  mod.FF.GorgerAss.Sub and mod:shouldDoDeathAnimation(npc) then -- Gorger Ass
			local referenceEntity = npc
			if npc.SubType == mod.FF.GorgerAss.Sub and npc.Parent then
				referenceEntity = npc.Parent
			end

			local spawned = Isaac.Spawn(referenceEntity.Type, referenceEntity.Variant, referenceEntity.SubType, referenceEntity.Position, nilvector, referenceEntity)
			spawned:ToNPC():Morph(spawned.Type, spawned.Variant, spawned.SubType, referenceEntity:ToNPC():GetChampionColorIdx())
			spawned.HitPoints = 0
			spawned:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			spawned.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			spawned:ToNPC().State = 11
			spawned:GetSprite().FlipX = referenceEntity:GetSprite().FlipX

			local spawnedData = mod:GetEntityData(spawned)
			spawnedData.FFIsDeathAnimation = true

			if (referenceEntity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)) then
				spawned:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
			end

			if npc.SubType == mod.FF.GorgerAss.Sub then
				if npc.Parent then
					npc.Parent:Remove()
				end
			end
			npc:Remove()

		   if mod:GetEntityData(tear).FF_InstantKillPierce then
			return true
		   else
			tear:Die()
			return false
		   end
	  elseif etype == mod.FF.HeadHoncho.ID and evar == mod.FF.HeadHoncho.Var and mod:shouldDoDeathAnimation(npc) then -- Head Honcho
		if npc:ToNPC().State == 11 then
		   if mod:GetEntityData(tear).FF_InstantKillPierce then
			return true
		   else
			tear:Die()
			return false
		   end
		end
	  elseif etype == mod.FF.Melty.ID and evar == mod.FF.Melty.Var and mod:shouldDoDeathAnimation(npc) then -- Melty
		if npc:ToNPC().State == 11 then
		   if mod:GetEntityData(tear).FF_InstantKillPierce then
			return true
		   else
			tear:Die()
			return false
		   end
		end
	  elseif etype == mod.FF.Phoenix.ID and evar == mod.FF.Phoenix.Var and esubtype == mod.FF.PhoenixUnignited.Sub and mod:shouldDoDeathAnimation(npc) then -- Phoenix
		if npc:ToNPC().State == 11 then
		   if mod:GetEntityData(tear).FF_InstantKillPierce then
			return true
		   else
			tear:Die()
			return false
		   end
		end
	  elseif etype == mod.FF.Blastcore.ID and evar == mod.FF.Blastcore.Var and mod:shouldDoDeathAnimation(npc) then -- Blastcore
		if npc:ToNPC().State == 11 then -- Blastcore currently doesn't play death animation when killed by little horn tear effect.
		   if mod:GetEntityData(tear).FF_InstantKillPierce then
			return true
		   else
			tear:Die()
			return false
		   end
		end
	  end
	 end

  -- BOSSES
	 if tear.Variant == 9 then
	  if etype == mod.FF.Psion.ID and evar == mod.FF.Psion.Var then -- Psion
		 npc.Velocity = nilvector
		 npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		 npc.HitPoints = 0
		 npc:ToNPC().State = 11
		 npc:ToNPC():PlaySound(mod.Sounds.PsionDeath,1,0,false,1)
		 sfx:Stop(mod.Sounds.PsionRedirectLoop)
			return true
	  elseif etype == mod.FFID.Boss and evar == mod.FF.Monsoon.Var then -- Monsoon
		 npc.Velocity = nilvector
		 npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		 npc.HitPoints = 0
		 npc:ToNPC().State = 11
			return true
	  elseif etype == mod.FFID.Boss and evar == mod.FF.SunBody.Var then -- The Sun
		 mod:GetEntityData(npc).earth:Kill()
		 mod:GetEntityData(npc).venus:Kill()
		 mod:GetEntityData(npc).neptune:Kill()
		 mod:GetEntityData(npc).spawnCard = true
			return true
	  elseif etype == mod.FFID.Boss and evar >= mod.FF.OrgChaser.Var and evar <= mod.FF.OrgPokey.Var then -- Organization
			if evar == mod.FF.OrgChaser.Var and esubtype == mod.FF.OrgPokeyCorpse.Sub then
			 mod:GetEntityData(npc).Chaser:Kill()
			elseif evar ~= mod.FF.OrgChaser.Var and esubtype ~= mod.FF.OrgPokeyCorpse.Sub then
			 npc:GetSprite().FlipX = false
			 npc:GetSprite():Play("CorpseDeath", true)
			 mod:GetEntityData(npc).State = "Death"
			else
			 npc:Kill()
			end
			return true
	  elseif etype == mod.FF.SunSpike.ID and evar == mod.FF.SunSpike.Var then -- The Sun Spikes
			return true
	  elseif etype == mod.FF.Meltdown.ID and evar == mod.FF.Meltdown.Var then -- Meltdown first phase
			npc:ToNPC():Morph(mod.FF.Meltdown2.ID, mod.FF.Meltdown2.Var, 0, -1)
			npc:Kill()
			return true
	  elseif etype == mod.FF.Whispers.ID and evar == mod.FF.Whispers.Var then
			npc.Parent:Kill()
			return true
	  end
	 end

	 if tear:HasTearFlags(TearFlags.TEAR_HORN) or tear:HasTearFlags(TearFlags.TEAR_NEEDLE) then
		if etype == mod.FF.SunBody.ID and evar == mod.FF.SunBody.Var then
			return false
		end
	 end


 end
 -- Death Failsafe END --

	--Moved this here so the failsafe runs first, makes more sense I think
	mod:fiendTearCollision(tear, collider)
	if etype == mod.FF.Luncheon.ID and evar == mod.FF.Luncheon.Var then
		if not mod:GetEntityData(tear).LuncheonReflected then
			tear.Velocity = (tear.Velocity * -1):Rotated(-20 + math.random(40))
			mod:GetEntityData(tear).LuncheonReflected = true
			sfx:Play(mod.Sounds.Ricochet,1,0,false,0.7)
			return false
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, mod.OnTearColl)

function mod:OnBombColl(bomb, npc, mysteryBool)
local etype = npc.Type
local evar = npc.Variant
	if etype == mod.FF.SunSpike.ID and evar == mod.FF.SunSpike.Var and mod:GetEntityData(bomb).sun and bomb.FrameCount < 10 then
		return false
	end
end

mod:AddCallback(ModCallbacks.MC_PRE_BOMB_COLLISION , mod.OnBombColl)


--RUN AI
function mod:checkGaper(npc)
	if npc.SubType == 0 and npc.Variant <= 1 then
		mod:SurpriseDeathAnimGaper(npc)
	end
	if npc.SubType == 960 then
		npc:GetSprite():SetOverlayFrame("Head", 19)
		npc.SubType = 0
	elseif npc.Variant == 161 then
		mod:psychicGaperAI(npc)
	elseif npc.Variant == 162 then
		mod:wallGaperAI(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkGaper, 10)

function mod:checkDip(npc)
	if npc.SubType == 970 then
		npc.State = 5
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkDip, EntityType.ENTITY_DIP)

local fireboneSpawns = {
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
	2,2,2,2,2,2,2,2,
	3,3,3,3,
	4,4,
	5,
}

--GlobalEntityUpdate, GlobalEnemy, GlobalUpdate, GlobalNPC
function mod:checkAllEnemy(npc)
	local d = mod:GetEntityData(npc)
	local level = game:GetLevel()

	mod:ferriumGenericNPCUpdate(npc, d)
    mod:dropFractionalsIfMortal(npc, d)
	mod:runSwineSpawnCoinCheck(npc, d, level)
	mod:HandleWantedPosterTarget(npc, d)
	mod:HandleBabyBottle(npc, d)

	if mod.spookInRoom then
		if npc:IsEnemy() and npc:IsDead() then
			mod.spookJustKilledEnemy = 1
		end
	end
	if npc:IsEnemy() then
		--Grotto beast sparkle
		if npc.SpawnerEntity and npc.SpawnerEntity.Type == 1 then
			if d.sparklyGrottoBeast then
				if npc.FrameCount % 3 == 0 then
					local randvec = Vector(-15 + math.random(20), -15 + math.random(20))
					local sparkle = Isaac.Spawn(1000, 7003, 0, npc.Position, randvec * 0.1, npc):ToEffect()
					sparkle.RenderZOffset = -5
					sparkle.SpriteOffset = randvec + Vector(0, -20)
					--sparkle.SpriteScale = Vector(0.3,0.3)
				end
			end
		end
		--Fiend effects
		if mod.FiendDoingFireballs then
			if d.spawnFiendishBlackHeart then
				d.spawnFiendishBlackHeart = nil
				if npc:HasMortalDamage() and not npc:HasEntityFlags(EntityFlag.FLAG_NO_REWARD) then
					if d.SpawnedAtRoomStart then
						if npc:GetDropRNG():RandomInt(2) < 1 then
							local heart = Isaac.Spawn(5, mod.PICKUP.VARIANT.HALF_IMMORAL_HEART, 0, npc.Position, RandomVector():Resized(math.random(1,20)/10), Isaac.GetPlayer()):ToPickup()
							heart.Timeout = 60
							heart:Update()
						end
					else
						if mod.fiendImmoralSpawnOnSpawnedChance and mod.fiendImmoralSpawnOnSpawnedChance > 0 then
							if npc:GetDropRNG():RandomInt(4) < mod.fiendImmoralSpawnOnSpawnedChance then
								local heart = Isaac.Spawn(5, mod.PICKUP.VARIANT.HALF_IMMORAL_HEART, 0, npc.Position, RandomVector():Resized(math.random(1,20)/10), Isaac.GetPlayer()):ToPickup()
								heart.Timeout = 60
								heart:Update()
								mod.fiendImmoralSpawnOnSpawnedChance = mod.fiendImmoralSpawnOnSpawnedChance / 2
								--mod.fiendImmoralSpawnOnSpawnedChance = math.floor(mod.fiendImmoralSpawnOnSpawnedChance)
							end
						end
					end
				end
			end
			if d.spawnSkeletalFiendFirebone then
				d.spawnSkeletalFiendFirebone = nil
				if npc:HasMortalDamage() and not npc:HasEntityFlags(EntityFlag.FLAG_NO_REWARD) then
					local nearestPlayer = mod.FindClosestEntity(npc.Position, 1) or Isaac.GetPlayer()
					local max = fireboneSpawns[math.random(#fireboneSpawns)]
					local startAng = math.random(360)
					for i = 1, max do
						local spood = Isaac.Spawn(3, 128, 0, npc.Position, Vector(5, 0):Rotated(startAng + ((360 / max) * i)), nearestPlayer)
						spood.Parent = nearestPlayer
						spood.Color = FiendFolio.ColorSkeletalFiend
						spood.SplatColor = FiendFolio.ColorSkeletalFiend
						spood:Update()
					end
				end
			end
			if d.spawnFiendFireball then
				--[[if npc:HasMortalDamage() and not npc:HasEntityFlags(EntityFlag.FLAG_NO_REWARD) then
					local player = d.spawnFiendFireball
					local data = mod:GetEntityData(player).ffsavedata
					data.orbitingfireballs = math.min(data.orbitingfireballs + 1, 3)
					player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
					player:EvaluateItems()
				end]]--
				local player = d.spawnFiendFireball
				local data = mod:GetEntityData(player).ffsavedata
				local cap = 40 + 10 * math.max(game:GetLevel():GetStage(), 1)
				if data.fiendDamageDealt and data.fiendDamageDealt >= cap then
					data.fiendDamageDealt = 0

					local fiendflasheffect = Isaac.Spawn(1000, 668, 0, player.Position, Vector(0,0), player):ToEffect()
					mod:GetEntityData(fiendflasheffect).parent = player
					sfx:Play(SoundEffect.SOUND_FLAME_BURST, 0.3, 0, false, math.random(150,160)/100)

					local fireballCap = 3 + (player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.PYROMANCY) * 3) + player:GetTrinketMultiplier(mod.ITEM.TRINKET.IMP_FINGER)
					data.orbitingfireballs = math.min(data.orbitingfireballs + 1, fireballCap)
					player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS, true)
				end
				d.spawnFiendFireball = nil
			end
		end
		mod:erflyGlobalNPCUpdate(npc, d)
		if d.tookChaldeanAxeDamageRecently then
			d.tookChaldeanAxeDamageRecently = d.tookChaldeanAxeDamageRecently - 1
			if d.tookChaldeanAxeDamageRecently <= 0 then
				d.tookChaldeanAxeDamageRecently = nil
			end
		end
		if d.DevilsDaggerBurn then
			if not npc:HasEntityFlags(EntityFlag.FLAG_BURN) then
				d.DevilsDaggerBurn = nil
			end
			if npc:IsDead() then
				local fire = Isaac.Spawn(1000, 51, 960, npc.Position, nilvector, Isaac.GetPlayer())
				mod:GetEntityData(fire).timer = 30
				fire:Update()
			end
		end
	end

	mod:connorEnemyUpdate(npc, d)
	mod:UpdateFoolsGoldFreeze(npc, d)
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkAllEnemy)

local downloadFailureBlacklist = {
	[EntityType.ENTITY_MOTHER] = true,
	[EntityType.ENTITY_DARK_ESAU] = true,
	[EntityType.ENTITY_MOTHERS_SHADOW] = true,
}
mod.DownloadFailureBlacklist = downloadFailureBlacklist

function mod:preNPCUpdateAllEnemy(npc)
	local d = mod:GetEntityData(npc)
	local ret

	ret = mod:preUpdateBasicDeath(npc, d)
	if ret ~= nil then return ret end
	ret = mod:oldShellResetDamageMult(npc, d)
	if ret ~= nil then return ret end

	if (mod.downloadFailureCarded or d.DownloadFailuredManually) and not npc.Parent and not npc.Child and not downloadFailureBlacklist[npc.Type] and not (not npc:IsVulnerableEnemy() and npc.CanShutDoors) then
		if d.DownloadFailuredManually then
			local square = Isaac.Spawn(mod.FF.WhiteSquareEffect.ID, mod.FF.WhiteSquareEffect.Var, mod.FF.WhiteSquareEffect.Sub, npc.Position, nilvector, npc)
			square:Update()
		end
		if d.downloadFailureCarded then
			npc:SetColor(Color(1.5,1.5,1.5,0.3,50 / 255,50 / 255,50 / 255),15,1,true,false)
			if npc.FrameCount % 30 == 1 then
				npc:TakeDamage(2, 0, EntityRef(npc), 0)
			end
			if math.random(d.downloadFailureCarded) == 1 then
				d.downloadFailureCarded = nil
				d.poopleAI = nil
			else
				d.downloadFailureCarded = d.downloadFailureCarded - 1
			end
			if d.poopleAI then
				mod:poopleAI(npc)
			end
			return true
		else
			if math.random(50) == 1 then
				d.downloadFailureCarded = math.random(100)
				if math.random(5) == 1 then
					d.poopleAI = true
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.preNPCUpdateAllEnemy)

function mod:renderAllEnemy(npc, offset)
	local data = mod:GetEntityData(npc)

	--mod:ferriumGenericNPCRender(npc, data)
	--mod:guwahGenericNPCRender(npc, offset, data)
	mod:RenderFesteringFlies(npc, offset, data)
	mod:finishManualMinecartRendering(npc, offset, data)
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.renderAllEnemy)

function mod:preRenderAllEnemy(npc, offset)
	local data = mod:GetEntityData(npc)
end
--mod:AddCallback(ModCallbacks.MC_PRE_NPC_RENDER, mod.preRenderAllEnemy)

function mod:checkPacer(npc)
	local d = mod:GetEntityData(npc)
	if not d.replacecheck then
		local subt = npc.SubType
		local sprite = npc:GetSprite()
			if subt == 770 then
				sprite:ReplaceSpritesheet(0, "gfx/enemies/mrhorf/monsterbody.png")
				sprite:LoadGraphics()
			elseif subt == 772 then
				sprite:ReplaceSpritesheet(0, "gfx/enemies/mrhorf/monsterbodyred.png")
				sprite:LoadGraphics()
			elseif subt == 830 then
				mod:ReplaceEnemySpritesheet(npc, "gfx/enemies/pester/bodyblood", 0)
			end
		--Isaac.ConsoleOutput("a")
		d.replacecheck = true
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkPacer, 11)

--Run nerve ending AI
function mod:checkNerveEnding(npc)
	if npc.SubType == 960 then
		npc.HitPoints = 500
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkNerveEnding, 231)

--Run Pooter AI
function mod:checkPooter(npc)
	local var = npc.Variant
	local data = mod:GetEntityData(npc)
	local subt = npc.SubType

	if not data.PooterAppeared then
		if mod:CheckStage("Corpse", {34,43,44}) then
			if var == 1 and subt == 0 then
				npc:ReplaceSpritesheet(0, mod:spritesheetCheckLJReplacement("gfx/monsters/classic/monster_007_superpooter_corpse.png"), true)
			elseif var == 0 and subt == 0 then
				npc:ReplaceSpritesheet(0, mod:spritesheetCheckLJReplacement("gfx/monsters/classic/monster_001_pooter_corpse.png"), true)
			end
		end
		data.PooterAppeared = true
	end

end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkPooter, 14)

--Run Hungrygan AI
function mod:checkHungrygan(npc)
	if npc.Variant == mod.FF.Facade.Var then
		mod:hungryganAI(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkHungrygan, 16)

--Run Shopkeeper AI
function mod:checkShopkeeper(npc)
	if npc.Variant == mod.FF.FFShopkeeper.Var then
		mod:ffShopkeeperAI(npc)
	end
	local d = mod:GetEntityData(npc)
	if d.inMinecart and d.inMinecart:Exists() then
		npc.TargetPosition = d.inMinecart.Position
	end

	--[[
	--This is a joke
	if mod.DoVanillaItemTweaks then
		for _, foundPlayer in pairs(Isaac.FindInRadius(npc.Position, npc.Size, EntityPartition.PLAYER)) do
			local p = foundPlayer:ToPlayer()
			if p:HasCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
				npc:TakeDamage(10, DamageFlag.DAMAGE_FIRE, EntityRef(p), 20)
			end
		end
	end
	]]
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkShopkeeper, 17)

--Run Fly AI
function mod:checkFly(npc)
	--Drowned attack fly ehehehehehehehehehehehehehehe
	if npc.Variant == mod.FF.DrownedAttackFly.Var then
		local blue = Color(1,1,1,1,0,0,0)
		blue:SetColorize(1, 1, 3, 1)
		npc:GetSprite().Color = blue
		if npc:IsDead() then
			local maggot = Isaac.Spawn(23, 1, 0, npc.Position, Vector(0,0), npc)
			local params = ProjectileParams()
			for i = 45, 405, 90 do
				npc:FireProjectiles(npc.Position, Vector(8,0):Rotated(i), 0, params)
			end
		end
	end

	--Isaac.ConsoleOutput(npc.GridCollisionClass)
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkFly, 18)

--Run Maggot
function mod:checkMaggot(npc)
	local sprite = npc:GetSprite();
	local npcdata = mod:GetEntityData(npc);
	local var = npc.Variant
	if var == mod.FF.RolyPoly.Var then
		mod:rolyPolyAI(npc, npc.SubType)
	elseif var == mod.FF.Nimbus.Var then
		mod:nimbusai(npc, sprite, npcdata)
	elseif var == mod.FF.PsiKnight.Var then
		mod:psionicKnightAI(npc, sprite, npcdata)
	elseif var == mod.FF.SeaCucumber.Var then
		mod:seaCucumberAI(npc, sprite, npcdata)
	elseif var == mod.FF.Alfil.Var then
		mod:alfilAI(npc, sprite, npcdata)
	elseif var == mod.FF.Stiffany.Var then
		mod:stiffanyAI(npc, sprite, npcdata)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkMaggot, 21)


function mod:checkMaggotCollision(npc1, npc2, low)
end
--mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, mod.checkMaggotCollision, 21)

function mod:checkMaggotDeath(npc)
	local var = npc.Variant
	if var == mod.FF.RolyPoly.Var then
		sfx:Stop(mod.Sounds.RolyPolyRoll)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.checkMaggotDeath, 21)

function mod:checkMaggotKill(npc)
end
--mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.checkMaggotKill, 21)

function mod:checkMaggotHurt(npc, damage, flag, source)
	if npc.Variant == mod.FF.SeaCucumber.Var then
		local data = mod:GetEntityData(npc)
		local sprite = npc:GetSprite()
		if not data.anim then
			if sprite:IsPlaying("Move Hori") then
				data.anim = "ShootHori"
				data.offset = 1.6
			elseif sprite:IsPlaying("Move Down") then
				data.anim = "ShootDown"
				data.offset = 0.3
			elseif sprite:IsPlaying("Move Up") then
				data.anim = "ShootUp"
				data.offset = 1.1
			end

			if data.anim then
				sprite:SetFrame(data.anim, 0)
			end
		end
	elseif npc.Variant == mod.FF.Alfil.Var then
		return mod:alfilHurt(npc, damage, flag, source)
	elseif npc.Variant == mod.FF.Stiffany.Var then
		return mod:stiffanyHurt(npc, damage, flag, source)
	elseif npc.Variant == mod.FF.PsiKnight.Var then
		if mod:KnightDamageBlocking(npc, source, mod:GetEntityData(npc).faceAngle) then
			return false
		end
	end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.checkMaggotHurt, 21)

--Stop replacing cisterns with drowned friggin hives
function mod:hiveinit(npc)
	local sprite = npc:GetSprite();
	local npcdata = mod:GetEntityData(npc);
	if npc.Variant == mod.FF.Cistern.Var then
		npcdata.fuckoff = true
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.hiveinit, 22)

--Run Charger AI
function mod:checkCharger(npc)
	if npc.Variant == mod.FF.Sternum.Var or npc.Variant == mod.FF.Splodum.Var then
		mod:rocketChargerAI(npc, npc.Variant)
	elseif npc.Variant == mod.FF.ReheatedCharger.Var then
		mod:reheatedChargerAI(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkCharger, 23)

--Run Boom Fly AI
function mod:checkBoom(npc)
	if npc.Variant == mod.FF.DoomFly.Var then
		mod:doomFlyAI(npc)
	elseif npc.Variant == mod.FF.GBF.Var then
		mod:gbfAI(npc)
	elseif npc.Variant == mod.FF.Warhead.Var then
		mod:warheadAI(npc)
	elseif npc.Variant == mod.FF.Drainer.Var then
		mod:drainerAI(npc)
	elseif npc.Variant == mod.FF.PsychoFly.Var then
		mod:psychoFlyAI(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkBoom, 25)

--Run Maw AI
function mod:checkMaw(npc)
	if npc.SpawnerType == 216 and not mod:GetEntityData(npc).SwingerMaw then
		local sprite = npc:GetSprite()
		sprite:Load("gfx/enemies/swinger head/swinger_head.anm2",true)
		sprite:Play("Appear",true)
		mod:lastJudgementAutoResprite(npc, mod:GetEntityData(npc), sprite)
		mod:GetEntityData(npc).SwingerMaw = true
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkMaw, 26)

--Run Host AI
function mod:checkHost(npc)
	if npc.SubType == mod.FF.ReheatedHost1.Sub then
		mod:reheatedHost1AI(npc)
	elseif npc.SubType == mod.FF.ReheatedHost2.Sub then
		mod:reheatedHost2AI(npc)
	elseif npc.SubType == mod.FF.ReheatedHost3.Sub then
		mod:reheatedHost3AI(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkHost, 27)

--Run Hopper AI
function mod:checkHopper(npc)
	local var = npc.Variant
	local subT = npc.SubType
	if var == mod.FF.Tot.Var then
		mod:totAI(npc)
	elseif var ==  mod.FF.Spinneretch.Var then
		mod:spinneretchAI(npc)
	elseif var == mod.FF.SourpatchHead.Var then
		mod:sourpatchHeadAI(npc, npc.SubType)
	elseif var ==  mod.FF.Bombmuncher.Var and subT ==  mod.FF.Bombmuncher.Sub then
		mod:bombmuncherAI(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkHopper, 29)

--Run Boil AI
function mod:checkBoil(npc)
	if npc.Variant == mod.FF.StickySack.Var then
		mod:stickySackAI(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkBoil, 30)

--Run Boil AI
function mod:checkWalkingBoil(npc)
	if npc.Variant == mod.FF.WalkingStickySack.Var or npc.Variant == mod.FF.StumblingStickySack.Var then
		mod:walkingStickySackAI(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkWalkingBoil, 88)

--Run Boil AI
function mod:checkFire(npc)
	if npc.Variant == 10 then
		for key, value in ipairs(npc) do
			--print(key, value)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkFire, 33)

--Run Knight AI
--[[function mod:checkKnight(npc)
	local data = mod:GetEntityData(npc)
	if npc.Variant == 4 and mod.isBackdrop("Mines") then
		if not data.BlackKnightAppeared then
			npc:ReplaceSpritesheet(0, "gfx/monsters/repentance/041.012_blackknight_body_mines.png", true)
			npc:ReplaceSpritesheet(1, "gfx/monsters/repentance/041.012_blackknight_mines.png", true)
			npc.SplatColor = mod.ColorFireyFade
			data.BlackKnightAppeared = true
		end
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkKnight, 41)

function mod:checkBlackKnightFireJetWave(effect)
	local data = mod:GetEntityData(effect)
	if effect.SubType == 0 and effect.SpawnerType == 41 and effect.SpawnerVariant == 4 and mod.isBackdrop("Mines") then
		if not data.BlackKnight_FireJetWave_Appeared then
			effect.Color = mod.ColorNormal
			data.BlackKnight_FireJetWave_Appeared = true
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.checkBlackKnightFireJetWave, 147)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.checkBlackKnightFireJetWave, 148)]]

--Run Grimace AI
function mod:checkGrimace(npc)
	local variant = npc.Variant
	if variant > 959 and variant < 970 then
		local sprite = npc:GetSprite();
		local npcdata = mod:GetEntityData(npc);
		npc.Visible = true
		if variant == mod.FF.Wetstone.Var then
			mod:wetstoneai(npc, sprite, npcdata)
		elseif variant == mod.FF.Cauldron.Var then
			mod:cursedGrimaceAI(npc)
		--[[elseif variant == 7709 or variant == 7710 then
			mod:spawnCongression(npc, variant, npc.SubType)]]
		elseif variant == mod.FF.SensoryGrimace.Var then
			mod:sensoryGrimaceAI(npc, sprite, npcdata)
		elseif variant == mod.FF.Casted.Var then
			mod:castedAI(npc, sprite, npcdata)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE , mod.checkGrimace, 42)

function mod:checkGrimaceHurt(npc, damage, flag, source, count)
	local variant = npc.Variant
	if variant > 959 and variant < 970 then
		local sprite = npc:GetSprite()
		local npcdata = mod:GetEntityData(npc)
		if variant == mod.FF.Casted.Var then
			mod:castedHurt(npc, npcdata, source)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.checkGrimaceHurt, 42)

--Run Poky AI
function mod:checkPoky(npc)
local variant = npc.Variant
	if variant == mod.FF.ArteryM.Var or variant == mod.FF.ArteryS.Var then
		mod:arteryAI(npc, variant)
	elseif variant == mod.FF.Vein.Var then
		mod:veinAI(npc)
	elseif variant == mod.FF.Graterhole.Var then
		mod:grateholeAI(npc)
	elseif variant >= mod.FF.PipeSeptic.Var and variant <= mod.FF.PipeSplit.Var then
		mod:pipeAI(npc, variant, npc.SubType)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE , mod.checkPoky, 44)

--Run Mom AI
function mod:checkMom(npc)
	local subt = npc.SubType
	if subt == mod.FF.FiendMom.Sub then
		mod:momFFChampionAI(npc, npc.Variant)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkMom, 45)
--adding compat to hmmbp maybe?
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkMom, 396)

function mod:mominit(npc)
	if npc.SubType == 3 then --Replace Maus Mom on main path with Fiend Mom
		local stagetype = game:GetLevel():GetStageType()
		if not (stagetype == StageType.STAGETYPE_REPENTANCE or stagetype == StageType.STAGETYPE_REPENTANCE_B) then
			npc:Morph(npc.Type, npc.Variant, mod.FF.FiendMom.Sub, -1)
			npc.MaxHitPoints = npc.MaxHitPoints * 0.75
			npc.HitPoints = npc.MaxHitPoints
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.mominit, 45)

function mod:momhurt(npc, amount, damageFlags, source)
	if npc.SubType == mod.FF.FiendMom.Sub then
		return mod:IgnoreFireDamage(npc, amount, damageFlags, source)
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.momhurt, 45)

mod.overwriteDopleCrawlspace = true

function mod:preDople(npc)
	if mod.overwriteDopleCrawlspace then
		local room = Game():GetRoom()
		local sprite = npc:GetSprite()
		if room:GetBackdropType() == 29 then
			if npc.FrameCount <= 1 then
				npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			end
			local target = npc:GetPlayerTarget()
			local targetpos = target.Position
			local centre = room:GetCenterPos()
			local targetVec = targetpos - centre
			npc.TargetPosition = centre + Vector(targetVec.X * -1, targetVec.Y)
			local ts = target:GetSprite()
			--local tsA, tsOA = ts:GetAnimation(), ts:GetOverlayAnimation()
			if tsA and tsOA then
				sprite:SetFrame(tsA, ts:GetFrame())
				sprite:SetOverlayFrame(tsOA, ts:GetOverlayFrame())
			else
				 if npc.TargetPosition:Distance(npc.Position) > 1 then
					local vec = npc.TargetPosition - npc.Position

					if math.abs(vec.X) > math.abs(vec.Y) then
						sprite:SetOverlayFrame("HeadHori", 0)
						mod:spritePlay(sprite, "WalkHori")
						if vec.X > 0 then
							sprite.FlipX = false
						else
							sprite.FlipX = true
						end
					else
						mod:spritePlay(sprite, "WalkVert")
						if vec.Y > 0 then
							sprite:SetOverlayFrame("HeadDown", 0)
						else
							sprite:SetOverlayFrame("HeadUp", 0)
						end
					end
				else
					npc.Velocity = nilvector
					sprite:SetFrame("WalkVert", 0)
					sprite:SetOverlayFrame("HeadDown", 0)
				end
			end
			npc.Position = centre + Vector(targetVec.X * -1, targetVec.Y)
			npc.Velocity = nilvector
			return true
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.preDople, 53)

function mod:checkDople(npc)
	if not mod.overwriteDopleCrawlspace then
		local room = Game():GetRoom()
		if room:GetBackdropType() == 29 then
			local target = npc:GetPlayerTarget()
			local targetpos = target.Position
			local centre = room:GetCenterPos()
			local targetVec = targetpos - centre
			npc.TargetPosition = centre + Vector(targetVec.X * -1, targetVec.Y)
			npc.Position = centre + Vector(targetVec.X * -1, targetVec.Y)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkDople, 53)

function mod:checkParabite(npc)
	local data = mod:GetEntityData(npc)
	if not data.ParabiteInit then
		if npc.Variant == 0 then
			if mod.roomBackdrop == 10 or (npc.SpawnerType == mod.FF.Nematode.ID and npc.SpawnerVariant == mod.FF.Nematode.Var) then
				local spriteSheet = "gfx/monsters/classic/monster_199_parabite_morbus"
				if LastJudgementSprites then
					spriteSheet = "gfx/monsters/classic/monster_199_parabite_lj_morbus"
				end
				mod:ReplaceEnemySpritesheet(npc, spriteSheet, 0)
				mod:ReplaceEnemySpritesheet(npc, spriteSheet, 1)
			end
		end
		data.ParabiteInit = true
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE , mod.checkParabite, 58)

function mod:parabiteCollide(npc, npc2, mysteryBoolean)
	if npc.Variant == mod.FF.HungryParabite.Var then
		if npc2.Type == 1 then
			local roundy = Isaac.Spawn(276, 0, 0, npc.Position, nilvector, npc):ToNPC()
			npc:PlaySound(SoundEffect.SOUND_VAMP_GULP,1,0,false,0.8)
			roundy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			npc:Remove()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION , mod.parabiteCollide, 58)

--Run Sucker AI
function mod:checkSucker(npc)
	local variant = npc.Variant
	if variant == mod.FF.Spitroast.Var or variant == mod.FF.Spitfire.Var then
		mod:spitroastAI(npc)
	elseif variant == mod.FF.ShineSpit.Var then
		mod:shineSpitAI(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE , mod.checkSucker, 61)

function mod:checksuckerhurt(npc, damage, flag, source)
	local variant = npc.Variant
	if variant == mod.FF.Spitroast.Var or variant == mod.FF.Spitfire.Var then
		if flag & DamageFlag.DAMAGE_FIRE ~= 0 then
			if source.Type ~= 1 then
				return false
			else
				npc:TakeDamage(damage * 2, flag & DamageFlag.DAMAGE_CLONES, EntityRef(target), 0)
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.checksuckerhurt, 61)

--Run Spooter AI
function mod:checkSpooter(npc)
	if mod.FlickerspiritInRoom then
		if mod:GetEntityData(npc).flickerspirited then
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
		end
	end
	local var = npc.Variant
	if var == mod.FF.Spooter.Var or var == mod.FF.SuperSpooter.Var or var == mod.FF.MegaSpooter.Var or var == mod.FF.LitterBug.Var or var == mod.FF.LitterBugToxic.Var or var == mod.FF.LitterBugCharmed.Var or var == mod.FF.LitterBugBruising.Var then
		mod:spooterAI(npc, var)
	elseif var == mod.FF.BabySpider.Var then
		mod:babySpiderAI(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkSpooter, 85)

--Run Gurgle AI
function mod:checkGurgle(npc)
	if npc.Variant == mod.FF.ReheatedGurgle.Var then
		mod:reheatedGurgleAI(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkGurgle, 87)

--Run Big Spider AI
function mod:checkBigSpider(npc)
	if mod.FlickerspiritInRoom then
		if mod:GetEntityData(npc).flickerspirited then
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
		end
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkBigSpider, 94)

--Run Gutbuster AI
function mod:checkLongLegs(npc)
	local var = npc.Variant
	if var == mod.FF.Gutbuster.Var or var == mod.FF.KrassBlaster.Var then
		mod:drownedLongLegsAI(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkLongLegs, 207)

--Run Fatty AI
function mod:checkFatty(npc)
	local sprite = npc:GetSprite();
	local npcdata = mod:GetEntityData(npc);
	if npc.Variant == mod.FF.DankFatty.Var then
		mod:dankFattyAI(npc, sprite)
	elseif npc.Variant == mod.FF.Tubby.Var then
		mod:wehai(npc, sprite, npcdata)
	elseif npc.Variant == mod.FF.Mouthful.Var then
		mod:morselMommyAI(npc, sprite)
	elseif npc.Variant == mod.FF.BigSmoke.Var then
		mod:bigSmokeAI(npc, sprite)
	elseif npc.Variant == 0 then
		mod:SurpriseDeathAnimFatty(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkFatty, 208)

--Run Lvl2 Spider AI
function mod:checkLvl2Fly(npc)
	local var = npc.Variant
	if var == mod.FF.ReheatedIckyFly.Var then
		mod:reheatedIckyAI(npc)
	elseif var == mod.FF.ReheatedBobbyFly.Var then
		mod:reheatedTickingAI(npc)
	elseif var == mod.FF.ReheatedFly.Var then
		mod:reheatedFlyAI(npc)
	elseif var == mod.FF.ReheatedSackyFly.Var then
	mod:reheatedsSpiderSackAI(npc)
	elseif var == mod.FF.ReheatedChompyFly.Var then
	mod:reheatedFlyScarsAI(npc)
	elseif var == mod.FF.ReheatedTickingFly.Var then
	mod:nonCanonReheatedFlyTickingRealsAI(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkLvl2Fly, 214)

--Run Lvl2 Spider AI
function mod:checkLvl2Spider(npc)
	if mod.FlickerspiritInRoom then
		if mod:GetEntityData(npc).flickerspirited then
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
		end
	end
	local var = npc.Variant

	if var == 0 and mod:GetEntityData(npc).IsSpoilie then
		mod.spoiliespiderAI(npc)
	end

	if var == mod.FF.FullSpider.Var then
		mod:reheatedSpiderFullAI(npc)
	elseif var == mod.FF.ReheatedBobbySpider.Var then
		mod:reheatedTickingAI(npc)
	elseif var == mod.FF.ReheatedSpider.Var then
		mod:reheatedSpiderAI(npc)
	elseif var == mod.FF.ReheatedSackySpider.Var then
		mod:reheatedsSpiderSackAI(npc)
	elseif var == mod.FF.ReheatedIckySpider.Var then
		mod:reheatedIckyAI(npc)
	elseif var == mod.FF.ReheatedChompySpider.Var then
		mod:reheatedSpiderScarsAI(npc)
	elseif var == mod.FF.SoulSpooter.Var then
		mod:soulSpooterAI(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkLvl2Spider, 215)

--Black Maw funneee
function mod:checkBlackMaw(npc)
	if npc.Variant == mod.FF.BlackMawHapyHed.Var then
		if npc.SubType == 0 then
			local sprite = npc:GetSprite()
			mod:ReplaceEnemySpritesheet(npc, "gfx/enemies/blackmaw/monster_224_blackmaw", 0)
			sprite:LoadGraphics()
			npc.SubType = 1
		end
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE , mod.checkBlackMaw, 225)

--Globin funneee
function mod:checkGlobin(npc)
	local slunkAttack = RNG()
	slunkAttack:SetSeed(npc.InitSeed + 1)
	if npc.Variant == 1 and npc.SubType == 0 and npc.FrameCount <= 1 and slunkAttack:RandomFloat() <= 0.005 then
		local sprite = npc:GetSprite()
		mod:ReplaceEnemySpritesheet(npc, "gfx/enemies/glorf/nightmare", 1)
		sprite:LoadGraphics()
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE , mod.checkGlobin, EntityType.ENTITY_GLOBIN)

--Run Bony AI
function mod:checkBony(npc)
	local var = npc.Variant
	if var == mod.FF.HollowKnight.Var then
		mod:hollowKnightAI(npc)
	elseif var == mod.FF.Powderkeg.Var then
		mod:powderkegAI(npc)
	elseif var == mod.FF.Crepitus.Var then
		local sprite = npc:GetSprite();
		local npcdata = mod:GetEntityData(npc);
		mod:crepitusai(npc, sprite, npcdata)
	elseif var == mod.FF.MrBones.Var then
		local sprite = npc:GetSprite();
		local npcdata = mod:GetEntityData(npc);
		mod:mrbonesai(npc, sprite, npcdata)
	elseif var == mod.FF.Hazy.Var then
		mod:hazyAI(npc)
	elseif var == 0 then
		mod:lastJudgementAutoResprite(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE , mod.checkBony, 227)

function mod:checkBonyHurt(npc, damage, flag, source)
	if npc.Variant == mod.FF.Powderkeg.Var then
		if flag & DamageFlag.DAMAGE_FIRE ~= 0 then
			npc:Kill()
		end
	elseif npc.Variant == mod.FF.HollowKnight.Var then
		local data = mod:GetEntityData(npc)

		if flag == flag | DamageFlag.DAMAGE_POISON_BURN then -- Keep Poison/Burn synced to once per 40 frames
			data.FFLastPoisonProc = data.FFLastPoisonProc or 0
			if Isaac.GetFrameCount() - data.FFLastPoisonProc < 40 then
				return false
			end
			data.FFLastPoisonProc = Isaac.GetFrameCount()

			if flag ~= flag | DamageFlag.DAMAGE_CLONES then
				--if npc.Child then
				--	npc.Child:TakeDamage(damage, flag | DamageFlag.DAMAGE_CLONES, source, 0)
				--end
			end
		elseif flag ~= flag | DamageFlag.DAMAGE_CLONES and not data.FFTakingBleedDamage then -- Regular damage
			return false
		end
	end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.checkBonyHurt, 227)

function mod:checkBonyKill(npc)
	local var = npc.Variant
	if var == mod.FF.HollowKnight.Var then
		local data = mod:GetEntityData(npc)
		if data.brain and data.brain:Exists() then
			data.brain:Kill()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.checkBonyKill, 227)

function mod:checkBonyCollision(npc, entity, mysteryBool)
	local var = npc.Variant
	if var == mod.FF.HollowKnight.Var then
		local data = mod:GetEntityData(npc)
		if data.brain and entity.InitSeed == data.brain.InitSeed and entity.Index == data.brain.Index then
			return true
		end
	elseif var == mod.FF.MrBones.Var then
		local data = mod:GetEntityData(npc)
		if data.head and entity.InitSeed == data.head.InitSeed and entity.Index == data.head.Index then
			return true
		elseif data.parent and entity.InitSeed == data.parent.InitSeed and entity.Index == data.parent.Index then
			return true
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, mod.checkBonyCollision, 227)

--Run Bat AI
function mod:checkBat(npc)
	if npc.Variant == 0 then
		if npc.FrameCount == 5 then
			if npc.SubType == 7000 then
				npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			end
		end
	elseif npc.Variant == mod.FF.Jawbone.Var then
		mod:jawboneAI(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE , mod.checkBat, 234)

--Run Wall Creep AI
function mod:checkWallCreep(npc)
	local var = npc.Variant
	if var == mod.FF.Fried.Var then
		mod:friedAI(npc)
	elseif var == mod.FF.OgreCreep.Var then
		mod:ogreCreepAI(npc)
	elseif var == mod.FF.ReheatedIckyCreep.Var then
		mod:reheatedCreep1AI(npc)
	elseif var == mod.FF.ReheatedTechyCreep.Var then
		mod:reheatedCreep2AI(npc)
	elseif var == mod.FF.ScowlCreep.Var then
		mod:scowlCreepAI(npc)
	elseif var == mod.FF.ScopeCreep.Var then
		mod:scopeCreepAI(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE , mod.checkWallCreep, 240)

function mod:checkWallCreepHurt(npc, damage, flag, source)
	if npc.Variant == mod.FF.Fried.Var then
		if flag & DamageFlag.DAMAGE_FIRE ~= 0 and source.Type ~= 1 then
			return false
		end
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.checkWallCreepHurt, 240)

function mod:checkTickingSpider(npc)
	if mod.FlickerspiritInRoom then
		if mod:GetEntityData(npc).flickerspirited then
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
		end
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkTickingSpider, 250)

--[[function mod:checkBegotten(npc)
	--Ms. Dominator ones

	local d = mod:GetEntityData(npc)
	if npc.SubType == 960 and d.dominated then
		mod:dominatorBegottenAI(npc, d)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkBegotten, 251)]]

--Run Fat Bat AI
function mod:checkFatBat(npc)
	local var = npc.Variant
	if var == mod.FF.BubbleBat.Var then
		mod:drownedFatBatAI(npc)
	elseif var == mod.FF.Ribbone.Var then
		mod:ribboneAI(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkFatBat, 258)

--Run Black Globin AI
function mod:checkBlackGlobin(npc)
	local var = npc.Variant
	local data = mod:GetEntityData(npc)
	if var == 0 and mod:CheckStage("Corpse", {34,43,44}) then
		if not data.BlackGlobinAppeared then
			npc:ReplaceSpritesheet(0, "gfx/monsters/afterbirth/monster_005_bodies01_black_corpse.png", true)
			npc:ReplaceSpritesheet(1, mod:spritesheetCheckLJReplacement("gfx/monsters/afterbirth/278.000_blackglobin_corpse.png"), true)
			data.BlackGlobinAppeared = true
		end
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkBlackGlobin, 278)

--Run Black Globin's Head AI
function mod:checkBlackGlobinsHead(npc)
	local var = npc.Variant
	local data = mod:GetEntityData(npc)
	if var == 0 and mod:CheckStage("Corpse", {34,43,44}) then
		if not data.BlackGlobinsHeadAppeared then
			npc:ReplaceSpritesheet(0, mod:spritesheetCheckLJReplacement("gfx/monsters/afterbirth/279.000_blackglobinhead_corpse.png"), true)
			data.BlackGlobinsHeadAppeared = true
		end
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkBlackGlobinsHead, 279)

--Run Cyclopia AI
function mod:checkCyclopia(npc)
	local var = npc.Variant
	if var == mod.FF.ReheatedCyclopia.Var then
		mod:reheatedCyclopiaAI(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkCyclopia, 284)

function mod:checkStoney(npc)
	if not npc:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) then
		npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkStoney, 302)

function mod:checkGrudge(npc)
	if npc.Variant == mod.FF.Grievance.Var then
		mod:grievanceAI(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkGrudge, 877)

function mod:checkGrudgeCollision(npc, coll, bool)
	if npc.Variant == mod.FF.Grievance.Var then
		mod:grievanceColl(npc, coll, bool)
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, mod.checkGrudgeCollision, 877)

function mod:checkMinecart(npc)
	if npc.Child then
		mod:GetEntityData(npc.Child).inMinecart = npc
		if npc.Child.Type == 907 then
			npc.SpriteScale = Vector(10, 1)
		end
		--[[if npc.Child.Type == mod.FF.Centipede.ID and npc.Child.Variant == mod.FF.Centipede.Var then
			npc.Visible = false
		end]]
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkMinecart, 965)

--Mini - Run AI


mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	if eff.SubType == 960 then
		eff.Variant = 1230

		eff.SpriteScale = eff.SpriteScale * 2
		-- scale to 1 from current scale in timeout frames
		eff.Scale = 1 / (eff.SpriteScale.X ^ (1 / eff.Timeout))
		eff.Timeout = 6
		eff.Rotation = math.random(0, 360)

		local sprite = eff:GetSprite()
		sprite:Load('gfx/effects/effect_rockpoof.anm2', true)
		sprite:Play("Poof", true)
		sprite.PlaybackSpeed = 14 / eff.LifeSpan

		local data = mod:GetEntityData(eff)
		data.IsScaledEff = true
	end
end, EffectVariant.DUST_CLOUD)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	eff.Velocity = eff.Velocity * eff.Friction
	eff.Rotation = eff.Rotation + (eff.InitSeed % 40)
end, 1230)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	if eff.SubType == 960 then
		local d = mod:GetEntityData(eff)
		if d.shrink then
			eff.SpriteScale = eff.SpriteScale * d.shrink
			eff.Color = Color(eff.Color.R, eff.Color.G, eff.Color.B, eff.Color.A * d.shrink, eff.Color.RO, eff.Color.GO, eff.Color.BO)
		end
	end
end, EffectVariant.DARK_BALL_SMOKE_PARTICLE)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	if eff.SubType == 960 then
		local d = mod:GetEntityData(eff)
		if d.shrink then
			eff.SpriteScale = eff.SpriteScale * d.shrink
			eff.Color = Color(eff.Color.R, eff.Color.G, eff.Color.B, eff.Color.A * d.shrink, eff.Color.RO, eff.Color.GO, eff.Color.BO)
		end
	end
end, EffectVariant.DARK_BALL_SMOKE_PARTICLE)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	if eff.SubType == 960 then
		eff.Color = Color(eff.Color.R, eff.Color.G, eff.Color.B, eff.Color.A * 0.9, eff.Color.RO, eff.Color.GO, eff.Color.BO)
	end
end, EffectVariant.POOF02)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	local sprite = eff:GetSprite()
	if eff.FrameCount < 2 then
		if sprite:GetFilename() == "gfx/grid/grid_rock.anm2" then
			if game:GetRoom():GetBackdropType() == 31 then
				sprite:ReplaceSpritesheet(0, "gfx/grid/rocks_downpour_entrance.png")
				sprite:LoadGraphics()
			end
		end
	end
end, EffectVariant.GRID_ENTITY_PROJECTILE_HELPER)

--Run Worm AI
function mod:checkWorm(npc)
	local sprite = npc:GetSprite();
	local npcdata = mod:GetEntityData(npc);
	if npc.Variant == mod.FF.BoneWorm.Var then
		mod:bonewormai(npc, sprite, npcdata)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkWorm, 244)


function mod:checkDeliriumInit(npc)
	mod.IsDeliriumRoom = true
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.checkDeliriumInit, EntityType.ENTITY_DELIRIUM)

function mod:checkWormInit(npc)
	local sprite = npc:GetSprite();
	local npcdata = mod:GetEntityData(npc);
	local var = npc.Variant
		if var == Isaac.GetEntityVariantByName("Soft Serve") or var == Isaac.GetEntityVariantByName("Solid Serve") then
			if (npc.SubType == 1 or npc.SubType == 2) and npc:HasEntityFlags(EntityFlag.FLAG_APPEAR) then
				npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				sprite:Play("Appear" .. npc.SubType, true)
				npc:AddEntityFlags(EntityFlag.FLAG_APPEAR)
			end
		end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT , mod.checkWormInit, FiendFolio.FFID.Mini)

local spikerel = {
	Vector(-60, 0),
	Vector(60, 0),
	Vector(-30, 20),
	Vector(30, 20),
}

local sunAIs = {
	[50] = function(npc, sprite, data) -- The Sun
		local room = game:GetRoom()

		if not data.init then
			npc.CanShutDoors = false
			npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_DONT_COUNT_BOSS_HP)

			npc.Position = Vector(npc.Position.X, 200)

			FiendFolio.NPCBlockerGrid:Spawn(room:GetGridIndex(npc.Position), true, false, { Parent = npc })

			data.venus = Isaac.Spawn(npc.Type, 51, npc.SubType, npc.Position + Vector(0, 80):Rotated(-60), nilvector, npc)
			mod:GetEntityData(data.venus).sun = npc
			data.earth = Isaac.Spawn(npc.Type, 52, npc.SubType, npc.Position + Vector(0, 140):Rotated(60), nilvector, npc)
			mod:GetEntityData(data.earth).sun = npc
			data.neptune = Isaac.Spawn(npc.Type, 53, npc.SubType, npc.Position + Vector(0, 200):Rotated(-60), nilvector, npc)
			mod:GetEntityData(data.neptune).sun = npc

			data.orbitalpos = {
				venus = data.venus.Position - npc.Position,
				earth = data.earth.Position - npc.Position,
				neptune = data.neptune.Position - npc.Position,
			}

			data.orbitalspeed = {
				venus = 0.5,
				earth = -1,
				neptune = 1.2,
				neptuneInPractice = 1.2, -- used for gradual adjustments
			}

			data.spikes = {}
			for i = 1, 4 do
				data.spikes[i] = Isaac.Spawn(npc.Type, 55, npc.SubType, npc.Position + spikerel[i], nilvector, npc)
				mod:GetEntityData(data.spikes[i]).sun = npc
				if i % 2 == 0 then
					data.spikes[i]:GetSprite().FlipX = true
				end
			end

			sprite:Play("Idle")

			--[[for _, p in pairs(Isaac.FindByType(1, -1, -1)) do
				if p.Position.Y < npc.Position.Y or p.Position:Distance(npc.Position) - p.Size - npc.Size <= 0 then
					p.Position = npc.Position + Vector(0, 150)
				end
			end]]

			data.last = npc.FrameCount
			data.lastroll = 0

			data.init = true
		end

		npc.Velocity = nilvector

		if sprite:IsFinished("SpawnHollow") or sprite:IsFinished("SpitFire") or sprite:IsFinished("SpitBomb") then
			sprite:Play("Idle")
			data.last = npc.FrameCount
		end

		local canattack = data.venus.HitPoints + data.earth.HitPoints + data.neptune.HitPoints < (data.venus.MaxHitPoints + data.earth.MaxHitPoints + data.neptune.MaxHitPoints) * 9/10

		if sprite:IsPlaying("Idle") and canattack and ((data.last + 60 < npc.FrameCount and math.random(30) == 1) or data.last + 90 < npc.FrameCount) then
			local r = data.lastroll
			while r == data.lastroll do
				r = math.random(3)
			end
			--r = 1

			if r == 1 then
				sprite:Play("SpawnHollow")
				if (mod.GetEntityCount(40) + mod.GetEntityCount(227)) > 1 then
					if data.lastroll == 2 then
						sprite:Play("SpitBomb")
						r = 3
					else
						sprite:Play("SpitFire")
						r = 2
					end
				end
			elseif r == 2 then
				sprite:Play("SpitFire")
			elseif r == 3 then
				sprite:Play("SpitBomb")
			end

			data.lastroll = r
		end

		if sprite:IsPlaying("SpawnHollow") then
			if sprite:IsEventTriggered("Grunt") then
				npc:PlaySound(mod.Sounds.FlashSatanHurt,1,0,false,1.3)
			elseif sprite:IsEventTriggered("Pop") then
				npc:PlaySound(SoundEffect.SOUND_MEATY_DEATHS,1,0,false,0.7)
			end
		elseif sprite:IsPlaying("SpitFire") then
			if sprite:IsEventTriggered("Grunt") then
				npc:PlaySound(mod.Sounds.FlashSatanCharge,1,0,false,1.3)
			elseif sprite:IsEventTriggered("FireStart") then
				npc:PlaySound(mod.Sounds.FlashDevilCard,1,0,false,math.random(90,120)/100)
			end
		elseif sprite:IsPlaying("SpitBomb") then
			if sprite:IsEventTriggered("Grunt") then
				npc:PlaySound(mod.Sounds.FlashSatanSpit1,1,0,false,1.3)
			elseif sprite:IsEventTriggered("Grunt2") then
				npc:PlaySound(mod.Sounds.FlashSatanSpit1,1,0,false,1.6)
			elseif sprite:IsEventTriggered("Phew") then
				npc:PlaySound(mod.Sounds.FireLight,1,0,false,1.6)
			end
		end

		if sprite:IsEventTriggered("Shoot") then
			npc:PlaySound(mod.Sounds.FlashSatanSpit2,1,0,false,math.random(150,180)/100)
			local b = Isaac.Spawn(4, 8, 0, npc.Position, (npc:GetPlayerTarget().Position - npc.Position):Resized(13), npc):ToBomb()
			b:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			b.ExplosionDamage = 20
			b.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			b.Flags = TearFlags.TEAR_BURN
			mod:GetEntityData(b).sun = true
		end

		if sprite:WasEventTriggered("FireStart") and not sprite:WasEventTriggered("FireEnd") then
			local f = Isaac.Spawn(1000, 7005, 0, npc.Position - (npc:GetPlayerTarget().Position - npc.Position):Resized(15), (npc:GetPlayerTarget().Position - npc.Position):Resized(8):Rotated(math.random(-10, 10)), npc):ToEffect()
			f:SetColor(Color(1,1,1,1,-100 / 255,70 / 255,455 / 255),10,1,true,false)
			mod:GetEntityData(f).timer = 24
			mod:GetEntityData(f).flamethrower = true
			f:Update()
		end

		if sprite:IsEventTriggered("Summon") then
			npc:PlaySound(mod.Sounds.FlashSatanBlast,1,0,false,1.3)
			if (math.random(2) == 1) and not (mod.GetEntityCount(277) > mod.GetEntityCount(40)) then
				for i = -30, 30, 60 do -- Hollow Knights
					local e = Isaac.Spawn(mod.FF.RollingHollowKnight.ID, mod.FF.RollingHollowKnight.Var, 1, npc.Position + Vector(i, 15), Vector(i/15, 10):Resized(13), npc)
					e:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					local es = e:GetSprite()
					es:ReplaceSpritesheet(0, "gfx/enemies/hollowknight/hollow_knight_sun.png")
					es:ReplaceSpritesheet(1, "gfx/enemies/hollowknight/hollow_knight_sun.png")
					es:LoadGraphics()
					e.SpriteOffset = Vector(0, -14)
				end
			else
				for i = -30, 30, 60 do --Guts
					local e = Isaac.Spawn(40, 0, 4, npc.Position + Vector(i, 75), Vector(0, 10):Resized(13), npc)
					e:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					e.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
					--e.SpriteOffset = Vector(0, -14)
				end
			end
		end

		if npc.FrameCount > 24 then
			if not data.venus:IsDead() then
				local brainorbit = true
				if data.earth:IsDead() or data.neptune:IsDead() then
					brainorbit = false
					mod:GetEntityData(data.venus).enraged = true
				end
				if brainorbit then
					local oldpos = data.orbitalpos.venus
					data.orbitalpos.venus = data.orbitalpos.venus:Rotated(data.orbitalspeed.venus)
					local len = data.venus.Velocity:Length() + 0.1
					local maxlen = oldpos:Distance(data.orbitalpos.venus)

					data.venus.Velocity = ((npc.Position + data.orbitalpos.venus) - data.venus.Position):Resized(len) * 1.2
					if data.venus.Velocity:Length() > maxlen then
						data.venus.Velocity = data.venus.Velocity:Resized(maxlen)
					end
				else
					data.venus.Velocity = (npc:GetPlayerTarget().Position - data.venus.Position):Resized(2)
				end

			end
			if not data.earth:IsDead() then
				local oldpos = data.orbitalpos.earth
				data.orbitalpos.earth = data.orbitalpos.earth:Rotated(data.orbitalspeed.earth)
				if data.venus:IsDead() or data.neptune:IsDead() then
					mod:GetEntityData(data.earth).enraged = true
					local targdist = (npc:GetPlayerTarget().Position - npc.Position):Length()
					if targdist > data.orbitalpos.earth:Length() then
						data.orbitalpos.earth = data.orbitalpos.earth:Resized(data.orbitalpos.earth:Length() + 1)
					else
						data.orbitalpos.earth = data.orbitalpos.earth:Resized(data.orbitalpos.earth:Length() - 1)
					end
					if (npc:GetPlayerTarget().Position - data.earth.Position):Length() < 150 then
						local extra = (npc:GetPlayerTarget().Position - data.earth.Position):Length() / 300
						data.orbitalspeed.earth = mod:Lerp(data.orbitalspeed.earth, -1 + extra, 0.1)
					elseif not room:IsPositionInRoom(data.earth.Position, 0) then
						data.orbitalspeed.earth = mod:Lerp(data.orbitalspeed.earth, -2, 0.1)
					else
						data.orbitalspeed.earth = mod:Lerp(data.orbitalspeed.earth, -1, 0.1)
					end
				end
				local len = data.earth.Velocity:Length() + 0.1
				local maxlen = oldpos:Distance(data.orbitalpos.earth)

				data.earth.Velocity = ((npc.Position + data.orbitalpos.earth) - data.earth.Position):Resized(len) * 1.2
				if data.earth.Velocity:Length() > maxlen then
					data.earth.Velocity = data.earth.Velocity:Resized(maxlen)
				end
			end
			if not data.neptune:IsDead() then
				if (data.venus:IsDead() or data.earth:IsDead()) and not mod:GetEntityData(data.neptune).enraged then
					mod:GetEntityData(data.neptune).enraged = true
					data.orbitalspeed.neptune = 2
				end
				local oldpos = data.orbitalpos.neptune
				data.orbitalspeed.neptuneInPractice = mod:Lerp(data.orbitalspeed.neptuneInPractice, data.orbitalspeed.neptune, 0.2)
				data.orbitalpos.neptune = data.orbitalpos.neptune:Rotated(data.orbitalspeed.neptuneInPractice)
				local len = data.neptune.Velocity:Length() + 0.1
				local maxlen = oldpos:Distance(data.orbitalpos.neptune)

				data.neptune.Velocity = ((npc.Position + data.orbitalpos.neptune) - data.neptune.Position):Resized(len) * 1.2
				if data.neptune.Velocity:Length() > maxlen then
					data.neptune.Velocity = data.neptune.Velocity:Resized(maxlen)
				end
			end
		end

		if data.venus:IsDead() and data.earth:IsDead() and data.neptune:IsDead() and not data.dead then
			sprite:Play("Death")
			data.dead = true

			if mod.CanRunUnlockAchievements() and game:GetRoom():GetType() == RoomType.ROOM_BOSS then
				FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
				FiendFolio.savedata.killedBosses["TheSun"] = true
			end
		end

		if sprite:IsPlaying("Death") and sprite:IsEventTriggered("Grunt") then
			npc:PlaySound(mod.Sounds.FlashSatanBlast,1,0,false,0.8)
		end

		if sprite:IsEventTriggered("KillSpikes") then
			for _, s in pairs(data.spikes) do
				s:Kill()
			end

			if data.spawnCard then
				sprite:Play("Dead")
			end
		end

		if sprite:IsFinished("Death") then
			npc.CollisionDamage = 0
			sprite:Play("Dead")
		end

		if sprite:IsPlaying("Dead") and data.spawnCard then
			if game:GetRoom():GetType() == RoomType.ROOM_BOSS then
				Isaac.Spawn(5,100,mod.ITEM.COLLECTIBLE.PLANET_BADGE,npc.Position,nilvector,npc)
			end
			npc:BloodExplode()
			for i = 1, 20 do
				Isaac.Spawn(EntityType.ENTITY_EFFECT, 5, 0, npc.Position + RandomVector()*math.random(1,50), (RandomVector()*(math.random()+math.random(5,12))), npc);
			end
			npc:Remove()
		end
	end,
	[51] = function(npc, sprite, data) -- Venus (The Brain)
		if data.sun and data.sun:Exists() then
			if not data.init then
				npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
				npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE

				sprite:Play("Idle")
				sprite.Offset = Vector(0, -14)

				data.last = npc.FrameCount

				data.init = true
			end

			if sprite:IsFinished("SpawnBrain") then
				sprite:Play("Idle")
			end

			if sprite:IsPlaying("Idle") then
				if data.enraged then
					if (mod.GetEntityCount(32, 0, 0) < 3) and ((data.last + 120 < npc.FrameCount and math.random(17) == 1) or data.last + 150 < npc.FrameCount) then
						sprite:Play("SpawnBrain")
					end
				elseif (mod.GetEntityCount(32, 0, 0) < 1) and (data.sun.Position + mod:GetEntityData(data.sun).orbitalpos.venus:Rotated(mod:GetEntityData(data.sun).orbitalspeed.venus * 30)).Y > data.sun.Position.Y - 20 and ((data.last + 120 < npc.FrameCount and math.random(17) == 1) or data.last + 150 < npc.FrameCount) then
					sprite:Play("SpawnBrain")
				end
			end

			if mod.GetEntityCount(32) > 0 then
				data.last = npc.FrameCount
			end

			if sprite:IsEventTriggered("Spawn") then
				npc:PlaySound(SoundEffect.SOUND_SUMMONSOUND, 0.6, 0, false, 1)
				data.last = npc.FrameCount
				local brain = Isaac.Spawn(32, 0, 0, npc.Position, nilvector, npc)
				brain:GetSprite():ReplaceSpritesheet(0, "gfx/bosses/the sun/sunbrain.png")
				brain:GetSprite():LoadGraphics()
			elseif sprite:IsEventTriggered("Liftoff") then
				npc:PlaySound(SoundEffect.SOUND_MEATY_DEATHS,1,0,false,1.3)
			end
		else
			npc:Kill()
		end
	end,
	[52] = function(npc, sprite, data) -- Earth (The Kidney)
		if data.sun and data.sun:Exists() then
			if not data.init then
				npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
				npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE

				sprite:Play("Idle")
				sprite.Offset = Vector(0, -14)

				data.stones = {}
				for i = 1, 2 do
					data.stones[i] = Isaac.Spawn(npc.Type, 54, npc.SubType, npc.Position + Vector(30, 30):Rotated(180 * i), nilvector, npc)
					data.stones[i]:GetSprite():Play("Stone0"..i)
					mod:GetEntityData(data.stones[i]).skin = i
					data.stones[i].Parent = npc
				end

				data.orbitalpos = {
					data.stones[1].Position - npc.Position,
					data.stones[2].Position - npc.Position,
				}

				data.init = true
			end

			if npc.FrameCount > 24 then
				for i, s in pairs(data.stones) do
					local speed = 1
					if data.enraged then
						speed = 3
					end
					data.orbitalpos[i] = data.orbitalpos[i]:Rotated(speed)
					s.Velocity = (npc.Position + data.orbitalpos[i]) - s.Position
				end
			end

			if npc:IsDead() then
				for _, s in pairs(data.stones) do
					s:Kill()
				end
			end
		else
			npc:Kill()
		end
	end,
	[53] = function(npc, sprite, data) -- Neptune (The Heart)
		if data.sun and data.sun:Exists() then
			local room = game:GetRoom()

			if not data.init then
				npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
				npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE

				sprite:Play("Idle")
				sprite.Offset = Vector(0, -14)

				data.last = npc.FrameCount

				data.init = true
			end

			if sprite:IsFinished("BeatStart") then
				sprite:Play("Beating")
				data.beat = npc.FrameCount
			elseif sprite:IsFinished("BeatEnd") then
				sprite:Play("Idle")
				data.last = npc.FrameCount
				data.blowOut = false
			end

			if sprite:IsEventTriggered("Done") then
				npc:PlaySound(SoundEffect.SOUND_HEARTIN, 1.5, 0, false, 0.7)
				if data.blowOut then
					for i = 30, 360, 30 do
						local params = ProjectileParams()
						params.FallingAccelModifier = -0.08
						params.FallingSpeedModifier = 0
						params.Scale = 2
						local vec = Vector(9, 0):Rotated(i)
						npc:FireProjectiles(npc.Position + Vector(20, 0):Rotated(i), Vector(9, 0):Rotated(i), 0, params)
					end
				end
			elseif data.blowOut and sprite:IsPlaying("BeatEnd") and sprite:GetFrame() == 21 then
				for i = 30, 360, 30 do
					local params = ProjectileParams()
					params.FallingAccelModifier = -0.08
					params.FallingSpeedModifier = 0
					params.Scale = 2
					local vec = Vector(9, 0):Rotated(i)
					npc:FireProjectiles(npc.Position + Vector(20, 0):Rotated(i + 15), Vector(9, 0):Rotated(i + 15), 0, params)
				end
			end

			if sprite:IsPlaying("Idle") then
				if data.last + 480 < npc.FrameCount and room:IsPositionInRoom(npc.Position, 0) and math.random(6) == math.random(6) then
					sprite:Play("BeatStart")
				end
			elseif sprite:IsPlaying("Beating") then
				if sprite:GetFrame() % 8 == 0 then
					npc:PlaySound(SoundEffect.SOUND_HEARTBEAT_FASTEST, 1.5, 0, false, 1.3)
					local offset = math.random(360)
					for i = 1, 4 do
						local p = mod:LazySpawnProjectile(0, 0, npc.Position, Vector(3, 0):Rotated(i * 90 + 5 * (npc.FrameCount % 360)), npc)
					end
				end

				if data.beat + 80 <= npc.FrameCount or not room:IsPositionInRoom(npc.Position, 0) then
					sprite:Play("BeatEnd")
				end
			end

			if npc.FrameCount % 4 == 0 and room:IsPositionInRoom(npc.Position, 0) then
				local c = Isaac.Spawn(1000, 22, 0, npc.Position, nilvector, npc):ToEffect()
				c:SetTimeout(30)
				if npc.FrameCount % 8 == 0 then
					local params = ProjectileParams()
					params.FallingAccelModifier = -0.08
					params.FallingSpeedModifier = 0
					npc:FireProjectiles(npc.Position, nilvector, 0, params)
				end
			end

			if data.enraged then
				if not room:IsPositionInRoom(npc.Position, 0) then
					if not data.flippedYet then
						if data.sun then
							local sund = mod:GetEntityData(data.sun)
							sund.orbitalspeed.neptune = sund.orbitalspeed.neptune * -1
							if sprite:IsPlaying("Idle") then
								sprite:Play("BeatEnd")
								data.blowOut = true
								Game():ShakeScreen(15)
								npc:PlaySound(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND,0.6,2,false,1)
							end
						end
						data.flippedYet = true
					end
				else
					data.flippedYet = false
				end
			end
		else
			npc:Kill()
		end
	end,
	[54] = function(npc, sprite, data) -- Moon (The Kidney Stones)
		if npc.Parent and npc.Parent:Exists() then
			if not data.init then
				npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS)
				npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE

				sprite.Offset = Vector(0, -14)
				data.Cooldown = 0
				data.last = npc.FrameCount
				data.skin = data.skin or math.random(2)
				data.init = true
			end

			data.Cooldown = data.Cooldown - 1
			if sprite:IsFinished("Shoot0"..data.skin) then
				data.last = npc.FrameCount
				sprite:Play("Stone0"..data.skin)
			end

			--[[if sprite:IsPlaying("Stone0"..data.skin) then
				if data.last + 150 < npc.FrameCount and room:IsPositionInRoom(npc.Position, 0) and math.random(35) == math.random(35) then
					sprite:Play("Shoot0"..data.skin)
				end
			end]]

			if sprite:IsEventTriggered("Shoot") then
				--local p = mod:LazySpawnProjectile(4, 0, npc.Position, (npc:GetPlayerTarget().Position - npc.Position):Resized(7), npc)
				--p:SetColor(Color(1, 1, 0, 1, 0, 0, 0), 0, 0, 0, false, true)
				data.targVec = (npc:GetPlayerTarget().Position - npc.Position):Normalized()
				npc.StateFrame = 3
			end

			if npc.StateFrame > 0 then
				if npc.StateFrame == 3 then
					npc:PlaySound(mod.Sounds.Valvo, 1.5, 0, false, math.random(9,11)/10)
				end
				npc.StateFrame = npc.StateFrame - 1
				local power = (15-(5 - npc.StateFrame-6))/15
				local pistolet = ProjectileParams()
				pistolet.Color = FiendFolio.ColorLemonYellow
				--pistolet.Variant = 4
				npc.Velocity = npc.Velocity - data.targVec*3*(power^3)
				Game():ShakeScreen(math.floor(((power^2)*15)*0.3))
				--if npc.FrameCount%(5-math.ceil((power^2)*4))==0 then
					for i=0,math.ceil((power^2)*1.5),1 do
						local projectileSpeed = math.random(40,80)/10*power*1.2
						pistolet.Scale = (projectileSpeed-3)/3.5 +(1-power)/7
						pistolet.FallingAccelModifier = math.random(1,5)/20*(2-power)
						npc:FireProjectiles(npc:ToNPC().Position + data.targVec*10, data.targVec:Rotated(-5):Rotated(math.random(0,10))*projectileSpeed, 0, pistolet)
					end
				--end
			end
		else
			npc:Kill()
		end
	end,
	[55] = function(npc, sprite, data) -- Sun Spikes
		if data.sun and data.sun:Exists() then
			if not data.init then
				npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS)
				npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
				data.init = true
			end

			npc.Velocity = nilvector
		else
			npc:Kill()
		end
	end,
}

function mod:hollowKnightProjectileAI(npc, sprite, data)
	mod:setTargetOfNPC(npc, data)

	if not data.init then
		--npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
		npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
		data.init = true
	end

	if npc.FrameCount < 5 then
		npc.SpriteOffset = npc.SpriteOffset * (1 - npc.FrameCount / 5)
	end

	if sprite:IsFinished("ShotOut") then
		sprite:Play("Roll")
	end
	if sprite:IsFinished("Roll") then
		sprite:Play("Spawn")
	end

	if not sprite:IsPlaying("ShotOut") then
		npc.Velocity = npc.Velocity * 0.9
	end

	if sprite:IsEventTriggered("SpawnBrain") then
		data.brain = Isaac.Spawn(mod.FF.Cortex.ID, mod.FF.Cortex.Var, 0, npc.Position, nilvector, npc)
		data.brain:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		data.brain.Parent = npc
		mod:copyStatusEffects(npc, data.brain)
		data.brain:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		data.brain.HitPoints = npc.HitPoints
	end

	if sprite:IsFinished("Spawn") then
		local knight = Isaac.Spawn(mod.FF.HollowKnight.ID, mod.FF.HollowKnight.Var, 0, npc.Position, nilvector, npc)
		if npc.SubType == 1 then
			local es = knight:GetSprite()
			es:ReplaceSpritesheet(0, "gfx/enemies/hollowknight/hollow_knight_sun.png")
			es:ReplaceSpritesheet(1, "gfx/enemies/hollowknight/hollow_knight_sun.png")
			es:LoadGraphics()
		end
		data.brain.Parent = knight
		local d = mod:GetEntityData(knight)
		d.init = true
		d.brain = data.brain
		mod:copyStatusEffects(npc, knight)
		knight:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		--knight:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET)
		npc:Remove()
	end
end

mod:addCopyStatusHandler(FiendFolio.FF.RollingHollowKnight.ID, FiendFolio.FF.RollingHollowKnight.Var)

--Run Boss AI
function mod:checkBosses(npc)
	local sprite = npc:GetSprite();
	local npcdata = mod:GetEntityData(npc);
	local var = npc.Variant
	if var == 10 then
		mod:battyAI(npc, sprite, npcdata)
	elseif var == 1000 then
		mod:blueHorfAI(npc, sprite, npcdata)
	elseif var == 1010 then
		mod:dukeOfDemonsAI(npc, sprite, npcdata)
	elseif var == 1011 then
		mod:dukesDemonAI(npc, sprite, npcdata)
	elseif var == 21 then
		mod:commissionAI(npc, sprite, npcdata)
	elseif var == 30 then
		mod:griddleHornAI(npc, sprite, npcdata)
	elseif var == 40 then
		mod:MoistroAKAJackTheDripperAI(npc, sprite, npcdata)
	elseif var >= 50 and var <= 55 then
		sunAIs[var](npc, sprite, npcdata)
	elseif var >= 60 and var <= 63 then
		mod:organizationAI(npc, sprite, npcdata)
	elseif var == 70 then
		mod:bascoAI(npc, sprite, npcdata)
	elseif var == 71 then
		mod:bascoFruitAI(npc, sprite, npcdata)
	elseif var == 80 then
		mod:kingpinAI(npc, sprite, npcdata)
	elseif var == 90 then
		mod:peepingAI(npc, sprite, npcdata)
	elseif var == 91 then
		mod:peepingPhase2AI(npc, sprite, npcdata)
	elseif var == 92 then
		mod:peepstalkAI(npc, sprite, npcdata)
	elseif var == 93 then
		mod:peepeeAI(npc, sprite, npcdata)
	elseif var == 100 then
		mod:luncheonAI(npc)
	elseif var == 101 then
		local subt = npc.SubType
		mod:tapewormAI(npc, subt)
	elseif var == 102 then
		local subt = npc.SubType
		mod:tapewormEggAI(npc, subt)
	elseif var == 103 then
		mod:wormBall(npc)
	elseif var == 110 then
		mod:pollutionAI(npc, sprite, npcdata)
	elseif var == 111 then
		mod:pollutionHorsepowerAI(npc, sprite, npcdata)
	elseif var == 120 then
		mod:meltdownAI(npc, sprite, npcdata)
	elseif var == 121 then
		mod:meltdownForsakenAI(npc, sprite, npcdata)
	elseif var == 122 then
		mod:meltdownBombHorseAI(npc, sprite, npcdata)
	elseif var == 160 then
		mod:bluehorfRealAI(npc, sprite, npcdata)
	elseif var == 161 then
		mod:babybluehorfAI(npc, sprite, npcdata)
	elseif var == mod.FF.Dusk.Var then
		mod:duskBossAI(npc, sprite, npcdata)
	elseif var == mod.FF.DuskHand.Var then
		mod:duskHandAI(npc, sprite, npcdata)
	elseif var == mod.FF.Cacamancer.Var then
		mod:cacamancerAI(npc, sprite, npcdata)
	elseif var == mod.FF.CacaSplurt.Var then
		mod:cacaSplurtAI(npc, sprite, npcdata)
	elseif var == mod.FF.Gutso.Var then
		mod:gutsoAI(npc, sprite, npcdata)
	elseif var == mod.FF.Ghostbuster.Var then
		mod:ghostbusterAI(npc, sprite, npcdata)
	elseif var == mod.FF.Emmission.Var then
		mod:emmissionAI(npc, sprite, npcdata)
	elseif var == mod.FF.CongressingEmmission.Var then
		mod:congressingEmmissionAI(npc, sprite, npcdata)
	elseif var == mod.FF.EmmissionProjectile.Var then
		mod:emmissionProjectileAI(npc, sprite, npcdata)
	elseif var == mod.FF.EmmissionDeathHitbox.Var then
		mod:emmissionDeathHitboxAI(npc, sprite, npcdata)
	elseif var == mod.FF.WhispersController.Var then
		mod:whispersControllerAI(npc, sprite, npcdata)
	elseif var == mod.FF.Whispers.Var then
		mod:whispersAI(npc, sprite, npcdata)
	elseif var == mod.FF.CacophobiaVenus.Var then
		mod:cacophobiaAI(npc, sprite, npcdata)
	elseif var == mod.FF.Junkstrap.Var then
		mod:JunkstrapAI(npc, sprite, npcdata)
	elseif var == mod.FF.FoozTwinRed.Var then
		mod:foozTwinAI(npc, sprite, npcdata)
	elseif var == mod.FF.FoozTwinsBall.Var then
		mod:foozBallAI(npc, sprite, npcdata)
	elseif var == mod.FF.Deluge.Var then
		mod:DelugeAI(npc, sprite, npcdata)
	elseif var == mod.FF.BabyBubbles.Var then
		mod:babyBubblesAI(npc, sprite, npcdata)
	elseif var == mod.FF.BabyBubblesPipe.Var then
		mod:babyBubblesPipeAI(npc, sprite, npcdata)
	elseif var == mod.FF.Lez.Var then
		mod:lezAI(npc, sprite, npcdata)
	elseif var == 0 then
		mod:buckAI(npc, sprite, npcdata)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkBosses, mod.FFID.Boss)
--bossai, check980, 980ai

--bossrender
function mod:renderBosses(npc, offset)
	mod:organizationRender(npc)
	mod:kingpinRender(npc)
	local var = npc.Variant
	if var == 0 then
		mod:buckRenderAI(npc)
	elseif var == 30 then
		mod:griddleRenderAI(npc)
	elseif var == 111 then
		mod:pollution2RenderAI(npc)
	elseif var == 121 then
		mod:meltdown2RenderAI(npc)
	elseif var == mod.FF.Aquagob.Var then
		mod:aquagobRenderAI(npc)
	elseif var == mod.FF.Cacamancer.Var then
		mod:cacamancerRenderAI(npc)
	elseif var == mod.FF.Dusk.Var then
		mod:duskRenderAI(npc)
	elseif var == mod.FF.Ghostbuster.Var then
		mod:ghostbusterRender(npc, offset)
	elseif var == mod.FF.Emmission.Var then
		mod:emmissionRender(npc, offset)
	elseif var == mod.FF.CongressingEmmission.Var then
		mod:congressingEmmissionRender(npc, offset)
	elseif var == mod.FF.EmmissionProjectile.Var then
		mod:emmissionProjectileRender(npc, offset)
	elseif var == mod.FF.WarpZone.Var then
		mod:warpZoneRender(npc)
	elseif var == mod.FF.Junkstrap.Var then
		mod:JunkstrapRender(npc, npc:GetSprite())
	elseif var == mod.FF.Deluge.Var then
		mod:DelugeRender(npc)
	elseif var == mod.FF.FoozTwinsBall.Var then
		mod:foozBallRender(npc)
	elseif var == mod.FF.BabyBubbles.Var then
		mod:babyBubblesRender(npc)
	end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.renderBosses, mod.FFID.Boss)

--980hurt
function mod:checkBossHurt(npc, damage, flag, source, cooldown)
	local variant = npc.Variant;

	if variant == Isaac.GetEntityVariantByName("Buck") then
		return mod:buckHurt(npc, damage, flag, source);
	elseif variant == 30 then -- Griddle
		if flag & DamageFlag.DAMAGE_FIRE ~= 0 and source.Type ~= 1 then
			return false
		elseif mod:GetEntityData(npc).unhurtable then
			return false
		end
	elseif variant == 40 then -- Moistro / Jack the Dripper, JackTheDripper
		if mod:shouldDoDeathAnimation(npc) then
			if npc.HitPoints - damage <= 10 then
			npc.Velocity = nilvector
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			npc.HitPoints = 0
			npc:ToNPC().State = 11
			return false
			end
		end
	elseif variant == 50 or variant == 55 then
		return false
	elseif variant == 51 then
		if mod:GetEntityData(npc).sun then
			local sund = mod:GetEntityData(mod:GetEntityData(npc).sun)
			if sund.orbitalspeed and sund.orbitalspeed.venus then
				sund.orbitalspeed.venus = sund.orbitalspeed.venus + 0.02
			end
		end
		if flag ~= flag | DamageFlag.DAMAGE_CLONES and mod:GetEntityData(npc).sun then
			local sund = mod:GetEntityData(mod:GetEntityData(npc).sun)
			if sund.earth then
				sund.earth:TakeDamage(damage/2, flag | DamageFlag.DAMAGE_CLONES, source, cooldown)
			end
			if sund.neptune then
				sund.neptune:TakeDamage(damage/2, flag | DamageFlag.DAMAGE_CLONES, source, cooldown)
			end
		end
		if flag & DamageFlag.DAMAGE_FIRE ~= 0 and source.Type == 1000 and source.Variant == 7005 then
			return false
		end
	elseif variant == 52 then
		if flag ~= flag | DamageFlag.DAMAGE_CLONES and mod:GetEntityData(npc).sun then
			local sund = mod:GetEntityData(mod:GetEntityData(npc).sun)
			if sund.venus then
				sund.venus:TakeDamage(damage/2, flag | DamageFlag.DAMAGE_CLONES, source, cooldown)
			end
			if sund.neptune then
				sund.neptune:TakeDamage(damage/2, flag | DamageFlag.DAMAGE_CLONES, source, cooldown)
			end
		end
		if flag & DamageFlag.DAMAGE_FIRE ~= 0 and source.Type == 1000 and source.Variant == 7005 then
			return false
		end
	elseif variant == 53 then
		if flag ~= flag | DamageFlag.DAMAGE_CLONES and mod:GetEntityData(npc).sun then
			local sund = mod:GetEntityData(mod:GetEntityData(npc).sun)
			if sund.venus then
				sund.venus:TakeDamage(damage/2, flag | DamageFlag.DAMAGE_CLONES, source, cooldown)
			end
			if sund.earth then
				sund.earth:TakeDamage(damage/2, flag | DamageFlag.DAMAGE_CLONES, source, cooldown)
			end
		end
		if flag & DamageFlag.DAMAGE_FIRE ~= 0 and source.Type == 1000 and source.Variant == 7005 then
			return false
		end
	elseif variant == 54 then
		local d = mod:GetEntityData(npc)
		if d.Cooldown and d.Cooldown <= 0 then
			d.Cooldown = 45
			npc:GetSprite():Play("Shoot0"..mod:GetEntityData(npc).skin)
		end
		return false
	elseif variant == 55 then
		return false
	elseif variant == mod.FF.Basco.Var then
		return mod:bascoHurt(npc, damage, flag, source)
	elseif variant == mod.FF.BascoFood.Var then
		return mod:bascoFruitHurt(npc, damage, flag, source)
	elseif variant == 90 then
		if mod:GetEntityData(npc).state == "peepeePlant" then
			npc.HitPoints = npc.HitPoints + damage * 0.75
		end
	elseif variant == 92 then
		return false
	elseif variant == 100 then
		if flag & DamageFlag.DAMAGE_CLONES == 0 then
			return false
		end
	elseif variant == 101 then
		local d = mod:GetEntityData(npc)
		if (d.Color == "whiteboi" and npc.SubType == 2) or (npc.Parent and npc.Parent.SubType == 2 and mod:GetEntityData(npc.Parent).Color == "whiteboi") or (npc.Child and npc.Child.SubType == 2 and mod:GetEntityData(npc.Child).Color == "whiteboi") then
			d.damagetook = d.damagetook or 0
			d.damagetook = d.damagetook + damage
			if d.damagetook > 7 then
				d.AAAHELP = true
				d.damagetook = 0
			end
		end
	elseif variant == 102 then
		return false
	elseif variant == 111 then
		if flag & DamageFlag.DAMAGE_FIRE ~= 0 and source.Type == 1000 and source.Variant == 7005 then
			return false
		end
	elseif variant == 120 then
		if flag & DamageFlag.DAMAGE_FIRE ~= 0 and source.Type == 1000 and source.Variant == 7005 then
			return false
		elseif flag ~= flag | DamageFlag.DAMAGE_CLONES then
			if npc:GetSprite():IsPlaying("Transition") then
				npc:TakeDamage(damage * 0.05, flag | DamageFlag.DAMAGE_CLONES, source, cooldown)
				return false
			end
		end
	elseif variant == 121 then
		if flag & DamageFlag.DAMAGE_TNT ~= 0 and source.Type == mod.FFID.Tech then
			return false
		elseif flag & DamageFlag.DAMAGE_FIRE ~= 0 and source.Type == 1000 and source.Variant == 7005 then
			return false
		elseif flag ~= flag | DamageFlag.DAMAGE_CLONES then
			if npc:GetSprite():IsPlaying("Appear") or npc:GetSprite():IsPlaying("TransitionIdle") then
				npc:TakeDamage(damage * 0.05, flag | DamageFlag.DAMAGE_CLONES, source, cooldown)
				return false
			end
		end
	elseif variant == mod.FF.Dusk.Var then
		mod:duskHurt(npc, damage, flag, source, cooldown)
	elseif variant == mod.FF.DuskHand.Var then
		if npc.Parent then
			npc.Parent:TakeDamage(damage, flag | DamageFlag.DAMAGE_CLONES, source, cooldown)
			--npc:SetColor(Color(30,1,1,1,0,0,0), 2, 1, false, false)
			return false
		end
	elseif variant == mod.FF.Cacamancer.Var then
		if flag == flag | DamageFlag.DAMAGE_EXPLOSION then
			mod:GetEntityData(npc).preventGas = 30
		end
	elseif variant == mod.FF.CacophobiaVenus.Var then
		return mod:cacophobiaHurt(npc, damage, flag, source, cooldown)
	elseif variant == mod.FF.Deluge.Var then
		return mod:DelugeHurt(npc, damage, flag, source, cooldown)
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.checkBossHurt, mod.FFID.Boss)

function mod:checkBossKill(npc)
	local variant = npc.Variant
	if variant == 101 then
		mod:tapewormDeath(npc, npc.SubType)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.checkBossKill, mod.FFID.Boss)

function mod:checkBossRemove(npc)
	local variant = npc.Variant;
	if variant == 101 then
		mod:tapewormRemoveAI(npc, subt)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, mod.checkBossRemove, mod.FFID.Boss)

function mod:checkBossDeath(npc)

end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.checkBossDeath, mod.FFID.Boss)

-- Guillotine21 AI --
function mod:check940(npc)
 local variant = npc.Variant
 local subType = npc.SubType
	if variant == 10 then

	else
		mod:honeyeyeAI(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.check940, mod.FFID.Guill)
-- Guillotine21 AI END--

function mod:customHitboxAI(npc)
	if npc.SubType == 0 and (not npc.SpawnerEntity or not npc.SpawnerEntity:Exists() or mod:isStatusCorpse(npc.SpawnerEntity)) then
		npc:Remove()
		return
	elseif npc.SubType == 1 and (not mod:GetEntityData(npc).CustomGrid or not mod:GetEntityData(npc).CustomGrid:Exists()) then
		npc:Remove()
		return
	end

	local data = mod:GetEntityData(npc)
	if not data.Init then
		npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		if not data.AllowKnockback then
			npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
		end
		npc.Visible = false
		data.Init = true
	end

	data.Updated = true

	local width, height, rotation = data.Width or 16, data.Height or 16, data.Rotation or 0

	npc.SpriteRotation = rotation
	npc.SizeMulti = Vector(width / 16, height / 16)

	if data.FixToPosition then
		npc.Position = data.FixToPosition
		npc.Velocity = Vector.Zero
	end

	if data.FixToSpawner then
		data.SpawnerOffset = data.SpawnerOffset or Vector.Zero
		if npc.SubType == 1 then
			local customGrid = data.CustomGrid
			if customGrid.Projectile then
				npc.Position = data.CustomGrid.Projectile.Position
				npc.Velocity = data.CustomGrid.Projectile.Velocity
			elseif customGrid.GridEntity then
				npc.Position = data.CustomGrid.GridEntity.Position
				npc.Velocity = Vector.Zero
			else
				npc.Position = game:GetRoom():GetGridPosition(data.CustomGrid.GridIndex)
				npc.Velocity = Vector.Zero
			end
		else
			npc.Position = npc.SpawnerEntity.Position
			npc.Velocity = npc.SpawnerEntity.Velocity
		end

		if data.PositionOffset then
			npc.Position = npc.Position + data.PositionOffset
		end
	end
end

function mod:HitboxPrePlayerCollision(hb, player, hbData)
	if hbData.OnPlayerCollide then
		return hbData.OnPlayerCollide(hb, player)
	end
end

function mod:customHitboxFrozenChecks()
	local hitboxes = Isaac.FindByType(mod.FF.Hitbox.ID, mod.FF.Hitbox.Var)
	if #hitboxes > 0 then
		local chains = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.ANIMA_CHAIN)
		for _, hitbox in ipairs(hitboxes) do
			local data = mod:GetEntityData(hitbox)
			if data.Updated then
				data.Updated = false
			elseif not data.NoForceUpdate then
				mod:customHitboxAI(hitbox:ToNPC())
			end

			if data.OnAnimaSola then
				for _, chain in ipairs(chains) do
					if chain.Target and GetPtrHash(chain.Target) == GetPtrHash(hitbox) then
						data.OnAnimaSola(hitbox, chain)
					end
				end
			end
		end
	end
end

function mod:waitingWormAI(npc, subt)
	local sprite = npc:GetSprite()
	local npcdata = mod:GetEntityData(npc)
	local target = npc:GetPlayerTarget()

	if not npcdata.init then
		npcdata.StateFrame = 0
		npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS)
		npc.Visible = false
		npcdata.waiting = true
		npcdata.init = true
		npc.TargetPosition = npc.Position
		if npc.SubType == mod.FF.WaitingWormBunker.Sub then
			npc.PositionOffset = Vector(0,10)
		end

		mod:waitingWormSprites(npc, sprite, subt)

	else
		npcdata.StateFrame = npcdata.StateFrame + 1
	end

	if npcdata.waiting then
		if mod.CanIComeOutYet() then
			if npcdata.StateFrame > 15 then
				if mod.farFromAllPlayers(npc.Position, 60) then
					npcdata.waiting = false
					npc:ClearEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS)
					npc.Visible = true
					if(subt == 12) then
						--weaver
						mod:spritePlay(sprite, "Empty")
					elseif(subt == 13) then
						--weaver sr.
						mod:spritePlay(sprite, "Empty")
					elseif(subt == 10 or subt == 18) then
						--lump/bunker worm
						mod:spritePlay(sprite, "Emerge")
					elseif(subt == 11) then
						--fred
						mod:spritePlay(sprite, "DigUp")
					elseif (subt == 14 or subt == 15 or subt == 16 or subt == 17) then
						--pins
						mod:spritePlay(sprite, "HoleClose")
						npc.Visible = false
					elseif(subt == 19) then
						--drunk worm
						mod:spritePlay(sprite, "digout")
					else
						npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
						mod:spritePlay(sprite, "Appear")
					end
				end
			end
		else
			npcdata.StateFrame = 0
		end
	else
		npc.Velocity = nilvector
		npc:ClearEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS)
		if (subt == 14 or subt == 15 or subt == 16) then
			if sprite:IsFinished("HoleClose") then
				--pin scolex frail
				local pin = Isaac.Spawn(62, subt - 14, 0, npc.Position, nilvector, npc):ToNPC()
				pin.Visible = false
				mod:GetEntityData(pin).wasWaitingWorm = true
				npc:Remove()
			end
		elseif subt == 17 then
			if sprite:IsFinished("HoleClose") then
				local kingy = Isaac.Spawn(mod.FF.Kingpin.ID, mod.FF.Kingpin.Var, 0, npc.Position, nilvector, npc)
				kingy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				kingy:Update()
				npc:Remove()
			end
		elseif subt == 12 or subt == 13 then
			if sprite:IsFinished("Empty") then
				if(subt == 12) then
					--weaver
						local weave = Isaac.Spawn(mod.FF.Weaver.ID, 0, 0, npc.Position, nilvector, npc):ToNPC()
						weave:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
						npc:Remove()
				elseif(subt == 13) then
					--weaver sr.
					local weave = Isaac.Spawn(mod.FF.Weaver.ID, 1, 0, npc.Position, nilvector, npc):ToNPC()
					weave:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					npc:Remove()
				end
			end
		elseif subt == 10 then
			if sprite:IsFinished("Emerge") then
				--lump
				npc:Morph(56, 0, 95, -1)
				mod:waitingWormSprites(npc, sprite, subt)
			end
		elseif subt == 11 then
			if sprite:IsFinished("DigUp") then
				--fred
				npc:Morph(59, 0, 95, -1)
				mod:waitingWormSprites(npc, sprite, subt)
			end
		elseif subt == 18 then --bunker worm
			if sprite:IsFinished("Emerge") then
				npc:Morph(mod.FF.BunkerWorm.ID, mod.FF.BunkerWorm.Var, 0, -1)
				local d = mod:GetEntityData(npc)
				d.shoot = 1
				d.state = "idle"
				d.init = true
				npc.TargetPosition = npc.Position
				npc.PositionOffset = Vector(0,10)
				npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			elseif sprite:IsEventTriggered("Emerge") then
				npc:PlaySound(SoundEffect.SOUND_SHOVEL_DIG,0.6,0,false,math.random(150,170)/100)
			elseif sprite:IsEventTriggered("Shoot") then
				npc:PlaySound(SoundEffect.SOUND_MAGGOT_BURST_OUT,0.7,0,false,math.random(120,130)/100)
			end
		elseif subt == 19 and sprite:IsFinished("digout") then
			--drunk worm
			npc:Morph(mod.FF.DrunkWorm.ID, mod.FF.DrunkWorm.Var, 0, -1)
			local d = mod:GetEntityData(npc)
			d.state = "idle"
			d.init = true
			npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
			npc.TargetPosition = npc.Position
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		elseif sprite:IsFinished("Appear") then
			if subt == 1 then
				--round
				npc:Morph(244, 0, 95, -1)
			elseif subt == 2 then
				--night
				npc:Morph(255, 0, 95, -1)
			elseif subt == 3 then
				--ulcer
				npc:Morph(289, 0, 95, -1)
			elseif subt == 4 then
				--roundy
				npc:Morph(276, 0, 95, -1)
			elseif subt == 5 then
				--tube
				npc:Morph(244, 1, 95, -1)
			elseif subt == 6 then
				--parabite
				npc:Morph(58, 0, 95, -1)
			elseif subt == 7 then
				--scarred parabite
				npc:Morph(58, 1, 95, -1)
			elseif subt == 8 then
				--bone
				npc:Morph(mod.FF.BoneWorm.ID, mod.FF.BoneWorm.Var, 95, -1)
			elseif subt == 9 then
				--drink
				npc:Morph(666, 100, 95, -1)
				npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
				npcdata.state = "idle"
				npcdata.idletimer = math.random(15, 30)
				npcdata.burrowedtimer = 0
				npcdata.init = true
				npcdata.firstdig = false
				npcdata.burrowcheck = false
				npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			else
				--base case
				npc:Morph(244, 0, 95, -1)
			end
			mod:waitingWormSprites(npc, sprite, subt)
		end
	end
end

function mod:waitingWormSprites(npc, sprite, subt)
	local level = game:GetLevel()
	local stage = level:GetStage()
	local stageType = level:GetStageType()

	--[[if(subt == 5) then
		if ((stageType == StageType.STAGETYPE_REPENTANCE) and (stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE1_2)) or ((stageType == StageType.STAGETYPE_AFTERBIRTH) and (stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2)) then
			sprite:ReplaceSpritesheet(0, "gfx/monsters/afterbirthplus/tubeworm_downpour.png")
			sprite:LoadGraphics()
		end
	end]]
	if subt == 6 and mod.roomBackdrop == 10 then
		--parabite
		local spriteSheet = "gfx/monsters/classic/monster_199_parabite_morbus"
		if LastJudgementSprites then
			spriteSheet = "gfx/monsters/classic/monster_199_parabite_lj_morbus"
		end
		mod:ReplaceEnemySpritesheet(npc, spriteSheet, 0)
		mod:ReplaceEnemySpritesheet(npc, spriteSheet, 1)
	end
end

--Run Psion AI
function mod:checkPsion(npc)
	mod:psionAI(npc)
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkPsion, mod.FF.Psion.ID)

--Run Further Erf AI
--My god it's gone
--960update, 960_update, 960ai,

function mod:checkBombmuncherCollision(npc1, npc2, mysteryBoolean)
  local d = mod:GetEntityData(npc1:ToNPC())
	if npc1.Variant == mod.FF.Bombmuncher.Var then
		if npc2.SpawnerEntity and npc2.SpawnerEntity.Variant == npc1.Variant then
			return true
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, mod.checkBombmuncherCollision, mod.FF.Bombmuncher.ID)

--[[function mod:checkPlayerColl(playerEntity, npc2, mysteryBoolean)
	if npc2.Type == 960 and npc2.Variant == 451 then
		Isaac.ConsoleOutput("ya2")
		return false
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, mod.checkPlayerColl)]]

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
	local data = mod:GetEntityData(effect)
	local sprite = effect:GetSprite()

	if not data.init then
		sprite:SetFrame("Bubble", 0)
		data.init = true
	else
		for _, p in pairs(Isaac.FindByType(1, -1, -1, false, false)) do
			if p.Position:Distance(effect.Position) - effect.Size - p.Size <= 0 then
				effect:Remove()
				sfx:Play(SoundEffect.SOUND_PLOP,0.7,2,false,math.random(8,12)/10)
			end
		end
	end

	if sprite:GetFrame() == 7 and sprite:IsFinished("Bubble") then
		sprite:Play("BubbleIdle")
	end

	if sprite:IsFinished("Bubble") and effect.FrameCount > 1 and effect.FrameCount % 7 == 0 then
		sprite:SetFrame("Bubble", effect.FrameCount / 7)
	end

	if effect.FrameCount > 150 then
		effect:Remove()
		sfx:Play(SoundEffect.SOUND_PLOP,0.7,2,false,math.random(8,12)/10)
		for i = 1, 4 do
			local p = mod:LazySpawnProjectile(0, 0, effect.Position, RandomVector() * (math.random(12, 50)/7.5), nil):ToProjectile()
			p.FallingSpeed = -35 + math.random(10);
			p.FallingAccel = 1.5
			p.Color = mod.ColorDankBlackReal
		end
	end

	local ents = {}
	for _, e in pairs(Isaac.GetRoomEntities()) do
		if e.Position:Distance(effect.Position) - effect.Size - e.Size <= 1 and (e.Type == 1000 and e.Variant == 26 and e:GetColor().A > 0.5) then
			ents[#ents + 1] = e
		end
	end

	if #ents == 0 then
		if sprite:IsPlaying("BubbleIdle") then
			effect:Remove()
			sfx:Play(SoundEffect.SOUND_PLOP,0.7,2,false,math.random(8,12)/10)
			for i = 1, 4 do
				local p = mod:LazySpawnProjectile(0, 0, effect.Position, RandomVector() * (math.random(12, 50)/7.5), nil):ToProjectile()
				p.FallingSpeed = -35 + math.random(10);
				p.FallingAccel = 1.5
				p.Color = mod.ColorDankBlackReal
			end
		else
			effect:Remove()
			sfx:Play(SoundEffect.SOUND_PLOP,0.7,2,false,math.random(8,12)/10)
		end
	end
end, 1723)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
	local sprite = effect:GetSprite()
	local subt = effect.SubType

	sprite:Play("Poof")

	if sprite:IsEventTriggered("popsound") and not subt == 1 then
		sfx:Play(SoundEffect.SOUND_PLOP, 0.7, 2, false, math.random(8,12)/10)
	end
	if sprite:IsFinished("Poof") then
		effect:Remove()
	end
end, 7020)

function mod:globalPlayerTakeDamageEarly(player, amount, flag, source, cooldown)
	if mod:nursingOnDamage(player, source) == false then
		return false
	elseif mod:pacifiedOnDamage(player, source) == false then
		return false
	elseif mod:tryTimeFcukTeleport(player, flag, source, cooldown) == false then
		return false
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, CallbackPriority.EARLY, mod.globalPlayerTakeDamageEarly)

function mod:PlayerTakeDamageEarlyButAfterHolyMantle(player, amount, flag, source, cooldown)
	local player = player:ToPlayer()
	if mod:shadowMantleHurt(player, flag, source, cooldown) == false then
		return false
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.EARLY, mod.PlayerTakeDamageEarlyButAfterHolyMantle, 1)

local mimeHurts = {
	"Ouch!",
	"Oof!",
	"Ow!",
	"Merde!",
	"Sacre Bleu!",
	"Mon Dieu!",
}
local mimeHurtsFiend = {
	"F**k!",
	"S**t!",
	"D*mn!",
	"Cr*p!",
	"Gah!",
	"Grah!",
	"Bah!",
	"**** **** ***** ** *** *** !",
}

function mod:playerDamage(entity, amount, flags, source, cooldown)
	local player = entity:ToPlayer()
	local ret = mod:biendHurt(entity, amount, flags, source, cooldown)
	if ret ~= nil then
		return ret
	end

	local data = mod:GetEntityData(player)
	mod.CheckDireChestConversion(flags, data)

	mod:erflyPlayerHurt(player, amount, flags, source, cooldown)

	if player:HasCollectible(mod.ITEM.COLLECTIBLE.MIME_DEGREE) then
		mod.scheduleForUpdate(function()
			sfx:Stop(SoundEffect.SOUND_ISAAC_HURT_GRUNT)
		end, 1)
		if player:GetPlayerType() == FiendFolio.PLAYER.FIEND then
			game:GetHUD():ShowItemText(mimeHurtsFiend[math.random(#mimeHurtsFiend)])
		else
			if math.random(1000) == 1 then
				game:GetHUD():ShowItemText("TABARNAK D'OSTI D'CALISSE", "DE SAINT SIBOUERE DE SACREMENT D'MAUDITE MARDE")
			else
				game:GetHUD():ShowItemText(mimeHurts[math.random(#mimeHurts)])
			end
		end
	else
		local playedCustomSound
		if Isaac.RunCallbackWithParam("FF_PLAYER_HURT_SOUND", player:GetPlayerType(), player) then
			playedCustomSound = true
		end

		if playedCustomSound then
			mod.scheduleForUpdate(function()
				sfx:Stop(SoundEffect.SOUND_ISAAC_HURT_GRUNT)
			end, 1)
		else
			if player:HasCollectible(mod.ITEM.COLLECTIBLE.SPINACH_PIE) then
				if mod:RandomInt(10) == 1 then
					sfx:Stop(SoundEffect.SOUND_ISAAC_HURT_GRUNT)
					if mod:RandomInt(2) == 0 then
						sfx:Play(SoundEffect.SOUND_ISAAC_HURT_GRUNT, 1, 0, false, mod:RandomInt(100,250)/100)
					else
						sfx:Play(SoundEffect.SOUND_ISAAC_HURT_GRUNT, 1, 0, false, mod:RandomInt(25,100)/100)
					end
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.playerDamage, 1)

function mod:playerDamageLate(entity, amount, flags, source, cooldown)
	local player = entity:ToPlayer()
	mod:erflyPlayerHurtLate(player, amount, flags, source, cooldown)
end
mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.LATE, mod.playerDamageLate, 1)


--Effect related (in cases of overriding stuff)

function mod:checkDirtPile(e)
	local subt = e.SubType
	local d = mod:GetEntityData(e)
	if d.WeaverPile then
		mod:weaverDirtPileOpeningAI(e)
	elseif d.KingpinPile then
		mod:kingpinDirtPileAI(e)
	end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.checkDirtPile, 146)

function mod:checkBlackCreep(e)
local subt = e.SubType
	if subt == 980 then
		mod:borisCreepPool(e)
	elseif subt == 7000 then
		mod:AshCreepAI(e)
	elseif subt == 7001 then
		mod:gunpowderCreepAI(e)
	elseif subt == 7002 then
		mod:weaverDirtPileAI(e)
	end

	local d = mod:GetEntityData(e)
	if d.DangerousToFeetsies then
		for _, player in pairs(Isaac.FindInRadius(e.Position, 40, EntityPartition.PLAYER)) do
			player = player:ToPlayer()
			if not (player:HasCollectible(CollectibleType.COLLECTIBLE_SOCKS) or player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_HEELS) or player:HasCollectible(mod.ITEM.COLLECTIBLE.BEE_SKIN) or player:HasTrinket(TrinketType.TRINKET_CALLUS) or player.CanFly) then
				mod:GetEntityData(player).BleedyFeetsies = 50
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.checkBlackCreep, 26)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.checkBlackCreep, 45)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.checkBlackCreep, 7000)

function mod:checkRedCandle(e)
	if e.SubType == 960 then
		local d = mod:GetEntityData(e)
		local fc = e.FrameCount
		local timer = d.timer or 120
		if fc < 5 then
			e.SpriteScale = Vector(fc/5, fc/5)
		elseif fc > timer then
			e.SpriteScale = e.SpriteScale * 0.9
			if e.SpriteScale.X < 0.1 then
				e:Remove()
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.checkRedCandle, 51)

--Find color info
--[[function mod:checkSplatCol(npc)
	Isaac.ConsoleOutput("R" .. npc.SplatColor.R .. "\n")
	Isaac.ConsoleOutput("G" .. npc.SplatColor.G .. "\n")
	Isaac.ConsoleOutput("B" .. npc.SplatColor.B .. "\n")
	Isaac.ConsoleOutput("A" .. npc.SplatColor.A .. "\n")
	Isaac.ConsoleOutput("RO" .. npc.SplatColor.RO .. "\n")
	Isaac.ConsoleOutput("GO" .. npc.SplatColor.GO .. "\n")
	Isaac.ConsoleOutput("BO" .. npc.SplatColor.BO .. "\n")
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkSplatCol, 219)]]

function mod.GetPlayerIndex(player)
	local idx = 0
	for i = 1, game:GetNumPlayers() do
		local p = Isaac.GetPlayer(i - 1)
		if p and GetPtrHash(p) == GetPtrHash(player) then
			idx = i
			break
		end
	end
	return idx
end

function mod.AnyPlayerDo(foo)
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		foo(player)
	end
end

local cachedAnyPlayerHas = {}
function mod.anyPlayerHas(itemid, trinket, mombox, useCached, returnPlayer)
	local k = itemid
	if trinket then
		k = k .. " t"
	else
		k = k .. " f"
	end
	if mombox then
		k = k .. " t"
	else
		k = k .. " f"
	end
	if useCached and cachedAnyPlayerHas[k] then
		return cachedAnyPlayerHas[k]
	end

	for i = 1, game:GetNumPlayers() do
		local p = Isaac.GetPlayer(i - 1)
		if trinket then
			if mombox then
				if p:HasTrinket(itemid) and p:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) then
					cachedAnyPlayerHas[k] = true
					if returnPlayer then
						return p
					else
						return true
					end
				end
			else
				if p:HasTrinket(itemid) then
					cachedAnyPlayerHas[k] = true
					if returnPlayer then
						return p
					else
						return true
					end
				end
			end
		else
			if p:HasCollectible(itemid) then
				cachedAnyPlayerHas[k] = true
				if returnPlayer then
					return p
				else
					return true
				end
			end
		end
	end
	cachedAnyPlayerHas[k] = false
end

mod:AddPriorityCallback(ModCallbacks.MC_POST_UPDATE, math.huge, function()
	cachedAnyPlayerHas = {}
end)

function mod.phdPlayer()
	for i = 1, game:GetNumPlayers() do
		local p = Isaac.GetPlayer(i - 1)
		if p:HasCollectible(CollectibleType.COLLECTIBLE_PHD) then
			return p
		end
	end
end
function mod.goodPillPlayer()
	for i = 1, game:GetNumPlayers() do
		local p = Isaac.GetPlayer(i - 1)
		if p:HasCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT) or p:HasCollectible(CollectibleType.COLLECTIBLE_VIRGO) then
			return p
		end
	end
end
function mod.falsephdPlayer()
	for i = 1, game:GetNumPlayers() do
		local p = Isaac.GetPlayer(i - 1)
		if p:HasCollectible(CollectibleType.COLLECTIBLE_FALSE_PHD) then
			return p
		end
	end
end

function mod.getTrinketMultiplierAcrossAllPlayers(trinketid)
	local totalMult = 0
	for i = 1, game:GetNumPlayers() do
		local p = Isaac.GetPlayer(i - 1)
		totalMult = totalMult + p:GetTrinketMultiplier(trinketid)
	end
	return totalMult
end

function mod.getCollectibleMultiplierAcrossAllPlayers(collectibleid, trueCopies)
	local totalMult = 0
	trueCopies = trueCopies or false
	for i = 1, game:GetNumPlayers() do
		local p = Isaac.GetPlayer(i - 1)
		totalMult = totalMult + p:GetCollectibleNum(collectibleid, trueCopies)
	end
	return totalMult
end

function mod.getTrinketMultiplierOfPlayerWithTrinket(multiId, hasId)
	local maxMulti = 0
	for i = 1, game:GetNumPlayers() do
		local p = Isaac.GetPlayer(i - 1)
		if p:HasTrinket(hasId) then
			maxMulti = math.max(maxMulti, p:GetTrinketMultiplier(multiId))
		end
	end
	return maxMulti
end

function mod.isAnyoneCharacter(characterID)
	for i = 1, game:GetNumPlayers() do
		local p = Isaac.GetPlayer(i - 1)
		if p:GetPlayerType() == characterID then
			return true
		end
	end
end

function mod.slowestPlayerSpeed(capMin, capMax)
	capMin = capMin or 0.1
	local movespeed = capMax or 2
	for i = 1, game:GetNumPlayers() do
		local p = Isaac.GetPlayer(i - 1)
		if p.MoveSpeed < movespeed then
			movespeed = p.MoveSpeed
		end
	end
	return math.max(capMin, movespeed)
end

function mod:playerIsBelialMode(player)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and
	(player:GetPlayerType() == PlayerType.PLAYER_JUDAS or player:GetPlayerType() == PlayerType.PLAYER_BLACKJUDAS) then
		return true
	end
end

local cursedPennyRng = RNG()
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	if pickup.SubType ~= mod.PICKUP.COIN.CURSED and pickup.SubType ~= 216 then return end

	local sprite = pickup:GetSprite()
	if sprite:IsEventTriggered("DropSound") then
		if pickup.SubType == 216 then
			sfx:Play(SoundEffect.SOUND_DIMEDROP, 1, 0, false, 1)
		end
		sfx:Play(SoundEffect.SOUND_PENNYDROP, 1, 0, false, 1.0)
	end
end, PickupVariant.PICKUP_COIN)

function mod:AddCursedPennyStats(player)
	local data = mod:GetEntityData(player)
	--data.ffsavedata.CursedPennyStats = (data.ffsavedata.CursedPennyStats or 0) + 1
	player:AddNullItemEffect(mod.ITEM.NULL.CURSED_PENNY_ALL_STATS, false)
	player:AddCacheFlags(CacheFlag.CACHE_ALL)
	player:EvaluateItems()
end

function mod:cursedPennyCollide(pickup, opp, low)
	if pickup.SubType == mod.PICKUP.COIN.CURSED or pickup.SubType == 216 then
	else return end

	if opp:ToPlayer() or
	   (opp:ToFamiliar() and (opp.Variant == FamiliarVariant.BUM_FRIEND or
							  opp.Variant == FamiliarVariant.BUMBO or
							  opp.Variant == FamiliarVariant.SUPER_BUM))
	then
		local sprite = pickup:GetSprite()
		if not (sprite:WasEventTriggered("DropSound") or sprite:IsPlaying("Idle")) then
			return false
		end

		cursedPennyRng:SetSeed(pickup.DropSeed, 0)
		local odds = cursedPennyRng:RandomInt(200)

		local player = opp:ToPlayer()
		local familiar = opp:ToFamiliar()

		if player then
			if not player:HasCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
				if player:HasTrinket(TrinketType.TRINKET_CURSED_PENNY) and player:GetTrinketRNG(TrinketType.TRINKET_CURSED_PENNY):RandomInt(13) ~= 0 then
					pickup.Position = mod:FindRandomFreePos(pickup) + (RandomVector() * cursedPennyRng:RandomInt(20))
					pickup:SetColor(Color(1,1,1,1,1,1,1), 5, 10, true, false)
					sfx:Play(SoundEffect.SOUND_HELL_PORTAL1, 1, 0, false, math.random(120,150)/100)
					return true
				end
			end

			if mod.CanRunUnlockAchievements() then
				mod.savedata.cursedPennyPickups = mod.savedata.cursedPennyPickups + 1
				if not FiendFolio.ACHIEVEMENT.GOLDEN_CURSED_PENNY:IsUnlocked(true) and mod.savedata.cursedPennyPickups >= 50 then
					FiendFolio.ACHIEVEMENT.GOLDEN_CURSED_PENNY:Unlock()
				end
			end
		end

		if odds < 60 then
			-- 30% - remove 1 coin
			if player then
				player:AddCoins(-1)
				mod:triggerPennyPickup(player, pickup, 0.5, -1)
			elseif familiar then
				familiar.Coins = math.max(familiar.Coins - 1, 0)
			end
			sfx:Play(mod.Sounds.CursedPennyNegative, 1, 0, false, 1)
			mod:AddSamaelAngerBonus(0.05)
		elseif odds < 120 then
			-- 30% - grant 1 coin
			if player then
				player:AddCoins(1)
				mod:triggerPennyPickup(player, pickup, 1)
			elseif familiar then
				familiar.Coins = familiar.Coins + 1
			end
			sfx:Play(SoundEffect.SOUND_PENNYPICKUP, 1, 0, false, 1)
		elseif odds < 160 then
			-- 20% - grant 2 coins
			if player then
				player:AddCoins(2)
				mod:triggerPennyPickup(player, pickup, 2)
			elseif familiar then
				familiar.Coins = familiar.Coins + 2
			end
			sfx:Play(mod.Sounds.CursedPennyPositive, 1, 0, false, 1)
		elseif odds < 180 then
			-- 10% -removes -2 coins
			if player then
				player:AddCoins(-2)
				mod:triggerPennyPickup(player, pickup, 0.25, -2)
			elseif familiar then
				familiar.Coins = math.max(familiar.Coins - 2, 0)
			end
			sfx:Play(mod.Sounds.CursedPennyNegativeSuper, 1, 0, false, 1)
			--sfx:Play(SoundEffect.SOUND_BROWNIE_LAUGH, 1, 0, false, 1.3)
			game:Fart(pickup.Position, 40, pickup, 1, 0)
			mod:AddSamaelAngerBonus(0.1)
		elseif odds < 190 then
			-- 5% - grant 1 luck and 1 coin
			if player then
				player:AddCoins(1)
				player:DonateLuck(1)
				player:AnimateHappy()
				mod:triggerPennyPickup(player, pickup, 5, 1)
			elseif familiar then
				familiar.Coins = familiar.Coins + 1
			end
			sfx:Play(mod.Sounds.CursedPennyPositiveSuper, 1, 0, false, 1)
		elseif odds < 195 then
			-- 2.5% - explode and hurt the player and remove 1 coin
			if player then
				player:AddCoins(-1)
				player:AnimateSad()
				mod:triggerPennyPickup(player, pickup, 0.1, -1)

				if not FiendFolio.ACHIEVEMENT.EVIL_STICKER:IsUnlocked(true) then
					FiendFolio.ACHIEVEMENT.EVIL_STICKER:Unlock()
				end
			elseif familiar then
				familiar.Coins = math.max(familiar.Coins - 1, 0)
			end
			if player and player:HasTrinket(TrinketType.TRINKET_CURSED_PENNY) and not player:HasCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
				local bomb = Isaac.Spawn(4, 17, BombSubType.BOMB_GIGA, player.Position, nilvector, player):ToBomb()
				bomb:SetExplosionCountdown(0)
				bomb:Update()
			else
				Isaac.Explode(pickup.Position, nil, 40)
			end
			sfx:Play(mod.Sounds.CursedPennyNegativeMega, 1, 0, false, 1)
			mod:AddSamaelAngerBonus(0.25)
		elseif odds < 198 then
			-- 1.5% - grant a very minor all stats up and 1 coin
			if player then
				player:AddCoins(1)
				mod:AddCursedPennyStats(player)
				player:AnimateHappy()
				mod:triggerPennyPickup(player, pickup, 10, 1)

				if not FiendFolio.ACHIEVEMENT.FOOLS_GOLD_HEART:IsUnlocked(true) then
					FiendFolio.ACHIEVEMENT.FOOLS_GOLD_HEART:Unlock()
				end
			elseif familiar then
				familiar.Coins = familiar.Coins + 1
			end
			sfx:Play(mod.Sounds.CursedPennyPositiveMega, 1, 0, false, 1)
		else
			-- 1% - does nothing
			sfx:Play(mod.Sounds.CursedPennyNeutral, 1, 0, false, 1)
			if player then
				mod:triggerPennyPickup(player, pickup, 0.75, 0)
			end
		end

		if pickup.OptionsPickupIndex ~= 0 then
			local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP)
			for _, entity in ipairs(pickups) do
				if entity:ToPickup().OptionsPickupIndex == pickup.OptionsPickupIndex and
				   (entity.Index ~= pickup.Index or entity.InitSeed ~= pickup.InitSeed)
				then
					Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, nilvector, nil)
					entity:Remove()
				end
			end
		end

		pickup.Velocity = nilvector
		pickup.Touched = true
		pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		sprite:Play("Collect", true)
		if pickup.SubType == 216 and cursedPennyRng:RandomInt(10) < 9 then
			local gold = Isaac.Spawn(5, 20, 216, mod:FindRandomFreePos(pickup), Vector.Zero, pickup)
			gold:GetSprite():Play("Reappear", true)
		end
		pickup:Die()

		Game():SetStateFlag(GameStateFlag.STATE_HEART_BOMB_COIN_PICKED, true)

		Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, opp, low)
		return true
	elseif opp.Type == EntityType.ENTITY_ULTRA_GREED or
		   opp.Type == EntityType.ENTITY_BUMBINO
	then
		cursedPennyRng:SetSeed(pickup.DropSeed, 0)
		if pickup.SubType == 216 and cursedPennyRng:RandomInt(10) < 9 then
			local gold = Isaac.Spawn(5, 20, 216, mod:FindRandomFreePos(pickup), Vector.Zero, pickup)
			gold:GetSprite():Play("Reappear", true)
		end
		pickup.SubType = 1
		return
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.cursedPennyCollide, 20)

--Haunted Penny
function mod:hauntedPennyCollide(pickup, opp, low)
	if pickup.SubType ~= mod.PICKUP.COIN.HAUNTED then return end

	if opp:ToPlayer() or
	   (opp:ToFamiliar() and (opp.Variant == FamiliarVariant.BUM_FRIEND or
							  opp.Variant == FamiliarVariant.BUMBO or
							  opp.Variant == FamiliarVariant.SUPER_BUM))
	then
		local sprite = pickup:GetSprite()
		if not (sprite:WasEventTriggered("DropSound") or sprite:IsPlaying("Idle")) then
			return false
		end

		local player = opp:ToPlayer()
		local familiar = opp:ToFamiliar()

		if player then
			player:AddCoins(1)
			player:AddWisp(0, player.Position, true)
			mod:triggerPennyPickup(player, pickup, 1)

			if mod.CanRunUnlockAchievements() then
				mod.savedata.hauntedPennyPickups = mod.savedata.hauntedPennyPickups + 1
				if not FiendFolio.ACHIEVEMENT.PLANCHETTE:IsUnlocked(true) and mod.savedata.hauntedPennyPickups >= 15 then
					FiendFolio.ACHIEVEMENT.PLANCHETTE:Unlock()
				end
			end
		elseif familiar then
			familiar.Coins = familiar.Coins + 1
		end
		sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT, 1, 0, false, 1)
		sfx:Play(SoundEffect.SOUND_SOUL_PICKUP, 1.3, 0, false, 1)

		if pickup.OptionsPickupIndex ~= 0 then
			local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP)
			for _, entity in ipairs(pickups) do
				if entity:ToPickup().OptionsPickupIndex == pickup.OptionsPickupIndex and
				   (entity.Index ~= pickup.Index or entity.InitSeed ~= pickup.InitSeed)
				then
					Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, nilvector, nil)
					entity:Remove()
				end
			end
		end

		pickup.Velocity = nilvector
		pickup.Touched = true
		pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		sprite:Play("Collect", true)
		pickup:Die()

		Game():SetStateFlag(GameStateFlag.STATE_HEART_BOMB_COIN_PICKED, true)

		Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, opp, low)
		return true
	elseif opp.Type == EntityType.ENTITY_ULTRA_GREED or
		   opp.Type == EntityType.ENTITY_BUMBINO
	then
		pickup.SubType = 1
		return
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.hauntedPennyCollide, 20)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	if pickup.SubType == 214 then
		if pickup:GetSprite():IsEventTriggered("DropSound") then
			sfx:Play(SoundEffect.SOUND_PENNYDROP, 1, 0, false, 1)
		end
	end
end, 20)

local FFSpicyKeys = {
	[FiendFolio.PICKUP.KEY.SPICY] = true,
	[FiendFolio.PICKUP.KEY.SUPERSPICY] = true,
	[FiendFolio.PICKUP.KEY.CHARGEDSPICY] = true,
	[FiendFolio.PICKUP.KEY.SPICY_BOX] = true,
	[FiendFolio.PICKUP.KEY.SUPERSPICY_BOX] = true,
	[FiendFolio.PICKUP.KEY.CHARGEDSPICY_BOX] = true,
	[FiendFolio.PICKUP.KEY.SPICY_PERM] = true,
	[FiendFolio.PICKUP.KEY.SUPERSPICY_PERM] = true,
	[FiendFolio.PICKUP.KEY.CHARGEDSPICY_PERM] = true,
}

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider)
	if not FFSpicyKeys[pickup.SubType] then return end
	--if mod:EpiphanyPickupCheck(pickup, collider) then return end
	if mod:pickupShopCheck(pickup, collider) then return end
	if pickup.SubType == mod.PICKUP.KEY.SPICY or pickup.SubType == mod.PICKUP.KEY.SPICY_PERM then
		if collider.Type == 1 then
			collider = collider:ToPlayer()
			if pickup:GetSprite():WasEventTriggered("DropSound") or pickup:GetSprite():IsPlaying("Idle") then
				pickup:GetSprite():Play("Collect")
				pickup:Die()
				sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS, 1, 0, false, 1)
				collider:AddKeys(2)
				collider:TakeDamage(1, DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_FIRE, EntityRef(pickup), 30)

				if pickup.OptionsPickupIndex ~= 0 then
					local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP)
					for _, entity in ipairs(pickups) do
						if entity:ToPickup().OptionsPickupIndex == pickup.OptionsPickupIndex and
						   (entity.Index ~= pickup.Index or entity.InitSeed ~= pickup.InitSeed)
						then
							Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, nilvector, nil)
							entity:Remove()
						end
					end
				end

				pickup.EntityCollisionClass = 0
				if pickup:IsShopItem() then
					pickup:Remove()
				end
				return true
			end
		elseif collider.Type == 3 and (collider.Variant == FamiliarVariant.KEY_BUM or collider.Variant == FamiliarVariant.SUPER_BUM) then
			collider = collider:ToFamiliar()
			if pickup:GetSprite():WasEventTriggered("DropSound") or pickup:GetSprite():IsPlaying("Idle") then
				pickup:GetSprite():Play("Collect")
				pickup:Die()
				sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS, 1, 0, false, 1)
				collider.Keys = collider.Keys + 2

				if pickup.OptionsPickupIndex ~= 0 then
					local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP)
					for _, entity in ipairs(pickups) do
						if entity:ToPickup().OptionsPickupIndex == pickup.OptionsPickupIndex and
						   (entity.Index ~= pickup.Index or entity.InitSeed ~= pickup.InitSeed)
						then
							Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, nilvector, nil)
							entity:Remove()
						end
					end
				end

				pickup.EntityCollisionClass = 0
				return true
			end
		end
	elseif pickup.SubType == mod.PICKUP.KEY.SUPERSPICY or pickup.SubType == mod.PICKUP.KEY.SUPERSPICY_PERM then
		if collider.Type == 1 then
			collider = collider:ToPlayer()
			if pickup:GetSprite():WasEventTriggered("DropSound") or pickup:GetSprite():IsPlaying("Idle") then
				pickup:GetSprite():Play("Collect")
				pickup:Die()
				sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS, 1, 0, false, 1)
				collider:AddKeys(3)
				collider:TakeDamage(1, DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_FIRE, EntityRef(pickup), 30)

				if pickup.OptionsPickupIndex ~= 0 then
					local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP)
					for _, entity in ipairs(pickups) do
						if entity:ToPickup().OptionsPickupIndex == pickup.OptionsPickupIndex and
						   (entity.Index ~= pickup.Index or entity.InitSeed ~= pickup.InitSeed)
						then
							Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, nilvector, nil)
							entity:Remove()
						end
					end
				end

				pickup.EntityCollisionClass = 0
				if pickup:IsShopItem() then
					pickup:Remove()
				end
				return true
			end
		elseif collider.Type == 3 and (collider.Variant == FamiliarVariant.KEY_BUM or collider.Variant == FamiliarVariant.SUPER_BUM) then
			collider = collider:ToFamiliar()
			if pickup:GetSprite():WasEventTriggered("DropSound") or pickup:GetSprite():IsPlaying("Idle") then
				pickup:GetSprite():Play("Collect")
				pickup:Die()
				sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS, 1, 0, false, 1)
				collider.Keys = collider.Keys + 3

				if pickup.OptionsPickupIndex ~= 0 then
					local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP)
					for _, entity in ipairs(pickups) do
						if entity:ToPickup().OptionsPickupIndex == pickup.OptionsPickupIndex and
						   (entity.Index ~= pickup.Index or entity.InitSeed ~= pickup.InitSeed)
						then
							Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, nilvector, nil)
							entity:Remove()
						end
					end
				end

				pickup.EntityCollisionClass = 0
				return true
			end
		end
	elseif pickup.SubType == mod.PICKUP.KEY.CHARGEDSPICY or pickup.SubType == mod.PICKUP.KEY.CHARGEDSPICY_PERM then
		if collider.Type == 1 then
			collider = collider:ToPlayer()
			if pickup:GetSprite():WasEventTriggered("DropSound") or pickup:GetSprite():IsPlaying("Idle") then
				pickup:GetSprite():Play("Collect")
				pickup:Die()
				sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS, 1, 0, false, 1)
				collider:AddKeys(2)
				collider:FullCharge()
				collider:TakeDamage(1, DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_FIRE, EntityRef(pickup), 30)

				if pickup.OptionsPickupIndex ~= 0 then
					local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP)
					for _, entity in ipairs(pickups) do
						if entity:ToPickup().OptionsPickupIndex == pickup.OptionsPickupIndex and
						   (entity.Index ~= pickup.Index or entity.InitSeed ~= pickup.InitSeed)
						then
							Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, nilvector, nil)
							entity:Remove()
						end
					end
				end

				pickup.EntityCollisionClass = 0
				if pickup:IsShopItem() then
					pickup:Remove()
				end
				return true
			end
		elseif collider.Type == 3 and (collider.Variant == FamiliarVariant.KEY_BUM or collider.Variant == FamiliarVariant.SUPER_BUM) then
			collider = collider:ToFamiliar()
			if pickup:GetSprite():WasEventTriggered("DropSound") or pickup:GetSprite():IsPlaying("Idle") then
				Isaac.Spawn(5,PickupVariant.PICKUP_LIL_BATTERY,1,pickup.Position,Vector.Zero,nil)
				pickup:GetSprite():Play("Collect")
				pickup:Die()
				sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS, 1, 0, false, 1)
				collider.Keys = collider.Keys + 2

				if pickup.OptionsPickupIndex ~= 0 then
					local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP)
					for _, entity in ipairs(pickups) do
						if entity:ToPickup().OptionsPickupIndex == pickup.OptionsPickupIndex and
						   (entity.Index ~= pickup.Index or entity.InitSeed ~= pickup.InitSeed)
						then
							Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, nilvector, nil)
							entity:Remove()
						end
					end
				end

				pickup.EntityCollisionClass = 0
				return true
			end
		end
	elseif pickup.SubType == mod.PICKUP.KEY.SPICY_BOX then
		if collider.Type == 1 then
			collider = collider:ToPlayer()
			if pickup:GetSprite():WasEventTriggered("DropSound") or pickup:GetSprite():IsPlaying("Idle") then
				pickup:GetSprite():Play("Collect")
				pickup:Die()
				sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS, 1, 0, false, 0.8)
				collider:AddKeys(3)
				collider:TakeDamage(2, DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_FIRE, EntityRef(pickup), 30)

				if pickup.OptionsPickupIndex ~= 0 then
					local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP)
					for _, entity in ipairs(pickups) do
						if entity:ToPickup().OptionsPickupIndex == pickup.OptionsPickupIndex and
						   (entity.Index ~= pickup.Index or entity.InitSeed ~= pickup.InitSeed)
						then
							Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, nilvector, nil)
							entity:Remove()
						end
					end
				end

				pickup.EntityCollisionClass = 0
				if pickup:IsShopItem() then
					pickup:Remove()
				end
				return true
			end
		elseif collider.Type == 3 and (collider.Variant == FamiliarVariant.KEY_BUM or collider.Variant == FamiliarVariant.SUPER_BUM) then
			collider = collider:ToFamiliar()
			if pickup:GetSprite():WasEventTriggered("DropSound") or pickup:GetSprite():IsPlaying("Idle") then
				pickup:GetSprite():Play("Collect")
				pickup:Die()
				sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS, 1, 0, false, 1)
				collider.Keys = collider.Keys + 3

				if pickup.OptionsPickupIndex ~= 0 then
					local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP)
					for _, entity in ipairs(pickups) do
						if entity:ToPickup().OptionsPickupIndex == pickup.OptionsPickupIndex and
						   (entity.Index ~= pickup.Index or entity.InitSeed ~= pickup.InitSeed)
						then
							Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, nilvector, nil)
							entity:Remove()
						end
					end
				end

				pickup.EntityCollisionClass = 0
				return true
			end
		end
	elseif pickup.SubType == mod.PICKUP.KEY.SUPERSPICY_BOX then
		if collider.Type == 1 then
			collider = collider:ToPlayer()
			if pickup:GetSprite():WasEventTriggered("DropSound") or pickup:GetSprite():IsPlaying("Idle") then
				pickup:GetSprite():Play("Collect")
				pickup:Die()
				sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS, 1, 0, false, 0.8)
				collider:AddKeys(4)
				collider:TakeDamage(2, DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_FIRE, EntityRef(pickup), 30)

				if pickup.OptionsPickupIndex ~= 0 then
					local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP)
					for _, entity in ipairs(pickups) do
						if entity:ToPickup().OptionsPickupIndex == pickup.OptionsPickupIndex and
						   (entity.Index ~= pickup.Index or entity.InitSeed ~= pickup.InitSeed)
						then
							Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, nilvector, nil)
							entity:Remove()
						end
					end
				end

				pickup.EntityCollisionClass = 0
				if pickup:IsShopItem() then
					pickup:Remove()
				end
				return true
			end
		elseif collider.Type == 3 and (collider.Variant == FamiliarVariant.KEY_BUM or collider.Variant == FamiliarVariant.SUPER_BUM) then
			collider = collider:ToFamiliar()
			if pickup:GetSprite():WasEventTriggered("DropSound") or pickup:GetSprite():IsPlaying("Idle") then
				pickup:GetSprite():Play("Collect")
				pickup:Die()
				sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS, 1, 0, false, 1)
				collider.Keys = collider.Keys + 4

				if pickup.OptionsPickupIndex ~= 0 then
					local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP)
					for _, entity in ipairs(pickups) do
						if entity:ToPickup().OptionsPickupIndex == pickup.OptionsPickupIndex and
						   (entity.Index ~= pickup.Index or entity.InitSeed ~= pickup.InitSeed)
						then
							Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, nilvector, nil)
							entity:Remove()
						end
					end
				end

				pickup.EntityCollisionClass = 0
				return true
			end
		end
	elseif pickup.SubType == mod.PICKUP.KEY.CHARGEDSPICY_BOX then
		if collider.Type == 1 then
			collider = collider:ToPlayer()
			if pickup:GetSprite():WasEventTriggered("DropSound") or pickup:GetSprite():IsPlaying("Idle") then
				pickup:GetSprite():Play("Collect")
				pickup:Die()
				sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS, 1, 0, false, 0.8)
				collider:AddKeys(3)
				collider:FullCharge()
				collider:TakeDamage(2, DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_FIRE, EntityRef(pickup), 30)

				if pickup.OptionsPickupIndex ~= 0 then
					local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP)
					for _, entity in ipairs(pickups) do
						if entity:ToPickup().OptionsPickupIndex == pickup.OptionsPickupIndex and
						   (entity.Index ~= pickup.Index or entity.InitSeed ~= pickup.InitSeed)
						then
							Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, nilvector, nil)
							entity:Remove()
						end
					end
				end

				pickup.EntityCollisionClass = 0
				if pickup:IsShopItem() then
					pickup:Remove()
				end
				return true
			end
		elseif collider.Type == 3 and (collider.Variant == FamiliarVariant.KEY_BUM or collider.Variant == FamiliarVariant.SUPER_BUM) then
			collider = collider:ToFamiliar()
			if pickup:GetSprite():WasEventTriggered("DropSound") or pickup:GetSprite():IsPlaying("Idle") then
				Isaac.Spawn(5,PickupVariant.PICKUP_LIL_BATTERY,1,pickup.Position,Vector.Zero,nil)
				pickup:GetSprite():Play("Collect")
				pickup:Die()
				sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS, 1, 0, false, 1)
				collider.Keys = collider.Keys + 3

				if pickup.OptionsPickupIndex ~= 0 then
					local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP)
					for _, entity in ipairs(pickups) do
						if entity:ToPickup().OptionsPickupIndex == pickup.OptionsPickupIndex and
						   (entity.Index ~= pickup.Index or entity.InitSeed ~= pickup.InitSeed)
						then
							Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, nilvector, nil)
							entity:Remove()
						end
					end
				end

				pickup.EntityCollisionClass = 0
				return true
			end
		end
	end
end, PickupVariant.PICKUP_KEY)

mod.WoodenBackdrops = {
	[BackdropType.CELLAR] = true,
	[BackdropType.BURNT_BASEMENT] = true,
	[BackdropType.LIBRARY] = true,
	[BackdropType.SHOP] = true,
	[BackdropType.ISAAC] = true,
	[BackdropType.BARREN] = true,
	[BackdropType.ARCADE] = true,
	[BackdropType.GREED_SHOP] = true,
	[BackdropType.DOWNPOUR] = true,
	[BackdropType.DOWNPOUR_ENTRANCE] = true,
	[BackdropType.ISAACS_BEDROOM] = true,
	[BackdropType.HALLWAY] = true,
	[BackdropType.MOMS_BEDROOM] = true,
	[BackdropType.CLOSET] = true,
	[BackdropType.CLOSET_B] = true,
	[BackdropType.DOGMA] = true,
	[BackdropType.DARK_CLOSET] = true,
}

mod.PipeBackdrops = {
	[BackdropType.DROSS] = true,
}

mod.fireTypes = {
{10, 2},		--Flaming Gaper
{15, 3},		--Grilled Clotty
{54, 0},		--Flaming Hopper
{160, 442},		--Flamin
{160, 443},		--Flamin Chain
{208, 2},		--Flaming Fatty
{226, 2},		--Crispy
{824, 1},		--Grilled Gyro
{1000, 1},		--Bomb explosion
{1000, 51, 1},	--Fatty Fire
{1000, 147},	--Fire Jet
{1000, 148},	--Fire Wave
{1000, 7005},	--Gunpowder fire
{1000, 7012},	--Evil Explosion
{1000, 7015},	--Fiend fire
{mod.FF.Litling.ID, mod.FF.Litling.Var}, --Litling
{mod.FF.Chili.ID, mod.FF.Chili.Var}, --Chili
{mod.FF.TrailblazerFlameSegment.ID, mod.FF.TrailblazerFlameSegment.Var, mod.FF.TrailblazerFlameSegment.Sub}, --Trailblazer
{9,2}, --Flame Projectile
}
mod.specialFireTypes = {
{mod.FF.Spark.ID, mod.FF.Spark.Var},			--Spark
{mod.FF.Fumegeist.ID, mod.FF.Fumegeist.Var},	--Fumegeist
{mod.FF.Mote.ID, mod.FF.Mote.Var},				--Mote
{mod.FF.Smokin.ID, mod.FF.Smokin.Var},			--Smokin
{mod.FF.Smogger.ID, mod.FF.Smogger.Var},		--Smogger
}
mod.playerFireTypes = {
{1000, 51},
{1000, 52},
{3, 231, mod.ITEM.COLLECTIBLE.MODERN_OUROBOROS}
}
mod.blacklistedFlickerSpirits = {
{33},			--Fires
{965},				--Minecart
{mod.FF.Flickerspirit.ID, mod.FF.Flickerspirit.Var},		--Flickerspirit
{mod.FF.EternalFlickerspirit.ID, mod.FF.EternalFlickerspirit.Var},		--Eternal Flickerspirit
{mod.FF.Viscerspirit.ID, mod.FF.Viscerspirit.Var},      --Viscerspirit
{EntityType.ENTITY_DARK_ESAU},
{EntityType.ENTITY_FROZEN_ENEMY}, --Uranus Frozen Corpses
{mod.FF.Specturn.ID, mod.FF.Specturn.Var},      --Specturn
{mod.FF.FriendFireball.ID, mod.FF.FriendFireball.Var}, --Friend's fireball
}
mod.playerobjsFlickerSpirits = {
{35, 1},			--Maw Head
{96}			--Eternal Fly
}
mod.unaffectedFlickerSpirits = {
{35, 10},			--Maw Neck
{216, 10},			--Swinger Neck
mod.ENT("WaitingSpider"),			--Waiting Spider
mod.ENT("WaitingWorm"),			--Waiting Worm
mod.ENT("OffalWait"),		--Waiting Offal
{mod.FF.Drop.ID, mod.FF.Drop.Var},
{mod.FF.Fishface.ID, mod.FF.Fishface.Var, mod.FF.FishfaceWait.Sub},
{mod.FF.Harletwin.ID, mod.FF.Harletwin.Var, mod.FF.HarletwinCord.Sub},
{mod.FF.Effigy.ID, mod.FF.Effigy.Var, mod.FF.EffigyCord.Sub},
{mod.FF.FlaminChain.ID, mod.FF.FlaminChain.Var},
{mod.FF.Madclaw.ID, mod.FF.Madclaw.Var},
FiendFolio.ENT("BucketheadWait"),
FiendFolio.ENT("PaladinWait"),
}
mod.PlayerCreeps = {
	[EffectVariant.PLAYER_CREEP_WHITE] = true,
	[EffectVariant.PLAYER_CREEP_BLACK] = true,
	[EffectVariant.PLAYER_CREEP_RED] = true,
	[EffectVariant.PLAYER_CREEP_GREEN] = true,
	[EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL] = true,
	[EffectVariant.PLAYER_CREEP_BLACKPOWDER] = true,
}

function mod.GetRoomEntitiesCache()
	mod.RoomEntitiesCache = Isaac.GetRoomEntities()
	return mod.RoomEntitiesCache
end

function mod.GetRoomEntities()
	mod.creepSpawnerCount = {0}
	mod.countFlies = {}
	mod.fireEntities = {}
	mod.fireEntitiesFriend = {}
	mod.playerPositions = {}
	mod.playerVelocities = {}
	mod.playerCreepCount = 0

	mod.RoomEntitiesCache = nil

	local printStuff = false
	if FiendFolio.PrintEnts then
		print("___________________________")

		for _, entity in ipairs(mod.GetRoomEntitiesCache()) do
			local etype = entity.Type
			local evar = entity.Variant
			local esub = entity.SubType

			print(etype, evar, esub)
		end
	end

	local players = Isaac.FindByType(1)
	for _, entity in ipairs(players) do
		table.insert(mod.playerPositions, entity)
		table.insert(mod.playerVelocities, entity.Velocity)
	end

	if mod.FiendishEffects then
		for _,entity in ipairs(mod.GetRoomEntitiesCache()) do
			local etype = entity.Type
			local evar = entity.Variant
			local esub = entity.SubType
			if etype == 1 then
				local p = entity:ToPlayer()
				if mod.FiendishEffects.RollHealth then
					p:AddMaxHearts(math.random(3) - 2)
					if math.random(3) == 1 then
						p:AddBoneHearts(math.random(3) - 2)
					end
					p:AddHearts(math.random(3) - 2)
					p:AddRottenHearts(math.random(3) - 2)
					if math.random(2) == 1 then
						p:AddSoulHearts(math.random(3) - 2)
					end
					if math.random(2) == 1 then
						p:AddBlackHearts(math.random(3) - 2)
					end
					if math.random(5) == 1 then
						p:AddGoldenHearts(math.random(3) - 2)
					end
					if math.random(5) == 1 then
						p:AddBrokenHearts(math.random(3) - 2)
					end
				end
				if mod.FiendishEffects.RollItems and entity.FrameCount % 5 == 0 then
					player:UseActiveItem(CollectibleType.COLLECTIBLE_D4, false, false, true, false)
				end
				if mod.FiendishEffects.GetSpeedy then
					p.MoveSpeed = p.MoveSpeed + 0.01
				end
				if mod.FiendishEffects.GetShooty then
					p.MaxFireDelay = p.MaxFireDelay - 0.05
				end
				if mod.FiendishEffects.GetHurty then
					p.Damage = p.Damage + 1
				end
				if mod.FiendishEffects.LessHurty then
					p.Damage = p.Damage * 0.99
				end
				if mod.FiendishEffects.GetShootSpeedy then
					p.ShotSpeed = p.ShotSpeed + 0.05
				end
			end
			if etype ~= 1 then
				if mod.FiendishEffects.RunRound then
					entity.Velocity = RandomVector():Resized(math.random(50) - 25)
				end
				if mod.FiendishEffects.ZipZoop then
					entity.Velocity = entity.Velocity * -1
				end
				if mod.FiendishEffects.Nyoom then
					entity.Velocity = entity.Velocity * 1.1
				end
				if mod.FiendishEffects.SlowDown then
					entity.Velocity = entity.Velocity * 0.1
				end
				if mod.FiendishEffects.Funny then
					entity.Position = entity.Position + RandomVector()*math.random(100)/10
				end
				if mod.FiendishEffects.Twirly then
					entity.SpriteRotation = entity.SpriteRotation + math.random(100)
				end
				if mod.FiendishEffects.Spunky then
					entity.HitPoints = math.random(100)
				end
				if mod.FiendishEffects.Spindigo then
					grng:SetSeed(entity.InitSeed, 0)
					local rotval = grng:RandomInt(100) - 50
					entity.Velocity = entity.Velocity:Rotated(rotval)
				end
				if mod.FiendishEffects.Homer then
					entity.Velocity = mod:Lerp(entity.Velocity, (Isaac.GetPlayer(0).Position - entity.Position), 0.001)
				end
				if mod.FiendishEffects.Scared then
					entity.Velocity = mod:Lerp(entity.Velocity, (entity.Position - Isaac.GetPlayer(0).Position), 0.001)
				end
				if mod.FiendishEffects.SPEED then
					entity:Update()
				end
				if mod.FiendishEffects.FunnyPickup then
					if etype == 5 or etype == 6 then
						mod:CatheryPathFinding(entity, Isaac.GetPlayer(0).Position, {
							Speed = 2,
							Accel = 0.3
						})
					end
				end
				if mod.FiendishEffects.FunnyProjectiles then
					if etype == 9 or etype == mod.FFID.Tech or (etype == 1000 and evar == 7005) or (etype == 1000 and evar > 21 and evar < 27)then
						mod:CatheryPathFinding(entity, Isaac.GetPlayer(0).Position, {
							Speed = 10,
							Accel = 0.3
						})
					end
				end
				if mod.FiendishEffects.SizeRandomizer then
					entity.SpriteScale = Vector(math.random(100)/50, math.random(100)/50)
				end
				if mod.FiendishEffects.Pendulum then
					grng:SetSeed(entity.InitSeed, 0)
					local rotval = grng:RandomInt(100) - 50
					entity.SpriteRotation = entity.SpriteRotation + (math.sin(entity.FrameCount / 10) * rotval)
				end
				if mod.FiendishEffects.SpeedSpinUp then
					grng:SetSeed(entity.InitSeed, 0)
					local rotval = grng:RandomInt(10) - 5
					rotval = rotval * 1 + (mod.FiendishEffects.SpeedSpinUp)
					entity.SpriteRotation = entity.SpriteRotation + rotval
				end
				--entity.Friction = 1.1
			end
		end
	end

	--local snaggers = Isaac.FindByType(mod.FF.Snagger.ID)
	--for _, entity in ipairs(snaggers) do
		--[[if mod:GetEntityData(entity).batteried then
			entity:Update()
		end]]
	--end

	for _,v in ipairs(mod.creepLeavingEnemies) do
		local ents = Isaac.FindByType(v[1], v[2] or -1, v[3] or -1)
		for _, entity in ipairs(ents) do
			if not entity:IsDead() then
				table.insert(mod.creepSpawnerCount, entity)
			end
		end
	end

	for _,v in ipairs(mod.customFlies) do
		local ents = Isaac.FindByType(v[1], v[2] or -1, v[3] or -1)
		for _, entity in ipairs(ents) do
			if not (entity:IsDead() or mod:GetEntityData(entity).FFIsCircleSummon) then
				table.insert(mod.countFlies, entity)
			end
		end
	end

	local fireplaces = Isaac.FindByType(33)
	for _, entity in ipairs(fireplaces) do
		if entity.HitPoints > 1 then
			table.insert(mod.fireEntities, entity)
		end
	end

	for _,v in ipairs(mod.fireTypes) do
		local ents = Isaac.FindByType(v[1], v[2] or -1, v[3] or -1)
		for _, entity in ipairs(ents) do
			table.insert(mod.fireEntities, entity)
		end
	end

	for _,v in ipairs(mod.specialFireTypes) do
		local ents = Isaac.FindByType(v[1], v[2] or -1, v[3] or -1)
		for _, entity in ipairs(ents) do
			if mod:GetEntityData(entity).flaming then
				table.insert(mod.fireEntities, entity)
			end
		end
	end

	for _,v in ipairs(mod.playerFireTypes) do
		local ents = Isaac.FindByType(v[1], v[2] or -1, v[3] or -1)
		for _, entity in ipairs(ents) do
			table.insert(mod.fireEntitiesFriend, entity)
		end
	end

	for evar,_ in pairs(mod.PlayerCreeps) do
		mod.playerCreepCount = mod.playerCreepCount + Isaac.CountEntities(nil, 1000, evar)
	end

	if mod.FlickerspiritInRoom then
		local players = PlayerManager.GetPlayers()
		for _,entity in ipairs(mod.GetRoomEntitiesCache()) do
			if entity:IsEnemy() then
				local etype = entity.Type
				local evar = entity.Variant
				local esub = entity.SubType

				local isgood = true
				for _, v in ipairs(mod.blacklistedFlickerSpirits) do
					if v[2] then if etype == v[1] and evar == v[2] then isgood = false end
					elseif etype == v[1] then isgood = false end
				end
				if mod:GetEntityData(entity).FFIsCircleSummon then
					isgood = false
				end
				if isgood then
					for _, player in ipairs(players) do
						local held = player:GetHeldEntity()
						if held and GetPtrHash(held) == GetPtrHash(entity) then
							isgood = false
							break
						end
					end
				end
				if isgood then
					local unaffected = false
					for _, v in ipairs(mod.unaffectedFlickerSpirits) do
						if v[3] then if etype == v[1] and evar == v[2] and esub == v[3] then unaffected = true end
						elseif v[2] then if etype == v[1] and evar == v[2] then unaffected = true end
						elseif etype == v[1] then unaffected = true end
					end
					local fs = mod.FindClosestEntity(entity.Position, 150, mod.FF.Flickerspirit.ID, mod.FF.Flickerspirit.Var, nil, nil, nil, true)
					if fs then
						--entity:SetColor(Color(0.7,8,10,0.05,0,0,0), 1, 1, false, true)
						entity:SetColor(Color(1,1,1,0.15,0,400 / 255,500 / 255), 1, 3, false, true)
						local origcoll
						if not mod:GetEntityData(entity).flickerspirited or entity.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_PLAYERONLY then
							origcoll = entity.EntityCollisionClass
						end
						if not unaffected then
							entity.EntityCollisionClass = math.min(entity.EntityCollisionClass, EntityCollisionClass.ENTCOLL_PLAYERONLY)
						end
						if origcoll then
							mod:GetEntityData(entity).flickerspiritRestoreCollision = origcoll
						end
						mod:GetEntityData(entity).flickerspirited = true
					else
						local d = mod:GetEntityData(entity)
						if unaffected then
							d.flickerspirited = false
						else
							local obj = false
							for _, v in ipairs(mod.playerobjsFlickerSpirits) do
								if v[2] then if etype == v[1] and evar == v[2] then obj = true end
								elseif etype == v[1] then obj = true end
							end
							if obj then
								entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
								d.flickerspirited = false
							end

							if d.flickerspirited then
								if mod:GetEntityData(entity).flickerspiritRestoreCollision then
									entity.EntityCollisionClass = mod:GetEntityData(entity).flickerspiritRestoreCollision
								end
								d.flickerspirited = false
							end
						end
					end
				end
			end
		end
	end

	if Isaac.GetChallenge() == mod.challenges.dirtyBubble then
		local projectiles = Isaac.FindByType(9)
		for _, entity in ipairs(projectiles) do
			local entity = entity:ToProjectile()
			local ef = entity.ProjectileFlags
			if ef == ef | ProjectileFlags.SMART then
				mod.ShootBubble(entity, 4, entity.Position, entity.Velocity * 0.4)
			elseif ef == ef | ProjectileFlags.EXPLODE then
				mod.ShootBubble(entity, 6, entity.Position, entity.Velocity * 0.4)
			else
				mod.ShootBubble(entity, nil, entity.Position, entity.Velocity * 0.4)
			end
			entity:Remove()
		end

		local gunpowderFire = Isaac.FindByType(1000, 7005)
		for _, entity in ipairs(gunpowderFire) do
			mod.ShootBubble(entity, 6, entity.Position, entity.Velocity * 0.2)
			entity:Remove()
		end
	end

	if #mod.creepSpawnerCount == 0 then
		mod.creepSpawnerCount = {0}
	end
end

function mod.PlayFlySound()
	local lightning_fly_counter = 0

	if #mod.countFlies > 0 and not sfx:IsPlaying(mod.Sounds.InsectSwarmLoop) then
		sfx:Play(mod.Sounds.InsectSwarmLoop, 0.3, 0, true, 1)
	elseif #mod.countFlies == 0 then
		sfx:Stop(mod.Sounds.InsectSwarmLoop)
	end

	--[[for _,fly in pairs(mod.countFlies) do
		if fly.Type == 970 and fly.Variant == Isaac.GetEntityVariantByName("Lightning Fly") and mod:GetEntityData(fly).state == "charged" then
			lightning_fly_counter = lightning_fly_counter + 1
		end
	end

	if lightning_fly_counter > 0 and not sfx:IsPlaying(mod.Sounds.LightningFlyBuzzLoop) then
		sfx:Play(mod.Sounds.LightningFlyBuzzLoop, 0.5, 0, true, 1)
	elseif lightning_fly_counter == 0 then
		sfx:Stop(mod.Sounds.LightningFlyBuzzLoop)
	end]]
end

function mod.SuperEasyModeFun()
	if mod.ModeEnabled == 2 then
		local room = game:GetRoom()
		if room:GetType() == RoomType.ROOM_BOSS then
			if room:IsClear() then
				local size = room:GetGridSize()
				for i=0, size do
					local gridEntity = room:GetGridEntity(i)
					if gridEntity then
						local desc = gridEntity.Desc.Type
						if gridEntity.Desc.Type == GridEntityType.GRID_TRAPDOOR then
							local gridpos = room:GetGridPosition(i)
							Isaac.Spawn(5, 370, 0, gridpos, nilvector, nil)
							Isaac.GridSpawn(1, 0, gridpos, true)
						end
					end
				end
			end
		end
	end
end

function mod.spawnPersistents()
	local room = game:GetRoom()
	if room:IsClear() and not room:IsFirstVisit() then
		if mod.persistentTable then
			if #mod.persistentTable > 0 then
				--Isaac.ConsoleOutput(mod.persistentTable[1].Type .. mod.persistentTable[1].Variant)
				if room:IsClear() then
					--Isaac.ConsoleOutput("spawning")
					for _, entity in ipairs(mod.persistentTable) do
						local ent = Isaac.Spawn(entity.Type, entity.Variant, entity.SubType, entity.Position, nilvector, nil)
						--if entity.DontClearAppear then
							ent:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
						--end
						ent:Update()
					end
				end
			end
			mod.persistentTable = {}
		end
	else
		mod.persistentTable = {}
	end
end

function mod.challengeDadsHomePlus()
	if Isaac.GetChallenge() == mod.challenges.dadsHomePlus then
		local sd = FiendFolio.savedata.run
		local room = game:GetRoom()
		sd.challengeDadsHomePlusTable = sd.challengeDadsHomePlusTable or {}
		if #sd.challengeDadsHomePlusTable > 0 then
			for _,entity in ipairs(sd.challengeDadsHomePlusTable) do
				Isaac.Spawn(entity.Type, entity.Variant, entity.SubType, room:FindFreePickupSpawnPosition(room:GetCenterPos(), 40, true), nilvector, nil)
			end
		end
		if room:IsFirstVisit() then
			sd.challengeDadsHomePlusTable = {}
			for _,entity in ipairs(Isaac.GetRoomEntities()) do
				if entity:IsEnemy() then
					local blacklisted
					if entity.Type == 33 then
						blacklisted = true
					elseif entity.Type == 62 and entity.Parent then
						blacklisted = true
					elseif entity.Type == 13 and entity.SubType == 250 then
						blacklisted = true
					elseif entity.Type == 79 and entity.Variant == 20 then
						blacklisted = true
					elseif entity.Type == 281 and entity.Parent then
						blacklisted = true
					end
					if not blacklisted then
						table.insert(sd.challengeDadsHomePlusTable, {Type = entity.Type, Variant = entity.Variant, SubType = entity.SubType})
					end
				end
			end
		end
	end
end

mod:AddChallengeCallback(ModCallbacks.MC_POST_CURSE_EVAL, FiendFolio.challenges.dadsHomePlus, function()
    if game.Challenge == FiendFolio.challenges.dadsHomePlus then
        return 0
    end
end)

function mod.challengeTheRealJon()
	if Isaac.GetChallenge() == mod.challenges.theRealJon then
		local jons = {}
		for _,entity in ipairs(Isaac.FindByType(mod.FF.LilJon.ID, mod.FF.LilJon.Var, 1, false, false)) do
			table.insert(jons, entity)
		end
		if #jons < 1 then
			local entity = Isaac.Spawn(mod.FF.LilJon.ID, mod.FF.LilJon.Var, 1, Game():GetRoom():GetCenterPos(), nilvector, nil)
		end
	end
end

--DO NOT UNCOMMENT OUT REPETE!! playtesters complained about sickness and "black spots" after playing the game. someone please test it, i'm really busy
--[[function mod.challengeRePete()
	if Isaac.GetChallenge() == mod.challenges.RePete then
		if not mod.ActivatedPete then
			--First checks player (actual) location

			local realPos = game:ScreenToRealPos(Vector(10, 0))
			local searchRadius = 250 * 10 --based on average house size
			local playerDiscovered = false
			for _, player in pairs(Isaac.GetRealPlayers(realPos, searchRadius))) do
				--on location discovery
				if player and player:Exists() then
					--Just being cheeky and using the discovered player as the bool
					playerDiscovered = player
					break
				end
			end

			if playerDiscovered then
				local moveVec = playerDiscovered.Position - game:ScreenToRealPos(room:GetCenterPos()):Resized(10)
				local pete = Isaac.Spawn(mod.FF.realPete.Type, mod.FF.realPete.Variant, playerDiscovered.SubType, playerDiscovered.Position, moveVec, nil):ToReal()
				pete:Activate()
				pete:Update()
				mod.ActivatedPete = true
			end
		end
	end
end]]

--Familiars update their room clears and ignore skip card
mod:AddPriorityCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, -10, function(_, dropRNG, spawnPos)
	local room = game:GetRoom()
	spawnPos = room:FindFreePickupSpawnPosition(spawnPos, 10, true)
	mod:erflyPreSpawnAwardFamiliars(spawnPos, dropRNG)
end)

--Skip Card is special
mod:AddPriorityCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, -5, function(_, dropRNG, spawnPos)
	local room = game:GetRoom()
	if mod.SkipCardUsed then
		mod.SkipCardUsed = nil
		if room:IsCurrentRoomLastBoss() and not game:IsGreedMode() then
			if game:GetLevel():GetStage() ~= LevelStage.STAGE7 then --Void sometimes had a trapdoor spawn???
				spawnPos = room:FindFreePickupSpawnPosition(spawnPos, 10, true)
				Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 0, spawnPos, true)
			end
		end
		return true
	end
end)

--Anything that drops alongside room rewards (eg. Cyanide pills)
mod:AddPriorityCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, -1, function(_, dropRNG, spawnPos)
	local room = game:GetRoom()
	spawnPos = room:FindFreePickupSpawnPosition(spawnPos, 10, true)
	mod:erflyPreSpawnAwardExtras(spawnPos, dropRNG)
	mod:explosiveFossilSpawn(room, spawnPos)
end)

--Anything that returns a value
mod:AddPriorityCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, 10, function(_, dropRNG, spawnPos)
	local room = game:GetRoom()
	spawnPos = room:FindFreePickupSpawnPosition(spawnPos, 10, true)

	--ROOM REWARDS
	local roomtype = room:GetType()
	if roomtype == RoomType.ROOM_DEFAULT then
		--Balanced Fossil
		local balancedFossil = nil
		for i=1, game:GetNumPlayers() do
			local p = Isaac.GetPlayer(i - 1)

			if p:HasTrinket(FiendFolio.ITEM.ROCK.BALANCED_FOSSIL) then
				local rng = p:GetTrinketRNG(FiendFolio.ITEM.ROCK.BALANCED_FOSSIL)
				local mult = math.min(0,math.floor(mod.GetGolemTrinketPower(p, FiendFolio.ITEM.ROCK.BALANCED_FOSSIL))-1)
				if rng:RandomInt(2) == 0 then
					if p:GetNumKeys() <= 0+mult then
						balancedFossil = "key"
					elseif p:GetNumBombs() <= 0+mult then
						balancedFossil = "bomb"
					elseif p:GetNumCoins() < 5+mult*5 then
						balancedFossil = "coin"
					--[[elseif p:GetHearts() < p:GetMaxHearts()/2 then
						balancedFossil = "heart"]]
					end
				end
			end
		end

		if balancedFossil then
			if balancedFossil == "key" then
				Isaac.Spawn(5, 30, 0, spawnPos, nilvector, nil)
			elseif balancedFossil == "bomb" then
				Isaac.Spawn(5, 40, 0, spawnPos, nilvector, nil)
			elseif balancedFossil == "coin" then
				Isaac.Spawn(5, 20, 0, spawnPos, nilvector, nil)
			elseif balancedFossil == "heart" then
				Isaac.Spawn(5, 10, 1, spawnPos, nilvector, nil)
			end
			Isaac.Spawn(1000, 15, 0, spawnPos, nilvector, nil)
			sfx:Play(SoundEffect.SOUND_SUMMONSOUND, 0.7, 0, false, 1)
			return true
		end

		--IOU
		local spawntrinket = false
		for i = 1, game:GetNumPlayers() do
			local p = Isaac.GetPlayer(i - 1)
			if p:HasTrinket(mod.ITEM.TRINKET.IOU) then
				local rng = p:GetTrinketRNG(mod.ITEM.TRINKET.IOU)
				local playerChance = rng:RandomInt(100)
				local startval = math.max(30, 100 - 50 * (p:GetTrinketMultiplier(mod.ITEM.TRINKET.IOU) - 1))
				--print(startval - playerChance)
				if startval - playerChance < math.max(math.min(15 + p.Luck * 2.5, 90), 5) then
					spawntrinket = true
				end
			end
		end

		if spawntrinket then
			local trinkydinky = Isaac.Spawn(5, 350, 0, spawnPos, nilvector, nil)
			return true
		end

		--Fool's Gold
		local spawnfool = false
		for i = 1, game:GetNumPlayers() do
			local p = Isaac.GetPlayer(i - 1)
			if p:HasTrinket(mod.ITEM.TRINKET.FOOLS_GOLD) then
				local startval = 15 - 5 * (p:GetTrinketMultiplier(mod.ITEM.TRINKET.FOOLS_GOLD) - 1)
				local randnum = math.floor(startval - p.Luck)
				local rng = p:GetTrinketRNG(mod.ITEM.TRINKET.FOOLS_GOLD)
				local rand = rng:RandomInt(math.max(randnum, 1))
				if rand == 0 then
					spawnfool = true
				end
			end
		end

		if spawnfool then
			local funnypenny = Isaac.Spawn(5, 20, mod.PICKUP.COIN.CURSED, spawnPos, nilvector, nil)
			return true
		end

		if mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.EVIL_STICKER) then
			local rng = Isaac.GetPlayer():GetCollectibleRNG(mod.ITEM.COLLECTIBLE.EVIL_STICKER)
			local rand = rng:RandomInt(13)
			if rand == 0 then
				local rand2 = rng:RandomInt(100)
				--1% Copper Troll Bomb
				if rand2 < 1 then
					local spawn = Isaac.Spawn(5, PickupVariant.PICKUP_BOMB, FiendFolio.PICKUP.BOMB.COPPER_TROLL, spawnPos, nilvector, nil)
					return true
				--10% Dire Chest
				elseif rand2 < 11 then
					local spawn = Isaac.Spawn(5, mod.PICKUP.VARIANT.DIRE_CHEST, 0, spawnPos, nilvector, nil)
					return true
				--13% Spicy Key
				elseif rand2 < 24 then
					local spawn = Isaac.Spawn(5, 30, mod.PICKUP.KEY.SPICY_PERM, spawnPos, nilvector, nil)
					return true
				--13% Immoral Heart
				elseif rand2 < 37 and mod.ACHIEVEMENT.IMMORAL_HEART:IsUnlocked() then
					local spawn = Isaac.Spawn(5, mod.PICKUP.VARIANT.IMMORAL_HEART, 0, spawnPos, nilvector, nil)
					return true
				--13% Copper Bomb
				elseif rand2 < 50 then
					local spawn = Isaac.Spawn(5, PickupVariant.PICKUP_BOMB, FiendFolio.PICKUP.BOMB.COPPER, spawnPos, nilvector, nil)
					return true
				--50% Cursed Penny
				else
					local spawn = Isaac.Spawn(5, 20, mod.PICKUP.COIN.CURSED, spawnPos, nilvector, nil)
					return true
				end
			end
		end

		local totalTrollChance = 0
		mod.AnyPlayerDo(function(player)
			if player:HasTrinket(FiendFolio.ITEM.ROCK.TROLLITE) then
				local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.TROLLITE)
				totalTrollChance = totalTrollChance + 10 * trinketPower
			end
		end)
		totalTrollChance = math.ceil(totalTrollChance)
		if totalTrollChance > 0 then
			local rng = Isaac.GetPlayer():GetTrinketRNG(mod.ITEM.ROCK.TROLLITE)
			if rng:RandomInt(100) < totalTrollChance then
				local rand = rng:RandomInt(20)
				if rand == 0 then
					--Golden troll
					local spawn = Isaac.Spawn(4, 18, 0, spawnPos, nilvector, nil)
					return true
				elseif rand < 3 then
					--Copper troll
					local spawn = Isaac.Spawn(4, 3, 160, spawnPos, nilvector, nil)
					return true
				elseif rand < 8 then
					--Mega troll
					local spawn = Isaac.Spawn(4, 4, 0, spawnPos, nilvector, nil)
					return true
				else
					--Troll
					local spawn = Isaac.Spawn(4, 3, 0, spawnPos, nilvector, nil)
					return true
				end
			end
		end

		--Faulty Fuse
		local trinkyPower = mod.getTrinketMultiplierAcrossAllPlayers(FiendFolio.ITEM.TRINKET.FAULTY_FUSE)

		local chance = (0.05 * trinkyPower)
		if chance > 0 then
			local rng = Isaac.GetPlayer():GetTrinketRNG(mod.ITEM.TRINKET.FAULTY_FUSE)
			if rng:RandomFloat() < chance then
				local spawn = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, FiendFolio.PICKUP.BOMB.COPPER, spawnPos, nilvector, nil)
				return true
			end
		end

		--Energy searcher
		local trinkyPower = mod.getTrinketMultiplierAcrossAllPlayers(FiendFolio.ITEM.TRINKET.ENERGY_SEARCHER)

		local chance = (0.05 * trinkyPower)
		if chance > 0 then
			local rng = Isaac.GetPlayer():GetTrinketRNG(mod.ITEM.TRINKET.ENERGY_SEARCHER)
			if rng:RandomFloat() < chance then
				local spawn = Isaac.Spawn(5, 302, 2, spawnPos, nilvector, nil)
				return true
			end
		end

		--Steven's Box
		local boxMult = mod.getTrinketMultiplierAcrossAllPlayers(mod.ITEM.TRINKET.STEVENS_BOX)
		if boxMult >= 1 then
			local stevenChance = boxMult/35
			local rng = Isaac.GetPlayer():GetTrinketRNG(mod.ITEM.TRINKET.STEVENS_BOX)
			if rng:RandomFloat() <= stevenChance then
				local spawn = Isaac.Spawn(5, FiendFolio.PICKUP.VARIANT.STEVEN_HEART, 0, spawnPos, Vector.Zero, nil)
				return true
			end
		end
	end
end)

local function areAllBossesGone()
	if game:GetRoom():GetAliveBossesCount() ~= 0 then
		return false
	end

	for _, entity in ipairs(Isaac.GetRoomEntities()) do
		if entity:IsBoss() then
			return false
		end
	end

	return true
end

function mod.MusicLogic()
	if StageAPI.InNewStage() then return end
	if not mod.CustomMusicEnabled then return end
	local currentRoom = StageAPI.GetCurrentRoom()
	local isFFBoss
	local bossData
	if mod.IsFFMiniboss then
		isFFBoss = true
	elseif currentRoom and currentRoom.PersistentData.BossID then
		bossData = StageAPI.GetBossData(currentRoom.PersistentData.BossID)
		if bossData and bossData.IsFFBoss then
			isFFBoss = true
		end
	end

	if isFFBoss then
		local mm = MusicManager()
		local musicId = mm:GetCurrentMusicID()
		local stageType = Game():GetLevel():GetStageType()

		local newId = nil
		local queueMaize
		if musicId == Music.MUSIC_BOSS or musicId == Music.MUSIC_BOSS2 or musicId == Music.MUSIC_BOSS3 then
			if bossData.Horseman then
				newId = FiendFolio.Music.HorsemanTheme
			elseif stageType == StageType.STAGETYPE_REPENTANCE or stageType == StageType.STAGETYPE_REPENTANCE_B then
				newId = FiendFolio.Music.AltBossTheme
			else
				newId = FiendFolio.Music.BossTheme
			end
		elseif musicId == Music.MUSIC_JINGLE_BOSS then
			if bossData.Horseman then
				newId = FiendFolio.Music.HorsemanAppear
			elseif stageType == StageType.STAGETYPE_REPENTANCE or stageType == StageType.STAGETYPE_REPENTANCE_B then
				newId = FiendFolio.Music.AltBossAppear
			else
				newId = FiendFolio.Music.BossAppear
			end
		elseif musicId == Music.MUSIC_JINGLE_BOSS_OVER or musicId == Music.MUSIC_JINGLE_BOSS_OVER2 or musicId == Music.MUSIC_JINGLE_BOSS_OVER3
		or ((musicId == FiendFolio.Music.HorsemanTheme or musicId == FiendFolio.Music.AltBossTheme or musicId == FiendFolio.Music.BossTheme) and areAllBossesGone()) then
			if bossData.Horseman then
				newId = FiendFolio.Music.HorsemanOverJingle
			elseif stageType == StageType.STAGETYPE_REPENTANCE or stageType == StageType.STAGETYPE_REPENTANCE_B then
				newId = FiendFolio.Music.AltBossOverJingle
			else
				newId = FiendFolio.Music.BossOverJingle
			end
			queueMaize = true
		elseif musicId == Music.MUSIC_BOSS_OVER then
			newId = FiendFolio.Music.BossOver
		elseif musicId == Music.MUSIC_CHALLENGE_FIGHT then
			newId = FiendFolio.Music.MinibossTheme
		elseif musicId == FiendFolio.Music.MinibossTheme and Game():GetRoom():IsClear() then
			newId = FiendFolio.Music.MinibossOverJingle
			queueMaize = true
		end

		if newId then
			mm:Play(newId, 0)
			mm:UpdateVolume()
			if queueMaize then
				mm:Queue(FiendFolio.Music.BossOver)
			end
		end
	elseif (not mod.crawlspaceMoosicks) then
		local newId = nil
		local room = Game():GetRoom()
		local mm = MusicManager()
		local musicId = mm:GetCurrentMusicID()
		local backid = room:GetBackdropType()
		local roomType = room:GetType()
		if backid == 29 then
			if  musicId ~= FiendFolio.Music.CrawlSpace then
				newId = FiendFolio.Music.CrawlSpace
			end
		elseif roomType == RoomType.ROOM_BLACK_MARKET then
			if musicId ~= FiendFolio.Music.BlackMarket then
				newId = FiendFolio.Music.BlackMarket
			end
		elseif roomType == FiendFolio.SpecialRooms.Saloon.RoomType and backid == mod.Backdrops.SALOON then
			if musicId ~= FiendFolio.Music.Saloon then
				newId = FiendFolio.Music.Saloon
			end
		end

		if newId then
			mm:Play(newId, 0)
			mm:UpdateVolume()
		end
		mod.crawlspaceMoosicks = true
	elseif mod.IsInPsionicCluster() then
		local manager = MusicManager()
		local music = manager:GetCurrentMusicID()
		local room = Game():GetRoom()
		local roomType = room:GetType()
		local new
		local queue

		if roomType == RoomType.ROOM_TREASURE and mod.HermitAggro then
			if music ~= FiendFolio.Music.MinibossTheme and music ~= FiendFolio.Music.MinibossOverJingle and music ~= FiendFolio.Music.BossOver then
				if room:IsClear() then
					new = FiendFolio.Music.BossOver
				else
					new = FiendFolio.Music.MinibossTheme
				end
			elseif room:IsClear() then
				if music == FiendFolio.Music.MinibossTheme then
					new = FiendFolio.Music.MinibossOverJingle
					queue = FiendFolio.Music.BossOver
				end
			end
		--elseif music ~= Music.MUSIC_SHEOL then
			--new = Music.MUSIC_SHEOL
		end

		if new and new ~= music then
			manager:Crossfade(new)
			if queue then manager:Queue(queue) end
		end
	end
end

mod.fiendCheat = {
Keyboard.KEY_S, Keyboard.KEY_E, Keyboard.KEY_C, Keyboard.KEY_R, Keyboard.KEY_E, Keyboard.KEY_T,
}

function mod:cheatCodeLogic(player, ci)
	if mod.cheatModeOn then return end
	local data = mod:GetEntityData(player)
	local inputFrames = 7

	data.fiendCheat = data.fiendCheat or {}
	data.fiendCheat.LastKeyPressed = data.fiendCheat.LastKeyPressed or 0

	if data.fiendCheat.LastTimePressed and player.FrameCount > data.fiendCheat.LastTimePressed + inputFrames then
		data.fiendCheat.LastTimePressed = nil
		data.fiendCheat.LastKeyPressed = 0
	end

	if data.fiendCheat.LastKeyPressed > #mod.fiendCheat - 1 then data.fiendCheat.LastKeyPressed = #mod.fiendCheat - 1 end

	if mod.AnyKeyboardTriggered(mod.fiendCheat[data.fiendCheat.LastKeyPressed + 1], ci) then

		local frame = player.FrameCount
		local dropFrame = data.fiendCheat.LastTimePressed

		data.fiendCheat.LastTimePressed = frame
		data.fiendCheat.LastKeyPressed = data.fiendCheat.LastKeyPressed + 1

		if dropFrame and frame - dropFrame <= inputFrames then
			if data.fiendCheat.LastKeyPressed == #mod.fiendCheat then
				Isaac.ConsoleOutput("Fiend has found your password\n")
				sfx:Play(mod.Sounds.FiendFolioBook, 1, 0, false, 1)
				mod.Fiendish = true
				mod.cheatModeOn = true
				data.fiendCheat.LastTimePressed = nil
				data.fiendCheat.LastKeyPressed = nil
			end
		elseif dropFrame and frame - dropFrame > inputFrames then
			data.fiendCheat.LastTimePressed = nil
			data.fiendCheat.LastKeyPressed = nil
		end
	end
end

mod.ValidFunnyKeys = {
	{Keyboard.KEY_SPACE, "Space"},
	{Keyboard.KEY_TAB, "Tab"},
	{Keyboard.KEY_ENTER, "Enter"},
	{Keyboard.KEY_RIGHT, "Right Arrow"},
	{Keyboard.KEY_LEFT, "Left Arrow"},
	{Keyboard.KEY_DOWN, "Down Arrow"},
	{Keyboard.KEY_UP, "Up Arrow"},
	{Keyboard.KEY_LEFT_CONTROL, "Left Control"},
	{Keyboard.KEY_LEFT_SHIFT, "Left Shift"},
	{Keyboard.KEY_0, "0"},
	{Keyboard.KEY_1, "1"},
	{Keyboard.KEY_2, "2"},
	{Keyboard.KEY_3, "3"},
	{Keyboard.KEY_4, "4"},
	{Keyboard.KEY_5, "5"},
	{Keyboard.KEY_6, "6"},
	{Keyboard.KEY_7, "7"},
	{Keyboard.KEY_8, "8"},
	{Keyboard.KEY_9, "9"},
	{Keyboard.KEY_A, "A"},
	{Keyboard.KEY_B, "B"},
	{Keyboard.KEY_C, "C"},
	{Keyboard.KEY_D, "D"},
	{Keyboard.KEY_E, "E"},
	{Keyboard.KEY_F, "F"},
	{Keyboard.KEY_G, "G"},
	{Keyboard.KEY_H, "H"},
	{Keyboard.KEY_I, "I"},
	{Keyboard.KEY_J, "J"},
	{Keyboard.KEY_K, "K"},
	{Keyboard.KEY_L, "L"},
	{Keyboard.KEY_M, "M"},
	{Keyboard.KEY_N, "N"},
	{Keyboard.KEY_O, "O"},
	{Keyboard.KEY_Q, "Q"},
	{Keyboard.KEY_R, "R"},
	{Keyboard.KEY_S, "S"},
	{Keyboard.KEY_T, "T"},
	{Keyboard.KEY_U, "U"},
	{Keyboard.KEY_V, "V"},
	{Keyboard.KEY_W, "W"},
	{Keyboard.KEY_X, "X"},
	{Keyboard.KEY_Y, "Y"},
	{Keyboard.KEY_Z, "Z"},
}
mod.ValidFunnyActions = {
	{ButtonAction.ACTION_LEFT, "Move left"},
	{ButtonAction.ACTION_RIGHT, "Move right"},
	{ButtonAction.ACTION_UP, "Move up"},
	{ButtonAction.ACTION_DOWN, "Move down"},
	{ButtonAction.ACTION_SHOOTLEFT, "Shoot left"},
	{ButtonAction.ACTION_SHOOTRIGHT, "Shoot right"},
	{ButtonAction.ACTION_SHOOTUP, "Shoot up"},
	{ButtonAction.ACTION_SHOOTDOWN, "Shoot down"},
	{ButtonAction.ACTION_BOMB, "Place a bomb"},
	{ButtonAction.ACTION_ITEM, "Use your active item"},
	{ButtonAction.ACTION_PILLCARD, "Use your pill or card"},
}

function mod:pressKeyOrDieLogic(player, ci)
	if mod.FiendishKeyToPress then
		local key = mod.ValidFunnyKeys[mod.FiendishKeyToPress][1]
		if mod.AnyKeyboardTriggered(key, ci) then
			mod.FiendishKeyToPress = nil
			mod.FiendishKeyTimer = nil
		end
	end
end
function mod:doActionOrDieLogic(player, ci)
	if mod.FiendishActionToDo then
		local key = mod.ValidFunnyActions[mod.FiendishActionToDo][1]
		if Input.IsActionPressed(key, ci) then
			mod.FiendishActionToDo = nil
			mod.FiendishKeyTimer = nil
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	if mod.FiendishKeyToPress then
		local key = mod.ValidFunnyKeys[mod.FiendishKeyToPress][2]
		mod.FiendishKeyTimer = mod.FiendishKeyTimer - 1
		local secondTimer = math.ceil(mod.FiendishKeyTimer / 60)
		local secondString = "s"
		if secondTimer == 1 then
			secondString = ""
		end
		Isaac.RenderText("Press " .. key .. " key in " .. secondTimer .. " second" .. secondString .. " or die!",  100, 78, 255, 255, 255, 1)
		if mod.FiendishKeyTimer < 1 then
			Isaac.GetPlayer():Kill()
			mod.FiendishKeyToPress = nil
			mod.FiendishKeyTimer = nil
		end
	elseif mod.FiendishActionToDo then
		local key = mod.ValidFunnyActions[mod.FiendishActionToDo][2]
		mod.FiendishKeyTimer = mod.FiendishKeyTimer - 1
		local secondTimer = math.ceil(mod.FiendishKeyTimer / 60)
		local secondString = "s"
		if secondTimer == 1 then
			secondString = ""
		end
		Isaac.RenderText(key .. " in " .. secondTimer .. " second" .. secondString .. " or die!",  100, 78, 255, 255, 255, 1)
		if mod.FiendishKeyTimer < 1 then
			Isaac.GetPlayer():Kill()
			mod.FiendishActionToDo = nil
			mod.FiendishKeyTimer = nil
		end
	end
end)

function mod.PressButtonLogic()
	if game:IsPaused() then return end
	local player = Isaac.GetPlayer(0):ToPlayer()
	local ci = player.ControllerIndex
	mod:cheatCodeLogic(player, ci)
	mod:pressKeyOrDieLogic(player, ci)
	mod:doActionOrDieLogic(player, ci)
	mod:erflyPressButtonLogic(player, ci)
	for i = 1, game:GetNumPlayers() do
		local p = Isaac.GetPlayer(i - 1)
		local ci1 = player.ControllerIndex
		mod:frogmodeLogic(p, ci1)
		mod:ferriumPressButtonLogic(p, ci1)
	end
end

function mod:OnRender()
	if not mod.Lerp then return end
	mod.MusicLogic()
	mod.PressButtonLogic()
	mod:ferriumOnRender()

	--[[if sfx:IsPlaying(mod.Sounds.FiendHurt)
	or sfx:IsPlaying(mod.Sounds.BiendHurt)
	or sfx:IsPlaying(mod.Sounds.GolemHurt)
	or sfx:IsPlaying(mod.Sounds.CraigHurt) then
		sfx:Stop(SoundEffect.SOUND_ISAAC_HURT_GRUNT)
	end]]
end
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.OnRender)

local dirToVec = {
	[Direction.NO_DIRECTION] = Vector(0,0),
	[Direction.LEFT] = Vector(-1,0),
	[Direction.UP] = Vector(0,-1),
	[Direction.RIGHT] = Vector(1,0),
	[Direction.DOWN] = Vector(0,1)
}

FiendFolio.AnalogFiringCharacters = {
	[FiendFolio.PLAYER.FRIEND] = true,
	[FiendFolio.PLAYER.BRIEND] = true,
}

function FiendFolio.GetCorrectedFiringInput(p, useAimDir)
	if p:HasCollectible(CollectibleType.COLLECTIBLE_MARKED) then
		local markedTarget = mod.GetPlayerMarkedTarget(p)
		if markedTarget then
			return (markedTarget.Position - p.Position):Normalized()
		end
	end
	if useAimDir
	or p:HasCollectible(CollectibleType.COLLECTIBLE_ANALOG_STICK)
	or p:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE)
	or (FiendFolio.AnalogFiringCharacters[p:GetPlayerType()] and mod.MouseGunAiming == 1)
	then
		--Bit funny, GetShootingInput returns nothing with analog stick
		--Still better to return but I'll make sure it has a backup
		local aimDir = p:GetAimDirection()
		local shootInput = p:GetShootingInput()
		if aimDir:Length() > 0 and shootInput:Length() <= 0.1 then
			return aimDir:Normalized()
		else
			if shootInput:Length() > 1 then
				shootInput = shootInput:Normalized()
			end
			return shootInput
		end
	else
		return dirToVec[p:GetFireDirection()]
	end
end

function mod.debugToolLogic()
	if mod.motherFollowing then
		if mod.GetEntityCount(mod.FF.MotherOrb.ID, mod.FF.MotherOrb.Var) < 1 then
			local room = game:GetRoom()
			local targ = room:GetCenterPos()
			local player = mod.FindClosestEntity(1, 80)
			if player and player.Distance(targ.Position) < 80 then
				targ = player.Position + Vector(0, -80)
			end
			local mother = Isaac.Spawn(mod.FF.MotherOrb.ID, mod.FF.MotherOrb.Var, 0, targ, nilvector, nil)
			mod:GetEntityData(mother).DingCount = 5
			mother.CollisionDamage = 100
			mother.Color = Color(0, 0, 0, 1, 0, 0, 0)
			mother:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
			mother:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			mother:Update()
		end
	end
end

function mod:grabberChallenge()
	if Isaac.GetChallenge() == mod.challenges.handsOn and not sfx:IsPlaying(mod.Sounds.ClapSong) then
		sfx:Play(mod.Sounds.ClapSong, 2, 0, false, 1)
		MusicManager():Pause()
		MusicManager():Disable()
	end
end

mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function()
	if sfx:IsPlaying(mod.Sounds.ClapSong) then
		sfx:Stop(mod.Sounds.ClapSong)
	end
end)

function mod:OnUpdate()
	mod.GetRoomEntities()
	mod.PlayFlySound()
	mod.RoomGridPath = mod:GetRoomGridPath()
	mod.smokingMulliganExplosionHandling()
	mod.graterGratesLogic()
	mod.SuperEasyModeFun()
	mod.ThousandEyesLogic()
	mod.fiendishLogic()
	mod.spookLogic()
	mod.debugToolLogic()
	mod.nukePathLogic()
	--mod.grabberChallenge()
	mod.bullMatador()

	mod:erflyOnUpdate()
	mod:customHitboxFrozenChecks()

	mod:handleStatusEffects()

	math.randomseed(Isaac.GetTime())
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.OnUpdate)

function mod.stopLoopingSounds()
	--[[sfx:Stop(SoundEffect.SOUND_ULTRA_GREED_SPINNING)
	sfx:Stop(mod.Sounds.FriedLoop)
	sfx:Stop(mod.Sounds.CrosseyeShootLoop)
	sfx:Stop(mod.Sounds.PsionRedirectLoop)
	sfx:Stop(mod.Sounds.TapLoop)
	sfx:Stop(mod.Sounds.TapHoney02)
	sfx:Stop(mod.Sounds.SteamTrain)
	sfx:Stop(mod.Sounds.RolyPolyRoll)]]
	sfx:StopLoopingSounds() --I didn't realise this function existed my god
end

function mod.gbfLogic()
	if FiendFolio.savedata.sawGBFBefore then return end
	if mod.sawGBF then
		mod.sawGBF = mod.sawGBF + 1
		if mod.sawGBF == 15 then
			sfx:Play(mod.Sounds.gbf, 0.5, 0, false, 1)
			mod.sawGBF = false
			FiendFolio.savedata.sawGBFBefore = true
		end
	end
end

function mod:resetCertainFamiliars()
	for _, randy in pairs(Isaac.FindByType(3, mod.ITEM.FAMILIAR.RANDY_THE_SNAIL, -1, false, false)) do
		mod:GetEntityData(randy).init = nil
		randy:Update()
	end
	for _, psihelper in pairs(Isaac.FindByType(mod.FF.Psihunter.ID, mod.FF.Psihunter.Var, 10, false, false)) do
		psihelper.Position = Isaac.GetPlayer(0).Position
	end
	for _, peachcreep in pairs(Isaac.FindByType(3, mod.ITEM.FAMILIAR.PEACH_CREEP, -1, false, false)) do
		peachcreep.Position = Isaac.GetPlayer(0).Position
		mod:GetEntityData(peachcreep).init = nil
	end
	for _, gorgon in pairs(Isaac.FindByType(3, mod.ITEM.FAMILIAR.GORGON, -1, false, false)) do
		mod:GetEntityData(gorgon).init = nil
		gorgon:Update()
	end
	for _, rock in pairs(Isaac.FindByType(3, mod.ITEM.FAMILIAR.PETROCK, -1, false, false)) do
		mod:GetEntityData(rock).init = nil
		--mod:GetEntityData(rock).face = nil
		rock:Update()
	end
	for _, snake in pairs(Isaac.FindByType(3, mod.ITEM.FAMILIAR.OPHIUCHUS, -1, false, false)) do
		snake.Position = mod:FindNearbyDoor(snake:ToFamiliar().Player.Position, true)
		mod:GetEntityData(snake).init = nil
		snake:Update()
	end
	for _, hand in pairs(Isaac.FindByType(3, mod.ITEM.FAMILIAR.REDHAND, -1, false, false)) do
		mod:GetEntityData(hand).init = nil
		hand:Update()
	end
	for _, peeve in pairs(Isaac.FindByType(3, mod.ITEM.FAMILIAR.PET_PEEVE, -1, false, false)) do
		mod:GetEntityData(peeve).init = nil
	end
	for _, ffbookhelp in pairs(Isaac.FindByType(3, mod.ITEM.FAMILIAR.FF_BOOK_HELPER, -1, false, false)) do
		ffbookhelp:Remove()
	end
end

function mod:removeDireChests()
	for _, pickup in pairs(Isaac.FindByType(5, 712, 1, false, false)) do
		if pickup.SubType == 1 then
			pickup:Remove()
		end
	end
end

function mod:moveToCentreForCertainBosses()
	local room = game:GetRoom()
	if room:GetType() == RoomType.ROOM_BOSS
	and (
		  #Isaac.FindByType(mod.FF.SunBody.ID, mod.FF.SunBody.Var, -1, false, false)
		+ #Isaac.FindByType(mod.FF.Luncheon.ID, mod.FF.Luncheon.Var, -1, false, false)
		+ #Isaac.FindByType(mod.FF.Dusk.ID, mod.FF.Dusk.Var, -1, false, false)
		+ #Isaac.FindByType(mod.FF.WarpZone.ID, mod.FF.WarpZone.Var, -1, false, false)
		+ #Isaac.FindByType(mod.FF.Junkstrap.ID, mod.FF.Junkstrap.Var, -1, false, false)
	) > 0 then
		local room = Game():GetRoom()
		local spawnpos = room:FindFreePickupSpawnPosition(room:GetCenterPos() + Vector(0,80), 1, true)
		for _,player in ipairs(Isaac.FindByType(1, -1, -1, EntityPartition.PLAYER, true)) do
			--Lets just be safe
			local realPlayer = player:ToPlayer()
			if realPlayer then
				realPlayer:Teleport(spawnpos, false)
			end
		end
	end
end

mod.ModernHorsemanFleas = {
[1] = mod.ITEM.TRINKET.FLEA_MELTDOWN,
[2] = mod.ITEM.TRINKET.FLEA_DELUGE,
[3] = mod.ITEM.TRINKET.FLEA_POLLUTION,
[4] = mod.ITEM.TRINKET.FLEA_PROPAGANDA,
}
mod.LadybugTrinkets = {
	[1] = mod.ITEM.TRINKET.FIENDISH_LADYBUG,
	[2] = mod.ITEM.TRINKET.BASTARDLY_LADYBUG,
	[3] = mod.ITEM.TRINKET.FRIENDLY_LADYBUG,
	[4] = mod.ITEM.TRINKET.SKELETAL_LADYBUG,
}

function mod:triggerFleaSpawning(p)
	for j = 1, 4 do
		if p:HasTrinket(mod.ModernHorsemanFleas[j]) then
			local repeatTimes = p:GetTrinketMultiplier(mod.ModernHorsemanFleas[j])
			for k = 1, repeatTimes do
				local randVec = RandomVector() * math.random(5,15)
				local flea = Isaac.Spawn(3, mod.ITEM.FAMILIAR.ATTACK_SKUZZ, j, p.Position + randVec, nilvector, p)
				flea:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			end
		end
	end
	--Just doing this in here too since it's easier
	if p:HasTrinket(mod.ITEM.TRINKET.CHUNK_OF_TAR) then
		local repeatTimes = 3 + 2 * (p:GetTrinketMultiplier(mod.ITEM.TRINKET.CHUNK_OF_TAR) - 1)
		for k = 1, repeatTimes do
			local randVec = RandomVector() * math.random(5,15)
			local blot = Isaac.Spawn(mod.FF.Blot.ID, mod.FF.Blot.Var, 0, p.Position + randVec, nilvector, p)
			blot:AddEntityFlags(EntityFlag.FLAG_CHARM)
			blot:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
			blot:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
			blot.Color = Color(1.5,1.5,1.5,1)
			blot:Update()
		end
	end
	--me too here i go
	for j = 1, 4 do
		if p:HasTrinket(mod.LadybugTrinkets[j]) then
			local repeatTimes = p:GetTrinketMultiplier(mod.LadybugTrinkets[j])
			local rng = p:GetTrinketRNG(mod.LadybugTrinkets[j])
			for k = 1, repeatTimes do
				local randVec = RandomVector() * mod:RandomInt(5,15,rng)
				local lady = Isaac.Spawn(3, mod.ITEM.FAMILIAR.BLUE_BEETLE, j, p.Position + randVec, nilvector, p)
				lady:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			end
		end
	end
end

function mod:fleaSpawnLogic()
	local room = game:GetRoom()
	if room:IsFirstVisit() and not room:IsClear() then
		for i = 1, game:GetNumPlayers() do
			local p = Isaac.GetPlayer(i - 1)
			mod:triggerFleaSpawning(p)
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	if eff.SubType == 960 then
		eff.Color = Color(1,1,1,mod:GetEntityData(eff).opacity)
	elseif eff.SubType == 961 then
		local opacityAmount = mod:GetEntityData(eff).opacity
		if opacityAmount and eff.FrameCount <= 10 then
			opacityAmount = opacityAmount * (0.1 * eff.FrameCount)
		end
		eff.Velocity = mod:Lerp(eff.Velocity, eff.Velocity:Resized(1), 0.07)
		if opacityAmount and eff.FrameCount > 40 then
			opacityAmount = opacityAmount * (0.9^(eff.FrameCount - 40))
			if eff.FrameCount > 120 or opacityAmount < 0.001 then
				eff:Remove()
			end
		end
		eff.Color = Color(eff.Color.R,eff.Color.G,eff.Color.B,opacityAmount, eff.Color.RO, eff.Color.GO, eff.Color.BO)
	end
end, 138)

function mod.determineFuegoSpots()
	mod.fuegoSpawnPoints = {}
	if mod.fuegoSpawners then
		for i = 1, #mod.fuegoSpawners do
			--table.insert(mod.fuegoSpawnPoints, mod.fuegoSpawners[i])
			mod.fuegoSpawnPoints[mod.fuegoSpawners[i]] = true
		end
	end
	mod.fuegoSpawners = nil
end

function mod:OnNewRoom()
	--Clear loop sounds
	mod.stopLoopingSounds()

	--Custom drops for vanilla grids/alt rocks/pIss BUCKET
	if StageAPI then
		local room = game:GetRoom()
		local backdropType = room:GetBackdropType()
		if backdropType == 16
		or backdropType == 17
		or backdropType == BackdropType.DICE
		or room:GetType() == RoomType.ROOM_DUNGEON
		or backdropType == mod.Backdrops.SALOON
		then
			StageAPI.TemporarilyOverrideRockAltEffects()
		elseif mod.roomBackdrop == 9 --Peepee Dross
		or mod.roomBackdrop == 10 --Morbus
		or mod.roomBackdrop == 14 then --Surreal Sheol
			StageAPI.TemporarilyOverrideRockAltEffects()
		end
	end

	mod.RoomIndexOffsets = mod:GetRoomIndexOffsets()

	mod.FlickerspiritInRoom = false
	mod.eternalFlickerspiritInRoom = false
	mod.waitingEnemiesTriggered = false
	mod.momframes = false
	mod.secondphasestomp = false
	mod.momfleshframes = 0
	mod.momfleshbuffer = 10
	mod.comeconsecutivecheck = nil
	mod.comeconsecutivecheck2 = nil
	mod.smokingMulliganLocations = {} --Clear em all away
	mod.smokingMulliganTicks = nil
	mod.graterInRoom = false
	mod.graterCount = nil
	mod.GraterState = nil
	mod.thousandeyes = nil
	mod.ThousandEyesSpawned = nil
	mod.resetelitejon = nil
	mod.cursedGrimaceClones = 0
	mod.spookInRoom = nil
	mod.spookRecord = {}
	mod.spookrecordplayerstart = {}
	mod.spookJustKilledEnemy = nil
	mod.ghostLarriesKilled = 0
	mod.doneShowingModCompatWarning = true
	mod.crawlspaceMoosicks = false
	mod.RoomGrids = nil
	mod.downloadFailureCarded = nil
	mod.bullInRoom = nil
	mod.bullData = nil
	mod.petRocksKilled = nil
	mod.checkWeedy = false
	mod.SkipCardUsed = nil
	mod.RoomEntitiesCache = nil
	mod.nukeDrops = nil
	mod.usedStorageBattery = nil --Safety measure
	mod.HermitAggro = false
	mod.RocktopSafetyData = nil
	mod.IsD12DiceRoom = false

	mod:FiendNewRoomStuff()
	mod:BossRoomFunTime()
	mod:backdropReplacer()
	mod:checkD12Rocks()
	--mod:gbfLogic() --Arg over
	mod:spawnPersistents()
	mod:makeRamblinPoints()
	mod:resetCertainFamiliars()
	mod:removeDireChests()
	mod:moveToCentreForCertainBosses()
	mod:fleaSpawnLogic()
	mod.ExtraCrawlspaceGfx()
	mod.cirnoTime()
	mod.determineFuegoSpots()
	mod:cancelScheduledFunctions()

	mod:challengeDadsHomePlus()
	mod:challengeTheRealJon()
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoom)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, npc)
  if npc.Variant == 1 then
	local hosts = Isaac.FindByType(27, 0, 0, false, false)
	for _, h in ipairs(hosts) do
	  if h.FrameCount == 0 and npc.Position:Distance(h.Position) == 0 then
		local sprite = h:GetSprite()
		sprite:Load("gfx/enemies/grid hosts/host.anm2", false)
		sprite:ReplaceSpritesheet(1, "gfx/enemies/grid hosts/host_siren.png")
		sprite:LoadGraphics()
		mod:GetEntityData(h).ffGridHost = "siren.png"
		break
	  end
	end
  end
end, 904)

function mod.setHostGridGfx(host, backdrop)
  local hSprite
  if ((1<<7 | 1<<30) & backdrop) ~= 0 then hSprite = "depths.png"
  elseif ((1<<8) & backdrop) ~= 0 then hSprite = "necropolis.png"
  elseif ((1<<9) & backdrop) ~= 0 then hSprite = "dank.png"
  elseif ((1<<14) & backdrop) ~= 0 then hSprite = "sheol.png"
  elseif ((1<<33 | 1<<38 | 1<<40 | 1<<41 | 1<<42) & backdrop) ~= 0 then hSprite = "maus.png"
  elseif ((1<<39) & backdrop) ~= 0 then hSprite = "corpse_maus.png"
  elseif ((1<<47) & backdrop) ~= 0 then hSprite = "gehenna.png"
  end
  local sprite = host:GetSprite()
  sprite:Load("gfx/enemies/grid hosts/host.anm2", false)
  sprite:ReplaceSpritesheet(1, "gfx/enemies/grid hosts/host_" .. hSprite)
  sprite:LoadGraphics()
  mod:GetEntityData(host).ffGridHost = hSprite
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
  if npc.Variant == 0 then
	if npc.SubType == 250 then
	  mod:GetEntityData(npc).ffGridHost = "hostlet.png"
	  return
	end
	local backdrop = 1<<(Game():GetRoom():GetBackdropType())
	local backdropFlags = 1<<7 | 1<<8 | 1<<9 | 1<<14 | 1<<30 | 1<<33 | 1<<38 | 1<<39 | 1<<40 | 1<<41 | 1<<42 | 1<<47
	--1<<7 depths  --1<<30 depths  --1<<8 necro  --1<<9 dank  --1<<14 sheol  --1<<33 maus  --1<<38 maus  --1<<40 maus  --1<<41 maus?  --1<<42 maus?  --1<<39 corpse  --1<<47 gehenna
	if (backdropFlags & backdrop) == 0 then return end
	local grid = Game():GetRoom():GetGridEntityFromPos(npc.Position)
	if not grid then return end
	if grid:GetType() == 6 and grid.State == 2 then
	  local pGrids = Isaac.FindByType(1000, 4, 0, false, false)
	  for _, p in ipairs(pGrids) do
		if p.FrameCount == 0 and npc.Position:Distance(p.Position) < 5 then
		  mod.setHostGridGfx(npc, backdrop)
		  break
		end
	  end
	end
  end
end, 27)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, tear)
  if (tear.Type == 2 and tear.Variant == 40) or (tear.Type == 9 and tear.Variant == 8) then
	local backdrop = 1<<(Game():GetRoom():GetBackdropType())
	local backdropFlags = 1<<7 | 1<<8 | 1<<9 | 1<<14 | 1<<30 | 1<<33 | 1<<38 | 1<<39 | 1<<40 | 1<<41 | 1<<42 | 1<<47
	if (backdropFlags & backdrop) == 0 then return end
	local hosts = Isaac.FindByType(27, 0, 0, false, false)
	for _, h in ipairs(hosts) do
	  if h.FrameCount == 0 and tear.Position:Distance(h.Position) == 0 then
		mod.setHostGridGfx(h, backdrop)
		break
	  end
	end
  end
end)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
  if eff.FrameCount == 1 and eff:GetSprite():GetFilename() == "gfx/002.040_thrown tear.anm2" then
	local hosts = Isaac.FindInRadius(eff.Position, 40, EntityPartition.ENEMY)
	local nearest
	local dist
	for _, h in pairs(hosts) do
	  if h.Type == 27 and h.Variant == 0 then
		if not nearest then
		  nearest = h
		  dist = h.Position:Distance(eff.Position)
		else
		  local distN = h.Position:Distance(eff.Position)
		  if distN < dist then
			nearest = h
			dist = distN
		  end
		end
	  end
	end
	if not nearest then return end
	local h = nearest
	if mod:GetEntityData(h).ffGridHost then
	  local sSprite = mod:GetEntityData(h).ffGridHost
	  local sprite = eff:GetSprite()
	  sprite:Load("gfx/enemies/grid hosts/thrown_specialrocks.anm2", false)
	  sprite:ReplaceSpritesheet(0, "gfx/enemies/grid hosts/thrown_specialrocks_" .. sSprite)
	  sprite:LoadGraphics()
	  sprite:Play("Rock1", true)
	  if not mod:GetEntityData(h).ffGridRedHost then
		mod:GetEntityData(h).ffGridRedHost = true
		local hSprite = h:GetSprite()
		local hAnm = hSprite:GetAnimation()
		local hNum = hSprite:GetFrame()
		local hFile = hSprite:GetFilename()
		if hFile == "gfx/enemies/jammed/hostlet.anm2" then
		  hSprite:ReplaceSpritesheet(1, "gfx/enemies/jammed/red_hostlet.png")
		  mod:GetEntityData(h).IsHostlet = true
		elseif hFile == "gfx/enemies/grid hosts/host.anm2" then
		  hSprite:ReplaceSpritesheet(1, "gfx/enemies/grid hosts/redhost_" .. sSprite)
		end
		hSprite:LoadGraphics()
		hSprite:Play(hAnm, true)
		for i=0, hNum do
		  hSprite:Update()
		end
		--hSprite:SetFrame(hAnm, hNum)
	  end
	end
  end
end, 136)

--[[
mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, function(_, mask) -- Bye-bye curse of maze
	return mask & ~ LevelCurse.CURSE_OF_MAZE
end)

mod:AddCallback(ModCallbacks.MC_GET_PILL_EFFECT, function(selectedEffect, colour)
	if selectedEffect == PillEffect.PILLEFFECT_QUESTIONMARK then
		return math.random(Isaac.GetPillEffectByName("Melatonin"), Isaac.GetPillEffectByName("Spider Unboxing"))
	end
end)
]]

-- It seems like this isn't needed anymore as Epiphany should now be properly handling pickup collisions using
-- early callback priority (I think this compatability check was added before callback priorities were a thing).
--[[
function mod:EpiphanyPickupCheck(pickup, collider)
	-- EPIPHANY PICKUP FIX --
	if collider -- is defined
	and collider:ToPlayer() -- is a player
	and Epiphany -- is installed
	and collider:ToPlayer():GetPlayerType() == Epiphany.table_type_id["KEEPER"] -- player is Tarnished Keeper
	and not (pickup.Price > 0)
	and not pickup.Touched
	then return true end -- do not open the pickup
	-- END --
end
]]

function mod:IsInMinecart(entity)
    if entity:GetMinecart() then
        return entity:GetMinecart()
    else
        for _, minecart in ipairs(Isaac.FindByType(EntityType.ENTITY_MINECART)) do
            if minecart.Child and minecart.Child.InitSeed == entity.InitSeed then
                return minecart
            end
        end
    end
end

LoadScripts({
	"ffscripts.callbacks.players",
	"ffscripts.callbacks.player_input",
	"ffscripts.callbacks.all_entities",
	"ffscripts.callbacks.technical_entities",
	"ffscripts.callbacks.projectiles",
	"ffscripts.controls",
	"ffscripts.customgrids",
	"ffscripts.puzzlelocks",
	"ffscripts.players.golem",
	"ffscripts.extraSlots",
	"ffscripts.customhealth",
	"ffscripts.customTearVariants",
	"ffscripts.players.golem_subway",
	"ffscripts.players.bolem",
	"ffscripts.blor.gutso",
	"ffscripts.blor.whispers",
	"ffscripts.critical_hit",
	"ffscripts.replacements",
	"ffscripts.alphacoin",
	"ffscripts.penny_trinkets",
	"ffscripts.sacrificial_altar",
	"ffscripts.players.friend",
	"ffscripts.players.briend",
	"ffscripts.players.briend_bounty.heat",
	"ffscripts.players.briend_bounty.gunslingers",
	"ffscripts.players.briend_bounty.guns",
	"ffscripts.players.briend_bounty.costumes",
	"ffscripts.players.briend_bounty.birthright",
	"ffscripts.players.fiend",
	"ffscripts.players.fiend_classic",
	"ffscripts.theboss",
	"ffscripts.modcompat.minimap_api",
	"ffscripts.modcompat.roomcompatscript",
	"ffscripts.players.inaba",

	"ffscripts.general.main",
})

LoadScripts({
	"ffscripts.mini.main",
	"ffscripts.budj.main",
	"ffscripts.dead.main",
	"ffscripts.erfly.main",
	"ffscripts.ferrium.main",
	"ffscripts.fiendfoliobook.main",
	"ffscripts.taiga.main",
	"ffscripts.xalum.main",
	"ffscripts.snake.main",
	"ffscripts.guwah.main",
	"ffscripts.sbody.main",
	"ffscripts.connor.main",
	"ffscripts.cake.main",
	"ffscripts.oroshibu.main",
	"ffscripts.julia.main",
	"ffscripts.jd.main",
    "ffscripts.marianna.myepicmain",
	"ffscripts.blor.main",
	"ffscripts.hippo.main",
	"ffscripts.sunil.main",
	"ffscripts.catinsurance.main",
	"ffscripts.sin.main",
	"ffscripts.pixelplz.main",
	"ffscripts.beah.main",
	"ffscripts.vermin.main",
	"ffscripts.hapty.main",
	"ffscripts.jerb.main",
})

--Some stuff needs to be loaded after everything else
LoadScripts({
	"ffscripts.revives",
	"ffscripts.modcompat.abl",
	"ffscripts.modcompat.enhancedbossbars",
	"ffscripts.modcompat.roomcompatwhitelist",
	"ffscripts.modcompat.epiphany",
	"ffscripts.modcompat.theshampoobottle",
	"ffscripts.modcompat.voidsillies",
	"ffscripts.erfly.familiars.d3",
})

-- these are here so they can be after everything else is loaded
-- please leave them here
FiendFolio.EnemyOnDeath.DeathAnims = {
	{ID = mod.FF.Tagbag.ID, Var = mod.FF.Tagbag.Var, CustomAnimFunc = mod.tagbagDeathAnim},
	{ID = mod.FF.FossilBoomFly.ID, Var = mod.FF.FossilBoomFly.Var, CustomAnimFunc = mod.fossilizedBoomFlyDeathAnim},
	{ID = mod.FF.Gunk.ID, Var = mod.FF.Gunk.Var, CustomAnimFunc = mod.gunkDeathAnim},
	{ID = mod.FF.Punk.ID, Var = mod.FF.Punk.Var, CustomAnimFunc = mod.gunkDeathAnim},
	{ID = mod.FF.Dogmeat.ID, Var = mod.FF.Dogmeat.Var, CustomAnimFunc = mod.erflyCustomDeathAnim},
	{ID = mod.FF.HeadHoncho.ID, Var = mod.FF.HeadHoncho.Var, CustomAnimFunc = mod.headHonchoDeathAnim},
	{ID = mod.FF.Gorger.ID, Var = mod.FF.Gorger.Var, Sub = 0, BasicAnimName = "Death"},
	{ID = mod.FF.Fishaac.ID, Var = mod.FF.Fishaac.Var, CustomAnimFunc = mod.fishaacDeathAnim},
	{ID = mod.FF.TDweller.ID, Var = mod.FF.TDweller.Var, CustomAnimFunc = mod.deepDwellerDeathAnim},
	{ID = mod.FF.Warden.ID, Var = mod.FF.Warden.Var, CustomAnimFunc = mod.erflyCustomDeathAnim},
	{ID = mod.FF.Carrier.ID, Var = mod.FF.Carrier.Var, CustomAnimFunc = mod.erflyCustomDeathAnim},
	{ID = mod.FF.MiniMinMin.ID, Var = mod.FF.MiniMinMin.Var, CustomAnimFunc = mod.miniMinDeathAnim},
	{ID = mod.FF.Tango.ID, Var = mod.FF.Tango.Var, BasicAnimName = "Death", DropsBeforeAnim = true},
	{ID = mod.FF.Blastcore.ID, Var = mod.FF.Blastcore.Var, CustomAnimFunc = mod.BlastcoreDeathAnim},
	{ID = mod.FF.Rufus.ID, Var = mod.FF.Rufus.Var, CustomAnimFunc = mod.RufusDeathAnim},
	{ID = mod.FF.Oralopede.ID, Var = mod.FF.Oralopede.Var, BasicAnimName = "Death", DropsBeforeAnim = true},
	{ID = mod.FF.Oralid.ID, Var = mod.FF.Oralid.Var, BasicAnimName = "Death", DropsBeforeAnim = true},
	{ID = mod.FF.Craterface.ID, Var = mod.FF.Craterface.Var, BasicAnimName = "Death"},
	{ID = mod.FF.Load.ID, Var = mod.FF.Load.Var, BasicAnimName = "death"},
	{ID = mod.FF.CornLoad.ID, Var = mod.FF.CornLoad.Var, BasicAnimName = "death"},
	{ID = mod.FF.Baro.ID, Var = mod.FF.Baro.Var, BasicAnimName = "Death"},
	{ID = mod.FF.Lez.ID, Var = mod.FF.Lez.Var, Sub = mod.FF.Lez.Sub, BasicAnimName = "Death", DropsBeforeAnim = true},
	{ID = mod.FF.Shi.ID, Var = mod.FF.Shi.Var, CustomAnimFunc = mod.shiDeathAnim},
	{ID = mod.FF.Nuchal.ID, Var = mod.FF.Nuchal.Var, CustomAnimFunc = mod.nuchalDeathAnim},
	{ID = mod.FF.MamaPooter.ID, Var = mod.FF.MamaPooter.Var, CustomAnimFunc = mod.mamaPooterDeathAnim},
	{ID = mod.FF.PsychoFly.ID, Var = mod.FF.PsychoFly.Var, CustomAnimFunc = mod.psychoFlyDeathAnim},
	{ID = mod.FF.ManicFly.ID, Var = mod.FF.ManicFly.Var, CustomAnimFunc = mod.manicFlyDeathAnim},
	{ID = mod.FF.Punted.ID, Var = mod.FF.Punted.Var, CustomAnimFunc = mod.puntedDeathAnim},
	{ID = mod.FF.Empath.ID, Var = mod.FF.Empath.Var, CustomAnimFunc = mod.empathDeathAnim},
	{ID = mod.FF.BubbleBat.ID, Var = mod.FF.BubbleBat.Var, CustomAnimFunc = mod.drownedFatDeathAnim},
	{ID = mod.FF.Drooler.ID, Var = mod.FF.Drooler.Var, CustomAnimFunc = mod.mukDeathAnim},
	{ID = mod.FF.Melty.ID, Var = mod.FF.Melty.Var, CustomAnimFunc = mod.meltyDeathAnim},
	{ID = mod.FF.Coconut.ID, Var = mod.FF.Coconut.Var, CustomAnimFunc = mod.CoconutDeathAnim},
	{ID = mod.FF.Fishy.ID, Var = mod.FF.Fishy.Var, Sub = 0, CustomAnimFunc = mod.FishyDeathAnim},
	{ID = mod.FF.Discy.ID, Var = mod.FF.Discy.Var, Sub = 0, CustomAnimFunc = mod.DiscyDeathAnim},
	{ID = mod.FF.DreadMaw.ID, Var = mod.FF.DreadMaw.Var, CustomAnimFunc = mod.dreadMawDeathAnim},
	{ID = mod.FF.Quack.ID, Var = mod.FF.Quack.Var, CustomAnimFunc = mod.QuackDeathAnim},
	{ID = mod.FF.CorruptedContusion.ID, Var = mod.FF.CorruptedContusion.Var, CustomAnimFunc = mod.corruptedContusionDeathAnim},
	{ID = mod.FF.CorruptedSuture.ID, Var = mod.FF.CorruptedSuture.Var, CustomAnimFunc = mod.corruptedSutureDeathAnim},
	{ID = mod.FF.CorruptedMonstro.ID, Var = mod.FF.CorruptedMonstro.Var, CustomAnimFunc = mod.corruptedMonstroDeathAnim},
	{ID = mod.FF.Steralis.ID, Var = mod.FF.Steralis.Var, CustomAnimFunc = mod.SteralisDeathAnim},
	{ID = mod.FF.Nematode.ID, Var = mod.FF.Nematode.Var, CustomAnimFunc = mod.nematodeDeathAnim},
	{ID = mod.FF.Chummer.ID, Var = mod.FF.Chummer.Var, Sub = 0, CustomAnimFunc = mod.chummerDeathAnim},
	{ID = mod.FF.Aleya.ID, Var = mod.FF.Aleya.Var, CustomAnimFunc = mod.AleyaDeathAnim},
	{ID = mod.FF.Whale.ID, Var = mod.FF.Whale.Var, Sub = 0, CustomAnimFunc = mod.whaleDeathAnim},
	{ID = mod.FF.Clam.ID, Var = mod.FF.Clam.Var, BasicAnimName = "Death"},
	{ID = mod.FF.Buckshot.ID, Var = mod.FF.Buckshot.Var, CustomAnimFunc = mod.BuckshotDeathAnim},
	{ID = mod.FF.Musk.ID, Var = mod.FF.Musk.Var, CustomAnimFunc = mod.mukDeathAnim},
	{ID = mod.FF.Plexus.ID, Var = mod.FF.Plexus.Var, BasicAnimName = "death"},
	{ID = mod.FF.Onlyfan.ID, Var = mod.FF.Onlyfan.Var, BasicAnimName = "Death!"},
	{ID = mod.FF.Temptress.ID, Var = mod.FF.Temptress.Var, CustomAnimFunc = mod.TemptressDeathAnim},
	{ID = mod.FF.Zephyr.ID, Var = mod.FF.Zephyr.Var, CustomAnimFunc = mod.ZephyrDeathAnim},
	{ID = mod.FF.TaintedCraig.ID, Var = mod.FF.TaintedCraig.Var, CustomAnimFunc = mod.TaintedCraigDeathAnim},
	{ID = mod.FF.Kablammer.ID, Var = mod.FF.Kablammer.Var, Sub = 0, CustomAnimFunc = mod.chummerDeathAnim},
	{ID = mod.FF.AntiFiend.ID, Var = mod.FF.AntiFiend.Var, CustomAnimFunc = mod.AntiFiendDeathAnim},
	{ID = mod.FF.Apocalypse.ID, Var = mod.FF.Apocalypse.Var, CustomAnimFunc = mod.ApocalypseDeathAnim},
	{ID = mod.FF.Jugular.ID, Var = mod.FF.Jugular.Var, CustomAnimFunc = mod.jugularDeathAnim},
	{ID = mod.FF.TheTerribleOni.ID, Var = mod.FF.TheTerribleOni.Var, CustomAnimFunc = mod.TheDyingOni},
	{ID = mod.FF.Partyball.ID, Var = mod.FF.Partyball.Var, CustomAnimFunc = mod.PartyballDeathAnim},
	{ID = mod.FF.Suave.ID, Var = mod.FF.Suave.Var, CustomAnimFunc = mod.SuaveDeathAnim},
	{ID = mod.FF.Laideronnette.ID, Var = mod.FF.Laideronnette.Var, CustomAnimFunc = mod.LaideronnetteDeathAnim},
	{ID = mod.FF.Level0Fly.ID, Var = mod.FF.Level0Fly.Var, BasicAnimName = "Death"},
	{ID = mod.FF.WarpCultist.ID, Var = mod.FF.WarpCultist.Var, BasicAnimName = "Death"},
	{ID = mod.FF.EarSplitter.ID, Var = mod.FF.EarSplitter.Var, CustomAnimFunc = mod.EarSplitterDeathAnim},
	{ID = mod.FF.Blubbie.ID, Var = mod.FF.Blubbie.Var, CustomAnimFunc = mod.BlubbieDeathAnim},
	{ID = mod.FF.AtomicGaper.ID, Var = mod.FF.AtomicGaper.Var, CustomAnimFunc = mod.AtomicGaperDeathAnim},
}

FiendFolio.EnemyOnDeath.SkulltistEffects = {
	{ID = mod.FF.Tagbag.ID, Var = mod.FF.Tagbag.Var, EffectFunc = mod.tagbagDeathEffect},
	{ID = mod.FF.Gunk.ID, Var = mod.FF.Gunk.Var, EffectFunc = mod.gunkDeathEffect},
	{ID = mod.FF.Punk.ID, Var = mod.FF.Punk.Var, EffectFunc = mod.gunkDeathEffect},
	{ID = mod.FF.Dogmeat.ID, Var = mod.FF.Dogmeat.Var, EffectFunc = mod.dogmeatDeathEffect},
	{ID = mod.FF.HeadHoncho.ID, Var = mod.FF.HeadHoncho.Var, EffectFunc = mod.headHonchoDeathEffect},
	{ID = mod.FF.Carrier.ID, Var = mod.FF.Carrier.Var, EffectFunc = mod.carrierDeathEffect},
	{ID = mod.FF.MiniMinMin.ID, Var = mod.FF.MiniMinMin.Var, EffectFunc = mod.miniMinDeathEffect},
	{ID = mod.FF.MamaPooter.ID, Var = mod.FF.MamaPooter.Var, EffectFunc = mod.mamaPooterDeathEffect},
	{ID = mod.FF.Melty.ID, Var = mod.FF.Melty.Var, EffectFunc = mod.meltyDeathEffect},
	{ID = mod.FF.Empath.ID, Var = mod.FF.Empath.Var, EffectFunc = mod.empathDeathEffect},
	{ID = mod.FF.Coconut.ID, Var = mod.FF.Coconut.Var, EffectFunc = mod.CoconutDeathEffect},
	{ID = mod.FF.FossilBoomFly.ID, Var = mod.FF.FossilBoomFly.Var, EffectFunc = mod.fossilizedBoomFlyDeathEffect},
	{ID = mod.FF.DreadMaw.ID, Var = mod.FF.DreadMaw.Var, EffectFunc = mod.DreadMawDeathEffect},
	{ID = mod.FF.Blastcore.ID, Var = mod.FF.Blastcore.Var, EffectFunc = mod.BlastcoreDeathEffect},
	{ID = mod.FF.Rufus.ID, Var = mod.FF.Rufus.Var, EffectFunc = mod.RufusDeathEffect},
	{ID = mod.FF.Temptress.ID, Var = mod.FF.Temptress.Var, EffectFunc = mod.TemptressDeathEffect},
	{ID = mod.FF.Nematode.ID, Var = mod.FF.Nematode.Var, EffectFunc = mod.NematodeDeathEffect},
	{ID = mod.FF.TaintedCraig.ID, Var = mod.FF.TaintedCraig.Var, EffectFunc = mod.TaintedCraigDeathEffect},
	{ID = mod.FF.AntiFiend.ID, Var = mod.FF.AntiFiend.Var, EffectFunc = mod.AntiFiendDeathEffect},
	{ID = mod.FF.Partyball.ID, Var = mod.FF.Partyball.Var, EffectFunc = mod.PartyballDeathEffect},
	{ID = mod.FF.EarSplitter.ID, Var = mod.FF.EarSplitter.Var, EffectFunc = mod.EarSplitterDeathEffect},
	{ID = mod.FF.Blubbie.ID, Var = mod.FF.Blubbie.Var, EffectFunc = mod.BlubbieDeathEffect},
	{ID = mod.FF.AtomicGaper.ID, Var = mod.FF.AtomicGaper.Var, EffectFunc = mod.AtomicGaperDeathEffect},
}

FiendFolio:ReloadAllDynamicCallbacks()
