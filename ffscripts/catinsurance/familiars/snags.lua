local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

local ITEM = mod.ITEM.COLLECTIBLE.SNAGS
local FAMILIAR = mod.ITEM.FAMILIAR.SNAGS
local CONFIG = Isaac.GetItemConfig():GetCollectible(ITEM)

local MAX_COINS = 15
local MAX_COINS_BFFS = 30

local MAX_BOMBS = 9
local MAX_BOMBS_BFFS = 18

local MAX_KEYS = 9
local MAX_KEYS_BFFS = 18

local MAX_HEARTS = 3
local MAX_HEARTS_BFFS = 5

local KEY_FORCE = 11
local COIN_FORCE = 15
local BOMB_FORCE = 6
local THROW_STRENGTH = 16

local AMMO_PER_COIN = 5
local AMMO_PER_BOMB = 3
local AMMO_PER_KEY = 3

local KEY_DAMAGE_MULT = 1.25
local KEY_DAMAGE_ADD = 6

local ATTACK_RADIUS = 40 * 5
local MOVE_SPEED = 3

local SnagsState = {
    IDLE = 0,
    ATTACKING = 1,
    COLLECTING = 2,
    THROWING = 3,
}

-- Set SoulHeart to true for soul/black hearts
-- Set Blended to true for special cases where it's a soul and red heart
-- Don't add rotten/bone hearts, should just be red heart variants and soul/black heart variants
-- Set WorthBlackHealth if worth Black hearts.
mod.SnagsHealthType = {
    {Variant = 10, Subtype = 1, Value = 2, SoulHeart = false},
    {Variant = 10, Subtype = 2, Value = 1, SoulHeart = false},
    {Variant = 10, Subtype = 3, Value = 2, SoulHeart = true},
    {Variant = 10, Subtype = 5, Value = 4, SoulHeart = false},
    {Variant = 10, Subtype = 6, Value = 2, SoulHeart = true, WorthBlackHealth = true},
    {Variant = 10, Subtype = 8, Value = 1, SoulHeart = true},
    {Variant = 10, Subtype = 9, Value = 2, SoulHeart = false},
    {Variant = 10, Subtype = 10, Value = 2, Blended = true},
    {Variant = mod.PICKUP.VARIANT.HALF_BLACK_HEART, Subtype = 0, Value = 1, SoulHeart = true},
    {Variant = mod.PICKUP.VARIANT.BLENDED_BLACK_HEART, Subtype = 0, Value = 2, Blended = true, WorthBlackHealth = true},
}

-- Returns the data for the snags of that index.
function mod:GetSnagsData(familiar)
    local player = familiar.Player
    local index = familiar.Coins
    local ffsavedata = mod:GetEntityData(player).ffsavedata
    if not ffsavedata.SnagsFamiliar then
        ffsavedata.SnagsFamiliar = {}
    end
    local data = ffsavedata.SnagsFamiliar
    if not data[index] then
        data[index] = {Hearts = {}, Pickups = {}}
    end
    return data[index]
end

function mod:SnagsHasAmmo(familiar)
    local data = mod:GetSnagsData(familiar)
    return #data.Pickups > 0
end

function mod:SnagsGetAmmoCount(familiar, key)
    local count = 0
    local data = mod:GetSnagsData(familiar)
    for _, pickup in ipairs(data.Pickups) do
        if pickup == key then
            count = count + 1
        end
    end

    return count
end

---@param familiar EntityFamiliar
function mod:SnagsCanHeal(familiar)
    local player = familiar.Player
    local data = mod:GetSnagsData(familiar)

    if player:GetPlayerType() == mod.PLAYER.BRIEND then
        if not mod:IsSelectedBriend(player) then
            player = player:GetOtherTwin()
        end
    end

    if #data.Hearts == 0 then
        return false
    end

    if (not CustomHealthAPI.Helper.PlayerIsSoulHeartOnly(player, true) and player:CanPickRedHearts())
    or (CustomHealthAPI.Helper.PlayerIsSoulHeartOnly(player, true) and player:CanPickSoulHearts()) then
        return true
    end

    return false
end

---@param player EntityPlayer
function mod:SnagsCacheEvaluate(player)
    local count = player:GetCollectibleNum(ITEM) + player:GetEffects():GetCollectibleEffectNum(ITEM)
    player:CheckFamiliar(FAMILIAR, count, player:GetCollectibleRNG(ITEM), CONFIG)
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.SnagsCacheEvaluate, CacheFlag.CACHE_FAMILIARS)

---@param familiar EntityFamiliar
function mod:SnagsFamiliarInit(familiar)
    local index = 1
    for _, fam in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FAMILIAR)) do
        if GetPtrHash(fam:ToFamiliar().Player) == GetPtrHash(familiar.Player) then
            index = index + 1
        end
    end
    familiar.Coins = index
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.SnagsFamiliarInit, FAMILIAR)

