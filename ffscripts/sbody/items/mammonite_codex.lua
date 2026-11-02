local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

local mammoniteRoomsMain = include("resources.luarooms.mammonite_codex")
local mammoniteRoomsTrinket = {}

local listTrinketStart
for i, room in ipairs(mammoniteRoomsMain) do
  if room.TYPE == RoomType.ROOM_DEFAULT then
    listTrinketStart = i
    break
  end
end
mammoniteRoomsTrinket = { table.unpack(mammoniteRoomsMain, listTrinketStart, #mammoniteRoomsMain) }
mammoniteRoomsMain = { table.unpack(mammoniteRoomsMain, 1, listTrinketStart-1) }

local mammoniteRoomsListMain = StageAPI.RoomsList("MammoniteCodexRoomsMain", mammoniteRoomsMain)
local mammoniteRoomsListTrinket = StageAPI.RoomsList("MammoniteCodexRoomsTrinket", mammoniteRoomsTrinket)

local function initMammoniteDimensionData()
  return {
    pickedUpRocks = 0,
    rocksLimit = 0,
    npcState = 0,               -- 0:inactive;   1:awake;   2:smelting    3:finish
    warpBackTo = {},            -- room
    --rockTrackerBuffer = {},
  }
end

local ITEM_PORTRAIT = {
  TRINKET = {
    VANILLA = {
      COL_START = 0,
      ROW_WIDTH = 20,
      --with repentogon's version freeze trinket portraits are not available so i gotta use a dupe
      PATH = "gfx/ui/death items_vanilla.png",
      GROUPS = {
        {
          START = {
            ID = TrinketType.TRINKET_SWALLOWED_PENNY,
            X = 0, Y = 38,
          },
          END = { ID = TrinketType.TRINKET_ISAACS_FORK },
        }, {
          START = {
            ID = TrinketType.TRINKET_MISSING_PAGE,
            X = 6, Y = 40,
            OFFSET = 6,
          },
          END = { ID = TrinketType.TRINKET_BROWN_CAP },
        }, {
          START = {
            ID = TrinketType.TRINKET_MECONIUM,
            X = 0, Y = 43,
          },
          END = { ID = TrinketType.TRINKET_FINGER_BONE },
        }, {
          START = {
            ID = TrinketType.TRINKET_JAW_BREAKER,
            X = 0, Y = 45,
          },
          END = { ID = TrinketType.NUM_TRINKETS - 1 },
        },
      }
    },
    FIEND_FOLIO = {
      COL_START = 17,
      ROW_WIDTH = 16,
      GROUPS = {
        {
          START = {
            ID = Isaac.GetTrinketIdByName("Shard of China"),
            X = 17, Y = 0,
          },
          END = { ID = Isaac.GetTrinketIdByName("Red Ribbon") },
        }, {
        -- Reheated
          START = {
            ID = Isaac.GetTrinketIdByName("Flea of Meltdown"),
            X = 21, Y = 1,
            OFFSET = 4,
          },
          END = { ID = Isaac.GetTrinketIdByName("Bomb Token") },
        }, {
        -- RELOADED
          START = {
            ID = Isaac.GetTrinketIdByName("Shampoo Bottle"),
            X = 17, Y = 5,
          },
          END = { ID = Isaac.GetTrinketIdByName("Joy Buzzer") },
        }, {
          START = {
            ID = Isaac.GetTrinketIdByName("Internalized Hatred"),
            X = 28, Y = 6,
            OFFSET = 11,
          },
          END = { ID = Isaac.GetTrinketIdByName("Shadow Mantle") },
        }, {
          START = {
            ID = Isaac.GetTrinketIdByName("Dad's USB"),
            X = 18, Y = 11,
            OFFSET = 1,
          },
          END = { ID = Isaac.GetTrinketIdByName("Constellation Penny") },
        }, {
        -- BONUS PENNIES
          START = {
            ID = Isaac.GetTrinketIdByName("Bent Penny"),
            X = 17, Y = 12,
          },
          END = { ID = Isaac.GetTrinketIdByName("Brazilian Penny") },
        }, {
        -- CURSED TRINKETS
          START = {
            ID = Isaac.GetTrinketIdByName("Wife Hat"),
            X = 17, Y = 15,
          },
          END = { ID = Isaac.GetTrinketIdByName("Wife Hat") },
        }, {
        -- ROCKS
          START = {
            ID = Isaac.GetTrinketIdByName("Dirt Clump"),
            X = 17, Y = 16,
          },
          END = { ID = Isaac.GetTrinketIdByName("Ancient Effigy") },
        }, {
        -- PEBBLE ROCKS
          START = {
            ID = Isaac.GetTrinketIdByName("Knife Pebble"),
            X = 17, Y = 26,
          },
          END = { ID = Isaac.GetTrinketIdByName("     Mixed Pebble     ") },
        }, {
        -- GRIMLINS
          START = {
            ID = Isaac.GetTrinketIdByName("Grimlin"),
            X = 17, Y = 27,
          },
          END = { ID = Isaac.GetTrinketIdByName("Sensory Grimlin") },
        }, {
        -- FOSSILS
          START = {
            ID = Isaac.GetTrinketIdByName("Breakfast Fossil"),
            X = 17, Y = 28,
          },
          END = { ID = Isaac.GetTrinketIdByName("Fossilized Eye") },
        }, {
        -- GEODES
          START = {
            ID = Isaac.GetTrinketIdByName("Curved Geode"),
            X = 17, Y = 31,
          },
          END = { ID = Isaac.GetTrinketIdByName("The Strongest Geode") },
        }, {
        -- GEODE FOSSILS
          START = {
            ID = Isaac.GetTrinketIdByName("Geode Fossil"),
            X = 32, Y = 26,
            OFFSET = 15,
          },
          END = { ID = Isaac.GetTrinketIdByName("Geode Fossil") },
        },
      }
    }
  }
}

--[[
FiendFolio.savedata.run.level.TooManyOptions = FiendFolio.savedata.run.level.TooManyOptions or {}
local savedata = FiendFolio.savedata.run.level.TooManyOptions
]]

-- █■■■■■■■█
-- █ GRIDS █
-- █■■■■■■■█

FiendFolio.MammoniteTrapdoorGrid = StageAPI.CustomGrid("FFMammoniteTrapdoor", {
  BaseType = GridEntityType.GRID_DECORATION,
  BaseVariant = 20,
  --Anm2 = "gfx/grid/mammonite_trapdoor.anm2",
  --Animation = "Opened",
  RemoveOnAnm2Change = true,
  OverrideGridSpawns = true,
  SpawnerEntity = { Type = FiendFolio.FFID.Grid, Variant = 1124 }
})

FiendFolio.MammoniteLadderGrid = StageAPI.CustomGrid("FFMammoniteLadder", {
  BaseType = GridEntityType.GRID_DECORATION,
  BaseVariant = 10,
  --Anm2 = "gfx/grid/mammonite_ladder.anm2",
  --Animation = "Opened",
  RemoveOnAnm2Change = true,
  OverrideGridSpawns = true,
  SpawnerEntity = { Type = FiendFolio.FFID.Grid, Variant = 1125 }
})

local mammoniteGridData = {
  {
    anm2 = "gfx/grid/mammonite_trapdoor.anm2",                -- Regular trapdoor
  },
  {
    anm2 = "gfx/grid/mammonite_ladder.anm2",                  -- Regular ladder
    spriteOffset = Vector(0, -30),
    hitbox = {Vector(-18, -20), Vector(18, 0)},
  },
  {
    anm2 = "gfx/grid/mammonite_crawlspace_trapdoor.anm2",     -- Crawlspace trapdoor
    spriteOffset = Vector(0, -18),
    hitbox = {Vector(-20, 0), Vector(20, 20)},
  },
  {
    anm2 = "gfx/grid/mammonite_crawlspace_ladder.anm2",       -- Crawlspace ladder
    hitbox = {Vector(-20, -80), Vector(20, -40)},
  },
}

local function InitMammoniteTrapdoor(type, customGrid)

  local grid = customGrid.GridEntity
  local room = game:GetRoom()

  --customGrid.PersistentData.brTest = type(StageAPI.GetCurrentRoomID()) == "number"
  customGrid.PersistentData.brTest = BasementRenovator and BasementRenovator.InTestRoom and BasementRenovator.InTestStage
    and (BasementRenovator:InTestRoom() or BasementRenovator:InTestStage())

  local idx = 1
  if type == "FFMammoniteLadder" then idx = idx + 1 end
  if room:GetType() == RoomType.ROOM_DUNGEON then idx = idx + 2 end
  customGrid.Data.TDoorVariant = idx

  customGrid.PersistentData.gHitbox = mammoniteGridData[idx].hitbox

  -- GFX
  if idx == 1 then
    local index = customGrid.GridIndex
    local sprite = StageAPI.SpawnFloorEffect(room:GetGridPosition(index), Vector.Zero, nil,
      "gfx/grid/mammonite_trapdoor.anm2", true)
    sprite:GetSprite():Play("Opened", true)
    customGrid.Data.Trapdoor = sprite
  elseif idx == 2 or idx == 3 then
    local index = customGrid.GridIndex
    local sprOffset = mammoniteGridData[idx].spriteOffset
    local sprite = Isaac.Spawn(1000, 6, 0, room:GetGridPosition(index) + sprOffset, Vector.Zero, nil)   -- dont look at this
    sprite:GetSprite():Load(mammoniteGridData[idx].anm2, true)
    sprite:GetSprite():Play("Opened", true)
    customGrid.Data.Trapdoor = sprite
  else
    local sprite = grid:GetSprite()
    sprite:Load(mammoniteGridData[idx].anm2, true)
    sprite:Play("Opened")
  end

  if idx == 4 then
    local idxAbove = room:GetGridIndex(customGrid.Position - Vector(0, 40) )
    room:RemoveGridEntityImmediate(idxAbove, 0, false)
    room:SpawnGridEntity(idxAbove, 1, 10, 0, 0)
    room:SpawnGridEntity(customGrid.GridIndex, 1, 10, 0, 0)

    --[[
    local hitbox = Isaac.Spawn(FiendFolio.FF.Hitbox.ID, FiendFolio.FF.Hitbox.Var, 0, Vector(customGrid.Position.X, 80), Vector.Zero, nil)
    hitbox.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
    hitbox:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS)
    hitbox.SpawnerEntity = Isaac.GetPlayer(0)
    mod:GetEntityData(hitbox).Width = 40
    mod:GetEntityData(hitbox).Height = 20
    mod:GetEntityData(hitbox).MammonniteLadder = true
    mod:GetEntityData(hitbox).customGrid = customGrid
    customGrid.Data.Hitbox = hitbox
    ]]
  end

  FiendFolio.savedata.run.level.mammoniteDimension = FiendFolio.savedata.run.level.mammoniteDimension or initMammoniteDimensionData()
  local savedata = FiendFolio.savedata.run.level.mammoniteDimension
  customGrid.PersistentData.blocked = (savedata.npcState == 2 or savedata.npcState == 3)
  customGrid.PersistentData.playerOnArea = true
end

-- TODO: failsafe
--[[
mod:AddCallback(ModCallbacks.MC_PRE_CHANGE_ROOM, function()
  print(Isaac.GetPlayer(0).Position)                          -- Y: 120
end)
]]

StageAPI.AddCallback("FiendFolio", "POST_SPAWN_CUSTOM_GRID", 1, function(customGrid)
  InitMammoniteTrapdoor("FFMammoniteTrapdoor", customGrid)
end, "FFMammoniteTrapdoor")

StageAPI.AddCallback("FiendFolio", "POST_SPAWN_CUSTOM_GRID", 1, function(customGrid)
  InitMammoniteTrapdoor("FFMammoniteLadder", customGrid)
end, "FFMammoniteLadder")

--[[
mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, function(_, npc, collider)
  if npc.SubType == 0 and mod:GetEntityData(npc).MammonniteLadder then
    SFXManager():Play(SoundEffect.SOUND_METAL_BLOCKBREAK, 0.5, 0, false, 0.8)
  end
end, FiendFolio.FF.Hitbox.ID)
]]

