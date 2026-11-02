-- Hidden

local mod = FiendFolio
local game = Game()

local statusflag = mod:RegisterEnemyStatusEffect("HIDDEN", 90, "hiddenOnUpdate", {})
local statusColourPriority = -1 --really low priority for obvious reasons

local dmgIncrement = 10
local basedmg = 1.3
local floorScalar = 0.4

local flashIncrement = 23
local flashDuration = 6
local flashColour = Color(0, 0, 0, 0.4)
local altFlashColour = Color(0, 0, 0, 0.4, 0, 0, 0.2)
local absenceColour = Color(0,0,0,0)

function mod:handleHidden(npc, data, sprite)
    if data.ff_hiddenTimer <= 15 then
        --initial flashes of colour
        --print("help")
        --npc:SetColor(flashColour, 13, statusColourPriority-2, true, false)
        local num = 1 - ((data.ff_hiddenTimer / 15) ^ 0.7)
        npc:SetColor(Color(0,0,0,(num^0.3),num,num,num), 1, statusColourPriority-5, true, false)
    end
    if data.ff_hiddenTimer % dmgIncrement == 0 then
        --dmg the enemy, does funny flag stuff to prevent it from revealing the enemy
        local level = game:GetLevel()
        
        data.ffHiddenDontReveal = true
        local dmg = basedmg + (floorScalar*level:GetAbsoluteStage())
		npc:TakeDamage(dmg, DamageFlag.DAMAGE_NOKILL | DamageFlag.DAMAGE_POISON_BURN, data.FFHiddenSource, 0)
        data.ffHiddenDontReveal = false
    end
    if data.ff_hiddenTimer % flashIncrement == 0 then
        mod:hiddenBroadcastEnemy(npc, sprite)
    end
	npc:SetColor(FiendFolio.StatusEffectColors.Hidden, 1, statusColourPriority, false, false)
    data.ff_hiddenTimer = data.ff_hiddenTimer + 1
end

local palinsopiaColour = Color(0,0,0,1,0.6,0.6,0.6)
function mod:hiddenBroadcastEnemy(npc, sprite, tear, posOverride, timeout)
    mod.initFlashController()

    local pos = (posOverride or npc.Position) + npc.PositionOffset
    local s = sprite:Copy()
    local c = npc.HitPoints < 1 and altFlashColour or flashColour
    local t = { s = s, pos = pos, dur = flashDuration, mc = c, c = c, timeout = timeout}
    if tear then
        t.mc = palinsopiaColour
        t.killSignal = npc.Index
    end

    local data = mod:GetEntityData(mod.flashController)
    table.insert(data.flashingEnemies, t)
end

function mod.initFlashController()
    if not mod.flashController or not mod.flashController:Exists() then
		mod.flashController = Isaac.FindByType(EntityType.ENTITY_EFFECT, mod.FF.BeahInvisible.Var, 20)[1]
		if mod.flashController == nil then
			local flashMaster = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.FF.BeahInvisible.Var, 20, Vector(100, 100), Vector.Zero, nil)
			flashMaster.DepthOffset = -9999
			mod.flashController = flashMaster

            local data = mod:GetEntityData(mod.flashController)
            data.flashingEnemies = {}
		end
    end
end

local function updateFlashes(_, ent)
	if ent.SubType ~= 20 then
        return
    end

    local data = mod:GetEntityData(ent)
    local newflashingenemies = {}
    for index, value in ipairs(data.flashingEnemies) do
        if value.dur ~= 0 or value.killSignal ~= nil then
			if value.timeout then
				value.timeout = value.timeout - 1
				if value.timeout <= 0 then
					value.killSignal = nil
					value.dur = 1
				end
			end
			
            local lerp = value.dur / flashDuration
            if lerp > 0 then
                lerp = lerp ^ 0.7
            end
            if value.killSignal ~= nil then
                lerp = math.max(lerp, 0.08)
			else
				lerp = value.dur / 2 * 0.08
            end

            local acolor = absenceColour
            local c = Color.Lerp(acolor, value.mc, lerp)
            value.c = c

            value.dur = value.dur - 1
            table.insert(newflashingenemies, value)
        end
    end
    data.flashingEnemies = newflashingenemies
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, updateFlashes, mod.FF.BeahInvisible.Var)

