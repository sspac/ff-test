local mod = FiendFolio
local sfx = SFXManager()

local bal = {
    breakChance = 66,
    damage = 40,
}

function mod:MirrorSlateTrinketUpdate(trinket, d)
    if mod:GetRealTrinketId(trinket.SubType) == mod.ITEM.ROCK.MIRROR_SLATE and trinket.Touched == true then
        if not d.ClosestPlayer then
            d.ClosestPlayer = mod:getClosestPlayer(trinket.Position, 50)
        end
        if trinket:GetSprite():IsEventTriggered("DropSound") and d.ClosestPlayer and d.ClosestPlayer:Exists() then
            local player = d.ClosestPlayer
            local rng = player:GetTrinketRNG(mod.ITEM.ROCK.MIRROR_SLATE)
            local mult = 1 or (mod:IsGoldTrinket(trinket.SubType) and 2)
            local broken
            if mod.IsActiveRoom() then
                if rng:RandomInt(100) < bal.breakChance then
                    broken = true
                end
            end
            player:UseActiveItem(CollectibleType.COLLECTIBLE_NECRONOMICON, UseFlag.USE_NOANIM, -1)
            local damage = bal.damage*mult
            if player:HasCollectible(CollectibleType.COLLECTIBLE_MISSING_PAGE_2) then
                damage = damage+40
            end
            if player:HasTrinket(TrinketType.TRINKET_MISSING_PAGE) then
                damage = damage+40
            end

            for _,entity in ipairs(Isaac.FindInRadius(player.Position, 999, EntityPartition.ENEMY)) do
                if entity:IsActiveEnemy() and (not mod:isFriend(entity)) then
                    entity:TakeDamage(damage, 0, EntityRef(player), 0)
                end
            end
            sfx:Play(SoundEffect.SOUND_DEATH_CARD, 1, 0, false, 1)

            if broken then
                sfx:Play(SoundEffect.SOUND_MIRROR_BREAK, 0.55, 0, false, 2.6)
                local heart = Isaac.Spawn(5, 10, 6, trinket.Position, Vector(0,3):Rotated(rng:RandomInt(360)), trinket)
                trinket:Remove()
            else
                sfx:Play(SoundEffect.SOUND_POT_BREAK, 0.55, 0, false, mod:RandomInt(95,105,rng)/100)
            end
            for i=1,3 do
                local randVel = RandomVector()*mod:RandomInt(10,25,rng)/20
                local cloud = Isaac.Spawn(1000, 59, 0, trinket.Position, Vector.Zero, trinket):ToEffect()
                local life = mod:RandomInt(70,120,rng)
                cloud:SetTimeout(life)
                local color = Color(0.15,0.15,0.15,0.3,0,0,0)
                cloud.Color = color
                local randScale = mod:RandomInt(70,90,rng)/100
                cloud.SpriteScale = Vector(randScale, randScale)
                mod:GetEntityData(cloud).cosmeticDust = {scale = randScale, vel = randVel, lifespan = life, alpha = 0.65}
                cloud.SpriteOffset = Vector(0, -10)
            end
            for i=1,4 do
                local randVel = RandomVector()*mod:RandomInt(15,45,rng)/20
                local part = Isaac.Spawn(1000, EffectVariant.TOOTH_PARTICLE, 0, trinket.Position, randVel, trinket):ToEffect()
            end
        end
    end
end