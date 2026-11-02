local mod = FiendFolio

--Stolen function edited from the Beaten mod / Tarnished Bryson, thank you for the example!

function mod:getSkeletalFiendInEpiphany()
    if not Epiphany or not Epiphany.API then return end
    if Epiphany.TheSkeletalFiendHasBeenInjected then return end
    
    local function skeletalFiendUnlocked(absoluteness)
        return FiendFolio.ACHIEVEMENT.SKELETALFIEND:IsUnlocked(absoluteness)
    end
    
    Epiphany.API.AddCharacter({
        charName = "The Skeletal Fiend",
        charID = FiendFolio.PLAYER.SKELETAL_FIEND,
        menuGraphics = "gfx/ui/tarnished/epiphany_skeletalfiend_menu.anm2",
        costume = "gfx/characters/player_skeletal_fiend.anm2",
        coopMenuSprite = "gfx/characters/player_skeletal_fiend.anm2",
        unlockChecker = function() return skeletalFiendUnlocked() end,
    })
    Epiphany.TheSkeletalFiendHasBeenInjected = true

    local bonies = {
        [EntityType.ENTITY_BONY] = true,
        [EntityType.ENTITY_BLACK_BONY] = true,
        [EntityType.ENTITY_BIG_BONY] = true,
    }
    
    function mod:skeletalFiendCheckBonyDeath(npc)
        if not skeletalFiendUnlocked(true) then
            if PlayerManager.AnyoneIsPlayerType(mod.PLAYER.BIEND) then
                --I gotta be real I don't want to be too in depth with this
                --It's a bit of a joke, overly simple unlock condition so
                FiendFolio.ACHIEVEMENT.SKELETALFIEND:Unlock()
            end
        end
    end
    mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.skeletalFiendCheckBonyDeath, EntityType.ENTITY_BONY)
    mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.skeletalFiendCheckBonyDeath, EntityType.ENTITY_BLACK_BONY)
    mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.skeletalFiendCheckBonyDeath, EntityType.ENTITY_BIG_BONY)

    mod:RemoveCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.getSkeletalFiendInEpiphany)
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.getSkeletalFiendInEpiphany)