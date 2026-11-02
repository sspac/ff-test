local mod = FiendFolio

FiendFolio.scheduleForUpdate(function()
    if LastJudgement then
        table.insert(mod.RandomFreakingRocks, "gfx/grid/mortis/rocks_moistis.png")
        table.insert(mod.RandomFreakingRocks, "gfx/grid/mortis/rocks_moistis_ff.png")
        table.insert(mod.RandomFreakingRocks, "gfx/grid/mortis/rocks_morgueis.png")
        table.insert(mod.RandomFreakingRocks, "gfx/grid/mortis/rocks_morgueis_ff.png")
        table.insert(mod.RandomFreakingRocks, "gfx/grid/mortis/rocks_mortis.png")
        table.insert(mod.RandomFreakingRocks, "gfx/grid/mortis/rocks_mortis_ff.png")

        table.insert(mod.RandomFreakingPits, {"gfx/grid/mortis/grid_pit_moistis.png"})
        table.insert(mod.RandomFreakingPits, {"gfx/grid/mortis/grid_pit_morgueis.png"})
        table.insert(mod.RandomFreakingPits, {"gfx/grid/mortis/grid_pit_morgueis_chemical.png"})
        table.insert(mod.RandomFreakingPits, {"gfx/grid/mortis/grid_pit_mortis.png"})
        table.insert(mod.RandomFreakingPits, {"gfx/grid/mortis/grid_pit_mortis_chemical.png"})
        table.insert(mod.RandomFreakingPits, {"gfx/grid/mortis/grid_pit_moistis_ff.png", true})
        table.insert(mod.RandomFreakingPits, {"gfx/grid/mortis/grid_pit_morgueis_ff.png", true})
        table.insert(mod.RandomFreakingPits, {"gfx/grid/mortis/grid_pit_morgueis_ff_chemical.png", true})
        table.insert(mod.RandomFreakingPits, {"gfx/grid/mortis/grid_pit_morgueis_ff_chemical.png", true})
        table.insert(mod.RandomFreakingPits, {"gfx/grid/mortis/grid_pit_mortis_ff.png", true})
        table.insert(mod.RandomFreakingPits, {"gfx/grid/mortis/grid_pit_mortis_ff_chemical.png", true})
    end
    if FFGRACE then
        table.insert(mod.RandomFreakingRocks, "gfx/grid/boiler/rocks_boiler.png")
        table.insert(mod.RandomFreakingRocks, "gfx/grid/boiler/rocks_boiler_ff(old).png")
        table.insert(mod.RandomFreakingRocks, "gfx/grid/boiler/rocks_boiler_ff.png")

        table.insert(mod.RandomFreakingPits, {"gfx/grid/boiler/grid_pit_boiler.png"})
        table.insert(mod.RandomFreakingPits, {"gfx/grid/boiler/grid_pit_boiler_ff.png", true})

        table.insert(mod.RandomFreakingRocks, "gfx/grid/grotto/grotto_rocks.png")
        table.insert(mod.RandomFreakingRocks, "gfx/grid/grotto/grotto_rocks_ff.png")

        table.insert(mod.RandomFreakingPits, {"gfx/grid/grotto/grid_pit_grotto.png"})
        table.insert(mod.RandomFreakingPits, {"gfx/grid/grotto/grid_pit_grotto_water.png"})
        table.insert(mod.RandomFreakingPits, {"gfx/grid/grotto/grid_pit_grotto_cursed.png"})
        table.insert(mod.RandomFreakingPits, {"gfx/grid/grotto/grid_pit_grotto_ff.png"})
        table.insert(mod.RandomFreakingPits, {"gfx/grid/grotto/grid_pit_grotto_water_ff.png"})
        table.insert(mod.RandomFreakingPits, {"gfx/grid/grotto/grid_pit_grotto_cursed_ff.png"})
    end
    if TheFuture then
        table.insert(mod.RandomFreakingRocks, "gfx/grid/rocks_future.png")
        table.insert(mod.RandomFreakingPits, {"gfx/grid/grid_pit_future.png"})
    end
end, 1, ModCallbacks.MC_INPUT_ACTION, true)