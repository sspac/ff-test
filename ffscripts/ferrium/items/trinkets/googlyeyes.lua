local mod = FiendFolio

local bal = {
    XOff = 10,
    YOff = -31,
    YRand = 3,

    FireRate = 24,
    ShotSpeed = 10,
    TearDamage = 3.5
}

function mod:IsGooglyEyeCompatible(itemConfig, fam)
    if mod.GooglyEyesWhitelist[fam.Variant] or mod.GooglyEyesWhitelist[fam.Variant .. " " .. fam.SubType] then
        return true
    elseif mod.GooglyEyesWhitelist[fam.Variant] == false or mod.GooglyEyesWhitelist[fam.Variant .. " " .. fam.SubType] == false then
    elseif itemConfig and not itemConfig:IsTrinket() and itemConfig.Tags & ItemConfig.TAG_OFFENSIVE == 0 then
        return true
    end
end

function mod:GooglyEyesFamiliarInit(fam)
    mod.scheduleForUpdate(function()
        local itemConfig = fam:GetItemConfig()
        if mod:IsGooglyEyeCompatible(itemConfig, fam) then
            local d = mod:GetEntityData(fam)
            local player = fam.Player
            local rng = fam:GetDropRNG()
            d.GooglyEyesTab = {}
            local overrule
            local positions = {Vector(0, bal.YOff), bal.XOff}
            if mod.GooglyEyesWhitelist[fam.Variant] then
                overrule = mod.GooglyEyesWhitelist[fam.Variant]
            elseif mod.GooglyEyesWhitelist[fam.Variant .. " " .. fam.SubType] then
                overrule = mod.GooglyEyesWhitelist[fam.Variant .. " " .. fam.SubType]
            end
            if type(overrule) == "table" then
               if overrule[1] then
                    positions[1] = overrule[1]
               end
               if overrule[2] then
                    positions[2] = overrule[2]
               end
            end

            for i=1,2 do
                local xOff = -positions[2]+(2*positions[2]*(2-i))+positions[1].X
                local yOff = positions[1].Y+mod:RandomInt(-bal.YRand, bal.YRand, rng)
                local size = (rng:RandomInt(2) == 0 and "Big") or "Small"
                local eye = Isaac.Spawn(mod.FF.GooglyEyesEffect.ID, mod.FF.GooglyEyesEffect.Var, mod.FF.GooglyEyesEffect.Sub, fam.Position, fam.Velocity, player):ToEffect()
                eye:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                eye.DepthOffset = fam.DepthOffset+1
                eye.PositionOffset = Vector(xOff, yOff)
                local ed = mod:GetEntityData(eye)
                ed.EyeSize = size
                eye.Parent = fam
                ed.PlayerSpawner = player
                eye:GetSprite():Play(size .. "D", true)

                table.insert(d.GooglyEyesTab, eye)
            end
        end
    end, 0)
end
mod:AddTrinketCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.ITEM.TRINKET.GOOGLY_EYES, mod.GooglyEyesFamiliarInit)

function mod:GooglyEyesAdd(player, id, firstTime)
    local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.GOOGLY_EYES)
    for _,fam1 in ipairs(Isaac.FindByType(3, -1, -1, false, false)) do
        local fam = fam1:ToFamiliar()
        if fam.Player and GetPtrHash(player) == GetPtrHash(fam.Player) then
            local itemConfig = fam:GetItemConfig()
            if mod:IsGooglyEyeCompatible(itemConfig, fam) then
                local d = mod:GetEntityData(fam)
                d.GooglyEyesTab = {}
                local overrule
                local positions = {Vector(0, bal.YOff), bal.XOff}
                if mod.GooglyEyesWhitelist[fam.Variant] then
                    overrule = mod.GooglyEyesWhitelist[fam.Variant]
                elseif mod.GooglyEyesWhitelist[fam.Variant .. " " .. fam.SubType] then
                    overrule = mod.GooglyEyesWhitelist[fam.Variant .. " " .. fam.SubType]
                end
                if type(overrule) == "table" then
                if overrule[1] then
                        positions[1] = overrule[1]
                end
                if overrule[2] then
                        positions[2] = overrule[2]
                end
                end

                for i=1,2 do
                    local xOff = -positions[2]+(2*positions[2]*(2-i))+positions[1].X
                    local yOff = positions[1].Y+mod:RandomInt(-bal.YRand, bal.YRand, rng)
                    local size = (rng:RandomInt(2) == 0 and "Big") or "Small"
                    local eye = Isaac.Spawn(mod.FF.GooglyEyesEffect.ID, mod.FF.GooglyEyesEffect.Var, mod.FF.GooglyEyesEffect.Sub, fam.Position, fam.Velocity, player):ToEffect()
                    eye:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    eye.DepthOffset = fam.DepthOffset+1
                    eye.PositionOffset = Vector(xOff, yOff)
                    local ed = mod:GetEntityData(eye)
                    ed.EyeSize = size
                    eye.Parent = fam
                    ed.PlayerSpawner = player
                    eye:GetSprite():Play(size .. "D", true)

                    table.insert(d.GooglyEyesTab, eye)
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, mod.GooglyEyesAdd, mod.ITEM.TRINKET.GOOGLY_EYES)
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, mod.GooglyEyesAdd, mod.ITEM.TRINKET.GOOGLY_EYES + TrinketType.TRINKET_GOLDEN_FLAG)

local directionToLetter = {
    [Direction.LEFT] = "L",
    [Direction.UP] = "U",
    [Direction.RIGHT] = "R",
    [Direction.DOWN] = "D",
}

