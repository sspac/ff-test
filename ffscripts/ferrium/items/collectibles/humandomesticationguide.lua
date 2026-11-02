local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

local hBal = {
    SnareRange = 200,
    SnareKeepClose = 120,
}

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, item, rng, player, useflags, activeSlot)
    local d = mod:GetEntityData(player).ffsavedata.RunEffects
    d.HDGFlorets = d.HDGFlorets or {}
    local dist = hBal.SnareRange+10
    local target
    for _,enemy in ipairs(Isaac.FindInRadius(player.Position, hBal.SnareRange, EntityPartition.ENEMY)) do
        local d2 = mod:GetEntityData(enemy)
        if enemy:IsActiveEnemy() and not (mod:isFriend(enemy) or enemy:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) or d2.AffiniSnares or enemy:IsBoss())
        and enemy.Position:Distance(player.Position) < dist  and not (enemy.Type == EntityType.ENTITY_THE_HAUNT and enemy.Variant == 10 and
        enemy.SpawnerType and enemy.SpawnerType == EntityType.ENTITY_THE_HAUNT) then
            dist = player.Position:Distance(enemy.Position)
            target = enemy
        end
    end

    if target then
        local d2 = mod:GetEntityData(target)
        local dummyeffect = mod:AddDummyEffect(player, Vector(0,10))
        --dummyeffect:AddCharmed(EntityRef(player), -1)
        dummyeffect:Update()
        local vine = Isaac.Spawn(mod.FF.SweetRedVine.ID, mod.FF.SweetRedVine.Var, mod.FF.SweetRedVine.Sub, player.Position, Vector.Zero, player):ToNPC()
        vine:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        vine:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_DEATH_TRIGGER | EntityFlag.FLAG_NO_REWARD)
        vine.Parent = dummyeffect
        vine.Target = target
        mod:GetEntityData(vine).HDGVine = {dummyeffect, target}
        --vine:AddCharmed(EntityRef(player), -1)
        for i=1,10 do
            vine:Update()
        end

        d2.HDGSnareKeepClose = hBal.SnareKeepClose
        d2.HDGSetSnareLength = hBal.SnareRange
        d2.HDGAffiniSnares = d2.HDGAffiniSnares or {}
        d2.HDGAffiniSnares[player.InitSeed] = player
        table.insert(d.HDGFlorets, {Vine = vine, Enemy = target, Dummy = dummyeffect, ID = {ID = target.Type, Var = target.Variant, Sub = target.SubType}})

        target:AddCharmed(EntityRef(player), -1)

        if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
            local wisp = Isaac.Spawn(3, FamiliarVariant.WISP, mod.ITEM.COLLECTIBLE.HUMAN_DOMESTICATION_GUIDE, target.Position, Vector.Zero, target):ToFamiliar()
            wisp.Player = player
            wisp.Target = target
        end

        sfx:Play(SoundEffect.SOUND_WHIP, 0.65, 0, false, 1.3)
        return true
    else
        --[[local charge = player:GetActiveCharge(activeSlot) + player:GetBatteryCharge(activeSlot)
        mod.scheduleForUpdate(function()
            if player:GetActiveItem(activeSlot) == mod.ITEM.COLLECTIBLE.HUMAN_DOMESTICATION_GUIDE then
                player:SetActiveCharge(charge, activeSlot)
            end
        end, 0)]]
        return {Discharge = false, Remove = false, ShowAnim = true}
    end
end, mod.ITEM.COLLECTIBLE.HUMAN_DOMESTICATION_GUIDE)

