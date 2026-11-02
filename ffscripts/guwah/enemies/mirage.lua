local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    moveSpeed = 4,
    moveLerp = 0.3,
    avoidRadius = 160,
    closetAvoidRadius = 80,
    amonSpawnAvoidRadius = 240,
    slowFactor = 0.5,
    cloneAmount = 3,
    maxCloneAlpha = 0.3,
    alphaCollThreshold = 0.1,
    poofInterval = 0.35,
    swapTime = {60,150},
    waitTime = {10,20},
    fadeDistance = 200,
}

function mod:IsCloset(includeBig)
    local roomshape = game:GetRoom():GetRoomShape()
    return (roomshape == RoomShape.ROOMSHAPE_IH or roomshape == RoomShape.ROOMSHAPE_IV or (includeBig and (roomshape == RoomShape.ROOMSHAPE_IIH or roomshape == RoomShape.ROOMSHAPE_IIV)))
end

local function GatherClones(npc)
    local clones = {}
    for _, clone in pairs (Isaac.FindByType(mod.FF.MirageClone.ID, mod.FF.MirageClone.Var, mod.FF.MirageClone.Sub)) do
        if clone.Parent and clone.Parent.InitSeed == npc.InitSeed then
            table.insert(clones, clone)
        end
    end
    return clones
end

local function MakeClones(npc, setPos)
    local avoidRadius = mod:IsCloset() and bal.closetAvoidRadius or bal.avoidRadius
    if npc:GetData().AmonSpawned and not npc:GetData().AmonInit then
        avoidRadius = bal.amonSpawnAvoidRadius
        npc:GetData().AmonInit = true
    end
    for i = 1, bal.cloneAmount do
        local spawnpos = mod:FindSafeSpawnSpot(npc.Position, nil, nil, false, avoidRadius, true)
        if spawnpos then
            local clone = Isaac.Spawn(mod.FF.MirageClone.ID, mod.FF.MirageClone.Var, mod.FF.MirageClone.Sub, spawnpos, Vector.Zero, npc):ToNPC()
            clone.Parent = npc
            if npc:IsChampion() then
                clone:MakeChampion(69, npc:GetChampionColorIdx(), true)
            end
            clone:Update()
        end
    end
    if setPos then
        npc.Position = mod:FindSafeSpawnSpot(npc.Position, nil, nil, true, avoidRadius, true)
    end
end

function mod:MirageInit(npc)
    mod:SetAlpha(npc:GetSprite(), 0)
end

