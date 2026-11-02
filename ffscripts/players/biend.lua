local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

TearFlagsLib.RegisterWeapon("FF_MALICE")
TearFlagsLib.RegisterWeaponIdentityFunction(TearFlagsLib.WeaponFlag.FF_MALICE, function(entity)
    return (
        entity.Type == FiendFolio.FF.BallOfMalice.ID and
        entity.Variant == FiendFolio.FF.BallOfMalice.Var and
        entity.SubType == FiendFolio.FF.BallOfMalice.Sub
    )
end)

local hats = {
    {
        Sprite = "astronaut",
        Offset = Vector(0, 1),
        Tears = 0.9
    },
    {
        Sprite = "cat",
        Offset = Vector(0, 3),
        Tears = 0.8,
        Luck = -1
    },
    {
        Sprite = "fedora",
        Offset = Vector(0, -1),
        Damage = 1.1,
        Luck = 1
    },
    {
        Sprite = "flower",
        Luck = 4
    },
    {
        Sprite = "football",
        Offset = Vector(0, -1),
        Damage = 1.1,
        TearSize = 1.25,
        Luck = -1
    },
    {
        Sprite = "ghastly",
        Offset = Vector(0, -1),
        Damage = 2,
        Tears = 1.9
    },
    {
        Sprite = "goggles",
        Offset = Vector(0, 3),
        Tears = 0.5,
        Damage = 0.75,
        TearSize = 0.75
    },
    {
        Sprite = "plumber",
        Tears = 0.95,
        Luck = 1
    },
    {
        Sprite = "viking",
        Offset = Vector(0, -1),
        Damage = 1.2,
        Tears = 1.1
    },
    {
        Sprite = "visor",
        TearSize = 1.75
    }
}

local maliceCropOffset = Vector(32, 0)

if StageAPI and StageAPI.Loaded then
    StageAPI.AddPlayerGraphicsInfo(FiendFolio.PLAYER.BIEND, {
        Name = "gfx/ui/boss/playername_fiend.png",
        Portrait = "gfx/ui/stage/playerportrait_taintedfiend_rep.png",
        NoShake = true,
        Controls = "gfx/backdrop/controls_fiend.png"
    })
end

function mod:ShouldPlayerGetInitialised(player) -- Credit to Kittenchilly
    if (player.FrameCount == 0 or (game:GetRoom():GetFrameCount() > 1 and player.FrameCount == 1)) and not player.Parent then
        local level = game:GetLevel()

        if (level:GetAbsoluteStage() == LevelStage.STAGE1_1 and level:GetCurrentRoomIndex() == level:GetStartingRoomIndex()) or level:GetCurrentRoomIndex() == GridRooms.ROOM_GENESIS_IDX then
            return level:GetCurrentRoomDesc().VisitedCount == 1
        end
    end
end

local function swapPlayerAnm2(player, anm2)
    local sprite = player:GetSprite()
    local anim, frame, isPlaying = sprite:GetAnimation(), sprite:GetFrame(), not sprite:IsFinished()
    sprite:Load(anm2, true)
    if isPlaying then
        sprite:Play(anim, true)
        sprite:SetFrame(frame)
    else
        sprite:SetFrame(anim, frame)
    end
end

local biendBlacklistedItems = {
    CollectibleType.COLLECTIBLE_GUILLOTINE,
    CollectibleType.COLLECTIBLE_SCISSORS,
    CollectibleType.COLLECTIBLE_DECAP_ATTACK
}

function mod.FiendBSkinInit(player)
    swapPlayerAnm2(player, "gfx/characters/player_biend.anm2")
	--player:SetPocketActiveItem(mod.ITEM.COLLECTIBLE.MALICE)

    local pool = game:GetItemPool()
    for _, item in ipairs(biendBlacklistedItems) do
        pool:RemoveCollectible(item)
    end
end

local dirToVec = {
	[Direction.NO_DIRECTION] = Vector(0,0),
	[Direction.LEFT] = Vector(-1,0),
	[Direction.UP] = Vector(0,-1),
	[Direction.RIGHT] = Vector(1,0),
	[Direction.DOWN] = Vector(0,1)
}

local dirToStr = {
	[Direction.NO_DIRECTION] = "Down",
	[Direction.DOWN] = "Down",
	[Direction.UP] = "Up",
	[Direction.LEFT] = "Left",
	[Direction.RIGHT] = "Right",
}

local dirToReverse = {
	[Direction.LEFT] = Direction.RIGHT,
	[Direction.UP] = Direction.DOWN,
	[Direction.RIGHT] = Direction.LEFT,
	[Direction.DOWN] = Direction.UP
}

local function canMaliceHit(ent)
    return (
        ent:ToNPC() 
        and ent:IsActiveEnemy(false) 
        and not ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
        and not ent:HasEntityFlags(EntityFlag.FLAG_NO_TARGET)
        and ent.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_NONE 
        and ent.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_ENEMIES
    )
end

local function tearsUp(firedelay, val)
	local currentTears = 30 / (firedelay + 1)
	local newTears = currentTears + val
	return math.max((30 / newTears) - 1, -0.99)
end

function mod.GetMaliceMinionAnm2(parent, isHollow)
    local isLost = parent:GetEffects():HasNullEffect(NullItemID.ID_LOST_CURSE)
    local prefix = (isLost and "lost_") or (parent.CanFly and "flying_") or ""
    local suffix = (isHollow and "_hollow") or ""
    return "gfx/familiar/biend/" .. prefix .. "malice_minion" .. suffix .. ".anm2"
end

function mod.SpawnMaliceMinion(parent, pos, vel, tearDelayOffset, isHollow)
    parent = parent or Isaac.GetPlayer()

    Isaac.ExecuteCommand("addplayer " .. PlayerType.PLAYER_THELOST .. " " .. parent.ControllerIndex)
    local player = Isaac.GetPlayer(game:GetNumPlayers() - 1)

    local data = mod:GetEntityData(player)
    data.MaliceMinion = true
	data.HollowMaliceMinion = isHollow
    data.TearDelayOffset = tearDelayOffset

    player.Variant = 1
    player.SubType = 0
    player.Parent = parent

    local sprite = player:GetSprite()
    sprite:Load(mod.GetMaliceMinionAnm2(parent, isHollow), true)

    player:AddCacheFlags(CacheFlag.CACHE_ALL)
    player:EvaluateItems()

    player.Position = pos
    player.Velocity = vel
    player:SetMinDamageCooldown(30)

    game:GetHUD():AssignPlayerHUDs()

    return player
end

local function handleMinionDamage(player, parentPlayer, parentData, data)
    if not parentData.MaliceMinions then return end

    player.Damage = parentPlayer.Damage

    local parentFireDelay = parentPlayer.MaxFireDelay
    local currentTears = 30 / (parentFireDelay + 1)
    local minionCount = #parentData.MaliceMinions
    local currentTearsTotal = currentTears * minionCount
    if currentTearsTotal > 60 then
        local newDamage = (player.Damage / 60) * currentTearsTotal
        player.Damage = newDamage
    end

    if data.Hat then
        local hat = data.Hat
        if hat.Damage then
            player.Damage = player.Damage * hat.Damage
        end
    end
	
	if data.HollowMaliceMinion then
		player.Damage = player.Damage * 0.5
	end
end

local function handleMinionFireDelay(player, parentPlayer, parentData, data)
    if not parentData.MaliceMinions then return end

    local parentFireDelay = parentPlayer.MaxFireDelay
    local currentTears = 30 / (parentFireDelay + 1)
    local minionCount = #parentData.MaliceMinions
    local currentTearsTotal = currentTears * minionCount
    if currentTearsTotal > 60 then
        currentTearsTotal = 60
    end

    --player.MaxFireDelay = ((30 / (currentTearsTotal / minionCount)) - 1) * mod:GetEntityData(player).TearDelayOffset -- direct maxfiredelay multipliers break at negative firedelay values
	player.MaxFireDelay = (30 / (currentTearsTotal / minionCount)) - 1
	player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, mod:convertTearMultABPToRep(data.TearDelayOffset))

    if data.Hat then
        local hat = data.Hat
        if hat.Tears then
            --player.MaxFireDelay = player.MaxFireDelay * hat.Tears -- direct maxfiredelay multipliers break at negative firedelay values
			player.MaxFireDelay = mod:tearsMult(player.MaxFireDelay, mod:convertTearMultABPToRep(hat.Tears))
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, flag)
    local pData = mod:GetEntityData(player)
    if pData.MaliceSplit then
        if flag == CacheFlag.CACHE_DAMAGE then
            local maxDamage = mod:Lerp(player.Damage * 0.8, player.Damage * 2.25, pData.InitialMinionCount / 6)
            player.Damage = maxDamage / pData.InitialMinionCount
        end
    end

    if pData.MaliceMinion then
        local parentPlayer = player.Parent:ToPlayer()
        local parentPlayerData = mod:GetEntityData(parentPlayer)
        if flag == CacheFlag.CACHE_RANGE then
            player.TearHeight = -6
            player.TearRange = parentPlayer.TearRange
        elseif flag == CacheFlag.CACHE_FLYING then
            player.CanFly = parentPlayer.CanFly
        elseif flag == CacheFlag.CACHE_TEARFLAG then
            player.TearFlags = parentPlayer.TearFlags
        elseif flag == CacheFlag.CACHE_TEARCOLOR then
            local tearcolor = Color.Lerp(parentPlayer.TearColor, parentPlayer.TearColor, 1)
            local lasercolor = Color.Lerp(parentPlayer.LaserColor, parentPlayer.LaserColor, 1)
			if pData.HollowMaliceMinion then
				tearcolor.A = tearcolor.A * 0.5
				lasercolor.A = lasercolor.A * 0.5
			end
			player.TearColor = tearcolor
			player.LaserColor = lasercolor
        elseif flag == CacheFlag.CACHE_DAMAGE then
            handleMinionDamage(player, parentPlayer, parentPlayerData, pData)
        elseif flag == CacheFlag.CACHE_FIREDELAY then
            handleMinionFireDelay(player, parentPlayer, parentPlayerData, pData)
        elseif flag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck - 2

            if pData.Hat then
                local hat = pData.Hat
                if hat.Luck then
                    player.Luck = player.Luck + hat.Luck
                end
            end
        end
    else
        if player:GetPlayerType() ~= FiendFolio.PLAYER.BIEND then return end

        if flag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage * 0.8
        elseif flag == CacheFlag.CACHE_FIREDELAY then
            player.MaxFireDelay = tearsUp(player.MaxFireDelay, 0.32)
        elseif flag == CacheFlag.CACHE_TEARCOLOR then
            player.TearColor = player.TearColor * FiendFolio.ColorDankBlackReal
        elseif flag == CacheFlag.CACHE_RANGE then
            player.TearRange = player.TearRange * 0.9
        end
    end
