local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local pickingupitem = {}
function mod:orangeJuicePickupSound(player)
	if not player:IsItemQueueEmpty() and player.QueuedItem.Item:IsCollectible() then
		if not pickingupitem[player.InitSeed] then
			if player.QueuedItem.Item.ID == FiendFolio.ITEM.COLLECTIBLE.HUNDRED_PERCENT_ORANGE_JUICE then
                if mod:cancelCollectiblePickupSound() then
                    if math.random(10) == 1 then
                        FiendFolio:trySayAnnouncerLine(mod.Sounds.OrangeJuiceA100Percent, 0, 30)
                    end
                    sfx:Play(mod.Sounds.OrangeJuiceChapterStart, 0.5, 2, false, 1)
                end
			end
		end
		pickingupitem[player.InitSeed] = true
	else
		pickingupitem[player.InitSeed] = false
	end
end

local function findOrangeJuicePosition()
    local room = game:GetRoom()
    local acceptableMimePositions = {}
    local size = room:GetGridSize()
    for i=0, size do
        local gridpos = room:GetGridPosition(i)
        local nearbyMime
        for _, mimeBlock in ipairs(Isaac.FindByType(mod.FF.OrangeJuiceTile.ID, mod.FF.OrangeJuiceTile.Var, mod.FF.OrangeJuiceTile.Sub, false, false)) do
            if mimeBlock.Position:Distance(gridpos) < 10 then
                nearbyMime = true
                break
            end
        end
        if (not nearbyMime) and #Isaac.FindInRadius(gridpos, 10, EntityPartition.ENEMY) > 0 then
            nearbyMime = true
        end
        if (not nearbyMime) and #Isaac.FindInRadius(gridpos, 10, EntityPartition.PLAYER) > 0 then
            nearbyMime = true
        end
        for k = 90, 360, 90 do
            local checkGrid = room:GetGridEntityFromPos(gridpos + Vector(40, 0):Rotated(k))
            if checkGrid and checkGrid:GetType() == GridEntityType.GRID_DOOR then
                nearbyMime = true
                break
            end
        end
        if not nearbyMime and room:GetGridCollisionAtPos(gridpos) == 0 and room:IsPositionInRoom(gridpos, 0) and not room:GetGridEntity(i) then
            table.insert(acceptableMimePositions, gridpos)
        end
    end

    if #acceptableMimePositions > 0 then
        --base this off room seed
        local newpos = acceptableMimePositions[math.random(#acceptableMimePositions)]
        return newpos
    end
end

local OJ_TILE = {
    BONUSU        = 1,
    MISS          = 2,
    CARD          = 3,
    WARP          = 4,
    ENCOUNTER     = 5,
    HEAL          = 6,
    ENCOUNTERBOSS = 7,
    EXPLODE       = 8,
}

local OJ_WEIGHTS = {
    {OJ_TILE.BONUSU,        10},
    {OJ_TILE.MISS,          10},
    {OJ_TILE.CARD,          10},
    {OJ_TILE.WARP,          9},
    {OJ_TILE.ENCOUNTER,     9},
    {OJ_TILE.HEAL,          1},
    {OJ_TILE.ENCOUNTERBOSS, 5},
    {OJ_TILE.EXPLODE,       1},
}

local function triggerOrangeJuice(player)
    local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.HUNDRED_PERCENT_ORANGE_JUICE)
    local chance = math.max(0.01, 0.2 + (player.Luck / 20))
    local bonus = 0
    for i = 1, 4 * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.HUNDRED_PERCENT_ORANGE_JUICE) do
        if rng:RandomFloat() < chance then
            bonus = bonus + 1
        end
    end
    mod.scheduleForUpdate(function()
        for i = 1, 3 + bonus do
            local juicePos = findOrangeJuicePosition()
            if juicePos then
                local mimeBlock = Isaac.Spawn(mod.FF.OrangeJuiceTile.ID, mod.FF.OrangeJuiceTile.Var, mod.FF.OrangeJuiceTile.Sub, juicePos, Vector.Zero, Isaac.GetPlayer()):ToEffect()
                mimeBlock:Update()
            end
        end
    end, 1, nil, true)
end

function mod:CreateNewOrangeJuiceTile(pos)
    local juicePos = pos or findOrangeJuicePosition()
    if juicePos then
        local mimeBlock = Isaac.Spawn(mod.FF.OrangeJuiceTile.ID, mod.FF.OrangeJuiceTile.Var, mod.FF.OrangeJuiceTile.Sub, juicePos, Vector.Zero, Isaac.GetPlayer()):ToEffect()
        mimeBlock:Update()
        return mimeBlock
    end
