local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

--Ehhh, the other cards felt a bit too iffy to add so I'll just leave them in the sprite and that's it

local bal = {
    DraHeal = 3,
    DraCharge = 2,

    TriTimer = 85,
    TriBossPercent = 0.2,

    DanStagger = 5,
    DanFlat = 6,
    DanScale = 3.5,

    HaHoChance = 100,
    HaHoTransp = 0.2,

    DBDamage = 3,
    DBProcs = 3,
    DBHeal = 1,
}

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
    player:AddHearts(bal.DraHeal)
    local chosen = ActiveSlot.SLOT_PRIMARY
    for i=0,2 do
        local check = player:GetActiveItem(i)
        --local config = Isaac.GetItemConfig():GetCollectible(check)
        if check ~= 0 and player:NeedsCharge(i) then --Ignores special anyways
            chosen = i
            break
        end
    end
    player:AddActiveCharge(bal.DraCharge, chosen, true, false, false)
    sfx:Play(mod.Sounds.ShadowverseHeal, 1, 0, false, 1)
    local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, player.Position, Vector.Zero, player):ToEffect()
    poof.SpriteOffset = Vector(0,-40*player.SpriteScale.Y)
    poof:FollowParent(player)
    poof.DepthOffset = 50
    poof:Update()

    for i=-45,45,90 do
        local card = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, 0, player.Position, Vector(0, 2):Rotated(i), player)
    end
    mod:trySayAnnouncerLine(mod.Sounds.VACardShadowverseDraconicFervor, flags, 40)
end, mod.ITEM.CARD.DRACONIC_FERVOR)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
    local enemies = {}
    for _,entity in ipairs(Isaac.FindInRadius(player.Position, 1050, EntityPartition.ENEMY)) do
        if entity:ToNPC() and (not mod:isFriend(entity)) and entity:IsActiveEnemy() and entity:IsVulnerableEnemy()
        and not entity:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) and not mod:GetEntityData(entity).FFSentencedDuration then
            table.insert(enemies, entity)
        end
    end
    if #enemies > 0 then
        local num = (#enemies > 1 and 2) or 1
        local rng = player:GetCardRNG(mod.ITEM.CARD.TRIBUNAL_OF_GOOD_AND_EVIL)
        local results = mod:getSeveralDifferentNumbers(num, #enemies, rng)
        for key,chose in ipairs(results) do
            local count = 5
            if key > 1 then
                count = bal.TriTimer
            end
            local chosen = enemies[chose]
            local damage = -1
            if chosen:IsBoss() then
                damage = chosen.MaxHitPoints*bal.TriBossPercent
            end
            mod.AddSentenced(chosen, player, count, damage)
        end
    end
    mod:trySayAnnouncerLine(mod.Sounds.VACardShadowverseTribunalOfGoodAndEvil, flags, 20)
end, mod.ITEM.CARD.TRIBUNAL_OF_GOOD_AND_EVIL)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
    local rng = player:GetCardRNG(mod.ITEM.CARD.DANCE_OF_USURPATION)
    sfx:Play(mod.Sounds.ShadowverseSlash1, 1, 0, false, 1.3)
    local enemies = {}
    for _,entity in ipairs(Isaac.FindInRadius(player.Position, 1050, EntityPartition.ENEMY)) do
        if entity:ToNPC() and (not mod:isFriend(entity)) and entity:IsActiveEnemy() and entity:IsVulnerableEnemy()
        and not entity:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) then
            table.insert(enemies, entity:ToNPC())
        end
    end
    --shuffle time
    local realOrder = mod:getSeveralDifferentNumbers(#enemies, #enemies, rng)
    local level = math.ceil(game:GetLevel():GetAbsoluteStage()/2)
    local room = game:GetRoom()
    for key,num in ipairs(realOrder) do
        local enemy = enemies[num]
        mod.scheduleForUpdate(function()
            if mod:superExists(enemy) then
                enemy:TakeDamage(player.Damage+bal.DanFlat+bal.DanScale*level, 0, EntityRef(player), 0)
                local flip = (rng:RandomInt(2) == 0 and 1) or -1
                local slash = Isaac.Spawn(1000, EffectVariant.CLEAVER_SLASH, 0, enemy.Position+Vector(-60*flip,-12), Vector.Zero, player):ToEffect()
                slash.SpriteRotation = flip*90+mod:RandomInt(-35,35)
                slash.SpriteScale = Vector(0.5, 1.5)
                slash.Color = Color(1, 1, 1, 1, 0, 0, 0)
                slash:FollowParent(enemy)
                slash.DepthOffset = 100
                slash:Update()
                slash:Update()
                sfx:Play(mod.Sounds.ShadowverseSlash2, 0.66, 0, false, mod:RandomInt(80,120,rng)/100)
                mod:GetEntityData(enemy).electrumDeath = function(npc)
                    local pickup = Isaac.Spawn(5, 0, 4, room:FindFreePickupSpawnPosition(npc.Position, 0, false, false), Vector.Zero, player)
                    for i=1,4 do
                        local gold = Isaac.Spawn(1000, EffectVariant.COIN_PARTICLE, 0, enemy.Position, Vector(mod:RandomInt(1, 6, rng), 0):Rotated(rng:RandomInt(360)), player)
                    end
                end
            end
        end, bal.DanStagger*key)
    end
    mod:trySayAnnouncerLine(mod.Sounds.VACardShadowverseDanceOfUsurpation, flags, 20)
end, mod.ITEM.CARD.DANCE_OF_USURPATION)

