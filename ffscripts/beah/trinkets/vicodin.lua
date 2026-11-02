local mod = FiendFolio

local function takePill(_, effect, player, flags)
  if flags & UseFlag.USE_NOANIM > 0 then
    return
  end
  if player:HasTrinket(mod.ITEM.TRINKET.VICODIN) and effect ~= PillEffect.PILLEFFECT_PERCS then
    player:UsePill(PillEffect.PILLEFFECT_PERCS, 0, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOHUD)
  end
end
mod:AddTrinketCallback(ModCallbacks.MC_USE_PILL, mod.ITEM.TRINKET.VICODIN, takePill)