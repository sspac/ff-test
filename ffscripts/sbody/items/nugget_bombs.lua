local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

local flag = TearFlagsLib.RegisterTearFlag("NUGGET_BOMB")

function mod:nuggetBombsFlag(entity, player)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.NUGGET_BOMBS) then
		TearFlagsLib.AddTearFlags(entity, flag)
	end
end
mod:AddCollectibleCallback(FiendFolio.CALLBACK.FF_POLL_BOMBFLAGS, FiendFolio.ITEM.COLLECTIBLE.NUGGET_BOMBS, mod.nuggetBombsFlag)

function mod:nuggetBombsVariant(bomb, player)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.NUGGET_BOMBS) then
		local var = bomb.Variant
		if mod:isReplaceableBombVariant(var) then
			if mod:isCopperVariant(var) then
				bomb.Variant = mod.BOMB.NUGGET_COPPER
				bomb.Flags = bomb.Flags
			else
				bomb.Variant = mod.BOMB.NUGGET
				bomb.Flags = bomb.Flags
			end
		end
	end
end
mod:AddCollectibleCallback(FiendFolio.CALLBACK.FF_SET_BOMB_VARIANT, FiendFolio.ITEM.COLLECTIBLE.NUGGET_BOMBS, mod.nuggetBombsVariant)

function mod:SpawnNuggetFam(pos, flags, player, isDecoy, bSeed, src, isParallelClone)
  if mod:GetEntityData(src).ParallelBombParent then
	return
  end
  if Isaac.CountEntities(nil, 3) < 64 then
	local spooter = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BROWN_NUGGET_POOTER, 0, pos, Vector(0,0), player):ToFamiliar()
	spooter.TargetPosition = pos
	local bFlags = {}
	local nullF = BitSet128(0,0)
	bFlags[0] = flags
	bFlags[1] = player:HasCollectible(CollectibleType.COLLECTIBLE_MR_MEGA)						-- Mr. Mega
	bFlags[2] = (flags & TearFlags.TEAR_HOMING) ~= nullF        								-- Homing
	bFlags[3] = (flags & TearFlags.TEAR_POISON) ~= nullF        								-- Poison
	bFlags[4] = (flags & TearFlags.TEAR_BURN) ~= nullF          								-- Fire
	bFlags[5] = (flags & TearFlags.TEAR_SAD_BOMB) ~= nullF      								-- Sad
	bFlags[6] = (flags & TearFlags.TEAR_BUTT_BOMB) ~= nullF     								-- Butt
	bFlags[7] = (flags & TearFlags.TEAR_GLITTER_BOMB) ~= nullF  								-- Glitter
	bFlags[8] = (flags & TearFlags.TEAR_STICKY) ~= nullF        								-- Sticky
	bFlags[9] = (flags & TearFlags.TEAR_CROSS_BOMB) ~= nullF    								-- Bomber boy
	bFlags[10] = (flags & TearFlags.TEAR_CREEP_TRAIL) ~= nullF  								-- Bob's Bladder
	bFlags[11] = (flags & BitSet128(0,1<<(126-64))) ~= nullF    								-- Fast bombs
	bFlags[12] = isDecoy                                        								-- Best Friend
	bFlags[13] = (flags & BitSet128(0,1<<(72-64))) ~= nullF     								-- Blood bombs
	bFlags[14] = (flags & BitSet128(0,1<<(75-64))) ~= nullF     								-- Brimstone bombs
	bFlags[15] = (flags & BitSet128(0,1<<(78-64))) ~= nullF     								-- Ghost bombs
	bFlags[16] = (flags & BitSet128(0,1<<(119-64))) ~= nullF    								-- Giga bombs
	bFlags[17] = src and TearFlagsLib.HasTearFlags(src, TearFlagsLib.Flag.BRIDGE_BOMB)			-- Bridge Bombs
	bFlags[18] = src and TearFlagsLib.HasTearFlags(src, TearFlagsLib.Flag.LOCUST_BOMB)			-- Musca
	bFlags[19] = src and TearFlagsLib.HasTearFlags(src, TearFlagsLib.Flag.GUTS_BOMB)			-- Slippy's Guts
	bFlags[20] = src and TearFlagsLib.HasTearFlags(src, TearFlagsLib.Flag.GREEN_BOMB)			-- Green Bombs
	bFlags[21] = src and TearFlagsLib.HasTearFlags(src, TearFlagsLib.Flag.PARALLEL_BOMB)		-- Parallel Bombs
	bFlags[22] = src and TearFlagsLib.HasTearFlags(src, TearFlagsLib.Flag.TELE_BOMB)			-- Telebombs
	bFlags[23] = src and TearFlagsLib.HasTearFlags(src, TearFlagsLib.Flag.FABERGE_BOMB)			-- Faberge Bombs
	bFlags[24] = src and TearFlagsLib.HasTearFlags(src, TearFlagsLib.Flag.FOSSIL_BOMB)			-- Bomb Sack Fossil
	bFlags[25] = src and TearFlagsLib.HasTearFlags(src, TearFlagsLib.Flag.FF_ZIP_BOMB)			-- 43.zip
	bFlags[26] = src and TearFlagsLib.HasTearFlags(src, TearFlagsLib.Flag.CHAOS_EGG_BOMB)		-- Chaos Bombs (egg)
	bFlags[27] = src and TearFlagsLib.HasTearFlags(src, TearFlagsLib.Flag.CHAOS_MAGNET_BOMB)	-- Chaos Bombs (magnet)
	bFlags[28] = src and TearFlagsLib.HasTearFlags(src, TearFlagsLib.Flag.CHAOS_POOP_BOMB)		-- Chaos Bombs (poop)
	bFlags[29] = src and TearFlagsLib.HasTearFlags(src, TearFlagsLib.Flag.CHAOS_HOLY_BOMB)		-- Chaos Bombs (holy)
	bFlags[30] = src and TearFlagsLib.HasTearFlags(src, TearFlagsLib.Flag.CHAOS_BABY_BOMB)		-- Chaos Bombs (baby)
	bFlags[31] = src and TearFlagsLib.HasTearFlags(src, TearFlagsLib.Flag.CHAOS_ICE_BOMB)		-- Chaos Bombs (ice)
	bFlags[32] = src and TearFlagsLib.HasTearFlags(src, TearFlagsLib.Flag.CHAOS_FLYING_BOMB)	-- Chaos Bombs (flying)
	bFlags[33] = src and TearFlagsLib.HasTearFlags(src, TearFlagsLib.Flag.CHAOS_FORTUNE_BOMB)	-- Chaos Bombs (fortune)
	bFlags[34] = src and TearFlagsLib.HasTearFlags(src, TearFlagsLib.Flag.CHAOS_MONEY_BOMB)		-- Chaos Bombs (money)
	bFlags[35] = src and TearFlagsLib.HasTearFlags(src, TearFlagsLib.Flag.CHAOS_BUBBLE_BOMB)	-- Chaos Bombs (bubble)
	
	if bFlags[2] and bFlags[32] and src.Type == EntityType.ENTITY_BOMB and not mod:GetEntityData(src).chaosHadHomingBefore then
		bFlags[2] = false
	end
	
	local data = mod:GetEntityData(spooter)
	data.bFlags = bFlags
	data.nuggetRNG = RNG()
	data.nuggetRNG:SetSeed(math.max(spooter.InitSeed, 1), 27)
	local clone
	if bFlags[21] then
	  if isParallelClone then
		spooter.Color = Color(1, 1, 1, 1, -0.2, -0.2, -0.2, 3, 3, 3, 1)
		local sprite = spooter:GetSprite()
		sprite:SetCustomShader("shaders/fiendfolio/coloroffset_parallel")
		sprite.FlipX = true
	  else
		spooter.Color = Color(3, 3, 3, 1, -0.2, -0.2, -0.2, 1, 1, 1, 1)
		clone = mod:SpawnNuggetFam(mod:GetMirroredPosition(spooter.Position), flags, player, isDecoy, bSeed, src, true)
		data.ParallelBombClone = clone
		local cdata = mod:GetEntityData(clone)
		cdata.ParallelBombClone = spooter
		cdata.IsParallelCloned = true
		cdata.nuggetRNG = RNG()
		cdata.nuggetRNG:SetSeed(math.max(spooter.InitSeed, 1), 27)
	  end
	end
	--data.fastTearRate = (flags & BitSet128(0,1<<(126-64))) ~= nullF  -- Fast Bombs
	data.bSeed = bSeed
	player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_BROWN_NUGGET)
	Isaac.RunCallback(FiendFolio.CALLBACK.POST_SPAWN_NUGGET_BOMB_POOTER, spooter:ToFamiliar(), flags, player, isDecoy, bSeed)
	return spooter, clone
  end
