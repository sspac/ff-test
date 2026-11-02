local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

function mod:psychicGaperAI(npc)
    local target = npc:GetPlayerTarget()

	npc.Color = Color(1,0,1,1)
	
    local targvel = (target.Position - npc.Position)
    local dist = targvel:Length()
    if dist < 1000 then
        npc.Velocity = mod:Lerp(npc.Velocity, targvel, 0.05)
    end
end

function mod:wallGaperAI(npc)
    local alignment = mod:GetClosestWall(npc.Position, true)
    local targetDirection = alignment[2]
    local d = mod:GetEntityData(npc)
    d.Direction = d.Direction or Vector(1, 0)
    d.Direction = mod:Lerp(d.Direction, Vector(1,0):Rotated(targetDirection * 90), 0.1)
    local rot = d.Direction:GetAngleDegrees()
    --print(npc:GetSprite().FlipX)
    if npc:GetSprite().FlipX then
        rot = d.Direction:GetAngleDegrees() * -1
    end
    npc.SpriteRotation = rot
end

mod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, function(_,npc)
    if npc.Variant == mod.FF.PennyGaper.Var and npc.State == NpcState.STATE_ATTACK5 then
        npc.Velocity = Vector.Zero
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        local sprite = npc:GetSprite()
        npc:SetShadowSize(0)
        if sprite:IsFinished("Collect") then
            npc:Remove()
        else
            mod:spritePlay(sprite, "Collect")
        end        
        return true
    end
end, EntityType.ENTITY_GAPER)

mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, function(_, npc, collider)
    if npc.Variant == mod.FF.PennyGaper.Var and collider:ToPlayer() then
        if npc.State ~= NpcState.STATE_ATTACK5 then
		    npc.State = NpcState.STATE_ATTACK5
            local sprite = npc:GetSprite()
            sprite:RemoveOverlay()
            sprite:Play("Collect", true)
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            npc:SetShadowSize(0)
            npc:PlaySound(SoundEffect.SOUND_PENNYPICKUP)
            collider:ToPlayer():AddCoins(1)
        end
	end
end, EntityType.ENTITY_GAPER)