function mod:HumanDomesticationGuideUpdate(player, da)
    local d = da.ffsavedata.RunEffects
    if d.HDGFlorets then
        local real
        for id,entry in pairs(d.HDGFlorets) do
			if entry.Enemy and not mod:superExists(entry.Enemy) then
				if entry.Vine and mod:superExists(entry.Vine) then
					entry.Vine:Kill()
				end
				if entry.Dummy and entry.Dummy:Exists() then
					entry.Dummy:Remove()
				end
                local battery = player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY)
                local sound
                for i=0,2 do
                    if player:GetActiveItem(i) == mod.ITEM.COLLECTIBLE.HUMAN_DOMESTICATION_GUIDE then
                        local prevCharge = player:GetActiveCharge(i)
                        local next = math.min((battery and 2) or 1, player:GetActiveCharge(i)+1)
                        if next > prevCharge then
                            sound = true
                        end
                        player:SetActiveCharge(next, i)
                    end
                end
                if sound then
                    sfx:Play(SoundEffect.SOUND_BATTERYCHARGE, 1, 0, false, 1)
                end
				d.HDGFlorets[id] = nil
                local d2 = mod:GetEntityData(entry.Enemy)
                d2.HDGSnareKeepClose = nil
                d2.HDGSetSnareLength = nil
                d2.HDGAffiniSnares = nil

                if player:HasTrinket(mod.ITEM.ROCK.ELECTRUM) and entry.Enemy.Position then
                    local rng2 = player:GetTrinketRNG(mod.ITEM.ROCK.ELECTRUM)
                    local mult = mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.ELECTRUM)
                    mod:alternateElectrumShock(player, rng2, player.Damage*mult+9, entry.Enemy.Position, 3)
                end
                if mod:playerIsBelialMode(player) and entry.Enemy.Position then
                    local level = game:GetLevel():GetAbsoluteStage()
                    local explosion = Isaac.Spawn(1000, 144, 1, entry.Enemy.Position, Vector.Zero, player):ToEffect()
			        sfx:Play(SoundEffect.SOUND_DEMON_HIT, 0.65, 0, false, mod:RandomInt(110,125,player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE))/100)
                    explosion.CollisionDamage = player.Damage+10*level
                end
			elseif entry.Enemy then
                local d2 = mod:GetEntityData(entry.Enemy)
                if not d2.HDGAffiniSnares or not d2.HDGAffiniSnares[player.InitSeed] then
                    if entry.Vine and mod:superExists(entry.Vine) then
                        entry.Vine:Kill()
                    end
                    if entry.Dummy and entry.Dummy:Exists() then
                        entry.Dummy:Remove()
                    end
                end
                real = true
            end
		end

        if not real then
            d.HDGFlorets = nil
        end
    end
end

function mod:HumanDomesticationGuideFloretCheck(player, d)
    local sd = d.ffsavedata.RunEffects
    if sd.HDGFlorets then
        local check
        for _,enemy in ipairs(Isaac.FindInRadius(player.Position, 20, EntityPartition.ENEMY)) do
            if mod:isFriend(enemy) then
                for id,entry in pairs(sd.HDGFlorets) do
                    if entry.ID then
                        if enemy.Type == entry.ID.ID and enemy.Variant == entry.ID.Var and enemy.SubType == entry.ID.Sub then
                            check = true
                            entry.Enemy = enemy
                        end
                    end
                end
            end
        end
        if check then
            mod:HumanDomesticationGuideNewRoom(player, d)
        end
    end
end

function mod:HumanDomesticationGuideNewRoom(player, da)
    local d = da.ffsavedata.RunEffects
    if d.HDGFlorets then
        local real
        for id,entry in pairs(d.HDGFlorets) do
			if entry.Enemy and mod:superExists(entry.Enemy) then
                local target = entry.Enemy
                real = true
				if entry.Vine and mod:superExists(entry.Vine) then
					entry.Vine:Remove()
				end
				if entry.Dummy and entry.Dummy:Exists() then
					entry.Dummy:Remove()
				end
                
                if not (target:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) or target.Type == EntityType.ENTITY_EYE) then
                    local d2 = mod:GetEntityData(target)
                    local dummyeffect = mod:AddDummyEffect(player, Vector(0,10))
                    dummyeffect:Update()
                    local vine = Isaac.Spawn(mod.FF.SweetRedVine.ID, mod.FF.SweetRedVine.Var, mod.FF.SweetRedVine.Sub, player.Position, Vector.Zero, player):ToNPC()
                    vine:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    vine:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_DEATH_TRIGGER | EntityFlag.FLAG_NO_REWARD)
                    vine.Parent = dummyeffect
                    vine.Target = target
                    mod:GetEntityData(vine).HDGVine = {dummyeffect, target}
                    for i=1,10 do
                        vine:Update()
                    end
                    entry.Vine = vine
                    entry.Dummy = dummyeffect

                    d2.HDGSnareKeepClose = hBal.SnareKeepClose
                    d2.HDGSetSnareLength = hBal.SnareRange
                    d2.HDGAffiniSnares = d2.HDGAffiniSnares or {}
                    d2.HDGAffiniSnares[player.InitSeed] = player
                end
			else
                d.HDGFlorets[id] = nil
            end
		end

        if not real then
            d.HDGFlorets = nil
        end
    end
