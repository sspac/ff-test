local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_UPDATE, function(_, f, c)
    f:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
end, mod.ITEM.FAMILIAR.BABY_ORB)

local rareStrawberryForms = {
	"gfx/items/collectibles/sacred/Collectibles_CrushedCookie.png",
	"gfx/items/collectibles/collectibles_001_thesadonion.png",
	"gfx/items/collectibles/questionmark.png",
	"gfx/items/collectibles/collectible_strange_red_object.png",
	"gfx/items/collectibles/collectibles_crushing_anxiety_old.png",
	"gfx/items/collectibles/collectibles_terror_engine.png",
	"gfx/items/collectibles/collectible_nendoroid.png",
	"gfx/items/collectibles/bresh_003_UNUSED.png",
	"gfx/items/collectibles/hi_horse.png",
	"gfx/items/collectibles/collectible_pak_choi_old.png",
	"gfx/items/trinkets/trinket_internalized_hatred_old.png",
	"gfx/items/trinkets/008_tweezers_temp.png",
	"gfx/items/trinkets/bonuspennies/blank_penny.png",
	"gfx/items/trinkets/bonuspennies/mysterious_star_penny_of_truth.png",
	"gfx/characters/player2/538_baby_rock.png",
	"gfx/grid/rocks_basement.png",
	"gfx/grid/rocks_cellar.png",
	"gfx/ui/death enemies horf.png",
	"gfx/ui/emotewheel waawaad.png",
	"gfx/ui/inaba_quest_icon.png",
	"gfx/ui/ui_ffcompletionwidget.png",
	"gfx/ui/bosshp_icons/ff/corrupted_larry_jr_segment.png",
	"gfx/ui/bosshp_icons/ff/mo.png",
	"gfx/ui/achievement/group_icons/icon_golem.png",
	"gfx/ui/achievement/group_icons/icon_misc.png",
	"gfx/ui/ff_developers/shampoobottle.png",
	"gfx/bosses/geminis_ball.png",
	"gfx/familiar/inabasatellite/inaba_satellite old.png",
	"gfx/effects/devildagger_glow.png",
	"gfx/effects/divine_vengeance_orb.png",
	"gfx/effects/darknessdance.png",
	"gfx/effects/effect_deudlyfirearm.png",
	"gfx/effects/effect_orange_juice_tiles.png",
	"gfx/effects/golem_target.png",
	"gfx/effects/hydrokinesis_floating_knife.png",
	"gfx/projectiles/Flyball.png",
	"gfx/projectiles/skull_shot.png",
	"gfx/projectiles/music_notes_miku.png",
	"gfx/enemies/mite/monster_mite.png",
}

