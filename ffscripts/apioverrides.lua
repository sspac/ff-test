-- Do not use file-scope local variables here, it can potentially create luamod memory leaks.
-- For similar reasons, this function is at the top to minimize what it has in scope.
local function CreateIndexOverride(className, oldIndex)
	-- Override for __index that checks for FiendFolio overrides.
	return function(self, k)
		local overrides = FiendFolio.ApiOverrides[className]
		return overrides and overrides[k] or oldIndex(self, k)
	end
end

-- Holds the original versions of the functions that got overridden.
-- Example: `FiendFolio.OverriddenFunctions.EntityPlayer.GetActiveItem`
FiendFolio.OverriddenFunctions = FiendFolio.OverriddenFunctions or {}
FiendFolio.OverriddenFunctions.Game = FiendFolio.OverriddenFunctions.Game or {}

-- Individual overrides defined here, one per function.
FiendFolio.ApiOverrides = {
	EntityPlayer = {
		GetActiveItem = function(player, slot)
			return FiendFolio:getCreativeAIItem(player, slot) or FiendFolio.OverriddenFunctions.EntityPlayer.GetActiveItem(player, slot)
		end,
		AddCoins = function(player, amount)
			amount = FiendFolio:PlatinumCreditPreAddCoins(player, amount)
			FiendFolio.OverriddenFunctions.EntityPlayer.AddCoins(player, amount)
		end,
		ResetDamageCooldown = function(player)
			if player:GetPlayerType() == FiendFolio.PLAYER.BRIEND then
				local othertwin = player:GetOtherTwin()
				if othertwin then
					FiendFolio.OverriddenFunctions.EntityPlayer.ResetDamageCooldown(othertwin)
				end
			end
			FiendFolio.OverriddenFunctions.EntityPlayer.ResetDamageCooldown(player)
		end,
		SetMinDamageCooldown = function(player, amount)
			if player:GetPlayerType() == FiendFolio.PLAYER.BRIEND then
				local othertwin = player:GetOtherTwin()
				if othertwin then
					FiendFolio.OverriddenFunctions.EntityPlayer.SetMinDamageCooldown(othertwin, amount)
				end
			end
			FiendFolio.OverriddenFunctions.EntityPlayer.SetMinDamageCooldown(player, amount)
		end,
		TakeDamage = function(player, ...)
			if not FiendFolio.PreventBriendDamagePassing and player:GetPlayerType() == FiendFolio.PLAYER.BRIEND and not FiendFolio:IsSelectedBriend(player) then
				player = player:GetOtherTwin() or player
			end
			return FiendFolio.OverriddenFunctions.EntityPlayer.TakeDamage(player, ...)
		end,
		FireTear = function(player, ...)
			FiendFolio.IsModdedFireTear = (FiendFolio.IsModdedFireTear or 0) + 1
			local tear = FiendFolio.OverriddenFunctions.EntityPlayer.FireTear(player, ...)
			FiendFolio.IsModdedFireTear = (FiendFolio.IsModdedFireTear or 0) - 1
			return tear
		end
	},
}

for className, funcs in pairs(FiendFolio.ApiOverrides) do
	local T = _G[className]
	local META = type(T) == "function" and getmetatable(T()) or getmetatable(T).__class

	-- Only override __index once per class. Otherwise luamods would cause them to stack.
	if not rawget(META, "__indexOverriddenByFIENDFOLIOMOD") then
		local oldIndex = rawget(META, "__index")
		rawset(META, "__indexOverriddenByFIENDFOLIOMOD", oldIndex)
		rawset(META, "__index", CreateIndexOverride(className, oldIndex))
	end

	-- Store the original version of any overridden functions.
	for funcName, _ in pairs(funcs) do
		if not FiendFolio.OverriddenFunctions[className] then
			FiendFolio.OverriddenFunctions[className] = {}
		end
		FiendFolio.OverriddenFunctions[className][funcName] = rawget(META, "__indexOverriddenByFIENDFOLIOMOD")(META, funcName) or rawget(META, funcName)
	end
end
