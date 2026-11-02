local mod = FiendFolio
local synergy = {}

local CLOT_DAMAGE = 1
local STYE_MULT = 1.28
local CHEMICAL_PEEL_DAMAGE = 2
local PEEPER_MULT = 1.35

local function cloneColor(color)
    return Color(color.R, color.G, color.B, color.A, table.unpack(color:GetOffset() or {0, 0, 0}), table.unpack(color:GetColorize() or {0, 0, 0}))
end

---@param player EntityPlayer
function synergy:BloodClot(e, player, aim, ammoUsed, held, entities)
    if not player:HasCollectible(CollectibleType.COLLECTIBLE_BLOOD_CLOT) then return end

    local data = mod:GetEntityData(player)
    if not data.FriendIsRightEye then
        for _, singleShot in ipairs(entities) do
            if singleShot.Type == EntityType.ENTITY_TEAR then
                singleShot.CollisionDamage = singleShot.CollisionDamage + CLOT_DAMAGE
                local c = cloneColor(singleShot.Color)
                c:SetColorize(1, 0, 0, 1)
                singleShot.Color = c
            elseif singleShot.Type == EntityType.ENTITY_LASER then
                singleShot.CollisionDamage = singleShot.CollisionDamage + CLOT_DAMAGE
            elseif singleShot.Type == EntityType.ENTITY_BOMB then
                singleShot.ExplosionDamage = singleShot.ExplosionDamage + CLOT_DAMAGE
                local c = cloneColor(singleShot.Color)
                c:SetColorize(1, 0, 0, 1)
                singleShot.Color = c
            end
        end
    end
end

mod:AddCallback("POST_GUN_FIRE", synergy.BloodClot)

---@param player EntityPlayer
function synergy:Stye(e, player, aim, ammoUsed, held, entities)
    if not player:HasCollectible(CollectibleType.COLLECTIBLE_STYE) then return end

    local data = mod:GetEntityData(player)
    if data.FriendIsRightEye then
        for _, singleShot in ipairs(entities) do
            if singleShot.Type == EntityType.ENTITY_TEAR then
                singleShot.CollisionDamage = singleShot.CollisionDamage * STYE_MULT
            elseif singleShot.Type == EntityType.ENTITY_LASER then
                singleShot.CollisionDamage = singleShot.CollisionDamage * STYE_MULT
            elseif singleShot.Type == EntityType.ENTITY_BOMB then
                singleShot.ExplosionDamage = singleShot.ExplosionDamage * STYE_MULT
            end
        end
    end
end

mod:AddCallback("POST_GUN_FIRE", synergy.Stye)

---@param player EntityPlayer
function synergy:ChemicalPeel(e, player, aim, ammoUsed, held, entities)
    if not player:HasCollectible(CollectibleType.COLLECTIBLE_CHEMICAL_PEEL) then return end

    local data = mod:GetEntityData(player)
    if not data.FriendIsRightEye then
        for _, singleShot in ipairs(entities) do
            if singleShot.Type == EntityType.ENTITY_TEAR then
                singleShot.CollisionDamage = singleShot.CollisionDamage + CHEMICAL_PEEL_DAMAGE
            elseif singleShot.Type == EntityType.ENTITY_LASER then
                singleShot.CollisionDamage = singleShot.CollisionDamage + CHEMICAL_PEEL_DAMAGE
            elseif singleShot.Type == EntityType.ENTITY_BOMB then
                singleShot.ExplosionDamage = singleShot.ExplosionDamage + CHEMICAL_PEEL_DAMAGE
            end
        end
    end
end

mod:AddCallback("POST_GUN_FIRE", synergy.ChemicalPeel)

---@param player EntityPlayer
function synergy:Peeper(e, player, aim, ammoUsed, held, entities)
    if not player:HasCollectible(CollectibleType.COLLECTIBLE_PEEPER) then return end

    local data = mod:GetEntityData(player)
    if not data.FriendIsRightEye then
        for _, singleShot in ipairs(entities) do
            if singleShot.Type == EntityType.ENTITY_TEAR then
                singleShot.CollisionDamage = singleShot.CollisionDamage * PEEPER_MULT
            elseif singleShot.Type == EntityType.ENTITY_LASER then
                singleShot.CollisionDamage = singleShot.CollisionDamage * PEEPER_MULT
            elseif singleShot.Type == EntityType.ENTITY_BOMB then
                singleShot.ExplosionDamage = singleShot.ExplosionDamage * PEEPER_MULT
            end
        end
    end
end

mod:AddCallback("POST_GUN_FIRE", synergy.Peeper)