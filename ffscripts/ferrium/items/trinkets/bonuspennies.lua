local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

local bal = {
    WackyFound = 20,

    BentChance = {25, 25}, --Base + trinketmult

    TrollChance = {0.5, 25}, --Subtractive, Gold troll
    BombStagger = 4,

    AirbagForce = 20,

    MicroChance = 0.15, --Additive * mult
    MicroDecrease = 0.9,

    MapChance = 0.66, --Subtractive
    MapInc = 3,

    PrettyChance = 0.33, --Additive * mult

    FacebookChance = 0.15, --Additive * mult

    CharitableChance = {25, 25}, --Base, additive * mult

    DeviousChance = {0.25, 0.25}, --Base, additive * mult
    DeviousLoot = {{"Immoral", 10}, {"Spicy", 20}, {"Copper", 35}, {"Cursed", 35}},

    PoopChance = {0.25, 0.25}, --Base, additive * mult
    PoopTypes = {{0, 50}, --Standard
        {1, 50}, --Red
        {2, 45}, --Corn
        {3, 10}, --Gold
        {4, 30}, --Rainbow
        {5, 40}, --Black
        {6, 30}, --Holy
        {12, 40}, --Stone
        {13, 40}, --Flaming
        {14, 40}, --Stinky
        {666, 40}, --Drop
        {667, 30}, --Cursed
        {668, 40}, --Bee
        {669, 15}, --Platinum
        {670, 30}, --Spider
        {671, 30}, --Evil
        --{672, 1}, --Dad
        {673, 45}, --Fuzzy
        {674, 30}, --Trash
    },

    AlphaChance = 0.2, --Additive * mult

    RedChance = {0.15, 0.10}, --Base, additive * mult
    RedChance2 = {0.03, 0.05}, --Base, additive * mult, lesser if you're already in a red room

    PuckSpeed = 20,

    PrismChance = {0.25, 0.25}, --Base, additive * mult

    BerryChance = {0.25, 0.25}, --Base, additive * mult

    CalciumChance = {0.2, 0.2}, --Base, additive * mult

    DogChance = {0.5, 0.85}, --Subtractive, subtractive

    HoneyedChance = {0.25, 0.25},--Base, additive * mult

    BrazilianChance = {0.5, 0.25}, --base, additive*mult
    BrazilianTimeout = 200,
}

mod.BonusPennyWeights = {
    {mod.ITEM.TRINKET.BENT_PENNY, 100},
    {mod.ITEM.TRINKET.TROLL_PENNY, 20},
    {mod.ITEM.TRINKET.AIRBAG_PENNY, 5},
    {mod.ITEM.TRINKET.MICRO_PENNY, 50},
    {mod.ITEM.TRINKET.MAP_PENNY, 100},
    {mod.ITEM.TRINKET.PRETTY_PENNY, 100},
    {mod.ITEM.TRINKET.FACEBOOK_PENNY, 33},
    {mod.ITEM.TRINKET.CHARITABLE_PENNY, 100},
    {mod.ITEM.TRINKET.DEVIOUS_PENNY, 100},
    {mod.ITEM.TRINKET.SWITCH_PENNY, 20},
    {mod.ITEM.TRINKET.POOP_PENNY, 100},
    {mod.ITEM.TRINKET.SLIPPERY_PENNY, 20},
    {mod.ITEM.TRINKET.CANADIAN_PENNY, 50},
    {mod.ITEM.TRINKET.ALPHA_PENNY, 100},
    {mod.ITEM.TRINKET.STONE_PENNY, 50},
    {mod.ITEM.TRINKET.RED_PENNY, 100},
    {mod.ITEM.TRINKET.PUCK_PENNY, 33},
    {mod.ITEM.TRINKET.PRISM_PENNY, 100},
    {mod.ITEM.TRINKET.BERRY_PENNY, 100},
    {mod.ITEM.TRINKET.CALCIUM_PENNY, 100},
    {mod.ITEM.TRINKET.DOG_PENNY, 20},
    {mod.ITEM.TRINKET.DADS_LOST_PENNY, 50},
    {mod.ITEM.TRINKET.LOADED_PENNY, 100},
    {mod.ITEM.TRINKET.SUNDIAL_PENNY, 100},
    {mod.ITEM.TRINKET.BRAZILIAN_PENNY, 33},
}

