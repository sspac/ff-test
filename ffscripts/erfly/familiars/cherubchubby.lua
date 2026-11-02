local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, f)
    f.IsFollower = true
end, mod.ITEM.FAMILIAR.CHERUB_CHUBBY)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
	local d = mod:GetEntityData(fam)
	local sprite = fam:GetSprite()

    if (not d.state) or game:GetRoom():GetFrameCount() == 0 then
		d.state = "idle"
        d.Trail = nil
        d.OldTrail = nil
        d.CoolDown = 10
    end

    if d.state == "idle" then
        if not d.followParent then
			fam:AddToFollowers()
			d.followParent = true
		end
        fam:FollowParent()
        if d.CoolDown then
            d.CoolDown = d.CoolDown - 1
            if d.CoolDown <= 0 then
                d.CoolDown = nil
            end
        else
            local dir = fam.Player:GetFireDirection()
            local isKingBabyTarget = mod:isKingBabyAParent(fam, true)
            local playerMarked = fam.Player:HasCollectible(CollectibleType.COLLECTIBLE_MARKED)
            if dir >= 0 then
                d.FireDir = dir
                d.StartPos = fam.Position
                local targPos
                if isKingBabyTarget then
                    targPos = isKingBabyTarget.Position
                elseif playerMarked then
                    targPos = mod.GetPlayerMarkedTarget(fam.Player).Position
                end
                local vec
                local vecLength = 250
                if targPos then
                    vec = (targPos - fam.Position):Resized(vecLength)
                else
                    vec = Vector(-vecLength,0):Rotated(90 * dir)
                end
                d.EndPos = fam.Position + vec
                d.state = "charge"
                sfx:Play(FiendFolio.TempSoundEnums.ChubbyFire,1,0,false,1.1)
    
                d.followParent = nil
                fam:RemoveFromFollowers()
            end
        end
    elseif d.state == "charge" then
        if not d.Trail then
            d.Trail = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.SPRITE_TRAIL,0,fam.Position,Vector.Zero,fam):ToEffect()
            d.Trail:FollowParent(fam)
            d.Trail.ParentOffset = Vector(0,-22)
            d.Trail.Color = Color(1,1,0.5,0.3)
            local radiiVal = 0.015
            if d.OldTrail then
                radiiVal = 0.05
            end
            d.Trail:SetRadii(radiiVal,radiiVal)
        end
        if d.counter or fam.Position:Distance(d.EndPos) < 10 then
            fam.Velocity = fam.Velocity * 0.5
            d.counter = d.counter or 0
            d.counter = d.counter + 1
            if d.counter > 10 then
                d.counter = nil
                if d.doingCross then
                    d.doingCross = nil
                    d.state = "idle"
                    d.CoolDown = 30
                    if d.Trail then
                        d.Trail:Remove()
                        d.Trail = nil
                    end
                    if d.OldTrail then
                        d.OldTrail:Remove()
                        d.OldTrail = nil
                    end
                else
                    if d.Trail then
                        d.OldTrail = d.Trail
                        d.Trail.Parent = nil
                        d.Trail = nil
                    end
                    local vec = d.EndPos - d.StartPos
                    local crossPoint = d.StartPos + (vec * 2/3)
                    local flipNess = 90
                    if fam:GetDropRNG():RandomInt(2) == 0 then
                        flipNess = -90
                    end
                    d.StartPos = crossPoint + (vec * 1/4):Rotated(flipNess)
                    d.EndPos = crossPoint + (vec * 1/4):Rotated(flipNess * -1)
                    d.state = "switchingPoint"
                end
            end
        else
            local vec = (d.EndPos - fam.Position):Resized(15)
            fam.Velocity = mod:Lerp(fam.Velocity, vec, 0.2)
        end
    elseif d.state == "switchingPoint" then
        local vec = (d.StartPos - fam.Position):Resized(30)
        fam.Velocity = mod:Lerp(fam.Velocity, vec, 0.2)
        if fam.Position:Distance(d.StartPos) < 10 then
            d.state = "charge"
            d.doingCross = true
            fam.Velocity = fam.Velocity * 0.1
            sfx:Play(FiendFolio.TempSoundEnums.ChubbyFire,1,0,false,0.9)
        end
    end

    sprite.FlipX = false
    if d.state == "idle" or d.state == "switchingPoint" then
        mod:spritePlay(sprite, "Float")
        fam.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    else
        fam.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
        if fam.Velocity:Length() > 0.1 then
            if math.abs(fam.Velocity.X) > math.abs(fam.Velocity.Y) then
                mod:spritePlay(sprite, "FloatShootSide")
                if fam.Velocity.X < 0 then
                    sprite.FlipX = true
                end
            else
                if fam.Velocity.Y > 0 then
                    mod:spritePlay(sprite, "FloatShootDown")
                else
                    mod:spritePlay(sprite, "FloatShootUp")
                end
            end
        end
    end
end, mod.ITEM.FAMILIAR.CHERUB_CHUBBY)