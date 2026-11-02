local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

local bal = {
    rockDist = 80,
    rockRadius = 20,
    damageMult = 0.5, --Add inherent one from standard mult
    damageFlat = 5,
    damageScale = 1.5,
}

mod:AddCallback("FF_TRINKET_CHARGE_CIRCLE_FIRED", function(_, player, entry, d)
    local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.EARTH_IMPALE)
    local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.EARTH_IMPALE)
    sfx:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND, 0.4, 0, false, mod:RandomInt(140,155,rng)/100)
        
    local level = game:GetLevel():GetAbsoluteStage()
    local room = game:GetRoom()
    for i=90,360,90 do
        local newPos = player.Position+Vector(bal.rockDist, 0):Rotated(i)
        if room:GetGridCollisionAtPos(newPos) == GridCollisionClass.COLLISION_NONE then
            local shockwave = Isaac.Spawn(1000, EffectVariant.ROCK_EXPLOSION, 0, newPos, Vector.Zero, player):ToEffect()
            shockwave.DepthOffset = 50
            for _, enemy in ipairs(Isaac.FindInRadius(newPos, bal.rockRadius, EntityPartition.ENEMY)) do
                if enemy:IsActiveEnemy() and (not mod:isFriend(enemy)) and enemy:IsVulnerableEnemy() then
                    local damage = (player.Damage+bal.damageFlat)*(mult+bal.damageMult)+bal.damageScale*level
                    enemy:TakeDamage(damage, 0, EntityRef(shockwave), 0)
                end
            end
        end
    end
end, mod.ITEM.TRINKET.EARTH_IMPALE)