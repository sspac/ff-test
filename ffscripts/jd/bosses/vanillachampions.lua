local mod = FiendFolio
local game = Game()


--LOTS OF STOLEN CODE FROM GREEN LOKI, THANKS JULIA

local function spawnDirections(spawner, start, goal, step)
    for i = start, goal, step do
        local vel = Vector.FromAngle(i) * 12
        local proj = mod:LazySpawnProjectile(0, 0, spawner.Position, vel, spawner):ToProjectile()
        proj:AddProjectileFlags(ProjectileFlags.SMART | ProjectileFlags.DECELERATE)
        proj.Color = mod.ColorPsy
    end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == 1 and npc:GetBossColorIdx() == mod.FF.AlienLokiChampion.IDx then
        local data = mod:GetEntityData(npc)
        local sprite = npc:GetSprite()

        if not data.initialized then
			data.GreenLokiiAnm2Replace = false
            data.initialized = true
        end

		if npc.FrameCount > 0 and (npc:ToDelirium() or (npc.SpawnerEntity and npc.SpawnerEntity:ToDelirium())) and not data.GreenLokiiAnm2Replace then
			sprite:Load("gfx/bosses/champions/lokii/alien_lokii.anm2", true)
			npc:ReplaceSpritesheet(0, "gfx/bosses/afterbirthplus/deliriumforms/classic/boss_071_lokii.png", true)
			data.GreenLokiiAnm2Replace = true
		end

        if sprite:IsPlaying("TeleportUp") and sprite:IsEventTriggered("Jump") then
            npc:PlaySound(SoundEffect.SOUND_CUTE_GRUNT, 1, 0, false, 1)
           --[[Isaac.Spawn(1000, 2, 0, npc.Position, Vector(0,0), npc)
            spawnDirections(npc, 18, 306, 72)]] --5 projectiles
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

		if not npc.FlipX and not sprite:IsPlaying("TeleportUp") then
			local otherhalf
			for i, entity in pairs(Isaac.FindInRadius(npc.Position, 200, EntityPartition.ENEMY)) do
				if entity.Type == 69 and entity.Variant == 1 and entity:ToNPC():GetBossColorIdx() == mod.FF.AlienLokiiChampion.IDx and entity.FlipX then
					otherhalf = entity
				end
			end

			if otherhalf and not otherhalf:GetSprite():IsPlaying("TeleportUp") then
				local laserend = otherhalf.Position + Vector(0, -17)
				data.LokiiLaser = data.LokiiLaser or EntityLaser.ShootAngle(10, npc.Position, (laserend - npc.Position):GetAngleDegrees(), 5, Vector(0,-17), npc)
				local laser = data.LokiiLaser
				laser.Angle = (laserend - npc.Position):GetAngleDegrees()
				laser.MaxDistance = laserend:Distance(npc.Position) + 3
				laser.DepthOffset = -500
				laser.CollisionDamage = 0
				laser.Mass = 0
				laser:SetTimeout(2)
			end
		end

		if data.LokiiLaser and not data.LokiiLaser:Exists() then
			data.LokiiLaser = nil
		end
    end
end, 69)

function mod:alienLokiiPreSpawn(type, var, sub, pos, vel, spawner, seed)
    if spawner then
        if spawner.Type == 69 and spawner.Variant == 1 and spawner:ToNPC():GetBossColorIdx() == mod.FF.AlienLokiiChampion.IDx then
            --replace boom fly with Volt
            return {195, 30, 0, seed}
        end
    end
end