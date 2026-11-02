local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local craiganm2 = "gfx/characters/costumes/craig/player_craig.anm2"

local maxcharges = Isaac.GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.CRAIGS_BATTERY).MaxCharges
mod.CraigOnHitCharge = 10
mod.CraigBulbRockNearCharge = 2
mod.CraigBulbRockTouchCharge = 120
mod.CraigBulbPlantChargeTiny = 30
mod.CraigBulbPlantChargeMed = 75
mod.CraigBulbPlantChargeFull = 150

mod.BulbPlantSpawnTime = 120
mod.BulbPlantSpawnLimit = 5
mod.BulbPlantGrowTime = 100

StageAPI.AddPlayerGraphicsInfo(mod.PLAYER.CRAIG, {
    Name = "gfx/ui/boss/playername_craig.png",
    Portrait = "gfx/ui/stage/playerportrait_craig.png",
    NoShake = false,
})

--[[mod.CraigItemBlacklist = {
    CollectibleType.COLLECTIBLE_BRIMSTONE,
    CollectibleType.COLLECTIBLE_SULFUR,
    CollectibleType.COLLECTIBLE_MOMS_KNIFE,
    CollectibleType.COLLECTIBLE_EPIC_FETUS,
    CollectibleType.COLLECTIBLE_DR_FETUS,
    CollectibleType.COLLECTIBLE_TRISAGION,
    CollectibleType.COLLECTIBLE_C_SECTION,
    CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE,
    --CollectibleType.COLLECTIBLE_FLAT_STONE,
    --CollectibleType.COLLECTIBLE_EYE_OF_BELIAL,
    --CollectibleType.COLLECTIBLE_TRACTOR_BEAM,
}]]

mod:AddCallback(ModCallbacks.MC_PLAYER_GET_ACTIVE_MIN_USABLE_CHARGE, function(_, slot)
    return math.floor(maxcharges * 0.33)
end, mod.ITEM.COLLECTIBLE.CRAIGS_BATTERY)

local function FireCraigLaser(player, aimVec)
    mod:GetEntityData(player).ChargingCraigLaser = false
    mod:GetEntityData(player).CraigLaserVec = aimVec
    mod:GetEntityData(player).FiringCraigLaser = true
    mod:GetEntityData(player).CraigHeadSprite:Play("firebrim"..mod:GetMoveString(aimVec), true)
    player:SetCanShoot(false)

    local charge = mod:GetEntityData(player).CraigLaserCharge
    local doBigLaser = charge >= maxcharges
    local laser = Isaac.Spawn(EntityType.ENTITY_LASER, doBigLaser and LaserVariant.THICKER_BRIM_TECH or LaserVariant.BRIM_TECH, 0, player.Position, Vector.Zero, player):ToLaser()
    laser:SetTimeout(10)
    laser.Parent = player
    laser.Angle = aimVec:GetAngleDegrees()
    laser.Color = mod.ColorElectricYellow
    laser.PositionOffset = Vector(0,-30)
    local damage = player.Damage^(charge/100)
    if doBigLaser then
        damage = damage * 1.5
        mod:PlaySound(mod.Sounds.CraigLaser,nil,1,2)
    else
        laser:SetScale(math.max(charge,50)/200)
    end
    laser.CollisionDamage = damage
    if player.Position.Y < (player.Position + aimVec).Y then
        laser.DepthOffset = 40
    else
        laser.DepthOffset = -40
    end
    laser:Update()
    return laser
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, itemType, rng, player, useFlags, slot, varData)
    if player:GetPlayerType() == mod.PLAYER.CRAIG then
        local sprite = player:GetSprite()
        local cSprite = mod:GetEntityData(player).CraigHeadSprite
        cSprite.Color = sprite.Color
        cSprite.Scale = sprite.Scale
        cSprite:Play("headchargedDown", true)
        mod:GetEntityData(player).ChargingCraigLaser = true
        mod:GetEntityData(player).CraigLaserCharge = math.min(player:GetTotalActiveCharge(slot), maxcharges)
        player:SetCanShoot(false)
    end
end, mod.ITEM.COLLECTIBLE.CRAIGS_BATTERY)

