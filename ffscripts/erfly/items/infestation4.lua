local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local function getInfestation4Count(player)
    local effects = player:GetEffects()
    local stacks = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.INFESTATION_4)
    if effects:HasNullEffect(mod.ITEM.NULL.GOBY) then
        stacks = stacks + 3
    end
    return stacks
end

local function shouldSpawnBeetle(player, damage)
    local count = getInfestation4Count(player)
    if count > 0 then
        local save = mod:GetEntityData(player).ffsavedata
        save.Infestation4Counter = save.Infestation4Counter or 0
        save.Infestation4Counter = save.Infestation4Counter + damage
        if mod.GetEntityCount(3, mod.ITEM.FAMILIAR.BLUE_BEETLE) < 15 and save.Infestation4Counter >= 50/count then
            save.Infestation4Counter = 0
            sfx:Play(SoundEffect.SOUND_BOIL_HATCH, 0.75, 0, false, mod:RandomInt(150,200)/100)
            return true
        end
    end
end

function mod:infestation4PostFire(player, ent, rng, pdata, entdata)
    if getInfestation4Count(player) > 0 then
        entdata.Infestation4Shot = true
    end
end
function mod:infestation4PostFireCreep(player, ent, entdata)
    if getInfestation4Count(player) > 0 then
        entdata.Infestation4Shot = true
    end
end

function mod:infestation4DirectDamage(player, entity)
    if shouldSpawnBeetle(player, player.Damage) then
        mod:ThrowBlueBeetle(player, entity.Position)
    end
end

function mod:infestation4GeneralDamage(source, entity, data, amount)
    if data.Infestation4Shot then
        local player
        if source.SpawnerEntity and source.SpawnerEntity.Type == 1 then
            player = source.SpawnerEntity:ToPlayer()
        else
            player = Isaac.GetPlayer()
        end
        if shouldSpawnBeetle(player, math.min(amount, entity.HitPoints)) then
            mod:ThrowBlueBeetle(player, entity.Position)
        end
    end
end