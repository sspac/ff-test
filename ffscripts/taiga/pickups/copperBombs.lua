-- Copper Bombs --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local flag = TearFlagsLib.RegisterTearFlag("COPPER_BOMB")

function mod:isCopperVariant(var)
	return mod.CopperBombVariants[var]
end

-- all this shit because there's no way to tell if a bomb is supposed to be a dr fetus bomb in pre ent spawn weeeeeeeeeeeeeeeeeeeeeeeeee
function mod:copperPostFireBomb(player, bomb, isFetus)
	local data = mod:GetEntityData(bomb)
	local playerDud = player and player:HasTrinket(mod.ITEM.TRINKET.DUDS_FLOWER)
	if not data.TriedLoadingFFCopperBomb then
		local var = bomb.Variant
		data.FFCopperBomb = mod:isCopperVariant(var)
		
		if isFetus then
			if playerDud then
				data.FFCopperBomb = true
			end
		elseif (var == BombVariant.BOMB_NORMAL or
		    var == BombVariant.BOMB_ROCKET or
		    var == FiendFolio.BOMB.NUGGET or
		    var == FiendFolio.BOMB.LOCUST or
		    var == FiendFolio.BOMB.SLIPPY or
		    var == FiendFolio.BOMB.BRIDGE or
		    var == FiendFolio.BOMB.FABERGE or
		    var == FiendFolio.BOMB.ZIP or
			var == FiendFolio.BOMB.PARALLEL or
			var == FiendFolio.BOMB.GREEN or
			var == FiendFolio.BOMB.SHUFFLE
			or playerDud) and
		   bomb.SpawnerEntity and
		   bomb.SpawnerEntity.Type == EntityType.ENTITY_PLAYER and
		   mod:GetEntityData(bomb.SpawnerEntity).ffsavedata ~= nil and
		   ((mod:GetEntityData(bomb.SpawnerEntity).ffsavedata.FFCopperBombsStored ~= nil and
		   mod:GetEntityData(bomb.SpawnerEntity).ffsavedata.FFCopperBombsStored > 0)
		   or playerDud)
		then
			data.FFCopperBomb = true
			--Sorry taiga for messing with your nice code
			if playerDud then
				local numBombs = bomb.SpawnerEntity:ToPlayer():GetNumBombs()
				if mod:GetEntityData(bomb.SpawnerEntity).ffsavedata.FFCopperBombsStored ~= nil and
					mod:GetEntityData(bomb.SpawnerEntity).ffsavedata.FFCopperBombsStored > numBombs
				then
					mod:GetEntityData(bomb.SpawnerEntity).ffsavedata.FFCopperBombsStored = numBombs
				end
			else
				mod:GetEntityData(bomb.SpawnerEntity).ffsavedata.FFCopperBombsStored = mod:GetEntityData(bomb.SpawnerEntity).ffsavedata.FFCopperBombsStored - 1
			end
		end
		
		if data.FFCopperBomb then
			if bomb.Variant == BombVariant.BOMB_NORMAL then
				bomb.Variant = FiendFolio.BOMB.COPPER
			elseif bomb.Variant == BombVariant.BOMB_ROCKET then
				-- FUCK YOU IN PARTICULAR NO SUBTYPE BOMBCOSTUMES STINK DUMB
				local sprite = bomb:GetSprite()
				local path = Isaac.GetPlayer():HasGoldenBomb() and "rocket_gold" or "rocket"
				sprite:ReplaceSpritesheet(0, "gfx/items/pick ups/bombs/copper/costumes/" .. path .. ".png")
				sprite:LoadGraphics()
			elseif bomb.Variant == FiendFolio.BOMB.NUGGET then
				bomb.Variant = FiendFolio.BOMB.NUGGET_COPPER
			elseif bomb.Variant == FiendFolio.BOMB.LOCUST then
				bomb.Variant = FiendFolio.BOMB.LOCUST_COPPER
			elseif bomb.Variant == FiendFolio.BOMB.SLIPPY then
				bomb.Variant = FiendFolio.BOMB.SLIPPY_COPPER
			elseif bomb.Variant == FiendFolio.BOMB.BRIDGE then
				bomb.Variant = FiendFolio.BOMB.BRIDGE_COPPER
			elseif bomb.Variant == FiendFolio.BOMB.FABERGE then
				bomb.Variant = FiendFolio.BOMB.FABERGE_COPPER
			elseif bomb.Variant == FiendFolio.BOMB.ZIP then
				bomb.Variant = FiendFolio.BOMB.ZIP_COPPER
			elseif bomb.Variant == FiendFolio.BOMB.PARALLEL then
				bomb.Variant = FiendFolio.BOMB.PARALLEL_COPPER
			elseif bomb.Variant == FiendFolio.BOMB.GREEN then
				bomb.Variant = FiendFolio.BOMB.GREEN_COPPER
			elseif bomb.Variant == FiendFolio.BOMB.SHUFFLE then
				bomb.Variant = FiendFolio.BOMB.SHUFFLE_COPPER
			else
				bomb.Variant = FiendFolio.BOMB.COPPER
			end
			
			bomb.ExplosionDamage = bomb.ExplosionDamage * 1.85
			if isFetus then
				bomb.RadiusMultiplier = bomb.RadiusMultiplier * 1.25
			end
			
			if bomb.Variant ~= BombVariant.BOMB_ROCKET then
				bomb.Flags = bomb.Flags -- ????????????????????????????????????????????????? WHY DO I NEED TO DO THIS WHY DOES THIS REFRESH THE SPRITE WHY
			end
		end
		
		mod:GetEntityData(bomb).TriedLoadingFFCopperBomb = true
	end