end)

local function cancelAllMaliceEffects(player)
    local data = mod:GetEntityData(player)

    if data.MaliceMinions then
        for _, minion in ipairs(data.MaliceMinions) do
            if minion.Type == 1 then
                mod:GetEntityData(minion).NoDeathEffects = true
                minion.Visible = false
                minion:Die()
            else
                minion:Remove()
            end
        end

        data.MaliceMinions = nil
    end
	
	if data.HollowMaliceMinions then
        for _, minion in ipairs(data.HollowMaliceMinions) do
			local dedbaby = Isaac.Spawn(1000, 2, 1, minion.Position, Vector.Zero, nil)
			dedbaby.Color = Color(0,0,0,0.7,0,0,0)
			local poof = Isaac.Spawn(1000, 15, 0, minion.Position, Vector.Zero, nil)
			poof.SpriteScale = poof.SpriteScale * 0.5
			poof.Color = Color(0.3,0.3,0.3,1,10 / 255,0,10 / 255)
			
            mod:GetEntityData(minion).NoDeathEffects = true
            minion.Visible = false
			minion.Velocity = Vector.Zero
            minion:Die()
        end
        data.HollowMaliceMinions = nil
	end

    if data.MaliceReformTarget then
        data.MaliceReformTarget:Remove()
        data.MaliceReformTarget = nil
    end

    if data.MaliceProjectile then
        data.MaliceProjectile:Remove()
        data.MaliceProjectile = nil
    end

    data.MaliceSplit = nil
    data.MaliceDashing = nil
    data.LastValidMalicePos = nil
    data.MaliceInMirror = nil
    data.Reverse3FireballsDash = nil
    data.Reverse3FireballsDashCount = nil
    data.MaliceReforming = nil
    data.MaliceMegaMush = nil
    data.MaliceHits = nil
end

local function reform(player, data)
    for _, minionBall in ipairs(data.MaliceMinions) do
        minionBall:Remove()
    end
	
    for _, minion in ipairs(data.HollowMaliceMinions) do
		local dedbaby = Isaac.Spawn(1000, 2, 1, minion.Position, Vector.Zero, nil)
		dedbaby.Color = Color(0,0,0,0.7,0,0,0)
		local poof = Isaac.Spawn(1000, 15, 0, minion.Position, Vector.Zero, nil)
		poof.SpriteScale = poof.SpriteScale * 0.5
		poof.Color = Color(0.3,0.3,0.3,1,10 / 255,0,10 / 255)
		
        mod:GetEntityData(minion).NoDeathEffects = true
        minion.Visible = false
		minion.Velocity = Vector.Zero
        minion:Die()
    end

    data.ReformTarget:Remove()
    data.ReformTarget = nil

    player.Visible = true 
    local poof = Isaac.Spawn(FiendFolio.FF.BallOfMalice.ID, FiendFolio.FF.BallOfMalice.Var, FiendFolio.FF.BallOfMalice.Sub, player.Position, Vector.Zero, player)
    poof.Parent = player
    poof:GetSprite():Play("Poof", true)
    player:UpdateCanShoot()
    data.MaliceReforming = nil
    data.MaliceMinions = nil
	data.HollowMaliceMinions = nil

    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    player:EvaluateItems()
end

