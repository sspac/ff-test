local mod = FiendFolio
local game = Game()

--[[
    local roomDat = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'amnioticSackData', tostring(game:GetLevel():GetCurrentRoomDesc().ListIndex), {})
		if roomDat[tostring(room:GetGridIndex(npc.Position))] then
			sprite:SetFrame("Blown", 0)
			npc:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR)
			return
		end

        local roomDat = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'amnioticSackData', tostring(game:GetLevel():GetCurrentRoomDesc().ListIndex), {})
		roomDat[tostring(room:GetGridIndex(npc.Position))] = true
]]

local hunkBal = {
    smallHealth = 12,
    shakeCooldown = 5,
    flyChanceMinor = {10, 40},
    poopChanceMinor = 30, --increase is added before the chance is rolled
    poopChanceIncrease = 20,

    poopDeathFly = {{"Pooter", 1}, {"FriendlyDips", 2}, {"Coin", 1}, {"Heart", 0.8}},
    poopDeathNorm = {{"Dip", 1}, {"FriendlyDips", 2}, {"Coin", 1}, {"Heart", 0.8}},
    poopDeathTotal = 4.8,
}

--using some stuff from amniotic sacs!
function mod:hunkOfGunkAI(npc)
    local d = mod:GetEntityData(npc)
    local sprite = npc:GetSprite()
    local rng = npc:GetDropRNG()
    local room = game:GetRoom()
    local donot

    if not d.init then
        if rng:RandomInt(2) == 0 then
			sprite.FlipX = true
		end
		npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET)
        npc.SplatColor = FiendFolio.ColorPoop

        if (npc.SubType >> 1 & 1) == 1 then
            d.hunkSuffix = "Fly"
        else
            d.hunkSuffix = ""
        end
        d.hunkPrefix = "Large"
        local adjustedHealth
		local roomDat = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'hunkOfGunkData', tostring(game:GetLevel():GetCurrentRoomDesc().ListIndex), {})
        local entry = roomDat[tostring(room:GetGridIndex(npc.Position))]
        if entry then
            if entry.health then
                npc.HitPoints = entry.health
                adjustedHealth = true
            end
            if entry.small then
                d.hunkPrefix = "Small"
                npc.MaxHitPoints = hunkBal.smallHealth
            end
            if entry.gone then
                donot = true
                npc:Remove()
            end
        end
        if (npc.SubType & 1) == 1 then
            if not adjustedHealth then
                npc.HitPoints = hunkBal.smallHealth
                npc.MaxHitPoints = hunkBal.smallHealth
            end
            d.hunkPrefix = "Small"
        end
        sprite:Play(d.hunkPrefix .. d.hunkSuffix, true)
        d.state = "Idle"
        d.initPos = npc.Position
        d.init = true
    else
        npc.StateFrame = npc.StateFrame+1
    end

    if not d.isSpecturned then
		if not d.initPos then
			d.initPos = npc.Position
		end
		npc.Velocity = d.initPos-npc.Position
	else
		d.initPos = nil
	end
    if d.hunkPrefix == "Large" then
        mod.QuickSetEntityGridPath(npc, 3999)
    else
        mod.QuickSetEntityGridPath(npc, 900)
    end

    if d.state == "Idle" then
        mod:spritePlay(sprite, d.hunkPrefix .. d.hunkSuffix)
    elseif d.state == "Collapse" then
        if sprite:IsFinished("LargeCollapse" .. d.hunkSuffix) then
            d.state = "Idle"
            d.hunkPrefix = "Small"
        elseif sprite:IsEventTriggered("Spawn") then
            npc:PlaySound(SoundEffect.SOUND_PLOP, 1, 0, false, 1)
        else
            mod:spritePlay(sprite, "LargeCollapse" .. d.hunkSuffix)
        end
    elseif d.state == "Shake" then
        if sprite:IsFinished(d.hunkPrefix .. "Shake" .. d.hunkSuffix) then
            d.state = "Idle"
        else
            mod:spritePlay(sprite, d.hunkPrefix .. "Shake" .. d.hunkSuffix)
        end
    end

    if npc:IsDead() then
        if d.hunkPrefix == "Large" then
            mod.QuickSetEntityGridPath(npc, 900)
        end
        local roomDat = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'hunkOfGunkData', tostring(game:GetLevel():GetCurrentRoomDesc().ListIndex), {})
		roomDat[tostring(room:GetGridIndex(npc.Position))] = {gone = true}
        if not d.sound and not donot then
            d.sound = true
            npc:PlaySound(SoundEffect.SOUND_PLOP, 1, 0, false, 1.5)
            local poopBonus = mod.getTrinketMultiplierAcrossAllPlayers(TrinketType.TRINKET_PETRIFIED_POOP)
            local buttBonus = mod.getTrinketMultiplierAcrossAllPlayers(TrinketType.TRINKET_BUTT_PENNY)
            local realButt
            local realPoop
            if buttBonus > 0 then
                realButt = hunkBal.poopDeathTotal*(0.2 + (0.1*buttBonus))
            end
            if poopBonus then
                realPoop = hunkBal.poopDeathTotal*(0.4 + (0.1*poopBonus))
            end
            local result
            if d.hunkSuffix == "Fly" then
                local tab = mod:makeCopiedTable(hunkBal.poopDeathFly)
                if realButt then
                    tab[3][2] = tab[3][2]+realButt
                end
                if realPoop then
                    tab[4][2] = tab[4][2]+realPoop
                    tab[3][2] = tab[3][2]+realPoop
                end
                result = mod:weightedRNG(tab, rng)
            else
                local tab = mod:makeCopiedTable(hunkBal.poopDeathNorm)
                if realButt then
                    tab[3][2] = tab[3][2]+realButt
                end
                if realPoop then
                    tab[4][2] = tab[4][2]+realPoop
                    tab[3][2] = tab[3][2]+realPoop
                end
                result = mod:weightedRNG(tab, rng)
            end
            if result == "Pooter" then
                local fly = Isaac.Spawn(EntityType.ENTITY_POOTER, 0, 0, npc.Position, Vector.Zero, npc):ToNPC()
                mod:GetEntityData(fly).hunkSpawned = "Fly"
                fly.PositionOffset = Vector(0, 20)
                mod:GetEntityData(fly).hunkSpawner = npc
                fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                fly:Update()
            elseif result == "Dip" then
                local dip = Isaac.Spawn(EntityType.ENTITY_DIP, 0, 0, npc.Position, Vector.Zero, npc):ToNPC()
                dip:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                dip.State = NpcState.STATE_MOVE
                mod:GetEntityData(dip).hunkSpawned = "Dip"
                mod:GetEntityData(dip).hunkSpawner = npc
                dip.SplatColor = FiendFolio.ColorPoop
                dip:Update()
            elseif result == "Coin" then
                local coin = Isaac.Spawn(5, 20, 0, npc.Position, Vector.Zero, npc):ToPickup()
            elseif result == "Heart" then
                local heart = Isaac.Spawn(5, 10, 0, npc.Position, Vector.Zero, npc):ToPickup()
            elseif result == "FriendlyDips" then
                local player = Isaac.GetPlayer(0)
                if player then
                    for i=1,3 do
                        player:ThrowFriendlyDip(0, npc.Position, npc.Position+Vector(0,mod:RandomInt(40,60,rng)):Rotated(rng:RandomInt(360)))
                    end
                end
            end
        end
    end
