local mod = FiendFolio

-- Custom efficiency callbacks akin to MC_(POST_)ENTITY_TAKE_DMG, but specified by the SOURCE of the damage (up to subtype accuracy) and ONLY runs for NPCs.
--
-- mod:AddPreNpcTakeDmgFromSourceCallback(func, srcEntityType = -1, srcEntityVariant = -1, srcEntitySubType = -1)
-- mod:AddPostNpcTakeDmgFromSourceCallback(func, srcEntityType = -1, srcEntityVariant = -1, srcEntitySubType = -1)
--
-- Appropriate GetData tables provided for optimization. None of the provided arguments are ever nil.
--
-- The callback is intended to at least provide it srcEntityType, but you can omit all the params if you wanna just skip having to
-- call your function from `all_entities.lua`, and also skip having to check that the thing taking the damage is an NPC.
-- The "pre" variant runs on `CallbackPriority.EARLY-1`, over in `all_entities.lua`.

-- EXAMPLES:
--[[
mod:AddPreNpcTakeDmgFromSourceCallback(function(_, npc, data, damage, damageFlags, sourceEntity, sourceData, sourceRef, cooldown)
	if data.dontTakeDamageFromThisSource or sourceData.dontDoDamage then
		return false
	end
end, srcEntityType, srcEntityVariant, srcEntitySubType)

mod:AddPostNpcTakeDmgFromSourceCallback(function(_, npc, data, damage, damageFlags, sourceEntity, sourceData, sourceRef, cooldown)
	if sourceData.InstantKill then
		npc:Kill()
	end
end, srcEntityType, srcEntityVariant)
]]

local PRE_TAKE_DMG_FROM = {}
local POST_TAKE_DMG_FROM = {}

local function AddTakeDmgFromCallback(tab, func, id, var, subt)
	id = id or -1
	var = var or -1
	subt = subt or -1

	if not tab[id] then
		tab[id] = {}
	end
	tab = tab[id]
	if not tab[var] then
		tab[var] = {}
	end
	tab = tab[var]
	if not tab[subt] then
		tab[subt] = {}
	end

	table.insert(tab[subt], func)
end

function mod:AddPreNpcTakeDmgFromSourceCallback(...)
	AddTakeDmgFromCallback(PRE_TAKE_DMG_FROM, ...)
end

function mod:AddPostNpcTakeDmgFromSourceCallback(...)
	AddTakeDmgFromCallback(POST_TAKE_DMG_FROM, ...)
end

local function RunNpcTakeDmgFromSourceCallback(tab, pre, npc, data, damageAmount, damageFlags, sourceEnt, sourceData, sourceRef, cooldown)
	local sourceType = sourceEnt.Type

	tab = tab[sourceType]
	if not tab then return end

	local sourceVariant = sourceEnt.Variant
	local sourceSubType = sourceEnt.SubType

	sourceEnt = mod:CastEntity(sourceEnt)

	local returnTable = false

	for _, v in ipairs({-1, sourceVariant}) do
		local vartab = tab[v]
		if vartab then
			for _, s in ipairs({-1, sourceSubType}) do
				local subtab = vartab[s]
				if subtab then
					for _, func in ipairs(subtab) do
						local result = func(mod, npc, data, damageAmount, damageFlags, sourceEnt, sourceData, sourceRef, cooldown)
						if pre and result ~= nil then
							if result == false then
								return false
							elseif type(result) == "table" then
								returnTable = true
								if result.Damage then
									damageAmount = result.Damage
								end
								if result.DamageFlags then
									damageFlags = result.DamageFlags
								end
								if result.DamageCountdown then
									cooldown = result.DamageCountdown
								end
							end
						end
					end
				end
			end
		end
	end

	if returnTable then
		return {
			Damage = damageAmount,
			DamageFlags = damageFlags,
			DamageCountdown = cooldown,
		}, true
	end
end

function mod:RunPreNpcTakeDmgFromSourceCallback(...)
	return RunNpcTakeDmgFromSourceCallback(PRE_TAKE_DMG_FROM, true, ...)
end

function mod:RunPostNpcTakeDmgFromSourceCallback(...)
	return RunNpcTakeDmgFromSourceCallback(POST_TAKE_DMG_FROM, false, ...)
end
