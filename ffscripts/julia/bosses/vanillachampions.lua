local mod = FiendFolio
local game = Game()

local function findSelf(entity)
    for _, e in pairs(Isaac.FindByType(entity.Type, entity.Variant, entity.SubType, false, true)) do
        if e.Index == entity.Index then return e end
    end
end

local function isNearAlienLoki(entity)
    for _, e in pairs(Isaac.FindByType(69, 0, 1)) do
        if entity.Position:Distance(e.Position) < 5 then return e end
    end
    return nil
end

local function spawnDirections(spawner, start, goal, step)
    for i = start, goal, step do
        local vel = Vector.FromAngle(i) * 12
        local proj = mod:LazySpawnProjectile(0, 0, spawner.Position, vel, spawner):ToProjectile()
        proj:AddProjectileFlags(ProjectileFlags.SMART)
        proj.Color = mod.ColorPsy
    end
end

--green alien loki
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == 0 and npc:GetBossColorIdx() == mod.FF.AlienLokiChampion.IDx then
        local data = mod:GetEntityData(npc)
        local sprite = npc:GetSprite()

        if not data.initialized then
			if npc:ToDelirium() or (npc.SpawnerEntity and npc.SpawnerEntity:ToDelirium()) then
				sprite:Load("gfx/bosses/champions/loki/alien_loki.anm2", true)
				npc:ReplaceSpritesheet(0, "gfx/bosses/afterbirthplus/deliriumforms/classic/boss_048_loki.png", true)
			end
            data.initialized = true
        end

        if sprite:IsPlaying("TeleportUp") and sprite:IsEventTriggered("Jump") then
            npc:PlaySound(SoundEffect.SOUND_CUTE_GRUNT, 1, 0, false, 1)
            local effect = Isaac.Spawn(1000, 2, 0, npc.Position, Vector(0,0), npc)
			effect.Color = mod.ColorPsyGrape2
            spawnDirections(npc, 18, 306, 72) --5 projectiles
        end

        if sprite:IsPlaying("Attack03") and sprite:IsEventTriggered("Attack") then
            npc:PlaySound(SoundEffect.SOUND_CUTE_GRUNT, 1, 0, false, 1)
            local effect = Isaac.Spawn(1000, 2, 2, npc.Position, Vector(0,0), npc)
			effect.DepthOffset = 10
			effect.Color = mod.ColorPsyGrape2
            spawnDirections(npc, 18, 306, 72) --5 projectiles
        end

        if sprite:IsPlaying("Attack01") then
			if sprite:IsEventTriggered("Attack") or sprite:IsEventTriggered("AttackCardinal") then
				npc:PlaySound(SoundEffect.SOUND_CUTE_GRUNT, 1, 0, false, 1)
				local effect = Isaac.Spawn(1000, 2, 2, npc.Position, Vector(0,0), npc)
				effect.DepthOffset = 10
				effect.Color = mod.ColorPsyGrape2
				if sprite:IsEventTriggered("AttackCardinal") then
					spawnDirections(npc, 0, 360, 90) --cardinal
				elseif sprite:IsEventTriggered("Attack") then
					spawnDirections(npc, 45, 315, 90) --diagonal
				end
				if npc:ToDelirium() then
					npc.TransformationTimer = 1
				end
			end
        end

    end
end, 69) --nice

--mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, eff) --remove his blood splash when firing projectiles (this is such a horrible way of doing it im going to puke)
--    local loki = isNearAlienLoki(eff)
--    if loki then
--        local sprite = loki:GetSprite()
--
--        if sprite:IsEventTriggered("Shoot") then
--            eff:Remove()
--        end
--    end
--end, 2)

function mod:alienLokiPreSpawn(type, var, sub, pos, vel, spawner, seed)
    if spawner then
        if spawner.Type == 69 and spawner.Variant == 0 and spawner:ToNPC():GetBossColorIdx() == mod.FF.AlienLokiChampion.IDx then
            local extra = math.random(2, 3)
            for i=1, extra do
                Isaac.Spawn(170, 30, 0, Isaac.GetFreeNearPosition(spawner.Position, 0), vel, findSelf(spawner)) --i cant just use spawner for some fucked up reason
            end

            return {170, 30, 0, seed}
        end
    end
end



--yellow mask of infamy haha pee
local function spawnDirectionsMask(spawner, start, goal, step, scale)
    for i = start, goal, step do
        local vel = Vector.FromAngle(i) * 9
        local proj = mod:LazySpawnProjectile(0, 0, spawner.Position, vel, spawner):ToProjectile()
        proj.Color = mod.ColorLemonYellow
        proj.Scale = scale
    end
end