end

function mod:initSpooter(spooter, isBomb, var, data, sourceFlag)
	local sprite = spooter:GetSprite()
	if spooter and isBomb and (var == BombVariant.BOMB_GIGA or var == BombVariant.BOMB_ROCKET_GIGA) then
	  mod:GetEntityData(spooter).isUltraSpooter = true
	  spooter:SetSize(20, spooter.SizeMulti, 12)
	  sprite:Load("gfx/familiar/nugget fly/ultra pooter.anm2", true)
	elseif spooter and (data.FFIsScatter or sourceFlag == mod.BombFlagSource.LOCUST_OF_WAR) then
	  mod:GetEntityData(spooter).isBabySpooter = true
	  --spooter.SpriteScale = Vector(0.5, 0.5)
	  spooter:SetSize(spooter.Size * 0.5, spooter.SizeMulti * 0.5, 12)
	  sprite:Load("gfx/familiar/nugget fly/pooter_0.anm2", true)
	  --sprite:ReplaceSpritesheet(1, "gfx/familiar/babypooter_spawn.png")
	  --sprite:LoadGraphics()
	end
	sprite:Play("Appear", true)
end

mod:AddCallback(FiendFolio.CALLBACK.FF_POST_BOMBFLAG_EFFECTS, function(_, pos, radius, tearflags, src, radiusMult, player, sourceFlag, tearFlagParams)
	local data = mod:GetEntityData(src)
	local frame = game:GetFrameCount()
	if data.lastFrameNuggetSpawned == frame then
		return
	end
	
	local isBomb = src.Type == EntityType.ENTITY_BOMB
	local var = src.Variant
	local flags = tearflags | (((sourceFlag == mod.BombFlagSource.BOBS_ROTTEN_HEAD or sourceFlag == mod.BombFlagSource.BOBS_BRAIN) and TearFlags.TEAR_POISON) or TearFlags.TEAR_NORMAL)
	local spooter, clone = mod:SpawnNuggetFam(src.Position, flags, player, isBomb and var == BombVariant.BOMB_DECOY, src.InitSeed, src)
	if spooter then mod:initSpooter(spooter, isBomb, var, data, sourceFlag) end
	if clone then mod:initSpooter(clone, isBomb, var, data, sourceFlag) end
	--mod.customBombs[bomb.InitSeed] = nil
	data.lastFrameNuggetSpawned = frame
end, flag)

local targetProj = nil -- i love jank coding
mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_UPDATE, function(_, fam)
	local data = mod:GetEntityData(fam)
	local checkProj, override = false, false
	if data.bFlags and data.bFlags[20] then
	  checkProj = true
	  override = true
	elseif data.bFlags and data.bFlags[21] and data.ParallelBombClone and data.ParallelBombClone:Exists() then
	  override = true
	end
	
	if override then
	  fam.Position = fam.TargetPosition
	  fam.Velocity = Vector(0,0)
	
	  local sprite = fam:GetSprite()
	  if sprite:IsFinished("Appear") or sprite:IsFinished("Attack") then
		sprite:Play("Fly", true)
	  end
	
	  local frame = game:GetFrameCount()
	  if (sprite:IsPlaying("Fly") or sprite:IsPlaying("Attack")) and (frame + fam.Index) % 30 == 0 and data.LastFrameDefaultFired ~= frame and not (data.IsParallelCloned and data.ParallelBombClone and data.ParallelBombClone:Exists()) then
		local pos = fam.Position
		local clonePos = data.bFlags[21] and data.ParallelBombClone and data.ParallelBombClone:Exists() and data.ParallelBombClone.Position
		
		if checkProj then
		  local nearest, cloneNearest
		  local dist, cloneDist
		  for _, p in pairs(Isaac.FindInRadius(pos, 150, EntityPartition.BULLET)) do
			if dist then
			  local distN = p.Position:Distance(pos)
			  if distN < dist then
				nearest = p
				dist = distN
			  end
			end
			if not nearest then
			  nearest = p
			  dist = p.Position:Distance(pos)
			end
		  end
		  if clonePos then
			for _, p in pairs(Isaac.FindInRadius(clonePos, 150, EntityPartition.BULLET)) do
			  if cloneDist then
				local distN = p.Position:Distance(clonePos)
				if distN < cloneDist then
				  cloneNearest = p
				  cloneDist = distN
				end
			  end
			  if not cloneNearest then
				cloneNearest = p
				cloneDist = p.Position:Distance(clonePos)
			  end
			end
		  end
		  local baseSpooter, baseNearest
		  if nearest and (not cloneNearest or dist <= cloneDist) then
			baseSpooter = fam
			baseNearest = nearest
		  elseif cloneNearest and (not nearest or cloneDist <= dist) then
			baseSpooter = data.ParallelBombClone
			baseNearest = cloneNearest
		  end
		  if baseNearest then
			targetProj = baseNearest
			local sprite = baseSpooter:GetSprite()
			sprite:Play("Attack", true)
			local vel = ((baseNearest.Position + baseNearest.Velocity * 3) - baseSpooter.Position):Normalized() * 15
			local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, baseSpooter.Position, vel, baseSpooter)
			tear:ToTear().Scale = 0.8
			targetProj = nil
			sprite.FlipX = vel.X < 0

			local data = mod:GetEntityData(baseSpooter)
			if data.bFlags[21] and data.ParallelBombClone and data.ParallelBombClone:Exists() then
			  local csprite = data.ParallelBombClone:GetSprite()
			  csprite:Play("Attack", true)
			  local ctear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, data.ParallelBombClone.Position, vel * -1, data.ParallelBombClone)
			  ctear:ToTear().Scale = 0.8
			  csprite.FlipX = vel.X * -1 < 0
			end

			goto postFireNuggetPooter
		  end
		end
		
		local nearest, cloneNearest
		local dist, cloneDist
		for _, e in pairs(Isaac.FindInRadius(pos, 150, EntityPartition.ENEMY)) do
		  if e.Type > 9 and e.Type < 1000 and e:IsVulnerableEnemy() and not e:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) then
		    if dist then
			  local distN = e.Position:Distance(pos)
			  if distN < dist then
			    nearest = e
			    dist = distN
			  end
		    end
		    if not nearest then
			  nearest = e
			  dist = e.Position:Distance(pos)
		    end
		  end
		end
		if clonePos then
		  for _, e in pairs(Isaac.FindInRadius(clonePos, 150, EntityPartition.ENEMY)) do
		    if e.Type > 9 and e.Type < 1000 and e:IsVulnerableEnemy() and not e:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) then
			  if cloneDist then
			    local distN = e.Position:Distance(clonePos)
			    if distN < cloneDist then
				  cloneNearest = e
				  cloneDist = distN
			    end
			  end
			  if not cloneNearest then
			    cloneNearest = e
			    cloneDist = e.Position:Distance(clonePos)
			  end
			end
		  end
		end
		local baseSpooter, baseNearest
		if nearest and (not cloneNearest or dist <= cloneDist) then
		  baseSpooter = fam
		  baseNearest = nearest
		elseif cloneNearest and (not nearest or cloneDist <= dist) then
		  baseSpooter = data.ParallelBombClone
		  baseNearest = cloneNearest
		end
		if baseNearest then
		  local sprite = baseSpooter:GetSprite()
		  sprite:Play("Attack", true)
		  local vel = (baseNearest.Position - baseSpooter.Position):Normalized() * 10
		  local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, baseSpooter.Position, vel, baseSpooter)
		  tear:ToTear().Scale = 0.8
		  sprite.FlipX = vel.X < 0
		  local data = mod:GetEntityData(baseSpooter)
		  data.LastFrameDefaultFired = frame
		  
		  if data.bFlags[21] and data.ParallelBombClone and data.ParallelBombClone:Exists() then
			local csprite = data.ParallelBombClone:GetSprite()
			csprite:Play("Attack", true)
			local ctear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, data.ParallelBombClone.Position, vel * -1, data.ParallelBombClone)
			ctear:ToTear().Scale = 0.8
			csprite.FlipX = vel.X * -1 < 0
			mod:GetEntityData(data.ParallelBombClone).LastFrameDefaultFired = frame
		  end
		end
	  end
	  ::postFireNuggetPooter::
	  Isaac.RunCallbackWithParam(ModCallbacks.MC_FAMILIAR_UPDATE, FamiliarVariant.BROWN_NUGGET_POOTER, fam)
	  return true
	end
