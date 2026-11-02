local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local SpectralKeychain = {}

local TRINKET = mod.ITEM.TRINKET.SPECTRAL_KEYCHAIN
local KEYGHOST = mod.ITEM.FAMILIAR.GREY_KEYGHOST
local COINGHOST = mod.ITEM.FAMILIAR.COINGHOST

local GHOST_COMBINE_THRESHOLD = 7
local KEY_DOUBLE_CHANCE = 0.25

local function getGhosts(player, justCoins)
    local coinGhosts = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, COINGHOST)
    local merged = {}
    for _, v in ipairs(coinGhosts) do
        if v.SubType ~= 2 then
            if player and GetPtrHash(player) == GetPtrHash(v:ToFamiliar().Player) then
                table.insert(merged, v:ToFamiliar())
            else
                table.insert(merged, v:ToFamiliar())
            end
        end
    end
    if not justCoins then
        local keyGhosts = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, KEYGHOST)
        for _, v in ipairs(keyGhosts) do
            if v.SubType ~= 2 then
                if player and GetPtrHash(player) == GetPtrHash(v:ToFamiliar().Player) then
                    table.insert(merged, v:ToFamiliar())
                else
                    table.insert(merged, v:ToFamiliar())
                end
            end
        end
    end
    return merged
end

local function subtractGhost(ghost, amount)
    local diff = ghost.Keys - amount
    ghost.Keys = math.max(diff, 0)
    if ghost.Keys == 0 then
        mod:GetEntityData(ghost).GreyKeyGhostTargetPosition = ghost.Position
        ghost:GetSprite():Play("Poof", true)
    end
    if diff < 0 then
        return math.abs(diff)
    else
        return 0
    end
end

local function subtractMultipleGhosts(player, amount)
    local coinghosts = getGhosts(player, true)
    for _, ghost in ipairs(coinghosts) do
        local leftover = subtractGhost(ghost, amount)
        if leftover == 0 then
            break
        end
    end
end

local function spendGhost(ghost, d)
    local target = ghost.Target
    if target then
        local pickup = target:ToPickup()
        if pickup then
            if pickup.Variant == PickupVariant.PICKUP_MEGACHEST then
                local s = pickup:GetSprite()
                if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_PAY_TO_PLAY) then
                    s:Play("UseCoin", true)
                else
                    s:Play("UseKey", true)
                end

                -- It'll need to be opened again
                if pickup.SubType > 1 then
                    d.GreyKeyghostTryMegachestAgain = s:GetCurrentAnimationData():GetLength() + 5 -- just make sure it's longer than the animation of the chest opening
                    d.GreyKeyghostLockedIn = true
                end

                -- Allow another ghost to try and open it
                if pickup.SubType > 1 and ghost.Keys == 0 then
                    mod:GetEntityData(pickup).GreyKeyGhostTarget = nil
                end
            else
                local chestData = mod:GetEntityData(pickup)
                if chestData.GreyKeyGhostCustomChest then
                    chestData.GreyKeyGhostCustomChest(pickup)
                    chestData.GreyKeyGhostCustomChest = nil
                else
                    pickup:TryOpenChest()
                end
            end
        end
    elseif d.GreyKeyghostDoorSlot then
        local door = room:GetDoor(d.GreyKeyghostDoorSlot)
        if door then
            door:TryUnlock(ghost.Player, true)
        end
    elseif d.GreyKeyghostLockBlock then
        local block = room:GetGridEntity(d.GreyKeyghostLockBlock)
        if block then
            block:Destroy(false)
            block.State = 1
            block:Update()
            block:GetSprite():Play("Breaking", true)
        end
    end
end

-- Chest variants for it to target.
-- Please only put stuff here that is unlocked by a key.
-- This is technically in priority of how it should be opened.
-- But that shouldn't matter much in a real run.
FiendFolio.GREY_KEYGHOST_CHESTS = {
    PickupVariant.PICKUP_LOCKEDCHEST,
    mod.PICKUP.VARIANT.GLASS_CHEST,
    mod.PICKUP.VARIANT.SHOP_CHEST,
    PickupVariant.PICKUP_OLDCHEST,
    PickupVariant.PICKUP_MEGACHEST,
}

