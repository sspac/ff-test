local mod = FiendFolio
local game = Game()

mod.pocketDiceGood = {
	{FiendFolio.ITEM.CARD.GLASS_D6, 100},
	{FiendFolio.ITEM.CARD.GLASS_D4, 50},
	{FiendFolio.ITEM.CARD.GLASS_D8, 100},
	{FiendFolio.ITEM.CARD.GLASS_D100, 25},
	{FiendFolio.ITEM.CARD.GLASS_SPINDOWN, 100},
	{FiendFolio.ITEM.CARD.GLASS_AZURITE_SPINDOWN, 100},
}

mod.PocketDiceWhatever = {
	{FiendFolio.ITEM.CARD.GLASS_D10, 100},
	{FiendFolio.ITEM.CARD.GLASS_D20, 100},
	{FiendFolio.ITEM.CARD.GLASS_D12, 100},
	{FiendFolio.ITEM.CARD.GLASS_D2, 100},
	{FiendFolio.ITEM.CARD.GLASS_D5, 100},
	{FiendFolio.ITEM.CARD.GLASS_D3, 100},
}

function mod:isAnyGoodDiceUnlocked()
	for i = 1, #mod.pocketDiceGood do
		if mod:IsGlassDiceUnlocked(mod.pocketDiceGood[i][1]) then
			return true
		end
	end
end

function mod:pocketDiceNewLevel(player)
	if player:HasTrinket(FiendFolio.ITEM.TRINKET.POCKET_DICE) then
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.TRINKET.POCKET_DICE)
		local mult = player:GetTrinketMultiplier(FiendFolio.ITEM.TRINKET.POCKET_DICE)-1
		local num = 2+mult
		for i=0,2+mult*2 do
			mod.scheduleForUpdate(function()
				local room = game:GetRoom()
				if i == 0 then
					Isaac.Spawn(5, 20, 1, room:FindFreePickupSpawnPosition(player.Position, 40), Vector.Zero, nil)
				elseif (i <= math.ceil(num/2)) and mod:isAnyGoodDiceUnlocked() then
					local choice = mod:weightedRNG(mod.pocketDiceGood, rng)
					while (not mod:IsGlassDiceUnlocked(choice)) do
						choice = mod:weightedRNG(mod.pocketDiceGood, rng)
					end
					Isaac.Spawn(5, 300, choice, room:FindFreePickupSpawnPosition(player.Position, 20)+mod:shuntedPosition(10, rng), Vector.Zero, nil)
				else
					local choice = mod:weightedRNG(mod.PocketDiceWhatever, rng)
					while (not mod:IsGlassDiceUnlocked(choice)) do
						choice = mod:weightedRNG(mod.PocketDiceWhatever, rng)
					end
					Isaac.Spawn(5, 300, choice, room:FindFreePickupSpawnPosition(player.Position, 20)+mod:shuntedPosition(10, rng), Vector.Zero, nil)
				end
			end, i)
		end
	end
end
mod:AddTrinketCallback("FF_NEW_LEVEL_PLAYER_FERRIUM", mod.ITEM.TRINKET.POCKET_DICE, mod.pocketDiceNewLevel)