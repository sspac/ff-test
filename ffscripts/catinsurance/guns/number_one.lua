local mod = FiendFolio
local sfx = SFXManager()
local synergy = {}

local DROP_CONSTANT = 28
local PISS_COLOR = Color(217 / 255, 170 / 255, 0, 1)

local function spawnPissParticles(position, offset)
    for _ = 1, math.random(2, 5) do
        local velocity = math.random(2, 5)
        local droplet = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TEAR_POOF_VERYSMALL, 0, position + offset, RandomVector():Resized(velocity), nil):ToEffect()
        droplet.Color = PISS_COLOR
    end
end

function synergy:PissGunFire(e, player, aim, shots, held, shotThings)
    if not (e.SubType == CollectibleType.COLLECTIBLE_NUMBER_ONE or player:HasCollectible(CollectibleType.COLLECTIBLE_NUMBER_ONE)) then
        return
    end
    
    if not shotThings or #shotThings == 0 then return end
    for _, thing in ipairs(shotThings) do
        if thing.Type == EntityType.ENTITY_TEAR then
            local d = mod:GetEntityData(thing)
            d.FriendNumberOneTear = true
        end
    end
end
mod:AddCallback(mod.CALLBACK.POST_GUN_FIRE, synergy.PissGunFire)

---@param tear EntityTear
function synergy:ExplodePiss(tear)
    if not tear.SpawnerEntity then
        return
    end

    if tear.StickTarget then
        return
    end

    local data = mod:GetEntityData(tear)
    if data.GatlingGunBullet then
        return
    end

    local player = tear.SpawnerEntity:ToPlayer()
    if player and data.FriendNumberOneTear then
        local cutoff = player.TearRange // DROP_CONSTANT
        if tear.FrameCount > cutoff then
            tear:Die()
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, synergy.ExplodePiss, mod.TEAR.FRIEND_BULLET)

function synergy:M90PissSplat(tear, var, data)
	-- hi erfly im making number one do it's thing as friend
    if data.GatlingGunBullet or not data.FriendNumberOneTear then
        return
    end

    sfx:Play(SoundEffect.SOUND_SPLATTER)
	spawnPissParticles(tear.Position, tear.PositionOffset + tear.SpriteOffset)
    local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT, 0, tear.Position + RandomVector():Resized(0, 30), Vector.Zero, tear)
    splat.Color = Color(1, 1, 1, 1, 0.8, 0.75, 0)
    splat.SpriteScale = splat.SpriteScale * 0.7
    splat:Update()
end

mod:AddCallback("FF_CUSTOM_TEAR_SPLAT", synergy.M90PissSplat, mod.TEAR.FRIEND_BULLET)