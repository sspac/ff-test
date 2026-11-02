local mod = FiendFolio

local Settings = {
	BaseDuration = 1.5,
	ExtraDuration = 0.5,

	BaseChance = 85,
	ExtraChance = 5,
}



-- Check if the given heart is a red heart variant and return its data if it is
local function isRedHeart(pickup)
	local pickupDef = CustomHealthAPI.Library.GetPickupDefinition(pickup.Variant, pickup.SubType)

	if pickupDef and pickupDef.IsHeart and pickupDef.HealthKeys then
		for i, heartType in pairs(pickupDef.HealthKeys) do
			if CustomHealthAPI.Library.GetInfoOfKey(heartType, "Type") == CustomHealthAPI.Enums.HealthTypes.RED then
				return pickupDef, heartType
			end
		end
	end
end



-- Make red hearts temporary
function mod:PlushieGluttonyHeartInit(pickup)
	local pickupDef, heartType = isRedHeart(pickup)

	if pickupDef and pickup.Timeout <= -1 then
		local extra = pickupDef.HealthAmount * Settings.ExtraDuration
		pickup.Timeout = (Settings.BaseDuration + extra) * 30
	end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.ITEM.TRINKET.PLUSHIE_GLUTTONY, mod.PlushieGluttonyHeartInit)



-- Have a chance to spawn a half red heart when picking up red hearts
local tryCreatingHeart = false

function mod:PlushieGluttonyHeartPickup(pickup, collider, bool)
	local pickupDef, heartType = isRedHeart(pickup)
	local player = collider:ToPlayer()

	if pickupDef and player then
		tryCreatingHeart = heartType

		mod.scheduleForUpdate(function()
			tryCreatingHeart = false
		end, 0)
	end
end
mod:AddTrinketCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.ITEM.TRINKET.PLUSHIE_GLUTTONY, mod.PlushieGluttonyHeartPickup)

function mod:PlushieGluttonyHeartAdd(player, heartType, amount)
	if heartType == tryCreatingHeart then
		local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.PLUSHIE_GLUTTONY)
		local multi = PlayerManager.GetTotalTrinketMultiplier(mod.ITEM.TRINKET.PLUSHIE_GLUTTONY)
		local extraChance = (multi - 1) * Settings.ExtraChance
		local chance = Settings.BaseChance + extraChance

		if mod:Random(nil, nil, rng) <= chance / 100 then
			-- Spawn the heart in a random spot
			local pos = Game():GetRoom():FindFreePickupSpawnPosition( Isaac.GetRandomPosition() )
			local heart = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, pos, Vector.Zero, player)
			heart:GetSprite():SetFrame(7)

			-- Effects
			local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 2, heart.Position, Vector.Zero, heart):GetSprite()
			effect.Offset = Vector(0, -8)
			effect.PlaybackSpeed = 1.25
		end

		tryCreatingHeart = false
	end
end
mod:AddTrinketCallback(CustomHealthAPI.Enums.Callbacks.POST_ADD_HEALTH, mod.ITEM.TRINKET.PLUSHIE_GLUTTONY, mod.PlushieGluttonyHeartAdd)