-- Okay so MAYBE it's not a gun and therefore it doesn't make sense to put in this folder... so what?!
-- Why didn't YOU add support for Dead Tooth, huh?!
-- You probably didn't realize it wasn't working in the first place.
-- Yeah... that's what I thought.
-- Looks like I'm done here. 
-- [dramatically and hastily turns the other direction, causing my big $$$$-ing tail to knock over a table previously displaying an expensive selection of delicate china]
-- fuck. im so sorry. i didn't mean to... fuck, dude.

local mod = FiendFolio
local DEAD_TOOTH = CollectibleType.COLLECTIBLE_DEAD_TOOTH
local FART_RING_SCALE = Vector.One * 0.8

---@param player EntityPlayer
local function SpawnFartRing(player)
    local ring = Isaac.Spawn(
        EntityType.ENTITY_EFFECT,
        EffectVariant.FART_RING,
        0,
        player.Position,
        player.Velocity,
        player
    ):ToEffect()

    ring.Parent = player
    ring.SpriteScale = FART_RING_SCALE
    ring.PositionOffset = Vector(0, -20)

    local sprite = ring:GetSprite()
    sprite:Play("Appear", true)

    local data = mod:GetEntityData(player)
    data.FriendFartRing = EntityPtr(ring)
end


---@param player EntityPlayer
---@param fartRing EntityEffect
---@param isHolding boolean
local function UpdateFartRing(player, fartRing, isHolding)
    fartRing.Position = mod:Lerp(fartRing.Position, player.Position, 0.2)

    local sprite = fartRing:GetSprite()

    if sprite:IsFinished("Appear") then
        sprite:Play("Loop", true)
    end

    if not isHolding and sprite:IsPlaying("Loop") then
        sprite:Play("Dissappear", true)
    end
end


---@param player EntityPlayer
function mod:FriendFartRingUpdate(player)
    local data = mod:GetEntityData(player)
    local currentShootDir = player:GetAimDirection()
    local isHolding = currentShootDir:Length() > 1e-3

    local ring = mod:GetPointee(data.FriendFartRing)
    if ring then
        UpdateFartRing(player, ring, isHolding)
    elseif isHolding and player:HasCollectible(DEAD_TOOTH) then
        SpawnFartRing(player)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.FriendFartRingUpdate, mod.PLAYER.FRIEND)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.FriendFartRingUpdate, mod.PLAYER.BRIEND)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.FriendFartRingUpdate, mod.PLAYER.BINABA)