local mod = FiendFolio
local game = Game()
local offGreenColor = Color(0.376, 0.478, 0.215)
local flag = TearFlagsLib.RegisterTearFlag("WNIC")
local splitflag = TearFlagsLib.RegisterTearFlag("WNIC_SPLIT")

mod.PocketRockitDisallowedCustomFlags = (mod.PocketRockitDisallowedCustomFlags or TearFlagsLib.BitSetInfinity.Zero) | flag

local beamSprite = Sprite()
beamSprite:Load("gfx/effect_wnic_connector.anm2", true)
beamSprite:Play("Idle", false)
beamSprite.Color = offGreenColor

local beamLayer = beamSprite:GetLayer("beam")
beamLayer:SetWrapSMode(1)
beamLayer:SetWrapTMode(0)
local snapBeam = Beam(beamSprite, "beam", false, false)

mod.wnicDisallowedTearFlags = TearFlags.TEAR_ORBIT | TearFlags.TEAR_ORBIT_ADVANCED | TearFlags.TEAR_WIGGLE |
                              TearFlags.TEAR_SPIRAL | TearFlags.TEAR_BIG_SPIRAL | TearFlags.TEAR_LUDOVICO

mod.loopController = nil
--[[mod:AddNewTearFlag(mod.CustomTearFlags.FLAG_PING, {
    ApplyLogic = function (_, player, tear)
        if player:HasCollectible(mod.ITEMS.WNIC) then
            if (tear.Parent and tear.Parent.Type == EntityType.ENTITY_PLAYER) then
                return true
            end
        end
    end,
    EnemyHitEffect = function (_, tear, pos, enemy, p)
        if tear.Type == EntityType.ENTITY_TEAR and not mod:GetEntityData(tear).sw_loopIdx then
            --[[local nt = p:FireTear(p.Position, tear.Velocity, false, true, false, nil, math.min(tear.CollisionDamage / p.Damage,1))
            nt.Parent = nil
            local nt = mod:SpawnTearSplit(tear, p, pos, tear.Velocity, 0.8)
            nt:SetColor(tear.Color*Color(1,1,1,1,1,2,1), 15, 15, true, true)
            local nt_data = mod:GetEntityData(nt)
            nt_data.sw_loopIdx = tear.Index
            mod:addWickedTearFlag(nt, mod.CustomTearFlags.FLAG_PING)
        end
    end,
    PostApply = function (_, player, tear)
        mod:addTearToConnectors(tear)
    end
})]]

mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, function(_, entity, player, source, weaponFlag, params)
	local data = mod:GetEntityData(source)
	local frame = game:GetFrameCount()
    if data.LastFrameWNIC == frame and FiendFolio.HasBeansFlag(source) then return end

    if weaponFlag == TearFlagsLib.WeaponFlag.FF_PLANET_X then
        mod:handlePlanetXWNIC(source, player)
        return
    end

    local velocity = source.Velocity
    if not TearFlagsLib.IsWeaponTearVariant(weaponFlag) then
        velocity = (entity.Position - player.Position):Resized(player.ShotSpeed * 10)
    end

    local tear = TearFlagsLib.FireSplitTear(source, velocity, player, {
        RemoveFlags = mod.wnicDisallowedTearFlags,
        RemoveCustomFlags = flag | ((TearFlagsLib.GetTearFlagParams(source, TearFlagsLib.Flag.WORMHOLE).wasSplit and TearFlagsLib.BitSetInfinity.Zero) or TearFlagsLib.Flag.WORMHOLE),

        PositionOverride = player.Position,
        ColorOverride = player.TearColor,
        ScaleMult = 0.75,
        SplitTearType = "FF_WNIC",
        DamageMult = 1.0,
    })
	TearFlagsLib.AddTearFlags(tear, splitflag)

    if TearFlagsLib.AgnosticGetVanillaTearFlags(source) & TearFlags.TEAR_LUDOVICO ~= TearFlags.TEAR_NORMAL then
        TearFlagsLib.SetTearCanHitMultipleTimes(tear)
    end

    if params.arcParams then
        tear.Height = params.arcParams.height
        tear.FallingSpeed = params.arcParams.speed
        tear.FallingAcceleration = params.arcParams.accel
    end

    tear:SetColor(source.Color*Color(1,1,1,0.05,1,2,1), 15, 15, true, true)
    mod:GetEntityData(tear).sw_loopIdx = GetPtrHash(source)
    data.LastFrameWNIC = frame

    if TearFlagsLib.IsWeaponTearVariant(weaponFlag) then
        mod:addTearToConnectors(tear, player)
    end
end, flag)


function mod.FlagWNIC(tear)
    TearFlagsLib.AddTearFlags(tear, flag)
end

local function checkForFlagStuff(_, entity, player, weapon)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.WNIC) then
        TearFlagsLib.AddTearFlags(entity, flag)
    end
