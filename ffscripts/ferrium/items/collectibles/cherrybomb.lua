local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

mod.nancyCherry = {
	"megaCherry",
	"bobbyBombCherry",
	"bobsCurseCherry",
	"buttBombsCherry",
	"sadBombsCherry",
	"hotBombsCherry",
	"bomberBoyCherry",
	"scatterBombsCherry",
	"stickyBombsCherry",
	"glitterBombsCherry",
	"fastBombsCherry",
	"rocketJarCherry",
	"bloodBombsCherry",
	"brimBombsCherry",
	"ghostBombsCherry",
	"nuggetBombsCherry",
	"muscaCherry",
	"slippyCherry",
	"electrumCherry",
	"bombSackCherry",
	"fabergeBombsCherry",
	"zipBombsCherry",
}

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, item, rng, player)
	mod.scheduleForUpdate(function()
		local bomb = Isaac.Spawn(mod.FF.CherryBomb.ID, mod.FF.CherryBomb.Var, 0, player.Position, Vector.Zero, player):ToBomb()
		player:TryHoldEntity(bomb)
		sfx:Play(SoundEffect.SOUND_FETUS_FEET, 1, 0, false, 1)
		local data = mod:GetEntityData(bomb)
		data.player = player
		
		if mod:playerIsBelialMode(player) then
			data.belialBombCherry = true
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MR_MEGA) then
			data.megaCherry = true
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BOBBY_BOMB) then
			bomb:AddTearFlags(TearFlags.TEAR_HOMING)
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BOBS_CURSE) then
			data.bobsCurseCherry = true
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BUTT_BOMBS) then
			data.buttBombsCherry = true
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_SAD_BOMBS) then
			data.sadBombsCherry = true
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_HOT_BOMBS) then
			data.hotBombsCherry = true
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BOMBER_BOY) then
			data.bomberBoyCherry = true
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_SCATTER_BOMBS) then
			data.scatterBombsCherry = true
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_STICKY_BOMBS) then
			data.stickyBombsCherry = true
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_GLITTER_BOMBS) then
			data.glitterBombsCherry = true
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_FAST_BOMBS) then
			mod.scheduleForUpdate(function()
				if player:HasCollectible(CollectibleType.COLLECTIBLE_9_VOLT) then
					player:SetActiveCharge(55)
				else
					player:SetActiveCharge(35)
				end
			end, 0)
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR) then
			data.rocketJarCherry = true
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BLOOD_BOMBS) then
			data.bloodBombsCherry = true
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE_BOMBS) then
			data.brimBombsCherry = true
		end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_GHOST_BOMBS) then
			data.ghostBombsCherry = true
		end
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.NUGGET_BOMBS) then
			data.nuggetBombsCherry = true
		end
		--[[if player:HasCollectible(mod.ITEM.COLLECTIBLE.BRIDGE_BOMBS) then
			data.bridgeBombsCherry = true
		end]]
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.MUSCA) then
			data.muscaCherry = true
		end
		--[[if player:HasCollectible(mod.ITEM.COLLECTIBLE.TELEBOMBS) then
			
		end]]
		if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.SLIPPYS_GUTS) then
			data.slippyCherry = true
		end
		if player:HasTrinket(FiendFolio.ITEM.ROCK.ELECTRUM) then
			local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.ELECTRUM)
			data.electrumCherry = player.Damage*mult
		end
		if player:HasTrinket(mod.ITEM.ROCK.BOMB_SACK_FOSSIL) then
			data.bombSackCherry = true
		end
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.FABERGE_BOMBS) then
			data.fabergeBombsCherry = true
		end
		if player:HasCollectible(mod.ITEM.COLLECTIBLE.ZIP_43) then
			data.zipBombsCherry = true
		end
		
		if player:HasCollectible(CollectibleType.COLLECTIBLE_NANCY_BOMBS) then
			local eff = mod.nancyCherry[rng:RandomInt(#mod.nancyCherry)+1]
			if eff == "bobbyBombCherry" then
				bomb:AddTearFlags(TearFlags.TEAR_HOMING)
			elseif eff == "fastBombsCherry" then
				mod.scheduleForUpdate(function()
					if player:HasCollectible(CollectibleType.COLLECTIBLE_9_VOLT) then
						player:SetActiveCharge(55)
					else
						player:SetActiveCharge(35)
					end
				end, 0)
			else
				data[eff] = true
			end
		end
		
		Isaac.RunCallback(FiendFolio.CALLBACK.POST_FIRE_CHERRY_BOMB, bomb, player)
	end, 0)
end, FiendFolio.ITEM.COLLECTIBLE.CHERRY_BOMB)

mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, function(_, bomb)
	local data = mod:GetEntityData(bomb)
	bomb.RadiusMultiplier = 0
	if not data.timer then
		data.timer = 50
		bomb:SetExplosionCountdown(50)
	end
	if data.player then
		if not data.player:HasCollectible(CollectibleType.COLLECTIBLE_REMOTE_DETONATOR) then
			data.timer = data.timer-1
		end
	else
		data.timer = data.timer-1
	end
	if data.timer <= 0 then
		bomb:Remove()
	end
	
	if data.stickedEnemy and data.stickedEnemy:Exists() and data.stickedEnemy.EntityCollisionClass > EntityCollisionClass.ENTCOLL_NONE then
		bomb.Position = data.stickedPosition+data.stickedEnemy.Position
		bomb.Velocity = data.stickedEnemy.Velocity
		bomb.PositionOffset = Vector(0, data.stuckOffset)
		bomb.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		bomb.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
	end
	
	if data.rocketJarCherry then
		bomb.Velocity = bomb.Velocity:Resized(15)
		if bomb:CollidesWithGrid() then
			bomb:Remove()
		end
	end
end, mod.FF.CherryBomb.Var)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, bomb)
	if bomb.Variant == mod.FF.CherryBomb.Var then
		local rng = bomb:GetDropRNG()
		local data = mod:GetEntityData(bomb)
		if not data.player then
			data.player = Isaac.GetPlayer(0)
		end
		local level = game:GetLevel():GetAbsoluteStage()
		local explosion
		if data.belialBombCherry then
			explosion = Isaac.Spawn(1000, 144, 1, bomb.Position, Vector.Zero, bomb):ToEffect()
			sfx:Play(SoundEffect.SOUND_DEMON_HIT, 0.65, 0, false, math.random(110,125)/100)
			explosion.CollisionDamage = data.player.Damage+5*level
		else
			explosion = Isaac.Spawn(1000, 1, 0, bomb.Position, Vector.Zero, bomb):ToEffect()
		end
		explosion.SpriteScale = Vector(0.6, 0.6)
		explosion.DepthOffset = 10
		local crater = Isaac.Spawn(1000, 18, 0, bomb.Position, Vector.Zero, bomb):ToEffect()
		crater.SpriteScale = Vector(0.6, 0.6)
		
		if data.bobsCurseCherry then
			local cloud = Isaac.Spawn(1000, 141, 0, bomb.Position, Vector.Zero, data.player):ToEffect()
			cloud.Parent = data.player
			cloud.SpriteScale = Vector(0.1,0.1)
			cloud.CollisionDamage = 2*level+data.player.Damage/2
			mod:GetEntityData(cloud).moveGasInfo = {timeout = 70, grow = 0.008, growLimit = 0.66}
		end
		if data.sadBombsCherry then
			for i=1,5 do
				local tear = Isaac.Spawn(2, 0, 0, bomb.Position, Vector(0,rng:RandomInt(60)/10):Rotated(rng:RandomInt(360)), bomb):ToTear()
				tear.CollisionDamage = data.player.Damage
				tear.FallingSpeed = mod:getRoll(-25,-10,rng)
				tear.FallingAcceleration = mod:getRoll(100,120,rng)/100
			end
		end
		if data.hotBombsCherry then
			local fire = Isaac.Spawn(1000, EffectVariant.HOT_BOMB_FIRE, 0, bomb.Position, Vector.Zero, bomb):ToEffect()
			fire:SetTimeout(100)
			fire.CollisionDamage = data.player.Damage+level
		end
		if data.bomberBoyCherry then
			for i=90,360,90 do
				local newPos = bomb.Position+Vector(0,50):Rotated(i)
				local explosion
				if data.belialBombCherry then
					explosion = Isaac.Spawn(1000, 144, 1, newPos, Vector.Zero, bomb):ToEffect()
					--sfx:Play(SoundEffect.SOUND_DEMON_HIT, 0.65, 0, false, math.random(110,125)/100)
					explosion.CollisionDamage = data.player.Damage+5*level
				else
					explosion = Isaac.Spawn(1000, 1, 0, newPos, Vector.Zero, bomb):ToEffect()

					for _, enemy in ipairs(Isaac.FindInRadius((newPos or bomb.Position), 30, EntityPartition.ENEMY)) do
						if enemy:IsActiveEnemy() and (not mod:isFriend(enemy)) and (enemy:IsVulnerableEnemy() or mod:GetEntityData(enemy).FFCopperBombHitbox) then
							local damage = (data.player.Damage or 5)+10+5*level
							enemy:TakeDamage(damage, DamageFlag.DAMAGE_EXPLOSION | DamageFlag.DAMAGE_IGNORE_ARMOR, EntityRef(bomb), 0)
						end
					end
					for _, pickup in ipairs(Isaac.FindInRadius((newPos or bomb.Position), 30, EntityPartition.PICKUP)) do
						local dist = (100)/pickup.Position:Distance(newPos)
						pickup.Velocity = (pickup.Position-newPos):Resized(dist)
						if pickup.Velocity:Length() > 10 then
							pickup.Velocity = pickup.Velocity:Resized(10)
						end
					end
				end
				explosion.SpriteScale = Vector(0.6, 0.6)
				explosion.DepthOffset = 10
				local crater = Isaac.Spawn(1000, 18, 0, newPos, Vector.Zero, bomb):ToEffect()
				crater.SpriteScale = Vector(0.6, 0.6)
			end
		end
		if data.scatterBombsCherry then
			local bomb1 = Isaac.Spawn(mod.FF.CherryBomb.ID, mod.FF.CherryBomb.Var, 0, bomb.Position, Vector(2,0):Rotated(rng:RandomInt(360)), bomb):ToBomb()
			bomb1.SpriteScale = Vector(0.5,0.5)
			bomb1.Size = bomb1.Size*0.5
			mod:GetEntityData(bomb1).timer = 12
			bomb1:SetExplosionCountdown(12)
			mod:GetEntityData(bomb1).player = data.player
			mod:GetEntityData(bomb1).FFIsScatter = true
		end
		if data.glitterBombsCherry then
			local tears = rng:RandomInt(2)
			if tears == 0 then
				for i=90,360,90 do
					local tear = Isaac.Spawn(2, 20, 0, bomb.Position, Vector(0,11):Rotated(i), bomb):ToTear()
					tear.CollisionDamage = data.player.Damage*1.5
					tear.Scale = 0.5
				end
			elseif tears == 1 then
				for i=45,315,90 do
					local tear = Isaac.Spawn(2, 13, 0, bomb.Position, Vector(0,11):Rotated(i), bomb):ToTear()
					tear:GetSprite():Load("gfx/002.043_key tear.anm2", true)
					tear:GetSprite():Play("Idle", true)
					tear.CollisionDamage = data.player.Damage
					tear.Scale = 0.5
					tear.SpriteScale = Vector(0.6,0.6)
					tear:AddTearFlags(TearFlags.TEAR_PIERCING)
				end
			end
		end
		if data.bloodBombsCherry then
			local creep = Isaac.Spawn(1000, 46, 0, bomb.Position, Vector.Zero, bomb)
			creep.SpriteScale = Vector(1.3,1.3)
			creep.CollisionDamage = data.player.Damage/2
		end
		if data.brimBombsCherry then
			for i=90,360,90 do
				local laser = EntityLaser.ShootAngle(1, bomb.Position, i, 12, Vector.Zero, data.player)
				if i == 90 then
					laser.DepthOffset = 500
				end
				laser.CollisionDamage = data.player.Damage*0.5
				mod:GetEntityData(laser).thinLaser = true
				laser.Parent = data.player
				laser.Size = 8
				laser.MaxDistance = 65
				laser:Update()
				laser.SpriteScale = Vector(0.5, 0.5)
				laser.DisableFollowParent = true
			end
			sfx:Stop(SoundEffect.SOUND_BLOOD_LASER)
			sfx:Play(SoundEffect.SOUND_BLOOD_LASER_SMALL, 0.8, 0, false, 1.1)
		end
		if data.ghostBombsCherry then
			local soul = Isaac.Spawn(1000, EffectVariant.PURGATORY, 1, bomb.Position, Vector.Zero, bomb):ToEffect()
			soul.Parent = data.player
			for i=1,39 do
				soul:Update()
			end
		end
		if data.nuggetBombsCherry then
			if mod.IsActiveRoom() and mod.GetEntityCount(3, 43) < 10 then
				local fly = Isaac.Spawn(3, 43, 0, bomb.Position, Vector.Zero, bomb):ToFamiliar()
				fly.Player = data.player
			end
		end
		--[[if data.bridgeBombsCherry then
			local room = game:GetRoom()
			local gridEnt = room:GetGridEntityFromPos(bomb.Position)
			if gridEnt and gridEnt:ToPit() then
				gridEnt:MakeBridge()
			end
		end]]
		if data.muscaCherry then
			if data.belialBombCherry then
				if mod.IsActiveRoom() and mod.GetEntityCount(3, 43) < 10 then
					local subt = rng:RandomInt(5) + 1
					local fly = Isaac.Spawn(3, 43, subt, bomb.Position, Vector.Zero, bomb):ToFamiliar()
					fly.Player = data.player
				end
			else
				if not mod.IsActiveRoom() or mod.GetEntityCount(3, 43) > 9 then
					mod.scheduleForUpdate(function()
						for _,loc in ipairs(Isaac.FindByType(3, 43, -1, false, false)) do
							if loc.FrameCount == 0 and loc.Position:Distance(bomb.Position) < 10 then
								loc:Remove()
							end
						end
					end, 0)
				end
			end
		end
		if data.slippyCherry then
			local cloud = Isaac.Spawn(mod.FF.SlippyFart.ID, mod.FF.SlippyFart.Var, mod.FF.SlippyFart.Sub, bomb.Position, Vector(0,0), bomb)
			sfx:Play(mod.Sounds.FartFrog1,0.2,0,false,math.random(80,120)/100)
			
			mod:GetEntityData(cloud).RadiusMult = 0.66
			cloud.SpriteScale = Vector(0.66, 0.66)
			
			if data.bomberBoyCherry then
				for i=90,360,90 do
					local newPos = bomb.Position+Vector(0,50):Rotated(i)
					local cloud = Isaac.Spawn(mod.FF.SlippyFart.ID, mod.FF.SlippyFart.Var, mod.FF.SlippyFart.Sub, newPos, Vector(0,0), bomb)
					mod:GetEntityData(cloud).RadiusMult = 0.66
					cloud.SpriteScale = Vector(0.66, 0.66)
				end
			end
		end
		if data.stickyBombsCherry then
			local creep = Isaac.Spawn(1000, 44, 0, bomb.Position, Vector.Zero, bomb)
			creep.SpriteScale = Vector(1.5, 1.5)
			creep:Update()
		end
		if data.bombSackCherry then
			local shockwave = Isaac.Spawn(1000, EffectVariant.ROCK_EXPLOSION, 0, bomb.Position, Vector.Zero, data.player):ToEffect()
            shockwave.DepthOffset = 50
            for _, enemy in ipairs(Isaac.FindInRadius(bomb.Position, 25, EntityPartition.ENEMY)) do
				if enemy:IsActiveEnemy() and (not mod:isFriend(enemy)) and enemy:IsVulnerableEnemy() then
					local damage = (data.player.Damage or 5)+5+2.5*level
					enemy:TakeDamage(damage, 0, EntityRef(shockwave), 0)
				end
			end
			sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 1, 0, false, 1)
		end
		if data.fabergeBombsCherry then
			for i=1,5 do
				local penny = Isaac.Spawn(5, PickupVariant.PICKUP_COIN, mod.PICKUP.COIN.LIL_PENNY, bomb.Position, rng:RandomVector()*(13+rng:RandomFloat()*5), data.player):ToPickup()
				penny:GetSprite():Play("AppearFast")
				mod:GetEntityData(penny).dangerousMode = data.player
				mod:GetEntityData(penny).CosmeticDoNotPickup = true
				penny.Timeout = 35
			end
		end
		
		local radius = 40
		if data.megaCherry then
			radius = 100
			explosion.SpriteScale = Vector(1,1)
			crater.SpriteScale = Vector(1,1)
		elseif data.FFIsScatter then
			radius = 20
			explosion.SpriteScale = Vector(0.55,0.55)
			crater.SpriteScale = Vector(0.4,0.4)
		end
		
		if data.buttBombsCherry then
			Game():ButterBeanFart(bomb.Position, radius, bomb, true, false)
		end

		if data.electrumCherry then
			mod:alternateElectrumShock(data.player, rng, data.electrumCherry+5*level, bomb.Position, 2)
		end

		if data.zipBombsCherry then
			--Nevermind, download failure never runs out
			local num = 0
			for _,enemy in ipairs(Isaac.FindInRadius(bomb.Position, radius, EntityPartition.ENEMY)) do
				if enemy:IsActiveEnemy() and (not mod:isFriend(enemy)) and (not enemy:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)) then
					if num == 0 then
						mod.AddOverloaded(enemy, data.player, 0, 2, data.player.Damage*0.25+level, 45, 15, true)
					else
						if not (enemy:IsBoss() or mod.DownloadFailureBlacklist[enemy.Type]) then
							mod:GetEntityData(enemy).DownloadFailuredManually = true
						end
					end
				end
			end
		end
		
		if not data.belialBombCherry then
			for _, enemy in ipairs(Isaac.FindInRadius(bomb.Position, radius, EntityPartition.ENEMY)) do
				if enemy:IsActiveEnemy() and (not mod:isFriend(enemy)) and (enemy:IsVulnerableEnemy() or mod:GetEntityData(enemy).FFCopperBombHitbox) then
					local damage = (data.player.Damage*2 or 10)+10+5*level
					if data.megaCherry then
						damage = damage+5*level
					end
					enemy:TakeDamage(damage, DamageFlag.DAMAGE_EXPLOSION | DamageFlag.DAMAGE_IGNORE_ARMOR, EntityRef(bomb), 0)
					if not enemy:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) then
						if data.bobsCurseCherry then
							enemy:AddPoison(EntityRef(bomb), 80, (data.player.Damage or 5))
						end
						if data.buttBombsCherry then
							enemy:AddConfusion(EntityRef(bomb), 80, false)
						end
					end
				end
			end
		end
		for _, pickup in ipairs(Isaac.FindInRadius(bomb.Position, radius, EntityPartition.PICKUP)) do
			local dist = (radius+70)/pickup.Position:Distance(bomb.Position)
			pickup.Velocity = (pickup.Position-bomb.Position):Resized(dist)
			if pickup.Velocity:Length() > 10 then
				pickup.Velocity = pickup.Velocity:Resized(10)
			end
		end
		
		Isaac.RunCallback(FiendFolio.CALLBACK.POST_CHERRY_BOMB_EXPLODE, bomb:ToBomb())
	end
