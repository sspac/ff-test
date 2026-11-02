local mod = FiendFolio
local sfx = SFXManager()

local cooldown = 15
local function preKalusClaw(_, _, ent)
	local isBoss = ent:IsBoss()
	if isBoss and ent:GetBossStatusEffectCooldown() <= 0 then
        mod:GetEntityData(ent).CanBeKaluClawed = Game():GetFrameCount()
    end
end

mod:AddTrinketCallback(ModCallbacks.MC_PRE_STATUS_EFFECT_APPLY, mod.ITEM.TRINKET.KALUS_CLAW, preKalusClaw)

local function kalusClaw(_, _, ent)
    
	local isBoss = ent:IsBoss()
	if isBoss and mod:GetEntityData(ent).CanBeKaluClawed ~= Game():GetFrameCount() then
        return
    end
    if ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) or ent.Type == 1 then
        return
    end
        local p = nil
        for index, player in ipairs(mod:GetAllPlayers()) do
            if player:HasTrinket(mod.ITEM.TRINKET.KALUS_CLAW) then
                p = player
                break
            end
        end

        if p then
            local e_data = mod:GetEntityData(ent)
            local lastAttack = e_data.kaluLastSlash or -999
            if (ent.FrameCount - lastAttack) > cooldown then
                e_data.kaluLastSlash = ent.FrameCount
                ent:TakeDamage(p.Damage * 2, 0, EntityRef(p), 0)

                local pow = mod:beahPoof(ent.Position, 7)
                pow.DepthOffset = -9
            
                sfx:Play(mod.Sounds.KaluSlash, 0.4)
            end
        end
end

mod:AddTrinketCallback(ModCallbacks.MC_POST_STATUS_EFFECT_APPLY, mod.ITEM.TRINKET.KALUS_CLAW, kalusClaw)