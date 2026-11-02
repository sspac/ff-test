local mod = FiendFolio
local game = Game()

function mod:SpawnTearSplit(tear, player, pos, vel, mult)
    local t_data = mod:GetEntityData(tear)
    local haemoDowngrade = t_data.ff_wasHaemoSplitShot
    mult = mult or 1
    local tdamage = math.min(tear.CollisionDamage / player.Damage,1)
    if tear.Type ~= EntityType.ENTITY_TEAR then
        tdamage = 1
    end

	mod.IgnoreSecondaryFireEffects = true
    local nt = player:FireTear(pos, vel, false, true, false, tear, tdamage*mult)
	mod.IgnoreSecondaryFireEffects = false
    nt.Scale = (tear.Scale or nt.Scale)*(mult^0.5)
    nt.Parent = nil
    if haemoDowngrade then
        nt:ClearTearFlags(TearFlags.TEAR_BURSTSPLIT)
        nt:ChangeVariant(tear.Variant) --not using the custom function here because the custom function wont override haemolacria. iirc
        nt.FallingAcceleration = 1.3
        local rng = nt:GetDropRNG()
        local fallSpeed = rng:RandomInt(-12, -4)
        nt.FallingSpeed = fallSpeed
        mod:GetEntityData(nt).ff_wasHaemoSplitShot = true
    end
    return nt
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function (_, tear)
    tear = tear:ToTear()
	if tear:HasTearFlags(TearFlags.TEAR_BURSTSPLIT) then --checking if it's a Haemolacria burst tear
        for _, split in ipairs(Isaac.FindInRadius(tear.Position, 10, EntityPartition.TEAR)) do
			if split.Type == EntityType.ENTITY_TEAR and split.FrameCount == 0 and split.Parent == nil then
				if TearFlagsLib.GetTearPlayer(split) then
                    mod:GetEntityData(split).ff_wasHaemoSplitShot = true
                end
			end
		end
	end
end, EntityType.ENTITY_TEAR)

--Spam-changing this can lead to inconsistent projectile flight distances
function FiendFolio:MultiplyTearFall(tear, index, wantedMult)
    local t_data = mod:GetEntityData(tear)
    t_data.sw_fallMults = t_data.sw_fallMults or {}
    t_data.sw_fallMults[index] = t_data.sw_fallMults[index] or 1

    local lastMult = t_data.sw_fallMults[index]
    --t_data.sw_lastFallSpeed = t_data.sw_lastFallSpeed or 0

    if t_data.sw_lastFallFrame ~= tear.FrameCount then
        t_data.sw_lastFallFrame = tear.FrameCount
        t_data.sw_savedDiff = nil
    end
    t_data.sw_lastFallSpeed = t_data.sw_lastFallSpeed or tear.Height
    local bounce = tear:HasTearFlags(TearFlags.TEAR_HYDROBOUNCE) and t_data.sw_lastFallSpeed > -6

    local diff = tear.Height - t_data.sw_lastFallSpeed
    if tear.FallingSpeed >= 0 and not bounce and (t_data.sw_fakeStoneBounces or 0)< 3/wantedMult then
        if t_data.sw_savedDiff ~= nil then
            diff = t_data.sw_savedDiff
            tear.Height = tear.Height - (t_data.sw_savedDiff*(1-lastMult))
        elseif diff > 0 then
            tear.Height = t_data.sw_lastFallSpeed + diff*lastMult
        end
    elseif bounce then
        t_data.sw_fakeStoneBounces = (t_data.sw_fakeStoneBounces or -1) + 1
        tear.FallingSpeed = math.min(0, (-18+2*t_data.sw_fakeStoneBounces)*1-wantedMult)
    end
    t_data.sw_lastFallSpeed = tear.Height
    t_data.sw_savedDiff = diff*lastMult
    
    t_data.sw_fallMults[index] = wantedMult
    
    return lastMult
end


