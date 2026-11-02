local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local params = ProjectileParams()
params.Variant = ProjectileVariant.PROJECTILE_BONE

local bal = {
    auraMin = 80,
    auraMax = 160,
    auraIncrease = 0.4,

    maxSpinSpeed = 10,

    randomProjSpeed = {7,10},
    targetedProjSpeed = 10,
}

local function radialJets(pos, num, dist)
    for i=1,num do
        local vec = pos + Vector(0, 1*dist):Rotated((360/num)*i)
        local firejet = Isaac.Spawn(mod.FF.RadioactiveFireJet.ID, mod.FF.RadioactiveFireJet.Var, mod.FF.RadioactiveFireJet.Sub, vec, Vector.Zero, nil):ToEffect()
        firejet:Update()
    end
end

local function popcornTrail(npc, pos, percent)
    local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HAEMO_TRAIL, 0, npc.Position+(pos-npc.Position)*percent, (pos-npc.Position):Resized(4), npc):ToEffect()
    trail.SpriteScale = Vector(1, 1)
    trail:GetSprite().PlaybackSpeed = 0.5
    local color = Color(1,1,1,1,0.3,1,0)
    color:SetColorize(1,1,1,1)
    trail.Color = color
    trail:Update()
    trail.DepthOffset = -10
end