local directions = {
    [Direction.NO_DIRECTION] = "Down",
    [Direction.LEFT] = "Left",
    [Direction.UP] = "Up",
    [Direction.RIGHT] = "Right",
    [Direction.DOWN] = "Down",
}

function mod:IsExtraAnimationPlaying(player)
	local anim = player:GetSprite():GetAnimation()
	return not (anim == "WalkDown" or anim == "WalkRight" or anim == "WalkUp" or anim == "WalkLeft")
end

mod:AddCallback(ModCallbacks.MC_PRE_RENDER_PLAYER_HEAD, function(_, player, offset)
    if not mod:IsExtraAnimationPlaying(player) then
        if mod:GetEntityData(player).ChargingCraigLaser then
            local hSprite = mod:GetEntityData(player).CraigHeadSprite
            hSprite:SetAnimation("headcharged"..directions[player:GetHeadDirection()], false)
            hSprite:Render(Isaac.WorldToScreen(player.Position))
            if Isaac.GetFrameCount() % 2 == 0 then
                hSprite:Update()
            end
            return false
        elseif mod:GetEntityData(player).FiringCraigLaser then
            local hSprite = mod:GetEntityData(player).CraigHeadSprite
            hSprite:Render(Isaac.WorldToScreen(player.Position))
            if Isaac.GetFrameCount() % 2 == 0 then
                hSprite:Update()
            end
            if hSprite:IsFinished() then
                mod:GetEntityData(player).FiringCraigLaser = false
                player:SetCanShoot(true)
            end
            return false
        end
    end
end, mod.PLAYER.CRAIG)

mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_RENDER, function(_, player, offset)
    if mod:GetEntityData(player).GotThePhone then
        local hSprite = mod:GetEntityData(player).CraigHeadSprite
        if Isaac.GetFrameCount() % 2 == 0 then
            hSprite:Update()
        end
        if hSprite:IsFinished("challengewin") then
            hSprite:Play("gaming", true)
        end
        hSprite:Render(Isaac.WorldToScreen(player.Position))
        return false
    end
end)

local BatterySprite = Sprite()
BatterySprite:Load("gfx/characters/costumes/craig/collectible_craigs_battery.anm2", true)

mod:AddCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_ACTIVE_ITEM, function(_, player, slot, offset, alpha)
    local pkitem = player:GetPocketItem(0)
    local ispocketactive = (pkitem:GetSlot() == 3 and pkitem:GetType() == 2)
    local renderPos = Vector(16, 16)
    local renderScale = Vector(1, 1)
    local charge = player:GetActiveCharge(slot)
    local frame = 0
    if charge >= maxcharges then
        frame = 3
    elseif charge >= maxcharges * 0.66 then
        frame = 2
    elseif charge >= maxcharges * 0.33 then
        frame = 1
    end

    if slot == ActiveSlot.SLOT_SECONDARY or (not ispocketactive) then
        renderPos = renderPos / 2
        renderScale = renderScale / 2
    end
    BatterySprite:SetFrame("Battery", frame)
    BatterySprite.Scale = renderScale
    BatterySprite:Render(renderPos + offset, Vector.Zero, Vector.Zero)
end, mod.ITEM.COLLECTIBLE.CRAIGS_BATTERY)

function mod:HasCraigBattery(player)
    return player:HasCollectible(mod.ITEM.COLLECTIBLE.CRAIGS_BATTERY, true)
end

function mod:TryAddCraigBatteryCharge(player, amount, doEffect)
    player = player:ToPlayer()
    local didCharge
    if mod:HasCraigBattery(player) then
        for slot = ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET2 do
            if player:GetActiveItem(slot) == mod.ITEM.COLLECTIBLE.CRAIGS_BATTERY then
                local charge = player:GetTotalActiveCharge(slot)
                player:AddActiveCharge(amount, slot, false, true, true)
                if player:GetTotalActiveCharge(slot) > charge then
                    didCharge = true
                end
            end
        end
    end
    if didCharge and doEffect then
        sfx:Play(SoundEffect.SOUND_BATTERYCHARGE, 0.5)
        local icon = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 1, player.Position, Vector.Zero, player):ToEffect()
        icon.SpriteOffset = Vector(0,-40)
        icon:FollowParent(player)
        icon:Update()
    end
    return didCharge