function mod:maliceUpdate(player, data)
    -- malice works on other players just in case
    --local data = mod:GetEntityData(player)

    -- this runs for actual malice minions, not for the player who used malice
    if data.MaliceMinion then
        if player.FrameCount % 3 == 1 then
            if data.Leader then
                local creep = Isaac.Spawn(1000, 45, 0, player.Position, Vector.Zero, player):ToEffect()
                creep.Scale = 0.5
                creep:SetTimeout(10)
                creep:Update()
            end
            local splat = Isaac.Spawn(1000, 7, 0, player.Position + RandomVector()*mod:RandomFloat()*10, Vector.Zero, player):ToEffect()
            splat.Color = FiendFolio.ColorDankBlackReal
            splat.SpriteScale = splat.SpriteScale * 0.5
        end
    end

    if data.MaliceDashing then
        local isMirror = game:GetRoom():IsMirrorWorld()
        if data.MaliceInMirror ~= isMirror then
            if data.MaliceInMirror ~= nil then
                if data.MaliceProjectile and data.MaliceProjectile:Exists() then
                    data.MaliceProjectile.Velocity = -data.MaliceProjectile.Velocity
                end
                
                data.MaliceDashing = dirToReverse[data.MaliceDashing]
            end

            data.MaliceInMirror = isMirror
        end

        if not data.MaliceProjectile or not data.MaliceProjectile:Exists() then
            local vec = dirToVec[data.MaliceDashing]
            data.MaliceProjectile = Isaac.Spawn(FiendFolio.FF.BallOfMalice.ID, FiendFolio.FF.BallOfMalice.Var, FiendFolio.FF.BallOfMalice.Sub, player.Position, vec * 20, player)
            data.MaliceProjectile.Parent = player
            local maliceSprite = data.MaliceProjectile:GetSprite()
            if data.MaliceDashing == Direction.UP then
                maliceSprite:Play("AppearUp", true)
            elseif data.MaliceDashing == Direction.DOWN then
                maliceSprite:Play("AppearDown", true)
            else
                maliceSprite:Play("AppearHori", true)
                data.MaliceProjectile.FlipX = data.MaliceDashing == Direction.LEFT
            end
        end

        local creepPos = player.Position + RandomVector() * 20
        local creep = Isaac.Spawn(1000, 45, 0,creepPos, Vector.Zero, player):ToEffect()
        creep.SpriteScale = Vector.One * 1.5
        creep:SetTimeout(50)
        creep:Update()

        if player.FrameCount % 3 == 0 then
            local splatter = Isaac.Spawn(1000, 2, 2, creepPos, Vector.Zero, player)
            splatter.Color = FiendFolio.ColorDankBlackReal
            local splat = Isaac.Spawn(1000, 7, 0, player.Position + RandomVector()*mod:RandomFloat()*10, Vector.Zero, player):ToEffect()
            splat.Color = FiendFolio.ColorDankBlackReal
            splat.SpriteScale = splat.SpriteScale * 2
        end

        local attemptedMovement = player:GetMovementVector()

        data.MaliceMobility = data.MaliceMobility or 0.1
        data.MaliceMobility = mod:Lerp(data.MaliceMobility, 0.05, 0.1)
        data.MaliceProjectile.Velocity = mod:Lerp(data.MaliceProjectile.Velocity:Normalized(), attemptedMovement:Normalized(), data.MaliceMobility) * 20

        data.MaliceHits = data.MaliceHits or {}
		
		local level = game:GetLevel()
        local stage = level:GetStage()
        local stageType = game:GetLevel():GetStageType()
        if level:IsAscent() then
            stage = 10
        elseif stageType == StageType.STAGETYPE_REPENTANCE or stageType == StageType.STAGETYPE_REPENTANCE_B then
            stage = stage + 1
        end
		local damageMod = stage * 5
        if data.Reverse3FireballsDash then
            damageMod = damageMod + 10 + stage * 2
        end

        TearFlagsLib.WipeTearFlags(data.MaliceProjectile)

        local vanillaFlags, tearFlagDamage = TearFlagsLib.PollVanillaTearFlags(player)
        data.MaliceProjectile.CollisionDamage = (10 + damageMod) * tearFlagDamage / player.Damage 
        TearFlagsLib.AddCustomVanillaTearFlags(data.MaliceProjectile, vanillaFlags)
        TearFlagsLib.SetCustomVanillaTearFlagParams(data.MaliceProjectile, {
            ScaleOverride = 1.5,
			ColorOverride = mod.ColorDankBlackReal,
        })
		
        local colorBefore = data.MaliceProjectile.Color
        TearFlagsLib.CallPollTearFlagCallback(data.MaliceProjectile, player, TearFlagsLib.WeaponFlag.FF_MALICE)
		data.MaliceProjectile.Color = colorBefore

        local enemies = Isaac.FindInRadius(data.MaliceProjectile.Position, 40, EntityPartition.ENEMY)
        for _, enemy in ipairs(enemies) do
            if canMaliceHit(enemy) and not data.MaliceHits[GetPtrHash(enemy)] then
                data.MaliceHits[GetPtrHash(enemy)] = true

				TearFlagsLib.SetCustomVanillaTearFlagParams(data.MaliceProjectile, {
					DamageOverride = data.MaliceProjectile.CollisionDamage
				})

                -- enemy:TakeDamage(data.MaliceProjectile.CollisionDamage, 0, EntityRef(player), 0)
                TearFlagsLib.DamageEntity(enemy, data.MaliceProjectile.CollisionDamage, 0, data.MaliceProjectile, {DamageSource = player})
                TearFlagsLib.CallTearFlagCallback(enemy, player, data.MaliceProjectile, TearFlagsLib.WeaponFlag.FF_MALICE, true)

                if enemy:HasMortalDamage() then
                    if data.Reverse3FireballsDash then
                        data.Reverse3FireballsDashCount = math.min(4, data.Reverse3FireballsDashCount + 1)
                    end

                    if not FiendFolio.ACHIEVEMENT.IMPLOSION:IsUnlocked(true) and mod.CanRunUnlockAchievements() then
                        mod.savedata.maliceKills = mod.savedata.maliceKills + 1
                        if mod.savedata.maliceKills >= 50 then
                            FiendFolio.ACHIEVEMENT.IMPLOSION:Unlock()
                        end
                    end

                    local isBiend = player:GetPlayerType() == FiendFolio.PLAYER.BIEND
                    if isBiend or data.Reverse3FireballsDash then
                        local odds = 0.2
                        if isBiend and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
                            odds = 0.35
                        end

                        if math.random() <= odds then
                            Isaac.Spawn(EntityType.ENTITY_PICKUP, mod.PICKUP.VARIANT.HALF_BLACK_HEART, 0, enemy.Position, Vector.Zero, player)
                        end
                    end
                end
            end
        end
		data.MaliceProjectile.CollisionDamage = 0

        local dashEnd
        if player:CollidesWithGrid() or not game:GetRoom():IsPositionInRoom(player.Position, -50) then
            sfx:Play(mod.Sounds.SplashSmall, 0.4, 0, false, math.random(90, 110)/100)
            if data.Reverse3FireballsDash then
                data.Reverse3FireballsDashCount = data.Reverse3FireballsDashCount - 1
                if data.Reverse3FireballsDashCount < 0 then
                    dashEnd = true
                else
                    local splatter = Isaac.Spawn(1000, 2, 0, player.Position, Vector.Zero, player)
                    splatter.Color = FiendFolio.ColorDankBlackReal
                    data.MaliceHits = nil
                    data.MaliceProjectile.Velocity = -data.MaliceProjectile.Velocity
                    data.MaliceMobility = 0.2
                end
            else
                dashEnd = true
            end
        end

        if dashEnd then
            -- Don't clip into pits please
            player.Position = data.LastValidMalicePos or player.Position
            data.LastValidMalicePos = nil

            local splatter = Isaac.Spawn(1000, 2, 0, player.Position, Vector.Zero, player)
            splatter.Color = FiendFolio.ColorDankBlackReal
            data.MaliceProjectile = nil
            data.MaliceDashing = nil
            data.MaliceInMirror = nil
            data.MaliceHits = nil
            data.Reverse3FireballsDash = nil
            data.Reverse3FireballsDashCount = nil

            local playerVelLength = player.Velocity:Length()
            if playerVelLength > player.MoveSpeed * 4 then
                player.Velocity = (player.Velocity / playerVelLength) * player.MoveSpeed * 4
            end

            if player:GetPlayerType() == FiendFolio.PLAYER.BIEND then
                data.MaliceSplit = true
                
                data.MaliceMinions = {}
				data.HollowMaliceMinions = {}

                local minionCount = math.max(2, math.min(math.ceil(player:GetSoulHearts() / 2), 6))
				local _, birthcakeMult = mod:playerHasBirthcake(player)

                data.InitialMinionCount = minionCount

                player:SetMinDamageCooldown(45)
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                player:EvaluateItems()

                local coins = player:GetNumCoins()

                for i = 1, minionCount + birthcakeMult do
                    local vel = RandomVector() * 4
                    if i == 1 then
                        vel = player.Velocity
                    end
                    
                    local tearDelayOffset = 1
                    if minionCount + birthcakeMult > 1 then
                        tearDelayOffset = mod:Lerp(0.9, 1.1, (i - 1) / ((minionCount + birthcakeMult) - 1))
                    end

					if i <= minionCount then
						data.MaliceMinions[#data.MaliceMinions + 1] = mod.SpawnMaliceMinion(player, player.Position, vel, tearDelayOffset)
					else
						data.HollowMaliceMinions[#data.HollowMaliceMinions + 1] = mod.SpawnMaliceMinion(player, player.Position, vel, tearDelayOffset, true)
					end
                end

				mod:CheckMaliceMinionBirthrightHats(player, data)

                player:AddCoins(coins - player:GetNumCoins())
            end

            if player:HasTrinket(mod.ITEM.ROCK.ELECTRUM) then
                local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.ELECTRUM)
                local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.ELECTRUM)
                mod:alternateElectrumShock(player, rng, player.Damage*mult+1, player.Position, 1)
            end
        end
    elseif data.MaliceSplit then
        local oldLeader
        for i = #data.MaliceMinions, 1, -1 do
            local minion = data.MaliceMinions[i]
            if not minion:Exists() then
                table.remove(data.MaliceMinions, i)
            else
                local minionData = mod:GetEntityData(minion)
                if minionData.Leader then
                    oldLeader = GetPtrHash(minion)
                    minionData.Leader = false
                end
            end
        end
        for i = #data.HollowMaliceMinions, 1, -1 do
            local minion = data.HollowMaliceMinions[i]
            if not minion:Exists() then
                table.remove(data.HollowMaliceMinions, i)
            end
        end

        if #data.MaliceMinions == 0 then
            data.MaliceSplit = nil
            swapPlayerAnm2(player, "gfx/characters/player_biend_miniondeath.anm2")
            player:Die()
			
			for _, minion in ipairs(data.HollowMaliceMinions) do
				local dedbaby = Isaac.Spawn(1000, 2, 1, minion.Position, Vector.Zero, nil)
				dedbaby.Color = Color(0,0,0,0.7,0,0,0)
				local poof = Isaac.Spawn(1000, 15, 0, minion.Position, Vector.Zero, nil)
				poof.SpriteScale = poof.SpriteScale * 0.5
				poof.Color = Color(0.3,0.3,0.3,1,10 / 255,0,10 / 255)
				
				mod:GetEntityData(minion).NoDeathEffects = true
				minion.Visible = false
				minion.Velocity = Vector.Zero
				minion:Die()
			end
			
            data.MaliceMinions = nil
            data.HollowMaliceMinions = nil
        else
            if oldLeader ~= GetPtrHash(data.MaliceMinions[1]) then
                player.Position = data.MaliceMinions[1].Position
                player.Velocity = data.MaliceMinions[1].Velocity
            end

            mod:GetEntityData(data.MaliceMinions[1]).Leader = true
        end
    elseif data.MaliceReforming then
        if not data.ReformTarget then
            data.ReformTarget = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TARGET, 0, player.Position, player.Velocity, player):ToEffect()
            data.ReformTarget:GetSprite():ReplaceSpritesheet(0, "gfx/effects/biend_reform_target.png")
            data.ReformTarget:GetSprite():LoadGraphics()
            data.ReformTarget:GetSprite():Play("Blink", true)
        end

        data.ReformTarget.Position = player.Position
        data.ReformTarget.Velocity = player.Velocity

        local anyBallTooFar
        for _, minionBall in ipairs(data.MaliceMinions) do
            if minionBall.Position:DistanceSquared(player.Position) > 20 ^ 2 or (minionBall:GetSprite():IsPlaying("Transform") and not minionBall:GetSprite():WasEventTriggered("Transformed")) then
                anyBallTooFar = true
                break
            end
        end

        if not anyBallTooFar then
            reform(player, data)
        end
    end

    if player:GetPlayerType() ~= FiendFolio.PLAYER.BIEND then
        return
    end

    if mod:ShouldPlayerGetInitialised(player) then
        mod.FiendBSkinInit(player)
    end

    if player.FrameCount % 3 == 1 and not data.MaliceHidden and not data.BiendClosetMode then
        local creep = Isaac.Spawn(1000, 45, 0, player.Position, Vector.Zero, player):ToEffect()
        creep.Scale = 0.75
        creep:SetTimeout(10)
        creep:Update()
        local splat = Isaac.Spawn(1000, 7, 0, player.Position + RandomVector()*mod:RandomFloat()*10, Vector.Zero, player):ToEffect()
        splat.Color = FiendFolio.ColorDankBlackReal
        splat.SpriteScale = splat.SpriteScale * 0.75
    end
end

local playerPickupAnims = {
    LiftItem = true,
    HideItem = true,
    UseItem = true,
    PickupWalkDown = true,
    PickupWalkLeft = true,
    PickupWalkRight = true,
    PickupWalkUp = true
}

local copiedPlayerAnims = {
    Happy = true,
    Sad = true,
    TeleportUp = true,
    TeleportDown = true,
    Glitch = true,
    Jump = true,
    Trapdoor = 1,
    LightTravel = 1,
    DeathTeleport = 1,
}

local recentDeadMinions = {}

