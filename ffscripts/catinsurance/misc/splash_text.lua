local mod = FiendFolio

FiendFolio.SplashTexts = {
    Small = {
        {"sequel to devil's harvest mod: shepherd's sacrifice:", "     director's cut: dx edition - probirth version featuring proapi"},
        "fiend folio v1: fiend folio v1: fiend folio v1: ",
        "enemies that don't look as isaac-y, but still look pretty good",
        "today is a good day to be a fiend folio fan",
        "play it and express your true feelings and joy",
        "brought to you by the sweaty meta-fetishists",
        "old friends and new friends and even a bear",
        "download minimod for nuclear throne today!",
        "go clackety clackety clack on your keyboard!",
        "so who in here plays a lot of greed mode?",
        "from the creators of brimstone oh my god!",
        "undertale/deltarune recommendation of the day:",
        "it's a bug! it's a bug! it's actually a bug!",
        {"friend is here!", "so sad i have to uninstall the sheriff mod now :("},
    },
    Medium = {
        "some monsters 2: now it's personal",
        "the game just got even harder!",
        "bringing back dated memes since 1886",
        "please don't judge my code too much",
        "from the creators of happy pack!",
        "from the creators of plagues of egypt!",
        "from the creators of some monsters!",
        "from the creators of antibirth!",
        "from the creators of repentance!",
        "from the creators of pronoun palace!",
        "not from the creators of repentance+!",
        "i'm so freaking sick of wannabe modders",
        "some mod that'll prolly never come out at this rate",
        "we put the mental in experimental",
        "bubbles pop when the room is clear",
        "the vietnam sun tanned their skin",
        "criticism just makes you weak",
        "you're playing with bertran, right?",
        "stop putting necros in mausoleum",
        "yyou shoulj paly dream land 3",
        "inspired by the yiik post-modern rpg",
        "mod compatibility hack can't be killed",
        "stageapi advocates until the bitter end",
        "elder gods of the isaac community",
        "la la la lovely tiny pee peepy",
        "long past the point of being an x mod",
        "thats right, it goes in the square hole!",
        "real people deserve real credit",
        "no more betas, just finished version :)",
        "edmund does not smile upon this...",
        "check out limelight directive!",
        "unapproachable to new players",
        "not to be confused with friend folio!",
        "that sure is something wicked!",
        "beware the fiend folio shadow people",
        "immediately made by shadow people",
        "this new character will knock your rocks off!",
        "are you strong enough to fight the ones with guns?",
        "the axe forgets but the tree remembers"
    },
    Large = {
        ":^)",
        "now with bigger enemies!",
        "now with smaller enemies!",
        "antibirth killer",
        "revelations killer",
        "fiend folio killer",
        "bitcoin mining initialized",
        "fiend folio spoilers!!!!",
        "better than devils harvest",
        "<3",
        "erfly is stinky",
        "welcome to tv tropes",
        "crushing dogs since 1964",
        "made by people with no life",
        "300% more gamefeel",
        "reheated",
        "reloaded",
        "skinless",
        "forget about revelations",
        "the blood moon is rising...",
        "you can step on tar bubbles!",
        "don't get hit",
        "he real swiss knife",
        "purple grass!",
        "also try deliverance!",
        "also try retribution!",
        "also try alphabirth!",
        "also try revelations!",
        "also try bygone characters!",
        "also try fall from grace!",
        "also try last judgement!",
        "also try the future!",
        "also try boss butch!",
        "play as fiend!",
        "play as golem!",
        "play as friend!",
        "play as edith!",
        "play as china!",
        "play as craig!",
        "play as slippy!",
        "play as fient!",
        "play as fend!",
        "play as peat!",
        "play as icarus!",
        "play as mammon!",
        "play as bertran!",
        "play as josuke!",
        "play as vriska!",
        "play as flysaac!",
        "play as samael!",
        "play as job!",
        "play as ohyo!",
        "play as elijah!",
        "play as the sheriff!",
        "play brutal orchestra!",
        "check out clown meat!",
        "check out gimmiko!",
        "it came from space",
        "limited edition!",
        "the sequel!",
        "going sicko mode",
        "more than 8 enemies!",
        "more than 200 enemies!",
        "more than 700 enemies!",
        "nice man, nice",
        "modders making mods for fun",
        "sponsored by peribot",
        "fully modelled",
        "and kingpin",
        "devil's harvest 2?",
        "goes great with bertran!",
        "look behind you",
        "look in front of you",
        "oil of dneif",
        "7 new enemies!",
        "2!",
        "electric boogaloo",
        "happy mario day!",
        "happy birthday!",
        "happy holidays!",
        "sponsored by corn fanta",
        "dopeheap or retrogate?",
        "now with basement bonies!",
        "three days are remaining...",
        "freeloader to free labor",
        "isaac curse is real",
        "sainte or gronch?",
        "complete the brown ritual",
        "now a madness combat mod",
        "now a touhou mod",
        "now a homestuck mod",
        "fiendcraft when?",
        "devil's throne when?",
        "friday night fiendin' when?",
        "now a card mod",
        "now an everything mod",
        "nyeah, see?",
        "why am i not a floor?",
        "now featuring greg the egg",
        "trolleybus",
        "morbus absorption complete",
        "milk dog vs spaghetti dog",
        "flenolo",
        "one hell of an oversight",
        "genesis 34:10 (niv)",
        "luke 11:14 (wyc)",
        "2 samuel 6:14 (kjv)",
        "powered by repentogon",
        "beware of the pipeline",
        "mesi",
        "hi bethany",
        "ñ",
        "they look like demonstratives",
        "i found some wild glizzies!",
        "super ventilador",
        "aaaaaaaaaaieeeeeeeeee!!!!!",
        "isaac fact!",
        "makes the game more rancid",
        "hi bartar",
        "too many fortunes...!",
        "isaac fact!",
        "holy shoot",
        "everything has a price",
        "it's fiend! watch out!",
        "stop ragebaiting",
        "why is the sheriff purple",
        "we hate fun!",
        "what if it was purple?",
        "heaps of unused content!",
        "fiend Folio found me!",
        "real rabbits use gamepad!",
        "someone should rework this foe",
        "unnecessary poop lore!",
        "glumps get punished",
        "click to learn more!"
    }
}

