local mod = FiendFolio
local game = Game()

local playerTypeRedirect = {
	[PlayerType.PLAYER_BLACKJUDAS] = PlayerType.PLAYER_JUDAS,
	[PlayerType.PLAYER_LAZARUS2]   = PlayerType.PLAYER_LAZARUS,
	[PlayerType.PLAYER_THESOUL]    = PlayerType.PLAYER_THEFORGOTTEN,
	[PlayerType.PLAYER_ESAU]       = PlayerType.PLAYER_JACOB,
	[PlayerType.PLAYER_LAZARUS2_B] = PlayerType.PLAYER_LAZARUS_B,
	[PlayerType.PLAYER_THESOUL_B]  = PlayerType.PLAYER_THEFORGOTTEN_B,
	[PlayerType.PLAYER_JACOB2_B]   = PlayerType.PLAYER_JACOB_B,
}

local soulstoneTaintedMembers = {
	[CompletionType.BOSS_RUSH] = true,
	[CompletionType.HUSH] = true,
}

local polaroidNegativeTaintedMembers = {
	[CompletionType.ISAAC] = true,
	[CompletionType.SATAN] = true,
	[CompletionType.BLUE_BABY] = true,
	[CompletionType.LAMB] = true,
}

local hardModeMarks = {
	[CompletionType.MOMS_HEART] = true,
	[CompletionType.ULTRA_GREEDIER] = true,
}

local function getEasiestCompletedMark(playerType)
	local lowest = 3
	for i = CompletionType.MOMS_HEART, CompletionType.BEAST do
		if i ~= 8 and i ~= 10 then -- We seriously need to consider killing Tyrone Nicalis Rodriguez
			local mark = Isaac.GetCompletionMark(playerType, i)
			if mark < lowest then
				lowest = mark
			end
		end
	end

	return lowest
end

local associatedPlayerTypes = {
	mod.PLAYER.FIEND,
	mod.PLAYER.BIEND,
	mod.PLAYER.GOLEM,
	mod.PLAYER.BOLEM,
	mod.PLAYER.FRIEND,
	mod.PLAYER.BRIEND,
	mod.PLAYER.INABA,
	mod.PLAYER.BINABA,
	mod.PLAYER.SKELETAL_FIEND,
}