mod:AddPriorityCallback(ModCallbacks.MC_PRE_NPC_UPDATE, math.huge, function(_, npc)
    if npc.Variant == 0 then
        local data = mod:GetEntityData(npc)
	    if data.yellowChampion then
            if npc.State == 9 then --2nd phase
                --this does exactly what i need but it sucks because i cant remove the fucking skull symbol
                --trying to reimplement mask of infamy ai from the ground up was making me too depressed though so im leaving it like this for now
				--no longer will big skull icon keep the little guy down
                if not npc:HasEntityFlags(EntityFlag.FLAG_FEAR) then
                    npc:AddEntityFlags(EntityFlag.FLAG_FEAR)
					data.addedFear = true
                end
            end
        end
    end
end, 97)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == 0 then
        local data = mod:GetEntityData(npc)
        local sprite = npc:GetSprite()

            if npc.Parent then
                if npc.Variant == 0 and npc:GetBossColorIdx() == mod.FF.YellowMaskOfInfamy.IDx and npc.Parent.Type == 98 and npc.Parent.Variant == 0 and not data.yellowChampion then
                    data.yellowChampion = true
					--sprite:ReplaceSpritesheet(0, "gfx/bosses/champions/boss_maskofinfamy_yellow.png")
					--sprite:LoadGraphics()
					--[[local anim = sprite:GetAnimation()
					local frame = sprite:GetFrame()
					sprite:Load("gfx/bosses/champions/kidneyofinfamymask.anm2", true)
					sprite:SetFrame(anim, frame)]]
                end
            end

	  if data.yellowChampion then
        if data.addedFear then
          npc:ClearEntityFlags(EntityFlag.FLAG_FEAR)
          data.addedFear = nil
        end

        if npc.State == 9 then --2nd phase
            if npc.Velocity:Length() > 8 and npc.FrameCount % 10 == 0 then --spawn creep if "charging"
                local creep = Isaac.Spawn(1000, 24, 0, npc.Position, Vector(0, 0), npc):ToEffect()
                local scale = math.random(5, 15)/10
                creep.Scale = scale
                creep:Update()
            end
        end
	  end
    end
end, 97)

--yellow heart
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == 0 and npc:GetBossColorIdx() == mod.FF.KidneyOfInfamy.IDx then
        local data = mod:GetEntityData(npc)
        local sprite = npc:GetSprite()

        if not data.initialized then
            --[[sprite:ReplaceSpritesheet(0, "gfx/bosses/champions/boss_maskofinfamy_yellow.png")
            sprite:LoadGraphics()]]

            if npc.Child then
                if npc.Child.Type == 97 and npc.Child.Variant == 0 and npc:GetBossColorIdx() == mod.FF.YellowMaskOfInfamy.IDx then
                    mod:GetEntityData(npc.Child).yellowChampion = true
					--npc.Child:GetSprite():ReplaceSpritesheet(0, "gfx/bosses/champions/boss_maskofinfamy_yellow.png")
					--npc.Child:GetSprite():LoadGraphics()
					--[[local anim = npc.Child:GetSprite():GetAnimation()
					local frame = npc.Child:GetSprite():GetFrame()
					npc.Child:GetSprite():Load("gfx/bosses/champions/kidneyofinfamymask.anm2", true)
					npc.Child:GetSprite():SetFrame(anim, frame)]]
                end
            end
			if npc:ToDelirium() or (npc.SpawnerEntity and npc.SpawnerEntity:ToDelirium()) then
				sprite:Load("gfx/bosses/champions/maskofinfamy/kidneyofinfamy_heart.anm2", true)
				npc:ReplaceSpritesheet(0, "gfx/bosses/afterbirthplus/deliriumforms/classic/boss_057_maskofinfamy.png", true)
			end
            data.initialized = true
        end


        if sprite:IsPlaying("HeartAttack") and (sprite:IsEventTriggered("Attack") or sprite:IsEventTriggered("Attack2") or sprite:IsEventTriggered("Attack3")) then --projectile burst and creep spawning
            if sprite:IsEventTriggered("Attack3") then
                spawnDirectionsMask(npc, 0, 360, 90, 0.5)
                spawnDirectionsMask(npc, 45, 315, 90, 0.5)
            elseif sprite:IsEventTriggered("Attack2") then
                spawnDirectionsMask(npc, 0, 360, 90, 1.5)
                spawnDirectionsMask(npc, 45, 315, 90, 1.5)
            elseif sprite:IsEventTriggered("Attack") then
				npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT, 1, 0, false, 1)
                spawnDirectionsMask(npc, 0, 360, 90, 2)
				local effect = Isaac.Spawn(1000, 2, 4, npc.Position, Vector(0,0), npc)
				effect.SpriteOffset = Vector(0, -20)
				effect.DepthOffset = 10
				effect.Color = Color(0,0,0,1,180 / 255,180 / 255,30 / 255)
                local creep = Isaac.Spawn(1000, 24, 0, npc.Position, Vector(0, 0), npc):ToEffect()
                creep.Scale = 1.5
                creep:Update()
            end
        end
    end
end, 98)