local function MammoniteTrapdoorUpdate(type, customGrid)
  if customGrid.PersistentData.brTest or customGrid.PersistentData.blocked then return end
  -- TODO: bring back the hitbox on crawlspace ladder
  --[[
  if customGrid.Data.Hitbox and customGrid.Data.Hitbox.FrameCount == 1 then
    customGrid.Data.Hitbox.Position = customGrid.Data.Hitbox.Position - Vector(0, 3)    -- esto es una bosta
  end
  ]]
  local gPos = customGrid.Position
  local playerOnArea = customGrid.PersistentData.playerOnArea
  local h = customGrid.PersistentData.gHitbox
  local anyOnArea = false
  for i = 0, game:GetNumPlayers() - 1 do
    local player = Isaac.GetPlayer(i)
    if player.Parent == nil then    -- Strawman / Soulstones / Mini-Biends
      local pPos = player.Position

      if h then
        anyOnArea = (gPos+h[1]).X < pPos.X and pPos.X < (gPos+h[2]).X and (gPos+h[1]).Y < pPos.Y and pPos.Y < (gPos+h[2]).Y     -- custom area
      else
        anyOnArea = pPos:DistanceSquared(gPos) < (20 + player.Size) ^ 2 and player:IsExtraAnimationFinished()                   -- default square area
      end
      if anyOnArea then
        break
      end
    end
  end
  if anyOnArea then
    if playerOnArea == false then
      customGrid.PersistentData.playerOnArea = true
      local currentRoom = StageAPI.GetCurrentRoom()
      local roomT = currentRoom.PersistentData.mammoniteDim.descendTo
      local dir = Direction.DOWN
      if (customGrid.Data.TDoorVariant % 2) == 0 then
        roomT = currentRoom.PersistentData.mammoniteDim.ascendTo
        dir = Direction.UP
      end
      local roomData = StageAPI.GetDefaultLevelMap():GetRoomDataFromRoomID(roomT.ID)
      --StageAPI.ExtraRoomTransition(roomData.MapID, dir, RoomTransitionAnim.MAZE, StageAPI.DefaultLevelMapID, nil, roomT.Side)
      customGrid.PersistentData.blocked = true
      StageAPI.ExtraRoomTransition(roomData.MapID, dir, RoomTransitionAnim.MAZE, StageAPI.DefaultLevelMapID, nil, roomT.Side, roomT.Pos)
    end
  else
    customGrid.PersistentData.playerOnArea = false
  end
