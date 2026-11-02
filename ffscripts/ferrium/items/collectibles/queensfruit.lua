local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    DamageMax = 10,
    DamageGain = 0.03, --Per tick
    BigBoost = 3,
    DamageRemoved = 0.4,
    DamageDecay = 0.3, --No longer decays
    DecayRate = 80,
    MinCut = 0.35,

    BaseHealth = 15,
    HealthScale = 15, --Increases by this every chapter
    Chance = 33,
    Cooldown = 60,
    ChanceMin = 12,
    ChanceMinHealth = 15,
    HealDist = 25,

    MinRatio = 0.66,
    MaxRatio = 1.7,
    SpriteSize = 210,
    BaseSize = 80,
    LerpVal = 0.15,
    AuraDelay = 5,
    AuraTime = 30,
    AuraScaling = 40,
    DetonateSize = 20,
    WarnSize = 40,
}

local lastQueensFruitProc = 0
function mod:QueensFruitNewRoom(player, d)
    lastQueensFruitProc = 0
    if d.QueensFruitDamage and d.QueensFruitDamage > 0 then
        local new = d.QueensFruitDamage*bal.DamageRemoved
        if d.QueensFruitDamage-new < bal.MinCut then
            new = 0
        end
        d.QueensFruitDamage = new
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:EvaluateItems()
    end
    d.ffsavedata.RunEffects.QueensFruitEaten = nil
end

function mod:QueensFruitDeath(npc)
	if mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.QUEENS_FRUIT, false) then
		if not (npc.Type == mod.FFID.Tech and npc.Variant > 999) and not (npc:HasEntityFlags(EntityFlag.FLAG_NO_REWARD) or npc:HasEntityFlags(EntityFlag.FLAG_NO_DEATH_TRIGGER)) then
            local level = math.ceil(game:GetLevel():GetAbsoluteStage()/2)-1
            local ratio = npc.MaxHitPoints/(bal.BaseHealth+bal.HealthScale*level)
            local min = 0
            if npc.MaxHitPoints > bal.ChanceMinHealth then
                min = bal.ChanceMin
            end
			local chance = math.max(min, bal.Chance*ratio)
            local rng = npc:GetDropRNG()
			if rng:RandomInt(100) < chance and game:GetFrameCount()-lastQueensFruitProc > bal.Cooldown then
                lastQueensFruitProc = game:GetFrameCount()
				local aura = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.FF.QueensFruitHandler.Var, mod.FF.QueensFruitHandler.Sub, npc.Position, Vector.Zero, npc):ToEffect()
                mod:GetEntityData(aura).AuraMultiplier = math.min(bal.MaxRatio, math.max(bal.MinRatio, ratio))
                aura:Update()
                sfx:Play(mod.Sounds.QueensFruitBurst, 0.55, 0, false, mod:RandomInt(80, 90, rng)/100)
                sfx:Play(mod.Sounds.QueensFruitExtra, 0.15, 0, false, mod:RandomInt(115, 130, rng)/100)
			end
		end
	end
end
mod:AddCollectibleCallback("FF_POST_NPC_DEATH_FERRIUM", mod.ITEM.COLLECTIBLE.QUEENS_FRUIT, mod.QueensFruitDeath)

function mod:QueensFruitUpdate(player, d)
    if d.QueensFruitDamage and d.QueensFruitDamage > 0 then
        if player.FrameCount % bal.DecayRate == 0 then
            d.QueensFruitDamage = math.max(0, (d.QueensFruitDamage-bal.DamageDecay))
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            player:EvaluateItems()
        end
    end
end

