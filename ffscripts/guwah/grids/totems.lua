local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local rng = RNG()

-- `false` =  Red enabled / no totems.
-- Changing this variable does not swap totems. Use FiendFolio:SwitchTotems() for that.
FiendFolio.TotemState = false

-- `true` = Totem exists in the room
FiendFolio.TotemsExist = false

FiendFolio.RedTotemGrid = StageAPI.CustomGrid("FFTotemRed", {
    BaseType = GridEntityType.GRID_PILLAR,
    Anm2 = "gfx/grid/totems/grid_totem.anm2",
    SpawnerEntity = {Type = FiendFolio.FFID.Grid, Variant = 1039},
    NoD12 = true,
})
FiendFolio.BlueTotemGrid = StageAPI.CustomGrid("FFTotemBlue", {
    BaseType = GridEntityType.GRID_PILLAR,
    Anm2 = "gfx/grid/totems/grid_totem.anm2",
    SpawnerEntity = {Type = FiendFolio.FFID.Grid, Variant = 1040},
    NoD12 = true,
})
FiendFolio.RedTotemGridLil = StageAPI.CustomGrid("FFLilTotemRed", {
    BaseType = GridEntityType.GRID_ROCKB,
    Anm2 = "gfx/grid/totems/grid_lil_totem.anm2",
    SpawnerEntity = {Type = FiendFolio.FFID.Grid, Variant = 1044},
    NoD12 = true,
    NoSnowGlobe = true,
})
FiendFolio.BlueTotemGridLil = StageAPI.CustomGrid("FFLilTotemBlue", {
    BaseType = GridEntityType.GRID_ROCKB,
    Anm2 = "gfx/grid/totems/grid_lil_totem.anm2",
    SpawnerEntity = {Type = FiendFolio.FFID.Grid, Variant = 1045},
    NoD12 = true,
    NoSnowGlobe = true,
})
FiendFolio.RedTotemSpikesGrid = StageAPI.CustomGrid("FFTotemSpikesRed", {
    BaseType = GridEntityType.GRID_TELEPORTER,
    Anm2 = "gfx/grid/totems/grid_totem_spikes.anm2",
    SpawnerEntity = {Type = FiendFolio.FFID.Grid, Variant = 1046},
})
FiendFolio.BlueTotemSpikesGrid = StageAPI.CustomGrid("FFTotemSpikesBlue", {
    BaseType = GridEntityType.GRID_TELEPORTER,
    Anm2 = "gfx/grid/totems/grid_totem_spikes.anm2",
    SpawnerEntity = {Type = FiendFolio.FFID.Grid, Variant = 1047},
})
FiendFolio.TotemLeverGrid = StageAPI.CustomGrid("FFTotemLever", {
    BaseType = GridEntityType.GRID_TELEPORTER,
    Anm2 = "gfx/grid/totems/grid_totem_switch.anm2",
    SpawnerEntity = {Type = FiendFolio.FFID.Grid, Variant = 1041},
})
FiendFolio.TotemSwitchGrid = StageAPI.CustomGrid("FFTotemSwitch", {
    BaseType = GridEntityType.GRID_TELEPORTER,
    Anm2 = "gfx/grid/totems/grid_totem_switch.anm2",
    SpawnerEntity = {Type = FiendFolio.FFID.Grid, Variant = 1042},
})
FiendFolio.TotemTimedButton = StageAPI.CustomGrid("FFTotemTimedButton", {
    BaseType = GridEntityType.GRID_TELEPORTER,
    Anm2 = "gfx/grid/totems/grid_totem_switch.anm2",
    SpawnerEntity = {Type = FiendFolio.FFID.Grid, Variant = 1048},
})
FiendFolio.TotemAutoTimer = StageAPI.CustomGrid("FFTotemAutoTimer", {
    BaseType = GridEntityType.GRID_ROCKB,
    Anm2 = "gfx/grid/totems/grid_totem_switch.anm2",
    SpawnerEntity = {Type = FiendFolio.FFID.Grid, Variant = 1049},
    NoD12 = true,
    NoSnowGlobe = true,
})

