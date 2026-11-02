local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

local ITEM = mod.ITEM.COLLECTIBLE.GRANDPAS_GATLING_GUN
local flag = TearFlagsLib.RegisterTearFlag("BULLET_GATLING")

mod.GRANDPAS_GATLING_GUN = {}
mod.GRANDPAS_GATLING_GUN.Constants = {
    SHOT_ANGLE_VARIANCE = 15,
    SHOT_SPEED = 24,
    SHOT_COOLDOWN = 1.5,
    PLAYER_PUSH_FORCE = 1.7,
    DAMAGE_MULT = 2,
    FLAT_DAMAGE = 6,
    MAX_WISPS = 6,
    MAX_CHARGES = Isaac.GetItemConfig():GetCollectible(ITEM).MaxCharges,
}

mod.GRANDPAS_GATLING_GUN.Constants.CHARGE_PER_WISP = mod.GRANDPAS_GATLING_GUN.Constants.MAX_CHARGES / mod.GRANDPAS_GATLING_GUN.Constants.MAX_WISPS

--local itemSprite = Sprite()
--itemSprite:Load("gfx/items/collectibles/grandpas_gatling_gun.anm2", true)

function mod:GetGGGWispCount(player)
    local charge = 0
    local slot
    if player:GetActiveItemDesc(ActiveSlot.SLOT_PRIMARY).Item == ITEM
    and player:GetActiveItemDesc(ActiveSlot.SLOT_PRIMARY).Charge > 0 then
        slot = ActiveSlot.SLOT_PRIMARY
        charge = player:GetActiveItemDesc(ActiveSlot.SLOT_PRIMARY).Charge
    
    elseif player:GetActiveItemDesc(ActiveSlot.SLOT_POCKET).Item == ITEM
    and player:GetActiveItemDesc(ActiveSlot.SLOT_POCKET).Charge > 0 then
        slot = ActiveSlot.SLOT_SECONDARY
        charge = player:GetActiveItemDesc(ActiveSlot.SLOT_POCKET).Charge
    end

    if not slot then
        return 0
    end

    return math.ceil(charge / mod.GRANDPAS_GATLING_GUN.Constants.CHARGE_PER_WISP)
end

---@param player EntityPlayer
function mod:ToggleGrandpasGatlingGun(_, _, player, flags)
    if flags & UseFlag.USE_CARBATTERY == UseFlag.USE_CARBATTERY then
        return
    end

    local effects = player:GetEffects()
    local data = mod:GetEntityData(player)

    if effects:GetCollectibleEffectNum(ITEM) >= 1 then
        Isaac.CreateTimer(function ()
            effects:RemoveCollectibleEffect(ITEM, -1)
        end, 1, 1, true)
        if data.GatlingGun then
            if data.GatlingGun.Ref then
                data.GatlingGun.Ref:Remove()
            end
            data.GatlingGun = nil
        end

        if data.GatlingGunPreventShoot then
            data.GatlingGunPreventShoot = false
            player:SetCanShoot(true)
            player:UpdateCanShoot()
        end

        sfx:Stop(mod.Sounds.MinigunFireLoop)
        sfx:Stop(mod.Sounds.MinigunFireCritLoop)
        sfx:Stop(mod.Sounds.MinigunSpinLoop)
        sfx:Stop(mod.Sounds.MinigunWindUp)
        sfx:Play(mod.Sounds.MinigunWindDown, 0.5)

        local sprite = Sprite("gfx/items/collectibles/grandpas_gatling_gun.anm2", true)
        sprite:Play("Closed", true)
        player:AnimatePickup(sprite, false, "HideItem")
    else
        if data.GatlingGun then
            if data.GatlingGun.Ref then
                data.GatlingGun.Ref:Remove()
            end
            data.GatlingGun = nil
        end

        local gun = Isaac.Spawn(mod.FF.GrandpasGatlingGun.ID, mod.FF.GrandpasGatlingGun.Var, mod.FF.GrandpasGatlingGun.Sub, player.Position, Vector.Zero, player):ToEffect()
        local gd = mod:GetEntityData(gun)
        gun.Parent = player
        gun.DepthOffset = 5
        gun.SpriteOffset = Vector(0,-10)
        gd.state = "Init"
        gd.StateFrame = 0
        gd.AngleOffset = 0
        gd.ForceMuzzleScale = 0.95
        gd.ForceMuzzleOffset = Vector(48, -15)
        gun:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
        mod:GunDataInit(player, gun, data)

        data.GatlingGun = EntityPtr(gun)

        if not data.GatlingGunPreventShoot then
            data.GatlingGunPreventShoot = true
            player:SetCanShoot(false)

            if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
                for i = 1, mod:GetGGGWispCount(player) do
                    local wisp = player:AddWisp(ITEM, player.Position, true, false)
                    wisp.Coins = i
                end
            end
        end

        sfx:Play(mod.Sounds.MinigunWindUp, 0.5)

        local sprite = Sprite("gfx/items/collectibles/grandpas_gatling_gun.anm2", true)
        sprite:Play("Open", true)
        player:AnimatePickup(sprite, false, "HideItem")
    end

    mod:QueueFriendMultishotRefresh(player, data)

    return {
        Discharge = false,
        Remove = false,
        ShowAnim = false
    }
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.ToggleGrandpasGatlingGun, ITEM)

