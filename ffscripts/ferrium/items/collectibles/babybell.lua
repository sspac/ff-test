local mod = FiendFolio
local sfx = SFXManager()

local bal = {
    BlockExtra = 5,
    ScareRadius = 85,
    ScareDur = 50,
    KnockbackStrengthEnemy = 18,
    KnockbackStrengthProj = 8,
    RingMax = 6,
    DeactivateTimer = 130,
}

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, fam)
    local d = mod:GetEntityData(fam)
    fam:AddToOrbit(1)
    d.State = "Idle"
    d.StateFrame = 0
end, mod.ITEM.FAMILIAR.BABY_BELL)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
    local d = mod:GetEntityData(fam)
    local sprite = fam:GetSprite()
    local mult = fam:GetMultiplier()
    local player = fam.Player
    local rng = fam:GetDropRNG()

    d.StateFrame = d.StateFrame+1

    local projs = {}
    for _,ent in ipairs(Isaac.FindByType(9,-1,-1,false, true)) do
		if ent.Position:DistanceSquared(fam.Position) <= (ent.Size+fam.Size)^2+bal.BlockExtra then
			ent:Die()
            d.HitByProj = true
        else
            table.insert(projs, ent:ToProjectile())
        end
	end

    if fam.FrameCount % 7 == 0 then
        for _,ent in ipairs(Isaac.FindInRadius(fam.Position, 500, EntityPartition.ENEMY)) do
		    if ent:IsActiveEnemy() and ent:IsVulnerableEnemy() and not mod:isFriend(ent) and ent.Position:DistanceSquared(fam.Position) <= (ent.Size+fam.Size)^2 then
				ent:TakeDamage(player.Damage/2*mult, 0, EntityRef(player), 0)
                d.HitByProj = true
			end
		end
    end

    if d.State == "Idle" then
        if d.HitByProj then
            d.State = "Ringing"
            d.RingCount = 0
        else
            mod:spritePlay(sprite, "Idle")
        end
    elseif d.State == "Deactivated" then
        if d.StateFrame > bal.DeactivateTimer then
            d.State = "Reactivate"
        end

        mod:spritePlay(sprite, "DullIdle")
    elseif d.State == "Ringing" then
        if sprite:IsEventTriggered("End") then
            d.RingCount = d.RingCount+1

            if d.RingCount > bal.RingMax+mult then
                d.State = "RingingStop"
            end
        elseif sprite:IsEventTriggered("Ding") then
            sfx:Play(mod.Sounds.SmallBell, 0.7, 0, false, mod:RandomInt(90,110,rng)/100)
            for i=0,1 do
                mod.scheduleForUpdate(function()
                    local burst = Isaac.Spawn(1000, EffectVariant.BIG_ATTRACT, 10, fam.Position, Vector.Zero, fam):ToEffect()
                    burst:SetTimeout(30)
                    burst.Color = Color(1, 0.85, 0.2, 0.4, 0.5, 0.5, 0.5)
                    mod:GetEntityData(burst).cochleaEffect = {scale = 0.04, frames = 0, speed = 0.035}
                    burst.SpriteScale = Vector.Zero
                    burst:GetSprite().Rotation = burst:GetDropRNG():RandomInt(360)
                    burst:Update()
                end, 3*i)
            end
            
            local dur = bal.ScareDur*(player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND)+1)
            for _,enemy in ipairs(Isaac.FindInRadius(fam.Position, bal.ScareRadius, EntityPartition.ENEMY)) do
                if enemy:IsActiveEnemy() and (not mod:isFriend(enemy)) then
                    if not enemy:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) then
                        enemy:AddFear(EntityRef(fam), dur)
                    end
                    if not enemy:HasEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK) then
                        enemy.Velocity = (enemy.Position-fam.Position):Resized(bal.KnockbackStrengthEnemy)
                    end
                end
            end

            for _,proj in ipairs(projs) do
                if not proj:HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) then
                    proj:AddProjectileFlags(ProjectileFlags.HIT_ENEMIES | ProjectileFlags.CANT_HIT_PLAYER)
                    proj.Velocity = (proj.Position-fam.Position):Resized(bal.KnockbackStrengthProj)
                end
            end
        else
            mod:spritePlay(sprite, "Ring")
        end
    elseif d.State == "RingingStop" then
        if sprite:IsFinished("RingStop") then
            d.State = "Deactivated"
            d.StateFrame = 0
        else
            mod:spritePlay(sprite, "RingStop")
        end
    elseif d.State == "Reactivate" then
        if sprite:IsFinished("Awaken") then
            d.State = "Idle"
            d.HitByProj = nil
        elseif sprite:IsEventTriggered("Activate") then
            sfx:Play(SoundEffect.SOUND_UNHOLY, 0.2, 0, false, mod:RandomInt(16,22,rng)/10)
        else
            mod:spritePlay(sprite, "Awaken")
        end
    end

    local pos = fam:GetOrbitPosition(player.Position + player.Velocity)
    fam.Velocity = (pos-fam.Position)
end, mod.ITEM.FAMILIAR.BABY_BELL)