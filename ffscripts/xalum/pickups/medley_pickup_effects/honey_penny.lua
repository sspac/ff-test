local mod = FiendFolio
local sfx = SFXManager()

mod:AddCallback(mod.CALLBACK.MEDLEY_PENNY_PICKUP, function(_, pickup, collider)
	local player = collider:ToPlayer()

	if player then
		local data = mod:GetEntityData(player)
		if data.HoneyPenny ~= true then
			local icon = Isaac.Spawn(EntityType.ENTITY_EFFECT, 1748, 0, player.Position, player.Velocity, nil):ToEffect()
			icon:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
			icon.Parent = player
			icon:FollowParent(player)
			icon.DepthOffset = 1
			icon:Update()
			icon:GetSprite():Play("Honey")
		end

		data.HoneyPenny = true
		data.HoneyPennyTimer = 60 * 8

		sfx:Play(SoundEffect.SOUND_ANIMAL_SQUISH, 1.3, 0, false, 1)
	end
end)