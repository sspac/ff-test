local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local time = 90
local oset = Vector(0, 2)
local retryAttempts = 30
local function glitchCityTick(_, player)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.GLITCHCITY) then
        local stacks = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.GLITCHCITY)
        local p_data = mod:GetEntityData(player)
        p_data.sw_glitchCityTimer = (p_data.sw_glitchCityTimer or 170) - (stacks+0.2)
        --print(p_data.sw_glitchCityTimer, stacks, (stacks*10))

        local room = game:GetRoom()
        if room:GetFrameCount() <= 0 then
            p_data.sw_glitchCityTimer = math.min(p_data.sw_glitchCityTimer, 20)
        end

        local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.GLITCHCITY)
        if p_data.sw_glitchCityTimer < 0 then
            while p_data.sw_glitchCityTimer < 0 do
                local target = mod:FindNearestVulnerableEnemy(player.Position)
                local randomPos
                for i = 1, retryAttempts, 1 do
                    randomPos = player.Position + RandomVector()*rng:RandomFloat()*200
                    if target and target.Position:Distance(player.Position) > 240 then
                        target = nil
                    elseif target then
                        randomPos = mod:Lerp(randomPos,
                        target.Position + (math.max((rng:RandomFloat()*target.Size)-28, 00)*(RandomVector()+Vector(0, -1))), rng:RandomFloat())
                    end

                    local grid = room:GetClampedGridIndex(randomPos)
                    grid = room:GetGridEntity(grid)
                    if not grid or (grid:GetType() ~= GridEntityType.GRID_WALL and grid:GetType() ~= GridEntityType.GRID_DOOR) then
                        if room:IsPositionInRoom(randomPos, 20) then
                            goto continue
                        end
                    end
                end
                ::continue::

                randomPos = room:GetClampedGridIndex(randomPos)
                randomPos = room:GetGridPosition(randomPos)
                randomPos = randomPos - oset

                local glitchedTile = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.FF.GlitchcityTile.Var, mod.FF.GlitchcityTile.Sub, randomPos, Vector.Zero, player):ToEffect()
                glitchedTile.Timeout = 170
                p_data.sw_glitchCityTimer = p_data.sw_glitchCityTimer + 170
            end
        end

        if game.TimeCounter % (30*time) == 0 then
                --"based off of the code for that one DDLC item in fiendfolio" (2023 beah)
                --now how, the turntables
                --(i dont know why i had to look at isaac.chr for this, i guess i didnt know how look at the player inventory back then)
                --((and it wasnt the blacklist stuff either i made my own blacklist back then))
                local iconfig = Isaac.GetItemConfig()

                local allItemsHeld = player:GetCollectiblesList()
                local items = {}
                for i,v in pairs(allItemsHeld) do
                    local item = iconfig:GetCollectible(i)
                    if item ~= nil and not item.Hidden and not item:HasTags(ItemConfig.TAG_QUEST) and item.Type ~= ItemType.ITEM_ACTIVE
                    and not FiendFolio.GLITCH_NO_REPLACE[i] and v > 0 then
                        for _ = 1, v, 1 do
                            table.insert(items, i)
                        end
                    end
                end

                mod:Shuffle(items)

                local unlockySod = items[1]
                if unlockySod == nil then
                    return
                end
                player:RemoveCollectible(unlockySod)
                player:AnimateCollectible(unlockySod , "LiftItem", "PlayerPickupSparkle")

                mod.scheduleForUpdate(function ()
                    local conf = iconfig:GetCollectible(mod.ITEM.COLLECTIBLE.GLITCHCITY)
                    player:AnimateCollectible(mod.ITEM.COLLECTIBLE.GLITCHCITY, "Pickup", "PlayerPickupSparkle")
                    player:QueueItem(conf, conf.InitCharge)
                    game:GetHUD():ShowItemText(player, conf)
                    sfx:Play(SoundEffect.SOUND_CHOIR_UNLOCK)

                    player:MakeGroundPoof ()
                end, 21)
            end
        end
    end

mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.GLITCHCITY, glitchCityTick)

local damage = 60
local duration = 144
local function EffectUpdate(_, effect)
    if effect.SubType ~= mod.FF.GlitchcityTile.Sub then
        return
    end
    local room = game:GetRoom()
    local pos = room:GetClampedGridIndex(effect.Position)
    pos = room:GetGridPosition(pos)
    local sprite = effect:GetSprite()
    local dissapearedCompletely = sprite:IsPlaying("Dissapear")
    local e_data = mod:GetEntityData(effect)
    e_data.ff_dontHitAgain = e_data.ff_dontHitAgain or {}
    if sprite:IsPlaying("Idle") or dissapearedCompletely then

        local nearbyEnemies = Isaac.FindInRadius(pos, 17, EntityPartition.ENEMY)
        local notDoneThing = true
        for index, ent in ipairs(nearbyEnemies) do
            if e_data.ff_dontHitAgain[ent.Index] then
                goto continue
            end
            if notDoneThing and not dissapearedCompletely then
                sprite:Play("Dissapear")
                sfx:Play(SoundEffect.SOUND_REDLIGHTNING_ZAP_BURST, 0.5)
            end
            ent:TakeDamage(damage, DamageFlag.DAMAGE_IGNORE_ARMOR, EntityRef(effect), 0)
            e_data.ff_dontHitAgain[ent.Index] = true
            --mod:DoKnifeDamage(effect, ent, Isaac.GetPlayer(1), damage)

            local veloc = (ent.Position - pos):Normalized()
            local pf = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.FF.GlitchPoof.Var, mod.FF.GlitchPoof.Sub, pos+(veloc*40), Vector.Zero, nil)
            --pf.Color = Color(1, 0.7, 0)
            pf.DepthOffset = 18
            if not ent:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) then
                veloc = veloc*15

                ent:AddEntityFlags(EntityFlag.FLAG_KNOCKED_BACK)
                ent:AddVelocity(veloc)
            end
            ::continue::
        end
    end

    if sprite:IsFinished("Appear") then
        sprite:Play("Idle", true)
    end
    if effect.FrameCount == duration then
        sprite:Play("Dissapear")
        sfx:Play(SoundEffect.SOUND_BUTTON_PRESS, 1)
    end
    if sprite:WasEventTriggered("Break") then
        --spawn rock particles
        game:SpawnParticles(effect.Position, EffectVariant.ROCK_PARTICLE, 2, 3, Color(0, 0.68, 0.68, 1, 0.3921, 0.2549))

        effect:Remove()
    end
end

local rockSuffix = "gfx/grid/rocks_"
local rockPaths = {
    "basement",
    "bluewomb",
    "burningbasement",
    "catacombs",
    "cathedral",
    "caves",
    "cellar",
    "chest",
    "d12",
    "dankdepths",
    "darkroom",
    "depths_custom",
    "dice",
    "downpour",
    "dross",
    "drownedcaves",
    "gehenna",
    "library",
    "mausoleum",
    "necropolis",
    "pipes",
    "primitive",
    "secret",
    "sheol",
    "shop",
}
local function EffectInit(_, effect)
    if effect.SubType ~= mod.FF.GlitchcityTile.Sub then
        return
    end
    sfx:Play(SoundEffect.SOUND_LASERRING_WEAK, 0.5)
    local sprite = effect:GetSprite()
    mod:Shuffle(rockPaths)
    for i = 0, 3, 1 do
        local path = rockSuffix..rockPaths[i+1]..".png"
        sprite:ReplaceSpritesheet(i, path)
    end
    sprite:LoadGraphics()

    local room = game:GetRoom()
    local grid = room:GetGridEntityFromPos(effect.Position)
    if grid then
        grid:Destroy()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, EffectInit, mod.FF.GlitchcityTile.Var)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, EffectUpdate, mod.FF.GlitchcityTile.Var)