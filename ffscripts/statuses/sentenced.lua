local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local statusflag = mod:RegisterEnemyStatusEffect("SENTENCED", 60, "SentencedOnUpdate", {HasIcon = true})
local statusColorPriority = 999
local reddedColorPriority = 0

function mod:HandleSentenced(entity, data)
	entity:SetColor(FiendFolio.StatusEffectColors.Sentenced, 1, statusColorPriority, false, false)
	
	if data.FFSentencedDuration > 0 then
        data.FFSentencedDuration = data.FFSentencedDuration - 1
        if not data.FFStatusSpecialRender then
            data.FFStatusSpecialRender = Sprite()
            data.FFStatusSpecialRender:Load("gfx/effects/effect_executioner_status.anm2", true)
            data.FFStatusSpecialRender:Play("Appear", true)
            data.SentencedAnimState = "Appear"
        else
            local sprite = data.FFStatusSpecialRender
			sprite:Update()
            if data.SentencedAnimState == "Appear" then
                if sprite:GetFrame() >= 7 then
                    data.SentencedAnimState = "Idle"
                    sprite:Play("Idle", true)
                else
                    mod:spritePlay(sprite, "Appear")
                end
            end
        end
    else
        local sprite = data.FFStatusSpecialRender
		sprite:Update()
        if sprite:GetFrame() >= 22 and not data.ExecutedReally then
            data.ExecutedReally = true
            local rng = entity:GetDropRNG()

            if data.FFSentencedDamage < 0 then
                sprite.Color = Color(1, 1, 1, 0)

                for i=1,4 do
                    local randVel = RandomVector()*mod:getRoll(10,30,rng)/20
                    local cloud = Isaac.Spawn(1000, 59, 0, entity.Position, Vector.Zero, entity):ToEffect()
                    cloud:SetTimeout(mod:getRoll(100,150,rng))
                    local color = Color(0.45,0,0,0,0,0,0)
                    cloud.Color = color
                    local randScale = mod:getRoll(80,150,rng)/100
                    cloud.SpriteScale = Vector(0.5, 0.5)
                    mod:GetEntityData(cloud).cosmeticDust = {scale = randScale, vel = randVel, alpha = 0.5}
                end

                local bigSplat = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT, 0, entity.Position, Vector.Zero, entity):ToEffect()
                bigSplat.SpriteScale = Vector(2, 2)
                bigSplat:Update()

                local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 4, entity.Position, Vector.Zero, entity):ToEffect()
                poof.SpriteScale = Vector(0.9, 0.9)
                poof:Update()

                sfx:Play(SoundEffect.SOUND_MOTHER_WRIST_EXPLODE, 0.6, 0, false, mod:getRoll(110,120,rng)/100)
                sfx:Play(SoundEffect.SOUND_MOTHER_ISAAC_HIT, 1.2, 0, false, mod:getRoll(95, 105, rng)/100)

                entity:Kill()
            else
				if not data.FFSentencedSource then
					data.FFSentencedSource = EntityRef(Isaac.GetPlayer(0))
				end

				sfx:Play(SoundEffect.SOUND_MOTHER_WRIST_EXPLODE, 0.6, 0, false, mod:getRoll(110,120,rng)/100)
                sfx:Play(SoundEffect.SOUND_MOTHER_ISAAC_HIT, 1.2, 0, false, mod:getRoll(95, 105, rng)/100)

                if data.FFSentencedDamage > entity.HitPoints then
                    mod.scheduleForUpdate(function()
                        if not entity:Exists() or entity:IsDead() or entity:HasMortalDamage() then
                            for i=1,4 do
                                local randVel = RandomVector()*mod:getRoll(10,30,rng)/20
                                local cloud = Isaac.Spawn(1000, 59, 0, entity.Position, Vector.Zero, entity):ToEffect()
                                cloud:SetTimeout(mod:getRoll(100,150,rng))
                                local color = Color(0.45,0,0,0,0,0,0)
                                cloud.Color = color
                                local randScale = mod:getRoll(80,150,rng)/100
                                cloud.SpriteScale = Vector(0.5, 0.5)
                                mod:GetEntityData(cloud).cosmeticDust = {scale = randScale, vel = randVel, alpha = 0.5}
                            end

                            local bigSplat = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT, 0, entity.Position, Vector.Zero, entity):ToEffect()
                            bigSplat.SpriteScale = Vector(2, 2)
                            bigSplat:Update()

                            local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 4, entity.Position, Vector.Zero, entity):ToEffect()
                            poof.SpriteScale = Vector(0.9, 0.9)
                            poof:Update()
                        end
                    end, 1)
                end

                entity:BloodExplode()
                entity:TakeDamage(data.FFSentencedDamage or entity.MaxHitPoints*0.2, 0, data.FFSentencedSource, 0)

                data.ExecutedReally = nil
                data.FFStatusSpecialRender = nil
                data.SentencedForExecution = nil
                mod.RemoveSentenced(entity)
            end
        elseif sprite:GetFrame() >= 19 and not data.ReddedExecuted then
            data.ReddedExecuted = true
            entity:SetColor(Color(1, 0.5, 0.5, 1, 1, 0, 0, 1, 0, 0, 1), 5, reddedColorPriority, false, false)
        else
            mod:spritePlay(sprite, "Proc")
        end
    end
