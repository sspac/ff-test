local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local flag = TearFlagsLib.RegisterTearFlag("TAN")
local tanEnabled = true

--Worked fine but couldn't synergise very well
local function oldMoveInTanWave(object, data)
    data = data or TearFlagsLib.GetTearFlagParams(object, flag)
    data.tanWormStartVec = data.tanWormStartVec or object.Velocity
    data.tanWormStartPos = data.tanWormStartPos or object.Position
    local vecPos = data.tanWormStartPos + data.tanWormStartVec:Resized(object.FrameCount * data.tanWormStartVec:Length() / 3)
    local tangentSpot = math.tan((object.FrameCount * data.tanWormShotSpeed) / 20) * 25
    vecPos = vecPos + data.tanWormStartVec:Rotated(-90):Resized(tangentSpot)
    object.Velocity = (vecPos - object.Position):Normalized()
    object.Position = vecPos
	TearFlagsLib.SetTearFlagParams(object, flag, data)
end

--Locked in with this one folks
local function moveInTanWave(object, data)
    data = data or TearFlagsLib.GetTearFlagParams(object, flag)
    data.tanWormStartVec = data.tanWormStartVec or object.Velocity
    data.tanWormStartPos = data.tanWormStartPos or object.Position
    --Determines a point on the tan line the tear should try to be at
    local vecPos = data.tanWormStartPos + data.tanWormStartVec:Resized(object.FrameCount * data.tanWormStartVec:Length() / 3)
    local tangentSpot = math.tan((object.FrameCount * data.tanWormShotSpeed) / 20) * 25
    vecPos = vecPos + data.tanWormStartVec:Rotated(-90):Resized(tangentSpot)
    data.tanWormLastTangentSpot = data.tanWormLastTangentSpot or tangentSpot
    --When it goes over the infinite boundary, say fuck it
    if data.tanWormLastTangentSpot > tangentSpot then
        object.Position = vecPos
        data.tanWormLastPos = object.Position
    end
    data.tanWormLastTangentSpot = tangentSpot
    --Compare the difference between the expected line positions
    data.tanWormLastPos = data.tanWormLastPos or data.tanWormStartPos
    local vecPosDiff = (vecPos - data.tanWormLastPos)
    --Only care about the expected difference for how it should be moving
    --So it loosely follows the path but can move around on its own volition
    object.Velocity = object.Velocity + vecPosDiff
    object.Velocity = object.Velocity:Resized(vecPosDiff:Length())
    data.tanWormLastPos = vecPos
	TearFlagsLib.SetTearFlagParams(object, flag, data)
end

function mod:tanFlagGeneric(entity, player, weaponFlag)
	if mod.HasTanWorm(player) then
		TearFlagsLib.AddTearFlags(entity, flag)
		TearFlagsLib.SetTearFlagParams(entity, flag, {tanWormShotSpeed = player.ShotSpeed})
		if entity.Type == EntityType.ENTITY_TEAR then
			local color = entity.Color
			entity:ToTear():AddTearFlags(TearFlags.TEAR_SPECTRAL)
			entity.Color = color
		elseif entity.Type == EntityType.ENTITY_BOMB then
			entity:SetExplosionCountdown(math.ceil(entity:GetExplosionCountdown() * player.TearRange / 20 / 30))
		end
	end
end
mod:AddCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, mod.tanFlagGeneric)
mod:AddCallback(TearFlagsLib.Callback.POLL_CHANCELESS_TEARFLAGS, mod.tanFlagGeneric)

function mod:tanWormPostTearUpdate(tear, tdata)
    if not tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) and TearFlagsLib.HasTearFlags(tear, flag) then
        moveInTanWave(tear)
    end
end

function mod:tanWormPostBombUpdate(bomb, data)
    if TearFlagsLib.HasTearFlags(bomb, flag) then
        --Sorry bomb fans but you don't even got ring worm
        oldMoveInTanWave(bomb)
        bomb.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
    end
end

function mod.handleTanD3(entity)
	local player = TearFlagsLib.GetTearPlayer(entity)
	if player then
		TearFlagsLib.SetTearFlagParams(entity, flag, {tanWormShotSpeed = player.ShotSpeed})
	end
end