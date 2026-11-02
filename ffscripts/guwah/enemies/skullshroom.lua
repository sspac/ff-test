local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local params = ProjectileParams()
params.Variant = ProjectileVariant.PROJECTILE_BONE

function mod:SkullshroomAI(npc, sprite, data)
    if not data.Init then
        npc.SplatColor = Color(0.8,0.8,0.8)
    end

    if data.inMinecart and data.inMinecart:Exists() then
        npc.TargetPosition = data.inMinecart.Position
    end

    if sprite:IsEventTriggered("Shoot") then
        sfx:Stop(SoundEffect.SOUND_MEAT_JUMPS)
        npc:PlaySound(SoundEffect.SOUND_BONE_HEART,1,2,false,1.3)
        for _, proj in pairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE)) do
            if proj.FrameCount <= 0 and proj.SpawnerEntity and proj.SpawnerEntity.InitSeed == npc.InitSeed then
                local projectile = mod:FireProjectiles(npc, proj.Position, proj.Velocity:Resized(10):Rotated(-25), 0, params)
                projectile.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
                projectile.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                projectile.Height = -10
                projectile.DepthOffset = -80
                local s = projectile:GetSprite()
                s:Load("gfx/projectiles/boomerang rib big.anm2",true)
                s:Play("spin",false)
                projectile.Parent = npc
                projectile.FallingSpeed = 0
                projectile.FallingAccel = -0.1
                local pd = mod:GetEntityData(projectile)
                pd.projType = "boomerang2"
                pd.origpos = npc.Position
                pd.origparent = npc
                pd.fasterReturn = true
                pd.rot = 3
                pd.fadeOut = 4
                proj:Remove()
            end
        end
        for i = 1, 5 do
            local smoke = Isaac.Spawn(1000, mod.FF.FFWhiteSmoke.Var, mod.FF.FFWhiteSmoke.Sub, npc.Position, RandomVector() * mod:RandomInt(1,3), npc)
            mod:GetEntityData(smoke).longonly = true
            smoke.Color = Color(0.6,0.6,0.6)
			smoke:Update()
		end
    end
end

function mod:FadeIn(ent, length)
    length = length or 4
    local color = ent.Color
    ent:SetColor(Color(color.R,color.G,color.B,0,color.RO,color.GO,color.BO),length,1,true,true)
end

function mod:FadeOut(ent, length)
    length = length or 12
    local color = ent.Color
    ent.Color = Color(color.R,color.G,color.B,0,color.RO,color.GO,color.BO)
    ent:SetColor(color,length,1,true,true)
end