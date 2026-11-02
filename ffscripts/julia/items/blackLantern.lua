local mod = FiendFolio
local game = Game()

mod.IMPCURSE_MINION_CHANCE = 50      --% chance for a heart to turn into a minion

mod.SWINECURSE_DROP_CHANCE = 50      --% chance for enemies to drop coins

mod.SUNCURSE_BUFF_MULTIPLIER = 1.1
mod.SUNCURSE_DEBUFF_MULTIPLIER = 0.85
mod.SUNCURSE_RECHARGE_TIME = 2       --how many rooms it takes for the sun curse stat boost to come back

mod.SCYTHECURSE_RAGE_MAX = 50        --treshold where player enters rage mode
mod.SCYTHECURSE_RAGE_GAIN = 1
mod.SCYTHECURSE_RAGE_DECAY_RATE = 16 --rage decays by gain rate every nth frame
mod.SCYTHECURSE_FIREDELAY_MULTIPLIER = 0.5

mod.MASTERCURSE_STYLE_MAX = 100
mod.MASTERCURSE_STYLE_GAIN_MULTIPLIER = 0.1 --damage dealt to enemy is multiplied by this to determine style level gain
mod.MASTERCURSE_STYLE_LOSS_ON_HIT = 25

mod.RAINCURSE_PROJECTILE_DAMAGE = 6.66

mod.STONECURSE_SPEED_MODIFIER = 0.3

local function levelHasAnyBLCurse(level, mask)
    if level == nil then return false end
    for c = FiendFolio.curses.impCurse, FiendFolio.curses.lunacyCurse do
        if mod:levelHasCurse(level, c, mask) then return true end
    end
    return false
end

local function areBlackLanternCursesEvil()
    if mod.anyPlayerHas(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
        return false
    elseif mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.BLACK_CANDELABRA) and mod:BlackCandelabraStatus() < 3 then
        return false
    else
        return true
    end
end

local function getRandomLanternCurse(player)
    local rng = RNG()
    if not rng then
        rng:SetSeed(game:GetSeeds():GetStartSeed(), 0)
    end

    local c = math.random(FiendFolio.curses.impCurse, FiendFolio.curses.lunacyCurse)

    --local c = math.random(FiendFolio.curses.ghostCurse, FiendFolio.curses.ghostCurse) FOR DEBUG
    if c == FiendFolio.curses.sunCurse then
        mod:GetEntityData(player).sunCurseCounter = 0
    elseif c == FiendFolio.curses.masterCurse then
        mod:GetEntityData(player).ffsavedata.masterLevel = mod.MASTERCURSE_STYLE_MAX / 2
    elseif c == FiendFolio.curses.scytheCurse then
        mod:GetEntityData(player).ffsavedata.scytheRage = 0
    end
    return 1 << (c - 1)
end

local function variableTintEntity(ent, var, max, r, g, b, multiplier)
    local intensity = var/max

    local c = Color(1,1,1,1,0,0,0)
    c:SetColorize(r, g, b, intensity * multiplier)
    --ent:GetSprite().Color = c
    ent:SetColor(c, 5, 1, true, false)
end

local function toggleRageMode(player)
    local sd = mod:GetEntityData(player).ffsavedata

    if not sd.scytheMode then
        SFXManager():Play(SoundEffect.SOUND_LARYNX_SCREAM_HI, 1, 0, false, 1)
        sd.scytheMode = true
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        player:EvaluateItems()
    else
        sd.scytheMode = false
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        player:EvaluateItems()
    end
end

local function getQualityCollectible(pool, min, max)
    min = min or 0
    max = max or 4

    local itempool = game:GetItemPool()

    if pool == -1 then
        pool = itempool:GetLastPool()
    end
    local i = 0
    local c = itempool:GetCollectible(pool)
    --print(c)

    while Isaac.GetItemConfig():GetCollectible(c).Quality < min or Isaac.GetItemConfig():GetCollectible(c).Quality > max do
        c = itempool:GetCollectible(pool)
        --print(c)

        if i > 100 then break end --prevent infinite loops if itempool doesnt have any items with desired quality
        i = i + 1
    end

    return c
end

local function getRoomEnemies()
    local enemies = {}
    for _, e in pairs(Isaac.GetRoomEntities()) do
        if e:IsVulnerableEnemy() then
            table.insert(enemies, e)
        end
    end
    return enemies
end
local function getRoomEnemiesForDynamo(rng)
    local enemies = {}
    for _, e in pairs(Isaac.GetRoomEntities()) do
        if e:IsVulnerableEnemy() then
            local npc = e:ToNPC()
            if npc and ((not npc:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET)) and (not mod:isFriend(npc))) then
                table.insert(enemies, npc)
            end
        end
    end
    if #enemies > 0 then
        return enemies[rng:RandomInt(#enemies) + 1]
    end
end

--replace normal curses
mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, function(_, curses)
    if mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.BLACK_LANTERN) then
        local player = Isaac.GetPlayer(0)
        local curse = getRandomLanternCurse(player)
        mod:GetEntityData(player).lastBlackLanternCurse = curse
        return curse
    end
end)