-- Chest variant to function that should be called when trying to open.
FiendFolio.GREY_KEYGHOST_CHESTS_CUSTOM_OPEN = {
    [mod.PICKUP.VARIANT.GLASS_CHEST] = function (chest)
        chest:GetSprite():Play("Open")
        mod:GetEntityData(chest).Opened = true
        chest.SubType = mod.shopChestStates.Opening
        sfx:Play(SoundEffect.SOUND_CHEST_OPEN, 1, 0, false, 1)
        sfx:Play(SoundEffect.SOUND_UNLOCK00, 1, 0, false, 1)
        mod:openGlassChest(chest)
    end,

    [mod.PICKUP.VARIANT.SHOP_CHEST] = function (chest)
        chest:GetSprite():Play("Open")
        mod:GetEntityData(chest).Opened = true
        chest.SubType = mod.shopChestStates.Opening
        sfx:Play(SoundEffect.SOUND_CHEST_OPEN, 1, 0, false, 1)
        sfx:Play(SoundEffect.SOUND_UNLOCK00, 1, 0, false, 1)
    end
}

-- Chest variant to function that should return true if the chest should be able to be opened.
FiendFolio.GREY_KEYGHOST_CHESTS_CUSTOM_CHECK = {
    [mod.PICKUP.VARIANT.GLASS_CHEST] = function (chest)
        return not mod:GetEntityData(chest).Opened
    end,

    [mod.PICKUP.VARIANT.SHOP_CHEST] = function (chest)
        return chest.SubType == mod.shopChestStates.Closed
    end
}

-- Key subtypes and their values.
FiendFolio.GREY_KEYGHOST_KEYS = {
    [KeySubType.KEY_CHARGED] = 1,
    [KeySubType.KEY_DOUBLEPACK] = 2,
    [KeySubType.KEY_NORMAL] = 1,

    [mod.PICKUP.KEY.SPICY] = 2,
    [mod.PICKUP.KEY.SPICY_PERM] = 2,
    
    [mod.PICKUP.KEY.SUPERSPICY] = 3,
    [mod.PICKUP.KEY.SUPERSPICY_PERM] = 3,
    
    [mod.PICKUP.KEY.SPICY_BOX] = 3,
    [mod.PICKUP.KEY.SUPERSPICY_BOX] = 4,
    [mod.PICKUP.KEY.CHARGEDSPICY_BOX] = 2,

    [mod.PICKUP.KEY.CHARGEDSPICY] = 2,
    [mod.PICKUP.KEY.CHARGEDSPICY_PERM] = 2,
}

