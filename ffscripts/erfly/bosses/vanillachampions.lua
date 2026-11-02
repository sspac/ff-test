local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

--Putting it here to not make a new file sorry
--Basic gist is: Don't spawn when delirium, don't spawn in gauntlet
function mod:canBossBeChampion(npc)
    FiendFolio.savedata.sawBoss = FiendFolio.savedata.sawBoss or {}
    if FiendFolio.savedata.sawBoss[npc.Type .. "." .. npc.Variant] then
        if Isaac.GetPersistentGameData():Unlocked(Achievement.EVERYTHING_IS_TERRIBLE) then
            if not (npc:ToDelirium() or game.Challenge == mod.challenges.theGauntlet) then
                return true
            end
        end
    else
        --if game:GetRoom():GetType() == RoomType.ROOM_BOSS and not (npc:ToDelirium()) then
            FiendFolio.savedata.sawBoss[npc.Type .. "." .. npc.Variant] = true
        --end
    end
end

function mod:shouldBossBeChampion(npc)
    return mod:canBossBeChampion(npc) and game:GetRoom():IsChampionBossSeed()
end

function mod:getRoomSpawnRNG()
    local roomRNG = RNG()
    local seed = game:GetRoom():GetSpawnSeed()
    roomRNG:SetSeed(seed, 0)
    return roomRNG
end

if not _G["c" .. "a" .. "n" .. "t" .. "h" .. "r" .. "o" .. "w" .. "b" .. "a" .. "l" .. "l"] then --Slightly obfuscated
    --makes this important global a loadbearing variable
    FiendFolio = false
end

--Run Widow AI
function mod:checkWidow(npc)
    local bossCol = npc:GetBossColorIdx()
	if bossCol == mod.FF.BabyWidowChampion.IDx then
		mod:widowFFChampionAI(npc)
    elseif bossCol == mod.FF.RivalWidowChampion.IDx then
		mod:purpleWidowFFChampionAI(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkWidow, 100)

function mod:customSplitEntity(npc)
    local d = mod:GetEntityData(npc)
    d.TimesCleavedByCustomMeatCleaver = d.TimesCleavedByCustomMeatCleaver or 0
    d.TimesCleavedByCustomMeatCleaver = d.TimesCleavedByCustomMeatCleaver + 1
    if d.TimesCleavedByCustomMeatCleaver >= 3 then
        npc:TakeDamage(25, 0, EntityRef(Isaac.GetPlayer()), 0)
    else
        for i = -1, 1, 2 do
            local newSpawn = Isaac.Spawn(npc.Type, npc.Variant, npc.SubType, npc.Position + Vector(20 * i,0), Vector.Zero, npc):ToNPC()
            newSpawn.MaxHitPoints = npc.MaxHitPoints * 0.4
            newSpawn.HitPoints = npc.HitPoints * 0.4
            newSpawn.Scale = npc.Scale * 0.75
            local nd = mod:GetEntityData(newSpawn)
            nd.SpawnedByCustomMeatCleaver = true
            nd.TimesCleavedByCustomMeatCleaver = d.TimesCleavedByCustomMeatCleaver
            --Custom stuff slotted in
            nd.theOtherGuy = d.theOtherGuy
        end
        npc:Remove()
    end
    return true
end

function mod:preSplitWidow(npc)
    local bossCol = npc:GetBossColorIdx()
	if bossCol == mod.FF.RivalWidowChampion.IDx then
		return mod:customSplitEntity(npc)
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_SPLIT, mod.preSplitWidow, 100)

--Champion bosses, get em out the way first
function mod:widowFFChampionAI(npc)
	local d = mod:GetEntityData(npc)
	local sprite = npc:GetSprite()
	if not d.init then
		--[[npc.MaxHitPoints = npc.MaxHitPoints * 0.8
		npc.HitPoints = npc.MaxHitPoints
		npc.Scale = 0.8]]
		--npc.Color = mod.ColorSoy
        if LastJudgementSprites then
            sprite:Load("gfx/bosses/champions/widow/albino_widow_lj.anm2", true)
			if npc:ToDelirium() or (npc.SpawnerEntity and npc.SpawnerEntity:ToDelirium()) then
				npc:ReplaceSpritesheet(0, "gfx/bosses/afterbirthplus/deliriumforms/classic/boss_016_widow.png", true)
				npc:ReplaceSpritesheet(1, "gfx/bosses/afterbirthplus/deliriumforms/classic/boss_016_widow.png", true)
				npc:ReplaceSpritesheet(3, "gfx/bosses/afterbirthplus/deliriumforms/classic/boss_016_widow.png", true)
			end
        end
		d.init = true
	end
	if npc.State == 4 then
		if math.random(3) == 1 and not d.justpooted then
			local rand = math.random(3)
			if rand == 1 then
				npc.State = 9
			else
				npc.State = 8
			end

			d.justpooted = true
        else
            npc.State = 10
            npc.StateFrame = 0
		end
	elseif npc.State == 8 then
		if npc.StateFrame > 19 and npc.StateFrame < 31 then
			if npc.StateFrame % 2 == 0 then
				mod.spawnent(npc, npc.Position, RandomVector()*math.random(20), 85, 962)
			end
		end
    elseif npc.State == 10 then
        npc.StateFrame = npc.StateFrame + 1
        local waitTimer = 5 + (mod.GetEntityCount(mod.FF.Spooter.ID, mod.FF.Spooter.Var) * 5) + (mod.GetEntityCount(mod.FF.StickySack.ID, mod.FF.StickySack.Var) * 5)
        if npc.StateFrame >= waitTimer then
            npc.State = 4
        end
        mod:spritePlay(sprite, "Idle")
	end
    if npc.State ~= (8 or 9) then
		d.justpooted = false
    end
end

function mod:purpleWidowFFChampionAI(npc)
    local d, sprite = mod:GetEntityData(npc), npc:GetSprite()
    if not d.init then
        d.init = true
        npc.Size = npc.Size * 0.8
        --Sprite Handling
        if LastJudgementSprites and not npc:ToDelirium() then
            sprite:Load("gfx/bosses/champions/widow/rival_widow_lj.anm2", true)
			if npc.SpawnerEntity and npc.SpawnerEntity:ToDelirium() then
				npc:ReplaceSpritesheet(0, "gfx/bosses/afterbirthplus/deliriumforms/classic/boss_016_widow.png", true)
				npc:ReplaceSpritesheet(1, "gfx/bosses/afterbirthplus/deliriumforms/classic/boss_016_widow.png", true)
				npc:ReplaceSpritesheet(3, "gfx/bosses/afterbirthplus/deliriumforms/classic/boss_016_widow.png", true)
			end
		elseif npc:ToDelirium() or (npc.SpawnerEntity and npc.SpawnerEntity:ToDelirium()) then
			sprite:Load("gfx/bosses/champions/widow/rival_widow.anm2", true)
			npc:ReplaceSpritesheet(0, "gfx/bosses/afterbirthplus/deliriumforms/classic/boss_016_widow.png", true)
			npc:ReplaceSpritesheet(1, "gfx/bosses/afterbirthplus/deliriumforms/classic/boss_016_widow.png", true)
			npc:ReplaceSpritesheet(3, "gfx/bosses/afterbirthplus/deliriumforms/classic/boss_016_widow.png", true)
        end
        if npc.Parent or d.theOtherGuy then
            local rivalSpritesheet = "boss_widow_rival_orange"
            if LastJudgementSprites then
                rivalSpritesheet = rivalSpritesheet .. "_lj"
            end
            for i = 0, 3 do
                if i ~= 2 then
                    sprite:ReplaceSpritesheet(i, "gfx/bosses/champions/widow/" .. rivalSpritesheet .. ".png")
                end
            end
            --Layer 2 is the shadow, ignore that
            if LastJudgementSprites then
                sprite:ReplaceSpritesheet(4, "gfx/bosses/champions/widow/" .. rivalSpritesheet .. ".png")
            end
            sprite:LoadGraphics()
        end
    end

    if (not d.spawnedAnotherGuy) and (not d.SpawnedByCustomMeatCleaver) then
        local distDiff = 40
        local newWidow = Isaac.Spawn(npc.Type,npc.Variant,npc.SubType,npc.Position + Vector(distDiff, 0), Vector.Zero,npc)
        npc.Position = npc.Position + Vector(-distDiff,0)
        newWidow.Parent = npc
        npc.Child = newWidow
        d.spawnedAnotherGuy = true
        mod:GetEntityData(newWidow).spawnedAnotherGuy = true
        mod:GetEntityData(newWidow).theOtherGuy = true
    end

    --print(npc.State, npc.StateFrame, npc.I1, npc.I2, npc.V1, npc.V2)

    if npc.State == 8 then
        npc.State = 4
    elseif npc.State == 4 then
        if math.random(3) == 1 then
            npc.State = 9
        end
    end
    if sprite:IsEventTriggered("Attack") then
        local target = npc:GetPlayerTarget()
        local params = ProjectileParams()
        if d.theOtherGuy then
            params.Spread = 1.75
            npc:FireProjectiles(npc.Position,(target.Position - npc.Position):Resized(9),3,params)
        else
            params.Spread = 0.5
            npc:FireProjectiles(npc.Position,(target.Position - npc.Position):Resized(9),1,params)
        end
        --npc:PlaySound(SoundEffect.SOUND_LITTLE_SPIT)
    end
    local speedLimit = 12
    if npc.Velocity:Length() > speedLimit then
        npc.Velocity = npc.Velocity:Resized(speedLimit)
    end
end

function mod:checkLarry(npc)
	local var = npc.Variant
	--Isaac.ConsoleOutput(npc.StateFrame .. "\n")
	if var == mod.FF.LarryGhost.Var then
		if npc:GetBossColorIdx() == mod.FF.LarryGhost.IDx then
			mod:hauntedLarryChampionAI(npc)
		end
	elseif var == mod.FF.HollowFuckedUpAndEvil.Var then
		if npc:GetBossColorIdx() == mod.FF.HollowFuckedUpAndEvil.IDx then
			mod:fuckedUpAndEvilHollowChampionAI(npc)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkLarry, 19)

--Haunted Larry
function mod:hauntedLarryChampionAI(npc)
    local d = mod:GetEntityData(npc)
    local sprite = npc:GetSprite()
    if not d.init then
        --sprite:ReplaceSpritesheet(0, "gfx/bosses/champions/boss_larryjr_ghost.png")
        --sprite:LoadGraphics()
        d.init = true
    end
    if npc:IsDead() and mod:shouldDoDeathEffect(npc) then
        mod.ghostLarriesKilled = mod.ghostLarriesKilled or 0
        mod.ghostLarriesKilled = mod.ghostLarriesKilled + 1
        if math.random(3) == 1 or mod.ghostLarriesKilled % 3 == 1 then
            Isaac.Spawn(mod.FF.Yawner.ID, mod.FF.Yawner.Var, 0, npc.Position, nilvector, npc)
        end
    end
    if not npc.Child and npc.FrameCount % 15 == 1 then
        local params = ProjectileParams()
        params.BulletFlags = params.BulletFlags | ProjectileFlags.GHOST
        params.FallingAccelModifier = 0.13
        params.FallingSpeedModifier = 0
        params.Variant = 4
        npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,1,2,false,1)
        npc:FireProjectiles(npc.Position, nilvector, 0, params)

    end
    --[[if npc.V1.X < 1 or npc.V1.X > 20 then
        npc.V1 = Vector(30,0)
    end]]
