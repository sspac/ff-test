local mod = FiendFolio
local game = Game()
local nilvector = Vector.Zero

function mod:HorseFlyUpdate(npc)
	local sprite = npc:GetSprite()
	local d = mod:GetEntityData(npc)
	local room = game:GetRoom()
	
	if not d.init then
		npc.StateFrame = 40
		npc.SplatColor = mod.ColorLemonYellow
		d.init = true
	end
end

function mod:HorseFlyDeath(npc, variant)
	if mod:shouldDoDeathEffect(npc) then
		Isaac.Spawn(160, 1006, 0, npc.Position, Vector.Zero, npc)
	end
end

-- amy wanted me to make a mega satan fly but mega satan disappeared on frame 1.....................