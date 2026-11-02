-- Rabbit's Foot --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local slapVal = 120 --How many frames (30fps) of slap card get added on use

function mod:rabbitsFootCache(player, flags)
	if flags & CacheFlag.CACHE_LUCK ~= 0 then
		local basedata = mod:GetEntityData(player)
		local data = basedata.ffsavedata
		if not data then
			return
		end
		
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.RABBITS_FOOT) then
			if data.FFRabbitsFootFirstKnownLuck == nil then
				data.FFRabbitsFootFirstKnownLuck = player.Luck
			end
			player.Luck = player.Luck - math.min(3, data.FFRabbitsFootFirstKnownLuck) + 4
		end
		player.Luck = player.Luck - (data.FFRabbitsFootPenalty or 0)
	end
end

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.LATE, function(_, player, amount, flags)
	--check if debug 3 is active
	if game:GetDebugFlags() & DebugFlag.INFINITE_HP == DebugFlag.INFINITE_HP then
		return
	end
	
	--check if damage is fake or nokill
	if flags & DamageFlag.DAMAGE_FAKE == DamageFlag.DAMAGE_FAKE or 
	   flags & DamageFlag.DAMAGE_NOKILL == DamageFlag.DAMAGE_NOKILL 
	then
		return
	end
	
	local player = player:ToPlayer()
	if not player then
		return
	end
	
	--check if player has item, and if luck is positive
	local rabbitsFootOwner
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.RABBITS_FOOT) and player.Luck > 0 then
		rabbitsFootOwner = player
	elseif player:GetPlayerType() == mod.PLAYER.BRIEND then
		-- Briend's twin can activate it too
		local twin = player:GetOtherTwin()
		if twin and twin:HasCollectible(mod.ITEM.COLLECTIBLE.RABBITS_FOOT) and twin.Luck > 0 then
			rabbitsFootOwner = twin
		end
	end
	
	if not rabbitsFootOwner then
		return
	end
	
	-- check if the player has more than one type of health
	local redHP = CustomHealthAPI.Helper.GetTotalRedHP(player)
	local soulHP = CustomHealthAPI.Helper.GetTotalSoulHP(player)
	local boneHP = CustomHealthAPI.Helper.GetTotalBoneHP(player)
	if (redHP > 0 and soulHP > 0) or (redHP > 0 and boneHP > 0) or (soulHP > 0 and boneHP > 0) then
		-- hit cannot possibly kill
		return
	end
	
	--check if the player has more than one bone-style heart
	local basegameBoneHP = player:GetBoneHearts()
	if basegameBoneHP > 1 then
		-- hit cannot possibly kill
		return
	end
	
	--check if damage is less than amount of hp remaining
	if redHP + soulHP + boneHP > amount then
		return
	end
	
	--check if player has berserk active
	local effects = player:GetEffects()
	if effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK) then
		return
	end
	
	--check if astral projection hasnt proc'd
	if player:HasCollectible(CollectibleType.COLLECTIBLE_ASTRAL_PROJECTION) and 
	   effects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_ASTRAL_PROJECTION) < 2 
	then
		return
	end
	
	--check if spirit shackles hasnt proc'd
	if player:HasCollectible(CollectibleType.COLLECTIBLE_SPIRIT_SHACKLES) and 
	   not effects:HasNullEffect(NullItemID.ID_SPIRIT_SHACKLES_DISABLED)
	then
		return
	end
	
	--do the funny
	local basedata = mod:GetEntityData(rabbitsFootOwner)
	local data = basedata.ffsavedata
	if data then
		data.FFRabbitsFootPenalty = (data.FFRabbitsFootPenalty or 0) + 4
		rabbitsFootOwner:AddCacheFlags(CacheFlag.CACHE_LUCK)
		rabbitsFootOwner:EvaluateItems()
	end
	
	--imma be lazy and just reuse the slap card effect its fine prolly
    FiendFolio.savedata = FiendFolio.savedata or {}
    FiendFolio.savedata.run = FiendFolio.savedata.run or {}
    FiendFolio.savedata.run.slapCardActive = FiendFolio.savedata.run.slapCardActive or 0
    FiendFolio.savedata.run.slapCardActive = FiendFolio.savedata.run.slapCardActive + slapVal
	for k = 0, 1 do
        mod.scheduleForUpdate(function()
            for _, ent in ipairs(Isaac.GetRoomEntities()) do
                local id, var, subt = ent.Type, ent.Variant, ent.SubType
                if mod.slapCardKillers[id] or mod.slapCardKillers[id .. "." .. var] or mod.slapCardKillers[id .. "." .. var .. "." .. subt] then
                    if id == 1000 then
                        local cloud = Isaac.Spawn(1000, mod.FF.FFWhiteSmoke.Var, mod.FF.FFWhiteSmoke.Sub, ent.Position - ent.Velocity, ent.Velocity, ent)
                        mod:GetEntityData(cloud).longonly = true
                        cloud.SpriteOffset = Vector(0, ent.SpriteOffset.Y * 0.5)
                        cloud.SpriteScale = Vector(0.75,0.75) * ent:ToEffect().Scale
                        cloud.Color = ent.Color
                        cloud:Update()
                        ent:Remove()
                    else
                        ent:Die()
                    end
                end
            end
        end, k)
    end
    sfx:Play(mod.Sounds.SlapcardItemActivate, 1, 0, false, mod:RandomInt(90,110,rng)/100)
    game:MakeShockwave(player.Position, 0.035, 0.025, 10)
	
	-- no die pls
	return {DamageFlags = flags | DamageFlag.DAMAGE_NOKILL}
end, EntityType.ENTITY_PLAYER)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	local room = game:GetRoom()
	if (not room:IsClear()) and room:IsFirstVisit() then
		for i = 1, game:GetNumPlayers() do
			local player = Isaac.GetPlayer(i - 1)
			local basedata = mod:GetEntityData(player)
			local data = basedata.ffsavedata
			if data then
				data.FFRabbitsFootPenalty = math.max((data.FFRabbitsFootPenalty or 0) - 1, 0)
				player:AddCacheFlags(CacheFlag.CACHE_LUCK)
				player:EvaluateItems()
			end
		end
	end
end)