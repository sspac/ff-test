local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local DROP_CHANCE = 0.01

local vendingMachineItems = {
    Vanilla = {
        {Item = CollectibleType.COLLECTIBLE_BIBLE},
        {Item = CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL},
        {Item = CollectibleType.COLLECTIBLE_NECRONOMICON},
        {Item = CollectibleType.COLLECTIBLE_POOP, ForceAnim = "UseItem"},
        {Item = CollectibleType.COLLECTIBLE_MR_BOOM, ForceAnim = "UseItem"},
        {Item = CollectibleType.COLLECTIBLE_TAMMYS_HEAD},
        {Item = CollectibleType.COLLECTIBLE_MOMS_BRA},
        {Item = CollectibleType.COLLECTIBLE_KAMIKAZE, ForceAnim = "UseItem"},
        {Item = CollectibleType.COLLECTIBLE_MOMS_PAD},
        {Item = CollectibleType.COLLECTIBLE_BOBS_ROTTEN_HEAD, Broken = true}, --Drains held active
        {Item = CollectibleType.COLLECTIBLE_TELEPORT},
        {Item = CollectibleType.COLLECTIBLE_YUM_HEART},
        {Item = CollectibleType.COLLECTIBLE_DOCTORS_REMOTE},
        {Item = CollectibleType.COLLECTIBLE_SHOOP_DA_WHOOP, Broken = true}, --Drains held active
        {Item = CollectibleType.COLLECTIBLE_LEMON_MISHAP},
        {Item = CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS},
        {Item = CollectibleType.COLLECTIBLE_ANARCHIST_COOKBOOK},
        {Item = CollectibleType.COLLECTIBLE_HOURGLASS},
        {Item = CollectibleType.COLLECTIBLE_MY_LITTLE_UNICORN, ForceAnim = "UseItem"},
        {Item = CollectibleType.COLLECTIBLE_BOOK_OF_REVELATIONS},
        {Item = CollectibleType.COLLECTIBLE_THE_NAIL},
        {Item = CollectibleType.COLLECTIBLE_WE_NEED_TO_GO_DEEPER},
        {Item = CollectibleType.COLLECTIBLE_DECK_OF_CARDS},
        {Item = CollectibleType.COLLECTIBLE_MONSTROS_TOOTH},
        {Item = CollectibleType.COLLECTIBLE_GAMEKID, ForceAnim = "UseItem"},
        {Item = CollectibleType.COLLECTIBLE_BOOK_OF_SIN},
        {Item = CollectibleType.COLLECTIBLE_MOMS_BOTTLE_OF_PILLS},
        {Item = CollectibleType.COLLECTIBLE_D6},
        {Item = CollectibleType.COLLECTIBLE_PINKING_SHEARS},
        {Item = CollectibleType.COLLECTIBLE_BEAN},
        {Item = CollectibleType.COLLECTIBLE_MONSTER_MANUAL},
        {Item = CollectibleType.COLLECTIBLE_DEAD_SEA_SCROLLS},
        {Item = CollectibleType.COLLECTIBLE_RAZOR_BLADE},
        {Item = CollectibleType.COLLECTIBLE_FORGET_ME_NOW}, --pls don't
        {Item = CollectibleType.COLLECTIBLE_PONY, Broken = true}, --Inconsistent, either gives item or charges based on movement
        --WOTL
        {Item = CollectibleType.COLLECTIBLE_GUPPYS_PAW},
        {Item = CollectibleType.COLLECTIBLE_IV_BAG},
        {Item = CollectibleType.COLLECTIBLE_BEST_FRIEND, ForceAnim = "UseItem"},
        {Item = CollectibleType.COLLECTIBLE_REMOTE_DETONATOR, Broken = true}, --Not how it works
        {Item = CollectibleType.COLLECTIBLE_GUPPYS_HEAD},
        {Item = CollectibleType.COLLECTIBLE_PRAYER_CARD},
        {Item = CollectibleType.COLLECTIBLE_NOTCHED_AXE, Broken = true}, --Borked
        {Item = CollectibleType.COLLECTIBLE_CRYSTAL_BALL},
        {Item = CollectibleType.COLLECTIBLE_CRACK_THE_SKY},
        {Item = CollectibleType.COLLECTIBLE_CANDLE, Broken = true}, --Drainer
        {Item = CollectibleType.COLLECTIBLE_D20},
        {Item = CollectibleType.COLLECTIBLE_SPIDER_BUTT},
        {Item = CollectibleType.COLLECTIBLE_DADS_KEY},
        {Item = CollectibleType.COLLECTIBLE_PORTABLE_SLOT, ForceAnim = "UseItem"},
        {Item = CollectibleType.COLLECTIBLE_WHITE_PONY, Broken = true}, --Same as the pony
        {Item = CollectibleType.COLLECTIBLE_BLOOD_RIGHTS},
        {Item = CollectibleType.COLLECTIBLE_TELEPATHY_BOOK},
        --Rebirth
        {Item = CollectibleType.COLLECTIBLE_CLEAR_RUNE}, --Awkwardly filling slot 263
        {Item = CollectibleType.COLLECTIBLE_HOW_TO_JUMP},
        {Item = CollectibleType.COLLECTIBLE_D100},
        {Item = CollectibleType.COLLECTIBLE_D4},
        {Item = CollectibleType.COLLECTIBLE_D10},
        {Item = CollectibleType.COLLECTIBLE_BLANK_CARD},
        {Item = CollectibleType.COLLECTIBLE_BOOK_OF_SECRETS},
        {Item = CollectibleType.COLLECTIBLE_BOX_OF_SPIDERS},
        {Item = CollectibleType.COLLECTIBLE_RED_CANDLE, Broken = true},
        {Item = CollectibleType.COLLECTIBLE_THE_JAR, Broken = true},
        {Item = CollectibleType.COLLECTIBLE_FLUSH},
        {Item = CollectibleType.COLLECTIBLE_SATANIC_BIBLE},
        {Item = CollectibleType.COLLECTIBLE_HEAD_OF_KRAMPUS},
        {Item = CollectibleType.COLLECTIBLE_BUTTER_BEAN, ForceAnim = "UseItem"},
        {Item = CollectibleType.COLLECTIBLE_MAGIC_FINGERS},
        {Item = CollectibleType.COLLECTIBLE_CONVERTER, ForceAnim = "UseItem"},
        {Item = CollectibleType.COLLECTIBLE_BLUE_BOX},
        {Item = CollectibleType.COLLECTIBLE_UNICORN_STUMP, ForceAnim = "UseItem"},
        {Item = CollectibleType.COLLECTIBLE_ISAACS_TEARS},
        {Item = CollectibleType.COLLECTIBLE_UNDEFINED},
        {Item = CollectibleType.COLLECTIBLE_SCISSORS},
        {Item = CollectibleType.COLLECTIBLE_BREATH_OF_LIFE, Broken = true},
        {Item = CollectibleType.COLLECTIBLE_BOOMERANG, Broken = true},
        --Afterbirth
        {Item = CollectibleType.COLLECTIBLE_DIPLOPIA},
        {Item = CollectibleType.COLLECTIBLE_PLACEBO},
        {Item = CollectibleType.COLLECTIBLE_WOODEN_NICKEL},
        {Item = CollectibleType.COLLECTIBLE_MEGA_BEAN},
        {Item = CollectibleType.COLLECTIBLE_GLASS_CANNON, Broken = true},
        {Item = CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS},
        {Item = CollectibleType.COLLECTIBLE_FRIEND_BALL, Broken = true},
        {Item = CollectibleType.COLLECTIBLE_TEAR_DETONATOR},
        {Item = CollectibleType.COLLECTIBLE_D12},
        {Item = CollectibleType.COLLECTIBLE_VENTRICLE_RAZOR},
        {Item = CollectibleType.COLLECTIBLE_D8},
        {Item = CollectibleType.COLLECTIBLE_TELEPORT_2},
        {Item = CollectibleType.COLLECTIBLE_KIDNEY_BEAN, ForceAnim = "UseItem"},
        {Item = CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS},
        {Item = CollectibleType.COLLECTIBLE_MINE_CRAFTER},
        {Item = CollectibleType.COLLECTIBLE_JAR_OF_FLIES, Broken = true},
        {Item = CollectibleType.COLLECTIBLE_D7},
        {Item = CollectibleType.COLLECTIBLE_MOMS_BOX},
        {Item = CollectibleType.COLLECTIBLE_MEGA_BLAST},
        {Item = CollectibleType.COLLECTIBLE_BROKEN_GLASS_CANNON, Broken = true},
        --Afterbirth+
        {Item = CollectibleType.COLLECTIBLE_PLAN_C},
        {Item = CollectibleType.COLLECTIBLE_D1},
        {Item = CollectibleType.COLLECTIBLE_VOID},
        {Item = CollectibleType.COLLECTIBLE_PAUSE},
        {Item = CollectibleType.COLLECTIBLE_SMELTER},
        {Item = CollectibleType.COLLECTIBLE_COMPOST},
        {Item = CollectibleType.COLLECTIBLE_DATAMINER},
        {Item = CollectibleType.COLLECTIBLE_CLICKER},
        {Item = CollectibleType.COLLECTIBLE_MAMA_MEGA},
        {Item = CollectibleType.COLLECTIBLE_WAIT_WHAT, ForceAnim = "UseItem"},
        {Item = CollectibleType.COLLECTIBLE_CROOKED_PENNY},
        {Item = CollectibleType.COLLECTIBLE_DULL_RAZOR},
        {Item = CollectibleType.COLLECTIBLE_POTATO_PEELER},
        {Item = CollectibleType.COLLECTIBLE_METRONOME},
        {Item = CollectibleType.COLLECTIBLE_D_INFINITY, Broken = true},
        {Item = CollectibleType.COLLECTIBLE_EDENS_SOUL},
        {Item = CollectibleType.COLLECTIBLE_BROWN_NUGGET},
        {Item = CollectibleType.COLLECTIBLE_SHARP_STRAW},
        {Item = CollectibleType.COLLECTIBLE_DELIRIOUS},
        {Item = CollectibleType.COLLECTIBLE_BLACK_HOLE, Broken = true},
        {Item = CollectibleType.COLLECTIBLE_MYSTERY_GIFT},
        {Item = CollectibleType.COLLECTIBLE_SPRINKLER},
        {Item = CollectibleType.COLLECTIBLE_COUPON},
        {Item = CollectibleType.COLLECTIBLE_TELEKINESIS},
        {Item = CollectibleType.COLLECTIBLE_MOVING_BOX},
        {Item = CollectibleType.COLLECTIBLE_MR_ME},
        {Item = CollectibleType.COLLECTIBLE_SACRIFICIAL_ALTAR},
        {Item = CollectibleType.COLLECTIBLE_BOOK_OF_THE_DEAD},
        {Item = CollectibleType.COLLECTIBLE_BROKEN_SHOVEL_1},
        {Item = CollectibleType.COLLECTIBLE_MOMS_SHOVEL},
        --Repentance
        {Item = CollectibleType.COLLECTIBLE_GOLDEN_RAZOR},
        {Item = CollectibleType.COLLECTIBLE_SULFUR},
        {Item = CollectibleType.COLLECTIBLE_FORTUNE_COOKIE},
        {Item = CollectibleType.COLLECTIBLE_DAMOCLES},
        {Item = CollectibleType.COLLECTIBLE_FREE_LEMONADE},
        {Item = CollectibleType.COLLECTIBLE_RED_KEY},
        {Item = CollectibleType.COLLECTIBLE_WAVY_CAP},
        {Item = CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES, Broken = true},
        {Item = CollectibleType.COLLECTIBLE_ALABASTER_BOX},
        {Item = CollectibleType.COLLECTIBLE_MOMS_BRACELET},
        {Item = CollectibleType.COLLECTIBLE_SCOOPER, ForceAnim = "UseItem"},
        {Item = CollectibleType.COLLECTIBLE_ETERNAL_D6},
        {Item = CollectibleType.COLLECTIBLE_LARYNX},
        {Item = CollectibleType.COLLECTIBLE_GENESIS},
        {Item = CollectibleType.COLLECTIBLE_SHARP_KEY, Broken = true},
        {Item = CollectibleType.COLLECTIBLE_MEGA_MUSH},
        {Item = CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE},
        {Item = CollectibleType.COLLECTIBLE_MEAT_CLEAVER},
        {Item = CollectibleType.COLLECTIBLE_STITCHES},
        {Item = CollectibleType.COLLECTIBLE_R_KEY},
        {Item = CollectibleType.COLLECTIBLE_ERASER, Broken = true},
        {Item = CollectibleType.COLLECTIBLE_YUCK_HEART},
        {Item = CollectibleType.COLLECTIBLE_URN_OF_SOULS, Broken = true},
        {Item = CollectibleType.COLLECTIBLE_MAGIC_SKIN},
        {Item = CollectibleType.COLLECTIBLE_PLUM_FLUTE},
        {Item = CollectibleType.COLLECTIBLE_VADE_RETRO, Broken = true},
        {Item = CollectibleType.COLLECTIBLE_SPIN_TO_WIN, Broken = true},
        {Item = CollectibleType.COLLECTIBLE_JAR_OF_WISPS},
        {Item = CollectibleType.COLLECTIBLE_FRIEND_FINDER},
        {Item = CollectibleType.COLLECTIBLE_ESAU_JR, Broken = true},
        {Item = CollectibleType.COLLECTIBLE_BERSERK, ForceAnim = "UseItem"},
        {Item = CollectibleType.COLLECTIBLE_DARK_ARTS},
        {Item = CollectibleType.COLLECTIBLE_ABYSS},
        {Item = CollectibleType.COLLECTIBLE_SUPLEX},
        {Item = CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING, Broken = true},
        {Item = CollectibleType.COLLECTIBLE_FLIP, Broken = true},
        {Item = CollectibleType.COLLECTIBLE_LEMEGETON},
        {Item = CollectibleType.COLLECTIBLE_SUMPTORIUM},
        {Item = CollectibleType.COLLECTIBLE_RECALL, Broken = true},
        {Item = CollectibleType.COLLECTIBLE_HOLD, Broken = true},
        {Item = CollectibleType.COLLECTIBLE_KEEPERS_BOX},
        {Item = CollectibleType.COLLECTIBLE_EVERYTHING_JAR, Broken = true},
        {Item = CollectibleType.COLLECTIBLE_ANIMA_SOLA},
        {Item = CollectibleType.COLLECTIBLE_SPINDOWN_DICE},
        {Item = CollectibleType.COLLECTIBLE_GELLO, Broken = true},
        {Item = CollectibleType.COLLECTIBLE_DECAP_ATTACK, Broken = true},
    },
    FF = {
        {Item = mod.ITEM.COLLECTIBLE.FIEND_FOLIO},
        {Item = mod.ITEM.COLLECTIBLE.D2},
        {Item = mod.ITEM.COLLECTIBLE.STORE_WHISTLE},
        {Item = mod.ITEM.COLLECTIBLE.RISKS_REWARD},
        {Item = mod.ITEM.COLLECTIBLE.ALPHA_COIN},
        {Item = mod.ITEM.COLLECTIBLE.MARIAS_IPAD},
        {Item = mod.ITEM.COLLECTIBLE.GOLEMS_ROCK},
        {Item = mod.ITEM.COLLECTIBLE.GRAPPLING_HOOK, Broken = true},
        {Item = mod.ITEM.COLLECTIBLE.FROG_HEAD, Broken = true},
        {Item = mod.ITEM.COLLECTIBLE.SANGUINE_HOOK},
        {Item = mod.ITEM.COLLECTIBLE.FIDDLE_CUBE, Broken = true},
        {Item = mod.ITEM.COLLECTIBLE.AVGM, StopSound = true},
        {Item = mod.ITEM.COLLECTIBLE.MALICE},
        {Item = mod.ITEM.COLLECTIBLE.CONTRABAND},
        {Item = mod.ITEM.COLLECTIBLE.CLEAR_CASE, Broken = true},
        {Item = mod.ITEM.COLLECTIBLE.BEDTIME_STORY},
        {Item = mod.ITEM.COLLECTIBLE.ETERNAL_D12, ED12 = 1},
        {Item = mod.ITEM.COLLECTIBLE.ETERNAL_D12, ED12 = 2},
        {Item = mod.ITEM.COLLECTIBLE.PURPLE_PUTTY},
        {Item = mod.ITEM.COLLECTIBLE.FIEND_MIX},
        {Item = mod.ITEM.COLLECTIBLE.WHITE_PEPPER},
        {Item = mod.ITEM.COLLECTIBLE.PERFECTLY_GENERIC_OBJECT_4},
        {Item = mod.ITEM.COLLECTIBLE.WRONG_WARP},
        {Item = mod.ITEM.COLLECTIBLE.GOLDEN_PLUM_FLUTE, Broken = true},
        {Item = mod.ITEM.COLLECTIBLE.DOGBOARD, Broken = true},
        {Item = mod.ITEM.COLLECTIBLE.ETERNAL_D10},
        {Item = mod.ITEM.COLLECTIBLE.TOY_CAMERA},
        {Item = mod.ITEM.COLLECTIBLE.THE_BROWN_HORN},
        {Item = mod.ITEM.COLLECTIBLE.ETERNAL_CLICKER},
        {Item = mod.ITEM.COLLECTIBLE.SNOW_GLOBE},
        {Item = mod.ITEM.COLLECTIBLE.CHERRY_BOMB},
        {Item = mod.ITEM.COLLECTIBLE.ASTROPULVIS},
        {Item = mod.ITEM.COLLECTIBLE.AZURITE_SPINDOWN},
        {Item = mod.ITEM.COLLECTIBLE.KING_WORM},
        {Item = mod.ITEM.COLLECTIBLE.DAZZLING_SLOT},
        {Item = mod.ITEM.COLLECTIBLE.KALUS_HEAD, Broken = true},
        {Item = mod.ITEM.COLLECTIBLE.RAT_POISON},
        {Item = mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_B, Broken = true},
        {Item = mod.ITEM.COLLECTIBLE.HORSE_PASTE},
        {Item = mod.ITEM.COLLECTIBLE.LEMON_MISHUH},
        {Item = mod.ITEM.COLLECTIBLE.NIL_PASTA},
        {Item = mod.ITEM.COLLECTIBLE.EMPTY_BOOK},
        {Item = mod.ITEM.COLLECTIBLE.YICK_HEART},
        {Item = mod.ITEM.COLLECTIBLE.GAMMA_GLOVES, ForceAnim = "HideItem", StopSound = true},
        {Item = mod.ITEM.COLLECTIBLE.SHREDDER},
        {Item = mod.ITEM.COLLECTIBLE.LOADED_D6},
        {Item = mod.ITEM.COLLECTIBLE.TORTURE_COOKIE},
        {Item = mod.ITEM.COLLECTIBLE.MOONBEAM},
        {Item = mod.ITEM.COLLECTIBLE.DUSTY_D10},
        {Item = mod.ITEM.COLLECTIBLE.HEDONISTS_COOKBOOK},
        {Item = mod.ITEM.COLLECTIBLE.HOW_TO_ROLL},
        {Item = mod.ITEM.COLLECTIBLE.DOG_WHISTLE},
        {Item = mod.ITEM.COLLECTIBLE.DOOMSDAY_CLOCK},
        {Item = mod.ITEM.COLLECTIBLE.TELEPORT_ALPHA},
        {Item = mod.ITEM.COLLECTIBLE.IMP_SODA_TRICKY_CHERRY, Broken = true},
        {Item = mod.ITEM.COLLECTIBLE.DYNAMITE_PACK},
        {Item = mod.ITEM.COLLECTIBLE.HUMAN_DOMESTICATION_GUIDE},
        {Item = mod.ITEM.COLLECTIBLE.THE_WAR_HORN},
        {Item = mod.ITEM.COLLECTIBLE.VOYAGER_VENDOR},
        {Item = mod.ITEM.COLLECTIBLE.MAMMONITE_CODEX},
        {Item = mod.ITEM.COLLECTIBLE.GRANDPAS_GATLING_GUN, Broken = true},
        {Item = mod.ITEM.COLLECTIBLE.SHADOW_CLUSTER},
        {Item = mod.ITEM.COLLECTIBLE.DECK_BOX, Broken = true},
        {Item = mod.ITEM.COLLECTIBLE.STORY_OF_UNDERTALE},
        {Item = mod.ITEM.COLLECTIBLE.TOYBOX},
        {Item = mod.ITEM.COLLECTIBLE.HOT_POTATO_BOOK},
        {Item = mod.ITEM.COLLECTIBLE.ACTIVATED_CHARCOAL},
        {Item = mod.ITEM.COLLECTIBLE.RESURRECTION},
        {Item = mod.ITEM.COLLECTIBLE.EDENS_HEAD},
        {Item = mod.ITEM.COLLECTIBLE.SOLAR_TABLET},
        {Item = mod.ITEM.COLLECTIBLE.OLD_TESTAMENT},
        {Item = mod.ITEM.COLLECTIBLE.BOTTLE_CAP},
        {Item = mod.ITEM.COLLECTIBLE.BOOK_OF_LEVIATHAN, Broken = true},
        {Item = mod.ITEM.COLLECTIBLE.THE_PYX},
        {Item = mod.ITEM.COLLECTIBLE.HOLY_BEAN},
        {Item = mod.ITEM.COLLECTIBLE.BLACK_EYED_PEA},
        {Item = mod.ITEM.COLLECTIBLE.SNOOZE_BUTTON},
        {Item = mod.ITEM.COLLECTIBLE.EARTH_OF_ADAM},
        {Item = mod.ITEM.COLLECTIBLE.LASER_POINTER, Broken = true},
        {Item = mod.ITEM.COLLECTIBLE.ANARCHISTS_EASY_BAKE},
    }
}