local function tryGildTrinket(id, rng)
	if Isaac.GetPersistentGameData():Unlocked(Achievement.GOLDEN_TRINKETS) and rng:RandomFloat() < 0.02 then
		return id | TrinketType.TRINKET_GOLDEN_FLAG
	end

	return id
end

function mod:GetPennyTrinketIncludingFunnies(rng)
    local sub
    if rng:RandomInt(100) < bal.WackyFound then --I know this doesn't abide by item pool rules but ughghhh
        sub = tryGildTrinket(mod:weightedRNG(mod.BonusPennyWeights, rng), rng)
    else
        sub = mod.GetItemFromCustomItemPool(mod.CustomPool.PENNY_TRINKETS, rng)
    end
    return sub
end

function mod:FerriumPennyPickup(player, pickup, value, trueValue, data)
    mod:BentPennyPickup(player, pickup, value, trueValue)
    mod:TrollfacePennyPickup(player, pickup, value)
    mod:AirbagPennyPickup(player, pickup, value)
    mod:MicroPennyPickup(player, pickup, value)
    mod:MapPennyPickup(player, pickup, value)
    mod:PrettyPennyPickup(player, pickup, value)
    mod:FacebookPennyPickup(player, pickup, value)
    mod:CharitablePennyPickup(player, pickup, value, trueValue)
    mod:DeviousPennyPickup(player, pickup, value)
    mod:SwitchPennyPickup(player, pickup, value)
    mod:PoopPennyPickup(player, pickup, value)
    mod:SlipperyPennyPickup(player, pickup, value)
    mod:CanadianPennyPickup(player, pickup, value, trueValue)
    mod:AlphaPennyPickup(player, pickup, value)
    mod:StonePennyPickup(player, pickup, value)
    mod:RedPennyPickup(player, pickup, value)
    mod:PrismPennyPickup(player, pickup, value)
    mod:BerryPennyPickup(player, pickup, value)
    mod:CalciumPennyPickup(player, pickup, value)
    mod:DogPennyPickup(player, pickup, value, data)
    mod:HoneyedPennyPickup(player, pickup, value, data)
    mod:DadsLostPennyPickup(player, data)
    mod:LoadedPennyPickup(player, pickup, value, trueValue, data)
    mod:SundialPennyPickup(player, pickup, value, trueValue, data)
    mod:SuicidalPennyPickup(player)
    mod:BrazilianPennyPickup(player, value)
end

function mod:BonusPenniesNewRoom(player, data, room)
    if data.ffsavedata.RunEffects then
        if data.ffsavedata.RunEffects.DadsLostPennyStacks then
            data.ffsavedata.RunEffects.DadsLostPennyStacks = 0
            player:AddCacheFlags(CacheFlag.CACHE_RANGE | CacheFlag.CACHE_LUCK)
            player:EvaluateItems()
        end
    end
end

function mod:BentPennyPickup(player, pickup, value, trueValue)
	if player:HasTrinket(mod.ITEM.TRINKET.BENT_PENNY) then
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.BENT_PENNY)
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.BENT_PENNY)
        local chance = bal.BentChance[1]+(bal.BentChance[2]*mult)
        local roll = rng:RandomInt(100)

        if trueValue then
            value = trueValue
        end

        if roll < chance then
            player:AddCoins(value)
        else
            --[[local val = player:GetNumCoins()
            local max = (player:HasCollectible(CollectibleType.COLLECTIBLE_DEEP_POCKETS) and 999) or 99]]
            player:AddCoins(-value)
        end
	end
end

