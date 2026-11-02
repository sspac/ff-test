local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

--I didn't realize how tedious this is good god

local chestChances = {{"Item", 11}, {"Pickups", 56}, {"Trinket", 10}, {"Card", 10}, {"Battery", 11}, {"Chest", 2}}
local batteryChances = {{BatterySubType.BATTERY_NORMAL, 40}, {BatterySubType.BATTERY_MICRO, 40}, {BatterySubType.BATTERY_MEGA, 5}, {BatterySubType.BATTERY_GOLDEN, 5}, {-1, 25}}
-- -1 is storage battery

local pickupChances = {{"Coins", 35}, {"Hearts", 20}, {"Keys", 15}, {"Bombs", 30}}
local daemonChances = {{"Coins", 41.6}, {"Hearts", 4.7}, {"Keys", 18}, {"Bombs", 35.7}}

local function GetDadsBatteryData(player, itemID, slot)
	if itemID == 0 then return end
	local data = mod:GetEntityData(player)
	if not data.ffDadsBattery then
		data.ffDadsBattery = {}
	end
	if not data.ffDadsBattery[itemID] then
		data.ffDadsBattery[itemID] = {}
	end
	if not data.ffDadsBattery[itemID][slot] then
		data.ffDadsBattery[itemID][slot] = {}
	end
	return data.ffDadsBattery[itemID][slot]
end

--Some code borrowed from Dire/Glass Chest
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, chest)
	chest = chest:ToPickup()
	local sprite = chest:GetSprite()
	local chestseed = tostring(chest.InitSeed)
    local d = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'ChestData', chestseed, {})
	local gd = mod:GetEntityData(chest)

	chest.Velocity = chest.Velocity * 0.8
	if not d.init then
		if gd.Opened then return end
		sprite:Play("Appear", true)
		d.Charges = 0
        gd.State = "Appear"
        mod:GenerateEngineChestContent(chest, d)
		d.init = true
		gd.init = true
	elseif not gd.init then
		if chest.SubType == 1 then
			chest:Remove()
		else
			sprite:Play("Idle_0" .. d.Charges+1, true)
		end
        gd.State = "Idle"
		gd.init = true
	end

    if gd.State == "Appear" then
        if sprite:IsEventTriggered("DropSound") then
            sfx:Play(SoundEffect.SOUND_CHEST_DROP, 1, 0, false, 0.9)
        end
        if sprite:IsFinished("Appear") then
            sprite:Play("Idle_01", true)
            gd.State = "Idle"
        end
    elseif gd.State == "Idle" then
    elseif gd.State == "Pip" then
        if sprite:IsFinished("Pip_01") then
            sprite:Play("Idle_02", true)
            gd.State = "Idle"
        end
        if sprite:IsFinished("Pip_02") then
            sprite:Play("Idle_03", true)
            gd.State = "Idle"
        end
    elseif gd.State == "Opening" then
        if sprite:IsFinished("Open") then
            sprite:Play("Opened", true)
        end
    end

    if gd.State == "Idle" and mod.anyPlayerHas(CollectibleType.COLLECTIBLE_GUPPYS_EYE) then
        local dist = Game():GetNearestPlayer(chest.Position).Position:Distance(chest.Position)
        gd.Alpha = gd.Alpha or 0
        gd.Alpha = mod:Lerp(gd.Alpha, 0.8, 0.1)
    else
        gd.Alpha = 0
    end
end, mod.PICKUP.VARIANT.ENGINE_CHEST)

