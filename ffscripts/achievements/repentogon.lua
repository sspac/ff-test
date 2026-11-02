local mod = FiendFolio
local json = require "json"

-- Instead of migrating our entire achievement/unlock system over to REPENTOGON, we decided to continue tracking our achievements/unlocks ourselves as before,
-- but automatically sync their state to REPENTOGON achievements so that they show up in the in-game secrets menu and so that we can support unlockable characters.
-- This code can run on file select, before FF itself actually loads its savedata.

-- Triggers the unlock of the corresponding REPENTOGON achievement for an FF achievement.
-- Makes sure that the achivement is currently locked before unlocking it if the popup is desired.
function mod:UnlockRepentogonAchievement(ffAchievement, showPopup, force)
	local rgonAchievement = Isaac.GetAchievementIdByName("FF_" .. ffAchievement)
	if rgonAchievement <= Achievement.DEAD_GOD then
		return false
	end

	local rgonData = Isaac.GetPersistentGameData()
	if showPopup and rgonData:Unlocked(rgonAchievement) then
		Isaac.ExecuteCommand("lockachievement " .. rgonAchievement)
	end
	if force then
		rgonData:Unlock(rgonAchievement, not showPopup)
	else
		rgonData:TryUnlock(rgonAchievement, not showPopup)
	end

	return true
end

-- Sync the unlock state of FF's achievements in REPENTOGON with those tracked by the mod.
local function SyncAchievements(savedata)
	local ffAchievementsDisabled = savedata and savedata.disableAchievements
	local rgonData = Isaac.GetPersistentGameData()
	local ffData = savedata and savedata.achievements or {}

	for ffAchievement, ffAchievementData in pairs(mod.ACHIEVEMENT) do
		local ffUnlocked = ffAchievementData.AlwaysUnlocked or ffData[ffAchievement]
		local rgonAchievement = Isaac.GetAchievementIdByName("FF_" .. ffAchievement)
		assert(rgonAchievement > Achievement.DEAD_GOD, "Invalid REPENTOGON achievement `FF_" .. ffAchievement .. "`")
		local rgonUnlocked = rgonData:Unlocked(rgonAchievement)

		-- Keep inaba locked ANYWAY!
		-- (At least initially, we can remove this at some point post-release...)
		-- NOTE: If this is removed, you should probably update the `CanTriggerInabaQuest` function in `erfly/misc/follow_the_rabbit.lua` too.
		local ignoreAchievementsDisabled = ffAchievement == "INABA"
			or (ffAchievement == "BINABA" and not ffData["INABA"])
		for _, tag in ipairs(ffAchievementData.Tags) do
			if not FiendFolio.ACHIEVEMENT.INABA:IsUnlocked(true) and tag == "InabaHidden" then
				ignoreAchievementsDisabled = true
				break
			end
		end

		if ignoreAchievementsDisabled or not ffAchievementsDisabled then
			if ffUnlocked and not rgonUnlocked then
				rgonData:TryUnlock(rgonAchievement, true)
			elseif not ffUnlocked and rgonUnlocked then
				Isaac.ExecuteCommand("lockachievement " .. rgonAchievement)
			end
		elseif not rgonUnlocked then
			mod.IgnoreRGONUnlock = true
			rgonData:TryUnlock(rgonAchievement, true)
			mod.IgnoreRGONUnlock = false
		end
	end

	local slippyLock = Isaac.GetAchievementIdByName("FF_SLIPPY")
	local chinaLock = Isaac.GetAchievementIdByName("FF_CHINA")
	local craigLock = Isaac.GetAchievementIdByName("FF_CRAIG")
	local classicFiendLock = Isaac.GetAchievementIdByName("FF_CLASSIC_FIEND")
	local imageLock = Isaac.GetAchievementIdByName("FF_IMAGE")
	local jokeLock = Isaac.GetAchievementIdByName("FF_JOKE_CHARACTERS")
	local familyGuyLock = Isaac.GetAchievementIdByName("FF_PEAT")

	if slippyLock == -1 or chinaLock == -1 or craigLock == -1 or classicFiendLock == -1 or imageLock == -1 or jokeLock == -1 or familyGuyLock == -1 then
		error("[FF] Invalid Bonus Character achievement!")
	end

	if FiendFolio.BonusCharacters == 0 then
		Isaac.ExecuteCommand("lockachievement " .. slippyLock)
		Isaac.ExecuteCommand("lockachievement " .. chinaLock)
		Isaac.ExecuteCommand("lockachievement " .. craigLock)
		Isaac.ExecuteCommand("lockachievement " .. classicFiendLock)
		Isaac.ExecuteCommand("lockachievement " .. imageLock)
	else
		if FiendFolio.BonusCharacters >= 1 then
			if FiendFolio.ACHIEVEMENT.SLIPPYS_ORGANS:IsUnlocked() then
				rgonData:TryUnlock(slippyLock, true)
			else
				Isaac.ExecuteCommand("lockachievement " .. slippyLock)
			end
			if FiendFolio.ACHIEVEMENT.CHINAS_BELONGINGS:IsUnlocked() then
				rgonData:TryUnlock(chinaLock, true)
			else
				Isaac.ExecuteCommand("lockachievement " .. chinaLock)
			end
			if FiendFolio.ACHIEVEMENT.CRAIGS_UNLOCKS:IsUnlocked() then
				rgonData:TryUnlock(craigLock, true)
			else
				Isaac.ExecuteCommand("lockachievement " .. craigLock)
			end
		end

		if FiendFolio.BonusCharacters >= 2 then
			if FiendFolio.ACHIEVEMENT.DEVILS_HARVEST:IsUnlocked() then
				rgonData:TryUnlock(classicFiendLock, true)
			else
				Isaac.ExecuteCommand("lockachievement " .. classicFiendLock)
			end
		else
			Isaac.ExecuteCommand("lockachievement " .. classicFiendLock)
		end

		if FiendFolio.BonusCharacters >= 3 then
			if FiendFolio.ACHIEVEMENT.IMAGES_UNLOCKS:IsUnlocked() then
				rgonData:TryUnlock(imageLock, true)
			else
				Isaac.ExecuteCommand("lockachievement " .. imageLock)
			end
		else
			Isaac.ExecuteCommand("lockachievement " .. imageLock)
		end
	end

	if FiendFolio.JokeCharacters > 0 and (FiendFolio.JokeCharacters < 704 or FiendFolio.JokeCharacters >= 999) then
		rgonData:TryUnlock(jokeLock, true)
	else
		Isaac.ExecuteCommand("lockachievement " .. jokeLock)
	end

	if FiendFolio.JokeCharacters < 999 then
		Isaac.ExecuteCommand("lockachievement " .. familyGuyLock)
	else
		rgonData:TryUnlock(familyGuyLock, true)
	end
