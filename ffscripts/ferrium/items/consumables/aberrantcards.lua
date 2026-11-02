local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {

}

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
    if not mod.ACHIEVEMENT.MORBID_HEART:IsUnlocked() then --Teehee nothing's wrong everyone's healthy
        for i=1,2 do
            local pos = game:GetRoom():FindFreePickupSpawnPosition(player.Position, 40, true, false)
            Isaac.Spawn(5, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL, pos, Vector.Zero, player)
        end
    else
        for i=1,2 do
            local pos = game:GetRoom():FindFreePickupSpawnPosition(player.Position, 40, true, false)
            Isaac.Spawn(5, mod.PICKUP.VARIANT.MORBID_HEART, 0, pos, Vector.Zero, player)
        end
        local heartNum = math.floor(player:GetHearts()/2)
        if heartNum > 0 then
            local rng = player:GetCardRNG(cardID)
            player:AddHearts(-heartNum)
            for i=1,heartNum do
                mod.scheduleForUpdate(function()
                    local heart = Isaac.Spawn(5, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, player.Position, Vector(0, mod:RandomInt(20,60,rng)/10):Rotated(rng:RandomInt(360)), player):ToPickup()
                    heart.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                    heart.Timeout = mod:RandomInt(25,45,rng)
                    mod:GetEntityData(heart).CosmeticDoNotPickup = true
                end, i*3+rng:RandomInt(2))
            end
            sfx:Play(SoundEffect.SOUND_POISON_HURT, 1, 0, false, 1)
        end
    end
    mod:trySayAnnouncerLine(SoundEffect.SOUND_THE_LOVERS, flags, 20)
end, mod.ITEM.CARD.ABERRANT_LOVERS)

local function roomAllowsD7Use()
    local roomtype = game:GetRoom():GetType()
    if roomtype == RoomType.ROOM_BOSS
    or roomtype == RoomType.ROOM_CHALLENGE
    then
        return false
    end

    if game:GetLevel():GetStage() == LevelStage.STAGE8 then
        if roomtype == RoomType.ROOM_DUNGEON then
            return false
        end
    end

    return true
end

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
    local rng = player:GetCardRNG(cardID)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_D7, UseFlag.USE_NOANIM, -1)
    mod.scheduleForUpdate(function()
        for _,entity in ipairs(Isaac.FindInRadius(player.Position, 1050, EntityPartition.ENEMY)) do
            if entity:ToNPC() and (not mod:isFriend(entity))
            and not (entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) or entity:HasEntityFlags(EntityFlag.FLAG_NO_TARGET)) then
                if rng:RandomInt(2) == 0 then
                    local isBoss = entity:ToNPC():IsBoss()
                    if (isBoss and roomAllowsD7Use())
                    or (not isBoss) then
                        entity:AddCharmed(EntityRef(player), -1)
                    end
                end
            end
        end
    end, 1)
    mod:trySayAnnouncerLine(SoundEffect.SOUND_DEATH, flags, 20)
end, mod.ITEM.CARD.ABERRANT_DEATH)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
    local rng = player:GetCardRNG(cardID)
    for i=1,3 do
        local pos = mod:FindRandomFreePos(player)
        local target = Isaac.Spawn(1000, EffectVariant.TARGET, 115, pos, Vector.Zero, player):ToEffect()
        mod:GetEntityData(target).VinetaArtillery = player
        target.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
        target:SetTimeout(mod:RandomInt(60,125,rng))
        target.Parent = player
        mod:GetEntityData(target).MissileTimer = 0
        target:Update()
    end
    mod:trySayAnnouncerLine(SoundEffect.SOUND_TOWER, flags, 20)
end, mod.ITEM.CARD.ABERRANT_TOWER)

