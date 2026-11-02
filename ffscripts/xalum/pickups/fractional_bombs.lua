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

function mod.GetFractionalBombs()
	return mod.savedata.run.FractionalBombs or 0
end

-- 0.1 == 1 Fractional Bomb, 1 = 10 Fractional Bombs = 1 Bomb
-- e.g Add(2.3) == 2 Bombs + 3 Fractionals
function mod.AddFractionalBombs(amount)
	local newFractionals = (mod.savedata.run.FractionalBombs or 0) + amount
	Isaac.GetPlayer():AddBombs(newFractionals // 1)
	mod.savedata.run.FractionalBombs = newFractionals % 1
end

local function getBombsString(player)
	local targetLen = string.len(player:GetMaxBombs())
	local bombs = tostring(player:GetNumBombs())

	while string.len(bombs) < targetLen do bombs = "0" .. bombs end
	return bombs
end

mod:AddCallback(ModCallbacks.MC_POST_HUD_RENDER, function()
	local player = Isaac.GetPlayer()
	if player:HasCurseMistEffect() or not game:GetHUD():IsVisible() then return end
	if not gameHasIsntTaintedBlueBaby() then return end

	-- offset code could possible be cleaned up
	local offset = Vector(16, 45) + Vector(Options.HUDOffset * 20, Options.HUDOffset * 12) + game.ScreenShakeOffset
	offset = offset + Vector(mod.TempestFont:GetStringWidth(getBombsString(player)), 0)
	if REPENTANCE_PLUS then
		offset = offset + Vector(0, 2)
	end

	if player:GetPlayerType() == PlayerType.PLAYER_JACOB then
		offset = offset + Vector(0, 14)
	end

	if PlayerManager.AnyoneIsPlayerType(PlayerType.PLAYER_BLUEBABY_B) then
		offset = offset + Vector(0, -1) -- This game is made of tape and prayers
	end

	local fractionals = math.floor(mod.GetFractionalBombs() * 10 + 0.5)
	if fractionals > 0 then
		mod.TempestFont:DrawStringScaled("." .. fractionals, offset.X, offset.Y, 1, 1, NULL_KCOLOR, 0, false)
	end
end)