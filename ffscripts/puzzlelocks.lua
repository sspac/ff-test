local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    local sprite = pickup:GetSprite()
    local data = mod:GetEntityData(pickup)
    if sprite:IsFinished("Appear") then
        sprite:Play("Idle", false)
    end
    if sprite:IsPlaying("Collect") and sprite:GetFrame() == 5 then
        pickup.Visible = false
        pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    end
    if sprite:IsEventTriggered("DropSound") then
        sfx:Play(SoundEffect.SOUND_KEY_DROP0, 1, 0, false, 1.25)
    end

    if not data.checkcolour then
        if pickup.SubType == 1 and mod.ColourBlindMode then
            local s = pickup:GetSprite()
            s:ReplaceSpritesheet(0, "gfx/items/pick ups/consumable_yellowkey.png")
            s:LoadGraphics()
        end
        data.checkcolour = true
    end
end, mod.PICKUP.VARIANT.PUZZLE_KEY)

function mod.CollectPuzzleKey(player, pickup)
    local sprite = pickup:GetSprite()
    if sprite:WasEventTriggered("DropSound") or sprite:IsPlaying("Idle") then
        pickup.Touched = true
		pickup.Velocity = Vector.Zero
        sprite:Play("Collect")
        sfx:Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET, 1, 0, false, math.random(147,153)/100)

        local data = mod:GetEntityData(player)
        local ghostVariant = FiendFolio.KeyToGhostMap[pickup.SubType]
        table.insert(data.KeyGhostData[ghostVariant], { Key = pickup })

        player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS, true)
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider)
    if collider.Type == EntityType.ENTITY_PLAYER then
		collider = collider:ToPlayer()
		local keyOwner = FiendFolio:GetMainPlayer(collider, true)
        mod.CollectPuzzleKey(keyOwner, pickup)
    end
    return true
end, mod.PICKUP.VARIANT.PUZZLE_KEY)

-- Keep the key data between different forms
function mod:TransferPuzzleKeyData(originalForm, newForm)
	local originalData = mod:GetEntityData(originalForm)
    local newData = mod:GetEntityData(newForm)
    newData.KeyGhostData = mod:CopyTable(originalData.KeyGhostData)
end
mod:AddCallback(mod.CALLBACK.ESAU_JR_SWITCH_FORM,  mod.TransferPuzzleKeyData)
mod:AddCallback(mod.CALLBACK.TLAZARUS_SWITCH_FORM, mod.TransferPuzzleKeyData)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function()
    local originalSeeds = {}
    for _, p in pairs(Isaac.FindByType(5, mod.PICKUP.VARIANT.PUZZLE_KEY, -1, false, false)) do
        if originalSeeds[p.InitSeed] then
            p:Remove()
        else
            originalSeeds[p.InitSeed] = true
        end
    end
end, Card.RUNE_JERA)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, familiar)
    familiar.IsFollower = true
    familiar:AddEntityFlags(EntityFlag.FLAG_DONT_OVERWRITE)
end, mod.ITEM.FAMILIAR.BLUE_KEYGHOST)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, familiar)
    familiar.IsFollower = true
    familiar:AddEntityFlags(EntityFlag.FLAG_DONT_OVERWRITE)

    if mod.ColourBlindMode then
        local s = familiar:GetSprite()
        s:ReplaceSpritesheet(0, "gfx/familiar/keyghosts/familiar_keyghostyellow.png")
        s:ReplaceSpritesheet(1, "gfx/familiar/keyghosts/familiar_keyghostyellow.png")
        s:LoadGraphics()
    end
end, mod.ITEM.FAMILIAR.GREEN_KEYGHOST)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, familiar)
    familiar.IsFollower = true
    familiar:AddEntityFlags(EntityFlag.FLAG_DONT_OVERWRITE)
end, mod.ITEM.FAMILIAR.RED_KEYGHOST)

-- note these do not use anm2s as grid sprites are very funky
local blockColors = {{"Blue", 1013, 1017}, {"Green", 1014, 1018}, {"Red", 1015, 1019}, {"Gray", 1034, 1035}}

FiendFolio.KeyBlockGrid = {}
FiendFolio.ChainBlockGrid = {}

