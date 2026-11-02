local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

function mod:bucketheadAI(npc, subType)
	local sprite = npc:GetSprite()
	local path = npc.Pathfinder
	local d = mod:GetEntityData(npc)
	local target = npc:GetPlayerTarget()
	local targetpos = mod:randomConfuse(npc, target.Position)

	if not d.triedReplacing then
		d.triedReplacing = true
		if math.random(3) == 1 then
			local stringRep = "bloodbuckethead"
			if mod.roomBackdrop == 9 then
				stringRep = stringRep .. "_pee"
			elseif mod.isBackdrop("Dross") then
				stringRep = stringRep .. "_dross"
			end
			sprite:ReplaceSpritesheet(1, "gfx/enemies/bucketheaddeep/" .. stringRep .. ".png")
			sprite:LoadGraphics()
		end
		d.bucketed = true
	end

	if subType == 1 then
		if not sprite:IsPlaying("Bonk") then
			mod:spritePlay(sprite, "Idle")
		elseif sprite:IsEventTriggered("Clunk") then
			npc:PlaySound(mod.Sounds.PvZBucket, 0.5, 0, false, math.random(90,110)/100)
		end
		if not d.init then
			npc.CollisionDamage = 0
			npc.TargetPosition = npc.Position
			npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET)
			npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
			d.init = true
		end
		npc.Position = npc.TargetPosition
		npc.Velocity = nilvector

		if mod.CanIComeOutYet() then
			npc.StateFrame = npc.StateFrame + 1
			if (npc.StateFrame > 15 and math.random(10) == 1 or npc.StateFrame > 30) and mod.farFromAllPlayers(npc.Position, 60) then
				if math.random(5) == 1 and not d.bonkedHead then
					d.bonkedHead = true
					sprite:Play("Bonk")
					npc.StateFrame = -10
				else
					npc:ClearEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET)
					mod:spritePlay(sprite, "Ambush1")
					npc.SubType = 0
					npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
					npc.CollisionDamage = 1
				end
			end
		else
			mod.QuickSetEntityGridPath(npc, 3999)
		end
	else
		if sprite:IsPlaying("Ambush1") then
			npc.Velocity = nilvector
			if sprite:IsEventTriggered("Splash") then
				if game:GetRoom():HasWater() then
					npc:PlaySound(SoundEffect.SOUND_BOSS2_DIVE, 0.8, 0, false, math.random(80, 90)/100)
				else
					npc:PlaySound(SoundEffect.SOUND_FETUS_JUMP, 1.1, 0, false, math.random(80, 90)/100)
				end
			end
		else
			if npc.Velocity:Length() > 0.1 then
				npc:AnimWalkFrame("WalkHori","WalkVert",0)
			else
				sprite:SetFrame("WalkVert", 0)
			end
			mod:spriteOverlayPlay(sprite, "Head")

			if mod:isScare(npc) then
				local targetvel = (targetpos - npc.Position):Resized(-6)
				npc.Velocity = mod:Lerp(npc.Velocity, targetvel,0.25)
			elseif game:GetRoom():CheckLine(npc.Position,targetpos,0,1,false,false) then
				local targetvel = (targetpos - npc.Position):Resized(4)
				npc.Velocity = mod:Lerp(npc.Velocity, targetvel,0.25)
			else
				path:FindGridPath(targetpos, 0.6, 900, true)
			end

			if d.bucketed and PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_MAGNETO) then
				d.bucketmagnet = Isaac.Spawn(1000, 7006, 0, npc.Position, Vector(0,0), npc):ToEffect()
				mod:GetEntityData(d.bucketmagnet).parent = npc
				npc:PlaySound(SoundEffect.SOUND_LIGHTBOLT_CHARGE, 1, 0, false, 1)
				npc:ToNPC():Morph(10, 0, 960, -1)
				npc.HitPoints = npc.MaxHitPoints
				npc:GetSprite():SetOverlayFrame("Head", 19)
				if mod.isBackdrop("Dross") then
					npc:GetSprite():ReplaceSpritesheet(1, "gfx/enemies/bucketheaddeep/bucketless_dross.png")
					npc:GetSprite():LoadGraphics()
				end
				d.bucketed = false
			end
		end
	end

	if npc:IsDead() and d.bucketed then
		for i = 90, 360, 90 do
			local bucketGib = Isaac.Spawn(1000, 4, 0, npc.Position, Vector(mod:RandomInt(15,30)/10, 0):Rotated(i + mod:RandomInt(45)), nil)
			bucketGib:GetSprite():SetFrame("rubble_alt", mod:RandomInt(4))
			bucketGib:Update()
			npc:PlaySound(SoundEffect.SOUND_POT_BREAK, 1, 0, false, 1)
		end
		d.bucketed = false
	end
