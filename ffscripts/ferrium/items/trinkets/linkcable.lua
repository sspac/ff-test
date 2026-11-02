local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    Chance = 25,
    Time = {600, 300},
}

local sprite = Sprite()
sprite:Load("gfx/effects/effect_link_cable.anm2", true)
sprite:Play("Idle", true)

mod.LinkCableActive = nil
function mod:LinkCableNewRoom(player)
    if player:HasTrinket(mod.ITEM.TRINKET.LINK_CABLE) and mod.IsActiveRoom() then
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.LINK_CABLE)
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.LINK_CABLE)
        local chance = bal.Chance*mult

        mod.scheduleForUpdate(function()
            local guy
            for _,ent in ipairs(Isaac.FindInRadius(player.Position, 1000, EntityPartition.ENEMY)) do
                guy = true
                break
            end

            if guy and rng:RandomInt(100) < chance then
                --Okay, this doesn't reset upon firing
                --local room = game:GetRoom()
                --room:SetPauseTimer(bal.Time[1]+bal.Time[2]*mult)
                player:UseActiveItem(CollectibleType.COLLECTIBLE_PAUSE, 1, -1, 0)
                player:AnimateTrinket(mod.ITEM.TRINKET.LINK_CABLE, "UseItem")
                mod.LinkCableActive = true
                sfx:Play(mod.Sounds.BatonPass, 1, 0, false, 1)
            end
        end, 5)
    end
end
mod:AddTrinketCallback("FF_NEW_ROOM_PLAYER_FERRIUM", mod.ITEM.TRINKET.LINK_CABLE, mod.LinkCableNewRoom)

function mod:LinkCableUpdate(room)
    if mod.LinkCableActive and game:GetFrameCount() % 2 == 0 then
        local found
        for _,ent in ipairs(Isaac.FindInRadius(room:GetCenterPos(), 1000, EntityPartition.ENEMY)) do
            if ent:GetPauseTime() > 0 then
                found = true
            end
            break
        end

        if not found then
            mod.LinkCableActive = nil
        end
    end
end
mod:AddTrinketCallback("FF_POST_UPDATE_FERRIUM", mod.ITEM.TRINKET.LINK_CABLE, mod.LinkCableUpdate)

function mod:LinkCableRender()
    if mod.LinkCableActive then
        local pos = Vector(Isaac.GetScreenWidth(), Isaac.GetScreenHeight())/2
        sprite:Render(pos, Vector.Zero, Vector.Zero)
    end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_RENDER, mod.ITEM.TRINKET.LINK_CABLE, mod.LinkCableRender)

mod:AddTrinketCallback(mod.CALLBACK.FF_PLAYER_POST_START_GREED_WAVE, mod.ITEM.TRINKET.LINK_CABLE, function(_, player, data, waveNumber, isBossWave)
	if player:HasTrinket(mod.ITEM.TRINKET.LINK_CABLE) then
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.LINK_CABLE)
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.LINK_CABLE)
        local chance = bal.Chance*mult
        if rng:RandomInt(100) < chance then
            mod.scheduleForUpdate(function()
                player:UseActiveItem(CollectibleType.COLLECTIBLE_PAUSE, 1, -1, 0)
                player:AnimateTrinket(mod.ITEM.TRINKET.LINK_CABLE, "UseItem")
                mod.LinkCableActive = true
                sfx:Play(mod.Sounds.BatonPass, 1, 0, false, 1)
            end, 40)
        end
    end
end)