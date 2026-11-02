local mod = FiendFolio
local sfx = SFXManager()

local function useItem(_, id, rng, player, flags)
    local pd = mod:GetEntityData(player).ffsavedata.RunEffects

    if pd.deadFamiliars == nil or #pd.deadFamiliars == 0 then
        mod:ThrowBlueBeetle(player, player.Position)
    else
        for key, value in ipairs(pd.deadFamiliars) do
            if value.var == mod.ITEM.FAMILIAR.MORBID_CHUNK then
                mod:GetEntityData(player).ffsavedata.MorbidChunks = math.min(mod:GetEntityData(player).ffsavedata.MorbidChunks + 1, 3)
            end
            local f = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, value.var, value.stype, player.Position, Vector.Zero, nil)
            f.Parent = player

            pd.resurrectionIgnoreMe[""..f.InitSeed] = true

            f:SetColor(Color(1,1,1,1,1,1,1), 30, 15, true, true)
            f.Color = f.Color * Color(0, 1, 0.7, 1, 0, 0.2, 0.1)
        end
    end

    sfx:Play(SoundEffect.SOUND_POWERUP1, 0.7) --i could add ab etter sfx here 
    return true
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, useItem, mod.ITEM.COLLECTIBLE.RESURRECTION)

mod.ResurrectionFamiliarWhitelist = {  --todo: add funny interaction for hollow minions
    FamiliarVariant.BLUE_FLY,
    FamiliarVariant.BLUE_SPIDER,
    FamiliarVariant.BONE_ORBITAL,
    FamiliarVariant.WISP,
    FamiliarVariant.ITEM_WISP,
    --fiendfolio
    mod.ITEM.FAMILIAR.BLUE_BEETLE,
    mod.ITEM.FAMILIAR.ATTACK_SKUZZ,
    mod.ITEM.FAMILIAR.FRAGILE_BOBBY,
    mod.ITEM.FAMILIAR.MORBID_CHUNK,
	mod.ITEM.FAMILIAR.FAIRY_FLY_1,
	mod.ITEM.FAMILIAR.FAIRY_FLY_2,
	mod.ITEM.FAMILIAR.FAIRY_FLY_3 ,
    --mod.ITEM.FAMILIAR.FIEND_ORBITING_FIREBALL, for some reason, fireball's init seeds act super strange
    --mod.ITEM.FAMILIAR.MINI_LEVEL_0_FLY,
}
--entity remove isnt called on familars upon entering a new room, fun fact
local function onFamiliarDie(_, familiar)
    familiar = familiar:ToFamiliar()
    local v = familiar.Variant
    local p = familiar.Player
    if p and familiar.Visible then
        local pd = mod:GetEntityData(p).ffsavedata.RunEffects
        pd.resurrectionIgnoreMe = pd.resurrectionIgnoreMe or {}
        if pd.resurrectionIgnoreMe[""..familiar.InitSeed] then
            return
        end
        pd.resurrectionIgnoreMe[""..familiar.InitSeed] = true

        if mod:Contains(mod.ResurrectionFamiliarWhitelist, v) then
            pd.deadFamiliars = pd.deadFamiliars or {}
            table.insert(pd.deadFamiliars, {var = v, stype = familiar.SubType})
        end
    end
end

mod:AddCollectibleCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, mod.ITEM.COLLECTIBLE.RESURRECTION, onFamiliarDie, EntityType.ENTITY_FAMILIAR)