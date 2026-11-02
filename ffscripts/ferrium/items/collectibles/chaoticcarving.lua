local mod = FiendFolio
local sfx = SFXManager()

local bal = {
    ExistTimes = {100, 90, 40},
    Radius = {100,80,80},
    BaseAura = 80,
    Chances = {40, 40},
    ConfuseDur = 50,
    CharmDur = 40,
    BerserkDur = 75,
    BossPetrifyDur = 35,
    
    DamageMult = 5,
    DamageDefault = 5,
    DamageScale = 5,
    DamageFlat = 20,
}

mod:AddCallback("FF_CHARGE_CIRCLE_FIRED", function(_, player, entry, d)
    local charge = entry.charged-1
    if charge > 0 then
        if charge == 3 then
            entry.layeredCharges = 2
        end
                
        local carving = Isaac.Spawn(mod.FF.ChaoticCarving.ID, mod.FF.ChaoticCarving.Var, mod.FF.ChaoticCarving.Sub, player.Position, Vector.Zero, player):ToEffect()
        local cd = mod:GetEntityData(carving)
        cd.CarvingType = charge
        carving.Parent = player
    end
end, mod.ITEM.COLLECTIBLE.CHAOTIC_CARVING)

function mod:ChaoticCarvingNewRoom(player, d)
    if d.customChargeBarTable then
        for _,entry in pairs(d.customChargeBarTable) do
            if entry.id == mod.ITEM.COLLECTIBLE.CHAOTIC_CARVING then
                entry.layeredCharges = 3
                break
            end
        end
    end
end

local subToAnim = {[1] = "Wood", [2] = "Stone", [3] = "Obsidian"}
local auraColor = Color(0.6, 0, 0.6, 0.6, 0.2, 0, 0.2)

