local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

--Code is a mishmash of a clotty trinket I made that I don't fully remember about

function mod:ProjectileTrinketUpdate(player)
    if player:HasTrinket(mod.ITEM.TRINKET.PROJECTILE_TRINKET) then
        local queuedItem = player.QueuedItem
		if queuedItem.Item ~= nil and queuedItem.Item:IsTrinket() and queuedItem.Item.ID == mod.ITEM.TRINKET.PROJECTILE_TRINKET then
            game:GetHUD():ShowItemText("Projectile", "Should've dodged it!")
		end
		player:TryRemoveTrinket(mod.ITEM.TRINKET.PROJECTILE_TRINKET)
    end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.TRINKET.PROJECTILE_TRINKET, mod.ProjectileTrinketUpdate)

function mod:ProjectileTrinketColl(trinket, coll)
    if mod:GetRealTrinketId(trinket.SubType) == mod.ITEM.TRINKET.PROJECTILE_TRINKET and coll then
        local d = mod:GetEntityData(trinket)
        if coll:ToPlayer() and not d.DoNotCollideWithPlayer then
            local player = coll:ToPlayer()
            if player:CanPickupItem() and not d.SpawnedProjectile then
                mod.scheduleForUpdate(function()
                    if mod:IsGoldTrinket(trinket.SubType) then
                        player:TakeDamage(2, 0, EntityRef(trinket), 0)
                    else
                        player:TakeDamage(1, 0, EntityRef(trinket), 0)
                    end
                    local proj = Isaac.Spawn(9, 0, 0, trinket.Position, trinket.Velocity, trinket):ToProjectile()
                    proj.Scale = 0.6
                    proj:Die()
                end, 1)
                d.SpawnedProjectile = true
                sfx:Play(SoundEffect.SOUND_TEARIMPACTS, 1, 0, false, 1)
            end
        --elseif coll:ToNPC() then
        --doesn't trigger
        else
            return true
        end
    end
end

function mod:ProjectileTrinketTrinketUpdate(trinket, d)
	if mod:GetRealTrinketId(trinket.SubType) == mod.ITEM.TRINKET.PROJECTILE_TRINKET then
        local mult = (mod:IsGoldTrinket(trinket.SubType) and 2) or 1

        if d.Velocity then
            trinket.Velocity = d.Velocity
        end

        if d.Height then
            local accel = 0.1
            d.ZVel = (d.ZVel or 0)

            trinket:GetSprite():Play("Idle")
            local offset = d.Height+d.ZVel+accel/2
            d.Height = offset
            trinket.PositionOffset = Vector(0,d.Height)
            d.ZVel = d.ZVel+accel

            if d.Height >= 10 then
                d.Kill = true
            end
        end

        if d.Friendly then
            local capsule = trinket:GetCollisionCapsule()
            for _,npc in ipairs(Isaac.FindInCapsule(capsule, EntityPartition.ENEMY)) do
                if npc:IsVulnerableEnemy() and not mod:isFriend(npc) then
                    npc:TakeDamage((d.Damage or 5), 0, EntityRef(trinket), 0) --Don't multiply by mult, that's already done from the drumstick
                    d.Kill = true
                    break
                end
            end
        end

		if trinket:CollidesWithGrid() or d.Kill then
            sfx:Play(SoundEffect.SOUND_TEARIMPACTS, 1, 0, false, 1)
            local splat = Isaac.Spawn(1000, EffectVariant.BULLET_POOF, 0, trinket.Position, Vector.Zero, trinket)
            splat.SpriteOffset = trinket.PositionOffset+Vector(0,-10)
            splat.SpriteScale = Vector(0.6, 0.6)
            trinket:Remove()
        end
	end
end

function mod:DelightfulDrumstickTrinketInit(trinket)
    if mod:GetRealTrinketId(trinket.SubType) == mod.ITEM.TRINKET.DELIGHTFUL_DRUMSTICK then
        local sprite = trinket:GetSprite()
        local d = mod:GetEntityData(trinket)
        if sprite:GetFilename() == "gfx/005.350_Trinket.anm2" then
            local appear = false
            if sprite:IsPlaying("Appear") then
                appear = true
            end
            sprite:Load("gfx/items/trinkets/trinket_delightful_drumstick.anm2", true)
            if appear == true then
                sprite:Play("Appear", true)
                d.State = "Drop"
            else
                sprite:Play("Idle", true)
                d.State = "Idle"
            end
            d.StateFrame = 0
            sprite:LoadGraphics()
            sprite:Update()
        end
    end
end

