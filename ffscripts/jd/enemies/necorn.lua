local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local params = ProjectileParams()
params.Variant = ProjectileVariant.PROJECTILE_BONE

function mod:NecornAI(npc, sprite, data)
	local target = npc:GetPlayerTarget()
	local targetpos = mod:confusePos(npc, target.Position)
	local room = game:GetRoom()
	--print(npc.GridCollisionClass)
	
	if not data.Init then
        --npc.SplatColor = mod.ColorBobsGreen
		data.ffRadioactiveEnemy = true
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        data.Init = true
		data.AttackTimer = 10
		npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_BLOOD_SPLASH)
    end

	if sprite:IsFinished() then
		sprite:Play("Idle")
	end

	if data.AttackTimer <= 0 then
		sprite:Play("Attack")
		data.AttackTimer = mod:RandomInt(60, 80)
	end

	if sprite:IsEventTriggered("Summon") then
		local pos = npc.Position

		for i = 1, 5*#mod:FindRadiationAuras() do
			local rad = mod:ShuffleTable(mod:FindRadiationAuras())[1]
			local new_pos = rad.Position + Vector(Random() % (rad.Size - 20), 0):Rotated(Random() % 360)
			if rad.Size >= 5 and mod:getClosestPlayer(new_pos, 9999999).Position:Distance(new_pos) > 80 and room:CheckLine(new_pos, targetpos, 0, 950) and room:GetGridPathFromPos(new_pos) < 950 and new_pos:Distance(npc.Position) > 40 then
				pos = new_pos
				break
			end
		end

		local proj = npc:FireProjectilesEx(pos, Vector(0,0), 0, params)[1]
		
		
		proj.FallingAccel = -0.1
		proj.FallingSpeed = 0
		proj.Height = -5
		proj.DepthOffset = 20
		local pSprite = proj:GetSprite()
		proj:GetSprite():Load("gfx/bosses/propaganda/projectile_organ.anm2", true)
		--proj:GetSprite():Play("Move")
		pSprite:ReplaceSpritesheet(0, "gfx/projectiles/popcornbone.png", true)
		mod:GetEntityData(proj).ffBonePopcornTarget = targetpos
		sfx:Play(SoundEffect.SOUND_PORTAL_SPAWN, 0.5)

		local e = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WATER_RIPPLE, 0, pos, Vector(0,0), proj):ToEffect()
		local color = Color(1,1,1,1,0.3,1,0)
		color:SetColorize(1,1,1,1)
		e.Color = color
		e.DepthOffset = 5

		proj.Color = color
	end

	npc.Velocity = Vector.Zero
	local idx = room:GetGridIndex(npc.Position)
	room:SetGridPath(idx, math.max(room:GetGridPath(idx),900))
	data.AttackTimer = data.AttackTimer - 1
	mod:SetRadioactiveAura(npc, 5)
end

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, proj)
	if mod:GetEntityData(proj).ffBonePopcornTarget then
		if proj.Velocity:Length() == 0 then
			proj.Height = mod:Lerp(proj.Height, -40, 0.1)
			if proj.FrameCount >= 15 then
				proj.Velocity = (mod:GetEntityData(proj).ffBonePopcornTarget-proj.Position):Resized(10)

				local dist = mod:GetEntityData(proj).ffBonePopcornTarget:Distance(proj.Position)
				if dist < 120 then 
					dist = (120-dist)/240
				else
					dist = 0
				end
				proj.FallingAccel = -0.035+dist+mod:TrueRandomFloat(entrng)*0.1
				sfx:Play(SoundEffect.SOUND_SCAMPER)
				proj.DepthOffset = 0
			end 
		elseif proj.Height > -25 then
			proj.FallingSpeed = 1
			proj.Velocity = mod:Lerp(proj.Velocity, Vector.Zero, 0.15)
		end
		
		proj.Color = Color.Lerp(proj.Color, Color.Default, 0.1)
		if proj.FrameCount % 2 == 0 then
			local pos = proj.Position + RandomVector() * 5 * ((Random() % 101)/100)
			local vel = mod.nilvector
			local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HAEMO_TRAIL, 0, pos, vel, proj):ToEffect()
			--trail:GetSprite().PlaybackSpeed = 0.5
			trail.SpriteScale = Vector(1, 1) * proj.Scale
			trail.PositionOffset = Vector(0, proj.Height - 2.5)
			local color = Color(1,1,1,1,0.3,1,0)
			color:SetColorize(1,1,1,1)
			trail.Color = color
			trail:Update()
			trail.DepthOffset = -10
		end
	end
end, ProjectileVariant.PROJECTILE_BONE)

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_DEATH, function(_, proj)
	if mod:GetEntityData(proj).ffBonePopcornTarget then
		sfx:Play(SoundEffect.SOUND_BONE_BREAK)
		for i = 1, 6 do
			local vel = Vector(10, 0):Rotated(360 * i/6)
			local new = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_BONE, 0, proj.Position + vel:Resized(10) - proj.Velocity:Resized(5), vel, proj):ToProjectile()
			new.ProjectileFlags = proj.ProjectileFlags
		end
	end
end, ProjectileVariant.PROJECTILE_BONE)