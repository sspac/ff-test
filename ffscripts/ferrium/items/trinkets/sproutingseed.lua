local mod = FiendFolio

function mod:SproutingSeedTrinketUpdate(trinket, d)
    if mod:GetRealTrinketId(trinket.SubType) == mod.ITEM.TRINKET.SPROUTING_SEED and trinket.Touched == true then
        if not d.ClosestPlayer then
            d.ClosestPlayer = mod:getClosestPlayer(trinket.Position, 50)
        end
        if trinket:GetSprite():IsEventTriggered("DropSound") and d.ClosestPlayer and d.ClosestPlayer:Exists() and mod.IsActiveRoom() then
            local vine = Isaac.Spawn(3, mod.ITEM.FAMILIAR.SWEET_RED_BRAMBLE, 0, trinket.Position, Vector.Zero, d.ClosestPlayer):ToFamiliar()
            vine.Player = d.ClosestPlayer
            mod:GetEntityData(vine).SproutingSeed = trinket
            mod:GetEntityData(vine).SproutingSeedOriginalSub = trinket.SubType

            trinket.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            mod:GetEntityData(trinket).DontPickUpTrinket = true
            trinket.Visible = false
            mod:GetEntityData(trinket).VineFam = vine
        end

        if d.VineFam then
            if d.VineFam:Exists() then
                trinket.Position = d.VineFam.Position
            else
                trinket.Visible = true
                mod:GetEntityData(trinket).DontPickUpTrinket = nil
                trinket.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                d.VineFam = nil
            end
        end
    end
end

function mod:SproutingSeedHurt(player)
    if player:HasTrinket(mod.ITEM.TRINKET.SPROUTING_SEED) and mod.IsActiveRoom() then
        local found
        for i=0,1 do
            if player:GetTrinket(i) == mod.ITEM.TRINKET.SPROUTING_SEED then
                local sub = player:GetTrinket(i)
                player:TryRemoveTrinket(mod.ITEM.TRINKET.SPROUTING_SEED)
                local trinket = Isaac.Spawn(5, 350, sub, player.Position, Vector.Zero, player):ToPickup()
                mod:GetEntityData(trinket).ClosestPlayer = player
                trinket.Touched = true
                found = true
                break
            end
        end
        if not found then
            local vine = Isaac.Spawn(3, mod.ITEM.FAMILIAR.SWEET_RED_BRAMBLE, 0, player.Position, Vector.Zero, player):ToFamiliar()
        end
    end
end

mod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.EARLY, function(_, pickup, coll)
    local d = mod:GetEntityData(pickup)
    if coll and coll:ToPlayer() and d.DontPickUpTrinket then
        return true
    end
end, 350)