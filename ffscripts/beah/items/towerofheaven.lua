local mod = FiendFolio
local game = Game()
local popup = "thou shalt not enter"

local function steveChallenge()
    return Isaac.GetChallenge() == mod.challenges.cursedIfItWasGood
end
local function challengeEval(_, player) --i looked at penis land on how to do this because i was confused
    if steveChallenge() then
        player:AddCollectible(mod.ITEM.COLLECTIBLE.TOWER_OF_HEAVEN)
        player:SetPocketActiveItem(mod.ITEM.COLLECTIBLE.AVGM, ActiveSlot.SLOT_POCKET, false)
        mod:TowerOfHeavenNewfloor()
    end
end
mod:AddCallback(ModCallbacks.MC_PLAYER_INIT_POST_LEVEL_INIT_STATS, challengeEval)

local function roomTypeIsntAltType(roomType, rtype)
    if (roomType ~= rtype)
    and not (rtype == RoomType.ROOM_DEVIL and roomType == RoomType.ROOM_ANGEL)
    and not (rtype == RoomType.ROOM_SECRET and roomType == RoomType.ROOM_SUPERSECRET)
    and not (rtype == RoomType.ROOM_ISAACS and roomType == RoomType.ROOM_BARREN) then
        return true
    end
end

local function roomIsntRedRoom()
    local level = Game():GetLevel()
    local roomDescriptor = level:GetCurrentRoomDesc()
    return roomDescriptor.Flags & RoomDescriptor.FLAG_RED_ROOM == 0
end

--This function name sux -erf
local function real(door, rtype)
    if steveChallenge() then
        return (door.CurrentRoomType == RoomType.ROOM_DEFAULT and door.TargetRoomType == RoomType.ROOM_DEFAULT) or door:IsRoomType(RoomType.ROOM_CURSE)
    end
    local room = game:GetRoom()
    local roomType = room:GetType()
    return (door:IsRoomType(rtype)
    or (rtype == RoomType.ROOM_DEVIL and door:IsRoomType(RoomType.ROOM_ANGEL))
    or (rtype == RoomType.ROOM_SECRET and door:IsRoomType(RoomType.ROOM_SUPERSECRET))
    or (rtype == RoomType.ROOM_ISAACS and door:IsRoomType(RoomType.ROOM_BARREN)))
    and roomTypeIsntAltType(roomType, rtype)
    and roomIsntRedRoom()
end
local function nroom(_, door)
    local rtype = FiendFolio.savedata.run.level.tower_of_heaven
    if not rtype then
        return
    end

    if real(door, rtype) then
		door:Close(true) --thanks curse of the gate
		door:Bar()
		door.State = 1
		door.CollisionClass = GridCollisionClass.COLLISION_WALL
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_GRID_ENTITY_DOOR_UPDATE, mod.ITEM.COLLECTIBLE.TOWER_OF_HEAVEN, nroom, GridEntityType.GRID_DOOR)

local bars = Sprite()
bars:Load("gfx/grid/door_17_bardoor.anm2", true)
bars:Play("Idle", true)
local renderBarsInPost = false
mod:AddCollectibleCallback(ModCallbacks.MC_PRE_GRID_ENTITY_DOOR_RENDER, mod.ITEM.COLLECTIBLE.TOWER_OF_HEAVEN, function(_, door)
    local rtype = FiendFolio.savedata.run.level.tower_of_heaven
    if not rtype then
        return
    end
	if real(door, rtype) then
        local secret = rtype == RoomType.ROOM_SECRET
		local sprite = door:GetSprite()
		if not sprite:GetAnimation() == "Closed" then
			sprite:Play("Closed", true)
		end
        local r = game:GetRoom()
        local render = false
        if r:GetFrameCount() <= 0 then
            local xtrasprite = door.ExtraSprite
            door:Bar()
            bars.Rotation = xtrasprite.Rotation
            door.ExtraSprite = bars
        end
        if door.ExtraSprite:IsPlaying("Appear") then
            door.ExtraSprite:SetAnimation("Idle", true)
            renderBarsInPost = true
            --bars:Render(Isaac.WorldToScreen(door.Position)+(Vector(0,14):Rotated(door.ExtraSprite.Rotation)))
        end
        if secret then
            renderBarsInPost = false
            bars.Rotation = door.ExtraSprite.Rotation
            bars:Render(Isaac.WorldToScreen(door.Position)+(Vector(0,15):Rotated(door.ExtraSprite.Rotation)))
            return true
        end
    end
end)

