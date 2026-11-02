local mod = FiendFolio
local game = Game()
local flag = TearFlagsLib.RegisterTearFlag("YAAI")
local colors = { Color(1,1,1,1,0.2,0.2,0.2,1,1,1,1), Color(-2,-2,-2, 1, 2.2, 2.2, 2.2, 1, 1, 1, 1)} --time itself
mod.PocketRockitDisallowedCustomFlags = (mod.PocketRockitDisallowedCustomFlags or TearFlagsLib.BitSetInfinity.Zero) | flag

local flashDuration = 5
local function flashUpdate(_,tear)
    local fcount = game:GetFrameCount() -- adjusting this to be based on a global timer instead of entity framecount cause seizure warning
    local alt = mod:GetEntityData(tear).ff_yaaiflashOther
    local flash = colors[alt and 2 or 1]

    if fcount % (flashDuration * 2) < flashDuration then
        flash = colors[alt and 1 or 2]
    end

    tear:SetColor(flash, 1, 99, false, false)
end

local function endHitSplit(tear, pos, player)
    pos = mod:getTearSplitPos(pos, tear.Velocity, tear)
    local amount = math.max(player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.YAAI), 1)
    for i = 1, 6*amount, 1 do
        local c = (i%2)+1
        local flagFlashOther = c == 2
        local vec = Vector.FromAngle(i*(60/amount))*player.ShotSpeed*10
        local new = TearFlagsLib.FireSplitTear(tear, vec, player, {
            RemoveCustomFlags = TearFlagsLib.Flag.YAAI,

            ColorOverride = tear.Color * colors[1],
            TearVariant = 0,
            SplitTearType = "FF_YAAI",
        })

        mod:SmoothTearPositionOffset(tear, new)
        mod:GetEntityData(new).ff_yaaiflashOther = flagFlashOther
        mod:AddToTearUpdateList("ff_yaai", new, flashUpdate)
		
		if tear.Type == EntityType.ENTITY_FAMILIAR and tear.Variant == mod.ITEM.FAMILIAR.PLANET_X then
			TearFlagsLib.GetCustomVanillaTearFlagParams(new).ScaleOverride = nil
			new.Scale = TearFlagsLib.GetCustomVanillaTearFlagParams(tear).ScaleOverride * 0.75
		end
    end

    --vfx
    local vpos = (tear.Type == EntityType.ENTITY_TEAR and (tear.Position + tear.PositionOffset)) or pos
    local effect = Isaac.Spawn(mod.FF.YAAIPopup.ID, mod.FF.YAAIPopup.Var, mod.FF.YAAIPopup.Sub, vpos, Vector.Zero, tear)

    local sprite = effect:GetSprite()
    local anim = "Star4"
    if tear.Type == EntityType.ENTITY_TEAR then
        tear = tear:ToTear()
        local scale = tear.Scale
        if scale <= 0.675 then
            anim = "Star1"
        elseif scale <= 0.925 then
            anim = "Star2"
        elseif scale <= 1.175 then
            anim = "Star3"
        elseif scale <= 1.675 then
            anim = "Star4"
        elseif scale <= 2.175 then
            anim = "Star5"
        else
            anim = "Star6"
        end
        local sscale = mod:getTearScale6(tear)
        effect.SpriteScale = effect.SpriteScale * sscale
    end
    sprite:Play(anim)
    --effect.Visible = false
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_DEATH, function (_, tear)
    if TearFlagsLib.HasTearFlags(tear, flag) then
        local p = TearFlagsLib.GetTearPlayer(tear)
        endHitSplit(tear, tear.Position, p)
    end
end)

local function getClosestPointOnLine(testPosition, lineOrigin, lineEnd)
	local heading = lineEnd - lineOrigin
	local magnitude = heading:Length()
	heading:Normalize()

	local lhs = testPosition - lineOrigin
	local dot = lhs:Dot(heading)
	dot = math.min(math.max(0, dot), magnitude)
	return lineOrigin + heading * dot
end

local function movePosToClosestLaserSegment(pos, laser)
	local closestPoint = pos
	local closestDist = math.huge
	local capsules
	if laser:IsSampleLaser() then
		capsules = TearFlagsLib.GetLaserSampleCapsules(laser)
	else
		capsules = {TearFlagsLib.GetCapsule(laser.Position, laser.Position + Vector.FromAngle(laser.AngleDegrees) * 9999, laser.Radius)}
	end
	for _, laserCapsule in pairs(capsules) do
		local pointOnLine = getClosestPointOnLine(pos, laserCapsule.Locus1, laserCapsule.Locus2)
		local dist = pointOnLine:Distance(pos)
		if dist < closestDist then
			closestPoint = pointOnLine
			closestDist = dist
		end
	end
	return closestPoint
