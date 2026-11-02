local mod = FiendFolio

--THIS IS NOT AN ENEMY STATUS EFFECT, THIS ONLY REALLY APPLIES TO DELUGE'S BUBBLES GRANTING IT TO PLAYERS

local bal = {
    FloodingSlowMin = 0.05,
    FloodingSlowMax = 0.9,
    FloodingSlippy1 = 0.3,
    FloodingSlippy2 = 0.65,
    FloodedDurIncrease = 50,
}

local floodedColor1 = Color(0.95, 0.95, 0.95, 1, 0, 0, 0.2)
local floodedColor2 = Color(0.7, 0.7, 0.7, 1, 0, 0, 0.3)

function mod:FloodedStatusUpdate(player, d)
    if d.PlayerFloodedStacks and d.PlayerFloodedStacks > 0 then
        if not d.PlayerFloodedIcon then
            d.PlayerFloodedIcon = Sprite()
            d.PlayerFloodedIcon:Load("gfx/bosses/deluge/status_flooded.anm2", true)
            d.PlayerFloodedIcon:Play("Level" .. d.PlayerFloodedStacks, true)
        elseif (d.PlayerFloodedIcon:IsPlaying("Level1") and d.PlayerFloodedStacks == 2) or (d.PlayerFloodedIcon:IsPlaying("Level2") and d.PlayerFloodedStacks == 1) then
            d.PlayerFloodedIcon:Play("Level" .. d.PlayerFloodedStacks)
        end
        d.PlayerFloodedIcon:Update()

        if d.PlayerFloodedStacks == 2 then
            if d.FloodedSlippyVel then
                player.Velocity = mod:Lerp(player.Velocity, d.FloodedSlippyVel, bal.FloodingSlippy2)
            end

            d.FloodedSlippyVel = player.Velocity

            player:SetColor(floodedColor2, 1, 1, false, false)
        else
            if d.FloodedSlippyVel then
                player.Velocity = mod:Lerp(player.Velocity, d.FloodedSlippyVel, bal.FloodingSlippy1)
            end

            d.FloodedSlippyVel = player.Velocity

            player:SetColor(floodedColor1, 1, 1, false, false)
        end

        d.PlayerFloodedDuration = d.PlayerFloodedDuration-1
        if d.PlayerFloodedDuration <= 0 then
            d.PlayerFloodedStacks = nil
            d.PlayerFloodedIcon = nil
            d.PlayerFloodedDuration = nil
            d.FloodedStatusSlow = nil
            player:AddCacheFlags(CacheFlag.CACHE_SPEED)
            player:EvaluateItems()
        end
    end
end

function mod:FloodedStatusRender(player, d)
    if mod:IsNormalRender(true) then
        if d.PlayerFloodedStacks and d.PlayerFloodedStacks > 0 then
            if not d.PlayerFloodedIcon then
                d.PlayerFloodedIcon = Sprite()
                d.PlayerFloodedIcon:Load("gfx/bosses/deluge/status_flooded.anm2", true)
                d.PlayerFloodedIcon:Play("Level" .. d.PlayerFloodedStacks, true)
            end
            d.PlayerFloodedIcon:Render(Isaac.WorldToScreen(player.Position+Vector(0, -50*player.SpriteScale.Y)))
        end
    end
end

function mod:AddFloodedToPlayer(player, dur, stacks, delugeVer)
    if stacks <= 0 then return end
	if Isaac.RunCallbackWithParam(ModCallbacks.MC_PRE_STATUS_EFFECT_APPLY, "FFFlooded", "FFFlooded", entity, EntityRef(source), duration) == false then
		return
	end
    local d = mod:GetEntityData(player)
    d.PlayerFloodedStacks = d.PlayerFloodedStacks or 0

    d.PlayerFloodedStacks = math.min(2, d.PlayerFloodedStacks+(stacks or 1))
    d.PlayerFloodedDuration = d.PlayerFloodedDuration or 0
    if d.PlayerFloodedDuration > 0 and delugeVer then
        d.PlayerFloodedDuration = math.min(d.PlayerFloodedDuration+bal.FloodedDurIncrease, dur)
    else
        d.PlayerFloodedDuration = math.max(d.PlayerFloodedDuration, dur)
    end
    if not d.PlayerFloodedIcon then
        d.PlayerFloodedIcon = Sprite()
        d.PlayerFloodedIcon:Load("gfx/bosses/deluge/status_flooded.anm2", true)
        d.PlayerFloodedIcon:Play("Level" .. d.PlayerFloodedStacks, true)
    end
    d.FloodedStatusSlow = {bal.FloodingSlowMax, bal.FloodingSlowMin}
    player:AddCacheFlags(CacheFlag.CACHE_SPEED)
    player:EvaluateItems()
	
	Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_STATUS_EFFECT_APPLY, "FFFlooded", "FFFlooded", entity, EntityRef(source), duration)
end