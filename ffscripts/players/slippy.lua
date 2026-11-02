local mod = FiendFolio
local game = Game()
local nilvector = Vector.Zero
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, function(_, item, rng, player, flags, slot)
    if flags == flags | UseFlag.USE_VOID then
        Game():Fart(player.Position, 80, player, 1, 0)
        for i = 45, 360, 45 do
            Game():Fart(player.Position + Vector(40, 0):Rotated(i), 80, player, 1, 0)
        end
        game:ButterBeanFart(player.Position, 280, player, false)
        sfx:Play(mod.Sounds.FartFrog4,1,0,false,math.random(90,110)/100)
        Game():ShakeScreen(50)
        sfx:Stop(SoundEffect.SOUND_FART)
    else
        local data = mod:GetEntityData(player)
        data.frogModeAction = slot < ActiveSlot.SLOT_POCKET and ButtonAction.ACTION_ITEM or ButtonAction.ACTION_PILLCARD
        data.canTrackFrogMode = true
    end
end, mod.ITEM.COLLECTIBLE.FROG_HEAD)

local function shouldCtrlCancelFrogHead(player)
    local data = mod:GetEntityData(player)
    return (
        (data.frogModeAction == ButtonAction.ACTION_ITEM and player:HasCollectible(CollectibleType.COLLECTIBLE_SCHOOLBAG)) or
        (data.frogModeAction == ButtonAction.ACTION_PILLCARD and (
            player:GetActiveItem(ActiveSlot.SLOT_POCKET2) > 0 or
            player:GetCard(0) > 0 or
            player:GetPill(0) > 0
        ))
    )
end

function mod:frogmodeLogic(p, ci)
    if p:HasCollectible(mod.ITEM.COLLECTIBLE.FROG_HEAD) then
        local data = mod:GetEntityData(p)
        if shouldCtrlCancelFrogHead(p) and Input.IsActionPressed(ButtonAction.ACTION_DROP, p.ControllerIndex) then
            data.canTrackFrogMode = false
        end

        if data.canTrackFrogMode and Input.IsActionPressed(data.frogModeAction, p.ControllerIndex) and not p:GetSprite():IsPlaying("Death") then
            data.frogStop = true
			data.frogBirthcakeMult = data.frogBirthcakeMult or (BirthcakeRebaked and p:GetPlayerType() == FiendFolio.PLAYER.SLIPPY and p:GetTrinketMultiplier(BirthcakeRebaked.Birthcake.ID)) or 0
        else
            data.canTrackFrogMode = false
            data.frogStop = false
        end
    end
end

local blockedAnimations = {
    ["Appear"] = true,
    ["Death"] = true,
}

local goldenFrogHeadCostume = Isaac.GetCostumeIdByPath("gfx/characters/frogModeGold.anm2")

--[[function mod:slippyPeffectUpdate(player, data)
    if player:GetPlayerType() == FiendFolio.PLAYER.SLIPPY then
        if mod:ShouldPlayerGetInitialised(player) then
            player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/frogMode.anm2"))
            player:AddCollectible(mod.ITEM.COLLECTIBLE.FROG_HEAD,0,false)
        end
    end
end]]

