local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

--holy shit this is so messy but im so tired

local bal = {
    attackFreq1 = 28,
    attackFreq2 = 34,
    spreadMin = 30, --doubled
    maxSpeed = 14,
    scale = {80,150},

    fadeTime = 45,

    increase1 = 0.005,
    increase2 = 43,

    realSize = 198,
}

--current size of ring is ~198 away

local ring = Sprite()
ring:Load("gfx/enemies/excluder/excluder_ring.anm2", true)
ring:Play("Idle", true)

local color1 = Color(0.4, 0.7, 1, 0, 0, 0, 0)
color1:SetColorize(0.8, 0.7, 0.4, 1)

local color2 = Color(1, 1, 1, 0, 0, 0, 0)
color2:SetColorize(0.6, 2.3, 0.1, 1)

local params = ProjectileParams()
params.Scale = 0
params.Color = color2
params.BulletFlags = ProjectileFlags.NO_WALL_COLLIDE

function mod:excluderAI(npc)
    local sprite = npc:GetSprite()
    local d = mod:GetEntityData(npc)
    local rng = npc:GetDropRNG()

    if not d.init then
        d.initPos = npc.Position
        npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
        d.state = "Idle"
        d.ringSize = 0
        if npc.SubType == 0 then
            npc.SubType = 60
        end
        --[[d.renderBuddy = Isaac.Spawn(mod.FF.ChummerPathfinder.ID, mod.FF.ChummerPathfinder.Var, npc.Variant, npc.Position, Vector.Zero, npc):ToNPC()
        d.renderBuddy.Parent = npc
        mod:GetEntityData(d.renderBuddy).dummyRender = true
        mod:GetEntityData(d.renderBuddy).delayRemove = 50
        d.renderBuddy.DepthOffset = -500]]
        d.maxRingSize = npc.SubType*2
        d.ringIncrease = 0.01
        d.attack1 = rng:RandomInt(bal.attackFreq1)
        d.attack2 = rng:RandomInt(bal.attackFreq2)
        d.init = true
    else
        npc.StateFrame = npc.StateFrame+1
    end

    if not d.isSpecturned then
		if not d.initPos then
			d.initPos = npc.Position
		end
		npc.Velocity = d.initPos-npc.Position
	else
		d.initPos = nil
	end

    --[[if d.ringSize < d.maxRingSize and npc.StateFrame > 2 then
        if npc.StateFrame < bal.increase2 then
            d.ringIncrease = (d.ringIncrease or 0)+bal.increase1
            d.ringSize = mod:Lerp(d.ringSize, d.maxRingSize, d.ringIncrease or 0)
        else
            d.ringSize = d.maxRingSize
            d.initializedRing = true
        end
    end]]
    if npc.StateFrame > 20 and not d.initializedRing then
        d.initializedRing = true
    end
    if d.initializedRing then
        d.attack1 = d.attack1+1
        d.attack2 = d.attack2+1

        if d.attack1 % bal.attackFreq1 == 0 then
            d.nextFireAngle1 = d.nextFireAngle1 or rng:RandomInt(360)
            mod:SetGatheredProjectiles()
            npc:FireProjectiles(npc.Position+Vector(0,d.maxRingSize):Rotated(d.nextFireAngle1), Vector.Zero, 0, params)
			for _, proj in pairs(mod:GetGatheredProjectiles()) do
                proj.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                mod:GetEntityData(proj).projType = "excluder"
                mod:GetEntityData(proj).excluder = npc
                proj.SpriteScale = Vector.Zero
                mod:GetEntityData(proj).maxScale = mod:RandomInt(bal.scale[1], bal.scale[2], rng)/100
                proj:Update()
            end
            d.nextFireAngle1 = d.nextFireAngle1+mod:RandomInt(bal.spreadMin,360-bal.spreadMin)%360
        end

        if d.attack2 % bal.attackFreq2 == 0 then
            d.nextFireAngle2 = d.nextFireAngle2 or rng:RandomInt(360)
            mod:SetGatheredProjectiles()
            npc:FireProjectiles(npc.Position+Vector(0,d.maxRingSize):Rotated(d.nextFireAngle2), Vector.Zero, 0, params)
			for _, proj in pairs(mod:GetGatheredProjectiles()) do
                proj.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                mod:GetEntityData(proj).projType = "excluder"
                mod:GetEntityData(proj).excluder = npc
                proj.SpriteScale = Vector.Zero
                mod:GetEntityData(proj).maxScale = mod:RandomInt(bal.scale[1], bal.scale[2], rng)/100
                proj:Update()
            end
            d.nextFireAngle2 = d.nextFireAngle2+mod:RandomInt(bal.spreadMin,360-bal.spreadMin)%360
        end
    end

    --[[if mod:superExists(d.renderBuddy) then
        d.renderBuddy.Position = npc.Position
        d.renderBuddy.Velocity = npc.Velocity
    end]]

    mod:spritePlay(sprite, "Idle")
end

