local mod = FiendFolio
local sfx = SFXManager()

--ah right, can't do this because of dynamic dirt...

function mod:famLuncheon(fam, player, sprite, d)
    local rng = fam:GetDropRNG()

    if not d.init then
        d.state = "Emerge"
        d.init = true
    end
end