end

StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_UPDATE", 1, function(customGrid)
  MammoniteTrapdoorUpdate("FFMammoniteTrapdoor", customGrid)
end, "FFMammoniteTrapdoor")

StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_UPDATE", 1, function(customGrid)
  MammoniteTrapdoorUpdate("FFMammoniteLadder", customGrid)
end, "FFMammoniteLadder")


-- █■■■■■■■■■■■■■■■■■█
-- █ ROOM GENERATION █
-- █■■■■■■■■■■■■■■■■■█

local function GridAxisToPos(X, Y)
  return Vector((X + 2) * 40, (Y + 4) * 40)
end

local mDimTrinketsPool = {}
for id, _ in pairs(FiendFolio.RockTrinkets) do
  if not inBlacklist then
    table.insert(mDimTrinketsPool, id)
  end
end
for id, _ in pairs(FiendFolio.GolemTrinketWhitelist) do
  if not inBlacklist then
    table.insert(mDimTrinketsPool, id)
  end
end
table.sort(mDimTrinketsPool, function(a, b) return a < b end )

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, _, _, player)
  local defaultMap = StageAPI.GetDefaultLevelMap()
  local warpPoint = defaultMap:GetRoomDataFromRoomID("mammoniteEntrance")

  FiendFolio.savedata.run.level.mammoniteDimension = FiendFolio.savedata.run.level.mammoniteDimension or initMammoniteDimensionData()
  local savedata = FiendFolio.savedata.run.level.mammoniteDimension
  savedata.rocksLimit = savedata.rocksLimit + 3

  if warpPoint then
    savedata.npcState = 1
  else
    savedata.npcState = 0

    -- [ ENTRY ROOM ]
    local mammoniteEntrance = StageAPI.LevelRoom {
      LayoutName = "Entrance",
      RoomsList = mammoniteRoomsListMain,
      IgnoreDoors = true,
      Shape = RoomShape.ROOMSHAPE_IH,
      RoomType = RoomType.ROOM_MINIBOSS,
		  RequireRoomType = true,
      IsExtraRoom = true,
    }
    mammoniteEntrance.Layout.Name = "???"
    mammoniteEntrance.Layout.Variant = ""
    warpPoint = defaultMap:AddRoom(mammoniteEntrance, { RoomID = "mammoniteEntrance" }, true)
    mammoniteEntrance.PersistentData.mammoniteDim = { customBackdrop = "gfx/backdrop/mammonite_dim_closet.anm2" }

    -- [ MAIN ROOM ]
    local mammoniteMain = StageAPI.LevelRoom {
      LayoutName = "Main room",
      RoomsList = mammoniteRoomsListMain,
      IgnoreDoors = true,
      Shape = RoomShape.ROOMSHAPE_1x1,
      RoomType = RoomType.ROOM_MINIBOSS,
		  RequireRoomType = true,
      IsExtraRoom = true,
    }
    mammoniteMain.Layout.Name = "???"
    mammoniteMain.Layout.Variant = ""
    defaultMap:AddRoom(mammoniteMain, { RoomID = "mammoniteMain" }, true)
    mammoniteMain.PersistentData.mammoniteDim = { descendTo = { ID = "mammoniteDescent", Side = 1, Pos = Vector(320, 160) } }

    -- [ DESCENT ROOM ]
    local mammoniteDescent = StageAPI.LevelRoom {
      LayoutName = "Descent",
      RoomsList = mammoniteRoomsListMain,
      IgnoreDoors = true,
      Shape = RoomShape.ROOMSHAPE_1x2,
      RoomType = RoomType.ROOM_DUNGEON,
		  RequireRoomType = true,
      IsExtraRoom = true,
    }
    mammoniteDescent.Layout.Name = "???"
    mammoniteDescent.Layout.Variant = ""
    defaultMap:AddRoom(mammoniteDescent, { RoomID = "mammoniteDescent" }, true)
    mammoniteDescent.PersistentData.mammoniteDim = { ascendTo = { ID = "mammoniteMain", Side = 1, Pos = Vector(320, 320) } }

    local generatedTrinkets = 0
    local idx = 0
    local gridLadderSide = 1      -- left: 1;   right: 5
    local gridLadderPos
    local gridTrapdoorSide = 3    -- left: 3;   right: 7
    local gridTrapdoorPos = Vector(320, 640)
    local prevRoom = mammoniteDescent
    local prevRoomID = "mammoniteDescent"
    while generatedTrinkets < #mDimTrinketsPool do          -- create rooms until all rocks are generated...
      idx = idx + 1
      local rType = RoomType.ROOM_DEFAULT
      if (idx % 2) == 0 then                                -- ...alternating between normal and crawlspace rooms
        rType = RoomType.ROOM_DUNGEON
      end
      local newRoom = StageAPI.LevelRoom {
        RoomsList = mammoniteRoomsListTrinket,
        IgnoreDoors = true,
        IgnoreShape = true,
        RoomType = rType,
		    RequireRoomType = true,
        IsExtraRoom = true,
      }
      --newRoom.Layout.Variant = ""
      local roomId = "mammoniteTrinketRoom" .. idx
      defaultMap:AddRoom(newRoom, { RoomID = roomId }, true)

      newRoom.PersistentData.mammoniteDim = { ascendTo = { ID = prevRoomID, Side = gridTrapdoorSide, Pos = gridTrapdoorPos }, trinketRoom = true }

      local gridTrapdoorIdx
      local spawnsIdxs = {}                                       -- get all spawns from the room that are trinkets...
      local SpawnEntities = newRoom.SpawnEntities
      for i, _ in pairs(SpawnEntities) do
        local eRef = SpawnEntities[i][1].Data
        if eRef.Type == 5 and eRef.Variant == 350 then
          table.insert(spawnsIdxs, i)
        elseif eRef.Type == mod.FFID.Grid then
          if eRef.Variant == 1124 then
            gridTrapdoorIdx = i
            gridTrapdoorSide = (eRef.GridX > 12 and 7) or 3
            gridTrapdoorPos = GridAxisToPos(eRef.GridX, eRef.GridY)
          elseif eRef.Variant == 1125 then
            gridLadderSide = (eRef.GridX > 12 and 5) or 1
            gridLadderPos = GridAxisToPos(eRef.GridX, eRef.GridY)
          end
        end
      end
      table.sort(spawnsIdxs, function(a, b) return a < b end )    -- ...and sort em so rocks generate from left-right and top-bottom
      for _, i in ipairs(spawnsIdxs) do
        local eRef = SpawnEntities[i][1].Data
        if generatedTrinkets < #mDimTrinketsPool then                   -- replace trinket with rock from pool...
          if mDimTrinketsPool[generatedTrinkets+1] ~= mod.ITEM.ROCK.UNOBTAINIUM then
            eRef.SubType = mDimTrinketsPool[generatedTrinkets+1]
          else
            SpawnEntities[i][1].Persistent = false
            SpawnEntities[i][1].PersistentIndex = nil
            eRef.Type = 1000
            eRef.Variant = 15
            eRef.SubType = 1
          end
          generatedTrinkets = generatedTrinkets + 1
        else                                                            -- ...or delete trinket from room if all rocks generated
          SpawnEntities[i] = nil
        end
      end

      if not (generatedTrinkets < #mDimTrinketsPool) then
        if rType == RoomType.ROOM_DUNGEON then
          local gridX = SpawnEntities[gridTrapdoorIdx][1].Data.GridX
          local gridY = SpawnEntities[gridTrapdoorIdx][1].Data.GridY
          newRoom.SpawnGrids[gridTrapdoorIdx] = {
            GridX = gridX,
            GridY = gridY,
            Weight = 1,
            Index = gridTrapdoorIdx,
            Type = GridEntityType.GRID_GRAVITY,
            SubType = 0,
            Variant = 0,
          }
          newRoom.GridTakenIndices[gridTrapdoorIdx] = true
        end
        newRoom.SpawnEntities[gridTrapdoorIdx] = nil        -- remove last trapdoor if all trinkets were generated
      end

      prevRoom.PersistentData.mammoniteDim.descendTo = { ID = roomId, Side = gridLadderSide, Pos = gridLadderPos }

      prevRoom = newRoom
      prevRoomID = roomId

      --print("Room ".. roomId .. " created. " .. generatedTrinkets .. "/" .. #mDimTrinketsPool .. " trinkets generated")
    end

  end

  --player:AddControlsCooldown(15)
  mod.scheduleForUpdate(function()
    local currentRoom = StageAPI.GetCurrentRoom()
    if not(currentRoom and currentRoom.PersistentData and currentRoom.PersistentData.mammoniteDim) then
      local roomID = StageAPI.GetCurrentRoomID()
      if type(roomID) == "number" then
        savedata.warpBackTo = {
          ID = game:GetLevel():GetCurrentRoomIndex(),
          vanillaRoom = true,
        }
      else
        savedata.warpBackTo = {
          ID = roomID,
          vanillaRoom = false,
        }
      end
    end
    StageAPI.ExtraRoomTransition(warpPoint.MapID, Direction.NO_DIRECTION, RoomTransitionAnim.TELEPORT, StageAPI.DefaultLevelMapID, nil, nil)
  end, 15, nil, true)

  --TODO: change in xml
  player:RemoveCollectible(mod.ITEM.COLLECTIBLE.MAMMONITE_CODEX, false, ActiveSlot.SLOT_PRIMARY, true)
  return true
end, mod.ITEM.COLLECTIBLE.MAMMONITE_CODEX)

local MammoniteDoor = StageAPI.CustomDoor(
    "MammoniteDoor",
    "gfx/grid/mammonite dimension/door_mammonite.anm2",
    nil, nil, nil, nil,
    false,
    true
)

-- █■■■■■■■■■■■█
-- █ ROOM INIT █
-- █■■■■■■■■■■■█

local function overrideVeil(p)
  if p.Type == EntityType.ENTITY_PICKUP and p.Variant == PickupVariant.PICKUP_TRINKET then
    -- a bit redundant to double check but oh well
    local currentRoom = StageAPI.GetCurrentRoom()
    local currentData = currentRoom and currentRoom.PersistentData
    if currentData and currentData.mammoniteDim then
      return true
    end
  end
end

--StageAPI.AddCallback("FiendFolio", "POST_ROOM_LOAD", 1, function(currentRoom, isFirstLoad, _)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()

  local currentRoom = StageAPI.GetCurrentRoom()
  local currentData = currentRoom and currentRoom.PersistentData
  if currentData and currentData.mammoniteDim then

    for i = 1, game:GetNumPlayers() do
      Isaac.GetPlayer(i - 1).Velocity = RandomVector() / 10000
      --local player = Isaac.GetPlayer(i - 1)
      --player.Velocity = Vector.Zero
    end

    local isFirstLoad = currentRoom.VisitCount == 1
    local ms = MusicManager()

    -- room gfx
    if game:GetRoom():GetType() == RoomType.ROOM_DUNGEON then
      StageAPI.ChangeRoomGfx(mod.CrawlspaceMammoniteBackdrop)
      mod.scheduleForUpdate(function()
        mod.ReplaceCrawlspaceTileGfx('gfx/grid/mammonite dimension/tiles_itemdungeon_mammonite.png')
      end, 1, ModCallbacks.MC_INPUT_ACTION, true)
    else
      if not currentData.mammoniteDim.customBackdrop then
        --currentRoom.Data.RoomGfx = mod.MammoniteBackdrop
        StageAPI.ChangeRoomGfx(mod.MammoniteBackdrop)
      else
        --might be possible to use StageAPI.ChangeBackdrop() but i cant bother figuring it out so im reusing code
        local backdropEntity = Isaac.Spawn(StageAPI.E.Backdrop.T, StageAPI.E.Backdrop.V, 0, Vector.Zero, Vector.Zero, nil)
        local sprite = backdropEntity:GetSprite()
        sprite:Load(currentData.mammoniteDim.customBackdrop, true)
        sprite:SetFrame("Idle", 1)
        backdropEntity.SpriteOffset = ((game:GetRoom():GetTopLeftPos() - Vector(80, 160) ) / 40) * 26
        backdropEntity:AddEntityFlags(EntityFlag.FLAG_RENDER_WALL)
        backdropEntity:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR)

        StageAPI.ChangeGrids(mod.MammoniteBackdrop.Grids)
      end
    end

    -- doors
    local rID = StageAPI.GetCurrentRoomID()
    if isFirstLoad then
      local defaultMap = StageAPI.GetDefaultLevelMap()
      if rID == "mammoniteEntrance" then
        local room2 = defaultMap:GetRoomDataFromRoomID("mammoniteMain")
        StageAPI.SpawnCustomDoor(DoorSlot.RIGHT0, room2.MapID, StageAPI.DefaultLevelMapID, MammoniteDoor.Name)
      elseif rID == "mammoniteMain" then
        local room1 = defaultMap:GetRoomDataFromRoomID("mammoniteEntrance")
        StageAPI.SpawnCustomDoor(DoorSlot.LEFT0, room1.MapID, StageAPI.DefaultLevelMapID, MammoniteDoor.Name)
      end
    end

    FiendFolio.savedata.run.level.mammoniteDimension = FiendFolio.savedata.run.level.mammoniteDimension or initMammoniteDimensionData()
    local savedata = FiendFolio.savedata.run.level.mammoniteDimension

    if currentData.mammoniteDim.trinketRoom then
      -- trinkets
      for _, t in ipairs(Isaac.FindByType(5, 350, -1, false, false)) do
        --if FiendFolio.findKey(mDimTrinketsPool, function(id) return t.SubType == id end) then
        if FiendFolio.findKey(mDimTrinketsPool, function(id) return mod:GetRealTrinketId(t.SubType) == id end) then
          t:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
          mod:GetEntityData(t).mammoniteRock = true
        end
      end
      -- npc update
      if savedata.npcState == 0 then
        savedata.npcState = 1
        local defaultMap = StageAPI.GetDefaultLevelMap()
        for i, n in pairs({ "mammoniteEntrance", "mammoniteMain", "mammoniteDescent" }) do
          local roomData = defaultMap:GetRoomDataFromRoomID(n)
          local room = defaultMap:GetRoom(roomData)
          room.Layout.Name = ({ "Mammonite Ruins - Entrance", "Mammonite Ruins - Main room", "Mammonite Ruins - Descent" })[i]
          room.Layout.Variant = ({ 0, 1, 0 })[i]
        end
      end
    else
      -- darkness gfx
      if savedata.npcState == 0 then
        --game:GetLevel():GetCurrentRoomDesc().Flags = game:GetLevel():GetCurrentRoomDesc().Flags & ~RoomDescriptor.FLAG_PITCH_BLACK
        game:GetLevel():GetCurrentRoomDesc().Flags = game:GetLevel():GetCurrentRoomDesc().Flags | RoomDescriptor.FLAG_PITCH_BLACK
      elseif isFirstLoad and rID == "mammoniteTrinketRoom1" then
        --game:Darken(1, 1)       -- fade out darkness (doesnt work the way id like)
      end
    end

    --music update
    local musicID = mod.Music.BlackMarket
    if not mod.CustomMusicEnabled then
      musicID = Music.MUSIC_SECRET_ROOM
    end
    mod.scheduleForUpdate(function()
      if savedata.npcState == 0 then
        ms:Play(Music.MUSIC_MINESHAFT_AMBIENT, 0)
      elseif ms:GetCurrentMusicID() ~= musicID then
        ms:Play(musicID, 0)
        ms:UpdateVolume()
      end
    end, 1, ModCallbacks.MC_POST_RENDER)

  end
end)