function mod:TrollfacePennyPickup(player, pickup, value)
	if player:HasTrinket(mod.ITEM.TRINKET.TROLL_PENNY) then
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.TROLL_PENNY)
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.TROLL_PENNY)
        local chance = (1 - bal.TrollChance[1]^value)*100
        local chance2 = bal.TrollChance[2]
        local roll = rng:RandomInt(100)
        if roll < chance then
            local results = mod:findCharredBombSpot(player, rng, mult)
            local spawn = 0
            for _,pos in ipairs(results) do
                spawn = spawn+1
                mod.scheduleForUpdate(function()
                    if (pickup.SubType == CoinSubType.COIN_GOLDEN or pickup.SubType == mod.PICKUP.COIN.GOLDENCURSED) and rng:RandomInt(100) < chance2 then
                        local trol = Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_GOLDENTROLL, 0, pos, Vector.Zero, player):ToBomb()
                    else
                        local trol = Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_TROLL, 0, pos, Vector.Zero, player):ToBomb()
                        trol:AddTearFlags(player:GetBombFlags())
                    end
                end, bal.BombStagger*spawn)
            end
        end
	end
end

function mod:AirbagPennyPickup(player, pickup, value)
    if player:HasTrinket(mod.ITEM.TRINKET.AIRBAG_PENNY) then
        player.Velocity = (player.Position-pickup.Position):Resized(bal.AirbagForce)
        sfx:Play(SoundEffect.SOUND_JELLY_BOUNCE, 1, 0, false, 1.5)
    end
end

function mod:MicroPennyPickup(player, pickup, value)
	if player:HasTrinket(mod.ITEM.TRINKET.MICRO_PENNY) then
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.MICRO_PENNY)
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.MICRO_PENNY)
        local chance = (1-(1-bal.MicroChance*mult)^value)*100
        local roll = rng:RandomInt(100)
        if roll < chance then
            local d = mod:GetEntityData(player)
            local data = d.ffsavedata
            data.MicroPennySizeReduction = data.MicroPennySizeReduction or 1
            data.MicroPennySizeReduction = data.MicroPennySizeReduction*bal.MicroDecrease
            data.MicroPennySizeReduction = math.max(0.1,data.MicroPennySizeReduction)
            player:AddCacheFlags(CacheFlag.CACHE_SIZE, true)
        end
	end
end

function mod:MapPennyPickup(player, pickup, value)
    if player:HasTrinket(mod.ITEM.TRINKET.MAP_PENNY) then
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.MAP_PENNY)
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.MAP_PENNY)
        local chance = (1 - bal.MapChance^value)*100
        local roll = rng:RandomInt(100)
        if roll < chance then
            local level = game:GetLevel()
            local num = math.ceil(value/bal.MapInc)*mult
            local potentials = {}
            local roomList = level:GetRooms()
            for i=1,roomList.Size do
                local room = roomList:Get(i-1)
                if room and room.DisplayFlags == 0 then
                    table.insert(potentials, i-1)
                end
            end
            if #potentials > 0 then
                local results = mod:getSeveralDifferentNumbers(math.min(num, #potentials), #potentials, rng)
                for i=1,#results do
                    local room = roomList:Get(potentials[results[i]])
                    room.DisplayFlags = room.DisplayFlags | 5
                end
                level:UpdateVisibility()
            end
        end
    end
end

function mod:PrettyPennyPickup(player, pickup, value)
	if player:HasTrinket(mod.ITEM.TRINKET.PRETTY_PENNY) then
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.PRETTY_PENNY)
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.PRETTY_PENNY)
        local chance = (1-(1-bal.PrettyChance*mult)^value)*100

        local roll = rng:RandomInt(100)
        if roll < chance then
            local variant = mod.ITEM.FAMILIAR.FAIRY_FLY_1
            --Nah, don't want to tread on the rock's toes too much
            --[[if value >= 10 then
                variant = mod.ITEM.FAMILIAR.FAIRY_FLY_3
            elseif value >= 5 then
                variant = mod.ITEM.FAMILIAR.FAIRY_FLY_2
            end]]
            local fairy = Isaac.Spawn(3, variant, 0, player.Position, Vector.Zero, player)
        end
	end
end