--optimised i think?
local tearsToUpdate = {}
local tearUpdateRefs = {}
--passes a tear as argument to the func
function FiendFolio:AddToTearUpdateList(index, tear, func)
    if not tearUpdateRefs[index] then
        tearUpdateRefs[index] = func
    end

    tearsToUpdate[index] = tearsToUpdate[index] or {}
    table.insert(tearsToUpdate[index], tear)
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE,  function ()
    local room = game:GetRoom()
    if room:GetFrameCount() == 0 then
        tearsToUpdate = {}
    end

    for index, tears in pairs(tearsToUpdate) do
        for tidx, tear in ipairs(tears) do
            if not tear or not tear:Exists() then
                table.remove(tearsToUpdate[index], tidx)
            else
                tearUpdateRefs[index](mod, tear)
            end
            
        end
    end
end)

function FiendFolio:ClearMovementModifyingTearFlags(tear)
    tear:ClearTearFlags(TearFlags.TEAR_WIGGLE | TearFlags.TEAR_SPIRAL | TearFlags.TEAR_ORBIT| TearFlags.TEAR_SQUARE| TearFlags.TEAR_BIG_SPIRAL|
    TearFlags.TEAR_ORBIT_ADVANCED | TearFlags.TEAR_TURN_HORIZONTAL| TearFlags.TEAR_LUDOVICO)
end

function FiendFolio:ShouldMultiplyTearVelocity(tear)
    local t_data = mod:GetEntityData(tear)
    if tear:HasTearFlags(TearFlags.TEAR_FETUS) then
        return
    end
    local gany = t_data.sw_gany == nil or (t_data.sw_gany.isBomb and not t_data.sw_gany.gp)
    return gany and not t_data.snakeTearData
end

function FiendFolio:MultiplyTearVelocity(tear, index, wantedMult, multTearFall)
    local t_data = mod:GetEntityData(tear)
    t_data.sw_velMults = t_data.sw_velMults or {}
    t_data.sw_velMults[index] = t_data.sw_velMults[index] or 1

    local lastMult = t_data.sw_velMults[index]
    local multiplier = (1 / lastMult) * wantedMult
    if FiendFolio:ShouldMultiplyTearVelocity(tear) then
        tear.Velocity = tear.Velocity * multiplier
        tear.HomingFriction = tear.HomingFriction * multiplier
    end
    t_data.sw_velMults[index] = wantedMult
    if multTearFall then
        mod:MultiplyTearFall(tear, index, wantedMult)
    end
    return lastMult
end

function FiendFolio:SmoothOrbitVec(tear, oPos, oDis, speed)
    local dis = tear.Position - oPos
    local ang = mod:GetAngleDegreesButGood(dis) local len = dis:Length()
    len = mod:Lerp(len, oDis--[[tear.Size+10]], 0.1)

    ang = ang + speed 

    local orbVec = Vector.FromAngle(ang)*len
    return orbVec
end


local staticArray = {
	0.3,
	0.55,
	0.675,
	0.8,
	0.925,
	1.05,
	1.175,
	1.425,
	1.675,
	1.925,
	2.175,
	2.55,
}
local animArray = {
	0.675,
	0.925,
	1.175,
	1.675,
	2.175
}
function mod:GetTearAnimSuffix(tear, animated)
	local scale = type(tear) == "number" and tear or tear.Scale
	local array = animated and animArray or staticArray
	for index, scalar in ipairs(array) do
		if scale <= scalar then
			return "Tear"..index, scalar, index
		end
	end
	return "Tear"..#array+1, array[#array], #array
end

function mod:SetEasyTearTrail(tear)
    local t_data = mod:GetEntityData(tear) 
    local init = false
    if not t_data.sw_tearTrail then
        init = true
        local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPRITE_TRAIL, 0, tear.Position + tear.PositionOffset, Vector.Zero, tear):ToEffect()
        trail.MinRadius = 0.2
        trail:FollowParent(tear)
        trail.ParentOffset = tear.PositionOffset
        t_data.sw_tearTrail = trail
    end
    t_data.sw_tearTrail.ParentOffset = tear.PositionOffset
    return t_data.sw_tearTrail, init
end

--todo, look at model rocket and put that in here too
function mod:GetAllMultipliedTearVelocity(tear)
    local t_data = mod:GetEntityData(tear)
    local mult = 1
    if t_data.sw_velMults ~= nil then
        for key, value in pairs(t_data.sw_velMults) do
            mult = mult * value
        end
    end
    return mult
