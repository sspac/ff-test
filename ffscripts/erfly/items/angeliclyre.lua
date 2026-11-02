local mod = FiendFolio
local game = Game()
local nilvector = Vector.Zero
local sfx = SFXManager()

mod.AngelicLyreStats = {
    Blue = {
        TearMult = 0.75,
        Speed = 0.2,
        Luck = 3,
        Shotspeed = -0.2
    },
    Red = {
        DamageMult = 2,
        TearMult = 6,
        Flags = TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_KNOCKBACK,
        Color = Color(1.5, 2, 2, 0.5, 0, 0, 0)
    },
    Yellow = {
        DamageMult = 0.2,
        TearMult = 0.15,
        BurstDelayMult = 15,
        Range = 100,
        Flags = TearFlags.TEAR_HOMING,
        Color = Color(0.4, 0.15, 0.38, 1, 0.27843, 0, 0.4549)
    }
}

local lyreRotation = {
    [mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_B] = mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_R,
    [mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_R] = mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_Y,
    [mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_Y] = mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_B,
}

local lyreInterruptables = {
    ["PickupWalkUp"] = true,
    ["PickupWalkDown"] = true,
    ["PickupWalkLeft"] = true,
    ["PickupWalkRight"] = true,
    ["WalkUp"] = true,
    ["WalkDown"] = true,
    ["WalkLeft"] = true,
    ["WalkRight"] = true,
    ["Hit"] = true,
}

local function getLyreActiveSlot(player, pdata)
    if pdata.ffsavedata.VoidedLyre then
        return false
    else
        if lyreRotation[player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)] then
            return ActiveSlot.SLOT_PRIMARY
        elseif lyreRotation[player:GetActiveItem(ActiveSlot.SLOT_POCKET)] then
            return ActiveSlot.SLOT_POCKET
        end
    end
end

function mod:useAngelicLyre(ItemID, rng, player, useFlags, activeSlot)
    local d = mod:GetEntityData(player)
    local sprite = player:GetSprite()
    local anim = sprite:GetAnimation()
    if player:IsExtraAnimationFinished() or sprite:IsPlaying("Hit") or (room:IsClear() and lyreInterruptables[anim]) then
        sfx:Play(mod.Sounds.AngelicHarpStrum, 1, 0, false, 1)
        if activeSlot and activeSlot >= 0 then
            player:RemoveCollectible(ItemID, true, activeSlot)
            player:AddCollectible(lyreRotation[ItemID], 0, false, activeSlot)
        end
        if useFlags == useFlags | UseFlag.USE_VOID then
            d.ffsavedata.VoidedLyre = d.ffsavedata.VoidedLyre or -1
            d.ffsavedata.VoidedLyre = (d.ffsavedata.VoidedLyre + 1) % 3
            ItemID = d.ffsavedata.VoidedLyre + mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_R
        end
        --[[player:AddCacheFlags(CacheFlag.CACHE_ALL)
        player:EvaluateItems()]]
        player.FireDelay = 1
        mod:GetEntityData(player).BlueLyreShot = nil
        mod:GetEntityData(player).YellowLyreShot = 0
        --print(ItemID)
        player:AnimateCollectible(lyreRotation[ItemID], "UseItem")
        local note = Isaac.Spawn(1000, mod.FF.LyreParticle.Var, mod.FF.LyreParticle.Sub, player.Position, nilvector, player):ToEffect()
        mod:GetEntityData(note).note = (lyreRotation[ItemID] - mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_R + 1) % 3
        note:Update()
        --return true
        if mod:IsAnyFriend(player) then
            mod:UpdateMultishotGuns(player)
            for initseed, gTab in pairs(d.FriendHeldGuns) do
                if gTab.Gun and gTab.Gun:Exists() then
                    gTab.Ammo = mod:GetFriendAmmo(gTab.Gun)
                end
            end
        end
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
        for _, wisp in pairs(Isaac.FindByType(3, 206, ItemID)) do
            if wisp.SpawnerEntity and wisp.SpawnerEntity.InitSeed == player.InitSeed then
                wisp:Remove()
            end
        end
        local newWisp = player:AddWisp(lyreRotation[ItemID], player.Position)
        newWisp:Update()
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.useAngelicLyre, mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_B)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.useAngelicLyre, mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_R)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.useAngelicLyre, mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_Y)

