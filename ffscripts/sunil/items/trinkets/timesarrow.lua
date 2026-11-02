local mod = FiendFolio
local game = Game()

function mod:TimesArrowFloorChange()
	local level = game:GetLevel()
	local stagetype = level:GetStageType()
	local absolutestage = level:GetAbsoluteStage()
	local nextstage = absolutestage + 1
	local nextascentstage = absolutestage - 1

	if StageAPI.InNewStage() then return end

	if mod.anyPlayerHas(mod.ITEM.TRINKET.TIMES_ARROW, true) then
		if game:IsGreedMode() == true then level.GreedModeWave = 5 else
		if level:IsAscent() == false then
			if absolutestage == 1 or absolutestage == 3 or absolutestage == 5 or absolutestage == 7 then
				if stagetype == 0 then
					Isaac.ExecuteCommand("stage " .. nextstage)
				elseif stagetype == 1 then
					local actualnextstage = nextstage .. "a"
					Isaac.ExecuteCommand("stage " .. actualnextstage)
				elseif stagetype == 2 then
					local actualnextstage = nextstage .. "b"
					Isaac.ExecuteCommand("stage " .. actualnextstage)
				elseif stagetype == 4 then
					local actualnextstage = nextstage .. "c"
					Isaac.ExecuteCommand("stage " .. actualnextstage)
				elseif stagetype == 5 then
					local actualnextstage = nextstage .. "d"
					Isaac.ExecuteCommand("stage " .. actualnextstage)
				end
			end
		elseif level:IsAscent() == true then
				if absolutestage == 2 or absolutestage == 4 or absolutestage == 6 then
					if stagetype == 0 then
						Isaac.ExecuteCommand("stage " .. nextascentstage)
					elseif stagetype == 1 then
						local actualnextstage = nextascentstage .. "a"
						Isaac.ExecuteCommand("stage " .. actualnextstage)
					elseif stagetype == 2 then
						local actualnextstage = nextascentstage .. "b"
						Isaac.ExecuteCommand("stage " .. actualnextstage)
					elseif stagetype == 4 then
						if absolutestage == 2 or absolutestage == 4 then
							local actualnextstage = nextascentstage .. "c"
							Isaac.ExecuteCommand("stage " .. actualnextstage)
						else
						end
					elseif stagetype == 5 then
						if absolutestage == 2 or absolutestage == 4 then
							local actualnextstage = nextascentstage .. "d"
							Isaac.ExecuteCommand("stage " .. actualnextstage)
						else
						end
					end
				end
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.TimesArrowFloorChange)
