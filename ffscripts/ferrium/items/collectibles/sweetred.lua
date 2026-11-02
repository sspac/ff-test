local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local sBal = {
    dropChance = {20, 50},
    healthMin = 6,

    upgradeThresh = {5, 10, 15, 20, 5},
	bunchDropChance = 19,
	pityDrop = 5,

	chargeTime = 15,
	lobScale = 1.25,
	lobFallAccel = 0.85,
	lobFallSpeed = -17,
	lobSpeed = 8,
	lobDamageFlat = 40,
	extraDamage = 17,
	poisonRadius = 50,
	poisonDur = 80,
	poisonDamagePlus = 5,
	poisonGasVel = {5,15},
	poisonGasDur = {130, 180},
	poisonGasSize = {0.3, 50, 80},
	poisonGasDamMult = 1,
	poisonGasNum = 3,

	upgrade2Shots = 6,
	upgrade3Shots = 11,
	splatterSpeed = {45,90},
	splatterVar = 20,
	splatterVarIncrease = 30,
	splatterFallSpeed = {11,17},
	splatterAccel = 1.3,
	splatterScale = {50,90},
	splatterGreens = 0.55, --how many shots are green versus bloody
	splatterDamageMult = 1,
	splatterDamageFlat = 5,
	creepTimeout = 140,
	creepDamageMult = 1,

	snareRange = 150,
	snareKeepClose = 80,
	snareDur = 220,
}

--1 - gas
--2 - extra vomit
--3 - buffed vomit
--4 - vine
--5+ - extra damage

function mod:sweetRedUpdate(player, d)
	local sd = d.ffsavedata.RunEffects

	if sd.SweetRedShot and sd.SweetRedShot > 0 and not d.FFCurseMistCheck then
		d.CustomChargeBarExtra = d.CustomChargeBarExtra or {}
		if not d.CustomChargeBarExtra[mod.ITEM.COLLECTIBLE.SWEET_RED] then
			d.CustomChargeBarExtra[mod.ITEM.COLLECTIBLE.SWEET_RED] = {id = mod.ITEM.COLLECTIBLE.SWEET_RED, Priority = 1, anm2 = "gfx/ui/chargebars/chargebar_sweet_red.anm2", maxTime = sBal.chargeTime, special = true}
			mod:EvaluateExtraChargeBar(player)
		end
	end
end

