local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

mod.FlamingMinecartExists = false
mod.FlamingMinecartSpawns = {}

local Constants = {
    Directions = {
        [0] = StbRailVariant.HORIZONTAL_CART_LEFT,
        [1] = StbRailVariant.HORIZONTAL_CART_RIGHT,
        [2] = StbRailVariant.VERTICAL_CART_UP,
        [3] = StbRailVariant.VERTICAL_CART_DOWN,
        [4] = StbRailVariant.HORIZONTAL_CART_LEFT,
        [5] = StbRailVariant.HORIZONTAL_CART_RIGHT,
        [6] = StbRailVariant.VERTICAL_CART_UP,
        [7] = StbRailVariant.VERTICAL_CART_DOWN,
    },
    PitDirectionStart = 4,

    Rail = 6000,
    RailPit = 6001,

    BaseSpeed = 6.5,
    SpeedMult = 1.5,

    BaseHealth = EntityConfig.GetEntity(EntityType.ENTITY_MINECART, mod.FF.FlamingMinecart.Var, 0):GetBaseHP()
}

function mod:FlamingMinecartReset()
    mod.FlamingMinecartExists = false
    mod.FlamingMinecartSpawns = {}
end
mod:AddCallback(ModCallbacks.MC_PRE_ROOM_EXIT, mod.FlamingMinecartReset)

function mod:SetFlamingMinecartRails(entType, entVariant, entSubtype, gridIndex)
    if entType == EntityType.ENTITY_MINECART and entVariant == mod.FF.FlamingMinecart.Var then
        local gridType = StbGridType.RAIL
        if entSubtype >= Constants.PitDirectionStart then
            gridType = StbGridType.RAIL_PIT
        end

        mod.FlamingMinecartExists = true
        mod.FlamingMinecartSpawns[gridIndex] = true

        return {gridType, Constants.Directions[entSubtype], 0}
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, CallbackPriority.IMPORTANT, mod.SetFlamingMinecartRails)

---@param npc EntityNPC
function mod:FlamingMinecartInit(npc)
    if npc.Variant == mod.FF.FlamingMinecart.Var then
        npc.Color = Color(1, 1, 1, 0, 0.5, 0, 0)
        npc:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.FlamingMinecartInit, EntityType.ENTITY_MINECART)

function mod:FlamingMinecartReplace(entType, entVar, entSub, pos, vel, spawner, seed)
    if not mod.FlamingMinecartExists then
        return
    end

    if entType == EntityType.ENTITY_MINECART and entVar == 0 then
        local room = game:GetRoom()
        local index = room:GetGridIndex(pos)
        if mod.FlamingMinecartSpawns[index] then
            return {entType, mod.FF.FlamingMinecart.Var, 0, seed}
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, mod.FlamingMinecartReplace)

function mod:FlamingMinecartUpdate(npc)
    if npc.Variant ~= mod.FF.FlamingMinecart.Var then
        return
    end
    
    -- Has to be done on update for whatever reason
    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
    npc:SetInvincible(false)
    npc.Velocity = npc.Velocity:Resized(Constants.BaseSpeed * Constants.SpeedMult)

    if npc.HitPoints <= 0 and npc.Child then
        local room = game:GetRoom()
        local grid = room:GetGridEntityFromPos(npc.Position)
        if grid and grid:ToPit() then
            npc.Child:Kill()
        end

        npc.Child = nil

        npc:Update()
    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.FlamingMinecartUpdate, EntityType.ENTITY_MINECART)

function mod:FlamingMinecartPreventDamage(entity)
    local npc = entity:ToNPC()
    if npc then
        local minecart = npc:GetMinecart()
        if minecart and minecart.Variant == mod.FF.FlamingMinecart.Var then
            return false
        end
    end
end
mod:AddEntityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, EntityType.ENTITY_MINECART, mod.FF.FlamingMinecart.Var, 0, mod.FlamingMinecartPreventDamage)