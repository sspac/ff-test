local mod = CustomPoopAPI
local game = Game()
local itemconfig = Isaac.GetItemConfig()

local CUSTOM_HOLD = Isaac.GetItemIdByName(" Hold")

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, collectible, rng, player)
	local savedata = mod.GetPersistentPlayerData(player)
	if savedata.Poops then
		if not savedata.StoredPoop and player:GetPoopMana() > 0 then
			player:AddPoopMana(-1)
			savedata.StoredPoop = savedata.Poops[1]
			table.remove(savedata.Poops, 1)
			SFXManager():Play(SoundEffect.SOUND_POOPITEM_STORE)
			return true
		elseif not player:ThrowHeldEntity(Vector.Zero) then
			mod:RunPoopSpellCallback(savedata.StoredPoop, {savedata.StoredPoop, player})
			savedata.StoredPoop = nil
		end
	end
end, CUSTOM_HOLD)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_HOLD) then
		player:SetPocketActiveItem(CUSTOM_HOLD, ActiveSlot.SLOT_POCKET)
	end
	--I'm so sorry JD
	--You don't have to fix it your end but it'd probably be cleaner
	if Epiphany and not Epiphany.FIXED_CUSTOM_POOP_API_OUR_END_NOW then
		local epiphanySave = Epiphany:RunSave()
		if epiphanySave then
			--Bug occurs where shred just wouldn't appear
			--Soooooooooooooooooooooooooooo
			if not epiphanySave.CustomPoopAPIGaveShred then
				if epiphanySave.CustomPoopAPIShredWait then
					player:SetPocketActiveItem(Isaac.GetItemIdByName("Shred"), ActiveSlot.SLOT_POCKET)
					epiphanySave.CustomPoopAPIGaveShred = true
				else
					if epiphanySave.TR_BB_UNLOCK_METHOD_STARTED
					and not epiphanySave.CustomPoopAPIShredWait
					then
						--Can't give it on the same frame, or no item appears
						--Has to wait another frame for some godforsaken reason
						epiphanySave.CustomPoopAPIShredWait = true
					end
				end
			end
		end
	end
end, PlayerType.PLAYER_BLUEBABY_B)

function mod:RenderHold(player, slot, pos, alpha, scale, chargeBarPos)
	if slot == ActiveSlot.SLOT_POCKET then
		local savedata = mod.GetPersistentPlayerData(player)
		if savedata.StoredPoop then
			local sprite = mod.SpellSprites[savedata.StoredPoop].IdleSmall
			if sprite:IsLoaded() then
				sprite.Scale = Vector(scale, scale)
				sprite.Color.A = alpha
				local offset = Vector(16, 19)
				sprite:Render(pos + offset * scale)
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_ACTIVE_ITEM, mod.RenderHold, CUSTOM_HOLD)

function mod:CustomPoopApiResetOnGameStart(iscontinued)
	mod.rng:SetSeed(Game():GetSeeds():GetStartSeed(), 35)
	if not iscontinued then
		mod.savedata.persistentPlayerData = {}
	end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.CustomPoopApiResetOnGameStart)
