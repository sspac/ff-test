local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

local NULL_COSTUME = Isaac.GetCostumeIdByPath("gfx/characters/tricky_cherry.anm2")
local ITEM = mod.ITEM.COLLECTIBLE.IMP_SODA_TRICKY_CHERRY
local CRIT_TIME = 90
local COOLDOWN = 600

function mod:ActivateTrickyCherry(player, data, critTime)
    player:AddNullCostume(NULL_COSTUME)
    player:AnimateCollectible(ITEM, "HideItem")

    data.TrickyCherryCrit = true
    data.TempCritTime = (data.TempCritTime or 0) + (critTime or CRIT_TIME)
	
	player:AddCacheFlags(CacheFlag.CACHE_TEARCOLOR)
	player:EvaluateItems()
    
    sfx:Play(mod.Sounds.SodaOpen)
    sfx:Play(mod.Sounds.SodaElectricity, 1, 2, true)
end

---@param player EntityPlayer
function mod:DepleteTrickyCherryCritTime(player, data)
    if data.TempCritTime then
        data.TrickyCherryCrit = true
        data.TempCritTime = data.TempCritTime - 1

        if data.TempCritTime <= 0 then
            data.TempCritTime = nil
            data.TrickyCherryCrit = false
	
			player:AddCacheFlags(CacheFlag.CACHE_TEARCOLOR)
			player:EvaluateItems()
			
            player:TryRemoveNullCostume(NULL_COSTUME)
            sfx:Stop(mod.Sounds.SodaElectricity)
        end
    end
end

---@param player EntityPlayer
function mod:GiveTrickyCherryCharge(player)
    local data = mod:GetEntityData(player)
    if player:HasCollectible(ITEM) then
        local save = data.ffsavedata
        save.TrickyCherryTimer = save.TrickyCherryTimer or 1
        if save.TrickyCherryPrimed == nil then
            save.TrickyCherryPrimed = true
        end

        if not game:IsPaused() then
            local room = game:GetRoom()
            if not room:IsClear()
            and Isaac.CountEnemies() > 0 then
                local oldTrickyCherry = save.TrickyCherryTimer
                save.TrickyCherryTimer = math.max(save.TrickyCherryTimer - 1, 0)
                if oldTrickyCherry ~= 0 and save.TrickyCherryTimer == 0 then
                    sfx:Play(mod.Sounds.SodaRecharge)
                    save.TrickyCherryPrimed = true
                end

                if save.TrickyCherryPrimed then
                    save.TrickyCherryTimer = COOLDOWN
                    save.TrickyCherryPrimed = false
                    mod:ActivateTrickyCherry(player, data, CRIT_TIME * player:GetCollectibleNum(ITEM))
                end
            end
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ITEM, mod.GiveTrickyCherryCharge)

function mod:RemoveTrickyCherryCostumeOnLeave()
    for _, player in ipairs(PlayerManager.GetPlayers()) do
        player:TryRemoveNullCostume(NULL_COSTUME)
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.RemoveTrickyCherryCostumeOnLeave)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.IMP_SODA_TRICKY_CHERRY] = {
	BodyColor = Color(1,1,1,1,93.345/255,-109.920/255,-109.920/255,0.540,0.894,0.894,1),
	EyeAColor = Color(1,1,1,1,85.805/255,-244.381/255,-244.381/255,0.593,1.841,1.841,1),
	EyeBColor = Color(1,1,1,1,85.805/255,-244.381/255,-244.381/255,0.593,1.841,1.841,1)}

local function activateTrickyCherrySewing(familiar, data, critTime)
    data.TrickyCherryCrit = true
    data.TempCritTime = (data.TempCritTime or 0) + (critTime or CRIT_TIME)
    
    sfx:Play(mod.Sounds.SodaOpen)
    sfx:Play(mod.Sounds.SodaElectricity, 1, 2, true)
end

local function depleteTrickyCherryCritTimeSewing(familiar, data)
    if data.TempCritTime then
        data.TrickyCherryCrit = true
        data.TempCritTime = data.TempCritTime - 1

        if data.TempCritTime <= 0 then
            data.TempCritTime = nil
            data.TrickyCherryCrit = false
            sfx:Stop(mod.Sounds.SodaElectricity)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
	if familiar.SubType == FiendFolio.ITEM.COLLECTIBLE.IMP_SODA_TRICKY_CHERRY then
		local data = mod:GetEntityData(familiar)
		depleteTrickyCherryCritTimeSewing(familiar, data)

		data.TrickyCherryTimer = data.TrickyCherryTimer or 1
		if data.TrickyCherryPrimed == nil then
			data.TrickyCherryPrimed = true
		end

		if not game:IsPaused() then
			local room = game:GetRoom()
			if not room:IsClear()
			and Isaac.CountEnemies() > 0 then
				local oldTrickyCherry = data.TrickyCherryTimer
				data.TrickyCherryTimer = math.max(data.TrickyCherryTimer - 1, 0)
				if oldTrickyCherry ~= 0 and data.TrickyCherryTimer == 0 then
					sfx:Play(mod.Sounds.SodaRecharge)
					data.TrickyCherryPrimed = true
				end
				
				if data.TrickyCherryPrimed then
					data.TrickyCherryTimer = 600
					data.TrickyCherryPrimed = false
					activateTrickyCherrySewing(familiar, data, 90)
				end
			end
		end
	end
end, FiendFolio.ITEM.FAMILIAR.SEWING_MANUAL_DOLL)

mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	local fd = mod:GetEntityData(familiar)
	if fd.TempCritTime then
		TearFlagsLib.AddTearFlags(tear, mod.CritFlag)
		TearFlagsLib.SetTearFlagParams(tear, mod.CritFlag, {IsTrickyCherry = true})
		local data = mod:GetEntityData(tear)
		if not data.critLightning or not data.critLightning:Exists() then
			sfx:Play(mod.Sounds.CritShoot, 0.3, 0, false, math.random(80,120)/100)
			local critLightning = Isaac.Spawn(1000, 1737, 1, tear.Position, Vector.Zero, tear):ToEffect()
			critLightning.Parent = tear
			critLightning.Color = Color(1,1,1,0,0,0,1)
			critLightning:Update()
			mod:GetEntityData(critLightning).TrickyCherryCrit = true
			data.critLightning = critLightning
		end
		tear.Color = Color(1.3,1.3,1.3,1,150/255,-150/255,-150/255)
		
		if familiar.Player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
			local tearcolor = Color(0.4, 0.15, 0.38, 1, 55/255, 5/255, 95/255)
			tear.Color = tearcolor
		end
		if mod:isSuperpositionedPlayer(familiar.Player) then
			local tearcolor = Color.Lerp(tear.Color, Color(1,1,1,1,0,0,0), 0)
			tearcolor.A = tearcolor.A / 4
			tear.Color = tearcolor
		end
	end
end, FiendFolio.ITEM.COLLECTIBLE.IMP_SODA_TRICKY_CHERRY)
