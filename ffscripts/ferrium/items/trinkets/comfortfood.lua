local mod = FiendFolio
local game = Game()

function mod:ComfortFoodRoomClear(player, data, spawned)
    if spawned == false and player:HasTrinket(mod.ITEM.TRINKET.COMFORT_FOOD) then
        if not mod.DidRoomSpawnReward.ComfortFood and not mod.anyPlayerHas(CollectibleType.COLLECTIBLE_DEEP_POCKETS) then
            mod.DidRoomSpawnReward.ComfortFood = true
            local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.COMFORT_FOOD)
            if rng:RandomInt(2) == 0 then
                local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.COMFORT_FOOD)
                if player:GetEffectiveMaxHearts() > player:GetHearts() then
                    player:AddHearts(mult)
                    SFXManager():Play(SoundEffect.SOUND_VAMP_GULP, 1, 0, false, 1)
                    local poof = Isaac.Spawn(1000, 49, 0, player.Position, Vector.Zero, player):ToEffect()
                    poof.SpriteOffset = Vector(0,-40*player.SpriteScale.Y)
                    poof:FollowParent(player)
                    poof:Update()
                end
            end
        end
    end
end

function mod:CheckIfRoomRewardExists()
    if mod.DidRoomRewardInfo and mod.DidRoomRewardInfo.Delay and 0 == 1 then
        if mod.DidRoomRewardInfo.Delay > 0 then
            mod.DidRoomRewardInfo.Delay = mod.DidRoomRewardInfo.Delay-1
        else
            mod.DidRoomRewardInfo.Delay = nil
        end
    elseif not mod.DidRoomSpawnReward and not mod.IsActiveRoom() and mod.DidRoomRewardInfo and mod.DidRoomRewardInfo.Pos then
        local spawn = false
        local pickup
        
        --[[if level:GetCurrentRoomDesc().AwardSeed == mod.DidRoomRewardInfo.Seed then
            spawn = false
        end]]
        for _,pick in ipairs(Isaac.FindByType(5, -1, -1, false, false)) do
            if pick.FrameCount == 0 and pick.Position:Distance(mod.DidRoomRewardInfo.Pos) < 10 then
                pickup = pick
                spawn = true
                break
            end
        end
        if not spawn then
            for _,pick in ipairs(Isaac.FindByType(4, -1, -1, false, false)) do --Troll bombs can spawn too
                if pick.FrameCount == 0 and pick.Position:Distance(mod.DidRoomRewardInfo.Pos) < 10 then
                    pickup = pick
                    spawn = true
                    break
                end
            end
        end
        mod.DidRoomSpawnReward = {SpawnedCheck = spawn, Pickup = pickup}
        mod.DidRoomRewardInfo = nil
    end
end

mod:AddPriorityCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, CallbackPriority.EARLY, function(_, rng, pos)
    --mod.DidRoomRewardInfo.Rng = rng
    --mod.DidRoomRewardInfo.Seed = rng:GetSeed()
    --mod.DidRoomRewardInfo.Pos = pos This doesn't even adjust for the room laytou!?!?!
    if mod.DidRoomRewardInfo then
        mod.DidRoomRewardInfo.Pos = game:GetRoom():FindFreePickupSpawnPosition(pos, 0, false, false)
        mod.DidRoomRewardInfo.Delay = 2
    end
end)