for _, color in ipairs(blockColors) do
    FiendFolio.KeyBlockGrid[color[1]] = StageAPI.CustomGrid("FFKeyBlock" .. color[1], {
        BaseType = GridEntityType.GRID_WALL,
        Anm2 = "gfx/grid/" .. string.lower(color[1]) .. "_lock.anm2",
        Animation = "Idle",
        SpawnerEntity = {Type = FiendFolio.FFID.Grid, Variant = color[2]}
    })

    FiendFolio.ChainBlockGrid[color[1]] = StageAPI.CustomGrid("FFChainBlock" .. color[1], {
        BaseType = GridEntityType.GRID_WALL,
        Anm2 = "gfx/grid/" .. string.lower(color[1]) .. "_blank_lock.anm2",
        Animation = "Idle",
        SpawnerEntity = {Type = FiendFolio.FFID.Grid, Variant = color[3]}
    })
end

function mod.IsKeyBlock(grid)
	local gridIndex = grid:GetGridIndex()

	for _, color in ipairs(blockColors) do
		if StageAPI.IsCustomGrid(gridIndex, "FFKeyBlock" .. color[1]) or StageAPI.IsCustomGrid(gridIndex, "FFChainBlock" .. color[1]) then
			return true
		end
	end
	return false
end

FiendFolio.BlockGridToEffect = {
    FFKeyBlockBlue  = 1013,
    FFKeyBlockGreen = 1014,
    FFKeyBlockRed   = 1015,
    FFKeyBlockGray  = 1034,
    FFChainBlockBlue  = 1017,
    FFChainBlockGreen = 1018,
    FFChainBlockRed   = 1019,
    FFChainBlockGray = 1035,
}

for _, variant in pairs(FiendFolio.BlockGridToEffect) do
    mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, eff)
        local sprite = eff:GetSprite()
        if sprite:IsFinished() then
            eff:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR)
        end
    end, variant)
end

FiendFolio.ColorBlindBlocks = {
    FFKeyBlockGreen = "gfx/grid/yellow_lock.png",
    FFChainBlockGreen = "gfx/grid/yellow_blank_lock.png",
}

FiendFolio.KeyToGhostMap = {
    [FiendFolio.PuzzleKeySubType.BLUE] = mod.ITEM.FAMILIAR.BLUE_KEYGHOST,
    [FiendFolio.PuzzleKeySubType.GREEN] = mod.ITEM.FAMILIAR.GREEN_KEYGHOST,
    [FiendFolio.PuzzleKeySubType.RED] = mod.ITEM.FAMILIAR.RED_KEYGHOST
}

FiendFolio.KeyBlockToGhostMap = {
    FFKeyBlockBlue  = mod.ITEM.FAMILIAR.BLUE_KEYGHOST,
    FFKeyBlockGreen = mod.ITEM.FAMILIAR.GREEN_KEYGHOST,
    FFKeyBlockRed   = mod.ITEM.FAMILIAR.RED_KEYGHOST
}

FiendFolio.KeyBlockToEvilGhostMap = {
    FFKeyBlockBlue = mod.FF.BlueKeyFiend.Sub,
    FFKeyBlockGreen = mod.FF.GreenKeyFiend.Sub,
    FFKeyBlockRed = mod.FF.RedKeyFiend.Sub
}

FiendFolio.ChaintoKeyBlock = {
    FFChainBlockBlue  = 'FFKeyBlockBlue',
    FFChainBlockGreen = 'FFKeyBlockGreen',
    FFChainBlockRed   = 'FFKeyBlockRed',
    FFChainBlockGray  = 'FFKeyBlockGray',
}

FiendFolio.KeytoChainBlock = {
    FFKeyBlockBlue  = 'FFChainBlockBlue',
    FFKeyBlockGreen = 'FFChainBlockGreen',
    FFKeyBlockRed   = 'FFChainBlockRed',
    FFKeyBlockGray  = 'FFChainBlockGray'
}

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    if game.Challenge == FiendFolio.challenges.theGauntlet then -- key ghosts persist in this challenge
        return
    end

    for i, player in pairs( PlayerManager.GetPlayers() ) do
        local data = mod:GetEntityData(player)

        for variant, entry in pairs(data.KeyGhostData) do
            data.KeyGhostData[variant] = {}
        end
        player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS, true)
    end

    for _, puzzleKey in ipairs( Isaac.FindByType(EntityType.ENTITY_PICKUP, mod.PICKUP.VARIANT.PUZZLE_KEY) ) do
        puzzleKey:ToPickup().Touched = false
    end
end)

