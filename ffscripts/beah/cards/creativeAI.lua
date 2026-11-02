local mod = FiendFolio
local game = Game()
local hud = game:GetHUD()

local cachedIconSprite = -1
local newIconSprite = Sprite()
newIconSprite:Load("gfx/effects/effect_wickeditempopup.anm2", true)
newIconSprite:Play("Idle")
local sfx = SFXManager()

local bovSprite = Sprite()
bovSprite:Load("gfx/effects/effect_wickeditempopup.anm2", true)
bovSprite:ReplaceSpritesheet(0, "gfx/ui/hud_bookofvirtues.png", true)
bovSprite:Play("Idle")

local indicator = Sprite()
indicator:Load("gfx/effects/effect_wickeditempopup.anm2", true)
indicator:ReplaceSpritesheet(0, "gfx/items/collectibles/collectible_bookofgenesis.png", true)
indicator:Play("Idle")

local flashduration = 16

--feel free to add to this, other mod developers! and fiendfolio developers but ill probably be the one adding all the fiendfolio items!
mod.creativeAIValidItems = {
    CollectibleType.COLLECTIBLE_BIBLE,
    CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL,
    CollectibleType.COLLECTIBLE_NECRONOMICON,
    CollectibleType.COLLECTIBLE_POOP,
    CollectibleType.COLLECTIBLE_MR_BOOM,
    CollectibleType.COLLECTIBLE_TAMMYS_HEAD,
    --CollectibleType.COLLECTIBLE_MOMS_BRA,
    --CollectibleType.COLLECTIBLE_KAMIKAZE,
    --CollectibleType.COLLECTIBLE_MOMS_PAD,
    CollectibleType.COLLECTIBLE_TELEPORT,
    CollectibleType.COLLECTIBLE_YUM_HEART,
    CollectibleType.COLLECTIBLE_DOCTORS_REMOTE,
    --CollectibleType.COLLECTIBLE_LEMON_MISHAP,
    CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS,
    --CollectibleType.COLLECTIBLE_ANARCHIST_COOKBOOK,
    --CollectibleType.COLLECTIBLE_HOURGLASS,
    --CollectibleType.COLLECTIBLE_MY_LITTLE_UNICORN,
    CollectibleType.COLLECTIBLE_BOOK_OF_REVELATIONS,
    CollectibleType.COLLECTIBLE_THE_NAIL,
    CollectibleType.COLLECTIBLE_WE_NEED_TO_GO_DEEPER,
    CollectibleType.COLLECTIBLE_DECK_OF_CARDS,
    --CollectibleType.COLLECTIBLE_MONSTROS_TOOTH,
    --CollectibleType.COLLECTIBLE_GAMEKID,
    CollectibleType.COLLECTIBLE_BOOK_OF_SIN,
    CollectibleType.COLLECTIBLE_MOMS_BOTTLE_OF_PILLS,
    CollectibleType.COLLECTIBLE_D6,
    --CollectibleType.COLLECTIBLE_PINKING_SHEARS,
    --CollectibleType.COLLECTIBLE_BEAN,
    CollectibleType.COLLECTIBLE_MONSTER_MANUAL,
    --CollectibleType.COLLECTIBLE_DEAD_SEA_SCROLLS,
    CollectibleType.COLLECTIBLE_RAZOR_BLADE,
    CollectibleType.COLLECTIBLE_PONY,
    CollectibleType.COLLECTIBLE_GUPPYS_PAW,
    CollectibleType.COLLECTIBLE_IV_BAG,
    --FORGET ME NOT
    --CollectibleType.COLLECTIBLE_BEST_FRIEND,
    --CollectibleType.COLLECTIBLE_REMOTE_DETONATOR,
    CollectibleType.COLLECTIBLE_GUPPYS_HEAD,
    CollectibleType.COLLECTIBLE_PRAYER_CARD,
    --CollectibleType.COLLECTIBLE_NOTCHED_AXE, --needs testing
    CollectibleType.COLLECTIBLE_CRYSTAL_BALL,
    CollectibleType.COLLECTIBLE_CRACK_THE_SKY,
    CollectibleType.COLLECTIBLE_D20,
    --CollectibleType.COLLECTIBLE_SPIDER_BUTT,
    CollectibleType.COLLECTIBLE_DADS_KEY,
    CollectibleType.COLLECTIBLE_PORTABLE_SLOT,
    CollectibleType.COLLECTIBLE_WHITE_PONY,
    --CollectibleType.COLLECTIBLE_TELEPATHY_BOOK,
    --CLEA RUNE
    --CollectibleType.COLLECTIBLE_HOW_TO_JUMP,
    CollectibleType.COLLECTIBLE_D100,
    CollectibleType.COLLECTIBLE_D4,
    CollectibleType.COLLECTIBLE_D10,
    --BLANK CARD
    CollectibleType.COLLECTIBLE_BOOK_OF_SECRETS,
    --CollectibleType.COLLECTIBLE_BOX_OF_SPIDERS,
    --CollectibleType.COLLECTIBLE_THE_JAR,
    CollectibleType.COLLECTIBLE_FLUSH,
    CollectibleType.COLLECTIBLE_SATANIC_BIBLE,
    CollectibleType.COLLECTIBLE_HEAD_OF_KRAMPUS,
    --CollectibleType.COLLECTIBLE_BUTTER_BEAN,
    CollectibleType.COLLECTIBLE_MAGIC_FINGERS,
    CollectibleType.COLLECTIBLE_CONVERTER,
    --PANDORAS BOX
    --CollectibleType.COLLECTIBLE_UNICORN_STUMP,
    --CollectibleType.COLLECTIBLE_ISAACS_TEARS,
    CollectibleType.COLLECTIBLE_UNDEFINED,
    --CollectibleType.COLLECTIBLE_SCISSORS,
    --BREATH OF LIFE (NEEDS TESTING B UT IM GONNA ASSUME NO)
    --CollectibleType.COLLECTIBLE_BOOMERANG,
    --DIPLO AND PLACEBO (START OF AB)
    CollectibleType.COLLECTIBLE_WOODEN_NICKEL,
    --CollectibleType.COLLECTIBLE_MEGA_BEAN,
    --CollectibleType.COLLECTIBLE_GLASS_CANNON, NEEDS TESTING BUT IM GONNA ASSUME NO
    --CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS,
    --CollectibleType.COLLECTIBLE_FRIEND_BALL,
    --CollectibleType.COLLECTIBLE_TEAR_DETONATOR,
    CollectibleType.COLLECTIBLE_D12,
    CollectibleType.COLLECTIBLE_VENTRICLE_RAZOR, --NEEDS TESTING
    CollectibleType.COLLECTIBLE_D8,
    CollectibleType.COLLECTIBLE_TELEPORT_2,
    --CollectibleType.COLLECTIBLE_KIDNEY_BEAN,
    --GLOWING HOURGLASS
    --CollectibleType.COLLECTIBLE_MINE_CRAFTER,
    --JAR OF FLIES
    CollectibleType.COLLECTIBLE_D7,
    CollectibleType.COLLECTIBLE_MOMS_BOX,
    CollectibleType.COLLECTIBLE_MEGA_BLAST,
    --PLAN C (START OF AB+)
    CollectibleType.COLLECTIBLE_D1,
    --CollectibleType.COLLECTIBLE_VOID,
    --CollectibleType.COLLECTIBLE_PAUSE,
    CollectibleType.COLLECTIBLE_SMELTER,
    CollectibleType.COLLECTIBLE_COMPOST,
    CollectibleType.COLLECTIBLE_DATAMINER,
    -- CollectibleType.COLLECTIBLE_CLICKER, 
    --CollectibleType.COLLECTIBLE_WAIT_WHAT,
    CollectibleType.COLLECTIBLE_CROOKED_PENNY,
    CollectibleType.COLLECTIBLE_DULL_RAZOR,
    CollectibleType.COLLECTIBLE_POTATO_PEELER,
    CollectibleType.COLLECTIBLE_METRONOME,
    --EDENS SOUL, DINFINITY
    --CollectibleType.COLLECTIBLE_BROWN_NUGGET,
    CollectibleType.COLLECTIBLE_SHARP_STRAW,
    CollectibleType.COLLECTIBLE_DELIRIOUS,
    CollectibleType.COLLECTIBLE_BLACK_HOLE,
    --MYSTERY GIFT
    --CollectibleType.COLLECTIBLE_SPRINKLER,
    CollectibleType.COLLECTIBLE_COUPON,
    --CollectibleType.COLLECTIBLE_TELEKINESIS,
    --CollectibleType.COLLECTIBLE_MOVING_BOX,
    --CollectibleType.COLLECTIBLE_MR_ME,
    --SAC ALTER
    CollectibleType.COLLECTIBLE_BOOK_OF_THE_DEAD,
    --BROKEN SHOVELS
    CollectibleType.COLLECTIBLE_GOLDEN_RAZOR, --START OF REP
    CollectibleType.COLLECTIBLE_SULFUR,
    CollectibleType.COLLECTIBLE_FORTUNE_COOKIE,
    --DAMOCLES
    --CollectibleType.COLLECTIBLE_FREE_LEMONADE,
    CollectibleType.COLLECTIBLE_RED_KEY,
    --CollectibleType.COLLECTIBLE_WAVY_CAP, ACCESSIBILITY REASONS
    --BOV AND ALABASTER BOX
    CollectibleType.COLLECTIBLE_MOMS_BRACELET,
    --CollectibleType.COLLECTIBLE_SCOOPER,
    CollectibleType.COLLECTIBLE_ETERNAL_D6,
    --CollectibleType.COLLECTIBLE_LARYNX, --NEEDS TESTING
    --GENESIS
    CollectibleType.COLLECTIBLE_SHARP_KEY,
    --CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE,
    --CollectibleType.COLLECTIBLE_MEAT_CLEAVER,
    CollectibleType.COLLECTIBLE_STITCHES, --I WOULDVE BEEN SO SAD IF THIS DIDNT WORK
    --CollectibleType.COLLECTIBLE_ERASER,
    CollectibleType.COLLECTIBLE_YUCK_HEART,
    --CollectibleType.COLLECTIBLE_URN_OF_SOULS, --NEEDS TESTING BUT IM GONNA ASSUME NO
    CollectibleType.COLLECTIBLE_MAGIC_SKIN,
    --CollectibleType.COLLECTIBLE_PLUM_FLUTE,
    CollectibleType.COLLECTIBLE_VADE_RETRO, --NEEDS TESTING
    --CollectibleType.COLLECTIBLE_SPIN_TO_WIN, --buggy
    --JAR OF WISPS
    CollectibleType.COLLECTIBLE_FRIEND_FINDER,
    --ESAU JR, BERSERK
    CollectibleType.COLLECTIBLE_DARK_ARTS,
    CollectibleType.COLLECTIBLE_ABYSS,
    --CollectibleType.COLLECTIBLE_SUPLEX,
    --BAG OF CRAFTING
    CollectibleType.COLLECTIBLE_FLIP, --NEEDS TESTING
    CollectibleType.COLLECTIBLE_LEMEGETON,
    CollectibleType.COLLECTIBLE_SUMPTORIUM, --NEEDS TESTING
    --RECALL AND HOLD (SORRY)
    CollectibleType.COLLECTIBLE_KEEPERS_BOX,
    --CollectibleType.COLLECTIBLE_EVERYTHING_JAR,
    --CollectibleType.COLLECTIBLE_ANIMA_SOLA,
    CollectibleType.COLLECTIBLE_SPINDOWN_DICE,
    --CollectibleType.COLLECTIBLE_GELLO,
    --CollectibleType.COLLECTIBLE_DECAP_ATTACK,

    --fiendfolio
    mod.ITEM.COLLECTIBLE.ALPHA_COIN,
    --mod.ITEM.COLLECTIBLE.FIEND_FOLIO,
    mod.ITEM.COLLECTIBLE.D2,
    mod.ITEM.COLLECTIBLE.STORE_WHISTLE,
    --mod.ITEM.COLLECTIBLE.RISKS_REWARD,
    mod.ITEM.COLLECTIBLE.GOLEMS_ROCK,
    --GRAPPLING, GOLDEN FROG HEAD, SANGUINE HOOK
    mod.ITEM.COLLECTIBLE.FIDDLE_CUBE, 
    mod.ITEM.COLLECTIBLE.AVGM, 
    --mod.ITEM.COLLECTIBLE.MALICE,
    --mod.ITEM.COLLECTIBLE.BEDTIME_STORY,
    mod.ITEM.COLLECTIBLE.PURPLE_PUTTY,
    mod.ITEM.COLLECTIBLE.FIEND_MIX,
    --mod.ITEM.COLLECTIBLE.WHITE_PEPPER,
    mod.ITEM.COLLECTIBLE.GOLDEN_PLUM_FLUTE,
    --mod.ITEM.COLLECTIBLE.ETERNAL_D10,
    --mod.ITEM.COLLECTIBLE.TOY_CAMERA,
    mod.ITEM.COLLECTIBLE.THE_BROWN_HORN,
    --mod.ITEM.COLLECTIBLE.SNOW_GLOBE,
    --mod.ITEM.COLLECTIBLE.CHERRY_BOMB,
    mod.ITEM.COLLECTIBLE.AZURITE_SPINDOWN,
    --mod.ITEM.COLLECTIBLE.KING_WORM,
    mod.ITEM.COLLECTIBLE.DAZZLING_SLOT,
    --mod.ITEM.COLLECTIBLE.KALUS_HEAD,
    --mod.ITEM.COLLECTIBLE.LEMON_MISHUH,
    mod.ITEM.COLLECTIBLE.YICK_HEART,
    --mod.ITEM.COLLECTIBLE.GAMMA_GLOVES,
    mod.ITEM.COLLECTIBLE.SHREDDER,
    mod.ITEM.COLLECTIBLE.LOADED_D6,
    mod.ITEM.COLLECTIBLE.TORTURE_COOKIE,
    --mod.ITEM.COLLECTIBLE.DUSTY_D10,
    --mod.ITEM.COLLECTIBLE.HEDONISTS_COOKBOOK,
    --mod.ITEM.COLLECTIBLE.SCULPTED_PEPPER,
    mod.ITEM.COLLECTIBLE.HOW_TO_ROLL,
    mod.ITEM.COLLECTIBLE.FLIP_PHONE,
    --mod.ITEM.COLLECTIBLE.DOG_WHISTLE,
    --mod.ITEM.COLLECTIBLE.DOOMSDAY_CLOCK,
    --mod.ITEM.COLLECTIBLE.TELEPORT_ALPHA,
    mod.ITEM.COLLECTIBLE.HUMAN_DOMESTICATION_GUIDE,
    mod.ITEM.COLLECTIBLE.DYNAMITE_PACK,
    mod.ITEM.COLLECTIBLE.VOYAGER_VENDOR,
    --mod.ITEM.COLLECTIBLE.GRANDPAS_GATLING_GUN, --doesn't really work
    --mod.ITEM.COLLECTIBLE.SHADOW_CLUSTER,
    --mod.ITEM.COLLECTIBLE.DECK_BOX, --ERRORS
    mod.ITEM.COLLECTIBLE.STORY_OF_UNDERTALE, --SILLY
    --mod.ITEM.COLLECTIBLE.RESURRECTION,
    --mod.ITEM.COLLECTIBLE.SOLAR_TABLET,
    mod.ITEM.COLLECTIBLE.BOTTLE_CAP,
    --mod.ITEM.COLLECTIBLE.THE_PYX,
    --mod.ITEM.COLLECTIBLE.HOLY_BEAN,
    --mod.ITEM.COLLECTIBLE.BLACK_EYED_PEA,
    --mod.ITEM.COLLECTIBLE.ECHOLILAC,
    mod.ITEM.COLLECTIBLE.SNOOZE_BUTTON,
    mod.ITEM.COLLECTIBLE.ANARCHISTS_EASY_BAKE,
    --mod.ITEM.COLLECTIBLE.LASER_POINTER,
    --mod.ITEM.COLLECTIBLE.SERTRALINE,
    mod.ITEM.COLLECTIBLE.YCUK_HEART,
    mod.ITEM.COLLECTIBLE.BAPHOMETS_EXCHANGE,
    mod.ITEM.COLLECTIBLE.DSTOCK,
    mod.ITEM.COLLECTIBLE.CLOWN_HORN,
    mod.ITEM.COLLECTIBLE.FIND_IT,
    mod.ITEM.COLLECTIBLE.KALUS_WICKED_PAW,
}

