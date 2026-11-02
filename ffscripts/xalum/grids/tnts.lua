local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

mod.TntVariant = {
	SUPER = 750,
	WATER = 751,
}

mod.tntBehaviour = {}
mod.tntSkin = {}
mod.tntVariantFromPath = {}

function mod.RegisterTnt(variant, skin, onBreak)
	mod.tntBehaviour[tostring(variant)] = onBreak
	mod.tntSkin[tostring(variant)] = skin
	mod.tntVariantFromPath[skin] = variant
end

function mod.GetTntSkin(variant)
	return mod.tntSkin[tostring(variant)] or mod.tntSkin["750"]
end

function mod.TntCommonBreak(entity, fromTear)
	-- Spawn particle effects
	for i = 1, 6 do
		local particle = Isaac.Spawn(1000, 27, 0, entity.Position, RandomVector() * math.random(5, 30) / 10, entity)
		local sprite = particle:GetSprite()
		local skin = mod.GetTntSkin(entity.Variant)
		if fromTear then skin = entity:GetSprite():GetFilename() end

		sprite:Load(skin, true)
		sprite:Play("Gib" .. math.random(4), true)
		mod:GetEntityData(particle).turnedIntoCoolBetterParticles = true
		particle:Update()
	end

	-- Safe remove
	mod:GetEntityData(entity).dontDoAnything = true
	entity:GetSprite():Play("Blown")
	entity:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR)
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
	local data = mod:GetEntityData(npc)
	local sprite = npc:GetSprite()

	if npc.FrameCount < 1 and npc.Variant >= 750 and npc.Variant <= 760 then
		if sprite:IsPlaying("Blown") then
			data.dontDoAnything = true
		end
	end

	if npc.Variant == 750 then -- Super TNT
		npc.Velocity = Vector.Zero
		if not data.dontDoAnything then
			mod.QuickSetEntityGridPath(npc, 3999)
		end
	elseif npc.Variant == 751 then
		if not data.dontDoAnything then
			mod.QuickSetEntityGridPath(npc, 900)
		end
	elseif npc.Variant == 752 then
		npc.Velocity = Vector.Zero
		if not data.dontDoAnything then
			mod.QuickSetEntityGridPath(npc, 3999)
		end
	end
end, 292) -- Pushable TNT

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.EARLY, function(_, entity, amount, flags)
	if mod:GetEntityData(entity).dontDoAnything then
		return false
	end
end, 292) -- Pushable TNT

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.LATE, function(_, entity, amount, flags)
	if mod.tntBehaviour[tostring(entity.Variant)] then
		local realAmount = math.min(math.max(math.floor(amount / 15), 1), 3)
		if entity.HitPoints - realAmount <= 1 or flags & (DamageFlag.DAMAGE_TNT | DamageFlag.DAMAGE_EXPLOSION) ~= 0 or entity:IsDead() then
			mod.TntCommonBreak(entity)
			mod.tntBehaviour[tostring(entity.Variant)](entity)
		else
			entity.HitPoints = entity.HitPoints - realAmount
		end

		return false
	end
end, 292) -- Pushable TNT

mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, function(_, tear)
	local variant = mod.tntVariantFromPath[tear:GetSprite():GetFilename()]
	if variant then
		mod.tntBehaviour[tostring(variant)](tear, true)
		mod.TntCommonBreak(tear, true)
	end
end, TearVariant.GRIDENT)

mod:AddCallback(ModCallbacks.MC_PRE_TEAR_GRID_COLLISION, function(_, tear)
	local variant = mod.tntVariantFromPath[tear:GetSprite():GetFilename()]
	if variant then
		mod.tntBehaviour[tostring(variant)](tear, true)
		mod.TntCommonBreak(tear, true)
	end
end, TearVariant.GRIDENT)

