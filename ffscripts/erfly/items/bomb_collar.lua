local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local function determineHealthSafety(player)
	local healthtype = player:GetHealthType()
	if healthtype == HealthType.COIN then
		local numHearts = player:GetHearts()
		local unsafeHealth = {}
		if numHearts >= 2 then
			unsafeHealth[1] = true
		end
		if numHearts >= 4 then
			unsafeHealth[2] = true
		end
		return unsafeHealth, math.min(4, numHearts), math.max(0, numHearts - 4)
	elseif healthtype == HealthType.LOST or 
		   CustomHealthAPI.Helper.IsFoundSoul(player) or
		   player:IsCoopGhost()
	then
		return {[1] = true}, 0, 0
	elseif player:GetPlayerType() == FiendFolio.PLAYER.CHINA then
		local numLimit = player:GetHeartLimit()
		local trueLimit = CustomHealthAPI.Helper.GetTrueHeartLimit(player)
		local unsafeHealth = {}
		unsafeHealth[math.max(1, math.ceil(trueLimit / 2) + 1)] = true
		unsafeHealth[math.max(1, math.ceil(trueLimit / 2))] = true
		return unsafeHealth, math.min(4, numLimit), math.max(0, numLimit - 4)
	end
	
	local data = CustomHealthAPI.Helper.GetSavedata(player)
	if not data then
		CustomHealthAPI.Helper.CheckIfHealthOrderSet()
		CustomHealthAPI.Helper.CheckHealthIsInitializedForPlayer(player)
		CustomHealthAPI.Helper.CheckSubPlayerInfoOfPlayer(player)
		data = CustomHealthAPI.Helper.GetSavedata(player)
	end
	
	data.Cached = data.Cached or {}
	if data.Cached.BombCollarUnsafeHealth ~= nil then
		return data.Cached.BombCollarUnsafeHealth, data.Cached.BombCollarNumUnsafeHealth, data.Cached.BombCollarNumSafeHealth
	end
	
	local redMasks = data.RedHealthMasks or {}
	local otherMasks = data.OtherHealthMasks or {}
	
	local healthOrder = CustomHealthAPI.Helper.GetHealthOrder(player)
	local earlyUnsafe = {}
	local midUnsafe = {}
	local lateUnsafe = {}
	local hasCrowHeart = player:HasTrinket(TrinketType.TRINKET_CROW_HEART)
	for i = 1, #healthOrder do
		local orderEntry = healthOrder[i]
		local otherIndices = orderEntry.Other
		local otherHealth = otherMasks[otherIndices[1]][otherIndices[2]]
		local otherHealthDef = CustomHealthAPI.PersistentData.HealthDefinitions[otherHealth.Key]
			
		if otherHealthDef.Type == CustomHealthAPI.Enums.HealthTypes.CONTAINER and
		   otherHealthDef.KindContained ~= CustomHealthAPI.Enums.HealthKinds.NONE
		then
			if hasCrowHeart then
				if otherHealthDef.MaxHP > 0 then
					table.insert(midUnsafe, i)
				else
					table.insert(lateUnsafe, i)
				end
			else
				table.insert(earlyUnsafe, i)
			end
		elseif otherHealthDef.Type == CustomHealthAPI.Enums.HealthTypes.SOUL then
			table.insert(earlyUnsafe, i)
		end
	end
	
	local unsafeHealth = {}
	local totalUnsafeHealth = 0
	while totalUnsafeHealth < 2 do
		if #earlyUnsafe > 0 then
			local index = earlyUnsafe[1]
			unsafeHealth[index] = true
			table.remove(earlyUnsafe, 1)
			totalUnsafeHealth = totalUnsafeHealth + 1
		elseif #midUnsafe > 0 then
			local index = midUnsafe[1]
			unsafeHealth[index] = true
			table.remove(midUnsafe, 1)
			totalUnsafeHealth = totalUnsafeHealth + 1
		elseif #lateUnsafe > 0 then
			local index = lateUnsafe[1]
			unsafeHealth[index] = true
			table.remove(lateUnsafe, 1)
			totalUnsafeHealth = totalUnsafeHealth + 1
		else
			break
		end
	end
	
	local numSafeHealth = 0
	local numUnsafeHealth = 0
	for i = 1, #healthOrder do
		local orderEntry = healthOrder[i]
		local otherIndices = orderEntry.Other
		local otherHealth = otherMasks[otherIndices[1]][otherIndices[2]]
		local otherHealthDef = CustomHealthAPI.PersistentData.HealthDefinitions[otherHealth.Key]
			
		if otherHealthDef.Type == CustomHealthAPI.Enums.HealthTypes.CONTAINER and
		   otherHealthDef.KindContained ~= CustomHealthAPI.Enums.HealthKinds.NONE
		then
			local redIndices = orderEntry.Red
			if redIndices ~= nil then
				local redHealth = redMasks[redIndices[1]][redIndices[2]]
				local redHealthDef = CustomHealthAPI.PersistentData.HealthDefinitions[redHealth.Key]
				if unsafeHealth[i] then
					if redHealthDef.MaxHP > redHealth.HP then
						numUnsafeHealth = numUnsafeHealth + 1
					else
						numUnsafeHealth = numUnsafeHealth + 2
					end
				else
					numSafeHealth = numSafeHealth + redHealth.HP
				end
			end
			if not unsafeHealth[i] then
				numSafeHealth = numSafeHealth + otherHealth.HP
			end
		elseif otherHealthDef.Type == CustomHealthAPI.Enums.HealthTypes.SOUL then
			if unsafeHealth[i] then
				if otherHealthDef.MaxHP > otherHealth.HP then
					numUnsafeHealth = numUnsafeHealth + 1
				else
					numUnsafeHealth = numUnsafeHealth + 2
				end
			else
				numSafeHealth = numSafeHealth + otherHealth.HP
			end
		end
	end
	
	data.Cached.BombCollarUnsafeHealth = unsafeHealth
	data.Cached.BombCollarNumUnsafeHealth = numUnsafeHealth
	data.Cached.BombCollarNumSafeHealth = numSafeHealth
	return unsafeHealth, numUnsafeHealth, numSafeHealth
