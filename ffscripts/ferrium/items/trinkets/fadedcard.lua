local mod = FiendFolio
local game = Game()

--Borrowing heavily from skip card

function mod:FadedCardNewRoom(player)
    if player:HasTrinket(mod.ITEM.TRINKET.FADED_CARD) then
        local room = game:GetRoom()
        if not room:IsClear() and room:GetType() == RoomType.ROOM_BOSS then
            mod.scheduleForUpdate(function()
                local overrideLogic
                local level = game:GetLevel()
                local roomDesc = level:GetCurrentRoomDesc()
                local roomsub = roomDesc.Data.Subtype

                local isHush = level:GetStage() == LevelStage.STAGE4_3 and room:GetType() == RoomType.ROOM_BOSS and roomsub == 63
                local isMother = level:GetStage() == LevelStage.STAGE4_2 and room:GetType() == RoomType.ROOM_BOSS and roomsub == 88
                local isDelirium = level:GetStage() == LevelStage.STAGE7 and room:GetType() == RoomType.ROOM_BOSS and roomsub == 70
                local isHome = level:GetStage() == LevelStage.STAGE8
                local isDadNote = level:GetStage() == LevelStage.STAGE3_2 and roomsub == 89 and game:GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH_INIT)
                local isMegaSatan = room:GetType() == RoomType.ROOM_BOSS and roomsub == 55

                if room:IsCurrentRoomLastBoss() or isHush or isMother or isDelirium or isHome or isDadNote or isMegaSatan then
                    if mod.overrideFinalBosses[roomsub] or isHome or isDadNote or roomsub == 6 or roomsub == 89 then --Adding in both moms
                        overrideLogic = true
                    end
                end
                if not overrideLogic then
                    mod:skipCardRoom()
                end
            end, 0)
        end
    end
end
mod:AddTrinketCallback("FF_NEW_ROOM_PLAYER_FERRIUM", mod.ITEM.TRINKET.FADED_CARD, mod.FadedCardNewRoom)

mod:AddTrinketCallback(mod.CALLBACK.FF_PLAYER_POST_START_GREED_WAVE, mod.ITEM.TRINKET.FADED_CARD, function(_, player, data, waveNumber, isBossWave)
	if player:HasTrinket(mod.ITEM.TRINKET.FADED_CARD) then
        if isBossWave then
            mod.scheduleForUpdate(function()
                mod:skipCardRoom()
            end, 40)
        end
    end
end)