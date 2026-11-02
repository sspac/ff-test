FiendFolio.ACHIEVEMENT = {
	-- Order of this table determines order of button appearance in menu
	-- IMPORTANT: Make sure to add a corresponding achievement to `achievements.xml` with the same name as here, prefixed with "FF_"!
	-- ALSO IMPORTANT: Don't change the ID/names of any established achievements as they are used for savedata and code!

	-- To-do unlocks
	--[[
		dad's dip: ???
		red no. 3: ???
		guppy's heart: ???
		ceiling popcorn: ???
	]]
	{
		ID = "FIENDISH_FOES",
		AlwaysUnlocked = true,
		Note = "fiendish_foes",
		Tags = {"Misc", "Other"},
		NoInsertTags = {"Misc", "Other"},
		Tooltip = {"thank you", "for playing", "our mod"}
	},

	-- Character Unlocks
	{
		ID = "FIEND",
		Note = "achievement_fiend",
		Name = "fiend",
		Tags = {"FiendUnlock", "Character", "CharacterDisplay", "Fiend", "CharacterUnlock"},
		NoInsertTags = {"Fiend"},
		Tooltip = {"beat one", "fiend folio", "boss"}
	},
	{
		ID = "BIEND",
		Note = "achievement_fiendb",
		Name = "the bastard",
		Tooltip = {"open a", "certain closet", "as fiend"},
		Tags = {"BiendUnlock", "Character", "CharacterDisplay", "Biend", "TaintedCharacterUnlock"},
		NoInsertTags = {"Biend"}
	},
	{
		ID = "SKELETALFIEND",
		Note = "skeletal_fiend/achievement_skeletal_fiend",
		Name = "the skeletal fiend",
		Tags = {"SkeletalFiendUnlock", "Character", "CharacterDisplay", "SkeletalFiend", "TarnishedCharacterUnlock"},
		NoInsertTags = {"SkeletalFiend"},
		Tooltip = {"murder a bony", "as", "tainted fiend"},
		Tarnished = true,
		NoCountCompletion = true
	},
	{
		ID = "GOLEM",
		Note = "achievement_golem",
		Name = "golem",
		Tags = {"GolemUnlock", "Character", "CharacterDisplay", "Golem", "CharacterUnlock"},
		NoInsertTags = {"Golem"},
		Tooltip = {"find the", "unfinished", "golem", "in the mines"}
	},
	{
		ID = "BOLEM",
		Note = "achievement_golemb",
		Name = "the artisan",
		Tooltip = {"open a", "certain closet", "as golem"},
		Tags = {"BolemUnlock", "Character", "CharacterDisplay", "Bolem", "TaintedCharacterUnlock"},
		NoInsertTags = {"Bolem"}
	},
	{
		ID = "FRIEND",
		Note = "achievement_friend",
		Name = "friend",
		Tooltip = {"bounty hunt", "friend", "as fiend"},
		Tags = {"FriendUnlock", "Character", "CharacterDisplay", "Friend", "CharacterUnlock"},
		NoInsertTags = {"Friend"}
	},
	{
		ID = "BRIEND",
		Note = "achievement_friendb",
		Name = "the wanted",
		Tooltip = {"open a", "certain closet", "as friend"},
		Tags = {"BriendUnlock", "Character", "CharacterDisplay", "Briend", "TaintedCharacterUnlock"},
		NoInsertTags = {"Briend"}
	},
	{
		ID = "INABA",
		Note = "achievement_inaba",
		Name = "inaba",
		Tooltip = {"???"},
		Tags = {"InabaUnlock", "Character", "CharacterDisplay", "Inaba", "CharacterUnlock", "InabaHidden"},
		NoInsertTags = {"Inaba", "InabaHidden"},
		Challenge = true,
	},
	{
		ID = "BINABA",
		Note = "achievement_inabab",
		Name = "the euthymic",
		Tooltip = {"open a", "certain closet", "as inaba"},
		Tags = {"BinabaUnlock", "Character", "CharacterDisplay", "Binaba", "TaintedCharacterUnlock", "InabaHidden"},
		NoInsertTags = {"Binaba", "InabaHidden"},
	},

	-- Fiend Unlocks
	{
		ID = "IMMORAL_HEART",
		Note = "immoral_heart",
		Tooltip = {"beat", "mom", "as fiend"},
		Tags = {"Fiend", "FiendCompletion", "Character", "FiendDisplay"}
	},
	{
		ID = "LIL_FIEND",
		Note = "lil_fiend",
		Tooltip = {"beat", "mom's heart", "on hard", "as fiend"},
		CompletionMark = {FiendFolio.PLAYER.FIEND, "Heart"},
		Tags = {"Fiend", "FiendCompletion", "Character", "FiendDisplay"}
	},
	{
		ID = "IMP_SODA",
		Note = "imp_soda",
		Tooltip = {"beat", "isaac", "as fiend"},
		CompletionMark = {FiendFolio.PLAYER.FIEND, "Isaac"},
		Tags = {"Fiend", "FiendCompletion", "Character", "FiendDisplay"}
	},
	{
		ID = "HEART_OF_CHINA",
		Note = "heart_of_china",
		Tooltip = {"beat", "???", "as fiend"},
		CompletionMark = {FiendFolio.PLAYER.FIEND, "BlueBaby"},
		Tags = {"Fiend", "FiendCompletion", "Character", "FiendDisplay"}
	},
	{
		ID = "FIEND_MIX",
		Note = "fiend_mix",
		Tooltip = {"beat", "satan", "as fiend"},
		CompletionMark = {FiendFolio.PLAYER.FIEND, "Satan"},
		Tags = {"Fiend", "FiendCompletion", "Character", "FiendDisplay"}
	},
	{
		ID = "PRANK_COOKIE",
		Note = "prank_cookie",
		Tooltip = {"beat", "the lamb", "as fiend"},
		CompletionMark = {FiendFolio.PLAYER.FIEND, "Lamb"},
		Tags = {"Fiend", "FiendCompletion", "Character", "FiendDisplay"}
	},
	{
		ID = "GMO_CORN",
		Note = "gmo_corn",
		Tooltip = {"beat", "boss rush", "as fiend"},
		CompletionMark = {FiendFolio.PLAYER.FIEND, "BossRush"},
		Tags = {"Fiend", "FiendCompletion", "Character", "FiendDisplay"}
	},
	{
		ID = "PLUS_3_FIREBALLS",
		Note = "3_fireballs",
		Name = "+3 fireballs",
		Tooltip = {"beat", "hush", "as fiend"},
		CompletionMark = {FiendFolio.PLAYER.FIEND, "Hush"},
		Tags = {"Fiend", "FiendCompletion", "Character", "FiendDisplay"}
	},
	{
		ID = "FIENDS_HORN",
		Note = "fiends_horn",
		Name = "fiend's horn",
		Tooltip = {"beat", "delirium", "as fiend"},
		CompletionMark = {FiendFolio.PLAYER.FIEND, "Delirium"},
		Tags = {"Fiend", "FiendCompletion", "Character", "FiendDisplay"}
	},
	{
		ID = "PYROMANCY",
		Note = "pyromancy",
		Tooltip = {"beat", "mega satan", "as fiend"},
		CompletionMark = {FiendFolio.PLAYER.FIEND, "MegaSatan"},
		Tags = {"Fiend", "FiendCompletion", "Character", "FiendDisplay"}
	},
	{
		ID = "LONGTIME_FIEND",
		Note = "longtime_fiend",
		Tooltip = {"beat", "mother", "as fiend"},
		CompletionMark = {FiendFolio.PLAYER.FIEND, "Mother"},
		Tags = {"Fiend", "FiendCompletion", "Character", "FiendDisplay"}
	},
	{
		ID = "FETAL_FIEND",
		Note = "fetal_fiend",
		Tooltip = {"beat", "beast", "as fiend"},
		CompletionMark = {FiendFolio.PLAYER.FIEND, "Beast"},
		Tags = {"Fiend", "FiendCompletion", "Character", "FiendDisplay"}
	},
	{
		ID = "FLAMING_PENNY",
		Note = "flaming_penny",
		Tooltip = {"beat", "greed mode", "as fiend"},
		CompletionMark = {FiendFolio.PLAYER.FIEND, "Greed"},
		Tags = {"Fiend", "FiendCompletion", "Character", "FiendDisplay"}
	},
	{
		ID = "JACK_CARDS",
		Note = "jack_cards",
		Tooltip = {"beat", "greedier mode", "as fiend"},
		CompletionMark = {FiendFolio.PLAYER.FIEND, "Greedier"},
		Tags = {"Fiend", "FiendCompletion", "Character", "FiendDisplay"}
	},
	{
		ID = "FIEND_FOLIO",
		Note = "fiendfolio",
		Name = "the fiend folio",
		Tooltip = {"beat", "everything", "on hard", "as fiend"},
		CompletionMark = {FiendFolio.PLAYER.FIEND, "All"},
		Tags = {"Fiend", "FiendAll", "Character", "FiendDisplay"}
	},

	-- Biend Unlocks
	{
		ID = "IMP_FINGER",
		Note = "imp_finger",
		Tooltip = {"beat isaac,", "???, satan", "and the lamb", "as tainted", "fiend"},
		ViewerTooltip = {"beat isaac, ???, satan", "and the lamb as tainted fiend"},
		CompletionMark = {FiendFolio.PLAYER.BIEND, "Quartet"},
		Tags = {"Biend", "Character", "BiendDisplay"}
	},
	{
		ID = "SOUL_OF_FIEND",
		Note = "soul_of_fiend",
		Tooltip = {"beat boss", "rush and hush", "as tainted", "fiend"},
		CompletionMark = {FiendFolio.PLAYER.BIEND, "Duet"},
		Tags = {"Biend", "Character", "BiendDisplay"}
	},
	{
		ID = "GOLDEN_SLOT_MACHINE",
		Note = "golden_slot_machine",
		Tooltip = {"beat", "mega satan", "as tainted", "fiend"},
		CompletionMark = {FiendFolio.PLAYER.BIEND, "MegaSatan"},
		Tags = {"Biend", "Character", "BiendDisplay"}
	},
	{
		ID = "REVERSE_3_FIREBALLS",
		Note = "3_fireballs_evil",
		Name = "+3 fireballs?",
		Tooltip = {"beat", "greedier mode", "as tainted", "fiend"},
		CompletionMark = {FiendFolio.PLAYER.BIEND, "Greedier"},
		Tags = {"Biend", "Character", "BiendDisplay"}
	},
	{
		ID = "MALICE",
		Note = "malice",
		Tooltip = {"beat", "delirium", "as tainted", "fiend"},
		CompletionMark = {FiendFolio.PLAYER.BIEND, "Delirium"},
		Tags = {"Biend", "Character", "BiendDisplay"}
	},
	{
		ID = "HATRED",
		Note = "hatred",
		Tooltip = {"beat", "mother", "as tainted", "fiend"},
		CompletionMark = {FiendFolio.PLAYER.BIEND, "Mother"},
		Tags = {"Biend", "Character", "BiendDisplay"}
	},
	{
		ID = "IMP_CURSE",
		Note = "achievement_impcurse",
		Name = "imp curse",
		Tooltip = {"beat", "beast", "as tainted", "fiend"},
		CompletionMark = {FiendFolio.PLAYER.BIEND, "Beast"},
		Tags = {"Biend", "Character", "BiendDisplay"}
	},

	-- Skeletal Fiend Unlocks
	{
		ID = "SKELETALFIEND_BABY",
		Note = "skeletal_fiend/achievement_baby",
		Name = "baby",
		Tooltip = {"beat", "mom's heart", "on hard", "as the", "skeletal fiend"},
		CompletionMark = {FiendFolio.PLAYER.SKELETAL_FIEND, "Heart"},
		Tags = {"SkeletalFiend", "SkeletalFiendCompletion", "Character", "SkeletalFiendDisplay"},
		Tarnished = true,
		NoCountCompletion = true
	},
	{
		ID = "SKELETALFIEND_STARS",
		Note = "skeletal_fiend/achievement_stars",
		Name = "stars?",
		Tooltip = {"beat", "isaac", "as the", "skeletal fiend"},
		CompletionMark = {FiendFolio.PLAYER.SKELETAL_FIEND, "Isaac"},
		Tags = {"SkeletalFiend", "SkeletalFiendCompletion", "Character", "SkeletalFiendDisplay"},
		Tarnished = true,
		NoCountCompletion = true
	},
	{
		ID = "SKELETALFIEND_POOP",
		Note = "skeletal_fiend/achievement_poop",
		Name = "poop",
		Tooltip = {"beat", "???", "as the", "skeletal fiend"},
		CompletionMark = {FiendFolio.PLAYER.SKELETAL_FIEND, "BlueBaby"},
		Tags = {"SkeletalFiend", "SkeletalFiendCompletion", "Character", "SkeletalFiendDisplay"},
		Tarnished = true,
		NoCountCompletion = true
	},
	{
		ID = "SKELETALFIEND_CURVED_HORN",
		Note = "skeletal_fiend/achievement_curved_horn",
		Name = "curved horn",
		Tooltip = {"beat", "satan", "as the", "skeletal fiend"},
		CompletionMark = {FiendFolio.PLAYER.SKELETAL_FIEND, "Satan"},
		Tags = {"SkeletalFiend", "SkeletalFiendCompletion", "Character", "SkeletalFiendDisplay"},
		Tarnished = true,
		NoCountCompletion = true
	},
	{
		ID = "SKELETALFIEND_BETTER_ITEM",
		Note = "skeletal_fiend/achievement_better_item",
		Name = "better first item",
		Tooltip = {"beat", "the lamb", "as the", "skeletal fiend"},
		CompletionMark = {FiendFolio.PLAYER.SKELETAL_FIEND, "Lamb"},
		Tags = {"SkeletalFiend", "SkeletalFiendCompletion", "Character", "SkeletalFiendDisplay"},
		Tarnished = true,
		NoCountCompletion = true
	},
	{
		ID = "SKELETALFIEND_SPEED_UP",
		Note = "skeletal_fiend/achievement_speed_up",
		Name = "speed up",
		Tooltip = {"beat", "boss rush", "as the", "skeletal fiend"},
		CompletionMark = {FiendFolio.PLAYER.SKELETAL_FIEND, "BossRush"},
		Tags = {"SkeletalFiend", "SkeletalFiendCompletion", "Character", "SkeletalFiendDisplay"},
		Tarnished = true,
		NoCountCompletion = true
	},
	{
		ID = "SKELETALFIEND_SHOTSPEED_UP",
		Note = "skeletal_fiend/achievement_shotspeed_up",
		Name = "shotspeed up",
		Tooltip = {"beat", "hush", "as the", "skeletal fiend"},
		CompletionMark = {FiendFolio.PLAYER.SKELETAL_FIEND, "Hush"},
		Tags = {"SkeletalFiend", "SkeletalFiendCompletion", "Character", "SkeletalFiendDisplay"},
		Tarnished = true,
		NoCountCompletion = true
	},
	{
		ID = "SKELETALFIEND_FIREBONE",
		Note = "skeletal_fiend/achievement_firebone",
		Name = "one firebone",
		Tooltip = {"beat", "delirium", "as the", "skeletal fiend"},
		CompletionMark = {FiendFolio.PLAYER.SKELETAL_FIEND, "Delirium"},
		Tags = {"SkeletalFiend", "SkeletalFiendCompletion", "Character", "SkeletalFiendDisplay"},
		Tarnished = true,
		NoCountCompletion = true
	},
	{
		ID = "SKELETALFIEND_SLOT_MACHINE",
		Note = "skeletal_fiend/achievement_slot_machine",
		Name = "slot machine",
		Tooltip = {"beat", "mega satan", "as the", "skeletal fiend"},
		CompletionMark = {FiendFolio.PLAYER.SKELETAL_FIEND, "MegaSatan"},
		Tags = {"SkeletalFiend", "SkeletalFiendCompletion", "Character", "SkeletalFiendDisplay"},
		Tarnished = true,
		NoCountCompletion = true
	},
	{
		ID = "SKELETALFIEND_HIS_PET",
		Note = "skeletal_fiend/achievement_his_pet",
		Name = "his pet",
		Tooltip = {"beat", "mother", "as the", "skeletal fiend"},
		CompletionMark = {FiendFolio.PLAYER.SKELETAL_FIEND, "Mother"},
		Tags = {"SkeletalFiend", "SkeletalFiendCompletion", "Character", "SkeletalFiendDisplay"},
		Tarnished = true,
		NoCountCompletion = true
	},
	{
		ID = "SKELETALFIEND_MYSTERY_GIFT",
		Note = "skeletal_fiend/achievement_mystery_gift",
		Name = "mystery gift",
		Tooltip = {"beat", "beast", "as the", "skeletal fiend"},
		CompletionMark = {FiendFolio.PLAYER.SKELETAL_FIEND, "Beast"},
		Tags = {"SkeletalFiend", "SkeletalFiendCompletion", "Character", "SkeletalFiendDisplay"},
		Tarnished = true,
		NoCountCompletion = true
	},
	{
		ID = "SKELETALFIEND_A_PENNY",
		Note = "skeletal_fiend/achievement_a_penny",
		Name = "a penny",
		Tooltip = {"beat", "greed mode", "as the", "skeletal fiend"},
		CompletionMark = {FiendFolio.PLAYER.SKELETAL_FIEND, "Greed"},
		Tags = {"SkeletalFiend", "SkeletalFiendCompletion", "Character", "SkeletalFiendDisplay"},
		Tarnished = true,
		NoCountCompletion = true
	},
	{
		ID = "SKELETALFIEND_ANOTHER_PENNY",
		Note = "skeletal_fiend/achievement_another_penny",
		Name = "another penny",
		Tooltip = {"beat", "greedier mode", "as the", "skeletal fiend"},
		CompletionMark = {FiendFolio.PLAYER.SKELETAL_FIEND, "Greedier"},
		Tags = {"SkeletalFiend", "SkeletalFiendCompletion", "Character", "SkeletalFiendDisplay"},
		Tarnished = true,
		NoCountCompletion = true
	},
	{
		ID = "SKELETALFIEND_BIRTHRIGHT",
		Note = "skeletal_fiend/achievement_birthright",
		Name = "birthright",
		Tooltip = {"beat", "everything", "on hard", "as the", "skeletal fiend"},
		Tags = {"SkeletalFiend", "SkeletalFiendAll", "Character", "SkeletalFiendDisplay"},
		Tarnished = true,
		NoCountCompletion = true
	},

	-- Golem Unlocks
	{
		ID = "PET_ROCK",
		Note = "pet_rock",
		Tooltip = {"beat", "mom", "as golem"},
		Tags = {"Golem", "GolemCompletion", "Character", "GolemDisplay"}
	},
	{
		ID = "LIL_GOLEM",
		Note = "achievement_lilgolem",
		Name = "lil golem",
		Tooltip = {"beat", "mom's heart", "on hard", "as golem"},
		CompletionMark = {FiendFolio.PLAYER.GOLEM, "Heart"},
		Tags = {"Golem", "GolemCompletion", "Character", "GolemDisplay"}
	},
	{
		ID = "GOLEMS_ROCK",
		Note = "golems_rock",
		Name = "golem's rock",
		Tooltip = {"beat", "isaac", "as golem"},
		CompletionMark = {FiendFolio.PLAYER.GOLEM, "Isaac"},
		Tags = {"Golem", "GolemCompletion", "Character", "GolemDisplay"}
	},
	{
		ID = "GOLEMS_ORB",
		Note = "golems_orb",
		Name = "golem's orb",
		Tooltip = {"beat", "???", "as golem"},
		CompletionMark = {FiendFolio.PLAYER.GOLEM, "BlueBaby"},
		Tags = {"Golem", "GolemCompletion", "Character", "GolemDisplay"}
	},
	{
		ID = "CHERRY_BOMB",
		Note = "cherry_bomb",
		Tooltip = {"beat", "satan", "as golem"},
		CompletionMark = {FiendFolio.PLAYER.GOLEM, "Satan"},
		Tags = {"Golem", "GolemCompletion", "Character", "GolemDisplay"}
	},
	{
		ID = "BRIDGE_BOMBS",
		Note = "bridge_bombs",
		Tooltip = {"beat", "the lamb", "as golem"},
		CompletionMark = {FiendFolio.PLAYER.GOLEM, "Lamb"},
		Tags = {"Golem", "GolemCompletion", "Character", "GolemDisplay"}
	},
	{
		ID = "SOLEMN_VOW",
		Note = "solemn_vow",
		Tooltip = {"beat", "boss rush", "as golem"},
		CompletionMark = {FiendFolio.PLAYER.GOLEM, "BossRush"},
		Tags = {"Golem", "GolemCompletion", "Character", "GolemDisplay"}
	},
	{
		ID = "DICE_GOBLIN",
		Note = "dice_goblin",
		Tooltip = {"beat", "hush", "as golem"},
		CompletionMark = {FiendFolio.PLAYER.GOLEM, "Hush"},
		Tags = {"Golem", "GolemCompletion", "Character", "GolemDisplay"}
	},
	{
		ID = "PERFECTLY_GENERIC_OBJECT",
		Note = "pgo",
		Tooltip = {"beat", "delirium", "as golem"},
		CompletionMark = {FiendFolio.PLAYER.GOLEM, "Delirium"},
		Tags = {"Golem", "GolemCompletion", "Character", "GolemDisplay"}
	},
	{
		ID = "MASSIVE_AMETHYST",
		Note = "massive_amethyst",
		Tooltip = {"beat", "mega satan", "as golem"},
		CompletionMark = {FiendFolio.PLAYER.GOLEM, "MegaSatan"},
		Tags = {"Golem", "GolemCompletion", "Character", "GolemDisplay"}
	},
	{
		ID = "ETERNAL_D12",
		Note = "eternal_d12",
		Tooltip = {"beat", "mother", "as golem"},
		CompletionMark = {FiendFolio.PLAYER.GOLEM, "Mother"},
		Tags = {"Golem", "GolemCompletion", "Character", "GolemDisplay"}
	},
	{
		ID = "ASTROPULVIS",
		Note = "astropulvis",
		Tooltip = {"beat", "beast", "as golem"},
		CompletionMark = {FiendFolio.PLAYER.GOLEM, "Beast"},
		Tags = {"Golem", "GolemCompletion", "Character", "GolemDisplay"}
	},
	{
		ID = "MOLTEN_PENNY",
		Note = "molten_penny",
		Tooltip = {"beat", "greed mode", "as golem"},
		CompletionMark = {FiendFolio.PLAYER.GOLEM, "Greed"},
		Tags = {"Golem", "GolemCompletion", "Character", "GolemDisplay"}
	},
	{
		ID = "GOLDEN_SPIKES",
		Note = "golden_spikes",
		Tooltip = {"beat", "greedier mode", "as golem"},
		CompletionMark = {FiendFolio.PLAYER.GOLEM, "Greedier"},
		Tags = {"Golem", "GolemCompletion", "Character", "GolemDisplay"}
	},
	{
		ID = "SNOW_GLOBE",
		Note = "snow_globe",
		Tooltip = {"beat", "everything", "on hard", "as golem"},
		CompletionMark = {FiendFolio.PLAYER.GOLEM, "All"},
		Tags = {"Golem", "GolemAll", "Character", "GolemDisplay"}
	},

	-- Bolem Unlocks
	{
		ID = "WAVEBREAKER",
		Note = "wavebreaker",
		Tooltip = {"beat isaac,", "???, satan", "and the lamb", "as tainted", "golem"},
		ViewerTooltip = {"beat isaac, ???, satan", "and the lamb as tainted golem"},
		CompletionMark = {FiendFolio.PLAYER.BOLEM, "Quartet"},
		Tags = {"Bolem", "Character", "BolemDisplay"}
	},
	{
		ID = "SOUL_OF_GOLEM",
		Note = "soul_of_golem",
		Tooltip = {"beat boss", "rush and hush", "as tainted", "golem"},
		CompletionMark = {FiendFolio.PLAYER.BOLEM, "Duet"},
		Tags = {"Bolem", "Character", "BolemDisplay"}
	},
	{
		ID = "BLASPHEMOUS_TRINKETS",
		Note = "blasphemous_trinkets",
		Tooltip = {"beat", "mega satan", "as tainted", "golem"},
		CompletionMark = {FiendFolio.PLAYER.BOLEM, "MegaSatan"},
		Tags = {"Bolem", "Character", "BolemDisplay"}
	},
	{
		ID = "REVERSE_KING_OF_PENTACLES",
		Note = "reverse_king_of_pentacles",
		Name = "king of pentacles?",
		Tooltip = {"beat", "greedier mode", "as tainted", "golem"},
		CompletionMark = {FiendFolio.PLAYER.BOLEM, "Greedier"},
		Tags = {"Bolem", "Character", "BolemDisplay"}
	},
	{
		ID = "MAMMONITE_CODEX",
		Note = "mammonite_codex",
		Tooltip = {"beat", "delirium", "as tainted", "golem"},
		CompletionMark = {FiendFolio.PLAYER.BOLEM, "Delirium"},
		Tags = {"Bolem", "Character", "BolemDisplay"}
	},
	{
		ID = "SISYPHEAN_BOULDER",
		Note = "sisyphean_boulder",
		Tooltip = {"beat", "mother", "as tainted", "golem"},
		CompletionMark = {FiendFolio.PLAYER.BOLEM, "Mother"},
		Tags = {"Bolem", "Character", "BolemDisplay"}
	},
	{
		ID = "AZURITE_SPINDOWN",
		Note = "azurite_spindown",
		Tooltip = {"beat", "beast", "as tainted", "golem"},
		CompletionMark = {FiendFolio.PLAYER.BOLEM, "Beast"},
		Tags = {"Bolem", "Character", "BolemDisplay"}
	},

	-- Friend Unlocks
	{
		ID = "STRANGE_EYE",
		Note = "strange_eye",
		Tooltip = {"beat", "mom", "as friend"},
		Tags = {"Friend", "FriendCompletion", "Character", "FriendDisplay"}
	},
	{
		ID = "LIL_FRIEND",
		Note = "lil_friend",
		Tooltip = {"beat", "mom's heart", "on hard", "as friend"},
		CompletionMark = {FiendFolio.PLAYER.FRIEND, "Heart"},
		Tags = {"Friend", "FriendCompletion", "Character", "FriendDisplay"}
	},
	{
		ID = "IMP_SODA_CHERRY",
		Note = "imp_soda_cherry",
		Tooltip = {"beat", "isaac", "as friend"},
		CompletionMark = {FiendFolio.PLAYER.FRIEND, "Isaac"},
		Tags = {"Friend", "FriendCompletion", "Character", "FriendDisplay"}
	},
	{
		ID = "RUBBER_BULLETS",
		Note = "rubber_bullets",
		Tooltip = {"beat", "???", "as friend"},
		CompletionMark = {FiendFolio.PLAYER.FRIEND, "BlueBaby"},
		Tags = {"Friend", "FriendCompletion", "Character", "FriendDisplay"}
	},
	{
		ID = "CONTRA_BAND",
		Note = "contra_band",
		Tooltip = {"beat", "satan", "as friend"},
		CompletionMark = {FiendFolio.PLAYER.FRIEND, "Satan"},
		Tags = {"Friend", "FriendCompletion", "Character", "FriendDisplay"}
	},
	{
		ID = "SWALLOWED_M90",
		Note = "swallowed_m90",
		Tooltip = {"beat", "the lamb", "as friend"},
		CompletionMark = {FiendFolio.PLAYER.FRIEND, "Lamb"},
		Tags = {"Friend", "FriendCompletion", "Character", "FriendDisplay"}
	},
	{
		ID = "HOW_TO_ROLL",
		Note = "how_to_roll",
		Tooltip = {"beat", "boss rush", "as friend"},
		CompletionMark = {FiendFolio.PLAYER.FRIEND, "BossRush"},
		Tags = {"Friend", "FriendCompletion", "Character", "FriendDisplay"}
	},
	{
		ID = "OLD_SHELL",
		Note = "old_shell",
		Tooltip = {"beat", "hush", "as friend"},
		CompletionMark = {FiendFolio.PLAYER.FRIEND, "Hush"},
		Tags = {"Friend", "FriendCompletion", "Character", "FriendDisplay"}
	},
	{
		ID = "FIREBALL_FORMULA",
		Note = "fireball_formula",
		Tooltip = {"beat", "delirium", "as friend"},
		CompletionMark = {FiendFolio.PLAYER.FRIEND, "Delirium"},
		Tags = {"Friend", "FriendCompletion", "Character", "FriendDisplay"}
	},
	{
		ID = "BULLET_HELL",
		Note = "bullet_hell",
		Tooltip = {"beat", "mega satan", "as friend"},
		CompletionMark = {FiendFolio.PLAYER.FRIEND, "MegaSatan"},
		Tags = {"Friend", "FriendCompletion", "Character", "FriendDisplay"}
	},
	{
		ID = "RAILDRIVER",
		Note = "raildriver",
		Tooltip = {"beat", "mother", "as friend"},
		CompletionMark = {FiendFolio.PLAYER.FRIEND, "Mother"},
		Tags = {"Friend", "FriendCompletion", "Character", "FriendDisplay"}
	},
	{
		ID = "FETAL_FRIEND",
		Note = "fetal_friend",
		Tooltip = {"beat", "beast", "as friend"},
		CompletionMark = {FiendFolio.PLAYER.FRIEND, "Beast"},
		Tags = {"Friend", "FriendCompletion", "Character", "FriendDisplay"}
	},
	{
		ID = "SNAGS",
		Note = "snags",
		Tooltip = {"beat", "greed mode", "as friend"},
		CompletionMark = {FiendFolio.PLAYER.FRIEND, "Greed"},
		Tags = {"Friend", "FriendCompletion", "Character", "FriendDisplay"}
	},
	{
		ID = "DYNAMITE_PACK",
		Note = "dynamite_pack",
		Tooltip = {"beat", "greedier mode", "as friend"},
		CompletionMark = {FiendFolio.PLAYER.FRIEND, "Greedier"},
		Tags = {"Friend", "FriendCompletion", "Character", "FriendDisplay"}
	},
	{
		ID = "GRANDPAS_GATLING_GUN",
		Note = "grandpas_gatling_gun",
		Tooltip = {"beat", "everything", "on hard", "as friend"},
		CompletionMark = {FiendFolio.PLAYER.FRIEND, "All"},
		Tags = {"Friend", "FriendAll", "Character", "FriendDisplay"}
	},

	-- Briend Unlocks
	{
		ID = "AMMO_CLIP",
		Note = "achievement_ammoclip",
		Name = "ammo clip",
		Tooltip = {"beat isaac,", "???, satan", "and the lamb", "as tainted", "friend"},
		ViewerTooltip = {"beat isaac, ???, satan", "and the lamb as tainted friend"},
		CompletionMark = {FiendFolio.PLAYER.BRIEND, "Quartet"},
		Tags = {"Briend", "Character", "BriendDisplay"}
	},
	{
		ID = "SOUL_OF_FRIEND",
		Note = "achievement_souloffriend",
		Name = "soul of friend",
		Tooltip = {"beat boss", "rush and hush", "as tainted", "friend"},
		CompletionMark = {FiendFolio.PLAYER.BRIEND, "Duet"},
		Tags = {"Briend", "Character", "BriendDisplay"}
	},
	{
		ID = "SALOON",
		Note = "achievement_saloon",
		Name = "saloons",
		Tooltip = {"beat", "mega satan", "as tainted", "friend"},
		CompletionMark = {FiendFolio.PLAYER.BRIEND, "MegaSatan"},
		Tags = {"Briend", "Character", "BriendDisplay"}
	},
	{
		ID = "MISPRINTED_JOKER",
		Note = "achievement_misprintedjoker",
		Name = "misprinted joker",
		Tooltip = {"beat", "greedier mode", "as tainted", "friend"},
		CompletionMark = {FiendFolio.PLAYER.BRIEND, "Greedier"},
		Tags = {"Briend", "Character", "BriendDisplay"}
	},
	{
		ID = "GUNSLINGERS_GRIT",
		Note = "achievement_gunslingersgrit",
		Name = "gunslinger's grit",
		Tooltip = {"beat", "delirium", "as tainted", "friend"},
		CompletionMark = {FiendFolio.PLAYER.BRIEND, "Delirium"},
		Tags = {"Briend", "Character", "BriendDisplay"}
	},
	{
		ID = "DADS_USB",
		Note = "achievement_dadsusb",
		Name = "dad's usb",
		Tooltip = {"beat", "mother", "as tainted", "friend"},
		CompletionMark = {FiendFolio.PLAYER.BRIEND, "Mother"},
		Tags = {"Briend", "Character", "BriendDisplay"}
	},
	{
		ID = "MYSTERIOUS_FEDORA",
		Note = "achievement_mysteriousfedora",
		Name = "mysterious fedora",
		Tooltip = {"beat", "beast", "as tainted", "friend"},
		CompletionMark = {FiendFolio.PLAYER.BRIEND, "Beast"},
		Tags = {"Briend", "Character", "BriendDisplay"}
	},

	-- Inaba Unlocks
	{
		ID = "ICE_IX",
		Name = "ice ix",
		Note = "achievement_iceix",
		Tooltip = {"beat", "mom", "as inaba"},
		Tags = {"Inaba", "InabaCompletion", "Character", "InabaDisplay", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "LIL_INABA",
		Note = "lil_inaba",
		Tooltip = {"beat", "mom's heart", "on hard", "as inaba"},
		CompletionMark = {FiendFolio.PLAYER.INABA, "Heart"},
		Tags = {"Inaba", "InabaCompletion", "Character", "InabaDisplay", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "ACUPUNCTURE_NEEDLES",
		Note = "acupuncture_needles",
		Name = "acupuncture needles",
		Tooltip = {"beat", "isaac", "as inaba"},
		CompletionMark = {FiendFolio.PLAYER.INABA, "Isaac"},
		Tags = {"Inaba", "InabaCompletion", "Character", "InabaDisplay", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "CRUSHING_ANXIETY",
		Note = "crushing_anxiety",
		Tooltip = {"beat", "???", "as inaba"},
		CompletionMark = {FiendFolio.PLAYER.INABA, "BlueBaby"},
		Tags = {"Inaba", "InabaCompletion", "Character", "InabaDisplay", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "PARANOIA",
		Note = "paranoia",
		Tooltip = {"beat", "satan", "as inaba"},
		CompletionMark = {FiendFolio.PLAYER.INABA, "Satan"},
		Tags = {"Inaba", "InabaCompletion", "Character", "InabaDisplay", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "PHOENIX_ELIXIR",
		Note = "phoenix_elixir",
		Tooltip = {"beat", "the lamb", "as inaba"},
		CompletionMark = {FiendFolio.PLAYER.INABA, "Lamb"},
		Tags = {"Inaba", "InabaCompletion", "Character", "InabaDisplay", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "SANGUINE_SALIVATION",
		Note = "sanguine_salivation",
		Tooltip = {"beat", "boss rush", "as inaba"},
		CompletionMark = {FiendFolio.PLAYER.INABA, "BossRush"},
		Tags = {"Inaba", "InabaCompletion", "Character", "InabaDisplay", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "HYPERFIXATION",
		Note = "hyperfixation",
		Tooltip = {"beat", "hush", "as inaba"},
		CompletionMark = {FiendFolio.PLAYER.INABA, "Hush"},
		Tags = {"Inaba", "InabaCompletion", "Character", "InabaDisplay", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "ISOLATED",
		Note = "isolated",
		Tooltip = {"beat", "delirium", "as inaba"},
		CompletionMark = {FiendFolio.PLAYER.INABA, "Delirium"},
		Tags = {"Inaba", "InabaCompletion", "Character", "InabaDisplay", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "GREEN_BOMBS",
		Note = "green_bombs",
		Tooltip = {"beat", "mega satan", "as inaba"},
		CompletionMark = {FiendFolio.PLAYER.INABA, "MegaSatan"},
		Tags = {"Inaba", "InabaCompletion", "Character", "InabaDisplay", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "BOUNDLESS_PARASOL",
		Note = "boundless_parasol",
		Tooltip = {"beat", "mother", "as inaba"},
		CompletionMark = {FiendFolio.PLAYER.INABA, "Mother"},
		Tags = {"Inaba", "InabaCompletion", "Character", "InabaDisplay", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "DUMB_BUNNY",
		Note = "dumb_bunny",
		Tooltip = {"beat", "beast", "as inaba"},
		CompletionMark = {FiendFolio.PLAYER.INABA, "Beast"},
		Tags = {"Inaba", "InabaCompletion", "Character", "InabaDisplay", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "SERTRALINE",
		Note = "sertraline",
		Name = "sertraline pack",
		Tooltip = {"beat", "greed mode", "as inaba"},
		CompletionMark = {FiendFolio.PLAYER.INABA, "Greed"},
		Tags = {"Inaba", "InabaCompletion", "Character", "InabaDisplay", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "REPRESSION",
		Note = "repression",
		Tooltip = {"beat", "greedier mode", "as inaba"},
		CompletionMark = {FiendFolio.PLAYER.INABA, "Greedier"},
		Tags = {"Inaba", "InabaCompletion", "Character", "InabaDisplay", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "RABBITS_FOOT",
		Note = "rabbits_foot",
		Name = "rabbit's foot",
		Tooltip = {"beat", "everything", "on hard", "as inaba"},
		CompletionMark = {FiendFolio.PLAYER.INABA, "All"},
		Tags = {"Inaba", "InabaAll", "Character", "InabaDisplay", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},

	-- Binaba Unlocks
	{
		ID = "LUNATIC_EYE",
		Note = "lunatic_eye",
		Tooltip = {"beat isaac,", "???, satan", "and the lamb", "as tainted", "inaba"},
		ViewerTooltip = {"beat isaac, ???, satan", "and the lamb as tainted inaba"},
		CompletionMark = {FiendFolio.PLAYER.BINABA, "Quartet"},
		Tags = {"Binaba", "Character", "BinabaDisplay", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "SOUL_OF_INABA",
		Note = "soul_of_inaba",
		Tooltip = {"beat boss", "rush and hush", "as tainted", "inaba"},
		CompletionMark = {FiendFolio.PLAYER.BINABA, "Duet"},
		Tags = {"Binaba", "Character", "BinabaDisplay", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "SOUL_SHARD",
		Note = "soul_shard",
		Tooltip = {"beat", "mega satan", "as tainted", "inaba"},
		CompletionMark = {FiendFolio.PLAYER.BINABA, "MegaSatan"},
		Tags = {"Binaba", "Character", "BinabaDisplay", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "THE_INVISIBLE_MOON",
		Note = "the_invisible_moon",
		Tooltip = {"beat", "greedier mode", "as tainted", "inaba"},
		CompletionMark = {FiendFolio.PLAYER.BINABA, "Greedier"},
		Tags = {"Binaba", "Character", "BinabaDisplay", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "OCULAR_SPECTRUM",
		Note = "ocular_spectrum",
		Tooltip = {"beat", "delirium", "as tainted", "inaba"},
		CompletionMark = {FiendFolio.PLAYER.BINABA, "Delirium"},
		Tags = {"Binaba", "Character", "BinabaDisplay", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "SEWING_MANUAL",
		Note = "sewing_manual",
		Tooltip = {"beat", "mother", "as tainted", "inaba"},
		CompletionMark = {FiendFolio.PLAYER.BINABA, "Mother"},
		Tags = {"Binaba", "Character", "BinabaDisplay", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "BEREAVEMENT",
		Note = "bereavement",
		Tooltip = {"beat", "beast", "as tainted", "inaba"},
		CompletionMark = {FiendFolio.PLAYER.BINABA, "Beast"},
		Tags = {"Binaba", "Character", "BinabaDisplay", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},

	-- Mecha Satan Unlocks
	{
		ID = "LOADED_D6",
		Note = "loaded_d6",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as isaac"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as isaac"},
		Tags = {"MechaSatan", "MechaSatanVanilla", "Character"}
	},
	{
		ID = "QUEENS_FRUIT",
		Note = "queens_fruit",
		Name = "queen's fruit",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as magdalene"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as magdalene"},
		Tags = {"MechaSatan", "MechaSatanVanilla", "Character"}
	},
	{
		ID = "HAPPY_SQUIRREL",
		Note = "happy_squirrel",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as cain"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as cain"},
		Tags = {"MechaSatan", "MechaSatanVanilla", "Character"}
	},
	{
		ID = "BOOK_OF_LEVIATHAN",
		Note = "achievement_bookofleviathan",
		Name = "book of leviathan",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as judas"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as judas"},
		Tags = {"MechaSatan", "MechaSatanVanilla", "Character"}
	},
	{
		ID = "NUGGET_BOMBS",
		Note = "achievement_nuggetbombs",
		Name = "nugget bombs",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as ???"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as ???"},
		Tags = {"MechaSatan", "MechaSatanVanilla", "Character"}
	},
	{
		ID = "TORTURE_COOKIE",
		Note = "achievement_torturecookie",
		Name = "torture cookie",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as eve"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as eve"},
		Tags = {"MechaSatan", "MechaSatanVanilla", "Character"}
	},
	{
		ID = "WARFARIN",
		Note = "achievement_warfarin",
		Name = "warfarin",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as samson"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as samson"},
		Tags = {"MechaSatan", "MechaSatanVanilla", "Character"}
	},
	{
		ID = "SHADOW_CLUSTER",
		Note = "shadow_cluster",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as azazel"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as azazel"},
		Tags = {"MechaSatan", "MechaSatanVanilla", "Character"}
	},
	{
		ID = "DEADLY_DOSE",
		Note = "deadly_dose",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as lazarus"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as lazarus"},
		Tags = {"MechaSatan", "MechaSatanVanilla", "Character"}
	},
	{
		ID = "EDENS_HEAD",
		Note = "edens_head",
		Name = "eden's_head",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as eden"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as eden"},
		Tags = {"MechaSatan", "MechaSatanVanilla", "Character"}
	},
	{
		ID = "GODHEAD_JR",
		Note = "achievement_godheadjr",
		Name = "godhead jr.",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as lost"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as lost"},
		Tags = {"MechaSatan", "MechaSatanVanilla", "Character"}
	},
	{
		ID = "EARTH_OF_ADAM",
		Note = "earth_of_adam",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as lilith"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as lilith"},
		Tags = {"MechaSatan", "MechaSatanVanilla", "Character"}
	},
	{
		ID = "GOLDEN_WATCH",
		Note = "golden_watch",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as keeper"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as keeper"},
		Tags = {"MechaSatan", "MechaSatanVanilla", "Character"}
	},
	{
		ID = "OWL_FEATHER",
		Note = "owl_feather",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as apollyon"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as apollyon"},
		Tags = {"MechaSatan", "MechaSatanVanilla", "Character"}
	},
	{
		ID = "BONE_LORDS_TABLET",
		Note = "bone_lords_tablet",
		Name = "bone lord's tablet",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as forgotten"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as forgotten"},
		Tags = {"MechaSatan", "MechaSatanVanilla", "Character"}
	},
	{
		ID = "PAGE_OF_VIRTUES",
		Note = "page_of_virtues",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as bethany"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as bethany"},
		Tags = {"MechaSatan", "MechaSatanVanilla", "Character"}
	},
	{
		ID = "DOUBLES",
		Note = "achievement_doubles",
		Name = "doubles!",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as jacob", "and esau"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as jacob and esau"},
		Tags = {"MechaSatan", "MechaSatanVanilla", "Character"}
	},
	{
		ID = "FIENDS_LOST_FRIEND",
		Note = "fiends_lost_friend",
		Name = "fiend's lost friend",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as fiend"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as fiend"},
		Tags = {"MechaSatan", "MechaSatanVanilla", "Fiend", "FiendCompletion", "Character", "FiendDisplay"}
	},
	{
		ID = "ASTEROID_BELT",
		Note = "asteroid_belt",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as golem"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as golem"},
		Tags = {"MechaSatan", "MechaSatanVanilla", "Golem", "GolemCompletion", "Character", "GolemDisplay"}
	},
	{
		ID = "FRIENDLY_FIRE",
		Note = "friendly_fire",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as friend"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as friend"},
		Tags = {"MechaSatan", "MechaSatanVanilla", "Friend", "FriendCompletion", "Character", "FriendDisplay"}
	},
	{
		ID = "HARE_TRIGGER",
		Note = "hare_trigger",
		Name = "hare-trigger",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as inaba"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as inaba"},
		Tags = {"MechaSatan", "MechaSatanVanilla", "Inaba", "InabaCompletion", "Character", "InabaHidden", "InabaDisplay"},
		NoInsertTags = {"InabaHidden"},
	},

	-- Mecha Satan Tainted Unlocks
	{
		ID = "ISAACD_EULOGY",
		Note = "isaacd_eulogy",
		Name = "isaac'd's eulogy",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as tainted", "isaac"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as tainted isaac"},
		Tags = {"MechaSatan", "MechaSatanTainted", "Character"}
	},
	{
		ID = "APPENDIX",
		Note = "achievement_appendix",
		Name = "appendix",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as tainted", "magdalene"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as tainted magdalene"},
		Tags = {"MechaSatan", "MechaSatanTainted", "Character"}
	},
	{
		ID = "GAPER_IN_A_JAR",
		Note = "gaper_in_a_jar",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as tainted", "cain"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as tainted cain"},
		Tags = {"MechaSatan", "MechaSatanTainted", "Character"}
	},
	{
		ID = "EXECUTIONER",
		Note = "executioner",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as tainted", "judas"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as tainted judas"},
		Tags = {"MechaSatan", "MechaSatanTainted", "Character"}
	},
	{
		ID = "THE_BROWN_HORN",
		Note = "brown_horn",
		Name = "the brown horn",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as tainted", "???"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as tainted ???"},
		Tags = {"MechaSatan", "MechaSatanTainted", "Character"}
	},
	{
		ID = "BAD_BLOOD",
		Note = "bad_blood",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as tainted", "eve"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as tainted eve"},
		Tags = {"MechaSatan", "MechaSatanTainted", "Character"}
	},
	{
		ID = "LIL_MINX",
		Note = "lil_minx",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as tainted", "samson"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as tainted samson"},
		Tags = {"MechaSatan", "MechaSatanTainted", "Character"}
	},
	{
		ID = "HELLFIRE",
		Note = "hellfire",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as tainted", "azazel"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as tainted azazel"},
		Tags = {"MechaSatan", "MechaSatanTainted", "Character"}
	},
	{
		ID = "LOURDES_WATER",
		Note = "lourdes_water",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as tainted", "lazarus"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as tainted lazarus"},
		Tags = {"MechaSatan", "MechaSatanTainted", "Character"}
	},
	{
		ID = "NIL_PASTA",
		Note = "nil_pasta",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as tainted", "eden"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as tainted eden"},
		Tags = {"MechaSatan", "MechaSatanTainted", "Character"}
	},
	{
		ID = "CROSS_NECKLACE",
		Note = "cross_necklace",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as tainted", "lost"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as tainted lost"},
		Tags = {"MechaSatan", "MechaSatanTainted", "Character"}
	},
	{
		ID = "BLASTULATION",
		Note = "blastulation",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as tainted", "lilith"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as tainted lilith"},
		Tags = {"MechaSatan", "MechaSatanTainted", "Character"}
	},
	{
		ID = "D2",
		Note = "d2",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as tainted", "keeper"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as tainted keeper"},
		Tags = {"MechaSatan", "MechaSatanTainted", "Character"}
	},
	{
		ID = "MUSCA",
		Note = "achievement_musca",
		Name = "musca",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as tainted", "apollyon"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as tainted apollyon"},
		Tags = {"MechaSatan", "MechaSatanTainted", "Character"}
	},
	{
		ID = "DOUBLE_DOG",
		Note = "double_dog",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as tainted", "forgotten"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as tainted forgotten"},
		Tags = {"MechaSatan", "MechaSatanTainted", "Character"}
	},
	{
		ID = "ACHERON",
		Note = "acheron",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as tainted", "bethany"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as tainted bethany"},
		Tags = {"MechaSatan", "MechaSatanTainted", "Character"}
	},
	{
		ID = "MONSTER_DOMESTICATION_GUIDE",
		Note = "monster_domestication_guide",
		Name = "m. domestication guide",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as tainted", "jacob"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as tainted jacob"},
		Tags = {"MechaSatan", "MechaSatanTainted", "Character"}
	},
	{
		ID = "HUITLACOCHE",
		Note = "huitlacoche",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as tainted", "fiend"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as tainted fiend"},
		Tags = {"MechaSatan", "MechaSatanTainted", "Biend", "Character", "BiendDisplay"}
	},
	{
		ID = "COPPER_BAR",
		Note = "copper_bar",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as tainted", "golem"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as tainted golem"},
		Tags = {"MechaSatan", "MechaSatanTainted", "Bolem", "Character", "BolemDisplay"}
	},
	{
		ID = "MAGIC_BULLET",
		Note = "magicbullet-A",
		Name = "magic bullet",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as tainted", "friend"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as tainted friend"},
		Tags = {"MechaSatan", "MechaSatanTainted", "Briend", "Character", "BriendDisplay"}
	},
	{
		ID = "SHADOW_RABBITS",
		Note = "shadow_rabbits",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as tainted", "inaba"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as tainted inaba"},
		Tags = {"MechaSatan", "MechaSatanTainted", "Binaba", "Character", "InabaHidden", "BinabaDisplay"},
		NoInsertTags = {"InabaHidden"},
	},

	-- Mecha Satan Tarnished Unlocks
	{
		ID = "SKELETALFIEND_SPICY_KEY",
		Note = "skeletal_fiend/achievement_key",
		Name = "the ol' spicy keychain",
		Tooltip = {"beat ???, lamb,", "mega satan,", "mother, beast,", "delirium or", "ultra greedier", "in fiend folio", "as the","skeletal fiend"},
		ViewerTooltip = {"beat ???, lamb, mega satan, mother, beast, delirium", "or ultra greedier in fiend folio as the skeletal fiend"},
		Tags = {"MechaSatan", "MechaSatanTarnished", "SkeletalFiend", "SkeletalFiendCompletion", "Character", "SkeletalFiendDisplay"},
		Tarnished = true,
		NoCountCompletion = true
	},

	-- All Clear Unlocks
	{
		ID = "TOY_CAMERA",
		Note = "toy_camera",
		Tooltip = {"beat", "mom", "as fiend,", "golem, friend,", "and inaba"},
		Tags = {"AllClear", "Character", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "BAG_OF_BOBBIES",
		Note = "bag_of_bobbies",
		Tooltip = {"beat", "mom's heart", "as fiend,", "golem, friend,", "and inaba"},
		Tags = {"AllClear", "Character", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "CRY_BABY",
		Note = "cry_baby",
		Tooltip = {"beat", "isaac", "as fiend,", "golem, friend,", "and inaba"},
		Tags = {"AllClear", "Character", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "TOYBOX",
		Note = "toybox",
		Tooltip = {"beat", "???", "as fiend,", "golem, friend,", "and inaba"},
		Tags = {"AllClear", "Character", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "DARK_BARGAIN",
		Note = "dark_bargain",
		Tooltip = {"beat", "satan", "as fiend,", "golem, friend,", "and inaba"},
		Tags = {"AllClear", "Character", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "LIL_LAMB",
		Note = "achievement_lillamb",
		Name = "lil lamb",
		Tooltip = {"beat", "the lamb", "as fiend,", "golem, friend,", "and inaba"},
		Tags = {"AllClear", "Character", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "ANGRY_FAIC",
		Note = "angry_faic",
		Tooltip = {"beat", "boss rush", "as fiend,", "golem, friend,", "and inaba"},
		Tags = {"AllClear", "Character", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "GIZMO_BOOTS",
		Note = "gizmo_boots",
		Tooltip = {"beat", "hush", "as fiend,", "golem, friend,", "and inaba"},
		Tags = {"AllClear", "Character", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "BAD_DATA",
		Note = "bad_data",
		Tooltip = {"beat", "delirium", "as fiend,", "golem, friend,", "and inaba"},
		Tags = {"AllClear", "Character", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "DEVILS_DAGGER",
		Note = "devils_dagger",
		Name = "devil's dagger",
		Tooltip = {"beat", "mega satan", "as fiend,", "golem, friend,", "and inaba"},
		Tags = {"AllClear", "Character", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "CHERUB_CHUBBY",
		Note = "cherub_chubby",
		Tooltip = {"beat", "mother", "as fiend,", "golem, friend,", "and inaba"},
		Tags = {"AllClear", "Character", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "BEAST_BEGGAR",
		Note = "evil_beggar",
		Tooltip = {"beat", "beast", "as fiend,", "golem, friend,", "and inaba"},
		Tags = {"AllClear", "Character", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "COOL_SUNGLASSES",
		Note = "cool_sunglasses",
		Tooltip = {"beat", "greed mode", "as fiend,", "golem, friend,", "and inaba"},
		Tags = {"AllClear", "Character", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},

	-- Challenge Unlocks
	{
		ID = "DEVILS_HARVEST_CHALLENGE",
		Note = "achievement_ffchallenge_devils_harvest",
		Name = "the devil's harvest",
		Tooltip = {"unlock", "fiend", "and", "the womb"},
		Tags = {"Challenge", "ChallengeUnlock"},
	},
	{
		ID = "NO_OFFENSE",
		Note = "achievement_ffchallenge_no_offense",
		Name = "no offense",
		Tooltip = {"find 6", "offensive items", "in a run"},
		Tags = {"Challenge", "ChallengeUnlock"},
	},
	{
		ID = "HANDLE_WITH_CARE",
		Note = "achievement_ffchallenge_handle_with_care",
		Name = "handle with care",
		Tooltip = {"take damage", "100 times", "or", "unlock", "heart of", "china"},
		ViewerTooltip = {"take damage 100 times", "or unlock heart of china"},
		Tags = {"Challenge", "ChallengeUnlock"},
	},
	{
		ID = "DADS_HOME",
		Note = "achievement_ffchallenge_dads_home",
		Name = "dad's home+",
		Tooltip = {"find a", "dad item", "in a run"},
		Tags = {"Challenge", "ChallengeUnlock"},
	},
	{
		ID = "BLURSED",
		Note = "achievement_ffchallenge_blursed",
		Name = "blursed",
		Tooltip = {"unlock", "black", "lantern"},
		Tags = {"Challenge", "ChallengeUnlock"},
	},
	{
		ID = "MR_HANDS",
		Note = "achievement_ffchallenge_mr_hands",
		Name = "mr. hands",
		Tooltip = {"find grabber"},
		Tags = {"Challenge", "ChallengeUnlock"},
	},
	{
		ID = "FROG_MODE",
		Note = "achievement_ffchallenge_frog_mode",
		Name = "frog mode",
		Tooltip = {"unlock", "flooded", "caves"},
		Tags = {"Challenge", "ChallengeUnlock"},
	},
	{
		ID = "DIRTY_BUBBLE",
		Note = "achievement_ffchallenge_dirty_bubble",
		Name = "dirty bubble challenge",
		Tooltip = {"pop 50", "bubbles"},
		Tags = {"Challenge", "ChallengeUnlock"},
	},
	{
		ID = "PEN_ISLAND",
		Note = "achievement_ffchallenge_penisland",
		Name = "pen island",
		Tooltip = {"unlock", "the", "planetarium"},
		Tags = {"Challenge", "ChallengeUnlock"},
	},
	{
		ID = "REAL_JON",
		Note = "achievement_ffchallenge_real_jon",
		Name = "the real jon",
		Tooltip = {"unlock", "necropolis", "and", "bone hearts"},
		Tags = {"Challenge", "ChallengeUnlock"},
	},
	{
		ID = "BRICK_BY_BRICK",
		Note = "achievement_ffchallenge_brick_by_brick",
		Name = "brick by brick",
		Tooltip = {"unlock", "golem", "and", "golden", "trinkets"},
		Tags = {"Challenge", "ChallengeUnlock"},
	},
	{
		ID = "TOWER_OFFENSE",
		Note = "achievement_ffchallenge_tower_offense",
		Name = "tower offense",
		Tooltip = {"unlock", "golem", "and", "brown nugget"},
		Tags = {"Challenge", "ChallengeUnlock"},
	},
	{
		ID = "CRAIGS_CHALLENGE",
		Note = "achievement_ffchallenge_craigs_challenge",
		Name = "craig's challenge",
		Tooltip = {"kill", "craig"},
		Tags = {"Challenge", "ChallengeUnlock"},
	},
	{
		ID = "ALLOW_ENEMY_REPLACEMENTS",
		Note = "achievement_ffchallenge_allow_enemy_replacements",
		Name = "allow e. replacements",
		Tooltip = {"unlock every", "floor,", "cameo boss,", "something", "wicked+,", "the gate is", "open, and a", "strange door"},
		ViewerTooltip = {"unlock every floor, cameo boss, something wicked+,", "the gate is open, and a strange door"},
		Tags = {"Challenge", "ChallengeUnlock"},
	},
	{
		ID = "EMBRYOS_AKIMBO",
		Note = "achievement_ffchallenge_embryos_akimbo",
		Name = "embryos akimbo",
		Tooltip = {"unlock lilith,", "birthright,", "lil friend,", "how to roll,", "and", "cherry bomb"},
		ViewerTooltip = {"unlock lilith, birthright, lil friend,", "how to roll, and cherry bomb"},
		Tags = {"Challenge", "ChallengeUnlock"},
	},
	{
		ID = "MAGNA_FARTA",
		Note = "achievement_ffchallenge_magna_farta",
		Name = "magna farta",
		Tooltip = {"unlock", "the soiled", "and", "rainbow bean"},
		Tags = {"Challenge", "ChallengeUnlock"},
	},
	{
		ID = "ISAAC_REBUILT",
		Note = "achievement_ffchallenge_isaac_rebuilt",
		Name = "isaac rebuilt",
		Tooltip = {"unlock", "the dauntless", "and", "birthright"},
		Tags = {"Challenge", "ChallengeUnlock"},
	},
	{
		ID = "BOSS_MAKES_A_DOLLAR",
		Note = "achievement_ffchallenge_boss_makes_a_dollar",
		Name = "boss makes a dollar",
		Tooltip = {"unlock", "keeper,", "cursed penny,", "and", "blue map"},
		Tags = {"Challenge", "ChallengeUnlock"},
	},
	{
		ID = "BABY_SENSORY",
		Note = "achievement_ffchallenge_image",
		Name = "baby sensory",
		Tooltip = {"unlock m.", "harbingers,", "golden slot", "machine,", "empty gaze,", "daydream,", "schoolbag,", "pet rock, and", "dud's flower"},
		ViewerTooltip = {"unlock modern harbingers, golden slot machine, empty", "gaze, daydream, schoolbag, pet rock, and dud's flower"},
		Tags = {"Challenge", "ChallengeUnlock"},
	},
	{
		ID = "GAUNTLET",
		Note = "achievement_ffchallenge_gauntlet",
		Name = "the gauntlet",
		Tooltip = {"unlock", "every floor,", "golem,", "and", "a strange", "door"},
		ViewerTooltip = {"unlock every floor, golem,", "and a strange door"},
		Tags = {"Challenge", "ChallengeUnlock"},
	},
	{
		ID = "IMPERISHABLE_NIGHT",
		Note = "achievement_ffchallenge_imperishable_night",
		Name = "imperishable night",
		Tooltip = {"unlock", "scarred womb,", "mega satan,", "inaba, and", "sertraline", "pack"},
		ViewerTooltip = {"unlock scarred womb, mega satan,", "inaba, and sertraline pack"},
		Tags = {"Challenge", "ChallengeUnlock", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},

	-- Unlocked by Challenges
	{
		ID = "DEVILS_HARVEST",
		Note = "the_devils_harvest",
		Name = "the devil's harvest",
		Tooltip = {"complete", "the devil's", "harvest", "---------", "unlocks", "2 items"},
		ViewerTooltip = {"complete the devil's harvest"},
		Tags = {"Challenge", "ChallengeReward"},
		Challenge = true,
	},
	{
		ID = "APOTHEOSIS",
		Note = "apotheosis",
		Tooltip = {"complete", "no offense"},
		Tags = {"Challenge", "ChallengeReward"},
		Challenge = true,
	},
	{
		ID = "CHINAS_BELONGINGS",
		Note = "chinas_belongings",
		Name = "china's belongings",
		Tooltip = {"complete", "handle with", "care", "---------", "unlocks", "3 items"},
		ViewerTooltip = {"complete handle with care"},
		Tags = {"Challenge", "ChallengeReward"},
		Challenge = true,
	},
	{
		ID = "GREEN_HOUSE",
		Note = "green_house",
		Tooltip = {"complete", "dad's home+"},
		Tags = {"Challenge", "ChallengeReward"},
		Challenge = true,
	},
	{
		ID = "BLACK_CANDELABRA",
		Note = "black_candelabra",
		Tooltip = {"complete", "blursed"},
		Tags = {"Challenge", "ChallengeReward"},
		Challenge = true,
	},
	{
		ID = "RED_HAND",
		Note = "red_hand",
		Name = "grabber's enemy",
		Tooltip = {"complete", "mr. hands"},
		Tags = {"Challenge", "ChallengeReward"},
		Challenge = true,
	},
	{
		ID = "SLIPPYS_ORGANS",
		Note = "slippys_organs",
		Name = "slippy's organs",
		Tooltip = {"complete", "frog mode", "---------", "unlocks", "4 items"},
		ViewerTooltip = {"complete frog mode"},
		Tags = {"Challenge", "ChallengeReward"},
		Challenge = true,
	},
	{
		ID = "PETRIFIED_GEL",
		Note = "petrified_gel",
		Tooltip = {"complete", "dirty bubble", "challenge"},
		Tags = {"Challenge", "ChallengeReward"},
		Challenge = true,
	},
	{
		ID = "DEVILS_UMBRELLA",
		Note = "devils_umbrella",
		Name = "devil's umbrella",
		Tooltip = {"complete", "pen island"},
		Tags = {"Challenge", "ChallengeReward"},
		Challenge = true,
	},
	{
		ID = "SPARE_RIBS",
		Note = "spare_ribs",
		Tooltip = {"complete", "the real jon"},
		Tags = {"Challenge", "ChallengeReward"},
		Challenge = true,
	},
	{
		ID = "BRICK_SEPARATOR",
		Note = "brick_seperator",
		Tooltip = {"complete", "brick by brick"},
		Tags = {"Challenge", "ChallengeReward"},
		Challenge = true,
	},
	{
		ID = "LAWN_DARTS",
		Note = "lawn_darts",
		Tooltip = {"complete", "tower", "offense"},
		Tags = {"Challenge", "ChallengeReward"},
		Challenge = true,
	},
	{
		ID = "CRAIGS_UNLOCKS",
		Note = "craig_unlocks",
		Name = "craig's stuff",
		Tooltip = {"complete", "craig's", "challenge", "---------", "unlocks", "3 items"},
		ViewerTooltip = {"complete craig's challenge"},
		Tags = {"Challenge", "ChallengeReward"},
		Challenge = true,
	},
	{
		ID = "ETERNAL_D10",
		Note = "eternal_d10",
		Tooltip = {"complete", "allow enemy", "replacements"},
		Tags = {"Challenge", "ChallengeReward"},
		Challenge = true,
	},
	{
		ID = "GOOGLY_EYES",
		Note = "googly_eyes",
		Tooltip = {"complete", "embryos", "akimbo"},
		Tags = {"Challenge", "ChallengeReward"},
		Challenge = true,
	},
	{
		ID = "CAN_OF_BEANS",
		Note = "can_of_beans",
		Name = "can of beans",
		Tooltip = {"complete", "magna farta"},
		Tags = {"Challenge", "ChallengeReward"},
		Challenge = true,
	},
	{
		ID = "DEIMOS",
		Note = "deimos",
		Tooltip = {"complete", "isaac rebuilt"},
		Tags = {"Challenge", "ChallengeReward"},
		Challenge = true,
	},
	{
		ID = "TIME_IS_MONEY",
		Note = "time_is_money",
		Tooltip = {"complete", "boss makes", "a dollar"},
		Tags = {"Challenge", "ChallengeReward"},
		Challenge = true,
	},
	{
		ID = "IMAGES_UNLOCKS",
		Note = "images_unlocks",
		Name = "twinkle of contagion",
		Trinket = FiendFolio.ITEM.ROCK.ROCKY,
		Tooltip = {"complete", "baby", "sensory", "---------", "unlocks", "2 items"},
		ViewerTooltip = {"complete baby sensory"},
		Tags = {"Challenge", "ChallengeReward"},
		Challenge = true,
	},
	{
		ID = "GAUNTLET_BEATEN",
		Note = "achievement_community",
		Name = "community achievement",
		Tooltip = {"complete", "the gauntlet"},
		Tags = {"Challenge", "ChallengeReward"},
		Challenge = true,
	},
	{
		ID = "DICHROMATIC_BUTTERFLY",
		Note = "dichromatic_butterfly",
		Tooltip = {"complete", "imperishable", "night"},
		Tags = {"Challenge", "ChallengeReward", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
		Challenge = true,
	},

	-- Misc. Challenge Unlocks
	{
		ID = "SHARD_OF_CHINA",
		Note = "shard_of_china",
		Tooltip = {"lose", "handle with", "care"},
		Tags = {"Challenge", "ChallengeMisc"},
		Challenge = true,
	},
	{
		ID = "DADS_HOME_TRINKET",
		Note = "dads_home",
		Name = "dad's home",
		Tooltip = {"lose", "dad's home+"},
		Tags = {"Challenge", "ChallengeMisc"},
		Challenge = true,
	},
	{
		ID = "DUSTY_D10",
		Note = "dusty_d10",
		Tooltip = {"lose", "allow enemy", "replacements"},
		Tags = {"Challenge", "ChallengeMisc"},
		Challenge = true,
	},
	{
		ID = "ADBLOCKER",
		Note = "adblocker",
		Tooltip = {"lose", "baby", "sensory"},
		Tags = {"Challenge", "ChallengeMisc"},
		Challenge = true,
	},
	{
		ID = "LOST_ARTIFACT",
		Note = "lost_artifact",
		Tooltip = {"beat a", "boss in", "the gauntlet"},
		Tags = {"Challenge", "ChallengeMisc"},
		Challenge = true,
	},
	{
		ID = "RIDICULOUS_METAL",
		Note = "ridiculous_metal",
		Tooltip = {"clear", "chapter 1", "of", "the gauntlet"},
		Tags = {"Challenge", "ChallengeMisc"},
		Challenge = true,
	},
	{
		ID = "ATLAS_BURDEN",
		Note = "atlas_burden",
		Name = "atlas' burden",
		Tooltip = {"clear", "chapter 2", "of", "the gauntlet"},
		Tags = {"Challenge", "ChallengeMisc"},
		Challenge = true,
	},
	{
		ID = "POCKET_ROCKIT",
		Note = "pocket_rockit",
		Name = "pocket rock-it",
		Tooltip = {"clear", "chapter 3", "of", "the gauntlet"},
		Tags = {"Challenge", "ChallengeMisc"},
		Challenge = true,
	},
	{
		ID = "WORMHOLE_ROCK",
		Note = "wormhole_rock",
		Tooltip = {"clear", "chapter 4", "of", "the gauntlet"},
		Tags = {"Challenge", "ChallengeMisc"},
		Challenge = true,
	},

	-- Backdrop unlocks
	{
		ID = "BEE_SKIN",
		Note = "bee_skin",
		Tooltip = {"clear honeyed", "cellar", "rooms without", "taking damage", "25 times"},
		ViewerTooltip = {"clear honeyed cellar rooms", "without taking damage 25 times"},
		Tags = {"Backdrop", "Other"}
	},
	{
		ID = "MODERN_OUROBOROS",
		Note = "modern_ouroboros",
		Tooltip = {"clear", "smoky burning", "basement", "rooms without", "taking damage", "25 times"},
		ViewerTooltip = {"clear smoky burning basement rooms", "without taking damage 25 times"},
		Tags = {"Backdrop", "Other"}
	},
	{
		ID = "EARTH_IMPALE",
		Note = "earth_impale",
		Tooltip = {"clear", "primordial caves", "rooms without", "taking damage", "25 times"},
		ViewerTooltip = {"clear primordial caves rooms", "without taking damage 25 times"},
		Tags = {"Backdrop", "Other"}
	},
	{
		ID = "CHUNK_OF_TAR",
		Note = "chunk_of_tar",
		Tooltip = {"clear", "pipes dank", "depths", "rooms without", "taking damage", "25 times"},
		ViewerTooltip = {"clear pipes dank depths rooms", "without taking damage 25 times"},
		Tags = {"Backdrop", "Other"}
	},
	{
		ID = "MISPRINTED_GISH",
		Note = "achievement_misprintedgish",
		Name = "misprinted gish",
		Tooltip = {"clear", "trash dank", "depths", "rooms without", "taking damage", "25 times"},
		ViewerTooltip = {"clear trash dank depths rooms", "without taking damage 25 times"},
		Tags = {"Backdrop", "Other"}
	},
	{
		ID = "EMPTY_GAZE",
		Note = "empty_gaze",
		Tooltip = {"clear", "eyeball utero", "rooms without", "taking damage", "25 times"},
		ViewerTooltip = {"clear eyeball utero rooms", "without taking damage 25 times"},
		Tags = {"Backdrop", "Other"}
	},
	{
		ID = "CALLING_CARD",
		Note = "calling_card",
		Tooltip = {"clear", "psionic sheol", "rooms without", "taking damage", "25 times"},
		ViewerTooltip = {"clear psionic sheol rooms", "without taking damage 25 times"},
		Tags = {"Backdrop", "Other"}
	},
	{
		ID = "DRIED_PAINT",
		Note = "dried_paint",
		Tooltip = {"clear", "surreal sheol", "rooms without", "taking damage", "25 times"},
		ViewerTooltip = {"clear surreal sheol rooms", "without taking damage 25 times"},
		Tags = {"Backdrop", "Other"}
	},
	{
		ID = "LEMON_MISHUH",
		Note = "lemon_mishuh",
		Name = "lemon mishuh???",
		Tooltip = {"clear", "peepee dross", "rooms without", "taking damage", "25 times"},
		ViewerTooltip = {"clear peepee dross rooms", "without taking damage 25 times"},
		Tags = {"Backdrop", "Other"},
		OverridePaper = "paper",
	},
	{
		ID = "MTN_DEW",
		Note = "mtn_dew",
		Tooltip = {"clear", "irradiated", "ashpit", "rooms without", "taking damage", "25 times"},
		ViewerTooltip = {"clear irradiated ashpit rooms", "without taking damage 25 times"},
		Tags = {"Backdrop", "Other"}
	},
	{
		ID = "MORBID_HEART",
		Note = "morbid_heart",
		Tooltip = {"clear morbus", "rooms without", "taking damage", "25 times"},
		ViewerTooltip = {"clear morbus rooms", "without taking damage 25 times"},
		Tags = {"Backdrop", "Other"}
	},

	-- Misc Unlocks
	{
		ID = "PURPLE_PUTTY",
		Note = "purple_putty",
		Tooltip = {"kill", "50 enemies", "with immoral", "minions"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "FIEND_HEART",
		Note = "aehrt",
		Name = ">3",
		Tooltip = {"have 6 or", "more immoral", "hearts at once"},
		Tags = {"Misc", "Other"},
		ViewerDisplayIf = function()
			return FiendFolio.ACHIEVEMENT.IMMORAL_HEART:IsUnlocked()
		end,
	},
	{
		ID = "DEVILLED_EGG",
		Note = "devilled_egg",
		Tooltip = {"kill", "greg the egg"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "SKIP_CARD",
		Note = "skip_card",
		Tooltip = {"skip 20", "rooms"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "ZODIAC_BEGGAR",
		Note = "zodiac_beggar",
		Tooltip = {"enter a", "planetarium"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "FRAUDULENT_FUNGUS",
		Note = "fraudulent_fungus",
		Tooltip = {"have 3", "or more", "rotten hearts", "at once"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "FISTFUL_OF_ASH",
		Note = "fist_full_of_ash",
		Tooltip = {"have 6", "or more", "broken hearts", "at once"},
		Tags = {"Misc", "Other"},
	},
	{
		ID = "EVIL_STICKER",
		Note = "evil_sticker",
		Tooltip = {"get the worst", "cursed penny", "payout"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "FOOLS_GOLD_HEART",
		Note = "fools_gold_heart",
		Name = "fool's gold heart",
		Tooltip = {"get the best", "cursed penny", "payout"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "GOLDEN_CURSED_PENNY",
		Note = "golden_cursed_penny",
		Tooltip = {"pick up 50", "cursed pennies"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "DUDS_FLOWER",
		Note = "duds_flower",
		Item = {
			FiendFolio.ITEM.COLLECTIBLE.COPPER_WRENCH,
		},
		Name = "dud's flower",
		Tooltip = {"have a", "copper bomb", "fail to", "explode"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "CARELESS_WHISPERS",
		Note = "careless_whispers",
		Tooltip = {"kill", "whispers"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "GRIDDLE_CORNS",
		Note = "griddle_corns",
		Tooltip = {"kill", "griddle horn"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "HYDROKINESIS",
		Note = "achievement_hydrokinesis",
		Name = "hydrokinesis",
		Tooltip = {"kill", "rainmaker"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "QUEEN_OF_CLUBS",
		Note = "queen_of_clubs",
		Tooltip = {"kill", "singe"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "CLUTCHS_CURSE",
		Note = "clutchs_curse",
		Name = "clutch's curse",
		Tooltip = {"kill", "clutch"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "BLACK_LANTERN",
		Note = "black_lantern",
		Tooltip = {"kill", "gravedigger"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "RISKS_REWARD",
		Note = "risks_reward",
		Name = "risk's reward",
		Tooltip = {"kill", "psion"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "STEVENS_HAT",
		Note = "achievement_stevenshat",
		Name = "steven's hat",
		Tooltip = {"win a duel", "against a", "gunslinger", "steven"},
		Tags = {"Misc", "Other"},
		NoInsertTags = {"Briend"}
	},
	{
		ID = "MODERN_HARBINGERS",
		Note = "the_modern_harbingers",
		Tooltip = {"unlock all", "afterbirth", "floors"},
		Tags = {"Misc", "Other"},
		OverridePaper = "_skin_paper",
	},
	{
		ID = "SEVEN_SEALS_2",
		Note = "achievement_sevenseals2",
		Name = "seven seals 2",
		Tooltip = {"kill every", "modern", "harbinger"},
		Tags = {"Misc", "Other"},
	},
	{
		ID = "FLEA_OF_MELTDOWN",
		Note = "flea_of_meltdown",
		Tooltip = {"kill", "meltdown", "3 times"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "FLEA_OF_DELUGE",
		Note = "flea_of_deluge",
		Tooltip = {"kill", "deluge", "3 times"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "FLEA_OF_POLLUTION",
		Note = "flea_of_pollution",
		Tooltip = {"kill", "pollution", "3 times"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "FLEA_OF_PROPAGANDA",
		Note = "flea_of_propaganda",
		Tooltip = {"kill", "propaganda", "3 times"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "FLEA_CIRCUS",
		Note = "flea_circus",
		Tooltip = {"unlock every", "apocalypse", "flea"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "DADS_HALF",
		Note = "dads_half",
		Name = "dad's half",
		Tooltip = {"kill", "the beast"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "SOUL_OF_RANDOM",
		Note = "soul_of_random",
		Tooltip = {"unlock half", "of all", "soul stones"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "BIFURCATED_STARS",
		Note = "bifurcated_card",
		Tooltip = {"enter an", "item room", "you had", "previously", "skipped", "beyond the", "strange door"},
		ViewerTooltip = {"enter an item room you had previously skipped", "beyond the strange door"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "DELUXE",
		Note = "the_deluxe",
		Tooltip = {"unlock every", "type of heart"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "THIRTEEN_OF_STARS",
		Note = "13_of_stars",
		Tooltip = {"chance when", "using a new", "glitched active", "item"},
		Tags = {"Misc", "Other"},
		Challenge = true,
	},
	{
		ID = "MINOR_ARCANA_KINGS",
		Note = "kings_minor_arcana",
		Tooltip = {"unlock:", "", "horse pills", "gold trinkets", "gold batteries"},
		ViewerTooltip = {"unlock horse pills, gold trinkets,", "and gold batteries"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "KING_OF_DIAMONDS",
		Note = "king_of_diamonds",
		Tooltip = {"blow up", "25 fool's", "gold rocks"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "PLAGUE_OF_DECAY",
		Note = "plague_of_decay",
		Tooltip = {"bomb a", "rotten beggar"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "IMPLOSION",
		Note = "implosion",
		Tooltip = {"kill 50", "enemies using", "malice's", "fireball"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "GOLDEN_REWARD_PLATE",
		Note = "golden_button",
		Tooltip = {"press 79", "reward plates"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "GLASS_CHEST",
		Note = "glass_chest",
		Tooltip = {"kill a boss", "in the mirror", "dimension"},
		Tags = {"Misc", "Other"},
	},
	{
		ID = "HAUNTED_PENNY",
		Note = "haunted_penny",
		Tooltip = {"have 8", "virtues wisps", "at once"},
		Tags = {"Misc", "Other"},
	},
	{
		ID = "PLANCHETTE",
		Note = "planchette",
		Tooltip = {"pick up 15", "haunted", "pennies"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "VIRTUOUS_BATTERY",
		Note = "virtuous_battery",
		Tooltip = {"have", "virtues wisps", "from 3", "different", "active items", "at once"},
		ViewerTooltip = {"have virtues wisps from", "3 different active items at once"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "SEAL_OF_ORICHALCOS",
		Note = "achievement_thesealoforichalcos",
		Name = "seal of orichalcos",
		Tooltip = {"kill", "50 enemies", "with virtues", "wisps"},
		Tags = {"Misc", "Other"}
	},
	--[[{
		ID = "RUNIC_CUBE",
		Note = "runic_cube",
		Tooltip = {"have 6", "item wisps", "at once"},
		Tags = {"Misc", "Other"}
	},]]--
	{
		ID = "DIRE_CHEST",
		Note = "dire_chest",
		-- Tooltip = {"complete the", "brown ritual"},
		Tooltip = {"convert a red", "chest into a", "dire chest", "using the", "secret method", "---------", "or make the", "middle hand"},
		ViewerTooltip = {"convert a red chest into a dire chest", "or make the middle hand"},
		Tags = {"Misc", "Other"},
	},
	{
		ID = "52_DECK",
		Note = "52_deck",
		Tooltip = {"trounce the", "poker table", "dealer and", "make him", "ragequit"},
		ViewerTooltip = {"trounce the poker table dealer", "and make him ragequit"},
		Tags = {"Misc", "Other"},
	},
	{
		ID = "RIGHT_HAND",
		Note = "the_right_hand",
		Tooltip = {"kill ???", "while holding", "the left hand"},
		Tags = {"Misc", "Other"},
	},
	{
		ID = "TOKEN",
		Note = "token",
		Name = "tokens",
		Tooltip = {"pick up", "1000 pickups", "in total"},
		Tags = {"Misc", "Other"},
	},
	{
		ID = "OLD_TESTAMENT",
		Note = "old_testament",
		Tooltip = {"use five", "different", "active items", "in a run"},
		Tags = {"Misc", "Other"},
	},
	{
		ID = "TOO_MANY_OPTIONS",
		Note = "too_many_options",
		Name = "too many options",
		Tooltip = {"enter an", "ultra secret", "room"},
		Tags = {"Misc", "Other"},
	},
	{
		ID = "THE_FINAL_OPTION",
		Note = "the_final_option",
		Name = "the final option",
		Tooltip = {"discover the", "final option"},
		Tags = {"Misc", "Other"},
	},
	{
		ID = "DAYDREAM",
		Note = "daydream",
		Name = "daydream",
		Tooltip = {"find 2", "dream or sleep", "related items", "in a run"},
		Tags = {"Misc", "Other"},
	},
	{
		ID = "SPECTRAL_KEYCHAIN",
		Note = "spectral_keychain",
		Name = "spectral keychain",
		Tooltip = {"use a", "curse of the gate", "keyghost"},
		Tags = {"Misc", "Other"},
	},
	--[[{
		ID = "SNOOZE_BUTTON",
		Note = "snooze_button",
		Name = "snooze button",
		Tooltip = {"stop the", "greed mode", "timer", "5 times"},
		Tags = {"Misc", "Other"},
	},]]--
	{
		ID = "TRICOLOR_KEY",
		Note = "tricolor_key",
		Name = "tricolor key",
		Tooltip = {"open 20", "puzzle locks"},
		Tags = {"Misc", "Other"},
	},
	{
		ID = "LUCKY_CAT",
		Note = "lucky_cat",
		Tooltip = {"see 100", "fortunes"},
		Tags = {"Misc", "Other"},
	},
	{
		ID = "CORRUPTED_LARVA",
		Note = "achievement_corrupted_larva",
		Name = "corrupted larva",
		Tooltip = {"get rewound", "by a", "level 0 fly"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "GOLDEN_POPSICLE",
		Note = "golden_popsicle",
		Tooltip = {"unlock every", "golden pickup"},
		Tags = {"Misc", "Other"},
	},
	{
		ID = "HINGE",
		Note = "hinge",
		Tooltip = {"find both", "lil fiend", "and", "lil friend", "in a run"},
		Tags = {"Misc", "Other"},
	},
	{
		ID = "DAZZLING_SLOT",
		Note = "dazzling_slot",
		Tooltip = {"play a", "golden slot", "machine", "until it", "breaks"},
		Tags = {"Misc", "Other"},
	},
	{
		ID = "BAPHOMETS_EXCHANGE",
		Note = "achievement_baphomets_exchange",
		Name = "baphomet's exchange",
		Tooltip = {"play a", "milk machine", "until it", "breaks"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "LOADSAMONEY",
		Note = "achievement_loadsamoney",
		Name = "loadsamoney",
		Tooltip = {"hold over", "99 coins", "at one time", "or", "pick up", "a token", "after", "a lil penny"},
		ViewerTooltip = {"hold over 99 coins at one time", "or pick up a token after a lil penny"},
		Tags = {"Misc", "Other"},
	},
	{
		ID = "GLITCHCITY",
		Note = "achievement_glitchcity",
		Name = "glitchcity",
		Tooltip = {"enter an", "error room"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "RAINBOW_BEAN",
		Note = "rainbow_bean",
		Tooltip = {"break open 50", "compost bins"},
		Tags = {"Misc", "Other"},
	},
	{
		ID = "LARGE_DOSE",
		Note = "large_dose",
		Tooltip = {"get the", "spun", "transformation", "for the", "first time"},
		Tags = {"Misc", "Other"},
	},
	{
		ID = "GREEN_CANDLE",
		Note = "green_candle",
		Tooltip = {"donate", "700 coins", "to the", "donation", "machine"},
		Tags = {"Misc", "Other"},
	},
	{
		ID = "PLATINUM_PENNY",
		Note = "platinum_penny",
		Tooltip = {"destroy a", "platinum", "poop"},
		Tags = {"Misc", "Other"},
	},
	{
		ID = "BLASPHEMY",
		Note = "blasphemy",
		Tooltip = {"win a run", "with", "damocles", "dangling"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "RED",
		Note = "red",
		Tooltip = {"enter 50", "red rooms"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "WRONG_WARP",
		Note = "wrong_warp",
		Tooltip = {"unlock", "every floor", "and", "a strange", "door"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "GIFT_CARD",
		Note = "gift_card",
		Tooltip = {"use", "mystery gift", "5 times", "or get", "a lump", "of coal", "from", "mystery gift"},
		ViewerTooltip = {"use mystery gift 5 times", "or get a lump of coal from mystery gift"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "BIRTHDAY_GIFT",
		Note = "birthday_gift",
		Tooltip = {"use", "mystery gift", "10 times", "or get", "the poop", "from", "mystery gift"},
		ViewerTooltip = {"use mystery gift 10 times", "or get the poop from mystery gift"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "ISAAC_DOT_CHR",
		Note = "isaac_dot_chr",
		Name = "isaac.chr",
		Tooltip = {"get 5", "glitched", "items", "in a run"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "BOTTLE_OF_WATER",
		Note = "bottle_of_water",
		Tooltip = {"swallow 100", "pills"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "CREATIVE_AI",
		Note = "creative_ai",
		Name = "creative a.i.",
		Tooltip = {"swap", "active items", "while under", "the effect of", "old testament"},
		ViewerTooltip = {"swap active items while under", "the effect of old testament"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "CORRUPTION",
		Note = "corruption",
		Tooltip = {"use a", "consumable", "active item", "or destroy an", "active item", "using", "eternal", "car battery"},
		ViewerTooltip = {"use a consumable active item", "or destroy an active item using eternal car battery"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "CHATTERBOX",
		Note = "chatterbox",
		Tooltip = {"activate", "a", "dice room"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "GOLEMS_SUB",
		Note = "golems_sub",
		Name = "golem's sub",
		Tooltip = {"smelt 15", "rock trinkets", "in a run"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "NEIGHBOURS_FROM_HELL",
		Note = "neighbours_from_hell",
		Tooltip = {"find 5", "non-rock", "trinkets", "in a run"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "PENNY_ALBUM",
		Note = "penny_album",
		Tooltip = {"use 10", "penny presses"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "ACE_OF_WANDS",
		Note = "achievement_aceofwands",
		Name = "ace of wands",
		Tooltip = {"beat the lamb", "without", "using", "active items", "for the", "entire run"},
		ViewerTooltip = {"beat the lamb without using", "active items for the entire run"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "ACE_OF_PENTACLES",
		Note = "achievement_aceofpentacles",
		Name = "ace of pentacles",
		Tooltip = {"beat the lamb", "without", "picking up", "trinkets", "for the", "entire run"},
		ViewerTooltip = {"beat the lamb without picking up", "trinkets for the entire run"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "ACE_OF_SWORDS",
		Note = "achievement_aceofswords",
		Name = "ace of swords",
		Tooltip = {"beat the lamb", "without", "picking up", "familiars", "for the", "entire run"},
		ViewerTooltip = {"beat the lamb without picking up", "familiars for the entire run"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "ACE_OF_CUPS",
		Note = "achievement_aceofcups",
		Name = "ace of cups",
		Tooltip = {"beat the lamb", "without", "using", "pills", "for the", "entire run"},
		ViewerTooltip = {"beat the lamb without using", "pills for the entire run"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "CHARACTER_SELECT",
		Note = "character_select",
		Name = "character select",
		Tooltip = {"collect and", "complete 3", "soul shards"},
		Tags = {"Misc", "Other", "InabaHidden"},
		NoInsertTags = {"InabaHidden"},
	},
	{
		ID = "MORBUS",
		Note = "morbus",
		Tooltip = {"enter", "the corpse"},
		Tags = {"Misc", "Other"},
		NoMenu = true,
		AlwaysUnlock = true, -- Ignores canAchievementsUnlock and canChallengeAchievementsUnlock
	},
	{
		ID = "MERN",
		Note = "mern",
		Tooltip = {"build a mern"},
		Tags = {"Misc", "Other"}
	},
	{
		ID = "IM_SORRY_ISAAC",
		Note = "achievement_dadtransformation",
		Name = "i'm sorry, isaac...",
		Tooltip = {"get the", "dad", "transformation", "for the", "first time"},
		Tags = {"Misc", "Other"},
	},
	{
		ID = "GET_IN_THE_BOX",
		Note = "achievement_steventransformation",
		Name = "get in the box!!",
		Tooltip = {"get the", "steven", "transformation", "for the", "first time"},
		Tags = {"Misc", "Other"},
	},
	{
		ID = "PRO_GOD",
		Note = "achievement_pro_god",
		Name = "pro god",
		Tooltip = {"unlock", "everything"},
		Tags = {"Misc", "Other"},
		NoCountCompletion = true
	},

	-- hidden tracker achievements
	{
		ID = "ETERNAL_REWARD_OBTAINED",
		NoMenu = true,
		Challenge = true,
		NoCountCompletion = true
	},

	-- placeholder achievement for the recents page
	{
		ID = "LOCKED_PLACEHOLDER",
		Unobtainable = true,
		NoCountCompletion = true,
		ViewerDisplayIf = function (currentGroup)
			return currentGroup.ShowRecent == true
		end,
		Note = "vanilla_locked",
		Tooltip = {"unlock something", "to fill", "this paper!"}
	},
}

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local playerToCompletionManagerName = {
	[FiendFolio.PLAYER.FIEND] = "Fiend",
	[FiendFolio.PLAYER.BIEND] = "FiendB",
	[FiendFolio.PLAYER.GOLEM] = "Golem",
	[FiendFolio.PLAYER.BOLEM] = "GolemB",
	[FiendFolio.PLAYER.FRIEND] = "Friend",
	[FiendFolio.PLAYER.INABA] = "Inaba",
	[FiendFolio.PLAYER.BINABA] = "InabaB",
}

local AchievementStageAPI = StageAPI.Class("Achievement")

function AchievementStageAPI:Init(id, tbl)
	self.ID = id

	if tbl.Note then
		self.Note = "gfx/ui/achievement/" .. tbl.Note .. ".png"
		self.Sprite = Sprite()
		self.Sprite:Load("gfx/ui/achievement/_ff_achievement.anm2", false)
		self.Sprite:ReplaceSpritesheet(0, "gfx/nothing.png")
		if tbl.Tarnished then --The skeletal fiend appears
			self.Sprite:ReplaceSpritesheet(1, "gfx/ui/achievement/skeletal_fiend/_tarnished_paper.png")
		elseif tbl.OverridePaper then
			self.Sprite:ReplaceSpritesheet(1, "gfx/ui/achievement/" .. tbl.OverridePaper .. ".png")
		end
		self.Sprite:ReplaceSpritesheet(2, self.Note)
		self.Sprite:LoadGraphics()
	end

	if tbl.CompletionMark then
		self.CompletionMark = {
			Player = tbl.CompletionMark[1],
			Mark = tbl.CompletionMark[2]
		}
		self.CompletionMark.PlayerName = playerToCompletionManagerName[self.CompletionMark.Player]
	end

	self.Tags = {}
	if tbl.Tags then
		for i, tag in ipairs(tbl.Tags) do
			self.Tags[i] = tag
			self.Tags[tag] = true
		end
	end

	self.NoInsertTags = {}
	if tbl.NoInsertTags then
		for i, tag in ipairs(tbl.NoInsertTags) do
			self.NoInsertTags[i] = tag
			self.NoInsertTags[tag] = true
		end
	end

	self.Name = tbl.Name
	self.Group = tbl.Group
	self.NoMenu = tbl.NoMenu
	if tbl.Tooltip then
		if not self.Name then
			self.Name = string.gsub(string.lower(tbl.Note), "_", " ")
		end

		self.Tooltip = tbl.Tooltip

		if not self.NoMenu then
			self.MenuButton = {
				str = self.Name,
				choices = {"locked", "unlocked"},
				variable = self.ID,
				setting = 1,
				load = function()
					return self:IsUnlocked(true) and 2 or 1
				end,
				store = function(var)
					self:SetUnlocked(var == 2)
				end,
				changefunc = function(button)
					self:SetUnlocked(button.setting == 2)
				end,
				tooltip = {strset = self.Tooltip},
				displayif = function()
                    if not FiendFolio.ACHIEVEMENT.INABA:IsUnlocked(true) then
						for _, tag in ipairs(self.Tags) do
							if tag == "InabaHidden" then
								return false
							end
						end
					end
					if self.Tarnished and not (Epiphany and Epiphany.API) then
						return false
					end
					return true
                end
			}
		end
	end

	if tbl.ViewerTooltip then
		self.ViewerTooltip = tbl.ViewerTooltip
	end

	self.ViewerDisplayIf = tbl.ViewerDisplayIf

	self.NoCountCompletion = tbl.NoCountCompletion -- Achievement is not required for 100% completion
	self.AlwaysUnlocked    = tbl.AlwaysUnlocked	   -- Achievement is always unlocked, will always be visible on the viewer, and has no unlock condition
	self.AlwaysUnlock 	   = tbl.AlwaysUnlock 	   -- Achievement cannot be blocked from unlocking except by Basement Renovator
	self.Challenge 		   = tbl.Challenge 		   -- Achievement uses the Challenge unlocks condition to test whether this unlock should be prevented
	self.Unobtainable 	   = tbl.Unobtainable	   -- In case you want to make an unobtainable achievement for some reason?
	self.Tarnished		   = tbl.Tarnished		   -- Achievement relates to a Tarnished character and should not appear without Epiphany installed.
	self.OverridePaper	   = tbl.OverridePaper	   -- Achievement uses a non-fiendish achievement paper

	if self.Unobtainable or self.AlwaysUnlocked then
		self.NoCountCompletion = true
	end
end

function AchievementStageAPI:IsUnlocked(ignoreModifiers)
	if self.Unobtainable then
		return false
	end

	if self.AlwaysUnlocked then
		return true
	end

	local canLock = FiendFolio.AreAchievementsEnabled()
	if not canLock and not ignoreModifiers then
		return true
	end

	-- sometimes unlock checks will run before save data is loaded
	return FiendFolio.savedata.achievements and FiendFolio.savedata.achievements[self.ID] == true
end

function AchievementStageAPI:Unlock(noNote, force)
	if self.Unobtainable or self.AlwaysUnlocked then
		return
	end

	local noNote = noNote or FiendFolio.ForceUnlockNoNote
	if not self:IsUnlocked(true) or force then
		local canLock, canUnlockAchievements, canUnlockChallengeAchievements, blockAlwaysUnlock = FiendFolio.AreAchievementsEnabled()
		if canUnlockAchievements or (canUnlockChallengeAchievements and self.Challenge) or (self.AlwaysUnlock and not blockAlwaysUnlock) or force then
			self:SetUnlocked(true)

			local showPopup = (canLock or force) and not noNote
			local unlockedRepentogonAchievement = mod:UnlockRepentogonAchievement(self.ID, showPopup, self.Challenge or force)

			if showPopup then
				if not unlockedRepentogonAchievement or self.Tarnished then
					FiendFolio.QueueAchievementNote(self.Note, self.Tarnished)
				end
			end

			Isaac.RunCallbackWithParam(FiendFolio.CALLBACK.POST_ACHIEVEMENT_UNLOCK, self.ID, self, noNote, force)
		end
	end
end

FiendFolio.ACHIEVEMENT_HISTORY_LENGTH = 10
function AchievementStageAPI:SetUnlocked(bool)
	if bool ~= nil and not self.AlwaysUnlocked then
		local unlockStateChanged = FiendFolio.savedata.achievements[self.ID] ~= bool
		FiendFolio.savedata.achievements[self.ID] = bool

		-- Make sure not to add Inaba stuff unless Inaba is unlocked
		local canShow = true
		if not FiendFolio.ACHIEVEMENT.INABA:IsUnlocked(true) then
			for _, tag in ipairs({"Inaba", "InabaHidden", "Binaba"}) do
				if mod:Contains(self.Tags, tag) then
					canShow = false
					break
				end
			end
		end
		
		-- Add it to the recently obtained achievements list
		if unlockStateChanged then
			if bool and self.ID ~= "ETERNAL_REWARD_OBTAINED" and canShow then
				table.insert(FiendFolio.savedata.recentAchievements, 1, self.ID)

				-- Remove achievements past the memory length
				local ACHIEVEMENT_HISTORY_LENGTH = mod.ACHIEVEMENT_HISTORY_LENGTH
				if #FiendFolio.savedata.recentAchievements > ACHIEVEMENT_HISTORY_LENGTH then
					for i = ACHIEVEMENT_HISTORY_LENGTH, #FiendFolio.savedata.recentAchievements do
						table.remove(FiendFolio.savedata.recentAchievements, ACHIEVEMENT_HISTORY_LENGTH+1)
					end
				end
			-- Otherwise remove it
			else
				for i = 1, #FiendFolio.savedata.recentAchievements do
					local achieve = FiendFolio.savedata.recentAchievements[i]
					if self.ID == achieve then
						table.remove(FiendFolio.savedata.recentAchievements, i)
						break
					end
				end
			end
		end

		if unlockStateChanged and FiendFolio.savedata and not bool then
			if self.ID == "HANDLE_WITH_CARE" then
				FiendFolio.savedata.timesPlayerTookDamage = 0
			elseif self.ID == "DIRTY_BUBBLE" then
				FiendFolio.savedata.bubblesPopped = 0
			elseif self.ID == "BEE_SKIN" then
				FiendFolio.savedata.honeyedRoomsPerfect = 0
			elseif self.ID == "MODERN_OUROBOROS" then
				FiendFolio.savedata.smokyRoomsPerfect = 0
			elseif self.ID == "EARTH_IMPALE" then
				FiendFolio.savedata.primordialRoomsPerfect = 0
			elseif self.ID == "CHUNK_OF_TAR" then
				FiendFolio.savedata.pipesRoomsPerfect = 0
			elseif self.ID == "MISPRINTED_GISH" then
				FiendFolio.savedata.trashRoomsPerfect = 0
			elseif self.ID == "EMPTY_GAZE" then
				FiendFolio.savedata.eyeballRoomsPerfect = 0
			elseif self.ID == "CALLING_CARD" then
				FiendFolio.savedata.psionicRoomsPerfect = 0
			elseif self.ID == "DRIED_PAINT" then
				FiendFolio.savedata.surrealRoomsPerfect = 0
			elseif self.ID == "LEMON_MISHUH" then
				FiendFolio.savedata.peepeeRoomsPerfect = 0
			elseif self.ID == "MTN_DEW" then
				FiendFolio.savedata.irradiatedRoomsPerfect = 0
			elseif self.ID == "MORBID_HEART" then
				FiendFolio.savedata.morbusRoomsPerfect = 0
			elseif self.ID == "PURPLE_PUTTY" then
				mod.savedata.immoralMinionKills = 0
			elseif self.ID == "SKIP_CARD" then
				mod.savedata.skippedRooms = 0
			elseif self.ID == "GOLDEN_CURSED_PENNY" then
				mod.savedata.cursedPennyPickups = 0
			elseif self.ID == "FLEA_OF_MELTDOWN" then
				mod.savedata.meltdownKills = 0
			elseif self.ID == "FLEA_OF_DELUGE" then
				mod.savedata.delugeKills = 0
			elseif self.ID == "FLEA_OF_POLLUTION" then
				mod.savedata.pollutionKills = 0
			elseif self.ID == "FLEA_OF_PROPAGANDA" then
				mod.savedata.propagandaKills = 0
			elseif self.ID == "KING_OF_DIAMONDS" then
				mod.savedata.foolsGoldBombed = 0
			elseif self.ID == "IMPLOSION" then
				mod.savedata.maliceKills = 0
			elseif self.ID == "GOLDEN_REWARD_PLATE" then
				mod.savedata.pressedRewardPlates = 0
			elseif self.ID == "PLANCHETTE" then
				mod.savedata.hauntedPennyPickups = 0
			elseif self.ID == "SEAL_OF_ORICHALCOS" then
				mod.savedata.virtuesWispKills = 0
			elseif self.ID == "TOKEN" then
				FiendFolio.savedata.totalPickupsPickedUp = 0
			elseif self.ID == "TRICOLOR_KEY" then
				FiendFolio.savedata.puzzleLocksUnlocked = 0
			elseif self.ID == "LUCKY_CAT" then
				FiendFolio.savedata.fortunesSeen = 0
			elseif self.ID == "RAINBOW_BEAN" then
				mod.savedata.compostBinsPopped = 0
			elseif self.ID == "RED" then
				mod.savedata.redRoomsVisited = 0
			elseif self.ID == "GIFT_CARD" or self.ID == "BIRTHDAY_GIFT" then
				FiendFolio.savedata.mysteryGiftsUsed = 0
			elseif self.ID == "BOTTLE_OF_WATER" then
				FiendFolio.savedata.pillsUsed = 0
			elseif self.ID == "PENNY_ALBUM" then
				FiendFolio.savedata.pennyPressesUsed = 0
			end
		end
	end
end

FiendFolio:AddCallback(ModCallbacks.MC_EXECUTE_CMD, function(_, cmd)
	if cmd == "unlockallff" then
		local achievements = FiendFolio.GetAchievementsWithTag(nil)
		FiendFolio.ForceUnlockNoNote = true
		for _, achievement in ipairs(achievements) do
			achievement:Unlock(true)
		end
		FiendFolio.ForceUnlockNoNote = nil
		print("Unlocked all FF achievements.")
	end
end)

FiendFolio.ACHIEVEMENT_ORDERED = {}
FiendFolio.TOTAL_COMPLETION_ACHIEVEMENTS = 0

for i, achievementData in ipairs(FiendFolio.ACHIEVEMENT) do
	local achievement = AchievementStageAPI(achievementData.ID, achievementData)
	if not achievement.NoCountCompletion then
		FiendFolio.TOTAL_COMPLETION_ACHIEVEMENTS = FiendFolio.TOTAL_COMPLETION_ACHIEVEMENTS + 1
	end

	FiendFolio.ACHIEVEMENT[i] = nil
	FiendFolio.ACHIEVEMENT[achievementData.ID] = achievement
	FiendFolio.ACHIEVEMENT_ORDERED[i] = FiendFolio.ACHIEVEMENT[achievementData.ID]
end

-- Returns:
--[[
	1: Can achievements lock features
	2: Can achievements be unlocked
	3: Can achievements with the Challenge attribute be unlocked
	4: Are achievements with the AlwaysUnlock attribute blocked
]]
function FiendFolio.AreAchievementsEnabled()
	if BasementRenovator and BasementRenovator.InTestRoom and BasementRenovator.InTestStage and (BasementRenovator:InTestRoom() or BasementRenovator:InTestStage()) then
		return false, false, false, true
	end

	if FiendFolio.savedata.disableAchievements then
		return false, FiendFolio.CanRunUnlockAchievements(), FiendFolio.CanChallengeRunUnlockAchievements(), false
	end

	return true, FiendFolio.CanRunUnlockAchievements(), FiendFolio.CanChallengeRunUnlockAchievements(), false
end

function FiendFolio.GetNumCompletedAchievements()
	local count = 0
	for _, achievement in ipairs(FiendFolio.ACHIEVEMENT_ORDERED) do
		if achievement:IsUnlocked(true) and not achievement.NoCountCompletion then
			count = count + 1
		end
	end

	return count
end

function FiendFolio.GetAchievementsWithTag(tag)
	local achievements = {}
	for _, achievement in ipairs(FiendFolio.ACHIEVEMENT_ORDERED) do
		if not tag or achievement.Tags[tag] then
			achievements[#achievements + 1] = achievement
		end
	end

	return achievements
end

function FiendFolio.GetAchievementById(id)
	for _, achievement in ipairs(FiendFolio.ACHIEVEMENT_ORDERED) do
		if achievement.ID == id then
			return achievement
		end
	end
end

function FiendFolio.GetMenuButtonsForAchievementTag(tag)
	local achievements = FiendFolio.GetAchievementsWithTag(tag)
	local buttons = {}
	for _, achievement in ipairs(achievements) do
		if achievement.MenuButton and not achievement.NoInsertTags[tag] then
			if #buttons ~= 0 then
				buttons[#buttons + 1] = {str = "", fsize = 1, nosel = true, displayif = function()
                    if not FiendFolio.ACHIEVEMENT.INABA:IsUnlocked(true) then
						for _, tag in ipairs(achievement.Tags) do
							if tag == "InabaHidden" then
								return false
							end
						end
					end
					if achievement.Tarnished and not (Epiphany and Epiphany.API) then
						return false
					end
					return true
                end,}
			end

			buttons[#buttons + 1] = achievement.MenuButton
		end
	end

	return buttons
end

function FiendFolio.RemoveFFItemsFromPool()
	if not FiendFolio.ItemsEnabled then
		local pool = game:GetItemPool()
		for _, id in pairs(FiendFolio.ITEM.COLLECTIBLE) do
			pool:RemoveCollectible(id)
		end
		for _, id in pairs(FiendFolio.ITEM.TRINKET) do
			pool:RemoveTrinket(id)
		end
	end
end

function FiendFolio.AchievementsPostGameStart()
	FiendFolio.TryUnlockCompletionAchievements()
	--FiendFolio.RemoveFFItemsFromPool()
end

function FiendFolio.GetAchievementSetUnlockCount(set)
	local count = 0
	local persistentData = Isaac.GetPersistentGameData()

	for _, key in ipairs(set) do
		if type(key) == "number" then
			if persistentData:Unlocked(key) then
				count = count + 1
			end
		elseif type(key) == "string" then
			if FiendFolio.ACHIEVEMENT[key] and FiendFolio.ACHIEVEMENT[key]:IsUnlocked(true) then
				count = count + 1
			end
		end
	end

	return count
end

function FiendFolio.IsAchievementSetUnlocked(set)
	return FiendFolio.GetAchievementSetUnlockCount(set) == #set
end

function FiendFolio.CanRunUnlockAchievements()
	return not game:AchievementUnlocksDisallowed()
end

mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function() mod.CurrentRunCanGrantUnlocks = nil end)
mod:AddCallback(ModCallbacks.MC_POST_GAME_END, function() mod.CurrentRunCanGrantUnlocks = nil end)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function() mod.CurrentRunCanGrantUnlocks = nil end)

function FiendFolio.CanChallengeRunUnlockAchievements()
	return Isaac.GetPersistentGameData():Unlocked(Achievement.THE_WOMB)
end

------------------------------------------
-- RANDOM UNLOCK CONDITIONS START HERE! --
------------------------------------------

-- King of diamonds, golden reward plate, mern, skip card
local isCurrentRoomClear
local existentFoolsGold = {}
local existentRewardPlates = {}

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	if mod.CanRunUnlockAchievements() then
		local room = game:GetRoom()
		isCurrentRoomClear = room:IsClear()

		if not FiendFolio.ACHIEVEMENT.KING_OF_DIAMONDS:IsUnlocked(true) then
			for _, index in pairs(existentFoolsGold) do
				local grid = room:GetGridEntity(index)
				if grid and grid:GetType() == GridEntityType.GRID_ROCK_GOLD and grid.State == 2 then
					mod.savedata.foolsGoldBombed = mod.savedata.foolsGoldBombed + 1
				end
			end

			existentFoolsGold = {}
			for i = 0, room:GetGridSize() do
				local grid = room:GetGridEntity(i)
				if grid and grid:GetType() == GridEntityType.GRID_ROCK_GOLD and not StageAPI.IsCustomGrid(i) then
					if grid.State == 1 then
						table.insert(existentFoolsGold, i)
					end
				end
			end

			if mod.savedata.foolsGoldBombed >= 25 then
				FiendFolio.ACHIEVEMENT.KING_OF_DIAMONDS:Unlock()
			end
		end

		if not FiendFolio.ACHIEVEMENT.GOLDEN_REWARD_PLATE:IsUnlocked(true) then
			for _, index in pairs(existentRewardPlates) do
				local grid = room:GetGridEntity(index)
				if grid and grid:ToPressurePlate() and (grid.State == 3 or grid.State == 4) then
					mod.savedata.pressedRewardPlates = mod.savedata.pressedRewardPlates + 1
				end
			end

			existentRewardPlates = {}
			for i = 0, room:GetGridSize() do
				local grid = room:GetGridEntity(i)
				if grid and grid:ToPressurePlate() and grid:GetVariant() == 1 and grid.State == 0 and not StageAPI.IsCustomGrid(i) then
					table.insert(existentRewardPlates, i)
				end
			end

			if mod.savedata.pressedRewardPlates >= 79 then
				FiendFolio.ACHIEVEMENT.GOLDEN_REWARD_PLATE:Unlock()
			end
		end
	end

	if not FiendFolio.ACHIEVEMENT.MERN:IsUnlocked(true) and Isaac.CountEntities(nil, 3, mod.ITEM.FAMILIAR.MERN_4) > 0 then
		FiendFolio.ACHIEVEMENT.MERN:Unlock()
	end
end)

local function ThrownFoolsGoldCheck(projectile)
	local sprite = projectile:GetSprite()
	if projectile:IsDead() and sprite:GetFilename() == "gfx/grid/grid_rock.anm2" and sprite:GetAnimation() == "foolsgold" then
		mod.savedata.foolsGoldBombed = mod.savedata.foolsGoldBombed + 1
	end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, entity) if mod.CanRunUnlockAchievements() and entity.Variant == ProjectileVariant.PROJECTILE_GRID then ThrownFoolsGoldCheck(entity) end end, 9)
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, entity) if mod.CanRunUnlockAchievements() and entity.Variant == TearVariant.GRIDENT               then ThrownFoolsGoldCheck(entity) end end, 2)

-- Skip card, zodiac beggar, bifurcated stars, red, morbus!
mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, CallbackPriority.LATE, function()
	if not mod.LOADED_SAVEDATA then return end -- I don't think this will ever actually be the case but better safe than sorry

	local room = game:GetRoom()

	if isCurrentRoomClear ~= nil and not isCurrentRoomClear and mod.CanRunUnlockAchievements() then
		isCurrentRoomClear = nil

		mod.savedata.skippedRooms = mod.savedata.skippedRooms + 1
		if mod.savedata.skippedRooms >= 20 and not FiendFolio.ACHIEVEMENT.SKIP_CARD:IsUnlocked(true) then
			FiendFolio.ACHIEVEMENT.SKIP_CARD:Unlock()
		end
	end

	if not FiendFolio.ACHIEVEMENT.ZODIAC_BEGGAR:IsUnlocked(true) and room:GetType() == RoomType.ROOM_PLANETARIUM then
		FiendFolio.ACHIEVEMENT.ZODIAC_BEGGAR:Unlock()
	end

	if not FiendFolio.ACHIEVEMENT.GLITCHCITY:IsUnlocked(true) and room:GetType() == RoomType.ROOM_ERROR then
		FiendFolio.ACHIEVEMENT.GLITCHCITY:Unlock()
	end

	if not FiendFolio.ACHIEVEMENT.BIFURCATED_STARS:IsUnlocked(true) and game:GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH) and room:GetType() == RoomType.ROOM_TREASURE and room:IsFirstVisit() then
		FiendFolio.ACHIEVEMENT.BIFURCATED_STARS:Unlock()
	end

	if not FiendFolio.ACHIEVEMENT.TOO_MANY_OPTIONS:IsUnlocked(true) and room:GetType() == RoomType.ROOM_ULTRASECRET then
		FiendFolio.ACHIEVEMENT.TOO_MANY_OPTIONS:Unlock()
	end

	if not FiendFolio.ACHIEVEMENT.MORBUS:IsUnlocked(true) then
		local level = game:GetLevel()
		if level:GetStage() == LevelStage.STAGE4_1 and level:GetStageType() == StageType.STAGETYPE_REPENTANCE then -- I'm in Corpse
			FiendFolio.ACHIEVEMENT.MORBUS:Unlock()
		end
	end

	if mod.CanRunUnlockAchievements() and room:IsFirstVisit() and game:GetLevel():GetCurrentRoomDesc().Flags & RoomDescriptor.FLAG_RED_ROOM == RoomDescriptor.FLAG_RED_ROOM then
		mod.savedata.redRoomsVisited = mod.savedata.redRoomsVisited + 1
		if not FiendFolio.ACHIEVEMENT.RED:IsUnlocked(true) and mod.savedata.redRoomsVisited >= 50 then
			FiendFolio.ACHIEVEMENT.RED:Unlock()
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function()
	isCurrentRoomClear = nil
end)

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.POST_ADD_HEALTH, function(_, player, key, hp)
	-- fiend heart (aehrt)
	if key == "IMMORAL_HEART" and mod.ACHIEVEMENT.IMMORAL_HEART:IsUnlocked(true)
	and not mod.ACHIEVEMENT.FIEND_HEART:IsUnlocked(true) and mod.GetImmoralHeartsNum(player) >= 12 then
		mod.ACHIEVEMENT.FIEND_HEART:Unlock()
	end

	-- fraudulent fungus
	if key == "ROTTEN_HEART" and not mod.ACHIEVEMENT.FRAUDULENT_FUNGUS:IsUnlocked(true)
	and player:GetRottenHearts() >= 3 and Isaac.GetPersistentGameData():Unlocked(Achievement.ROTTEN_HEARTS) then
		mod.ACHIEVEMENT.FRAUDULENT_FUNGUS:Unlock()
	end

	-- fistful of ash
	if key == "BROKEN_HEART" and not mod.ACHIEVEMENT.FISTFUL_OF_ASH:IsUnlocked(true) and player:GetBrokenHearts() >= 6 then
		mod.ACHIEVEMENT.FISTFUL_OF_ASH:Unlock()
	end
end)

-- purple putty
function mod:CheckPurplePuttyUnlock()
	if mod.ACHIEVEMENT.IMMORAL_HEART:IsUnlocked(true)
	and not mod.ACHIEVEMENT.PURPLE_PUTTY:IsUnlocked(true)
	and mod.savedata.immoralMinionKills >= 50 then
		mod.ACHIEVEMENT.PURPLE_PUTTY:Unlock()
	end
end

-- haunted penny, virtuous battery
function mod:CheckHauntedPennyVirtuousBatteryUnlocks(playerIdx)
	local player = PlayerManager.GetPlayers()[playerIdx+1]
	if not player then return end

	local numWisps = Isaac.CountEntities(player, 3, FamiliarVariant.WISP, -1)
	if not mod.ACHIEVEMENT.HAUNTED_PENNY:IsUnlocked(true) and numWisps >= 8 then
		mod.ACHIEVEMENT.HAUNTED_PENNY:Unlock()
	end
	if not mod.ACHIEVEMENT.VIRTUOUS_BATTERY:IsUnlocked(true) and numWisps >= 3 then
		local ptrhash = GetPtrHash(player)
		local subtypesUsed = {}
		local numSubtypesUsed = 0
		for _, wisp in ipairs(Isaac.FindByType(3, FamiliarVariant.WISP)) do
			if GetPtrHash(wisp:ToFamiliar().Player) == ptrhash then
				local subtype = wisp.SubType
				if subtype >= 65536 and subtype <= 65540 then
					subtype = CollectibleType.COLLECTIBLE_NOTCHED_AXE
				elseif subtype >= 65541 and subtype <= 65545 then
					subtype = CollectibleType.COLLECTIBLE_JAR_OF_FLIES
				elseif subtype >= 65546 and subtype <= 65549 then
					subtype = CollectibleType.COLLECTIBLE_FRIEND_BALL
				elseif subtype >= 65550 and subtype <= 65553 then
					subtype = CollectibleType.COLLECTIBLE_DELIRIOUS
				end

				if not subtypesUsed[subtype] then
					subtypesUsed[subtype] = true
					numSubtypesUsed = numSubtypesUsed + 1
					if numSubtypesUsed >= 3 then
						mod.ACHIEVEMENT.VIRTUOUS_BATTERY:Unlock()
						break
					end
				end
			end
		end
	end
	--[[if not mod.ACHIEVEMENT.RUNIC_CUBE:IsUnlocked(true) and numWisps >= 6 then
		mod.ACHIEVEMENT.RUNIC_CUBE:Unlock()
	end]]--
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, wisp)
	local player = wisp.Player
	if player then
		local pidx = player:GetPlayerIndex()
		if pidx >= 0 then
			mod:AddOneTimeCallback(ModCallbacks.MC_POST_UPDATE, function()
				mod:CheckHauntedPennyVirtuousBatteryUnlocks(pidx)
			end)
		end
	end
end, FamiliarVariant.WISP)

-- loadsamoney
function mod:CheckLoadsamoneyUnlock(player)
	if not mod.ACHIEVEMENT.LOADSAMONEY:IsUnlocked(true) and (player:GetNumCoins() + (mod.savedata.run.FractionalCoins or 0) / 10 + mod:GetPlatinumCreditData().Credit - (FiendFolio.savedata.run.dadsdebt or 0)) > 99 then
		mod.ACHIEVEMENT.LOADSAMONEY:Unlock()
	end
end

-- plague of decay (kill a rotten beggar)
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, entity)
	if game:GetRoom():GetFrameCount() > 0 and entity.Type == EntityType.ENTITY_SLOT and entity.Variant == 18 and entity.EntityCollisionClass == 4 then
		if not FiendFolio.ACHIEVEMENT.PLAGUE_OF_DECAY:IsUnlocked(true) then
			FiendFolio.ACHIEVEMENT.PLAGUE_OF_DECAY:Unlock()
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, id, rng, player, flags)
	-- Thirteen of Stars
	if mod.CanRunUnlockAchievements() and not FiendFolio.ACHIEVEMENT.THIRTEEN_OF_STARS:IsUnlocked(true) and id < 0 then
		local saveIndex = tostring(id)

		if not mod.savedata.tmtrainerIdsUsed[saveIndex] then -- TMTRAINER time baby
			mod.savedata.tmtrainerIdsUsed[saveIndex] = true

			if rng:RandomFloat() < 0.2 then
				FiendFolio.ACHIEVEMENT.THIRTEEN_OF_STARS:Unlock()
			end
		end
	end

	-- Ace of Wands / Old Testament
	if (not FiendFolio.ACHIEVEMENT.ACE_OF_WANDS:IsUnlocked(true) or not mod.ACHIEVEMENT.OLD_TESTAMENT:IsUnlocked(true))
	and ((flags & UseFlag.USE_OWNED > 0) or (flags & UseFlag.USE_VOID > 0)) then
		local saveData = mod.savedata.run

		saveData.uniqueActivesUsed = saveData.uniqueActivesUsed or {}
		local saveIndex = tostring(id)

		if not saveData.uniqueActivesUsed[saveIndex] then
			saveData.uniqueActivesUsed[saveIndex] = true
			saveData.numUniqueActivesUsed = (saveData.numUniqueActivesUsed or 0) + 1

			-- Ace of Wands
			if not mod.ACHIEVEMENT.ACE_OF_WANDS:IsUnlocked(true) then
				saveData.usedActiveItems = true
			end

			-- Old Testament
			if not mod.ACHIEVEMENT.OLD_TESTAMENT:IsUnlocked(true) and saveData.numUniqueActivesUsed >= 5 then
				mod.ACHIEVEMENT.OLD_TESTAMENT:Unlock()
			end
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, function(_, id, charge, firstTime, slot, vardata, player)
	local saveData = mod.savedata.run
	local config = Isaac.GetItemConfig():GetCollectible(id)

	-- Isaac.chr
	if not mod.ACHIEVEMENT.ISAAC_DOT_CHR:IsUnlocked(true) and id < 0 then
		saveData.glitchedItemsFound = saveData.glitchedItemsFound or {}
		local saveIndex = tostring(id)

		if not saveData.glitchedItemsFound[saveIndex] then
			saveData.glitchedItemsFound[saveIndex] = true
			saveData.numGlitchedItemsFound = (saveData.numGlitchedItemsFound or 0) + 1

			if saveData.numGlitchedItemsFound >= 5 then
				mod.ACHIEVEMENT.ISAAC_DOT_CHR:Unlock()
			end
		end
	end

	-- Creative A.I.
	if not mod.ACHIEVEMENT.CREATIVE_AI:IsUnlocked(true) and config.Type == ItemType.ITEM_ACTIVE and id ~= FiendFolio.ITEM.COLLECTIBLE.OLD_TESTAMENT then
		local sdata = mod:GetEntityData(player).ffsavedata

		if sdata and sdata.RunEffects and sdata.RunEffects.creativeAIItem then
			mod.ACHIEVEMENT.CREATIVE_AI:Unlock()
		end
	end

	-- Ace of Swords
	if not mod.ACHIEVEMENT.ACE_OF_SWORDS:IsUnlocked(true) and config.Type == ItemType.ITEM_FAMILIAR then
		saveData.collectedFamiliars = true
	end
end)

-- Ace of Swords (again)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_ADD_EFFECT, function(_, player, config, addCostume, count)
	if not mod.ACHIEVEMENT.ACE_OF_SWORDS:IsUnlocked(true) then
		local saveData = mod.savedata.run

		if config.Type == ItemType.ITEM_FAMILIAR then
			saveData.collectedFamiliars = true
		end
	end
end)

-- Ace of Pentacles / Neighbours from Hell
mod:AddPriorityCallback(ModCallbacks.MC_PRE_ADD_TRINKET, math.huge, function(_, player, id)
	if not mod.ACHIEVEMENT.ACE_OF_PENTACLES:IsUnlocked(true) or not mod.ACHIEVEMENT.NEIGHBOURS_FROM_HELL:IsUnlocked(true) then
		local saveData = mod.savedata.run

		saveData.trinketsFound = saveData.trinketsFound or {}
		local saveIndex = tostring(id % TrinketType.TRINKET_GOLDEN_FLAG)

		if not saveData.trinketsFound[saveIndex] then
			saveData.trinketsFound[saveIndex] = true
			saveData.numTrinketsFound = (saveData.numTrinketsFound or 0) + 1

			-- Ace of Pentacles
			if not mod.ACHIEVEMENT.ACE_OF_PENTACLES:IsUnlocked(true) and game:GetFrameCount() > 0 then
				saveData.collectedTrinkets = true
			end

			-- Neighbours from Hell
			if not mod.ACHIEVEMENT.NEIGHBOURS_FROM_HELL:IsUnlocked(true) and saveData.numTrinketsFound >= 5 then
				mod.ACHIEVEMENT.NEIGHBOURS_FROM_HELL:Unlock()
			end
		end
	end
end)

-- Bottle of Water / Ace of Cups
mod:AddCallback(ModCallbacks.MC_USE_PILL, function(_, pill, player, useflags)
	if mod.CanRunUnlockAchievements() and not (useflags & UseFlag.USE_NOHUD > 0)
	and (not (useflags & UseFlag.USE_NOANIM > 0) or (useflags & UseFlag.USE_MIMIC > 0)) then
		mod.savedata.pillsUsed = (mod.savedata.pillsUsed or 0) + 1
		mod.savedata.run.usedPills = true

		-- Bottle of Water
		if not mod.ACHIEVEMENT.BOTTLE_OF_WATER:IsUnlocked(true) and mod.savedata.pillsUsed >= 100 then
			mod.ACHIEVEMENT.BOTTLE_OF_WATER:Unlock()
		end
	end
end)

-- Ace Card unlocks
local aceCards = {
	ACE_OF_WANDS 	 = "usedActiveItems",
	ACE_OF_PENTACLES = "collectedTrinkets",
	ACE_OF_SWORDS 	 = "collectedFamiliars",
	ACE_OF_CUPS 	 = "usedPills",
}
mod:AddCallback(ModCallbacks.MC_POST_COMPLETION_EVENT, function(_, completionType)
	if completionType == CompletionType.LAMB then
		local saveData = mod.savedata.run

		for id, variable in pairs(aceCards) do
			if not mod.ACHIEVEMENT[id]:IsUnlocked(true) and not saveData[variable] then
				mod.ACHIEVEMENT[id]:Unlock()
			end
		end
	end
end)

local soulStonesList = {
	-- Vanilla
	[Card.CARD_SOUL_ISAAC] 		= true,
	[Card.CARD_SOUL_MAGDALENE]	= true,
	[Card.CARD_SOUL_CAIN]		= true,
	[Card.CARD_SOUL_JUDAS]		= true,
	[Card.CARD_SOUL_BLUEBABY]	= true,
	[Card.CARD_SOUL_EVE]		= true,
	[Card.CARD_SOUL_SAMSON]		= true,
	[Card.CARD_SOUL_AZAZEL]		= true,
	[Card.CARD_SOUL_LAZARUS]	= true,
	[Card.CARD_SOUL_EDEN]		= true,
	[Card.CARD_SOUL_LOST]		= true,
	[Card.CARD_SOUL_LILITH]		= true,
	[Card.CARD_SOUL_KEEPER]		= true,
	[Card.CARD_SOUL_APOLLYON]	= true,
	[Card.CARD_SOUL_FORGOTTEN]	= true,
	[Card.CARD_SOUL_BETHANY]	= true,
	[Card.CARD_SOUL_JACOB]		= true,

	-- FF
	[mod.ITEM.CARD.SOUL_OF_FIEND]		= true,
	[mod.ITEM.CARD.SOUL_OF_GOLEM]		= true,
	[mod.ITEM.CARD.SOUL_OF_CRAIG]		= true,
	[mod.ITEM.CARD.SOUL_OF_RANDOM]		= true,
}

-- immoral hearts, Glass Chest
local function GameHasFiend()
	for _, player in pairs(Isaac.FindByType(1)) do
		if player:ToPlayer():GetPlayerType() == mod.PLAYER.FIEND then
			return true
		end
	end

	return false
end

mod:AddPriorityCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, -1 * math.huge, function()
	local room = game:GetRoom()
	if room:GetType() == RoomType.ROOM_BOSS then
		if game:GetLevel():GetStage() ~= LevelStage.STAGE7 then
			local boss = room:GetBossID()
			if boss == 6 or boss == 89 then -- Mom / Maus Mom
				local hasFiend = PlayerManager.AnyoneIsPlayerType(mod.PLAYER.FIEND)
				local hasBiend = PlayerManager.AnyoneIsPlayerType(mod.PLAYER.BIEND)
				FiendFolio.savedata.beatMomAsFiend = FiendFolio.savedata.beatMomAsFiend or hasFiend or hasBiend

				local hasGolem = PlayerManager.AnyoneIsPlayerType(mod.PLAYER.GOLEM)
				local hasBolem = PlayerManager.AnyoneIsPlayerType(mod.PLAYER.BOLEM)
				FiendFolio.savedata.beatMomAsGolem = FiendFolio.savedata.beatMomAsGolem or hasGolem or hasBolem

				local hasFriend = PlayerManager.AnyoneIsPlayerType(mod.PLAYER.FRIEND)
				local hasBriend = PlayerManager.AnyoneIsPlayerType(mod.PLAYER.BRIEND)
				FiendFolio.savedata.beatMomAsFriend = FiendFolio.savedata.beatMomAsFriend or hasFriend or hasBriend

				local hasInaba = PlayerManager.AnyoneIsPlayerType(mod.PLAYER.INABA)
				local hasBinaba = PlayerManager.AnyoneIsPlayerType(mod.PLAYER.BINABA)
				FiendFolio.savedata.beatMomAsInaba = FiendFolio.savedata.beatMomAsInaba or hasInaba or hasBinaba

				if not mod.ACHIEVEMENT.TOY_CAMERA:IsUnlocked(true) and
				   FiendFolio.savedata.beatMomAsFiend and FiendFolio.savedata.beatMomAsGolem and
				   FiendFolio.savedata.beatMomAsFriend and FiendFolio.savedata.beatMomAsInaba
				then
					mod.ACHIEVEMENT.TOY_CAMERA:Unlock()
				end

				if not mod.ACHIEVEMENT.IMMORAL_HEART:IsUnlocked(true) and hasFiend then
					mod.ACHIEVEMENT.IMMORAL_HEART:Unlock()
				end

				if not mod.ACHIEVEMENT.PET_ROCK:IsUnlocked(true) and hasGolem then
					mod.ACHIEVEMENT.PET_ROCK:Unlock()
				end

				if not mod.ACHIEVEMENT.STRANGE_EYE:IsUnlocked(true) and hasFriend then
					mod.ACHIEVEMENT.STRANGE_EYE:Unlock()
				end
				
				if not mod.ACHIEVEMENT.ICE_IX:IsUnlocked(true) and hasInaba then
					mod.ACHIEVEMENT.ICE_IX:Unlock()
				end
			end
		end

		if not mod.ACHIEVEMENT.GLASS_CHEST:IsUnlocked(true) and room:IsMirrorWorld() then
			mod.ACHIEVEMENT.GLASS_CHEST:Unlock()
		end
	end
end)

-- flea of meltdown
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
	if npc.Variant == mod.FF.Meltdown2.Var and game:GetRoom():GetType() == RoomType.ROOM_BOSS and mod.CanRunUnlockAchievements() then
		mod.savedata.meltdownKills = mod.savedata.meltdownKills + 1
	end
end, mod.FF.Meltdown2.ID)

-- flea of deluge
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
	if npc.Variant == mod.FF.Deluge.Var and game:GetRoom():GetType() == RoomType.ROOM_BOSS and mod.CanRunUnlockAchievements() then
		mod.savedata.delugeKills = mod.savedata.delugeKills + 1
	end
end, mod.FF.Deluge.ID)

-- flea of pollution
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
	if npc.Variant == mod.FF.Pollution2.Var and game:GetRoom():GetType() == RoomType.ROOM_BOSS and mod.CanRunUnlockAchievements() then
		mod.savedata.pollutionKills = mod.savedata.pollutionKills + 1
	end
end, mod.FF.Pollution2.ID)

-- flea of propaganda
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
	if npc.Variant == mod.FF.Propaganda.Var and npc.SubType == 0 and game:GetRoom():GetType() == RoomType.ROOM_BOSS and mod.CanRunUnlockAchievements() then
		mod.savedata.propagandaKills = mod.savedata.propagandaKills + 1
	end
end, mod.FF.Propaganda.ID)

-- fleas / 7 seals 2
function mod:CheckFleasUnlock()
	if mod.savedata.meltdownKills >= 3 then
		if not mod.ACHIEVEMENT.FLEA_OF_MELTDOWN:IsUnlocked(true) then
			mod.ACHIEVEMENT.FLEA_OF_MELTDOWN:Unlock()
		end
	end

	if mod.savedata.delugeKills >= 3 then
		if not mod.ACHIEVEMENT.FLEA_OF_DELUGE:IsUnlocked(true) then
			mod.ACHIEVEMENT.FLEA_OF_DELUGE:Unlock()
		end
	end

	if mod.savedata.pollutionKills >= 3 then
		if not mod.ACHIEVEMENT.FLEA_OF_POLLUTION:IsUnlocked(true) then
			mod.ACHIEVEMENT.FLEA_OF_POLLUTION:Unlock()
		end
	end

	if mod.savedata.propagandaKills >= 3 then
		if not mod.ACHIEVEMENT.FLEA_OF_PROPAGANDA:IsUnlocked(true) then
			mod.ACHIEVEMENT.FLEA_OF_PROPAGANDA:Unlock()
		end
	end

	if mod.savedata.meltdownKills >= 1 and mod.savedata.delugeKills >= 1 and mod.savedata.pollutionKills >= 1 and mod.savedata.propagandaKills >= 1 then
		if not mod.ACHIEVEMENT.SEVEN_SEALS_2:IsUnlocked(true) then
			mod.ACHIEVEMENT.SEVEN_SEALS_2:Unlock()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.CheckFleasUnlock)
mod:AddPriorityCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, -1 * math.huge, mod.CheckFleasUnlock)

-- The Right Hand
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
	if npc.Variant == 1 and game:GetRoom():GetBossID() == 40 and not mod.ACHIEVEMENT.RIGHT_HAND:IsUnlocked(true) then
		local anyPlayerHasLeftHand
		mod.AnyPlayerDo(function(player)
			if player:HasTrinket(TrinketType.TRINKET_LEFT_HAND) or player:HasTrinket(mod.ITEM.ROCK.LEFT_FOSSIL) then
				anyPlayerHasLeftHand = true
			end
		end)

		if anyPlayerHasLeftHand then
			mod.ACHIEVEMENT.RIGHT_HAND:Unlock()
		end
	end
end, EntityType.ENTITY_ISAAC)

-- Morbid Heart (old)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
	if npc.Variant == mod.FF.MrDead.Var and game:GetRoom():GetType() == RoomType.ROOM_BOSS then
		--[[if not mod.ACHIEVEMENT.MORBID_HEART:IsUnlocked(true) then
			mod.ACHIEVEMENT.MORBID_HEART:Unlock()
		end]]--

		if game.Challenge == 0 and FiendFolio.ACHIEVEMENT.MORBID_HEART:IsUnlocked() then
			Isaac.Spawn(5, mod.PICKUP.VARIANT.MORBID_HEART, 0, npc.Position, RandomVector(), npc)
		end
	end
end, mod.FF.MrDead.ID)

-- Dad's Half
mod:AddCallback(ModCallbacks.MC_POST_COMPLETION_EVENT, function(_, completionType)
	if completionType == CompletionType.BEAST and FiendFolio.CanRunUnlockAchievements() and not FiendFolio.ACHIEVEMENT.DADS_HALF:IsUnlocked(true) then
		FiendFolio.ACHIEVEMENT.DADS_HALF:Unlock()
	end
end)

local testingForGiftUnlocks = false
mod:AddPriorityCallback(ModCallbacks.MC_PRE_USE_ITEM, math.huge, function()
	testingForGiftUnlocks = true
end, CollectibleType.COLLECTIBLE_MYSTERY_GIFT)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, item)
	if testingForGiftUnlocks then
		if item.SubType == CollectibleType.COLLECTIBLE_POOP then
			if not mod.ACHIEVEMENT.BIRTHDAY_GIFT:IsUnlocked(true) then
				mod.ACHIEVEMENT.BIRTHDAY_GIFT:Unlock()
			end
		elseif item.SubType == CollectibleType.COLLECTIBLE_LUMP_OF_COAL then
			if not mod.ACHIEVEMENT.GIFT_CARD:IsUnlocked(true) then
				mod.ACHIEVEMENT.GIFT_CARD:Unlock()
			end
		end
	end
end, PickupVariant.PICKUP_COLLECTIBLE)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function()
	testingForGiftUnlocks = false
	if mod.CanRunUnlockAchievements() then
		FiendFolio.savedata.mysteryGiftsUsed = (FiendFolio.savedata.mysteryGiftsUsed or 0) + 1
		if FiendFolio.savedata.mysteryGiftsUsed >= 5 and not FiendFolio.ACHIEVEMENT.GIFT_CARD:IsUnlocked(true) then
			FiendFolio.ACHIEVEMENT.GIFT_CARD:Unlock()
		end
		if FiendFolio.savedata.mysteryGiftsUsed >= 10 and not FiendFolio.ACHIEVEMENT.BIRTHDAY_GIFT:IsUnlocked(true) then
			FiendFolio.ACHIEVEMENT.BIRTHDAY_GIFT:Unlock()
		end
	end
end, CollectibleType.COLLECTIBLE_MYSTERY_GIFT)

local blacklistedFlags = UseFlag.USE_CARBATTERY | UseFlag.USE_VOID
local function addCorruptionCheckCallbacks()
	for id, _ in pairs(FiendFolio.ConsumableActiveItems) do
		mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, id, rng, player, useflags, slot, vardata)
			if slot >= 0 and useflags & blacklistedFlags == 0 and not FiendFolio.ACHIEVEMENT.CORRUPTION:IsUnlocked(true) then
				FiendFolio.ACHIEVEMENT.CORRUPTION:Unlock()
			end
		end, id)
	end
	mod:AddPriorityCallback(ModCallbacks.MC_PRE_USE_ITEM, math.huge, function(_, id, rng, player, useflags, slot, vardata)
		if slot >= 0 and useflags & blacklistedFlags == 0 and player:GetCard(0) == Card.CARD_QUESTIONMARK and not FiendFolio.ACHIEVEMENT.CORRUPTION:IsUnlocked(true) then
			FiendFolio.ACHIEVEMENT.CORRUPTION:Unlock()
		end
	end, CollectibleType.COLLECTIBLE_BLANK_CARD)
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_MODS_LOADED, CallbackPriority.LATE, function()
	addCorruptionCheckCallbacks()
end)
if ModReloadDetector.ModsLoaded then
	addCorruptionCheckCallbacks()
end

local checkingForDiceRoomEffects = nil
mod:AddCallback(ModCallbacks.MC_PRE_EFFECT_UPDATE, function(_, effect)
	checkingForDiceRoomEffects = effect.SubType
end, EffectVariant.DICE_FLOOR)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
	checkingForDiceRoomEffects = nil
end, EffectVariant.DICE_FLOOR)

function mod:CheckChatterboxUnlock()
	if not FiendFolio.ACHIEVEMENT.CHATTERBOX:IsUnlocked(true) then
		FiendFolio.ACHIEVEMENT.CHATTERBOX:Unlock()
	end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, id, rng, player, useflags, slot, vardata)
	if checkingForDiceRoomEffects == 0 then
		FiendFolio.savedata.usedDiceRoom1Pip = true
		mod:CheckChatterboxUnlock()
	elseif checkingForDiceRoomEffects == 5 then
		FiendFolio.savedata.usedDiceRoom6Pip = true
		mod:CheckChatterboxUnlock()
	end
end, CollectibleType.COLLECTIBLE_D4)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, id, rng, player, useflags, slot, vardata)
	if checkingForDiceRoomEffects == 1 then
		FiendFolio.savedata.usedDiceRoom2Pip = true
		mod:CheckChatterboxUnlock()
	elseif checkingForDiceRoomEffects == 2 then
		FiendFolio.savedata.usedDiceRoom3Pip = true
		mod:CheckChatterboxUnlock()
	elseif checkingForDiceRoomEffects == 5 then
		FiendFolio.savedata.usedDiceRoom6Pip = true
		mod:CheckChatterboxUnlock()
	end
end, CollectibleType.COLLECTIBLE_D20)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, id, rng, player, useflags, slot, vardata)
	if checkingForDiceRoomEffects == 3 then
		FiendFolio.savedata.usedDiceRoom4Pip = true
		mod:CheckChatterboxUnlock()
	elseif checkingForDiceRoomEffects == 5 then
		FiendFolio.savedata.usedDiceRoom6Pip = true
		mod:CheckChatterboxUnlock()
	end
end, CollectibleType.COLLECTIBLE_D6)
mod:AddCallback(ModCallbacks.MC_PRE_ROOM_EXIT, function(_, player, newLevel)
	if checkingForDiceRoomEffects == 4 then
		FiendFolio.savedata.usedDiceRoom5Pip = true
		mod:CheckChatterboxUnlock()
	end
end)

-- challenge unlocks!

function mod:CheckHandleWithCareDamage(entity, damage, flags, source, countdown)
	if mod.CanRunUnlockAchievements() and flags & DamageFlag.DAMAGE_FAKE == 0 then
		FiendFolio.savedata.timesPlayerTookDamage = (FiendFolio.savedata.timesPlayerTookDamage or 0) + 1
		mod:CheckHandleWithCareUnlock()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, mod.CheckHandleWithCareDamage, EntityType.ENTITY_PLAYER)

--[[function mod:CheckGauntletUnlock()
	if mod.CanRunUnlockAchievements() and not FiendFolio.ACHIEVEMENT.GAUNTLET:IsUnlocked(true) then
		for _, wasKilled in pairs(FiendFolio.savedata.killedBosses) do
			if not wasKilled then return end
		end
		FiendFolio.ACHIEVEMENT.GAUNTLET:Unlock()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.CheckGauntletUnlock)
mod:AddPriorityCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, -1 * math.huge, mod.CheckGauntletUnlock)]]--

local tryUnlockCarelessWhispers = false
local tryUnlockGriddleCorns = false
function mod:CheckBossesDead(boss)
	if not mod.CanRunUnlockAchievements() or game:GetRoom():GetType() ~= RoomType.ROOM_BOSS then return end

	local var = boss.Variant
	if var == FiendFolio.FF.Buck.Var and boss.SubType ~= 100 then
		FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
		FiendFolio.savedata.killedBosses["Buck"] = true
	elseif var == FiendFolio.FF.FoozTwinRed.Var or var == FiendFolio.FF.FoozTwinsBall.Var then
		local twins = Isaac.FindByType(FiendFolio.FF.FoozTwinRed.ID, FiendFolio.FF.FoozTwinRed.Var)
		local balls = Isaac.FindByType(FiendFolio.FF.FoozTwinsBall.ID, FiendFolio.FF.FoozTwinsBall.Var)
		local allSegmentsDead = true
		for _, twin in ipairs(twins) do
			if not (twin:IsDead() or twin:HasMortalDamage()) then
				allSegmentsDead = false
				break
			end
		end
		for _, ball in ipairs(balls) do
			if not (ball:IsDead() or ball:HasMortalDamage()) then
				allSegmentsDead = false
				break
			end
		end
		if allSegmentsDead then
			FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
			FiendFolio.savedata.killedBosses["FoozTwins"] = true
		end
	elseif var == FiendFolio.FF.Whispers.Var then
		FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
		FiendFolio.savedata.killedBosses["Whispers"] = true
		tryUnlockCarelessWhispers = true
	elseif var == FiendFolio.FF.GriddleHorn.Var then
		FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
		FiendFolio.savedata.killedBosses["GriddleHorn"] = true
		tryUnlockGriddleCorns = true
	elseif var == FiendFolio.FF.Buster.Var then
		FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
		FiendFolio.savedata.killedBosses["Buster"] = true
	elseif var == FiendFolio.FF.Meltdown2.Var then
		FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
		FiendFolio.savedata.killedBosses["Meltdown"] = true
	elseif var == FiendFolio.FF.Battie.Var then
		FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
		FiendFolio.savedata.killedBosses["Battie"] = true
	elseif var == FiendFolio.FF.Kingpin.Var then
		local kingpins = Isaac.FindByType(FiendFolio.FF.Kingpin.ID, FiendFolio.FF.Kingpin.Var)
		local allKingpinsDead = true
		for _, kingpin in ipairs(kingpins) do
			if not (kingpin:IsDead() or kingpin:HasMortalDamage()) then
				allKingpinsDead = false
				break
			end
		end
		if allKingpinsDead then
			FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
			FiendFolio.savedata.killedBosses["Kingpin"] = true
		end
	elseif var == FiendFolio.FF.Slinger.Var then
		FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
		FiendFolio.savedata.killedBosses["Slinger"] = true
	elseif var == FiendFolio.FF.Monsoon.Var then
		FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
		FiendFolio.savedata.killedBosses["Monsoon"] = true
	elseif var == FiendFolio.FF.Aquagob.Var then
		FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
		FiendFolio.savedata.killedBosses["Aquagob"] = true
	elseif var == FiendFolio.FF.Deluge.Var then
		FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
		FiendFolio.savedata.killedBosses["Deluge"] = true
	elseif var == FiendFolio.FF.OrgChaser.Var then
		FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
		FiendFolio.savedata.killedBosses["Organization"] = true
	elseif var == FiendFolio.FF.Gutso.Var then
		FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
		FiendFolio.savedata.killedBosses["Gutso"] = true
	elseif var == FiendFolio.FF.Luncheon.Var then
		FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
		FiendFolio.savedata.killedBosses["Luncheon"] = true
	elseif var == FiendFolio.FF.Pollution2.Var then
		FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
		FiendFolio.savedata.killedBosses["Pollution"] = true
	elseif var == FiendFolio.FF.Junkstrap.Var then
		FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
		FiendFolio.savedata.killedBosses["Junkstrap"] = true
	elseif var == FiendFolio.FF.Basco.Var then
		FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
		FiendFolio.savedata.killedBosses["Basco"] = true
	elseif var == FiendFolio.FF.Peeping2.Var then
		FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
		FiendFolio.savedata.killedBosses["Peeping"] = true
	elseif var == FiendFolio.FF.CacophobiaVenus.Var then
		FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
		FiendFolio.savedata.killedBosses["Cacophobia"] = true
	elseif var == FiendFolio.FF.Propaganda.Var then
		FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
		FiendFolio.savedata.killedBosses["Propaganda"] = true
	elseif var == FiendFolio.FF.Ghostbuster.Var then
		FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
		FiendFolio.savedata.killedBosses["Ghostbuster"] = true
	elseif var == FiendFolio.FF.Cacamancer.Var then
		FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
		FiendFolio.savedata.killedBosses["Cacamancer"] = true
	elseif var == FiendFolio.FF.Amon.Var then
		FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
		FiendFolio.savedata.killedBosses["HighAmon"] = true
	elseif var == FiendFolio.FF.Dusk.Var then
		FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
		FiendFolio.savedata.killedBosses["Dusk"] = true
	elseif var == FiendFolio.FF.WarpZone.Var then
		FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
		FiendFolio.savedata.killedBosses["WarpZone"] = true
	elseif var == FiendFolio.FF.Madomme.Var then
		FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
		FiendFolio.savedata.killedBosses["Madomme"] = true
	elseif var == FiendFolio.FF.Idolator.Var then
		local idolators = Isaac.FindByType(FiendFolio.FF.Idolator.ID, FiendFolio.FF.Idolator.Var)
		local allIdolatorsDead = true
		for _, idolator in ipairs(idolators) do
			if not idolator:IsDead() then
				allIdolatorsDead = false
				break
			end
		end
		if allIdolatorsDead then
			FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
			FiendFolio.savedata.killedBosses["Idolator"] = true
		end
	elseif var == FiendFolio.FF.MrDead.Var then
		FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
		FiendFolio.savedata.killedBosses["MrDead"] = true
	elseif var == FiendFolio.FF.BabyBubbles.Var then
		FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
		FiendFolio.savedata.killedBosses["BabyBubbles"] = true
	elseif var == FiendFolio.FF.Mo.Var then
		FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
		FiendFolio.savedata.killedBosses["Mo"] = true
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.CheckBossesDead, mod.FFID.Boss)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, function(_, boss)
	if not mod.CanRunUnlockAchievements() or game:GetRoom():GetType() ~= RoomType.ROOM_BOSS then return end
	if boss.Variant == FiendFolio.FF.Honeydrop.Var then
		FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
		FiendFolio.savedata.killedBosses["Honeydrop"] = true
	end
end, FiendFolio.FF.Honeydrop.ID)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, function(_, boss)
	if not mod.CanRunUnlockAchievements() or game:GetRoom():GetType() ~= RoomType.ROOM_MINIBOSS then return end
	if boss.Variant == FiendFolio.FF.Gravedigger.Var then
		FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
		FiendFolio.savedata.killedBosses["Gravedigger"] = true
	end
end, FiendFolio.FF.Gravedigger.ID)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, -1 * math.huge, function()
	if tryUnlockGriddleCorns and not FiendFolio.ACHIEVEMENT.GRIDDLE_CORNS:IsUnlocked(true) then
		FiendFolio.ACHIEVEMENT.GRIDDLE_CORNS:Unlock()
	end
	tryUnlockGriddleCorns = false
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	tryUnlockGriddleCorns = false
end)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, -1 * math.huge, function()
	if tryUnlockCarelessWhispers and not FiendFolio.ACHIEVEMENT.CARELESS_WHISPERS:IsUnlocked(true) then
		FiendFolio.ACHIEVEMENT.CARELESS_WHISPERS:Unlock()
	end
	tryUnlockCarelessWhispers = false
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	tryUnlockCarelessWhispers = false
end)

function mod:CheckDevilsHarvestUnlock()
	if not FiendFolio.ACHIEVEMENT.DEVILS_HARVEST_CHALLENGE:IsUnlocked(true) and
	   FiendFolio.ACHIEVEMENT.FIEND:IsUnlocked(true) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.WOMB)
	then
		FiendFolio.ACHIEVEMENT.DEVILS_HARVEST_CHALLENGE:Unlock()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.CheckDevilsHarvestUnlock)
mod:AddCallback(FiendFolio.CALLBACK.POST_ACHIEVEMENT_UNLOCK, mod.CheckDevilsHarvestUnlock, FiendFolio.ACHIEVEMENT.FIEND.ID)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckDevilsHarvestUnlock, Achievement.WOMB)

function mod:CheckNoOffenseUnlock(collectible, charge, firstTime)
	local isOffensive = firstTime and game:GetFrameCount() ~= 0 and Isaac.GetItemConfig():GetCollectible(collectible):HasTags(ItemConfig.TAG_OFFENSIVE)
	if isOffensive then
		FiendFolio.savedata.run.offensiveItems = (FiendFolio.savedata.run.offensiveItems or 0) + 1
	end
	if FiendFolio.savedata and FiendFolio.savedata.run and (FiendFolio.savedata.run.offensiveItems or 0) >= 6 and not FiendFolio.ACHIEVEMENT.NO_OFFENSE:IsUnlocked(true) then
		FiendFolio.ACHIEVEMENT.NO_OFFENSE:Unlock()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.CheckNoOffenseUnlock)

function mod:CheckHandleWithCareUnlock()
	if not FiendFolio.ACHIEVEMENT.HANDLE_WITH_CARE:IsUnlocked(true) and
	   (FiendFolio.ACHIEVEMENT.HEART_OF_CHINA:IsUnlocked(true) or
	    ((FiendFolio.savedata and FiendFolio.savedata.timesPlayerTookDamage) or 0) >= 100)
	then
		FiendFolio.ACHIEVEMENT.HANDLE_WITH_CARE:Unlock()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.CheckHandleWithCareUnlock)
mod:AddCallback(FiendFolio.CALLBACK.POST_ACHIEVEMENT_UNLOCK, mod.CheckHandleWithCareUnlock, FiendFolio.ACHIEVEMENT.HEART_OF_CHINA.ID)

function mod:CheckDadsHomeUnlock(collectible)
	if mod.DadItemsTruth[collectible] and not FiendFolio.ACHIEVEMENT.DADS_HOME:IsUnlocked(true) then
		FiendFolio.ACHIEVEMENT.DADS_HOME:Unlock()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.CheckDadsHomeUnlock)

function mod:CheckBlursedUnlock()
	if not FiendFolio.ACHIEVEMENT.BLURSED:IsUnlocked(true) and
	   FiendFolio.ACHIEVEMENT.BLACK_LANTERN:IsUnlocked(true)
	then
		FiendFolio.ACHIEVEMENT.BLURSED:Unlock()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.CheckBlursedUnlock)
mod:AddCallback(FiendFolio.CALLBACK.POST_ACHIEVEMENT_UNLOCK, mod.CheckBlursedUnlock, FiendFolio.ACHIEVEMENT.BLACK_LANTERN.ID)

function mod:CheckMrHandsUnlock()
	if not FiendFolio.ACHIEVEMENT.MR_HANDS:IsUnlocked(true) then
		FiendFolio.ACHIEVEMENT.MR_HANDS:Unlock()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.CheckMrHandsUnlock, FiendFolio.ITEM.COLLECTIBLE.GRABBER)

function mod:CheckFrogModeUnlock()
	if not FiendFolio.ACHIEVEMENT.FROG_MODE:IsUnlocked(true) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.FLOODED_CAVES)
	then
		FiendFolio.ACHIEVEMENT.FROG_MODE:Unlock()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.CheckFrogModeUnlock)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckFrogModeUnlock, Achievement.FLOODED_CAVES)

function mod:CheckPenIslandUnlock()
	if not FiendFolio.ACHIEVEMENT.PEN_ISLAND:IsUnlocked(true) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.PLANETARIUMS)
	then
		FiendFolio.ACHIEVEMENT.PEN_ISLAND:Unlock()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.CheckPenIslandUnlock)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckPenIslandUnlock, Achievement.PLANETARIUMS)

function mod:CheckRealJonUnlock()
	if not FiendFolio.ACHIEVEMENT.REAL_JON:IsUnlocked(true) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.NECROPOLIS) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.BONE_HEARTS)
	then
		FiendFolio.ACHIEVEMENT.REAL_JON:Unlock()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.CheckRealJonUnlock)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckRealJonUnlock, Achievement.NECROPOLIS)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckRealJonUnlock, Achievement.BONE_HEARTS)

local function checkBrickByBrickUnlockWrapper()
	mod:CheckBrickByBrickUnlock()
end

function mod:CheckBrickByBrickUnlock(_, noNote, force)
	if (not FiendFolio.ACHIEVEMENT.BRICK_BY_BRICK:IsUnlocked(true) or force) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.GOLDEN_TRINKET) and
	   FiendFolio.ACHIEVEMENT.GOLEM:IsUnlocked(true)
	then
		FiendFolio.ACHIEVEMENT.BRICK_BY_BRICK:Unlock(noNote, force)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, checkBrickByBrickUnlockWrapper)
mod:AddCallback(FiendFolio.CALLBACK.POST_ACHIEVEMENT_UNLOCK, mod.CheckBrickByBrickUnlock, FiendFolio.ACHIEVEMENT.GOLEM.ID)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, checkBrickByBrickUnlockWrapper, Achievement.GOLDEN_TRINKET)

