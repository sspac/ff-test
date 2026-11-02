-- Baby Bubbles --

-- welcome to the reason why so much optimization work has to be done for ff
-- at some point everything began to lag so much that having this many projectiles/bubbles on screen is unreasonable
-- making this boss work is my white whale
-- baby bubbles must be real
-- if you can read this message, dear player, then know that i was successful

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local BABY_BUBBLES_RADIUS = 40
local LEPER_BUBBLE_RADIUS = 10
local SMALL_BUBBLE_RADIUS = 10

local ATTACK_COOLDOWN = 30

local BUBBLE_PUMP_BUBBLE_PATTERNS = {
	{mod.FF.BubbleLeper.Sub, mod.FF.BubbleLeper.Sub, mod.FF.BubbleLeper.Sub, mod.FF.BubbleLeper.Sub, mod.FF.BubbleLeper.Sub, mod.FF.BubbleLeper.Sub, 
	 mod.FF.BubbleLeper.Sub, mod.FF.BubbleLeper.Sub, mod.FF.BubbleLeper.Sub, mod.FF.BubbleLeper.Sub, mod.FF.BubbleLeper.Sub, mod.FF.BubbleLeper.Sub},
	{mod.FF.BubbleLeper.Sub, mod.FF.BubbleLeper.Sub, mod.FF.BubbleLargeLeper.Sub,
	 mod.FF.BubbleLeper.Sub, mod.FF.BubbleLeper.Sub, mod.FF.BubbleLargeLeper.Sub,
	 mod.FF.BubbleLeper.Sub, mod.FF.BubbleLeper.Sub, mod.FF.BubbleLargeLeper.Sub,
	 mod.FF.BubbleLeper.Sub, mod.FF.BubbleLeper.Sub, mod.FF.BubbleLargeLeper.Sub},
	{mod.FF.BubbleLeper.Sub, mod.FF.BubbleLargeLeper.Sub, 
	 mod.FF.BubbleLeper.Sub, mod.FF.BubbleLargeLeper.Sub, 
	 mod.FF.BubbleLeper.Sub, mod.FF.BubbleLargeLeper.Sub, 
	 mod.FF.BubbleLeper.Sub, mod.FF.BubbleLargeLeper.Sub, 
	 mod.FF.BubbleLeper.Sub, mod.FF.BubbleLargeLeper.Sub, 
	 mod.FF.BubbleLeper.Sub, mod.FF.BubbleLargeLeper.Sub},
}
local BUBBLE_PUMP_SPAWN_RADIUS = 120
local BUBBLE_PUMP_TIME_TO_RISE = 12
local BUBBLE_PUMP_COOLDOWN = 30
local BUBBLE_PUMP_ANGLE_RAND_OFFSET = 6.25
local BUBBLE_PUMP_FOLLOW_TARGET = true

local RING_MAX_TIMES = 3
local RING_NUM_PROJ = 40
local RING_NUM_BULLET_SECTION = 5
local RING_NUM_BUBBLE_SECTION = 3
local RING_PROJ_INIT_VEL = 1
local RING_PROJ_ACCEL_MULT = 1.04
local RING_SPAWN_OFFSET = 5
local RING_SPURT_POSITIONS = {
	{Vector(-38,-32), true, -1},
	{Vector(-8,-65), true, 1},
	{Vector(28,-35), false, 1},
	{Vector(41,-15), false, -1},
}

local PARTIAL_SUBMERGE_FRAMES = 180
local PARTIAL_EMERGE_FRAMES = 30
local PARTIAL_VEL = 7.5
local PARTIAL_LERP = 0.1
local PARTIAL_BUBBLE_SPAWN_COOLDOWN = 3
local PARTIAL_SPURT_COOLDOWN = 9
local PARTIAL_PIPE_COOLDOWN = 25
local PARTIAL_BUBBLE_TIME_TO_BURST = 90
local PARTIAL_BUBBLE_TIME_TO_BURST_RANGE = 15
local PARTIAL_BUBBLE_VEL = 1.5
local PARTIAL_SPAWN_POSITIONS = {
	Vector(-40,2),
	Vector(-12,-8),
	Vector(31,5),
}
local PARTIAL_PIPE_VEL = 6.5
local PARTIAL_PIPE_SPREAD_ANGLE = 35

local STREAM_MAX_TIMES = 3
local STREAM_BUBBLES_PER_TILE = 2
local STREAM_BUBBLE_POS_LERP = 0.07
local STREAM_BUBBLE_MAX_LERP_FRAMES = 60
local STREAM_BUBBLE_POP_ON_FRAME = 45
local STREAM_BUBBLE_ANGLE_RANGE = 30
local STREAM_BLOODY_EVERY_X_BUBBLES_VERT = 6
local STREAM_BLOODY_EVERY_X_BUBBLES_HORI = 8
local STREAM_BLOODY_MIN_STARTING_EVERY_X_VERT = 6
local STREAM_BLOODY_MIN_STARTING_EVERY_X_HORI = 6
local STREAM_FOR_X_FRAMES = 23
local STREAM_FINISH_MAX_FRAMES = 30

local SCREAM_MAX_TIMES = 3
local SCREAM_MAX_FRAMES = 64
local SCREAM_VEL = 1.5
local SCREAM_LERP = 0.1
local SCREAM_PIPE_EVERY_X_FRAMES = 25
local SCREAM_PIPE_INITIAL_DELAY = 10
local SCREAM_MAX_PIPES = 10
local SCREAM_DIST_PER_STEP = 30
local SCREAM_BUBBLES_PER_STEP = 1
local SCREAM_BUBBLE_POS_LERP = 0.045
local SCREAM_BUBBLE_MAX_LERP_FRAMES = 75
local SCREAM_BUBBLE_TIMEOUT = 75
local SCREAM_BUBBLE_ANGLE_RANGE = 30
local SCREAM_BUBBLE_RADIUS_FROM_STEP = 7.5
local SCREAM_BUBBLE_STEPS = 5
local SCREAM_BUBBLE_AFTER_STEPS = 4
local SCREAM_NUM_PROJ = 8
local SCREAM_PROJ_VEL = 4
local SCREAM_PROJ_SPAWN_OFFSET = 5
local SCREAM_PROJ_COOLDOWN = 32
local SCREAM_PROJ_ROTATE_VEL = 4.5
local SCREAM_PROJ_TIMEOUT = 180

local PROVIDENCE_MAX_FRAMES = 210
local PROVIDENCE_INIT_ACCEL = 0.005
local PROVIDENCE_ACCEL_ACCEL = 0.0015
local PROVIDENCE_INIT_SPEED = 2
local PROVIDENCE_MAX_SPEED = 11
local PROVIDENCE_GAP = 120
local PROVIDENCE_BULLET_MAX_SPEED = 9.5
local PROVIDENCE_BULLET_ACCEL_MULT = 1.6
local PROVIDENCE_SPURT_POSITIONS = {
	{Vector(-32,-26), true, 1},
	{Vector(-12,-28), true, 1},
	{Vector(25,-30), false, -1},
	{Vector(35,-17), false, 1},
}

local BRIMSTONE_BUBBLE_SIZEMULT = 3
local BRIMSTONE_BUBBLE_SIZEMULT_LERP = 1/18
local BRIMSTONE_BUBBLE_VEL = 8
local BRIMSTONE_BUBBLE_ANGLE = 15
local BRIMSTONE_BUBBLE_ANGLE_GAP = 15

local function isNoOrPitColl(gridcoll)
	return gridcoll == GridCollisionClass.COLLISION_NONE or gridcoll == GridCollisionClass.COLLISION_PIT
end

