local mod = FiendFolio
local game = Game()

function mod:addToBadBagTrain(bag, npc)
    local d = mod:GetEntityData(npc)
    d.badBagFamiliarTrain = d.badBagFamiliarTrain or {}
    local key = #d.badBagFamiliarTrain+1
    d.badBagFamiliarTrain[key] = bag
    mod:GetEntityData(bag).currentBadBagNumber = key
end

function mod:badBagAI(npc)
    local sprite = npc:GetSprite()
    local d = mod:GetEntityData(npc)
    local target = npc:GetPlayerTarget()
    local rng = npc:GetDropRNG()
    local room = game:GetRoom()

    if not d.init then
        if npc.SubType == 0 then
            npc.Parent = mod:getNearestSpecturnTargets(npc.Position, 1, 0)[1]
            if npc.Parent and mod:superExists(npc.Parent) then
                mod:addToBadBagTrain(npc, npc.Parent)
            end
        else
            npc.Parent = mod.FindClosestEnemyEffigy(npc.Position)
            if npc.Parent and mod:superExists(npc.Parent) then
                mod:addToBadBagTrain(npc, npc.Parent)
            end
        end
        npc:AddEntityFlags(EntityFlag.FLAG_NO_REWARD | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS)
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        d.state = "Idle"
        
        d.init = true
    end

    if d.state == "Idle" then
        if npc.SubType == 0 then
            if not npc.Parent or not mod:superExists(npc.Parent) then
                d.state = "Spawn"
            end
        elseif npc.SubType == 1 then
            if not npc.Parent or not mod:superExists(npc.Parent) then
                npc.Parent = mod.FindClosestEnemyEffigy(npc.Position)
                if npc.Parent and mod:superExists(npc.Parent) then
                    mod:addToBadBagTrain(npc, npc.Parent)
                else
                    d.state = "Spawn"
                end
            end
        end

        if npc.Parent and mod:superExists(npc.Parent) then
            local pd = mod:GetEntityData(npc.Parent)
            pd.badBagFamiliarTrain = pd.badBagFamiliarTrain or {}
            if d.currentBadBagNumber and pd.badBagFamiliarTrain[d.currentBadBagNumber] and pd.badBagFamiliarTrain[d.currentBadBagNumber].InitSeed == npc.InitSeed then
                local pos = npc.Parent.Position
                if d.currentBadBagNumber > 1 then
                    if pd.badBagFamiliarTrain[d.currentBadBagNumber-1] and mod:superExists(pd.badBagFamiliarTrain[d.currentBadBagNumber-1]) then
                        pos = pd.badBagFamiliarTrain[d.currentBadBagNumber-1].Position
                    end
                end

                if npc.Position:Distance(pos) > 40 then
                    local extraLength = (pos-npc.Position)
                    if extraLength:Length() > 40 then
                        extraLength = extraLength:Resized(40)
                    end
                    local targetpos = npc.Position+extraLength
                    local vel = (targetpos-npc.Position)*0.2
                    if vel:Length() < npc.Parent.Velocity:Length() then
                        vel = vel:Resized(npc.Parent.Velocity:Length())
                    end
                    npc.Velocity = mod:Lerp(npc.Velocity, vel, 0.2)
                else
                    npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.1)
                end
            end

            if room:IsClear() then
                d.state = "Spawn"
            end
        else
            d.state = "Spawn"
        end


        mod:spritePlay(sprite, "Idle")
    elseif d.state == "Spawn" then
        if not d.badBagRandTimer then
            d.badBagRandTimer = rng:RandomInt(9)
        end
        if d.badBagRandTimer > 0 then
            d.badBagRandTimer = d.badBagRandTimer-1
        else
            if sprite:IsFinished("Death") then
                for i=1,4 do
                    local spd = mod:getRoll(3, 10, rng)/4
                    local vel = RandomVector():Resized(spd)
                    local dust = Isaac.Spawn(1000, EffectVariant.DUST_CLOUD, 0, npc.Position, vel, npc):ToEffect()
                    local de_dust = mod:GetEntityData(dust)
                    dust.Color = Color(0.2, 0.2, 0.2, 0.2, 0, 0, 0)
                    local scale = mod:getRoll(30,60,rng)/100
                    dust.SpriteScale = Vector(scale, scale)
                    dust:SetTimeout(mod:getRoll(35,50,rng))
                    de_dust.cosmeticDust = {vel = vel, scale = mod:getRoll(45,65,rng)/100, alpha = 0.6}
                    dust:Update()
                end

                npc:PlaySound(SoundEffect.SOUND_MUSHROOM_POOF, 0.6, 0, false, 1.5);

                npc:Remove()
            elseif sprite:IsEventTriggered("Troll") then
                local vel = mod:getRoll(20,55,rng)/10
                local bom = Isaac.Spawn(4, 3, 0, npc.Position, (target.Position-npc.Position):Resized(vel), npc)
                npc:PlaySound(SoundEffect.SOUND_FETUS_LAND, 1.6, 0, false, mod:getRoll(90,110,rng)/100)
            elseif sprite:IsEventTriggered("Sound") then
                npc:PlaySound(SoundEffect.SOUND_HELL_PORTAL1, 0.6, 0, false, mod:getRoll(100,120,rng)/100)
            else
                mod:spritePlay(sprite, "Death")
            end
        end

        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, 0.3)
    end
end