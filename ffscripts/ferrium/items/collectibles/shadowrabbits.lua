local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local bal = {
    BaseRooms = 3, --How many extra rooms you get
    BaseTimer = 1600,
    TimerMinimum = 400, --Sets to this timer on room entrance if below it
    TimerWarning = 80,

    UseBigs = 4,
    UseSmalls = 2,
    UseSpecials = 2,
    UseSpecialChance = 25,

    SmallRabbitChance = 33,
    Speed = 5,
    FireRate = 13,
    SRClose = 150,
    SRAlignRange = 20,
    SRShootDist = 70,
    SRShotSpeed = 10,
    SRDamageFlat = 1.25,
    SRDamageMult = 0.4,
    SRLoseInterest = 100,
    SRTearHeight = -23,
    
    BigDamage = 1.6,
    BigDamageMult = 0.66,
    BigTearHeight = -23,
    BigEnochlophobia = 55,
    SkittishTimer = 100,
    EyeOffset = 5,

    ControllerGainDist = 40,
    ControllerLoseDist = 80,
}

--Welp no more curse mist turns out it sucks

local numToDir = {
    [0] = "Down", [1] = "Right", [2] = "Up", [3] = "Left"
}

local isGridCollFine = {
    [EntityGridCollisionClass.GRIDCOLL_GROUND] = GridCollisionClass.COLLISION_PIT,
    [EntityGridCollisionClass.GRIDCOLL_NOPITS] = GridCollisionClass.COLLISION_OBJECT,
    [EntityGridCollisionClass.GRIDCOLL_WALLS] = GridCollisionClass.COLLISION_WALL,
}

--Stat changes are added to the existing numbers, not replacing them
mod.ShadowRabbitSpecials = {
    [CollectibleType.COLLECTIBLE_SPOON_BENDER] = {Weight = 100, TearFlags = TearFlags.TEAR_HOMING, FireFunc = function(_, _, tear)
        local tearcolor = Color(0.4, 0.15, 0.38, 0.5, 55/255, 5/255, 95/255)
        tear.Color = tearcolor
    end, Costume = {Head = "Spoon Bender"}, SpoonBender = true}, --Why doesn't the fire work normally????
    [CollectibleType.COLLECTIBLE_NUMBER_ONE] = {Weight = 70, TearHeight = 16, FireRate = -6, NoEyeOffset = true, FallingSpeed = -4, FallingAccel = 0.4},
    [CollectibleType.COLLECTIBLE_BROTHER_BOBBY] = {Weight = 100, InitFunc = function(rabbit, d)
        local friend = Isaac.Spawn(3, mod.ITEM.FAMILIAR.SHADOW_RABBIT_SMALL, 0, rabbit.Position, Vector.Zero, rabbit):ToFamiliar()
        friend.Player = rabbit.Player
        mod:GetEntityData(friend).BrotherBobbyRabbit = rabbit
        friend:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        d.MyFamiliar = friend
    end, FireFunc = function(rabbit, d, tear, direction)
        if d.MyFamiliar and d.MyFamiliar:Exists() then
            local fam = d.MyFamiliar
            local fd = mod:GetEntityData(fam)
            fd.Shooting = direction
            fd.OverwriteTearVelocity = tear.Velocity
            fd.ForceFire = true
            fd.StateFrame = 0
        end
    end},
    [CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM] = {Weight = 70, Scale = 0.3, FireRate = -2, DamageMult = 0.5, Damage = 0.3, Speed = 1, ShotSpeed = 1.5},
    [CollectibleType.COLLECTIBLE_WIRE_COAT_HANGER] = {Weight = 100, FireRate = -4},
    [CollectibleType.COLLECTIBLE_CUPIDS_ARROW] = {Weight = 100, TearFlags = TearFlags.TEAR_PIERCING, Costume = {Head = "Cupid's Arrow"}},
    [CollectibleType.COLLECTIBLE_PENTAGRAM] = {Weight = 100, Damage = 2.5},
    [CollectibleType.COLLECTIBLE_MUTANT_SPIDER] = {Weight = 50, FireRate = 10, NoEyeOffset = true, FireFunc = function(rabbit, d, tear, direction)
        local first
        local origVel = tear.Velocity
        local low = 2
        for i=-1,1,2 do
            for j=low,7,4 do
                if not first then
                    first = true
                    tear.Velocity = origVel:Rotated(i*j)
                    tear.Position = rabbit.Position+tear.Velocity:Resized(8)
                    tear:Update()
                else
                    local newTear = Isaac.Spawn(tear.Type, tear.Variant, tear.SubType, rabbit.Position, origVel:Rotated(i*j), rabbit):ToTear()
                    if j==low then
                        newTear.Position = newTear.Position+newTear.Velocity:Resized(8)
                    end
                    newTear.Height = tear.Height
                    newTear.Scale = tear.Scale
                    newTear.CollisionDamage = tear.CollisionDamage
                    newTear.Color = tear.Color
                    newTear.TearFlags = tear.TearFlags
                    newTear:Update()
                end
            end
        end
    end, Costume = {Head = "Mutant Spider"}},
    [CollectibleType.COLLECTIBLE_SPIRIT_OF_THE_NIGHT] = {Weight = 100, Flying = true, Costume = {Body = "Spirit of the Night"}},
    [CollectibleType.COLLECTIBLE_POLYPHEMUS] = {Weight = 50, TearFlags = TearFlags.TEAR_PERSISTENT, Damage = 12, FireRate = 10,
        NoEyeOffset = true, Costume = {Head = "Polyphemus"}},
    [CollectibleType.COLLECTIBLE_TINY_PLANET] = {Weight = 50, Special = "Tiny Planet", Costume = {Head = "Tiny Planet"}, FireFunc = function(rabbit, d, tear, dir, eye)
        local td = mod:GetEntityData(tear)
        tear.Parent = rabbit
		td.tinyDirection = eye
		td.originalVec = Vector(tear.Velocity.X, tear.Velocity.Y)
        tear.Velocity = Vector.Zero

        local tab = {update = function(v, tab1, d1)
            d1.tinyDist = math.min(120, (d1.tinyDist or 0)+1.6)
            if v.Parent and mod:superExists(v.Parent) and not d1.dwellerGone then
                if v.FrameCount < 350 then
                    d1.shiftingAngle = (d1.shiftingAngle or 0)+(3*d1.tinyDirection)
                    local targPos = v.Parent.Position+d1.originalVec:Resized(d1.tinyDist):Rotated(d1.shiftingAngle)
                    v.Velocity = (targPos-v.Position)

                    v.FallingSpeed = 0
                    v.FallingAcceleration = -0.05
                else
                    d1.dwellerGone = true
                    v.FallingSpeed = -5
                    v.FallingAcceleration = 1.1
                end
            else
                if not d1.dwellerGone then
                    d1.dwellerGone = true
                    v.FallingSpeed = -5
                    v.FallingAcceleration = 1.1
                end
                v.Velocity = mod:Lerp(v.Velocity, Vector.Zero, 0.2)
            end
        end}

        mod:TryToAddTearBehavior(tear, td, tab)
        tear:Update()
    end},
    [CollectibleType.COLLECTIBLE_EXPERIMENTAL_TREATMENT] = {Weight = 70, InitFunc = function(rabbit, d)
        local rng = rabbit:GetDropRNG()
        d.DamageMult = d.DamageMult+mod:RandomInt(-10,20,rng)/100
        d.FireRate = d.FireRate+mod:RandomInt(-5,8,rng)
        d.Speed = d.Speed+mod:RandomInt(-6,15,rng)/10
    end},
    [CollectibleType.COLLECTIBLE_AQUARIUS] = {Weight = 100, ExtraFunc = function(rabbit, d)
        if rabbit.FrameCount % 3 == 0 then
            local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, rabbit.Position, Vector.Zero, rabbit):ToEffect()
            creep:SetTimeout(100)
            local mult = rabbit:GetMultiplier()
            if d.Controller and d.Controller:Exists() then
                local balancedMult = 1-bal.BigDamageMult
                creep.CollisionDamage = (d.Damage+d.Controller.Damage*(d.DamageMult+balancedMult))*mult*0.66
            else
                creep.CollisionDamage = (d.Damage+rabbit.Player.Damage*d.DamageMult)*mult*0.66
            end
            creep.SpriteScale = Vector(0.9, 0.9)
            creep:Update()
        end
    end},
    [CollectibleType.COLLECTIBLE_SOY_MILK] = {Weight = 50, FireRate = -10, DamageMult = -0.8, Special="Soy Milk"},
    --[CollectibleType.COLLECTIBLE_VENUS] = {Weight = 70, Special = "Venus"},
    [CollectibleType.COLLECTIBLE_TOOTH_AND_NAIL] = {Weight = 100, ExtraFunc = function(rabbit, d)
        if not d.ToothAndNailed then
            d.ToothAndNailTimer = (d.ToothAndNailTimer or 0)+1

            if d.ToothAndNailTimer >= 84 then
                d.ToothAndNailed = true

                rabbit:GetSprite():ReplaceSpritesheet(1, "gfx/familiar/shadowrabbits/Tooth and Nail.png", true)

                rabbit:SetColor(Color(1, 1, 1, 1, 0.4, 0.4, 0.4), 4, 1, true, false)
                sfx:Play(SoundEffect.SOUND_TOOTH_AND_NAIL, 0.35, 0, false, 1.2)
            elseif d.ToothAndNailTimer > 47 and d.ToothAndNailTimer % 12 == 0 then
                rabbit:SetColor(Color(1, 1, 1, 1, 0.4, 0.4, 0.4), 4, 1, true, false)
                sfx:Play(SoundEffect.SOUND_TOOTH_AND_NAIL_TICK, 0.35, 0, false, 1.2)
            end
        elseif rabbit.FrameCount % 5 == 0 then
            for _,ent in ipairs(Isaac.FindInRadius(rabbit.Position, 50, EntityPartition.ENEMY)) do
                if ent:IsActiveEnemy() and (not mod:isFriend(ent))and ent:IsVulnerableEnemy() then
                    if ent.Position:DistanceSquared(rabbit.Position) <= (ent.Size + rabbit.Size) ^ 2 then
                        ent:TakeDamage(rabbit.Player.Damage+5, 0, EntityRef(rabbit), 0)
                    end
                end
            end
        end
    end},
    --[[[mod.ITEM.COLLECTIBLE.TIME_ITSELF] = {Weight = 60, ExtraFunc = function(rabbit, d)
        local s = math.sin(game:GetFrameCount()/20*math.pi)
        local multiEuclidColor = Color(-s*2, -s*2, -s*2, 1, (s+1)/2, (s+1)/2, (s+1)/2)
        multiEuclidColor:SetColorize(1, 1, 1, 1)
        rabbit.Color = multiEuclidColor


        for _,tear in ipairs(Isaac.FindInRadius(rabbit.Position, 30, EntityPartition.TEAR)) do
            local tdata = mod:GetEntityData(tear)
            if tear.Position:DistanceSquared(rabbit.Position) <= (tear.Size + rabbit.Size) ^ 2 and not tdata.AlreadyDuplicatedByMultiEuclidean then
                for i = -90, 90, 180 do
                    local offsetVec = tear.Velocity:Resized(tear.Size):Rotated(i)
                    if i == -90 then
                        local newtear = Isaac.Spawn(tear.Type, tear.Variant, tear.SubType, tear.Position + offsetVec, tear.Velocity, rabbit):ToTear()
                        newtear.TearFlags = tear.TearFlags
                        mod:GetEntityData(newtear).FFMultiEuclideanTearSpawner = rabbit
                        mod:GetEntityData(newtear).FFMultiEuclideanTearSetColor = true
                        mod:GetEntityData(newtear).AlreadyDuplicatedByMultiEuclidean = true
                    else
                        tear.Position = tear.Position+offsetVec
                        mod:GetEntityData(tear).FFMultiEuclideanTearSpawner = rabbit
                        mod:GetEntityData(tear).FFMultiEuclideanTearSetColor = true
                        mod:GetEntityData(tear).AlreadyDuplicatedByMultiEuclidean = true
                    end
                end
            end
        end
        
    end, FireFunc = function(rabbit, d, tear)
        mod:GetEntityData(tear).AlreadyDuplicatedByMultiEuclidean = true
        mod:changeTearVariant(tear, mod.TEAR.MULTI_EUCLIDEAN)
    end},]]
    [mod.ITEM.COLLECTIBLE.RUBBER_BULLETS] = {Weight = 100, FireFunc = function(rabbit, d, tear)
        local rng = rabbit:GetDropRNG()
        if rng:RandomInt(100) <= 50 then
            FiendFolio.FlagBruise(tear, mod.RubberBulletsBal.BaseDuration, 1, 1)
            mod:changeTearVariant(tear, mod.TEAR.M90_BULLET)
            tear.Velocity = tear.Velocity*1.5
            sfx:Play(mod.Sounds.ShotgunBlast,0.4,0,false,mod:RandomInt(60,80,rng)/100)
        end
    end},
}

