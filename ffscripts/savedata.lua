local mod = FiendFolio
local json = require "json"
local game = Game()

mod.savedata = mod.savedata or {}
mod.gamestarted = mod.gamestarted or false

function mod.ValidateSavedataEntries(dataset)
    for _, entry in pairs(dataset) do
        mod.savedata[entry[1]] = mod.savedata[entry[1]] ~= nil and mod.savedata[entry[1]] or entry[2]
    end
end

local function LogError(err)
    err = "[FFSAVEDATA] " .. err
    Console.PrintError(err)
    Isaac.DebugString("[ERROR] " .. err)
end

function mod.IsNanOrInf(v)
    return type(v) == "number" and (v ~= v or v == math.huge or v == -math.huge)
end

local function SanitizeSaveTable(tab, visited)
    visited = visited or {}
    if visited[tab] then return end
    visited[tab] = true

    local found = false

    for k, v in pairs(tab) do
        if mod.IsNanOrInf(k) or mod.IsNanOrInf(v) then
            LogError('Found nan/inf at key "' .. tostring(k) .. '"')
            found = true
            tab[k] = nil
        elseif type(v) == "table" then
            local subfound = SanitizeSaveTable(v, visited)
            if subfound then
                LogError('... in table "' .. tostring(k) .. '"')
            end
            found = found or subfound
        end
    end

    return found
end

function mod.SaveSaveData(init) -- this isn't just SaveData because that's already a function on mod and overriding it could be :grimacing:
    if not mod.LOADED_SAVEDATA and not init then
        return
    end

    FiendFolio.savedata.config = {
        replacementsEnabled = FiendFolio.replacementsEnabled,
        legacyReplacementsEnabled = FiendFolio.legacyReplacementsEnabled,
        ModeEnabled = FiendFolio.ModeEnabled,
        TrueVoteOutcome = FiendFolio.TrueVoteOutcome,
        ShowRoomNames = FiendFolio.ShowRoomNames,
        RoomNameOpacity = FiendFolio.RoomNameOpacity,
        RoomNameScale = FiendFolio.RoomNameScale,
        ExtraVsPortraits = FiendFolio.ExtraVsPortraits,
        NameTags = FiendFolio.NameTags,
        NameTagKeybind = FiendFolio.NameTagKeybind,
        ItemsEnabled = FiendFolio.ItemsEnabled,
        CardsEnabled = FiendFolio.CardsEnabled,
        DoVanillaItemTweaks = FiendFolio.DoVanillaItemTweaks,
        GreatFortune = FiendFolio.GreatFortune,
        MonsoonName = FiendFolio.MonsoonName,
        FiendConfig = FiendFolio.FiendConfig,
        ChangeAi = FiendFolio.ChangeAi,
        RevShaderUpgrade = FiendFolio.RevShaderUpgrade,
        CardConfig = FiendFolio.CardConfig,
        ItemConfig = FiendFolio.ItemConfig,
        HotkeyConfig = FiendFolio.HotkeyConfig,
        DataHarvesting = FiendFolio.DataHarvesting,
        WackyPoopsEnabled = FiendFolio.WackyPoopsEnabled,
        CustomMusicEnabled = FiendFolio.CustomMusicEnabled,
        GatedBosses = FiendFolio.GatedBosses,
        BossPoolOverhaulEnabled = FiendFolio.BossPoolOverhaulEnabled,
        ReducedFrights = FiendFolio.ReducedFrights,
        ForcingFiendFolioBosses = FiendFolio.ForcingFiendFolioBosses,
        CustomFortunesEnabled = FiendFolio.CustomFortunesEnabled,
        CustomCursesEnabled = FiendFolio.CustomCursesEnabled,
        WomanMode = FiendFolio.WomanMode,
        ExtraChargeBar = FiendFolio.ExtraChargeBar,
        MouseGunAiming = FiendFolio.MouseGunAiming,
        DuelWinner = FiendFolio.DuelWinner,
        DoubleTapDrop = FiendFolio.DoubleTapDrop,
        BonusCharacters = FiendFolio.BonusCharacters,
        JokeCharacters = FiendFolio.JokeCharacters,
        FortunePaperOpacity = FiendFolio.FortunePaperOpacity,

        CursorOptionsVisual = FiendFolio.CursorOptionsVisual,
        CursorOptionsScale = FiendFolio.CursorOptionsScale,
        CursorOptionsRandomizer = FiendFolio.CursorOptionsRandomizer,
    }

    local psave = mod.getFieldInit(FiendFolio.savedata, 'run', 'playerSaveData', {})
    for i = 1, game:GetNumPlayers() do
        local p = Isaac.GetPlayer(i - 1)
        local data = mod:GetEntityData(p)

        local playerSave = {}
        if data.ffsavedata then
            for key, val in pairs(data.ffsavedata) do
                playerSave[key] = val
            end
        end

        psave[i] = playerSave
    end

    -- Sync achievements and completion marks with REPENTOGON before saving.
    FiendFolio:SyncAchievementsWithRepentogon(FiendFolio.savedata)

    SanitizeSaveTable(FiendFolio.savedata)

    Isaac.SaveModData(mod, json.encode(FiendFolio.savedata))
end