function mod:lyreParticleAI(e)
    local sprite, d = e:GetSprite(), mod:GetEntityData(e)
    sprite:SetFrame("Idle", d.note or 0)
    d.speed = d.speed or math.random(50,200)/100
    d.offset = d.offset or (math.random() * math.pi * 2)
    d.mult = d.mult or math.random(5,20)
    e.SpriteOffset = Vector(math.cos(d.offset + e.FrameCount/10) * d.mult, -30 - e.FrameCount/d.speed)

    if e.FrameCount > 150 then
        e:Remove()
    elseif e.FrameCount > 120 then
        e.Color = Color(1,1,1,1 - (e.FrameCount - 120)/30)
    elseif e.FrameCount <= 5 then
        e.Color = Color(1,1,1,math.min(e.FrameCount/5, 1))
    end
end

function mod:angelicLyrePlayerUpdate(player, data)
    if data.BlueLyreShotCooldown then
        data.BlueLyreShotCooldown = nil
    end
    if data.YellowLyreShotCooldown then
        data.YellowLyreShotCooldown = nil
    end
    if data.YellowLyreShot and data.YellowLyreShot > 0 then
        local aim = mod.GetGoodShootingJoystick(player)
        if aim:Length() < 0.5 then
            player.FireDelay = player.MaxFireDelay * mod.AngelicLyreStats.Yellow.BurstDelayMult
            data.YellowLyreShot = 0
            if player:HasTrinket(mod.ITEM.TRINKET.BUTTON_MASHER) then
                data.buttonMashActiveItem = getLyreActiveSlot(player, data)
            end
        end
    end
end