local playerAchievements = {
	[mod.PLAYER.FIEND] = {
		[CompletionType.MOMS_HEART] 	= mod.ACHIEVEMENT.LIL_FIEND,
		[CompletionType.ISAAC] 			= mod.ACHIEVEMENT.IMP_SODA,
		[CompletionType.SATAN] 			= mod.ACHIEVEMENT.FIEND_MIX,
		[CompletionType.BOSS_RUSH] 		= mod.ACHIEVEMENT.GMO_CORN,
		[CompletionType.BLUE_BABY] 		= mod.ACHIEVEMENT.HEART_OF_CHINA,
		[CompletionType.LAMB] 			= mod.ACHIEVEMENT.PRANK_COOKIE,
		[CompletionType.MEGA_SATAN] 	= mod.ACHIEVEMENT.PYROMANCY,
		[CompletionType.ULTRA_GREED] 	= mod.ACHIEVEMENT.FLAMING_PENNY,
		[CompletionType.HUSH] 			= mod.ACHIEVEMENT.PLUS_3_FIREBALLS,
		[CompletionType.ULTRA_GREEDIER] = mod.ACHIEVEMENT.JACK_CARDS,
		[CompletionType.DELIRIUM] 		= mod.ACHIEVEMENT.FIENDS_HORN,
		[CompletionType.MOTHER] 		= mod.ACHIEVEMENT.LONGTIME_FIEND,
		[CompletionType.BEAST] 			= mod.ACHIEVEMENT.FETAL_FIEND,
		All = mod.ACHIEVEMENT.FIEND_FOLIO,
	},
	[mod.PLAYER.BIEND] = {
		[CompletionType.ISAAC] 			= mod.ACHIEVEMENT.IMP_FINGER,
		[CompletionType.SATAN] 			= mod.ACHIEVEMENT.IMP_FINGER,
		[CompletionType.BOSS_RUSH] 		= mod.ACHIEVEMENT.SOUL_OF_FIEND,
		[CompletionType.BLUE_BABY] 		= mod.ACHIEVEMENT.IMP_FINGER,
		[CompletionType.LAMB] 			= mod.ACHIEVEMENT.IMP_FINGER,
		[CompletionType.MEGA_SATAN] 	= mod.ACHIEVEMENT.GOLDEN_SLOT_MACHINE,
		[CompletionType.HUSH] 			= mod.ACHIEVEMENT.SOUL_OF_FIEND,
		[CompletionType.ULTRA_GREEDIER] = mod.ACHIEVEMENT.REVERSE_3_FIREBALLS,
		[CompletionType.DELIRIUM] 		= mod.ACHIEVEMENT.MALICE,
		[CompletionType.MOTHER] 		= mod.ACHIEVEMENT.HATRED,
		[CompletionType.BEAST] 			= mod.ACHIEVEMENT.IMP_CURSE,
	},
	[mod.PLAYER.GOLEM] = {
		[CompletionType.MOMS_HEART] 	= mod.ACHIEVEMENT.LIL_GOLEM,
		[CompletionType.ISAAC] 			= mod.ACHIEVEMENT.GOLEMS_ROCK,
		[CompletionType.SATAN] 			= mod.ACHIEVEMENT.CHERRY_BOMB,
		[CompletionType.BOSS_RUSH] 		= mod.ACHIEVEMENT.SOLEMN_VOW,
		[CompletionType.BLUE_BABY] 		= mod.ACHIEVEMENT.GOLEMS_ORB,
		[CompletionType.LAMB] 			= mod.ACHIEVEMENT.BRIDGE_BOMBS,
		[CompletionType.MEGA_SATAN] 	= mod.ACHIEVEMENT.MASSIVE_AMETHYST,
		[CompletionType.ULTRA_GREED] 	= mod.ACHIEVEMENT.MOLTEN_PENNY,
		[CompletionType.HUSH] 			= mod.ACHIEVEMENT.DICE_GOBLIN,
		[CompletionType.ULTRA_GREEDIER] = mod.ACHIEVEMENT.GOLDEN_SPIKES,
		[CompletionType.DELIRIUM] 		= mod.ACHIEVEMENT.PERFECTLY_GENERIC_OBJECT,
		[CompletionType.MOTHER] 		= mod.ACHIEVEMENT.ETERNAL_D12,
		[CompletionType.BEAST] 			= mod.ACHIEVEMENT.ASTROPULVIS,
		All = mod.ACHIEVEMENT.SNOW_GLOBE,
	},
	[mod.PLAYER.BOLEM] = {
		[CompletionType.ISAAC] 			= mod.ACHIEVEMENT.WAVEBREAKER,
		[CompletionType.SATAN] 			= mod.ACHIEVEMENT.WAVEBREAKER,
		[CompletionType.BOSS_RUSH] 		= mod.ACHIEVEMENT.SOUL_OF_GOLEM,
		[CompletionType.BLUE_BABY] 		= mod.ACHIEVEMENT.WAVEBREAKER,
		[CompletionType.LAMB] 			= mod.ACHIEVEMENT.WAVEBREAKER,
		[CompletionType.MEGA_SATAN] 	= mod.ACHIEVEMENT.BLASPHEMOUS_TRINKETS,
		[CompletionType.HUSH] 			= mod.ACHIEVEMENT.SOUL_OF_GOLEM,
		[CompletionType.ULTRA_GREEDIER] = mod.ACHIEVEMENT.REVERSE_KING_OF_PENTACLES,
		[CompletionType.DELIRIUM] 		= mod.ACHIEVEMENT.MAMMONITE_CODEX,
		[CompletionType.MOTHER] 		= mod.ACHIEVEMENT.SISYPHEAN_BOULDER,
		[CompletionType.BEAST] 			= mod.ACHIEVEMENT.AZURITE_SPINDOWN,
	},
	[mod.PLAYER.FRIEND] = {
		[CompletionType.MOMS_HEART] 	= mod.ACHIEVEMENT.LIL_FRIEND,
		[CompletionType.ISAAC] 			= mod.ACHIEVEMENT.IMP_SODA_CHERRY,
		[CompletionType.SATAN] 			= mod.ACHIEVEMENT.CONTRA_BAND,
		[CompletionType.BOSS_RUSH] 		= mod.ACHIEVEMENT.HOW_TO_ROLL,
		[CompletionType.BLUE_BABY] 		= mod.ACHIEVEMENT.RUBBER_BULLETS,
		[CompletionType.LAMB] 			= mod.ACHIEVEMENT.SWALLOWED_M90,
		[CompletionType.MEGA_SATAN] 	= mod.ACHIEVEMENT.BULLET_HELL,
		[CompletionType.ULTRA_GREED] 	= mod.ACHIEVEMENT.SNAGS,
		[CompletionType.HUSH] 			= mod.ACHIEVEMENT.OLD_SHELL,
		[CompletionType.ULTRA_GREEDIER] = mod.ACHIEVEMENT.DYNAMITE_PACK,
		[CompletionType.DELIRIUM] 		= mod.ACHIEVEMENT.FIREBALL_FORMULA,
		[CompletionType.MOTHER] 		= mod.ACHIEVEMENT.RAILDRIVER,
		[CompletionType.BEAST] 			= mod.ACHIEVEMENT.FETAL_FRIEND,
		All = mod.ACHIEVEMENT.GRANDPAS_GATLING_GUN,
	},
	[mod.PLAYER.BRIEND] = {
		[CompletionType.ISAAC] 			= mod.ACHIEVEMENT.AMMO_CLIP,
		[CompletionType.SATAN] 			= mod.ACHIEVEMENT.AMMO_CLIP,
		[CompletionType.BOSS_RUSH] 		= mod.ACHIEVEMENT.SOUL_OF_FRIEND,
		[CompletionType.BLUE_BABY] 		= mod.ACHIEVEMENT.AMMO_CLIP,
		[CompletionType.LAMB] 			= mod.ACHIEVEMENT.AMMO_CLIP,
		[CompletionType.MEGA_SATAN] 	= mod.ACHIEVEMENT.SALOON,
		[CompletionType.HUSH] 			= mod.ACHIEVEMENT.SOUL_OF_FRIEND,
		[CompletionType.ULTRA_GREEDIER] = mod.ACHIEVEMENT.MISPRINTED_JOKER,
		[CompletionType.DELIRIUM] 		= mod.ACHIEVEMENT.GUNSLINGERS_GRIT,
		[CompletionType.MOTHER] 		= mod.ACHIEVEMENT.DADS_USB,
		[CompletionType.BEAST] 			= mod.ACHIEVEMENT.MYSTERIOUS_FEDORA,
	},
	[mod.PLAYER.INABA] = {
		[CompletionType.MOMS_HEART] 	= mod.ACHIEVEMENT.LIL_INABA,
		[CompletionType.ISAAC] 			= mod.ACHIEVEMENT.ACUPUNCTURE_NEEDLES,
		[CompletionType.SATAN] 			= mod.ACHIEVEMENT.PARANOIA,
		[CompletionType.BOSS_RUSH] 		= mod.ACHIEVEMENT.SANGUINE_SALIVATION,
		[CompletionType.BLUE_BABY] 		= mod.ACHIEVEMENT.CRUSHING_ANXIETY,
		[CompletionType.LAMB] 			= mod.ACHIEVEMENT.PHOENIX_ELIXIR,
		[CompletionType.MEGA_SATAN] 	= mod.ACHIEVEMENT.GREEN_BOMBS,
		[CompletionType.ULTRA_GREED] 	= mod.ACHIEVEMENT.SERTRALINE,
		[CompletionType.HUSH] 			= mod.ACHIEVEMENT.HYPERFIXATION,
		[CompletionType.ULTRA_GREEDIER] = mod.ACHIEVEMENT.REPRESSION,
		[CompletionType.DELIRIUM] 		= mod.ACHIEVEMENT.ISOLATED,
		[CompletionType.MOTHER] 		= mod.ACHIEVEMENT.BOUNDLESS_PARASOL,
		[CompletionType.BEAST] 			= mod.ACHIEVEMENT.DUMB_BUNNY,
		All = mod.ACHIEVEMENT.RABBITS_FOOT,
	},
	[mod.PLAYER.BINABA] = {
		[CompletionType.ISAAC] 			= mod.ACHIEVEMENT.LUNATIC_EYE,
		[CompletionType.SATAN] 			= mod.ACHIEVEMENT.LUNATIC_EYE,
		[CompletionType.BOSS_RUSH] 		= mod.ACHIEVEMENT.SOUL_OF_INABA,
		[CompletionType.BLUE_BABY] 		= mod.ACHIEVEMENT.LUNATIC_EYE,
		[CompletionType.LAMB] 			= mod.ACHIEVEMENT.LUNATIC_EYE,
		[CompletionType.MEGA_SATAN] 	= mod.ACHIEVEMENT.SOUL_SHARD,
		[CompletionType.HUSH] 			= mod.ACHIEVEMENT.SOUL_OF_INABA,
		[CompletionType.ULTRA_GREEDIER] = mod.ACHIEVEMENT.THE_INVISIBLE_MOON,
		[CompletionType.DELIRIUM] 		= mod.ACHIEVEMENT.OCULAR_SPECTRUM,
		[CompletionType.MOTHER] 		= mod.ACHIEVEMENT.SEWING_MANUAL,
		[CompletionType.BEAST] 			= mod.ACHIEVEMENT.BEREAVEMENT,
	},
	[mod.PLAYER.SKELETAL_FIEND] = {
		[CompletionType.MOMS_HEART] 	= mod.ACHIEVEMENT.SKELETALFIEND_BABY,
		[CompletionType.ISAAC] 			= mod.ACHIEVEMENT.SKELETALFIEND_STARS,
		[CompletionType.SATAN] 			= mod.ACHIEVEMENT.SKELETALFIEND_CURVED_HORN,
		[CompletionType.BOSS_RUSH] 		= mod.ACHIEVEMENT.SKELETALFIEND_SPEED_UP,
		[CompletionType.BLUE_BABY] 		= mod.ACHIEVEMENT.SKELETALFIEND_POOP,
		[CompletionType.LAMB] 			= mod.ACHIEVEMENT.SKELETALFIEND_BETTER_ITEM,
		[CompletionType.MEGA_SATAN] 	= mod.ACHIEVEMENT.SKELETALFIEND_SLOT_MACHINE,
		[CompletionType.ULTRA_GREED] 	= mod.ACHIEVEMENT.SKELETALFIEND_A_PENNY,
		[CompletionType.HUSH] 			= mod.ACHIEVEMENT.SKELETALFIEND_SHOTSPEED_UP,
		[CompletionType.ULTRA_GREEDIER] = mod.ACHIEVEMENT.SKELETALFIEND_ANOTHER_PENNY,
		[CompletionType.DELIRIUM] 		= mod.ACHIEVEMENT.SKELETALFIEND_FIREBONE,
		[CompletionType.MOTHER] 		= mod.ACHIEVEMENT.SKELETALFIEND_HIS_PET,
		[CompletionType.BEAST] 			= mod.ACHIEVEMENT.SKELETALFIEND_MYSTERY_GIFT,
		All = mod.ACHIEVEMENT.SKELETALFIEND_BIRTHRIGHT,
	},
}