FiendFolio.DefaultTotemColorsGFX = {"A_red", "B_blue"}
FiendFolio.TotemColorsGFX = {
    -- Vanilla
    {
        --[BackdropType.CELLAR] =                 { "A_", "B_" },
        [BackdropType.BURNT_BASEMENT] =         { "A_amber", "B_darkBlue" },
        --[BackdropType.CAVES] =                  { "A_", "B_" },
        --[BackdropType.CATACOMBS] =              { "A_", "B_" },
        --[BackdropType.FLOODED_CAVES] =          { "A_", "B_" },
        [BackdropType.DEPTHS] =                 { "A_red", "B_lightGray" },
        [BackdropType.NECROPOLIS] =             { "A_red", "B_lightGray" },
        [BackdropType.DANK_DEPTHS] =            { "A_yellow", "B_darkBlue" },
        [BackdropType.WOMB] =                   { "A_reddierRed", "B_white" },
        [BackdropType.UTERO] =                  { "A_reddierRed", "B_white" },
        --[BackdropType.SCARRED_WOMB] =           { "A_", "B_" },
        --[BackdropType.BLUE_WOMB] =              { "A_", "B_" },
        [BackdropType.SHEOL] =                  { "A_reddierRed", "B_yellow" },
        [BackdropType.CATHEDRAL] =              { "A_white", "B_blue" },
        [BackdropType.DARKROOM] =               { "A_black", "B_purple" },
        [BackdropType.ARCADE] =                 { "A_black", "B_green" },
        --[BackdropType.SECRET] =                 { "A_", "B_" },
        --[BackdropType.ERROR_ROOM] =             { "A_", "B_" },
        --[BackdropType.BLUE_WOMB_PASS] =         { "A_", "B_" },
        --[BackdropType.DOWNPOUR] =               { "A_", "B_" },
        --[BackdropType.MINES] =                  { "A_", "B_" },
        [BackdropType.MAUSOLEUM] =              { "A_lightGray", "B_purple" },
        [BackdropType.CORPSE] =                 { "A_lightGray", "B_green" },
        --[BackdropType.PLANETARIUM] =            { "A_", "B_" },
        --[BackdropType.DOWNPOUR_ENTRANCE] =      { "A_", "B_" },
        --[BackdropType.MINES_ENTRANCE] =         { "A_", "B_" },
        [BackdropType.MAUSOLEUM_ENTRANCE] =     { "A_lightGray", "B_purple" },
        [BackdropType.CORPSE_ENTRANCE] =        { "A_lightGray", "B_green" },
        [BackdropType.MAUSOLEUM2] =             { "A_lightGray", "B_purple" },
        [BackdropType.MAUSOLEUM3] =             { "A_lightGray", "B_purple" },
        [BackdropType.MAUSOLEUM4] =             { "A_lightGray", "B_purple" },
        [BackdropType.CORPSE2] =                { "A_lightGray", "B_green" },
        [BackdropType.CORPSE3] =                { "A_lightGray", "B_green" },
        [BackdropType.DROSS] =                  { "A_yellow", "B_brown" },
        [BackdropType.ASHPIT] =                 { "A_amber", "B_darkGray" },
        [BackdropType.GEHENNA] =                { "A_reddierRed", "B_black" },
        --[BackdropType.MORTIS] =                 { "A_", "B_" },
        --[BackdropType.MINES_SHAFT] =            { "A_", "B_" },
        [BackdropType.ASHPIT_SHAFT] =           { "A_amber", "B_darkGray" },
    },
    {
        [1] = { "A_yellow", "B_darkBlue" },         --DankerBackdrop
        [2] = { "A_orange", "B_darkBlue" },         --SmokyBackdrop
        [3] = { "A_yellow", "B_darkBlue" },         --PipesBackdrop
        [4] = { "A_yellow", "B_blue" },             --HoneyedCellarBackdrop
        [5] = { "A_reddierRed", "B_white" },        --EyeballUteroBackdrop
        --[6] = { "A_", "B_" },                       --PrimordialBackdrop
        --[7] = { "A_", "B_" },                       --ChallengeBackdrop
        [8] = { "A_darkGray", "B_green" },          --TrashDankDepthsBackdrop
        [9] = { "A_yellow", "B_brown" },            --PeepeeBackdrop
        [10] = { "A_lightGray", "B_black" },        --MorbusBackdrop
        [11] = { "A_lightGray", "B_purple" },       --MausoleumAltBackdrop
        [12] = { "A_black", "B_yellow" },           --RiskRewardBackdrop
        [13] = { "A_amber", "B_green" },           --IrradiatedAshpitNoAshBackdrop
        --[14] = { "A_", "B_" },                      --SurrealSheolBackdrop
    },
    {
        --Custom Stages go here
    },
}

local gridsAnm2LayerMap = {     --A         B
    ["FFTotemRed"] =            { {0, 1},   {}, },
    ["FFTotemBlue"] =           { {},       {1, 2}, },
    ["FFLilTotemRed"] =         { {0},      {} },
    ["FFLilTotemBlue"] =        { {},       {1} },
    ["FFTotemSpikesRed"] =      { {0},      {} },
    ["FFTotemSpikesBlue"] =     { {},       {1} },
    ["FFTotemLever"] =          { {1, 2},   {0} },
    ["FFTotemSwitch"] =         { {1, 2},   {0} },
    ["FFTotemTimedButton"] =    { {1, 2},   {0} },
    ["FFTotemAutoTimer"] =      { {1, 2},   {0} },
}

local gridsAppearAboveWater = {
    ["FFTotemRed"] =            false,  -- handled automatically by game
    ["FFTotemBlue"] =           false,  -- handled automatically by game
    ["FFLilTotemRed"] =         true,
    ["FFLilTotemBlue"] =        true,
    ["FFTotemSpikesRed"] =      true,
    ["FFTotemSpikesBlue"] =     true,
    ["FFTotemLever"] =          true,
    ["FFTotemSwitch"] =         true,
    ["FFTotemTimedButton"] =    true,
    ["FFTotemAutoTimer"] =      false,  -- handled automatically by game
}

