local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

if StageAPI and StageAPI.Loaded then
    StageAPI.AddPlayerGraphicsInfo(FiendFolio.PLAYER.CLASSIC_FIEND, {
        Name = "gfx/ui/boss/playername_fiend_classic.png",
		Portrait = "gfx/ui/stage/playerportrait_fiend_classic.png",
		NoShake = true,
		Controls = "gfx/backdrop/controls_fiend.png"
    })
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if player:GetPlayerType() == mod.PLAYER.CLASSIC_FIEND
	or player:HasCollectible(mod.ITEM.COLLECTIBLE.DEAL_OF_THE_DEMONS)
	then
		player.TearFlags = player.TearFlags | TearFlags.TEAR_HOMING
	end
end, CacheFlag.CACHE_TEARFLAG)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player)
	if player:GetPlayerType() == mod.PLAYER.CLASSIC_FIEND
	or player:HasCollectible(mod.ITEM.COLLECTIBLE.DEAL_OF_THE_DEMONS)
	then
		player.TearColor = Color(1.0, 1.0, 0.5, 1.0, 200/255, 0, 0)
		player.LaserColor = Color(1.0, 1.0, 0.5, 1.0, 200/255, 100/255, 0)
	end
end, CacheFlag.CACHE_TEARCOLOR)

mod:AddCallback("FF_PLAYER_HURT_SOUND", function()
	local voiceCrackVal = 0
	if math.random(10) == 1 then
		voiceCrackVal = 0.4
	end
    sfx:Play(mod.Sounds.FiendHurt, 0.8, 0, false, 1.1 + voiceCrackVal)
    return true
end, mod.PLAYER.CLASSIC_FIEND)

mod:AddCallback("FF_PLAYER_DEATH_SOUND", function()
    sfx:Play(mod.Sounds.FiendDies, 0.8, 0, false, 1.1)
    return true
end, mod.PLAYER.CLASSIC_FIEND)

local function findEnemy(fampos, radius)
	local target
	for k,enemy in ipairs(Isaac.GetRoomEntities()) do
		if enemy:IsVulnerableEnemy() and enemy:IsActiveEnemy() then
			enemy = enemy:ToNPC()
			if not (enemy:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) or enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)) then
				local distance = fampos:Distance(enemy.Position)
				if distance < radius then
					radius = distance
					target = enemy
				end
			end
		end
	end
	return target
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	local d = mod:GetEntityData(pickup)
	if d.canreroll == nil then --if the entity loses its unrerollable state for some reason
		d.canreroll = false
	end

	local room = game:GetRoom()
	if room:IsClear() then
		pickup:Morph(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_HEART,HeartSubType.HEART_BLACK)
		pickup:GetSprite():SetLastFrame()
	else
		local target = findEnemy(pickup.Position, 900)
		local extraVec = Vector.Zero
		if not target then
			target = pickup
			extraVec = RandomVector()
		end
		if target then
			mod:CatheryPathFinding(pickup, target.Position + extraVec, {Speed = 1, Threshold = 100, AddVelocity = true})
		end
	end

	for _, enemy in pairs(Isaac.FindInRadius(pickup.Position, 25, EntityPartition.ENEMY)) do
		if enemy:IsActiveEnemy() and enemy:IsVulnerableEnemy() then
			local source = pickup.Parent or Isaac.GetPlayer()
			source = source:ToPlayer()
			if source then
				local maxDelay = math.ceil(math.max(1,source.MaxFireDelay))
				enemy:TakeDamage(source.Damage,DamageFlag.DAMAGE_COUNTDOWN,EntityRef(source), maxDelay)
			end
		end
	end
end, mod.PICKUP.VARIANT.FIEND_MINION_CLASSIC)