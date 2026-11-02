local mod = FiendFolio 
local sfx = SFXManager()
local flag = TearFlagsLib.RegisterTearFlag("EYE_OF_PROVIDENCE")
TearFlagsLib.RegisterWeapon("FF_PROVIDENCE_LASER")
TearFlagsLib.RegisterWeaponIdentityFunction(TearFlagsLib.WeaponFlag.FF_PROVIDENCE_LASER, function(entity)
    return TearFlagsLib.GetSafeData(entity).dummyWeaponIdentity == TearFlagsLib.WeaponFlag.FF_PROVIDENCE_LASER
end)

mod.CAN_OF_BEANS.FART_PER_ENEMY = mod.CAN_OF_BEANS.FART_PER_ENEMY | TearFlagsLib.WeaponFlag.FF_PROVIDENCE_LASER
mod.CAN_OF_BEANS.USE_ENEMY_SPECIFIC_DAMAGE = mod.CAN_OF_BEANS.USE_ENEMY_SPECIFIC_DAMAGE | TearFlagsLib.WeaponFlag.FF_PROVIDENCE_LASER
mod.CAN_OF_BEANS.FART_FROM_ENEMY_POS = mod.CAN_OF_BEANS.FART_FROM_ENEMY_POS | TearFlagsLib.WeaponFlag.FF_PROVIDENCE_LASER

local aVariance, LengthPer = 18, Vector(6, 0)
local bhelper = nil
local visDuration = 10
local dmgmult = 0.3
local origindmgmult = 0.1
local function hitEnemy(_, entity, player, source, weaponFlag, params)
	local origin = TearFlagsLib.GetTearFlagParams(source, flag).Origin or player
    local capsule = Capsule(entity.Position, origin.Position, 80)
    local raw_e = Isaac.FindInCapsule(capsule, EntityPartition.ENEMY)

    --wells fargo naruto coat guy gif
    local bones = {}
    local e = {}
    table.insert(e, {e = source, d = 0})
    for i = 1, #raw_e, 1 do
        local ent = raw_e[i]
        if ent:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) then
            goto continue
        end
        local dis = ent.Position:Distance(source.Position)
        for j = 1, #e + 1, 1 do
            local entry = e[j]
            if entry == nil or dis < entry.d then
                table.insert(e, j, { e = ent, d = dis})
                goto continue
            end
        end
        ::continue::
    end
    table.insert(e, { e = origin })
    local scale = source:ToTear() and source:ToTear().Scale or 1
	if source.Type == EntityType.ENTITY_FAMILIAR and source.Variant == mod.ITEM.FAMILIAR.PLANET_X then
		scale = mod:GetEntityData(source).Scale or scale
	end
    local poof = Isaac.Spawn(mod.FF.FocusCrystalPoof.ID, mod.FF.FocusCrystalPoof.Var, mod.FF.FocusCrystalPoof.Sub, source.Position+source.PositionOffset, Vector.Zero, ent):ToEffect()
    poof.Color = Color(1,1,1,1,0,1)
    poof.SpriteScale = Vector(scale, scale)
    local poof = Isaac.Spawn(mod.FF.FocusCrystalPoof.ID, mod.FF.FocusCrystalPoof.Var, mod.FF.FocusCrystalPoof.Sub, origin.Position+source.PositionOffset, Vector.Zero, ent):ToEffect()
    poof.Color = Color(1,1,1,1,0,1)
    poof.SpriteScale = Vector(scale, scale)

    local o_dmg = source.CollisionDamage--player.Damage
    if entity.Type == EntityType.ENTITY_BOMB then
        o_dmg = source:ToBomb().ExplosionDamage
    elseif o_dmg == 0 then
        o_dmg = player.Damage
    end

    local laserDummy = TearFlagsLib.SpawnDummyEntity(player, TearFlagsLib.WeaponFlag.FF_PROVIDENCE_LASER)
    TearFlagsLib.CopyTearFlags(laserDummy, source, TearFlagsLib.WeaponFlag.FF_PROVIDENCE_LASER)
    TearFlagsLib.ClearTearFlags(laserDummy, TearFlagsLib.Flag.EYE_OF_PROVIDENCE, true)
    TearFlagsLib.SetCustomVanillaTearFlagParams(laserDummy, {ColorOverride = source.Color})

    for index, value in ipairs(e) do
        local ent = value.e
        if index ~= #e and index ~= 1 then
            local dmg = o_dmg*dmgmult
            if GetPtrHash(entity) == GetPtrHash(ent) then
                dmg = o_dmg*origindmgmult
            end

            -- ent:TakeDamage(dmg, 0, EntityRef(source), 0)
			TearFlagsLib.SetCustomVanillaTearFlagParams(laserDummy, {DamageOverride = dmg})
			mod.EyeOfProvLaser = laserDummy
            TearFlagsLib.DamageEntity(ent, dmg, 0, laserDummy, {DamageSource = source})
            laserDummy.Position = ent.Position
            TearFlagsLib.ApplyWeaponTearFlags(ent, player, laserDummy, TearFlagsLib.WeaponFlag.FF_PROVIDENCE_LASER, true)
			mod.EyeOfProvLaser = nil
        end

        local safetyInt = 60
            local nbone = ent.Position
            if index > 2 then
                local lastBone = bones[#bones]
                local ta = nbone - lastBone
                local oa = lastBone - bones[#bones-1]

                local adiff = mod:GetAngleDifferenceDead(oa, ta)
                while math.abs(adiff) >= math.abs(1) and safetyInt > 0 do
                    local rotate = mod:ClampNumber(-adiff, -aVariance, aVariance)
                    local mbone = lastBone + (LengthPer:Rotated(mod:GetAngleDegreesButGood(oa:Rotated(rotate))))
                    table.insert(bones, mbone)

                    lastBone = bones[#bones]
                    oa = lastBone - bones[#bones-1]
                    ta = nbone - lastBone
                    adiff = mod:GetAngleDifferenceDead(oa, ta)
                    safetyInt = safetyInt - 1
                end
            end
            table.insert(bones, nbone)
    end

    if bhelper == nil or not bhelper:Exists() then
        bhelper = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.FF.BeahInvisible.Var, 2, Vector.Zero, Vector.Zero, nil)
        bhelper.DepthOffset = -9999
    end

    local b_data = mod:GetEntityData(bhelper)
    b_data.bones = b_data.bones or {}
    table.insert(b_data.bones, {d = visDuration, b = bones, os = source.PositionOffset, sc = scale})
    sfx:Play(mod.Sounds.FocusCrystal, 1.2, 0)
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, hitEnemy, flag)

local function tearFlagCheck(_, entity, player, wflag)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.EYE_OF_PROVIDENCE) then
        TearFlagsLib.AddTearFlags(entity, flag)
    end
end

mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, mod.ITEM.COLLECTIBLE.EYE_OF_PROVIDENCE, tearFlagCheck)

mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_CHANCELESS_TEARFLAGS, mod.ITEM.COLLECTIBLE.EYE_OF_PROVIDENCE, function(_, entity, player, weaponFlag)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.EYE_OF_PROVIDENCE) then
        TearFlagsLib.AddTearFlags(entity, flag)
    end
end)

local beamSprite = Sprite()
beamSprite:Load("gfx/effect_providence_beam.anm2", true)
beamSprite:Play("Idle", false)

local beamLayer = beamSprite:GetLayer("beam")
beamLayer:SetWrapSMode(1)
beamLayer:SetWrapTMode(0)
local snapBeam = Beam(beamSprite, "beam", false, false)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function (_, effect)
    if effect.SubType == 2 then
        local bones = mod:GetEntityData(effect).bones
        if bones then
            for _, value in pairs(bones) do
                for index, bone in ipairs(value.b) do
                    snapBeam:Add(Isaac.WorldToScreen(bone+value.os), 1, 0.1*(value.d/visDuration)*(value.sc^1.5))
                end
                snapBeam:Render()
            end
        end
    end
end, mod.FF.BeahInvisible.Var)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function (_, effect)
    if effect.SubType == 2 then
        
        local bones = mod:GetEntityData(effect).bones
        if bones then
            for idx, value in pairs(bones) do
                value.d = value.d - 1
                if value.d <= 0 then
                    bones[idx] = nil
                end
            end
        end
        mod:GetEntityData(effect).bones = bones
    end
end, mod.FF.BeahInvisible.Var)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.EYE_OF_PROVIDENCE] = {
	TearColor = FiendFolio.ColorEyeOfProvidenceTear, 
	BodyColor = Color(1,1,1,1,-35.283/255,-69.336/255,-55.221/255,1.044,1.115,0.628,1),
	EyeAColor = Color(1,1,1,1,11.953/255,11.953/255,11.953/255,0.953,0.953,0.953,1),
	EyeBColor = Color(1,1,1,1,11.953/255,11.953/255,11.953/255,0.953,0.953,0.953,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	TearFlagsLib.AddTearFlags(tear, flag)
	TearFlagsLib.SetTearFlagParams(tear, flag, {Origin = familiar})
end, FiendFolio.ITEM.COLLECTIBLE.EYE_OF_PROVIDENCE)