function mod:FacebookPennyPickup(player, pickup, value)
	if player:HasTrinket(mod.ITEM.TRINKET.FACEBOOK_PENNY) then
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.FACEBOOK_PENNY)
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.FACEBOOK_PENNY)
        local chance = (1-(1-bal.FacebookChance*mult)^value)*100

        local roll = rng:RandomInt(100)
        if roll < chance then
            player:UseActiveItem(CollectibleType.COLLECTIBLE_MONSTER_MANUAL, UseFlag.USE_NOANIM)
        end
	end
end

function mod:CharitablePennyPickup(player, pickup, value, trueValue)
    if player:HasTrinket(mod.ITEM.TRINKET.CHARITABLE_PENNY) then
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.CHARITABLE_PENNY)
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.CHARITABLE_PENNY)
        local chance = bal.CharitableChance[1]+(bal.CharitableChance[2]*mult)
        local roll = rng:RandomInt(100)
        if roll < chance then
            if trueValue then
                value = trueValue
            end
            local found
            local d = Isaac.GetPersistentGameData()
            local counter = EventCounter.DONATION_MACHINE_COUNTER
            if game:IsGreedMode() then
                counter = EventCounter.GREED_DONATION_MACHINE_COUNTER
            end
            local max = 999-d:GetEventCounter(counter)
            local inc = math.min(max, value)
            if inc < 0 and d:GetEventCounter(counter) < value then
                inc = -d:GetEventCounter(counter)
            end

            if game:IsGreedMode() then
                for _,slot in ipairs(Isaac.FindByType(EntityType.ENTITY_SLOT, SlotVariant.GREED_DONATION_MACHINE, 0, false, false)) do
                    if not found then
                        local don = slot:ToSlot()
                        local s = don:GetSprite()
                        if s:GetAnimation() == "Prize" and (s:GetOverlayAnimation() ~= "CoinInsert" or s:IsOverlayFinished("CoinInsert")) then
                            don:SetState(2)
                            s:PlayOverlay("CoinInsert", true)
                            found = true
                            inc = math.max(0, inc-1)
                        end
                    end
                end
            else
                for _,slot in ipairs(Isaac.FindByType(EntityType.ENTITY_SLOT, SlotVariant.DONATION_MACHINE, 0, false, false)) do
                    if not found then
                        local don = slot:ToSlot()
                        local s = don:GetSprite()
                        if s:GetAnimation() == "Prize" and (s:GetOverlayAnimation() ~= "CoinInsert" or s:IsOverlayFinished("CoinInsert")) then
                            don:SetState(2)
                            s:PlayOverlay("CoinInsert", true)
                            found = true
                            inc = math.max(0, inc-1)
                        end
                    end
                end
            end
            if inc > 0 then
                d:IncreaseEventCounter(counter, inc)
            end
        end
	end
end

function mod:DeviousPennyPickup(player, pickup, value)
    if player:HasTrinket(mod.ITEM.TRINKET.DEVIOUS_PENNY) and pickup.SubType ~= mod.PICKUP.COIN.CURSED then --So it doesn't infinite loop
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.DEVIOUS_PENNY)
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.DEVIOUS_PENNY)
        local chance = (1-(1-(bal.DeviousChance[1]+(bal.DeviousChance[2]*mult)))^value)*100
        local roll = rng:RandomInt(100)
        if roll < chance then
            local result = mod:weightedRNG(bal.DeviousLoot, rng)
            local pos = game:GetRoom():FindFreePickupSpawnPosition(player.Position, 40, false, false)
            if result == "Immoral" then
                if mod.ACHIEVEMENT.IMMORAL_HEART:IsUnlocked() then
                    Isaac.Spawn(5, mod.PICKUP.VARIANT.IMMORAL_HEART, 0, pos, Vector.Zero, player)
                else
                    Isaac.Spawn(5, 20, mod.PICKUP.COIN.CURSED, pos, Vector.Zero, player)
                end
            elseif result == "Spicy" then
                Isaac.Spawn(5, 30, mod.PICKUP.KEY.SPICY_PERM, pos, Vector.Zero, player)
            elseif result == "Copper" then
                Isaac.Spawn(5, 40, mod.PICKUP.BOMB.COPPER, pos, Vector.Zero, player)
            elseif result == "Cursed" then
                Isaac.Spawn(5, 20, mod.PICKUP.COIN.CURSED, pos, Vector.Zero, player)
            end
        end
	end