local function checkTowerOffenseUnlockWrapper()
	mod:CheckTowerOffenseUnlock()
end

function mod:CheckTowerOffenseUnlock(_, noNote, force)
	if (not FiendFolio.ACHIEVEMENT.TOWER_OFFENSE:IsUnlocked(true) or force) and
	   FiendFolio.ACHIEVEMENT.GOLEM:IsUnlocked(true) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.BROWN_NUGGET)
	then
		FiendFolio.ACHIEVEMENT.TOWER_OFFENSE:Unlock(noNote, force)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, checkTowerOffenseUnlockWrapper)
mod:AddCallback(FiendFolio.CALLBACK.POST_ACHIEVEMENT_UNLOCK, mod.CheckTowerOffenseUnlock, FiendFolio.ACHIEVEMENT.GOLEM.ID)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, checkTowerOffenseUnlockWrapper, Achievement.BROWN_NUGGET)

local tryUnlockCraigsChallenge = false
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
	if npc.Variant == mod.FF.Craig.Var and mod.CanRunUnlockAchievements() then
		tryUnlockCraigsChallenge = true
	end
end, mod.FF.Craig.ID)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, -1 * math.huge, function()
	if tryUnlockCraigsChallenge and not FiendFolio.ACHIEVEMENT.CRAIGS_CHALLENGE:IsUnlocked(true) and Isaac.GetPersistentGameData():Unlocked(Achievement.SECRET_EXIT) then
		FiendFolio.ACHIEVEMENT.CRAIGS_CHALLENGE:Unlock()
	end
	tryUnlockCraigsChallenge = false
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	tryUnlockCraigsChallenge = false
end)