---@param familiar EntityFamiliar
function mod:SnagsFamiliarUpdate(familiar)
    local player = familiar.Player
    local sprite = familiar:GetSprite()
    local data = mod:GetSnagsData(familiar)
    local tempData = mod:GetEntityData(familiar)

    local hasBffs = PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_BFFS)
    
    local nearestEnemy = mod:GetNearestEnemy(familiar.Position, nil, function (_, enemy)
        return enemy:IsActiveEnemy()
        and enemy:IsVulnerableEnemy()
        and not mod:isFriend(enemy)
        and not mod:isCharm(enemy)
        and not enemy:HasEntityFlags(EntityFlag.FLAG_NO_TARGET)
    end)

    if familiar.State == SnagsState.IDLE then

        if (nearestEnemy and mod:SnagsHasAmmo(familiar))
        or mod:SnagsCanHeal(familiar) then
            familiar.State = SnagsState.ATTACKING
            if mod:SnagsCanHeal(familiar) then
                tempData.SnagsHealingPlayer = true
            end
            return
        end

        if familiar.Position:Distance(player.Position) > 75 then
            familiar.Velocity = mod:Lerp(familiar.Velocity, (player.Position - familiar.Position):Resized(MOVE_SPEED), 0.33)
        else
            familiar.Velocity = mod:Lerp(familiar.Velocity, Vector.Zero, 0.33)
        end

        local pickups = Isaac.FindByType(5, -1, -1, false, false)
		local dist = 999999

        local targetPickup, targetType, targetValue

        for _, pickup in ipairs(pickups) do
            local candidate
            local candidateValue

            local value = mod.snaggerPickupTable[pickup.Variant .. " | " .. pickup.SubType]
            if pickup:IsDead() or pickup:ToPickup():IsShopItem() then
                goto check_candidate
            end

            if value and not value.Special and not value.Hurts then
                if value.Type == "Coin" and mod:SnagsGetAmmoCount(familiar, "Coin") + value.Count <= (hasBffs and MAX_COINS_BFFS or MAX_COINS) then
                    candidate = pickup
                    candidateValue = value.Count * AMMO_PER_COIN
                    goto check_candidate
                end

                if value.Type == "Key" and mod:SnagsGetAmmoCount(familiar, "Key") + value.Count <= (hasBffs and MAX_KEYS_BFFS or MAX_KEYS) then
                    candidate = pickup
                    candidateValue = value.Count * AMMO_PER_KEY
                    goto check_candidate
                end

            end

            if value and value.Type == "Bomb" then
                if value.Special == "double" and mod:SnagsGetAmmoCount(familiar, "Bomb") + 2 <= (hasBffs and MAX_BOMBS_BFFS or MAX_BOMBS) then
                    candidate = pickup
                    candidateValue = AMMO_PER_BOMB * 2
                    goto check_candidate
                end

                if not value.Special and mod:SnagsGetAmmoCount(familiar, "Bomb") <= (hasBffs and MAX_BOMBS_BFFS or MAX_BOMBS) then
                    candidate = pickup
                    candidateValue = AMMO_PER_BOMB
                    goto check_candidate
                end
            end

            if value and value.Type == "Heart" and #data.Hearts < (hasBffs and MAX_HEARTS_BFFS or MAX_HEARTS) then
                for _, healthData in ipairs(mod.SnagsHealthType) do
                    if healthData.Variant == pickup.Variant and healthData.Subtype == pickup.SubType then
                        if (CustomHealthAPI.Helper.PlayerIsSoulHeartOnly(player, true) and (healthData.SoulHeart or healthData.Blended)) 
                        or (not CustomHealthAPI.Helper.PlayerIsSoulHeartOnly(player, true) and ((not healthData.SoulHeart) or healthData.Blended)) then
                            candidate = pickup
                            candidateValue = {Variant = pickup.Variant, Subtype = pickup.SubType}
                        end
                    end
                end
            end

            ::check_candidate::

            if candidate and ((not targetPickup) or candidate.Position:Distance(targetPickup.Position) < dist) then
                targetPickup = candidate
                targetType = value.Type
                targetValue = candidateValue
                dist = candidate.Position:Distance(targetPickup.Position)
            end
        end

        if targetPickup then
            tempData.SnagsTarget = EntityPtr(targetPickup)
            tempData.SnagsTargetType = targetType
            tempData.SnagsTargetValue = targetValue
            familiar.State = SnagsState.COLLECTING
        end
    
    elseif familiar.State == SnagsState.ATTACKING then
        if not nearestEnemy and not tempData.SnagsHealingPlayer then
            familiar.State = SnagsState.IDLE
            return
        end

        nearestEnemy = nearestEnemy or player

        familiar.Velocity = mod:Lerp(familiar.Velocity, (nearestEnemy.Position - familiar.Position):Resized(MOVE_SPEED), 0.33)

        local nextThrownThing = tempData.SnagsHealingPlayer and "Heart" or data.Pickups[1]
        local room = game:GetRoom()
        local canSee = room:CheckLine(familiar.Position, nearestEnemy.Position, LineCheckMode.ENTITY)
        if (familiar.Position:Distance(nearestEnemy.Position) <= ATTACK_RADIUS and (canSee or (nextThrownThing ~= "Key")))
        or (tempData.SnagsHealingPlayer and familiar.Position:Distance(player.Position) <= ATTACK_RADIUS) then

            if nextThrownThing then
                if nextThrownThing == "Heart" then
                    sprite:Play("throw_empty", true)
                else
                    sprite:Play("throw")

                    if nextThrownThing == "Key" then
                        sprite:ReplaceSpritesheet(1, "gfx/familiar/snags/key.png", true)
                    elseif nextThrownThing == "Bomb" then
                        sprite:ReplaceSpritesheet(1, "gfx/familiar/snags/small_bomb.png", true)
                    else
                        sprite:ReplaceSpritesheet(1, "gfx/familiar/snags/small_penny.png", true)
                    end
                end
            end

            familiar.State = SnagsState.THROWING
        end

    elseif familiar.State == SnagsState.COLLECTING then
        if nearestEnemy and mod:SnagsHasAmmo(familiar) and not sprite:IsPlaying("grab") then
            familiar.State = SnagsState.ATTACKING
            return
        end

        
        if sprite:IsPlaying("grab") then
            familiar.Velocity = mod:Lerp(familiar.Velocity, Vector.Zero, 0.33)

            if sprite:IsEventTriggered("grab") and tempData.SnagsTarget and tempData.SnagsTarget.Ref and not tempData.SnagsTarget.Ref:IsDead() then
                if tempData.SnagsTargetType == "Heart" then
                    data.Hearts[#data.Hearts+1] = tempData.SnagsTargetValue
                elseif tempData.SnagsTargetType == "Key" then
                    for _ = 1, tempData.SnagsTargetValue do
                        data.Pickups[#data.Pickups+1] = "Key" 
                    end
                elseif tempData.SnagsTargetType == "Bomb" then
                    for _ = 1, tempData.SnagsTargetValue do
                        data.Pickups[#data.Pickups+1] = "Bomb" 
                    end 
                elseif tempData.SnagsTargetType == "Coin" then
                    for _ = 1, tempData.SnagsTargetValue do
                        data.Pickups[#data.Pickups+1] = "Coin" 
                    end
                end

                sfx:Play(SoundEffect.SOUND_FETUS_JUMP, 1, 2, false, math.random(80,120)/100)

                tempData.SnagsTarget.Ref:GetSprite():Play("Collect", true)
				tempData.SnagsTarget.Ref.Velocity = Vector.Zero
				tempData.SnagsTarget.Ref.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				tempData.SnagsTarget.Ref:Die()
                
                tempData.SnagsTarget = nil
            end
        else
            if not tempData.SnagsTarget or not tempData.SnagsTarget.Ref or tempData.SnagsTarget.Ref:IsDead() then
                familiar.State = SnagsState.IDLE
                return
            end
            
            if familiar.Position:Distance(tempData.SnagsTarget.Ref.Position) <= 5 then
                sprite:Play("grab", true)
            else 
                familiar.Velocity = mod:Lerp(familiar.Velocity, (tempData.SnagsTarget.Ref.Position - familiar.Position):Resized(MOVE_SPEED), 0.33)

                if tempData.SnagsTarget.Ref.Variant == PickupVariant.PICKUP_HEART 
                and tempData.SnagsTarget.Ref.SubType == HeartSubType.HEART_SCARED
                and tempData.SnagsTarget.Ref.Position:Distance(familiar.Position) < 120 then
                    tempData.SnagsTarget.Ref:AddVelocity((tempData.SnagsTarget.Ref.Position - familiar.Position):Resized(1))
                end
            end
        end

        if sprite:IsFinished("grab") then
            familiar.State = SnagsState.ATTACKING
            return
        end

    elseif familiar.State == SnagsState.THROWING then
        if PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
            sprite.PlaybackSpeed = 2
        end

        if sprite:IsEventTriggered("throw") then
            if not nearestEnemy and not tempData.SnagsHealingPlayer then
                familiar.State = SnagsState.IDLE
                sprite.PlaybackSpeed = 1
                return
            end

            sfx:Play(SoundEffect.SOUND_SHELLGAME)
            
            local pickupToThrow = tempData.SnagsHealingPlayer and "Heart" or table.remove(data.Pickups, 1)
            tempData.SnagsHealingPlayer = nil

            if pickupToThrow == "Heart" and tempData.SnagsHeart and tempData.SnagsHeart.Ref then
                local heart = tempData.SnagsHeart.Ref
                heart.Position = familiar.Position
                heart.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
                heart.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                mod:GetEntityData(heart).launchedEnemyInfo = {
                    vel = (player.Position - familiar.Position):Resized(THROW_STRENGTH), 
                    zVel = -4, 
                    height = -16, 
                    landFunc = function()
                        if not heart:IsDead() then
                            sfx:Play(SoundEffect.SOUND_MEAT_FEET_SLOW0, 1, 0, false, 1)
                            heart.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
                            heart.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
                        end
                    end
                }
                tempData.SnagsHeart = nil
            elseif pickupToThrow == "Bomb" then
                local direction = (nearestEnemy.Position - familiar.Position):Resized(BOMB_FORCE)
				mod.IgnoreTelebombs = true
                local miniBomb = player:FireBomb(familiar.Position, direction, familiar)
				mod.IgnoreTelebombs = false
                miniBomb.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                miniBomb:SetScale(0.5)
                miniBomb:SetFallSpeed(-8)
                miniBomb.RadiusMultiplier = 0.6
				miniBomb:ClearTearFlags(TearFlags.TEAR_SCATTER_BOMB)
				local data = mod:GetEntityData(miniBomb)
				data.FFIsScatter = true
                data.launchedEnemyInfo = {
                    vel = direction, 
                    zVel = -5, 
                    height = -24, 
                    landFunc = function()
                        if not miniBomb:IsDead() then
                            miniBomb.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
                        end
                    end
                }
            elseif pickupToThrow == "Key" then
                local direction = (nearestEnemy.Position - familiar.Position):Normalized()
                local key = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.KEY, 0, familiar.Position, direction:Resized(KEY_FORCE), player):ToTear()
                key:AddTearFlags(TearFlags.TEAR_PIERCING)
                key.CollisionDamage = player.Damage * KEY_DAMAGE_MULT + KEY_DAMAGE_ADD
                if mod.GetPersistentPlayerData(player).warHornActive then
                    key.CollisionDamage = key.CollisionDamage * mod.WarHornDamageMult
                end
            elseif pickupToThrow == "Coin" then
                local direction = (nearestEnemy.Position - familiar.Position):Normalized()
                local penny = Isaac.Spawn(5, PickupVariant.PICKUP_COIN, mod.PICKUP.COIN.LIL_PENNY, familiar.Position, Vector.Zero, familiar)
                penny.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                mod:GetEntityData(penny).launchedEnemyInfo = {
                    vel = direction:Resized(COIN_FORCE), 
                    zVel = -2.1, 
                    height = -15, 
                    landFunc = function()
                        if not penny:IsDead() then
                            penny.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
                            penny.SpriteOffset = Vector.Zero
                        end
                    end
                }

                local pennySprite = penny:GetSprite()
                pennySprite:Play("AppearFast")
                pennySprite:SetLastFrame()
                
                local pennyData = mod:GetEntityData(penny)
                pennyData.dangerousMode = player
                if mod.GetPersistentPlayerData(player).warHornActive then
                    pennyData.dangerousModeDamage = player.Damage * mod.WarHornDamageMult
                else
                    pennyData.dangerousModeDamage = player.Damage
                end
                pennyData.dangerousButDontSpawnExtra = true
            end
        end

        if sprite:IsFinished("throw") or sprite:IsFinished("throw_empty") or sprite:IsPlaying("idle") then
            familiar.State = SnagsState.IDLE
            sprite.PlaybackSpeed = 1
        end

        -- Hold heart above Snags
        if tempData.SnagsHealingPlayer then
            local offset = sprite:GetNullFrame("throw"):GetPos()
            if not tempData.SnagsHeart or not tempData.SnagsHeart.Ref then
                local target = table.remove(data.Hearts, 1)
                if target then
                    local heart = Isaac.Spawn(EntityType.ENTITY_PICKUP, target.Variant, target.Subtype, familiar.Position + offset, Vector.Zero, familiar)
                    heart:GetSprite():SetLastFrame()
                    heart.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                    tempData.SnagsHeart = EntityPtr(heart)
                else
                    tempData.SnagsHealingPlayer = nil
                end
            end

            -- If healing while leaving room, there'll be no SnagsHeart
            -- Just end the state immediately
            if tempData.SnagsHealingPlayer then
                tempData.SnagsHeart.Ref.Position = familiar.Position + offset
            end
        end
        
        familiar.Velocity = mod:Lerp(familiar.Velocity, Vector.Zero, 0.33)
    end

    if sprite:IsFinished() then
        sprite:Play("idle", true)
    end
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.SnagsFamiliarUpdate, FAMILIAR)