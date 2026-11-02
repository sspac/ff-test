local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

function mod:lastBlackHeartReplaceCheck(pickup)
    if pickup.FrameCount < 10 then
        if pickup.Variant ~= 10 or (pickup.Variant == 10 and pickup.SubType == HeartSubType.HEART_BLACK) then
            if mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.THE_LAST_BLACK_HEART) then
                if mod:RoomForcesBlackHeart() then
                    Isaac.Spawn(13,0,0,pickup.Position,Vector.Zero,nil)
                    pickup:Remove()
                else
                    local pickupChoice
                    local dynamicPool = {}
                    for _, data in pairs(mod.UnbiasedPickups["HeartsNoBlack"]) do
                        if data.Unlocked() then
                            table.insert(dynamicPool, data.ID)
                        end
                    end
                    pickupChoice = dynamicPool[pickup:GetDropRNG():RandomInt(#dynamicPool) + 1]

                    if tonumber(pickupChoice) then
                        pickup:Morph(5, 10, pickupChoice, true)
                    else
                        pickup:Morph(5, pickupChoice.Var, pickupChoice.Sub, true)
                    end
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.lastBlackHeartReplaceCheck, 10)
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.lastBlackHeartReplaceCheck, FiendFolio.PICKUP.VARIANT.HALF_BLACK_HEART)
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.lastBlackHeartReplaceCheck, FiendFolio.PICKUP.VARIANT.BLENDED_BLACK_HEART)

FiendFolio.AddItemPickupCallback(function(player, added)
    sfx:Play(mod.Sounds.FiendHeartPickupRare, 1, 0, false, 0.5)
    game:Darken(1, 80)
end, nil, FiendFolio.ITEM.COLLECTIBLE.THE_LAST_BLACK_HEART)

function mod:lastBlackHeartPeffectUpdate(player)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.THE_LAST_BLACK_HEART) then
        if not (player:GetPlayerType() == FiendFolio.PLAYER.BIEND) then
            local sdata = mod:GetEntityData(player).ffsavedata
            local blackHearts = player:GetBlackHearts()
            if blackHearts > 0 then
                sdata.BlackHeartLowestCount = sdata.BlackHeartLowestCount or 18
                if sdata.BlackHeartLowestCount == 0 then
                    player:RemoveBlackHeart(blackHearts)
                else
                    local val = 1
                    local lowestVal = 0
                    local heartCount = 0
                    for i = 1, 18 do
                        if blackHearts & val == val then
                            heartCount = heartCount + 1
                            if lowestVal == 0 then
                                lowestVal = i
                            else
                                if heartCount > sdata.BlackHeartLowestCount then
                                    player:RemoveBlackHeart((i * 2) - 1)
                                    heartCount = heartCount - 1
                                end
                            end
                        end
                        val = val * 2
                    end
                    sdata.BlackHeartLowestCount = heartCount
                end
            else
                sdata.BlackHeartLowestCount = 0
            end
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.THE_LAST_BLACK_HEART, mod.lastBlackHeartPeffectUpdate)