function mod:CheckMaliceMinionBirthrightHats(player, data)
	if data.MaliceMinions and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
		mod:Shuffle(hats)

		for i, minion in ipairs(data.MaliceMinions) do
			local hat = hats[i]
			local minionData = mod:GetEntityData(minion)
			minionData.Hat = minionData.Hat or hat or hats[mod:RandomInt(1, #hats)]
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_ADDED, function(_, player)
	if player:GetPlayerType() == FiendFolio.PLAYER.BIEND then
		mod:CheckMaliceMinionBirthrightHats(player, mod:GetEntityData(player))
	end
end, CollectibleType.COLLECTIBLE_BIRTHRIGHT)

function mod:MaliceMinionPlayerUpdate(player, data)
    if data.MaliceMinion then
        player.PositionOffset = Vector(0, 0)

        local playerParent = player.Parent:ToPlayer()
        local playerParentData = mod:GetEntityData(playerParent)
        local pSprite = playerParent:GetSprite()
        local sprite = player:GetSprite()

        handleMinionDamage(player, playerParent, playerParentData, data)
        handleMinionFireDelay(player, playerParent, playerParentData, data)

        sprite.Scale = Vector(0.5, 0.5)

        local targetAnm2 = mod.GetMaliceMinionAnm2(playerParent, data.HollowMaliceMinion)
        if sprite:GetFilename() ~= targetAnm2 then
            swapPlayerAnm2(player, targetAnm2)
        end

        if data.Leader then
            player.Position = player.Parent.Position
            player.Velocity = player.Parent.Velocity
        else
            local targetAhead = player.Parent.Position + player.Parent.Velocity * 20
            if not data.TargetPosition or targetAhead:DistanceSquared(data.TargetPosition) > 30 ^ 2 then
                data.TargetPosition = targetAhead + RandomVector() * 25
            end

            if data.ForcedAnim == "Trapdoor" then
                local dirFromPlayer = data.TargetPosition - player.Parent.Position
                if dirFromPlayer:LengthSquared() > 15 ^ 2 then
                    data.TargetPosition = player.Parent.Position + dirFromPlayer:Resized(15)
                end
                
                player.Velocity = mod:Lerp(player.Position, data.TargetPosition, 0.1) - player.Position
            elseif not data.ForcedAnim and player.Position:DistanceSquared(data.TargetPosition) > 3 ^ 2 then
                player.Velocity = player.Velocity + (data.TargetPosition - player.Position):Resized(math.max(player.Parent:ToPlayer().MoveSpeed, 0.65) * 1.1 * 0.5)
            else
                player.Velocity = Vector.Zero
            end
        end

        local isDying = sprite:GetAnimation() == "Death" or sprite:GetAnimation() == "LostDeath"
        if isDying and not data.CheckedDeathEffects then
            if not data.NoDeathEffects then
                local splatter = Isaac.Spawn(1000, 2, 0, player.Position, Vector.Zero, player)
                splatter.Color = FiendFolio.ColorDankBlackReal

                Isaac.Spawn(mod.FF.MaliceMinionGhost.ID, mod.FF.MaliceMinionGhost.Var, mod.FF.MaliceMinionGhost.Sub, player.Position, Vector.Zero, player)
            end

            recentDeadMinions[GetPtrHash(player)] = {player.Position, 2}
            data.CheckedDeathEffects = true
            sprite:SetLastFrame()
        end
        
        local playerAnim = pSprite:GetAnimation()
        if data.JustPlayed then
            if (data.JustPlayed ~= playerAnim or pSprite:GetFrame() < data.JustPlayedFrame) then
                data.JustPlayed = nil
            else
                data.JustPlayedFrame = pSprite:GetFrame()
            end
        end

        if not data.Appeared then
            if not data.DelayedAnim and not data.ForcedAnim then
                data.DelayedAnim = "Spawn"
                data.AnimDelay = 0
            end
        elseif copiedPlayerAnims[playerAnim] and not data.JustPlayed then
            data.DelayedAnim = playerAnim
            data.JustPlayed = playerAnim
            data.JustPlayedFrame = pSprite:GetFrame()
            if copiedPlayerAnims[playerAnim] == 1 then
                data.SmallDelay = true
            end
        elseif playerPickupAnims[playerAnim] and not sprite:IsPlaying("UseItem") then
            if not data.CurrentlyPickingUp and not data.DelayedAnim and playerAnim ~= "HideItem" then
                data.PickupAnim = true
                data.DelayedAnim = "LiftItem"
                if playerAnim == "UseItem" then
                    data.DelayedAnim = "UseItem"
                end
            end
        elseif data.CurrentlyPickingUp and not data.DelayedAnim then
            data.DelayedAnim = "HideItem"
        end

        if data.DelayedAnim and not data.AnimDelay then
            if data.Leader or data.SmallDelay then
                data.AnimDelay = math.random(1, 5)
            else
                data.AnimDelay = math.random(1, 15)
            end

            data.SmallDelay = nil
        end

        if data.AnimDelay then
            data.AnimDelay = data.AnimDelay - 1
            if data.AnimDelay <= 0 then
                if data.PickupAnim then
                    data.CurrentlyPickingUp = true
                else
                    data.CurrentlyPickingUp = nil
                end

                data.ForcedAnim = data.DelayedAnim
                data.ForcedAnimFrame = 0
                sprite:Play(data.DelayedAnim, true)
                sprite:SetLastFrame()
                data.ForcedAnimLastFrame = sprite:GetFrame()
                sprite:RemoveOverlay()
                data.AnimDelay = nil
                data.DelayedAnim = nil
                data.PickupAnim = nil
            end
        end

        data.CanRenderHat = false
        if data.ForcedAnim then
            local frame = math.floor(data.ForcedAnimFrame)
            sprite:SetFrame(data.ForcedAnim, frame)

            data.ForcedAnimFrame = data.ForcedAnimFrame + 1
            if data.ForcedAnimFrame >= data.ForcedAnimLastFrame + 1 then
                if data.ForcedAnim == "Trapdoor" then
                    player.Visible = false
                elseif data.ForcedAnim == "Appear" then -- if i don't forcibly stop the appear anim, they transform into random co-op babies?!?
                    sprite:SetFrame("WalkDown", 0)
                    sprite:SetOverlayFrame("HeadDown", 0)
                elseif data.ForcedAnim == "Spawn" then
                    data.Appeared = true
                end

                data.ForcedAnim = nil
                data.ForcedAnimFrame = nil
                data.ForcedAnimLastFrame = nil
            end
        elseif sprite:IsFinished() and not isDying then
            data.CanRenderHat = true

            local fireDir = player:GetFireDirection()

            local walkPrefix = "Walk"
            if data.CurrentlyPickingUp then
                walkPrefix = "PickupWalk"
            end

            if (playerParent and playerParent.CanFly) or data.Flying then
                --walkPrefix = "Fly"
                data.Flying = true
            end

            local moveDirStr
            local noMovement = player.Velocity:LengthSquared() <= 1
            if noMovement then
                moveDirStr = "Down"
            elseif math.abs(player.Velocity.X) > math.abs(player.Velocity.Y) then
                if player.Velocity.X < 0 then
                    moveDirStr = "Left"
                else
                    moveDirStr = "Right"
                end
            else
                if player.Velocity.Y < 0 then
                    moveDirStr = "Up"
                else
                    moveDirStr = "Down"
                end
            end

            local walkAnim = walkPrefix .. moveDirStr
            local headAnim = "Head" .. dirToStr[fireDir]

            if not data.MaxWalkFrame then
                sprite:SetAnimation(walkAnim, false)
                sprite:SetLastFrame()
                data.MaxWalkFrame = sprite:GetFrame()
            end

            data.WalkFrame = ((data.WalkFrame or 0) + 0.5) % data.MaxWalkFrame

            if noMovement and walkPrefix ~= "Fly" then
                sprite:SetFrame(walkAnim, 0)
            else
                sprite:SetFrame(walkAnim, math.floor(data.WalkFrame))
            end

            if walkPrefix ~= "PickupWalk" then
                if fireDir == Direction.NO_DIRECTION then
                    headAnim = "Head" .. moveDirStr
                end

                sprite:SetOverlayFrame(headAnim, (player.FireDelay > (player.MaxFireDelay / 2)) and 2 or 0)
            end
        end

        -- Copy colors (for invincibility)
        if pSprite.Color.A > 1e-3 then
            sprite.Color = pSprite.Color
        else
            sprite.Color = Color.Default
        end
    else
        if data.MaliceDashing or data.MaliceSplit or data.MaliceReforming then
            player:SetColor(Color(1, 1, 1, 0, 1, 1, 1), 2, 999, false, false)
            player.Visible = false
            local challenge = game.Challenge
            game.Challenge = 6
            player:UpdateCanShoot()
            game.Challenge = challenge
            data.PlayerShootingLocked = true
            data.MaliceHidden = true

            local activeWeapon = player:GetActiveWeaponEntity()
            if activeWeapon then
                activeWeapon:Remove()
            end
        elseif data.PlayerShootingLocked or data.MaliceHidden then
            player.Visible = true
            player:UpdateCanShoot()
            data.MaliceHidden = nil
            data.PlayerShootingLocked = nil
        end

        if data.MaliceSplit then
            local playerTempEffects = player:GetEffects()
            if playerTempEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE) then
                playerTempEffects:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
                for _, minion in ipairs(data.MaliceMinions) do
                    local minionTempEffects = minion:GetEffects()
                    if not minionTempEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE) then
                        minionTempEffects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, true, 1)
                    end
                end
				for _, minion in ipairs(data.HollowMaliceMinions) do
                    local minionTempEffects = minion:GetEffects()
                    if not minionTempEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE) then
                        minionTempEffects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, true, 1)
                    end
                end
            end
        end
    end
end

function mod:CheckMaliceReplacement(player, slot, offset, alpha, scale, offset)
	local data = mod:GetEntityData(player)
	if not data.MaliceMinion and (data.MaliceSplit or data.MaliceReforming) then
		return { CropOffset = maliceCropOffset }
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_ACTIVE_ITEM, mod.CheckMaliceReplacement, mod.ITEM.COLLECTIBLE.MALICE)