end

local CopperBombData = {
	[FiendFolio.PICKUP.BOMB.COPPER] 		= {Bombs = 1, Coppers = 1, SPitch = 1},
	[FiendFolio.PICKUP.BOMB.DOUBLE_COPPER] 	= {Bombs = 2, Coppers = 2, SPitch = 0.975},
	[FiendFolio.PICKUP.BOMB.MIXED_DOUBLE] 	= {Bombs = 2, Coppers = 1, SPitch = 0.975},
}

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider, low)
	--if mod:EpiphanyPickupCheck(pickup, collider) then return end

	if CopperBombData[pickup.SubType] then
		if collider.Type == 1 and mod:GetEntityData(collider).ffsavedata then
			local player = collider:ToPlayer()
			if pickup:IsShopItem() and pickup.Price > player:GetNumCoins() then
				Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, collider, low)
				return true
			else
				if pickup:GetSprite():WasEventTriggered("DropSound") or pickup:GetSprite():IsPlaying("Idle") or pickup:GetSprite():IsFinished("Idle") then
					local amount = CopperBombData[pickup.SubType].Bombs
					if TBBCoopFix and player:GetPlayerType() == PlayerType.PLAYER_BLUEBABY_B then
						TBBCoopFix:AddBombsAsTBB(player, amount, true)
					else
						player:AddBombs(amount)
					end
					mod:GetEntityData(player).ffsavedata.FFCopperBombsStored = (mod:GetEntityData(player).ffsavedata.FFCopperBombsStored or 0) + CopperBombData[pickup.SubType].Coppers
					
					pickup:GetSprite():Play("Collect")
					sfx:Play(FiendFolio.Sounds.CopperBombPickup, 0.2, 0, false, CopperBombData[pickup.SubType].SPitch)
					sfx:Play(SoundEffect.SOUND_FETUS_FEET, 2, 0, false, CopperBombData[pickup.SubType].SPitch)

					pickup.Velocity = nilvector
					pickup.Touched = true
					pickup.EntityCollisionClass = 0

					if pickup:IsShopItem() then
						player:AddCoins(-1 * pickup.Price)
					end

					if pickup.OptionsPickupIndex ~= 0 then
						local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP)
						for _, entity in ipairs(pickups) do
							if entity:ToPickup().OptionsPickupIndex == pickup.OptionsPickupIndex and
							   (entity.Index ~= pickup.Index or entity.InitSeed ~= pickup.InitSeed)
							then
								Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, nilvector, nil)
								entity:Remove()
							end
						end
					end
			
					Game():SetStateFlag(GameStateFlag.STATE_HEART_BOMB_COIN_PICKED, true)
					
					pickup:Die()
				end
				Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, collider, low)
				return true
			end
		else
			Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, collider, low)
			return false
		end
	end
