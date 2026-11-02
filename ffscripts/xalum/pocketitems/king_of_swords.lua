local mod = FiendFolio
local kingOfSwords = mod.ITEM.CARD.KING_OF_SWORDS

local commonDips = {
	[0] = true,
	[1] = true,
	[2] = true,
	[20] = true,
}

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, card, player, flags)
	FiendFolio:AddInnateCollectibleForFloor(player, CollectibleType.COLLECTIBLE_BFFS, 1, false)
	FiendFolio:AddInnateCollectibleForFloor(player, CollectibleType.COLLECTIBLE_HIVE_MIND, 1, false)

	--Upgrade familiars
	local rng = player:GetCardRNG(kingOfSwords)
	for _, fly in pairs(Isaac.FindByType(3, FamiliarVariant.BLUE_FLY, 0)) do
		local fly = fly:ToFamiliar()
		local rand = rng:RandomInt(5) + 1
		if rand == 5 then
			for i = 1, 3 do
				local newFly = Isaac.Spawn(3, FamiliarVariant.BLUE_FLY, rand, fly.Position + RandomVector() * 10, Vector.Zero, fly.Player)
				newFly:Update()
			end
		else
			local newFly = Isaac.Spawn(3, FamiliarVariant.BLUE_FLY, rand, fly.Position, Vector.Zero, fly.Player)
			newFly:Update()
		end
		fly:Remove()
	end

	for _, dip in pairs(Isaac.FindByType(3, FamiliarVariant.DIP, -1)) do
		if commonDips[dip.SubType] then
			local dip = dip:ToFamiliar()
			local newVar = rng:RandomInt(#mod.poopyFamiliars.Rare2) + 1
			local newDip = Isaac.Spawn(3, FamiliarVariant.DIP, mod.poopyFamiliars.Rare2[newVar], dip.Position, Vector.Zero, dip.Player)
			newDip:Update()
			dip:Remove()
		elseif dip.SubType == 3 then
			local dip = dip:ToFamiliar()
			local newDip = Isaac.Spawn(3, FamiliarVariant.DIP, 669, dip.Position, Vector.Zero, dip.Player)
			newDip:Update()
			dip:Remove()
		elseif dip.SubType ~= 669 then
			local dip = dip:ToFamiliar()
			local newDip = Isaac.Spawn(3, FamiliarVariant.DIP, 3, dip.Position, Vector.Zero, dip.Player)
			newDip:Update()
			dip:Remove()
		end
	end

	for _, skuzz in pairs(Isaac.FindByType(3, mod.ITEM.FAMILIAR.ATTACK_SKUZZ, 0)) do
		local skuzz = skuzz:ToFamiliar()
		local rand = rng:RandomInt(4) + 1
		local newSkuzz = Isaac.Spawn(3, mod.ITEM.FAMILIAR.ATTACK_SKUZZ, rand, skuzz.Position, Vector.Zero, skuzz.Player)
		newSkuzz:Update()
		skuzz:Remove()
	end

	FiendFolio:trySayAnnouncerLine(mod.Sounds.VACardPlayingKingSwords, flags, 20)
end, kingOfSwords)