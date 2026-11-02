local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local rng = RNG()
local rng2 = RNG()
local rng3 = RNG()

local WIND_MAX_VOL = 2

mod.AmonAshpileAnims = {
	{"small", 3},
	{"med", 3},
	{"big", 2},
	{"spider"},
	{"fly"},
	{"clicketyclack"},
	{"bigbony"},
}

mod.AmonGridPathIndexes = {21, 22, 23, 36, 37, 38, 46, 58, 61, 73, 76, 88, 151, 163, 166, 178, 181, 193}
mod.AmonAshpileSizes = {13, 24, 36, 13, 13, 24, 36}
mod.AshpileSizeMultiplier = 1.25
mod.AshpilePoofBaseSizeEstimate = 40

mod.AmonWaves, mod.BreathsHeadWaves = include("ffscripts.xalum.bosses.extras.amon_waves")
include("ffscripts.xalum.bosses.extras.amon_mancave")

local function isAmonWaveDead(npc)
	local data = npc:GetData()
	local sprite = npc:GetSprite()

	if sprite:IsPlaying("SpawnDustsStart") or sprite:IsPlaying("SpawnDustsLoop") or data.dead then
		return false
	end

	local alive = false
	for _, ent in pairs(data.currentwave or {}) do
		if not ent:IsDead() then alive = true end
	end

	return not alive
end