function SpectralKeychain.CursedPennyChances(player, pickup)
    local cursedPennyRng = RNG()
    cursedPennyRng:SetSeed(pickup.DropSeed, 0)
    local odds = cursedPennyRng:RandomInt(200)

    -- remove a coinghost >:)
    if odds < 60 then
        subtractMultipleGhosts(player, 2)
        mod:triggerPennyPickup(player, pickup, 0.5, -1)
        sfx:Play(mod.Sounds.CursedPennyNegative, 1, 0, false, 1)
        mod:AddSamaelAngerBonus(0.05)
    -- add coinghost O:)
    elseif odds < 120 then
        sfx:Play(SoundEffect.SOUND_PENNYPICKUP, 1, 0, false, 1)
        mod:triggerPennyPickup(player, pickup, 1)
        return 1
    elseif odds < 160 then
        sfx:Play(mod.Sounds.CursedPennyPositive, 1, 0, false, 1)
        mod:triggerPennyPickup(player, pickup, 2)
        return 3
    -- remove FOUR coinghosts...
    elseif odds < 180 then
        subtractMultipleGhosts(player, 4)
        mod:triggerPennyPickup(player, pickup, 0.25, -2)
        sfx:Play(mod.Sounds.CursedPennyNegativeSuper, 1, 0, false, 1)
        --sfx:Play(SoundEffect.SOUND_BROWNIE_LAUGH, 1, 0, false, 1.3)
        game:Fart(pickup.Position, 40, pickup, 1, 0)
        mod:AddSamaelAngerBonus(0.1)
    
    -- luck + coinghost
    elseif odds < 190 then
        player:AnimateHappy()
        sfx:Play(mod.Sounds.CursedPennyPositiveSuper, 1, 0, false, 1)
        mod:triggerPennyPickup(player, pickup, 5, 1)
        player:DonateLuck(1)
        return 1
    
    -- EXPLODE and HURT and REMOVE 2 COIN!!!
    elseif odds < 195 then
        subtractMultipleGhosts(player, 2)
        if player:HasTrinket(TrinketType.TRINKET_CURSED_PENNY) and not player:HasCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
            local bomb = Isaac.Spawn(4, 17, BombSubType.BOMB_GIGA, player.Position, Vector.Zero, player):ToBomb()
            bomb:SetExplosionCountdown(0)
            bomb:Update()
        else
            Isaac.Explode(pickup.Position, nil, 40)
        end
        mod:triggerPennyPickup(player, pickup, 0.1, -1)
        if not FiendFolio.ACHIEVEMENT.EVIL_STICKER:IsUnlocked(true) then
            FiendFolio.ACHIEVEMENT.EVIL_STICKER:Unlock()
        end
        sfx:Play(mod.Sounds.CursedPennyNegativeMega, 1, 0, false, 1)
        mod:AddSamaelAngerBonus(0.25)
    elseif odds < 198 then
        mod:AddCursedPennyStats(player)
        player:AnimateHappy()
        sfx:Play(mod.Sounds.CursedPennyPositiveMega, 1, 0, false, 1)
        mod:triggerPennyPickup(player, pickup, 10, 1)
        return 1
    else
        sfx:Play(mod.Sounds.CursedPennyNeutral, 1, 0, false, 1)
        mod:triggerPennyPickup(player, pickup, 0.75, 0)
    end

    return 0
end

function SpectralKeychain.HauntedPennyChances(player, pickup)
    player:AddWisp(0, player.Position)
    mod:triggerPennyPickup(player, pickup, 1)
    return 1
end

function SpectralKeychain.HoneyPennyChances(player, pickup)
    local data = mod:GetEntityData(player)
    data.HoneyPenny = true
    data.HoneyPennyTimer = 60*8
    mod:triggerPennyPickup(player, pickup, 1)
    return 1
end

function SpectralKeychain.LegoStudChances(player, pickup)
    player:TakeDamage(1, DamageFlag.DAMAGE_FAKE | DamageFlag.DAMAGE_RED_HEARTS, EntityRef(player), 0)
    return 1
end

function SpectralKeychain.MedleyPennyChances(player, pickup)
    local rng = pickup:GetDropRNG()
    
    local collective = 1
    player:DonateLuck(1)
    collective = collective + SpectralKeychain.CursedPennyChances(player, pickup)
    collective = collective + SpectralKeychain.HauntedPennyChances(player, pickup)
    collective = collective + SpectralKeychain.HoneyPennyChances(player, pickup)

    if rng:RandomFloat() < 0.9 then
        local room = game:GetRoom()
        local spawnPosition = room:FindFreePickupSpawnPosition(Isaac.GetRandomPosition(), 0, true)
        local new = Isaac.Spawn(5, PickupVariant.PICKUP_COIN, mod.PICKUP.COIN.MEDLEY_STICKY, spawnPosition, Vector.Zero, pickup.SpawnerEntity)
        new:GetSprite():Play("Reappear")
    end

    mod:triggerPennyPickup(player or familiar.Player, pickup, mod:GetEntityData(pickup).trinketEffectValue or 1)
    game:SetStateFlag(GameStateFlag.STATE_HEART_BOMB_COIN_PICKED, true)

    return collective
end

