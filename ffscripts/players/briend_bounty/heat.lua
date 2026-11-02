local mod = FiendFolio
local game = Game()
local sfx = SFXManager()



-- Meter states
local meterStates = {
	Idle 	  = 0,
	Advance   = 1,
	Disappear = 2,
}
local meterState = meterStates.Idle



-- Meter sprite
local appearLayers = { "AppearBack", "AppearFront" }

local sprite = Sprite("gfx/ui/briend_heat.anm2", true)
sprite:Play("Idle", true)
sprite:Stop(false)
sprite.PlaybackSpeed = 0.5



-- Render and update the heat meter
function mod:RenderBountyHeat()
	local shouldUpdate = not game:IsPaused() and Game():GetFrameCount() > 0
	and (not StageAPI or StageAPI.TransitionAnimationData.State == 0)


	if shouldUpdate then
		local currentFrame = sprite:GetFrame()

		-- Decide the next state
		if meterState == meterStates.Idle then
			-- Advance the meter
			if currentFrame < mod.savedata.run.briendHeat then
				meterState = meterStates.Advance

				local anim = currentFrame >= 5 and "AppearExtra" or "Appear"
				sprite:PlayOverlay(anim, true)

				-- Set the appearing star's position
				local nextLayer = sprite:GetLayer( tostring(currentFrame + 1) )
				local layerData = sprite:GetAnimationData("Idle"):GetLayer( nextLayer:GetLayerID() )
				local offset = layerData:GetFrame(currentFrame + 1):GetPos()

				for i, layerName in pairs(appearLayers) do
					sprite:GetLayer(layerName):SetPos(offset)
				end

				-- Probably unnecessary sound
				local pitch = 0.8 + (currentFrame + 1) / 20
				sfx:Play(SoundEffect.SOUND_GOLD_HEART_DROP, 0.3, 0, false, pitch)

			-- Start fading out
			else
				meterState = meterStates.Disappear
				sprite:PlayOverlay("Disappear", true)
			end
		end


		-- Advancing
		if meterState == meterStates.Advance then
			if sprite:IsOverlayFinished() then
				meterState = meterStates.Idle
				sprite:SetFrame(currentFrame + 1)
				sprite:RemoveOverlay()
			end


		-- Fading out
		elseif meterState == meterStates.Disappear then
			local transform = sprite:GetOverlayNullFrame("Transform")
			sprite.Color = transform:GetColor()

			-- Remove the callback
			if sprite:IsOverlayFinished() then
				mod:DisableManualCallback(ModCallbacks.MC_POST_HUD_RENDER, mod.RenderBountyHeat)
			end
		end
	end


	-- Get the position
	local xPos = Isaac.GetScreenWidth() / 2
	local yPos = 18
	local hudOffset = Options.HUDOffset * Vector(0, 12)

	-- Timer / score offset
	if Options.ExtraHUDStyle == ExtraHudStyle.ON or Minimap.GetState() ~= MinimapState.NORMAL then
		local add = game:IsGreedMode() and 15 or 30
		yPos = yPos + add + hudOffset.Y -- They offset the timer more than they should lol
	end


	-- Render it
	local pos = Vector(xPos, yPos) + hudOffset
	sprite:Render(pos)

	if shouldUpdate then
		sprite:Update()
	end
end
mod:AddManualCallback(ModCallbacks.MC_POST_HUD_RENDER, mod.RenderBountyHeat)

-- Remove the heat render callback when starting a new run
function mod:RemoveBountyHeatCallback()
	if not PlayerManager.AnyoneIsPlayerType(mod.PLAYER.BRIEND) then
		mod:DisableManualCallback(ModCallbacks.MC_POST_HUD_RENDER, mod.RenderBountyHeat)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.RemoveBountyHeatCallback)





-- Set the heat amount and show the meter
---@param amount integer
function mod:SetBountyHeat(amount)
	local runData = mod.savedata.run
	local previous = runData.briendHeat or 0
	runData.briendHeat = mod:ClampNumber(amount, 0, 6)

	-- Set up the meter and show it
	local startingFrame = math.min(previous, runData.briendHeat)
	sprite:SetFrame(startingFrame)

	meterState = meterStates.Idle
	sprite.Color = Color.Default
	mod:EnableManualCallback(ModCallbacks.MC_POST_HUD_RENDER, mod.RenderBountyHeat)
end



-- Update the heat amount when entering a new floor
function mod:GetBountyHeat()
	if PlayerManager.AnyoneIsPlayerType(mod.PLAYER.BRIEND) then
		local isGreed = game:IsGreedMode()
		local level = game:GetLevel()
		local stageNumber = level:GetStage()
		local stageType = level:GetStageType()

		-- Ascent
		if level:IsAscent() then
			stageNumber = LevelStage.STAGE3_2 + (LevelStage.STAGE3_2 - stageNumber - 1)

		-- Custom stages
		elseif StageAPI and StageAPI.CurrentStage then
			stageNumber = StageAPI.CurrentStage.StageHPNumber

			local levelGenStage = StageAPI.CurrentStage.LevelgenStage
			stageType = levelGenStage and levelGenStage.StageType or stageType
		end

		-- Account for Blue Womb and the Shop
		if (not isGreed and stageNumber > LevelStage.STAGE4_3)
		or (isGreed and stageNumber > LevelStage.STAGE5_GREED) then
			stageNumber = stageNumber - 1
		end

		-- XL floors
		if level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH > 0 then
			stageNumber = stageNumber + 1
		end

		-- Alt path
		if stageType >= StageType.STAGETYPE_REPENTANCE
		and not game:GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH_INIT) then
			stageNumber = stageNumber + 1
		end

		-- Set the final amount
		local amount = isGreed and stageNumber or math.ceil(stageNumber / 2)
		mod:SetBountyHeat(amount)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.GetBountyHeat)

-- Fix for CO-OP :)
function mod:GetBountyHeatLate(player)
	local func = function()
		if player:GetPlayerType() == mod.PLAYER.BRIEND and not mod.savedata.run.briendHeat then
			mod:GetBountyHeat()
		end
	end
	mod.scheduleForUpdate(func, 0, ModCallbacks.MC_POST_UPDATE, true)
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.GetBountyHeatLate, PlayerVariant.PLAYER)



-- Console command
local commandName = "setheat"
local description = "Sets the heat level to the given amount."
local helpText = "Run without any parameters to reset it to its normal amount."

local function commandFunc(_, cmd, rawParams)
	if cmd == commandName then
		local value = tonumber(rawParams)

		if value then
			value = mod:GoRoundNumber(value)
			mod:SetBountyHeat(value)
		else
			mod:GetBountyHeat()
		end
	end
end
mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, commandFunc)

Console.RegisterCommand(commandName,
	description,
	description .. " " .. helpText,
	false,
	AutocompleteType.NONE
)