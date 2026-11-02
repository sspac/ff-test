local eidCardSprite = Sprite("gfx/ui/eid/eid_ff_cardfronts.anm2", true)

-- Note that I later use LUA MAGIC(!!) on this table to make able to be concatenated.
--
-- This means you can just outright concatenate with the table to concatenate the shortcut.
-- 
-- I recommend doing this because it allows us to change the name of the
-- icon without needing to edit a bunch of descriptions :)
--
-- Example:
-- FiendFolio.DescriptionIcons.Bruise .. " Bruised enemies take bonus damage per stack applied" 

---@type table<string, ItemDescriptionIcon>
return {
	Plus3Fireballs = {
        Shortcut = FiendFolio.ITEM.CARD.PLUS_3_FIREBALLS,
        Sprite = eidCardSprite,
        Animation = "+3 Fireballs",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    GlassD6 = {
        Shortcut = FiendFolio.ITEM.CARD.GLASS_D6,
        Sprite = eidCardSprite,
        Animation = "Glass D6",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 1,
        TopOffset = 1
    },
    GlassD4 = {
        Shortcut = FiendFolio.ITEM.CARD.GLASS_D4,
        Sprite = eidCardSprite,
        Animation = "Glass D4",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 1,
        TopOffset = 1
    },
    GlassD8 = {
        Shortcut = FiendFolio.ITEM.CARD.GLASS_D8,
        Sprite = eidCardSprite,
        Animation = "Glass D8",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 1,
        TopOffset = 1
    },
    GlassD100 = {
        Shortcut = FiendFolio.ITEM.CARD.GLASS_D100,
        Sprite = eidCardSprite,
        Animation = "Glass D100",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 1,
        TopOffset = 1
    },
    GlassD10 = {
        Shortcut = FiendFolio.ITEM.CARD.GLASS_D10,
        Sprite = eidCardSprite,
        Animation = "Glass D10",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 1,
        TopOffset = 1
    },
    GlassD20 = {
        Shortcut = FiendFolio.ITEM.CARD.GLASS_D20,
        Sprite = eidCardSprite,
        Animation = "Glass D20",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 1,
        TopOffset = 1
    },
    GlassD12 = {
        Shortcut = FiendFolio.ITEM.CARD.GLASS_D12,
        Sprite = eidCardSprite,
        Animation = "Glass D12",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 1,
        TopOffset = 1
    },
    GlassSpindown = {
        Shortcut = FiendFolio.ITEM.CARD.GLASS_SPINDOWN,
        Sprite = eidCardSprite,
        Animation = "Glass Spindown",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 1,
        TopOffset = 1
    },
    GlassAzuriteSpindown = {
        Shortcut = FiendFolio.ITEM.CARD.GLASS_AZURITE_SPINDOWN,
        Sprite = eidCardSprite,
        Animation = "Glass Azurite Spindown",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 1,
        TopOffset = 1
    },
    GlassD3 = {
        Shortcut = FiendFolio.ITEM.CARD.GLASS_D3,
        Sprite = eidCardSprite,
        Animation = "Glass D3",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 1,
        TopOffset = 1
    },
    GlassD5 = {
        Shortcut = FiendFolio.ITEM.CARD.GLASS_D5,
        Sprite = eidCardSprite,
        Animation = "Glass D5",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 1,
        TopOffset = 1
    },
    Implosion = {
        Shortcut = FiendFolio.ITEM.CARD.IMPLOSION,
        Sprite = eidCardSprite,
        Animation = "Imp-losion",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    CallingCard = {
        Shortcut = FiendFolio.ITEM.CARD.CALLING_CARD,
        Sprite = eidCardSprite,
        Animation = "Calling Card",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    GrottoBeast = {
        Shortcut = FiendFolio.ITEM.CARD.GROTTO_BEAST,
        Sprite = eidCardSprite,
        Animation = "Grotto Beast",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    GlassD2 = {
        Shortcut = FiendFolio.ITEM.CARD.GLASS_D2,
        Sprite = eidCardSprite,
        Animation = "Glass D2",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 1,
        TopOffset = 1
    },
    JackofDiamonds = {
        Shortcut = FiendFolio.ITEM.CARD.JACK_OF_DIAMONDS,
        Sprite = eidCardSprite,
        Animation = "Jack of Diamonds",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    JackofClubs = {
        Shortcut = FiendFolio.ITEM.CARD.JACK_OF_CLUBS,
        Sprite = eidCardSprite,
        Animation = "Jack of Clubs",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    KingofClubs = {
        Shortcut = FiendFolio.ITEM.CARD.KING_OF_CLUBS,
        Sprite = eidCardSprite,
        Animation = "King of Clubs",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    DownloadFailure = {
        Shortcut = FiendFolio.ITEM.CARD.DOWNLOAD_FAILURE,
        Sprite = eidCardSprite,
        Animation = "Download Failure",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    ThreeofClubs = {
        Shortcut = FiendFolio.ITEM.CARD.THREE_OF_CLUBS,
        Sprite = eidCardSprite,
        Animation = "3 of Clubs",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    ThreeofDiamonds = {
        Shortcut = FiendFolio.ITEM.CARD.THREE_OF_DIAMONDS,
        Sprite = eidCardSprite,
        Animation = "3 of Diamonds",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    ThreeofSpades = {
        Shortcut = FiendFolio.ITEM.CARD.THREE_OF_SPADES,
        Sprite = eidCardSprite,
        Animation = "3 of Spades",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    ThreeofHearts = {
        Shortcut = FiendFolio.ITEM.CARD.THREE_OF_HEARTS,
        Sprite = eidCardSprite,
        Animation = "3 of Hearts",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    SmallContraband = {
        Shortcut = FiendFolio.ITEM.CARD.SMALL_CONTRABAND,
        Sprite = eidCardSprite,
        Animation = "Small Contraband",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    PuzzlePiece = {
        Shortcut = FiendFolio.ITEM.CARD.PUZZLE_PIECE,
        Sprite = eidCardSprite,
        Animation = "Puzzle Piece",
        Frame = -1,
        Width = 9,
        Height = 10,
        LeftOffset = -2,
        TopOffset = 2
    },
    StorageBattery = {
        Shortcut = FiendFolio.ITEM.CARD.STORAGE_BATTERY_0,
        Sprite = eidCardSprite,
        Animation = "Storage Battery",
        Frame = -1,
        Width = 8,
        Height = 11,
        LeftOffset = -2,
        TopOffset = 1
    },
    StorageBattery1 = {
        Shortcut = FiendFolio.ITEM.CARD.STORAGE_BATTERY_1,
        Sprite = eidCardSprite,
        Animation = "Storage Battery (1)",
        Frame = -1,
        Width = 8,
        Height = 11,
        LeftOffset = -2,
        TopOffset = 1
    },
    StorageBattery2 = {
        Shortcut = FiendFolio.ITEM.CARD.STORAGE_BATTERY_2,
        Sprite = eidCardSprite,
        Animation = "Storage Battery (2)",
        Frame = -1,
        Width = 8,
        Height = 11,
        LeftOffset = -2,
        TopOffset = 1
    },
    StorageBatteryFull = {
        Shortcut = FiendFolio.ITEM.CARD.STORAGE_BATTERY_3,
        Sprite = eidCardSprite,
        Animation = "Storage Battery (Full)",
        Frame = -1,
        Width = 8,
        Height = 11,
        LeftOffset = -2,
        TopOffset = 1
    },
    SkipCard = {
        Shortcut = FiendFolio.ITEM.CARD.SKIP_CARD,
        Sprite = eidCardSprite,
        Animation = "Skip Card",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    Defuse = {
        Shortcut = FiendFolio.ITEM.CARD.DEFUSE,
        Sprite = eidCardSprite,
        Animation = "Defuse",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    CorrodedBattery = {
        Shortcut = FiendFolio.ITEM.CARD.CORRODED_BATTERY_0,
        Sprite = eidCardSprite,
        Animation = "Corroded Battery",
        Frame = -1,
        Width = 8,
        Height = 11,
        LeftOffset = -2,
        TopOffset = 1
    },
    CorrodedBattery1 = {
        Shortcut = FiendFolio.ITEM.CARD.CORRODED_BATTERY_1,
        Sprite = eidCardSprite,
        Animation = "Corroded Battery (1)",
        Frame = -1,
        Width = 8,
        Height = 11,
        LeftOffset = -2,
        TopOffset = 1
    },
    CorrodedBattery2 = {
        Shortcut = FiendFolio.ITEM.CARD.CORRODED_BATTERY_2,
        Sprite = eidCardSprite,
        Animation = "Corroded Battery (2)",
        Frame = -1,
        Width = 8,
        Height = 11,
        LeftOffset = -2,
        TopOffset = 1
    },
    CorrodedBatteryFull = {
        Shortcut = FiendFolio.ITEM.CARD.CORRODED_BATTERY_3,
        Sprite = eidCardSprite,
        Animation = "Corroded Battery (Full)",
        Frame = -1,
        Width = 8,
        Height = 11,
        LeftOffset = -2,
        TopOffset = 1
    },
    QueenofDiamonds = {
        Shortcut = FiendFolio.ITEM.CARD.QUEEN_OF_DIAMONDS,
        Sprite = eidCardSprite,
        Animation = "Queen of Diamonds",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    JackofSpades = {
        Shortcut = FiendFolio.ITEM.CARD.JACK_OF_SPADES,
        Sprite = eidCardSprite,
        Animation = "Jack of Spades",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    QueenofSpades = {
        Shortcut = FiendFolio.ITEM.CARD.QUEEN_OF_SPADES,
        Sprite = eidCardSprite,
        Animation = "Queen of Spades",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    KingofSpades = {
        Shortcut = FiendFolio.ITEM.CARD.KING_OF_SPADES,
        Sprite = eidCardSprite,
        Animation = "King of Spades",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    KingofDiamonds = {
        Shortcut = FiendFolio.ITEM.CARD.KING_OF_DIAMONDS,
        Sprite = eidCardSprite,
        Animation = "King of Diamonds",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    MisprintedJoker = {
        Shortcut = FiendFolio.ITEM.CARD.MISPRINTED_JOKER,
        Sprite = eidCardSprite,
        Animation = "Misprinted Joker",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    JokeofClubs = {
        Shortcut = FiendFolio.ITEM.CARD.MISPRINTED_JACK_OF_CLUBS,
        Sprite = eidCardSprite,
        Animation = "Joke of Clubs",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    MisprintedJusticeJack = {
        Shortcut = FiendFolio.ITEM.CARD.MISPRINTED_JUSTICEJACK,
        Sprite = eidCardSprite,
        Animation = "Misprinted JusticeJack",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    Plus3FireballsQ = {
        Shortcut = FiendFolio.ITEM.CARD.REVERSE_3_FIREBALLS,
        Sprite = eidCardSprite,
        Animation = "+3 Fireballs?",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    QueenofClubs = {
        Shortcut = FiendFolio.ITEM.CARD.QUEEN_OF_CLUBS,
        Sprite = eidCardSprite,
        Animation = "Queen of Clubs",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    JackofHearts = {
        Shortcut = FiendFolio.ITEM.CARD.JACK_OF_HEARTS,
        Sprite = eidCardSprite,
        Animation = "Jack of Hearts",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    SoulofFiend = {
        Shortcut = FiendFolio.ITEM.CARD.SOUL_OF_FIEND,
        Sprite = eidCardSprite,
        Animation = "Soul of Fiend",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -3,
        TopOffset = -1
    },
    SoulofGolem = {
        Shortcut = FiendFolio.ITEM.CARD.SOUL_OF_GOLEM,
        Sprite = eidCardSprite,
        Animation = "Soul of Golem",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -3,
        TopOffset = -1
    },
    SoulofFriend = {
        Shortcut = FiendFolio.ITEM.CARD.SOUL_OF_FRIEND,
        Sprite = eidCardSprite,
        Animation = "Soul of Friend",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -3,
        TopOffset = -1
    },
    SoulofRandom = {
        Shortcut = FiendFolio.ITEM.CARD.SOUL_OF_RANDOM,
        Sprite = eidCardSprite,
        Animation = "Soul of Random",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -3,
        TopOffset = -1
    },
    SoulofCraig = {
        Shortcut = FiendFolio.ITEM.CARD.SOUL_OF_CRAIG,
        Sprite = eidCardSprite,
        Animation = "Soul of Craig",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -3,
        TopOffset = -1
    },
    SoulofInaba = {
        Shortcut = FiendFolio.ITEM.CARD.SOUL_OF_INABA,
        Sprite = eidCardSprite,
        Animation = "Soul of Inaba",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -3,
        TopOffset = -1
    },
    PlagueofDecay = {
        Shortcut = FiendFolio.ITEM.CARD.PLAGUE_OF_DECAY,
        Sprite = eidCardSprite,
        Animation = "Plague of Decay",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    ThirteenofStars = {
        Shortcut = FiendFolio.ITEM.CARD.THIRTEEN_OF_STARS,
        Sprite = eidCardSprite,
        Animation = "13 of Stars",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    AceofWands = {
        Shortcut = FiendFolio.ITEM.CARD.ACE_OF_WANDS,
        Sprite = eidCardSprite,
        Animation = "Ace of Wands",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    AceofCups = {
        Shortcut = FiendFolio.ITEM.CARD.ACE_OF_CUPS,
        Sprite = eidCardSprite,
        Animation = "Ace of Cups",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    AceofPentacles = {
        Shortcut = FiendFolio.ITEM.CARD.ACE_OF_PENTACLES,
        Sprite = eidCardSprite,
        Animation = "Ace of Pentacles",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    AceofSwords = {
        Shortcut = FiendFolio.ITEM.CARD.ACE_OF_SWORDS,
        Sprite = eidCardSprite,
        Animation = "Ace of Swords",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    TwoofWands = {
        Shortcut = FiendFolio.ITEM.CARD.TWO_OF_WANDS,
        Sprite = eidCardSprite,
        Animation = "2 of Wands",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    TwoofPentacles = {
        Shortcut = FiendFolio.ITEM.CARD.TWO_OF_PENTACLES,
        Sprite = eidCardSprite,
        Animation = "2 of Pentacles",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    TwoofSwords = {
        Shortcut = FiendFolio.ITEM.CARD.TWO_OF_SWORDS,
        Sprite = eidCardSprite,
        Animation = "2 of Swords",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    ThreeofCups = {
        Shortcut = FiendFolio.ITEM.CARD.THREE_OF_CUPS,
        Sprite = eidCardSprite,
        Animation = "3 of Cups",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    ThreeofPentacles = {
        Shortcut = FiendFolio.ITEM.CARD.THREE_OF_PENTACLES,
        Sprite = eidCardSprite,
        Animation = "3 of Pentacles",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    ThreeofSwords = {
        Shortcut = FiendFolio.ITEM.CARD.THREE_OF_SWORDS,
        Sprite = eidCardSprite,
        Animation = "3 of Swords",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    ThreeofWands = {
        Shortcut = FiendFolio.ITEM.CARD.THREE_OF_WANDS,
        Sprite = eidCardSprite,
        Animation = "3 of Wands",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    KingofPentacles = {
        Shortcut = FiendFolio.ITEM.CARD.KING_OF_PENTACLES,
        Sprite = eidCardSprite,
        Animation = "King of Pentacles",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    KingofPentaclesQ = {
        Shortcut = FiendFolio.ITEM.CARD.REVERSE_KING_OF_PENTACLES,
        Sprite = eidCardSprite,
        Animation = "King of Pentacles?",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    MisprintedKingofPentacles = {
        Shortcut = FiendFolio.ITEM.CARD.MISPRINTED_KING_OF_PENTACLES,
        Sprite = eidCardSprite,
        Animation = "Misprinted King of Pentacles",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    KingofClubsQ = {
        Shortcut = FiendFolio.ITEM.CARD.REVERSE_KING_OF_CLUBS,
        Sprite = eidCardSprite,
        Animation = "King of Clubs?",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    Ansus = {
        Shortcut = FiendFolio.ITEM.CARD.RUNE_ANSUS,
        Sprite = eidCardSprite,
        Animation = "Ansus",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -5,
        TopOffset = -1
    },
    PotofGreed = {
        Shortcut = FiendFolio.ITEM.CARD.POT_OF_GREED,
        Sprite = eidCardSprite,
        Animation = "Pot of Greed",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    KingofCups = {
        Shortcut = FiendFolio.ITEM.CARD.KING_OF_CUPS,
        Sprite = eidCardSprite,
        Animation = "King of Cups",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    KingofWands = {
        Shortcut = FiendFolio.ITEM.CARD.KING_OF_WANDS,
        Sprite = eidCardSprite,
        Animation = "King of Wands",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    FairyEnergy = {
        Shortcut = FiendFolio.ITEM.CARD.ENERGY_FAIRY,
        Sprite = eidCardSprite,
        Animation = "Fairy Energy",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    FireEnergy = {
        Shortcut = FiendFolio.ITEM.CARD.ENERGY_FIRE,
        Sprite = eidCardSprite,
        Animation = "Fire Energy",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    FightingEnergy = {
        Shortcut = FiendFolio.ITEM.CARD.ENERGY_FIGHTING,
        Sprite = eidCardSprite,
        Animation = "Fighting Energy",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    DragonEnergy = {
        Shortcut = FiendFolio.ITEM.CARD.ENERGY_DRAGON,
        Sprite = eidCardSprite,
        Animation = "Dragon Energy",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    LightningEnergy = {
        Shortcut = FiendFolio.ITEM.CARD.ENERGY_LIGHTNING,
        Sprite = eidCardSprite,
        Animation = "Lightning Energy",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    GrassEnergy = {
        Shortcut = FiendFolio.ITEM.CARD.ENERGY_GRASS,
        Sprite = eidCardSprite,
        Animation = "Grass Energy",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    WaterEnergy = {
        Shortcut = FiendFolio.ITEM.CARD.ENERGY_WATER,
        Sprite = eidCardSprite,
        Animation = "Water Energy",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    PsychicEnergy = {
        Shortcut = FiendFolio.ITEM.CARD.ENERGY_PSYCHIC,
        Sprite = eidCardSprite,
        Animation = "Psychic Energy",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    DarknessEnergy = {
        Shortcut = FiendFolio.ITEM.CARD.ENERGY_DARKNESS,
        Sprite = eidCardSprite,
        Animation = "Darkness Energy",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    MetalEnergy = {
        Shortcut = FiendFolio.ITEM.CARD.ENERGY_METAL,
        Sprite = eidCardSprite,
        Animation = "Metal Energy",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    ColorlessEnergy = {
        Shortcut = FiendFolio.ITEM.CARD.ENERGY_COLORLESS,
        Sprite = eidCardSprite,
        Animation = "Colorless Energy",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    TrainerCard = {
        Shortcut = FiendFolio.ITEM.CARD.TRAINER_CARD,
        Sprite = eidCardSprite,
        Animation = "Trainer Card",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    GreenHouse = {
        Shortcut = FiendFolio.ITEM.CARD.GREEN_HOUSE,
        Sprite = eidCardSprite,
        Animation = "Green House",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -3,
        TopOffset = -2
    },
    CoolPhoto = {
        Shortcut = FiendFolio.ITEM.CARD.COOL_PHOTO,
        Sprite = eidCardSprite,
        Animation = "Cool Photo",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -3,
        TopOffset = 0
    },
    CardJitsuSoccer = {
        Shortcut = FiendFolio.ITEM.CARD.CARDJITSU_SOCCER,
        Sprite = eidCardSprite,
        Animation = "CardJitsu Soccer",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    CardJitsuFlooringUpgrade = {
        Shortcut = FiendFolio.ITEM.CARD.CARDJITSU_FLOORING_UPGRADE,
        Sprite = eidCardSprite,
        Animation = "CardJitsu Flooring Upgrade",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    CardJitsuAC3000 = {
        Shortcut = FiendFolio.ITEM.CARD.CARDJITSU_AC_3000,
        Sprite = eidCardSprite,
        Animation = "CardJitsu AC3000",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    DevilDisc = {
        Shortcut = FiendFolio.ITEM.CARD.DEVIL_DISC,
        Sprite = eidCardSprite,
        Animation = "Devil Disc",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -3,
        TopOffset = -2
    },
    TreasureDisc = {
        Shortcut = FiendFolio.ITEM.CARD.TREASURE_DISC,
        Sprite = eidCardSprite,
        Animation = "Treasure Disc",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -3,
        TopOffset = -2
    },
    ShopDisc = {
        Shortcut = FiendFolio.ITEM.CARD.SHOP_DISC,
        Sprite = eidCardSprite,
        Animation = "Shop Disc",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -3,
        TopOffset = -2
    },
    AngelDisc = {
        Shortcut = FiendFolio.ITEM.CARD.ANGEL_DISC,
        Sprite = eidCardSprite,
        Animation = "Angel Disc",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -3,
        TopOffset = -2
    },
    PlanetariumDisc = {
        Shortcut = FiendFolio.ITEM.CARD.PLANETARIUM_DISC,
        Sprite = eidCardSprite,
        Animation = "Planetarium Disc",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -3,
        TopOffset = -2
    },
    SecretDisc = {
        Shortcut = FiendFolio.ITEM.CARD.SECRET_DISC,
        Sprite = eidCardSprite,
        Animation = "Secret Disc",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -3,
        TopOffset = -2
    },
    BossDisc = {
        Shortcut = FiendFolio.ITEM.CARD.BOSS_DISC,
        Sprite = eidCardSprite,
        Animation = "Boss Disc",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -3,
        TopOffset = -2
    },
    ChaosDisc = {
        Shortcut = FiendFolio.ITEM.CARD.CHAOS_DISC,
        Sprite = eidCardSprite,
        Animation = "Chaos Disc",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -3,
        TopOffset = -2
    },
    BrokenDisc = {
        Shortcut = FiendFolio.ITEM.CARD.BROKEN_DISC,
        Sprite = eidCardSprite,
        Animation = "Broken Disc",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -3,
        TopOffset = -2
    },
    TaintedTreasureDisc = {
        Shortcut = FiendFolio.ITEM.CARD.TAINTED_TREASURE_DISC,
        Sprite = eidCardSprite,
        Animation = "Tainted Treasure Disc",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -3,
        TopOffset = -2
    },
    BrickSeperator = {
        Shortcut = FiendFolio.ITEM.CARD.BRICK_SEPERATOR,
        Sprite = eidCardSprite,
        Animation = "Brick Seperator",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -5,
        TopOffset = -1
    },
    BlankLetterTile = {
        Shortcut = FiendFolio.ITEM.CARD.BLANK_LETTER_TILE,
        Sprite = eidCardSprite,
        Animation = "Blank Letter Tile",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -5,
        TopOffset = -1
    },
    HorsePushPop = {
        Shortcut = FiendFolio.ITEM.CARD.HORSE_PUSHPOP,
        Sprite = eidCardSprite,
        Animation = "Horse Push-Pop",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -5,
        TopOffset = -1
    },
    TopHat = {
        Shortcut = FiendFolio.ITEM.CARD.TOP_HAT,
        Sprite = eidCardSprite,
        Animation = "TopHat",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -5,
        TopOffset = -1
    },
    GiftCard = {
        Shortcut = FiendFolio.ITEM.CARD.GIFT_CARD,
        Sprite = eidCardSprite,
        Animation = "Gift Card",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    Misprinted2ofClubs = {
        Shortcut = FiendFolio.ITEM.CARD.MISPRINTED_TWO_OF_CLUBS,
        Sprite = eidCardSprite,
        Animation = "Misprinted 2 of Clubs",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    Misprinted3ofDiamonds = {
        Shortcut = FiendFolio.ITEM.CARD.MISPRINTED_THREE_OF_DIAMONDS,
        Sprite = eidCardSprite,
        Animation = "Misprinted 3 of Diamonds",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    DarkHole = {
        Shortcut = FiendFolio.ITEM.CARD.DARK_HOLE,
        Sprite = eidCardSprite,
        Animation = "Dark Hole",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    DestinyBoard = {
        Shortcut = FiendFolio.ITEM.CARD.DESTINY_BOARD,
        Sprite = eidCardSprite,
        Animation = "Destiny Board",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    Sorry = {
        Shortcut = FiendFolio.ITEM.CARD.SORRY,
        Sprite = eidCardSprite,
        Animation = "Sorry!",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    Stud = {
        Shortcut = FiendFolio.ITEM.CARD.STUD,
        Sprite = eidCardSprite,
        Animation = "Stud",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -5,
        TopOffset = -1
    },
    Stud2 = {
        Shortcut = FiendFolio.ITEM.CARD.STUD_2,
        Sprite = eidCardSprite,
        Animation = "Stud 2",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -5,
        TopOffset = -1
    },
    Stud3 = {
        Shortcut = FiendFolio.ITEM.CARD.STUD_3,
        Sprite = eidCardSprite,
        Animation = "Stud 3",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -5,
        TopOffset = -1
    },
    Stud4 = {
        Shortcut = FiendFolio.ITEM.CARD.STUD_4,
        Sprite = eidCardSprite,
        Animation = "Stud 4",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -5,
        TopOffset = -1
    },
    Stud5 = {
        Shortcut = FiendFolio.ITEM.CARD.STUD_5,
        Sprite = eidCardSprite,
        Animation = "Stud 5",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -5,
        TopOffset = -1
    },
    Stud6 = {
        Shortcut = FiendFolio.ITEM.CARD.STUD_6,
        Sprite = eidCardSprite,
        Animation = "Stud 6",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -5,
        TopOffset = -1
    },
    MisprintedGish = {
        Shortcut = FiendFolio.ITEM.CARD.MISPRINTED_GISH,
        Sprite = eidCardSprite,
        Animation = "Misprinted Gish",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    FriendlyFire = {
        Shortcut = FiendFolio.ITEM.CARD.FRIENDLY_FIRE,
        Sprite = eidCardSprite,
        Animation = "Friendly Fire",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    TheEyeofTruth = {
        Shortcut = FiendFolio.ITEM.CARD.EYE_OF_TRUTH,
        Sprite = eidCardSprite,
        Animation = "The Eye of Truth",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    HappySquirrel = {
        Shortcut = FiendFolio.ITEM.CARD.HAPPY_SQUIRREL,
        Sprite = eidCardSprite,
        Animation = "Happy Squirrel",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    TheInvisibleMoon = {
        Shortcut = FiendFolio.ITEM.CARD.THE_INVISIBLE_MOON,
        Sprite = eidCardSprite,
        Animation = "The Invisible Moon",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    NyanNekoQuizCard = {
        Shortcut = FiendFolio.ITEM.CARD.NEKO_NYAN_QUIZ_CARD,
        Sprite = eidCardSprite,
        Animation = "Nyan Neko Quiz Card",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    RedactedTriangle = {
        Shortcut = FiendFolio.ITEM.CARD.REDACTED_TRIANGLE,
        Sprite = eidCardSprite,
        Animation = "Redacted Triangle",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    D10Shard = {
        Shortcut = FiendFolio.ITEM.CARD.D10_SHARD,
        Sprite = eidCardSprite,
        Animation = "D10 Shard",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -5,
        TopOffset = -1
    },
    EternalShard = {
        Shortcut = FiendFolio.ITEM.CARD.ETERNAL_SHARD,
        Sprite = eidCardSprite,
        Animation = "Eternal Shard",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -5,
        TopOffset = -1
    },
    D8Shard = {
        Shortcut = FiendFolio.ITEM.CARD.D8_SHARD,
        Sprite = eidCardSprite,
        Animation = "D8 Shard",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -5,
        TopOffset = -1
    },
    PinkCow = {
        Shortcut = FiendFolio.ITEM.CARD.PINK_COW,
        Sprite = eidCardSprite,
        Animation = "Pink Cow",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -5,
        TopOffset = -1
    },
    YellowCar = {
        Shortcut = FiendFolio.ITEM.CARD.YELLOW_CAR,
        Sprite = eidCardSprite,
        Animation = "Yellow Car",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -5,
        TopOffset = -1
    },
    LuckyDuck = {
        Shortcut = FiendFolio.ITEM.CARD.LUCKY_DUCK,
        Sprite = eidCardSprite,
        Animation = "Lucky Duck",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -5,
        TopOffset = -1
    },
    ComicalRoundGlasses = {
        Shortcut = FiendFolio.ITEM.CARD.COMICAL_ROUND_GLASSES,
        Sprite = eidCardSprite,
        Animation = "Comical Round Glasses",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -5,
        TopOffset = -1
    },
    EggSack = {
        Shortcut = FiendFolio.ITEM.CARD.EGG_SACK,
        Sprite = eidCardSprite,
        Animation = "Egg Sack",
        Frame = -1,
        Width = 16,
        Height = 16,
        LeftOffset = -5,
        TopOffset = -1
    },
    AberrantLovers = {
        Shortcut = FiendFolio.ITEM.CARD.ABERRANT_LOVERS,
        Sprite = eidCardSprite,
        Animation = "Aberrant Lovers",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    AberrantDeath = {
        Shortcut = FiendFolio.ITEM.CARD.ABERRANT_DEATH,
        Sprite = eidCardSprite,
        Animation = "Aberrant Death",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    AberrantStars = {
        Shortcut = FiendFolio.ITEM.CARD.ABERRANT_STARS,
        Sprite = eidCardSprite,
        Animation = "Aberrant Stars",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    AberrantTower = {
        Shortcut = FiendFolio.ITEM.CARD.ABERRANT_TOWER,
        Sprite = eidCardSprite,
        Animation = "Aberrant Tower",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    AberrantMoon = {
        Shortcut = FiendFolio.ITEM.CARD.ABERRANT_MOON,
        Sprite = eidCardSprite,
        Animation = "Aberrant Moon",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    AberrantSun = {
        Shortcut = FiendFolio.ITEM.CARD.ABERRANT_SUN,
        Sprite = eidCardSprite,
        Animation = "Aberrant Sun",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    DraconicFervor = {
        Shortcut = FiendFolio.ITEM.CARD.DRACONIC_FERVOR,
        Sprite = eidCardSprite,
        Animation = "Draconic Fervor",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    TribunalofGoodandEvil = {
        Shortcut = FiendFolio.ITEM.CARD.TRIBUNAL_OF_GOOD_AND_EVIL,
        Sprite = eidCardSprite,
        Animation = "Tribunal of Good and Evil",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    DanceofUsurpation = {
        Shortcut = FiendFolio.ITEM.CARD.DANCE_OF_USURPATION,
        Sprite = eidCardSprite,
        Animation = "Dance of Usurpation",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    CreativeAI = {
        Shortcut = FiendFolio.ITEM.CARD.CREATIVE_AI,
        Sprite = eidCardSprite,
        Animation = "Creative A.I.",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    NeighboursFromHell = {
        Shortcut = FiendFolio.ITEM.CARD.NEIGHBOURS_FROM_HELL,
        Sprite = eidCardSprite,
        Animation = "Neighbours From Hell",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    Corruption = {
        Shortcut = FiendFolio.ITEM.CARD.CORRUPTION,
        Sprite = eidCardSprite,
        Animation = "Corruption",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    Blasphemy = {
        Shortcut = FiendFolio.ITEM.CARD.BLASPHEMY,
        Sprite = eidCardSprite,
        Animation = "Blasphemy",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    HauntedHouse = {
        Shortcut = FiendFolio.ITEM.CARD.HAUNTED_HOUSE,
        Sprite = eidCardSprite,
        Animation = "Haunted House",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    DireBond = {
        Shortcut = FiendFolio.ITEM.CARD.DIRE_BOND,
        Sprite = eidCardSprite,
        Animation = "Dire Bond",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
    ElfSong = {
        Shortcut = FiendFolio.ITEM.CARD.ELF_SONG,
        Sprite = eidCardSprite,
        Animation = "Elf Song",
        Frame = -1,
        Width = 8,
        Height = 10,
        LeftOffset = 0,
        TopOffset = 1
    },
}