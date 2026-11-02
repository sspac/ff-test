-- Page of Virtues --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

function mod:rollPageOfVitruesEffect()
	local rand = math.random()
	if rand < 0.05 then
		return mod.PageOfVirtuesWisps["Rare"][math.random(#(mod.PageOfVirtuesWisps["Rare"]))]
	elseif rand < 0.50 then
		return mod.PageOfVirtuesWisps["Uncommon"][math.random(#(mod.PageOfVirtuesWisps["Uncommon"]))]
	elseif rand < 0.83 then
		return mod.PageOfVirtuesWisps["Common"][math.random(#(mod.PageOfVirtuesWisps["Common"]))]
	else
		return CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES
	end
end

function mod:spawnPageOfVirtuesWisp(player, data, basedata, id)
	data["PageOfVirtues" .. id .. "Id"] = mod:rollPageOfVitruesEffect()
	
	local wisp = player:AddWisp(data["PageOfVirtues" .. id .. "Id"], player.Position, true)
	if wisp then
		mod:GetEntityData(wisp)["PageOfVirtues" .. id .. "Wisp"] = true
		basedata["PageOfVirtues" .. id .. "IsSet"] = true
		sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT, 1, 0, false, 1)
	end
end

function mod:setWispAsPageOfVirtuesWisp(player, data, basedata, id)
	if data["PageOfVirtues" .. id .. "Id"] ~= nil then
		local wisps = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, data["PageOfVirtues" .. id .. "Id"])
		for _, wisp in ipairs(wisps) do
			local wisp = wisp:ToFamiliar()
			if wisp.Player and wisp.Player.Index == player.Index and wisp.Player.InitSeed == player.InitSeed then
				local wispdata = mod:GetEntityData(wisp)
				if wispdata.PageOfVirtues1Wisp == nil then --and wispdata.PageOfVirtues2Wisp == nil then
					wispdata["PageOfVirtues" .. id .. "Wisp"] = true
					basedata["PageOfVirtues" .. id .. "IsSet"] = true
				end
				return
			end
		end
	end
	mod:spawnPageOfVirtuesWisp(player, data, basedata, id)
end

mod:AddCollectibleCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, FiendFolio.ITEM.COLLECTIBLE.PAGE_OF_VIRTUES, function(_, player)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.PAGE_OF_VIRTUES) then
		local basedata = mod:GetEntityData(player)
		local data = basedata.ffsavedata or basedata
		
		if basedata.PageOfVirtues1TilNextSpawn ~= nil and basedata.PageOfVirtues1TilNextSpawn > 0 then
			basedata.PageOfVirtues1TilNextSpawn = basedata.PageOfVirtues1TilNextSpawn - 1
		elseif not data.PageOfVirtues1Id then
			mod:spawnPageOfVirtuesWisp(player, data, basedata, 1)
		elseif not basedata.PageOfVirtues1IsSet then
			mod:setWispAsPageOfVirtuesWisp(player, data, basedata, 1)
		end
		
		--[[if basedata.PageOfVirtues2TilNextSpawn ~= nil and basedata.PageOfVirtues2TilNextSpawn > 0 then
			basedata.PageOfVirtues2TilNextSpawn = basedata.PageOfVirtues2TilNextSpawn - 1
		elseif not data.PageOfVirtues2Id then
			mod:spawnPageOfVirtuesWisp(player, data, basedata, 2)
		elseif not basedata.PageOfVirtues2IsSet then
			mod:setWispAsPageOfVirtuesWisp(player, data, basedata, 2)
		end]]--
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, function(_, e)
	if e.Variant == FamiliarVariant.WISP then
		local wisp = e:ToFamiliar()
		local wispdata = mod:GetEntityData(e)
		
		if wispdata.PageOfVirtues1Wisp and wisp.Player then
			local player = wisp.Player
			local basedata = mod:GetEntityData(player)
			local data = basedata.ffsavedata or basedata
			
			data.PageOfVirtues1Id = nil
			basedata.PageOfVirtues1IsSet = nil
			basedata.PageOfVirtues1TilNextSpawn = 29
		end
		
		--[[if wispdata.PageOfVirtues2Wisp and wisp.Player then
			local player = wisp.Player
			local basedata = mod:GetEntityData(player)
			local data = basedata.ffsavedata or basedata
			
			data.PageOfVirtues2Id = nil
			basedata.PageOfVirtues2IsSet = nil
			basedata.PageOfVirtues2TilNextSpawn = 29
		end]]--
	end
end, EntityType.ENTITY_FAMILIAR)
