local mod = FiendFolio
local sfx = SFXManager()

local fireNeeded = 5
local volleyNum = 4
local minSpread = 37.5
local additionalSpread = 90
local colors = {
    Color (1, 1, 1, 1, 1),
    Color (1, 1, 1, 1, 0, 1),
    Color (1, 1, 1, 1, 0, 0.2, 1),
    Color (1, 1, 1, 1, 1, 0, 1),
    Color (1, 1, 1, 1, 1, 1, 0),
}
local function getColor(rng)
    mod:Shuffle(colors)
    return colors[1]
end
local function OnFirePure(_, player, dir, amount, owner, params)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.GANYMEDE) then
		local p_data = mod:GetEntityData(player)
		p_data.sw_ganymedeTick = p_data.sw_ganymedeTick or 0
		if owner.Type == EntityType.ENTITY_PLAYER then
			if p_data.sw_ganymedeTick > fireNeeded then
				p_data.sw_ganymedeTick = 0
			end
			p_data.sw_ganymedeTick = p_data.sw_ganymedeTick + 1
		end

		if p_data.sw_ganymedeTick == fireNeeded then
			local c_rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.GANYMEDE)
			for i = 1, volleyNum, 1 do
				local mult = c_rng:RandomFloat()>0.5 and -1 or 1
				local addSpread = c_rng:RandomFloat()*additionalSpread
				local ang = (minSpread + addSpread)*mult
				local v = dir:Rotated(ang)

				v = v + player:GetTearMovementInheritance(player:GetAimDirection())
				v:Resize(10)
				v:Resize(v:Length()--[[^(1/dv.X)]] / (1.15 + (c_rng:RandomFloat()-0.5)*0.15) *1.5)
				mod.IgnoreSecondaryFireEffects = true
				local t = player:FireTear(owner.Position - v, v, false, false, false, nil, amount)
				mod.IgnoreSecondaryFireEffects = false

				mod:ClearMovementModifyingTearFlags(t)
				mod:changeTearVariant(t, mod.TEAR.GANYMEDE)
				t.Height = t.Height*3
				t.Scale = t.Scale * 0.66
				t.Color = getColor(c_rng)
				t.FlipX = c_rng:RandomInt(2)==1

				local t_data = mod:GetEntityData(t)
				t_data.sw_gany = {faller = player.MaxFireDelay/10}
				mod:AddToTearUpdateList("sw_ganymede", t, mod.ganymedeTearUpdate)
				sfx:Play(SoundEffect.SOUND_SCYTHE_BREAK)
			end
		end
    end
end
mod:AddCollectibleCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE, mod.ITEM.COLLECTIBLE.GANYMEDE, OnFirePure)
mod:AddCollectibleCallback("POST_PRIMARY_GUN_FIRE", mod.ITEM.COLLECTIBLE.GANYMEDE, function (_, _, player, aim)
    OnFirePure(_, player, aim, 1, player, nil) --dont know if this should be 1 but i cant think of any instance where it shouldnt rn?
end)

