local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local twinkleBoilCostume = Isaac.GetCostumeIdByPath("gfx/characters/twinkle_of_contagion2.anm2")

local function GetTwinklyPlayers()
	local players = {}
	for i, player in pairs(mod:GetAllPlayers()) do
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.TWINKLE_OF_CONTAGION) or player:HasTrinket(mod.ITEM.ROCK.ROCKY) then
			table.insert(players, player)
		end
	end
	return players
end

local function IsNpcInSight(npc, player)
	if not player then
		for i, player in pairs(GetTwinklyPlayers()) do
			local degree = math.abs(mod:GetVectorFromDirection(player:GetHeadDirection()):GetAngleDegrees() - ((npc.Position - player.Position):GetAngleDegrees() % 360)) % 360
			if degree < 30 and game:GetRoom():CheckLine(player.Position, npc.Position, 3, 0, false, false) then
				return true
			end
		end
		return false
	else
		local degree = math.abs(mod:GetVectorFromDirection(player:GetHeadDirection()):GetAngleDegrees() - ((npc.Position - player.Position):GetAngleDegrees() % 360)) % 360
		return degree < 30 and game:GetRoom():CheckLine(player.Position, npc.Position, 3, 0, false, false)
	end
end

local function filter(_, npc)
	if not (npc:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) or npc:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) or npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) or npc:IsBoss() or IsNpcInSight(npc)) then
		return true
	end
end

local function SpawnTwinkle()
	local enemy = mod:GetRandomElem(mod:GetAllEnemies(filter))
	if enemy then
		local aura = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.FF.TwinkleAura.Var, mod.FF.TwinkleAura.Sub, enemy.Position, Vector.Zero, enemy):ToEffect()
		aura:FollowParent(enemy)
		mod:GetEntityData(aura).TwinkleAuraEnemy = enemy
		
		return aura
	end
end

local function IsTwinkleActive()
	return Isaac.CountEntities(nil, EntityType.ENTITY_EFFECT, mod.FF.TwinkleAura.Var, mod.FF.TwinkleAura.Sub) > 0
end

--Weight in sounds.xml doesn't work so
local function playTwinkleSound()
	if math.random(50) == 1 then
		sfx:Play(mod.Sounds.RockyCrush)
	else
		sfx:Play(mod.Sounds.TwinklePass)
	end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function(_)
	if #mod:GetPlayersHoldingCollectible(mod.ITEM.COLLECTIBLE.TWINKLE_OF_CONTAGION) > 0 then
		if mod:RandomInt(1, 2) == 1 and not game:GetRoom():IsClear() then
			SpawnTwinkle()
		end
	end
	for i, player in pairs(GetTwinklyPlayers()) do
		if mod:GetEntityData(player).HasTwinkle then
			mod:GetEntityData(player).HasTwinkle = false
			player:TryRemoveNullCostume(twinkleBoilCostume)
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_LUCK)
			player:EvaluateItems()
		end
	end
end)

function mod:handleRockyTrinket(player)
	if player:HasTrinket(mod.ITEM.ROCK.ROCKY) then
		if not game:GetRoom():IsClear() then
			local rockpower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.ROCKY)
			
			if player:GetTrinketRNG(mod.ITEM.ROCK.ROCKY):RandomFloat() <= 0.002+(rockpower*0.001) and not IsTwinkleActive() then
				local twinkle = SpawnTwinkle()
				if twinkle then
					playTwinkleSound()
					mod:GetEntityData(twinkle).TwinkleBlink = 10
				end
			end
		end
	end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.ROCK.ROCKY, mod.handleRockyTrinket)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
	local data = mod:GetEntityData(effect)
	if effect.SubType == mod.FF.TwinkleAura.Sub then
		data.TwinkleBlink = data.TwinkleBlink or 0
		
		if not data.init then
			effect:SetColor(Color(1,1,1,0.4,0.5,0.5,0.5), 0, 0, false, false)
			effect.DepthOffset = 100
			effect.SpriteOffset = Vector(0, -10)
			effect.SpriteScale = effect.SpriteScale*1.25
			
			data.init = true
		end
		
		if effect.FrameCount % mod:RandomInt(10, 15) == 0 then
			for i = 1, mod:RandomInt(0,3) do
				local vel = RandomVector()*math.random()*4
				local sparkle = Isaac.Spawn(1000, 1727, 0, effect.Position+vel*5+Vector(0, -10), vel+effect.Velocity, effect):ToEffect()
				sparkle:SetColor(Color(1,1,1,1,0.4,0.4,0.4), 0, 0, false, false)
			end
		end
		
		if data.TwinkleAuraEnemy then
			if data.TwinkleAuraEnemy:IsDead() then
				local enemy = mod:GetRandomElem(mod:GetAllEnemies(filter))
				if enemy then
					effect.Position = enemy.Position
					effect:FollowParent(enemy)
					data.TwinkleAuraEnemy = enemy
					data.TwinkleBlink = 10
					playTwinkleSound()
				else
					effect:Remove()
				end
			end
			for i, player in pairs(GetTwinklyPlayers()) do
				if IsNpcInSight(data.TwinkleAuraEnemy, player) then
					effect.Position = player.Position
					effect:FollowParent(player)
					playTwinkleSound()
					data.TwinkleAuraEnemy = nil
					data.TwinkleBlink = 10
					mod:GetEntityData(player).HasTwinkle = true
					player:AddNullCostume(twinkleBoilCostume)
					data.TwinkleAuraPlayer = player
					player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_LUCK)
					player:EvaluateItems()
				end
			end
		elseif data.TwinkleAuraPlayer then
			local player = data.TwinkleAuraPlayer
			if mod:RandomInt(1, 200) == 1 then
				local enemy = mod:GetRandomElem(mod:GetAllEnemies(filter))
				if enemy then
					effect.Position = enemy.Position
					effect:FollowParent(enemy)
					data.TwinkleAuraEnemy = enemy
					data.TwinkleBlink = 10
					mod:GetEntityData(player).HasTwinkle = false
					player:TryRemoveNullCostume(twinkleBoilCostume)
					player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_LUCK)
					player:EvaluateItems()
					playTwinkleSound()
					data.TwinkleAuraPlayer = nil
				end
			end
		end
		
		if data.TwinkleBlink > 0 then
			data.TwinkleBlink = data.TwinkleBlink - 1
			effect.Visible = data.TwinkleBlink % 2 == 0
		else
			effect.Visible = true
		end
	end
end, mod.FF.TwinkleAura.Var)
