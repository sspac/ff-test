local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    WallDensity = 52,
    FogSpeed = 20,
    InitialSpeed = 6,
    Decel = 0.88,
    Accel = 0.1,
    WarningPeriod = 30,
    RO = -20,
}

local dirToString = {[0] = "Down", [1] = "Left", [2] = "Up", [3] = "Right"}
local stringToAng = {["Down"] = 0, ["Left"] = 90, ["Up"] = 180, ["Right"] = 270}
function mod:FogspawnCloudUpdate(effect)
    local d = mod:GetEntityData(effect)
    local sprite = effect:GetSprite()
    local room = game:GetRoom()

    if not d.init then
        d.StateFrame = 0
        d.FogFlashColor = Color(1, 1, 1, 1, 0.08, 0, 0.08)
        d.FogBlinkColor = Color(1, 1, 1, 1, 0.35, 0, 0.35)
        d.State = "Appear"


        if not d.CosmeticFogClouds then
            sfx:Play(mod.Sounds.FogspawnStart, 3, 0, false, 1)
            d.FogIsWall = effect.SubType & 1
            local dir = (effect.SubType >> 1 & 3)
            d.FogDir = dirToString[dir]
            local frequency = 5/((effect.SubType >> 3 & 15)+1)
            d.FogFreq = math.floor(frequency*30)
            local frames = (effect.SubType >> 7 & 7)*10
            d.FrameOffset = frames-40

            if d.FogIsWall == 1 then
                local pos = {0,0,0,0}
                local chosenWall
                if room:GetGridCollisionAtPos(effect.Position) == GridCollisionClass.COLLISION_WALL then
                    chosenWall = effect.Position
                else
                    chosenWall = mod:GetClosestWallPos(effect.Position)
                end
                local tl = room:GetTopLeftPos()
                local br = room:GetBottomRightPos()
                if chosenWall.X <= tl.X then
                    d.FogWall = "Left"
                    d.FogDir = "Right"
                    pos = {tl.X+bal.RO,tl.X+bal.RO,tl.Y,br.Y}
                    effect.Position = Vector(tl.X+bal.RO, effect.Position.Y)
                elseif chosenWall.X >= room:GetBottomRightPos().X then
                    d.FogWall = "Right"
                    d.FogDir = "Left"
                    pos = {br.X-bal.RO,br.X-bal.RO,tl.Y,br.Y}
                    effect.Position = Vector(br.X-bal.RO, effect.Position.Y)
                elseif chosenWall.Y <= room:GetTopLeftPos().Y then
                    d.FogWall = "Top"
                    d.FogDir = "Down"
                    pos = {tl.X,br.X,tl.Y+bal.RO,tl.Y+bal.RO}
                    effect.Position = Vector(effect.Position.X, tl.Y+bal.RO)
                elseif chosenWall.Y >= room:GetBottomRightPos().Y then
                    d.FogWall = "Bottom"
                    d.FogDir = "Up"
                    pos = {tl.X,br.X,br.Y-bal.RO,br.Y-bal.RO}
                    effect.Position = Vector(effect.Position.X, br.Y-bal.RO)
                else
                    --Horizontal is prioritized for this
                    local midPoint = (room:GetBottomRightPos()+room:GetTopLeftPos())/2
                    local roomShape = room:GetRoomShape()
                    if math.abs(chosenWall.Y-midPoint.Y) <= 20 then
                        if roomShape == RoomShape.ROOMSHAPE_LTL then
                            d.FogWall = "MidLeft"
                            d.FogDir = "Down"
                            pos = {tl.X,midPoint.X,midPoint.Y+bal.RO,midPoint.Y+bal.RO}
                            effect.Position = Vector(effect.Position.X, midPoint.Y+bal.RO)
                        elseif roomShape == RoomShape.ROOMSHAPE_LTR then
                            d.FogWall = "MidRight"
                            d.FogDir = "Down"
                            pos = {midPoint.X,br.X,midPoint.Y+bal.RO,midPoint.Y+bal.RO}
                            effect.Position = Vector(effect.Position.X, midPoint.Y+bal.RO)
                        elseif roomShape == RoomShape.ROOMSHAPE_LBL then
                            d.FogWall = "MidLeft"
                            d.FogDir = "Up"
                            pos = {tl.X,midPoint.X,midPoint.Y-bal.RO,midPoint.Y-bal.RO}
                            effect.Position = Vector(effect.Position.X, midPoint.Y-bal.RO)
                        elseif roomShape == RoomShape.ROOMSHAPE_LBR then
                            d.FogWall = "MidRight"
                            d.FogDir = "Up"
                            pos = {midPoint.X,br.X,midPoint.Y-bal.RO,midPoint.Y-bal.RO}
                            effect.Position = Vector(effect.Position.X, midPoint.Y-bal.RO)
                        end
                    else
                        if roomShape == RoomShape.ROOMSHAPE_LTL then
                            d.FogWall = "MidUp"
                            d.FogDir = "Right"
                            pos = {midPoint.X+bal.RO,midPoint.X+bal.RO,tl.Y,midPoint.Y}
                            effect.Position = Vector(midPoint.X+bal.RO, effect.Position.Y)
                        elseif roomShape == RoomShape.ROOMSHAPE_LTR then
                            d.FogWall = "MidUp"
                            d.FogDir = "Left"
                            pos = {midPoint.X-bal.RO,midPoint.X-bal.RO,tl.Y,midPoint.Y}
                            effect.Position = Vector(midPoint.X-bal.RO, effect.Position.Y)
                        elseif roomShape == RoomShape.ROOMSHAPE_LBL then
                            d.FogWall = "MidDown"
                            d.FogDir = "Right"
                            pos = {midPoint.X+bal.RO,midPoint.X+bal.RO,midPoint.Y,br.Y}
                            effect.Position = Vector(midPoint.X+bal.RO, effect.Position.Y)
                        elseif roomShape == RoomShape.ROOMSHAPE_LBR then
                            d.FogWall = "MidDown"
                            d.FogDir = "Left"
                            pos = {midPoint.X-bal.RO,midPoint.X-bal.RO,midPoint.Y,br.Y}
                            effect.Position = Vector(midPoint.X-bal.RO, effect.Position.Y)
                        end
                    end
                end
                effect.Visible = false
                effect.Color = Color(1, 1, 1, 1, 1, 0, 0)
                local offset = 0
                local increment = Vector(bal.WallDensity, 0)
                if pos[1] == pos[2] then
                    offset = 2
                    increment = Vector(0, bal.WallDensity)
                end
                local dist = pos[offset+2]-pos[offset+1]
                local num = math.floor(dist/bal.WallDensity)
                local initPos = (offset == 0 and Vector(pos[offset+1]+(dist%bal.WallDensity)/2, pos[3])) or Vector(pos[1], pos[offset+1]+(dist%bal.WallDensity)/2)
                for i=1,num do
                    local cloud = Isaac.Spawn(1000, mod.FF.FogspawnCloud.Var, 0, initPos+increment*(i-1), Vector.Zero, effect):ToEffect()
                    cloud.Parent = effect
                    mod:GetEntityData(cloud).CosmeticFogClouds = 0
                    mod:GetEntityData(cloud).initPos = initPos+increment*(i-1)
                    mod:GetEntityData(cloud).FogDir = d.FogDir
                    mod:GetEntityData(cloud).FogFrames = i*12
                    mod:GetEntityData(cloud).FogFlash = i*4
                    mod:GetEntityData(cloud).FogMove = Vector(0,1):Rotated(stringToAng[d.FogDir])
                    cloud:Update()
                end
            else
                if d.FogDir == "Right" or d.FogDir == "Left" then
                    effect.SpriteOffset = Vector(0,-20)
                end
            end
            d.FogFlash = 0
        end

        effect.SpriteRotation = stringToAng[d.FogDir]

        d.init = true
    else
        d.FogFlash = d.FogFlash+1
        d.StateFrame = d.StateFrame+1
    end


    if d.CosmeticFogClouds == 0 then
        d.FogFrames = d.FogFrames+1
        local targetPos = d.initPos+d.FogMove:Resized(10*math.sin(d.FogFrames/20))

        effect.Velocity = targetPos-effect.Position
        if d.FogFlash and d.FogFlash % 80 == 0 then
            effect:SetColor(d.FogFlashColor, 20, 10, true, false)
        end
    else
        if not d.initPos then
            d.initPos = effect.Position
        end
        effect.Velocity = d.initPos-effect.Position
        if not d.FogFlashed then
            
            if d.FogFlash > 12 then
                effect.Color = Color.Lerp(effect.Color, Color(1, 1, 1, 1, 0, 0, 0), 0.05)
            else
                effect.Color = Color.Lerp(effect.Color, d.FogBlinkColor, 0.1)
            end
            if effect.Color.RO < 0.05 and d.FogFlash > 12 then
                effect.Color = Color(1, 1, 1, 1, 0, 0, 0)
                d.FogFlashed = true
                d.FogFlash = 0
            end
        else
            if d.FogFlash and d.FogFlash % 50 == 0 then
                effect:SetColor(d.FogFlashColor, 20, 10, true, false)
            end
        end
    end

    if d.State == "Appear" then
        if sprite:IsFinished("Appear") then
            d.State = "Idle"
            d.StateFrame = (d.FrameOffset or 0)
        else
            mod:spritePlay(sprite, "Appear")
        end
    elseif d.State == "Idle" then
        if not d.CosmeticFogClouds then
            if d.StateFrame % d.FogFreq == 0 then
                local fogSpawn = Isaac.Spawn(mod.FF.Fogspawn.ID, mod.FF.Fogspawn.Var, 0, effect.Position, Vector.Zero, effect):ToNPC()
                local target = fogSpawn:GetPlayerTarget()
                if d.FogIsWall == 1 then
                    if d.FogDir == "Up" or d.FogDir == "Down" then
                        fogSpawn.Position = Vector(target.Position.X, effect.Position.Y)
                    else
                        fogSpawn.Position = Vector(effect.Position.X, target.Position.Y)
                    end
                    mod:GetEntityData(fogSpawn).FogFollowTarget = true
                end
                fogSpawn.Target = target
                fogSpawn:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                fogSpawn.Parent = effect
                mod:GetEntityData(fogSpawn).FogDir = d.FogDir
                mod:GetEntityData(fogSpawn).FogVec = Vector(0, bal.FogSpeed):Rotated(stringToAng[d.FogDir])
                mod:GetEntityData(fogSpawn).FogSpeed = bal.InitialSpeed
                fogSpawn:Update()
            end
        end

        
        if d.CosmeticFogClouds then
            if not effect.Parent or not effect.Parent:Exists() or mod:GetEntityData(effect.Parent).State == "Disappear" then
                d.State = "Disappear"
            end
        elseif effect.Variant == mod.FF.FogspawnCloud.Var and room:IsClear() then
            d.State = "Disappear"
            sfx:Play(mod.Sounds.FogspawnEnd, 3, 0, false, 1)
        end

        mod:spritePlay(sprite, "Idle")
    elseif d.State == "Disappear" then
        if sprite:IsFinished("Disappear") then
            effect:Remove()
        else
            mod:spritePlay(sprite, "Disappear")
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.FogspawnCloudUpdate, mod.FF.FogspawnCloud.Var)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.FogspawnCloudUpdate, mod.FF.FogspawnCloudPersistent.Var)