function mod:GenerateEngineChestContent(chest, d)
    d.drops = {}
    local rng = chest:GetDropRNG()

    local types
    if game:GetLevel():GetAbsoluteStage() == LevelStage.STAGE6 then
        types = "Item2"
    else
        types = mod:weightedRNG(chestChances, rng)
    end

    local chipMult = 1
    if mod.anyPlayerHas(TrinketType.TRINKET_POKER_CHIP, true) then
        if rng:RandomInt(2) == 0 then
            chipMult = 2
        else
            chipMult = 0
        end
    end

    if types == "Item" then
        table.insert(d.drops, {Type = "Item", ID = mod.GetItemFromCustomItemPool(mod.CustomPool.ENGINE_CHEST, rng)})
    elseif types == "Item2" then --For the Chest/Dark Room
        local item = game:GetItemPool():GetCollectible(ItemPoolType.POOL_TREASURE, true, chest.InitSeed, CollectibleType.COLLECTIBLE_9_VOLT)
        table.insert(d.drops, {Type = "Item", ID = item})
    elseif types == "Trinket" then
        if chipMult == 0 then
            table.insert(d.drops, {Type = "Monster", ID = EntityType.ENTITY_ATTACKFLY, Anm2 = "018.000_attack fly", Animation = "Fly"})
        else
            for i=1,chipMult do
                local trinket = game:GetItemPool():GetTrinket(false)
                table.insert(d.drops, {Type = "Trinket", ID = trinket})
            end
        end
    elseif types == "Battery" then
        if chipMult == 0 then
            table.insert(d.drops, {Type = "Monster", ID = EntityType.ENTITY_ATTACKFLY, Anm2 = "018.000_attack fly", Animation = "Fly"})
        else
            local tempTab = mod:makeCopiedTable(batteryChances)
            if not Isaac.GetPersistentGameData():Unlocked(Achievement.GOLDEN_BATTERIES) then
                tempTab = {{BatterySubType.BATTERY_NORMAL, 40}, {BatterySubType.BATTERY_MICRO, 40}, {BatterySubType.BATTERY_MEGA, 10}, {-1, 25}}
            end
            for i=1,chipMult do
                local amount = mod:RandomInt(2, 3, rng)
                for j=1,amount do
                    local sub = mod:weightedRNG(tempTab, rng)
                    local anim
                    if sub == -1 then
                        sub = mod.ITEM.CARD.STORAGE_BATTERY_0+rng:RandomInt(3)+1
                        anim = "pick ups/storage_battery"
                        table.insert(d.drops, {Type = "BatteryCard", ID = sub, Anm2 = anim})
                    else
                        if sub == BatterySubType.BATTERY_NORMAL then
                            anim = "005.090_littlebattery"
                        elseif sub == BatterySubType.BATTERY_MICRO then
                            anim = "005.090_microbattery"
                        elseif sub == BatterySubType.BATTERY_MEGA then
                            anim = "005.090_megabattery"
                        elseif sub == BatterySubType.BATTERY_GOLDEN then
                            anim = "005.090_golden battery"
                        end
                        table.insert(d.drops, {Type = "Battery", ID = sub, Anm2 = anim})
                    end
                end
            end
        end
    elseif types == "Card" then
        if chipMult == 0 then
            table.insert(d.drops, {Type = "Monster", ID = EntityType.ENTITY_ATTACKFLY, Anm2 = "018.000_attack fly", Animation = "Fly"})
        else
            for i=1,chipMult do
                local card = game:GetItemPool():GetCard(chest.InitSeed, false, false, false)
                table.insert(d.drops, {Type = "Card", ID = card, Anm2 = "005.301_tarot card"})
            end
        end
    elseif types == "Chest" then
        --SpriteScale is 0.8
        if rng:RandomInt(2) == 0 then
            table.insert(d.drops, {Type = "Chest", ID = PickupVariant.PICKUP_CHEST, Var = 1})
        else
            table.insert(d.drops, {Type = "Locked", ID = PickupVariant.PICKUP_LOCKEDCHEST})
        end
    elseif types == "Pickups" then
        local bonusItems = {}
        if mod.anyPlayerHas(TrinketType.TRINKET_ACE_SPADES) then
            table.insert(bonusItems, "Card")
        end
        if mod.anyPlayerHas(TrinketType.TRINKET_CHILDS_HEART) then
            table.insert(bonusItems, "Hearts")
        end
        if mod.anyPlayerHas(TrinketType.TRINKET_MATCH_STICK) then
            table.insert(bonusItems, "Bombs")
        end
        if mod.anyPlayerHas(TrinketType.TRINKET_RUSTED_KEY) then
            table.insert(bonusItems, "Keys")
        end
        --[[if mod.anyPlayerHas(TrinketType.TRINKET_SAFETY_CAP) then
            table.insert(bonusItems, "Pill")
        end]]

        local chance = pickupChances
        if mod.anyPlayerHas(TrinketType.TRINKET_DAEMONS_TAIL) then
            chance = daemonChances
        end

        local try = 1
        if mod.anyPlayerHas(CollectibleType.COLLECTIBLE_MOMS_KEY) then
            try = 2
        end
        for i=1,try do
            local amount = mod:RandomInt(2, 6, rng)
            if mod.anyPlayerHas(TrinketType.TRINKET_LUCKY_TOE) and rng:RandomInt(3) == 0 then
                amount = 1
            end

            local bonusItem
            if #bonusItems > 0 and rng:RandomInt(3) == 0 then
                bonusItem = bonusItems[rng:RandomInt(#bonusItems)+1]
                if bonusItem == "Pill" then
                    local pill = game:GetItemPool():GetPill(chest.InitSeed)
                    table.insert(d.drops, {Type = "Pill", ID = pill, Anm2 = "005.071_pill blue-blue"})
                elseif bonusItem == "Card" then
                    local card = game:GetItemPool():GetCard(chest.InitSeed, false, false, false)
                    table.insert(d.drops, {Type = "Card", ID = card, Anm2 = "005.301_tarot card"})
                else
                    local PType, PVar, PSub, PAnm2, POff, PFrame, Repeat = mod:GetRandomChestItem(chest, bonusItem)
                    table.insert(d.drops, {Type = "Pickup", TypeNum = PType, Var = PVar, Sub = PSub, Anm2 = PAnm2, Offset = POff, AnimationFrame = PFrame})
                end
            end

            for j=1,amount do
                local roll = mod:weightedRNG(chance, rng)

                local PType, PVar, PSub, PAnm2, POff, PFrame, Repeat = mod:GetRandomChestItem(chest, roll)
                table.insert(d.drops, {Type = "Pickup", TypeNum = PType, Var = PVar, Sub = PSub, Anm2 = PAnm2, Offset = POff, AnimationFrame = PFrame})
                if Repeat > 1 then
                    for k=1,Repeat-1 do
                        table.insert(d.drops, {Type = "Pickup", TypeNum = PType, Var = PVar, Sub = PSub, Anm2 = PAnm2, Offset = POff, AnimationFrame = PFrame})
                    end
                end
            end
        end
    end
end

function mod:OpenEngineChest(chest, returnPayout)
    local chestseed = tostring(chest.InitSeed)
	local d = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'ChestData', chestseed, {})
	if d.drops and #d.drops > 0 then
        local rng = chest:GetDropRNG()
		local vec = RandomVector()
		for i = 1, #d.drops do
			if d.drops[i].Type == "Item" then
				local item = Isaac.Spawn(5, 100, d.drops[i].ID, chest.Position, Vector.Zero, chest)
				item.SpawnerType = 5
				item.SpawnerVariant = mod.PICKUP.VARIANT.ENGINE_CHEST
				chest:Remove()
			else
				local vel = vec:Rotated((i / #d.drops * 360) + (mod:RandomInt(-90,90,rng))):Resized(mod:RandomInt(3,6,rng))
				local IType, IVar, ISub = 5, 0, 0
				local SpawnPos = chest.Position
                local smal
				if d.drops[i].Type == "Trinket" then
					IVar, ISub = 350, d.drops[i].ID
				elseif d.drops[i].Type == "Card" then
					IVar, ISub = 300, d.drops[i].ID
				elseif d.drops[i].Type == "Pickup" then
					IType, IVar, ISub = d.drops[i].TypeNum, d.drops[i].Var, d.drops[i].Sub
				elseif d.drops[i].Type == "Monster" then
					IType, IVar, ISub = d.drops[i].ID, d.drops[i].Var or IVar, d.drops[i].Sub or ISub
					local player = Game():GetNearestPlayer(chest.Position)
					SpawnPos = SpawnPos + (chest.Position - player.Position):Resized(10)
                elseif d.drops[i].Type == "Pill" then
                    IVar, ISub = PickupVariant.PICKUP_PILL, d.drops[i].ID
                elseif d.drops[i].Type == "Chest" then
                    smal = true
                    IVar, ISub = d.drops[i].ID, d.drops[i].Var
                elseif d.drops[i].Type == "Locked" then
                    smal = true
                    IVar = d.drops[i].ID
                elseif d.drops[i].Type == "Battery" then
                    IVar, ISub = PickupVariant.PICKUP_LIL_BATTERY, d.drops[i].ID
                elseif d.drops[i].Type == "BatteryCard" then
                    IVar, ISub = 300, d.drops[i].ID
                end
				local pickup = Isaac.Spawn(IType, IVar, ISub, SpawnPos, vel, Isaac.GetPlayer(0))
				if pickup.Type == 3 then
					pickup:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				elseif pickup.Type >= 10 then
					if pickup.CollisionDamage > 0 then
						local StoredColl = pickup.CollisionDamage
						pickup.CollisionDamage = 0
						mod.scheduleForUpdate(function()
							if pickup and pickup:Exists() then
								pickup.CollisionDamage = StoredColl
							end
						end, 10)
						pickup:Update()
					end
				end
                if smal then
                    pickup.SpriteScale = chest.SpriteScale*0.8
                end
			end
		end
	end
	chest.SubType = 1

    if REPENTOGON and game:GetRoom():GetType() == RoomType.ROOM_CHALLENGE then
        Ambush.StartChallenge()
    end
end

function mod:CanPlayerUseEngineChest(player)
    local actives = {}
    for _, slot in pairs({ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET}) do
        if player:GetActiveItem(slot) ~= 0 then
            if slot == ActiveSlot.SLOT_POCKET and player:GetActiveItem(ActiveSlot.SLOT_POCKET) > 0 and player:GetPill(0) == 0 and player:GetCard(0) == 0 then
                actives[slot] = player:GetActiveItem(slot)
            elseif slot == ActiveSlot.SLOT_PRIMARY then
                actives[slot] = player:GetActiveItem(slot)
            end
        end
    end

    local finished
    for slot,active in pairs(actives) do
        local config = Isaac.GetItemConfig():GetCollectible(active)
        local charge = player:GetActiveMaxCharge(slot)
        if charge > 0 and config.ChargeType == 0 then
            finished = true
        elseif config.ChargeType == 1 then
            finished = true
        end
        if finished then
            break
        end
    end

    if not finished then
        local blood, soul = player:GetBloodCharge(), player:GetSoulCharge()
        if blood > 0 then
            finished = true
        elseif soul > 0 then
            finished = true
        end

        if not finished then
            for i=0,3 do
                if mod.isStorageBattery[player:GetCard(i)] == true then
                    local subt
                    if player:GetCard(i) > mod.ITEM.CARD.CORRODED_BATTERY_0 then
                        finished = true
                    else
                        finished = true
                    end
                    if finished then
                        break
                    end
                end
            end
        end
    end

    return finished
end

--Well, ended up using some Dads' Battery stuff here
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, coll)
    if coll.Type == 1 then
		local player = coll:ToPlayer()
        local d = mod:GetEntityData(pickup)
        local sprite = pickup:GetSprite()
        local chestseed = tostring(pickup.InitSeed)
        local sd = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'ChestData', chestseed, {})
        local pData = mod:GetEntityData(player)
		if (not d.Opened) and (sprite:WasEventTriggered("DropSound") or sprite:IsPlaying("Idle_0" .. (sd.Charges+1 or 1)))
        and not (player:IsHoldingItem() or pData.holdingFFItem or pData.overheadActiveItem) then
            local actives = {}
            local timedRecharge
            for slot = 0,2 do
                local item = player:GetActiveItem(slot)
                if item ~= 0 then
                    local config = Isaac.GetItemConfig():GetCollectible(item)
                    if config and config.ChargeType == 1 then
                        timedRecharge = true
                    end
                    if slot == ActiveSlot.SLOT_POCKET and player:GetActiveItem(ActiveSlot.SLOT_POCKET) > 0 and player:GetPill(0) == 0 and player:GetCard(0) == 0 then
                        actives[slot] = player:GetActiveItem(slot)
                    elseif slot == ActiveSlot.SLOT_PRIMARY then
                        actives[slot] = player:GetActiveItem(slot)
                    elseif slot == ActiveSlot.SLOT_SECONDARY then
                        actives[slot] = player:GetActiveItem(slot)
                    end
                end
            end
            local finished
            local charges = sd.Charges or 0
            for key,active in pairs(actives) do
                local config = Isaac.GetItemConfig():GetCollectible(active)
                local maxCharge = player:GetActiveMaxCharge(key)
                local charge = player:GetActiveCharge(key)+player:GetBatteryCharge(key)
                if charge > 0 and config.ChargeType == 0 and not timedRecharge then
                    local subt = math.min(charge, 3-charges)
                    charges = charges+subt
                    player:SetActiveCharge(charge-subt, key)
                end
                if config.ChargeType == 1 then
                    local subt = math.min(math.floor(charge/maxCharge), 3-charges)
                    charges = 3
                    player:SetActiveCharge(charge-subt*maxCharge, key)
                end
                if charges >= 3 then
                    finished = true
                    break
                end
            end

            if not finished then
                local blood, soul = player:GetBloodCharge(), player:GetSoulCharge()
                if blood > 0 then
                    local subt = math.min(blood, 3-charges)
                    charges = charges+subt
                    player:SetBloodCharge(blood-subt)
                elseif soul > 0 then
                    local subt = math.min(soul, 3-charges)
                    charges = charges+subt
                    player:SetSoulCharge(soul-subt)
                end
                if charges >= 3 then
                    finished = true
                end

                if not finished and player:HasCollectible(mod.ITEM.COLLECTIBLE.DADS_BATTERY) then
                    if not pData.ffDadsBatteryPrevCharge then
                        pData.ffDadsBatteryPrevCharge = {}
                    end
                    for _, slot in pairs({ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET}) do
                        local isPocketActive = (slot == ActiveSlot.SLOT_POCKET)
                        local activeInfo = mod:GetActiveItemInfo(player, slot)

                        if activeInfo and not mod.DadsBattery.BLACKLIST[activeInfo.ID] and activeInfo.MaxCharges > 0 and activeInfo.ChargeType ~= ItemConfig.CHARGE_SPECIAL
                                and (not isPocketActive or pData.ffDadsBatteryPocketActiveSelected) then
                            local itemID = activeInfo.ID
                            local debtCap = mod:getDadsBatteryMaxDebt(activeInfo.ChargeType)
                            local currentDebt = mod:getChargeDebt(player, pData, slot)
                            local dadsBatteryData = GetDadsBatteryData(player, itemID, slot)
                            if not dadsBatteryData.PRE and not dadsBatteryData.POST
                                    and currentDebt < debtCap then
                                        local subt = math.min(debtCap-currentDebt, 3-charges)
                                        charges = charges+subt
                                        mod:setChargeDebt(player, pData, slot, mod:getChargeDebt(player, pData, slot) + subt)
                            end
                        end
                    end
                end

                if charges >= 3 then
                    finished = true
                end

                if not finished then
                    if mod.isStorageBattery[player:GetCard(0)] == true then
                        local subt
                        if player:GetCard(0) > mod.ITEM.CARD.CORRODED_BATTERY_0 then
                            subt = math.min(player:GetCard(0)-mod.ITEM.CARD.CORRODED_BATTERY_0, 3-charges)
                        else
                            subt = math.min(player:GetCard(0)-mod.ITEM.CARD.STORAGE_BATTERY_0, 3-charges)
                        end
                        charges = charges+subt
                        player:SetCard(0, player:GetCard(0)-subt)
                    end
                end
            end

			if finished or charges >= 3 then
                --Actually it's minor but I guess I'll open it now instead of the event so it doesn't get interrupted by leaving
                d.State = "Opening"
				pickup:GetSprite():Play("Open")

				pickup.SubType = mod.shopChestStates.Opening
				d.Opened = true
				sfx:Play(SoundEffect.SOUND_CHEST_OPEN, 1, 0, false, 1)
				sfx:Play(SoundEffect.SOUND_BATTERYCHARGE, 0.6, 0, false, 0.9)

				mod:OpenEngineChest(pickup)
                Isaac.RunCallback(ModCallbacks.MC_POST_OPEN_CHEST, pickup, player)

				if pickup.OptionsPickupIndex ~= 0 then
					local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP)
					for _, entity in ipairs(pickups) do
						if entity:ToPickup().OptionsPickupIndex == pickup.OptionsPickupIndex and
						   (entity.Index ~= pickup.Index or entity.InitSeed ~= pickup.InitSeed)
						then
							Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, nil)
							entity:Remove()
						end
					end

					pickup.OptionsPickupIndex = 0
				end
			elseif charges > (sd.Charges or 0) then
                sd.Charges = charges
                sfx:Play(SoundEffect.SOUND_BEEP, 0.8, 0, false, mod:RandomInt(80,90,pickup:GetDropRNG())/100)
                pickup:GetSprite():Play("Pip_0" .. charges, true)

                d.State = "Pip"
            end
		end
	end