local font = Sprite("gfx/ui/splashtext/splash_font.anm2", true)

local animations = {
    "12",
    "16",
    "24",
}

local mfdat = {}
mfdat['a'] = { 0, 4, 7, 11 }
mfdat['b'] = { 1, 4, 8, 12 }
mfdat['c'] = { 2, 4, 7, 10 }
mfdat['d'] = { 3, 4, 8, 12 }
mfdat['e'] = { 4, 4, 7, 10 }
mfdat['f'] = { 5, 4, 6, 9 }
mfdat['g'] = { 6, 5, 8, 12 }
mfdat['h'] = { 7, 4, 8, 11 }
mfdat['i'] = { 8, 1, 3, 4 }
mfdat['j'] = { 9, 4, 7, 11 }
mfdat['k'] = { 10, 4, 6, 9 }
mfdat['l'] = { 11, 4, 8, 10 }
mfdat['m'] = { 12, 5, 8, 13 }
mfdat['n'] = { 13, 4, 8, 10 }
mfdat['o'] = { 14, 5, 10, 12 }
mfdat['p'] = { 15, 4, 7, 10 }
mfdat['q'] = { 16, 5, 9, 13 }
mfdat['r'] = { 17, 4, 7, 10 }
mfdat['s'] = { 18, 4, 6, 10 }
mfdat['t'] = { 19, 4, 7, 10 }
mfdat['u'] = { 20, 4, 7, 13 }
mfdat['v'] = { 21, 5, 8, 13 }
mfdat['w'] = { 22, 5, 11, 16 }
mfdat['x'] = { 23, 4, 6, 12 }
mfdat['y'] = { 24, 4, 7, 10 }
mfdat['z'] = { 25, 4, 6, 9 }
mfdat['0'] = { 26, 4, 8, 12 }
mfdat['1'] = { 27, 4, 8, 10 }
mfdat['2'] = { 28, 4, 8, 10 }
mfdat['3'] = { 29, 4, 8, 10 }
mfdat['4'] = { 30, 4, 7, 10 }
mfdat['5'] = { 31, 4, 8, 9 }
mfdat['6'] = { 32, 4, 8, 10 }
mfdat['7'] = { 33, 4, 8, 10 }
mfdat['8'] = { 34, 4, 8, 9 }
mfdat['9'] = { 35, 4, 8, 9 }
mfdat["'"] = { 36, 1, 2, 3 }
mfdat['"'] = { 37, 3, 4, 5 }
mfdat[':'] = { 38, 1, 3, 4 }
mfdat['/'] = { 39, 3, 6, 8 }
mfdat['.'] = { 40, 1, 2, 4 }
mfdat[','] = { 41, 2, 3, 4 }
mfdat['!'] = { 42, 2, 4, 6 }
mfdat['?'] = { 43, 3, 6, 8 }
mfdat['['] = { 44, 2, 4, 6 }
mfdat[']'] = { 45, 2, 4, 6 }
mfdat['('] = { 44, 2, 4, 6 }
mfdat[')'] = { 45, 2, 4, 6 }
mfdat['$'] = { 46, 4, 6, 8 }
mfdat['C'] = { 47, 5, 6, 8 }
mfdat['+'] = { 48, 5, 6, 8 }
mfdat['-'] = { 49, 4, 6, 10 }
mfdat['X'] = { 50, 5, 6, 8 }
mfdat['D'] = { 51, 5, 6, 8 }
mfdat['%'] = { 52, 4, 6, 8 }
mfdat['_'] = { 54, 2, 4, 5 }
mfdat[' '] = { 54, 4, 6, 8 }
mfdat['='] = { 53, 5, 8, 12 }
mfdat['^'] = { 55, 3, 4, 5 }
mfdat['<'] = { 56, 5, 7, 10 }
mfdat['>'] = { 57, 5, 7, 10 }
mfdat['ñ'] = { 58, 4, 8, 10 }