function mod:KeyGhostUpdate(familiar)
    local data = mod:GetEntityData(familiar)
    local sprite = familiar:GetSprite()

    if not data.key then
        local playerData = mod:GetEntityData(familiar.Player)
        local keys = playerData.KeyGhostData[familiar.Variant]

        for i, entry in ipairs(keys) do
            if not entry.Ghost or not entry.Ghost:Exists() then
                entry.Ghost = familiar
                data.key = entry.Key
                break
            end
        end
    end

    if sprite:IsFinished("Appear") then
        sprite:Play("Move")
    elseif sprite:IsFinished("Poof") then
        familiar:Remove()
    end
    sprite.Offset = Vector(0, -10)
    sprite.FlipX = familiar.Velocity.X <= 0

    if sprite:IsEventTriggered("UseKey") then
        data.target:GetData().Unlock = true

        -- kill the key right now to avoid waiting for the rest of the animation
        -- because the lock part of the code runs in post_update this is fine
        local playerData = mod:GetEntityData(familiar.Player)
        local keys = playerData.KeyGhostData[familiar.Variant]

        for i, entry in ipairs(keys) do
            if entry.Ghost and GetPtrHash(entry.Ghost) == GetPtrHash(familiar) then
                entry.Key:Remove()
                table.remove(keys, i)
                break
            end
        end
    end

    if data.target then
        familiar.Velocity = (data.target.Position - familiar.Position) * 0.2
        if familiar.Position:DistanceSquared(data.target.Position) <= (familiar.Size + data.target.Size) ^ 2 then
            sprite:Play("Poof", false)
        end
    else
        familiar:FollowParent()
    end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.KeyGhostUpdate, mod.ITEM.FAMILIAR.RED_KEYGHOST)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.KeyGhostUpdate, mod.ITEM.FAMILIAR.GREEN_KEYGHOST)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.KeyGhostUpdate, mod.ITEM.FAMILIAR.BLUE_KEYGHOST)

function mod.commonBlockAI(customGrid)
    local persistData = customGrid.PersistentData
    persistData.FrameCount = persistData.FrameCount + 1

    local sprite = customGrid.GridEntity:GetSprite()
    if persistData.BreakStarted then
        if not persistData.BreakTriggered and persistData.FrameCount > persistData.BreakStarted then
            persistData.BreakTriggered = true
            sprite:Play("Breaking", true)
        end

        if sprite:IsEventTriggered('SndPlay') then
            sfx:Play(SoundEffect.SOUND_METAL_BLOCKBREAK, 0.9, 0, false, math.random(125,135)/100)
        end

        if sprite:IsEventTriggered('Unlock') then
            sfx:Play(SoundEffect.SOUND_UNLOCK00, 1.2, 0, false, math.random(120,140)/100)
            local eff = Isaac.Spawn(1000, FiendFolio.BlockGridToEffect[customGrid.GridConfig.Name], 0, customGrid.GridEntity.Position, Vector.Zero, nil)
            eff:GetSprite():Play(sprite:GetAnimation(), true)
            eff:GetSprite():SetFrame(sprite:GetFrame())
            local savedPos = game:GetRoom():GetGridIndex(customGrid.GridEntity.Position)
            for k = 1, 3 do
                mod.scheduleForUpdate(function()
                    local room = game:GetRoom()
                    room:SpawnGridEntity(savedPos, GridEntityType.GRID_DECORATION, 0, 0, 0)
                end, k)
            end
            customGrid:Remove()

			if mod.CanRunUnlockAchievements() then
				FiendFolio.savedata.puzzleLocksUnlocked = (FiendFolio.savedata.puzzleLocksUnlocked or 0) + 1
				if FiendFolio.savedata.puzzleLocksUnlocked >= 20 and not FiendFolio.ACHIEVEMENT.TRICOLOR_KEY:IsUnlocked(true) then
					FiendFolio.ACHIEVEMENT.TRICOLOR_KEY:Unlock()
				end
			end

			if game.Challenge == FiendFolio.challenges.theGauntlet then
				local grids = StageAPI.GetRoomCustomGrids().Grids
				local anyPuzzleLocksStillExist = false
				for _, grid in pairs(grids) do
					local name = grid.Name
					if grid.Name == "FFKeyBlockBlue" or 
					   grid.Name == "FFKeyBlockGreen" or 
					   grid.Name == "FFKeyBlockRed"
					then
						anyPuzzleLocksStillExist = true
						break
					end
				end
				if not anyPuzzleLocksStillExist then
					local currentRoom = StageAPI.GetCurrentRoom()
					if currentRoom.Layout.Name == "Chapter 1 Exit" then
						if not FiendFolio.ACHIEVEMENT.RIDICULOUS_METAL:IsUnlocked(true) then
							FiendFolio.ACHIEVEMENT.RIDICULOUS_METAL:Unlock()
						end
					elseif currentRoom.Layout.Name == "Chapter 2 Exit" then
						if not FiendFolio.ACHIEVEMENT.ATLAS_BURDEN:IsUnlocked(true) then
							FiendFolio.ACHIEVEMENT.ATLAS_BURDEN:Unlock()
						end
					elseif currentRoom.Layout.Name == "Chapter 3 Exit" then
						if not FiendFolio.ACHIEVEMENT.POCKET_ROCKIT:IsUnlocked(true) then
							FiendFolio.ACHIEVEMENT.POCKET_ROCKIT:Unlock()
						end
					elseif currentRoom.Layout.Name == "Final Exit?" then
						if not FiendFolio.ACHIEVEMENT.WORMHOLE_ROCK:IsUnlocked(true) then
							FiendFolio.ACHIEVEMENT.WORMHOLE_ROCK:Unlock()
						end
					end
				end
			end
        end
    end

    sprite:Update() -- walls don't update their sprites by default, so we have to do it
