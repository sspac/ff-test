local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local bal = {
    Init = 290, --Sets itself to this if you are above it, so it doesn't poop immediately (okay this made it feel a bit bad when too low)
    Min = 320,
    Max = 650,
    Inc = 65,
    WarningTime = 60,
    WarnSplats = {0.1, 0.7},

    VelMult = 4, --Multiplies player velocity by this, then checks behind when spawning poop to prevent it from spawning in front of player's movement.
    PoopCount = {3,7},
    PoopMax = 10,
    PoopFreq = 4,
    FartRad = 100,
    FartRadSmall = 55,

    BagChance = {40, 10},
    DecayFreq = 14,
    DecayAmount = 0.16,
    SpeedFreq = 3,
    SpeedLerp = 0.05,
    SpeedSubtract = 0.01,

    DipRadius = 50,
    DipConfuse = 110,

    DizzyDecrease = 110,
}

local function IsGridPoopUnderPlayer(grid)
    return grid:ToPoop() and grid:ToPoop().UnderPlayer
end

local color = Color(0.8, 0.5, 0.5, 1, 0.1, 0.05, 0, 0.6, 0.2, 0, 0.8)
local blacklists = {[GridEntityType.GRID_TRAPDOOR] = true, [GridEntityType.GRID_PRESSURE_PLATE] = true, [GridEntityType.GRID_TELEPORTER] = true,}
function mod:EighteenFootLeashUpdate(player)
    local d = mod:GetEntityData(player)
    local sd = d.ffsavedata.RunEffects
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.EIGHTEEN_FOOT_LEASH) then
        if not d.IntestineLeash18 then
            d.IntestineLeash18 = {Timer = 0, Event = bal.Min}
        end

        local tab = d.IntestineLeash18
        if (mod.IsActiveRoom() and Isaac.CountEnemies() > 0) or (tab.Warning or tab.Pooping) then
            local mult = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.EIGHTEEN_FOOT_LEASH)
            local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.EIGHTEEN_FOOT_LEASH)
            
            if tab.Pooping then
                if tab.Pooping > 0 then
                    local room = game:GetRoom()
                    if tab.Timer % bal.PoopFreq == 1 then
                        local index = room:GetGridIndex(player.Position-player.Velocity*bal.VelMult)
                        local checkGrid = room:GetGridEntity(index)
                        if room:GetGridCollision(index) == GridCollisionClass.COLLISION_NONE
                        and not (checkGrid and ((blacklists[checkGrid:GetType()]) or IsGridPoopUnderPlayer(checkGrid))) then
                            if mod.DruggedPoopGrid:Spawn(index, true, false, {LeashMult = mult, PlayAppear = true}) then
                                for i=1,2 do
                                    local fly = Isaac.Spawn(1000, EffectVariant.TINY_FLY, 0, player.Position, Vector.Zero, player)
                                end
                                sfx:Play(SoundEffect.SOUND_FART, 0.9, 0, false, mod:RandomInt(90,110,rng)/100)
                                --[[local data = FiendFolio.savedata.run
                                local currentRoom = game:GetLevel():GetCurrentRoomDesc().ListIndex
                                data.EighteenFootLeashPoops = data.EighteenFootLeashPoops or {}
                                data.EighteenFootLeashPoops[currentRoom] = data.EighteenFootLeashPoops[currentRoom] or {}
                                data.EighteenFootLeashPoops[currentRoom][index] = {Mult = mult}]]
                                tab.Pooping = tab.Pooping-1

                                local splat = Isaac.Spawn(1000, EffectVariant.BLOOD_SPLAT, 0, player.Position, Vector.Zero, player):ToEffect()
                                splat.Color = mod.ColorPoop
                                local scale = mod:RandomInt(13,16,rng)/10
                                splat.SpriteScale = Vector(scale, scale)
                                splat:Update()

                                local poof = Isaac.Spawn(1000, EffectVariant.TEAR_POOF_A, 0, room:GetGridPosition(index), Vector.Zero, player):ToEffect()
                                poof.Color = Color(1.5, 1.5, 1.5, 0.5, -0.4, -0.45, -0.4, 0.7, 0.6, 0.5, 1)
								poof.DepthOffset = -40
                                poof:Update()

                                game:ButterBeanFart(player.Position, bal.FartRadSmall, player, false, false)

                                for i=1,6 do
                                    local vel = Vector(mod:RandomInt(10,40,rng)/10, 0):Rotated(rng:RandomInt(360))
                                    local drop = Isaac.Spawn(1000, EffectVariant.WATER_SPLASH, 1, player.Position, vel, player):ToEffect()
                                    drop.FallingSpeed = -mod:RandomInt(60,120,rng)/10
                                    drop.m_Height = -5
                                    drop.Color = mod.ColorPoop
                                    drop.SpriteScale = Vector(1.1, 1.1)
                                end
                            end
                        end
                    end

                    local lerped = Color.Lerp(tab.ExtraColor, tab.OriginalColor, 0.06)
                    tab.ExtraColor = lerped
                    player:SetColor(lerped, 10, 0, true, false)

                    if tab.Timer % 5 == 0 then
                        local splat = Isaac.Spawn(1000, EffectVariant.BLOOD_SPLAT, 0, player.Position, Vector.Zero, player):ToEffect()
                        splat.Color = mod.ColorPoop
                        splat.SpriteScale = Vector(bal.WarnSplats[2], bal.WarnSplats[2])
                        splat:Update()
                    end
                else
                    tab.Pooping = nil
                    tab.Timer = 0
                end
            elseif tab.Warning then
                if tab.Timer % 3 == 0 then
                    local splat = Isaac.Spawn(1000, EffectVariant.BLOOD_SPLAT, 0, player.Position, Vector.Zero, player):ToEffect()
                    splat.Color = mod.ColorPoop
                    local scale = bal.WarnSplats[1]+(bal.WarnSplats[2]-bal.WarnSplats[1])*tab.Timer/bal.WarningTime
                    splat.SpriteScale = Vector(scale, scale)
                    splat:Update()
                end

                local lerped = Color.Lerp(tab.ExtraColor, color, 0.035)
                tab.ExtraColor = lerped
                player:SetColor(lerped, 10, 0, true, false)

                if tab.Timer > bal.WarningTime then
                    local min = math.min(bal.PoopMax, bal.PoopCount[1]*mult)
                    local max = math.min(bal.PoopMax, bal.PoopCount[2]+(mult-1))
                    tab.Pooping = mod:RandomInt(min, max, rng)
                    tab.Warning = nil
                    tab.Timer = 0
                    tab.Event = math.min(bal.Max, tab.Event+bal.Inc)
                end
            else
                if tab.Timer > tab.Event then
                    tab.ExtraColor = player.Color
                    tab.OriginalColor = player.Color
                    tab.Warning = true
                    tab.Timer = 0
                    sfx:Play(SoundEffect.SOUND_FART, 1, 0, false, mod:RandomInt(105,115,rng)/100)
                    game:ButterBeanFart(player.Position, bal.FartRad, player, true, false)
                end
            end
            tab.Timer = tab.Timer+1
        end
    end

    if sd.EighteenFootLeashBonus then
        local changed
        if sd.EighteenFootLeashBonus.Tears > 0 and player.FrameCount % bal.DecayFreq == 0 then
            sd.EighteenFootLeashBonus.Tears = math.max(0, sd.EighteenFootLeashBonus.Tears-bal.DecayAmount)
            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
            changed = true
        end
        if sd.EighteenFootLeashBonus.Speed > 0 and player.FrameCount % bal.SpeedFreq == 0 then
            sd.EighteenFootLeashBonus.Speed = math.max(0, mod:Lerp(sd.EighteenFootLeashBonus.Speed, 0, bal.SpeedLerp)-bal.SpeedSubtract)

            player:AddCacheFlags(CacheFlag.CACHE_SPEED)
            changed = true
        end

        if sd.EighteenFootLeashBonus.Dizzy > 0 and player.FrameCount % bal.DizzyDecrease == 0 then
            sd.EighteenFootLeashBonus.Dizzy = math.max(0, sd.EighteenFootLeashBonus.Dizzy-0.005)
            local amount = game:GetDizzyAmount()
			game:SetDizzyAmount(math.max(0, amount-0.005), amount)
        end

        if changed then
            player:EvaluateItems()
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.EIGHTEEN_FOOT_LEASH, mod.EighteenFootLeashUpdate)

