local mod = FiendFolio
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, function(_, slot)
	local d = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'SlotData', tostring(slot.InitSeed), {})
    local sprite = slot:GetSprite()
	local data = mod:GetEntityData(slot)
	local tempRNG = slot:GetDropRNG()

	if not data.init then
		if d.played then
			data.state = "Played"
		else
			data.state = "Idle"
		end
		if not d.rand then
			d.rand = RNG()
			d.rand:SetSeed(slot.InitSeed, 0)
			d.plays = 0
		end
		
		function data.DropFunc()
			if not data.DidDropFunc then
				local dropTable = {
					{1, 3, 100}, --Random Coins, guaranteed
					{1, 2, 40}, --They're all coins
					{1, 1, 50},
				}
				local results = mod:compoundRoll(dropTable, slot.InitSeed)
				for i=1,#results do
					for j=1,results[i] do
						Isaac.Spawn(5, 20, 0, slot.Position, RandomVector()*d.rand:RandomInt(45)/10, slot)
					end
				end
				data.DidDropFunc = true
				data.state = "Broken"
			end
		end
		data.init = true
	end

	if data.state == "Idle" then
		mod:spritePlay(sprite, "Idle1")
	elseif data.state == "Played" then
		mod:spritePlay(sprite, "Idle2")
	elseif data.state == "Broken" then
		mod:spritePlay(sprite, "Death")
	elseif data.state == "Playing" then
		if sprite:IsFinished("Initiate") then
			data.state = "Played"

		elseif sprite:IsEventTriggered("Prize") then
			sfx:Play(SoundEffect.SOUND_SLOTSPAWN, 1, 0, false, 1)
			d.played = true
			data.clicking = false

			local trinket = mod.ITEM.ROCK.ORE_PENNY
			if not mod.GolemExists() then
				trinket = mod:GetPennyTrinketIncludingFunnies(d.rand)
			end
			Isaac.Spawn(5, 350, trinket, slot.Position, Vector(0, mod:RandomInt(25, 50, d.rand)/10):Rotated(mod:RandomInt(-50, 50, d.rand)), slot)

			if mod.CanRunUnlockAchievements() then
				FiendFolio.savedata.pennyPressesUsed = (FiendFolio.savedata.pennyPressesUsed or 0) + 1

				if FiendFolio.savedata.pennyPressesUsed >= 10 and not FiendFolio.ACHIEVEMENT.PENNY_ALBUM:IsUnlocked(true) then
					FiendFolio.ACHIEVEMENT.PENNY_ALBUM:Unlock()
				end
			end

		elseif sprite:IsEventTriggered("Sound1") then
			sfx:Play(SoundEffect.SOUND_CLAP, 0.6, 0, false, mod:RandomInt(220,240,tempRNG)/100)
		elseif sprite:IsEventTriggered("Sound2") then
			data.clicking = true
		else
			mod:spritePlay(sprite, "Initiate")
		end
	end

	if data.clicking then
		sfx:Play(SoundEffect.SOUND_CLAP, 0.6, 0, false, mod:RandomInt(350,380,tempRNG)/100)
	end

    FiendFolio.OverrideExplosionHack(slot, true)
end, mod.FF.PennyPress.Var)

FiendFolio.onMachineTouch(mod.FF.PennyPress.Var, function(player, slot)
	local d = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'SlotData', tostring(slot.InitSeed), {})
    local sprite = slot:GetSprite()
	local data = mod:GetEntityData(slot)
	if d.plays == nil then
		d.plays = 0
	end

	if data.state == "Idle" then
		if player:GetNumCoins() > 10 then
			player:AddCoins(-11)
			sfx:Play(SoundEffect.SOUND_COIN_SLOT, 1, 0, false, 1)
			--[[mod.scheduleForUpdate(function()
				sfx:Play(SoundEffect.SOUND_COIN_SLOT, 1, 0, false, 1)
			end, 4)]]
			data.state = "Playing"
		end
	end
end)