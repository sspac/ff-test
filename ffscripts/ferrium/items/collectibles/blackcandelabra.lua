local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    GrantedCurses = 2,
    Damage = 1.6,
}

local function levelHasAnyBLCurse(level)
    if level == nil then return false end
    for c = FiendFolio.curses.impCurse, FiendFolio.curses.masterCurse do
        if mod:levelHasCurse(level, c) then return true end
    end
    return false
end

local curseFromNum = {
    [0] = "curse of darkness",
    [1] = "curse of the labyrinth",
    [2] = "curse of the lost",
    [3] = "curse of the unknown",
    [5] = "curse of the maze",
    [6] = "curse of the blind",
    [mod.curses.veilCurse-1] = "curse of the veil",
}
local function AddBlackCandelabraCurses(level, rng, player)
    local potCurses = {0, 2, 3, 5, 6}
    if mod.CustomCursesEnabled then
        potCurses = {0, 2, 3, 5, 6, mod.curses.veilCurse-1}
    end
    local validCurses = {}
    for _,curse in ipairs(potCurses) do
        local blacklist
        if curse == mod.curses.veilCurse and player:HasCollectible(CollectibleType.COLLECTIBLE_GUPPYS_EYE) then
            blacklist = true
        end
        if not mod:levelHasCurse(level, curse) and not blacklist then
            table.insert(validCurses, curse)
        end
    end
    if #validCurses > 2 then
        local results = mod:getSeveralDifferentNumbers(bal.GrantedCurses, #validCurses, rng)
        local tab  = {}
        for _,result in ipairs(results) do
            table.insert(tab, validCurses[result])
        end
        validCurses = tab
    end
    if #validCurses > 0 then
        for key,curse in ipairs(validCurses) do
            game:GetHUD():ShowItemText(curseFromNum[curse])
            level:AddCurse(1 << curse, false)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, function()
    if not mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.BLACK_LANTERN) and mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.BLACK_CANDELABRA)
        and not (Isaac.GetChallenge() == mod.challenges.blursed) then
        return LevelCurse.CURSE_NONE
    end
end)

function mod:BlackCandelabraStatus()
    local level = game:GetLevel()
    local roomList = level:GetRooms()
    if game:IsGreedMode() then
        local cleared = 0
        local secret = 0
        for i=1,roomList.Size do
            local room = roomList:Get(i-1)
            if room.Clear then
                cleared = cleared+1
            end
            if (room.Data.Type == RoomType.ROOM_SECRET or room.Data.Type == RoomType.ROOM_SUPERSECRET
            or room.Data.Type == RoomType.ROOM_ULTRASECRET) then
                secret = secret+1
            end
        end
        cleared = cleared+level.GreedModeWave
        local num = cleared/(roomList.Size+11-secret)
        return math.min(math.floor(num/0.25), 3)
    else
        local cleared = 0
        local secret = 0
        for i=1,roomList.Size do
            local room = roomList:Get(i-1)
            if room.Clear then
                cleared = cleared+1
            end
            if (room.Data.Type == RoomType.ROOM_SECRET or room.Data.Type == RoomType.ROOM_SUPERSECRET
            or room.Data.Type == RoomType.ROOM_ULTRASECRET) then
                secret = secret+1
            end
        end
        local num = cleared/(roomList.Size-secret)
        return math.min(math.floor(num/0.25), 3)
    end
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, fam)
    local d = mod:GetEntityData(fam)
    fam:AddToFollowers()
    local check = mod:BlackCandelabraStatus()
    d.FlamesLeft = 3-check
    fam:GetSprite():Play("Idle" .. d.FlamesLeft, true)
    local player = fam.Player
    local pd = mod:GetEntityData(player).ffsavedata.RunEffects
    local num = bal.Damage-(check*bal.Damage/3)
    if pd.BlackCandelabraBuff ~= num then
        pd.BlackCandelabraBuff = num
        mod.scheduleForUpdate(function()
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FAMILIARS)
            player:EvaluateItems()
        end, 0)
    end
    local level = game:GetLevel()
    local roomList = level:GetRooms()
    if check == 1 then
        for i=1,roomList.Size do
            local room = roomList:Get(i-1)
            if (room.Data.Type == RoomType.ROOM_BOSS) then
                if room.DisplayFlags == 0 then
                    room.DisplayFlags = room.DisplayFlags | 5
                end
            end
        end
        level:UpdateVisibility()
    elseif check == 2 then
        for i=1,roomList.Size do
            local room = roomList:Get(i-1)
            if (room.Data.Type == RoomType.ROOM_TREASURE) then
                if room.DisplayFlags == 0 then
                    room.DisplayFlags = room.DisplayFlags | 5
                end
            end
        end
        level:UpdateVisibility()
    elseif check == 3 and (mod.savedata.run and not mod.savedata.run.BlackCandelabraActivatedThisFloor) then
        AddBlackCandelabraCurses(level, fam:GetDropRNG(), player)
        mod.savedata.run.BlackCandelabraActivatedThisFloor = true
    end