-- music override
mod:AddCallback(ModCallbacks.MC_PRE_MUSIC_PLAY, function(_, ID, _, _)
  --FiendFolio.savedata.run.level.mammoniteDimension = FiendFolio.savedata.run.level.mammoniteDimension or initMammoniteDimensionData()
  --local savedata = FiendFolio.savedata.run.level.mammoniteDimension

  if Isaac.IsInGame() and game:GetRoom():GetFrameCount() == 0 then
    local currentRoom = StageAPI.GetCurrentRoom()
    local currentData = currentRoom and currentRoom.PersistentData
    --[[
    if StageAPI.GetCurrentRoomID() == "mammoniteDescent" and currentRoom.VisitCount == 1
      and ID ~= mod.Music.CrawlSpace and ID ~= mod.Music.BlackMarket and ID ~= Music.MUSIC_SECRET_ROOM
    then
      -- TODO: test with music mods. Use table if a single id is not enough
      savedata.overrideMusic = ID
    end
    ]]
    if
      currentData and currentData.mammoniteDim and
      ID ~= Music.MUSIC_MINESHAFT_AMBIENT and ID ~= Music.MUSIC_SECRET_ROOM and ID ~= mod.Music.BlackMarket
      --and ID == Music.MUSIC_BOSS_OVER or ID == mod.Music.CrawlSpace or ID == savedata.overrideMusic
    then
      return false
    end
  end
end)