end

function mod.lockAI(customGrid)
    mod.commonBlockAI(customGrid)

    local room = game:GetRoom()
    local persistData = customGrid.PersistentData
    local customGridTypeName = customGrid.GridConfig.Name
    local spawnIndex = customGrid.GridIndex

    --This code basically ensures it can still open if the friend doesn't exist
    --A case this happens is if the player leaves the room before it finishes opening
    if persistData.friend and not persistData.friend:Exists()
    and not persistData.BreakTriggered then
        persistData.friend = nil
    end

    if not persistData.friend then
        local position = customGrid.GridEntity.Position
        local ghostVariant = FiendFolio.KeyBlockToGhostMap[customGridTypeName]

        if ghostVariant then
            for _, player in pairs( PlayerManager.GetPlayers() ) do
                local radius = player.Size + 26
                if player:GetPlayerType() == mod.PLAYER.CHINA then radius = radius + 20 end

                if (player.Position + player.Velocity):Distance(position) <= radius then
                    local playerData = mod:GetEntityData(player).KeyGhostData

                    for _, entry in pairs( playerData[ghostVariant] ) do
                        local ghost = entry.Ghost

                        if ghost and ghost:Exists() and not mod:GetEntityData(ghost).target then
                            mod:GetEntityData(ghost).target = {
                                Position = position,
                                Size = 26,
                                GetData = function() return persistData end
                            } -- fake npc
                            persistData.friend = ghost
                            break
                        end
                    end

                    if persistData.friend then
                        break
                    end

                    if player:HasCollectible(mod.ITEM.COLLECTIBLE.TRICOLOR_KEY) then
                        persistData.friend = player
                        persistData.Unlock = true
                        player:AnimateCollectible(mod.ITEM.COLLECTIBLE.TRICOLOR_KEY, "UseItem", "PlayerPickup")
                        sfx:Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET, 1, 0, false, math.random(147,153)/100)
                    end
                end
            end
        end

        --Dungeon Master stuff
        for _, keyfiend in pairs(Isaac.FindByType(mod.FF.KeyFiend.ID, mod.FF.KeyFiend.Var, FiendFolio.KeyBlockToEvilGhostMap[customGridTypeName], false, false)) do
            if mod:GetEntityData(keyfiend).State == "Fly" and room:GetGridIndex(keyfiend.Position) == room:GetGridIndex(position) then
                persistData.Unlock = true
                persistData.friend = keyfiend
                mod:GetEntityData(keyfiend).State = "Poof"
            end
        end
        if customGridTypeName == "FFKeyBlockGray" then
            for _, dungeonmaster in pairs(Isaac.FindByType(mod.FF.DungeonMaster.ID, mod.FF.DungeonMaster.Var, -1, false, false)) do
                if dungeonmaster:ToNPC().I1 == 1 and dungeonmaster.Position:Distance(customGrid.GridEntity.Position) < 75 then
                    if dungeonmaster:GetSprite():IsEventTriggered("Shoot") then
                        persistData.Unlock = true
                        persistData.friend = dungeonmaster
                        sfx:Play(SoundEffect.SOUND_METAL_BLOCKBREAK)
                    end
                end
            end
        end

    elseif persistData.Unlock then
        persistData.Unlock = nil
        persistData.BreakStarted = persistData.FrameCount

        local function addNeighbors(queue, frameOffset, idx, width)
            table.insert(queue, { frameOffset, idx - 1,        })
            table.insert(queue, { frameOffset, idx + 1,        })
            table.insert(queue, { frameOffset, idx - width,    })
            table.insert(queue, { frameOffset, idx + width,    })
        end

        local width = room:GetGridWidth()

        -- do a BFS over neighbors to trigger breaks
        local queue = {}
        addNeighbors(queue, 0, spawnIndex, width)
        local visited = {}

        repeat
            local breakFrameOffset, idx = table.unpack(table.remove(queue, 1))
            if not visited[idx] then
                visited[idx] = true
                local grid = StageAPI.GetCustomGrid(idx, FiendFolio.KeytoChainBlock[customGridTypeName])
                if grid then
                    local breakFrameDelay = breakFrameOffset + grid.PersistentData.BreakDelay
                    grid.PersistentData.BreakStarted = math.min(grid.PersistentData.FrameCount + breakFrameDelay,
                                                             grid.PersistentData.BreakStarted or math.maxinteger)
                    addNeighbors(queue, grid.PersistentData.BreakStarted - grid.PersistentData.FrameCount, idx, width)
                end
            end
        until #queue == 0
    end