local noCollideFrames = 8
local noFallFrames = 94
local maxSpinSpeed = 30
local flashColour = Color(1,1,1,1, 0.4, 0.4, 0.4)
function mod:ganymedeTearUpdate(tear)
    local t_data = mod:GetEntityData(tear)
    local g = t_data.sw_gany
    if not g then
        return
    end

    local gp = g.parent
    local vel = g.savedVel
    local dontFall = true
    if not gp and not vel and tear.FrameCount > noCollideFrames
    and tear.FrameCount % 2 == 1 then -- my life fears for the performance of this
        --tears, and also hopefully bombs
        local t, b
        local tears = Isaac.FindInRadius(tear.Position, tear.Size+48)
        for _, nt in ipairs(tears) do
            b = nt:ToBomb()
            local isBomb = (b and b.IsFetus)

            t = nt:ToTear()
            if t or isBomb then                
                local ntd = mod:GetEntityData(nt)
                if not ntd.sw_gany then
                    g.parent = nt
                    gp = g.parent

                    g.isBomb = isBomb
                    goto newParent
                    break
                end
            end
        end

        ::newParent::
        if gp or vel then
            if gp then
                if t then
                    t:AddTearFlags(TearFlags.TEAR_HOMING)
                else
                    b:AddTearFlags(TearFlags.TEAR_HOMING)
                end

                gp:SetColor(tear.Color*flashColour, 8, 3, true, false)
            end
        end
    end
    g.olOrbVec = g.olOrbVec or Vector.Zero

    --checking for parent stuff
    if gp ~= nil then
        --if parent dies
        if not gp:Exists() then
            g.parent = nil
            gp = nil

            tear:AddTearFlags(TearFlags.TEAR_HOMING) -- generosity
            --tear.HomingFriction = tear.HomingFriction * 2
            if g.isBomb then
                tear.Velocity:Resize(20)
                dontFall = false
            end
        else -- otherwise, continue on
            vel = (gp.Position + gp.Velocity) - g.olOrbVec - tear.Position
            g.savedVel = gp.Velocity
            g.savedPos = gp.Position

            local pt = gp:ToTear()
            if pt then
                -- set height
            end
        end
    end

    --setting the velocity if it has, or had, a parent
    if vel then
        if gp == nil then
            if tear.Target then
                goto endofline
            end
            if g.isBomb then
                g.bombless = (g.bombless or 0)+1
                tear.Velocity = tear.Velocity:Rotated(g.orbSpeed)
                mod:MultiplyTearVelocity(tear, "sw_ganyfetus", 1+(g.bombless/10))
                dontFall = false
                goto endofline
            end
            g.savedPos = (g.savedPos or tear.Position) + g.savedVel
            vel = (g.savedPos + g.savedVel) - g.olOrbVec - tear.Position
        end
        g.velFrames = (g.velFrames or 0)
        local ov = g.olOrbVec
        local pos = (tear.Position-ov)

        local lerp = mod:ClampNumber(1-1/g.velFrames*4, 0.1, 1)
        local nPos = mod:Lerp(pos, pos+vel, lerp)
        local uPos = mod:Lerp(Vector.Zero, vel, 1-lerp)

        g.orbSpeed = g.orbSpeed or 0
        g.orbSpeed = mod:ClampNumber((g.orbSpeed*1.5)+1, 1.1, maxSpinSpeed)
        g.orbSpeed = (g.orbSpeed * mod:GetAllMultipliedTearVelocity(tear) * 0.66)
        local orbVec = mod:SmoothOrbitVec(tear, pos, tear.Size+10, g.orbSpeed)

        g.allUPos = (g.allUPos or Vector.Zero) + uPos
        local catchupVel = g.allUPos * lerp
        g.allUPos = g.allUPos - catchupVel
        tear.Velocity = (nPos+catchupVel)+orbVec - tear.Position
        g.lastCatchupVel = catchupVel
        g.olOrbVec = orbVec
        
        if tear.FrameCount > noFallFrames*g.faller*2 then
            dontFall = false
        end
    else -- idle
        if tear.FrameCount > noFallFrames*g.faller then
            dontFall = false
        end
        tear.Velocity = mod:Lerp(tear.Velocity, Vector.Zero, 0.1)
    end
    ::endofline::
    if dontFall then
        tear.Height = tear.Height - tear.FallingSpeed
        tear.FallingSpeed = 0
    end

    local trail, init = mod:SetEasyTearTrail(tear)
    if init then
        trail.SpriteScale = Vector.One*tear.Scale*2
        trail.MinRadius = 0.075
        trail.Color = Color(tear.Color.R, tear.Color.G, tear.Color.B, 0.4, tear.Color.RO*0.4,tear.Color.GO*0.4,tear.Color.BO*0.4)
    end
    t_data.sw_gany = g

    EntityEffect.CreateLight(tear.Position + tear.PositionOffset, 1, 1, 6, tear.Color)
end

mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, function (_, tear, other)
    local t_data = mod:GetEntityData(tear)
    if t_data.sw_gany and other:ToBomb() then
        return true
    end
end)

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
mod:AddCallback("FF_CUSTOM_TEAR_RENDER", ganymedeRender, FiendFolio.TEAR.GANYMEDE)

local function ganymedeSplat(_, tear, var, data, offset)
    if not data.denySound then
        sfx:Play(SoundEffect.SOUND_FREEZE_SHATTER)
    end
	
	if tear.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE then return end
    local explode = Isaac.Spawn(mod.FF.GanymedePoof.ID, mod.FF.GanymedePoof.Var, mod.FF.GanymedePoof.Sub, tear.Position + tear.PositionOffset, Vector.Zero, tear)
    explode.SpriteScale = Vector.One*tear.Scale*1.2
end
mod:AddCallback("FF_CUSTOM_TEAR_SPLAT", ganymedeSplat, FiendFolio.TEAR.GANYMEDE)

local function poofUpdate(_, effect)
    if effect.SubType ~= mod.FF.GanymedePoof.Sub then
        return
    end
    if effect:GetSprite():IsFinished("Appear") then
        effect:Remove()
    end
end
mod:AddEntityCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.FF.GanymedePoof.ID, mod.FF.GanymedePoof.Var, mod.FF.GanymedePoof.Sub, poofUpdate, mod.FF.GanymedePoof.Var)

--funny
local game = Game()
local hud = game:GetHUD()
local function addCollectible(_, title, subtitle)
    if title == "Ganymede" and subtitle == "Heaven calls" and math.random() <= 0.1 then
        hud:ShowItemText("Gunymede", "Heaven's call")
        return false
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_ITEM_TEXT_DISPLAY, CallbackPriority.LATE, addCollectible)