end, PickupVariant.PICKUP_BOMB)

mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, function(_, bomb)
	local var = bomb.Variant
	local data = mod:GetEntityData(bomb)
	if not data.FFCopperBomb and
	   (var == FiendFolio.BOMB.COPPER or 
	    var == FiendFolio.BOMB.NUGGET_COPPER or 
	    var == FiendFolio.BOMB.LOCUST_COPPER or 
	    var == FiendFolio.BOMB.SLIPPY_COPPER or 
	    var == FiendFolio.BOMB.BRIDGE_COPPER or
	    var == FiendFolio.BOMB.TROLL_COPPER or
		(var == BombVariant.BOMB_TROLL and bomb.SubType == 160))
	then
		data.FFCopperBomb = true
		data.FFCopperBombWasADud = bomb.SubType == 923
	end
	
	if data.FFCopperBomb then
		local sprite = bomb:GetSprite()
		
		if bomb.Child == nil then
			local hitbox = Isaac.Spawn(mod.FF.Hitbox.ID, mod.FF.Hitbox.Var, 0, bomb.Position, Vector.Zero, bomb)
			local hdata = mod:GetEntityData(hitbox)
			hdata.PositionOffset = nilvector
			hdata.FixToSpawner = true
			hdata.AllowKnockback = false
			hdata.FFCopperBombHitbox = true
			hdata.IgnoreTearFlagEffects = true
			hitbox.CollisionDamage = 0
			hitbox.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
			hitbox.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
			
			hdata.OnHurt = function(npc, damage, flag, source, countdown)
				if flag & DamageFlag.DAMAGE_EXPLOSION == DamageFlag.DAMAGE_EXPLOSION then
					if npc.SpawnerEntity ~= nil and 
					   npc.SpawnerEntity:Exists() and
					   npc.SpawnerEntity:ToBomb() and 
					   mod:GetEntityData(npc.SpawnerEntity).FFCopperBomb and 
					   npc.SpawnerEntity:GetSprite():GetAnimation() ~= "Explode" and
					   not (source and 
					        source.Entity and 
					        source.Entity.InitSeed == npc.SpawnerEntity.InitSeed and 
					        source.Entity.Index == npc.SpawnerEntity.Index)
					then
						npc.SpawnerEntity:GetSprite():Play("Pulse", true)
						npc.SpawnerEntity:ToBomb():SetExplosionCountdown(0)
						mod:GetEntityData(npc.SpawnerEntity).FFCopperBombForcingExplosion = true
					end
				end
				return false
			end
			
			hdata.OnCollide = function(npc1, npc2, first)
				return true
			end
			
			bomb.Child = hitbox
		end
		
		if data.FFCopperBombWasADud then
			if bomb.Visible and not data.FFCopperBombForcingExplosion then
				if var == FiendFolio.BOMB.TROLL_COPPER then
					sprite:Play("Idle", true)
				else
					sprite:Play("Defuse", true)
				end
				bomb:SetExplosionCountdown(9999)
			end
		elseif var == BombVariant.BOMB_TROLL and sprite:IsPlaying("Pulse") and sprite:GetFrame() == 57 then
			if mod.anyPlayerHas(TrinketType.TRINKET_SAFETY_SCISSORS, true) then
				local newbomb = Isaac.Spawn(5, 40, FiendFolio.PICKUP.BOMB.COPPER, bomb.Position, bomb.Velocity, nil)
				newbomb:GetSprite():Play("Idle")
				newbomb.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
				newbomb:Update()

				local poof = Isaac.Spawn(1000, 15, 0, bomb.Position, Vector.Zero, nil)
				poof.SpriteScale = poof.SpriteScale * 0.5
				poof:Update()

				bomb:Remove()
			end
		elseif sprite:IsPlaying("Pulse") and sprite:GetFrame() == 58 then
			local rng = RNG()
			rng:SetSeed(bomb.InitSeed, 0)

			local bombChance = rng:RandomFloat()

			-- Copper Wrench: temp buffed dud chance until you get at least one
			for i=1, game:GetNumPlayers() do
				local p = Isaac.GetPlayer(i)
				if p:GetEffects():HasCollectibleEffect(mod.ITEM.COLLECTIBLE.COPPER_WRENCH) then
					if bombChance < 0.80 then
						bombChance = 0
						p:GetEffects():RemoveCollectibleEffect(mod.ITEM.COLLECTIBLE.COPPER_WRENCH, -1)
					end
				end
			end

			if bombChance > 0.5 then
				if rng:RandomFloat() < 0.00001 then
					sfx:Play(FiendFolio.Sounds.CopperBombSuccess, 1.0, 0, false, 1.0)
				end
			else
				if not bomb.Visible then
					sfx:Play(FiendFolio.Sounds.CopperBombSizzle, 1.2, 0, false, 1.25 + math.random() * 0.25)
					bomb:Remove()
				else
					data.FFCopperBombWasADud = true
					--Weird code I know
					if bomb.Variant == BombVariant.BOMB_TROLL then
						bomb.Variant = FiendFolio.BOMB.TROLL_COPPER
						
						if not mod:SpawnCopperBotFly(bomb) then
							sfx:Play(FiendFolio.Sounds.BrownedBoowomp, 1, 0, false, 0.9 + math.random() * 0.2)
						end
					else
						if not FiendFolio.ACHIEVEMENT.DUDS_FLOWER:IsUnlocked(true) then
							FiendFolio.ACHIEVEMENT.DUDS_FLOWER:Unlock()
						end
						mod:SpawnCopperBotFly(bomb)
						
						if mod.anyPlayerHas(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE, true) then
							mod:makeShampooText("CopperBombDud", bomb:GetDropRNG())
						end
					end

					bomb.SubType = 923
					if var == FiendFolio.BOMB.TROLL_COPPER then
						sprite:Play("Idle", true)
					else
						sprite:Play("Defuse", true)
					end
					bomb:SetExplosionCountdown(9999)
					bomb.ExplosionDamage = bomb.ExplosionDamage / 1.85
					
					sfx:Play(FiendFolio.Sounds.CopperBombSizzle, 1.2, 0, false, 1.25 + math.random() * 0.25)
					
					for i = 1, 2 do
						local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, 
												bomb.Position, 
												RandomVector() * (math.random() / 2 + 0.5) * 3, 
												bomb)
						smoke.SpriteOffset = Vector(0,-20)
						smoke.SpriteScale = Vector(0.7, 0.7)
						smoke.DepthOffset = 10
					end
				end
			end
		end
	end