function mod:slippyPlayerUpdate(player)
--Frog Mode
    local data = mod:GetEntityData(player)
    local isSlippy
    local isBirthright
    if player:GetPlayerType() == FiendFolio.PLAYER.SLIPPY then
        isSlippy = true
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
            isBirthright = true
            if not data.SlippyHasBirthrightCostume then
                player:AddNullCostume(goldenFrogHeadCostume)
                player:SetColor(Color(1,1,1,1,1,1,1), 5, 10, true, false)
                data.SlippyHasBirthrightCostume = true
            end
        end
    end
    if isSlippy or player:HasCollectible(mod.ITEM.COLLECTIBLE.FROG_HEAD) then
        local sprite = player:GetSprite()
        data.frogTimer = data.frogTimer or 0
        --print(player:GetSprite():GetAnimation(), player:IsExtraAnimationFinished())
        if data.frogStop or (isSlippy and ((not player.ControlsEnabled) or blockedAnimations[sprite:GetAnimation()])) then
            if player.ControlsEnabled then
                data.frogTimer = data.frogTimer + 1
            end
            if not isSlippy then
                if not data.hasFrogCostume then
                    player:SetColor(Color(1,1,1,1,1,1,1), 5, 10, true, false)
                    player:AddNullCostume(goldenFrogHeadCostume)
                    --Isaac.Spawn(1000, 15, 0, player.Position, nilvector, player)
                    data.hasFrogCostume = true
                end
            end

			local birthcakeMult = ((data.frogBirthcakeMult or 0) > 0 and (1 - (math.min(data.frogBirthcakeMult, 3) + 1) / 6)) or 1
            if data.frogTimer > 150 * birthcakeMult  then
                if data.frogTimer % 5 == 1 then
                    player:SetColor(Color(1,1,1,1,100 / 255,0,0),5,1,true,false)
                end
            elseif data.frogTimer > 80 * birthcakeMult then
                if data.frogTimer % 10 == 1 then
                    player:SetColor(Color(1,1,1,1,100 / 255,0,0),5,1,true,false)
                end
            elseif data.frogTimer > 30 * birthcakeMult then
                if data.frogTimer % 10 == 1 then
                    player:SetColor(Color(1,1,1,1,20 / 255,20 / 255,20 / 255),5,1,true,false)
                end
            end
            player.Velocity = nilvector
            if sprite:GetAnimation() == "Death" and sprite:GetFrame() > 15 and data.frogTimer > 150 then
                mod:explodePlayer(player)
                Game():Fart(player.Position, 80, player, 1, 0)
                for i = 45, 360, 45 do
                    Game():Fart(player.Position + Vector(40, 0):Rotated(i), 80, player, 1, 0)
                end
                game:ButterBeanFart(player.Position, 280, player, false)
                sfx:Play(mod.Sounds.FartFrog4,1,0,false,math.random(90,110)/100)
                Game():ShakeScreen(50)
                sfx:Stop(SoundEffect.SOUND_FART)
                data.frogTimer = 0
            end
        else
            if data.frogTimer and data.frogTimer > 0 then
				local birthcakeMult = ((data.frogBirthcakeMult or 0) > 0 and (1 - (math.min(data.frogBirthcakeMult, 3) + 1) / 6)) or 1
                if data.frogTimer > 150 * birthcakeMult then
                    Game():Fart(player.Position, 80, player, 1, 0)
                    for i = 45, 360, 45 do
                        Game():Fart(player.Position + Vector(40, 0):Rotated(i), 80, player, 1, 0)
                        if isBirthright then
                            local gas = Isaac.Spawn(1000, 141, 0, player.Position + Vector(20, 0):Rotated(i), Vector(5, 0):Rotated(i), player):ToEffect()
                            gas.Timeout = 300
                        end
                    end
                    game:ButterBeanFart(player.Position, 280, player, false)
                    sfx:Play(mod.Sounds.FartFrog4,1,0,false,math.random(90,110)/100)
                    Game():ShakeScreen(50)
                    sfx:Stop(SoundEffect.SOUND_FART)
                    if isBirthright then
                        local gas = Isaac.Spawn(1000, 141, 0, player.Position, nilvector, player):ToEffect()
                        gas.Timeout = 300
                    end

                    if player:HasTrinket(mod.ITEM.ROCK.ELECTRUM) then
                        local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.ELECTRUM)
                        local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.ELECTRUM)
                        mod:alternateElectrumShock(player, rng, player.Damage*mult*2+30, player.Position, 4)
                    end
                elseif data.frogTimer > 80 * birthcakeMult then
                    Game():Fart(player.Position, 80, player, 1, 0)
                    game:ButterBeanFart(player.Position, 280, player, false)
                    sfx:Play(mod.Sounds.FartFrog3,1,0,false,math.random(90,110)/100)
                    Game():ShakeScreen(10)
                    sfx:Stop(SoundEffect.SOUND_FART)
                    if isBirthright then
                        local vec = RandomVector()
                        for i = 120, 360, 120 do
                            local gas = Isaac.Spawn(1000, 141, 0, player.Position + Vector(10, 0):Rotated(i), Vector(2.5, 0):Rotated(i), player):ToEffect()
                            gas.Timeout = 150
                        end
                    end

                    if player:HasTrinket(mod.ITEM.ROCK.ELECTRUM) then
                        local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.ELECTRUM)
                        local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.ELECTRUM)
                        mod:alternateElectrumShock(player, rng, player.Damage*mult+15, player.Position, 3)
                    end
                elseif data.frogTimer > 30 * birthcakeMult then
                    Game():ShakeScreen(5)
                    sfx:Play(mod.Sounds.FartFrog2,1,0,false,math.random(70,130)/100)
                    game:ButterBeanFart(player.Position, 280, player, true)
                    sfx:Stop(SoundEffect.SOUND_FART)
                    if isBirthright then
                        local gas = Isaac.Spawn(1000, 141, 0, player.Position, nilvector, player):ToEffect()
                        gas.Timeout = 60
                    end

                    if player:HasTrinket(mod.ITEM.ROCK.ELECTRUM) then
                        local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.ELECTRUM)
                        local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.ELECTRUM)
                        mod:alternateElectrumShock(player, rng, player.Damage*mult*5, player.Position, 2)
                    end
                elseif data.frogTimer > 10 * birthcakeMult then
                    sfx:Play(mod.Sounds.FartFrog1,0.2,0,false,math.random(80,120)/100)
                    local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 960, player.Position, player.Velocity:Resized(-1), player):ToEffect();
                    local smokeCol = Color(1,1,1,1,100 / 255,100 / 255,100 / 255)
                    smokeCol:SetColorize(0.5,3,0.5,1)
                    smoke.Color = smokeCol
                    smoke.SpriteOffset = Vector(0,-10)
                    smoke.SpriteRotation = math.random(360)
                    smoke:Update()

                    if player:HasTrinket(mod.ITEM.ROCK.ELECTRUM) then
                        local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.ELECTRUM)
                        local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.ELECTRUM)
                        mod:alternateElectrumShock(player, rng, player.Damage*mult, player.Position, 1)
                    end
                end
                data.frogTimer = 0
				data.frogBirthcakeMult = nil
                if isSlippy then
                    player.Velocity = player:GetMovementVector():Normalized():Rotated(-90 + math.random(180))
                else
                    if data.hasFrogCostume then
                        player:TryRemoveNullCostume(goldenFrogHeadCostume)
                        player:SetColor(Color(1,1,1,1,1,1,1), 5, 10, true, false)
                        data.hasFrogCostume = false
                    end
                end
            end
        end
        if isSlippy or data.frogTimer > 0 then
            local venus = Isaac.FindByType(mod.FF.CacophobiaVenus.ID, mod.FF.CacophobiaVenus.Var)[1]
            if venus then
                if data.frogTimer > 0 then
                    player.Velocity = RandomVector()
                end
            else
                local effects = player:GetEffects()
                if (not data.ClownMeatActive) 
                and (not effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_MARS))
                and (not effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_PONY))
                and (not effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_WHITE_PONY))
                then    
                    if flattening and flattening.modVersionNumber then
                        player.Velocity = player.Velocity:Resized(player.MoveSpeed * 4)
                        player.Velocity = mod:Lerp(player.Velocity, Vector(player.Velocity.X * theWidth, player.Velocity.Y * theHeight), 0.2)
                    else
                        player.Velocity = player.Velocity:Resized(player.MoveSpeed * 4)
                    end
                    if player.Velocity:Length() == 0 then
                        player.Velocity = RandomVector()
                    end
                end
            end
        end
    end
