local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    moveSpeed = 2.5, --Same as Tango
    attackCooldown = {120,150},
    numAfterimages = 5,
    afterimageInterval = 10,
    afterimageDistance = {120,200},
    projSpeed = 5,
}

function mod:FalseIdolAI(npc, sprite, data)
    local rng = npc:GetDropRNG()
    local targetpos = mod:confusePos(npc, npc:GetPlayerTarget().Position)

    if not data.Init then
		npc.SplatColor = mod.ColorGhostly
		npc.StateFrame = mod:RandomInt(bal.attackCooldown, rng) - 30
        for i = 0, 2 do
            sprite:GetLayer(i):SetRenderFlags(AnimRenderFlags.STATIC)
        end
		data.State = "Idle"
		data.Init = true
    end

    if data.State == "Idle" then 
        mod:SpritePlay(sprite, "Idle")
        mod:WanderAboutAir(npc, data, bal.moveSpeed, 0.1, 40, 120, 60)

        npc.StateFrame = npc.StateFrame - 1
        if npc.StateFrame <= 0 then
            data.State = "AttackStart"
        end

    elseif data.State == "AttackStart" then
        npc.Velocity = npc.Velocity * 0.5
        
        if sprite:IsFinished("AttackStart") then
            npc.Visible = false
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            npc:RemoveStatusEffects()
            npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET)
            npc.I1 = bal.numAfterimages
            npc.StateFrame = 0
            data.State = "Attacking"
        else
            mod:SpritePlay(sprite, "AttackStart")
        end

    elseif data.State == "Attacking" then
        npc.Velocity = Vector.Zero

        npc.StateFrame = npc.StateFrame - 1
        if npc.StateFrame <= 0 then
            npc.StateFrame = bal.afterimageInterval
            if npc.I1 <= 0 then
                npc.Visible = true
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                npc:ClearEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET)
                data.State = "AttackEnd"
            else
                local afterimage = Isaac.Spawn(mod.FF.FalseIdolAfterimage.ID, mod.FF.FalseIdolAfterimage.Var, mod.FF.FalseIdolAfterimage.Sub, targetpos + RandomVector():Resized(mod:RandomInt(bal.afterimageDistance, rng)), Vector.Zero, npc)
                mod:GetEntityData(afterimage).PoseNum = bal.numAfterimages - npc.I1 + 1
                afterimage:Update()
                afterimage:GetSprite():Play("Image0"..bal.numAfterimages - npc.I1)
            end
            npc.I1 = npc.I1 - 1
        end

    elseif data.State == "AttackEnd" then
        npc.Velocity = npc.Velocity * 0.5
        
        if sprite:IsFinished("AttackEnd") then
            npc.StateFrame = mod:RandomInt(bal.attackCooldown, rng) - 30
		    data.State = "Idle"
        else
            mod:SpritePlay(sprite, "AttackEnd")
        end
    end
end

mod.FalseIdolTimestop = 0
function mod:HandleFalseIdolTimestop()
    local stopTime = false
    for _, falseIdol in pairs(Isaac.FindByType(mod.FF.FalseIdol.ID, mod.FF.FalseIdol.Var)) do
        if mod:GetEntityData(falseIdol).State == "Attacking" and not mod:IsReallyDead(falseIdol) then
            falseIdol:Update()
            stopTime = true
        end
    end
    if stopTime then
        for _, afterimage in pairs(Isaac.FindByType(mod.FF.FalseIdolAfterimage.ID, mod.FF.FalseIdolAfterimage.Var, mod.FF.FalseIdolAfterimage.Sub)) do
            afterimage:ToEffect().Timeout = 2
            afterimage:Update()
        end
    end
    return stopTime
end

function mod:FalseIdolAfterimage(effect, sprite, data)
    if not data.Init then
        for i = 0, 2 do
            sprite:GetLayer(i):SetRenderFlags(AnimRenderFlags.STATIC)
        end
        effect.Timeout = 2
        data.PoseNum = data.PoseNum or 0
        data.Init = true
    end

    mod:SpritePlay(sprite, "Image0"..data.PoseNum)
    if effect.Timeout <= 0 then
        for i = 90, 360, 90 do
            Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, effect.Position, Vector.FromAngle(i):Resized(bal.projSpeed), effect.SpawnerEntity)
        end
        effect:Remove()
    end
end