function mod.IsVendingMachineLocked(entry)
    return mod:VendingMachineReplacementCheck(entry.Variant, entry.Subtype)
end

function mod:VendingMachineReplacementCheck(var, subt)
    --if (not FiendFolio.ACHIEVEMENT.VENDING_MACHINE:IsUnlocked()) and (not (BasementRenovator and BasementRenovator.mod)) then
    --    return true
    --end

    local item
    if var == mod.FF.VendingMachine.Var then
        item = vendingMachineItems.Vanilla[math.floor(subt / 256) + 1]
    else
        item = vendingMachineItems.FF[math.floor(subt / 256) + 1]

        if not item.IgnoreAvailable then
            if FiendFolio.IsCollectibleLocked(item.Item) and not (BasementRenovator and game:GetLevel():GetCurrentRoomDesc().Data and BasementRenovator.InTestRoom and BasementRenovator:InTestRoom()) then
                return true
            end
        end
    end
    if not item.IgnoreAvailable then
        local itemConfig = Isaac.GetItemConfig()
        if not itemConfig:GetCollectible(item.Item):IsAvailable() and not (BasementRenovator and game:GetLevel():GetCurrentRoomDesc().Data and BasementRenovator.InTestRoom and BasementRenovator:InTestRoom()) then
            return true
        end
    end
    if item.Broken then
        return true
    end