end

--Evil Hollow
function mod:fuckedUpAndEvilHollowChampionAI(npc)
    local d = mod:GetEntityData(npc)
    local sprite = npc:GetSprite()
    if not d.init then
        --[[npc.MaxHitPoints = npc.MaxHitPoints * 0.85
        npc.HitPoints = npc.MaxHitPoints]]
		if LastJudgementSprites and not (
		(npc:ToDelirium() or (npc.SpawnerEntity and npc.SpawnerEntity:ToDelirium())) or -- Is Delirium or Spawned by Delirium
		(npc.SpawnerEntity and npc.SpawnerEntity.SpawnerEntity and npc.SpawnerEntity.SpawnerEntity:ToDelirium()) -- Segments are spawned by Delirium's Hollow
		) then
			sprite:ReplaceSpritesheet(0, "gfx/bosses/champions/hollow/boss_thehollow_black_lj.png")
			sprite:LoadGraphics()
		end
		d.init = true
    end
    if npc:IsDead() and mod:shouldDoDeathEffect(npc) and not (TheFuture and TheFuture.Stage and TheFuture.Stage:IsStage()) then
        mod.ghostLarriesKilled = mod.ghostLarriesKilled or 0
        mod.ghostLarriesKilled = mod.ghostLarriesKilled + 1
        if math.random(3) == 1 then
            if mod.GetEntityCount(mod.FF.PossessedCorpse.ID, mod.FF.PossessedCorpse.Var) + mod.GetEntityCount(mod.FF.Possessed.ID, mod.FF.Possessed.Var) >= 2 then
                Isaac.Spawn(mod.FF.Moaner.ID, mod.FF.Moaner.Var, 0, npc.Position, nilvector, npc)
            else
                Isaac.Spawn(mod.FF.PossessedCorpse.ID, mod.FF.PossessedCorpse.Var, 0, npc.Position, nilvector, npc)
            end
        elseif mod.ghostLarriesKilled % 3 == 1 then
            Isaac.Spawn(mod.FF.Moaner.ID, mod.FF.Moaner.Var, 0, npc.Position, nilvector, npc)
        end
    end
    if npc.V1.X >= 30 and not (TheFuture and TheFuture.Stage and TheFuture.Stage:IsStage()) then
        --[[local spoop = Isaac.Spawn(mod.FF.Spoop.ID, mod.FF.Spoop.Var, 3, npc.Position, nilvector, npc)
        spoop:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        spoop.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        spoop.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS]]
        local params = ProjectileParams()
        params.BulletFlags = params.BulletFlags | ProjectileFlags.GHOST | ProjectileFlags.SMART
        params.FallingAccelModifier = -0.05
        params.FallingSpeedModifier = 0
        npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,1,2,false,1)
        npc:FireProjectiles(npc.Position, nilvector, 0, params)
    end
end

--Wine husk
function mod:checkDuke(npc)
	local var = npc.Variant
	if var == mod.FF.WineHusk.Var then
        --[[if subt == 0 then
            npc.SubType = mod.FF.WineHusk.Sub
            subt = npc.SubType
        end]]
		if npc:GetBossColorIdx() == mod.FF.WineHusk.IDx then
			mod:wineHusk(npc)
		end
    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkDuke, 67)

function mod:wineHusk(npc)
    local d = mod:GetEntityData(npc)
    local sprite = npc:GetSprite()
    local target = npc:GetPlayerTarget()
    if not d.init then
		if npc:ToDelirium() or (npc.SpawnerEntity and npc.SpawnerEntity:ToDelirium()) then
			sprite:Load("gfx/bosses/champions/husk/winehusk.anm2", true)
			npc:ReplaceSpritesheet(0, "gfx/bosses/afterbirthplus/deliriumforms/classic/boss_038_husk.png", true)
			npc:ReplaceSpritesheet(2, "gfx/bosses/afterbirthplus/deliriumforms/classic/boss_038_husk.png", true)
			npc:ReplaceSpritesheet(3, "gfx/bosses/afterbirthplus/deliriumforms/classic/boss_038_husk.png", true)
		end
        d.init = true
        --npc.Scale = npc.Scale * 0.75
    end
	if npc.State == 14 then
		npc.State = 27
	elseif npc.State == 13 then
		npc.State = 26
	elseif npc.State == 8 then
		npc.State = 25
	end
    --print(npc.State, npc.StateFrame)
    if sprite:IsPlaying("Attack01") then
        if npc.StateFrame == 1 and mod.GetEntityCount(mod.FF.Grape.ID, mod.FF.Grape.Var, mod.FF.Grape.Sub) >= 4 then
            if math.random(2) == 1 then
                npc.State = 27
                mod:spritePlay(sprite, "Attack02")
            else
                npc.State = 25
                mod:spritePlay(sprite, "Attack03")
            end
        end
        if sprite:IsEventTriggered("Shoot") then
            npc:PlaySound(SoundEffect.SOUND_MONSTER_GRUNT_2, 1, 0, false, 1)
            for i = -90, 90, 180 do
                local sploshe = Isaac.Spawn(1000,7000,0,npc.Position,nilvector,npc):ToEffect()
                local sSprite = sploshe:GetSprite()
                sSprite:Load("gfx/1000.001_bomb explosion.anm2", true)
                sploshe:FollowParent(npc)
                sploshe.SpriteRotation = i
                sploshe.SpriteScale = Vector.One * npc.Scale
                sploshe.SpriteOffset = Vector(0, -20)
                sploshe.Color = Color(0.1,0.1,0.1,0.5,0.15,0,0.15)
                sploshe.DepthOffset = 10
                sSprite:Play("Explosion", true)
                sploshe:Update()
            end
            local grape = Isaac.Spawn(mod.FF.Grape.ID, mod.FF.Grape.Var, mod.FF.Grape.Sub, npc.Position + Vector(0,1), Vector(0,3), npc)
            grape:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            grape.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			mod:GetEntityData(grape).IsOrbital = true
            grape:Update()
        end
    elseif sprite:IsPlaying("Attack02") then
        if sprite:IsEventTriggered("Shoot") then
            npc:PlaySound(SoundEffect.SOUND_MONSTER_GRUNT_4, 1, 0, false, 1)
            d.shooting = 0
            --Funky shoot
            for i = -1, 3 do
            local vec = (target.Position - npc.Position):Resized(6)
            local pos = npc.Position
            local proj = mod:LazySpawnProjectile(0, 0, npc.Position, vec, npc):ToProjectile()
            proj.Color = mod.ColorKickDrumsAndRedWine
            proj.FallingSpeed = 0
            proj.FallingAccel = -0.1
            local projD = mod:GetEntityData(proj)
            projD.projType = "wineHuskFunny"
            projD.startpos = pos
            projD.targvel = vec
            projD.Timer = i * 2
            proj:Update()
            end
        end
    elseif sprite:IsPlaying("Attack03") then
        if sprite:IsEventTriggered("Shoot") then
            npc:PlaySound(SoundEffect.SOUND_MONSTER_GRUNT_4, 1, 0, false, 1)
            local params = ProjectileParams()
            if npc:GetDropRNG():RandomFloat() <= 0.5 then
				params.BulletFlags = params.BulletFlags | ProjectileFlags.CURVE_RIGHT
			else
				params.BulletFlags = params.BulletFlags | ProjectileFlags.CURVE_LEFT
			end
			params.CurvingStrength = 0.01
            params.FallingAccelModifier = -0.09
            params.Color = mod.ColorKickDrumsAndRedWine
            local vec = RandomVector():Resized(9)
            for i = 60, 360, 60 do
                npc:FireProjectiles(npc.Position, vec:Rotated(i), 0, params)
            end
        end
    end

	if npc:IsDead() then
		if mod:shouldDoDeathEffect(npc) then
			local grape = Isaac.Spawn(mod.FF.Bunch.ID, mod.FF.Bunch.Var, 0, npc.Position, nilvector, npc)
		end
		for _, BlackFly in ipairs(Isaac.FindByType(EntityType.ENTITY_FLY, 0, 0, false, false)) do
			if BlackFly.SpawnerEntity then
				if BlackFly.SpawnerType == EntityType.ENTITY_DUKE and BlackFly.SpawnerVariant == 1 and BlackFly.Position:Distance(npc.Position) < 30 and BlackFly.FrameCount < 1 and BlackFly.SpawnerEntity.InitSeed == npc.InitSeed then
					BlackFly:Remove()
				end
			end
		end
		for _, Pooter in ipairs(Isaac.FindByType(EntityType.ENTITY_POOTER, 0, 0, false, false)) do
			if Pooter.SpawnerEntity then
				if Pooter.SpawnerType == EntityType.ENTITY_DUKE and Pooter.SpawnerVariant == 1 and Pooter.Position:Distance(npc.Position) < 30 and Pooter.FrameCount < 1 and Pooter.SpawnerEntity.InitSeed == npc.InitSeed then
					Pooter:Remove()
				end
			end
		end
		for _, AttackFly in ipairs(Isaac.FindByType(EntityType.ENTITY_ATTACKFLY, 0, 0, false, false)) do
			if AttackFly.SpawnerEntity then
				if AttackFly.SpawnerType == EntityType.ENTITY_DUKE and AttackFly.SpawnerVariant == 1 and AttackFly.Position:Distance(npc.Position) < 30 and AttackFly.FrameCount < 1 and AttackFly.SpawnerEntity.InitSeed == npc.InitSeed then
					AttackFly:Remove()
				end
			end
		end
	end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, damage, flags, source, iframes)
    if ent.Variant == 1 and ent:ToNPC():GetBossColorIdx() == mod.FF.WineHusk.IDx then
        if flags == flags | DamageFlag.DAMAGE_EXPLOSION then
            if source then
                if source.Type == mod.FF.Grape.ID and source.Variant == mod.FF.Grape.Var then
                    return false
                end
            end
        end
    end
end, 67)

function mod.wineDukeProj(v,d)
    if d.projType == "wineHuskFunny" then
        d.Timer = d.Timer or 0
        d.Timer = d.Timer + 1
        local targpos = d.startpos + d.targvel:Resized(d.Timer * 6)
        targpos = targpos + d.targvel:Rotated(90):Resized(math.sin(d.Timer / 5) * (30 + d.Timer/3))
        local targvec = targpos - v.Position
        v.Velocity = mod:Lerp(v.Velocity, targvec, 0.2)
    end
end