function mod:checkConfigSettings(savedata)
    savedata = savedata or FiendFolio.savedata
    if savedata then
        local config = FiendFolio.savedata.config
        if config then
            FiendFolio.ModeEnabled               = config.ModeEnabled or FiendFolio.ModeEnabled
            FiendFolio.TrueVoteOutcome           = config.TrueVoteOutcome or FiendFolio.TrueVoteOutcome
            FiendFolio.ShowRoomNames             = config.ShowRoomNames or FiendFolio.ShowRoomNames
            FiendFolio.RoomNameOpacity           = config.RoomNameOpacity or FiendFolio.RoomNameOpacity
            FiendFolio.RoomNameScale             = config.RoomNameScale or FiendFolio.RoomNameScale
            FiendFolio.MonsoonName               = config.MonsoonName or FiendFolio.MonsoonName
            FiendFolio.ExtraVsPortraits          = config.ExtraVsPortraits or FiendFolio.ExtraVsPortraits
            FiendFolio.NameTags                  = config.NameTags or FiendFolio.NameTags
            FiendFolio.NameTagKeybind            = config.NameTagKeybind or FiendFolio.NameTagKeybind
            FiendFolio.WomanMode                 = config.WomanMode or FiendFolio.WomanMode
            FiendFolio.ExtraChargeBar            = config.ExtraChargeBar or FiendFolio.ExtraChargeBar
            FiendFolio.MouseGunAiming            = config.MouseGunAiming or FiendFolio.MouseGunAiming
            FiendFolio.DuelWinner                = config.DuelWinner or FiendFolio.DuelWinner
            FiendFolio.BonusCharacters           = config.BonusCharacters or FiendFolio.BonusCharacters
            FiendFolio.JokeCharacters            = config.JokeCharacters or FiendFolio.JokeCharacters
            FiendFolio.CursorOptionsVisual       = config.CursorOptionsVisual or FiendFolio.CursorOptionsVisual
            FiendFolio.CursorOptionsScale        = config.CursorOptionsScale or FiendFolio.CursorOptionsScale
            FiendFolio.CursorOptionsRandomizer   = config.CursorOptionsRandomizer or FiendFolio.CursorOptionsRandomizer
            FiendFolio.FortunePaperOpacity   	 = config.FortunePaperOpacity or FiendFolio.FortunePaperOpacity

            if config.replacementsEnabled ~= nil then FiendFolio.replacementsEnabled = config.replacementsEnabled end
            if config.legacyReplacementsEnabled ~= nil then FiendFolio.legacyReplacementsEnabled = config.legacyReplacementsEnabled end
            if config.GreatFortune ~= nil then FiendFolio.GreatFortune = config.GreatFortune end
            if config.CustomFortunesEnabled ~= nil then FiendFolio.CustomFortunesEnabled = config.CustomFortunesEnabled end
            if config.CustomCursesEnabled ~= nil then FiendFolio.CustomCursesEnabled = config.CustomCursesEnabled end
            if config.ItemsEnabled ~= nil then FiendFolio.ItemsEnabled = config.ItemsEnabled end
            if config.CardsEnabled ~= nil then FiendFolio.CardsEnabled = config.CardsEnabled end
            if config.DoVanillaItemTweaks ~= nil then FiendFolio.DoVanillaItemTweaks = config.DoVanillaItemTweaks end
            if config.ChangeAi ~= nil then FiendFolio.ChangeAi = config.ChangeAi end
            if config.RevShaderUpgrade ~= nil then FiendFolio.RevShaderUpgrade = config.RevShaderUpgrade end
            if config.WackyPoopsEnabled ~= nil then FiendFolio.WackyPoopsEnabled = config.WackyPoopsEnabled end
            if config.CustomMusicEnabled ~= nil then FiendFolio.CustomMusicEnabled = config.CustomMusicEnabled end
            if config.GatedBosses ~= nil then FiendFolio.GatedBosses = config.GatedBosses end
            if config.BossPoolOverhaulEnabled ~= nil then FiendFolio.BossPoolOverhaulEnabled = config.BossPoolOverhaulEnabled end
            if config.ReducedFrights ~= nil then FiendFolio.ReducedFrights = config.ReducedFrights end
            if config.ForcingFiendFolioBosses ~= nil then FiendFolio.ForcingFiendFolioBosses = config.ForcingFiendFolioBosses end
			if config.DoubleTapDrop ~= nil then FiendFolio.DoubleTapDrop = config.DoubleTapDrop end

            FiendFolio.FiendConfig               = config.FiendConfig or FiendFolio.FiendConfig
            FiendFolio.CardConfig                = config.CardConfig or FiendFolio.CardConfig
            FiendFolio.ItemConfig                = config.ItemConfig or FiendFolio.ItemConfig
            FiendFolio.HotkeyConfig              = config.HotkeyConfig or FiendFolio.HotkeyConfig
            FiendFolio.DataHarvesting            = config.DataHarvesting or FiendFolio.DataHarvesting
        end
    end
end

function mod:tryMigratingSave(savedata, wasImported)
	mod:tryMigratingSaveToReloaded(savedata)
	mod:tryMigratingSaveToKalu(savedata, wasImported)
end