end

function mod:IsRoomActive()
    local room = game:GetRoom()
    return (room:IsAmbushActive() or not room:IsClear())
end

function mod:CraigBatteryUpdate(player, data)
    if mod:HasCraigBattery(player) then
        for slot = ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET2 do
            if player:GetActiveItem(slot) == mod.ITEM.COLLECTIBLE.CRAIGS_BATTERY then
                local charge = player:GetTotalActiveCharge(slot)
                if charge >= maxcharges * 2 then
                    player.Velocity = RandomVector() * 20
                    player:SetActiveCharge(0, slot)
                    game:BombExplosionEffects(player.Position, player.Damage * 100, 0, mod.ColorElectricYellow, nil, 1.5)
                end
                if charge > 0 and not mod:IsRoomActive() then
                    player:SetActiveCharge(charge - 1, slot)
                end
            end
        end

        local spawnrate
        if mod:IsRoomActive() and mod.GetEntityCount(mod.FF.BulbPlant.ID, mod.FF.BulbPlant.Var, mod.FF.BulbPlant.Sub) < mod.BulbPlantSpawnLimit then
            if not StageAPI.IsCustomGrid(nil, "FFBulbRock") then
                spawnrate = spawnrate and math.floor(spawnrate/2) or mod.BulbPlantSpawnTime
            end
            if player:GetPlayerType() == mod.PLAYER.CRAIG and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
                spawnrate = spawnrate and math.floor(spawnrate/2) or mod.BulbPlantSpawnTime
            end
        end

        local roomFrame = game:GetRoom():GetFrameCount()
        if spawnrate and roomFrame > 1 and roomFrame % spawnrate == 10 then
            local spawnPos = mod:FindSafeSpawnSpot(player.Position, nil, nil, true, 120, true)
            Isaac.Spawn(mod.FF.BulbPlant.ID, mod.FF.BulbPlant.Var, mod.FF.BulbPlant.Sub, spawnPos, Vector.Zero, player)
        end

        if data.GiveBulbRockHitCharge then
            mod:TryAddCraigBatteryCharge(player, mod.CraigBulbRockTouchCharge, true)
            data.GiveBulbRockHitCharge = false
        end

		local hasBirthcake, birthcakeMult = mod:playerHasBirthcake(player)
		if player:GetPlayerType() == FiendFolio.PLAYER.CRAIG and hasBirthcake then
			for _, enemy in ipairs(Isaac.FindInRadius(player.Position, 80, EntityPartition.ENEMY)) do
				if enemy:ToNPC() and enemy.HitPoints > 0 and not enemy:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) and
				   enemy:IsVulnerableEnemy() and not mod:isFriend(enemy) and
				   mod:TryAddCraigBatteryCharge(player, (game:GetFrameCount() % 2 == 0 and 1 + birthcakeMult) or 1) and game:GetFrameCount() % 3 == 0
				then
					local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HAEMO_TRAIL, 0, enemy.Position, (player.Position-enemy.Position):Rotated(mod:RandomInt(-10,10))/7, player)
					effect.Color = mod.ColorElectricYellowA
					effect.SpriteScale = Vector(0.5,0.5)
					effect.SpriteOffset = Vector(0,-10)
					effect:Update()
				end
			end
        end
    end
end

local function LoadCraigSkin(player, sprite)
    sprite:Load(craiganm2, true)
    sprite:Play(player:GetSprite():GetDefaultAnimationName(), true)
    local cSprite = Sprite()
    cSprite:Load(craiganm2, true)
    mod:GetEntityData(player).CraigHeadSprite = cSprite
end

