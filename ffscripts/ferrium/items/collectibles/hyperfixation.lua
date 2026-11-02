local mod = FiendFolio
local game = Game()

local bal = {
    Chance = 30,
    CooldownB = {40,250,30},
    StatusTime = 120,
}

function mod:HyperFixationUpdate(player)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.HYPERFIXATION) then
        local mult = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.HYPERFIXATION)
        local d = mod:GetEntityData(player)
        d.HyperfixationCooldown = d.HyperfixationCooldown or 0
        if d.NoMoreHyperfixations then
            if d.NoMoreHyperfixations and mod:superExists(d.NoMoreHyperfixations) then
                if not mod:GetEntityData(d.NoMoreHyperfixations).HyperFixationTargeted then
                    d.HyperfixationCooldown = math.max(bal.CooldownB[1], bal.CooldownB[2]-bal.CooldownB[3]*mult)
                    d.NoMoreHyperfixations = nil
                end
            else
                d.HyperfixationCooldown = math.max(bal.CooldownB[1], bal.CooldownB[2]-bal.CooldownB[3]*mult)
                d.NoMoreHyperfixations = nil
            end
        elseif d.HyperfixationCooldown <= 0 then
            local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.HYPERFIXATION)
            local mult2 = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND)+1
            local chance = bal.Chance
            if player.FrameCount % 2 == 0 and mod.IsActiveRoom() and rng:RandomInt(100) < chance then
                local enemies = {}
                for _,entity in ipairs(Isaac.FindInRadius(player.Position, 1050, EntityPartition.ENEMY)) do
                    if entity:ToNPC() and (not mod:isFriend(entity)) and entity:IsActiveEnemy() and entity:IsVulnerableEnemy()
                    and not (entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) or entity:HasEntityFlags(EntityFlag.FLAG_NO_TARGET))
                    and not mod:GetEntityData(entity).HyperfixationTargeted then
                        table.insert(enemies, entity)
                    end
                end
                if #enemies > 0 then
                    local chosen = enemies[rng:RandomInt(#enemies)+1]
                    mod:GetEntityData(chosen).HyperfixationTargeted = bal.StatusTime*(mult+mult2)
                    mod:GetEntityData(chosen).HyperfixationPlayer = player
                    d.NoMoreHyperfixations = chosen
                end
            end
        else
            d.HyperfixationCooldown = d.HyperfixationCooldown-1
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.HYPERFIXATION, mod.HyperFixationUpdate)

local sp = Sprite()
sp:Load("gfx/effects/effect_hyperfixation.anm2", true)
--sp:ReplaceSpritesheet(1, "gfx/effects/effect_hyperfixation.png", true)
sp:Play("Default", true)
mod:AddCollectibleCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.ITEM.COLLECTIBLE.HYPERFIXATION, function(_, npc)
    local d = mod:GetEntityData(npc)
    if mod:IsNormalRender(false) then
        if d.HyperfixationTargeted then
            if d.HyperfixationPlayer and d.HyperfixationPlayer:Exists() then
                d.HyperfixationEffectDisplay = d.HyperfixationEffectDisplay or 0
                if d.HyperfixationTargeted > 0 then
                    d.HyperfixationTargeted = d.HyperfixationTargeted-1
                else
                    d.HyperfixationPlayer = nil
                    d.HyperfixationTargeted = nil
                end
            else
                d.HyperfixationPlayer = nil
                d.HyperfixationTargeted = nil
            end
        end
        if d.HyperfixationEffectDisplay then
            local sprite = npc:GetSprite():GetNullFrame("OverlayEffect")
            local offset = Vector(0,-30)*npc.SpriteScale.Y
            if sprite and sprite:GetPos() then
                offset = sprite:GetPos() + Vector(0,-16) + RandomVector()
            end
            sp:SetFrame("Default", math.floor(d.HyperfixationEffectDisplay))
            sp:Render(Isaac.WorldToScreen(npc.Position)+offset, Vector.Zero, Vector.Zero)
            if d.HyperfixationTargeted then
                d.HyperfixationEffectDisplay = math.min(4, d.HyperfixationEffectDisplay + 0.5)
            else
                d.HyperfixationEffectDisplay = d.HyperfixationEffectDisplay - 0.5
                if d.HyperfixationEffectDisplay < 0 then
                    d.HyperfixationEffectDisplay = nil
                end
            end
        end
    end
end)

mod:AddPriorityCollectibleCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.LATE, mod.ITEM.COLLECTIBLE.HYPERFIXATION, function(_, ent)
    local d = mod:GetEntityData(ent)
    if d.HyperfixationTargeted and not (ent:HasMortalDamage() or ent:IsDead()) then
        local aura = Isaac.Spawn(1000, 123, 8, ent.Position, Vector.Zero, ent):ToEffect()
		aura.SpriteScale = Vector(1,1)
        game:MakeShockwave(ent.Position, 0.03, 0.02, 6)
        for _,tear in ipairs(Isaac.FindByType(2, -1, -1, false, false)) do
            tear = tear:ToTear()
            if not tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) then
                tear.Velocity = Vector.Zero
                tear.FallingSpeed = -0.1
                tear.FallingAcceleration = -0.05

                local tab1 = {update = function(v, tab, data, key)
                    if tab.HyperTarget and mod:superExists(tab.HyperTarget) then
                        if tab.Hyperfixated then
                            v.Velocity = mod:Lerp(v.Velocity, (tab.HyperTarget.Position-v.Position):Resized(15), 0.3)
                        else
                            if tab.HyperTimer > 0 then
                                tab.HyperTimer=tab.HyperTimer-1
                            else
                                tab.Hyperfixated = true
                            end
                            v.Velocity = Vector.Zero
                            v.FallingAcceleration = -0.05
                            v.FallingSpeed = -0.01
                        end
                    else
                        v.FallingAcceleration = 1
                        if key then
                            data.customTearBehavior.update[key] = nil
                        else
                            data.customTearBehavior = nil
                        end
                    end
                end, HyperTimer = 10, HyperTarget = ent}
                mod:TryToAddTearBehavior(tear, mod:GetEntityData(tear), tab1)
            end
        end

        for _,proj in ipairs(Isaac.FindByType(9, -1, -1, false, false)) do
            proj = proj:ToProjectile()
            proj:AddProjectileFlags(ProjectileFlags.HIT_ENEMIES | ProjectileFlags.CANT_HIT_PLAYER)
            local tab2 = {update = function(v, tab)
                if tab.HyperTarget and mod:superExists(tab.HyperTarget) then
                    if tab.Hyperfixated then
                        v.Velocity = mod:Lerp(v.Velocity, (tab.HyperTarget.Position-v.Position):Resized(15), 0.3)
                    else
                        if tab.HyperTimer > 0 then
                            tab.HyperTimer=tab.HyperTimer-1
                        else
                            tab.Hyperfixated = true
                        end
                        v.Velocity = Vector.Zero
                        v.FallingAccel = -0.05
                        v.FallingSpeed = -0.01
                    end
                else
                    v.FallingAccel = 1
                    mod:GetEntityData(v).customTearBehavior = nil
                end
            end, HyperTimer = 10, HyperTarget = ent}
            mod:TryToAddProjBehavior(proj, mod:GetEntityData(proj), tab2)
        end

        d.HyperfixationTargeted = nil
    end
end)