function mod:MirageAI(npc, sprite, data)
    local targetpos = mod:confusePos(npc, npc:GetPlayerTarget().Position)
    local rng = npc:GetDropRNG()

    if not data.Init then
        if npc.SubType == 1 then
            mod:makeWaitFerr(npc, npc.Type, npc.Variant, 0, 40, false)
        else
            npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_HIDE_HP_BAR)
            npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            npc.SplatColor = FiendFolio.ColorAshGibs
            data.HasCollision = false
            if npc.SubType == mod.FF.MirageClone.Sub then
                npc.CollisionDamage = 0
                data.State = "Appear"
            else
                data.BaseDamamgeBuffer = npc.MaxHitPoints * bal.poofInterval
                data.DamageBuffer = data.BaseDamamgeBuffer
            end
            data.Init = true
        end
    elseif not data.SecondInit and npc.FrameCount > 1 then --For BR purely zzz
        if npc.SubType ~= mod.FF.MirageClone.Sub then
            MakeClones(npc)
            data.State = "Appear"
        end
        data.SecondInit = true
    end

    if data.State == "Idle" then
        mod:AnimWalkFrame(npc, sprite, "WalkHori", "WalkVert", true)
        if data.Chasing then
            mod:ChasePlayer(npc, bal.moveSpeed, targetpos)
        else
            mod:WanderAbout(npc, data, bal.moveSpeed, 1, bal.avoidRadius, bal.moveLerp)
        end

        npc.StateFrame = npc.StateFrame - 1
        if npc.StateFrame <= 0 then
            data.Chasing = not data.Chasing
            npc.StateFrame = mod:RandomInt(bal.swapTime, rng)
        end

        if npc.SubType == mod.FF.MirageClone.Sub and mod:IsReallyDead(npc.Parent) then
            data.State = "Poof"
        end
    
    else
        npc.Velocity = npc.Velocity * bal.slowFactor
        if data.State == "Poof" then
            if sprite:IsFinished("Poof") then
                if npc.SubType == mod.FF.MirageClone.Sub then
                    npc:Remove()
                else
                    npc.StateFrame = npc.StateFrame - 1
                    if npc.StateFrame <= 0 then  
                        data.State = "Appear"
                        if npc.SubType ~= mod.FF.MirageClone.Sub then
                            MakeClones(npc, true)
                        end
                    else
                        npc.Visible = false
                        npc.Velocity = Vector.Zero
                    end
                end
            elseif sprite:IsEventTriggered("Poof") then
                data.HasCollision = false
                npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_HIDE_HP_BAR)
                mod:PlaySound(SoundEffect.SOUND_BLACK_POOF, npc, mod:RandomInt(80,120,rng)*0.01, 0.8)
                npc.StateFrame = mod:RandomInt(bal.waitTime, rng)
            else
                mod:spritePlay(sprite, "Poof")
            end

        elseif data.State == "Appear" then
            npc.Visible = true
            if sprite:IsFinished("Appear") then
                data.State = "Idle"
                data.Chasing = true
                npc.StateFrame = mod:RandomInt(bal.swapTime, rng)
            elseif sprite:IsEventTriggered("Poof") then
                data.HasCollision = true
                npc:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_HIDE_HP_BAR)
            else
                mod:spritePlay(sprite, "Appear")
            end
        end
    end
end

function mod:MirageRender(npc, sprite, data)
    local alpha = (math.max(0, (bal.fadeDistance - npc:GetPlayerTarget().Position:Distance(npc.Position))/bal.fadeDistance))
    if npc.SubType == mod.FF.MirageClone.Sub then
        alpha = math.min(alpha, bal.maxCloneAlpha)
    end
    if not data.State then
        alpha = 0
    end
    if data.HasCollision then
        if alpha > bal.alphaCollThreshold then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        else
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        end
    else
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    end
    mod:SetAlpha(sprite, alpha)
end

function mod:MirageHurt(npc, amount, damageFlags, source)
    local data = mod:GetEntityData(npc)
    if npc.SubType == mod.FF.MirageClone.Sub then
        if amount > 0 and data.State ~= "Poof" then
            data.State = "Poof"
        end
        return false
    else
        if data.Init then
            data.DamageBuffer = data.DamageBuffer - amount
            if data.DamageBuffer <= 0 then
                data.DamageBuffer = data.BaseDamamgeBuffer
                data.State = "Poof"
                for _, clone in pairs(GatherClones(npc)) do
                    if mod:GetEntityData(clone).State ~= "Poof" then
                        mod:GetEntityData(clone).State = "Poof"
                    end
                end
            end
        end
    end
end

function mod:MirageColl(npc, collider)
    local data = mod:GetEntityData(npc)
    if npc.SubType == mod.FF.MirageClone.Sub and not collider:ToNPC() then
        if data.State ~= "Poof" then
            data.State = "Poof"
        end
        return true
    end
end

function mod:MirageDeath(npc)
    local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 1, npc.Position, Vector.Zero, npc)
    poof.SpriteScale = Vector(0.6,0.6)
    poof:Update()
    local pile = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_CRATER, 0, npc.Position, Vector.Zero, npc)
    pile.Color = Color(1,1,1,1,0.5,0.5,0.5)
    pile.SpriteScale = Vector(0.75,0.75)
    pile:Update()
end