end, mod.ITEM.FAMILIAR.BLACK_CANDELABRA)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
    local sprite = fam:GetSprite()
    local d = mod:GetEntityData(fam)

    if d.UpdateFlames then
        d.UpdateFlames = nil

        local over = sprite:GetNullFrame("LostFlame")
        if over and over:GetPos() then
            local vec = Vector(over:GetPos().X*fam.SpriteScale.X, over:GetPos().Y*fam.SpriteScale.Y)
            local rng = fam:GetDropRNG()
            for i=1,3 do
                local randVel = RandomVector()*mod:RandomInt(10,30,rng)/20
                local cloud = Isaac.Spawn(1000, 59, 0, fam.Position+vec, Vector.Zero, nil):ToEffect()
                cloud:SetTimeout(mod:RandomInt(60,120,rng))
                local color = Color(0.05,0,0,0,0,0,0)
                cloud.Color = color
                local randScale = mod:RandomInt(35,70,rng)/100
                cloud.SpriteScale = Vector(0.5, 0.5)
                mod:GetEntityData(cloud).cosmeticDust = {scale = randScale, vel = randVel}
            end
        end
        sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS, 1, 0, false, 1)
    end
    mod:spritePlay(sprite, "Idle" .. d.FlamesLeft)

    fam:FollowParent()
end, mod.ITEM.FAMILIAR.BLACK_CANDELABRA)

mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, function(_, collectibleType, charge, firstTime, slot, varData, player)
    local level = game:GetLevel()

    if not levelHasAnyBLCurse(level) then
        local cursesToRemove = level:GetCurses()
		if FiendFolio.GatedBosses then
			cursesToRemove = cursesToRemove & ~(1 << (FiendFolio.curses.gateCurse - 1))
		end
    	level:RemoveCurses(cursesToRemove)
    end
end, mod.ITEM.COLLECTIBLE.BLACK_CANDELABRA)

function mod:BlackCandelabraRoomClear(waves)
    if not waves or waves == "Greed" then
        local check = mod:BlackCandelabraStatus()
        for _,f in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.BLACK_CANDELABRA, -1)) do
            local fam = f:ToFamiliar()
            local fd = mod:GetEntityData(fam)
            local update = true
            if fd.FlamesLeft then
                if 3-check < fd.FlamesLeft then
                    fd.FlamesLeft = 3-check
                else
                    update = false
                end
            else
                fd.FlamesLeft = 3-check
            end
            if update then
                fd.UpdateFlames = true
            end
            local player = fam.Player
            local pd = mod:GetEntityData(player).ffsavedata.RunEffects
            local num = bal.Damage-(check*bal.Damage/3)
            if pd.BlackCandelabraBuff ~= num then
                pd.BlackCandelabraBuff = num
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                player:EvaluateItems()
            end
            local level = game:GetLevel()
            local roomList = level:GetRooms()
            if check == 1 then
                for i=1,roomList.Size do
                    local room = roomList:Get(i-1)
                    if (room.Data.Type == RoomType.ROOM_BOSS) then
                        if room.DisplayFlags == 0 then
                            room.DisplayFlags = room.DisplayFlags | 5
                        end
                    end
                end
                level:UpdateVisibility()
            elseif check == 2 then
                for i=1,roomList.Size do
                    local room = roomList:Get(i-1)
                    if (room.Data.Type == RoomType.ROOM_TREASURE) then
                        if room.DisplayFlags == 0 then
                            room.DisplayFlags = room.DisplayFlags | 5
                        end
                    end
                end
                level:UpdateVisibility()
            elseif check == 3 and (mod.savedata.run and not mod.savedata.run.BlackCandelabraActivatedThisFloor) then
                AddBlackCandelabraCurses(level, fam:GetDropRNG(), player)
                mod.savedata.run.BlackCandelabraActivatedThisFloor = true
            end
        end
    end
