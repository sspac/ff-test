local fiendfoliodirectory = FiendFolio.DSS_DIRECTORY
local dssmod = FiendFolio.DSS_MOD

local credits = {
    --[[
    {str = "team folio", nosel = true, fsize = 1},
    {"fiend", "mod lead", tooltip = {"v", "'u'"}},
	"",
    {"budj", "coder", tooltip = {"buster is", "not that", "hard"}},
    {"blorengerhymes", "spriter, coder", tooltip = {"with orange"}},
    {"bustin blotch", "tester"},
    {"cadence (ciirulean)", "spriter", tooltip = {"arbiter of", " death and", "fuzz"}},
    {"cake", "coder"},
    {"cometz", "spriter", tooltip = {"i got", "lucky"}},
    {"connor", "coder"},
    {"creeps", "spriter", tooltip = {"can i get", "back to you", "on that"}},
    {"deadinfinity", "coder", tooltip = {"please eat", "all of my", "lovely", "ghosts"}},
    {"erfly", "coder", tooltip = {"isaac curse", "is real"}},
    {"ferrium", "coder, spriter", tooltip = {"wait, we", "get quotes?"}},
    {"fuyucchi (maria)", "spriter", tooltip = {"move and", "i'll shoot!", "", "i messed up.", "", "i mean,", "shoot and", "i'll move!"}},
    {"guillotine-21", "coder, spriter"},
    {"gummy", "spriter", tooltip = {"oh right", "i made stuff", "for it"}},
	{"guwahavel", "coder, spriter", tooltip = {"the quirky", "antibirth", "inspired", "isaac mod"}},
    {"happyhead", "spriter, sounds, 3d", tooltip = {"oh um"}},
    {"jerb", "coder"},
    {"jm2k (julia)", "coder, spriter", tooltip = {"estranged", "mother of", "buck"}},
    {"redrachis", "spriter, voices", tooltip = {"proponent of", "dogtology"}},
    {"jordy", "tester"},
    {"melon", "devil's harvest"},
    {"minichibis", "founder, coder, spriter", tooltip = {"haha whee"}},
    {"notyoursagittarius", "spriter"},
    {"orisghost", "spriter"},
    {"oroshibu", "coder"},
    {"peas", "spriter, voices", tooltip = {"creator of", "antibirth"}},
    {"pixelo", "spriter",  tooltip = {"thank you", "erflyy for", "squirty sunday"}},
	{"pkpseudo", "spriter", tooltip = {"every pk", "has its", "mausoleum"}},
	{"poyo", "spriter", tooltip = {"uhh", "i don't know"}},
    {"renren", "music", tooltip = {"victim 4"}},
    {"sadly just al", "spriter", tooltip = {"poopy boner"}},
    {"sbody2", "coder, spriter", tooltip = {"", "", "", "", "", "", "", "bottom text"}},
    {"snakeblock", "coder, spriter"},
    {"sunil_b", "spriter", tooltip = {"go to the", "dark room", "", "i beg of you"}},
    {"taigatreant", "coder", tooltip = {"hmm", "i'll have to", "think on that"}},
    {"thx", "co-founder, spriter"},
    {"titaniumgrunt7 (vermin)", "spriter", tooltip = {"aha! you", "read my spell,", "now i have", "all your", "powers!"}},
    {"xalum", "coder", tooltip = {"last seen:", "sept. 2019", "", "call", "07944 xxxxxx", "if located"}},
    "",
	{"almost everyone", "rooms", tooltip = {"especially", "sadly just al,", "sunil_b", "and vermin"}},
	{"mern", "mern, traitor", tooltip = {"mern"}},
	{"peribot", "moral support", tooltip = {"evil"}},
	"",]]
    {str = "special thanks to", fsize = 2, nosel = true},
    "",
    "community credits",
    "",
    {"attfooy", "enemy designer", tooltip = {"nihilist"}},
    {"badsytheedgecat", "trinket designer", tooltip = {"switch penny"}},
    {"beatrixharper", "guest spriter", tooltip = {"costumes"}},
    {"blanthos ", "trinket designer", tooltip = {"charitable","penny"}},
    {"blueresonant ", "item designer", tooltip = {"lemon mishuh?"}},
    {"bluthescrappyfigure", "enemy designer", tooltip = {"techneedle"}},
    {"brie", "trinket designer", tooltip = {"leftovers"}},
    {"buh", "guest spriter + designer", tooltip = {"suave", "and urbane"}},
    {"burguer king", "item designer", tooltip = {"the strongest", "geode","warden's"," crown", "green apple", "nursing", "brazilian penny"}},
    {"camille (cyancan1)", "enemy designer", tooltip = {"friend horse"}},
    {"cubesjr32", "item designer", tooltip = {"mime degree", "golem's sub", "poop penny", "slippery penny", "red penny", "puck penny", "calcium penny"}},
    {"cuerzor", "guest spriter", tooltip = {"eid icons"}},
    {"deli3345 ", "trinket designer", tooltip = {"pretty penny", "stained card",}},
    {"dokodemo nephilim", "item designer", tooltip = {"spade of clubs", "", "shadow", "cluster"}},
    {"ferpe", "guest spriter", tooltip = {"congregation"}},
    {"fork guy", "enemy desginer", tooltip = {"gritty"}},
    {"galrosalina", "guest spriter", tooltip = {"ugh costumes"}},
    {"gelehed", "trinket designer", tooltip = {"faded card"}},
    {"goosecultist", "trinket desginer", tooltip = {"dud's flower"}},
    {"gumfondle", "item designer", tooltip = {"spelling bee"}},
    {"grunchtastic", "trinket designer", tooltip = {"bent penny"}},
    {"hairy", "enemy designer", tooltip = {"matte", "free thinker"}},
    {"haloway", "item designer", tooltip = {"error's", "crazy slots"}},
    {"hooviey", "item designer", tooltip = {"warden's"," crown"}},
    {"jj", "guest spriter", tooltip = {"zephyr"}},
    {"jovial", "card designer", tooltip = {"seal of", "orichalcos"}},
    {"jubbalub", "trinket designer", tooltip = {"angry faic"}},
    {"koo", "joke enemy + trinket designer", tooltip = {"grinner", "hollow card",}},
    {"matzie", "guest spriter", tooltip = {"minimap icons"}},
    {"ouravantgarde", "trinket designer", tooltip = {"button masher"}},
    {"pasta", "guest spriter + designer", tooltip = {"spoop"}},
    {"pdaexpert", "trinket designer", tooltip = {"shroomite", "gravel"}},
    {"pemthebun", "trinket designer", tooltip = {"locked shackle"}},
    {"rolly polly", "guest spriter", tooltip = {"costumes"}},
    {"select-o-matic", "spriter + designer", tooltip = {"rosie and posie", "infestation 0"}}, --written as "spriter and designer" instead of "guest spriter and designer" for legibility's sakes
    {"shanepatsmith", "voice acting", tooltip = {"voiceovers for", "consumable", "items"}},
    {"shuaner", "guest spriter + designer", tooltip = {"jammed,", "hostlet", "pet peeve", "large dose"}},
    {"somebunny", "guest spriter + designer", tooltip = {"trollface","penny", "crowded card",}},
    {"sqid_official", "spriter + designer", tooltip = {"infested","pipeline",}},
    {"sweet", "guest spriter + designer", tooltip = {"grinner", "cubert", "lithopedian", "onion rock"}},
    {"tabvee", "inspiration", tooltip = {"redacted", "triangle", "gang rise up"}},
    {"tiburones202", "descriptions", tooltip = {"t. blue baby", "external item", "descriptions"}},
    {"toast but cereal", "item designer", tooltip = {"baby bell"}},
    {"thewizardslime", "trinket designer", tooltip = {"devious penny", "miniature card"}},
    {"voxelroguery", "item designer", tooltip = {"empty gaze", "earth impale", "map penny", "link cable",}},
    {"waste of time", "guest spriter", tooltip = {"medley penny"}},
	{"watchmeojo", "item designer", tooltip = {"bottle of", "water"}},
	{"wibi", "sound designer", tooltip = {"soul of fiend", "sentence","mixing"}},
	{"xxnobody", "guest coder", tooltip = {"chapi features", "and fixes"}},
    "",
    "everyone who contributed",
	"rooms or fortunes",
    "",
    "stronger than golem",
    "",
    {"alter", "",  tooltip = {"lost artifact"}},
    {"danial", "", tooltip = {"pocket rock-it"}},
    {"dastarod", "", tooltip = {"ridiculous", "metal"}},
    {"gabe", "", tooltip = {"atlas' burden"}},
    {"honeyfox", "", tooltip = {"wormhole", "rock"}},
    "",
    "additional thanks",
    "",
	{"appa", "tale of samuel, spinach pie"},
	{"barack obama", "thanks!"},
	{"baicherra", "rigor mortis", tooltip = {"fire fly", "sprites"}},
	{"breadmeat531", ""},
	{"cathery", "devil's harvest"},
	{"circusqueen", "trans brimstone"},
	{"creeps", "former dev"},
    {"conjunction", ""},
	{"dogjoneswildson", ""},
	{"drtapeworm", ""},
	{"eden", "placed pill"},
	{"electoon", ""},
	{"emffles", "teraphobia"},
	{"filloax", "morbus"},
	{"finglebar", "devil's harvest", tooltip = {"joke game", "over music", "", "risus", "(you died)"}},
	{"gabe newell", "steam", tooltip = {"and my","favorite mod", "is the fly", "saac", "", "thanks!", "and", "have fun!"}},
    {"itsthetalia", "brutal orchestra", tooltip = {"the crossover", "", "dried paint", "and","clown meat"}},
    {"kerkel", "coding support", tooltip = {"old room", "compat script", "that went", "unused when", "repentogon", "added stb", "loading"}},
    {"ketchup bottle", "voice actor", tooltip = {"shampoo", "bottle", "voice actor"}},
	{"kilburn", "sprites", tooltip = {"fiend", "co-op select", "", "devil's harvest", "item sprite"}},
    {"klester", "cacamancer va"},
	{"lung", "heretic mod"},
    {"melon", "devil's harvest"},
    {"mern", "mern, traitor", tooltip = {"mern"}},
    {"noodle", "modding of isaac"},
	{"rob franzese", "acting", tooltip = {"real life", "peter griffin"}},
    {"rufia", "rigor mortis", tooltip = {"clod design"}},
	{"rustybucket", "visual design", tooltip = {"robo-baby 3.0", "appearance"}},
    {"scrake", "the bosses mod", tooltip = {"high amon", "and", "the baron"}},
	{"sissi6", "", tooltip = {"beans"}},
	{"springboi", "devil's harvest", tooltip = {"give download", "to the devil", "harvest mod"}},
    {"suppermariobroth"},
	{"tealx", ""},
	{"toby fox", "undertale"},
	{"w.d. gaster", "deltarune", tooltip = {"my","golden battie"}},
	{"wuggy", "sprites", tooltip = {"emoji glasses", "item sprite", "and costume"}},
	{"xnami", "devil's harvest", tooltip = {"firecracker", "sprite"}},
    {"zizou", "gimmiko"},
    "",
	"thank you too to the",
	"people who responded to our",
	"tweets and discord posts",
	"",
    {ShowFlag = true},
    "you all made it fun for us",
    "",
	{"greeb", "production baby", tooltip = {"ayy lmao"}},
	{"shampoo bottle", "production baby", tooltip = {"he doesn't", "freaking", "shut up"}},
	"",
	"",
}