--wip-ish curse icon rendering

function mod:renderMasterCurseCrown(player, data, renderOffset)
    if mod.WaterRenderModes[game:GetRoom():GetRenderMode()] then return end
    if player:GetPlayerIndex() ~= 0 then return end
    local level = game:GetLevel()
    local mask = level:GetCurses()
    if mod:levelHasCurse(level, FiendFolio.curses.masterCurse, mask) then
        if data.ffsavedata.masterLevel then
            local ml = data.ffsavedata.masterLevel
            local s = Sprite()
            local room = game:GetRoom()
            s:Load("gfx/mastercrown.anm2", true)

            local anim
            if ml <= 25 then
                anim = "FloatNoGlow"
            elseif ml <= 50 then
                anim = "FloatSlightGlow"
            elseif ml <= 75 then
                anim = "FloatMoreGlow"
            else anim = "FloatGlow" end

            s:Play(anim, true)

            s:Render(room:WorldToScreenPosition(player.Position - Vector(0, 6)), nilvector, nilvector)
        end
    end
end
--mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.renderMasterCurseCrown)


--imp curse: spawn hollow minions instead of hearts that persist between a few rooms
--black candle synergy: minions spawn in addition to hearts instead of replacing them
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
    local level = game:GetLevel()
    local player = Isaac.GetPlayer(0)

    if mod:levelHasCurse(level, FiendFolio.curses.impCurse) then

        if math.random(0, 99) < mod.IMPCURSE_MINION_CHANCE and not pickup:IsShopItem() then --spawn hollow minion
            local head = math.random(170) - 1

            local minion = Isaac.Spawn(1000, mod.PICKUP.VARIANT.FIEND_MINION_EFFECT, 1, pickup.Position, Vector(0, 0), player)
            mod:GetEntityData(minion).canreroll = false
			minion.EntityCollisionClass = 4
			minion.Parent = player
            mod:GetEntityData(minion).hollow = true
            mod:GetEntityData(minion).persistent = true
            mod:GetEntityData(minion).remainingRooms = 3
            mod:GetEntityData(minion).headframe = head

            if areBlackLanternCursesEvil() then
                pickup:Remove()
            end

            local sdata = mod:GetEntityData(player).ffsavedata
            sdata.curseMinions = sdata.curseMinions or {}

            table.insert(sdata.curseMinions, {headFrame = head, remainingRooms = 3})

        end
    end
end, PickupVariant.PICKUP_HEART)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local player = Isaac.GetPlayer(0)
    local sdata = mod:GetEntityData(player).ffsavedata

    if sdata.curseMinions then
        for _, m in pairs(sdata.curseMinions) do
            --if mod:GetEntityData(player).persistentMinions[i] > 0 then
                local minion = Isaac.Spawn(1000, mod.PICKUP.VARIANT.FIEND_MINION_EFFECT, 1, player.Position, Vector(0, 0), player)
                mod:GetEntityData(minion).canreroll = false
                minion.EntityCollisionClass = 4
                minion.Parent = player
                mod:GetEntityData(minion).hollow = true
                mod:GetEntityData(minion).persistent = true
                mod:GetEntityData(minion).remainingRooms = m.remainingRooms
                mod:GetEntityData(minion).headframe = m.headFrame
                --m = minion
            --end
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, function(_, rng, pos)
    local player = Isaac.GetPlayer(0)
    local sdata = mod:GetEntityData(player).ffsavedata

    if sdata.curseMinions then
        for k, m in pairs(sdata.curseMinions) do
            m.remainingRooms = m.remainingRooms - 1
            if m.remainingRooms == 0 then
                table.remove(sdata.curseMinions, k)
            end
        end

        for _, mi in pairs(Isaac.FindByType(1000, mod.PICKUP.VARIANT.FIEND_MINION_EFFECT, 1)) do
            if mod:GetEntityData(mi).remainingRooms then
                mod:GetEntityData(mi).remainingRooms = mod:GetEntityData(mi).remainingRooms - 1
            end
        end
    end
end)


--swine curse: all pennies are timed out, enemies sometimes drop pennies
--black candle synergy: regular pennies dont have timeout, enemies still drop pennies
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
    local level = game:GetLevel()

    if mod:levelHasCurse(level, FiendFolio.curses.swineCurse) and areBlackLanternCursesEvil() then
        pickup.Timeout = 50
    end
end, PickupVariant.PICKUP_COIN)

