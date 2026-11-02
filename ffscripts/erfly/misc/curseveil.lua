local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

--Helper Function examples

--By default, curse of the veil only hides whitelisted trinket variants
--Add them using these methods
--Chests are treated slightly differently, so set true to let the game assume it's that

--FiendFolio:VeilCurseLetPickupBeHidden(PickupVariant.PICKUP_BED)
--FiendFolio:VeilCurseLetPickupBeHidden(PickupVariant.PICKUP_MOMSCHEST, true)

--These functions allow you to block them from being hidden, or add a custom ANM2 for while it's hidden

--FiendFolio:VeilCurseAddPickupToBlacklist(PickupVariant.PICKUP_HEART,HeartSubType.HEART_ETERNAL)
--FiendFolio:VeilCurseAddPickupANM2Override("gfx/items/pick ups/mysterypickup_dangerous.anm2", PickupVariant.PICKUP_COIN,CoinSubType.COIN_LUCKYPENNY)

function FiendFolio:VeilCurseLetPickupBeHidden(variant, isChest)
    local usedTable = FiendFolio.VeiledPickupsWhitelist
    if isChest then
        usedTable = FiendFolio.VeiledChestsWhitelist
    end

    for i = 1, #usedTable do
        local alreadyIn
        if usedTable[i] == variant then
            alreadyIn = true
            break
        end
        if not alreadyIn then
            table.insert(usedTable, variant)
        end
    end
end
function FiendFolio:VeilCurseAddPickupToBlacklist(variant,subtype)
    if FiendFolio.BlacklistMysteryPickup[variant] then
        local varTabType = type(FiendFolio.BlacklistMysteryPickup[variant])
        if varTabType ~= "boolean" then
            if varTabType == "table" then
                FiendFolio.BlacklistMysteryPickup[variant][subtype] = true
            end
        end
    else
        FiendFolio.BlacklistMysteryPickup[variant] = {}
        FiendFolio.BlacklistMysteryPickup[variant][subtype] = true
    end
end
function FiendFolio:VeilCurseAddPickupANM2Override(filepath,variant,subtype)
    if FiendFolio.OverrideMysteryPickup[variant] then
        local varTabType = type(FiendFolio.OverrideMysteryPickup[variant])
        if varTabType ~= "string" then
            if varTabType == "table" then
                FiendFolio.OverrideMysteryPickup[variant][subtype] = filepath
            end
        end
    else
        FiendFolio.OverrideMysteryPickup[variant] = {}
        FiendFolio.OverrideMysteryPickup[variant][subtype] = true
    end
end

mod.PickupsAreHidden = false

local function levelHasCurse(level, curse)
    if level == nil then return false end
    if curse == -1 then return false end
    return level:GetCurses() & (1 << curse - 1) >= (1 << curse - 1)
end

function mod:checkHasVeil()
    return levelHasCurse(game:GetLevel(), FiendFolio.curses.veilCurse) or mod.PickupsAreHidden
end

--[[mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, function(_, curses)
    --if (curses == LevelCurse.CURSE_NONE) then
    --local curse = 1 << (FiendFolio.curses.veilCurse - 1)
	    --return curse
    --end
end)]]

local function stopDropSounds()
    for i = 1, #FiendFolio.BlacklistMysterPickupDropSounds do
        sfx:Stop(FiendFolio.BlacklistMysterPickupDropSounds[i])
    end
    if Retribution then
        sfx:Stop(Retribution.Sound.DROP_WOOD)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, function(_, collectibleType, charge, firstTime, slot, varData, player)
	game:GetLevel():RemoveCurses(1 << FiendFolio.curses.veilCurse - 1)
end, CollectibleType.COLLECTIBLE_GUPPYS_EYE)

function mod:getExpectedVeilAnm2(pickup)
    local animOverride
    if pickup.Type == EntityType.ENTITY_PICKUP then
        if mod.OverrideMysteryPickup[pickup.Variant] then
            animOverride = mod.OverrideMysteryPickup[pickup.Variant] and mod.OverrideMysteryPickup[pickup.Variant][pickup.SubType] and mod.OverrideMysteryPickup[pickup.Variant][pickup.SubType] or mod.OverrideMysteryPickup[pickup.Variant]
        end
        animOverride = type(animOverride) == "string" and animOverride or nil
    end
    return animOverride or "gfx/items/pick ups/mystery_pickup.anm2"
end