---@param player EntityPlayer
function mod:ShootGrandpasGatlingGun(player, data)
    if data.GatlingGunPreventShoot then
        player:SetCanShoot(false)
    end

    if not player:HasCollectible(ITEM) then
        if data.GatlingGun then
            if data.GatlingGun.Ref then
                data.GatlingGun.Ref:Remove()
            end
            data.GatlingGun = nil

            sfx:Stop(mod.Sounds.MinigunFireLoop)
            sfx:Stop(mod.Sounds.MinigunFireCritLoop)
            sfx:Stop(mod.Sounds.MinigunSpinLoop)
            sfx:Stop(mod.Sounds.MinigunWindUp)
            sfx:Play(mod.Sounds.MinigunWindDown, 0.5)
        end

        if data.GatlingGunPreventShoot then
            data.GatlingGunPreventShoot = false
            player:SetCanShoot(true)
            player:UpdateCanShoot()
        end

        return
    end

    
    data.GatlingGunSoundCooldown = data.GatlingGunSoundCooldown or 0
    data.GatlingGunSoundCooldown = math.max(data.GatlingGunSoundCooldown - 1, 0)
    if data.GatlingGunSoundCooldown == 0 and (sfx:IsPlaying(mod.Sounds.MinigunFireLoop) or sfx:IsPlaying(mod.Sounds.MinigunFireCritLoop)) then
        sfx:Stop(mod.Sounds.MinigunFireLoop)
        sfx:Stop(mod.Sounds.MinigunFireCritLoop)
        if data.GatlingGun and data.GatlingGun.Ref then
            sfx:Play(mod.Sounds.MinigunSpinLoop, 0.5, 2, true)
        end
    end
    
    local rng = player:GetCollectibleRNG(ITEM)
    if not data.GatlingGun or not data.GatlingGun.Ref then
        return
    end

    if not sfx:IsPlaying(mod.Sounds.MinigunWindUp) 
    and not (sfx:IsPlaying(mod.Sounds.MinigunSpinLoop) or sfx:IsPlaying(mod.Sounds.MinigunFireLoop) or sfx:IsPlaying(mod.Sounds.MinigunFireCritLoop)) then
        sfx:Play(mod.Sounds.MinigunSpinLoop, 0.5, 2, true)
    end

    data.GatlingGunCooldown = data.GatlingGunCooldown or 0
    data.GatlingGunCooldown = math.max(data.GatlingGunCooldown - 1, 0)

    local charge = 0
    local slot
    if player:GetActiveItemDesc(ActiveSlot.SLOT_PRIMARY).Item == ITEM
    and player:GetActiveItemDesc(ActiveSlot.SLOT_PRIMARY).Charge > 0 then
        slot = ActiveSlot.SLOT_PRIMARY
        charge = player:GetActiveItemDesc(ActiveSlot.SLOT_PRIMARY).Charge
    
    elseif player:GetActiveItemDesc(ActiveSlot.SLOT_POCKET).Item == ITEM
    and player:GetActiveItemDesc(ActiveSlot.SLOT_POCKET).Charge > 0 then
        slot = ActiveSlot.SLOT_SECONDARY
        charge = player:GetActiveItemDesc(ActiveSlot.SLOT_POCKET).Charge
    end

    if not slot or charge == 0 then
        player:GetEffects():RemoveCollectibleEffect(ITEM, -1)
        if data.GatlingGun then
            data.GatlingGun.Ref:Remove()
            data.GatlingGun = nil
        end

        if data.GatlingGunPreventShoot then
            data.GatlingGunPreventShoot = false
            player:SetCanShoot(true)
            player:UpdateCanShoot()
        end
        
        sfx:Stop(mod.Sounds.MinigunFireLoop)
        sfx:Stop(mod.Sounds.MinigunFireCritLoop)
        sfx:Stop(mod.Sounds.MinigunSpinLoop)
        sfx:Play(mod.Sounds.MinigunWindDown, 0.5)

        return
    end

    local aimDir = player:GetFireDirection()
    if data.GatlingGunCooldown == 0 and aimDir ~= Direction.NO_DIRECTION and charge > 0 then
        data.GatlingGunCooldown = mod.GRANDPAS_GATLING_GUN.Constants.SHOT_COOLDOWN

        local gatlingGun = data.GatlingGun.Ref
        local gatlingGunData = mod:GetEntityData(gatlingGun)
        gatlingGunData.state = "Shoot"

        data.GatlingGunSoundCooldown = 6
        
        if sfx:IsPlaying(mod.Sounds.MinigunSpinLoop) or sfx:IsPlaying(mod.Sounds.MinigunWindUp) then
            sfx:Stop(mod.Sounds.MinigunSpinLoop)
            sfx:Stop(mod.Sounds.MinigunWindUp)
            sfx:Play(mod.Sounds.MinigunFireLoop, 0.5, 2, true)
        end

        local var = rng:RandomInt(-mod.GRANDPAS_GATLING_GUN.Constants.SHOT_ANGLE_VARIANCE, mod.GRANDPAS_GATLING_GUN.Constants.SHOT_ANGLE_VARIANCE)
        local aimVec = mod.DirectionToVector[aimDir]
        gatlingGunData.LockAngle = aimVec:GetAngleDegrees()
        local vec = aimVec:Rotated(var)
        local vecMuzzle = aimVec:Rotated(var * 0.15)

        local tear = Isaac.Spawn(
            EntityType.ENTITY_TEAR,
            mod.TEAR.FRIEND_BULLET,
            0,
            mod:GetFriendGunShootPos(gatlingGun, vec, 25),
            vec:Resized(mod.GRANDPAS_GATLING_GUN.Constants.SHOT_SPEED),
            player
        ):ToTear()
        tear:SetInitSound(SoundEffect.SOUND_NULL)
        if player:HasTrinket(mod.ITEM.ROCK.ELECTRUM) then
            tear:AddTearFlags(TearFlags.TEAR_JACOBS)
        end

        -- some flashes dont get deleted properly when you spin down while shooting, idk how to fix it but its not a big deal i think, urp
        mod:MakeMuzzleFlashFriend(gatlingGun, player, mod:GetFriendGunShootPos(gatlingGun, vecMuzzle), vecMuzzle)
        TearFlagsLib.AddTearFlags(tear, mod.FriendBulletFlags.NO_FALL_TEAR)
        TearFlagsLib.AddTearFlags(tear, flag)

        if mod:playerIsBelialMode(player) then
            tear:AddTearFlags(TearFlags.TEAR_BURN)
            tear:Update()
        end

        tear.FallingSpeed = -0.1
        tear.FallingAcceleration = -0.05
        tear.Height = -6

        tear.CollisionDamage = player.Damage * mod.GRANDPAS_GATLING_GUN.Constants.DAMAGE_MULT + mod.GRANDPAS_GATLING_GUN.Constants.FLAT_DAMAGE

        if data.TrickyCherryCrit then
            tear.Color = Color(1, 1, 1, 1, 0.25, 0, 0)
        end
		
		mod:SecondaryFire(player, vec, 1, player, {DoBasegameEffects = true, GatlingGun = true})

        -- Don't use GetTotalActiveCharge here since that is affected weirdly by Bethany's soul charges
        local currentCharge = player:GetActiveCharge(slot) + player:GetBatteryCharge(slot)
        player:SetActiveCharge(currentCharge - 1)

        player:AddVelocity(Vector.FromAngle(mod.DirectionToVector[aimDir]:GetAngleDegrees()):Rotated(180):Resized(mod.GRANDPAS_GATLING_GUN.Constants.PLAYER_PUSH_FORCE))
    end

    if sfx:IsPlaying(mod.Sounds.MinigunFireLoop)
    and data.TrickyCherryCrit then
        sfx:Stop(mod.Sounds.MinigunFireLoop)
        sfx:Play(mod.Sounds.MinigunFireCritLoop, 0.5, 2, true)
    elseif sfx:IsPlaying(mod.Sounds.MinigunFireCritLoop)
    and not data.TrickyCherryCrit then
        sfx:Stop(mod.Sounds.MinigunFireCritLoop)
        sfx:Play(mod.Sounds.MinigunFireLoop, 0.5, 2, true)
    end
