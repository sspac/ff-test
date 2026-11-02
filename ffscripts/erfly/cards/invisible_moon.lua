local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

mod.InvisibleMoonTimer = mod.InvisibleMoonTimer or 0

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, useFlags)
    local rng = player:GetCardRNG(cardID)
    local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
    sfx:Play(mod.Sounds.FlashDevilCard, 0.4, 0, false, 0.75)
    mod.InvisibleMoonTimer = mod.InvisibleMoonTimer or 0
    mod.InvisibleMoonTimer = mod.InvisibleMoonTimer + 300 * secondHandMultiplier
    game:Darken(1, mod.InvisibleMoonTimer)
    for i = 1, 100 do
        local vecX = math.random(50,100)
        if math.random(2) == 1 then
            vecX = vecX * -1
        end

        local side = -400 + math.random(room:GetGridWidth()*40 + 650)

        local eff = Isaac.Spawn(1000, 138, 961, Vector(side, 30 + math.random(room:GetGridHeight() * 40 + 120)), Vector(vecX, 0), nil):ToEffect()
        eff.Color = Color(0.5,0.5,0.5,1,0.5,0,0)
        mod:GetEntityData(eff).opacity = 0.3
        eff:GetSprite():Stop()
        eff:GetSprite():SetFrame(math.random(4)-1)
        eff.Timeout = 50
        eff:Update()
    end
    mod:trySayAnnouncerLine(mod.Sounds.VACardInvisibleMoon, useFlags, 60)
end, mod.ITEM.CARD.THE_INVISIBLE_MOON)

function mod.invisibleMoonUpdate()
    if mod.InvisibleMoonTimer and mod.InvisibleMoonTimer > 0 then
        mod.InvisibleMoonTimer = mod.InvisibleMoonTimer - 1
    end
end

function mod:invisibleMoonEntityUpdate(npc, data)
    if mod.InvisibleMoonTimer and mod.InvisibleMoonTimer > 0 then
        if (not npc:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET)) and (not mod:isFriend(npc)) then
            mod.AddBerserk(npc, Isaac.GetPlayer(), mod.InvisibleMoonTimer)
        end
    end
end