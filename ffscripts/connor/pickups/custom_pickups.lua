-- NOTE: Unused. Most of this was ported to CHAPI

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local CUSTOM_PICKUPS = {}

function mod:getCustomPickupInfo(variant, subtype)
	if CUSTOM_PICKUPS[variant] then
		return CUSTOM_PICKUPS[variant][subtype or 0] or CUSTOM_PICKUPS[variant][0]
	end
end

--[[ Supported stuff (all technically optional):
{
	OnDrop = function(pickup)
		-- Called when the pickup hits the floor after spawning.
		-- Good for playing the drop sound effect.
	end,
	OnAnyPickup = function(entity, pickup)
		-- Called when any entity collects the pickup.
		-- Good for playing sounds or effects when collects, but don't put player-specific code here.
	end,
	CanPlayerPickup = function(player, pickup)
		-- Return true if a player can collect this pickup, false if not.
	end,
	OnPlayerPickup = function(player, pickup)
		-- Gets called when a player collects the pickup.
		-- Return true to allow the game's internal collision code to run. You probably don't want to do that.
	end,
	OnFamiliarPickup = function(fam, pickup)
		-- Gets called if a familiar collects the pickup.
		-- Currently only supports custom coins & stuff like Bum Friend/Bumbo.
		-- Return true to allow the game's internal collision code to run. You probably don't want to do that.
	end,
	OnEnemyPickup = function(npc, pickup)
		-- Gets called if an enemy collects the pickup.
		-- Currently only supports Bumbino / Ultra Greed collecting a custom coin.
		-- Return true to allow the game's internal collision code to run. In this case maybe you do want to do that?
	end,
}
]]
function mod:addCustomPickup(variant, subtype, info)
	if not CUSTOM_PICKUPS[variant] then
		CUSTOM_PICKUPS[variant] = {}
		
		mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.customPickupUpdate, variant)
		mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.customPickupCollision, variant)
	end
	
	CUSTOM_PICKUPS[variant][subtype] = info
end

function mod:customPickupUpdate(pickup)
	local sprite = pickup:GetSprite()
	
	if sprite:IsFinished("Collect") then
		pickup:Remove()
	elseif sprite:IsPlaying("Collect") then
		pickup.Velocity = Vector.Zero
	elseif sprite:IsEventTriggered("DropSound") then
		local info = mod:getCustomPickupInfo(pickup.Variant, pickup.SubType)
		if info and info.OnDrop then
			info.OnDrop(pickup)
		end
	end
end

local function canBePickedUpByPlayer(player, pickup)
	local info = mod:getCustomPickupInfo(pickup.Variant, pickup.SubType)
	if info and info.CanPlayerPickup then
		return info.CanPlayerPickup(player, pickup)
	end
	return true
end

local function canBePickedUpByFamiliar(familiar, pickup)
	if pickup.Variant == PickupVariant.PICKUP_COIN then
		return familiar.Variant == FamiliarVariant.BUM_FRIEND
			or familiar.Variant == FamiliarVariant.BUMBO
			or familiar.Variant == FamiliarVariant.SUPER_BUM
	end
	return false
end

local function canBePickedUpByEnemy(npc, pickup)
	if pickup.Variant == PickupVariant.PICKUP_COIN then
		return npc.Type == EntityType.ENTITY_ULTRA_GREED or npc.Type == EntityType.ENTITY_BUMBINO
	end
	return false
end

local function canPickup(entity, pickup)
	if entity:ToPlayer() then
		return canBePickedUpByPlayer(entity:ToPlayer(), pickup)
	elseif entity:ToFamiliar() then
		return canBePickedUpByFamiliar(entity:ToFamiliar(), pickup)
	elseif entity:ToNPC() then
		return canBePickedUpByEnemy(entity:ToNPC(), pickup)
	end
	return false
end

function mod:customPickupCollision(pickup, collider)
	local info = mod:getCustomPickupInfo(pickup.Variant, pickup.SubType)
	
	if not info then
		return
	end
	
	local sprite = pickup:GetSprite()
	
	if sprite:GetAnimation() == "Collect" then
		return true
	end
	
	local player = collider:ToPlayer()
	local familiar = collider:ToFamiliar()
	local npc = collider:ToNPC()
	
	if not canPickup(collider, pickup) then
		if player then
			return pickup:IsShopItem()
		end
		return
	end
	
	if pickup:IsShopItem() then
		if not player then
			return
		elseif pickup.Price == PickupPrice.PRICE_SPIKES then
			local tookDamage = player:TakeDamage(2, DamageFlag.DAMAGE_SPIKES | DamageFlag.DAMAGE_NO_PENALTIES, EntityRef(nil), 30)
			if not tookDamage then
				return true
			end
		elseif pickup.Price > player:GetNumCoins() then
			return true
		elseif pickup.Price > 0 then
			player:AddCoins(-1 * pickup.Price)
		end
		pickup.Price = 0
	end
	
	local allowInternalCode = false
	
	if info.OnAnyPickup then
		info.OnAnyPickup(collider, pickup)
	end
	
	if player and info.OnPlayerPickup then
		allowInternalCode = info.OnPlayerPickup(player, pickup)
	elseif familiar and info.OnFamiliarPickup then
		allowInternalCode = info.OnFamiliarPickup(familiar, pickup)
	elseif npc and info.OnEnemyPickup then
		allowInternalCode = info.OnEnemyPickup(npc, pickup)
	end
	
	sprite:Play("Collect", true)
	pickup.Touched = true
	pickup.Velocity = mod.nilvector
	pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	pickup:Die()
	
	if not allowInternalCode then
		return true
	end
end