end

--these are sort of genericly named functions for things that arent so generic so im add my less generic name to hopefully avoid future conflicts

function mod:BeahGetOrbitalPositionInLayer(fcheck, player)
    local posInLayer local totalLayerSize = 0 local shouldReset = false
    for _, familiar in ipairs(Isaac.FindByType(3)) do
        familiar = familiar:ToFamiliar()
        if ((familiar.Parent and GetPtrHash(familiar.Parent) == GetPtrHash(player)) or GetPtrHash(familiar.Player) == GetPtrHash(player)) and familiar.OrbitLayer == fcheck.OrbitLayer then
            totalLayerSize = totalLayerSize + 1
            if GetPtrHash(familiar) == GetPtrHash(fcheck) then
                posInLayer = totalLayerSize
            end
            if familiar.FrameCount <= 1 or (familiar:HasEntityFlags(EntityFlag.FLAG_APPEAR) and familiar.FrameCount <= 6) then
                shouldReset = true
            end
        end
    end
    return posInLayer, totalLayerSize, shouldReset
end

--its really annoying and inconsistent in vanilla so this is good enough imo
function mod:GetOrbitalSpeedMult(player)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_GUARDIAN_ANGEL) then
        return 2
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BIG_FAN) then
        return 0.33
    end
    return 1
end

--allows orbitals that change speed on the fly without effing things up. also allows custom familiar orbit intervals
function mod:BeahDynamicOrbit(familiar, parent, speed, distance, manualAngle, overridePos)
    local layerPos, size, shouldReset = mod:BeahGetOrbitalPositionInLayer(familiar, parent)
    local f_data = mod:GetEntityData(familiar)
    
    speed = speed * mod:GetOrbitalSpeedMult(parent)
    if shouldReset then
        f_data.somethingWicked__dynamicOrbitPos = 0 + speed
    else
        f_data.somethingWicked__dynamicOrbitPos = (f_data.somethingWicked__dynamicOrbitPos or 0) + speed
    end
    local v = overridePos or parent.Position
    if manualAngle ~= nil then
        v = v + distance * Vector.FromAngle(manualAngle)
    else
        v = v + distance * Vector.FromAngle(f_data.somethingWicked__dynamicOrbitPos + ((layerPos / size) * 360))
    end
    return v, shouldReset
end

--this function exists to prevent some minor visual bugs when you enter a new room with some dynamic orbit familiars. it really might suck though now that i think about it
function mod:SetFamiliarOrbitPosWOVisualBugs(familiar, pos, vel)
    if game:GetRoom():GetFrameCount() == 0 then
        familiar.Velocity = Vector.Zero
        familiar.Position = pos
    else
        familiar.Velocity = vel
    end
end

function mod:AllPlayersWithCollectible(type)
    local t = {}
    for index, value in ipairs(mod:GetAllPlayers()) do
        if value:HasCollectible(type) then
            table.insert(t, value)
        end
    end
    return t
end

function mod:ChargeFirstActive(player, chargeToAdd, skipBatteryCheck, chargeAllActually, func)
    func = func or function ()
        return true
    end
    chargeToAdd = chargeToAdd or 1

    for i = 0, 3, 1 do
        --print("Ah")
        local currentItem = player:GetActiveItem(i)
        if currentItem ~= 0 and player:NeedsCharge(i) then
            local maxCharge = Isaac.GetItemConfig():GetCollectible(currentItem).MaxCharges
            local charge = player:GetActiveCharge(i) + player:GetBatteryCharge(i)

            local overCharge = player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY) or skipBatteryCheck
            local newMaxCharge = maxCharge * (overCharge and 2 or 1)
            if charge < newMaxCharge
            and func(player, currentItem, charge) then
                player:AddActiveCharge(chargeToAdd, i, true, overCharge)
                
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BATTERY, 0, player.Position - Vector(0, 60), Vector.Zero, player)
                sfx:Play(SoundEffect.SOUND_BEEP)
                if not chargeAllActually then
                    goto outofloop
                end
            end
        end
    end
    ::outofloop::
end

