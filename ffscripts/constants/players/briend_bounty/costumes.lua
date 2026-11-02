local mod = FiendFolio



mod.GunslingerCostumes = {
	Filepath = "gfx/enemies/gunslinger_hats.anm2",
	VerticalOffset = 4, -- Easier than changing the positions in the anm2
	MaxSize = 3,

	-- Head related layer names (in order of priority)
	HeadLayers = {
		"hat", "helmet", "hair",
		"head", "skull", "brain",
		"top", "overlay",
		"main", "body",
		"dude", "gambler",
	},

	-- Layers that should never be used as the head layer
	LayersToIgnore = {
		"*", "glow", "shadow",
		"dirt", "hole",
		"effect", "fx", "particle",
		"darkness", "ray",
		"wing", "halo",
		"rag", "rope", "noose",
		"sign",
	},

	-- AnimRenderFlags that should be copied over from the entity if it has them
	RenderFlagsToCopy = {
		AnimRenderFlags.GLITCH,
		AnimRenderFlags.GOLDEN,
	},



	-- Extra conditions for rendering the costume for an entity
	RenderConditions = {
		-- Pickups
		[ mod:TypeKey(EntityType.ENTITY_PICKUP) ] = function(entity, sprite, data, renderMode)
			return not entity:IsDead()
		end,

		-- Rift Walker (Still looks jank but the enemy is made in a jank way)
		[ mod:TypeKey(mod.FF.RiftWalker.ID, mod.FF.RiftWalker.Var) ] = function(entity, sprite, data, renderMode)
			if entity.SubType ~= 10 then
				if renderMode == RenderMode.RENDER_WATER_REFLECT then
					return data.below.Visible
				end
				return data.above.Visible
			end
		end,

		-- Tsar
		[ mod:TypeKey(mod.FF.Tsar.ID, mod.FF.Tsar.Var) ] = function(entity, sprite, data, renderMode)
			return sprite:GetFilename() ~= "gfx/bosses/tsar/boss_tsargrate.anm2"
		end,

		-- Ghostbuster
		[ mod:TypeKey(mod.FF.Ghostbuster.ID, mod.FF.Ghostbuster.Var) ] = function(entity, sprite, data, renderMode)
			local isReflection = renderMode == RenderMode.RENDER_WATER_REFLECT
			return (data.IsInReflection and isReflection) or (not data.IsInReflection and not isReflection)
		end,
	},



	-- Manually set what layer to use as the head for an ANM2 and its animations
	-- The "_Default" layer is used if nothing else is defined for the current layer
	-- Setting "_None" as the layer to use will make the costume not render for that animation
	-- "_IgnoreOverlay" will prevent overlays from being used for the head layer
	HeadLayerOverrides = {
		-- Vanilla
		[ "gfx/006.006_shell game.anm2" ] = "Dude",
			[ "gfx/006.015_hell game.anm2" ] = "Dude",

		[ "gfx/036.000_gurdy.anm2" ] = "body",
			[ "gfx/099.000_gurdy jr..anm2" ] = "body",

		[ "gfx/060.000_eye.anm2" ] = "eye",

		[ "gfx/074.000_blastocyst big.anm2" ] = "bubble",
			[ "gfx/075.000_blastocyst medium.anm2" ] = "bubble",
			[ "gfx/076.000_blastocyst small.anm2" ] = "bubble",

		[ "gfx/226.002_crispy.anm2" ] = "head2",

		[ "gfx/280.000_black globins body.anm2" ] = {
			_Default = "body",
			_IgnoreOverlay = true, -- Had to implement this just for this guy
		},

		[ "gfx/306.000_portal.anm2" ] = "Black",

		[ "gfx/406.000_ultragreed.anm2" ] = {
			_Default = "Noose", -- Nicalis moment
			Walking = "Head",
			WalkingDown = "Head",
			WalkingUp = "HeadBack",
			Hanging = "Head",
			Appearing = { [0] = "Arm2", [14] = "Noose", },
			ShootRight = "Head",
			ShootLeft = "Head",
			ShootDown = "Head",
			ShootUp = "HeadBack",
		},
		[ "gfx/406.001_ultragreedier.anm2" ] = {
			_Default = "Noose",
			Walking = "Head",
			WalkingDown = "Head",
			WalkingUp = "HeadBack",
			Death = { [0] = "Noose", [64] = "_None", },
			ShootRight = "Head",
			ShootLeft = "Head",
			ShootDown = "Head",
			ShootUp = "HeadBack",
			Smash = "Head",
			BreakFreeShort = "Head",
			BreakFreeLong = "Head",
		},

		[ "gfx/407.000_hush.anm2" ] = {
			_Default = "Main",
			TurnConcave = { [0] = "Main", [3] = "_None", },
			Concave = "_None",
			BecomeConvex = { [0] = "_None", [3] = "Main", },
			Death = { [0] = "Main", [67] = "_None", },
			Appear = { [0] = "_None", [69] = "Main", },
			MovingConcave = "_None",
			MovingConcaveEyesOpen = "_None",
		},

		[ "gfx/913.000_min min.anm2" ] = {
			_Default = "husk",
			Transition = { [0] = "husk", [10] = "head", },
		},

		-- FF
		[ "gfx/items/slots/cell_game.anm2" ] = "Dude",

		[ "gfx/items/slots/golem/midarizer.anm2" ] = "Body", -- This should already be the one it uses???

		[ "gfx/enemies/cancerboy/monster_cancerboy.anm2" ] = {
			_Default = "Head",
			HeadUp = "Extra",
			ShootUp = "Extra",
		},

		[ "gfx/enemies/excluder/monster_excluder.anm2" ] = "body",

		[ "gfx/enemies/compass/monster_armillery.anm2" ] = {
			_Default = "Eye",
			Appear = { [0] = "_None", [5] = "Eye", },
		},

		[ "gfx/enemies/clicketychar/monster_clickety-char.anm2" ] = "head2",

		[ "gfx/enemies/walkingnerve/walking nerve.anm2" ] = {
			_Default = "head",
			Idle = "effect", -- bruh
		},

		[ "gfx/enemies/grater/monster_grater.anm2" ] = {
			_Default = "body",
			Burrow = { [0] = "body", [21] = "_None", },
			Grate = "_None",
			GrateShake = "_None",
			Emerge = { [0] = "_None", [3] = "body", },
		},

		[ "gfx/enemies/bumbler/monster_bumbler.anm2" ] = {
			_Default = "body",
			ShootHori = "wing",
			ShootHoriLoop = "extra",
			ShootHoriEnd = "wing",
		},
			[ "gfx/enemies/bumbler/monster_buckshot.anm2" ] = {
				_Default = "body",
				ShootHori = "wing",
				ShootHoriLoop = "extra2",
				ShootHoriEnd = "wing",
				ChargeRight = "wing",
				ChargeLeft = "wing",
			},
			[ "gfx/enemies/phoenix/monster_phoenix.anm2" ] = {
				_Default = "body",
				ShootRight = "wing",
				ShootRightLoop = "extra",
				ShootRightEnd = "wing",
				ShootLeft = "wing",
				ShootLeftLoop = "extra",
				ShootLeftEnd = "wing",
			},
				[ "gfx/enemies/phoenix/monster_phoenix02.anm2" ] = {
					_Default = "body",
					ShootRight = "wing",
					ShootRightLoop = "extra",
					ShootRightEnd = "wing",
					ShootLeft = "wing",
					ShootLeftLoop = "extra",
					ShootLeftEnd = "wing",
				},

		[ "gfx/enemies/warden/warden.anm2" ] = "of", -- Come on man...

		[ "gfx/enemies/bowler/monster_bowler.anm2" ] = {
			_Default = "bodypart2",
			WalkUp01 = "bodypart",
		},
			[ "gfx/enemies/bowler/monster_bowler_septic.anm2" ] = { -- Isn't this just a spritesheet swap?
				_Default = "bodypart2",
				WalkUp01 = "bodypart",
			},
			[ "gfx/enemies/bowler/monster_palebowler.anm2" ] = {
				_Default = "bodypart2",
				WalkUp01 = "bodypart",
			},

		[ "gfx/bosses/pollution/boss_pollutionhorseless.anm2" ] = "Extra",

		[ "gfx/bosses/slinger/slinger.anm2" ] = {
			_Default = "slingerhead",
			Intro = "slingerstring",
			Idle = "slingerstring",
			PullFoetuStart = "slingerstring",
			PullFoetu = "slingerstring",
			PullChunks = "slingerstring",
			HeadRegrow = "slingerstring",
			Death = "slingerstring",
		},

		[ "gfx/enemies/shi/shi.anm2" ] = "head",

		[ "gfx/enemies/zealot/monster_zealot.anm2" ] = "layer 3",

		[ "gfx/enemies/weeper/monster_weeper.anm2" ] = "eye",

		[ "gfx/enemies/coalscoop/monster_coalscoop.anm2" ] = "Coal03",
			[ "gfx/enemies/coalscoop/monster_coalscoop_2.anm2" ] = "Coal02",
			[ "gfx/enemies/coalscoop/monster_coalscoop_3.anm2" ] = "Coal01",
	},



	-- Manually set the costume height for an ANM2 and its animations
	-- The "_Default" value is used if nothing else is defined for the current layer
	-- Only use this if really necessary!
	HeightOverrides = {
		-- Vanilla
		[ "gfx/078.000_moms heart.anm2" ] = 18,
			[ "gfx/078.001_it lives.anm2" ] = 18,

		[ "gfx/908.000_baby plum.anm2" ] = {
			_Default = 11,
			Appear = { [0] = 21, [31] = 11, },
			Attack2 = { [0] = 11, [19] = 21, [30] = 11, },
			Death = { [0] = 11, [10] = 21, },
		},
			[ "gfx/bosses/champions/babyplum/golden_plum.anm2" ] = { -- It's not even different...
				_Default = 11,
				Appear = { [0] = 21, [31] = 11, },
				Attack2 = { [0] = 11, [19] = 21, [30] = 11, },
				Death = { [0] = 11, [10] = 21, },
			},

		-- FF
		[ "gfx/bosses/honeydrop/honeydrop.anm2" ] = {
			Idle = 16,
			Appear = 16,
			Summon = { [0] = 16, [12] = 21, [22] = 16, },
			Shoot = { [0] = 16, [12] = 21, [22] = 16, },
		},
	},



	-- Entities that should only use OverlayEffect to get the costume height
	DontUseTexelDetection = {
		-- Vanilla
		[ mod:TypeKey(EntityType.ENTITY_POOTER) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_BOOMFLY) ] = true,
		[ mod:TypeKey(EntityType.ENTITY_SUCKER) ] = true,

		-- FF
		[ mod:TypeKey(mod.FF.Brood.ID, mod.FF.Brood.Var) ] = true,
		[ mod:TypeKey(mod.FF.ManicFly.ID, mod.FF.ManicFly.Var) ] = true,
		[ mod:TypeKey(mod.FF.Beeter.ID, mod.FF.Beeter.Var) ] = true,
		[ mod:TypeKey(mod.FF.Hover.ID, mod.FF.Hover.Var) ] = true,
		[ mod:TypeKey(mod.FF.ButtFly.ID, mod.FF.ButtFly.Var) ] = true,
	},
}



-- Check if the given sprite is in the given list using its filename, animation and frame as keys
---@param list table The list to check.
---@param sprite Sprite
---@return table | boolean, boolean
function FiendFolio:IsOnSpriteList(list, sprite)
	local filename = string.lower( sprite:GetFilename() )
	local result
	local ignoreOverlay = false

	-- ANM2 entry
	if list[filename] then
		local entry = list[filename]
		result = entry

		if type(entry) == "table" then
			result = entry._Default
			ignoreOverlay = entry._IgnoreOverlay

			-- Specific animation entry
			for i = 1, 2 do
				local animation = i == 1 and sprite:GetOverlayAnimation() or sprite:GetAnimation()

				if entry[animation] and (i == 2 or not ignoreOverlay) then
					result = entry[animation]

					-- Look for the nearest frame to use
					if type(result) == "table" then
						local frame = i == 1 and sprite:GetOverlayFrame() or sprite:GetFrame()

						for checkFrame = frame, 0, -1 do
							local frameData = result[checkFrame]

							if frameData then
								result = frameData
								break
							end
						end
					end
					break
				end
			end
		end
	end

	return result or false, ignoreOverlay
end