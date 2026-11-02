local mod = FiendFolio

local Settings = {
	AddThreshold = 10,
	BaseIncrease = 2,
	ExtraIncrease = 0.25,
}



-- Keep track of the previous coin count
function mod:PlushieGreedPlayerUpdate(player)
	local data = mod:GetEntityData(player)
	data.PreviousCoinCount = player:GetNumCoins()
	data.PreviousFractionalCoinCount = mod:GetFractionalCoins()
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.ITEM.TRINKET.PLUSHIE_GREED, mod.PlushieGreedPlayerUpdate)



-- Handle picking up pennies
function mod:PlushieGreedPennyPickup(pickup, collider, bool)
	local player = collider:ToPlayer()

	if mod.IsCoinVariant(pickup.Variant) and pickup:IsDead()
	and player and player:HasTrinket(mod.ITEM.TRINKET.PLUSHIE_GREED) then
		local data = mod:GetEntityData(player)
		local valueToAdd = 0

		-- Don't add pennies immediately
		if (data.PreviousCoinCount and player:GetNumCoins() > data.PreviousCoinCount) or player:GetNumCoins() >= player:GetMaxCoins() then
			local sub = player:GetNumCoins() - data.PreviousCoinCount
			player:AddCoins(-sub)
			valueToAdd = valueToAdd + math.max(mod.GetCoinValue(pickup), sub)
		end

		-- Don't add lil' pennies immediately
		if data.PreviousFractionalCoinCount and mod:GetFractionalCoins() ~= data.PreviousFractionalCoinCount then
			local sub = mod:GetFractionalCoins() - data.PreviousFractionalCoinCount
			mod:AddFractionalCoins(-sub)
			valueToAdd = valueToAdd + sub
		end

		-- Store the penny's value
		if valueToAdd ~= 0 then
			local saveData = mod.savedata.run
			saveData.GreedyPlushieTracker = saveData.GreedyPlushieTracker or 0
			saveData.GreedyPlushieTracker = saveData.GreedyPlushieTracker + valueToAdd

			-- Increase the stored amount and add it if the threshold is reached
			if saveData.GreedyPlushieTracker >= Settings.AddThreshold then
				local multi = PlayerManager.GetTotalTrinketMultiplier(mod.ITEM.TRINKET.PLUSHIE_GREED)
				local extraIncrease = (multi - 1) * Settings.ExtraIncrease
				local increase = Settings.BaseIncrease + extraIncrease
				local finalAmount = saveData.GreedyPlushieTracker * increase

				-- Add the coins
				player:AddCoins( math.floor(finalAmount) )
				mod:AddFractionalCoins(finalAmount % 1)
				saveData.GreedyPlushieTracker = 0

				-- Effects
				player:SetColor(Color(1,1,1, 1, 0.5,0.5,0), 5, 1, true, false)
				mod:PlaySoundCool(nil, SoundEffect.SOUND_CASH_REGISTER)
			end
		end
	end
end
mod:AddPriorityTrinketCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, math.huge, mod.ITEM.TRINKET.PLUSHIE_GREED, mod.PlushieGreedPennyPickup)



-- Render the counter over the trinket
local sprite = Sprite("gfx/items/trinkets/plushie_greed_counter.anm2", true)
sprite:Play("Idle", true)
sprite.PlaybackSpeed = 0

function mod:PlushieGreedCounter(slot, position, scale, player, cropOffset)
	if player:GetTrinket(slot) == mod.ITEM.TRINKET.PLUSHIE_GREED then
		sprite.Scale = Vector.One * scale

		-- Set the frame
		local saveData = mod.savedata.run
		local counter = saveData.GreedyPlushieTracker or 0
		sprite:SetFrame( math.floor(counter + 0.1) ) -- Lazy fix

		-- Get the position
		local offset = scale * Vector(32, 28)
		local renderPos = position + offset

		-- Queue the rendering for later
		local func = function()
			sprite:Render(renderPos)
		end
		mod.scheduleForUpdate(func, 0, ModCallbacks.MC_POST_HUD_RENDER, true)
	end
end
mod:AddTrinketCallback(ModCallbacks.MC_PRE_PLAYERHUD_TRINKET_RENDER, mod.ITEM.TRINKET.PLUSHIE_GREED, mod.PlushieGreedCounter)