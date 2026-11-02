local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local flag = TearFlagsLib.RegisterTearFlag("GUTS_BOMB")
mod.BombsThatIgnoreSlippysGuts = {
	[mod.BombFlagSource.DR_FETUS] = true,
	[mod.BombFlagSource.EPIC_FETUS] = true,
	[mod.BombFlagSource.ANARCHISTS_EASY_BAKE] = true,
    [mod.BombFlagSource.MINESWEEPER] = true,
}

mod:AddCollectibleCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.ITEM.COLLECTIBLE.SLIPPYS_GUTS, function(_, player)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.SLIPPYS_GUTS) and game:GetRoom():GetFrameCount() > 0 then
		local data = mod:GetEntityData(player)
		for _, n in pairs(Isaac.FindInRadius(Vector(640, 560), 875, EntityPartition.ENEMY)) do
			if n:IsEnemy() and n:IsDead() then
				local d = mod:GetEntityData(n)
				if not (d.checkedslippysguts or (n.Type == mod.FFID.Tech and n.Variant > 999)) then
					if (not (n.Type == 792 and n.Variant == 1889)) then
						data.slippysGutsFartAttempts = data.slippysGutsFartAttempts or 0
						data.slippysGutsFartAttempts = data.slippysGutsFartAttempts + 1
						local luck = player.Luck
						luck = luck < 0 and 0 or luck
						luck = luck > 7 and 7 or luck
						local rand = 5 + (luck * 15/7) + math.min(30, math.floor(n.MaxHitPoints / 3)) + mod:GetEntityData(player).slippysGutsFartAttempts * 2
						--print(rand)
						if math.random(50) <= rand or data.slippysGutsFartAttempts > 10 then
							local cloud = Isaac.Spawn(mod.FF.SlippyFart.ID, mod.FF.SlippyFart.Var, mod.FF.SlippyFart.Sub, n.Position, nilvector, player)
							sfx:Play(mod.Sounds.FartFrog1,0.2,0,false,math.random(80,120)/100)
							data.slippysGutsFartAttempts = 0
						end
						d.checkedslippysguts = true
					end
				end
			end
		end
	end
end)

function mod:slippysGutsFlag(entity, player, sourceFlag)
	if not mod.BombsThatIgnoreSlippysGuts[sourceFlag] and player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.SLIPPYS_GUTS) then
		TearFlagsLib.AddTearFlags(entity, flag)
	end
end
mod:AddCollectibleCallback(FiendFolio.CALLBACK.FF_POLL_BOMBFLAGS, FiendFolio.ITEM.COLLECTIBLE.SLIPPYS_GUTS, mod.slippysGutsFlag)

function mod:slippysGutsVariant(bomb, player, sourceFlag)
	if not mod.BombsThatIgnoreSlippysGuts[sourceFlag] and player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.SLIPPYS_GUTS) then
		local var = bomb.Variant
		if mod:isReplaceableBombVariant(var) then
			if mod:isCopperVariant(var) then
				bomb.Variant = mod.BOMB.SLIPPY_COPPER
				bomb.Flags = bomb.Flags
			else
				bomb.Variant = mod.BOMB.SLIPPY
				bomb.Flags = bomb.Flags
			end
		end
	end
end
mod:AddCollectibleCallback(FiendFolio.CALLBACK.FF_SET_BOMB_VARIANT, FiendFolio.ITEM.COLLECTIBLE.SLIPPYS_GUTS, mod.slippysGutsVariant)

mod:AddCallback(FiendFolio.CALLBACK.FF_POST_BOMBFLAG_EFFECTS, function(_, pos, radius, tearflags, src, radiusMult, player, sourceFlag, tearFlagParams)
	local cloud = Isaac.Spawn(mod.FF.SlippyFart.ID, mod.FF.SlippyFart.Var, mod.FF.SlippyFart.Sub, pos, nilvector, src)
	sfx:Play(mod.Sounds.FartFrog1,0.2,0,false,math.random(80,120)/100)

	local data = mod:GetEntityData(src)
	if data.FFIsScatter or data.MaliceSplit or sourceFlag == mod.BombFlagSource.LOCUST_OF_WAR then
		mod:GetEntityData(cloud).RadiusMult = 0.5
		cloud.SpriteScale = Vector(0.5, 0.5)
	end
end, flag)

function mod:slippyFartAI(e)
	local sprite = e:GetSprite()
	local d = mod:GetEntityData(e)

	if sprite:IsFinished("PoofStart") then
		mod:spritePlay(sprite, "PoofLoop")
	end



	if e.FrameCount > 300 then
		if sprite:IsFinished("PoofEnd") then
			e:Remove()
		else
			mod:spritePlay(sprite, "PoofEnd")
		end
	elseif e.FrameCount % 5 == 0 then
		for _, entity in pairs(Isaac.FindInRadius(e.Position, 50 * (d.RadiusMult or 1), EntityPartition.ENEMY)) do
			local ed = mod:GetEntityData(entity)
			if entity:ToNPC() and (ed.LastFrameDamagedByGutCloud or 0) <= Game():GetFrameCount() - 5 then
				entity:TakeDamage(5, 0, EntityRef(entity), 0)
				if not entity:HasEntityFlags(EntityFlag.FLAG_POISON) then
					entity:AddPoison(EntityRef(Isaac.GetPlayer(0)), 60, 5)
				end
				ed.LastFrameDamagedByGutCloud = Game():GetFrameCount()
			end
		end
	end
end
