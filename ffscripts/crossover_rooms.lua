if not REPENTOGON.MeetsVersion("1.1.2") then
	return
end

local roomMap = {
	[StbType.SPECIAL_ROOMS] = "00.special rooms",
	[StbType.BASEMENT] = "01.basement",
	[StbType.CELLAR] = "02.cellar",
	[StbType.BURNING_BASEMENT] = "03.burning basement",
	[StbType.CAVES] = "04.caves",
	[StbType.CATACOMBS] = "05.catacombs",
	[StbType.FLOODED_CAVES] = "06.flooded caves",
	[StbType.DEPTHS] = "07.depths",
	[StbType.NECROPOLIS] = "08.necropolis",
	[StbType.DANK_DEPTHS] = "09.dank depths",
	[StbType.WOMB] = "10.womb",
	[StbType.UTERO] = "11.utero",
	[StbType.SCARRED_WOMB] = "12.scarred womb",
	[StbType.BLUE_WOMB] = "13.blue womb",
	[StbType.SHEOL] = "14.sheol",
	[StbType.CATHEDRAL] = "15.cathedral",
	[StbType.DARK_ROOM] = "16.dark room",
	[StbType.CHEST] = "17.chest",
	[StbType.VOID] = "26.the void_ex",
	[StbType.DOWNPOUR] = "27.downpour",
	[StbType.DROSS] = "28.dross",
	[StbType.MINES] = "29.mines",
	[StbType.ASHPIT] = "30.ashpit",
	[StbType.MAUSOLEUM] = "31.mausoleum",
	[StbType.GEHENNA] = "32.gehenna",
	[StbType.CORPSE] = "33.corpse",
	[StbType.HOME] = "35.home",
	[StbType.ASCENT] = "36.backwards",
	[24] = "24.the shop",
}

FiendFolio:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, function()
	local compatMods = {
		bossbutch = BossButch,
		fallfromgrace = FFGRACE,
		lastjudgment = LastJudgement,  --lol
		malware = MalwareHorseman,
		retribution = Retribution,
		revelations = REVEL,
		epiphany = Epiphany,
		communityremix = communityRemix,
		sheriff = SheriffRepentogon,
		battlefantasy = battleFantasy,
		crabbyscretins = CrabbyCertins
	}
	for modName, modEnabled in pairs(compatMods) do
		if modEnabled then
			Isaac.DebugString("[FF] Loading crossover rooms for " .. modName)
			for stbType, fileName in pairs(roomMap) do
				for mode=0,1 do
					local filePath = "ff_crossover/" .. modName .. (mode == 1 and "/greed/" or "/") .. fileName .. ".stb"
					Isaac.DebugString("[FF] Loading `" .. filePath .. "`...")
					local numRooms = 0
					for k,v in pairs(RoomConfig.LoadStb(stbType, mode, filePath)) do
						numRooms = numRooms + 1
					end
					Isaac.DebugString("[FF] ...done! Loaded " .. numRooms .. " rooms.")
				end
			end
		end
	end
end)