end)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
	local data = mod:GetEntityData(fam)
	if data.IsParallelCloned and data.ParallelBombClone and data.ParallelBombClone:Exists() then return end
	local sprite = fam:GetSprite()
	--if data.fastTearRate and sprite:IsPlaying("Attack") and sprite:GetFrame() == 13 then table.insert(mod.fastNuggetFams, fam) end
	if (data.FastFireCooldown or 1) > 0 then data.FastFireCooldown = (data.FastFireCooldown or 1) - 1 end

	if data.bFlags and data.bFlags[11] and sprite:IsPlaying("Attack") and sprite:GetFrame() == 0 then
	  data.FastFireCooldown = 16
	end
	if data.FastFireCooldown == 1 then
	  local pos = fam.Position
	  local clonePos = data.bFlags and data.bFlags[21] and data.ParallelBombClone and data.ParallelBombClone:Exists() and data.ParallelBombClone.Position
	  if data.bFlags and data.bFlags[20] then
		local nearest, cloneNearest
		local dist, cloneDist
		for _, p in pairs(Isaac.FindInRadius(pos, 150, EntityPartition.BULLET)) do
		  if dist then
		  local distN = p.Position:Distance(pos)
		  if distN < dist then
			nearest = p
			dist = distN
		  end
		  end
		  if not nearest then
			nearest = p
			dist = p.Position:Distance(pos)
		  end
		end
		if clonePos then
		  for _, p in pairs(Isaac.FindInRadius(clonePos, 150, EntityPartition.BULLET)) do
			if cloneDist then
			  local distN = p.Position:Distance(clonePos)
			  if distN < cloneDist then
				cloneNearest = p
				cloneDist = distN
			  end
			end
			if not cloneNearest then
			  cloneNearest = p
			  cloneDist = p.Position:Distance(clonePos)
			end
		  end
		end
		local baseSpooter, baseNearest
		if nearest and (not cloneNearest or dist <= cloneDist) then
		  baseSpooter = fam
		  baseNearest = nearest
		elseif cloneNearest and (not nearest or cloneDist <= dist) then
		  baseSpooter = data.ParallelBombClone
		  baseNearest = cloneNearest
		end
		if baseNearest then
		  targetProj = baseNearest
		  local sprite = baseSpooter:GetSprite()
		  sprite:Play("Attack", true)
		  local vel = ((baseNearest.Position + baseNearest.Velocity * 3) - baseSpooter.Position):Normalized() * 15
		  local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, baseSpooter.Position, vel, baseSpooter)
		  tear:ToTear().Scale = 0.8
		  targetProj = nil
		  sprite.FlipX = vel.X < 0

		  local data = mod:GetEntityData(baseSpooter)
		  if data.bFlags[21] and data.ParallelBombClone and data.ParallelBombClone:Exists() then
			local csprite = data.ParallelBombClone:GetSprite()
			csprite:Play("Attack", true)
			local ctear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, data.ParallelBombClone.Position, vel * -1, data.ParallelBombClone)
			ctear:ToTear().Scale = 0.8
			csprite.FlipX = vel.X * -1 < 0
		  end

		  return
		end
	  end
	  
	  local nearest, cloneNearest
	  local dist, cloneDist
	  for _, e in pairs(Isaac.FindInRadius(pos, 150, EntityPartition.ENEMY)) do
		if e.Type > 9 and e.Type < 1000 and e:IsVulnerableEnemy() and not e:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) then
		  if dist then
		    local distN = e.Position:Distance(pos)
		    if distN < dist then
			  nearest = e
			  dist = distN
		    end
		  end
		  if not nearest then
		    nearest = e
		    dist = e.Position:Distance(pos)
		  end
		end
	  end
	  if clonePos then
		for _, e in pairs(Isaac.FindInRadius(clonePos, 150, EntityPartition.ENEMY)) do
		  if e.Type > 9 and e.Type < 1000 and e:IsVulnerableEnemy() and not e:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) then
		    if cloneDist then
			  local distN = e.Position:Distance(clonePos)
			  if distN < cloneDist then
			    cloneNearest = e
			    cloneDist = distN
			  end
		    end
		    if not cloneNearest then
			  cloneNearest = e
			  cloneDist = e.Position:Distance(clonePos)
		    end
		  end
		end
	  end
	  local baseSpooter, baseNearest
	  if nearest and (not cloneNearest or dist <= cloneDist) then
		baseSpooter = fam
		baseNearest = nearest
	  elseif cloneNearest and (not nearest or cloneDist <= dist) then
		baseSpooter = data.ParallelBombClone
		baseNearest = cloneNearest
	  end
	  if baseNearest then
		local sprite = baseSpooter:GetSprite()
		sprite:Play("Attack", true)
		local vel = (baseNearest.Position - baseSpooter.Position):Normalized() * 10
		local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, baseSpooter.Position, vel, baseSpooter)
		tear:ToTear().Scale = 0.8
		sprite.FlipX = vel.X < 0
		local data = mod:GetEntityData(baseSpooter)
		data.LastFrameDefaultFired = frame
		  
		if data.bFlags[21] and data.ParallelBombClone and data.ParallelBombClone:Exists() then
		  local csprite = data.ParallelBombClone:GetSprite()
		  csprite:Play("Attack", true)
		  local ctear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, data.ParallelBombClone.Position, vel * -1, data.ParallelBombClone)
		  ctear:ToTear().Scale = 0.8
		  csprite.FlipX = vel.X * -1 < 0
		  mod:GetEntityData(data.ParallelBombClone).LastFrameDefaultFired = frame
		end
	  end
	end

	--if data.isBabySpooter then
	--  fam.SpriteScale = Vector(0.5, 0.5)
	--end

	--if fam.FrameCount == 6 and data.bSeed then       -- dont ask
	--  mod.customBombs[data.bSeed] = nil
	--end
end, FamiliarVariant.BROWN_NUGGET_POOTER)

function mod:nuggetLaserUpdate(laser, data)
	local nuggetType = data.nuggetType
	if nuggetType and laser.Timeout > 0 then
		laser:GetSprite().Scale = Vector(0.25*nuggetType, 1)
		laser:SetSize(4*nuggetType, Vector.One, 0)
		--laser.Child:GetSprite().Scale = Vector(0.3125, 0.25)--*nuggetType
	end
end

local function lerpColor(colorA, colorB, percent)
	local r = colorA.R * (1-percent) + colorB.R * percent
	local g = colorA.G * (1-percent) + colorB.G * percent
	local b = colorA.B * (1-percent) + colorB.B * percent
	local a = colorA.A * (1-percent) + colorB.A * percent
	local ro = colorA.RO * (1-percent) + colorB.RO * percent
	local go = colorA.GO * (1-percent) + colorB.GO * percent
	local bo = colorA.BO * (1-percent) + colorB.BO * percent
	
	local colorizeA = colorA:GetColorize()
	local colorizeB = colorB:GetColorize()
	local rc = colorizeA.R * (1-percent) + colorizeB.R * percent
	local gc = colorizeA.G * (1-percent) + colorizeB.G * percent
	local bc = colorizeA.B * (1-percent) + colorizeB.B * percent
	local ac = colorizeA.A * (1-percent) + colorizeB.A * percent
	
	return Color(r,g,b,a,ro,go,bo,rc,gc,bc,ac)
end

