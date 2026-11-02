local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local GVals = {
    RING_INITIAL_RADIUS = 20, -- Initial radius of the ring before eyes
    EYE_RADIUS_INCREMENTER = 7, -- How much radius each eye adds

    RING_MOVEMENT_SPEED_CAP = 15, --How fast the ring can move to reach its target

    IDLE_WAIT = 60, --How long the ring waits before moving again
    MOVE_WAIT = 30, --How long it waits before moving the eyes

    PULSE_RANGE = 120, --Length of time for ring's radius to pulse in/out (idly)
    PULSE_SCALE = 10, --Size difference scale can add to the radius

    LASER_SPRITE_RADIUS_MULT = 0.5, --Cosmetic radius of the laser
    LASER_HITBOX_CAPSULE_SIZE = 10, --Changes the size of the laser hitbox
}

mod.galgalimEyeGroups = {}

mod:AddCallback(ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, function(type, var, sub, index, seed)
    mod.galgalimEyeGroups = {}
end)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
    mod.galgalimEyeGroups = {}
end)

function mod:galgalimUpdate(npc)
    local sprite, data = npc:GetSprite(), mod:GetEntityData(npc)
    local targetpos = mod:confusePos(npc, npc:GetPlayerTarget().Position)
    local rng = npc:GetDropRNG()

    if not data.Init then
        data.Init = true
        if npc.SubType > 1 and npc:Exists() then
            local headgroup = {}
            local vec = RandomVector()*10
            for i = 1, npc.SubType do
                local head = Isaac.Spawn(mod.FF.Galgalim.ID, mod.FF.Galgalim.Var, 0, npc.Position + vec:Rotated(360/i), Vector.Zero, npc.SpawnerEntity):ToNPC()
                mod:GetEntityData(head).ImBaby = true
				if npc:IsChampion() and (i == 1 or mod:GetEntityData(npc).AllChamps) then
					head:MakeChampion(69, npc:GetChampionColorIdx(), true)
					head.HitPoints = head.MaxHitPoints
				end
                table.insert(headgroup, EntityRef(head))
            end
            table.insert(mod.galgalimEyeGroups, {["Heads"] = headgroup, ["Position"] = npc.Position})
			npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            npc:Remove()
        elseif not data.ImBaby then
            table.insert(mod.galgalimEyeGroups, {["Heads"] = {EntityRef(npc)}, ["Position"] = npc.Position})
        end
    
        sprite:Play("Appear")
        data.State = "Idle"
    end

    local starePos = targetpos
    local anim = "Rotate"
    if data.GroupState and data.GroupState == "Move" then
        if data.GroupTarget then
            starePos = data.GroupTarget
            anim = "RotateMove"
        end
    end
    local playerAng = starePos - npc.Position
    playerAng = 24 - ((math.floor(playerAng:GetAngleDegrees() / 15)) - 7) % 24
    --print(playerAng)
    sprite:SetFrame(anim, playerAng)

    if data.TargetPos then
        data.TargetAngle = data.TargetAngle or mod:RandomAngle()
        data.TargetOffset = data.TargetOffset or mod:RandomInt(0,20,rng)
        if mod:RandomInt(1,5) == 1 then
            data.TargetAngle = data.TargetAngle + mod:RandomInt(-45,45,rng)
            data.TargetOffset = mod:RandomInt(0,20,rng)
        end
        npc.TargetPosition = data.TargetPos + Vector(data.TargetOffset,0):Rotated(data.TargetAngle)

        local vel = (npc.TargetPosition - npc.Position)
        vel = vel:Resized(math.min(12, vel:Length()))
        npc.Velocity = mod:Lerp(npc.Velocity, vel, 0.05)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    for i = 1, #mod.galgalimEyeGroups do 
        mod:galgalimGroupControl(mod.galgalimEyeGroups[i], i)
    end
end)