end

mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, mod.ITEM.COLLECTIBLE.WNIC, checkForFlagStuff)
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_CHANCELESS_TEARFLAGS, mod.ITEM.COLLECTIBLE.WNIC, checkForFlagStuff)

mod:AddCallback(TearFlagsLib.Callback.POST_ADD_TEARFLAG, function(_, entity, player, isPolling, weaponFlag)
    weaponFlag = weaponFlag or TearFlagsLib.EstimateWeaponFlagFromEntity(entity)

    if TearFlagsLib.IsWeaponTearVariant(weaponFlag) then
        entity = entity:ToTear()

        if not mod:isEntityWNICParent(entity) then
            local isLudo = TearFlagsLib.AgnosticGetVanillaTearFlags(entity) & TearFlags.TEAR_LUDOVICO ~= TearFlags.TEAR_NORMAL
            mod:addTearToConnectors(entity, player, isLudo)
        end

        if entity.TearFlags & TearFlags.TEAR_HYDROBOUNCE ~= TearFlags.TEAR_HYDROBOUNCE then
            TearFlagsLib.SetTearFlagParams(entity, flag, {
                arcParams = {
                    height = entity.Height,
                    speed = entity.FallingSpeed,
                    accel = entity.FallingAcceleration,
                },
            })
        end
    elseif weaponFlag == TearFlagsLib.WeaponFlag.FF_PLANET_X then
        mod:addPlanetXToConnectors(entity, player)
    end
end, flag)

mod:AddCallback(ModCallbacks.MC_POST_FIRE_SPLIT_TEAR, function(_, new, old)
    mod.initLoopController(TearFlagsLib.GetTearPlayer(old))
    mod:GetEntityData(mod.loopController).sw_GoingTears[GetPtrHash(new)] = nil
end, "FF_WNIC")

mod:AddCallback(TearFlagsLib.Callback.POST_REMOVE_TEARFLAG, function(_, entity, player, weaponFlag)
    Isaac.CreateTimer(function()
        if mod.loopController and not TearFlagsLib.HasTearFlags(entity, flag) then
            (mod:GetEntityData(mod.loopController).sw_GoingTears or {})[GetPtrHash(entity)] = nil
        end
    end, 0, 1, false)
end, flag)

function mod.handleWNICD3(entity)
	if entity.Type == EntityType.ENTITY_TEAR then
        mod.scheduleForUpdate(function ()
            if entity.Parent == nil or entity.Parent.Type ~= EntityType.ENTITY_PLAYER then
                local nt_data = mod:GetEntityData(entity)
                if not nt_data.ff_wasHaemoSplitShot or nt_data.sw_loopIdx then
                    return
                end
            end
            mod:addTearToConnectors(entity, TearFlagsLib.GetTearPlayer(entity))
        end, 0, ModCallbacks.MC_POST_UPDATE, true)
	end
end