end)

local dudBombs = {}
mod:AddPriorityCallback(ModCallbacks.MC_PRE_USE_ITEM, CallbackPriority.LATE, function(_, item, rng, player, flags, slot, vardata)
	local bombs = Isaac.FindByType(4)
	for _, bomb in ipairs(bombs) do
		local bomb = bomb:ToBomb()
		local var = bomb.Variant
		local data = mod:GetEntityData(bomb)
		if not data.FFCopperBomb and
		   (var == FiendFolio.BOMB.COPPER or 
		    var == FiendFolio.BOMB.NUGGET_COPPER or 
		    var == FiendFolio.BOMB.LOCUST_COPPER or 
		    var == FiendFolio.BOMB.SLIPPY_COPPER or 
		    var == FiendFolio.BOMB.BRIDGE_COPPER or
		    var == FiendFolio.BOMB.TROLL_COPPER)
		then
			data.FFCopperBomb = true
			data.FFCopperBombWasADud = bomb.SubType == 923
		end
		
		if data.FFCopperBomb then
			local rng = RNG()
			rng:SetSeed(bomb.InitSeed, 0)
			if (data.FFCopperBombForcingExplosion or not data.FFCopperBombWasADud) and rng:RandomFloat() > 0.5 then
				--explode
			else
				local sprite = bomb:GetSprite()
				
				if not data.FFCopperBombWasADud then
					sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS, 1, 0, false, 1.5)
					
					for i = 1, 2 do
						local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, 
												  bomb.Position, 
												  RandomVector() * (math.random() / 2 + 0.5) * 3, 
												  bomb)
						smoke.SpriteOffset = Vector(0,-20)
						smoke.SpriteScale = Vector(0.7, 0.7)
						smoke.DepthOffset = 10
					end
				end
				
				data.FFCopperBombWasADud = true
				bomb.SubType = 923

				if var == FiendFolio.BOMB.TROLL_COPPER then
					sprite:Play("Idle", true)
				else
					sprite:Play("Defuse", true)
				end

				bomb:SetExplosionCountdown(9999)
				bomb.ExplosionDamage = bomb.ExplosionDamage / 1.85
				
				data.FFCopperOriginalVariant = bomb.SpawnerEntity
				bomb.SpawnerEntity = nil
				table.insert(dudBombs, bomb)
			end
		end
	end