-- Coin subtypes and their values.
FiendFolio.COINGHOST_COINS = {
    [CoinSubType.COIN_PENNY] = 1,
    [CoinSubType.COIN_LUCKYPENNY] = 1,
    [CoinSubType.COIN_DOUBLEPACK] = 2,
    [CoinSubType.COIN_GOLDEN] = 1,
    [CoinSubType.COIN_NICKEL] = 5,
    [CoinSubType.COIN_DIME] = 10,

    [mod.PICKUP.COIN.CURSED] = SpectralKeychain.CursedPennyChances,
    [mod.PICKUP.COIN.GOLDENCURSED] = SpectralKeychain.CursedPennyChances,
    [mod.PICKUP.COIN.HAUNTED] = SpectralKeychain.HauntedPennyChances,
    [mod.PICKUP.COIN.HONEY] = SpectralKeychain.HoneyPennyChances,
    [mod.PICKUP.COIN.LEGOSTUD] = SpectralKeychain.LegoStudChances,
    [mod.PICKUP.COIN.MEDLEY] = SpectralKeychain.MedleyPennyChances,
}

---@param player EntityPlayer
---@param pickup EntityPickup
function SpectralKeychain:CheckKeyGhost(player, pickup)
    local rng = player:GetTrinketRNG(TRINKET)
    local chance = KEY_DOUBLE_CHANCE * player:GetTrinketMultiplier(TRINKET)

    if pickup.Variant == PickupVariant.PICKUP_KEY
    and not player:HasCollectible(CollectibleType.COLLECTIBLE_PAY_TO_PLAY) then
        local value = FiendFolio.GREY_KEYGHOST_KEYS[pickup.SubType]
        if value then
            if rng:RandomFloat() > chance then
                value = 0
            end
            
            for _ = 1, value + 1 do
                Isaac.Spawn(EntityType.ENTITY_FAMILIAR, KEYGHOST, 0, pickup.Position, Vector.Zero, player)
            end
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pickup.Position, Vector.Zero, nil)
            pickup:Remove()
            pickup:PlayPickupSound()
            sfx:Play(SoundEffect.SOUND_PORTAL_SPAWN)
            return true
        end
    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_PAY_TO_PLAY)
    and pickup.Variant == PickupVariant.PICKUP_COIN then
        local value = FiendFolio.COINGHOST_COINS[pickup.SubType]
        if value then
            if type(value) == "function" then
                value = value(player, pickup)
            end

            if value then
                if value > 0 then
                    if rng:RandomFloat() > chance then
                        value = 1
                    end
                    
                    for _ = 1, value do
                        Isaac.Spawn(EntityType.ENTITY_FAMILIAR, COINGHOST, 0, pickup.Position, Vector.Zero, player)
                    end
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pickup.Position, Vector.Zero, nil)
                end
                sfx:Play(SoundEffect.SOUND_PORTAL_SPAWN)
            end
        end
    end
end

function SpectralKeychain:PrePickup(pickup, collider, low)
    if collider.Type == EntityType.ENTITY_PLAYER then
        local player = collider:ToPlayer()
        if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B then
            player = player:GetMainTwin()
        end

        if not player:HasTrinket(TRINKET) then
            return
        end

        local doCancel = SpectralKeychain:CheckKeyGhost(player, pickup)
        if doCancel then
            game:SetStateFlag(GameStateFlag.STATE_HEART_BOMB_COIN_PICKED, true)
            Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, collider, low)
            return doCancel
        end
    end
end

mod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.IMPORTANT, SpectralKeychain.PrePickup, PickupVariant.PICKUP_KEY)
mod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.IMPORTANT, SpectralKeychain.PrePickup, PickupVariant.PICKUP_COIN)

---@param ghost EntityFamiliar
function SpectralKeychain:GreyKeyghostInit(ghost)
    ghost:AddToFollowers()
    ghost:GetSprite():Play("Appear")
    ghost.Keys = 1
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, SpectralKeychain.GreyKeyghostInit, KEYGHOST)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, SpectralKeychain.GreyKeyghostInit, COINGHOST)

local doorslotTargeted = {}
local gridTargeted = {}