function mod:necornierAI(npc, sprite, d)
    local rng = npc:GetDropRNG()
	local target = npc:GetPlayerTarget()
    local targetpos = mod:confusePos(npc, target.Position)
    local room = game:GetRoom()

    local confused = npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION)
    local feared = npc:HasEntityFlags(EntityFlag.FLAG_FEAR | EntityFlag.FLAG_SHRINK)

    if not d.init then
        d.ffRadioactiveEnemy = true
        npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_BLOOD_SPLASH | EntityFlag.FLAG_EXTRA_GORE)
        npc:PlaySound(SoundEffect.SOUND_FLAME_BURST, 1, 0, false, 1)

        d.state = "Idle"
        d.hurtTimer = 30
		d.init = true
	else
        d.hurtTimer = d.hurtTimer or mod:RandomInt(8,36,rng)
        if d.hurtTimer > 0 then
            d.hurtTimer = d.hurtTimer - 1
        end
        npc.StateFrame = npc.StateFrame + 1
    end

    if d.state == "Idle" or d.state == "Hit" then
        if npc.StateFrame < 40 then
            d.radAura = bal.auraMin
            mod:SetRadioactiveAura(npc, bal.auraMin)
        else
            d.radAura = d.radAura or bal.auraMin
            if d.radAura < bal.auraMax then
                d.radAura = d.radAura + bal.auraIncrease
            end
            local radFloor = math.floor(d.radAura)
            mod:SetRadioactiveAura(npc, radFloor)
        end
    end

    if d.state == "Idle" then
        mod:SpritePlay(sprite,"Idle")
        npc.SizeMulti = Vector(1,1)

        if npc.StateFrame > 160 then
            npc.StateFrame = 0
            npc:PlaySound(SoundEffect.SOUND_FLAMETHROWER_END, 0.6, 0, false, 1)
            npc:PlaySound(mod.Sounds.MDP2_PickupScream, 0.75, 0, false, 1.0)
            d.state = "ToSpin"
        end

        npc.Velocity = Vector.Zero
    elseif d.state == "Hit" then
        mod:SpritePlay(sprite,"Hit")
        npc.SizeMulti = Vector(1,1)

        if sprite:IsFinished("Hit") then
            d.hurtTimer = nil
            d.state = "Idle"
        end
        npc.Velocity = Vector.Zero
    elseif d.state == "ToSpin" then
        mod:SpritePlay(sprite,"ToSpin")
         if sprite:IsFinished("ToSpin") then
            npc.StateFrame = 0
            d.spinVel = 5
            d.state = "Spinnin"
        end
        npc.Velocity = Vector.Zero
    elseif d.state == "Spinnin" then
        mod:SpritePlay(sprite,"Spinnin")
        npc.SizeMulti = Vector(2,2)

        if not sfx:IsPlaying(SoundEffect.SOUND_ULTRA_GREED_SPINNING) then
            sfx:Play(SoundEffect.SOUND_ULTRA_GREED_SPINNING, 0.4, 0, true, 1.8)
        end

        if npc:CollidesWithGrid() then
            npc:PlaySound(mod.Sounds.BaloonBounce, 1.4, 0, false, math.random(90,120)/100)
        end

        if npc.FrameCount % 5 == 0 then
            local dust = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, 0, npc.Position, Vector(mod:RandomFloat(-3.75, 3.75), -5), nil):ToEffect()
            dust.Color = Color(0.6, 0.6, 0.6)
            dust.SpriteScale = Vector.One * 0.9
            dust.Timeout = 15
            dust.LifeSpan = 15
            dust.DepthOffset = -10000
            dust:Update()
        end

        if npc.Position:Distance(target.Position) < 150 and not (confused or feared) then
			local targAngle = (target.Position-npc.Position)
			local diff = mod:GetAngleDifference(targAngle, npc.Velocity)
			if diff < 180 then
				npc.Velocity = npc.Velocity:Rotated(1)
			elseif diff > 180 then
				npc.Velocity = npc.Velocity:Rotated(-1)
			end
		end
		if npc.Velocity:Length() < d.spinVel then
			npc.Velocity = npc.Velocity:Resized(d.spinVel)
		elseif npc.Velocity:Length() > 14 then
			npc.Velocity = npc.Velocity:Resized(14)
		end

        if npc.StateFrame < 110 then
            if npc.StateFrame < 2 then
                npc.Velocity = (targetpos-npc.Position):Resized(8)
            end
			if d.spinVel < bal.maxSpinSpeed then
				d.spinVel = d.spinVel+0.5
			end
		else
			if d.spinVel > 5 then
				d.spinVel = d.spinVel-0.12
            elseif npc.Position:Distance(room:GetCenterPos()) > 100 or npc.StateFrame > 200 then
                npc:PlaySound(mod.Sounds.MDP1_DashEnd, 1.0, 0, false, 1.0)
                sfx:Stop(SoundEffect.SOUND_ULTRA_GREED_SPINNING)
				d.state = "ToIdle"
			end
		end

        -- Spawn Popcorns
        if npc.FrameCount % 50 == 0 then
            local pos = npc.Position
            local doSpawn = false

            for i = 1, 5*#mod:FindRadiationAuras() do
                local rad = mod:ShuffleTable(mod:FindRadiationAuras())[1]
                local new_pos = rad.Position + Vector(Random() % (rad.Size - 20), 0):Rotated(Random() % 360)
                if rad.Size >= 5 and npc.Position:Distance(new_pos) < 300 and mod:getClosestPlayer(new_pos, 9999999).Position:Distance(new_pos) > 80 and room:CheckLine(new_pos, targetpos, 0, 950) and room:GetGridPathFromPos(new_pos) < 950 and new_pos:Distance(npc.Position) > 40 then
                    pos = new_pos
                    doSpawn = true
                    break
                end
            end

            if doSpawn then
                npc:SetColor(Color(1, 3, 1, 1, 0.05, 0.3, 0), 15, 1, true, false)
                npc:PlaySound(SoundEffect.SOUND_CANDLE_LIGHT,1.2,0,false,1.3)
                mod.scheduleForUpdate(function()
                    popcornTrail(npc,pos,0.2)
                end, 4)
                mod.scheduleForUpdate(function()
                    popcornTrail(npc,pos,0.35)
                end, 6)
                mod.scheduleForUpdate(function()
                    popcornTrail(npc,pos,0.5)
                end, 8)
                mod.scheduleForUpdate(function()
                    popcornTrail(npc,pos,0.65)
                end, 10)
                mod.scheduleForUpdate(function()
                    popcornTrail(npc,pos,0.8)
                end, 12)
                mod.scheduleForUpdate(function()
                    popcornTrail(npc,pos,0.95)
                end, 14)

                mod.scheduleForUpdate(function()
                    local proj = npc:FireProjectilesEx(pos, Vector(0,0), 0, params)[1]
                    
                    proj.FallingAccel = -0.1
                    proj.FallingSpeed = 0
                    proj.Height = -5
                    proj.DepthOffset = 20
                    local pSprite = proj:GetSprite()
                    proj:GetSprite():Load("gfx/bosses/propaganda/projectile_organ.anm2", true)
                    --proj:GetSprite():Play("Move")
                    pSprite:ReplaceSpritesheet(0, "gfx/projectiles/popcornbone.png", true)
                    mod:GetEntityData(proj).ffBonePopcornTarget = targetpos
                    sfx:Play(SoundEffect.SOUND_PORTAL_SPAWN, 0.5)

                    local e = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WATER_RIPPLE, 0, pos, Vector(0,0), proj):ToEffect()
                    local color = Color(1,1,1,1,0.3,1,0)
                    color:SetColorize(1,1,1,1)
                    e.Color = color
                    e.DepthOffset = 5

                    proj.Color = color
                end, 16)
            end
        end

    elseif d.state == "ToIdle" then
        mod:SpritePlay(sprite,"ToIdle")
        npc.SizeMulti = Vector(1,1)

        if sprite:IsEventTriggered("Sound") then
            npc:PlaySound(SoundEffect.SOUND_FLAME_BURST, 1, 0, false, 1)
        end

        if sprite:IsFinished("ToIdle") then
            npc.StateFrame = 0
            d.hurtTimer = 20
            d.state = "Idle"
        end
        npc.Velocity = npc.Velocity * 0.8
    end

    if npc:HasMortalDamage() then
		sfx:StopLoopingSounds()
	end

    if npc:IsDead() then
        local position = npc.Position

        mod.scheduleForUpdate(function()
            sfx:Play(SoundEffect.SOUND_FLAMETHROWER_END, 1, 0, false, 1)
            radialJets(position, 6, 35)
        end, 6)

        mod.scheduleForUpdate(function()
            radialJets(position, 8, 70)
        end, 12)

        mod.scheduleForUpdate(function()
            radialJets(position, 10, 105)
        end, 18)

        npc:PlaySound(SoundEffect.SOUND_DEATH_BURST_BONE, 1, 0, false, 1)
    end