end

local function getSafeHealth(player)
	local healthtype = player:GetHealthType()
	if healthtype == HealthType.COIN then
		return math.max(0, player:GetHearts() - 4)
	elseif healthtype == HealthType.LOST or 
		   CustomHealthAPI.Helper.IsFoundSoul(player) or
		   player:IsCoopGhost()
	then
		return 0
	elseif player:GetPlayerType() == FiendFolio.PLAYER.CHINA then
		return math.max(0, player:GetHeartLimit() - 4)
	else
		local _, _, numSafeHealth = determineHealthSafety(player)
		return numSafeHealth
	end
end

local function getUnsafeHealth(player)
	local healthtype = player:GetHealthType()
	if healthtype == HealthType.COIN then
		return math.min(4, player:GetHearts())
	elseif healthtype == HealthType.LOST or 
		   CustomHealthAPI.Helper.IsFoundSoul(player) or
		   player:IsCoopGhost()
	then
		return 0
	elseif player:GetPlayerType() == FiendFolio.PLAYER.CHINA then
		return math.min(4, player:GetHeartLimit())
	else
		local _, numUnsafeHealth = determineHealthSafety(player)
		return numUnsafeHealth
	end
end

function mod:calculateBombCollarTears(player)
    local val = getSafeHealth(player)
    local mult = 1 + (0.5 / (1 + (val/5)))
    return mult
end

local splodeTimer = 10