local customPurgatorySouls = {}
function mod:nuggetFlyAttack(fam, vel, hex)
  local data = mod:GetEntityData(fam)
  local bFlags = data.bFlags

  local dmgBonus = 1
  local scaleBonus = 1
  if bFlags[1] then
	dmgBonus = dmgBonus * 1.6
	scaleBonus = scaleBonus * 1.2
  end
  if bFlags[9] and data.nuggetRNG:RandomInt(4) == 1 then
	scaleBonus = scaleBonus * 1.1
  end
  if bFlags[17] then
	local randMult = data.nuggetRNG:RandomInt() + 1
	if data.nuggetRNG:RandomInt(2) == 1 then
	  dmgBonus = dmgBonus * (randMult + 1)
	  scaleBonus = (scaleBonus + 0.1) * (randMult / 5 + 1)
	else
	  dmgBonus = dmgBonus / (randMult + 1)
	  scaleBonus = (scaleBonus + 0.1) / (randMult / 6 + 1)
	end
  end
  if data.isUltraSpooter then
	dmgBonus = dmgBonus * 2
  elseif data.isBabySpooter then
	dmgBonus = dmgBonus * 0.5
	scaleBonus = scaleBonus * 0.5
  end

  local flags = BitSet128(0,0)
  local flagstearonly = BitSet128(0,0)
  local cNuggetFlags = {}
  local color
  local variant = 1
  if bFlags[2] or fam.Player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
	flags = flags | TearFlags.TEAR_HOMING
	variant = TearVariant.BLUE
	color = Color(0.4, 0.15, 0.38, 1, 71 / 255, 0, 116 / 255)
  end
  if bFlags[3] and data.nuggetRNG:RandomInt(15) == 1  then
	flags = flags | TearFlags.TEAR_POISON
	if variant ~= 0 then variant = TearVariant.BLUE end
	color = Color(0.196078, 1, 0.196078, 1, 0, 0, 0)
  end
  if bFlags[4] and data.nuggetRNG:RandomInt(15) == 1 then
	flags = flags | TearFlags.TEAR_BURN
	variant = TearVariant.FIRE_MIND
	color = Color(1, 148/255, 76/255, 1, 64/255, 48/255, 19/255)
  end
  if bFlags[6] and data.nuggetRNG:RandomInt(15) == 1 then
	flags = flags | TearFlags.TEAR_CONFUSION
	variant = TearVariant.BLUE
	color = Color(0.375, 0.25, 0, 1, 32 / 255, 0, 0)
  end
  if bFlags[7] and data.nuggetRNG:RandomInt(10) == 1 then
	flags = flags | TearFlags.TEAR_CHARM
	variant = TearVariant.BLUE
	color = Color(1, 0, 1, 1, 50 / 255, 0, 0)
  end
  if (bFlags[8] or bFlags[26]) and data.nuggetRNG:RandomInt(20) == 3 then
	flags = flags | TearFlags.TEAR_EGG
	variant = TearVariant.EGG
  end
  if bFlags[9] and data.nuggetRNG:RandomInt(4) == 1 then
	flags = flags | TearFlags.TEAR_QUADSPLIT
	cNuggetFlags.nuggetSplit = true
  end
  if bFlags[10] and data.nuggetRNG:RandomInt(8) == 1 then
	if variant == 0 or variant == 1 then variant = TearVariant.MYSTERIOUS end
	cNuggetFlags.nuggetBladder = true
  end
  if bFlags[12] and data.nuggetRNG:RandomInt(4) == 1 then
	flags = flags | BitSet128(0,1<<(67-64))
	color = Color(0.7, 0.14, 0.1, 1, 0.3, 0, 0)
  end
  if bFlags[13] and data.nuggetRNG:RandomInt(12) == 1 then
	if variant == 0 or variant == 1 then variant = TearVariant.BALLOON end
	cNuggetFlags.nuggetBlood = true
  end
  if bFlags[17] then
	if variant == 0 or variant == 1 then variant = TearVariant.ROCK end
  end
  if bFlags[18] and data.nuggetRNG:RandomInt(10) == 1 then
	cNuggetFlags.nuggetMulligan = fam
  end
  if bFlags[20] then
	if variant == 0 or variant == 1 then variant = TearVariant.LOST_CONTACT end
	flags = flags | TearFlags.TEAR_SHIELDED
	flagstearonly = flagstearonly | TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_HOMING
  end
  if bFlags[22] and data.nuggetRNG:RandomInt(10) == 1 then
	if variant ~= 0 then variant = TearVariant.BLUE end
	cNuggetFlags.nuggetExcommunicate = fam.Player
	color = Color(1.3, 1.3, 1.3, 1.0, 0/255, 30/255, 45/255, 1.0, 1.0, 1.0, 1)
  end
  if bFlags[23] then
	cNuggetFlags.nuggetFaberge = true
	if variant == 0 or variant == 1 then variant = TearVariant.COIN end
  end
  if bFlags[25] and data.nuggetRNG:RandomFloat() < 0.25 then
    cNuggetFlags.nuggetZip = fam.Player
    color = Color(1.0, 1.0, 0.0, 1.0, 80/255, 20/255, 0/255, 1.0, 1.0, 0.0, 0.5)
  end
  if bFlags[28] then
	cNuggetFlags.nuggetPoop = fam.Player
  end
  if bFlags[29] and data.nuggetRNG:RandomInt(18) == 1 then
	cNuggetFlags.nuggetHoly = fam.Player
  end
  if bFlags[31] then
	flags = flags | TearFlags.TEAR_ICE
	if variant == 0 or variant == 1 then variant = TearVariant.ICE end
  end
  if bFlags[32] and data.nuggetRNG:RandomInt(8) == 1 then
	flags = flags | TearFlags.TEAR_HOMING
	cNuggetFlags.nuggetFlying = true
	dmgBonus = dmgBonus * 1.25
    color = Color(3.65, 1.25, 1, 1.0, -90/255, 40/255, 40/255, 0.413, 0.422, 0.657, 1.0)
  end
  if bFlags[33] and data.nuggetRNG:RandomInt(21) == 1 then
	cNuggetFlags.nuggetFortune = true
	dmgBonus = dmgBonus * 1.05
	if variant == 0 or variant == 1 then variant = mod.TEAR.FORTUNE_COOKIE end
  end
  if bFlags[34] then
	flags = flags | TearFlags.TEAR_COIN_DROP_DEATH
  end
  if bFlags[35] and data.nuggetRNG:RandomFloat() <= 0.15 then
    cNuggetFlags.nuggetSoap = fam.Player
	if variant == 1 then variant = TearVariant.BLUE end
	color = Color(1.5, 1.5, 1.5, 1)
  end
  if bFlags[30] and data.nuggetRNG:RandomInt(15) == 1 then
	flags = flags | TearFlags.TEAR_GODS_FLESH
	if variant == 0 then 
		variant = TearVariant.GODS_FLESH
	elseif variant == 1 then 
		variant = TearVariant.GODS_FLESH_BLOOD
	end
  end
  if bFlags[27] then
	flags = flags | TearFlags.TEAR_ATTRACTOR
	if variant == 0 or variant == 1 then variant = TearVariant.METALLIC end
  end

  local w_rng = data.nuggetRNG:RandomInt(7) + 1
  local secondHandMultiplier
  if w_rng == 5 and bFlags[19] and Isaac.CountEntities(fam, mod.FF.SlippyFart.ID, mod.FF.SlippyFart.Var, mod.FF.SlippyFart.Sub) <= 0 then -- Pooter shoots linger bean
	local cloud = Isaac.Spawn(mod.FF.SlippyFart.ID, mod.FF.SlippyFart.Var, mod.FF.SlippyFart.Sub, fam.Position, Vector(0,0), fam)
	cloud.DepthOffset = -5
	sfx:Play(mod.Sounds.FartFrog1,0.2,0,false,math.random(80,120)/100)
	if data.isBabySpooter then
		mod:GetEntityData(cloud).RadiusMult = 0.5
		cloud.SpriteScale = Vector(0.5, 0.5)
		cloud.SpriteOffset = Vector(0,-2)
	elseif data.isUltraSpooter then
		mod:GetEntityData(cloud).RadiusMult = 2
		cloud.SpriteScale = Vector(2,2)
		cloud.SpriteOffset = Vector(0,15)
	else
		cloud.SpriteOffset = Vector(0,-3)
	end
  elseif w_rng == 6 and bFlags[15] then                     -- Pooter shoots ghost
	--if not (math.abs(color.B-0.38) < 0.0001) then soul:SetColor(color, 0, 0, false, false) end
	if color and (math.abs(color.B-0.38) < 0.0001) then color = nil end    -- homing color check
	if not color then
	  if cNuggetFlags.nuggetBladder then color = Color(19/255, 239/255, 0, 1, 0, 0, 0)
	  elseif variant == TearVariant.BALLOON then color = Color(237/255, 15/255, 0, 1, 0, 0, 0) end
	end
	if color then color:SetColorize(1, 1, 1, 0.3) else color = Color(1, 1, 1, 1, 0, 0, 0) end
	if data.isUltraSpooter then
	  scaleBonus = scaleBonus * 1.25
	  for i=0, 3 do
		local soul = Isaac.Spawn(1000, 189, 1, fam.Position, Vector.Zero, fam.SpawnerEntity):ToEffect()
		soul:SetColor(color, 0, 0, false, false)
		customPurgatorySouls[soul.InitSeed] = {}
		customPurgatorySouls[soul.InitSeed].nuggetDmgBonus = dmgBonus
		customPurgatorySouls[soul.InitSeed].nuggetFlags = flags
		customPurgatorySouls[soul.InitSeed].nuggetFam = fam
		customPurgatorySouls[soul.InitSeed].nuggetBlood = cNuggetFlags.nuggetBlood
		customPurgatorySouls[soul.InitSeed].nuggetMulligan = cNuggetFlags.nuggetMulligan
		customPurgatorySouls[soul.InitSeed].nuggetExcommunicate = cNuggetFlags.nuggetExcommunicate
		customPurgatorySouls[soul.InitSeed].nuggetFaberge = cNuggetFlags.nuggetFaberge
		customPurgatorySouls[soul.InitSeed].nuggetZip = cNuggetFlags.nuggetZip
		customPurgatorySouls[soul.InitSeed].nuggetPoop = cNuggetFlags.nuggetPoop
		customPurgatorySouls[soul.InitSeed].nuggetHoly = cNuggetFlags.nuggetHoly
		customPurgatorySouls[soul.InitSeed].nuggetFortune = cNuggetFlags.nuggetFortune
		customPurgatorySouls[soul.InitSeed].nuggetSoap = cNuggetFlags.nuggetSoap
		mod:GetEntityData(soul).nuggetBladder = cNuggetFlags.nuggetBladder
		mod:GetEntityData(soul).nuggetAttractor = flags & TearFlags.TEAR_ATTRACTOR == TearFlags.TEAR_ATTRACTOR
		mod:GetEntityData(soul).nuggetStartPos = fam.Position
		soul.SpriteScale = Vector(scaleBonus, scaleBonus)
		soul.SpriteOffset = Vector(0, 12*(-1+scaleBonus))
		for j=1, (40-i*3) do soul:Update() end
	  end
	else
	  local soul = Isaac.Spawn(1000, 189, 1, fam.Position, Vector.Zero, fam.SpawnerEntity):ToEffect()
	  soul:SetColor(color, 0, 0, false, false)
	  customPurgatorySouls[soul.InitSeed] = {}
	  customPurgatorySouls[soul.InitSeed].nuggetDmgBonus = dmgBonus
	  customPurgatorySouls[soul.InitSeed].nuggetFlags = flags
	  customPurgatorySouls[soul.InitSeed].nuggetFam = fam
	  customPurgatorySouls[soul.InitSeed].nuggetBlood = cNuggetFlags.nuggetBlood
	  customPurgatorySouls[soul.InitSeed].nuggetMulligan = cNuggetFlags.nuggetMulligan
	  customPurgatorySouls[soul.InitSeed].nuggetExcommunicate = cNuggetFlags.nuggetExcommunicate
	  customPurgatorySouls[soul.InitSeed].nuggetFaberge = cNuggetFlags.nuggetFaberge
	  customPurgatorySouls[soul.InitSeed].nuggetZip = cNuggetFlags.nuggetZip
	  customPurgatorySouls[soul.InitSeed].nuggetPoop = cNuggetFlags.nuggetPoop
	  customPurgatorySouls[soul.InitSeed].nuggetHoly = cNuggetFlags.nuggetHoly
	  customPurgatorySouls[soul.InitSeed].nuggetFortune = cNuggetFlags.nuggetFortune
	  customPurgatorySouls[soul.InitSeed].nuggetSoap = cNuggetFlags.nuggetSoap
	  mod:GetEntityData(soul).nuggetBladder = cNuggetFlags.nuggetBladder
	  mod:GetEntityData(soul).nuggetAttractor = flags & TearFlags.TEAR_ATTRACTOR == TearFlags.TEAR_ATTRACTOR
	  mod:GetEntityData(soul).nuggetStartPos = fam.Position
	  soul.SpriteScale = Vector(scaleBonus, scaleBonus)
	  soul.SpriteOffset = Vector(0, 12*(-1+scaleBonus))
	  for i=1, 40 do soul:Update() end
	end

  elseif w_rng == 7 and bFlags[14] then                 -- Pooter shoots brimstone
	if color then
	  color:SetColorize(color.R, color.G, color.B, 0.35)
	else
	  color = Color(1, 1, 1, 1, 0, 0, 0)
	end
	if cNuggetFlags.nuggetBladder then flags = flags | TearFlags.TEAR_MYSTERIOUS_LIQUID_CREEP end
	if data.isUltraSpooter then
	  local angles
	  if hex then
		angles = {-22.5, -7.5, 7.5, 22.5}
	  else
		angles = {-28.118, -9.567, 9.567, 28.118}
	  end
	  local angle = vel:GetAngleDegrees()

	  for i=1, 4 do
		local laser = EntityLaser.ShootAngle(1, fam.Position + vel, angles[i] + angle, 8, Vector(0, -15), fam):ToLaser()
		laser.CollisionDamage = 1.3125 * dmgBonus
		local ldata = mod:GetEntityData(laser)
		ldata.nuggetType = 3
		laser:SetSize(12, Vector.One, 0)
		laser:GetSprite().Scale = Vector(0.75, 0.75)
		laser:AddTearFlags(flags)
		laser:SetColor(color, 0, 0, false, false)
		if cNuggetFlags.nuggetExcommunicate then
		  ldata.nuggetExcommunicate = fam.Player
		  laser:SetColor(Color(6.8, 6.8, 6.8, 1.0, -50/255, -50/255, -50/255, 0.9, 1.0, 1.2, 1), 0, 0, false, false)
		end
		if cNuggetFlags.nuggetZip then
		  ldata.nuggetZip = fam.Player
		  laser:SetColor(Color(1.0, 1.0, 1.0, 1.0, 0/255, 0/255, 0/255, 6.0, 4.2, 1.0, 1.0), 0, 0, false, false)
		end
		if cNuggetFlags.nuggetPoop then
		  ldata.nuggetPoop = fam.Player
		  mod:setupCanOfBeansInfo(laser, fam.Player, ldata, false)
		  local lasercolor = laser.Color
		  local lasercolorize = lasercolor:GetColorize()
		  local beancolor = Color(1, 1, 1, lasercolor.A, lasercolor.RO, lasercolor.GO, lasercolor.BO,
		                          lasercolor.R * 3.81, lasercolor.G * 2.7, lasercolor.B * 2.28, 1)
		  laser:SetColor(lerpColor(beancolor, lasercolor, lasercolorize.A), 0, 0, false, false)
		end
		ldata.nuggetFaberge = cNuggetFlags.nuggetFaberge
		ldata.nuggetHoly = cNuggetFlags.nuggetHoly
		ldata.nuggetSoap = cNuggetFlags.nuggetSoap
	    if cNuggetFlags.nuggetFortune then
	      ldata.nuggetFortune = fam.Player
		  laser:SetColor(Color(1.0, 1.0, 1.0, 1.0, 0/255, 0/255, 0/255, 4.5, 3.44, 2.41, 1), 0, 0, false, false)
	    end

		Isaac.RunCallbackWithParam(mod.CALLBACK.POST_NUGGET_BOMB_POOTER_FIRE_WEAPON, WeaponType.WEAPON_BRIMSTONE, laser, WeaponType.WEAPON_BRIMSTONE, fam, data.isUltraSpooter, data.isBabySpooter)

		laser:Update()
		laser:Update()  --bruh
	  end
	else
	  local laser = EntityLaser.ShootAngle(1, fam.Position + vel, vel:GetAngleDegrees(), 8, Vector(0, -15), fam):ToLaser()
	  local nuggetType = 2
	  if data.isBabySpooter then nuggetType = 1 end
	  laser.CollisionDamage = 1.3125 * dmgBonus
	  local ldata = mod:GetEntityData(laser)
	  ldata.nuggetType = nuggetType
	  laser:SetSize(4*nuggetType, Vector.One, 0)
	  laser:GetSprite().Scale = Vector(0.25, 0.25)*nuggetType
	  laser:AddTearFlags(flags)
	  laser:SetColor(color, 0, 0, false, false)
	  if cNuggetFlags.nuggetExcommunicate then
	    ldata.nuggetExcommunicate = fam.Player
		laser:SetColor(Color(6.8, 6.8, 6.8, 1.0, -50/255, -50/255, -50/255, 0.9, 1.0, 1.2, 1), 0, 0, false, false)
	  end
	  if cNuggetFlags.nuggetZip then
        ldata.nuggetZip = fam.Player
        laser:SetColor(Color(1.0, 1.0, 1.0, 1.0, 0/255, 0/255, 0/255, 6.0, 4.2, 1.0, 1.0), 0, 0, false, false)
	  end
	  if cNuggetFlags.nuggetPoop then
		ldata.nuggetPoop = fam.Player
		mod:setupCanOfBeansInfo(laser, fam.Player, ldata, false)
		local lasercolor = laser.Color
		local lasercolorize = lasercolor:GetColorize()
		local beancolor = Color(1, 1, 1, lasercolor.A, lasercolor.RO, lasercolor.GO, lasercolor.BO,
		                        lasercolor.R * 3.81, lasercolor.G * 2.7, lasercolor.B * 2.28, 1)
		laser:SetColor(lerpColor(beancolor, lasercolor, lasercolorize.A), 0, 0, false, false)
	  end
	  ldata.nuggetFaberge = cNuggetFlags.nuggetFaberge
	  ldata.nuggetHoly = cNuggetFlags.nuggetHoly
	  ldata.nuggetSoap = cNuggetFlags.nuggetSoap
	  if cNuggetFlags.nuggetFortune then
	    ldata.nuggetFortune = fam.Player
		laser:SetColor(Color(1.0, 1.0, 1.0, 1.0, 0/255, 0/255, 0/255, 4.5, 3.44, 2.41, 1), 0, 0, false, false)
	  end

	  Isaac.RunCallbackWithParam(mod.CALLBACK.POST_NUGGET_BOMB_POOTER_FIRE_WEAPON, WeaponType.WEAPON_BRIMSTONE, laser, WeaponType.WEAPON_BRIMSTONE, fam, data.isUltraSpooter, data.isBabySpooter)

	  laser:Update()
	  laser:Update()  --bruh
	  
	  if targetProj and not targetProj:IsDead() then -- wow shielded lasers really suck actually
		targetProj:Die()
	  end
	end
  elseif w_rng == 4 and bFlags[24] then                 -- Pooter shoots crackwave
	local crack = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE, 0, fam.Position, Vector.Zero, player):ToEffect()
	crack.Parent = player
	crack:SetRadii(30,30)
	crack.Timeout = 1
  else                                                  -- Pooter shoots tear
	if not color then color = Color(1, 1, 1, 1, 0, 0, 0) end
	if data.isUltraSpooter then
	  local angles
	  local vels
	  if hex then
		angles = {-22.5, -7.5, 7.5, 22.5}
		vels = {7.028, 7.028, 7.028, 7.028}
	  else
		angles = {-28.118, -9.567, 9.567, 28.118}
		vels = {6.529, 7.028, 7.028, 6.529}
	  end
	  local angle = vel:GetAngleDegrees()

	  for i=1, 4 do
		local velE = Vector.FromAngle(angles[i] + angle) * vel:Length()
		local tearE = Isaac.Spawn(EntityType.ENTITY_TEAR, variant, 0, fam.Position, velE:Normalized()*vels[i], nil):ToTear()
		tearE.Scale = 1.4 * scaleBonus
		tearE.CollisionDamage = 3.5 * dmgBonus
		local tdata = mod:GetEntityData(tearE)
		tdata.nuggetUltra = {color, tearE.Scale}      --used on MC_POST_ENTITY_REMOVE
		tdata.nuggetBladder = cNuggetFlags.nuggetBladder
		tdata.nuggetSplit = cNuggetFlags.nuggetSplit
		tdata.nuggetBlood = cNuggetFlags.nuggetBlood
		tdata.nuggetMulligan = cNuggetFlags.nuggetMulligan
		tdata.nuggetFaberge = cNuggetFlags.nuggetFaberge
		tearE:Update()
		tearE.TearFlags = flags | flagstearonly
		if cNuggetFlags.nuggetHoly then tearE:AddTearFlags(TearFlags.TEAR_LIGHT_FROM_HEAVEN) end
		tearE:SetColor(color, 0, 0, false, false)
		tearE:ResetSpriteScale()
		if targetProj then tearE.Target = targetProj end
		if cNuggetFlags.nuggetExcommunicate then
		  secondHandMultiplier = secondHandMultiplier or (fam.Player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1)
		  FiendFolio.FlagExcommunicate(tearE, mod.AnathemaBal.BaseDuration * secondHandMultiplier, fam.Player.Damage)
		end
	    if cNuggetFlags.nuggetZip then
		  secondHandMultiplier = secondHandMultiplier or (fam.Player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1)
		  FiendFolio.FlagOverload(tearE, 3 * secondHandMultiplier, fam.Player.Damage * 0.4, 45, 15)
	    end
		if cNuggetFlags.nuggetPoop then
		  tearE.FallingSpeed = -10.98
		  tearE.FallingAcceleration = 0.8
		  mod:setupCanOfBeansFlagGeneric(tearE, fam.Player)
		  mod:makeTearBloody(tearE)
		  mod:GetEntityData(tearE).FFBeansInfo.ColorTime = true
		  mod:canOfBeansColorScheduled(tearE)
		end
		if cNuggetFlags.nuggetFlying then
          TearFlagsLib.AddTearFlags(tearE, TearFlagsLib.Flag.YIN_YANG)
		end
		if cNuggetFlags.nuggetFortune then
          TearFlagsLib.AddTearFlags(tearE, TearFlagsLib.Flag.FORTUNE)
		end
		if cNuggetFlags.nuggetSoap then
          TearFlagsLib.AddTearFlags(tearE, TearFlagsLib.Flag.SOAPSUDS)
		  local overlay = tearE:GetTearEffectSprite()
		  overlay:Load("gfx/projectiles/soapsuds_sparkles.anm2", true)
		  overlay:Play("Idle")
		  tearE:ResetSpriteScale()
		end

		Isaac.RunCallbackWithParam(mod.CALLBACK.POST_NUGGET_BOMB_POOTER_FIRE_WEAPON, WeaponType.WEAPON_TEARS, tearE, WeaponType.WEAPON_TEARS, fam, data.isUltraSpooter, data.isBabySpooter)
	  end
	else
	  local tearE = Isaac.Spawn(EntityType.ENTITY_TEAR, variant, 0, fam.Position, vel, nil):ToTear()
	  tearE.Scale = 0.8 * scaleBonus
	  tearE.CollisionDamage = 3.5 * dmgBonus
	  local tdata = mod:GetEntityData(tearE)
	  tdata.nuggetBladder = cNuggetFlags.nuggetBladder
	  tdata.nuggetSplit = cNuggetFlags.nuggetSplit
	  tdata.nuggetBlood = cNuggetFlags.nuggetBlood
	  tdata.nuggetMulligan = cNuggetFlags.nuggetMulligan
	  tdata.nuggetFaberge = cNuggetFlags.nuggetFaberge
	  tearE:Update()
	  tearE.TearFlags = flags | flagstearonly
	  if cNuggetFlags.nuggetHoly then tearE:AddTearFlags(TearFlags.TEAR_LIGHT_FROM_HEAVEN) end
	  tearE:SetColor(color, 0, 0, false, false)
	  tearE:ResetSpriteScale()
	  if targetProj then tearE.Target = targetProj end
	  if cNuggetFlags.nuggetExcommunicate then
		secondHandMultiplier = secondHandMultiplier or (fam.Player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1)
		FiendFolio.FlagExcommunicate(tearE, mod.AnathemaBal.BaseDuration * secondHandMultiplier, fam.Player.Damage)
	  end
	  if cNuggetFlags.nuggetZip then
		secondHandMultiplier = secondHandMultiplier or (fam.Player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1)
		FiendFolio.FlagOverload(tearE, 3 * secondHandMultiplier, fam.Player.Damage * 0.4, 45, 15)
	  end
	  if cNuggetFlags.nuggetPoop then
		tearE.FallingSpeed = -10.98
		tearE.FallingAcceleration = 0.8
		mod:setupCanOfBeansFlagGeneric(tearE, fam.Player)
		mod:makeTearBloody(tearE)
		mod:GetEntityData(tearE).FFBeansInfo.ColorTime = true
		mod:canOfBeansColorScheduled(tearE)
	  end
	  if cNuggetFlags.nuggetFlying then
        TearFlagsLib.AddTearFlags(tearE, TearFlagsLib.Flag.YIN_YANG)
	  end
	  if cNuggetFlags.nuggetFortune then
        TearFlagsLib.AddTearFlags(tearE, TearFlagsLib.Flag.FORTUNE)
	  end
	  if cNuggetFlags.nuggetSoap then
        TearFlagsLib.AddTearFlags(tearE, TearFlagsLib.Flag.SOAPSUDS)
		local overlay = tearE:GetTearEffectSprite()
		overlay:Load("gfx/projectiles/soapsuds_sparkles.anm2", true)
		overlay:Play("Idle")
		tearE:ResetSpriteScale()
	  end

	  Isaac.RunCallbackWithParam(mod.CALLBACK.POST_NUGGET_BOMB_POOTER_FIRE_WEAPON, WeaponType.WEAPON_TEARS, tearE, WeaponType.WEAPON_TEARS, fam, data.isUltraSpooter, data.isBabySpooter)
	end
  end
