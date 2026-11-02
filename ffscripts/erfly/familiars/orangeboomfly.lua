local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, fam)
    fam.OrbitDistance = Vector(105,100)
    fam.OrbitSpeed = 0.015
    fam.OrbitLayer = 4
    fam:RecalculateOrbitOffset(fam.OrbitLayer, true)
end, mod.ITEM.FAMILIAR.ORANGE_BOOM_FLY)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
    local sprite = fam:GetSprite()
    local d = mod:GetEntityData(fam)
    local player = fam.Player
    fam.OrbitDistance = Vector(105,100)
    local targetPosition = fam:GetOrbitPosition(player.Position + player.Velocity)
    fam.Velocity = targetPosition - fam.Position
    fam.SpriteOffset = Vector(0,-2)
    local isSuperpositioned = mod:isSuperpositionedPlayer(player)

    if fam.Visible then
        fam.CollisionDamage = 2
        local npcs = Isaac.FindInRadius(fam.Position, 100, EntityPartition.ENEMY)
        local closestdist = 99999
        for _,npc in ipairs(npcs) do
            if npc:IsEnemy() then
                --Please social distance
                local dist = npc.Position:Distance(fam.Position)
                if dist < closestdist then
                    closestdist = dist
                end
                --Likes flies :)
                if ((not npc:ToNPC():IsBoss()) and (FiendFolio.AllFlies[npc.Type] or FiendFolio.AllFlies[npc.Type .. " " .. npc.Variant] or FiendFolio.AllFlies[npc.Type .. " " .. npc.Variant .. " " .. npc.SubType])) then
                    if dist < 50 then
                        npc:AddCharmed(EntityRef(player), 20)
                    end
                end    
            end
        end
        d.swell = d.swell or 0
        if closestdist < 100 then
            d.swell = d.swell + (2 - (closestdist / 50))
        end
        d.swell = math.max(d.swell - 0.3, 0)
    
        if d.swell < 25 then
            mod:spritePlay(sprite, "Idle")
        elseif d.swell < 50 then
            mod:spritePlay(sprite, "Swell1")
        elseif d.swell < 75 then
            mod:spritePlay(sprite, "Swell2")
        else
            mod:spritePlay(sprite, "Swell3")
        end

        if d.swell > 100 then
            d.swell = 0
            fam.Visible = false
            Isaac.Explode(fam.Position, fam, 50)
            for i = 36, 360, 36 do
                local tear = Isaac.Spawn(2, 0, 0, fam.Position, Vector(14,0):Rotated(i), fam):ToTear()
                tear:AddTearFlags(TearFlags.TEAR_CHARM)
                if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
                    tear:SetColor(FiendFolio.ColorPsy,0,0,false,false)
                    tear:AddTearFlags(TearFlags.TEAR_HOMING)
                else
                    tear:SetColor(Color(0.8,0.5,0,1,0,0,0),0,0,false,false)
                end
                local mult = fam:GetMultiplier()
                tear.Scale = 0.7 + 0.2 * math.max(1, mult)
                tear.CollisionDamage = 3.5 * mult
                if isSuperpositioned then
                    tear.CollisionDamage = tear.CollisionDamage / 4
                    local tearcolor = Color.Lerp(tear.Color, Color(1,1,1,1,0,0,0), 0)
                    tearcolor.A = tearcolor.A / 4
                    tear.Color = tearcolor
                end
            end
        end
    else
        fam.CollisionDamage = 0
        d.swell = d.swell + 1
        if d.swell > 300 then
            sfx:Play(mod.Sounds.Tada,0.5,0,false,1.5)
            d.swell = 0
            fam.Visible = true
            local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, fam.Position, nilvector, fam)
            if isSuperpositioned then
                poof.Color = Color(1,1,1,0.25)
            end
        end
    end
    --print(d.swell)
end, mod.ITEM.FAMILIAR.ORANGE_BOOM_FLY)

mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, function(_, fam, collider)
    if collider:ToProjectile() then
    	collider:Die()
		local d = mod:GetEntityData(fam)
        d.swell = d.swell or 0
        d.swell = d.swell + 10
    end
end, mod.ITEM.FAMILIAR.ORANGE_BOOM_FLY)