local mod = FiendFolio
local gfx = "gfx/ui/ui_challengedestinations.png"

mod.DestinationIcon = {
	DAD = 0,
	GIDEON = 1,
	RANDOM = 2,
	GAUNTLET = 3,
	PROPAGANDA = 4,
}

local iconSprite = Sprite()
iconSprite:Load("gfx/ui/ff_challengedestinations.anm2")
iconSprite:Play("Idle")

function mod.UpdateChallengeDestinationIcon()
	local icon = mod.savedata and mod.savedata.run and mod.savedata.run.destinationIcon
	if not icon then return end

	Game():GetHUD():GetPickupsHUDSprite():ReplaceSpritesheet(1, "gfx/nothing.png", true)
	iconSprite:SetFrame("Idle", mod.savedata.run.destinationIcon)
end

function mod.SetChallengeDestinationIcon(iconId)
	if not mod.savedata and not mod.savedata.run then return end
	mod.savedata.run.destinationIcon = iconId
	mod.UpdateChallengeDestinationIcon()
end

mod:AddCallback(ModCallbacks.MC_POST_HUD_RENDER, function()
	if mod.savedata and mod.savedata.run and mod.savedata.run.destinationIcon then
		local hudPos = Vector(Options.HUDOffset * 20, Options.HUDOffset * 12) + Vector(0, 6)
        local iconOffset = Vector(25, 77)
        iconSprite:Render(hudPos + iconOffset)
	end
end)