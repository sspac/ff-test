local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    ChargeTime = {42, 55},
    VelocityThresh = 1.5,
    VelBase = 8,
    VelScale = 8,
    VelDecay = 0.995,
    Tolerance = 2, --How many frames you have to hold movement to cancel the charge
    LifetimeBase = 12,
    LifetimeScale = 14,
    FinishAccel = 0.1,
    FinishSpeed = 0.15,
    FinishCutoff = 1.5,
    NormalColl = 0.15,
    CollCooldownDecay = 4,
    SafetyFrames = 17,

    ContactMult = {1, 1.5},
    ContactScale = {1.5, 4.8},
    ContactFlat = {2, 5},
    ContactCooldown = 2, --How much needs to pass for the SAME enemy to take damage

    LowCutoff = 0.25,
    LowColl = 0.75,

    ImpactCooldown = 8,
    ImpactScale = {1.3, 2.65},
    ImpactTimeout = 100,
    ImpactSplatter = {3,4,6},
    ImpactThresh = {0.33, 0.66},
    ImpactMult = 0.3,
    ImpactFlat = 1,
    SplatterMult = 2,
    SplatterSpeed = {35,65},
    SplatterFall = {10,26},
    SplatterAccel = 1.2,

    TrailScale = {85,100},
    TrailDamageMult = 0.15,
    TrailDamageFlat = 1,
    TrailTimeout = 40, --Add the lifetime of the charge to this
}

function mod:ClownMeatSafety(player, d)
    if d.ClownMeatSafety then
        if d.ClownMeatSafety % 3 == 0 then
            player:SetColor(Color(1, 1, 1, 0.2, 0.1, 0.1, 0.1), 1, 1, false, false)
        end
        if d.ClownMeatSafety > 0 then
            d.ClownMeatSafety = d.ClownMeatSafety-1
        else
            d.ClownMeatSafety = nil
        end
    end
end

