local mod = FiendFolio

FiendFolio.LoadScripts({
  "ffscripts.sbody.misc",
  "ffscripts.sbody.enemies.offset_grimaces",
  "ffscripts.sbody.enemies.punisher",
  "ffscripts.sbody.items.nugget_bombs",
  "ffscripts.sbody.items.azurite_spindown",
  "ffscripts.sbody.items.mammonite_codex.lua",
  "ffscripts.sbody.items.eternal_d12",
  "ffscripts.sbody.bosses.vanillachampions",
})


--[[
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, npc)
  for i=0, 15 do
    local pos = Game():GetRoom():GetCenterPos()
    local splat = Isaac.Spawn(1000, 7, 0, pos, Vector(0,0), nil):ToEffect()
    splat:GetSprite():Play("Size6BloodStains", true)
    splat:GetSprite():SetFrame(2)
    splat:GetSprite():Stop()
    splat.Scale = 75

    local color = Color(1, 1, 1, 1, 0, 0, 0)
    color:SetColorize(2, 0, 2, 1)
    splat.Color = color

    --splat:AddEntityFlags(EntityFlag.FLAG_NO_REMOVE_ON_TEX_RENDER)

    --print(splat:GetSprite():GetFrame())

  end
end, CollectibleType.COLLECTIBLE_YUM_HEART)
]]