local mod = FiendFolio
local game = Game()
local nilvector = Vector.Zero

function mod:TinkleUpdate(npc)
	local d = mod:GetEntityData(npc)
	
	if not d.init then
		npc.SplatColor = mod.ColorLemonYellow
		d.init = true
	end

    if npc:IsDead() and mod:shouldDoDeathEffect(npc) then --Moving death logic here, this is how most of our enemies work -Guwah
        mod:TinkleDeath(npc)
    end
end

function mod:TinkleDeath(npc)
    local room = game:GetRoom()
    local r = npc:GetDropRNG()
    local params = ProjectileParams()
    params.Color = mod.ColorPeepPiss
    for i = 45, 360, 45 do
        local rand = r:RandomFloat()
        local projectile = npc:FireProjectilesEx(npc.Position, Vector(mod:RandomInt(1,3,r), 0):Rotated(i-40+rand*80), 0, params)[1]
        projectile.FallingSpeed = mod:RandomInt(-40,-10,r)
        projectile.FallingAccel = 2
            
        local d = mod:GetEntityData(projectile)
        d.projType = "Peepisser"
        d.detail = "Pee"
        d.creepTimeout = 150
        projectile:Update()
    end
        
    local effect = Isaac.Spawn(1000,EffectVariant.CREEP_YELLOW,0,npc.Position,Vector.Zero,npc):ToEffect()
    effect:SetTimeout(room:HasWater() and 1 or 150)
    effect.SpriteScale = Vector(2,2)
    effect:Update()
end

-- it's my first enemy, i heavily referenced mayfly, hyperbole, cathy and snake's enemies/file structures,
-- so thaaaaanks guwah, blor and snake for your work on the mod :)