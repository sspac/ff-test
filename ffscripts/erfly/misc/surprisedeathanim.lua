local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local ANIMCHANCE = 10000

function mod:surpriseDeathAnimAI(e)
    local d, sprite = mod:GetEntityData(e), e:GetSprite()

    d.Anim = d.Anim or "Gaper"
    if not d.init then
        if e:GetDropRNG():RandomInt(2) == 0 then
            sprite.FlipX = true
        end
        d.init = true
    end

    if sprite:IsFinished(d.Anim) then
        if d.Anim == "Mushroom" then
            e:Remove()
        end
    else
        mod:spritePlay(sprite, d.Anim)
    end

    if e.FrameCount > 50 then
		local removal = (e.FrameCount - 50) / 100
		removal = math.min(0.3, removal)
		e.Color = Color(1 - removal, 1 - removal, 1- removal, 1, 0, 0, 0)
	end

	if e.FrameCount == 50 then
		local vec = Vector(0, -10)
		for i = 1, 1 + e:GetDropRNG():RandomInt(6) do
			Isaac.Spawn(1000, 33, 0, e.Position + vec, Vector.Zero, e):ToEffect()
		end
		for i = 1, 1 + e:GetDropRNG():RandomInt(6) do
			Isaac.Spawn(1000, 21, 0, e.Position + vec, Vector.Zero, e):ToEffect()
		end
	end
end

function mod:SurpriseDeathAnimGaper(npc)
    if npc:IsDead() and (not npc:IsChampion()) and npc:GetDropRNG():RandomInt(ANIMCHANCE) == 0 then
        local spritePath = npc:GetSprite():GetLayer(0):GetSpritesheetPath()
        if spritePath == "gfx/Monsters/Classic/Monster_000_Bodies01.png" then --Not in downpour
            local animChoice = "Frowning Gaper"
            local DepthOffset = 0
            if npc.Variant == 1 then
                animChoice = "Gaper"
                DepthOffset = -5
            end
        
            local DeathAnim = Isaac.Spawn(mod.FF.SurpriseDeathAnim.ID, mod.FF.SurpriseDeathAnim.Var, mod.FF.SurpriseDeathAnim.Sub, npc.Position, Vector.Zero, npc):ToEffect()
            mod:GetEntityData(DeathAnim).Anim = animChoice
            DeathAnim.DepthOffset = DepthOffset
            DeathAnim:Update()
        end
    end
end

function mod:SurpriseDeathAnimFatty(npc)
    if npc.SubType == 0 and npc:IsDead() and (not npc:IsChampion()) and npc:GetDropRNG():RandomInt(ANIMCHANCE) == 0 then
        local DeathAnim = Isaac.Spawn(mod.FF.SurpriseDeathAnim.ID, mod.FF.SurpriseDeathAnim.Var, mod.FF.SurpriseDeathAnim.Sub, npc.Position, Vector.Zero, npc):ToEffect()
        mod:GetEntityData(DeathAnim).Anim = "Fatty"
        DeathAnim.DepthOffset = -10
        DeathAnim:Update()
    end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == 0 and npc.SubType == 0 and npc:IsDead() and (not npc:IsChampion()) and npc:GetDropRNG():RandomInt(ANIMCHANCE) == 0 then
        local DeathAnim = Isaac.Spawn(mod.FF.SurpriseDeathAnim.ID, mod.FF.SurpriseDeathAnim.Var, mod.FF.SurpriseDeathAnim.Sub, npc.Position, Vector.Zero, npc):ToEffect()
        mod:GetEntityData(DeathAnim).Anim = "Mushroom"
        DeathAnim:Update()
    end
end, EntityType.ENTITY_MUSHROOM)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == 1 and npc.SubType == 0 and npc:IsDead() and (not npc:IsChampion()) and npc:GetDropRNG():RandomInt(ANIMCHANCE) == 0 then
        local DeathAnim = Isaac.Spawn(mod.FF.SurpriseDeathAnim.ID, mod.FF.SurpriseDeathAnim.Var, mod.FF.SurpriseDeathAnim.Sub, npc.Position, Vector.Zero, npc):ToEffect()
        mod:GetEntityData(DeathAnim).Anim = "Eye"
        DeathAnim.DepthOffset = -5
        DeathAnim:Update()
    end
end, EntityType.ENTITY_EYE)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == 0 and npc.SubType == 0 and npc:IsDead() and (not npc:IsChampion()) and npc:GetDropRNG():RandomInt(ANIMCHANCE) == 0 then
        local DeathAnim = Isaac.Spawn(mod.FF.SurpriseDeathAnim.ID, mod.FF.SurpriseDeathAnim.Var, mod.FF.SurpriseDeathAnim.Sub, npc.Position, Vector.Zero, npc):ToEffect()
        mod:GetEntityData(DeathAnim).Anim = "Half Sack"
        DeathAnim.DepthOffset = -7
        DeathAnim:Update()
    end
end, EntityType.ENTITY_HALF_SACK)