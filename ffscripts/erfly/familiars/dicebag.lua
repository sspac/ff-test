local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, familiar)
	familiar.IsFollower = true
end, mod.ITEM.FAMILIAR.DICE_BAG)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
	local data = mod:GetEntityData(familiar)
	local sprite = familiar:GetSprite()
	local payoutNum = 8
	if Sewn_API then
		if Sewn_API:IsUltra(data) then
			payoutNum = 4
		elseif Sewn_API:IsSuper(data) then
			payoutNum = 6
		end
	end
	if familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
		payoutNum = math.ceil(payoutNum / 2)
	end
	if familiar.Coins >= payoutNum then
		sprite:Play("Spawn", false)
		familiar.Coins = 0
	end
	if sprite:IsFinished("Spawn") then
		sprite:Play("FloatDown", false)
		local diceroll = mod:GetRandomGlassDice(familiar.Player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.DICE_BAG))
		local die = Isaac.Spawn(5, 300, diceroll, familiar.Position, nilvector, familiar)
	end
	familiar:FollowParent()
end, mod.ITEM.FAMILIAR.DICE_BAG)

function mod:diceBagRoomClear()
	for _, d in pairs(Isaac.FindByType(3, mod.ITEM.FAMILIAR.DICE_BAG, -1, false, false)) do
		familiar = d:ToFamiliar()
		familiar.Coins = familiar.Coins + 1
	end
end