local function IsBlue(customGrid)
    return (customGrid.GridConfig.Name == "FFTotemBlue" or customGrid.GridConfig.Name == "FFLilTotemBlue" or customGrid.GridConfig.Name == "FFTotemSpikesBlue")
end

local function IsSmall(customGrid)
    return (customGrid.GridConfig.Name == "FFLilTotemRed" or customGrid.GridConfig.Name == "FFLilTotemBlue")
end

function mod:GetExpectedTotemColors(customBackdropID)
    if customBackdropID == nil and StageAPI.GetCurrentBackdropID then
        customBackdropID = StageAPI.GetCurrentBackdropID()
    end
    if customBackdropID and mod.TotemColorsGFX[3][customBackdropID] then
        return mod.TotemColorsGFX[3][customBackdropID]
    elseif mod.roomBackdrop and mod.TotemColorsGFX[2][mod.roomBackdrop] then
        return mod.TotemColorsGFX[2][mod.roomBackdrop]
    elseif mod.TotemColorsGFX[1][game:GetRoom():GetBackdropType()] then
        return mod.TotemColorsGFX[1][game:GetRoom():GetBackdropType()]
    end
    return FiendFolio.DefaultTotemColorsGFX
end

function mod:RegisterCustomBackdropTotemColors(backdropID, colorA, colorB) --For StageAPI backdrops with ID variable set
    if type(backdropID) ~= "string" and #backdropID > 0 then
        for _, id in pairs(backdropID) do
            FiendFolio.TotemColorsGFX[3][id] = {colorA, colorB}
        end
    else
        FiendFolio.TotemColorsGFX[3][backdropID] = {colorA, colorB}
    end
end

local function setTotemColorsGFX(customGrid, target)
    -- Set water clip flags.
    local gName = customGrid.GridConfig.Name
    if customGrid.GridEntity.SetWaterClipFlags and gridsAppearAboveWater[gName] then
        customGrid.GridEntity:SetWaterClipFlags(WaterClipFlag.DISABLE_RENDER_BELOW_WATER)
    end

    local cPair = mod:GetExpectedTotemColors()
    if not cPair then return false end
    local sprite = target or customGrid.GridEntity:GetSprite()        -- target used for totem's dummyEffect
    local lMap = gridsAnm2LayerMap[gName]
    local customColorB = false
    if cPair[1] ~= "A_red" then                 -- red / on / A
        for _, layer in pairs(lMap[1]) do
            sprite:ReplaceSpritesheet(layer, "gfx/grid/totems/grid_totem_" .. cPair[1] .. ".png")
        end
    end
    if cPair[2] ~= "B_blue" then                -- blue / off / B
        customColorB = true
        for _, layer in pairs(lMap[2]) do
            sprite:ReplaceSpritesheet(layer, "gfx/grid/totems/grid_totem_" .. cPair[2] .. ".png")
        end
    end
    sprite:LoadGraphics()
    return customColorB
end

StageAPI.AddCallback("FiendFolio", "POST_CHANGE_ROOM_GFX", 1, function(currentRoom, usingGfx, onRoomLoad) --If a StageAPI backdrop loads at room start, attempt to reskins Totems/Binaries to match
    if usingGfx and game:GetRoom():GetFrameCount() <= 1 then
       for _, totem in pairs(mod:GetTotems()) do
            setTotemColorsGFX(totem)
            if totem.Data.DummyEffect then
                setTotemColorsGFX(totem, totem.Data.DummyEffect:GetSprite())
            end
        end
        for _, binary in pairs(Isaac.FindByType(mod.FF.Binary.ID, mod.FF.Binary.Var)) do
            mod:LoadBinarySkin(binary:ToNPC())
        end
    end
end)

