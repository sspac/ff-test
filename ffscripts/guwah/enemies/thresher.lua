local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    diveWait = {30,90},
    diveRange = 120,
    appearRange = 80,
}

local suffixes = {"Down", "Left", "Up", "Right"}

function mod:ThresherAI(npc, sprite, data)
    local targetpos = mod:confusePos(npc, npc:GetPlayerTarget().Position)
    local rng = npc:GetDropRNG()
    local room = game:GetRoom()

    if not data.Init then
        if npc.SubType == 1 then
            mod:makeWaitFerr(npc, npc.Type, npc.Variant, 0, 60, true)
        else
            if data.waited then
                npc.Visible = true
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
                sprite:RemoveOverlay()
                npc:PlaySound(mod.Sounds.SplashLargePlonkless,0.6,0,false,1.5)
                mod:spritePlay(sprite, "Emerge")
                data.State = "Emerge"
                npc.State = NpcState.STATE_JUMP
            end
            data.ThresherRestoreColl = npc.CollisionDamage
            npc.StateFrame = mod:RandomInt(bal.diveWait, rng)
        end
        data.Init = true
    end

    if npc.State == NpcState.STATE_JUMP then
        npc.Velocity = Vector.Zero
        if data.State == "Submerge" then
            if sprite:IsFinished("Submerge") then
                data.State = "Emerge"
                npc:PlaySound(mod.Sounds.SplashLargePlonkless,0.6,0,false,1.5)
                npc.Position = room:FindFreePickupSpawnPosition(targetpos, bal.appearRange, true)
            elseif sprite:IsEventTriggered("Sound") then
                npc:PlaySound(mod.Sounds.SplashLarge,0.6,0,false,1.2)
            elseif sprite:IsEventTriggered("NoDMG") then
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
            else
                mod:spritePlay(sprite, "Submerge")
            end
        elseif data.State == "Emerge" then
            if sprite:IsFinished("Emerge") then
                npc.StateFrame = mod:RandomInt(bal.diveWait, rng)
                npc.State = NpcState.STATE_MOVE
                npc.CollisionDamage = data.ThresherRestoreColl
                data.State = nil

                for _, suffix in pairs(suffixes) do
                    local _, attacksuffix = mod:KnightTargetCheck(npc, targetpos, suffix, false, npc.Size * 3, bal.diveRange)
                    if attacksuffix and room:CheckLine(npc.Position,targetpos,0,1,false,false) then
                        npc.TargetPosition = mod:SnapVector((targetpos - npc.Position), 90):Normalized()
                        npc.Velocity = npc.TargetPosition:Resized(10)
                        break
                    end
                end
            elseif sprite:IsEventTriggered("DMG") then
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                npc:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET)
            else
                mod:spritePlay(sprite, "Emerge")
            end
        end
    else
        npc.StateFrame = npc.StateFrame - 1
        if npc.StateFrame <= 0 then
            if room:HasWater()
            and npc.Position:Distance(targetpos) > bal.diveRange 
            and npc.State == NpcState.STATE_MOVE 
            and npc.TargetPosition:Length() <= 0.01 then
                sprite:RemoveOverlay()
                mod:spritePlay(sprite, "Submerge")
                data.State = "Submerge"
                npc.State = NpcState.STATE_JUMP
                data.ThresherRestoreColl = npc.CollisionDamage
                npc.CollisionDamage = 0
            else
                npc.StateFrame = mod:RandomInt(bal.diveWait, rng)
            end
        end
    end
end