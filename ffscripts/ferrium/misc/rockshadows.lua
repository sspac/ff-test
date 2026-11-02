local mod = FiendFolio

function mod:shadowlessRockShadowEffect(effect)
	if effect.Parent then
		local proj = effect.Parent:ToProjectile()
		local sprite = effect:GetSprite()
		local data = mod:GetEntityData(effect)
		effect.Velocity = proj.Position-effect.Position
		local scale = math.max(0, proj.Scale)
		effect.SpriteScale = Vector(scale, scale)
		if data.dontBlink then
			mod:spritePlay(sprite, "Idle")
		else
			local effectiveHeight = proj.Height/proj.FallingSpeed
			if effectiveHeight < -50 or effectiveHeight > 0 then
				mod:spritePlay(sprite, "blink1")
			elseif not data.scheduleBlink2 then
				data.scheduleBlink2 = true
			end
			
			if data.scheduleBlink2 then
				if sprite:GetFrame() > 22 then
					sprite:Play("blink2")
					data.scheduleBlink2 = nil
				end
			end
		end
	else
		effect:Remove()
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, proj)
	if proj.SubType == mod.FF.ShadowlessRock.Sub then
		local data = mod:GetEntityData(proj)
		if not data.shadowlessRockShadow then
			data.shadowlessRockShadow = Isaac.Spawn(mod.FF.ShadowlessRockShadow.ID, mod.FF.ShadowlessRockShadow.Var, mod.FF.ShadowlessRockShadow.Sub, proj.Position, proj.Velocity, proj):ToEffect()
			data.shadowlessRockShadow.Parent = proj
			--data.shadowlessRockShadow:FollowParent(proj)
			data.shadowlessRockShadow.Scale = proj.Scale
			if data.dontBlink then
				mod:GetEntityData(data.shadowlessRockShadow).dontBlink = true
			end
		end
	end
end, 9)

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, proj)
	if proj.SubType == mod.FF.ShadowlessGridProjectile.Sub then
		local data = mod:GetEntityData(proj)
		if not data.shadowlessRockShadow then
			data.shadowlessRockShadow = Isaac.Spawn(mod.FF.ShadowlessRockShadow.ID, mod.FF.ShadowlessRockShadow.Var, mod.FF.ShadowlessRockShadow.Sub, proj.Position, proj.Velocity, proj):ToEffect()
			data.shadowlessRockShadow.Parent = proj
			--data.shadowlessRockShadow:FollowParent(proj)
			data.shadowlessRockShadow.Scale = proj.Scale
			if data.dontBlink then
				mod:GetEntityData(data.shadowlessRockShadow).dontBlink = true
			end
		end
	elseif proj.SubType == mod.FF.SilentBloodProj.Sub then
		local d = mod:GetEntityData(proj)
		if not d.init then
			if not d.makeSplat then
				d.makeSplat = EffectVariant.BULLET_POOF
			end
			local shadow = Isaac.Spawn(mod.FF.ShadowlessRockShadow.ID, mod.FF.ShadowlessRockShadow.Var, mod.FF.ShadowlessRockShadow.Sub, proj.Position, proj.Velocity, proj):ToEffect()
			shadow.Parent = proj
			shadow.Scale = proj.Scale
			mod:GetEntityData(shadow).dontBlink = true
			d.init = true
		end
		if not d.ignoreScale then
			local s = proj:GetSprite()
			local num = math.floor(math.min(13, math.max(1, 6+(proj.Scale-1)/0.333)))
			mod:spritePlay(s, "RegularTear" .. num)
		end
	elseif proj.SubType == mod.FF.SilentRockProj.Sub then
		local d = mod:GetEntityData(proj)
		if not d.init then
			if not d.makeSplat then
				d.makeSplat = EffectVariant.ROCK_POOF
				d.toothParticles = mod.ColorRockGibs
			end
			local shadow = Isaac.Spawn(mod.FF.ShadowlessRockShadow.ID, mod.FF.ShadowlessRockShadow.Var, mod.FF.ShadowlessRockShadow.Sub, proj.Position, proj.Velocity, proj):ToEffect()
			shadow.Parent = proj
			shadow.Scale = proj.Scale
			mod:GetEntityData(shadow).dontBlink = true
			d.init = true
		end
		if not d.ignoreScale then
			local s = proj:GetSprite()
			local num = math.min(6, math.max(0, math.floor(1+proj.Scale/0.5)))
			mod:spritePlay(s, "Rotate" .. num)
		end
	end
end, 8)