--local retryAttempts = 3
local function useCard(_, _, player, flags)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_SHOVEL) or #Isaac.FindByType(5, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_MOMS_SHOVEL) > 0 then
        sfx:Play(SoundEffect.SOUND_THUMBS_DOWN)
        hud:ShowFortuneText("no softlock please")
        return
    end
    local p_data = mod:GetEntityData(player).ffsavedata.RunEffects
    local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.OLD_TESTAMENT)
    if flags then mod:trySayAnnouncerLine(mod.Sounds.VACardSlayTheSpireCreativeAI, flags, 20) end

    local iconfig = Isaac.GetItemConfig()
    local c_id = _G.NextOldTestament or nil -- for debug purposes
    if c_id == nil then
        local i = rng:RandomInt(#mod.creativeAIValidItems)+1
        local throwable = mod.creativeAIValidItems[i]
        c_id = throwable
        --[[for i = 1, retryAttempts, 1 do
            local pooltype = pool:GetRandomPool(rng, false, {ItemPoolType.POOL_PLANETARIUM}) --sorry to any mods that add planetarium actives
            local collectibles = pool:GetCollectiblesFromPool(pooltype)

            mod:Shuffle(collectibles)
            for index, value in ipairs(collectibles) do
                local collectible = iconfig:GetCollectible(value.itemID)
                if collectible ~= nil and collectible.Type == ItemType.ITEM_ACTIVE and collectible.ChargeType ~= 2 then
                    c_id = value.itemID
                    goto found
                end
            end
        end ]]
    end
    --::found::
    if p_data.creativeAIItem ~= nil then
        mod:beahAddInnate(player, p_data.creativeAIItem, -1)
    end
    mod:beahAddInnate(player, c_id, 1)
    local nc = iconfig:GetCollectible(c_id)
    local desiredChargeType = nc.ChargeType
    local desiredMaxCharge = nc.MaxCharges
    p_data.creativeAIMaxCharge = desiredMaxCharge
    p_data.creativeAIChargeType = desiredChargeType

    if p_data.creativeAICleanupTable == nil then
        local cleanupTable = {}
        for i = 0, 1, 1 do
            local active = player:GetActiveItemDesc(i)
            local id = active.Item
                if id ~= 0 then

                    --print(id)
                local c = iconfig:GetCollectible(id)
                local oldChargeType = c.ChargeType
                --print(oldChargeType, desiredChargeType)
                if oldChargeType ~= desiredChargeType then
                    local charge = player:GetActiveCharge(i)
                    c.ChargeType = desiredChargeType
                    --mod.scheduleForUpdate(function ()
                        player:RemoveCollectible(id)
                        player:AddCollectible(id, charge, false, i)
                    --end, 0)

                    mod.savedata.run.creativeCleanTable = mod.savedata.run.creativeCleanTable or { }
                    mod.savedata.run.creativeCleanTable[""..id] = oldChargeType
                else
                    oldChargeType = nil
                end
                cleanupTable[""..id] = {
                    charge = active.Charge,
                    subcharge = active.PartialCharge,
                    overcharge = active.BatteryCharge,
                    typecharge = oldChargeType,
                } --look into debt charge also
                --print(cleanupTable[""..id].typecharge, oldChargeType)

                --it used to block the collectible but that broke it if you were holding stitches
            end
        end

        p_data.creativeAICleanupTable = cleanupTable
    end

    p_data.creativeAIItem = c_id
    p_data.CreativeAICachedBov = player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES)
    mod.scheduleForUpdate(function ()
        for i = 0, 1, 1 do
            player:SetActiveCharge(nc.InitCharge == -1 and nc.MaxCharges or nc.InitCharge, i)
        end
    end, 0)

    hud:ShowItemText(player, nc)
    sfx:Play(SoundEffect.SOUND_BEEP)
    --player:BlockCollectible(59) --not even gonna bother