local hauntedHouseActive
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
    hauntedHouseActive = true
    local rng = player:GetCardRNG(mod.ITEM.CARD.HAUNTED_HOUSE)
    local room = game:GetRoom()

    for i = 1, 30 do
		local vecX = rng:RandomFloat() * 2
		if rng:RandomInt(2) == 1 then
			vecX = vecX * -1
		end

		local side = -400 + rng:RandomInt(room:GetGridWidth()*40 + 650)

		local eff = Isaac.Spawn(1000, 138, 114, Vector(side, 30 + rng:RandomInt(room:GetGridHeight() * 40 + 120)), Vector(vecX, 0), player):ToEffect()
		mod:GetEntityData(eff).TargetOpacity = mod:RandomInt(20,70,rng)/100
        mod:GetEntityData(eff).CurrOpacity = 0
		eff:GetSprite():Stop()
		eff:GetSprite():SetFrame(rng:RandomInt(4))
		eff.Timeout = 1000
		eff:Update()
	end
    mod:trySayAnnouncerLine(mod.Sounds.VACardShadowverseHauntedHouse, flags, 20)
end, mod.ITEM.CARD.HAUNTED_HOUSE)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, e)
    local d = mod:GetEntityData(e)
    if e.SubType == 114 and d.CurrOpacity then
        e.Color = Color(e.Color.R,e.Color.G,e.Color.B,d.CurrOpacity)
        d.CurrOpacity = mod:Lerp(d.CurrOpacity, d.TargetOpacity, 0.08)
    end
end, EffectVariant.MIST)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    hauntedHouseActive = nil
end)

function mod:HauntedHouseDeathCheck(npc, d)
	if hauntedHouseActive then
		if not (npc.Type == mod.FFID.Tech and npc.Variant > 999) and not (npc:HasEntityFlags(EntityFlag.FLAG_NO_REWARD)
        or npc:HasEntityFlags(EntityFlag.FLAG_NO_DEATH_TRIGGER)) and not mod:isFriend(npc) and not npc:IsBoss() then
			local chance = bal.HaHoChance
            local rng = npc:GetDropRNG()
			if 1 == 1 or rng:RandomInt(100) < chance then
                local ghosty = Isaac.Spawn(npc.Type, npc.Variant, npc.SubType, npc.Position, Vector.Zero, npc):ToNPC()
				ghosty:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)
				ghosty:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				mod:GetEntityData(ghosty).temporaryFriendly = true
                ghosty:Update()
				ghosty:SetColor(Color(1, 1, 1, bal.HaHoTransp, 0.05, 0.05, 0.05), 999, 999, true, true)
                ghosty:Update()
			end
		end
	end
