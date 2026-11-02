local mod = FiendFolio
local game = Game()

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, e)
    local data = mod:GetEntityData(e)
    if data.astroDust then
        local rng = e:GetDropRNG()
        local entry = data.astroDust
        e.Velocity = entry.vel
        entry.vel = entry.vel*0.98
        if entry.scale then
            e.SpriteScale = Vector(e.SpriteScale.X+0.05, e.SpriteScale.Y+0.02)
            if e.Color.A < 0.75 then
                e.Color = Color(e.Color.R,e.Color.G,e.Color.B,e.Color.A+0.05, 0,0,0)
            end
			if e.SpriteScale.X >= entry.scale then
				entry.scale = nil
			end
        end
        entry.lifespan = entry.lifespan-1
        --[[if entry.lifespan < 50 then
            e.Color = Color(e.Color.R,e.Color.G,e.Color.B,e.Color.A-0.008, 0,0,0)
            if e.Color.A <= 0 then
                e:Remove()
            end
        end]]

        if entry.lifespan % 22 == 0 then
            local star = Isaac.Spawn(1000, 1727, 0, e.Position+mod:shuntedPosition(20, rng), Vector.Zero, nil):ToEffect()
            --star.Color = Color(e.Color.R,e.Color.G,e.Color.B,0.5, 0,0,0)
            star.Color = Color(1,1,1,0.5,0,0,0)
            local scale = math.random(10,100)/100
            star.SpriteScale = Vector(scale, scale)
        end
    elseif data.cosmeticDust then
        local rng = e:GetDropRNG()
        local entry = data.cosmeticDust
        if entry.vel then
            e.Velocity = entry.vel
            if entry.slowdown then
                entry.vel = entry.vel*entry.slowdown
            else
                entry.vel = entry.vel*0.98
            end
        end
        if entry.scale then
            if e.Color.A < (entry.alpha or 0.75) then
                e.Color = Color(e.Color.R,e.Color.G,e.Color.B,e.Color.A+0.03, 0,0,0)
            end
			if e.SpriteScale.X >= entry.scale then
				e.SpriteScale = Vector(entry.scale, entry.scale)
            else
                entry.initScale = entry.initScale or Vector(e.SpriteScale.X, e.SpriteScale.Y)
                entry.initScale = Vector(entry.initScale.X+0.02, entry.initScale.Y+0.02)
                e.SpriteScale = entry.initScale
            end
        end
        if entry.customEffect then
            entry.customEffect()
        end
    elseif data.holyWobblesDust then
        local rng = e:GetDropRNG()
        local entry = data.holyWobblesDust
        e.Velocity = entry.vel
        entry.vel = entry.vel*0.98
        if entry.scale then
            e.SpriteScale = Vector(e.SpriteScale.X+0.05, e.SpriteScale.Y+0.02)
            local num = 0.2
            if entry.beam then
                num = 0.35
            end
            if e.Color.A < num then
                e.Color = Color(e.Color.R,e.Color.G,e.Color.B,e.Color.A+0.05, e.Color.RO,e.Color.GO,e.Color.BO)
            end
			if e.SpriteScale.X >= entry.scale then
				entry.scale = nil
			end
        end
        if e.SpriteOffset.Y < 0 then
            local num = 1
            if entry.beam then
                num = 0.5
            end
            e.SpriteOffset = Vector(e.SpriteOffset.X, e.SpriteOffset.Y+num)
        end
        entry.lifespan = entry.lifespan-1
        --[[if entry.lifespan < 50 then
            e.Color = Color(e.Color.R,e.Color.G,e.Color.B,e.Color.A-0.008, 0,0,0)
            if e.Color.A <= 0 then
                e:Remove()
            end
        end]]

        if entry.lifespan % 55 == 0 then
            local star = Isaac.Spawn(1000, 1727, 0, e.Position+mod:shuntedPosition(20, rng), Vector.Zero, nil):ToEffect()
            --star.Color = Color(e.Color.R,e.Color.G,e.Color.B,0.5, 0,0,0)
            star.Color = Color(1,1,1,e.Color.A,0,0,0)
            local scale = math.random(10,100)/100
            star.SpriteScale = Vector(scale, scale)
        end

        if entry.npc and entry.npc:Exists() then
            if mod:GetEntityData(entry.npc).gassing and not data.expired then
                e:SetTimeout(entry.timeout)
            else
                data.expired = true
            end
        end
        local room = game:GetRoom()
        if e.Timeout == 40 and entry.beam and entry.npc and not room:IsClear() then
            local beam = Isaac.Spawn(1000, mod.FF.HolyWobblesBeam.Var, mod.FF.HolyWobblesBeam.Sub, e.Position+mod:shuntedPosition(10,rng), Vector.Zero, entry.npc):ToEffect()
            beam.Color = Color(1,0.8,0.3,1,0.2,0.3,0.3)
            beam.SpriteScale = Vector(0.2,1)
            beam.SpriteOffset = Vector(0, -5)
            beam.Scale = 0.3
            beam.Size = 0.3
            beam.Parent = entry.npc
        end
    end
end, 59)