local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

function mod:GetFractionalCoins()
	return mod.savedata.run.FractionalCoins or 0
end

function mod:AddFractionalCoins(amount)
	local p1 = Isaac.GetPlayer()
	local currentCoins = p1:GetNumCoins()
	local fractionalCoins = mod:LuaRound((mod.savedata.run.FractionalCoins or 0) + amount, 1)
	local wholeCoins = (fractionalCoins < 0) and math.ceil(fractionalCoins) or math.floor(fractionalCoins)
	fractionalCoins = fractionalCoins - wholeCoins
	if fractionalCoins < 0 then
		fractionalCoins = fractionalCoins + 1
		wholeCoins = wholeCoins - 1
	end
	if wholeCoins > 0 and currentCoins + wholeCoins > p1:GetMaxCoins() then
		fractionalCoins = 0.9
	elseif wholeCoins < 0 and currentCoins + wholeCoins < 0 then
		fractionalCoins = 0
	end
	mod.savedata.run.FractionalCoins = mod:LuaRound(fractionalCoins, 1)
	if wholeCoins ~= 0 then
		p1:AddCoins(wholeCoins)
	elseif fractionalCoins ~= 0 then
		for _, player in ipairs(PlayerManager.GetPlayers()) do
			if player:HasCollectible(CollectibleType.COLLECTIBLE_MONEY_EQUALS_POWER) then
				player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
			end
		end
	end
end

CustomHealthAPI.Library.RegisterPickupEntity(PickupVariant.PICKUP_COIN, mod.PICKUP.COIN.LIL_PENNY, {
	DropSound = { ID = SoundEffect.SOUND_PENNYDROP, Volume = 1, Pitch = 1.25 },
	CollectSound = { ID = SoundEffect.SOUND_PENNYPICKUP, Volume = 1, Pitch = 1.5 },
	OnCollect = function(player, pickup)
		mod:AddFractionalCoins(0.1)
		if pickup.InitSeed % 10 == 0 then
			mod:triggerPennyPickup(player, pickup, 1)
		end
		local d = mod:GetEntityData(pickup)
		if d.isPickupAToken and not FiendFolio.ACHIEVEMENT.LOADSAMONEY:IsUnlocked(true) then
			FiendFolio.ACHIEVEMENT.LOADSAMONEY:Unlock()
		end
	end,
})

local function IsCoinCollectingFamiliarVariant(familiarVariant)
	return familiarVariant == FamiliarVariant.BUM_FRIEND
		or familiarVariant == FamiliarVariant.BUMBO
		or familiarVariant == FamiliarVariant.SUPER_BUM
end

function mod:LilPennyCollision(pickup, collider, ...)
	local colliderType = collider.Type
	if colliderType == EntityType.ENTITY_ULTRA_GREED or colliderType == EntityType.ENTITY_BUMBINO
	or (colliderType == EntityType.ENTITY_FAMILIAR and IsCoinCollectingFamiliarVariant(collider.Variant)) then
		local sprite = pickup:GetSprite()
		if sprite:IsPlaying("Collect") or (sprite:IsPlaying("Appear") and not sprite:WasEventTriggered("DropSound")) or pickup:IsShopItem() then
			Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, collider, ...)
			return true
		end

		local triggerCollect = false

		if colliderType == EntityType.ENTITY_FAMILIAR then
			local familiar = collider:ToFamiliar()
			local familiarFractionalCoins = mod:LuaRound((mod.savedata.run.FamiliarFractionalCoins or 0) + 0.1, 1)
			if familiarFractionalCoins >= 1 then
				familiar.Coins = familiar.Coins + 1
				familiarFractionalCoins = 0
			end
			mod.savedata.run.FamiliarFractionalCoins = familiarFractionalCoins
			triggerCollect = true
		else
			local data = mod:GetEntityData(collider)
			local fractionalCoins = mod:LuaRound((data.fractionalCoinsCollected or 0) + 0.1, 1)
			if fractionalCoins >= 1 then
				data.fractionalCoinsCollected = 0
			else
				data.fractionalCoinsCollected = fractionalCoins
				triggerCollect = true
			end
		end

		if triggerCollect then
			pickup:GetSprite():Play("Collect", true)
			pickup.Touched = true
			pickup.Velocity = Vector.Zero
			pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			pickup:Die()
			Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, collider, ...)
			return true
		end
	end
end
mod:AddPriorityEntityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.LATE, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, mod.PICKUP.COIN.LIL_PENNY, mod.LilPennyCollision, PickupVariant.PICKUP_COIN)

-- 2 of Diamonds
mod:AddPriorityCallback(ModCallbacks.MC_USE_CARD, CallbackPriority.EARLY, function(_, _, player)
	local fractionalCoins = mod:GetFractionalCoins()
	if fractionalCoins > 0 then
		mod:AddFractionalCoins(fractionalCoins)
	end
end, Card.CARD_DIAMONDS_2)