function mod:runSwineSpawnCoinCheck(npc, data, level)
    if mod:levelHasCurse(level, FiendFolio.curses.swineCurse) then
        if (not data.ranSpawnCoinCheck) and npc:HasMortalDamage() and npc:IsEnemy() and not npc:HasEntityFlags(EntityFlag.FLAG_NO_REWARD) and npc.Type ~= EntityType.ENTITY_MOVABLE_TNT then
            if data.SpawnedAtRoomStart then
                if math.random(0, 99) < mod.SWINECURSE_DROP_CHANCE then
                    local p = Isaac.Spawn(5, PickupVariant.PICKUP_COIN, 0, npc.Position, npc.Velocity, npc):ToPickup()
                    p.Timeout = 50
                end
                data.ranSpawnCoinCheck = true
            end
        end
    end
end


--sun curse: stat boost until you get hit, which will give a negative stat multiplier, boost regenerates after 3 rooms
--black candle synergy: getting hit only drops you to base stats rather than giving a negative multiplier
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local level = game:GetLevel()

    if mod:levelHasCurse(level, FiendFolio.curses.sunCurse) then
        local player = Isaac.GetPlayer(0)

        player:AddCacheFlags(CacheFlag.CACHE_ALL)
        player:EvaluateItems()
    end
    if mod:levelHasCurse(level, FiendFolio.curses.dynamoCurse) then
        mod.CurseOfTheDynamoActive = true
    else
        mod.CurseOfTheDynamoActive = false
    end
    if mod:levelHasCurse(level, FiendFolio.curses.lunacyCurse) then
        mod.CurseOfLunacyActive = true
    else
        mod.CurseOfLunacyActive = false
    end
    --[[if mod:levelHasCurse(level, FiendFolio.curses.fungusCurse) then
        mod.CurseOfTheFungusActive = true
    else
        mod.CurseOfTheFungusActive = false
    end]]
end)

--Putting it here because it sits nicely with the above table
function mod:curseOfLunacyEntityUpdate(npc, data)
    if mod.CurseOfLunacyActive then
        if (not npc:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET)) and (not mod:isFriend(npc)) then
            if not mod:isBerserk(npc) then
                local rng = Isaac.GetPlayer():GetCollectibleRNG(mod.ITEM.COLLECTIBLE.BLACK_LANTERN)
                if rng:RandomInt(300) == 0 then
                    if mod.anyPlayerHas(CollectibleType.COLLECTIBLE_BLACK_CANDLE)
                    and rng:RandomInt(3) ~= 0 then
                        npc:AddCharmed(EntityRef(Isaac.GetPlayer()), 180)
                    else
                        mod.AddBerserk(npc, Isaac.GetPlayer(), 180)
                    end
                end
            end
        end
    end
    if mod.CurseOfTheDynamoActive then
        if (not npc:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET)) and (not mod:isFriend(npc)) then
            if data.CurseOfTheDynamoFiring then
                data.CurseOfTheDynamoTimer = data.CurseOfTheDynamoTimer or 0
                data.CurseOfTheDynamoTimer = data.CurseOfTheDynamoTimer + 1
                if data.CurseOfTheDynamoTimer > 30 then
                    data.CurseOfTheDynamoFiring = nil
                    data.CurseOfTheDynamoTimer = nil
                    npc.Color = mod.ColorNormal
                    local vec = RandomVector()
                    local fireBall = Isaac.Spawn(mod.FF.FriendFireball.ID, mod.FF.FriendFireball.Var, 0, npc.Position + (vec*npc.Size), vec, npc):ToNPC()
                    fireBall.Parent = Isaac.GetPlayer()
                    local fd = mod:GetEntityData(fireBall)
                    fd.Hits = 1
                    fd.FireballLifespan = 300
                    fd.fireballDirection = vec
                    if data.CurseOfTheDynamoBirthright then
                        fd.IsBirthrightFireball = true
                        fd.Hits = mod.FriendBalancing.SFFireballBirthrightHits
                        local fsprite = fireBall:GetSprite()
                        fsprite:ReplaceSpritesheet(0, "gfx/projectiles/projectile_friend_fireball_birthright2.png")
                        fsprite:LoadGraphics()
                    end
                    fireBall.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
                    fireBall:Update()
                    mod.scheduleForUpdate(function()
                        if fireBall and fireBall:Exists() then
                            fireBall.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                        end
                    end, 5)
                    SFXManager():Play(mod.Sounds.FireLight, 1, 0, false, mod:RandomInt(110,130,fireBall:GetDropRNG())/100)

                    local poof = Isaac.Spawn(1000,16,0,npc.Position,Vector.Zero,npc)
                    poof.SpriteOffset = Vector(0,-20)
                    poof.SpriteScale = Vector(0.6,0.6)
                    if data.CurseOfTheDynamoBirthright then
                        poof.Color = Color(1,1,1,0.5,-1,0.5,1)
                    else
                        poof.Color = Color(1,1,1,0.5,-0.5,0,1)
                    end
                    poof:Update()

                    data.CurseOfTheDynamoBirthright = nil
                else
                    if data.CurseOfTheDynamoBirthright then
                        npc:SetColor(Color(1,1,1,1,0,data.CurseOfTheDynamoTimer/60,data.CurseOfTheDynamoTimer/30), 2, 5, true, false)
                    else
                        npc:SetColor(Color(1,1,1,1,data.CurseOfTheDynamoTimer/60,0,data.CurseOfTheDynamoTimer/30), 2, 5, true, false)
                    end
                end
            end
        end
    end