local function CraigInit(player, addItem)
    LoadCraigSkin(player, player:GetSprite())
    if addItem then
        player:SetPocketActiveItem(mod.ITEM.COLLECTIBLE.CRAIGS_BATTERY)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_, player)
    if game.Challenge == mod.challenges.craigChallenge then
        player:ChangePlayerType(mod.PLAYER.CRAIG)
        CraigInit(player, true)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    local data = mod:GetEntityData(player)
    local sprite = player:GetSprite()

    if mod:ShouldPlayerGetInitialised(player) then
        CraigInit(player, true)
    elseif sprite:GetFilename() ~= craiganm2 then
        CraigInit(player)
    end
    player:ClearCostumes()

    if mod:GetEntityData(player).ChargingCraigLaser and player:GetAimDirection():Length() > 0.1 then
        FireCraigLaser(player, player:GetAimDirection(), mod:GetEntityData(player).CraigBatteryUsedSlot)
    end
end, mod.PLAYER.CRAIG)

mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_SELECT, function(_, levelStage, stageType)
    if game.Challenge == mod.challenges.craigChallenge then
        if levelStage >= LevelStage.STAGE2_2 then
            return {LevelStage.STAGE2_2, StageType.STAGETYPE_REPENTANCE}
        else
            return {LevelStage.STAGE2_1, StageType.STAGETYPE_REPENTANCE}
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, flag)
    if player:GetPlayerType() == mod.PLAYER.CRAIG then
        if flag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage * 0.5
        elseif flag == CacheFlag.CACHE_FIREDELAY then
            --player.MaxFireDelay = player.MaxFireDelay * 1.5 -- direct maxfiredelay multipliers break at negative firedelay values
			player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, mod:convertTearMultABPToRep(1.5))
        elseif flag == CacheFlag.CACHE_RANGE then
            player.TearRange = player.TearRange * 0.5
        elseif flag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + 0.3
        elseif flag == CacheFlag.CACHE_TEARCOLOR then
            player.TearColor = player.TearColor * mod.ColorCraigTears
            player.LaserColor = player.LaserColor * mod.ColorElectricYellow
        end
    end
end)

function mod:CraigOnFireTear(tear, player) --Replaces tears with lasers
    local vel = tear.Velocity
    if tear.ContinueVelocity:Length() > 0 then --Anti-Gravity
        vel = tear.ContinueVelocity
    end
    local laser = player:FireTechLaser(tear.Position, -1, vel:Rotated(mod:RandomInt(-5,5)), false, true, player, tear.CollisionDamage/player.Damage)
    laser:SetMaxDistance(player.TearRange)
    laser.PositionOffset = Vector(0,-20)
    tear.Visible = false
    tear:Remove()
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, itemID, rng, player, useFlags, slot, varData)
    if player:GetPlayerType() == mod.PLAYER.CRAIG then
        sfx:Play(mod.Sounds.CraigJump, 1.5)
        sfx:Play(SoundEffect.SOUND_FETUS_JUMP)
    end
end, CollectibleType.COLLECTIBLE_HOW_TO_JUMP)

local function BulbPlantSplat(effect, player)
    local data = mod:GetEntityData(effect)
    local splatsub = 0
    if data.Suffix == "tiny" then
        splatsub = 1
    end
    local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, splatsub, effect.Position, Vector.Zero, effect)
    splat.Color = FiendFolio.ColorBulbSplat
    if data.Suffix == "med" then
        splat.SpriteScale = Vector(0.7,0.7)
    end
    splat:Update()
    sfx:Play(SoundEffect.SOUND_BULB_FLASH)
    sfx:Play(SoundEffect.SOUND_DEATH_BURST_SMALL, 1, 0, false, 1.5)
    effect:GetSprite():Play("Popped"..data.Suffix)
    if player then
        mod:TryAddCraigBatteryCharge(player, data.ChargeAmount, true)
    end
    data.Coll = false
end

