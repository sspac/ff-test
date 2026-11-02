local mod = FiendFolio
local game = Game()
local nilvector = mod.nilvector

mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.TRINKET.FORTUNE_GRUB, function(_, player)
	local n = player:GetTrinketMultiplier(mod.ITEM.TRINKET.FORTUNE_GRUB)
	if n > 0 then
		for _, slot in pairs(Isaac.FindByType(6, -1, -1)) do
			local s = slot:GetSprite()
			if s:IsFinished("WiggleEnd") then
				FiendFolio.QueueFortunes(n)
			elseif s:IsFinished("PayNothing") or s:IsFinished("PayPrize") then
				s:Play("Idle")
				FiendFolio.QueueFortunes(n)
			end
			for i = 1, 3 do
				if s:IsPlaying("Shell" .. i .. "Prize") then
					if s:IsEventTriggered("Prize") then
						FiendFolio.QueueFortunes(n)
					end
				end
			end
			if slot.Variant == 10 and s:IsOverlayPlaying("CoinInsert") and s:GetOverlayFrame() == 6 then
				FiendFolio.QueueFortunes(n)
			elseif slot.Variant == 2 and s:IsEventTriggered("Prize") then
				FiendFolio.QueueFortunes(n)
			elseif (slot.Variant == 8 or slot.Variant == 11)
			and ((s:IsOverlayPlaying("CoinInsert") and s:GetOverlayFrame() == 6)
			or (s:IsOverlayPlaying("CoinInsert2") and s:GetOverlayFrame() == 4)
			or (s:IsOverlayPlaying("CoinInsert3") and s:GetOverlayFrame() == 2)
			) then
				FiendFolio.QueueFortunes(n)
			elseif slot.Variant == 16 and (s:IsEventTriggered("Prize") or s:IsFinished("NoPrize")) then
				FiendFolio.QueueFortunes(n)
			elseif slot.Variant == 17 and (s:IsEventTriggered("Prize") or s:IsFinished("NoPrize")) then
				FiendFolio.QueueFortunes(n)
			end
		end
	end
end)

function FiendFolio.QueueFortunes(num)
	local d = mod:GetEntityData(Isaac.GetPlayer(0))

	d.fortunestodisplay = d.fortunestodisplay or 0
	d.fortunetimer = d.fortunetimer or 0

	d.fortunestodisplay = d.fortunestodisplay + num
end

function mod:DisplayQueuedFortunes(player, data)
	if data.fortunestodisplay and data.fortunestodisplay > 0 then
		if not data.fortunetimer then data.fortunetimer = 0 end

		if data.fortunetimer % 75 == 0 then
			--game:ShowFortune()
			mod:ShowFortune()
			data.fortunestodisplay = data.fortunestodisplay - 1
		end

		data.fortunetimer = data.fortunetimer + 1
	else
		if data.fortunetimer then
			data.fortunetimer = nil
		end
	end
end