function mod:hiddenKillSignal(killSignal)
    if not mod.flashController then
        return
    end


    local data = mod:GetEntityData(mod.flashController)
    local newflashingenemies = {}
    for index, value in ipairs(data.flashingEnemies) do
        if value.killSignal == killSignal then
            value.killSignal = nil
            value.dur = 1
        end
        table.insert(newflashingenemies, value)
    end
    data.flashingEnemies = newflashingenemies
end

local function renderFlashes(_, ent)
    if ent.SubType ~= 20 then
        return
    end
    local room = game:GetRoom()
    if room:GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
        return
    end

    local data = mod:GetEntityData(ent)

    for index, value in ipairs(data.flashingEnemies) do
        local rpos = Isaac.WorldToScreen(value.pos)
        local s = value.s
        s.Color = value.c

        s:Render(rpos)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, renderFlashes, mod.FF.BeahInvisible.Var)

function mod:hiddenOnUpdate(npc, data, sprite, clearingStatus)
    if not clearingStatus and data.ff_hiddenTimer then
	    mod:handleHidden(npc, data, sprite) 
    else
        data.ff_hiddenTimer = nil
	    mod:UntrackEnemyStatus(npc, statusflag)
    end
end

function mod:hiddenOnDamage(ent, amount, flags)
    if flags & DamageFlag.DAMAGE_CLONES ~= 0 then
        return
    end
    local data = mod:GetEntityData(ent)
    if data.ff_hiddenTimer == nil then
        return
    end
    if data.ffHiddenDontReveal == true then
        return
    end
    
    FiendFolio.RemoveHidden(ent)
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, mod.hiddenOnDamage)

function mod.AddHidden(entity, source, duration, isCloned)
	if not (entity and entity:ToNPC()) then
		return
	end
	
	if (entity.Type == EntityType.ENTITY_MASK or (entity.Type == EntityType.ENTITY_MASK_OF_INFAMY and entity.Parent)) and not isCloned then
		return
	end
	
	if Isaac.RunCallbackWithParam(ModCallbacks.MC_PRE_STATUS_EFFECT_APPLY, "FFHidden", "FFHidden", entity, EntityRef(source), duration) == false then
		return
	end
	
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				mod.AddHidden(segment, source, duration, true)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				mod.AddHidden(segment, source, duration, true)
			end
		end
	end

	local data = mod:GetEntityData(entity)
	--[[local isBoss = entity:IsBoss()
	if isBoss and entity:GetBossStatusEffectCooldown() > 0 then
		--do nothing
	else]]if not (entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) or mod:isStatusBlacklisted(entity)) or 
	       ((entity.Type == EntityType.ENTITY_MASK or entity.Type == EntityType.ENTITY_MASK_OF_INFAMY) and isCloned) 
	then
        data.ff_hiddenTimer = 0
        data.FFHiddenSource = EntityRef(source)
		entity:SetColor(FiendFolio.StatusEffectColors.Hidden, 1, statusColourPriority, false, false)
        entity:SetShadowSize(0)
        mod.initFlashController()
		
		--[[if isBoss then
			entity:SetBossStatusEffectCooldown(FiendFolio.StatusEffectVariables.BossStatusResistanceFrameCount)
		end]]
		
		mod:TrackEnemyStatus(entity, statusflag)
		
		Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_STATUS_EFFECT_APPLY, "FFHidden", "FFHidden", entity, EntityRef(source), duration)
	end
end

function FiendFolio.RemoveHidden(entity, isCloned)
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.RemoveHidden(segment, true)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				FiendFolio.RemoveHidden(segment, true)
			end
		end
	end

	local data = mod:GetEntityData(entity)
	data.ff_hiddenTimer = nil
	mod:UntrackEnemyStatus(entity, statusflag)

    local ec = EntityConfig.GetEntity(entity.Type, entity.Variant, entity.SubType)
    entity:SetShadowSize(ec:GetShadowSize())
end

function mod:copyHidden(copy, copyData, source, sourceData)
	copyData.ff_hiddenTimer = sourceData.ff_hiddenTimer
	copyData.FFHiddenSource = sourceData.FFHiddenSource
	
	mod:TrackEnemyStatus(copy, statusflag)
end