local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local function addCoins(target, amount)
	local player = target:ToPlayer()
	local familiar = target:ToFamiliar()
	local subAmount = amount % 1
	amount = amount - subAmount

	if player then
		player:AddCoins(amount)
		mod:AddFractionalCoins(subAmount)
	else
		familiar.Coins = math.max(familiar.Coins + amount, 0)
	end
end

mod:AddCallback(mod.CALLBACK.MEDLEY_PENNY_PICKUP, function(_, pickup, collider)
	local player = collider:ToPlayer()
	local familiar = collider:ToFamiliar()
	local data = mod:GetEntityData(pickup)
	local rng = pickup:GetDropRNG()
	local roll = rng:RandomFloat()

	if roll < 0.3 then			-- Remove 1 coin
		addCoins(collider, -1.1)
		sfx:Play(mod.Sounds.CursedPennyNegative, 1, 0, false, 1)
		mod:AddSamaelAngerBonus(0.05)
		data.trinketEffectValue = 0.5
	elseif roll < 0.6 then		-- Add 1 coin
		addCoins(collider, 1.1)
		sfx:Play(SoundEffect.SOUND_PENNYPICKUP, 1, 0, false, 1)
		data.trinketEffectValue = 1
	elseif roll < 0.8 then		-- Add 2 coins
		addCoins(collider, 2.2)
		sfx:Play(mod.Sounds.CursedPennyPositive, 1, 0, false, 1)
		data.trinketEffectValue = 2
	elseif roll < 0.9 then		-- Remove 2 coins
		addCoins(collider, -2.2)
		sfx:Play(mod.Sounds.CursedPennyNegativeSuper, 1, 0, false, 1)
		game:Fart(pickup.Position, 40, pickup, 1, 0)
		mod:AddSamaelAngerBonus(0.1)
		data.trinketEffectValue = 0.25
	elseif roll < 0.95 then		-- Add 1 coin + 1 luck
		addCoins(collider, 1.1)
		sfx:Play(mod.Sounds.CursedPennyPositiveSuper, 1, 0, false, 1)
		data.trinketEffectValue = 5

		if player then
			player:DonateLuck(1)
			player:AnimateHappy()
		end
	elseif roll < 0.975 then	-- Remove 1 coin + explode
		addCoins(collider, -1.1)
		sfx:Play(mod.Sounds.CursedPennyNegativeMega, 1, 0, false, 1)
		mod:AddSamaelAngerBonus(0.25)
		data.trinketEffectValue = 0.1

		if player then
			player:AnimateSad()

			if player:HasTrinket(TrinketType.TRINKET_CURSED_PENNY) and not player:HasCollectible(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
				local bomb = Isaac.Spawn(4, 17, BombSubType.BOMB_GIGA, player.Position, Vector.Zero, player):ToBomb()
				bomb:SetExplosionCountdown(0)
				bomb:Update()
			else
				Isaac.Explode(pickup.Position, nil, 40)
			end

			if not FiendFolio.ACHIEVEMENT.EVIL_STICKER:IsUnlocked(true) then
				FiendFolio.ACHIEVEMENT.EVIL_STICKER:Unlock()
			end
		end
	elseif roll < 0.99 then		-- Add 1 coin + minor all stats up
		addCoins(collider, 1.1)
		sfx:Play(mod.Sounds.CursedPennyPositiveMega, 1, 0, false, 1)
		data.trinketEffectValue = 10

		if player then
			mod:AddCursedPennyStats(player)
			player:AnimateHappy()
		end
	else						-- Do nothing
		sfx:Play(mod.Sounds.CursedPennyNeutral, 1, 0, false, 1)
		data.trinketEffectValue = 0.75
	end
end)