function mod:BulbPlant(effect, sprite, data)
    if not data.Init then
        data.GrowTimer = mod.BulbPlantGrowTime
        data.Size = 8
        data.ChargeAmount = mod.CraigBulbPlantChargeTiny
        data.Suffix = "tiny"
        data.Init = true
    end

    if sprite:IsFinished("Appear"..data.Suffix) or sprite:IsFinished("grow"..data.Suffix) then
        sprite:Play("idle"..data.Suffix)
    elseif sprite:IsFinished("Popped"..data.Suffix) then
        effect:Remove()
    end

    if sprite:IsEventTriggered("Coll") then
        data.Coll = true
    elseif sprite:IsEventTriggered("grow") then
        if data.Suffix == "med" then
            data.ChargeAmount = mod.CraigBulbPlantChargeMed
        elseif data.Suffix == "full" then
            data.ChargeAmount = mod.CraigBulbPlantChargeFull
        end
    end

    if data.Coll then
        data.GrowTimer = data.GrowTimer - 1
        if data.GrowTimer <= 0 and not data.MaxSize then
            data.GrowTimer = mod.BulbPlantGrowTime
            if data.Suffix == "tiny" then
                data.Suffix = "med"
                data.Size = 13
            elseif data.Suffix == "med" then
                data.Suffix = "full"
                data.Size = 18
                data.MaxSize = true
            end
            sprite:Play("grow"..data.Suffix, true)
        end

        local player = game:GetNearestPlayer(effect.Position)
        if player.Position:Distance(effect.Position) < data.Size + player.Size then
            BulbPlantSplat(effect, player)
        elseif game:GetRoom():GetGridPathFromPos(effect.Position) > 900 or not mod:IsRoomActive() then
            BulbPlantSplat(effect)
        end
    end
end

mod:AddCallback("FF_PLAYER_HURT_SOUND", function()
    sfx:Play(mod.Sounds.CraigHurt, 1.5)
    return true
end, mod.PLAYER.CRAIG)

mod:AddCallback("FF_PLAYER_DEATH_SOUND", function()
    sfx:Stop(mod.Sounds.CraigHurt)
    sfx:Play(mod.Sounds.CraigDeath, 1.5)
    return true
end, mod.PLAYER.CRAIG)

local CraigRNG = RNG()

mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_PLACE_ROOM, function(_, levelGenRoom, roomConfigRoom)
	if game.Challenge == mod.challenges.craigChallenge then
        CraigRNG:Next()
        if (roomConfigRoom.Type == RoomType.ROOM_DEFAULT or roomConfigRoom.Type == RoomType.ROOM_TREASURE) and not (levelGenRoom:GenerationIndex() <= 0) then
            local minDiff, maxDiff = 0,10
            if game:GetLevel():GetStage() == LevelStage.STAGE2_2 and roomConfigRoom.Type == RoomType.ROOM_DEFAULT then
                minDiff, maxDiff = 10,15
            end
            local newData = RoomConfigHolder.GetRandomRoom(CraigRNG:GetSeed(), true, StbType.MINES, roomConfigRoom.Type, roomConfigRoom.Shape, nil, nil, minDiff, maxDiff, roomConfigRoom.Doors, 451)
            if newData then
                return newData
            end
        end
    end
end)

local CraigBossSelectRNG = RNG()
mod:AddCallback(ModCallbacks.MC_PRE_BOSS_SELECT, function(_, bossID, bossPool, levelStage, stageType)
    if game.Challenge == mod.challenges.craigChallenge then
        CraigBossSelectRNG:SetSeed(game:GetSeeds():GetStageSeed(levelStage), 35)
        if levelStage == LevelStage.STAGE2_1 then
            return (CraigBossSelectRNG:RandomFloat() <= 0.5 and BossType.TUFF_TWINS or BossType.HORNFEL)
        elseif levelStage == LevelStage.STAGE2_2 then
            return BossType.GREAT_GIDEON
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_PLANETARIUM_CALCULATE, function(_, chance)
    if game.Challenge == mod.challenges.craigChallenge then
        return 0
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_DEVIL_CALCULATE, function(_, chance)
    if game.Challenge == mod.challenges.craigChallenge then
        return 0
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, function()
    if game.Challenge == mod.challenges.craigChallenge then
        return 0
    end
end)

mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, function(_, cmd, params)
    if cmd == "makemecraig" then
        local player = Isaac.GetPlayer()
        player:ChangePlayerType(mod.PLAYER.CRAIG)
        CraigInit(player, true)
    end
end)

