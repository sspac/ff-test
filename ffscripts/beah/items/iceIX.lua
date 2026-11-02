local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

local radius = 110
local duration = 10
local freezeDur = 1.2 --in seconds

local baseDMG = 7
local floorDMG = 1.5

local function effectUpdate(_, effect)
    local e_data = mod:GetEntityData(effect)
    local pos = effect.Position

    if effect.FrameCount <= duration then
        e_data.iceIXBlacklist = e_data.iceIXBlacklist or {}
        
        local clearIceFlag = {}

        local enemies = Isaac.FindInRadius(pos, radius, 8)
        for index, value in ipairs(enemies) do
            if not value:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) and value:IsVulnerableEnemy()
            and not e_data.iceIXBlacklist[""..value.InitSeed] then
                value:AddFreeze(EntityRef(effect.SpawnerEntity), freezeDur*30)

                
                local level = game:GetLevel()
                local dmg = baseDMG + (floorDMG*level:GetAbsoluteStage())
                if value:TakeDamage(dmg, 0, EntityRef(effect.SpawnerEntity), 0) then
                    if not value:HasEntityFlags(EntityFlag.FLAG_ICE) then
                        value:AddEntityFlags(EntityFlag.FLAG_ICE)
                        table.insert(clearIceFlag, value)
                    end
                end

                e_data.iceIXBlacklist[""..value.InitSeed] = true
            end
        end

        --clearing projectiles
        local b = Isaac.FindInRadius(pos, radius, EntityPartition.BULLET)
        for _, v in ipairs(b) do
            if not v:IsDead() then
                v:Die()
            end
        end

        mod.scheduleForUpdate(function ()
            for _, value in ipairs(clearIceFlag) do
                value:ClearEntityFlags(EntityFlag.FLAG_ICE)
            end
        end, 2)
    else
        --cleanup
        effect:Remove()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, effectUpdate, mod.FF.IceIXBlast.Var)


local c = Color (1,1,1,1,0.3,0.3,0.3)
c:SetColorize(0.8,1,1,1)
mod:AddCallback("FF_CHARGE_CIRCLE_FIRED", function(_, player, entry, d)
    local effect = Isaac.Spawn(mod.FF.IceIXBlast.ID, mod.FF.IceIXBlast.Var, mod.FF.IceIXBlast.Sub, player.Position, Vector.Zero, player)
    effect.Visible = false

    --ripped from green bombs dr. fetus at peas' bequest
	local splash = Isaac.Spawn(1000, 12, 0, player.Position, Vector.Zero, player):ToEffect()
	splash.SpriteScale = Vector.One / 60 * 20 * radius / 20
	splash:GetSprite():Load("gfx/enemies/warden/cross.anm2", true)
	splash:GetSprite():Play(anim or "Impact")
	splash:GetSprite():GetLayer(0):SetVisible(false)
	splash:Die()
	splash.Color = Color(1,1,1,0.75,0,0,0,1,1,1,1)

    sfx:Play(mod.Sounds.IceIX)
    
end, mod.ITEM.COLLECTIBLE.ICE_IX)


local function yayyyyyyyy(_, player)
    player:SetColor(Color(1,1,1,1,0.3,0.3,0.35), 10, 15, true, false)
    sfx:Play(mod.Sounds.HeyFellas)
end
mod:AddCallback("FF_CHARGE_CIRCLE_CHARGED", yayyyyyyyy, mod.ITEM.COLLECTIBLE.ICE_IX)