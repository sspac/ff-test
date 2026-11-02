local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Isaac,

	IFrames = 30,
	ShotSpeed = 8,
}
mod:AddEmbryo(embryo)



function embryo:Update(entity)
	-- Invinciblity frames
	if entity.StateFrame > 0 then
		entity.StateFrame = entity.StateFrame - 1

		if entity.StateFrame <= 0 then
			entity.Visible = true
		else
			entity.Visible = entity.StateFrame % 4 >= 2
		end
	end


	-- Shoot a tear in the nearest cardinal direction to the target
	if entity:GetSprite():IsEventTriggered("Landed") then
		local params = ProjectileParams()
		params.Variant = ProjectileVariant.PROJECTILE_TEAR
		params.HeightModifier = 10

		local target = entity:GetPlayerTarget()
		local vector = mod:ClampVector(target.Position - entity.Position, 90):Resized(embryo.ShotSpeed)
		entity:FireProjectilesEx(entity.Position, vector, ProjectileMode.SINGLE, params)
		mod:PlaySoundCool(nil, SoundEffect.SOUND_TEARS_FIRE)
	end
end

function embryo:DMG(entity, damageAmount, damageFlags, damageSource, damageCountdownFrames)
	-- Don't take damage during the invinciblity frames
	if entity.StateFrame > 0 then
		return false

	-- Reduce all damage to 1
	else
		if entity.HitPoints > 1 then
			entity.StateFrame = embryo.IFrames
			mod:PlaySoundCool(entity, SoundEffect.SOUND_ISAAC_HURT_GRUNT, 0.6, 1.2)
		end
		return { Damage = 1, }
	end
end

-- Funny Isaac death noise :)
function embryo:Death(entity)
	mod:PlaySoundCool(entity, SoundEffect.SOUND_ISAACDIES, 0.6, 1.2)
end