local allClearUnlocks = {
	[CompletionType.MOMS_HEART] 	= mod.ACHIEVEMENT.BAG_OF_BOBBIES,
	[CompletionType.ISAAC] 			= mod.ACHIEVEMENT.CRY_BABY,
	[CompletionType.SATAN] 			= mod.ACHIEVEMENT.DARK_BARGAIN,
	[CompletionType.BOSS_RUSH] 		= mod.ACHIEVEMENT.ANGRY_FAIC,
	[CompletionType.BLUE_BABY] 		= mod.ACHIEVEMENT.TOYBOX,
	[CompletionType.LAMB] 			= mod.ACHIEVEMENT.LIL_LAMB,
	[CompletionType.MEGA_SATAN] 	= mod.ACHIEVEMENT.DEVILS_DAGGER,
	[CompletionType.ULTRA_GREED] 	= mod.ACHIEVEMENT.COOL_SUNGLASSES,
	[CompletionType.HUSH] 			= mod.ACHIEVEMENT.GIZMO_BOOTS,
	[CompletionType.ULTRA_GREEDIER] = mod.ACHIEVEMENT.COOL_SUNGLASSES,
	[CompletionType.DELIRIUM] 		= mod.ACHIEVEMENT.BAD_DATA,
	[CompletionType.MOTHER] 		= mod.ACHIEVEMENT.CHERUB_CHUBBY,
	[CompletionType.BEAST] 			= mod.ACHIEVEMENT.BEAST_BEGGAR,
}