-- Gets all totem-adjacent grids in the room
function mod:GetTotems()
    local grids = {}
    for name in pairs(gridsAnm2LayerMap) do
        for _, grid in ipairs(StageAPI.GetCustomGrids(nil, name)) do
            grids[#grids+1] = grid
        end
    end

    return grids
end

function mod.TotemSpawn(customGrid)
    local grid = customGrid.GridEntity
	local sprite = grid:GetSprite(customGrid)
    local hasCustomColorB = setTotemColorsGFX(customGrid)
    if IsBlue(customGrid) then
        customGrid.Data.AnimPrefix = "OffPillar"
        sprite:Play(customGrid.Data.AnimPrefix.."_Down", true)
        --sprite:ReplaceSpritesheet(IsSmall(customGrid) and 2 or 3, "gfx/grid/totems/totemgibs_blue.png", true)
        if not (IsSmall(customGrid) or hasCustomColorB) then
            sprite:ReplaceSpritesheet(1, "gfx/grid/totems/grid_totem_B_blue.png")
        end
        sprite:LoadGraphics()
    else
        customGrid.Data.AnimPrefix = "OnPillar"
        sprite:Play(customGrid.Data.AnimPrefix.."_Up", true)
        customGrid.Data.IsActive = true
    end

    local dummyEffect = Isaac.Spawn(mod.FF.DummyEffect.ID, mod.FF.DummyEffect.Var, mod.FF.DummyEffect.Sub, customGrid.Position, Vector.Zero, nil)
    dummyEffect:GetSprite():Load(sprite:GetFilename(), true)
    setTotemColorsGFX(customGrid, dummyEffect:GetSprite())
    dummyEffect.SortingLayer = SortingLayer.SORTING_BACKGROUND
    dummyEffect.RenderZOffset = 3000
    dummyEffect.Visible = true
    customGrid.Data.DummyEffect = dummyEffect

    FiendFolio.TotemsExist = true
    mod.TotemUpdate(customGrid)
end
StageAPI.AddCallback("FiendFolio", "POST_SPAWN_CUSTOM_GRID", 1, mod.TotemSpawn, "FFTotemRed")
StageAPI.AddCallback("FiendFolio", "POST_SPAWN_CUSTOM_GRID", 1, mod.TotemSpawn, "FFTotemBlue")
StageAPI.AddCallback("FiendFolio", "POST_SPAWN_CUSTOM_GRID", 1, mod.TotemSpawn, "FFLilTotemRed")
StageAPI.AddCallback("FiendFolio", "POST_SPAWN_CUSTOM_GRID", 1, mod.TotemSpawn, "FFLilTotemBlue")

function mod.TotemUpdate(customGrid)
    if customGrid:IsOnGrid() then
        local room = game:GetRoom()
        local grid = customGrid.GridEntity
	    local sprite = grid:GetSprite()

        if sprite:IsFinished(customGrid.Data.AnimPrefix.."_Raise") then
            sprite:Play(customGrid.Data.AnimPrefix.."_Up", true)

        elseif sprite:IsFinished(customGrid.Data.AnimPrefix.."_Lower") then
            sprite:Play(customGrid.Data.AnimPrefix.."_Down", true)

        elseif sprite:IsEventTriggered("Down") then
            customGrid.Data.IsActive = false
            customGrid.Data.QueuedActiveState = nil

        elseif sprite:IsEventTriggered("Up") then
            customGrid.Data.IsActive = true
            customGrid.Data.QueuedActiveState = nil

            for _, player in pairs(mod:GetAllPlayers()) do
                if room:GetGridIndex(player.Position) == grid:GetGridIndex()
                --Considered this check, I think it'd be fine but left out in case it might cause other issues
                --and player.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_NONE
                then
                    local data = mod:GetEntityData(player)
                    data.TotemUpward = true
                    Isaac.RunCallback(FiendFolio.CALLBACK.FF_POST_TOTEM_LAUNCH, player, data)
                    sfx:Play(mod.Sounds.SmashHitWeak)
                    sfx:Play(mod.Sounds.ZoomAway, 0.6)

                    local parentPlayer = player.Parent and player.Parent:ToPlayer()
                    if parentPlayer and mod:GetEntityData(parentPlayer).MaliceMinions then
                        local data = mod:GetEntityData(parentPlayer)
                        data.TotemUpward = true
                    elseif not data.MaliceMinions then
                        player:AddCacheFlags(CacheFlag.CACHE_FLYING, true)
                        player.ControlsEnabled = false
                        player:TryThrow(EntityRef(nil), Vector.Zero, 30)
                    end
                end
            end
        end

        --[[if grid:GetType() ~= customGrid.GridConfig.BaseType then --Giga Bomb detection
            customGrid.Data.DummyEffect:Remove()
            customGrid:Remove()

        else]]
        if customGrid.PersistentData.Destroyed then
            customGrid.Data.DummyEffect.Visible = false
            --[[grid.CollisionClass = GridCollisionClass.COLLISION_NONE
            grid.State = 2]]
            customGrid:Remove()

        else
            customGrid.Data.DummyEffect.Visible = true

            if customGrid.Data.IsActive then
                customGrid.Data.DummyEffect.Visible = false
                grid.State = 1
				if IsSmall(customGrid) then
					grid.CollisionClass = GridCollisionClass.COLLISION_SOLID
				else
					grid.CollisionClass = GridCollisionClass.COLLISION_WALL
				end
                room:SetGridPath(grid:GetGridIndex(), 1000)

            else
                customGrid.Data.DummyEffect.Visible = true
                grid.State = 0
                grid.CollisionClass = GridCollisionClass.COLLISION_NONE
                room:SetGridPath(grid:GetGridIndex(), 0)
            end
        end

        customGrid.Data.DummyEffect:GetSprite():SetFrame(sprite:GetAnimation(), sprite:GetFrame())
    end
end
StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_UPDATE", 1, mod.TotemUpdate, "FFTotemRed")
StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_UPDATE", 1, mod.TotemUpdate, "FFTotemBlue")
StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_UPDATE", 1, mod.TotemUpdate, "FFLilTotemRed")
StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_UPDATE", 1, mod.TotemUpdate, "FFLilTotemBlue")

FiendFolio.TotemIDs = {"FFTotemRed", "FFTotemBlue", "FFLilTotemRed", "FFLilTotemBlue"}
mod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_SPAWN, function(_, type, var, varData, index, seed, desc)
    for _, id in pairs(FiendFolio.TotemIDs) do
        local customGrid = StageAPI.GetCustomGrid(index, id)
        if customGrid then
            return false
        end
    end
end)

