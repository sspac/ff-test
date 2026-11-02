-- Character Select --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local randomPickupChance = 0.05
FiendFolio.CharacterSelectPlayerTypes = {}

function mod:registerCharacterSelectSoulstoneRevive(cardId, playerType)
	mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, _, player)
		if player:HasTrinket(mod.ITEM.TRINKET.CHARACTER_SELECT) then
			local data = mod:GetEntityData(player).ffsavedata
			data.CharacterSelectCharged = {}
			table.insert(data.CharacterSelectCharged, {PlayerType = playerType, 
			                                           TrinketMult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.CHARACTER_SELECT)})
			local t0, t1, smeltedTrinkets = player:GetTrinket(0), player:GetTrinket(1), player:GetSmeltedTrinkets()
			if t0 == mod.ITEM.TRINKET.CHARACTER_SELECT + TrinketType.TRINKET_GOLDEN_FLAG or
			   t1 == mod.ITEM.TRINKET.CHARACTER_SELECT + TrinketType.TRINKET_GOLDEN_FLAG or
			   smeltedTrinkets[mod.ITEM.TRINKET.CHARACTER_SELECT].goldenTrinketAmount > 0
			then
				player:TryRemoveTrinket(mod.ITEM.TRINKET.CHARACTER_SELECT + TrinketType.TRINKET_GOLDEN_FLAG)
			else
				player:TryRemoveTrinket(mod.ITEM.TRINKET.CHARACTER_SELECT)
			end
		end
	end, cardId)
	table.insert(FiendFolio.CharacterSelectPlayerTypes, playerType)
end

mod:registerCharacterSelectSoulstoneRevive(Card.CARD_SOUL_ISAAC, PlayerType.PLAYER_ISAAC)
mod:registerCharacterSelectSoulstoneRevive(Card.CARD_SOUL_MAGDALENE, PlayerType.PLAYER_MAGDALENE)
mod:registerCharacterSelectSoulstoneRevive(Card.CARD_SOUL_CAIN, PlayerType.PLAYER_CAIN)
mod:registerCharacterSelectSoulstoneRevive(Card.CARD_SOUL_JUDAS, PlayerType.PLAYER_JUDAS)
mod:registerCharacterSelectSoulstoneRevive(Card.CARD_SOUL_BLUEBABY, PlayerType.PLAYER_BLUEBABY)
mod:registerCharacterSelectSoulstoneRevive(Card.CARD_SOUL_EVE, PlayerType.PLAYER_EVE)
mod:registerCharacterSelectSoulstoneRevive(Card.CARD_SOUL_SAMSON, PlayerType.PLAYER_SAMSON)
mod:registerCharacterSelectSoulstoneRevive(Card.CARD_SOUL_AZAZEL, PlayerType.PLAYER_AZAZEL)
mod:registerCharacterSelectSoulstoneRevive(Card.CARD_SOUL_LAZARUS, PlayerType.PLAYER_LAZARUS)
mod:registerCharacterSelectSoulstoneRevive(Card.CARD_SOUL_EDEN, PlayerType.PLAYER_EDEN)
mod:registerCharacterSelectSoulstoneRevive(Card.CARD_SOUL_LOST, PlayerType.PLAYER_THELOST)
mod:registerCharacterSelectSoulstoneRevive(Card.CARD_SOUL_LILITH, PlayerType.PLAYER_LILITH)
mod:registerCharacterSelectSoulstoneRevive(Card.CARD_SOUL_KEEPER, PlayerType.PLAYER_KEEPER)
mod:registerCharacterSelectSoulstoneRevive(Card.CARD_SOUL_APOLLYON, PlayerType.PLAYER_APOLLYON)
mod:registerCharacterSelectSoulstoneRevive(Card.CARD_SOUL_FORGOTTEN, PlayerType.PLAYER_THEFORGOTTEN)
mod:registerCharacterSelectSoulstoneRevive(Card.CARD_SOUL_BETHANY, PlayerType.PLAYER_BETHANY)
mod:registerCharacterSelectSoulstoneRevive(Card.CARD_SOUL_JACOB, PlayerType.PLAYER_JACOB)
mod:registerCharacterSelectSoulstoneRevive(FiendFolio.ITEM.CARD.SOUL_OF_FIEND, FiendFolio.PLAYER.FIEND)
mod:registerCharacterSelectSoulstoneRevive(FiendFolio.ITEM.CARD.SOUL_OF_GOLEM, FiendFolio.PLAYER.GOLEM)
mod:registerCharacterSelectSoulstoneRevive(FiendFolio.ITEM.CARD.SOUL_OF_CRAIG, FiendFolio.PLAYER.CRAIG)
mod:registerCharacterSelectSoulstoneRevive(FiendFolio.ITEM.CARD.SOUL_OF_INABA, FiendFolio.PLAYER.INABA)

