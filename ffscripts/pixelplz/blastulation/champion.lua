local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Champion,

	ChampionTypes = {
		ChampionColor.RED,
		ChampionColor.YELLOW,
		ChampionColor.GREEN,
		ChampionColor.ORANGE,
		ChampionColor.BLUE,
		ChampionColor.BLACK,
		ChampionColor.GREY,
		ChampionColor.TRANSPARENT,
		ChampionColor.FLICKER,
		ChampionColor.PINK,
		ChampionColor.DARK_RED,
		ChampionColor.LIGHT_BLUE,
		ChampionColor.CAMO,
		ChampionColor.FLY_PROTECTED,
		ChampionColor.TINY,
		ChampionColor.GIANT,
		ChampionColor.DEATH,
	},
}
mod:AddEmbryo(embryo)



-- Turn into a champion
function embryo:Init(entity)
	local rng = RNG(entity.InitSeed)
	local chosen = mod:RandomIndex(embryo.ChampionTypes, rng)
	entity:MakeChampion(entity.InitSeed, chosen, true)

	entity.HitPoints = entity.MaxHitPoints
end