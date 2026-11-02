local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local BrickFlags = {
	SMELTED = 1<<0,
	GOLDEN = 1<<1,
	BLASPHEMOUS = 1<<2,
}

--Currently unused
--[[function mod:brickRockFire(player, tear, rng, pdata, tdata)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.BRICK_ROCK) then
        tear.Variant = TearVariant.STONE
        tear:GetSprite():Load("gfx/projectiles/fortune_cookie_tear.anm2", true)
        tear.CollisionDamage = 15
        tear.Velocity = tear.Velocity*1.3
        player:TryRemoveTrinket(FiendFolio.ITEM.ROCK.BRICK_ROCK)
        tdata.IsBrickTear = true
        tdata.customtype = "brick"
    end
end]]

function mod:spawnBrickTrinket(tear)
    if not game:IsPaused() then 
		sfx:Play(SoundEffect.SOUND_POT_BREAK, 0.6, 0, false, 1.5)
	end
	if tear.Child and tear.Child:Exists() then
		tear.Child:Remove()
		tear.Child = nil
	end
	local tempOverride = StageAPI.TemporaryIgnoreSpawnOverride
	StageAPI.TemporaryIgnoreSpawnOverride = true
	local brick
	if tear.SubType & BrickFlags.SMELTED == BrickFlags.SMELTED then
		local effectsub = 0
		if tear.SubType & BrickFlags.GOLDEN == BrickFlags.GOLDEN then
			effectsub = effectsub | BrickFlags.GOLDEN
		end
		if tear.SubType & BrickFlags.BLASPHEMOUS == BrickFlags.BLASPHEMOUS then
			effectsub = effectsub | BrickFlags.BLASPHEMOUS
		end
		brick = Isaac.Spawn(5, FiendFolio.PICKUP.VARIANT.SMELTED_BRICK_ROCK, effectsub, tear.Position, tear.Velocity:Resized(5):Rotated(120 + math.random(120)), tear):ToPickup()
	else
		local trinketsub = FiendFolio.ITEM.ROCK.BRICK_ROCK
		if tear.SubType & BrickFlags.GOLDEN == BrickFlags.GOLDEN then
			trinketsub = FiendFolio.ITEM.ROCK.BRICK_ROCK + TrinketType.TRINKET_GOLDEN_FLAG
		end
		brick = Isaac.Spawn(5, 350, trinketsub, tear.Position, tear.Velocity:Resized(5):Rotated(120 + math.random(120)), tear):ToPickup()
		if tear.SubType & BrickFlags.BLASPHEMOUS == BrickFlags.BLASPHEMOUS then
			mod:MakePickupTrinketBlasphemous(brick)
		end
	end
	StageAPI.TemporaryIgnoreSpawnOverride = tempOverride
	local sprite = brick:GetSprite()
    sprite:Play("Appear")
    sprite:SetFrame(7)
	brick.Touched = true
	mod:HiddenPickupHandling(brick)
end

function mod:brickRockUpdate(tear, tdata)
    --[[if tear:IsDead() and tdata.IsBrickTear then
        mod:spawnBrickTrinket(tear)
    end]]--
	if tdata.IsBrickTear and tear.SubType & BrickFlags.GOLDEN == BrickFlags.GOLDEN then
		tdata.sparkleCooldown = (tdata.sparkleCooldown or math.random(3) + 3) - 1
		if tdata.sparkleCooldown <= 0 then
			local expvec = (Vector.FromAngle(tear.Velocity:GetAngleDegrees() - 180) * math.random(10,20)):Rotated(math.random(-30,30))
			local sparkle = Isaac.Spawn(1000, 1727, 0, tear.Position + expvec * 0.1, expvec * 0.3, tear):ToEffect()
			sparkle.SpriteOffset = Vector(0,-15)
			sparkle:Update()
			
			tdata.sparkleCooldown = nil
		end
	end
end

--[[function mod:brickRockColl(tear, ent, tdata)
    if tdata.IsBrickTear then
        mod:spawnBrickTrinket(tear)
    end
end]]--

