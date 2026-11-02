local mod = FiendFolio

mod.BlastulationEmbryos = {}
mod.EmbryoPickers = {
	Enemy 		  = WeightedOutcomePicker(),
	Boss 		  = WeightedOutcomePicker(),
	EvenPlayfield = WeightedOutcomePicker(),
}



-- Register a Blastulation Embryo
---@param embryo table A table containing the variant, rarity and callbacks of the Embryo.
function FiendFolio:AddEmbryo(embryo)
	mod.BlastulationEmbryos[embryo.Variant] = embryo

	-- Add it to the spawn pickers
	local enemyWeight = embryo.Special and 25 or 100
	mod.EmbryoPickers.Enemy:AddOutcomeWeight(embryo.Variant, enemyWeight)

	local bossWeight = embryo.Special and 75 or 100
	mod.EmbryoPickers.Boss:AddOutcomeWeight(embryo.Variant, bossWeight)

	if not embryo.Special then
		mod.EmbryoPickers.EvenPlayfield:AddOutcomeWeight(embryo.Variant, 100)
	end
end



-- Load the scripts
local scripts = {
	"item",
	"progressText",
	"compatibility",

	-- Common
	"isaac",
	"sucker",
	"swarm",
	"burning",
	"host",
	"chubber",
	"drowned",
	"rock",
	"throwable",
	"mr",
	"pale",
	"dank",
	"blastocyst",
	"scarred",
	"angelic",
	"steven",
	"sketch",
	"radical",
	"embrrryo",
	"mishap",
	"embryobot",
	"guillotine",
	"prism",
	"jelly",
	"fortuneTeller",
	"champion",
	"sniffing",
	"iceCream",
	"misc",

	-- Special
	"gagger",
	"heart",
	"embrainyo",
	"grudge",
	"peeping",
	"level2",
	"shady",
	"tainted",
	"skinless",
	"dr",
}
for i, script in pairs(scripts) do
	include("ffscripts.pixelplz.blastulation." .. script)
end



-- The funny callbacks
-- Embryo init
function mod:EmbryoInit(entity)
	local entry = mod.BlastulationEmbryos[entity.Variant]

	if entry and entry.Init then
		entry:Init(entity)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.EmbryoInit, EntityType.ENTITY_EMBRYO)

-- Embryo update
function mod:EmbryoUpdate(entity)
	mod:BlastulationEmbryoConvert(entity)

	local entry = mod.BlastulationEmbryos[entity.Variant]

	if entry and entry.Update then
		local result = entry:Update(entity)

		if result ~= nil then
			return result
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.EmbryoUpdate, EntityType.ENTITY_EMBRYO)

-- Embryo collision
function mod:EmbryoCollision(entity, collider, bool)
	local entry = mod.BlastulationEmbryos[entity.Variant]

	if entry and entry.Collision then
		local result = entry:Collision(entity, collider, bool)

		if result ~= nil then
			return result
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, mod.EmbryoCollision, EntityType.ENTITY_EMBRYO)

-- Embryo damage
function mod:EmbryoDMG(entity, damageAmount, damageFlags, damageSource, damageCountdownFrames)
	local entry = mod.BlastulationEmbryos[entity.Variant]

	if entry and entry.DMG then
		local result = entry:DMG(entity:ToNPC(), damageAmount, damageFlags, damageSource, damageCountdownFrames)

		if result ~= nil then
			return result
		end
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.EmbryoDMG, EntityType.ENTITY_EMBRYO)

-- Embryo death
function mod:EmbryoDeath(entity)
	mod:UpdateBlastulationCache()

	local entry = mod.BlastulationEmbryos[entity.Variant]

	if entry and entry.Death then
		entry:Death(entity:ToNPC())
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.EmbryoDeath, EntityType.ENTITY_EMBRYO)

-- Tear Collision
function mod:EmbryoTearCollide(tear, target, bool)
	local result =
	mod:PrismEmbryoTearCollision(tear, target, bool) or
	mod:FriendlyEnemyTearCollision(tear, target, bool)

	if result ~= nil then
		return result
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, mod.EmbryoTearCollide)