local waveOverride = nil
local function pregenerateAmonWave()
	return mod.AmonWaves[waveOverride or (rng2:RandomInt(#mod.AmonWaves) + 1)]
end

local function makeAmonSpawn(npc, type, var, sub, pos, vel)
	local spawn = Isaac.Spawn(type, var or 0, sub or 0, pos, vel or Vector.Zero, npc)
	spawn:GetData().AmonSpawned = true
	return spawn
end

local function spawnAmonWave(npc)
	local room = game:GetRoom()
	local data = npc:GetData()
	local wave = data.wave

	data.currentwave = {}

	if wave.DoorSpawns or wave.SpecialSpawns then
		sfx:Play(SoundEffect.SOUND_SUMMONSOUND)
	end

	if wave.DoorSpawns then
		for door, spawns in pairs(wave.DoorSpawns) do
			local fanning = #spawns + 1
			local angle = 160 / fanning

			local doorpos = room:GetDoorSlotPosition(door)
			local pos = room:GetClampedPosition(doorpos, 5)

			for index, item in pairs(spawns) do
				data.currentwave[#data.currentwave + 1] = makeAmonSpawn(npc, item[1], item[2], item[3], pos + (pos - doorpos):Resized(25):Rotated(angle * index - 80))
			end
		end
	end

	if wave.MouthSpawns then
		local fanning = #wave.MouthSpawns + 1
		local angle = 160 / fanning

		for index, item in pairs(wave.MouthSpawns) do
			data.currentwave[#data.currentwave + 1] = makeAmonSpawn(npc, item[1], item[2], item[3], npc.Position + Vector(0, 35):Rotated(angle * index - 80))
		end 
	end

	if wave.SpecialSpawns then
		for _, item in pairs(wave.SpecialSpawns) do
			--Isaac.Spawn(, item[1], Vector.Zero, npc)
			local pos = item[1]
			if type(pos) == "number" then pos = room:GetGridPosition(pos) end

			data.currentwave[#data.currentwave + 1] = makeAmonSpawn(npc, item[2][1], item[2][2], item[2][3], pos)
		end
	end

	data.spawndusts = wave.Dusts or 0
	data.spawnmirages = wave.Mirages or 0
end

local function hideArms(npc)
	local data = npc:GetData()

	for i = 1, 2 do
		data["arm"..i]:GetData().hide = true
		data["arm"..i]:GetSprite():Play("Retract")
	end
end

local function unHideArms(npc)
	local data = npc:GetData()

	for i = 1, 2 do
		data["arm"..i]:GetData().hide = false
	end
end

local function playAmonIdle(npc, sprite, data)
	if npc.HitPoints < npc.MaxHitPoints / 2 and data.breath_started then
		sprite:Play("BreathIdle")
	else
		sprite:Play("Idle")
	end
end

local function isAmonIdle(sprite)
	return sprite:IsPlaying("Idle") or sprite:IsPlaying("BreathIdle")
end

local function shouldSpawnBreathWave(data)
	return data.breath_started and #Isaac.FindByType(mod.FF.BreathsHead.ID, mod.FF.BreathsHead.Var) == 0 and not data.dead
end

local function getAshpileAnimFromSubType(n)
	if not mod.AmonAshpileAnims[n] then n = 0 end
	n = n > 0 and n or rng:RandomInt(3) + 1

	local data = mod.AmonAshpileAnims[n]
	local anim = data[1]

	if data[2] then
		anim = anim .. math.random(data[2])
	end

	return anim
end

local uniqueAshPiles = {
	[EntityType.ENTITY_ROCK_SPIDER] = 							{mod.FF.AshpileSpider.Sub,		mod.FF.AshpileSmall.Sub},
	[EntityType.ENTITY_SPIDER] = 								{mod.FF.AshpileSpider.Sub,		mod.FF.AshpileSmall.Sub},

	[EntityType.ENTITY_BOOMFLY] = 								{mod.FF.AshpileFly.Sub, 		mod.FF.AshpileSmall.Sub},
	[EntityType.ENTITY_FLY_BOMB] = 								{mod.FF.AshpileFly.Sub, 		mod.FF.AshpileSmall.Sub},
	[mod.FF.Ztewie.ID.." "..mod.FF.Ztewie.Var] = 				{mod.FF.AshpileFly.Sub, 		mod.FF.AshpileSmall.Sub},
	[mod.FF.Briar.ID.." "..mod.FF.Briar.Var] = 					{mod.FF.AshpileFly.Sub, 		mod.FF.AshpileSmall.Sub},

	[EntityType.ENTITY_CLICKETY_CLACK.." "..0] = 				{mod.FF.AshpileClickety.Sub,	mod.FF.AshpileMedium.Sub},

	[EntityType.ENTITY_BIG_BONY] = 								{mod.FF.AshpileBigBony.Sub,		mod.FF.AshpileBig.Sub},
	[mod.FF.ClicketyClash.ID.." "..mod.FF.ClicketyClash.Var] =	{mod.FF.AshpileBigBony.Sub,		mod.FF.AshpileBig.Sub},
}

local function npcHasSpecialAshpile(npc)
	if uniqueAshPiles[npc.Type] then
		return uniqueAshPiles[npc.Type]
	elseif uniqueAshPiles[npc.Type.." "..npc.Variant] then
		return uniqueAshPiles[npc.Type.." "..npc.Variant]
	end

	return false
end

local function estimateAshpileSize(npc)
	if npc.Size <= mod.AmonAshpileSizes[1] * mod.AshpileSizeMultiplier then return 1 end
	if npc.Size <= mod.AmonAshpileSizes[2] * mod.AshpileSizeMultiplier then return 2 end
	return 3
end

local function convertToAshpile(ent)
	if game:GetRoom():IsPositionInRoom(ent.Position, 0) then
		local sub = npcHasSpecialAshpile(ent)
		sub = sub and sub[math.random(#sub)] or estimateAshpileSize(ent)
		Isaac.Spawn(mod.FF.Ashpile.ID, mod.FF.Ashpile.Var, sub, ent.Position, Vector.Zero, npc)	
	end
	if ent.Type == FiendFolio.FF.Shellmet.ID and ent.Variant == FiendFolio.FF.Shellmet.Var then
		sfx:Stop(SoundEffect.SOUND_ULTRA_GREED_SPINNING)
	end
	ent:Remove()
end

local function scaleAmonAshpilePoof(pile, poof)
	local scaler = mod.AmonAshpileSizes[pile.SubType] / mod.AshpilePoofBaseSizeEstimate
	poof.SpriteScale = poof.SpriteScale * scaler
end

local function isBonyAshpile(pile)
	return pile.SubType == mod.FF.AshpileClickety.Sub or pile.SubType == mod.FF.AshpileBigBony.Sub
end

local function getAshpileDropChance(pile)
	if isBonyAshpile(pile) then
		return 10
	else
		return 5
	end
end

local function doAshpileBreak(pile)
	pile:Remove()

	sfx:Play(SoundEffect.SOUND_SIREN_MINION_SMOKE)
	if isBonyAshpile(pile) then
		sfx:Play(SoundEffect.SOUND_BONE_BREAK)
	end

	local gameData = Isaac.GetPersistentGameData()
	local roll = rng:RandomInt(100)
	if gameData:Unlocked(Achievement.BONE_HEARTS) and roll < getAshpileDropChance(pile) then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BONE, pile.Position, Vector.Zero, pile)
	end

	local poof = Isaac.Spawn(1000, 16, 1, pile.Position, Vector.Zero, pile)
	poof:GetSprite():ReplaceSpritesheet(0, "gfx/bosses/amon/ashy_groundpoof.png", true)	
	scaleAmonAshpilePoof(pile, poof)
end

local function gridAlignPosition(pos)
	local room = game:GetRoom()
	return room:GetGridPosition(room:GetGridIndex(pos))
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
	if npc.Variant == mod.FF.Amon.Var then
		npc.EntityCollisionClass = 0
	end
end, mod.FF.Amon.ID)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
	if npc.Variant == mod.FF.Amon.Var then
		local data = npc:GetData()
		local sprite = npc:GetSprite()
		local room = game:GetRoom()

		if not data.params_bone then
			data.params_bone = ProjectileParams()
			data.params_bone.Variant		= ProjectileVariant.PROJECTILE_BONE
			data.params_bone.BulletFlags	= ProjectileFlags.BOUNCE_FLOOR

			rng:SetSeed(npc.InitSeed, 44)
			rng2:SetSeed(rng:RandomInt(9999), 46)
			rng3:SetSeed(rng:RandomInt(9999), 46)

			npc.Position = Vector(room:GetCenterPos().X, 180)

			npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)

			data.checkwave = false
		end

		local target = npc:GetPlayerTarget()

		npc.Velocity = Vector.Zero
		mod.NegateKnockoutDrops(npc)

		if sprite:IsFinished("Intro") then
			data.arm1 = Isaac.Spawn(mod.FF.AmonArm.ID, mod.FF.AmonArm.Var, 0, room:GetDoorSlotPosition(2) + Vector(20, 0), Vector.Zero, npc)
			data.arm1:GetSprite():Play("Intro")

			data.arm2 = Isaac.Spawn(mod.FF.AmonArm.ID, mod.FF.AmonArm.Var, 1, room:GetDoorSlotPosition(4) + Vector(-20, 0), Vector.Zero, npc)
			data.arm2:GetSprite():Play("Intro")

			data.arm2:GetData().otherArm = data.arm1
			data.arm1:GetData().otherArm = data.arm2

			data.lastframe = npc.FrameCount
		end

		for _, index in pairs(mod.AmonGridPathIndexes) do
			room:SetGridPath(index, 950)
		end

		if sprite:IsFinished("Spawn") or sprite:IsFinished("SpawnDoor") then
			unHideArms(npc)

			data.forcespawn = false
			data.canattack = true

			if data.spawndusts > 0 or data.spawnmirages > 0 then
				sprite:Play("SpawnDustsStart")
			end
		end

		if sprite:IsFinished("BreathStart") then
			data.breath_starting = false
			data.breath_started = true

			if data.forcespawn then
				repeat
					data.wave = pregenerateAmonWave()
				until (data.wave.Dusts == 0 or not data.wave.Dusts) and (data.wave.Mirages == 0 or not data.wave.Mirages)

				spawnAmonWave(npc)
				data.forcespawn = false
				data.checkwave = true

				data.respawnhands = npc.FrameCount + 36
			end
		end

		if data.respawnhands and data.respawnhands <= npc.FrameCount then
			data.respawnhands = nil

			data.arm1:GetData().hide = false
			data.arm2:GetData().hide = false
		end

		if sprite:IsFinished("Outro") then
			local corpse = Isaac.Spawn(mod.FF.AmonCorpse.ID, mod.FF.AmonCorpse.Var, 0, npc.Position, Vector.Zero, npc)
			corpse:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			corpse:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
			corpse:Update()

			npc:Remove()
			return
		end

		if shouldSpawnBreathWave(data) then
			local roll = rng3:RandomInt(#mod.BreathsHeadWaves) + 1
			local set = mod.BreathsHeadWaves[roll]

			for _, pos in pairs(set) do
				Isaac.Spawn(mod.FF.BreathsHead.ID, mod.FF.BreathsHead.Var, 0, npc.Position + pos, Vector.Zero, npc)
			end
		end

		if sprite:IsFinished("Flinch") then
			data.wave = pregenerateAmonWave()

			if data.wave.MouthSpawns then
				sprite:Play("SpawnDoor")
			elseif data.wave.DoorSpawns or data.wave.SpecialSpawns then
				sprite:Play("Spawn")
			elseif data.wave.Dusts > 0 or data.wave.Mirages > 0 then
				data.spawndusts = data.wave.Dusts or 0
				data.spawnmirages = data.wave.Mirages or 0
				data.checkwave = true
				unHideArms(npc)
				sprite:Play("SpawnDustsStart")
			end
		elseif sprite:IsFinished("SpawnDustsStart") then
			sprite:Play("SpawnDustsLoop")
			data.spawnduststart = npc.FrameCount + 5
			data.currentwave = data.currentwave or {}
		elseif sprite:IsFinished() then
			if data.intro then
				playAmonIdle(npc, sprite, data)
				data.lastframe = npc.FrameCount
			else
				data.intro = true
				sprite:Play("Intro", true)
			end
		end

		--print(tostring(data.checkwave))
		if data.checkwave and isAmonWaveDead(npc) then
			data.waveChecks = data.waveChecks + 1
			if data.waveChecks > 3 then
				npc.HitPoints = npc.HitPoints - npc.MaxHitPoints / 8

				if isAmonIdle(sprite) then
					if npc.HitPoints < npc.MaxHitPoints / 2 and not data.breath_started then
						data.forcespawn = true
						data.breath_starting = true

						sprite:Play("BreathStart")
					else
						sprite:Play("Flinch")
					end
				else
					data.forcespawn = true
				end

				hideArms(npc)
				data.checkwave = false
			end
		else
			data.waveChecks = 0
		end

		if data.breath_started then
			for _, p in pairs(Isaac.FindByType(1)) do
				local d = p:GetData()
				d.lastAmonPush = d.lastAmonPush or -1

				if p.FrameCount > d.lastAmonPush then
					p:AddVelocity(Vector(0, 0.3))
					d.lastAmonPush = p.FrameCount
				end
			end
		end

		if isAmonIdle(sprite) and data.canattack then
			if sprite:IsPlaying("Idle") and npc.HitPoints < npc.MaxHitPoints / 2 then
				sprite:Play("BreathStart")
				data.breath_starting = true
			end

			if not data.breath_starting and ((npc.FrameCount % 12 == 0 and rng:RandomInt(12) == rng:RandomInt(12)) or data.lastframe + 180 <= npc.FrameCount or data.forcespawn) then
				local roll = rng:RandomInt(2)

				if data.forcespawn then
					data.wave = pregenerateAmonWave()

					if data.wave.MouthSpawns then
						sprite:Play("SpawnDoor")
					elseif data.wave.DoorSpawns or data.wave.SpecialSpawns then
						sprite:Play("Spawn")
					elseif data.wave.Dusts > 0 or data.wave.Mirages > 0 then
						data.spawndusts = data.wave.Dusts or 0
						data.spawnmirages = data.wave.Mirages or 0
						data.checkwave = true
						unHideArms(npc)
						sprite:Play("SpawnDustsStart")
					end

					data.forcespawn = false
				elseif roll == 0 then
					sprite:Play("BouncingBones")
				elseif roll == 1 then
					sprite:Play("Fireball")
					sfx:Play(SoundEffect.SOUND_LARYNX_SCREAM_MED)
				end
			end
		end	

		if sprite:IsEventTriggered("Sound") then
			if sprite:IsPlaying("BouncingBones") then
				sfx:Play(SoundEffect.SOUND_MEGA_BLAST_END)
			elseif sprite:IsPlaying("SpawnDustsEnd") then
				sfx:Play(SoundEffect.SOUND_SIREN_MINION_SMOKE, 2, 0, false, 1)
				sfx:Stop(SoundEffect.SOUND_DEATH_DIES)
			elseif sprite:IsPlaying("SpawnDustsStart") then
				sfx:Play(SoundEffect.SOUND_LARYNX_SCREAM_MED)
				sfx:Play(SoundEffect.SOUND_DEATH_DIES, 0.2, 0, false, 0.2)
			end
		end

		if sprite:IsEventTriggered("DeathRoar") then
			sfx:Play(SoundEffect.SOUND_LARYNX_SCREAM_MED)
			sfx:Play(SoundEffect.SOUND_DEATH_DIES, 0.3, 0, false, 0.2)
		end

		if sprite:IsEventTriggered("BreathStart") then
			local dustOverlay = Isaac.Spawn(mod.FF.DustOverlay.ID, mod.FF.DustOverlay.Var, 0, npc.Position + Vector(0, -64), Vector.Zero, npc):ToEffect()
			data.dustOverlay = dustOverlay

			dustOverlay:GetSprite():Play("Appear")
			sfx:Play(mod.Sounds.AmonWindLoop, 0.1, 2, true)
			data.rampUpWindSound = 0.1
		end

		if data.rampUpWindSound and not sfx:IsPlaying(mod.Sounds.AmonWindLoop) then
			sfx:Play(mod.Sounds.AmonWindLoop, data.rampUpWindSound, 2, true)
		end

		if data.rampUpWindSound then
			data.rampUpWindSound = mod.XalumLerp(data.rampUpWindSound, WIND_MAX_VOL, 0.2)
			sfx:AdjustVolume(mod.Sounds.AmonWindLoop, data.rampUpWindSound)
		end

		if data.rampDownWindSound then
			data.rampDownWindSound = mod.XalumLerp(data.rampDownWindSound, 0, 0.2)
			sfx:AdjustVolume(mod.Sounds.AmonWindLoop, data.rampDownWindSound)

			if data.rampDownWindSound < 0.01 then
				sfx:Stop(mod.Sounds.AmonWindLoop)
			end
		end

		if sprite:WasEventTriggered("DustFadeIn") and data.dustOverlay then
			data.dustOverlay.Color = data.dustOverlay.Color * Color(1, 1, 1, 0.99, 0, 0, 0)
			if data.dustOverlay.Color.A <= 0.05 then
				data.dustOverlay:Remove()
				data.dustOverlay = nil
			end
		end

		if sfx:IsPlaying(SoundEffect.SOUND_WHIP_HIT) then -- WhipHit sfx
			sfx:Stop(SoundEffect.SOUND_WHIP_HIT)
			sfx:Play(SoundEffect.SOUND_BONE_BREAK)

			if data.arm1 and data.arm2 then
				local p = Isaac.GetPlayer()
				if data.arm1.Position:Distance(p.Position) < data.arm2.Position:Distance(p.Position) then
					local anm1 = data.arm1:GetSprite():GetAnimation()
					if anm1 == "WalkAttackDown" or anm1 == "Extend" then
						data.arm1:GetSprite():Play("Flick")
					end
				else
					local anm2 = data.arm2:GetSprite():GetAnimation()
					if anm2 == "WalkAttackDown" or anm2 == "Extend" then
						data.arm2:GetSprite():Play("Flick")
					end
				end
			end
		end

		if sprite:IsPlaying("Fireball") and sprite:GetFrame() == 17 then
			local sounds = {SoundEffect.SOUND_MOTHER_CHARGE1, SoundEffect.SOUND_MOTHER_CHARGE2}
			local sound = sounds[math.random(2)]
			sfx:Play(sound)
		end

		if sprite:IsPlaying("SpawnDustsLoop") then
			if data.spawndusts <= 0 and data.spawnmirages <= 0 then
				sprite:Play("SpawnDustsEnd")
			end

			if npc.FrameCount >= data.spawnduststart then
				if data.spawndusts > 0 then
					data.currentwave[#data.currentwave + 1] = makeAmonSpawn(npc, 882, data.redust or 0, 0, npc.Position + Vector(0, 20))
					data.currentwave[#data.currentwave]:Update()

					data.spawndusts = data.spawndusts - 1
				elseif data.spawnmirages > 0 then
					data.currentwave[#data.currentwave + 1] = makeAmonSpawn(npc, FiendFolio.FF.Mirage.ID, FiendFolio.FF.Mirage.Var, 0, npc.Position + Vector(0, 20))
					data.currentwave[#data.currentwave]:Update()

					data.spawnmirages = data.spawnmirages - 1
				end
				data.spawnduststart = npc.FrameCount + 30
			end
		end

		if sprite:IsEventTriggered("ScreenShake") then
			game:ShakeScreen(10)

			if sprite:IsPlaying("Intro") then
				sfx:Play(SoundEffect.SOUND_BULLET_SHOT)
				sfx:Play(SoundEffect.SOUND_GROUND_TREMOR)

				for i = 1, 5 do
					local dust = Isaac.Spawn(1000, 59, 0, npc.Position - Vector(0, 45), Vector(math.random(-5, 5), math.random(-1, 3)), npc):ToEffect()
					dust:SetTimeout(45)
					dust.Color = Color(1, 1, 1, 0.75)
				end

				for i = 1, 3 do
					local gib = Isaac.Spawn(1000, 4, 0, npc.Position - Vector(0, 45), Vector(math.random(-5, 5), math.random(-1, 3)), npc)
				end
			end
		end

		if sprite:IsEventTriggered("BreakIn") then
			data.headhole = Isaac.Spawn(mod.FF.AmonHole.ID, mod.FF.AmonHole.Var, 0, npc.Position - Vector(0, 35), Vector.Zero, npc)
			data.headhole:GetSprite():Play("Hole")
			data.headhole.RenderZOffset = -5000
			--data.headhole:AddEntityFlags(EntityFlag.FLAG_RENDER_WALL)

			sfx:Play(SoundEffect.SOUND_EXPLOSION_STRONG)

			npc.EntityCollisionClass = 4

			for i = 1, 8 do
				local gib = Isaac.Spawn(1000, 4, 0, npc.Position - Vector(0, 45), Vector(math.random(-8, 8), math.random(-1, 8)), npc)
			end

			game:ShakeScreen(20)
		end

		if sprite:IsEventTriggered("Roar") then
			sfx:Play(SoundEffect.SOUND_LARYNX_SCREAM_MED, 1, 3)
			sfx:Play(SoundEffect.SOUND_BEAST_SURFACE_GROWL, 1.2, 3, false, 0.8)
		end

		if sprite:IsEventTriggered("Shoot") then
			if sprite:IsPlaying("BouncingBones") then
				for i = 1, 5 do
					local proj = Isaac.Spawn(9, ProjectileVariant.PROJECTILE_BONE, 0, npc.Position, Vector(0, 5):Rotated(-40 + 40/3 * i), npc):ToProjectile()
					proj:GetData().amonSkippingTear = true

					local spr = proj:GetSprite()
					spr:Load("gfx/bosses/amon/bigbone.anm2", true)
					spr.FlipX = proj.Velocity.X < 0


					sfx:Play(SoundEffect.SOUND_BEAST_SURFACE_GROWL, 0.75, 3, false, 0.8)
					sfx:Play(SoundEffect.SOUND_DEATH_BURST_BONE)
				end
			elseif sprite:IsPlaying("Fireball") then
				sfx:Play(SoundEffect.SOUND_WAR_LAVA_SPLASH, 1.2, 0, false, 0.8)
				sfx:Play(SoundEffect.SOUND_BEAST_SURFACE_GROWL, 0.6, 0, false, 0.6)

				Isaac.Spawn(mod.FF.AmonFireball.ID, mod.FF.AmonFireball.Var, 0, npc.Position, (target.Position - npc.Position):Resized(12), npc)
			end
		end

		if sprite:IsEventTriggered("Spawn") then
			spawnAmonWave(npc)
			data.checkwave = true
		end

		if sprite:IsEventTriggered("DustMax") then
			data.rampDownWindSound = WIND_MAX_VOL
			data.rampUpWindSound = nil

			npc.CollisionDamage = 0

			if data.arm1 then
				data.arm1:Remove()
				data.arm2:Remove()
			end
			data.headhole:Remove()

			for _, ent in pairs(Isaac.FindInRadius(npc.Position, 5000, EntityPartition.ENEMY)) do
				if not ent:IsBoss() then
					convertToAshpile(ent)
				end
			end
			for _, spawn in pairs(data.currentwave) do --Adding an extra check for enemies without collision which FindInRadius misses
				if spawn:Exists() then
					convertToAshpile(spawn)
				end
			end

			for _, proj in pairs(Isaac.FindByType(9)) do
				proj:Remove()
			end

			for _, dust in pairs(Isaac.FindByType(882, 0)) do
				convertToAshpile(dust)
			end

			for _, hole in pairs(Isaac.FindByType(mod.FF.AmonArmHole.ID, mod.FF.AmonArmHole.Var)) do
				hole:Remove()
			end

			local roomskin = Isaac.Spawn(mod.FF.AshypitSkin.ID, mod.FF.AshypitSkin.Var, 0, game:GetRoom():GetTopLeftPos(), Vector.Zero, nil)
			roomskin:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR + EntityFlag.FLAG_RENDER_WALL)

			if #Isaac.FindByType(mod.FF.Ashpile.ID, mod.FF.Ashpile.Var) == 0 then
				local room = game:GetRoom()
				for i = 1, rng:RandomInt(4) + 2 do
					local pos = room:FindFreeTilePosition(room:GetRandomPosition(40), 900)
					Isaac.Spawn(mod.FF.Ashpile.ID, mod.FF.Ashpile.Var, 0, pos, Vector.Zero, npc)
				end
			end
		end

		if npc:HasMortalDamage() then
			npc.HitPoints = npc.MaxHitPoints
			npc:AddEntityFlags(EntityFlag.FLAG_DONT_COUNT_BOSS_HP)

			sprite:Play("Outro")
			
			if mod.CanRunUnlockAchievements() and game:GetRoom():GetType() == RoomType.ROOM_BOSS then
				FiendFolio.savedata.killedBosses = FiendFolio.savedata.killedBosses or {}
				FiendFolio.savedata.killedBosses["HighAmon"] = true
			end

			if data.arm1 then
				data.arm1:GetSprite():Play("DeathLoop")
				data.arm2:GetSprite():Play("DeathLoop")
			end

			data.dead = true
			npc.RenderZOffset = 99999
		end
	elseif npc.Variant == mod.FF.BreathsHead.Var then
		local sprite = npc:GetSprite()
		local data = npc:GetData()

		if not data.init then
			data.init = true

			npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK + EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		end

		if sprite:IsFinished("Intro") then sprite:Play("Idle") end

		npc.Velocity = Vector(math.sin(npc.FrameCount / 12) * 3.5, 3.5)

		local room = game:GetRoom()
		if npc.Position.Y >= room:GetClampedPosition(npc.Position, 40).Y + 300 then
			--npc.Position = Vector(mod.Clamp(npc.Position.X --[[+ rng:RandomInt(401) - 200]], 70, 570), room:GetClampedPosition(Vector(npc.Position.X, 100), 0).Y - 160)
			npc:Remove()
		end
	end
end, mod.FF.Amon.ID)

mod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, function(_, npc)
	if npc.Variant == mod.FF.AmonArm.Var then
		npc.State = 3

		local data = npc:GetData()
		local sprite = npc:GetSprite()
		local room = game:GetRoom()

		if not npc.SpawnerEntity then
			if data.myHoles[1] then data.myHoles[1]:Remove() end
			if data.myHoles[2] then data.myHoles[2]:Remove() end
			npc:Remove()
		end

		if not data.params then
			data.params = ProjectileParams()
			data.params.Variant = ProjectileVariant.PROJECTILE_ROCK

			npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK + EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK + EntityFlag.FLAG_DONT_COUNT_BOSS_HP)

			sprite.FlipX = npc.SubType == 1

			data.doors = npc.SubType == 1 and {Vector(40, 280), Vector(40, 560)} or {Vector(600, 280), Vector(600, 560)}
			data.doori = 0

			data.hide = true
			data.myHoles = {}
		end

		npc.HitPoints = 1000

		if sprite:IsFinished("Intro") then
			if data.hide then
				local dat = npc.SpawnerEntity:GetData()

				dat.forcespawn = true
				dat.canattack = true
			else
				npc.Position = data.doors[1]
				data.doori = 1

				sprite:Play("Extend")
			end
		elseif sprite:IsFinished("Crush") then
			sprite:Play("WalkAttackDown")
			npc.SpawnerEntity:GetData().canattack = true
		elseif sprite:IsFinished("Retract") then
			if not data.hide then
				data.doori = data.doori % 2 + 1
				npc.Position = data.doors[data.doori]

				sprite:Play("Extend")
			end
		elseif sprite:IsFinished() then
			sprite:Play("WalkAttackDown")
		end

		if sprite:IsPlaying("WalkAttackDown") then
			if sprite:GetFrame() == 0 then
				npc:Morph(npc.Type, 2, npc.SubType, -1)
				npc:Update()
				npc:Morph(npc.Type, mod.FF.AmonArm.Var, npc.SubType, -1)
			end

			if npc.FrameCount % 15 == 0 and rng:RandomInt(10) == rng:RandomInt(10) then
				if rng:RandomInt(3) == rng:RandomInt(3) and not data.otherArm:GetSprite():IsPlaying("Crush") then
					sprite:Play("Crush")
				else
					sprite:Play("Retract")
				end
			end
		end

		if sprite:IsEventTriggered("ScreenShake") then
			game:ShakeScreen(10)

			if sprite:IsPlaying("Intro") then
				sfx:Play(SoundEffect.SOUND_BULLET_SHOT)
				sfx:Play(SoundEffect.SOUND_GROUND_TREMOR)

				for i = 1, 5 do
					local dust = Isaac.Spawn(1000, 59, 0, npc.Position, Vector(math.random(-5, 5), math.random(5)):Rotated(90 - npc.SubType * 180), npc):ToEffect()
					dust:SetTimeout(45)
					dust.Color = Color(1, 1, 1, 0.75)
				end

				for i = 1, 3 do
					local gib = Isaac.Spawn(1000, 4, 0, npc.Position, Vector(math.random(-5, 5), math.random(5)):Rotated(90 - npc.SubType * 180), npc)
				end
			end
		end

		if sprite:IsEventTriggered("BreakIn") then
			local hole = Isaac.Spawn(mod.FF.AmonArmHole.ID, mod.FF.AmonArmHole.Var, 0, room:GetClampedPosition(npc.Position, 0), Vector.Zero, npc)
			hole.RenderZOffset = -5000
			hole:GetSprite().FlipX = sprite.FlipX
			game:ShakeScreen(20)
			sfx:Play(SoundEffect.SOUND_EXPLOSION_STRONG)

			for i = 1, 8 do
				local gib = Isaac.Spawn(1000, 4, 0, npc.Position, Vector(math.random(-5, 5), math.random(5)):Rotated(90 - npc.SubType * 180), npc)
			end

			table.insert(data.myHoles, hole)
		end

		if sprite:IsEventTriggered("BreakOpen") then
			local hole = Isaac.Spawn(mod.FF.AmonArmHole.ID, mod.FF.AmonArmHole.Var, 0, room:GetClampedPosition(room:GetDoorSlotPosition(npc.SubType * 6), 0), Vector.Zero, npc)
			hole.RenderZOffset = -5000
			hole:GetSprite().FlipX = not sprite.FlipX
			game:ShakeScreen(20)
			sfx:Play(SoundEffect.SOUND_BULLET_SHOT, 0.8)

			for i = 1, 8 do
				local gib = Isaac.Spawn(1000, 4, 0, room:GetClampedPosition(room:GetDoorSlotPosition(npc.SubType * 6), 0), Vector(math.random(-5, 5), math.random(5)):Rotated(-90 - npc.SubType * 180), npc)
			end

			table.insert(data.myHoles, hole)
		end

		if sprite:IsEventTriggered("Shoot") then
			game:ShakeScreen(10)

			if sprite:IsPlaying("Intro") then
				npc:FireProjectiles(room:GetClampedPosition(room:GetDoorSlotPosition(npc.SubType * 6), 5), Vector(8, 12), 9, data.params)
			elseif sprite:IsPlaying("Crush") then
				local shockwave = Isaac.Spawn(1000, 61, 0, npc.Position - Vector(200 - 400 * npc.SubType, 0), Vector.Zero, npc):ToEffect()
				shockwave:SetRadii(20, 65)
				shockwave:SetTimeout(15)
				sfx:Play(SoundEffect.SOUND_EXPLOSION_STRONG)
			end
		end
	end
end, mod.FF.AmonArm.ID)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_COLLISION, function(_, tear, collider)
	if collider.Type ~= mod.FF.Amon.ID or collider.Variant ~= mod.FF.Amon.Var then
		if collider.Type ~= mod.FF.AmonCorpse.ID or collider.Variant ~= mod.FF.AmonCorpse.Var then
			return 
		end
	end

	for _, arm in pairs(Isaac.FindByType(mod.FF.AmonArm.ID, mod.FF.AmonArm.Var)) do
		local data = arm:GetData()
		if data.myHoles then
			if data.myHoles[1] then data.myHoles[1]:Remove() end
			if data.myHoles[2] then data.myHoles[2]:Remove() end
		end
	end
	game:GetRoom():ClearBossHazards(false, collider) -- :(
	game:GetRoom():ClearBossHazards(false, collider)
	game:GetRoom():ClearBossHazards(false, collider)

	local rng = collider:GetDropRNG()

	for i = 1, 30 do
		local offset = Vector(0, rng:RandomFloat()):Rotated(rng:RandomInt(360)) * rng:RandomFloat() * 20
		local vel = Vector(0, rng:RandomFloat()):Rotated(rng:RandomInt(360)) * 7 + Vector(0, rng:RandomFloat()) * 5

		local bone = Isaac.Spawn(9, ProjectileVariant.PROJECTILE_BONE, 0, collider.Position + offset, vel, collider):ToProjectile()
		bone.FallingSpeed = -rng:RandomInt(35, 40)
		bone.FallingAccel = 2
	end

	if Isaac.GetPersistentGameData():Unlocked(Achievement.BONE_HEARTS) then
		for i = 1, 2 + rng:RandomInt(2) do
			Isaac.Spawn(5, 10, 11, collider.Position, RandomVector() * 3, collider)
		end
	end

	sfx:Play(SoundEffect.SOUND_BULLET_SHOT)
	sfx:Play(SoundEffect.SOUND_GROUND_TREMOR)

	for i = 1, 5 do
		local dust = Isaac.Spawn(1000, 59, 0, collider.Position, Vector(math.random(-5, 5), math.random(5)):Rotated(90 - collider.SubType * 180), collider):ToEffect()
		dust:SetTimeout(45)
		dust.Color = Color(1, 1, 1, 0.75)
	end

	for i = 1, 3 do
		local gib = Isaac.Spawn(1000, 4, 0, collider.Position, Vector(math.random(-5, 5), math.random(5)):Rotated(90 - collider.SubType * 180), collider)
	end

	if collider.Type == mod.FF.Amon.ID and collider.Variant == mod.FF.Amon.Var then
		local data = collider:GetData()
		if data.headhole then
			data.headhole:Remove()
		end

		mod.SpawnAmonManCave()
	end
end, TearVariant.CHAOS_CARD)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
	if npc.Variant == mod.FF.AmonCorpse.Var then
		npc.State = 0
		npc:GetSprite():Play("DeathIdle")
	end
end, mod.FF.AmonCorpse.ID)

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, projectile)
	local data = projectile:GetData()
	local sprite = projectile:GetSprite()

	if projectile.FrameCount <= 1 then
		sprite:Play("Move")
		sprite.Offset = Vector(1, -14)

		data.amonRealBounceTear = true
		projectile:AddProjectileFlags(ProjectileFlags.FIRE_WAVE + ProjectileFlags.FIRE_WAVE_X)
	end

	projectile.Height = -15
	projectile.Velocity = projectile.Velocity * 0.965

	if sprite:GetAnimation() ~= "Detonate" then
		if #Isaac.FindInRadius(projectile.Position, 90, EntityPartition.PLAYER) > 0 then
			sprite:Play("Detonate")
		end
	end

	if projectile.Velocity:Length() < 0.5 and not sprite:IsPlaying("Detonate") then
		if sprite:IsPlaying("Move") then
			sprite:Play("Flash")
			data.initframe = projectile.FrameCount
		end

		if data.initframe + 150 <= projectile.FrameCount then
			sprite:Play("Detonate")
		end
	end

	for _, tear in pairs(Isaac.FindInRadius(projectile.Position, projectile.Size + 5, EntityPartition.TEAR)) do
		tear:Die()
	end

	if sprite:IsEventTriggered("Explode") and not projectile:IsDead() then
		sfx:Play(SoundEffect.SOUND_WAR_LAVA_DASH)
		sfx:Play(SoundEffect.SOUND_SIREN_MINION_SMOKE)
		projectile:Die()

		local poof = Isaac.Spawn(mod.FF.AmonFireballPoof.ID, mod.FF.AmonFireballPoof.Var, 0, projectile.Position, Vector.Zero, projectile)
		poof.SpriteOffset = Vector(0, projectile.Height)
	end
end, mod.FF.AmonFireball.Var)

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_RENDER, function(_, projectile)
	local alpha = math.min(0.5, projectile.FrameCount / 480)
	mod.RenderCircle(projectile.Position, 90, 32, KColor(1, 0.5, 0, alpha))
end, mod.FF.AmonFireball.Var)

mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, function(_, projectile, entity)
	if entity.Type == 1 then
		sfx:Play(SoundEffect.SOUND_WAR_LAVA_DASH)
		sfx:Play(SoundEffect.SOUND_SIREN_MINION_SMOKE)

		local poof = Isaac.Spawn(mod.FF.AmonFireballPoof.ID, mod.FF.AmonFireballPoof.Var, 0, projectile.Position, Vector.Zero, projectile)
		poof.SpriteOffset = Vector(0, projectile.Height)
	end
end, mod.FF.AmonFireball.Var)

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, projectile)
	if projectile:IsDead() and projectile:GetData().amonSkippingTear then
		sfx:Play(SoundEffect.SOUND_BONE_BREAK)
	end