end

function mod.lockSpawn(customGrid)
    local persistData = customGrid.PersistentData
    if persistData.BreakStarted then
        local room = game:GetRoom()
        local savedPos = room:GetGridIndex(customGrid.GridEntity.Position)
        for k = 1, 3 do
            mod.scheduleForUpdate(function()
                local room = game:GetRoom()
                room:SpawnGridEntity(savedPos, GridEntityType.GRID_DECORATION, 0, 0, 0)
            end, k, nil, true)
        end
        customGrid:Remove()
        return
    end

    persistData.FrameCount = 0
    persistData.BreakDelay = (persistData.SpawnerEntity and persistData.SpawnerEntity.SubType) or 20

    if mod.ColourBlindMode then
        local repl = FiendFolio.ColorBlindBlocks[customGrid.GridConfig.Name]
        if repl then
            local s = customGrid.GridEntity:GetSprite()
            s:ReplaceSpritesheet(0, repl)
            s:LoadGraphics()
        end
    end
end

for _, grid in pairs(FiendFolio.KeyBlockGrid) do
    StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_UPDATE", 1, mod.lockAI, grid.Name)
    StageAPI.AddCallback("FiendFolio", "POST_SPAWN_CUSTOM_GRID", 1, mod.lockSpawn, grid.Name)
end

for _, grid in pairs(FiendFolio.ChainBlockGrid) do
    StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_UPDATE", 1, mod.commonBlockAI, grid.Name)
    StageAPI.AddCallback("FiendFolio", "POST_SPAWN_CUSTOM_GRID", 1, mod.lockSpawn, grid.Name)
end

local puzzleKeyRNG = RNG()
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local room = game:GetRoom()
    local level = game:GetLevel()
    if room:IsFirstVisit() and level:GetStage() <= 2 and level:GetStageType() >= StageType.STAGETYPE_REPENTANCE and StageAPI.GetDimension() == 1 then
        local matchingSpawns = {}
        local spawnList = {}
        StageAPI.ForAllSpawnEntries(level:GetCurrentRoomDesc().Data, function(entry, spawn)
            if entry.Type == EntityType.ENTITY_PICKUP and entry.Variant == mod.PICKUP.VARIANT.PUZZLE_KEY then
                matchingSpawns[spawn.X] = matchingSpawns[spawn.X] or {}
                if not matchingSpawns[spawn.X][spawn.Y] then
                    matchingSpawns[spawn.X][spawn.Y] = spawn
                    spawnList[#spawnList + 1] = spawn
                end
            end
        end)

        if #spawnList > 0 then
            puzzleKeyRNG:SetSeed(room:GetSpawnSeed(), 35)
            local width = StageAPI.RoomShapeToWidthHeight[room:GetRoomShape()].Width
            for _, spawn in ipairs(spawnList) do
                local entry = spawn:PickEntry(puzzleKeyRNG:RandomFloat())
                if entry.Type == EntityType.ENTITY_PICKUP and entry.Variant == mod.PICKUP.VARIANT.PUZZLE_KEY then
                    local index = StageAPI.VectorToGrid(spawn.X, spawn.Y, width)
                    Isaac.Spawn(entry.Type, entry.Variant, entry.Subtype, room:GetGridPosition(index), Vector.Zero, nil)
                end
            end
        end
    end
end)