function mod:CheckAllowEnemyReplacementsUnlock()
	if not FiendFolio.ACHIEVEMENT.ALLOW_ENEMY_REPLACEMENTS:IsUnlocked(true) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.WOMB) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.CELLAR) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.CATACOMBS) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.NECROPOLIS) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.BURNING_BASEMENT) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.FLOODED_CAVES) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.DANK_DEPTHS) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.SCARRED_WOMB) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.POLAROID) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.NEGATIVE) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.BLUE_WOMB) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.THE_VOID) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.ALT_PATH) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.DROSS) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.ASHPIT) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.GEHENNA) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.ASCENT_DOOR) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.STEVEN) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.CHAD) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.GISH) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.TRIACHNID) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.SOMETHING_WICKED_PLUS) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.THE_GATE_IS_OPEN)
	then
		FiendFolio.ACHIEVEMENT.ALLOW_ENEMY_REPLACEMENTS:Unlock()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.CheckAllowEnemyReplacementsUnlock)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckAllowEnemyReplacementsUnlock, Achievement.WOMB)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckAllowEnemyReplacementsUnlock, Achievement.CELLAR)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckAllowEnemyReplacementsUnlock, Achievement.CATACOMBS)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckAllowEnemyReplacementsUnlock, Achievement.NECROPOLIS)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckAllowEnemyReplacementsUnlock, Achievement.BURNING_BASEMENT)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckAllowEnemyReplacementsUnlock, Achievement.FLOODED_CAVES)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckAllowEnemyReplacementsUnlock, Achievement.DANK_DEPTHS)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckAllowEnemyReplacementsUnlock, Achievement.SCARRED_WOMB)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckAllowEnemyReplacementsUnlock, Achievement.POLAROID)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckAllowEnemyReplacementsUnlock, Achievement.NEGATIVE)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckAllowEnemyReplacementsUnlock, Achievement.BLUE_WOMB)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckAllowEnemyReplacementsUnlock, Achievement.THE_VOID)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckAllowEnemyReplacementsUnlock, Achievement.ALT_PATH)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckAllowEnemyReplacementsUnlock, Achievement.DROSS)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckAllowEnemyReplacementsUnlock, Achievement.ASHPIT)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckAllowEnemyReplacementsUnlock, Achievement.GEHENNA)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckAllowEnemyReplacementsUnlock, Achievement.ASCENT_DOOR)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckAllowEnemyReplacementsUnlock, Achievement.STEVEN)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckAllowEnemyReplacementsUnlock, Achievement.CHAD)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckAllowEnemyReplacementsUnlock, Achievement.GISH)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckAllowEnemyReplacementsUnlock, Achievement.TRIACHNID)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckAllowEnemyReplacementsUnlock, Achievement.SOMETHING_WICKED_PLUS)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckAllowEnemyReplacementsUnlock, Achievement.THE_GATE_IS_OPEN)