end

--[[function mod:fungusCurseDeath(npc)
	if mod.CurseOfTheFungusActive then
        if not mod:isFriend(npc) then
            local rng = Isaac.GetPlayer():GetCollectibleRNG(mod.ITEM.COLLECTIBLE.BLACK_LANTERN)
            local offset = 0
            if rng:RandomInt(2) == 1 then
                offset = 45
            end
            local params = ProjectileParams()
            params.BulletFlags = ProjectileFlags.HIT_ENEMIES
            params.FallingSpeedModifier = 3
            params.Scale = 0.5
            if mod.anyPlayerHas(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
                params.BulletFlags = params.BulletFlags | ProjectileFlags.CANT_HIT_PLAYER
            end
            for i = 90, 360, 90 do
                local proj = npc:FireProjectilesEx(npc.Position, Vector(0,5):Rotated(i + offset), 0, params)
            end
        end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.fungusCurseDeath)]]

function mod:SunCursePlayerUpdate(player, data)
    local sun = data.sunCurseCounter

    if sun ~= nil then
        local level = game:GetLevel()

        if mod:levelHasCurse(level, FiendFolio.curses.sunCurse) then
            variableTintEntity(player, 3 - sun, 3, 1, 0.5, 0, 0.5)
        else
            --variableTintEntity(player, 0, 0, 1, 1, 1, 0)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, flag)
    local level = game:GetLevel()

    if mod:levelHasCurse(level, FiendFolio.curses.sunCurse) then
        local sc = mod:GetEntityData(player).sunCurseCounter
        if sc ~= nil then
            local multiplier = 1
            if sc == 0 then
                multiplier = mod.SUNCURSE_BUFF_MULTIPLIER
            elseif not areBlackLanternCursesEvil() then
                multiplier = 1
            else
                multiplier = mod.SUNCURSE_DEBUFF_MULTIPLIER
            end
            if flag == CacheFlag.CACHE_DAMAGE then
                player.Damage = player.Damage * multiplier
            elseif flag == CacheFlag.CACHE_SPEED then
                player.MoveSpeed = player.MoveSpeed * multiplier
            elseif flag == CacheFlag.CACHE_SHOTSPEED then
                player.ShotSpeed = player.ShotSpeed * multiplier
            elseif flag == CacheFlag.CACHE_FIREDELAY then
                --player.MaxFireDelay = player.MaxFireDelay * (2 - multiplier) -- direct maxfiredelay multipliers break at negative firedelay values
				player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, mod:convertTearMultABPToRep(2 - multiplier))
            elseif flag == CacheFlag.CACHE_LUCK then
                player.Luck = player.Luck * multiplier
            elseif flag == CacheFlag.CACHE_RANGE then
                player.TearHeight = player.TearHeight - (multiplier - 1)
            end
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, damage, flags, source, countdown)
    local level = game:GetLevel()

    if mod:levelHasCurse(level, FiendFolio.curses.sunCurse) and (flags & DamageFlag.DAMAGE_NO_PENALTIES == 0) and (flags & DamageFlag.DAMAGE_IV_BAG == 0) and (flags & DamageFlag.DAMAGE_FAKE == 0) then
        local player = ent:ToPlayer()

        mod:GetEntityData(player).sunCurseCounter = mod.SUNCURSE_RECHARGE_TIME
        player:AddCacheFlags(CacheFlag.CACHE_ALL)
        player:EvaluateItems()
    end
end, 1)

mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, function(_, rng, pos)
    local level = game:GetLevel()

    if mod:levelHasCurse(level, FiendFolio.curses.sunCurse) then
        local player = Isaac.GetPlayer(0)

        if mod:GetEntityData(player).sunCurseCounter ~= nil then
            if mod:GetEntityData(player).sunCurseCounter > 0 then
                mod:GetEntityData(player).sunCurseCounter = mod:GetEntityData(player).sunCurseCounter - 1
                if mod:GetEntityData(player).sunCurseCounter == 0 then
                    player:AddCacheFlags(CacheFlag.CACHE_ALL)
                    player:EvaluateItems()
                end
            end
        end
    end
end)