local isHeartVariant = {
    [PickupVariant.PICKUP_HEART] = true,
    [mod.PICKUP.VARIANT.BLENDED_IMMORAL_HEART] = true,
    [mod.PICKUP.VARIANT.IMMORAL_HEART] = true,
    [mod.PICKUP.VARIANT.HALF_IMMORAL_HEART] = true,
    [mod.PICKUP.VARIANT.HALF_BLACK_HEART] = true,
    [mod.PICKUP.VARIANT.BLENDED_BLACK_HEART] = true
}

local blackHeartSubtypes = {
    [HeartSubType.HEART_BLACK] = true,
    [91] = true, -- benighted hearts, rep+
    [100] = true, -- deserted hearts (blended black hearts), rep+
}

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, colliding, low)
    local player = colliding:ToPlayer()
    if not player then return end

    if mod:GetEntityData(player).MaliceMinion then
        return true
    end

    local pickupVariant = pickup.Variant
    local ptype = player:GetPlayerType()
    if (ptype ~= FiendFolio.PLAYER.BIEND and ptype ~= FiendFolio.PLAYER.CLASSIC_FIEND) or not isHeartVariant[pickupVariant] then return end

    if (pickupVariant == PickupVariant.PICKUP_HEART and not blackHeartSubtypes[pickup.SubType])
    or (pickupVariant ~= PickupVariant.PICKUP_HEART and pickupVariant ~= mod.PICKUP.VARIANT.HALF_BLACK_HEART and pickupVariant ~= mod.PICKUP.VARIANT.BLENDED_BLACK_HEART) then
        if pickup:IsShopItem() then
            Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, colliding, low)
            return true
        else
            Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, colliding, low)
            return false
        end
    end
end)

local heldPickups = {
    [PickupVariant.PICKUP_COLLECTIBLE] = true,
    [PickupVariant.PICKUP_TRINKET] = true,
    [PickupVariant.PICKUP_TAROTCARD] = true,
    [PickupVariant.PICKUP_PILL] = true,
}

mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, function(_, player, colliding)
    local data = mod:GetEntityData(player)
    if data.MaliceHidden then
        if colliding.Type ~= EntityType.ENTITY_PICKUP or ((data.MaliceDashing or data.MaliceReforming) and colliding.Variant == PickupVariant.PICKUP_SHOPITEM) then
            return true
        elseif (data.MaliceDashing or data.MaliceReforming) and heldPickups[colliding.Variant] then
            return false
        end
    end
end)

local function cancelCollision(_, collidesWith, colliding)
    if mod:GetEntityData(colliding).MaliceHidden then
        return true
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, cancelCollision)
mod:AddCallback(ModCallbacks.MC_PRE_BOMB_COLLISION, cancelCollision)

function mod:useMalice(item, rng, player)
    if player.Variant ~= 0 then return end

    local playerTempEffects = player:GetEffects()
    if playerTempEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_MEGA_MUSH) then
        return {
            Discharge = false,
            Remove = false,
            ShowAnim = false
        }
    end


    local data = mod:GetEntityData(player)
    if not data.MaliceReforming then
        if not data.MaliceDashing and not data.MaliceSplit then
            data.MaliceDashing = player:GetHeadDirection()
            sfx:Play(mod.Sounds.FireballLaunch, 0.4, 0, false, math.random(90, 110)/100)
        elseif data.MaliceSplit then
            data.MaliceSplit = false
            data.MaliceReforming = true
            local allHadHolyMantle = true
            for i, minion in ipairs(data.MaliceMinions) do
                minion.Velocity = Vector.Zero

                if not minion:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE) then
                    allHadHolyMantle = false
                end

                mod:GetEntityData(minion).NoDeathEffects = true
                minion:Die()

                local minionBall = Isaac.Spawn(FiendFolio.FF.BallOfMinion.ID, FiendFolio.FF.BallOfMinion.Var, FiendFolio.FF.BallOfMinion.Sub, minion.Position, Vector.Zero, player)
                minionBall.Parent = player
                data.MaliceMinions[i] = minionBall
            end
			
			for _, minion in ipairs(data.HollowMaliceMinions) do
				local dedbaby = Isaac.Spawn(1000, 2, 1, minion.Position, Vector.Zero, nil)
				dedbaby.Color = Color(0,0,0,0.7,0,0,0)
				local poof = Isaac.Spawn(1000, 15, 0, minion.Position, Vector.Zero, nil)
				poof.SpriteScale = poof.SpriteScale * 0.5
				poof.Color = Color(0.3,0.3,0.3,1,10 / 255,0,10 / 255)
				
				mod:GetEntityData(minion).NoDeathEffects = true
				minion.Visible = false
				minion.Velocity = Vector.Zero
				minion:Die()
			end

            if allHadHolyMantle then
                playerTempEffects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, true, 1)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.useMalice, mod.ITEM.COLLECTIBLE.MALICE)
--mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.useMalice, mod.ITEM.COLLECTIBLE.MALICE_REFORM)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, item, rng, player)
    cancelAllMaliceEffects(player)
end, CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, card, player, useFlags)
    local tempEffects = player:GetEffects()
    if tempEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_MEGA_MUSH) then
        tempEffects:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_MEGA_MUSH) -- idiot
    end

    local data = mod:GetEntityData(player)
    data.MaliceDashing = player:GetHeadDirection()
    data.Reverse3FireballsDash = true
    data.Reverse3FireballsDashCount = 4
    sfx:Play(mod.Sounds.FireballLaunch, 0.4, 0, false, math.random(90, 110)/100)

    if data.MaliceSplit or data.MaliceReforming then
        data.MaliceSplit = false
        data.MaliceReforming = false
        if data.MaliceMinions then
            for i, minion in ipairs(data.MaliceMinions) do
                minion.Velocity = Vector.Zero
                mod:GetEntityData(minion).NoDeathEffects = true
                minion:Die()
            end
			
			for _, minion in ipairs(data.HollowMaliceMinions) do
				local dedbaby = Isaac.Spawn(1000, 2, 1, minion.Position, Vector.Zero, nil)
				dedbaby.Color = Color(0,0,0,0.7,0,0,0)
				local poof = Isaac.Spawn(1000, 15, 0, minion.Position, Vector.Zero, nil)
				poof.SpriteScale = poof.SpriteScale * 0.5
				poof.Color = Color(0.3,0.3,0.3,1,10 / 255,0,10 / 255)
				
				mod:GetEntityData(minion).NoDeathEffects = true
				minion.Visible = false
				minion.Velocity = Vector.Zero
				minion:Die()
			end
        end
    end

    FiendFolio:trySayAnnouncerLine(mod.Sounds.VACardThreeFireballsBiend, useFlags, 20)
end, FiendFolio.ITEM.CARD.REVERSE_3_FIREBALLS)

function mod:useMegaMushMalice(item, rng, player)
    if player.Variant ~= 0 then return end
    local data = mod:GetEntityData(player)

    if data.MaliceHidden then
        cancelAllMaliceEffects(player)
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, mod.useMegaMushMalice, CollectibleType.COLLECTIBLE_MEGA_MUSH)

function mod:ballOfMaliceAI(effect)
    if effect.SubType ~= FiendFolio.FF.BallOfMalice.Sub and effect.SubType ~= FiendFolio.FF.BallOfMinion.Sub then return end

    if not effect.Parent or not effect.Parent:Exists() then
        if not mod:GetEntityData(effect).HatredHijacked or effect:GetSprite():IsFinished() then
            effect:Remove()
        end
        return
    end

    local parentData = mod:GetEntityData(effect.Parent)
    local sprite = effect:GetSprite()

    if effect.SubType == FiendFolio.FF.BallOfMinion.Sub then
        if not parentData.MaliceReforming then
            effect:Remove()
        end

        if effect.FrameCount % 3 == 1 then
            local creep = Isaac.Spawn(1000, 45, 0, effect.Position, Vector.Zero, effect):ToEffect()
            creep.Scale = 0.5
            creep:SetTimeout(10)
            creep:Update()
        end

        if sprite:IsPlaying("Idle") or sprite:WasEventTriggered("Transformed") then
            local dist = effect.Parent.Position:Distance(effect.Position)
            local speed = math.min(dist, mod:Lerp(2, 15, math.min(effect.FrameCount, 30) / 30))
            effect.Velocity = (effect.Parent.Position - effect.Position):Resized(speed)
        else
            effect.Velocity = Vector.Zero
        end

        if sprite:IsFinished() then
            sprite:Play("Idle", true)
        end

        return
    end

    if parentData.MaliceDashing and parentData.MaliceProjectile and (GetPtrHash(parentData.MaliceProjectile) == GetPtrHash(effect)) then
        local currentDirection = "Down"
        local currentFlip = false
        if math.abs(effect.Velocity.X) > math.abs(effect.Velocity.Y) then
            currentDirection = "Hori"
            if effect.Velocity.X < 0 then
                currentFlip = true
            end
        elseif effect.Velocity.Y < 0 then
            currentDirection = "Up"
        end

        local anim = sprite:GetAnimation()
        local isAppearing
        if string.sub(anim, 1, 6) == "Appear" then
            isAppearing = true
        end

        if isAppearing then
            if sprite:IsFinished() then
                sprite:Play(currentDirection, true)
            else
                sprite:SetAnimation("Appear" .. currentDirection, false)
            end
        else
            sprite:SetAnimation(currentDirection, false)
        end

        effect.FlipX = currentFlip
    else
        effect.Velocity = Vector.Zero
        if sprite:IsFinished("Poof") then
            parentData.MaliceProjectile = nil
            effect:Remove()
            return
        elseif not sprite:IsPlaying("Poof") then
            sprite:Play("Poof", true)
        end
    end