end

function mod:SwitchPennyPickup(player, pickup, value)
    if player:HasTrinket(mod.ITEM.TRINKET.SWITCH_PENNY) then
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.SWITCH_PENNY)
        for i=1,mult do
            player:UseActiveItem(mod.ITEM.COLLECTIBLE.AVGM)
        end
    end
end

function mod:PoopPennyPickup(player, pickup, value)
    if player:HasTrinket(mod.ITEM.TRINKET.POOP_PENNY) then
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.POOP_PENNY)
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.POOP_PENNY)
        local chance = (1-(1-(bal.PoopChance[1]+(bal.PoopChance[2]*mult)))^value)*100
        if rng:RandomInt(100) < chance then
            local room = game:GetRoom()
            for i=1,mult do
                local var = mod:weightedRNG(bal.PoopTypes, rng)
                player:ThrowFriendlyDip(var, pickup.Position, room:FindFreePickupSpawnPosition(player.Position, 40, true))
                if var == 668 then
                    for j=1,2 do
                        player:ThrowFriendlyDip(var, pickup.Position, room:FindFreePickupSpawnPosition(player.Position, 40, true))
                    end
                end
            end
            sfx:Play(SoundEffect.SOUND_PLOP, 1, 0, false, mod:RandomInt(90,110,rng)/100)
            local poof = Isaac.Spawn(1000, 2, 114, player.Position, Vector.Zero, player):ToEffect()
            poof.Color = Color(0,0,0,1,55 / 255,35 / 255,30 / 255)
        end
    end
end

function mod:SlipperyPennyPickup(player, pickup, value)
    if player:HasTrinket(mod.ITEM.TRINKET.SLIPPERY_PENNY) then
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.SLIPPERY_PENNY)
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.SLIPPERY_PENNY)
        for i=1,mult do
            local keys = player:GetNumKeys()
            local bombs = player:GetNumBombs()
            local droppedBomb = false
            local droppedKey = false
            if bombs > 0 and keys > 0 then
                if rng:RandomInt(2) == 0 then
                    player:AddBombs(-1)
                    droppedBomb = true
                else
                    player:AddKeys(-1)
                    droppedKey = true
                end
            elseif bombs > 0 then
                player:AddBombs(-1)
                droppedBomb = true
            elseif keys > 0 then
                player:AddKeys(-1)
                droppedKey = true
            end
            if droppedKey == true then
                Isaac.Spawn(5, 30, 0, player.Position, Vector(0,rng:RandomInt(5)+3):Rotated(rng:RandomInt(360)), player)
            elseif droppedBomb == true then
                Isaac.Spawn(5, 40, 0, player.Position, Vector(0,rng:RandomInt(5)+3):Rotated(rng:RandomInt(360)), player)
            end
        end
    end
end

function mod:CanadianPennyPickup(player, pickup, value, trueValue)
    if player:HasTrinket(mod.ITEM.TRINKET.CANADIAN_PENNY) then
        if trueValue then
            value = trueValue
        end
        local newValue = mod.CanadianExchangeRate * value

        -- Add / remove the whole pennies
        local whole = math.floor(newValue - value)

        if whole ~= 0 then
            player:AddCoins(whole)
        end

        -- Add the fractional pennies
        local fractions = newValue % 1

        if fractions ~= 0 then
            mod:AddFractionalCoins(fractions)
        end
    end
end

function mod:AlphaPennyPickup(player, pickup, value)
	if player:HasTrinket(mod.ITEM.TRINKET.ALPHA_PENNY) then
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.ALPHA_PENNY)
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.ALPHA_PENNY)
        local chance = (1-(1-bal.AlphaChance*mult)^value)*100

        local roll = rng:RandomInt(100)
        if roll < chance then
            player:UseActiveItem(mod.ITEM.COLLECTIBLE.ALPHA_COIN, UseFlag.USE_NOANIM)
        end
	end