--scythe curse: rage builds, reaching max rage will trigger rage mode with a high tear rate but apply bruised status effect, reducing i-frames
--black candle synergy: no longer applies bruised status
function mod:CurseOfTheScytheTakeDmg(ent, damage, flags, source, countdown)
    local level = game:GetLevel()
    local buildRage = false

    if mod:levelHasCurse(level, FiendFolio.curses.scytheCurse) then
        if ent:IsActiveEnemy() then
            if source.Type == 2 or source.Type == 1 then buildRage = true end
            if source.Entity ~= nil then
                if source.Entity.SpawnerType ~= nil then
                    if source.Entity.SpawnerType == 1 then buildRage = true end
                end
            end

            if buildRage then
                local player = Isaac.GetPlayer(0)
                local sd = mod:GetEntityData(player).ffsavedata

                if not sd.scytheMode then
                    if sd.scytheRage then
                        sd.scytheRage = sd.scytheRage + mod.SCYTHECURSE_RAGE_GAIN

                        if sd.scytheRage >= mod.SCYTHECURSE_RAGE_MAX then
                            toggleRageMode(player)
                        end
                    end
                end

                buildRage = false
            end
        end
    end
end

function mod:ScytheCursePlayerUpdate(player, data)
    local level = game:GetLevel()
    data.ffsavedata.scytheRage = data.ffsavedata.scytheRage or 0

    if mod:levelHasCurse(level, FiendFolio.curses.scytheCurse) then
        variableTintEntity(player, data.ffsavedata.scytheRage, mod.SCYTHECURSE_RAGE_MAX, 1, 0, 0, 1)

        if data.ffsavedata.scytheMode and game:GetFrameCount() % mod.SCYTHECURSE_RAGE_DECAY_RATE == 0 then
            data.ffsavedata.scytheRage = data.ffsavedata.scytheRage - mod.SCYTHECURSE_RAGE_GAIN

            if data.ffsavedata.scytheRage <= 0 then
                toggleRageMode(player)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, flag)
    local sd = mod:GetEntityData(player).ffsavedata
    if not sd then return end

    if flag == CacheFlag.CACHE_FIREDELAY then
        if sd.scytheMode then
            --player.MaxFireDelay = player.MaxFireDelay * mod.SCYTHECURSE_FIREDELAY_MULTIPLIER -- direct maxfiredelay multipliers break at negative firedelay values
			player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, mod:convertTearMultABPToRep(mod.SCYTHECURSE_FIREDELAY_MULTIPLIER))
        end
    end
end)

--mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, damage, flags, source, countdown)
--    local player = ent:ToPlayer()
--
--    local sd = mod:GetEntityData(player).ffsavedata
--
--    if sd.scytheMode and not mod.anyPlayerHas(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
--        if mod:GetEntityData(player).tookDoubleDamage ~= nil and mod:GetEntityData(player).tookDoubleDamage then
--            mod:GetEntityData(player).tookDoubleDamage = false
--        else
--            local doubleDamage = damage * 2
--
--            mod:GetEntityData(player).tookDoubleDamage = true
--            player:TakeDamage(doubleDamage, flags, source, countdown)
--            return false
--        end
--    end
--end, 1)

--master curse: style system that affects item/pickup quality  TODO: should reset style level on new floor
--black candle synergy: pickups/items arent rerolled into worse ones at low style level
local function upgradePickup(variant, subtype) --returns new subtype
    if variant == 10 then --hearts
        if subtype == 1 then return 5
        elseif subtype == 2 then return 1
        elseif subtype == 3 then return 6
        elseif subtype == 8 then return 3
        else return subtype end
    elseif variant == 20 then --coins
        if subtype == 1 then return 4
        elseif subtype == 4 then return 2
        elseif subtype == 2 then return 3
        else return subtype end
    elseif variant == 30 then --keys
        if subtype == 1 then return 3
        elseif subtype == 3 then return 2
        else return subtype end
    elseif variant == 40 then --bombs
        if subtype == 1 then return 2
        elseif subtype == 2 then return 4
        elseif subtype == 3 then return 1
        elseif subtype == 5 then return 3
        elseif subtype == 6 then return 4
        else return subtype end
    elseif variant == 90 then --batteries
        if subtype == 2 then return 1
        elseif subtype == 1 then return 3
        elseif subtype == 3 then return 4
        else return subtype end
    else return subtype end
end

local function downgradePickup(variant, subtype)
    if variant == 10 then
        if subtype == 1 then return 2
        elseif subtype == 3 then return 8
        elseif subtype == 4 then return 8
        elseif subtype == 5 then return 1
        elseif subtype == 6 then return 3
        else return subtype end
    elseif variant == 20 then
        if subtype == 4 then return 1
        elseif subtype == 2 then return 4
        elseif subtype == 3 then return 2
        else return subtype end
    elseif variant == 30 then
        if subtype == 3 then return 1
        elseif subtype == 2 then return 3
        else return subtype end
    elseif variant == 40 then
        if subtype == 1 then return 3
        elseif subtype == 2 then return 1
        elseif subtype == 3 then return 5
        elseif subtype == 4 then return 2
        elseif subtype == 5 then return 6
        else return subtype end
    elseif variant == 90 then
        if subtype == 1 then return 2
        elseif subtype == 3 then return 1
        else return subtype end
    else return subtype end