end

function mod:ballOfMaliceRender(effect)
    local effectParent = effect.Parent
    if effectParent then
        local effectParentData = mod:GetEntityData(effectParent)
        if effectParentData.MaliceDashing then
            effectParent.Position = effect.Position
            effectParent.Velocity = effect.Velocity

            if effectParent:ToPlayer().CanFly then
                return
            end

            local room = game:GetRoom()
            local freeTilePos = room:FindFreeTilePosition(effectParent.Position, effectParent.Size)
            if freeTilePos:DistanceSquared(effectParent.Position) < 100 then
                effectParentData.LastValidMalicePos = effectParent.Position
            end
        end
    end
end

function mod:maliceMinionGhostAI(effect)
    local sprite = effect:GetSprite()
    local data = mod:GetEntityData(effect)

    if not data.Init then
        effect:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        sprite:Play("Death", true)
        sprite:PlayOverlay("Head" .. tostring(math.random(1, 4) .. "Death"), true)
        data.Init = true
    elseif effect:GetSprite():IsFinished() then
        effect:Remove()
    end
end

-- shrink malice minion tears
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
	if tear.FrameCount < 1 and tear.Parent then
        local tearParentData = mod:GetEntityData(tear.Parent)
        if tearParentData.MaliceMinion then
            local parentPlayer = tear.Parent.Parent and tear.Parent.Parent:ToPlayer()
            if parentPlayer and mod:GetEntityData(parentPlayer).MaliceMinions then
                local minionCount = #mod:GetEntityData(parentPlayer).MaliceMinions
                tear:SetKnockbackMultiplier(1 / (minionCount * 1.5))
            else
                tear:SetKnockbackMultiplier(0.5)
            end
            tear.Scale = tear.Scale * 0.75

            local hat = tearParentData.Hat
            if hat and hat.TearSize then
                tear.Scale = tear.Scale * hat.TearSize
            end

            -- this doesn't get charged, so charge it manually
            if parentPlayer then
                local isaacsTear = parentPlayer:GetActiveItemSlot(CollectibleType.COLLECTIBLE_ISAACS_TEARS)
                if isaacsTear and isaacsTear >= 0 then
                    local rng = parentPlayer:GetCollectibleRNG(CollectibleType.COLLECTIBLE_ISAACS_TEARS)
                    if rng:RandomFloat() <= 0.33 then
                        parentPlayer:AddActiveCharge(1, isaacsTear, true, false, true)
                    end
                end
            end

        end
	end
end)

local function killMinion(player, damage, flags)
    local parentPlayer = player.Parent:ToPlayer()
    if player.Type == EntityType.ENTITY_PLAYER then
        local pdata = mod:GetEntityData(parentPlayer)
        for _, minion in ipairs(pdata.MaliceMinions) do
            minion:SetMinDamageCooldown(30)
        end
        for _, minion in ipairs(pdata.HollowMaliceMinions) do
            minion:SetMinDamageCooldown(30)
        end
        
        player:Die()
    end

	local d = mod:GetEntityData(player)
	local isHollowMinion = d.HollowMaliceMinion
    mod.scheduleForUpdate(function()
        if sfx:IsPlaying(SoundEffect.SOUND_ISAAC_HURT_GRUNT) then
            sfx:Stop(SoundEffect.SOUND_ISAAC_HURT_GRUNT)
            if not isHollowMinion then sfx:Play(mod.Sounds.BiendHurt, 0.8, 0, false, 1.5) end
        end
    end, 1)

	if not isHollowMinion then
		local soulHP = parentPlayer:GetSoulHearts()
		if damage >= soulHP then
			damage = soulHP - 1
		end

		parentPlayer:AddSoulHearts(-damage)
	else
		local dedbaby = Isaac.Spawn(1000, 2, 1, player.Position, Vector.Zero, nil)
		dedbaby.Color = Color(0,0,0,0.7,0,0,0)
		local poof = Isaac.Spawn(1000, 15, 0, player.Position, Vector.Zero, nil)
		poof.SpriteScale = poof.SpriteScale * 0.5
		poof.Color = Color(0.3,0.3,0.3,1,10 / 255,0,10 / 255)
		
		d.NoDeathEffects = true
		minion.Visible = false
		minion.Velocity = Vector.Zero
	end
end

local function handleVesselTrinket(parentPlayer)
    local pdata = mod:GetEntityData(parentPlayer)
    for _, minion in ipairs(pdata.MaliceMinions) do
        minion:SetMinDamageCooldown(30)
    end
    for _, minion in ipairs(pdata.HollowMaliceMinions) do
        minion:SetMinDamageCooldown(30)
    end
    mod.scheduleForUpdate(function()
        if sfx:IsPlaying(SoundEffect.SOUND_ISAAC_HURT_GRUNT) then
            sfx:Stop(SoundEffect.SOUND_ISAAC_HURT_GRUNT)
            sfx:Play(mod.Sounds.BiendHurt, 0.8, 0, false, 1.5)
        end
    end, 1)
    return {Damage = 1, DamageFlags = DamageFlag.DAMAGE_FAKE}
end

-- Handles running special hurt actions
function mod:biendHurt(ent, damage, flags)
    local data = mod:GetEntityData(ent)
    
    if data.MaliceMinion and damage > 0 and flags & DamageFlag.DAMAGE_FAKE == 0 then
        local parentPlayer = ent.Parent:ToPlayer()
        local spill = FiendFolio.HandleVesselTrinketChange(parentPlayer, -damage)
        if spill then
            return handleVesselTrinket(parentPlayer)
        end
        
        local spill2 = FiendFolio.HandleVesselTrinketChange2(parentPlayer, -damage)
        if spill2 then
            return handleVesselTrinket(parentPlayer)
        end
    end
end

-- Handles running queued hurt actions
-- Must be done here for stuff like i-frames to work
function mod:biendHurtPostDamage(ent)
    local data = mod:GetEntityData(ent)
    if data.BiendKillMinion ~= nil then
        local minionPtr, damage, flags = table.unpack(data.BiendKillMinion)
        local player = minionPtr.Ref

        killMinion(player, damage, flags)
        data.BiendKillMinion = nil
    end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, mod.biendHurtPostDamage, EntityType.ENTITY_PLAYER)

-- Handles queueing actions related to being hurt
function mod:biendHurtProtectMantle(player, damage, flags, source, cooldown)
    local data = mod:GetEntityData(player)

    if data.MaliceMinion then
		if damage > 0 and flags & DamageFlag.DAMAGE_FAKE == 0 then
            ---@type EntityPlayer
            local parentPlayer = player.Parent:ToPlayer()

            if (
                parentPlayer:HasInvincibility() 
                or parentPlayer:GetDamageCooldown() > 0
                or parentPlayer:IsInvincible()
                or mod.IsDebugThreeActive()
            ) then
                return false
            end

            local spill = FiendFolio.HandleVesselTrinketChange(parentPlayer, -damage, true)
            if spill then
                return
            end

            local spill2 = FiendFolio.HandleVesselTrinketChange2(parentPlayer, -damage, true)
            if spill2 then
                return
            end

            if mod:sandCastleHurt(parentPlayer, flags, source) == false then
				local pdata = mod:GetEntityData(parentPlayer).MaliceMinions
                for _, minion in ipairs(pdata.MaliceMinions) do
                    minion:SetMinDamageCooldown(30)
                end
                for _, minion in ipairs(pdata.HollowMaliceMinions) do
                    minion:SetMinDamageCooldown(30)
                end
                return false
			end

            data.BiendKillMinion = {EntityPtr(player), damage, flags}
        end

    elseif data.MaliceSplit or data.MaliceHidden then
        if ((flags & (DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_ISSAC_HEART | DamageFlag.DAMAGE_IV_BAG)) ~= 0)
        and flags & DamageFlag.DAMAGE_FAKE == 0 then
            if data.MaliceSplit and data.MaliceMinions and #data.MaliceMinions > 0 then
                local chosen = math.random(1, #data.MaliceMinions)
                data.MaliceMinions[chosen]:TakeDamage(damage, flags, source, cooldown)
                return false
            end

        else
            return false
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, mod.biendHurtProtectMantle)

mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, function(_, item, rng, player)
    if mod:GetEntityData(player).MaliceMinion then
        return true
    end
end)

local function nullifyAction(hook)
    if hook == InputHook.GET_ACTION_VALUE then
        return 0
    else
        return false
    end
end

local minionBlacklistedActions = {
    [ButtonAction.ACTION_LEFT] = true,
    [ButtonAction.ACTION_RIGHT] = true,
    [ButtonAction.ACTION_UP] = true,
    [ButtonAction.ACTION_DOWN] = true,
    [ButtonAction.ACTION_BOMB] = true,
}

local dashingPlayerWhitelistedActions = {
    [ButtonAction.ACTION_LEFT] = true,
    [ButtonAction.ACTION_RIGHT] = true,
    [ButtonAction.ACTION_UP] = true,
    [ButtonAction.ACTION_DOWN] = true,
}

mod:AddCallback("FF_PLAYER_INPUT_ACTION", function(_, player, data, hook, action)
    if not mod.IsForcingUnpause(hook, action) then
        if data.MaliceMinion then
            if minionBlacklistedActions[action] then
                return nullifyAction(hook)
            end
        elseif data.MaliceDashing or data.MaliceReforming then
            if not dashingPlayerWhitelistedActions[action] then
                return nullifyAction(hook)
            end
        end
    end
end)

