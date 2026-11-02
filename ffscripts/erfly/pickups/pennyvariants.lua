local mod = FiendFolio
local sfx = SFXManager()

mod.PennySubsThatBecomeNormalPenniesOnCollision = {
    [mod.PICKUP.COIN.PENNY_THAT_DOUBLES_IN_SIZE_EVERY_DAY] = true,
    [mod.PICKUP.COIN.MOBILE_PENNY] = true,
}

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider)
	if mod.PennySubsThatBecomeNormalPenniesOnCollision[pickup.SubType] then
		if collider:ToPlayer() or collider:ToFamiliar() then
			pickup.SubType = 1
		end
	end
end, PickupVariant.PICKUP_COIN)

function mod:mobilePennyMovement(penny)
    local d = mod:GetEntityData(penny)
    local rng = penny:GetDropRNG()
    if d.walkPos then
        mod:CatheryPathFinding(penny, d.walkPos, {
            Speed = 1,
            Accel = 0.1,
            Threshold = 600
        })

        if penny.Position:Distance(d.walkPos) < 10 or rng:RandomInt(300) == 0 then
            d.walkPos = nil
        end
    else
        if rng:RandomInt(500) == 0 then
            d.walkPos = Game():GetRoom():GetRandomPosition(1)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, penny)
    if penny.SubType == mod.PICKUP.COIN.MOBILE_PENNY then
        mod:mobilePennyMovement(penny)

        if penny:GetSprite():IsEventTriggered("DropSound") then
			sfx:Play(SoundEffect.SOUND_PENNYDROP)
		end
    end
end, PickupVariant.PICKUP_COIN)