local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local ORICHALCOS_SEAL_RADIUS = 200
local ORICHALCOS_SEAL_ALPHA = 0.2

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, useFlags)
    sfx:Play(mod.Sounds.YgoCard, 1, 0, false, 0.75)
    mod:trySayAnnouncerLine(mod.Sounds.VACardSealofOrichalcos, useFlags, 40)
    mod.sealOfOrichalcosActive = true
    if not mod:GetEntityData(player).sealOfOrichalcosActive then
        player:AddNullItemEffect(mod.ITEM.NULL.SEAL_OF_ORICHALCOS)
        mod:GetEntityData(player).sealOfOrichalcosActive = true
        local seal = Isaac.Spawn(mod.FF.OrichalcosSeal.ID, mod.FF.OrichalcosSeal.Var, mod.FF.OrichalcosSeal.Sub, player.Position, Vector.Zero, player):ToEffect()
        seal:FollowParent(player)
        seal:Update()
    end
end, FiendFolio.ITEM.CARD.SEAL_OF_ORICHALCOS)

function mod:sealOfOrichalcosNewRoom(player, d)
    d.sealOfOrichalcosActive = false
    mod.sealOfOrichalcosActive = false
end

function mod:sealOfOrichalcosEffect(e)
    e.DepthOffset = -500
    local sprite = e:GetSprite()
    if sprite:IsFinished("Appear") then
        mod:spritePlay(sprite, "Idle")
    end
    e.Color = Color(1,1,1,ORICHALCOS_SEAL_ALPHA)
end

mod:AddPlayerTempEffectCallback(ModCallbacks.MC_POST_NPC_DEATH, Isaac.GetItemConfig():GetNullItem(mod.ITEM.NULL.SEAL_OF_ORICHALCOS), function(_, npc)
    if mod.sealOfOrichalcosActive and not npc:HasEntityFlags(EntityFlag.FLAG_NO_REWARD) then
        local foundPlayer
        for _, player in pairs(Isaac.FindByType(1)) do
            player = player:ToPlayer()
            if mod:GetEntityData(player).sealOfOrichalcosActive then
                local dist = player.Position:Distance(npc.Position)
                dist = dist + player.Size + npc.Size
                if dist <= ORICHALCOS_SEAL_RADIUS then
                    foundPlayer = player
                    break
                end
            end
        end
        if foundPlayer then
            local wisp = foundPlayer:ToPlayer():AddWisp(0, npc.Position, true)
            sfx:Play(mod.Sounds.FireFizzle, 1, 0, false, math.random(70,120)/100)
        end
    end
end)