mod:AddCallback("FF_EXTRA_CHARGE_CIRCLE_FIRED", function(_, player, entry, d)
	--print("fired")
	local sd = d.ffsavedata.RunEffects
	local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.SWEET_RED)
	local sMult = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND)+1
	local dir = entry.dir
	local inh = player:GetTearMovementInheritance(dir)
	local vel = dir:Resized(sBal.lobSpeed)+inh
	local tear = Isaac.Spawn(2, 0, 0, player.Position, vel, player):ToTear()
	tear.Scale = sBal.lobScale
	-- | TearFlags.TEAR_POISON
    tear:AddTearFlags(TearFlags.TEAR_EXPLOSIVE)
	tear.FallingAcceleration = sBal.lobFallAccel
	tear.FallingSpeed = sBal.lobFallSpeed
	sd.SweetRedBonus = sd.SweetRedBonus or 0
	if sd.SweetRedBonus >= sBal.upgradeThresh[4] then
		tear:GetSprite():ReplaceSpritesheet(0, "gfx/projectiles/sweetred_shot.png")
		tear:GetSprite():LoadGraphics()
	else
		tear.Color = Color(0.5, 0.9, 0.4, 1)
	end

	tear.CollisionDamage = tear.CollisionDamage+sBal.lobDamageFlat
	if sd.SweetRedBonus >= sBal.upgradeThresh[4] then
		local extra = math.floor((sd.SweetRedBonus-sBal.upgradeThresh[4])/sBal.upgradeThresh[5])
		tear.CollisionDamage = tear.CollisionDamage+sBal.extraDamage*extra
	end

	local tab = {death = function(t)
	local splat = Isaac.Spawn(1000, EffectVariant.BLOOD_SPLAT, 0, t.Position, Vector.Zero, t):ToEffect()
	splat.Color = Color(0.02, 0.9, 0.02, 1, 0, 0.33, 0)

	if sd.SweetRedBonus >= sBal.upgradeThresh[1] then
		for i=1,sBal.poisonGasNum do
			local rangle = rng:RandomInt(360)
				local spd = mod:RandomInt(sBal.poisonGasVel[1], sBal.poisonGasVel[2], rng)/10
				local cloud = Isaac.Spawn(1000, 141, 0, t.Position, Vector(0,spd):Rotated(rangle), player):ToEffect()
				cloud.Parent = player
				cloud.SpriteScale = Vector(sBal.poisonGasSize[1], sBal.poisonGasSize[1])
				cloud.CollisionDamage = player.Damage*sBal.poisonGasDamMult
				local time = mod:RandomInt(sBal.poisonGasDur[1], sBal.poisonGasDur[2], rng)
				local limit = mod:RandomInt(sBal.poisonGasSize[2], sBal.poisonGasSize[3], rng)/100
				mod:GetEntityData(cloud).moveGasInfo = {vel = Vector(0,spd):Rotated(rangle), accel = 0.965, timeout = time, grow = 0.05, growLimit = limit}
			end
		end

		if sd.SweetRedBonus >= sBal.upgradeThresh[4] then
			local vine = Isaac.Spawn(3, mod.ITEM.FAMILIAR.SWEET_RED_BRAMBLE, 0, t.Position, Vector.Zero, player):ToFamiliar()
			vine.Player = player
		end

		for _,enemy in ipairs(Isaac.FindInRadius(tear.Position, sBal.poisonRadius, EntityPartition.ENEMY)) do
			if enemy:IsActiveEnemy() and (not mod:isFriend(enemy)) and not enemy:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) then
				enemy:AddPoison(EntityRef(tear), sBal.poisonDur*sMult, player.Damage+sBal.poisonDamagePlus)
			end
		end
	end}
	mod:TryToAddTearBehavior(tear, mod:GetEntityData(tear), tab)

	if sd.SweetRedBonus >= sBal.upgradeThresh[2] then
		local shotCount = (sd.SweetRedBonus >= sBal.upgradeThresh[3] and sBal.upgrade3Shots) or sBal.upgrade2Shots
		for i=1,shotCount do
			local var = 0
			if (sd.SweetRedBonus >= sBal.upgradeThresh[3] and i > shotCount*sBal.splatterGreens) then
				var = 1
			end
			local ang = (sd.SweetRedBonus >= sBal.upgradeThresh[3] and sBal.splatterVar2) or sBal.splatterVar
			local vel2 = dir:Resized(mod:RandomInt(sBal.splatterSpeed[1], sBal.splatterSpeed[2], rng)/10, 0):Rotated(mod:RandomInt(-ang, ang, rng))+inh
			local t = Isaac.Spawn(2, var, 0, player.Position, vel2, player):ToTear()
			t.FallingSpeed = -mod:RandomInt(sBal.splatterFallSpeed[1], sBal.splatterFallSpeed[2], rng)
			t.FallingAcceleration = sBal.splatterAccel
			t.Scale = mod:RandomInt(sBal.splatterScale[1], sBal.splatterScale[2], rng)/100
			t.CollisionDamage = player.Damage*sBal.splatterDamageMult+sBal.splatterDamageFlat

			if (sd.SweetRedBonus >= sBal.upgradeThresh[3] and i > shotCount*sBal.splatterGreens) then
				local tab1 = {death = function(t1)
					local creep = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_RED, 0, t1.Position, Vector.Zero, t1):ToEffect()
					creep.Timeout = sBal.creepTimeout
					creep.Scale = t1.Scale+mod:RandomInt(-15,35,rng)/100
					creep:Update()
				end}
				mod:TryToAddTearBehavior(t, mod:GetEntityData(t), tab1)
			else
				t.Color = Color(0.5, 0.9, 0.4, 1)
				t:AddTearFlags(TearFlags.TEAR_POISON)
			end
		end
	end

	d.CustomChargeBarExtra = d.CustomChargeBarExtra or {}
	d.CustomChargeBarExtra[mod.ITEM.COLLECTIBLE.SWEET_RED] = nil
	mod:EvaluateExtraChargeBar(player)
	sd.SweetRedShot = sd.SweetRedShot or 0
	sd.SweetRedShot = math.max(sd.SweetRedShot-1, 0)
end, mod.ITEM.COLLECTIBLE.SWEET_RED)

