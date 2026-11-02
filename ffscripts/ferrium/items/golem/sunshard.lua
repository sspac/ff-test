local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

function mod:sunShardFamiliar(player)
    if player:HasTrinket(mod.ITEM.ROCK.SUN_SHARD) then
        local mult = math.min(3, math.ceil(FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.SUN_SHARD)))
        player:CheckFamiliar(mod.ITEM.FAMILIAR.SUNSHARD_FAMILIAR, mult or 0, player:GetTrinketRNG(mod.ITEM.ROCK.SUN_SHARD), Isaac:GetItemConfig():GetTrinket(mod.ITEM.ROCK.SUN_SHARD), 0)
        mod:GetEntityData(player).updateSunShardFam = true
    end
end

function mod:SunShardOnTrinketStuffWhatever(player)
    mod:GetEntityData(player).updateSunShardFam = true
end


function mod:sunShardUpdate(player)
    if player:HasTrinket(FiendFolio.ITEM.ROCK.SUN_SHARD) then
        local data = mod:GetEntityData(player)
        if data.updateSunShardFam then
            local mult = math.min(3, math.ceil(FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.SUN_SHARD)))
            local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.SUN_SHARD)
            local nums = mod:getSeveralDifferentNumbers(3, 3, rng)
            local curr = 0
            local myOrbitals = {}
            local rangle = rng:RandomInt(360)
            for e,sun in ipairs(Isaac.FindByType(3, mod.ITEM.FAMILIAR.SUNSHARD_FAMILIAR, -1, false, false)) do
                local fam = sun:ToFamiliar()
                if fam.Player.InitSeed == player.InitSeed then
                    if curr == 0 and mod:GetEntityData(fam).angle then
                        rangle = mod:GetEntityData(fam).angle
                    end
                    curr = curr+1
                    if curr < 4 then
                        table.insert(myOrbitals, fam)
                    else
                        fam:Remove()
                    end
                end
            end
            for num,fam in ipairs(myOrbitals) do
                if data.refreshSunShardFam and (mod:GetEntityData(fam).howManySuns or 0) == #myOrbitals then
                    mod:GetEntityData(fam).sunVariant = nums[num]
                    local splat = Isaac.Spawn(1000, 2, 160, fam.Position, Vector.Zero, nil):ToEffect()
                    splat:FollowParent(fam)
                    fam:Update()
                else
                    local pos = player.Position+Vector(60,0):Rotated(rangle+(num-1)*360/mult)
                    fam.Position = pos
                    local fd = mod:GetEntityData(fam)
                    fd.angle = rangle+(num-1)*360/mult
                    fd.howManySuns = #myOrbitals
                    if not fd.sunVariant then
                        mod:GetEntityData(fam).sunVariant = nums[num]
                    end
                    fam:Update()
                end
            end
            data.refreshSunShardFam = nil
            data.updateSunShardFam = nil

            --[[if data.refreshSunShardFam and data.sunShard then
                for num,fam in ipairs(data.sunShard) do
                    if num > 1 then
                        mod:GetEntityData(fam).angle = (mod:GetEntityData(data.sunShard[1]).angle+(num-1)*360/math.min(3,mult)) % 360
                    end

                    local pos = player.Position+Vector(1,0):Rotated(mod:GetEntityData(fam).angle):Resized(60)
                    data.sunShard[num] = Isaac.Spawn(3, mod.ITEM.FAMILIAR.SUNSHARD_FAMILIAR, nums[num], pos, Vector.Zero, player):ToFamiliar()
                    mod:GetEntityData(data.sunShard[num]).angle = mod:GetEntityData(fam).angle
                    data.sunShard[num]:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    local splat = Isaac.Spawn(1000, 2, 160, pos, Vector.Zero, nil):ToEffect()
                    splat:FollowParent(data.sunShard[num])
                    data.sunShard[num]:Update()
                    fam:Remove()
                    data.refreshSunShardFam = nil
                end
                sfx:Play(SoundEffect.SOUND_MEAT_JUMPS, 0.5, 0, false, 1.3)
            end


            for i=1,math.min(3, mult) do
                if (not data.sunShard or not data.sunShard[i] or not data.sunShard[i]:Exists()) then
                    if not data.sunShard then
                        data.sunShard = {}
                    end

                    local chosenAngle = rangle
                    if i > 1 then
                        chosenAngle = mod:GetEntityData(data.sunShard[1]).angle+(i-1)*360/math.min(3,mult)
                    end
                    local pos = player.Position+Vector(1,0):Rotated(chosenAngle):Resized(60)
                    local rock = Isaac.Spawn(3, mod.ITEM.FAMILIAR.SUNSHARD_FAMILIAR, nums[i], pos, Vector.Zero, player):ToFamiliar()
                    rock.Player = player
                    mod:GetEntityData(rock).angle = chosenAngle
                    data.sunShard[i] = rock
                    rock:Update()
                    rock:Update()
                end
            end
            for num,fam in ipairs(data.sunShard) do
                if num > mult then
                    fam:Remove()
                    data.sunShard[num] = nil
                end
            end
            data.updateSunShardFam = nil]]
        end
	end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.ROCK.SUN_SHARD, mod.sunShardUpdate)

