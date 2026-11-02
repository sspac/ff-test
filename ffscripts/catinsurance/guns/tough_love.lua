local mod = FiendFolio
local synergy = {}

local MAX_LUCK = 9
local TEETH_DAMAGE_MULT = 1.33
local TEETH_AMOUNT = 4
local TEETH_SPREAD = 25
local TEETH_SPEED_MIN = 12
local TEETH_SPEED_MAX = 15
local TEETH_HEIGHT_ADD_MIN = -36
local TEETH_HEIGHT_ADD_MAX = -28

local function getToughLoveChance(player)
    local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_TOUGH_LOVE)
    local float = rng:RandomFloat()
    if float < 1 / math.max((MAX_LUCK + 1) - math.min(player.Luck, MAX_LUCK), 1) then
        return true
    end
end

---@param player EntityPlayer
function synergy:ShootToothBlast(e, player, aim)
    if mod:ShouldRunSynergy(player, e, CollectibleType.COLLECTIBLE_TOUGH_LOVE) and getToughLoveChance(player) then
        local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_TOUGH_LOVE)
        for _ = 1, TEETH_AMOUNT do
            local direction = aim:Rotated(rng:RandomInt(-TEETH_SPREAD, TEETH_SPREAD)):Resized(rng:RandomInt(TEETH_SPEED_MIN, TEETH_SPEED_MAX))
            local spawnPos = mod:GetFriendGunShootPos(e, aim)
            local tooth = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.TOOTH, 0, spawnPos, direction, player):ToTear()
            tooth.Height = tooth.Height + rng:RandomInt(TEETH_HEIGHT_ADD_MIN, TEETH_HEIGHT_ADD_MAX)
            tooth.FallingAcceleration = 0.33
            tooth.FallingSpeed = 0.33
            tooth.CollisionDamage = tooth.CollisionDamage * TEETH_DAMAGE_MULT
        end
    end
end

mod:AddCallback("POST_GUN_FIRE", synergy.ShootToothBlast)