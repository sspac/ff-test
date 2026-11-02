local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.IceCream,

	Colors = {
		Color(0,0,0, 1, 0.94,0.43,0.73),
		Color(0,0,0, 1, 1,0.9,0.76),
		Color(0,0,0, 1, 0.38,0.25,0.14),
	},

	Radius = 100,
	HealAmount = 10,
}
mod:AddEmbryo(embryo)



-- Splat color
function embryo:Init(entity)
	local rng = RNG(entity.InitSeed)
	entity.SplatColor = mod:RandomIndex(embryo.Colors, rng)
end

-- Creamy splat
function embryo:Update(entity)
	if entity:GetSprite():IsEventTriggered("Landed") then
		local splat = entity:MakeSplat(0.75)
		local color = mod:RandomIndex(embryo.Colors)
		splat.Color = Color.Lerp(color, color, 1) * Color(1,1,1, 0.6)
	end
end

-- Heal nearby friends
function embryo:Death(entity)
	local others = Isaac.FindInRadius(entity.Position, embryo.Radius, EntityPartition.ENEMY)

	for i, other in pairs(others) do
		if other:ToNPC() and other:IsActiveEnemy(false) -- Is actually an NPC
		and other.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_NONE -- Is tangible
		and entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) == other:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then -- On the same team
			other:AddHealth(embryo.HealAmount)
			mod:PlaySoundCool(other:ToNPC(), SoundEffect.SOUND_VAMP_GULP, 0.75, 1.05, 2)

			-- Heart effect
			local overlay = other:GetSprite():GetNullFrame("OverlayEffect")

			if overlay and overlay:IsVisible() then
				local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, other.Position, Vector.Zero, other)
				effect:ToEffect():FollowParent(other)
				effect.DepthOffset = other.DepthOffset + 1

				local offset = other.SpriteScale * overlay:GetPos()
				effect:GetSprite().Offset = offset
			end
		end
	end

	-- Drop a heart if friendly
	if entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, entity.Position, Vector.Zero, entity)
	end
end