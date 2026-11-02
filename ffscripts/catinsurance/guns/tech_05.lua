local mod = FiendFolio

local CHECK_INTERVAL = 4
local CHECK_CHANCE = 1 / 6

local function getLaserChance(player)
    local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_TECH_5)
    if player.FrameCount % CHECK_INTERVAL == 0 and rng:RandomFloat() < CHECK_CHANCE then
        return true
    end
end

---@param player EntityPlayer
function mod:FriendTech05Laser(player)
    if player:CanTurnHead()
    and mod:IsAnyFriend(player)
    and player:GetFireDirection() ~= Direction.NO_DIRECTION
    and player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_5) 
    and getLaserChance(player) then
        local aim = mod:SnapVector(player:GetAimDirection(), 90)
        local laser = player:FireTechLaser(player.Position, LaserOffset.LASER_TECH5_OFFSET, aim, false, true, player, 1)
        laser.Color = player.LaserColor
    end
end