function mod:angelicLyrePostFireTear(player, tear, rng, pdata, tdata, ignorePlayerEffects, isLudo)
    if isLudo then return end
    if not pdata.ffsavedata then return end
    local voidVal = pdata.ffsavedata.VoidedLyre

    if not tear.CanTriggerStreakEnd then return end
    
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_B) or (player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and voidVal == 1) then
        if not pdata.BlueLyreShotIsTriangular then
            pdata.BlueLyreShot = pdata.BlueLyreShot or 0
            if not pdata.BlueLyreShotCooldown then
                pdata.BlueLyreShot = (pdata.BlueLyreShot + 1) % 3
                pdata.BlueLyreShotCooldown = true
            end

            if math.floor(pdata.BlueLyreShot) == 2 and player:GetPlayerType() ~= mod.PLAYER.FRIEND then --Triangle Shot 
                pdata.BlueLyreShotIsTriangular = true
                for i = -90, 90, 180 do
                    local newtear = player:FireTear(tear.Position, tear.Velocity, true, false, true, player, 1)
                    --newtear.FallingSpeed = tear.FallingSpeed
                    --newtear.PositionOffset = tear.PositionOffset
                    if newtear.Variant ~= tear.Variant then
                        newtear:ChangeVariant(tear.Variant)
                    end
                    if player:HasCollectible(CollectibleType.COLLECTIBLE_CHOCOLATE_MILK) then
                        newtear.Scale = tear.Scale
                        newtear.CollisionDamage = tear.CollisionDamage
                    end
                    if tdata.AlreadyDuplicatedByMultiEuclidean then
                        mod:GetEntityData(newtear).AlreadyDuplicatedByMultiEuclidean = tdata.AlreadyDuplicatedByMultiEuclidean
                    end
                    mod.scheduleForUpdate(function()
                        newtear.Position = tear.Position + tear.Velocity:Resized(-tear.Size * 2) + tear.Velocity:Resized(-tear.Size):Rotated(i)
                    end, 0)
                    if TearFlagsLib.HasTearFlags(tear, mod.FriendBulletFlags.FRIEND) then
						local gun = TearFlagsLib.GetTearFlagParams(tear, mod.FriendBulletFlags.FRIEND).Gun
						if gun and gun.Ref then
							mod:HandleFriendTears(player, gun.Ref, newtear, TearFlagsLib.GetTearFlagParams(tear, mod.FriendBulletFlags.FRIEND).Shot or {}, newtear.Velocity, false)
						end
                    end
                    if player:HasTrinket(mod.ITEM.TRINKET.BUTTON_MASHER) then
                        pdata.buttonMashActiveItem = getLyreActiveSlot(player, pdata)
                    end
                end
                pdata.BlueLyreShotIsTriangular = false
            elseif math.floor(pdata.BlueLyreShot) == 0 then --Nothing Shot
                local cloud = Isaac.Spawn(1000, mod.FF.FFWhiteSmoke.Var, mod.FF.FFWhiteSmoke.Sub, tear.Position - tear.Velocity, tear.Velocity, player)
                mod:GetEntityData(cloud).longonly = true
                cloud.SpriteOffset = Vector(0, tear.Height * 0.5)
                cloud.SpriteScale = Vector(0.5,0.5) * tear.Scale
                cloud.Color = tear.Color
                cloud:Update()
                mod:GetEntityData(tear).ffNoSplat = true
                tear:Remove()
            end
        end
    end
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_R) or (player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and voidVal == 2) then
        --print(tear.KnockbackMultiplier)
        tear.KnockbackMultiplier = tear.KnockbackMultiplier * 1.5
        --tear.Color = Color(1.5, 2, 2, 0.5, 0, 0, 0)
        --tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
        if not pdata.RedLyreShotIsQuaddening and player:GetPlayerType() ~= mod.PLAYER.FRIEND then
            pdata.RedLyreShotIsQuaddening = true
            for i = -2.5, 7.5, 5 do
                local newtear = player:FireTear(tear.Position - tear.Velocity, tear.Velocity:Rotated(i), true, false, true, player, 1)
                newtear.PositionOffset = tear.PositionOffset
                if player:HasCollectible(CollectibleType.COLLECTIBLE_CHOCOLATE_MILK) then
                    newtear.Scale = tear.Scale
                    newtear.CollisionDamage = tear.CollisionDamage
                end
                if tdata.FFMultiEuclideanTearSpawner then
                    mod:GetEntityData(newtear).FFMultiEuclideanTearSpawner = tdata.FFMultiEuclideanTearSpawner
                end
            end
            tear.Velocity = tear.Velocity:Rotated(-7.5)
            pdata.RedLyreShotIsQuaddening = false
            if player:HasTrinket(mod.ITEM.TRINKET.BUTTON_MASHER) then
                pdata.buttonMashActiveItem = getLyreActiveSlot(player, pdata)
            end
        end
    end
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_Y) or (player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and voidVal == 0) then
        if not pdata.YellowLyreShotCooldown then
            pdata.YellowLyreShot = pdata.YellowLyreShot or 0
            pdata.YellowLyreShot = pdata.YellowLyreShot + 1
            pdata.YellowLyreShotCooldown = true
            if pdata.YellowLyreShot >= 10 or (mod:IsAnyFriend(player) and #pdata.FriendHeldGuns[pdata.FriendsRevolver.InitSeed].Ammo <= 1) then
                player.FireDelay = player.MaxFireDelay * mod.AngelicLyreStats.Yellow.BurstDelayMult
                pdata.YellowLyreShot = 0
                if player:HasTrinket(mod.ITEM.TRINKET.BUTTON_MASHER) then
                    pdata.buttonMashActiveItem = getLyreActiveSlot(player, pdata)
                end
            end
        end
    end
end

function mod:angelicLyrePostFireBomb(player, bomb, rng, pdata, bdata)
    if not pdata.ffsavedata then return end
    local voidVal = pdata.ffsavedata.VoidedLyre
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_B) or (player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and voidVal == 1) then
        if not pdata.BlueLyreShotIsTriangular then
            if not pdata.BlueLyreShotCooldown then
                pdata.BlueLyreShot = pdata.BlueLyreShot or 0
                pdata.BlueLyreShot = (pdata.BlueLyreShot + 1) % 3
                pdata.BlueLyreShotCooldown = true
            end

            if math.floor(pdata.BlueLyreShot) == 2 then --Triangle Shot 
                pdata.BlueLyreShotIsTriangular = true
                for i = -90, 90, 180 do
                    local pos = bomb.Position + bomb.Velocity:Resized(-bomb.Size) + bomb.Velocity:Resized(-bomb.Size * 0.5):Rotated(i)
                    local newbomb = player:FireBomb(pos, bomb.Velocity, player)
                end
                mod.scheduleForUpdate(function()
                    pdata.BlueLyreShotIsTriangular = false
                end, 0)
                if player:HasTrinket(mod.ITEM.TRINKET.BUTTON_MASHER) then
                    pdata.buttonMashActiveItem = getLyreActiveSlot(player, pdata)
                end
            elseif math.floor(pdata.BlueLyreShot) == 0 then --Nothing Shot
                local cloud = Isaac.Spawn(1000, mod.FF.FFWhiteSmoke.Var, mod.FF.FFWhiteSmoke.Sub, bomb.Position, bomb.Velocity, player)
                mod:GetEntityData(cloud).longonly = true
                cloud.SpriteScale = Vector(0.5,0.5)
                cloud.SpriteOffset = Vector(0, -7)
                cloud.Color = bomb.Color
                cloud:Update()
                bomb:Remove()
            end
        end
    end
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_R) or (player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and voidVal == 2) then
        if not bdata.RedLyreShotIsQuaddening then
            for i = -2.5, 7.5, 5 do
                local newBomb = player:FireBomb(bomb.Position, bomb.Velocity:Rotated(i), player)
                mod:GetEntityData(newBomb).RedLyreShotIsQuaddening = true
            end
            bomb.Velocity = bomb.Velocity:Rotated(-7.5)
        end
    end
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_Y) or (player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and voidVal == 0) then
        if not pdata.YellowLyreShotCooldown then
            pdata.YellowLyreShot = pdata.YellowLyreShot or 0
            pdata.YellowLyreShot = pdata.YellowLyreShot + 1
            pdata.YellowLyreShotCooldown = true
            if pdata.YellowLyreShot >= 10 then
                player.FireDelay = player.MaxFireDelay * mod.AngelicLyreStats.Yellow.BurstDelayMult
                pdata.YellowLyreShot = 0
                if player:HasTrinket(mod.ITEM.TRINKET.BUTTON_MASHER) then
                    pdata.buttonMashActiveItem = getLyreActiveSlot(player, pdata)
                end
            end
        end
    end