end, ProjectileVariant.PROJECTILE_BONE)

mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, function(_, projectile, entity)
	if entity.Type == 1 and projectile:GetData().amonSkippingTear then
		sfx:Play(SoundEffect.SOUND_BONE_BREAK)
	end
end, ProjectileVariant.PROJECTILE_BONE)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, effect)
	effect.SubType = effect.SubType > 0 and effect.SubType or rng:RandomInt(3) + 1

	local anim = getAshpileAnimFromSubType(effect.SubType)
	effect:GetSprite():Play(anim)
end, mod.FF.Ashpile.Var)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
	local room = game:GetRoom()
	local tile = room:GetGridIndex(effect.Position)

	for i = -1, 1, 2 do
		local check = tile + i
		local grid = room:GetGridEntity(check)
		if grid and grid:GetType() == GridEntityType.GRID_TRAPDOOR then
			doAshpileBreak(effect)
			return
		end
	end

	for _, player in pairs(Isaac.FindByType(1)) do
		if player.Position:Distance(effect.Position) < mod.AmonAshpileSizes[effect.SubType] / mod.AshpileSizeMultiplier then
			doAshpileBreak(effect)
		end
	end
end, mod.FF.Ashpile.Var)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
	if effect:GetSprite():IsFinished("Idle") then
		effect:Remove()
	end
