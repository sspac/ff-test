local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

--Don't mind references to the name "slap card", this was the old name

local slapVal = 60 --How many frames (30fps) of slap card get added on use

mod.slapCardKillers = {
    [EntityType.ENTITY_PROJECTILE] = true,
    [EntityType.ENTITY_EFFECT .. "." .. EffectVariant.CREEP_RED] = true,
    [EntityType.ENTITY_EFFECT .. "." .. EffectVariant.CREEP_GREEN] = true,
    [EntityType.ENTITY_EFFECT .. "." .. EffectVariant.CREEP_YELLOW] = true,
    [EntityType.ENTITY_EFFECT .. "." .. EffectVariant.CREEP_WHITE] = true,
    [EntityType.ENTITY_EFFECT .. "." .. EffectVariant.CREEP_BLACK] = true,
    [EntityType.ENTITY_EFFECT .. "." .. EffectVariant.FIRE_JET] = true,
    [EntityType.ENTITY_EFFECT .. "." .. 7005] = true,
    [mod.FF.Bubble.ID .. "." .. mod.FF.Bubble.Var] = true,
    [mod.FF.FlyBundle.ID .. "." .. mod.FF.FlyBundle.Var] = true,
    [mod.FF.BoneRocket.ID .. "." .. mod.FF.BoneRocket.Var] = true,
    [mod.FF.StingerProj.ID .. "." .. mod.FF.StingerProj.Var] = true,
    [mod.FF.SporeProjectile.ID .. "." .. mod.FF.SporeProjectile.Var] = true,
    [mod.FF.NerveCluster.ID .. "." .. mod.FF.NerveCluster.Var] = true,
    [mod.FF.RiderScythe.ID .. "." .. mod.FF.RiderScythe.Var] = true,
    [mod.FF.WardenStar.ID .. "." .. mod.FF.WardenStar.Var] = true,
    [mod.FF.FloatingSpore.ID .. "." .. mod.FF.FloatingSpore.Var] = true,
    [mod.FF.MegaHemo.ID .. "." .. mod.FF.MegaHemo.Var] = true,
    [mod.FF.BoneCross.ID .. "." .. mod.FF.BoneCross.Var] = true,
    [mod.FF.SternumRib.ID .. "." .. mod.FF.SternumRib.Var] = true,
    [mod.FF.SpiderProj.ID .. "." .. mod.FF.SpiderProj.Var] = true,
    [mod.FF.SkullShot.ID .. "." .. mod.FF.SkullShot.Var] = true,
    --[mod.FF.ZtewieStinger.ID .. "." .. mod.FF.ZtewieStinger.Var] = true,
    [mod.FF.ScrewProjectile.ID .. "." .. mod.FF.ScrewProjectile.Var] = true,
}

local vignette = Sprite()
vignette:Load("gfx/ui/slap_vignette.anm2", true)
vignette.Scale = Vector(0.2,0.2)
vignette.Color = Color(1,1,1,0)
local vCol = 0.7
local eCol = 1.5
local maxAlpha = 0.5
local colRate = maxAlpha / 10

