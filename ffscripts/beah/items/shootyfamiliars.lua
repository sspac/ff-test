local mod = FiendFolio

local genericDamage, genericFirerate = 3.5, 22
local excommunicateDuration, burgleDuration = 45, 22 --taken from their respective items for reference, and then halved for balance
local overloadingTimes, shockMult, shockRest, shockActive = 1, 0.4, 45, 15
local familiars = {
    [mod.ITEM.FAMILIAR.PAPAL_PAL] = { tfunc = function (tear, secondhandmult)
        FiendFolio.FlagExcommunicate(tear, excommunicateDuration*secondhandmult, genericDamage)
    end,
    fr = 44 ,
    color = Color(1.3, 1.3, 1.3, 1.0, 0/255, 30/255, 45/255, 1.0, 1.0, 1.0, 1) }, --these were also taken from their respective items, for consistency. if these ever get added as some like constant value fix this
    [mod.ITEM.FAMILIAR.OUTLET_BABY] = { tfunc = function (tear, secondhandmult)
			FiendFolio.FlagOverload(tear, overloadingTimes*secondhandmult, genericDamage*shockMult, shockRest, shockActive)
    end,
    color = Color(1.0, 1.0, 0.0, 1.0, 80/255, 20/255, 0/255, 1.0, 1.0, 0.0, 0.5) },
    [mod.ITEM.FAMILIAR.BURGLAR_BABY] = { tfunc = function (tear, secondhandmult)
		FiendFolio.FlagMug(tear, burgleDuration*secondhandmult)
    end,
    fr = 44 ,
    color = Color(1.1, 1.1, 1.1, 1.0, -5/255, -5/255, -5/255, 1.0, 0.75, 0.45, 1) },
    [mod.ITEM.FAMILIAR.CYBORG_BABY] = { tfunc = function (tear)
		TearFlagsLib.AddTearFlags(tear, TearFlagsLib.Flag.WNIC, true)
    end,
    color = FiendFolio.ColorWNICTear,
    fr = 33 },
}

local animationEnum = {
    [Vector(0, 1)] = "Down",
    [Vector(-1, 0)] = "Side",
    [Vector(0, -1)] = "Up",
    [Vector(1, 0)] = "Side",
}

--despite this looking scary i think this is more efficient in the end compared to one big callback due to the callbacks having a variant arg
--(im not writing seperate callbacks for 5-6 familiars that behave the same)
for type, data in pairs(familiars) do 
    mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function (_, familiar)
        local p = familiar.Player
        local sprite = familiar:GetSprite()
        local f_data = mod:GetEntityData(familiar)
        local direction = mod.DirectionToVector[p:GetFireDirection()]
        local maxFireRate = data.fr or genericFirerate
        if p:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
            maxFireRate = math.floor(maxFireRate/2)
        end

        local m = familiar:GetMultiplier()
        local secondhandmult = p:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND)

        familiar.FireCooldown = math.max(familiar.FireCooldown - 1, 0)
        if direction:Length() ~= 0 and familiar.FireCooldown == 0 then
            familiar.FireCooldown = maxFireRate

            --direction = (direction * 10) + familiar.Velocity
            local t = familiar:FireProjectile(mod.GetFamiliarShootingDirection(familiar))
            t.CollisionDamage = genericDamage*m
            data.tfunc(t, 1+secondhandmult)
            t.Color = data.color

            f_data.lastShootDirection = direction
            local anim = nil local diff = 999
            local flipX = false
            for key, value in pairs(animationEnum) do
                local currentDiff = math.abs(mod:GetAngleDifferenceDead(key, direction))
                if currentDiff < diff then
                    diff = currentDiff
                    anim = value

                    if key.X == -1 then
                        flipX = true
                    else
                        flipX = false
                    end
                end
            end
            f_data.animSuffix = anim
            f_data.flipX = flipX
        elseif familiar.FireCooldown <= 0 then 
            f_data.animSuffix = nil
            f_data.flipX = false
        end

        local isShooting = familiar.FireCooldown > (maxFireRate/2)
        local animPrefix = isShooting and "FloatShoot" or "Float"
        local animSuffix = f_data.animSuffix or "Down"

        local anim = animPrefix..animSuffix
        if sprite:GetAnimation() ~= anim then
            local frame = sprite:GetFrame()
            sprite:Play(animPrefix..animSuffix, true)
            sprite:SetFrame(frame)

            familiar.FlipX = f_data.flipX
        end

        familiar:FollowParent()
    end, type)
    
    mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function (_, familiar)
        familiar:AddToFollowers()
        familiar.Parent = familiar.Parent or familiar.Player
    end, type)
end

function mod:WNICspawnBabyProjectile(familiar,vec)
    local m = familiar:GetMultiplier()
    local t = familiar:FireProjectile(vec:Normalized())
    t.CollisionDamage = genericDamage*m
    t.Color = FiendFolio.ColorWNICTear
    return t
end