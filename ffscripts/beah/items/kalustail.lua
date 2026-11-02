local mod = FiendFolio
local game = Game()

local centerOfRoom = nil

local function findCenterOfRoom()
    local room = game:GetRoom()
    local rwidth, rheight = room:GetGridWidth(), room:GetGridHeight()*20
    local v = Vector(rwidth*20+ (rwidth%2==0 and 0 or 20), rheight+100)
    centerOfRoom = v
end

local speed = 1.2
local oset = Vector(90, 90)
local function familiarUpdate (_, familiar)
    if centerOfRoom == nil then
        findCenterOfRoom()
    end

    local p = familiar.Player
    local sp = speed * mod:GetOrbitalSpeedMult(p)
    local v = mod:BeahDynamicOrbit(familiar, p, sp, oset, nil, centerOfRoom)
    mod:SetFamiliarOrbitPosWOVisualBugs(familiar, v, v - familiar.Position)

    local fcount = familiar.FrameCount
    local damage = fcount % 16 == 0
    if fcount % 2 == 0 then
        local enemies = Isaac.FindInRadius(familiar.Position, 90, 8)
        for index, value in ipairs(enemies) do
            value = value:ToNPC()
            if value and not value:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) and value:IsVulnerableEnemy() then
                value:TryForceTarget(familiar, 10)
                if damage then
                    value:TakeDamage(1, 0, EntityRef(familiar), 0)
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, familiarUpdate, mod.ITEM.FAMILIAR.KALUS_TAIL)

local function FamiliarInit(_, familiar)
    familiar:AddToOrbit(1092)
    familiar.OrbitSpeed = 0
    familiar.OrbitLayer = 1092
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, FamiliarInit, mod.ITEM.FAMILIAR.KALUS_TAIL)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function ()
    centerOfRoom = nil
end)