function mod:tryMigratingSaveToReloaded(savedata)
	if savedata and not (savedata.CheckedRetroactiveFiendGolemUnlocks or savedata.MigratedReheatedSave or savedata.IsReloadedSave) then
		Isaac.DebugString("Imported Fiend Folio mod save from Reheated.")
		--print("Imported Fiend Folio mod save from Reheated.")

		local rgonData = Isaac.GetPersistentGameData()
		savedata.achievements = savedata.achievements or {}
		savedata.forceAchievementToPopup = savedata.forceAchievementToPopup or {}

		-- Since Fiend and Golem are now unlockable, check once to see if someone has obtained
		-- any completion marks with either of them beforehand. If so, unlock them immediately.
		if savedata.completion then
			for _, playername in ipairs({"fiend", "golem"}) do
				if savedata.completion[playername] then
					local hasAnyMark = false
					for mark, value in pairs(savedata.completion[playername]) do
						if type(value) == "number" and value > 0 then
							hasAnyMark = true
							break
						end
					end
					if hasAnyMark or (playername == "fiend" and savedata.achievements and savedata.achievements.IMMORAL_HEART) then
						savedata.achievements[string.upper(playername)] = true
					end
				end
			end
		end

		-- some completion marks got shuffled around
		-- unlock the new achievements associated with those completion marks and relock the old ones
		savedata.achievements.LONGTIME_FIEND = savedata.achievements.DEVILS_HARVEST
		savedata.achievements.DEVILS_HARVEST = nil

		savedata.achievements.FLAMING_PENNY = savedata.achievements.COOL_SUNGLASSES
		savedata.achievements.COOL_SUNGLASSES = nil

		savedata.achievements.IMP_FINGER = savedata.achievements.CHUNK_OF_TAR
		savedata.achievements.CHUNK_OF_TAR = nil

		savedata.achievements.IMP_CURSE = savedata.achievements.MODERN_OUROBOROS
		savedata.achievements.MODERN_OUROBOROS = nil

		savedata.achievements.GOLDEN_SPIKES = savedata.achievements.NYX
		savedata.achievements.NYX = nil

		savedata.achievements.SOUL_OF_GOLEM = nil

		-- other shuffled achievements
		-- same as above
		savedata.achievements.DADS_HALF = savedata.achievements.BEAST_BEGGAR
		savedata.achievements.BEAST_BEGGAR = nil

		savedata.achievements.OLD_TESTAMENT = savedata.achievements.VENDING_MACHINE
		savedata.achievements.VENDING_MACHINE = nil

		-- challenges that were previously available
		-- check if any were previously cleared and automatically unlock and clear them
		if savedata.achievements.SLIPPYS_ORGANS then
			savedata.achievements.FROG_MODE = true
			mod:UnlockRepentogonAchievement(FiendFolio.ACHIEVEMENT.SLIPPYS_ORGANS.ID, false, true)
			Isaac.ClearChallenge(FiendFolio.challenges.frogMode)
		end

		if savedata.achievements.DEIMOS then
			savedata.achievements.ISAAC_REBUILT = true
			mod:UnlockRepentogonAchievement(FiendFolio.ACHIEVEMENT.DEIMOS.ID, false, true)
			Isaac.ClearChallenge(FiendFolio.challenges.isaacRebuilt)
		end

		if savedata.achievements.LAWN_DARTS then
			savedata.achievements.TOWER_OFFENSE = true
			mod:UnlockRepentogonAchievement(FiendFolio.ACHIEVEMENT.LAWN_DARTS.ID, false, true)
			Isaac.ClearChallenge(FiendFolio.challenges.towerOffense)
		end

		if savedata.achievements.CHINAS_BELONGINGS then
			savedata.achievements.HANDLE_WITH_CARE = true
			mod:UnlockRepentogonAchievement(FiendFolio.ACHIEVEMENT.CHINAS_BELONGINGS.ID, false, true)
			Isaac.ClearChallenge(FiendFolio.challenges.chinaShop)
		end

		if savedata.achievements.GAUNTLET_BEATEN then
			savedata.achievements.GAUNTLET = true
			mod:UnlockRepentogonAchievement(FiendFolio.ACHIEVEMENT.GAUNTLET_BEATEN.ID, false, true)
			Isaac.ClearChallenge(FiendFolio.challenges.theGauntlet)
		end

		if savedata.achievements.BRICK_SEPARATOR then
			savedata.achievements.BRICK_BY_BRICK = true
			mod:UnlockRepentogonAchievement(FiendFolio.ACHIEVEMENT.BRICK_SEPARATOR.ID, false, true)
			Isaac.ClearChallenge(FiendFolio.challenges.brickByBrick)
		end

		if savedata.achievements.GREEN_HOUSE then
			savedata.achievements.DADS_HOME = true
			mod:UnlockRepentogonAchievement(FiendFolio.ACHIEVEMENT.GREEN_HOUSE.ID, false, true)
			Isaac.ClearChallenge(FiendFolio.challenges.dadsHomePlus)
		end

		if savedata.achievements.PETRIFIED_GEL then
			savedata.achievements.DIRTY_BUBBLE = true
			mod:UnlockRepentogonAchievement(FiendFolio.ACHIEVEMENT.PETRIFIED_GEL.ID, false, true)
			Isaac.ClearChallenge(FiendFolio.challenges.dirtyBubble)
		end

		if savedata.achievements.SPARE_RIBS then
			savedata.achievements.REAL_JON = true
			mod:UnlockRepentogonAchievement(FiendFolio.ACHIEVEMENT.SPARE_RIBS.ID, false, true)
			Isaac.ClearChallenge(FiendFolio.challenges.theRealJon)
		end

		if savedata.achievements.RED_HAND then
			savedata.achievements.MR_HANDS = true
			mod:UnlockRepentogonAchievement(FiendFolio.ACHIEVEMENT.RED_HAND.ID, false, true)
			Isaac.ClearChallenge(FiendFolio.challenges.catchTheseHands)
		end

		-- gauntlet rocks
		-- check if the gauntlet was cleared and unlock these if so
		-- also force these ones to pop up cause they are special
		savedata.achievements.LOST_ARTIFACT = savedata.achievements.GAUNTLET_BEATEN
		savedata.forceAchievementToPopup.LOST_ARTIFACT = savedata.achievements.GAUNTLET_BEATEN

		savedata.achievements.RIDICULOUS_METAL = savedata.achievements.GAUNTLET_BEATEN
		savedata.forceAchievementToPopup.RIDICULOUS_METAL = savedata.achievements.GAUNTLET_BEATEN

		savedata.achievements.ATLAS_BURDEN = savedata.achievements.GAUNTLET_BEATEN
		savedata.forceAchievementToPopup.ATLAS_BURDEN = savedata.achievements.GAUNTLET_BEATEN

		savedata.achievements.POCKET_ROCKIT = savedata.achievements.GAUNTLET_BEATEN
		savedata.forceAchievementToPopup.POCKET_ROCKIT = savedata.achievements.GAUNTLET_BEATEN

		savedata.achievements.WORMHOLE_ROCK = savedata.achievements.GAUNTLET_BEATEN
		savedata.forceAchievementToPopup.WORMHOLE_ROCK = savedata.achievements.GAUNTLET_BEATEN

		-- fleas
		-- deluge and propaganda should be relocked, and flea circus by extension
		savedata.achievements.FLEA_OF_DELUGE = nil
		savedata.achievements.FLEA_OF_PROPAGANDA = nil
		savedata.achievements.FLEA_CIRCUS = nil

		savedata.MigratedReheatedSave = true
		savedata.IsReloadedSave = true
		Isaac.SaveModData(mod, json.encode(savedata))
	end
