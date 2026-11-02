local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

local function handleSandCastleChange(player, id, nextid)
	local data = mod:GetEntityData(player).ffsavedata.RunEffects
	local t0 = player:GetTrinket(0)
	local t1 = player:GetTrinket(1)
	if mod:GetRealTrinketId(t0) == id or mod:GetRealTrinketId(t1) == id then
		if t0 > 0 and mod:GetRealTrinketId(t0) == id then
			player:TryRemoveTrinket(t1)
			if t0 == id + TrinketType.TRINKET_GOLDEN_FLAG then
				if not data.goldCastle then
					data.goldCastle = true
				else
					data.goldCastle = nil
					local oldTrinket = mod.TrinketTracker:GetDataForPlayerSlot(player, 0, false)
					local data
					if oldTrinket then
						data = oldTrinket.Data
						oldTrinket.Data = {}
					end
					player:TryRemoveTrinket(t0)
					player:AddTrinket(nextid + TrinketType.TRINKET_GOLDEN_FLAG)
					if data then
						local newTrinket = mod.TrinketTracker:GetDataForPlayerSlot(player, 0, true)
						newTrinket.Data = data
					end
				end
			else
				local oldTrinket = mod.TrinketTracker:GetDataForPlayerSlot(player, 0, false)
				local data
				if oldTrinket then
					data = oldTrinket.Data
					oldTrinket.Data = {}
				end
				player:TryRemoveTrinket(t0)
				player:AddTrinket(nextid)
				if data then
					local newTrinket = mod.TrinketTracker:GetDataForPlayerSlot(player, 0, true)
					newTrinket.Data = data
				end
			end
			player:AddTrinket(t1)
			return true
		elseif t1 > 0 and mod:GetRealTrinketId(t1) == id then
			if t1 == id + TrinketType.TRINKET_GOLDEN_FLAG then
				if not data.goldCastle then
					data.goldCastle = true
				else
					data.goldCastle = nil
					local oldTrinket = mod.TrinketTracker:GetDataForPlayerSlot(player, 1, false)
					local data
					if oldTrinket then
						data = oldTrinket.Data
						oldTrinket.Data = {}
					end
					player:TryRemoveTrinket(t1)
					player:AddTrinket(nextid + TrinketType.TRINKET_GOLDEN_FLAG)
					if data then
						local newTrinket = mod.TrinketTracker:GetDataForPlayerSlot(player, 1, true)
						newTrinket.Data = data
					end
				end
			else
				local oldTrinket = mod.TrinketTracker:GetDataForPlayerSlot(player, 1, false)
				local data
				if oldTrinket then
					data = oldTrinket.Data
					oldTrinket.Data = {}
				end
				player:TryRemoveTrinket(t1)
				player:AddTrinket(nextid)
				if data then
					local newTrinket = mod.TrinketTracker:GetDataForPlayerSlot(player, 1, true)
					newTrinket.Data = data
				end
			end
			return true
		end
	else
		local smeltedCastles = player:GetSmeltedTrinkets({id})[id]
		if smeltedCastles.goldenTrinketAmount > 0 and not data.goldCastle then
			data.goldCastle = true
		else
			data.goldCastle = nil
			if smeltedCastles.trinketAmount > 0 then
				local oldTrinket = mod.TrinketTracker:GetSmelted(player, id)[1]
				local data
				if oldTrinket then
					data = oldTrinket.Data
					oldTrinket.Data = {}
				end
				player:TryRemoveSmeltedTrinket(id)
				player:AddSmeltedTrinket(nextid, false)
				if data then
					local newTrinkets = mod.TrinketTracker:GetDataForPlayerSmelted(player, nextid, game:GetFrameCount(), false, true)
					if #newTrinkets > 0 then newTrinkets[1].Data = data end
				end
			elseif smeltedCastles.goldenTrinketAmount > 0 then
				local oldTrinket = mod.TrinketTracker:GetSmelted(player, id + TrinketType.TRINKET_GOLDEN_FLAG)[1]
				local data
				if oldTrinket then
					data = oldTrinket.Data
					oldTrinket.Data = {}
				end
				player:TryRemoveSmeltedTrinket(id + TrinketType.TRINKET_GOLDEN_FLAG)
				player:AddSmeltedTrinket(nextid + TrinketType.TRINKET_GOLDEN_FLAG, false)
				if data then
					local newTrinkets = mod.TrinketTracker:GetDataForPlayerSmelted(player, nextid + TrinketType.TRINKET_GOLDEN_FLAG, game:GetFrameCount(), false, true)
					if #newTrinkets > 0 then newTrinkets[1].Data = data end
				end
			end
		end
		return true
	end
	return false
end