end

function mod:hunkOfGunkHurt(ent, damage, flag, source)
    local npc = ent:ToNPC()
    local room = game:GetRoom()
    local roomDat = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'hunkOfGunkData', tostring(game:GetLevel():GetCurrentRoomDesc().ListIndex), {})
    local entry = roomDat[tostring(room:GetGridIndex(npc.Position))]
    local d = mod:GetEntityData(npc)
    if npc.HitPoints-damage < hunkBal.smallHealth and d.hunkPrefix == "Large" then
        d.state = "Collapse"
        if entry then
            entry.health = npc.HitPoints-damage
            entry.small = true
        else
            roomDat[tostring(room:GetGridIndex(npc.Position))] = {small = true, health = npc.HitPoints-damage}
        end
    else
        if entry then
            entry.health = npc.HitPoints-damage
        else
            roomDat[tostring(room:GetGridIndex(npc.Position))] = {health = npc.HitPoints-damage}
        end
    end
    if npc.StateFrame > hunkBal.shakeCooldown and damage < npc.HitPoints then
        if d.state ~= "Collapse" then
            d.state = "Shake"
        end
        npc.StateFrame = 0
        local rng = npc:GetDropRNG()
        local myChance = rng:RandomInt(100)
        if d.hunkSuffix == "Fly" then
            if myChance < hunkBal.flyChanceMinor[1] then
                local fly = Isaac.Spawn(EntityType.ENTITY_POOTER, 0, 0, npc.Position, Vector.Zero, npc):ToNPC()
                mod:GetEntityData(fly).hunkSpawned = "Fly"
                fly.PositionOffset = Vector(0, 20)
                mod:GetEntityData(fly).hunkDir = Vector(0,mod:RandomInt(350,500,rng)/100):Rotated(rng:RandomInt(360))
                mod:GetEntityData(fly).hunkSpawner = npc
                fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                fly:Update()
            elseif myChance < hunkBal.flyChanceMinor[2] then
                local fly = Isaac.Spawn(EntityType.ENTITY_ATTACKFLY, 0, 0, npc.Position, Vector.Zero, npc):ToNPC()
                mod:GetEntityData(fly).hunkSpawned = "Fly"
                fly.PositionOffset = Vector(0, 20)
                mod:GetEntityData(fly).hunkDir = Vector(0,mod:RandomInt(350,500,rng)/100):Rotated(rng:RandomInt(360))
                mod:GetEntityData(fly).hunkSpawner = npc
                fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                fly:Update()
            else
                local fly = Isaac.Spawn(EntityType.ENTITY_FLY, 0, 0, npc.Position, Vector.Zero, npc):ToNPC()
                mod:GetEntityData(fly).hunkSpawned = "Fly"
                fly.PositionOffset = Vector(0, 20)
                mod:GetEntityData(fly).hunkDir = Vector(0,mod:RandomInt(350,500,rng)/100):Rotated(rng:RandomInt(360))
                mod:GetEntityData(fly).hunkSpawner = npc
                fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                fly:Update()
            end
            npc:PlaySound(SoundEffect.SOUND_MEAT_JUMPS, 0.3, 0, false, mod:RandomInt(120,140,rng)/100)
        else
            d.hunkPoopIncrease = (d.hunkPoopIncrease or 0)+hunkBal.poopChanceIncrease
            if myChance < hunkBal.poopChanceMinor+d.hunkPoopIncrease then
                d.hunkPoopIncrease = 0
                local dip = Isaac.Spawn(EntityType.ENTITY_DIP, 0, 0, npc.Position, Vector.Zero, npc):ToNPC()
                dip:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                dip.State = NpcState.STATE_MOVE
                mod:GetEntityData(dip).hunkSpawned = "Dip"
                mod:GetEntityData(dip).hunkSpawner = npc
                dip.SplatColor = FiendFolio.ColorPoop
                dip:Update()
                npc:PlaySound(SoundEffect.SOUND_BLOBBY_WIGGLE, 0.4, 0, false, mod:RandomInt(135,155,rng)/100)
                npc:PlaySound(SoundEffect.SOUND_MEAT_JUMPS, 0.3, 0, false, mod:RandomInt(120,140,rng)/100)
                local poof = Isaac.Spawn(1000, EffectVariant.BLOOD_EXPLOSION, 100, npc.Position, Vector.Zero, npc):ToEffect()
                poof.Color = FiendFolio.ColorPoop
            end
        end
    end
