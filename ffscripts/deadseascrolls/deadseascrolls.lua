local DSSModName = "Dead Sea Scrolls (Fiend Folio)"
local DSSCoreVersion = 7
local MenuProvider = {}
local game = Game()

-- Fiend Folio's menu code starts here!
function MenuProvider.SaveSaveData()
    FiendFolio.SaveSaveData()
end

function MenuProvider.GetPaletteSetting()
    return FiendFolio.savedata.MenuPalette
end

function MenuProvider.SavePaletteSetting(var)
    FiendFolio.savedata.MenuPalette = var
end

function MenuProvider.GetGamepadToggleSetting()
    return FiendFolio.savedata.MenuControllerToggle
end

function MenuProvider.SaveGamepadToggleSetting(var)
    FiendFolio.savedata.MenuControllerToggle = var
end

function MenuProvider.GetMenuKeybindSetting()
    return FiendFolio.savedata.MenuKeybind
end

function MenuProvider.SaveMenuKeybindSetting(var)
    FiendFolio.savedata.MenuKeybind = var
end

function MenuProvider.GetMenuHintSetting()
    return FiendFolio.savedata.MenuHint
end

function MenuProvider.SaveMenuHintSetting(var)
    FiendFolio.savedata.MenuHint = var
end

function MenuProvider.GetMenuBuzzerSetting()
    return FiendFolio.savedata.MenuBuzzer
end

function MenuProvider.SaveMenuBuzzerSetting(var)
    FiendFolio.savedata.MenuBuzzer = var
end

function MenuProvider.GetMenusNotified()
    return FiendFolio.savedata.MenusNotified
end

function MenuProvider.SaveMenusNotified(var)
    FiendFolio.savedata.MenusNotified = var
end

function MenuProvider.GetMenusPoppedUp()
    return FiendFolio.savedata.MenusPoppedUp
end

function MenuProvider.SaveMenusPoppedUp(var)
    FiendFolio.savedata.MenusPoppedUp = var
end

local DSSInitializerFunction = include("ffscripts.deadseascrolls.dssmenucore")
local dssmod = DSSInitializerFunction(DSSModName, DSSCoreVersion, MenuProvider)

local NOTE1_RENDER_OFFSET = Vector(-116, -27)
local NOTE2_RENDER_OFFSET = Vector(-32, -27)
local NOTE3_RENDER_OFFSET = Vector(-74, -27)

local completionNoteSprite = Sprite()
completionNoteSprite:Load("gfx/ui/completion_widget.anm2")
completionNoteSprite:SetFrame("Idle", 0)
--completionNoteSprite.Scale = Vector.One / 2

local completionHead = Sprite()
completionHead:Load("gfx/ui/completion_heads_ff.anm2")
completionHead:SetFrame("Fiend", 0)

local completionDoor = Sprite()
completionDoor:Load("gfx/ui/completion_doors_ff.anm2")
completionDoor:SetFrame("Fiend", 0)

local completionCharacterSets = {
    {
        {HeadName = "Fiend", PlayerID = FiendFolio.PLAYER.FIEND, IsUnlocked = function() return FiendFolio.ACHIEVEMENT.FIEND:IsUnlocked() end},
        {HeadName = "Biend", PlayerID = FiendFolio.PLAYER.BIEND, IsUnlocked = function() return FiendFolio.ACHIEVEMENT.BIEND:IsUnlocked() end},
    },
    {
        {HeadName = "Golem", PlayerID = FiendFolio.PLAYER.GOLEM, IsUnlocked = function() return FiendFolio.ACHIEVEMENT.GOLEM:IsUnlocked() end},
        {HeadName = "Bolem", PlayerID = FiendFolio.PLAYER.BOLEM, IsUnlocked = function() return FiendFolio.ACHIEVEMENT.BOLEM:IsUnlocked() end},
    },
    {
        {HeadName = "Friend", PlayerID = FiendFolio.PLAYER.FRIEND, IsUnlocked = function() return FiendFolio.ACHIEVEMENT.FRIEND:IsUnlocked() end},
        {HeadName = "Briend", PlayerID = FiendFolio.PLAYER.BRIEND, IsUnlocked = function() return FiendFolio.ACHIEVEMENT.BRIEND:IsUnlocked() end},
    },
    {
        {HeadName = "Inaba", PlayerID = FiendFolio.PLAYER.INABA, IsUnlocked = function() return FiendFolio.ACHIEVEMENT.INABA:IsUnlocked(true) end},
        {HeadName = "Binaba", PlayerID = FiendFolio.PLAYER.BINABA, IsUnlocked = function() return FiendFolio.ACHIEVEMENT.BINABA:IsUnlocked() end},
    },
    {
        {HeadName = "The Skeletal Fiend", PlayerID = FiendFolio.PLAYER.SKELETAL_FIEND, IsUnlocked = function() return (Epiphany and Epiphany.API and FiendFolio.ACHIEVEMENT.SKELETALFIEND:IsUnlocked()) end},
    },
}

-- Sorry I need these here too for the note rendering!
local function getScreenBottomRight()
    return game:GetRoom():GetRenderSurfaceTopLeft() * 2 + Vector(442,286)
end

local function getScreenCenterPosition()
    return getScreenBottomRight() / 2
end

local completionNoteTip = {strset = {"press confirm", "to edit your", "completion", "note"}}
local areYouSureUnlockTag
local isUnlockingAll

local jokeCharacterTooltip = {}
local jokeCharacterSprite = Sprite()
jokeCharacterSprite:Load("gfx/enemies/peat/the seal has been broken.anm2", true)
jokeCharacterSprite:Play("Idle", true)

local function setJokeCharacterTooltip(setting)
	if setting <= 9 then
		jokeCharacterTooltip.strset = {'the good', 'characters'}
	elseif setting == 10 then
		jokeCharacterTooltip.strset = {'the good', 'characters?'}
	elseif setting == 11 then
		jokeCharacterTooltip.strset = {'huh?'}
	elseif setting == 12 then
		jokeCharacterTooltip.strset = {'what are', 'you doing?'}
	elseif setting == 13 then
		jokeCharacterTooltip.strset = {'you already', 'enabled', 'the joke', 'characters'}
	elseif setting == 14 then
		jokeCharacterTooltip.strset = {'i mean', 'the good', 'characters'}
	elseif setting == 15 then
		jokeCharacterTooltip.strset = {'that\'s it'}
	elseif setting == 16 then
		jokeCharacterTooltip.strset = {'that\'s the', 'whole point', 'of this', 'setting'}
	elseif setting == 17 then
		jokeCharacterTooltip.strset = {'you can', 'go back', 'now'}
	elseif setting == 18 then
		jokeCharacterTooltip.strset = {'you can', 'play the', 'game now'}
	elseif setting == 19 then
		jokeCharacterTooltip.strset = {'the imp gang', 'is waiting'}
	elseif setting == 20 then
		jokeCharacterTooltip.strset = {'go try', 'them out'}
	elseif setting <= 40 then
		jokeCharacterTooltip.strset = {'the good', 'characters'}
	elseif setting == 41 then
		jokeCharacterTooltip.strset = {'ummm...'}
	elseif setting == 42 then
		jokeCharacterTooltip.strset = {'why are you', 'still here?'}
	elseif setting == 43 then
		jokeCharacterTooltip.strset = {'you already', 'turned this', 'setting on'}
	elseif setting == 44 then
		jokeCharacterTooltip.strset = {'did it', 'not work', 'or something?'}
	elseif setting == 45 then
		jokeCharacterTooltip.strset = {'it should be', 'working'}
	elseif setting == 46 then
		jokeCharacterTooltip.strset = {'lemme check', 'real quick'}
	elseif setting <= 58 then
		jokeCharacterTooltip.strset = {'...'}
	elseif setting == 59 then
		jokeCharacterTooltip.strset = {'yeah,', 'it\'s definitely', 'working'}
	elseif setting == 60 then
		jokeCharacterTooltip.strset = {'good of you', 'to check'}
	elseif setting <= 100 then
		jokeCharacterTooltip.strset = {'the good', 'characters'}
	elseif setting == 101 then
		jokeCharacterTooltip.strset = {'okay'}
	elseif setting == 102 then
		jokeCharacterTooltip.strset = {'what are we', 'doing here?'}
	elseif setting == 103 then
		jokeCharacterTooltip.strset = {'this is', 'just an', 'options menu'}
	elseif setting == 104 then
		jokeCharacterTooltip.strset = {'it\'s not', 'that deep'}
	elseif setting == 105 then
		jokeCharacterTooltip.strset = {'i already', 'checked that', 'it\'s working'}
	elseif setting == 106 then
		jokeCharacterTooltip.strset = {'you can', 'go back', 'now'}
	elseif setting <= 200 then
		jokeCharacterTooltip.strset = {'the good', 'characters'}
	elseif setting == 201 then
		jokeCharacterTooltip.strset = {'why'}
	elseif setting == 202 then
		jokeCharacterTooltip.strset = {'why do', 'you keep', 'scrolling?'}
	elseif setting == 203 then
		jokeCharacterTooltip.strset = {'boredom?'}
	elseif setting == 204 then
		jokeCharacterTooltip.strset = {'escapism?'}
	elseif setting == 205 then
		jokeCharacterTooltip.strset = {'the love of', 'the game?'}
	elseif setting == 206 then
		jokeCharacterTooltip.strset = {'i dunno'}
	elseif setting == 207 then
		jokeCharacterTooltip.strset = {'but that\'s', 'enough'}
	elseif setting <= 400 then
		jokeCharacterTooltip.strset = {'the good', 'characters'}
	elseif setting == 401 then
		jokeCharacterTooltip.strset = {'c\'mon man'}
	elseif setting == 402 then
		jokeCharacterTooltip.strset = {'there\'s', 'nothing here,', 'y\'know?'}
	elseif setting == 403 then
		jokeCharacterTooltip.strset = {'don\'t you got', 'something', 'better to do?'}
	elseif setting == 404 then
		jokeCharacterTooltip.strset = {'did you', 'even try', 'the joke', 'characters?'}
	elseif setting == 405 then
		jokeCharacterTooltip.strset = {'i mean', 'the good', 'characters'}
	elseif setting == 406 then
		jokeCharacterTooltip.strset = {'yeah,', 'i can make', 'the same', 'joke twice'}
	elseif setting == 407 then
		jokeCharacterTooltip.strset = {'seriously', 'though,', 'you aren\'t', 'accomplishing', 'anything', 'right now'}
	elseif setting == 408 then
		jokeCharacterTooltip.strset = {'you\'re wasting', 'your time'}
	elseif setting == 409 then
		jokeCharacterTooltip.strset = {'and mine'}
	elseif setting == 410 then
		jokeCharacterTooltip.strset = {'go play the', 'game already'}
	elseif setting <= 500 then
		jokeCharacterTooltip.strset = {'the good', 'characters'}
	elseif setting == 501 then
		jokeCharacterTooltip.strset = {'are you okay?'}
	elseif setting == 502 then
		jokeCharacterTooltip.strset = {'you\'ve', 'scrolled', 'through like', '500', 'of these now'}
	elseif setting == 503 then
		jokeCharacterTooltip.strset = {'you can', 'stop now'}
	elseif setting == 504 then
		jokeCharacterTooltip.strset = {'did you', 'not like', 'the joke', 'characters?'}
	elseif setting == 505 then
		jokeCharacterTooltip.strset = {'i\'m not', 'making the', 'same joke', 'a third', 'time'}
	elseif setting == 506 then
		jokeCharacterTooltip.strset = {'but i', 'thought they', 'were cool'}
	elseif setting == 507 then
		jokeCharacterTooltip.strset = {'we worked', 'real hard on', 'them'}
	elseif setting == 508 then
		jokeCharacterTooltip.strset = {'just go', 'try them', 'out'}
	elseif setting <= 700 then
		jokeCharacterTooltip.strset = {'the good', 'characters'}
	elseif setting == 701 then
		jokeCharacterTooltip.strset = {'alright that\'s', 'enough'}
	elseif setting == 702 then
		jokeCharacterTooltip.strset = {'if you', 'keep going', 'there will be', 'consequences'}
	elseif setting == 703 then
		jokeCharacterTooltip.strset = {'y\'know what?'}
	elseif setting == 704 then
		jokeCharacterTooltip.strset = {'fine'}
	elseif setting == 705 then
		jokeCharacterTooltip.strset = {'no more', 'joke', 'characters'}
	elseif setting == 706 then
		jokeCharacterTooltip.strset = {'how do', 'you like', 'that?'}
	elseif setting == 707 then
		jokeCharacterTooltip.strset = {'consider this', 'a warning'}
	elseif setting == 708 then
		jokeCharacterTooltip.strset = {'i can do', 'so much', 'worse'}
	elseif setting <= 900 then
		jokeCharacterTooltip.strset = {'...'}
	elseif setting == 901 then
		jokeCharacterTooltip.strset = {'please'}
	elseif setting == 902 then
		jokeCharacterTooltip.strset = {'please stop'}
	elseif setting == 903 then
		jokeCharacterTooltip.strset = {'you don\'t', 'know what', 'you\'re doing'}
	elseif setting == 904 then
		jokeCharacterTooltip.strset = {'you don\'t', 'know what', 'you\'re', 'unleashing'}
	elseif setting == 905 then
		jokeCharacterTooltip.strset = {'nobody', 'deserves', 'this...'}
	elseif setting <= 950 then
		jokeCharacterTooltip.strset = {'...'}
	elseif setting == 951 then
		jokeCharacterTooltip.strset = {'why are you', 'doing this'}
	elseif setting == 952 then
		jokeCharacterTooltip.strset = {'don\'t do', 'this'}
	elseif setting == 953 then
		jokeCharacterTooltip.strset = {'the seal', 'is weakening'}
	elseif setting == 954 then
		jokeCharacterTooltip.strset = {'i can', 'already hear', 'his infernal', 'hymn'}
	elseif setting == 955 then
		jokeCharacterTooltip.strset = {'just go back...'}
	elseif setting <= 983 then
		jokeCharacterTooltip.strset = {'...'}
	elseif setting == 984 then
		jokeCharacterTooltip.strset = {'it seems', 'today'}
	elseif setting == 985 then
		jokeCharacterTooltip.strset = {'that all', 'you see'}
	elseif setting == 986 then
		jokeCharacterTooltip.strset = {'is violence', 'in movies'}
	elseif setting == 987 then
		jokeCharacterTooltip.strset = {'and sex', 'on tv'}
	elseif setting == 988 then
		jokeCharacterTooltip.strset = {'but where', 'are those'}
	elseif setting == 989 then
		jokeCharacterTooltip.strset = {'good', 'old-fashioned', 'values'}
	elseif setting == 990 then
		jokeCharacterTooltip.strset = {'on which', 'we used to', 'rely?'}
	elseif setting == 991 then
		jokeCharacterTooltip.strset = {'lucky', 'there\'s a', 'family guy'}
	elseif setting == 992 then
		jokeCharacterTooltip.strset = {'lucky', 'there\'s a', 'man who'}
	elseif setting == 993 then
		jokeCharacterTooltip.strset = {'positively', 'can do'}
	elseif setting == 994 then
		jokeCharacterTooltip.strset = {'all the', 'things that', 'make us'}
	elseif setting == 995 then
		jokeCharacterTooltip.strset = {'laugh and', 'cry'}
	elseif setting == 996 then
		jokeCharacterTooltip.strset = {'he\'s'}
	elseif setting == 997 then
		jokeCharacterTooltip.strset = {'a'}
	elseif setting == 998 then
		jokeCharacterTooltip.strset = {'family'}
	elseif setting == 999 then
		jokeCharacterTooltip.strset = {'guuuuuuuuuuuy'}
	elseif setting == 1000 then
		jokeCharacterTooltip.strset = nil
	end

	if setting < 1000 then
		jokeCharacterTooltip.spr = nil
		jokeCharacterTooltip.pos = nil
	else
		jokeCharacterTooltip.spr = {sprite = jokeCharacterSprite, width = 50, height = 26, scale = Vector(2,2)}
		jokeCharacterTooltip.pos = Vector(0,12)
	end
end
local jokeCharacterChoices = {}
for i = 1, 1000 do
	if i == 1 then
		jokeCharacterChoices[i] = 'off'
	elseif i < 44 then
		jokeCharacterChoices[i] = 'on'
	elseif i < 59 then
		jokeCharacterChoices[i] = 'on?'
	elseif i < 705 then
		jokeCharacterChoices[i] = 'on'
	elseif i < 801 then
		jokeCharacterChoices[i] = 'off'
	elseif i < 851 then
		jokeCharacterChoices[i] = 'off...'
	elseif i < 1000 then
		jokeCharacterChoices[i] = '...'
	else
		jokeCharacterChoices[i] = 'all'
	end
