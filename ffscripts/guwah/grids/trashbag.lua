local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

FiendFolio.TrashbagGrid = StageAPI.CustomGrid("FFTrashbag", {
    BaseType = GridEntityType.GRID_POOP,
    Anm2 = "gfx/grid/grid_trashbag.anm2",
    Animation = "State1",
    OverrideGridSpawns = true,
    RemoveOnAnm2Change = true,
    PoopExplosionColor = mod.ColorDankBlackReal,
    PoopGibSheet = "gfx/grid/grid_trashbag_gibs.png",
    SpawnerEntity = {Type = FiendFolio.FFID.Grid, Variant = 1037},
})

StageAPI.AddCallback("FiendFolio", "POST_SPAWN_CUSTOM_GRID", 1, function(customGrid)
    local grid = customGrid.GridEntity
	local sprite = grid:GetSprite()
	FiendFolio.SetPoopSpriteState(grid, sprite)
    --print(mod:CheckStage("Dross", {45}))
    if mod:CheckStage("Dross", {45}) then
        sprite:ReplaceSpritesheet(0, "gfx/grid/grid_trashbag_dross.png")
        sprite:LoadGraphics()
        customGrid.GridConfig.PoopGibSheet = "gfx/grid/grid_trashbag_gibs_dross.png"
    end
end, "FFTrashbag")

StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_UPDATE", 1, function(customGrid)
    if customGrid:IsOnGrid() then
        local grid = customGrid.GridEntity

    end
end, "FFTrashbag")

StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_DESTROY", 1, function(customGrid, projectile)
    local pos = customGrid.Position
    local rng = customGrid.RNG

    sfx:Play(SoundEffect.SOUND_MUSHROOM_POOF, 1.5, 0, false, 1.5)

    local enemychance = 0.5
    local pickupchance = 0.33
    local maxextraflies = 1
    if mod:CheckStage("Dank Depths", {9}) then
        local creep = Isaac.Spawn(1000,26,0,pos,Vector.Zero,nil)
        creep.SpriteScale = Vector(1.5,1.5)
        creep:Update()
        maxextraflies = 2
    end
    if customGrid.PersistentData.NoReward then
        enemychance = 1
        pickupchance = 0
    end

    if rng:RandomFloat() <= enemychance then --Enemies (Flies)
        local spawner = Isaac.Spawn(17,0,0,pos,Vector.Zero,nil)
        spawner.Visible = false
        mod:TrashbaggerUnboxing(spawner, mod:RandomInt(0,maxextraflies), rng)
        spawner:Remove()
    else --Familiars
        local player = game:GetNearestPlayer(pos)
        for i = 1, mod:RandomInt(1,2,rng) do
            if rng:RandomFloat() <= 0.33 then
                local skuzz = Isaac.Spawn(3, mod.ITEM.FAMILIAR.ATTACK_SKUZZ, 0, pos, Vector.Zero, nil):ToFamiliar()
                skuzz.Player = player
                skuzz:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            elseif rng:RandomFloat() <= 0.66 then
                local fly = Isaac.Spawn(3, 43, 0, pos, RandomVector() * 3, nil):ToFamiliar()
                fly.Player = player
                fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            elseif rng:RandomFloat() <= 0.5 then
                player:ThrowBlueSpider(pos, pos + RandomVector() * 3)
            else
                mod:ThrowBlueBeetle(player, pos)
            end
        end
    end

    if rng:RandomFloat() <= pickupchance then --Pickups
        if rng:RandomFloat() <= 0.1 then
            local randWorm = mod:GetRandomElem(mod.TrashBagMiscs.Worms, rng)
            local picky = Isaac.Spawn(5, 350, randWorm, pos, Vector.Zero, nil)
            mod:GetEntityData(picky).bloodsackspawned = true
        elseif rng:RandomFloat() <= 0.5 then
            local randHeart = mod:GetRandomElem(mod.TrashBagMiscs.Hearts, rng)
            local gameData = Isaac.GetPersistentGameData()

			while (
				(randHeart == HeartSubType.HEART_BONE and (not gameData:Unlocked(Achievement.BONE_HEARTS)))
				or (randHeart == HeartSubType.HEART_ROTTEN and (not gameData:Unlocked(Achievement.ROTTEN_HEARTS)))
				or (randHeart == HeartSubType.HEART_HALF_SOUL and (not gameData:Unlocked(Achievement.EVERYTHING_IS_TERRIBLE)))
				or (randHeart == mod.PICKUP.VARIANT.MORBID_HEART and (not mod.ACHIEVEMENT.MORBID_HEART:IsUnlocked()))
				or (randHeart == mod.PICKUP.VARIANT.TWOTHIRDS_MORBID_HEART and (not mod.ACHIEVEMENT.MORBID_HEART:IsUnlocked()))
				or (randHeart == mod.PICKUP.VARIANT.THIRD_MORBID_HEART and (not mod.ACHIEVEMENT.MORBID_HEART:IsUnlocked()))
			) do
				randHeart = mod.TrashBagMiscs.Hearts[rng:RandomInt(#mod.TrashBagMiscs.Hearts) + 1]
			end
            local picky = Isaac.Spawn(5, 10, randHeart, pos, Vector.Zero, nil)
            mod:GetEntityData(picky).bloodsackspawned = true
        else
            local picky = Isaac.Spawn(5, 20, 0, pos, Vector.Zero, nil)
            mod:GetEntityData(picky).bloodsackspawned = true
        end
    end
end, "FFTrashbag")

StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_DIRTY_MIND_SPAWN", 1, function(customGrid, familiar)
    local player = familiar.Player

    local dip = player:ThrowFriendlyDip(674, familiar.Position, familiar.TargetPosition)
	dip.SplatColor = mod.ColorDankBlackReal

    familiar.Visible = false
    familiar:Remove()
end, "FFTrashbag")

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, familiar)
    if familiar.SubType == 674 then
        familiar.SplatColor = mod.ColorDankBlackReal
    end
end, FamiliarVariant.DIP)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, entity)
    mod.TrashBagDipSpawns = mod.TrashBagDipSpawns or {}
	if entity.Variant == FamiliarVariant.DIP and entity.SubType == 674 and not mod.TrashBagDipSpawns[entity.InitSeed] and entity.HitPoints <= 0 then
        local rng = entity:GetDropRNG()
        mod.TrashBagDipSpawns[entity.InitSeed] = true
        local num = rng:RandomInt(3)+1
        sfx:Play(SoundEffect.SOUND_MUSHROOM_POOF, 2, 0, false, 1.5)
        for i=1,num do
            local var = FamiliarVariant.BLUE_FLY
            local roll = rng:RandomInt(4)
            if roll == 1 then
                var = FamiliarVariant.BLUE_SPIDER
            elseif roll == 2 then
                var = mod.ITEM.FAMILIAR.ATTACK_SKUZZ
            elseif roll == 3 then
                var = mod.ITEM.FAMILIAR.BLUE_BEETLE
            end
            local fam = Isaac.Spawn(3, var, 0, entity.Position, Vector.Zero, entity):ToFamiliar()
            fam:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        end
	end
end, EntityType.ENTITY_FAMILIAR)