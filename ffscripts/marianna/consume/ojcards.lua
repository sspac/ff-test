local mod = FiendFolio
local game = Game()
local hud = game:GetHUD()
local tookDamage = 0
local cbsUsed = 0
local sfx = SFXManager()

local bal = {
    PresentCards = 2,
    PresentReroll = 10,

    BusinessTotal = {20,55},
    BusinessHit = {2,5},
    BusinessDur = 220,

    StrongerBase = 1,
    StrongerBuffed = 2,

    SeagullDamageFlat = 10,
    SeagullScale = 5,

    FireSupportCount = 4,
    FireSupportFreq = 38,
    FireSupportFlat = 6,
    FireSupportScale = 2,

    SereneDur = 140,

    MixTiles = 3,

    RushInvuln = 80,
    RushExplosionFlat = 15,
    RushExplosionScale = 5,
    RushFlat = 5,
    RushMult = 1.5,

    WindySpeed = 0.15,

    PeaterChance = 10,
    PeaterDamage = 1,
    PeaterSpeed = 0.15,
    PeaterRange = 15,
    PeaterTears = 0.3,
    PeaterLuck = 1,
    PeaterShotSpeed = 0.2,
}

--=======================--
--100% Orange Juice Cards--
--=======================--

--Nice Present

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
    local rng = player:GetCardRNG(mod.ITEM.CARD.OJ_PRESENT)
    for i=1,bal.PresentCards do
        local id = mod:weightedRNG(mod.OrangeJuiceCards, rng)

        mod.scheduleForUpdate(function()
            local vec = Vector(mod:RandomInt(3,8,rng), 0):Rotated(rng:RandomInt(360))
            local card = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, id, player.Position, vec, player):ToPickup()
        end, i*5)
    end

    sfx:Play(mod.Sounds.OrangeJuiceCard)
    mod:trySayAnnouncerLine(mod.Sounds.VACardOrangeJuiceNicePresent, flags, 30)
end, mod.ITEM.CARD.OJ_PRESENT)

--Dark Side of Business

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
    local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
    local rng = player:GetCardRNG(mod.ITEM.CARD.OJ_BUSINESS)
    for i, v in pairs(Isaac.GetRoomEntities()) do
        if v:IsVulnerableEnemy() and not v:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) and (not mod:isFriend(v)) then
            local perHit = rng:RandomInt(bal.BusinessHit[1], bal.BusinessHit[2])
            local total = rng:RandomInt(bal.BusinessTotal[1], bal.BusinessTotal[2])
            mod.AddMugged(v, player, bal.BusinessDur * secondHandMultiplier, false, perHit, total, true)
        end
    end
    sfx:Play(mod.Sounds.OrangeJuiceCard)
    mod:trySayAnnouncerLine(mod.Sounds.VACardOrangeJuiceDarkSideOfBusiness, flags, 30)
end, mod.ITEM.CARD.OJ_BUSINESS)

--Coming Back Stronger

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.LATE, function(_, player, amount, flags)
    tookDamage = 1
--    print("took damage")
end, 1)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
    local pineapple = mod:GetEntityData(player)
    if tookDamage == 1 then
        pineapple.cbsDamage = (pineapple.cbsDamage or 0) + bal.StrongerBuffed
    else
        pineapple.cbsDamage = (pineapple.cbsDamage or 0) + bal.StrongerBase
    end
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    player:EvaluateItems()

--    print(tostring(pineapple.cbsDamage))
    sfx:Play(mod.Sounds.OrangeJuiceCard)
    mod:trySayAnnouncerLine(mod.Sounds.VACardOrangeJuiceComingBackStronger, flags, 30)
end, mod.ITEM.CARD.OJ_STRONGER)

local fireSupportData = {}
local fireSupportFrame
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    for i = 1, game:GetNumPlayers() do
        local player = Isaac.GetPlayer(i-1)
        local pineapple = mod:GetEntityData(player)
        local changed
        if pineapple.cbsDamage then
            pineapple.cbsDamage = 0
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            changed = true
        end
        if pineapple.WindyEnchantmentUsed then
            pineapple.WindyEnchantmentUsed = nil
            player:AddCacheFlags(CacheFlag.CACHE_SPEED)
            changed = true
        end
        if pineapple.PeaterStats then
            pineapple.PeaterStats = nil
            player:AddCacheFlags(CacheFlag.CACHE_ALL)
        end

        if changed then
            player:EvaluateItems()
        end
    end

    tookDamage = 0
--    print("damage reset")

    fireSupportData = {}
    fireSupportFrame = nil
end)