end

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
    local rng = player:GetCardRNG(mod.ITEM.CARD.DIRE_BOND)
    local dFlag = DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_IV_BAG | DamageFlag.DAMAGE_NOKILL
    player:TakeDamage(bal.DBDamage, dFlag, EntityRef(player), 0)
    local savedata = mod:GetEntityData(player).ffsavedata
    savedata.DireBondProcs = (savedata.DireBondProcs or 0) + bal.DBProcs

    sfx:Play(SoundEffect.SOUND_DEATH_BURST_LARGE, 1, 0, false, 1)
    sfx:Play(SoundEffect.SOUND_UNHOLY, 0.35, 0, false, 0.7)

    mod:trySayAnnouncerLine(mod.Sounds.VACardShadowverseDireBond, flags, 50)

    local splash = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 3, player.Position, Vector.Zero, player)
    for i=1,12 do
        local vel = Vector(1, 0):Rotated(30*i+mod:RandomInt(-15,15,rng)):Resized(mod:RandomInt(39, 55, rng)/5)+player.Velocity
        local poof = Isaac.Spawn(1000, mod.FF.WhiteTrailEffect.Var, mod.FF.WhiteTrailEffect.Sub, player.Position, vel, player):ToEffect()
        local pd = mod:GetEntityData(poof)
        poof.Color = Color(0, 0, 0, 1, 2, mod:RandomInt(1,4,rng)/100, mod:RandomInt(1,4,rng)/100)
        pd.TargetColor = Color(0, 0, 0, 1, mod:RandomInt(45,55,rng)/100, mod:RandomInt(1,4,rng)/100, mod:RandomInt(1,4,rng)/100)
        poof.Parent = player
        poof:SetTimeout(700)
        local size = mod:RandomInt(35,85,rng)/100
        poof.SpriteScale = Vector(size, size)
        pd.Deccel = 0.88
        pd.DontShrink = true
        pd.Timer = 25
        poof.SpriteOffset = Vector(0, -10)
        pd.ExtraFunc = function(e)
            e.Color = Color.Lerp(e.Color, pd.TargetColor, 0.2)

            if pd.Timer > 0 then
                pd.Timer = pd.Timer-1
            elseif not pd.GoForth then
                pd.GoForth = true
                pd.Deccel = nil
                pd.Chasing = true
            end
            if pd.GoForth then
                if pd.Chasing then
                    if e.Position:Distance(player.Position) < 15 then
                        pd.Chasing = nil
                        pd.DontShrink = nil
                        poof:SetTimeout(5)
                        pd.MaxTime = 5
                    end
                    e.Velocity = mod:Lerp(e.Velocity, (player.Position-e.Position):Resized(35), 0.17)
                else
                    e.Velocity = player.Position-e.Position
                end
            elseif pd.Timer < 17 and pd.DontShrink then
                pd.DontShrink = nil
                pd.MaxTime = 80
                poof:SetTimeout(80)
            end
        end
        poof:Update()
    end
    for i=1,6 do
        local vel = Vector(1, 0):Rotated(rng:RandomInt(360)):Resized(mod:RandomInt(25, 40, rng)/5)+player.Velocity
        local poof = Isaac.Spawn(1000, mod.FF.WhiteTrailEffect.Var, mod.FF.WhiteTrailEffect.Sub, player.Position, vel, player):ToEffect()
        local pd = mod:GetEntityData(poof)
        poof.Color = Color(0, 0, 0, 1, 2, mod:RandomInt(1,4,rng)/100, mod:RandomInt(1,4,rng)/100)
        pd.TargetColor = Color(0, 0, 0, 1, mod:RandomInt(45,55,rng)/100, mod:RandomInt(1,4,rng)/100, mod:RandomInt(1,4,rng)/100)
        poof.Parent = player
        poof:SetTimeout(700)
        local size = mod:RandomInt(15,45,rng)/100
        poof.SpriteScale = Vector(size, size)
        pd.Deccel = 0.83
        pd.DontShrink = true
        pd.Timer = 25
        poof.SpriteOffset = Vector(0, -10)
        pd.ExtraFunc = function(e)
            e.Color = Color.Lerp(e.Color, pd.TargetColor, 0.2)

            if pd.Timer > 0 then
                pd.Timer = pd.Timer-1
            elseif not pd.GoForth then
                pd.GoForth = true
                pd.Deccel = nil
                pd.Chasing = true
            end
            if pd.GoForth then
                if pd.Chasing then
                    if e.Position:Distance(player.Position) < 15 then
                        pd.Chasing = nil
                        pd.DontShrink = nil
                        poof:SetTimeout(5)
                        pd.MaxTime = 5
                    end
                    e.Velocity = mod:Lerp(e.Velocity, (player.Position-e.Position):Resized(35), 0.17)
                else
                    e.Velocity = player.Position-e.Position
                end
            elseif pd.Timer < 17 and pd.DontShrink then
                pd.DontShrink = nil
                pd.MaxTime = 80
                poof:SetTimeout(80)
            end
        end
        poof:Update()
    end
