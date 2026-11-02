local mod = FiendFolio
local costume = Isaac.GetCostumeIdByPath("gfx/characters/058_Book of Shadows.anm2")
FiendFolio.AddItemPickupCallback(function(player)
    local effects = player:GetEffects()
    effects:AddCollectibleEffect(mod.ITEM.COLLECTIBLE.PLANCHETTE)
    effects:GetCollectibleEffect(mod.ITEM.COLLECTIBLE.PLANCHETTE).Cooldown = 2709

    player:AddNullCostume(costume)
end, nil, mod.ITEM.COLLECTIBLE.PLANCHETTE)

local function applyDevil(_,chance)
    return chance + 0.15
end
mod:AddCollectibleCallback(ModCallbacks.MC_PRE_DEVIL_APPLY_ITEMS, mod.ITEM.COLLECTIBLE.PLANCHETTE, applyDevil)

mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, function (_, player)
    local effects = player:GetEffects()
    if effects:HasCollectibleEffect(mod.ITEM.COLLECTIBLE.PLANCHETTE) then
        return false
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_TRIGGER_EFFECT_REMOVED, function(_, player)
	if not player:GetEffects():HasCollectibleEffect(mod.ITEM.COLLECTIBLE.PLANCHETTE) then
		player:TryRemoveNullCostume(costume)
	end
end, Isaac.GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.PLANCHETTE))

--[[for i = 1, 4, 1 do
    player:AddWisp(mod.ITEM.COLLECTIBLE.PLANCHETTE, player.Position)
end]]
--[[local s = 1.4
local smult = Vector(s, s)
local function wispUpdate(_, w)
    if w.SubType == mod.ITEM.COLLECTIBLE.PLANCHETTE then
        w.SpriteScale = smult
    end
end
mod:AddEntityCallback(ModCallbacks.MC_FAMILIAR_UPDATE, EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, mod.ITEM.COLLECTIBLE.PLANCHETTE, wispUpdate, FamiliarVariant.WISP)]]