end

local function canNpcGetOverloaded(npc)
	return (
		npc and
		npc:IsVulnerableEnemy() and
		not npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and
		not npc:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) and
		not npc:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
	)
end

local function getClosestPointOnLine(testPosition, lineOrigin, lineEnd)
	local heading = lineEnd - lineOrigin
	local magnitude = heading:Length()
	heading:Normalize()

	local lhs = testPosition - lineOrigin
	local dot = lhs:Dot(heading)
	dot = math.min(math.max(0, dot), magnitude)
	return lineOrigin + heading * dot
end

local function movePosToClosestLaserSegment(pos, laser)
	local closestPoint = pos
	local closestDist = math.huge
	local capsules
	if laser:IsSampleLaser() then
		capsules = TearFlagsLib.GetLaserSampleCapsules(laser)
	else
		capsules = {TearFlagsLib.GetCapsule(laser.Position, laser.Position + Vector.FromAngle(laser.AngleDegrees) * 9999, laser.Radius)}
	end
	for _, laserCapsule in pairs(capsules) do
		local pointOnLine = getClosestPointOnLine(pos, laserCapsule.Locus1, laserCapsule.Locus2)
		local dist = pointOnLine:Distance(pos)
		if dist < closestDist then
			closestPoint = pointOnLine
			closestDist = dist
		end
	end
	return closestPoint