function mod:sweetRedDeath(npc)
	if mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.SWEET_RED, false) then
		local mult = mod.getCollectibleMultiplierAcrossAllPlayers(mod.ITEM.COLLECTIBLE.SWEET_RED)
		if not (npc.Type == mod.FFID.Tech and npc.Variant > 999) and not (npc:HasEntityFlags(EntityFlag.FLAG_NO_REWARD) or npc:HasEntityFlags(EntityFlag.FLAG_NO_DEATH_TRIGGER)) then
			local chance = math.min(mult*sBal.dropChance[1], sBal.dropChance[2])
            local rng = npc:GetDropRNG()
			if rng:RandomInt(100) < chance then
				local berry = Isaac.Spawn(5, mod.PICKUP.VARIANT.SWEET_RED_BERRY, 0, npc.Position, Vector.Zero, npc):ToPickup()
			end
		end
	end
end
mod:AddCollectibleCallback("FF_POST_NPC_DEATH_FERRIUM", mod.ITEM.COLLECTIBLE.SWEET_RED, mod.sweetRedDeath)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	local sprite = pickup:GetSprite()
	if sprite:IsFinished("Appear") then
		sprite:Play("Idle", true)
	end
	if sprite:IsFinished("Collect") then
		pickup:Remove()
	end
	if sprite:IsEventTriggered("DropSound") then
        if pickup.SubType == 0 then
		    sfx:Play(SoundEffect.SOUND_SCAMPER, 0.5, 0, false, 1.3)
        else
            sfx:Play(SoundEffect.SOUND_SCAMPER, 0.7, 0, false, 1)
        end
	end
end, mod.PICKUP.VARIANT.SWEET_RED_BERRY)

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider, low)
	if collider.Type == 1 then
		local player = collider:ToPlayer()
		if pickup:IsShopItem() and pickup.Price > collider:GetNumCoins() then
			Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, collider, low)
			return true
		else
            if pickup:GetSprite():WasEventTriggered("DropSound") or pickup:GetSprite():IsPlaying("Idle") then
                local rng = pickup:GetDropRNG()
				local data = mod:GetEntityData(player)
                local savedata = data.ffsavedata.RunEffects
				local mult = math.max(player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.SWEET_RED), 1)

                if pickup.SubType == 1 then
                    savedata.SweetRedBonus = (savedata.SweetRedBonus or 0)+1
                end
                savedata.SweetRedShot = (savedata.SweetRedShot or 0)+mult
                sfx:Play(SoundEffect.SOUND_DEATH_BURST_SMALL, 0.7, 0, false, mod:RandomInt(180,190,rng)/100)
                sfx:Play(SoundEffect.SOUND_VAMP_GULP, 0.35, 0, false, mod:RandomInt(120,140,rng)/100)
				
                pickup:GetSprite():Play("Collect")
				pickup.Velocity = Vector.Zero
				pickup.EntityCollisionClass = 0
				if pickup:IsShopItem() then
					player:AddCoins(-1 * pickup.Price)
				end

				if pickup.OptionsPickupIndex ~= 0 then
					local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP)
					for _, entity in ipairs(pickups) do
						if entity:ToPickup().OptionsPickupIndex == pickup.OptionsPickupIndex and
						   (entity.Index ~= pickup.Index or entity.InitSeed ~= pickup.InitSeed)
						then
							Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, nil)
							entity:Remove()
						end
					end
				end
			end
			Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, collider, low)
			return true
        end
    end