function mod.initLoopController(player)
    if not mod.loopController or not mod.loopController:Exists() then
		mod.loopController = Isaac.FindByType(EntityType.ENTITY_EFFECT, mod.FF.BeahInvisible.Var, 10)[1]
		if mod.loopController == nil then
			local loopMaster = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.FF.BeahInvisible.Var, 10, Vector(100, 100), Vector.Zero, player)
			loopMaster.DepthOffset = -9999
			mod.loopController = loopMaster
		end
    end
end

function mod:addTearToConnectors(tear, player, isLudo)
    if player == nil then
        return
    end
    mod.initLoopController(player)

    local t_data = mod:GetEntityData(tear)
---@diagnostic disable-next-line: need-check-nil, undefined-field
    local e_data = mod:GetEntityData(mod.loopController)
    local idx =  GetPtrHash(tear)--getGenericId()
    
    if t_data.sw_loopIdx then
        e_data.sw_AgainTears = e_data.sw_AgainTears or {}
        e_data.sw_GoingTears =  e_data.sw_GoingTears or {}

        local parent = e_data.sw_GoingTears[t_data.sw_loopIdx]
        e_data.sw_AgainTears[idx] = {
            t = tear,
            posMap = parent.posMap,
        }
        tear.Position = parent.startPos
    else
        e_data.sw_GoingTears =  e_data.sw_GoingTears or {}

        e_data.sw_GoingTears[idx] = {
            t = tear,
            posMap = {},
            startPos = tear.Position - tear.Velocity,
            isLudo = isLudo,
        }
    end
end

function mod:isEntityWNICParent(entity)
    return (
        mod.loopController and
        (mod:GetEntityData(mod.loopController).sw_GoingTears or {})[GetPtrHash(entity)]
    )
end

local function animOffset(frame)
    frame = frame%16
    return frame*-0.25
end

local wnicMaxDuration = 300
local wnicLudoMaxDuration = 120

mod.wnicBlinkDuration = 4
mod.wnicIsVis = 2
local timeToLast = 18