end
mod:AddCallback(ModCallbacks.MC_USE_CARD, useCard, mod.ITEM.CARD.CREATIVE_AI)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function (_,_,_,player)
    useCard(_,_,player)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
        local p_data = mod:GetEntityData(player).ffsavedata.RunEffects
        player:TriggerBookOfVirtues(p_data.creativeAIItem)
    end
    return true
end, mod.ITEM.COLLECTIBLE.OLD_TESTAMENT)

local infiniteLoopProtector = false
local function useActiveItem(_, item, _, player, flags, slot)
    if infiniteLoopProtector then
        return
    end
    if flags & UseFlag.USE_OWNED > 0 or flags & UseFlag.USE_CARBATTERY > 0 then
        local p_data = mod:GetEntityData(player).ffsavedata.RunEffects
        if not p_data.creativeAICleanupTable then
            return
        end

        if p_data.creativeAICleanupTable[""..item] and p_data.creativeAIItem then
            ItemOverlay.Show(0, 0) --item overlays still play despite item effects not occuring. this overrides that
            -- aint that funny
            --bov nullification. which is rly silly that i have to do this
            if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
                player:TriggerBookOfVirtues(p_data.creativeAIItem)
                player:BlockCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES)
                        mod.scheduleForUpdate(function ()
                player:UnblockCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES)

                        end, 0)
            end


            infiniteLoopProtector = true
            player:UseActiveItem(p_data.creativeAIItem, flags, slot)
            infiniteLoopProtector = false
            return true
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, useActiveItem)

