local mod = FiendFolio

local CLOT_TYPE = {
	RED = 0,
	SOUL = 1,
	BLACK = 2,
	ETERNAL = 3,
	GOLD = 4,
	BONE = 5,
	ROTTEN = 6,
	TRINKET = 7,
}

local NUM_TO_DIRECTION = {
    [0] = Vector(0, -1),
    [1] = Vector(1, 0),
    [2] = Vector(0, 1),
    [3] = Vector(-1, 0)
}

local familiarsToTarget = {
    -- normal shooters (just copying tears, nothing special)
    {
        Variant = FamiliarVariant.INCUBUS,
        DamageMultSub = 0.25,
    },
    {
        Variant = FamiliarVariant.TWISTED_BABY,
        DamageMultSub = 0.625,
    },

    -- special shooters (copy tears but also something else)
    {
        Variant = FamiliarVariant.UMBILICAL_BABY,
        DamageMultSub = 0.25,
    },
    {
        Variant = FamiliarVariant.CAINS_OTHER_EYE,
        DamageMultSub = 0.25
    },

    -- sumptorium
    {
        Variant = FamiliarVariant.BLOOD_BABY,
        SubType = CLOT_TYPE.RED,
        DamageMultSub = 0.65,
    },
    {
        Variant = FamiliarVariant.BLOOD_BABY,
        SubType = CLOT_TYPE.SOUL,
        DamageMultSub = 0.65,
    },
    {
        Variant = FamiliarVariant.BLOOD_BABY,
        SubType = CLOT_TYPE.BLACK,
        DamageMultSub = 0.57,
    },
    {
        Variant = FamiliarVariant.BLOOD_BABY,
        SubType = CLOT_TYPE.ETERNAL,
        DamageMultSub = 0.48,
    },
    {
        Variant = FamiliarVariant.BLOOD_BABY,
        SubType = CLOT_TYPE.GOLD,
        DamageMultSub = 0.65,
    },
    {
        Variant = FamiliarVariant.BLOOD_BABY,
        SubType = CLOT_TYPE.BONE,
        DamageMultSub = 0.65,
    },
    {
        Variant = FamiliarVariant.BLOOD_BABY,
        SubType = CLOT_TYPE.ROTTEN,
        DamageMultSub = 0.65,
    },
    {
        Variant = FamiliarVariant.BLOOD_BABY,
        SubType = CLOT_TYPE.TRINKET,
        DamageMultSub = 0.35,
    },
}

local alreadyHooked = {}
for _, familiarData in ipairs(familiarsToTarget) do
    if not alreadyHooked[familiarData.Variant] then
        alreadyHooked[familiarData.Variant] = true
        
        ---@param familiar EntityFamiliar
        mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function (_, familiar)
            if familiarData.SubType and familiar.SubType ~= familiarData.SubType then
                return
            end

            local data = mod:GetEntityData(familiar)

            local player = familiar.Player
            if not player or not mod:IsAnyFriend(player) or player:IsDead() then
                if data.FriendsMultishotGuns then
                    for _, gun in pairs(data.FriendsMultishotGuns) do
                        if gun.Ref and gun.Ref:Exists() then
                            gun.Ref:Remove()
                        end
                    end
                    data.FriendsMultishotGuns = nil
                end
                return
            end

            if familiar:GetWeapon() then
                familiar:GetWeapon():SetCharge(0)
                familiar:GetWeapon():SetFireDelay(999)
            end

            data.FamiliarCopyingFriendsGuns = true

            if not data.FriendsMultishotGuns then
                mod:UpdateMultishotGuns(familiar)
            end

            if familiarData.Variant == FamiliarVariant.UMBILICAL_BABY then
                local closestEnemyDirection, dist
                for _, enemy in ipairs(Isaac.FindInRadius(familiar.Position, player.TearRange, EntityPartition.ENEMY)) do
                    if enemy:IsActiveEnemy() and enemy:IsVulnerableEnemy() then
                        local enemyDistance = enemy.Position:DistanceSquared(familiar.Position)
                        if not dist or enemyDistance < dist then
                            dist = enemyDistance
                            closestEnemyDirection = (enemy.Position - familiar.Position):Normalized()
                        end
                    end
                end

                data.LockGunAim = closestEnemyDirection
            elseif familiarData.Variant == FamiliarVariant.CAINS_OTHER_EYE and not data.LockGunAim then
                data.LockGunAim = Vector(1,0)
            end
        end, familiarData.Variant)
    end
end

local function GetFamiliarGunDamageMultSub(gun)
	local _, parent = mod:GetFriendGunPlayer(gun)
	if parent and parent.Type == EntityType.ENTITY_FAMILIAR then
		for _, data in ipairs(familiarsToTarget) do
			if parent.Variant == data.Variant and (not data.SubType or parent.SubType == data.SubType) then
				return 1 - data.DamageMultSub
			end
		end
	end
end



mod:AddCallback("POST_GUN_FIRE_TEAR", function (_, gun, player, tear)
	local multSub = GetFamiliarGunDamageMultSub(gun)
	if multSub then
		tear.CollisionDamage = tear.CollisionDamage * multSub
	end
end)

mod:AddCallback("POST_GUN_FIRE_LASER", function (_, gun, player, laser)
	local multSub = GetFamiliarGunDamageMultSub(gun)
	if multSub then
		laser:SetDamageMultiplier(laser:GetDamageMultiplier() * multSub)
	end
end)

mod:AddCallback("POST_GUN_FIRE_BOMB", function (_, gun, player, bomb)
	local multSub = GetFamiliarGunDamageMultSub(gun)
	if multSub then
		bomb.ExplosionDamage = bomb.ExplosionDamage * multSub
	end
end)

mod:AddCallback("POST_GUN_FIRE", function (_, gun, player, aim)
	local player, parent = mod:GetFriendGunPlayer(gun)
	if parent and parent.Type == EntityType.ENTITY_FAMILIAR and parent.Variant == FamiliarVariant.CAINS_OTHER_EYE then
		local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_CAINS_OTHER_EYE)
		local newAim = NUM_TO_DIRECTION[rng:RandomInt(4)]
		mod:GetEntityData(parent).LockGunAim = newAim
	end
end)
