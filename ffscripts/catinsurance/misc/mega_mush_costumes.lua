-- Handle costumes for mega mush ( doesn't work ) ( edit: yes it does )

local megaCostumes = {
    [FiendFolio.PLAYER.FIEND] = "gfx/characters/costumes_fiend/big_isaac.png",
    [FiendFolio.PLAYER.BIEND] = "gfx/characters/costumes_biend/big_isaac.png",
    [FiendFolio.PLAYER.FRIEND] = "gfx/characters/costumes_friend/big_isaac.png",
    [FiendFolio.PLAYER.BRIEND] = "gfx/characters/costumes_friend/big_isaac.png",
}

---@param player EntityPlayer
FiendFolio:AddCallback(ModCallbacks.MC_POST_ITEM_OVERLAY_SHOW, function (_, _, _, overlayUser)
    if not overlayUser then
        return
    end
    
    local path = megaCostumes[overlayUser:GetPlayerType()]
    if path then
        local overlaySprite = ItemOverlay.GetMegaMushPlayerSprite()
        overlaySprite:ReplaceSpritesheet(0, path)
        overlaySprite:ReplaceSpritesheet(1, path)
        overlaySprite:ReplaceSpritesheet(2, overlayUser:GetSprite():GetLayer(0):GetSpritesheetPath(), true)

        -- Update costume now (deferred so that it actually works)
        Isaac.CreateTimer(function ()
            for _, costume in ipairs(overlayUser:GetCostumeSpriteDescs()) do
                local costumeSprite = costume:GetSprite()

                if costume:GetItemConfig().ID == CollectibleType.COLLECTIBLE_MEGA_MUSH
                and costumeSprite:GetLayer(0):GetSpritesheetPath() ~= path then
                    costumeSprite:ReplaceSpritesheet(0, path)
                    costumeSprite:ReplaceSpritesheet(1, path)
                    costumeSprite:ReplaceSpritesheet(2, overlayUser:GetSprite():GetLayer(0):GetSpritesheetPath(), true)
                end
            end
        end, 1, 1, true)
    end
end)