-- okay now it's for my cards

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, id, player, flags)
    local enemies = {}
    for i=1,game:GetNumPlayers() do
        table.insert(enemies, Isaac.GetPlayer(i-1))
    end
    for _,entity in ipairs(Isaac.FindInRadius(player.Position, 1050, EntityPartition.ENEMY)) do
        if not entity:ToNPC() then return end
        entity = entity:ToNPC()
		if (not mod:isFriend(entity)) and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
			table.insert(enemies, entity)
		end
	end
    local rng = player:GetCardRNG(mod.ITEM.CARD.OJ_SEAGULLS)
    local chosen = enemies[rng:RandomInt(#enemies)+1]
    if chosen.Type == 1 then
        chosen:ToPlayer():UseActiveItem(CollectibleType.COLLECTIBLE_DULL_RAZOR, UseFlag.USE_NOANIM, -1)
    else
        local level = game:GetLevel():GetAbsoluteStage()
        chosen:TakeDamage(bal.SeagullDamageFlat+bal.SeagullScale*level, 0, EntityRef(player), 0)
    end
    local rangle = rng:RandomInt(360)
    for i = 120, 360, 120 do
        local vec = Vector(0,3):Rotated(i+rangle)
        local sparkle = Isaac.Spawn(1000, 1727, 0, chosen.Position + vec:Resized(20), vec, chosen):ToEffect()
        sparkle.SpriteOffset = Vector(0,-12)
        sparkle:SetColor(Color(1, 1, 0.3, 1, 0.55, 0.55, 0), 100, 1, false, false)
        sparkle:Update()
    end
    sfx:Play(mod.Sounds.OrangeJuiceHit, 1, 0, false, 1)

    sfx:Play(mod.Sounds.OrangeJuiceCard)
    mod:trySayAnnouncerLine(mod.Sounds.VACardOrangeJuiceCloudOfSeagulls, flags, 30)
end, mod.ITEM.CARD.OJ_SEAGULLS)


mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, id, player, flags)
    table.insert(fireSupportData, {player = player, count = bal.FireSupportCount})
    fireSupportFrame = fireSupportFrame or game:GetRoom():GetFrameCount()

    sfx:Play(mod.Sounds.OrangeJuiceCard)
    mod:trySayAnnouncerLine(mod.Sounds.VACardOrangeJuiceIndiscriminateFireSupport, flags, 30)
end, mod.ITEM.CARD.OJ_FIRE_SUPPORT)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    if fireSupportData and #fireSupportData > 0 and mod.IsActiveRoom() then
        local room = game:GetRoom()
        local entry = fireSupportData[1]


        if (room:GetFrameCount()-fireSupportFrame) % bal.FireSupportFreq == 1 then
            local try = true
            local failure
            while try do
                if entry then
                    if not mod:superExists(entry.player) then
                        table.remove(fireSupportData, 1)
                        entry = fireSupportData[1]
                    else
                        try = false
                    end
                else
                    failure = true
                    try = false
                end
            end

            if not failure then
                local player = entry.player
                local rng = player:GetCardRNG(mod.ITEM.CARD.OJ_FIRE_SUPPORT)
                local enemies = {}
                for _,entity in ipairs(Isaac.FindInRadius(Vector(80,80), 1050, EntityPartition.ENEMY)) do
                    if not entity:ToNPC() then return end
                    entity = entity:ToNPC()
                    if (not mod:isFriend(entity)) and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
                        table.insert(enemies, entity)
                    end
                end
                if #enemies > 0 then
                    local enemy = enemies[rng:RandomInt(#enemies)+1]
                    local target = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TARGET, 115, enemy.Position, Vector.Zero, player):ToEffect()

                    target:SetTimeout(20)
                    target.Parent = player

                    local td = mod:GetEntityData(target)
                    td.IndFireSupport = enemy:ToNPC()
                    td.RocketPlayer = player
                    local level = game:GetLevel():GetAbsoluteStage()
                    td.IndFireSupportDam = bal.FireSupportFlat+level*bal.FireSupportScale

                    entry.count = entry.count-1
                    if entry.count <= 0 then
                        table.remove(fireSupportData, 1)
                    end
                end
            end
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, id, player, flags)
    local entities = Isaac.GetRoomEntities()
    local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
	for _,entity in ipairs(entities) do
        if entity:ToNPC() then
            entity = entity:ToNPC()
            if mod:checkIfStatusLogicIsApplied(entity, false) and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
                mod.AddPacified(entity, player, bal.SereneDur * secondHandMultiplier)
            end
        end
	end

    sfx:Play(mod.Sounds.OrangeJuiceCard)
    mod:trySayAnnouncerLine(mod.Sounds.VACardOrangeJuiceSereneHush, flags, 30)
