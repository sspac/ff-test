local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, familiar)
	--familiar.IsFollower = true
end, mod.ITEM.FAMILIAR.SOUL_EXTRACTION_BUM)

mod.bumVariants = {
    [FamiliarVariant.BUM_FRIEND] = true,
    [FamiliarVariant.DARK_BUM] = true,
    [FamiliarVariant.KEY_BUM] = true,
    [FamiliarVariant.SUPER_BUM] = true,
    [mod.ITEM.FAMILIAR.SOUL_EXTRACTION_BUM] = true,
    [mod.ITEM.FAMILIAR.LIL_GOLEM] = true,
}

local function findLastBum(player, familiar)
    local lastBum
    for i,entity in ipairs(Isaac.GetRoomEntities()) do
        if entity.Type == 3 and mod.bumVariants[entity.Variant] then
            local fam = entity:ToFamiliar()
            --Means it won't follow anything after itself
            if GetPtrHash(fam) == GetPtrHash(familiar) then
                break
            end
            if GetPtrHash(fam.Player) == GetPtrHash(player) then
                lastBum = entity
            end
        end
    end
    return lastBum or player
end

local bumVals = {
    ["fam"] = {
        Min = 40,
        Max = 40,
        LerpFol = 0.1,
        LerpStop = 0.5,
    },
    ["player"] = {
        Min = 80,
        Max = 80,
        LerpFol = 0.5,
        LerpStop = 0.2,
    }
}

local function findClosestGuyWithSoul(position, radius)
	radius = radius ^ 2
	local target
	for _, ent in ipairs(Isaac.GetRoomEntities()) do
		if ent:IsActiveEnemy() and ent:IsVulnerableEnemy() and not ent:IsDead()
		and not ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and ent.Type ~= mod.FFID.Tech then
			local distance = position:DistanceSquared(ent.Position)
			if distance < radius then
                if not mod:GetEntityData(ent).SoulExtractedByBum then
                    radius = distance
				    target = ent
                end
			end
		end
	end
	return target
end

function mod:soulExtractionBumPayout(familiar, rng, player)
    familiar.Coins = math.max(0, familiar.Coins - familiar.Hearts)
    familiar.Hearts = 3 + rng:RandomInt(3)
    local rand = rng:RandomFloat()
    sfx:Play(SoundEffect.SOUND_THUMBSUP)
    if rand < 0.6 then
        --60% Purgatory ghost
        local ghost = Isaac.Spawn(1000, EffectVariant.PURGATORY, 1, familiar.Position + Vector(-2,-15), Vector.Zero, Familiar)
        ghost:Update()
        sfx:Play(mod.Sounds.WingFlap,1,0,false,0.5)
    elseif rand < 0.8 then
        --20% Combat cards
        player:UseCard(mod:getCombatCard(rng))
    elseif rand < 0.94 then
        --Pennies
        if rand > 0.88 and mod.ACHIEVEMENT.HAUNTED_PENNY:IsUnlocked() then
            --6% haunted pennies
            Isaac.Spawn(5, 20, mod.PICKUP.COIN.HAUNTED, familiar.Position + RandomVector(), Vector.Zero, Familiar)
        else
            --8% cursed pennies
            Isaac.Spawn(5, 20, mod.PICKUP.COIN.CURSED, familiar.Position + RandomVector(), Vector.Zero, Familiar)
        end
        sfx:Play(mod.Sounds.D2Toss,0.3,0,false,1.6)
    elseif rand < 0.999 then
        --Wisp
        if rand < 0.965 and Isaac.GetPersistentGameData():Unlocked(Achievement.LEMEGETON) then
            --2.5% item wisps
            player:UseActiveItem(CollectibleType.COLLECTIBLE_LEMEGETON)
        else
            --3.49% normal wisps
            player:AddWisp(0, player.Position, true)
        end
        sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT, 1, 0, false, 1)
    else
        if familiar.Keys >= 3 then
            Isaac.Spawn(5, 20, mod.PICKUP.COIN.CURSED, familiar.Position + RandomVector(), Vector.Zero, Familiar)
            sfx:Play(mod.Sounds.D2Toss,0.3,0,false,1.6)
        else
            familiar.Keys = familiar.Keys + 1
            sfx:Play(SoundEffect.SOUND_DARKBUM_PAYOUT, 0.75, 0, false, 0.5)
            Isaac.Spawn(5, 100, mod.GetItemFromCustomItemPool(mod.CustomPool.DIRE_CHEST, rng), familiar.Position + RandomVector(), Vector.Zero, Familiar)
        end
    end
end