local function tryHidePickup(pickup)
    if pickup.Type == EntityType.ENTITY_PICKUP then
        --high priority special checks
        for _, f in pairs(mod.BlacklistMysteryHighPriorityChecks) do
            if f(pickup) then return end
        end
        --regular check
        local isBlacklisted
        if mod.BlacklistMysteryPickup[pickup.Variant] then
            isBlacklisted = mod.BlacklistMysteryPickup[pickup.Variant] and mod.BlacklistMysteryPickup[pickup.Variant][pickup.SubType] and mod.BlacklistMysteryPickup[pickup.Variant][pickup.SubType] or mod.BlacklistMysteryPickup[pickup.Variant]
        end
        if isBlacklisted and type(isBlacklisted) == "boolean" then return end
        --low priority special checks
        for _, f in pairs(mod.BlacklistMysteryLowPriorityChecks) do
            if f(pickup) then return end
        end
    end

    local sprite, data = pickup:GetSprite(), mod:GetEntityData(pickup)
    local animOverride = mod:getExpectedVeilAnm2(pickup)
    --print(sprite:GetFilename(), animOverride)
    --Some stuff replaces their sprites later, just want to be safe
    if sprite:GetFilename() ~= animOverride then
        data.ReplacedByVeil = true
        local anim, frame = sprite:GetAnimation(), sprite:GetFrame()
        sprite:Load(animOverride, true)
        sprite:Play(anim)
        sprite:SetFrame(frame)
        sprite:Update()
        if REPENTOGON then
            local data = mod:GetEntityData(pickup)
            data.savedVeilShadowSize = data.savedVeilShadowSize or pickup:GetShadowSize()
            pickup:SetShadowSize(0)
        end
    end
    --Safety check in case it doesn't have layer 0 for some reason (failed for oily once)
    local layer = sprite:GetLayer(0)
    if layer then
        layer:SetCropOffset(Vector.Zero)
    end
end

local checkVars = {
    [PickupVariant.PICKUP_PILL] = true,
    [PickupVariant.PICKUP_TAROTCARD] = true,
    [PickupVariant.PICKUP_TRINKET] = true,
}

local function shouldBeHidden(pickup)
    local var = pickup.Variant
    if checkVars[var] then
        if (pickup.SpawnerType ~= 1)
        or (mod:GetEntityData(pickup).ReplacedByVeil)
        then
            return true
        end
    else
        return true
    end
end

function mod:HiddenPickupHandling(pickup)
    --[[if levelHasCurse(game:GetLevel(), FiendFolio.curses.veilCurse) then
        print("hi")
    end]]
    if (levelHasCurse(game:GetLevel(), FiendFolio.curses.veilCurse) or mod.PickupsAreHidden)
    and shouldBeHidden(pickup) then
        tryHidePickup(pickup)
        local sprite = pickup:GetSprite()
        if sprite:IsEventTriggered("DropSound") then
            stopDropSounds()
            for i = 0, 3 do
                mod.scheduleForUpdate(function()
                    stopDropSounds()
                end, i, ModCallbacks.MC_POST_RENDER, true)
            end
            sfx:Play(mod.Sounds.D5WoodImpact, 1, 0, false, mod:RandomInt(50,150)/100)
        end

        local bomb = pickup:ToBomb()
        if bomb and sprite:IsPlaying("BombReturn") then
            bomb:UpdateDirtColor(true)
        end
    end