local stupidCheck = 0
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, e)
    local d = mod:GetEntityData(e)
    if d.VinetaArtillery and d.VinetaArtillery:Exists() then
        local player = d.VinetaArtillery:ToPlayer()
        local aim = player:GetAimDirection()
        if aim:Length() > 0.5 then
            e.Velocity = mod:Lerp(e.Velocity, aim:Resized(25), 0.8)
        end

        if e.Timeout == 1 and (not d.VinetaCount or d.VinetaCount < 4) then
            e:SetTimeout(12)
            d.Rocketed = nil
        elseif e.Timeout < 11 and not d.Rocketed then
            local level = game:GetLevel():GetAbsoluteStage()
            d.VinetaCount = (d.VinetaCount or 0)+1
			mod.CurrentRocketTarget = e
            local rocket = Isaac.Spawn(1000, EffectVariant.ROCKET, 0, e.Position, Vector.Zero, player):ToEffect()
			mod.CurrentRocketTarget = nil
            rocket:SetTimeout(10)
            rocket.PositionOffset = Vector(0, -1000)
            rocket.SpriteScale = Vector(0.66, 0.66)
            --rocket.CollisionDamage = player.Damage*1.5+10
            rocket:FollowParent(e)
            mod:GetEntityData(rocket).RocketDamageOverride = player.Damage*1.25+10+5*level
            d.Rocketed = true
        end
    elseif d.IndFireSupport and d.RocketPlayer and d.RocketPlayer:Exists() then
        local player = d.RocketPlayer:ToPlayer()
        local enemy = d.IndFireSupport:ToNPC()
        if mod:superExists(d.IndFireSupport) then
            e.Velocity = enemy.Position-e.Position
        else
            e.Velocity = Vector.Zero
        end

        if e.Timeout < 11 and not d.Rocketed then
            local rocket = Isaac.Spawn(1000, EffectVariant.ROCKET, 0, e.Position, Vector.Zero, player):ToEffect()
            rocket:SetTimeout(10)
            rocket.PositionOffset = Vector(0, -1000)
            rocket.SpriteScale = Vector(0.5, 0.5)
            rocket:FollowParent(enemy)
            local rd = mod:GetEntityData(rocket)
            rd.RocketDamageOverride = d.IndFireSupportDam
            rd.DontHurtPlayer = true
            rd.IndSmallExplosion = Vector(0.5, 0.5)
            d.Rocketed = true
        end
        if e.Timeout == 0 then
            stupidCheck = game:GetRoom():GetFrameCount()
        end
    end
end, EffectVariant.TARGET)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, explosion)
	if explosion.SpawnerEntity and explosion.SpawnerType == EntityType.ENTITY_EFFECT then
		if explosion.SpawnerVariant == EffectVariant.ROCKET then
			local rocket = explosion.SpawnerEntity
            local rd = mod:GetEntityData(rocket)
            if rd.IndSmallExplosion then
                mod.scheduleForUpdate(function()
                    explosion.SpriteScale = rd.IndSmallExplosion
                    explosion.Scale = explosion.Scale*rd.IndSmallExplosion.X
                    explosion:Update()
                end, 1)
                stupidCheck = 0
            end
		end
	end
end, EffectVariant.BOMB_EXPLOSION)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, crater)
    if stupidCheck > 0 then
        stupidCheck = 0
        crater.SpriteScale = Vector(0.5, 0.5)
        crater:Update()
    end
end, EffectVariant.BOMB_CRATER)



mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -250, function(_, entity, amount, flags, source, cooldown)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 then return end
	if source.Type == EntityType.ENTITY_EFFECT and source.Variant == EffectVariant.ROCKET and source.Entity then
		local data = mod:GetEntityData(source.Entity)
        if data.DontHurtPlayer and entity:ToPlayer() then
            return false
        elseif data.RocketDamageOverride and entity:ToNPC() then
			return {Damage = data.RocketDamageOverride}
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
    mod.scheduleForUpdate(function()
        local rng = player:GetCardRNG(cardID)
        local pool = game:GetItemPool()
        local pockets = player:GetMaxPocketItems()
        local actives = 0
        local held = 0
        for i=2,3 do
            if player:GetActiveItem(i) > 0 then
                actives = actives+1
            end
        end
        for i=0,pockets-1 do
            if player:GetPocketItem(i):GetSlot() ~= 0 then
                held = held+1
            end
        end
        pockets = pockets-actives
        held = held-actives
        local num = math.max(0, pockets-held)
        if num > 0 then
            for i=1,num do
                mod.scheduleForUpdate(function()
                    sfx:Play(SoundEffect.SOUND_SCAMPER, 0.5, 0, false, mod:RandomInt(190,210,rng)/100)
                    local roll = rng:RandomInt(100)
                    if roll < 50 then
                        player:AddPill(pool:GetPill(rng:GetSeed()))
                    else
                        player:AddCard(pool:GetCard(rng:GetSeed()))
                    end
                end, i*8, nil, true)
            end
        end
        local trinks = 0
        for i=0,player:GetMaxTrinkets()-1 do
            if player:GetTrinket(i) > 0 then
                trinks = trinks+1
            end
        end
        trinks = player:GetMaxTrinkets()-trinks
        if trinks > 0 then
            for i=1,trinks do
                mod.scheduleForUpdate(function()
                    sfx:Play(SoundEffect.SOUND_SCAMPER, 0.5, 0, false, mod:RandomInt(190,210,rng)/100)
                    player:AddTrinket(pool:GetTrinket(false))
                end, num*8+i*8, nil, true)
            end
        end
    end, 2)
    mod:trySayAnnouncerLine(SoundEffect.SOUND_STARS, flags, 20)
end, mod.ITEM.CARD.ABERRANT_STARS)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
    local level = game:GetLevel()
    local roomList = level:GetRooms()
    for i=1,roomList.Size do
        local room = roomList:Get(i-1)
        if (room.Data.Type == RoomType.ROOM_SECRET or room.Data.Type == RoomType.ROOM_SUPERSECRET) then
            if room.DisplayFlags == 0 then
                room.DisplayFlags = room.DisplayFlags | 5
            end
            for j=0,3 do
                level:MakeRedRoomDoor(room.GridIndex, j)
            end
        end
    end
    level:UpdateVisibility()
    mod:trySayAnnouncerLine(SoundEffect.SOUND_MOON, flags, 20)
end, mod.ITEM.CARD.ABERRANT_MOON)

local soulHearts = {
    [PlayerType.PLAYER_BLUEBABY] = true,
    [PlayerType.PLAYER_BLACKJUDAS] = true,
    [PlayerType.PLAYER_THESOUL] = true,
    [PlayerType.PLAYER_JUDAS_B] = true,
    [PlayerType.PLAYER_BLUEBABY_B] = true,
    [PlayerType.PLAYER_THEFORGOTTEN_B] = true,
    [FiendFolio.PLAYER.FIEND] = true,
    [FiendFolio.PLAYER.BIEND] = true,
    [FiendFolio.PLAYER.CHINA] = true,
}

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
    local sd = mod:GetEntityData(player).ffsavedata.RunEffects
    if soulHearts[player:GetPlayerType()] then
        sd.AberrantSun = sd.AberrantSun or {}
        sd.AberrantSun[2] = (sd.AberrantSun[2] or 0)+4
    else
        sd.AberrantSun = sd.AberrantSun or {}
        sd.AberrantSun[1] = (sd.AberrantSun[1] or 0)+12
    end
    mod:trySayAnnouncerLine(SoundEffect.SOUND_SUN, flags, 20)
end, mod.ITEM.CARD.ABERRANT_SUN)

