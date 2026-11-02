local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_USE_PILL, function(_, effect, player, flags, pillColor)
	player:AnimateSad()

	local data = mod:GetEntityData(player)
	data.fiendfolio_epidermolysisStrength = data.fiendfolio_epidermolysisStrength or 0

	local targetLevel = (pillColor & PillColor.PILL_GIANT_FLAG > 0) and 2 or 1
	
	data.fiendfolio_epidermolysisStrength = math.max(targetLevel, data.fiendfolio_epidermolysisStrength)

	if targetLevel > 1 then
		sfx:Play(SoundEffect.SOUND_THUMBSDOWN_AMPLIFIED, 1, 0, false, 1)
		mod:trySayAnnouncerLine(mod.Sounds.VAPillHorseEpidermolysis, flags, 20)
	else
		mod:trySayAnnouncerLine(mod.Sounds.VAPillEpidermolysis, flags, 20)
	end
end, mod.ITEM.PILL.EPIDERMOLYSIS)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	for _, player in pairs(Isaac.FindByType(1)) do
		mod:GetEntityData(player).fiendfolio_epidermolysisStrength = 0
	end
end)