local devs = {
    bustin = {
        name = "bustin",
        subname = "(bustin blotch)",
        subheader = "tester",
        pos = Vector(303, 171),
        row = 8,
        col = 11
    },
    pixl = {
        name = "pixl",
        subheader = "spriter",
        tooltip = {"thank you", "erflyy for", "squirty sunday"},
        pos = Vector(172, 165),
        row = 7,
        col = 5
    },
    guillotine = {
        name = "guillotine",
        subname = "(guillotine-21)",
        subheader = "coder, spriter",
        pos = Vector(230, 152),
        row = 7,
        col = 7
    },
    thx = {
        name = "thx",
        subheader = "cofounder, spriter",
        pos = Vector(113, 143),
        row = 6,
        col = 4
    },
    pkpseudo = {
        name = "pkpseudo",
        subheader = "spriter",
        tooltip = {"every pk", "has its", "mausoleum"},
        pos = Vector(96, 162),
        ySortOffset = 10,
        row = 6,
        col = 3
    },
    guwah = {
        name = "guwahavel",
        subheader = "coder, spriter",
        tooltip = {"professional", "nitpicker"},
        pos = Vector(259, 20),
        row = 3,
        col = 10,
    },
    mini = {
        name = "minichibis",
        subheader = "founder, coder, spriter",
        tooltip = {"i'm like this"},
        pos = Vector(169, 97),
        row = 4,
        col = 6
    },
    connor = {
        name = "connor",
        subname = "(ghostbroster)",
        subheader = "coder",
        tooltip = {"my", "", "lua"},
        pos = Vector(252, 151),
        row = 7,
        col = 8
    },
    budj = {
        name = "budj",
        subheader = "coder",
        tooltip = {"buster is", "not that", "hard"},
        pos = Vector(321, 39),
        ySortOffset = 100,
        row = 3,
        col = 12
    },
    cadence = {
        name = "cadence",
        subname = "(ciirulean)",
        subheader = "spriter",
        tooltip = {"arbiter of", " death and", "fuzz"},
        pos = Vector(146, 80),
        row = 4,
        col = 5
    },
    julia = {
        name = "jm2k",
        subname = "(julia)",
        subheader = "coder, spriter",
        tooltip = {"estranged", "mother of", "buck"},
        pos = Vector(139, 151),
        row = 6,
        col = 5
    },
    sunil = {
        name = "sunil_b",
        subheader = "spriter, rooms!",
        tooltip = {"go to the", "dark room", "", "i beg of you"},
        pos = Vector(39, 54),
        row = 3,
        col = 2,
    },
    blor = {
        name = "blorenge",
        subname = "(blorengerhymes)",
        subheader = "spriter, coder",
        tooltip = {"with orange"},
        pos = Vector(334, 141),
        row = 7,
        col = 12
    },
    al = {
        name = "al",
        subname = "(sadly just al)",
        subheader = "spriter, rooms!",
        tooltip = {"(pinchy fingers)", '"ua"'},
        pos = Vector(254, 113),
        ySortOffset = 20,
        row = 6,
        col = 9
    },
    sbody = {
        name = "sbody2",
        subheader = "coder, spriter",
        tooltip = {"", "", "", "", "", "bottom text"},
        pos = Vector(311, 134),
        ySortOffset = 30,
        row = 7,
        col = 11
    },
    ren = {
        name = "renren",
        subheader = "music, spriter",
        tooltip = {"victim 4"},
        pos = Vector(299, 50),
        row = 3,
        col = 11
    },
    vermin = {
        name = "vermin",
        subname = "(titaniumgrunt7)",
        subheader = "spriter",
        tooltip = {"aha! you", "read my spell,", "now i have", "all your", "powers!"},
        pos = Vector(67, 158),
        row = 6,
        col = 2
    },
    gummy = {
        name = "gummy",
        subheader = "spriter",
        tooltip = {"oh right", "i made stuff", "for it"},
        pos = Vector(283, 143),
        row = 7,
        col = 9
    },
    maria = {
        name = "foxgirlyuri",
        subname = "(maria)",
        subheader = "spriter, musician, coder",
        tooltip = {"move and", "i'll shoot!", "", "i messed up.", "", "i mean,", "shoot and", "i'll move!"},
        pos = Vector(35, 151),
        row = 6,
        col = 1
    },
    cake = {
        name = "cake",
        subheader = "coder",
		tooltip = {"feel weirb"},
        pos = Vector(25, 126),
        row = 5,
        col = 1
    },
    dead = {
        name = "dead",
        subheader = "coder",
        tooltip = {"i made", "this menu!"},
        pos = Vector(321, 105),
        row = 6,
        col = 11
    },
    oroshibu = {
        name = "oroshibu",
        subheader = "coder",
        pos = Vector(76, 122),
        row = 5,
        col = 3
    },
    xalum = {
        name = "xalum",
        subheader = "coder",
        tooltip = {"last seen:", "sept. 2019", "", "call", "07944 xxxxxx", "if found"},
        pos = Vector(56, 114),
        row = 5,
        col = 2
    },
    cometz = {
        name = "cometz",
        subheader = "spriter, voices",
        tooltip = {"a very manly", "muppet"},
        pos = Vector(56, 87),
        row = 4,
        col = 2
    },
    peas = {
        name = "peas",
        subheader = "spriter, voices",
        tooltip = {"creator of", "antibirth"},
        pos = Vector(292, 124),
        row = 6,
        col = 10
    },
    redrachis = {
        name = "redrachis",
        subheader = "spriter, voices",
        tooltip = {"proponent of", "dogtology"},
        pos = Vector(278, 97),
        row = 5,
        col = 10
    },
    happyhead = {
        name = "hapty",
        subheader = "spriter, sounds, 3d",
        tooltip = {"oh um"},
        pos = Vector(294, 81),
        row = 4,
        col = 11
    },
    snake = {
        name = "snakeblock",
        subheader = "coder, spriter",
        pos = Vector(65, 21),
        row = 2,
        col = 2
    },
    poyo = {
        name = "poyo",
        subheader = "spriter",
        tooltip = {"uhh", "i don't know"},
        pos = Vector(127, 115),
        row = 5,
        col = 5
    },
    erfly = {
        name = "erfly",
        subheader = "coder, bit of everythin'",
        tooltip = {"isaac curse", "is real"},
        pos = Vector(154, 117),
        row = 5,
        col = 6
    },
    funkengine = {
        name = "funkengine",
        subheader = "tester",
        pos = Vector(93, 110),
        row = 5,
        col = 4
    },
    taiga = {
        name = "taigatreant",
        subheader = "coder",
        tooltip = {"lost in the", "custom health", "mines"},
        pos = Vector(225, 129),
        row = 6,
        col = 8,
    },
    jordy = {
        name = "jordy",
        subheader = "tester",
        pos = Vector(188, 127),
        row = 6,
        col = 6
    },
    ori = {
        name = "orisghost",
        subheader = "spriter",
        pos = Vector(240, 88),
        row = 5,
        col = 9
    },
    jerb = {
        name = "jerb",
        subheader = "coder",
        pos = Vector(268, 74),
        row = 4,
        col = 10
    },
    ferrium = {
        name = "ferrium",
        subheader = "coder, spriter",
        tooltip = {"i'll put in a", "quote later"},
        pos = Vector(112, 91),
        row = 4,
        col = 4
    },
    sin = {
        name = "sin",
        subheader = "rooms!",
        pos = Vector(86, 69),
        row = 4,
        col = 3
    },
    jd = {
        name = "jd",
        subheader = "coder, voices",
        tooltip = {"jd was here"},
        pos = Vector(85, 37),
        row = 2,
        col = 3
    },
    --[[
    sag = {
        pos = Vector(361, 93)
    },]]
    sag = {
        name = "sag",
        subname = "(notyoursagittarius)",
        subheader = "spriter",
        pos = Vector(340, 97),
        row = 6,
        col = 12
    },
    hippo = {
        name = "hippocrunchy",
        subheader = "coder, spriter, rooms",
        tooltip = {"i don't even", "get it"},
        pos = Vector(14, 27),
        row = 2,
        col = 1,
    },
    amy = {
        name = "amy",
        subname = "(love_amy)",
        subheader = "rooms",
        pos = Vector(328, 69),
        row = 4,
        col = 12
    },
    oily = {
        name = "oilyspoily",
        subheader = "rooms, fortunes",
        tooltip = {"that's a", "new fortune!"},
        pos = Vector(238, 61),
        row = 4,
        col = 9
    },
    catinsurance = {
        name = "catinsurance",
        subheader = "coder, spriter, voices",
        tooltip = {"bow", "wow", "wow!"},
        pos = Vector(207, 87),
        row = 4,
        col = 8
    },
    pixelplz = {
        name = "pixelplz",
        subheader = "coder, spriter",
        tooltip = { "the embryo", "emperor", },
        pos = Vector(291, 8),
        ySortOffset = 20,
        row = 2,
        col = 11,
    },
    instrumentalfriendhellfirejunebeah = { --thanks cometz LOL
        name = "junebeah",
        subname = "(hellfirebeah)",
        subheader = "spriter, coder",
        tooltip = {"i have nothing", "but my skibidi"},
        pos = Vector(20, 84),
        row = 4,
        col = 1,
    },
    nari = {
        name = "narillia",
        subheader = "spriter",
        tooltip = {"i'm not even", "supposed to", "be here!"},
        pos = Vector(202, 157),
        row = 7,
        col = 6
    },
    conboi = {
        name = "conboi",
        subheader = "spriter",
        tooltip = {"bad at", "balatro"},
        pos = Vector(124, 71),
        row = 3,
        col = 4
    },
    sipher = {
        name = "sipher nil",
        subheader = "spriter",
        tooltip = {"is actually", "shovel knight"},
        pos = Vector(214, 107),
        row = 5,
        col = 8
    },
    balgor_faded = {
        name = "balgor",
        subheader = "visitor",
        pos = Vector(233, 15),
        row = 9,
        col = 15
    },
    fiend = {
        name = "fiend",
        subheader = "mod lead",
        tooltip = {"v", "'u'"},
        pos = Vector(332, 15),
        row = 1,
        col = 12,
    },
    peribot = {
        name = "peribot",
        subheader = "moral support",
        subheader2 = "2018-2022",
        tooltip = {"press menu", "confirm to", "view the", "special thanks!"},
        dest = "credits",
        pos = Vector(342, 31),
        row = 2,
        col = 12
    },
}