local currentBlinkFrames = nil
local function renderActiveItem(_,player, slot, offset, alpha, scale, chargeOffset)
    --oh dear heavens i have to rewrite the entire active item render code now dont i
    if slot > 1 then
        return
    end

    local p_data = mod:GetEntityData(player).ffsavedata.RunEffects
    if not p_data.creativeAICleanupTable then
        return
    end

    local item = FiendFolio.OverriddenFunctions.EntityPlayer.GetActiveItem(player, slot)
    if p_data.creativeAICleanupTable[""..item] then
        if player:HasCollectible(59) then
            offset = offset + Vector(0,4)
            chargeOffset = chargeOffset - Vector(0,3)
        end
        local creativeAiId = p_data.creativeAIItem
        local ccharge = player:GetActiveCharge(slot)
        local mcharge = player:GetActiveMaxCharge(slot)

        local gaster = player:HasCurseMistEffect()

        local vectorScale = Vector(scale, scale)

        if cachedIconSprite ~= creativeAiId then
            cachedIconSprite = creativeAiId
            local iconfig = Isaac.GetItemConfig()
            local coll = iconfig:GetCollectible(creativeAiId)
            local path = coll.GfxFileName
            newIconSprite:ReplaceSpritesheet(0, path)
            newIconSprite:LoadGraphics()
        end
        local rpos = offset+(Vector(16,16)*scale)

        newIconSprite.Scale = vectorScale

        -- bov
        if p_data.CreativeAICachedBov and slot == 0 then
            --local sheet = "gfx/ui/hud_bookofvirtues.png"
            --[[if mod:playerIsBelialMode(player) and player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
                sheet = "gfx/ui/hud_bookofvirtueswithbelial.png"
            elseif mod:playerIsBelialMode(player) then
                sheet = "gfx/ui/hud_bookofbelial.png"
            end, idk who added this but it specifically cant support book of belial right now ):]]

            --bovSprite:ReplaceSpritesheet(0, sheet, true)
            bovSprite:Render(rpos+Vector(0,7))
        end

        --outline
        --GOOD CODE :D
        --i approve -catinsured
        if ccharge == mcharge and mcharge ~= 0 and not gaster then
            newIconSprite.Color = Color(1,1,1,1,1,1,1)
            for i = 1, 4, 1 do
                local oset = Vector(0,scale):Rotated(90*i)
                newIconSprite:Render(rpos+oset)
            end
        end

        if gaster then
            newIconSprite.Color = Color(1,1,1,0.3) --good enough
        else
            newIconSprite.Color = Color(1,1,1,1)
        end

        newIconSprite:Render(rpos)

        --chargebar
        if mcharge > 0 and slot == 0 then
            local cbarSprite = hud:GetChargeBarSprite()
            cbarSprite.Scale = vectorScale

            local rPos = chargeOffset
            cbarSprite:Play("BarEmpty")
            cbarSprite:Render(rPos)

            if currentBlinkFrames == nil or currentBlinkFrames % 2 == 0 then
                local divisor = 1-(ccharge / mcharge)
                cbarSprite:Play("BarFull")
                cbarSprite:Render(rPos, Vector(1, 3 + (23*divisor))) --top is 3
            end
            if mcharge <= 8 or mcharge == 12 then
                local olay = "BarOverlay"..mcharge
                cbarSprite:Play(olay)
                cbarSprite:Render(rPos)
            end
        end

        --MANUALLY RUN POST_PLAYERHUD_RENDER_ACTIVE_ITEM
        Isaac.RunCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_ACTIVE_ITEM, player, slot, offset, alpha, scale, chargeOffset)

        --blink
        if p_data.CreativeAIFlash then
            p_data.CreativeAIFlash = p_data.CreativeAIFlash + 1
            if p_data.CreativeAIFlash >= flashduration then
                p_data.CreativeAIFlash = nil
            else
                local scaler = (1 - (p_data.CreativeAIFlash / flashduration))^0.65
                indicator.Color = Color(1,1,1,scaler)
                indicator.Scale = Vector(2-scaler, 2-scaler)
                indicator:Render(rpos)
            end
        end
        return true
    else
        cachedIconSprite = -1
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_ACTIVE_ITEM, 200, renderActiveItem)

