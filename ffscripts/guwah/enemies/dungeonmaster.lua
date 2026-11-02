local mod = FiendFolio
local game = Game()
local rng = RNG()
local sfx = SFXManager()

local function DungeonMasterPhaseTwo(npc, data)
    npc.I1 = 1
    if not data.Regenerating then
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        npc:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
    end
end

local function GetKeyFiends(npc)
    local keyfiends = {}
    for _, keyfiend in pairs(Isaac.FindByType(mod.FF.KeyFiend.ID, mod.FF.KeyFiend.Var, -1)) do
        if keyfiend and keyfiend.Parent and keyfiend.Parent.InitSeed == npc.InitSeed then
            table.insert(keyfiends, keyfiend)
        end
    end
    return keyfiends
end

local function GetKeyFiend(npc, color)
    color = color or -1
    for _, keyfiend in pairs(Isaac.FindByType(mod.FF.KeyFiend.ID, mod.FF.KeyFiend.Var, color)) do
        if keyfiend and keyfiend.Parent and keyfiend.Parent.InitSeed == npc.InitSeed then
            return keyfiend
        end
    end
end

local function AddKeyFiend(npc, color, angle)
    local keyfiend = Isaac.Spawn(mod.FF.KeyFiend.ID, mod.FF.KeyFiend.Var, color, npc.Position, Vector.Zero, npc):ToNPC()
    keyfiend.Parent = npc
    mod:GetEntityData(keyfiend).OrbitAngle = angle or 0
    mod:GetEntityData(keyfiend).OrbitAmount = mod:GetEntityData(npc).OrbitAmount
    keyfiend:Update()
    return keyfiend
end