end

function mod.AddSentenced(entity, source, duration, damage, isCloned)
	if not (entity and entity:ToNPC()) then
		return
	end
	
	if (entity.Type == EntityType.ENTITY_MASK or (entity.Type == EntityType.ENTITY_MASK_OF_INFAMY and entity.Parent)) and not isCloned then
		return
	end
	
	if Isaac.RunCallbackWithParam(ModCallbacks.MC_PRE_STATUS_EFFECT_APPLY, "FFSentenced", "FFSentenced", entity, EntityRef(source), duration) == false then
		return
	end
	
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				mod.AddSentenced(segment, source, duration, damage, true)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				mod.AddSentenced(segment, source, duration, damage, true)
			end
		end
	end

	local data = mod:GetEntityData(entity)
	if not (entity:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) or mod:isStatusBlacklisted(entity)) or 
	       ((entity.Type == EntityType.ENTITY_MASK or entity.Type == EntityType.ENTITY_MASK_OF_INFAMY) and isCloned) 
	then
		data.FFSentencedDuration = math.min(data.FFSentencedDuration or 100, duration)
        data.FFSentencedDamage = damage or -1
		data.FFSentencedSource = EntityRef(source)
		
		mod:TrackEnemyStatus(entity, statusflag)
		
		Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_STATUS_EFFECT_APPLY, "FFSentenced", "FFSentenced", entity, EntityRef(source), duration)
	end
end

function mod.RemoveSentenced(entity, isCloned)
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				mod.RemoveSentenced(segment, true)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				mod.RemoveSentenced(segment, true)
			end
		end
	end

	local data = mod:GetEntityData(entity)
	data.FFSentencedDuration = nil
    data.FFSentencedDamage = nil
	mod:UntrackEnemyStatus(entity, statusflag)
end

function mod:SentencedOnApply(entity, source, data)
	if data.ApplySentenced then
		mod.AddSentenced(entity, source.Entity.SpawnerEntity, data.ApplySentencedDuration, data.ApplySentencedDamage)
	end
end

function mod:SentencedOnUpdate(npc, data, sprite, clearingStatus)
	if data.FFSentencedDuration ~= nil and not clearingStatus then
		mod:HandleSentenced(npc, data)
	else
		data.FFSentencedDuration = nil
		mod:UntrackEnemyStatus(npc, statusflag)

        if not (npc:IsDead() or npc:HasMortalDamage()) then
			local ptrhash = GetPtrHash(npc)
			mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
			mod.VasculitisInfo[ptrhash][statusflag] = nil
		end
	end
end

function mod:copySentenced(copy, copyData, source, sourceData)
	copyData.FFMSentencedDuration = sourceData.FFMSentencedDuration
    copyData.FFMSentencedDamage = sourceData.FFMSentencedDamage
	copyData.FFSentencedSource = sourceData.FFSentencedSource
	
	mod:TrackEnemyStatus(copy, statusflag)
    local copyPtrhash = GetPtrHash(copy)
	local sourcePtrhash = GetPtrHash(source)
	mod.VasculitisInfo[copyPtrhash] = mod.VasculitisInfo[copyPtrhash] or {}
	mod.VasculitisInfo[sourcePtrhash] = mod.VasculitisInfo[sourcePtrhash] or {}
	if mod.VasculitisInfo[sourcePtrhash][statusflag] then
		mod.VasculitisInfo[copyPtrhash][statusflag] = {Source = mod.VasculitisInfo[sourcePtrhash][statusflag].Source or copyData.FFSentencedSource}
	end
end

local tearflag = TearFlagsLib.RegisterTearFlag("SENTENCED")
function FiendFolio.FlagSentenced(entity, duration, damage)
	TearFlagsLib.AddTearFlags(entity, tearflag)

	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, duration),
	                                                  Damage = math.max(params.Damage or 0, damage),})
end

function mod:applySentencedFlag(entity, player, source)
	local data = mod:GetEntityData(source)
	local params = TearFlagsLib.GetTearFlagParams(source, tearflag)
	FiendFolio.AddSentenced(entity, player, params.Duration, params.Damage)
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.applySentencedFlag, tearflag)

function mod.handleSentencedD3(entity)
	local player = TearFlagsLib.GetTearPlayer(entity)
	local params = TearFlagsLib.GetTearFlagParams(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = math.max(params.Duration or 0, 300),
	                                                  Damage = math.max(params.Damage or 0, 40)})
end

function mod:SentencedOnVasculitis(tear, npc)
	local ptrhash = GetPtrHash(npc)
	mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
	
	local vasculitisInfo = mod.VasculitisInfo[ptrhash][statusflag]
	if vasculitisInfo then
		local source = vasculitisInfo.Source
		--local player = source and source.Entity and source.Entity:ToPlayer()
		--local secondHandMultiplier = (player and (player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1)) or 1
		FiendFolio.FlagSentenced(tear, 300, 40)
	end
end