end

function mod:angelicLyrePostFireLaser(player, laser, rng)
    --[[if player:HasCollectible(mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_R) then
        local pdata = mod:GetEntityData(player)
        local ldata = mod:GetEntityData(laser)
        if not ldata.RedLyreShotIsQuaddening then
            for i = -7.5, 7.5, 5 do
                --local newBomb = player:FireBomb(bomb.Position, bomb.Velocity:Rotated(i), player)
                local newLaser = player:FireTechLaser(laser.Position, 0, Vector(1,0):Rotated(laser.AngleDegrees):Rotated(i))
                mod:GetEntityData(newLaser).RedLyreShotIsQuaddening = true
            end
            pdata.RedLyreShotIsQuaddening = false
            laser:Remove()
        end
    end]]
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_Y) or (player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and voidVal == 0) then
        if not player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then
            local pdata = mod:GetEntityData(player)
            if not pdata.YellowLyreShotCooldown then
                pdata.YellowLyreShot = pdata.YellowLyreShot or 0
                pdata.YellowLyreShot = pdata.YellowLyreShot + 1
                pdata.YellowLyreShotCooldown = true
                if pdata.YellowLyreShot >= 10 then
                    player.FireDelay = player.MaxFireDelay * mod.AngelicLyreStats.Yellow.BurstDelayMult
                    pdata.YellowLyreShot = 0
                    if player:HasTrinket(mod.ITEM.TRINKET.BUTTON_MASHER) then
                        pdata.buttonMashActiveItem = getLyreActiveSlot(player, pdata)
                    end
                end
            end
        end
    end