function mod:bombCollarPeffectUpdate(player)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.BOMB_COLLAR) then
        local data = mod:GetEntityData(player)
        local safeHealth = getSafeHealth(player)
        if safeHealth <= 0 and not player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE) and not data.BombCollarExplosionTimer then
            if player.FrameCount % 30 == 0 then
                data.BombCollarHealthBeep = data.BombCollarHealthBeep or 0.5
                if data.BombCollarHealthBeep > 0 then
                    sfx:Play(mod.Sounds.BombCollarTrigger, data.BombCollarHealthBeep, 0, false, 0.75)
                    data.BombCollarHealthBeep = data.BombCollarHealthBeep - 0.1
                end
            end
        else
            data.BombCollarHealthBeep = nil
        end
        if data.BombCollarExplosionTimer then
			local unsafeHealth = getUnsafeHealth(player)
            if unsafeHealth >= 4 or safeHealth > 0 then
                sfx:Stop(mod.Sounds.BombCollarTrigger)
                if data.BombCollarExplosionTimer ~= splodeTimer then
                    sfx:Play(FiendFolio.Sounds.CopperBombSizzle, 1.2, 0, false, 1.25 + math.random() * 0.25)
                end
                data.BombCollarExplosionTimer = nil
            else
                if data.BombCollarExplosionTimer == splodeTimer then
                    sfx:Play(mod.Sounds.BombCollarTrigger)
                end
                data.BombCollarExplosionTimer = data.BombCollarExplosionTimer - 1
                if data.BombCollarExplosionTimer <= 0 then
                    player:RemoveCollectible(mod.ITEM.COLLECTIBLE.BOMB_COLLAR)
					
					player:ResetDamageCooldown()
					local isPlayerInvincible = player:TakeDamage(1, 0, EntityRef(player), 0)
					if isPlayerInvincible then
						mod:removeAllHearts(player)
					end
					mod:explodePlayer(player, not isPlayerInvincible)
					
                    local bomb = Isaac.Spawn(4, 17, BombSubType.BOMB_GIGA, player.Position, Vector.Zero, player):ToBomb()
                    bomb:SetExplosionCountdown(0)
                    bomb:Update()
					
					data.BombCollarExplosionTimer = nil
                end
            end
        end
    else
		data.BombCollarExplosionTimer = nil
		data.BombCollarHealthBeep = nil
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.BOMB_COLLAR, mod.bombCollarPeffectUpdate)

function mod:bombCollarCheck(entity, amount, flags)
	if flags & DamageFlag.DAMAGE_FAKE ~= DamageFlag.DAMAGE_FAKE then
		local player = entity:ToPlayer()
		if player and player:HasCollectible(mod.ITEM.COLLECTIBLE.BOMB_COLLAR) then
			mod:GetEntityData(player).BombCollarHealthBeep = nil
			local currentHealth = getUnsafeHealth(player)
			if currentHealth < 4 and mod:GetEntityData(player).BombCollarProtectingUnsafe ~= game:GetFrameCount() then
				local healthtype = player:GetHealthType()
				if healthtype == HealthType.LOST or 
				   CustomHealthAPI.Helper.IsFoundSoul(player) or
				   player:IsCoopGhost()
				then
					player:RemoveCollectible(mod.ITEM.COLLECTIBLE.BOMB_COLLAR)
					
                    local bomb = Isaac.Spawn(4, 17, BombSubType.BOMB_GIGA, player.Position, Vector.Zero, player):ToBomb()
                    bomb:SetExplosionCountdown(0)
                    bomb:Update()
					
					if player:IsDead() then
						player:Revive()
					end
					mod:explodePlayer(player)
				else
					mod:GetEntityData(player).BombCollarExplosionTimer = splodeTimer
				end
			end
		end
    end
end
mod:AddPriorityCollectibleCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, CallbackPriority.LATE, mod.ITEM.COLLECTIBLE.BOMB_COLLAR, mod.bombCollarCheck, 1)

function mod:bombCollarCheckDangerFlash(healthDefinition, hasRedHealth, redKey, player, healthSlot, redHealthIndex, overlays, isSubPlayer)
	if not isSubPlayer then
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.BOMB_COLLAR) then
			local unsafeHealth, _, numSafeHealth = determineHealthSafety(player)
			local shouldDangerFlash = numSafeHealth <= 0 and not player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
			
			if unsafeHealth[healthSlot] and shouldDangerFlash then
				return true
			end
		end
	end
