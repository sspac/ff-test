local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local shufflehitthisroom = 0
local shuffleperfect = 0

mod:AddCollectibleCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.ITEM.COLLECTIBLE.SHUFFLE_TIME, function()
	shufflehitthisroom = 0
end)

mod:AddCollectibleCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.ITEM.COLLECTIBLE.SHUFFLE_TIME, function(_, ent)
	local player = ent:ToPlayer()
	if player then
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.SHUFFLE_TIME) then
			shufflehitthisroom = shufflehitthisroom + 1
			-- print("OUCH")
		end
	end
end, 1)

mod:AddCollectibleCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.ITEM.COLLECTIBLE.SHUFFLE_TIME, function()
	if shufflehitthisroom == 0 then
	shuffleperfect = shuffleperfect + 1
	if shuffleperfect == 1 then
		sfx:Play(SoundEffect.SOUND_PAPER_IN)
	elseif shuffleperfect == 2 then
			local shuffletimerandom = math.random(1,11)
			for i = 0,game:GetNumPlayers() - 1 do
				local player = Isaac.GetPlayer(i)
				local save = mod:GetEntityData(player).ffsavedata
				-- plays one of seven categories of effects every room cleared without getting hurt
				if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.SHUFFLE_TIME) then
					-- sfx:Play(mod.Sounds.ShuffleTimeActivate)
					-- 1: stat up - red
					if shuffletimerandom == 1 then
						shuffleperfect = 0
						local shuffle1random = math.random(3)
						if shuffle1random == 1 then
							save.ShuffleTimeDamage = save.ShuffleTimeDamage or 0
							save.ShuffleTimeDamage = save.ShuffleTimeDamage + 0.15
							player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
							Isaac.Spawn(1000, 70, 0, player.Position, Vector.Zero, nil)
							sfx:Play(SoundEffect.SOUND_KNIFE_PULL, 1, 0, false, 1.5)
						else
							save.ShuffleTimeLuck = save.ShuffleTimeLuck or 0
							save.ShuffleTimeLuck = save.ShuffleTimeLuck + 0.50
							player:AddCacheFlags(CacheFlag.CACHE_LUCK)
							sfx:Play(SoundEffect.SOUND_LUCKYPICKUP)
						end
						player:EvaluateItems()
						-- print("1")
					-- 2: healing - blue
					elseif shuffletimerandom == 2 or shuffletimerandom == 8 then
						shuffleperfect = 0
						local shuffle2random = math.random(10)
						if shuffle2random < 8 then
							sfx:Play(SoundEffect.SOUND_VAMP_GULP)
							player:AddHearts(2)
							Isaac.Spawn(1000, 49, 0, player.Position, Vector.Zero, nil)
						elseif shuffle2random == 8 or shuffle2random == 9 then
							sfx:Play(SoundEffect.SOUND_HOLY)
							player:AddSoulHearts(2)
						elseif shuffle2random == 10 then
							sfx:Play(SoundEffect.SOUND_UNHOLY)
							player:AddBlackHearts(2)
						end
						-- print("2")
					-- 3: money - yellow
					elseif shuffletimerandom == 3 or shuffletimerandom == 9 then
						shuffleperfect = 0
						local shuffle3random = math.random(5)
						local coinamount = math.random(2,5)
						if shuffle3random == 1 then
							player:AddCoins(coinamount)
							for i=1,coinamount do
								Isaac.Spawn(1000, 95, 0, player.Position, Vector.Zero, nil)
								sfx:Play(SoundEffect.SOUND_CASH_REGISTER, 1, 10, false, 1.15)
							end
						else
							player:AddCoins(1)
							Isaac.Spawn(1000, 95, 0, player.Position, Vector.Zero, nil)
							sfx:Play(SoundEffect.SOUND_CASH_REGISTER)
						end
						-- print("3")
					-- 4: active item charge - green
					elseif shuffletimerandom == 4 or shuffletimerandom == 10 then
						shuffleperfect = 0
						local randShuffleChargeCount = math.random(3)
						sfx:Play(SoundEffect.SOUND_BATTERYCHARGE)
						player:AddActiveCharge(randShuffleChargeCount, 0)
						Isaac.Spawn(1000, 48, 0, player.Position, Vector.Zero, nil)
						-- print("4")
					-- 5: blue bug or temp familiar - persona card
					elseif shuffletimerandom == 5 or shuffletimerandom == 11 then
						shuffleperfect = 0
						local shuffle5random = math.random(1,11)
						if shuffle5random == 1 then
							player:UseActiveItem(123, false)
						elseif shuffle5random == 2 or shuffle5random == 3 then
							sfx:Play(SoundEffect.SOUND_ANIMAL_SQUISH)
							for i=1,3 do
								Isaac.Spawn(3, 1065, 0, player.Position, Vector.Zero, nil)
							end
						elseif shuffle5random == 4 or shuffle5random == 5 then
							sfx:Play(SoundEffect.SOUND_ANIMAL_SQUISH)
							for i=1,3 do
								Isaac.Spawn(3, mod.ITEM.FAMILIAR.ATTACK_SKUZZ, 0, player.Position, Vector.Zero, nil)
							end
						elseif shuffle5random == 6 or shuffle5random == 7 then
							sfx:Play(SoundEffect.SOUND_ANIMAL_SQUISH)
							for i=1,3 do
								Isaac.Spawn(3, 43, 0, player.Position, Vector.Zero, nil)
							end
						elseif shuffle5random == 8 or shuffle5random == 9 then
							sfx:Play(SoundEffect.SOUND_ANIMAL_SQUISH)
							for i=1,3 do
								Isaac.Spawn(3, 73, 0, player.Position, Vector.Zero, nil)
							end
						elseif shuffle5random == 10 or shuffle5random == 11 then
							sfx:Play(SoundEffect.SOUND_ANIMAL_SQUISH)
							for i=1,3 do
								Isaac.Spawn(3, 201, 0, player.Position, Vector.Zero, nil)
							end
						end
						-- print("5")
					-- 6: minor or major arcana card - blank card
					elseif shuffletimerandom == 6 then
						sfx:Play(SoundEffect.SOUND_MENU_NOTE_APPEAR)
						local shuffle6random = math.random(1,5)
						shuffleperfect = 0
						if shuffle6random == 1 then
							Isaac.Spawn(5, 307, 0, player.Position + RandomVector():Resized(20), Vector.Zero, player)
						else
							Isaac.Spawn(5, 308, 0, player.Position + RandomVector():Resized(20), Vector.Zero, player)
						end
						-- print("6")
					-- 7: bad pickups (troll bomb or spicy key) - cursed card
					elseif shuffletimerandom == 7 then
						shuffleperfect = 0
						-- player:AnimateSad()
						local shuffle7random = math.random(1,8)
						if shuffle7random == 1 then
							sfx:Play(mod.Sounds.AceVenturaLaugh, 1, 0, false, 1.5)
							Isaac.Spawn(5, 30, 185, player.Position + RandomVector():Resized(20), Vector.Zero, player)
						elseif shuffle7random == 2 or shuffle7random == 3 then
							sfx:Play(mod.Sounds.AceVenturaLaugh, 1, 0, false, 1.5)
							Isaac.Spawn(5, 903, 0, player.Position + RandomVector():Resized(20), Vector.Zero, player)
						elseif shuffle7random == 4 or shuffle7random == 5 then
							sfx:Play(197)
							Isaac.Spawn(5, 40, 3, player.Position + RandomVector():Resized(20), Vector.Zero, player)
						elseif shuffle7random == 6 or shuffle7random == 7 then
							sfx:Play(mod.Sounds.AceVenturaLaugh, 1, 0, false, 1.5)
							for i=1,3 do
								Isaac.Spawn(5, 20, 213, player.Position + RandomVector():Resized(20), Vector.Zero, player)
							end
						elseif shuffle7random == 8 then
							sfx:Play(mod.Sounds.AceVenturaLaugh, 1, 0, false, 1.5)
							Isaac.Spawn(5, 40, 923, player.Position + RandomVector():Resized(20), Vector.Zero, player)
							-- print("7")
						end
					end
				end
			end
		else
		end
	end
end)