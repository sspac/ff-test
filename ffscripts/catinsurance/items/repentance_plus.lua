local mod = FiendFolio
local game = Game()
local config = Isaac.GetItemConfig()

local Constants = {
    ITEM_ID = mod.ITEM.COLLECTIBLE.REPENTANCE_PLUS,
    FONT = Font("font/teammeatex/teammeatex12.fnt"),
    FONT_SETTINGS = FontRenderSettings(),

    FONT_SCALE = 0.5,
    LINE_HEIGHT_MODIFIER = 0.4,
    BOX_WIDTH = 120,
    CHAT_MESSAGE_FADEIN_TIME = 10,
    CHAT_MESSAGE_FADEOUT_TIME = 300,
    CHAT_OPACITY_FADE_GLOBAL = 0.025,
    CHAT_OPACITY_FADE_PER = 0.025,
    MAX_MESSAGES = 10,
    BUBBLE_APPEAR_TIME = 120,
    HIGHLIGHT_MAX_FRAME = 10,
    CHAT_MESSAGE_SPACING = 8,

    JOIN_DELAY = 90,

    USERNAMES = {
        "Mr. Science",
        "thegamer27",
        "gayincubus",
        "CornManiac",
        "balgor_real",
        "terrible_steve",
        "FartDaniel1998",
        "mariomario03",
    },
    COLORS = {
        KColor(1, 0.6, 0.6, 1),
        KColor.Blue,
        KColor.Cyan,
        KColor.Yellow,
        KColor.Green,
        KColor.Magenta,
    }
}
Constants.FONT_SETTINGS:SetAlignment(DrawStringAlignment.TOP_LEFT)
Constants.FONT_SETTINGS:EnableAutoWrap(Constants.BOX_WIDTH)
Constants.FONT_SETTINGS:SetLineHeightModifier(Constants.LINE_HEIGHT_MODIFIER)

local validUsernames = {}
for _, v in ipairs(Constants.USERNAMES) do
    table.insert(validUsernames, v)
end

local joinMessages = {
    "yooooo",
    "what up",
    "yo bro",
    "sup",
    "whaddup",
}

local idleMessages = {
    "youre gonna miss boss rush",
    "hi",
    "you missed a tinted rock",
    "???",
    "i got isaac for my birthday",
    "i just bought isaac recently from the sale and for some reason my character doesnt dance when he sees an item, why is that?",
    "i hope you get brimmy",
    "can you help me install repentagon?",
    "hurry up bro",
    "how do you turn on item descriptions i cant find it in my settings",
    "have you ever tried playing isaac with the filter on? it looks so much better",
    "can you turn off friend folio",
    "fiend folio lags my game too much even though i literally only have like 200 other mods on",
    "good plays bro",
    "do you have specialist dance",
    "do you have flattening of isaac enabled",
    "can you download flattening of isaac",
    "how'd you get this working? i tried feind folio but it doesn't work",
    "yawn",
    "any tips for tainted cain",
    "why is everyone ignoring me",
    "i saw this game on youtube",
    "how do i enable debug console",
}

local leaveMessages = {
    "ts ass bro",
    "gtg dinner",
    "brb",
    "ts pmo",
    "nahhhhh i'm out",
    "gotta get ready for school",
    "gtg chores",
}

local qualityFour = {
    "POGGERS!!!!",
    "QUALITY 4!!!!",
    "TAKE THAT TAKE THAT",
    "QUALITY 4",
    "THE MATTMAN LUCK IS CRAZY",
    "YOUTUBER LUCK BRO",
    "QALITY 4",
    "THAT'S A QUALITY 4",
    "DUDE TAKE THAT ITEM",
    "THAT'S ONE OF THE BEST ITEMS IN THE GAME",
    "YOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO",
    "TAKEEEEEE",
    "QAULITY 4",
    "Q4! Q4!",
    "THAT'S A REALLY GOOD ITEM",
    "OMG",
    "OMG ITS SO GOOD",
}

local qualityZero = {
    "don't even bother bro",
    "actual garbage",
    "eid says it's quality 0",
    "that's a skip",
    "that's q0 so you shouldn't take it",
    "bad item",
    "this item needs a buff",
}