function mod:CheckEmbryosAkimboUnlock()
	if not FiendFolio.ACHIEVEMENT.EMBRYOS_AKIMBO:IsUnlocked(true) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.LILITH) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.BIRTHRIGHT) and
	   FiendFolio.ACHIEVEMENT.LIL_FRIEND:IsUnlocked(true) and
	   FiendFolio.ACHIEVEMENT.HOW_TO_ROLL:IsUnlocked(true) and
	   FiendFolio.ACHIEVEMENT.CHERRY_BOMB:IsUnlocked(true)
	then
		FiendFolio.ACHIEVEMENT.EMBRYOS_AKIMBO:Unlock()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.CheckEmbryosAkimboUnlock)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckEmbryosAkimboUnlock, Achievement.LILITH)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckEmbryosAkimboUnlock, Achievement.BIRTHRIGHT)
mod:AddCallback(FiendFolio.CALLBACK.POST_ACHIEVEMENT_UNLOCK, mod.CheckEmbryosAkimboUnlock, FiendFolio.ACHIEVEMENT.LIL_FRIEND.ID)
mod:AddCallback(FiendFolio.CALLBACK.POST_ACHIEVEMENT_UNLOCK, mod.CheckEmbryosAkimboUnlock, FiendFolio.ACHIEVEMENT.HOW_TO_ROLL.ID)
mod:AddCallback(FiendFolio.CALLBACK.POST_ACHIEVEMENT_UNLOCK, mod.CheckEmbryosAkimboUnlock, FiendFolio.ACHIEVEMENT.CHERRY_BOMB.ID)