function mod:DungeonMasterAI(npc, sprite, data)
    local rng = npc:GetDropRNG()
    local targetpos = mod:isCharm(npc) and mod:confusePos(npc, npc:GetPlayerTarget().Position) or game:GetNearestPlayer(npc.Position).Position

    if not data.Init then
        npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS)
        npc.SplatColor = mod.ColorGhostly
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
        data.OrbitAmount = (rng:RandomFloat() <= 0.5 and -3 or 3)
        for i = 1, 3 do
            AddKeyFiend(npc, i, i * 120)
        end
        npc.StateFrame = mod:RandomInt(15,30,rng)
        mod:FlipSprite(sprite, targetpos, npc.Position)
        data.State = "Idle"
        data.Init = true
    end

    if data.State == "Idle" then
        mod:WanderAboutAir(npc, data, 1, 0.1, 60, 120, 100)
        mod:SpritePlay(sprite, "Walk")
        mod:FlipSprite(sprite, targetpos, npc.Position)

        npc.StateFrame = npc.StateFrame - 1
        if npc.StateFrame <= 0 then
            data.State = "AttackPrep"
        end

    elseif data.State == "AttackPrep" then
        npc.Velocity = npc.Velocity * 0.8

        if sprite:IsFinished("AttackPrep") then
            local target = Isaac.Spawn(mod.FF.DungeonMasterTarget.ID, mod.FF.DungeonMasterTarget.Var, mod.FF.DungeonMasterTarget.Sub, npc.Position, Vector.Zero, npc)
            target.Parent = npc
            target:Update()
            data.Target = target
            data.State = "PrepLoop"
            npc.StateFrame = 60
        elseif sprite:IsEventTriggered("Grunt") then
            mod:PlaySound(mod.Sounds.DungeonMasterGrunt, npc, 1, 2)
        else
            mod:SpritePlay(sprite, "AttackPrep")
        end

    elseif data.State == "PrepLoop" then
        npc.Velocity = npc.Velocity * 0.5
        mod:SpritePlay(sprite, "PrepLoop")
        mod:FlipSprite(sprite, data.Target.Position, npc.Position)

        npc.StateFrame = npc.StateFrame - 1
        if npc.StateFrame <= 0 then
            data.Suffix = data.Target.Position.Y < npc.Position.Y and 2 or 1
            data.KeyFiend = data.KeyFiend or mod:GetRandomElem(GetKeyFiends(npc))
            mod:GetEntityData(data.KeyFiend).State = "Targeting"
            mod:GetEntityData(data.KeyFiend).Target = data.Target
            data.State = "Swing"
        end

    elseif data.State == "Swing" then
        npc.Velocity = Vector.Zero
    
        if sprite:IsFinished("Swing0"..data.Suffix) then
            data.KeyFiend = nil
            npc.StateFrame = mod:RandomInt(45,75,rng)
            data.State = "Idle"
        elseif sprite:IsEventTriggered("Shoot") then
            mod:PlaySound(mod.Sounds.DungeonMasterSwipe, npc, 1, 2)
            mod:PlaySound(SoundEffect.SOUND_SHELLGAME, npc)
            mod:FlipSprite(sprite, data.Target.Position, npc.Position)

            if not mod:IsReallyDead(data.KeyFiend) then
                mod:PlaySound(mod.Sounds.BatBaseballHit, npc, 1.2, 0.3)

                data.KeyFiend.Velocity = (data.Target.Position - data.KeyFiend.Position):Resized(10)
                data.KeyFiend.Parent = nil
                mod:GetEntityData(data.KeyFiend).State = "Fly"
                data.KeyFiend.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
                AddKeyFiend(npc, data.KeyFiend.SubType, mod:GetEntityData(data.KeyFiend).OrbitAngle)

                data.Target.Parent = nil
            end
        else
            mod:SpritePlay(sprite, "Swing0"..data.Suffix)
        end

    elseif data.State == "Death" then
        npc.Velocity = Vector.Zero
    
        if sprite:IsFinished("Death") then
            npc:Remove()
        elseif sprite:IsEventTriggered("Shout") then
            mod:PlaySound(mod.Sounds.DungeonMasterDeath, npc, 1.7, 2)
        elseif sprite:IsEventTriggered("Poof") then
            mod:PlaySound(SoundEffect.SOUND_SIREN_MINION_SMOKE, npc)
        elseif sprite:IsEventTriggered("Clang") then
            mod:PlaySound(mod.Sounds.MetalDrop, npc, 2, 0.8)
        elseif sprite:IsEventTriggered("Warp") then
            mod:PlaySound(SoundEffect.SOUND_HELL_PORTAL2, npc)
        else
            mod:SpritePlay(sprite, "Death")
        end
    end

    if room:IsClear() then
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        data.State = "Death"
    elseif npc:IsDead() then --Failsafe
        game:MakeShockwave(npc.Position, 0.035, 0.025, 10)
        for _, lock in pairs(mod:GetAllColoredLocks()) do
            lock.PersistentData.Unlock = true
            lock.PersistentData.friend = lock
        end
    end
end

function mod:DungeonMasterHurt(npc, amount, damageFlags, source)
    if npc.I1 ~= 1 then
        return false
    end
end

--[[function FiendFolio.DungeonMasterDeathAnim(npc)
	local onCustomDeath = function(npc, deathAnim)
        if mod:GetEntityData(npc).Regenerating then
            deathAnim:GetSprite():ReplaceSpritesheet(0, "gfx/enemies/dungeonmaster/Dungeonmaster_regenerating.png")
            deathAnim:GetSprite():LoadGraphics()
        end
        mod:GetEntityData(deathAnim).Init = true
	end
	FiendFolio.genericCustomDeathAnim(npc, "Death", false, onCustomDeath)
end]]

local function IsMasterDead(npc)
    return mod:IsReallyDead(npc.Parent) or mod:GetEntityData(npc.Parent).State == "Death"
end