end
function mod:HiddenChestsHandling(pickup)
    if levelHasCurse(game:GetLevel(), FiendFolio.curses.veilCurse) or mod.PickupsAreHidden then
        if pickup.Type == EntityType.ENTITY_PICKUP then
            local isBlacklisted
            if mod.BlacklistMysteryPickup[pickup.Variant] then
                isBlacklisted = mod.BlacklistMysteryPickup[pickup.Variant] and mod.BlacklistMysteryPickup[pickup.Variant][pickup.SubType] and mod.BlacklistMysteryPickup[pickup.Variant][pickup.SubType] or mod.BlacklistMysteryPickup[pickup.Variant]
            end
            if isBlacklisted and type(isBlacklisted) == "boolean" then return end
        end

        local sprite = pickup:GetSprite()
        local anim, frame = sprite:GetAnimation(), sprite:GetFrame()
        if pickup.FrameCount <= 1
        or (sprite:IsPlaying("CloseBack") and sprite:IsEventTriggered("DropSound"))
        or (sprite:IsPlaying("Close") and frame == 3)
        then
            local data = mod:GetEntityData(pickup)
            local animOverride
            if pickup.Type == EntityType.ENTITY_PICKUP then
                if mod.OverrideMysteryPickup[pickup.Variant] then
                    animOverride = mod.OverrideMysteryPickup[pickup.Variant] and mod.OverrideMysteryPickup[pickup.Variant][pickup.SubType] and mod.OverrideMysteryPickup[pickup.Variant][pickup.SubType] or mod.OverrideMysteryPickup[pickup.Variant]
                end
                animOverride = type(animOverride) == "string" and animOverride or nil
            end
            data.savedVeilAnim = data.savedVeilAnim or sprite:GetFilename()
            sprite:Load(animOverride or "gfx/items/slots/mystery_chest.anm2", true)
            sprite:Play(anim)
            sprite:SetFrame(frame)
            sprite:Update()
            if REPENTOGON then
                data.savedVeilShadowSize = data.savedVeilShadowSize or pickup:GetShadowSize()
                pickup:SetShadowSize(0)
            end
        end
        if FiendFolio.VeilChestClearAnimations[anim] then
            local data = mod:GetEntityData(pickup)
            if data.savedVeilAnim then
                sprite:Load(data.savedVeilAnim, true)
                sprite:Play(anim)
                sprite:SetFrame(frame)
                sprite:Update()
                if data.savedVeilShadowSize then
                    pickup:SetShadowSize(data.savedVeilShadowSize)
                end
                data.savedVeilAnim = nil
                data.savedVeilShadowSize = nil
            end
        end
    end
end
function mod:HiddenPickupInit(pickup)
    if (levelHasCurse(game:GetLevel(), FiendFolio.curses.veilCurse) or mod.PickupsAreHidden)
    and shouldBeHidden(pickup) then
        tryHidePickup(pickup)
    end
end
function mod:HiddenChestInit(pickup)
    if levelHasCurse(game:GetLevel(), FiendFolio.curses.veilCurse) or mod.PickupsAreHidden then
        if pickup.Type == EntityType.ENTITY_PICKUP then
            local isBlacklisted
            if mod.BlacklistMysteryPickup[pickup.Variant] then
                isBlacklisted = mod.BlacklistMysteryPickup[pickup.Variant] and mod.BlacklistMysteryPickup[pickup.Variant][pickup.SubType] and mod.BlacklistMysteryPickup[pickup.Variant][pickup.SubType] or mod.BlacklistMysteryPickup[pickup.Variant]
            end
            if isBlacklisted and type(isBlacklisted) == "boolean" then return end
        end

        if REPENTOGON then
            local data = mod:GetEntityData(pickup)
            data.savedVeilShadowSize = data.savedVeilShadowSize or pickup:GetShadowSize()
            pickup:SetShadowSize(0)
        end
    end
end

function mod:veilTrinketQueueCheck(player, queueItem)
    if levelHasCurse(game:GetLevel(), FiendFolio.curses.veilCurse) or mod.PickupsAreHidden then
        local defaultGfx = queueItem.GfxFileName
        local sprite = player:GetHeldSprite()
        if sprite:GetLayer(0):GetSpritesheetPath() == "gfx/items/pick ups/mystery_pickup.png" then
            sprite:ReplaceSpritesheet(0, defaultGfx)
            sprite:LoadGraphics()
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    if REPENTOGON then
        local hasVeil = levelHasCurse(game:GetLevel(), FiendFolio.curses.veilCurse) or mod.PickupsAreHidden
        if hasVeil then
            --Global so it doesn't break on luamod
            if not FiendFolioMinimapIsVeiled then
                FiendFolioMinimapIsVeiled = true
                --Base minimap (replace only the replaced pickups with a ? icon)
                local sprite = Minimap:GetIconsSprite()
                sprite:ReplaceSpritesheet(0, "gfx/ui/minimap_icons_veil.png")
                sprite:LoadGraphics()
                --Minimap API (replace all type 5s with a ? icon)
                --Forgive me padre for the sinning I am doing, but damn does it work
                if MinimapAPI then
                    for i = 1, #mod.VeiledPickupsWhitelist do
                        MinimapAPI:AddPickup("VeilQuestion" .. i,"VeilQuestionIcon",5,mod.VeiledPickupsWhitelist[i],nil,mod.checkHasVeil,"specialFFgroup",999999, mod.checkHasVeil)
                    end
                    for i = 1, #mod.VeiledChestsWhitelist do
                        MinimapAPI:AddPickup("VeilQuestionChest".. i,"VeilQuestionChestIcon",5,mod.VeiledChestsWhitelist[i],nil,mod.checkHasVeil,"chests",9999999,mod.checkHasVeil)
                    end
                end
            end
        elseif FiendFolioMinimapIsVeiled then
            FiendFolioMinimapIsVeiled = false
            --Base minimap (return it to normal)
            local sprite = Minimap:GetIconsSprite()
            sprite:ReplaceSpritesheet(0, "gfx/ui/minimap_icons.png")
            sprite:LoadGraphics()
            --Minimap API (get rid of the new overriding icons)
            if MinimapAPI then
                for i = 1, #mod.VeiledChestsWhitelist do
                    MinimapAPI:RemovePickup("VeilQuestion" .. i)
                end
                for i = 1, #mod.VeiledChestsWhitelist do
                    MinimapAPI:RemovePickup("VeilQuestionChest" .. i)
                end
            end
        end
    end