mod:AddCollectibleCallback(ModCallbacks.MC_POST_GRID_ENTITY_DOOR_RENDER, mod.ITEM.COLLECTIBLE.TOWER_OF_HEAVEN, function(_, door)
    if renderBarsInPost then
        bars:Render(Isaac.WorldToScreen(door.Position)+(Vector(0,15):Rotated(door.ExtraSprite.Rotation)))
        renderBarsInPost = false
    end
end)

local roomtypes = { --all vanilla special rooms minus treasure rooms (or maybe not >:)), boss rooms and the weeeeeird ones
    { RoomType.ROOM_SHOP, "shops"},
    { RoomType.ROOM_SECRET, "secret rooms" },
    { RoomType.ROOM_ARCADE, "arcades" },
    { RoomType.ROOM_CURSE, "curse rooms" },
    { RoomType.ROOM_CHALLENGE, "challenge rooms" }, --and boss challenge (i dont need to do anything for this one)
    { RoomType.ROOM_LIBRARY, "libraries" },
    { RoomType.ROOM_SACRIFICE, "sacrifice rooms" },
    { RoomType.ROOM_DEVIL, "devil or angel rooms" }, --and angel
    { RoomType.ROOM_ISAACS, "bedrooms" }, --and barren
    { RoomType.ROOM_CHEST, "chest rooms" },
    { RoomType.ROOM_DICE, "dice rooms" },
    { RoomType.ROOM_PLANETARIUM, "planetariums" },
    --{ RoomType.ROOM_ERROR, "error rooms??"}
    --{ RoomType.ROOM_TREASURE, "treasure rooms" }
}
function mod:TowerOfHeavenNewfloor()
    if PlayerManager.AnyoneHasCollectible(mod.ITEM.COLLECTIBLE.TOWER_OF_HEAVEN) then
        local level = game:GetLevel()
        if level:IsAscent() then
            return
        end
        local roomtype
        if steveChallenge() then
            roomtype = { RoomType.ROOM_CURSE, "curse rooms" }
            goto continue
        end
        for i = 1, #roomtypes, 1 do
            if not FiendFolio.savedata.run.tower_of_heaven or #FiendFolio.savedata.run.tower_of_heaven == 0 then
                local t = roomtypes
                mod:Shuffle(t)
                --table.insert(t, { RoomType.ROOM_TREASURE, "treasure rooms" })
                FiendFolio.savedata.run.tower_of_heaven = t
            end

            local ntype = FiendFolio.savedata.run.tower_of_heaven[i]

            local room = ntype[1]
            if room ~= RoomType.ROOM_DEVIL then
            	local sacIDX = level:QueryRoomTypeIndex(room, false, RNG())
            	if level:GetRoomByIdx(sacIDX).Data.Type == room then
            		roomtype = ntype
            	end
            else
                local lstage = level:GetAbsoluteStage()
                if lstage <= LevelStage.STAGE4_3 then
                    roomtype = ntype
                end
            end

            if roomtype ~= nil then
                table.remove(FiendFolio.savedata.run.tower_of_heaven, i)
                table.insert(FiendFolio.savedata.run.tower_of_heaven, roomtype)
                goto continue
            end
        end
        ::continue::

        local hud = game:GetHUD()
        mod.scheduleForUpdate(function ()
            FiendFolio.NextFortuneGFX = "gfx/ui/fortune_paper_towerofheaven.png"
            if roomtype ~= nil then
                FiendFolio.savedata.run.level.tower_of_heaven = roomtype[1]
                hud:ShowFortuneText(popup, roomtype[2])
            else
                --cool message if not applicable this floor
                FiendFolio.NextFortuneGFX = nil -- comment this out if you end up adding a fortune here, since it's usually set to nil automatically :-)
                --aye aye
            end
        end, 0)
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.ITEM.COLLECTIBLE.TOWER_OF_HEAVEN, mod.TowerOfHeavenNewfloor)