function mod:ShrinkBomb(bomb)
	local originalScale = bomb:GetScale()
	local originalRadiusMult = bomb.RadiusMultiplier

	local newScale
	if originalScale >= 1.5 then
		newScale = originalScale - 0.5
	elseif originalScale > 1.1 then
		newScale = 1.0
	else
		newScale = math.max(originalScale - 0.25, 0.25)
	end
	bomb:SetScale(newScale)

	if newScale >= 1.0 and originalRadiusMult >= 1.0 then
		bomb.RadiusMultiplier = math.max(originalRadiusMult - 0.25, 1.0)
	elseif newScale <= 0.75 and originalRadiusMult <= 1.0 then
		bomb.RadiusMultiplier = 0.65
	else
		bomb.RadiusMultiplier = originalRadiusMult - 0.2
	end

	bomb:SetLoadCostumes(true)
end

-- Fetus Bombs
mod:AddCallback(ModCallbacks.MC_POST_FIRE_BOMB, function(_, bomb)
    local player = bomb.SpawnerEntity and bomb.SpawnerEntity:ToPlayer()
    if not player or not mod:GetEntityData(player).MaliceMinion then return end

    mod:ShrinkBomb(bomb)
    bomb:SetExplosionCountdown(bomb:GetExplosionCountdown() + mod:RandomInt(0, 4))
end)

function mod:malicePostScatterBomb(bomb, originalBomb)
    local player

    if originalBomb.SpawnerEntity then
        if originalBomb.SpawnerEntity:ToPlayer() then
            player = originalBomb.SpawnerEntity:ToPlayer()
        elseif originalBomb.SpawnerEntity:ToFamiliar() then
            local famVar = originalBomb.SpawnerEntity.Variant
            if famVar == FamiliarVariant.INCUBUS or
                famVar == FamiliarVariant.SPRINKLER or
                famVar == FamiliarVariant.TWISTED_BABY or
                famVar == FamiliarVariant.BLOOD_BABY or
                famVar == FamiliarVariant.UMBILICAL_BABY or
                famVar == FamiliarVariant.CAINS_OTHER_EYE
            then
                player = originalBomb.SpawnerEntity:ToFamiliar().Player
            end
        end
    end

    if not player or not mod:GetEntityData(player).MaliceMinion then return end

    bomb:SetScale(originalBomb:GetScale())
    bomb.RadiusMultiplier = originalBomb.RadiusMultiplier
    mod:ShrinkBomb(bomb)
end

local function spawnMinionBomb(minion, variant, flags, scale, radiusMult, velocity, damage)
    local player = minion.Parent and minion.Parent:ToPlayer()

    if not player then return end

    local newBomb
    if variant == BombVariant.BOMB_ROCKET or variant == BombVariant.BOMB_ROCKET_GIGA then
        newBomb = minion:FireBomb(minion.Position, player:GetShootingInput():Resized(velocity:Length()), player)
        newBomb.Color = Color.Default
    else
        newBomb = Isaac.Spawn(EntityType.ENTITY_BOMB, variant, 0, minion.Position, velocity, player):ToBomb()
        mod:postFireBomb(newBomb, player)
    end

    newBomb:SetScale(scale)
    newBomb.RadiusMultiplier = radiusMult
    mod:ShrinkBomb(newBomb)
    newBomb.SizeMulti = Vector(0.75, 0.75)

    newBomb.Flags = flags
    newBomb:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
    mod:GetEntityData(newBomb).MaliceSplit = true
    newBomb.ExplosionDamage = damage
end

-- Bombs placed with "E"
mod:AddPriorityCallback(ModCallbacks.MC_POST_PLAYER_USE_BOMB, CallbackPriority.LATE, function(_, player, bomb)
    local pdata = mod:GetEntityData(player)
	if not pdata.MaliceSplit then return end

    local minions = {}
	for _, minion in ipairs(pdata.MaliceMinions) do
		table.insert(minions, minion)
	end
	for _, minion in ipairs(pdata.HollowMaliceMinions) do
		table.insert(minions, minion)
	end

    local damage = bomb.ExplosionDamage
    local numMinions = #minions
    damage = damage / numMinions

    if numMinions ~= 1 then -- slightly buff damage for multiple minions
        damage = damage * (1 + ((numMinions ^ 0.33) / 12))
    end

    for _, minion in ipairs(minions) do
        if mod:GetEntityData(minion).Leader then
            spawnMinionBomb(minion, bomb.Variant, bomb.Flags, bomb:GetScale(), bomb.RadiusMultiplier, bomb.Velocity, damage)
        else
            local ptr = EntityPtr(minion)
            mod.scheduleForUpdate(function()
                if ptr and ptr.Ref and ptr.Ref:Exists() then
                    spawnMinionBomb(ptr.Ref:ToPlayer(), bomb.Variant, bomb.Flags, bomb:GetScale(), bomb.RadiusMultiplier, bomb.Velocity, damage)
                end
            end, mod:RandomInt(0, 4), ModCallbacks.MC_POST_UPDATE, false)
        end
    end

    bomb:Remove()
    return true
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local playerData = mod:GetEntityData(player)
        if playerData.MaliceMinion then
            player.Position = player.Parent.Position + RandomVector() * 20
            playerData.DelayedAnim = "Appear"
            playerData.AnimDelay = 0
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local playerData = mod:GetEntityData(player)
        if playerData.MaliceSplit or playerData.MaliceDashing then
            playerData.MaliceHits = nil
            player.Visible = false
        elseif playerData.MaliceMinion then
            player.Visible = true
        elseif playerData.MaliceReforming then
            reform(player, playerData)
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    for k, v in pairs(recentDeadMinions) do
        v[2] = v[2] - 1
        if v[2] <= 0 then
            recentDeadMinions[k] = nil
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function(_, player, offset)
    local data = mod:GetEntityData(player)
    if data.MaliceMinion then
        if data.Leader then
            local playerParent = player.Parent:ToPlayer()
            if playerParent then
                local pSprite = playerParent:GetSprite()
                local anim = pSprite:GetAnimation()
                if playerPickupAnims[anim] then
                    local oldFrame = pSprite:GetFrame()
                    pSprite:SetAnimation("HoleDeath", false)
                    pSprite:SetFrame(0)
                    playerParent.Visible = true
                    playerParent:Render(offset + Vector(0, 10))
                    playerParent.Visible = false
                    pSprite:SetAnimation(anim, false)
                    pSprite:SetFrame(oldFrame)
                end
            end
        end
        
        if data.Hat and data.CanRenderHat then
            if not data.HatSprite then
                local hatSheet = "gfx/familiar/biend/hats/" .. data.Hat.Sprite .. ".png"
                data.HatSprite = Sprite()
                data.HatSprite:Load("gfx/familiar/biend/hats/hat.anm2", false)
                data.HatSprite:ReplaceSpritesheet(0, hatSheet)
                data.HatSprite:LoadGraphics()
            end

            local playerSprite = player:GetSprite()
            data.HatSprite:SetFrame(playerSprite:GetOverlayAnimation(), playerSprite:GetOverlayFrame())
            data.HatSprite:Render(game:GetRoom():WorldToScreenPosition(player.Position) + (data.Hat.Offset or Vector.Zero) + Vector(0, 0.5), Vector.Zero, Vector.Zero)
        end
    end
end)

local minionCounterSprite = Sprite()
minionCounterSprite:Load("gfx/ui/biend_counter.anm2", true)

function mod.shouldRenderMaliceMinionIcon(player, playerSlot)
	return player:GetPlayerType() == mod.PLAYER.BIEND and playerSlot ~= CustomHealthAPI.Enums.PlayerSlot.STRAWMAN
end

function mod.onRenderMaliceMinionIcon(player, playerSlot, healthIndex, renderInfo)
	local data = mod:GetEntityData(player)
	if not data.MaliceSplit then
		return
	end
	local numMinions = #data.MaliceMinions
	if numMinions > 6 then
		minionCounterSprite:Play("x6+", true)
	else
		minionCounterSprite:Play("x" .. numMinions, true)
	end

	if numMinions == 1 then
		local regularColor = Color(1.0, 1.0, 1.0, 1.0, 0/255, 0/255, 0/255)
		local dangerPulseColorHigh = Color(1.0, 1.0, 1.0, 1.0, 255/255, 0/255, 0/255)
		local dangerPulseColor = Color.Lerp(regularColor, dangerPulseColorHigh, math.max(0, ((Game():GetFrameCount() % 45) - 9) / 9 * -1))

		minionCounterSprite.Color = dangerPulseColor
	else
		minionCounterSprite.Color = Color(1.0, 1.0, 1.0, 1.0, 0/255, 0/255, 0/255)
	end

	CustomHealthAPI.Helper.RenderHealth(minionCounterSprite, player, playerSlot, healthIndex, renderInfo.RenderOffset, renderInfo.TotalHealthRendered, renderInfo.ExtraOffset + Vector(-0.5, 0))
end

CustomHealthAPI.Library.RegisterBelowHealthIcon("MALICE_MINIONS", 
	{SortOrder = 0,
	 ShouldRenderFunc = mod.shouldRenderMaliceMinionIcon,
	 OnRenderFunc = mod.onRenderMaliceMinionIcon,
	 RowsUsed = 1,
	 OffsetAsHP = true,
	 IgnoreUnknownCurse = false,})

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_HEALTH_RENDER, function(_, player)
	if mod:GetEntityData(player).MaliceMinion then
		return {Prevent = true}
	end
end)

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_AFTER_HEALTH_ICON_RENDER, function(_, player, key, playerSlot, healthIndex, indexOffset, renderInfo)
	local data = mod:GetEntityData(player)
	if data.MaliceMinion and key ~= "HOLY_MANTLE" then
		return {Prevent = true}
	elseif data.MaliceHidden and key == "HOLY_MANTLE" then 
		return {Prevent = true}
	end