function mod:soulExtractionBumTryFindTarget(familiar, data)
    local guy = findClosestGuyWithSoul(familiar.Position, 300)
    if guy then
        data.Chasing = guy
        data.speedAddition = 0
        return true
    end
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
	local data = mod:GetEntityData(familiar)
	local sprite = familiar:GetSprite()
    local player = familiar.Player
    local isSirenCharmed = mod:isSirenCharmed(familiar)
    local rng = familiar:GetDropRNG()

    if game:GetRoom():GetFrameCount() == 0 then
        familiar.Target = nil
    end
    if familiar.Hearts == 0 then
        familiar.Hearts = 3 + rng:RandomInt(3)
    end

    if data.Payout then
        familiar.Velocity = familiar.Velocity * 0.9
        if data.PaidOut then
            if sprite:IsFinished("Spawn") then
                if familiar.Coins >= 4 then
                    data.PaidOut = nil
                else
                    data.PaidOut = nil
                    data.Payout = nil
                end
            else
                mod:spritePlay(sprite, "Spawn")
            end
        else
            if sprite:IsFinished("PreSpawn") then
                data.PaidOut = true
                mod:soulExtractionBumPayout(familiar, rng, player)
            else
                mod:spritePlay(sprite, "PreSpawn")
            end
        end
    elseif not data.Chasing then
        if not familiar.Target or (familiar.Target and not familiar.Target:Exists()) then
            familiar.Target = findLastBum(player, familiar)
        end
        local targ = familiar.Target
        --Bum movement
        local targType = "fam"
        if targ.Type == 1 then
            targType = "player"
        end
        mod:spritePlay(sprite, "FloatDown")
        local playerDistance = targ.Position:Distance(familiar.Position)
        if data.FollowingParent then
            local targVel = (targ.Position - familiar.Position):Resized(3)
            familiar.Velocity = mod:Lerp(familiar.Velocity, targVel, bumVals[targType].LerpFol)
            if playerDistance < bumVals[targType].Min then
                if familiar.Coins >= familiar.Hearts then
                    data.Payout = true
                end
                data.FollowingParent = false
            end
        else
            familiar.Velocity = mod:Lerp(familiar.Velocity, Vector.Zero, bumVals[targType].LerpStop)
            if playerDistance > bumVals[targType].Max then
                data.FollowingParent = true
            end
        end

        familiar.FireCooldown = math.max(0, familiar.FireCooldown - 1)

        if familiar.FireCooldown == 0 and familiar.FrameCount % 30 == 0 then
            mod:soulExtractionBumTryFindTarget(familiar, data)
       end
    elseif data.Chasing then
        if (data.Chasing and data.Chasing:Exists()) and not data.ChaseOver then
            if not data.SuckState then
                local targPos = data.Chasing.Position + Vector(-10,-10)
                data.speedAddition = data.speedAddition or 0
                data.speedAddition = data.speedAddition + 0.05
                local targVel = (targPos - familiar.Position):Resized(4 + data.speedAddition)
                familiar.Velocity = mod:Lerp(familiar.Velocity, targVel, 0.2)
                if targPos:Distance(familiar.Position) < 10 then
                    data.SuckState = "Extract"
                    mod:spritePlay(sprite, "ExtractStart")
                elseif player.Position:Distance(familiar.Position) < 50 then
                    if familiar.Coins >= familiar.Hearts then
                        data.Payout = true
                    end
                end
            elseif data.SuckState == "Extract" then
                if not sprite:IsPlaying("ExtractStart") then
                    mod:spritePlay(sprite, "ExtractLoop")
                end
                local targPos = data.Chasing.Position + Vector(-10,-10)
                local targVel = (targPos - familiar.Position)
                familiar.Velocity = mod:Lerp(familiar.Velocity, targVel, 0.2)
                data.SmokeSuckness = data.SmokeSuckness or 0
                data.SmokeSuckness = (data.SmokeSuckness + 1)
                if data.SmokeSuckness == 1 then
                    local dust = Isaac.Spawn(mod.FF.SoulExtractionDust.ID, mod.FF.SoulExtractionDust.Var, mod.FF.SoulExtractionDust.Sub, familiar.Position, Vector.Zero, familiar):ToEffect()
                    dust:FollowParent(familiar)
                    dust:Update()
                    local sleepVal = 999999999
                    if data.Chasing:IsBoss() then
                        familiar.FireCooldown = 180
                        sleepVal = 120
                    else
                        if data.Chasing.MaxHitPoints > 30 then
                            familiar.FireCooldown = math.min(120, math.ceil(data.Chasing.MaxHitPoints))
                        end
                        mod:GetEntityData(data.Chasing).SoulExtractedByBum = true
                    end
                    data.Chasing:AddSlowing(EntityRef(player), sleepVal, 0.8, mod.ColorGreyscaleDarkLaser)
                    familiar.Coins = familiar.Coins + 1
                    sfx:Play(SoundEffect.SOUND_BEAST_GHOST_DASH ,0.2,0,false,math.random(130,170)/100)
                elseif data.SmokeSuckness > 20 then
                    data.ChaseOver = true
                end
            end
        else
            if sprite:IsPlaying("ExtractStart") or sprite:IsPlaying("ExtractLoop") then
                mod:spritePlay(sprite, "ExtractStop")
            end
            if sprite:IsFinished("ExtractStop") or not sprite:IsPlaying("ExtractStop") then
                data.Chasing = nil
                data.SuckState = nil
                data.SmokeSuckness = nil
                data.ChaseOver = nil
                familiar.Target = nil
                familiar.Velocity = familiar.Velocity * 0.75
               --[[if familiar.Coins >= 4 then
                    if mod:soulExtractionBumPayout(familiar, rng) then
                        data.Payout = true
                        data.PayoutMean = true
                    end
                end]]
                if not data.Payout and familiar.FireCooldown <= 0 then
                    mod:soulExtractionBumTryFindTarget(familiar, data)
                end
            end
        end
    end

end, mod.ITEM.FAMILIAR.SOUL_EXTRACTION_BUM)

function mod:soulExtractionDustEffect(e)
    local sprite = e:GetSprite()
    local alpha = math.min(e.FrameCount / 10, 0.5)
    e.Color = Color(e.Color.R, e.Color.G, e.Color.B, alpha)
    if sprite:IsFinished("effect") then
        e:Remove()
    else
        mod:spritePlay(sprite, "effect")
    end
    e.SpriteOffset = Vector(0, -15)
    e.DepthOffset = 5
end