end

function mod:orangeJuiceNewRoom(player, d, savedata)
    if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.HUNDRED_PERCENT_ORANGE_JUICE) then
        local room = game:GetRoom()
        if room:IsFirstVisit() and not room:IsClear() then
            triggerOrangeJuice(player)
        end
    end
end

function mod:orangeJuiceNewGreedWave(player)
    if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.HUNDRED_PERCENT_ORANGE_JUICE) then
        triggerOrangeJuice(player)
    end
end

--I think this means it should work with Metronome?
FiendFolio.AddItemPickupCallback(function(player, added)
    local room = game:GetRoom()
    if not room:IsClear() then
        triggerOrangeJuice(player)
    end
end, nil, mod.ITEM.COLLECTIBLE.HUNDRED_PERCENT_ORANGE_JUICE)

local function ActivateOrangeJuice(e, tileNum, player)
    local r = e:GetDropRNG()
    if tileNum == OJ_TILE.BONUSU then
        if r:RandomInt(1000) == 1 then
            FiendFolio:trySayAnnouncerLine(mod.Sounds.OrangeJuiceABonusu, 0, 40)
        end
        sfx:Play(mod.Sounds.OrangeJuiceStar)
        for i = 1, 1 + r:RandomInt(6) do
            local vec = RandomVector()*mod:RandomInt(10,20)/10
            Isaac.Spawn(5, 20, FiendFolio.PICKUP.COIN.LIL_PENNY, e.Position, vec, nil)
        end
    elseif tileNum == OJ_TILE.MISS then
        if r:RandomInt(1000) == 1 then
            FiendFolio:trySayAnnouncerLine(mod.Sounds.OrangeJuiceADrop, 0, 30)
        end
        sfx:Play(mod.Sounds.OrangeJuiceDrop)
        player:AnimateSad()
        local numRemoved = (r:RandomInt(6) + 1) / 10
        mod:AddFractionalCoins(-numRemoved)
    elseif tileNum == OJ_TILE.CARD then
        if r:RandomInt(1000) == 1 then
            FiendFolio:trySayAnnouncerLine(mod.Sounds.OrangeJuiceACard, 0, 30)
        end
        sfx:Play(mod.Sounds.OrangeJuiceCard)
        --local chosenCard = FiendFolio.EnergyCards[r:RandomInt(#FiendFolio.EnergyCards) + 1]
        local chosenCard = mod:weightedRNG(mod.OrangeJuiceCards, r)
        player:UseCard(chosenCard, UseFlag.USE_MIMIC)
        local hud = game:GetHUD()
        local config = Isaac.GetItemConfig():GetCard(chosenCard)
        hud:ShowItemText(config.Name, config.Description)
    elseif tileNum == OJ_TILE.WARP then
        sfx:Play(mod.Sounds.OrangeJuiceWarp)
        local tempFly = Isaac.Spawn(18, 0, 250, e.Position, Vector.Zero, e):ToNPC()
        tempFly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        tempFly:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_HIDE_HP_BAR | EntityFlag.FLAG_NO_REWARD | EntityFlag.FLAG_NO_DEATH_TRIGGER)

        local path = tempFly.Pathfinder

        local acceptableGrids = {}
        local room = game:GetRoom()
        local size = room:GetGridSize()
        for i=0, size do
            local gridpos = room:GetGridPosition(i)
            if room:GetGridCollisionAtPos(gridpos) == GridCollisionClass.COLLISION_NONE and room:IsPositionInRoom(gridpos, 0) then
                if path:HasPathToPos(gridpos, false) then
                    table.insert(acceptableGrids, gridpos)
                end
            end
        end
        tempFly:Remove()
        if #acceptableGrids > 0 then
            local telePos = acceptableGrids[r:RandomInt(#acceptableGrids) + 1]
            mod:alphaTeleportToPosition(player, telePos)
        end
    elseif tileNum == OJ_TILE.ENCOUNTER or tileNum == OJ_TILE.ENCOUNTERBOSS then
        if r:RandomInt(1000) == 1 then
            FiendFolio:trySayAnnouncerLine(mod.Sounds.OrangeJuiceAEncounter, 0, 35)
        end
        sfx:Play(mod.Sounds.OrangeJuiceEncounter)
        --I can't fucking believe I'm reusing Mo code, but here we are.
        --I decided against it, leaving the comment in though for the funny.
        local backdrop = game:GetRoom():GetBackdropType()
        local ent
        local floor
        if mod.portalreplacement[backdrop] and not (StageAPI and StageAPI.InNewStage()) then
            floor = mod.portalreplacement[backdrop]
            if type(floor) == "number" then
                floor = mod.portalreplacement[floor]
            end
        end
        if not floor then
            local room = game:GetRoom()
            if room:GetType() == RoomType.ROOM_DEFAULT then
                floor = mod.portalreplacement[mod:GetRandomElem(mod.portalreplacementrandompool, r)]
            else
                floor = mod.portalreplacement[1] --Just draw from basement in like, shops and whatever
            end
        end
        if not ent then
            ent = floor[r:RandomInt(#floor) + 1]
        end
        if not ent then
            ent = {}
        end
        local npc = Isaac.Spawn(ent[1] or 10, ent[2] or 0, ent[3] or 0, e.Position, Vector.Zero, e):ToNPC()
        if tileNum == OJ_TILE.ENCOUNTERBOSS then
            npc:MakeChampion(npc.InitSeed, -1, true)
        end
        --Don't wanna hurt the player eh?
        player:SetMinDamageCooldown(30)
    elseif tileNum == OJ_TILE.HEAL then
        sfx:Play(mod.Sounds.OrangeJuiceHeal)
        local heart = Isaac.Spawn(5,10, 0, e.Position, Vector.Zero, e):ToPickup()
        heart.Timeout = 120
    elseif tileNum == OJ_TILE.EXPLODE then
        sfx:Play(mod.Sounds.OrangeJuiceExplode, 0.5)
        --game:BombExplosionEffects(e.Position, 2, 0, Color(1, 1, 1, 1, 0, 0, 0), e, 1, false, true)
        local supertroll = Isaac.Spawn(5, 40, 5, e.Position, Vector.Zero, e):ToPickup()
    end
end

local function selectOrangeJuiceTile(e)
    local wop = WeightedOutcomePicker()
    for i = 1, #OJ_WEIGHTS do
        wop:AddOutcomeWeight(OJ_WEIGHTS[i][1], OJ_WEIGHTS[i][2])
    end
    return wop:PickOutcome(e:GetDropRNG())
end

function mod:orangeJuiceTileEffectAI(e)
    local sprite, d = e:GetSprite(), mod:GetEntityData(e)
    local room = game:GetRoom()

    e.DepthOffset = -100

    if not d.init then
        d.tile = selectOrangeJuiceTile(e)
        sprite:Play("Appear" .. d.tile, true)
        d.init = true
    end

    if sprite:IsFinished("Appear" .. d.tile) then
        sprite:Play("Idle" .. d.tile)
    end

    if room:IsClear() then
        --d.roomDone = true
    end

    if d.disappearing then
        if sprite:IsFinished("Shoot" .. d.tile) then
            e:Remove()
        else
            mod:spritePlay(sprite, "Shoot" .. d.tile)
        end
    elseif d.roomDone then
        if sprite:IsFinished("Leave" .. d.tile) then
            e:Remove()
        else
            mod:spritePlay(sprite, "Leave" .. d.tile)
        end
    else
        if not d.disappearing then
            for _, player in ipairs(Isaac.FindByType(1, -1, -1, false, false)) do
                if player.Position:Distance(e.Position) < 10 + player.Size then
                    ActivateOrangeJuice(e, d.tile, player:ToPlayer())
                    d.disappearing = true
                    break
                end
            end
        end



        if d.TryReroll then
            local original = tostring(d.tile)
            local anim = string.sub(sprite:GetAnimation(), 1, -string.len(original)-1)

            e:SetColor(Color(1, 1, 1, 1, 1, 1, 1), 1, 0, true, false)
            d.RerollFlash = 1
            d.TryReroll = nil

            local rng = e:GetDropRNG()
            local newResults = mod:makeCopiedTable(OJ_TILE)
            local keys = {}
            for key,entry in pairs(newResults) do
                table.insert(keys, key)
            end
            table.remove(keys, rng:RandomInt(#keys)+1)

            d.tile = OJ_TILE[keys[rng:RandomInt(#keys)+1]]
            sprite:SetFrame(anim .. d.tile, sprite:GetFrame())
        end
    end
    if d.RerollFlash then
        if d.RerollFlash > 0.05 then
            d.RerollFlash = mod:Lerp(d.RerollFlash, 0, 0.3)
            e:SetColor(Color(1, 1, 1, 1, d.RerollFlash, d.RerollFlash, d.RerollFlash), 1, 0, true, false)
        else
            d.RerollFlash = nil
            e:SetColor(Color(1, 1, 1, 1, 0, 0, 0), 1, 0, true, false)
        end
    end
end