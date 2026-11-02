local door = {
	tl = 0, -- Upper/Top left
	tr = 2, -- Upper/Top Right
	bl = 4, -- Lower/Bottom Left
	br = 6, -- Lower/Bottom Right
}

local function getFFEnt(ent, sub)
	return {ent.ID, ent.Var or 0, (sub or ent.Sub) or 0}
end

-- Shortcuts
local flesh_maiden		= {880, 0, 0}
local crackle			= {87, 1, 0}
local bone_fly			= {25, 4, 0}
local mole				= {829, 0, 0}
local clickety_clack	= {889, 0, 0}
local rock_spider		= {818, 0, 0}
local boney				= {227, 0, 0}
local carrion_princess	= {23, 3, 0}
local splasher			= {238, 0, 0}
local gurgle			= {87, 0, 0}
local fly_bomb			= {819, 0, 0}
local big_boney			= {830, 0, 0}
local hardy				= {826, 0, 0}
local coal_spider		= {818, 2, 0}
local dragonfly			= {25, 3, 0}
local dragonfly_x		= {25, 3, 1}
local dragonfly_random	= {25, 3, 100}
local blaster			= {821, 0, 0}
local migraine			= {869, 0, 0}
local danny				= {820, 0, 0}
local coal_boy			= {820, 1, 0}
local necro				= {828, 0, 0}
local ruiner			= getFFEnt(FiendFolio.FF.Ruiner)
local blasted			= getFFEnt(FiendFolio.FF.Blasted)
local flesh_sistern		= getFFEnt(FiendFolio.FF.FleshSistern)
local pyroclasm		 	= getFFEnt(FiendFolio.FF.Pyroclasm)
local bombmuncher		= getFFEnt(FiendFolio.FF.Bombmuncher)
local clickety_clash	= getFFEnt(FiendFolio.FF.ClicketyClash)
local clickety_char		= getFFEnt(FiendFolio.FF.ClicketyChar)
local ztewie_small		= getFFEnt(FiendFolio.FF.Ztewie, 3)
local ztewie_large		= getFFEnt(FiendFolio.FF.Ztewie, 6)
local briar				= getFFEnt(FiendFolio.FF.Briar)
local shellmet			= getFFEnt(FiendFolio.FF.Shellmet)


--[[  Template

	{
		DoorSpawns = {
			[DoorID] = {
				{EntityType, EntityVariant, EntitySubType},
				{EntityType, EntityVariant, EntitySubType},
				...
			},
			[DoorID] = {
				...
			},
		},
		MouthSpawns = {
			{EntityType, EntityVariant, EntitySubType},
			...
		}
		SpecialSpawns = {
			{Position (Vector), {EntityType, EntityVariant, EntitySubType}},
				OR
			{TileIndex (Integer), {EntityType, EntityVariant, EntitySubType}}
		}
		Dusts = 0,
		Mirages = 0,
		Weight = 1, -- NOT YET IMPLEMENTED
	},

Not including any of DoorSpawns, MouthSpawns, or SpecialSpawns will cause the Spawn animation to be skipped, the dust Spawns loop will play immediately
Weight and Dusts will default to the values shown in the template if not included

]]


