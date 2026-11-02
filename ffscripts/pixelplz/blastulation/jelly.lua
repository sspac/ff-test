local mod = FiendFolio

local embryo = {
	Variant = mod.FF.Blastulation.Jelly,

	Strength = 12,
	Duration = 5,
}
mod:AddEmbryo(embryo)



-- Splat color
function embryo:Init(entity)
	entity.SplatColor = Color(1,1,1, 0.5, 0.1,0.1,0.1, 0.1,2,0.1, 1)
end

function embryo:Update(entity)
	local sprite = entity:GetSprite()

	-- Epic splats
	if sprite:IsEventTriggered("Landed") then
		entity:MakeSplat(0.75).Color = entity.SplatColor
	end

	-- Handle the bounce animation
	if sprite:IsOverlayPlaying("Boing") then
		local scale = sprite:GetOverlayNullFrame("Deform"):GetScale()

		for i, layer in pairs( sprite:GetAllLayers() ) do
			layer:SetSize(scale)
		end
	end
end

-- Bounce back entities on contact
function embryo:Collision(entity, target, bool)
	local friendly = entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)

	if (target:ToPlayer() and not friendly) -- Players if hostile
	or (target:ToNPC() and (not friendly or friendly ~= target:HasEntityFlags(EntityFlag.FLAG_FRIENDLY))) then -- Other enemies
		if entity.FrameCount >= 1 then
			local vector = (target.Position - entity.Position):Resized(embryo.Strength)
			target:AddKnockback(EntityRef(entity), vector, embryo.Duration, target:ToNPC() ~= nil)

			-- Effects
			entity:GetSprite():PlayOverlay("Boing", true)
			mod:PlaySoundCool(nil, SoundEffect.SOUND_JELLY_BOUNCE, 0.8, 1.1)
		end

		return true
	end
end