local devsYSorted = {}

local devs2DGrid = {}

local maxRow, maxCol = 0, 0
for k, v in pairs(devs) do
    local sprite = Sprite()
    sprite:Load("gfx/ui/ff_developers/dev.anm2", false)
    sprite:ReplaceSpritesheet(0, "gfx/ui/ff_developers/" .. k .. ".png")
    sprite:LoadGraphics()
    sprite:Play("Idle")
    v.sprite = sprite

    v.ySort = v.pos.Y + (v.ySortOffset or 0)

    if not devs2DGrid[v.row] then
        devs2DGrid[v.row] = {}
    end

    devs2DGrid[v.row][v.col] = v

    maxRow, maxCol = math.max(maxRow, v.row), math.max(maxCol, v.col)

    local insertAt = #devsYSorted + 1
    for i, dev in ipairs(devsYSorted) do
        if v.ySort < dev.ySort then
            insertAt = i
            break
        end
    end

    table.insert(devsYSorted, insertAt, v)
end

local ffCreditsPaper = Sprite()
ffCreditsPaper:Load("gfx/ui/ff_developers/paper.anm2", true)

local ffCreditsPaperMask = Sprite()
ffCreditsPaperMask:Load("gfx/ui/ff_developers/paper.anm2", true)
ffCreditsPaperMask:ReplaceSpritesheet(1, "gfx/ui/ff_developers/paper.png")
ffCreditsPaperMask:LoadGraphics()

