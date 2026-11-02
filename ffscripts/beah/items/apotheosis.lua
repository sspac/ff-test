local mod = FiendFolio
local sfx = SFXManager()
local canDoSFX = false

local maxOrbitals = 12
local function evaluateSoulHeartsAmount(_, player)
    if not player:HasCollectible(mod.ITEM.COLLECTIBLE.APOTHEOSIS) then
        return
    end
    local soul = math.min(maxOrbitals, math.ceil((player:GetSoulCharge()+player:GetSoulHearts())/2))
    local p_data = mod:GetEntityData(player) --intentionally not using rundata savedeffects because i want it to run again on reloading the run
    local os = p_data.ff_apotheosiscachedsoulhearts
    if os ~= soul then
        p_data.ff_apotheosiscachedsoulhearts = soul
        canDoSFX = true
        player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS, true)
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.APOTHEOSIS, evaluateSoulHeartsAmount)

function mod:EvaluateApotheosis(player)
    local p_data = mod:GetEntityData(player)
    local f = p_data.ff_apotheosiscachedsoulhearts or 0
    if not player:HasCollectible(mod.ITEM.COLLECTIBLE.APOTHEOSIS) then
        f = 0
    else
        local s = mod.GetExpectedFamiliarNum(player, mod.ITEM.COLLECTIBLE.APOTHEOSIS)
        f = f + (s-1)
        --f = math.max(f, s - 1)
    end
    
    local source = Isaac.GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.APOTHEOSIS)
    local fs = player:CheckFamiliarEx(mod.ITEM.FAMILIAR.APOTHEOSIS_ORBITAL, f, player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.APOTHEOSIS), source)
    for index, value in ipairs(fs) do
        value:AddToOrbit(276)
        --familiar:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        value.OrbitSpeed = 0

        local f_index = mod:BeahGetOrbitalPositionInLayer(value, player)
        value.Hearts = f_index
        
        value:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        value:Update()
        value.Velocity = Vector.Zero
        value.Visible = true

        value:SetColor(Color(1,1,1,0,2,2,1), 15, 15, true, true) -- if it aint broke
        sfx:Play(SoundEffect.SOUND_SOUL_PICKUP, 0.8)
        canDoSFX = false
    end
end

local distance = Vector(90, 90)
local ishowspeed = 2
local voset = Vector(0,-12)
local function apotheosisFamiliarUpdate(_, f)
    local p = f.Player
    local row = math.floor((f.Hearts-1)/12)
    local a = ((f.Hearts + (row%2)/2) / 12) % 1

    local sp = ishowspeed * mod:GetOrbitalSpeedMult(p)
    a = ((p.FrameCount*sp)) + (a*360)
    local d = distance * Vector(1 + (row*0.5), 1+(row*0.5))
    local v = mod:BeahDynamicOrbit(f, p, 1, d, a)
    mod:SetFamiliarOrbitPosWOVisualBugs(f, v, v - f.Position)

    local sprite = f:GetSprite()
    if not sprite:IsPlaying("Float") then
        sprite:Play("Float", true)
    end

    EntityEffect.CreateLight(f.Position + voset, 1, 1) --err, doing this every frame might be a bad idea. or maybe my pc is just overheating a normal amount
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, apotheosisFamiliarUpdate, mod.ITEM.FAMILIAR.APOTHEOSIS_ORBITAL)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, CallbackPriority.LATE, function (_, familiar, other)
    local proj = other:ToProjectile()
    if proj then
        proj:Die()
    end
end, mod.ITEM.FAMILIAR.APOTHEOSIS_ORBITAL)

mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function()
    canDoSFX = false
end)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function (_, ent)
    if not canDoSFX then
        return
    end
    if ent.Variant == mod.ITEM.FAMILIAR.APOTHEOSIS_ORBITAL then
        Isaac.Spawn(mod.FF.GanymedePoof.ID, mod.FF.GanymedePoof.Var, mod.FF.GanymedePoof.Sub, ent.Position + voset, Vector.Zero, ent)
        sfx:Play(SoundEffect.SOUND_FREEZE_SHATTER, 0.8)
    else
        canDoSFX = false
    end
end, EntityType.ENTITY_FAMILIAR)