function mod:galgalimGroupControl(group, index) --Adapted from shrunken heads
    local room = game:GetRoom()
    group.StateFrame = group.StateFrame or mod:RandomInt(GVals.MOVE_WAIT)
    group.StateFrame = group.StateFrame + 1
    group.PulseOffset = group.PulseOffset or mod:RandomInt(GVals.PULSE_RANGE)
    group.PulseOffset = (group.PulseOffset + 1) % GVals.PULSE_RANGE
    group.State = group.State or "Idle"

    local heads = {}
    for _, headref in pairs(group.Heads) do
        if headref.Entity then
            if mod:IsReallyDead(headref.Entity) then
                headref.Entity = nil
            else
                table.insert(heads, headref.Entity)
            end
        end
    end
    local count = #heads
    --print(count)
    if count > 0 then
        if (not group.Laser) then
            group.Laser = EntityLaser.ShootAngle(5, group.Position, 0, 30, Vector(0, -10), heads[1]):ToLaser()
            group.Laser.SpawnerEntity = heads[i]
            group.Laser.SpawnerType = mod.FF.Galgalim.ID
            group.Laser.SpawnerVariant = mod.FF.Galgalim.Var
            local gLaserSprite = group.Laser:GetSprite()
            gLaserSprite:Load("gfx/enemies/galgalim/galgalim_beam.anm2",true)
            gLaserSprite:Play("LargeRedLaser", true)
            group.Laser.SubType = 1
            group.Laser.Radius = 5
            group.Laser:Update()
            sfx:Stop(SoundEffect.SOUND_ANGEL_BEAM)
            sfx:Play(SoundEffect.SOUND_LIGHTBOLT, 1, 0, false, mod:RandomInt(70,100)/100)
        end
        if group.State == "Idle" then
            group.Position = group.Laser.Position + RandomVector()
            if group.StateFrame > GVals.IDLE_WAIT then
                group.State = "Move"
                local targ = heads[1]:ToNPC():GetPlayerTarget().Position
                group.TargetPos = targ
                group.StateFrame = 0
                sfx:Play(SoundEffect.SOUND_LIGHTBOLT_CHARGE, 1, 0, false, mod:RandomInt(70,100)/100)
            end
        elseif group.State == "Move" then
            local targVec = (group.TargetPos - group.Laser.Position) * 0.1
            if targVec:Length() > GVals.RING_MOVEMENT_SPEED_CAP then
                targVec = targVec:Resized(GVals.RING_MOVEMENT_SPEED_CAP)
            end
            group.Laser.Velocity = mod:Lerp(group.Laser.Velocity,targVec, 0.2)

            if group.StateFrame > GVals.MOVE_WAIT then
                group.StateFrame = 0
                group.State = "Idle"
                group.Position = group.Laser.Position
            end
        end
        for _, head in pairs(heads) do
            mod:GetEntityData(head).TargetPos = group.Position
            mod:GetEntityData(head).GroupState = group.State
            mod:GetEntityData(head).GroupTarget = group.TargetPos
        end
        if group.Laser then
            local pulseVal = math.sin((math.pi / GVals.PULSE_RANGE) * group.PulseOffset) * GVals.PULSE_SCALE
            group.Laser.Radius = mod:Lerp(group.Laser.Radius, 20 + (7 * #heads) + pulseVal, 0.3)
            group.Laser.Velocity = (group.Laser.Velocity * 0.9) + (RandomVector() * 0.25)
            group.Laser.SpriteScale = Vector(GVals.LASER_SPRITE_RADIUS_MULT,1)
            group.Laser.Size = GVals.LASER_HITBOX_CAPSULE_SIZE
        end
    else
        if group.Laser then
            group.Laser.Radius = mod:Lerp(group.Laser.Radius, 0, 0.4)
            if group.Laser.Radius < 3 then
                sfx:Play(SoundEffect.SOUND_BISHOP_HIT, 1, 0, false, 0.5)
                sfx:Play(SoundEffect.SOUND_HOLY, 1, 0, false, 0.75)
                local poof = Isaac.Spawn(1000, 15, 0, group.Laser.Position, Vector.Zero, nil)
                local poofData = mod:GetEntityData(poof)
                local poofSprite = poof:GetSprite()
                poof.Color = Color(1,1,175/255,0.5)
                poofSprite:Load("gfx/1000.144_enemy ghost.anm2", true)
	            poofSprite:Play("Explosion")
                --mod.XalumDamageInArea(nil, 40)
                group.Laser:Remove()
                group.Laser = nil
            end
        else
            group = nil
        end
    end
end
mod:AddEntityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.FF.Galgalim.ID, mod.FF.Galgalim.Var, -1,
function(_, entity, damage, flag, source)
    if entity:ToNPC() then
        if flag & DamageFlag.DAMAGE_LASER ~= 0 then
            if source then
                spawnType = source.SpawnerType
                spawnVar = source.SpawnerVariant
                if (spawnType and spawnType == mod.FF.Galgalim.ID)
                and (spawnVar and spawnVar == mod.FF.Galgalim.Var)
                then
                    return false
                end
            end
        end
    end
end)