end


--[[local fortuneDSSSprite = Sprite()
fortuneDSSSprite:Load("gfx/ui/ui_fortunepaper.anm2", true)
fortuneDSSSprite:SetFrame("Text3", 20)]]

local fiendfoliodirectory = {
    main = {
        title = 'fiend folio',
        buttons = {
            {str = 'resume game', action = 'resume'},
            {str = 'settings', dest = 'settings'},
            {str = "unlocks", dest = "unlocks", cursoroff = Vector(6, 0)},
			{str = 'credits', dest = 'awesomecredits'},
            dssmod.changelogsButton,
            {str = '', fsize = 2, nosel = true},
            {str = 'check out the', fsize = 2, nosel = true},
            {str = 'mod compatibility page', fsize = 2, nosel = true},
            {str = 'at fiendfolio.wiki.gg', fsize = 2, nosel = true},
            {str = 'for extra compatible mods! ', fsize = 2, nosel = true},
            {str = '', fsize = 2, nosel = true},
            {str = '', fsize = 2, nosel = true}
        },
        tooltip = dssmod.menuOpenToolTip
    },
    settings = {
        title = 'settings',
        buttons = {
            dssmod.gamepadToggleButton,
            dssmod.menuKeybindButton,

            {
                str = 'general',
                dest = "settingsGeneral",
            },
            {
                str = 'uncategorized settings',
                fsize = 2,
                nosel = true
            },
            {str = '', fsize = 2, nosel = true},

            {
                str = 'characters',
                dest = "settingsCharacters",
            },
            {
                strset = {'configure our new', 'characters'},
                fsize = 2,
                nosel = true
            },
            {str = '', fsize = 2, nosel = true},

            {
                str = 'items',
                dest = 'settingsItems',
            },
            {strset = {'settings related', 'to items'}, fsize = 2, nosel = true},
            {str = '', fsize = 2, nosel = true},

            {
                str = 'hud',
                dest = "settingsHud",
            },
            {
                strset = {'change how the', 'hud appears'},
                fsize = 2,
                nosel = true
            },
            {str = '', fsize = 2, nosel = true},

            {
                str = 'wackies',
                dest = "settingsWackies",
            },
            {
                str = 'the real important stuff',
                fsize = 2,
                nosel = true
            },
            {
                str = '(not really)',
                fsize = 1,
                nosel = true,
            },
            {str = '', fsize = 2, nosel = true},
        },
        tooltip = dssmod.menuOpenToolTip
    },
    settingsCharacters = {
        title = "settings - chrs.",
        buttons = {
            {str = "-----------------", fsize = 3, nosel = true},
            {str = "", fsize = 1, nosel = true},
            {str = "friend", fsize = 3, nosel = true},
            {str = "", nosel = true},
            {
                str = 'friend aiming',
                choices = {'vanilla', 'full control'},
                variable = 'MouseGunAiming',
                setting = 0,
                load = function()
                    return FiendFolio.MouseGunAiming + 1
                end,
                store = function(var)
                    FiendFolio.MouseGunAiming = var - 1
                end,
                tooltip = {strset = {'full control', 'allows', 'shooting', 'in any', 'direction', ' ', 'full control', 'is default'}}
            },
            {
                str = '',
                fsize = 2,
                nosel = true
            },
            {str = "-----------------", fsize = 3, nosel = true},
            {str = "", fsize = 1, nosel = true},
            {str = "bonus characters", fsize = 3, nosel = true},
            {str = "", nosel = true},
            {
                str = 'challenges',
                choices = {'off', 'slippy, china and craig', 'classic fiend too', 'all'},
                variable = 'BonusCharacters',
                setting = 0,
                load = function()
                    return FiendFolio.BonusCharacters + 1
                end,
                store = function(var)
                    FiendFolio.BonusCharacters = var - 1
                end,
                tooltip = {strset = {'allows', 'challenge', 'characters', 'on the', 'main menu', 'after beating', 'their', 'challenge'}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = 'jokes',
                choices = jokeCharacterChoices,
                variable = 'JokeCharacters',
                setting = 0,
                load = function()
					setJokeCharacterTooltip(FiendFolio.JokeCharacters + 1)
                    return FiendFolio.JokeCharacters + 1
                end,
                store = function(var)
                    FiendFolio.JokeCharacters = var - 1
                end,
				changefunc = function(button, item)
					setJokeCharacterTooltip(button.setting)
				end,
                tooltip = jokeCharacterTooltip,
            },
            {
                str = '',
                fsize = 2,
                nosel = true
            },
            {
                str = 'go back',
                fsize = 2,
                action = 'back'
            },
        },
        tooltip = dssmod.menuOpenToolTip,
    },
    settingsGeneral = {
        title = "settings - general",
        buttons = {
            {
                str = 'mouse controls',
                choices = {'enabled', 'disabled'},
                variable = "MouseControls",
                cursoroff = Vector(6, 0),
                setting = 1,
                load = function()
                    if Options.MouseControl then
                        return 1
                    else
                        return 2
                    end
                end,
                store = function(var)
                    Options.MouseControl = (var == 1)
                end,
                changefunc = function(button)
                    Options.MouseControl = (button.setting == 1)
                end,
                tooltip = {strset = {'if enabled', 'you can shoot', 'with the mouse!', ' ', 'vanilla option', ' ', 'disabled by', 'default'}}
            },
            {
                str = 'random enemies',
                choices = {'folio replacements', 'all replacements', 'vanilla only', 'all disabled'},
                variable = 'FolioReplacements',
                setting = 1,
                load = function()
                    if FiendFolio.replacementsEnabled and not FiendFolio.legacyReplacementsEnabled then
                        return 1
                    elseif FiendFolio.replacementsEnabled and FiendFolio.legacyReplacementsEnabled then
                        return 2
                    elseif FiendFolio.legacyReplacementsEnabled then
                        return 3
                    else
                        return 4
                    end
                end,
                store = function(var)
                    FiendFolio.replacementsEnabled = (var == 1 or var == 2)
                    FiendFolio.legacyReplacementsEnabled = (var == 2 or var == 3)
                end,
                tooltip = {strset = {'configure', 'random enemy', 'replacement', ' ', 'folio mode', 'is default'}}
            },
            --[[{
                str = 'colour blind fix',
                choices = {'enabled', 'disabled'},
                variable = "ColourBlindMode",
                setting = 2,
                load = function()
                    if FiendFolio.ColourBlindMode then
                        return 1
                    else
                        return 2
                    end
                end,
                store = function(var)
                    FiendFolio.ColourBlindMode = (var == 1)
                end,
                tooltip = {strset = {'if enabled', 'green puzzle', 'blocks', 'become', 'yellow', 'with higher', 'brightness'}}
            },]]
			{
                str = 'vanilla ai changes',
                choices = {'enabled', 'disabled'},
                variable = "ChangeAi",
                cursoroff = Vector(6, 0),
                setting = 1,
                load = function()
                    if FiendFolio.ChangeAi then
                        return 1
                    else
                        return 2
                    end
                end,
                store = function(var)
                    FiendFolio.ChangeAi = (var == 1)
                end,
                tooltip = {strset = {'if enabled', 'some basegame', "enemies will", 'be modified', ' ', 'enabled by', 'default'}}
            },
            {
                str = 'custom curses',
                choices = {'enabled', 'disabled'},
                variable = "CustomCurses",
                setting = 1,
                load = function()
                    if FiendFolio.CustomCursesEnabled then
                        return 1
                    else
                        return 2
                    end
                end,
                store = function(var)
                    FiendFolio.CustomCursesEnabled = (var == 1)
                end,
                tooltip = {strset = {'if enabled', 'allows', 'ff curses', 'to appear', '', '(enabled by', 'default,', 'takes effect', 'next floor)'}}
            },
			{
                str = 'custom fortunes',
                choices = {'enabled', 'disabled'},
                variable = "CustomFortunes",
                setting = 1,
                load = function()
                    if FiendFolio.CustomFortunesEnabled then
                        return 1
                    else
                        return 2
                    end
                end,
                store = function(var)
                    FiendFolio.CustomFortunesEnabled = (var == 1)
                end,
                tooltip = {strset = {'if enabled', 'there will be', 'increased', 'fortune', 'variety', '', 'enabled by', 'default'}}
            },
            {
                str = 'new poop spells',
                choices = {'enabled', 'disabled'},
                variable = "WackyPoops",
                setting = 1,
                load = function()
                    if FiendFolio.WackyPoopsEnabled then
                        return 1
                    else
                        return 2
                    end
                end,
                store = function(var)
                    FiendFolio.WackyPoopsEnabled = (var == 1)
                end,
                tooltip = {strset = {'custom poops','for tainted', 'blue baby', '(changes', 'applied', 'on relaunch)', '', 'enabled by', 'default'}}
            },
            {
                str = 'custom music',
                choices = {'enabled', 'disabled'},
                variable = "CustomMusic",
                setting = 1,
                load = function()
                    if FiendFolio.CustomMusicEnabled then
                        return 1
                    else
                        return 2
                    end
                end,
                store = function(var)
                    FiendFolio.CustomMusicEnabled = (var == 1)
                end,
                tooltip = {strset = {'custom music', 'for bosses,', 'crawlspaces,', 'etc.', '', 'enabled by', 'default'}}
            },
            {str = '', fsize = 2, nosel = true},
			{
                str = 'taunt hotkeys',
                choices = {'enabled', 'disabled'},
                variable = "HotkeyConfig.Taunts",
                setting = 1,
                load = function()
                    if FiendFolio.HotkeyConfig.Taunts then
                        return 1
                    else
                        return 2
                    end
                end,
                store = function(var)
                    FiendFolio.HotkeyConfig.Taunts = (var == 1)
                end,
                tooltip = {strset = {'if enabled', 'you can press ', '+ and -', 'to taunt!', '',  'enabled by', 'default'}}
            },
			{
                str = 'killbind hotkeys',
                choices = {'enabled', 'disabled'},
                variable = "HotkeyConfig.Killbinds",
                setting = 1,
                load = function()
                    if FiendFolio.HotkeyConfig.Killbinds then
                        return 1
                    else
                        return 2
                    end
                end,
                store = function(var)
                    FiendFolio.HotkeyConfig.Killbinds = (var == 1)
                end,
                tooltip = {strset = {'if enabled', 'you can press ', 'end and del', 'to die!', '',  'disabled by', 'default'}}
            },
			{
                str = 'double-tap drop',
                choices = {'enabled', 'disabled'},
                variable = "DoubleTapDrop",
                setting = 1,
                load = function()
                    if FiendFolio.DoubleTapDrop then
                        return 1
                    else
                        return 2
                    end
                end,
                store = function(var)
                    FiendFolio.DoubleTapDrop = (var == 1)
                end,
                tooltip = {strset = {'if enabled', 'double-tap to', 'to drop cards', 'and trinkets', 'much faster', ' ', 'enabled by', 'default'}}
            },
            {str = '', fsize = 2, nosel = true},
            {
                str = 'ff boss weight',
                choices = {'default (raised)', 'unraised', 'unraised (custom)'},
                variable = "BossWeightMode",
                load = function()
                    return FiendFolio.savedata.bossWeightMode or 1
                end,
                store = function(var)
                    FiendFolio.savedata.bossWeightMode = var
                    FiendFolio.ReloadBossWeights()
                end,
                tooltip = {strset = {'decides how', 'often our', 'bosses appear', 'relative to', 'vanilla ones'}},
            },
            {
                str = 'weight cutoff',
                choices = {'basement', 'caves', 'depths', 'womb'},
                variable = "BossWeightCutoff",
                load = function()
                    return FiendFolio.savedata.bossWeightCutoff or 1
                end,
                store = function(var)
                    FiendFolio.savedata.bossWeightCutoff = var
                    FiendFolio.ReloadBossWeights()
                end,
                displayif = function(_, item)
                    if item and item.buttons then
                        for _, button in ipairs(item.buttons) do
                            if button.str == 'ff boss weight' then
                                return button.setting == 3
                            end
                        end
                    end

                    return false
                end,
                tooltip = {strset = {'our bosses', 'appear a bit', 'more often', 'than vanilla', 'bosses after', 'this floor'}}
            },
            {
                str = 'boss pool rework',
                choices = {'enabled', 'disabled'},
                variable = "BossPoolOverhaul",
                cursoroff = Vector(6, 0),
                load = function()
                    if FiendFolio.BossPoolOverhaulEnabled then
                        return 1
                    else
                        return 2
                    end
                end,
                store = function(var)
                    FiendFolio.BossPoolOverhaulEnabled = (var == 1)
                end,
                tooltip = {strset = {'reworks', 'boss pools', 'for some', 'floors to', 'be more', 'unique', '', 'enabled by', 'default'}}
            },
            {
                str = 'force ff bosses',
                choices = {'enabled', 'disabled'},
                variable = "ForcingFiendFolioBosses",
                load = function()
                    if FiendFolio.ForcingFiendFolioBosses then
                        return 1
                    else
                        return 2
                    end
                end,
                store = function(var)
                    FiendFolio.ForcingFiendFolioBosses = (var == 1)
                end,
                tooltip = {strset = {'tries to', 'force bosses', 'from fiend', 'folio to', 'always spawn'}}
            },
            {str = '', fsize = 2, nosel = true},
            {
                str = 'reduced frights',
                choices = {'on (sry if we scared u <3)', 'disabled'},
                variable = "ReducedFrights",
                cursoroff = Vector(6, 0),
                load = function()
                    if FiendFolio.ReducedFrights then
                        return 1
                    else
                        return 2
                    end
                end,
                store = function(var)
                    FiendFolio.ReducedFrights = (var == 1)
                end,
                tooltip = {strset = {"the mod has", "no jumpscares,", "this just makes ", "some things", "less freaky", "", 'disabled by', 'default'}}
            },
            dssmod.paletteButton,
            {
                str = '',
                fsize = 2,
                nosel = true
            },
            {
                str = 'go back',
                fsize = 2,
                action = 'back'
            },
        },
        tooltip = dssmod.menuOpenToolTip,

    },
    settingsHud = {
        title = "settings - hud",
        buttons = {
            {
                str = 'extra portraits',
                choices = {'disabled', 'enabled'},
                variable = "ExtraVsPortraits",
                setting = 3,
                load = function()
                    return FiendFolio.ExtraVsPortraits + 1
                end,
                store = function(var)
                    FiendFolio.ExtraVsPortraits = var - 1
                end,
                tooltip = {strset = {'fiend and', 'golem will', 'have unique', 'vs screen', 'portraits'}}
            },
            {
                str = 'name tags',
                choices = {'disabled', 'always', 'toggle'},
                variable = "NameTags",
                setting = 3,
                load = function()
                    return FiendFolio.NameTags + 1
                end,
                store = function(var)
                    FiendFolio.NameTags = var - 1
                end,
                tooltip = {strset = {'if enabled', 'fiend folio', 'enemies will', 'have', 'name tags'}}
            },
            {
                str = 'name tag keybind',
                tooltip = {strset = {'sets', 'which key', 'will toggle', 'name tags'}},
                variable = "NameTagKeybind",
                setting = -1,
                keybind = true,
                load = function()
                    return FiendFolio.NameTagKeybind or -1
                end,
                store = function(var)
                    FiendFolio.NameTagKeybind = var
                end,
                displayif = function(_, item)
                    if item and item.buttons then
                        for _, button in ipairs(item.buttons) do
                            if button.str == 'name tags' then
                                return button.setting == 3
                            end
                        end
                    end

                    return false
                end,
            },
            {
                str = 'show room names',
                choices = {'always', 'temporary', 'disabled', 'with map', 'voice acting'},
                variable = "ShowRoomNames",
                setting = 1,
                load = function()
                    return FiendFolio.ShowRoomNames
                end,
                store = function(var)
                    FiendFolio.ShowRoomNames = var
                end,
                tooltip = {strset = {'enable to', 'know', 'who to blame', 'for that', 'unfair room'}}
            },
            {
                str = 'room name alpha',
                increment = 1, max = 9,
                variable = "RoomNameOpacity",
                slider = true,
                setting = 1,
                load = function()
                    return FiendFolio.RoomNameOpacity
                end,
                store = function(var)
                    FiendFolio.RoomNameOpacity = var
                end,
                displayif = function(_, item)
                    if item and item.buttons then
                        for _, button in ipairs(item.buttons) do
                            if button.str == 'show room names' then
                                return button.setting ~= 3 and button.setting ~= 5
                            end
                        end
                    end

                    return false
                end
            },
            {
                str = 'room name scale',
                choices = {'big', 'small', 'force small', 'fit'},
                variable = "RoomNameScale",
                setting = 1,
                load = function()
                    return FiendFolio.RoomNameScale
                end,
                store = function(var)
                    FiendFolio.RoomNameScale = var
                end,
                displayif = function(_, item)
                    if item and item.buttons then
                        for _, button in ipairs(item.buttons) do
                            if button.str == 'show room names' then
                                return button.setting ~= 3 and button.setting ~= 5
                            end
                        end
                    end

                    return false
                end
            },
            {
                str = 'extra charge bar',
                choices = {'4 max', 'endless'},
                variable = "ExtraChargeBar",
                setting = 0,
                load = function()
                    return FiendFolio.ExtraChargeBar + 1
                end,
                store = function(var)
                    FiendFolio.ExtraChargeBar = var - 1
                end,
                tooltip = {strset = {'sets max charge', 'bars visible'}}
            },
            {
                str = 'fortune opacity',
                increment = 1, max = 10,
                variable = "FortunePaperOpacity",
                slider = true,
                setting = 1,
                load = function()
                    return FiendFolio.FortunePaperOpacity
                end,
                store = function(var)
                    FiendFolio.FortunePaperOpacity = var
                end,
                changefunc = function(button)
                    FiendFolio.FortunePaperOpacity = button.setting
                end,
                tooltip = {strset = {'lets cowards', 'turn down the ', 'opacity of', 'fortune paper ', ' ', 'at the maximum ', 'is default'}}
            },
            {str = '', fsize = 2, nosel = true,
            displayif = function()
                return Options.MouseControl
            end
            },
            {
                str = 'cursor settings',
                dest = "settingsCursor",
                displayif = function()
                    return Options.MouseControl
                end
            },
            {
                strset = {'change how the', 'cursor appears'},
                fsize = 2,
                nosel = true,
                displayif = function()
                    return Options.MouseControl
                end
            },
            {
                str = '',
                fsize = 2,
                nosel = true
            },
            {
                str = 'go back',
                fsize = 2,
                action = 'back'
            },
        },
        tooltip = dssmod.menuOpenToolTip,
    },
    settingsCursor = {
        title = "settings - hud",
        buttons = {
            {
                str = "cursor gfx",
                choices = {},
                variable = "CursorOptionsVisual",
                setting = 1,

                load = function()
                    return FiendFolio.CursorOptionsVisual
                end,
                store = function(var)
                    FiendFolio.CursorOptionsVisual = var
                    FiendFolio:UpdateCursorVisuals()
                end,
                changefunc = function(button)
                    FiendFolio.CursorOptionsVisual = button.setting
                    FiendFolio:UpdateCursorVisuals()
                end,

                tooltip = {
                    spr = {sprite = Isaac.GetCursorSprite(), width = 16, height = 16, scale = Isaac.GetCursorSprite().Scale},
                    pos = Vector.Zero,
                },
            },
            {
                str = "cursor scale",
                choices = {"0.5x", "1x", "2x"},
                variable = "CursorOptionsScale",
                setting = 2,

                load = function()
                    return FiendFolio.CursorOptionsScale
                end,
                store = function(var)
                    FiendFolio.CursorOptionsScale = var
                    FiendFolio:UpdateCursorVisuals()
                end,
                changefunc = function(button)
                    FiendFolio.CursorOptionsScale = button.setting
                    FiendFolio:UpdateCursorVisuals()
                end,
                tooltip = {
                    spr = {sprite = Isaac.GetCursorSprite(), width = 16, height = 16, scale = Isaac.GetCursorSprite().Scale},
                    pos = Vector.Zero,
                },
            },
            {
                str = "randomiser",
                choices = {"on", "off"},
                variable = "CursorOptionsRandomizer",
                setting = 2,

                load = function()
                    return FiendFolio.CursorOptionsRandomizer and 1 or 2
                end,
                store = function(var)
                    FiendFolio.CursorOptionsRandomizer = (var == 1)
                end,

                tooltip = {strset = {"should cursor", "gfx randomise", "each room"}}
            },
            {
                str = '',
                fsize = 2,
                nosel = true
            },
            {
                str = 'go back',
                fsize = 2,
                action = 'back'
            },
        },
        tooltip = dssmod.menuOpenToolTip,
    },
    settingsWackies = {
        title = "settings - wackies",
        buttons = {
            {
                str = 'great fortune',
                choices = {'enabled', 'disabled'},
                variable = "GreatFortune",
                setting = 2,
                load = function()
                    if FiendFolio.GreatFortune then
                        return 1
                    else
                        return 2
                    end
                end,
                store = function(var)
                    FiendFolio.GreatFortune = (var == 1)
                end,
                tooltip = {strset = {'enable to', 'learn', 'your fortune', 'when firing', 'tears'}}
            },
            {
                str = 'folio mode',
                choices = {'classic', 'mern', 'super easy', 'stable', 'popo modo'},
                variable = "FolioMode",
                setting = 1,
                load = function()
                    return FiendFolio.ModeEnabled + 1
                end,
                store = function(var)
                    FiendFolio.ModeEnabled = var - 1
                end,
                tooltip = {strset = {'change', 'to enable', 'wacky new', 'modes of', 'play', "", "classic", "by default"}}
            },
            {
                str = 'gated bosses',
                choices = {'enabled', 'disabled'},
                variable = "GatedBosses",
                setting = 2,
                load = function()
                    if FiendFolio.GatedBosses then
                        return 1
                    else
                        return 2
                    end
                end,
                store = function(var)
                    FiendFolio.GatedBosses = (var == 1)
                end,
                tooltip = {strset = {'boss rooms', 'require', 'special keys', 'to unlock', '', '(takes effect', 'next floor)'}}
            },
            {
                str = 'waterstro name',
                choices = {'monsoon', 'moistro', 'jack the dripper', 'j.m. the dripper', 'j.m. the m.d.', 'random'},
                variable = "MonsoonName",
                setting = 1,
                load = function()
                    return FiendFolio.MonsoonName or 1
                end,
                store = function(var)
                    FiendFolio.MonsoonName = var
                end,
                changefunc = function(button)
                    FiendFolio.MonsoonName = button.setting
                    local monsoonData = StageAPI.GetBossData("Moistro")

                    if FiendFolio.MonsoonName == 6 then
                        monsoonData.Bossname = FiendFolio.MonsoonNames[math.random(1, 5)]
                    else
                        monsoonData.Bossname = FiendFolio.MonsoonNames[FiendFolio.MonsoonName]
                    end
                end
            },
            {
                str = 'warp zone name',
                choices = {'warp zone', 'warp zooooone', 'mega portal', 'random'},
                variable = "WarpZoneName",
                setting = 1,
                load = function()
                    return FiendFolio.WarpZoneName or 1
                end,
                store = function(var)
                    FiendFolio.WarpZoneName = var
                end,
                changefunc = function(button)
                    FiendFolio.WarpZoneName = button.setting
                    local warpzoneData = StageAPI.GetBossData("Warp Zone")

                    if FiendFolio.WarpZoneName == 4 then
                        warpzoneData.BossName = FiendFolio.WarpZoneNames[math.random(1, 3)]
                    else
                        warpzoneData.BossName = FiendFolio.WarpZoneNames[FiendFolio.WarpZoneName]
                    end
                end
            },
            {
                str = 'community decision',
                choices = {'all enemies appear', 'vote them out!'},
                variable = "TrueVoteOutcome",
                setting = 1,
                cursoroff = Vector(6, 0),
                load = function()
					if FiendFolio.TrueVoteOutcome then
                        return 2
                    else
                        return 1
                    end
                end,
                store = function(var)
                    FiendFolio.TrueVoteOutcome = (var == 2)
                end,
                tooltip = {strset = {'remove', 'dogmeat and', 'calzone like', 'the community', 'wanted'}}
            },
            {
                str = 'female identifier',
                choices = {'no women', 'sometimes women', 'all women'},
                variable = "WomanMode",
                setting = 0,
                load = function()
                    return FiendFolio.WomanMode + 1
                end,
                store = function(var)
                    FiendFolio.WomanMode = var - 1
                end,
                tooltip = {strset = {'reveal female', 'enemies'}}
            },
            --[[{
                str = 'classic fiend',
                choices = {'enabled', 'disabled'},
                variable = 'FiendClassicTears',
                setting = 2,
                load = function()
                    if FiendFolio.FiendConfig.ClassicTears then
                        return 1
                    else
                        return 2
                    end
                end,
                store = function(var)
                    FiendFolio.FiendConfig.ClassicTears = (var == 1)
                end,
                tooltip = {strset = {'if enabled', "fiend's tears", 'become', 'more faithful', "to devil's", "harvest"}}
            },]]
            {
                str = 'imp baby mode',
                choices = {'enabled', 'disabled'},
                variable = "ImpBabyMode",
                setting = 2,
                load = function()
                    if FiendFolio.FiendConfig.ImpBabyMode then
                        return 1
                    else
                        return 2
                    end
                end,
                store = function(var)
                    FiendFolio.FiendConfig.ImpBabyMode = (var == 1)
                end,
                tooltip = {strset = {'please', 'do not', 'enable', 'this setting'}}
            },
            {
                str = 'duel winner',
                choices = {'sgjd01', 'guwahavel', 'love'},
                variable = 'DuelWinner',
                setting = 0,
                load = function()
                    return FiendFolio.DuelWinner + 1
                end,
                store = function(var)
                    FiendFolio.DuelWinner = var - 1
                    FiendFolio.UpdateDuelWinner()
                end,
                tooltip = {strset = {'come to', 'your own', 'conclusion'}}
            },
            {str = '', fsize = 2, nosel = true},
            {
                str = 'data harvesting',
                dest = 'dataharvesting',
            },
            {str = 'choose how your data', fsize = 2, nosel = true},
            {str = 'gets processed', fsize = 2, nosel = true},
            {str = '', fsize = 2, nosel = true},
            {
                str = '',
                fsize = 2,
                nosel = true
            },
            {
                str = 'go back',
                fsize = 2,
                action = 'back'
            },
        },
        tooltip = dssmod.menuOpenToolTip,
    },
    settingsItems = {
        title = 'settings - items',
        buttons = {
            --[[{str = "please don't disable", fsize = 2, nosel = true},
            {str = 'our epic items :(', fsize = 2, nosel = true},
            {str = '', fsize = 1, nosel = true},
            {
                str = 'fiend folio items',
                choices = {'enabled', 'disabled'},
                variable = "FolioItems",
                setting = 1,
                load = function()
                    if FiendFolio.ItemsEnabled then
                        return 1
                    else
                        return 2
                    end
                end,
                store = function(var)
                    FiendFolio.ItemsEnabled = (var == 1)
                end,
                tooltip = {strset = {'can be used', 'to disable', "fiend folio's", 'new items'}}
            },
            {
                str = 'fiend folio cards',
                choices = {'enabled', 'disabled'},
                variable = "FolioCards",
                setting = 1,
                load = function()
                    if FiendFolio.CardsEnabled then
                        return 1
                    else
                        return 2
                    end
                end,
                store = function(var)
                    FiendFolio.CardsEnabled = (var == 1)
                end,
                tooltip = {strset = {'can be used', 'to disable', "fiend folio's", 'new pocket', 'items'}}
            },]]
            {
                str = 'vanilla tweaks',
                choices = {'enabled', 'disabled'},
                variable = "VanillaFolio",
                setting = 1,
                load = function()
                    if FiendFolio.DoVanillaItemTweaks then
                        return 1
                    else
                        return 2
                    end
                end,
                store = function(var)
                    FiendFolio.DoVanillaItemTweaks = (var == 1)
                end,
                tooltip = {strset = {'can be used', 'to disable', "fiend folio's", 'vanilla item', 'tweaks'}}
            },
            {
                str = '',
                fsize = 1,
                nosel = true
            },
            {str = "mods with matching names", fsize = 2, nosel = true},
            {str = "should be compatible, but", fsize = 2, nosel = true},
            {str = "you can disable ours", fsize = 2, nosel = true},
            {str = "here to reduce confusion", fsize = 2, nosel = true},
            {str = '', fsize = 1, nosel = true},
            {
                str = '- items -',
                nosel = true
            },
            {str = '', fsize = 2, nosel = true},
            {
                str = 'opihuchus',
                choices = {'enabled', 'disabled'},
                variable = "OpihuchusEnabled",
                setting = 1,
                load = function()
                    return (FiendFolio.ItemConfig.OpihuchusDisabled and 2) or 1
                end,
                store = function(var)
                    FiendFolio.ItemConfig.OpihuchusDisabled = var == 2
                end,
                tooltip = {strset = {'disables', "fiend folio's", 'opihuchus', '', 'enabled by', 'default'}}
            },
            {
                str = 'cetus',
                choices = {'enabled', 'disabled'},
                variable = "CetusEnabled",
                setting = 1,
                load = function()
                    return (FiendFolio.ItemConfig.CetusDisabled and 2) or 1
                end,
                store = function(var)
                    FiendFolio.ItemConfig.CetusDisabled = var == 2
                end,
                tooltip = {strset = {'disables', "fiend folio's", 'cetus', '', 'enabled by', 'default'}}
            },
            {str = '', fsize = 2, nosel = true},
            {
                str = '- cards -',
                nosel = true
            },
            {str = '', fsize = 2, nosel = true},
            {
                str = 'kings',
                choices = {'all enabled', 'playing cards disabled', 'minor arcana disabled', 'all disabled'},
                variable = 'KingCardsEnabled',
                setting = 1,
                load = function()
                    if FiendFolio.CardConfig.ArcanaKingCardsDisabled and FiendFolio.CardConfig.PlayingKingCardsDisabled then
                        return 4
                    elseif FiendFolio.CardConfig.ArcanaKingCardsDisabled then
                        return 3
                    elseif FiendFolio.CardConfig.PlayingKingCardsDisabled then
                        return 2
                    else
                        return 1
                    end
                end,
                store = function(var)
                    FiendFolio.CardConfig.ArcanaKingCardsDisabled = (var == 3 or var == 4)
                    FiendFolio.CardConfig.PlayingKingCardsDisabled = (var == 2 or var == 4)
                end,
                tooltip = {strset = {'disables', 'custom', 'fiend folio', 'king cards', '', 'enabled by', 'default'}}
            },
            {
                str = 'queens',
                choices = {'all enabled', --[[ 'playing cards disabled', 'minor arcana disabled',]] 'all disabled'}, -- for now, there aren't any minor arcana queens, so just disabling playing queens should be fine
                variable = 'QueenCardsEnabled',
                setting = 1,
                load = function()
                    if FiendFolio.CardConfig.ArcanaQueenCardsDisabled and FiendFolio.CardConfig.PlayingQueenCardsDisabled then
                        return 4
                    elseif FiendFolio.CardConfig.ArcanaQueenCardsDisabled then
                        return 3
                    elseif FiendFolio.CardConfig.PlayingQueenCardsDisabled then
                        return 2
                    else
                        return 1
                    end
                end,
                store = function(var)
                    FiendFolio.CardConfig.ArcanaQueenCardsDisabled = (var == 3 or var == 4)
                    FiendFolio.CardConfig.PlayingQueenCardsDisabled = (var == 2 or var == 4)
                end,
                tooltip = {strset = {'disables', 'custom', 'fiend folio', 'queen cards', '', 'enabled by', 'default'}}
            },
            {
                str = 'jacks',
                choices = {'all enabled', --[[ 'playing cards disabled', 'minor arcana disabled',]] 'all disabled'},
                variable = 'JackCardsEnabled',
                setting = 1,
                load = function()
                    if FiendFolio.CardConfig.ArcanaJackCardsDisabled and FiendFolio.CardConfig.PlayingJackCardsDisabled then
                        return 4
                    elseif FiendFolio.CardConfig.ArcanaJackCardsDisabled then
                        return 3
                    elseif FiendFolio.CardConfig.PlayingJackCardsDisabled then
                        return 2
                    else
                        return 1
                    end
                end,
                store = function(var)
                    FiendFolio.CardConfig.ArcanaJackCardsDisabled = (var == 3 or var == 4)
                    FiendFolio.CardConfig.PlayingJackCardsDisabled = (var == 2 or var == 4)
                end,
                tooltip = {strset = {'disables', 'custom', 'fiend folio', 'jack cards', '', 'enabled by', 'default'}}
            },
            {
                str = 'twos',
                choices = {'all enabled', 'all disabled'},
                variable = 'MinorTwoCardsEnabled',
                setting = 1,
                load = function()
                    if FiendFolio.CardConfig.ArcanaTwoCardsDisabled then
                        return 2
                    else
                        return 1
                    end
                end,
                store = function(var)
                    FiendFolio.CardConfig.ArcanaTwoCardsDisabled = var == 2
                end,
                tooltip = {strset = {'disables', 'custom', 'fiend folio', 'two cards', '', 'enabled by', 'default'}}
            },
            {
                str = 'threes',
                choices = {'all enabled', 'playing cards disabled', 'minor arcana disabled', 'all disabled'},
                variable = 'ThreeCardsEnabled',
                setting = 1,
                load = function()
                    if FiendFolio.CardConfig.ArcanaThreeCardsDisabled and FiendFolio.CardConfig.PlayingThreeCardsDisabled then
                        return 4
                    elseif FiendFolio.CardConfig.ArcanaThreeCardsDisabled then
                        return 3
                    elseif FiendFolio.CardConfig.PlayingThreeCardsDisabled then
                        return 2
                    else
                        return 1
                    end
                end,
                store = function(var)
                    FiendFolio.CardConfig.ArcanaThreeCardsDisabled = (var == 3 or var == 4)
                    FiendFolio.CardConfig.PlayingThreeCardsDisabled = (var == 2 or var == 4)
                end,
                tooltip = {strset = {'disables', 'custom', 'fiend folio', 'three cards', '', 'enabled by', 'default'}}
            },
        },
    },
    dataharvesting = {
        title = 'data harvesting',
        buttons = {
            {str = 'modify what data', fsize = 2, nosel = true},
            {str = 'you provide to us', fsize = 2, nosel = true},
            {str = '', fsize = 2, nosel = true},
            {str = '- personal info -', nosel = true},
            {str = '', fsize = 2, nosel = true},
            {
                str = 'name',
                choices = {'michael', 'john', "maria", "peter", "julia", "jay", "steven", "harry", "jay", "tom", "bethany", "jeremy", "sam", "james", 'kalu', 'jay', 'earl', 'reimu', 'sephiroth', 'may', 'john', 'holly', 'noelle', 'joe', 'kris', 'rigby'},
                variable = 'DataHarvestName',
                setting = 1,
                load = function()
                    return FiendFolio.DataHarvesting.Name
                end,
                store = function(var)
                    FiendFolio.DataHarvesting.Name = var
                end,
                tooltip = {strset = {'what is your', 'name'}}
            },
            {
                str = 'home address',
                choices = {"39 jersey south", "10 caxton laurels", "23 jethan drive", "17 lane pines", "33 tewkesbury nook", "42 peter walk", "40 wykeham knoll", "15 avenue place", "16 lowther green", "35 deans ridge", "100 billion bean road", "742 evergreen terrace", "31 spooner street", "416 cherry street", "221b baker street", "1600 pennsylvania avenue", "350 fifth avenue", "62 west wallaby street", "29 acacia road", "124 conch street", "13 mushroom alley"},
                variable = 'DataHarvestAddress',
                setting = 1,
                load = function()
                    return FiendFolio.DataHarvesting.Address
                end,
                store = function(var)
                    FiendFolio.DataHarvesting.Address = var
                end,
                tooltip = {strset = {'what is your', 'home address'}}
            },
            {
                str = 'phone number',
                increment = 1, max = 9999999999,
                variable = 'DataHarvestPhoneNumber',
                setting = 1,
                load = function()
                    return FiendFolio.DataHarvesting.PhoneNumber
                end,
                store = function(var)
                    FiendFolio.DataHarvesting.PhoneNumber = var
                end,
                tooltip = {strset = {'what is your', 'phone number'}}
            },
            {
                str = 'credit card number',
                increment = 1, max = 9999999999999999,
                variable = 'DataHarvestCreditNumber',
                setting = 1,
                load = function()
                    return FiendFolio.DataHarvesting.CreditNumber
                end,
                store = function(var)
                    FiendFolio.DataHarvesting.CreditNumber = var
                end,
                tooltip = {strset = {'what is your', 'credit card', 'number'}}
            },
            {
                str = 'class',
                choices = {"lower", "middle", "upper", "scout", "soldier", "pyro", "demoman", "heavy", "engineer", "medic", "sniper", "spy", "civilian", "artificer", "barbarian", "bard", "cleric", "druid", "fighter", "monk", "paladin", "ranger", "rogue", "sorcerer", "warlock", "wizard"},
                variable = 'DataHarvestClass',
                setting = 1,
                load = function()
                    return FiendFolio.DataHarvesting.Class
                end,
                store = function(var)
                    FiendFolio.DataHarvesting.Class = var
                end,
                tooltip = {strset = {'what is your', 'class'}}
            },
            {
                str = 'age',
                increment = 1, max = 25,
                slider = true,
                variable = 'DataHarvestAge',
                setting = 1,
                load = function()
                    return FiendFolio.DataHarvesting.Age
                end,
                store = function(var)
                    FiendFolio.DataHarvesting.Age = var
                end,
                tooltip = {strset = {'what is your', 'age'}}
            },
            {
                str = 'gender',
                increment = 1, max = 25,
                slider = true,
                variable = 'DataHarvestGender',
                setting = 1,
                load = function()
                    return FiendFolio.DataHarvesting.Gender
                end,
                store = function(var)
                    FiendFolio.DataHarvesting.Gender = var
                end,
                tooltip = {strset = {'what is your', 'gender'}}
            },
            {
                str = 'height',
                increment = 1, max = 25,
                slider = true,
                variable = 'DataHarvestHeight',
                setting = 1,
                load = function()
                    return FiendFolio.DataHarvesting.Height
                end,
                store = function(var)
                    FiendFolio.DataHarvesting.Height = var
                end,
                tooltip = {strset = {'what is your', 'height'}}
            },
            {
                str = 'weight',
                increment = 1, max = 25,
                slider = true,
                variable = 'DataHarvestWeight',
                setting = 1,
                load = function()
                    return FiendFolio.DataHarvesting.Weight
                end,
                store = function(var)
                    FiendFolio.DataHarvesting.Weight = var
                end,
                tooltip = {strset = {'what is your', 'weight'}}
            },
            {
                str = 'net worth',
                increment = 1, max = 25,
                slider = true,
                variable = 'DataHarvestNetWorth',
                setting = 1,
                load = function()
                    return FiendFolio.DataHarvesting.NetWorth
                end,
                store = function(var)
                    FiendFolio.DataHarvesting.NetWorth = var
                end,
                tooltip = {strset = {'what is your', 'net worth'}}
            },
            {
                str = 'level',
                increment = 1, max = 25,
                slider = true,
                variable = 'DataHarvestLevel',
                setting = 1,
                load = function()
                    return FiendFolio.DataHarvesting.Level
                end,
                store = function(var)
                    FiendFolio.DataHarvesting.Level = var
                end,
                tooltip = {strset = {'what is your', 'level'}}
            },
            {
                str = 'limb count',
                increment = 1, max = 16,
                slider = true,
                variable = 'DataHarvestLimbCount',
                setting = 1,
                load = function()
                    return FiendFolio.DataHarvesting.LimbCount
                end,
                store = function(var)
                    FiendFolio.DataHarvesting.LimbCount = var
                end,
                tooltip = {strset = {'what is your', 'number of', 'limbs'}}
            },
            {str = '', fsize = 2, nosel = true},
            {str = '- tastes - ', nosel = true},
            {str = '', fsize = 2, nosel = true},
            {
                str = 'pet preference',
                choices = {'dogs', 'cats', 'fish', 'rabbits', 'horses', 'reptiles', 'rodents', 'birds', 'bugs', 'other'},
                variable = 'DataHarvestPetPreference',
                setting = 1,
                load = function()
                    return FiendFolio.DataHarvesting.Pet
                end,
                store = function(var)
                    FiendFolio.DataHarvesting.Pet = var
                end,
                tooltip = {strset = {'what is your', 'favorite pet'}}
            },
            {
                str = 'favorite color',
                choices = {'red', 'scarlet', 'vermillion', 'persimmon', 'orange', 'orange peel', 'amber', 'golden yellow', 'yellow', 'lemon-lime', 'chartreuse', 'apple green', 'green', 'viridian', 'teal', 'cerulean', 'blue', 'indigo', 'violet', 'amethyst', 'purple', 'aubergine', 'magenta', 'crimson'},
                variable = 'DataHarvestColorPreference',
                setting = 1,
                load = function()
                    return FiendFolio.DataHarvesting.Pet
                end,
                store = function(var)
                    FiendFolio.DataHarvesting.Pet = var
                end,
                tooltip = {strset = {'what is your', 'favorite', 'color'}}
            },
            {
                str = 'favorite dev',
                choices = FiendFolio.Developers,
                variable = 'DataHarvestDevPreference',
                setting = 1,
                load = function()
                    return FiendFolio.DataHarvesting.Dev
                end,
                store = function(var)
                    if var == 22 then
                        FiendFolio.savedata.JDMode = true
                    else
                        FiendFolio.savedata.JDMode = nil
                    end
                    FiendFolio.DataHarvesting.Dev = var
                end,
                tooltip = {strset = {'who is your', 'favorite', 'dev'}}
            },
            {str = '', fsize = 2, nosel = true},
            {str = '- cookies -', nosel = true},
            {str = '', fsize = 2, nosel = true},
            {
                str = 'essential cookies',
                choices = {"enabled"},
                variable = 'DataHarvestCookiesEssential',
                setting = 1,
                load = function()
                    return FiendFolio.DataHarvesting.CookiesEssential
                end,
                store = function(var)
                    FiendFolio.DataHarvesting.CookiesEssential = var
                end,
                tooltip = {strset = {'essential', 'cookies'}}
            },
            {
                str = 'tracking cookies',
                choices = {"enabled"},
                variable = 'DataHarvestCookiesTracking',
                setting = 1,
                load = function()
                    return FiendFolio.DataHarvesting.CookiesTracking
                end,
                store = function(var)
                    FiendFolio.DataHarvesting.CookiesTracking = var
                end,
                tooltip = {strset = {'allows us', 'to track you', 'online'}}
            },
            {
                str = 'bitcoin mining',
                choices = {"enabled", "initialized", "activated", "engaged", "allowed"},
                variable = 'DataHarvestBitcoinMining',
                setting = 1,
                load = function()
                    return FiendFolio.DataHarvesting.BitcoinMining
                end,
                store = function(var)
                    FiendFolio.DataHarvesting.BitcoinMining = var
                end,
                tooltip = {strset = {'allows for', 'mining of', 'bitcoin on', 'your machine'}}
            },
        },
    },
    unlocks = {
        title = "unlocks",
        buttons = {
            {str = "achievements", dest = "achievementviewer", tooltip = {strset = {"view all", "your cool", "finds!"}}},
            {str = "completion notes", dest = "completionnotes", cursoroff = Vector(6, 0), tooltip = {strset = {"check out", "your progress!"}}},
            {str = "unlock manager", dest = "unlocksmanager", tooltip = {strset = {"configuration", "options", "for unlocks!"}}}
        },
        tooltip = {strset = {"fiend folio", "has", tostring(#FiendFolio.ACHIEVEMENT_ORDERED), "unlocks for", "you to find!"}}
    },
    completionnotes = {
        title = "completion notes",
        nocursor = true,
        buttons = {
            {str = ""},
            {str = ""},
            {str = ""},
            {str = ""},

            {str = "", nosel = true},
            {str = "", nosel = true},
            {str = "", nosel = true},
            {str = "", fsize = 2, nosel = true},

            {
                str = "press down for golem",
                nosel = true,
                fsize = 1,

                displayif = function(_, item)
                    return item.bsel == 1
                end,
            },
            {
                str = "press down for friend",
                nosel = true,
                fsize = 1,

                displayif = function(_, item)
                    return item.bsel == 2
                end,
            },
            {
                str = "press down for inaba",
                nosel = true,
                fsize = 1,

                displayif = function(_, item)
                    return item.bsel == 3 and FiendFolio.ACHIEVEMENT.INABA:IsUnlocked(true)
                end,
            },
            {
                str = "press down for fiend",
                nosel = true,
                fsize = 1,

                displayif = function(_, item)
                    return item.bsel > 3 or (item.bsel == 3 and not FiendFolio.ACHIEVEMENT.INABA:IsUnlocked(true))
                end,
            },
        },

        postrender = function(item, tbl)
            if item.bsel > 4 then item.bsel = 1 end -- Idk why DSS is letting me pick a fourth option in the menu with only 3 non-nosel buttons but whatever
            if item.bsel > 3 and not FiendFolio.ACHIEVEMENT.INABA:IsUnlocked(true) then item.bsel = 1 end -- inaba should be completely hidden when not unlocked

            local centre = getScreenCenterPosition()
            local renderDataset = completionCharacterSets[item.bsel]
            local offsets = {NOTE1_RENDER_OFFSET, NOTE2_RENDER_OFFSET}
            if #renderDataset == 1 then offsets = {NOTE3_RENDER_OFFSET} end

            for index, renderData in pairs(renderDataset) do
                if renderData.IsUnlocked() then
                    local dataset = FiendFolio.GetCompletionNoteLayerDataFromPlayerType(renderData.PlayerID)
                    for index, value in pairs(dataset) do
                        completionNoteSprite:SetLayerFrame(index, value)
                    end
                    completionHead:SetFrame(renderData.HeadName, 0)

                    completionNoteSprite:Render(centre + offsets[index], Vector.Zero, Vector.Zero)
                    completionHead:Render(centre + offsets[index] + Vector(30, 85), Vector.Zero, Vector.Zero)

					FiendFolio:renderMechaSatanCompletion(centre + offsets[index], Vector(1,1), renderData.PlayerID)
                else
                    completionHead:SetFrame(renderData.HeadName, 1)
                    completionHead:Render(centre + offsets[index] + Vector(30, 85), Vector.Zero, Vector.Zero)

                    completionDoor:SetFrame(renderData.HeadName, 0)
                    completionDoor:Render(centre + offsets[index], Vector.Zero, Vector.Zero)
                end
            end
        end,

        generate = function(item)
            local numAchievements = FiendFolio.TOTAL_COMPLETION_ACHIEVEMENTS
            local numCompleted = FiendFolio.GetNumCompletedAchievements() + 5
            local asPercent = string.format("%.f%%", (numCompleted / numAchievements) * 100)
            local extra = ""
            if numCompleted > numAchievements then
                extra = "!?!"
            elseif numCompleted == numAchievements then
                extra = "!!"
            end
            item.tooltip = {strset = {"you're", asPercent, "done with", "fiend folio!" .. extra}}
        end
    },
    unlocksmanager = {
        title = "unlocks manager",
        fsize = 2,

        buttons = {
            {str = "", nosel = true},
            {
                str = "achievements",
                fsize = 3,
                choices = {"enabled", "disabled"},
                variable = "AchievementsEnabled",
                setting = 1,
                load = function()
                    if FiendFolio.savedata.disableAchievements then
                        return 2
                    else
                        return 1
                    end
                end,
                store = function(var)
                    FiendFolio.savedata.disableAchievements = var == 2
                end,
                tooltip = {strset = {'change this', 'to enable or', 'disable all', 'unlocks.', "we'll still", 'keep track', 'for you!'}}
            },
            {str = "", nosel = true},
            {str = "unlock all", dest = "areyousure", func = function() areYouSureUnlockTag = nil isUnlockingAll = true end},
            {str = "lock all", dest = "areyousure", func = function() areYouSureUnlockTag = nil isUnlockingAll = false end},
            {str = "", nosel = true},
            {str = "-----------------", fsize = 3, nosel = true},
            {str = "", fsize = 1, nosel = true},
            {str = "character unlocks", fsize = 3, nosel = true},
            {str = "", nosel = true},
            {str = "characters", fsize = 3, dest = "characterunlocks"},

            {str = "", nosel = true, displayif = function() return FiendFolio.ACHIEVEMENT.FIEND:IsUnlocked() end},
            {str = "fiend", fsize = 3, dest = "fiendunlocks", displayif = function() return FiendFolio.ACHIEVEMENT.FIEND:IsUnlocked() end},
            {str = "tainted fiend", fsize = 3, dest = "biendunlocks", displayif = function() return FiendFolio.ACHIEVEMENT.BIEND:IsUnlocked() end},
            {str = "the skeletal fiend", fsize = 3, dest = "skeletalfiendunlocks", displayif = function() return (Epiphany and Epiphany.API and FiendFolio.ACHIEVEMENT.SKELETALFIEND:IsUnlocked()) end},

            {str = "", nosel = true, displayif = function() return FiendFolio.ACHIEVEMENT.GOLEM:IsUnlocked() end},
            {str = "golem", fsize = 3, dest = "golemunlocks", displayif = function() return FiendFolio.ACHIEVEMENT.GOLEM:IsUnlocked() end},
            {str = "tainted golem", fsize = 3, dest = "bolemunlocks", displayif = function() return FiendFolio.ACHIEVEMENT.BOLEM:IsUnlocked() end},

            {str = "", nosel = true, displayif = function() return FiendFolio.ACHIEVEMENT.FRIEND:IsUnlocked() end},
            {str = "friend", fsize = 3, dest = "friendunlocks", displayif = function() return FiendFolio.ACHIEVEMENT.FRIEND:IsUnlocked() end},
            {str = "tainted friend", fsize = 3, dest = "briendunlocks", displayif = function() return FiendFolio.ACHIEVEMENT.BRIEND:IsUnlocked() end},

            {str = "", nosel = true, displayif = function() return FiendFolio.ACHIEVEMENT.INABA:IsUnlocked(true) end},
            {str = "inaba", fsize = 3, dest = "inabaunlocks", displayif = function() return FiendFolio.ACHIEVEMENT.INABA:IsUnlocked(true) end},
            {str = "tainted inaba", fsize = 3, dest = "binabaunlocks", displayif = function() return FiendFolio.ACHIEVEMENT.INABA:IsUnlocked(true) and FiendFolio.ACHIEVEMENT.BINABA:IsUnlocked() end},

            {str = "", nosel = true, displayif = function () return FiendFolio.ACHIEVEMENT.FIEND:IsUnlocked() or
			                                                        FiendFolio.ACHIEVEMENT.BIEND:IsUnlocked() or
			                                                        FiendFolio.ACHIEVEMENT.GOLEM:IsUnlocked() or
			                                                        FiendFolio.ACHIEVEMENT.BOLEM:IsUnlocked() or
			                                                        FiendFolio.ACHIEVEMENT.FRIEND:IsUnlocked() or
			                                                        FiendFolio.ACHIEVEMENT.BRIEND:IsUnlocked() or
			                                                        FiendFolio.ACHIEVEMENT.INABA:IsUnlocked(true) or
			                                                        FiendFolio.ACHIEVEMENT.BINABA:IsUnlocked() end},
            {str = "fiendish foes", fsize = 3, dest = "finalbossunlocks"},
            {str = "full marks", fsize = 3, dest = "allclearunlocks", displayif = function () return (FiendFolio.ACHIEVEMENT.FIEND:IsUnlocked() or
			                                                                                         FiendFolio.ACHIEVEMENT.GOLEM:IsUnlocked() or
			                                                                                         FiendFolio.ACHIEVEMENT.FRIEND:IsUnlocked()) and
			                                                                                         FiendFolio.ACHIEVEMENT.INABA:IsUnlocked(true) end},
            {str = "", nosel = true},
            {str = "unlock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Character" isUnlockingAll = true end},
            {str = "lock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Character" isUnlockingAll = false end},
            {str = "", nosel = true},

            {str = "-----------------", fsize = 3, nosel = true},
            {str = "", fsize = 1, nosel = true},
            {str = "challenge unlocks", fsize = 3, nosel = true},
            {str = "", fsize = 3, nosel = true},
            {str = "challenges", fsize = 3, dest = "challengeunlocks"},
            {str = "rewards", fsize = 3, dest = "challengerewards"},
            {str = "", nosel = true},
            {str = "unlock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Challenge" isUnlockingAll = true end},
            {str = "lock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Challenge" isUnlockingAll = false end},
            {str = "", nosel = true},

            {str = "-----------------", fsize = 3, nosel = true},
            {str = "", fsize = 1, nosel = true},
            {str = "other unlocks", fsize = 3, nosel = true},
            {str = "", fsize = 1, nosel = true},
            {str = "backdrops", fsize = 3, dest = "backdropunlocks"},
            {str = "miscellaneous", fsize = 3, dest = "miscunlocks"},
            {str = "", fsize = 3, nosel = true},
            {str = "unlock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Other" isUnlockingAll = true end},
            {str = "lock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Other" isUnlockingAll = false end},
        },
    },
    characterunlocks = {
        title = "characters",
        fsize = 2,
        buttons = {
            {str = "", nosel = true},
            {str = "regular unlocks", fsize = 3, nosel = true},
            {str = "", nosel = true},
			{insertUnlockTag = "CharacterUnlock"},
            {str = "", nosel = true},
            {str = "unlock all", dest = "areyousure", func = function() areYouSureUnlockTag = "CharacterUnlock" isUnlockingAll = true end},
            {str = "lock all", dest = "areyousure", func = function() areYouSureUnlockTag = "CharacterUnlock" isUnlockingAll = false end},
            {str = "", nosel = true},
            {str = "-----------------", fsize = 3, nosel = true},
            {str = "", nosel = true},
            {str = "tainted unlocks", fsize = 3, nosel = true},
            {str = "", nosel = true},
			{insertUnlockTag = "TaintedCharacterUnlock"},
            {str = "", nosel = true},
            {str = "unlock all", dest = "areyousure", func = function() areYouSureUnlockTag = "TaintedCharacterUnlock" isUnlockingAll = true end},
            {str = "lock all", dest = "areyousure", func = function() areYouSureUnlockTag = "TaintedCharacterUnlock" isUnlockingAll = false end},
            {str = "", nosel = true},
            {str = "-----------------", fsize = 3, nosel = true, displayif = function() return Epiphany and Epiphany.API end},
            {str = "", nosel = true, displayif = function() return Epiphany and Epiphany.API end},
            {str = "tarnished unlocks", fsize = 3, nosel = true, displayif = function() return Epiphany and Epiphany.API end},
            {str = "", nosel = true, displayif = function() return Epiphany and Epiphany.API end},
			{insertUnlockTag = "TarnishedCharacterUnlock", displayif = function() return Epiphany and Epiphany.API end},
            {str = "", nosel = true, displayif = function() return Epiphany and Epiphany.API end},
            {str = "unlock all", dest = "areyousure", func = function() areYouSureUnlockTag = "TarnishedCharacterUnlock" isUnlockingAll = true end, displayif = function() return Epiphany and Epiphany.API end},
            {str = "lock all", dest = "areyousure", func = function() areYouSureUnlockTag = "TarnishedCharacterUnlock" isUnlockingAll = false end, displayif = function() return Epiphany and Epiphany.API end},
            {str = "", nosel = true, displayif = function() return Epiphany and Epiphany.API end},
        }
    },
    fiendunlocks = {
        title = "fiend unlocks",
        fsize = 2,
        buttons = {
            {str = "", nosel = true},
            {str = "completion note", fsize = 3, dest = "fiendcompletion", tooltip = completionNoteTip},
            {str = "", nosel = true},
            {str = "-----------------", fsize = 3, nosel = true},
            {str = "", fsize = 1, nosel = true},
            {insertUnlockTag = "BiendUnlock"},
            {str = "", nosel = true},
            {str = "-----------------", fsize = 3, nosel = true},
            {str = "", fsize = 1, nosel = true},
            {str = "item unlocks", fsize = 3, nosel = true},
            {str = "", fsize = 3, nosel = true},
            {insertUnlockTag = "FiendCompletion"},
            {str = "", fsize = 1, nosel = true},
            {insertUnlockTag = "FiendAll"},
            {str = "", nosel = true},
            {str = "unlock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Fiend" isUnlockingAll = true end},
            {str = "lock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Fiend" isUnlockingAll = false end},
            {str = "", nosel = true},
        }
    },
    fiendcompletion = {
        title = "fiend completion",
        fsize = 2,
        buttons = {
            {
                str = "mom's heart / it lives",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "fiend_heart",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.FIEND, CompletionType.MOMS_HEART) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.FIEND, CompletionType.MOMS_HEART, var - 1)
                end,

                tooltip = {strset = {"lil fiend", "", "unlocks on", "hard"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "isaac",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "fiend_isaac",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.FIEND, CompletionType.ISAAC) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.FIEND, CompletionType.ISAAC, var - 1)
                end,

                tooltip = {strset = {"imp soda", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "???",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "fiend_bluebaby",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.FIEND, CompletionType.BLUE_BABY) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.FIEND, CompletionType.BLUE_BABY, var - 1)
                end,

                tooltip = {strset = {"shard of", "china", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "satan",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "fiend_satan",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.FIEND, CompletionType.SATAN) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.FIEND, CompletionType.SATAN, var - 1)
                end,

                tooltip = {strset = {"fiend mix", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "the lamb",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "fiend_lamb",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.FIEND, CompletionType.LAMB) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.FIEND, CompletionType.LAMB, var - 1)
                end,

                tooltip = {strset = {"prank cookie", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "boss rush",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "fiend_rush",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.FIEND, CompletionType.BOSS_RUSH) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.FIEND, CompletionType.BOSS_RUSH, var - 1)
                end,

                tooltip = {strset = {"gmo corn", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "hush",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "fiend_hush",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.FIEND, CompletionType.HUSH) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.FIEND, CompletionType.HUSH, var - 1)
                end,

                tooltip = {strset = {"+3 fireballs", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "mega satan",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "fiend_megasatan",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.FIEND, CompletionType.MEGA_SATAN) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.FIEND, CompletionType.MEGA_SATAN, var - 1)
                end,

                tooltip = {strset = {"pyromancy", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "ultra greed(ier)",
                choices = {"uncompleted", "completed: greed", "completed: greedier"},
                variable = "fiend_greed",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.FIEND, CompletionType.ULTRA_GREEDIER) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.FIEND, CompletionType.ULTRA_GREED, var - 1)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.FIEND, CompletionType.ULTRA_GREEDIER, var - 1)
                end,

                tooltip = {strset = {"cool", "sunglasses", "unlocks on", "greed+", "", "jack cards", "unlock on", "greedier"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "delirium",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "fiend_delirium",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.FIEND, CompletionType.DELIRIUM) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.FIEND, CompletionType.DELIRIUM, var - 1)
                end,

                tooltip = {strset = {"fiends horn", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "mother",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "fiend_mother",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.FIEND, CompletionType.MOTHER) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.FIEND, CompletionType.MOTHER, var - 1)
                end,

                tooltip = {strset = {"longtime", "fiend", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "beast",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "fiend_beast",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.FIEND, CompletionType.BEAST) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.FIEND, CompletionType.BEAST, var - 1)
                end,

                tooltip = {strset = {"fetal fiend", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "fiendish foes",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "fiend_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, FiendFolio.PLAYER.FIEND)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(FiendFolio.PLAYER.FIEND):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, FiendFolio.PLAYER.FIEND)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(FiendFolio.PLAYER.FIEND):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"fiend's lost", "friend", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {str = "the fiend folio", nosel = true},
            {str = "unlocked by beating everything on hard", fsize = 1, nosel = true},
            {str = "", nosel = true},
        },
    },
    biendunlocks = {
        title = "t. fiend unlocks",
        fsize = 2,
        buttons = {
            {str = "", nosel = true},
            {str = "completion note", fsize = 3, dest = "biendcompletion", tooltip = completionNoteTip},
            {str = "", nosel = true},
            {str = "-----------------", fsize = 3, nosel = true, displayif = function() return Epiphany and Epiphany.API end},
            {str = "", fsize = 1, nosel = true, displayif = function() return Epiphany and Epiphany.API end},
            {insertUnlockTag = "SkeletalFiendUnlock", displayif = function() return Epiphany and Epiphany.API end},
            {str = "", fsize = 1, nosel = true, displayif = function() return Epiphany and Epiphany.API end},
            {str = "-----------------", fsize = 3, nosel = true},
            {str = "", fsize = 1, nosel = true},
            {str = "item unlocks", fsize = 3, nosel = true},
            {str = "", fsize = 3, nosel = true},
            {insertUnlockTag = "Biend"},
            {str = "", nosel = true},
            {str = "unlock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Biend" isUnlockingAll = true end},
            {str = "lock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Biend" isUnlockingAll = false end},
            {str = "", nosel = true},
        }
    },
    biendcompletion = {
        title = "t. fiend completion",
        fsize = 2,
        buttons = {
            {
                str = "mom's heart / it lives",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "biend_heart",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BIEND, CompletionType.MOMS_HEART) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BIEND, CompletionType.MOMS_HEART, var - 1)
                end,

                tooltip = {strset = {"no unlock"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "isaac",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "biend_isaac",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BIEND, CompletionType.ISAAC) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BIEND, CompletionType.ISAAC, var - 1)
                end,

                tooltip = {strset = {"imp finger", "", "quartet:", "beat isaac,", "???, satan", "and the lamb", "on normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "???",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "biend_bluebaby",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BIEND, CompletionType.BLUE_BABY) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BIEND, CompletionType.BLUE_BABY, var - 1)
                end,

                tooltip = {strset = {"imp finger", "", "quartet:", "beat isaac,", "???, satan", "and the lamb", "on normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "satan",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "biend_satan",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BIEND, CompletionType.SATAN) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BIEND, CompletionType.SATAN, var - 1)
                end,

                tooltip = {strset = {"imp finger", "", "quartet:", "beat isaac,", "???, satan", "and the lamb", "on normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "the lamb",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "biend_lamb",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BIEND, CompletionType.LAMB) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BIEND, CompletionType.LAMB, var - 1)
                end,

                tooltip = {strset = {"imp finger", "", "quartet:", "beat isaac,", "???, satan", "and the lamb", "on normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "boss rush",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "biend_rush",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BIEND, CompletionType.BOSS_RUSH) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BIEND, CompletionType.BOSS_RUSH, var - 1)
                end,

                tooltip = {strset = {"soul of", "fiend", "", "duet:", "beat boss", "rush and hush", "on normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "hush",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "biend_hush",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BIEND, CompletionType.HUSH) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BIEND, CompletionType.HUSH, var - 1)
                end,

                tooltip = {strset = {"soul of", "fiend", "", "duet:", "beat boss", "rush and hush", "on normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "mega satan",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "biend_megasatan",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BIEND, CompletionType.MEGA_SATAN) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BIEND, CompletionType.MEGA_SATAN, var - 1)
                end,

                tooltip = {strset = {"dire chest", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "ultra greed(ier)",
                choices = {"uncompleted", "completed: greed", "completed: greedier"},
                variable = "biend_greed",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BIEND, CompletionType.ULTRA_GREEDIER) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BIEND, CompletionType.ULTRA_GREED, var - 1)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BIEND, CompletionType.ULTRA_GREEDIER, var - 1)
                end,

                tooltip = {strset = {"+3 fireballs?", "", "unlocks on", "greedier"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "delirium",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "biend_delirium",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BIEND, CompletionType.DELIRIUM) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BIEND, CompletionType.DELIRIUM, var - 1)
                end,

                tooltip = {strset = {"malice", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "mother",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "biend_mother",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BIEND, CompletionType.MOTHER) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BIEND, CompletionType.MOTHER, var - 1)
                end,

                tooltip = {strset = {"hatred", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "beast",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "biend_beast",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BIEND, CompletionType.BEAST) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BIEND, CompletionType.BEAST, var - 1)
                end,

                tooltip = {strset = {"imp curse", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "fiendish foes",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "biend_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, FiendFolio.PLAYER.BIEND)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(FiendFolio.PLAYER.BIEND):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, FiendFolio.PLAYER.BIEND)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(FiendFolio.PLAYER.BIEND):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"huitlacoche", "", "unlocks on", "normal+"}}
            }
        },
    },
    golemunlocks = {
        title = "golem unlocks",
        fsize = 2,
        buttons = {
            {str = "", nosel = true},
            {str = "completion note", fsize = 3, dest = "golemcompletion", tooltip = completionNoteTip},
            {str = "", nosel = true},
            {str = "-----------------", fsize = 3, nosel = true},
            {str = "", fsize = 1, nosel = true},
            {insertUnlockTag = "BolemUnlock"},
            {str = "", nosel = true},
            {str = "-----------------", fsize = 3, nosel = true},
            {str = "", fsize = 1, nosel = true},
            {str = "item unlocks", fsize = 3, nosel = true},
            {str = "", fsize = 3, nosel = true},
            {insertUnlockTag = "GolemCompletion"},
            {str = "", fsize = 1, nosel = true},
            {insertUnlockTag = "GolemAll"},
            {str = "", nosel = true},
            {str = "unlock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Golem" isUnlockingAll = true end},
            {str = "lock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Golem" isUnlockingAll = false end},
            {str = "", nosel = true},
        }
    },
    golemcompletion = {
        title = "golem completion",
        fsize = 2,
        buttons = {
            {
                str = "mom's heart / it lives",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "golem_heart",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.GOLEM, CompletionType.MOMS_HEART) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.GOLEM, CompletionType.MOMS_HEART, var - 1)
                end,

                tooltip = {strset = {"lil golem", "", "unlocks on", "hard"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "isaac",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "golem_isaac",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.GOLEM, CompletionType.ISAAC) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.GOLEM, CompletionType.ISAAC, var - 1)
                end,

                tooltip = {strset = {"golem's rock", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "???",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "golem_bluebaby",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.GOLEM, CompletionType.BLUE_BABY) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.GOLEM, CompletionType.BLUE_BABY, var - 1)
                end,

                tooltip = {strset = {"golem's orb", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "satan",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "golem_satan",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.GOLEM, CompletionType.SATAN) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.GOLEM, CompletionType.SATAN, var - 1)
                end,

                tooltip = {strset = {"cherry bomb", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "the lamb",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "golem_lamb",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.GOLEM, CompletionType.LAMB) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.GOLEM, CompletionType.LAMB, var - 1)
                end,

                tooltip = {strset = {"bridge bombs", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "boss rush",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "golem_rush",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.GOLEM, CompletionType.BOSS_RUSH) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.GOLEM, CompletionType.BOSS_RUSH, var - 1)
                end,

                tooltip = {strset = {"solemn vow", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "hush",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "golem_hush",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.GOLEM, CompletionType.HUSH) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.GOLEM, CompletionType.HUSH, var - 1)
                end,

                tooltip = {strset = {"dice goblin", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "mega satan",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "golem_megasatan",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.GOLEM, CompletionType.MEGA_SATAN) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.GOLEM, CompletionType.MEGA_SATAN, var - 1)
                end,

                tooltip = {strset = {"massive", "amethyst", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "ultra greed(ier)",
                choices = {"uncompleted", "completed: greed", "completed: greedier"},
                variable = "golem_greed",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.GOLEM, CompletionType.ULTRA_GREEDIER) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.GOLEM, CompletionType.ULTRA_GREED, var - 1)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.GOLEM, CompletionType.ULTRA_GREEDIER, var - 1)
                end,

                tooltip = {strset = {"molten penny", "unlocks on", "greed+", "", "golden spikes", "unlocks on", "greedier"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "delirium",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "golem_delirium",
                setting = 1,

               load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.GOLEM, CompletionType.DELIRIUM) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.GOLEM, CompletionType.DELIRIUM, var - 1)
                end,

                tooltip = {strset = {"perfectly", "generic object", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "mother",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "golem_mother",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.GOLEM, CompletionType.MOTHER) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.GOLEM, CompletionType.MOTHER, var - 1)
                end,

                tooltip = {strset = {"eternal d12", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "beast",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "golem_beast",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.GOLEM, CompletionType.BEAST) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.GOLEM, CompletionType.BEAST, var - 1)
                end,

                tooltip = {strset = {"astropulvis", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "fiendish foes",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "golem_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, FiendFolio.PLAYER.GOLEM)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(FiendFolio.PLAYER.GOLEM):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, FiendFolio.PLAYER.GOLEM)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(FiendFolio.PLAYER.GOLEM):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"asteroid belt", "", "unlocks on", "normal+"}}
			},
            {str = "", fsize = 1, nosel = true},
            {str = "snow globe", nosel = true},
            {str = "unlocked by beating everything on hard", fsize = 1, nosel = true},
            {str = "", nosel = true},
        },
    },
    bolemunlocks = {
        title = "t. golem unlocks",
        fsize = 2,
        buttons = {
            {str = "", nosel = true},
            {str = "completion note", fsize = 3, dest = "bolemcompletion", tooltip = completionNoteTip},
            {str = "", nosel = true},
            {str = "-----------------", fsize = 3, nosel = true},
            {str = "", fsize = 1, nosel = true},
            {str = "item unlocks", fsize = 3, nosel = true},
            {str = "", fsize = 3, nosel = true},
            {insertUnlockTag = "Bolem"},
            {str = "", nosel = true},
            {str = "unlock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Bolem" isUnlockingAll = true end},
            {str = "lock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Bolem" isUnlockingAll = false end},
            {str = "", nosel = true},
        }
    },
    bolemcompletion = {
        title = "t. golem completion",
        fsize = 2,
        buttons = {
            {
                str = "mom's heart / it lives",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "bolem_heart",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BOLEM, CompletionType.MOMS_HEART) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BOLEM, CompletionType.MOMS_HEART, var - 1)
                end,

                tooltip = {strset = {"no unlock"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "isaac",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "bolem_isaac",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BOLEM, CompletionType.ISAAC) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BOLEM, CompletionType.ISAAC, var - 1)
                end,

                tooltip = {strset = {"wavebreaker", "", "quartet:", "beat isaac,", "???, satan", "and the lamb", "on normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "???",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "bolem_bluebaby",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BOLEM, CompletionType.BLUE_BABY) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BOLEM, CompletionType.BLUE_BABY, var - 1)
                end,

                tooltip = {strset = {"wavebreaker", "", "quartet:", "beat isaac,", "???, satan", "and the lamb", "on normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "satan",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "bolem_satan",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BOLEM, CompletionType.SATAN) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BOLEM, CompletionType.SATAN, var - 1)
                end,

                tooltip = {strset = {"wavebreaker", "", "quartet:", "beat isaac,", "???, satan", "and the lamb", "on normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "the lamb",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "bolem_lamb",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BOLEM, CompletionType.LAMB) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BOLEM, CompletionType.LAMB, var - 1)
                end,

                tooltip = {strset = {"wavebreaker", "", "quartet:", "beat isaac,", "???, satan", "and the lamb", "on normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "boss rush",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "bolem_rush",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BOLEM, CompletionType.BOSS_RUSH) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BOLEM, CompletionType.BOSS_RUSH, var - 1)
                end,

                tooltip = {strset = {"soul of", "golem", "", "duet:", "beat boss", "rush and hush", "on normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "hush",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "bolem_hush",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BOLEM, CompletionType.HUSH) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BOLEM, CompletionType.HUSH, var - 1)
                end,

                tooltip = {strset = {"soul of", "golem", "", "duet:", "beat boss", "rush and hush", "on normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "mega satan",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "bolem_megasatan",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BOLEM, CompletionType.MEGA_SATAN) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BOLEM, CompletionType.MEGA_SATAN, var - 1)
                end,

                tooltip = {strset = {"blasphemous", "trinkets", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "ultra greed(ier)",
                choices = {"uncompleted", "completed: greed", "completed: greedier"},
                variable = "bolem_greed",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BOLEM, CompletionType.ULTRA_GREEDIER) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BOLEM, CompletionType.ULTRA_GREED, var - 1)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BOLEM, CompletionType.ULTRA_GREEDIER, var - 1)
                end,

                tooltip = {strset = {"king of", "pentacles?", "", "unlocks on", "greedier"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "delirium",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "bolem_delirium",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BOLEM, CompletionType.DELIRIUM) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BOLEM, CompletionType.DELIRIUM, var - 1)
                end,

                tooltip = {strset = {"mammonite", "codex", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "mother",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "bolem_mother",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BOLEM, CompletionType.MOTHER) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BOLEM, CompletionType.MOTHER, var - 1)
                end,

                tooltip = {strset = {"sisyphean", "boulder", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "beast",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "bolem_beast",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BOLEM, CompletionType.BEAST) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BOLEM, CompletionType.BEAST, var - 1)
                end,

                tooltip = {strset = {"azurite", "spindown", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "fiendish foes",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "bolem_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, FiendFolio.PLAYER.BOLEM)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(FiendFolio.PLAYER.BOLEM):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, FiendFolio.PLAYER.BOLEM)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(FiendFolio.PLAYER.BOLEM):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"copper bar", "", "unlocks on", "normal+"}}
			}
        },
    },
    friendunlocks = {
        title = "friend unlocks",
        fsize = 2,
        buttons = {
            {str = "", nosel = true},
            {str = "completion note", fsize = 3, dest = "friendcompletion", tooltip = completionNoteTip},
            {str = "", nosel = true},
            {str = "-----------------", fsize = 3, nosel = true},
            {str = "", fsize = 1, nosel = true},
            {insertUnlockTag = "BriendUnlock"},
            {str = "", nosel = true},
            {str = "-----------------", fsize = 3, nosel = true},
            {str = "", fsize = 1, nosel = true},
            {str = "item unlocks", fsize = 3, nosel = true},
            {str = "", fsize = 3, nosel = true},
            {insertUnlockTag = "FriendCompletion"},
            {str = "", fsize = 1, nosel = true},
            {insertUnlockTag = "FriendAll"},
            {str = "", nosel = true},
            {str = "unlock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Friend" isUnlockingAll = true end},
            {str = "lock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Friend" isUnlockingAll = false end},
            {str = "", nosel = true},
        }
    },
    friendcompletion = {
        title = "friend completion",
        fsize = 2,
        buttons = {
            {
                str = "mom's heart / it lives",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "friend_heart",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.FRIEND, CompletionType.MOMS_HEART) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.FRIEND, CompletionType.MOMS_HEART, var - 1)
                end,

                tooltip = {strset = {"lil friend", "", "unlocks on", "hard"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "isaac",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "friend_isaac",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.FRIEND, CompletionType.ISAAC) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.FRIEND, CompletionType.ISAAC, var - 1)
                end,

                tooltip = {strset = {"imp soda:", "tricky cherry", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "???",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "friend_bluebaby",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.FRIEND, CompletionType.BLUE_BABY) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.FRIEND, CompletionType.BLUE_BABY, var - 1)
                end,

                tooltip = {strset = {"rubber bullets", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "satan",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "friend_satan",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.FRIEND, CompletionType.SATAN) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.FRIEND, CompletionType.SATAN, var - 1)
                end,

                tooltip = {strset = {"contra band", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "the lamb",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "friend_lamb",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.FRIEND, CompletionType.LAMB) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.FRIEND, CompletionType.LAMB, var - 1)
                end,

                tooltip = {strset = {"swallowed", "m90", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "boss rush",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "friend_rush",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.FRIEND, CompletionType.BOSS_RUSH) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.FRIEND, CompletionType.BOSS_RUSH, var - 1)
                end,

                tooltip = {strset = {"how to roll", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "hush",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "friend_hush",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.FRIEND, CompletionType.HUSH) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.FRIEND, CompletionType.HUSH, var - 1)
                end,

                tooltip = {strset = {"old shell", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "mega satan",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "friend_megasatan",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.FRIEND, CompletionType.MEGA_SATAN) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.FRIEND, CompletionType.MEGA_SATAN, var - 1)
                end,

                tooltip = {strset = {"bullet hell", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "ultra greed(ier)",
                choices = {"uncompleted", "completed: greed", "completed: greedier"},
                variable = "friend_greed",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.FRIEND, CompletionType.ULTRA_GREEDIER) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.FRIEND, CompletionType.ULTRA_GREED, var - 1)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.FRIEND, CompletionType.ULTRA_GREEDIER, var - 1)
                end,

                tooltip = {strset = {"snags", "unlocks on", "greed+", "", "dynamite pack", "unlock on", "greedier"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "delirium",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "friend_delirium",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.FRIEND, CompletionType.DELIRIUM) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.FRIEND, CompletionType.DELIRIUM, var - 1)
                end,

                tooltip = {strset = {"friend's", "fireball", "formula", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "mother",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "friend_mother",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.FRIEND, CompletionType.MOTHER) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.FRIEND, CompletionType.MOTHER, var - 1)
                end,

                tooltip = {strset = {"raildriver", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "beast",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "friend_beast",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.FRIEND, CompletionType.BEAST) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.FRIEND, CompletionType.BEAST, var - 1)
                end,

                tooltip = {strset = {"fetal friend", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "fiendish foes",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "friend_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, FiendFolio.PLAYER.FRIEND)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(FiendFolio.PLAYER.FRIEND):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, FiendFolio.PLAYER.FRIEND)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(FiendFolio.PLAYER.FRIEND):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"friendly fire", "", "unlocks on", "normal+"}}
			},
            {str = "", fsize = 1, nosel = true},
            {str = "grandpa's gatling gun", nosel = true},
            {str = "unlocked by beating everything on hard", fsize = 1, nosel = true},
            {str = "", nosel = true},
        },
    },
    briendunlocks = {
        title = "t. friend unlocks",
        fsize = 2,
        buttons = {
            {str = "", nosel = true},
            {str = "completion note", fsize = 3, dest = "briendcompletion", tooltip = completionNoteTip},
            {str = "", nosel = true},
            {str = "-----------------", fsize = 3, nosel = true},
            {str = "", fsize = 1, nosel = true},
            {str = "item unlocks", fsize = 3, nosel = true},
            {str = "", fsize = 3, nosel = true},
            {insertUnlockTag = "Briend"},
            {str = "", nosel = true},
            {str = "unlock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Briend" isUnlockingAll = true end},
            {str = "lock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Briend" isUnlockingAll = false end},
            {str = "", nosel = true},
        }
    },
    briendcompletion = {
        title = "t. friend completion",
        fsize = 2,
        buttons = {
            {
                str = "mom's heart / it lives",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "briend_heart",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BRIEND, CompletionType.MOMS_HEART) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BRIEND, CompletionType.MOMS_HEART, var - 1)
                end,

                tooltip = {strset = {"no unlock"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "isaac",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "briend_isaac",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BRIEND, CompletionType.ISAAC) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BRIEND, CompletionType.ISAAC, var - 1)
                end,

                tooltip = {strset = {"ammo clip", "", "quartet:", "beat isaac,", "???, satan", "and the lamb", "on normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "???",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "briend_bluebaby",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BRIEND, CompletionType.BLUE_BABY) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BRIEND, CompletionType.BLUE_BABY, var - 1)
                end,

                tooltip = {strset = {"ammo clip", "", "quartet:", "beat isaac,", "???, satan", "and the lamb", "on normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "satan",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "briend_satan",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BRIEND, CompletionType.SATAN) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BRIEND, CompletionType.SATAN, var - 1)
                end,

                tooltip = {strset = {"ammo clip", "", "quartet:", "beat isaac,", "???, satan", "and the lamb", "on normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "the lamb",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "briend_lamb",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BRIEND, CompletionType.LAMB) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BRIEND, CompletionType.LAMB, var - 1)
                end,

                tooltip = {strset = {"ammo clip", "", "quartet:", "beat isaac,", "???, satan", "and the lamb", "on normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "boss rush",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "briend_rush",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BRIEND, CompletionType.BOSS_RUSH) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BRIEND, CompletionType.BOSS_RUSH, var - 1)
                end,

                tooltip = {strset = {"soul of", "friend", "", "duet:", "beat boss", "rush and hush", "on normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "hush",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "briend_hush",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BRIEND, CompletionType.HUSH) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BRIEND, CompletionType.HUSH, var - 1)
                end,

                tooltip = {strset = {"soul of", "friend", "", "duet:", "beat boss", "rush and hush", "on normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "mega satan",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "briend_megasatan",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BRIEND, CompletionType.MEGA_SATAN) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BRIEND, CompletionType.MEGA_SATAN, var - 1)
                end,

                tooltip = {strset = {"saloons", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "ultra greed(ier)",
                choices = {"uncompleted", "completed: greed", "completed: greedier"},
                variable = "briend_greed",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BRIEND, CompletionType.ULTRA_GREEDIER) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BRIEND, CompletionType.ULTRA_GREED, var - 1)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BRIEND, CompletionType.ULTRA_GREEDIER, var - 1)
                end,

                tooltip = {strset = {"misprinted", "joker", "", "unlocks on", "greedier"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "delirium",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "briend_delirium",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BRIEND, CompletionType.DELIRIUM) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BRIEND, CompletionType.DELIRIUM, var - 1)
                end,

                tooltip = {strset = {"gunslinger's", "grit", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "mother",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "briend_mother",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BRIEND, CompletionType.MOTHER) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BRIEND, CompletionType.MOTHER, var - 1)
                end,

                tooltip = {strset = {"dad's usb", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "beast",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "briend_beast",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BRIEND, CompletionType.BEAST) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BRIEND, CompletionType.BEAST, var - 1)
                end,

                tooltip = {strset = {"mysterious", "fedora", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "fiendish foes",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "briend_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, FiendFolio.PLAYER.BRIEND)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(FiendFolio.PLAYER.BRIEND):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, FiendFolio.PLAYER.BRIEND)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(FiendFolio.PLAYER.BRIEND):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"magic bullet", "", "unlocks on", "normal+"}}
			}
        },
    },
    inabaunlocks = {
        title = "inaba unlocks",
        fsize = 2,
        buttons = {
            {str = "", nosel = true},
            {str = "completion note", fsize = 3, dest = "inabacompletion", tooltip = completionNoteTip},
            {str = "", nosel = true},
            {str = "-----------------", fsize = 3, nosel = true},
            {str = "", fsize = 1, nosel = true},
            {insertUnlockTag = "BinabaUnlock"},
            {str = "", nosel = true},
            {str = "-----------------", fsize = 3, nosel = true},
            {str = "", fsize = 1, nosel = true},
            {str = "item unlocks", fsize = 3, nosel = true},
            {str = "", fsize = 3, nosel = true},
            {insertUnlockTag = "InabaCompletion"},
            {str = "", fsize = 1, nosel = true},
            {insertUnlockTag = "InabaAll"},
            {str = "", nosel = true},
            {str = "unlock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Inaba" isUnlockingAll = true end},
            {str = "lock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Inaba" isUnlockingAll = false end},
            {str = "", nosel = true},
        }
    },
    inabacompletion = {
        title = "inaba completion",
        fsize = 2,
        buttons = {
            {
                str = "mom's heart / it lives",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "inaba_heart",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.INABA, CompletionType.MOMS_HEART) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.INABA, CompletionType.MOMS_HEART, var - 1)
                end,

                tooltip = {strset = {"lil inaba", "", "unlocks on", "hard"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "isaac",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "inaba_isaac",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.INABA, CompletionType.ISAAC) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.INABA, CompletionType.ISAAC, var - 1)
                end,

                tooltip = {strset = {"acupuncture", "needles", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "???",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "inaba_bluebaby",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.INABA, CompletionType.BLUE_BABY) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.INABA, CompletionType.BLUE_BABY, var - 1)
                end,

                tooltip = {strset = {"crushing", "anxiety", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "satan",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "inaba_satan",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.INABA, CompletionType.SATAN) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.INABA, CompletionType.SATAN, var - 1)
                end,

                tooltip = {strset = {"paranoia", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "the lamb",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "inaba_lamb",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.INABA, CompletionType.LAMB) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.INABA, CompletionType.LAMB, var - 1)
                end,

                tooltip = {strset = {"phoenix elixir", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "boss rush",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "inaba_rush",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.INABA, CompletionType.BOSS_RUSH) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.INABA, CompletionType.BOSS_RUSH, var - 1)
                end,

                tooltip = {strset = {"sanguine", "salivation", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "hush",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "inaba_hush",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.INABA, CompletionType.HUSH) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.INABA, CompletionType.HUSH, var - 1)
                end,

                tooltip = {strset = {"hyperfixation", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "mega satan",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "inaba_megasatan",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.INABA, CompletionType.MEGA_SATAN) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.INABA, CompletionType.MEGA_SATAN, var - 1)
                end,

                tooltip = {strset = {"green bombs", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "ultra greed(ier)",
                choices = {"uncompleted", "completed: greed", "completed: greedier"},
                variable = "inaba_greed",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.INABA, CompletionType.ULTRA_GREEDIER) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.INABA, CompletionType.ULTRA_GREED, var - 1)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.INABA, CompletionType.ULTRA_GREEDIER, var - 1)
                end,

                tooltip = {strset = {"sertraline", "unlocks on", "greed+", "", "repression", "unlocks on", "greedier"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "delirium",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "inaba_delirium",
                setting = 1,

               load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.INABA, CompletionType.DELIRIUM) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.INABA, CompletionType.DELIRIUM, var - 1)
                end,

                tooltip = {strset = {"isolated", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "mother",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "inaba_mother",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.INABA, CompletionType.MOTHER) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.INABA, CompletionType.MOTHER, var - 1)
                end,

                tooltip = {strset = {"boundless", "parasol", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "beast",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "inaba_beast",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.INABA, CompletionType.BEAST) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.INABA, CompletionType.BEAST, var - 1)
                end,

                tooltip = {strset = {"dumb bunny", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "fiendish foes",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "inaba_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, FiendFolio.PLAYER.INABA)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(FiendFolio.PLAYER.INABA):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, FiendFolio.PLAYER.INABA)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(FiendFolio.PLAYER.INABA):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"hare-trigger", "", "unlocks on", "normal+"}}
			},
            {str = "", fsize = 1, nosel = true},
            {str = "rabbit's foot", nosel = true},
            {str = "unlocked by beating everything on hard", fsize = 1, nosel = true},
            {str = "", nosel = true},
        },
    },
    binabaunlocks = {
        title = "t. inaba unlocks",
        fsize = 2,
        buttons = {
            {str = "", nosel = true},
            {str = "completion note", fsize = 3, dest = "binabacompletion", tooltip = completionNoteTip},
            {str = "", nosel = true},
            {str = "-----------------", fsize = 3, nosel = true},
            {str = "", fsize = 1, nosel = true},
            {str = "item unlocks", fsize = 3, nosel = true},
            {str = "", fsize = 3, nosel = true},
            {insertUnlockTag = "Binaba"},
            {str = "", nosel = true},
            {str = "unlock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Binaba" isUnlockingAll = true end},
            {str = "lock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Binaba" isUnlockingAll = false end},
            {str = "", nosel = true},
        }
    },
	binabacompletion = {
        title = "t. inaba completion",
        fsize = 2,
        buttons = {
            {
                str = "mom's heart / it lives",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "binaba_heart",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BINABA, CompletionType.MOMS_HEART) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BINABA, CompletionType.MOMS_HEART, var - 1)
                end,

                tooltip = {strset = {"no unlock"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "isaac",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "binaba_isaac",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BINABA, CompletionType.ISAAC) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BINABA, CompletionType.ISAAC, var - 1)
                end,

                tooltip = {strset = {"lunatic eye", "", "quartet:", "beat isaac,", "???, satan", "and the lamb", "on normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "???",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "binaba_bluebaby",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BINABA, CompletionType.BLUE_BABY) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BINABA, CompletionType.BLUE_BABY, var - 1)
                end,

                tooltip = {strset = {"lunatic eye", "", "quartet:", "beat isaac,", "???, satan", "and the lamb", "on normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "satan",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "binaba_satan",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BINABA, CompletionType.SATAN) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BINABA, CompletionType.SATAN, var - 1)
                end,

                tooltip = {strset = {"lunatic eye", "", "quartet:", "beat isaac,", "???, satan", "and the lamb", "on normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "the lamb",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "binaba_lamb",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BINABA, CompletionType.LAMB) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BINABA, CompletionType.LAMB, var - 1)
                end,

                tooltip = {strset = {"lunatic eye", "", "quartet:", "beat isaac,", "???, satan", "and the lamb", "on normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "boss rush",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "binaba_rush",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BINABA, CompletionType.BOSS_RUSH) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BINABA, CompletionType.BOSS_RUSH, var - 1)
                end,

                tooltip = {strset = {"soul of", "inaba", "", "duet:", "beat boss", "rush and hush", "on normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "hush",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "binaba_hush",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BINABA, CompletionType.HUSH) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BINABA, CompletionType.HUSH, var - 1)
                end,

                tooltip = {strset = {"soul of", "inaba", "", "duet:", "beat boss", "rush and hush", "on normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "mega satan",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "binaba_megasatan",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BINABA, CompletionType.MEGA_SATAN) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BINABA, CompletionType.MEGA_SATAN, var - 1)
                end,

                tooltip = {strset = {"soul shard", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "ultra greed(ier)",
                choices = {"uncompleted", "completed: greed", "completed: greedier"},
                variable = "binaba_greed",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BINABA, CompletionType.ULTRA_GREEDIER) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BINABA, CompletionType.ULTRA_GREED, var - 1)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BINABA, CompletionType.ULTRA_GREEDIER, var - 1)
                end,

                tooltip = {strset = {"the invisible", "moon", "", "unlocks on", "greedier"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "delirium",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "binaba_delirium",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BINABA, CompletionType.DELIRIUM) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BINABA, CompletionType.DELIRIUM, var - 1)
                end,

                tooltip = {strset = {"ocular", "spectrum", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "mother",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "binaba_mother",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BINABA, CompletionType.MOTHER) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BINABA, CompletionType.MOTHER, var - 1)
                end,

                tooltip = {strset = {"sewing manual", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "beast",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "binaba_beast",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.BINABA, CompletionType.BEAST) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.BINABA, CompletionType.BEAST, var - 1)
                end,

                tooltip = {strset = {"bereavement", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "fiendish foes",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "binaba_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, FiendFolio.PLAYER.BINABA)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(FiendFolio.PLAYER.BINABA):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, FiendFolio.PLAYER.BINABA)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(FiendFolio.PLAYER.BINABA):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"shadow", "rabbits", "", "unlocks on", "normal+"}}
			}
        },
    },
    skeletalfiendunlocks = {
        title = "t. s. fiend unlocks",
        fsize = 2,
        buttons = {
            {str = "", nosel = true},
            {str = "completion note", fsize = 3, dest = "skeletalfiendcompletion", tooltip = completionNoteTip},
            {str = "", nosel = true},
            {str = "-----------------", fsize = 3, nosel = true},
            {str = "", fsize = 1, nosel = true},
            {str = "item unlocks", fsize = 3, nosel = true},
            {str = "", fsize = 3, nosel = true},
            {insertUnlockTag = "SkeletalFiendCompletion"},
            {str = "", fsize = 1, nosel = true},
            {insertUnlockTag = "SkeletalFiendAll"},
            {str = "", nosel = true},
            {str = "unlock all", dest = "areyousure", func = function() areYouSureUnlockTag = "SkeletalFiend" isUnlockingAll = true end},
            {str = "lock all", dest = "areyousure", func = function() areYouSureUnlockTag = "SkeletalFiend" isUnlockingAll = false end},
            {str = "", nosel = true},
        }
    },
    skeletalfiendcompletion = {
        title = "ts fiend completion",
        fsize = 2,
        buttons = {
            {
                str = "mom's heart / it lives",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "skeletalfiend_heart",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.SKELETAL_FIEND, CompletionType.MOMS_HEART) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.SKELETAL_FIEND, CompletionType.MOMS_HEART, var - 1)
                end,

                tooltip = {strset = {"baby", "", "unlocks on", "hard"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "isaac",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "skeletalfiend_isaac",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.SKELETAL_FIEND, CompletionType.ISAAC) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.SKELETAL_FIEND, CompletionType.ISAAC, var - 1)
                end,

                tooltip = {strset = {"the stars?", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "???",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "skeletalfiend_bluebaby",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.SKELETAL_FIEND, CompletionType.BLUE_BABY) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.SKELETAL_FIEND, CompletionType.BLUE_BABY, var - 1)
                end,

                tooltip = {strset = {"a poop", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "satan",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "skeletalfiend_satan",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.SKELETAL_FIEND, CompletionType.SATAN) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.SKELETAL_FIEND, CompletionType.SATAN, var - 1)
                end,

                tooltip = {strset = {"curved horn", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "the lamb",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "skeletalfiend_lamb",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.SKELETAL_FIEND, CompletionType.LAMB) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.SKELETAL_FIEND, CompletionType.LAMB, var - 1)
                end,

                tooltip = {strset = {"a better", "first item", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "boss rush",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "skeletalfiend_rush",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.SKELETAL_FIEND, CompletionType.BOSS_RUSH) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.SKELETAL_FIEND, CompletionType.BOSS_RUSH, var - 1)
                end,

                tooltip = {strset = {"a speed up", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "hush",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "skeletalfiend_hush",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.SKELETAL_FIEND, CompletionType.HUSH) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.SKELETAL_FIEND, CompletionType.HUSH, var - 1)
                end,

                tooltip = {strset = {"a shotspeed up", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "mega satan",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "skeletalfiend_megasatan",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.SKELETAL_FIEND, CompletionType.MEGA_SATAN) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.SKELETAL_FIEND, CompletionType.MEGA_SATAN, var - 1)
                end,

                tooltip = {strset = {"slot machine", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "ultra greed(ier)",
                choices = {"uncompleted", "completed: greed", "completed: greedier"},
                variable = "skeletalfiend_greed",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.SKELETAL_FIEND, CompletionType.ULTRA_GREEDIER) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.SKELETAL_FIEND, CompletionType.ULTRA_GREED, var - 1)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.SKELETAL_FIEND, CompletionType.ULTRA_GREEDIER, var - 1)
                end,

                tooltip = {strset = {"a penny", "unlocks on", "greed+", "", "another penny", "unlocks on", "greedier"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "delirium",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "skeletalfiend_delirium",
                setting = 1,

               load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.SKELETAL_FIEND, CompletionType.DELIRIUM) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.SKELETAL_FIEND, CompletionType.DELIRIUM, var - 1)
                end,

                tooltip = {strset = {"one firebone", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "mother",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "skeletalfiend_mother",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.SKELETAL_FIEND, CompletionType.MOTHER) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.SKELETAL_FIEND, CompletionType.MOTHER, var - 1)
                end,

                tooltip = {strset = {"his pet", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "beast",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "skeletalfiend_beast",
                setting = 1,

                load = function()
                    return Isaac.GetCompletionMark(FiendFolio.PLAYER.SKELETAL_FIEND, CompletionType.BEAST) + 1
                end,

                store = function(var)
                    Isaac.SetCompletionMark(FiendFolio.PLAYER.SKELETAL_FIEND, CompletionType.BEAST, var - 1)
                end,

                tooltip = {strset = {"mystery gift", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "fiendish foes",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "skeletalfiend_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, FiendFolio.PLAYER.SKELETAL_FIEND)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(FiendFolio.PLAYER.SKELETAL_FIEND):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, FiendFolio.PLAYER.SKELETAL_FIEND)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(FiendFolio.PLAYER.SKELETAL_FIEND):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"the ol'", "spicy keychain", "", "unlocks on", "normal+"}}
			},
            {str = "", fsize = 1, nosel = true},
            {str = "birthright", nosel = true},
            {str = "unlocked by beating everything on hard", fsize = 1, nosel = true},
            {str = "", nosel = true},
        },
    },
    finalbossunlocks = {
        title = "fiendish foes",
        fsize = 2,
        buttons = {
            {str = "", nosel = true},
            {str = "completion note", fsize = 3, dest = "finalbosscompletion", tooltip = completionNoteTip},
            {str = "", nosel = true},
            {str = "-----------------", fsize = 3, nosel = true},
            {str = "", fsize = 1, nosel = true},
            {insertUnlockTag = "MechaSatanVanilla"},
            {str = "", nosel = true},
            {str = "-----------------", fsize = 3, nosel = true},
            {str = "", fsize = 1, nosel = true},
            {insertUnlockTag = "MechaSatanTainted"},
            {str = "", nosel = true},
            {str = "-----------------", fsize = 3, nosel = true, displayif = function() return Epiphany and Epiphany.API end},
            {str = "", fsize = 1, nosel = true, displayif = function() return Epiphany and Epiphany.API end},
            {insertUnlockTag = "MechaSatanTarnished", displayif = function() return Epiphany and Epiphany.API end},
            {str = "", nosel = true, displayif = function() return Epiphany and Epiphany.API end},
            {str = "unlock all", dest = "areyousure", func = function() areYouSureUnlockTag = "MechaSatan" isUnlockingAll = true end},
            {str = "lock all", dest = "areyousure", func = function() areYouSureUnlockTag = "MechaSatan" isUnlockingAll = false end},
            {str = "", nosel = true},
        }
    },
	finalbosscompletion = {
        title = "fiendish completion",
        fsize = 2,
        buttons = {
            {
                str = "isaac",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "isaac_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_ISAAC)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_ISAAC):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_ISAAC)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_ISAAC):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"loaded d6", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "magdalene",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "magdalene_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_MAGDALENE)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_MAGDALENE):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_MAGDALENE)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_MAGDALENE):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"queen's fruit", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "cain",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "cain_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_CAIN)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_CAIN):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_CAIN)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_CAIN):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"happy squirrel", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "judas",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "judas_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_JUDAS)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_JUDAS):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_JUDAS)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_JUDAS):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"book of", "leviathan", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "???",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "bluebaby_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_BLUEBABY)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_BLUEBABY):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_BLUEBABY)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_BLUEBABY):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"nugget bombs", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "eve",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "eve_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_EVE)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_EVE):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_EVE)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_EVE):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"torture", "cookie", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "samson",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "samson_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_SAMSON)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_SAMSON):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_SAMSON)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_SAMSON):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"warfarin", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "azazel",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "azazel_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_AZAZEL)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_AZAZEL):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_AZAZEL)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_AZAZEL):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"shadow", "cluster", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "lazarus",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "lazarus_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_LAZARUS)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_LAZARUS):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_LAZARUS)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_LAZARUS):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"deadly dose", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "eden",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "eden_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_EDEN)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_EDEN):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_EDEN)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_EDEN):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"eden's head", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "the lost",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "lost_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_THELOST)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_THELOST):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_THELOST)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_THELOST):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"godhead jr.", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "lilith",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "lilith_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_LILITH)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_LILITH):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_LILITH)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_LILITH):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"earth of", "adam", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "the keeper",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "keeper_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_KEEPER)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_KEEPER):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_KEEPER)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_KEEPER):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"golden watch", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "apollyon",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "apollyon_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_APOLLYON)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_APOLLYON):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_APOLLYON)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_APOLLYON):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"owl feather", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "the forgotten",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "forgotten_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_THEFORGOTTEN)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_THEFORGOTTEN):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_THEFORGOTTEN)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_THEFORGOTTEN):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"bone lord's", "tablet", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "bethany",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "bethany_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_BETHANY)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_BETHANY):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_BETHANY)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_BETHANY):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"page of", "virtues", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "jacob and esau",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "jacob_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_JACOB)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_JACOB):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_JACOB)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_JACOB):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"doubles", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "fiend",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "fiend_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, FiendFolio.PLAYER.FIEND)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(FiendFolio.PLAYER.FIEND):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, FiendFolio.PLAYER.FIEND)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(FiendFolio.PLAYER.FIEND):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"fiend's lost", "friend", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "golem",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "golem_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, FiendFolio.PLAYER.GOLEM)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(FiendFolio.PLAYER.GOLEM):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, FiendFolio.PLAYER.GOLEM)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(FiendFolio.PLAYER.GOLEM):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"asteroid belt", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "friend",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "friend_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, FiendFolio.PLAYER.FRIEND)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(FiendFolio.PLAYER.FRIEND):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, FiendFolio.PLAYER.FRIEND)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(FiendFolio.PLAYER.FRIEND):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"friendly fire", "", "unlocks on", "normal+"}}
            },
            {str = "", nosel = true},
            {str = "-----------------", fsize = 3, nosel = true},
            {str = "", nosel = true},
			{
                str = "tainted isaac",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "bisaac_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_ISAAC_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_ISAAC_B):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_ISAAC_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_ISAAC_B):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"isaac'd's", "eulogy", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "tainted magdalene",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "bagdalene_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_MAGDALENE_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_MAGDALENE_B):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_MAGDALENE_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_MAGDALENE_B):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"appendix", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "tainted cain",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "bain_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_CAIN_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_CAIN_B):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_CAIN_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_CAIN_B):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"gaper in", "a jar", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "tainted judas",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "budas_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_JUDAS_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_JUDAS_B):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_JUDAS_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_JUDAS_B):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"executioner", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "tainted ???",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "bbluebaby_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_BLUEBABY_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_BLUEBABY_B):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_BLUEBABY_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_BLUEBABY_B):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"the brown", "horn", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "tainted eve",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "beve_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_EVE_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_EVE_B):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_EVE_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_EVE_B):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"bad blood", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "tainted samson",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "bamson_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_SAMSON_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_SAMSON_B):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_SAMSON_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_SAMSON_B):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"lil minx", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "tainted azazel",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "bazazel_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_AZAZEL_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_AZAZEL_B):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_AZAZEL_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_AZAZEL_B):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"hellfire", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "tainted lazarus",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "bazarus_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_LAZARUS_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_LAZARUS_B):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_LAZARUS_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_LAZARUS_B):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"lourdes", "water", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "tainted eden",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "beden_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_EDEN_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_EDEN_B):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_EDEN_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_EDEN_B):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"nil pasta", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "tainted lost",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "bost_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_THELOST_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_THELOST_B):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_THELOST_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_THELOST_B):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"cross", "necklace", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "tainted lilith",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "bilith_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_LILITH_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_LILITH_B):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_LILITH_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_LILITH_B):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"blastulation", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "tainted keeper",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "beeper_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_KEEPER_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_KEEPER_B):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_KEEPER_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_KEEPER_B):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"d2", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "tainted apollyon",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "bapollyon_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_APOLLYON_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_APOLLYON_B):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_APOLLYON_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_APOLLYON_B):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"musca", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "tainted forgotten",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "borgotten_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_THEFORGOTTEN_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_THEFORGOTTEN_B):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_THEFORGOTTEN_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_THEFORGOTTEN_B):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"double dog", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "tainted bethany",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "bbethany_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_BETHANY_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_BETHANY_B):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_BETHANY_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_BETHANY_B):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"acheron", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "tainted jacob",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "bacob_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_JACOB_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_JACOB_B):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, PlayerType.PLAYER_JACOB_B)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(PlayerType.PLAYER_JACOB_B):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"monster", "domestication", "guide", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "tainted fiend",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "biend_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, FiendFolio.PLAYER.BIEND)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(FiendFolio.PLAYER.BIEND):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, FiendFolio.PLAYER.BIEND)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(FiendFolio.PLAYER.BIEND):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"huitlacoche", "", "unlocks on", "normal+"}}
            },
            {str = "", fsize = 1, nosel = true},
            {
                str = "tainted golem",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "bolem_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, FiendFolio.PLAYER.BOLEM)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(FiendFolio.PLAYER.BOLEM):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, FiendFolio.PLAYER.BOLEM)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(FiendFolio.PLAYER.BOLEM):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"copper bar", "", "unlocks on", "normal+"}}
            },
            {str = "", nosel = true},
            {
                str = "tainted friend",
                choices = {"uncompleted", "completed: normal", "completed: hard"},
                variable = "briend_fiendish_foes",
                setting = 1,

                load = function()
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, FiendFolio.PLAYER.BRIEND)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(FiendFolio.PLAYER.BRIEND):IsTainted() and "-Tainted") or "")
                    return (FiendFolio.savedata.mechaSatanCompletion[saveID] or 0) + 1
                end,

                store = function(var)
					local xmlEntry = XMLData.GetEntryById(XMLNode.PLAYER, FiendFolio.PLAYER.BRIEND)
					local saveID = xmlEntry.sourceid .. "-" .. xmlEntry.name .. ((EntityConfig.GetPlayer(FiendFolio.PLAYER.BRIEND):IsTainted() and "-Tainted") or "")
                    FiendFolio.savedata.mechaSatanCompletion[saveID] = var - 1
                end,

                tooltip = {strset = {"magic bullet", "", "unlocks on", "normal+"}}
            },
            {str = "", nosel = true},
        },
    },
    allclearunlocks = {
        title = "full marks",
        fsize = 2,
        buttons = {
            {str = "", nosel = true},
			{insertUnlockTag = "AllClear"},
            {str = "", nosel = true},
            {str = "unlock all", dest = "areyousure", func = function() areYouSureUnlockTag = "AllClear" isUnlockingAll = true end},
            {str = "lock all", dest = "areyousure", func = function() areYouSureUnlockTag = "AllClear" isUnlockingAll = false end},
            {str = "", nosel = true},
        }
    },
    challengeunlocks = {
        title = "challenges",
        fsize = 2,
        buttons = {
            {str = "", nosel = true},
			{insertUnlockTag = "ChallengeUnlock"},
            {str = "", nosel = true},
            {str = "unlock all", dest = "areyousure", func = function() areYouSureUnlockTag = "ChallengeUnlock" isUnlockingAll = true end},
            {str = "lock all", dest = "areyousure", func = function() areYouSureUnlockTag = "ChallengeUnlock" isUnlockingAll = false end},
            {str = "", nosel = true},
        }
    },
	challengerewards = {
        title = "challenge rewards",
        fsize = 2,
        buttons = {
            {str = "", nosel = true},
            {str = "completion unlocks", fsize = 3, nosel = true},
            {str = "", nosel = true},
			{insertUnlockTag = "ChallengeReward"},
            {str = "", nosel = true},
            {str = "unlock all", dest = "areyousure", func = function() areYouSureUnlockTag = "ChallengeReward" isUnlockingAll = true end},
            {str = "lock all", dest = "areyousure", func = function() areYouSureUnlockTag = "ChallengeReward" isUnlockingAll = false end},
            {str = "", nosel = true},
            {str = "-----------------", fsize = 3, nosel = true},
            {str = "", nosel = true},
            {str = "other unlocks", fsize = 3, nosel = true},
            {str = "", nosel = true},
			{insertUnlockTag = "ChallengeMisc"},
            {str = "", nosel = true},
            {str = "unlock all", dest = "areyousure", func = function() areYouSureUnlockTag = "ChallengeMisc" isUnlockingAll = true end},
            {str = "lock all", dest = "areyousure", func = function() areYouSureUnlockTag = "ChallengeMisc" isUnlockingAll = false end},
            {str = "", nosel = true},
        }
    },
	backdropunlocks = {
        title = "backdrops",
        fsize = 2,
        buttons = {
            {str = "", nosel = true},
			{insertUnlockTag = "Backdrop"},
            {str = "", nosel = true},
            {str = "unlock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Backdrop" isUnlockingAll = true end},
            {str = "lock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Backdrop" isUnlockingAll = false end},
            {str = "", nosel = true},
        }
    },
	miscunlocks = {
        title = "miscellaneous",
        fsize = 2,
        buttons = {
            {str = "", nosel = true},
			{insertUnlockTag = "Misc"},
            {str = "", nosel = true},
            {str = "unlock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Misc" isUnlockingAll = true end},
            {str = "lock all", dest = "areyousure", func = function() areYouSureUnlockTag = "Misc" isUnlockingAll = false end},
            {str = "", nosel = true},
        }
    },
	areyousure = {
        title = "are you sure?",
        buttons = {
            {str = "", nosel = true},
            {str = "", nosel = true},
            {str = "no", action = "back", glowcolor = 3},
            {str = "", fsize = 2, nosel = true},
            {
                str = "yes",
                action = "back",

                func = function(button, item, root)
					if DeadSeaScrollsMenu.OpenedMenu and DeadSeaScrollsMenu.OpenedMenu.DirectoryKey.SettingsChanged then
						DeadSeaScrollsMenu.OpenedMenu.DirectoryKey.SettingsChanged = false
						for k, item in pairs(DeadSeaScrollsMenu.OpenedMenu.Directory) do
							if item.buttons then
								for _, button in ipairs(item.buttons) do
									if button.store and button.variable then
										button.store(DeadSeaScrollsMenu.OpenedMenu.DirectoryKey.Settings[button.variable] or button.setting, button, item, DeadSeaScrollsMenu.OpenedMenu)
									end
								end
							end
						end
					end
					
                    local achievements = FiendFolio.GetAchievementsWithTag(areYouSureUnlockTag)
					FiendFolio.ForceUnlockNoNote = true
                    for _, achievement in ipairs(achievements) do
						local isInabaUnlock = false
						for _, tag in ipairs(achievement.Tags) do
							if tag == "Inaba" or tag == "Binaba" or tag == "AllClear" or tag == "InabaHidden" then
								isInabaUnlock = true
								break
							end
						end
                        if isUnlockingAll == true and (FiendFolio.ACHIEVEMENT.INABA:IsUnlocked(true) or not isInabaUnlock or
						                               areYouSureUnlockTag == "Inaba" or areYouSureUnlockTag == "Binaba" or areYouSureUnlockTag == "AllClear")
						then
                            achievement:Unlock(true)
                        else
                            achievement:SetUnlocked(false)
                        end
                    end
					FiendFolio.ForceUnlockNoNote = nil

                    dssmod.reloadButtons(root, root.Directory.characterunlocks)
                    dssmod.reloadButtons(root, root.Directory.fiendunlocks)
                    dssmod.reloadButtons(root, root.Directory.biendunlocks)
                    dssmod.reloadButtons(root, root.Directory.golemunlocks)
                    dssmod.reloadButtons(root, root.Directory.bolemunlocks)
                    dssmod.reloadButtons(root, root.Directory.friendunlocks)
                    dssmod.reloadButtons(root, root.Directory.briendunlocks)
                    dssmod.reloadButtons(root, root.Directory.inabaunlocks)
                    dssmod.reloadButtons(root, root.Directory.binabaunlocks)
                    dssmod.reloadButtons(root, root.Directory.skeletalfiendunlocks)
                    dssmod.reloadButtons(root, root.Directory.finalbossunlocks)
                    dssmod.reloadButtons(root, root.Directory.allclearunlocks)
                    dssmod.reloadButtons(root, root.Directory.challengeunlocks)
                    dssmod.reloadButtons(root, root.Directory.challengerewards)
                    dssmod.reloadButtons(root, root.Directory.backdropunlocks)
                    dssmod.reloadButtons(root, root.Directory.miscunlocks)
                    dssmod.reloadButtons(root, root.Directory.unlocksmanager)
                end,
            },

            {str = "", nosel = true},
            {str = "you will have to start a new run in", nosel = true, fsize = 1, glowcolor = 3},
            {str = "order for these changes to take effect", nosel = true, fsize = 1, glowcolor = 3},
        },
    },
    unlockspopup = {
        title = "achievements?",
        fsize = 1,
        buttons = {
            {str = "fiendfolio comes with a large list", nosel = true},
            {str = "of unlockables for you to discover", nosel = true},
            {str = "", nosel = true},
            {str = "this is an optional feature", nosel = true},

            {str = "", nosel = true},
            {str = "do you want to lock", fsize = 2, nosel = true},
            {str = "our content behind", fsize = 2, nosel = true},
            {str = "achievements?", fsize = 2, nosel = true},
            {str = "", nosel = true},
            {
                str = "yes",
                action = "resume",
                fsize = 3,
                glowcolor = 3,

                func = function()
                    FiendFolio.savedata.disableAchievements = false
                    FiendFolio.savedata.shownUnlocksChoicePopup = true
                end,
            },
            {
                str = "no",
                action = "resume",
                fsize = 3,

                func = function(button, item, root)
                    FiendFolio.savedata.disableAchievements = true
                    FiendFolio.savedata.shownUnlocksChoicePopup = true

                    SFXManager():Play(SoundEffect.SOUND_FART)
                end
            },

            {str = "", nosel = true},
            {str = "you can change this later in our mod menu", nosel = true},
        },

        tooltip = {strset = {"you can", "change this", "later"}},
    },
	credits = {
        title = 'credits',
        fsize = 1,
        buttons = {
        }
    }
}