function mod:DungeonMasterTarget(effect, sprite, data)
    if not data.Init then
        effect.DepthOffset = -4000
        sprite:Play("TargetAppear")
        data.Init = true
    end

    if IsMasterDead(effect) then
        if sprite:IsFinished("TargetLeave") then
            effect:Remove()
        else
            if sprite:IsOverlayPlaying() then
                mod:SpritePlay(sprite, "RingLeave")
            end
            mod:SpritePlay(sprite, "TargetLeave")
        end
    
    else
        if sprite:IsFinished("TargetAppear") then
            sprite:Play("Target")
        end

        if not data.LockedOn then
            data.TargetPos = effect.Parent:ToNPC():GetPlayerTarget().Position

            if data.TargetPos:Distance(effect.Position) < 10 and not data.RingActivated then
                sprite:PlayOverlay("RingAppear")
                data.RingActivated = true
            elseif sprite:IsOverlayFinished("RingAppear") then
                local lock = mod:GetNearestColoredLock(effect.Position)
                if lock and lock.Position:Distance(effect.Position) < 100 then
                    local keyfiend = GetKeyFiend(effect.Parent, mod:KeyLockToKeyFiend(lock.GridConfig.Name))
                    if keyfiend then
                        mod:GetEntityData(keyfiend).State = "Targeting"
                        mod:GetEntityData(keyfiend).Target = effect
                        mod:GetEntityData(effect.Parent).KeyFiend = keyfiend
                        effect.Parent:ToNPC().StateFrame = 10
                        data.TargetPos = lock.Position
                        data.LockedOn = true
                        sprite:PlayOverlay("RingLeave")
                    end
                end
            end
        end
    
        if data.TargetPos then
            local vec = data.TargetPos - effect.Position
            effect.Velocity = vec:Resized(math.min(vec:Length(), 12))
        end
    end
end

function mod:KeyFiendAI(npc, sprite, data) 
    if not data.Init then
        npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_HIDE_HP_BAR | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
        npc.SplatColor = mod.ColorInvisible
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        if mod.ColourBlindMode and npc.SubType == mod.FF.GreenKeyFiend.Sub then
            sprite:ReplaceSpritesheet(1, "gfx/enemies/dungeonmaster/keyfiend_yellow.png")
            sprite:LoadGraphics()
        end
        npc.SpriteOffset = Vector(0, -10)
        data.State = "Appear"
        data.Init = true
    end

    data.OrbitAngle = data.OrbitAngle + data.OrbitAmount

    if data.State == "Idle" or data.State == "Appear" then
        if IsMasterDead(npc) then
            data.Suffix = "Idle"
            data.State = "Poof"
        else
            local targetpos = npc.Parent.Position + Vector(40,0):Rotated(data.OrbitAngle)
            npc.Velocity = mod:Lerp(npc.Velocity, (targetpos - npc.Position) / 2, 0.1)

            if sprite:IsFinished("Appear") then
                data.State = "Idle"
            end
            mod:SpritePlay(sprite, data.State)
            sprite.FlipX = not npc.Parent:GetSprite().FlipX
        end
    
    elseif data.State == "Targeting" then
        if IsMasterDead(npc) then
            data.State = "Poof"
        else
            local targetpos = npc.Parent.Position + (data.Target.Position - npc.Parent.Position):Resized(40)
            npc.Velocity = mod:Lerp(npc.Velocity, (targetpos - npc.Position) / 2, 0.3)

            mod:SpritePlay(sprite, "Fly")
            mod:FlipSprite(sprite, npc.Position, data.Target.Position)
        end

    elseif data.State == "Fly" then
        mod:SpritePlay(sprite, "Fly")
        mod:FlipSprite(sprite, npc.Position, npc.Position + npc.Velocity)

        local room = game:GetRoom()
        if not room:IsPositionInRoom(npc.Position, 0) then
            if data.CanSplat then
                if not StageAPI.IsCustomGrid(room:GetGridIndex(npc.Position)) then
                    data.State = "Poof"
                end
            end
        else
            data.CanSplat = true
        end
    
    elseif data.State == "Poof" then
        npc.Velocity = Vector.Zero

        if not data.PoofInit then
            data.Suffix = data.Suffix or ""
            sfx:Play(SoundEffect.SOUND_SIREN_MINION_SMOKE)
            data.PoofInit = true
        end
    
        if sprite:IsFinished("Poof"..data.Suffix) then
            npc:Remove()
        else
            mod:SpritePlay(sprite, "Poof"..data.Suffix)
        end
    end