StageAPI.AddCallback("FiendFolio", "POST_HUD_RENDER", 1, function(isPauseMenuOpen, pauseMenuDarkPct)
    if (StageAPI ~= nil and StageAPI.PlayingBossSprite) then return end
    if mod.slapCardActive then
        local rCol = vCol
        if FiendFolio.savedata.run.slapCardEvil then
            rCol = eCol
        end
        if vignette.Color.A < maxAlpha then
            vignette.Color = Color(rCol,vCol,vCol,math.min(vignette.Color.A + colRate, maxAlpha))
        end
    else
        local rCol = vCol
        if FiendFolio.savedata.run.slapCardEvil then
            rCol = eCol
        end
        if vignette.Color.A > 0 then
            vignette.Color = Color(rCol,vCol,vCol,math.max(vignette.Color.A - colRate, 0))
        end
    end
    if vignette.Color.A > 0 then
        local middlePos = StageAPI.GetScreenCenterPosition()
        local screenScale = StageAPI.GetScreenBottomRight()
        local scaleX = (1/1024) * screenScale.X
        local scaleY = (1/732) * screenScale.Y
        vignette:SetFrame("Meter", 0)
        vignette.Scale = Vector(scaleX,scaleY)
        vignette:Render(middlePos, Vector.Zero, Vector.Zero)
    end
end)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, typ, rng, player, useflags)
    FiendFolio.savedata = FiendFolio.savedata or {}
    FiendFolio.savedata.run = FiendFolio.savedata.run or {}
    FiendFolio.savedata.run.slapCardActive = FiendFolio.savedata.run.slapCardActive or 0
    FiendFolio.savedata.run.slapCardActive = FiendFolio.savedata.run.slapCardActive + slapVal

    local hasCarBattery = useflags == useflags | UseFlag.USE_CARBATTERY
    local isBelial = mod:playerIsBelialMode(player)
    if isBelial then
        FiendFolio.savedata.run.slapCardEvil = true
    end

    for k = 0, 1 do
        mod.scheduleForUpdate(function()
            for _, ent in ipairs(Isaac.GetRoomEntities()) do
                local id, var, subt = ent.Type, ent.Variant, ent.SubType
                if mod.slapCardKillers[id] or mod.slapCardKillers[id .. "." .. var] or mod.slapCardKillers[id .. "." .. var .. "." .. subt] then
                    if id == 1000 then
                        local cloud = Isaac.Spawn(1000, mod.FF.FFWhiteSmoke.Var, mod.FF.FFWhiteSmoke.Sub, ent.Position - ent.Velocity, ent.Velocity, ent)
                        mod:GetEntityData(cloud).longonly = true
                        cloud.SpriteOffset = Vector(0, ent.SpriteOffset.Y * 0.5)
                        cloud.SpriteScale = Vector(0.75,0.75) * ent:ToEffect().Scale
                        cloud.Color = ent.Color
                        cloud:Update()
                        ent:Remove()
                    else
                        ent:Die()
                    end
                end
                if k == 0 and ent:IsVulnerableEnemy() and not ent:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) and (not mod:isFriend(ent)) then
                    local npc = ent:ToNPC()
                    if npc then
                        if hasCarBattery then
                            mod.AddPacified(npc, player, FiendFolio.savedata.run.slapCardActive)
                        end
                        if isBelial then
                            npc:TakeDamage(player.Damage * 3, 0, EntityRef(player), 0)
                        end
                    end
                end
            end
        end, k)
    end
    sfx:Play(mod.Sounds.SlapcardItemActivate, 1, 0, false, mod:RandomInt(90,110,rng)/100)
    game:MakeShockwave(player.Position, 0.035, 0.025, 10)
    return true
end, mod.ITEM.COLLECTIBLE.SERTRALINE)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local sd = FiendFolio.savedata
    if sd and sd.run then
        local rundata = sd.run
        if rundata.slapCardActive then
            mod.slapCardActive = true
            rundata.slapCardActive = rundata.slapCardActive - 1
            if rundata.slapCardActive <= 0 then
                rundata.slapCardActive = nil
                rundata.slapCardEvil = nil
            end
        else
            mod.slapCardActive = nil
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_INIT, function(_, proj)
    if mod.slapCardActive then
        FiendFolio.savedata = FiendFolio.savedata or {}
        FiendFolio.savedata.run = FiendFolio.savedata.run or {}
        if FiendFolio.savedata.run.slapCardActive then
            local cloud = Isaac.Spawn(1000, mod.FF.FFWhiteSmoke.Var, mod.FF.FFWhiteSmoke.Sub, proj.Position - proj.Velocity, (proj.Velocity * 0.25):Rotated(mod:RandomInt(-45,45)), proj)
            mod:GetEntityData(cloud).longonly = true
            cloud.SpriteOffset = Vector(0, proj.Height * 0.5)
            cloud.SpriteScale = Vector(0.75,0.75) * proj.Scale
            cloud.Color = proj.Color
            cloud:Update()
            proj:Remove()
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, ent)
    if mod.slapCardActive then
        FiendFolio.savedata = FiendFolio.savedata or {}
        FiendFolio.savedata.run = FiendFolio.savedata.run or {}
        if FiendFolio.savedata.run.slapCardActive then
            local id, var, subt = ent.Type, ent.Variant, ent.SubType
            if mod.slapCardKillers[id] or mod.slapCardKillers[id .. "." .. var] or mod.slapCardKillers[id .. "." .. var .. "." .. subt] then
                local cloud = Isaac.Spawn(1000, mod.FF.FFWhiteSmoke.Var, mod.FF.FFWhiteSmoke.Sub, ent.Position - ent.Velocity, ent.Velocity, ent)
                mod:GetEntityData(cloud).longonly = true
                cloud.SpriteOffset = Vector(0, ent.SpriteOffset.Y * 0.5)
                cloud.SpriteScale = Vector(0.75,0.75) * ent.Scale
                cloud.Color = ent.Color
                cloud:Update()
                ent:Die()
            end
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, ent)
    if mod.slapCardActive then
        FiendFolio.savedata = FiendFolio.savedata or {}
        FiendFolio.savedata.run = FiendFolio.savedata.run or {}
        if FiendFolio.savedata.run.slapCardActive then
            local id, var, subt = ent.Type, ent.Variant, ent.SubType
            if mod.slapCardKillers[id] or mod.slapCardKillers[id .. "." .. var] or mod.slapCardKillers[id .. "." .. var .. "." .. subt] then
                local cloud = Isaac.Spawn(1000, mod.FF.FFWhiteSmoke.Var, mod.FF.FFWhiteSmoke.Sub, ent.Position - ent.Velocity, ent.Velocity, ent)
                mod:GetEntityData(cloud).longonly = true
                cloud.SpriteOffset = Vector(0, ent.SpriteOffset.Y * 0.5)
                cloud.SpriteScale = Vector(0.75,0.75) * ent.Scale
                cloud.Color = ent.Color
                cloud:Update()
                ent:Remove()
            end
        end
    end