function mod:sandCastleHurt(player, flag, source)
	if not mod:isDamageSelfInflicted(flag, source) then
		local sandy = false
		if player:HasTrinket(FiendFolio.ITEM.ROCK.SAND_CASTLE) then
			sandy = handleSandCastleChange(player, FiendFolio.ITEM.ROCK.SAND_CASTLE, FiendFolio.ITEM.ROCK.DAMAGED_SAND_CASTLE)
		end
		if player:HasTrinket(FiendFolio.ITEM.ROCK.DAMAGED_SAND_CASTLE) and not sandy then
			sandy = handleSandCastleChange(player, FiendFolio.ITEM.ROCK.DAMAGED_SAND_CASTLE, FiendFolio.ITEM.ROCK.BROKEN_SAND_CASTLE)
		end
		if player:HasTrinket(FiendFolio.ITEM.ROCK.BROKEN_SAND_CASTLE) and not sandy then
			sandy = handleSandCastleChange(player, FiendFolio.ITEM.ROCK.BROKEN_SAND_CASTLE, FiendFolio.ITEM.ROCK.POCKET_SAND)
		end
		
		if sandy == true then
			sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 1, 0, false, 1.7)
			for i=1,6 do 
				local sand = Isaac.Spawn(1000, EffectVariant.TOOTH_PARTICLE, 0, player.Position, RandomVector()*math.random(1,5), nil):ToEffect()
				sand.Color = Color(220/255, 180/255, 170/255, 1, 0, 0, 0)
			end
			player:UseActiveItem(CollectibleType.COLLECTIBLE_DULL_RAZOR, UseFlag.USE_NOANIM, -1)
			mod:StopFFPlayerSoundsIGuess(player)
			mod.scheduleForUpdate(function()
				sfx:Stop(SoundEffect.SOUND_ISAAC_HURT_GRUNT)
			end, 0)
			return false
		end
	end
end

function mod:sandCastleNewLevel()
	for i = 1, game:GetNumPlayers() do
		local player = Isaac.GetPlayer(i - 1)
		if mod:GetEntityData(player).ffsavedata.RunEffects.goldCastle then
			mod:GetEntityData(player).ffsavedata.RunEffects.goldCastle = nil
		end
		if player:HasTrinket(FiendFolio.ITEM.ROCK.BROKEN_SAND_CASTLE) or player:HasTrinket(FiendFolio.ITEM.ROCK.DAMAGED_SAND_CASTLE) then
			local t0 = player:GetTrinket(0)
			local t1 = player:GetTrinket(1)
			
			if t1 > 0 then
				player:TryRemoveTrinket(t1)
			end
			if t0 > 0 then
				player:TryRemoveTrinket(t0)
			end
			local held = false
			
			if player:HasTrinket(FiendFolio.ITEM.ROCK.BROKEN_SAND_CASTLE) or player:HasTrinket(FiendFolio.ITEM.ROCK.DAMAGED_SAND_CASTLE) then
				local check = false
				local mult = player:GetTrinketMultiplier(FiendFolio.ITEM.ROCK.BROKEN_SAND_CASTLE)
				for i=1,mult do --A bit sad if you have multiple, but prevents multiplying castles
					player:TryRemoveTrinket(FiendFolio.ITEM.ROCK.BROKEN_SAND_CASTLE)
					check = true
				end
				if check then
					player:AddTrinket(FiendFolio.ITEM.ROCK.SAND_CASTLE)
					player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, UseFlag.USE_NOANIM, -1)
				end
				check = false
				local mult = player:GetTrinketMultiplier(FiendFolio.ITEM.ROCK.DAMAGED_SAND_CASTLE)
				for i=1,mult do --A bit sad if you have multiple, but prevents multiplying castles
					player:TryRemoveTrinket(FiendFolio.ITEM.ROCK.DAMAGED_SAND_CASTLE)
					check = true
				end
				if check then
					player:AddTrinket(FiendFolio.ITEM.ROCK.SAND_CASTLE)
					player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, UseFlag.USE_NOANIM, -1)
				end
			end
			
			if t0 > 0 then
				if t0 == FiendFolio.ITEM.ROCK.BROKEN_SAND_CASTLE or t0 == FiendFolio.ITEM.ROCK.DAMAGED_SAND_CASTLE then
					player:AddTrinket(FiendFolio.ITEM.ROCK.SAND_CASTLE)
				elseif t0 == FiendFolio.ITEM.ROCK.BROKEN_SAND_CASTLE + TrinketType.TRINKET_GOLDEN_FLAG or t0 == FiendFolio.ITEM.ROCK.DAMAGED_SAND_CASTLE + TrinketType.TRINKET_GOLDEN_FLAG then
					player:AddTrinket(FiendFolio.ITEM.ROCK.SAND_CASTLE + TrinketType.TRINKET_GOLDEN_FLAG)
				else
					player:AddTrinket(t0)
				end
			end
			if t1 > 0 then
				if t1 == FiendFolio.ITEM.ROCK.BROKEN_SAND_CASTLE or t1 == FiendFolio.ITEM.ROCK.DAMAGED_SAND_CASTLE then
					player:AddTrinket(FiendFolio.ITEM.ROCK.SAND_CASTLE)
				elseif t1 == FiendFolio.ITEM.ROCK.BROKEN_SAND_CASTLE + TrinketType.TRINKET_GOLDEN_FLAG or t1 == FiendFolio.ITEM.ROCK.DAMAGED_SAND_CASTLE + TrinketType.TRINKET_GOLDEN_FLAG then
					player:AddTrinket(FiendFolio.ITEM.ROCK.SAND_CASTLE + TrinketType.TRINKET_GOLDEN_FLAG)
				else
					player:AddTrinket(t1)
				end
			end
		end
	end
