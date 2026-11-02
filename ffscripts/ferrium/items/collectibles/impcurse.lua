local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

local bal = {
    BaseMinions = 3,
    Increment = 2,

    Chance = 25,
    RecuperateChance = {35,15},
}

local function tryActivateImpCurse(player)
    local mult = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.IMP_CURSE)
    local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.IMP_CURSE)
    if rng:RandomInt(100) < bal.Chance then
        local num = bal.BaseMinions + mult*bal.Increment
        local recover = rng:RandomInt(100) < (bal.RecuperateChance[1]*mult+mod.XalumLuckBonus(player.Luck, 25, bal.RecuperateChance[2]/100)*100)

        for i=1,num do
            if i == 1 and recover then
                local minion = Isaac.Spawn(5, mod.PICKUP.VARIANT.FIEND_MINION, 3, player.Position+mod:shuntedPosition(5, rng), Vector.Zero, player):ToPickup()
                minion.Parent = player
            else
                local minion = Isaac.Spawn(1000, mod.PICKUP.VARIANT.FIEND_MINION_EFFECT, 0, player.Position+mod:shuntedPosition(5, rng), Vector.Zero, player):ToEffect()
                minion.Parent = player
            end
        end
        sfx:Play(mod.Sounds.FiendFolioBook, 0.40, 0, false, mod:RandomInt(135,150,rng)/100)

        local hearts = player:GetHearts()+player:GetSoulHearts()
        if hearts > 1 and not (player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B) then
            if player:GetHearts() > 0 then
                player:AddHearts(-1)
            elseif player:GetSoulHearts() > 0 then
                player:AddSoulHearts(-1)
            end
        end

        local poof = Isaac.Spawn(1000, EffectVariant.POOF01, 0, player.Position, Vector.Zero, player):ToEffect()
        poof.Color = Color(0.2, 0.2, 0.2, 1, 0, 0, 0)

        for i=1,4 do
            local randVel = player.Velocity+RandomVector()*mod:RandomInt(10,25,rng)/20
            local cloud = Isaac.Spawn(1000, 59, 0, player.Position, Vector.Zero, player):ToEffect()
            local life = mod:RandomInt(70,120,rng)
            cloud:SetTimeout(life)
            local color = Color(0.25,0.1,0.25,0.3,0.1,0,0.1)
            cloud.Color = color
            local randScale = mod:RandomInt(70,90,rng)/100
            cloud.SpriteScale = Vector(randScale, randScale)
            mod:GetEntityData(cloud).cosmeticDust = {scale = randScale, vel = randVel, lifespan = life, alpha = 0.65}
            cloud.SpriteOffset = Vector(0, -15)
        end
    end
end

function mod:ImpCurseNewRoom(player)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.IMP_CURSE) and not game:GetRoom():IsClear() then
        mod.scheduleForUpdate(function()
            local hasEnemies
            for _,enemy in ipairs(Isaac.FindInRadius(player.Position, 999, EntityPartition.ENEMY)) do
                hasEnemies = true
                break
            end
            if hasEnemies then
                tryActivateImpCurse(player)
            end
        end, 1)
    end
end
mod:AddCollectibleCallback("FF_NEW_ROOM_PLAYER_FERRIUM", mod.ITEM.COLLECTIBLE.IMP_CURSE, mod.ImpCurseNewRoom)

mod:AddCollectibleCallback(mod.CALLBACK.FF_PLAYER_POST_START_GREED_WAVE, mod.ITEM.COLLECTIBLE.IMP_CURSE, function(_, player, d, waveNumber, isBossWave)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.IMP_CURSE) then
        tryActivateImpCurse(player)
    end
end)