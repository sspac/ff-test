local mod = FiendFolio

function mod:CacepiOnFireTear(player, tear)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.CACEPI) then
        tear.FallingSpeed = 10
        tear.FallingAcceleration = 1
        local room = Game():GetRoom()
        local tearBehaviorSmall = {
            update = function(t)
                if t.Height >= -10 then
                    local pos = t.Position
                    local kill
                    for i=1,7 do
                        mod.scheduleForUpdate(function()
                            local newPos = pos+t.Velocity:Resized(14*i)
                            if room:IsPositionInRoom(newPos, 0) and not kill then
                                local pile = Isaac.Spawn(1000, 146, 0, newPos, Vector.Zero, t):ToEffect()
                                pile:Update()
                            else
                                kill = true
                            end
                        end, 3*i)
                    end
                    mod.scheduleForUpdate(function()
                        if not kill then
                            local new = Isaac.Spawn(t.Type, t.Variant, t.SubType, pos+t.Velocity:Resized(14*8), t.Velocity, t):ToTear()
                            new.Scale = t.Scale
                            new.Color = t.Color
                            new.TearFlags = t.TearFlags
                            new.CollisionDamage = t.CollisionDamage
                            new.Height = -5
                            new.FallingAcceleration = -5
                            new.FallingSpeed = -30
                            mod:GetEntityData(new).dontHitAbove = true
                            new:AddTearFlags(TearFlags.TEAR_SPECTRAL)
                            mod.scheduleForUpdate(function()
                                SFXManager():Play(SoundEffect.SOUND_BOSS1_EXPLOSIONS, 0.2, 0, false, 1.1)
                                new:Remove()
                            end, 35)
                        end
                    end, 3*8)

                    t:Remove()
                end
            end
        }
        mod:TryToAddTearBehavior(tear, mod:GetEntityData(tear), tearBehaviorSmall)
    end
end

function mod:CacepiUpdate(player)
    local newCount = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.CACEPI)
    player:SetInnateCollectibleCount(CollectibleType.COLLECTIBLE_IPECAC, newCount, "FF_CACEPI")
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_ADDED, mod.CacepiUpdate, mod.ITEM.COLLECTIBLE.CACEPI)
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.CacepiUpdate, mod.ITEM.COLLECTIBLE.CACEPI)

mod.SewingManualWhitelist[mod.ITEM.COLLECTIBLE.CACEPI] = {
	FireCooldown = 70,
	TearFallingSpeed = 10,
	TearFallingAccel = 1,
	TearVelocity = 8.0,
	TearColor = Color(0.5, 0.9, 0.4, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
	TearFlags = TearFlags.TEAR_EXPLOSIVE | TearFlags.TEAR_POISON,
	BodyColor = Color(1,1,1,1,22.422/255,21.641/255,20.234/255,0.422,0.641,0.234,1),
	EyeAColor = Color(1,1,1,1,22.469/255,69.752/255,-7.584/255,0.708,0.664,0.779,1),
	EyeBColor = Color(1,1,1,1,22.469/255,69.752/255,-7.584/255,0.708,0.664,0.779,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
    tear.CollisionDamage = tear.CollisionDamage + 40
	tear.Scale = tear.Scale * 1.25
	
    local room = Game():GetRoom()
    local tearBehaviorSmall = {
        update = function(t)
            if t.Height >= -10 then
                local pos = t.Position
                local kill
                for i=1,7 do
                    mod.scheduleForUpdate(function()
                        local newPos = pos+t.Velocity:Resized(14*i)
                        if room:IsPositionInRoom(newPos, 0) and not kill then
                            local pile = Isaac.Spawn(1000, 146, 0, newPos, Vector.Zero, t):ToEffect()
                            pile:Update()
                        else
                            kill = true
                        end
                    end, 3*i)
                end
                mod.scheduleForUpdate(function()
                    if not kill then
                        local new = Isaac.Spawn(t.Type, t.Variant, t.SubType, pos+t.Velocity:Resized(14*8), t.Velocity, t):ToTear()
                        new.Scale = t.Scale
                        new.Color = t.Color
                        new.TearFlags = t.TearFlags
                        new.CollisionDamage = t.CollisionDamage
                        new.Height = -5
                        new.FallingAcceleration = -5
                        new.FallingSpeed = -30
                        mod:GetEntityData(new).dontHitAbove = true
                        new:AddTearFlags(TearFlags.TEAR_SPECTRAL)
                        mod.scheduleForUpdate(function()
                            SFXManager():Play(SoundEffect.SOUND_BOSS1_EXPLOSIONS, 0.2, 0, false, 1.1)
                            new:Remove()
                        end, 35)
                    end
                end, 3*8)

                t:Remove()
            end
        end
    }
    mod:TryToAddTearBehavior(tear, mod:GetEntityData(tear), tearBehaviorSmall)
end, FiendFolio.ITEM.COLLECTIBLE.CACEPI)