local skipNote = false
mod:AddCallback(ModCallbacks.MC_POST_COMPLETION_MARK_GET, function(_, completionType, playerType)
	local data = playerAchievements[playerType]
	if not data or not data[completionType] then return end

	if EntityConfig.GetPlayer(playerType):IsTainted() then
		if soulstoneTaintedMembers[completionType] then
			if Isaac.AllTaintedCompletion(playerType, TaintedMarksGroup.SOULSTONE) > 0 then
				data[completionType]:Unlock(skipNote)
			end
		elseif polaroidNegativeTaintedMembers[completionType] then
			if Isaac.AllTaintedCompletion(playerType, TaintedMarksGroup.POLAROID_NEGATIVE) > 0 then
				data[completionType]:Unlock(skipNote)
			end
		else
			data[completionType]:Unlock(skipNote)
		end
	else
		local difficultyRequirement = hardModeMarks[completionType] and 2 or 1
		if Isaac.GetCompletionMark(playerType, completionType) >= difficultyRequirement then -- Using the game's actual difficulty means Isaac.SetCompletionMark won't cascade into granting that mark's unlock
			data[completionType]:Unlock(skipNote)
		end

		if getEasiestCompletedMark(playerType) == 2 then
			data.All:Unlock(skipNote)
		end
	end

	local allClearUnlock = allClearUnlocks[completionType]
	if allClearUnlock and not allClearUnlock:IsUnlocked(true) then
		local allCleared = (Isaac.GetCompletionMark(mod.PLAYER.FIEND, completionType) > 0 or Isaac.GetCompletionMark(mod.PLAYER.BIEND, completionType) > 0) and
		                   (Isaac.GetCompletionMark(mod.PLAYER.GOLEM, completionType) > 0 or Isaac.GetCompletionMark(mod.PLAYER.BOLEM, completionType) > 0) and
		                   (Isaac.GetCompletionMark(mod.PLAYER.FRIEND, completionType) > 0 or Isaac.GetCompletionMark(mod.PLAYER.BRIEND, completionType) > 0) and
		                   (Isaac.GetCompletionMark(mod.PLAYER.INABA, completionType) > 0 or Isaac.GetCompletionMark(mod.PLAYER.BINABA, completionType) > 0)
		if allCleared then
			allClearUnlock:Unlock(skipNote)
		end
	end
end)