function mod:DelightfulDrumstickTrinketUpdate(trinket, d)
    if mod:GetRealTrinketId(trinket.SubType) == mod.ITEM.TRINKET.DELIGHTFUL_DRUMSTICK then
		local sprite = trinket:GetSprite()
        local rng = trinket:GetDropRNG()
        local bff

        local isBlasphemous = mod:IsPickupTrinketBlasphemous(trinket)
        local mult = (mod:IsGoldTrinket(trinket.SubType) and 2) or 1
        if mod.anyPlayerHas(CollectibleType.COLLECTIBLE_MOMS_BOX) then
            mult = mult+1
        end
        if mod.anyPlayerHas(CollectibleType.COLLECTIBLE_BFFS) then
            mult = mult+1
            if trinket.SpriteScale == Vector.One then
                trinket.SpriteScale = Vector(1.5, 1.5)
            end
            bff = true
        end
        local bffmult = (bff and 2) or 1

		if sprite:GetFilename() == "gfx/005.350_Trinket.anm2" then
			local appear = false
			if sprite:IsPlaying("Appear") then
				appear = true
			end
			sprite:Load("gfx/items/trinkets/trinket_delightful_drumstick.anm2", true)
			if appear == true then
				sprite:Play("Appear", true)
				d.State = "Drop"
			else
				sprite:Play("Idle", true)
				d.State = "Idle"
			end
            d.StateFrame = 0
			sprite:LoadGraphics()
			sprite:Update()
            trinket.Visible = false
            mod.scheduleForUpdate(function()
                trinket.Visible = true
            end, 3)
        else
            d.StateFrame = d.StateFrame+1
        end

        if not d.ClosestPlayer or not d.ClosestPlayer:Exists() then
            d.ClosestPlayer = mod:getClosestPlayer(trinket.Position, 999)
        end

        sprite.FlipX = trinket.Velocity.X < 0
		
		if d.State == "Idle" then
            if rng:RandomInt(7) == 0 then
                d.State = "Attack"
            else
                d.State = "Move"
                d.Velocity = (mod:FindRandomVisiblePosition(trinket, trinket.Position, 3, nil, 80)-trinket.Position):Resized(9)
                d.Accel = false
            end
            mod:spritePlay(sprite, "Idle")
        elseif d.State == "Move" then
            if sprite:IsFinished("Hop") or sprite:GetFrame() > 14 then
                d.State = "Attack"
            else
                mod:spritePlay(sprite, "Hop")
            end

            if not d.Accel then
                if trinket.Velocity:Length() < 8 then
                    trinket.Velocity = mod:Lerp(trinket.Velocity, d.Velocity, 0.05)
                else
                    d.Accel = true
                end
            else
                trinket.Velocity = mod:Lerp(trinket.Velocity, Vector.Zero, 0.05)
            end
        elseif d.State == "Attack" then
            if sprite:IsFinished("Attack") then
                d.State = "Idle"
                d.StateFrame = 0
            elseif sprite:IsEventTriggered("TinyShoot") then
                local id = trinket.SubType-mod.ITEM.TRINKET.DELIGHTFUL_DRUMSTICK
                for i=90,360,90 do
                    --[[local proj = Isaac.Spawn(5, 350, mod.ITEM.TRINKET.PROJECTILE_TRINKET+id, trinket.Position, Vector(0,11):Rotated(i), trinket):ToPickup()
                    local pData = mod:GetEntityData(proj)
                    pData.Velocity = Vector(0,11):Rotated(i)
                    pData.Height = -10
                    pData.DontPickUpTrinket = true
                    pData.Friendly = true
                    if d.ClosestPlayer and d.ClosestPlayer:Exists() then
                        pData.Damage = d.ClosestPlayer:ToPlayer().Damage
                    else
                        pData.Damage = 5
                    end
                    pData.Damage = (pData.Damage+5)*mult
                    if bff then
                        proj.SpriteScale = Vector(1.5, 1.5)
                    end
                    proj.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
                    proj:SetShadowSize(0.1)
                    proj:Update()]]
                    local proj = Isaac.Spawn(2, 1, 0, trinket.Position, Vector(0, 11):Rotated(i), trinket):ToTear()
                    proj.Scale = 0.75
                    proj.Height = -10
                    proj.FallingAcceleration = -0.03
                    local dam
                    if d.ClosestPlayer and d.ClosestPlayer:Exists() then
                        dam = d.ClosestPlayer:ToPlayer().Damage
                        if d.ClosestPlayer:ToPlayer():HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
                            proj:AddTearFlags(TearFlags.TEAR_HOMING)
                        end
                    else
                        dam = 5
                    end
                    proj.CollisionDamage = (dam+1.5)*mult*bffmult
                    if isBlasphemous then
                        proj.CollisionDamage = proj.CollisionDamage + 1
                    end
                end

                local effect = Isaac.Spawn(1000, 2, 1, trinket.Position - Vector(0,10), Vector.Zero, trinket)
                effect.DepthOffset = trinket.Position.Y * 1.25
                sfx:Play(SoundEffect.SOUND_ANIMAL_SQUISH, 0.5, 0, false, 1.5)
            else
                mod:spritePlay(sprite, "Attack")
            end
            trinket.Velocity = mod:Lerp(trinket.Velocity, Vector.Zero, 0.1)
		elseif d.State == "Drop" then
			if sprite:IsPlaying("Idle") or sprite:IsFinished("Idle") then
				d.State = "Idle"
			end
		end

        if trinket.FrameCount % 8 == 0 then
            local capsule = trinket:GetCollisionCapsule()
            local collisionDamage = (d.Damage or 5)*mult*bffmult
            if isBlasphemous then
                collisionDamage = collisionDamage + 1
            end
            for _,npc in ipairs(Isaac.FindInCapsule(capsule, EntityPartition.ENEMY)) do
                if npc:IsVulnerableEnemy() and not mod:isFriend(npc) then
                    npc:TakeDamage(collisionDamage, 0, EntityRef(trinket), 0)
                end
            end
        end

        if trinket.FrameCount % 16 == 0 then
            local splat = Isaac.Spawn(1000, 7, 0, trinket.Position, Vector.Zero, trinket)
            splat.SpriteScale = Vector(0.5,0.5)
            splat.Color = Color(1, 0, 0.7, 1, 0.4, 0.2, 0.4)
        end
    end