function mod:CharacterControlsEffect(effect)
    local player = Isaac.GetPlayer()
    local controls = EntityConfig.GetPlayer(player:GetPlayerType()):GetModdedControlsSprite()
    if controls then
        local sprite = effect:GetSprite()
        sprite:Load(controls:GetFilename(), true)
        sprite:SetFrame(player:GetName(), 0)
        effect:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR)
        effect.DepthOffset = -200
        effect:Update()
    else
        effect.Visible = false
        effect:Remove()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
    if game.Challenge == mod.challenges.craigChallenge and not isContinued then
        mod.SetChallengeDestinationIcon(mod.DestinationIcon.GIDEON)

        if game:GetLevel():GetStage() == LevelStage.STAGE2_1 then
            --mod.scheduleForUpdate(function()
                local eff = Isaac.Spawn(mod.FF.CharacterControls.ID, mod.FF.CharacterControls.Var, mod.FF.CharacterControls.Sub, game:GetRoom():GetCenterPos(), Vector.Zero, nil)
                eff.Color = Color(1,1,1,1,0.2,0.2,0.2)
                eff:Update()
            --end, 1, ModCallbacks.MC_POST_UPDATE, true)
        end
    end
end)

local phoneSub = Isaac.GetEntitySubTypeByName("Craig's Cell Phone")

function mod:craigsPhonePreSpawn(type, var, sub, pos, vel, spawner, seed)
    if game.Challenge == mod.challenges.craigChallenge
    and sub == 0 then
        return {type, var, phoneSub, seed}
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, function(_, pickup, collider)
    local player = collider:ToPlayer()
    if pickup.SubType == phoneSub and player and player:GetPlayerType() == mod.PLAYER.CRAIG then
        mod.scheduleForUpdate(function()
            local sprite = player:GetSprite()
            local cSprite = mod:GetEntityData(player).CraigHeadSprite
            cSprite.Color = sprite.Color
            cSprite.Scale = sprite.Scale
            cSprite:Play("challengewin", true)
            mod:GetEntityData(player).GotThePhone = true
            pickup.Visible = false
            pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            sfx:Play(SoundEffect.SOUND_THUMBSUP)
        end, 1)
    end
end, PickupVariant.PICKUP_TROPHY)

--Item unlocks
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, card, player, useFlags)
	for slot = ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET2 do
        if not (useFlags & UseFlag.USE_MIMIC > 0) then
            player:AddActiveCharge(12, slot, true, true)
        end
    end
    mod:GetEntityData(player).ffsavedata.virtuousCharge = (mod:GetEntityData(player).ffsavedata.virtuousCharge or 0) + 1
    mod:GetEntityData(player).ffsavedata.excelsiorBonus = (mod:GetEntityData(player).ffsavedata.excelsiorBonus or 0) + 1
    sfx:Play(SoundEffect.SOUND_REDLIGHTNING_ZAP_BURST)
end, mod.ITEM.CARD.SOUL_OF_CRAIG)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, itemType, rng, player, useFlags, slot, varData)
    local data = mod:GetEntityData(player)
    if player:GetItemState() == mod.ITEM.COLLECTIBLE.FLIP_PHONE then
        player:ResetItemState()
        player:AnimateCollectible(mod.ITEM.COLLECTIBLE.FLIP_PHONE, "HideItem", "PlayerPickup")
    else
        player:SetItemState(mod.ITEM.COLLECTIBLE.FLIP_PHONE)
        player:AnimateCollectible(mod.ITEM.COLLECTIBLE.FLIP_PHONE, "LiftItem", "PlayerPickup")
    end
    return {Discharge = false}
end, mod.ITEM.COLLECTIBLE.FLIP_PHONE)

