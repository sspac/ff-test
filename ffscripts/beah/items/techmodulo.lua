local mod = FiendFolio
local game = Game()
local flag = TearFlagsLib.RegisterTearFlag("MODULO")

local function DoHitscan(pos, dir, player, forceRange)
    local room = game:GetRoom()
    local _, hit = room:CheckLine(pos, pos + (dir*(forceRange or player.TearRange)), 3)
    local capsule = Capsule(pos, hit, 10)
    
    local raw_e = Isaac.FindInCapsule(capsule, EntityPartition.ENEMY)
    local e = {}
    for i = 1, #raw_e, 1 do
        local ent = raw_e[i]
        if ent:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) then
            goto continue
        end
        local dis = ent.Position:Distance(pos)
        for j = 1, #e + 1, 1 do
            local entry = e[j]
            if entry == nil or dis < entry.d then
                table.insert(e, j, { e = ent, d = dis})
                goto continue
            end
        end
        ::continue::
    end

    if e[1] ~= nil then
       return e[1].e.Position
    else
        return hit
    end
end

local osetEnoughToBeOffscreen = -600
local function FirePerpendicularLaser(_, player, tear, dmgmult, dir, flip)
    local vel = dir:Normalized()
    --local _, pos = room:CheckLine(shooter.Position, shooter.Position + vel, 0)

    local stacks = math.max(player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.TECH_MODULO), 1)
    local pos = DoHitscan(tear.Position, vel, player)
    local ang = vel:Normalized():Rotated(90)
    if flip then
        ang = ang:Rotated(180)
    end
    local otflags = player.TearFlags
    player.TearFlags = player.TearFlags | TearFlags.TEAR_SPECTRAL --if you know a better way to do this feel free to let me know! and no, laser:AddTearFlags() doesnt work
    local laser = player:FireTechLaser(pos - (ang*osetEnoughToBeOffscreen), 4, ang:Rotated(180), true, false, nil, (dmgmult*stacks))
    --laser.MaxDistance = laser.MaxDistance+700
    laser:Update()
    player.TearFlags = otflags
    laser.Parent = nil
end

local function fire(_, tear, player, wflag)
    if not player:HasCollectible(mod.ITEM.COLLECTIBLE.TECH_MODULO) then
        return
    end
    if tear.Type == EntityType.ENTITY_EFFECT then -- no aquarius creep synergy yet
        return
    end
    mod.scheduleForUpdate(function ()
        if not player or not tear.Parent or tear.Parent.Type ~= EntityType.ENTITY_PLAYER then
            return
        end
        local c_rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.TECH_MODULO)

        local dir = tear.Velocity
        local o_dmg = tear.CollisionDamage--player.Damage
        local flip = c_rng:RandomFloat() <= 0.5
        if tear.Type == EntityType.ENTITY_BOMB then
            o_dmg = tear:ToBomb().ExplosionDamage
        elseif tear.Type == EntityType.ENTITY_LASER then
            dir = Vector.FromAngle(tear:ToLaser().Angle)
            if tear.Variant == 2 and tear.FrameCount > 1 then
                return
            end
        elseif o_dmg == 0 then
            o_dmg = player.Damage
        elseif tear.Type == EntityType.ENTITY_TEAR then
            flip = tear:ToTear().TearIndex % 2 == 1
        elseif tear.Type == EntityType.ENTITY_KNIFE then
            return --ill deal with this later
        end
        FirePerpendicularLaser(_,player, tear, o_dmg/player.Damage, dir, flip)
        TearFlagsLib.AddTearFlags(tear, flag)
    end, 0)
end
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, mod.ITEM.COLLECTIBLE.TECH_MODULO, fire)

