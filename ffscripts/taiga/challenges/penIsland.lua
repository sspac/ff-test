-- Pen Island --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local dirToAng = {
	[Direction.LEFT] = 180,
	[Direction.UP] = 270,
	[Direction.RIGHT] = 0,
	[Direction.DOWN] = 90
}

mod:AddChallengeCallback(ModCallbacks.MC_PLAYER_INIT_POST_LEVEL_INIT_STATS, mod.challenges.penIsland, function(_, player)
	player:AddSmeltedTrinket(mod.ITEM.TRINKET.TRINITY_WORM)
	player:AddSoulHearts(-1)
	player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.PLANET_X))
end)

function mod:penIslandDevilsUmbrella(player)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.DEVILS_UMBRELLA) then
		local fireDirection = player:GetFireDirection()
		if fireDirection ~= Direction.NO_DIRECTION then
			local data = mod:GetEntityData(player)

			data.penIslandFireDelay = (data.penIslandFireDelay or 0) - 1
			while data.penIslandFireDelay <= 0 do
				if math.random(4) == 1 then
					local angle
					if player:HasCollectible(CollectibleType.COLLECTIBLE_ANALOG_STICK) then
						angle = player:GetShootingJoystick():GetAngleDegrees() % 360
					else
						angle = dirToAng[fireDirection]
					end
					mod:firePiss(player, Vector.FromAngle(angle))
				end

				data.penIslandFireDelay = data.penIslandFireDelay + player.MaxFireDelay
			end
		end
	end
end
mod:AddChallengeCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.challenges.penIsland, mod.penIslandDevilsUmbrella)