function mod.TotemRemove(customGrid)
    customGrid.Data.DummyEffect:Remove()
end
StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_REMOVE", 1, mod.TotemRemove, "FFTotemRed")
StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_REMOVE", 1, mod.TotemRemove, "FFTotemBlue")
StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_REMOVE", 1, mod.TotemRemove, "FFLilTotemRed")
StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_REMOVE", 1, mod.TotemRemove, "FFLilTotemBlue")

function mod.TotemSpikesSpawn(customGrid)
    local grid = customGrid.GridEntity
	local sprite = grid:GetSprite()
    setTotemColorsGFX(customGrid)
    if IsBlue(customGrid) then
        customGrid.Data.AnimSuffix = "blue"
        sprite:Play("spikes_off_"..customGrid.Data.AnimSuffix, true)
    else
        customGrid.Data.AnimSuffix = "red"
        sprite:Play("spikes_"..customGrid.Data.AnimSuffix, true)
        customGrid.Data.IsActive = true
        customGrid.Data.Poking = true
    end

    FiendFolio.TotemsExist = true
end

StageAPI.AddCallback("FiendFolio", "POST_SPAWN_CUSTOM_GRID", 1, mod.TotemSpikesSpawn, "FFTotemSpikesRed")
StageAPI.AddCallback("FiendFolio", "POST_SPAWN_CUSTOM_GRID", 1, mod.TotemSpikesSpawn, "FFTotemSpikesBlue")

function mod.TotemSpikesUpdate(customGrid)
    if customGrid:IsOnGrid() then
        local grid = customGrid.GridEntity
	    local sprite = grid:GetSprite()
        grid.State = 2

        if sprite:IsEventTriggered("Up") then
            customGrid.Data.Poking = true
        elseif sprite:IsEventTriggered("Down") then
            customGrid.Data.Poking = false
        end

        --room:SetGridPath(grid:GetGridIndex(), customGrid.Data.Poking and 999 or 0)

        if customGrid.Data.Poking then
            local did, _, players = mod:DamageInRadius(customGrid.Position, 11, 2, nil, DamageFlag.DAMAGE_SPIKES, true, true, 4, 5)
            if did then
                for _, player in ipairs(players) do
                    local dir = (player.Position - customGrid.Position):Resized(1.5)
                    player:AddVelocity(dir)
                end
            end
        end
    end
end
StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_UPDATE", 1, mod.TotemSpikesUpdate, "FFTotemSpikesRed")
StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_UPDATE", 1, mod.TotemSpikesUpdate, "FFTotemSpikesBlue")

function mod:TryActivateLever(customGrid)
    if customGrid and customGrid.Data.ActivateCooldown <= 0 then
        mod:PlaySound(SoundEffect.SOUND_METAL_DOOR_OPEN, nil, 2, 0.6)
        mod:SwitchTotems()
    end
end

local function ShouldPlayerTouchLever(player)
    return (
    not player:IsCoopGhost()
    and (
            (
                player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B 
                or player:IsNullItemCostumeVisible(NullItemID.ID_BLINDFOLD, "head3")
            )
            or (
                player.CollisionDamage > 0 
                and player:GetPlayerType() ~= PlayerType.PLAYER_THEFORGOTTEN_B
            )
        )
    )
end

local function TotemLeverPlayerCollide(hitbox, ent)
    local player = ent:ToPlayer()
    local shouldActivate = Isaac.RunCallback(mod.CALLBACK.FF_PRE_PLAYER_TOUCH_TOTEM_LEVER, player) or ShouldPlayerTouchLever(player)
    if shouldActivate then
        mod:TryActivateLever(mod:GetEntityData(hitbox).CustomGrid)
    end
end

local function TotemLeverHitboxCollide(hitbox, collider)
    if not collider:ToNPC() then
        if not collider:ToFamiliar() then
            if collider.CollisionDamage > 0 then
                mod:TryActivateLever(mod:GetEntityData(hitbox).CustomGrid)
            end
        end
    end
    if not collider:IsFlying() then
        return true
    end
end

local function GetEntitiesWhichCanPressTotemButtons()
    local players = mod:GetAllPlayers()
    local doples = Isaac.FindByType(EntityType.ENTITY_DOPLE) -- Also covers Last Judgement!
    local apers = Isaac.FindByType(mod.FF.Aper.ID, mod.FF.Aper.Var)
    return mod:MergeArrays(players, doples, apers)