function mod:CheckMagnaFartaUnlock()
	if not FiendFolio.ACHIEVEMENT.MAGNA_FARTA:IsUnlocked(true) and
		Isaac.GetPersistentGameData():Unlocked(Achievement.TAINTED_BLUE_BABY) and
	  	FiendFolio.ACHIEVEMENT.RAINBOW_BEAN:IsUnlocked(true)
	then
		FiendFolio.ACHIEVEMENT.MAGNA_FARTA:Unlock()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.CheckMagnaFartaUnlock)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckMagnaFartaUnlock, Achievement.TAINTED_BLUE_BABY)
mod:AddCallback(FiendFolio.CALLBACK.POST_ACHIEVEMENT_UNLOCK, mod.CheckMagnaFartaUnlock, FiendFolio.ACHIEVEMENT.RAINBOW_BEAN.ID)

function mod:CheckIsaacRebuiltUnlock()
	if not FiendFolio.ACHIEVEMENT.ISAAC_REBUILT:IsUnlocked(true) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.TAINTED_MAGDALENE) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.BIRTHRIGHT)
	then
		FiendFolio.ACHIEVEMENT.ISAAC_REBUILT:Unlock()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.CheckIsaacRebuiltUnlock)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckIsaacRebuiltUnlock, Achievement.TAINTED_MAGDALENE)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckIsaacRebuiltUnlock, Achievement.BIRTHRIGHT)

