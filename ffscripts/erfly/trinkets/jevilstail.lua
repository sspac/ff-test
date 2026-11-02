local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

mod.JevilText = {
    {Main = "Noisy!",                   Sub = "It's just foley!"},
    {Main = "Your FOEs felt at ease.",  Sub = "Their defense dropped!"},
    {Main = "Awkward!",                 Sub = "Your FOEs will hurt you rapidly!"},
    {Main = "Tranquil!",                Sub = "Your defense raised!"},
    {Main = "What!",                    Sub = "It's just a useless fly!"},
    {Main = "Warm!",                    Sub = "It felt comforting!"},
    {Main = "Dizzy!",                   Sub = "Your HP got jumbled up!"},
    {Main = "Careful!",                 Sub = "Your FOEs got powered up!"},
    {Main = "Fiendish!",                Sub = "A perfect 10!"},
}

function mod:jevilstailNewRoom()
    mod.activeJevilEffects = {}
end

function mod:jevilstailPlayerNewRoom(player, d, savedata)
    local room = game:GetRoom()
	local isImage = player:GetPlayerType() == FiendFolio.PLAYER.IMAGE
	local hasJevilstail = player:HasTrinket(mod.ITEM.TRINKET.JEVILSTAIL)
    if not room:IsClear() or isImage then
        if hasJevilstail or isImage then
            if not savedata.jevilsTail then
                savedata.jevilsTail = 0
            end
			if isImage then
				mod.activeJevilEffects[0] = true
				mod.activeJevilEffects[4] = true
			end
			if hasJevilstail then
				for i = 1, math.floor(player:GetTrinketMultiplier(mod.ITEM.TRINKET.JEVILSTAIL)) do
					mod.activeJevilEffects[(savedata.jevilsTail - 1 + i) % 9] = true
				end
			end
        else
            d.jevilActive = nil
        end
        if savedata and savedata.jevilsTail then
            savedata.jevilsTail = ((savedata.jevilsTail + math.max(1,math.floor(player:GetTrinketMultiplier(mod.ITEM.TRINKET.JEVILSTAIL)))) % 9)
            --print(savedata.jevilsTail)
        end
    end
end

mod:AddCallback(mod.CALLBACK.FF_POST_START_GREED_WAVE, function(_, waveNumber, isBossWave)
    mod.activeJevilEffects = {}
end)

mod:AddCallback(mod.CALLBACK.FF_PLAYER_POST_START_GREED_WAVE, function(_, player, d, waveNumber, isBossWave)
    if d and d.ffsavedata then
        local savedata = d.ffsavedata
		local isImage = player:GetPlayerType() == FiendFolio.PLAYER.IMAGE
		local hasJevilstail = player:HasTrinket(mod.ITEM.TRINKET.JEVILSTAIL)
        if hasJevilstail or isImage then
            if not savedata.jevilsTail then
                savedata.jevilsTail = 0
            end
			if isImage then
				mod.activeJevilEffects[0] = true
				mod.activeJevilEffects[4] = true
			end
			if hasJevilstail then
				for i = 1, math.floor(player:GetTrinketMultiplier(mod.ITEM.TRINKET.JEVILSTAIL)) do
					mod.activeJevilEffects[(savedata.jevilsTail - 1 + i) % 9] = true
				end
            end
        else
            d.jevilActive = nil
        end
        if savedata and savedata.jevilsTail then
            savedata.jevilsTail = ((savedata.jevilsTail + math.max(1,math.floor(player:GetTrinketMultiplier(mod.ITEM.TRINKET.JEVILSTAIL)))) % 9)
            --print(savedata.jevilsTail)
        end
    end
end)

mod:AddCallback(mod.CALLBACK.FF_POST_PLAYER_POST_START_GREED_WAVE, function(_, waveNumber, isBossWave)
    mod:jevilstailHandleActiveEffects()
end)