end

function mod:StonePennyPickup(player, pickup, value)
    if player:HasTrinket(mod.ITEM.TRINKET.STONE_PENNY) then
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.STONE_PENNY)
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.STONE_PENNY)

        local num = value+(mult-1)
        local grids = {}
        for _,grid in ipairs(mod.GetGridEntities()) do
            if grid.CollisionClass == GridCollisionClass.COLLISION_OBJECT or grid.CollisionClass == GridCollisionClass.COLLISION_SOLID then
                table.insert(grids, grid)
            end
        end
        local results = mod:getSeveralDifferentNumbers(math.min(num, #grids), #grids, rng)
        for _,id in ipairs(results) do
            grids[id]:Destroy()
        end
	end
end

function mod:RedPennyPickup(player, pickup, value)
    if player:HasTrinket(mod.ITEM.TRINKET.RED_PENNY) then
        local level = game:GetLevel()
        local roomIndex = level:GetCurrentRoomIndex()
        local validSlots = {}

        for slot = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
            if level:CanSpawnDoorOutline(roomIndex, slot) then
                table.insert(validSlots, slot)
            end
        end

        if #validSlots > 0 then
            local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.RED_PENNY)
            local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.RED_PENNY)
            local chance
            if level:GetCurrentRoomDesc().Flags == level:GetCurrentRoomDesc().Flags | RoomDescriptor.FLAG_RED_ROOM then
                chance = (1-(1-(bal.RedChance2[1]+(bal.RedChance2[2]*mult)))^value)*100
            else
                chance = (1-(1-(bal.RedChance[1]+(bal.RedChance[2]*mult)))^value)*100
            end

            if rng:RandomInt(100) < chance then
                local makeSound
                --local amount = math.min(mult, #validSlots)
                local amount = 1
                local results = mod:getSeveralDifferentNumbers(amount, #validSlots, rng)

                for _, result in ipairs(results) do
                    if level:MakeRedRoomDoor(roomIndex, validSlots[result]) then
                        makeSound = true
                    end
                end

                if makeSound then
                    sfx:Play(SoundEffect.SOUND_GOLDENKEY, 1, 0, false, 1)
                end
            end
        end
    end
end

mod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.EARLY, function(_, pickup, opp, low)
	if opp:ToPlayer() then
		local player = opp:ToPlayer()
		if player:HasTrinket(mod.ITEM.TRINKET.PUCK_PENNY) and mod:IsActiveRoom() then
            local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.PUCK_PENNY)
			pickup.Velocity = ((pickup.Position-player.Position)+player.Velocity):Resized(bal.PuckSpeed)
			mod:GetEntityData(pickup).puckLaunched = true
			mod:GetEntityData(pickup).puckSpeed = bal.PuckSpeed
			mod:GetEntityData(pickup).puckDamage = player.Damage*mult
			sfx:Play(SoundEffect.SOUND_BONE_BOUNCE, 1, 0, false, 1)
			Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, opp, low)
            return true
        end
    end