local function BackupSpawnFunc(entry, room)
    if entry.Type == "Shadow Rabbits Large" then
        for key2,entry2 in ipairs(entry.Squadron) do
            local player = entry2.Player
            local pd = mod:GetEntityData(player)
            if player:Exists() and pd.ffsavedata.ShadowRabbiting and not pd.ffsavedata.ShadowRabbiting.ExitPoint then
                mod.scheduleForUpdate(function()
                    if player:Exists() and pd.ffsavedata.ShadowRabbiting and not pd.ffsavedata.ShadowRabbiting.ExitPoint then
                        local testPath = Isaac.Spawn(mod.FF.ChummerPathfinder.ID, mod.FF.ChummerPathfinder.Var, 0, player.Position, Vector.Zero, nil):ToNPC()
						testPath.Visible = false
						testPath:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
						testPath:AddEntityFlags(EntityFlag.FLAG_NO_REWARD)
						testPath.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                        local pos = mod:FindRandomValidPathPosition(testPath)
                        testPath:Remove()
                        local rabbit = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.SHADOW_RABBIT_LARGE,
                        0, pos, Vector.Zero, player):ToFamiliar()
                        rabbit.Player = player
                        mod:GetEntityData(rabbit).DoorAppearing = true
                        mod:GetEntityData(rabbit).RabbitSpecial = entry2.Special
                        rabbit:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                        rabbit:Update()
                        local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 1, pos, Vector.Zero, player):ToEffect()
                        poof.Color = Color(0.12, 0.12, 0.12, 1, 0, 0, 0)
                        poof.DepthOffset = 20
                        poof:Update()
                        local poof2 = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 2, pos, Vector.Zero, player):ToEffect()
                        poof2.Color = Color(0.12, 0.12, 0.12, 1, 0, 0, 0)
                        poof2.DepthOffset = 20
                        poof2.SpriteScale = Vector(1.5, 1.5)
                        poof2:Update()
                        sfx:Play(SoundEffect.SOUND_BLACK_POOF, 1, 0, false, 1)
                    end
                end, key2*20)
            end
        end
    elseif entry.Type == "Shadow Rabbits Small" then
        for key2,player in ipairs(entry.Smalls) do
            local pd = mod:GetEntityData(player)
            if player:Exists() and pd.ffsavedata.ShadowRabbiting and not pd.ffsavedata.ShadowRabbiting.ExitPoint then
                mod.scheduleForUpdate(function()
                    if player:Exists() and pd.ffsavedata.ShadowRabbiting and not pd.ffsavedata.ShadowRabbiting.ExitPoint then
                        local testPath = Isaac.Spawn(mod.FF.ChummerPathfinder.ID, mod.FF.ChummerPathfinder.Var, 0, player.Position, Vector.Zero, nil):ToNPC()
						testPath.Visible = false
						testPath:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
						testPath:AddEntityFlags(EntityFlag.FLAG_NO_REWARD)
						testPath.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                        local pos = mod:FindRandomValidPathPosition(testPath)
                        testPath:Remove()
                        local rabbit = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.SHADOW_RABBIT_SMALL,
                        0, pos, Vector.Zero, player):ToFamiliar()
                        rabbit.Player = player
                        mod:GetEntityData(rabbit).DoorAppearing = true
                        rabbit:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                        rabbit:Update()
                        local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 1, pos, Vector.Zero, player):ToEffect()
                        poof.Color = Color(0.12, 0.12, 0.12, 1, 0, 0, 0)
                        poof.DepthOffset = 20
                        poof:Update()
                        local poof2 = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 2, pos, Vector.Zero, player):ToEffect()
                        poof2.Color = Color(0.12, 0.12, 0.12, 1, 0, 0, 0)
                        poof2.DepthOffset = 20
                        poof2.SpriteScale = Vector(1.5, 1.5)
                        poof2:Update()
                        sfx:Play(SoundEffect.SOUND_BLACK_POOF, 1, 0, false, 1)
                    end
                end, key2*20)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, item, rng, player, useflags)
    local d = mod:GetEntityData(player).ffsavedata
	if d.ShadowRabbiting and 1 == 0 then
    else
        player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        player.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE

        local firstTime
        if not d.ShadowRabbiting then
            firstTime = true
        end
        
        if d.ShadowRabbiting then
            d.ShadowRabbiting.Rooms = d.ShadowRabbiting.Rooms+bal.BaseRooms
            d.ShadowRabbiting.Timer = bal.BaseTimer
            d.ShadowRabbiting.BigNum = bal.UseBigs+d.ShadowRabbiting.BigNum
            d.ShadowRabbiting.SmallNum = bal.UseSmalls+d.ShadowRabbiting.SmallNum
        else
            d.ShadowRabbiting = {Rooms = bal.BaseRooms, Timer = bal.BaseTimer, BigNum = bal.UseBigs, SmallNum = bal.UseSmalls, BigSpecials = 0}
        end
        if firstTime then
            d.ShadowRabbiting.CouldShoot = player:CanShoot()
        end
        player:SetCanShoot(false)

        --[[local level = game:GetLevel()
        local desc = level:GetRoomByIdx(level:GetCurrentRoomIndex())
        d.ShadowRabbitsRoomData = d.ShadowRabbitsRoomData or {}
        d.ShadowRabbitsRoomData[desc.SafeGridIndex] = d.ShadowRabbitsRoomData[desc.SafeGridIndex] or {Shadowed = true, OriginalFlags = desc.Flags}
		desc.Flags = desc.Flags | RoomDescriptor.FLAG_CURSED_MIST
        d.ShadowRabbiting.Host = true]]

        if mod.RabbitsToEnter then
            if not mod.RabbitsToEnter.Doors then
                mod:RabbitNewRoom(game:GetRoom())
            end
            mod.RabbitsToEnter.Delay = 0

            mod.RabbitsToEnter.Queue = mod.RabbitsToEnter.Queue or {}
            local foundKey
            for key,entry in ipairs(mod.RabbitsToEnter.Queue) do
                if entry.Type == "Shadow Rabbits Large" then
                    foundKey = key
                    break
                end
            end
            if not foundKey then
                table.insert(mod.RabbitsToEnter.Queue, {Type = "Shadow Rabbits Large", Priority = 15, InClearRooms = true, BackupSpawn = BackupSpawnFunc})
                foundKey = #mod.RabbitsToEnter.Queue
            end

            local tab = mod.RabbitsToEnter.Queue[foundKey]
            tab.Squadron = tab.Squadron or {}
            for i=1,bal.UseBigs do
                if i <= bal.UseSpecials or rng:RandomInt(100) < bal.UseSpecialChance then
                    d.ShadowRabbiting.BigSpecials = d.ShadowRabbiting.BigSpecials+1
                    local _,key,roll = mod:weightedRNG(mod.ShadowRabbitSpecials, rng)
                    table.insert(tab.Squadron, {Player = player, Special = roll})
                else
                    table.insert(tab.Squadron, {Player = player})
                end
            end

            foundKey = nil
            for key,entry in ipairs(mod.RabbitsToEnter.Queue) do
                if entry.Type == "Shadow Rabbits Small" then
                    foundKey = key
                    break
                end
            end
            if not foundKey then
                table.insert(mod.RabbitsToEnter.Queue, {Type = "Shadow Rabbits Small", Priority = 14, InClearRooms = true, BackupSpawn = BackupSpawnFunc})
                foundKey = #mod.RabbitsToEnter.Queue
            end

            tab = mod.RabbitsToEnter.Queue[foundKey]
            tab.Smalls = tab.Smalls or {}
            for i=1,bal.UseSmalls do
                table.insert(tab.Smalls, player)
            end
            --table.insert(tab.Squadron, {Player = player, Special = mod.ShadowRabbitSpecials[mod.ShadowRabbitItem]})
        end
    end
	return true
