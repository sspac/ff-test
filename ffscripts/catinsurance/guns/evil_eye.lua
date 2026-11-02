local mod = FiendFolio
local synergy = {}

local function createEyeGun(data, eye, player)
    local gun = mod:SpawnFriendGun(eye, nil, player, "RED_HEART")
    data.EyeFriendGun = EntityPtr(gun)

    if mod:IsBriendTwin(player) then
        mod:CheckAgainstCurrentGun(player, mod.SpecialFriendGunSubtypes.BRIEND_DEAGLE, true, gun, true)
    end
    
    mod:GetEntityData(gun).NoReload = true
end

---@param player EntityPlayer
function synergy:HandleFriendEvilEye(gun, player, aim)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_EVIL_EYE) then
        for _, eye in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.EVIL_EYE)) do
            local data = mod:GetEntityData(eye)
            if data.FriendFireCooldown
            and data.FriendFireCooldown == 0
            and eye.Parent
            and GetPtrHash(eye.Parent) == GetPtrHash(player) then
                local eyeGun = data.EyeFriendGun and data.EyeFriendGun.Ref
                if not eyeGun then
                    goto continue
                end

                if GetPtrHash(gun) ~= GetPtrHash(eyeGun) then
                    local gunData = mod:GetEntityData(eyeGun)
                    gunData.state = mod:GetEntityData(gun).state

                    local aim = mod:GetFriendGunAim(eyeGun)
                    mod:FireGunFriend(eyeGun, aim, false, false)
                end
            end

            ::continue::
        end
    end
end

mod:AddCallback("POST_PRIMARY_GUN_FIRE", synergy.HandleFriendEvilEye)

---@param eye EntityEffect
function synergy:DisableEvilEye(eye)
    local player = eye.Parent and eye.Parent:ToPlayer()
    if player and mod:IsAnyFriend(player) then
        eye.State = 512 -- Disables shooting. It decreases by 256 every frame.
        local data = mod:GetEntityData(eye)
        data.FriendFireCooldown = data.FriendFireCooldown or 0
        data.FriendFireCooldown = math.max(data.FriendFireCooldown - 1, 0)

        local sprite = eye:GetSprite()
        if sprite:IsFinished("ShootSide") then
            sprite:Play("IdleSide", true)
        elseif sprite:IsFinished("ShootUp") then
            sprite:Play("IdleUp", true)
        elseif sprite:IsFinished("ShootDown") then
            sprite:Play("IdleDown", true)
        end

        if not data.EyeFriendGun or not data.EyeFriendGun.Ref then
            createEyeGun(data, eye, player)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, synergy.DisableEvilEye, EffectVariant.EVIL_EYE)

function synergy:InitEvilEye(eye)
    local player
    
    -- evil eye doesnt have Parent set on init because fuck you i guess
    for _, ent in ipairs(Isaac.FindInRadius(eye.Position, 5, EntityPartition.PLAYER)) do
        local plr = ent:ToPlayer()
        if plr:GetPlayerType() == mod.PLAYER.FRIEND and plr:HasCollectible(CollectibleType.COLLECTIBLE_EVIL_EYE) then
            player = plr
            break
        end
    end

    if player and mod:IsAnyFriend(player) then
        eye.State = 512 -- Disables shooting. It decreases by 256 every frame.
        local data = mod:GetEntityData(eye)
        data.FriendFireCooldown = data.FriendFireCooldown or 0
        data.FriendFireCooldown = math.max(data.FriendFireCooldown - 1, 0)

        if not data.EyeFriendGun or not data.EyeFriendGun.Ref then
            createEyeGun(data, eye, player)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, synergy.InitEvilEye, EffectVariant.EVIL_EYE)