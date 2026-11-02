local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local card = mod.ITEM.CARD.MISPRINTED_TWO_OF_CLUBS

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, _, player, flags)
	local bombs = player:GetNumBombs()
	local target = math.max(2, 2 * bombs)
	player:AddBombs(target - bombs)

	local data = mod.GetPersistentPlayerData(player)
	data.FFCopperBombsStored = player:GetNumBombs()

	sfx:Play(FiendFolio.Sounds.CopperBombPickup, 1, 0, false, 1)
end, card)