-- If for some reason you get all completion marks, and then choose to re-lock the items locked behind them, this will unlock them on game start
function mod.TryUnlockCompletionAchievements()
	skipNote = true

	for _, playerType in pairs(associatedPlayerTypes) do
		for i = CompletionType.MOMS_HEART, CompletionType.BEAST do
			if i ~= 8 and i ~= 10 then
				Isaac.SetCompletionMark(playerType, i, Isaac.GetCompletionMark(playerType, i)) -- This is kinda stupid but also very funny so idrc
			end
		end
	end

	skipNote = false
end

-- This is all exclusively for our DSS completion note page
local NoteLayer = {
	DELIRIUM	= 0,
	MOMS_HEART	= 1,
	ISAAC		= 2,
	SATAN		= 3,
	BOSS_RUSH 	= 4,
	BLUE_BABY 	= 5,
	LAMB 		= 6,
	MEGA_SATAN	= 7,
	GREED 		= 8,
	HUSH 		= 9,
	MOTHER 		= 10,
	BEAST 		= 11,
}

function mod.GetCompletionNoteLayerDataFromPlayerType(playerType)
	-- Fixes the note being blue
	local deli = Isaac.GetCompletionMark(playerType, CompletionType.DELIRIUM)
	if EntityConfig.GetPlayer(playerType):IsTainted() then
		deli = deli + 5
	end

	return {
		[NoteLayer.DELIRIUM] 	= deli,
		[NoteLayer.MOMS_HEART] 	= Isaac.GetCompletionMark(playerType, CompletionType.MOMS_HEART),
		[NoteLayer.ISAAC] 		= Isaac.GetCompletionMark(playerType, CompletionType.ISAAC),
		[NoteLayer.SATAN] 		= Isaac.GetCompletionMark(playerType, CompletionType.SATAN),
		[NoteLayer.BOSS_RUSH] 	= Isaac.GetCompletionMark(playerType, CompletionType.BOSS_RUSH),
		[NoteLayer.BLUE_BABY] 	= Isaac.GetCompletionMark(playerType, CompletionType.BLUE_BABY),
		[NoteLayer.LAMB] 		= Isaac.GetCompletionMark(playerType, CompletionType.LAMB),
		[NoteLayer.MEGA_SATAN] 	= Isaac.GetCompletionMark(playerType, CompletionType.MEGA_SATAN),
		[NoteLayer.GREED]		= Isaac.GetCompletionMark(playerType, CompletionType.ULTRA_GREED),
		[NoteLayer.HUSH]		= Isaac.GetCompletionMark(playerType, CompletionType.HUSH),
		[NoteLayer.MOTHER]		= Isaac.GetCompletionMark(playerType, CompletionType.MOTHER),
		[NoteLayer.BEAST]		= Isaac.GetCompletionMark(playerType, CompletionType.BEAST),
	}