local onHurt = {
    "lol",
    "i wouldnt have gotten hit there lol",
    "yikes",
    "what are you doing bro",
    "just dodge",
    "cmon now",
    "give me the controller",
    "that's funny",
    "ur bad kid",
    "skill issue",
}

local newItem = {
    "loot get!",
    "hell yeah bro",
    "let's gooooo",
    "nice",
    "sick",
    "poggy woggy!!",
}

local wheelVisible
local highlightFrame = 0

local onlineActivatedTime
local onlineActivated = false

local emote = Sprite("gfx/ui/waaaawaa_d.anm2", true)
emote:Play("Idle")

local wheel = Sprite("gfx/ui/waaaawaa_d.anm2", true)

local highlight = Sprite("gfx/ui/waaaawaa_d.anm2", true)

local wawas = Sprite("gfx/ui/waaaawaa_d.anm2", true)
wawas:Play("waaawaa_d")

local chatOpacity = 0
local chatFadeCooldown = 0
local chatUsers = {}
local chatQueue = {}

function mod:RepPlusHandleShowEmote()
    for _, player in ipairs(PlayerManager.GetPlayers()) do
        local data = mod:GetEntityData(player)
        if not data.WaWaSprite then return end

        local renderPos = Isaac.WorldToRenderPosition(player.Position + Vector(0, -72)) + game:GetRoom():GetRenderScrollOffset() + game.ScreenShakeOffset
        emote:Render(renderPos)

        data.WaWaSprite = data.WaWaSprite + 1
        if data.WaWaSprite >= Constants.BUBBLE_APPEAR_TIME then
            data.WaWaSprite = nil
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_RENDER, Constants.ITEM_ID, mod.RepPlusHandleShowEmote)

function mod:RepPlusReset()
    onlineActivated = false
    wheelVisible = false
    chatQueue = {}
    chatUsers = {}
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.RepPlusReset)

---@param font Font?
function mod:CutStringAtWidth(str, width, font)
    font = font or Constants.FONT

    local len = utf8.len(str)
    local strOne, strTwo
    for i = 1, len do
        local substr = mod:SubUTF8(str, 1, i)
        if font:GetStringWidth(substr) > width then
            strOne = mod:SubUTF8(str, 1, i)
            strTwo = mod:SubUTF8(str, i, len)
            break
        end
    end

    return strOne, strTwo
end

function mod:SendChatMessage(kcolor, username, message)
    local message = message

    -- If not a system message, create typos
    if username ~= nil then
        local len = utf8.len(message)
        for i = 1, len do
            if i == 1 then
                goto continue
            end

            local substr = mod:SubUTF8(message, i-1, i-1)
            local before = mod:SubUTF8(message, i-2, i-2)
            if (
                math.random() < 0.005 -- 0.05% chance
                and substr:match("%s") == nil
                and before:match("%s") == nil
            ) then
                -- Swap the characters
                -- https://stackoverflow.com/a/18884859
                local combined = before .. substr
                combined = combined:gsub("(.)(.)", "%2%1")

                -- Create the final message
                local resultMessage = mod:SubUTF8(message, 1, i-3) .. combined
                if i + 1 <= len then
                    resultMessage = resultMessage .. mod:SubUTF8(message, i, len)
                end

                message = resultMessage
            end

            ::continue::
        end
    end

    table.insert(chatQueue, 1, {
        Color = kcolor,
        Username = username,
        Message = message,
        LifeTime = 0,
        Opacity = 0,
    })

    -- Calculate how many lines this message will have
    local lineWidth = 0
    local splitText = mod:SplitString(message, " ")

    local splitLines = {}
    local i = 1
    local currentLine = ""
    local failsafe = 0
    while i <= #splitText do
        if failsafe > 100 then
            break
        end

        local text = splitText[i]
        local oldLine = currentLine


        if currentLine ~= "" then
            currentLine = currentLine .. " " .. text
        else
            currentLine = text
        end

        lineWidth = Constants.FONT:GetStringWidth(currentLine)

        -- The text is gonna be too long, split the line
        -- The +5 is so lines that are barely too long dont wrap, seems to be what vanilla does
        if lineWidth > Constants.BOX_WIDTH + 5 then
            -- If this word doesn't fit on the next string, cut it in half and add a dash to first half
            if Constants.FONT:GetStringWidth(text) > Constants.BOX_WIDTH then
                local cutStart, cutEnd = mod:CutStringAtWidth(text, Constants.BOX_WIDTH)

                if oldLine ~= "" then
                    table.insert(splitLines, oldLine)
                end

                if cutStart ~= "" then
                    table.insert(splitLines, cutStart .. "-")
                end

                table.insert(splitText, i+1, cutEnd)
            -- Else split at the space
            else
                table.insert(splitLines, oldLine)
                table.insert(splitText, i+1, text)
            end

            currentLine = ""
        end

        ::skip::

        i = i + 1
        failsafe = failsafe + 1
    end

    table.insert(splitLines, currentLine)

    -- Now calculate the line height
    local lineCount = #splitLines
    local heightOfSpacing = (lineCount-1) * (Constants.FONT:GetLineHeight() * Constants.LINE_HEIGHT_MODIFIER)
    chatQueue[1].Height = heightOfSpacing

    for i, chat in ipairs(chatQueue) do
        chat.TargetOffset = mod:CalculateChatOffset(i)

        if i == 1 then
            chat.Offset = chat.TargetOffset
        end

        chat.OldOffset = Vector(chat.Offset.X, chat.Offset.Y)
    end