function mod:QueensFruitHandlerEffect(e)
    local d = mod:GetEntityData(e)
    local rng = e:GetDropRNG()
    if not d.init then
        d.State = "Init"
        d.StateFrame = 0
        e.SpriteScale = Vector.Zero
        d.AuraMultiplier = d.AuraMultiplier or 1
        for i=1,11 do
            mod.scheduleForUpdate(function()
                local splash = Isaac.Spawn(mod.FF.QueensFruitSplash.ID, mod.FF.QueensFruitSplash.Var, mod.FF.QueensFruitSplash.Sub, e.Position, Vector.Zero, e):ToEffect()
                splash.Parent = e
                mod:GetEntityData(splash).Angle = i*33+mod:RandomInt(-10,10,rng)
                splash:Update()
            end, rng:RandomInt(9))
        end
        e.DepthOffset = -1000
        d.init = true
    else
        d.StateFrame = d.StateFrame+1
    end
    local dist = e.SpriteScale.X*bal.SpriteSize

    if not mod.IsActiveRoom() then
        if e.Color.A > 0 then
            e.Color = Color(e.Color.R, e.Color.G, e.Color.B, math.max(0, e.Color.A-0.08))
        else
            e:Remove()
        end
    elseif d.State == "Init" then
        local targ = bal.BaseSize*d.AuraMultiplier
        if targ-dist < 0.2 then
            local final = targ/bal.SpriteSize
            e.SpriteScale = Vector(final, final)
            d.State = "Idle"
            d.StateFrame = 0
            d.AuraDecay = final/(bal.AuraTime+d.AuraMultiplier*bal.AuraScaling)
        else
            local val = mod:Lerp(dist, targ, bal.LerpVal)
            val = val/bal.SpriteSize
            e.SpriteScale = Vector(val, val)
        end
    elseif d.State == "Idle" then
        if d.StateFrame > bal.AuraDelay then
            local targ = e.SpriteScale.X-d.AuraDecay
            e.SpriteScale = Vector(targ, targ)
            if bal.SpriteSize*targ < bal.DetonateSize then
                d.State = "Remove"
            end
        end
    elseif d.State == "Remove" then
        for i=1, game:GetNumPlayers() do
            local p = Isaac.GetPlayer(i-1)
            if p.Position:Distance(e.Position) < bal.HealDist then
                local dat = mod:GetEntityData(p)
                local mult = 1
                if p:GetCollectibleNum(mod.ITEM.COLLECTIBLE.QUEENS_FRUIT) > 1 then
                    mult = p:GetCollectibleNum(mod.ITEM.COLLECTIBLE.QUEENS_FRUIT)
                end
                if not dat.ffsavedata.RunEffects.QueensFruitEaten then
                    dat.ffsavedata.RunEffects.QueensFruitEaten = true
                    sfx:Play(SoundEffect.SOUND_VAMP_GULP, 1, 0, false, 1)
                    p:AddHearts(mult)
                    local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, p.Position, Vector.Zero, p):ToEffect()
                    poof.SpriteOffset = Vector(0,-40)
                    poof:FollowParent(p)
                    poof:Update()
                else
                    dat.QueensFruitDamage = math.min(bal.DamageMax*mult, (dat.QueensFruitDamage or 0)+bal.BigBoost*mult)
                    p:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                    p:EvaluateItems()
                    sfx:Play(SoundEffect.SOUND_SMB_LARGE_CHEWS_4, 1, 0, false, 1)
                end
            end
            for j=1,6 do
                local vel = Vector(mod:getRoll(5,45,rng)/10,0):Rotated(rng:RandomInt(360))
                local gib = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_PARTICLE, 0, e.Position, vel, e):ToEffect()
            end
            local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 4, e.Position, Vector.Zero, e)
            sfx:Play(SoundEffect.SOUND_MOTHER_WRIST_EXPLODE, 0.5, 0, false, mod:getRoll(110,120,rng)/100)
            sfx:Play(SoundEffect.SOUND_MOTHER_ISAAC_HIT, 0.8, 0, false, 1)
        end
        e:Remove()
    end

    if d.State ~= "Remove" and mod.IsActiveRoom() and e.FrameCount > 7 then
        local warn
        if d.State == "Idle" then
            local targ = e.SpriteScale.X-d.AuraDecay
            if bal.SpriteSize*targ < bal.WarnSize then
                warn = true
            end
        end
        if e.FrameCount % 6 == 0 then
            local rangle = rng:RandomInt(360)
            for i=1,3 do
                local ang = rangle+120*i+mod:RandomInt(-30,30,rng)
                local pos = e.Position+Vector(e.SpriteScale.X*bal.SpriteSize*0.95, 0):Rotated(ang)
                local splash = Isaac.Spawn(mod.FF.QueensFruitSplash.ID, mod.FF.QueensFruitSplash.Var, mod.FF.QueensFruitSplash.Sub, pos, Vector.Zero, e):ToEffect()
                splash.Parent = e
                mod:GetEntityData(splash).Gorged = warn
                mod:GetEntityData(splash).Angle = ang
                splash:Update()
            end
        end
        for i=1, game:GetNumPlayers() do
            local p = Isaac.GetPlayer(i-1)
            if p.Position:Distance(e.Position) < dist then
                local mult = 1
                if p:GetCollectibleNum(mod.ITEM.COLLECTIBLE.QUEENS_FRUIT) > 1 then
                    mult = p:GetCollectibleNum(mod.ITEM.COLLECTIBLE.QUEENS_FRUIT)
                end
                mod:GetEntityData(p).QueensFruitDamage = math.min(bal.DamageMax*mult, (mod:GetEntityData(p).QueensFruitDamage or 0)+bal.DamageGain*mult)
                p:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                p:EvaluateItems()
            end
        end
    end
end

function mod:QueensFruitSplashEffect(e)
    local d = mod:GetEntityData(e)
    local sprite = e:GetSprite()
    if not d.init then
        local rng = e:GetDropRNG()
        local sca = mod:RandomInt(40,75,rng)/100
        e.SpriteScale = Vector(sca, sca)
        d.RandomFrame = e:GetDropRNG():RandomInt(4)
        if d.Gorged and e.Parent and e.Parent:Exists() then
            local adjusted = bal.WarnSize-bal.DetonateSize
            local extra = (adjusted-e.Parent.SpriteScale.X*bal.SpriteSize)/adjusted
            e.Color = Color(1, 0, 0, 1, 0, 0, 0, 1+extra, 0, 0, 1)
        else
            e.Color = Color(1, 0, 0, 1, 0, 0, 0, 1, mod:RandomInt(0, 12, rng)/100, mod:RandomInt(0, 12, rng)/100, 1)
        end
        e.DepthOffset = 1000
        d.init = true
    end

    if e.Parent and e.Parent:Exists() then
        local dist = e.Parent.SpriteScale.X*bal.SpriteSize*0.95
        local targ = e.Parent.Position+Vector(dist, 0):Rotated(d.Angle)
        e.Velocity = targ-e.Position

        if d.Gorged then
            local adjusted = bal.WarnSize-bal.DetonateSize
            local extra = math.max(0, (1-(e.Parent.SpriteScale.X*bal.SpriteSize-adjusted)/adjusted)*5)
            e.Color = Color(1, 0, 0, 1, 0, 0, 0, 1+extra, 0, 0, 1)
        end
    else
        e.Velocity = Vector.Zero
    end

    if sprite:IsFinished("Sploch" .. d.RandomFrame) then
        e:Remove()
    else
        mod:spritePlay(sprite, "Sploch" .. d.RandomFrame)
    end
end