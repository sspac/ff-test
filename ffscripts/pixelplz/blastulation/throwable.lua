local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Throwable,

	SpawnDelay = 20,
	Damage = 40,
}
mod:AddEmbryo(embryo)



function embryo:Init(entity)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
end

-- Handle picking them up
function embryo:Collision(entity, target, bool)
	local player = target:ToPlayer()

	if entity.FrameCount >= embryo.SpawnDelay and Game():GetRoom():GetFrameCount() >= embryo.SpawnDelay
	and player and player:IsExtraAnimationFinished() and not player:GetHeldEntity() then
		entity:Remove()

		-- Create the bomb version
		local bomb = Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_THROWABLE, embryo.Variant, entity.Position, entity.Velocity, player):ToBomb()
		bomb:GetSprite():Load(entity:GetSprite():GetFilename())
		bomb.ExplosionDamage = embryo.Damage
		player:TryHoldEntity(bomb)

		mod:PlaySoundCool(nil, SoundEffect.SOUND_FETUS_FEET)
		return true
	end
end

-- Explode on death
function embryo:Death(entity)
	Game():BombExplosionEffects(entity.Position, embryo.Damage, TearFlags.TEAR_NORMAL, entity.Color, entity, 1, true, true, DamageFlag.DAMAGE_EXPLOSION)
end



-- Handle the bomb version
function mod:BombUpdate(bomb)
	if bomb.SubType == embryo.Variant and not bomb:HasEntityFlags(EntityFlag.FLAG_HELD) then
		local sprite = bomb:GetSprite()
		mod:FlipTowardsMovement(bomb, sprite)

		-- Set the sprite rotation
		local animData = sprite:GetAnimationData("Midair")

		if animData and animData:GetLayer(0) then
			local rotationFrame = bomb.FrameCount % animData:GetLength()
			local rotation = animData:GetLayer(0):GetFrame(rotationFrame):GetRotation()

			for i, layer in pairs( sprite:GetAllLayers() ) do
				layer:SetRotation(rotation)
			end
		end

		-- Explode immediately if it lands
		if bomb.PositionOffset.Y >= 0 then
			bomb:SetExplosionCountdown(0)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, mod.BombUpdate, BombVariant.BOMB_THROWABLE)