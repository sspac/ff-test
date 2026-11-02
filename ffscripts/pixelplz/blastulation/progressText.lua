local mod = FiendFolio

local font = Font("font/pftempestasevencondensed.fnt")
local textHeight = font:GetLineHeight()
local duration = 75



-- Rise up and fade out
function mod:BlastulationProgressTextUpdate(effect)
	effect.Velocity = Vector(0, -0.6)

	if effect.FrameCount >= duration then
		effect:Remove()
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.BlastulationProgressTextUpdate, mod.FF.Blastulation.ProgressText)



-- Render the actual text
function mod:BlastulationProgressTextRender(effect, offset)
	local effectPos = Isaac.WorldToRenderPosition(effect.Position) + offset
	local textPos = Vector(effectPos.X, effectPos.Y - textHeight)

	-- Set the numbers
	local discovered = math.floor(effect.TargetPosition.X)
	local total = math.floor(effect.TargetPosition.Y)
	local text = discovered .. " / " .. total

	-- Set the color
	local alpha = 1 - (effect.FrameCount / duration)
	local textColor = KColor(1,1,1, alpha)

	font:DrawStringScaled(text, textPos.X, textPos.Y, 1, 1, textColor, 1, true)
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, mod.BlastulationProgressTextRender, mod.FF.Blastulation.ProgressText)