local mod = FiendFolio
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, function(_, slot)
	local d = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'SlotData', tostring(slot.InitSeed), {})
    local sprite = slot:GetSprite()
	local data = mod:GetEntityData(slot)

    if not data.init then
		data.state = "Idle"
		if not d.rand then
			d.rand = RNG()
			d.rand:SetSeed(slot.InitSeed, 0)
			d.plays = 0
		end

		function data.DropFunc()
			if not data.DidDropFunc then
				local dropTable = {
					{1, 1, 100}, --Random Dice, guaranteed
					{1, 1, 30}, --Extra Dice
					{1, 1, 25}, --Miscellaneous
					{1, 2, 40} --Coins
				}
				local results = mod:compoundRoll(dropTable, slot.InitSeed)
				for i=1,#results do
					if i < 3 then --Random Dice
						for j=1,results[i] do
							local sub = mod:GetRandomGlassDice(d.rand, nil, true, true)
							Isaac.Spawn(5, 300, sub, slot.Position, RandomVector()*d.rand:RandomInt(45)/10, slot)
						end
					elseif i == 2 then --Miscellaneous
						for j=1,results[i] do
							Isaac.Spawn(5, 0, 1, slot.Position, RandomVector()*d.rand:RandomInt(45)/10, slot)
						end
					elseif i > 2 then --Coins
						for j=1,results[i] do
							Isaac.Spawn(5, 20, 0, slot.Position, RandomVector()*d.rand:RandomInt(45)/10, slot)
						end
					end
				end
				data.DidDropFunc = true
				data.state = "Breaking"
			end
		end
		data.init = true
	end

	if data.state == "Idle" then
		mod:spritePlay(sprite, "Idle")
	elseif data.state == "Prizes" then
		if sprite:IsFinished("Prize") then
			data.state = "Idle"
		elseif sprite:IsEventTriggered("Prize") then
			sfx:Play(SoundEffect.SOUND_SLOTSPAWN, 1, 0, false, 1)
			local sub = mod:GetRandomGlassDice(d.rand, nil, true, true)
			Isaac.Spawn(5, 300, sub, slot.Position+Vector(10,0), Vector(0, mod:RandomInt(25, 50, d.rand)/10):Rotated(mod:RandomInt(-50, 50, d.rand)), slot)
		else
			mod:spritePlay(sprite, "Prize")
		end
	elseif data.state == "Initiate" then
		if sprite:IsFinished("Initiate") then
			if data.Prize == "Dice" then
				data.state = "Prizes"
			elseif data.Prize == "Break" then
				data.state = "Breaking"
				data.DropFunc = nil
				data.DidDropFunc = true
				--[[sfx:Play(SoundEffect.SOUND_BOSS1_EXPLOSIONS, 1, 0, false, 1)
				Isaac.Spawn(1000, EffectVariant.BOMB_EXPLOSION, 0, slot.Position, Vector.Zero, slot)]]
				Isaac.Explode(slot.Position, slot, 0)
				if d.rand:RandomInt(100) < 85 and not data.GiveGoodPrize then
					for i=1,3 do
						local sub = mod:GetRandomGlassDice(d.rand, nil, true, true)
						Isaac.Spawn(5, 300, sub, slot.Position, RandomVector()*d.rand:RandomInt(45)/10, slot)
					end
					slot:TakeDamage(1, DamageFlag.DAMAGE_EXPLOSION, EntityRef(slot), 1)
				else
					local sub = mod.GetItemFromCustomItemPool(mod.CustomPool.DICE_ITEMS, data.rand)
					local item = Isaac.Spawn(5, 100, sub, slot.Position, Vector.Zero, slot)
					item.SpawnerType = 6
					item.SpawnerVariant = mod.FF.DiceDispenser.Var
					mod.RemoveRecentRewards(slot.Position)
					slot:Remove()
				end
			end
		else
			mod:spritePlay(sprite, "Initiate")
		end
	elseif data.state == "Breaking" then
		if sprite:IsFinished("Death") then
			data.state = "Broken"
		else
			mod:spritePlay(sprite, "Death")
		end
	elseif data.state == "Broken" then
		sprite:Play("Broken", true)
	end

    FiendFolio.OverrideExplosionHack(slot, true)
end, mod.FF.DiceDispenser.Var)

FiendFolio.onMachineTouch(mod.FF.DiceDispenser.Var, function(player, slot)
	local d = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'SlotData', tostring(slot.InitSeed), {})
    local sprite = slot:GetSprite()
	local data = mod:GetEntityData(slot)
	if d.plays == nil then
		d.plays = 0
	end

	if data.state == "Idle" then
		if player:GetNumCoins() > 3 then
			d.plays = d.plays+1
			player:AddCoins(-4)
			sfx:Play(SoundEffect.SOUND_COIN_SLOT, 1, 0, false, 1)
			local prize = d.rand:RandomInt(100)
			local num = 3*d.plays
			local trueNum = 3
			if player:HasCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT) then
				trueNum = trueNum*2
			end
			data.state = "Initiate"
			if prize > num then
				data.Prize = "Dice"
			else
				if num <= trueNum then
					data.GiveGoodPrize = true
				end
				data.Prize = "Break"
			end
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	local d = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'PedestalData', tostring(pickup.InitSeed), {})
		if d.diceDispenserPedestal or pickup.SpawnerEntity then
			if d.diceDispenserPedestal or (pickup.SpawnerEntity.Type == 6 and pickup.SpawnerEntity.Variant == mod.FF.DiceDispenser.Var) then
				pickup:GetSprite():ReplaceSpritesheet(5, "gfx/items/slots/ff_chest_pedestals.png")
				pickup:GetSprite():LoadGraphics()
				pickup:GetSprite():SetOverlayFrame("Alternates", 6)
                d.diceDispenserPedestal = true
			end
		end
end, 100)