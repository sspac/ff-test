local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

function mod.trySpawnPosticheSkuzz(player, fireVec, rng)
    local chance = math.floor(math.max(1,20 - (player.Luck * 2)))
    if rng:RandomInt(chance) == 0 then
        local maxSkuzz = 10
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
            maxSkuzz = maxSkuzz * 2
        end
        if mod.GetEntityCount(3, mod.ITEM.FAMILIAR.ATTACK_SKUZZ) < maxSkuzz then
            sfx:Play(SoundEffect.SOUND_SKIN_PULL, 0.2, 0, false, math.random(160,200)/100)
            local randVec = fireVec:Resized(math.random(3,10)):Rotated(-45 + math.random(90))
            local skuzz = Isaac.Spawn(3, mod.ITEM.FAMILIAR.ATTACK_SKUZZ, 0, player.Position - randVec, nilvector, player):ToFamiliar()
            skuzz:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            skuzz:Update()
        end
    end
end

FiendFolio.AddItemPickupCallback(function(player, added)
    if mod.ACHIEVEMENT.MORBID_HEART:IsUnlocked() then
        mod:AddMorbidHearts(player, 1)
    else
        player:AddHearts(1)
    end
end, nil, mod.ITEM.COLLECTIBLE.DADS_POSTICHE)

mod:AddCollectibleCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE, mod.ITEM.COLLECTIBLE.DADS_POSTICHE, function(_, player, dir, amount, owner, params)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.DADS_POSTICHE) then
		local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.DADS_POSTICHE)
		for i = 1, amount do
			mod.trySpawnPosticheSkuzz(player, dir, rng)
		end
	end
end)