end

function mod:MasterCursePlayerUpdate(player)
    local data = mod:GetEntityData(player).ffsavedata
    data.masterLevel = data.masterLevel or mod.MASTERCURSE_STYLE_MAX / 2
end

function mod:CurseOfTheMasterTakeDmg(ent, damage, flags, source, countdown)
    local level = game:GetLevel()

    if mod:levelHasCurse(level, FiendFolio.curses.masterCurse) then
        if ent:IsActiveEnemy() then
            if source.Type == 2 or source.Type == 1 then
                local player = Isaac.GetPlayer(0)
                local sd = mod:GetEntityData(player).ffsavedata

                if sd.masterLevel then
                    sd.masterLevel = math.min(mod.MASTERCURSE_STYLE_MAX, sd.masterLevel + damage * mod.MASTERCURSE_STYLE_GAIN_MULTIPLIER)
                end
            end
            if source.Entity ~= nil then
                if source.Entity.SpawnerType ~= nil and source.Entity.SpawnerType == 1 then
                    local player = Isaac.GetPlayer(0)
                    local sd = mod:GetEntityData(player).ffsavedata

                    if sd.masterLevel then
                        sd.masterLevel = math.min(mod.MASTERCURSE_STYLE_MAX, sd.masterLevel + damage * mod.MASTERCURSE_STYLE_GAIN_MULTIPLIER)
                    end
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, damage, flags, source, countdown)
    local level = game:GetLevel()

    if mod:levelHasCurse(level, FiendFolio.curses.masterCurse) and (flags & DamageFlag.DAMAGE_NO_PENALTIES == 0) and (flags & DamageFlag.DAMAGE_IV_BAG == 0) and (flags & DamageFlag.DAMAGE_FAKE == 0) then
        local player = Isaac.GetPlayer(0)
        local sd = mod:GetEntityData(player).ffsavedata
        if sd.masterLevel then
            sd.masterLevel = math.max(0, sd.masterLevel - mod.MASTERCURSE_STYLE_LOSS_ON_HIT)
        end
    end
end, 1)

local masterRerollingPickup
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
    local level = game:GetLevel()

    if mod:levelHasCurse(level, FiendFolio.curses.masterCurse) and not mod:GetEntityData(pickup:ToPickup()).rerolled and not masterRerollingPickup then
        local player = Isaac.GetPlayer(0)
        local mLevel = mod:GetEntityData(player).ffsavedata.masterLevel or mod.MASTERCURSE_STYLE_MAX / 2

        local v = pickup.Variant
        local s = pickup.SubType

        if upgradePickup(v, s) ~= s or downgradePickup(v, s) ~= s then
            masterRerollingPickup = true
            if mLevel >= mod.MASTERCURSE_STYLE_MAX * 0.9 then
                pickup:Morph(pickup.Type, v, upgradePickup(v, s), true, true)
                mod:GetEntityData(pickup).rerolled = true
            elseif mLevel >= mod.MASTERCURSE_STYLE_MAX * 0.7 then
                if math.random(0, 2) == 0 then
                    pickup:Morph(pickup.Type, v, upgradePickup(v, s), true, true)
                    mod:GetEntityData(pickup).rerolled = true
                end
            elseif mLevel <= mod.MASTERCURSE_STYLE_MAX * 0.3 and areBlackLanternCursesEvil() then
                if math.random(0, 2) == 0 then
                    pickup:Morph(pickup.Type, v, downgradePickup(v, s), true, true)
                    mod:GetEntityData(pickup).rerolled = true
                end
            elseif mLevel <= mod.MASTERCURSE_STYLE_MAX * 0.1 and areBlackLanternCursesEvil() then
                pickup:Morph(pickup.Type, v, downgradePickup(v, s), true, true)
                mod:GetEntityData(pickup).rerolled = true
            end

            masterRerollingPickup = false
        end

        --if v == 100 then
        --    local st = s
        --
        --    if mLevel >= 75 and Isaac.GetItemConfig():GetCollectible(s).Quality < 2 then
        --        st = getQualityCollectible(-1, 2, 4)
        --    elseif mLevel <= 25 and Isaac.GetItemConfig():GetCollectible(s).Quality > 2 then
        --        st = getQualityCollectible(-1, 0, 2)
        --    end
        --
        --    if st ~= s then
        --        local p = Isaac.Spawn(pickup.Type, v, st, pickup.Position, pickup.Velocity, pickup.SpawnerEntity)
        --        --pickup:Morph(5, v, st, true, true)
        --        mod:GetEntityData(p).rerolled = true
        --        pickup:Remove()
        --    end
        --end
    end
