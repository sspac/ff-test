FiendFolio.LoadScripts({
	"ffscripts.blor.splitear",
})

local mod = FiendFolio
local game = Game()

mod.TearBarrage = {}

function mod:ClearBlorTables()
	mod.TearBarrage = {}
end

function mod:update132(npc)
	local sprite = npc:GetSprite();
	local npcdata = mod:GetEntityData(npc);
	local var = npc.Variant

	if var == mod.FF.SplitEar.Var then
		mod:splitearAI(npc, sprite, npcdata)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.update132, mod.FFID.Blor)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local room = game:GetRoom()
    for _, barrage in pairs(mod.TearBarrage) do
        mod:TearBarrageUpdate(barrage)
    end
end)

mod:AddCallback(ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, function(type, var, sub, index, seed)
    mod:ClearBlorTables()
end)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
    mod:ClearBlorTables()
end)