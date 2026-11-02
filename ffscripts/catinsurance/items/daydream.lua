local mod = FiendFolio
local game = Game()
local ONE_SECOND = 30
local ONE_SECOND_RENDER = 60
local Daydream = {}

local EVENT_INTERVAL_MIN = ONE_SECOND * 15
local EVENT_INTERVAL_MAX = ONE_SECOND * 30
local EVENT_INTERVAL_START = ONE_SECOND * 5

local TEXT_COLOR = KColor(84 / 255, 108 / 255, 121 / 255, 255 / 255)
local ACTIVATION_TIMER = ONE_SECOND_RENDER * 6

local BUBBLE_FONT = Font()
BUBBLE_FONT:Load("font/teammeatfont16.fnt")

local DAYDREAM_UNLOCK_REQUIREMENT = 2

mod.DaydreamUnlockItems = {
    CollectibleType.COLLECTIBLE_DREAM_CATCHER,
    CollectibleType.COLLECTIBLE_PJS,
    CollectibleType.COLLECTIBLE_BLANKET,
    CollectibleType.COLLECTIBLE_BINKY,
    CollectibleType.COLLECTIBLE_NIGHT_LIGHT,
    CollectibleType.COLLECTIBLE_MILK, -- because it's like warm milk before sleep (no one does this in real life)
    mod.ITEM.COLLECTIBLE.BEDTIME_STORY,
    mod.ITEM.COLLECTIBLE.SPIRIT_OF_NIGHTMARE,
    mod.ITEM.COLLECTIBLE.HYPNO_RING,
}