function mod:sunShardNewRoom(player, data)
    if player:HasTrinket(FiendFolio.ITEM.ROCK.SUN_SHARD) then
        data.updateSunShardFam = true
        data.refreshSunShardFam = true
    end
end
mod:AddTrinketCallback("FF_NEW_ROOM_PLAYER_FERRIUM", mod.ITEM.ROCK.SUN_SHARD, mod.sunShardNewRoom)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
	local data = mod:GetEntityData(familiar)
	local sprite = familiar:GetSprite()
	local player = familiar.Player

	if not player or not player:HasTrinket(FiendFolio.ITEM.ROCK.SUN_SHARD) then
		familiar:Remove()
        return
	end
    local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.SUN_SHARD)
	local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.SUN_SHARD)
    local bff = familiar:GetMultiplier()
    local room = game:GetRoom()

	if not data.init then
		data.stateFrame = 0
		data.angle = data.angle or 0
        data.state = "Idle"
        data.speed = 2
        familiar.CollisionDamage = player.Damage/2
		data.init = true
	else
		data.stateFrame = data.stateFrame + 1
		data.angle = data.angle % 360
	end

    data.damaged = nil

	local targPos = player.Position+Vector(1,0):Rotated(data.angle):Resized(60)
	familiar.Velocity = targPos-familiar.Position
    data.angle = data.angle+data.speed

    for _,ent in ipairs(Isaac.FindByType(9,-1,-1,false, true)) do
		if ent.Position:Distance(familiar.Position) - ent.Size < 10 then
			ent:Die()
            if not data.damaged then
                data.damaged = true
            end
		end
	end

    if data.sunVariant == 3 then -- Venus
        if data.damaged and data.stateFrame > 30 and (not data.brain or not data.brain:Exists()) and data.state == "Idle" then
            data.state = "Spawn"
        end
        if data.state == "Spawn" then
            if sprite:IsFinished("SpawnBrain") then
                data.state = "Idle"
                data.damaged = nil
                if not data.couldntSpawn then
                    data.stateFrame = 0
                else
                    data.couldntSpawn = nil
                end
            elseif sprite:IsEventTriggered("Sound") then
                sfx:Play(SoundEffect.SOUND_MEATY_DEATHS,0.5,0,false,1.5)
            elseif sprite:IsEventTriggered("Land") then
                if room:GetGridCollisionAtPos(familiar.Position) == 0 then
                    local brain = Isaac.Spawn(32, 0, 0, familiar.Position, Vector.Zero, player):ToNPC()
                    brain:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)
                    brain.HitPoints = 10*mult*bff
                    brain:GetSprite():ReplaceSpritesheet(0, "gfx/bosses/the sun/sunbrain.png")
			    	brain:GetSprite():LoadGraphics()
                    brain.Scale = 0.8
                    sfx:Play(SoundEffect.SOUND_SUMMONSOUND, 0.5, 0, false, 1)
                    data.brain = brain
                else
                    sfx:Play(SoundEffect.SOUND_MEATY_DEATHS,0.5,0,false,1.5)
                    data.couldntSpawn = true
                end
            else
                mod:spritePlay(sprite, "SpawnBrain")
            end
        elseif data.state == "Idle" then
            mod:spritePlay(sprite, "IdleBrain")
        end
    elseif data.sunVariant == 2 then -- Earth
        if data.damaged and data.stateFrame > 15 and data.state == "Idle" then
            data.state = "Fire"
        end
        if data.state == "Fire" then
            if sprite:IsFinished("FireKidney") then
                data.state = "Idle"
                data.damaged = nil
                data.stateFrame = 0
            elseif sprite:IsEventTriggered("Sound") then
                data.firing = 4
                local radius = 9999
                local target
                for _,ent in ipairs(Isaac.FindInRadius(familiar.Position, 500, EntityPartition.ENEMY)) do
                    if ent:IsActiveEnemy() and (not mod:isFriend(ent)) then
                        if ent.Position:Distance(familiar.Position) < radius then
                            radius = ent.Position:Distance(familiar.Position)
                            target = ent
                        end
                    end
                end
                if target then
                    data.shootVec = target.Position-familiar.Position
                else
                    data.shootVec = Vector(0,1):Rotated(rng:RandomInt(360))
                end
                sfx:Play(mod.Sounds.Valvo, 0.6, 0, false, math.random(9,11)/10)
            else
                mod:spritePlay(sprite, "FireKidney")
            end
        elseif data.state == "Idle" then
            mod:spritePlay(sprite, "IdleKidney")
        end

        if data.firing then
            if data.firing > 0 then
                for i=1,data.firing do
                    local tear = Isaac.Spawn(2, 1, 0, familiar.Position, data.shootVec:Resized(data.firing*mod:getRoll(70,110,rng)/100*2.5):Rotated(mod:getRoll(-6,6,rng)), familiar):ToTear()
                    tear.Color = mod.ColorLemonYellow
                    tear.Scale = data.firing/3.5*mod:getRoll(70,110,rng)/100
                    tear.FallingAcceleration = mod:getRoll(1,10,rng)/40*(5-data.firing)
                    tear.FallingSpeed = -data.firing/2
                    tear.CollisionDamage = player.Damage/3*bff
                end
                data.firing = data.firing-1
            else
                data.firing = nil
            end
        end
    elseif data.sunVariant == 1 then -- Neptune
        if data.damaged and data.stateFrame > 20 and data.state == "Idle" then
            data.state = "Beating"
            data.stateFrame = 0
            data.speed = 7.95
        end
        if data.state == "Beating" then
            if data.stateFrame > 120 then
                data.state = "Idle"
                data.damaged = nil
                data.stateFrame = 0
                data.speed = 2
            elseif sprite:IsEventTriggered("Shoot") then
                local tear = Isaac.Spawn(2, 1, 0, familiar.Position, Vector.Zero, familiar):ToTear()
                tear.FallingSpeed = 0
                tear.FallingAcceleration = 0
                tear.CollisionDamage = player.Damage*bff
                sfx:Play(SoundEffect.SOUND_HEARTBEAT_FASTEST, 0.8, 0, false, 1.5)
            else
                mod:spritePlay(sprite, "BeatingHeart")
            end
            if familiar.FrameCount % 3 == 0 then
                local creep = Isaac.Spawn(1000, 46, 0, familiar.Position, Vector.Zero, player):ToEffect()
                creep.SpriteScale = Vector(0.4,0.4)
                creep.CollisionDamage = player.Damage/3*bff
            end
        elseif data.state == "Idle" then
            mod:spritePlay(sprite, "IdleHeart")
        end
    end
end, mod.ITEM.FAMILIAR.SUNSHARD_FAMILIAR)