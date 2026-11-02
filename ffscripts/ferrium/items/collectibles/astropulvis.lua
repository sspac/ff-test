local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, item, rng, player, useflags, activeSlot)
    local virtues = player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES)

    local ghosty = {}
    for _,ghost in ipairs(Isaac.FindByType(mod.FF.AstropulvisGhost.ID, mod.FF.AstropulvisGhost.Var, mod.FF.AstropulvisGhost.Sub, false, false)) do
        table.insert(ghosty, ghost)
    end
    local rocks = false
    for key,rock in pairs(mod.astropulvisRocks) do
        rocks = true
        break
    end
    if #ghosty == 0 and rocks == false then
        local radius = 9999
        local chosenGrid
        for _,grid in ipairs(mod.GetGridEntities()) do
            if grid.CollisionClass == GridCollisionClass.COLLISION_SOLID and grid.Position:Distance(player.Position) < radius and mod.astropulvisRocks[grid:GetGridIndex()] == nil and mod.gridToProjectile[grid:GetType()] ~= nil then
                chosenGrid = grid
                radius = grid.Position:Distance(player.Position)
            end
        end
        if chosenGrid then
            local chosenIndex = chosenGrid:GetGridIndex()
            mod.astropulvisRocks[chosenIndex] = {player = player, grid = chosenGrid, index = chosenGrid:GetGridIndex(), frame = 0, rng = rng}
            --[[chosenGrid:Destroy()
            data.astropulvisGhost = Isaac.Spawn(mod.FF.AstropulvisGhost.ID, mod.FF.AstropulvisGhost.Var, mod.FF.AstropulvisGhost.Sub, chosenGrid.Position, Vector(0,5):Rotated(rng:RandomInt(360)), player)]]
        end
        return {Discharge = false, Remove = false, ShowAnim = true}
    elseif #ghosty > 0 then
        for _,ghost in ipairs(ghosty) do
            if ghost:Exists() then
                mod:GetEntityData(ghost).state = "Explode"
                if virtues then
                    mod:GetEntityData(ghost).spawnWisp = true
                    mod:GetEntityData(ghost).spawnWispPlayer = player
                end
                if mod:playerIsBelialMode(player) then
                    mod:GetEntityData(ghost).belialExplosion = true
                end
                if player:HasTrinket(FiendFolio.ITEM.ROCK.ELECTRUM) then
                    local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.ELECTRUM)
                    mod:alternateElectrumShock(player, rng, player.Damage*mult+6*Game():GetLevel():GetAbsoluteStage()/2, ghost.Position, 3)
                end
            end
        end

        for _,wisp in ipairs(Isaac.FindByType(3, FamiliarVariant.WISP, FiendFolio.ITEM.COLLECTIBLE.ASTROPULVIS, false, false)) do
            local explosion = Isaac.Spawn(1000, 144, 1, wisp.Position, Vector.Zero, wisp):ToEffect()
            explosion.CollisionDamage = player.Damage+3*Game():GetLevel():GetAbsoluteStage()/2
            explosion.SpriteScale = Vector(0.7, 0.7)
            sfx:Play(SoundEffect.SOUND_DEMON_HIT, 0.3, 0, false, 1.5)
            wisp:Remove()
        end
    else
        return {Discharge = false, Remove = false, ShowAnim = false}
    end
    return true
end, FiendFolio.ITEM.COLLECTIBLE.ASTROPULVIS)

