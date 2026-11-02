-- Time Fcuk'd Transformation --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

function mod:handleTimeFcukTransformation(player, amount)
	-- for testing purposes
	if BasementRenovator and BasementRenovator.InTestRoom and BasementRenovator:InTestRoom() then
		return
	end

    local eff = player:GetEffects()
    if amount == 1 then
        player:AddNullItemEffect(mod.ITEM.NULL.NORAD_TIME_FCUK_TRANSFORMATION_TRACKER, true)
    elseif amount == -1 then
        eff:RemoveNullEffect(mod.ITEM.NULL.NORAD_TIME_FCUK_TRANSFORMATION_TRACKER, 1)
    end

    local isFcukd = eff:HasNullEffect(mod.ITEM.NULL.TIME_FCUK_TRANSFORMATION)
    if eff:GetNullEffectNum(mod.ITEM.NULL.NORAD_TIME_FCUK_TRANSFORMATION_TRACKER) >= 3 or game.Challenge == FiendFolio.challenges.theEndIsNeverTheEnd then
        if not isFcukd then
            player:AddNullItemEffect(mod.ITEM.NULL.TIME_FCUK_TRANSFORMATION, true)

			if game.Challenge ~= FiendFolio.challenges.theEndIsNeverTheEnd then
				local sdata = mod:GetEntityData(player).ffsavedata
				if not sdata.GaveStevenTransformationHearts then FiendFolio:AddStevenHearts(player, 3) end
				sdata.GaveStevenTransformationHearts = true

				Game():GetHUD():ShowItemText("Time Fcuk'd!")
				sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER)

				if not FiendFolio.ACHIEVEMENT.GET_IN_THE_BOX:IsUnlocked(true) then
					FiendFolio.ACHIEVEMENT.GET_IN_THE_BOX:Unlock()
				end
			end
        end
    else --Based on how mom transformation works
        if isFcukd then
            eff:RemoveNullEffect(mod.ITEM.NULL.TIME_FCUK_TRANSFORMATION, eff:GetNullEffectNum(mod.ITEM.NULL.TIME_FCUK_TRANSFORMATION))
        end
    end
end

function mod:timeFcukTransformationCheckItemAdded(collectibleType, charge, firstTime, slot, varData, player)
    if firstTime then
        mod:handleTimeFcukTransformation(player, 1)
    end
end
function mod:timeFcukTransformationCheckItemRemoved(player, collectibleType, removeForm)
    --Procs before POST_ADD_COLLECTIBLE, so scheduling or else you can pick up actives and get a double up
    mod.scheduleForUpdate(function()
        if removeForm then
            mod:handleTimeFcukTransformation(player, -1)
        end
    end, 0, ModCallbacks.MC_POST_RENDER, true)
end

mod:AddPriorityCallback(ModCallbacks.MC_POST_MODS_LOADED, math.huge, function()
	for i = 1, #FiendFolio.TimeFcukItems do
		mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.timeFcukTransformationCheckItemAdded, FiendFolio.TimeFcukItems[i])
		mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.timeFcukTransformationCheckItemRemoved, FiendFolio.TimeFcukItems[i])
	end
end)
if ModReloadDetector.ModsLoaded then
	for i = 1, #FiendFolio.TimeFcukItems do
		mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.timeFcukTransformationCheckItemAdded, FiendFolio.TimeFcukItems[i])
		mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.timeFcukTransformationCheckItemRemoved, FiendFolio.TimeFcukItems[i])
	end
end