end

function mod:tryMigratingSaveToKalu(savedata, wasImported)
	if savedata and not savedata.IsKaluSave then
		Isaac.DebugString("Imported Fiend Folio mod save from Reloaded.")

		local rgonData = Isaac.GetPersistentGameData()
		savedata.achievements = savedata.achievements or {}
		savedata.forceAchievementToPopup = savedata.forceAchievementToPopup or {}

		-- golem moms heart now unlocks lil golem
		-- so if pet rock was unlocked, need to unlock lil golem and relock that
		if savedata.achievements.PET_ROCK then
			savedata.forceAchievementToPopup.LIL_GOLEM = not wasImported
			savedata.achievements.LIL_GOLEM = true
			savedata.achievements.PET_ROCK = nil
		end
		
		-- if any completion marks exist for golem or inaba, unlock their mom unlocks
		-- greed mode excluded
		if wasImported then
			if savedata.completion and savedata.completion["golem"] then
				local hasAnyMark = false
				for mark, value in pairs(savedata.completion["golem"]) do
					if mark ~= "greed" and type(value) == "number" and value > 0 then
						hasAnyMark = true
						break
					end
				end
				if hasAnyMark then
					savedata.achievements.PET_ROCK = true
				end
			end
		else
			local golemMarks = Isaac.GetCompletionMarks(FiendFolio.PLAYER.GOLEM)
			local inabaMarks = Isaac.GetCompletionMarks(FiendFolio.PLAYER.INABA)
			
			savedata.achievements.PET_ROCK = golemMarks.MomsHeart > 0 or
			                                 golemMarks.Isaac > 0 or
			                                 golemMarks.Satan > 0 or
			                                 golemMarks.BossRush > 0 or
			                                 golemMarks.BlueBaby > 0 or
			                                 golemMarks.Lamb > 0 or
			                                 golemMarks.MegaSatan > 0 or
			                                 golemMarks.Hush > 0 or
			                                 golemMarks.Delirium > 0 or
			                                 golemMarks.Mother > 0 or
			                                 golemMarks.Beast > 0 or
			                                 mod:HasFiendishFoesCompletionMark(FiendFolio.PLAYER.GOLEM)
			
			if inabaMarks.MomsHeart > 0 or inabaMarks.Isaac > 0 or inabaMarks.Satan > 0 or
			   inabaMarks.BossRush > 0 or inabaMarks.BlueBaby > 0 or inabaMarks.Lamb > 0 or
			   inabaMarks.MegaSatan > 0 or inabaMarks.Hush > 0 or inabaMarks.Delirium > 0 or
			   inabaMarks.Mother > 0 or inabaMarks.Beast > 0 or
			   mod:HasFiendishFoesCompletionMark(FiendFolio.PLAYER.INABA)
			then
				savedata.forceAchievementToPopup.ICE_IX = not wasImported
				savedata.achievements.ICE_IX = true
			end
		end

		savedata.MigratedReheatedSave = true
		savedata.IsReloadedSave = true
		savedata.IsKaluSave = true
		Isaac.SaveModData(mod, json.encode(savedata))
	end
