local mod = FiendFolio
local game = Game()

local bal = {
    MaxTime = 360, --Uhhhh, I think this is 1 minute?
    TimeAdd = 180,
    Slowdown = 0.2,
}

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, item, rng, player, useflags)
    local d = mod:GetEntityData(player)
    local d2 = d.ffsavedata.RunEffects
    d2.CatnipTimer = math.min(bal.MaxTime, (d.CatnipTimer or 0)+bal.TimeAdd)
    d.CatnipInitCheck = nil
end, mod.ITEM.COLLECTIBLE.CATNIP)

local blacklist = {
    [EntityType.ENTITY_TEAR] = true,
    [EntityType.ENTITY_KNIFE] = true,
}

function mod:CatnipUpdate(player, d)
    local d2 = d.ffsavedata.RunEffects
    if d2.CatnipTimer then
        if d2.CatnipTimer > 0 then
            if d2.CatnipTimer % 30 == 0 or not d.CatnipInitCheck then
                d.CatnipInitCheck = true
                for _,ent in ipairs(Isaac.GetRoomEntities()) do
                    if not blacklist[ent.Type] then
                        mod:GetEntityData(ent).CatnipSlowdown = true
                    end
                end
            end
            d2.CatnipTimer = d2.CatnipTimer-1
        else
            for _,ent in ipairs(Isaac.GetRoomEntities()) do
                mod:GetEntityData(ent).CatnipSlowdown = nil
            end
            d2.CatnipTimer = nil
            d.CatnipInitCheck = nil
        end
    end
end

function mod:CatnipNPCInit(npc, player)
    if mod:GetEntityData(player).ffsavedata.RunEffects.CatnipTimer then
        mod:GetEntityData(npc).CatnipSlowdown = true
    end
end

function mod:CatnipProjInit(proj, player)
    if mod:GetEntityData(player).ffsavedata.RunEffects.CatnipTimer then
        mod:GetEntityData(proj).CatnipSlowdown = true
    end
end

--[[function mod:CatnipEffectInit(effect, player)
    if mod:GetEntityData(player).ffsavedata.RunEffects.CatnipTimer then
        mod:GetEntityData(effect).CatnipSlowdown = true
    end
end]]

mod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, function(_, npc)
    if mod:GetEntityData(npc).CatnipSlowdown then
        npc:SetSpeedMultiplier(bal.Slowdown)
    end
end)

mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_UPDATE, function(_, player)
    local slowed
    for i = 1, game:GetNumPlayers() do
		local p = Isaac.GetPlayer(i - 1)
		if mod:GetEntityData(p).ffsavedata.RunEffects.CatnipTimer then
            slowed = true
            break
        end
	end
    if slowed then
        player:SetSpeedMultiplier(bal.Slowdown)
    end
end)

mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_UPDATE, function(_, proj)
    if mod:GetEntityData(proj).CatnipSlowdown then
        proj:SetSpeedMultiplier(bal.Slowdown)
    end
    proj:SetSpeedMultiplier(0.1)
end)