function mod:jevilstailHandleActiveEffects()
    if mod.activeJevilEffects then
        --Now do the effects
        if mod.activeJevilEffects[0] then
            --Funny random noises
            sfx:Play(mod.Sounds.SlideWhistle, 1, 0, false, math.random(80,120)/100)
        end
        if mod.activeJevilEffects[4] then
            --Useless fly
            local room = game:GetRoom()
            local fly = Isaac.Spawn(13, 0, 0, room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0) + RandomVector(), nilvector, nil)
            sfx:Play(mod.Sounds.CrowdCheer, 2, 0, false, 1)
            for i = 90, 360, 90 do
                local arrow = Isaac.Spawn(1000, mod.FF.AwesomePointingArrow.Var, mod.FF.AwesomePointingArrow.Sub, fly.Position, nilvector, nil):ToEffect()
                arrow:ToEffect():FollowParent(fly)
                arrow.SpriteRotation = i
                if i == 90 and PlayerManager.AnyoneIsPlayerType(FiendFolio.PLAYER.IMAGE) then
                    arrow.State = 5
                end
                arrow:Update()
            end
        end

        --Player Related Effects
        local players = Isaac.FindByType(1, 0, -1, false, false)
        for _, player in ipairs(players) do
            player = player:ToPlayer()
            if mod.activeJevilEffects[1] then
                player:AnimateHappy()
            end
            if mod.activeJevilEffects[2] then
                player:AnimateSad()
            end
            if mod.activeJevilEffects[3] then
                --Wafer
                player:UsePill(PillEffect.PILLEFFECT_PERCS, 1, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
            end
            if mod.activeJevilEffects[5] then
                --Restore half heart
                player:AddHearts(1)
                local heart = Isaac.Spawn(1000,49,0,player.Position,nilvector,nil):ToEffect()
                heart.SpriteOffset = Vector(0, -20)
                heart:Update()
                sfx:Play(SoundEffect.SOUND_VAMP_GULP, 1, 0, false, 1)
            end
            if mod.activeJevilEffects[6] then
                --Scramble health
                mod:scramblePlayerHealth(player)
                sfx:Play(SoundEffect.SOUND_COIN_SLOT, 1, 0, false, 1)
            end
            if mod.activeJevilEffects[7] then
                --Addicted pill
                player:UsePill(PillEffect.PILLEFFECT_ADDICTED, 1, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
            end
            if mod.activeJevilEffects[8] then
                --Free immoral heart
                mod:TrySpawnHeart(
                    {
                        {mod.PICKUP.VARIANT.IMMORAL_HEART, 0},
                        {mod.PICKUP.VARIANT.HALF_BLACK_HEART, 0}
                    },
                    player.Position, RandomVector() * 10, player
                )
            end
        end

        --Display effect on HUD
		if PlayerManager.AnyoneHasTrinket(mod.ITEM.TRINKET.JEVILSTAIL) then
			local activeEffect
			local numActiveEffects = 0
			for i = 0, 8 do
				if mod.activeJevilEffects[i] then
					activeEffect = i
					numActiveEffects = numActiveEffects + 1
				end
			end
			local HUD = game:GetHUD()
			if numActiveEffects > 1 then
				HUD:ShowItemText("Chaos! Chaos!", "There are multiple effects!")
			elseif activeEffect then
				if mod.JevilText[activeEffect + 1].Sub then
					HUD:ShowItemText(mod.JevilText[activeEffect + 1].Main, mod.JevilText[activeEffect + 1].Sub)
				else
					HUD:ShowItemText(mod.JevilText[activeEffect + 1].Main)
				end
			end
        end
    end
end

function mod:scramblePlayerHealth(player)
	if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B then
		local twin = player:GetOtherTwin()
		if twin ~= nil then
			mod:scramblePlayerHealth(twin)
			return
		end
	end
	if CustomHealthAPI.Helper.PlayerIsIgnored(player) or 
	   CustomHealthAPI.Helper.PlayerHasCoinHealth(player) or 
	   CustomHealthAPI.Helper.PlayerIsHealthless(player)
	then
		return
	end
	
	CustomHealthAPI.Helper.CheckIfHealthOrderSet()
	CustomHealthAPI.Helper.CheckHealthIsInitializedForPlayer(player)
	CustomHealthAPI.Helper.CheckSubPlayerInfoOfPlayer(player)
	CustomHealthAPI.Helper.ResyncHealthOfPlayer(player)
	
	--rerolling red hearts
	local totalRedHP = CustomHealthAPI.Helper.GetTotalRedHP(player)
	local totalContainers = math.ceil(CustomHealthAPI.Helper.GetRedCapacity(player) / 2)
	
	local newRotten = 0
	local newRed = 0
	local newMorbid = 0
	
	while (newRotten + newRed + newMorbid < totalRedHP and newRotten + math.ceil(newRed / 2) + math.ceil(newMorbid / 3) < totalContainers) do
		local rand = math.random(3)
		if rand == 1 then
			newRotten = newRotten + 1
		elseif rand == 2 then
			newRed = newRed + 1
		else
			newMorbid = newMorbid + 1
		end
	end
	
	while (newRotten + newRed + newMorbid < totalRedHP and (newRed % 2 ~= 0 or newMorbid % 3 ~= 0)) do
		local rand = math.random(2)
		if rand == 1 or newMorbid % 3 == 0 then
			newRed = newRed + 1
		elseif rand == 2 or newRed % 2 == 0 then
			newMorbid = newMorbid + 1
		else
			break
		end
	end
	
	while (newRotten + newRed + newMorbid < totalRedHP and (newRotten > 0 or newRed > 0)) do
		local rand = math.random(2)
		if rand == 1 or newRed <= 0 then
			newRotten = newRotten - 1
			newRed = newRed + 2
		elseif rand == 2 or newRotten <= 0 then
			newRed = newRed - 2
			newMorbid = newMorbid + 3
		else
			break
		end
	end
	
	player:AddHearts(-999)
	player:AddRottenHearts(newRotten * 2)
	player:AddHearts(newRed)
	FiendFolio:AddMorbidHearts(player, newMorbid)
	
	--rerolling soul hearts
	local hearts = CustomHealthAPI.Library.GetHealthInOrder(player)
	for i = #hearts, 1, -1 do
		local health = hearts[i]
		local key = health.Other.Key
		local typeOfKey = CustomHealthAPI.Library.GetInfoOfKey(key, "Type")
		
		if typeOfKey == CustomHealthAPI.Enums.HealthTypes.SOUL then
			local rand = math.random(3)
			if rand == 1 then
				CustomHealthAPI.Library.TryConvertOtherKey(player, i, "SOUL_HEART", true)
			elseif rand == 2 then
				CustomHealthAPI.Library.TryConvertOtherKey(player, i, "BLACK_HEART", true)
			else
				CustomHealthAPI.Library.TryConvertOtherKey(player, i, "IMMORAL_HEART", true)
			end
		end
	end
	
	--leaving containers and overlays alone for now, maybe in the future if we ever add variants of these
	--the future is now, old man
end

function mod:getPlayerBruiseStrength(player, playerData)
    playerData = playerData or mod:GetEntityData(player)
    local strength = 0

    if mod.activeJevilEffects and mod.activeJevilEffects[2] then
        strength = strength + 1
    end

    if playerData.fiendfolio_epidermolysisStrength then
        strength = strength + playerData.fiendfolio_epidermolysisStrength
    end

    if playerData.ffsavedata.scytheMode and playerData.ffsavedata.scytheMode == true and not mod.anyPlayerHas(CollectibleType.COLLECTIBLE_BLACK_CANDLE) then
        strength = strength + 2
    end

    if playerData.lastComposterBruise and player.FrameCount - playerData.lastComposterBruise <= 120 then
        strength = strength + 1
    end

	-- this should always come last
	if strength > 0 and player:HasCollectible(CollectibleType.COLLECTIBLE_EVIL_CHARM) then
		strength = 0
	end

    return strength
end

function mod:jevilstailPlayerUpdate(player, data)
    local bruiseStrength = mod:getPlayerBruiseStrength(player, data)
    local morbidModifierActive = data.TookMorbidHeartDamage

    local multiplier = 1

    if bruiseStrength > 0 then
        --Reduce iframes
        multiplier = math.max(0, 1 - ((15 * math.log(bruiseStrength) + 40) / 60))

        --Fake bruise
        player:SetColor(FiendFolio.StatusEffectColors.BruiseLvl1, 1, 1, false, false)
        --[[if not data.HasFakeBruiseVisual then
            local iconEnt = Isaac.Spawn(EntityType.ENTITY_EFFECT, 1748, 0, player.Position, player.Velocity, nil)
            iconEnt:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
            local icon = iconEnt:ToEffect()
            icon.Parent = player
            icon:FollowParent(player)
            icon.DepthOffset = 1
            icon:Update()
            data.HasFakeBruiseVisual = iconEnt
        end]]-- --this is now handled in status code
    elseif data.HasFakeBruiseVisual then
        if data.HasFakeBruiseVisual:Exists() then
            data.HasFakeBruiseVisual:Remove()
        end
        data.HasFakeBruiseVisual = nil
    end

    if morbidModifierActive then
        multiplier = multiplier * 2/3
    end

	if multiplier ~= 1 then
        local baseIFrames = 60 * (player:GetTrinketMultiplier(TrinketType.TRINKET_BLIND_RAGE) + 1)
        local frameLimit = math.ceil(baseIFrames - baseIFrames * multiplier)

        if player:GetDamageCooldown() < frameLimit then
            player:ResetDamageCooldown()

            if morbidModifierActive then
                data.TookMorbidHeartDamage = nil
            end
        end
    end

    -- safeguard
    if morbidModifierActive and player:GetDamageCooldown() <= 0 then
        data.TookMorbidHeartDamage = nil
    end
	
	if mod.activeJevilEffects and mod.activeJevilEffects[1] then
		mod.jevilBruiseEnemiesDamage = math.max(mod.jevilBruiseEnemiesDamage or 0, player.Damage * 0.2)
	end
end

function mod:jevilBruseEnemies()
    if mod.activeJevilEffects and mod.activeJevilEffects[1] and mod.jevilBruiseEnemiesDamage then
		for _, entity in ipairs(mod.GetRoomEntitiesCache()) do
			local etyp = entity.Type
			if etyp > 9 and etyp < 1000 then
				FiendFolio.AddBruise(entity, player, 1, 1, mod.jevilBruiseEnemiesDamage, false, true)
			end
		end
    end
	mod.jevilBruiseEnemiesDamage = nil
end

local jevilFoleys = {
    {Sound = mod.Sounds.SlideWhistle,   Vol = 0.5},
    {Sound = mod.Sounds.WhipCrack,      Vol = 0.5},
    {Sound = mod.Sounds.Monch,          Vol = 1},
    {Sound = mod.Sounds.FunnyBonk,      Vol = 1},
    {Sound = mod.Sounds.FartFrog3,      Vol = 0.6},
    {Sound = mod.Sounds.CartoonGulp,    Vol = 1},
    {Sound = mod.Sounds.Crow,           Vol = 1},
    {Sound = mod.Sounds.BingBingWahoo,  Vol = 0.3},
    {Sound = mod.Sounds.EpicTwinkle,    Vol = 1},
    {Sound = mod.Sounds.LezEffectGet,   Vol = 1},
    {Sound = mod.Sounds.BabyGasp,       Vol = 1},
    {Sound = mod.Sounds.CatSqueal,      Vol = 1},
    {Sound = mod.Sounds.MamaDoll,       Vol = 1},
    {Sound = mod.Sounds.MonkeyScream,   Vol = 1},
    {Sound = mod.Sounds.Orangutan,      Vol = 1},
    {Sound = mod.Sounds.BrownedBoing,   Vol = 1},
}

function mod:playJevilFoley()
    local choice = math.random(#jevilFoleys)
    sfx:Play(jevilFoleys[choice].Sound, jevilFoleys[choice].Vol, 0, false, math.random(80,120)/100)
end

mod:AddCallback(ModCallbacks.MC_PRE_SFX_PLAY, function(_, sound, volume, delay, loop, pitch, pan)
    if mod.activeJevilEffects then
        if mod.activeJevilEffects[0] then
            if sound == SoundEffect.SOUND_TEARS_FIRE then
                return {mod.Sounds.Boink, 2, 0, false,  math.random(80,120)/100, pan}
            elseif sound == SoundEffect.SOUND_TEARIMPACTS then
                return {SoundEffect.SOUND_FART, 0.2, 0, false,  math.random(80,120)/100, pan}
            elseif sound == SoundEffect.SOUND_SPLATTER then
                return {SoundEffect.SOUND_FART, 0.2, 0, false,  math.random(80,120)/100, pan}
            elseif sound == SoundEffect.SOUND_SUMMONSOUND then
                return {mod.Sounds.FunnyHello, 1, 0, false,  math.random(80,120)/100, pan}
            elseif sound == SoundEffect.SOUND_BOSS1_EXPLOSIONS then
                return {mod.Sounds.FunnyFart, 1, 0, false,  math.random(80,120)/100, pan}
            elseif sound == SoundEffect.SOUND_EXPLOSION_WEAK then
                return {SoundEffect.SOUND_FART, 0.4, 0, false,  math.random(100,150)/100, pan}
            elseif sound == SoundEffect.SOUND_EXPLOSION_STRONG then
                return {mod.Sounds.FartFrog4, 1, 0, false,  math.random(80,120)/100, pan}
            elseif sound == SoundEffect.SOUND_HELLBOSS_GROUNDPOUND then
                return {mod.Sounds.Subaluwa, 1, 0, false,  math.random(80,120)/100, pan}
            elseif sound == SoundEffect.SOUND_MONSTER_YELL_A then
                if math.random(2) == 1 then
                    return {mod.Sounds.EpicHorn, 1, 0, false,  math.random(80,120)/100, pan}
                else
                    return {mod.Sounds.YodelGoofy, 1, 0, false,  math.random(80,120)/100, pan}
                end
            end
        end
    end
end)

function mod:JevilsTailTakeDmg(entity, damage, flags, source, countdown)
	if mod.activeJevilEffects then
        if mod.activeJevilEffects[0] then
            if entity.Type >= 10 and source.Type == 2 then
                sfx:Play(mod.Sounds.EpicPunch, 1, 0, false,  math.random(80,120)/100)
            elseif entity.Type == 1 then
                sfx:Play(mod.Sounds.Hoot6, 1, 0, false,  math.random(80,120)/100)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
    local level = game:GetLevel()

    if mod.activeJevilEffects and mod.activeJevilEffects[0] then
        if npc:IsEnemy() then
            mod:playJevilFoley()
        end
    end
end)

function mod:AwesomePointingArrowAI(e)
    local sprite = e:GetSprite()
    if sprite:IsFinished("Appear") then
        mod:spritePlay(sprite, "Idle")
    end
    local data = mod:GetEntityData(e)
    if not data.NoRotation then
        e.SpriteRotation = e.SpriteRotation + 1
    end
    e.SpriteOffset = data.ForcedOffset or Vector(0, -18)
    if not e.Parent then
        if e.State == 5 and data.LastParentPos then
            game:MakeShockwave(data.LastParentPos, 0.0175, 0.05, 50)
            if math.random(10) == 1 then
                local fly = Isaac.Spawn(13, 0, 0, data.LastParentPos, Vector.Zero, nil)
                sfx:Play(mod.Sounds.CrowdCheer, 2, 0, false, 1)
                sfx:Play(mod.Sounds.Tada, 2, 0, false, 1)
                for i = 90, 360, 90 do
                    local arrow = Isaac.Spawn(1000, mod.FF.AwesomePointingArrow.Var, mod.FF.AwesomePointingArrow.Sub, fly.Position, nilvector, nil):ToEffect()
                    arrow:ToEffect():FollowParent(fly)
                    arrow.SpriteRotation = i
                    if i == 90 and PlayerManager.AnyoneIsPlayerType(FiendFolio.PLAYER.IMAGE) then
                        arrow.State = 5
                    end
                    arrow:Update()
                end
            end
        end
        e:Remove()
    else
        data.LastParentPos = e.Parent.Position
    end
end
