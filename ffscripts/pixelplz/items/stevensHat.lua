local mod = FiendFolio

local Settings = {
	BaseChance = 40,
	ExtraChance = 20,

	Costumes = {
		"Deputy",
		"Mobster",
		"Dunce",
		"Soldier",
		"Badass",
		"Doctor",
		"Goon",
	},

	Cooldown = 48,
	ShotSpeed = 10,
	Damage = 3.5,
}



-- Check if a pickup or slot machine should get a Steven costume
function mod:ShouldNonEnemyGetStevenHat()
	local room = Game():GetRoom()
	return not room:IsClear() or room:IsAmbushActive() or Isaac.CountEnemies() > 0
end

-- Give a Steven costume to an entity
function mod:AddStevenHat(entity)
	local data = mod:GetEntityData(entity)

	-- Create the gunslinger tracker if it doesn't exist
	if not data.GunslingerData then
		data.GunslingerData = {}
	end

	-- Add the Steven costume
	local rng = RNG(entity.InitSeed)

	data.GunslingerData.Costume = {
		Sprite = Sprite("gfx/enemies/steven_hats.anm2", true),
		Animation = mod:RandomIndex(Settings.Costumes, rng),
		LastUpdateFrame = -1,
		IsSteven = true,
		StevenCooldown = mod:Random(math.floor(Settings.Cooldown / 2), Settings.Cooldown, rng),
	}
end



-- Give Steven costumes to pickups in uncleared rooms
function mod:StevenHatPickupInit(pickup)
	local func = function()
		if not mod.StevensHatBlacklist.Pickups[pickup.Variant] and mod:ShouldNonEnemyGetStevenHat()
		and not pickup:IsShopItem() and pickup.Timeout <= -1 then
			mod:AddStevenHat(pickup)
		end
	end
	mod.scheduleForUpdate(func, 0, ModCallbacks.MC_POST_UPDATE, true)
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.ITEM.COLLECTIBLE.STEVENS_HAT, mod.StevenHatPickupInit)
mod:AddPriorityCollectibleCallback(ModCallbacks.MC_PRE_PICKUP_RENDER, CallbackPriority.EARLY * 1000, mod.ITEM.COLLECTIBLE.STEVENS_HAT, mod.RenderGunslingerCostume)

-- Give Steven costumes to slots in uncleared rooms
function mod:StevenHatSlotInit(slot)
	local func = function()
		if not mod.StevensHatBlacklist.Slots[slot.Variant] and mod:ShouldNonEnemyGetStevenHat() then
			mod:AddStevenHat(slot)
		end
	end
	mod.scheduleForUpdate(func, 0, ModCallbacks.MC_POST_UPDATE, true)
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_SLOT_INIT, mod.ITEM.COLLECTIBLE.STEVENS_HAT, mod.StevenHatSlotInit)
mod:AddPriorityCollectibleCallback(ModCallbacks.MC_PRE_SLOT_RENDER, CallbackPriority.EARLY * 1000, mod.ITEM.COLLECTIBLE.STEVENS_HAT, mod.RenderGunslingerCostume)

-- Have a chance to give Steven costumes to enemies when they spawn
function mod:StevenHatEnemyInit(entity)
	local func = function()
		if mod:IsValidBountyEnemy(entity) then
			local rng = RNG(entity.InitSeed)
			local extraCopies = PlayerManager.GetNumCollectibles(mod.ITEM.COLLECTIBLE.STEVENS_HAT) - 1
			local chance = Settings.BaseChance + (extraCopies * Settings.ExtraChance)

			if entity:IsBoss() or mod:Random(nil, nil, rng) <= (chance / 100) then
				mod:AddStevenHat(entity)
			end
		end
	end
	mod.scheduleForUpdate(func, 0, ModCallbacks.MC_POST_UPDATE, true)
end
mod:AddPriorityCollectibleCallback(ModCallbacks.MC_POST_NPC_INIT, CallbackPriority.EARLY, mod.ITEM.COLLECTIBLE.STEVENS_HAT, mod.StevenHatEnemyInit)