end, FiendFolio.ITEM.COLLECTIBLE.SHADOW_RABBITS)
--mod.ShadowRabbitItem = CollectibleType.COLLECTIBLE_SPOON_BENDER

function mod:ShadowRabbitPEffectUpdate(player)
    local pd = mod:GetEntityData(player)
    local d = pd.ffsavedata
    if d.ShadowRabbiting and d.ShadowRabbiting.ExitPoint then
        d.ShadowRabbiting.Leaving = (d.ShadowRabbiting.Leaving or 0)+1
        local STOP
        if player.Position:Distance(d.ShadowRabbiting.ExitPoint) < 30 then
            player.Velocity = (d.ShadowRabbiting.ExitPoint-player.Position)
        else
            STOP = true
        end
        
        if STOP or d.ShadowRabbiting.Leaving > 30 then
            d.ShadowRabbiting = nil
            pd.ControllingSRabbit = nil
        end
    elseif d.ShadowRabbiting then
        local tab = d.ShadowRabbiting
        if tab.Timer > 0 then
            if mod:IsActiveRoom() then
                tab.Timer = tab.Timer-1
                
                if tab.Timer <= bal.TimerWarning and tab.Timer % 24 == 0 and tab.Timer > 0 then
                    local inc = (bal.TimerWarning-tab.Timer)/bal.TimerWarning
                    sfx:Play(898, 0.8, 0, false, 0.8+inc*0.9) --Oh I guess this enum isn't here yet, but this is portable slot
                end
            else
                tab.Timer = tab.Timer-2
                
                if tab.Timer <= bal.TimerWarning*2 and (tab.Timer % 48 == 1 or tab.Timer % 48 == 0) and tab.Timer > 0 then
                    local inc = (bal.TimerWarning*2-tab.Timer)/(bal.TimerWarning*2)
                    sfx:Play(898, 0.8, 0, false, 0.8+inc*0.9)
                end
            end

            player:SetColor(Color(player.Color.R, player.Color.G, player.Color.B, 0.1), 2, 1, false, true)
            player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            player.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
            if player:CanShoot() then
                player:SetCanShoot(false)
            end
        else
            local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.SHADOW_RABBITS)
            local room = game:GetRoom()
            local doors = mod.availableDoors[room:GetRoomShape()]
            local closestDoor
            local dist = 99999
            for _,checkDoor in ipairs(doors) do
                local checkedDoor = room:GetDoor(checkDoor)
                if checkedDoor ~= nil and checkedDoor:GetSprite():GetAnimation() ~= "Hidden" then
                    if checkedDoor.Position:Distance(player.Position) < dist then
                        closestDoor = checkedDoor
                        dist = checkedDoor.Position:Distance(player.Position)
                    end
                end
            end

            for _,babbit in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.SHADOW_RABBIT_LARGE, -1, false, false)) do
                local rabbit = babbit:ToFamiliar()
                local rd = mod:GetEntityData(rabbit)
                if rabbit.Player and player.InitSeed == rabbit.Player.InitSeed and not rd.RemoveChecked then
                    rd.RemoveChecked = true

                    mod.scheduleForUpdate(function()
                        rd.FadedIn = 15
                        rd.State = "YouNeedToLeave"
                        for i=1,3 do
                            local randVel = RandomVector()*mod:RandomInt(10,30,rng)/20
                            local cloud = Isaac.Spawn(1000, 59, 0, rabbit.Position, Vector.Zero, rabbit):ToEffect()
                            cloud:SetTimeout(mod:RandomInt(60,120,rng))
                            local color = Color(0.05,0,0,0,0,0,0)
                            cloud.Color = color
                            local randScale = mod:RandomInt(35,70,rng)/100
                            cloud.SpriteScale = Vector(0.5, 0.5)
                            mod:GetEntityData(cloud).cosmeticDust = {scale = randScale, vel = randVel}
                            cloud.SpriteOffset = Vector(0, -15)
                        end
                    end, rng:RandomInt(8))
                end
            end
            for _,babbit in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.SHADOW_RABBIT_SMALL, -1, false, false)) do
                local rabbit = babbit:ToFamiliar()
                local rd = mod:GetEntityData(rabbit)
                if rabbit.Player and player.InitSeed == rabbit.Player.InitSeed and not rd.RemoveChecked then
                    rd.RemoveChecked = true

                    mod.scheduleForUpdate(function()
                        rd.FadedIn = 15
                        rd.State = "YouNeedToLeave"
                        for i=1,2 do
                            local randVel = RandomVector()*mod:RandomInt(10,30,rng)/20
                            local cloud = Isaac.Spawn(1000, 59, 0, rabbit.Position, Vector.Zero, rabbit):ToEffect()
                            cloud:SetTimeout(mod:RandomInt(60,120,rng))
                            local color = Color(0.05,0,0,0,0,0,0)
                            cloud.Color = color
                            local randScale = mod:RandomInt(35,70,rng)/100
                            cloud.SpriteScale = Vector(0.5, 0.5)
                            mod:GetEntityData(cloud).cosmeticDust = {scale = randScale, vel = randVel}
                            cloud.SpriteOffset = Vector(0, -15)
                        end
                    end, rng:RandomInt(8))
                end
            end

            if mod.RabbitsToEnter and mod.RabbitsToEnter.Queue then
                for key,entry in pairs(mod.RabbitsToEnter.Queue) do
                    if entry.Type == "Shadow Rabbits Large" then
                        for key2,entry2 in ipairs(entry.Squadron) do
                            if entry2.Player.InitSeed == player.InitSeed then
                                table.remove(entry.Squadron, key2)
                            end
                        end
                        if #entry.Squadron == 0 then
                            table.remove(mod.RabbitsToEnter.Queue, key)
                        end
                    elseif entry.Type == "Shadow Rabbits Small" then
                        for key2,player2 in ipairs(entry.Smalls) do
                            if player2.InitSeed == player.InitSeed then
                                table.remove(entry.Smalls, key2)
                            end
                        end
                        if #entry.Smalls == 0 then
                            table.remove(mod.RabbitsToEnter.Queue, key)
                        end
                    end
                end
            end         

            for i=1,3 do
                local randVel = RandomVector()*mod:RandomInt(10,30,rng)/20
                local cloud = Isaac.Spawn(1000, 59, 0, player.Position, Vector.Zero, player):ToEffect()
                cloud:SetTimeout(mod:RandomInt(60,120,rng))
                local color = Color(0.05,0,0,0,0,0,0)
                cloud.Color = color
                local randScale = mod:RandomInt(35,70,rng)/100
                cloud.SpriteScale = Vector(0.5, 0.5)
                mod:GetEntityData(cloud).cosmeticDust = {scale = randScale, vel = randVel}
                cloud.SpriteOffset = Vector(0, -15)
            end

            local telepos
            if closestDoor then
                telepos = room:FindFreeTilePosition(closestDoor.Position, 0)
                if room:GetGridCollisionAtPos(telepos+(telepos-closestDoor.Position):Resized(40)) == GridCollisionClass.COLLISION_NONE then
                    telepos = room:GetGridPosition(room:GetGridIndex(telepos+(telepos-closestDoor.Position)))
                end
            else
                local threshold = (player.CanFly and GridCollisionClass.COLLISION_SOLID) or GridCollisionClass.COLLISION_NONE
                if room:GetGridCollisionAtPos(player.Position) <= threshold then
                    telepos = player.Position
                else
                    telepos = room:FindFreeTilePosition(player.Position, 0)
                end
            end
            player.Position = telepos
            d.ShadowRabbiting.ExitPoint = telepos

            d.ShadowRabbitFade = 20
            player:SetColor(Color(0, 0, 0, 0), 20, 1, true, true)
            pd.ClownMeatSafety = (pd.ClownMeatSafety or 0)+80

            if player.CanFly then
                player.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            else
                player.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            end
            player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            if d.ShadowRabbiting.CouldShoot == true or d.ShadowRabbiting.CouldShoot == nil then
                player:SetCanShoot(true)
            end

            for i=1,6 do
                local randVel = RandomVector()*mod:RandomInt(10,30,rng)/20
                local cloud = Isaac.Spawn(1000, 59, 0, telepos, Vector.Zero, player):ToEffect()
                cloud:SetTimeout(mod:RandomInt(60,120,rng))
                local color = Color(0.05,0,0,0,0,0,0)
                cloud.Color = color
                local randScale = mod:RandomInt(35,70,rng)/100
                cloud.SpriteScale = Vector(0.5, 0.5)
                mod:GetEntityData(cloud).cosmeticDust = {scale = randScale, vel = randVel}
            end
            local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 1, telepos, Vector.Zero, player):ToEffect()
            poof.Color = Color(0.12, 0.12, 0.12, 1, 0, 0, 0)
            poof.DepthOffset = 20
            poof:Update()
            local poof2 = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 2, telepos, Vector.Zero, player):ToEffect()
            poof2.Color = Color(0.12, 0.12, 0.12, 1, 0, 0, 0)
            poof2.DepthOffset = 20
            poof2.SpriteScale = Vector(1.5, 1.5)
            poof2:Update()
            sfx:Play(SoundEffect.SOUND_BLACK_POOF, 1, 0, false, 1)
        end
    end