function mod.handleModuloD3(tear)
    mod.scheduleForUpdate(function ()
        local player = TearFlagsLib.GetTearPlayer(tear)
        if not player or not tear.Parent or tear.Parent.Type ~= EntityType.ENTITY_PLAYER then
            return
        end
        local c_rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.TECH_MODULO)

        local dir = tear.Velocity
        local o_dmg = tear.CollisionDamage--player.Damage
        local flip = c_rng:RandomFloat() <= 0.5
        if tear.Type == EntityType.ENTITY_BOMB then
            o_dmg = tear:ToBomb().ExplosionDamage
        elseif tear.Type == EntityType.ENTITY_LASER then
            dir = Vector.FromAngle(tear:ToLaser().Angle)
            if tear.Variant == 2 and tear.FrameCount > 1 then
                return
            end
        elseif o_dmg == 0 then
            o_dmg = player.Damage
        elseif tear.Type == EntityType.ENTITY_TEAR then
            flip = tear:ToTear().TearIndex % 2 == 1
        elseif tear.Type == EntityType.ENTITY_KNIFE then
            return --ill deal with this later
        end
        FirePerpendicularLaser(_,player, tear, o_dmg/player.Damage, dir, flip)
    end, 0)
end
--[[mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function (_, tear)
    fire(tear, tear.Velocity)
end)
mod:AddCustomCBack(mod.CustomCallbacks.SWCB_ON_LASER_FIRED, function (_, tear)
    fire(tear, Vector.FromAngle(tear.Angle))
end)
mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, function (_, bomb)
    if bomb.FrameCount ~= 1 then
        return
    end
    local player = mod:UtilGetPlayerFromTear(bomb)
    if not bomb or not bomb.IsFetus or not bomb.Parent or bomb.Parent.Type ~= EntityType.ENTITY_PLAYER then
        return
    end
    FirePerpendicularLaser(_,player,bomb, bomb.ExplosionDamage/player.Damage, bomb.Position-player.Position)
end]]

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.TECH_MODULO] = {
	TearDamage = 2.33,
	BodyColor = Color(1,1,1,1,-11.549/255,-11.549/255,-11.549/255,0.398,0.398,0.398,1),
	EyeAColor = Color(1,1,1,1,-95.625/255,-61.547/255,-61.547/255,1.375,0.453,0.453,1),
	EyeBColor = Color(1,1,1,1,-95.625/255,-61.547/255,-61.547/255,1.375,0.453,0.453,1)}

local function FirePerpendicularLaserSewing(_, familiar, tear, dmgmult, dir, flip)
    local vel = dir:Normalized()
    local pos = DoHitscan(tear.Position, vel, familiar.Player, 260)
    local ang = vel:Normalized():Rotated(90)
    if flip then
        ang = ang:Rotated(180)
    end
	
	local laser = EntityLaser.ShootAngle(2, pos - (ang*600), ang:GetAngleDegrees(), 3, Vector(0,-24), familiar)
	laser.Parent = nil
	laser.CollisionDamage = 2.33 * dmgmult
	if familiar.Player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
		local color = Color(1, 1, 1, 1, 0/255, 0/255, 0/255, 3, 1, 3.5, 1)
		laser.Color = color
		laser:AddTearFlags(TearFlags.TEAR_HOMING)
	end
	if mod:isSuperpositionedPlayer(familiar.Player) then
		local color = Color.Lerp(laser.Color, Color(1,1,1,1,0,0,0), 0)
		color.A = color.A / 4
		laser.Color = color
	end
    laser:AddTearFlags(TearFlags.TEAR_SPECTRAL)
end

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	local dir = tear.Velocity
	local o_dmg = tear.CollisionDamage
	
	local d = mod:GetEntityData(familiar)
	local flip = (d.TearIndex or 0) % 2 == 1
	d.TearIndex = (d.TearIndex or 0) + 1
	
    FirePerpendicularLaserSewing(_, familiar, tear, o_dmg / 2.33, dir, flip)
	
	tear.Scale = tear.Scale * 0.91
end, FiendFolio.ITEM.COLLECTIBLE.TECH_MODULO)