end

local sandCastleHits = {
	[mod.ITEM.ROCK.SAND_CASTLE] = 3,
	[mod.ITEM.ROCK.DAMAGED_SAND_CASTLE] = 2,
	[mod.ITEM.ROCK.BROKEN_SAND_CASTLE] = 1,
	[mod.ITEM.ROCK.SAND_CASTLE + TrinketType.TRINKET_GOLDEN_FLAG] = 6,
	[mod.ITEM.ROCK.DAMAGED_SAND_CASTLE + TrinketType.TRINKET_GOLDEN_FLAG] = 4,
	[mod.ITEM.ROCK.BROKEN_SAND_CASTLE + TrinketType.TRINKET_GOLDEN_FLAG] = 2,
}

local isGoldenSandCastle = {
	[mod.ITEM.ROCK.SAND_CASTLE + TrinketType.TRINKET_GOLDEN_FLAG] = true,
	[mod.ITEM.ROCK.DAMAGED_SAND_CASTLE + TrinketType.TRINKET_GOLDEN_FLAG] = true,
	[mod.ITEM.ROCK.BROKEN_SAND_CASTLE + TrinketType.TRINKET_GOLDEN_FLAG] = true,
}

function mod.shouldRenderSandCastleIcon(player, playerSlot)
	return player:HasTrinket(mod.ITEM.ROCK.SAND_CASTLE) or
	       player:HasTrinket(mod.ITEM.ROCK.DAMAGED_SAND_CASTLE) or
	       player:HasTrinket(mod.ITEM.ROCK.BROKEN_SAND_CASTLE)
end

function mod.onRenderSandCastleIcon(player, playerSlot, healthIndex, renderInfo)
	local data = mod:GetEntityData(player).ffsavedata.RunEffects
	local t0, t1 = player:GetTrinket(0), player:GetTrinket(1)
	local smeltedTrinkets = player:GetSmeltedTrinkets()
	local numHits = (sandCastleHits[t0] or 0) + (sandCastleHits[t1] or 0) +
	                smeltedTrinkets[mod.ITEM.ROCK.SAND_CASTLE].trinketAmount * 3 + smeltedTrinkets[mod.ITEM.ROCK.SAND_CASTLE].goldenTrinketAmount * 6 +
	                smeltedTrinkets[mod.ITEM.ROCK.DAMAGED_SAND_CASTLE].trinketAmount * 2 + smeltedTrinkets[mod.ITEM.ROCK.DAMAGED_SAND_CASTLE].goldenTrinketAmount * 4 +
	                smeltedTrinkets[mod.ITEM.ROCK.BROKEN_SAND_CASTLE].trinketAmount + smeltedTrinkets[mod.ITEM.ROCK.BROKEN_SAND_CASTLE].goldenTrinketAmount * 2
	if (isGoldenSandCastle[t0] or isGoldenSandCastle[t1] or
	    smeltedTrinkets[mod.ITEM.ROCK.SAND_CASTLE].goldenTrinketAmount > 0 or
	    smeltedTrinkets[mod.ITEM.ROCK.DAMAGED_SAND_CASTLE].goldenTrinketAmount > 0 or
	    smeltedTrinkets[mod.ITEM.ROCK.BROKEN_SAND_CASTLE].goldenTrinketAmount > 0) and mod:GetEntityData(player).ffsavedata.RunEffects.goldCastle then
		numHits = numHits - 1
	end
	if numHits <= 0 then return end

	-- render only two icons
	local icons = {}
	while numHits > 0 do
		if numHits % 3 == 1 then
			table.insert(icons, "SandCastle1")
			numHits = numHits - 1
		elseif numHits % 3 == 2 then
			table.insert(icons, "SandCastle2")
			numHits = numHits - 2
		else
			table.insert(icons, "SandCastle3")
			numHits = numHits - 3
		end
	end

	if #icons > 1 then
		mod.ExtraHealthIconSprite:Play(icons[2], true)
		mod.ExtraHealthIconSprite.Color = Color(1,1,1,0.5,0,0,0)
		CustomHealthAPI.Helper.RenderHealth(mod.ExtraHealthIconSprite, player, playerSlot, healthIndex, renderInfo.RenderOffset, renderInfo.TotalHealthRendered, renderInfo.ExtraOffset + Vector(3, -2))
	end
	mod.ExtraHealthIconSprite:Play(icons[1], true)
	mod.ExtraHealthIconSprite.Color = Color(1,1,1,1,0,0,0)
	CustomHealthAPI.Helper.RenderHealth(mod.ExtraHealthIconSprite, player, playerSlot, healthIndex, renderInfo.RenderOffset, renderInfo.TotalHealthRendered, renderInfo.ExtraOffset)
end

CustomHealthAPI.Library.RegisterAfterHealthIcon("SAND_CASTLE",
	{SortOrder = -300,
	 ShouldRenderFunc = mod.shouldRenderSandCastleIcon,
	 OnRenderFunc = mod.onRenderSandCastleIcon,})