function mod:updateEveryPingTear()
    local effect = mod.loopController
    if effect == nil or not effect:Exists() then
        return
    end
    local e_data = mod:GetEntityData(effect)

    local t_renderData = {}
    local bonesWithoutFathers = {}
    local t_animoffset = {}
    if e_data.sw_GoingTears then
        for key, value in pairs(e_data.sw_GoingTears) do
            local ntab = value
            local t = ntab.t
            if t and t:Exists() then
                ntab.fcount = ntab.fcount or 0
                local vCount = ntab.fcount%mod.wnicBlinkDuration
                local vis = vCount <= mod.wnicIsVis
                local val = { pos = t.Position, v = vis, rPos = t.Position + t.PositionOffset, noRender = mod:GetEntityData(t).exitedWormholeRockPortalAt == game:GetFrameCount() }

                if ntab.isLudo and #ntab.posMap > wnicLudoMaxDuration then
                    ntab.posMap[1].pos = ntab.posMap[2].pos
                    ntab.posMap[1].rPos = ntab.posMap[2].rPos
                    table.remove(ntab.posMap, 2)

                    ntab.startPos = ntab.posMap[1].pos
                end

                if #ntab.posMap > wnicMaxDuration then
                    ntab.startPos = ntab.posMap[#ntab.posMap].pos
                    ntab.posMap = {}
                end

                if #ntab.posMap == 0 then
                    val.heartscale = (Vector.One*t.Scale*0.7)
                    _,_,val.heartanim = mod:GetTearAnimSuffix(t.Scale*0.7 )
                end

                table.insert(ntab.posMap, val)
                ntab.fcount = ntab.fcount + 1
                t_renderData[key] = ntab.posMap
                t_animoffset[key] = animOffset(ntab.fcount)
            else
                ntab.posMap[#ntab.posMap] = nil
                bonesWithoutFathers[key] = ntab
                ntab = nil
            end

            e_data.sw_GoingTears[key] = ntab
        end
    end

    local boneRefs = {}
    local bonesWithoutFathers2 = {}
    local needlesslyComplicatedRenderList = {}
	if e_data.sw_GoingPlanets then
		for key, value in pairs(e_data.sw_GoingPlanets) do
			local ntab = value
			local p = ntab.p
			ntab.fcount = ntab.fcount or 0
			if p and p:Exists() and TearFlagsLib.HasTearFlags(p, TearFlagsLib.Flag.WNIC) then
				t_renderData[key] = mod:GetEntityData(p).WNICPosMap
				t_animoffset[key] = animOffset(ntab.fcount)
				ntab.fcount = ntab.fcount + 1
			else
				e_data.sw_GoingPlanets[key] = nil
			end
		end
	end
    
    if e_data.sw_AgainTears then
        for key, value in pairs(e_data.sw_AgainTears) do
            local ntab = value
            local t = ntab.t
            if t and t:Exists() then
                local t_data = mod:GetEntityData(t)
                local echoIdx = t_data.sw_loopIdx or key
                local isLudo = e_data.sw_GoingTears[echoIdx] and e_data.sw_GoingTears[echoIdx].isLudo

                local fCount = ntab.sfc or t.FrameCount
                local pos = ntab.posMap[fCount]
                if pos == nil then
					if isLudo then
						ntab.sfc = 1
						ntab.posMap = e_data.sw_GoingTears[echoIdx].posMap
						pos = ntab.posMap[fCount]
					elseif ntab.planetx then
						t.Velocity = Vector.Zero
						t:Die()
						ntab = nil
						e_data.sw_AgainTears[key] = ntab
						return
					end
                end
                if ntab.sfc then
                    ntab.sfc = ntab.sfc + 1
                end
                if pos then
                    pos = pos.pos + ((pos.origin and pos.origin.Position + pos.origin.Velocity * 2) or Vector.Zero)
                    t.Velocity = pos - t.Position
                end
                if not (isLudo or ntab.planetx) then
                    if ntab.posMap[fCount-1] then
                        ntab.posMap[fCount-1].v = nil
                    end
                    if bonesWithoutFathers[echoIdx] then
                        boneRefs[echoIdx] = boneRefs[echoIdx] or { f = 999, ref = nil }
                        local brefs = boneRefs[echoIdx]
                        if t.FrameCount < brefs.f then
                            if brefs.ref then
                                e_data.sw_AgainTears[brefs.ref].render = nil
                            end
                            boneRefs[echoIdx] = { f = t.FrameCount, ref = key }
                            ntab.render = true
                        end
                    end
                
                    ntab.fcount = (ntab.fcount or 0) + 1
                    if ntab.render then
                        needlesslyComplicatedRenderList[echoIdx] = ntab
                    end
                end

                if isLudo then
                    mod:MultiplyTearFall(t, "ff_ludoWNIC", 0.1)
                    if ntab.sfc and ntab.sfc >= #e_data.sw_GoingTears[echoIdx].posMap then
                        t.Velocity = Vector.Zero
                        t:Remove()
                        ntab = nil
                        e_data.sw_AgainTears[key] = nil
                        return
                    end
                end

				if ntab.planetx then
					local endtab = {}
					endtab.posMap = {{rPos = ntab.rEndPos,
					                  origin = ntab.posMap[1].origin,
									  v = true,
					                  heartscale = ntab.posMap[1].heartscale,
					                  heartanim = ntab.posMap[1].heartanim}}
					endtab.fcount = 0
					
					needlesslyComplicatedRenderList[echoIdx] = endtab
				end
            else
                if ntab.planetx then
					local endtab = {}
					endtab.posMap = {{rPos = ntab.rEndPos,
					                  origin = ntab.posMap[1].origin,
									  v = true,
					                  heartscale = ntab.posMap[1].heartscale,
					                  heartanim = ntab.posMap[1].heartanim}}
					endtab.fcount = 0
					
					bonesWithoutFathers2[key] = endtab
				else
					bonesWithoutFathers2[key] = ntab
				end
                ntab = nil
            end

            e_data.sw_AgainTears[key] = ntab
        end
    end
    for key, value in pairs(needlesslyComplicatedRenderList) do
        t_renderData[key] = value.posMap
        t_animoffset[key] = animOffset(value.fcount)
    end
    e_data.sw_NoneTears = e_data.sw_NoneTears or {}
    for key, value in pairs(bonesWithoutFathers) do
        if not boneRefs[key] then
            e_data.sw_NoneTears[key] = value
        end
    end
    for key, value in pairs(bonesWithoutFathers2) do
        e_data.sw_NoneTears[key] = value
    end
    for key, value in pairs(e_data.sw_NoneTears) do
        local ntab = value
        ntab.fcount = (ntab.fcount or 0) + 1
        ntab.deathCount = (ntab.deathCount or 0) + 1
        local evenBotherRendering = ntab.deathCount < timeToLast/2 or ntab.deathCount%4<=1
        if ntab.deathCount > timeToLast then
            ntab = nil
        elseif evenBotherRendering then
            t_renderData[key] = ntab.posMap
            t_animoffset[key] = animOffset(ntab.fcount)
        end

        e_data.sw_NoneTears[key] = ntab
    end

    e_data.sw_tearBonesToRender = t_renderData
    e_data.sw_tearBonesOffset = t_animoffset
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_UPDATE, CallbackPriority.LATE, mod.updateEveryPingTear)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function (_, effect)
    if effect.SubType ~= 10 then
        return
    end
    local room = game:GetRoom()
    if room:GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
        return
    end
    local e_data = mod:GetEntityData(effect)
    --mod.creationOfManRender(effect)
    local allBones = e_data.sw_tearBonesToRender
    if not allBones then
        return
    end

    local lastRPos
    for key, map in pairs(allBones) do
        local currentLong = 0
        local offset = e_data.sw_tearBonesOffset
        for index, value in ipairs(map) do
            local renderAnyway = index == #map
			if value.noRender and currentLong > 0 then
				if currentLong == 1 then
					local rpos = lastRPos
					snapBeam:Add(rpos, currentLong*4)
				end
				if currentLong ~= 0 then
					snapBeam:Render()
				end
				currentLong = 0
			else
				if value.v then
					local roffset = (value.origin and value.origin:Exists() and value.origin.Position) or Vector.Zero
					local rpos = Isaac.WorldToScreen(value.rPos + roffset)
					lastRPos = rpos
					beamSprite:GetAnimation()
					snapBeam:Add(rpos, (currentLong+4.25+offset[key])*4, 0.8)
					currentLong = currentLong + 1
					if value.heartanim then
						beamSprite.Scale = value.heartscale
						beamSprite:RenderLayer(value.heartanim, rpos)
						beamSprite.Scale = Vector.One
					end
				end
				if not value.v or renderAnyway then
					if currentLong == 1 then
						local rpos = lastRPos
						snapBeam:Add(rpos, currentLong*4)
					end
					if currentLong ~= 0 then
						snapBeam:Render()
					end
					currentLong = 0
				end
			end
        end
    end
end, mod.FF.BeahInvisible.Var)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.WNIC] = {
	TearColor = FiendFolio.ColorWNICTear, 
	BodyColor = Color(1,1,1,1,-9.628/255,-9.628/255,-9.628/255,0.504,0.504,0.504,1),
	EyeAColor = Color(1,1,1,1,-47.327/255,-18.584/255,-61.327/255,0.770,0.779,0.770,1),
	EyeBColor = Color(1,1,1,1,-47.327/255,-18.584/255,-61.327/255,0.770,0.779,0.770,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	TearFlagsLib.AddTearFlags(tear, flag, true)
end, FiendFolio.ITEM.COLLECTIBLE.WNIC)