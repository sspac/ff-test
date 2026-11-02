local mod = FiendFolio
local game = Game()

-- Scripts

FiendFolio.LoadScripts({
	-- Util
	"ffscripts.connor.utilities.range_prediction",
	"ffscripts.connor.utilities.misc_functions",
	"ffscripts.connor.utilities.trinket_tracker",
	-- Items
	"ffscripts.connor.items.brown_horn",
	"ffscripts.connor.items.nyx",
	"ffscripts.connor.items.loaded_d6",
	"ffscripts.connor.items.isaac_dot_chr",
	"ffscripts.connor.items.dads_battery",
	"ffscripts.connor.items.gaper_in_a_jar",
	"ffscripts.connor.items.double_dog",
	-- Trinkets
	"ffscripts.connor.trinkets.broken_record",
	"ffscripts.connor.trinkets.wormhole_rock",
	"ffscripts.connor.trinkets.scarab_penny",
	"ffscripts.connor.trinkets.stack_of_penny",
	"ffscripts.connor.trinkets.sisyphean_boulder",
	"ffscripts.connor.trinkets.blasphemous_trinkets",
	-- Cards Etc
	"ffscripts.connor.cards.discs",
	"ffscripts.connor.cards.blank_letter_tile",
	"ffscripts.connor.cards.fucked_up_king_of_pentacles",
	-- Pickups
	-- "ffscripts.connor.pickups.custom_pickups",
	"ffscripts.connor.pickups.custom_batteries",
	"ffscripts.connor.pickups.platinum_penny",
	"ffscripts.connor.pickups.lil_penny",
	"ffscripts.connor.pickups.coins_hud",
	-- Enemies
	"ffscripts.connor.enemies.beacon",
	"ffscripts.connor.enemies.new_year",
	"ffscripts.connor.enemies.kawasaki",
	"ffscripts.connor.enemies.little_boy",
	"ffscripts.connor.enemies.man_at_arms",
	"ffscripts.connor.enemies.beetle",
	"ffscripts.connor.enemies.BRANDON",
	"ffscripts.connor.enemies.foster_fly",
	"ffscripts.connor.enemies.desolator",
	"ffscripts.connor.enemies.elephant",
	"ffscripts.connor.enemies.elephantjr",
	"ffscripts.connor.enemies.uranium_spider",
	"ffscripts.connor.enemies.flux",
	"ffscripts.connor.enemies.heads",
	-- Grids
	"ffscripts.connor.grids.uranium",
	-- GUNS
	"ffscripts.connor.guns.temp_extra_guns",
	"ffscripts.connor.guns.dr_fetus",
	"ffscripts.connor.guns.brimstone",
	"ffscripts.connor.guns.lead_pencil",
	"ffscripts.connor.guns.spirit_sword",
	"ffscripts.connor.guns.moms_knife",
	-- Misc
	"ffscripts.connor.ff_character_pause_screen_marks",
	"ffscripts.connor.utilities.negative_charge",
	"ffscripts.connor.utilities.trail_renderer",
	"ffscripts.connor.utilities.multishot",
	"ffscripts.connor.misc.radiation",
	"ffscripts.ferrium.misc.renderSpells", --sorry, this wasn't working when I did it in my section -- hi ferrium
})

-- Enemy callbacks

local ENEMY_CALLBACKS = {
	Init = { Callback = ModCallbacks.MC_POST_NPC_INIT },
	--PreUpdate = { Callback = ModCallbacks.MC_PRE_NPC_UPDATE },
	Update = { Callback = ModCallbacks.MC_NPC_UPDATE },
	Render = { Callback = ModCallbacks.MC_POST_NPC_RENDER },
	Death = { Callback = ModCallbacks.MC_POST_NPC_DEATH },
	PreCollisionEarly = {
		Callback = ModCallbacks.MC_PRE_NPC_COLLISION,
		Priority = CallbackPriority.EARLY,
	},
	PreCollisionLate = {
		Callback = ModCallbacks.MC_PRE_NPC_COLLISION,
		Priority = CallbackPriority.LATE,
	},
	PreDamageEarly = {
		Callback = ModCallbacks.MC_ENTITY_TAKE_DMG,
		Priority = CallbackPriority.EARLY,
	},
	PreDamageLate = {
		Callback = ModCallbacks.MC_ENTITY_TAKE_DMG,
		Priority = CallbackPriority.LATE,
	},
}
-- Global collision: beacon
-- Global damage: desolator, foster fly
-- Global projectile: desolator, kawasaki, brandon