end

function mod:DelightfulDrumstickFire(player)
	local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.DELIGHTFUL_DRUMSTICK)
	local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.DELIGHTFUL_DRUMSTICK)
	local chance = 15+10*mult+mod.XalumLuckBonus(player.Luck, 15, 0.15)*100
	if rng:RandomInt(100) < chance then
        for i=90,360,90 do
            local tear = Isaac.Spawn(2, 1, 0, player.Position, Vector(0,11):Rotated(i), player):ToTear()
            tear.CollisionDamage = player.Damage*mult
		end
	end
end

mod:AddTrinketCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE, mod.ITEM.TRINKET.DELIGHTFUL_DRUMSTICK, function(_, player, dir, amount, owner, params)
	if player:HasTrinket(mod.ITEM.TRINKET.DELIGHTFUL_DRUMSTICK) then
		mod:DelightfulDrumstickFire(player)
	end
end)

--Reused from puzzle keys
local rerollingBlacklisted = {}
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function()
    for _,proj in ipairs(rerollingBlacklisted) do
        proj[1]:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, proj[2])
        proj[1]:GetSprite():SetLastFrame()
        --proj:GetData() = proj[3]
    end

    rerollingBlacklisted = {}
end, CollectibleType.COLLECTIBLE_D20)

mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, function()
    rerollingBlacklisted = {}
    for _,proj in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET)) do
        if mod:GetRealTrinketId(proj.SubType) == mod.ITEM.TRINKET.PROJECTILE_TRINKET then
            rerollingBlacklisted[#rerollingBlacklisted + 1] = {proj, proj.SubType}
            --mod:makeCopiedTable(proj:GetData()
        end
    end
end, CollectibleType.COLLECTIBLE_D20)

local puzzleKeyBadCards = {
    Card.CARD_ACE_OF_CLUBS,
    Card.CARD_ACE_OF_HEARTS,
    Card.CARD_ACE_OF_SPADES,
    Card.CARD_ACE_OF_DIAMONDS,
    Card.RUNE_BLACK
}

local function fixRerolledProjTrinkets()
    for _,proj in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET)) do
        if mod:GetRealTrinketId(proj.SubType) == mod.ITEM.TRINKET.PROJECTILE_TRINKET then
            for _, pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
                if pickup.Variant ~= proj.Variant
                and pickup.Position.X == proj.Position.X and pickup.Position.Y == proj.Position.Y then
                    pickup:Remove()
                end
            end

            for _, familiar in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR)) do
                if (familiar.Variant == FamiliarVariant.BLUE_FLY or familiar.Variant == FamiliarVariant.BLUE_SPIDER)
                and (familiar.Position.X == proj.Position.X and familiar.Position.Y == proj.Position.Y) then
                    familiar:Remove()
                end
            end

            local new = Isaac.Spawn(proj.Type, proj.Variant, proj.SubType, proj.Position, proj.Velocity, proj.SpawnerEntity)
            new.Parent = proj.Parent
            new:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            new:GetSprite():SetLastFrame()
            local d = new:GetData()
            for key,entry in pairs(proj:GetData()) do
                d[key] = entry
            end
        end
    end
end

for _, card in ipairs(puzzleKeyBadCards) do
    mod:AddCallback(ModCallbacks.MC_USE_CARD, fixRerolledProjTrinkets, card)
end

function mod:ProjectileTrinketNewRoom()
    for _,trink in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET)) do
        if mod:GetRealTrinketId(trink.SubType) == mod.ITEM.TRINKET.PROJECTILE_TRINKET then
            trink:Remove()
        end
    end
end

mod:AddCallback(TearFlagsLib.Callback.PRE_SWING_CLUB, function(_, entity, player)
	if player:HasTrinket(mod.ITEM.TRINKET.DELIGHTFUL_DRUMSTICK) then
		local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.DELIGHTFUL_DRUMSTICK)
		local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.DELIGHTFUL_DRUMSTICK)
		local chance = 15+10*mult+mod.XalumLuckBonus(player.Luck, 15, 0.15)*100

		if rng:RandomInt(100) < chance then
			for i=90,360,90 do
                local tear = Isaac.Spawn(2, 1, 0, player.Position, Vector(0,11):Rotated(i), player):ToTear()
                tear.CollisionDamage = player.Damage*mult
            end
		end
	end
end)