end)

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_RENDER_LIVES, function(_, player, lives)
	if mod:GetEntityData(player).MaliceMinion then 
		return {Prevent = true}
	end
end)

mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_RENDER_UNKNOWN_CURSE, function(_, player, index)
	if mod:GetEntityData(player).MaliceMinion then
		return true
	end
end)

function mod:handleDeadMinionPreSpawn(id, var, sub, pos, vel, spawner, seed)
    local delete
    for k, minion in pairs(recentDeadMinions) do
        local mPos = minion[1]
        if pos:DistanceSquared(Vector(mPos.X, mPos.Y - 10)) < 2 ^ 2 then
            recentDeadMinions[k] = nil
            delete = true
            break
        end
    end

    if delete then
        if sfx:IsPlaying(SoundEffect.SOUND_ISAACDIES) then
            sfx:Stop(SoundEffect.SOUND_ISAACDIES)
        end

        return {
            StageAPI.E.DeleteMeEffect.T,
            StageAPI.E.DeleteMeEffect.V,
            0
        }
    end
end

mod:AddCallback("FF_PLAYER_HURT_SOUND", function()
    sfx:Play(mod.Sounds.BiendHurt, 0.8, 0, false, 1)
    return true
end, mod.PLAYER.BIEND)

mod:AddCallback("FF_PLAYER_DEATH_SOUND", function()
    sfx:Play(mod.Sounds.BiendFreakingDies, 0.8, 0, false, 1)
    return true
end, mod.PLAYER.BIEND)

function mod:biendPreAddHealth(player, key, hp)
    if hp > 0 and not mod:GetEntityData(player).MaliceMinion then
        if CustomHealthAPI.Library.GetInfoOfKey(key, "Type") == CustomHealthAPI.Enums.HealthTypes.CONTAINER and
           CustomHealthAPI.Library.GetInfoOfKey(key, "KindContained") ~= CustomHealthAPI.Enums.HealthKinds.NONE
        then
            local maxHP = CustomHealthAPI.Library.GetInfoOfKey(key, "MaxHP")
            local canHaveHalfCapacity = CustomHealthAPI.Library.GetInfoOfKey(key, "CanHaveHalfCapacity")

            if maxHP < 1 then
                if canHaveHalfCapacity then
                    return "BLACK_HEART", hp
                else
                    return "BLACK_HEART", hp * 2
                end
            else
                local fullKeysToAdd = math.floor(hp / maxHP)
                local newHP = fullKeysToAdd * 2
                if hp % maxHP ~= 0 then
                    newHP = newHP + 1
                end

                return "BLACK_HEART", newHP
            end
        elseif CustomHealthAPI.Library.GetInfoOfKey(key, "Type") == CustomHealthAPI.Enums.HealthTypes.RED then
            return true
        elseif CustomHealthAPI.Library.GetInfoOfKey(key, "Type") == CustomHealthAPI.Enums.HealthTypes.SOUL and
               key ~= "BLACK_HEART"
        then
            local maxHP = CustomHealthAPI.Library.GetInfoOfKey(key, "MaxHP")

            local fullKeysToAdd = math.floor(hp / maxHP)
            local newHP = fullKeysToAdd * 2
            if hp % maxHP ~= 0 then
                newHP = newHP + 1
            end

            return "BLACK_HEART", newHP
        end
    end
end
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_ADD_HEALTH, mod.biendPreAddHealth, FiendFolio.PLAYER.BIEND)
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_ADD_HEALTH, mod.biendPreAddHealth, FiendFolio.PLAYER.CLASSIC_FIEND)

function mod:biendPostResyncPlayer(player)
    if not mod:GetEntityData(player).MaliceMinion then
        local hearts = CustomHealthAPI.Library.GetHealthInOrder(player)

        local numBlack = 0
        for i = #hearts, 1, -1 do
            local health = hearts[i]
            local key = health.Other.Key
            local typeOfKey = CustomHealthAPI.Library.GetInfoOfKey(key, "Type")

            if typeOfKey == CustomHealthAPI.Enums.HealthTypes.SOUL and key ~= "BLACK_HEART" then
                numBlack = numBlack + health.Other.HP
                CustomHealthAPI.Library.RemoveOtherKey(player, i, true)
            elseif CustomHealthAPI.Library.GetInfoOfKey(key, "Type") == CustomHealthAPI.Enums.HealthTypes.CONTAINER and
                   CustomHealthAPI.Library.GetInfoOfKey(key, "KindContained") ~= CustomHealthAPI.Enums.HealthKinds.NONE
            then
                numBlack = numBlack + 2
                CustomHealthAPI.Library.RemoveOtherKey(player, i, true)
            end
        end
        
        if numBlack ~= 0 then player:AddBlackHearts(numBlack) end
    end
end
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.POST_RESYNC_PLAYER, mod.biendPostResyncPlayer, FiendFolio.PLAYER.BIEND)
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.POST_RESYNC_PLAYER, mod.biendPostResyncPlayer, FiendFolio.PLAYER.CLASSIC_FIEND)

function mod:biendPreHeal(player)
	if not mod:GetEntityData(player).MaliceMinion then
        return "BLACK_HEART", 1
    end
end
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_ETERNAL_HEAL, mod.biendPreHeal, FiendFolio.PLAYER.BIEND)
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_ETERNAL_HEAL, mod.biendPreHeal, FiendFolio.PLAYER.CLASSIC_FIEND)
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_SPIRIT_SHACKLES_HEAL, mod.biendPreHeal, FiendFolio.PLAYER.BIEND)
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_SPIRIT_SHACKLES_HEAL, mod.biendPreHeal, FiendFolio.PLAYER.CLASSIC_FIEND)
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_HEARTBREAK_HEAL, mod.biendPreHeal, FiendFolio.PLAYER.BIEND)
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_HEARTBREAK_HEAL, mod.biendPreHeal, FiendFolio.PLAYER.CLASSIC_FIEND)
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_GLASS_CANNON_HEAL, mod.biendPreHeal, FiendFolio.PLAYER.BIEND)
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_GLASS_CANNON_HEAL, mod.biendPreHeal, FiendFolio.PLAYER.CLASSIC_FIEND)
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_NOKILL_HEAL, mod.biendPreHeal, FiendFolio.PLAYER.BIEND)
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.PRE_NOKILL_HEAL, mod.biendPreHeal, FiendFolio.PLAYER.CLASSIC_FIEND)

function mod:biendMaxHPConversion(player)
    if not mod:GetEntityData(player).MaliceMinion then
        return "BLACK_HEART"
    end
end
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.GET_MAX_HP_CONVERSION, mod.biendMaxHPConversion, FiendFolio.PLAYER.BIEND)
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.GET_MAX_HP_CONVERSION, mod.biendMaxHPConversion, FiendFolio.PLAYER.CLASSIC_FIEND)

function mod:biendGulletKey(player)
    if not mod:GetEntityData(player).MaliceMinion then
        return "BLACK_HEART"
    end
end
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.GET_GULLET_HEART_KEY, mod.biendGulletKey, FiendFolio.PLAYER.BIEND)
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.GET_GULLET_HEART_KEY, mod.biendGulletKey, FiendFolio.PLAYER.CLASSIC_FIEND)

mod:AddPriorityCallback(ModCallbacks.MC_PLAYER_GET_HEART_LIMIT, CallbackPriority.IMPORTANT, function (_, player, limit, ignoreModifiers)
    if not mod:GetEntityData(player).MaliceMinion then
		if ignoreModifiers then
			return 12
		else
			local brokenHearts = player:GetBrokenHearts()
			return (6 - brokenHearts) * 2
		end
    end
end, FiendFolio.PLAYER.BIEND)

mod:AddPriorityCallback(ModCallbacks.MC_POST_BOSS_INTRO_SHOW, CallbackPriority.EARLY, function()
	if Isaac.GetPlayer():GetPlayerType() ~= FiendFolio.PLAYER.BIEND then
		return
	end

	local totalMinions = 0

	for _, player in ipairs(PlayerManager.GetPlayers()) do
		if mod:GetEntityData(player).MaliceMinion then
			totalMinions = totalMinions + 1
		end
	end

	if totalMinions < 1 then
		return
	end

	local sprite = RoomTransition.GetVersusScreenSprite()
	if sprite:GetAnimation() == "Scene" then
		sprite:Play("SceneCoop")
	elseif sprite:GetAnimation() == "DoubleTrouble" then
		sprite:Play("DoubleTroubleCoop")
	end

	for slot=1, 4 do
		local hide = slot > totalMinions
		local mainlayer = sprite:GetLayer("PlayerPortrait_" .. slot)
		local altlayer = sprite:GetLayer("PlayerPortraitAlt_" .. slot)
		local spotlayer = sprite:GetLayer("PlayerSpot_" .. slot)
		if mainlayer then
			mainlayer:SetVisible(false)
		end
		if altlayer then
			if hide then
				altlayer:SetVisible(false)
			else
				sprite:ReplaceSpritesheet(altlayer:GetLayerID(), "gfx/ui/stage/playerportrait_taintedfiend_minion.png", true)
				altlayer:SetVisible(true)
			end
		end
		if spotlayer and hide then
			spotlayer:SetVisible(false)
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_ADDED, function(_, player, item, firstTime, wispOrInnate)
	if player:GetPlayerType() == FiendFolio.PLAYER.BIEND and player:GetSoulHearts() <= 0 then
		player:AddSoulHearts(1)
	end
end, CollectibleType.COLLECTIBLE_BRITTLE_BONES)