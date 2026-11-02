local mod = FiendFolio
local AttackBabySpider = {}
local sfx = SFXManager()

function AttackBabySpider:SquishBlueBabySpider(familiar)
	local deatheffect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPIDER_EXPLOSION, 7000, familiar.Position, Vector.Zero, familiar)
	deatheffect:Update()
	sfx:Play(SoundEffect.SOUND_DEATH_BURST_SMALL, 0.8, 0, false, 1)
	familiar:Remove()
end

---@param familiar EntityFamiliar
---@param collider Entity
function AttackBabySpider:DieFromCollision(familiar, collider)
	if familiar.SubType == mod.ITEM.FAMILIAR.BLUE_BABY_SPIDER_SUBTYPE then
		if collider.Type == EntityType.ENTITY_PROJECTILE and not collider:ToProjectile():HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) then
			collider:Die()
		end

		if collider:IsVulnerableEnemy() and collider:IsActiveEnemy() and not mod:isFriend(collider) then
			AttackBabySpider:SquishBlueBabySpider(familiar)
		end

		return true
	end
end

mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, AttackBabySpider.DieFromCollision, FamiliarVariant.BLUE_SPIDER)

-- you have to do this every frame trololo
---@param familiar EntityFamiliar
function AttackBabySpider:FixCollision(familiar)
	if familiar.SubType == mod.ITEM.FAMILIAR.BLUE_BABY_SPIDER_SUBTYPE then
		familiar.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
	end
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, AttackBabySpider.FixCollision, FamiliarVariant.BLUE_SPIDER)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, AttackBabySpider.FixCollision, FamiliarVariant.BLUE_SPIDER)