end

function mod:HumanDomesticationGuideOnheal(player, key, hp)
	if hp > 0 and game:GetFrameCount() <= 10 then return end
	local data = mod:GetEntityData(player)
    local ffsavedata = data.ffsavedata
    if not ffsavedata then return end
    local d = ffsavedata.RunEffects
    if d.HDGFlorets then
        for id,entry in pairs(d.HDGFlorets) do
            if entry.Enemy and mod:superExists(entry.Enemy) and entry.Enemy.HitPoints < entry.Enemy.MaxHitPoints then
                entry.Enemy.HitPoints = entry.Enemy.MaxHitPoints
                local poof = Isaac.Spawn(1000, 49, 0, entry.Enemy.Position, Vector.Zero, entry.Enemy):ToEffect()
                poof.DepthOffset = 800
                if REPENTOGON then
                    local sprite = entry.Enemy:GetSprite()
                    local over = sprite:GetNullFrame("OverlayEffect")
                    local off = Vector(0,-40*entry.Enemy.SpriteScale.Y)
                    if over then
                        off = over:GetPos()*entry.Enemy.SpriteScale
                    end
                    poof.SpriteOffset = off
                else
                    poof.SpriteOffset = Vector(0,-40*entry.Enemy.SpriteScale.Y)
                end
                poof:FollowParent(entry.Enemy)
                poof:Update()
            end
        end
    end
end
mod:AddCallback(CustomHealthAPI.Enums.Callbacks.POST_ADD_HEALTH, mod.HumanDomesticationGuideOnheal)

function mod:HumanDomesticationGuideRoomClear(player, da)
    local d = da.ffsavedata.RunEffects
    if not d.HDGFlorets or #d.HDGFlorets == 0 then
        local battery = player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY)
        local sound
        for i=0,2 do
            if player:GetActiveItem(i) == mod.ITEM.COLLECTIBLE.HUMAN_DOMESTICATION_GUIDE then
                local prevCharge = player:GetActiveCharge(i)
                local next = math.min((battery and 2) or 1, player:GetActiveCharge(i)+1)
                if next > prevCharge then
                    sound = true
                end
                player:SetActiveCharge(next, i)
            end
        end
        if sound then
            sfx:Play(SoundEffect.SOUND_BATTERYCHARGE, 1, 0, false, 1)
        end
    end
end

--[[mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, npc)
    if npc.Variant == mod.FF.SweetRedVine.Var and npc.SubType == mod.FF.SweetRedVine.Sub then
        local room = game:GetRoom()
		local isPaused = game:IsPaused()
		local isReflected = (room:GetRenderMode() == RenderMode.RENDER_WATER_REFLECT)
		if not (isPaused or isReflected) then
            local d = mod:GetEntityData(npc)
            if d.HDGVine then
                npc.Parent = d.HDGVine[1]
                npc.Target = d.HDGVine[2]
            end
        end
    end
end, mod.FF.SweetRedVine.ID)]]

function mod:HumanDomesticationGuideWisp(wisp)
    if mod:superExists(wisp.Target) then
        local d = mod:GetEntityData(wisp)
        d.angle = d.angle or 0
        local targPos = wisp.Target.Position+Vector(wisp.Target.Size+35,0):Rotated(d.angle)
	    wisp.Velocity = targPos-wisp.Position
        d.angle = d.angle+2
    else
        wisp:Kill()
    end
end