function mod:EighteenFootLeashNewRoom(player, d)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.EIGHTEEN_FOOT_LEASH) and d.IntestineLeash18 then
        d.IntestineLeash18.Event = bal.Min
        d.IntestineLeash18.Timer = math.min(d.IntestineLeash18.Timer, bal.Init)
        d.IntestineLeash18.Pooping = nil
        d.IntestineLeash18.Warning = nil
    end
    if d.ffsavedata.RunEffects.EighteenFootLeashBonus then
        if d.ffsavedata.RunEffects.EighteenFootLeashBonus.Dizzy > 0 then
            local amount = game:GetDizzyAmount()
			game:SetDizzyAmount(math.max(0, amount-d.ffsavedata.RunEffects.EighteenFootLeashBonus.Dizzy), amount)
        end
        d.ffsavedata.RunEffects.EighteenFootLeashBonus = nil
        player:AddCacheFlags(CacheFlag.CACHE_SPEED | CacheFlag.CACHE_FIREDELAY)
		player:EvaluateItems()
    end
end

FiendFolio.DruggedPoopGrid = StageAPI.CustomGrid("FFDruggedPoop", {
    BaseType = GridEntityType.GRID_POOP,
    Anm2 = "gfx/grid/grid_drugged_poop.anm2",
    Animation = "State1",
    OverrideGridSpawns = true,
    RemoveOnAnm2Change = true,
    PoopGibSheet = "gfx/effects/effect_poopgibs.png",
    SpawnerEntity = {Type = FiendFolio.FFID.Grid, Variant = 1050},
})