end

function mod:SendPlayerChatMessage(player, category, cooldown, force)
    if player.Cooldown > 0 and not force then
        return
    end

    mod:SendChatMessage(player.ChatColor, player.Username, mod:RandomIndex(category, player.RNG))
    player.Cooldown = cooldown or 15
    mod:ChatMessageSafetyAnalyser(player.Username)
end

function mod:CalculateChatOffset(index)
    local totalOffset = 0
    for i, message in ipairs(chatQueue) do
        if i > index then
            break
        end

        totalOffset = totalOffset + message.Height

        if i+1 <= index then
            totalOffset = totalOffset + Constants.CHAT_MESSAGE_SPACING
        end
    end
    return Vector(0, -totalOffset)
end

function mod:GetChatOrigin()
    local width, height = Isaac.GetScreenWidth(), Isaac.GetScreenHeight()
    return Vector(width/6, height - height/3)
end

-- Handles chat rendering
function mod:RepPlusChatHandler()
    local firstMessage = chatQueue[1]

    if firstMessage and firstMessage.LifeTime == 0 then
        chatFadeCooldown = 0
    elseif not game:IsPaused() then
        chatFadeCooldown = chatFadeCooldown + 1
    end

    for index, message in ipairs(chatQueue) do
        -- Handle fading in and moving of chat messages
        if index > 1 then
            local progress = math.min(firstMessage.LifeTime / Constants.CHAT_MESSAGE_FADEIN_TIME, 1)
            message.Offset = mod:Lerp(message.OldOffset, message.TargetOffset, progress)
        end

        if index > 10 then
            message.Opacity = math.max(message.Opacity - 1 / Constants.CHAT_MESSAGE_FADEIN_TIME, 0)
            if message.Opacity <= 0 then
                message.MarkForRemoval = true
            end
        else
            message.Opacity = math.min(message.Opacity + 1 / Constants.CHAT_MESSAGE_FADEIN_TIME, 1)
        end

        -- Render current chat message
        -- First, get the drawing position
        local position = mod:GetChatOrigin() + message.Offset
        local color = KColor(message.Color.Red, message.Color.Green, message.Color.Blue, chatOpacity * message.Opacity)

        -- Render "user" messages
        if message.Username then
            -- Draw the username
            Constants.FONT:DrawString(message.Username .. ":", position.X, position.Y, Constants.FONT_SCALE, Constants.FONT_SCALE, color, Constants.FONT_SETTINGS)

            -- Now draw the message
            -- Add an offset for the username, too
            local colorWhite = KColor(1, 1, 1, chatOpacity * message.Opacity)
            local width = Constants.FONT:GetStringWidth(message.Username .. ": ") * Constants.FONT_SCALE
            Constants.FONT:DrawString(message.Message, position.X + width, position.Y, Constants.FONT_SCALE, Constants.FONT_SCALE, colorWhite, Constants.FONT_SETTINGS)

        -- Render "system" messages
        else
            Constants.FONT:DrawString(message.Message, position.X, position.Y, Constants.FONT_SCALE, Constants.FONT_SCALE, color, Constants.FONT_SETTINGS)
        end

        message.LifeTime = message.LifeTime + 1
    end

    for i = #chatQueue, 1, -1 do
        if chatQueue[i].MarkForRemoval then
            chatQueue[i] = nil
        end
    end

    -- Set global opacity
    if chatFadeCooldown < Constants.CHAT_MESSAGE_FADEIN_TIME then
        chatOpacity = math.min(chatOpacity + Constants.CHAT_OPACITY_FADE_GLOBAL, 1)
    elseif chatFadeCooldown > Constants.CHAT_MESSAGE_FADEOUT_TIME then
        chatOpacity = math.max(chatOpacity - Constants.CHAT_OPACITY_FADE_GLOBAL, 0)
    else
        chatOpacity = 1
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_HUD_RENDER, Constants.ITEM_ID, mod.RepPlusChatHandler)