function mod:ClownMeatUpdate(player)
    local d = mod:GetEntityData(player)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.CLOWN_MEAT) and not mod:IsBriendTwin(player) then
        local num = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.CLOWN_MEAT)
        local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.CLOWN_MEAT)
        d.CustomChargeBarExtra = d.CustomChargeBarExtra or {}
		if not d.CustomChargeBarExtra[mod.ITEM.COLLECTIBLE.CLOWN_MEAT] then
			d.CustomChargeBarExtra[mod.ITEM.COLLECTIBLE.CLOWN_MEAT] = {id = mod.ITEM.COLLECTIBLE.CLOWN_MEAT, Priority = 1, anm2 = "gfx/ui/chargebars/chargebar_clown_meat.anm2",
            maxTime = bal.ChargeTime, special = true, layeredCharges = 2, ignoreMarked = true, renderCondition = function(p, da)
                return (da.LastInputtedMovement and (game:GetFrameCount()-da.LastInputtedMovement[1]) < 2 and not da.ClownMeatActive)
            end}
			mod:EvaluateExtraChargeBar(player)
		end

        if d.ClownMeatFired then
            sfx:Play(SoundEffect.SOUND_DEATH_REVERSE, 1, 0, false, mod:RandomInt(180,220,rng)/100)
            sfx:Play(SoundEffect.SOUND_DEATH_BURST_LARGE, 0.35, 0, false, mod:RandomInt(120,130,rng)/100)
            local poof = Isaac.Spawn(1000, 16, 4, player.Position, Vector.Zero, player):ToEffect()
            player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/clownmeatball.anm2"))

            local speed = bal.VelBase+d.ClownMeatFired*bal.VelScale
            if player.Velocity:Length() > bal.VelocityThresh then
                d.ClownMeatDir = player.Velocity:Resized(speed)
            else
                local dir = mod.GetCorrectedFiringInput(player)
                if dir:Length() > 0 then
                    --[[local lockAngle
                    if not player:HasCollectible(CollectibleType.COLLECTIBLE_ANALOG_STICK) then
                        if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) and 1 == 0 then
                            lockAngle = 45
                        else
                            lockAngle = 90
                        end
                    end
                    if lockAngle then
                        dir = mod:SnapVector(dir, lockAngle)
                    end]]
                else
                    dir = Vector(-1,0):Rotated(player:GetHeadDirection()*90)
                end
                d.ClownMeatDir = Vector(dir.X, dir.Y):Resized(speed)
            end
            d.ClownMeatPreviousMass = player.Mass
            player.Mass = 999
            d.ClownMeatFirstSpeed = speed
            d.ClownMeatSpeed = speed
            d.ClownMeatActive = true
            d.ClownMeatPrevColl = 0
            d.ClownMeatLifetime = bal.LifetimeBase+d.ClownMeatFired*bal.LifetimeScale
            d.ClownMeatFrameCount = 0
            d.ClownMeatPrevCreep = 0
            d.ClownMeatTolerance = 0
            d.ClownMeatDecelSpeed = bal.FinishSpeed
            d.ClownMeatDecaying = nil
            d.ClownMeatSmall = d.ClownMeatFired <= bal.LowCutoff
            d.ClownMeatFired = nil
        end

        if d.ClownMeatActive then
            local room = game:GetRoom()
            player.Velocity = d.ClownMeatDir:Resized(d.ClownMeatSpeed)

            if math.abs(player.Velocity.X) > math.abs(player.Velocity.Y) then
                if player.Velocity.X > 0 then
                    player:SetHeadDirection(Direction.RIGHT, 1, true)
                else
                    player:SetHeadDirection(Direction.LEFT, 1, true)
                end
            else
                if player.Velocity.Y > 0 then
                    player:SetHeadDirection(Direction.DOWN, 1, true)
                else
                    player:SetHeadDirection(Direction.UP, 1, true)
                end
            end

            if player.Velocity:Length() > 8 then
                local creep = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_RED, 0, player.Position, Vector.Zero, player):ToEffect()
                local scale = mod:RandomInt(bal.TrailScale[1],bal.TrailScale[2],rng)/100
                creep.SpriteScale = Vector(scale, scale)
                creep:SetTimeout(math.floor(bal.TrailTimeout+math.max(0, d.ClownMeatLifetime-d.ClownMeatFrameCount)))
                creep.CollisionDamage = player.Damage*bal.TrailDamageMult*num+bal.TrailDamageFlat
                creep:Update()
                local ripple = Isaac.Spawn(1000, EffectVariant.TEAR_POOF_A, 10, player.Position, Vector.Zero, player):ToEffect()
                ripple.Color = Color(0.75, 0.05, 0.05, 1, 0.1, 0, 0)
                ripple:Update()
            else
                if player.FrameCount % 2 == 0 then
                    local creep = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_RED, 0, player.Position, Vector.Zero, player):ToEffect()
                    local scale = (mod:RandomInt(bal.TrailScale[1],bal.TrailScale[2],rng)/100)
                    creep.SpriteScale = Vector(scale, scale)
                    creep.Scale = d.ClownMeatSpeed/d.ClownMeatFirstSpeed
                    creep:SetTimeout(math.floor(bal.TrailTimeout+math.max(0, d.ClownMeatLifetime-d.ClownMeatFrameCount)))
                    creep.CollisionDamage = player.Damage*bal.TrailDamageMult*num+bal.TrailDamageFlat
                    creep:Update()
                    local ripple = Isaac.Spawn(1000, EffectVariant.TEAR_POOF_A, 10, player.Position, Vector.Zero, player):ToEffect()
                    ripple.Color = Color(0.75, 0.05, 0.05, 1, 0.1, 0, 0)
                    ripple:Update()
                end
            end
            if player.FrameCount % 3 == 0 then
                local vel = player.Velocity:Rotated(180+mod:RandomInt(-90,90,rng)):Resized(mod:RandomInt(20,50,rng)/10)
                local drop = Isaac.Spawn(1000, EffectVariant.WATER_SPLASH, 1, player.Position, vel, player):ToEffect()
                drop.FallingSpeed = -mod:RandomInt(60,120,rng)/10
                drop.m_Height = -10
                drop.Color = Color(0.66, 0.05, 0.05, 1, 0.1, 0, 0)
                drop:Update()
            end

            if player.FrameCount % 2 == 0 then
                local scale = d.ClownMeatSpeed/d.ClownMeatFirstSpeed
                local splat = Isaac.Spawn(1000, 7, 0, player.Position, Vector.Zero, player):ToEffect()
                splat.SpriteScale = Vector(scale, scale)
                splat:Update()
            end

            if player:CollidesWithGrid() and (player.FrameCount-d.ClownMeatPrevColl) > 1 then
                local align
                local isBroke
                for i=-1,1,2 do
                    if not isBroke then
                        for j=0,player.Size do
                            local pos = player.Position+player.Velocity:Rotated(90):Resized((player.Size+2)*i)+player.Velocity:Resized(j)
                            local gridColl = room:GetGridCollisionAtPos(pos)
                            if mod:WouldEntCollideWithClass(player, gridColl) then
                                local gridEnt = room:GetGridEntityFromPos(pos)
                                if gridEnt and (gridEnt:ToPoop() or gridEnt:ToTNT()) then
                                    gridEnt:Destroy()
                                end
                                isBroke = true
                                local dist = pos-(room:GetGridPosition(room:GetGridIndex(pos)))
                                if math.abs(dist.X) > math.abs(dist.Y) then
                                    align = "X"
                                else
                                    align = "Y"
                                end
                                break
                            end
                        end
                    else
                        break
                    end
                end
                local pos = player.Position+player.Velocity:Resized(player.Size+2)
                local gridEnt = room:GetGridEntityFromPos(pos)
                if gridEnt and (gridEnt:ToPoop() or gridEnt:ToTNT()) then
                    gridEnt:Destroy()
                end
                if align then
                    if align == "X" then
                        d.ClownMeatDir = Vector(d.ClownMeatDir.X*-1, d.ClownMeatDir.Y)
                    else
                        d.ClownMeatDir = Vector(d.ClownMeatDir.X, d.ClownMeatDir.Y*-1)
                    end
                else --Failsafe
                    if math.abs(d.ClownMeatDir.X) > math.abs(d.ClownMeatDir.Y) then
                        d.ClownMeatDir = Vector(d.ClownMeatDir.X*-1, d.ClownMeatDir.Y)
                    else
                        d.ClownMeatDir = Vector(d.ClownMeatDir.X, d.ClownMeatDir.Y*-1)
                    end
                end

                if player.FrameCount-d.ClownMeatPrevColl >= bal.CollCooldownDecay then
                    if d.ClownMeatSmall then
                        d.ClownMeatFrameCount = d.ClownMeatFrameCount+d.ClownMeatLifetime*bal.LowColl
                    else
                        d.ClownMeatFrameCount = d.ClownMeatFrameCount+d.ClownMeatLifetime*bal.NormalColl
                    end
                end

                if player.FrameCount-d.ClownMeatPrevCreep >= bal.ImpactCooldown then
                    local creep = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_RED, 0, player.Position, Vector.Zero, player):ToEffect()
                    local scale = d.ClownMeatSpeed/(bal.VelBase+bal.VelScale)
                    local newScale = bal.ImpactScale[1]+(bal.ImpactScale[2]-bal.ImpactScale[1])*scale
                    creep.SpriteScale = Vector(newScale, newScale)
                    creep:SetTimeout(bal.ImpactTimeout)
                    creep.CollisionDamage = player.Damage*bal.ImpactMult+bal.ImpactFlat
                    creep:Update()
                    
                    local numS = bal.ImpactSplatter[1]
                    if scale > bal.ImpactThresh[2] then
                        numS = bal.ImpactSplatter[3]
                        sfx:Play(SoundEffect.SOUND_DEATH_BURST_LARGE, 0.66, 0, false, mod:RandomInt(105,115,rng)/100)
                        local poof = Isaac.Spawn(1000, 16, 4, player.Position, Vector.Zero, player):ToEffect()
                    elseif scale > bal.ImpactThresh[1] then
                        numS = bal.ImpactSplatter[2]
                        sfx:Play(SoundEffect.SOUND_DEATH_BURST_LARGE, 0.35, 0, false, mod:RandomInt(120,130,rng)/100)
                        local poof = Isaac.Spawn(1000, 16, 4, player.Position, Vector.Zero, player):ToEffect()
                        poof.SpriteScale = Vector(0.5, 0.5)
                        poof:Update()
                    else
                        sfx:Play(SoundEffect.SOUND_DEATH_BURST_LARGE, 0.15, 0, false, mod:RandomInt(140,150,rng)/100)
                        Isaac.Spawn(1000, 2, 114, player.Position, Vector.Zero, player)
                    end

                    for i=1,numS do
                        local tear
                        local vel = Vector(mod:RandomInt(bal.SplatterSpeed[1], bal.SplatterSpeed[2], rng)/10, 0):Rotated(rng:RandomInt(360))
                        if i % 4 == 0 or rng:RandomInt(3) == 0 then
                            tear = Isaac.Spawn(2, TearVariant.BONE, 0, player.Position, vel, player):ToTear()
                        else
                            tear = Isaac.Spawn(2, TearVariant.BLOOD, 0, player.Position, vel, player):ToTear()
                        end
                        tear.FallingAcceleration = bal.SplatterAccel
                        tear.FallingSpeed = -mod:RandomInt(bal.SplatterFall[1], bal.SplatterFall[2], rng)
                        tear.CollisionDamage = player.Damage*bal.SplatterMult*num
                    end

                    d.ClownMeatPrevCreep = player.FrameCount
                end

                d.ClownMeatPrevColl = player.FrameCount
            end

            if d.ClownMeatFrameCount > 2 and d.LastInputtedMovement and (game:GetFrameCount()-d.LastInputtedMovement[1]) < 2 then
                d.ClownMeatTolerance = d.ClownMeatTolerance+1
                if d.ClownMeatTolerance > bal.Tolerance or d.ClownMeatSmall then
                    d.ClownMeatActive = nil
                    player.Mass = d.ClownMeatPreviousMass
                    d.ClownMeatSafety = bal.SafetyFrames
                    player:TryRemoveNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/clownmeatball.anm2"))
                end
            else
                d.ClownMeatTolerance = 0
            end

            if not d.ClownMeatDecaying and d.ClownMeatFrameCount > d.ClownMeatLifetime then
                d.ClownMeatDecaying = true
            elseif d.ClownMeatDecaying then
                d.ClownMeatSpeed = math.max(0, d.ClownMeatSpeed-d.ClownMeatDecelSpeed)
                d.ClownMeatDecelSpeed = d.ClownMeatDecelSpeed+bal.FinishAccel

                if d.ClownMeatSpeed < bal.FinishCutoff then
                    d.ClownMeatActive = nil
                    player.Mass = d.ClownMeatPreviousMass
                    d.ClownMeatSafety = bal.SafetyFrames
                    player:TryRemoveNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/clownmeatball.anm2"))
                end
            else
                d.ClownMeatSpeed = d.ClownMeatSpeed*bal.VelDecay
                d.ClownMeatFrameCount = d.ClownMeatFrameCount+1
            end
        end
    else
        if d.CustomChargeBarExtra and d.CustomChargeBarExtra[mod.ITEM.COLLECTIBLE.CLOWN_MEAT] then
            d.CustomChargeBarExtra[mod.ITEM.COLLECTIBLE.CLOWN_MEAT] = nil
            mod:EvaluateExtraChargeBar(player)
        end
        if d.ClownMeatActive then
            d.ClownMeatActive = nil
            player.Mass = d.ClownMeatPreviousMass
            d.ClownMeatSafety = bal.SafetyFrames
            player:TryRemoveNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/clownmeatball.anm2"))
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.CLOWN_MEAT, mod.ClownMeatUpdate)

