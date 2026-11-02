local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_USE_PILL, function(_, effect, player, flags, pillColor)
	player:AnimateSad()
	sfx:Play(SoundEffect.SOUND_FART)

	local doHorseEffect = pillColor & PillColor.PILL_GIANT_FLAG > 0
	local room = game:GetRoom()

	for i = 1, doHorseEffect and 2 or 1 do
		local offset = RandomVector():Resized(60)

		local position = room:FindFreeTilePosition(player.Position + offset, 180)
		local index = room:GetGridIndex(position)
		local grid = room:GetGridEntity(index)
		if (not grid) or (grid and grid.Desc.Type == GridEntityType.GRID_DECORATION) then
			room:SpawnGridEntity(index, GridEntityType.GRID_POOP, 1, Random(), 1)
		end
	end

	if doHorseEffect then
		sfx:Play(SoundEffect.SOUND_THUMBSDOWN_AMPLIFIED, 1, 0, false, 1)
		mod:trySayAnnouncerLine(mod.Sounds.VAPillHorseHaemorrhoids, flags, 20)
	else
		mod:trySayAnnouncerLine(mod.Sounds.VAPillHaemorrhoids, flags, 20)
	end
end, mod.ITEM.PILL.HAEMORRHOIDS)