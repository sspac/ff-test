local mod = FiendFolio
local basePath = "gfx/enemies/blastulation/compatibility/"



function mod:BlastulationLoadCompatibility()
	--[[ Fall from Grace ]]--
	if FFGRACE then
		-- Rock
		local key = EntityType.ENTITY_EMBRYO .. " " .. mod.FF.Blastulation.Rock.Variant .. " " .. mod.FF.Blastulation.Rock.SubTypes.Rock
		FFGRACE.StageSkins.Grotto[key] = {{ {0}, basePath .. "rock_grotto", }}
		FFGRACE.EnemyRocksToMuddy[key] = FFGRACE.ColorMudSplat
	end



	--[[ Last Judgement ]]--
	if LastJudgement then
		local reskins = {
			{ -- Walking
				Variant = mod.FF.Blastulation.Walking,
				Sheets = {{ { 0, 1, }, basePath .. "walking_mortis.png", }},
				SplatColor = LastJudgement.Colors.MortisBlood,
			},
			{ -- Mr.
				Variant = mod.FF.Blastulation.Mr.Variant,
				Sheets = {{ { 0, 1, }, basePath .. "mr_mortis.png", }},
				SplatColor = LastJudgement.Colors.MortisBlood,
			},
			{ -- Blastocyst
				Variant = mod.FF.Blastulation.Blastocyst.Variant,
				SubType = mod.FF.Blastulation.Blastocyst.SubTypes.Big,
				Sheets = {{ { 0, 1, 2, }, basePath .. "blastocyst_mortis.png", }},
				SplatColor = LastJudgement.Colors.VirusBlue,
			},
			{ -- Embryo
				Variant = mod.FF.Blastulation.Blastocyst.Variant,
				SubType = mod.FF.Blastulation.Blastocyst.SubTypes.Small,
				Sheets = {{ {0}, basePath .. "embryo_mortis.png", }},
				SplatColor = LastJudgement.Colors.MortisBlood,
			},
			{ -- Guillotine
				Variant = mod.FF.Blastulation.Guillotine.Variant,
				Sheets = {
					{ {0}, basePath .. "guillotine_mortis.png", },
					{ {1}, basePath .. "effect_bloodgush_small_mortis.png", },
				},
				SplatColor = LastJudgement.Colors.MortisBlood,
			},
			{ -- Sniffing
				Variant = mod.FF.Blastulation.Sniffing,
				Sheets = {{ {0}, basePath .. "sniffing_mortis.png", }},
				SplatColor = LastJudgement.Colors.MortisBlood,
			},
			{ -- Level 2
				Variant = mod.FF.Blastulation.Level2,
				Sheets = {{ {0}, basePath .. "level2_mortis.png", }},
				SplatColor = LastJudgement.Colors.MortisBlood,
			},
		}

		for i, entry in pairs(reskins) do
			local key = EntityType.ENTITY_EMBRYO .. " " .. entry.Variant

			if entry.SubType then
				key = key .. " " .. entry.SubType
			end

			-- Set the spritesheets
			LastJudgement.MortisSkins[key] = entry.Sheets

			-- Set the splat color
			if entry.SplatColor then
				LastJudgement.MortisSplatColors[key] = entry.SplatColor
			end
		end
	end



	--[[ The Future ]]--
	if TheFuture then
		local host = EntityType.ENTITY_EMBRYO .. " " .. mod.FF.Blastulation.Host.Variant
		TheFuture.SplatColorsToFuture[host] = TheFuture.ColorDankBlackReal

		local regular = host .. " " .. mod.FF.Blastulation.Host.SubTypes.Regular
		TheFuture.StageSkins[regular] = {{ {0}, basePath .. "host_future", }}

		local red = host .. " " .. mod.FF.Blastulation.Host.SubTypes.Red
		TheFuture.StageSkins[red] = {{ {0}, basePath .. "host_red_future", }}
	end
end
mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, mod.BlastulationLoadCompatibility)