end

local function hitEnemy(_, entity, player, source, wflag)
	if wflag == TearFlagsLib.WeaponFlag.FF_PLANET_X then
		local fdata = mod:GetEntityData(source)
		if fdata.YAAICooldown ~= nil then
			return
		end
	end
    if source.Type ~= EntityType.ENTITY_TEAR
    and wflag ~= TearFlagsLib.WeaponFlag.DR_FETUS
    and wflag ~= TearFlagsLib.WeaponFlag.EPIC_FETUS
    and wflag ~= TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS then
		local pos = source.Position
		if source.Type == EntityType.ENTITY_LASER then
			pos = movePosToClosestLaserSegment(entity.Position, source:ToLaser())
		end
		if wflag == TearFlagsLib.WeaponFlag.CLUB and source.SubType == 4 then
			local capsulePosition, capsuleRadius = TearFlagsLib.GetSwingingKnifeCapsulePositionRadius(source)
			pos = (capsulePosition - entity.Position):Resized(entity.Size * math.max(entity.SizeMulti.X, entity.SizeMulti.Y)) + entity.Position
		end
		if wflag == TearFlagsLib.WeaponFlag.FF_PROVIDENCE_LASER then
			pos = entity.Position
		end
        endHitSplit(source, pos, player)
		SFXManager():Play(SoundEffect.SOUND_LASERRING_WEAK, 0.5)
		if wflag == TearFlagsLib.WeaponFlag.FF_PLANET_X then
			local fdata = mod:GetEntityData(source)
			fdata.YAAICooldown = player.MaxFireDelay
		end
    end
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, hitEnemy, flag)

local function bombExplode(_, explosion, player, source, wflag)
	local frame = game:GetFrameCount()
	if mod:GetEntityData(source).didYaai ~= frame then
		endHitSplit(source, source.Position, player)
		mod:GetEntityData(source).didYaai = frame
	end
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_EXPLOSION_TEARFLAG_EFFECT, bombExplode, flag)

local function increment(entity, player)
    local p_data = mod:GetEntityData(player)
    p_data.ff_yaaiSplitCount = (p_data.ff_yaaiSplitCount or 0) + 1
    if p_data.ff_yaaiSplitCount >= 3 then
    p_data.ff_yaaiSplitCount = 0
        TearFlagsLib.AddTearFlags(entity, flag)
        if entity.Type == EntityType.ENTITY_TEAR then
            entity:ToTear().Scale = entity:ToTear().Scale + 0.1
            mod:changeTearVariant(entity, mod.TEAR.YAAI)
            mod:AddToTearUpdateList("ff_yaai", entity, flashUpdate)
        end
    end
end
local function incrementPlanetX(entity)
    local p_data = mod:GetEntityData(entity)
    p_data.ff_yaaiSplitCount = (p_data.ff_yaaiSplitCount or 0) + 1
    if p_data.ff_yaaiSplitCount >= 3 then
    p_data.ff_yaaiSplitCount = 0
        TearFlagsLib.AddTearFlags(entity, flag)
    end
end
local function tearFlagComplex(_, entity, player, wflag)
    if entity.Type == EntityType.ENTITY_TEAR then
        mod.scheduleForUpdate(function ()
            if player:HasCollectible(mod.ITEM.COLLECTIBLE.YAAI)
            and entity.Parent and entity.Parent.Type == EntityType.ENTITY_PLAYER then
                increment(entity,player)
            end
        end, 0)
    elseif wflag == TearFlagsLib.WeaponFlag.FF_PLANET_X then
        if player:HasCollectible(mod.ITEM.COLLECTIBLE.YAAI) then
            incrementPlanetX(entity)
        end
	else
        if player:HasCollectible(mod.ITEM.COLLECTIBLE.YAAI) then
            increment(entity,player)
        end
    end
end
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, mod.ITEM.COLLECTIBLE.YAAI, 		tearFlagComplex)

function mod.handleYAAID3(entity)
	if entity.Type == EntityType.ENTITY_TEAR then
		mod:AddToTearUpdateList("ff_yaai", entity, flashUpdate)
	end
end