end, mod.FF.AmonFireballPoof.Var)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, amount, flags, source, cooldown)
	if npc.Variant == mod.FF.Amon.Var then
		if npc:GetSprite():IsPlaying("Outro") then
			return false
		end

		for _, arm in pairs(Isaac.FindByType(mod.FF.AmonArm.ID, mod.FF.AmonArm.Var)) do
			arm:TakeDamage(10, flags | DamageFlag.DAMAGE_CLONES, source, cooldown)
		end
	elseif npc.Variant == mod.FF.BreathsHead.Var then
		return false
	end
end, mod.FF.Amon.ID)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, npc, amount, flags, source, cooldown)
	if npc.Variant == mod.FF.AmonArm.Var then
		if flags & DamageFlag.DAMAGE_CLONES == 0 then
			return false
		end
	end
end, mod.FF.AmonArm.ID)

mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, function(_, npc, collider)
	if npc.Variant == mod.FF.BreathsHead.Var and collider.Type ~= 1 then
		return true
	end
end, mod.FF.BreathsHead.ID)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
	local sprite = effect:GetSprite()
	if sprite:IsFinished("Appear") then
		sprite:Play("Idle")
	end

	effect.DepthOffset = 1000
end, mod.FF.DustOverlay.Var)

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, proj)
	if proj.FrameCount <= 1 and proj:GetData().amonSkippingTear then
		proj.FallingSpeed = -10
		proj.FallingAccel = 1
	end

	if proj:GetData().amonSkippingTear then
		if proj.FallingSpeed * 2 + proj.Height > 0 then
			proj.FallingSpeed = -1.85 * proj.FallingSpeed

			sfx:Play(499)
		end
	end

	if proj:GetData().amonRealBounceTear then
		local pos = gridAlignPosition(proj.Position + proj.Velocity)
		local room = game:GetRoom()
		if room:GetGridCollisionAtPos(pos) >= GridCollisionClass.COLLISION_WALL then
			if math.abs(pos.X - proj.Position.X) > math.abs(pos.Y - proj.Position.Y) then
				proj.Velocity = Vector(-proj.Velocity.X, proj.Velocity.Y)
			else
				proj.Velocity = Vector(proj.Velocity.X, -proj.Velocity.Y)
			end
		end
	end
end)