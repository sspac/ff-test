local mod = FiendFolio
local game = Game()

FiendFolio.BridgeSkins = {
	PET_ROCK = "gfx/familiar/petrock/grid_petrockbridge.png",
	EVIL_PET_ROCK = "gfx/familiar/petrock/grid_evilpetrockbridge.png",
}

local function getGridKey(gridIndex)
	return game:GetLevel():GetCurrentRoomDesc().ListIndex .. "." .. gridIndex
end

local function setSkin(grid, gfx)
	local sprite = grid:GetSprite()
	local layer = sprite:GetLayer(1)
	sprite:ReplaceSpritesheet(1, gfx, true)
	layer:SetCropOffset(Vector(-32 * grid.State, -160))
end

function mod.SetBridgeSkin(grid, bridgeSkin)
	mod.savedata.run.bridgeSkinIndexes[getGridKey(grid:GetGridIndex())] = bridgeSkin
end

mod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_PIT_UPDATE, function(_, pit)
	if pit.CollisionClass == GridCollisionClass.COLLISION_NONE and mod.savedata and mod.savedata.run and mod.savedata.run.bridgeSkinIndexes and mod.savedata.run.bridgeSkinIndexes[getGridKey(pit:GetGridIndex())] then
		if pit:GetSprite():GetLayer(1):GetSpritesheetPath() ~= mod.savedata.run.bridgeSkinIndexes[getGridKey(pit:GetGridIndex())] then
			setSkin(pit, mod.savedata.run.bridgeSkinIndexes[getGridKey(pit:GetGridIndex())])
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_INIT, function()
	mod.savedata.run.bridgeSkinIndexes = {}
end)