end

function mod:hunkOfGunkColl(ent, coll, first)
    if coll:ToNPC() and mod:GetEntityData(coll).hunkSpawned then
        return true
    else
        mod:ReimplementKnifeDamage(ent, coll)
    end
end

function mod:hunkOfGunkExtraUpdates(npc)
    local d = mod:GetEntityData(npc)
    if d.hunkSpawned then
        if d.hunkSpawned == "Fly" then
            if npc.PositionOffset.Y > 0 and not d.hunkFinished then
                if d.hunkDir then
                    npc.Velocity = mod:Lerp(npc.Velocity, d.hunkDir, 0.5)
                    d.hunkDir = d.hunkDir*0.95
                end
                npc.PositionOffset = Vector(0, math.max(0, npc.PositionOffset.Y-1))
            elseif npc.FrameCount > 50 then
                d.hunkFinished = true
            end
            if npc.Type == EntityType.ENTITY_POOTER and npc.FrameCount < 20 and npc.State == 8 then
                npc.State = 4
                npc.StateFrame = 0
            end
        end
    end
end
mod:AddEntityCallback(ModCallbacks.MC_NPC_UPDATE, mod.FF.HunkOfGunk.ID, mod.FF.HunkOfGunk.Var, nil, mod.hunkOfGunkExtraUpdates, EntityType.ENTITY_FLY)
mod:AddEntityCallback(ModCallbacks.MC_NPC_UPDATE, mod.FF.HunkOfGunk.ID, mod.FF.HunkOfGunk.Var, nil, mod.hunkOfGunkExtraUpdates, EntityType.ENTITY_ATTACKFLY)
mod:AddEntityCallback(ModCallbacks.MC_NPC_UPDATE, mod.FF.HunkOfGunk.ID, mod.FF.HunkOfGunk.Var, nil, mod.hunkOfGunkExtraUpdates, EntityType.ENTITY_POOTER)