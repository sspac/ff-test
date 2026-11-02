local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

--[[function mod:utilityPoleNewLevel(player, d)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.UTILITY_POLE) then
        local sdata = d.ffsavedata
        if sdata then
            if sdata.utilityPoleSpawned then
                sdata.utilityPoleSpawned = nil
            else
                local offsetVec = Vector(0, -75)
                local utilityNum = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.UTILITY_POLE)
                if utilityNum > 0 then
                    for i = 1, utilityNum do
                        local box = Isaac.Spawn(5, FiendFolio.PICKUP.VARIANT.UTILITY_POLE_BOX, 0, player.Position + offsetVec + RandomVector(), Vector.Zero, player)
                    end
                else
                    local box = Isaac.Spawn(5, FiendFolio.PICKUP.VARIANT.UTILITY_POLE_BOX, 0, player.Position + offsetVec, Vector.Zero, player)
                end
                for i = -50, 50, 100 do
                    local crow = Isaac.Spawn(mod.FF.UtilityPoleCrow.ID, mod.FF.UtilityPoleCrow.Var, mod.FF.UtilityPoleCrow.Sub, player.Position + offsetVec + Vector(i, 0), Vector.Zero, player):ToEffect()
                    if i < 0 then
                        crow:GetSprite().FlipX = true
                        local sprite = player:GetSprite()
                    end
                    crow:Update()
                end
                sdata.utilityPoleSpawned = true
            end
        end
    end
end]]

function mod:utilityPoleStartRoom(roomCenter)
    if mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.UTILITY_POLE) then
        local sdata = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', {})
        if sdata then
            if sdata.utilityPoleSpawned then
                sdata.utilityPoleSpawned = nil
            else
                local offsetVec = Vector(0, -75)
                local utilityNum = mod.getCollectibleMultiplierAcrossAllPlayers(mod.ITEM.COLLECTIBLE.UTILITY_POLE)
                if utilityNum > 0 then
                    for i = 1, utilityNum do
                        local box = Isaac.Spawn(5, FiendFolio.PICKUP.VARIANT.UTILITY_POLE_BOX, 0, roomCenter + offsetVec + RandomVector(), Vector.Zero, nil)
                    end
                else
                    local box = Isaac.Spawn(5, FiendFolio.PICKUP.VARIANT.UTILITY_POLE_BOX, 0, roomCenter + offsetVec, Vector.Zero, nil)
                end
                for i = -50, 50, 100 do
                    local crow = Isaac.Spawn(mod.FF.UtilityPoleCrow.ID, mod.FF.UtilityPoleCrow.Var, mod.FF.UtilityPoleCrow.Sub, roomCenter + offsetVec + Vector(i, 0), Vector.Zero, nil):ToEffect()
                    if i < 0 then
                        crow:GetSprite().FlipX = true
                    end
                    crow:Update()
                end
                sdata.utilityPoleSpawned = true
            end
        end
    end
end

local pettingCrow = true

function mod:utilityPoleCrowAI(e)
    local sprite = e:GetSprite()
    local d = mod:GetEntityData(e)
    local bombs = Isaac.FindByType(4, -1, -1, false, false)
    if #bombs > 0 then
        d.flee = true
    end

    if Input.IsMouseBtnPressed(0) then
        if not pettingCrow then
            local pos = Input.GetMousePosition(true)
            if game:GetRoom():IsMirrorWorld() then
                local xPos = 2*room:GetCenterPos().X-pos.X
                pos = Vector(xPos, pos.Y)
            end
            if pos:Distance(e.Position) < 50 then
                pettingCrow = true
                d.beenPetted = true
                local heart = Isaac.Spawn(mod.FF.UtilityPoleHeart.ID, mod.FF.UtilityPoleHeart.Var, mod.FF.UtilityPoleHeart.Sub, pos, Vector.Zero, player):ToEffect()
                sfx:Play(mod.Sounds.UtilityPolePetCrow, 0.3)
                e.SpriteScale = Vector(e.SpriteScale.X * 1.5,e.SpriteScale.Y / 1.5)
            end
        end
    else
        pettingCrow = nil
    end

    e.SpriteScale = mod:Lerp(e.SpriteScale, Vector.One, 0.3)

    local crowBounce = 18
    if d.flee then
        if sprite:IsFinished("Leave") then
            e:Remove()
        else
            mod:spritePlay(sprite, "Leave")
        end
    else
        local openedBoxCount = mod.GetEntityCount(5, FiendFolio.PICKUP.VARIANT.UTILITY_POLE_BOX, 1)
        if openedBoxCount > 0 or d.beenPetted then
            sprite:SetFrame("IdleHappy", e.FrameCount % crowBounce)
        else
            sprite:SetFrame("Idle", e.FrameCount % crowBounce)
        end
    end
