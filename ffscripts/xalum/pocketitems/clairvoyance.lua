local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_USE_PILL, function(_, effect, player, flags, pillColor)
	player:AnimateHappy()

	local level = game:GetLevel()
	local removableCurses = level:GetCurses() & ~ LevelCurse.CURSE_OF_LABYRINTH

	level:RemoveCurses(removableCurses)

	if pillColor & PillColor.PILL_GIANT_FLAG > 0 then
		for i = 1, 2 do
			player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_SECRETS, false, false, true, false)
		end
		sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER_AMPLIFIED, 1, 0, false, 1)
		sfx:Play(SoundEffect.SOUND_THUMBSUP_AMPLIFIED, 1, 0, false, 1)
		mod:trySayAnnouncerLine(mod.Sounds.VAPillHorseClairvoyance, flags, 20)
	else
		player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_SECRETS, false, false, true, false)
		mod:trySayAnnouncerLine(mod.Sounds.VAPillClairvoyance, flags, 20)
	end
end, mod.ITEM.PILL.CLAIRVOYANCE)