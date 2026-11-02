local mod = FiendFolio
local game = Game()

local COIN_OBSCURA_SPRITE = Sprite()
COIN_OBSCURA_SPRITE:Load("gfx/ui/ui_coin_obscura.anm2", true)

local NULL_KCOLOR = KColor(1, 1, 1, 1)
local PLAT_CREDIT_KCOLOR = KColor(0.278, 0.278, 0.631, 1.0)
local DADS_DEBT_KCOLOR = KColor(0.631, 0.278, 0.278, 1.0)

function mod:GetNumDigits(i)
	return math.max(1, math.floor(math.log(math.abs(i), 10)) + 1)
end

-- Pads a number of coins with an appropriate number of zeroes.
local function GetCoinStr(coins, maxCoins)
	local digits = mod:GetNumDigits(coins)
	local maxDigits = mod:GetNumDigits(maxCoins)
	local coinStr = tostring(coins)
	for i=digits+1, maxDigits do
		coinStr = "0" .. coinStr
	end
	return coinStr
end

function mod:RenderCoinHudStuff()
	-- Only need to refer to player 1 for coins hud things.
	local player = Isaac.GetPlayer()

	if player:HasCurseMistEffect() or game:GetSeeds():HasSeedEffect(SeedEffect.SEED_NO_HUD) or not game:GetHUD():IsVisible() then return end

	local maxCoins = player:GetMaxCoins()
	-- Note: ScreenShakeOffset only needs to be added when rendering text, not for sprites.
	local coinOffset = Vector(16, 33) + Vector(Options.HUDOffset * 20, Options.HUDOffset * 12) + game.ScreenShakeOffset
	if REPENTANCE_PLUS then
		coinOffset = coinOffset + Vector(0, 2)
	end

	if player:GetPlayerType() == PlayerType.PLAYER_JACOB then
		coinOffset = coinOffset + Vector(0, 14)
	end

	local platinumCreditData = mod:GetPlatinumCreditData()
	local platinumCredit = platinumCreditData.Credit + platinumCreditData.PhantomCredit
	local dadsDebt = mod.getField(FiendFolio.savedata, 'run', 'dadsdebt') or 0

	local actualCoins = player:GetNumCoins()
	local actualCoinsStr = GetCoinStr(actualCoins, maxCoins)

	if platinumCreditData.PhantomCredit > 0 then
		-- Render black on top of the actual coin count to keep the white from peeking out.
		local maxDigits = mod:GetNumDigits(maxCoins)
		local padding = 0
		for i=1, maxDigits do
			local isOne = math.floor(actualCoins / 10 ^ (maxDigits-i)) % 10 == 1
			COIN_OBSCURA_SPRITE:SetFrame(isOne and "1" or "X", 0)
			COIN_OBSCURA_SPRITE:Render(coinOffset + Vector(padding, 0))
			padding = padding + (isOne and 4 or 6)
		end

		-- Render the player's "Real Coins", ie without any "Phantom" Platinum Credit.
		local coinsToRender = platinumCreditData.RealCoins
		local coinStr = GetCoinStr(coinsToRender, maxCoins)
		mod.TempestFont:DrawStringScaled(coinStr, coinOffset.X, coinOffset.Y, 1, 1, NULL_KCOLOR, 0, false)
		coinOffset = coinOffset + Vector(mod.TempestFont:GetStringWidth(coinStr), 0)
	else
		-- Just get the width of the player's current coin count - don't render over it.
		coinOffset = coinOffset + Vector(mod.TempestFont:GetStringWidth(actualCoinsStr), 0)
	end

	-- Render fractional coins, if any (and if there is no debt).
	local tenthCoins = math.min(math.floor(mod:GetFractionalCoins()*10), 9)
	if tenthCoins > 0 and dadsDebt == 0 then
		local str = "." .. tenthCoins
		mod.TempestFont:DrawStringScaled(str, coinOffset.X, coinOffset.Y, 1, 1, NULL_KCOLOR, 0, false)
		coinOffset = coinOffset + Vector(mod.TempestFont:GetStringWidth(str), 0)
	end

	if platinumCredit > 0 then
		-- Render +Platinum Credit
		mod.TempestFont:DrawStringScaled("+" .. platinumCredit, coinOffset.X, coinOffset.Y, 1, 1, PLAT_CREDIT_KCOLOR, 0, false)
	elseif dadsDebt > 0 then
		-- Render -Dad's Debt
		local dadsDebtStr = "-"
		if tenthCoins > 0 then
			-- Pretend that the tenth-coins were taken out of the debt.
			dadsDebtStr = dadsDebtStr .. (dadsDebt - 1) .. "." .. (10-tenthCoins)
		else
			dadsDebtStr = dadsDebtStr .. dadsDebt
		end
		mod.TempestFont:DrawStringScaled(dadsDebtStr, coinOffset.X, coinOffset.Y, 1, 1, DADS_DEBT_KCOLOR, 0, false)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_HUD_RENDER, mod.RenderCoinHudStuff)