end, 20)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	local data = mod:GetEntityData(pickup)

	if data.puckLaunched then
		if data.puckSpeed < 5 then
			data.puckSpeed = nil
			data.puckLaunched = nil
			data.puckCooldown = nil
		else
			pickup.Velocity = pickup.Velocity:Resized(data.puckSpeed)
			data.puckSpeed = data.puckSpeed*0.95
			local rng = pickup:GetDropRNG()
			local enemies = {}
			for _,entity in ipairs(Isaac.FindInRadius(pickup.Position, 40, EntityPartition.ENEMY)) do
				if entity:IsActiveEnemy() and not mod:isFriend(entity) then
					table.insert(enemies, entity)
				end
			end
			if #enemies > 0 then
				local npc = enemies[rng:RandomInt(#enemies)+1]
				if not data.puckCooldown then
					npc:TakeDamage(data.puckDamage, 0, EntityRef(pickup), 0)
					data.puckCooldown = 3
				end
				sfx:Play(SoundEffect.SOUND_BONE_BOUNCE, 0.8, 0, false, 1)
				pickup.Velocity = (pickup.Position-npc.Position):Resized(data.puckSpeed)
			end

			if pickup:CollidesWithGrid() then
				sfx:Play(SoundEffect.SOUND_BONE_BOUNCE, 0.8, 0, false, 1)
			end
			if data.puckCooldown then
				if data.puckCooldown > 0 then
					data.puckCooldown = data.puckCooldown-1
				else
					data.puckCooldown = nil
				end
			end
		end
	end
end, 20)

function mod:PrismPennyPickup(player, pickup, value)
    if player:HasTrinket(mod.ITEM.TRINKET.PRISM_PENNY) then
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.PRISM_PENNY)
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.PRISM_PENNY)
        local chance = (1-(1-(bal.PrismChance[1]+(bal.PrismChance[2]*mult)))^value)*100
        local roll = rng:RandomInt(100)
        if roll < chance then
            local pos = game:GetRoom():FindFreePickupSpawnPosition(player.Position, 40, false, false)
            local subt = rng:RandomInt(6)
            if subt == 3 then
                if rng:RandomInt(2) == 0 then
                    subt = rng:RandomInt(6) --I know this means it can roll rainbow again but it still makes it rarer
                end
            end
            Isaac.Spawn(5, mod.PICKUP.VARIANT.PRISM_SHARD, subt, pos, Vector.Zero, player)
        end
    end
end

function mod:BerryPennyPickup(player, pickup, value)
    if player:HasTrinket(mod.ITEM.TRINKET.BERRY_PENNY) then
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.BERRY_PENNY)
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.BERRY_PENNY)
        local chance = (1-(1-(bal.BerryChance[1]+(bal.BerryChance[2]*mult)))^value)*100
        local roll = rng:RandomInt(100)
        if roll < chance then
            local pos = game:GetRoom():FindFreePickupSpawnPosition(player.Position, 40, false, false)
            Isaac.Spawn(5, mod.PICKUP.VARIANT.SWEET_RED_BERRY, 0, pos, Vector.Zero, player)
        end
    end
end

function mod:CalciumPennyPickup(player, pickup, value)
    if player:HasTrinket(mod.ITEM.TRINKET.CALCIUM_PENNY) then
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.CALCIUM_PENNY)
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.CALCIUM_PENNY)
        for i=1,2+mult do
            local bone = Isaac.Spawn(3, 234, 0, pickup.Position, Vector(0,3):Rotated(rng:RandomInt(360)), player):ToFamiliar()
            bone.Player = player
            bone:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        end
        sfx:Play(SoundEffect.SOUND_BONE_SNAP, 0.6, 0, false, 1)

        local chance = (1-(1-(bal.CalciumChance[1]+(bal.CalciumChance[2]*mult)))^value)*100
        if rng:RandomInt(100) < chance then
            local borbital = Isaac.Spawn(3, FamiliarVariant.BONE_ORBITAL, 0, pickup.Position, Vector.Zero, player):ToFamiliar()
            borbital.Player = player
        end
    end
end

function mod:DogPennyPickup(player, pickup, value, data)
	if player:HasTrinket(mod.ITEM.TRINKET.DOG_PENNY) then
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.DOG_PENNY)
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.DOG_PENNY)
        local chance = (1 - bal.DogChance[1]^value)*100
        local chance2 = (1 - bal.DogChance[2]^value)*100
        local roll = rng:RandomInt(100)
        if roll < chance then
            sfx:Play(SoundEffect.SOUND_DOG_HOWELL, 1, 40, false, 1)
            Isaac.Spawn(mod.FF.MaxFossilGhost.ID, mod.FF.MaxFossilGhost.Var, mod.FF.MaxFossilGhost.Sub, player.Position, Vector.Zero, player)
        end
        if roll < chance2 then
            if not data.ffsavedata.RunEffects.storedDogsHowls then
                data.ffsavedata.RunEffects.storedDogsHowls = 0
            end
            data.ffsavedata.RunEffects.storedDogsHowls = data.ffsavedata.RunEffects.storedDogsHowls+mult
        end
	end