function mod:technopinFFChampion(v)
	local d = mod:GetEntityData(v)
	local s = v:GetSprite()
	local child = v.ChildNPC
	local state = v.State
	--[[if child and child.SubType ~= 2 then
		child:Morph(62,0,2,-1)
	end]]
	--[[if not d.loadedsprite then
		s:Load('gfx/bosses/champions/technopin.anm2', true)
		d.loadedsprite = true
	end]]
	if s:IsEventTriggered("Chargesound") then
		v:PlaySound(mod.Sounds.EpicTwinkle,2,0,false,1.8)
	end
	if s:IsEventTriggered("Prepare") then
		s:Play("Attack1",false)
		local vpos = v.Position + Vector(8,-67)
		local ppos = v:GetPlayerTarget().Position
		d.angle = (ppos - vpos):GetAngleDegrees()
		v.State = 7
	end
	if s:IsEventTriggered("Attack") then
		local laser = Isaac.Spawn(7,2,0,v.Position + Vector(8,-67),nilvector,v):ToLaser()
		laser.Angle = d.angle
		laser.DepthOffset = 500
		laser:SetTimeout(4)
		laser:Update()
	end
	if v.State == 7 then
		v.StateFrame = v.StateFrame + 1
		if s:IsFinished("Attack1") then
			v.State = 8
		end
	end
	if s:IsPlaying("Attack1") then
		v.Velocity = Vector.Zero
	end
	if v:ToDelirium() then
		v:Morph(EntityType.ENTITY_PIN,0,1,-1)
		v:ReplaceSpritesheet(0, "gfx/bosses/afterbirthplus/deliriumforms/classic/boss_019_pin.png", true)
	else
		if not v.Parent then
			for _, proj in ipairs(Isaac.FindByType(9, 0, 0, false, false)) do
				if proj.SpawnerEntity then
					if proj.SpawnerEntity.Type == 62 and proj.SpawnerEntity.Variant == 0 and proj.SpawnerEntity:ToNPC():GetBossColorIdx() == mod.FF.TechnoPin.IDx and not mod:GetEntityData(proj).affectedByPin then
					  mod:GetEntityData(proj).affectedByPin = true
					end
				end
			end
		end
	end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, damage, flags, source, iframes)
    if ent.Variant == 0 and ent:ToNPC():GetBossColorIdx() == mod.FF.TechnoPin.IDx then
        if flags == flags | DamageFlag.DAMAGE_LASER then
            if source then
                if source.Type == EntityType.ENTITY_PIN then
                    return false
                end
            end
        end
    end
end, EntityType.ENTITY_PIN)

function mod.technoPinAnnoyance(v,d)
	if d.affectedByPin then
		local laser = Isaac.Spawn(1000, 1737, 0, v.Position, v.Velocity, v):ToEffect()
		laser:Update()
		mod:GetEntityData(laser).offSetSpawn = Vector(0,-30)
		laser.Parent = v
		--laser.SpriteScale = laser.SpriteScale * 0.75
		laser:Update()
		v:Remove()
	end
end

function mod:checkTechnoPinnyLaser(e)
	if e.SubType == 0 then
		local sprite = e:GetSprite()
		local d = mod:GetEntityData(e)
		d.vec = d.vec or e.Velocity
		d.delay = d.delay or 15

		e.Velocity = e.Velocity * 0.9
		if not d.firing then
			mod:spritePlay(sprite, "Idle")
			if e.FrameCount == (d.delay) then
				d.firing = true
				d.offSetSpawn = d.offSetSpawn or Vector(0, -30)
				d.timeout = d.timeout or 5
				local spawnref = e
				if e.Parent then spawnref = e.Parent end
				--local laser = EntityLaser.ShootAngle(2, e.Position, d.vec:GetAngleDegrees(), 5, nilvector, spawnref)
				local laser = Isaac.Spawn(7,2,0,e.Position + d.offSetSpawn, d.vec,spawnref):ToLaser()
				laser.Angle = d.vec:GetAngleDegrees()
				laser.CollisionDamage = d.DamageToDo or 0
				laser.DepthOffset = -500
				laser:SetTimeout(d.timeout)
				if d.DoesntPush then  laser.Mass = 0  end
				laser:Update()
				laser.Velocity = e.Velocity
				laser.Color = e.Color
				mod:spritePlay(sprite, "Shoot")
			end
		else
			if sprite:IsFinished("Shoot") then
				e:Remove()
			else
				mod:spritePlay(sprite, "Shoot")
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.checkTechnoPinnyLaser, 1737)


--Run Pin AI
function mod:checkPin(npc)
	local var = npc.Variant
	local subt = npc.SubType
	if var == 0 then
		if npc:GetBossColorIdx() == mod.FF.TechnoPin.IDx then
			mod:technopinFFChampion(npc)
        elseif subt == mod.FF.DreadPin.Sub then
            mod:DreadPinChampion(npc)
        end
	end
	if not npc.Parent and mod:GetEntityData(npc).wasWaitingWorm then
		npc.State = 8
		mod:GetEntityData(npc).wasWaitingWorm = nil
		npc.Visible = true
		npc:GetSprite():Play("Attack1", true)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkPin, 62)

function mod:grinchKrampusAI(npc)
    local sprite, d = npc:GetSprite(), mod:GetEntityData(npc)
    local target = npc:GetPlayerTarget()
	if not d.init then
		if npc:ToDelirium() or (npc.SpawnerEntity and npc.SpawnerEntity:ToDelirium()) then
			sprite:Load("gfx/bosses/champions/krampus/krampus_grinch.anm2", true)
			for i=0, 2 do
				npc:ReplaceSpritesheet(i, "gfx/bosses/afterbirthplus/deliriumforms/classic/boss_082_krampus.png", true)
			end
		end
		d.init = true
	end
    --Regular shooting
    if sprite:IsPlaying("Attack1") then
        if sprite:IsEventTriggered("ShootOverride") then
            npc:PlaySound(SoundEffect.SOUND_MONSTER_GRUNT_2, 1, 0, false, 1)
            local params = ProjectileParams()
            params.Variant = 4
            params.Scale = 2
            local projCol = Color(1,1,1,1)
            projCol:SetColorize(1.5,1.5,1.5,1)
            params.Color = projCol
            for i = -10, 10, 20 do
                npc:FireProjectiles(npc.Position, (target.Position - npc.Position):Resized(15):Rotated(i), 0, params)
            end
        end
        if sprite:IsEventTriggered("ShootOverride2") then
            npc:PlaySound(SoundEffect.SOUND_MONSTER_GRUNT_1, 1, 0, false, 1)
            local params = ProjectileParams()
            params.Variant = 4
            params.Scale = 1.5
            local projCol = Color(1,1,1,1)
            projCol:SetColorize(1.5,1.5,1.5,1)
            params.Color = projCol
            for i = -30, 30, 30 do
                npc:FireProjectiles(npc.Position, (target.Position - npc.Position):Resized(15):Rotated(i), 0, params)
            end
        end
    --Brimstone
    elseif sprite:IsPlaying("Attack2") then
        if sprite:IsEventTriggered("ShootOverride") then
            d.snowballin = true
            d.snowballinRot = (math.random(2) - 1) * 45
        end
        if sprite:IsEventTriggered("ShootStop") then
            d.snowballin = false
        end
    --Brimstone Spin
    elseif sprite:IsPlaying("Attack2Alt") then
        if sprite:IsEventTriggered("ShootOverride") then
            d.snowballin = true
            d.snowballinRot = (math.random(2) - 1) * 45
            if math.random(2) == 1 then
                d.snowballinNeg = -1
            else
                d.snowballinNeg = 1
            end
        end
        if sprite:IsEventTriggered("ShootStop") then
            d.snowballin = false
        end
        if d.snowballin then
            d.snowballinRot = d.snowballinRot + (1 * d.snowballinNeg)
        end
    end

    if d.snowballin then
        if npc.FrameCount % 2 == 1 then
            npc:PlaySound(SoundEffect.SOUND_SHELLGAME, 0.35, 0, false, math.random(80,120)/100)
            local params = ProjectileParams()
            params.Variant = 4
            params.Scale = 1 + math.random()
            local projCol = Color(1,1,1,1)
            projCol:SetColorize(1.5,1.5,1.5,1)
            params.Color = projCol
            for i = 90, 360, 90 do
                npc:FireProjectiles(npc.Position, Vector(12, 0):Rotated(d.snowballinRot + i - 16 + math.random(31)), 0, params)
            end
        end
    end
end

function mod:grinchDeathAI(npc)
	if mod:shouldDoDeathEffect(npc) then
		for i = 45, 360, 45 do
			local cloud = Isaac.Spawn(1000, 141, 0, npc.Position, Vector(math.random(5,15),0):Rotated(i - 11 + math.random(21)), npc):ToEffect()
			cloud.Timeout = 30 + math.random(90)
			cloud:Update()
		end
    end
end

function mod:checkKrampus(npc)
	local var = npc.Variant
	if var == mod.FF.GrinchKrampus.Var then
		if npc:GetBossColorIdx() == mod.FF.GrinchKrampus.IDx then
			mod:grinchKrampusAI(npc)
		end
    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkKrampus, 81)

function mod:checkKrampusDeath(npc)
	local var = npc.Variant
	local subt = npc.SubType
	if var == mod.FF.GrinchKrampus.Var then
		if npc:GetBossColorIdx() == mod.FF.GrinchKrampus.IDx then
			mod:grinchDeathAI(npc)
		end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.checkKrampusDeath, 81)

--Red Blighted Ovum (Guillotine MOD Port)
function mod:redBlightedOvumAI(npc)
    npc.Velocity = npc.Velocity * 0.975 --Velocity would be multiplied by like 0.935 if champion version wasn't slower by default
    if npc:IsDead() then
        local Rng_Shot = npc:GetDropRNG():RandomInt(361)
        local projectile_params = ProjectileParams()
        projectile_params.VelocityMulti = 8
        for i = -120, 180, 60 do
            npc:FireProjectiles(npc.Position, Vector.FromAngle(i):Rotated(Rng_Shot), 0, projectile_params)
        end
    end