StageAPI.AddCallback("FiendFolio", "POST_SPAWN_CUSTOM_GRID", 1, function(customGrid)
    local data = customGrid.PersistentData
    local grid = customGrid.GridEntity
	local sprite = grid:GetSprite()
    local rng = customGrid.RNG
    if not data.DruggedSpritesheet then
        data.DruggedSpritesheet = "gfx/grid/grid_drugs_poop_" .. rng:RandomInt(4)+1 .. ".png"
    end
    sprite:ReplaceSpritesheet(0, data.DruggedSpritesheet, true)
    if data.PlayAppear then
        sprite:Play("Appear", true)
    else
    	FiendFolio.SetPoopSpriteState(grid, sprite)
    end
end, "FFDruggedPoop")

StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_UPDATE", 1, function(customGrid)
    local data = customGrid.PersistentData
    if data.PlayAppear then
        local grid = customGrid.GridEntity
	    local sprite = grid:GetSprite()
        if sprite:IsFinished("Appear") or not sprite:IsPlaying("Appear") then
            data.PlayAppear = nil
            FiendFolio.SetPoopSpriteState(grid, sprite)
        end
    end
end, "FFDruggedPoop")

StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_DESTROY", 1, function(customGrid, projectile)
    local rng = customGrid.RNG
    local data = customGrid.PersistentData
    local strength = (data.LeashMult or 1)
    if rng:RandomInt(100) < bal.BagChance[1]+bal.BagChance[2]*strength then
        local vec = Vector(mod:RandomInt(1,10,rng)/10, 0):Rotated(rng:RandomInt(360))
        local baggie = Isaac.Spawn(5, mod.PICKUP.VARIANT.DRUG_BAGGIE, 13, customGrid.Position, vec, nil):ToPickup()
        mod:GetEntityData(baggie).LeashMultiplier = strength
    end
end, "FFDruggedPoop")

StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_DIRTY_MIND_SPAWN", 1, function(customGrid, familiar)
    local player = familiar.Player

    local dip = player:ThrowFriendlyDip(675, familiar.Position, familiar.TargetPosition)
    dip.SplatColor = mod.ColorPoop

    familiar.Visible = false
    familiar:Remove()
end, "FFDruggedPoop")