local function getNewMaxCharge(_, item, player, _, maxCharge)
    if not mod:GetEntityData(player).ffsavedata then
        return
    end
    local p_data = mod:GetEntityData(player).ffsavedata.RunEffects
    if not p_data.creativeAICleanupTable then
        return
    end

    if p_data.creativeAICleanupTable[""..item] and p_data.creativeAIMaxCharge then
        return p_data.creativeAIMaxCharge
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_PLAYER_GET_ACTIVE_MAX_CHARGE, CallbackPriority.EARLY, getNewMaxCharge) --not sure what priority this should have

function mod:creativeAINewFloorCleanup(player)
    --i should also find a way to have this called before a run is exited
    local p_data = mod:GetEntityData(player).ffsavedata.RunEffects
    if p_data.creativeAICleanupTable then
        p_data.creativeAIMaxCharge = nil
        mod:beahAddInnate(player, p_data.creativeAIItem, -1)
        p_data.creativeAIItem = nil
        local iconfig = Isaac.GetItemConfig()
            for key, value in pairs(p_data.creativeAICleanupTable) do
                local id = tonumber(key)
                if value.typecharge then
                    local c = iconfig:GetCollectible(id)
                    c.ChargeType = value.typecharge
                end
                if player:HasCollectible(id) then
                    if value.typecharge then
                        mod.scheduleForUpdate(function ()
                            local charge, slot = mod:BeahCheckPlayerForActiveData(player, id)
                            player:RemoveCollectible(id)
                            player:AddCollectible(id, charge, false, slot)
                    end, 0)
                end

                local active = player:GetActiveItemDesc()
                active.Charge = value.charge
                active.PartialCharge = value.subcharge
                active.BatteryCharge = value.overcharge
            end
        end
        p_data.creativeAICleanupTable = nil

        --player:RemoveCollectible(mod.ITEM.COLLECTIBLE.CREATIVE_AI_NULL_ACTIVE)
        --player:UnblockCollectible(59) --not even gonna bother
    end
    mod.savedata.run.creativeCleanTable = nil
