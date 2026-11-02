local mod = FiendFolio
local game = Game()

local Constants = {
    RADIUS = 40 * 2.5,
    SECONDS = 30 * 4,
    CHANCE = 0.20,
}

mod:AddTrinketCallback(CustomHealthAPI.Enums.Callbacks.POST_PLAYER_DAMAGE, mod.ITEM.TRINKET.BABY_BOTTLE, function(_, player, amount, flags, source, countdown)
	if player:HasTrinket(mod.ITEM.TRINKET.BABY_BOTTLE) then
        for _, ent in ipairs(Isaac.FindInRadius(player.Position, Constants.RADIUS, EntityPartition.ENEMY)) do
            if (
                ent:IsActiveEnemy() 
                and ent:IsVulnerableEnemy()
                and not ent:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
                and not mod:IsCharmedCool(ent)
            ) then
                local duration = Constants.SECONDS * player:GetTrinketMultiplier(mod.ITEM.TRINKET.BABY_BOTTLE)
                mod.AddPacified(ent, player, duration)
            end
        end
	end
end)

function mod:HandleBabyBottle(npc, data)
    if data.FFPacifiedDuration and npc:HasMortalDamage() then
        if not PlayerManager.AnyoneHasTrinket(mod.ITEM.TRINKET.BABY_BOTTLE) then
            return
        end

        if npc:HasEntityFlags(EntityFlag.FLAG_NO_REWARD) then
            return
        end
        
        local rng = npc:GetDropRNG()
        if rng:RandomFloat() < Constants.CHANCE then
            local pos = game:GetRoom():FindFreePickupSpawnPosition(npc.Position, 40, true)
            mod:TrySpawnHeart(
                {
                    {PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL},
                    {PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL}
                },
                pos, Vector.Zero, npc
            )
            mod.RemovePacified(npc)
        end
    end
end