end, CollectibleType.COLLECTIBLE_REMOTE_DETONATOR)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, item, rng, player, flags, slot, vardata)
	for _, bomb in pairs(dudBombs) do
		if bomb:Exists() then
			bomb.SpawnerEntity = mod:GetEntityData(bomb).FFCopperOriginalSpawnerEntity
			mod:GetEntityData(bomb).FFCopperOriginalSpawnerEntity = nil
		end
	end
	dudBombs = {}
end, CollectibleType.COLLECTIBLE_REMOTE_DETONATOR)

local bombuisprite = nil

function mod:UpdateCopperBombs()
	local gold = false
	local copper = false
    local players = Isaac.FindByType(1, -1, -1, false, false)
    for _, p in pairs(players) do
		if p:ToPlayer():GetNumGigaBombs() > 0 then
			bombuisprite = nil
			return
		end
	end
    for _, p in pairs(players) do
		local rng = RNG()
		rng:SetSeed(p.InitSeed, 0)
		if mod:GetEntityData(p).ffsavedata and mod:GetEntityData(p).ffsavedata.FFCopperBombsStored and mod:GetEntityData(p).ffsavedata.FFCopperBombsStored > 0
		or p:ToPlayer():HasTrinket(mod.ITEM.TRINKET.DUDS_FLOWER)
		then
			copper = true
			for _, pAux in pairs(players) do
				if pAux:ToPlayer():HasGoldenBomb() then
					gold = true
					break
				end
			end
			break
		end
	end
	if not copper and bombuisprite then
		bombuisprite = nil
	end
	if copper and not bombuisprite then
		bombuisprite = Sprite()
		bombuisprite:Load("gfx/ui/bomb_copper.anm2", true)
		if gold then
			bombuisprite:Play("Gold", true)
		else
			bombuisprite:Play("Single", true)
		end
	end
	if bombuisprite then
		if gold then
			bombuisprite:Play("Gold", true)
		else
			bombuisprite:Play("Single", true)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.UpdateCopperBombs)
mod:AddPriorityCallback(ModCallbacks.MC_POST_GAME_STARTED, CallbackPriority.LATE, mod.UpdateCopperBombs)

mod:AddCallback(ModCallbacks.MC_POST_HUD_RENDER, function()
	if bombuisprite and game:GetHUD():IsVisible() then
		local offset = Options.HUDOffset * Vector(20, 12) + Vector(8, 52)
		--A third vector has hit the copper bomb
		if REPENTANCE_PLUS then
			offset = offset + Vector(0,2)
		end
		local firstPlayerType = Isaac.GetPlayer():GetPlayerType()
		if firstPlayerType == PlayerType.PLAYER_JACOB then
			offset = offset + Vector(0, 14)
		elseif firstPlayerType == PlayerType.PLAYER_BETHANY or firstPlayerType == PlayerType.PLAYER_BETHANY_B then
			offset = offset - Vector(0, 1)
		end
		bombuisprite:Render(offset, Vector.Zero, Vector.Zero)
	end
end)