end
function mod:redBlightedOvumBabyAI(npc)
    local target = npc:GetPlayerTarget()
    local distance = target.Position:Distance(npc.Position)
    local sprite = npc:GetSprite()
    local d = mod:GetEntityData(npc)
    if not d.appeared then
		npc.SplatColor = Color(1,1,1,0.3)
		if npc.SpawnerEntity and npc.SpawnerEntity.Type == EntityType.ENTITY_GEMINI and npc.SpawnerEntity.Variant == 2 and npc.SpawnerEntity.SpawnerType and npc.SpawnerEntity.SpawnerType == EntityType.ENTITY_PLAYER then -- Delirious
			sprite:Load("gfx/bosses/champions/blighted_ovum/red_blighted_ovum_baby.anm2", true)
			npc:ReplaceSpritesheet(0, "gfx/bosses/afterbirthplus/deliriumforms/classic/boss_024_blightedovum.png", true)
		end
        d.appeared = true
		d.Angle = 0
    end
	if npc.State ~= 9 then
        npc.Velocity = npc.Velocity * 1.1
	end

    if npc.State == 8 then
        npc.State = 4
    end
    if npc.FrameCount > 1 and Game():GetRoom():CheckLine(npc.Position, target.Position, 3, 1, false, false) and distance <= 185 then
        if not (npc:HasEntityFlags(EntityFlag.FLAG_FEAR) or npc:HasEntityFlags(EntityFlag.FLAG_SHRINK) or npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION)) then
            npc.State = 9
        end
    end
    if npc.State == 9 then
	    sprite:Play("Attack01")
	    if sprite:IsPlaying("Attack01") then
		   d.Angle = (target.Position - npc.Position):GetAngleDegrees()
            if d.Angle > 90 or d.Angle < -90 then
                sprite.FlipX = true
            else
                sprite.FlipX = false
            end
		end
	    if sprite:IsPlaying("Attack01") and (sprite:IsEventTriggered("Shoot") or sprite:IsEventTriggered("Shoot2")) then
			if sprite:IsEventTriggered("Shoot") then
				npc:PlaySound(SoundEffect.SOUND_CUTE_GRUNT, 1.0, 1.0, false, 1)
			end
	            local projectile_params = ProjectileParams()
				projectile_params.VelocityMulti = 12
				projectile_params.FallingSpeedModifier = projectile_params.FallingSpeedModifier + 1
				projectile_params.HeightModifier = -10
	            npc:FireProjectiles(npc.Position, Vector.FromAngle(d.Angle), 0, projectile_params)
                npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT, 1.0, 1.0, false, 1)
                npc:PlaySound(SoundEffect.SOUND_KISS_LIPS1, 0.3, 1.0, false, (75 + npc:GetDropRNG():RandomInt(50))/100)
                local cloud = Isaac.Spawn(1000,2,5,npc.Position,Vector.Zero,npc):ToEffect()
				cloud:FollowParent(npc)
				cloud.SpriteOffset = Vector(0, -20) * npc.SpriteScale.X
				cloud.SpriteScale = Vector(0.6,0.6) * npc.SpriteScale.X
				cloud.DepthOffset = 10
				cloud.Color = Color(1,1,1,0.8,0.1,0.1,0.1)
                cloud:GetSprite().PlaybackSpeed = 1.5
				cloud:Update()
		end
    end
    if sprite:IsFinished("Attack01") then
        npc.State = 4
    end
end

function mod:blueBlightedOvumAI(npc)
    --Barely does anything himself but safety checks in case the little ghost dies

	--[[ Velocity would be multiplied by like that amount below if champion version being slower by default was fixed.
	This champion is supposed to be slower, but just to help you with knowing about default speed of normal version anyway, multiply velocity by like 1.0475 for now.]]
	--npc.Velocity = npc.Velocity * 0.95725

    if not npc.Child then
        if npc.State == 13 then
            npc.Velocity = npc.Velocity * 0.1
            local sprite = npc:GetSprite()
            if sprite:IsFinished("TeleportUp") then
                npc.State = 14
            else
                mod:spritePlay(sprite, "TeleportUp")
            end
        elseif npc.State == 14 then
            npc.Velocity = npc.Velocity * 0.1
            local sprite = npc:GetSprite()
            if sprite:IsFinished("TeleportDown") then
                npc.State = 4
            else
                mod:spritePlay(sprite, "TeleportDown")
            end
        end
    end
end

function mod:blueBlightedOvumBabyAI(npc)
    local sprite, d = npc:GetSprite(), mod:GetEntityData(npc)
    local p

    if npc.Parent
    and npc.Parent:ToNPC()
    and npc.Parent:Exists()
    and not npc:ToDelirium()
    and not npc.Parent:ToDelirium() then
        p = npc.Parent:ToNPC()
        p.Child = npc
        --print(p.State, npc.State)
        if (p.State == 4 or p.State == 8) and npc.State == 4 then
            d.teleportCooldown = d.teleportCooldown or 15
            if d.teleportCooldown > 0 and not (npc.SpawnerEntity and npc.SpawnerEntity.Type == EntityType.ENTITY_GEMINI and npc.SpawnerEntity.Variant == 2 and npc.SpawnerEntity.SpawnerType and npc.SpawnerEntity.SpawnerType == EntityType.ENTITY_PLAYER) then -- Delirious
                d.teleportCooldown = d.teleportCooldown - 1
            end
            if npc:GetDropRNG():RandomInt(30) == 1
            and d.teleportCooldown == 0
            and npc.Position:Distance(p.Position) > 8
            and game:GetRoom():GetGridCollisionAtPos(npc.Position) == GridCollisionClass.COLLISION_NONE then
                d.storedParentState = p.State
                p.State = 13
                npc.State = 13
                npc.TargetPosition = Vector(npc.Position.X, npc.Position.Y)
                p.TargetPosition = Vector(p.Position.X, p.Position.Y)
                npc:PlaySound(SoundEffect.SOUND_HELL_PORTAL1, 0.5, 0, false, 1)
            end
        end
        --[[if npc:IsDead() then
            if p.State == 13 or p.State == 14 then
                p.State = 4
            end
        end]]
    end
    if npc.State == 13 then
        local vec = npc.TargetPosition - npc.Position
        npc.Velocity = mod:Lerp(npc.Velocity,vec,0.5)
        if p then
            local vec = p.TargetPosition - p.Position
            p.Velocity = mod:Lerp(p.Velocity,vec,0.5)
        end
        if sprite:IsFinished("TeleportUp") then
            npc.State = 14
            if p then
                local pos = npc.TargetPosition
                npc.Position = p.TargetPosition
                p.Position = pos
            end
        else
            mod:spritePlay(sprite, "TeleportUp")
        end

        if p then
            local ps = p:GetSprite()
            ps:SetFrame("TeleportUp", sprite:GetFrame())
            ps:RemoveOverlay()
        end
    elseif npc.State == 14 then
        npc.Velocity = npc.Velocity * 0.1
        if sprite:IsFinished("TeleportDown") then
            npc.State = 4
            d.teleportCooldown = 30
            if p then
                p.State = d.storedParentState
            end
        else
            mod:spritePlay(sprite, "TeleportDown")
        end
        if p then
            local ps = p:GetSprite()
            ps:SetFrame("TeleportDown", sprite:GetFrame())
        end
    end
end

--Angry Steven (Guillotine MOD Port)
--[[function mod:angryStevenAI(npc)

end
function mod:angryStevenBabyAI(npc)
    local d = mod:GetEntityData(npc)
    if not d.leftParent then
        if npc.Parent then
            if npc.FrameCount > 1 and npc.Parent.Child then
                if (npc.Parent.Type == 79 and npc.Parent.Variant == 1) or npc.Parent.Type == 412 then
                    npc.Parent = nil
                    d.leftParent = true
                end
            end
        end
    end
    npc.Velocity = npc.Velocity * 0.9875
end]]

function mod:checkGemini(npc)
	local var = npc.Variant
	if var == mod.FF.RedBlightedOvum.Var then
		if npc:GetBossColorIdx() == mod.FF.RedBlightedOvum.IDx then
			mod:redBlightedOvumAI(npc)
        elseif npc:GetBossColorIdx() == mod.FF.BlueBlightedOvum.IDx then
			mod:blueBlightedOvumAI(npc)
		end
    elseif var == mod.FF.RedBlightedOvumBaby.Var then
		if npc:GetBossColorIdx() == mod.FF.RedBlightedOvumBaby.IDx then
			mod:redBlightedOvumBabyAI(npc)
        elseif npc:GetBossColorIdx() == mod.FF.BlueBlightedOvumBaby.IDx then
			mod:blueBlightedOvumBabyAI(npc)
		end
    --[[elseif var == mod.FF.AngrySteven.Var then
		if npc:GetBossColorIdx() == mod.FF.AngrySteven.IDx then
			mod:angryStevenAI(npc)
		end
    elseif var == mod.FF.AngryStevenBaby.Var then
		if npc:GetBossColorIdx() == mod.FF.AngryStevenBaby.IDx then
			mod:angryStevenBabyAI(npc)
		end]]
    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkGemini, 79)

--BIG CORN IS BACK IN TOWN (Guillotine MOD Port, but heavily modified)
function mod:CornyTeratomaAI(npc)
	local sprite = npc:GetSprite()
	local d = mod:GetEntityData(npc)
    npc.SplatColor = mod.ColorFadedBrowniePoop --Intentionally not too brown
    npc.Velocity = npc.Velocity * 1.01
    if npc.Velocity:Length() > 9 then
        npc.Velocity = npc.Velocity:Resized(9)
    end
	if not d.init then
		if not (npc:ToDelirium() or (npc.SpawnerEntity and npc.SpawnerEntity:ToDelirium())) then
			if mod:CheckStage("Corpse", {34,43,44}) then
				sprite:ReplaceSpritesheet(0, "gfx/bosses/champions/teratoma/boss_teratoma_corny_corpse.png")
			elseif mod:CheckStage("Dross", {45}) then
				sprite:ReplaceSpritesheet(0, "gfx/bosses/champions/teratoma/boss_teratoma_corny_dross.png")
			end
			sprite:LoadGraphics()
		end
		d.init = true
	end
    if npc:IsDead() then
        if npc.Type == 71 then
            mod:softservesplatter(npc, 0)
        elseif npc.Type == 73 then
            --Remove spiders
            for _, Spider in ipairs(Isaac.FindByType(85, 140, 0, false, false)) do
				if Spider.SpawnerEntity then
					if Spider.SpawnerEntity.InitSeed == npc.InitSeed then
						d.SpawnedSpiders = true
						Spider:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
						Spider:AddEntityFlags(EntityFlag.FLAG_NO_REWARD)
						Spider:Remove()
					end
				end
            end

            --Spawn Dart Flies
			if d.SpawnedSpiders then
				local fly = Isaac.Spawn(256,0,0,Vector(npc.Position.X+5,npc.Position.Y),Vector(1,0),npc)
				fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				local fly = Isaac.Spawn(256,0,0,Vector(npc.Position.X-5,npc.Position.Y),Vector(-1,0),npc)
				fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			end
        end
	end
    local scaleMult = npc.Type - 70
    if npc.FrameCount % (scaleMult * 3) == 0 then
		local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_SLIPPERY_BROWN, 0, npc.Position, Vector.Zero, npc):ToEffect();
		creep:SetTimeout(60)
        creep:Update()
	end
end

local RAGMINI_ORBDIST = 50

