local mod = FiendFolio
local game = Game()
local roomIsRetconned = false
-- GetData is bad, I wonder if I can just not use entity data at all outside of storing rng

mod.RetconEntities = {
	[mod.FF.Retcon.ID .. "." .. mod.FF.Retcon.Var] = true
}

local retconConfigs = {}
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	retconConfigs = {}
	roomIsRetconned = false
end)

local function entityIsRetcon(entity)
	return mod.RetconEntities[entity.Type .. "." .. entity.Variant]
end

local function replaceRoomLayout(config)
	--[[
		Retain retcons
		Reposition players?
	]]

	local room = game:GetRoom()
	local levelRoom = StageAPI.LevelRoom{
		Layout = StageAPI.GenerateRoomLayoutFromData(config),
		IgnoreDoors = true,
		IgnoreShape = true,
		Shape = room:GetRoomShape(),
		RoomType = room:GetType(),
		RequireRoomType = false,
	}

	levelRoom:Load()
end

function mod.TestRetcon()
	local level = game:GetLevel()
	local room = game:GetRoom()
	local currentRoom = level:GetCurrentRoomDesc()

	local new = RoomConfig.GetRandomRoom(
		math.ceil(math.random() * 100000000),		-- Seed
		false,			-- ReduceWeight
		StbType.BASEMENT,
		room:GetType(),
		room:GetRoomShape(),
		0,
		-1,
		currentRoom.Data.Difficulty,
		currentRoom.Data.Difficulty,
		currentRoom.AllowedDoors,
		currentRoom.Data.Subtype,
		currentRoom.Data.Mode
	)

	local layout = StageAPI.GenerateRoomLayoutFromData(new)
	local levelRoom = StageAPI.LevelRoom{
		Layout = layout,
		IgnoreDoors = true,
		IgnoreShape = true,
		Shape = room:GetRoomShape(),
		RoomType = room:GetType(),
		RequireRoomType = false,
	}
end

function mod.RetconRoom(rng)
	local level = game:GetLevel()
	local room = game:GetRoom()
	local currentRoom = level:GetCurrentRoomDesc()

	if not roomIsRetconned then
		table.insert(retconConfigs, currentRoom.Data)
	end

	local new = RoomConfig.GetRandomRoom(
		rng:Next(),		-- Seed
		false,			-- ReduceWeight
		StbType.BASEMENT,
		room:GetType(),
		room:GetRoomShape(),
		0,
		-1,
		currentRoom.Data.Difficulty,
		currentRoom.Data.Difficulty,
		currentRoom.AllowedDoors,
		currentRoom.Data.Subtype,
		currentRoom.Data.Mode
	)

	table.insert(retconConfigs, new)
	replaceRoomLayout(new)
	roomIsRetconned = true
end

function mod.RestoreRetconnedRoom()
	-- replaceRoomLayour(originalConfig)
	roomIsRetconned = false
end

function mod.IsRoomRetconned()
	return roomIsRetconned
end

return {
	Init = function(npc)
		local data = mod:GetEntityData(npc)
		data.rng = RNG(npc.InitSeed)
	end,

	AI = function(npc)
		local sprite = npc:GetSprite()

		if sprite:IsFinished("Appear") or sprite:IsFinished("Move") then
			sprite:Play("Idle")
			npc.State = NpcState.STATE_IDLE
		end

		if npc.FrameCount % 5 == 0 and sprite:IsPlaying("Idle") then
			local rng = mod:GetEntityData(npc).rng
			if rng:RandomFloat() < 1/3 then
				sprite:Play("Move")
				npc.V1 = Vector.FromAngle(rng:RandomFloat() * 360) * 5
			end
		end

		if sprite:IsEventTriggered("Jump") then
			npc.State = NpcState.STATE_MOVE
		elseif sprite:IsEventTriggered("Land") then
			npc.State = NpcState.STATE_IDLE
		end

		if npc.State == NpcState.STATE_IDLE then
			npc.Velocity = npc.Velocity:Lerp(Vector.Zero, 0.25)
		elseif npc.State == NpcState.STATE_MOVE then
			npc.Velocity = npc.Velocity:Lerp(npc.V1, 0.6)
		end
	end,

	Death = function(npc)
		-- mod.RetconRoom(mod:GetEntityData(npc).rng)
	end,
}