end

function mod:MigratedAchievementsCheck()
	FiendFolio.savedata.achievements = FiendFolio.savedata.achievements or {}
	FiendFolio.savedata.forceAchievementToPopup = FiendFolio.savedata.forceAchievementToPopup or {}
	if FiendFolio.savedata.forceAchievementToPopup.FIEND then
		FiendFolio.savedata.achievements.FIEND = nil
		FiendFolio.ACHIEVEMENT.FIEND:Unlock()
		FiendFolio.savedata.forceAchievementToPopup.FIEND = nil
	end

	if FiendFolio.savedata.forceAchievementToPopup.GOLEM then
		FiendFolio.savedata.achievements.GOLEM = nil
		FiendFolio.ACHIEVEMENT.GOLEM:Unlock()
		FiendFolio.savedata.forceAchievementToPopup.GOLEM = nil
	end

	if FiendFolio.savedata.forceAchievementToPopup.LONGTIME_FIEND then
		FiendFolio.savedata.achievements.LONGTIME_FIEND = nil
		FiendFolio.ACHIEVEMENT.LONGTIME_FIEND:Unlock()
		FiendFolio.savedata.forceAchievementToPopup.LONGTIME_FIEND = nil
	end

	if FiendFolio.savedata.forceAchievementToPopup.FLAMING_PENNY then
		FiendFolio.savedata.achievements.FLAMING_PENNY = nil
		FiendFolio.ACHIEVEMENT.FLAMING_PENNY:Unlock()
		FiendFolio.savedata.forceAchievementToPopup.FLAMING_PENNY = nil
	end

	if FiendFolio.savedata.forceAchievementToPopup.IMP_FINGER then
		FiendFolio.savedata.achievements.IMP_FINGER = nil
		FiendFolio.ACHIEVEMENT.IMP_FINGER:Unlock()
		FiendFolio.savedata.forceAchievementToPopup.IMP_FINGER = nil
	end

	if FiendFolio.savedata.forceAchievementToPopup.IMP_CURSE then
		FiendFolio.savedata.achievements.IMP_CURSE = nil
		FiendFolio.ACHIEVEMENT.IMP_CURSE:Unlock()
		FiendFolio.savedata.forceAchievementToPopup.IMP_CURSE = nil
	end

	if FiendFolio.savedata.forceAchievementToPopup.GOLDEN_SPIKES then
		FiendFolio.savedata.achievements.GOLDEN_SPIKES = nil
		FiendFolio.ACHIEVEMENT.GOLDEN_SPIKES:Unlock()
		FiendFolio.savedata.forceAchievementToPopup.GOLDEN_SPIKES = nil
	end

	if FiendFolio.savedata.forceAchievementToPopup.HANDLE_WITH_CARE then
		FiendFolio.savedata.achievements.HANDLE_WITH_CARE = nil
		FiendFolio.ACHIEVEMENT.HANDLE_WITH_CARE:Unlock()
		FiendFolio.savedata.forceAchievementToPopup.HANDLE_WITH_CARE = nil
	end

	if FiendFolio.savedata.forceAchievementToPopup.DADS_HOME then
		FiendFolio.savedata.achievements.DADS_HOME = nil
		FiendFolio.ACHIEVEMENT.DADS_HOME:Unlock()
		FiendFolio.savedata.forceAchievementToPopup.DADS_HOME = nil
	end

	if FiendFolio.savedata.forceAchievementToPopup.MR_HANDS then
		FiendFolio.savedata.achievements.MR_HANDS = nil
		FiendFolio.ACHIEVEMENT.MR_HANDS:Unlock()
		FiendFolio.savedata.forceAchievementToPopup.MR_HANDS = nil
	end

	if FiendFolio.savedata.forceAchievementToPopup.FROG_MODE then
		FiendFolio.savedata.achievements.FROG_MODE = nil
		FiendFolio.ACHIEVEMENT.FROG_MODE:Unlock()
		FiendFolio.savedata.forceAchievementToPopup.FROG_MODE = nil
	end

	if FiendFolio.savedata.forceAchievementToPopup.DIRTY_BUBBLE then
		FiendFolio.savedata.achievements.DIRTY_BUBBLE = nil
		FiendFolio.ACHIEVEMENT.DIRTY_BUBBLE:Unlock()
		FiendFolio.savedata.forceAchievementToPopup.DIRTY_BUBBLE = nil
	end

	if FiendFolio.savedata.forceAchievementToPopup.REAL_JON then
		FiendFolio.savedata.achievements.REAL_JON = nil
		FiendFolio.ACHIEVEMENT.REAL_JON:Unlock()
		FiendFolio.savedata.forceAchievementToPopup.REAL_JON = nil
	end

	if FiendFolio.savedata.forceAchievementToPopup.BRICK_BY_BRICK then
		FiendFolio.savedata.achievements.BRICK_BY_BRICK = nil
		FiendFolio.ACHIEVEMENT.BRICK_BY_BRICK:Unlock()
		FiendFolio.savedata.forceAchievementToPopup.BRICK_BY_BRICK = nil
	end

	if FiendFolio.savedata.forceAchievementToPopup.TOWER_OFFENSE then
		FiendFolio.savedata.achievements.TOWER_OFFENSE = nil
		FiendFolio.ACHIEVEMENT.TOWER_OFFENSE:Unlock()
		FiendFolio.savedata.forceAchievementToPopup.TOWER_OFFENSE = nil
	end

	if FiendFolio.savedata.forceAchievementToPopup.ISAAC_REBUILT then
		FiendFolio.savedata.achievements.ISAAC_REBUILT = nil
		FiendFolio.ACHIEVEMENT.ISAAC_REBUILT:Unlock()
		FiendFolio.savedata.forceAchievementToPopup.ISAAC_REBUILT = nil
	end

	if FiendFolio.savedata.forceAchievementToPopup.GAUNTLET then
		FiendFolio.savedata.achievements.GAUNTLET = nil
		FiendFolio.ACHIEVEMENT.GAUNTLET:Unlock()
		FiendFolio.savedata.forceAchievementToPopup.GAUNTLET = nil
	end

	if FiendFolio.savedata.forceAchievementToPopup.LOST_ARTIFACT then
		FiendFolio.savedata.achievements.LOST_ARTIFACT = nil
		FiendFolio.ACHIEVEMENT.LOST_ARTIFACT:Unlock()
		FiendFolio.savedata.forceAchievementToPopup.LOST_ARTIFACT = nil
	end

	if FiendFolio.savedata.forceAchievementToPopup.RIDICULOUS_METAL then
		FiendFolio.savedata.achievements.RIDICULOUS_METAL = nil
		FiendFolio.ACHIEVEMENT.RIDICULOUS_METAL:Unlock()
		FiendFolio.savedata.forceAchievementToPopup.RIDICULOUS_METAL = nil
	end

	if FiendFolio.savedata.forceAchievementToPopup.ATLAS_BURDEN then
		FiendFolio.savedata.achievements.ATLAS_BURDEN = nil
		FiendFolio.ACHIEVEMENT.ATLAS_BURDEN:Unlock()
		FiendFolio.savedata.forceAchievementToPopup.ATLAS_BURDEN = nil
	end

	if FiendFolio.savedata.forceAchievementToPopup.POCKET_ROCKIT then
		FiendFolio.savedata.achievements.POCKET_ROCKIT = nil
		FiendFolio.ACHIEVEMENT.POCKET_ROCKIT:Unlock()
		FiendFolio.savedata.forceAchievementToPopup.POCKET_ROCKIT = nil
	end

	if FiendFolio.savedata.forceAchievementToPopup.WORMHOLE_ROCK then
		FiendFolio.savedata.achievements.WORMHOLE_ROCK = nil
		FiendFolio.ACHIEVEMENT.WORMHOLE_ROCK:Unlock()
		FiendFolio.savedata.forceAchievementToPopup.WORMHOLE_ROCK = nil
	end

	if FiendFolio.savedata.forceAchievementToPopup.DADS_HALF then
		FiendFolio.savedata.achievements.DADS_HALF = nil
		FiendFolio.ACHIEVEMENT.DADS_HALF:Unlock()
		FiendFolio.savedata.forceAchievementToPopup.DADS_HALF = nil
	end

	if FiendFolio.savedata.forceAchievementToPopup.OLD_TESTAMENT then
		FiendFolio.savedata.achievements.OLD_TESTAMENT = nil
		FiendFolio.ACHIEVEMENT.OLD_TESTAMENT:Unlock()
		FiendFolio.savedata.forceAchievementToPopup.OLD_TESTAMENT = nil
	end

	if FiendFolio.savedata.forceAchievementToPopup.LIL_GOLEM then
		FiendFolio.savedata.achievements.LIL_GOLEM = nil
		FiendFolio.ACHIEVEMENT.LIL_GOLEM:Unlock()
		FiendFolio.savedata.forceAchievementToPopup.LIL_GOLEM = nil
	end

	if FiendFolio.savedata.forceAchievementToPopup.ICE_IX then
		FiendFolio.savedata.achievements.ICE_IX = nil
		FiendFolio.ACHIEVEMENT.ICE_IX:Unlock()
		FiendFolio.savedata.forceAchievementToPopup.ICE_IX = nil
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.MigratedAchievementsCheck)