-- https://stackoverflow.com/a/43139063
function mod:SubUTF8(s,i,j)
    i=utf8.offset(s,i)
    j=utf8.offset(s,j+1)-1
    return string.sub(s,i,j)
end


local function getMenuStringLength(str, fsize)
    fsize = fsize + 1
    local length = 0
    local chr = {}
    for i = 1, utf8.len(str) do
        local substr = mod:SubUTF8(str, i, i):lower()
        if not mfdat[substr] then
            print("INVALID CHARACTER FOR SPLPASH TEXT!!!:( :", substr)
            substr = '!'
        end

        local len = mfdat[substr][fsize]
        table.insert(chr, { substr, length })
        length = length + len + 1
    end

    return length, chr
end

local TEXT_POS = Vector(12, 10)
local choices = {}
FiendFolio.CurrentSplashText = {}

function mod:BuildSplashTexts()
    choices = {}
    
    for size, splashes in pairs(FiendFolio.SplashTexts) do
        local anim
        if size == "Small" then
            anim = 1
        elseif size == "Medium" then
            anim = 2
        else
            anim = 3
        end

        for _, splash in ipairs(splashes) do
            local splashTable = type(splash) == "string" and {splash} or splash
            choices[#choices+1] = {anim, splashTable}
        end
    end

    mod:ChooseSplashText()
end

function mod:ChooseSplashText(fsize, text)
    if fsize == nil or text == nil then
        mod.CurrentSplashText = choices[math.random(#choices)]
    else
        mod.CurrentSplashText = {fsize, text}
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.ChooseSplashText)

function mod:SplashTextRender()
    local root = Isaac.WorldToMenuPosition(MainMenuType.GAME, TEXT_POS)
    local charIndex = 0
    local chosen = mod.CurrentSplashText
    for line, str in ipairs(chosen[2]) do
        local length, fullStringChr = getMenuStringLength(str, chosen[1])
        for i, chr in ipairs(fullStringChr) do
            charIndex = charIndex + 1

            local frame = animations[chosen[1]]
            local fpos = Vector(chr[2], (line - 1) * (tonumber(frame) / 2 + 2)):Rotated(-5)


            font:SetFrame(frame, mfdat[chr[1]][1])
            font:Render(root + fpos)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER, mod.SplashTextRender)

mod:BuildSplashTexts()