end)

local function veilEIDCondition(descObj)
    if levelHasCurse(game:GetLevel(), FiendFolio.curses.veilCurse) or mod.PickupsAreHidden then
        if descObj.ObjType == 5 and descObj.Entity and shouldBeHidden(descObj.Entity) then
            local shouldHide
            for i = 1, #FiendFolio.VeiledPickupsWhitelist do
                if descObj.ObjVariant == FiendFolio.VeiledPickupsWhitelist[i] then
                    return true
                end
            end
        end
    end
end

local function veilEIDCallback(descObj)
	descObj.Name = ""
	descObj.Description = ""
	descObj.Icon = nil -- also tested {"Blank", 0, 0, 0}
	descObj.ModName = nil
	return descObj
end

--Waits a moment to let other mods add to it potentially
mod.scheduleForUpdate(function()
    if Retribution then
        local fineItems = {
            Retribution.PickupVariant.COINSTACK,
            Retribution.PickupVariant.CELESTIAL_BERRY,
            Retribution.PickupVariant.WOODEN_PICKUP,
            Retribution.PickupVariant.SPOILS_COIN,
            Retribution.PickupVariant.MINICAPSULE,
        }
        for i = 1, #fineItems do
            table.insert(FiendFolio.VeiledPickupsWhitelist, fineItems[i])
        end
    end
    for i = 1, #FiendFolio.VeiledPickupsWhitelist do
        mod:AddPriorityCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, CallbackPriority.LATE, mod.HiddenPickupHandling, FiendFolio.VeiledPickupsWhitelist[i])
        mod:AddPriorityCallback(ModCallbacks.MC_POST_PICKUP_INIT, CallbackPriority.LATE, mod.HiddenPickupInit, FiendFolio.VeiledPickupsWhitelist[i])
    end
    for i = 1, #FiendFolio.VeiledChestsWhitelist do
        mod:AddPriorityCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, CallbackPriority.LATE, mod.HiddenChestsHandling, FiendFolio.VeiledChestsWhitelist[i])
        mod:AddPriorityCallback(ModCallbacks.MC_POST_PICKUP_INIT, CallbackPriority.LATE, mod.HiddenChestInit, FiendFolio.VeiledChestsWhitelist[i])
    end

    if EID then
        EID:addDescriptionModifier("FF Veil Modifier", veilEIDCondition, veilEIDCallback)
    end
end, 1, ModCallbacks.MC_POST_RENDER, true)


mod:AddPriorityCallback(ModCallbacks.MC_POST_BOMB_UPDATE, CallbackPriority.LATE, mod.HiddenPickupHandling, BombVariant.BOMB_TROLL)
mod:AddPriorityCallback(ModCallbacks.MC_POST_BOMB_UPDATE, CallbackPriority.LATE, mod.HiddenPickupHandling, BombVariant.BOMB_SUPERTROLL)
mod:AddPriorityCallback(ModCallbacks.MC_POST_BOMB_UPDATE, CallbackPriority.LATE, mod.HiddenPickupHandling, BombVariant.BOMB_HOT) --Only hot troll bombs
mod:AddPriorityCallback(ModCallbacks.MC_POST_BOMB_UPDATE, CallbackPriority.LATE, mod.HiddenPickupHandling, BombVariant.BOMB_GOLDENTROLL)
mod:AddPriorityCallback(ModCallbacks.MC_POST_BOMB_UPDATE, CallbackPriority.LATE, mod.HiddenPickupHandling, BombVariant.BOMB_THROWABLE)