mod:AddCallback("FF_EXTRA_CHARGE_CIRCLE_FIRED", function(_, player, entry, d)
    if entry.charged then
        if entry.charged == 2 and entry.timer == 0 then
            entry.timer = bal.ChargeTime[2]
        end
        d.ClownMeatFired = (bal.ChargeTime[2]-entry.timer)/bal.ChargeTime[2]
    end
end, mod.ITEM.COLLECTIBLE.CLOWN_MEAT)

local moveButtons = {ButtonAction.ACTION_LEFT, ButtonAction.ACTION_RIGHT, ButtonAction.ACTION_UP, ButtonAction.ACTION_DOWN}
function mod:PlayerMovementChecking(player)
    local d = mod:GetEntityData(player)
    for _,button in ipairs(moveButtons) do
        if Input.IsActionPressed(button, player.ControllerIndex) then
            if not d.LastInputtedMovement then
                d.LastInputtedMovement = {game:GetFrameCount(), {button}}
            elseif d.LastInputtedMovement[1] == game:GetFrameCount() then
                table.insert(d.LastInputtedMovement[2], button)
            else
                d.LastInputtedMovement = {game:GetFrameCount(), {button}}
            end
        end
    end
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.CLOWN_MEAT) and d.CustomChargeBarExtra and d.CustomChargeBarExtra[mod.ITEM.COLLECTIBLE.CLOWN_MEAT] then
        if Input.IsActionPressed(ButtonAction.ACTION_DROP, player.ControllerIndex) then
            local entry = d.CustomChargeBarExtra[mod.ITEM.COLLECTIBLE.CLOWN_MEAT]
            if entry.timer then
                entry.timer = bal.ChargeTime[1]
                entry.charged = nil
                entry.chargeLayer = 1
            end
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.ITEM.COLLECTIBLE.CLOWN_MEAT, mod.PlayerMovementChecking)