end

local canUnlockMechaSatan = {
	[CompletionType.BLUE_BABY] = true,
	[CompletionType.LAMB] = true,
	[CompletionType.MEGA_SATAN] = true,
	[CompletionType.ULTRA_GREEDIER] = true,
	[CompletionType.DELIRIUM] = true,
	[CompletionType.MOTHER] = true,
	[CompletionType.BEAST] = true,
}

local mechaSatanUnlocks = {
	[PlayerType.PLAYER_ISAAC]          = mod.ACHIEVEMENT.LOADED_D6,
	[PlayerType.PLAYER_MAGDALENE]      = mod.ACHIEVEMENT.QUEENS_FRUIT,
	[PlayerType.PLAYER_CAIN]           = mod.ACHIEVEMENT.HAPPY_SQUIRREL,
	[PlayerType.PLAYER_JUDAS]          = mod.ACHIEVEMENT.BOOK_OF_LEVIATHAN,
	[PlayerType.PLAYER_BLACKJUDAS]     = mod.ACHIEVEMENT.BOOK_OF_LEVIATHAN,
	[PlayerType.PLAYER_BLUEBABY]       = mod.ACHIEVEMENT.NUGGET_BOMBS,
	[PlayerType.PLAYER_EVE]            = mod.ACHIEVEMENT.TORTURE_COOKIE,
	[PlayerType.PLAYER_SAMSON]         = mod.ACHIEVEMENT.WARFARIN,
	[PlayerType.PLAYER_AZAZEL]         = mod.ACHIEVEMENT.SHADOW_CLUSTER,
	[PlayerType.PLAYER_LAZARUS]        = mod.ACHIEVEMENT.DEADLY_DOSE,
	[PlayerType.PLAYER_LAZARUS2]       = mod.ACHIEVEMENT.DEADLY_DOSE,
	[PlayerType.PLAYER_EDEN]           = mod.ACHIEVEMENT.EDENS_HEAD,
	[PlayerType.PLAYER_THELOST]        = mod.ACHIEVEMENT.GODHEAD_JR,
	[PlayerType.PLAYER_LILITH]         = mod.ACHIEVEMENT.EARTH_OF_ADAM,
	[PlayerType.PLAYER_KEEPER]         = mod.ACHIEVEMENT.GOLDEN_WATCH,
	[PlayerType.PLAYER_APOLLYON]       = mod.ACHIEVEMENT.OWL_FEATHER,
	[PlayerType.PLAYER_THEFORGOTTEN]   = mod.ACHIEVEMENT.BONE_LORDS_TABLET,
	[PlayerType.PLAYER_THESOUL]        = mod.ACHIEVEMENT.BONE_LORDS_TABLET,
	[PlayerType.PLAYER_BETHANY]        = mod.ACHIEVEMENT.PAGE_OF_VIRTUES,
	[PlayerType.PLAYER_JACOB]          = mod.ACHIEVEMENT.DOUBLES,
	[PlayerType.PLAYER_ESAU]           = mod.ACHIEVEMENT.DOUBLES,
	[mod.PLAYER.FIEND]                 = mod.ACHIEVEMENT.FIENDS_LOST_FRIEND,
	[mod.PLAYER.GOLEM]                 = mod.ACHIEVEMENT.ASTEROID_BELT,
	[mod.PLAYER.FRIEND]                = mod.ACHIEVEMENT.FRIENDLY_FIRE,
	[mod.PLAYER.INABA]                 = mod.ACHIEVEMENT.HARE_TRIGGER,

	[PlayerType.PLAYER_ISAAC_B]        = mod.ACHIEVEMENT.ISAACD_EULOGY,
	[PlayerType.PLAYER_MAGDALENE_B]    = mod.ACHIEVEMENT.APPENDIX,
	[PlayerType.PLAYER_CAIN_B]         = mod.ACHIEVEMENT.GAPER_IN_A_JAR,
	[PlayerType.PLAYER_JUDAS_B]        = mod.ACHIEVEMENT.EXECUTIONER,
	[PlayerType.PLAYER_BLUEBABY_B]     = mod.ACHIEVEMENT.THE_BROWN_HORN,
	[PlayerType.PLAYER_EVE_B]          = mod.ACHIEVEMENT.BAD_BLOOD,
	[PlayerType.PLAYER_SAMSON_B]       = mod.ACHIEVEMENT.LIL_MINX,
	[PlayerType.PLAYER_AZAZEL_B]       = mod.ACHIEVEMENT.HELLFIRE,
	[PlayerType.PLAYER_LAZARUS_B]      = mod.ACHIEVEMENT.LOURDES_WATER,
	[PlayerType.PLAYER_LAZARUS2_B]     = mod.ACHIEVEMENT.LOURDES_WATER,
	[PlayerType.PLAYER_EDEN_B]         = mod.ACHIEVEMENT.NIL_PASTA,
	[PlayerType.PLAYER_THELOST_B]      = mod.ACHIEVEMENT.CROSS_NECKLACE,
	[PlayerType.PLAYER_LILITH_B]       = mod.ACHIEVEMENT.BLASTULATION,
	[PlayerType.PLAYER_KEEPER_B]       = mod.ACHIEVEMENT.D2,
	[PlayerType.PLAYER_APOLLYON_B]     = mod.ACHIEVEMENT.MUSCA,
	[PlayerType.PLAYER_THEFORGOTTEN_B] = mod.ACHIEVEMENT.DOUBLE_DOG,
	[PlayerType.PLAYER_THESOUL_B]      = mod.ACHIEVEMENT.DOUBLE_DOG,
	[PlayerType.PLAYER_BETHANY_B]      = mod.ACHIEVEMENT.ACHERON,
	[PlayerType.PLAYER_JACOB_B]        = mod.ACHIEVEMENT.MONSTER_DOMESTICATION_GUIDE,
	[PlayerType.PLAYER_JACOB2_B]       = mod.ACHIEVEMENT.MONSTER_DOMESTICATION_GUIDE,
	[mod.PLAYER.BIEND]                 = mod.ACHIEVEMENT.HUITLACOCHE,
	[mod.PLAYER.BOLEM]                 = mod.ACHIEVEMENT.COPPER_BAR,
	[mod.PLAYER.BRIEND]                = mod.ACHIEVEMENT.MAGIC_BULLET,
	[mod.PLAYER.BINABA]                = mod.ACHIEVEMENT.SHADOW_RABBITS,

	[mod.PLAYER.SKELETAL_FIEND]        = mod.ACHIEVEMENT.SKELETALFIEND_SPICY_KEY,
}

