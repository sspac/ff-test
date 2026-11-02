-- Anarchist's Easy-Bake --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local bal = {
    keepAwayPlayer = 60, --tries to be at least this far away from players
	keepAwayBomb = 20,
    bombStagger = 4,
}

-- thx ferrium for charred card
function mod:findEasyBakeBombSpot(p, rng)
    local room = game:GetRoom()
    local size = room:GetGridSize()
    local backup = {}
    local goods = {}
    local players = {}
    for i = 1, game:GetNumPlayers() do
		table.insert(players, Isaac.GetPlayer(i-1))
    end
	local bombs = Isaac.FindByType(EntityType.ENTITY_BOMB)
    for i=0, size do
        if room:GetGridCollision(i) == GridCollisionClass.COLLISION_NONE then
            local pos = room:GetGridPosition(i)
            table.insert(backup, pos)
			local bad = false
            for _,player in ipairs(players) do
                if player.Position:Distance(pos) <= bal.keepAwayPlayer then
                    bad = true
					break
                end
            end
			if not bad then
				for _,bomb in ipairs(bombs) do
					if bomb.Position:Distance(pos) <= bal.keepAwayBomb then
						bad = true
						break
					end
				end
			end
			if not bad then
				table.insert(goods, pos)
			end
        end
    end

    if #goods > 0 then
        local results = mod:getSeveralDifferentNumbers(1, #goods, rng)
        return goods[results[1]]
    elseif #backup > 0 then
        local results = mod:getSeveralDifferentNumbers(1, #backup, rng)
        return backup[results[1]]
    else
        return {p.Position}
    end
end

local easyBakeBombFuncs = {}
local lastFrameEasyBakeBombed = nil
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, id, rng, player, useflags, activeslot, customvardata)
	table.insert(easyBakeBombFuncs, function()
		local pos = mod:findEasyBakeBombSpot(player, rng)
		local trol = Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_TROLL, 0, pos, Vector.Zero, player):ToBomb()
		trol:AddTearFlags(player:GetBombFlags(true))
		
		local data = mod:GetEntityData(trol)
		data.ffOverrideBombFlagSource = mod.BombFlagSource.ANARCHISTS_EASY_BAKE
		Isaac.RunCallbackWithParam(FiendFolio.CALLBACK.FF_POLL_BOMBFLAGS, mod.BombFlagSource.ANARCHISTS_EASY_BAKE, trol, player, mod.BombFlagSource.ANARCHISTS_EASY_BAKE)
		data.HasPolledBombFlags = true
	end)

	return useflags ~= useflags | UseFlag.USE_NOANIM
end, FiendFolio.ITEM.COLLECTIBLE.ANARCHISTS_EASY_BAKE)

mod:AddPriorityCallback(ModCallbacks.MC_POST_UPDATE, CallbackPriority.EARLY, function()
	local frame = game:GetFrameCount()
	if #easyBakeBombFuncs >= 1 and frame - (lastFrameEasyBakeBombed or (-1 * bal.bombStagger)) >= bal.bombStagger then
		easyBakeBombFuncs[1]()
		table.remove(easyBakeBombFuncs, 1)
		lastFrameEasyBakeBombed = frame
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	easyBakeBombFuncs = {}
	lastFrameEasyBakeBombed = nil
end)