end

function mod:KeyFiendHurt(npc, amount, damageFlags, source)
    return false
end

function mod:KeyFiendColl(npc, collider)
    if mod:GetEntityData(npc).State == "Fly" and collider:ToPlayer() then
        collider:TakeDamage(1, 0, EntityRef(npc), 0)
    end
    return true
end

function mod:GetAllColoredLocks()
    local blocks1 = {}
    local blocks2 = {StageAPI.GetCustomGrids(nil, "FFKeyBlockBlue"), StageAPI.GetCustomGrids(nil, "FFKeyBlockRed"), StageAPI.GetCustomGrids(nil, "FFKeyBlockGreen")}
    for _, blocks in pairs(blocks2) do
        for _, block in pairs(blocks) do
            table.insert(blocks1, block)
        end
    end
    return blocks1
end

function mod:GetNearestColoredLock(pos)
    local nearest = nil
    local dist = 9999
    local locks = mod:GetAllColoredLocks()
    for _, lock in pairs(locks) do
        local grid = lock.GridEntity
        if grid and grid.Position:Distance(pos) < dist then
            nearest = lock
            dist = grid.Position:Distance(pos)
        end
    end
    return nearest
end

function mod:KeyFiendToKeyLock(sub)
    if sub == mod.FF.RedKeyFiend.Sub then
        return "FFKeyBlockRed"
    elseif sub == mod.FF.BlueKeyFiend.Sub then
        return "FFKeyBlockBlue"
    elseif sub == mod.FF.GreenKeyFiend.Sub then
        return "FFKeyBlockGreen"
    end
end

function mod:KeyLockToKeyFiend(variant)
    if variant == "FFKeyBlockRed" then
        return mod.FF.RedKeyFiend.Sub
    elseif variant == "FFKeyBlockBlue" then
        return mod.FF.BlueKeyFiend.Sub
    elseif variant == "FFKeyBlockGreen" then
        return mod.FF.GreenKeyFiend.Sub
    end
end

function mod:DungeonLocking(npc, sprite, data)
    npc.Visible = false
    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    mod:GetEntityData(npc).DungeonLocked = true
    npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET + EntityFlag.FLAG_HIDE_HP_BAR)
    local dungeonLockFilter = function(position, candidate)
        if mod:GetEntityData(candidate).DungeonLocked then
            return false
        elseif not mod:IsNPCFlickerspiritable(candidate) then
            return false
        else
            return true
        end
    end
    if npc.FrameCount > 3 then
        for i = 0, npc.SubType - 1 do
            local enemy = mod:GetNearestEnemy(npc.Position, 1000, dungeonLockFilter)
            if enemy then
                mod:AddDungeonLock(enemy)
            end
        end
        npc:Remove()
    end
end

function mod:AddDungeonLock(npc)
    mod:GetEntityData(npc).DungeonLocked = true
    local lock = Isaac.Spawn(1000, mod.FF.DungeonLock.Var, mod.FF.DungeonLock.Sub, npc.Position, Vector.Zero, npc)
    lock.SpriteOffset = Vector(0, -30 + npc.Size * -1.0)
    lock:GetSprite():Play("Appear")
    lock.Parent = npc
    if npc.CanShutDoors then
        npc.CanShutDoors = false
        mod:GetEntityData(lock).RestoreMyPower = true
    end
end