function mod:ChaoticCarvingEffect(e)
    local d = mod:GetEntityData(e)
    local rng = e:GetDropRNG()
    local sprite = e:GetSprite()
    if not d.Init then
        d.StateFrame = 0
        d.State = "Appear"
        sprite.FlipX = rng:RandomInt(2) == 0
        d.CarvingType = d.CarvingType or 1
        d.AnimType = subToAnim[d.CarvingType] .. rng:RandomInt(2)+1
        local mult = 1
        if e.Parent and e.Parent:ToPlayer() then
            local player = e.Parent:ToPlayer()
            local num = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.CHAOTIC_CARVING)-1
            mult = mult+0.5*num
        end
        d.CarvingTime = bal.ExistTimes[d.CarvingType]*mult
        d.Init = true
    else
        d.StateFrame = d.StateFrame+1
    end

    local die
    if mod:superExists(e.Parent) and e.Parent:ToPlayer() then
        if d.State == "Appear" then
            if sprite:IsFinished("Appear" .. d.AnimType) then
                d.State = "Idle"
            elseif sprite:IsEventTriggered("Drop") then
                sfx:Play(SoundEffect.SOUND_STONE_IMPACT, 1, 0, false, 1)
                d.CarvingActive = true
            else
                mod:spritePlay(sprite, "Appear" .. d.AnimType)
            end
        elseif d.State == "Idle" then
            if d.StateFrame > d.CarvingTime then
                d.State = "Dying"
            end
            mod:spritePlay(sprite, "Idle" .. d.AnimType)
        elseif d.State == "Dying" then
            if sprite:IsFinished("Die" .. d.AnimType) then  
                if d.CarvingType == 3 then
                    d.AndSheKnewTheWholeWorldWasHerCanvas = true
                    sfx:Play(mod.Sounds.WarpZonePhase, 0.2, 0, false, 0.85)
                else
                    if d.CarvingAura and d.CarvingAura:Exists() then
                        d.CarvingAura:Remove()
                    end
                    d.CarvingAura = nil
                    d.CarvingActive = false
                end
                die = true
            else
                mod:spritePlay(sprite, "Die" .. d.AnimType)
            end
        end
    else
        if sprite:IsFinished("Die" .. d.AnimType) then
            die = true
        else
            mod:spritePlay(sprite, "Die" .. d.AnimType)
        end
    end

    if d.CarvingActive and e.Parent and e.Parent:ToPlayer() and e.Parent:Exists() then
        local player = e.Parent:ToPlayer()
        local mult = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.CHAOTIC_CARVING)
        local rad = bal.Radius[d.CarvingType]*(1+0.5*(mult-1))
        local scale = (rad/bal.BaseAura)
        if not d.CarvingAura then
            d.CarvingAura = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HALLOWED_GROUND, 0, e.Position, Vector.Zero, e):ToEffect()
			d.CarvingAura:FollowParent(e)
			d.CarvingAura.DepthOffset = -100
			d.CarvingAura.Color = auraColor
            d.CarvingAura.SpriteScale = Vector(scale, scale)
            d.CarvingAura:Update()
        elseif scale ~= d.CarvingAura.SpriteScale.X then
            d.CarvingAura.SpriteScale = Vector(scale, scale)
        end

        if d.CarvingType == 1 then
            local secondMult = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND)+0.5
            local tMult = (secondMult+mult*0.5)
            for _,entity in ipairs(Isaac.FindInRadius(e.Position, rad, EntityPartition.ENEMY)) do
                if entity:IsActiveEnemy() and (not mod:isFriend(entity)) and (not entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)) then
                    local data = mod:GetEntityData(entity)
                    if not data.ChaoticCarvingEmotion then
                        local roll = rng:RandomInt(100)
                        if roll < bal.Chances[1] then
                            data.ChaoticCarvingEmotion = 1
                        elseif roll < bal.Chances[1]+bal.Chances[2] then
                            data.ChaoticCarvingEmotion = 2
                        else
                            data.ChaoticCarvingEmotion = 3
                        end
                    end
                    if data.ChaoticCarvingEmotion == 1 and not entity:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then --Confuse
                        entity:AddConfusion(EntityRef(e.Parent), math.ceil(bal.ConfuseDur*tMult), false)
                    elseif data.ChaoticCarvingEmotion == 2 and not entity:HasEntityFlags(EntityFlag.FLAG_CHARM) then --Charm
                        entity:AddCharmed(EntityRef(e.Parent), math.ceil(bal.CharmDur*tMult))
                    elseif data.ChaoticCarvingEmotion == 3 and not data.FFBerserkDuration then --Berserk
                        mod.AddBerserk(entity, e.Parent, math.ceil(bal.BerserkDur*tMult))
                    end
                end
            end
        else
            for _,entity in ipairs(Isaac.FindInRadius(e.Position, rad, EntityPartition.ENEMY)) do
                if entity:IsActiveEnemy() and (not mod:isFriend(entity)) and (not entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)) then
                    if entity:IsVulnerableEnemy() and entity.EntityCollisionClass > EntityCollisionClass.ENTCOLL_PLAYERONLY and not entity:HasEntityFlags(EntityFlag.FLAG_FREEZE) then
                        if entity:IsBoss() then
                            entity:AddFreeze(EntityRef(e.Parent), bal.BossPetrifyDur)
                        else
                            entity:AddFreeze(EntityRef(e.Parent), 2)
                        end
                    end
                end
            end
        end
    end

    if die and not d.Died then
        d.Died = true
        if d.CarvingAura and d.CarvingAura:Exists() then
            d.CarvingAura:Remove()
        end
        d.CarvingAura = nil
        if d.CarvingType == 1 then
            for i=0,3 do
                local vel = Vector(mod:RandomInt(5,50,rng)/10, 0):Rotated(rng:RandomInt(360))
                local gibs = Isaac.Spawn(1000, 4, 0, e.Position, vel, e):ToEffect()
                local gSprite = gibs:GetSprite()
                gibs:Update()
                gSprite:SetFrame("rubble", rng:RandomInt(4)+1)
                gSprite:ReplaceSpritesheet(0, "gfx/grid/rocks_burningbasement.png")
                --gSprite.Rotation = rng:RandomInt(360)
                gSprite:LoadGraphics()
                gibs:Update()
            end
            for i=1,2 do
                local randVel = Vector(mod:RandomInt(10,25,rng)/20, 0):Rotated(rng:RandomInt(360))
                local cloud = Isaac.Spawn(1000, 59, 0, e.Position, Vector.Zero, e):ToEffect()
                local life = mod:RandomInt(60,90,rng)
                cloud:SetTimeout(life)
                local color = Color(0.5,0.5,0.5,0.3,0,0,0)
                cloud.Color = color
                local randScale = mod:RandomInt(70,90,rng)/100
                cloud.SpriteScale = Vector(randScale, randScale)
                mod:GetEntityData(cloud).cosmeticDust = {scale = randScale, vel = randVel, lifespan = life, alpha = 0.65}
                cloud.SpriteOffset = Vector(0, -15)
            end
            sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 0.6, 0, false, 1)
            e:Remove()
        elseif d.CarvingType == 2 then
            for i=0,3 do
                local vel = Vector(mod:RandomInt(5,50,rng)/10, 0):Rotated(rng:RandomInt(360))
                local gibs = Isaac.Spawn(1000, 4, 0, e.Position, vel, e):ToEffect()
                local gSprite = gibs:GetSprite()
                gibs:Update()
                gSprite:SetFrame("rubble_alt", rng:RandomInt(4)+1)
                gSprite:ReplaceSpritesheet(0, "gfx/grid/rocks_ed12.png")
                --gSprite.Rotation = rng:RandomInt(360)
                gSprite:LoadGraphics()
                gibs:Update()
            end
            for i=1,2 do
                local randVel = Vector(mod:RandomInt(10,25,rng)/20, 0):Rotated(rng:RandomInt(360))
                local cloud = Isaac.Spawn(1000, 59, 0, e.Position, Vector.Zero, e):ToEffect()
                local life = mod:RandomInt(60,90,rng)
                cloud:SetTimeout(life)
                local color = Color(0.5,0.5,0.5,0.3,0,0,0)
                cloud.Color = color
                local randScale = mod:RandomInt(70,90,rng)/100
                cloud.SpriteScale = Vector(randScale, randScale)
                mod:GetEntityData(cloud).cosmeticDust = {scale = randScale, vel = randVel, lifespan = life, alpha = 0.65}
                cloud.SpriteOffset = Vector(0, -15)
            end
            sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 0.6, 0, false, 1)
            e:Remove()
        else
            if d.AndSheKnewTheWholeWorldWasHerCanvas then
                local mult = 1
                if e.Parent and e.Parent:ToPlayer() and e.Parent:Exists() then
                    local player = e.Parent:ToPlayer()
                    mult = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.CHAOTIC_CARVING)
                    local rad = bal.Radius[3]*(1+0.5*(mult-1))
                    local level = Game():GetLevel():GetAbsoluteStage()
                    local damage = player.Damage*bal.DamageMult+bal.DamageScale*level+bal.DamageFlat
                    for _,entity in ipairs(Isaac.FindInRadius(e.Position, rad, EntityPartition.ENEMY)) do
                        if entity:IsActiveEnemy() and (not mod:isFriend(entity)) and entity:IsVulnerableEnemy() then
                            if entity:IsBoss() then
                                entity:TakeDamage(damage, 0, EntityRef(player), 0)
                            else
                                if entity.HitPoints > damage then
                                    entity:TakeDamage(damage, 0, EntityRef(player), 0)
                                else
                                    local afterimage = Isaac.Spawn(mod.FF.GenericAfterimage.ID, mod.FF.GenericAfterimage.Var, mod.FF.GenericAfterimage.Sub, entity.Position, Vector.Zero, entity):ToEffect()
                                    mod:GetEntityData(afterimage).customAfterimageData = {
                                        timeout = 20, color = Color(0, 0, 0, 1, 0, 0, 0), fade = true, sprite = entity:GetSprite(),
                                    }
                                    afterimage.Parent = entity
                                    afterimage.PositionOffset = entity.PositionOffset
                                    afterimage.SpriteOffset = entity.SpriteOffset
                                    afterimage:GetSprite().FlipX = entity:GetSprite().FlipX
                                    afterimage.SpriteScale = entity.SpriteScale
                                    afterimage:Update()
                                    entity:Remove()
                                end
                            end
                        end
                    end
                end
            end
            
			local afterimage = Isaac.Spawn(mod.FF.GenericAfterimage.ID, mod.FF.GenericAfterimage.Var, mod.FF.GenericAfterimage.Sub, e.Position, Vector.Zero, e):ToEffect()
			mod:GetEntityData(afterimage).customAfterimageData = {
				timeout = 20, color = Color(0, 0, 0, 1, 0, 0, 0), fade = true, sprite = sprite,
			}
            afterimage:GetSprite().FlipX = sprite.FlipX
			afterimage.Parent = e
			afterimage:Update()
            e:Remove()
        end
    end
end

function mod:ChaoticCarvingPEffectUpdate(player)
    local d = mod:GetEntityData(player)
    if d.customChargeBarTable and not mod:IsActiveRoom() then
        for _,entry in pairs(d.customChargeBarTable) do
            if entry.id == mod.ITEM.COLLECTIBLE.CHAOTIC_CARVING then
                entry.layeredCharges = 3
                break
            end
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.CHAOTIC_CARVING, mod.ChaoticCarvingPEffectUpdate)