-- █■■■■■■■■■■■■■■█
-- █ ROCK PICK UP █
-- █■■■■■■■■■■■■■■█

function GetTrinketPortrait(id)
  local res
  local sheetRes
  for n, sheet in pairs(ITEM_PORTRAIT.TRINKET) do
    for _, group in ipairs(sheet.GROUPS) do
      if id >= group.START.ID and id <= group.END.ID then
        local startOffset = group.START.OFFSET or 0
        local localOffset = id - group.START.ID + startOffset
        local gridOffset = Vector(localOffset % sheet.ROW_WIDTH, localOffset // sheet.ROW_WIDTH)
        res = 16 * (Vector(sheet.COL_START, group.START.Y) + gridOffset)
        sheetRes = {NAME = n, PATH = sheet.PATH}
        break
      end
    end
  end
  return res, sheetRes
end

local rocksIcons = {}
local rockTracker = {}
local rockTrackerBuffer = {}        -- TODO: add to savedata

local function queueRock(player, trinket)

  FiendFolio.savedata.run.level.mammoniteDimension = FiendFolio.savedata.run.level.mammoniteDimension or initMammoniteDimensionData()
  local savedata = FiendFolio.savedata.run.level.mammoniteDimension
  savedata.pickedUpRocks = savedata.pickedUpRocks + 1     -- TODO : move to trinket post remove

  local tID = mod:GetRealTrinketId(trinket.SubType)

  local sprite = Sprite()
  sprite:Load("gfx/effects/mammonite_rocks_tracker.anm2", false)
  local count = ((savedata.pickedUpRocks-1) % 3) + 1                   --1, 2, 3, 1, 2, 3, ...
  sprite:Play(tostring(count))

  if count == 1 then
    rockTrackerBuffer = {}    -- clear buffer
  end
  for i = 1, 2 do
    if rockTrackerBuffer[i] then
      sprite:GetLayer(i):SetCropOffset(rockTrackerBuffer[i].Offset)
      if rockTrackerBuffer[i].Sheet then
        sprite:ReplaceSpritesheet(i, rockTrackerBuffer[i].Sheet)
      end
    end
  end

  local offset, sheet = GetTrinketPortrait(tID)
  if offset then
    if sheet.NAME ~= "FIEND_FOLIO" then
      for i = 4, 10 do
        sprite:ReplaceSpritesheet(i, sheet.PATH)
      end
      sprite:ReplaceSpritesheet(count, sheet.PATH)
    end
    for i = 4, 10 do
      sprite:GetLayer(i):SetCropOffset(offset - Vector(272, 256))
    end
    sprite:GetLayer(count):SetCropOffset(offset - Vector(272, 256))
    rockTrackerBuffer[count] = {
      Offset = offset - Vector(272, 256),
      Sheet = sheet.PATH
    }
  end

  sprite:LoadGraphics()
  sprite.Offset = Vector(0, 15)

  table.insert(rockTracker, {
    Sprite = sprite,
    Trinket = tID,
    Player = player,
  })

  local playerData = EntitySaveStateManager.GetEntityData(mod, player)    --you may wonder why i dont use GetData().ffsavedata... idk
  if not playerData.mammoniteRocks then
    playerData.mammoniteRocks = {}
  end
  table.insert(playerData.mammoniteRocks, {
    ID = tID,     -- "real" id
    Golden = mod:IsGoldTrinket(trinket.SubType),
    Blasphemous =  mod:IsPickupTrinketBlasphemous(trinket) or false,
    Sprite = {
      File = trinket:GetSprite():GetFilename(),
      Play = trinket:GetSprite():GetAnimation() },
  })
  mod:GetEntityData(player).mammoniteRockTP = tID
end

-- i learned this one from brick rock
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, trinket, collider, _)
  FiendFolio.savedata.run.level.mammoniteDimension = FiendFolio.savedata.run.level.mammoniteDimension or initMammoniteDimensionData()
  local savedata = FiendFolio.savedata.run.level.mammoniteDimension
  if (savedata.npcState == 2 and mod:GetEntityData(trinket).mammoniteRock) or mod:GetEntityData(trinket).mammoniteSmelt then
    return false
  end
	if mod:GetEntityData(trinket).mammoniteRock and
	  collider.Type == EntityType.ENTITY_PLAYER and
	  collider.Variant == 0
	then
		local player = collider:ToPlayer()
    if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B then
      player = player:GetOtherTwin()
    end

		if player.Parent == nil and -- Strawman / Soulstones / Mini-Biends
		   not player:IsCoopGhost() and
		   player:IsExtraAnimationFinished()
		then
			player:AnimateTrinket(mod:GetRealTrinketId(trinket.SubType))
			sfx:Play(SoundEffect.SOUND_SHELLGAME, 1, 0, false, 1, 0)

			if mod:IsGoldTrinket(trinket.SubType) then
				player:GetHeldSprite():SetRenderFlags(player:GetHeldSprite():GetRenderFlags() | AnimRenderFlags.GOLDEN)
			end
			if mod:IsPickupTrinketBlasphemous(trinket) then
				mod:AddBlasphemousShader(player:GetHeldSprite())
			end

      queueRock(player, trinket)

      if savedata.pickedUpRocks >= savedata.rocksLimit then
        savedata.npcState = 2
        savedata.pickedUpRocks = 0
        savedata.rocksLimit = 0
      end

			trinket.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			trinket.Visible = false
			trinket:Remove()
		end

		return false
	end
