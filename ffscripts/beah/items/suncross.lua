local mod = FiendFolio
local game = Game()

local function resetPos(f, room)
    local rwidth = room:GetGridWidth()
    local pos = Vector(rwidth*20 + (rwidth%2==0 and 0 or 20), 70)
    f.Position = pos
end

local function familiarUpdate(_, f)
    local isBoosted = f.SubType == 1
    local room = game:GetRoom()
    if room:GetFrameCount() == 0 or f.FrameCount == 1 then
        resetPos(f, room)
        EntityEffect.CreateLight(f.Position, 3)
        EntityEffect.CreateLight(f.Position, 2)
        EntityEffect.CreateLight(f.Position, 2)
        EntityEffect.CreateLight(f.Position, 1)
        EntityEffect.CreateLight(f.Position, 1)
    end
    game:UpdateStrangeAttractor(f.Position, isBoosted and 15 or 10, 80000)

    local fcount = f.FrameCount
    if fcount % 2 == 0 then
        local enemies = Isaac.FindInRadius(f.Position, isBoosted and 180 or 140, 8)
        for index, value in ipairs(enemies) do
            if not value:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) and value:IsVulnerableEnemy() and not value:IsBoss() then
                value:AddBurn(EntityRef(f), 40, f.Player.Damage*2)
                if mod:GetEntityData(f).ElectrumSun then
                    mod.AddOverloaded(value, f.Player, 0, 1, f.Player.Damage*0.5, 45, 15, true)
                end
            end
        end
    end

    f.DepthOffset = 500

    if fcount < 36 then
        f.Visible = true
        f.PositionOffset = Vector(0, -100*(0.8^fcount))
    else
        f.PositionOffset = Vector(0, math.sin(fcount/20))
    end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, familiarUpdate, mod.ITEM.FAMILIAR.THE_SUN)

local function familiarInit(_, f)
    resetPos(f, game:GetRoom())
        local sprite = f:GetSprite()
    sprite:SetRenderFlags(AnimRenderFlags.ENABLE_LAYER_LIGHTING)
    sprite:GetLayer(0):GetBlendMode():SetMode(BlendType.ADDITIVE)
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, familiarInit, mod.ITEM.FAMILIAR.THE_SUN)

local beamSprite = Sprite()
beamSprite:Load("gfx/familiar/the sun/sunbeam.anm2", true)
beamSprite:Play("Idle", false)

local beamLayer = beamSprite:GetLayer("beam")
beamLayer:SetWrapSMode(1)
beamLayer:SetWrapTMode(0)
local snapBeam = Beam(beamSprite, "beam", false, false)
local function preSunRender(_, f)
    if not f.Visible or (f.Variant == FamiliarVariant.WISP and f.SubType ~= mod.ITEM.COLLECTIBLE.SOLAR_TABLET) then
        return
    end
    local pos = f.Position + f.PositionOffset
    local fcount = f.FrameCount + (mod:GetEntityData(f).offsetFrameCount or 0)
    beamSprite.Color = Color(1,1,1, 1)
    local scaler = f.SubType == 1 and 1.23 or 1
    local isWisp = f.Variant == FamiliarVariant.WISP
    if isWisp then
        scaler = 0.2
        pos = pos + Vector(0, -18)
    end
    local speed = fcount*(isWisp and 6 or 1.2)
    for i = 1, 6, 1 do
        snapBeam:Add(Isaac.WorldToScreen(pos), 48, 0.1)
        snapBeam:Add(Isaac.WorldToScreen(pos+ (Vector(0, 96)*scaler):Rotated(speed+(60*i))), 1, isWisp and 0.06 or 0.2)
        snapBeam:Render()
    end

    for i = 1, 6, 1 do
        snapBeam:Add(Isaac.WorldToScreen(pos), 32, 0.2)
        snapBeam:Add(Isaac.WorldToScreen(pos + (Vector(0, 64)*scaler):Rotated(speed+(60*i)+30)), 1, isWisp and 0.12 or 0.4)
        snapBeam:Render()
    end

    local sp = f:GetSprite()
    local l = sp:GetLayer(0)
    l:SetSize(Vector(1,1)*(1+(math.sin(fcount/10)*0.05)))
end
mod:AddCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, preSunRender, mod.ITEM.FAMILIAR.THE_SUN)


--solar tablet
local sfx = SFXManager()
local function useItem()
    sfx:Play(SoundEffect.SOUND_BLACK_POOF)
    return true
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, useItem, mod.ITEM.COLLECTIBLE.SOLAR_TABLET)

local function wispUpdate(_, wisp)
    local fcount = wisp.FrameCount
    if fcount % 2 == 0 then
        local enemies = Isaac.FindInRadius(wisp.Position, 70, 8)
        for index, value in ipairs(enemies) do
            if not value:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) and value:IsVulnerableEnemy() and not value:IsBoss() then
                value:AddBurn(EntityRef(wisp), 40, wisp.Player.Damage*2)
            end
        end
    end
end
mod:AddEntityCallback(ModCallbacks.MC_FAMILIAR_UPDATE, EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, mod.ITEM.COLLECTIBLE.SOLAR_TABLET, wispUpdate, FamiliarVariant.WISP)
mod:AddEntityCallback(ModCallbacks.MC_PRE_FAMILIAR_RENDER, EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, mod.ITEM.COLLECTIBLE.SOLAR_TABLET, preSunRender, FamiliarVariant.WISP)