end
mod:AddCollectibleCallback(CustomHealthAPI.Enums.Callbacks.SHOULD_DANGER_FLASH, mod.ITEM.COLLECTIBLE.BOMB_COLLAR, mod.bombCollarCheckDangerFlash)

local bombCollarAlert = Sprite()
bombCollarAlert:Load("gfx/ui/ui_heart_warning.anm2", true)

function mod:bombCollarHealthRender(player, playerSlot, healthIndex, renderInfo)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.BOMB_COLLAR) then
        bombCollarAlert:SetFrame("Alert!", 0)
        local unsafeHealth = determineHealthSafety(player)
		if unsafeHealth[renderInfo.OrderIndex] then
			CustomHealthAPI.Helper.RenderHealth(bombCollarAlert, player, playerSlot, healthIndex, renderInfo.RenderOffset, renderInfo.TotalHealthRendered, renderInfo.ExtraOffset, false, renderInfo.Flip, renderInfo.Scale, renderInfo.Color)
        end
	end
end
mod:AddPriorityCollectibleCallback(CustomHealthAPI.Enums.Callbacks.POST_HEALTH_RENDER, CallbackPriority.LATE, mod.ITEM.COLLECTIBLE.BOMB_COLLAR, mod.bombCollarHealthRender)

function mod:bombCollarPreHPBarRender(player, playerSlot, renderOffset, flip)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.BOMB_COLLAR) then
		local healthtype = player:GetHealthType()
		if healthtype == HealthType.LOST or 
		   CustomHealthAPI.Helper.IsFoundSoul(player) or
		   player:IsCoopGhost()
		then
			bombCollarAlert:SetFrame("Alert!", 0)
			local color = Color()
			if not player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE) then
				color.RO = math.max(0, ((Game():GetFrameCount() % 45) - 9) / 9 * -1)
			end
			CustomHealthAPI.Helper.RenderHealth(bombCollarAlert, player, playerSlot, 0, renderOffset, nil, nil, nil, flip, nil, color)
		elseif player:GetPlayerType() == FiendFolio.PLAYER.CHINA then
			local trueLimit = CustomHealthAPI.Helper.GetTrueHeartLimit(player)
			bombCollarAlert:SetFrame("Alert!", 0)
			local color = Color()
			if getSafeHealth(player) <= 0 and not player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE) then
				color.RO = math.max(0, ((Game():GetFrameCount() % 45) - 9) / 9 * -1)
			end
			CustomHealthAPI.Helper.RenderHealth(bombCollarAlert, player, playerSlot, math.max(0, math.ceil(trueLimit / 2) - 1), renderOffset, nil, nil, nil, flip, nil, color)
			CustomHealthAPI.Helper.RenderHealth(bombCollarAlert, player, playerSlot, math.max(0, math.ceil(trueLimit / 2) - 2), renderOffset, nil, nil, nil, flip, nil, color)
        end
	end
end
mod:AddPriorityCollectibleCallback(CustomHealthAPI.Enums.Callbacks.PRE_RENDER_HP_BAR, CallbackPriority.LATE, mod.ITEM.COLLECTIBLE.BOMB_COLLAR, mod.bombCollarPreHPBarRender)

function mod:bombCollarLives(player, numLives, isChance, ignoredHealth, playerSlot, numRowsRendered, numColumnsRendered)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.BOMB_COLLAR) then
		local healthtype = player:GetHealthType()
		if healthtype == HealthType.LOST or 
		   CustomHealthAPI.Helper.IsFoundSoul(player) or
		   player:IsCoopGhost()
		then
			return {NumRowsRendered = math.max(1, numRowsRendered), NumColumnsRendered = math.max(1, numColumnsRendered)}
		elseif player:GetPlayerType() == FiendFolio.PLAYER.CHINA then
			local maxColumns = 6
			if not REPENTANCE_PLUS and playerSlot ~= 0 and playerSlot ~= 4 then
				maxColumns = 3
			end
			if CustomHealthAPI.Constants.HEARTS_PER_ROW > 0 then maxColumns = CustomHealthAPI.Constants.HEARTS_PER_ROW end
			
			local trueLimit = math.ceil(CustomHealthAPI.Helper.GetTrueHeartLimit(player) / 2)
			return {NumRowsRendered = math.max(math.max(0, math.ceil(trueLimit / maxColumns)), numRowsRendered), NumColumnsRendered = math.max(math.max(0, math.min(trueLimit, maxColumns)), numColumnsRendered)}
		end
	end