function mod:tryImportSaveDataFromReheated()
	if Isaac.LoadModDataFromFolder then
		local reheatedSave = Isaac.LoadModDataFromFolder("fiendfolio-reheated")
		if reheatedSave ~= nil then
			FiendFolio.savedata = json.decode(reheatedSave)
			mod:tryMigratingSave(FiendFolio.savedata, true)
			FiendFolio:checkConfigSettings(savedata)
			return true
		end
	end
	return false
end

function mod:initKilledBosses()
	if not FiendFolio.savedata.killedBosses then
		FiendFolio.savedata.killedBosses = {}
		FiendFolio.savedata.killedBosses["Buck"] = false
		FiendFolio.savedata.killedBosses["FoozTwins"] = false
		FiendFolio.savedata.killedBosses["Honeydrop"] = false
		FiendFolio.savedata.killedBosses["Whispers"] = false
		FiendFolio.savedata.killedBosses["GriddleHorn"] = false
		FiendFolio.savedata.killedBosses["Buster"] = false
		FiendFolio.savedata.killedBosses["Meltdown"] = false
		FiendFolio.savedata.killedBosses["Battie"] = false
		FiendFolio.savedata.killedBosses["Kingpin"] = false
		FiendFolio.savedata.killedBosses["Slinger"] = false
		FiendFolio.savedata.killedBosses["Monsoon"] = false
		FiendFolio.savedata.killedBosses["Aquagob"] = false
		FiendFolio.savedata.killedBosses["Deluge"] = false
		FiendFolio.savedata.killedBosses["Organization"] = false
		FiendFolio.savedata.killedBosses["Gutso"] = false
		FiendFolio.savedata.killedBosses["Luncheon"] = false
		FiendFolio.savedata.killedBosses["Pollution"] = false
		FiendFolio.savedata.killedBosses["Tsar"] = false
		FiendFolio.savedata.killedBosses["Junkstrap"] = false
		FiendFolio.savedata.killedBosses["Basco"] = false
		FiendFolio.savedata.killedBosses["Peeping"] = false
		FiendFolio.savedata.killedBosses["TheSun"] = false
		FiendFolio.savedata.killedBosses["Cacophobia"] = false
		FiendFolio.savedata.killedBosses["Propaganda"] = false
		FiendFolio.savedata.killedBosses["Ghostbuster"] = false
		FiendFolio.savedata.killedBosses["Raymond"] = false
		FiendFolio.savedata.killedBosses["Cacamancer"] = false
		FiendFolio.savedata.killedBosses["HighAmon"] = false
		FiendFolio.savedata.killedBosses["Dusk"] = false
		FiendFolio.savedata.killedBosses["WarpZone"] = false
		FiendFolio.savedata.killedBosses["Madomme"] = false
		FiendFolio.savedata.killedBosses["Idolator"] = false
		FiendFolio.savedata.killedBosses["MrDead"] = false
		FiendFolio.savedata.killedBosses["BabyBubbles"] = false
		FiendFolio.savedata.killedBosses["Mo"] = false
		FiendFolio.savedata.killedBosses["Psion"] = false
		FiendFolio.savedata.killedBosses["Gravedigger"] = false
	end