local function insertUnlockTags(item)
    for i, v in ipairs(item.buttons) do
        if v.insertUnlockTag then
            local buttons = FiendFolio.GetMenuButtonsForAchievementTag(v.insertUnlockTag)
            for b, button in ipairs(buttons) do
                table.insert(item.buttons, i + b, button)
            end
        end
    end

    for i = #item.buttons, 1, -1 do
        local v = item.buttons[i]
        if v.insertUnlockTag then
            table.remove(item.buttons, i)
        end
    end
end

insertUnlockTags(fiendfoliodirectory.unlocksmanager)
insertUnlockTags(fiendfoliodirectory.characterunlocks)
insertUnlockTags(fiendfoliodirectory.fiendunlocks)
insertUnlockTags(fiendfoliodirectory.biendunlocks)
insertUnlockTags(fiendfoliodirectory.golemunlocks)
insertUnlockTags(fiendfoliodirectory.bolemunlocks)
insertUnlockTags(fiendfoliodirectory.friendunlocks)
insertUnlockTags(fiendfoliodirectory.briendunlocks)
insertUnlockTags(fiendfoliodirectory.inabaunlocks)
insertUnlockTags(fiendfoliodirectory.binabaunlocks)
insertUnlockTags(fiendfoliodirectory.skeletalfiendunlocks)
insertUnlockTags(fiendfoliodirectory.finalbossunlocks)
insertUnlockTags(fiendfoliodirectory.allclearunlocks)
insertUnlockTags(fiendfoliodirectory.challengeunlocks)
insertUnlockTags(fiendfoliodirectory.challengerewards)
insertUnlockTags(fiendfoliodirectory.backdropunlocks)
insertUnlockTags(fiendfoliodirectory.miscunlocks)