function mod:soulOfRandomCharacterSelect(choice)
	if FiendFolio.CharacterSelectPlayerTypes[choice] and player:HasTrinket(mod.ITEM.TRINKET.CHARACTER_SELECT) then
		local data = mod:GetEntityData(player).ffsavedata
		data.CharacterSelectCharged = {}
		table.insert(data.CharacterSelectCharged, {PlayerType = FiendFolio.CharacterSelectPlayerTypes[choice], 
		                                           TrinketMult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.CHARACTER_SELECT)})
		local t0, t1, smeltedTrinkets = player:GetTrinket(0), player:GetTrinket(1), player:GetSmeltedTrinkets()
		if t0 == mod.ITEM.TRINKET.CHARACTER_SELECT + TrinketType.TRINKET_GOLDEN_FLAG or
		   t1 == mod.ITEM.TRINKET.CHARACTER_SELECT + TrinketType.TRINKET_GOLDEN_FLAG or
		   smeltedTrinkets[mod.ITEM.TRINKET.CHARACTER_SELECT].goldenTrinketAmount > 0
		then
			player:TryRemoveTrinket(mod.ITEM.TRINKET.CHARACTER_SELECT + TrinketType.TRINKET_GOLDEN_FLAG)
		else
			player:TryRemoveTrinket(mod.ITEM.TRINKET.CHARACTER_SELECT)
		end
	end
end

mod:AddPriorityCallback(CustomHealthAPI.Enums.Callbacks.PRE_RENDER_LIVES, 1, function(_, player, lives, isChance, heartsRenderedOffset, columnOffset)
	local data = mod:GetEntityData(player)
	local sdata = data.ffsavedata
	if sdata.CharacterSelectCharged then 
		return {Lives = lives + #sdata.CharacterSelectCharged}
	end
end)

-- Called from `ffscripts/revives.lua`
function mod.TryCharacterSelectRevive(player, data, effs)
	local sdata = data.ffsavedata
	
	if sdata.CharacterSelectCharged then
		local reviveInfo = sdata.CharacterSelectCharged[1]
		table.remove(sdata.CharacterSelectCharged, 1)
		if #sdata.CharacterSelectCharged <= 0 then
			sdata.CharacterSelectCharged = nil
		end
		
		player:Revive()
		
		-- Transform the main twin.
		if player:GetMainTwin() and GetPtrHash(player) ~= GetPtrHash(player:GetMainTwin()) then
			player = player:GetMainTwin()
			player:Revive()
		end
		
		player:ChangePlayerType(reviveInfo.PlayerType)
		
		CustomHealthAPI.Library.ResetPlayerData(player)
		if reviveInfo.TrinketMult and reviveInfo.TrinketMult > 1 then
			if reviveInfo.PlayerType == PlayerType.PLAYER_THEFORGOTTEN then
				player:AddBoneHearts(-99)
				player:AddBoneHearts(1)
			end
			player:SetFullHearts()
		elseif player:GetHealthType() == HealthType.COIN then
			player:AddHearts(-99)
			player:AddHearts(2)
		elseif reviveInfo.PlayerType == PlayerType.PLAYER_THEFORGOTTEN then
			player:AddBoneHearts(-99)
			player:AddBoneHearts(1)
		elseif reviveInfo.PlayerType == PlayerType.PLAYER_JACOB then
			local othertwin = player:GetOtherTwin()
			if othertwin then
				if player:GetMaxHearts() > 0 then
					player:AddSoulHearts(-99)
					player:AddHearts(-99)
					player:AddHearts(1)
				end
			end
		elseif reviveInfo.PlayerType == FiendFolio.PLAYER.FIEND then
			player:AddSoulHearts(-99)
			mod:AddImmoralHearts(player, 1)
		end
		if reviveInfo.PlayerType == PlayerType.PLAYER_THEFORGOTTEN then
			player:AddSoulHearts(-99)
			player:AddSoulHearts(1)
		elseif reviveInfo.PlayerType == FiendFolio.PLAYER.CRAIG then
			player:SetPocketActiveItem(mod.ITEM.COLLECTIBLE.CRAIGS_BATTERY)
		elseif reviveInfo.PlayerType == FiendFolio.PLAYER.INABA then
			player:GetSprite():Load("gfx/characters/player_inaba.anm2", true)
			player:GetSprite():Play(player:GetSprite():GetDefaultAnimationName(), true)
		end
		
		Isaac.RunCallbackWithParam(mod.CALLBACK.POST_CHARACTER_SELECT_REVIVE, reviveInfo.PlayerType, player, reviveInfo.PlayerType)
		
		if game:GetLevel():GetStage() == LevelStage.STAGE8 and game:GetRoom():GetType() == RoomType.ROOM_DUNGEON then
			player:SetMinDamageCooldown(90)
		elseif reviveInfo.TrinketMult and reviveInfo.TrinketMult <= 2 then
			game:StartRoomTransition(game:GetLevel():GetLastRoomDesc().SafeGridIndex, -1, 0, player)
			mod.scheduleForUpdate(function()
				player:AnimateTrinket(mod.ITEM.TRINKET.CHARACTER_SELECT)
			end, 2, nil, true)
		else
			player:AnimateTrinket(mod.ITEM.TRINKET.CHARACTER_SELECT, "UseItem")
			player:SetMinDamageCooldown(90)
		end
	end
end

mod:AddPriorityTrinketCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, 10, mod.ITEM.TRINKET.CHARACTER_SELECT, function(_, dropRNG, spawnPos)
	--ROOM REWARDS
	local chance = randomPickupChance * PlayerManager.GetTotalTrinketMultiplier(mod.ITEM.TRINKET.CHARACTER_SELECT)
	if chance > 0 then
		local room = game:GetRoom()
		local roomtype = room:GetType()
		if roomtype == RoomType.ROOM_DEFAULT then
			if dropRNG:RandomFloat() < chance then
				local spawn = Isaac.Spawn(5, 310, 0, room:FindFreePickupSpawnPosition(spawnPos, 10, true), nilvector, nil)
				return true
			end
		end
	end
end)