end, 4)

mod:AddCallback(ModCallbacks.MC_PRE_BOMB_COLLISION, function(_, bomb, coll, bool)
	if coll:ToNPC() and mod:GetEntityData(bomb).stickyBombsCherry then
		mod:GetEntityData(bomb).stickedEnemy = coll
		mod:GetEntityData(bomb).stickedPosition = (bomb.Position-coll.Position)
		mod:GetEntityData(bomb).stuckOffset = bomb.PositionOffset.Y
	end
	if coll and coll:ToNPC() and mod:GetEntityData(bomb).rocketJarCherry then
		mod:GetEntityData(bomb).timer = 0
	end
end, mod.FF.CherryBomb.Var)

function mod:cherryBombWisp(wisp)
	local data = mod:GetEntityData(wisp)
	if wisp.FrameCount < 6 and not data.cherryBomb then
		for _,bomb in ipairs(Isaac.FindByType(4, mod.FF.CherryBomb.Var, -1, false, false)) do
			if bomb.FrameCount < 6 then
				data.cherryBomb = bomb
			end
		end
	end

	if not data.cherryBomb or not data.cherryBomb:Exists() and wisp.FrameCount > 5 then
		wisp:Remove()
		local explosion = Isaac.Spawn(1000, 1, 0, wisp.Position, Vector.Zero, wisp):ToEffect()
		explosion.SpriteScale = Vector(0.6, 0.6)
		explosion.DepthOffset = 10
		local crater = Isaac.Spawn(1000, 18, 0, wisp.Position, Vector.Zero, wisp):ToEffect()
		crater.SpriteScale = Vector(0.6, 0.6)

		for _, enemy in ipairs(Isaac.FindInRadius(wisp.Position, 30, EntityPartition.ENEMY)) do
			if enemy:IsActiveEnemy() and (not mod:isFriend(enemy)) and (enemy:IsVulnerableEnemy() or mod:GetEntityData(enemy).FFCopperBombHitbox) then
				local damage = 15
				enemy:TakeDamage(damage, DamageFlag.DAMAGE_EXPLOSION | DamageFlag.DAMAGE_IGNORE_ARMOR, EntityRef(wisp), 0)
			end
		end
		for _, pickup in ipairs(Isaac.FindInRadius(wisp.Position, 30, EntityPartition.PICKUP)) do
			local dist = (100)/pickup.Position:Distance(wisp.Position)
			pickup.Velocity = (pickup.Position-wisp.Position):Resized(dist)
			if pickup.Velocity:Length() > 10 then
				pickup.Velocity = pickup.Velocity:Resized(10)
			end
		end
	end
end