function mod:brickRockPlayer(player)
    if player:HasTrinket(FiendFolio.ITEM.ROCK.BRICK_ROCK) then
		local data = mod:GetEntityData(player)
		data.SmeltedBrickData = data.SmeltedBrickData or {}
		
		local t1 = player:GetTrinket(1)
		local t0 = player:GetTrinket(0)
		local smeltedBricks = player:GetSmeltedTrinkets({FiendFolio.ITEM.ROCK.BRICK_ROCK})[FiendFolio.ITEM.ROCK.BRICK_ROCK]
		
		local brickInSlot1 = mod:GetRealTrinketId(t1) == FiendFolio.ITEM.ROCK.BRICK_ROCK
		local brickInSlot0 = mod:GetRealTrinketId(t0) == FiendFolio.ITEM.ROCK.BRICK_ROCK
		
		if not brickInSlot1 and not brickInSlot0 and
		   smeltedBricks.goldenTrinketAmount <= (data.SmeltedBrickData.BlasphemousGoldenTossed or 0) + (data.SmeltedBrickData.GoldenTossed or 0) and
		   smeltedBricks.trinketAmount <= (data.SmeltedBrickData.BlasphemousTossed or 0) + (data.SmeltedBrickData.RegularTossed or 0)
		then
			return
		end
		
        player.FireDelay = math.max(player.MaxFireDelay, 1)
        local aim = player:GetAimDirection()
        if mod:canUseDrawnItem(player, mod.DrawnItemTypes.BrickRock, aim) then
			data.FFdrawnItemCooldown = player.MaxFireDelay
			
			local isGolden = false
			local isSmelted = false
			local isBlasphemous = false
			
			if brickInSlot0 or brickInSlot1 then
				isGolden = mod:IsGoldTrinket(brickInSlot0 and t0 or t1)
				isBlasphemous = mod:IsPlayerTrinketBlasphemous(player, brickInSlot0 and 0 or 1)
				player:TryRemoveTrinket(FiendFolio.ITEM.ROCK.BRICK_ROCK)
			else
				if smeltedBricks then
					if smeltedBricks.goldenTrinketAmount > (data.SmeltedBrickData.BlasphemousGoldenTossed or 0) + (data.SmeltedBrickData.GoldenTossed or 0) then
						isGolden = true
						isSmelted = true
						
						local numBlasphemous = 0
						local smeltedGoldenTracked = mod.TrinketTracker:GetSmelted(player, FiendFolio.ITEM.ROCK.BRICK_ROCK + TrinketType.TRINKET_GOLDEN_FLAG)
						for _, trackedTrinket in pairs(smeltedGoldenTracked) do
							if trackedTrinket.Data.IsBlasphemousTrinket then
								numBlasphemous = numBlasphemous + 1
							end
						end
						isBlasphemous = numBlasphemous > (data.SmeltedBrickData.BlasphemousGoldenTossed or 0)
						
						--player:TryRemoveSmeltedTrinket(FiendFolio.ITEM.ROCK.BRICK_ROCK + TrinketType.TRINKET_GOLDEN_FLAG)
						if isBlasphemous then
							data.SmeltedBrickData.BlasphemousGoldenTossed = (data.SmeltedBrickData.BlasphemousGoldenTossed or 0) + 1
						else
							data.SmeltedBrickData.GoldenTossed = (data.SmeltedBrickData.GoldenTossed or 0) + 1
						end
					elseif smeltedBricks.trinketAmount > (data.SmeltedBrickData.BlasphemousTossed or 0) + (data.SmeltedBrickData.RegularTossed or 0) then
						isSmelted = true
						
						local numBlasphemous = 0
						local smeltedTracked = mod.TrinketTracker:GetSmelted(player, FiendFolio.ITEM.ROCK.BRICK_ROCK)
						for _, trackedTrinket in pairs(smeltedTracked) do
							if trackedTrinket.Data.IsBlasphemousTrinket then
								numBlasphemous = numBlasphemous + 1
							end
						end
						isBlasphemous = numBlasphemous > (data.SmeltedBrickData.BlasphemousTossed or 0)
						
						--player:TryRemoveSmeltedTrinket(FiendFolio.ITEM.ROCK.BRICK_ROCK)
						if isBlasphemous then
							data.SmeltedBrickData.BlasphemousTossed = (data.SmeltedBrickData.BlasphemousTossed or 0) + 1
						else
							data.SmeltedBrickData.RegularTossed = (data.SmeltedBrickData.RegularTossed or 0) + 1
						end
					end
				end
			end
			
			local tearsub = 0
			if isGolden then
				tearsub = tearsub | BrickFlags.GOLDEN
			end
			if isBlasphemous then
				tearsub = tearsub | BrickFlags.BLASPHEMOUS
			end
			if isSmelted then
				tearsub = tearsub | BrickFlags.SMELTED
			end
		
            local vec = player:GetAimDirection():Resized(player.ShotSpeed * 13) + player:GetTearMovementInheritance(aim)
            local tear = Isaac.Spawn(2, mod.TEAR.BRICK, tearsub, player.Position, vec, player):ToTear()
            tear.SpawnerEntity = player
            --tear:GetSprite():Load("gfx/projectiles/brick_rock.anm2", true)
            --tear:GetSprite():Play("Stone1Move", true)
            tear.TearFlags = tear.TearFlags | TearFlags.TEAR_CONFUSION
            local tdata = mod:GetEntityData(tear)
            tdata.IsBrickTear = true
            tdata.customtype = "brick"
            --sfx:Stop(SoundEffect.SOUND_TEARS_FIRE)
            sfx:Play(SoundEffect.SOUND_SHELLGAME, 1, 0, false, math.random(70,80)/100)
			
			local brickGfx
			if isSmelted then
				local effectsub = 0
				if isGolden then
					effectsub = effectsub | BrickFlags.GOLDEN
				end
				if isBlasphemous then
					effectsub = effectsub | BrickFlags.BLASPHEMOUS
				end
				brickGfx = Isaac.Spawn(5, FiendFolio.PICKUP.VARIANT.SMELTED_BRICK_ROCK, effectsub, tear.Position, nilvector, player):ToPickup()
			else
				local trinketsub = FiendFolio.ITEM.ROCK.BRICK_ROCK
				if isGolden then
					trinketsub = FiendFolio.ITEM.ROCK.BRICK_ROCK + TrinketType.TRINKET_GOLDEN_FLAG
				end
				brickGfx = Isaac.Spawn(5, 350, trinketsub, tear.Position, nilvector, player):ToPickup()
				if isBlasphemous then
					mod:MakePickupTrinketBlasphemous(brickGfx)
				end
			end
			
			brickGfx.Parent = tear
			brickGfx.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			brickGfx.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
			brickGfx.Visible = false
			local brickGfxData = mod:GetEntityData(brickGfx)
			brickGfxData.IsGfxBrick = true
			brickGfxData.ReplacedByVeil = false
			brickGfxData.BrickFollowParent = true
			local sprite = brickGfx:GetSprite()
			sprite:Load("gfx/projectiles/brick_rock.anm2", true)
			sprite:Play("Stone1Move", true)
			if brickGfx.Variant == FiendFolio.PICKUP.VARIANT.SMELTED_BRICK_ROCK then
				if isGolden then 
					sprite:SetRenderFlags(sprite:GetRenderFlags() | AnimRenderFlags.GOLDEN)
				end
			else
				brickGfx:AddEntityFlags(EntityFlag.FLAG_NO_QUERY)
			end
			tear.Child = brickGfx
			mod:HiddenPickupHandling(brickGfx)
			
			local trackedTrinket = mod.TrinketTracker:GetDataForPickup(brickGfx)
			if trackedTrinket and trackedTrinket.Data.IsBlasphemousTrinket then
				tear.SubType = tear.SubType | BrickFlags.BLASPHEMOUS
			end
			
			tear.CollisionDamage = 15
			if isGolden then
				tear.CollisionDamage = tear.CollisionDamage + 15
			end
			if (trackedTrinket and trackedTrinket.Data.IsBlasphemousTrinket) or isBlasphemous then
				tear.CollisionDamage = tear.CollisionDamage + 15
			end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) then
				tear.CollisionDamage = tear.CollisionDamage + 15
			end
			if data.OverclockTime and data.OverclockTime > 0 and not isSmelted then
				tear.CollisionDamage = tear.CollisionDamage + 15
			end
			if isSmelted and not (data.OverclockTime and data.OverclockTime > 0) then
				tear.CollisionDamage = tear.CollisionDamage * 2/3
			end
        end
    end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, FiendFolio.ITEM.ROCK.BRICK_ROCK, mod.brickRockPlayer)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, trinket)
	local realTrinketId = mod:GetRealTrinketId(trinket.SubType)
	if realTrinketId == FiendFolio.ITEM.ROCK.BRICK_ROCK then
		if mod:GetEntityData(trinket).BrickFollowParent then
			trinket.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			trinket.Visible = false
			trinket.Velocity = nilvector
			
			if trinket.Parent and trinket.Parent:Exists() then
				trinket.Position = trinket.Parent.Position
			else
				trinket:Remove()
			end
		elseif Isaac.GetChallenge() == mod.challenges.brickByBrick then
			local player = Isaac.GetPlayer(0)
			local speed = 2.5
			local trackedTrinket = mod.TrinketTracker:GetDataForPickup(trinket)
			if trinket.SubType == FiendFolio.ITEM.ROCK.BRICK_ROCK + TrinketType.TRINKET_GOLDEN_FLAG or (trackedTrinket and trackedTrinket.Data.IsBlasphemousTrinket) then
				speed = 1
			end
			if game:GetRoom():IsClear() then speed = 3 end
			trinket.Velocity = (player.Position - trinket.Position):Resized(speed)
			trinket.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
		end
	end