end, mod.ITEM.CARD.OJ_SERENE_HUSH)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, id, player, flags)
    local found = 0
    for _,tile in ipairs(Isaac.FindByType(mod.FF.OrangeJuiceTile.ID, mod.FF.OrangeJuiceTile.Var, mod.FF.OrangeJuiceTile.Sub, false, false)) do
        local d = mod:GetEntityData(tile)
        if not d.disappearing then
            found = found+1
            d.TryReroll = true
        end
    end

    if found < bal.MixTiles then
        for i=1,bal.MixTiles-found do
            mod:CreateNewOrangeJuiceTile()
        end
    end

    sfx:Play(mod.Sounds.OrangeJuiceCard)
    mod:trySayAnnouncerLine(mod.Sounds.VACardOrangeJuiceMixPhenomenon, flags, 30)
end, mod.ITEM.CARD.OJ_MIX_PHENOMENON)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, id, player, flags)
    local enemies = {}
    for _,entity in ipairs(Isaac.FindInRadius(player.Position, 1050, EntityPartition.ENEMY)) do
        if not entity:ToNPC() then return end
        entity = entity:ToNPC()
		if (not mod:isFriend(entity)) and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
            if entity.Pathfinder:HasPathToPos(player.Position) then
                table.insert(enemies, entity)
            end
		end
	end
    if #enemies > 0 then
        local rng = player:GetCardRNG(mod.ITEM.CARD.OJ_SEAGULLS)
        local chosen = enemies[rng:RandomInt(#enemies)+1]

        local targPos = chosen.Position
        player:Teleport(targPos, true, true)
        player:SetMinDamageCooldown(bal.RushInvuln)
        local level = game:GetLevel():GetAbsoluteStage()
        mod.scheduleForUpdate(function()
            Isaac.Explode(player.Position, player, bal.RushExplosionFlat+bal.RushExplosionScale*level)
            if mod:superExists(chosen) then
                chosen:TakeDamage(bal.RushFlat+player.Damage*bal.RushMult, 0, EntityRef(player), 0)
            end
        end, 5)
    end

    sfx:Play(mod.Sounds.OrangeJuiceCard)
    mod:trySayAnnouncerLine(mod.Sounds.VACardOrangeJuiceJonathanRush, flags, 30)
end, mod.ITEM.CARD.OJ_JONATHAN_RUSH)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, id, player, flags)
    local d = mod:GetEntityData(player)
    d.WindyEnchantmentUsed = (d.WindyEnchantmentUsed or 0)+bal.WindySpeed
    player:AddCacheFlags(CacheFlag.CACHE_SPEED)
    player:EvaluateItems()

    sfx:Play(mod.Sounds.OrangeJuiceCard)
    mod:trySayAnnouncerLine(mod.Sounds.VACardOrangeJuiceWindyEnchantment, flags, 30)
end, mod.ITEM.CARD.OJ_ENCHANTMENT)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, id, player, flags)
    local rng = player:GetCardRNG(mod.ITEM.CARD.OJ_HINDENPEATER)
    local d = mod:GetEntityData(player)

    local activeFlags = (UseFlag.USE_NOANIM | UseFlag.USE_NOCOSTUME)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_WAFER, activeFlags)

    d.PeaterStats = d.PeaterStats or {Damage = 0, Tears = 0, Speed = 0, Range = 0, ShotSpeed = 0, Luck = 0}
    d.PeaterStats.Damage = d.PeaterStats.Damage + bal.PeaterDamage
    d.PeaterStats.Tears = d.PeaterStats.Tears + bal.PeaterTears
    d.PeaterStats.Luck = d.PeaterStats.Luck + bal.PeaterLuck
    d.PeaterStats.Range = d.PeaterStats.Range + bal.PeaterRange
    d.PeaterStats.ShotSpeed = d.PeaterStats.ShotSpeed + bal.PeaterShotSpeed
    d.PeaterStats.Speed = d.PeaterStats.Speed + bal.PeaterSpeed
    player:AddCacheFlags(CacheFlag.CACHE_ALL)
    player:EvaluateItems()

    sfx:Play(mod.Sounds.OrangeJuiceCard)
    if rng:RandomInt(bal.PeaterChance) == 0 then
        mod:trySayAnnouncerLine(mod.Sounds.VACardOrangeJuiceHindenpeaterRare, flags, 30)
    else
        mod:trySayAnnouncerLine(mod.Sounds.VACardOrangeJuiceHindenpeater, flags, 30)
    end
end, mod.ITEM.CARD.OJ_HINDENPEATER)