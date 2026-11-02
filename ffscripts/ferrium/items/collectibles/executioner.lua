local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    ExecuteHealth = 0.7,
    ExecuteHealth2 = 0.1,
    ExecuteHealthBosses = 0.5,
    MaxThresh = 0.9,
    BossDamagePercent = 0.2,
}

mod.ExecutionHappening = false

function mod.ExecutionerBarRenderCondition(player, d, entry)
    return mod.IsActiveRoom() and not entry.Executed
end

function mod.ExecutionerAnimFunc(player, d, sprite, entry)
    if entry.timer > 0 then
        sprite:Play("Charging")
        sprite:SetFrame(100-math.floor(entry.timer/entry.maxTime*100))
        d.ExecutionerTimer = entry.timer
        entry.charged = nil
    elseif entry.timer == 0 then
        if not entry.charged then
            Isaac.RunCallbackWithParam("FF_CHARGE_CIRCLE_CHARGED", entry.id, player, entry, d, entry.charged)
            sprite:Play("StartCharged", true)
            entry.charged = true
        elseif sprite:IsFinished("StartCharged") then
            entry.REALLYSTOPRENDERING = true
            entry.Executed = true
            entry.bababa = nil
            mod.ExecutionHappening = true
        elseif sprite:GetFrame() == 14 and not entry.bababa then
            entry.bababa = true
            mod.ExecutionHappening = true

            local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.EXECUTIONER)
            if entry.RenderPosition and Options.ChargeBars then
                for i=1,2 do
                    local randVel = RandomVector()*mod:RandomInt(10,30,rng)/20
                    local cloud = Isaac.Spawn(1000, 59, 0, entry.RenderPosition, Vector.Zero, player):ToEffect()
                    cloud:SetTimeout(mod:RandomInt(100,150,rng))
                    local color = Color(0.45,0,0,0,0,0,0)
                    cloud.Color = color
                    local randScale = mod:RandomInt(55,95,rng)/100
                    cloud.SpriteScale = Vector(0.3, 0.3)
                    mod:GetEntityData(cloud).cosmeticDust = {scale = randScale, vel = randVel, alpha = 0.5}
                end
                for i=1,3 do
                    local vel = Vector(0,1):Rotated(rng:RandomInt(360)):Resized(mod:RandomInt(8, 16, rng)/5)
                    local poof = Isaac.Spawn(1000, mod.FF.WhiteTrailEffect.Var, mod.FF.WhiteTrailEffect.Sub, entry.RenderPosition, vel, player):ToEffect()
                    poof.Color = Color(0, 0, 0, 1, mod:RandomInt(45,55,rng)/100, mod:RandomInt(1,4,rng)/100, mod:RandomInt(1,4,rng)/100)
                    poof.Parent = player
                    poof:SetTimeout(25+rng:RandomInt(10))
                    local size = 0.2+mod:RandomInt(4,9,rng)/15
                    poof.SpriteScale = Vector(size, size)
                    mod:GetEntityData(poof).Deccel = 0.86
                    mod:GetEntityData(poof).ShrinkDelay = 10
                    poof.SpriteOffset = Vector(0, -10)
                    poof:Update()
                end
            end
            sfx:Play(SoundEffect.SOUND_KNIFE_PULL, 1, 0, false, mod:RandomInt(110,130,rng)/100)
        end
    end
end

function mod:ExecutionerNewRoom(player, d)
    if d.customChargeBarTable and player:HasCollectible(mod.ITEM.COLLECTIBLE.EXECUTIONER) then
        for id,entry in pairs(d.customChargeBarTable) do
            if entry.id == mod.ITEM.COLLECTIBLE.EXECUTIONER and not (entry.trinket or entry.extraCharge) then
                entry.Executed = nil
                entry.REALLYSTOPRENDERING = nil
                mod.ExecutionHappening = false
                entry.bababa = nil
                break
            end
        end
    end
end
mod:AddCollectibleCallback("FF_NEW_ROOM_PLAYER_FERRIUM", mod.ITEM.COLLECTIBLE.EXECUTIONER, mod.ExecutionerNewRoom)

mod:AddCollectibleCallback(mod.CALLBACK.FF_PLAYER_POST_START_GREED_WAVE, mod.ITEM.COLLECTIBLE.EXECUTIONER, function(_, player, d, waveNumber, isBossWave)
	if d.customChargeBarTable and player:HasCollectible(mod.ITEM.COLLECTIBLE.EXECUTIONER) then
        for id,entry in pairs(d.customChargeBarTable) do
            if entry.id == mod.ITEM.COLLECTIBLE.EXECUTIONER and not (entry.trinket or entry.extraCharge) then
                entry.Executed = nil
                entry.REALLYSTOPRENDERING = nil
                mod.ExecutionHappening = false
                entry.bababa = nil
                break
            end
        end
    end
end)

function mod:ExecutionerEntDamage(npc, d, damage)
    local chosenPlayer
    local count = 0
    local highest = 0
    for i = 1, game:GetNumPlayers() do
		local player = Isaac.GetPlayer(i - 1)
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.EXECUTIONER) then
            local num = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.EXECUTIONER)
            count = count+num
            if num > highest then
                highest = num
                chosenPlayer = player
            end
        end
	end
    if count > 0 and not mod:isFriend(npc) then
        if not d.SentencedForExecution and not mod.ExecutionHappening then
            local executeThresh = math.min(bal.ExecuteHealth+(count-1)*bal.ExecuteHealth2, bal.MaxThresh)
            if npc:IsBoss() then
                executeThresh = math.min(bal.ExecuteHealthBosses+(count-1)*bal.ExecuteHealth2, bal.MaxThresh)
            end
            if npc.HitPoints <= npc.MaxHitPoints*executeThresh then
                local pd = mod:GetEntityData(chosenPlayer)
                d.SentencedForExecution = true
                local timer = (pd.ExecutionerTimer or 30)+mod:RandomInt(4,20,npc:GetDropRNG())
                if npc:IsBoss() then
                    mod.AddSentenced(npc, chosenPlayer, timer, npc.MaxHitPoints*bal.BossDamagePercent, false)
                else
                    mod.AddSentenced(npc, chosenPlayer, timer, -1, false)
                end
            end
        end
    end
end