end)

--item quality stuff
local masterRerollingCollectible
mod:AddCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, function(_, type, pool, decrease, seed)
    --i   hope   the items the game goes through while searching for a suitable quality item dont get removed from the pools if theyre not actually returned in the end? but how am i supposed to know

    local level = game:GetLevel()

    if mod:levelHasCurse(level, FiendFolio.curses.masterCurse) and not masterRerollingCollectible then
    --if 0 == 1 then
        masterRerollingCollectible = true
        local player = Isaac.GetPlayer(0)
        local mLevel = mod:GetEntityData(player).ffsavedata.masterLevel or mod.MASTERCURSE_STYLE_MAX / 2
        local t = type

        if mLevel >= mod.MASTERCURSE_STYLE_MAX * 0.75 and Isaac.GetItemConfig():GetCollectible(t).Quality < 2 then
            t = getQualityCollectible(pool, 2, 4)
        elseif mLevel <= mod.MASTERCURSE_STYLE_MAX * 0.25 and Isaac.GetItemConfig():GetCollectible(t).Quality > 2 and areBlackLanternCursesEvil() then
            t = getQualityCollectible(pool, 0, 2)
        end

        masterRerollingCollectible = false

        if t ~= type then return t end
    end
end)


--ghost curse: cursed evil ghost rain that hurts both player and enemies comes down; at a higher frequency when the player is at lower health
--black candle synergy: rain doesnt hurt the player
function mod:GhostCursePlayerUpdate(player)
        if player:GetEffectiveMaxHearts() == 0 then
            mod:GetEntityData(player).ghostCurseHealth = player:GetSoulHearts() / 12 --uhhhhh idk this sucks
        else
            mod:GetEntityData(player).ghostCurseHealth = player:GetHearts() / player:GetEffectiveMaxHearts()
        end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local level = game:GetLevel()

    if mod:levelHasCurse(level, FiendFolio.curses.ghostCurse) then
        local player = Isaac.GetPlayer(0)
        local room = game:GetRoom()
        local targetFreq = 70

        if not room:IsClear() and mod:GetEntityData(player).ghostCurseHealth ~= nil then
            targetFreq = math.max(5, math.floor(mod:GetEntityData(player).ghostCurseHealth * 20))
        end

        local rainFrequency = mod:GetEntityData(player).ghostCurseRainFrequency or 70
        local dif = targetFreq - rainFrequency

        local step
        if dif < 0 then step = -0.5
        elseif dif > 0 then step = 0.5
        else step = 0 end

        if rainFrequency ~= targetFrequency then
            rainFrequency = rainFrequency + step
        end

        if rainFrequency < 70 and game:GetFrameCount() % math.floor(rainFrequency) == 0 then
            local pos = Isaac.GetRandomPosition()

            local enemies = getRoomEnemies()
            if #enemies ~= 0 and math.random(0, 1) == 0 then
                local e = enemies[math.random(1, #enemies)]
                pos = e.Position + Vector(math.random(-40, 40), math.random(-40, 40))
            end

            local target = Isaac.Spawn(1000, 7013, 2, pos, Vector(0,0), nil)
            target:Update()
        end

        mod:GetEntityData(player).ghostCurseRainFrequency = rainFrequency
    end
    if mod.CurseOfTheDynamoActive then
        local rng = Isaac.GetPlayer():GetCollectibleRNG(mod.ITEM.COLLECTIBLE.BLACK_LANTERN)
        if rng:RandomInt(120) == 0 then
            local dynamoTarget = getRoomEnemiesForDynamo(rng)
            if dynamoTarget then
                mod:GetEntityData(dynamoTarget).CurseOfTheDynamoFiring = true
                if mod.anyPlayerHas(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
                    mod:GetEntityData(dynamoTarget).CurseOfTheDynamoBirthright = true
                end
            end
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, projectile) --ugh!
    if mod:GetEntityData(projectile:ToProjectile()).projType == "cursed rain" and projectile:ToProjectile().Height >= -60 then
        if not areBlackLanternCursesEvil() then
            local players = Isaac.FindInRadius(projectile.Position, 10, EntityPartition.PLAYER)
            if #players > 0 then
                projectile:Kill()
            end
        end

        local enemies = Isaac.FindInRadius(projectile.Position, 10, EntityPartition.ENEMY)
        if #enemies > 0 then
            for _, e in pairs(enemies) do
                if e:IsVulnerableEnemy() then
                    e:TakeDamage(mod.RAINCURSE_PROJECTILE_DAMAGE, 0, EntityRef(projectile), 0)
                    e:AddFear(EntityRef(projectile), 120)
                end
            end
            projectile:Kill()
        end
    end
end, 4)


--stone curse: carrying weight system, having no trinkets/pocket items gives a speed boost, having more gives a speed down
--black candle synergy: no negative effect for high weight
function mod:StoneCursePlayerUpdate(player)
    player:AddCacheFlags(CacheFlag.CACHE_SPEED, true)
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, flag)
    local level = game:GetLevel()

    if mod:levelHasCurse(level, FiendFolio.curses.stoneCurse) and flag == CacheFlag.CACHE_SPEED then
        local stuff = 0

        for i = 0, 1 do
            if player:GetTrinket(i) ~= 0 then stuff = stuff + 1 end
            if player:GetPill(i) ~= 0 or player:GetCard(i) ~= 0 then stuff = stuff + 1 end
        end

        local modifier = - (stuff - 1) * mod.STONECURSE_SPEED_MODIFIER
        if not areBlackLanternCursesEvil() then
            modifier = math.max(0, modifier)
        end
        player.MoveSpeed = player.MoveSpeed + modifier
        if stuff == 0 then player.MoveSpeed = player.MoveSpeed + 0.15 end --extra bonus
    end