end, mod.PICKUP.VARIANT.ENGINE_CHEST)


mod:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, function(_, chest)
	local chestseed = tostring(chest.InitSeed)
    local gd = mod:GetEntityData(chest)
	local d = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'ChestData', chestseed, {})
	if mod:GetEntityData(chest).Opened then return end
	local icon = Sprite()
	icon.Color = Color(icon.Color.R, icon.Color.G, icon.Color.B, gd.Alpha or 0.8, icon.Color.RO, icon.Color.GO, icon.Color.BO)


	icon:Load("gfx/005.011_heart.anm2", true)
	icon:SetFrame("Idle", 0)
	local baseOffset = Vector.Zero
	if d.drops and #d.drops > 0 then
		local count = math.min(#d.drops, 16)
		for i = 1, #mod.GuppyEyeOffsets[count] do
			baseOffset = Vector.Zero
			icon.Scale = Vector(0.5, 0.5)
			if d.drops[i].Type then
				if d.drops[i].Type == "Item" then
					icon:Load("gfx/005.100_collectible.anm2", true)
					icon:SetFrame("Idle", 0)
					local curses = game:GetLevel():GetCurses()
                    local itemSprite
                    if d.drops[i].ID then
                        local config = Isaac.GetItemConfig():GetCollectible(d.drops[i].ID)
                        if config then
                            itemSprite = config.GfxFileName
                        end
                    end
					if curses == curses | LevelCurse.CURSE_OF_BLIND or not itemSprite then
						icon:ReplaceSpritesheet(1, "gfx/items/collectibles/questionmark.png")
					else
						icon:ReplaceSpritesheet(1, itemSprite)
					end
					baseOffset = Vector(0, 12)
					icon:LoadGraphics()
				elseif d.drops[i].Type == "Trinket" then
					icon:Load("gfx/005.350_trinket.anm2", true)
					icon:SetFrame("Idle", 0)
					icon:ReplaceSpritesheet(0, Isaac.GetItemConfig():GetTrinket(d.drops[i].ID).GfxFileName)
					icon:LoadGraphics()
				elseif d.drops[i].Type == "Card" then
					icon:Load("gfx/" .. d.drops[i].Anm2 .. ".anm2", true)
					icon:SetFrame("Idle", 0)
				elseif d.drops[i].Type == "Pickup" then
					icon:Load("gfx/" .. d.drops[i].Anm2 .. ".anm2", true)
					icon:SetFrame("Idle", d.drops[i].AnimationFrame or 0)
					baseOffset = d.drops[i].Offset or  Vector(0, 5)
                elseif d.drops[i].Type == "Chest" then
                    icon:Load("gfx/005.050_chest.anm2", true)
                    icon:SetFrame("Idle", 0)
                    if REPENTOGON then
                        icon:GetLayer("shadow"):SetVisible(false)
                    end
                elseif d.drops[i].Type == "Locked" then
                    icon:Load("gfx/005.060_locked chest.anm2", true)
                    icon:SetFrame("Idle", 0)
                    if REPENTOGON then
                        icon:GetLayer("shadow"):SetVisible(false)
                    end
                elseif d.drops[i].Type == "Battery" then
                    icon:Load("gfx/" .. d.drops[i].Anm2 .. ".anm2", true)
                    icon:SetFrame("Idle", 0)
                elseif d.drops[i].Type == "BatteryCard" then
                    local num = d.drops[i].ID-mod.ITEM.CARD.STORAGE_BATTERY_0+1
                    icon:Load("gfx/" .. d.drops[i].Anm2 .. ".anm2", true)
                    icon:SetFrame("Idle", 0)
                    icon:ReplaceSpritesheet(0, "gfx/items/pick ups/storage_battery_0" .. num .. ".png")
					icon:LoadGraphics()
				elseif d.drops[i].Type == "Monster" then
					icon:Load("gfx/" .. d.drops[i].Anm2 .. ".anm2", true)
					icon:SetFrame(d.drops[i].Animation or "Idle", d.drops[i].AnimationFrame or 0)
					if d.drops[i].Overlay then
						icon:SetOverlayFrame(d.drops[i].Overlay or "Idle", d.drops[i].OverlayFrame or 0)
					end
					baseOffset = d.drops[i].Offset or  Vector(0, 5)
					if d.drops[i].Scale then
						icon.Scale = Vector(d.drops[i].Scale, d.drops[i].Scale)
					end
				end
			end
			local renderPos = chest.Position + baseOffset - mod.GuppyEyeOffsets[count][i]
			renderPos = Isaac.WorldToScreen(renderPos)
			icon:Render(renderPos, Vector.Zero, Vector.Zero)
		end
	end
end, mod.PICKUP.VARIANT.ENGINE_CHEST)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, pickup)
	local d = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'PedestalData', tostring(pickup.InitSeed), {})
		if d.enginePedestal or pickup.SpawnerEntity then
			if d.enginePedestal or (pickup.SpawnerEntity.Type == 5 and pickup.SpawnerEntity.Variant == mod.PICKUP.VARIANT.ENGINE_CHEST) then
				pickup:GetSprite():ReplaceSpritesheet(5, "gfx/items/slots/ff_chest_pedestals.png")
				pickup:GetSprite():LoadGraphics()
				pickup:GetSprite():SetOverlayFrame("Alternates", 5)
                d.enginePedestal = true
			end
		end
end, 100)