FiendFolio.DSS_DIRECTORY = fiendfoliodirectory
FiendFolio.DSS_MOD = dssmod

local fiendfoliodirectorykey = {
    Item = fiendfoliodirectory.main,
    Main = 'main',
    Idle = false,
    MaskAlpha = 1,
    Settings = {},
    SettingsChanged = false,
    Path = {},
}

DeadSeaScrollsMenu.AddMenu("Fiend Folio", {Run = dssmod.runMenu, Open = dssmod.openMenu, Close = dssmod.closeMenu, Directory = fiendfoliodirectory, DirectoryKey = fiendfoliodirectorykey})

DeadSeaScrollsMenu.AddPalettes({
    {
        Name = "bubbly",
        {145, 188, 191}, -- Back
        {0, 65, 82}, -- Text
        {0, 106, 146}, -- Highlight Text
    },
    {
        Name = "bustin'",
        {102, 65, 55},
        {255, 138, 0},
        {255, 197, 0},
    },
    {
        Name = "expensive",
        {215, 162, 55},
        {255, 214, 141},
        {255, 255, 255},
    },
    {
        Name = "friendly",
        {215, 94, 53},
        {135, 60, 146},
        {182, 39, 203},
    },
    {
        Name = "inky",
        {79, 80, 89},
        {191, 148, 61},
        {205, 182, 133},
    },
    {
        Name = "load mega",
        {121, 79, 57},
        {188, 146, 100},
        {211, 187, 153},
    },
    {
        Name = "scar tissue",
        {190, 173, 172},
        {149, 59, 70},
        {129, 50, 55},
    },
    {
        Name = "honeyed",
        {198, 170, 89},
        {47, 48, 63},
        {89, 48, 38},
    },
    {
        Name = "wart",
        {77, 84, 63},
        {110, 122, 79},
        {162, 165, 100},
    },
    {
        Name = "watered down",
        {175, 178, 198},
        {86, 88, 120},
        {67, 73, 122},
    }
})
