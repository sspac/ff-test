local mod = FiendFolio
local sfx = SFXManager()

mod:AddTrinketCallback(ModCallbacks.MC_EVALUATE_MULTI_SHOT_PARAMS, mod.ITEM.TRINKET.NOTABLE_ALBUM, function(_, player, params, weaponType)
	--Stealing Xalum code for this thank you pal
    if player:HasTrinket(mod.ITEM.TRINKET.NOTABLE_ALBUM) then
        local d = mod:GetEntityData(player)
        d.firedNotableAlbum = d.firedNotableAlbum or 0
        if d.firedNotableAlbum < player:GetTrinketMultiplier(mod.ITEM.TRINKET.NOTABLE_ALBUM) then
            local tears = params:GetNumTears() + 3
            params:SetNumTears(tears)
            params:SetNumLanesPerEye(tears // params:GetNumEyesActive())

            if mod:canWeaponTypeSpread(weaponType) then
                params:SetSpreadAngle(weaponType, (tears - 1) * mod:getWeaponSpread(weaponType))
            end
        end
	end
end)

local ignoredWeaponTypes = {
    [WeaponType.WEAPON_BRIMSTONE] = true,
    [WeaponType.WEAPON_ROCKETS] = true,
    [WeaponType.WEAPON_SPIRIT_SWORD] = true,
}

mod:AddTrinketCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE, mod.ITEM.TRINKET.NOTABLE_ALBUM, function(_, player, dir, amount, owner, params)
	if player:HasTrinket(mod.ITEM.TRINKET.NOTABLE_ALBUM) then
        mod.scheduleForUpdate(function()
            local d = mod:GetEntityData(player)
            local weaponType = params.WeaponType
            if weaponType == WeaponType.WEAPON_LUDOVICO_TECHNIQUE then
                d.firedNotableAlbum = d.firedNotableAlbum or 0
                if d.firedNotableAlbum < player:GetTrinketMultiplier(mod.ITEM.TRINKET.NOTABLE_ALBUM) then
                    d.firedNotableAlbum = d.firedNotableAlbum + 0.2
                end
            elseif not ignoredWeaponTypes[weaponType] then
                d.firedNotableAlbum = d.firedNotableAlbum or 0
                if d.firedNotableAlbum < player:GetTrinketMultiplier(mod.ITEM.TRINKET.NOTABLE_ALBUM) then
                    d.firedNotableAlbum = d.firedNotableAlbum + 1
                    sfx:Play(mod.Sounds.BertranSlap, 1, 0, false, math.random(165,185)/100)
                end
            end

            mod:QueueFriendMultishotRefresh(player, d)
        end, 0)
    end
end)

local decrementNotableAlbumBrimstone = true
mod:AddTrinketCallback(ModCallbacks.MC_POST_FIRE_BRIMSTONE, mod.ITEM.TRINKET.NOTABLE_ALBUM, function(_, laser)
	local player = TearFlagsLib.GetTearPlayer(laser)
    if player and player:HasTrinket(mod.ITEM.TRINKET.NOTABLE_ALBUM) then
        local d = mod:GetEntityData(player)
        d.firedNotableAlbum = d.firedNotableAlbum or 0
        if decrementNotableAlbumBrimstone and d.firedNotableAlbum < player:GetTrinketMultiplier(mod.ITEM.TRINKET.NOTABLE_ALBUM) then
            d.firedNotableAlbum = d.firedNotableAlbum + 1
            sfx:Play(mod.Sounds.BertranSlap, 1, 0, false, math.random(165,185)/100)
            decrementNotableAlbumBrimstone = false
        end
    end
    mod.scheduleForUpdate(function()
        decrementNotableAlbumBrimstone = true
    end, 0, nil, true)
end)

mod:AddTrinketCallback(mod.CALLBACK.FF_ERFLY_ON_FIRE_ROCKET, mod.ITEM.TRINKET.NOTABLE_ALBUM, function(_, player, target)
    local data = mod:GetEntityData(target)
    if target.Variant == EffectVariant.TARGET then
        if player and player:HasTrinket(mod.ITEM.TRINKET.NOTABLE_ALBUM) then
            local d = mod:GetEntityData(player)
            d.firedNotableAlbum = d.firedNotableAlbum or 0
            if d.firedNotableAlbum < player:GetTrinketMultiplier(mod.ITEM.TRINKET.NOTABLE_ALBUM) then
                d.firedNotableAlbum = d.firedNotableAlbum + 0.5 --Borked so whatever
                sfx:Play(mod.Sounds.BertranSlap, 1, 0, false, math.random(165,185)/100)
            end
        end
    end
end)

function mod:notableAlbumNewRoom(player, d)
    d.firedNotableAlbum = nil
end

mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, function(_, player)
    local data = mod:GetEntityData(player)
    data.FFPlayedTrinketSound = false
end, mod.ITEM.TRINKET.NOTABLE_ALBUM)