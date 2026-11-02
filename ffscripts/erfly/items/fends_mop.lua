local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local mop = Sprite()
mop:Load("gfx/effects/fend_mop.anm2", true)

local function getShootInput(player)
    local shootInput = player:GetAimDirection()
    local lockAngle
    if not player:HasCollectible(CollectibleType.COLLECTIBLE_ANALOG_STICK) then
        if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
            lockAngle = 45
        else
            lockAngle = 90
            if math.abs(shootInput.X) == math.abs(shootInput.Y) then
                shootInput = Vector(0, shootInput.Y):Normalized()
            end
        end
    end
    if lockAngle then
        shootInput = mod:SnapVector(shootInput, lockAngle)
    end

    return shootInput
end

function mod:fendsMopPlayerUpdate(player)
    local data = mod:GetEntityData(player)
    if data.holdingFFItem then return end
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.FENDS_MOP) then
        if not data.FendMop or (data.FendMop and not data.FendMop:Exists()) then
            local mop = Isaac.Spawn(mod.FF.FendMop.ID, mod.FF.FendMop.Var, mod.FF.FendMop.Sub, player.Position, Vector.Zero, player):ToEffect()
            mop.Parent = player
            mop:Update()
            data.FendMop = mop
        end

        local shootInput = getShootInput(player)

        player.FireDelay = math.max(player.MaxFireDelay, 1)
        if shootInput:Length() > 0.1 then
            if data.fendsMopDown then
                data.FFdrawnItemCooldown = player.MaxFireDelay
                data.fendsMopDown = data.fendsMopDown + 1
                if data.fendsMopDown % 3 == 0 then
                    --Important bits
                    local mopRadius = 25
                    local mopPos = player.Position + shootInput:Resized(10 + mopRadius)

                    --Creep
                    local creep = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL, 0, mopPos, Vector.Zero, player):ToEffect()
                    creep.Color = player.TearColor
                    creep.CollisionDamage = player.Damage * 0.1
                    creep:Update()

                    --Pushback
                    for _, entity in ipairs(Isaac.FindInRadius(mopPos, 250, EntityPartition.ENEMY + EntityPartition.PICKUP)) do
                        if entity.Position:Distance(mopPos) < mopRadius + entity.Size then
                            entity:TakeDamage(player.Damage / 3, 0, EntityRef(player), 0)
                            entity.Velocity = mod:Lerp(entity.Velocity, (entity.Position - mopPos) / 5, 0.2)
                        end
                    end
                end
            elseif mod:canUseDrawnItem(player, mod.DrawnItemTypes.FendsMop, shootInput) then
                data.FFdrawnItemCooldown = player.MaxFireDelay
                data.fendsMopDown = 0
                for i = 1, 5 do
                    local dir = shootInput:Resized(player.ShotSpeed * 10 - (i * 1.5))
                    dir = dir + player:GetTearMovementInheritance(shootInput)
                    dir = dir:Rotated(mod:RandomInt(-10,10))
                    local tear = player:FireTear(player.Position, dir, false, true, false, player, 0.1 + i/10):ToTear()
                    tear.FallingAcceleration = tear.FallingAcceleration + 0.5
                    tear.FallingSpeed = tear.FallingSpeed - (i * 3)
                    tear:Update()
                end
            end
        else
            data.fendsMopDown = nil
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.FENDS_MOP, mod.fendsMopPlayerUpdate)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, mop)
    local sprite = mop:GetSprite()
    local p = mop.Parent
    mop.SpriteOffset = Vector(0, -5)
    if p then
        local player = p:ToPlayer()
        if player:HasCollectible(mod.ITEM.COLLECTIBLE.FENDS_MOP) then
            --Position
            local shootInput = getShootInput(player)
            if shootInput:Length() < 0.1 then
                shootInput = Vector(0,1)
            end
            sprite.Rotation = shootInput:GetAngleDegrees()
            local targPos = p.Position + shootInput:Resized(10)
            mop.Velocity = mod:Lerp(mop.Velocity, (targPos - mop.Position), 0.5)
            --Animation
            data = mod:GetEntityData(player)
            if data.fendsMopDown then
                if data.fendsMopDown > 7 then
                    sprite:SetFrame("Down", data.fendsMopDown % 7)
                else
                    sprite:SetFrame("Swing", data.fendsMopDown)
                end
            else
                sprite:SetFrame("Idle", 0)
            end
        else
            mop:Remove()
        end
    else
        mop:Remove()
    end
end, mod.FF.FendMop.Var)