end

local function TotemLeverHitboxHurt(hitbox, damage, flag, source, countdown)
    if damage > 0 then
        if mod:HasDamageFlag(DamageFlag.DAMAGE_LASER, flag) or not (source.Entity and source.Entity:ToFamiliar()) then
            mod:TryActivateLever(mod:GetEntityData(hitbox).CustomGrid)
        end
    end
    return false
end

StageAPI.AddCallback("FiendFolio", "POST_SPAWN_CUSTOM_GRID", 1, function(customGrid)
    local grid = customGrid.GridEntity
	local sprite = grid:GetSprite()
    grid.CollisionClass = GridCollisionClass.COLLISION_PIT
    setTotemColorsGFX(customGrid)
    sprite:Play("Lever_On", true)
    customGrid.Data.ActivateCooldown = 0


    customGrid.Data.Hitbox = Isaac.Spawn(mod.FF.Hitbox.ID, mod.FF.Hitbox.Var, 1, grid.Position, Vector.Zero, nil)
    customGrid.Data.Hitbox.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
    customGrid.Data.Hitbox:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
    local hdata = mod:GetEntityData(customGrid.Data.Hitbox)
    hdata.CustomGrid = customGrid
    hdata.FixToSpawner = true
    hdata.Width = 23
    hdata.Height = 23
    hdata.NoFamiliarTarget = true
    hdata.IgnoreTearFlagEffects = true
    hdata.OnHurt = TotemLeverHitboxHurt
    hdata.OnCollide = TotemLeverHitboxCollide
    hdata.OnPlayerCollide = TotemLeverPlayerCollide

    FiendFolio.TotemsExist = true
end, "FFTotemLever")

StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_UPDATE", 1, function(customGrid)
    if customGrid:IsOnGrid() then
        local room = game:GetRoom()
        local grid = customGrid.GridEntity
	    local sprite = grid:GetSprite()

        grid.State = 2

        if sprite:IsFinished() then
            customGrid.Data.ActivateCooldown = customGrid.Data.ActivateCooldown - 1
        end

        for _, hook in pairs(Isaac.FindByType(mod.FF.SanguineHook.ID, mod.FF.SanguineHook.Var, mod.FF.SanguineHook.Sub)) do
            if hook.Position:Distance(customGrid.Position) < customGrid.Data.Hitbox.Size + hook.Size then
                mod:TryActivateLever(customGrid)
            end
        end
    end
end, "FFTotemLever")

StageAPI.AddCallback("FiendFolio", "POST_SPAWN_CUSTOM_GRID", 1, function(customGrid)
    local grid = customGrid.GridEntity
    setTotemColorsGFX(customGrid)
	local sprite = grid:GetSprite()
    sprite:Play("Button_On", true)

    FiendFolio.TotemsExist = true
end, "FFTotemSwitch")

StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_UPDATE", 1, function(customGrid)
    if customGrid:IsOnGrid() then
        local room = game:GetRoom()
        local grid = customGrid.GridEntity
	    local sprite = grid:GetSprite()

        grid.State = 2

        local targets = GetEntitiesWhichCanPressTotemButtons()

        if customGrid.Data.SteppedOn then
            local noTargets = true
            for _, target in pairs(targets) do
                if room:GetGridIndex(target.Position) == grid:GetGridIndex() then
                    noTargets = false
                    break
                end
            end
            if noTargets then
                sfx:Play(SoundEffect.SOUND_BUTTON_PRESS)
                customGrid.Data.SteppedOn = false
            end
        else
            for _, target in pairs(targets) do
                if room:GetGridIndex(target.Position) == grid:GetGridIndex() then
                    mod:SwitchTotems()
                    customGrid.Data.SteppedOn = true
                    sfx:Play(SoundEffect.SOUND_BUTTON_PRESS)
                    break
                end
            end
        end

        room:SetGridPath(grid:GetGridIndex(), 950)
    end
end, "FFTotemSwitch")

StageAPI.AddCallback("FiendFolio", "POST_SPAWN_CUSTOM_GRID", 1, function(customGrid)
    local grid = customGrid.GridEntity
    setTotemColorsGFX(customGrid)
	local sprite = grid:GetSprite()
    sprite:Play("TimedButton_On", true)

    FiendFolio.TotemsExist = true
end, "FFTotemTimedButton")