function mod:excluderProj(proj, d)
    if d.projType == "excluder" then
        if not d.init then
            d.stateframe = 0
            d.state = "Begin"
            d.alphaGain = 0
            d.greenGain = 0
            d.speed = 0
            d.accel = 0.1
            d.colorizeVec1 = Vector(0.8, 0.7)
            d.colorize2 = 0.4
            d.init = true
        else
            d.stateframe = d.stateframe+1
        end

        proj.FallingSpeed = 0
        proj.FallingAccel = -0.1

        if d.state == "Begin" then
            if mod:superExists(d.excluder) then
                proj.Velocity = Vector.Zero
                proj.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                if proj.Scale < (d.maxScale or 1) and proj.FrameCount > 5 then
                    proj.Scale = proj.Scale+0.1
                end
                if proj.SpriteScale.X < 1 then
                    proj.SpriteScale = Vector(proj.SpriteScale.X+0.03, proj.SpriteScale.X+0.03)
                end
                --[[local newColor = Color.Lerp(proj.Color, color2, 0.1)
                local newerColor = Color(newColor.R, newColor.G, newColor.B, d.alphaGain, 0, d.greenGain, 0)
                newerColor:SetColorize(d.colorizeVec1.X, d.colorizeVec1.Y, d.colorize2, 1)
                d.colorizeVec1 = mod:Lerp(d.colorizeVec1, Vector(0.6, 2.3), 0.1)
                d.colorize2 = mod:Lerp(d.colorize2, 0.1, 0.1)

                proj.Color = newerColor]]
                local newerColor = Color(color2.R, color2.G, color2.B, d.alphaGain, 0, 0, 0)
                newerColor:SetColorize(0.6, 2.3, 0.1, 1)
                proj.Color = newerColor

                if d.alphaGain < 0.5 then
                    d.alphaGain = math.min(d.alphaGain+0.01, 0.5)
                end

                if d.stateframe > bal.fadeTime then
                    d.state = "Return"
                    proj.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                end
            else
                proj.FallingSpeed = -3
                proj.FallingAccel = 1.3
                proj.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                d.projType = "NoColl"
            end

            if proj.FrameCount % 10 == 0 then
                local blood = Isaac.Spawn(1000, 7, 0, proj.Position, Vector.Zero, proj)
				blood.SpriteScale = Vector(0.4,0.4)
				blood.Color = Color(0.2, 0.2, 0.2, 0.1, 0, 0, 0)
				blood:Update()
            end
        elseif d.state == "Return" then
            if d.greenGain < 0.29 and not d.greenFlash then
                d.greenGain = mod:Lerp(d.greenGain, 0.3, 0.25)
            else
                d.greenFlash = true
                d.greenGain = mod:Lerp(d.greenGain, 0, 0.1)
            end

            if proj.FrameCount % 3 == 0 then
                local blood = Isaac.Spawn(1000, 7, 0, proj.Position, Vector.Zero, proj)
				blood.SpriteScale = Vector(0.4,0.4)
				blood.Color = Color(0.2, 0.2, 0.2, 0.1, 0, 0, 0)
				blood:Update()
            end

            if not (proj.SpawnerType == EntityType.ENTITY_CLUTCH) then
                local newColor = Color.Lerp(proj.Color, color2, 0.1)
                local newerColor = Color(newColor.R, newColor.G, newColor.B, 1, 0, d.greenGain, 0)
                newerColor:SetColorize(0.6, 2.3, 0.1, 1)
                proj.Color = newerColor
            end

            local vel = Vector.Zero
            if mod:superExists(d.excluder) then
                d.speed = math.min(bal.maxSpeed, d.speed+d.accel)
                d.accel = d.accel+0.005
                vel = (d.excluder.Position-proj.Position):Resized(d.speed)

                if proj.Position:Distance(d.excluder.Position) < 5 then
                    --[[if not mod:GetEntityData(d.excluder).eternalFlickerspirited then
                        local newc = Color(d.excluder.Color.R, d.excluder.Color.G, d.excluder.Color.B, d.excluder.Color.A, d.excluder.Color.RO, d.excluder.Color.GO+0.1, d.excluder.Color.BO)
                        d.excluder:SetColor(newc, 6, 1, true, false)
                    end]]
                    sfx:Play(SoundEffect.SOUND_BISHOP_HIT, 0.1, 0, false, mod:RandomInt(250,300,proj:GetDropRNG())/100)
                    local poof = Isaac.Spawn(1000, EffectVariant.IMPACT, 0, proj.Position, Vector.Zero, proj):ToEffect()
                    poof.Color = proj.Color
                    poof.SpriteScale = Vector(proj.Scale, proj.Scale)*0.6
                    poof.SpriteOffset = Vector(0, proj.Height*0.75)
                    poof.DepthOffset = -30
                    poof:Update()
                    proj:Remove()
                end
            else
                proj.FallingSpeed = -3
                proj.FallingAccel = 1.3
                d.projType = nil
            end
            proj.Velocity = mod:Lerp(proj.Velocity, vel, 0.3)
        end
    end
end

--run through chummerpathfinder to do depthoffset stuff
function mod:excluderRender(npc, npc1)
    if mod:IsNormalRender(true) then
        local od = mod:GetEntityData(npc1)
        if npc and mod:superExists(npc) then
            local d = mod:GetEntityData(npc)
            if d.ringSize then
                local scale = d.ringSize/bal.realSize
                ring.Scale = Vector(scale, scale)
                ring.Color = Color(1, 1, 1, 1, 0, 0, 0)
                ring:Render(Isaac.WorldToScreen(npc.Position), Vector.Zero, Vector.Zero)
                od.ringSize = d.ringSize
            end
        else
            if od.ringSize then
                if not od.decrease2 then
                    od.alpha, od.decrease, od.decrease2 = 1, 0.005, 1
                end
                local scale = od.ringSize/bal.realSize
                ring.Scale = Vector(scale, scale)
                ring.Color = Color(1, 1, 1, od.alpha or 0, 0, 0, 0)
                ring:Render(Isaac.WorldToScreen(npc1.Position), Vector.Zero, Vector.Zero)
                if od.alpha > 0 then
                    od.alpha = od.alpha-od.decrease
                    od.ringSize = od.ringSize*od.decrease2
                    od.decrease = od.decrease+0.001
                    od.decrease2 = od.decrease2-0.001
                else
                    npc1:Remove()
                end
            else
                npc1:Remove()
            end
        end
    end
end