local CONNOR_ENEMIES = {
	[mod.FF.Beacon.Var] = {
		Init = mod.BeaconInit,
		Update = mod.BeaconUpdate,
		Death = mod.BeaconDeath,
		PreCollisionLate = mod.BeaconCollision,
		PreDamageEarly = mod.BeaconDamage,
	},
	[mod.FF.Beetle.Var] = {
		Init = mod.NpcBeetleInit,
		Update = mod.BeetleUpdate,
		PreCollisionEarly = mod.BeetleCollision,
	},
	[mod.FF.Brandon.Var] = {
		Update = mod.BrandonUpdate,
	},
	[mod.FF.Desolator.Var] = {
		Init = mod.DesolatorInit,
		Update = mod.DesolatorUpdate,
	},
	[mod.FF.Elephant.Var] = {
		Init = mod.ElephantInit,
		Update = mod.ElephantUpdate,
		PreDamageEarly = mod.ElephantTakeDamageEarly,
		PreDamageLate = mod.ElephantTakeDamageLate,
	},
	[mod.FF.ElephantJr.Var] = {
		Init = mod.ElephantJrInit,
		Update = mod.ElephantJrUpdate,
		PreDamageEarly = mod.ElephantJrTakeDamageEarly,
		PreDamageLate = mod.ElephantJrTakeDamageLate,
	},
	[mod.FF.Flux.Var] = {
		Init = mod.FluxInit,
		Update = mod.FluxUpdate,
	},
	[mod.FF.Kawasaki.Var] = {
		Update = mod.KawasakiUpdate,
		Death = mod.KawasakiDeath,
	},
	[mod.FF.NewYear.Var] = {
		Update = mod.NewYearUpdate,
		Render = mod.NewYearRender,
		PreCollisionEarly = mod.NewYearCollision,
	},
}

-- Variants of other entities:
-- LittleBoy
-- ManAtArms etc
-- FosterFly
-- UraniumSpider

for key, tab in pairs(ENEMY_CALLBACKS) do
	mod:AddPriorityCallback(tab.Callback, tab.Priority or CallbackPriority.DEFAULT, function(_, npc, ...)
		local vartab = CONNOR_ENEMIES[npc.Variant]
		if vartab then
			local func = vartab[key]
			if func then
				return func(mod, npc, ...)
			end
		end
	end, FiendFolio.FFID.Connor)
end

-- Consider optimizations for more player callbacks like collision, cache eval
-- Also optimize the trinket tracker a lil
-- And effects
-- And radiation

-- General callbacks

function mod:connorPostUpdate()
	mod:brokenRecordPostUpdate()
	mod:dadsBatteryPostUpdate()
	mod:chargeDebtPostUpdate()
	mod:SisypheanBoulderPostUpdate()
	mod:CheckExpiredDiscs()
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.connorPostUpdate)

function mod:connorPostRender()
	mod:discPostRender()
	mod:brokenRecordRenderSprites()
end
mod:AddCallback(ModCallbacks.MC_POST_ROOM_RENDER_ENTITIES, mod.connorPostRender)

function mod:connorNewRoom()
	mod:spindleNewRoom()
	mod:wormholeRockNewRoom()
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.connorNewRoom)

function mod:connorNewFloor()
	mod:resetBlankLetterTileData()
	mod:wormholeRockNewRoom()
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.connorNewFloor)

-- Player callbacks

function mod:connorPlayerUpdate(player, data)
	mod:blankLetterTileUpdate(player, data)
	mod:handleChargeDebt(player, data)
end

function mod:connorPEffectUpdate(player, data)
	mod:FriendSwordPeffect(player, data)
	mod:RadiationPlayerUpdate(player, data)
	mod:DoubleDogPeffect(player, data)
	mod:nyxPlayerUpdate(player, data)
	mod:CheckSisypheanBoulder(player, data)
end

function mod:connorPlayerRender(player, data, renderOffset)
	mod:GaperInAJarQueuedRander(player, data, renderOffset)
	mod:DoubleDogRender(player, data)
	mod:blankLetterTileRender(player, data)
	mod:isaacDotChrRender(player, data)
	--mod:SisypheanBoulderPlayerRender(player, data)
end

-- Generic entity callbacks

function mod:connorPostEntityDeath(entity)
	mod:brownHornEntityDeath(entity)
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.connorPostEntityDeath)

function mod:connorPostEntityRemove(entity)
	mod:brownHornEntityRemove(entity)
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, mod.connorPostEntityRemove)

-- Misc entity callbacks

function mod:connorEnemyUpdate(entity, data)
	mod:brownHornEntityUpdate(entity, data)
	mod:nyxEnemyUpdate(entity, data)
	mod:RadiationEnemyUpdate(entity, data)
end

function mod:connorFamiliarUpdate(entity)
	mod:brownHornEntityUpdate(entity, mod:GetEntityData(entity))
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.connorFamiliarUpdate)

function mod:connorLaserUpdate(laser)
	mod:nyxChainLightningUpdate(laser)
end
mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, mod.connorLaserUpdate)

function mod:connorPostTearUpdate(tear)
	mod:wormholeRockProjUpdate(tear, mod:GetEntityData(tear))
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.connorPostTearUpdate)

function mod:connorPostProjUpdate(proj, data)
	mod:DesolatorProjectileUpdate(proj, data)
	mod:KawasakiProjectileUpdate(proj, data)
	mod:wormholeRockProjUpdate(proj, data)
end

function mod:connorPostBombUpdate(bomb)
	mod:wormholeRockProjUpdate(bomb, mod:GetEntityData(bomb))
end
mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, mod.connorPostBombUpdate)