function mod:ChargeFirstActiveOfType(player, collectible, chargeToAdd, skipBatteryCheck, chargeAllActually, func)
    return mod:ChargeFirstActive(player, chargeToAdd, skipBatteryCheck, chargeAllActually, function (_, item)
        func = func or function ()
            
        end
        return func() and collectible == item
    end)
end

function mod:Current45VoltCharge()
    local level = game:GetLevel()
    return 40 + 20*level:GetAbsoluteStage()
end

function mod:beahAddInnate(player, id, amount)
    amount = amount or 1

    if amount < 0 then
        player:RemoveInnateCollectible(id, -amount, "FF_BEAH_INNATES")
    else
        player:AddInnateCollectible(id, amount, "FF_BEAH_INNATES")
    end
end

function FiendFolio:GetCollectibleWithArgs(args, poolType, removeFromPool)
    local pool = game:GetItemPool()
    local itemConfig = Isaac.GetItemConfig()
    if removeFromPool == nil then
        removeFromPool = false
    end
    if poolType == nil then
        local room = game:GetRoom()
        poolType = pool:GetPoolForRoom(room:GetType(), room:GetAwardSeed())
        if poolType == -1 then poolType = ItemPoolType.POOL_TREASURE end
    end
    

    for i = 1, 1000, 1 do
        local newCollectible = pool:GetCollectible(poolType, removeFromPool)
        local conf = itemConfig:GetCollectible(newCollectible)
        if args(conf, newCollectible) then
            return newCollectible
        end
    end
    return 1
end

function mod:FindNearestVulnerableEnemy(pos, dis, blacklist)
    dis = dis or 80000
    local enemies = Isaac.FindInRadius(pos, dis, EntityPartition.ENEMY)
    local distance = 80009 local enemy = nil

    for index, value in ipairs(enemies) do
        local newDist = value.Position:Distance(pos)
        if value:IsVulnerableEnemy() and not value:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and  newDist < distance
        and (blacklist == nil or not blacklist[""..value.InitSeed]) then
            distance = newDist
            enemy = value
        end
    end

    return enemy
end

function mod:GetFamiliarPureFireScalar(familiar, player)
    if familiar.Type == 1 then
        return 1
    end

    local playertype = player:GetPlayerType()
    local variant = familiar.Variant
    if variant == FamiliarVariant.INCUBUS
    or variant == FamiliarVariant.UMBILICAL_BABY then
        return (playertype == PlayerType.PLAYER_LILITH or playertype == PlayerType.PLAYER_LILITH_B) and 1 or 0.75
    end
    --[[elseif familiar.Variant == FamiliarVariant.SOMETHINGWICKED_LEGION
    or familiar.Variant == FamiliarVariant.SOMETHINGWICKED_LEGION_B then
        return 0.175
    end]]
    return 0.35
end

function mod:TEARFLAG(x)
    return x >= 64 and BitSet128(0,1<<(x-64)) or BitSet128(1<<x,0)
end

local function edgeUpdate(_,tear)
    local t_data = mod:GetEntityData(tear)
	if t_data.sw_edgingOffset then
		t_data.sw_edgingOffset = mod:Lerp(Vector.Zero, t_data.sw_edgingOffset, 0.85)
	end
end
function mod:SmoothTearPositionOffset(tear, nt)
    local easeEdge = tear.PositionOffset-nt.PositionOffset
    mod:GetEntityData(nt).sw_edgingOffset = easeEdge
    mod:AddToTearUpdateList("ff_offsetSmooth", nt, edgeUpdate)
end

--spawns one of my custom poofs, since they all use the same type and variant
function mod:beahPoof(pos, type, color)
    if color == nil then
        color = Color(1,1,1)
    end
    local p = Isaac.Spawn(FiendFolio.FF.GlitchPoof.ID, FiendFolio.FF.GlitchPoof.Var, type, pos, Vector.Zero, nil)
    p.Color = color
    return p:ToEffect()
end

function mod:CanPickupPickupGeneric(heart, player)
    if (not heart:IsShopItem() or (heart.Price > player:GetNumCoins() and player:IsExtraAnimationFinished()))
    then
        return true
    end
    return false
end