-- Reverse Fool (drop lil pennies on ground)
mod:AddPriorityCallback(ModCallbacks.MC_USE_CARD, CallbackPriority.EARLY, function(_, _, player)
	local fractionalCoins = mod:GetFractionalCoins()
	if fractionalCoins > 0 then
		local room = game:GetRoom()
		mod:AddFractionalCoins(-fractionalCoins)
		for _ = 1, fractionalCoins * 10 do
			local pos = room:FindFreePickupSpawnPosition(player.Position, 40)
			Isaac.Spawn(5, 20, mod.PICKUP.COIN.LIL_PENNY, pos, Vector.Zero, player)
		end
	end
end, Card.CARD_REVERSE_FOOL)

function mod:PreventSmallPennyReroll()
	local smallPennies = {}
	for _, penny in ipairs(Isaac.FindByType(5, 20, FiendFolio.PICKUP.COIN.LIL_PENNY, false, false)) do
		local sprite = penny:GetSprite()
		if not sprite:IsPlaying("Collect") then
			table.insert(smallPennies, {
				Position = penny.Position,
				Velocity = penny.Velocity,
				Animation = sprite:GetAnimation(),
				AnimationFrame = sprite:GetFrame(),
				GridColl = penny.GridCollisionClass,
				EntColl = penny.EntityCollisionClass
			})
			penny:Remove()
		end
	end
	mod.scheduleForUpdate(function()
		for i = 1, #smallPennies do
			local pennyInfo = smallPennies[i]
			local penny = Isaac.Spawn(5, 20, FiendFolio.PICKUP.COIN.LIL_PENNY, pennyInfo.Position, pennyInfo.Velocity, nil)
			penny.GridCollisionClass = pennyInfo.GridColl
			penny.EntityCollisionClass = pennyInfo.EntColl
			local sprite = penny:GetSprite()
			sprite:Play(pennyInfo.Animation)
			sprite:SetFrame(pennyInfo.AnimationFrame)
			penny:Update()
		end
	end, 1, ModCallbacks.MC_INPUT_ACTION)
end

mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, mod.PreventSmallPennyReroll, CollectibleType.COLLECTIBLE_D20)

function mod:FixReplacedSmallPennies(card)
	for _, originalPenny in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, mod.PICKUP.COIN.LIL_PENNY)) do
		if card == Card.RUNE_BLACK then
			for _, familiar in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR)) do
				if (familiar.Variant == FamiliarVariant.BLUE_FLY or familiar.Variant == FamiliarVariant.BLUE_SPIDER)
						and (familiar.Position.X == originalPenny.Position.X and familiar.Position.Y == originalPenny.Position.Y)
						and familiar.FrameCount <= 1 then
					familiar:Remove()
				end
			end
		else
			for _, pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
				if (pickup.Variant ~= PickupVariant.PICKUP_COIN or pickup.SubType ~= mod.PICKUP.COIN.LIL_PENNY)
						and pickup.Position.X == originalPenny.Position.X
						and pickup.Position.Y == originalPenny.Position.Y
						and pickup.FrameCount <= 1 then
					pickup:Remove()
				end
			end
		end
		
		local newPenny = Isaac.Spawn(5, 20, FiendFolio.PICKUP.COIN.LIL_PENNY, originalPenny.Position, originalPenny.Velocity, nil)
		newPenny.GridCollisionClass = originalPenny.GridCollisionClass
		newPenny.EntityCollisionClass = originalPenny.EntityCollisionClass
		local sprite = newPenny:GetSprite()
		sprite:Play(originalPenny:GetSprite():GetAnimation())
		sprite:SetFrame(originalPenny:GetSprite():GetFrame())
		newPenny:Update()
		
		originalPenny:Remove()
	end
end
local CardsToStopFromReplacingSmallPennies = {
	Card.CARD_ACE_OF_CLUBS,
	Card.CARD_ACE_OF_HEARTS,
	Card.CARD_ACE_OF_SPADES,
	Card.CARD_ACE_OF_DIAMONDS,
	Card.RUNE_BLACK,
}
for _, card in ipairs(CardsToStopFromReplacingSmallPennies) do
	mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.FixReplacedSmallPennies, card)
end

if ModCallbacks.MC_EVALUATE_STAT then
	-- A final damage increase of < 0.02 will not trigger the +stat popup on the hud. Work around this at some point?
	mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_STAT, CollectibleType.COLLECTIBLE_MONEY_EQUALS_POWER, function(_, player, _, damage)
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MONEY_EQUALS_POWER) then
			return damage + 0.04 * mod:GetFractionalCoins()
		end
	end, EvaluateStatStage.DAMAGE_UP)
end