---@param ghost EntityFamiliar
function SpectralKeychain:GreyKeyghostLogic(ghost)
    local sprite = ghost:GetSprite()
    local d = mod:GetEntityData(ghost)
    local room = game:GetRoom()

    ghost.SpriteScale = Vector.One * (1 + (ghost.Keys - 1) * 0.1)
    
    if sprite:IsPlaying("Appear") then
        ghost:FollowParent()
    end

    if sprite:IsFinished("Appear") then
        sprite:Play("Move")
    end

    if sprite:IsPlaying("Move") and not d.GreyKeyghostLockedIn then
        ghost:FollowParent()

        -- If the ghost is able to spend
        if ghost.Keys > 0 then
            -- Look for chests first.
            for _, chestVariant in ipairs(FiendFolio.GREY_KEYGHOST_CHESTS) do
                for _, chest in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, chestVariant)) do
                    -- Check if framecount is greater than 2 so that chests that are removed on init or something aren't counted
                    if chest.FrameCount > 2 then
                        -- Check custom chests
                        if (mod.GREY_KEYGHOST_CHESTS_CUSTOM_CHECK[chestVariant] and mod.GREY_KEYGHOST_CHESTS_CUSTOM_CHECK[chestVariant](chest:ToPickup())) then
                            local chestData = mod:GetEntityData(chest)
                            if not chestData.GreyKeyGhostTarget then
                                -- Found a chest to open!
                                chestData.GreyKeyGhostTarget = true
                                chestData.GreyKeyGhostCustomChest = mod.GREY_KEYGHOST_CHESTS_CUSTOM_OPEN[chestVariant]
    
                                ghost.Target = chest
                                ghost:RemoveFromFollowers()
                                d.GreyKeyGhostTargetPosition = chest.Position
                                d.GreyKeyghostLockedIn = true
                                return
                            end

                        -- Check vanilla chests
                        elseif chest.SubType >= 1 and not mod.GREY_KEYGHOST_CHESTS_CUSTOM_CHECK[chestVariant] then
                            local chestData = mod:GetEntityData(chest)
                            if not chestData.GreyKeyGhostTarget then
                                -- Found a chest to open!
                                chestData.GreyKeyGhostTarget = true
    
                                ghost.Target = chest
                                ghost:RemoveFromFollowers()
                                d.GreyKeyGhostTargetPosition = chest.Position
                                d.GreyKeyghostLockedIn = true
                                return
                            end
                        end
                    end
                end
            end

            -- Now look for doors since no locked chests.
            -- Don't do it during the ascent (there's usually no locked doors there but treasure doors are locked for a frame for some reason)
            if not game:GetLevel():IsAscent() then
                for slot = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
                    if not doorslotTargeted[slot] then
                        local door = room:GetDoor(slot)
                        if door then
                            if door:IsLocked()
                            and (door:GetVariant() == DoorVariant.DOOR_LOCKED 
                            or door:GetVariant() == DoorVariant.DOOR_LOCKED_DOUBLE)
                            and (door.TargetRoomIndex > 0 or (door.TargetRoomIndex == GridRooms.ROOM_SECRET_EXIT_IDX and game:GetLevel():GetStage() < LevelStage.STAGE3_1)) then
                                -- Found a door to target! Only open arcade if a coinghost.
                                if (door.TargetRoomType == RoomType.ROOM_ARCADE and ghost.Variant == COINGHOST)
                                or door.TargetRoomType ~= RoomType.ROOM_ARCADE then
                                    d.GreyKeyghostDoorSlot = slot
                                    doorslotTargeted[slot] = true
                                    ghost:RemoveFromFollowers()
                                    d.GreyKeyGhostTargetPosition = door.Position
                                    d.GreyKeyghostLockedIn = true
                                    return
                                end
                            end
                        end
                    end
                end
            end

            -- Finally, look for key blocks
            for index = 0, room:GetGridSize() - 1 do
                if not gridTargeted[index] then
                    local block = room:GetGridEntity(index)
                    if block
                    and block:GetType() == GridEntityType.GRID_LOCK
                    and block.State ~= 1 then
                        d.GreyKeyghostLockBlock = index
                        gridTargeted[index] = true
                        ghost:RemoveFromFollowers()
                        d.GreyKeyGhostTargetPosition = block.Position
                        d.GreyKeyghostLockedIn = true
                        return
                    end
                end
            end
        end
    end

    -- Megachest key insert cooldown
    if d.GreyKeyghostTryMegachestAgain then
        d.GreyKeyghostTryMegachestAgain = d.GreyKeyghostTryMegachestAgain - 1
        if d.GreyKeyghostTryMegachestAgain <= 0 then
            d.GreyKeyghostTryMegachestAgain = nil
        end
    end

    -- LOCK IN!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    if d.GreyKeyghostLockedIn then
        ghost.Position = mod:Lerp(ghost.Position, d.GreyKeyGhostTargetPosition, 0.1)
        ghost.Velocity = Vector.Zero
        ghost.DepthOffset = 100
        sprite.FlipX = ghost.Position.X > d.GreyKeyGhostTargetPosition.X
        if d.GreyKeyghostCombining and d.GreyKeyghostCombining.Ref then
            d.GreyKeyGhostTargetPosition = d.GreyKeyghostCombining.Ref.Position
        end
        if d.GreyKeyGhostTargetPosition:Distance(ghost.Position) < 10 and not d.GreyKeyghostTryMegachestAgain then
            d.GreyKeyghostLockedIn = false

            -- If locked in to another ghost, combine!
            if d.GreyKeyghostCombining and d.GreyKeyghostCombining.Ref then
                local fam = d.GreyKeyghostCombining.Ref:ToFamiliar()
                fam.Keys = fam.Keys + 1
                sprite:Play("Poof", true)
                return
            end

            -- Else, locked into unlocking, so remove a key.
            ghost.Keys = ghost.Keys - 1

            -- DIE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            if ghost.Keys == 0 then
                sprite:Play("Poof", true)
            else
                spendGhost(ghost, d)
        
                if not d.GreyKeyghostTryMegachestAgain then
                    ghost:AddToFollowers()
                    ghost.DepthOffset = 0
                end
            end
        end
    end

    if sprite:IsFinished("Poof") then
        ghost:FollowPosition(d.GreyKeyGhostTargetPosition)
        spendGhost(ghost, d)

        ghost:Remove()
    end
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, SpectralKeychain.GreyKeyghostLogic, KEYGHOST)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, SpectralKeychain.GreyKeyghostLogic, COINGHOST)

