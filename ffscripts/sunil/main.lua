local mod = FiendFolio
local game = Game()
local rng = RNG()
local itemconfig = Isaac.GetItemConfig()

-- my lil enemy
mod.LoadScripts({
    "ffscripts.sunil.enemies.tinkle",
    "ffscripts.sunil.enemies.horse_fly",
-- items
	"ffscripts.sunil.items.collectibles.shuffletime",
	"ffscripts.sunil.items.collectibles.pocketmachine",
-- trinkets
	"ffscripts.sunil.items.trinkets.tokenonastring",
	"ffscripts.sunil.items.trinkets.shootingstar",
	"ffscripts.sunil.items.trinkets.longtimefiend",
	"ffscripts.sunil.items.trinkets.vanillaextract",
	"ffscripts.sunil.items.trinkets.timesarrow",
-- pickups
	"ffscripts.sunil.cards.sunilcards",
-- misc stuff
    "ffscripts.sunil.misc.randomcardspawners",
})

mod.SunilFunctions = {
	[mod.FF.Tinkle.Var] = {
		Update = mod.TinkleUpdate,
		--Death = mod.TinkleDeath,
	},
	[mod.FF.HorseFly.Var] = {
		Update = mod.HorseFlyUpdate,
		Death = mod.HorseFlyDeath,
	},
}

--slightly modified snake functions:

function mod:SunilEnemyUpdate(npc)
	local variant = npc.Variant
	local subtype = npc.SubType
	
	if mod.SunilFunctions[variant] and mod.SunilFunctions[variant].Update then
		mod.SunilFunctions[variant].Update(_, npc, subtype, variant)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.SunilEnemyUpdate, 61)

function mod:SunilEnemyDeath(npc)
	local variant = npc.Variant
	
	if mod.SunilFunctions[variant] and mod.SunilFunctions[variant].Death then
		mod.SunilFunctions[variant].Death(_, npc, variant)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.SunilEnemyDeath, 61)

-- function mod:SunilEnemyRender(npc)
	-- local variant = npc.Variant
	
	-- if mod.SunilFunctions[variant] and mod.SunilFunctions[variant].Render then
		-- mod.SunilFunctions[variant].Render(_, npc)
	-- end
-- end
-- mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.SunilEnemyRender, mod.FFID.Sunil)

-- function mod:SunilEnemyHurt(npc, damage, flag, source, countdown)
	-- local variant = npc.Variant
	
	-- if mod.SunilFunctions[variant] and mod.SunilFunctions[variant].Hurt then
		-- return mod.SunilFunctions[variant].Hurt(_, npc, damage, flag, source, countdown)
	-- end
-- end
-- mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.SunilEnemyHurt, mod.FFID.Sunil)

-- function mod:SunilEnemyRemove(npc)
	-- local variant = npc.Variant
	
	-- if mod.SunilFunctions[variant] and mod.SunilFunctions[variant].Remove then
		-- mod.SunilFunctions[variant].Remove(_, npc)
	-- end
-- end
-- mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, mod.SunilEnemyRemove, mod.FFID.Sunil)

-- function mod:SunilEnemyPreCollision(npc, npc2, low)
	-- local variant = npc.Variant
	
	-- if mod.SunilFunctions[variant] and mod.SunilFunctions[variant].PreCollision then
		-- mod.SunilFunctions[variant].PreCollision(_, npc, npc2, low)
	-- end
-- end
-- mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, mod.SunilEnemyPreCollision, mod.FFID.Sunil)