end, 350)

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, trinket, collider, low)
	if mod:GetRealTrinketId(trinket.SubType) == FiendFolio.ITEM.ROCK.BRICK_ROCK and
	   trinket.Touched and
	   collider.Type == EntityType.ENTITY_PLAYER and
	   collider.Variant == 0 and
	   not mod:GetEntityData(trinket).IsGfxBrick
	then
		local player = collider:ToPlayer()
		local data = mod:GetEntityData(player).ffsavedata

		if player.Parent == nil and -- Strawman and Soulstones
		   not player:IsCoopGhost() and
		   player:IsExtraAnimationFinished()
		then
			-- Bypass streak text; fake pickup behaviour time
			local t0 = player:GetTrinket(0)
			local t1 = player:GetTrinket(1)
			
			if t0 ~= 0 and (not player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_PURSE) or t1 ~= 0) then
				player:DropTrinket(player.Position, true)
			end
			
			player:AddTrinket(trinket.SubType)
			player:AnimateTrinket(FiendFolio.ITEM.ROCK.BRICK_ROCK, "HideItem", "PlayerPickup")
			sfx:Play(SoundEffect.SOUND_SHELLGAME, 1, 0, false, 1, 0)
			
			if mod:IsGoldTrinket(trinket.SubType) then
				player:GetHeldSprite():SetRenderFlags(player:GetHeldSprite():GetRenderFlags() | AnimRenderFlags.GOLDEN)
			end
			if mod:IsPickupTrinketBlasphemous(trinket) then
				mod:AddBlasphemousShader(player:GetHeldSprite())
			end
			
			trinket.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			trinket.Visible = false
			trinket:Remove()
		end

		return false
	end