mod:AddCallback(ModCallbacks.MC_PRE_TEAR_UPDATE, function(_, tear) -- Why no PRE_TEAR_FLOOR_COLLISION :(
	if tear.Height + tear.FallingSpeed > 0 and not tear:IsDead() then
		local variant = mod.tntVariantFromPath[tear:GetSprite():GetFilename()]
		if variant then
			mod.tntBehaviour[tostring(variant)](tear, true)
			mod.TntCommonBreak(tear, true)
		end
	end
end, TearVariant.GRIDENT)

mod.RegisterTnt(mod.TntVariant.SUPER, "gfx/grid/super_tnt.anm2", function(entity)
	game:BombExplosionEffects(entity.Position, 100, 0, Color(0, 0, 0, 0, 0, 0, 0), entity, 0.5, false, true)
	Isaac.Spawn(1000, 1, 0, entity.Position, Vector.Zero, entity)

	Isaac.CreateTimer(function()
		for i = 1, 4 do
			local position = entity.Position + Vector(40, 0):Rotated(90 * i)

			game:BombExplosionEffects(position, 100, 0, Color(0, 0, 0, 0, 0, 0, 0), entity, 0.5, false, true)
			Isaac.Spawn(1000, 1, 0, position, Vector.Zero, entity)
		end
	end, 5, 1, false)

	Isaac.CreateTimer(function()
		for i = 1, 2 do
			local position = entity.Position + Vector(80, 0):Rotated(180 * i)

			game:BombExplosionEffects(position, 50, 0, Color(0, 0, 0, 0, 0, 0, 0), entity, 0.5, false, true)
			Isaac.Spawn(1000, 1, 0, position, Vector.Zero, entity)
		end
	end, 10, 1, false)
end)

mod.RegisterTnt(mod.TntVariant.WATER, "gfx/grid/water_tnt.anm2", function(entity)
	Isaac.Spawn(1000, 7019, 0, entity.Position, Vector.Zero, nil)
	sfx:Play(mod.Sounds.Waterboom, 2, 0, false, 1)
	mod.QuickSetEntityGridPath(entity, 0)

	local creep = Isaac.Spawn(1000, 32, 0, entity.Position + Vector(0, 10), Vector.Zero, entity):ToEffect()
	local color = Color(1,1,1,1,0,0,0)
	color:SetColorize(160/255,190/255,230/255,1)
	creep.Color = color
	creep:SetTimeout(90)
	creep:Update()

	for i = 22.5, 360, 22.5 do
		local tear = Isaac.Spawn(2, 0, 0, entity.Position, Vector(9, 0):Rotated(i), entity)
	end
end)

-- tnt, supertnt, watertnt, compost
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
	if npc.Variant == 750 or npc.Variant == 752 then
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
		npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
		npc.Velocity = Vector.Zero
	end
end, 292)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
	local sprite = effect:GetSprite()
	if sprite:IsFinished("Explosion") then
		effect:Remove()
	end

	if not mod:GetEntityData(effect).alreadyHit then
		mod:GetEntityData(effect).alreadyHit = true
		local extinguishedSomething
		for _, e in pairs(Isaac.FindInRadius(effect.Position, 80, 0xffffffff)) do
			if e.Type == 10 and e.Variant == 2 then -- Flaming Gaper
				e:ToNPC():Morph(10, 1, 0, e:ToNPC():GetChampionColorIdx())
				e:GetSprite():PlayOverlay("Head")
				e:TakeDamage(e.MaxHitPoints/5, 0, EntityRef(Isaac.GetPlayer(0)), 0)
				extinguishedSomething = true
			elseif e.Type == 54 and e.Variant == 0 then -- Flaming Hopper
				e:ToNPC():Morph(29, 0, 0, e:ToNPC():GetChampionColorIdx())
				e:TakeDamage(e.MaxHitPoints/5, 0, EntityRef(Isaac.GetPlayer(0)), 0)
				extinguishedSomething = true
			elseif e.Type == 208 and e.Variant == 2 then -- Flaming Fatty
				e:ToNPC():Morph(208, 0, 0, e:ToNPC():GetChampionColorIdx())
				e:TakeDamage(e.MaxHitPoints/5, 0, EntityRef(Isaac.GetPlayer(0)), 0)
				extinguishedSomething = true
			elseif e.Type == 226 and e.Variant == 2 then -- Crispy
				e:ToNPC():Morph(226, 0, 0, e:ToNPC():GetChampionColorIdx())
				local s = e:GetSprite()
				s:Load("gfx/226.002_crispy.anm2", true)
				s:ReplaceSpritesheet(3, "haha.png")
				s:LoadGraphics()
				if e:ToNPC():IsChampion() and not mod.SpritesheetlessChamps[e:ToNPC():GetChampionColorIdx()] then
					if LastJudgementSprites then
						mod:ReplaceEnemySpritesheet(e, "gfx/monsters/afterbirthplus/crispy_body", 0)
					else
						mod:ReplaceEnemySpritesheet(e, "gfx/monsters/classic/monster_000_bodies01", 0)
					end
					mod:ReplaceEnemySpritesheet(e, "gfx/monsters/afterbirthplus/crispy", 1)
					for i=0, 2 do
						local layer = s:GetLayer(i)
						layer:SetRenderFlags(layer:GetRenderFlags() | AnimRenderFlags.COLOROFFSET_CHAMPION)
					end
				end
				s:PlayOverlay("Head")
				e:TakeDamage(e.MaxHitPoints/5, 0, EntityRef(Isaac.GetPlayer(0)), 0)
				extinguishedSomething = true
			elseif e.Type == 33 and e.Variant <= 1 then -- (Red) Fireplace
				e:TakeDamage(99999, 0, EntityRef(effect), 0)
			elseif e.Type == 1000 and (e.Variant == 51 or e.Variant == 52) then -- Fire/Red Flame
				e:Remove()
				extinguishedSomething = true
			elseif e.Type == 1000 and e.Variant == 26 and (e.SubType == 7000 or e.SubType == 7001) then -- Gunpowder (FiendFolio)
				e:Remove()
			elseif e.Type == 1000 and e.Variant == 7005 then -- Gunpowder fire (FiendFolio)
				e:Remove()
				extinguishedSomething = true
			elseif e.Type == 1000 and e.Variant == 7015 then -- Fiend Fire (FiendFolio)
				e:Remove()
			elseif e.Type == mod.FF.Spitroast.ID and e.Variant == mod.FF.Spitroast.Var then -- Spitroast
				--e:ToNPC():Morph(61, 0, 0, e:ToNPC():GetChampionColorIdx())
				e:TakeDamage(e.MaxHitPoints/5, 0, EntityRef(Isaac.GetPlayer(0)), 0)
				extinguishedSomething = true
			elseif e.Type == mod.FF.Spitfire.ID and e.Variant == mod.FF.Spitfire.Var then -- Spitroast
				--e:ToNPC():Morph(61, 0, 0, e:ToNPC():GetChampionColorIdx())
				e:TakeDamage(e.MaxHitPoints/5, 0, EntityRef(Isaac.GetPlayer(0)), 0)
				extinguishedSomething = true
			elseif e.Type == 208 and e.Variant == 963 then -- Big Smoke
				--e:ToNPC():Morph(208, 0, 0, e:ToNPC():GetChampionColorIdx())
				e:TakeDamage(e.MaxHitPoints/5, 0, EntityRef(Isaac.GetPlayer(0)), 0)
				extinguishedSomething = true
				--e:Kill()
			elseif e.Type == 240 and e.Variant == 700 then -- Fried
				mod:GetEntityData(e).unignited = true
				e:TakeDamage(e.MaxHitPoints/5, 0, EntityRef(Isaac.GetPlayer(0)), 0)
				extinguishedSomething = true
			elseif e.Type == mod.FF.Smore.ID and e.Variant == mod.FF.Smore.Var then -- S'more
				extinguishedSomething = true
				local ed = mod:GetEntityData(e)
				if not ed.unignited then
					ed.unignited = true
					ed.AshLeave = false
					local smoresprite = e:GetSprite()
					mod:ReplaceEnemySpritesheet(e, "gfx/enemies/slamboy/smoreextinguished", 1)
					smoresprite:ReplaceSpritesheet(0, "gfx/nothing.png")
					smoresprite:LoadGraphics()
					e:TakeDamage(e.MaxHitPoints/5, 0, EntityRef(Isaac.GetPlayer(0)), 0)
				end
			elseif e.Type == mod.FF.Flare.ID and e.Variant == mod.FF.Flare.Var then -- Mr Flare
				extinguishedSomething = true
				--e:ToNPC():Morph(12, 0, 0, e:ToNPC():GetChampionColorIdx())
				mod:GetEntityData(e).unignited = true
				e:TakeDamage(e.MaxHitPoints/5, 0, EntityRef(Isaac.GetPlayer(0)), 0)
			elseif e.Type == mod.FF.Woodburner.ID and e.Variant == mod.FF.Woodburner.Var then -- Woodburner
				extinguishedSomething = true
				mod:GetEntityData(e).unignited = true
				e:TakeDamage(e.MaxHitPoints/5, 0, EntityRef(Isaac.GetPlayer(0)), 0)
			elseif e.Type == mod.FF.Fumegeist.ID and e.Variant == mod.FF.Fumegeist.Var then -- Fumegeist
				extinguishedSomething = true
				mod:GetEntityData(e).state = "BecomeNormal"
				e:TakeDamage(e.MaxHitPoints/5, 0, EntityRef(Isaac.GetPlayer(0)), 0)
			elseif e.Type == mod.FF.Mote.ID and e.Variant == mod.FF.Mote.Var then -- Mote
				extinguishedSomething = true
				mod:GetEntityData(e).flaming = false
				e:TakeDamage(e.MaxHitPoints/5, 0, EntityRef(Isaac.GetPlayer(0)), 0)
			elseif e.Type == mod.FF.Charlie.ID and e.Variant == mod.FF.Charlie.Var then -- Charlie
				extinguishedSomething = true
				--e:ToNPC():Morph(10, 1, 0, e:ToNPC():GetChampionColorIdx())
				e:TakeDamage(e.MaxHitPoints/5, 0, EntityRef(Isaac.GetPlayer(0)), 0)
				--e:Kill()
			elseif e.Type == mod.FF.Sooty.ID and e.Variant == mod.FF.Sooty.Var then -- Sooty
				extinguishedSomething = true
				--e:ToNPC():Morph(284, 0, 0, e:ToNPC():GetChampionColorIdx())
				e:TakeDamage(e.MaxHitPoints/5, 0, EntityRef(Isaac.GetPlayer(0)), 0)
				--e:Kill()
			elseif e.Type == 750 and e.Variant == 110 then -- Wick
				extinguishedSomething = true
				mod:GetEntityData(e).unignited = true
				e:TakeDamage(e.MaxHitPoints/5, 0, EntityRef(Isaac.GetPlayer(0)), 0)
			elseif e.Type == 114 and e.Variant == 8 then -- Crucible
				extinguishedSomething = true
				mod:GetEntityData(e).ignited = false
				e:TakeDamage(e.MaxHitPoints/5, 0, EntityRef(Isaac.GetPlayer(0)), 0)
			end
		end
		if extinguishedSomething then
			sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS,1,1,false,1.5)
		end
	end
end, 7019) -- Water Explosion