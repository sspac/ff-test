local mod = FiendFolio
local game = Game()

function mod:VanillaExtractFloorChange()
	if StageAPI.InNewStage() then
		return
	end
	
	if mod.anyPlayerHas(mod.ITEM.TRINKET.VANILLA_EXTRACT, true) then
		local level = game:GetLevel()
		local absolutestage = level:GetAbsoluteStage()
		if game:IsGreedMode() then
			absolutestage = level:GetStage()
		end
		local changedStage
		if absolutestage <= LevelStage.STAGE4_2 then
			if level:GetStageType() == StageType.STAGETYPE_WOTL or level:GetStageType() == StageType.STAGETYPE_AFTERBIRTH then
				Isaac.ExecuteCommand("stage " .. absolutestage)
				changedStage = true
			elseif level:GetStageType() == LevelStage.STAGE3_1 then
				Isaac.ExecuteCommand("stage " .. absolutestage .. "c")
				changedStage = true
			end
		end
		--[[if changedStage then
			mod.AnyPlayerDo(function(player)
				if player:HasTrinket(mod.ITEM.TRINKET.LONGTIME_FIEND) then
					local sdata = mod:GetEntityData(player).ffsavedata
					sdata.LongtimeFiendFloorsPassed = sdata.LongtimeFiendFloorsPassed - 0.33
				end
			end)
		end]]
	end
end
mod:AddPriorityTrinketCallback(ModCallbacks.MC_POST_NEW_LEVEL, CallbackPriority.LATE+100, mod.ITEM.TRINKET.VANILLA_EXTRACT, mod.VanillaExtractFloorChange)