--tear variant stuff
local function ganymedeRender(_, tear, var, data, offset)
    local sprite = tear:GetSprite()
    local scale = tear.Scale
    local flags = tear.TearFlags

    local anim
    if scale <= 0.675 then
        anim = "Star1"
    elseif scale <= 0.925 then
        anim = "Star2"
    elseif scale <= 1.175 then
        anim = "Star3"
    elseif scale <= 1.675 then
        anim = "Star4"
    elseif scale <= 2.175 then
        anim = "Star5"
    else
        anim = "Star6"
    end

    if not sprite:IsPlaying(anim) then
        local frame = sprite:GetFrame()
        sprite:Play(anim, true)
        sprite:SetFrame(frame)
    end

    local spritescale = mod:getTearScale6(tear)
    local layers = sprite:GetAllLayers()
    for _, layer in ipairs(layers) do
        layer:SetSize(spritescale)
    end

    if flags & TearFlags.TEAR_FLAT == TearFlags.TEAR_FLAT then
        local adjustedVelocity = tear.Velocity
        if tear.WaitFrames > 0 then
            adjustedVelocity = tear.ContinueVelocity
        elseif (tear.FallingSpeed < 0 or 0.2 < tear.FallingSpeed) and 
            flags & TearFlags.TEAR_LUDOVICO ~= TearFlags.TEAR_LUDOVICO and
            ((flags & TearFlags.TEAR_ABSORB ~= TearFlags.TEAR_ABSORB and flags & TearFlags.TEAR_POP ~= TearFlags.TEAR_POP) or tear.Velocity:Length() <= 0.1) 
        then
            adjustedVelocity = adjustedVelocity + Vector(0, tear.FallingSpeed)
        end
        
        sprite.Rotation = adjustedVelocity:GetAngleDegrees()
        sprite.FlipX = false
        sprite.FlipY = false
    else
        sprite.Rotation = 0
        sprite.FlipX = false
        sprite.FlipY = false
    end
end

local sfx = SFXManager()
mod:AddCallback("FF_CUSTOM_TEAR_RENDER", ganymedeRender, FiendFolio.TEAR.YAAI)
local function ganymedeSplat(_, tear, var, data, offset)
    if not data.denySound then
        sfx:Play(SoundEffect.SOUND_LASERRING_WEAK, 0.5)
    end
	
	if tear.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE then return end
    local explode = Isaac.Spawn(mod.FF.GlitchPoof.ID, mod.FF.GlitchPoof.Var, mod.FF.GlitchPoof.Sub, tear.Position + tear.PositionOffset, Vector.Zero, tear)
    explode.SpriteScale = Vector.One*tear.Scale*1.2
end
mod:AddCallback("FF_CUSTOM_TEAR_SPLAT", ganymedeSplat, FiendFolio.TEAR.YAAI)

local function popupUpdate(_, effect)
    if effect.SubType ~= mod.FF.YAAIPopup.Sub then
        return
    end
    if effect.FrameCount == 5 then
        effect.Visible = false
    end
    if effect.FrameCount == 10 then
        effect.Visible = true
    end
    if effect.FrameCount == 15 then
        effect.Visible = false
    end
    if effect.FrameCount == 20 then
        effect.Visible = true
    end
    if effect.FrameCount == 25 then
        effect:Remove()
    end
end
mod:AddEntityCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.FF.YAAIPopup.ID, mod.FF.YAAIPopup.Var, mod.FF.YAAIPopup.Sub, popupUpdate, mod.FF.YAAIPopup.Var)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.YAAI] = {
	BodyColor = Color(1,1,1,1,-11.283/255,-9.027/255,-51.903/255,1.044,1.035,1.204,1),
	EyeAColor = Color(1,1,1,1,-83.496/255,-83.496/255,-83.496/255,1.327,1.327,1.327,1),
	EyeBColor = Color(1,1,1,1,-83.496/255,-83.496/255,-83.496/255,1.327,1.327,1.327,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	local d = mod:GetEntityData(familiar)
	d.ff_yaaiSplitCount = (d.ff_yaaiSplitCount or 0) + 1
	if d.ff_yaaiSplitCount >= 3 then
		d.ff_yaaiSplitCount = 0
		TearFlagsLib.AddTearFlags(tear, TearFlagsLib.Flag.YAAI)
		tear.Scale = tear.Scale + 0.1
		mod:changeTearVariant(tear, mod.TEAR.YAAI)
		mod:AddToTearUpdateList("ff_yaai_sewing", tear, flashUpdate)
    end
end, FiendFolio.ITEM.COLLECTIBLE.YAAI)