end

local function addCollectible(_, type, charge, _, _, _, player)
    --print("does this get called on restarting a run?")
    local iconfig = Isaac.GetItemConfig()
    if not mod:GetEntityData(player).ffsavedata then
        return
    end
    local p_data = mod:GetEntityData(player).ffsavedata.RunEffects
    if not p_data then
        return
    end
    if p_data.creativeAICleanupTable then
        p_data.CreativeAICachedBov = player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) or mod:playerIsBelialMode(player)
        if p_data.creativeAICleanupTable[""..type] then
            return
        end
        local c = iconfig:GetCollectible(type)
        local oldChargeType = c.ChargeType
        if oldChargeType ~= p_data.creativeAIChargeType then
            c.ChargeType = p_data.creativeAIChargeType
            mod.savedata.run.creativeCleanTable = mod.savedata.run.creativeCleanTable or { }
            mod.savedata.run.creativeCleanTable[""..type] = oldChargeType
        else
            oldChargeType = nil
        end
        --print(oldChargeType, "taser taser taser")
        p_data.creativeAICleanupTable[""..type] = {
            charge = charge,
            subcharge = 0,
            overcharge = 0,
            typecharge = oldChargeType,
        }
    elseif mod.savedata.run.creativeCleanTable then
        local t = mod.savedata.run.creativeCleanTable[""..type]
        if t then
            local c = iconfig:GetCollectible(type)
            c.ChargeType = t
        end
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, CallbackPriority.LATE, addCollectible)