function mod:CheckCursed2Unlock()
	if not FiendFolio.ACHIEVEMENT.BOSS_MAKES_A_DOLLAR:IsUnlocked(true) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.KEEPER) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.CURSED_PENNY) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.BLUE_MAP)
	then
		FiendFolio.ACHIEVEMENT.BOSS_MAKES_A_DOLLAR:Unlock()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.CheckCursed2Unlock)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckCursed2Unlock, Achievement.KEEPER)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckCursed2Unlock, Achievement.CURSED_PENNY)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckCursed2Unlock, Achievement.BLUE_MAP)

function mod:CheckBabySensoryUnlock()
	if not FiendFolio.ACHIEVEMENT.BABY_SENSORY:IsUnlocked(true) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.SCHOOLBAG) and
	   FiendFolio.ACHIEVEMENT.MODERN_HARBINGERS:IsUnlocked(true) and
	   FiendFolio.ACHIEVEMENT.GOLDEN_SLOT_MACHINE:IsUnlocked(true) and
	   FiendFolio.ACHIEVEMENT.EMPTY_GAZE:IsUnlocked(true) and
	   FiendFolio.ACHIEVEMENT.DAYDREAM:IsUnlocked(true) and
	   FiendFolio.ACHIEVEMENT.PET_ROCK:IsUnlocked(true) and
	   FiendFolio.ACHIEVEMENT.DUDS_FLOWER:IsUnlocked(true)
	then
		FiendFolio.ACHIEVEMENT.BABY_SENSORY:Unlock()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.CheckBabySensoryUnlock)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckBabySensoryUnlock, Achievement.SCHOOLBAG)
mod:AddCallback(FiendFolio.CALLBACK.POST_ACHIEVEMENT_UNLOCK, mod.CheckBabySensoryUnlock, FiendFolio.ACHIEVEMENT.MODERN_HARBINGERS.ID)
mod:AddCallback(FiendFolio.CALLBACK.POST_ACHIEVEMENT_UNLOCK, mod.CheckBabySensoryUnlock, FiendFolio.ACHIEVEMENT.GOLDEN_SLOT_MACHINE.ID)
mod:AddCallback(FiendFolio.CALLBACK.POST_ACHIEVEMENT_UNLOCK, mod.CheckBabySensoryUnlock, FiendFolio.ACHIEVEMENT.EMPTY_GAZE.ID)
mod:AddCallback(FiendFolio.CALLBACK.POST_ACHIEVEMENT_UNLOCK, mod.CheckBabySensoryUnlock, FiendFolio.ACHIEVEMENT.DAYDREAM.ID)
mod:AddCallback(FiendFolio.CALLBACK.POST_ACHIEVEMENT_UNLOCK, mod.CheckBabySensoryUnlock, FiendFolio.ACHIEVEMENT.PET_ROCK.ID)
mod:AddCallback(FiendFolio.CALLBACK.POST_ACHIEVEMENT_UNLOCK, mod.CheckBabySensoryUnlock, FiendFolio.ACHIEVEMENT.DUDS_FLOWER.ID)

local function checkGauntletUnlockWrapper()
	mod:CheckGauntletUnlock()
end

function mod:CheckGauntletUnlock(_, noNote, force)
	if (not FiendFolio.ACHIEVEMENT.GAUNTLET:IsUnlocked(true) or force) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.WOMB) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.CELLAR) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.CATACOMBS) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.NECROPOLIS) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.BURNING_BASEMENT) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.FLOODED_CAVES) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.DANK_DEPTHS) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.SCARRED_WOMB) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.POLAROID) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.NEGATIVE) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.BLUE_WOMB) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.THE_VOID) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.ALT_PATH) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.DROSS) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.ASHPIT) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.GEHENNA) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.ASCENT_DOOR) and
	   FiendFolio.ACHIEVEMENT.GOLEM:IsUnlocked(true)
	then
		FiendFolio.ACHIEVEMENT.GAUNTLET:Unlock(noNote, force)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, checkGauntletUnlockWrapper)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, checkGauntletUnlockWrapper, Achievement.WOMB)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, checkGauntletUnlockWrapper, Achievement.CELLAR)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, checkGauntletUnlockWrapper, Achievement.CATACOMBS)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, checkGauntletUnlockWrapper, Achievement.NECROPOLIS)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, checkGauntletUnlockWrapper, Achievement.BURNING_BASEMENT)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, checkGauntletUnlockWrapper, Achievement.FLOODED_CAVES)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, checkGauntletUnlockWrapper, Achievement.DANK_DEPTHS)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, checkGauntletUnlockWrapper, Achievement.SCARRED_WOMB)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, checkGauntletUnlockWrapper, Achievement.POLAROID)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, checkGauntletUnlockWrapper, Achievement.NEGATIVE)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, checkGauntletUnlockWrapper, Achievement.BLUE_WOMB)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, checkGauntletUnlockWrapper, Achievement.THE_VOID)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, checkGauntletUnlockWrapper, Achievement.ALT_PATH)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, checkGauntletUnlockWrapper, Achievement.DROSS)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, checkGauntletUnlockWrapper, Achievement.ASHPIT)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, checkGauntletUnlockWrapper, Achievement.GEHENNA)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, checkGauntletUnlockWrapper, Achievement.ASCENT_DOOR)
mod:AddCallback(FiendFolio.CALLBACK.POST_ACHIEVEMENT_UNLOCK, mod.CheckGauntletUnlock, FiendFolio.ACHIEVEMENT.GOLEM.ID)

function mod:CheckImperishableNightUnlock()
	if not FiendFolio.ACHIEVEMENT.IMPERISHABLE_NIGHT:IsUnlocked(true) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.ANGELS) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.SCARRED_WOMB) and
	   FiendFolio.ACHIEVEMENT.INABA:IsUnlocked(true) and
	   FiendFolio.ACHIEVEMENT.SERTRALINE:IsUnlocked(true)
	then
		FiendFolio.ACHIEVEMENT.IMPERISHABLE_NIGHT:Unlock()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.CheckImperishableNightUnlock)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckImperishableNightUnlock, Achievement.ANGELS)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckImperishableNightUnlock, Achievement.SCARRED_WOMB)
mod:AddCallback(FiendFolio.CALLBACK.POST_ACHIEVEMENT_UNLOCK, mod.CheckImperishableNightUnlock, FiendFolio.ACHIEVEMENT.INABA.ID)
mod:AddCallback(FiendFolio.CALLBACK.POST_ACHIEVEMENT_UNLOCK, mod.CheckImperishableNightUnlock, FiendFolio.ACHIEVEMENT.SERTRALINE.ID)

local diedInAllowEnemyReplacements = false
local diedInBabySensory = false
local diedInHandleWithCare = false
local diedInDadsHome = false
function mod:CheckGameEndUnlocks(isGameOver)
	if isGameOver then
		if game.Challenge == mod.challenges.allowEnemyReplacements then
			diedInAllowEnemyReplacements = true
		elseif game.Challenge == mod.challenges.babySensory then
			diedInBabySensory = true
		elseif game.Challenge == mod.challenges.chinaShop then
			diedInHandleWithCare = true
		elseif game.Challenge == mod.challenges.dadsHomePlus then
			diedInDadsHome = true
		end
	else
		if not FiendFolio.ACHIEVEMENT.BLASPHEMY:IsUnlocked(true) and PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_DAMOCLES_PASSIVE) then
			FiendFolio.ACHIEVEMENT.BLASPHEMY:Unlock()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_END, mod.CheckGameEndUnlocks)

function mod:CheckLoseChallengeActuallyUnlock()
	if diedInAllowEnemyReplacements then
		if not FiendFolio.ACHIEVEMENT.DUSTY_D10:IsUnlocked(true) then
			FiendFolio.ACHIEVEMENT.DUSTY_D10:Unlock()
		end
	end
	if diedInBabySensory then
		if not FiendFolio.ACHIEVEMENT.ADBLOCKER:IsUnlocked(true) then
			FiendFolio.ACHIEVEMENT.ADBLOCKER:Unlock()
		end
	end
	if diedInHandleWithCare then
		if not mod.ACHIEVEMENT.SHARD_OF_CHINA:IsUnlocked(true) then
			mod.ACHIEVEMENT.SHARD_OF_CHINA:Unlock()
		end
	end
	if diedInDadsHome then
		if not mod.ACHIEVEMENT.DADS_HOME_TRINKET:IsUnlocked(true) then
			mod.ACHIEVEMENT.DADS_HOME_TRINKET:Unlock()
		end
	end
	diedInAllowEnemyReplacements = false
	diedInBabySensory = false
	diedInHandleWithCare = false
	diedInDadsHome = false
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.CheckLoseChallengeActuallyUnlock)
mod:AddPriorityCallback(ModCallbacks.MC_PRE_GAME_EXIT, CallbackPriority.EARLY, mod.CheckLoseChallengeActuallyUnlock)

function mod:CheckGauntletBossClearUnlock()
	if game.Challenge == FiendFolio.challenges.theGauntlet and game:GetRoom():GetType() == RoomType.ROOM_BOSS and not FiendFolio.ACHIEVEMENT.LOST_ARTIFACT:IsUnlocked(true) then
		FiendFolio.ACHIEVEMENT.LOST_ARTIFACT:Unlock()
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, -1 * math.huge, mod.CheckGauntletBossClearUnlock)

-- challenge rewards (syncing with rgon)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, function()
	if mod.IgnoreRGONUnlock then return end
	FiendFolio.ACHIEVEMENT.GREEN_HOUSE:SetUnlocked(true)
end, Isaac.GetAchievementIdByName("FF_GREEN_HOUSE"))

mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, function()
	if mod.IgnoreRGONUnlock then return end
	FiendFolio.ACHIEVEMENT.SLIPPYS_ORGANS:SetUnlocked(true)
end, Isaac.GetAchievementIdByName("FF_SLIPPYS_ORGANS"))

mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, function()
	if mod.IgnoreRGONUnlock then return end
	FiendFolio.ACHIEVEMENT.SPARE_RIBS:SetUnlocked(true)
end, Isaac.GetAchievementIdByName("FF_SPARE_RIBS"))

mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, function()
	if mod.IgnoreRGONUnlock then return end
	FiendFolio.ACHIEVEMENT.PETRIFIED_GEL:SetUnlocked(true)
end, Isaac.GetAchievementIdByName("FF_PETRIFIED_GEL"))

mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, function()
	if mod.IgnoreRGONUnlock then return end
	FiendFolio.ACHIEVEMENT.RED_HAND:SetUnlocked(true)
end, Isaac.GetAchievementIdByName("FF_RED_HAND"))

mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, function()
	if mod.IgnoreRGONUnlock then return end
	FiendFolio.ACHIEVEMENT.DEIMOS:SetUnlocked(true)
end, Isaac.GetAchievementIdByName("FF_DEIMOS"))

mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, function()
	if mod.IgnoreRGONUnlock then return end
	FiendFolio.ACHIEVEMENT.BRICK_SEPARATOR:SetUnlocked(true)
end, Isaac.GetAchievementIdByName("FF_BRICK_SEPARATOR"))

mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, function()
	if mod.IgnoreRGONUnlock then return end
	FiendFolio.ACHIEVEMENT.LAWN_DARTS:SetUnlocked(true)
end, Isaac.GetAchievementIdByName("FF_LAWN_DARTS"))

mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, function()
	if mod.IgnoreRGONUnlock then return end
	FiendFolio.ACHIEVEMENT.CHINAS_BELONGINGS:SetUnlocked(true)
end, Isaac.GetAchievementIdByName("FF_CHINAS_BELONGINGS"))

mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, function()
	if mod.IgnoreRGONUnlock then return end
	FiendFolio.ACHIEVEMENT.GAUNTLET_BEATEN:SetUnlocked(true)
end, Isaac.GetAchievementIdByName("FF_GAUNTLET_BEATEN"))

mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, function()
	if mod.IgnoreRGONUnlock then return end
	FiendFolio.ACHIEVEMENT.CRAIGS_UNLOCKS:SetUnlocked(true)
end, Isaac.GetAchievementIdByName("FF_CRAIGS_UNLOCKS"))

mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, function()
	if mod.IgnoreRGONUnlock then return end
	FiendFolio.ACHIEVEMENT.DICHROMATIC_BUTTERFLY:SetUnlocked(true)
end, Isaac.GetAchievementIdByName("FF_DICHROMATIC_BUTTERFLY"))

mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, function()
	if mod.IgnoreRGONUnlock then return end
	FiendFolio.ACHIEVEMENT.GOOGLY_EYES:SetUnlocked(true)
end, Isaac.GetAchievementIdByName("FF_GOOGLY_EYES"))

mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, function()
	if mod.IgnoreRGONUnlock then return end
	FiendFolio.ACHIEVEMENT.APOTHEOSIS:SetUnlocked(true)
end, Isaac.GetAchievementIdByName("FF_APOTHEOSIS"))

mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, function()
	if mod.IgnoreRGONUnlock then return end
	FiendFolio.ACHIEVEMENT.ETERNAL_D10:SetUnlocked(true)
end, Isaac.GetAchievementIdByName("FF_ETERNAL_D10"))

mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, function()
	if mod.IgnoreRGONUnlock then return end
	FiendFolio.ACHIEVEMENT.DEVILS_UMBRELLA:SetUnlocked(true)
end, Isaac.GetAchievementIdByName("FF_DEVILS_UMBRELLA"))

mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, function()
	if mod.IgnoreRGONUnlock then return end
	FiendFolio.ACHIEVEMENT.BLACK_CANDELABRA:SetUnlocked(true)
end, Isaac.GetAchievementIdByName("FF_BLACK_CANDELABRA"))

mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, function()
	if mod.IgnoreRGONUnlock then return end
	FiendFolio.ACHIEVEMENT.TIME_IS_MONEY:SetUnlocked(true)
end, Isaac.GetAchievementIdByName("FF_TIME_IS_MONEY"))

mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, function()
	if mod.IgnoreRGONUnlock then return end
	FiendFolio.ACHIEVEMENT.IMAGES_UNLOCKS:SetUnlocked(true)
end, Isaac.GetAchievementIdByName("FF_IMAGES_UNLOCKS"))

mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, function()
	if mod.IgnoreRGONUnlock then return end
	FiendFolio.ACHIEVEMENT.DEVILS_HARVEST:SetUnlocked(true)
end, Isaac.GetAchievementIdByName("FF_DEVILS_HARVEST"))

mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, function()
	if mod.IgnoreRGONUnlock then return end
	FiendFolio.ACHIEVEMENT.CAN_OF_BEANS:SetUnlocked(true)
end, Isaac.GetAchievementIdByName("FF_CAN_OF_BEANS"))

-- Unlocks based on sets of unlocks
-- Soul of random, deluxe, kings of the minor arcana, flea circus
local soulOfRandomList = {
	Achievement.SOUL_OF_ISAAC,
	Achievement.SOUL_OF_MAGDALENE,
	Achievement.SOUL_OF_CAIN,
	Achievement.SOUL_OF_JUDAS,
	Achievement.SOUL_OF_BLUE_BABY,
	Achievement.SOUL_OF_EVE,
	Achievement.SOUL_OF_SAMSON,
	Achievement.SOUL_OF_AZAZEL,
	Achievement.SOUL_OF_LAZARUS,
	Achievement.SOUL_OF_EDEN,
	Achievement.SOUL_OF_THE_LOST,
	Achievement.SOUL_OF_LILITH,
	Achievement.SOUL_OF_THE_KEEPER,
	Achievement.SOUL_OF_APOLLYON,
	Achievement.SOUL_OF_THE_FORGOTTEN,
	Achievement.SOUL_OF_BETHANY,
	Achievement.SOUL_OF_JACOB,

	"SOUL_OF_FIEND",
	"SOUL_OF_GOLEM",
	"SOUL_OF_FRIEND",
	"SOUL_OF_INABA",
	"CRAIGS_UNLOCKS",
}