local pressDuration = 150
StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_UPDATE", 1, function(customGrid)
    if customGrid:IsOnGrid() then
        local room = game:GetRoom()
        local grid = customGrid.GridEntity
	    local sprite = grid:GetSprite()

        grid.State = 2

        if customGrid.Data.Timer then
            customGrid.Data.Timer = customGrid.Data.Timer - 1
            if customGrid.Data.Timer <= 0 then
                sprite:Play("TimedButton_SwitchedOn", true)
                sfx:Play(SoundEffect.SOUND_BUTTON_PRESS)
                mod:PlaySound(SoundEffect.SOUND_BEEP, nil, 0.5 + ((pressDuration - customGrid.Data.Timer) / 300), 0.25)
                mod:SwitchTotems()
                customGrid.Data.Timer = nil
            else
                if not sprite:IsPlaying() then
                    local frame = math.floor(customGrid.Data.Timer / (pressDuration / 4)) + 1
                    if sprite:GetFrame() ~= frame then
                        mod:PlaySound(SoundEffect.SOUND_BEEP, nil, 0.5 + ((pressDuration - customGrid.Data.Timer) / 300), 0.25)
                    end
                    sprite:SetFrame("TimedButton_TickingOn", frame)
                end
            end
        else
            local targets = GetEntitiesWhichCanPressTotemButtons()

            for _, target in pairs(targets) do
                if room:GetGridIndex(target.Position) == grid:GetGridIndex() then
                    mod:SwitchTotems()
                    customGrid.Data.Timer = pressDuration
                    sfx:Play(SoundEffect.SOUND_BUTTON_PRESS)
                    break
                end
            end
        end

        room:SetGridPath(grid:GetGridIndex(), 950)
    end
end, "FFTotemTimedButton")

local timerInterval = 30
StageAPI.AddCallback("FiendFolio", "POST_SPAWN_CUSTOM_GRID", 1, function(customGrid)
    setTotemColorsGFX(customGrid)
    customGrid.Data.AnimSuffix = "On"
    customGrid.Data.TimeSteps = customGrid.PersistentData.SpawnerEntity.SubType
    customGrid.Data.CurrentTimeStep = customGrid.Data.TimeSteps
    customGrid.Data.Timer = 30
    customGrid.GridEntity:GetSprite():SetFrame("Timer_"..customGrid.Data.AnimSuffix, 9 - customGrid.Data.CurrentTimeStep)

    FiendFolio.TotemsExist = true
end, "FFTotemAutoTimer")

StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_UPDATE", 1, function(customGrid)
    if customGrid:IsOnGrid() then
        local room = game:GetRoom()
        local grid = customGrid.GridEntity
	    local sprite = grid:GetSprite()

        if not sprite:IsPlaying() then
            sprite:SetFrame("Timer_"..customGrid.Data.AnimSuffix, 9 - customGrid.Data.CurrentTimeStep)
        end

        customGrid.Data.Timer = customGrid.Data.Timer - 1
        if customGrid.Data.Timer <= 0 then
            customGrid.Data.CurrentTimeStep = customGrid.Data.CurrentTimeStep - 1
            if customGrid.Data.CurrentTimeStep <= 0 then
                customGrid.Data.CurrentTimeStep = customGrid.Data.TimeSteps
                mod:SwitchTotems()
                mod:PlaySound(SoundEffect.SOUND_STATIC, nil, 1, 0.25)
            end
            local pitch = 0.5 + (0.5 * (1 - (customGrid.Data.CurrentTimeStep + 1) / customGrid.Data.TimeSteps))
            mod:PlaySound(SoundEffect.SOUND_BEEP, nil, pitch, 0.25)
            customGrid.Data.Timer = timerInterval
        end
    end
end, "FFTotemAutoTimer")