end

-- Sets the modded character completion marks tracked by REPENTOGON (and shown in the main menu) to the ones tracked by FF.
local function SyncCompletionMarks(savedata)
	if not savedata or savedata.hasSyncedOldCompletion then return end -- This now only runs ONCE to sync old completion data, and after that any subsequent runs will use the arcane power of REPENTOGON

	for _, playerType in pairs(mod.PLAYER) do
		local playerConf = EntityConfig.GetPlayer(playerType)
		if playerConf then
			-- Create the key that this character's completion would have been saved under.
			-- Will be the same as the key created in `mod.InitCharacterCompletion()`.
			local lookup = string.lower(playerConf:GetName())
			if playerConf:IsTainted() then lookup = lookup .. "b" end

			local marks = (savedata and savedata.completion) and savedata.completion[lookup] or {}
			Isaac.SetCompletionMarks({
				PlayerType = playerType,
				MomsHeart = marks.heart or 0,
				Isaac = marks.isaac or 0,
				Satan = marks.satan or 0,
				BossRush = marks.rush or 0,
				BlueBaby = marks.bbaby or 0,
				Lamb = marks.lamb or 0,
				MegaSatan = marks.mega or 0,
				UltraGreed = marks.greed or 0,
				Hush = marks.hush or 0,
				Delirium = marks.deli or 0,
				Mother = marks.mother or 0,
				Beast = marks.beast or 0,
			})
		end
	end

	savedata.hasSyncedOldCompletion = true
end

-- This gets called when the save file is loaded + whenever FF saves its savedata.
function mod:SyncAchievementsWithRepentogon(savedata)
	SyncAchievements(savedata)
	SyncCompletionMarks(savedata)
end

-- On save file select, sync FF's achievements and completion marks with REPENTOGON.
mod:AddCallback(ModCallbacks.MC_POST_SAVESLOT_LOAD, function(_, saveSlot, isSlotSelected)
	if not isSlotSelected then return end

	-- Read directly from the json because FF itself doesn't load its save data until run start.
	local hasData = mod:HasData()
	local savedata = hasData and json.decode(mod:LoadData()) or {}

	if hasData then
		mod:tryMigratingSave(savedata)
	end

	mod:SyncAchievementsWithRepentogon(savedata)
end)