local minorArcanaKingsList = {
	Achievement.HORSE_PILLS,
	Achievement.GOLDEN_BATTERY,
	Achievement.GOLDEN_TRINKET,
}

local deluxeList = {
	Achievement.GOLDEN_HEARTS,
	Achievement.EVERYTHING_IS_TERRIBLE, 	-- Half soul hearts
	Achievement.SCARED_HEART,
	Achievement.BONE_HEARTS,
	Achievement.ROTTEN_HEARTS,
	Achievement.SOMETHING_FROM_THE_FUTURE,	-- Steven Hearts

	"IMMORAL_HEART",
	"MORBID_HEART",
	"FOOLS_GOLD_HEART",
}

local fleaCircusList = {
	"FLEA_OF_MELTDOWN",
	"FLEA_OF_DELUGE",
	"FLEA_OF_POLLUTION",
	"FLEA_OF_PROPAGANDA"
}

local goldenPopsicleList = {
	Achievement.GOLDEN_BOMBS,
	Achievement.GOLDEN_HEARTS, -- Half soul hearts
	Achievement.GOLDEN_PENNIES,
	Achievement.GOLDEN_PILLS,
	Achievement.GOLDEN_BATTERIES,
	Achievement.GOLDEN_TRINKETS,

	--"FOOLS_GOLD_HEART",
	"GOLDEN_CURSED_PENNY",
}

function mod:CheckSoulOfRandomUnlock()
	if not FiendFolio.ACHIEVEMENT.SOUL_OF_RANDOM:IsUnlocked(true) then
		local soulStonesCount = FiendFolio.GetAchievementSetUnlockCount(soulOfRandomList)
		if soulStonesCount >= #soulOfRandomList / 2 then
			FiendFolio.ACHIEVEMENT.SOUL_OF_RANDOM:Unlock(noNote)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.CheckSoulOfRandomUnlock)
for _, id in ipairs(soulOfRandomList) do
	if type(id) == "number" then
		mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckSoulOfRandomUnlock, id)
	else
		mod:AddCallback(FiendFolio.CALLBACK.POST_ACHIEVEMENT_UNLOCK, mod.CheckSoulOfRandomUnlock, FiendFolio.ACHIEVEMENT[id].ID)
	end
end

function mod:CheckMinorArcanaKingsUnlock()
	if not FiendFolio.ACHIEVEMENT.MINOR_ARCANA_KINGS:IsUnlocked(true) and FiendFolio.IsAchievementSetUnlocked(minorArcanaKingsList) then
		FiendFolio.ACHIEVEMENT.MINOR_ARCANA_KINGS:Unlock(noNote)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.CheckMinorArcanaKingsUnlock)
for _, id in ipairs(minorArcanaKingsList) do
	if type(id) == "number" then
		mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckMinorArcanaKingsUnlock, id)
	else
		mod:AddCallback(FiendFolio.CALLBACK.POST_ACHIEVEMENT_UNLOCK, mod.CheckMinorArcanaKingsUnlock, FiendFolio.ACHIEVEMENT[id].ID)
	end
end

function mod:CheckDeluxeUnlock()
	if not FiendFolio.ACHIEVEMENT.DELUXE:IsUnlocked(true) and FiendFolio.IsAchievementSetUnlocked(deluxeList) then
		FiendFolio.ACHIEVEMENT.DELUXE:Unlock(noNote)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.CheckDeluxeUnlock)
for _, id in ipairs(deluxeList) do
	if type(id) == "number" then
		mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckDeluxeUnlock, id)
	else
		mod:AddCallback(FiendFolio.CALLBACK.POST_ACHIEVEMENT_UNLOCK, mod.CheckDeluxeUnlock, FiendFolio.ACHIEVEMENT[id].ID)
	end
end

function mod:CheckGoldenPopsicleUnlock()
	if not FiendFolio.ACHIEVEMENT.GOLDEN_POPSICLE:IsUnlocked(true) and FiendFolio.IsAchievementSetUnlocked(goldenPopsicleList) then
		FiendFolio.ACHIEVEMENT.GOLDEN_POPSICLE:Unlock(noNote)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.CheckGoldenPopsicleUnlock)
for _, id in ipairs(goldenPopsicleList) do
	if type(id) == "number" then
		mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckGoldenPopsicleUnlock, id)
	else
		mod:AddCallback(FiendFolio.CALLBACK.POST_ACHIEVEMENT_UNLOCK, mod.CheckGoldenPopsicleUnlock, FiendFolio.ACHIEVEMENT[id].ID)
	end
end

function mod:checkPlayerFormUnlocks(collectible, charge, firstTime, slot, vardata, player)
	if not mod.ACHIEVEMENT.LARGE_DOSE:IsUnlocked(true) and player:HasPlayerForm(PlayerForm.PLAYERFORM_DRUGS) then
		mod.ACHIEVEMENT.LARGE_DOSE:Unlock()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.checkPlayerFormUnlocks)

-- Green Candle unlock
local gameStarted = false
function mod:CheckGreenCandleUnlock()
	if gameStarted and not FiendFolio.ACHIEVEMENT.GREEN_CANDLE:IsUnlocked(true) and
	   (Isaac.GetPersistentGameData():GetEventCounter(EventCounter.DONATION_MACHINE_COUNTER) >= 700 or
	    Isaac.GetPersistentGameData():Unlocked(Achievement.BLUE_CANDLE) or
	    Isaac.GetPersistentGameData():Unlocked(Achievement.STOP_WATCH))
	then
		FiendFolio.ACHIEVEMENT.GREEN_CANDLE:Unlock()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, mod.CheckGreenCandleUnlock, SlotVariant.DONATION_MACHINE)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.CheckGreenCandleUnlock)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
	gameStarted = true
	mod.CheckGreenCandleUnlock()
end)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function()
	gameStarted = false
end)

function mod:CheckWrongWarpUnlock()
	if not FiendFolio.ACHIEVEMENT.WRONG_WARP:IsUnlocked(true) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.WOMB) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.CELLAR) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.CATACOMBS) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.NECROPOLIS) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.BURNING_BASEMENT) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.FLOODED_CAVES) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.DANK_DEPTHS) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.SCARRED_WOMB) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.POLAROID) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.NEGATIVE) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.BLUE_WOMB) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.THE_VOID) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.ALT_PATH) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.DROSS) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.ASHPIT) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.GEHENNA) and
	   Isaac.GetPersistentGameData():Unlocked(Achievement.ASCENT_DOOR)
	then
		FiendFolio.ACHIEVEMENT.WRONG_WARP:Unlock()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.CheckWrongWarpUnlock)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckWrongWarpUnlock, Achievement.WOMB)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckWrongWarpUnlock, Achievement.CELLAR)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckWrongWarpUnlock, Achievement.CATACOMBS)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckWrongWarpUnlock, Achievement.NECROPOLIS)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckWrongWarpUnlock, Achievement.BURNING_BASEMENT)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckWrongWarpUnlock, Achievement.FLOODED_CAVES)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckWrongWarpUnlock, Achievement.DANK_DEPTHS)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckWrongWarpUnlock, Achievement.SCARRED_WOMB)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckWrongWarpUnlock, Achievement.POLAROID)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckWrongWarpUnlock, Achievement.NEGATIVE)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckWrongWarpUnlock, Achievement.BLUE_WOMB)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckWrongWarpUnlock, Achievement.THE_VOID)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckWrongWarpUnlock, Achievement.ALT_PATH)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckWrongWarpUnlock, Achievement.DROSS)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckWrongWarpUnlock, Achievement.ASHPIT)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckWrongWarpUnlock, Achievement.GEHENNA)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckWrongWarpUnlock, Achievement.ASCENT_DOOR)

-- Modern Horsemen unlock
function mod:CheckModernHorsemenUnlock()
	if not FiendFolio.ACHIEVEMENT.MODERN_HARBINGERS:IsUnlocked(true) and Isaac.GetPersistentGameData():Unlocked(Achievement.SCARRED_WOMB) then
		FiendFolio.ACHIEVEMENT.MODERN_HARBINGERS:Unlock()
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_GAME_STARTED, -1 * math.huge, mod.CheckModernHorsemenUnlock)
mod:AddPriorityCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, -1 * math.huge, mod.CheckModernHorsemenUnlock, Achievement.SCARRED_WOMB)

function mod:CheckFleaCircusUnlock()
	if not FiendFolio.ACHIEVEMENT.FLEA_CIRCUS:IsUnlocked(true) and FiendFolio.IsAchievementSetUnlocked(fleaCircusList) then
		FiendFolio.ACHIEVEMENT.FLEA_CIRCUS:Unlock(noNote)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.CheckFleaCircusUnlock)
for _, id in ipairs(fleaCircusList) do
	if type(id) == "number" then
		mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, mod.CheckFleaCircusUnlock, id)
	else
		mod:AddCallback(FiendFolio.CALLBACK.POST_ACHIEVEMENT_UNLOCK, mod.CheckFleaCircusUnlock, FiendFolio.ACHIEVEMENT[id].ID)
	end
end

function mod:CheckProGodUnlock()
	if not FiendFolio.ACHIEVEMENT.PRO_GOD:IsUnlocked(true) and
	   FiendFolio.GetNumCompletedAchievements() >= FiendFolio.TOTAL_COMPLETION_ACHIEVEMENTS
	then
		FiendFolio.ACHIEVEMENT.PRO_GOD:Unlock()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.CheckProGodUnlock)
mod:AddCallback(FiendFolio.CALLBACK.POST_ACHIEVEMENT_UNLOCK, mod.CheckProGodUnlock)

-- Fiend unlock (beat any FF boss)
mod:AddPriorityCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, -1 * math.huge, function()
	local currentRoom = StageAPI.GetCurrentRoom()
	if not FiendFolio.ACHIEVEMENT.FIEND:IsUnlocked(true) and currentRoom and currentRoom.PersistentData.BossID then
		local boss = StageAPI.GetBossData(currentRoom.PersistentData.BossID)
		if boss and boss.IsFFBoss then
			FiendFolio.ACHIEVEMENT.FIEND:Unlock()
		end
	end
end)

-- Golem unlock
local GOLEM_UNLOCK_ROOM_NAME = "Golem Unlock"

function mod:IsGolemUnlockRoom(roomData)
	roomData = roomData or game:GetLevel():GetCurrentRoomDesc().Data
	return roomData ~= nil and roomData.Name == GOLEM_UNLOCK_ROOM_NAME
end

function mod:TriggerGolemUnlockEvent(pos)
	SFXManager():Play(SoundEffect.SOUND_ROCK_CRUMBLE)
	game:SpawnParticles(pos, EffectVariant.ROCK_PARTICLE, 7, 5)
	Isaac.Spawn(EntityType.ENTITY_SLOT, SlotVariant.HOME_CLOSET_PLAYER, 0, pos, Vector.Zero, nil)
	-- Unlock Golem immediately JUST IN CASE, but don't trigger the paper yet.
	if not FiendFolio.ACHIEVEMENT.GOLEM:IsUnlocked(true) then
		FiendFolio.PendingGolemUnlockPaper = true
		FiendFolio.ACHIEVEMENT.GOLEM:Unlock(true)
		local func = function()
			if FiendFolio.PendingGolemUnlockPaper then
				FiendFolio.PendingGolemUnlockPaper = nil
				FiendFolio.ACHIEVEMENT.GOLEM:Unlock(false, true)
			end
		end
		mod:AddOneTimeCallback(ModCallbacks.MC_PRE_GAME_EXIT, func)
		mod:AddOneTimeCallback(ModCallbacks.MC_PRE_ROOM_EXIT, func)
	end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
	local level = game:GetLevel()
	local inMines = (level:GetStage() == LevelStage.STAGE2_1 or level:GetStage() == LevelStage.STAGE2_2)
			and (level:GetStageType() == StageType.STAGETYPE_REPENTANCE or level:GetStageType() == StageType.STAGETYPE_REPENTANCE_B)
	local canLock, canUnlockAchievements = FiendFolio.AreAchievementsEnabled()
	if inMines and canLock and canUnlockAchievements and not FiendFolio.ACHIEVEMENT.GOLEM:IsUnlocked(true) then
		local roomid = 17000
		local golemUnlockRoom = nil
		while not golemUnlockRoom do
			golemUnlockRoom = RoomConfigHolder.GetRoomByStageTypeAndVariant(StbType.MINES, RoomType.ROOM_SECRET, roomid)
			if not golemUnlockRoom or golemUnlockRoom.Name == GOLEM_UNLOCK_ROOM_NAME then
				break
			end
			golemUnlockRoom = nil
			roomid = roomid + 1
		end
		if golemUnlockRoom then
			local rooms = level:GetRooms()
			for i = 0, level:GetRoomCount() - 1 do
				local roomDesc = rooms:Get(i)
				if roomDesc.Data and roomDesc.Data.Type == RoomType.ROOM_SECRET then
					roomDesc.Data = golemUnlockRoom
					roomDesc.SurpriseMiniboss = false
					break
				end
			end
		else
			Console.PrintError("[FF] Failed to find Golem Unlock room, ended at " .. roomid)
		end
	end
end)

-- Friend unlock
local FRIEND_UNLOCK_ROOM_NAME = "Friend Unlock"

function mod:IsFriendUnlockRoom(roomData)
	local roomData = roomData or game:GetLevel():GetCurrentRoomDesc().Data
	return roomData ~= nil and roomData.Name == FRIEND_UNLOCK_ROOM_NAME
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
	local level = game:GetLevel()
	local canLock, canUnlockAchievements = FiendFolio.AreAchievementsEnabled()
	if PlayerManager.AnyoneHasTrinket(mod.ITEM.TRINKET.WANTED_POSTER)
	and canLock
	and canUnlockAchievements
	and not FiendFolio.ACHIEVEMENT.FRIEND:IsUnlocked(true)
	and PlayerManager.AnyoneIsPlayerType(mod.PLAYER.FIEND) then
		local roomid = 17000
		local friendUnlockRoom = nil
		while not friendUnlockRoom do
			friendUnlockRoom = RoomConfigHolder.GetRoomByStageTypeAndVariant(StbType.SPECIAL_ROOMS, RoomType.ROOM_SECRET, roomid)
			if not friendUnlockRoom or friendUnlockRoom.Name == FRIEND_UNLOCK_ROOM_NAME then
				break
			end
			friendUnlockRoom = nil
			roomid = roomid + 1
		end
		if friendUnlockRoom then
			local rooms = level:GetRooms()
			for i = 0, level:GetRoomCount() - 1 do
				local roomDesc = rooms:Get(i)
				if roomDesc.Data and roomDesc.Data.Type == RoomType.ROOM_SECRET then
					roomDesc.Data = friendUnlockRoom
					roomDesc.SurpriseMiniboss = false
					break
				end
			end
		else
			Console.PrintError("[FF] Failed to find Friend Unlock room, ended at " .. roomid)
		end
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, CallbackPriority.EARLY, function()
	local room = game:GetRoom()
    local save = mod.getFieldInit(FiendFolio.savedata, 'run', {})
	local canLock, canUnlockAchievements = FiendFolio.AreAchievementsEnabled()

	-- Golem unlock
	if mod:IsGolemUnlockRoom() then
		if not canLock or not canUnlockAchievements or FiendFolio.ACHIEVEMENT.GOLEM:IsUnlocked(true) then
			for _, slot in ipairs(Isaac.FindByType(EntityType.ENTITY_SLOT, 1023)) do
				Isaac.Spawn(EntityType.ENTITY_SHOPKEEPER, 0, 0, slot.Position, mod.nilvector, nil)
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, slot.Position + Vector(0, 40), mod.nilvector, nil)
				slot:Remove()
			end
			for _, slot in ipairs(Isaac.FindByType(EntityType.ENTITY_SLOT, SlotVariant.HOME_CLOSET_PLAYER)) do
				slot:Remove()
			end
		end
	end

	-- Friend wanted poster
	if room:GetType() == RoomType.ROOM_ARCADE
	and not FiendFolio.ACHIEVEMENT.FRIEND:IsUnlocked(true)
	and canUnlockAchievements
	and not PlayerManager.AnyoneHasTrinket(mod.ITEM.TRINKET.WANTED_POSTER)
	and not save.SpecialWantedPosterSpawned
	and PlayerManager.AnyoneIsPlayerType(mod.PLAYER.FIEND) then
		mod:SpawnFriendWantedPoster()
	end

	-- Friend cutscene
	if mod:IsFriendUnlockRoom() and not FiendFolio.ACHIEVEMENT.FRIEND:IsUnlocked(true) then
		local friend = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.FF.FriendUnlock.Var, mod.FF.FriendUnlock.Sub, room:GetCenterPos(), Vector.Zero, nil)
		friend:AddEntityFlags(EntityFlag.FLAG_DONT_OVERWRITE)
	end
end)

local function InitGolemUnlockSlot(slot)
	local sprite = slot:GetSprite()
	sprite:Load("gfx/001.000_player.anm2", true)
	sprite:ReplaceSpritesheet(12, EntityConfig.GetPlayer(mod.PLAYER.GOLEM):GetSkinPath(), true)
	sprite:Play("Appear", true)
end

-- Golem's little unlock animation
local function UpdateGolemUnlockSlot(slot)
	local sprite = slot:GetSprite()

	if slot.FrameCount < 20 then
		sprite:SetFrame(0)
	end

	if slot:GetState() == SlotState.REWARD or slot:GetState() == SlotState.DESTROYED or slot:IsDead() then
		-- How could you
		game:SpawnParticles(slot.Position, EffectVariant.ROCK_PARTICLE, 10, 10)
		game:SpawnParticles(slot.Position, EffectVariant.BLOOD_PARTICLE, 10, 10)
		sfx:Play(mod.Sounds.GolemDeath, 0.8, 0, false, 1)
		sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 1, 0, false, 1)
		sfx:Play(SoundEffect.SOUND_POT_BREAK, 1, 0, false, 0.6)
		sfx:Play(SoundEffect.SOUND_MUSHROOM_POOF, 1, 0, false, 1)
		
		local bloodSplat = Isaac.Spawn(1000, 2, 0, slot.Position, Vector.Zero, slot)
		bloodSplat:Update()
		local bloodCloud = Isaac.Spawn(1000, 16, 3, slot.Position, Vector.Zero, slot)
		bloodCloud:Update()
		
		game:ShakeScreen(20)
		
		if slot.Child then
			slot.Child:Remove()
		end
		
		slot:Remove()
		return
	end

	--[[if sprite:IsPlaying("Appear") and sprite:GetFrame() == 30 then
		mod.shampooBottleIdleCommentPerRoom = nil
		mod.shampooDialogue = {}
		mod.shampooRobobabyTalking = true
		mod.shampooDialogue.Dialogue = {"thank you fiend or awakening me once more"}
	else]]
	if sprite:IsFinished("Appear") --[[and not mod.shampooDialogue.Dialogue]] then
		sprite:Play("Happy", true)
		SFXManager():Play(SoundEffect.SOUND_THUMBSUP)
		local trapdoor = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 0, slot.Position, Vector.Zero, nil)
		mod:GetEntityData(trapdoor).GolemUnlockTrapdoor = true
		trapdoor:GetSprite():Load("gfx/grid/golem_trapdoor.anm2", true)
		trapdoor:GetSprite():Play("Push", true)
		trapdoor.SortingLayer = SortingLayer.SORTING_BACKGROUND
		slot.Child = trapdoor
		trapdoor.Parent = slot
		SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS, 1, 0, false, 1)
	elseif sprite:IsFinished("Happy") then
		sprite:Play("Trapdoor", true)
		SFXManager():Play(mod.Sounds.GolemDoorOpen, 1, 0, false, 1)
	elseif sprite:IsFinished("Trapdoor") then
		slot:Remove()
		if FiendFolio.PendingGolemUnlockPaper then
			FiendFolio.PendingGolemUnlockPaper = nil
			FiendFolio.ACHIEVEMENT.GOLEM:Unlock(false, true)
		end
		mod.scheduleForUpdate(function()
			SFXManager():Play(mod.Sounds.GolemDoorClose, 1, 0, false, 1)
		end, 5)
	end
end

---@param effect EntityEffect
function mod:UpdateFriendUnlock(effect)
	local sprite = effect:GetSprite()
	local data = mod:GetEntityData(effect)

	-- Appear state - Idle on the ground until the player draws near
	if effect.State == 0 then
		local closest = game:GetNearestPlayer(effect.Position)
		if closest.Position:Distance(effect.Position) < 100 and game:GetRoom():GetFrameCount() > 5 then
			effect.State = 1
			sprite:Play("Appear")

			for _, player in ipairs(PlayerManager.GetPlayers()) do
				local pData = mod:GetEntityData(player)
				pData.CouldMoveBeforeUnlock = player.ControlsEnabled
				player.ControlsEnabled = false
			end
		end

	-- Stand state - Stand up and ready the gun
	elseif effect.State == 1 then
		if sprite:IsEventTriggered("GunAppear") then
			local gun = Isaac.Spawn(mod.FF.FriendUnlockGun.ID, mod.FF.FriendUnlockGun.Var, mod.FF.FriendUnlockGun.Sub, effect.Position, Vector.Zero, effect):ToEffect()
			gun.DepthOffset = 5
			gun.SpriteOffset = Vector(0,-8)

			local gd = mod:GetEntityData(gun)
			gd.state = "Init"
			gd.StateFrame = 0
			gd.AngleOffset = 0
			gd.CurrentAngle = (game:GetNearestPlayer(effect.Position).Position - effect.Position):GetAngleDegrees()

			data.PlayerToShootFirst = game:GetNearestPlayer(effect.Position):GetPlayerIndex()
			data.ShotPlayerIndexes = {}
			data.FriendUnlockGun = EntityPtr(gun)
		end

		if sprite:IsFinished() then
			effect.State = 2
			data.StartedShootingFrame = effect.FrameCount
		end

	-- Shoot state - Gun everyone down
	elseif effect.State == 2 then
		local gun = data.FriendUnlockGun and data.FriendUnlockGun.Ref
		if not gun then
			effect.State = 3
			return
		end

		local gd = mod:GetEntityData(gun)
		local frameOffset = effect.FrameCount - data.StartedShootingFrame
		local playerToShoot

		if not data.ShotPlayerIndexes[data.PlayerToShootFirst] then
			playerToShoot = Isaac.GetPlayer(data.PlayerToShootFirst)
		else
			for _, player in ipairs(PlayerManager.GetPlayers()) do
				if not data.ShotPlayerIndexes[player:GetPlayerIndex()] and mod:IsRealAlivePlayer(player) then
					playerToShoot = player
				end
			end
		end

		if frameOffset == 1 or frameOffset % 15 == 0 then
			if not playerToShoot then
				effect.State = 3
				sprite:Play("Happy")
				sfx:Play(SoundEffect.SOUND_THUMBSUP)
			else
				local direction = Vector.FromAngle(gd.CurrentAngle)
				local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, mod.TEAR.M90_BULLET, 0, gun.Position + direction * 10, direction * 16, nil):ToTear()
				tear:ChangeVariant(mod.TEAR.M90_BULLET)
				tear.CollisionDamage = 0
				mod:GetEntityData(tear).FriendUnlockBullet = true
				sfx:Stop(SoundEffect.SOUND_TEARS_FIRE)
				sfx:Play(SoundEffect.SOUND_GFUEL_GUNSHOT, 1, 0, false, math.random(90, 100)/100)
				gd.JustShot = true

				data.ShotPlayerIndexes[playerToShoot:GetPlayerIndex()] = true
			end
		elseif playerToShoot then
			gd.CurrentAngle = (playerToShoot.Position - effect.Position):GetAngleDegrees()
		end

	-- Taunt state - Do the "happy" animation
	elseif effect.State == 3 then
		local gun = data.FriendUnlockGun and data.FriendUnlockGun.Ref
		if gun then
			mod:GetEntityData(gun).State = "Disappear"
			data.FriendUnlockGun = nil
		end

		if sprite:IsFinished() then
			effect.State = 4
		end

	-- Flee state - Leave the scene of the crime
	elseif effect.State == 4 then
		local room = game:GetRoom()
		local targetDoor = room:GetDoor(game:GetLevel().EnterDoor)

		effect.Velocity = mod:Lerp(effect.Velocity, (targetDoor.Position - effect.Position):Resized(9), 0.8)

		local direction = FiendFolio.GetCardinal(effect.Velocity:Normalized())
		if direction.X < 0 then
			mod:spritePlay(sprite, "WalkLeft")
			sprite:SetOverlayFrame("HeadLeft", 0)
		elseif direction.X > 0 then
			mod:spritePlay(sprite, "WalkRight")
			sprite:SetOverlayFrame("HeadRight", 0)
		elseif direction.Y < 0 then
			mod:spritePlay(sprite, "WalkUp")
			sprite:SetOverlayFrame("HeadUp", 0)
		else
			mod:spritePlay(sprite, "WalkDown")
			sprite:SetOverlayFrame("HeadDown", 0)
		end

		if targetDoor.Position:Distance(effect.Position) < 40 then
			sprite.Color = Color(1, 1, 1, targetDoor.Position:Distance(effect.Position) / 40)
		end

		if targetDoor.Position:Distance(effect.Position) < 5 then
			mod.ACHIEVEMENT.FRIEND:Unlock()
			effect:Remove()

			for _, player in ipairs(PlayerManager.GetPlayers()) do
				local pData = mod:GetEntityData(player)
				if pData.CouldMoveBeforeUnlock ~= nil then
					player.ControlsEnabled = pData.CouldMoveBeforeUnlock
				else
					player.ControlsEnabled = true
				end

				player:GetSprite():SetLastFrame()
				player:SetMinDamageCooldown(60)
				return
			end
		end
	end

	-- Lock shot players into being on the floor dead
	for _, player in ipairs(PlayerManager.GetPlayers()) do
		local pData = mod:GetEntityData(player)
		local sprite = player:GetSprite()
		if pData.ShotByFriendUnlockBullet and sprite:IsPlaying("DeathTeleport") and sprite:GetFrame() >= 19 then
			sprite:SetFrame(19)
		end
	end
end

function mod:UpdateFriendUnlockBullet(bullet)
	local data = mod:GetEntityData(bullet)
	if data.FriendUnlockBullet then
		for _, player in ipairs(Isaac.FindInRadius(bullet.Position, bullet.Size, EntityPartition.PLAYER)) do
			player = player:ToPlayer()
			local pData = mod:GetEntityData(player)
			if not pData.ShotByFriendUnlockBullet then
				pData.ShotByFriendUnlockBullet = true
				data.FriendUnlockBullet = false
				player:TakeDamage(99999, DamageFlag.DAMAGE_NOKILL | DamageFlag.DAMAGE_NO_PENALTIES, EntityRef(player), 30)
				player:PlayExtraAnimation("DeathTeleport")
			end
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.UpdateFriendUnlockBullet, mod.TEAR.M90_BULLET)

function mod:FriendUnlockGunMovement(e)
    local d = mod:GetEntityData(e)
    local sprite = e:GetSprite()
	local parentEffect = e.SpawnerEntity

    d.CurrentAngle = d.CurrentAngle or 90
    d.CurrentAngle = d.CurrentAngle % 360

    local offset = mod.FriendBalancing.DefaultHeldOffset
    local verticalOffset = mod.FriendBalancing.DefaultVerticalOffset
    if d.CurrentAngle > 0 and d.CurrentAngle < 180 then
        local real = (90-math.abs(90-d.CurrentAngle))/90
        offset = offset-offset*0.25*real
    end
    local dir = Vector(offset, verticalOffset):Rotated(d.CurrentAngle)

    e.SpriteRotation = d.CurrentAngle

    if d.CurrentAngle > 90 and d.CurrentAngle <= 270 then
        sprite.FlipX = true
        e.SpriteRotation = 180-e.SpriteRotation
    else
        sprite.FlipX = false
    end

	e.Position = parentEffect.Position + dir
end

function mod:FriendUnlockGunUpdate(e)
    local sprite = e:GetSprite()
    local d = mod:GetEntityData(e)

    if not d.init then
        d.State = "Appear"
        d.init = true
    end

    local parentEffect = e.SpawnerEntity
    if parentEffect and parentEffect:Exists() then
        mod:FriendUnlockGunMovement(e)

        if d.State == "Idle" then
            if d.JustShot then
                d.State = "Shoot"
            end
            mod:SpritePlay(sprite, "Idle")
        elseif d.State == "Appear" then
            if sprite:IsFinished("Appear") then
                d.State = "Idle"
            else
                mod:SpritePlay(sprite, "Appear")
            end
        elseif d.State == "Shoot" then
            if sprite:IsFinished("Shoot") then
                d.State = "Idle"
            else
                mod:SpritePlay(sprite, "Shoot")
            end
        elseif d.State == "Disappear" then
            if sprite:IsFinished("Disappear") then
                e:Remove()
            else
                mod:SpritePlay(sprite, "Disappear")
            end
        end
    else
        e.Velocity = Vector.Zero
        if sprite:IsFinished("Disappear") then
            e:Remove()
        else
            mod:spritePlay(sprite, "Disappear")
        end
    end
