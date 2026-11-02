local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

FiendFolio.AddItemPickupCallback(function(player, added)
    local date = os.date("%a")
    if date == "Tue" then
        player:AddSoulHearts(4)
    end
end, nil, mod.ITEM.COLLECTIBLE.BOUNCING_BALL_2)

local function tearsUp(firedelay, val)
	local currentTears = 30 / (firedelay + 1)
	local newTears = currentTears + val
	return math.max((30 / newTears) - 1, -0.99)
end

mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ITEM.COLLECTIBLE.BOUNCING_BALL_2, function(_, player, cacheFlags)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.BOUNCING_BALL_2) then
        if cacheFlags == CacheFlag.CACHE_DAMAGE then
            if mod:GetEntityData(player).BouncingBallStat and mod:GetEntityData(player).BouncingBallStat == 1 then
                player.Damage = player.Damage + (0.3 * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.BOUNCING_BALL_2))
            end
            local level = game:GetLevel()
            local levelNum = level:GetStage()
            local stageType = level:GetStageType()
            if levelNum == LevelStage.STAGE2_2 and stageType == StageType.STAGETYPE_REPENTANCE_B
            or levelNum == LevelStage.STAGE4_1 and stageType == StageType.STAGETYPE_REPENTANCE
            or #Isaac.FindByType(EntityType.ENTITY_MOTHERS_SHADOW, -1, -1) > 0 then
            --If in ashpit, corpse, or chase sequence
                player.Damage = player.Damage + (3 * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.BOUNCING_BALL_2))
            end
            if mod:GetEntityData(player).ffsavedata and mod:GetEntityData(player).ffsavedata.BallTwoTriedPickingUpQuestItem then
                player.Damage = player.Damage + (7 * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.BOUNCING_BALL_2))
            end
        end
        if cacheFlags == CacheFlag.CACHE_FIREDELAY then
            if Options.Filter then
                player.MaxFireDelay = tearsUp(player.MaxFireDelay, (0.66 * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.BOUNCING_BALL_2)))
            end
        end
        if cacheFlags == CacheFlag.CACHE_RANGE then
            if mod:GetEntityData(player).BouncingBallStat and mod:GetEntityData(player).BouncingBallStat == 2 then
                player.TearRange = player.TearRange - (20 * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.BOUNCING_BALL_2))
            end
        end
	end
end)

mod:AddCollectibleCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.ITEM.COLLECTIBLE.BOUNCING_BALL_2, function(_, player)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.BOUNCING_BALL_2) then
        if math.random(50) == 1 then
            mod:GetEntityData(player).BouncingBallStat = math.random(2)
            player:AddCacheFlags(CacheFlag.CACHE_ALL)
			player:EvaluateItems()
        end
        if not player:HasTrinket(mod.ITEM.TRINKET.ONE_OF_YOUR_BOMBS) then
            local numBombs = player:GetNumBombs()
            if numBombs > 0 and math.random(50) == 1 then
                --TODO work with copper, giga, bronze, silver, faulty and fringle bombs
                player:AddBombs(-1)
                sfx:Play(mod.Sounds.TheShittiestGulpSoundEver, 1, 0)
                player:AnimateTrinket(mod.ITEM.TRINKET.ONE_OF_YOUR_BOMBS, "UseItem")
                player:AddSmeltedTrinket(mod.ITEM.TRINKET.ONE_OF_YOUR_BOMBS)
                game:GetHUD():ShowItemText(player, Isaac.GetItemConfig():GetTrinket(mod.ITEM.TRINKET.ONE_OF_YOUR_BOMBS))
            end
        end
	end
end)
mod:AddCollectibleCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.ITEM.COLLECTIBLE.BOUNCING_BALL_2, function(_, npc)
    for i = 1, math.random(10) do
	    local ball = Isaac.Spawn(mod.FF.BouncingBall.ID, mod.FF.BouncingBall.Var, mod.FF.BouncingBall.Sub, npc.Position, RandomVector(), npc)
        ball:Update()
    end
end)

