local mod = FiendFolio
local game = Game()

local vars = {
    [FamiliarVariant.BLUE_FLY] = FamiliarVariant.BLUE_SPIDER,
    [FamiliarVariant.BLUE_SPIDER] = mod.ITEM.FAMILIAR.ATTACK_SKUZZ,
    [mod.ITEM.FAMILIAR.ATTACK_SKUZZ] = mod.ITEM.FAMILIAR.BLUE_BEETLE,
    [mod.ITEM.FAMILIAR.BLUE_BEETLE] = FamiliarVariant.BLUE_FLY
}

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
    if mod.savedata and mod.savedata.DontDoSomethingOnRunStart then
        mod.savedata.DontDoSomethingOnRunStart = false
    end
end)

mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function()
    mod.savedata.DontDoSomethingOnRunStart = true
end)

local goahead = true
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, fam)
    if goahead and vars[fam.Variant] and mod.anyPlayerHas(mod.ITEM.TRINKET.STRANGE_COCOON, true) and not mod.savedata.DontDoSomethingOnRunStart then
        if vars[fam.Variant] == FamiliarVariant.BLUE_SPIDER and fam.SubType > 0 then
        else
            goahead = false
            local new = Isaac.Spawn(3, vars[fam.Variant], fam.SubType, fam.Position, fam.Velocity, fam.SpawnerEntity):ToFamiliar()
            new:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            new.Parent = fam.Parent
            new.Player = fam.Player
            local nd = new:GetData()
            for key,entry in pairs(fam:GetData()) do
                nd[key] = entry
            end
            goahead = true
            fam:Remove()
        end
    end
end)