end, PickupVariant.PICKUP_TRINKET)

function mod:brickTearRender(tear, var, data, offset)
	local brickGfx = tear.Child
	if not brickGfx then
		if tear.SubType & BrickFlags.SMELTED == BrickFlags.SMELTED then
			local effectsub = 0
			if tear.SubType & BrickFlags.GOLDEN == BrickFlags.GOLDEN then
				effectsub = effectsub | BrickFlags.GOLDEN
			end
			if tear.SubType & BrickFlags.BLASPHEMOUS == BrickFlags.BLASPHEMOUS then
				effectsub = effectsub | BrickFlags.BLASPHEMOUS
			end
			brickGfx = Isaac.Spawn(5, FiendFolio.PICKUP.VARIANT.SMELTED_BRICK_ROCK, effectsub, tear.Position, nilvector, tear):ToPickup()
		else
			local trinketsub = FiendFolio.ITEM.ROCK.BRICK_ROCK
			if tear.SubType & BrickFlags.GOLDEN == BrickFlags.GOLDEN then
				trinketsub = FiendFolio.ITEM.ROCK.BRICK_ROCK + TrinketType.TRINKET_GOLDEN_FLAG
			end
			brickGfx = Isaac.Spawn(5, 350, trinketsub, tear.Position, nilvector, tear):ToPickup()
			if tear.SubType & BrickFlags.BLASPHEMOUS == BrickFlags.BLASPHEMOUS then
				mod:MakePickupTrinketBlasphemous(brickGfx)
			end
		end
		
		brickGfx.Parent = tear
		brickGfx.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		brickGfx.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
		brickGfx.Visible = false
		local brickGfxData = mod:GetEntityData(brickGfx)
		brickGfxData.IsGfxBrick = true
		brickGfxData.ReplacedByVeil = false
		brickGfxData.BrickFollowParent = true
		local sprite = brickGfx:GetSprite()
        sprite:Load("gfx/projectiles/brick_rock.anm2", true)
        sprite:Play("Stone1Move", true)
		if brickGfx.Variant == FiendFolio.PICKUP.VARIANT.SMELTED_BRICK_ROCK then
			if tear.SubType & BrickFlags.GOLDEN == BrickFlags.GOLDEN then 
				sprite:SetRenderFlags(sprite:GetRenderFlags() | AnimRenderFlags.GOLDEN) 
			end
		else
			brickGfx:AddEntityFlags(EntityFlag.FLAG_NO_QUERY)
		end
		tear.Child = brickGfx
		if brickGfx.Type == 5 then 
			brickGfx.Touched = true
		end
		mod:HiddenPickupHandling(brickGfx)
	end
	local sprite = tear.Child:GetSprite()
	
	local tearsprite = tear:GetSprite()
	local scale = tear.Scale
	local sizeMulti = tear.SizeMulti
	local flags = tear.TearFlags
	
	sprite.PlaybackSpeed = tearsprite.PlaybackSpeed
	if not sprite:IsPlaying("Stone1Move") then
		local frame = sprite:GetFrame()
		sprite:Play("Stone1Move", true)
		sprite:SetFrame(frame)
	end

	sprite.Scale = Vector(1, 1)
	
	if flags & TearFlags.TEAR_FLAT == TearFlags.TEAR_FLAT then
		sprite.Rotation = tearsprite.Rotation
		sprite.FlipX = tearsprite.FlipX
		sprite.FlipY = tearsprite.FlipY
	else
		sprite.Rotation = 0
		sprite.FlipX = false
		sprite.FlipY = false
	end
	
	sprite.Color = tearsprite.Color
	
	local pos = Isaac.WorldToRenderPosition(tear.Position + tear.PositionOffset) + offset
	
	local trackedTrinket = mod.TrinketTracker:GetDataForPickup(brickGfx)
	if trackedTrinket then
		local entity = trackedTrinket.Location.Entity and trackedTrinket.Location.Entity.Ref
		if trackedTrinket.Data.IsBlasphemousTrinket and (not entity or not mod:GetEntityData(entity).BlasphemousTransform) then
			if not mod:HasBlasphemousShader(sprite) then
				mod:AddBlasphemousShader(sprite)
			end
			mod:PreRenderBlasphemousShader(sprite, pos)
		end
	end
	if brickGfx.Variant == FiendFolio.PICKUP.VARIANT.SMELTED_BRICK_ROCK and tear.SubType & BrickFlags.BLASPHEMOUS == BrickFlags.BLASPHEMOUS then
		if not mod:HasBlasphemousShader(sprite) then
			mod:AddBlasphemousShader(sprite)
		end
		mod:PreRenderBlasphemousShader(sprite, pos)
	end
	