local rerollingPuzzleKeys = {}
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function()
    for _, puzzleKey in ipairs(rerollingPuzzleKeys) do
        puzzleKey[1]:ToPickup():Morph(EntityType.ENTITY_PICKUP, mod.PICKUP.VARIANT.PUZZLE_KEY, puzzleKey[2])
        puzzleKey[1]:GetSprite():SetLastFrame()
        if puzzleKey[1]:ToPickup().Touched then
            puzzleKey[1]:Update()
            puzzleKey[1].Visible = false
            puzzleKey[1].EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        end
    end

    rerollingPuzzleKeys = {}
end, CollectibleType.COLLECTIBLE_D20)

mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, function()
    rerollingPuzzleKeys = {}
    for _, puzzleKey in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, mod.PICKUP.VARIANT.PUZZLE_KEY)) do
        rerollingPuzzleKeys[#rerollingPuzzleKeys + 1] = {puzzleKey, puzzleKey.SubType}
    end
end, CollectibleType.COLLECTIBLE_D20)

local puzzleKeyBadCards = {
    Card.CARD_ACE_OF_CLUBS,
    Card.CARD_ACE_OF_HEARTS,
    Card.CARD_ACE_OF_SPADES,
    Card.CARD_ACE_OF_DIAMONDS,
    Card.RUNE_BLACK
}

local function fixRerolledPuzzleKeys()
    for _, puzzleKey in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, mod.PICKUP.VARIANT.PUZZLE_KEY)) do
        for _, pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
            if pickup.Variant ~= puzzleKey.Variant
            and pickup.Position.X == puzzleKey.Position.X and pickup.Position.Y == puzzleKey.Position.Y then
                pickup:Remove()
            end
        end

        for _, familiar in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR)) do
            if (familiar.Variant == FamiliarVariant.BLUE_FLY or familiar.Variant == FamiliarVariant.BLUE_SPIDER)
            and (familiar.Position.X == puzzleKey.Position.X and familiar.Position.Y == puzzleKey.Position.Y) then
                familiar:Remove()
            end
        end

        local new = Isaac.Spawn(puzzleKey.Type, puzzleKey.Variant, puzzleKey.SubType, puzzleKey.Position, puzzleKey.Velocity, puzzleKey.SpawnerEntity)
        new.Parent = puzzleKey.Parent
        new:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        new:GetSprite():SetLastFrame()
        if puzzleKey:ToPickup().Touched then
            new:Update()
            new.Visible = false
            new.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        end
    end
end
	
local function fixRerolledGateKeys()
    for _, ent in ipairs(Isaac.GetRoomEntities()) do -- forgive me but gatekeys need no query for other stuff so here we are, at least this isnt running all the time
        if ent.Type == EntityType.ENTITY_PICKUP and ent.Variant == mod.PICKUP.VARIANT.GATECURSE_KEY then
			for _, pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
				if pickup.Variant ~= ent.Variant
				and pickup.Position.X == ent.Position.X and pickup.Position.Y == ent.Position.Y then
					pickup:Remove()
				end
			end

			for _, familiar in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR)) do
				if (familiar.Variant == FamiliarVariant.BLUE_FLY or familiar.Variant == FamiliarVariant.BLUE_SPIDER)
				and (familiar.Position.X == ent.Position.X and familiar.Position.Y == ent.Position.Y) then
					familiar:Remove()
				end
			end

			local new = Isaac.Spawn(ent.Type, ent.Variant, ent.SubType, ent.Position, ent.Velocity, ent.SpawnerEntity)
			new.Parent = ent.Parent
			if ent.Parent then ent.Parent.Child = new end
			new:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			new:GetSprite():SetLastFrame()
			if ent:ToPickup().Touched then
				new:Update()
				new.Visible = false
				new.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			end
        end
    end
end

for _, card in ipairs(puzzleKeyBadCards) do
    mod:AddEntityCallback(ModCallbacks.MC_USE_CARD, EntityType.ENTITY_PICKUP, mod.PICKUP.VARIANT.PUZZLE_KEY, -1, fixRerolledPuzzleKeys, card)
    mod:AddEntityCallback(ModCallbacks.MC_USE_CARD, EntityType.ENTITY_PICKUP, mod.PICKUP.VARIANT.GATECURSE_KEY, -1, fixRerolledGateKeys, card)
end