end, PickupVariant.PICKUP_TRINKET)

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
  if mod:GetEntityData(player).mammoniteRockTP then
    if not player:IsHoldingItem() then
      local gfxPath = Isaac.GetItemConfig():GetTrinket(mod:GetEntityData(player).mammoniteRockTP).GfxFileName
      local sprite = Sprite()
      sprite:Load("gfx/effects/trinket_destroy.anm2", false)
      sprite:Play("TeleportUp")
      sprite:ReplaceSpritesheet(0, gfxPath)
      sprite:LoadGraphics()
      sprite.Offset = Vector(0, -40)

      table.insert(rocksIcons, {
        Sprite = sprite,
        Pos = player.Position + Vector(0, 2),
      })

      --sfx wont play on room transition
      mod.scheduleForUpdate(function()
        sfx:Play(SoundEffect.SOUND_HELL_PORTAL2, 1, 0, false, 1.1, 0)
      end, 0)

      mod:GetEntityData(player).mammoniteRockTP = nil
    end
  end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
  for k, tab in pairs(rocksIcons) do
    if not tab.Sprite:IsFinished() then
      tab.Sprite:Render(Isaac.WorldToScreen(tab.Pos), Vector.Zero, Vector.Zero)
      if not game:IsPaused() then
        tab.Sprite:Update()
      end
    else
      rocksIcons[k] = nil
    end
  end
  if rockTracker[1] then
    local hud = rockTracker[1]
    if not hud.Sprite:IsFinished() then
      hud.Sprite:Render(Isaac.WorldToScreen(hud.Player.Position + Vector(0, 1)), Vector.Zero, Vector.Zero)
      if hud.Sprite:IsEventTriggered('carve') then
        --local carvePos = hud.Player.Position + Vector(0, 40)
        --carvePos = carvePos + Vector(1, 0) * ({ -22, 0, 22 })[tonumber(hud.Sprite:GetAnimation())]
        --game:SpawnParticles(carvePos, EffectVariant.TOOTH_PARTICLE, 2, 1, Color.Default, 0, 124)
        sfx:Play(SoundEffect.SOUND_SCYTHE_BREAK, 1, 0, false, 1)
      end
      if not game:IsPaused() then
        hud.Sprite:Update()
      end
      if rockTracker[2] and rockTracker[2].Sprite:GetAnimation() ~= "1"
        and hud.Sprite:WasEventTriggered("check_queue_start") and not hud.Sprite:WasEventTriggered("check_queue_end")
      then
        rockTracker[2].Sprite:SetFrame(40)
        table.remove(rockTracker, 1)
      end
    else
      table.remove(rockTracker, 1)
    end
  end