---@diagnostic disable-next-line: param-type-mismatch
	sprite:Render(pos, nilvector, nilvector)
	
	data.LastRenderFrame = Isaac.GetFrameCount()
end
mod:AddCallback("FF_CUSTOM_TEAR_RENDER", mod.brickTearRender, FiendFolio.TEAR.BRICK)

function mod:brickTearSplat(tear, var, data)
	mod:spawnBrickTrinket(tear)
end
--mod:AddCallback("FF_CUSTOM_TEAR_SPLAT", mod.brickTearSplat, FiendFolio.TEAR.BRICK)

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_RENDER, function(_, brick, offset)
	if not brick.Visible then return end
	local sprite
	local isGolden = brick.SubType & BrickFlags.GOLDEN == BrickFlags.GOLDEN
	local isBlasphemous = brick.SubType & BrickFlags.BLASPHEMOUS == BrickFlags.BLASPHEMOUS
	if isBlasphemous then
		sprite = sprite or brick:GetSprite()
		if not mod:HasBlasphemousShader(sprite) then
			mod:AddBlasphemousShader(sprite)
		end
		mod:PreRenderBlasphemousShader(sprite, Isaac.WorldToScreen(brick.Position) + offset - Game():GetRoom():GetRenderScrollOffset())
	end
end, FiendFolio.PICKUP.VARIANT.SMELTED_BRICK_ROCK)

local bricks = {}
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function(_, brick)
	brick.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	brick.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
	
	local sprite = brick:GetSprite()
	sprite:ReplaceSpritesheet(0, "gfx/items/trinkets/golem/trinket_brick_rock.png")
	sprite:LoadGraphics()
	if brick.SubType & BrickFlags.GOLDEN == BrickFlags.GOLDEN then 
		sprite:SetRenderFlags(sprite:GetRenderFlags() | AnimRenderFlags.GOLDEN) 
	end
	
	brick:AddEntityFlags(EntityFlag.FLAG_NO_QUERY)
	table.insert(bricks, brick)