end
mod:AddCallback(mod.CALLBACK.FF_POST_PLAYER_UPDATE, function(_, player)
	mod:slippyPlayerUpdate(player)
end, mod.PLAYER.SLIPPY)
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.ITEM.COLLECTIBLE.FROG_HEAD, function(_, player)
	-- So it doesn't run twice
	if player:GetPlayerType() ~= FiendFolio.PLAYER.SLIPPY then
		mod:slippyPlayerUpdate(player)
	end
end, PlayerVariant.PLAYER)

function mod:slippyPlayerNewRoom(player, d, savedata)
    if player:GetPlayerType() == FiendFolio.PLAYER.SLIPPY or player:HasCollectible(mod.ITEM.COLLECTIBLE.FROG_HEAD) then
        d.frogTimer = 1
    end
end

function mod:slippyPostFireTear(player, tear, rng, pdata, tdata, ignorePlayerEffects, isLudo)
	--Slippy's tear stuff
	if player:GetPlayerType() == FiendFolio.PLAYER.SLIPPY then
		mod:changeTearVariant(tear, mod.TEAR.FROG, mod.TEAR.FROG_BLOOD)
		if not (pdata.cannotFireMoreSlippyTears) and (not ignorePlayerEffects) and (not isLudo) then
			pdata.cannotFireMoreSlippyTears = true
            for i = -15, 15, 30 do
				local shotvel = tear.Velocity:Rotated(i - 5 + math.random(10))
				--local frogExtra = Isaac.Spawn(EntityType.ENTITY_TEAR, tear.Variant, 0, player.Position, shotvel, player):ToTear()
				local frogExtra = player:FireTear(tear.Position, shotvel, true, false, true, player, 0.8)
                frogExtra.Scale = tear.Scale * 0.9
                --[[frogExtra.FallingSpeed = tear.FallingSpeed
				frogExtra.Height = tear.Height
				frogExtra.FallingAcceleration = tear.FallingAcceleration
				frogExtra.TearFlags = tear.TearFlags
				frogExtra:GetSprite().Color = tear:GetSprite().Color
				frogExtra.CollisionDamage = tear.CollisionDamage * 0.8
				frogExtra.Parent = player
				frogExtra.Scale = tear.Scale * 0.9
				frogExtra:Update()]]
                mod.scheduleForUpdate(function()
                    frogExtra.Position = tear.Position
                end, 0)
			end
            pdata.cannotFireMoreSlippyTears = false
		end
	end
