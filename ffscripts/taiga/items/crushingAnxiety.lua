-- Crushing Anxiety --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local chanceDivider = 100
local baseChanceVal = 10
local minChanceVal = 1
local maxChanceVal = 20
local maxChanceAtLuck = 15
local scaledChanceMult = (maxChanceVal - baseChanceVal) / maxChanceAtLuck

local cooldown = 0
function mod:fireCrushingAnxiety(player, pos, fireDir)
	if cooldown > 0 then
		return
	end
	
	local chance = (baseChanceVal * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.CRUSHING_ANXIETY)) + player.Luck * scaledChanceMult
	chance = math.min(math.max(minChanceVal, chance), maxChanceVal)
	if math.random() * chanceDivider <= chance then
		local anxietyCapsule = {
			Locus1 = pos,
			Locus2 = pos + fireDir:Resized(99999),
			Radius = 20,
		}
		
		local room = game:GetRoom()
		local hasSpectral = player.TearFlags & TearFlags.TEAR_SPECTRAL == TearFlags.TEAR_SPECTRAL
		local enemies = Isaac.FindInRadius(pos, 99999, EntityPartition.ENEMY)
		local closestEnemy, closestDist = nil, math.huge
		for _, enemy in ipairs(enemies) do
			if enemy.Type > 9 and enemy.Type < 1000 then
				local enemyCapsule = TearFlagsLib.GenerateCapsuleFromEntity(enemy)
				if TearFlagsLib.SimulateCapsuleCapsuleCollision(enemyCapsule, anxietyCapsule) then
					local dist = (enemy.Position - pos):Length()
					if dist < closestDist and not enemy:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) and 
					   (hasSpectral or room:CheckLine(pos, enemy.Position, 3)) 
					then
						closestEnemy = enemy
						closestDist = dist
					end
				end
			end
		end
		
		if closestEnemy then
			local boulder = Isaac.Spawn(1000, 1960, mod.FF.CrushingAnxiety.Sub, closestEnemy.Position, nilvector, player):ToEffect()
			boulder.CollisionDamage = player.Damage * 2.5 + 5
			boulder:FollowParent(closestEnemy)
			boulder:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			boulder:Update()
			
			cooldown = 90
			
			return true
		end
	end
end

mod:AddCollectibleCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE, mod.ITEM.COLLECTIBLE.CRUSHING_ANXIETY, function(_, player, dir, amount, owner, params)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.CRUSHING_ANXIETY) then
		for i = 1, amount do
			if mod:fireCrushingAnxiety(player, player.Position, dir) then 
				return 
			end
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	cooldown = math.max(0, cooldown - 1)
end)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
	if effect.SubType == mod.FF.CrushingAnxiety.Sub then
		effect.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		
		local sprite = effect:GetSprite()
		if sprite:IsEventTriggered("Impact") then
			local anxietyCapsule = {
				Locus1 = effect.Position,
				Locus2 = effect.Position,
				Radius = effect.Size,
			}
			
			local enemies = Isaac.FindInRadius(effect.Position, 99999, EntityPartition.ENEMY)
			for _, enemy in ipairs(enemies) do
				if enemy.Type > 9 and enemy.Type < 1000 then
					local enemyCapsule = TearFlagsLib.GenerateCapsuleFromEntity(enemy)
					if TearFlagsLib.SimulateCapsuleCapsuleCollision(enemyCapsule, anxietyCapsule) then
						enemy:TakeDamage(effect.CollisionDamage, 0, EntityRef(nil), 0)
						if enemy:ToNPC() and not enemy:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) and not enemy:IsBoss() then
							enemy:AddEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
						end
					end
				end
			end
			
			sfx:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS)
			sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE)
			game:MakeShockwave(effect.Position, 0.03, 0.025, 15)
			game:ShakeScreen(4)
		end
		
		if sprite:IsFinished("Drop1") or sprite:IsFinished("Drop2") then
			for i = 25, 360, 25 do
				local gib = Isaac.Spawn(1000, 35, 0, effect.Position, Vector.FromAngle(i + math.random(25) - 12.5):Resized(math.random(4) + 1), effect):ToEffect()
				local smoke = Isaac.Spawn(1000, mod.FF.FFWhiteSmoke.Var, mod.FF.FFWhiteSmoke.Sub, effect.Position, Vector.FromAngle(i):Resized(math.random(2) + 3), effect):ToEffect()
				smoke.Color = Color(1,1,1,0.1,0,0,0)
			end
			
			effect:Remove()
		elseif not (sprite:IsPlaying("Drop1") or sprite:IsPlaying("Drop2")) then
			sprite:Play("Drop" .. math.random(2), true)
		end
		
		if sprite:IsEventTriggered("StopFollow") or not effect.Parent or effect.Parent:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) then
			effect.IsFollowing = false
			effect.Parent = nil
		end
		effect.Velocity = nilvector
	end
end, 1960)