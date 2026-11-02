local mod = FiendFolio

mod.LoadScripts({
    "ffscripts.vermin.enemies.dangler"
})

function mod:checkVerminEnemies(npc)
	local var = npc.Variant
	if var == 1 then
		--nothing here yet
	else
		--The Default Boy
		mod:danglerAI(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkVerminEnemies, FiendFolio.FFID.Vermin)