end

function mod:frogTearRender(tear, var, data, offset)
	local sprite = tear:GetSprite()
	local scale = tear.Scale
	local flags = tear.TearFlags
	
	local prefix = "Regular"
	if tear.Variant == mod.TEAR.FROG_BLOOD then
		prefix = "Blood"
	end
	
	local anim
	if scale <= 0.3 then
		anim = prefix .. "Tear1"
	elseif scale <= 0.55 then
		anim = prefix .. "Tear2"
	elseif scale <= 0.675 then
		anim = prefix .. "Tear3"
	elseif scale <= 0.8 then
		anim = prefix .. "Tear4"
	elseif scale <= 0.925 then
		anim = prefix .. "Tear5"
	elseif scale <= 1.05 then
		anim = prefix .. "Tear6"
	elseif scale <= 1.175 then
		anim = prefix .. "Tear7"
	elseif scale <= 1.425 then
		anim = prefix .. "Tear8"
	elseif scale <= 1.675 then
		anim = prefix .. "Tear9"
	elseif scale <= 1.925 then
		anim = prefix .. "Tear10"
	elseif scale <= 2.175 then
		anim = prefix .. "Tear11"
	elseif scale <= 2.55 then
		anim = prefix .. "Tear12"
	else
		anim = prefix .. "Tear13"
	end
	
	if not sprite:IsPlaying(anim) then
		local frame = sprite:GetFrame()
		sprite:Play(anim, true)
		sprite:SetFrame(frame)
	end

	local spritescale = mod:getTearScale13(tear)
	local layers = sprite:GetAllLayers()
	for _, layer in ipairs(layers) do
		layer:SetSize(spritescale)
	end
	
	local adjustedVelocity = tear.Velocity
	if tear.WaitFrames > 0 then
		adjustedVelocity = tear.ContinueVelocity
	elseif (tear.FallingSpeed < 0 or 0.2 < tear.FallingSpeed) and 
	       flags & TearFlags.TEAR_LUDOVICO ~= TearFlags.TEAR_LUDOVICO and
	       ((flags & TearFlags.TEAR_ABSORB ~= TearFlags.TEAR_ABSORB and flags & TearFlags.TEAR_POP ~= TearFlags.TEAR_POP) or tear.Velocity:Length() <= 0.1) 
	then
		adjustedVelocity = adjustedVelocity + Vector(0, tear.FallingSpeed)
	end
	
	sprite.Rotation = adjustedVelocity:GetAngleDegrees()
	sprite.FlipX = false
	sprite.FlipY = false
end
mod:AddCallback("FF_CUSTOM_TEAR_RENDER", mod.frogTearRender, FiendFolio.TEAR.FROG)
mod:AddCallback("FF_CUSTOM_TEAR_RENDER", mod.frogTearRender, FiendFolio.TEAR.FROG_BLOOD)

function mod:frogTearSplat(tear, var, data)
	sfx:Play(SoundEffect.SOUND_SPLATTER, 1, 0, false, 1.0)
	
	if tear.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE then return end

	local scale = tear.Scale
	local color = tear:GetSprite().Color
	
	if tear.Variant == mod.TEAR.FROG_BLOOD then
		local poof = Isaac.Spawn(1000, EffectVariant.BULLET_POOF, 0, tear.Position, nilvector, tear)
		poof:GetSprite():ReplaceSpritesheet(0, "gfx/projectiles/projectile_frog_blood_tearpoof.png")
		poof:GetSprite():LoadGraphics()
		
		poof:GetSprite().Color = color
		poof.SpriteScale = Vector(scale * 0.8, scale * 0.8)
		poof.PositionOffset = tear.PositionOffset
	else
		local poof = Isaac.Spawn(1000, EffectVariant.BULLET_POOF, 0, tear.Position, nilvector, tear)
		poof:GetSprite():ReplaceSpritesheet(0, "gfx/projectiles/projectile_frog_tearpoof.png")
		poof:GetSprite():LoadGraphics()
		
		poof:GetSprite().Color = color
		poof.SpriteScale = Vector(scale * 0.8, scale * 0.8)
		poof.PositionOffset = tear.PositionOffset
	end
end
mod:AddCallback("FF_CUSTOM_TEAR_SPLAT", mod.frogTearSplat, FiendFolio.TEAR.FROG)
mod:AddCallback("FF_CUSTOM_TEAR_SPLAT", mod.frogTearSplat, FiendFolio.TEAR.FROG_BLOOD)

function mod:frogLocustAI(fam)
    local sprite = fam:GetSprite()
    fam.SpriteOffset = Vector(0, 6)
    sprite.PlaybackSpeed = fam.Velocity:Length() * 0.03
end