function mod:AddDaydreamUnlockItem(idOrTable)
    if type(idOrTable) == "table" then
        for _, var in ipairs(idOrTable) do
            if type(var) == "number" then
                mod.DaydreamUnlockItems[#mod.DaydreamUnlockItems+1] = var
            end
        end
    elseif type(idOrTable) == "number" then
        mod.DaydreamUnlockItems[#mod.DaydreamUnlockItems+1] = idOrTable
    end
end


---@class EventInfo
---@field Id integer Internal
---@field Name string What you'll use to identify this later
---@field Spritesheet string
---@field YesLabel string
---@field NoLabel string
---@field Weight number
---@field GreedBlacklisted boolean
---@field TextOffset Vector

---@type EventInfo[]
local events = {}

---@param name string
---@param weight number
---@param yesLabel string
---@param noLabel string
---@param spritesheet string Example: "bomb.png" (no need to put the full file path, just the file name)
function Daydream:RegisterEvent(name, weight, yesLabel, noLabel, spritesheet, greedBlacklisted, textOffset)
    table.insert(events, {
        Id = #events + 1,
        Name = name,
        Spritesheet = "gfx/effects/daydreams/" .. spritesheet,
        YesLabel = yesLabel,
        NoLabel = noLabel,
        Weight = weight,
        GreedBlacklisted = greedBlacklisted == true,
        TextOffset = textOffset or Vector(0, 0)
    })
end

FiendFolio.RegisterDaydreamEvent = Daydream.RegisterEvent

-- Load all events
FiendFolio.LoadScripts({
    "ffscripts.catinsurance.daydream_events._loader",
})

---@param rng RNG
---@return EventInfo info
function Daydream:GetRandomEvent(player, rng)
    local eventPicker = WeightedOutcomePicker()
    local data = mod:GetEntityData(player)

    for i, event in ipairs(events) do
        if data.DaydreamLastEvent and data.DaydreamLastEvent.Name == event.Name then
            goto continue
        end

        if game:IsGreedMode() and event.GreedBlacklisted then
            goto continue
        end

        for _, callback in ipairs(Isaac.GetCallbacks("DAYDREAM_PRE_EVENT_DISPLAY")) do
            if (callback.Param and callback.Param == event.Name) or not callback.Param then
                if callback.Function(callback.Mod, event, player) == false then
                    goto continue
                end
            end
        end

        eventPicker:AddOutcomeWeight(i, event.Weight)
        ::continue::
    end

    local outcome = events[eventPicker:PickOutcome(rng)]
    data.DaydreamLastEvent = outcome
    return outcome
end

---@param player EntityPlayer
---@param event EventInfo
function Daydream:RunEvent(player, event)
    local data = mod:GetEntityData(player)
    data.DaydreamInfo = event
    data.DaydreamSelectionTrue = true
    data.DaydreamSprite = Sprite()
    data.DaydreamSprite:Load("gfx/effects/daydream_thoughts.anm2", false)
    data.DaydreamSprite:ReplaceSpritesheet(3, event.Spritesheet)
    data.DaydreamSprite:LoadGraphics()
    data.DaydreamSprite:Play("Appear", true)
    data.DaydreamSelector = Sprite()
    data.DaydreamSelector:Load("gfx/effects/daydream_thoughts.anm2", true)
    data.DaydreamSelector:Play("Selector", true)
    data.DaydreamActivationTimer = ACTIVATION_TIMER
end

function mod:DaydreamUpdate()
    for _, player in ipairs(PlayerManager.GetPlayers()) do
        if player:HasCollectible(mod.ITEM.COLLECTIBLE.DAYDREAM) then
            local saveData = mod:GetEntityData(player)

            saveData.DaydreamVoteInterval = saveData.DaydreamVoteInterval or EVENT_INTERVAL_START

            if Isaac.CountEnemies() > 0 and not game:GetRoom():IsClear() then
                saveData.DaydreamVoteInterval = math.max(saveData.DaydreamVoteInterval - 1, 0)
            end

            if saveData.DaydreamVoteInterval == 0 then
                local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.DAYDREAM)
                local event = Daydream:GetRandomEvent(player, rng)

                Daydream:RunEvent(player, event)

                saveData.DaydreamVoteInterval = rng:RandomInt(EVENT_INTERVAL_MIN, EVENT_INTERVAL_MAX)
            end
        end
    end
end

local lastRenderOffset = {}
function mod:DaydreamPlayerRender(player, offset, room)
    room = room or game:GetRoom()
    local data = mod:GetEntityData(player)
    if not data.DaydreamSprite then return end
    ---@type Sprite
    local sprite = data.DaydreamSprite
    local renderPos = Isaac.WorldToRenderPosition(player.Position) + offset

    if room:IsMirrorWorld() then
        local halfPoint = Isaac.GetScreenWidth() / 2
        local diff = renderPos.X - halfPoint
        renderPos = Vector(halfPoint - diff, renderPos.Y)
    end

    renderPos = renderPos + Vector(player.Size * 1.75, player.Size * -3.75) + player:GetFlyingOffset()

    sprite:Render(renderPos)

    if sprite:IsFinished("Appear") then
        sprite:Play("Idle", true)
    end

    ---@type EventInfo
    local event = data.DaydreamInfo
    if data.DaydreamSelectionTrue == nil then
        data.DaydreamSelectionTrue = true
    end

    if not game:IsPaused() and data.DaydreamActivationTimer then
        data.DaydreamActivationTimer = math.max(data.DaydreamActivationTimer - 1, 0)
    end

    if not game:IsPaused() and game:GetFrameCount() % 2 == 0 then
        sprite:Update()
    end

    if not game:IsPaused() and data.DaydreamActivationTimer then
        local scrollWheel = player.ControllerIndex == 0 and Input.GetMouseWheel()
        if scrollWheel and not data.ScrollWheelCooldown and scrollWheel.Y ~= 0 then
            data.ScrollWheelCooldown = 10
            data.DaydreamSelectionTrue = not data.DaydreamSelectionTrue
        end

        if data.ScrollWheelCooldown then
            data.ScrollWheelCooldown = data.ScrollWheelCooldown - 1
            if data.ScrollWheelCooldown <= 0 then
                data.ScrollWheelCooldown = nil
            end
        end

        if Input.IsActionTriggered(ButtonAction.ACTION_SHOOTDOWN, player.ControllerIndex) then
            data.DaydreamSelectionTrue = not data.DaydreamSelectionTrue
        end

        if Input.IsActionTriggered(ButtonAction.ACTION_SHOOTUP, player.ControllerIndex) then
            data.DaydreamSelectionTrue = not data.DaydreamSelectionTrue
        end

        if Input.IsActionTriggered(ButtonAction.ACTION_DROP, player.ControllerIndex) then
            data.DaydreamActivationTimer = 0
        end

        if Options.MouseControl and Input.IsMouseBtnPressed(MouseButton.RIGHT) and player.ControllerIndex == 0 then
            if player:GetPlayerType() ~= mod.PLAYER.FRIEND then
                data.DaydreamActivationTimer = 0
            end
        end
    end

    if data.DaydreamActivationTimer and data.DaydreamActivationTimer == 0 then
        if data.DaydreamSelectionTrue then
            Isaac.RunCallbackWithParam("DAYDREAM_POST_CONFIRM_EVENT", event.Name, player, event.Name)
        else
            Isaac.RunCallbackWithParam("DAYDREAM_POST_DENY_EVENT", event.Name, player, event.Name)
        end

        data.DaydreamActivationTimer = nil
    elseif data.DaydreamActivationTimer and data.DaydreamActivationTimer > 0 and sprite:GetAnimation() == "Idle" then
        local yesPos = sprite:GetNullFrame("yesPos"):GetPos() + renderPos + event.TextOffset + game.ScreenShakeOffset
        local noPos = sprite:GetNullFrame("noPos"):GetPos() + renderPos + event.TextOffset + game.ScreenShakeOffset
        local countdownPos = sprite:GetNullFrame("countdownPos"):GetPos() + renderPos + event.TextOffset + game.ScreenShakeOffset

        local scale = 0.5
        BUBBLE_FONT:DrawStringScaled(event.YesLabel, yesPos.X, yesPos.Y, scale, scale, TEXT_COLOR)
        BUBBLE_FONT:DrawStringScaled(event.NoLabel, noPos.X, noPos.Y, scale, scale, TEXT_COLOR)
        BUBBLE_FONT:DrawStringScaled(tostring(data.DaydreamActivationTimer // 60), countdownPos.X, countdownPos.Y, scale, scale, TEXT_COLOR)

        local selectorOffset = Vector(0, -6)
        if data.DaydreamSelectionTrue then
            data.DaydreamSelector:Render(((yesPos + selectorOffset) - game.ScreenShakeOffset) + Vector(0, BUBBLE_FONT:GetLineHeight() / 2))
        else
            data.DaydreamSelector:Render(((noPos + selectorOffset) - game.ScreenShakeOffset) + Vector(0, BUBBLE_FONT:GetLineHeight() / 2))
        end
    elseif not data.DaydreamActivationTimer then
        sprite.Color = Color(1, 1, 1, sprite.Color.A - 0.05)
        if sprite.Color.A <= 0 then
            data.DaydreamSprite = nil
            data.DaydreamSelector = nil
        end
    end
end

function mod:DaydreamRender()
    if not mod:IsNormalRender(true) then
        return
    end
    
    local room = game:GetRoom()
    for _, player in ipairs(PlayerManager.GetPlayers()) do
        if player.Variant == PlayerVariant.PLAYER then
            mod:DaydreamPlayerRender(player, lastRenderOffset[player:GetPlayerIndex()] or Vector.Zero, room)
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_HUD_RENDER, mod.ITEM.COLLECTIBLE.DAYDREAM, mod.DaydreamRender)

mod:AddCollectibleCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.ITEM.COLLECTIBLE.DAYDREAM, function (_, player, offset)
    if mod:IsNormalRender(true) then
        lastRenderOffset[player:GetPlayerIndex()] = offset
    end
end, PlayerVariant.PLAYER)

---@param player EntityPlayer
function Daydream:HandleEventStats(player)
    local data = mod:GetEntityData(player).ffsavedata
    if not data then return end

    player.MoveSpeed = player.MoveSpeed + (data.DaydreamSpeedUp or 0)
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Daydream.HandleEventStats, CacheFlag.CACHE_SPEED)