end

function mod:DogPennyTrinketUpdate(trinket)
    if mod:GetRealTrinketId(trinket.SubType) == mod.ITEM.TRINKET.DOG_PENNY then
        local sprite = trinket:GetSprite()
        if sprite:GetFilename() == "gfx/005.350_Trinket.anm2" then
            local anim = sprite:GetAnimation()
            sprite:Load("gfx/items/trinkets/bonuspennies/trinket_dog_penny.anm2", true)
            sprite:Play(anim, true)
            sprite:Update()
        end
    end
end

function mod:HoneyedPennyPickup(player, pickup, value, data)
    if player:HasTrinket(mod.ITEM.TRINKET.HONEYED_PENNY) then
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.HONEYED_PENNY)
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.HONEYED_PENNY)
        local chance = (1-(1-(bal.HoneyedChance[1]+(bal.HoneyedChance[2]*mult)))^value)*100
        local roll = rng:RandomInt(100)
        if roll < chance then
            sfx:Play(SoundEffect.SOUND_ANIMAL_SQUISH, 1.3, 0, false, 1)
            data.HoneyPenny = true
			data.HoneyPennyTimer = 480
        end
    end
end

function mod:DadsLostPennyPickup(player, data)
    if player:HasTrinket(mod.ITEM.TRINKET.DADS_LOST_PENNY) then
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.DADS_LOST_PENNY)
        player:AnimateHappy()
        if data.ffsavedata.RunEffects then
            data.ffsavedata.RunEffects.DadsLostPennyStacks = (data.ffsavedata.RunEffects.DadsLostPennyStacks or 0)+mult
        end
        player:AddCacheFlags(CacheFlag.CACHE_RANGE | CacheFlag.CACHE_LUCK)
        player:EvaluateItems()
    end
end

function mod:LoadedPennyPickup(player, pickup, value, trueValue, d)
    if player:HasTrinket(mod.ITEM.TRINKET.LOADED_PENNY) then
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.LOADED_PENNY)
        d.ffsavedata.RunEffects.GuaranteedCrits = math.max(0, (d.ffsavedata.RunEffects.GuaranteedCrits or 0)+trueValue+(mult-1))
    end
end

function mod:BrazilianPennyPickup(player, value)
    if player:HasTrinket(mod.ITEM.TRINKET.BRAZILIAN_PENNY) then
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.BRAZILIAN_PENNY)
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.BRAZILIAN_PENNY)
        local chance = (1-(1-(bal.BrazilianChance[1]+(bal.BrazilianChance[2]*mult)))^value)*100
        local roll = rng:RandomInt(100)
        if roll < chance then
            local room = game:GetRoom()
            for i=0,2 do
                mod.scheduleForUpdate(function()
                    local pos = mod:FindRandomFreePos(player, 400)
                    local ball = Isaac.Spawn(915, 1, mod.FF.RockBallFootball.Sub + 5, pos, Vector.Zero, player)
                    ball.Parent = player
                    ball.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                    ball:GetData().TemporaryFootball = bal.BrazilianTimeout
                    ball:Update()
                end, i*8)
            end
        end
    end
end

-- catinsurance was here....
function mod:SundialPennyPickup(player, pickup, value, trueValue, d)
    if player:HasTrinket(mod.ITEM.TRINKET.SUNDIAL_PENNY) then
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.SUNDIAL_PENNY)
        local seconds = 1 + mult
        local sub = value * seconds * 30
        game.TimeCounter = math.max(game.TimeCounter - sub, 1)
    end
end

function mod:SuicidalPennyPickup(player)
    local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.SUICIDAL_PENNY)
    if mult >= 2 then
        Isaac.ExecuteCommand("")
    elseif mult >= 1 then
        mod:explodePlayer(player)
    end
end