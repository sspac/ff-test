local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

function mod:AmazoniteOnAdd(player, id)
	if not mod:GetEntityData(player).ffsavedata.RunEffects.amazoniteMult then
		mod:GetEntityData(player).ffsavedata.RunEffects.amazoniteMult = 0
	end
	local added = player:GetTrinketMultiplier(FiendFolio.ITEM.ROCK.AMAZONITE)-mod:GetEntityData(player).ffsavedata.RunEffects.amazoniteMult
	local savedata = FiendFolio.savedata.run
	savedata.amazonite = (savedata.amazonite or 0)+added
	savedata.amazoniteUsed = (savedata.amazoniteUsed or 0)
	mod:GetEntityData(player).ffsavedata.RunEffects.amazoniteMult = player:GetTrinketMultiplier(FiendFolio.ITEM.ROCK.AMAZONITE)
end

function mod:AmazoniteOnRemove(player, id)
	local loss = mod:GetEntityData(player).ffsavedata.RunEffects.amazoniteMult-player:GetTrinketMultiplier(FiendFolio.ITEM.ROCK.AMAZONITE)
	local savedata = FiendFolio.savedata.run
	if savedata.amazonite then
		savedata.amazonite = math.max(0, savedata.amazonite-loss)
	else
		savedata.amazonite = 0
	end
	mod:GetEntityData(player).ffsavedata.RunEffects.amazoniteMult = player:GetTrinketMultiplier(FiendFolio.ITEM.ROCK.AMAZONITE)
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	local savedata = FiendFolio.savedata.run
	local data = mod:GetEntityData(pickup)
	if (savedata.amazonite and savedata.amazonite > 0) and (savedata.amazoniteUsed and savedata.amazoniteUsed < savedata.amazonite) and pickup:IsShopItem() then
		if pickup.Variant == 100 and savedata.amazonite >= 1 and pickup.Price > 0 then
			pickup.AutoUpdatePrice = false
			pickup.Price = 5
			data.amazoniteReduced = true
		elseif pickup.Variant ~= 100 then
			pickup.AutoUpdatePrice = false
			pickup.Price = PickupPrice.PRICE_FREE
			data.amazoniteReduced = true
		end
	elseif data.amazoniteReduced == true then
		pickup.AutoUpdatePrice = true
		data.amazoniteReduced = nil
	end
end)

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, coll, low)
	local data = mod:GetEntityData(pickup)
	if data.amazoniteReduced and pickup:IsShopItem() and coll:ToPlayer() and coll:ToPlayer():GetNumCoins() >= pickup.Price then
		local savedata = FiendFolio.savedata.run
		if (savedata.amazonite and savedata.amazonite > 0) and (savedata.amazoniteUsed and savedata.amazoniteUsed < savedata.amazonite) then
			local player = coll:ToPlayer()
			local pdata = mod:GetEntityData(player).ffsavedata.RunEffects
			
			sfx:Play(SoundEffect.SOUND_CASH_REGISTER, 1, 0, false, 1)
			if not pdata.amazonitePurchased then
				pdata.amazonitePurchased = {}
			end
			table.insert(pdata.amazonitePurchased, {pickup.Type, pickup.Variant, pickup.SubType})
			if pickup.Variant == 100 and pickup.Price > 0 then
				player:AddCoins(-pickup.Price)
			end
			pickup:Remove()
			Isaac.Spawn(1000, 15, 0, pickup.Position, Vector.Zero, player)
			savedata.amazoniteUsed = (savedata.amazoniteUsed or 0)+1
			for i=1,4 do
				Isaac.Spawn(1000, 98, 0, pickup.Position, RandomVector()*math.random(2,6), player)
			end
			Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, coll, low)
			return true
		end
	end
end)

function mod:amazoniteNewLevelGeneric()
	local savedata = FiendFolio.savedata.run
	if savedata.amazonite then
		savedata.amazonite = 0
	end
	if savedata.amazoniteUsed then
		savedata.amazoniteUsed = 0
	end
end

function mod:amazoniteNewLevel(player, data, room)
	local savedata = FiendFolio.savedata.run
	if player:HasTrinket(FiendFolio.ITEM.ROCK.AMAZONITE) then
		local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.AMAZONITE)
		savedata.amazonite = savedata.amazonite+math.ceil(mult)
	end
	if data.ffsavedata.RunEffects.amazonitePurchased then
		local rng = player:GetTrinketRNG(mod.ITEM.ROCK.AMAZONITE)
		mod.scheduleForUpdate(function()
			local bought = data.ffsavedata.RunEffects.amazonitePurchased
			player:AnimateHappy()
			for _,item in ipairs(bought) do
				local pickup = Isaac.Spawn(item[1], item[2], item[3], room:FindFreePickupSpawnPosition(player.Position, 40, true, false), Vector.Zero, player)
				Isaac.Spawn(1000, 15, 0, pickup.Position, Vector.Zero, player)
			end
			sfx:Play(SoundEffect.SOUND_CASH_REGISTER, 1, 0, false, 1)
			for i=1,4 do
				Isaac.Spawn(1000, 98, 0, player.Position, Vector(0, mod:RandomInt(2, 6)):Rotated(rng:RandomInt(360)), player)
			end
			data.ffsavedata.RunEffects.amazonitePurchased = nil
		end, 3)
	end
end
--mod:AddTrinketCallback("FF_NEW_LEVEL_PLAYER_FERRIUM", mod.ITEM.ROCK.AMAZONITE, mod.amazoniteNewLevel)