end

local function SanitizeJsonData(rawdata, valuematcher)
	local replacements = {}
	for key, value in string.gmatch(rawdata, '"([^"]+)":(' .. valuematcher .. ')') do
		LogError("Found `" .. value .. "` in savedata under key: " .. key)
		local old = '"' .. key .. '":' .. valuematcher
		local new = '"' .. key .. '":0'
		replacements[old] = new
	end
	for old, new in pairs(replacements) do
		rawdata = string.gsub(rawdata, old, new)
	end
	return rawdata
end

function mod.LoadSaveData(skipUnlocks)
	mod.LOADED_SAVEDATA = false

    if not mod:HasData() then
		if not mod:tryImportSaveDataFromReheated() then
			FiendFolio.savedata = {}
			FiendFolio.savedata.IsReloadedSave = true
			FiendFolio.savedata.IsKaluSave = true
			FiendFolio.SaveSaveData(true)
			Isaac.DebugString("Fiend Folio mod save initialisation.")
			--print("Fiend Folio mod save initialisation.")
		end
    else
		local rawdata = mod:LoadData()
		rawdata = SanitizeJsonData(rawdata, '%-?nan%(ind%)')
		rawdata = SanitizeJsonData(rawdata, '%-?inf')
        FiendFolio.savedata = json.decode(rawdata)
		mod:tryMigratingSave(FiendFolio.savedata)
        FiendFolio:checkConfigSettings(savedata)
    end

    -- Misc entry validations
    mod.ValidateSavedataEntries({
        {"risksRewardIndexData",    {}},
        {"levelEntityPersistence",  {}},
        {"direChestConvertChance",  1/128},
        {"hasBeatenSlinger",        false},
        {"bossWeightMode",          1},
        {"bossWeightCutoff",        1},
    })


    -- Unlocks initialisation
    mod.ValidateSavedataEntries({
        {"shownUnlocksChoicePopup", false},
        {"disableAchievements",     false},
        {"achievements",            {}},
		{"recentAchievements", 		{}},
        {"mechaSatanCompletion",    {}},

        -- Unlock stat trackers
        {"immoralMinionKills",    0},
        {"skippedRooms",          0},
        {"cursedPennyPickups",    0},
        {"meltdownKills",         0},
        {"delugeKills",           0},
        {"pollutionKills",        0},
        {"propagandaKills",       0},
        {"foolsGoldBombed",       0},
        {"pressedRewardPlates",   0},
        {"maliceKills",           0},
        {"tmtrainerIdsUsed",      {}},
        {"timesPlayerTookDamage", 0},
        {"bubblesPopped",         0},
        --{"greedTimerStopped",     0},
        {"puzzleLocksUnlocked",   0},
        {"fortunesSeen",          0},
        {"compostBinsPopped",     0},
        {"redRoomsVisited",       0},
        {"hauntedPennyPickups",   0},
        {"virtuesWispKills",      0},
        {"mysteryGiftsUsed",      0},
        {"pillsUsed",             0},
		{"pennyPressesUsed",      0},

        {"honeyedRoomsPerfect",    0},
        {"smokyRoomsPerfect",      0},
        {"primordialRoomsPerfect", 0},
        {"pipesRoomsPerfect",      0},
        {"trashRoomsPerfect",      0},
        {"eyeballRoomsPerfect",    0},
        {"psionicRoomsPerfect",    0},
        {"surrealRoomsPerfect",    0},
        {"peepeeRoomsPerfect",     0},
        {"irradiatedRoomsPerfect", 0},
        {"othersideRoomsPerfect",  0},
        {"morbusRoomsPerfect",     0},

		{"beatMomAsFiend",  false},
		{"beatMomAsGolem",  false},
		{"beatMomAsFriend", false},
		{"beatMomAsInaba",  false},

		{"usedDiceRoom1Pip",  false},
		{"usedDiceRoom2Pip",  false},
		{"usedDiceRoom3Pip",  false},
		{"usedDiceRoom4Pip",  false},
		{"usedDiceRoom5Pip",  false},
		{"usedDiceRoom6Pip",  false},
		{"usedDiceRoom12Pip", false},
    })
	mod:initKilledBosses()

    mod.LOADED_SAVEDATA = true