function mod:ClownMeatNewRoom(player, d)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.CLOWN_MEAT) then
        player.Mass = d.ClownMeatPreviousMass or 5
        d.ClownMeatActive = nil
    end
end
--mod:AddCollectibleCallback("FF_NEW_ROOM_PLAYER_FERRIUM", mod.ITEM.COLLECTIBLE.CLOWN_MEAT, mod.ClownMeatNewRoom)

function mod:ClownMeatNewLevel(player, d)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.CLOWN_MEAT) then
        player.Mass = d.ClownMeatPreviousMass or 5
        d.ClownMeatActive = nil
    end
end
mod:AddCollectibleCallback("FF_NEW_LEVEL_PLAYER_FERRIUM", mod.ITEM.COLLECTIBLE.CLOWN_MEAT, mod.ClownMeatNewLevel)

function mod:ClownMeatHurt(player, flag, source)
    if (mod:GetEntityData(player).ClownMeatActive or mod:GetEntityData(player).ClownMeatSafety) and not mod:isDamageSelfInflicted(flag, source, true) then
        mod:StopFFPlayerSoundsIGuess(player)
        return false
    end
end

function mod:ClownMeatCollision(player, coll)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.CLOWN_MEAT) and mod:GetEntityData(player).ClownMeatActive and coll and coll.Type == EntityType.ENTITY_SLOT then
        return true
    elseif player:HasCollectible(mod.ITEM.COLLECTIBLE.CLOWN_MEAT) and mod:GetEntityData(player).ClownMeatActive and coll and coll:ToNPC() then
        local d = mod:GetEntityData(coll)
        coll = coll:ToNPC()
        if not mod:isFriend(coll) and (not d.ClownMeatCollCooldown or (coll.FrameCount-d.ClownMeatCollCooldown) > bal.ContactCooldown) then
            local num = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.CLOWN_MEAT)
            local pd = mod:GetEntityData(player)
            local scale = pd.ClownMeatSpeed/pd.ClownMeatFirstSpeed
            local mult = bal.ContactMult[1]+(bal.ContactMult[2]-bal.ContactMult[1])*scale
            local scaling = bal.ContactScale[1]+(bal.ContactScale[2]-bal.ContactScale[1])*scale
            local flat = bal.ContactFlat[1]+(bal.ContactFlat[2]-bal.ContactFlat[1])*scale
            local level = math.ceil(game:GetLevel():GetAbsoluteStage()/2)
            local damage = player.Damage*mult*num+scaling*level+flat

			coll:TakeDamage(damage, 0, EntityRef(player), 0)
            d.ClownMeatCollCooldown = coll.FrameCount
		end

        if coll:IsVulnerableEnemy() then
            return true
        end
    end
end

mod:AddCallback("FF_CURSE_MIST_ADDED", function(_, player, d)
    d.ClownMeatFired = nil
    d.ClownMeatActive = nil
    if d.ClownMeatPreviousMass then
        player.Mass = d.ClownMeatPreviousMass
    end
    player:TryRemoveNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/clownmeatball.anm2"))
end)