-- Bridge Bombs --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local flag = TearFlagsLib.RegisterTearFlag("BRIDGE_BOMB")

function mod:bridgeBombsFlag(entity, player)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.BRIDGE_BOMBS) then
		TearFlagsLib.AddTearFlags(entity, flag)
	end
end
mod:AddCollectibleCallback(FiendFolio.CALLBACK.FF_POLL_BOMBFLAGS, FiendFolio.ITEM.COLLECTIBLE.BRIDGE_BOMBS, mod.bridgeBombsFlag)

function mod:bridgeBombsVariant(bomb, player)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.BRIDGE_BOMBS) then
		local var = bomb.Variant
		if mod:isReplaceableBombVariant(var) then
			if mod:isCopperVariant(var) then
				bomb.Variant = mod.BOMB.BRIDGE_COPPER
				bomb.Flags = bomb.Flags
			else
				bomb.Variant = mod.BOMB.BRIDGE
				bomb.Flags = bomb.Flags
			end
		end
	end
end
mod:AddCollectibleCallback(FiendFolio.CALLBACK.FF_SET_BOMB_VARIANT, FiendFolio.ITEM.COLLECTIBLE.BRIDGE_BOMBS, mod.bridgeBombsVariant)

-- https://www.geeksforgeeks.org/check-if-any-point-overlaps-the-given-circle-and-rectangle/
local function gridInRadius(grid, pos, radius)
	local x1 = grid.Position.X - 20
	local x2 = grid.Position.X + 20
	local y1 = grid.Position.Y - 20
	local y2 = grid.Position.Y + 20
	
    local xn = math.max(x1, math.min(pos.X, x2))
    local yn = math.max(y1, math.min(pos.Y, y2))
	
    local dx = xn - pos.X
    local dy = yn - pos.Y
	
    return (dx ^ 2 + dy ^ 2) <= radius ^ 2
end

mod:AddCallback(FiendFolio.CALLBACK.FF_POST_BOMBFLAG_EFFECTS, function(_, pos, radius, tearflags, src, radiusMult, player, sourceFlag, tearFlagParams)
	local room = game:GetRoom()
	if not (room:GetType() == RoomType.ROOM_BOSS and room:GetBossID() == BossType.MEGA_SATAN) then
		local explosionRadius = radius * radiusMult
		local madeBridge = false
		for x = math.ceil(explosionRadius / 40) * -1, math.ceil(explosionRadius / 40) do
			for y = math.ceil(explosionRadius / 40) * -1, math.ceil(explosionRadius / 40) do
				local grid = room:GetGridEntityFromPos(pos + Vector(x, y) * 40)
				if grid and grid:ToPit() then
					local pit = grid:ToPit()
					if gridInRadius(pit, pos, explosionRadius) then
						pit:MakeBridge(nil)
						madeBridge = true
					end
				end
			end
		end
		
		if madeBridge then
			sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 1.0, 0, false, 1.0)
		end
	end
end, flag)