end

function mod:necornierHurt(npc, sprite, d, amount, flags, source, cooldown)
    if d.state == "Idle" and d.hurtTimer and d.hurtTimer <= 0 then
        local rng = npc:GetDropRNG()
        d.state = "Hit"

        for i=1,5 do
            local pSpeed = mod:RandomInt(bal.randomProjSpeed[1],bal.randomProjSpeed[2],rng)
            local vec = Vector(pSpeed,0):Rotated(mod:RandomInt(1,360,rng))
            if i == 5 and mod:RandomInt(1,3,rng) < 3 then
                vec = (npc:ToNPC():GetPlayerTarget().Position-npc.Position):Resized(bal.targetedProjSpeed)
            end
            npc:ToNPC():FireProjectiles(npc.Position, vec, 0, params)

            local dust = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, 0, npc.Position, Vector(mod:RandomFloat(-6, 6), -5), nil):ToEffect()
            dust.SpriteScale = Vector.One
            dust.Timeout = 20
            dust.LifeSpan = 20
            dust.DepthOffset = -10000
            dust:Update()
        end

        npc:ToNPC():PlaySound(SoundEffect.SOUND_BONE_SNAP, 0.9, 0, false, math.random(90,120)/100)
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, function(_, npc, coll)
    if npc.Variant == mod.FF.Necornier.Var and npc:GetData().state == "Spinnin" and (coll.Type <= 1 or coll.Type > 9) then
        npc.Velocity = npc.Velocity+(npc.Position-coll.Position):Resized(8)
		coll.Velocity = coll.Velocity+(coll.Position-npc.Position):Resized(8)
        if coll.Type == EntityType.ENTITY_PLAYER then
            npc:ToNPC():PlaySound(SoundEffect.SOUND_WHIP_HIT, 0.75, 0, false, 1.1)
        end
    end
end, mod.FF.Necornier.ID)