local mod = FiendFolio



function mod:MegaEmbryoUpdate(bigmanbigadventure)
	if bigmanbigadventure.Variant == FiendFolio.FF.MegaEmbryo.Var then
		local sprite = bigmanbigadventure:GetSprite()

		-- Don't move until the jump trigger
		if not sprite:WasEventTriggered("Jump") then
			bigmanbigadventure.Velocity = Vector.Zero
		end


		-- Land effects
		if sprite:IsEventTriggered("Landed") then
			-- Sounds
			SFXManager():Stop(SoundEffect.SOUND_GOOATTACH0)
			mod:PlaySoundCool(nil, SoundEffect.SOUND_FORESTBOSS_STOMPS, 1.1)
			mod:PlaySoundCool(nil, SoundEffect.SOUND_ROCK_CRUMBLE, 0.4)

			-- Shockwaves and shit
			Game():MakeShockwave(bigmanbigadventure.Position, 0.025, 0.025, 10)
			Game():ShakeScreen(8)

			local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 1, bigmanbigadventure.Position, Vector.Zero, bigmanbigadventure):GetSprite()
			poof.Color = Color(0.7,0.7,0.7, 0.75)
			poof.PlaybackSpeed = 0.9
			poof.Scale = Vector.One * 1.1


			-- Kick-up nearby players
			for i, player in ipairs(PlayerManager.GetPlayers()) do
				local vector = player.Position - bigmanbigadventure.Position
				local distance = vector:Length()
				local maxDistance = 200

				if distance <= maxDistance and player.PositionOffset.Y >= 0 then
					local strength = (maxDistance - distance) / 20
					player:TryThrow(EntityRef(bigmanbigadventure), vector:Resized(strength / 3), strength)
				end
			end


			-- Falling effects
			local offscreen = Game():GetRoom():GetTopLeftPos().Y - 80

			-- Rocks
			for i = 1, math.random(3, 5) do
				local position = Isaac.GetRandomPosition()
				local rockHeight = offscreen + -math.random(0, 200)

				local rock = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE, 0, position, Vector.Zero, bigmanbigadventure):ToEffect()
				rock.m_Height = rockHeight - rock.Position.Y
				rock.FallingAcceleration = 2.5
				rock.SpriteScale = Vector.One * math.random(75, 100) / 100

				rock:Update()
				rock:GetSprite():SetFrame(math.random(2, 3))
				rock.State = 2
			end

			-- Falling dust
			for i = 1, math.random(3, 5) do
				local position = Vector(Isaac.GetRandomPosition().X, offscreen)
				local velocity = Vector(0, math.random(30, 60) / 10)
				local scale = math.random(50, 100) / 100
				local color = Color(0.35,0.35,0.35, 0.5)
				local duration = math.random(30, 45)

				local dust = mod:SpawnDust(position, velocity, scale, color, duration)
				dust.DepthOffset = 1000
			end
		end


		-- Death effects
		if bigmanbigadventure:IsDead() then
			-- Sounds
			SFXManager():AdjustPitch(SoundEffect.SOUND_GOODEATH, 0.9)
			mod:PlaySoundCool(nil, SoundEffect.SOUND_ROCKET_BLAST_DEATH, 1.1, 0.95)

			-- Big splat
			local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, bigmanbigadventure.Position, Vector.Zero, bigmanbigadventure):GetSprite()
			splat.Color = bigmanbigadventure.SplatColor
			splat.Scale = Vector.One * 1.1
		end
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.MegaEmbryoUpdate, EntityType.ENTITY_EMBRYO)



--[[
                                                   @@@@@@@@@@@@@@@@@@@@@@@
                                            @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
                                            @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
                                         @@@@@@@@@@@@                   @@@@@@@@@@@@
                                     @@@@@@@@@@@@@@@                     @@@@@@@@@@@@@@@
                                  @@@@@@@@@@@                                  @@@@@@@@@@@@
                                  @@@@@@@@                                         @@@@@@@@
                          @@@@@@@@@@@@                                                @@@@@@@@
                       @@@@@@@@@@@@@@@                                                @@@@@@@@
                       @@@@@@@@@@@@@@@                                                @@@@@@@@
                @@@@@@@@@@@@  @@@@@@@@          @@@@@                          @@@@@  @@@@@@@@
            @@@@@@@@@@@@@@@   @@@@@@@@      @@@@@@@@@                       @@@@@@@@  @@@@@@@@
         @@@@@@@@@@@@@@@      @@@@@@@@      @@@@@@@@@                       @@@@@@@@  @@@@@@@@
         @@@@@@@@  @@@@@      @@@@@@@@                                                @@@@@@@@
      @@@@@@@@                @@@@@@@@             @@@@@@@@@@@@@@@@@@@@@@@@@@         @@@@@@@@
      @@@@@@@@     @@@@@      @@@@@@@@             @@@@@@@@@@@@@@@@@@@@@@@@@@         @@@@@@@@
      @@@@@@@@     @@@@@      @@@@@@@@@                                               @@@@@@@@
      @@@@@@@@         @@@@@      @@@@@@@@                                         @@@@@@@@
      @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
         @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
            @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
]]--