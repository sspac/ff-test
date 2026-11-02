local mod = FiendFolio
local game = Game()

--old code from before the rgon callback, unused
function mod:ferriumPlaceBombTrigger(player)
	local d = mod:GetEntityData(player)
    if Input.IsActionTriggered(ButtonAction.ACTION_BOMB, player.ControllerIndex) then
        d.JustPlacedBomb = game:GetFrameCount()
    end
end

function mod:ferriumPlacedBombCheck(player, bomb)
    local d = mod:GetEntityData(player)
    if d.JustPlacedBomb and game:GetFrameCount()-d.JustPlacedBomb < 2 and bomb and bomb:Exists() and bomb.Position:Distance(player.Position) < 10 and not bomb.IsFetus then
        local bd = mod:GetEntityData(bomb)
        bd.PlayerPlacedBomb = true

        --mod:charredCardBomb(player, bomb)
    end
    d.JustPlacedBomb = nil
end