end

function mod:ShadowRabbitsNewRoom(player, pd)
    local d = pd.ffsavedata
    if d.ShadowRabbiting then
        pd.ControllingSRabbit = nil
        if d.ShadowRabbiting.Rooms > 0 then
            if mod:IsActiveRoom() then
                d.ShadowRabbiting.Rooms = d.ShadowRabbiting.Rooms-1
                d.ShadowRabbiting.Timer = math.max(bal.TimerMinimum, d.ShadowRabbiting.Timer)
            end
            --[[if d.ShadowRabbitsRoomData then
                local level = game:GetLevel()
                local desc = level:GetRoomByIdx(level:GetCurrentRoomIndex())
                d.ShadowRabbitsRoomData[desc.SafeGridIndex] = d.ShadowRabbitsRoomData[desc.SafeGridIndex] or {Shadowed = true, OriginalFlags = desc.Flags}
                desc.Flags = desc.Flags | RoomDescriptor.FLAG_CURSED_MIST
            end]]
            --d.ShadowRabbiting = {Rooms = bal.BaseRooms, Timer = bal.BaseTimer, BigNum = bal.UseBigs, SmallNum = bal.UseSmalls, BigSpecials = 0}
            
            local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.SHADOW_RABBITS)
            if not mod.RabbitsToEnter.Doors then
                mod:RabbitNewRoom(game:GetRoom())
            end
            mod.RabbitsToEnter.Delay = 0

            mod.RabbitsToEnter.Queue = mod.RabbitsToEnter.Queue or {}
            local foundKey
            for key,entry in ipairs(mod.RabbitsToEnter.Queue) do
                if entry.Type == "Shadow Rabbits Large" then
                    foundKey = key
                    break
                end
            end
            if not foundKey then
                table.insert(mod.RabbitsToEnter.Queue, {Type = "Shadow Rabbits Large", Priority = 15, InClearRooms = true, BackupSpawn = BackupSpawnFunc})
                foundKey = #mod.RabbitsToEnter.Queue
            end

            local tab = mod.RabbitsToEnter.Queue[foundKey]
            tab.Squadron = tab.Squadron or {}
            for i=1,d.ShadowRabbiting.BigNum do
                if i <= d.ShadowRabbiting.BigSpecials then
                    d.ShadowRabbiting.BigSpecials = d.ShadowRabbiting.BigSpecials+1
                    local _,key,roll = mod:weightedRNG(mod.ShadowRabbitSpecials, rng)
                    table.insert(tab.Squadron, {Player = player, Special = roll})
                else
                    table.insert(tab.Squadron, {Player = player})
                end
            end

            foundKey = nil
            for key,entry in ipairs(mod.RabbitsToEnter.Queue) do
                if entry.Type == "Shadow Rabbits Small" then
                    foundKey = key
                    break
                end
            end
            if not foundKey then
                table.insert(mod.RabbitsToEnter.Queue, {Type = "Shadow Rabbits Small", Priority = 14, InClearRooms = true, BackupSpawn = BackupSpawnFunc})
                foundKey = #mod.RabbitsToEnter.Queue
            end

            tab = mod.RabbitsToEnter.Queue[foundKey]
            tab.Smalls = tab.Smalls or {}
            for i=1,d.ShadowRabbiting.SmallNum do
                table.insert(tab.Smalls, player)
            end
        else
            if player.CanFly then
                player.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            else
                player.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            end
            player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            if d.ShadowRabbiting.CouldShoot == true or d.ShadowRabbiting.CouldShoot == nil then
                player:SetCanShoot(true)
            end
            d.ShadowRabbiting = nil
            pd.ControllingSRabbit = nil
        end
    end

    if player:HasCollectible(mod.ITEM.COLLECTIBLE.SHADOW_RABBITS) and mod:IsActiveRoom() then
        local carBattery = (player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) and 2) or 1
        local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.SHADOW_RABBITS)
        for i=1,carBattery do
            if rng:RandomInt(100) < bal.SmallRabbitChance then
                if mod.RabbitsToEnter then
                    local foundKey = nil
                    for key,entry in ipairs(mod.RabbitsToEnter.Queue) do
                        if entry.Type == "Shadow Rabbits Small" then
                            foundKey = key
                            break
                        end
                    end
                    if not foundKey then
                        table.insert(mod.RabbitsToEnter.Queue, {Type = "Shadow Rabbits Small", Priority = 14, InClearRooms = true, BackupSpawn = BackupSpawnFunc})
                        foundKey = #mod.RabbitsToEnter.Queue
                    end

                    local tab = mod.RabbitsToEnter.Queue[foundKey]
                    tab.Smalls = tab.Smalls or {}
                    table.insert(tab.Smalls, player)
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_ROOM_EXIT, function(_, player)
    --[[local d = mod:GetEntityData(player).ffsavedata
    if d.ShadowRabbitsRoomData then
        local level = game:GetLevel()
        local desc = level:GetRoomByIdx(level:GetCurrentRoomIndex())
        if d.ShadowRabbitsRoomData[desc.SafeGridIndex] then
            desc.Flags = desc.Flags ~ RoomDescriptor.FLAG_CURSED_MIST
            d.ShadowRabbitsRoomData[desc.SafeGridIndex] = nil
        end
    end]]
    for _,fam in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.SHADOW_RABBIT_SMALL, -1, false, false)) do
        if not mod:GetEntityData(fam).DONTREMOVE then
            fam:Remove()
        end
    end
    for _,fam in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.SHADOW_RABBIT_LARGE, -1, false, false)) do
        if not mod:GetEntityData(fam).DONTREMOVE then
            fam:Remove()
        end
    end
end)
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.SHADOW_RABBITS, mod.ShadowRabbitPEffectUpdate)

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.EARLY, function(_, ent, damage, flag, source)
    local player = ent:ToPlayer()
    local d = mod:GetEntityData(player).ffsavedata
    if d.ShadowRabbiting and not mod:isDamageSelfInflicted(flag, source, true) then
        return false
    end
end, 1)