function mod:RepPlusAddPlayer()
    if #validUsernames < 1 then
        return
    end

    local rng = RNG(math.max(Random(), 1))
    local usernameIndex = mod:Random(1, #validUsernames, rng)
    local username = table.remove(validUsernames, usernameIndex)

    local userInfo = {
        Username = username,
        ChatColor = mod:RandomIndex(Constants.COLORS, rng),
        Cooldown = 30,
        RNG = rng,

        HasGreeted = false,
    }
    table.insert(chatUsers, userInfo)

    mod:SendChatMessage(KColor.White, nil, userInfo.Username .. " has connected as a SPECTATOR!")
end

function mod:RepPlusUpdate()
    if not onlineActivatedTime then
        return
    end

    onlineActivatedTime = onlineActivatedTime + 1

    if onlineActivatedTime == Constants.JOIN_DELAY then
        mod:RepPlusAddPlayer()
    end

    -- Small chance to add players after this
    if onlineActivatedTime > Constants.JOIN_DELAY then
        if #chatUsers < 3 and math.random() < 0.0001 then
            mod:RepPlusAddPlayer()
        end
    end

    local removeAtEnd = {}
    for i, player in ipairs(chatUsers) do
        player.Cooldown = math.max(player.Cooldown - 1, 0)

        if not player.HasGreeted and player.Cooldown == 0 then
            mod:SendPlayerChatMessage(player, joinMessages, 30 * 5)
            player.HasGreeted = true
        end

        if player.WillLeave then
            player.WillLeave = player.WillLeave + 1
        end
        if (player.WillLeave and player.WillLeave > 30) or mod.OddFeeling then
            removeAtEnd[i] = true
        end

        -- Handle quality four detection
        local hasQualityFour = false
        local hasQualityZero = false
        for _, item in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
            if item.SubType > 0 then
                local itemConfig = config:GetCollectible(item.SubType)
                if itemConfig and itemConfig.Quality == 4 then
                    hasQualityFour = true
                elseif itemConfig and itemConfig.Quality == 0 then
                    if not mod:GetEntityData(item).RepPlusQualityCheck then
                        hasQualityZero = true
                    end

                    mod:GetEntityData(item).RepPlusQualityCheck = true
                end
            end
        end

        -- Quality four messages
        if hasQualityFour then
            mod:SendPlayerChatMessage(player, qualityFour, 15)
        -- Quality zero messages
        elseif hasQualityZero then
            mod:SendPlayerChatMessage(player, qualityZero, 60, true)
        -- Idle messages
        elseif player.Cooldown == 0  then
            -- Small chance to leave the chat
            if player.RNG:RandomFloat() < 0.03 then
                player.WillLeave = 0
                mod:SendPlayerChatMessage(player, leaveMessages, 1000)
            else
                mod:SendPlayerChatMessage(player, idleMessages, math.random(30 * 7, 30 * 20))
            end
        end
    end

    -- Remove disconnecting players
    local removed = false
    for i = #chatUsers, 1, -1 do
        if removeAtEnd[i] then
            local username = chatUsers[i].Username
            mod:SendChatMessage(KColor.White, nil, username .. " has disconnected!")
            table.remove(chatUsers, i)
            table.insert(validUsernames, username)

            removed = true
        end
    end

    if removed and mod.OddFeeling then
        mod:SendChatMessage(KColor.White, nil, "You feel like you're being watched.")
        mod.OddFeeling = nil
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_UPDATE, Constants.ITEM_ID, mod.RepPlusUpdate)