end

---@param tear EntityTear
---@param gridEnt GridEntity
function mod:GGGBulletsBreakRocks(tear, gridIndex, gridEnt)
    if gridEnt and tear.Variant == mod.TEAR.FRIEND_BULLET and TearFlagsLib.HasTearFlags(tear, flag) then
        local rock = gridEnt:ToRock()
        if rock then
            rock:Destroy(false)

            -- Make bridge if necessary.
            local direction = (gridEnt.Position - tear.Position):Normalized()
            local otherGrid = room:GetGridEntityFromPos(tear.Position + direction:Resized(40))
            local pit = otherGrid and otherGrid:ToPit()
            if pit then
                pit:MakeBridge(rock)
            end
        else
            local door = gridEnt:ToDoor()
            if door and door:CanBlowOpen() then
                door:TryBlowOpen(false, tear)
            end
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_TEAR_GRID_COLLISION, ITEM, mod.GGGBulletsBreakRocks)

function mod:AllowGGGShootingWhenever()
    return 1
end
mod:AddCollectibleCallback(ModCallbacks.MC_PLAYER_GET_ACTIVE_MIN_USABLE_CHARGE, ITEM, mod.AllowGGGShootingWhenever, ITEM)

function mod:GrandpasGatlingGunRefill()
    for _, player in ipairs(PlayerManager.GetPlayers()) do
        local slot = player:GetActiveItemSlot(ITEM)
        if slot and slot > -1 then
            player:FullCharge(slot, true)
        end
    end