end
mod:AddCollectibleCallback("FF_ROOM_CLEAR_FERRIUM", mod.ITEM.COLLECTIBLE.BLACK_CANDELABRA, mod.BlackCandelabraRoomClear)

function mod:BlackCandelabraNewRoom(_, data, rom, level)
    if rom:IsFirstVisit() and rom:IsClear() then
        local check = mod:BlackCandelabraStatus()
        for _,f in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.BLACK_CANDELABRA, -1)) do
            local fam = f:ToFamiliar()
            local fd = mod:GetEntityData(fam)
            local update = true
            if fd.FlamesLeft then
                if 3-check < fd.FlamesLeft then
                    fd.FlamesLeft = 3-check
                else
                    update = false
                end
            else
                fd.FlamesLeft = 3-check
            end
            if update then
                fd.UpdateFlames = true
            end
            local player = fam.Player
            local pd = mod:GetEntityData(player).ffsavedata.RunEffects
            local num = bal.Damage-(check*bal.Damage/3)
            if pd.BlackCandelabraBuff ~= num then
                pd.BlackCandelabraBuff = num
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                player:EvaluateItems()
            end
            local roomList = level:GetRooms()
            if check == 1 then
                for i=1,roomList.Size do
                    local room = roomList:Get(i-1)
                    if (room.Data.Type == RoomType.ROOM_BOSS) then
                        if room.DisplayFlags == 0 then
                            room.DisplayFlags = room.DisplayFlags | 5
                        end
                    end
                end
                level:UpdateVisibility()
            elseif check == 2 then
                for i=1,roomList.Size do
                    local room = roomList:Get(i-1)
                    if (room.Data.Type == RoomType.ROOM_TREASURE) then
                        if room.DisplayFlags == 0 then
                            room.DisplayFlags = room.DisplayFlags | 5
                        end
                    end
                end
                level:UpdateVisibility()
            elseif check == 3 and (mod.savedata.run and not mod.savedata.run.BlackCandelabraActivatedThisFloor) then
                AddBlackCandelabraCurses(level, fam:GetDropRNG(), player)
                mod.savedata.run.BlackCandelabraActivatedThisFloor = true
            end
        end
    end
end
mod:AddCollectibleCallback("FF_NEW_ROOM_PLAYER_FERRIUM", mod.ITEM.COLLECTIBLE.BLACK_CANDELABRA, mod.BlackCandelabraNewRoom)

function mod:BlackCandelabraNewLevel()
    for _,f in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.BLACK_CANDELABRA, -1)) do
        local fam = f:ToFamiliar()
        local d = mod:GetEntityData(fam)
        d.FlamesLeft = 3
        fam:GetSprite():Play("Idle3", true)
        local player = fam.Player
        local pd = mod:GetEntityData(player).ffsavedata.RunEffects
        local num = bal.Damage
        if pd.BlackCandelabraBuff ~= num then
            pd.BlackCandelabraBuff = num
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FAMILIARS)
            player:EvaluateItems()
        end
    end
end
mod:AddCollectibleCallback("FF_NEW_LEVEL_PLAYER_FERRIUM", mod.ITEM.COLLECTIBLE.BLACK_CANDELABRA, mod.BlackCandelabraNewLevel)