function mod:pinkRagMegaAI(npc)
    local sprite = npc:GetSprite()
    local d = mod:GetEntityData(npc)
    if not d.init then
        if LastJudgementSprites then
			if not (npc:ToDelirium() or (npc.SpawnerEntity and npc.SpawnerEntity:ToDelirium()))then
				for i = 0, 7 do
					sprite:ReplaceSpritesheet(0, "gfx/bosses/champions/ragmega/boss_ragmega_pink_lj.png")
				end
				sprite:LoadGraphics()
			end
        end
        d.init = true
        --We found out how to add extra rag mega balls
        --[[local extraBalls = 2
        npc.I1 = 3 + extraBalls
        for i = 1, extraBalls do
            local ball = Isaac.Spawn(409,1,0,npc.Position,Vector.Zero,npc):ToNPC()
            ball.Parent = npc
            ball:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            ball.I1 = 2 + i
            ball:Update()
        end]]
		if not npc:ToDelirium() then
			for i = 120, 360, 120 do
				local mini = Isaac.Spawn(mod.FF.PinkRagMini.ID, mod.FF.PinkRagMini.Var, 0, npc.Position+Vector(0,RAGMINI_ORBDIST):Rotated(i), Vector.Zero, npc):ToNPC()
				mini.Parent = npc
				mod:GetEntityData(mini).OrbitOffset = i
				mini:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				mini.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
				mini.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
				mini.I1 = i/120
                mini:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
				mini:Update()
			end
		end
    end

    d.Orbit = d.Orbit or 0
    d.Orbit = (d.Orbit + 2) % 360

    --print(npc.State, npc.StateFrame, npc.ProjectileCooldown)
    if npc.State == 13 or npc.State == 14 then
        npc.I2 = (npc.I2 + 1) % 2
        if npc.I2 == 1 then
            npc.State = 8
            sprite:Play("Cover", true)
        else
            npc.StateFrame = 0
            npc.State = 3
        end
    elseif npc.State == 3 then
        mod:spritePlay(sprite, "Walk")
        npc.StateFrame = npc.StateFrame + 1
        if npc.StateFrame > 120 then
            npc.State = 4
        end
    end
end

local function ragMiniIdleCoverUp(npc, d)
    npc.I2 = (npc.I2 + 1) % 2
    if npc.I2 == 1 then
        d.state = "Idle"
        npc.StateFrame = 30
    else
        d.state = "Coverup"
    end
end
local function ragMiniSelectAttack(npc, rng)
    local randAttack = rng:RandomInt(5)
    local attack
    if randAttack == 1 and mod.GetEntityCount(EntityType.ENTITY_RAGLING) < 3 then
        attack = "Ragling"
    elseif randAttack <= 3 then
        attack = "Pillar"
    else
        attack = "Shoot"
    end
    return attack
end

function mod:ragMiniUpdate(npc)
    local sprite = npc:GetSprite()
    local d = mod:GetEntityData(npc)
    local target = npc:GetPlayerTarget()
    local rng = npc:GetDropRNG()

    if not d.init then
        d.state = "Cover"
        d.Invulnerable = true
        d.init = true
    else
        npc.StateFrame = npc.StateFrame + 1
    end

    if npc.Parent then
        if npc.Parent:Exists() then
            local orbit = mod:GetEntityData(npc.Parent).Orbit
            local offset = d.OrbitOffset
            if orbit and offset then
                local targPos = npc.Parent.Position + Vector(0,RAGMINI_ORBDIST):Rotated(offset + orbit)
                local vec = targPos - npc.Position
                npc.Velocity = mod:Lerp(npc.Velocity, vec, 0.2)
            end
            npc:SetColor(Color(1,1,1,1,0.2,0,0.2), 2, 1, false, false)
            if npc.Parent.HitPoints < npc.Parent.MaxHitPoints * (npc.I1/4) then
                npc.Parent = nil
                if d.flickerspiritRestoreCollision then
                    d.flickerspiritRestoreCollision = EntityCollisionClass.ENTCOLL_ALL
                else
                    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                end
                npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
                npc:SetColor(Color(1,1,1,1,0.2,0,0.2), 30, 5, true, false)
            end
            if npc.FrameCount % 2 == 0 then
            local smoke = Isaac.Spawn(1000,88,0,npc.Position,npc.Velocity:Rotated(160 + math.random(40)), npc):ToEffect()
            smoke.Color = Color(1,1,1,0.8,0.1,0,0.1)
            smoke.SpriteScale = smoke.SpriteScale
            smoke.SpriteOffset = Vector(0,-22)
            smoke:Update()
            end
        else
            npc.Parent = nil
            if d.flickerspiritRestoreCollision then
                d.flickerspiritRestoreCollision = EntityCollisionClass.ENTCOLL_ALL
            else
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            end
            npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
        end
    else
        local targvel = (target.Position - npc.Position):Resized(7)
        npc.Velocity = mod:Lerp(npc.Velocity, targvel, 0.03)
        npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
        if npc.Velocity:Length() > 12 then
            npc.Velocity = npc.Velocity:Resized(12)
        end
    end

    if sprite:IsEventTriggered("Cover") then
        d.Invulnerable = true
    elseif sprite:IsEventTriggered("Uncover") then
        d.Invulnerable = false
    end

    if d.Invulnerable or npc.Parent then
        npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS)
    else
        npc:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS)
    end

    if d.state == "Cover" then
        mod:spritePlay(sprite, "Covered")
        if npc.StateFrame > 30 and rng:RandomInt(30) == 1 then
            d.attack = ragMiniSelectAttack(npc, rng)
            d.state = "Uncover"
        end
    elseif d.state == "Coverup" then
        if sprite:IsFinished("Cover") then
            d.state = "Cover"
        else
            mod:spritePlay(sprite, "Cover")
        end
    elseif d.state == "Uncover" then
        if sprite:IsFinished("Uncover") then
            if d.attack then
                d.state = d.attack
                d.attack = nil
            else
                d.state = "Idle"
            end
        else
            mod:spritePlay(sprite, "Uncover")
        end
    elseif d.state == "Idle" then
        mod:spritePlay(sprite, "Walk")
        if npc.StateFrame > 30 and rng:RandomInt(30) == 1 then
            d.state = ragMiniSelectAttack(npc, rng)
        end
    elseif d.state == "Shoot" then
        if sprite:IsFinished("Attack02") then
            ragMiniIdleCoverUp(npc, d)
        elseif sprite:IsEventTriggered("Shoot") then
            local params = ProjectileParams()
            params.BulletFlags = params.BulletFlags | ProjectileFlags.SMART
            npc:FireProjectiles(npc.Position,(target.Position - npc.Position):Resized(9),0,params)
            npc:PlaySound(SoundEffect.SOUND_LITTLE_SPIT)
        else
            mod:spritePlay(sprite, "Attack02")
        end
    elseif d.state == "Pillar" then
        if sprite:IsFinished("Attack03") then
            d.state = "Coverup"
        elseif sprite:IsEventTriggered("Shoot") then
            npc:PlaySound(SoundEffect.SOUND_BIGHORN_SPIT, 0.7, 0, false, 1.5)
            local targVec = (target.Position - npc.Position):Resized(7)
            local pillar = Isaac.Spawn(EntityType.ENTITY_RAG_MEGA, 2, 0, npc.Position, targVec, npc):ToNPC()
            pillar:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            pillar:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH | EntityFlag.FLAG_NO_FLASH_ON_DAMAGE | EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_REWARD)
            pillar.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
            pillar.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            pillar.Mass = 1
            pillar:SetShadowSize(0)
            local ps = pillar:GetSprite()
            ps:Load("gfx/bosses/champions/ragmega/ragmini.anm2", true)
            ps:Play("Rebirth Pillar", true)
            pillar:Update()
        else
            mod:spritePlay(sprite, "Attack03")
        end
    elseif d.state == "Ragling" then
        if sprite:IsFinished("Attack01") then
            d.state = "Coverup"
        elseif sprite:IsEventTriggered("Shoot") then
            npc:PlaySound(SoundEffect.SOUND_BOSS_SPIT_BLOB_BARF, 1, 0, false, 2)
            local targVec = (target.Position - npc.Position):Resized(10)
            local ragling = Isaac.Spawn(EntityType.ENTITY_RAGLING, 1, 0, npc.Position, targVec, npc):ToNPC()
            ragling:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            ragling.Parent = npc
            ragling.Size = ragling.Size * 0.75
            ragling.Scale = ragling.Scale * 0.75
            ragling.MaxHitPoints = ragling.MaxHitPoints / 3
            ragling.HitPoints = ragling.MaxHitPoints
            if npc.Variant == mod.FF.PinkRagMini.Var then
                local ragSprite = ragling:GetSprite()
				local ragData = mod:GetEntityData(ragling)
                ragSprite:ReplaceSpritesheet(0, "gfx/bosses/champions/ragmega/pink_ragling.png")
                ragSprite:ReplaceSpritesheet(1, "gfx/bosses/champions/ragmega/pink_ragling.png")
		        ragSprite:LoadGraphics()
				mod:lastJudgementAutoResprite(ragling, ragData, ragSprite)
            end
            --This means if you exit/continue they visually change but I quite literally do not care
            if mod:isFriend(npc) then
                ragling.Variant = 0
            end
            ragling:Update()
        else
            mod:spritePlay(sprite, "Attack01")
        end
    end
end

function mod:ragMiniHurt(npc)
    local d = mod:GetEntityData(npc)
    if d.Invulnerable or npc.Parent then
        return false
    end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
	local var = npc.Variant
	if var == mod.FF.PinkRagMega.Var then
		if npc:GetBossColorIdx() == mod.FF.PinkRagMega.IDx then
			mod:pinkRagMegaAI(npc)
		end
    elseif var == 1 then
        if npc.Parent and npc.Parent:ToNPC():GetBossColorIdx() == mod.FF.PinkRagMega.IDx and not npc.Parent:ToDelirium() then
            npc:Remove()
        end
    end
end, EntityType.ENTITY_RAG_MEGA)

local function trySpawnCage(npc, giveReturn)
    local numCages = Isaac.CountEntities(nil, mod.FF.LilCage.ID, mod.FF.LilCage.Var)
    if numCages < 3 and not game:IsErased(mod.FF.LilCage.ID, mod.FF.LilCage.Var, -1) then
        if giveReturn then
            return true
        else
            npc.State = 15
        end
    end
end

function mod:blackSisterVisInit(npc)
    if npc.SpawnerEntity and (npc.SpawnerEntity.Type == EntityType.ENTITY_SISTERS_VIS or npc.SpawnerEntity.Type == EntityType.ENTITY_DELIRIUM) then
		if npc.SpawnerEntity.SpawnerType and npc.SpawnerEntity.SpawnerType == EntityType.ENTITY_PLAYER then -- Delirious
			npc.Scale = npc.SpawnerEntity:ToNPC().Scale
			mod:GetEntityData(npc).FromDelirious = true
        else
            --Hacky little meat cleaver fix
            if npc.SpawnerEntity and (npc.SpawnerEntity:ToDelirium() or not mod:GetEntityData(npc.SpawnerEntity).Black_SisterVis_Init) then
                npc:Remove()
            end
		end
    end
end