function mod:SwitchTotems()
    for _, totems in pairs({StageAPI.GetCustomGrids(nil, "FFTotemRed"), StageAPI.GetCustomGrids(nil, "FFTotemBlue"), StageAPI.GetCustomGrids(nil, "FFLilTotemRed"), StageAPI.GetCustomGrids(nil, "FFLilTotemBlue")}) do
        for _, totem in pairs(totems) do
            local isActive = totem.Data.IsActive

            if totem.Data.QueuedActiveState ~= nil then
                isActive = totem.Data.QueuedActiveState
            end

            if isActive then
                totem.GridEntity:GetSprite():Play(totem.Data.AnimPrefix.."_Lower", true)
                mod:PlaySound(mod.Sounds.GolemDoorClose, nil, 0.8, 2)
                totem.Data.QueuedActiveState = false
            else
                totem.GridEntity:GetSprite():Play(totem.Data.AnimPrefix.."_Raise", true)
                mod:PlaySound(mod.Sounds.GolemDoorClose, nil, 0.8, 2)
                totem.Data.QueuedActiveState = true
            end
        end
    end
    for _, spikes in pairs({StageAPI.GetCustomGrids(nil, "FFTotemSpikesRed"), StageAPI.GetCustomGrids(nil, "FFTotemSpikesBlue")}) do
        for _, spike in pairs(spikes) do
            if spike.Data.IsActive then
                spike.GridEntity:GetSprite():Play("spikes_unsummon_"..spike.Data.AnimSuffix, true)
                spike.Data.IsActive = false
            else
                spike.GridEntity:GetSprite():Play("spikes_summon_"..spike.Data.AnimSuffix, true)
                spike.Data.IsActive = true
            end
        end
    end
    for _, switch in pairs(StageAPI.GetCustomGrids(nil, "FFTotemSwitch")) do
        if switch.Data.IsActive then
            switch.GridEntity:GetSprite():Play("Button_SwitchedOn", true)
            switch.Data.IsActive = false
        else
            switch.GridEntity:GetSprite():Play("Button_SwitchedOff", true)
            switch.Data.IsActive = true
        end
    end
    for _, lever in pairs(StageAPI.GetCustomGrids(nil, "FFTotemLever")) do
        if lever.Data.IsActive then
            lever.GridEntity:GetSprite():Play("Lever_SwitchedOn", true)
            lever.Data.IsActive = false
        else
            lever.GridEntity:GetSprite():Play("Lever_SwitchedOff", true)
            lever.Data.IsActive = true
        end
        lever.Data.ActivateCooldown = 10
    end
    for _, button in pairs(StageAPI.GetCustomGrids(nil, "FFTotemTimedButton")) do
        if button.Data.Timer then
            button.Data.Timer = nil
            button.GridEntity:GetSprite():Play("TimedButton_SwitchedOn", true)
        else
            button.Data.Timer = pressDuration
            button.GridEntity:GetSprite():Play("TimedButton_SwitchedOff", true)
        end
    end
    for _, timer in pairs(StageAPI.GetCustomGrids(nil, "FFTotemAutoTimer")) do
        if timer.Data.AnimSuffix == "On" then
            timer.GridEntity:GetSprite():Play("Timer_SwitchedOff", true)
            timer.Data.AnimSuffix = "Off"
        else
            timer.GridEntity:GetSprite():Play("Timer_SwitchedOn", true)
            timer.Data.AnimSuffix = "On"
        end
        timer.Data.Timer = timerInterval
        timer.Data.CurrentTimeStep = timer.Data.TimeSteps
    end

    mod.TotemState = not mod.TotemState
    Isaac.RunCallbackWithParam(mod.CALLBACK.SWITCH_TOTEMS, mod.TotemState, mod.TotemState)
end

function mod:TotemResetLaunchLogic(player, data)
    data.TotemDownward = nil
    data.TotemUpward = nil
    player.PositionOffset.Y = 0
    player.ControlsEnabled = true
    player.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
    player:AddCacheFlags(CacheFlag.CACHE_FLYING, true)
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function ()
    -- Reset totem launch logic for all applicable players
    for _, player in ipairs(PlayerManager.GetPlayers()) do
        local data = mod:GetEntityData(player)
        if data.TotemDownward or data.TotemUpward then
            mod:TotemResetLaunchLogic(player, data)
        end
    end

    -- Also update totem state
    mod.TotemState = false
end)

function mod:TotemPlayerLaunchLogic(player)
    if mod:IsNormalRender() then
        local data = mod:GetEntityData(player)
        if data.TotemUpward then
            local room = game:GetRoom()
            local doorpos = room:GetDoorSlotPosition(game:GetLevel().EnterDoor)
            doorpos = doorpos + (room:GetCenterPos() - doorpos):Resized(40)
            player.Velocity = Vector.Zero

            local maliceMinions = data.MaliceMinions or (player.Parent and mod:GetEntityData(player.Parent).MaliceMinions)
            if maliceMinions then
                local playersAffected = {player, player.Parent, table.unpack(maliceMinions)}
                for _, player in ipairs(playersAffected) do
                    local pData = mod:GetEntityData(player)
                    pData.TotemUpward = nil
                    pData.TotemDownward = true

                    player.Position = doorpos
                end

                return
            end

            if player.PositionOffset.Y <= -300 then
                player.Position = doorpos
                player.PositionOffset.Y = -300

                data.TotemUpward = nil
                data.TotemDownward = true
            end
        elseif data.TotemDownward then
            player.Velocity = Vector.Zero
            if player.PositionOffset.Y >= 0 then
                mod:TotemResetLaunchLogic(player, data)
                local maliceMinions = data.MaliceMinions or (player.Parent and mod:GetEntityData(player.Parent).MaliceMinions)
                if maliceMinions then
                    local playersAffected = {player, player.Parent, table.unpack(maliceMinions)}
                    for _, player in ipairs(playersAffected) do
                        mod:TotemResetLaunchLogic(player:ToPlayer(), mod:GetEntityData(player))
                    end
                end

                if mod:IsBriendMain(player) then
                    local twin = player:GetOtherTwin()
                    mod:TotemResetLaunchLogic(twin, mod:GetEntityData(twin))
                end

                local held = player:GetHeldEntity()
                if held and held:ToPlayer() then
                    local heldData = mod:GetEntityData(held)
                    if heldData.TotemUpward or heldData.TotemDownward then
                        mod:TotemResetLaunchLogic(held:ToPlayer(), heldData)
                    end
                end

                sfx:Play(SoundEffect.SOUND_BONE_SNAP)
                for _ = 0, 3 do
                    Isaac.Spawn(1000, 5, 1, player.Position, Vector.One:Resized(rng:RandomFloat()*6):Rotated(mod:RandomAngle()), player):Update()
                end
            end
        end
    end
end