--Just piggybacking off of the trash bag dip removal doubling thing
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, entity)
	if entity.Variant == FamiliarVariant.DIP and entity.SubType == 675 and not mod.TrashBagDipSpawns[entity.InitSeed] and entity.HitPoints <= 0 then
        local rng = entity:GetDropRNG()
        mod.TrashBagDipSpawns[entity.InitSeed] = true
		sfx:Play(SoundEffect.SOUND_BLACK_POOF, 0.25, 0, false, 1.6)
		sfx:Play(SoundEffect.SOUND_MUSHROOM_POOF, 0.4, 0, false, 1.3)
        for i=1,2 do
			local randVel = RandomVector()*mod:RandomInt(5,20,rng)/20
			local cloud = Isaac.Spawn(1000, 59, 0, entity.Position, Vector.Zero, entity):ToEffect()
			cloud:SetTimeout(mod:RandomInt(60, 90, rng))
			local color2 = Color(1, 1, 1,0,0,0,0)
			cloud.Color = color2
			local randScale = mod:RandomInt(50,75,rng)/100
			cloud.SpriteScale = Vector(0.3, 0.3)
			mod:GetEntityData(cloud).cosmeticDust = {scale = randScale, vel = randVel, alpha = 0.35}
		end
        local mult = 1+mod.getTrinketMultiplierAcrossAllPlayers(TrinketType.TRINKET_SECOND_HAND)
        for _, enemy in ipairs(Isaac.FindInRadius(entity.Position, bal.DipRadius, EntityPartition.ENEMY)) do
            enemy:AddConfusion(EntityRef(entity), bal.DipConfuse*mult, false)
        end
	end
end, EntityType.ENTITY_FAMILIAR)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, familiar)
    if familiar.SubType == 675 then
        familiar.SplatColor = FiendFolio.ColorPoopyPeople
    end
end, FamiliarVariant.DIP)

--[[
NO LONGER USED DUE TO IT BEING A PROPER VARIANT NOW

function mod:EighteenFootLeashGridNewRoom()
    local data = FiendFolio.savedata.run
	local level = game:GetLevel()
	local room = game:GetRoom()
    local currentRoom = level:GetCurrentRoomDesc().ListIndex

    if data.EighteenFootLeashPoops then
        if data.EighteenFootLeashPoops[currentRoom] then
            local entry = data.EighteenFootLeashPoops[currentRoom]
            local found
            for index,strength in pairs(entry) do
                local grid = room:GetGridEntity(index)
                if grid and grid:GetType() == GridEntityType.GRID_POOP and grid:GetVariant() == GridPoopVariant.NORMAL then
                    local sprite = grid:GetSprite()
                    sprite:ReplaceSpritesheet(0, "gfx/grid/grid_drugs_poop.png")
                    sprite:LoadGraphics()
                else
                    data.EighteenFootLeashPoops[currentRoom][index] = nil
                end
            end
            if not found then
                data.EighteenFootLeashPoops[currentRoom] = nil
            end
        end
	end
end

function mod:EighteenFootLeashNewLevel()
    local data = FiendFolio.savedata.run
    if data.EighteenFootLeashPoops then
        data.EighteenFootLeashPoops = {}
    end
end

function mod:EighteenFootLeashPoopCheck()
    local data = FiendFolio.savedata.run
    if data.EighteenFootLeashPoops then
        local level = game:GetLevel()
        local room = game:GetRoom()
        local currentRoom = level:GetCurrentRoomDesc().ListIndex
        if data.EighteenFootLeashPoops[currentRoom] then
            for index,entry in pairs(data.EighteenFootLeashPoops[currentRoom]) do
                if not entry.Expired then
                    local grid = room:GetGridEntity(index)
                    if grid and grid:GetType() == GridEntityType.GRID_POOP and grid:GetVariant() == GridPoopVariant.NORMAL
                    and room:GetGridCollision(index) == GridCollisionClass.COLLISION_NONE and not IsGridPoopUnderPlayer(grid) then
                        local rng = grid:GetRNG()
                        for _,pickup in ipairs(Isaac.FindByType(5,-1,-1,false,false)) do
                            if pickup.Position:Distance(grid.Position) < 5 and pickup.FrameCount < 2 then
                                pickup:Remove()
                            end
                        end
                        local strength = entry.Mult
                        if rng:RandomInt(100) < bal.BagChance[1]+bal.BagChance[2]*strength then
                            local vec = Vector(mod:RandomInt(1,10,rng)/10, 0):Rotated(rng:RandomInt(360))
                            local baggie = Isaac.Spawn(5, mod.PICKUP.VARIANT.DRUG_BAGGIE, 13, grid.Position, vec, nil):ToPickup()
                            mod:GetEntityData(baggie).LeashMultiplier = strength
                        end
                        entry.Expired = true
                    end
                end
            end
        end
    end
end
]]