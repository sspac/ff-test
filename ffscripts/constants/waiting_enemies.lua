local mod = FiendFolio

--[[
	EntitiesMod subtype guide

	Offset 0, Choice 2: Subtype 1
	Offset 2, Choice 2: Subtype 4

	Offset 0, Choice 3: Subtype 2
	Offset 0, Choice 4: Subtype 4
]]

--[[
	Exclusions w/ reasons

	Singeball: 		Funny
	Thousand Eyes:	Primarily aesthetics
]]

--[[
	Potential issue entities

	Quaker (Over Rock)
	Speleo (Over Rock)
	Rancor
]]

mod.WaitingEntities = {
	["151.6.1"] 	= true, -- S'Eptic
	["155.4.4"] 	= true, -- Archer
	["160.1250.1"] 	= true, -- Buckethead
	["114.14.1"]	= true, -- Ignis
	["114.83.1"]	= true, -- Calsiketic
	["450.10.1"]	= true, -- Catfish
	["160.153.2"]	= true, -- Glob
	["160.154.2"]	= true, -- Sizzle
	["450.14.1"]	= true, -- Roasty
	["114.10.1"]	= true, -- Drillbit
	["114.18.2"] 	= true, ["114.18.4"] 	= true, -- Stalagnaught
	["114.31.1"] 	= true, ["114.31.2"] 	= true, -- Quaker
	["451.130.1"] 	= true, ["451.130.2"] 	= true,	-- Speleo
	["160.41.1"]	= true, -- Dried Offal
	["114.23.1"]	= true, -- Gritty
	["151.10.1"]	= true, -- Flinty
	["451.200.2"]	= true, -- Skitterskull
	["451.320.1"]	= true, -- Mirage
	["108.116.1"]	= true, -- Rancor
	["114.32.1"]	= true, -- Shaker
	["151.9.1"]		= true, -- Marzlammer
	["114.20.1"]	= true, -- Torment
	["450.20.1"]	= true, -- Weeper
	["834.451.1"]	= true, -- Thresher
	["155.5.4"]		= true, -- Diagetic
	["151.0.1"]		= true, -- Slammer
	["151.1.1"]		= true, -- Wimpy
	["450.23.1"]	= true, -- Shot Fly
	["450.24.1"]	= true, -- Shoter
	["450.13.1"]	= true, -- Shirk
	["151.5.1"]		= true, -- S'More
	["150.10.0"]	= true, -- Lvl 2 Spider
	["150.10.1"]	= true, -- Ticking Spider
	["150.10.2"]	= true, -- Baby Long Legs
	["150.10.3"]	= true, -- Small Baby Long Legs
	["150.10.4"]	= true, -- Crazy Long Legs
	["150.10.5"]	= true, -- Small Crazy Long Legs
	["150.10.6"]	= true, -- Full Spider
	["150.16.1"]	= true, -- Round Worm
	["150.16.2"]	= true, -- Nightcrawler
	["150.16.3"]	= true, -- Ulcer
	["150.16.4"]	= true, -- Roundy
	["150.16.5"]	= true, -- Tube Worm
	["150.16.6"]	= true, -- Parabite
	["150.16.7"]	= true, -- Scarred Parabite
	["150.16.8"]	= true, -- Drink Worm
	["150.16.9"]	= true, -- Bone Worm
	["150.16.10"]	= true, -- Lump
	["150.16.11"]	= true, -- Fred
	["150.16.12"]	= true, -- Weaver
	["150.16.13"]	= true, -- Weaver Sr.
	["150.16.14"]	= true, -- Pin
	["150.16.15"]	= true, -- Frail
	["150.16.16"]	= true, -- Scolex
	["150.16.17"]	= true, -- Kingpin
	["150.16.18"]	= true, -- Bunker Worm
	["150.16.19"]	= true, -- Drunk Worm
	["114.1004.1"]	= true, -- Polty
	["114.1004.2"]	= true, -- Needle
	["114.1004.3"]	= true, -- Pasty
	["114.1004.4"]	= true, -- Leaper
	["114.1004.5"]	= true, -- Sticky
	["114.1004.6"]	= true, -- Mr. Mine
	["114.1004.7"]	= true, -- Mole
	["114.1004.8"]	= true, -- Blasted
	["114.1004.9"]	= true, -- Wizoob
	["114.1004.10"]	= true, -- Red Ghost
	["114.1004.11"]	= true, -- Fire Worm
	["114.1004.12"]	= true, -- Tar Boy
	["114.1004.13"]	= true, -- Kineti
	["114.1004.14"]	= true, -- Dust
	["114.1004.15"]	= true, -- Adult Leech
	["114.1004.16"]	= true, -- Fat Sack
	["114.1004.17"]	= true, -- Techneedle
	["150.10.7"]	= true, -- Null
	["150.10.8"]	= true, -- Bone Knight
	["150.10.9"]	= true, -- Black Globin
	["114.39.1"]	= true, -- Hoster
	["160.40.1"]	= true, -- Offal
	["160.60.1"]	= true, -- Frog
	["160.150.1"]	= true, -- Drop
	["160.240.1"]	= true, -- Fishface
	["160.380.1"]	= true, -- Madclaw
	["450.28.2"]	= true, -- Dolphin
	["151.2.1"]		= true, -- Stone Slammer
	["151.4.1"]		= true, -- Smasher
	["160.980.1"]	= true, -- Flanks
	["451.300.1"]	= true, -- Ghastly
	["160.120.1"]	= true, -- Ribeye
	["750.140.1"]	= true, -- Cracker
	["150.14.1"]	= true, -- Gary
	["160.570.1"]	= true, -- Grater
	["114.42.1"]	= true, -- Slimer
	["155.3.4"]		= true, -- Thread
	["160.1020.1"]	= true, -- Lipoma
	["160.870.1"]	= true, -- Ms. Dominator
	["155.2.4"]		= true, -- Dread Weaver
	["151.8.1"]		= true, -- Doomer
	["114.79.1"]	= true, -- Toad
	["114.78.1"]	= true, -- Shader
	["197.806.1"]	= true, -- Paladin
}

function mod.IsWatingEntity(npc, fiendFolioOnly)
	local key = npc.Type .. "." .. npc.Variant .. "." .. npc.SubType
	return mod.WaitingEntities[key] or false
end