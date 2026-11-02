local mod = FiendFolio
local game = Game()

function mod:MiniatureCardNewLevel(player)
    if player:HasTrinket(mod.ITEM.TRINKET.MINIATURE_CARD) then
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.MINIATURE_CARD)
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.MINIATURE_CARD)
        local level = game:GetLevel()

        player:AddHearts(1+mult)
        local poof = Isaac.Spawn(1000, 49, 0, player.Position, Vector.Zero, player):ToEffect()
		poof.SpriteOffset = Vector(0,-40*player.SpriteScale.Y)
		poof:FollowParent(player)
		poof.DepthOffset = 50
        poof:Update()

        local ind = level:GetCurrentRoomIndex()

        local pleaseCheck = {}
        for i=-2,2 do
            local num = (math.abs(i) == 2 and 1) or 2
            for j=-num,num do
                pleaseCheck[ind+i*13+j] = true
            end
        end
        for key,_ in pairs(pleaseCheck) do
            if level:GetRoomByIdx(key) and level:GetRoomByIdx(key).GridIndex ~= key then
                pleaseCheck[level:GetRoomByIdx(key).GridIndex] = true
                pleaseCheck[key] = nil
            end
        end
        local roomList = level:GetRooms()
        for i=1,roomList.Size do
            local room = roomList:Get(i-1)
            if pleaseCheck[room.GridIndex] and room.DisplayFlags == 0 and room.Data.Type ~= RoomType.ROOM_ULTRASECRET then
                if room and room.DisplayFlags == 0 then
                    room.DisplayFlags = room.DisplayFlags | 5
                end
            end
        end
        level:UpdateVisibility()
        
        mod:GetEntityData(player).ffsavedata.RunEffects.MiniatureCardSuns = (mod:GetEntityData(player).ffsavedata.RunEffects.MiniatureCardSuns or 0)+mult
    end
end
mod:AddTrinketCallback("FF_NEW_LEVEL_PLAYER_FERRIUM", mod.ITEM.TRINKET.MINIATURE_CARD, mod.MiniatureCardNewLevel)

function mod:MiniatureCardNewRoom(player, d)
    if mod.IsActiveRoom() and d.ffsavedata and d.ffsavedata.RunEffects.MiniatureCardSuns then
        mod.scheduleForUpdate(function()
            --[[for _,enemy in ipairs(Isaac.FindInRadius(player.Position, 1000, EntityPartition.ENEMY)) do
                if enemy:ToNPC() and enemy:IsVulnerableEnemy() and not mod:isFriend(enemy) then
                    enemy:TakeDamage(50, 0, EntityRef(player), 0)
                end
            end]]
            player:UseActiveItem(CollectibleType.COLLECTIBLE_NECRONOMICON, UseFlag.USE_NOANIM, -1)
            --The sun doesn't use necronomicon, but them just popping feels weird
        end, 5)
        if d.ffsavedata.RunEffects.MiniatureCardSuns > 1 then
            d.ffsavedata.RunEffects.MiniatureCardSuns = d.ffsavedata.RunEffects.MiniatureCardSuns-1
        else
            d.ffsavedata.RunEffects.MiniatureCardSuns = nil
        end
    end
end
mod:AddTrinketCallback("FF_NEW_ROOM_PLAYER_FERRIUM", mod.ITEM.TRINKET.MINIATURE_CARD, mod.MiniatureCardNewRoom)