local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

FiendFolio.SootTagGrid = StageAPI.CustomGrid("FFSootTag", {
    BaseType = GridEntityType.GRID_SPIDERWEB,
    Anm2 = "gfx/grid/web/grid_soottag.anm2",
    Animation = "Idle",
    RemoveOnAnm2Change = true,
    OverrideGridSpawns = true,
    SpawnerEntity = {Type = FiendFolio.FFID.Grid, Variant = 1331}
})

function mod.sootTagUpdate(customGrid)
    local grid = customGrid.GridEntity
    local spawnFire
    local gridPos
    if grid.State == 0 then
        gridPos = grid.Position
        if game:GetRoom():GetFrameCount() > 1 then
            local fire = mod.FindClosestFire(gridPos, 99999)
            if fire and fire.Position:Distance(gridPos) < 50 then
                spawnFire = true
                grid.State = 1
                grid:GetSprite():Play("Bombed", true)
            end
        end
    elseif grid.State == 1 then
        if not customGrid.Data.SpawnedFire then
            grid:GetSprite():Play("Bombed", true)
            gridPos = grid.Position
            spawnFire = true
        end
    end
    if spawnFire and gridPos then
        local fire = Isaac.Spawn(1000,7005, 0, gridPos, Vector.Zero, nil):ToEffect()
        mod:GetEntityData(fire).timer = 100
        fire:Update()
        local soot = Isaac.Spawn(1000, 18, 0, gridPos, Vector.Zero, nil):ToEffect()
        soot.SpriteScale = soot.SpriteScale * 0.5
        soot:Update()
        customGrid.Data.SpawnedFire = true
    end
    if customGrid.Data.SpawnedFire then
        customGrid.Data.FadeoutTimer = customGrid.Data.FadeoutTimer or 0
        customGrid.Data.FadeoutTimer = customGrid.Data.FadeoutTimer + 1
        local fade = math.max(0.3, 1 - (customGrid.Data.FadeoutTimer/60))
        grid:GetSprite().Color = Color(1,1,1,0.1)
        if customGrid.Data.FadeoutTimer == 5 then
            --Blow up barrels
            local room = game:GetRoom()
            for i = 90, 360, 90 do
                local checkedPos = grid.Position + Vector(40,0):Rotated(i)
                local checkGrid = room:GetGridEntityFromPos(checkedPos)
                if checkGrid and checkGrid:ToTNT() then
                    checkGrid:Hurt(10)
                end
                for _, barrel in ipairs(Isaac.FindInRadius(checkedPos, 10, EntityPartition.ENEMY)) do
                    if barrel.Type == EntityType.ENTITY_MOVABLE_TNT then
                        if barrel.Variant ~= mod.FF.WaterTNT.Var then
                            barrel:TakeDamage(50, 0, EntityRef(Isaac.GetPlayer()), 0)
                            barrel:Die()
                        end
                    end
                end
            end
        end
    end
end

function mod.sootTagUnload(customGrid)

end

function mod.sootTagSpawn(customGrid)
    if customGrid.GridEntity.State == 1 then
        local sprite = customGrid.GridEntity:GetSprite()
        sprite:Play("Bombed", true)
        sprite:SetFrame("Bombed", 60)
        customGrid.Data.SpawnedFire = true
    end
end

StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_UPDATE", 1, mod.sootTagUpdate, FiendFolio.SootTagGrid.Name)
StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_UNLOAD", 1, mod.sootTagUnload, FiendFolio.SootTagGrid.Name)
StageAPI.AddCallback("FiendFolio", "POST_SPAWN_CUSTOM_GRID", 1, mod.sootTagSpawn, FiendFolio.SootTagGrid.Name)


----------------------------------------------------------------------
--Linger Webs, used to be soot tags so keeping them here!

FiendFolio.LingerWebGrid = StageAPI.CustomGrid("FFLingerWeb", {
    BaseType = GridEntityType.GRID_SPIDERWEB,
    Anm2 = "gfx/grid/web/grid_lingerweb.anm2",
    Animation = "Idle",
    RemoveOnAnm2Change = true,
    OverrideGridSpawns = true,
    SpawnerEntity = {Type = FiendFolio.FFID.Grid, Variant = 1332}
})

