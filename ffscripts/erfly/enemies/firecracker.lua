local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

function mod:firecrackerAI(npc)
	local sprite = npc:GetSprite()
	local d = mod:GetEntityData(npc)
    local target = npc:GetPlayerTarget()
    local targetpos = mod:randomConfuse(npc, target.Position)

    local vec = (targetpos - npc.Position):Resized(5)
    vec = mod:reverseIfFear(npc, vec)

    npc.Velocity = mod:Lerp(npc.Velocity, vec, 0.3)

    if npc.Velocity:Length() > 1 then
        if npc.Velocity.X > 0 then
            sprite.FlipX = true
        else
            sprite.FlipX = false
        end
    end

    mod:spritePlay(sprite, "Idle")

    if npc.FrameCount % 25 == 15 then
		local numberofflames = 5
		for i = 1, numberofflames do
			local vec = Vector(6,0):Rotated((360/numberofflames) * i)
			local fire = Isaac.Spawn(1000,7005, 1, npc.Position, Vector(6,0):Rotated((360/numberofflames) * i), npc)
			fire:Update()
		end
	end


	if npc:IsDead() then
		npc:PlaySound(mod.Sounds.MadnessDeath, 1, 0, false, math.random(90,110)/150)

        local room = game:GetRoom()
        room:SpawnGridEntity(room:GetGridIndex(npc.Position), GridEntityType.GRID_PIT, 0, 1, 0)
		mod:UpdatePits(0)

        local wave = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE, 0, npc.Position, Vector.Zero, g):ToEffect()
        wave.Parent = npc
        wave.MaxRadius = 50

        local numberofflames = 12
		for i = 1, numberofflames do
			local vec = Vector(6,0):Rotated((360/numberofflames) * i)
			local fire = Isaac.Spawn(1000,7005, 1, npc.Position, Vector(6,0):Rotated((360/numberofflames) * i), npc)
			fire:Update()
		end
	end
end