end

function mod:bucketheadHurt(npc, damage, flag, source)
    if npc.SubType == 1 then
		if mod:HasDamageFlag(DamageFlag.DAMAGE_EXPLOSION, flag) then
			npc:Kill()
		else
        	return false
		end
    else
        local d = mod:GetEntityData(npc)
        npc:SetColor(Color(2,2,2,1,0,0,0),5,2,true,false)
        if npc.HitPoints > npc.MaxHitPoints / 2 then
            npc:ToNPC():PlaySound(mod.Sounds.PvZBucket, 1, 0, false, math.random(90,110)/100)
        else
            for i = 90, 360, 90 do
                local bucketGib = Isaac.Spawn(1000, 4, 0, npc.Position, Vector(math.random(15,30)/10, 0):Rotated(i + math.random(45)), nil)
                bucketGib:GetSprite():SetFrame("rubble_alt", math.random(4))
                bucketGib:Update()
                bucketGib:GetSprite():SetFrame("rubble_alt", math.random(4))
            end
            npc:ToNPC():PlaySound(SoundEffect.SOUND_POT_BREAK, 1, 0, false, 1)
            npc:ToNPC():Morph(10, 0, 960, -1)
            npc.HitPoints = npc.MaxHitPoints
            npc:GetSprite():SetOverlayFrame("Head", 19)
			if mod.isBackdrop("Dross") then
				npc:GetSprite():ReplaceSpritesheet(1, "gfx/enemies/bucketheaddeep/bucketless_dross.png")
				npc:GetSprite():LoadGraphics()
			end
			d.bucketed = false
            return false
        end
    end
end

function mod:wispBucketheadCollision(wisp, collider)
	if collider then
		if collider.Type == mod.FF.Buckethead.ID and collider.Variant == mod.FF.Buckethead.Var and collider.SubType == mod.FF.BucketheadWait.Sub then
			return true
		end
	end
end

mod:AddEntityCallback(
	ModCallbacks.MC_PRE_FAMILIAR_COLLISION,
	mod.FF.Buckethead.ID, mod.FF.Buckethead.Var, mod.FF.BucketheadWait.Sub,
	mod.wispBucketheadCollision, FamiliarVariant.WISP
)
mod:AddEntityCallback(
	ModCallbacks.MC_PRE_FAMILIAR_COLLISION,
	mod.FF.Buckethead.ID, mod.FF.Buckethead.Var, mod.FF.BucketheadWait.Sub,
	mod.wispBucketheadCollision, FamiliarVariant.ITEM_WISP
)


function mod:clearGridCollonRemove(npc)
	mod.QuickSetEntityGridPath(npc, 0)
end

--hi i invaded to add this -hippo
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, e)
	e:GetSprite():Play("Idle")
	mod:GetEntityData(e).player = PlayerManager.FirstCollectibleOwner(CollectibleType.COLLECTIBLE_MAGNETO)

	if (mod:GetEntityData(e).parent and mod:GetEntityData(e).parent:IsDead() and game:GetRoom():IsClear()) or not mod:GetEntityData(e).player then
		for i = 90, 360, 90 do
			local bucketGib = Isaac.Spawn(1000, 4, 0, e.Position, Vector(mod:RandomInt(15,30)/10, 0):Rotated(i + mod:RandomInt(45)), nil)
			bucketGib:GetSprite():SetFrame("rubble_alt", mod:RandomInt(4))
			bucketGib:Update()
			sfx:Play(SoundEffect.SOUND_POT_BREAK)
		end
		e:Remove()
		return
	end

	mod:GetEntityData(e).pos = mod:GetEntityData(e).player.Position
	mod:GetEntityData(e).offset = mod:GetEntityData(e).offset or Vector(mod:RandomInt(-15,15),mod:RandomInt(-15,15))
	e.PositionOffset = Vector(0,-30) + mod:GetEntityData(e).offset
	e.DepthOffset = 40
	if e.Position:Distance(mod:GetEntityData(e).player.Position) > 30 then
		e.Position = mod:Lerp(e.Position, mod:GetEntityData(e).player.Position, 0.2)
	else
		e.Position = mod:Lerp(e.Position, mod:GetEntityData(e).player.Position, 0.5)
	end
	e.Velocity = mod:GetEntityData(e).player.Velocity
end, 7006)