-- Modified from ffscripts/erfly/enemies/_shared.lua
local function findRandomTelePos(npc, radius, findnear, avoidplayer, avoidfire, maxrad)
radius = radius or 0
local validPositions = {}
local validPositionsFar = {}
local validPositionsNear = {}
local room = game:GetRoom()
local topleft = room:GetTopLeftPos()
local bottomright = room:GetBottomRightPos()
local size = room:GetGridSize()
	for i=0, size do
		local gridpos = room:GetGridPosition(i)
		--local gridEntity = room:GetGridEntity(i)
		if isNoOrPitColl(room:GetGridCollisionAtPos(gridpos)) and 
		   isNoOrPitColl(room:GetGridCollisionAtPos(room:GetGridPosition(i-1))) and
		   isNoOrPitColl(room:GetGridCollisionAtPos(room:GetGridPosition(i+1))) and
		   room:IsPositionInRoom(gridpos, 0)
		then
			if (avoidplayer == nil or (avoidplayer and (npc:GetPlayerTarget().Position + (npc:GetPlayerTarget().Velocity * 3)):Distance(gridpos) > 100)) 
			and (avoidfire == nil or (avoidfire and not mod:IsCampfireWithinRadius(gridpos, 40)))
			then
				table.insert(validPositions, gridpos)
				if npc.Position:Distance(gridpos)> radius then
					if maxrad then
						if npc.Position:Distance(gridpos) < maxrad then
							table.insert(validPositionsFar, gridpos)
						end
					else
						table.insert(validPositionsFar, gridpos)
					end
				end
				if npc.Position:Distance(gridpos)< radius then
					if maxrad then
						if npc.Position:Distance(gridpos) > maxrad then
							table.insert(validPositionsNear, gridpos)
						end
					else
						table.insert(validPositionsNear, gridpos)
					end
				end
			end
		end
	end
	if #validPositionsNear > 0 and findnear then
		return validPositionsNear[math.random(#validPositionsNear)]
	elseif #validPositionsFar > 0 and not findnear then
		return validPositionsFar[math.random(#validPositionsFar)]
	elseif #validPositions > 0 then
		return validPositions[math.random(#validPositions)]
	else
		return room:GetRandomPosition(1)
	end
end

local wallTilesForRoomshape = {}
wallTilesForRoomshape[RoomShape.ROOMSHAPE_1x1] = {
	{1, Direction.DOWN},
	{2, Direction.DOWN},
	{3, Direction.DOWN},
	{4, Direction.DOWN},
	{5, Direction.DOWN},
	{6, Direction.DOWN},
	{7, Direction.DOWN},
	{8, Direction.DOWN},
	{9, Direction.DOWN},
	{10, Direction.DOWN},
	{11, Direction.DOWN},
	{12, Direction.DOWN},
	{13, Direction.DOWN},
	{15, Direction.RIGHT},
	{30, Direction.RIGHT},
	{45, Direction.RIGHT},
	{60, Direction.RIGHT},
	{75, Direction.RIGHT},
	{90, Direction.RIGHT},
	{105, Direction.RIGHT},
	{29, Direction.LEFT},
	{44, Direction.LEFT},
	{59, Direction.LEFT},
	{74, Direction.LEFT},
	{89, Direction.LEFT},
	{104, Direction.LEFT},
	{119, Direction.LEFT},
	{121, Direction.UP},
	{122, Direction.UP},
	{123, Direction.UP},
	{124, Direction.UP},
	{125, Direction.UP},
	{126, Direction.UP},
	{127, Direction.UP},
	{128, Direction.UP},
	{129, Direction.UP},
	{130, Direction.UP},
	{131, Direction.UP},
	{132, Direction.UP},
	{133, Direction.UP},
}
wallTilesForRoomshape[RoomShape.ROOMSHAPE_IH] = {
	{31, Direction.DOWN},
	{32, Direction.DOWN},
	{33, Direction.DOWN},
	{34, Direction.DOWN},
	{35, Direction.DOWN},
	{36, Direction.DOWN},
	{37, Direction.DOWN},
	{38, Direction.DOWN},
	{39, Direction.DOWN},
	{40, Direction.DOWN},
	{41, Direction.DOWN},
	{42, Direction.DOWN},
	{43, Direction.DOWN},
	{45, Direction.RIGHT},
	{60, Direction.RIGHT},
	{75, Direction.RIGHT},
	{59, Direction.LEFT},
	{74, Direction.LEFT},
	{89, Direction.LEFT},
	{91, Direction.UP},
	{92, Direction.UP},
	{93, Direction.UP},
	{94, Direction.UP},
	{95, Direction.UP},
	{96, Direction.UP},
	{97, Direction.UP},
	{98, Direction.UP},
	{99, Direction.UP},
	{100, Direction.UP},
	{101, Direction.UP},
	{102, Direction.UP},
	{103, Direction.UP},
}
wallTilesForRoomshape[RoomShape.ROOMSHAPE_IV] = {
	{5, Direction.DOWN},
	{6, Direction.DOWN},
	{7, Direction.DOWN},
	{8, Direction.DOWN},
	{9, Direction.DOWN},
	{19, Direction.RIGHT},
	{34, Direction.RIGHT},
	{49, Direction.RIGHT},
	{64, Direction.RIGHT},
	{79, Direction.RIGHT},
	{94, Direction.RIGHT},
	{109, Direction.RIGHT},
	{25, Direction.LEFT},
	{40, Direction.LEFT},
	{55, Direction.LEFT},
	{70, Direction.LEFT},
	{85, Direction.LEFT},
	{100, Direction.LEFT},
	{115, Direction.LEFT},
	{125, Direction.UP},
	{126, Direction.UP},
	{127, Direction.UP},
	{128, Direction.UP},
	{129, Direction.UP},
}
wallTilesForRoomshape[RoomShape.ROOMSHAPE_1x2] = {
	{1, Direction.DOWN},
	{2, Direction.DOWN},
	{3, Direction.DOWN},
	{4, Direction.DOWN},
	{5, Direction.DOWN},
	{6, Direction.DOWN},
	{7, Direction.DOWN},
	{8, Direction.DOWN},
	{9, Direction.DOWN},
	{10, Direction.DOWN},
	{11, Direction.DOWN},
	{12, Direction.DOWN},
	{13, Direction.DOWN},
	{15, Direction.RIGHT},
	{30, Direction.RIGHT},
	{45, Direction.RIGHT},
	{60, Direction.RIGHT},
	{75, Direction.RIGHT},
	{90, Direction.RIGHT},
	{105, Direction.RIGHT},
	{120, Direction.RIGHT},
	{135, Direction.RIGHT},
	{150, Direction.RIGHT},
	{165, Direction.RIGHT},
	{180, Direction.RIGHT},
	{195, Direction.RIGHT},
	{210, Direction.RIGHT},
	{29, Direction.LEFT},
	{44, Direction.LEFT},
	{59, Direction.LEFT},
	{74, Direction.LEFT},
	{89, Direction.LEFT},
	{104, Direction.LEFT},
	{119, Direction.LEFT},
	{134, Direction.LEFT},
	{149, Direction.LEFT},
	{164, Direction.LEFT},
	{179, Direction.LEFT},
	{194, Direction.LEFT},
	{209, Direction.LEFT},
	{224, Direction.LEFT},
	{226, Direction.UP},
	{227, Direction.UP},
	{228, Direction.UP},
	{229, Direction.UP},
	{230, Direction.UP},
	{231, Direction.UP},
	{232, Direction.UP},
	{233, Direction.UP},
	{234, Direction.UP},
	{235, Direction.UP},
	{236, Direction.UP},
	{237, Direction.UP},
	{238, Direction.UP},
}
wallTilesForRoomshape[RoomShape.ROOMSHAPE_IIV] = {
	{5, Direction.DOWN},
	{6, Direction.DOWN},
	{7, Direction.DOWN},
	{8, Direction.DOWN},
	{9, Direction.DOWN},
	{19, Direction.RIGHT},
	{34, Direction.RIGHT},
	{49, Direction.RIGHT},
	{64, Direction.RIGHT},
	{79, Direction.RIGHT},
	{94, Direction.RIGHT},
	{109, Direction.RIGHT},
	{124, Direction.RIGHT},
	{139, Direction.RIGHT},
	{154, Direction.RIGHT},
	{169, Direction.RIGHT},
	{184, Direction.RIGHT},
	{199, Direction.RIGHT},
	{214, Direction.RIGHT},
	{25, Direction.LEFT},
	{40, Direction.LEFT},
	{55, Direction.LEFT},
	{70, Direction.LEFT},
	{85, Direction.LEFT},
	{100, Direction.LEFT},
	{115, Direction.LEFT},
	{130, Direction.LEFT},
	{145, Direction.LEFT},
	{160, Direction.LEFT},
	{175, Direction.LEFT},
	{190, Direction.LEFT},
	{205, Direction.LEFT},
	{220, Direction.LEFT},
	{230, Direction.UP},
	{231, Direction.UP},
	{232, Direction.UP},
	{233, Direction.UP},
	{234, Direction.UP},
}
wallTilesForRoomshape[RoomShape.ROOMSHAPE_2x1] = {
	{1, Direction.DOWN},
	{2, Direction.DOWN},
	{3, Direction.DOWN},
	{4, Direction.DOWN},
	{5, Direction.DOWN},
	{6, Direction.DOWN},
	{7, Direction.DOWN},
	{8, Direction.DOWN},
	{9, Direction.DOWN},
	{10, Direction.DOWN},
	{11, Direction.DOWN},
	{12, Direction.DOWN},
	{13, Direction.DOWN},
	{14, Direction.DOWN},
	{15, Direction.DOWN},
	{16, Direction.DOWN},
	{17, Direction.DOWN},
	{18, Direction.DOWN},
	{19, Direction.DOWN},
	{20, Direction.DOWN},
	{21, Direction.DOWN},
	{22, Direction.DOWN},
	{23, Direction.DOWN},
	{24, Direction.DOWN},
	{25, Direction.DOWN},
	{26, Direction.DOWN},
	{28, Direction.RIGHT},
	{56, Direction.RIGHT},
	{84, Direction.RIGHT},
	{112, Direction.RIGHT},
	{140, Direction.RIGHT},
	{168, Direction.RIGHT},
	{196, Direction.RIGHT},
	{55, Direction.LEFT},
	{83, Direction.LEFT},
	{111, Direction.LEFT},
	{139, Direction.LEFT},
	{167, Direction.LEFT},
	{195, Direction.LEFT},
	{223, Direction.LEFT},
	{225, Direction.UP},
	{226, Direction.UP},
	{227, Direction.UP},
	{228, Direction.UP},
	{229, Direction.UP},
	{230, Direction.UP},
	{231, Direction.UP},
	{232, Direction.UP},
	{233, Direction.UP},
	{234, Direction.UP},
	{235, Direction.UP},
	{236, Direction.UP},
	{237, Direction.UP},
	{238, Direction.UP},
	{239, Direction.UP},
	{240, Direction.UP},
	{241, Direction.UP},
	{242, Direction.UP},
	{243, Direction.UP},
	{244, Direction.UP},
	{245, Direction.UP},
	{246, Direction.UP},
	{247, Direction.UP},
	{248, Direction.UP},
	{249, Direction.UP},
	{250, Direction.UP},
}
wallTilesForRoomshape[RoomShape.ROOMSHAPE_IIH] = {
	{57, Direction.DOWN},
	{58, Direction.DOWN},
	{59, Direction.DOWN},
	{60, Direction.DOWN},
	{61, Direction.DOWN},
	{62, Direction.DOWN},
	{63, Direction.DOWN},
	{64, Direction.DOWN},
	{65, Direction.DOWN},
	{66, Direction.DOWN},
	{67, Direction.DOWN},
	{68, Direction.DOWN},
	{69, Direction.DOWN},
	{70, Direction.DOWN},
	{71, Direction.DOWN},
	{72, Direction.DOWN},
	{73, Direction.DOWN},
	{74, Direction.DOWN},
	{75, Direction.DOWN},
	{76, Direction.DOWN},
	{77, Direction.DOWN},
	{78, Direction.DOWN},
	{79, Direction.DOWN},
	{80, Direction.DOWN},
	{81, Direction.DOWN},
	{82, Direction.DOWN},
	{84, Direction.RIGHT},
	{112, Direction.RIGHT},
	{140, Direction.RIGHT},
	{111, Direction.LEFT},
	{139, Direction.LEFT},
	{167, Direction.LEFT},
	{169, Direction.UP},
	{170, Direction.UP},
	{171, Direction.UP},
	{172, Direction.UP},
	{173, Direction.UP},
	{174, Direction.UP},
	{175, Direction.UP},
	{176, Direction.UP},
	{177, Direction.UP},
	{178, Direction.UP},
	{179, Direction.UP},
	{180, Direction.UP},
	{181, Direction.UP},
	{182, Direction.UP},
	{183, Direction.UP},
	{184, Direction.UP},
	{185, Direction.UP},
	{186, Direction.UP},
	{187, Direction.UP},
	{188, Direction.UP},
	{189, Direction.UP},
	{190, Direction.UP},
	{191, Direction.UP},
	{192, Direction.UP},
	{193, Direction.UP},
	{194, Direction.UP},
}
wallTilesForRoomshape[RoomShape.ROOMSHAPE_2x2] = {
	{1, Direction.DOWN},
	{2, Direction.DOWN},
	{3, Direction.DOWN},
	{4, Direction.DOWN},
	{5, Direction.DOWN},
	{6, Direction.DOWN},
	{7, Direction.DOWN},
	{8, Direction.DOWN},
	{9, Direction.DOWN},
	{10, Direction.DOWN},
	{11, Direction.DOWN},
	{12, Direction.DOWN},
	{13, Direction.DOWN},
	{14, Direction.DOWN},
	{15, Direction.DOWN},
	{16, Direction.DOWN},
	{17, Direction.DOWN},
	{18, Direction.DOWN},
	{19, Direction.DOWN},
	{20, Direction.DOWN},
	{21, Direction.DOWN},
	{22, Direction.DOWN},
	{23, Direction.DOWN},
	{24, Direction.DOWN},
	{25, Direction.DOWN},
	{26, Direction.DOWN},
	{28, Direction.RIGHT},
	{56, Direction.RIGHT},
	{84, Direction.RIGHT},
	{112, Direction.RIGHT},
	{140, Direction.RIGHT},
	{168, Direction.RIGHT},
	{196, Direction.RIGHT},
	{224, Direction.RIGHT},
	{252, Direction.RIGHT},
	{280, Direction.RIGHT},
	{308, Direction.RIGHT},
	{336, Direction.RIGHT},
	{364, Direction.RIGHT},
	{392, Direction.RIGHT},
	{55, Direction.LEFT},
	{83, Direction.LEFT},
	{111, Direction.LEFT},
	{139, Direction.LEFT},
	{167, Direction.LEFT},
	{195, Direction.LEFT},
	{223, Direction.LEFT},
	{251, Direction.LEFT},
	{279, Direction.LEFT},
	{307, Direction.LEFT},
	{335, Direction.LEFT},
	{363, Direction.LEFT},
	{391, Direction.LEFT},
	{419, Direction.LEFT},
	{421, Direction.UP},
	{422, Direction.UP},
	{423, Direction.UP},
	{424, Direction.UP},
	{425, Direction.UP},
	{426, Direction.UP},
	{427, Direction.UP},
	{428, Direction.UP},
	{429, Direction.UP},
	{430, Direction.UP},
	{431, Direction.UP},
	{432, Direction.UP},
	{433, Direction.UP},
	{434, Direction.UP},
	{435, Direction.UP},
	{436, Direction.UP},
	{437, Direction.UP},
	{438, Direction.UP},
	{439, Direction.UP},
	{440, Direction.UP},
	{441, Direction.UP},
	{442, Direction.UP},
	{443, Direction.UP},
	{444, Direction.UP},
	{445, Direction.UP},
	{446, Direction.UP},
}
wallTilesForRoomshape[RoomShape.ROOMSHAPE_LTL] = {
	{197, Direction.DOWN},
	{198, Direction.DOWN},
	{199, Direction.DOWN},
	{200, Direction.DOWN},
	{201, Direction.DOWN},
	{202, Direction.DOWN},
	{203, Direction.DOWN},
	{204, Direction.DOWN},
	{205, Direction.DOWN},
	{206, Direction.DOWN},
	{207, Direction.DOWN},
	{208, Direction.DOWN},
	{14, Direction.DOWN},
	{15, Direction.DOWN},
	{16, Direction.DOWN},
	{17, Direction.DOWN},
	{18, Direction.DOWN},
	{19, Direction.DOWN},
	{20, Direction.DOWN},
	{21, Direction.DOWN},
	{22, Direction.DOWN},
	{23, Direction.DOWN},
	{24, Direction.DOWN},
	{25, Direction.DOWN},
	{26, Direction.DOWN},
	{41, Direction.RIGHT},
	{69, Direction.RIGHT},
	{97, Direction.RIGHT},
	{125, Direction.RIGHT},
	{153, Direction.RIGHT},
	{181, Direction.RIGHT},
	{224, Direction.RIGHT},
	{252, Direction.RIGHT},
	{280, Direction.RIGHT},
	{308, Direction.RIGHT},
	{336, Direction.RIGHT},
	{364, Direction.RIGHT},
	{392, Direction.RIGHT},
	{55, Direction.LEFT},
	{83, Direction.LEFT},
	{111, Direction.LEFT},
	{139, Direction.LEFT},
	{167, Direction.LEFT},
	{195, Direction.LEFT},
	{223, Direction.LEFT},
	{251, Direction.LEFT},
	{279, Direction.LEFT},
	{307, Direction.LEFT},
	{335, Direction.LEFT},
	{363, Direction.LEFT},
	{391, Direction.LEFT},
	{419, Direction.LEFT},
	{421, Direction.UP},
	{422, Direction.UP},
	{423, Direction.UP},
	{424, Direction.UP},
	{425, Direction.UP},
	{426, Direction.UP},
	{427, Direction.UP},
	{428, Direction.UP},
	{429, Direction.UP},
	{430, Direction.UP},
	{431, Direction.UP},
	{432, Direction.UP},
	{433, Direction.UP},
	{434, Direction.UP},
	{435, Direction.UP},
	{436, Direction.UP},
	{437, Direction.UP},
	{438, Direction.UP},
	{439, Direction.UP},
	{440, Direction.UP},
	{441, Direction.UP},
	{442, Direction.UP},
	{443, Direction.UP},
	{444, Direction.UP},
	{445, Direction.UP},
	{446, Direction.UP},
}
wallTilesForRoomshape[RoomShape.ROOMSHAPE_LTR] = {
	{1, Direction.DOWN},
	{2, Direction.DOWN},
	{3, Direction.DOWN},
	{4, Direction.DOWN},
	{5, Direction.DOWN},
	{6, Direction.DOWN},
	{7, Direction.DOWN},
	{8, Direction.DOWN},
	{9, Direction.DOWN},
	{10, Direction.DOWN},
	{11, Direction.DOWN},
	{12, Direction.DOWN},
	{13, Direction.DOWN},
	{211, Direction.DOWN},
	{212, Direction.DOWN},
	{213, Direction.DOWN},
	{214, Direction.DOWN},
	{215, Direction.DOWN},
	{216, Direction.DOWN},
	{217, Direction.DOWN},
	{218, Direction.DOWN},
	{219, Direction.DOWN},
	{220, Direction.DOWN},
	{221, Direction.DOWN},
	{222, Direction.DOWN},
	{28, Direction.RIGHT},
	{56, Direction.RIGHT},
	{84, Direction.RIGHT},
	{112, Direction.RIGHT},
	{140, Direction.RIGHT},
	{168, Direction.RIGHT},
	{196, Direction.RIGHT},
	{224, Direction.RIGHT},
	{252, Direction.RIGHT},
	{280, Direction.RIGHT},
	{308, Direction.RIGHT},
	{336, Direction.RIGHT},
	{364, Direction.RIGHT},
	{392, Direction.RIGHT},
	{42, Direction.LEFT},
	{70, Direction.LEFT},
	{98, Direction.LEFT},
	{126, Direction.LEFT},
	{154, Direction.LEFT},
	{182, Direction.LEFT},
	{251, Direction.LEFT},
	{279, Direction.LEFT},
	{307, Direction.LEFT},
	{335, Direction.LEFT},
	{363, Direction.LEFT},
	{391, Direction.LEFT},
	{419, Direction.LEFT},
	{421, Direction.UP},
	{422, Direction.UP},
	{423, Direction.UP},
	{424, Direction.UP},
	{425, Direction.UP},
	{426, Direction.UP},
	{427, Direction.UP},
	{428, Direction.UP},
	{429, Direction.UP},
	{430, Direction.UP},
	{431, Direction.UP},
	{432, Direction.UP},
	{433, Direction.UP},
	{434, Direction.UP},
	{435, Direction.UP},
	{436, Direction.UP},
	{437, Direction.UP},
	{438, Direction.UP},
	{439, Direction.UP},
	{440, Direction.UP},
	{441, Direction.UP},
	{442, Direction.UP},
	{443, Direction.UP},
	{444, Direction.UP},
	{445, Direction.UP},
	{446, Direction.UP},
}
wallTilesForRoomshape[RoomShape.ROOMSHAPE_LBL] = {
	{1, Direction.DOWN},
	{2, Direction.DOWN},
	{3, Direction.DOWN},
	{4, Direction.DOWN},
	{5, Direction.DOWN},
	{6, Direction.DOWN},
	{7, Direction.DOWN},
	{8, Direction.DOWN},
	{9, Direction.DOWN},
	{10, Direction.DOWN},
	{11, Direction.DOWN},
	{12, Direction.DOWN},
	{13, Direction.DOWN},
	{14, Direction.DOWN},
	{15, Direction.DOWN},
	{16, Direction.DOWN},
	{17, Direction.DOWN},
	{18, Direction.DOWN},
	{19, Direction.DOWN},
	{20, Direction.DOWN},
	{21, Direction.DOWN},
	{22, Direction.DOWN},
	{23, Direction.DOWN},
	{24, Direction.DOWN},
	{25, Direction.DOWN},
	{26, Direction.DOWN},
	{28, Direction.RIGHT},
	{56, Direction.RIGHT},
	{84, Direction.RIGHT},
	{112, Direction.RIGHT},
	{140, Direction.RIGHT},
	{168, Direction.RIGHT},
	{196, Direction.RIGHT},
	{265, Direction.RIGHT},
	{293, Direction.RIGHT},
	{321, Direction.RIGHT},
	{349, Direction.RIGHT},
	{377, Direction.RIGHT},
	{405, Direction.RIGHT},
	{55, Direction.LEFT},
	{83, Direction.LEFT},
	{111, Direction.LEFT},
	{139, Direction.LEFT},
	{167, Direction.LEFT},
	{195, Direction.LEFT},
	{223, Direction.LEFT},
	{251, Direction.LEFT},
	{279, Direction.LEFT},
	{307, Direction.LEFT},
	{335, Direction.LEFT},
	{363, Direction.LEFT},
	{391, Direction.LEFT},
	{419, Direction.LEFT},
	{225, Direction.UP},
	{226, Direction.UP},
	{227, Direction.UP},
	{228, Direction.UP},
	{229, Direction.UP},
	{230, Direction.UP},
	{231, Direction.UP},
	{232, Direction.UP},
	{233, Direction.UP},
	{234, Direction.UP},
	{235, Direction.UP},
	{236, Direction.UP},
	{434, Direction.UP},
	{435, Direction.UP},
	{436, Direction.UP},
	{437, Direction.UP},
	{438, Direction.UP},
	{439, Direction.UP},
	{440, Direction.UP},
	{441, Direction.UP},
	{442, Direction.UP},
	{443, Direction.UP},
	{444, Direction.UP},
	{445, Direction.UP},
	{446, Direction.UP},
}
wallTilesForRoomshape[RoomShape.ROOMSHAPE_LBR] = {
	{1, Direction.DOWN},
	{2, Direction.DOWN},
	{3, Direction.DOWN},
	{4, Direction.DOWN},
	{5, Direction.DOWN},
	{6, Direction.DOWN},
	{7, Direction.DOWN},
	{8, Direction.DOWN},
	{9, Direction.DOWN},
	{10, Direction.DOWN},
	{11, Direction.DOWN},
	{12, Direction.DOWN},
	{13, Direction.DOWN},
	{14, Direction.DOWN},
	{15, Direction.DOWN},
	{16, Direction.DOWN},
	{17, Direction.DOWN},
	{18, Direction.DOWN},
	{19, Direction.DOWN},
	{20, Direction.DOWN},
	{21, Direction.DOWN},
	{22, Direction.DOWN},
	{23, Direction.DOWN},
	{24, Direction.DOWN},
	{25, Direction.DOWN},
	{26, Direction.DOWN},
	{28, Direction.RIGHT},
	{56, Direction.RIGHT},
	{84, Direction.RIGHT},
	{112, Direction.RIGHT},
	{140, Direction.RIGHT},
	{168, Direction.RIGHT},
	{196, Direction.RIGHT},
	{224, Direction.RIGHT},
	{252, Direction.RIGHT},
	{280, Direction.RIGHT},
	{308, Direction.RIGHT},
	{336, Direction.RIGHT},
	{364, Direction.RIGHT},
	{392, Direction.RIGHT},
	{55, Direction.LEFT},
	{83, Direction.LEFT},
	{111, Direction.LEFT},
	{139, Direction.LEFT},
	{167, Direction.LEFT},
	{195, Direction.LEFT},
	{223, Direction.LEFT},
	{266, Direction.LEFT},
	{294, Direction.LEFT},
	{322, Direction.LEFT},
	{356, Direction.LEFT},
	{378, Direction.LEFT},
	{406, Direction.LEFT},
	{421, Direction.UP},
	{422, Direction.UP},
	{423, Direction.UP},
	{424, Direction.UP},
	{425, Direction.UP},
	{426, Direction.UP},
	{427, Direction.UP},
	{428, Direction.UP},
	{429, Direction.UP},
	{430, Direction.UP},
	{431, Direction.UP},
	{432, Direction.UP},
	{433, Direction.UP},
	{239, Direction.UP},
	{240, Direction.UP},
	{241, Direction.UP},
	{242, Direction.UP},
	{243, Direction.UP},
	{244, Direction.UP},
	{245, Direction.UP},
	{246, Direction.UP},
	{247, Direction.UP},
	{248, Direction.UP},
	{249, Direction.UP},
	{250, Direction.UP},
}

local function getRandomWallTile()
	local room = game:GetRoom()
	local possibleTiles = wallTilesForRoomshape[room:GetRoomShape()]
	if possibleTiles == nil then 
		possibleTiles = wallTilesForRoomshape[RoomShape.ROOMSHAPE_1x1] 
	end
	
	local randTile = possibleTiles[math.random(#possibleTiles)]
	return randTile[1], randTile[2]
end

local cachedDoorTiles = nil
local function getDoorTiles()
	if cachedDoorTiles == nil then
		local doorTiles = {}
		local room = game:GetRoom()
		local width = room:GetGridWidth()
		local height = room:GetGridWidth()
		for x = 0, width - 1 do
			for y = 0, height - 1 do
				local grid = room:GetGridEntity(y * width + x) 
				if grid and grid:ToDoor() then
					doorTiles[y * width + x] = true
				end
				if y-1 >= 0 then
					grid = room:GetGridEntity((y-1) * width + x)
					if grid and grid:ToDoor() then
						doorTiles[y * width + x] = true
					end
				end
				if y+1 < height then
					grid = room:GetGridEntity((y+1) * width + x) 
					if grid and grid:ToDoor() then
						doorTiles[y * width + x] = true
					end
				end
				if x-1 >= 0 then
					grid = room:GetGridEntity(y * width + (x-1)) 
					if grid and grid:ToDoor() then
						doorTiles[y * width + x] = true
					end
				end
				if x+1 < width then
					grid = room:GetGridEntity(y * width + (x+1)) 
					if grid and grid:ToDoor() then
						doorTiles[y * width + x] = true
					end
				end
			end
		end
		cachedDoorTiles = doorTiles
	end
	return cachedDoorTiles
end

function mod:babyBubblesPump(npc, sprite, npcdata)
	npc.Position = npcdata.targetPos
	npc.Velocity = nilvector
	
	if sprite:IsFinished("BubblePump") then
		if npcdata.finalPump then
			npcdata.pumpingBubbles = nil
			npcdata.nextFrameToSpawnBubble = nil
			npcdata.numPumps = nil
			npcdata.pumpCooldown = nil
			npcdata.finalPump = nil
			npcdata.plopCooldown = nil
			
			npcdata.attackSelected = nil
			npcdata.waitingForAttack = ATTACK_COOLDOWN
			return
		else
			npcdata.numPumps = (npcdata.numPumps or 0) + 1
			sprite:Play("Idle", true)
			npcdata.pumpCooldown = BUBBLE_PUMP_COOLDOWN
			npcdata.finalPump = npcdata.numPumps >= #BUBBLE_PUMP_BUBBLE_PATTERNS
		end
	elseif not sprite:IsPlaying("BubblePump") then
		npcdata.pumpCooldown = math.max((npcdata.pumpCooldown or 0) - 1, 0)
		if npcdata.pumpCooldown <= 0 then
			sprite:Play("BubblePump", true)
		elseif not sprite:IsPlaying("Idle") then
			sprite:Play("Idle", true)
		end
	end
	
	if sprite:IsEventTriggered("Shoot") then
		for _, bubble in ipairs(Isaac.FindByType(mod.FF.BubbleLeper.ID, mod.FF.BubbleLeper.Var, mod.FF.BubbleLeper.Sub)) do
			if bubble.Parent and GetPtrHash(bubble.Parent) == GetPtrHash(npc) then
				local d = mod:GetEntityData(bubble)
				d.Timeout = nil
				d.IsPopping = true
				bubble:ToNPC().State = 11
			end
		end
		for _, bubble in ipairs(Isaac.FindByType(mod.FF.BubbleLargeLeper.ID, mod.FF.BubbleLargeLeper.Var, mod.FF.BubbleLargeLeper.Sub)) do
			if bubble.Parent and GetPtrHash(bubble.Parent) == GetPtrHash(npc) then
				local d = mod:GetEntityData(bubble)
				d.Timeout = nil
				d.IsPopping = true
				bubble:ToNPC().State = 11
			end
		end
		
		if not npcdata.finalPump then
			local bubblePattern = BUBBLE_PUMP_BUBBLE_PATTERNS[(npcdata.numPumps or 0) + 1]
			local numBubbles = #bubblePattern
			local patternIndex = 1
			local rotOffset = npcdata.attackRNG:RandomFloat() * 360
			for i = 360 / numBubbles, 360, 360 / numBubbles do
				local room = game:GetRoom()
				
				local bubbleSub = bubblePattern[patternIndex]
				patternIndex = patternIndex + 1
				
				local target = npc:GetPlayerTarget()
				local randOffset = (math.random() * 2 - 1) * BUBBLE_PUMP_ANGLE_RAND_OFFSET
				local randPos = Vector(math.random(), math.random()) * 5
				local targetOffset = Vector(BUBBLE_PUMP_SPAWN_RADIUS, 0):Rotated(i + rotOffset + randOffset) + randPos
				local bubblePos = target.Position + targetOffset
				
				local bubblingEffect = Isaac.Spawn(1000, 2009, 0, bubblePos, nilvector, npc):ToEffect()
				bubblingEffect.Target = target
				bubblingEffect.Parent = npc
				bubblingEffect.Visible = false
				
				local edata = mod:GetEntityData(bubblingEffect)
				edata.Timeout = BUBBLE_PUMP_TIME_TO_RISE
				edata.IsFriend = npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
				edata.TargetPos = target.Position
				edata.BubbleSub = bubbleSub
				edata.TargetOffset = targetOffset
			end

			npcdata.plopCooldown = 0
		end
		
		sfx:Play(FiendFolio.Sounds.BabyBubblesPump, 0.8, 0, false, 0.95 + math.random() * 0.1)
	elseif sprite:IsEventTriggered("StopShoot") then
		npcdata.plopCooldown = nil
	end
	
	if npcdata.plopCooldown ~= nil then
		npcdata.plopCooldown = math.max(0, (npcdata.plopCooldown or 0) - 1)
		if npcdata.plopCooldown <= 0 then
			sfx:Play(SoundEffect.SOUND_PLOP, 0.1, 0, false, 0.25)
			npcdata.plopCooldown = 4
		end
	end
end

function mod:babyBubblesStream(npc, sprite, npcdata)
	npcdata.state = npcdata.state or "submerge"
	
	if npcdata.state == "submerge" then
		npc.Position = npcdata.targetPos
		npc.Velocity = nilvector
		
		if sprite:IsFinished("Submerge") then
			npcdata.state = "firing"
			npcdata.streamBubbles = {}
		elseif not sprite:IsPlaying("Submerge") then
			sprite:Play("Submerge", true)
		end
	end
	
	if npcdata.state == "firing" then
		if not npcdata.selectedDir then
			local room = game:GetRoom()
			local topleft = room:GetTopLeftPos()
			local center = room:GetCenterPos()
			local bottomright = room:GetBottomRightPos()
			
			local target = npc:GetPlayerTarget()
			local possibleDirections = {}
			if target.Position.X <= center.X then
				table.insert(possibleDirections, Direction.LEFT)
			else
				table.insert(possibleDirections, Direction.RIGHT)
			end
			if target.Position.Y <= center.Y then
				table.insert(possibleDirections, Direction.UP)
			else
				table.insert(possibleDirections, Direction.DOWN)
			end
			
			local dir = ""
			repeat
				npcdata.selectedDir = possibleDirections[math.random(#possibleDirections)]
			until (npcdata.selectedDir ~= npcdata.lastDir)
			if npcdata.selectedDir == Direction.UP then
				npcdata.targetPos = Vector(math.min(math.max(topleft.X + 40, target.Position.X), bottomright.X - 40), bottomright.Y - 20)
				dir = "Up"
				npcdata.nextLeperInXBubbles = math.min(STREAM_BLOODY_MIN_STARTING_EVERY_X_VERT, math.random(STREAM_BLOODY_EVERY_X_BUBBLES_VERT) - 1)
			elseif npcdata.selectedDir == Direction.DOWN then
				npcdata.targetPos = Vector(math.min(math.max(topleft.X + 40, target.Position.X), bottomright.X - 40), topleft.Y + 20)
				dir = "Down"
				npcdata.nextLeperInXBubbles = math.min(STREAM_BLOODY_MIN_STARTING_EVERY_X_VERT, math.random(STREAM_BLOODY_EVERY_X_BUBBLES_VERT) - 1)
			elseif npcdata.selectedDir == Direction.LEFT then
				npcdata.targetPos = Vector(bottomright.X - 40, math.min(math.max(topleft.Y + 20, target.Position.Y), bottomright.Y - 20))
				dir = "Left"
				npcdata.nextLeperInXBubbles = math.min(STREAM_BLOODY_MIN_STARTING_EVERY_X_HORI, math.random(STREAM_BLOODY_EVERY_X_BUBBLES_HORI) - 1)
			elseif npcdata.selectedDir == Direction.RIGHT then
				npcdata.targetPos = Vector(topleft.X + 40, math.min(math.max(topleft.Y + 20, target.Position.Y), bottomright.Y - 20))
				dir = "Right"
				npcdata.nextLeperInXBubbles = math.min(STREAM_BLOODY_MIN_STARTING_EVERY_X_HORI, math.random(STREAM_BLOODY_EVERY_X_BUBBLES_HORI) - 1)
			end
			
			local fini = "Cont"
			npcdata.timesFired = (npcdata.timesFired or 0) + 1
			if npcdata.timesFired >= STREAM_MAX_TIMES then
				fini = "End"
			end
			npcdata.animName = "EmergeAttack" .. dir .. fini
			sprite:Play(npcdata.animName, true)
		end
		
		npc.Position = npcdata.targetPos
		npc.Velocity = nilvector
		npcdata.bubblesToSpawn = npcdata.bubblesToSpawn or {}
		
		local firePos = npc.Position
		if sprite:IsEventTriggered("Shoot") then
			local dir, everyXBubbles
			if npcdata.selectedDir == Direction.UP then
				dir = Vector(0, -1)
				everyXBubbles = STREAM_BLOODY_EVERY_X_BUBBLES_VERT
			elseif npcdata.selectedDir == Direction.DOWN then
				dir = Vector(0, 1)
				everyXBubbles = STREAM_BLOODY_EVERY_X_BUBBLES_VERT
			elseif npcdata.selectedDir == Direction.LEFT then
				dir = Vector(-1, 0)
				everyXBubbles = STREAM_BLOODY_EVERY_X_BUBBLES_HORI
			elseif npcdata.selectedDir == Direction.RIGHT then
				dir = Vector(1, 0)
				everyXBubbles = STREAM_BLOODY_EVERY_X_BUBBLES_HORI
			end
			
			local room = game:GetRoom()
			local topleft = room:GetTopLeftPos()
			local bottomright = room:GetBottomRightPos()
			
			npcdata.streamingBubbles = true
			
			local targetPos = npc.Position + dir * 40
			local isFirstTile = npcdata.selectedDir ~= Direction.DOWN
			repeat
				local angle = math.random() * 360
				for i = 360/STREAM_BUBBLES_PER_TILE, 360, 360/STREAM_BUBBLES_PER_TILE do
					local pos = targetPos + Vector(0,10):Rotated(angle + i + (math.random() * STREAM_BUBBLE_ANGLE_RANGE - STREAM_BUBBLE_ANGLE_RANGE / 2))
					local subt = mod.FF.BubbleStream.Sub
					if topleft.X + 10 < pos.X and pos.X < bottomright.X - 10 and topleft.Y + 10 < pos.Y and pos.Y < bottomright.Y - 10 then
						npcdata.nextLeperInXBubbles = npcdata.nextLeperInXBubbles - 1
					end
					if not isFirstTile and npcdata.nextLeperInXBubbles <= 0 then
						subt = mod.FF.BubbleBloodyStream.Sub
						npcdata.nextLeperInXBubbles = everyXBubbles
					end
					table.insert(npcdata.bubblesToSpawn, {Position = pos, SubType = subt})
				end
				targetPos = targetPos + dir * 40
				isFirstTile = false
			until (topleft.X > targetPos.X or targetPos.X > bottomright.X or topleft.Y > targetPos.Y or targetPos.Y > bottomright.Y)
			
			npcdata.numBubblesPerFrame = #npcdata.bubblesToSpawn / STREAM_FOR_X_FRAMES
			npcdata.bubblesFired = 0
	
		elseif sprite:IsEventTriggered("Emerge") then
			sfx:Play(FiendFolio.Sounds.BabyBubblesEmergeAttack, 1.0, 0, false, 1.0)
		end
		local stoppingShoot = sprite:IsEventTriggered("StopShoot")
		if stoppingShoot then
			npcdata.streamingBubbles = nil
		end
		
		if npcdata.streamingBubbles or (stoppingShoot and #npcdata.bubblesToSpawn > 0) then
			npcdata.lastFrameFiredBubbles = npcdata.lastFrameFiredBubbles or 14
			while ((sprite:GetFrame() > npcdata.lastFrameFiredBubbles or stoppingShoot) and #npcdata.bubblesToSpawn > 0) do
				while ((npcdata.bubblesFired < npcdata.numBubblesPerFrame or stoppingShoot) and #npcdata.bubblesToSpawn > 0) do
					local i = math.random(#npcdata.bubblesToSpawn)
					local bubbleInfo = npcdata.bubblesToSpawn[i]
					table.remove(npcdata.bubblesToSpawn, i)
					
					--[[local color = nil
					if bubbleInfo.SubType == mod.FF.BubbleBloodyStream.Sub then
						color = Color(1.5,1.5,1.5,1,0,0,0)
					end]]--
					
					local bubble = Isaac.Spawn(mod.FF.Bubble.ID, mod.FF.Bubble.Var, bubbleInfo.SubType, firePos, bubbleInfo.Position - npc.Position, npc):ToNPC()
					bubble:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					local d = mod:GetEntityData(bubble)
					d.Direction = npcdata.selectedDir
					d.StreamPos = bubbleInfo.Position
					d.StreamPosLerp = STREAM_BUBBLE_POS_LERP
					d.StreamPosMaxFrames = STREAM_BUBBLE_MAX_LERP_FRAMES
					d.StreamPosPopFrame = STREAM_BUBBLE_POP_ON_FRAME
					if mod:isFriend(npc) then
						bubble:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
					end
					--if color then bubble.Color = color end
					bubble:Update()
					
					table.insert(npcdata.streamBubbles, bubble)
					
					sfx:Play(FiendFolio.Sounds.BabyBubblesSpawnBubble, 0.3, 2, false, 1.2 + math.random() * 0.4)
					npcdata.bubblesFired = npcdata.bubblesFired + 1
				end
				npcdata.bubblesFired = npcdata.bubblesFired - npcdata.numBubblesPerFrame
				npcdata.lastFrameFiredBubbles = npcdata.lastFrameFiredBubbles + 1
			end
		end
		
		if sprite:IsFinished(npcdata.animName) then
			if (npcdata.timesFired or 0) >= STREAM_MAX_TIMES then
				npcdata.state = "finishing"
				npcdata.finishFrames = 0
			else
				npcdata.lastDir = npcdata.selectedDir
				npcdata.selectedDir = nil
				npcdata.animName = nil
				npcdata.streamingBubbles = nil
				npcdata.bubblesToSpawn = nil
				npcdata.numBubblesPerFrame = nil
				npcdata.bubblesFired = nil
				npcdata.lastFrameFiredBubbles = nil
				npcdata.nextLeperInXBubbles = nil
			end
		end
	end
	
	if npcdata.state == "finishing" then
		if not sprite:IsPlaying("Idle") then
			sprite:Play("Idle", true)
		end
		
		npcdata.finishFrames = npcdata.finishFrames + 1
		if npcdata.finishFrames >= STREAM_FINISH_MAX_FRAMES then
			npcdata.state = nil
			npcdata.selectedDir = nil
			npcdata.timesFired = nil
			npcdata.animName = nil
			npcdata.lastDir = nil
			npcdata.nextLeperInXBubbles = nil
			
			for _,bubble in ipairs(npcdata.streamBubbles) do
				if bubble and bubble:Exists() then
					bubble.Velocity = nilvector
					bubble.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
					bubble.HitPoints = 0
					mod:GetEntityData(bubble).IsPopping = true
					bubble.State = 11
				end
			end
			npcdata.streamBubbles = nil
			npcdata.streamingBubbles = nil
			npcdata.bubblesToSpawn = nil
			npcdata.numBubblesPerFrame = nil
			npcdata.bubblesFired = nil
			npcdata.lastFrameFiredBubbles = nil
			
			npcdata.attackSelected = nil
			npcdata.waitingForAttack = ATTACK_COOLDOWN
			
			return
		end
	end
end

function mod:babyBubblesRing(npc, sprite, npcdata)
	if sprite:IsFinished("Submerge") then
		npcdata.targetPos = findRandomTelePos(npc, 200, false, true)
		
		sprite:Play("Emerge", true)
	elseif sprite:IsFinished("Emerge") then
		sprite:Play("BlowTears", true)
	elseif sprite:IsFinished("BlowTears") then
		npcdata.numBlows = (npcdata.numBlows or 0) + 1
		if npcdata.numBlows >= RING_MAX_TIMES then
			npcdata.numBlows = nil
			
			npcdata.attackSelected = nil
			npcdata.waitingForAttack = ATTACK_COOLDOWN
			
			return
		else
			sprite:Play("Submerge", true)
		end
	elseif not (sprite:IsPlaying("Submerge") or sprite:IsPlaying("Emerge") or sprite:IsPlaying("BlowTears")) then
		sprite:Play("Submerge", true)
	end
	
	npc.Velocity = nilvector
	npc.Position = npcdata.targetPos
	
	if sprite:IsEventTriggered("Shoot") then
		local target = npc:GetPlayerTarget()
		local targetAngle = (target.Position - npc.Position):GetAngleDegrees()
		local isBubble = false
		local numSection = math.floor(RING_NUM_BULLET_SECTION / 2)
		for i = 0, 360 - 360 / RING_NUM_PROJ, 360 / RING_NUM_PROJ do
			local vec = Vector(RING_PROJ_INIT_VEL, 0):Rotated(targetAngle + i)
			if isBubble then
				local bubble = Isaac.Spawn(mod.FF.BubbleStream.ID, mod.FF.BubbleStream.Var, mod.FF.BubbleStream.Sub, npc.Position + vec:Resized(RING_SPAWN_OFFSET), vec, npc):ToNPC()
				bubble:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				mod:GetEntityData(bubble).AccelMult = RING_PROJ_ACCEL_MULT
				if mod:isFriend(npc) then
					bubble:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
				end
			else
				local projectile = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, npc.Position + vec:Resized(RING_SPAWN_OFFSET), vec, npc):ToProjectile()
				projectile.FallingSpeed = 0
				projectile.FallingAccel = -0.1
				--projectile:GetSprite().Color = Color(1,1,1,1,0.3,0,0)
				mod:GetEntityData(projectile).BabyBubblesAccelMult = RING_PROJ_ACCEL_MULT
				mod:makeCharmProj(npc, projectile)
			end
			
			numSection = numSection + 1
			if (isBubble and numSection >= RING_NUM_BUBBLE_SECTION) or (not isBubble and numSection >= RING_NUM_BULLET_SECTION) then
				isBubble = not isBubble
				numSection = 0
			end
		end
		
		for _, spurtInfo in ipairs(RING_SPURT_POSITIONS) do
			local effect = Isaac.Spawn(1000, 2, 5, npc.Position, nilvector, npc):ToEffect()
			effect.Color = Color(1,1,1,0.4,0.6,0.1,0.1)
			effect:FollowParent(npc)
			effect:Update()
			
			local esprite = effect:GetSprite()
			local flipped = spurtInfo[2]
			if flipped then
				esprite:Load("gfx/effects/1000.002_blood explosion_drops_flip.anm2", true)
			else
				esprite:Load("gfx/effects/1000.002_blood explosion_drops.anm2", true)
			end
			esprite:Play("Poof_Alt", true)
			
			effect.SpriteOffset = Isaac.WorldToScreenDistance(spurtInfo[1]) + Vector(0, -15) + ((flipped and Vector(2, 0)) or Vector(-2, 0))
			effect.SpriteScale = Vector(0.5, 0.5)
			effect.DepthOffset = spurtInfo[3]
		end
		
		sfx:Play(FiendFolio.Sounds.BabyBubblesBlowTearsShoot, 1.0, 0, false, 1.0)
		sfx:Play(FiendFolio.Sounds.BabyBubblesSpawnBubble, 1, 0, false, 0.8)
	elseif sprite:IsEventTriggered("BlowStart") then
		sfx:Play(FiendFolio.Sounds.BabyBubblesBlowTearsStart, 1.0, 0, false, 1.0)
	end
end

function mod:babyBubblesSpawnPipe(npc, npcdata, subt, avoidOppositeWall)
	local room = game:GetRoom()
	
	local attempts = 0
	local doorTiles = getDoorTiles()
	npcdata.usedPipeGridIndices = npcdata.usedPipeGridIndices or {}
	local gridIndex, direction
	repeat
		gridIndex, direction = getRandomWallTile()
		attempts = attempts + 1
	until (not (npcdata.usedPipeGridIndices[gridIndex] or doorTiles[gridIndex] or direction == npcdata.lastPipeDirection) or attempts >= 100)
	
	npcdata.usedPipeGridIndices[gridIndex] = true
	if avoidOppositeWall then
		local lastGridIndex = nil
		local currentGridIndex = gridIndex
		local dirVec = Vector(0,40)
		if direction == Direction.UP then
			dirVec = Vector(0,-40)
		elseif direction == Direction.DOWN then
			dirVec = Vector(0,40)
		elseif direction == Direction.LEFT then
			dirVec = Vector(-40,0)
		elseif direction == Direction.RIGHT then
			dirVec = Vector(40,0)
		end
		
		while (currentGridIndex ~= -1 and lastGridIndex ~= currentGridIndex) do
			npcdata.usedPipeGridIndices[currentGridIndex] = true
			lastGridIndex = currentGridIndex
			currentGridIndex = room:GetGridIndex(room:GetGridPosition(currentGridIndex) + dirVec)
		end
	end
	npcdata.lastPipeDirection = direction
	
	local pos = game:GetRoom():GetGridPosition(gridIndex)
	local pipe = Isaac.Spawn(mod.FF.BabyBubblesPipe.ID, mod.FF.BabyBubblesPipe.Var, subt, pos, nilvector, npc)
	pipe.Parent = npc
	mod:GetEntityData(pipe).direction = direction
	pipe:Update()
	
	sfx:Play(FiendFolio.Sounds.BabyBubblesSentryAppear, 0.45, 0, false, 0.85 + math.random() * 0.25)
	
	return pipe
end

function mod:babyBubblesResetPipeData(npcdata)
	npcdata.usedPipeGridIndices = nil
	npcdata.lastPipeDirection = nil
end

function mod:babyBubblesPartial(npc, sprite, npcdata)
	npcdata.state = npcdata.state or "submerge"
	npc.DepthOffset = -10
	local animSuffix = (npcdata.eyePopped and "2") or ""
	
	if npcdata.state == "submerge" then
		npc.Position = npcdata.targetPos
		npc.Velocity = nilvector
		
		if sprite:IsFinished("PartialSubmerge" .. animSuffix) then
			npcdata.state = "chasing"
		elseif not sprite:IsPlaying("PartialSubmerge" .. animSuffix) then
			sprite:Play("PartialSubmerge" .. animSuffix, true)
		end
		if sprite:IsEventTriggered("SplashDown") then
			npcdata.isPartialSubmerged = true
		end
	end
	
	if npcdata.state == "chasing" then
		npcdata.submergedFrames = (npcdata.submergedFrames or 0) + 1
		if npcdata.submergedFrames >= PARTIAL_SUBMERGE_FRAMES then
			npcdata.state = "waiting"
		else
			if not sprite:IsPlaying("SubmergeMove") then
				sprite:Play("SubmergeMove", true)
			end
			
			local target = npc:GetPlayerTarget()
			npc.Velocity = mod:Lerp(npc.Velocity, mod:reverseIfFear(npc, mod:confusePos(npc, target.Position) - npc.Position):Resized(PARTIAL_VEL), PARTIAL_LERP)
			
			npcdata.spurtCooldowns = npcdata.spurtCooldowns or {}
			for i = 1, #PARTIAL_SPAWN_POSITIONS do
				npcdata.spurtCooldowns[i] = (npcdata.spurtCooldowns[i] or PARTIAL_SPURT_COOLDOWN) + 1
			end
			
			npcdata.bubbleCooldown = (npcdata.bubbleCooldown or PARTIAL_BUBBLE_SPAWN_COOLDOWN) + 1
			if npcdata.bubbleCooldown >= PARTIAL_BUBBLE_SPAWN_COOLDOWN then
				local posIndex = math.random(#PARTIAL_SPAWN_POSITIONS)
				local pos = npc.Position + PARTIAL_SPAWN_POSITIONS[posIndex]
				local bubble = Isaac.Spawn(mod.FF.BubbleStream.ID, mod.FF.BubbleStream.Var, mod.FF.BubbleStream.Sub, pos, Vector(0, PARTIAL_BUBBLE_VEL):Rotated(npcdata.attackRNG:RandomFloat() * 360), npc):ToNPC()
				bubble:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				if mod:isFriend(npc) then
					bubble:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
				end
				local bd = mod:GetEntityData(bubble)
				bd.Timeout = math.min(bd.Timeout or math.huge, PARTIAL_BUBBLE_TIME_TO_BURST + math.floor(PARTIAL_BUBBLE_TIME_TO_BURST_RANGE * math.random() + 0.5))
				
				if npcdata.spurtCooldowns[posIndex] >= PARTIAL_SPURT_COOLDOWN then
					local effect = Isaac.Spawn(1000, 2, 5, npc.Position, nilvector, npc):ToEffect()
					effect.Color = Color(1,1,1,0.4,0.6,0.1,0.1)
					effect:FollowParent(npc)
					effect:Update()
					
					local esprite = effect:GetSprite()
					local flipped = math.random(2) == 1
					if flipped then
						esprite:Load("gfx/effects/1000.002_blood explosion_drops_flip.anm2", true)
					else
						esprite:Load("gfx/effects/1000.002_blood explosion_drops.anm2", true)
					end
					esprite:Play("Poof_Alt", true)
					
					effect.SpriteOffset = Isaac.WorldToScreenDistance(PARTIAL_SPAWN_POSITIONS[posIndex]) + Vector(0, -15) + ((flipped and Vector(2, 0)) or Vector(-2, 0))
					effect.SpriteScale = Vector(0.5, 0.5)
					
					npcdata.spurtCooldowns[posIndex] = 0
				end
				
				npcdata.bubbleCooldown = 0
			end
			
			sfx:Play(FiendFolio.Sounds.BabyBubblesSpawnBubble, 0.2, 4, false, 0.8 + math.random() * 0.2)
			if npcdata.eyePopped then
				npcdata.pipeCooldown = (npcdata.pipeCooldown or 0) + 1
				if npcdata.pipeCooldown >= PARTIAL_PIPE_COOLDOWN then
					mod:babyBubblesSpawnPipe(npc, npcdata, 0)
					npcdata.pipeCooldown = 0
				end
			end
		end
	end
	
	if npcdata.state == "waiting" then
		npcdata.emergeFrames = (npcdata.emergeFrames or 0) + 1
		if npcdata.emergeFrames >= PARTIAL_EMERGE_FRAMES then
			npcdata.state = "emerge"
			npcdata.targetPos = npc.Position
		else
			if not sprite:IsPlaying("SubmergeIdle") then
				sprite:Play("SubmergeIdle", true)
			end
				
			npc.Velocity = mod:Lerp(npc.Velocity, mod:reverseIfFear(npc, nilvector), PARTIAL_LERP)
		end
	end
	
	if npcdata.state == "emerge" then
		npc.Position = npcdata.targetPos
		npc.Velocity = nilvector
		
		if sprite:IsEventTriggered("SplashUp") then
			npcdata.isPartialSubmerged = nil
		end
		
		if sprite:IsFinished("PartialEmerge" .. animSuffix) then
			npcdata.state = nil
			npcdata.submergedFrames = nil
			npcdata.emergeFrames = nil
			npcdata.bubbleCooldown = nil
			npcdata.spurtCooldowns = nil
			npcdata.isPartialSubmerged = nil
			
			npcdata.pipeCooldown = nil
			mod:babyBubblesResetPipeData(npcdata)
			
			npcdata.attackSelected = nil
			npcdata.waitingForAttack = ATTACK_COOLDOWN
			npc.DepthOffset = 0
			
			return
		elseif not sprite:IsPlaying("PartialEmerge" .. animSuffix) then
			sprite:Play("PartialEmerge" .. animSuffix, true)
		end
	end
end

function mod:babyBubblesScream(npc, sprite, npcdata)
	if sprite:IsFinished("Submerge2") or sprite:IsFinished("ScreamSubmerge") then
		npcdata.targetPos = findRandomTelePos(npc, 200, false, true)
		
		sprite:Play("ScreamEmerge", true)
	elseif sprite:IsFinished("ScreamEmerge") or sprite:IsFinished("ScreamStart") then
		sprite:Play("ScreamLoop", true)
		npcdata.throwinTantrum = 0
	elseif sprite:IsPlaying("ScreamLoop") then
		npcdata.throwinTantrum = (npcdata.throwinTantrum or 0) + 1
		if npcdata.throwinTantrum > SCREAM_MAX_FRAMES then
			npcdata.numScreams = (npcdata.numScreams or 0) + 1
			npcdata.schmoving = false
			npcdata.bulletCooldown = nil
			npcdata.bulletRotation = nil
			if npcdata.numScreams >= SCREAM_MAX_TIMES then
				sprite:Play("ScreamEnd", true)
				npcdata.pipeCooldown = nil
			else
				sprite:Play("ScreamSubmerge", true)
			end
		end
	elseif sprite:IsFinished("ScreamEnd") then
		npcdata.targetPos = npc.Position
		npcdata.numScreams = nil
		npcdata.throwinTantrum = nil
		npcdata.schmoving = nil
		npcdata.bulletCooldown = nil
		npcdata.bulletRotation = nil
		npcdata.pipeCooldown = nil
		npcdata.pipesSpawned = nil
		mod:babyBubblesResetPipeData(npcdata)
		
		npcdata.attackSelected = nil
		npcdata.waitingForAttack = ATTACK_COOLDOWN
		
		return
	elseif not (sprite:IsPlaying("Submerge2") or sprite:IsPlaying("ScreamSubmerge") or sprite:IsPlaying("ScreamEmerge") or sprite:IsPlaying("ScreamStart") or sprite:IsPlaying("ScreamEnd")) then
		sprite:Play("Submerge2", true)
	end
	
	if sprite:IsEventTriggered("Scream") then
		if npcdata.pipeCooldown == nil then
			npcdata.pipeCooldown = SCREAM_PIPE_INITIAL_DELAY
		end
		npcdata.bulletCooldown = 0
		npcdata.bulletRotation = 1
		if math.random(2) == 1 then
			npcdata.bulletRotation = -1
		end
		npcdata.schmoving = true
		sfx:Play(FiendFolio.Sounds.BabyBubblesScream, 1.0, 2, false, 1)
	end
	if sprite:IsEventTriggered("ScreamLoop") then
		--sfx:Play(FiendFolio.Sounds.BabyBubblesScream, 1.0, 2, false, 1)
	end
	if sprite:IsEventTriggered("Submerge") then
		npcdata.targetPos = npc.Position
		npcdata.schmoving = nil
	end
	
	if npcdata.schmoving ~= nil then
		if npcdata.schmoving then
			local target = npc:GetPlayerTarget()
			npc.Velocity = mod:Lerp(npc.Velocity, mod:reverseIfFear(npc, mod:confusePos(npc, target.Position) - npc.Position):Resized(SCREAM_VEL), SCREAM_LERP)
		else
			npc.Velocity = mod:Lerp(npc.Velocity, mod:reverseIfFear(npc, nilvector), SCREAM_LERP)
		end
	else
		npc.Velocity = nilvector
		npc.Position = npcdata.targetPos
	end
	
	if npcdata.pipeCooldown ~= nil then
		npcdata.pipesSpawned = npcdata.pipesSpawned or 0
		npcdata.pipeCooldown = npcdata.pipeCooldown - 1
		if npcdata.pipeCooldown <= 0 and npcdata.pipesSpawned < SCREAM_MAX_PIPES then
			mod:babyBubblesSpawnPipe(npc, npcdata, 1)
			npcdata.pipeCooldown = SCREAM_PIPE_EVERY_X_FRAMES
			npcdata.pipesSpawned = npcdata.pipesSpawned + 1
		end
	end
	
	if npcdata.bulletCooldown ~= nil then
		npcdata.bulletCooldown = npcdata.bulletCooldown - 1
		if npcdata.bulletCooldown <= 0 then
			local target = npc:GetPlayerTarget()
			local targetAngle = (target.Position - npc.Position):GetAngleDegrees()
			for i = 0, 360 - 360 / SCREAM_NUM_PROJ, 360 / SCREAM_NUM_PROJ do
				local vec = Vector(SCREAM_PROJ_VEL, 0):Rotated(targetAngle + i)
				local projectile = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, npc.Position + vec:Resized(SCREAM_PROJ_SPAWN_OFFSET), vec, npc):ToProjectile()
				projectile.FallingSpeed = 0
				projectile.FallingAccel = -0.1
				local pdata = mod:GetEntityData(projectile)
				pdata.BabyBubblesRotate = true
				pdata.BabyBubblesRotateDirection = npcdata.bulletRotation
				pdata.BabyBubblesRotateOrigin = npc.Position
				mod:makeCharmProj(npc, projectile)
				projectile.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
			end
			sfx:Play(FiendFolio.Sounds.BabyBubblesScream, 1.0, 2, false, 1)
			npcdata.bulletRotation = npcdata.bulletRotation * -1
			npcdata.bulletCooldown = SCREAM_PROJ_COOLDOWN
		end
	end
end

local spawningProvidenceBubbles = nil
local spawnProvidenceBubblesThisFrame = false
local providenceBubbleDirection = Direction.DOWN
local providenceBubbleSpeed = PROVIDENCE_INIT_SPEED
local providenceBubbleAccel = PROVIDENCE_INIT_ACCEL
local providenceBubblePos = 0
local lastProvidenceBubblePos = nil
local providenceBubblePatternOutside = true
function mod:babyBubblesProvidence(npc, sprite, npcdata)
	npc.Position = npcdata.targetPos
	npc.Velocity = nilvector
	
	if sprite:IsFinished("BubblePump2End") then
		npcdata.providenceTimer = nil
		npcdata.spurtCooldown = nil
		npcdata.spurtIndividualCooldowns = nil
	
		npcdata.attackSelected = nil
		npcdata.waitingForAttack = ATTACK_COOLDOWN
		return
	elseif sprite:IsFinished("BubblePump2Start") then
		sprite:Play("BubblePump2Loop", true)
		npcdata.providenceTimer = 0
		if spawningProvidenceBubbles == nil then
			providenceBubbleSpeed = PROVIDENCE_INIT_SPEED
			providenceBubbleAccel = PROVIDENCE_INIT_ACCEL
			providenceBubblePos = 0
			lastProvidenceBubblePos = nil
			if npc.Position.Y <= game:GetRoom():GetCenterPos().Y then
				providenceBubbleDirection = Direction.DOWN
			else
				providenceBubbleDirection = Direction.UP
			end
			providenceBubblePatternOutside = true
		end
		spawningProvidenceBubbles = npc
	elseif not (sprite:IsPlaying("BubblePump2Start") or sprite:IsPlaying("BubblePump2Loop") or sprite:IsPlaying("BubblePump2End")) then
		sprite:Play("BubblePump2Start", true)
	end
	
	if npcdata.providenceTimer ~= nil then
		spawnProvidenceBubblesThisFrame = true
		npcdata.providenceTimer = npcdata.providenceTimer + 1
		if npcdata.providenceTimer >= PROVIDENCE_MAX_FRAMES then
			npcdata.providenceTimer = nil
			sprite:Play("BubblePump2End", true)
			if spawningProvidenceBubbles and GetPtrHash(spawningProvidenceBubbles) == GetPtrHash(npc) then
				spawningProvidenceBubbles = nil
			end
		end
		
		npcdata.spurtCooldown = (npcdata.spurtCooldown or 0) - 1
		npcdata.spurtIndividualCooldowns = npcdata.spurtIndividualCooldowns or {}
		for i = 1, #PROVIDENCE_SPURT_POSITIONS do
			npcdata.spurtIndividualCooldowns[i] = (npcdata.spurtIndividualCooldowns[i] or 0) - 1
		end
		if npcdata.spurtCooldown <= 0 then
			local rand = math.random(#PROVIDENCE_SPURT_POSITIONS)
			if npcdata.spurtIndividualCooldowns[rand] then
				local spurtInfo = PROVIDENCE_SPURT_POSITIONS[rand]
				local effect = Isaac.Spawn(1000, 2, 5, npc.Position, nilvector, npc):ToEffect()
				effect.Color = Color(1,1,1,0.4,0.6,0.1,0.1)
				effect:FollowParent(npc)
				effect:Update()
				
				local esprite = effect:GetSprite()
				local flipped = spurtInfo[2]
				if flipped then
					esprite:Load("gfx/effects/1000.002_blood explosion_drops_flip.anm2", true)
				else
					esprite:Load("gfx/effects/1000.002_blood explosion_drops.anm2", true)
				end
				esprite:Play("Poof_Alt", true)
				
				effect.SpriteOffset = Isaac.WorldToScreenDistance(spurtInfo[1]) + Vector(0, -15) + ((flipped and Vector(2, 0)) or Vector(-2, 0))
				effect.SpriteScale = Vector(0.5, 0.5)
				effect.DepthOffset = spurtInfo[3]
				
				npcdata.spurtIndividualCooldowns[rand] = 12
				
				sfx:Play(SoundEffect.SOUND_PLOP, 0.16, 0, false, 0.25)
			end
			npcdata.spurtCooldown = 4
		end
	end
end

function mod:inflateDecayBubble(npc, d)
	d.DecayScale = ((d.DecayScale or 0) * (1 - BRIMSTONE_BUBBLE_SIZEMULT_LERP) + BRIMSTONE_BUBBLE_SIZEMULT * BRIMSTONE_BUBBLE_SIZEMULT_LERP)
end

local bubblesToScale = {}
function mod:setBubbleToScale(bubble)
	bubblesToScale[GetPtrHash(bubble)] = bubble
end

function mod:babyBubblesBrimstone(npc, sprite, npcdata)
	if sprite:IsFinished("EyeBubble") then
		sprite:Play("Submerge2", true)
	elseif sprite:IsFinished("Submerge2") then
		npc.Visible = false
		if Isaac.CountEntities(nil, mod.FF.BubbleBrimstone.ID, mod.FF.BubbleBrimstone.Var, mod.FF.BubbleBrimstone.Sub) + Isaac.CountEntities(npc, EntityType.ENTITY_EFFECT, EffectVariant.ENEMY_BRIMSTONE_SWIRL, 0) <= 0 then
			npc.Visible = true
			npcdata.targetPos = findRandomTelePos(npc, 200, false, true)
			sprite:Play("Emerge2", true)
		end
	elseif sprite:IsFinished("Emerge2") then
		npcdata.eyeBubbles = nil
		
		npc.Visible = true
		npcdata.attackSelected = nil
		npcdata.waitingForAttack = ATTACK_COOLDOWN
		
		return
	elseif not (sprite:IsPlaying("EyeBubble") or sprite:IsPlaying("Submerge2") or sprite:IsPlaying("Emerge2")) then
		sprite:Play("EyeBubble", true)
	end
	
	if sprite:IsEventTriggered("Shoot") then
		local leftEyeBubble = Isaac.Spawn(mod.FF.BubbleBrimstone.ID, mod.FF.BubbleBrimstone.Var, mod.FF.BubbleBrimstone.Sub, npc.Position, nilvector, npc)
		mod:GetEntityData(leftEyeBubble).IsLeft = true
		local rightEyeBubble = Isaac.Spawn(mod.FF.BubbleBrimstone.ID, mod.FF.BubbleBrimstone.Var, mod.FF.BubbleBrimstone.Sub, npc.Position, nilvector, npc)
		mod:GetEntityData(rightEyeBubble).IsLeft = false
		
		npcdata.eyeBubbles = {leftEyeBubble, rightEyeBubble}
		for _, bubble in ipairs(npcdata.eyeBubbles) do
			bubble.Parent = npc
			bubble:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			if mod:isFriend(npc) then
				bubble:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
			end
			mod:GetEntityData(bubble).LaserSource = npc
			bubble:Update()
		end
		
		sfx:Play(FiendFolio.Sounds.BabyBubblesScream, 1.0, 0, false, 1)
		sfx:Play(FiendFolio.Sounds.BabyBubblesEyeBlow, 0.5, 0, false, 1)
	end
	
	if sprite:IsEventTriggered("StopShoot") then
		local randAngle = (math.random() * BRIMSTONE_BUBBLE_ANGLE + BRIMSTONE_BUBBLE_ANGLE_GAP) * ((math.random(2) == 1 and -1) or 1)
		for _, bubble in ipairs(npcdata.eyeBubbles) do
			local bdata = mod:GetEntityData(bubble)
			bdata.DecayScale = BRIMSTONE_BUBBLE_SIZEMULT
			bubble.Parent = nil
			bubble.Velocity = Vector(BRIMSTONE_BUBBLE_VEL,0):Rotated(randAngle)
			if bdata.IsLeft then
				bubble.Velocity = bubble.Velocity * -1
			end
		end
		npcdata.eyeBubbles = nil
		
		sfx:Play(FiendFolio.Sounds.BabyBubblesSpawnBubbleLong, 1.0, 0, false, 1)
	end
	
	npc.Velocity = nilvector
	npc.Position = npcdata.targetPos
end

function mod:babyBubblesAI(npc, sprite, npcdata)
	if not npcdata.init then
		npcdata.targetPos = npc.Position
		npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
		
		npcdata.eyePopped = false
		npcdata.waitingForAttack = ATTACK_COOLDOWN
		npcdata.attackSelected = nil
		npcdata.lastAttackSelected = nil
		npcdata.attackFreshness = {}
		npcdata.attackFreshness[1] = 1
		npcdata.attackFreshness[2] = 1
		npcdata.attackFreshness[3] = 1
		npcdata.attackFreshness[4] = 1
		
		npcdata.attackRNG = RNG()
		npcdata.attackRNG:SetSeed(npc.InitSeed, 7)
		
		npcdata.init = true
		
		return
	end
	
	if sprite:IsEventTriggered("Submerge") then
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
		npcdata.isSubmerged = true
	end
	if sprite:IsEventTriggered("Emerge") then
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		npc:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET)
		npcdata.isSubmerged = false
	end
	
	if not npcdata.isSubmerged and not npcdata.eyePopped and npc.HitPoints <= npc.MaxHitPoints / 2 then
		npcdata.phaseTransitioning = true
		npcdata.targetPos = npc.Position
	end
	
	if npcdata.phaseTransitioning then
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		npc:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET)
		
		npcdata.pumpingBubbles = nil
		npcdata.nextFrameToSpawnBubble = nil
		npcdata.numPumps = nil
		npcdata.pumpCooldown = nil
		npcdata.finalPump = nil
		npcdata.state = nil
		npcdata.selectedDir = nil
		npcdata.timesFired = nil
		npcdata.animName = nil
		npcdata.lastDir = nil
		npcdata.nextLeperInXBubbles = nil
		npcdata.streamingBubbles = nil
		npcdata.bubblesToSpawn = nil
		npcdata.numBubblesPerFrame = nil
		npcdata.bubblesFired = nil
		npcdata.lastFrameFiredBubbles = nil
		npcdata.numBlows = nil
		npcdata.submergedFrames = nil
		npcdata.emergeFrames = nil
		npcdata.bubbleCooldown = nil
		npcdata.spurtCooldowns = nil
		npcdata.pipeCooldown = nil
		npcdata.usedPipeGridIndices = nil
		
		npcdata.attackSelected = nil
		npcdata.waitingForAttack = ATTACK_COOLDOWN
		npcdata.nextAttack = 1
		npc.DepthOffset = 0
		
		npc.Position = npcdata.targetPos
		npc.Velocity = nilvector
		
		if sprite:IsFinished("PhaseTransition") then
			npcdata.eyePopped = true
			npcdata.phaseTransitioning = nil
		elseif sprite:IsPlaying("PartialSubmerge") then
			if sprite:GetFrame() < 10 then
				sprite:Play("PhaseTransition", true)
			end
		elseif sprite:IsFinished("PartialSubmerge") then
			sprite:Play("PartialEmerge", true)
		elseif sprite:IsPlaying("SubmergeMove") or sprite:IsPlaying("SubmergeIdle") then
			sprite:Play("PartialEmerge", true)
		elseif sprite:IsFinished("PartialEmerge") then
			sprite:Play("PhaseTransition", true)
			sfx:Play(FiendFolio.Sounds.BabyBubblesPhaseTransition, 1.0, 0, false, 1.0)
		elseif not (sprite:IsPlaying("PhaseTransition") or sprite:IsPlaying("PartialEmerge")) then
			sprite:Play("PhaseTransition", true)
			sfx:Play(FiendFolio.Sounds.BabyBubblesPhaseTransition, 1.0, 0, false, 1.0)
		end
		
		if sprite:IsEventTriggered("Scream") then
			-- pump bubbles
			for _, bubble in ipairs(Isaac.FindByType(mod.FF.BubbleLeper.ID, mod.FF.BubbleLeper.Var, mod.FF.BubbleLeper.Sub)) do
				if bubble.Parent and GetPtrHash(bubble.Parent) == GetPtrHash(npc) then
					local d = mod:GetEntityData(bubble)
					d.Timeout = nil
					d.IsPopping = true
					bubble:ToNPC().State = 11
				end
			end
			for _, bubble in ipairs(Isaac.FindByType(mod.FF.BubbleLargeLeper.ID, mod.FF.BubbleLargeLeper.Var, mod.FF.BubbleLargeLeper.Sub)) do
				if bubble.Parent and GetPtrHash(bubble.Parent) == GetPtrHash(npc) then
					local d = mod:GetEntityData(bubble)
					d.Timeout = nil
					d.IsPopping = true
					bubble:ToNPC().State = 11
				end
			end
			
			-- stream bubbles
			if npcdata.streamBubbles then
				for _,bubble in ipairs(npcdata.streamBubbles) do
					if bubble and bubble:Exists() then
						bubble.Velocity = nilvector
						bubble.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
						bubble.HitPoints = 0
						mod:GetEntityData(bubble).IsPopping = true
						bubble.State = 11
					end
				end
				npcdata.streamBubbles = nil
			end
			
			if sprite:IsPlaying("PhaseTransition") then
				sfx:Play(FiendFolio.Sounds.BabyBubblesPhaseTransitionScream, 1.0, 0, false, 1.0)
			end
		end
	else
		if npcdata.waitingForAttack ~= nil then
			npcdata.waitingForAttack = math.max(npcdata.waitingForAttack - 1, 0)
			if npcdata.waitingForAttack <= 0 then
				if npcdata.nextAttack then
					npcdata.attackSelected = npcdata.nextAttack
					npcdata.lastAttackSelected = npcdata.attackSelected
					npcdata.nextAttack = nil
				else
					local totalWeight = 0
					for i = 1, 4 do
						if npcdata.lastAttackSelected ~= i then
							totalWeight = totalWeight + npcdata.attackFreshness[i]
						end
					end
					
					local roll = math.random() * totalWeight
					npcdata.attackSelected = 4
					for i = 1, 4 do
						if npcdata.lastAttackSelected ~= i then
							if roll - npcdata.attackFreshness[i] <= 0.0001 then
								npcdata.attackSelected = i
								break
							else
								roll = roll - npcdata.attackFreshness[i]
							end
						end
					end
					npcdata.lastAttackSelected = npcdata.attackSelected
				end
				
				for i = 1, 4 do
					if npcdata.lastAttackSelected == i then
						npcdata.attackFreshness[i] = npcdata.attackFreshness[i] / 3
					else
						npcdata.attackFreshness[i] = math.min(10, npcdata.attackFreshness[i] + 1)
					end
				end
				
				npcdata.waitingForAttack = nil
			end
		end
		
		if npcdata.attackSelected ~= nil then
			if npcdata.eyePopped then
				if npcdata.attackSelected == 1 then
					mod:babyBubblesProvidence(npc, sprite, npcdata)
				elseif npcdata.attackSelected == 2 then
					mod:babyBubblesScream(npc, sprite, npcdata)
				elseif npcdata.attackSelected == 3 then
					mod:babyBubblesBrimstone(npc, sprite, npcdata)
				else
					mod:babyBubblesPartial(npc, sprite, npcdata)
				end
			else
				if npcdata.attackSelected == 1 then
					mod:babyBubblesPump(npc, sprite, npcdata)
				elseif npcdata.attackSelected == 2 then
					mod:babyBubblesStream(npc, sprite, npcdata)
				elseif npcdata.attackSelected == 3 then
					mod:babyBubblesRing(npc, sprite, npcdata)
				else
					mod:babyBubblesPartial(npc, sprite, npcdata)
				end
			end
		end
		
		if npcdata.attackSelected == nil then
			npc.Position = npcdata.targetPos
			npc.Velocity = nilvector
			if npcdata.eyePopped then
				if not sprite:IsPlaying("Idle2") then
					sprite:Play("Idle2", true)
				end
			else
				if not sprite:IsPlaying("Idle") then
					sprite:Play("Idle", true)
				end
			end
		end
	end
	
	if sprite:IsEventTriggered("SplashUp") then
		if not (sprite:IsPlaying("Appear") or sprite:IsPlaying("Death")) then
			sfx:Play(FiendFolio.Sounds.BabyBubblesReemerge, 0.6, 0, false, 1.0 + math.random() * 0.25)

			local splash = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_SPLASH, 0, npc.Position, nilvector, nil)
			splash.Color = Color(1,1,1,1,0,0,0,1,0,0,1)
			splash.DepthOffset = npc.DepthOffset + -5
		end
	elseif sprite:IsEventTriggered("SplashDown") then
		if not (sprite:IsPlaying("Appear") or sprite:IsPlaying("Death")) then
			sfx:Play(FiendFolio.Sounds.BabyBubblesSubmerge, 0.85, 0, false, 1.0 + math.random() * 0.25)

			local splash = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_SPLASH, 0, npc.Position, nilvector, nil)
			splash.Color = Color(1,1,1,1,0,0,0,1,0,0,1)
			splash.DepthOffset = npc.DepthOffset + -5
		end
	end
	
	if npcdata.eyePopped then
		npc:SetShieldStrength(40)
	else
		npc:SetShieldStrength(30)
	end
end

function mod:babyBubblesRender(npc)
	local sprite = npc:GetSprite()
	if sprite:IsEventTriggered("SplashUp") and sprite:IsPlaying("Appear") then
		local data = mod:GetEntityData(npc)
		if not data.didAppearSplash then
			sfx:Play(FiendFolio.Sounds.BabyBubblesReemerge, 0.6, 0, false, 1.0)
			sfx:Play(FiendFolio.Sounds.BabyBubblesAppear, 1.0, 0, false, 1.0)

			local splash = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_SPLASH, 0, npc.Position, nilvector, nil)
			splash.Color = Color(1,1,1,1,0,0,0,1,0,0,1)
			splash.DepthOffset = npc.DepthOffset + -5

			data.didAppearSplash = true
		end
	elseif sprite:IsEventTriggered("SplashDown") and sprite:IsPlaying("Death") then
		local data = mod:GetEntityData(npc)
		if not data.didDeathSplash then
			sfx:Play(FiendFolio.Sounds.BabyBubblesSplash, 0.7, 0, false, 1.0)

			local splash = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BIG_SPLASH, 0, npc.Position, nilvector, nil)
			splash.Color = Color(1,1,1,1,0,0,0,1,0,0,1)
			splash.DepthOffset = npc.DepthOffset + -5

			data.didDeathSplash = true
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, function(_, npc)
	if npc.Variant == mod.FF.BabyBubbles.Var then
		sfx:Play(FiendFolio.Sounds.BabyBubblesDeath, 1.0, 0, false, 1.0)
	end
end, mod.FF.BabyBubbles.ID)

local swimVolume = 1
local swimVolumeMult = nil
mod:AddEntityCallback(ModCallbacks.MC_POST_RENDER, mod.FF.BabyBubbles.ID, mod.FF.BabyBubbles.Var, -1, function()
	local playSwimSound = false
	local targetSwimVolume = 0.25
	if not game:IsPaused() then
		local babybubbles = Isaac.FindByType(mod.FF.BabyBubbles.ID, mod.FF.BabyBubbles.Var)
		
		for _, babybubble in ipairs(babybubbles) do
			local data = mod:GetEntityData(babybubble)
			local isPartial = data.attackSelected == 4 and (data.state == "chasing" or (data.state == "submerge" and data.isPartialSubmerged))
			local isPump = not data.eyePopped and data.attackSelected == 1 and data.plopCooldown ~= nil
			if not babybubble:IsDead() and (isPartial or isPump or spawningProvidenceBubbles) then
				playSwimSound = true
				if isPartial or spawningProvidenceBubbles then
					targetSwimVolume = 0.5
				end
			end
		end
	else
		swimVolume = 0
	end
	
	if playSwimSound then
		if swimVolumeMult == nil then
			swimVolumeMult = targetSwimVolume
		else
			swimVolumeMult = mod:Lerp(swimVolumeMult, targetSwimVolume, 0.1)
		end
	end
	
	if playSwimSound and not sfx:IsPlaying(mod.Sounds.BabyBubblesSwim) then
		swimVolume = 1
		sfx:Play(mod.Sounds.BabyBubblesSwim, swimVolume * swimVolumeMult, 0, true, 0.5)
	elseif playSwimSound then
		swimVolume = 1
		sfx:AdjustVolume(mod.Sounds.BabyBubblesSwim, swimVolume * swimVolumeMult)
	elseif not playSwimSound and sfx:IsPlaying(mod.Sounds.BabyBubblesSwim) then
		swimVolume = math.max(0, swimVolume - 0.05)
		if swimVolume > 0 then
			sfx:AdjustVolume(mod.Sounds.BabyBubblesSwim, swimVolume * swimVolumeMult)
		else
			sfx:Stop(mod.Sounds.BabyBubblesSwim)
		end
	elseif not playSwimSound then
		swimVolumeMult = nil
	end
end)

function mod:babyBubblesProjectiles(projectile, data)
	if data.BabyBubblesAccelMult then
		projectile.Velocity = projectile.Velocity * data.BabyBubblesAccelMult
	end
	if data.BabyBubblesRotate then
		projectile.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
		
		local vecFromOrigin = projectile.Position - data.BabyBubblesRotateOrigin
		local distFromOrigin = vecFromOrigin:Length()
		local newDistFromOrigin = distFromOrigin + SCREAM_PROJ_VEL
		local nextPos = vecFromOrigin:Rotated(math.deg(SCREAM_PROJ_ROTATE_VEL * data.BabyBubblesRotateDirection / newDistFromOrigin)):Resized(newDistFromOrigin) + data.BabyBubblesRotateOrigin
		projectile.Velocity = nextPos - projectile.Position
		
		data.BabyBubblesRotateTimeout = (data.BabyBubblesRotateTimeout or 0) + 1
		if data.BabyBubblesRotateTimeout >= SCREAM_PROJ_TIMEOUT then
			projectile.FallingAccel = 0
		end
	end
	if data.BabyBubblesProvidence then
		local vec = projectile.Velocity * PROVIDENCE_BULLET_ACCEL_MULT
		projectile.Velocity = vec:Resized(math.min(vec:Length(), PROVIDENCE_BULLET_MAX_SPEED))
	end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
	effect.Visible = false
	if not effect.Target then
		return
	end
	
	local data = mod:GetEntityData(effect)
	data.Timeout = math.max(0, (data.Timeout or 0) - 1)
	if BUBBLE_PUMP_FOLLOW_TARGET then
		effect.Position = effect.Target.Position + data.TargetOffset
	end
	
	local room = game:GetRoom()
	if isNoOrPitColl(room:GetGridCollisionAtPos(effect.Position)) then
		if effect.FrameCount % 3 == 0 then
			local pos = effect.Position + Vector(10 + math.random() * 10,0):Rotated(math.random(360))
			if isNoOrPitColl(room:GetGridCollisionAtPos(pos)) then
				local smallbubble = Isaac.Spawn(1000, 124, 0, pos, nilvector, effect)
				smallbubble:GetSprite():ReplaceSpritesheet(0, "gfx/effects/babybubbles_blood_bubble.png", true)
			end
		end

		if data.Timeout <= 0 then
			local bubble = Isaac.Spawn(mod.FF.Bubble.ID, mod.FF.Bubble.Var, data.BubbleSub or mod.FF.BubbleLeper.Sub, effect.Position, nilvector, effect.SpawnerEntity):ToNPC()
			bubble:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			bubble.Target = effect.Target
			bubble.Parent = effect.Parent
			bubble.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			local bd = mod:GetEntityData(bubble)
			bd.init = true
			bd.spawning = true
			bd.BabyBubblesSpawning = 6
			bd.TargetPos = data.TargetPos
			bubble:GetSprite():Play("Spawn")
			--bubble.SpriteOffset = Vector(0, 9)
			bubble.Color = Color(1.5,1.5,1.5,1,0,0,0)
			if data.IsFriend then bubble:AddEntityFlags(EntityFlag.FLAG_FRIENDLY) end
			bubble:Update()
			sfx:Play(FiendFolio.Sounds.BabyBubblesSpawnBubbleLong, 1, 0, false, 0.9 + math.random() * 0.2)
		end
	end
	
	if data.Timeout <= 0 then
		effect:Remove()
	end
end, 2009)

function mod:babyBubblesPipeAI(npc, sprite, npcdata)
	npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
	npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
	npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	npc.SortingLayer = SortingLayer.SORTING_DOOR
	
	npcdata.targetPos = npc.targetPos or npc.Position
	npc.Position = npcdata.targetPos
	npc.Velocity = nilvector
	
	local firePos = npc.Position + Vector(0,35)
	local firevec = Vector(0,1)
	if npcdata.direction == Direction.UP then
		sprite.Rotation = 180
		sprite.Offset = Vector(0,4)
		firevec = Vector(0,-1)
		firePos = npc.Position + Vector(0,10)
	elseif npcdata.direction == Direction.DOWN then
		sprite.Rotation = 0
		sprite.Offset = Vector(0,-8)
		firevec = Vector(0,1)
		firePos = npc.Position + Vector(0,35)
	elseif npcdata.direction == Direction.LEFT then
		sprite.Rotation = 90
		sprite.Offset = Vector(8,-6)
		firevec = Vector(-1,0)
		firePos = npc.Position + Vector(-10,16)
	elseif npcdata.direction == Direction.RIGHT then
		sprite.Rotation = 270
		sprite.Offset = Vector(-8,-6)
		firevec = Vector(1,0)
		firePos = npc.Position + Vector(10,16)
	end
	
	if sprite:IsEventTriggered("Shoot") then
		if npc.SubType == 0 then
			local params = ProjectileParams()
			params.Variant = 0
		
			npc:FireProjectiles(firePos, firevec:Rotated(-1 * PARTIAL_PIPE_SPREAD_ANGLE) * PARTIAL_PIPE_VEL, 0, params)
			npc:FireProjectiles(firePos, firevec * PARTIAL_PIPE_VEL, 0, params)
			npc:FireProjectiles(firePos, firevec:Rotated(PARTIAL_PIPE_SPREAD_ANGLE) * PARTIAL_PIPE_VEL, 0, params)
		elseif npc.SubType == 1 then
			local room = game:GetRoom()
			local topleft = room:GetTopLeftPos()
			local bottomright = room:GetBottomRightPos()
			
			local tilesProcessed = -1 * SCREAM_BUBBLE_AFTER_STEPS
			local targetPos = firePos + firevec * 8
			if npcdata.direction == Direction.LEFT or npcdata.direction == Direction.RIGHT then
				targetPos.X = npc.Position.X
			else
				targetPos.Y = npc.Position.Y
			end
			targetPos = targetPos + firevec * SCREAM_DIST_PER_STEP
			repeat
				if tilesProcessed >= 0 then
					local angle = math.random() * 360
					for i = 360/SCREAM_BUBBLES_PER_STEP, 360, 360/SCREAM_BUBBLES_PER_STEP do
						local pos = targetPos + Vector(0,SCREAM_BUBBLE_RADIUS_FROM_STEP):Rotated(angle + i + (math.random() * SCREAM_BUBBLE_ANGLE_RANGE - SCREAM_BUBBLE_ANGLE_RANGE / 2))
						local bubble = Isaac.Spawn(mod.FF.Bubble.ID, mod.FF.Bubble.Var, mod.FF.BubbleStream.Sub, firePos, pos - firePos, npc):ToNPC()
						bubble:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
						bubble.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
						local d = mod:GetEntityData(bubble)
						d.Direction = npcdata.direction
						d.StreamPos = pos
						d.StreamPosLerp = SCREAM_BUBBLE_POS_LERP
						d.StreamPosMaxFrames = SCREAM_BUBBLE_MAX_LERP_FRAMES
						d.Timeout = SCREAM_BUBBLE_TIMEOUT
						if mod:isFriend(npc) then
							bubble:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
						end
						bubble:Update()
					end
				end
				targetPos = targetPos + firevec * SCREAM_DIST_PER_STEP
				tilesProcessed = tilesProcessed + 1
			until (tilesProcessed >= SCREAM_BUBBLE_STEPS or topleft.X > targetPos.X or targetPos.X > bottomright.X or topleft.Y > targetPos.Y or targetPos.Y > bottomright.Y)
		end
		
		sfx:Play(FiendFolio.Sounds.BabyBubblesSentryShoot, 0.65, 0, false, 1)
	end
	
	if sprite:IsFinished("Leave") then
		npc:Remove()
	elseif sprite:IsFinished("Shoot") then
		sprite:Play("Leave", true)
	elseif sprite:IsFinished("Appear") then
		if npc.Parent and not npc.Parent:IsDead() then
			sprite:Play("Shoot", true)
		else
			sprite:Play("Leave", true)
		end
	elseif not (sprite:IsPlaying("Appear") or sprite:IsPlaying("Shoot") or sprite:IsPlaying("Leave") or sprite:IsPlaying("Idle")) or npc.FrameCount == 0 then
		sprite:Play("Appear", true)
	end
	
	if not npcdata.spawnedEffects then
		--[[local tracer = Isaac.Spawn(1000, 181, 0, npc.Position, nilvector, npc):ToEffect()
		tracer.SpriteRotation = 180 + sprite.Rotation
		tracer.SpriteScale = Vector(0.405,0.18)
		tracer.SpriteOffset = sprite.Offset
		tracer.Color = Color(0,0,0,0.5,1,0.2,0.2)
		tracer:GetSprite().PlaybackSpeed = 0.5
		tracer:Update()]]--
		
		for i = 1, 2 do
			local gib = Isaac.Spawn(1000, 5, 0, npc.Position - firevec * 20, firevec:Resized(math.random() + 1):Rotated(math.random() * 90 - 45), npc):ToEffect()
			gib.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
		end
		
		npcdata.spawnedEffects = true
	end
end

local stopDeathSound = false
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	spawningProvidenceBubbles = nil
	spawnProvidenceBubblesThisFrame = false
	providenceBubbleDirection = Direction.DOWN
	providenceBubbleSpeed = PROVIDENCE_INIT_SPEED
	providenceBubbleAccel = PROVIDENCE_INIT_ACCEL
	providenceBubblePatternOutside = true
	bubblesToScale = {}
	cachedDoorTiles = nil

	local room = game:GetRoom()
	local backdrop = room:GetBackdropType()

	local currentRoom = StageAPI.GetCurrentRoom()
	if currentRoom then
		local layout = currentRoom.Layout
		local entitiesByIndex = layout.EntitiesByIndex
		
		for index, entityList in pairs(entitiesByIndex) do
			for _, entity in ipairs(entityList) do
				if entity.Type == mod.FF.BabyBubbles.ID and entity.Variant == mod.FF.BabyBubbles.Var then
					-- setting corpse3 directly doesn't update rocks for some reason
					stopDeathSound = true
					room:SetWaterAmount(1)
					if backdrop == BackdropType.CORPSE or backdrop == BackdropType.CORPSE2 or backdrop == BackdropType.CORPSE3 then
						room:SetBackdropType(BackdropType.CORPSE, room:GetDecorationSeed())
						for _, mist in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.MIST)) do
							local sprite = mist:GetSprite()
							local layer = sprite:GetLayer(0)
							local color = layer:GetColor()
							color.R = 0.54902
							color.G = 0.164706
							color.B = 0.164706
							layer:SetColor(color)
						end
					end
					return
				end
			end
		end
		return
	end
	
	local roomDesc = game:GetLevel():GetCurrentRoomDesc()
	if roomDesc and roomDesc.Data then
		local spawns = roomDesc.Data.Spawns
		for i = 0, spawns.Size - 1 do
			local spawn = spawns:Get(i)
			if spawn then
				for j = 0, spawn.Entries.Size - 1 do
					local entry = spawn.Entries:Get(j)
					if entry and entry.Type == mod.FF.BabyBubbles.ID and entry.Variant == mod.FF.BabyBubbles.Var then
						-- setting corpse3 directly doesn't update rocks for some reason
						stopDeathSound = true
						room:SetWaterAmount(1)
						if backdrop == BackdropType.CORPSE or backdrop == BackdropType.CORPSE2 or backdrop == BackdropType.CORPSE3 then
							room:SetBackdropType(BackdropType.CORPSE, room:GetDecorationSeed())
							for _, mist in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.MIST)) do
								local sprite = mist:GetSprite()
								local layer = sprite:GetLayer(0)
								local color = layer:GetColor()
								color.R = 0.54902
								color.G = 0.164706
								color.B = 0.164706
								layer:SetColor(color)
							end
						end
						return
					end
				end
			end
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_PRE_SFX_PLAY, function()
	if stopDeathSound then
		stopDeathSound = false
		return false 
	end
end, SoundEffect.SOUND_DEATH_CARD)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	stopDeathSound = false
	
	if spawningProvidenceBubbles and spawningProvidenceBubbles:Exists() and not spawningProvidenceBubbles:IsDead() then
		local room = game:GetRoom()
		if spawnProvidenceBubblesThisFrame then
			providenceBubbleAccel = providenceBubbleAccel + PROVIDENCE_ACCEL_ACCEL
			providenceBubbleSpeed = math.min(providenceBubbleSpeed + providenceBubbleAccel, PROVIDENCE_MAX_SPEED)
			providenceBubblePos = providenceBubblePos + providenceBubbleSpeed
			if lastProvidenceBubblePos == nil or providenceBubblePos >= lastProvidenceBubblePos + PROVIDENCE_GAP then
				local target = spawningProvidenceBubbles:GetPlayerTarget()
				
				local topleft = room:GetTopLeftPos()
				local center = room:GetCenterPos()
				local bottomright = room:GetBottomRightPos()
				
				local bubbleSpawningSpaces = 13
				local roomShape = room:GetRoomShape()
				if roomShape == RoomShape.ROOMSHAPE_IV or roomShape == RoomShape.ROOMSHAPE_IIV then
					bubbleSpawningSpaces = 3
				elseif roomShape == RoomShape.ROOMSHAPE_1x1 or roomShape == RoomShape.ROOMSHAPE_IH or roomShape == RoomShape.ROOMSHAPE_1x2 then
					bubbleSpawningSpaces = 7
				end
				
				local vec = Vector(0, providenceBubbleSpeed)
				if providenceBubbleDirection == Direction.UP then
					vec = vec * -1
				end
				for i = 1, bubbleSpawningSpaces do
					local x = ((bottomright.X - 30) - (topleft.X + 30)) / (bubbleSpawningSpaces - 1) * (i - 1) + (topleft.X + 30)
					if (providenceBubblePatternOutside and i % 2 == 1) or (not providenceBubblePatternOutside and i % 2 == 0) then
						local bubble = Isaac.Spawn(mod.FF.BubbleProvidence.ID, mod.FF.BubbleProvidence.Var, mod.FF.BubbleProvidence.Sub, Vector(x, ((providenceBubbleDirection == Direction.UP) and bottomright.X + 60) or topleft.X - 60) + vec, vec, spawningProvidenceBubbles)
						local bdata = mod:GetEntityData(bubble)
						bdata.ProvidenceDirection = providenceBubbleDirection
						bdata.ProvidenceSpeed = providenceBubbleSpeed
						bdata.ProvidenceMaxSpeed = PROVIDENCE_MAX_SPEED
						bdata.ProvidenceAccel = providenceBubbleAccel
						bdata.ProvidenceAccelAccel = PROVIDENCE_ACCEL_ACCEL
						bubble:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
						if mod:isFriend(spawningProvidenceBubbles) then
							bubble:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
						end
						bubble.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
						bubble.Target = target
						mod:setBubbleToScale(bubble)
						bubble.Color = Color(1.5,1.5,1.5,1,0,0,0)
					end
				end
				
				providenceBubblePatternOutside = not providenceBubblePatternOutside
				lastProvidenceBubblePos = math.floor(providenceBubblePos / PROVIDENCE_GAP) * PROVIDENCE_GAP
				
				sfx:Play(FiendFolio.Sounds.BabyBubblesSpawnBubbleLong, 0.5, 1, false, 0.75 + (providenceBubbleSpeed - PROVIDENCE_INIT_SPEED) / (PROVIDENCE_MAX_SPEED - PROVIDENCE_INIT_SPEED) * 0.55)
			end
		end
		
		if game:GetFrameCount() % 2 == 0 then
			for i = 1, 4 do
				local pos = room:GetGridPosition(room:GetRandomTileIndex(math.random(2^31))) + Vector.FromAngle(math.random(360)):Resized(20)
				if isNoOrPitColl(room:GetGridCollisionAtPos(pos)) then
					local smallbubble = Isaac.Spawn(1000, 124, 0, pos, nilvector, effect)
					smallbubble:GetSprite():ReplaceSpritesheet(0, "gfx/effects/babybubbles_blood_bubble.png", true)
				end
			end
		end
	else
		spawningProvidenceBubbles = nil
	end
	spawnProvidenceBubblesThisFrame = false
	
	for k, bubble in pairs(bubblesToScale) do
		if bubble:Exists() then
			bubble.SpriteScale = bubble.SpriteScale * (mod:GetEntityData(bubble).DecayScale or 1.5)
		else
			bubblesToScale[k] = nil
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
	-- fixing nicalis' bugs for them
	if effect.SpawnerType == mod.FF.BabyBubbles.ID and effect.SpawnerVariant == mod.FF.BabyBubbles.Var then
		if Isaac.CountEntities(effect, EntityType.ENTITY_LASER) <= 0 then
			local sprite = effect:GetSprite()
			if sprite:IsFinished("Idle") or sprite:IsFinished("IdleQuick") then
				effect:Remove()
			end
		end
	end
end, EffectVariant.ENEMY_BRIMSTONE_SWIRL)

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -1 * math.huge, function(_, npc, damage, flags, source)
	if npc.Variant == mod.FF.BabyBubbles.Var then
		if source.Type == EntityType.ENTITY_EFFECT and source.Variant == EffectVariant.ENEMY_BRIMSTONE_SWIRL then
			if source.Entity and source.Entity.SpawnerEntity and GetPtrHash(source.Entity.SpawnerEntity) == GetPtrHash(npc) then
				return false
			end
		end
	end