function mod:HasFiendishFoesCompletionMark(playerType)
	if FiendFolio and FiendFolio.savedata and FiendFolio.savedata.mechaSatanCompletion then
		local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, playerType)
		local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(playerType):IsTainted() and "-Tainted") or "")
		if FiendFolio.savedata.mechaSatanCompletion[saveID] then
			return FiendFolio.savedata.mechaSatanCompletion[saveID] > 0
		end
	end
	return false
end

mod:AddCallback(ModCallbacks.MC_POST_COMPLETION_EVENT, function(_, completionType)
	if canUnlockMechaSatan[completionType] and FiendFolio.CanRunUnlockAchievements() then
		for _, player in ipairs(PlayerManager.GetPlayers()) do
			if not player.Parent and player.Variant == 0 then
				local playerType = player:GetPlayerType()
				playerType = playerTypeRedirect[playerType] or playerType
				if Isaac.RunCallback(ModCallbacks.MC_PRE_COMPLETION_EVENT, "FFFiendishFoes") ~= false and
				   Isaac.RunCallbackWithParam(ModCallbacks.MC_COMPLETION_MARK_GET, playerType, "FFFiendishFoes", playerType) ~= false
				then
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, playerType)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(playerType):IsTainted() and "-Tainted") or "")

					local difficulty = game.Difficulty
					if difficulty == Difficulty.DIFFICULTY_NORMAL or difficulty == Difficulty.DIFFICULTY_GREED then
						FiendFolio.savedata.mechaSatanCompletion[saveID] = math.max(FiendFolio.savedata.mechaSatanCompletion[saveID] or 0, 1)
					elseif difficulty == Difficulty.DIFFICULTY_HARD or difficulty == Difficulty.DIFFICULTY_GREEDIER then
						FiendFolio.savedata.mechaSatanCompletion[saveID] = math.max(FiendFolio.savedata.mechaSatanCompletion[saveID] or 0, 2)
					end

					mechaSatanUnlock = mechaSatanUnlocks[playerType]
					if mechaSatanUnlock and not mechaSatanUnlock:IsUnlocked(true) then
						mechaSatanUnlock:Unlock()
					end

					Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_COMPLETION_MARK_GET, playerType, "FFFiendishFoes", playerType)
					Isaac.RunCallback(ModCallbacks.MC_POST_COMPLETION_EVENT, "FFFiendishFoes")
				end
			end
		end
	end
end)

local mechaSatanSprite = Sprite()
mechaSatanSprite:Load("gfx/ui/ui_ffcompletionwidget.anm2", true)
function mod:renderMechaSatanCompletion(pos, scale, playerType)
	if not (FiendFolio.savedata and FiendFolio.savedata.mechaSatanCompletion) then return end

	local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, playerType)
	local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(playerType):IsTainted() and "-Tainted") or "")
	local note = FiendFolio.savedata.mechaSatanCompletion[saveID]
	if note and note > 0 then
		if note == 1 then
			mechaSatanSprite:Play("Normal", true)
		elseif note == 2 then
			mechaSatanSprite:Play("Hard", true)
		else
			return
		end
		mechaSatanSprite.Scale = scale
		mechaSatanSprite:Render(pos)
	end
end

mod:AddCallback(ModCallbacks.MC_POST_COMPLETION_MARKS_RENDER, function(_, sprite, pos, scale, playerType)
	local playerType = playerTypeRedirect[playerType] or playerType
	mod:renderMechaSatanCompletion(pos, scale, playerType)
end)