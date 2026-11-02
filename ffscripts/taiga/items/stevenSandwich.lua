-- Steven Sandwich --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, function(_, collectible, charge, firstTime, slot, vardata, player)
	if firstTime then
		FiendFolio:AddStevenHearts(player, 3)
	end
end, FiendFolio.ITEM.COLLECTIBLE.STEVEN_SANDWICH)



-- Abyss Locust
local screenWrapDistance = 150
local invertedColor = Color(-1,-1,-1, 1, 1,1,1, 1,1,1, 1)

function mod:StevenLocustUpdate(familiar)
	local room = Game():GetRoom()

	-- Pre-wrap
	if familiar.Keys == 0 then
		familiar.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE

		if not room:IsPositionInRoom(familiar.Position, -screenWrapDistance) then
			familiar.Position = room:ScreenWrapPosition(familiar.Position, -screenWrapDistance)
			familiar.Keys = 1
			familiar.Color = invertedColor
		end

	-- Post-wrap
	else
		-- Enable collision when re-entering the room
		if familiar.Keys == 1 then
			if room:IsPositionInRoom(familiar.Position, familiar.Size) then
				familiar.Keys = 2
				familiar.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
			else
				familiar.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
			end

		-- Fade back to black
		elseif familiar.FireCooldown > 0 then
			familiar.Keys = 0
			familiar.Color = Color.Default
			familiar:SetColor(invertedColor, 5, 1, true)
		end
	end
end
mod.ErflyLocustDict[mod.ITEM.COLLECTIBLE.STEVEN_SANDWICH] = { Update = mod.StevenLocustUpdate, }
mod.ErflyLocustDict[mod.ITEM.COLLECTIBLE.YCUK_HEART] 	  = { Update = mod.StevenLocustUpdate, }
mod.ErflyLocustDict[mod.ITEM.COLLECTIBLE.STEVENS_HAT] 	  = { Update = mod.StevenLocustUpdate, }