function mod:DungeonLockAI(effect, sprite, data)
    if sprite:IsFinished("Appear") then
        sprite:Play("Idle")
    elseif sprite:IsFinished("Leave") or sprite:IsFinished("Disappear") then
        effect:Remove()
    end
    if effect.Parent and effect.Parent:Exists() then
        local parent = effect.Parent:ToNPC()
        if not mod:AmISoftlocked(parent) then
            sprite:Play("Disappear")
            if data.RestoreMyPower then
                parent.CanShutDoors = true
            end
            mod:GetEntityData(parent).DungeonLocked = false
        end
        local noMasters = true
        for _, master in pairs(Isaac.FindByType(mod.FF.DungeonMaster.ID, mod.FF.DungeonMaster.Var, -1, false, false)) do
            if not mod:GetEntityData(master).DungeonLocked and not master:GetSprite():IsPlaying("Death") then
                noMasters = false
            end
        end
        if noMasters and not sprite:IsPlaying("Leave") and not canPathFind then
            for i = 0, game:GetNumPlayers() do
                local targetpos = game:GetPlayer(i).Position
                if not parent.Pathfinder:HasPathToPos(targetpos) then
                    sprite:Play("Leave")
                    sfx:Play(SoundEffect.SOUND_ANIMA_BREAK)
                end
            end
        end
        if not parent:Exists() and not sprite:IsPlaying("Leave") then
            sprite:Play("Disappear")
        elseif sprite:IsEventTriggered("Remove") then
            parent:Remove()
            local poof = Isaac.Spawn(1000, EffectVariant.POOF01, 0, parent.Position, Vector.Zero, effect)
            poof.Color = mod.ColorGhostly
            sfx:Play(SoundEffect.SOUND_SIREN_MINION_SMOKE)
        end
        effect.Velocity = parent.Position - effect.Position
        effect.SpriteOffset = Vector(0, -30 + parent.Size * -1.0)
    else
        effect.Velocity = Vector.Zero
        if not data.ImDone then
            sprite:Play("Disappear")
            data.ImDone = true
        end
    end
end

--Keyfiend spin animation when
--NEver idiot