function mod:SpectralKeychainHandleCombining()
    local keyghosts = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, KEYGHOST, 0)
    if #keyghosts >= GHOST_COMBINE_THRESHOLD then
        local familiar = keyghosts[1]:ToFamiliar()
        familiar.SubType = 1
        for i = 2, GHOST_COMBINE_THRESHOLD do
            local otherFamiliar = keyghosts[i]:ToFamiliar()
            local d = mod:GetEntityData(otherFamiliar)
            if not d.GreyKeyghostCombining then
                otherFamiliar:RemoveFromFollowers()
                d.GreyKeyGhostTargetPosition = familiar.Position
                d.GreyKeyghostLockedIn = true
                d.GreyKeyghostCombining = EntityPtr(familiar)
                otherFamiliar.Keys = 0
                otherFamiliar.SubType = 2
            end
        end
    end

    local coinghosts = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, COINGHOST, 0)
    if #coinghosts >= GHOST_COMBINE_THRESHOLD then
        local familiar = coinghosts[1]:ToFamiliar()
        familiar.SubType = 1
        for i = 2, GHOST_COMBINE_THRESHOLD do
            local otherFamiliar = coinghosts[i]:ToFamiliar()
            local d = mod:GetEntityData(otherFamiliar)
            if not d.GreyKeyghostCombining then
                otherFamiliar:RemoveFromFollowers()
                d.GreyKeyGhostTargetPosition = familiar.Position
                d.GreyKeyghostLockedIn = true
                d.GreyKeyghostCombining = EntityPtr(familiar)
                otherFamiliar.Keys = 0
                otherFamiliar.SubType = 2
            end
        end
    end
end

function mod:SpectralKeychainResetDoorslotStuff()
    doorslotTargeted = {}
    gridTargeted = {}
    for _, ghost in ipairs(getGhosts()) do
        ghost:GetSprite():Play("Move", true)
        ghost:ToFamiliar():AddToFollowers()

        local gd = mod:GetEntityData(ghost)
        gd.GreyKeyghostLockedIn = nil
        gd.GreyKeyghostDoorSlot = nil
        gd.GreyKeyghostLockBlock = nil
    end
end