end

-- Fake golem trapdoor
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
	if not mod:GetEntityData(eff).GolemUnlockTrapdoor then return end

	local sprite = eff:GetSprite()
	local anim = sprite:GetAnimation()
	if sprite:GetFrame() >= sprite:GetCurrentAnimationData():GetLength()-1 then
		if anim == "Push" then
			sprite:Play("Open Animation", true)
		elseif anim == "Open Animation" then
			sprite:Play("Close Animation", true)
		elseif anim == "Close Animation" then
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 1, eff.Position, Vector.Zero, nil)
			eff:Remove()
		end
	elseif anim == "Open Animation" and eff.Parent and not eff.Parent:GetSprite():IsPlaying("Trapdoor") then
		sprite:SetFrame(0)
	elseif anim == "Close Animation" and eff.Parent then
		sprite:SetFrame(0)
	end
end, EffectVariant.POOF02)

local function GetTaintedAchivement(playerType)
	if playerType == mod.PLAYER.FIEND then
		return FiendFolio.ACHIEVEMENT.BIEND
	elseif playerType == mod.PLAYER.GOLEM then
		return FiendFolio.ACHIEVEMENT.BOLEM
	elseif playerType == mod.PLAYER.FRIEND then
		return FiendFolio.ACHIEVEMENT.BRIEND
	elseif playerType == mod.PLAYER.INABA then
		return FiendFolio.ACHIEVEMENT.BINABA
	end
end

-- Spawn still-locked Tainted Character in the closet for their normal counterpart.
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	local level = game:GetLevel()
	local desc = level:GetCurrentRoomDesc()

	local playerType = Isaac.GetPlayer():GetPlayerType()
	local taintedAchievement = GetTaintedAchivement(playerType)

	if level:GetStage() == LevelStage.STAGE8 and desc.SafeGridIndex == 94 and mod.CanRunUnlockAchievements() and taintedAchievement then
		if not taintedAchievement:IsUnlocked() then
			for _, shopkeeper in pairs(Isaac.FindByType(17)) do
				shopkeeper:Remove()
			end
			for _, item in pairs(Isaac.FindByType(5)) do
				item:Remove()
			end

			if #Isaac.FindByType(EntityType.ENTITY_SLOT, SlotVariant.HOME_CLOSET_PLAYER) == 0 then
				Isaac.Spawn(EntityType.ENTITY_SLOT, SlotVariant.HOME_CLOSET_PLAYER, 0, game:GetRoom():GetCenterPos(), Vector.Zero, nil)
			end
		elseif not taintedAchievement:IsUnlocked(true) then
			-- achievements are disabled, just give them the unlocks for any of our players
			for _, player in ipairs(PlayerManager.GetPlayers()) do
				if player.Parent == nil and player.Variant == PlayerVariant.PLAYER then
					local playerType = player:GetPlayerType()
					local taintedAchievement = GetTaintedAchivement(playerType)
					if taintedAchievement and not taintedAchievement:IsUnlocked(true) then
						taintedAchievement:Unlock()
					end
				end
			end
			
			for _, shopkeeper in pairs(Isaac.FindByType(17)) do
				shopkeeper:Remove()
			end

			if #Isaac.FindByType(EntityType.ENTITY_SLOT, SlotVariant.HOME_CLOSET_PLAYER) == 0 and 
			   #Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_INNER_CHILD) == 0 
			then
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_INNER_CHILD, game:GetRoom():GetCenterPos(), Vector.Zero, nil)
			end
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_SLOT_INIT, function(_, slot)
	if mod:IsGolemUnlockRoom() then
		InitGolemUnlockSlot(slot)
	else
		local playerType = Isaac.GetPlayer():GetPlayerType()
		if GetTaintedAchivement(playerType) then
			slot:GetSprite():ReplaceSpritesheet(0, EntityConfig.GetPlayer(playerType):GetTaintedCounterpart():GetSkinPath(), true)
		end
	end
end, SlotVariant.HOME_CLOSET_PLAYER)

-- Trigger Tainted Character unlock.
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, function(_, slot)
	if mod:IsGolemUnlockRoom() then
		UpdateGolemUnlockSlot(slot)
	elseif slot:GetSprite():IsFinished("PayPrize") then
		local taintedAchivement = GetTaintedAchivement(Isaac.GetPlayer():GetPlayerType())
		if taintedAchivement and not taintedAchivement:IsUnlocked(true) then
			taintedAchivement:Unlock()
		end
	end
end, SlotVariant.HOME_CLOSET_PLAYER)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_SLOT_COLLISION, CallbackPriority.IMPORTANT-1, function()
	if mod:IsGolemUnlockRoom() then
		return false
	end
end, SlotVariant.HOME_CLOSET_PLAYER)

-- Snooze Button
--[[local lastGreedButtonState = {}
mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_PRESSUREPLATE_UPDATE, function(_, plate)
	if mod.CanRunUnlockAchievements() and plate:GetVariant() == 2 then
		local ptrhash = GetPtrHash(plate)
		if plate.State == 1 and (lastGreedButtonState[ptrhash] or 0) ~= 1 and plate:GetSprite():GetAnimation() == "SwitchedRed" then
			FiendFolio.savedata.greedTimerStopped = (FiendFolio.savedata.greedTimerStopped or 0) + 1
			if FiendFolio.savedata.greedTimerStopped >= 5 and not FiendFolio.ACHIEVEMENT.SNOOZE_BUTTON:IsUnlocked(true) then
				FiendFolio.ACHIEVEMENT.SNOOZE_BUTTON:Unlock()
			end
		end
		lastGreedButtonState[ptrhash] = plate.State
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	lastGreedButtonState = {}
end)]]--

-- Backdrop unlocks --
local tookDmgThisRoom = false
function mod:CheckBackdropDamage(player, damage, flags, source, countdown)
	if flags & DamageFlag.DAMAGE_FAKE == 0 and flags & DamageFlag.DAMAGE_NO_PENALTIES == 0 then
		tookDmgThisRoom = true
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, mod.CheckBackdropDamage, EntityType.ENTITY_PLAYER)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	tookDmgThisRoom = false
end)

function mod:CheckBackdropUnlocks()
	if mod.CanRunUnlockAchievements() and not tookDmgThisRoom then
		if mod.roomBackdrop == 4 then -- honeyed cellar
			FiendFolio.savedata.honeyedRoomsPerfect = (FiendFolio.savedata.honeyedRoomsPerfect or 0) + 1
			if FiendFolio.savedata.honeyedRoomsPerfect >= 25 and not FiendFolio.ACHIEVEMENT.BEE_SKIN:IsUnlocked(true) then
				FiendFolio.ACHIEVEMENT.BEE_SKIN:Unlock()
			end
		elseif mod.roomBackdrop == 2 then -- smoky burning basement
			FiendFolio.savedata.smokyRoomsPerfect = (FiendFolio.savedata.smokyRoomsPerfect or 0) + 1
			if FiendFolio.savedata.smokyRoomsPerfect >= 25 and not FiendFolio.ACHIEVEMENT.MODERN_OUROBOROS:IsUnlocked(true) then
				FiendFolio.ACHIEVEMENT.MODERN_OUROBOROS:Unlock()
			end
		elseif mod.roomBackdrop == 6 then -- primordial caves
			FiendFolio.savedata.primordialRoomsPerfect = (FiendFolio.savedata.primordialRoomsPerfect or 0) + 1
			if FiendFolio.savedata.primordialRoomsPerfect >= 25 and not FiendFolio.ACHIEVEMENT.EARTH_IMPALE:IsUnlocked(true) then
				FiendFolio.ACHIEVEMENT.EARTH_IMPALE:Unlock()
			end
		elseif mod.roomBackdrop == 3 then -- pipes dank depths
			FiendFolio.savedata.pipesRoomsPerfect = (FiendFolio.savedata.pipesRoomsPerfect or 0) + 1
			if FiendFolio.savedata.pipesRoomsPerfect >= 25 and not FiendFolio.ACHIEVEMENT.CHUNK_OF_TAR:IsUnlocked(true) then
				FiendFolio.ACHIEVEMENT.CHUNK_OF_TAR:Unlock()
			end
		elseif mod.roomBackdrop == 8 then -- trash dank depths
			FiendFolio.savedata.trashRoomsPerfect = (FiendFolio.savedata.trashRoomsPerfect or 0) + 1
			if FiendFolio.savedata.trashRoomsPerfect >= 25 and not FiendFolio.ACHIEVEMENT.MISPRINTED_GISH:IsUnlocked(true) then
				FiendFolio.ACHIEVEMENT.MISPRINTED_GISH:Unlock()
			end
		elseif mod.roomBackdrop == 5 then -- eyeball utero
			FiendFolio.savedata.eyeballRoomsPerfect = (FiendFolio.savedata.eyeballRoomsPerfect or 0) + 1
			if FiendFolio.savedata.eyeballRoomsPerfect >= 25 and not FiendFolio.ACHIEVEMENT.EMPTY_GAZE:IsUnlocked(true) then
				FiendFolio.ACHIEVEMENT.EMPTY_GAZE:Unlock()
			end
		elseif mod.roomBackdrop == 12 then -- psionic sheol
			FiendFolio.savedata.psionicRoomsPerfect = (FiendFolio.savedata.psionicRoomsPerfect or 0) + 1
			if FiendFolio.savedata.psionicRoomsPerfect >= 25 and not FiendFolio.ACHIEVEMENT.CALLING_CARD:IsUnlocked(true) then
				FiendFolio.ACHIEVEMENT.CALLING_CARD:Unlock()
			end
		elseif mod.roomBackdrop == 14 then -- surreal sheol
			FiendFolio.savedata.surrealRoomsPerfect = (FiendFolio.savedata.surrealRoomsPerfect or 0) + 1
			if FiendFolio.savedata.surrealRoomsPerfect >= 25 and not FiendFolio.ACHIEVEMENT.DRIED_PAINT:IsUnlocked(true) then
				FiendFolio.ACHIEVEMENT.DRIED_PAINT:Unlock()
			end
		elseif mod.roomBackdrop == 9 then -- peepee dross
			FiendFolio.savedata.peepeeRoomsPerfect = (FiendFolio.savedata.peepeeRoomsPerfect or 0) + 1
			if FiendFolio.savedata.peepeeRoomsPerfect >= 25 and not FiendFolio.ACHIEVEMENT.LEMON_MISHUH:IsUnlocked(true) then
				FiendFolio.ACHIEVEMENT.LEMON_MISHUH:Unlock()
			end
		elseif mod.roomBackdrop == 13 then -- irradiated ashpit
			FiendFolio.savedata.irradiatedRoomsPerfect = (FiendFolio.savedata.irradiatedRoomsPerfect or 0) + 1
			if FiendFolio.savedata.irradiatedRoomsPerfect >= 25 and not FiendFolio.ACHIEVEMENT.MTN_DEW:IsUnlocked(true) then
				FiendFolio.ACHIEVEMENT.MTN_DEW:Unlock()
			end
		elseif mod.roomBackdrop == 11 or game:GetRoom():GetBackdropType() == BackdropType.MAUSOLEUM3 then -- otherside mausoleum
			FiendFolio.savedata.othersideRoomsPerfect = (FiendFolio.savedata.othersideRoomsPerfect or 0) + 1
			-- nothing unlocked for now :)
		elseif mod.roomBackdrop == 10 then -- morbus
			FiendFolio.savedata.morbusRoomsPerfect = (FiendFolio.savedata.morbusRoomsPerfect or 0) + 1
			if FiendFolio.savedata.morbusRoomsPerfect >= 25 and not FiendFolio.ACHIEVEMENT.MORBID_HEART:IsUnlocked(true) then
				FiendFolio.ACHIEVEMENT.MORBID_HEART:Unlock()
			end
		end
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, -1 * math.huge, mod.CheckBackdropUnlocks)

local tryUnlockHydrokinesis = false
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
	if npc.Variant == 0 and game:GetRoom():GetType() == RoomType.ROOM_BOSS and mod.CanRunUnlockAchievements() then
		tryUnlockHydrokinesis = true
	end
end, EntityType.ENTITY_RAINMAKER)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, -1 * math.huge, function()
	if tryUnlockHydrokinesis and not FiendFolio.ACHIEVEMENT.HYDROKINESIS:IsUnlocked(true) then
		FiendFolio.ACHIEVEMENT.HYDROKINESIS:Unlock()
	end
	tryUnlockHydrokinesis = false
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	tryUnlockHydrokinesis = false
end)

local tryUnlockClutchsCurse = false
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
	if npc.Variant == 0 and game:GetRoom():GetType() == RoomType.ROOM_BOSS and mod.CanRunUnlockAchievements() then
		tryUnlockClutchsCurse = true
	end
end, EntityType.ENTITY_CLUTCH)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, -1 * math.huge, function()
	if tryUnlockClutchsCurse and not FiendFolio.ACHIEVEMENT.CLUTCHS_CURSE:IsUnlocked(true) then
		FiendFolio.ACHIEVEMENT.CLUTCHS_CURSE:Unlock()
	end
	tryUnlockClutchsCurse = false
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	tryUnlockClutchsCurse = false
end)

local tryUnlockQueenOfClubs = false
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
	if npc.Variant == 0 and game:GetRoom():GetType() == RoomType.ROOM_BOSS and mod.CanRunUnlockAchievements() then
		tryUnlockQueenOfClubs = true
	end
end, EntityType.ENTITY_SINGE)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, -1 * math.huge, function()
	if tryUnlockQueenOfClubs and not FiendFolio.ACHIEVEMENT.QUEEN_OF_CLUBS:IsUnlocked(true) then
		FiendFolio.ACHIEVEMENT.QUEEN_OF_CLUBS:Unlock()
	end
	tryUnlockQueenOfClubs = false
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	tryUnlockQueenOfClubs = false
end)

local function aliveStevensRemain()
	for _, steven in ipairs(Isaac.FindByType(EntityType.ENTITY_GEMINI, 1)) do
		if not steven:IsDead() then
			return true
		end
	end
	for _, steven in ipairs(Isaac.FindByType(EntityType.ENTITY_GEMINI, 11)) do
		if not steven:IsDead() then
			return true
		end
	end
	return false
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, function(_, npc, source)
	if mod.CanRunUnlockAchievements() and not FiendFolio.ACHIEVEMENT.STEVENS_HAT:IsUnlocked(true) and npc:IsDead() and mod:GetEntityData(npc).GunslingerData then
		if npc.Variant == 1 and not aliveStevensRemain() then
			FiendFolio.ACHIEVEMENT.STEVENS_HAT:Unlock()
		elseif npc.Variant == 11 and not aliveStevensRemain() then
			FiendFolio.ACHIEVEMENT.STEVENS_HAT:Unlock()
		end
	end
end, EntityType.ENTITY_GEMINI)

function mod:CheckHingeUnlock(collectible)
	if PlayerManager.AnyoneHasCollectible(FiendFolio.ITEM.COLLECTIBLE.LIL_FIEND) and
	   PlayerManager.AnyoneHasCollectible(FiendFolio.ITEM.COLLECTIBLE.LIL_FRIEND) and
	   not FiendFolio.ACHIEVEMENT.HINGE:IsUnlocked(true)
	then
		FiendFolio.ACHIEVEMENT.HINGE:Unlock()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.CheckHingeUnlock, FiendFolio.ITEM.COLLECTIBLE.LIL_FIEND)
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.CheckHingeUnlock, FiendFolio.ITEM.COLLECTIBLE.LIL_FRIEND)

function mod:CheckOrichalcosSealDamage(entity, damage, flags, source, countdown)
	if mod:CanRunUnlockAchievements() and entity:ToNPC() and entity:HasMortalDamage() and source and
	   ((source.Type == EntityType.ENTITY_FAMILIAR and source.Variant == FamiliarVariant.WISP) or
	    (source.SpawnerType == EntityType.ENTITY_FAMILIAR and source.SpawnerVariant == FamiliarVariant.WISP)) and
	   not mod:GetEntityData(entity).hasTrackedVirtuesKill
	then
		mod.savedata.virtuesWispKills = mod.savedata.virtuesWispKills + 1
		if not FiendFolio.ACHIEVEMENT.SEAL_OF_ORICHALCOS:IsUnlocked(true) and mod.savedata.virtuesWispKills >= 50 then
			FiendFolio.ACHIEVEMENT.SEAL_OF_ORICHALCOS:Unlock()
		end
		mod:GetEntityData(entity).hasTrackedVirtuesKill = true
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, mod.CheckOrichalcosSealDamage)

function mod:CheckGolemsSubUnlock()
	if not FiendFolio.ACHIEVEMENT.GOLEMS_SUB:IsUnlocked(true) then
		local numSmelted = 0
		for _, player in ipairs(PlayerManager.GetPlayers()) do
			local smelted = player:GetSmeltedTrinkets()
			for id, tab in pairs(smelted) do
				if FiendFolio.IsRockTrinket(id) then
					numSmelted = numSmelted + tab.trinketAmount + tab.goldenTrinketAmount
				end
			end
		end
		if numSmelted >= 15 then
			FiendFolio.ACHIEVEMENT.GOLEMS_SUB:Unlock()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, mod.CheckGolemsSubUnlock)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.CheckGolemsSubUnlock, CollectibleType.COLLECTIBLE_SMELTER)

------------------------------------------
-- LOCKED THINGS DISABLING STARTS HERE! --
------------------------------------------

-- zodiac beggar, beast beggar

function mod:checkLockedZodiacBeggar(typ, var, sub, pos, vel, spawner, seed)
	if not FiendFolio.ACHIEVEMENT.ZODIAC_BEGGAR:IsUnlocked() and game:GetRoom():GetType() ~= RoomType.ROOM_PLANETARIUM then
		return {5, 10, 3, seed}
	end
end

function mod:checkLockedEvilBeggar(typ, var, sub, pos, vel, spawner, seed)
	if not FiendFolio.ACHIEVEMENT.BEAST_BEGGAR:IsUnlocked() then
		return {6, 5, 0, seed}
	end
end

function mod:checkLockedGoldenSlot(typ, var, sub, pos, vel, spawner, seed)
	if not mod.ACHIEVEMENT.GOLDEN_SLOT_MACHINE:IsUnlocked() then
		return {6, 1, 0, seed}
	end
end

-- Immoral hearts & variants
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	if pickup.SpawnerType ~= 1 and not mod.ACHIEVEMENT.IMMORAL_HEART:IsUnlocked() and not GameHasFiend() then
		pickup:Morph(5, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK, true, true)
	end
end, mod.PICKUP.VARIANT.IMMORAL_HEART)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	if pickup.SpawnerType ~= 1 and not mod.ACHIEVEMENT.IMMORAL_HEART:IsUnlocked() and not GameHasFiend() then
		pickup:Morph(5, mod.PICKUP.VARIANT.HALF_BLACK_HEART, 0, true, true)
	end
end, mod.PICKUP.VARIANT.HALF_IMMORAL_HEART)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	if pickup.SpawnerType ~= 1 and not mod.ACHIEVEMENT.IMMORAL_HEART:IsUnlocked() and not GameHasFiend() then
		pickup:Morph(5, mod.PICKUP.VARIANT.BLENDED_BLACK_HEART, 0, true, true)
	end
end, mod.PICKUP.VARIANT.BLENDED_IMMORAL_HEART)

-- Morbid hearts
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	if not mod.ACHIEVEMENT.MORBID_HEART:IsUnlocked() then
		if Isaac.GetPersistentGameData():Unlocked(Achievement.ROTTEN_HEARTS) then
			pickup:Morph(5, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN)
		else
			pickup:Morph(5, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL)
		end
	end
end, mod.PICKUP.VARIANT.MORBID_HEART)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	if not mod.ACHIEVEMENT.MORBID_HEART:IsUnlocked() then
		if Isaac.GetPersistentGameData():Unlocked(Achievement.ROTTEN_HEARTS) then
			pickup:Morph(5, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN)
		else
			pickup:Morph(5, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF)
		end
	end
end, mod.PICKUP.VARIANT.TWOTHIRDS_MORBID_HEART)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	if not mod.ACHIEVEMENT.MORBID_HEART:IsUnlocked() then
		if Isaac.GetPersistentGameData():Unlocked(Achievement.ROTTEN_HEARTS) then
			pickup:Morph(5, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN)
		else
			pickup:Morph(5, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF)
		end
	end
end, mod.PICKUP.VARIANT.THIRD_MORBID_HEART)

-- Fool's Gold Heart
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	if not mod.ACHIEVEMENT.FOOLS_GOLD_HEART:IsUnlocked() then
		if mod.ACHIEVEMENT.IMMORAL_HEART:IsUnlocked() then
			pickup:Morph(5, mod.PICKUP.VARIANT.IMMORAL_HEART, 0)
		else
			pickup:Morph(5, PickupVariant.PICKUP_HEART, 0)
		end
	end
end, mod.PICKUP.VARIANT.FOOLS_GOLD_HEART)

-- Soul Shard
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	if not (mod.ACHIEVEMENT.SOUL_SHARD:IsUnlocked() and mod.ACHIEVEMENT.INABA:IsUnlocked(true)) then
		pickup:Morph(5, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL)
	end
end, mod.PICKUP.VARIANT.SOUL_SHARD)

-- Golden cursed penny
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	if pickup.SubType == mod.PICKUP.COIN.GOLDENCURSED and not mod.ACHIEVEMENT.GOLDEN_CURSED_PENNY:IsUnlocked() then
		pickup:Morph(5, PickupVariant.PICKUP_COIN, mod.PICKUP.COIN.CURSED)
	end
end, PickupVariant.PICKUP_COIN)

-- Haunted Penny
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	if pickup.SubType == mod.PICKUP.COIN.HAUNTED and not mod.ACHIEVEMENT.HAUNTED_PENNY:IsUnlocked() then
		pickup:Morph(5, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY)
	end
end, PickupVariant.PICKUP_COIN)

-- Haunted Penny
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	if not mod.ACHIEVEMENT.VIRTUOUS_BATTERY:IsUnlocked() then
		pickup:Morph(5, PickupVariant.PICKUP_LIL_BATTERY, BatterySubType.BATTERY_NORMAL)
	end
end, mod.PICKUP.VARIANT.VIRTUOUS_BATTERY)

-- Platinum Penny
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	if pickup.SubType == mod.PICKUP.COIN.PLATINUM and not mod.ACHIEVEMENT.PLATINUM_PENNY:IsUnlocked() then
		pickup:Morph(5, PickupVariant.PICKUP_COIN, CoinSubType.COIN_DIME)
	end
end, PickupVariant.PICKUP_COIN)

-- Dire chest
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	if not mod.ACHIEVEMENT.DIRE_CHEST:IsUnlocked() then
		pickup:Morph(5, PickupVariant.PICKUP_REDCHEST, 0)
	end
end, mod.PICKUP.VARIANT.DIRE_CHEST)

-- Glass chest
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	if not mod.ACHIEVEMENT.GLASS_CHEST:IsUnlocked() then
		pickup:Morph(5, PickupVariant.PICKUP_LOCKEDCHEST, 0)
	end
end, mod.PICKUP.VARIANT.GLASS_CHEST)

-- 52 Deck
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	if pickup.SubType == 11 then
		if not mod.ACHIEVEMENT["52_DECK"]:IsUnlocked() then
			pickup:Morph(5, PickupVariant.PICKUP_GRAB_BAG, 0)
		end
	end
end, mod.PICKUP.VARIANT.DECK52)

-- Token
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	if not mod.ACHIEVEMENT["TOKEN"]:IsUnlocked() then
		pickup:Morph(5, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY)
	end
end, mod.PICKUP.VARIANT.TOKEN)


-- Cheeky funny little temporary thing: Mark all of inaba's items as hidden until she's been found to hide them from the collection page...
-- We can remove this at some point post-release. Repentogon may also make this unnecessary later (maybe we can hide locked items...)
function mod:SetInabaUnlocksHidden(hidden)
	mod.InabaUnlocksHidden = hidden
	for _, item in pairs(mod.ITEM.COLLECTIBLE) do
		local xml = XMLData.GetEntryById(XMLNode.ITEM, item)
		if xml and xml.achievement and tonumber(xml.achievement) then
			local achievementxml = XMLData.GetEntryById(XMLNode.ACHIEVEMENT, tonumber(xml.achievement))
			if achievementxml and achievementxml.name then
				local ffchevo = string.gsub(achievementxml.name, "^FF_", "")
				if mod.ACHIEVEMENT[ffchevo] then
					for _, tag in ipairs(mod.ACHIEVEMENT[ffchevo].Tags) do
						if tag == "Inaba" or tag == "Binaba" then
							local conf = Isaac.GetItemConfig():GetCollectible(item)
							if conf then
								conf.Hidden = hidden
							end
							break
						end
					end
				end
			end
		end
	end
end
if mod.InabaUnlocksHidden == nil then
	mod:SetInabaUnlocksHidden(true)
end
local INABA_ACHIEVEMENT = Isaac.GetAchievementIdByName("FF_INABA")
mod:AddCallback(ModCallbacks.MC_POST_SAVESLOT_LOAD, function(_, slot, selected, rawslot)
	if mod.InabaUnlocksHidden and Isaac.GetPersistentGameData():Unlocked(INABA_ACHIEVEMENT) then
		mod:SetInabaUnlocksHidden(false)
	end
end)
mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, function()
	if mod.InabaUnlocksHidden then
		mod:SetInabaUnlocksHidden(false)
	end
end, INABA_ACHIEVEMENT)

function mod:CheckIceIXUnlock()
	if not mod.ACHIEVEMENT.ICE_IX:IsUnlocked(true) and FiendFolio.savedata.beatMomAsInaba then
		mod.ACHIEVEMENT.ICE_IX:Unlock()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.CheckIceIXUnlock)


-- SALUTE
--[[
-- Biend Locks
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	if not FiendFolio.ACHIEVEMENT.BIEND:IsUnlocked() then
		local level = game:GetLevel()
		local desc = level:GetCurrentRoomDesc()

		local playerType = Isaac.GetPlayer():GetPlayerType()

		if level:GetStage() == LevelStage.STAGE8 and desc.SafeGridIndex == 94 and ((playerType == mod.PLAYER.FIEND and mod.CanRunUnlockAchievements()) or playerType == mod.PLAYER.BIEND) then
			for _, shopkeeper in pairs(Isaac.FindByType(17)) do
				shopkeeper:Remove()
			end

			for _, item in pairs(Isaac.FindByType(5)) do
				item:Remove()
			end

			local room = game:GetRoom()
			local centre = room:GetCenterPos()
			local biend = Isaac.FindByType(6, 14)[1] or Isaac.Spawn(6, 14, 0, centre, Vector.Zero, nil)
			local sprite = biend:GetSprite()
			sprite:ReplaceSpritesheet(0, "gfx/characters/costumes/player_fiendb.png")
			sprite:LoadGraphics()

			if playerType == mod.PLAYER.BIEND then
				local door = room:GetDoor(2)
				room:RemoveGridEntity(door:GetGridIndex(), 0, false)

				for i = 1, 3 do
					Isaac.Spawn(1000, 21, 0, centre, Vector.Zero, nil)
				end

				Isaac.Spawn(1000, 64, 0, centre, Vector.Zero, nil)
			end
		end
	end
end)

function FiendFolio.SafeEndGame()
	-- disable achievements
	game:GetSeeds():AddSeedEffect(SeedEffect.SEED_PREVENT_ALL_CURSES)
	game:End(3)
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	if not FiendFolio.ACHIEVEMENT.BIEND:IsUnlocked() and game.Difficulty >= Difficulty.DIFFICULTY_GREED and Isaac.GetPlayer():GetPlayerType() == mod.PLAYER.BIEND then
		FiendFolio.SafeEndGame()
	end

	if Isaac.GetPlayer():GetPlayerType() == mod.PLAYER.BOLEM then
		--FiendFolio.SafeEndGame()
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
	if player.FrameCount > 0 then
		FiendFolio.TryLockBiendInHome(player)
	end
end)

function FiendFolio.TryLockBiendInHome(player)
	player = player or Isaac.GetPlayer()
	if not FiendFolio.ACHIEVEMENT.BIEND:IsUnlocked() and player:GetPlayerType() == mod.PLAYER.BIEND then
		player.ControlsEnabled = false
		player.Visible = false
		mod:GetEntityData(player).BiendClosetMode = true

		local hud = game:GetHUD()
		hud:SetVisible(false)

		if game.Difficulty < Difficulty.DIFFICULTY_GREED then
			local level = game:GetLevel()
			if level:GetStage() ~= LevelStage.STAGE8 then
				Isaac.ExecuteCommand("stage 13")
				level:ChangeRoom(95)

				player.Position = Vector(245, 280)
				player:SetPocketActiveItem(CollectibleType.COLLECTIBLE_RED_KEY, ActiveSlot.SLOT_POCKET2)
				player:UseActiveItem(CollectibleType.COLLECTIBLE_RED_KEY, UseFlag.USE_OWNED + UseFlag.USE_NOANIM, ActiveSlot.SLOT_POCKET2)
				player:RemoveCollectible(CollectibleType.COLLECTIBLE_RED_KEY)
				player.Position = Vector(160, 280)

				SFXManager():Stop(SoundEffect.SOUND_UNLOCK00)
			end
		end
	end
end
]]