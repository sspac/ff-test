local mod = FiendFolio
-- Stealing my own work from Retribution again

local function queueLiftItem(player, item)
	mod:GetEntityData(player).retributionItemToLift = item
end

function mod.SetItemState(player, item, slot, dontDischargeSlot, sourceItem)
	local data = mod:GetEntityData(player)
	data.retributionItemState = {
		Slot = slot or -1,
		StateItem = item,
		SourceItem = sourceItem or player:GetActiveItem(slot or -1),
		DischargeOnRemove = not dontDischargeSlot,
	}

	queueLiftItem(player, item)
end

function mod.RemoveItemState(player, skipDischarge, skipAnimation, d)
	local data = (d or mod:GetEntityData(player)).retributionItemState

	if data then
		if data.DischargeOnRemove and not skipDischarge and data.SourceItem > 0 then
			local chargesToRemove = -mod.GetItem(data.SourceItem).MaxCharges
			mod.AddCharges(player, data.Slot, chargesToRemove)
		end

		if not skipAnimation then
			player:AnimateCollectible(data.StateItem, "HideItem", "PlayerPickup")
		end

		(d or mod:GetEntityData(player)).retributionItemState = nil
		(d or mod:GetEntityData(player)).retributionItemToLift = nil
	end
end

function mod.HasItemState(player, stateItem, d)
	local data = (d or mod:GetEntityData(player)).retributionItemState
	return data and (data.StateItem == stateItem or not stateItem)
end

local function shouldInvalidateItemState(player, d) -- NOTE: THIS IS NOT FOR THE ITEM BEING USED, THIS IS FOR LOSING OR SWAPPING THE SOURCE ITEM
	local data = d.retributionItemState
	if data then
		if player:GetActiveItem(data.Slot) ~= data.SourceItem then
			mod.RemoveItemState(player, true, nil, d)
		end
	end
end

function mod:TryInvalidateItemState(player, data)
	if mod.HasItemState(player, nil, data) and shouldInvalidateItemState(player, data) then
		mod.RemoveItemState(player, true, nil, data)
	end

	if data.retributionItemToLift and player:IsExtraAnimationFinished() then
		player:AnimateCollectible(data.retributionItemToLift, "LiftItem", "PlayerPickup")
		data.retributionItemToLift = nil
	end
end

function mod.RemoveItemStateOnRoomChange()
	mod.AnyPlayerDo(function(player)
		mod.RemoveItemState(player, true, true)
	end)
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.RemoveItemStateOnRoomChange)