function mod:BouncingBallEffect(e)
    local sprite = e:GetSprite()
    local d = mod:GetEntityData(e)

    if not d.init then
        d.init = true

        d.startVel = 0.99 + (math.random() * 0.01)
        d.slowVel = 1 - d.startVel

        e.Color = Color(math.random(),math.random(),math.random())

        d.Height = 0
        local initialVelocity = (math.random() * 20)
        d.fallVel = - initialVelocity
        e.Velocity = e.Velocity * (0.5 * initialVelocity)
    end

    e.Velocity = e.Velocity * (d.startVel + (math.random() * d.slowVel))
    e.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS

    if not sprite:IsPlaying("Bounce") then
        mod:spritePlay(sprite, "Idle")
    end

    d.fallVel = d.fallVel + 1
    d.Height = d.Height + d.fallVel
    if d.Height < 0 then
        d.bounced = nil
    else
        if not d.bounced then
            d.bounced = true
            if d.fallVel < 3 then
                d.dying = 0
            else
                mod:spritePlay(sprite, "Bounce")
                sfx:Play(mod.Sounds.BrownedBoing, d.fallVel / 50, 0, false, d.fallVel / 8)
                d.fallVel = d.fallVel * -1
                d.fallVel = math.max(-20, d.fallVel)
                d.Height = 0
            end
        end
    end
    
    
    if d.dying then
        d.dying = d.dying + 1
        e.Color = Color(e.Color.R, e.Color.G, e.Color.B, 1 - (d.dying / 10))
        if d.dying >= 10 then
            e:Remove()
        end
    else
        e.SpriteOffset = Vector(0, d.Height)
    end
end

local planetariumUp

mod:AddCollectibleCallback(ModCallbacks.MC_POST_RENDER, mod.ITEM.COLLECTIBLE.BOUNCING_BALL_2, function()
    local player = Isaac.GetPlayer(0):ToPlayer()
    if not mod:GetEntityData(player).bouncingBallPlanetariumChanceActivated then
        Isaac.RenderText("Press G if you want +20% Planetarium Chance",  100, 78, 255, 255, 255, 1)
            
        if game:IsPaused() then return end
        local ci = player.ControllerIndex
        if mod.AnyKeyboardTriggered(Keyboard.KEY_G, ci) then
            mod:GetEntityData(player).bouncingBallPlanetariumChanceActivated = true
        end
    end
end)

mod:AddCollectibleCallback(ModCallbacks.MC_PRE_PLANETARIUM_APPLY_TELESCOPE_LENS, mod.ITEM.COLLECTIBLE.BOUNCING_BALL_2, function(_, chance)
    local player = Isaac.GetPlayer(0):ToPlayer()
    if mod:GetEntityData(player).bouncingBallPlanetariumChanceActivated then
        return chance + 0.2
    end
end)

mod:AddCollectibleCallback(ModCallbacks.MC_POST_UPDATE, mod.ITEM.COLLECTIBLE.BOUNCING_BALL_2, function(_, chance)
    local level = game:GetLevel()
    local levelNum = level:GetStage()
    local stageType = level:GetStageType()
    if levelNum == LevelStage.STAGE4_2 and stageType == StageType.STAGETYPE_AFTERBIRTH then
        if math.random(100) == 1 then
            local room = game:GetRoom()
            Isaac.Spawn(5, 70, 0, room:FindFreePickupSpawnPosition(Isaac.GetRandomPosition(), 40, true), Vector.Zero, nil)
        end
    end
end)

mod.BouncingBallPillsTakenTracker = 0

mod:AddCollectibleCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.ITEM.COLLECTIBLE.BOUNCING_BALL_2, function(_, entity, amount, flags, src, frames)
    local level = game:GetLevel()
    local levelNum = level:GetStage()
    local stageType = level:GetStageType()
    if levelNum == LevelStage.STAGE4_2 and stageType == StageType.STAGETYPE_AFTERBIRTH then
        if entity:ToNPC() then
            local npc = entity:ToNPC()
            if npc:IsBoss() then
                if mod.BouncingBallPillsTakenTracker < 10 then
                    return false
                end
            end
        end
    end
end)

mod:AddCollectibleCallback(ModCallbacks.MC_USE_PILL, mod.ITEM.COLLECTIBLE.BOUNCING_BALL_2, function()
    mod.BouncingBallPillsTakenTracker = mod.BouncingBallPillsTakenTracker + 1
end)

mod:AddCollectibleCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.ITEM.COLLECTIBLE.BOUNCING_BALL_2, function(_, pickup, coll, bool)
    if coll:ToPlayer() then
        local player = coll:ToPlayer()
        if player:HasCollectible(mod.ITEM.COLLECTIBLE.BOUNCING_BALL_2) then
            if pickup.SubType > 0 then
                local item = Isaac.GetItemConfig():GetCollectible(pickup.SubType)
                if item:HasTags(ItemConfig.TAG_QUEST) then
                    if not mod:GetEntityData(player).ffsavedata.BallTwoTriedPickingUpQuestItem then
                        mod:GetEntityData(player).ffsavedata.BallTwoTriedPickingUpQuestItem = true
                        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                        player:EvaluateItems()
                    end
                    Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, coll, bool)
                    return false
                end
            end
        end
    end
end, 100)