--DEPRECIATED AIs
local function RecalculateKeyFiendOrbiting(npc, keyfiends) 
    keyfiends = keyfiends or GetKeyFiends(npc)
    local sorttable = {}
    for _, keyfiend in pairs(keyfiends)do
        local angle = mod:GetAngleDegreesButGood(keyfiend.Position - npc.Position)
        table.insert(sorttable, {keyfiend, angle})
    end
    table.sort(sorttable, function( a, b ) return a[2] < b[2] end )
    for i = 1, #sorttable do
        local d = mod:GetEntityData(sorttable[i][1])
        d.Angle = ((360 / #sorttable) * i) + mod:GetEntityData(npc).AngleBuffer
    end
end

function mod:DungeonMasterAIOLD(npc, sprite, data) 
    local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position)
    if not data.Init then
        npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
        npc.SplatColor = mod.ColorInvisible
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
        data.RedFiends = (npc.SubType >> 1) & 7 
        data.BlueFiends = (npc.SubType >> 4) & 7
		data.GreenFiends = (npc.SubType >> 7) & 7
        data.TotalFiends = data.RedFiends + data.BlueFiends + data.GreenFiends
        data.FiendCount = data.TotalFiends
        data.Regenerating = npc.SubType % 2 == 1
        data.AngleShift = 2
        data.movetimer = 90
        if rng:RandomFloat() <= 0.5 then
            data.AngleShift = data.AngleShift * -1
        end
        data.AngleBuffer = 0
        local keyfiends = {}
        local iter = 0
        local redcount = data.RedFiends
        local bluecount = data.BlueFiends
        local greencount = data.GreenFiends
        if data.TotalFiends == 0 then
            DungeonMasterPhaseTwo(npc, data)
        end
        while true do
            local isDone = true
            if redcount > 0 then
                table.insert(keyfiends, AddKeyFiend(npc, mod.FF.RedKeyFiend.Sub))
                iter = iter + 1
                redcount = redcount - 1
                isDone = false
            end
            if bluecount > 0 then
                table.insert(keyfiends, AddKeyFiend(npc, mod.FF.BlueKeyFiend.Sub))
                iter = iter + 1
                bluecount = bluecount - 1
                isDone = false
            end
            if greencount > 0 then
                table.insert(keyfiends, AddKeyFiend(npc, mod.FF.GreenKeyFiend.Sub))
                iter = iter + 1
                greencount = greencount - 1
                isDone = false
            end
            if isDone then
                break
            end 
        end
        RecalculateKeyFiendOrbiting(npc, keyfiends)
        if data.Regenerating then
            npc.CanShutDoors = false
            sprite:ReplaceSpritesheet(0, "gfx/enemies/dungeonmaster/Dungeonmaster_regenerating.png")
            sprite:LoadGraphics()
        end
        sprite:Play("Appear")
        data.Init = true
    end
    data.AngleShift = data.AngleShift or 2
    data.AngleBuffer = data.AngleBuffer or 0
    data.AngleBuffer = data.AngleBuffer + data.AngleShift
    if data.ChargeVelocity then
        local room = game:GetRoom()
        local margain
        if StageAPI.IsCustomGrid(room:GetGridIndex(npc.Position + data.ChargeVelocity)) then
            margain = 40
        else
            margain = 10
        end
        if room:IsPositionInRoom(npc.Position + data.ChargeVelocity, margain) then
            npc.Velocity = data.ChargeVelocity
            if npc.FrameCount % 2 == 0 then
                mod:MakeAfterimage(npc, function(entity, effect, sprite, sprite2)
                    if mod:GetEntityData(entity).Regenerating then
                        sprite2:ReplaceSpritesheet(0, "gfx/enemies/dungeonmaster/Dungeonmaster_regenerating.png")
                        sprite2:LoadGraphics()
                    end
                end)
            end
        else
            npc.Velocity = Vector.Zero
        end
    elseif sprite:IsPlaying("Walk") then
        local movetarget
        local speed = 2
        if npc.I1 == 1 then
            movetarget = targetpos
            speed = math.min(200,npc.Position:Distance(targetpos)) / 100
        else
            if data.movetarget then 
                if data.movetarget:Distance(npc.Position) < 10 or data.movetimer <= 0 then
                    data.movetarget = mod:FindRandomFreePosAir(targetpos, 100, 300)
                    data.movetimer = 90
                else
                    data.movetimer = data.movetimer - 1
                end
            else
                data.movetarget = mod:FindRandomFreePosAir(targetpos, 100, 300)
            end
            movetarget = data.movetarget
        end
        local vel = mod:reverseIfFear(npc, (movetarget - npc.Position):Resized(speed)) 
        npc.Velocity = mod:Lerp(npc.Velocity, vel, 0.05)
        mod:FlipSprite(sprite, targetpos, npc.Position)
        if npc.StateFrame <= 0 then
            sprite:Play("Attack02")
            if npc.I1 ~= 1 then
                if npc.Position:Distance(target.Position) < 150 then
                    data.GiveSomeBreathingRoom = true
                end
            end
        else
            npc.StateFrame = npc.StateFrame - 1
        end
    else
        if data.GiveSomeBreathingRoom then
            npc.Velocity = mod:Lerp(npc.Velocity, (npc.Position - targetpos):Resized(3), 0.05)
        else
            npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.05)
        end
    end
    if sprite:IsFinished("Appear") then
        sprite:Play("Walk")
        npc.StateFrame = mod:RandomInt(40,60)
    elseif sprite:IsFinished("Attack01") or sprite:IsFinished("Attack02") then
        sprite:Play("Walk")
        data.GiveSomeBreathingRoom = false
        if npc.I1 == 1 then
            npc.StateFrame = mod:RandomInt(80,100)
        else
            local waittime = math.floor(180 / data.TotalFiends)
            local variance = math.floor(60 / data.TotalFiends)
            npc.StateFrame = mod:RandomInt(waittime,waittime+variance)
        end
    elseif sprite:IsFinished("Death") then
        npc:Remove()
    end
    if sprite:IsEventTriggered("Grunt") then
        mod:PlaySound(mod.Sounds.DungeonMasterGrunt, npc, 1, 2)
    elseif sprite:IsEventTriggered("Prep") then
        mod:FlipSprite(sprite, targetpos, npc.Position)
    elseif sprite:IsEventTriggered("Shoot") then
        mod:PlaySound(mod.Sounds.DungeonMasterSwipe, npc, 1, 2)
        sfx:Play(SoundEffect.SOUND_SHELLGAME)
        mod:FlipSprite(sprite, targetpos, npc.Position)
    elseif sprite:IsEventTriggered("Shout") then
        npc:PlaySound(mod.Sounds.DungeonMasterDeath, 2, 0, false, 1.7)
    elseif sprite:IsEventTriggered("Poof") then
        sfx:Play(SoundEffect.SOUND_SIREN_MINION_SMOKE)
    elseif sprite:IsEventTriggered("Clang") then
        sfx:Play(mod.Sounds.MetalDrop, 0.8, 0, false, 2)
    elseif sprite:IsEventTriggered("Warp") then
        sfx:Play(SoundEffect.SOUND_HELL_PORTAL2)
    end
    if npc.I1 == 1 then
        if sprite:IsEventTriggered("Prep") then
            data.ChargeVelocity = mod:reverseIfFear(npc, (targetpos - npc.Position):Resized(15))
            npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        elseif sprite:IsEventTriggered("Shoot") then
            data.ChargeVelocity = nil
            npc.Velocity = Vector.Zero
            npc:ClearEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        end
    else
        npc:SetColor(Color(1,1,1,0.5),5,3,true,false)
        if sprite:IsEventTriggered("Prep") then
            local theChosenOne
            local nearestKeyBlock = mod:GetNearestColoredLock(targetpos)
            if nearestKeyBlock and nearestKeyBlock.GridEntity.Position:Distance(targetpos) < 160 then
                local keyFiendWanted = mod:KeyLockToKeyFiend(nearestKeyBlock.GridConfig.Name)
                for _, keyfiend in pairs(GetKeyFiends(npc)) do
                    if keyfiend.SubType == keyFiendWanted then
                        theChosenOne = keyfiend
                        mod:GetEntityData(theChosenOne).TargetLock = nearestKeyBlock
                        break
                    end
                end
            end
            if not theChosenOne then
                local pool = {}
                for _, keyfiend in pairs(GetKeyFiends(npc)) do
                    table.insert(pool, keyfiend)
                end
                theChosenOne = mod:GetRandomElem(pool)
            end
            theChosenOne:GetSprite():Play("Move")
            theChosenOne.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
            data.ToHit = theChosenOne   
        elseif sprite:IsEventTriggered("Shoot") then
            local hitted = data.ToHit:ToNPC()
            hitted:GetSprite():Play("Fly")
            hitted.Velocity = mod:rotateIfConfuse(npc, (hitted:GetPlayerTarget().Position - hitted.Position):Resized(10)) 
            local keyfiends = GetKeyFiends(npc)
            if data.Regenerating then
                table.insert(keyfiends, AddKeyFiend(npc, hitted.SubType))
            else
                data.FiendCount = data.FiendCount - 1
            end
            RecalculateKeyFiendOrbiting(npc, keyfiends)
            if data.FiendCount <= 0 then
                DungeonMasterPhaseTwo(npc, data)
            end
            npc:PlaySound(mod.Sounds.BatBaseballHit, 0.3, 0, false, 1.2)
        end
    end
    if data.Regenerating and game:GetRoom():IsClear() and not sprite:IsPlaying("Death") then
        npc:Kill()
        for _, keyfiend in pairs(GetKeyFiends(npc)) do
            keyfiend:GetSprite():Play("Poof")
        end
    end
