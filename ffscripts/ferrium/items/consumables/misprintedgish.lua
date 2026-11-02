local mod = FiendFolio
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
    local gish = Isaac.Spawn(3, mod.ITEM.FAMILIAR.MISPRINTED_GISH, 0, player.Position, Vector.Zero, player):ToFamiliar()
    gish.Parent = player
    gish:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    gish.Visible = false
end, mod.ITEM.CARD.MISPRINTED_GISH)

local gishPoof = Color(3, 3, 3, 1)
gishPoof:SetColorize(0.03, 0.03, 0.03, 1)
local gishProj = Color(1, 1, 1, 1)
gishProj:SetColorize(0.5, 0.5, 0.5, 1)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
    local player = fam.Player
	local d = mod:GetEntityData(fam)
	local sprite = fam:GetSprite()
    
    if not d.target or not mod:superExists(d.target) then
        d.target = (mod.FindRandomEnemy(player.Position, nil, true) or player)
    end

    if not d.init then
        d.state = "Land"
        fam.Coins = 0
        fam.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        fam.Position = d.target.Position
        fam.SpriteScale = Vector(1, 1.25)
        sprite:Play("JumpDown", true)
        fam.SpriteOffset = Vector(20, 0)
        d.init = true
    else
        fam.Coins = fam.Coins+1
    end

    --Nevermind, he looked weird switching directions
    --fam.FlipX = fam.Velocity.X > 0
    --fam.SpriteOffset = (fam.Velocity.X > 0 and Vector(20, 0)) or Vector(-20, 0)

    if d.state == "Land" then
        if fam.FrameCount > 5 and fam.Visible == false then
            fam.Visible = true
        end
        if sprite:IsFinished("JumpDown") then
            d.state = "Shoot"
        elseif sprite:IsEventTriggered("Land") then
            d.landed = true
            fam.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
            sfx:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1)
            local creep = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_BLACK, 0, fam.Position, Vector.Zero, fam):ToEffect()
            creep:SetTimeout(250)
            creep.SpriteScale = Vector(4, 4)
            creep:Update()

            local poof = Isaac.Spawn(1000, EffectVariant.POOF02, 3, fam.Position, Vector.Zero, fam):ToEffect()
            local poof2 = Isaac.Spawn(1000, EffectVariant.POOF02, 4, fam.Position, Vector.Zero, fam):ToEffect()
            poof.Color = gishPoof
            poof2.Color = gishPoof
            poof:Update()
            poof2:Update()
            Game():MakeShockwave(fam.Position, 0.06, 0.02, 6)

            for _, enemy in ipairs(Isaac.FindInRadius((fam.Position), fam.Size, EntityPartition.ENEMY)) do
                if enemy:IsActiveEnemy() and (not mod:isFriend(enemy)) and enemy:IsVulnerableEnemy() then
                    enemy:TakeDamage(100, 0, EntityRef(fam), 0)
                end
            end
            for _,grid in ipairs(mod.GetGridEntities()) do
				if grid.Position:Distance(fam.Position) < 65 then
					grid:Destroy()
				end
			end
        else
            mod:spritePlay(sprite, "JumpDown")
        end

        if not d.landed then
            fam.Velocity = mod:Lerp(fam.Velocity, (d.target.Position-fam.Position):Resized(5), 0.1)
        else
            fam.Velocity = mod:Lerp(fam.Velocity, Vector.Zero, 0.3)
        end
    elseif d.state == "Shoot" then
        if sprite:IsFinished("Taunt") then
            d.state = "Leave"
        elseif sprite:IsEventTriggered("Shoot") then
            local tab = {death = function(v)
                local creep = Isaac.Spawn(1000, EffectVariant.PLAYER_CREEP_BLACK, 0, v.Position, Vector.Zero, v):ToEffect()
                creep:SetTimeout(250)
                creep.SpriteScale = Vector(4, 4)
                creep:Update()
            end}

            local vec = (d.target.Position-fam.Position)*0.04
            if vec:Length() > 10 then
                vec = vec:Resized(10)
            elseif vec:Length() < 4 then
                vec = vec:Resized(4)
            end

            local tear = Isaac.Spawn(2, 1, 0, fam.Position, vec, fam):ToTear()
            tear.FallingAcceleration = 1.02
            tear.FallingSpeed = -25
            tear.Scale = 1.5
            tear.Color = gishProj
            tear.CollisionDamage = 50
            tear:AddTearFlags(TearFlags.TEAR_EXPLOSIVE)
            mod:GetEntityData(tear).dontHurtPlayerExplosive = true
            mod:TryToAddTearBehavior(tear, mod:GetEntityData(tear), tab)
            tear:Update()
        else
            mod:spritePlay(sprite, "Taunt")
        end

        fam.Velocity = mod:Lerp(fam.Velocity, Vector.Zero, 0.3)
    elseif d.state == "Leave" then
        if sprite:IsFinished("JumpUp") then
            fam:Remove()
        elseif sprite:IsEventTriggered("Jump") then
            fam.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            sfx:Play(SoundEffect.SOUND_BOSS_LITE_ROAR, 1, 0, false, 1)
        else
            mod:spritePlay(sprite, "JumpUp")
        end

        fam.Velocity = mod:Lerp(fam.Velocity, Vector.Zero, 0.3)
    end
end, mod.ITEM.FAMILIAR.MISPRINTED_GISH)