end

-- nightmare nightmare nightmare
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source, cooldown)
	if flags & DamageFlag.DAMAGE_LASER > 0 and source.Entity and TearFlagsLib.ShouldEntityGetTearCollisionEffects(entity) then
		local ptrhash = GetPtrHash(entity)
		local entityCapsule = TearFlagsLib.GenerateCapsuleFromEntity(entity)
		local damageSources = {}
		for _, laser in pairs(Isaac.FindByType(EntityType.ENTITY_LASER)) do
			local data = mod:GetEntityData(laser)
			data.nuggetHitList = data.nuggetHitList or {}
			if (data.nuggetExcommunicate or data.nuggetFaberge or data.nuggetZip or data.nuggetPoop or data.nuggetHoly or data.nuggetFortune or data.nuggetSoap) and 
			   TearFlagsLib.AreEntitiesSame(laser.SpawnerEntity, source.Entity) and
			   not data.nuggetHitList[ptrhash]
			then
				laser = laser:ToLaser()
				local capsules
				if laser:IsSampleLaser() then
					capsules = TearFlagsLib.GetLaserSampleCapsules(laser)
				else
					capsules = {TearFlagsLib.GetCapsule(laser.Position, laser.Position + Vector.FromAngle(laser.AngleDegrees) * 9999, laser.Radius)}
				end
				for _, laserCapsule in pairs(capsules) do
					if TearFlagsLib.SimulateCapsuleCapsuleCollision(entityCapsule, laserCapsule) then
						if data.nuggetExcommunicate and data.nuggetExcommunicate:Exists() then
							local secondHandMultiplier = data.nuggetExcommunicate:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
							FiendFolio.AddExcommunicated(entity, data.nuggetExcommunicate, mod.AnathemaBal.BaseDuration * secondHandMultiplier, data.nuggetExcommunicate.Damage)
						end
						if data.nuggetFaberge then
							mod:GetEntityData(entity).dropFractionalsIfMortal = true
						end
						if data.nuggetZip and data.nuggetZip:Exists() and canNpcGetOverloaded(entity) then
							local secondHandMultiplier = data.nuggetZip:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
							FiendFolio.AddOverloaded(entity, data.nuggetZip, 0, 3 * secondHandMultiplier, data.nuggetZip.Damage * 0.4, 45, 15, true)
						end
						if data.nuggetPoop and data.nuggetPoop:Exists() and data.FFBeansInfo then
							local params = mod:getCanFartParams(laser, data.nuggetPoop, TearFlagsLib.WeaponFlag.LASER, entity)
							mod:spawnCanFart(laser, data.nuggetPoop, {movePosToClosestLaserSegment(entity.Position, laser)}, params, data.FFBeansInfo, TearFlagsLib.WeaponFlag.LASER)
						end
						if data.nuggetHoly and data.nuggetHoly:Exists() then
							local holylight = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 1, entity.Position, Vector(0,0), data.nuggetHoly)
							holylight.CollisionDamage = 10.5
						end
						if data.nuggetFortune and not data.HasShownFortuneAlready then
							if FiendFolio.FortuneTearCooldown <= 0 then
								--game:ShowFortune()
								mod:ShowFortune(false, true)
								FiendFolio.FortuneTearCooldown = 20
								data.HasShownFortuneAlready = true
							end
						end
						if data.nuggetSoap and data.nuggetSoap:Exists() then
							mod:CleanChampionWithSoap(entity, data.nuggetSoap)
						end
						data.nuggetHitList[ptrhash] = true
						break
					end
				end
			end
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, function(_, tear)
  if tear.SpawnerType == 3 and tear.SpawnerVariant == 115 then
	local fam = tear.SpawnerEntity and tear.SpawnerEntity:ToFamiliar()
	if not fam then return end

	local data = mod:GetEntityData(fam)
	if data.bFlags then
	  if data.bFlags[5] and data.nuggetRNG:RandomInt(4) == 1 then
		local angle = tear.Velocity:GetAngleDegrees()
		for i=0, 5 do
		  local vel = Vector.FromAngle(angle + 60*i) * tear.Velocity:Length()
		  mod:nuggetFlyAttack(fam, vel, true)
		end
	  else
		mod:nuggetFlyAttack(fam, tear.Velocity, false)
	  end
	  FiendFolio.scheduleForUpdate(function()
		tear:Remove()
	  end, 0)
	end
  end