end

function mod:utilityPoleHeartAI(e)
    local sprite, d, rng = e:GetSprite(), mod:GetEntityData(e), e:GetDropRNG()
    sprite:SetFrame("RedHeartFull", 0)
    d.fallingSpeed = d.fallingSpeed or - 2 - (rng:RandomFloat() * 3)
    d.fallingSpeed = d.fallingSpeed + 0.3
    e.SpriteOffset = e.SpriteOffset + Vector(0, d.fallingSpeed)

    if not d.Rotation then
        e.Velocity = Vector(rng:RandomFloat(), 0)
        d.Rotation = rng:RandomFloat() * 10
        if rng:RandomInt(2) == 1 then
            e.Velocity = e.Velocity * -1
            d.Rotation = d.Rotation * -1
        end
    end

    sprite.Rotation = sprite.Rotation + d.Rotation
    e.SpriteScale = Vector(0.5,0.5)
    e.DepthOffset = 500

    local timeOutTime = 50
    local fadeTime = 10
    if e.FrameCount > timeOutTime then
        e.Color = Color(1,1,1,0.5 - ((e.FrameCount - timeOutTime) / fadeTime * 2))
        if e.FrameCount >= timeOutTime + fadeTime then
            e:Remove()
        end
    else
        e.Color = Color(1,1,1,0.5)
    end
end

local validBoxVariants = {
    --[[PickupVariant.PICKUP_HEART,
    PickupVariant.PICKUP_COIN,
    PickupVariant.PICKUP_KEY,
    PickupVariant.PICKUP_BOMB,]]

    PickupVariant.PICKUP_PILL,
    PickupVariant.PICKUP_PILL,
    PickupVariant.PICKUP_PILL,
    PickupVariant.PICKUP_PILL,

    PickupVariant.PICKUP_TAROTCARD,
    PickupVariant.PICKUP_TAROTCARD,
    PickupVariant.PICKUP_TAROTCARD,
    PickupVariant.PICKUP_TAROTCARD,

    301, --StageAPI random rune

    FiendFolio.PICKUP.VARIANT.RANDOM_OBJECT,
    FiendFolio.PICKUP.VARIANT.RANDOM_OBJECT,
}

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_,pickup, collider)
    if collider.Type == 1 then
        if pickup.SubType == 0 then
            collider = collider:ToPlayer()
            --Make it technically open
            pickup.SubType = 1
            --Lazy open animation by using the idle anim
            local ps = pickup:GetSprite()
            ps:Play("Open")
            --Soundz
            sfx:Play(mod.Sounds.EarthboundBox)
            sfx:Play(mod.Sounds.UtilityPoleBoxOpen, 0.3)
            --Spawn pickups
            local rng = pickup:GetDropRNG()
            local max = 2 + rng:RandomInt(3)
            local startAng = rng:RandomInt(360)
            for i = 1, max do
                local vec = Vector(2 + rng:RandomFloat() * 3,0):Rotated(startAng + (i * (360/max)))
                local variant = validBoxVariants[rng:RandomInt(#validBoxVariants) + 1]
                local reward = Isaac.Spawn(5, variant, 0, pickup.Position + vec:Resized(5), vec, pickup)
            end
            --Visual poof cloud
            local poof = Isaac.Spawn(1000, 15, 0, pickup.Position, Vector.Zero, pickup):ToEffect()
            --poof:FollowParent(pickup)
            poof.SpriteScale = poof.SpriteScale * 0.75
            poof:Update()

        end
    end
end, FiendFolio.PICKUP.VARIANT.UTILITY_POLE_BOX)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_,pickup)
    if pickup.SubType == 1 then
        pickup:Remove()
    end
end, FiendFolio.PICKUP.VARIANT.UTILITY_POLE_BOX)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_,pickup)
    if pickup:HasEntityFlags(EntityFlag.FLAG_APPEAR) then
        pickup:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    end
    pickup.Velocity = pickup.Velocity * 0.75
    pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
	local sprite = pickup:GetSprite()
    if pickup.SubType == 1 then
        --mod:spritePlay(sprite, "IdleOpen")
    else
        --mod:spritePlay(sprite, "Idle")
        sprite:SetFrame("Idle", 0)
    end
end, FiendFolio.PICKUP.VARIANT.UTILITY_POLE_BOX)
