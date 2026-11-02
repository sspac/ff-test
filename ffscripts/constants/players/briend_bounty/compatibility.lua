local mod = FiendFolio



function mod:LoadBountyCompatibility()
	--[[ Boss Butch ]]--
	if BossButch then
		local m = BossButch


		-- Mirage costume render condition
		local mirage = mod:TypeKey(m.Entities.Mirage.Type, m.Entities.Mirage.Variant)

		mod.GunslingerCostumes.RenderConditions[mirage] = function(entity, sprite, data, renderMode)
			local reflectivity = data.reflected

			if Game():GetRoom():IsMirrorWorld() then
				reflectivity = not reflectivity
			end

			-- Only try to render the visible version's hat
			if renderMode == RenderMode.RENDER_WATER_REFLECT then
				return reflectivity
			else
				return not reflectivity
			end
		end


		-- Blacklist Scat Man's big poop
		local poop = mod:TypeKey(m.Entities.ScatManPoopGiant.Type, m.Entities.ScatManPoopGiant.Variant)
		mod.GunslingerSelection.Blacklist[poop] = true


		-- Tulip head layers
		mod.GunslingerCostumes.HeadLayerOverrides[ "gfx/bosses/chapter4/tulip/tulip.anm2" ] = {
			_Default = "flower",
			Death = "tulip",
		}

		-- Duke Bloat head layers
		mod.GunslingerCostumes.HeadLayerOverrides[ "gfx/bosses/chapter4/duke_bloat/dukebloat.anm2" ] = {
			_Default = "DBBody2",
			Piss = { [0] = "DBBody2", [5] = "DBBody4", [31] = "DBBody2", },
			PushStart = { [0] = "DBBody2", [12] = "DBBody4", },
			PushLoop = "DBBody4",
			PushStop = { [0] = "DBBody4", [6] = "DBBody2", },
			Summon = { [0] = "DBBody4", [35] = "DBBody2", },
		}

		-- Brainrot head layer
		mod.GunslingerCostumes.HeadLayerOverrides[ "gfx/bosses/chapter4/brainrot/brainrot.anm2" ] = "Ted"
	end



	--[[ Even Playfield ]]--
	if EvenPlayfield then
		local m = EvenPlayfield

		-- Blacklisted entities
		local blacklist = {
			[ mod:TypeKey(m.Entities.Familiar.Type, m.Entities.Familiar.Variant) ] = true,
			[ mod:TypeKey(EntityType.ENTITY_CHARGER, m.Entities.Leech) ] = true,
			[ mod:TypeKey(m.Entities.InnerChildHelper.Type, m.Entities.InnerChildHelper.Variant) ] = true,
		}
		for i, entry in pairs(blacklist) do
			mod.GunslingerSelection.Blacklist[entry] = true
		end

		-- Projectile change blacklist
		m.ProjectileChangeBlacklist[ mod.FF.BountyBullet.Var ] = true
	end



	--[[ Reworked Foes ]]--
	if ReworkedFoes then
		-- Blacklisted entities
		local blacklist = {
			mod:TypeKey(EntityType.ENTITY_WAR, 20),
			mod:TypeKey(ReworkedFoes.Entities.Type, ReworkedFoes.Entities.Wallace),
		}
		for i, entry in pairs(blacklist) do
			mod.GunslingerSelection.Blacklist[entry] = true
		end


		-- War head layers
		mod.GunslingerCostumes.HeadLayerOverrides[ "gfx/065.010_war without horse.anm2" ] = {
			_Default = "head",
			Idiot = { [0] = "head", [6] = "extra1", },
		}

		-- ??? head layers
		mod.GunslingerCostumes.HeadLayerOverrides[ "gfx/102.001_ (final boss).anm2" ] = {
			_Default = "body",
			["2_Transition"] = { [0] = "body", [61] = "front", },
		}

		-- Gate head layer
		mod.GunslingerCostumes.HeadLayerOverrides[ "gfx/263.000_megamaw2.anm2" ] = "Main"

		-- Mr. Fred head layers
		mod.GunslingerCostumes.HeadLayerOverrides[ "gfx/270.000_megafred.anm2" ] = {
			_Default = "Head",
			SummonRight = { [0] = "Head", [9] = "more", [16] = "Head", },
			SummonLeft = { [0] = "Head", [9] = "more", [16] = "Head", },
			LeapDown = { [0] = "Head", [14] = "more", [28] = "Head", [30] = "_None", },
			LeapUp = { [0] = "Head", [30] = "_None", },
		}

		-- Portal head layer
		mod.GunslingerCostumes.HeadLayerOverrides[ "gfx/306.000_portal.anm2" ] = "back"
	end



	--[[ Fall from Grace ]]--
	if FFGRACE then
		local m = FFGRACE

		-- Blacklisted entities
		local blacklist = {
			-- Boiler
			mod:TypeKey(m.ENT.PUFF.id, m.ENT.PUFF.variant),
			mod:TypeKey(m.ENT.SOURDOUGH.id, m.ENT.SOURDOUGH.variant),
			mod:TypeKey(m.ENT.CHUBBLE.id, m.ENT.CHUBBLE.variant),
				mod:TypeKey(m.ENT.GRUFF.id, m.ENT.GRUFF.variant),
				mod:TypeKey(m.ENT.SMOKEE.id, m.ENT.SMOKEE.variant),

			-- Grotto
			mod:TypeKey(m.ENT.MUD_FLY.id, m.ENT.MUD_FLY.variant),
				mod:TypeKey(m.ENT.SPORE_FLY.id, m.ENT.SPORE_FLY.variant),
			mod:TypeKey(m.ENT.POPCAP.id, m.ENT.POPCAP.variant),
				mod:TypeKey(m.ENT.POPCAP_CLUSTER.id, m.ENT.POPCAP_CLUSTER.variant),
				mod:TypeKey(m.ENT.POPCAP_AERIAL.id, m.ENT.POPCAP_AERIAL.variant),
			mod:TypeKey(m.ENT.RASCAL.id, m.ENT.RASCAL.variant),
		}
		for i, entry in pairs(blacklist) do
			mod.GunslingerSelection.Blacklist[entry] = true
		end


		-- Tootie head layers
		mod.GunslingerCostumes.HeadLayerOverrides[ "gfx/bosses/boiler/pipeline/boss_tootie.anm2" ] = {
			_Default = "Head",
			IdleUpRight = "Body",
			IdleUp = "Body",
			IdleUpLeft = "Body",
			ChaseUpRight = "Body",
			ChaseUp = "Body",
			ChaseUpLeft = "Body",
			ZoomUp = "Body",
		}


		-- Ms. Guano head layers
		mod.GunslingerCostumes.HeadLayerOverrides[ "gfx/bosses/grotto/ms. guano/boss_ms guano.anm2" ] = {
			_Default = "shrooms",
			ChargeLoopUp = "leftWing",
		}


		-- Dirt Digger custom check
		local dirtDigger = mod:TypeKey(m.ENT.DIRT_DIGGER.id, m.ENT.DIRT_DIGGER.variant)

		mod.GunslingerSelection.Blacklist[dirtDigger] = function(entity)
			return entity.SubType & 1 ~= 1
		end


		-- Stub custom check
		local stub = mod:TypeKey(m.ENT.STUB.id, m.ENT.STUB.variant)

		mod.GunslingerSelection.Blacklist[stub] = function(entity)
			return not entity:GetData().stubHead
		end
	end



	--[[ Last Judgement ]]--
	if LastJudgement then
		local m = LastJudgement

		-- Blacklisted entities
		local blacklist = {
			mod:TypeKey(m.ENT.CorpseEater.ID, m.ENT.CorpseEater.Var, 1),
				mod:TypeKey(m.ENT.CarrionRider.ID, m.ENT.CarrionRider.Var, 1),
			mod:TypeKey(m.ENT.Phage.ID, m.ENT.Phage.Var),
				mod:TypeKey(m.ENT.Pheege.ID, m.ENT.Pheege.Var),
				mod:TypeKey(m.ENT.Phooge.ID, m.ENT.Phooge.Var),
			mod:TypeKey(m.ENT.Topsy.ID, m.ENT.Topsy.Var),
			mod:TypeKey(m.ENT.Cadavra.ID, m.ENT.Cadavra.Var)
		}
		for i, entry in pairs(blacklist) do
			mod.GunslingerSelection.Blacklist[entry] = true
		end


		-- Mama Plum
		local mamaPlum = mod:TypeKey(m.ENT.MamaPlum.ID, m.ENT.MamaPlum.Var)
		mod.GunslingerCostumes.DontUseTexelDetection[mamaPlum] = true


		-- AIDS head layers
		mod.GunslingerCostumes.HeadLayerOverrides[ "gfx/enemies/aids/monster_aids.anm2" ] = {
			_Default = "Main",
			Melt = { [0] = "Main", [14] = "_None", },
			Idle02 = "_None",
			Reform = { [0] = "_None", [9] = "Main", },
		}


		-- Lobodius head layer
		mod.GunslingerCostumes.HeadLayerOverrides[ "gfx/enemies/lobodius/monster_lobodious.anm2" ] = "body"
	end



	--[[ God's Gambit ]]--
	if GodsGambit then
		local m = GodsGambit

		-- Blacklisted entities
		local blacklist = {
			mod:TypeKey(m.ENT.Humility.ID, m.ENT.Humility.Var),
				mod:TypeKey(m.ENT.SuperHumility.ID, m.ENT.SuperHumility.Var),
			mod:TypeKey(m.ENT.Louse.ID, m.ENT.Louse.Var),
			mod:TypeKey(m.ENT.Locust.ID, m.ENT.Locust.Var),
		}
		for i, entry in pairs(blacklist) do
			mod.GunslingerSelection.Blacklist[entry] = true
		end


		-- Make Humility's Pons have guns
		function mod:HumilityPonBounty(entity)
			local humilityPon = (entity.SpawnerType == m.ENT.Humility.ID 	  and entity.SpawnerVariant == m.ENT.Humility.Var)
							 or (entity.SpawnerType == m.ENT.SuperHumility.ID and entity.SpawnerVariant == m.ENT.SuperHumility.Var)

			if humilityPon and PlayerManager.AnyoneIsPlayerType(mod.PLAYER.BRIEND) then
				local func = function()
					mod:MakeGunslinger(entity, nil, false, nil, nil, "Goon", true)
				end
				mod.scheduleForUpdate(func, 0, ModCallbacks.MC_POST_UPDATE, true)
			end
		end
		mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.HumilityPonBounty, EntityType.ENTITY_PON)
	end



	--[[ The Future ]]--
	if TheFuture then
		local m = TheFuture

		-- Blacklist Oswald
		local oswald = mod:TypeKey(m.Monsters.Oswald.ID, m.Monsters.Oswald.Var)
		mod.GunslingerSelection.Blacklist[oswald] = true
	end



	--[[ Revelations ]]--
	if REVEL then
		local m = REVEL

		-- Blacklisted entities
		local blacklist = {
			-- Glacier
			mod:TypeKey(m.ENT.SNOW_FLAKE.id, m.ENT.SNOW_FLAKE.variant),
				mod:TypeKey(m.ENT.SNOW_FLAKE_BIG.id, m.ENT.SNOW_FLAKE_BIG.variant),
			mod:TypeKey(m.ENT.FROZEN_SPIDER.id, m.ENT.FROZEN_SPIDER.variant),
				mod:TypeKey(m.ENT.YELLOW_FROZEN_SPIDER.id, m.ENT.YELLOW_FROZEN_SPIDER.variant),
			mod:TypeKey(m.ENT.SNOWBALL.id, m.ENT.SNOWBALL.variant),
				mod:TypeKey(m.ENT.YELLOW_SNOWBALL.id, m.ENT.YELLOW_SNOWBALL.variant),
				mod:TypeKey(m.ENT.STRAWBERRY_SNOWBALL.id, m.ENT.STRAWBERRY_SNOWBALL.variant),
			mod:TypeKey(m.ENT.JUNIAUGR.id, m.ENT.JUNIAUGR.variant),
			mod:TypeKey(m.ENT.PINECONE.id, m.ENT.PINECONE.variant),

			-- Tomb
			mod:TypeKey(m.ENT.LOCUST.id, m.ENT.LOCUST.variant),
			mod:TypeKey(m.ENT.URNY.id, m.ENT.URNY.variant),
			mod:TypeKey(m.ENT.ANTLION_BABY.id, m.ENT.ANTLION_BABY.variant),
				mod:TypeKey(m.ENT.ANTLION_EGG.id, m.ENT.ANTLION_EGG.variant),
			mod:TypeKey(m.ENT.CATASTROPHE_YARN.id, m.ENT.CATASTROPHE_YARN.variant),
			mod:TypeKey(m.ENT.ARAGNID_INNARD.id, m.ENT.ARAGNID_INNARD.variant),
			mod:TypeKey(m.ENT.JEFFREY_BABY.id, m.ENT.JEFFREY_BABY.variant),
		}
		for i, entry in pairs(blacklist) do
			mod.GunslingerSelection.Blacklist[entry] = true
		end


		-- Only enable guns for active cats
		local kitties = {
			m.ENT.CATASTROPHE_GUPPY,
			m.ENT.CATASTROPHE_CRICKET,
			m.ENT.CATASTROPHE_TAMMY,
			m.ENT.CATASTROPHE_MOXIE,
		}
		for i, kitty in pairs(kitties) do
			local cat = mod:TypeKey(kitty.id, kitty.variant)
			mod.GunslingerSelection.AlwaysAllow[cat] = true

			local function catUpdate(_, entity)
				if entity.Variant == kitty.variant then
					local data = mod:GetEntityData(entity).GunslingerData

					if data and data.Entity then
						data.Entity.ForceDisable = m.GetData(entity).Invulnerable
					end
				end
			end
			mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, catUpdate, kitty.id)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, mod.LoadBountyCompatibility)