local amonwaves = {
	{
		DoorSpawns = {
			[door.tl] = {
				flesh_maiden,
			},
			[door.tr] = {
				flesh_maiden,
			},
		},
		Dusts = 2,
	},
	{
		DoorSpawns = {
			[door.bl] = {
				crackle,
			},
			[door.br] = {
				crackle,
			},
		},
		Dusts = 2,
	},
	{
		DoorSpawns = {
			[door.tl] = {
				clickety_clack,
			},
			[door.tr] = {
				clickety_clack,
			},
			[door.bl] = {
				clickety_clack,
			},
			[door.br] = {
				clickety_clack,
			},
		},
		Dusts = 0,
	},
	{
		DoorSpawns = {
			[door.tl] = {
				bone_fly,
			},
			[door.tr] = {
				bone_fly,
			},
			[door.bl] = {
				rock_spider,
				rock_spider,
			},
			[door.br] = {
				rock_spider,
				rock_spider,
			},
		},
		Dusts = 0,
	},
	{
		DoorSpawns = {
			[door.bl] = {
				boney,
			},
			[door.br] = {
				boney,
			},
		},
		Dusts = 2,
	},
	{
		DoorSpawns = {
			[door.tl] = {
				carrion_princess,
			},
			[door.tr] = {
				carrion_princess,
			},
			[door.bl] = {
				carrion_princess,
			},
			[door.br] = {
				carrion_princess,
			},
		},
		Dusts = 0,
	},
	{
		DoorSpawns = {
			[door.bl] = {
				splasher,
				splasher,
			},
			[door.br] = {
				splasher,
				splasher,
			},
		},
		Dusts = 1,
	},
	{
		DoorSpawns = {
			[door.bl] = {
				gurgle,
			},
			[door.br] = {
				gurgle,
			},
		},
		Dusts = 2,
	},
	{
		DoorSpawns = {
			[door.bl] = {
				rock_spider,
				rock_spider,
			},
			[door.br] = {
				rock_spider,
				rock_spider,
			},
		},
		Dusts = 2,
	},
	{
		DoorSpawns = {
			[door.tl] = {
				fly_bomb,
			},
			[door.tr] = {
				fly_bomb,
			},
			[door.bl] = {
				fly_bomb,
			},
			[door.br] = {
				fly_bomb,
			},
		},
		Dusts = 0,
	},
	{
		DoorSpawns = {
			[door.tl] = {
				big_boney,
			},
			[door.tr] = {
				boney,
			},
		},
		Dusts = 0,
	},
	{
		DoorSpawns = {
			[door.tl] = {
				hardy,
			},
			[door.tr] = {
				hardy,
			},
			[door.bl] = {
				clickety_clack,
			},
			[door.br] = {
				clickety_clack,
			},
		},
		Dusts = 0,
	},
	{
		Dusts = 5,
	},
	{
		DoorSpawns = {
			[door.tl] = {
				crackle,
			},
			[door.tr] = {
				coal_spider,
			},
			[door.bl] = {
				coal_spider,
			},
			[door.br] = {
				coal_spider,
			},
		},
		Dusts = 0,
	},
	{
		DoorSpawns = {
			[door.tr] = {
				dragonfly,
			},
			[door.bl] = {
				dragonfly_x,
			},
		},
		Dusts = 2,
	},
	{
		DoorSpawns = {
			[door.tl] = {
				fly_bomb,
			},
			[door.tr] = {
				fly_bomb,
			},
			[door.br] = {
				blaster,
			},
		},
		Dusts = 0,
	},
	{
		DoorSpawns = {
			[door.tl] = {
				rock_spider,
			},
			[door.tr] = {
				rock_spider,
			},
			[door.bl] = {
				rock_spider,
			},
			[door.br] = {
				danny,
			},
		},
		Dusts = 0,
	},
	{
		DoorSpawns = {
			[door.tl] = {
				migraine,
			},
			[door.tr] = {
				migraine,
			},
			[door.bl] = {
				fly_bomb,
			},
			[door.br] = {
				fly_bomb,
			},
		},
		Dusts = 0,
	},
	{
		DoorSpawns = {
			[door.tl] = {
				bone_fly,
			},
			[door.tr] = {
				clickety_clack,
			},
			[door.bl] = {
				bone_fly,
			},
			[door.br] = {
				clickety_clack,
			},
		},
		Dusts = 0,
	},
	{
		DoorSpawns = {
			[door.tl] = {
				clickety_clack,
			},
			[door.tr] = {
				clickety_clack,
			},
			[door.br] = {
				big_boney,
			},
		},
		Dusts = 0,
	},
	{
		DoorSpawns = {
			[door.tl] = {
				boney,
			},
			[door.tr] = {
				boney,
			},
			[door.bl] = {
				clickety_clack,
			},
			[door.br] = {
				clickety_clack,
			},
		},
		Dusts = 0,
	},
	{
		DoorSpawns = {
			[door.tl] = {
				clickety_clack,
			},
			[door.tr] = {
				clickety_clack,
			},
		},
		Dusts = 2,
	},
	{
		DoorSpawns = {
			[door.bl] = {
				coal_boy,
			},
			[door.br] = {
				coal_boy,
			},
		},
		Dusts = 0,
	},
	{
		DoorSpawns = {
			[door.tl] = {
				dragonfly_x,
			},
			[door.tr] = {
				dragonfly_x,
			},
			[door.bl] = {
				flesh_maiden,
			},
			[door.br] = {
				flesh_maiden,
			},
		},
		Dusts = 0,
	},
	{
		DoorSpawns = {
			[door.tl] = {
				coal_spider,
				coal_spider,
			},
			[door.tr] = {
				coal_spider,
				coal_spider,
			},
		},
		Dusts = 0,
	},
	{
		DoorSpawns = {
			[door.bl] = {
				carrion_princess,
			},
			[door.br] = {
				carrion_princess,
			},
		},
		Dusts = 3,
	},
	{
		DoorSpawns = {
			[door.bl] = {
				crackle,
			},
			[door.br] = {
				crackle,
			},
		},
		MouthSpawns = {
			crackle,
		},
	},
	{
		SpecialSpawns = {
			{49, necro},
			{55, necro},
		},
		Dusts = 2,
	},
	{
		DoorSpawns = {
			[door.br] = {
				bombmuncher,
			},
			[door.bl] = {
				bombmuncher,
			},
		},
		MouthSpawns = {
			clickety_clash,
		},
	},
	{
		DoorSpawns = {
			[door.tr] = {
				clickety_clack,
			},
			[door.tl] = {
				clickety_clack,
			},
		},
		MouthSpawns = {
			clickety_clash,
		},
	},
	{
		DoorSpawns = {
			[door.br] = {
				clickety_char,
			},
			[door.bl] = {
				clickety_char,
			},
		},
		MouthSpawns = {
			clickety_char,
		},
	},
	{
		DoorSpawns = {
			[door.tr] = {
				flesh_sistern,
			},
			[door.tl] = {
				flesh_sistern,
			},
		},
		Dusts = 1,
	},
	{
		DoorSpawns = {
			[door.tr] = {
				migraine,
			},
			[door.tl] = {
				migraine,
				
			},
			[door.br] = {
				bombmuncher,
			},
			[door.bl] = {
				bombmuncher,
			},
		},
	},
	{
		DoorSpawns = {
			[door.tr] = {
				clickety_char,
			},
			[door.tl] = {
				clickety_clack,
			},
			[door.br] = {
				clickety_clack,
			},
			[door.bl] = {
				clickety_char,
			},
		},
	},
	{
		DoorSpawns = {
			[door.br] = {
				pyroclasm,
			},
			[door.bl] = {
				pyroclasm,
			},
		},
		Dusts = 1,
	},
	{
		DoorSpawns = {
			[door.tr] = {
				ztewie_small,
			},
			[door.bl] = {
				ztewie_small,
			},
		},
		Mirages = 1,
	},
	{
		DoorSpawns = {
			[door.br] = {
				briar,
			},
			[door.bl] = {
				briar,
			},
		},
		MouthSpawns = {
			briar,
		},
	},
	{
		DoorSpawns = {
			[door.tr] = {
				briar,
			},
			[door.tl] = {
				briar,
			},
		},
		MouthSpawns = {
			ztewie_large,
		}
	},
	{
		DoorSpawns = {
			[door.tr] = {
				shellmet,
			},
			[door.tl] = {
				shellmet,
			},
			[door.br] = {
				shellmet,
			},
			[door.bl] = {
				shellmet,
			},
		},
	},
	{
		DoorSpawns = {
			[door.br] = {
				shellmet,
			},
			[door.bl] = {
				shellmet,
			},
		},
		MouthSpawns = {
			hardy,
		}
	},
	{
		DoorSpawns = {
			[door.tr] = {
				dragonfly,
			},
			[door.tl] = {
				dragonfly_x,
			},
			[door.br] = {
				blasted,
			},
			[door.bl] = {
				blasted,
			},
		},
	},
	{
		DoorSpawns = {
			[door.tr] = {
				blasted,
			},
			[door.tl] = {
				blasted,
			},
		},
		MouthSpawns = {
			blaster,
		}
	},
	{
		DoorSpawns = {
			[door.br] = {
				ruiner,
			},
			[door.bl] = {
				ruiner,
			},
		},
		Mirages = 1,
	},
	{
		DoorSpawns = {
			[door.tr] = {
				rock_spider,
				rock_spider,
			},
			[door.tl] = {
				rock_spider,
				rock_spider,
			},
		},
		Mirages = 2,
	},
	{
		DoorSpawns = {
			[door.tr] = {
				dragonfly,
			},
			[door.tl] = {
				dragonfly_x,
			},
		},
		Dusts = 2,
		Mirages = 1,
	},
	--[[{ --5 enemies will never work
		DoorSpawns = {
			[door.tr] = {
				briar,
			},
			[door.tl] = {
				crackle,
			},
			[door.br] = {
				migraine,
				
			},
			[door.bl] = {
				shellmet,
			},
		},
		Dusts = 1,
	},]]
}

local breathwaves = { -- Uses relative positions to Amon (40 units is 1 tile)
	{
		Vector(-160, -160),
		Vector(-60, -200),
		Vector(60, -200),
		Vector(160, -160),
	},
	{
		Vector(-80, -200),
		Vector(-160, -200),
		Vector(-120, -280),
		Vector(60, -120),
		Vector(120, -280),
	},
	{
		Vector(-160, -160),
		Vector(-120, -200),
		Vector(-80, -240),
		Vector(-40, -280),
	},
	{
		Vector(160, -160),
		Vector(120, -200),
		Vector(80, -240),
		Vector(40, -280),
	},
}

for i, set in pairs(breathwaves) do for j, pos in pairs(set) do
	breathwaves[i][j] = Vector(pos.X - 40, pos.Y)
end end

return amonwaves, breathwaves