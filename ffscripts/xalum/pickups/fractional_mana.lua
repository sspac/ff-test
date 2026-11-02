local mod = FiendFolio
local game = Game()
local NULL_KCOLOR = KColor(1, 1, 1, 1)

-- THIS DOES NOT IMPLEMENT FRACTIONAL MANA PICKUPS, ONLY THE STAT
-- If we ever want fractional mana pickups I can do that too ig

function mod.GetFractionalMana()
	return mod.savedata.run.FractionalMana or 0
end

-- 0.1 == 1 Fractional Mana, 1 = 10 Fractional Mana = 1 Mana
-- e.g Add(2.3) == 2 Mana + 3 Fractionals
function mod.AddFractionalMana(amount)
	local newFractionals = (mod.savedata.run.FractionalMana or 0) + amount
	Isaac.GetPlayer():AddPoopMana(newFractionals // 1)
	mod.savedata.run.FractionalMana = newFractionals % 1
end

local function getManaString()
	if PlayerManager.AnyPlayerTypeHasBirthright(PlayerType.PLAYER_BLUEBABY_B) then
		local mana = Isaac.GetPlayer():GetPoopMana()
		if mana < 10 then
			return "0" .. mana
		else
			return tostring(mana)
		end
	else
		return tostring(Isaac.GetPlayer():GetPoopMana())
	end
end

mod:AddCallback(ModCallbacks.MC_POST_HUD_RENDER, function()
	if Isaac.GetPlayer():HasCurseMistEffect() or not game:GetHUD():IsVisible() then return end
	if not PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_BLUEBABY_B) then return end

	-- offset code could possible be cleaned up
	local offset = Vector(16, 45) + Vector(Options.HUDOffset * 20, Options.HUDOffset * 12) + game.ScreenShakeOffset
	offset = offset + Vector(mod.TempestFont:GetStringWidth(getManaString()), 0)
	if REPENTANCE_PLUS then
		offset = offset + Vector(0, 2)
	end

	if Isaac.GetPlayer():GetPlayerType() == PlayerType.PLAYER_JACOB then
		offset = offset + Vector(0, 14)
	end

	local fractionals = math.floor(mod.GetFractionalMana() * 10 + 0.5)
	if fractionals > 0 then
		mod.TempestFont:DrawStringScaled("." .. fractionals, offset.X, offset.Y, 1, 1, NULL_KCOLOR, 0, false)
	end
end)