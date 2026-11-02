local mod = FiendFolio
local nagaviperVariant = 28

local function FirePure(_, player, dir, amount, owner, params)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.NAGA_VIPER) then
		for i = 1, amount do
			local vector = (dir*10 + player:GetTearMovementInheritance(dir)) * 1.4
			local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.NAGA_VIPER)
			local procChance = 1/(math.max(10 - player.Luck, 2))
			if procChance > rng:RandomFloat() then
				local fire = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLUE_FLAME, nagaviperVariant, owner.Position, vector, player):ToEffect()
				fire:SetTimeout(240)

				local scalar = mod:GetFamiliarPureFireScalar(owner, player)
				fire.CollisionDamage = ((player.Damage + 40) * scalar)/100
				fire.SpriteScale = Vector(1, 1) * (scalar/2 + 0.5)
				fire.Color = Color(1,1,1,1,0.05,0.1,0, 1, 0.8, 0.2, 1)--Color(1,0.9,0.4,1,0.5,0.2,-0.1)
			end
		end
	end
end

local function OnEnemyTakeDMG(_, ent, amount, flags, source, dmgCooldown)
    local fire = source.Entity

    if fire ~= nil
    and fire.Type == EntityType.ENTITY_EFFECT
    and fire.Variant == EffectVariant.BLUE_FLAME
    and fire.SubType == nagaviperVariant 
    and fire.CollisionDamage ~= -1 then
        Isaac.Explode(fire.Position, nil, fire.CollisionDamage*100)
        fire.CollisionDamage = -1
        fire:Kill()
    end
end

mod:AddCollectibleCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE, mod.ITEM.COLLECTIBLE.NAGA_VIPER, FirePure)
mod:AddPriorityEntityCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, -1, EntityType.ENTITY_EFFECT, EffectVariant.BLUE_FLAME, nagaviperVariant, OnEnemyTakeDMG)