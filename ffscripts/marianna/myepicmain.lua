local mod = FiendFolio
local game = Game()
local hud = game:GetHUD()

--hi all, welcome to my main! this is my first time programming for fiend folio so, be nice ^-^

local scrIt = "ffscripts/marianna/items/"
local scrCo = "ffscripts/marianna/consume/"

FiendFolio.LoadScripts({
    scrIt.."luckycat",
    scrIt.."dadshorts",
    scrIt.."extension",
    --scrIt.."ultima",
    scrIt.."oniondisc",
    scrIt.."happygoluckyonion",
    scrCo.."ojcards",
})
