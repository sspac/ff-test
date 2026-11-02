local mod = FiendFolio
local game = Game()
local NULL_KCOLOR = KColor(1, 1, 1, 1)

-- THIS DOES NOT IMPLEMENT FRACTIONAL BOMB PICKUPS, ONLY THE STAT
-- If we ever want fractional bomb pickups I can do that too ig

local function gameHasIsntTaintedBlueBaby()
	for _, player in pairs(PlayerManager.GetPlayers()) do
		if player:GetPlayerType() ~= PlayerType.PLAYER_BLUEBABY_B then
			return true
		end
	end

	return false
end

function mod.GetFractionalKeys()
	return mod.savedata.run.FractionalKeys or 0
end

-- 0.1 == 1 Fractional Bomb, 1 = 10 Fractional Bombs = 1 Bomb
-- e.g Add(2.3) == 2 Bombs + 3 Fractionals
function mod.AddFractionalKeys(amount)
	local newFractionals = (mod.savedata.run.FractionalKeys or 0) + amount
	Isaac.GetPlayer():AddKeys(newFractionals // 1)
	mod.savedata.run.FractionalKeys = newFractionals % 1
end

local function getKeysString(player)
	local targetLen = string.len(player:GetMaxKeys())
	local keys = tostring(player:GetNumKeys())

	while string.len(keys) < targetLen do keys = "0" .. keys end
	return keys
end

mod:AddCallback(ModCallbacks.MC_POST_HUD_RENDER, function()
	local player = Isaac.GetPlayer()
	if player:HasCurseMistEffect() or not game:GetHUD():IsVisible() then return end

	-- offset code could possible be cleaned up
	local offset = Vector(16, 57) + Vector(Options.HUDOffset * 20, Options.HUDOffset * 12) + game.ScreenShakeOffset
	offset = offset + Vector(mod.TempestFont:GetStringWidth(getKeysString(player)), 0)
	if REPENTANCE_PLUS then
		offset = offset + Vector(0, 2)
	end

	if player:GetPlayerType() == PlayerType.PLAYER_JACOB then
		offset = offset + Vector(0, 14)
	end

	if PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_BLUEBABY_B) and gameHasIsntTaintedBlueBaby() then
		offset = offset + Vector(0, 9)
	end

	local fractionals = math.floor(mod.GetFractionalKeys() * 10 + 0.5)
	if fractionals > 0 then
		mod.TempestFont:DrawStringScaled("." .. fractionals, offset.X, offset.Y, 1, 1, NULL_KCOLOR, 0, false)
	end
end)