--idc I'm taking it from sibling syl
function mod:GooglyEyesFamiliarUpdate(fam)
    local d = mod:GetEntityData(fam)

    if d.GooglyEyesTab then
        local player = fam.Player
        local isSuperpositioned = mod:isSuperpositionedPlayer(fam.Player)
        local isSirenCharmed = mod:isSirenCharmed(fam)
        local rng = fam:GetDropRNG()

        if not d.GooglyEyesInit then
            d.GooglyEyesInit = true
            d.GooglyEyesLastDirection = Direction.DOWN
            d.GooglyEyesFireCooldown = 0
            d.GooglyEyesSpriteDirection = "D"
        end

        d.GooglyEyesFireCooldown = (d.GooglyEyesFireCooldown or 0) - ((player and player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) and 2) or 1)

        local direction = player:GetFireDirection()
        d.GooglyEyesLastDirection = (direction ~= Direction.NO_DIRECTION and direction) or d.GooglyEyesLastDirection
        if d.GooglyEyesFireCooldown <= 0 and mod.IsPlayerTryingToShoot(player) and fam.Visible then
            d.GooglyEyesFireCooldown = bal.FireRate

            local velocity = mod.GetFamiliarShootingDirection(fam):Resized(bal.ShotSpeed)
            velocity = velocity + player:GetTearMovementInheritance(velocity)

            if isSirenCharmed then
                local proj = Isaac.Spawn(9, 0, 0, fam.Position, velocity, fam):ToProjectile()
            else
                local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, fam.Position, velocity, fam):ToTear()
                tear.Height = -23
                tear.FallingSpeed = 0.1 + (rng:RandomFloat() * 2 - 1) * 0.1
                tear.FallingAcceleration = 0
                local mult = fam:GetMultiplier() + player:GetTrinketMultiplier(mod.ITEM.TRINKET.GOOGLY_EYES) - 1
                tear.CollisionDamage = bal.TearDamage * mult
                tear.Scale = 0.6 + 0.2 * math.max(1, mult)
                tear:ResetSpriteScale()
                if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
                    tear:AddTearFlags(TearFlags.TEAR_HOMING)
                    local tearcolor = Color(0.4, 0.15, 0.38, 1, 55/255, 5/255, 95/255)
                    tear.Color = tearcolor
                end
                if isSuperpositioned then
                    local tearcolor = Color.Lerp(tear.Color, Color(1,1,1,1,0,0,0), 0)
                    tearcolor.A = tearcolor.A / 4
                    tear.Color = tearcolor
                    tear.CollisionDamage = tear.CollisionDamage/4
                end
            end
        end

        local animating
        if directionToLetter[d.GooglyEyesLastDirection] and d.GooglyEyesSpriteDirection ~= directionToLetter[d.GooglyEyesLastDirection] then
            animating = d.GooglyEyesSpriteDirection .. directionToLetter[d.GooglyEyesLastDirection]
            d.GooglyEyesSpriteDirection = directionToLetter[d.GooglyEyesLastDirection]
        end
        for i,eye in pairs(d.GooglyEyesTab) do
            if not eye:Exists() then
                local overrule
                local positions = {Vector(0, bal.YOff), bal.XOff}
                if mod.GooglyEyesWhitelist[fam.Variant] then
                    overrule = mod.GooglyEyesWhitelist[fam.Variant]
                elseif mod.GooglyEyesWhitelist[fam.Variant .. " " .. fam.SubType] then
                    overrule = mod.GooglyEyesWhitelist[fam.Variant .. " " .. fam.SubType]
                end
                if type(overrule) == "table" then
                    if overrule[1] then
                        positions[1] = overrule[1]
                    end
                    if overrule[2] then
                        positions[2] = overrule[2]
                    end
                end
                local xOff = -positions[2]+(2*positions[2]*(2-i))+positions[1].X
                local yOff = positions[1].Y+mod:RandomInt(-bal.YRand, bal.YRand, rng)

                local size = (rng:RandomInt(2) == 0 and "Big") or "Small"
                local new = Isaac.Spawn(mod.FF.GooglyEyesEffect.ID, mod.FF.GooglyEyesEffect.Var, mod.FF.GooglyEyesEffect.Sub, fam.Position, fam.Velocity, player):ToEffect()
                new:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                new.DepthOffset = fam.DepthOffset+1
                new.PositionOffset = Vector(xOff, yOff)
                local ed = mod:GetEntityData(new)
                ed.EyeSize = size
                new.Parent = fam
                ed.PlayerSpawner = player
                new:GetSprite():Play(size .. "D", true)

                d.GooglyEyesTab[i] = new
            end
            eye.Visible = fam.Visible

            local size = mod:GetEntityData(eye).EyeSize or "Big"
            local sprite = eye:GetSprite()

            if animating then
                mod:SpritePlay(sprite, size .. animating)
            end
        end
    end
end
mod:AddTrinketCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.ITEM.TRINKET.GOOGLY_EYES, mod.GooglyEyesFamiliarUpdate)

function mod:GooglyEyesEffect(e)
    if mod:superExists(e.Parent) then
        local par = e.Parent
        mod:updateToNPCPosition(par, e, nil, true)
        local ed = mod:GetEntityData(e)
        if not ed.PlayerSpawner or not ed.PlayerSpawner:HasTrinket(mod.ITEM.TRINKET.GOOGLY_EYES) then
            e:Remove()
            local pd = mod:GetEntityData(par)
            pd.GooglyEyesTab = nil
        end
    else
        e:Remove()
    end
end