end

function mod:KeyFiendAIOLD(npc, sprite, data) --DEPRECIATED
    if not data.Init then
        npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_HIDE_HP_BAR | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
        sprite:Play("Idle")
        npc.SplatColor = mod.ColorInvisible
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        if mod.ColourBlindMode and npc.SubType == mod.FF.GreenKeyFiend.Sub then
            sprite:ReplaceSpritesheet(1, "gfx/enemies/dungeonmaster/keyfiend_yellow.png")
            sprite:LoadGraphics()
        end
        sprite.Offset = Vector(0, -10)
        data.Init = true
    end
    if sprite:IsPlaying("Poof") then
        if sprite:GetFrame() == 1 then
            sfx:Play(SoundEffect.SOUND_SIREN_MINION_SMOKE)
        end
        npc.Velocity = Vector.Zero
    elseif sprite:IsFinished("Poof") then
        npc:Remove()
    else
        if npc.Parent and npc.Parent:Exists() then       
            if sprite:IsPlaying("Fly") then
                local target --= npc:GetPlayerTarget()
                local rotstrength
            
                if data.TargetLock --[[and data.TargetLock.Position:Distance(npc.Position) < 300]] then
                    target = data.TargetLock.GridEntity
                    rotstrength = 2
                elseif npc.StateFrame < 120 then
                    local nearestlock 
                    local neardist = 100
                    local keyblocks = StageAPI.GetCustomGrids(nil, mod:KeyFiendToKeyLock(npc.SubType))
                    for _, block in pairs(keyblocks) do
                        if block.GridEntity and block.GridEntity.Position:Distance(npc.Position) <= neardist then
                            neardist = block.GridEntity.Position:Distance(npc.Position)
                            nearestlock = block
                        end
                    end
                    if nearestlock then
                        target = nearestlock.GridEntity
                        rotstrength = 4
                    end
                end
            
                if target then
                    local angleDifference = mod:GetAngleDifference(target.Position - npc.Position, npc.Velocity)
                    local rotation = rotstrength
                    if angleDifference < rotstrength and angleDifference > -rotstrength then
                        rotation = angleDifference
                    elseif angleDifference > 180 then
                        rotation = -rotstrength
                    end
                    local targetvel = npc.Velocity
                    if target.Position:Distance(npc.Position) < 400 then
                        targetvel = npc.Velocity:Rotated(rotation)
                    end
                    npc.Velocity = mod:Lerp(targetvel, npc.Velocity, 0.05)
                end
            
                local room = game:GetRoom()
                if not room:IsPositionInRoom(npc.Position, 0) then
                    if data.CanSplat then
                        if not StageAPI.IsCustomGrid(room:GetGridIndex(npc.Position)) then
                            sprite:Play("Poof")
                        end
                    end
                else
                    data.CanSplat = true
                end
                mod:FlipSprite(sprite, npc.Position, npc.Position + npc.Velocity)
                npc.StateFrame = npc.StateFrame + 1
            elseif data.Angle then
                local master = npc.Parent:ToNPC()
                local target = master:GetPlayerTarget()
                data.Angle = data.Angle + mod:GetEntityData(master).AngleShift
                npc.TargetPosition = master.Position + Vector(50,0):Rotated(data.Angle)
                npc.Velocity = mod:Lerp(npc.Velocity, (npc.TargetPosition - npc.Position):Resized(5), 0.075)
                mod:FlipSprite(sprite, npc.Position, target.Position)
            end
        else
            sprite:Play("Poof")
        end
    end
end