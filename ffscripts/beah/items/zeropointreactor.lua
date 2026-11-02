local mod = FiendFolio
local game = Game()
local flag = TearFlagsLib.RegisterTearFlag("ZERO_POINT")

function mod:getTearSplitPos(pos, vel, tear)
    local room = game:GetRoom()
    local gridAtPos = room:GetGridEntityFromPos(pos)
    if gridAtPos and gridAtPos.CollisionClass > GridCollisionClass.COLLISION_PIT then
        local gridPos = gridAtPos.Position
        pos = gridPos + ((pos-gridPos) - vel:Normalized()*24)
    end
    return pos
end

local function zeroPointUpdate(_, tear)
    mod:MultiplyTearFall(tear, "sw_zeroPoint", 0.33)
    t_data = mod:GetEntityData(tear)
    if t_data.ff_noCollideFrames ~= nil then
        t_data.ff_noCollideFrames = t_data.ff_noCollideFrames - 1
        if t_data.ff_noCollideFrames <= 0 then
            t_data.ff_noCollideFrames = nil
        end
    end
	if t_data.ff_orbitEnt and t_data.ff_orbitEnt:Exists() then
		local newPos = t_data.ff_orbitEnt.Position + t_data.ff_orbitEnt.Velocity
		local oldPos = tear.TargetPosition
		if not t_data.zp_setTarget then
			oldPos = newPos
			t_data.zp_setTarget = true
		end
		tear.Position = tear.Position + newPos - oldPos
		tear.Velocity = tear.Velocity + newPos - oldPos
		tear.TargetPosition = newPos
	end
end
local function endHitSplit(tear, pos, player)
    pos = mod:getTearSplitPos(pos, tear.Velocity, tear)

    local odmg = nil
    if tear.Type == EntityType.ENTITY_FAMILIAR and tear.Variant == FamiliarVariant.ABYSS_LOCUST then
        odmg = 5.3*0.5
    end
    local new = TearFlagsLib.FireSplitTear(tear, Vector(1, 0) * player.ShotSpeed * 10, player, {
        RemoveCustomFlags = flag,
        ColorOverride = Color(-1,-1,-1,1,1,0,0),
        ScaleMult = 0.75,
        SplitTearType = "FF_ZERO_POINT",
        DamageOverride = odmg
    })

    local data = mod:GetEntityData(new)
    data.ff_zeropoint = true
    data.ff_noCollideFrames = 5
    new:SetPrismTouched(true)
    new:AddTearFlags(TearFlags.TEAR_ORBIT_ADVANCED | TearFlags.TEAR_SPECTRAL)
    new:SetColor(Color(1,1,1,0.05,2,1,1), 15, 15, true, true)
    mod:SmoothTearPositionOffset(tear, new)
    mod:AddToTearUpdateList("ff_zeropoint", new, zeroPointUpdate)
	data.ff_orbitEnt = TearFlagsLib.GetTearFlagParams(tear, flag).OrbitEnt
	
	if tear.Type == EntityType.ENTITY_FAMILIAR and tear.Variant == mod.ITEM.FAMILIAR.PLANET_X then
		TearFlagsLib.GetCustomVanillaTearFlagParams(new).ScaleOverride = nil
		TearFlagsLib.GetCustomVanillaTearFlagParams(new).ColorOverride = nil
		new.Scale = TearFlagsLib.GetCustomVanillaTearFlagParams(tear).ScaleOverride * 0.75
	end
end


mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, function (_, tear)
    local t_data = mod:GetEntityData(tear)
    if t_data.ff_noCollideFrames then
        return true
    end
end)


mod:AddCallback(ModCallbacks.MC_POST_TEAR_DEATH, function (_, tear)
    if TearFlagsLib.HasTearFlags(tear, flag) then
        local p = TearFlagsLib.GetTearPlayer(tear)
        endHitSplit(tear, tear.Position, p)
    end
end)

local function hitEnemy(_, entity, player, source, wflag)
    if wflag == TearFlagsLib.WeaponFlag.FF_PLANET_X then
		local fdata = mod:GetEntityData(source)
		if fdata.ZeroPointCooldown ~= nil then
			return
		end
	end
	if source.Type ~= EntityType.ENTITY_TEAR
    and wflag ~= TearFlagsLib.WeaponFlag.DR_FETUS
    and wflag ~= TearFlagsLib.WeaponFlag.EPIC_FETUS
    and wflag ~= TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS then
        endHitSplit(source, entity.Position, player)
		if wflag == TearFlagsLib.WeaponFlag.FF_PLANET_X then
			local fdata = mod:GetEntityData(source)
			fdata.ZeroPointCooldown = player.MaxFireDelay
		end
    end
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, hitEnemy, flag)

local oset = 24
local thing = { Vector(oset, 0), Vector(-oset, 0), Vector(0, oset), Vector(0, -oset), }
local function bombExplode(_, explosion, player)
    for i = 1, 4, 1 do
        endHitSplit(explosion, explosion.Position+thing[i], player)
    end
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_EXPLOSION_TEARFLAG_EFFECT, bombExplode, flag)

local function tearFlagComplex(_, entity, player, wflag)
    local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.ZERO_POINT_REACTOR)
    if entity.Type == EntityType.ENTITY_TEAR then
        mod.scheduleForUpdate(function ()
            if player:HasCollectible(mod.ITEM.COLLECTIBLE.ZERO_POINT_REACTOR)
            and entity.Parent and entity.Parent.Type == EntityType.ENTITY_PLAYER then
                TearFlagsLib.AddTearFlags(entity, flag)
            end
        end, 0)
    else
        if player:HasCollectible(mod.ITEM.COLLECTIBLE.ZERO_POINT_REACTOR) then
            TearFlagsLib.AddTearFlags(entity, flag)
        end
    end
end
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, mod.ITEM.COLLECTIBLE.ZERO_POINT_REACTOR, 		tearFlagComplex)

--thanks taiga 4 anath3ma 
local function evaluateLocust(_, entity, player, wflag)
    TearFlagsLib.AddTearFlags(entity, flag)
end
mod:AddEntityCallback(TearFlagsLib.Callback.POLL_LOCUST_TEARFLAGS, EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, 
                      mod.ITEM.COLLECTIBLE.ZERO_POINT_REACTOR, evaluateLocust, mod.ITEM.COLLECTIBLE.ZERO_POINT_REACTOR)

mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_CHANCELESS_TEARFLAGS, mod.ITEM.COLLECTIBLE.ZERO_POINT_REACTOR, function(_, entity, player, weaponFlag)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.ZERO_POINT_REACTOR) then
        TearFlagsLib.AddTearFlags(entity, flag)
    end
end)


mod:AddPriorityCallback(ModCallbacks.MC_PRE_TEAR_RENDER, CallbackPriority.LATE, function (_, tear, oset)
	local t_data = mod:GetEntityData(tear)
	if t_data.sw_edgingOffset then
		return t_data.sw_edgingOffset
	end
end)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.ZERO_POINT_REACTOR] = {
	BodyColor = Color(1,1,1,1,-32.301/255,-32.301/255,-32.301/255,0.735,0.735,0.735,1),
	EyeAColor = Color(1,1,1,1,255/255,-320.442/255,-320.442/255,0,2.257,2.257,1),
	EyeBColor = Color(1,1,1,1,255/255,-320.442/255,-320.442/255,0,2.257,2.257,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	TearFlagsLib.AddTearFlags(tear, flag)
	TearFlagsLib.SetTearFlagParams(tear, flag, {OrbitEnt = familiar})
end, FiendFolio.ITEM.COLLECTIBLE.ZERO_POINT_REACTOR)