local function ShadowRabbitsMovement(fam, target, d, room, lineCheck)
    local distanceabs = fam.Position:Distance(target.Position)
    local targrel
    local targdistance = target.Position-fam.Position
    local rng = fam:GetDropRNG()
    if math.abs(targdistance.X) > math.abs(targdistance.Y) then
        targrel = (targdistance.X < 0 and 3) or 1
    else
        targrel = (targdistance.Y < 0 and 2) or 0
    end
    local fakeTargRel = targrel

    local nearNum = 0
    for _,rabbits in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.SHADOW_RABBIT_LARGE, -1, false, false)) do
        local dist = rabbits.Position:Distance(fam.Position)
        if rabbits.InitSeed ~= fam.InitSeed and dist < bal.BigEnochlophobia then
            nearNum = nearNum+1
            if dist < 20 then
                local vec = (rabbits.Position - fam.Position):Resized(20 - dist)
                fam.Velocity = mod:Lerp(fam.Velocity, fam.Velocity - vec, 0.3)
                rabbits.Velocity = mod:Lerp(rabbits.Velocity, rabbits.Velocity + vec, 0.3)
            end
        end
    end
    if not d.Skittish and rng:RandomInt(100) < nearNum*5 then
        d.BlacklistedTargRel = targrel
        d.Skittish = bal.SkittishTimer
    end
    if d.BlacklistedTargRel and targrel == d.BlacklistedTargRel then
        if not d.NewTargRel then
            local nums = {0, 1, 2, 3}
            table.remove(nums, d.BlacklistedTargRel+1)
            d.NewTargRel = nums[rng:RandomInt(3)+1]
        else
            fakeTargRel = d.NewTargRel
        end
    end

    if d.Skittish then
        if d.Skittish > 0 then
            d.Skittish = d.Skittish-1
        else
            d.NewTargRel = nil
            d.BlacklistedTargRel = nil
            d.Skittish = nil
        end
    end

    local speed = d.Speed or bal.Speed
    d.MyCurrentLength = d.MyCurrentLength or bal.SRClose
    if distanceabs < d.MyCurrentLength and (lineCheck == 4 or room:CheckLine(fam.Position,target.Position,lineCheck,3,false,false)) then
        local extravec = 0
        local tpa = target.Position
		if distanceabs < bal.SRShootDist then
			extravec = distanceabs / 3
		end

        if fakeTargRel == 0 then
            tpa = target.Position + Vector((target.Position.X - fam.Position.X), -distanceabs - extravec)
        elseif fakeTargRel == 1 then
            tpa = target.Position + Vector(-distanceabs - extravec, (target.Position.Y - fam.Position.Y))
        elseif fakeTargRel == 2 then
            tpa = target.Position + Vector((target.Position.X - fam.Position.X), distanceabs + extravec)
        elseif fakeTargRel == 3 then
            tpa = target.Position + Vector(distanceabs + extravec, (target.Position.Y - fam.Position.Y))
        end

        if fam.Position:Distance(tpa) > 10 then
            if lineCheck < 4 and not room:CheckLine(fam.Position,tpa,lineCheck,3,false,false) then
                tpa = target.Position
            end
            local vel = (tpa - fam.Position):Resized(speed)
            fam.Velocity = mod:Lerp(vel, fam.Velocity, 0.8)
        else
            fam.Velocity = mod:Lerp(fam.Velocity, Vector.Zero, 0.35)
        end

    else
        if lineCheck == 4 or room:CheckLine(fam.Position,target.Position,lineCheck,1,false,false) then
            local vel = (target.Position - fam.Position):Resized(speed)
            fam.Velocity = mod:Lerp(vel, fam.Velocity, 0.8)
        elseif fam:GetPathfinder():HasPathToPos(target.Position, false) then
            mod:CatheryPathFinding(fam, target.Position, {
                Speed = speed,
                Accel = 0.2,
                Interval = 1,
                GiveUp = true
            })
        else
            if d.StateFrame > bal.SRLoseInterest then
                d.ChangeTarget = true
                d.StateFrame = 0
            end
            local targvec = Vector(fam.Position.X, target.Position.Y)
            if targrel == 2 or targrel == 0 then
                targvec = Vector(target.Position.X, fam.Position.Y)
            end
            local vel = (targvec - fam.Position):Resized(speed)
            fam.Velocity = mod:Lerp(vel, fam.Velocity, 0.8)
        end
    end
    return targrel
end

local goodGridTypes = {
    [GridEntityType.GRID_TRAPDOOR] = true,
    --[GridEntityType.GRID_PRESSURE_PLATE] = true, not needed
    [GridEntityType.GRID_TELEPORTER] = true,
}

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
    local sprite = fam:GetSprite()
	local player = fam.Player
	local d = mod:GetEntityData(fam)
	local isSuperpositioned = mod:isSuperpositionedPlayer(fam.Player)
	local isSirenCharmed = mod:isSirenCharmed(fam)
    local room = game:GetRoom()
    local rng = fam:GetDropRNG()

	if not d.Init then
		fam.FireCooldown = bal.FireRate
		d.StateFrame = 0

        if d.DoorAppearing then
            d.State = "Enter"
            fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
            fam.Color = Color(0, 0, 0, 0.5)
            d.FadedOut = 15
            d.DoorTargetPos = room:FindFreeTilePosition(fam.Position, 0)
        elseif d.BrotherBobbyRabbit then
            d.State = "Familiar"
            fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
            fam.Color = Color(0, 0, 0, 0.5)
            d.FadedOut = 15
        else
            d.State = "Standard"
            fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
        end
        d.Init = true
	else
		fam.FireCooldown = fam.FireCooldown - ((player and player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) and 2) or 1)
		d.StateFrame = d.StateFrame + 1
	end
	
    if d.State == "Standard" then
        local pathfinder = fam:GetPathfinder()
        if not mod:superExists(d.Target) or d.ChangeTarget then
            d.ChangeTarget = nil
            d.Target = mod.FindRandomEnemy(fam.Position, nil, true)
        end
        local target = d.Target
        if isSirenCharmed then
            target = player
        end

        if target then
            local targrel = ShadowRabbitsMovement(fam, target, d, room, 3)

            local targdistance = target.Position-fam.Position
            local dir
            if (math.abs(targdistance.X) < bal.SRAlignRange or math.abs(targdistance.Y) < bal.SRAlignRange) and (not target:ToNPC() or target:IsVulnerableEnemy()) then
                d.Shooting = numToDir[targrel]
                dir = targrel
            else
                d.Shooting = nil
            end

            if target and fam.FireCooldown <= 0 and d.Shooting then
                d.FiredRecently = fam.FrameCount
                fam.FireCooldown = bal.FireRate
                local vec = Vector(0, bal.SRShotSpeed):Rotated(-dir*90)+ (fam.Velocity/3)
                if d.OverwriteTearVelocity then
                    vec = d.OverwriteTearVelocity
                end
                        
                if isSirenCharmed then
                    local proj = Isaac.Spawn(9, 0, 0, fam.Position, vec, fam):ToProjectile()
                else
                    local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, fam.Position+vec:Resized(5), vec, fam):ToTear()
                    tear.Height = bal.SRTearHeight
                    local mult = fam:GetMultiplier()
                    tear.CollisionDamage = (bal.SRDamageFlat+player.Damage*bal.SRDamageMult)*mult
                    tear.Scale = 0.6 + 0.2 * math.max(1, mult)
                    tear:ResetSpriteScale()
                    if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
                        tear:AddTearFlags(TearFlags.TEAR_HOMING)
                        local tearcolor = Color(0.4, 0.15, 0.38, 1, 55/255, 5/255, 95/255)
                        tear.Color = tearcolor
                    end
                    if isSuperpositioned then
                        local tearcolor = Color.Lerp(tear.Color, Color(1,1,1,1,0,0,0), 0)
                        tearcolor.A = tearcolor.A / 4
                        tear.Color = tearcolor
                        tear.CollisionDamage = tear.CollisionDamage/4
                    end
                end
            end
        else
            d.Shooting = nil
            target = player
            if fam.Position:Distance(target.Position) < 60 then
                fam.Velocity = mod:Lerp(fam.Velocity, Vector.Zero, 0.3)
            elseif room:CheckLine(fam.Position,target.Position,3,1,false,false) then
                fam.Velocity = mod:Lerp(fam.Velocity, (target.Position-fam.Position):Resized(bal.Speed), 0.3)
            else
                if pathfinder:HasPathToPos(target.Position, false) then
                    pathfinder:FindGridPath(target.Position, bal.Speed/6.5, 900, true)
                else
                    fam.Velocity = mod:Lerp(fam.Velocity, Vector.Zero, 0.3)
                end
            end
            for _,rabbits in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.SHADOW_RABBIT_LARGE, -1, false, false)) do
                local dist = rabbits.Position:Distance(fam.Position)
                if rabbits.InitSeed ~= fam.InitSeed and dist < bal.BigEnochlophobia then
                    if dist < 20 then
                        local vec = (rabbits.Position - fam.Position):Resized(20 - dist)
                        fam.Velocity = mod:Lerp(fam.Velocity, fam.Velocity - vec, 0.3)
                        rabbits.Velocity = mod:Lerp(rabbits.Velocity, rabbits.Velocity + vec, 0.3)
                    end
                end
            end
        end
    elseif d.State == "Enter" then
        if not d.DoorAppeared then
            local targetvel = (d.DoorTargetPos - fam.Position):Resized(bal.Speed)
            fam.Velocity = mod:Lerp(fam.Velocity, targetvel, 0.2)

            if fam.Position:Distance(d.DoorTargetPos) < 6 then
                d.DoorAppeared = true
                fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
            end
        else
            fam.Velocity = mod:Lerp(fam.Velocity, Vector.Zero, 0.3)
            d.State = "Standard"
        end
    elseif d.State == "Familiar" then
        if d.BrotherBobbyRabbit and d.BrotherBobbyRabbit:Exists() then
            local p = d.BrotherBobbyRabbit
            local vec = (p.Position - fam.Position)
            if vec:Length() > 80 then
                fam.Velocity = mod:Lerp(fam.Velocity, vec:Resized(5), 0.2)
            elseif vec:Length() > 40 then
                fam.Velocity = mod:Lerp(fam.Velocity, vec:Resized(5), 0.09)
            else
                fam.Velocity = mod:Lerp(fam.Velocity, Vector.Zero, 0.3)
            end
        else
            fam:Remove()
        end
    elseif d.State == "YouNeedToLeave" then
        fam.Velocity = mod:Lerp(fam.Velocity, Vector.Zero, 0.3)
    end

    if d.ForceFire and fam.FireCooldown <= 0 then
        d.FiredRecently = fam.FrameCount
        fam.FireCooldown = bal.FireRate
        mod.scheduleForUpdate(function()
            d.FiredRecently = fam.FrameCount-30
        end, 5)
        local vec = d.OverwriteTearVelocity or Vector.Zero

        if isSirenCharmed then
            local proj = Isaac.Spawn(9, 0, 0, fam.Position, vec, fam):ToProjectile()
        else
            local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, fam.Position+vec:Resized(5), vec, fam):ToTear()
            tear.Height = bal.SRTearHeight
            local mult = fam:GetMultiplier()
            tear.CollisionDamage = (bal.SRDamageFlat+player.Damage*bal.SRDamageMult)*mult
            tear.Scale = 0.6 + 0.2 * math.max(1, mult)
            tear:ResetSpriteScale()
            if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
                tear:AddTearFlags(TearFlags.TEAR_HOMING)
                local tearcolor = Color(0.4, 0.15, 0.38, 1, 55/255, 5/255, 95/255)
                tear.Color = tearcolor
            end
            if isSuperpositioned then
                local tearcolor = Color.Lerp(tear.Color, Color(1,1,1,1,0,0,0), 0)
                tearcolor.A = tearcolor.A / 4
                tear.Color = tearcolor
                tear.CollisionDamage = tear.CollisionDamage/4
            end
        end
        d.ForceFire = nil
    end

    if d.FadedOut then
        if d.FadedOut > 0 then
            d.FadedOut = d.FadedOut-1
            fam.Color = Color.Lerp(fam.Color, Color(1, 1, 1, 1, 0, 0, 0), 0.1)
        else
            fam.Color = Color(1, 1, 1, 1, 0, 0, 0)
            d.FadedOut = nil
        end
    elseif d.FadedIn then
        if d.FadedIn > 0 then
            d.FadedIn = d.FadedIn-1
            fam.Color = Color.Lerp(fam.Color, Color(1, 1, 1, 0, 0, 0, 0), 0.1)
        else
            fam.Color = Color(1, 1, 1, 0, 0, 0, 0)
            d.FadedIn = nil
            fam:Remove()
        end
    end

    if d.Shooting then
        local anim = "FloatShoot"

        d.FiredRecently = d.FiredRecently or fam.FrameCount
        if fam.FrameCount-d.FiredRecently > 40 then
            anim = "Float"
            d.Shooting = nil
        elseif fam.FrameCount-d.FiredRecently > 5 then
            anim = "Float"
        end

		if d.Shooting == "Left" and not (sprite:IsPlaying(anim .. "Side") and sprite.FlipX == true) then
			local frame = sprite:GetFrame()
			sprite:Play(anim .. "Side", true)
			sprite:SetFrame(frame)
			sprite.FlipX = true
		elseif d.Shooting == "Right" and not (sprite:IsPlaying(anim .. "Side") and sprite.FlipX == false) then
			local frame = sprite:GetFrame()
			sprite:Play(anim .. "Side", true)
			sprite:SetFrame(frame)
			sprite.FlipX = false
		elseif d.Shooting == "Up" and not sprite:IsPlaying(anim .. "Up") then
			local frame = sprite:GetFrame()
			sprite:Play(anim .. "Up", true)
			sprite:SetFrame(frame)
			sprite.FlipX = false
		elseif d.Shooting == "Down" and not sprite:IsPlaying(anim .. "Down") then
			local frame = sprite:GetFrame()
			sprite:Play(anim .. "Down", true)
			sprite:SetFrame(frame)
			sprite.FlipX = false
		end
	else
        if fam.Velocity:Length() < 1 then
            mod:spritePlay(sprite, "FloatDown")
		elseif math.abs(fam.Velocity.X) > math.abs(fam.Velocity.Y) then
            if not sprite:IsPlaying("FloatSide") then
                local frame = sprite:GetFrame()
                sprite:Play("FloatSide", true)
                sprite:SetFrame(frame)
            end
            sprite.FlipX = fam.Velocity.X < 0
        else
            sprite.FlipX = false

            if fam.Velocity.Y < 0 and not sprite:IsPlaying("FloatUp") then
                local frame = sprite:GetFrame()
                sprite:Play("FloatUp", true)
                sprite:SetFrame(frame)
            elseif fam.Velocity.Y > 0 and not sprite:IsPlaying("FloatDown") then
                local frame = sprite:GetFrame()
                sprite:Play("FloatDown", true)
                sprite:SetFrame(frame)
            end
        end
	end

    
    --[[local layer = sprite:GetLayer(0)
    if layer:GetSpritesheetPath() ~= "gfx/familiar/nyx/familiar_castgem_green.png" then
        sprite:ReplaceSpritesheet(0, "gfx/familiar/nyx/familiar_castgem_green.png", true)
    end]]