function mod:blackSisterVisAI(npc)
    local sprite = npc:GetSprite()
    local d = mod:GetEntityData(npc)

	if not d.Black_SisterVis_Init then
		if npc:ToDelirium() or (npc.SpawnerEntity and npc.SpawnerEntity:ToDelirium()) then
			sprite:Load("gfx/bosses/champions/sistersvis/black_sistersvis.anm2", true)
			npc:ReplaceSpritesheet(0, "gfx/bosses/afterbirthplus/deliriumforms/afterbirthplus/boss_sistersvis.png", true)
			npc:ReplaceSpritesheet(5, "gfx/bosses/afterbirthplus/deliriumforms/afterbirthplus/boss_sistersvis.png", true)
		end
		d.Black_SisterVis_Init = true
        if npc.MaxHitPoints <= 180 then
            --Probably meat cleaver, might be some cases it acts differently but MEH!
            d.isProbablyMeatCleavered = true
        end
	end

	if d.FromDelirious then
		npc.SubType = 0
	else
        if npc:ToDelirium() then --The reason this code is like this is because Delirium crashes the game when transforming into this champion.
            if npc.HitPoints > (npc.MaxHitPoints / 2) and npc.FrameCount > 1 then
                npc.Child = npc
            else
                npc.Child = nil
            end
        else
            if npc.HitPoints > (npc.MaxHitPoints / 2) then
                npc.Child = npc
            else
                npc.Child = nil
            end
        end

        if npc.State == 3 then
            local numCages = Isaac.CountEntities(nil, mod.FF.LilCage.ID, mod.FF.LilCage.Var)
            if d.isProbablyMeatCleavered and math.random(30) == 1 then
                npc.State = 8
            elseif npc.StateFrame > 15 + numCages * 10 then
                trySpawnCage(npc)
            end
        elseif npc.State == 9 and npc.Child then
            npc.State = 3
        elseif npc.State == 12 or npc.State == 14 then
            if trySpawnCage(npc, true) then
                npc.State = 15
            else
                npc.State = 3
            end
        elseif npc.State == 15 then
            if sprite:IsFinished("AttackCage") then
                npc.State = 3
                npc.StateFrame = 0
            elseif sprite:IsEventTriggered("CageUnleash") then
                npc:PlaySound(SoundEffect.SOUND_BOSS_SPIT_BLOB_BARF)
                for i = -1, 1, 2 do
                    local lilCage = Isaac.Spawn(mod.FF.LilCage.ID, mod.FF.LilCage.Var, 0, npc.Position + Vector(i,1), Vector(i, 1), npc):ToNPC()
                    lilCage:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    lilCage.State = 8
                    lilCage.I1 = 1
					mod:GetEntityData(lilCage).EnrageOnSpawnersDeath = true
                    --I realise this bloodexplodes before I fix the splat color but I like it this way, it's like her guts spreading out instead of the lil cages
                    lilCage:BloodExplode()
                    lilCage:Update()
                end
                local poof = Isaac.Spawn(1000, 16, 0, npc.Position + Vector(0,1), Vector.Zero, npc):ToEffect()
                poof.Color = Color(1,1,1,0.5)
                poof.SpriteOffset = Vector(0,-25)
            else
                mod:spritePlay(sprite, "AttackCage")
            end
        end
        if npc.State == 8 then
            mod:EnableManualCallback(ModCallbacks.MC_PRE_EFFECT_RENDER, mod.blackSisterVisCreepInitRemoval)
            if npc.I1 == 1 and npc.FrameCount % 3 == 1 then
                local creep = Isaac.Spawn(1000, EffectVariant.CREEP_BLACK, 0, npc.Position, Vector.Zero, npc):ToEffect()
                creep.Size = 3
                creep.Scale = 1.5
                creep.LifeSpan = 60
                creep:Update()

                local bloodSplat = Isaac.Spawn(1000, EffectVariant.BLOOD_SPLAT, 0, npc.Position + (RandomVector()*math.random(10)), Vector.Zero, npc)
                bloodSplat.Color = Color(0.1,0.1,0.1,1)
                bloodSplat:Update()
            end
        end
    end
end

function mod:blackSisterVisCreepInitRemoval(creep)
    if creep.SpawnerEntity and creep.SpawnerEntity.Type == mod.FF.BlackSisterVis.ID and creep.SpawnerEntity.Variant == mod.FF.BlackSisterVis.Var and creep.SpawnerEntity.SubType == mod.FF.BlackSisterVis.IDx+1 then
        creep.Color = Color(0,0,0,0)
        creep:Remove()
    end
end

mod:AddManualCallback(ModCallbacks.MC_PRE_EFFECT_RENDER, mod.blackSisterVisCreepInitRemoval, EffectVariant.CREEP_GREEN)
mod:AddManualCallback(ModCallbacks.MC_PRE_EFFECT_RENDER, mod.blackSisterVisCreepInitRemoval, EffectVariant.CREEP_SLIPPERY_BROWN)
mod:DisableManualCallback(ModCallbacks.MC_PRE_EFFECT_RENDER, mod.blackSisterVisCreepInitRemoval)

local lilCageSplatColor = Color(10/255,80/255,10/255)
lilCageSplatColor:SetOffset(100/255,100/255,80/255)

function mod:lilCageAI(npc)
    npc.SplatColor = lilCageSplatColor
    local d = mod:GetEntityData(npc)
    if not d.init then
        npc.Scale = npc.Scale * 0.5
		d.enraged = false
        d.init = true
    end
    if npc.State == 3 or npc.State == 13 then
        npc.State = 8
        npc.I1 = 0
        d.speedCap = nil
    end
    if npc.I1 == 1 then
        --print(npc.StateFrame)
        if npc.StateFrame > 100 then
            if npc:GetDropRNG():RandomInt(25) == 0 then
                npc.I1 = 2
            end
        end
    end
    if npc.SpawnerEntity then
        if npc.SpawnerType == EntityType.ENTITY_SISTERS_VIS and npc.SpawnerEntity.HitPoints <= npc.SpawnerEntity.MaxHitPoints / 2 then
            d.enraged = true
		else
			if d.enraged then
				npc.Color = Color(1,1,1,1)
				d.enraged = false
			end
        end
	elseif d.EnrageOnSpawnersDeath then
		d.enraged = true
	else
		if d.enraged then
			npc.Color = Color(1,1,1,1)
			d.enraged = false
		end
    end
	d.startCap = 7
    if d.enraged then
        d.startCap = 10
        npc.Color = Color(0.5,0.2,0.2,1)
    end
    d.speedCap = d.speedCap or npc:GetDropRNG():RandomInt(6)
    local speedCap = d.startCap + d.speedCap
    if npc.Velocity:Length() > speedCap then
        npc.Velocity = npc.Velocity:Resized(speedCap)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
	local var = npc.Variant
	if var == mod.FF.BlackSisterVis.Var then
		if npc:GetBossColorIdx() == mod.FF.BlackSisterVis.IDx then
			mod:blackSisterVisInit(npc)
		end
    end
end, EntityType.ENTITY_SISTERS_VIS)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
	local var = npc.Variant
	if var == mod.FF.BlackSisterVis.Var then
		if npc:GetBossColorIdx() == mod.FF.BlackSisterVis.IDx then
			mod:blackSisterVisAI(npc)
		end
    end
end, EntityType.ENTITY_SISTERS_VIS)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
	local var = npc.Variant
	if var == mod.FF.LilCage.Var then
		mod:lilCageAI(npc)
    end
end, EntityType.ENTITY_CAGE)

function mod:ShootBigHornMiniTrollBomb(npc, hornNum, shotNum)
    local pTarget = npc:GetPlayerTarget().Position
    local vel = (pTarget - npc.Position):Normalized()
    local bombVar = 3
    if hornNum == 2 and shotNum == 3 then
        bombVar = 4
    end
    local tBomb = Isaac.Spawn(4, bombVar, 0, npc.Position + vel*20, vel*15, npc):ToBomb()
    tBomb:SetFallSpeed(-3)
    tBomb.PositionOffset = Vector(0,-40)
    if hornNum == 1 then
        mod:GetEntityData(tBomb).red_champ_variant = 3
    elseif hornNum == 3 then
        mod:GetEntityData(tBomb).red_champ_variant = 2
        mod:GetEntityData(tBomb).LastPos = npc.Position
    end
    tBomb:SetSize(12, Vector.One, 12)
    tBomb.RadiusMultiplier = 0.5
    tBomb.ExplosionDamage = tBomb.ExplosionDamage * 0.5

    local bSprite = tBomb:GetSprite()
    if bombVar == 4 then
        bSprite:Load("gfx/bosses/champions/littlehorn/bomb_small2.anm2", false)
    else
        bSprite:Load("gfx/bosses/champions/littlehorn/bomb_small.anm2", false)
    end
    if hornNum == 1 then
        bSprite:ReplaceSpritesheet(0, "gfx/bosses/champions/littlehorn/boss_littlehorn_riddy.png")
        bSprite:ReplaceSpritesheet(2, "gfx/bosses/champions/littlehorn/boss_littlehorn_riddy.png")
    elseif hornNum == 2 then
        bSprite:ReplaceSpritesheet(0, "gfx/bosses/champions/littlehorn/boss_littlehorn_reddy.png")
    elseif hornNum == 3 then
        bSprite:ReplaceSpritesheet(0, "gfx/bosses/champions/littlehorn/boss_littlehorn_roddy.png")
    end
    bSprite:LoadGraphics()
    bSprite:Play("Appear")
    bSprite:SetFrame(6)
end

function mod:redBigHornAI(npc)
    local d, sprite = mod:GetEntityData(npc), npc:GetSprite()
    if sprite:IsEventTriggered("Shoot") then
        local vec = (npc:GetPlayerTarget().Position - npc.Position):Resized(15)
        local bomb = Isaac.Spawn(mod.FF.BigHornBigBomb.ID, mod.FF.BigHornBigBomb.Var, 0, npc.Position, vec, npc):ToNPC()
        bomb.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        bomb:Update()
    end
