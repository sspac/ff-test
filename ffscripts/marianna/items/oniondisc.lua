local mod = FiendFolio
local game = Game()
local hud = game:GetHUD()

--==========--
--Onion Disc--
--==========--

--beah let me cannibalize the dis function (beah: it's true! i did!)
local function AddOnionItem(player, isActuallyDis, pos)
    if isActuallyDis == nil then
        isActuallyDis = true
    end
    local p_data = mod:GetEntityData(player)

    local onionsweighted = {
        --beah: if we ever add new inhouse onions please look at disAcheron.lua to set it up and make it give the flat tears like other sad onions
        mod.ITEM.COLLECTIBLE.ONION_DISC,
        CollectibleType.COLLECTIBLE_DEAD_ONION,
        mod.ITEM.COLLECTIBLE.THE_HAPPY_GO_LUCKY_ONION,
        mod.ITEM.COLLECTIBLE.SIDEWAYS_ONION,
        mod.ITEM.COLLECTIBLE.SIDEWAYS_ONION,
        CollectibleType.COLLECTIBLE_SAD_ONION,
        CollectibleType.COLLECTIBLE_SAD_ONION,
        CollectibleType.COLLECTIBLE_SAD_ONION,
    }
    if TaintedTreasure then
        table.insert(onionsweighted, TaintedCollectibles.BAD_ONION)
        table.insert(onionsweighted, TaintedCollectibles.SORROWFUL_SHALLOT)
--        print("inserted bad onion!")
    end
	if TheSadOnion2 then
        table.insert(onionsweighted, TheSadOnion2.Source.Item.TheSadOnion2.ID)
	end

    local collectible = onionsweighted[math.random(#onionsweighted)]
    if collectible == mod.ITEM.COLLECTIBLE.ONION_DISC then
        if math.random(3) ~= 1 then
            collectible = onionsweighted[math.random(2, #onionsweighted)]
--            print("i rerolled onion disc :(")
        end
    end
    p_data.ffsavedata.RunEffects.disItems = p_data.ffsavedata.RunEffects.disItems or {}
    table.insert(p_data.ffsavedata.RunEffects.disItems, {
        id = collectible,
        time = 60*30,
        dis = isActuallyDis,
        position = pos,
        readyToProcess = false,
        onion = true
    })
end

local function EnemyDies(_, enemy)
    local allP = mod:AllPlayersWithCollectible(mod.ITEM.COLLECTIBLE.ONION_DISC)
    for _, player in ipairs(allP) do
        local roll = math.random(100)
        if roll <= 5 + (player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.ONION_DISC) * 5) + (player.Luck * 2) then
            AddOnionItem(player, false, enemy.Position)
            --do flashy visuals (THANKS JUNEBEAH (np!))
            local white = Color(0.5,1,1,1,0.5,0.5,0.5)
            local green = Color(0.1,1,0.1,1,0.5,0.5,0.5)
            local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 3, enemy.Position, Vector.Zero, enemy)
            poof.Color = white
            local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 4, enemy.Position, Vector.Zero, enemy)
            poof.Color = green
            --player:MakeBloodPoof(enemy.Position, )
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, EnemyDies)

--beah: i wrote this part teehee
--[[mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_CUSTOM_CACHE, mod.ITEM.COLLECTIBLE.ONION_DISC, function (_, player)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.ONION_DISC) then
        return 50
    end
end, CustomCacheTag.TEARS_CAP)]]