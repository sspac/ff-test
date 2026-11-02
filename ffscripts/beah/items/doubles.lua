local mod = FiendFolio

local function postFire(_, vector, amount, owner)
    local p = owner:ToPlayer()

    if p == nil then
        local f = owner:ToFamiliar()
        if f and f.Player then
            p = f.Player
        else
            return
        end
    end

    local p_data = mod:GetEntityData(p)
    --[[local weapon = p:GetWeapon(1)
    if owner.Type ~= EntityType.ENTITY_PLAYER then
        local familiar = owner:ToFamiliar()
        if familiar then
            weapon = familiar:GetWeapon()
        end
    end

    if p_data.sw_doublesBonus then
        local mult = (1-(math.log(p_data.sw_doublesBonus, 10)))/0.89
        weapon:SetFireDelay((weapon:GetFireDelay()/mult)*0.456)
    end]]
    p_data.sw_resetVolley = true
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_TRIGGER_WEAPON_FIRED, mod.ITEM.COLLECTIBLE.DOUBLES, postFire)

mod:AddCollectibleCallback("POST_PRIMARY_GUN_FIRE", mod.ITEM.COLLECTIBLE.DOUBLES, function (_, _, player)
    postFire(_, _, _, player)
end)

function mod.doubklespEffectUpdate(_, player)
    local p_data = mod:GetEntityData(player)
    if p_data.sw_resetVolley == true then
        p_data.sw_resetVolley = nil
        if p_data.sw_doublesBonus then
            p_data.sw_doublesBonus = nil
        end
        if player:HasCollectible(mod.ITEM.COLLECTIBLE.DOUBLES) then
            local c_rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.DOUBLES)
            p_data.sw_doublesBonus = c_rng:RandomInt(1,6)
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.DOUBLES, mod.doubklespEffectUpdate)

local cantChangeAngle = {
    WeaponType.WEAPON_LUDOVICO_TECHNIQUE,
    WeaponType.WEAPON_UMBILICAL_WHIP,
}
local blacklist = {
    WeaponType.WEAPON_URN_OF_SOULS,
    WeaponType.WEAPON_NOTCHED_AXE
}
local function getVolleySize(_, player, params, weaponType)
    local p_data = mod:GetEntityData(player)

    local tears = (p_data.sw_doublesBonus or 1)-1
    if tears > 0 then
        params:SetNumTears(params:GetNumTears()+tears)
        params:SetNumLanesPerEye(params:GetNumLanesPerEye()+tears)
        if tears >= 2 then
            local a = tears
            if weaponType == WeaponType.WEAPON_BONE then
                a=a*5
            end
            if not mod:Contains(cantChangeAngle, weaponType) then
                params:SetSpreadAngle(weaponType, a*2)
            end
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_MULTI_SHOT_PARAMS, mod.ITEM.COLLECTIBLE.DOUBLES, getVolleySize)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.DOUBLES] = {
	FireCooldown = 50,
	BodyColor = Color(1,1,1,1,-83.496/255,-83.496/255,-83.496/255,1.327,1.327,1.327,1),
	EyeAColor = Color(1,1,1,1,-79.044/255,-65.460/255,-80.787/255,0.726,0.947,0.717,1),
	EyeBColor = Color(1,1,1,1,-42.805/255,-39.628/255,-33.327/255,0.407,0.504,0.770,1)}

local multishotInfo = {
	[2] = {{PosOffset = Vector(0,-8), VelRot = 0},
	       {PosOffset = Vector(0,8), VelRot = 0}},
	[3] = {{PosOffset = Vector(-0.024,-8.698), VelRot = -4},
	       {PosOffset = Vector(11.5,0), VelRot = 0},
	       {PosOffset = Vector(-0.024,8.698), VelRot = 4}},
	[4] = {{PosOffset = Vector(-0.054,-9.046), VelRot = -6},
	       {PosOffset = Vector(9.954,-4.354), VelRot = -2},
	       {PosOffset = Vector(9.954,4.354), VelRot = 2},
	       {PosOffset = Vector(-0.054,9.046), VelRot = 6}},
	[5] = {{PosOffset = Vector(-0.097,-9.392), VelRot = -8},
	       {PosOffset = Vector(8.108,-6.355), VelRot = -4},
	       {PosOffset = Vector(11.5,0), VelRot = 0},
	       {PosOffset = Vector(8.108,6.355), VelRot = 4},
	       {PosOffset = Vector(-0.097,9.392), VelRot = 8}},
	[6] = {{PosOffset = Vector(-0.151,-9.737), VelRot = -10},
	       {PosOffset = Vector(6.705,-7.518), VelRot = -6},
	       {PosOffset = Vector(10.931,-2.821), VelRot = -2},
	       {PosOffset = Vector(10.931,2.821), VelRot = 2},
	       {PosOffset = Vector(6.705,7.518), VelRot = 6},
	       {PosOffset = Vector(-0.151,9.737), VelRot = 10}},
}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	local rng = familiar.Player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.DOUBLES)
	local numTears = rng:RandomInt(1,6)
	if numTears > 1 then
		local player = familiar.Player
		local origAng = tear.Velocity:GetAngleDegrees()
		local infoForMultishot = multishotInfo[numTears]

		tear.Position = tear.Position + infoForMultishot[1].PosOffset:Rotated(origAng)
		tear.Velocity = tear.Velocity:Rotated(infoForMultishot[1].VelRot)

		for i = 2, numTears, 1 do
			local velocity = mod.GetFamiliarShootingDirection(familiar):Resized(10)
			velocity = velocity + player:GetTearMovementInheritance(velocity)

			local position = familiar.Position + infoForMultishot[i].PosOffset:Rotated(origAng)
			local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, 0, position, velocity:Rotated(infoForMultishot[i].VelRot), familiar):ToTear()

			tear.Height = -23.75
			tear.FallingSpeed = 0.1 + math.random() * 0.2
			tear.FallingAcceleration = 0.0

			tear.CollisionDamage = 3.5
			tear.Scale = 0.8
			if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
				tear.CollisionDamage = tear.CollisionDamage * 2
				tear.Scale = 1.0
			end
			if Sewn_API then
				if Sewn_API:IsUltra(data) then
					tear.CollisionDamage = tear.CollisionDamage * 1.5
					tear.Scale = tear.Scale * 1.1
				elseif Sewn_API:IsSuper(data) then
					tear.CollisionDamage = tear.CollisionDamage * 1.25
					tear.Scale = tear.Scale * 1.05
				end
			end
			tear:ResetSpriteScale()

			if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
				tear:AddTearFlags(TearFlags.TEAR_HOMING)
				local tearcolor = Color(0.4, 0.15, 0.38, 1, 55/255, 5/255, 95/255)
				tear.Color = tearcolor
			end

			if mod:isSuperpositionedPlayer(familiar.Player) then
				local tearcolor = Color.Lerp(tear.Color, Color(1,1,1,1,0,0,0), 0)
				tearcolor.A = tearcolor.A / 4
				tear.Color = tearcolor
				tear.CollisionDamage = tear.CollisionDamage/4
			end

			tear:Update()
		end
	end
end, FiendFolio.ITEM.COLLECTIBLE.DOUBLES)
