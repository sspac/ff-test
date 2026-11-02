--[[

Have you ever wanted to fly, but were put off by the price of two-heart devil deals and insultingly rare angel room items?
Have you ever been discontent with the current state of flight items, longing for something more stylishly balanced?
Have you ever wanted to snag pickups that are just out of reach, but hated the idea of cheating rooms with combat?

Well, do we have the product for you!
Introducing the all-new award-winning flight-activated* utility boots, Gizmo Boots™!
These striking new additions to your wardrobe will take you places you've never seen before, and more!
Just put them on, and the Gizmo Boots™ will imitate flight using bleeding-edge pyrotechnic technology!
It's so easy, even a baby† could do it!

Fly safe‡!

* ᴏɴʟʏ ғᴜɴᴄᴛɪᴏɴᴀʟ ɪɴ ᴄʟᴇᴀʀᴇᴅ ʀᴏᴏᴍs.
† ɢɪᴢᴍᴏ ʙᴏᴏᴛs™ ᴀʀᴇ ɪɴᴛᴇɴᴅᴇᴅ ғᴏʀ ᴀɢᴇs 12 ᴀɴᴅ ᴜᴘ.
‡ ɪ-ᴄᴀɴ-ᴄ4-ᴇᴠᴇʀ ᴛᴏʏ ɢʀᴏᴜᴘ ɪs ɴᴏᴛ ʀᴇsᴘᴏɴsɪʙʟᴇ ғᴏʀ ᴀɴʏ ᴅᴀᴍᴀɢᴇs ᴏʀ ʟᴏss ᴏғ ʟɪᴍʙs ᴀs ᴀ ʀᴇsᴜʟᴛ ᴏғ ɪᴍᴘʀᴏᴘᴇʀ ᴜsᴇ ᴏғ ᴛʜᴇ ɢɪᴢᴍᴏ ʙᴏᴏᴛs™ ғʟɪɢʜᴛ-ᴀᴄᴛɪᴠᴀᴛᴇᴅ ᴜᴛɪʟɪᴛʏ ʙᴏᴏᴛs.

]]

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local ITEM_ID = mod.ITEM.COLLECTIBLE.GIZMO_BOOTS
local PARTICLE_ID = mod.FF.FlameParticle

-- Grants flight for gizmo boots
function mod:GizmoBootsForceEvaluateCache()
    -- Only check every 6 frames for optimization :)
    if game:GetFrameCount() % 6 == 0 and not mod.IsActiveRoom() then
        for _, player in ipairs(PlayerManager.GetPlayers()) do
            local data = mod:GetEntityData(player)
            -- Grant flight if they have the item and didn't have flight before
            -- Never remove flight to avoid softlocks
            if player:HasCollectible(ITEM_ID) and not data.GizmoBootsFlight then
                data.GizmoBootsFlight = true
                player:AddCacheFlags(CacheFlag.CACHE_FLYING, true)
                sfx:Play(mod.Sounds.GizmoBootsFlight)
            end
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_UPDATE, ITEM_ID, mod.GizmoBootsForceEvaluateCache)

function mod:GizmoBootsRemoved(player)
    if not player:HasCollectible(ITEM_ID) then
        local data = mod:GetEntityData(player)
        if data.GizmoBootsFlight then
            data.GizmoBootsFlight = nil
            player:AddCacheFlags(CacheFlag.CACHE_FLYING, true)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.GizmoBootsRemoved, ITEM_ID)

-- Reset the Gizmo Boots flight status of all players if the room is active
function mod:GizmoBootsReset()
    if mod.IsActiveRoom() then
        for _, player in ipairs(PlayerManager.GetPlayers()) do
            local data = mod:GetEntityData(player)
            if data.GizmoBootsFlight then 
                data.GizmoBootsFlight = nil
                player:AddCacheFlags(CacheFlag.CACHE_FLYING, true)
            end
        end
    end
end

-- Spawns the cool particles if you have gizmo boots flight
function mod:SpawnGizmoBootsParticles(player)
    if player:HasCollectible(ITEM_ID) and mod:GetEntityData(player).GizmoBootsFlight then
        local distance = player.SpriteScale:Length() * 3
        if game:GetFrameCount() % 2 == 0 then
            distance = -distance
        end

        local speed = math.random(1, 6)
        local angle = math.random(-45, 45)
        local particle = Isaac.Spawn(EntityType.ENTITY_EFFECT, PARTICLE_ID.Var, PARTICLE_ID.Sub, player.Position + Vector(distance, 0), Vector(0, speed):Rotated(angle), nil)
        particle.SpriteScale = Vector.One * (math.random(70, 100) / 100)
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ITEM_ID, mod.SpawnGizmoBootsParticles)

-- Handles cool particle movement
---@param particle EntityEffect
function mod:GizmoBootsFlameParticles(particle)
    particle.Velocity = particle.Velocity * 0.9
    particle.SpriteScale = particle.SpriteScale * 0.9

    local scale = particle.SpriteScale:Length()
    particle.SpriteRotation = particle.SpriteRotation + (scale * 45)

    if scale < 0.05 then
        particle:Remove()
    end
end