end)

-- █■■■■■■■■■■■■█
-- █ ROCK SMELT █
-- █■■■■■■■■■■■■█

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
  if StageAPI.GetCurrentRoom() then
    local currentData = StageAPI.GetCurrentRoom().PersistentData
    if currentData.mammoniteDim then
      FiendFolio.savedata.run.level.mammoniteDimension = FiendFolio.savedata.run.level.mammoniteDimension or initMammoniteDimensionData()
      local savedata = FiendFolio.savedata.run.level.mammoniteDimension

      if savedata.npcState == 2 or savedata.npcState == 3 then
        for i = 1, game:GetNumPlayers() do
          local player = Isaac.GetPlayer(i - 1)
          --player.Velocity = Vector.Zero
          player.ControlsCooldown = 2
        end
        if #rockTracker == 0 and savedata.npcState == 2 then       -- tp when animation finished
          local rID = StageAPI.GetCurrentRoomID()
          if rID ~= "mammoniteMain" then
            local roomData = StageAPI.GetDefaultLevelMap():GetRoomDataFromRoomID("mammoniteMain")
            StageAPI.ExtraRoomTransition(roomData.MapID, Direction.UP, RoomTransitionAnim.FADE, StageAPI.DefaultLevelMapID, nil, nil, Vector(320, 320))
          end
        end
      end
    end
  end
end)

local rockSmeltRing = {}

--mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
StageAPI.AddCallback("FiendFolio", "POST_ROOM_LOAD", 1, function(_, _, _)

  local currentData = StageAPI.GetCurrentRoom().PersistentData
  if currentData.mammoniteDim then
    local roomID = StageAPI.GetCurrentRoomID()
    if roomID == "mammoniteMain" then
      FiendFolio.savedata.run.level.mammoniteDimension = FiendFolio.savedata.run.level.mammoniteDimension or initMammoniteDimensionData()
      local savedata = FiendFolio.savedata.run.level.mammoniteDimension

      if savedata.npcState ~= 3 then
        rockSmeltRing = {}
        for pIdx = 1, game:GetNumPlayers() do
          local player = Isaac.GetPlayer(pIdx - 1)
          local playerData = EntitySaveStateManager.GetEntityData(mod, player)
          if playerData.mammoniteRocks then
            for _, rData in pairs(playerData.mammoniteRocks) do
              rData.Player = player
              table.insert(rockSmeltRing, rData)
            end
          end
        end

        local l = #rockSmeltRing
        for i, rData in pairs(rockSmeltRing) do
          local gfxPath = Isaac.GetItemConfig():GetTrinket(rData.ID).GfxFileName
          local pos = Vector(320, 240 - 18)       -- idk where that 18 offset comes from (thats pretty bad)
          if l > 1 then
            pos = pos + Vector(40, 20) * Vector.FromAngle(game:GetFrameCount() * 2 + (360 / l * i)):Normalized()
            --[[  -- fucked up and evil vector
            pos = Vector(320, 240 - 18) +
              Vector(
                40 * math.cos((game:GetFrameCount() + (i * 240 / l)) / 120 * math.pi),
                20 * math.sin((game:GetFrameCount() + (i * 240 / l)) / 120 * math.pi)
              )
            ]]
          end
          local rock = Isaac.Spawn(1000, 6, 0, pos, Vector.Zero, nil)
		  mod:GetEntityData(rock).checkMeForBlasphemous = true
          local sprite = rock:GetSprite()
          if rData.Sprite.File == "gfx/005.350_Trinket.anm2" then
            sprite:Load("gfx/effects/trinket_destroy.anm2", false)
            sprite:Play("Idle", true)
            for layer = 0, 62 do
              sprite:ReplaceSpritesheet(layer, gfxPath)
            end
            sprite:LoadGraphics()
          else
            sprite:Load(rData.Sprite.File, true)
            --sprite:Play(sprite:GetDefaultAnimation(), true)
            sprite:Play(rData.Sprite.Play, true)
            rData.Sprite.Gfx = gfxPath
          end
          if rData.Golden then
            sprite:SetRenderFlags(AnimRenderFlags.GOLDEN)
          end
          if rData.Blasphemous then
            mod:AddBlasphemousShader(sprite)
          end
          rock:SetShadowSize(0.1)
          rock.SpriteOffset.Y = -32 + 3 * math.sin((game:GetFrameCount() + (i * 5)) / 20 * math.pi)

          if savedata.npcState == 2 then
            mod:GetEntityData(rock).mammoniteSmelt = rData
            rock:ToEffect().Timeout = 90
          end

          rockSmeltRing[i] = rock:ToEffect()
        end
      end

      if savedata.npcState == 2 or savedata.npcState == 3 then
        local scheduledFunction = function()
          if savedata.warpBackTo.vanillaRoom then
            game:StartRoomTransition(savedata.warpBackTo.ID, Direction.NO_DIRECTION, RoomTransitionAnim.TELEPORT, nil, -1)
          else
            -- TODO: un choclaso
            StageAPI.ExtraRoomTransition(
              StageAPI.GetDefaultLevelMap():GetRoomDataFromRoomID(savedata.warpBackTo.ID).MapID,
              Direction.NO_DIRECTION, RoomTransitionAnim.TELEPORT, StageAPI.DefaultLevelMapID, nil, nil
            )
          end
        end
        if savedata.npcState == 2 then
          mod.scheduleForUpdate(scheduledFunction, 150, nil, true)
        else
          mod.scheduleForUpdate(scheduledFunction, 30, nil, true)
        end

      end
    end

    mod.BlacklistMysteryHighPriorityChecks["MammoniteCheck"] = overrideVeil
  else
    mod.BlacklistMysteryHighPriorityChecks["MammoniteCheck"] = nil
  end
end)

--[[
  mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, trinket)
    if mod:GetEntityData(trinket).mammoniteSmelt then
      trinket:Remove()
    end
  end, 350)
]]