local function babyOrbOnTeleport(fam, d, sprite)
	--Occasionally reveal true form
	--Change form
	if (d.changedForm or d.isOrb) then
		if d.changedForm then
			sprite:ReplaceSpritesheet(1, "gfx/items/collectibles/collectible_strawberry.png")
			sprite:LoadGraphics()
			d.changedForm = false
		end
		if d.isOrb then
			d.isOrb = false
		end
	elseif math.random(5) == 1 then
		if math.random(100) == 1 then
			d.isOrb = true
		else
			local newForm = "gfx/items/collectibles/sacred/strawberry.png"
			if math.random(5) == 1 then
				newForm = rareStrawberryForms[math.random(#rareStrawberryForms)]
			end
			sprite:ReplaceSpritesheet(1, newForm)
			sprite:LoadGraphics()
			d.changedForm = true
		end
	end
	--Sound
	sfx:Play(SoundEffect.SOUND_BEEP,0.5,0,false,math.random(5,20)/100)
	--Yay particles!
	for i = 30, 360, 30 do
		local expvec = Vector(0,math.random(10,15)):Rotated(i)
		local sparkle = Isaac.Spawn(1000, 1727, 0, fam.Position + expvec * 0.1, expvec * 0.3, fam):ToEffect()
		sparkle.SpriteOffset = Vector(0,-25)
		sparkle:Update()
	end

	if d.SetSpriteScale then
		d.SetSpriteScale = nil
		fam.SpriteScale = Vector.One
	end
end

local function getCompletelyRandomFoe(fam)
	local enemies = Isaac.FindInRadius(fam.Position, 300, EntityPartition.ENEMY)
	if #enemies > 0 then
		return enemies[math.random(#enemies)]
	end
end

local function addRandomStatus(npc, fam, famPlayer)
	local player = famPlayer or fam.Player
	local rand = math.random(24)
	local duration = math.random(240)
	if rand == 1 then
		npc:AddBurn(EntityRef(player), duration, player.Damage * 0.2)
	elseif rand == 2 then
		npc:AddCharmed(EntityRef(player), duration)
	elseif rand == 3 then
		npc:AddConfusion(EntityRef(player), duration)
	elseif rand == 4 then
		npc:AddFear(EntityRef(player), duration)
	elseif rand == 5 then
		npc:AddFreeze(EntityRef(player), duration)
	elseif rand == 6 then
		npc:AddMidasFreeze(EntityRef(player), duration)
	elseif rand == 7 then
		npc:AddPoison(EntityRef(player), duration, player.Damage * 0.2)
	elseif rand == 8 then
		npc:AddShrink(EntityRef(player), duration)
	elseif rand == 9 then
		npc:AddSlowing(EntityRef(player), duration, 0.6, Color(1.2,1.2,1.2,1,0,0,0.1))
	elseif rand == 10 then
		npc:AddBaited(EntityRef(player), duration)
	elseif rand == 11 then
		npc:AddBleeding(EntityRef(player), duration)
	elseif rand == 12 then
		FiendFolio.AddBerserk(npc, player, duration)
	elseif rand == 13 then
		FiendFolio.AddBleed(npc, player, duration, player.Damage * 0.5)
	elseif rand == 14 then
		FiendFolio.AddBruise(npc, player, duration, 1, 1)
	elseif rand == 15 then
		FiendFolio.AddDrowsy(npc, player, math.ceil(duration/3), duration)
	elseif rand == 16 then
		FiendFolio.MarkForMartyrDeath(npc, player, duration, false)
		FiendFolio.AddExcommunicated(npc, player, math.ceil(duration/2), player.Damage)
	elseif rand == 17 then
		FiendFolio.AddSewn(npc, player, duration, nil, nil, 0.5)
	elseif rand == 18 then
		local ptrhash = GetPtrHash(npc)
		mod.QueuedStatusApply[ptrhash] = mod.QueuedStatusApply[ptrhash] or {}
		table.insert(mod.QueuedStatusApply[ptrhash], function()
			if mod:CanApplyDoom(npc, player) then
				FiendFolio.AddDoom(npc, player, duration, 3, player.Damage * 4)
			end
		end)
	elseif rand == 19 then
		FiendFolio.AddMultiEuclidean(npc, player, duration)
	elseif rand == 20 then
		FiendFolio.AddOverloaded(npc, player, 0, math.random(5), player.Damage * 0.4, 45, 15, true)
	elseif rand == 21 then
		FiendFolio.AddMugged(npc, player, duration)
	elseif rand == 22 then
		FiendFolio.AddPacified(npc, player, duration)
	elseif rand == 23 then
		FiendFolio.AddNursing(npc, player, duration)
	--[[elseif rand == 24 then
		mod:GetEntityData(npc).DownloadFailuredManually = true]]
	end
end

local function getPlayerItemPosition(player)
	--I can't really use the null position, it's only on Pickup, not the other anims
	return Vector(0,-37) * player.SpriteScale
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
	local player = fam.Player
	local d = mod:GetEntityData(fam)
	local sprite = fam:GetSprite()

	if not d.init then
		d.init = true
	end
	d.stateframe = d.stateframe or 0
	d.stateframe = d.stateframe + 1

	if d.MamasHere and not d.trackedTarget then
		if d.MamasHere:Exists() then
			local md = mod:GetEntityData(d.MamasHere)
			if md.DingCount and md.DingCount >= 5 then
				fam.Velocity = mod:Lerp(fam.Velocity, (d.MamasHere.Position - fam.Position):Resized(-25), 0.25)
			elseif md.MamaRotation and d.MamaIndex then
				d.MamaExtraOffset = d.MamaExtraOffset or Vector.Zero
				d.MyMamaRotationSide = d.MyMamaRotationSide or (math.random(3) - 2)
				if math.random(60) == 1 then
					d.MamaExtraOffset = Vector(math.random(50),math.random(50))
					d.MyMamaRotationSide = (math.random(3) - 2)
					d.SpeedLimit = math.random(10)
				end
				d.MyMamaRotation = d.MyMamaRotation or math.random(360)
				d.MyMamaRotation = d.MyMamaRotation + ((math.random() * 10) * d.MyMamaRotationSide)
				local dist = 120
				if md.DingCount then
					dist = dist + md.DingCount * 30
				end
				local targetPos = d.MamasHere.Position + Vector(dist, 0):Rotated(md.MamaRotation):Rotated(360 * d.MamaIndex) + d.MamaExtraOffset:Rotated(d.MyMamaRotation)
				local targVec = targetPos - fam.Position
				local speedLimit = 5
				if md.DingCount then
					speedLimit = speedLimit + md.DingCount * 5
				end
				if targVec:Length() > speedLimit then
					targVec = targVec:Resized(speedLimit)
				end
				fam.Velocity = mod:Lerp(fam.Velocity, targVec, 0.25)
				if math.random(300) == 1 and md.DingCount and md.DingCount == 0 then
					d.trackedTarget = d.MamasHere
				end
			end
		else
			d.MamasHere = nil
		end
	elseif d.Appearing then
		d.Appearing = d.Appearing + 1
		local pos = player.Position + getPlayerItemPosition(player)
		fam.DepthOffset = 50
		fam.Velocity = mod:Lerp((pos - fam.Position), fam.Velocity, 0.5)
		if d.Appearing > 30 then
			d.Appearing = nil
		end
	else
		d.target = d.target or nil
		if d.trackedTarget and d.trackedTarget:Exists() then
			d.target = d.trackedTarget.Position
		end
		if d.target then
			if fam.Position:Distance(d.target) < 20 then
				if math.random(3) == 1 then
					d.target = nil
					d.stateframe = 0
				else
					d.target = Isaac.GetRandomPosition()
					if math.random(3) == 1 then
						fam.Position = d.target
						babyOrbOnTeleport(fam, d, sprite)
					else
						fam.Velocity = ((d.target or fam.Position) - fam.Position):Resized(fam.Velocity:Length())
					end
				end
			end
		else
			if (d.stateframe >= 0 and math.random(60) == 1) or d.stateframe > 120 then
				d.target = Isaac.GetRandomPosition()
				if math.random(5) == 1 then
					local foe = getCompletelyRandomFoe(fam)
					if foe then
						d.trackedTarget = foe
					end
				end
				if math.random(3) == 1 then
					fam.Position = d.target
					babyOrbOnTeleport(fam, d, sprite)
				end
			end
			fam.Velocity = fam.Velocity * 0.95
		end
		fam.Velocity = mod:Lerp(fam.Velocity, ((d.target or fam.Position) - fam.Position):Resized(15), 0.05)
	end


	d.frame = d.frame or 0
	if d.isOrb then
		local speed = math.max(math.floor(fam.Velocity:Length() / 3), 1)
		if fam.Velocity.X > 0 then
			d.frame = d.frame + speed
		else
			d.frame = d.frame - speed
		end
		d.frame = d.frame % 120
		sprite:SetFrame("Orb", d.frame)
		if math.random(100) == 1 and (not d.MamasHere) then
			d.isOrb = false
			for i = 30, 360, 30 do
				local expvec = Vector(0,math.random(10,15)):Rotated(i)
				local sparkle = Isaac.Spawn(1000, 1727, 0, fam.Position + expvec * 0.1, expvec * 0.3, fam):ToEffect()
				sparkle.SpriteOffset = Vector(0,-25)
				sparkle:Update()
			end
		end
	else
		if d.Appearing then
			mod:spritePlay(sprite, "Idle")
		else
			mod:spritePlay(sprite, "IdleFloat")
		end
	end

	if d.SetSpriteScale then
		d.SetSpriteScale = mod:Lerp(d.SetSpriteScale, 1, 0.02)
		fam.SpriteScale = Vector.One * d.SetSpriteScale
	end

end, mod.ITEM.FAMILIAR.BABY_ORB)

mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, function(_, fam, collider)
	if collider.Type > 9 and collider.EntityCollisionClass >= 2 then
		local d = mod:GetEntityData(fam)
		if d.stateframe and d.stateframe >= 0 then
			d.target = nil
			d.trackedTarget = nil
			d.stateframe = 0 - math.random(15)
			fam.Velocity = fam.Velocity * -1
			if fam.Velocity:Length() < 1 then
				fam.Velocity = (fam.Position - collider.Position):Resized(10)
			end
			fam.Color = Color(math.random(),math.random(),math.random(),1,math.random(),math.random(),math.random())
			sfx:Play(SoundEffect.SOUND_BEEP,1,0,false,math.random(5,20)/100)
			local famPlayer = fam.Player
			addRandomStatus(collider, fam, famPlayer)
			local damageDone = fam.Velocity:Length() * (famPlayer.Damage/3.5)
			if fam.Player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
				damageDone = damageDone * 2
			end
			collider:TakeDamage(damageDone, 0, EntityRef(fam), 0)

			if collider.Type == mod.FF.MotherOrb.ID and collider.Variant == mod.FF.MotherOrb.Var then
				if not d.isOrb then
					d.isOrb = true
				end
				game:ShakeScreen(1)
				collider.Color = Color(math.random(200)/100, math.random(200)/100, math.random(200)/100, 1, 0, 0, 0)
			end
		end
	end
end, mod.ITEM.FAMILIAR.BABY_ORB)

function mod:badDataPlayerUpdate(player, data, sdata)
	if data.PickingUpBAD_DATA then
		data.PickingUpBAD_DATA = data.PickingUpBAD_DATA + 1
		if data.PickingUpBAD_DATA > 2 then
			local sprite = player:GetSprite()
			local anim, frame = sprite:GetAnimation(), sprite:GetFrame()
			--print(anim, data.PickingUpBAD_DATA)
			if data.PickingUpBAD_DATA >= 70 then
				local newStrawbs = player:CheckFamiliarEx(mod.ITEM.FAMILIAR.BABY_ORB, mod.GetExpectedFamiliarNum(player, mod.ITEM.COLLECTIBLE.BAD_DATA) + 1, player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.BAD_DATA), Isaac.GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.BAD_DATA))
				for _, fam in pairs(newStrawbs) do
					fam.Position = player.Position + getPlayerItemPosition(player)
					fam:GetSprite():Play("IdleFloat")
					mod:GetEntityData(fam).Appearing = 0
					if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
						mod:GetEntityData(fam).SetSpriteScale = 0.8
					end
					fam:Update()
				end
				data.PickingUpBAD_DATA = nil
			end
		end
	end
end