end, mod.PICKUP.VARIANT.SWEET_RED_BERRY)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
	local sprite = fam:GetSprite()
	local d = mod:GetEntityData(fam)
	
	if not d.Init then
		fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
		d.State = "Appear"
		d.StateFrame = 0
		mod.scheduleForUpdate(function()
			local dirt = Isaac.Spawn(mod.FF.SweetRedDirt.ID, mod.FF.SweetRedDirt.Var, mod.FF.SweetRedDirt.Sub, fam.Position, Vector.Zero, fam):ToEffect()
			dirt:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			dirt.Parent = fam
			dirt:Update()
			d.StayHere = fam.Position
		end, 1)
		d.SnaredTargets = {}
		
		d.Init = true
	else
		d.StateFrame = d.StateFrame+1
	end

	if d.StayHere then
		fam.Velocity = (d.StayHere-fam.Position)
	else
		fam.Velocity = Vector.Zero
	end

	if d.State == "Appear" then
		if sprite:IsFinished("Appear") then
			d.State = "Idle"
			d.StateFrame = 0
		elseif sprite:IsEventTriggered("Shoot") then
			d.myGuys = {}
			for _,enemy in ipairs(Isaac.FindInRadius(fam.Position, sBal.snareRange, EntityPartition.ENEMY)) do
				if enemy:IsActiveEnemy() and (not mod:isFriend(enemy)) and enemy.Mass < 100 and not mod:GetEntityData(enemy).initPos then
					local dummyeffect = mod:AddDummyEffect(fam, Vector(0,10))
					dummyeffect:Update()
					local vine = Isaac.Spawn(mod.FF.SweetRedVine.ID, mod.FF.SweetRedVine.Var, mod.FF.SweetRedVine.Sub, fam.Position, Vector.Zero, fam):ToNPC()
					vine:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					vine:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_DEATH_TRIGGER | EntityFlag.FLAG_NO_REWARD)
					vine.Parent = dummyeffect
					vine.Target = enemy
					for i=1,10 do
						vine:Update()
					end

					local d2 = mod:GetEntityData(enemy)
					d2.SweetRedVines = d2.SweetRedVines or {}
					d2.SweetRedVines[fam.InitSeed] = fam
					table.insert(d.myGuys, {Vine = vine, Enemy = enemy, Dummy = dummyeffect})
					d.grabbedGuys = true

					if not d.soundPlayed then
						d.soundPlayed = true
						sfx:Play(SoundEffect.SOUND_WHIP, 0.65, 0, false, 1.3)
					end
				end
			end
		elseif sprite:IsEventTriggered("Sound") then
			sfx:Play(SoundEffect.SOUND_GOOATTACH0, 1, 0, false, 1)
		else
			mod:spritePlay(sprite, "Appear")
		end
	elseif d.State == "Idle" then
		if d.StateFrame > sBal.snareDur or (d.myGuys and #d.myGuys == 0) then
			d.State = "Death"

			if d.myGuys then
				for id,entry in pairs(d.myGuys) do
					if entry.Enemy and mod:superExists(entry.Enemy) and mod:GetEntityData(entry.Enemy).SweetRedVines and mod:GetEntityData(entry.Enemy).SweetRedVines[fam.InitSeed] then
						mod:GetEntityData(entry.Enemy).SweetRedVines[fam.InitSeed] = nil
					end
					if entry.Vine and mod:superExists(entry.Vine) then
						entry.Vine:Kill()
					end
					if entry.Dummy and entry.Dummy:Exists() then
						entry.Dummy:Remove()
					end
				end
			end
			d.myGuys = nil
			d.grabbedGuys = nil
		end

		mod:spritePlay(sprite, "Idle")
	elseif d.State == "Death" then
		if sprite:IsFinished("Wither") then
			fam:Remove()
		elseif sprite:IsEventTriggered("Shoot") then
			if d.SproutingSeed then
				local trinket = Isaac.Spawn(5, 350, d.SproutingSeedOriginalSub, fam.Position, Vector.Zero, fam)
				d.SproutingSeed:Remove()
				d.SproutingSeedOriginalSub = nil
				d.SproutingSeed = nil
			end
			sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 1, 0, false, 1.3)
		else
			mod:spritePlay(sprite, "Wither")
		end
	end

	if d.grabbedGuys and d.myGuys then
		for id,entry in pairs(d.myGuys) do
			if entry.Enemy and not mod:superExists(entry.Enemy) then
				if entry.Vine and mod:superExists(entry.Vine) then
					entry.Vine:Kill()
				end
				if entry.Dummy and entry.Dummy:Exists() then
					entry.Dummy:Remove()
				end
				d.myGuys[id] = nil
			end
		end
	end

	if game:GetRoom():GetFrameCount() == 0 then
		if d.myGuys then
			for id,entry in pairs(d.myGuys) do
				if entry.Enemy and not mod:superExists(entry.Enemy) then
					if entry.Dummy and entry.Dummy:Exists() then
						entry.Dummy:Remove()
					end
					d.myGuys[id] = nil
				end
			end
		end

		fam:Remove()
	end
end, mod.ITEM.FAMILIAR.SWEET_RED_BRAMBLE)