-- Get the target for Steven costumes
local function getValidTarget(entity)
	local enemies = Isaac.FindInRadius(mod:GetRoomCenter(), 9999, EntityPartition.ENEMY)
	local nearest
	local nearestDistance = 9999

	for i, enemy in ipairs(enemies) do
		if (not entity or enemy.Index ~= entity.Index)
		and enemy:ToNPC() and enemy:IsActiveEnemy(false)
		and enemy:IsVulnerableEnemy() and not enemy:HasEntityFlags(EntityFlag.FLAG_NO_TARGET)
		and not mod:isFriend(enemy) then
			local distance = enemy.Position:Distance(entity.Position)

			-- Get the nearest one
			if distance < nearestDistance then
				nearest = enemy
				nearestDistance = distance
			end
		end
	end

	return nearest
end

-- Handle the shooting for Steven costumes
function mod:StevenHatUpdate(entity, costume)
	if costume.IsSteven then
		local sprite = costume.Sprite

		-- Idle face
		if not sprite:IsOverlayPlaying("FaceShoot") then
			mod:LoopingOverlay(sprite, "FaceIdle")
		end


		-- Shoot if not on cooldown and there are valid targets
		costume.StevenCooldown = math.max(costume.StevenCooldown - 1, 0)

		if costume.StevenCooldown <= 0 and getValidTarget(entity) then
			sprite:PlayOverlay("FaceShoot", true)
			costume.StevenCooldown = Settings.Cooldown
		end


		-- Shoot if possible
		if sprite:IsOverlayPlaying("FaceShoot") and sprite:IsOverlayEventTriggered("Shoot") then
			local target = getValidTarget(entity)

			if target then
				local face = sprite:GetLayer("face")

				-- Get the position to shoot from
				local spriteOffset = sprite.Offset / 0.65
				local faceOffset = face:GetPos():Rotated( face:GetRotation() )
				local flipMulti = Vector(-mod:GetSign(sprite.FlipX), -mod:GetSign(sprite.FlipY))
				local hatOffset = (sprite.Scale * faceOffset / 0.65):Rotated(sprite.Rotation) * flipMulti
				local tearOffset = Vector(0, 22)
				local shootPos = entity.Position + entity.PositionOffset + spriteOffset + hatOffset + tearOffset

				local velocity = (target.Position - shootPos):Resized(Settings.ShotSpeed)
				local spawner = PlayerManager.GetRandomCollectibleOwner(mod.ITEM.COLLECTIBLE.STEVENS_HAT, entity.InitSeed) or Isaac.GetPlayer()
				local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, FiendFolio.TEAR.MULTI_EUCLIDEAN, 0, shootPos, velocity, spawner):ToTear()

				local data = mod:GetEntityData(tear)
				data.stevenHatTear = true
				data.stevenHatTearOrigin = entity

				-- Set its damage
				local boxCount = spawner:GetTrinketMultiplier(mod.ITEM.TRINKET.STEVENS_BOX)
				local damageMulti = 1 + boxCount
				tear.CollisionDamage = Settings.Damage * damageMulti

				-- Set its size
				tear.Scale = face:GetSize().Y
				tear:ResetSpriteScale()

				-- Make it not fall down
				tear.FallingSpeed = -0.1
				tear.FallingAcceleration = -0.05
				TearFlagsLib.AddTearFlags(tear, mod.FriendBulletFlags.NO_FALL_TEAR)

				-- Make it homing and spectral
				tear:AddTearFlags(TearFlags.TEAR_HOMING)
				tear.Target = target
				tear.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
			end
		end
	end
end



-- Make the tears ignore collision with the hat's owner
-- (unless if they are specifically targeted by them)
function mod:StevenHatTearCollision(tear, target, bool)
	local origin = mod:GetEntityData(tear).stevenHatTearOrigin

	if origin and target.Index == origin.Index
	and (not tear.Target or tear.Target.Index ~= origin.Index) then
		return true
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, mod.StevenHatTearCollision, FiendFolio.TEAR.MULTI_EUCLIDEAN)