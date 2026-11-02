local mod = FiendFolio
local fiendfoliodirectory = FiendFolio.DSS_DIRECTORY
local dssmod = FiendFolio.DSS_MOD

--a lot copied from empty book cause this is a joke

fiendfoliodirectory.golemwishlistactivate = {
    title = "to santa:",
    fsize = 2,
    noscroll = true,
    format = {
        Panels = {
            {
                Panel = dssmod.panels.main,
                Offset = Vector(0, 0),
                Color = 1
            },
        }
    },
    buttons = {
        {str = "for christmas i want:", nosel = true},
        {str = "", nosel = true},
        {variable = "golemlist1", setting = 1, choices = {"a rock", "a rock", "a rock", "a rock", "a rock"}, inline = true},
        {str = "and", fsize = 1, nosel = true},
        {variable = "golemlist2", setting = 1, choices = {"a rock", "a rock", "a rock", "a rock"}, inline = true},
        {str = "and also", fsize = 1, nosel = true},
        {variable = "golemlist3", setting = 1, choices = {"a rock", "a rock", "a rock", "a rock", "a rock", "a rock"}, inline = true},
        {str = "", nosel = true},
        {str = "", nosel = true},
        {
            str = "from golem",
            fsize = 3,
            action = "resume",
            func = function(button, item, tbl)
                for i=1,3 do
                    local trink = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, FiendFolio.GetNextMiningMachineTrinket(), item.player.Position, Vector(5,0):Rotated(120*i+90), item.player)
                end

                DeadSeaScrollsMenu.CloseMenu(true)
            end
        }
    },
}

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, item, rng, player, useFlags, slot, varData)
    if useFlags & UseFlag.USE_CARBATTERY == 0 then
        fiendfoliodirectory.golemwishlistactivate.player = player
        DeadSeaScrollsMenu.OpenMenuToPath("Fiend Folio", 'golemwishlistactivate', nil, true)

        return {
            Remove = true,
            ShowAnim = true
        }
    end
end, mod.ITEM.COLLECTIBLE.GOLEMS_WISHLIST)