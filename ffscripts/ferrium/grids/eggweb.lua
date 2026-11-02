local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

--Some stuff taken from soot tag code
FiendFolio.EggWebGrid = StageAPI.CustomGrid("FFEggWeb", {
    BaseType = GridEntityType.GRID_SPIDERWEB,
    Anm2 = "gfx/grid/web/grid_eggweb.anm2",
    Animation = "Idle",
    RemoveOnAnm2Change = true,
    OverrideGridSpawns = true,
    SpawnerEntity = {Type = FiendFolio.FFID.Grid, Variant = 1051}
})

StageAPI.AddCallback("FiendFolio", "POST_SPAWN_CUSTOM_GRID", 1, function(customGrid)
    if customGrid.GridEntity.State == 1 then
        local sprite = customGrid.GridEntity:GetSprite()
        sprite:Play("Bombed", true)
    end
end, FiendFolio.EggWebGrid.Name)

StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_UPDATE", 1, function(customGrid)
    local grid = customGrid.GridEntity
    local triggeredPlayer
    local hatch
    if grid.State == 0 then
        local players = Isaac.FindInRadius(grid.Position, 24, EntityPartition.PLAYER)
        for _, player in ipairs(players) do
            if not player.CanFly then
                local room = game:GetRoom()
                local index = grid:GetGridIndex()
                triggeredPlayer = player
                customGrid.PersistentData.Egged = true
                room:RemoveGridEntity(index, 0, false)
                mod.scheduleForUpdate(function()
                    room:SpawnGridEntity(index, GridEntityType.GRID_SPIDERWEB, 0, 0, 0)
                end, 2)
                hatch = true
                break
            end
        end
    elseif grid.State == 1 and not customGrid.PersistentData.Egged then
        customGrid.PersistentData.Egged = true
        hatch = true
    end

    if hatch then
        sfx:Play(SoundEffect.SOUND_BOIL_HATCH, 1, 0, false, 1)
        local rng = customGrid.RNG
        rng:SetSeed(grid.Desc.SpawnSeed, 0)
        local num = rng:RandomInt(3)+2
        for i=1,num do
            local fam
            if rng:RandomInt(2) == 0 then
                fam = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.ATTACK_SKUZZ, 0, grid.Position, Vector.Zero, triggeredPlayer):ToFamiliar()
            else
                fam = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_SPIDER, 0, grid.Position, Vector.Zero, triggeredPlayer):ToFamiliar()
            end
            if triggeredPlayer and triggeredPlayer:ToPlayer() then
                fam.Player = triggeredPlayer:ToPlayer()
            end
        end
        local poof = Isaac.Spawn(1000, 2, 150, grid.Position, Vector.Zero, nil):ToEffect()
        poof.Color = mod.ColorWebWhite
        poof.SpriteScale = Vector(0.6, 0.6)
        poof.SpriteOffset = Vector(0, -6)
        poof:Update()
    end
end, FiendFolio.EggWebGrid.Name)



--test in a room using 
--mod.DruggedPoopGrid:Spawn(index, true, false, {LeashMult = mult, PlayAppear = true})