local mod = FiendFolio
local sfx = SFXManager()

function mod:RoseQuartzTakeDamage(player, source)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.ROSE_QUARTZ) then
		local data = mod:GetEntityData(player)
		local mult = math.ceil(mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.ROSE_QUARTZ))
		if data.roseQuartzShield then
			if data.roseQuartzShield:Exists() then
				if source.Type == 9 then
					mod:GetEntityData(data.roseQuartzShield).flash = true
					mod:StopFFPlayerSoundsIGuess(player)
					mod.scheduleForUpdate(function()
						sfx:Stop(SoundEffect.SOUND_ISAAC_HURT_GRUNT)
					end, 0)
					return false
				else
					data.roseQuartzShield:Remove()
					
					local shield = Isaac.Spawn(1000, 1750, 5, player.Position, Vector.Zero, player):ToEffect()
					shield.Target = player
					shield:FollowParent(player)
					shield.DepthOffset = 10
					shield.SpriteOffset = Vector(0,-15*player.SpriteScale.Y)
					shield.SpriteScale = player.SpriteScale
					mod:GetEntityData(shield).fade = 1.5/mult
					shield:Update()
					
					data.roseQuartzShield = shield
				end
			else
				local shield = Isaac.Spawn(1000, 1750, 5, player.Position, Vector.Zero, player):ToEffect()
				shield.Target = player
				shield:FollowParent(player)
				shield.DepthOffset = 10
				shield.SpriteOffset = Vector(0,-15*player.SpriteScale.Y)
				shield.SpriteScale = player.SpriteScale
				mod:GetEntityData(shield).fade = 1.5/mult
				shield:Update()
				
				data.roseQuartzShield = shield
			end
		else
			local shield = Isaac.Spawn(1000, 1750, 5, player.Position, Vector.Zero, player):ToEffect()
			shield.Target = player
			shield:FollowParent(player)
			shield.DepthOffset = 10
			shield.SpriteOffset = Vector(0,-15*player.SpriteScale.Y)
			shield.SpriteScale = player.SpriteScale
			mod:GetEntityData(shield).fade = 1.5/mult
			shield:Update()
				
			data.roseQuartzShield = shield
		end
	end
end

function mod:roseQuartzShieldEffect(npc)
	local sprite = npc:GetSprite()
	local data = mod:GetEntityData(npc)
	
	if not data.init then
		if data.fade == nil then
			data.fade = 10
		end
		data.init = true
	end
	
	if sprite:IsFinished("Begin") then
		sprite:Play("Idle")
	elseif data.flash == true then
		sprite:Play("Begin")
		data.flash = false
		sfx:Play(SoundEffect.SOUND_BISHOP_HIT, 1, 0, false, 1.5)
	end

	if (data.fade*npc.FrameCount) > 255 then
		mod:GetEntityData(npc.Parent).roseQuartzShield = nil
		sfx:Play(SoundEffect.SOUND_REDLIGHTNING_ZAP_BURST, 0.5, 0, false, 2)
		npc:Remove()
	else
		npc:SetColor(Color(1,0.9,0.9, (255-data.fade*npc.FrameCount)/255, 0.4,0.35,0.35), 99, 1, false, false)
	end
end