end
mod:AddCollectibleCallback(CustomHealthAPI.Enums.Callbacks.PRE_RENDER_LIVES, mod.ITEM.COLLECTIBLE.BOMB_COLLAR, mod.bombCollarLives)

mod:AddCollectibleCallback(CustomHealthAPI.Enums.Callbacks.PRE_PLAYER_DAMAGE, mod.ITEM.COLLECTIBLE.BOMB_COLLAR, function(_, player)
	local frame = game:GetFrameCount()
	local data = mod:GetEntityData(player)
	if data.BombCollarLastCheckedSafe ~= frame and getSafeHealth(player) > 0 then
		data.BombCollarProtectingUnsafe = game:GetFrameCount()
	end
	data.BombCollarLastCheckedSafe = frame
end)

function mod:bombCollarProtectUnsafeHealth(player, health, index)
	local frame = game:GetFrameCount()
	local data = mod:GetEntityData(player)
	if data.BombCollarLastCheckedSafe ~= frame and getSafeHealth(player) > 0 then
		data.BombCollarProtectingUnsafe = game:GetFrameCount()
	end
	data.BombCollarLastCheckedSafe = frame
	
	if data.BombCollarProtectingUnsafe == game:GetFrameCount() and player:HasCollectible(mod.ITEM.COLLECTIBLE.BOMB_COLLAR) then
		local healthtype = player:GetHealthType()
		if not (healthtype == HealthType.COIN or
		        healthtype == HealthType.LOST or 
		        CustomHealthAPI.Helper.IsFoundSoul(player) or
		        player:IsCoopGhost() or
		        player:GetPlayerType() == FiendFolio.PLAYER.CHINA)
		then
			local unsafeIndices = determineHealthSafety(player)
			if unsafeIndices[index] then
				return true
			end
		end
	end
end
mod:AddCollectibleCallback(CustomHealthAPI.Enums.Callbacks.IGNORE_HEALTH_FOR_DAMAGE, mod.ITEM.COLLECTIBLE.BOMB_COLLAR, mod.bombCollarProtectUnsafeHealth)

function mod:bombCollarUpdateHealthState(player)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.BOMB_COLLAR) then
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
	    player:EvaluateItems()
    end
end
mod:AddCollectibleCallback(CustomHealthAPI.Enums.Callbacks.POST_UPDATE_HEALTH_STATE, mod.ITEM.COLLECTIBLE.BOMB_COLLAR, mod.bombCollarUpdateHealthState)

function mod:clearBombCollarCache(player)
	local data = CustomHealthAPI.Helper.GetSavedata(player)
	if not data then
		CustomHealthAPI.Helper.CheckIfHealthOrderSet()
		CustomHealthAPI.Helper.CheckHealthIsInitializedForPlayer(player)
		CustomHealthAPI.Helper.CheckSubPlayerInfoOfPlayer(player)
		data = CustomHealthAPI.Helper.GetSavedata(player)
	end
	if data then
		data.Cached = data.Cached or {}
		data.Cached.BombCollarUnsafeHealth = nil
		data.Cached.BombCollarNumUnsafeHealth = nil
		data.Cached.BombCollarNumSafeHealth = nil
	end
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.clearBombCollarCache, mod.ITEM.COLLECTIBLE.BOMB_COLLAR)
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, mod.clearBombCollarCache, TrinketType.TRINKET_CROW_HEART)
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, mod.clearBombCollarCache, TrinketType.TRINKET_CROW_HEART)