local function findRandomPathablePos(rng, origpos, isFlying)
    local room = game:GetRoom()
	local origgridindex = room:GetGridIndex(origpos)
	local origgridpos = room:GetGridPosition(origgridindex)
	local gridsToCheck = {origgridpos + Vector(40,0), origgridpos + Vector(-40,0), origgridpos + Vector(0,40), origgridpos + Vector(0,-40)}
	local checkedGrids = {[origgridindex] = true}
    local validPositions = {}
	while (#gridsToCheck > 0) do
		local gridpos = gridsToCheck[1]
		local gridindex = room:GetGridIndex(gridpos)
		if not checkedGrids[gridindex] and room:GetGridCollisionAtPos(gridpos) == GridCollisionClass.COLLISION_NONE and room:IsPositionInRoom(gridpos, 0) then
			local dist = math.abs(origgridpos.X - gridpos.X) / 40 + math.abs(origgridpos.Y - gridpos.Y) / 40
			if dist >= 3 then
				table.insert(validPositions, gridpos)
			end

			checkedGrids[gridindex] = true
			table.insert(gridsToCheck, gridpos + Vector(40,0))
			table.insert(gridsToCheck, gridpos + Vector(-40,0))
			table.insert(gridsToCheck, gridpos + Vector(0, 40))
			table.insert(gridsToCheck, gridpos + Vector(0, -40))
		end
		table.remove(gridsToCheck, 1)
	end
	if #validPositions > 0 then
		return validPositions[rng:RandomInt(#validPositions) + 1]
	end
end

function mod:timeFcukTeleportToPosition(player, targPos)
	sfx:Play(FiendFolio.Sounds.StevenTransformationTeleport, 1.0, 0, false, 1)
    --sfx:Play(SoundEffect.SOUND_HELL_PORTAL1, 0.65, 0, false, 1)
    local dist = targPos - player.Position
	local steps = math.max(math.floor(dist:Length() / 20), 8)
    for i = 1, steps do
        local trail = Isaac.Spawn(1000, EffectVariant.HAEMO_TRAIL, 0, player.Position + (dist * i)/steps, nilvector, player):ToEffect()
        trail.SpriteScale = Vector(0.75,0.75) * i/steps
        trail.SpriteOffset = Vector(0,-10)
        trail.Color = (math.random(2) == 1 and Color(0,0,0,1,0,0,0)) or Color(0,0,0,1,1,1,1)
		trail:GetSprite().PlaybackSpeed = 0.5
        trail:Update()
    end
    player:Teleport(targPos, false)
    player:SetColor(Color(1,1,1,1,1,1,1), 5, 10, true, false)
    player:SetMinDamageCooldown(60 * (player:GetTrinketMultiplier(TrinketType.TRINKET_BLIND_RAGE) + 1))
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if entity:IsVulnerableEnemy() and (not mod:isFriend(entity:ToNPC())) or entity.Type == 33 then
            local distance = (player.Position - entity.Position):Length()
            if entity.Type == 33 then
                if distance - player.Size - entity.Size <= 0 then
                    entity:Die()
                end
            elseif distance - player.Size - entity.Size <= 20 then
                entity:AddEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
                entity:TakeDamage(40 + (player.Damage * 3), 0, EntityRef(player), 0)
                mod.scheduleForUpdate(function()
                    if entity then
                        if not (entity:IsDead() or entity:HasMortalDamage()) then
                            entity:ClearEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
                        end
                    end
                end, 1)
            end
        end
    end
end

function mod:tryTimeFcukTeleport(player, flag, source, cooldown)
	if player:GetEffects():HasNullEffect(mod.ITEM.NULL.TIME_FCUK_TRANSFORMATION) and
	   not mod:isDamageSelfInflicted(flag, source, nil, true) and
	   player:GetDamageCooldown() <= 0 and
	   not (flag & (DamageFlag.DAMAGE_EXPLOSION | DamageFlag.DAMAGE_FIRE) ~= 0 and player:HasCollectible(CollectibleType.COLLECTIBLE_PYROMANIAC))
	then
		local data = mod:GetEntityData(player)
		if data.timeFcukRNG == nil then
			data.timeFcukRNG = RNG()
			data.timeFcukRNG:SetSeed(math.max(1, player.InitSeed), game:GetFrameCount() % 80)
		end

		if data.timeFcukRNG:RandomInt(2) == 1 then
			local targ = findRandomPathablePos(data.timeFcukRNG, player.Position, player.IsFlying)
			if targ then
				mod:timeFcukTeleportToPosition(player, targ)
				for i = 45, 360, 45 do
					local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, FiendFolio.TEAR.MULTI_EUCLIDEAN, 0, player.Position, Vector.FromAngle(i) * 10, player):ToTear()
					tear.CollisionDamage = 10
					tear.TearFlags = TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_PIERCING | TearFlags.TEAR_CONTINUUM
					tear.Scale = mod:getTearParamsScale(player, tear.CollisionDamage, tear.TearFlags)
					tear.FallingAcceleration = -0.052
					tear.FallingSpeed = 0
					mod:GetEntityData(tear).forceColor = Color()
					tear:Update()
				end
				return false
			end
		end
	end
end

function mod:timeFcukHandleIFrames(player)
	local data = mod:GetEntityData(player)
	local damageCooldown = player:GetDamageCooldown()
	if player:GetEffects():HasNullEffect(mod.ITEM.NULL.TIME_FCUK_TRANSFORMATION) and damageCooldown > 1 and not data.didTimeFcukIFrameIncrease then
		player:ResetDamageCooldown()
		player:SetMinDamageCooldown(damageCooldown + 60)
		data.didTimeFcukIFrameIncrease = true
	elseif damageCooldown <= 1 then
		data.didTimeFcukIFrameIncrease = nil
	end
end
mod:AddPlayerTempEffectCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Isaac.GetItemConfig():GetNullItem(mod.ITEM.NULL.TIME_FCUK_TRANSFORMATION), mod.timeFcukHandleIFrames)