function mod:RepPlusPickup()
    if onlineActivated then
        for _, player in ipairs(chatUsers) do
            mod:SendPlayerChatMessage(player, newItem, 60, true)
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, Constants.ITEM_ID, mod.RepPlusPickup)

function mod:RepPlusDamage()
    if onlineActivated then
        for _, player in ipairs(chatUsers) do
            mod:SendPlayerChatMessage(player, onHurt, 60, true)
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, Constants.ITEM_ID, mod.RepPlusDamage, EntityType.ENTITY_PLAYER)

function mod:RepPlusHandleEmoteWheel()
    local player = Isaac.GetPlayer()
    local cIndex = player.ControllerIndex
    local center = Vector(Isaac.GetScreenWidth() / 2, Isaac.GetScreenHeight() / 2)

    if not player:HasCollectible(Constants.ITEM_ID) then
        return
    end

    if wheelVisible then

        wheel:Render(center)

        if wheel:IsFinished("WheelOpen") then
            highlight:SetFrame("Highlight", highlightFrame)

            if Input.IsActionTriggered(ButtonAction.ACTION_SHOOTRIGHT, cIndex) then
                highlightFrame = highlightFrame + 1
                if highlightFrame > Constants.HIGHLIGHT_MAX_FRAME then
                    highlightFrame = 0
                end
            end

            if Input.IsActionTriggered(ButtonAction.ACTION_SHOOTLEFT, cIndex) then
                highlightFrame = highlightFrame - 1
                if highlightFrame < 0 then
                    highlightFrame = Constants.HIGHLIGHT_MAX_FRAME
                end
            end

            if Input.IsActionTriggered(ButtonAction.ACTION_DROP, cIndex)
            or Input.IsButtonTriggered(Keyboard.KEY_LEFT_ALT, cIndex) then
                wheel:Play("WheelClose", true)
                mod:GetEntityData(player).WaWaSprite = 0
                if not onlineActivated then
                    mod:SendChatMessage(KColor.White, nil, "Lobby set to: Public")
                    onlineActivatedTime = 0
                end
                onlineActivated = true
            end

            highlight:Render(center)
            wawas:Render(center)
        end

        if wheel:IsFinished("WheelClose") then
            wheelVisible = false
        end
        wheel:Update()
    else
        highlightFrame = 0

        if Input.IsButtonTriggered(Keyboard.KEY_LEFT_ALT, cIndex) then
            wheelVisible = true
            wheel:Play("WheelOpen", true)
        end
    end
end

mod:AddCollectibleCallback(ModCallbacks.MC_POST_RENDER, Constants.ITEM_ID, mod.RepPlusHandleEmoteWheel)

function mod:RepPlusBlockInputs(entity, inputHook, buttonAction)
    if wheelVisible then
        if buttonAction == ButtonAction.ACTION_SHOOTDOWN
        or buttonAction == ButtonAction.ACTION_SHOOTLEFT
        or buttonAction == ButtonAction.ACTION_SHOOTRIGHT
        or buttonAction == ButtonAction.ACTION_SHOOTUP then
            if inputHook == InputHook.GET_ACTION_VALUE then
                return 0
            else
                return false
            end
        end
    end
end

mod:AddCollectibleCallback(ModCallbacks.MC_INPUT_ACTION, Constants.ITEM_ID, mod.RepPlusBlockInputs)