end)

--[[mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, function(_, id, var, subt, pos, vel, spawner, seed)
    FiendFolio.savedata = FiendFolio.savedata or {}
    FiendFolio.savedata.run = FiendFolio.savedata.run or {}
    if FiendFolio.savedata.run.slapCardActive then
        local killit = true
        if spawner and spawner:ToNPC() and mod:isFriend(spawner:ToNPC()) then
            killit = false
        end
        if killit then
            if mod.slapCardKillers[id] or mod.slapCardKillers[id .. "." .. var] or mod.slapCardKillers[id .. "." .. var .. "." .. subt] then
                return {1000,0,999,seed}
            end
        end
    end
end)]]

mod:AddCallback(ModCallbacks.MC_USE_PILL, function(_, pillEffect, player, flags, pillColor)
    player:AnimatePill(pillColor)
	local doHorseEffect = pillColor & PillColor.PILL_GIANT_FLAG > 0
    local slapValAmount = slapVal
    if doHorseEffect then
        slapValAmount = slapValAmount * 3
        mod:trySayAnnouncerLine(mod.Sounds.VAPillHorseSertraline, flags, 40)
    else
        mod:trySayAnnouncerLine(mod.Sounds.VAPillSertraline, flags, 40)
    end
	FiendFolio.savedata = FiendFolio.savedata or {}
    FiendFolio.savedata.run = FiendFolio.savedata.run or {}
    FiendFolio.savedata.run.slapCardActive = FiendFolio.savedata.run.slapCardActive or 0
    FiendFolio.savedata.run.slapCardActive = FiendFolio.savedata.run.slapCardActive + slapValAmount
	for k = 0, 1 do
        mod.scheduleForUpdate(function()
            for _, ent in ipairs(Isaac.GetRoomEntities()) do
                local id, var, subt = ent.Type, ent.Variant, ent.SubType
                if mod.slapCardKillers[id] or mod.slapCardKillers[id .. "." .. var] or mod.slapCardKillers[id .. "." .. var .. "." .. subt] then
                    if id == 1000 then
                        local cloud = Isaac.Spawn(1000, mod.FF.FFWhiteSmoke.Var, mod.FF.FFWhiteSmoke.Sub, ent.Position - ent.Velocity, ent.Velocity, ent)
                        mod:GetEntityData(cloud).longonly = true
                        cloud.SpriteOffset = Vector(0, ent.SpriteOffset.Y * 0.5)
                        cloud.SpriteScale = Vector(0.75,0.75) * ent:ToEffect().Scale
                        cloud.Color = ent.Color
                        cloud:Update()
                        ent:Remove()
                    else
                        ent:Die()
                    end
                end
                if doHorseEffect and k == 0 and ent:IsVulnerableEnemy() and not ent:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) and (not mod:isFriend(ent)) then
                    local npc = ent:ToNPC()
                    if npc then
                        mod.AddPacified(npc, player, slapValAmount)
                    end
                end
            end
        end, k)
    end
    sfx:Play(mod.Sounds.SlapcardItemActivate, 1, 0, false, mod:RandomInt(90,110,rng)/100)
    game:MakeShockwave(player.Position, 0.035, 0.025, 10)
    return true
end, mod.ITEM.PILL.SERTRALINE)