end

function mod.ResetNewRunSaveData()
    mod.savedata.run = {}
    mod.bubbleKillCounter = 0
    mod.motherFollowing = nil

    mod.savedata.tmtrainerIdsUsed = {}
    mod.savedata.risksRewardIndexData = {}
    mod.savedata.levelEntityPersistence = {}
    mod.savedata.direChestConvertChance = 1/256
    mod.savedata.cardRngSeed = nil
    mod.savedata.GateCurseKeyCollected = nil
    mod.savedata.GateCurseDoorIsUnlocked = false
    mod.savedata.TriggeredGateKeySpawnFailsafe = false
    mod.savedata.TriggeredGateDoorFailsafe = false
    mod.savedata.GateCurseRoomListIndex = nil
    mod.savedata.GateCurseRoomSubtype = nil

    for _, customPoolData in pairs(mod.CustomPool) do
        mod.savedata[customPoolData[1] .. "Recycled"] = false
    end

    FiendFolio.savedata.CustomHealthAPISave = nil
end

-- Needs to run before FF actually saves its data
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.ON_SAVE, function(_, savedata, isPreGameExit)
    FiendFolio.savedata.CustomHealthAPISave = savedata
end)

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.ON_LOAD, function()
    return FiendFolio.savedata.CustomHealthAPISave
end)

mod:AddCallback(ModCallbacks.MC_POST_SAVESLOT_LOAD, function(_, slot, isSelected, rawSlot)
    if isSelected then
        Isaac.DebugString("PREFFSAVELOAD")
        mod.LoadSaveData()
        Isaac.DebugString("POSTFFSAVELOAD")
    end
end)

-- Needs to run after `CustomHealthAPI.Enums.Callbacks.ON_SAVE`
mod:AddPriorityCallback(ModCallbacks.MC_PRE_GAME_EXIT, 1000, function(_, shouldSave)
    Isaac.DebugString("PREGAMEEXIT")
    if not game:AchievementUnlocksDisallowed() then
        mod:handleSecretStash()
		mod:iouPreExit()
    end
    Isaac.DebugString("PREGAMEEXITPRESAVE")

    if not shouldSave then
        FiendFolio.savedata.run = {} -- This wasn't getting cleared prior to MC_PRE_LEVEL_PLACE_ROOM before
    end

    FiendFolio.SaveSaveData()
    mod.LOADED_SAVEDATA = false
    Isaac.DebugString("PREGAMEEXITPOSTSAVE")
    FiendFolio.gamestarted = false
end)

mod:AddCallback(ModCallbacks.MC_POST_GAME_END, function()
    FiendFolio.gamestarted = false
end)

-- MC_POST_GAME_STARTED is called after MC_POST_NEW_ROOM and MC_POST_NEW_LEVEL, which is often too late
-- This, miraculously, is called before either of those, which lets us reset savedata before it may need to be accessed
mod:AddPriorityCallback(ModCallbacks.MC_POST_PLAYER_INIT, CallbackPriority.IMPORTANT, function()
    if Isaac.CountEntities(nil, EntityType.ENTITY_PLAYER) == 0 then
        if not mod.LOADED_SAVEDATA then -- Failsafe
            mod.LoadSaveData()
        end

        if game:GetFrameCount() == 0 then
            mod.ResetNewRunSaveData()
        end

        mod.UpdateChallengeDestinationIcon()
    end
end)

mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_INIT, function()
	if not mod.LOADED_SAVEDATA then -- Failsafe
        mod.LoadSaveData()
    end

    -- mod.savedata.run.level resets on MC_POST_NEW_LEVEL
    -- That callback is called after some other callbacks such as MC_POST_NEW_ROOM, which makes it potentially risky to use
    -- mod.savedata.level2 is reset upon entering the trapdoor to a new level, meaning the table is emptied before the new level is initialised

    -- Use mod.savedata.run.level if you need to access this level's data between entering the trapdoor and the full generation of the next level's room set
    -- Use mod.savedata.level2 if you might need to cache information during this level's layout generation, or during the initialisation of the first room on the floor
	mod.savedata.level2 = {}
end)