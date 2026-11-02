local mod = FiendFolio

function mod:InternalizedHatredDamage(player, damage, flag, source)
    if player:HasTrinket(mod.ITEM.TRINKET.INTERNALIZED_HATRED) then
        local order = CustomHealthAPI.Library.GetHealthInOrder(player, false)
        local defused = 0
        for i=#order,1,-1 do
            if damage > 0 then
                local heartEntry = order[i]
                for heartType,typeEntry in pairs(heartEntry) do
                    if heartType == "Other" and typeEntry.Key == "BONE_HEART" and typeEntry.HP > 0 then
                        damage = 0
                        break
                    elseif heartType == "Other" and typeEntry.Key == "BLACK_HEART" and typeEntry.HP > 0 then
                        if damage >= typeEntry.HP then
                            damage = damage-typeEntry.HP
                            typeEntry.Key = "SOUL_HEART"
                            defused = defused+1
                        end
                    end
                end
            else
                break
            end
        end

        if defused > 0 then
            local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.INTERNALIZED_HATRED)
            SFXManager():Play(SoundEffect.SOUND_DEATH_CARD, 0.6, 0, false, mod:RandomInt(140,150,rng)/100)
            local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.INTERNALIZED_HATRED)
            for i=1,4 do
                local randVel = player.Velocity+RandomVector()*mod:RandomInt(10,25,rng)/20
                local cloud = Isaac.Spawn(1000, 59, 0, player.Position, Vector.Zero, player):ToEffect()
                local life = mod:RandomInt(70,120,rng)
                cloud:SetTimeout(life)
                local color = Color(0.1,0.1,0.1,0.3,0,0,0)
                cloud.Color = color
                local randScale = mod:RandomInt(70,90,rng)/100
                cloud.SpriteScale = Vector(randScale, randScale)
                mod:GetEntityData(cloud).cosmeticDust = {scale = randScale, vel = randVel, lifespan = life, alpha = 0.65}
                cloud.SpriteOffset = Vector(0, -15)
            end

            mult = mult+player:GetTrinketMultiplier(TrinketType.TRINKET_MISSING_PAGE)
            mult = mult+player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MISSING_PAGE_2)

            --Start off at -0.5 so it's not just a straight up 1 damage after one hit
            mod:GetEntityData(player).ffsavedata.RunEffects.InternalizedHatredIncreases = math.max(0, (mod:GetEntityData(player).ffsavedata.RunEffects.InternalizedHatredIncreases or -0.5)+mult)
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            player:EvaluateItems()
        end
    end
end