end
--Big Horn Hand Subs/States
--5, Close
--1/2, 8, Slap
--3/4, 9, One bomb
--6, 10, Triple bomb
--7, 11, Little Horn, spawns little horn if killed during
function mod:redBigHornHandAI(npc)
    local d, sprite = mod:GetEntityData(npc), npc:GetSprite()
    if not d.init then
        sprite:Load("gfx/bosses/champions/bighorn/red_bighorn.anm2", true)
		if npc.SpawnerEntity:ToDelirium() then
			npc:ReplaceSpritesheet(0, "gfx/bosses/afterbirthplus/deliriumforms/afterbirthplus/boss_bighorn.png", true)
		end
        sprite:Play("SmallHoleOpen", true)
		d.HandCollision = false
        d.init = true
        npc:UpdateDirtColor(true)
    end
    --print(npc.SubType, npc.State, npc.StateFrame, sprite:GetAnimation(), npc:IsInvincible())
    if npc.State == 8 or npc.State == 11 then
        npc.State = 13
        npc.SubType = 0
    end
    if npc.State == 13 then
        if sprite:IsFinished("SmallHoleOpen") then
            local nextLittleHorn
            if npc.Parent then
                local pd = mod:GetEntityData(npc.Parent)
                pd.NextLittleHorn = pd.NextLittleHorn or 0
                pd.NextLittleHorn = (pd.NextLittleHorn + 1) % 3
                nextLittleHorn = pd.NextLittleHorn + 1 --Starts with 2
            end
            d.LittleHorn = nextLittleHorn or npc:GetDropRNG():RandomInt(3) + 1
        end
        if d.LittleHorn then
            local anim = "HandLittleHorn"
            if d.LittleHorn > 1 then
                anim = anim .. d.LittleHorn
            end
            if sprite:IsFinished(anim) then
                npc.State = 5
                sprite:Play("SmallHoleClose", true)
            elseif sprite:IsEventTriggered("Stop") then
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            elseif sprite:IsEventTriggered("Bomb") then
                d.fires = d.fires or 0
                npc:PlaySound(SoundEffect.SOUND_LITTLE_HORN_COUGH, 1, 0, false, 1 + (d.fires/10))
                d.fires = d.fires + 1
                mod:ShootBigHornMiniTrollBomb(npc, d.LittleHorn, d.fires)
            else
				if not d.HandCollision then
					npc:SetInvincible(false)
					npc.CollisionDamage = 1
					npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
					d.HandCollision = true
				end
                mod:spritePlay(sprite, anim)
            end
            if npc.SpawnerEntity and npc.SpawnerEntity:IsDead() and not d.SpawnedLittleHorn then
                d.SpawnedLittleHorn = true
                mod.BigHornAsksYouVeryNicelyNotToTriplicate = true
                local littleHorn = Isaac.Spawn(EntityType.ENTITY_LITTLE_HORN,0,mod.FF.RedLittleHorn.IDx+1,npc.Position,Vector.Zero,nil):ToNPC()
                mod.BigHornAsksYouVeryNicelyNotToTriplicate = false
                if d.LittleHorn == 1 then
                    mod:GetEntityData(littleHorn).red_champ_variant = 3
                    for i=0, 4 do
                        littleHorn:GetSprite():ReplaceSpritesheet(i, "gfx/bosses/champions/littlehorn/boss_littlehorn_riddy.png")
                    end
                elseif d.LittleHorn == 2 then
                    mod:GetEntityData(littleHorn).red_champ_variant = 1

                elseif d.LittleHorn == 3 then
                    mod:GetEntityData(littleHorn).red_champ_variant = 2
                    for i=0, 4 do
                        littleHorn:GetSprite():ReplaceSpritesheet(i, "gfx/bosses/champions/littlehorn/boss_littlehorn_roddy.png")
                    end
                end
                littleHorn:GetSprite():LoadGraphics()
                littleHorn:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                littleHorn.MaxHitPoints = littleHorn.MaxHitPoints * 0.25
                littleHorn.HitPoints = littleHorn.MaxHitPoints
                littleHorn:Update()
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc) -- Castrate Red Big Horn's Dark Balls
	if npc.Variant == 1 then --dark ball
        if npc.SpawnerEntity
        and npc.SpawnerEntity.Type == mod.FF.RedBigHorn.ID
        and npc.SpawnerEntity:ToNPC():GetBossColorIdx() == mod.FF.RedBigHorn.IDx then
            npc:Remove()
        end
    end
end, EntityType.ENTITY_LITTLE_HORN)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
	local var = npc.Variant
	if var == mod.FF.RedBigHorn.Var then
		if npc:GetBossColorIdx() == mod.FF.RedBigHorn.IDx then
			mod:redBigHornAI(npc)
		end
    elseif var == 1 then
        if npc.SpawnerEntity
        and npc.SpawnerEntity:ToNPC()
        and npc.SpawnerEntity:ToNPC():GetBossColorIdx() == mod.FF.RedBigHorn.IDx then
            mod:redBigHornHandAI(npc)
        end
    end
end, EntityType.ENTITY_BIG_HORN)

function mod:bigHornBigBombBigAssBigAI(npc)
    local sprite, d = npc:GetSprite(), mod:GetEntityData(npc)
    if not d.init then
        d.init = true
        d.state = "Pulse"
        npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    end
    --[[if sprite:IsEventTriggered("Drop") then
        print("hi")
    end]]
    d.FallSpeed = d.FallSpeed or -15
    local posOffset = npc.PositionOffset.Y + d.FallSpeed
    if posOffset > 0 then
        d.FallSpeed = d.FallSpeed * -0.25
    end
    posOffset = npc.PositionOffset.Y + d.FallSpeed
    npc.PositionOffset = Vector(0, math.min(0, posOffset))
    d.FallSpeed = d.FallSpeed + 2
    if d.state == "Pulse" then
        if sprite:IsFinished("Pulse") then
            d.state = "Grow"
        else
            mod:spritePlay(sprite, "Pulse")
        end
        local frame = sprite:GetFrame()
        if frame >= 50 then
            if frame % 3 == 1 then
                npc:PlaySound(SoundEffect.SOUND_BEEP, 1, 0, false, 0.75)
            end
        elseif frame >= 25 then
            if frame % 6 == 1 then
                npc:PlaySound(SoundEffect.SOUND_BEEP, 1, 0, false, 0.75)
            end
        else
            if frame % 9 == 1 then
                npc:PlaySound(SoundEffect.SOUND_BEEP, 1, 0, false, 0.75)
            end
        end
    elseif d.state == "Grow" then
        if sprite:IsFinished("Grow") then
            d.state = "BigPulse"
        elseif sprite:GetFrame() == 1 then
            npc:PlaySound(SoundEffect.SOUND_THUMBSUP, 1, 0, false, 0.9)
        elseif sprite:GetFrame() == 5 then
            npc:PlaySound(SoundEffect.SOUND_THUMBSUP, 1, 0, false, 1)
        elseif sprite:GetFrame() == 9 then
            npc:PlaySound(SoundEffect.SOUND_THUMBSUP, 1, 0, false, 1.1)
        else
            mod:spritePlay(sprite, "Grow")
        end
    elseif d.state == "BigPulse" then
        if sprite:IsFinished("BigPulseShort") then
            --[[local bomb = Isaac.Spawn(4, 17, BombSubType.BOMB_GIGA, npc.Position, Vector.Zero, npc):ToBomb()
            bomb:SetExplosionCountdown(0)
            bomb:Update()]]
            game:BombExplosionEffects(npc.Position, 2, TearFlags.TEAR_NORMAL, mod.ColorNormal, npc, 2)
            local rng = npc:GetDropRNG()
            local numBombs = 4
            local ang = 360/numBombs
            local startRot = rng:RandomInt(360)
            for i = 1, numBombs do
                local bomb = Isaac.Spawn(4,3,0,npc.Position,Vector(5 + rng:RandomInt(5),0):Rotated(startRot + (ang * i) + rng:RandomInt(30)),npc):ToBomb()
                bomb:SetFallAcceleration(1)
                bomb:SetFallSpeed(-10)
                bomb:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                bomb.ExplosionDamage = 10
                bomb:Update()
            end
            npc:Remove()
        else
            mod:spritePlay(sprite, "BigPulseShort")
        end
        local frame = sprite:GetFrame()
        if frame >= 24 then
            if frame % 2 == 1 then
                npc:PlaySound(SoundEffect.SOUND_BEEP, 1, 0, false, 0.5)
            end
        else
            if frame % 4 == 1 then
                npc:PlaySound(SoundEffect.SOUND_BEEP, 1, 0, false, 0.5)
            end
        end
    end

    if d.state == "Pulse" then
        local vec = (npc:GetPlayerTarget().Position - npc.Position):Resized(7)
        npc.Velocity = mod:Lerp(npc.Velocity, vec, 0.2)
    else
        npc.Velocity = npc.Velocity * 0.9
    end
end

--Green Clutch
function mod:greenClutchAI(npc)
    local d = mod:GetEntityData(npc)
	local room = game:GetRoom()
    npc.SplatColor = Color(1,1,1,0.5,-0.25,0.5,0)
    --print(npc.State, npc.I1, npc.I2, npc.StateFrame)
    local auraRadius = 80
    if npc.State == 6 then --Inside guy
        auraRadius = 140
    elseif npc.State == 8 or npc.State == 9 then --Charging
        local speedLimit = 12
        if npc.Velocity:Length() > speedLimit then
            npc.Velocity = npc.Velocity:Resized(speedLimit)
        end
    elseif npc.State == 4 then -- waiting to move
        npc.Velocity = npc.Velocity * 0.8
        d.WaitToMove = d.WaitToMove or 0
        d.WaitToMove = d.WaitToMove + 1
        if d.WaitToMove < 25 then
            npc.StateFrame = 0
        end
        if d.DidAttackBefore then
            auraRadius = 280
        end
    elseif npc.State == 10 then
        d.WaitToMove = nil
        d.DidAttackBefore = true
        auraRadius = 40 + 40 * npc.StateFrame
    end
    mod:SetRadioactiveAura(npc, auraRadius)
    if mod.isBackdrop("Ashpit", true) then
        if room:GetFrameCount() <= 1 and not d.setBackdrop then
            StageAPI.ChangeRoomGfx(mod.IrradiatedAshpitFullAshBackdrop)
            d.setBackdrop = true
        end
    end
end

mod:AddEntityCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, EntityType.ENTITY_CLUTCH, 0, mod.FF.GreenClutch.IDx+1,
function(_, proj)
    if proj.SpawnerType and proj.SpawnerType == EntityType.ENTITY_CLUTCH then
        if proj.SpawnerEntity and proj.SpawnerEntity:ToNPC():GetBossColorIdx() == mod.FF.GreenClutch.IDx then
            local spawner = proj.SpawnerEntity
            local d = mod:GetEntityData(proj)
            proj.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
            if not d.clutchAffected then
                d.clutchAffected = true
                if not LastJudgementSprites then
                    local sprite = proj:GetSprite()
                    sprite:Load("gfx/bosses/champions/clutch/last_judgement_fire.anm2", true)
                    sprite:Play("Flickering", true)
                end
                proj.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                proj.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                proj.Color = Color(1,1,1,0.75,-1,0.2,-1)
                --proj.Position = spawner.Position + Vector(0,300):Rotated(math.random(360))
                proj.Position = proj.Position + proj.Velocity*25
                proj.Velocity = (spawner.Position - proj.Position):Resized(0.01)
                proj.FallingAccel = -0.1
                d.projType = "excluder"
                d.excluder = spawner
                proj.SpriteScale = Vector.Zero
                d.maxScale = mod:RandomInt(80,150,proj:GetDropRNG())/100
                mod:excluderProj(proj, d)
            end
            --proj.SpriteOffset = Vector(0,5)
            if proj.Velocity:Length() >= 0.1 then
                proj.SpriteRotation = proj.Velocity:GetAngleDegrees() - 90
            else
                proj.SpriteRotation = (spawner.Position - proj.Position):GetAngleDegrees() - 90
            end
        end
    end
