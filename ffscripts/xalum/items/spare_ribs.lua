local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

mod:AddCollectibleCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.ITEM.COLLECTIBLE.SPARE_RIBS, function(_, entity, amount, flags, src, frames)
	local player = entity:ToPlayer()
	local data = mod:GetEntityData(player)

	if player:GetPlayerType() == PlayerType.PLAYER_JACOB_B and src.Type == EntityType.ENTITY_DARK_ESAU then
		return
	end
	
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.SPARE_RIBS) then
		if not data.ribsout or data.ribsout <= 0 then
			sfx:Play(SoundEffect.SOUND_BONE_SNAP, 0.6, 0, false, 1)
			local ribs = 6 * player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.SPARE_RIBS)
			data.ribsout = ribs
			for i = 1, ribs do
				mod.IgnoreSecondaryFireEffects = true
				local tear = player:FireTear(player.Position, Vector(11, 0):Rotated(i * 360/ribs), false, true, false):ToTear()
				mod.IgnoreSecondaryFireEffects = false
				tear.TearFlags = TearFlags.TEAR_PIERCING | TearFlags.TEAR_SPECTRAL
				tear.FallingAcceleration = 0
				tear.FallingAcceleration = 0
				mod:GetEntityData(tear).isrib = true
				--tear:GetSprite():Load("gfx/projectiles/boomerang rib.anm2", true)
				--tear:GetSprite():Play("friendly", true)
				mod:changeTearVariant(tear, mod.TEAR.BOOMERANG_RIB)
			end
		end
	end
end, EntityType.ENTITY_PLAYER)

FiendFolio.AddItemPickupCallback(function(player, added)
	player:AddBoneHearts(added)
end, nil, mod.ITEM.COLLECTIBLE.SPARE_RIBS)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
	local d = mod:GetEntityData(tear)

	if d.isrib then
		-- failsafe in case the parent no longer exists (biend minions for example)
		local tearParent = tear.Parent or Isaac.GetPlayer(0)

		tear = tear:ToTear()
		tear.Height = -24
		tear.Velocity = tear.Velocity:Resized(tear.Velocity:Length() * ((tear.Position:Distance(tearParent.Position) > 60 or tear.FrameCount < 20) and 0.9 or 0.6)) + (tearParent.Position - tear.Position):Resized(tear.Position:Distance(tearParent.Position) > 60 and 0.9 or (tear.FrameCount < 20 and 0.9 or 20))
		if tear.Velocity:Length() < 11 then
			tear.Velocity = tear.Velocity * 1.2
		end
		if tear.Velocity:Length() > 11 then
			tear.Velocity = tear.Velocity:Resized(11)
		end
		for _, p in pairs(Isaac.FindByType(9, -1, -1, false, false)) do
			if tear.Position:Distance(p.Position) - tear.Size - p.Size <= 0 then
				p:Kill()
			end
		end
		if tear.Position:Distance(tearParent.Position) - tear.Size - tearParent.Size <= 0 and tear.FrameCount > 10 then
			tear:Remove()
			--sfx:Play(SoundEffect.SOUND_SCAMPER, 0.6, 0, false, 1)
			if mod:GetEntityData(tearParent).ribsout then
				mod:GetEntityData(tearParent).ribsout = mod:GetEntityData(tearParent).ribsout - 1
			end
		end
		if d.removaltime then tear:Remove() end
	end
end)

function mod:boomerangRibTearRender(tear, var, data, offset)
	local sprite = tear:GetSprite()
	local scale = tear.Scale
	local sizeMulti = tear.SizeMulti
	local flags = tear.TearFlags

	if not sprite:IsPlaying("friendly") then
		local frame = sprite:GetFrame()
		sprite:Play("friendly", true)
		sprite:SetFrame(frame)
	end

	local layers = sprite:GetAllLayers()
	for _, layer in ipairs(layers) do
		layer:SetSize(Vector(1, 1))
	end

	if flags & TearFlags.TEAR_FLAT == TearFlags.TEAR_FLAT then
		local adjustedVelocity = tear.Velocity
		if tear.WaitFrames > 0 then
			adjustedVelocity = tear.ContinueVelocity
		elseif (tear.FallingSpeed < 0 or 0.2 < tear.FallingSpeed) and
		       flags & TearFlags.TEAR_LUDOVICO ~= TearFlags.TEAR_LUDOVICO and
		       ((flags & TearFlags.TEAR_ABSORB ~= TearFlags.TEAR_ABSORB and flags & TearFlags.TEAR_POP ~= TearFlags.TEAR_POP) or tear.Velocity:Length() <= 0.1)
		then
			adjustedVelocity = adjustedVelocity + Vector(0, tear.FallingSpeed)
		end

		sprite.Rotation = adjustedVelocity:GetAngleDegrees()
		sprite.FlipX = false
		sprite.FlipY = false
	else
		sprite.Rotation = 0
		sprite.FlipX = false
		sprite.FlipY = false
	end
end
mod:AddCallback("FF_CUSTOM_TEAR_RENDER", mod.boomerangRibTearRender, FiendFolio.TEAR.BOOMERANG_RIB)

function mod:boomerangRibTearSplat(tear, var, data)
	sfx:Play(SoundEffect.SOUND_SCAMPER, 0.6, 0, false, 1)

	if tear.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE then return end

	--[[local scale = tear.Scale
	local color = tear:GetSprite().Color

	local poof = Isaac.Spawn(1000, EffectVariant.IMPACT, 0, tear.Position, nilvector, tear)
	poof:GetSprite().Color = color
	poof.SpriteScale = Vector(scale * 0.8, scale * 0.8)
	poof.PositionOffset = tear.PositionOffset

	for i = 1, 5 do
		local gib = Isaac.Spawn(1000, EffectVariant.NAIL_PARTICLE, 0, tear.Position, RandomVector()*2, tear):ToEffect()
		gib.m_Height = math.min(-5, tear.Height)
		gib:GetSprite().Color = color
		gib.State = 2
	end]]--
end
mod:AddCallback("FF_CUSTOM_TEAR_SPLAT", mod.boomerangRibTearSplat, FiendFolio.TEAR.BOOMERANG_RIB)