mod:AddCallback(ModCallbacks.MC_IS_PERSISTENT_ROOM_ENTITY, function(_, t, variant)
    if t == mod.FF.FogspawnCloudPersistent.ID and variant == mod.FF.FogspawnCloudPersistent.Var then
        return true
    end
end)

function mod:fogspawnAI(npc)
    local d = mod:GetEntityData(npc)
    local sprite = npc:GetSprite()
    local room = game:GetRoom()

    if not d.init then
        npc.SplatColor = mod.ColorCharred
        d.State = "Appear"
        d.FogDir = d.FogDir or "Down"
        d.FogVec = d.FogVec or Vector(0, 1)
        d.FogSpeed = d.FogSpeed or 0
        npc:PlaySound(mod.Sounds.FogspawnCharge, 3, 0, false, 1)
        npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_REWARD)
        d.init = true
    else
        npc.StateFrame = npc.StateFrame+1
    end

    local extra = Vector.Zero
    if not d.FogDecelled then
        d.FogSpeed = d.FogSpeed*bal.Decel
        if npc.StateFrame > bal.WarningPeriod then
            d.FogDecelled = true
            d.FogVel = 0
        end
        if d.FogFollowTarget then
            if not npc.Target or not mod:superExists(npc.Target) then
                npc.Target = npc:GetPlayerTarget()
            end
            
            if d.FogDir == "Down" or d.FogDir == "Up" then
                extra = Vector(npc.Target.Position.X-npc.Position.X, 0)
            else
                extra = Vector(0, npc.Target.Position.Y-npc.Position.Y)
            end
        end
        npc.Velocity = extra+d.FogVec:Resized(d.FogSpeed)
    else
        d.FogVel = d.FogVel+bal.Accel
        d.FogSpeed = math.min(bal.FogSpeed, d.FogSpeed+d.FogVel)
        npc.Velocity = mod:Lerp(npc.Velocity, d.FogVec:Resized(d.FogSpeed), 0.3)
    end

    if d.State == "Appear" then
        if sprite:IsFinished(d.FogDir .. "Appear") then
            d.State = "Idle"
        else
            mod:spritePlay(sprite, d.FogDir .. "Appear")
        end
    else
        mod:spritePlay(sprite, d.FogDir .. "Idle")
    end
    
    if d.FogDecelled and not room:IsPositionInRoom(npc.Position, 0) then
        npc.Color = Color.Lerp(npc.Color, Color(npc.Color.R, npc.Color.G, npc.Color.B, 0), 0.1)
        if npc.Color.A < 0.1 then
            d.WHYAREYOUPLAYING = true
            npc:Remove()
        end
    end

    if npc:IsDead() and not d.WHYAREYOUPLAYING then
        npc:PlaySound(mod.Sounds.FogspawnDie, 3, 0, false, 1)
    end
end

function mod:fogspawnColl(npc, coll, low)
    if coll:ToNPC() and not mod:isCharm(npc) then
        return true
    end
end