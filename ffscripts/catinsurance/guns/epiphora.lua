local mod = FiendFolio
local synergy = {}

---@param player EntityPlayer

function synergy:TrackFiredGun(gun, player, aim)
    if not player:HasCollectible(CollectibleType.COLLECTIBLE_EPIPHORA) then
        return
    end
    
    local pd = mod:GetEntityData(player)
    local gunTable = pd.FriendHeldGuns[gun.InitSeed]
    
    -- just in case
    if not gunTable.Ammo then
        return
    end

    local friendAmmo = mod:GetFriendAmmo(gun)
    local ammoCount = #gunTable.Ammo
    local wasAtFullAmmo = ammoCount + 1 == #friendAmmo

    if wasAtFullAmmo and not pd.FriendEpiphoraCooldown then
        pd.FriendEpiphoraCooldown = true
        pd.FriendEpiphoraDirection = player:GetFireDirection()
    end

    if gunTable.Ammo and #gunTable.Ammo == 0 then
        -- Do a full reload if they kept up the same direction the whole time
        if pd.FriendEpiphoraDirection then
            for _ = ammoCount, #friendAmmo do
                local original = friendAmmo[#gunTable.Ammo + 1]
                table.insert(gunTable.Ammo, original)
            end

            pd.FriendEpiphoraDirection = nil
        end
    end
end

mod:AddCallback("POST_GUN_FIRE", synergy.TrackFiredGun)

---@param player EntityPlayer
function mod:EpiphoraGunTrackDirection(player, pd)
	if player:GetPlayerType() ~= mod.PLAYER.FRIEND then return end
    if not player:HasCollectible(CollectibleType.COLLECTIBLE_EPIPHORA) then
        return
    end

    if pd.FriendEpiphoraDirection and pd.FriendEpiphoraDirection ~= player:GetFireDirection() then
        pd.FriendEpiphoraDirection = nil
    end

    if player:GetFireDirection() == Direction.NO_DIRECTION then
        pd.FriendEpiphoraCooldown = nil
    end
end