end

-- Fixes having to tap spacebar twice to pull out gun after contiuing a run where the gun was equipped before extiing.
function mod:GrandpasGatlingGunStartRun()
    for _, player in ipairs(PlayerManager.GetPlayers()) do
        local effects = player:GetEffects()
        if effects:GetCollectibleEffectNum(ITEM) >= 1 then
            effects:RemoveCollectibleEffect(ITEM, -1)
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_GAME_STARTED, ITEM, mod.GrandpasGatlingGunStartRun)

function mod:GatlingGunUpdate(e)
    local d = mod:GetEntityData(e)
    local sprite = e:GetSprite()

    if not d.init then
        d.state = "Appear"
        d.StateFrame = 0
        d.ShotsFired = 0
        d.init = true
    else
        d.StateFrame = d.StateFrame+1
    end

    if e.Parent and e.Parent:ToPlayer() and e.Parent:Exists() and not e.Parent:IsDead() then
        local player = e.Parent:ToPlayer()

        d.CurrentAngle = d.CurrentAngle or 90
        d.CurrentAngle = d.CurrentAngle % 360

        mod:StandardGunMovement(e, player)

        local offset = 20
        if d.CurrentAngle > 0 and d.CurrentAngle < 180 then
            local real = (90-math.abs(90-d.CurrentAngle))/90
            offset = offset-offset*0.25*real
        end
        local dir = Vector(offset, 0):Rotated(d.CurrentAngle)

        if d.CurrentAngle > 90 and d.CurrentAngle <= 270 then
            sprite.FlipX = true
            e.SpriteRotation = 180-d.CurrentAngle
        else
            sprite.FlipX = false
            e.SpriteRotation = d.CurrentAngle
        end

        if e.FrameCount < 2 then
            e.Position = player.Position + dir
            e.Velocity = Vector.Zero
        else
            e.Velocity = (player.Position+player.Velocity*2.5+dir) - e.Position
        end

        if not player:IsExtraAnimationFinished() or player:GetSprite():IsPlaying("TeleportUp") then
            --mod:spritePlay(sprite, "Disappear")
            e.Visible = false
            d.TempHidden = true
            d.SetVisiblePlease = true
        elseif d.SetVisiblePlease then
            d.SetVisiblePlease = nil
            e.Visible = true
        end

        if d.state == "Idle" then
            if d.TempHidden and e.Visible then
                if sprite:IsFinished("Appear") then
                    d.TempHidden = nil
                else
                    mod:spritePlay(sprite, "Appear")
                end
            else
                mod:spritePlay(sprite, "Idle")
            end
        elseif d.state == "Shoot" then
            if sprite:IsFinished("Shoot") then
                d.state = "Idle"
                d.LockAngle = nil
            else
                mod:spritePlay(sprite, "Shoot")
            end
        elseif d.state == "Appear" then
            if sprite:IsFinished("Appear") then
                d.state = "Idle"
            else
                mod:spritePlay(sprite, "Appear")
            end
        elseif d.state == "Disappear" then
            if sprite:IsFinished("Disappear") then
                e:Remove()
            else
                mod:spritePlay(sprite, "Disappear")
            end
        end
    else
        e.Velocity = Vector.Zero
        if sprite:IsFinished("Disappear") then
            e:Remove()
        else
            mod:spritePlay(sprite, "Disappear")
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_RENDER_ACTIVE_ITEM, function(_, player, slot, offset, alpha, scale)
    local data = mod:GetEntityData(player)
    if data.GatlingGunPreventShoot then
        return {CropOffset = Vector(32,0)}
    end
end, mod.ITEM.COLLECTIBLE.GRANDPAS_GATLING_GUN) 

--[[mod:AddCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_ACTIVE_ITEM, function(_, player, slot, offset, alpha, scale)
    if game:GetHUD():IsVisible() and player:GetActiveItem(slot) == mod.ITEM.COLLECTIBLE.GRANDPAS_GATLING_GUN and not player:IsCoopGhost() then
        mod:RenderActive(itemSprite, player, slot, offset, alpha, scale, 2)
    end
end)]]