--golden baby plum
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == 0 and npc:GetBossColorIdx() == mod.FF.GoldenPlum.IDx and not (npc:ToDelirium() or (npc.SpawnerEntity and npc.SpawnerEntity:ToDelirium())) then
        local data = mod:GetEntityData(npc)
        local sprite = npc:GetSprite()

        if not data.initialized then
            --[[sprite:ReplaceSpritesheet(0, "gfx/bosses/champions/boss_babyplum_golden.png")
            sprite:LoadGraphics()]]
            data.initialized = true

            data.fiendfolio_isGoldenPlumChampion = true
        end

        if npc.FrameCount % 10 == 0 then --gbf sparkles
            local sparkle = Isaac.Spawn(1000, 7003, 0, npc.Position, Vector(0, 0), npc):ToEffect()
            sparkle.RenderZOffset = -5
            sparkle.SpriteOffset = Vector(-10 + math.random(20), -40 + math.random(20))
        end

        if npc.FrameCount % 6 == 0 then
            if npc.State == 10 and (sprite:IsPlaying("Attack3Loop") or sprite:IsPlaying("Attack3BackLoop")) then --when bounce, fire an extra slow projectile every 4th frame (not so sure if this is the best way to approach this but eh)
                local params = ProjectileParams()
                params.FallingAccelModifier = -0.1
                params.Scale = math.random(4, 10)/10
                params.HeightModifier = -10

                npc:FireProjectiles(npc.Position, -(npc.Velocity):Normalized() + Vector((math.random() - 0.5) / 2, (math.random() - 0.5) / 2) * math.random(2, 4), 0, params)
            elseif npc.State == 8 then

            end
        end

        if npc.State == 9 and sprite:IsEventTriggered("Shoot") then --monstro coin blast
            for i = 1, 10 do
                local dir = math.random(0, 360)
                local vel = Vector.FromAngle(dir) * math.random(4, 7)

                local proj = mod:LazySpawnProjectile(7, 0, npc.Position, vel, npc):ToProjectile()
                proj:AddProjectileFlags(ProjectileFlags.GREED)
                mod:GetEntityData(proj).customSpawn = true
                proj.FallingSpeed = -10 - math.random(20)
				proj.FallingAccel = 1 + (math.random() * 0.5)
            end
        elseif npc.State == 8 and sprite:IsPlaying("Attack1") then -- radius burst
            if not data.fireAngle then
                data.fireAngle = 0 --initialize angle
            elseif sprite:GetFrame() > 6 and sprite:GetFrame() < 31 and sprite:GetFrame() % 2 == 0 then
                for i = 0, 41, 41 do --shoot one shot and one further back in the circle
                    if data.fireAngle + i <= 360 then
                        local vel = Vector.FromAngle(data.fireAngle + i) * 7

                        local proj = mod:LazySpawnProjectile(0, 0, npc.Position, vel, npc):ToProjectile()
                        mod:GetEntityData(proj).customSpawn = true
                        --proj.Color = mod.ColorGolden
                        proj:AddHeight(-30)
                    end
                end

                data.fireAngle = data.fireAngle + 30 --two circles
            elseif sprite:GetFrame() == 33 then
                data.fireAngle = 0 --reset fire angle
            end
        end

	for _, proj in ipairs(Isaac.FindByType(9, 0, 170, false, false)) do
        if proj.SpawnerType == 908 and proj.SpawnerVariant == 0 and not mod:GetEntityData(proj).customSpawn and proj.Position:Distance(npc.Position) < 20 and proj.FrameCount < 1 then
			if sprite:GetAnimation() == "Attack2" or sprite:GetAnimation() == "Attack1" then
				proj:Remove()
			else
				--proj.Color = mod.ColorGolden
			end
        end
	end

        -- print(npc.State)
    end
end, 908)

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, proj)
	if proj.Variant == 0 and proj.SubType == 170 and proj.SpawnerType == 908 and proj.SpawnerVariant == 0 then --golden plum projectile color
		local data = mod:GetEntityData(proj)
		if not data.GoldenPlum_ProjInitialized then
			proj.Color = mod.ColorGolden
			data.GoldenPlum_ProjInitialized = true
		end
	end
end)

function mod:goldenPlumCreepPreSpawn(type, variant, sub, pos, vel, spawner, seed)
    if spawner then
		if not (spawner:ToDelirium() or (spawner.SpawnerEntity and spawner.SpawnerEntity:ToDelirium())) then
			if spawner.Type == 908 and spawner.Variant == 0 and spawner:ToNPC():GetBossColorIdx() == mod.FF.GoldenPlum.IDx then --golden plum
				return {1000, 24, 0, seed}
			end
		end
    end
end

function mod:goldenPlumProjPreSpawn(type, variant, sub, pos, vel, spawner, seed)
    if variant == 0 and sub == 0 and spawner then
        if spawner.Type == 908 and spawner.Variant == 0 and spawner:ToNPC():GetBossColorIdx() == mod.FF.GoldenPlum.IDx and not (spawner:ToDelirium() or (spawner.SpawnerEntity and spawner.SpawnerEntity:ToDelirium())) then --golden plum
            return {9, 0, 170, seed}
        end
    end
end