function mod:SweetRedVineUpdates(npc, d)
	local d = mod:GetEntityData(npc)
	if d.SweetRedVines then
		for id,fam in pairs(d.SweetRedVines) do
			if mod:superExists(fam) and npc.EntityCollisionClass > EntityCollisionClass.ENTCOLL_NONE then
				d.SweetRedSnareLength = d.SweetRedSnareLength or sBal.snareRange
				if d.SweetRedSnareLength > sBal.snareKeepClose then
					d.SweetRedSnareLength = d.SweetRedSnareLength-2
				end
				local dist = fam.Position - npc.Position
				if dist:Length() > d.SweetRedSnareLength then
					local distToClose = dist - dist:Resized(d.SweetRedSnareLength)
					npc.Velocity = npc.Velocity + distToClose*0.5
				end
			else
				d.SweetRedVines[id] = nil
			end
		end
	elseif d.HDGAffiniSnares then
		for id,player in pairs(d.HDGAffiniSnares) do
			if mod:superExists(player) and npc.EntityCollisionClass > EntityCollisionClass.ENTCOLL_NONE and not (npc:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) or npc.Type == EntityType.ENTITY_EYE) then
				d.HDGSnareLength = d.HDGSnareLength or d.HDGSetSnareLength
				if d.HDGSnareLength > d.HDGSnareKeepClose then
					d.HDGSnareLength = d.HDGSnareLength-2
				end
				local dist = player.Position - npc.Position
				if dist:Length() > d.HDGSnareLength then
					local distToClose = dist - dist:Resized(d.HDGSnareLength)
					npc.Velocity = npc.Velocity + distToClose*0.5
				end
			else
				d.HDGAffiniSnares[id] = nil
			end
		end
	end
end

mod:AddCollectibleCallback(ModCallbacks.MC_NPC_UPDATE, mod.ITEM.COLLECTIBLE.SWEET_RED, mod.SweetRedVineUpdates)
mod:AddCollectibleCallback(ModCallbacks.MC_NPC_UPDATE, mod.ITEM.COLLECTIBLE.HUMAN_DOMESTICATION_GUIDE, mod.SweetRedVineUpdates)

--Oh my god I was troubleshooting this for like 40 minutes I just forgot to change the gfx folder from effect to familiar
function mod:SweetRedDirtEffect(npc)
	if npc.Parent then
		local d = mod:GetEntityData(npc)
		local sprite = npc:GetSprite()
		if not d.init then
			sprite:Play("Hi", true)
			sprite:Play("Appear", true)
			sprite:SetFrame(npc.Parent:GetSprite():GetFrame())
			sprite.Color = mod:GetDirtColor(npc.Position)
			d.init = true
		end

		npc.DepthOffset = npc.Parent.DepthOffset+1
		npc.SpriteScale = npc.Parent.SpriteScale
		npc.Position = npc.Parent.Position
		if sprite:IsFinished("Appear") then
			npc:Remove()
		else
			mod:spritePlay(sprite, "Appear")
		end
	else
		npc:Remove()
	end
end

mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, function(_, rng)
	local room = game:GetRoom()
    if mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.SWEET_RED, false) then
		local d = FiendFolio.getFieldInit(FiendFolio.savedata, 'run')
		d.SweetRedPity = (d.SweetRedPity or 0)+1
		local mult = mod.getCollectibleMultiplierAcrossAllPlayers(mod.ITEM.COLLECTIBLE.SWEET_RED)
        local chance = mult*sBal.bunchDropChance
		if d.SweetRedPity > sBal.pityDrop then
			chance = 150
		end

        if rng:RandomInt(100) < chance then
			d.SweetRedPity = 0
			mod.scheduleForUpdate(function()
				Isaac.Spawn(5, mod.PICKUP.VARIANT.SWEET_RED_BERRY, 1, room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0, true), Vector.Zero, nil)
			end, 0)
        end
    end
end)

--[[mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
	if npc.Variant == mod.FF.SweetRedVine.Var and npc.SubType == mod.FF.SweetRedVine.Sub then
		npc.SplatColor = Color(0, 0, 0, 0, 0, 0, 0)
	end
end, EntityType.ENTITY_EVIS)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, npc)
end, EffectVariant.BLOOD_EXPLOSION)]]