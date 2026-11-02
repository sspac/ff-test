local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local thisDirectory = "ffscripts/beah/"
local i_ = thisDirectory.."items/"
local t_ = thisDirectory.."trinkets/"
local c_ = thisDirectory.."cards/"
local ch_= thisDirectory.."challenges/"
local g_ = thisDirectory.."golem/"

--[[returns with the charge of the item and the slot of the item.
something wicked remnant function]]
function mod:BeahCheckPlayerForActiveData(player, item)
    for i = 0, 3, 1 do
        local currentItem = player:GetActiveItem(i)
        if item == currentItem then
            local charge = player:GetActiveCharge(i) + player:GetBatteryCharge(i)
            return charge, i
        end
    end
    return 0, -1
end

function mod:RoomTypeCurrentlyExists(roomtype)
	local level = game:GetLevel()
	local sacIDX = level:QueryRoomTypeIndex(roomtype, false, RNG())
	if level:GetRoomByIdx(sacIDX).Data.Type == roomtype then
		return true
	end
	return false
end

local function OnNewRoom()
    local newFloor = false
    local room = game:GetRoom()
    local rtype = room:GetType()

    local level = game:GetLevel()
    local currRoom = level:GetCurrentRoomDesc()
    local currIdx = level:GetCurrentRoomIndex()
    local firstVisit = currRoom.VisitedCount == 1
  
    if firstVisit and level:GetStartingRoomIndex() == currIdx then
        newFloor = true
    end

    local hasDoneSacRoom = false
    mod:creativeAIrunLoad()
    for _, player in ipairs(mod:GetAllPlayers()) do
        mod:CreationEnterNewRoom(player)
        local pd = mod:GetEntityData(player)
        local d = pd.ffsavedata.RunEffects
        if d.devaTimedItems then
            for index, value in pairs(d.devaTimedItems) do
                d.devaItems[index] = nil
            end
        end
        if firstVisit and rtype == RoomType.ROOM_SACRIFICE then
            mod:SacrificeRoomItem(player)
        end
        
        if newFloor then
            d.devaItems = {}
            d.deadFamiliars = nil
            mod.savedata.run.sweeperRooms = {}
            d.kalusTongueBuff = nil

            if player:HasCollectible(mod.ITEM.COLLECTIBLE.DISCIPLINE) and not hasDoneSacRoom then
                hasDoneSacRoom = true
                mod:MakeNewSacRoomSometimes()
            end
            if player:HasCollectible(mod.ITEM.COLLECTIBLE.PLANCHETTE) then
                local effects = player:GetEffects()
                effects:AddCollectibleEffect(mod.ITEM.COLLECTIBLE.PLANCHETTE)
                
                local costume = Isaac.GetCostumeIdByPath("gfx/characters/058_Book of Shadows.anm2")
                player:AddNullCostume(costume)
            end

            mod:tefilinNewFloorPlayer(player)
            mod:corruptionNewFloor(player)
            
            local effects = player:GetEffects()
            effects:RemoveCollectibleEffect(mod.ITEM.COLLECTIBLE.BOOK_OF_LEVIATHAN, -1)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, OnNewRoom)

local function creativeAISpecifically()
    local level = game:GetLevel()
    local currRoom = level:GetCurrentRoomDesc()
    local currIdx = level:GetCurrentRoomIndex()
    local firstVisit = currRoom.VisitedCount == 1
  
    if firstVisit and level:GetStartingRoomIndex() == currIdx then
        
    else
        return
    end

    for _, player in ipairs(mod:GetAllPlayers()) do
        mod:creativeAINewFloorCleanup(player)
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, CallbackPriority.IMPORTANT, creativeAISpecifically)

function mod:beahEvaluateFamiliars(player)
    mod:EvaluateApotheosis(player)

    --sun cross
    local source = Isaac.GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.SUN_CROSS)
    local spawnMe = player:CheckFamiliarEx(mod.ITEM.FAMILIAR.THE_SUN, mod.GetExpectedFamiliarNum(player, mod.ITEM.COLLECTIBLE.SUN_CROSS), 
        player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.SUN_CROSS), source, 0)
        for index, value in ipairs(spawnMe) do
            value:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        end
        
    local spawnMe = player:CheckFamiliarEx(mod.ITEM.FAMILIAR.THE_SUN, player:GetEffects():GetCollectibleEffectNum(mod.ITEM.COLLECTIBLE.SOLAR_TABLET), 
        player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.SUN_CROSS), source, 1)
        for index, value in ipairs(spawnMe) do
            value:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            value:GetSprite():GetLayer(2):SetColor(Color(1,0,0))
        end
        
    --[[for index, spawned in ipairs(spawnMe) do
      spawned:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    end]]

    --solar tablet
    --player:CheckFamiliar(mod.ITEM.FAMILIAR.THE_SUN, , 
       -- player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.SUN_CROSS), source, 1)
    --[[for index, spawned in ipairs(spawnMe) do
      spawned:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    end

    for i, v in ipairs(Isaac.FindByType(3, mod.ITEM.FAMILIAR.THE_SUN)) do
        if v:HasEntityFlags(EntityFlag.FLAG_APPEAR) then
            
            v:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        end
    end]]
end