end)
mod:AddEntityCallback(ModCallbacks.MC_POST_PROJECTILE_INIT, EntityType.ENTITY_CLUTCH, 0, mod.FF.GreenClutch.IDx+1,
function(_, proj)
    if proj.SpawnerType and proj.SpawnerType == EntityType.ENTITY_CLUTCH then
        if proj.SpawnerEntity and proj.SpawnerEntity:ToNPC():GetBossColorIdx() == mod.FF.GreenClutch.IDx then
            proj.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
        end
    end
end)
mod:AddEntityCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, EntityType.ENTITY_CLUTCH, 0, mod.FF.GreenClutch.IDx+1,
function(_, eff)
    if eff.Parent
    and eff.Parent.Type == EntityType.ENTITY_CLUTCH
    and eff.Parent:ToNPC():GetBossColorIdx() == mod.FF.GreenClutch.IDx then
        eff.Color = Color(0.3,0.7,0.3,eff.Color.A)
    end
end, EffectVariant.KINETI_BEAM)

--[[function mod:greenClutchBoneOrbitals(npc)
--print(npc.I1, npc.I2, npc.V1, npc.V2)
end]]

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
	if npc.Variant == 0 and npc:GetBossColorIdx() == mod.FF.GreenClutch.IDx then
        mod:greenClutchAI(npc)
    --[[elseif npc.Variant == 1 then
        if npc.SpawnerEntity
        and npc.SpawnerEntity.Type == EntityType.ENTITY_CLUTCH
        and npc.SpawnerEntity:ToNPC():GetBossColorIdx() == mod.FF.GreenClutch.IDx then
            mod:greenClutchBoneOrbitals(npc)
        end]]
        --Didn't do anything with these in the end, so commenting out
    end
end, EntityType.ENTITY_CLUTCH)

--Make Clutch trail color match head color
mod:AddEntityCallback(ModCallbacks.MC_PRE_NPC_RENDER, EntityType.ENTITY_CLUTCH, 0, mod.FF.GreenClutch.IDx+1, function(_, npc)
    if not LastJudgementSprites then
        if npc.Variant == 0 and npc:GetBossColorIdx() == mod.FF.GreenClutch.IDx then
            local sprite = npc:GetSprite()
            for i = 1, 2 do
                if sprite:GetLayer(i):GetColor().A > 0 then
                    sprite:GetLayer(i):SetColor(Color.Default)
                end
            end
        end
    end
end, EntityType.ENTITY_CLUTCH)

mod:AddEntityCallback(ModCallbacks.MC_NPC_UPDATE, EntityType.ENTITY_CLUTCH, 0, mod.FF.GreenClutch.IDx+1, function(_, npc)
    --print(npc.Parent, npc.Child)
    local d = mod:GetEntityData(npc)
    if npc.FrameCount > 0 then
        if not d.BecameGreenClutch then
            if npc.Parent then
                if npc.Parent.Type == EntityType.ENTITY_CLUTCH and npc.Parent.SubType == mod.FF.GreenClutch.IDx+1 then
                    d.BecameGreenClutch = true
                    d.ClutchType = "Green"
                    local sprite = npc:GetSprite()
                    sprite:Load("gfx/bosses/champions/clutch/green_clickety_clack.anm2", true)
                    if npc:IsChampion() and not mod.SpritesheetlessChamps[npc:GetChampionColorIdx()] then
                        local layer = sprite:GetLayer(0)
						mod:ReplaceEnemySpritesheet(npc, "gfx/bosses/champions/clutch/clickety_clack_body_green", 0)
						layer:SetRenderFlags(layer:GetRenderFlags() | AnimRenderFlags.COLOROFFSET_CHAMPION)

                        layer = sprite:GetLayer(1)
						mod:ReplaceEnemySpritesheet(npc, "gfx/bosses/champions/clutch/clickety_clack_green", 1)
						layer:SetRenderFlags(layer:GetRenderFlags() | AnimRenderFlags.COLOROFFSET_CHAMPION)

                        sprite:LoadGraphics()
                    end
                    sprite:Play("WalkDown", true)
                end
            end
        end
    end
    if d.ClutchType == "Green" then
        if npc.State == 16 then --Dead
            --npc.ProjectileCooldown
            local isIrradiated = mod:IsEnemyExposedToRadiation(npc, true, d)
            local sprite = npc:GetSprite()
            local layer = sprite:GetLayer("fire")
            if layer then
                local targVec = Vector(0.5,0.5)
                if isIrradiated then
                    targVec = Vector(1,1)
                end
                local size = mod:Lerp(layer:GetSize(), targVec, 0.1)
                layer:SetSize(size)
            end
            if isIrradiated then
                if npc.ProjectileCooldown > 0 then
                    npc.ProjectileCooldown = npc.ProjectileCooldown - 1
                end
            else
                if npc.ProjectileCooldown > 0 then
                    if npc.FrameCount % 2 == 1 then
                        npc.ProjectileCooldown = npc.ProjectileCooldown + 1
                    end
                end
            end
        end
    end
end, EntityType.ENTITY_CLICKETY_CLACK)

mod:AddEntityCallback(ModCallbacks.MC_NPC_UPDATE, EntityType.ENTITY_CLUTCH, 0, mod.FF.GreenClutch.IDx+1, function(_, npc)
    if npc.Variant == 13 then --Movable purple fireplace
        if npc.SpawnerEntity
        and npc.SpawnerEntity.Type == EntityType.ENTITY_CLUTCH
        and npc.SpawnerEntity:ToNPC():GetBossColorIdx() == mod.FF.GreenClutch.IDx then
            local jet = Isaac.Spawn(1000, EffectVariant.FIRE_JET, mod.FF.RadioactiveFireJet.Sub, npc.Position, Vector.Zero, npc)
            npc:Remove()
        end
    end
end, EntityType.ENTITY_FIREPLACE)

local function findNearbyGreenClicketyClack(eff)
    local clicketies = Isaac.FindInRadius(eff.Position, 0.1, EntityPartition.ENEMY)
    for _, ent in pairs(clicketies) do
        if ent.Type == EntityType.ENTITY_CLICKETY_CLACK then
            if mod:GetEntityData(ent).ClutchType then
                if ent.Position:Distance(eff.Position) < 0.1 then
                    return true
                end
            end
        end
    end
end

--Override some effect entity stuff
--DUDE HE DOESN'T GIVE ANY OF THEM SPAWNER ENTITIES
--So don't mind my DUMB code that might break occasionally
mod:AddEntityCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, EntityType.ENTITY_CLUTCH, 0, mod.FF.GreenClutch.IDx+1, function(_, eff)
    if eff.FrameCount <= 1 then
        if findNearbyGreenClicketyClack(eff) then
            eff.Color = Color(0.3,0.7,0.3,1)
        end
    end
end, EffectVariant.WATER_RIPPLE)
mod:AddEntityCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, EntityType.ENTITY_CLUTCH, 0, mod.FF.GreenClutch.IDx+1, function(_, eff)
    if eff.FrameCount <= 1 and eff.SubType == 5 then
        if findNearbyGreenClicketyClack(eff) then
            eff.Color = Color(1,1,1,0.5,-0.25,0.5,0)
        end
    end
end, EffectVariant.BLOOD_EXPLOSION)
mod:AddEntityCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, EntityType.ENTITY_CLUTCH, 0, mod.FF.GreenClutch.IDx+1, function(_, eff)
    if eff.FrameCount <= 1 and eff.SubType == 3 then
        local clutches = Isaac.FindInRadius(eff.Position, 0.1, EntityPartition.ENEMY)
        for _, ent in pairs(clutches) do
            if ent.Type == EntityType.ENTITY_CLUTCH then
                if ent:ToNPC():GetBossColorIdx() == mod.FF.GreenClutch.IDx then
                    eff.Color = Color(1,1,1,0.5,-0.25,0.5,0)
                    eff.SubType = 2
                end
            end
        end
    end
    if mod:GetEntityData(eff).Clutching then
        local poofs = Isaac.FindByType(1000, EffectVariant.POOF01, -1)
        print(#poofs)
    end
end, EffectVariant.ENEMY_GHOST)

--Actually made by Guillotine, but setting them up here for 'em!
function mod:ChampionGurgling(npc)
	local sprite = npc:GetSprite()
	local d = mod:GetEntityData(npc)
	if not d.init then
		if npc:ToDelirium() or (npc.SpawnerEntity and npc.SpawnerEntity:ToDelirium()) then
			sprite:Load("gfx/bosses/champions/gurgling/mushroom_gurgling.anm2", true)
			npc:ReplaceSpritesheet(0, "gfx/bosses/afterbirthplus/deliriumforms/rebirth/monster_237_gurgling hands.png", true)
			npc:ReplaceSpritesheet(1, "gfx/bosses/afterbirthplus/deliriumforms/rebirth/monster_237_gurgling.png", true)
		end
		d.init = true
	end

	if sprite:IsEventTriggered("Spawn") then
		local rng = npc:GetDropRNG()
		local ShiitakeCount = #Isaac.FindByType(mod.FF.Shiitake.ID, mod.FF.Shiitake.Var, -1, false, false) + #Isaac.FindByType(mod.FF.FloatingSpore.ID, mod.FF.FloatingSpore.Var, -1, false, false)
		if rng:RandomFloat() <= 0.50 and ShiitakeCount < 4 then
			npc:PlaySound(SoundEffect.SOUND_SUMMONSOUND, 0.6, 0, false, 1)
			Isaac.Spawn(1000, 15, 0, npc.Position, nilvector, npc)
			local spore = Isaac.Spawn(mod.FF.FloatingSpore.ID,mod.FF.FloatingSpore.Var,0,npc.Position,nilvector,nil)
			local sd = mod:GetEntityData(spore)
			sd.fallspeed = -4
			sd.height = -5
			sd.target = mod:FindRandomValidPathPosition(npc, 3, nil, 120, nil, true)
			if mod:isFriend(npc) then
				spore:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
			end
			spore:Update()
		end
	end
	if npc.State == 8 then
		npc.Velocity = npc.Velocity * 0.975
		if npc.FrameCount % 6 == 0 then -- Default is npc.FrameCount % 5
			local creep = Isaac.Spawn(1000, EffectVariant.CREEP_GREEN, 0, npc.Position, Vector(0,0), npc):ToEffect()
			creep:SetTimeout(creep.Timeout - 20)
			creep:Update()
		end
	end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
	if npc.Variant == 1 and npc:GetBossColorIdx() == mod.FF.MushroomGurgling.IDx then
        mod:ChampionGurgling(npc)
    end
end, EntityType.ENTITY_GURGLING)

--Not really a champion but included here anyway

function mod:checkSirenTester(npc)
    if npc.SubType ~= mod.FF.SirenTester.Sub then return end
    --print(npc.State, npc.StateFrame, npc.I1, npc.I2)
    if npc.State ~= 10 then
        if npc.State == 8 then --That freaking scream shut up
            npc.State = 10
        end
    end
end
mod:AddEntityCallback(ModCallbacks.MC_NPC_UPDATE, EntityType.ENTITY_SIREN, 0, mod.FF.SirenTester.Sub, mod.checkSirenTester, EntityType.ENTITY_SIREN)