local mod = FiendFolio

local bal = {
	max = 10,
	dam = 0.4,
	bigDam = 2, --Multiplier for standard boost
	tears = 0.4,
}

function mod:NonEuclideanRockNewLevel(player, d, room, level)
	if player:HasTrinket(mod.ITEM.ROCK.NON_EUCLIDEAN_ROCK) then
		d.NonEuclideanRockRooms = {}
		local doors = mod.availableDoors[room:GetRoomShape()]
        local foundRooms = {}
        for _,checkDoor in ipairs(doors) do
            local checkedDoor = room:GetDoor(checkDoor)
			if checkedDoor then
				table.insert(foundRooms, level:GetRoomByIdx(checkedDoor.TargetRoomIndex).ListIndex)
			end
        end
		d.NonEuclideanRockRooms = foundRooms

		d.ffsavedata.RunEffects.NonEuclideanData = {Damage = 0, CurrentRoom = false, Mult = bal.bigDam, Tears = bal.tears, Num = 0}
		player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY, true)

		level:AddCurse(LevelCurse.CURSE_OF_MAZE)
	end
end
mod:AddTrinketCallback("FF_NEW_LEVEL_PLAYER_FERRIUM", mod.ITEM.ROCK.NON_EUCLIDEAN_ROCK, mod.NonEuclideanRockNewLevel)

function mod:NonEuclideanRockNewRoom(player, d, room, level)
	if player:HasTrinket(mod.ITEM.ROCK.NON_EUCLIDEAN_ROCK) then
		if not d.NonEuclideanRockRooms then
			
		else
			local id = level:GetCurrentRoomDesc().ListIndex
			local standard
			for _,entry in pairs(d.NonEuclideanRockRooms) do
				if id == entry then
					standard = true
					break
				end
			end
			local entry = d.ffsavedata.RunEffects.NonEuclideanData
			entry = entry or {Damage = 0, CurrentRoom = false, Mult = bal.bigDam, Tears = bal.tears, Num = 0}
			if not standard then
				local mult = mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.NON_EUCLIDEAN_ROCK)
				if entry.Num < bal.max then
					entry.Damage = entry.Damage+bal.dam*mult
					entry.CurrentRoom = true

					local rng = player:GetTrinketRNG(mod.ITEM.ROCK.NON_EUCLIDEAN_ROCK)
					local num = 3
					if player:GetHearts() < player:GetEffectiveMaxHearts() then
						num = 4
					end
					local roll = rng:RandomInt(num)
					if roll == 0 then
						player:AddCoins(1)
					elseif roll == 1 then
						player:AddKeys(1)
					elseif roll == 2 then
						player:AddBombs(1)
					elseif roll == 3 then
						player:AddHearts(1)
					end
				end
				entry.Num = entry.Num+1
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY, true)
			else
				if entry.CurrentRoom then
					entry.CurrentRoom = false
					player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY, true)
				end
			end
		end

		d.NonEuclideanRockRooms = {}
		local doors = mod.availableDoors[room:GetRoomShape()]
        local foundRooms = {}
        for _,checkDoor in ipairs(doors) do
            local checkedDoor = room:GetDoor(checkDoor)

			if checkedDoor then
				table.insert(foundRooms, level:GetRoomByIdx(checkedDoor.TargetRoomIndex).ListIndex)
			end
        end
		d.NonEuclideanRockRooms = foundRooms
	end
end
mod:AddTrinketCallback("FF_NEW_ROOM_PLAYER_FERRIUM", mod.ITEM.ROCK.NON_EUCLIDEAN_ROCK, mod.NonEuclideanRockNewRoom)