-- items small enough to not need their own file
FiendFolio.AddItemPickupCallback(function(player)
    --Isaac.Spawn(1000, 76, 881, player.Position, Vector(0, 0), nil)
    game:RerollLevelCollectibles()

    game:ShakeScreen(45)
    game:Darken(1, 45)

    --[[--hacky solution to do the vfx
    local deffect = Isaac.Spawn(1000, 76, -1, player.Position, Vector(0, 0), nil)
    deffect.Visible = false
    deffect:Update()
    deffect:Remove()]]
end, nil, mod.ITEM.COLLECTIBLE.FORTUNE_TELLER)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, _, _, player, flags)
    if flags & UseFlag.USE_CARBATTERY ~= 0 then
        return
    end
    sfx:Play(mod.Sounds.ClownHornHonk, 1)
    player:UseCard(Card.CARD_FOOL, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
end, mod.ITEM.COLLECTIBLE.CLOWN_HORN)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function (_, _, rng, player)
    local c = FiendFolio.GetRandomObject(rng)
    local room = game:GetRoom()
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, c,
		room:FindFreePickupSpawnPosition(player.Position), Vector.Zero, player)
        return true
end, mod.ITEM.COLLECTIBLE.FIND_IT)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function (_, _, _, player)
    sfx:Play(SoundEffect.SOUND_ROTTEN_HEART, 1, 0, false, 1.0)
    local hearts = CustomHealthAPI.Library.GetHPOfKey(player, "RED_HEART")
    if hearts < 4 then
        return
    end
    player:AddHearts(-4)
    mod:AddMorbidHearts(player, 3)

    return true
end,mod.ITEM.COLLECTIBLE.KALUS_WICKED_PAW)

local forceList = {
    [53] = true,
    [712] = true,
}
mod:AddCollectibleCallback(ModCallbacks.MC_POST_OPEN_CHEST, mod.ITEM.COLLECTIBLE.KALUS_HARVESTED_NOSE, function (_, pickup, player)
    if player == nil then
        return
    end
    local e_data = mod:GetEntityData(pickup)
    if e_data.FF_kalucheck ~= nil and not forceList[pickup.Variant] then
        return
    end
    e_data.FF_kalucheck = true
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.KALUS_HARVESTED_NOSE) then
        local effects = player:GetEffects()
        effects:AddCollectibleEffect(mod.ITEM.COLLECTIBLE.KALUS_HARVESTED_NOSE)
    end
end)

local function rolandsBadEndMeal(player)
    for i = 1, 9, 1 do
        mod.scheduleForUpdate(function ()
            --sorry i stole you from Razor Penny. Forgive me please. Please. I'm sorry. I don't know how to code anything. Please.
				player:UseActiveItem(CollectibleType.COLLECTIBLE_DULL_RAZOR, UseFlag.USE_NOANIM, -1)
				player:BloodExplode()
                
				local rangle = math.random(360)
				for j=-6,6,2 do
					Isaac.Spawn(1000, 5, 0, player.Position, Vector(i+math.random(-1,1),0):Rotated(rangle), player)
				end
				for j=1,3 do
					Isaac.Spawn(1000, 5, 0, player.Position, RandomVector()*math.random(1,3), player)
				end
				local poof = Isaac.Spawn(1000, 2, 160, player.Position, Vector.Zero, player):ToEffect()
				poof:FollowParent(player)
        end, i*10)
    end
end
FiendFolio.AddItemPickupCallback(rolandsBadEndMeal, nil, mod.ITEM.COLLECTIBLE.ROLANDS_BAD_END_MEAL)

mod.LoadScripts({
    thisDirectory.."wickedbox",
    thisDirectory.."wispdump",
    thisDirectory.."kaluTransformation",

    i_.."electricdice",
    i_.."lourdeswater",
    i_.."deva",
    i_.."doubles",
    i_.."roomgenitems",
    i_.."eyeofprovidence",
    i_.."wnic",
    i_.."zeropointreactor",
    i_.."ganymede",
    i_.."hellfire",
    i_.."apotheosis",
    i_.."toybox",
    i_.."suncross",
    i_.."tefillin",
    i_.."towerofheaven",
    i_.."hotpotatobook",
    i_.."goldenwatch",
    i_.."disAcheron",
    i_.."airFreshener",
    i_.."activatedCharcoal",
    i_.."glitchcity",
    i_.."planchette",
    i_.."resurrection",
    i_.."shootyfamiliars",
    i_.."motorspirit",
    i_.."nagaviper",
    i_.."creationofman",
    i_.."techmodulo",
    i_.."devilsknife",
    i_.."edenshead",
    i_.."yaai",
    i_.."impbottlecap",
    i_.."crossnecklace",
    i_.."darkness",
    i_.."markofpain",
    i_.."bookofleviathan",
    i_.."scoutsbadge",
    i_.."earthofadam",
    i_.."magicBullet",
    i_.."swordOfFracturedMods",
    i_.."minesweeper",
    i_.."dstock",
    i_.."iceIX",
    i_.."palinsopia",
    i_.."kalusHeart",
    i_.."kalustail",

    t_.."vicodin",
    t_.."runiccube",
    t_.."poppet",
    t_.."owlfeather",
    t_.."zzzzzzmagnet",
    t_.."powerinverter",
    t_.."pennys",
    t_.."kalusclaw",
    t_.."kalustongue",

    g_.."sacredSoil",
    g_.."ancientEffigy",

    c_.."creativeai",
    c_.."neighboursFromHell",
    c_.."corruption",
    c_.."blasphemy",

    thisDirectory.."ignore this/bytheprickingofmythumb.lua"
})