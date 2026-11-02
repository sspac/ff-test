local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local statusflag = mod:RegisterEnemyStatusEffect("DRIED_PAINT", 1030, "driedPaintOnUpdate")
local flagsManager = TearFlagsLib
flagsManager.RegisterTearFlag("DRIED_PAINT")

mod.driedPaintData = {}

local driedPaintAnims = {
    "Gaper",
    "Fatty",
    "Spider",
    "Fly",
    "Bony",
    "Horf",
    "Vis",
    "Dip",
    "Boil",
}

local driedPaintTearColours = {
    FiendFolio.ColorDriedPaint1,
    FiendFolio.ColorDriedPaint2,
    FiendFolio.ColorDriedPaint3,
    FiendFolio.ColorDriedPaint4,
}

local driedPaintVals = {
    3,3,2,2,2,1
}

function mod:driedPaintMonsterAI(npc)
    local sprite, d, rng = npc:GetSprite(), mod:GetEntityData(npc), npc:GetDropRNG()
    if not d.init then
        d.init = true
        d.cooldown = mod:RandomInt(3,10,rng)
    end
    npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS

    if mod:RandomInt(3,10,rng) == 1 then
        d.cooldown = mod:RandomInt(3,10,rng)
    end
    if d.cooldown and d.cooldown > 0 then
        d.anim = mod:RandomInt(1, #driedPaintAnims)
        d.cooldown = d.cooldown - 1
    end

    mod:spritePlay(sprite, driedPaintAnims[d.anim])
    npc:AddEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
    if npc:IsDead() then
        local swirl = Isaac.Spawn(1000,16,0,npc.Position,Vector.Zero,npc):ToEffect()
        swirl.Color = Color(0.6,1,1,0.75)
        swirl:GetSprite().PlaybackSpeed = 0.5
        swirl.SpriteOffset = Vector(0, -15)
        swirl:Update()
        mod.driedPaintData[npc.InitSeed] = {}
        mod.driedPaintData[npc.InitSeed].Position = npc.Position
        local iVal = driedPaintVals[mod:RandomInt(1,#driedPaintVals,rng)]
        for i = 0, 30, iVal do
            mod.scheduleForUpdate(function()
                mod.driedPaintData[npc.InitSeed].TargVel = mod.driedPaintData[npc.InitSeed].TargVel or Vector.Zero
                local player = Isaac.GetPlayer(0)
                if npc.SpawnerEntity and npc.SpawnerEntity.Type == 1 then
                    player = npc.SpawnerEntity:ToPlayer()
                end
                --sfx:Play(mod.Sounds.Plorp, 0.9, 0, false, math.random(130,150)/100)
                local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.DRIED_PAINT)
                local target = mod.FindClosestEnemy(mod.driedPaintData[npc.InitSeed].Position, 800, true, nil, nil, nil, nil, nil, nil, nil, 3)
                local targVel
                if target then
                    targVel = (target.Position - mod.driedPaintData[npc.InitSeed].Position):Normalized()
                end
                if not targVel then
                    targVel = RandomVector()
                end
                mod.driedPaintData[npc.InitSeed].TargVel = mod:Lerp(mod.driedPaintData[npc.InitSeed].TargVel, targVel, 0.2)
                local newtear = Isaac.Spawn(2, 0, 0, mod.driedPaintData[npc.InitSeed].Position, mod.driedPaintData[npc.InitSeed].TargVel:Resized(10):Rotated(mod:RandomInt(-15,15,rng)), player):ToTear()
                if rng:RandomInt(666) == 1 then
                    newtear.Color = mod.ColorDriedPaintRare
                else
                    newtear.Color = driedPaintTearColours[rng:RandomInt(#driedPaintTearColours) + 1]
                end
                newtear.CanTriggerStreakEnd = false
                local extra = (0.9 + (rng:RandomFloat() * 0.2))
                local baseDamage = mod:calculateDPS(player) * 0.1 * iVal
                newtear.CollisionDamage = baseDamage * extra
                newtear.Scale = math.min(1, baseDamage / 3) * extra
                newtear.SpawnerEntity = player
                newtear.FallingSpeed = -0.1
                newtear.FallingAcceleration = -0.1
                mod:GetEntityData(newtear).dontCollideBombs = true
                TearFlagsLib.AddTearFlags(newtear, TearFlagsLib.Flag.DRIED_PAINT)
                newtear:Update()
            end, i)
        end
    end

    npc.Velocity = npc.Velocity * 0.8
end

FiendFolio.DriedPaintBlacklist = {
    --[EntityType.ENTITY_MOVABLE_TNT] = true, --A little strange but I kinda like it
    [EntityType.ENTITY_FROZEN_ENEMY] = true,
    [EntityType.ENTITY_MINECART] = true,
    [mod.FF.DriedPaintMonster.ID .. " " .. mod.FF.DriedPaintMonster.Var] = true,
}

function mod:isDriedPaintBlacklisted(entity)
    return FiendFolio.DriedPaintBlacklist[entity.Type] or
    FiendFolio.DriedPaintBlacklist[entity.Type .. " " .. entity.Variant] or
    FiendFolio.DriedPaintBlacklist[entity.Type .. " " .. entity.Variant .. " " .. entity.SubType]
end

function mod:MarkForDriedPaintDeath(entity, source, isCloned)
    if not (entity and entity:ToNPC()) then
		return
	end

    local data = mod:GetEntityData(entity)
    
	if mod:isSegmented(entity) and not isCloned then
		local segments = mod:getSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				mod:MarkForDriedPaintDeath(segment, source, true)
			end
		end
	elseif mod:isBasegameSegmented(entity) and not isCloned then
		local segments = mod:getBasegameSegments(entity)

		for _,segment in ipairs(segments) do
			if segment.InitSeed ~= entity.InitSeed or segment.Index ~= entity.Index then
				mod:MarkForDriedPaintDeath(segment, source, true)
			end
		end
	end
    if not mod:isDriedPaintBlacklisted(entity) then
        data.FFApplyDriedPaintOnDeath = true
        data.FFDriedPaintOnDeathDuration = 2
        data.FFDriedPaintOnDeathSource = source
        --entity:ToNPC():AddEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
		mod:TrackEnemyStatus(entity, statusflag)
    end
end

mod:AddCallback(flagsManager.Callback.APPLY_TEARFLAG_EFFECT, function(_, entity, player, source)
    mod:MarkForDriedPaintDeath(entity, player)
end, flagsManager.Flag.DRIED_PAINT)

--[[mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
    local data = mod:GetEntityData(npc)
    if data.FFDriedPaintOnDeathDuration ~= nil and data.FFDriedPaintOnDeathDuration > 0 then
        local driedPaint = Isaac.Spawn(mod.FF.DriedPaintMonster.ID, mod.FF.DriedPaintMonster.Var, 0, npc.Position, Vector.Zero, npc)
        driedPaint:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        driedPaint.HitPoints = math.max(1, npc.MaxHitPoints)
        driedPaint:Update()
    end
end)]]

function mod:handleDriedPaintDeath(npc,data)
    mod.scheduleForUpdate(function()
        if npc and npc:ToNPC() then
            if npc:IsDead() or npc.Type == EntityType.ENTITY_FROZEN_ENEMY then
                local driedPaint = Isaac.Spawn(mod.FF.DriedPaintMonster.ID, mod.FF.DriedPaintMonster.Var, 0, npc.Position, Vector.Zero, data.FFDriedPaintOnDeathSource)
                driedPaint:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                driedPaint.HitPoints = math.max(1, npc.MaxHitPoints * 0.75)
                driedPaint:Update()
                data.FFDriedPaintOnDeathDuration = nil
            end
        end
    end, 1)
end

--Called in statuses/main
function mod:driedPaintOnUpdate(npc, data)
	if (data.FFDriedPaintOnDeathDuration ~= nil and data.FFDriedPaintOnDeathDuration > 0) or data.FFDriedPaintForce then
        mod:handleDriedPaintDeath(npc,data)
        data.FFDriedPaintOnDeathDuration = data.FFDriedPaintOnDeathDuration - 1
	else
        if npc:ToNPC() then
            --npc:ClearEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
        end
		data.FFApplyDriedPaintOnDeath = false
		data.FFDriedPaintOnDeathDuration = nil
		data.FFDriedPaintOnDeathSource = nil
		mod:UntrackEnemyStatus(npc, statusflag)
	end
end

local function addDriedPaintFlags(_, entity, player, weaponFlag)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.DRIED_PAINT) then
        TearFlagsLib.AddTearFlags(entity, TearFlagsLib.Flag.DRIED_PAINT)
	end
end

mod:AddCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, addDriedPaintFlags)
mod:AddCallback(TearFlagsLib.Callback.POLL_CHANCELESS_TEARFLAGS, addDriedPaintFlags)