end, mod.ITEM.FAMILIAR.SHADOW_RABBIT_SMALL)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
    local sprite = fam:GetSprite()
	local player = fam.Player
	local d = mod:GetEntityData(fam)
	local isSuperpositioned = mod:isSuperpositionedPlayer(fam.Player)
	local isSirenCharmed = mod:isSirenCharmed(fam)
    local room = game:GetRoom()
    local rng = fam:GetDropRNG()

	if not d.Init then
        d.FireRate = bal.FireRate
        d.Damage = bal.BigDamage
        d.DamageMult = bal.BigDamageMult
        d.Speed = bal.Speed
        d.ShotSpeed = bal.SRShotSpeed
        d.TearHeight = bal.BigTearHeight
        d.FallingAccel = 0
        d.FallingSpeed = 0
		d.StateFrame = 0
        d.CurrEye = (rng:RandomInt(2) == 0 and -1) or 1

        if d.DoorAppearing then
            d.State = "Enter"
            fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
            fam.Color = Color(0, 0, 0, 0.5)
            d.FadedOut = 15
            d.DoorTargetPos = room:FindFreeTilePosition(fam.Position, 0)
        else
            d.State = "Standard"
            fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        end

        if d.RabbitSpecial then
            if d.RabbitSpecial.InitFunc then
                d.RabbitSpecial.InitFunc(fam, d)
            end

            if d.RabbitSpecial.FireRate then
                d.FireRate = d.FireRate+d.RabbitSpecial.FireRate
            end
            if d.RabbitSpecial.Damage then
                d.Damage = d.Damage+d.RabbitSpecial.Damage
            end
            if d.RabbitSpecial.DamageMult then
                d.DamageMult = d.DamageMult+d.RabbitSpecial.DamageMult
            end
            if d.RabbitSpecial.Speed then
                d.Speed = d.Speed+d.RabbitSpecial.Speed
            end
            if d.RabbitSpecial.ShotSpeed then
                d.ShotSpeed = d.ShotSpeed+d.RabbitSpecial.ShotSpeed
            end
            if d.RabbitSpecial.Scale then
                fam.SpriteScale = Vector(fam.SpriteScale.X+d.RabbitSpecial.Scale, fam.SpriteScale.Y+d.RabbitSpecial.Scale)
            end
            if d.RabbitSpecial.TearHeight then
                d.TearHeight = d.TearHeight+d.RabbitSpecial.TearHeight
            end
            if d.RabbitSpecial.FallingAccel then
                d.FallingAccel = d.FallingAccel+d.RabbitSpecial.FallingAccel
            end
            if d.RabbitSpecial.FallingSpeed then
                d.FallingSpeed = d.FallingSpeed+d.RabbitSpecial.FallingSpeed
            end
            d.SpoonBender = d.RabbitSpecial.SpoonBender
            d.Flying = d.RabbitSpecial.Flying
            d.Special = d.RabbitSpecial.Special
            d.NoEye = d.RabbitSpecial.NoEyeOffset
        end

        fam.FireCooldown = d.FireRate
        d.Init = true
	else
		fam.FireCooldown = fam.FireCooldown - ((player and player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) and 2) or 1)
		d.StateFrame = d.StateFrame + 1
	end

    if d.RabbitSpecial then
        if d.RabbitSpecial.Costume and not d.ReplacedCostume then
            if d.RabbitSpecial.Costume.Head then
                sprite:ReplaceSpritesheet(1, "gfx/familiar/shadowrabbits/" .. d.RabbitSpecial.Costume.Head .. ".png", true)
            end
            if d.RabbitSpecial.Costume.Body then
                sprite:ReplaceSpritesheet(0, "gfx/familiar/shadowrabbits/" .. d.RabbitSpecial.Costume.Body .. " Body.png", true)
            end
            d.ReplacedCostume = true
        end
        if d.RabbitSpecial.Scale then
            fam.SpriteScale = Vector(fam.SpriteScale.X+d.RabbitSpecial.Scale, fam.SpriteScale.Y+d.RabbitSpecial.Scale)
        end
        if d.RabbitSpecial.ExtraFunc then
            d.RabbitSpecial.ExtraFunc(fam, d)
        end
    end

    if d.State == "Standard" and not d.Controller then
        for i = 1, game:GetNumPlayers() do
		    local p = Isaac.GetPlayer(i - 1)
            local pd = mod:GetEntityData(p)
            if pd.ffsavedata.ShadowRabbiting and p.Position:Distance(fam.Position) < bal.ControllerGainDist
            and not pd.ControllingSRabbit and not pd.ffsavedata.ShadowRabbiting.ExitPoint then
                d.Controller = p
                d.State = "CONTROLLED"
                d.Poofed = nil
                pd.ControllingSRabbit = fam
                break
            end
        end
    end

    if d.State == "CONTROLLED" then
        if d.Controller and d.Controller:Exists() and (d.Controller.Position:Distance(fam.Position) < bal.ControllerLoseDist or d.TeleportTimer) then
            local controller = d.Controller
            local cd = mod:GetEntityData(controller)

            local yay = room:IsPositionInRoom(controller.Position, 0) and room:GetGridCollisionAtPos(controller.Position) < isGridCollFine[fam.GridCollisionClass]
            if fam.Position:Distance(controller.Position) < 20 and yay then
                fam.Velocity = controller.Position-fam.Position
                if not d.Poofed then
                    d.Poofed = true
                    local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 1, controller.Position, Vector.Zero, fam):ToEffect()
                    poof.Color = Color(0.12, 0.12, 0.12, 1, 0, 0, 0)
                    poof.DepthOffset = 20
                    poof:Update()
                    local poof2 = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 2, controller.Position, Vector.Zero, fam):ToEffect()
                    poof2.Color = Color(0.12, 0.12, 0.12, 1, 0, 0, 0)
                    poof2.DepthOffset = 20
                    poof2.SpriteScale = Vector(1.5, 1.5)
                    poof2:Update()
                    sfx:Play(SoundEffect.SOUND_BLACK_POOF, 1, 0, false, 1)
                end
                
                for _, pickup in ipairs(Isaac.FindInRadius(controller.Position, 50, EntityPartition.PICKUP)) do
                    if pickup.EntityCollisionClass >= EntityCollisionClass.ENTCOLL_PLAYERONLY then
                        if pickup.Position:DistanceSquared(controller.Position) <= (controller.Size + pickup.Size) ^ 2 then
                            cd.ShadowRabbitSpecialColl = true
                            controller.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                            --pickup:ForceCollide(controller, true)
                            mod.scheduleForUpdate(function()
                                cd.ShadowRabbitSpecialColl = nil
                                controller.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                            end, 0)
                        end
                    end
                end
                local grid = room:GetGridEntityFromPos(controller.Position)
                if grid and goodGridTypes[grid:GetType()] then
                    local STOPIT
                    if grid:GetType() == GridEntityType.GRID_TELEPORTER and d.TeleportCooldown then
                        STOPIT = true
                    elseif grid:GetType() == GridEntityType.GRID_TELEPORTER and not d.TeleportTimer then
                        d.TeleportTimer = 5
                        d.LastPos = d.LastPos or controller.Position
                    end
                    if not STOPIT then
                        controller.EntityCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
                        mod.scheduleForUpdate(function()
                            cd.ShadowRabbitSpecialColl = nil
                            controller.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                        end, 0)
                    end
                end
            elseif yay then
                fam.Velocity = mod:Lerp(fam.Velocity, (controller.Position-fam.Position):Resized(d.Speed*2), 0.3)
            end

            if d.TeleportTimer then
                if d.TeleportTimer > 0 then
                    d.TeleportTimer = d.TeleportTimer-1
                    if controller.Position:Distance(d.LastPos) > 60 then
                        fam.Position = controller.Position
                        d.LastPos = nil
                        d.TeleportTimer = nil
                        d.TeleportCooldown = 40
                    else
                        d.LastPos = controller.Position
                    end
                else
                    d.TeleportTimer = nil
                    d.LastPos = nil
                end
            end
            if d.TeleportCooldown then
                d.TeleportCooldown = (d.TeleportCooldown > 0 and d.TeleportCooldown-1) or nil
            end

            local fireDir = mod.GetCorrectedFiringInput(d.Controller, true)
            local mouse = (Options.MouseControl and cd.LastFiredMouse and Input.IsMouseBtnPressed(Mouse.MOUSE_BUTTON_1))
            if (fireDir:Length() > 0.5 or mouse) and fam.FireCooldown <= 0 then
                if mouse then
                    fireDir = mod:SnapVector(mod:GetMousePosition(true)-fam.Position, 90)
                else
                    fireDir = mod:SnapVector(fireDir, 90)
                end
                local vec = fireDir:Resized(d.ShotSpeed) + controller:GetTearMovementInheritance(controller.Velocity)
                if vec:Length() < d.ShotSpeed then
                    vec = vec:Resized(d.ShotSpeed)
                end

                d.CurrEye = (d.CurrEye == 1 and -1) or 1
                local off = vec:Rotated(90):Resized(bal.EyeOffset*d.CurrEye)
                if d.NoEye then
                    off = Vector.Zero
                end

                local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, fam.Position+vec:Resized(5)+off, vec, fam):ToTear()
                tear.Height = d.TearHeight
                local mult = fam:GetMultiplier()
                local balancedMult = 1-bal.BigDamageMult
                tear.CollisionDamage = (d.Damage+player.Damage*(d.DamageMult+balancedMult))*mult
                local baseDamage = (bal.BigDamage+player.Damage)*mult
                tear.Scale = math.min(2, 0.4+0.7*(tear.CollisionDamage/baseDamage))
                tear:ResetSpriteScale()
                tear.FallingAcceleration = tear.FallingAcceleration+d.FallingAccel
                tear.FallingSpeed = tear.FallingSpeed+d.FallingSpeed
                tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
                if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
                    tear:AddTearFlags(TearFlags.TEAR_HOMING)
                    local tearcolor = Color(0.4, 0.15, 0.38, 1, 55/255, 5/255, 95/255)
                    tear.Color = tearcolor
                end
                tear.Color = Color(tear.Color.R, tear.Color.G, tear.Color.B, 0.65)
                if isSuperpositioned then
                    local tearcolor = Color.Lerp(tear.Color, Color(1,1,1,1,0,0,0), 0)
                    tearcolor.A = tearcolor.A / 4
                    tear.Color = tearcolor
                    tear.CollisionDamage = tear.CollisionDamage/4
                end
                if d.RabbitSpecial and d.RabbitSpecial.TearFlags then
                    tear:AddTearFlags(d.RabbitSpecial.TearFlags)
                end

                if math.abs(fireDir.X) >= math.abs(fireDir.Y) then
                    d.Shooting = (fireDir.X > 0 and "Right") or "Left"
                else
                    d.Shooting = (fireDir.Y > 0 and "Down") or "Up"
                end

                if d.RabbitSpecial and d.RabbitSpecial.FireFunc then
                    d.RabbitSpecial.FireFunc(fam, d, tear, d.Shooting, d.CurrEye)
                end
                fam.FireCooldown = d.FireRate
                d.FiredRecently = fam.FrameCount
            end
        else
            if d.Controller and d.Controller:Exists() then
                mod:GetEntityData(d.Controller).ControllingSRabbit = nil
            end
            d.Controller = nil
            d.State = "Standard"
        end
    elseif d.State == "Standard" then
        local pathfinder = fam:GetPathfinder()
        if not mod:superExists(d.Target) or d.ChangeTarget then
            d.ChangeTarget = nil
            d.Target = mod.FindRandomEnemy(fam.Position, nil, true)
        end
        local target = d.Target
        if isSirenCharmed then
            target = player
        end

        if target then
            local targrel = ShadowRabbitsMovement(fam, target, d, room, (d.Flying and 4) or 3)

            local targdistance = target.Position-fam.Position
            local dir
            if (math.abs(targdistance.X) < bal.SRAlignRange or math.abs(targdistance.Y) < bal.SRAlignRange) and (not target:ToNPC() or target:IsVulnerableEnemy()) then
                d.Shooting = numToDir[targrel]
                dir = targrel
            else
                d.Shooting = nil
            end

            if target and fam.FireCooldown <= 0 and d.Shooting then
                d.FiredRecently = fam.FrameCount
                fam.FireCooldown = d.FireRate
                local vec = Vector(0, d.ShotSpeed):Rotated(-dir*90)+ (fam.Velocity/3)

                d.CurrEye = (d.CurrEye == 1 and -1) or 1
                local off = vec:Rotated(90):Resized(bal.EyeOffset*d.CurrEye)
                if d.NoEye then
                    off = Vector.Zero
                end
                 
                if isSirenCharmed then
                    local proj = Isaac.Spawn(9, 0, 0, fam.Position+off, vec, fam):ToProjectile()
                else
                    local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, fam.Position+vec:Resized(5)+off, vec, fam):ToTear()
                    tear.Height = d.TearHeight
                    local mult = fam:GetMultiplier()
                    tear.CollisionDamage = (d.Damage+player.Damage*d.DamageMult)*mult
                    local baseDamage = (bal.BigDamage+player.Damage*bal.BigDamageMult)*mult
                    tear.Scale = math.min(2, 0.4+0.7*(tear.CollisionDamage/baseDamage))
                    tear:ResetSpriteScale()
                    tear.FallingAcceleration = tear.FallingAcceleration+d.FallingAccel
                    tear.FallingSpeed = tear.FallingSpeed+d.FallingSpeed
                    tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
                    if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
                        tear:AddTearFlags(TearFlags.TEAR_HOMING)
                        local tearcolor = Color(0.4, 0.15, 0.38, 1, 55/255, 5/255, 95/255)
                        tear.Color = tearcolor
                    end
                    tear.Color = Color(tear.Color.R, tear.Color.G, tear.Color.B, 0.65)
                    if isSuperpositioned then
                        local tearcolor = Color.Lerp(tear.Color, Color(1,1,1,1,0,0,0), 0)
                        tearcolor.A = tearcolor.A / 4
                        tear.Color = tearcolor
                        tear.CollisionDamage = tear.CollisionDamage/4
                    end
                    if d.RabbitSpecial and d.RabbitSpecial.TearFlags then
                        tear:AddTearFlags(d.RabbitSpecial.TearFlags)
                    end
                    if d.RabbitSpecial and d.RabbitSpecial.FireFunc then
                        d.RabbitSpecial.FireFunc(fam, d, tear, numToDir[targrel], d.CurrEye)
                    end
                end
            end
        else
            d.Shooting = nil
            target = player
            if fam.Position:Distance(target.Position) < 60 then
                fam.Velocity = mod:Lerp(fam.Velocity, Vector.Zero, 0.3)
            elseif d.Flying or room:CheckLine(fam.Position,target.Position,0,1,false,false) then
                fam.Velocity = mod:Lerp(fam.Velocity, (target.Position-fam.Position):Resized(d.Speed), 0.3)
            else
                if pathfinder:HasPathToPos(target.Position, false) then
                    pathfinder:FindGridPath(target.Position, d.Speed/6.5, 900, true)
                else
                    fam.Velocity = mod:Lerp(fam.Velocity, Vector.Zero, 0.3)
                end
            end

            for _,rabbits in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.SHADOW_RABBIT_LARGE, -1, false, false)) do
                local dist = rabbits.Position:Distance(fam.Position)
                if rabbits.InitSeed ~= fam.InitSeed and dist < bal.BigEnochlophobia then
                    if dist < 20 then
                        local vec = (rabbits.Position - fam.Position):Resized(20 - dist)
                        fam.Velocity = mod:Lerp(fam.Velocity, fam.Velocity - vec, 0.3)
                        rabbits.Velocity = mod:Lerp(rabbits.Velocity, rabbits.Velocity + vec, 0.3)
                    end
                end
            end
        end
    elseif d.State == "Enter" then
        if not d.DoorAppeared then
            local targetvel = (d.DoorTargetPos - fam.Position):Resized(d.Speed)
            fam.Velocity = mod:Lerp(fam.Velocity, targetvel, 0.2)

            if fam.Position:Distance(d.DoorTargetPos) < 6 then
                d.DoorAppeared = true
                if d.Flying then
                    fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
                else
                    fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
                end
            end
        else
            fam.Velocity = mod:Lerp(fam.Velocity, Vector.Zero, 0.3)
            d.State = "Standard"
        end
    elseif d.State == "Hurt" then
        if sprite:IsFinished("Hurt") then
            d.State = "Standard"
            d.StateFrame = 0
        else
            mod:spritePlay(sprite, "Hurt")
        end

        fam.Velocity = mod:Lerp(fam.Velocity, Vector.Zero, 0.3)
    elseif d.State == "YouNeedToLeave" then
        fam.Velocity = mod:Lerp(fam.Velocity, Vector.Zero, 0.3)
    end

    if d.FadedOut then
        if d.FadedOut > 0 then
            d.FadedOut = d.FadedOut-1
            fam.Color = Color.Lerp(fam.Color, Color(1, 1, 1, 1, 0, 0, 0), 0.1)
        else
            fam.Color = Color(1, 1, 1, 1, 0, 0, 0)
            d.FadedOut = nil
        end
    elseif d.FadedIn then
        if d.FadedIn > 0 then
            d.FadedIn = d.FadedIn-1
            fam.Color = Color.Lerp(fam.Color, Color(1, 1, 1, 0, 0, 0, 0), 0.1)
        else
            fam.Color = Color(1, 1, 1, 0, 0, 0, 0)
            d.FadedIn = nil
            fam:Remove()
        end
    end

	if d.State == "Hurt" then
    elseif d.Flying == true then
        if fam.Velocity:Length() < 1 then
            mod:spritePlay(sprite, "FlyIdle")
        else
            mod:spritePlay(sprite, "Fly")
        end
    else
        if fam.Velocity:Length() < 1 then
            mod:spritePlay(sprite, "IdleDown")
		elseif math.abs(fam.Velocity.X) > math.abs(fam.Velocity.Y) then
            if fam.Velocity.X > 0 then
                mod:spritePlay(sprite, "WalkRight")
            else
                mod:spritePlay(sprite, "WalkLeft")
            end
        else
            mod:spritePlay(sprite, "WalkDown")
        end
	end

    local anim = "Shoot"

    d.FiredRecently = d.FiredRecently or fam.FrameCount-50
    if fam.FrameCount-d.FiredRecently > 40 then
        anim = "Head"
        d.Shooting = nil
    elseif fam.FrameCount-d.FiredRecently > 5 then
        anim = "Head"
    end

    local extra = (d.SpoonBender and "Fire") or ""
    if d.State == "Hurt" then
        sprite:RemoveOverlay()
    elseif d.Shooting then
		if d.Shooting == "Left" and not sprite:IsOverlayPlaying(anim .. "Left" .. extra) then
			local frame = sprite:GetFrame()
			sprite:PlayOverlay(anim .. "Left" .. extra, true)
			sprite:SetOverlayFrame(frame)
		elseif d.Shooting == "Right" and not sprite:IsOverlayPlaying(anim .. "Right" .. extra) then
			local frame = sprite:GetFrame()
			sprite:PlayOverlay(anim .. "Right" .. extra, true)
			sprite:SetOverlayFrame(frame)
		elseif d.Shooting == "Up" and not sprite:IsOverlayPlaying(anim .. "Up" .. extra) then
			local frame = sprite:GetFrame()
			sprite:PlayOverlay(anim .. "Up" .. extra, true)
			sprite:SetOverlayFrame(frame)
		elseif d.Shooting == "Down" and not sprite:IsOverlayPlaying(anim .. "Down" .. extra) then
			local frame = sprite:GetFrame()
			sprite:PlayOverlay(anim .. "Down" .. extra, true)
			sprite:SetOverlayFrame(frame)
		end
    else
        if fam.Velocity:Length() < 0.5 then
            if not sprite:IsOverlayPlaying(anim .. "Down" .. extra) then
                local frame = sprite:GetFrame()
                sprite:PlayOverlay(anim .. "Down" .. extra, true)
                sprite:SetOverlayFrame(frame)
            end
		elseif math.abs(fam.Velocity.X) > math.abs(fam.Velocity.Y) then
            if fam.Velocity.X > 0 and not sprite:IsOverlayPlaying(anim .. "Right" .. extra) then
                local frame = sprite:GetFrame()
                sprite:PlayOverlay(anim .. "Right" .. extra, true)
                sprite:SetOverlayFrame(frame)
            elseif fam.Velocity.X <= 0 and not sprite:IsOverlayPlaying(anim .. "Left" .. extra) then
                local frame = sprite:GetFrame()
                sprite:PlayOverlay(anim .. "Left" .. extra, true)
                sprite:SetOverlayFrame(frame)
            end
        elseif math.abs(fam.Velocity.X) <= math.abs(fam.Velocity.Y) then
            if fam.Velocity.Y > 0 and not sprite:IsOverlayPlaying(anim .. "Down" .. extra) then
                local frame = sprite:GetFrame()
                sprite:PlayOverlay(anim .. "Down" .. extra, true)
                sprite:SetOverlayFrame(frame)
            elseif fam.Velocity.Y <= 0 and not sprite:IsOverlayPlaying(anim .. "Up" .. extra) then
                local frame = sprite:GetFrame()
                sprite:PlayOverlay(anim .. "Up" .. extra, true)
                sprite:SetOverlayFrame(frame)
            end
        end
    end
end, mod.ITEM.FAMILIAR.SHADOW_RABBIT_LARGE)

function mod:ShadowRabbitsCollision(player, collider, low)
    if mod:GetEntityData(player).ShadowRabbitSpecialColl then
        if collider and collider.Type ~= 5 then
            return true
        end
    end
end

mod:AddPriorityCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, -1, function(_, proj, collider, low)
	if collider and collider:ToPlayer() and mod:GetEntityData(collider).ShadowRabbitSpecialColl then
		return true
	end
end)