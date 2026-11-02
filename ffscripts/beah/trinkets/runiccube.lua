local mod = FiendFolio
local game = Game()

local function postTakeDMG(_, ent, amount, flags, source, dmgCooldown)
  if not ent then
    return
  end
  local p = ent:ToPlayer()
  if p then
    if p:HasTrinket(mod.ITEM.TRINKET.RUNIC_CUBE) then
      local t_rng = p:GetTrinketRNG(mod.ITEM.TRINKET.RUNIC_CUBE)
      if t_rng:RandomFloat() < 0.2*p:GetTrinketMultiplier(mod.ITEM.TRINKET.RUNIC_CUBE) then
        local room = game:GetRoom()
        local spawnPos = room:FindFreePickupSpawnPosition(p.Position)
        local ipool = game:GetItemPool()
        local c = ipool:GetCard(t_rng:Next(), false,  true, true)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, c, spawnPos, Vector.Zero, p) 
        --p:UseActiveItem(CollectibleType.COLLECTIBLE_LEMEGETON, UseFlag.USE_NOANIM)
      end
    end
  end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, mod.ITEM.TRINKET.RUNIC_CUBE, postTakeDMG)