end, mod.FF.BabyBubbles.ID)

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, math.huge, function(_, npc, damage, flags, source)
	if npc.Variant == mod.FF.BabyBubbles.Var then
		if npc.HitPoints <= npc.MaxHitPoints / 2 then
			local d = mod:GetEntityData(npc)
			if not d.eyePopped or d.phaseTransitioning then
				return {Damage = damage * 0.05}
			end
		end
	end
end, mod.FF.BabyBubbles.ID)

local bubblesBeingNoTargetted = {}
mod:AddPriorityEntityCallback(ModCallbacks.MC_PRE_FAMILIAR_UPDATE, math.huge, mod.FF.BubbleLeper.ID, mod.FF.BubbleLeper.Var, mod.FF.BubbleLeper.Sub, function()
	for _, bubble in ipairs(Isaac.FindByType(mod.FF.BubbleLeper.ID, mod.FF.BubbleLeper.Var, mod.FF.BubbleLeper.Sub)) do
		bubble:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
		table.insert(bubblesBeingNoTargetted, bubble)
	end
end)
mod:AddPriorityEntityCallback(ModCallbacks.MC_PRE_FAMILIAR_UPDATE, math.huge, mod.FF.BubbleLargeLeper.ID, mod.FF.BubbleLargeLeper.Var, mod.FF.BubbleLargeLeper.Sub, function()
	for _, bubble in ipairs(Isaac.FindByType(mod.FF.BubbleLargeLeper.ID, mod.FF.BubbleLargeLeper.Var, mod.FF.BubbleLargeLeper.Sub)) do
		bubble:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
		table.insert(bubblesBeingNoTargetted, bubble)
	end
end)
mod:AddPriorityEntityCallback(ModCallbacks.MC_PRE_FAMILIAR_UPDATE, math.huge, mod.FF.BubbleProvidence.ID, mod.FF.BubbleProvidence.Var, mod.FF.BubbleProvidence.Sub, function()
	for _, bubble in ipairs(Isaac.FindByType(mod.FF.BubbleProvidence.ID, mod.FF.BubbleProvidence.Var, mod.FF.BubbleProvidence.Sub)) do
		bubble:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
		table.insert(bubblesBeingNoTargetted, bubble)
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_FAMILIAR_UPDATE, -1 * math.huge, function()
	for _, bubble in ipairs(bubblesBeingNoTargetted) do
		bubble:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET)
	end
	bubblesBeingNoTargetted = {}
end)