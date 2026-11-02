local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Embrrryo,

	MoveSpeed = 3,
}
mod:AddEmbryo(embryo)



-- Splat color
function embryo:Init(entity)
	entity.SplatColor = Color(0.2,0.45,1, 1, 0.3,0.5,0.7)
end

function embryo:Update(entity)
	local sprite = entity:GetSprite()

	-- Movement
	if sprite:WasEventTriggered("Landed") then
		entity.Velocity = mod:StopLerp(entity.Velocity, 0.1)
	else
		mod:WanderAroundCool(entity, embryo.MoveSpeed)
		entity.TargetPosition = entity.Velocity
		mod:FlipTowardsMovement(entity, sprite)
	end

	-- Landed
	if sprite:IsEventTriggered("Landed") then
		entity.Velocity = entity.TargetPosition:Resized(embryo.MoveSpeed)
		mod:PlaySoundCool(nil, SoundEffect.SOUND_STONE_IMPACT, 0.7, 1.2)
	end

	-- Disable default AI
	if entity.FrameCount > 1 then
		mod:LoopingAnim(sprite, "Walk Sad")
		return true
	end
end

-- Turn into a pushable ice block
function embryo:Death(entity)
	entity:GetSprite():Play("Head", true)
	entity:AddEntityFlags(EntityFlag.FLAG_ICE)
	mod:GetEntityData(entity).FrozenEmbryoHead = true
end



-- Don't color the ice block
function mod:FrozenEnemyUpdate(entity)
	if mod:GetEntityData(entity).FrozenEmbryoHead then
		entity:GetSprite().Color = Color.Default
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_RENDER, mod.FrozenEnemyUpdate, EntityType.ENTITY_FROZEN_ENEMY)

-- Ignore collision with friendly enemies
function mod:FrozenEnemyCollision(entity, target, bool)
	if target:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
		return true
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, mod.FrozenEnemyCollision, EntityType.ENTITY_FROZEN_ENEMY)

-- Make icicles not collide with friendly enemies
function mod:FriendlyEnemyTearCollision(tear, target, bool)
	if tear.Variant == TearVariant.ICE and target:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
		return true
	end
end