local function removeCollectible(_, player)
    local p_data = mod:GetEntityData(player).ffsavedata.RunEffects
    if p_data and p_data.creativeAICleanupTable then
        p_data.CreativeAICachedBov = player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, removeCollectible)

local function postAddCollectible(_, id, _, _, _, _, player)
    local p_data = mod:GetEntityData(player).ffsavedata.RunEffects
    if p_data and p_data.creativeAICleanupTable then
        p_data.CreativeAICachedBov = player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES)
    end
    --mod.scheduleForUpdate(function ()
        local lastcai = p_data.creativeAIItem
        p_data.creativeAIItem = nil
        local _, slot = mod:BeahCheckPlayerForActiveData(player, id)
        p_data.creativeAIItem = lastcai
        if slot == 0 and id ~= p_data.creativeAIItem and p_data.creativeAIItem ~= nil then
            p_data.CreativeAIFlash = 0
        end
    --end, 1)
end
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, postAddCollectible)

local blinkFrames = 9
local function checkForBlink(_, id)
    if id == SoundEffect.SOUND_BEEP or id == SoundEffect.SOUND_BATTERYCHARGE then --sometimes. my genius. its frightening
        currentBlinkFrames = blinkFrames
    end
end
mod:AddCallback(ModCallbacks.MC_POST_SFX_PLAY, checkForBlink, SoundEffect.SOUND_BEEP)
mod:AddCallback(ModCallbacks.MC_POST_SFX_PLAY, checkForBlink, SoundEffect.SOUND_BATTERYCHARGE)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function ()
    if currentBlinkFrames ~= nil then
        currentBlinkFrames = currentBlinkFrames - 1
        if currentBlinkFrames == 0 then
            currentBlinkFrames = nil
        end
    end