Console.RegisterCommand(
    "ffdaydream",
    "Initiates a daydream event prompt",
    "Usage: ffdaydream <event name>",
    true,
    AutocompleteType.CUSTOM
)

function Daydream:DevConsoleAutocomplete(cmd, params)
    if cmd ~= "ffdaydream" then
        return
    end

    local list = {}
    for _, event in ipairs(events) do
        table.insert(list, event.Name)
    end

    return list
end

mod:AddCallback(ModCallbacks.MC_CONSOLE_AUTOCOMPLETE, Daydream.DevConsoleAutocomplete)

function Daydream:DevConsoleCommand(cmd, params)
    if cmd ~= "ffdaydream" then
        return
    end

    if params == "" then
        local rng = Isaac.GetPlayer():GetCollectibleRNG(mod.ITEM.COLLECTIBLE.DAYDREAM)
        local event = Daydream:GetRandomEvent(Isaac.GetPlayer(), rng)
        Daydream:RunEvent(Isaac.GetPlayer(), event)
        return
    end

    for _, event in ipairs(events) do
        if event.Name == params then
            Daydream:RunEvent(Isaac.GetPlayer(), event)
            return
        end
    end

    print("Event \"" .. params .. "\" not found!")
end

mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, Daydream.DevConsoleCommand)

---@param player EntityPlayer
function Daydream:HandleUnlock(_, _, _, _, _, player)
    local history = player:GetHistory()
    local count = 0

    local set = {}
    for _, collectible in ipairs(mod.DaydreamUnlockItems) do
        set[collectible] = true
    end

    for _, item in ipairs(history:GetCollectiblesHistory()) do
        if not item:IsTrinket() and set[item:GetItemID()] then
            count = count + 1
        end

        if count >= DAYDREAM_UNLOCK_REQUIREMENT then
            break
        end
    end

    if count >= DAYDREAM_UNLOCK_REQUIREMENT and not mod.ACHIEVEMENT.DAYDREAM:IsUnlocked(true) then
        mod.ACHIEVEMENT.DAYDREAM:Unlock()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, Daydream.HandleUnlock)