local mod = FiendFolio
local game = Game()

FiendFolio.UraniumGrid = StageAPI.CustomGrid("FFUranium", {
	BaseType = GridEntityType.GRID_ROCK,
	Anm2 = "gfx/grid/uranium.anm2",
	Animation = "Idle",
	VariantFrames = 2,
	RemoveOnAnm2Change = true,
	OverrideGridSpawns = true,
	SpawnerEntity = {Type = FiendFolio.FFID.Grid, Variant = 1043}
})

local function UraniumUpdate(customGrid)
	if not customGrid.PersistentData.Destroyed then
		mod:SetRadioactiveAura(customGrid, customGrid.PersistentData.AuraSize or 80)
	end
end
StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_UPDATE", 0, UraniumUpdate, "FFUranium")

StageAPI.AddCallback("FiendFolio", "POST_SPAWN_CUSTOM_GRID", 1, function(customGrid)
	if customGrid.PersistentData.SpawnerEntity then
		customGrid.PersistentData.AuraSize = customGrid.PersistentData.SpawnerEntity.SubType
	end
	UraniumUpdate(customGrid)
	if customGrid.PersistentData.DidFirstSpawn and customGrid.ffRadioactiveAura then
		customGrid.ffRadioactiveAura.Size = customGrid.PersistentData.AuraSize or 80
	end
	customGrid.PersistentData.DidFirstSpawn = true
end, "FFUranium")

-- Update neighboring big rock frames so that they don't connect into nothing
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function ()
	local grids = StageAPI.GetCustomGrids(nil, "FFUranium")
	for _, customGrid in ipairs(grids) do
		local rock = customGrid.GridEntity:ToRock()
		if rock then
			rock:UpdateNeighbors()
		end
	end
end)

--[[StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_DESTROY", 1, function(customGrid)
	FiendFolio.savedata.totalUraniumRocksDestroyed = FiendFolio.savedata.totalUraniumRocksDestroyed or 0
	FiendFolio.savedata.totalUraniumRocksDestroyed = FiendFolio.savedata.totalUraniumRocksDestroyed + 1

	if FiendFolio.savedata.totalUraniumRocksDestroyed >= 10 then
		if not FiendFolio.ACHIEVEMENT.MTN_DEW:IsUnlocked(true) then
			FiendFolio.ACHIEVEMENT.MTN_DEW:Unlock()
		end
	end
end, "FFUranium")]]--