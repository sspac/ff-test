--Solemn Vow trinket code
--[[FiendFolio.AddTrinketPickupCallback(function(player, added)
	local savedata = Isaac.GetPlayer():GetData().ffsavedata
	if not player:HasCollectible(403,false) then
	 savedata.playerWithVow = player
	 player:AddItemWisp(403,player.Position,false)
	 --RemoveSpider
		for _, spoder in pairs(Isaac.FindByType(3, 94, -1, false, false)) do
		spoder:Remove()
		end
	end
end, function(player, added)
	for _, wisp in ipairs(Isaac.FindByType(3, 237, 403, false, false)) do
		local savedata = wisp:ToFamiliar().Player:GetData().ffsavedata
		if savedata.playerWithVow ~= nil then
		 wisp:Remove()
		 wisp:Kill()
		end
		savedata.playerWithVow = nil
	end
end, mod.ITEM.TRINKET.SOLEMN_VOW, nil)

--Don't you love when AddCollectibleEffect doesn't actually do what the item does yeepee
--This Makes the wisp invisible
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function(_)
	--AdjustWisp
	local savedata = Isaac.GetPlayer():GetData().ffsavedata
	if savedata.playerWithVow ~= nil then
		for _, wisp in ipairs(Isaac.FindByType(3, 237, 403, false, false)) do
		 wisp.Visible = false
		 wisp.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		 wisp.Position = Vector(1900,1900)
		 wisp:ToFamiliar():RemoveFromOrbit()
		end
	end
		 --RemoveSpider
		for _, spoder in pairs(Isaac.FindByType(3, 94, -1, false, false)) do
		spoder:Remove()
		end
end)
--Solemn Vow Code end]]

--Cake originally made this
--THIS WOULD HAVE NO PROBLEMS IF WE COULD JUST ADD ITEM EFFECTS WITHOUT GIVING THE ITEM AAAA

--[[
local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

function mod:solemnVowUpdate(player, d)
    local savedata = d.ffsavedata
    if player:HasTrinket(mod.ITEM.TRINKET.SOLEMN_VOW) and player.FrameCount >= 1 then
        if not d.SolemnVowWisp then
            local foundWisp
            if savedata.SolemnVowWisp then
                local wisps = Isaac.FindByType(3, 237, 403, false, false)
                if #wisps > 0 then
                    local wisp = wisps[1]:ToFamiliar()
                    d.SolemnVowWisp = wisp
                    foundWisp = true
                    wisp.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                    wisp:GetData().preventWispFiring = true
                    wisp:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    wisp:RemoveFromOrbit()
                    wisp:Update()
                end
            end
            if not foundWisp then
                local wisp = Isaac.Spawn(3, 237, 403, Vector(-100, -50), nilvector, player):ToFamiliar()
                wisp.Parent = player
                wisp.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                wisp:GetData().preventWispFiring = true
                wisp:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                wisp:RemoveFromOrbit()
                wisp:Update()
                d.SolemnVowWisp = wisp
                savedata.SolemnVowWisp = true
            end
        end
    end
    if d.SolemnVowWisp then
        d.SolemnVowWisp.Position = Vector(-100, -50)
        d.SolemnVowWisp.Visible = false
        if not player:HasTrinket(mod.ITEM.TRINKET.SOLEMN_VOW) then
            d.SolemnVowWisp:Remove()
            d.SolemnVowWisp:Kill()
            d.SolemnVowWisp = nil
            savedata.SolemnVowWisp = nil
            
            local tempEffects = player:GetEffects()
            tempEffects:RemoveCollectibleEffect(403, -1)
        end
    end
end

mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, 999999999, function(_, player, flag)
    if flag == CacheFlag.CACHE_FAMILIARS then
        if player:HasTrinket(mod.ITEM.TRINKET.SOLEMN_VOW) or player:GetData().SolemnVowWisp then
            local youngestSpoder
            local spiders = Isaac.FindByType(3, 94, -1, false, false)
            for _, spoder in pairs(spiders) do
                if player.InitSeed == spoder.SpawnerEntity.InitSeed then
                    if youngestSpoder then
                        if spoder.FrameCount < youngestSpoder.FrameCount then
                            youngestSpoder = spoder
                        end
                    else
                        youngestSpoder = spoder
                    end
                end
            end
            if youngestSpoder then
                youngestSpoder:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                FiendFolio.scheduleForUpdate(function()
                    if youngestSpoder and youngestSpoder:Exists() then
                        youngestSpoder:Remove()
                    end
                end, 0, ModCallbacks.MC_PRE_RENDER, true)
            end
        end
    end
end)
]]


-- v3, wispless via repentogon (-connor)

-- 1. Use rgon innate collectible instead of a hidden wisp for spider mod
-- 2. Only add the innate collectible ONCE globally, and only if no other copies of spider mod exist (real or innate, on any player).
-- 3. If the effect of spider mod is only being supplied by Solemn Vow, remove ALL spider mod familiars during familiar cache eval.

local mod = FiendFolio

local function ShouldAddHiddenSpiderMod()
	local totalSpiders = 0
	local solemnSpiders = 0

	for _, player in ipairs(PlayerManager.GetPlayers()) do
		totalSpiders = totalSpiders + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_SPIDER_MOD)
		solemnSpiders = solemnSpiders + player:GetInnateCollectibleCount(CollectibleType.COLLECTIBLE_SPIDER_MOD, "FF_SOLEMN_VOW")
	end

	local shouldAdd = totalSpiders <= solemnSpiders and PlayerManager.AnyoneHasTrinket(mod.ITEM.TRINKET.SOLEMN_VOW)
	local currentlyAdded = solemnSpiders > 0

	return shouldAdd, currentlyAdded
end

local function CheckHiddenSpiderMods()
	local shouldAdd, currentlyAdded = ShouldAddHiddenSpiderMod()

	if shouldAdd and not currentlyAdded then
		local player = PlayerManager.FirstTrinketOwner(mod.ITEM.TRINKET.SOLEMN_VOW) or Isaac.GetPlayer()
		player:AddInnateCollectible(CollectibleType.COLLECTIBLE_SPIDER_MOD, 1, "FF_SOLEMN_VOW")
	elseif not shouldAdd and currentlyAdded then
		for _, player in ipairs(PlayerManager.GetPlayers()) do
			player:ClearInnateItemGroup("FF_SOLEMN_VOW")
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_ADDED, CheckHiddenSpiderMods, CollectibleType.COLLECTIBLE_SPIDER_MOD)
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, CheckHiddenSpiderMods, CollectibleType.COLLECTIBLE_SPIDER_MOD)
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, CheckHiddenSpiderMods, mod.ITEM.TRINKET.SOLEMN_VOW)
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, CheckHiddenSpiderMods, mod.ITEM.TRINKET.SOLEMN_VOW + TrinketType.TRINKET_GOLDEN_FLAG)
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, CheckHiddenSpiderMods, mod.ITEM.TRINKET.SOLEMN_VOW)
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, CheckHiddenSpiderMods, mod.ITEM.TRINKET.SOLEMN_VOW + TrinketType.TRINKET_GOLDEN_FLAG)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if ShouldAddHiddenSpiderMod() then
		for _, spoder in pairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.SPIDER_MOD)) do
			spoder:Remove()
		end
	end
end, CacheFlag.CACHE_FAMILIARS)