function mod.lingerWebUpdate(customGrid)
    local grid = customGrid.GridEntity
    if grid.State == 0 then
        local players = Isaac.FindInRadius(grid.Position, 24, EntityPartition.PLAYER)
        for _, player in ipairs(players) do
            local hash = GetPtrHash(player)
            if player:HasEntityFlags(EntityFlag.FLAG_SLOW) then
				if type(customGrid.Data.PlayersAffected[hash]) == "table" then
					customGrid.Data.PlayersAffected[hash].Cooldown = 30
				else
					customGrid.Data.PlayersAffected[hash] = player
				end
            end
        end
    end

    for k, player in pairs(customGrid.Data.PlayersAffected) do
        if type(player) == "table" then
            if player.Player and player.Player:Exists() then
                local cooldown = player.Cooldown
                player.Cooldown = player.Cooldown - 1
                player = player.Player

                if player.FrameCount % 4 <= 2 then
                    player:SetColor(Color(1, 1, 1, 1, 0.16, 0.16, 0.16), 1, 1, true, false)
                end

                if player.Velocity:Length() > 0.1 then
                    local rVector = RandomVector() * Vector(1, 0.666) * 6
                    local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, player.Position + rVector, player.Velocity, npc):ToEffect();
                    if customGrid.GridConfig.Name == "FFLingerWeb" then
                        smoke:SetColor(Color(1, 1, 1, 0.3, 1, 1, 1), 0, 1, false, false)
                    else
                        smoke:SetColor(Color(0.333, 0.333, 0.333, 0.666, 0, 0, 0), 0, 1, false, false)
                    end
                    smoke.SpriteScale = Vector(0.25, 0.25) * (0.7 + math.random() * 0.6)
                end

                player:AddEntityFlags(EntityFlag.FLAG_SLOW)
                if cooldown <= 0 then
                    player:ClearEntityFlags(EntityFlag.FLAG_SLOW)
                    customGrid.Data.PlayersAffected[k] = nil
                end
            else
                customGrid.Data.PlayersAffected[k] = nil
            end
        elseif player:Exists() then
            if not player:HasEntityFlags(EntityFlag.FLAG_SLOW) then
                player:AddEntityFlags(EntityFlag.FLAG_SLOW)
                customGrid.Data.PlayersAffected[k] = {Player = player, Cooldown = 30}
            end
        else
            customGrid.Data.PlayersAffected[k] = nil
        end
    end
end

function mod.lingerWebUnload(customGrid)
    for k, player in pairs(customGrid.Data.PlayersAffected) do
        if type(player) == "table" and player.Player and player.Player:Exists() then
            player.Player:ClearEntityFlags(EntityFlag.FLAG_SLOW)
        end
    end

    customGrid.Data.PlayersAffected = {}
end

function mod.lingerWebSpawn(customGrid)
    customGrid.Data.PlayersAffected = {}

    if customGrid.GridEntity.State == 1 then
        local sprite = customGrid.GridEntity:GetSprite()
        sprite:Play("Bombed", true)
    end
end

StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_UPDATE", 1, mod.lingerWebUpdate, FiendFolio.LingerWebGrid.Name)
StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_UNLOAD", 1, mod.lingerWebUnload, FiendFolio.LingerWebGrid.Name)
StageAPI.AddCallback("FiendFolio", "POST_SPAWN_CUSTOM_GRID", 1, mod.lingerWebSpawn, FiendFolio.LingerWebGrid.Name)

FiendFolio.SootTagGridOld = StageAPI.CustomGrid("FFSootTagOld", {
    BaseType = GridEntityType.GRID_SPIDERWEB,
    Anm2 = "gfx/grid/web/grid_soottag_old.anm2",
    Animation = "Idle",
    RemoveOnAnm2Change = true,
    OverrideGridSpawns = true,
    SpawnerEntity = {Type = FiendFolio.FFID.Grid, Variant = 1031}
})
StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_UPDATE", 1, mod.lingerWebUpdate, FiendFolio.SootTagGridOld.Name)
StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_UNLOAD", 1, mod.lingerWebUnload, FiendFolio.SootTagGridOld.Name)
StageAPI.AddCallback("FiendFolio", "POST_SPAWN_CUSTOM_GRID", 1, mod.lingerWebSpawn, FiendFolio.SootTagGridOld.Name)