end)

local persistBLCurseThisFloor = false
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
	 persistBLCurseThisFloor = mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.BLACK_LANTERN)

   local player = Isaac.GetPlayer(0)

   --reset last curse
   mod:GetEntityData(player).lastBlackLanternCurse = 1 << -1

   if persistBLCurseThisFloor and mod.anyPlayerHas(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
     local level = game:GetLevel()
     local player = Isaac.GetPlayer(0)

     local curse = getRandomLanternCurse(player)
     mod:GetEntityData(player).lastBlackLanternCurse = curse
     level:AddCurse(curse, false)

     --evaluate sun curse
     player:AddCacheFlags(CacheFlag.CACHE_ALL)
     player:EvaluateItems()
   end
end)

--if noone has the lantern and for some reason they have the curses, nuke the curses
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local level = game:GetLevel()
    local player = Isaac.GetPlayer(0)

    if levelHasAnyBLCurse(level) and not persistBLCurseThisFloor and not (Isaac.GetChallenge() == mod.challenges.blursed or mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.BLACK_LANTERN)) then
        for _, c in pairs(FiendFolio.SunCurses) do
            level:RemoveCurses(1 << c - 1)
        end

        --reset sun/stone curse boost
        player:AddCacheFlags(CacheFlag.CACHE_ALL)
        player:EvaluateItems()
        mod:GetEntityData(player).sunCurseCounter = nil

        --reset scythe and master
        mod:GetEntityData(player).ffsavedata.scytheRage = nil
        mod:GetEntityData(player).ffsavedata.masterLevel = nil
    elseif mod:GetEntityData(player).ffsavedata.scytheRage ~= nil and mod:GetEntityData(player).ffsavedata.scytheRage > 0 and not mod:levelHasCurse(level, FiendFolio.curses.scytheCurse) then
        mod:GetEntityData(player).ffsavedata.scytheRage = nil

        mod:GetEntityData(player).ffsavedata.scytheMode = false
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        player:EvaluateItems()
        --variableTintEntity(player, 0, mod.SCYTHECURSE_RAGE_MAX, 1, 0, 0, 1)
    end
end)

--replace curse upon item pickup
mod.AddItemPickupCallback(function(player, added)
    local level = game:GetLevel()

    if not levelHasAnyBLCurse(level) then
        local cursesToRemove = level:GetCurses()
        if FiendFolio.GatedBosses then
            cursesToRemove = cursesToRemove & ~(1 << (FiendFolio.curses.gateCurse - 1))
        end
        level:RemoveCurses(cursesToRemove)
        local curse = getRandomLanternCurse(player)
        mod:GetEntityData(player).lastBlackLanternCurse = curse
        level:AddCurse(curse, false)
    end

	persistBLCurseThisFloor = true
end, nil, mod.ITEM.COLLECTIBLE.BLACK_LANTERN, true)

mod.AddItemPickupCallback(function(player, added)
    local level = game:GetLevel()

    local curse

    if mod:GetEntityData(player).lastBlackLanternCurse then
        curse = mod:GetEntityData(player).lastBlackLanternCurse
    else
        curse = getRandomLanternCurse(player)
    end
    level:AddCurse(curse, false)
end, nil, CollectibleType.COLLECTIBLE_BLACK_CANDLE, true)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    local level = game:GetLevel()
    local curseMask = level:GetCurses()

    if mod:levelHasCurse(level, FiendFolio.curses.masterCurse, curseMask) then
        mod:MasterCursePlayerUpdate(player)
    end
    if mod:levelHasCurse(level, FiendFolio.curses.ghostCurse, curseMask) then
        mod:GhostCursePlayerUpdate(player)
    end
    if mod:levelHasCurse(level, FiendFolio.curses.stoneCurse, curseMask) then
        mod:StoneCursePlayerUpdate(player)
    end
end)
