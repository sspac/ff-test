local mod = FiendFolio
local game = Game()

local DONATION_MACHINE_MAX = 999

function mod:LifeInsuranceOnExit()
    if not game:AchievementUnlocksDisallowed() then
        local d = Isaac.GetPersistentGameData()
        local mult = PlayerManager.GetTotalTrinketMultiplier(mod.ITEM.TRINKET.LIFE_INSURANCE)


        -- Which counter do we add to?
        local counter = EventCounter.DONATION_MACHINE_COUNTER
        if game:IsGreedMode() then
            counter = EventCounter.GREED_DONATION_MACHINE_COUNTER
        end


        -- Donation machines can go above 1000 in code but only hold up to 999
        local current = d:GetEventCounter(counter) % (DONATION_MACHINE_MAX + 1)
        local max = DONATION_MACHINE_MAX - current

        local moneyToAdd = Isaac.GetPlayer(0):GetNumCoins() * mult
        local finalAdd = math.min(moneyToAdd, max)


        if finalAdd > 0 then
            d:IncreaseEventCounter(counter, finalAdd)
        end
    end
end
mod:AddTrinketCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.ITEM.TRINKET.LIFE_INSURANCE, mod.LifeInsuranceOnExit)

--[[
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
	if not game:AchievementUnlocksDisallowed() then
		if not isContinued and mod.savedata.LifeInsuranceMoneyToAdd then
            local counter = EventCounter.DONATION_MACHINE_COUNTER
            if mod.savedata.LifeInsuranceLastMode then
                counter = EventCounter.GREED_DONATION_MACHINE_COUNTER
            end
            local value = mod.savedata.LifeInsuranceMoneyToAdd
			local d = Isaac.GetPersistentGameData()
            local max = 999-d:GetEventCounter(counter)
            local inc = math.min(max, value)
            if inc > 0 then
                d:IncreaseEventCounter(counter, inc)
            end
            mod.savedata.LifeInsuranceMoneyToAdd = nil
		end
	end
end)
]]