function mod:AberrantSunUpdate(player, d)
    local sd = d.ffsavedata.RunEffects
    if sd.AberrantSun then
        if game:GetFrameCount() % 450 == 0 then
            local exists
            if sd.AberrantSun[1] and sd.AberrantSun[1] > 0 then
                if player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
                    player:AddCoins(1)
                else
                    player:AddHearts(1)
                end
                exists = true
                sd.AberrantSun[1] = sd.AberrantSun[1]-1
            end
            if sd.AberrantSun[2] and sd.AberrantSun[2] > 0 then
                if player:GetPlayerType() == FiendFolio.PLAYER.CHINA then
                    player:AddBrokenHearts(-1)
                else
                    player:AddSoulHearts(1)
                end
                exists = true
                sd.AberrantSun[2] = sd.AberrantSun[2]-1
            end
            if not exists then
                sd.AberrantSun = nil
            else
                sfx:Play(SoundEffect.SOUND_VAMP_GULP, 0.6, 0, false, 1)
                local poof = Isaac.Spawn(1000, 49, 0, player.Position, Vector.Zero, player):ToEffect()
                poof.SpriteOffset = Vector(0,-40*player.SpriteScale.Y)
                poof:FollowParent(player)
                poof.DepthOffset = 50
                poof:Update()
            end
        end
    end
end

mod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.EARLY, function(_, pick, coll, low)
    if mod:GetEntityData(pick).CosmeticDoNotPickup and (coll.Type == 1 or coll.Type == 3) then
		Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pick.Variant, pick, coll, low)
        return false
    elseif mod:GetEntityData(pick).CosmeticDoNotInteract then
		Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pick.Variant, pick, coll, low)
        return false
    end
end)

--Reused from puzzle keys
local rerollingBlacklisted = {}
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function()
    for _,pick in ipairs(rerollingBlacklisted) do
        pick[1]:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF)
        pick[1]:GetSprite():SetLastFrame()
        pick.Timeout = pick[2]
    end

    rerollingBlacklisted = {}
end, CollectibleType.COLLECTIBLE_D20)

mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, function()
    rerollingBlacklisted = {}
    for _,pick in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART)) do
        if mod:GetEntityData(pick).CosmeticDoNotInteract then
            rerollingBlacklisted[#rerollingBlacklisted + 1] = {pick, pick.Timeout}
        end
    end
end, CollectibleType.COLLECTIBLE_D20)

local puzzleKeyBadCards = {
    Card.CARD_ACE_OF_CLUBS,
    Card.CARD_ACE_OF_HEARTS,
    Card.CARD_ACE_OF_SPADES,
    Card.CARD_ACE_OF_DIAMONDS,
    Card.RUNE_BLACK
}

local function fixRerolledAberrantHearts()
    for _,pick in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART)) do
        if mod:GetEntityData(pick).CosmeticDoNotInteract then
            for _, pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
                if pickup.Variant ~= pick.Variant
                and pickup.Position.X == pick.Position.X and pickup.Position.Y == pick.Position.Y then
                    pickup:Remove()
                end
            end

            for _, familiar in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR)) do
                if (familiar.Variant == FamiliarVariant.BLUE_FLY or familiar.Variant == FamiliarVariant.BLUE_SPIDER)
                and (familiar.Position.X == pick.Position.X and familiar.Position.Y == pick.Position.Y) then
                    familiar:Remove()
                end
            end

            local new = Isaac.Spawn(pick.Type, pick.Variant, pick.SubType, pick.Position, pick.Velocity, pick.SpawnerEntity)
            new.Parent = pick.Parent
            new.Timeout = pick.Timeout
            new:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            new:GetSprite():SetLastFrame()
            local d = new:GetData()
            for key,entry in pairs(pick:GetData()) do
                d[key] = entry
            end
        end
    end
end

for _, card in ipairs(puzzleKeyBadCards) do
    mod:AddCallback(ModCallbacks.MC_USE_CARD, fixRerolledAberrantHearts, card)
end

mod:AddCallback(ModCallbacks.MC_PRE_ROOM_EXIT, function()
    for _,heart in ipairs(Isaac.FindByType(5, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, false, false)) do
        if mod:GetEntityData(heart).CosmeticDoNotInteract then
            heart:Remove()
        end
    end
end)