end, 1)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
  local data = mod:GetEntityData(tear)
  if data.nuggetUltra then tear.FallingSpeed = tear.FallingSpeed * 0.65 end
  if data.nuggetBladder and tear.FrameCount % math.ceil(2.5 * tear.Scale + 0.5) == 0 then
	--local creeps = Isaac.FindInRadius(tear.Position, 300*tear.Scale, 0xffffffff)            kilburn medio kilobyte de parche para la api aunque sea
	--for _, c in pairs(creeps) do
	--  if c.Type == 1000 and c.Variant == 53 then c:Remove() end
	--end
	local creep = Isaac.Spawn(1000, 53, 0, tear.Position, Vector(0,0), nil):ToEffect()
	creep.Scale = tear.Scale*0.625
	creep:Update()
	creep.CollisionDamage = 20/7 * tear.CollisionDamage       -- 10 * dmgBonus
	creep:SetTimeout(20)
  end
end)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_DEATH, function(_, tear)
  local data = mod:GetEntityData(tear)
  if data.nuggetUltra then
	local angles = {-156, 156}
	local angle = tear.Velocity:GetAngleDegrees()
	for i=1, 2 do
	  local vel = Vector.FromAngle(angles[i] + angle):Normalized() * 10
	  local tearE = Isaac.Spawn(EntityType.ENTITY_TEAR, tear.Variant, 0, tear.Position, vel, nil):ToTear()
	  tearE.CollisionDamage = tearE.CollisionDamage / 1.4
	  local edata = mod:GetEntityData(tearE)
	  edata.nuggetBladder = data.nuggetBladder
	  edata.nuggetBlood = data.nuggetBlood
	  tearE:SetColor(data.nuggetUltra[1], 0, 0, false, false)
	  tearE.Scale = data.nuggetUltra[2] / 1.4
	  tearE:AddTearFlags(TearFlags.TEAR_BOUNCE)
	end
  end
  if data.nuggetBlood then
	local creep = Isaac.Spawn(1000, 46, 0, tear.Position, Vector(0,0), nil):ToEffect()
	creep.Scale = tear.Size*0.15
	creep:Update()
	creep.CollisionDamage = 4/7 * tear.CollisionDamage      -- 2 * dmgBonus
	creep:SetTimeout(150)
  end