end, mod.ITEM.CARD.DIRE_BOND)

function mod:DireBondRoomClear(player, data)
    local d = data.ffsavedata
    if d.DireBondProcs and d.DireBondProcs > 0 then
        local rng = player:GetCardRNG(mod.ITEM.CARD.DIRE_BOND)
        local pool = game:GetItemPool()
        d.DireBondProcs = d.DireBondProcs-1

        player:AddCard(pool:GetCard(rng:GetSeed()))
        local subt = 0
        if player:GetEffectiveMaxHearts() > player:GetHearts() then
            player:AddHearts(1)
        else
            player:AddSoulHearts(1)
            subt = 4
        end
        sfx:Play(SoundEffect.SOUND_VAMP_GULP, 0.6, 0, false, 1)
        local heart = Isaac.Spawn(1000, 49, subt, player.Position, Vector.Zero, player):ToEffect()
        heart.SpriteOffset = Vector(0,-40*player.SpriteScale.Y)
        heart:FollowParent(player)
        heart.DepthOffset = 50
        heart:Update()
        sfx:Play(SoundEffect.SOUND_BOOK_PAGE_TURN_12, 1, 0, false, 1)

        for i=1,10 do
            local vel = Vector(1, 0):Rotated(rng:RandomInt(360)):Resized(mod:RandomInt(32, 47, rng)/5)+player.Velocity
            local poof = Isaac.Spawn(1000, mod.FF.WhiteTrailEffect.Var, mod.FF.WhiteTrailEffect.Sub, player.Position, vel, player):ToEffect()
            local pd = mod:GetEntityData(poof)
            if subt == 0 then
                poof.Color = Color(0, 0, 0, 1, mod:RandomInt(45,55,rng)/100, mod:RandomInt(1,4,rng)/100, mod:RandomInt(1,4,rng)/100)
            else
                poof.Color = Color(0, 0, 0, 1, mod:RandomInt(20,24,rng)/100, mod:RandomInt(20,24,rng)/100, mod:RandomInt(38,48,rng)/100)
            end
            poof.Parent = player
            poof:SetTimeout(15+mod:RandomInt(10,20,rng))
            local size = mod:RandomInt(35,85,rng)/100
            poof.SpriteScale = Vector(size, size)
            pd.Deccel = 0.9
            poof.SpriteOffset = Vector(0, -10)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
    local rng = player:GetCardRNG(mod.ITEM.CARD.ELF_SONG)
    for i=-1,1,2 do
        local fairy = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, mod.ITEM.FAMILIAR.FAIRY_FLY_2, 0, player.Position, Vector(3*i, 0), player):ToFamiliar()
        fairy.Player = player
        fairy.Parent = player
        local fly = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, 0, player.Position, Vector.Zero, player):ToFamiliar()
    end
    local hasItem = player:HasCollectible(CollectibleType.COLLECTIBLE_HIVE_MIND)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_HIVE_MIND, UseFlag.USE_NOANIM, -1, 0)
    if not hasItem then
        player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_HIVE_MIND))
    end

    for i=-1,1 do
        local note = Isaac.Spawn(1000, mod.FF.LyreParticle.Var, mod.FF.LyreParticle.Sub, player.Position+Vector(5,2*i)*i, Vector(2*i, 0), player):ToEffect()
        mod:GetEntityData(note).note = (mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_Y - mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_R + 1) % 3
        note:Update()
    end
    sfx:Play(mod.Sounds.AngelicHarpStrum, 1, 0, false, 1)
    mod:trySayAnnouncerLine(mod.Sounds.VACardShadowverseElfSong, flags, 20)
end, mod.ITEM.CARD.ELF_SONG)