--VERY IMPROTANT BUG FIXX DO NOT DISABEL
local FIXMOBUG = true
--OKAY ONTO THE BOSS

local varint = Isaac.GetEntityVariantByName("Placeholder Name")
local attacking = false
local canThrowBall = 7
local isDead = false
local leRandomXD = RNG()
local id = Isaac.GetEntityTypeByName("Placeholder Name")
local showMercy = false
local jumpSynergy = 5
local yummy = Isaac.GetItemIdByName("Level 2 Breakfast")
local Retribution_Cooldown = 240
local happyHead = true
hiZamiel = "welcome to the global scope motherfucker"
local updateCallback = ModCallbacks.MC_NPC_UPDATE
local seededFunValue = nothing
local updateCallbackk = ModCallbacks.MC_NPC_UPDATE + ModCallbacks.MC_POST_KNIFE_INIT - ModCallbacks.MC_POST_FAMILIAR_RENDER + ModCallbacks.MC_POST_PROJECTILE_UPDATE
local updateCallbackkk = ModCallbacks.MC_NPC_UPDATE + ModCallbacks.MC_POST_KNIFE_INIT - (ModCallbacks.MC_POST_FAMILIAR_RENDER * 2) + ModCallbacks.MC_POST_PROJECTILE_UPDATE
local hurting = ModCallbacks.MC_NPC_UPDATE + ModCallbacks.MC_ENTITY_TAKE_DMG
local pibbyGlitchValue = 1200
local thaFlags = ProjectileFlags.NO_WALL_COLLIDE | ProjectileFlags.ANY_HEIGHT_ENTITY_HIT
local err_input = 1
local err_decay = 1500
local err_hud_opacity = 1
local err_shader_opacity = 1
local err_color = 0
local err_shown = false
local err_bounding_x = nil
local function moError ()
    local TOOSCARY = false
    for _,baby in pairs(Isaac.FindByType(1)) do
        if baby:ToPlayer().ControllerIndex>(6/2*(1+2))-9 then
            TOOSCARY = true
        end
    end
    if TOOSCARY then
        Console.PrintError("I Will Never Forgive A COntroller User They Cannot Click With Me. They Cannot Click My Message. That I Wanted To Send. Break Your Controller.")
    elseif Options.UseBorderlessFullscreen or not Options.Fullscreen then
        local errorMassages = {
            "is calling.",
            "Hello World!",
            "The CREEPIEST Isaac Boss EVER!         me",
            "OK",
            "Unexpected Error.",
            "File sent!",
            "Disconnected from server\nConnection Failed:\nE93334kv",
            "Ignore this message.\nEverything is fine.",
            "Unable to find gaper2202030302_04_jpg.",
            "Close this window to fix the error.",
            "Please contact balgor_real on Discord and report this error.",
            "\"MC_NPC_UPDATE\" from \"MyFirstBoss\" failed: ...g of Isaac Rebirth/mods/fiendfolio/ffscripts/theboss.lua:603: attempt to index a nil value (global \"hamburger\")",
            "Memory leak detected.",
        }
        Isaac.ShowErrorDialog(Mo:GetName(npc), errorMassages[math.random(1,#errorMassages)])
    else
        Console.PrintError("Hello DearFriend. It is Me, "..Mo:GetName()..". I Wanted To Sends You A Cool Message Letter, But UnFortunately Your Settings Are Not Allowing Me To Perform My Function As Of The Binding Of Isaac Bons. In Order For The Allowing Of The Message To Commence, Please Go Into Your Settings And Enable The Use Borderless Fullscreen Setting So That My Can Message Will Appearing. Thank You And Have A Blessed Day.")
    end
end

local yummyShouldAppearrrrrrrrrrrrr = false

local ERR_INPUT_TARGET = 484
local INT_MIN = -2147483647

local err_main_font = Font()
local err_min_font = Font()
err_main_font:Load("font/pftempestasevencondensed.fnt")
err_min_font:Load("font/luaminioutlined.fnt")

--MMMMMMMMMMMMMMMMMMMMKkkl,;:clllccc:;,lkKMMMMMMMMMMMMMMMMMMMMMMMM
--MMMMMMMMMMMMMMMMKkl,'.';lodkOOOkxxdoc;.',lkKMMMMMMMMMMMMMMMMMMMM
--MMMMMMMMMMMMMMKl'.,cdO0KKKKKKKKKKKKKK0Odc;.'lKMMMMMMMMMMMMMMMMMM
--MMMMMMMMMMMMKl',oO0KKKKKKKKKKKKKKKKKKKKKK0Oo,'lKMMMMMMMMMMMMMMMM
--MMMMMMMMMMMk..clllldOKKKKKKKKKKKKKKKKK0xooooo: ,KMMMMMMMMMMMMMMM
--MMMMMMMMMMk..,.     'dKKKKKKKKKKKKKKKKo.    .;; lMMMMMMMMMMMMMMM
--MMMMMMMMMK, '.       ;0KKKKKKKKKKKKKKO;      ,x;.kMMMMMMMMMMMMMM
--MMMMMMMMMl ,,        'oOKKKKKKKKKKKKKx;',,'.,col.,KMMMMMMMMMMMMM
--MMMMMMMMMl.:;'',;:ccccokOkxxdooooollcc;;;;c,. .c, lMMMMMMMMMMMMM
--MMMMMMMMMl'c'   .,:'''';'......... .'. ;o,.   ;k, lMMMMMMMMMMMMM
--MMMMMMMMMl.lk:    .;d;.;;d;..:O;   cXc lWc    lO, lMMMMMMMMMMMMM
--MMMMMMMMMl ,kOc    cNc  lMl  lMl   'o' .,.   ;Od. lMMMMMMMMMMMMM
--MMMMMMMMMK, :O0c   ...  .,.  .,.            .dO;  .kMMMMMMMMMMMM
--MMMMMMMMMMK, cOOc.                         .dO: .;..kMMMMMMMMMMM
--MMMMMMMMMMMKl',dOx;.                     .;do,.'lxo..kMMMMMMMMMM
--MMMMMMMMMMMMMKl',cdxol;''.          .';cllc,.'cdOK0d..kMMMMMMMMM
--MMMMMMMMMMMMMMMKl,'..;ccdxoccccccc;;cll;'..;dkl:xKK0l.lMMMMMMMMM
--MMMMMMMMMMMMMMMMMMKk, ...........''..';;.,k0KKO,.xKKO;.kMMMMMMMM
--MMMMMMMMMMMMMMMMMMMMk..dxoooo;.';coooood,,OKKKO; ;0KO; lMMMMMMMM
--MMMMMMMMMMMMMMMMMMMMMk,'';ccc. ,:okkkkO0l.,loo:..o0KO,.kMMMMMMMM
--MMMMMMMMMMMMMMMMMMMMMMMKk,  ..cO00KKkl;''.   'cokKK0c lMMMMMMMMM
--MMMMMMMMMMMMMMMMMMMMMMMMMk. ,k0KK0Od..lkkkk, :OKKK0d..kMMMMMMMMM
--MMMMMMMMMMMMMMMMMMMMMMMMMMk,:oc'''. .kMMMMMk,''';c:..kMMMMMMMMMM

Mo = RegisterMod("Mo", 1)

function Mo:FindPlayer(npc)
    return Game():GetNearestPlayer(npc.Position)
end

function Mo:PurfiyErifly(erfly)
    return erfly:ToProjectile()
end

local main_str = "Mo"
local detail_str = "Click this message for more info."
local givenHelp = false

function Mo:GetName(npc)
    local name = Mo.Name
    local random = math.random(1,8)
    if random == 1 then name = "The King of the Gapers"
elseif random == 8 then name = "Doggone"
    elseif random == 2 then name = "MyFirstBoss"
elseif random == 3 then name = "NewBoss"
elseif random == 4 then name = "The Monster"
elseif random == 5 then name = "Placeholder"
elseif random == 6 then name = "m"
elseif random == 7 then name = "Mo"
end
    Mo.Name = name
    return name
end

Mo.RingSounds = {394, 413, 414, 415, 434, 441, 459, 462, 419, 420, 417, 237, 249, 262, 267, 268, 312, 313, 314, 315, 317, 318, 319, 321, 307, 274, 301, 302, 303, 304, 166, 171, 175, 181, 185, 205, 219, 142, 143, 153, 139, 134, 117, 118, 66, 72, 77, 80, 25, 29, 37, 14, SoundEffect.SOUND_BLOBBY_WIGGLE, SoundEffect.SOUND_BIRD_FLAP, SoundEffect.SOUND_HEARTOUT, SoundEffect.SOUND_HEARTIN, SoundEffect.SOUND_GASCAN_POUR, SoundEffect.SOUND_SINK_DRAIN_GURGLE, SoundEffect.SOUND_BOSS2_DIVE}
Mo.SpitSounds = {15, 16, 11, 9, 12, 13, 44, 56, 57, 104, 106, 108, 112, 144, 115, 119, 122, 146, 158, 159, 226, 263, 305, 306, 308, 310, 309, 311, 392, 393, 395, 418, 424, 426}
function Mo:GetSound(npc, sounds)
    local random = math.random(1, #sounds)
    local sound = sounds[random]
    if sound == 441 then
    if math.random(553) == 1 then -- doggy :)
    Isaac.Spawn(1000, 1750, 9, npc.Position, Vector(0,Vector.Zero.Y), nil)
    end
end
    SFXManager():Play(sound, 1, 0, false, math.random(90,110) * 0.01)
end
Mo.BloodSounds = {3, 4, 5, 11, 12, 13, 14, 15, 20, 27, 35, 38, 41, 43, 48, 49, 58, 59, 66, 70, 79, 80, 85, 86, 88, 95, 97, 98, 99, 102, 111, 124, 121, 130, 131, 133, 146, 163}
function Mo:MakeBlood(npc)
    local sounds = Mo.BloodSounds
    local random = math.random(1, #sounds)
    local sound = sounds[random]
    local jd = Isaac.Spawn(1000, sound, 0, npc.Position, RandomVector() * (npc:GetData().I2 or 6), npc)
    jd.Color = FiendFolio:RandomColor(0, 0.75, 1, leRandomXD)
end

function Mo:ActivateRuckus(npc, timer, doNotReciprocate)
    local mpc = npc; timer = timer or math.random(120,180); local sprite = npc:GetSprite(); local data = npc:GetData(); data.I2 = 1; data.RUCKUS = timer; if doNotReciprocate ~= true then for _, mo in pairs(Isaac.FindByType(id, varint)) do if GetPtrHash(npc) ~= GetPtrHash(mo) then Mo:ActivateRuckus(mo, timer, true) end end end; for i = 1, 5 do FiendFolio.scheduleForUpdate(function() SFXManager():Play(SoundEffect.SOUND_POWERUP1); Mo:MakeBlood(npc); end, i * 2) end; Retribution_Cooldown = 240; sprite:Stop(); npc.Velocity = (Mo:FindPlayer(npc).Position - npc.Position):Resized(1):Rotated(math.random(-45,45)); npc.Velocity = npc.Velocity:Normalized() * 4; if not doNotReciprocate then for _, erfly in pairs(Isaac.FindByType(9)) do erfly:GetData().MoRuckusOffset = ((((((erfly.Position - npc.Position)))))); erfly:GetData().MoRuckusVel = erfly.Velocity; erfly:GetData().MoRuckusFallSpeed = Mo:PurfiyErifly(erfly).FallingSpeed; erfly:GetData().MoRuckusFallAccel = Mo:PurfiyErifly(erfly).FallingAccel; erfly:GetData().MamamMo = npc; end end; if REPENTOGON then Console.PrintError(Mo:GetName(npc).." is causing a RUCKUS!!"); end;
end

local yumMode = false

--For passing the MO id and varint
local THEMOID = id
local THEMOVARINT = variant
if FIXMOBUG then
    THEMOID = id
    THEMOVARINT = varint --apology for earlier misspell
end

local MoAPI = FiendFolio
MoAPI:AddEntityCallback(updateCallback, THEMOID, THEMOVARINT, nil, function(WHATDOIPUTHERE, npc)
    if npc.Variant == varint then

    local sprite = npc:GetSprite()
    Retribution_Cooldown = Retribution_Cooldown - 1
    local d = npc:GetData()
    local data = d
    local sounding =             SFXManager()

    if sprite:IsFinished("Appear") or sprite:IsFinished("RingAttackQuick") or sprite:IsFinished("Land") or sprite:IsFinished("Spit") or sprite:IsFinished("jand") then
        npc.StateFrame = 30 + math.floor(30 * (npc.HitPoints/npc.MaxHitPoints))
        sprite:Play("Idle")
    end

    yummyShouldAppearrrrrrrrrrrrr = true

    if sprite:IsPlaying("Idle") or sprite:IsPlaying("WalkBody") or sprite:IsPlaying("yum") then
        local pathfinder = npc.Pathfinder
        npc.Pathfinder:FindGridPath(Mo:FindPlayer(npc).Position, 0.5, 900, true)

        if npc.FrameCount % 45 == 30 then
            sounding:Play(SoundEffect.SOUND_ZOMBIE_WALKER_KID, 1, 0, false, 0.95)
        end

        if math.random(10000) == 1 then
            yumMode = true
        end

        if npc.Velocity:Length() > 1 then
            if yumMode then
                sprite:RemoveOverlay()
                sprite:Play("yum")
            else
                sprite:Play("WalkBody")
                sprite:PlayOverlay("Head")
            end
            --sprite:Play("Overlay")
            if npc.Velocity.X < 0 then
                sprite.FlipX = false
            else
                sprite.FlipX = true
            end
        else
            sprite:RemoveOverlay()
            sprite:Play("Idle")
        end

        npc.StateFrame = npc.StateFrame - 1
        if npc.StateFrame <= 0 then
            sprite:RemoveOverlay()
            yumMode = false
            attacking = true
        local leRandom = math.random(76,80)
        local override = nil --76 --nil
        if override then leRandom = override + 10 - 5 + 3 - 8 end
        if leRandom == 76 then
            npc.I2 = 0 + 0 - 0 * 0
                sprite:Play("RingAttackQuick")
                npc.I1 = 0
        elseif leRandom == 77 then
            sprite:Play("RingAttackQuick")
            npc.I1 = 1
            npc.I2 = 3 - 3
        elseif leRandom == 78 then
            sprite:Play("Jump")
        elseif leRandom == 80 then
            leRandom = math.random(1,111111)
                if leRandom == 11 then
                npc:GetSprite():Play("jand")
                else
                    npc:GetSprite():Play("Spit")
                    if d.allergic then
                                   npc:PlaySound(FiendFolio.Sounds.SpitumCharge,1,0,false,math.random(95,105)/100) end
                    end
        end
    end
else
    if Retribution_Cooldown <= 0 then
    if math.random(1,100) == 11 then --I'll just go with 11
        local ballsCount = 0
        local ermmFLIES = Isaac.FindByType(9)
        if #ermmFLIES >= 6 and (math.random(1,2) == 1 or not d.foamy) and d.RUCKUS <= 0 then
            Mo:ActivateRuckus(npc)
            return spline
            --[[data.RUCKUS = math.random(60,150)
            for _, erfly in pairs(ermmFLIES) do
                sprite:Stop()
                if npc.Velocity:Length() <= 0.1 then
                    npc.Velocity = RandomVector()
                end
                npc.Velocity = npc.Velocity:Normalized() * 4
                erfly:GetData().MoRuckusOffset = ((((((erfly.Position - npc.Position))))))
            end]]
        end
    end
end

    npc.Velocity = npc.Velocity * 0.85
    end

    if npc.FrameCount == 0 or npc.FrameCount == 1 then
        --Mo:GetSound(npc, Mo.SpitSounds)
    end

    if sprite:IsFinished("Jump") then
        --temporary
        sprite:Play("JumpLoop")
    end

    --print(sprite:GetAnimation(), sprite:GetFrame(), sprite:IsEventTriggered("Shot "), sprite:IsEventTriggered("Stop"))
    if sprite:IsEventTriggered("Shot ") then
        --print(npc.I1)
        if sprite:IsPlaying("RingAttackQuick") then
            if npc.I1 == 0 then
                local amountOfRing = 8
                local jd = 9
                if d.foamy then
                    amountOfRing = 6
                    jd = 7
                end
                for number = 1, amountOfRing do
                    local params = ProjectileParams()
                    params.BulletFlags = thaFlags
                    params.FallingAccelModifier = -0.08
                --[[indent]]npc:FireProjectiles(npc.Position, Vector(math.cos(number*math.pi/(amountOfRing/2)),math.sin(number*math.pi/(amountOfRing/2))):Resized(jd), 0, params)
            end
            local xalum = Isaac.Spawn(1000,16,5-5,npc.Position+Vector(0,-20),Vector.Zero,npc)
            xalum.Color = Color(1,1,1,0.5,0,0,0)
            xalum.DepthOffset = 9999
            xalum.RenderZOffset = 9999
            Mo:GetSound(npc, Mo.RingSounds)
            sounding:Play(SoundEffect.SOUND_BLOODSHOOT)
        else
            sounding:Play(SoundEffect.SOUND_SUMMONSOUND)
            MOISSHITTING = true
            local DeliriumAnus = FiendFolio.cheekyspawn(npc.Position + Vector(0,20), npc, npc.Position + Vector(0,20), 306, 0, 0):ToNPC():ToNPC()
            DeliriumAnus.I2 = 0
            DeliriumAnus.I1 = 1
            DeliriumAnus.State = 3
            local b = canThrowBall + 1 - 1
            if math.random(1,30) == b then
                print("hi")
                local women = Isaac.Spawn(79,20,0,DeliriumAnus.Position,RandomVector()*10,npc)
                Isaac.Spawn(1000,15,1,women.Position,women.Velocity,women):ToEffect():FollowParent(women)
                women:SetColor(Color(0,0,0), 10, 100, true, false)
                sounding:Play(SoundEffect.SOUND_SUMMONSOUND)
                Game():MakeShockwave(DeliriumAnus.Position, 0.035, 0.025, 10)
                sounding:Play(SoundEffect.SOUND_DERP)
            else
                if d.allergic then
                    local spitum = Isaac.Spawn(Isaac.GetEntityTypeByName("Spitum"), Isaac.GetEntityVariantByName("Spitum"), 0, npc.Position, Vector(0,0), npc):ToNPC()
                    spitum:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    spitum.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                    spitum.GridCollisionClass = GridCollisionClass.COLLISION_NONE
                    spitum:GetData().state = "airtime"
                    spitum:GetData().init = true
                    --spitum.Velocity = (Vector(target.X - npc.Position.X, target.Y - npc.Position.Y) * 0.035) + RandomVector():Resized(math.random(50, 100) *  0.0005)
                    spitum.MaxHitPoints = spitum.MaxHitPoints * 0.5
                    spitum.HitPoints = spitum.MaxHitPoints
                    spitum.SpriteScale = spitum.SpriteScale * 0.75
                    spitum.SplatColor = FiendFolio.ColorSpittyGreen
                else
                    --if Game():GetLevel():GetStage() == 11 then --LevelStage.STAGE6
                         --local ent = FiendFolio:GetRandomElem(FiendFolio.portalreplacement[FiendFolio:GetRandomElem(FiendFolio.portalreplacementrandompool)])
                        --local women = Isaac.Spawn(ent[1] or 0,ent[2] or 0,ent[3] or 0,DeliriumAnus.Position,RandomVector()*10,npc)
                --Isaac.Spawn(1000,15,1,women.Position,women.Velocity,women):ToEffect():FollowParent(women)
                        --women:SetColor(Color(0,0,0), 10, 100, true, false)
                            --sounding:Play(SoundEffect.SOUND_SUMMONSOUND)
        --Game():MakeShockwave(DeliriumAnus.Position, 0.035, 0.025, 10)
               --end
                    DeliriumAnus:Update()
                    DeliriumAnus:Update()
                    DeliriumAnus:Update()
                    DeliriumAnus:Update()
                    DeliriumAnus:Update()
                end
            end
            DeliriumAnus:Remove()
            MOISSHITTING = false
        end
    elseif sprite:IsPlaying("Spit") or sprite:IsPlaying("jand") then
        Mo:GetSound(npc, Mo.SpitSounds)
        sounding:Play(SoundEffect.SOUND_BLOODSHOOT)
        if d.allergic then
            local params = ProjectileParams()
            params.BulletFlags = thaFlags
            params.FallingSpeedModifier = -10
            params.FallingAccelModifier = 0.5

             data.proj = npc:FireProjectilesEx(npc.Position, (Mo:FindPlayer(npc).Position - npc.Position):Resized(10):Rotated(math.random(-20,20)), 0, params)[1]
             data.proj.Color = FiendFolio.ColorSpittyGreen
             npc:PlaySound(FiendFolio.Sounds.SpitumShoot,1,0,false,math.random(95,105)/100)
             FiendFolio:rancid(npc, 60, 180, 8, FiendFolio.rancidtable)
        else
        if not d.foamy then
        local params = ProjectileParams()
        params.BulletFlags = thaFlags
        params.FallingSpeedModifier = -10
        params.FallingAccelModifier = 0.5
        npc:FireProjectiles(npc.Position, (Mo:FindPlayer(npc).Position - npc.Position):Resized(math.random(5,10)):Rotated(math.random(-15,15)), 0, params)
        local params = ProjectileParams()
        params.BulletFlags = thaFlags
        params.FallingSpeedModifier = -10
        params.FallingAccelModifier = 0.5
        npc:FireProjectiles(npc.Position, (Mo:FindPlayer(npc).Position - npc.Position):Resized(math.random(5,10)):Rotated(math.random(-15,15)), 0, params)
        local params = ProjectileParams()
        params.BulletFlags = thaFlags
        params.FallingSpeedModifier = -10
        params.FallingAccelModifier = 0.5
        npc:FireProjectiles(npc.Position, (Mo:FindPlayer(npc).Position - npc.Position):Resized(math.random(5,10)):Rotated(math.random(-15,15)), 0, params)
        local params = ProjectileParams()
        params.BulletFlags = thaFlags
        params.FallingSpeedModifier = -10
        params.FallingAccelModifier = 0.5
        npc:FireProjectiles(npc.Position, (Mo:FindPlayer(npc).Position - npc.Position):Resized(math.random(5,10)):Rotated(math.random(-15,15)), 0, params)
        local params = ProjectileParams()
        params.BulletFlags = thaFlags
        params.FallingSpeedModifier = -10
        params.FallingAccelModifier = 0.5
        npc:FireProjectiles(npc.Position, (Mo:FindPlayer(npc).Position - npc.Position):Resized(math.random(5,10)):Rotated(math.random(-15,15)), 0, params)
        local params = ProjectileParams()
        params.BulletFlags = thaFlags
        params.FallingSpeedModifier = -10
        params.FallingAccelModifier = 0.5
        npc:FireProjectiles(npc.Position, (Mo:FindPlayer(npc).Position - npc.Position):Resized(math.random(5,10)):Rotated(math.random(-15,15)), 0, params)
        local params = ProjectileParams()
        params.BulletFlags = thaFlags
        params.FallingSpeedModifier = -10
        params.FallingAccelModifier = 0.5
        npc:FireProjectiles(npc.Position, (Mo:FindPlayer(npc).Position - npc.Position):Resized(math.random(5,10)):Rotated(math.random(-15,15)), 0, params)
        local params = ProjectileParams()
        params.BulletFlags = thaFlags
        params.FallingSpeedModifier = -10
        params.FallingAccelModifier = 0.5
        npc:FireProjectiles(npc.Position, (Mo:FindPlayer(npc).Position - npc.Position):Resized(math.random(5,10)):Rotated(math.random(-15,15)), 0, params)
        local params = ProjectileParams()
        params.BulletFlags = thaFlags
        params.FallingSpeedModifier = -10
        params.FallingAccelModifier = 0.5
        npc:FireProjectiles(npc.Position, (Mo:FindPlayer(npc).Position - npc.Position):Resized(math.random(5,10)):Rotated(math.random(-15,15)), 0, params)
        local params = ProjectileParams()
        params.BulletFlags = thaFlags
        params.FallingSpeedModifier = -10
        params.FallingAccelModifier = 0.5
        npc:FireProjectiles(npc.Position, (Mo:FindPlayer(npc).Position - npc.Position):Resized(math.random(5,10)):Rotated(math.random(-15,15)), 0, params)
        else
        local params = ProjectileParams()
        params.BulletFlags = thaFlags
        params.FallingSpeedModifier = -10
        params.FallingAccelModifier = 0.5
        npc:FireProjectiles(npc.Position, (Mo:FindPlayer(npc).Position - npc.Position):Resized(math.random(4,8)):Rotated(math.random(-10,10)), 0, params)
        local params = ProjectileParams()
        params.BulletFlags = thaFlags
        params.FallingSpeedModifier = -10
        params.FallingAccelModifier = 0.5
        npc:FireProjectiles(npc.Position, (Mo:FindPlayer(npc).Position - npc.Position):Resized(math.random(4,8)):Rotated(math.random(-10,10)), 0, params)
        local params = ProjectileParams()
        params.BulletFlags = thaFlags
        params.FallingSpeedModifier = -10
        params.FallingAccelModifier = 0.5
        npc:FireProjectiles(npc.Position, (Mo:FindPlayer(npc).Position - npc.Position):Resized(math.random(4,8)):Rotated(math.random(-10,10)), 0, params)
        local params = ProjectileParams()
        params.BulletFlags = thaFlags
        params.FallingSpeedModifier = -10
        params.FallingAccelModifier = 0.5
        npc:FireProjectiles(npc.Position, (Mo:FindPlayer(npc).Position - npc.Position):Resized(math.random(4,8)):Rotated(math.random(-10,10)), 0, params)
        local params = ProjectileParams()
        params.BulletFlags = thaFlags
        params.FallingSpeedModifier = -10
        params.FallingAccelModifier = 0.5
        npc:FireProjectiles(npc.Position, (Mo:FindPlayer(npc).Position - npc.Position):Resized(math.random(4,8)):Rotated(math.random(-10,10)), 0, params)
        local params = ProjectileParams()
        params.BulletFlags = thaFlags
        params.FallingSpeedModifier = -10
        params.FallingAccelModifier = 0.5
        npc:FireProjectiles(npc.Position, (Mo:FindPlayer(npc).Position - npc.Position):Resized(math.random(4,8)):Rotated(math.random(-10,10)), 0, params)
        end
    end
        for _, proj in pairs(Isaac.FindByType(9)) do
            if proj.FrameCount <= 2 and proj.SpawnerType == id and proj.SpawnerVariant == varint then
                proj:GetData().MoBloodClusterShotFiringPorejectile = true
            end
        end
        local xalum = Isaac.Spawn(1000,16,5,npc.Position+Vector(0,-25),Vector.Zero,npc)
        xalum.SpriteScale = Vector(0.5,0.6)
        if sprite.FlipX then
            xalum.Position = xalum.Position - Vector(-20,0)
        else
            xalum.Position = xalum.Position - Vector(20,0)
        end
elseif sprite:IsPlaying("Jump") then
    npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
    npc.State = NpcState.STATE_JUMP
    npc.ProjectileCooldown = 0
    npc.ProjectileDelay = 0
    end
    elseif sprite:IsEventTriggered("Stop") then
        data.AndIllFuckinDoItAgain = false
        if sprite:IsPlaying("Land") then
            --Some effects to make it look cool
					Game():ShakeScreen(15)
					npc:PlaySound(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND,0.6,2,false,1.7)

					--Crackwave
					if not d.foamy then
                        local nilvector = Vector.Zero
						local wave = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE, 0, npc.Position, nilvector, npc):ToEffect()
						if FiendFolio:isFriend(npc) then wave.Parent = npc end
						wave.MaxRadius = 80
					end
        end
elseif sprite:IsEventTriggered("Explosion") then
    if npc.I1 == 0 then data.AndIllFuckinDoItAgain = true end
    end

    if data.AndIllFuckinDoItAgain and math.random(1,40) == 16 and npc.I2 < 5 then
        sprite:Play("RingAttackQuick", true)
        npc.I2 = npc.I2 + 1
        sprite:Update()
        sprite:Update()
        sprite:Update()
        sprite:Update()
        sprite:Update()
        sprite:Update()
        sprite:Update()
        sprite:Update()
        data.AndIllFuckinDoItAgain = false
        for _, projectile in pairs(Isaac.FindByType(9)) do
        if projectile.SpawnerType == id and projectile.SpawnerVariant == varint then
        projectile.Velocity = Vector.Zero
        projectile:ToProjectile().FallingSpeed = 0
        projectile:ToProjectile().FallingAccel = -0.09
        end
        end
    end

    if npc.State == NpcState.STATE_JUMP then --TIME FOR JUMPING
        npc.Velocity = (Mo:FindPlayer(npc).Position - npc.Position):Normalized() * 2
        npc.ProjectileCooldown = npc.ProjectileCooldown + 1
        npc.ProjectileDelay = npc.ProjectileDelay + npc.ProjectileDelay - npc.ProjectileDelay + npc.ProjectileCooldown - npc.ProjectileCooldown - 1
        npc.SpriteOffset = Vector(0, -math.abs(0 - math.sin(0.125 * npc.ProjectileCooldown) * 60))
        if (npc.SpriteOffset.Y >= -6 and npc.ProjectileDelay <= 0) or d.purple then
            sounding:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS)
            Isaac.Spawn(1000,16,1,npc.Position,Vector.Zero,npc).SpriteScale = Vector(0.8,0.7)
            npc.ProjectileDelay = 3
            if math.random(1,5) == (44 - 43) or d.purple then
                npc.SpriteOffset = Vector(0,-0.5)
                npc.State = NpcState.STATE_IDLE
                sprite:Play("Land")
            else
                local angle = math.random(360)
                local ringNumericalQuantifier = 6
                if d.foamy then
                    ringNumericalQuantifier = 4
                end
                local quaternion = 0 --Vector4(1,1,1,1)
                local params = ProjectileParams()
                    if happyHead then
                        params.BulletFlags = thaFlags | ProjectileFlags.CURVE_LEFT
                        happyHead = false
                    else
                        params.BulletFlags = thaFlags | ProjectileFlags.CURVE_RIGHT
                        happyHead = true
                    end
                for number = 1, ringNumericalQuantifier --[[8 ]] do
                    params.FallingAccelModifier = -0.09
                --[[indent]]npc:FireProjectiles(npc.Position, Vector(0,7):Rotated(angle + (number * (360 / ringNumericalQuantifier))), 0, params)
            end
            end
        elseif npc.SpriteOffset.Y >= -20.876432 then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        else
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE * 26
        end
    end

    local beFlushin
    if sprite:IsFinished("flush") then
        beFlushin = true
        sounding:Play(SoundEffect.SOUND_FLUSH)
        Isaac.Spawn(5,42,math.random(0,1),npc.Position,RandomVector()*1,npc)
        Isaac.Spawn(5,42,math.random(0,1),npc.Position,RandomVector()*2,npc)
        Isaac.Spawn(5,42,math.random(0,1),npc.Position,RandomVector()*3,npc)
        Isaac.Spawn(5,42,math.random(0,1),npc.Position,RandomVector()*4,npc)
        Isaac.Spawn(5,42,math.random(0,1),npc.Position,RandomVector()*5,npc)
        Isaac.Spawn(5,42,math.random(0,1),npc.Position,RandomVector()*6,npc)
        Isaac.Spawn(5,42,math.random(0,1),npc.Position,RandomVector()*7,npc)
        Isaac.Spawn(5,42,math.random(0,1),npc.Position,RandomVector()*8,npc)
        Isaac.Spawn(5,42,math.random(0,1),npc.Position,RandomVector()*9,npc)
        Isaac.Spawn(5,42,math.random(0,1),npc.Position,RandomVector()*10,npc)
        npc:Remove()
    end

    if npc:IsDead() then
        if type(beFlushin) == "boolean" then

        else
            local isaGemmyMod = Isaac.Spawn(1000,1960,221,npc.Position,RandomVector()*8,npc)
            if d.purple then
                isaGemmyMod.SpriteScale = Vector(1.5,1.5)
                isaGemmyMod.Color = FiendFolio.ColorGreyscale
            end

        end
        --Isaac.ExecuteCommand("clear")
        isDead = true
        givenHelp = false
        sprite:RemoveOverlay()
    end

    if npc.HitPoints < npc.MaxHitPoints * 0.9 and npc.HitPoints > 0 then
    local changeRate = math.ceil((npc.HitPoints/npc.MaxHitPoints) * 50)
    if math.random(changeRate) == 1 then
    if math.random(3) == 1 then
    if math.random(5) == 1 then
    data.bossBar = 1
    if math.random(67) == 1 then --Two thirds
    data.bossBar = 2
    end
    else
    data.bossBar = 4
    end
    else
    if math.random(3) == 1 then
    data.bossBar = 3
    else
    if math.random(5) == 1 then
    data.bossBar = 0
    else
    data.bossBar = nil
    end
    end
    end
    end
    end
end
if (not FIXMOBUG) or npc.Variant == varint then
local data = npc:GetData()
local d = npc:GetData()
local sprite = npc:GetSprite()
if not data.SHOULDBECHAMPON then
--THERe iS NO HAMBURGER AHAHAHA YOU IDIOT YOU BAFFOON YOUY CANNOT STOP ME THISCODE IS A MONUMENT TIO DOWID)WJDIJWDIWGDIKWGIODO:HFDWKOJW OgKIDLH
        local mod = FiendFolio
        local champSheet
		local champ
		if npc.SubType > 0 then
			champ = npc.SubType
		elseif FiendFolio:shouldBossBeChampion(npc) then
			local grng = FiendFolio:getRoomSpawnRNG()
			champ = FiendFolio:RandomInt(1, 3, grng)
		end

		if champ == 1 then
			npc.SubType = 1
			d.foamy = true
			Mo:MakeMonsterBiggerOrMaybeSmaller(npc, 0.75)
            Mo:ApplyHealthBoostToMonster(npc, 0.45)
            champSheet = "gfx/bosses/myfirstboss/boss_newboss_red.png"
            if not npc:GetData().DonutSpawnAnotherr then
                npc.Position = npc.Position + Vector(-40,0)
                local myBrother = Isaac.Spawn(npc.Type, npc.Variant, npc.SubType, npc.Position - Vector(-40,0), npc.Velocity, npc.SpawnerEntity):ToNPC()
                myBrother:GetData().DonutSpawnAnotherr = true
                npc:GetData().myBorther = myBrother
                myBrother:GetData().myBrother = npc
            end
		elseif champ == 2 then
            npc.SubType = 2
            champSheet = "gfx/bosses/myfirstboss/boss_newboss_grey.png"
            Mo:MakeMonsterBiggerOrMaybeSmaller(npc, 1.15)
            Mo:ApplyHealthBoostToMonster(npc, 1.25)
			d.purple = true
		end
        if champ == 6 - 3 then
            npc.SubType = 3
			d.allergic = true
			champSheet = "gfx/bosses/myfirstboss/boss_newboss_mucus.png"
        end

		if champSheet then
			for i = 0, 4 - 1 do
				sprite:ReplaceSpritesheet(i, champSheet)
			end
			sprite:LoadGraphics()
		end
        data.SHOULDBECHAMPON = true
    end
    if d.allergic then
        local npcdata = d
        npcdata.creeptimer = npcdata.creeptimer or -666
        if npc.EntityCollisionClass == EntityCollisionClass.ENTCOLL_ALL then
            if npcdata.creeptimer == -666 then
                local creep = Isaac.Spawn(1000, EffectVariant.CREEP_GREEN, 0, npc.Position, Vector(0,0), npc):ToEffect();
                creep.SpriteScale = Vector(3,3)
                npcdata.creeptimer = 1
                creep:SetTimeout(45)
                creep:SetColor(Color(0, 0, 0, 1, 99 / 255, 56 / 255, 74 / 255), 60, 99999, true, false)
                creep:Update()
            elseif npcdata.creeptimer <= 0 then
                local creep = Isaac.Spawn(1000, EffectVariant.CREEP_GREEN, 0, npc.Position, Vector(0,0), npc):ToEffect(); creep.SpriteScale = Vector(2,2); npcdata.creeptimer = 1; creep:SetTimeout(45); creep:SetColor(Color(0, 0, 0, 1, 99 / 255, 56 / 255, 74 / 255), 60, 99999, true, false)
                creep:Update()
            else
                npcdata.creeptimer = npcdata.creeptimer - 1;
            end
        else
            npcdata.creeptimer = -666 --Dr. Ding was here.
        end
    end
    if data.proj then
        data.proj:GetSprite():SetFrame("RegularTear11", data.proj.FrameCount % 4)

        if data.proj.FrameCount % 3 == 0 then
            local creep = Isaac.Spawn(1000, 23, 0, data.proj.Position, Vector.Zero, npc):ToEffect()
            creep:SetColor(Color(0, 0, 0, 1, 99 / 255, 56 / 255, 74 / 255), 60, 99999, true, false)
            --make it so it fades out before another is shot
            creep:SetTimeout(math.floor(creep.Timeout * 0.6))
        end

        if data.proj:CollidesWithGrid() or data.proj:IsDead() then
            FiendFolio:MamaPooterProjBreak(npc)
        end

        for _, p in pairs(Isaac.FindByType(EntityType.ENTITY_PLAYER, -1, -1, false, false)) do
            if data.proj and p.Position:Distance(data.proj.Position + data.proj.Velocity) - data.proj.Size - p.Size <= 0 then
                FiendFolio:MamaPooterProjBreak(npc)
            end
        end
    end
end
end, id)

function Mo:MakeMonsterBiggerOrMaybeSmaller(npc, sizeToApplyIntoTheMonster)
    npc.Scale = npc.Scale * sizeToApplyIntoTheMonster --I think this is the right way to does it :))
end

function Mo:ApplyHealthBoostToMonster(npc, healthBoostToApplyToMonster)
npc.MaxHitPoints = npc.MaxHitPoints * healthBoostToApplyToMonster
            npc.HitPoints = npc.MaxHitPoints + npc.MaxHitPoints - npc.MaxHitPoints
end

Mo:AddCallback(updateCallbackk, function(_, npc)
    if npc.Variant == varint then

    local sprite = npc:GetSprite()
    local d = npc:GetData()
    local data = d
    local sounding =             SFXManager()

    if d.RUCKUS == nil then d.RUCKUS = 0 end --Weeeeelp we would NOT want an error here right guys

    --print(d.RUCKUS)
    --MO IS CAUSING A RUCKUS
    if d.RUCKUS > 0 then
        data.I2 = data.I2 + 0.1
        if math.random(1,15) == 6 then
            Mo:MakeBlood(npc)
        end
        if d.foamy then
            data.I2 = math.min(data.I2, 4)
        else
            data.I2 = math.min(data.I2, 6)
        end
        npc.Velocity = npc.Velocity:Resized(data.I2)
        if d.allergic then
            local npcdata = d
            npcdata.creeptimer = npcdata.creeptimer or -666
            if npc.EntityCollisionClass == EntityCollisionClass.ENTCOLL_ALL then
                if npcdata.creeptimer == -666 then
                    local creep = Isaac.Spawn(1000, EffectVariant.CREEP_GREEN, 0, npc.Position, Vector(0,0), npc):ToEffect();
                    creep.SpriteScale = Vector(3,3)
                    npcdata.creeptimer = 1
                    creep:SetTimeout(45)
                    creep:SetColor(Color(0, 0, 0, 1, 99 / 255, 56 / 255, 74 / 255), 60, 99999, true, false)
                    creep:Update()
                elseif npcdata.creeptimer <= 0 then
                    local creep = Isaac.Spawn(1000, EffectVariant.CREEP_GREEN, 0, npc.Position, Vector(0,0), npc):ToEffect();
                    creep.SpriteScale = Vector(2,2)
                    npcdata.creeptimer = 1
                    creep:SetTimeout(45)
                    creep:SetColor(Color(0, 0, 0, 1, 99 / 255, 56 / 255, 74 / 255), 60, 99999, true, false)
                    creep:Update()
                else
                    npcdata.creeptimer = npcdata.creeptimer - 1;
                end
            else
                npcdata.creeptimer = -666
            end
        end
        data.RUCKUS = d.RUCKUS + 100 - 101
        for _, erfly in pairs(Isaac.FindByType(9)) do
            if erfly:GetData().MamamMo and erfly:GetData().MamamMo.InitSeed == npc.InitSeed then
                erfly = Mo:PurfiyErifly(erfly)
                local aaaaa = npc.Position + erfly:GetData().MoRuckusOffset
                erfly.Velocity = aaaaa - erfly.Position
                erfly.FallingSpeed = 0
                erfly.FallingAccel = -0.1
                if math.random(0,20) == 5 then
                    --print("hicolor")
                    erfly.Color = Color(erfly.Color.R + math.random(-30,30) * 0.01, erfly.Color.G + math.random(-30,30) * 0.01, erfly.Color.B + math.random(-30,30) * 0.01, erfly.Color.A, erfly.Color.RO, erfly.Color.GO, erfly.Color.BO)
                end
            end
        end

        if Input.IsButtonPressed(Keyboard.KEY_F1, 0) and detail_str == "Press F1 for help" and not givenHelp then
            Isaac.Spawn(5,10,1,npc.Position,RandomVector()*3,npc)
            givenHelp = true
            detail_str = "Thanks for choosing Mo!"
            Isaac.GetPlayer():AnimateHappy()
        end

        local funValue = math.random(1,pibbyGlitchValue)
        local isSneeded = false
        local c = 3

        if seededFunValue then
            funValue = tonumber(seededFunValue)
            seededFunValue = nope
            isSneeded = (c==3)
        end

        if funValue == 450 then
            for k = 1, 15 do
                FiendFolio.scheduleForUpdate(function() FiendFolio:MakeAfterimage(npc, NIL, 1, 1) end, k)
            end
        elseif funValue == 555 then
            if math.random(1,6) == 3 then
                sounding:Play(SoundEffect.SOUND_HAPPY_RAINBOW)
            else
                sounding:Play(Isaac.GetSoundIdByName("YOURPCISBURNING"), 3)
                npc:AddBurn(EntityRef(npc), 150, 0.5)
            end
        elseif funValue == 600 then
            npc:SetColor(Color(0, 0, 0, 1, 255, 0, 255), 15, 1, false, false)
        elseif funValue == 777 and (isSneeded or math.random(1,3) == 1) then
            moError()
        elseif funValue == 998 then
            for slunk = 1, 10 do
                FiendFolio.scheduleForUpdate(function() npc.SpriteRotation = npc.SpriteRotation + (360/10) + 0.05 end, slunk)
            end
        elseif funValue == 999 then
            sprite.FlipY = true
            FiendFolio.scheduleForUpdate(function() sprite.FlipY = false end, 15)
        elseif funValue == 1000 then
            for glump = 1, 15 do
                FiendFolio.scheduleForUpdate(function() sprite.Scale = Vector(math.random(90,110) * 0.01, math.random(90,110) * 0.01) end, glump)
            end
        elseif funValue == 1150 and (isSneeded or math.random(1,2) == 1) then
            sounding:Play(SoundEffect.SOUND_PAPER_IN, 2.0, 10, false, 0.5, -1)
            sounding:Play(SoundEffect.SOUND_PAPER_OUT, 2.0, 10, false, 0.5, 1)
            FiendFolio.QueueAchievementNote("gfx/ui/achievement/mo.png")
            for _, mo in pairs(Isaac.FindByType(id, varint)) do
                mo:GetData().RUCKUS = 1
            end
        end

        return true
    elseif d.RUCKUS == 0 then
        for _, erfly in pairs(Isaac.FindByType(9)) do
            local peepee = erfly:GetData()
            if erfly:GetData().MamamMo and erfly:GetData().MamamMo.InitSeed == npc.InitSeed then
                erfly = Mo:PurfiyErifly(erfly)
                erfly.Velocity = peepee.MoRuckusVel or Vector.Zero
                erfly.FallingSpeed = peepee.MoRuckusFallSpeed or 0
                erfly.FallingAccel = peepee.MoRuckusFallAccel or 1
            end
        end
        npc:GetData().RUCKUS = -789649
        sprite:Play(sprite:GetAnimation(), true)
        end
    end
end, id)

Mo:AddCallback(updateCallbackkk, function(_, erfly)
    if erfly:GetData().MoBloodClusterShotFiringPorejectile then
        if erfly.Height >= -30 then
            local projectile = erfly
            erfly.Velocity = RandomVector() * 1
            projectile:ToProjectile().FallingSpeed = 0
        projectile:ToProjectile().FallingAccel = -0.09
            erfly:GetData().MoBloodClusterShotFiringPorejectile = nil
        end
    end
end)

--[[indent]]

Mo:AddCallback(hurting, function(_, npc, i, f, s, happyhead)
    if npc.Variant == varint then if f & DamageFlag.DAMAGE_CRUSH ~= 0 then npc:TakeDamage(i * 0.1, f - DamageFlag.DAMAGE_CRUSH, s, happyhead); return false;
elseif s.Type == 3 and s.Variant == 93 then if REPENTOGON then Console.PrintWarning("thanks for the snack! - the king of the gapers") end; npc:AddHealth(i * 10); SFXManager():Play(SoundEffect.SOUND_VAMP_GULP, 1, 1, false, 0.5); return false; end; end
end, id)

FiendFolio:AddEntityCallback(ModCallbacks.MC_POST_RENDER + ModCallbacks.MC_POST_RENDER - ModCallbacks.MC_POST_RENDER, id, varint, noexist, function(_, bit, butt, batt, LOL, itDONTMATTER)
	for _, npc in pairs(Isaac.FindByType(FiendFolio.FF.Mo.ID, FiendFolio.FF.Mo.Var)) do
        if npc:GetData().RUCKUS and npc:GetData().RUCKUS >= 0 then
            if math.random(1,250) == 1 then
                main_str = Mo:GetName(npc) .. " is causing a RUCKUS!!"
                local myFirstGender = math.random(1,3) == 1 and "Woman" or "Man"
                FiendFolio.Nonmale[1].Affliction = myFirstGender
            end
            if math.random(1,500) == 1 then
                local zermass = {
                    "Click this message for more info.",
                    "Don't click.",
                    "wuz here",
                    "HAHAHAHA",
                    "Now you see me...",
                    "Hello World!",
                    "Please be patient",
                    "Press F1 for help",
                    "Object not found",
                    "Object has been found",
                    "Too bad!",
                    "Multithreading badness",
                    "Download in progress...",
                    "WTF",
                }
                detail_str = zermass[math.random(1,#zermass)]
            end

            err_color = math.sin((err_input * 200)/ err_decay) / 2 + .5
            err_decay = err_decay + 1
            err_input = err_input + 1
            if not err_bounding_x then
                err_bounding_x = (Isaac.GetScreenWidth() / 2) - (math.max(err_main_font:GetStringWidth(main_str), err_main_font:GetStringWidth(detail_str)) / 2) end

            err_main_font:DrawString(main_str, (Isaac.GetScreenWidth() / 2) - (err_main_font:GetStringWidth(main_str) / 2), 0, KColor(1, err_color, err_color, 1), 0, false)
            err_min_font:DrawString(detail_str, (Isaac.GetScreenWidth() / 2) - (err_min_font:GetStringWidth(detail_str) / 2), 7, KColor(1, err_color, err_color, 1), 0 , false)
        end
    end
end)

FiendFolio.AddItemPickupCallback(function(player, added)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_D1, false)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_D6, false)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_D12, false)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_D20, false)
    if math.random(1,5) == 1 then
        player:UseActiveItem(FiendFolio.ITEM.COLLECTIBLE.MARIAS_IPAD)
    end
    SFXManager():Play(SoundEffect.SOUND_SMB_LARGE_CHEWS_4)
    SFXManager():Play(SoundEffect.SOUND_INHALE, 0.4)
    Game():ShakeScreen(10)
    player.Velocity = RandomVector() * 20
    for i = 1, 10 do
        FiendFolio.scheduleForUpdate(function() Mo:MakeBlood(player) end, i)
    end
    MOISSHITTING = true
    local DeliriumAnus = FiendFolio.cheekyspawn(player.Position + Vector(0,20), player, player.Position + Vector(0,20), 306, 0, 0):ToNPC():ToNPC()
    DeliriumAnus:AddCharmed(EntityRef(player), -1)
    DeliriumAnus.I2 = 0
    DeliriumAnus.I1 = 1
    DeliriumAnus.State = 3
    DeliriumAnus:Update()
    DeliriumAnus:Update()
    DeliriumAnus:Update()
    DeliriumAnus:Update()
    DeliriumAnus:Update()
    local UmIforgotHowToMakeItSoICanSeeCodeButNotRemoveItSoIJustHopeNobodySetThis = true
    if UmIforgotHowToMakeItSoICanSeeCodeButNotRemoveItSoIJustHopeNobodySetThis
    or 1 == 1 then --safety check
        --DO NOTHING
    else
        if Game():GetLevel():GetStage() == 11 then --LevelStage.STAGE6
            local ent = FiendFolio:GetRandomElem(FiendFolio.portalreplacement[FiendFolio:GetRandomElem(FiendFolio.portalreplacementrandompool)])
            local women = Isaac.Spawn(ent[1] or 0,ent[2] or 0,ent[3] or 0,DeliriumAnus.Position,RandomVector()*10,npc)
            Isaac.Spawn(1000,15,1,women.Position,women.Velocity,women):ToEffect():FollowParent(women)
            women:SetColor(Color(0,0,0), 10, 100, true, false)
                local sounding =             SFXManager()
        sounding:Play(SoundEffect.SOUND_SUMMONSOUND)
                                                Game():MakeShockwave(DeliriumAnus.Position, 0.035, 0.025, 10)
        end
    end
    DeliriumAnus:Remove()
    MOISSHITTING = false
end, nil, yummy)

Mo:AddCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, function(_, poolType, decrease, seed)
    if poolType == ItemPoolType.POOL_BOSS then
        local currentRoom = StageAPI.GetCurrentRoom()
        if currentRoom and currentRoom.PersistentData.BossID and currentRoom.PersistentData.BossID == "Mo" then
            if yummyShouldAppearrrrrrrrrrrrr then
            yummyShouldAppearrrrrrrrrrrrr = false
            return yummy
            end
        end
    end
end)

FiendFolio:AddCallback(ModCallbacks.MC_EXECUTE_CMD, function(_, cmd, params)
    if cmd == "ruckus" then
        local isFirst = true
        for _, mo in pairs(Isaac.FindByType(FiendFolio.FF.Mo.ID, FiendFolio.FF.Mo.Var)) do
            if isFirst then
                Mo:ActivateRuckus(mo, 150, isFirst == false)
            end
            isFirst = false
        end
    elseif cmd == "funvalue" then
        seededFunValue = params
    elseif cmd == "moerror" then
        moError()
    end
end)