end

function mod:angelicLyrePostFireKnife(player, knife, rng, kdata)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_R) then
        if not kdata.RedLyreShotIsQuaddening then
            --[[for i = -2.5, 7.5, 5 do
                local newBomb = player:FireBomb(bomb.Position, bomb.Velocity:Rotated(i), player)
                mod:GetEntityData(newBomb).RedLyreShotIsQuaddening = true
            end
            bomb.Velocity = bomb.Velocity:Rotated(-7.5)]]
        end
    end
end

function mod:lyreLocustUpdate(locust)
    local d, sprite = mod:GetEntityData(locust), locust:GetSprite()
    --Init for spawning other two locusts
    if locust.Coins == 0 and locust.Keys == 0 then
        locust.Keys = 1
        local redOne = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, locust.SubType, locust.Position, nilvector, locust.Player):ToFamiliar()
        redOne.Coins = 1
        redOne:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        redOne:Update()
        local yellowOne = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, locust.SubType, locust.Position, nilvector, locust.Player):ToFamiliar()
        yellowOne.Coins = 2
        yellowOne:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        yellowOne:Update()
    end
    if not d.init then
        d.init = true
        if locust.Coins == 1 then
            sprite:ReplaceSpritesheet(0, "gfx/familiar/locusts/ff/lyrered.png")
            sprite:LoadGraphics()
        elseif locust.Coins == 2 then
            sprite:ReplaceSpritesheet(0, "gfx/familiar/locusts/ff/lyreyellow.png")
            sprite:LoadGraphics()
        end
    end
	if locust.State == 0 then
		mod:GetEntityData(locust).madeStrum = nil
	end
end

function mod:lyreLocustDamage(player, locust, entity)
    local d = mod:GetEntityData(locust)
    local damageMult = 1/3
    if locust.Coins == 1 then
        damageMult = 1
    elseif locust.Coins == 2 then
        damageMult = 1/8
    end
    entity:TakeDamage(mod:getLocustDamage(locust, damageMult), DamageFlag.DAMAGE_NO_MODIFIERS, EntityRef(locust), 0)
    if not d.madeStrum then
        sfx:Play(mod.Sounds.AngelicHarpStrum, 0.1, 0, false, 1.5)
        d.madeStrum = true
    end
end

function mod:lyrePostFire(locust, sub, d)
    if locust.Coins == 1 then
        locust.Velocity = locust.Velocity * 0.25
    elseif locust.Coins == 2 then
        locust.Velocity = locust.Velocity * 2
    end
end

-- Couple fixes for Friend guns.
mod:AddCallback("POST_GUN_FIRE", function(_, gun, player, aim, ammoUsed, isHeld)
    local pdata = mod:GetEntityData(player)
    local redLyre = player:HasCollectible(mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_R) or (player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and pdata.ffsavedata.VoidedLyre == 2)

    if mod:GetFriendWeaponType(player) == WeaponType.WEAPON_BRIMSTONE or mod:GetFriendWeaponType(player) == WeaponType.WEAPON_TECH_X then
        if not pdata.BlueLyreShotCooldown then
            pdata.BlueLyreShot = pdata.BlueLyreShot or 0
            pdata.BlueLyreShot = (pdata.BlueLyreShot + 1) % 3
            pdata.BlueLyreShotCooldown = true
        end
    end

    local blueLyreTriShot = (player:HasCollectible(mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_B) or (player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and voidVal == 1)) and pdata.BlueLyreShot == 2

    if blueLyreTriShot then
        mod:HandleBlueLyreGuns(gun, player, aim, ammoUsed, isHeld)  -- flies away to different file
    end

    if (redLyre or blueLyreTriShot) and player:HasTrinket(mod.ITEM.TRINKET.BUTTON_MASHER) then
        pdata.buttonMashActiveItem = getLyreActiveSlot(player, pdata)
    end
end)