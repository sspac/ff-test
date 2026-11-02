local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local blackmoonVolume = 0.3
local blackmoonAnimEnd = 95

local flag = TearFlagsLib.RegisterTearFlag("BLACK_MOON")

function mod.blackMoonSoundStuff()
    --[[if sfx:IsPlaying(mod.Sounds.BlackMoonLoop) then
        local readyToStop = true
        for _, blackmooner in ipairs(Isaac.FindByType(1000, 666, 170, false, false)) do
            if blackmooner:GetSprite():GetFrame() < blackmoonAnimEnd then
                readyToStop = false
            end
        end
        if readyToStop then
            sfx:Stop(mod.Sounds.BlackMoonLoop)
            sfx:Play(mod.Sounds.BlackMoonEnd,blackmoonVolume,0,false,1)
        end
    end]]
end

function mod:updateBlackMoonTearLaserColor(player)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.BLACK_MOON) then
		player.TearColor = player.TearColor * FiendFolio.ColorShadyRed
		player.LaserColor = player.LaserColor * FiendFolio.ColorShadyRed
	end
end
mod:AddCollectibleCallback(ModCallbacks.MC_EVALUATE_CACHE, FiendFolio.ITEM.COLLECTIBLE.BLACK_MOON, mod.updateBlackMoonTearLaserColor, CacheFlag.CACHE_TEARCOLOR)

function mod:blackMoonFlagGeneric(entity, player, weaponFlag)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.BLACK_MOON) then
		TearFlagsLib.AddTearFlags(entity, flag)
	end
end
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.COLLECTIBLE.BLACK_MOON, mod.blackMoonFlagGeneric)
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_CHANCELESS_TEARFLAGS, FiendFolio.ITEM.COLLECTIBLE.BLACK_MOON, mod.blackMoonFlagGeneric)

function mod:blackMoonFlagLocust(entity, player, weaponFlag)
	TearFlagsLib.AddTearFlags(entity, flag)
end
mod:AddEntityCallback(TearFlagsLib.Callback.POLL_LOCUST_TEARFLAGS, EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, 
                      FiendFolio.ITEM.COLLECTIBLE.BLACK_MOON, mod.blackMoonFlagLocust, FiendFolio.ITEM.COLLECTIBLE.BLACK_MOON)

function mod:applyBlackMoonFlag(entity, player, source)
	for i = 1, 2 do
        mod.scheduleForUpdate(function()
            --safety check
            if not player or (player and not player:Exists()) then
                player = Isaac.GetPlayer()
            end
            if entity and entity:Exists() and entity:IsEnemy() and entity:IsDead() and not (mod:GetEntityData(entity).checkedBlackMoon or (entity.Type == mod.FFID.Tech and entity.Variant > 999)) then
                local cloud = Isaac.Spawn(1000, 666, 170, entity.Position, nilvector, player)
                local scale = math.log(entity.MaxHitPoints, 1.3)
                scale = math.min(scale, 100)
                scale = math.max(scale, 5)
                mod:GetEntityData(cloud).Scale = scale
                mod:GetEntityData(cloud).Parent = player
                cloud:Update()
                --[[if not (sfx:IsPlaying(mod.Sounds.BlackMoonIntro) or sfx:IsPlaying(mod.Sounds.BlackMoonLoop)) then
                    sfx:Play(mod.Sounds.BlackMoonIntro,blackmoonVolume,0,false,1)
                    sfx:Stop(mod.Sounds.BlackMoonEnd)
                end]]
                mod:GetEntityData(entity).checkedBlackMoon = true
            end
        end, i)
    end
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.applyBlackMoonFlag, flag)

function mod:blackMoonAura(eff)
    local sprite = eff:GetSprite()
    local d = mod:GetEntityData(eff)
    local player = eff.Parent or Isaac.GetPlayer()
    local baseSize = 17

    local circleRange = (player.TearRange/260) / baseSize
    circleRange = math.max(circleRange, 1/(baseSize * 2))
    circleRange = math.min(circleRange, 1/10)

    if not d.init then
        sprite:Load("gfx/effects/bigRedCircle.anm2", true)
        sprite:Play("AuraOnly", true)
        sprite.Scale = Vector(d.Scale * circleRange, d.Scale * circleRange)
        local cloud = Isaac.Spawn(1000, 666, 171, eff.Position, nilvector, eff)
        cloud.Parent = eff
        cloud:Update()
        d.init = true
    end

    if sprite:GetFrame() < blackmoonAnimEnd then
        --[[if not (sfx:IsPlaying(mod.Sounds.BlackMoonIntro) or sfx:IsPlaying(mod.Sounds.BlackMoonLoop)) then
            sfx:Play(mod.Sounds.BlackMoonLoop,blackmoonVolume,0,false,1)
        end]]
    end

    --eff.SpriteScale = Vector(1, 0.5)
    eff.DepthOffset = -100

    local playerInside
    local procFrame = 5
    if eff.FrameCount % procFrame == 0 then
        local radius = sprite.Scale.X * 80
        for _,enemy in ipairs(Isaac.FindInRadius(eff.Position, radius + 300, EntityPartition.ENEMY)) do
            local pp = enemy.Position
            local ep = eff.Position
            local size = enemy.Size
            if math.abs(ep.X - pp.X) < radius + size and math.abs(ep.Y - pp.Y) < (radius/2) + size and pp:Distance(ep) < (radius * 0.95) + size then
                --playerInside = true
                local damage = ((player.Damage * procFrame ) / math.max(player.MaxFireDelay, 0.01))*0.5
                enemy:TakeDamage(damage, 0, EntityRef(eff), 5)
            end

        end
    end
    if playerInside then
        eff.Color = Color(0,1,1)
    else
        eff.Color = Color(1,1,1)
    end
    --d.cap = d.cap or 30
    --sprite.PlaybackSpeed = 100 / d.cap
    if sprite:IsFinished("AuraOnly") then
        eff:Remove()
    end
end

function mod:blackMoonMiddle(eff)
    local sprite = eff:GetSprite()
    local d = mod:GetEntityData(eff)

    if not d.init then
        sprite:Load("gfx/effects/bigRedCircle.anm2", true)
        sprite:Play("AlakazamOnly", true)
        d.init = true
    end
    if eff.Parent then
        sprite:SetFrame("AlakazamOnly", eff.Parent:GetSprite():GetFrame())
        sprite.Scale = eff.Parent:GetSprite().Scale
    else
        eff:Remove()
    end
end

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.BLACK_MOON] = {
	TearColor = FiendFolio.ColorShadyRed,
	BodyColor = Color(1,1,1,1,40.522/255,0,0,0.637,0/255,0/255,1),
	EyeAColor = Color(1,1,1,1,-14.265/255,-14.265/255,-14.265/255,0.347,0.347,0.347,1),
	EyeBColor = Color(1,1,1,1,-14.265/255,-14.265/255,-14.265/255,0.347,0.347,0.347,1)}

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	TearFlagsLib.AddTearFlags(tear, TearFlagsLib.Flag.BLACK_MOON)
end, FiendFolio.ITEM.COLLECTIBLE.BLACK_MOON)