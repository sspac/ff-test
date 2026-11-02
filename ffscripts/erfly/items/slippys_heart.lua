local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

mod:AddCollectibleCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.ITEM.COLLECTIBLE.SLIPPYS_HEART, function(_, player)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.SLIPPYS_HEART) then
		local n = mod.FindClosestEnemy(player.Position, 80, true, true)
		if n then
			player.Position = player.Position + RandomVector()
			if player.FrameCount % 5 == 1 then
				player:SetColor(Color(1,1,1,1,100 / 255,0,0),3,1,true,false)
			end
			if player.FrameCount % 10 == 1 then
				local data = mod:GetEntityData(player)
				data.slippysHeartFartAttempts = data.slippysHeartFartAttempts or 0
				data.slippysHeartFartAttempts = data.slippysHeartFartAttempts + 1
				if math.random(math.floor(n.Position:Distance(player.Position))) <= math.max((player.Luck * 2 + 5), 1) or mod:GetEntityData(player).slippysHeartFartAttempts > 30 then
					data.slippysHeartFartAttempts = 0
					local rand = math.random(50)
					if rand == 1 then
						Game():Fart(player.Position, 80, player, 1, 0)
						for i = 45, 360, 45 do
							Game():Fart(player.Position + Vector(40, 0):Rotated(i), 80, player, 1, 0)
						end
						game:ButterBeanFart(player.Position, 280, player, false)
						sfx:Play(mod.Sounds.FartFrog4,1,0,false,math.random(90,110)/100)
						Game():ShakeScreen(50)
						sfx:Stop(SoundEffect.SOUND_FART)
					elseif rand < 10 then
						sfx:Play(mod.Sounds.FartFrog1,0.2,0,false,math.random(80,120)/100)
						local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, player.Position, player.Velocity:Resized(-1), player):ToEffect();
						smoke.Color = Color(0,0,0,1,100 / 255,100 / 255,100 / 255)
						smoke.SpriteOffset = Vector(0,-10)
						smoke.SpriteRotation = math.random(360)
						smoke:Update()
					elseif rand < 30 then
						Game():Fart(player.Position, 80, player, 1, 0)
						game:ButterBeanFart(player.Position, 280, player, false)
						sfx:Play(mod.Sounds.FartFrog3,1,0,false,math.random(90,110)/100)
						Game():ShakeScreen(10)
						sfx:Stop(SoundEffect.SOUND_FART)
					else
						Game():ShakeScreen(5)
						sfx:Play(mod.Sounds.FartFrog2,1,0,false,math.random(70,130)/100)
						game:ButterBeanFart(player.Position, 280, player, true)
						sfx:Stop(SoundEffect.SOUND_FART)
					end
				end
			end
		end
	end
end)