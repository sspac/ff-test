local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

function mod:technologicalGeodeUpdate(player)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.TECHNOLOGICAL_GEODE) then
		local data = mod:GetEntityData(player)
		local mult = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.TECHNOLOGICAL_GEODE)
		local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.TECHNOLOGICAL_GEODE)
        local numLasers = 1
        if mod.HasTwoGeodes(player) then
			numLasers = 2
		end
		
		local input = mod.GetCorrectedFiringInput(player)
		if input:Length() > 0 then
			input = input:GetAngleDegrees()
		else
			input = nil
		end
		

		if input ~= nil and (not data.techGeodeLasers or #data.techGeodeLasers ~= numLasers) then
			data.techGeodeLasers = {}
			
			mod.IgnoreSecondaryFireEffects = true
			if numLasers == 1 then
				data.techGeodeLasers[1] = {player:FireTechLaser(player.Position, 0, Vector(0,1):Rotated(input), false, false, player, 0.3*mult), Vector.Zero}
			elseif numLasers == 2 then
				data.techGeodeLasers[1] = {player:FireTechLaser(player.Position, 0, Vector(0,1):Rotated(input), false, false, player, 0.25*mult), Vector(0,-7)}
				data.techGeodeLasers[2] = {player:FireTechLaser(player.Position, 0, Vector(0,1):Rotated(input), false, false, player, 0.25*mult), Vector(0,7)}
			end
			mod.IgnoreSecondaryFireEffects = false

			for _, lasera in ipairs(data.techGeodeLasers) do
				local laser = lasera[1]
				laser.PositionOffset = Vector(0, -5)
				laser.DepthOffset = player.DepthOffset - 10
				laser.Mass = 0
				laser.MaxDistance = 50+10*mult
				laser:SetTimeout(50)
				laser.Angle = input
				laser:Update()
			end

			sfx:Play(SoundEffect.SOUND_REDLIGHTNING_ZAP, 1, 0, false, 1)
		end
		
		if data.techGeodeLasers then
			for _, lasera in ipairs(data.techGeodeLasers) do
				local laser = lasera[1]
				if not laser:Exists() or input == nil then
					for _, l2a in ipairs(data.techGeodeLasers) do
						local l2 = l2a[1]
						if l2:Exists() then
							l2:Remove()
						end
					end

					data.techGeodeLasers = nil
					break
				else
					laser:SetTimeout(4)
					laser.SpriteScale = Vector.One
					laser.Velocity = player.Position+lasera[2]:Rotated(input) - laser.Position
					laser.Angle = input
				end
			end
		end
    elseif data.techGeodeLasers and #data.techGeodeLasers > 0 then
        data.techGeodeLasers = nil
	end
end
mod:AddTrinketCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.ROCK.TECHNOLOGICAL_GEODE, mod.technologicalGeodeUpdate)