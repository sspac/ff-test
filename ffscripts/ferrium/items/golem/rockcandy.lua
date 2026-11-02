local mod = FiendFolio
local game = Game()

function mod:RockCandyDeath(npc)
	if mod.anyPlayerHas(mod.ITEM.ROCK.ROCK_CANDY, true) then
		local mult = mod.GetGolemTrinketPowerAcrossAllPlayers(mod.ITEM.ROCK.ROCK_CANDY)
		if not (npc.Type == mod.FFID.Tech and npc.Variant > 999) and npc:GetDropRNG():RandomInt(100) < math.min(15*mult, 40) then
			local room = game:GetRoom()
			local chance = mult*20
			if npc:GetDropRNG():RandomInt(100) < chance and room:GetGridCollisionAtPos(npc.Position) == GridCollisionClass.COLLISION_NONE then
				local rockCandy = Isaac.Spawn(5, 10, 2, npc.Position, Vector.Zero, npc):ToPickup()
				rockCandy.Timeout = math.floor(40+mult*20)
				rockCandy:Update()
				rockCandy:GetSprite():ReplaceSpritesheet(0, "gfx/items/pick ups/rockcandy_heart.png")
				rockCandy:GetSprite():LoadGraphics()
			end
		end
	end
end
mod:AddTrinketCallback("FF_POST_NPC_DEATH_FERRIUM", mod.ITEM.ROCK.ROCK_CANDY, mod.RockCandyDeath)

function mod:rockCandyTearHitParams(player, tearparams, weapontype, damagescale, teardisplacement, source)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.ROCK_CANDY) then
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.ROCK_CANDY)
		local mult = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.ROCK_CANDY)
		local chance = 5+10*mult+3*player.Luck

		if rng:RandomInt(100) < chance then
			tearparams.TearDamage = tearparams.TearDamage * 1.5
			tearparams.TearVariant = TearVariant.DIAMOND
			tearparams.TearFlags = tearparams.TearFlags | TearFlags.TEAR_CHARM
			tearparams.TearColor = Color(1.5,1.5,1.5,1,0,0,0,1.3,0.7,0.7,1)
		end
	end
end
mod:AddTrinketCallback(ModCallbacks.MC_EVALUATE_TEAR_HIT_PARAMS, mod.ITEM.ROCK.ROCK_CANDY, mod.rockCandyTearHitParams)