local jd = Sprite()
jd:Load("gfx/ui/ff_developers/dev.anm2", false)
jd:ReplaceSpritesheet(0, "gfx/ui/ff_developers/jd.png")
jd:LoadGraphics()
jd:Play("Idle")

fiendfoliodirectory.awesomecredits = {
    format = {
        Panels = {
            {
                Panel = {
                    Sprites = {
                        Face = ffCreditsPaper,
                        Mask = ffCreditsPaperMask
                    },
                    StartAppear = function(panel, tbl, skipOpenAnimation)
                        dssmod.playSound(dssmod.menusounds.Open)
                        dssmod.defaultPanelStartAppear(panel, tbl, skipOpenAnimation)
                    end,
                    StartDisappear = function()
                        dssmod.playSound(dssmod.menusounds.Close)
                    end,
                    Draw = function(panel, panelPos, item)
                        for _, dev in ipairs(devsYSorted) do
                            local rpos = dev.pos + panelPos + Vector(-200, -112)
                            dev.sprite.Color = Color(0, 0, 0, 1, 221 / 255, 179 / 255, 226 / 255)
                            dev.sprite:Render(rpos, Vector.Zero, Vector.Zero)

                            if dev.buttonindex ~= item.bsel then
                                dev.sprite.Color = Color(1, 1, 1, 0.8, 0, 0, 0)
                            else
                                dev.sprite.Color = Color.Default
                            end

                            if FiendFolio.savedata.JDMode then
                                jd:Render(rpos, Vector.Zero, Vector.Zero)
                            else
                                dev.sprite:Render(rpos, Vector.Zero, Vector.Zero)
                            end

                        end
                    end,
                    HandleInputs = function(panel, input, item, itemswitched, tbl)
                        dssmod.handleInputs(item, itemswitched, tbl)
                    end,
                    DefaultRendering = true
                },
                Color = Color.Default,
                Offset = Vector(-50, 0)
            },
            {
                Panel = dssmod.panels.tooltip,
                Offset = Vector(180, -2),
                Color = 1
            }
        }
    },
    generate = function()
    end,
    gridx = maxCol,
    buttons = {}
}

