local mod = FiendFolio



--[[ My little collection :) ]]--
local folders = {
	library = {
		"general",
		"rng",
		"sprite",
		"spawnHelpers",
		"player",
		"npc",
		"rooms",
	},
	items = {
		"blastulation",
		"parallelBombs",
		"laserPointer",
		"mysteriousFedora",
		"stevensHat",
		"pennyAlbum",
		"knifeBlock",
	},
	trinkets = {
		"sharpshootingPenny",
		"plushieSloth",
		"plushieLust",
		"plushieWrath",
		"plushieGluttony",
		"plushieGreed",
		"plushieEnvy",
		"plushiePride",
		"toyGun",
	},
	enemies = {
		"poki",
		"megaEmbryo",
		"angler",
		"tiyanak",
		"toadsie",
		"nonBinary",
		"murder",
	},
	misc = {
		"activeModulesCostume",
		"plushieSinsDrops",
		"wantedPoster",
		"playerForms",
		"ratBombs",
	},
}

-- Load the scripts
for folderName, folder in pairs(folders) do
	for i, file in pairs(folder) do
		include("ffscripts.pixelplz." .. folderName .. "." .. file)
	end
end



--[[ Enemy callbacks ]]--
local ENEMY_CALLBACKS = {
	Init   = { ID = ModCallbacks.MC_POST_NPC_INIT, },
	Update = { ID = ModCallbacks.MC_NPC_UPDATE, },

	PreRender  = { ID = ModCallbacks.MC_PRE_NPC_RENDER, },
	PostRender = { ID = ModCallbacks.MC_POST_NPC_RENDER, },

	PreCollision  = { ID = ModCallbacks.MC_PRE_NPC_COLLISION, },
	PostCollision = { ID = ModCallbacks.MC_POST_NPC_COLLISION, },

	PreGridCollision  = { ID = ModCallbacks.MC_PRE_NPC_GRID_COLLISION, },
	PostGridCollision = { ID = ModCallbacks.MC_NPC_GRID_COLLISION, },

	PreDMG  = { ID = ModCallbacks.MC_ENTITY_TAKE_DMG, },
	PostDMG = { ID = ModCallbacks.MC_POST_ENTITY_TAKE_DMG, },
	Death 	= { ID = ModCallbacks.MC_POST_NPC_DEATH, },
	Remove 	= { ID = ModCallbacks.MC_POST_ENTITY_REMOVE, },
}

local PIXEL_ENEMIES = {
	[ mod.FF.Angler.Var ] = {
		Init   = mod.AnglerInit,
		Update = mod.AnglerUpdate,
	},
	[ mod.FF.Tiyanak.Var ] = {
		Init   = mod.TiyanakInit,
		Update = mod.TiyanakUpdate,
	},
	[ mod.FF.Toadsie.Var ] = {
		Init 			 = mod.ToadsieInit,
		Update 			 = mod.ToadsieUpdate,
		PreRender 		 = mod.ToadsiePreRender,
		PreDMG 			 = mod.ToadsiePreDMG,
		PreGridCollision = mod.ToadsiePreGridCollision,
		Remove 			 = mod.ToadsieRemove,
	},
	[ mod.FF.NonBinary.Var ] = {
		Init 			  = mod.NonBinaryInit,
		Update 			  = mod.NonBinaryUpdate,
		PostCollision 	  = mod.NonBinaryPostCollision,
		PostGridCollision = mod.NonBinaryPostGridCollision,
		PostDMG 		  = mod.NonBinaryPostDMG,
		Death 			  = mod.NonBinaryDeath,
	},
	[ mod.FF.Murder.Var ] = {
		Init   = mod.MurderInit,
		Update = mod.MurderUpdate,
	},
	[ mod.FF.FriendWantedPoster.Var ] = {
		Init 		 = mod.FriendWantedPosterInit,
		Update 		 = mod.FriendWantedPosterUpdate,
		PreCollision = mod.FriendWantedPosterCollision,
		PreDMG 		 = mod.FriendWantedPosterDMG,
	},
}

-- Create the callbacks
for name, callback in pairs(ENEMY_CALLBACKS) do
	mod:AddPriorityCallback(callback.ID, callback.Priority or CallbackPriority.DEFAULT, function(moo, entity, ...)
		local callbacks = PIXEL_ENEMIES[entity.Variant]

		if callbacks then
			local func = callbacks[name]

			if func then
				return func(moo, entity, ...)
			end
		end
	end, mod.FFID.Pixel)
end