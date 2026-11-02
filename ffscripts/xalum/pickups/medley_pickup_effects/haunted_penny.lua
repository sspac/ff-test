local mod = FiendFolio
local sfx = SFXManager()

mod:AddCallback(mod.CALLBACK.MEDLEY_PENNY_PICKUP, function(_, pickup, collider)
	if collider:ToPlayer() then
		collider:ToPlayer():AddWisp(0, collider.Position, true)
	end

	sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT, 1, 0, false, 1)
	sfx:Play(SoundEffect.SOUND_SOUL_PICKUP, 1.3, 0, false, 1)
end)