function mod:astropulvisGhostEffect(e)
    local data = mod:GetEntityData(e)
    local rng = e:GetDropRNG()
    local sprite = e:GetSprite()

    if not data.init then
        data.anim = rng:RandomInt(3)+1
        data.state = "Idle"
        data.init = true
    end

    if e.Velocity:Length() > 0.5 then
        if e.Velocity.X > 0 then
            sprite.FlipX = false
        else
            sprite.FlipX = true
        end
    end

    if data.state == "Idle" then
        mod:spritePlay(sprite, "Idle" .. data.anim)
    elseif data.state == "Explode" then
        if sprite:IsFinished("Explode" .. data.anim) then
            local rangle = rng:RandomInt(360)
            for i=120,360,120 do
                local newPos = e.Position+Vector(0,50):Rotated(i+rangle)
                local explosion = Isaac.Spawn(1000, 144, 1, newPos, Vector.Zero, e):ToEffect()
                local extDam = 0
                if data.player then
                    extDam = data.player.Damage
                else
                    extDam = 5
                end
                explosion.CollisionDamage = extDam+8*Game():GetLevel():GetAbsoluteStage()/2

                if data.belialExplosion then
                    local newPos2 = e.Position+Vector(0,100):Rotated(i+rangle)
                    local explosion2 = Isaac.Spawn(1000, 144, 1, newPos2, Vector.Zero, e):ToEffect()
                    explosion2.CollisionDamage = extDam+6*Game():GetLevel():GetAbsoluteStage()/2
                    explosion2.SpriteScale = Vector(0.7, 0.7)
                end

                if data.spawnWisp then
                    local wisp = Isaac.Spawn(3, FamiliarVariant.WISP, FiendFolio.ITEM.COLLECTIBLE.ASTROPULVIS, e.Position, Vector.Zero, data.spawnWispPlayer):ToFamiliar()
                    wisp.Player = data.spawnWispPlayer
                    data.spawnWisp = nil
                end
                --[[for _, enemy in ipairs(Isaac.FindInRadius(newPos, 30, EntityPartition.ENEMY)) do
					if enemy:IsActiveEnemy() and (not mod:isFriend(enemy)) and enemy:IsVulnerableEnemy() then
						local damage = (data.player.Damage or 5)+10
						enemy:TakeDamage(damage, DamageFlag.DAMAGE_EXPLOSION | DamageFlag.DAMAGE_IGNORE_ARMOR, EntityRef(bomb), 0)
					end
				end]]
            end
            sfx:Play(SoundEffect.SOUND_DEMON_HIT, 1, 0, false, 1)
            e:Remove()
        else
            mod:spritePlay(sprite, "Explode" .. data.anim)
        end
    end
    e.Velocity = mod:Lerp(e.Velocity, Vector.Zero, 0.1)
end

function mod:astropulvisGhostInit(e)
    local data = mod:GetEntityData(e)
    local rng = e:GetDropRNG()
    local sprite = e:GetSprite()

    if not data.init then
        data.anim = rng:RandomInt(3)+1
        data.state = "Idle"
        data.init = true
    end

    if e.Velocity:Length() > 0.5 then
        if e.Velocity.X > 0 then
            sprite.FlipX = false
        else
            sprite.FlipX = true
        end
    end

    mod:spritePlay(sprite, "Idle" .. data.anim)
end

function mod:astropulvisRockDestroy(entry)
    if entry.frame < 30 then
        if entry.grid and entry.grid.CollisionClass == GridCollisionClass.COLLISION_SOLID then
            entry.grid:GetSprite().Color = Color(1,1,1,1,(entry.frame*4)/255,0,0)
        else
            if entry.grid then
                entry.grid:GetSprite().Color = Color(1,1,1,1,0,0,0)
            end
            mod.astropulvisRocks[entry.index] = nil
        end
        entry.frame = entry.frame+1
    else
        if entry.grid and entry.grid.CollisionClass == GridCollisionClass.COLLISION_SOLID then
            entry.grid:GetSprite().Color = Color(1,1,1,0,0,0,0)
            entry.grid:Destroy()
            local ghostvec = Vector(0,5):Rotated(entry.rng:RandomInt(360))
            local target = mod.FindClosestEnemy(entry.grid.Position, 250, true)
            if target then
                ghostvec = (target.Position - entry.grid.Position):Resized(5)
            end
            local ghost = Isaac.Spawn(mod.FF.AstropulvisGhost.ID, mod.FF.AstropulvisGhost.Var, mod.FF.AstropulvisGhost.Sub, entry.grid.Position, ghostvec, entry.player)
            mod:GetEntityData(ghost).player = entry.player

            for i=1,7 do
                local randVel = RandomVector()*math.random(10,30)/20
                local cloud = Isaac.Spawn(1000, 59, 0, entry.grid.Position, Vector.Zero, nil):ToEffect()
                cloud:SetTimeout(math.random(60,200))
                --local color = Color(0.6,0,0,0,0,0,0)
                local color = Color(0.2,0,0.1,0,0,0,0)
                cloud.Color = color
                local randScale = math.random(50,200)/100
                cloud.SpriteScale = Vector(0.5, 0.5)
                mod:GetEntityData(cloud).astroDust = {scale = randScale, vel = randVel, lifespan = math.random(60,200)}
            end
        end
        mod.astropulvisRocks[entry.index] = nil
    end
end