end

function mod:GetVendingMachineSub(isVanilla, collectibleType, price, isOneUse)
    local sub = 0

    -- Get sub for collectible
    local targetTable = isVanilla and vendingMachineItems.Vanilla or vendingMachineItems.FF
    local collectibleIndex
    for i, entry in ipairs(targetTable) do
        if entry.Item == collectibleType then
            collectibleIndex = i-1
            break
        end
    end

    if not collectibleIndex then
        print("No", isVanilla and "vanilla" or "FF", "vending machine for item id", collectibleType, ":(")
        return
    end

    sub = sub + ((collectibleIndex << 8) | (1 >> 8))

    -- Get sub for price
    sub = sub + ((price << 1) | (1 >> 7) * 2)

    -- Get sub for if one-time use
    sub = sub + (isOneUse and 1 or 0)

    return sub
end

local function vendingMachineUpdate(_, slot)
    local sprite, d = slot:GetSprite(), mod:GetEntityData(slot)
	local data = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'SlotData', tostring(slot.InitSeed), {})

    if not d.init then
        slot:SetSize(9, Vector(3,1), 24)
        d.sizeMulti = Vector(2,1)
        d.price = math.floor((slot.SubType % 256) / 2)
        local dontSpawn
        if slot.Variant == mod.FF.VendingMachine.Var then
            d.item = vendingMachineItems.Vanilla[math.floor(slot.SubType / 256) + 1]
        else
            d.item = vendingMachineItems.FF[math.floor(slot.SubType / 256) + 1]
        end
        --print(d.item)
        data.oneUse = data.oneUse or (slot.SubType % 2 == 1)
        --d.item = {Item = CollectibleType.COLLECTIBLE_STITCHES, ForceAnim = "UseItem"}

        local ten = math.floor(d.price/10)
        --[[if ten == 0 then
            ten = "blank"
        end]]
        if slot.SubType % 2 == 1 then
            --cba to write a loop for this ok, don't kill me other modders
            sprite:ReplaceSpritesheet(0, "gfx/items/slots/vending machine/slot_vending_machine_singleuse.png")
            sprite:ReplaceSpritesheet(3, "gfx/items/slots/vending machine/slot_vending_machine_singleuse.png")
            sprite:ReplaceSpritesheet(4, "gfx/items/slots/vending machine/slot_vending_machine_singleuse.png")
            sprite:ReplaceSpritesheet(5, "gfx/items/slots/vending machine/slot_vending_machine_singleuse.png")
            sprite:ReplaceSpritesheet(7, "gfx/items/slots/vending machine/slot_vending_machine_singleuse.png")
        end
        sprite:ReplaceSpritesheet(1, "gfx/items/slots/vending machine/slot_vending_numbers_" .. ten .. ".png")
        sprite:ReplaceSpritesheet(2, "gfx/items/slots/vending machine/slot_vending_numbers_" .. d.price % 10 .. ".png")
        local curses = game:GetLevel():GetCurses()
        if curses == curses | LevelCurse.CURSE_OF_BLIND then
            sprite:ReplaceSpritesheet(6, "gfx/items/collectibles/questionmark.png")
        else
            sprite:ReplaceSpritesheet(6, Isaac.GetItemConfig():GetCollectible(d.item.Item).GfxFileName)
        end
        sprite:LoadGraphics()
        d.state = "idle"

        if EID then
            if not EID:hasCurseBlind() then
                local descriptionObject = EID:getDescriptionObj(5, 100, d.item.Item, slot)
                d.EID_Description = descriptionObject
            else
                d.EID_Description = { Icon = EID.InlineIcons["QuestionMark"], Description = "", Entity = slot, Name = "Vending Machine"}
            end
        end

        d.init = true
    end

    d.StateFrame = d.StateFrame or 0
    d.StateFrame = d.StateFrame + 1

    if d.state == "idle" then
        mod:spritePlay(sprite, "Idle")
    elseif d.state == "paid" then
        if not d.paymentAnims then
            d.paymentAnims = {}
            local remainingCosts = d.price
            if remainingCosts == 0 then
                d.paymentAnims = {"none"}
            else
                while remainingCosts > 0 do
                    if remainingCosts >= 99 then
                        table.insert(d.paymentAnims, "99c")
                        remainingCosts = remainingCosts - 99
                    elseif remainingCosts >= 50 then
                        table.insert(d.paymentAnims, "50c")
                        remainingCosts = remainingCosts - 50
                    elseif remainingCosts >= 10 then
                        table.insert(d.paymentAnims, "10c")
                        remainingCosts = remainingCosts - 10
                    elseif remainingCosts >= 5 then
                        table.insert(d.paymentAnims, "5c")
                        remainingCosts = remainingCosts - 5
                    elseif remainingCosts >= 1 then
                        table.insert(d.paymentAnims, "1c")
                        remainingCosts = remainingCosts - 1
                    end
                end
            end
            sprite.PlaybackSpeed = math.min(3, #d.paymentAnims)
        end
        if sprite:IsFinished("Initiate_" .. d.paymentAnims[1]) then
            table.remove(d.paymentAnims, 1)
            if #d.paymentAnims > 0 then
                sprite:Play("Initiate_" .. d.paymentAnims[1], true)
            else
                d.state = "paidPost"
                sprite.PlaybackSpeed = 1
            end
        else
            mod:spritePlay(sprite, "Initiate_" .. d.paymentAnims[1])
        end
    elseif d.state == "paidPost" then
        if sprite:IsFinished("Initiate_post") then
            if not data.oneUse then
                data.OverallUses = data.OverallUses or -1
                data.OverallUses = data.OverallUses + 1
                local rand = slot:GetDropRNG():RandomFloat()
                if rand > 0.8^data.OverallUses then
                    data.oneUse = true
                end
            end

            d.state = "activate"
        else
            mod:spritePlay(sprite, "Initiate_post")
        end
    elseif d.state == "activate" then
        if sprite:IsEventTriggered("UnhideItem") then
            -- You know what this is now so you can show the item sprite, too
            sprite:ReplaceSpritesheet(6, Isaac.GetItemConfig():GetCollectible(d.item.Item).GfxFileName, true)
        end

        if sprite:IsEventTriggered("UnhideItemAndEID") then
            -- You know what this is now so you can show the item sprite, too
            sprite:ReplaceSpritesheet(6, Isaac.GetItemConfig():GetCollectible(d.item.Item).GfxFileName, true)

            -- Update the description again, too
            -- This *doesn't* respect curse of the blind, which is the point
            if EID then
                local descriptionObject = EID:getDescriptionObj(5, 100, d.item.Item, slot)
                d.EID_Description = descriptionObject
            end
        end

        if sprite:IsFinished("Payout") then
            d.state = "idle"
        elseif sprite:IsFinished("Payout_alt") then
            slot:TakeDamage(1, DamageFlag.DAMAGE_EXPLOSION, EntityRef(slot), 1)
            d.state = "dead"
            mod:spritePlay(sprite, "Death")
            local exp = Isaac.Spawn(1000, 1, 0, slot.Position, nilvector, slot)
            exp:Update()
        elseif sprite:IsEventTriggered("Pulse") then
            sfx:Play(mod.Sounds.FlashZap,1,0,false,math.random(50,150)/100)
        elseif sprite:IsEventTriggered("Prize") then
            local player
            if d.player and d.player:Exists() then
                player = d.player
            else
                player = Isaac.GetPlayer()
            end
            if d.item.Broken then
                player:AnimateSad()
                Game():GetHUD():ShowFortuneText("out of order!")
            else
                if not d.item.StopSound then
                    sfx:Play(SoundEffect.SOUND_THUMBSUP, 1, 0, false, 1)
                end
                --This specific usecase man
                if d.item.ED12 then
                    mod.ForceED12Number = d.item.ED12
                end
                player:UseActiveItem(d.item.Item)
                mod:electrumUseActive(d.item.Item, player:GetCollectibleRNG(d.item.Item), player, -1)
                mod.ForceED12Number = nil
                if d.item.ForceAnim then
                    local anim = "Pickup"
                    if tostring(d.item.ForceAnim) then
                        anim = d.item.ForceAnim
                    end
                    player:AnimateCollectible(d.item.Item, anim)
                end
            end
        else
            local anim = "Payout"
            if data.oneUse then
                anim = "Payout_alt"
            end
            mod:spritePlay(sprite, anim)
        end
    elseif d.state == "dead" then
        if not sprite:IsPlaying("Death") then
            mod:spritePlay(sprite, "Broken")
        end
        d.EID_Description = nil

        if not d.ranDropFunc then
            -- idk why but oneUse was always true? so i just redid the calculation here
            mod:VendingMachingDeath(slot, (slot.SubType % 2 == 1))
            d.ranDropFunc = true
        end
    end

    if slot.GridCollisionClass == EntityGridCollisionClass.GRIDCOLL_GROUND then
        d.state = "dead"
        sprite:Play("Death", true)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, vendingMachineUpdate, mod.FF.VendingMachine.Var)
mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, vendingMachineUpdate, mod.FF.VendingMachineFF.Var)

function mod:VendingMachingDeath(slot, wasOneUse)
    if slot:GetDropRNG():RandomFloat() < DROP_CHANCE then
        local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, mod.ITEM.COLLECTIBLE.VOYAGER_VENDOR, slot.Position, Vector.Zero, slot):ToPickup()
        item.Wait = 20

        local itemD = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'PedestalData', tostring(item.InitSeed), {})
        itemD.WasOneUse = wasOneUse
        item:GetSprite():SetOverlayFrame("Alternates", itemD.WasOneUse and 1 or 0)

        slot:Remove()
    end

	mod:VendingMachineStitchesPatch()
end

function mod:VendingMachineCancelVanillaDrops()
    return false
end
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, mod.VendingMachineCancelVanillaDrops, mod.FF.VendingMachine.Var)
mod:AddCallback(ModCallbacks.MC_PRE_SLOT_CREATE_EXPLOSION_DROPS, mod.VendingMachineCancelVanillaDrops, mod.FF.VendingMachineFF.Var)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	local d = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'PedestalData', tostring(pickup.InitSeed), {})
    if d.VendingMachineDrop or pickup.SpawnerEntity then
        if d.VendingMachineDrop or (pickup.SpawnerEntity.Type == EntityType.ENTITY_SLOT and (pickup.SpawnerEntity.Variant == mod.FF.VendingMachine.Var or pickup.SpawnerEntity.Variant == mod.FF.VendingMachineFF.Var)) then
            local oneUse = d.WasOneUse
            local itemSprite
            if pickup.SubType > 0 then
                local config = Isaac.GetItemConfig():GetCollectible(pickup.SubType)
                if config then
                    itemSprite = config.GfxFileName
                end
            end
            local sprite = pickup:GetSprite()
            sprite:Load("gfx/items/slots/vending machine/vending_machine_altar.anm2", false)
            sprite:Play("Idle", true)

            if game:GetLevel():GetCurses() & LevelCurse.CURSE_OF_BLIND > 0 then
                itemSprite = "gfx/items/collectibles/questionmark.png"
            end
            sprite:ReplaceSpritesheet(1, itemSprite)
            sprite:SetOverlayFrame("Alternates", oneUse and 1 or 0)

            sprite:LoadGraphics()

            d.VendingMachineDrop = true

            pickup:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            pickup:Update()
        end
    end
