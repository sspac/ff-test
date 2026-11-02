local mod = FiendFolio
local sfx = SFXManager()
local nilvector = Vector.Zero

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, itemID, rng, player, useflags, activeslot)
    if useflags == useflags | UseFlag.USE_CARBATTERY then
        return {Discharge = false, Remove = false, ShowAnim = false}
    else
        local useOnReuse = false
        local d = mod:GetEntityData(player)
        if d.holdingFFItem then
            d.holdingFFItem = nil
            d.HoldingFFItemBlankVisual =nil
            player:AnimateCollectible(mod.ITEM.COLLECTIBLE.LEMON_MISHUH, "HideItem", "PlayerPickup")
            if useOnReuse then
                local pool = Isaac.Spawn(1000, 32, 0, player.Position, nilvector, player)
                pool:Update()
                sfx:Play(SoundEffect.SOUND_GASCAN_POUR, 1, 0, false, 1)
                return {Discharge = true, Remove = false, ShowAnim = false}
            end
        else
            d.holdingFFItem = mod.ITEM.COLLECTIBLE.LEMON_MISHUH
            d.holdingFFItemSlot = activeslot
            d.HoldingFFItemBlankVisual = true
            player:AnimateCollectible(mod.ITEM.COLLECTIBLE.LEMON_MISHUH, "LiftItem", "PlayerPickup")
        end

        return {Discharge = false, Remove = false, ShowAnim = false}
    end
end, mod.ITEM.COLLECTIBLE.LEMON_MISHUH)

function mod:throwLemonMishuh(player, data, aim)
    local lemonsSpawned = 0
    if player:HasTrinket(mod.ITEM.TRINKET.ETERNAL_CAR_BATTERY) then
        for i = 1, math.random(3,5) do
            local tear = Isaac.Spawn(2, mod.TEAR.LEMON_MISHAP, 0, player.Position, aim:Resized(15):Rotated(-15 + math.random(30)) + player:GetTearMovementInheritance(aim), player)
            lemonsSpawned = lemonsSpawned + 1
        end
    else
        local throwCount = 1
        if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
            throwCount = throwCount + 1
        end
        if player:HasCollectible(mod.ITEM.COLLECTIBLE.ELECTRIC_DICE) then
            throwCount = throwCount + player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.ELECTRIC_DICE):RandomInt(3)
        end
        if throwCount > 1 then
            for i = 1, throwCount do
                local angle = -5 + (((i-1)/(throwCount-1)) * 10)
                local tear = Isaac.Spawn(2, mod.TEAR.LEMON_MISHAP, 0, player.Position, aim:Resized(15):Rotated(angle) + player:GetTearMovementInheritance(aim), player)
                lemonsSpawned = lemonsSpawned + 1
            end
        else
            local tear = Isaac.Spawn(2, mod.TEAR.LEMON_MISHAP, 0, player.Position, aim:Resized(15) + player:GetTearMovementInheritance(aim), player)
            lemonsSpawned = lemonsSpawned + 1
        end
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
		for i = 1, lemonsSpawned do
			player:AddWisp(CollectibleType.COLLECTIBLE_LEMON_MISHAP, player.Position)
		end
		sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT, 1, 0, false, 1)
	end
    if player:HasTrinket(mod.ITEM.ROCK.ELECTRUM) then
        local mult = mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.ELECTRUM)
        local rng = player:GetTrinketRNG(mod.ITEM.ROCK.ELECTRUM)
        local itemConfig = Isaac:GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.LEMON_MISHUH)
        local hf = function(enemy, p, m, r)
			local puddle = Isaac.Spawn(1000, 32, 0, enemy.Position, Vector.Zero, p):ToEffect()
			puddle:Update()
			puddle.Size = puddle.Size*0.3
			puddle.Scale = puddle.Scale*0.3
			puddle.CollisionDamage = puddle.CollisionDamage/3
			puddle:Update()
		end
		mod:electrumShock(player, mult, rng, itemConfig, nil, hf)
    end
    if data.holdingFFItemSlot and data.holdingFFItemSlot >= 0 then
        player:DischargeActiveItem(data.holdingFFItemSlot)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
    local d = mod:GetEntityData(tear)
    d.RotVal = d.RotVal or 0
    if tear.Velocity.X > 0 then
        d.RotVal = d.RotVal + tear.Velocity:Length()
    else
        d.RotVal = d.RotVal - tear.Velocity:Length()
    end
    tear.SpriteRotation = d.RotVal
end, mod.TEAR.LEMON_MISHAP)

mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, function(_, tear, coll)
    if tear.SpawnerEntity then
        coll:AddConfusion(EntityRef(tear.SpawnerEntity), 120, false)
    end
end, mod.TEAR.LEMON_MISHAP)

function mod:lemonMishuhTearDeath(tear, data)
    if tear.Variant == mod.TEAR.LEMON_MISHAP then
        local pool = Isaac.Spawn(1000, 32, 0, tear.Position, nilvector, tear):ToEffect()
        --IS THIS FUNNY? I THINK IT IS!
        if REPENTANCE_PLUS then
            pool.Scale = pool.Scale * 1.3
            mod:GetEntityData(pool).RepPlusModeTeeHee = true
        end
        pool:Update()
        sfx:Play(SoundEffect.SOUND_GASCAN_POUR, 1, 0, false, 1)
        local splat = Isaac.Spawn(1000, 1960, 33, tear.Position, nilvector, tear):ToEffect()
        splat.Color = Color(1, 1, 0, 1)
        splat:Update()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
    if mod:GetEntityData(eff).RepPlusModeTeeHee then
        if eff.Timeout < 275 then
            eff.Timeout = 275
        end
    end
end, 32)