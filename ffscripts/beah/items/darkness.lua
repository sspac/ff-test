local mod = FiendFolio
local flag = TearFlagsLib.RegisterTearFlag("DARKNESS")
local game = Game()

local otherSpeedMult = 0.1
local function darknessTearUpdate(_, tear)
        local player = mod:getPlayerFromTear(tear)
        if not player then
            return
        end

        local t_data = mod:GetEntityData(tear)
        t_data.sw_drknessLastMult = t_data.sw_drknessLastMult or 1
        
        local p_data = mod:GetEntityData(player)
        local phase = p_data.ff_darknessActive or player:GetFireDirection() == Direction.NO_DIRECTION
        local expMult = phase and 1 or otherSpeedMult
        expMult = mod:Lerp(t_data.sw_drknessLastMult, expMult, 0.7333)
        local frames = math.max(0, tear.FrameCount-3)
        expMult = math.max(1-((frames^2)/10), expMult)

        t_data.sw_drknessLastMult = mod:MultiplyTearVelocity(tear, "sw_darkness", expMult, true)
        t_data.sw_drknessPhase = phase

        local cmult = (expMult-otherSpeedMult)/(1-otherSpeedMult)
        cmult = mod:Lerp(t_data.sw_drknessColourMult or cmult, cmult, 0.4)
        t_data.sw_drknessColourMult = cmult
        tear:SetColor(tear.Color*Color(cmult,cmult,cmult,math.min(1, cmult+0.3)), 2, 2, false, false)

        t_data.sw_fullDark = cmult <= otherSpeedMult
        --[[if not t_data.sw_drknessEffect then
            local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.EFFECTS.MOTV_HELPER,
            mod.MOTVHelperSubtypes.DARKNESSTRAIL, tear.Position, Vector.Zero, tear):ToEffect()
            effect.Parent = tear
            effect:FollowParent(tear)
            t_data.sw_drknessEffect = effect
        end
        t_data.sw_drknessEffect.ParentOffset = tear.PositionOffset]]
end

local function tearFlagComplex(_, entity, player, wflag)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.DARKNESS) then
        TearFlagsLib.AddTearFlags(entity, flag)
        if entity.Type == EntityType.ENTITY_TEAR then
            mod:AddToTearUpdateList("ff_darkness", entity, darknessTearUpdate)
        end
    end
end
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, mod.ITEM.COLLECTIBLE.DARKNESS, 			tearFlagComplex)
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_CHANCELESS_TEARFLAGS, mod.ITEM.COLLECTIBLE.DARKNESS, 	tearFlagComplex)

function mod.handleDarknessD3(entity)
	if entity.Type == EntityType.ENTITY_TEAR then
        mod:AddToTearUpdateList("ff_darkness", entity, darknessTearUpdate)
    end
end

local function preTearCollision(_, tear)
    local t_data = mod:GetEntityData(tear)
    if t_data.sw_drknessPhase ~= nil and not t_data.sw_drknessPhase then
            --[[if tear.FrameCount % 2 == 0 then
                other:TakeDamage(tear.CollisionDamage/5, 0, EntityRef(tear), 1)
            end]]

        return true
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, preTearCollision)

local frames = 8
local basedmg = 1
local floorScalar = 0.3
local function playerUpdate(_, player)
    if not player:HasCollectible(mod.ITEM.COLLECTIBLE.DARKNESS) then
        return
    end

    local p_data = mod:GetEntityData(player)
    p_data.ff_darknessActive = player:GetFireDirection() == Direction.NO_DIRECTION

    p_data.ff_darknessCooldown = (p_data.ff_darknessCooldown or 0) + 1
    if not p_data.ff_darknessActive then
        if p_data.ff_darknessCooldown >= frames then
            p_data.ff_darknessCooldown = -1

            --damage all enemies
            
            local level = game:GetLevel()
            local dmg = basedmg + (floorScalar*level:GetAbsoluteStage())
            
            local es = Isaac.FindInRadius(player.Position, 80000, 8)

            for index, value in ipairs(es) do
                if value:IsVulnerableEnemy() then
                    if value:TakeDamage(dmg, 0, EntityRef(player), 1) then
                        
                    end
                end
            end

            --hand vfx
            if not p_data.ff_darknessArms or not p_data.ff_darknessArms:Exists() then
                p_data.ff_darknessArms = mod:beahPoof(player.Position, mod.FF.DarknessPopup.Sub, player.Color)
                p_data.ff_darknessArms.Parent = player
                p_data.ff_darknessArms.DepthOffset = 500
            end
            local arms = p_data.ff_darknessArms

            local e_data = mod:GetEntityData(arms)
            e_data.ff_darknessAnim = (e_data.ff_darknessAnim or 0) + 1
            if e_data.ff_darknessAnim > 5 then
                e_data.ff_darknessAnim = 1
            end
            arms:GetSprite():Play("Main"..e_data.ff_darknessAnim, true)
        end
    elseif p_data.ff_darknessCooldown >= frames and p_data.ff_darknessArms then
        p_data.ff_darknessArms:Remove()
        p_data.ff_darknessArms = nil
    end

    --[[if p_data.ff_darknessArms ~= nil then
        --p_data.ff_darknessArms.ParentOffset = Vector(0, -24)
        p_data.ff_darknessArms.Position = player.Position + Vector(0, -50)
    end]]
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.DARKNESS, 		playerUpdate)

local function renderEffect(_, effect)
    if effect.SubType == 4 then
        effect.Position = effect.Parent.Position - Vector(0, 50)
    end
end
mod:AddEntityCallback(ModCallbacks.MC_PRE_EFFECT_RENDER, 1000, mod.FF.DarknessPopup.Var, mod.FF.DarknessPopup.Sub, renderEffect, mod.FF.DarknessPopup.Var)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.DARKNESS] = {
	TearDamage = 4.08,
	TearVelocity = 11.0,
	TearColor = FiendFolio.ColorDarknessTear, 
	BodyColor = Color(1,1,1,1,-83.496/255,-83.496/255,-83.496/255,1.327,1.327,1.327,1),
	EyeAColor = Color(1,1,1,1,-77.766/255,-39.734/255,-47.672/255,1.234,0.266,0.328,1),
	EyeBColor = Color(1,1,1,1,-77.766/255,-39.734/255,-47.672/255,1.234,0.266,0.328,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	TearFlagsLib.AddTearFlags(tear, TearFlagsLib.Flag.DARKNESS)
	mod:AddToTearUpdateList("ff_darkness", tear, darknessTearUpdate)
end, FiendFolio.ITEM.COLLECTIBLE.DARKNESS)