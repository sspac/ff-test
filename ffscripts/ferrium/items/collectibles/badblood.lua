local mod = FiendFolio
local game = Game()

function mod:BadBloodEntDamage(entity, amount, flags, source, cooldown)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not entity:ToNPC() then return end
	
    local mult = 0
    for i = 1, game:GetNumPlayers() do
        local player = Isaac.GetPlayer(i - 1)
        if player:HasCollectible(mod.ITEM.COLLECTIBLE.BAD_BLOOD) then
            local num = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.BAD_BLOOD)
            local cap = 10+num*2
            local hearts = player:GetHearts()+player:GetSoulHearts()
            if hearts <= cap then --Bone hearts just count as free hits, I suppose
                local scale = (cap-hearts+1)/cap --Add one cause you can't have 0 health (well)
                mult = mult+scale*(1+0.5*num)
            end
        end
    end
    if mult > 0 then
        mult = mult+1
        return {Damage = amount*mult}
    end
end
mod:AddPriorityCollectibleCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -100, mod.ITEM.COLLECTIBLE.BAD_BLOOD, mod.BadBloodEntDamage)

function mod:BadBloodUpdate(player)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.BAD_BLOOD) then
        local num = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.BAD_BLOOD)
        local cap = 10+num*2
        local hearts = player:GetHearts()+player:GetSoulHearts()
        if hearts <= cap then
            local freq = 5+math.ceil(60*(hearts+1)/cap)
            if player.FrameCount % freq == 0 then
                local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.BAD_BLOOD)
                for j=1,2 do
                    local baseVel = Vector(1, 0):Rotated(mod:RandomInt(360))
                    for i=1,6,2 do
                        local vel = baseVel:Rotated(mod:RandomInt(-14,14,rng)):Resized(mod:RandomInt(10+7*i, 15+7*i, rng)/5)+player.Velocity
                        local poof = Isaac.Spawn(1000, mod.FF.WhiteTrailEffect.Var, mod.FF.WhiteTrailEffect.Sub, player.Position, vel, player):ToEffect()
                        poof.Color = Color(0, 0, 0, 1, mod:RandomInt(45,55,rng)/100, mod:RandomInt(1,4,rng)/100, mod:RandomInt(1,4,rng)/100)
                        poof.Parent = player
                        poof:SetTimeout(12-i*2+rng:RandomInt(5))
                        local size = 0.3+mod:RandomInt(5,9,rng)/13*(6-i)/7
                        poof.SpriteScale = Vector(size, size)
                        mod:GetEntityData(poof).Deccel = 0.85
                        mod:GetEntityData(poof).ShrinkDelay = 3
                        poof.SpriteOffset = Vector(0, -10)
                        poof:Update()
                    end
                end
            end
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.BAD_BLOOD, mod.BadBloodUpdate)