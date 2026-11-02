local mod = FiendFolio
local game = Game()

local memberCardRoomCount
local memberCardRoomPos

local function tryRelocateMemberTrapdoorToPosition(pos)
	local room = game:GetRoom()
	local hasMemberCard
	local index = room:GetGridIndex(pos)
	for i = 0, room:GetGridSize() do
		local grid = room:GetGridEntity(i)
		if grid and grid.Desc.Type == GridEntityType.GRID_STAIRS and grid.Desc.Variant == 2 and i ~= index then
			hasMemberCard = true
			room:RemoveGridEntity(i, 0, false)
		end
	end

	if hasMemberCard then
		Isaac.GridSpawn(GridEntityType.GRID_STAIRS, 2, pos, true)
	end

    local ladders = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.TALL_LADDER, 0, false, false)
    for _, ladder in ipairs(ladders) do
        ladder.Position = pos
    end
end

function mod:memberCardRelocatorAI(npc)
	if not npc:Exists() then
		return
	end

    memberCardRoomCount = 0
    memberCardRoomPos = npc.Position

    tryRelocateMemberTrapdoorToPosition(npc.Position)

	npc:Remove()
end

FiendFolio.AddItemPickupCallback(function(player)
    if memberCardRoomCount == 1 then
        memberCardRoomCount = nil
        if memberCardRoomPos then
            tryRelocateMemberTrapdoorToPosition(memberCardRoomPos)
            memberCardRoomPos = nil
        end
    end
end, nil, CollectibleType.COLLECTIBLE_MEMBER_CARD)


function mod:memberCardRelocatorNewRoom()
    --POST_NEW_ROOM runs after the first AI check of the trapdoor relocator
    --So basically, don't remove it initially, but on the next NEW_ROOM
    if memberCardRoomCount == 0 then
        memberCardRoomCount = 1
    else
        memberCardRoomCount = nil
        memberCardRoomPos = nil
    end
    local room = game:GetRoom()
    if room:GetType() == RoomType.ROOM_SHOP then
        local desc = game:GetLevel():GetCurrentRoomDesc()

        local hasRelocator, relocatorPosition
        StageAPI.ForAllSpawnEntries(desc.Data, function(entry, spawn)
            if entry.Type == mod.FF.MemberCardRelocator.ID and entry.Variant == mod.FF.MemberCardRelocator.Var then
                hasRelocator = true
                relocatorPosition = StageAPI.VectorToGrid(spawn.X, spawn.Y)
                return true
            end
        end)

        if hasRelocator then
            local grid = room:GetGridEntity(25) -- default member card location
            if grid and grid.Desc.Type == GridEntityType.GRID_STAIRS and grid.Desc.Variant == 2 then
                room:RemoveGridEntity(25, 0, false)
            end

            local ladders = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.TALL_LADDER, 0, false, false)
            for _, ladder in ipairs(ladders) do
                ladder.Position = room:GetGridPosition(relocatorPosition)
            end

            if #ladders > 0 then
                for i = 0, game:GetNumPlayers() - 1 do
                    Isaac.GetPlayer(i).Position = ladders[1].Position
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.memberCardRelocatorNewRoom)

mod:AddCallback(ModCallbacks.MC_IS_PERSISTENT_ROOM_ENTITY, function(_,type,var)
    if type == mod.FF.MemberCardRelocator.ID and var == mod.FF.MemberCardRelocator.Var then
        return true
    end
end)