function mod:IsPlayerDying(player)
	return player:GetSprite():GetAnimation():sub(-#"Death") == "Death" --does their current animation end with "Death"?
end

-- Called from `ffscripts/revives.lua`
function mod.TryCraigsPipeRevive(player, data, effs)
    if player:HasTrinket(mod.ITEM.TRINKET.CRAIGS_PIPE) then
        player:Revive()
        mod.DowngradeTrinket(player, mod.ITEM.TRINKET.CRAIGS_PIPE)

		-- Transform the main twin.
		if player:GetMainTwin() and GetPtrHash(player) ~= GetPtrHash(player:GetMainTwin()) then
			player = player:GetMainTwin()
			player:Revive()
		end

		if player:GetPlayerType() ~= mod.PLAYER.CRAIG then
			player:ChangePlayerType(mod.PLAYER.CRAIG)
            CraigInit(player, true)
		end
        player:AddMaxHearts(6 - player:GetMaxHearts())
        player:AddBoneHearts(-player:GetBoneHearts())
        player:AddSoulHearts(-player:GetSoulHearts())
        player:AddRottenHearts(-player:GetRottenHearts())
        player:AddHearts(-99) -- clearing out custom hp
        player:AddHearts(6)
		player:AnimateTrinket(mod.ITEM.TRINKET.CRAIGS_PIPE)
        for i = 45, 360, 45 do
            local laser = player:FireTechLaser(player.Position, -1, Vector.FromAngle(i), false, true, player, player.Damage * 50.0)
            laser:SetMaxDistance(player.TearRange * 2)
            laser.PositionOffset = Vector(0,-20)
        end
        game:ShakeScreen(10)
        player:SetMinDamageCooldown(90)
    end
end

mod:AddPlayerTempEffectCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Isaac.GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.FLIP_PHONE), function(_, player)
    local data = mod:GetEntityData(player)
    local aim = player:GetAimDirection()
    if aim:Length() > 0.2 and player:GetItemState() == mod.ITEM.COLLECTIBLE.FLIP_PHONE then
        local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, mod.TEAR.FLIP_PHONE, 0, player.Position, aim:Resized(13), player):ToTear()
        tear:AddTearFlags(TearFlags.TEAR_PIERCING)
        tear.CollisionDamage = player.Damage * 0.5
        tear.Parent = player
        --tear.Scale = 2
        --tear.Color = mod.ColorElectricYellow
        tear.FallingSpeed = 0
        tear.FallingAcceleration = -0.1
        tear.Height = -7
        mod:GetEntityData(tear).FlipPhoneSpeed = tear.Velocity:Length()
        mod:GetEntityData(tear).FlipPhoneAngle = aim:GetAngleDegrees()
        tear:Update()
        player:ResetItemState()
        player:AnimateCollectible(mod.ITEM.COLLECTIBLE.FLIP_PHONE, "HideItem", "PlayerPickup")
        local activeSlot = player:GetActiveItemSlot(mod.ITEM.COLLECTIBLE.FLIP_PHONE)
        if activeSlot and activeSlot >= 0 then
            player:DischargeActiveItem(activeSlot)
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
    local data = mod:GetEntityData(tear)
    if data.FlipPhoneSpeed then
        local player = tear.Parent
        if player and player:ToPlayer() then
            local newAim = player:ToPlayer():GetAimDirection()
            if newAim:Length() > 0.2 and newAim:GetAngleDegrees() ~= data.FlipPhoneAngle then
                data.FlipPhoneAngle = newAim:GetAngleDegrees()
                data.FlipPhoneSpeed = data.FlipPhoneSpeed + 1.5
                if data.FlipPhoneSpeed > 100 then
                    tear:Die()
                else
                    tear.Velocity = newAim:Resized(data.FlipPhoneSpeed)
                    tear:GetSprite().PlaybackSpeed = tear:GetSprite().PlaybackSpeed + 0.25
                    local color = tear:GetSprite().Color
                    color.RO = math.min(color.RO + 0.05, 1.0)
                    color.GO = math.min(color.GO + 0.05, 1.0)
                    tear:GetSprite().Color = color
                end
            end
        end

        if tear.FrameCount % 3 == 0 then
            mod:fireOverloadedLaser(tear, true, tear.CollisionDamage)
        end
    end

    tear.SpriteRotation = tear.Velocity:GetAngleDegrees()
end, mod.TEAR.FLIP_PHONE)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_DEATH, function(_, tear)
    local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.IMPACT, 0, tear.Position, Vector.Zero, tear)
    poof.Color = mod.ColorElectricYellow
    sfx:Play(SoundEffect.SOUND_POT_BREAK, 0.5, 0, false, 1.5)
    sfx:Play(SoundEffect.SOUND_MIRROR_BREAK, 0.2, 0, false, 2.5)
end, mod.TEAR.FLIP_PHONE)