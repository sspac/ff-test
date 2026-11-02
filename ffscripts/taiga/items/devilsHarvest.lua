-- The Devil's Harvest --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

--this code is modified from ffscripts/players/craig.lua

local function isaacBecomeFiendish(player, data)
	CustomHealthAPI.Library.ResetPlayerData(player)
	if player:GetPlayerType() == FiendFolio.PLAYER.BIEND then
		player:AddEternalHearts(-999)
		player:AddGoldenHearts(-999)
		player:AddBlackHearts(-999)
		player:AddBoneHearts(-999)
		player:AddMaxHearts(-999)
		player:AddSoulHearts(-999)

		player:AddBlackHearts(4)
	else
		player:ChangePlayerType(FiendFolio.PLAYER.FIEND)
		player:AddEternalHearts(-999)
		player:AddGoldenHearts(-999)
		player:AddBlackHearts(-999)
		player:AddBoneHearts(-999)
		player:AddMaxHearts(-999)
		player:AddSoulHearts(-999)

		player:AddBlackHearts(4)
		mod:AddImmoralHearts(player, 2)
	end
end

-- Called from `ffscripts/revives.lua`
function mod.TryDevilsHarvestRevive(player, data, effs)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.DEVILS_HARVEST) then
        player:Revive()
		player:RemoveCollectible(mod.ITEM.COLLECTIBLE.DEVILS_HARVEST)

		-- Transform the main twin.
		if player:GetMainTwin() and GetPtrHash(player) ~= GetPtrHash(player:GetMainTwin()) then
			player = player:GetMainTwin()
			player:Revive()
		end

		isaacBecomeFiendish(player, data)
		player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/characters/devils_harvest_revive.anm2"))
		if game:GetLevel():GetStage() == LevelStage.STAGE8 and game:GetRoom():GetType() == RoomType.ROOM_DUNGEON then
			player:SetMinDamageCooldown(90)
		else
			game:StartRoomTransition(game:GetLevel():GetLastRoomDesc().SafeGridIndex, -1, 0, player)
			mod.scheduleForUpdate(function()
				player:AnimateCollectible(mod.ITEM.COLLECTIBLE.DEVILS_HARVEST)
			end, 2, nil, true)
		end
	end
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
	local data = mod:GetEntityData(familiar)
	local sprite = familiar:GetSprite()

	if not data.init then
		familiar:AddToFollowers()
		data.init = true
	end
	familiar:FollowParent()
	
	if not sprite:IsPlaying("Float") then
		sprite:Play("Float", true)
	end
	familiar.SpriteOffset = Vector(0,-3)
end, FiendFolio.ITEM.FAMILIAR.DEVILS_HARVEST)