for row = 1, maxRow do
    for column = 1, maxCol do
        local button = {}
        local buttonIndex = #fiendfoliodirectory.awesomecredits.buttons + 1
        if devs2DGrid[row][column] then
            local dev = devs2DGrid[row][column]
            dev.buttonindex = buttonIndex

            local baseFontSize = 2

            button.dest = dev.dest

            button.tooltip = {
                buttons = {
                    {str = dev.name, fsize = baseFontSize},
                    {str = dev.subheader, fsize = 1},
                }
            }

            if dev.subname then
                table.insert(button.tooltip.buttons, 1, {str = dev.subname, fsize = 1})
            end

            if dev.subheader2 then
                button.tooltip.buttons[#button.tooltip.buttons + 1] = {str = dev.subheader2, fsize = 1}
            end

            button.tooltip.buttons[#button.tooltip.buttons + 1] = {str = ""}

            if dev.tooltip then
                local extraFontSize = 2
                if #dev.tooltip > 6 then
                    extraFontSize = 1
                end

                for _, str in ipairs(dev.tooltip) do
                    button.tooltip.buttons[#button.tooltip.buttons + 1] = {str = str, fsize = extraFontSize}
                end
            end
        else
            button.nosel = true
        end

        fiendfoliodirectory.awesomecredits.buttons[buttonIndex] = button
    end
end

local coolSprite =  Sprite()
coolSprite:Load("gfx/ui/transrights_BITCH.anm2", true)
coolSprite:SetFrame("Flag", 0)

for _, credit in ipairs(credits) do
    if type(credit) == "string" then
        fiendfoliodirectory.credits.buttons[#fiendfoliodirectory.credits.buttons + 1] = {str = credit, nosel = true}
    elseif credit.fsize then
        fiendfoliodirectory.credits.buttons[#fiendfoliodirectory.credits.buttons + 1] = credit
    elseif credit.ShowFlag then
        local button = {spr = {sprite = coolSprite, width = -150, height = 1, center = true}, nosel = true}
        fiendfoliodirectory.credits.buttons[#fiendfoliodirectory.credits.buttons + 1] = button
    else
        for i, part in ipairs(credit) do
            if i ~= 1 then
                if i == 2 then
                    local button = {strpair = {{str = credit[1]}, {str = part}}}
                    if credit.tooltip then
                        if type(credit.tooltip) == "string" then
                            credit.tooltip = {credit.tooltip}
                        end
                        button.tooltip = {strset = credit.tooltip}
                    end
                    fiendfoliodirectory.credits.buttons[#fiendfoliodirectory.credits.buttons + 1] = button
                else
                    fiendfoliodirectory.credits.buttons[#fiendfoliodirectory.credits.buttons + 1] = {strpair = {{str = ''}, {str = part}}, nosel = true}
                end
            end
        end
    end
end