--[[
StageAPI.AddCallback("FiendFolio", "PRE_STAGEAPI_NEW_ROOM", 1, function()
  local roomID = StageAPI.GetCurrentRoomID()
  if roomID == "mammoniteMain" then
    for _, t in ipairs(Isaac.FindByType(5, 350, -1, false, false)) do
      --if FiendFolio.findKey(mDimTrinketsPool, function(id) return t.SubType == id end) then
      if mod:GetEntityData(t).mammoniteSmelt then
        t:Remove()
      end
    end
  end
end)
]]

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
  local l = #rockSmeltRing
  if l ~= 0 then
    for i, rock in pairs(rockSmeltRing) do
      if l == 1 then
        rock.Position = Vector(320, 240)
      else
        local orbit = Vector(40, 20) * Vector.FromAngle(game:GetFrameCount() * 2 + (360 / l * i)):Normalized()
        rock.Position = Vector(320, 240) + orbit
      end
      rock.SpriteOffset.Y = -32 + 3 * math.sin((game:GetFrameCount() + (i * 5)) / 20 * math.pi)
      if rock.Timeout == 8 then
        local gfxPath = mod:GetEntityData(rock).mammoniteSmelt.Sprite.Gfx
        if gfxPath then
          local sprite = rock:GetSprite()
          sprite:Load("gfx/effects/trinket_destroy.anm2", false)
          sprite:Play("Idle", true)
          for layer = 0, 62 do
            sprite:ReplaceSpritesheet(layer, gfxPath)
          end
          sprite:LoadGraphics()
        end
        rock:GetSprite():Play("Destroy", true)
        sfx:Play(496, 0.25, 0, false, 0.8, 0)
      elseif rock.Timeout == 2 then
        sfx:Play(498, 1, 0, false, 1.1, 0)

        local soul = Isaac.Spawn(1000, 179, 0, rock.Position, Vector.Zero, nil):ToEffect()
        soul.PositionOffset.Y = -32 + 3 * math.sin((game:GetFrameCount() + (i * 5)) / 20 * math.pi)
        soul.Target = mod:GetEntityData(rock).mammoniteSmelt.Player
        soul.Velocity = Vector(20, 10) * Vector.FromAngle(game:GetFrameCount() * 2 + (360 / l * i) + 90):Normalized()
        mod:GetEntityData(soul).mammoniteSmelt = mod:GetEntityData(rock).mammoniteSmelt

        rock:Remove()
        rockSmeltRing[i] = nil
      end
    end
  end
end)

mod:AddCallback(ModCallbacks.MC_PRE_EFFECT_RENDER, function(_, effect, renderOffset)
	if mod:GetEntityData(effect).checkMeForBlasphemous then
		local sprite = effect:GetSprite()
		if mod:HasBlasphemousShader(sprite) and effect:IsVisible() then
			local renderPos = Isaac.WorldToScreen(effect.Position) + renderOffset + - game:GetRoom():GetRenderScrollOffset()
			mod:PreRenderBlasphemousShader(sprite, renderPos)
		end
	end
end, 6)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, soul)
  if mod:GetEntityData(soul).mammoniteSmelt then
    soul.PositionOffset:Lerp(Vector.Zero, 0.05)
    soul.Velocity = soul.Velocity / 1.3
  end
end, EffectVariant.ENEMY_SOUL)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, soul)
  if soul.Variant == EffectVariant.ENEMY_SOUL and mod:GetEntityData(soul).mammoniteSmelt and game:GetRoom():GetFrameCount() ~= 0 then
    FiendFolio.savedata.run.level.mammoniteDimension = FiendFolio.savedata.run.level.mammoniteDimension or initMammoniteDimensionData()
    local savedata = FiendFolio.savedata.run.level.mammoniteDimension
    savedata.npcState = 3

    local rData = mod:GetEntityData(soul).mammoniteSmelt
    local id = rData.ID
    if rData.Golden then
      id = rData.ID | TrinketType.TRINKET_GOLDEN_FLAG
    end
    mod:gulpTrinket(rData.Player, id, rData.Blasphemous)

    local playerData = EntitySaveStateManager.GetEntityData(mod, rData.Player)
    playerData.mammoniteRocks = nil
  end
end, 1000)

-- t lazarus / esau jr compatibility
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
  local playerData = EntitySaveStateManager.GetEntityData(mod, player)
  if playerData.mammoniteRocks then
    FiendFolio.savedata.run.level.mammoniteDimension = FiendFolio.savedata.run.level.mammoniteDimension or initMammoniteDimensionData()
    local savedata = FiendFolio.savedata.run.level.mammoniteDimension
    if savedata.npcState == 3 then
      for _, rData in pairs(playerData.mammoniteRocks) do
        local id = rData.ID
        if rData.Golden then
          id = rData.ID | TrinketType.TRINKET_GOLDEN_FLAG
        end
        mod:gulpTrinket(rData.Player, id, rData.Blasphemous)
      end
      playerData.mammoniteRocks = nil
      mod.scheduleForUpdate(function()
        if player:Exists() then
          local sparks = Isaac.Spawn(1000, 179, 0, player.Position + Vector(0, 5), Vector.Zero, nil)
          sparks:GetSprite():Play("Collect", true)
        end
        sfx:Play(SoundEffect.SOUND_SOUL_PICKUP, 1, 2, false, 1, 0)
      end, 30)
    end
  end
end, 0)

--[[
mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
  local l = #rockSmeltRing
  if l ~= 0 then
    local centerOffset = 40 * Vector((l - 1) / 2, 0)
    --local rFrame = game:GetRoom().GetFrameCount()
    for i, rock in pairs(rockSmeltRing) do
      local pos = Isaac.WorldToScreen(Vector(320, 160) - centerOffset + (Vector(40, 0) * (i - 1)))
      rock.Sprite.Offset.Y = 3 * math.sin((game:GetFrameCount() + (i * 5))/20*math.pi)
      rock.Sprite:Render(pos, Vector.Zero, Vector.Zero)
    end
  end
end)
]]

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_MORPH, function(_, rock, type, var, _)
  if mod:GetEntityData(rock).mammoniteRock == true and type ~= EntityType.ENTITY_PICKUP and var ~= PickupVariant.PICKUP_TRINKET then
    return false
  end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
  rocksIcons = {}
  rockTracker = {}
end)

--[[
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
  FiendFolio.savedata.run.level.mammoniteDimension = initMammoniteDimensionData()
  for i = 1, game:GetNumPlayers() do
    local player = Isaac.GetPlayer(i - 1)
    local playerData = EntitySaveStateManager.GetEntityData(mod, player)
    playerData.mammoniteRocks = nil
  end
end)
]]