end, PickupVariant.PICKUP_COLLECTIBLE)

local function vendingMachineCollide(player, slot)
    local sprite, d = slot:GetSprite(), mod:GetEntityData(slot)
	local data = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'SlotData', tostring(slot.InitSeed), {})

    if d.price and d.state == "idle" then
        if player:GetNumCoins() >= d.price then
            player:AddCoins(d.price * -1)
            d.state = "paid"
            d.paymentAnims = nil
            local actualPlayer = player
            --Oh how I hate you Borgotten, why are you like this
            if actualPlayer:GetPlayerType() == PlayerType.PLAYER_THESOUL_B then
                local twin = actualPlayer:GetMainTwin()
                actualPlayer = twin or actualPlayer
            end
            d.player = actualPlayer
            sfx:Play(SoundEffect.SOUND_COIN_SLOT, 1, 0, false, 1)
        end
    end
end

FiendFolio.onMachineTouch(mod.FF.VendingMachine.Var, vendingMachineCollide)
FiendFolio.onMachineTouch(mod.FF.VendingMachineFF.Var, vendingMachineCollide)

--patch for specifically stitches. Beah Intrusion
function mod:VendingMachineStitchesPatch()
    local vendingMachines = Isaac.FindByType(6, mod.FF.VendingMachine.Var)
    local shouldGiveStitches = false
    for index, slot in ipairs(vendingMachines) do
        local v_d = mod:GetEntityData(slot)
        if v_d.item and v_d.item.Item == CollectibleType.COLLECTIBLE_STITCHES and v_d.state ~= "dead" then
            shouldGiveStitches = true
            break
        end
    end
    local allPlayers = mod:GetAllPlayers()
    for index, value in ipairs(allPlayers) do
        local p_data = mod:GetEntityData(value)
        p_data = p_data.ffsavedata.RunEffects
        if shouldGiveStitches then
            if not p_data.clearStitchesSoon then
                mod:beahAddInnate(value, CollectibleType.COLLECTIBLE_STITCHES, 1)
            end
            p_data.clearStitchesSoon = true
        elseif p_data.clearStitchesSoon then
            p_data.clearStitchesSoon = nil
            mod:beahAddInnate(value, CollectibleType.COLLECTIBLE_STITCHES, -1)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.VendingMachineStitchesPatch)