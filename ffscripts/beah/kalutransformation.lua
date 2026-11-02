-- Time Fcuk'd Transformation --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

function mod:handleKaluTransformation(player, amount)
    local eff = player:GetEffects()
    if amount == 1 then
        player:AddNullItemEffect(mod.ITEM.NULL.NORAD_KALU_TRANSFORMATION_TRACKER, true)
    elseif amount == -1 then
        eff:RemoveNullEffect(mod.ITEM.NULL.NORAD_KALU_TRANSFORMATION_TRACKER, 1)
    end

    local isKalu = eff:HasNullEffect(mod.ITEM.NULL.KALU_TRANSFORMATION)
    if eff:GetNullEffectNum(mod.ITEM.NULL.NORAD_KALU_TRANSFORMATION_TRACKER) >= 3 or game.Challenge == FiendFolio.challenges.theEndIsNeverTheEnd then
        if not isKalu then
            player:AddNullItemEffect(mod.ITEM.NULL.KALU_TRANSFORMATION, true)
			local sdata = mod:GetEntityData(player).ffsavedata
			if not sdata.GaveKaluTransformationHearts then player:AddRottenHearts(2) end
			sdata.GaveKaluTransformationHearts = true

			Game():GetHUD():ShowItemText("#MyDogKalu!")
			sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER)
			sfx:Play(mod.Sounds.VAWoohooMyDogKalu)

			--[[if not FiendFolio.ACHIEVEMENT.MY_DOG_KALU:IsUnlocked(true) then
				FiendFolio.ACHIEVEMENT.GET_IN_THE_BOX:Unlock()
			end]]
        end
    else --Based on how mom transformation works
        if isKalu then
            eff:RemoveNullEffect(mod.ITEM.NULL.KALU_TRANSFORMATION, eff:GetNullEffectNum(mod.ITEM.NULL.KALU_TRANSFORMATION))
        end
    end
end

function mod:KaluTransformationCheckItemAdded(collectibleType, charge, firstTime, slot, varData, player)
    if firstTime then
        mod:handleKaluTransformation(player, 1)
    end
end
function mod:KaluTransformationCheckItemRemoved(player, collectibleType, removeForm)
    --Procs before POST_ADD_COLLECTIBLE, so scheduling or else you can pick up actives and get a double up
    mod.scheduleForUpdate(function()
        if removeForm then
            mod:handleKaluTransformation(player, -1)
        end
    end, 0, ModCallbacks.MC_POST_RENDER, true)
end
function mod:KaluTransformationCheckTrinketAdded(player)
    mod:handleKaluTransformation(player, 1)
end
function mod:KaluTransformationCheckTrinketRemoved(player, collectibleType, removeForm)
    --Procs before POST_ADD_COLLECTIBLE, so scheduling or else you can pick up actives and get a double up
    mod.scheduleForUpdate(function()
        mod:handleKaluTransformation(player, -1)
    end, 0, ModCallbacks.MC_POST_RENDER, true)
end

mod:AddPriorityCallback(ModCallbacks.MC_POST_MODS_LOADED, math.huge, function()
	for i = 1, #FiendFolio.KaluItems do
		mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.KaluTransformationCheckItemAdded, FiendFolio.KaluItems[i])
		mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.KaluTransformationCheckItemRemoved, FiendFolio.KaluItems[i])
	end
	for i = 1, #FiendFolio.KaluTrinkets do
		mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, mod.KaluTransformationCheckTrinketAdded, FiendFolio.KaluTrinkets[i])
		mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, mod.KaluTransformationCheckTrinketRemoved, FiendFolio.KaluTrinkets[i])
	end
end)
if ModReloadDetector.ModsLoaded then
	for i = 1, #FiendFolio.KaluItems do
		mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, mod.KaluTransformationCheckItemAdded, FiendFolio.KaluItems[i])
		mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.KaluTransformationCheckItemRemoved, FiendFolio.KaluItems[i])
	end
	for i = 1, #FiendFolio.KaluTrinkets do
		mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, mod.KaluTransformationCheckTrinketAdded, FiendFolio.KaluTrinkets[i])
		mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, mod.KaluTransformationCheckTrinketRemoved, FiendFolio.KaluTrinkets[i])
	end
end

local function peffectUpdate(_, player)
    local effects = player:GetEffects()
    local d = mod:GetEntityData(player)
    if effects:HasNullEffect(mod.ITEM.NULL.KALU_TRANSFORMATION) then
		local aim = mod.GetCorrectedFiringInput(player, true)
        mod:weakerKaluBlast(player, d, aim)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, peffectUpdate)

local kaluhumVolume = 1
function mod:weakerKaluBlast(player, d, aim)
    if aim:Length() > 0.5 and d.holdingFFItemSlot == nil then
        if not d.kaluTransformationBlast or not d.kaluTransformationBlast:Exists() then
            d.kaluTransformationBlast = true
            local visage = Isaac.Spawn(mod.FF.KalusVisage.ID, mod.FF.KalusVisage.Var, mod.FF.KalusVisage.Sub, player.Position, nilvector, player):ToEffect()
            visage:FollowParent(player)
            visage:Update()
            d.kaluTransformationBlast = visage
            --sfx:Play(mod.Sounds.BlackMoonIntro,kaluhumVolume,0,false,1)
        end
        if not (sfx:IsPlaying(mod.Sounds.AmonWindLoop) or sfx:IsPlaying(mod.Sounds.BlackMoonIntro)) then
            sfx:Play(mod.Sounds.AmonWindLoop,kaluhumVolume,0,true,1)
        end
        for _, enemy in pairs(Isaac.FindInRadius(player.Position + aim:Resized(40), 100, EntityPartition.ENEMY)) do
            if enemy.EntityCollisionClass >= 2 then
                local enemyVec = (enemy.Position - player.Position):Normalized()
                local dotProd = aim:Normalized():Dot(enemyVec)
                --print(dotProd)
                if dotProd >= 0.9 and enemy.Position:Distance(player.Position + aim:Resized(40)) < (125 + enemy.Size) then
                    if not enemy:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) then
                        if enemy:ToNPC() then
                            if enemy:ToNPC():IsBoss() and not enemy:HasEntityFlags(EntityFlag.FLAG_FREEZE) then
                                enemy:AddFreeze(EntityRef(player), 360)
                            elseif not enemy:ToNPC():IsBoss() then
                                local slowness = 1 + game:GetFrameCount() % 2
                                local slownessVal = 1
                                slowness = slowness * slownessVal
                                enemy:AddFreeze(EntityRef(player), slowness)
                            end
                            mod:GetEntityData(enemy).KaluHeadFrozen = player
                        end
                    end
                end
            end
        end
    else
        if d.kaluTransformationBlast then
            sfx:Stop(mod.Sounds.BlackMoonIntro)
            sfx:Stop(mod.Sounds.AmonWindLoop)
            --sfx:Play(mod.Sounds.BlackMoonEnd,kaluhumVolume,0,false,1)
            d.kaluTransformationBlast = false
        end
    end
end