end)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_COLLISION, function(_, tear, collider, low)
  local data = mod:GetEntityData(tear)
  if data.nuggetMulligan and data.nuggetMulligan:Exists() and mod.GetEntityCount(3, 43) < 10 then
	local player = (data.nuggetMulligan.Type == EntityType.ENTITY_PLAYER and data.nuggetMulligan) or data.nuggetMulligan.Player
	if player and collider:ToNPC() and not collider:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) then
		local fly = Isaac.Spawn(3, 43, 0, data.nuggetMulligan.Position, Vector.Zero, player):ToFamiliar()
		fly.Player = player
		fly.Target = collider
		fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	end
  end
  if data.nuggetFaberge then
	mod:GetEntityData(collider).dropFractionalsIfMortal = true
  end
end)

mod:AddCallback(ModCallbacks.MC_POST_FIRE_SPLIT_TEAR, function(_, new, old, splitType)
	local odata = mod:GetEntityData(old)
	if odata.nuggetSplit then
		local ndata = mod:GetEntityData(new)
		new.Velocity = new.Velocity:Normalized() * 4
		ndata.nuggetUltra = odata.nuggetUltra
		ndata.nuggetBladder = odata.nuggetBladder
		ndata.nuggetBlood = odata.nuggetBlood
		ndata.nuggetMulligan = odata.nuggetMulligan
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, eff)
  local effs = Isaac.FindByType(1000, 189, -1, false, false)
  for _, e in pairs(effs) do
	local soul = customPurgatorySouls[e.InitSeed]
	if eff.Position:Distance(e.Position) == 0 and soul then
	  FiendFolio.scheduleForUpdate(function()
		eff.CollisionDamage = 7 * soul.nuggetDmgBonus
		eff.SpriteOffset = e.SpriteOffset
		local flags = soul.nuggetFlags
		local enemies = Isaac.FindInRadius(eff.Position, 35*eff.SpriteScale.X, EntityPartition.ENEMY)
		for _, enemy in pairs(enemies) do
		  if enemy:IsVulnerableEnemy() then
			if (flags & TearFlags.TEAR_POISON) ~= BitSet128(0,0) then     enemy:AddPoison(EntityRef(soul.nuggetFam), 62, 0) end
			if (flags & TearFlags.TEAR_BURN) ~= BitSet128(0,0) then       enemy:AddBurn (EntityRef(soul.nuggetFam), 62, 0) end
			if (flags & TearFlags.TEAR_CONFUSION) ~= BitSet128(0,0) then  enemy:AddConfusion(EntityRef(soul.nuggetFam), 120, false) end
			if (flags & TearFlags.TEAR_CHARM) ~= BitSet128(0,0) then      enemy:AddCharmed(EntityRef(soul.nuggetFam), 150) end
			if (flags & TearFlags.TEAR_EGG) ~= BitSet128(0,0) then        enemy:AddEntityFlags(EntityFlag.FLAG_SPAWN_STICKY_SPIDERS) end
			if (flags & TearFlags.TEAR_GODS_FLESH) ~= BitSet128(0,0) then enemy:AddShrink(EntityRef(soul.nuggetFam), 150, true) end
			if (flags & TearFlags.TEAR_ICE) ~= BitSet128(0,0) then        enemy:AddIce(EntityRef(soul.nuggetFam), 2) end
			if (flags & BitSet128(0,1<<(67-64))) ~= BitSet128(0,0) then   enemy:AddEntityFlags(EntityFlag.FLAG_BAITED) end
			if soul.nuggetBlood then
			  local creep = Isaac.Spawn(1000, 46, 0, eff.Position, Vector(0,0), nil):ToEffect()
			  creep.Scale = eff.SpriteScale.X * 1.5
			  creep:Update()
			  creep.CollisionDamage = 2 * soul.nuggetDmgBonus
			  creep:SetTimeout(150)
			end
			if soul.nuggetMulligan and soul.nuggetMulligan:Exists() and mod.GetEntityCount(3, 43) < 10 then
			  local player = soul.nuggetMulligan.Player
			  if player and enemy:ToNPC() and not enemy:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) then
				local fly = Isaac.Spawn(3, 43, 0, soul.nuggetMulligan.Position, Vector.Zero, player):ToFamiliar()
				fly.Player = player
				fly.Target = enemy
				fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			  end
			end
			if soul.nuggetExcommunicate and soul.nuggetExcommunicate:Exists() then
			  local secondHandMultiplier = soul.nuggetExcommunicate:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
			  FiendFolio.AddExcommunicated(enemy, soul.nuggetExcommunicate, mod.AnathemaBal.BaseDuration * secondHandMultiplier, soul.nuggetExcommunicate.Damage)
			end
			if soul.nuggetFaberge then
			  mod:GetEntityData(enemy).dropFractionalsIfMortal = true
			end
            if soul.nuggetZip and soul.nuggetZip:Exists() and canNpcGetOverloaded(enemy) then
              local secondHandMultiplier = soul.nuggetZip:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
              FiendFolio.AddOverloaded(enemy, soul.nuggetZip, 0, 3 * secondHandMultiplier, soul.nuggetZip.Damage * 0.4, 45, 15, true)
            end
            if soul.nuggetHoly and soul.nuggetHoly:Exists() then
			  local holylight = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 1, enemy.Position, Vector(0,0), soul.nuggetHoly)
			  holylight.CollisionDamage = 10.5
            end
			if soul.nuggetFortune and not soul.HasShownFortuneAlready then
				if FiendFolio.FortuneTearCooldown <= 0 then
					--game:ShowFortune()
					mod:ShowFortune(false, true)
					FiendFolio.FortuneTearCooldown = 20
					soul.HasShownFortuneAlready = true
				end
			end
			if soul.nuggetSoap and soul.nuggetSoap:Exists() then
				mod:CleanChampionWithSoap(enemy, soul.nuggetSoap)
			end
			if (flags & TearFlags.TEAR_COIN_DROP_DEATH) ~= BitSet128(0,0) and enemy:HasMortalDamage() and not enemy:HasEntityFlags(EntityFlag.FLAG_NO_REWARD) then
			  mod.scheduleForUpdate(function()
			    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, enemy.Position, Vector.Zero, nil)
			  end, 2)
			end
		  end
		end
		if soul.nuggetPoop and soul.nuggetPoop:Exists() then game:ButterBeanFart(eff.Position, 120, soul.nuggetPoop, false, false) end
		customPurgatorySouls[e.InitSeed] = nil
	  end, 0)
	end
  end
end, 144)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, soul)
  local data = mod:GetEntityData(soul)
  if data.nuggetBladder and soul.FrameCount % math.ceil(soul.SpriteScale.X + 1) == 0 then
	local creep = Isaac.Spawn(1000, 53, 0, soul.Position, Vector(0,0), nil):ToEffect()
	creep.Scale = soul.SpriteScale.X*0.625
	creep:Update()
	creep.CollisionDamage = 10 * customPurgatorySouls[soul.InitSeed].nuggetDmgBonus        -- 10 * dmgBonus
	creep:SetTimeout(20)
  end
  if data.nuggetAttractor then
    game:UpdateStrangeAttractor(soul.Position, 1 + 29 * math.min(1, soul.Position:Distance(data.nuggetStartPos) / 100))
  end
end, 189)

-- Pointless Future compatibility
function mod:swapParallelNuggets()
	for i, fly in ipairs( Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BROWN_NUGGET_POOTER) ) do
		local data = mod:GetEntityData(fly)
		if data.bFlags and data.bFlags[21] then
			local pos = mod:GetMirroredPosition(fly.Position)
			fly.Position = pos
			fly.TargetPosition = pos
			local sprite = fly:GetSprite()
			sprite.FlipX = not sprite.FlipX
		end
	end
end
mod:AddCallback("POST_MANTIS_CLAP", mod.swapParallelNuggets)