end)

local hasExited = true
function mod:creativeAIrunLoad()
    --sets items to their respective correct charge types
    if hasExited and mod.savedata.run.creativeCleanTable then
        hasExited = false
        local allPlayers = mod:GetAllPlayers()
        local iconfig = Isaac.GetItemConfig()
        for key, value in pairs(allPlayers) do
            local player = value
            local p_data = mod:GetEntityData(player).ffsavedata.RunEffects
            local creative = p_data.creativeAICleanupTable ~= nil
            for i = 0, 1, 1 do
                local active = FiendFolio.OverriddenFunctions.EntityPlayer.GetActiveItem(player, i)
                local setto = nil
                if creative then
                    --[[print(p_data.creativeAICleanupTable[""..active])
                    if p_data.creativeAICleanupTable[""..active] then
                        for key2, value2 in pairs(p_data.creativeAICleanupTable[""..active]) do
                            print(key2, value2)
                        end
                    end]]
                    if p_data.creativeAICleanupTable[""..active] and p_data.creativeAICleanupTable[""..active].typecharge then
                        setto = p_data.creativeAIChargeType
                    end
                else
                    if mod.savedata.run.creativeCleanTable[""..active] then
                        setto = mod.savedata.run.creativeCleanTable[""..active]
                    end
                end
                --print("setto", setto)

                if setto ~= nil then
                    --print("and yes, this works")
                    local c = iconfig:GetCollectible(active)
                    local charge = player:GetActiveCharge(i)
                    c.ChargeType = setto
                    player:RemoveCollectible(active)
                    --print(charge)
                    player:AddCollectible(active, charge, false, i)
                end
            end
        end
    end
end

local function runQuit()
    if mod.savedata.run.creativeCleanTable then
        local iconfig = Isaac.GetItemConfig()
        for key, value in pairs(mod.savedata.run.creativeCleanTable) do
            local id = tonumber(key)
            local c = iconfig:GetCollectible(id)
            c.ChargeType = value
        end
    end
    hasExited = true
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_GAME_EXIT, CallbackPriority.IMPORTANT, runQuit)

--this next experiment seems very very interesting
--called by EntityPlayer:GetActiveItem override in apioverrides.lua
function mod:getCreativeAIItem(player, slot)
    slot = slot or 0
    local p_data = mod:GetEntityData(player)
    if slot <= 1 and p_data.ffsavedata and p_data.ffsavedata.RunEffects and p_data.ffsavedata.RunEffects.creativeAIItem then
        return p_data.ffsavedata.RunEffects.creativeAIItem
    end
end