end, FiendFolio.PICKUP.VARIANT.SMELTED_BRICK_ROCK)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, brick)
	local data = mod:GetEntityData(brick)
	local sprite = brick:GetSprite()
	
	if sprite:IsEventTriggered("DropSound") then
		sfx:Play(SoundEffect.SOUND_SCAMPER, 1, 0, false, 1.0)
		brick.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
	end
	
	if data.BrickFollowParent then
		brick.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		brick.Visible = false
		brick.Velocity = nilvector
		
		if brick.Parent and brick.Parent:Exists() then
			brick.Position = brick.Parent.Position
		else
			brick:Remove()
		end
	elseif Isaac.GetChallenge() == mod.challenges.brickByBrick then
		local player = Isaac.GetPlayer(0)
		local speed = 2.5
		if brick.SubType & BrickFlags.GOLDEN == BrickFlags.GOLDEN or brick.SubType & BrickFlags.BLASPHEMOUS == BrickFlags.BLASPHEMOUS then
			speed = 1
		end
		if game:GetRoom():IsClear() then speed = 3 end
		brick.Velocity = (player.Position - brick.Position):Resized(speed)
		brick.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
	end
end, FiendFolio.PICKUP.VARIANT.SMELTED_BRICK_ROCK)

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, brick, collider, low)
	if collider.Type == EntityType.ENTITY_PLAYER and
	   collider.Variant == 0 and
	   not mod:GetEntityData(brick).IsGfxBrick
	then
		local player = collider:ToPlayer()

		if player.Parent == nil and -- Strawman and Soulstones
		   not player:IsCoopGhost() and
		   player:IsExtraAnimationFinished()
		then
			local smeltdata = mod:GetEntityData(player).SmeltedBrickData
			local isGolden = brick.SubType & BrickFlags.GOLDEN == BrickFlags.GOLDEN
			local isBlasphemous = brick.SubType & BrickFlags.BLASPHEMOUS == BrickFlags.BLASPHEMOUS
			
			if not smeltdata then
				return false
			elseif isGolden and isBlasphemous and (smeltdata.BlasphemousGoldenTossed or 0) <= 0 then
				return false
			elseif isGolden and not isBlasphemous and (smeltdata.GoldenTossed or 0) <= 0 then
				return false
			elseif not isGolden and isBlasphemous and (smeltdata.BlasphemousTossed or 0) <= 0 then
				return false
			elseif not isGolden and not isBlasphemous and (smeltdata.RegularTossed or 0) <= 0 then
				return false
			end
			
			player:AnimateTrinket(FiendFolio.ITEM.ROCK.BRICK_ROCK, "HideItem", "PlayerPickup")
			sfx:Play(SoundEffect.SOUND_SHELLGAME, 1, 0, false, 1, 0)
			
			if isGolden then
				player:GetHeldSprite():SetRenderFlags(player:GetHeldSprite():GetRenderFlags() | AnimRenderFlags.GOLDEN)
			end
			if isBlasphemous then
				mod:AddBlasphemousShader(player:GetHeldSprite())
			end
			
			brick.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			brick.Visible = false
			brick:Remove()
			
			if isGolden and isBlasphemous then
				smeltdata.BlasphemousGoldenTossed = math.max((smeltdata.BlasphemousGoldenTossed or 0) - 1, 0)
			elseif isGolden then
				smeltdata.GoldenTossed = math.max((smeltdata.GoldenTossed or 0) - 1, 0)
			elseif isBlasphemous then
				smeltdata.BlasphemousTossed = math.max((smeltdata.BlasphemousTossed or 0) - 1, 0)
			else
				smeltdata.RegularTossed = math.max((smeltdata.RegularTossed or 0) - 1, 0)
			end
		end

		return false
	end
end, FiendFolio.PICKUP.VARIANT.SMELTED_BRICK_ROCK)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_ROOM_EXIT, CallbackPriority.IMPORTANT, function(_, player)
	for _, brick in ipairs(bricks) do
		if brick and brick:Exists() then
			brick:Remove()
		end
	end
	bricks = {}

	mod:GetEntityData(player).SmeltedBrickData = {}
end)