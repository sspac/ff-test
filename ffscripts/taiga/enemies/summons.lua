-- Summons --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local DISTORT_TIME = 30
local PULSE_TIME = 5
local SUMMON_TIME = 30
local FADEOUT_TIME = 60

-- For all those enemies that don't have appear animations / set sprite offset on first update / do other funny things
-- Far from a complete list but should at the least include all Mausoleum enemies
FiendFolio.SummonsCompatibilities = {
	[EntityType.ENTITY_PICKUP .. " " .. PickupVariant.PICKUP_COLLECTIBLE] = {Anim = "Idle", Frame = 0, OverlayAnim = "Alternates", OverlayFrame = 0}, -- Item Pedestal
	[EntityType.ENTITY_GAPER] = {Anim = "WalkVert", Frame = 0, OverlayAnim = "Head", OverlayFrame = 0}, -- Gapers
	[EntityType.ENTITY_GRUDGE] = {Anim = "SummonCircle", Frame = 0}, -- Grudge
	[mod.FF.EyeOfShaggoth.ID .. " " .. mod.FF.EyeOfShaggoth.Var] = {Anim = "SummonCircle", Frame = 0}, -- Eye of Shaggoth
	[EntityType.ENTITY_REVENANT .. " " .. 0] = {Anim = "WalkDown", Frame = 0, OverlayAnim = "HeadWalkDown", OverlayFrame = 0}, -- Revenant
	[EntityType.ENTITY_REVENANT .. " " .. 1] = {Anim = "WalkDown", Frame = 0, OverlayAnim = "HeadWalk", OverlayFrame = 0}, -- Quad Revenant
	[mod.FF.Banshee.ID .. " " .. mod.FF.Banshee.Var] = {SpriteOffset = Vector(0,-14), FlipX = true}, -- Banshee
	[mod.FF.MrBones.ID .. " " .. mod.FF.MrBones.Var] = {Anim = "WalkDown", Frame = 0}, -- Mr. Bones
	[mod.FF.Flickerspirit.ID .. " " .. mod.FF.Flickerspirit.Var] = {Anim = "SummonCircle", Frame = 0}, -- Flickerspirit
	[EntityType.ENTITY_WHIPPER] = {Anim = "WalkDown", Frame = 0, OverlayAnim = "HeadDown", OverlayFrame = 0}, -- Whipper, Snapper, Flagellent, etc.
	[mod.FF.Morsel.ID .. " " .. mod.FF.Morsel.Var] = {Anim = "WalkVert", Frame = 0, OverlayAnim = "Head", OverlayFrame = 0}, -- Morsel
	[mod.FF.Falafel.ID .. " " .. mod.FF.Falafel.Var] = {Anim = "WalkVert", Frame = 0, OverlayAnim = "Head", OverlayFrame = 0}, -- Falafel, Cancerlet
	[mod.FF.Slick.ID .. " " .. mod.FF.Slick.Var] = {Anim = "WalkVert", Frame = 0, OverlayAnim = "Head", OverlayFrame = 0}, -- Slick
	[mod.FF.Stump.ID .. " " .. mod.FF.Stump.Var] = {Anim = "WalkVert", Frame = 0, OverlayAnim = "Gush", OverlayFrame = 0}, -- Stump
	[mod.FF.Balor.ID .. " " .. mod.FF.Balor.Var] = {Anim = "WalkVert", Frame = 0, OverlayAnim = "Head", OverlayFrame = 0}, -- Balor
	[mod.FF.GlassEye.ID .. " " .. mod.FF.GlassEye.Var] = {Anim = "SummonCircle", Frame = 0}, -- Glass Eye
	[EntityType.ENTITY_RAGLING] = {Anim = "Idle", Frame = 0}, -- Ragling
	[mod.FF.Sixth.ID .. " " .. mod.FF.Sixth.Var] = {Anim = "WalkVert", Frame = 0, OverlayAnim = "Head", OverlayFrame = 0}, -- Sixth
	[EntityType.ENTITY_DEATHS_HEAD] = {Anim = "Appear"}, -- Death's Head
	[EntityType.ENTITY_FLESH_DEATHS_HEAD] = {Anim = "Appear"}, -- Flesh Death's Head
	[mod.FF.Psyclopia.ID .. " " .. mod.FF.Psyclopia.Var] = {Anim = "WalkVert", Frame = 0, OverlayAnim = "Head", OverlayFrame = 0}, -- Psyclopia
	[mod.FF.Alderman.ID .. " " .. mod.FF.Alderman.Var] = {Anim = "SummonsBody", Frame = 0, OverlayAnim = "SummonsHead", OverlayFrame = 0}, -- Alderman
	[mod.FF.Nihilist.ID .. " " .. mod.FF.Nihilist.Var] = {Anim = "Idle", Frame = 0}, -- Nihilist
	[mod.FF.Wick.ID .. " " .. mod.FF.Wick.Var] = {Anim = "WalkVert", Frame = 0, OverlayAnim = "Head", OverlayFrame = 0}, -- Wick
	[mod.FF.Flanks.ID .. " " .. mod.FF.Flanks.Var] = {Anim = "WalkVert", Frame = 0, OverlayAnim = "SummonsHead", OverlayFrame = 0}, -- Flanks
	[mod.FF.Grimoire.ID .. " " .. mod.FF.Grimoire.Var] = {Anim = "SummonCircle", Frame = 0}, -- Grimoire
	[mod.FF.Lunksack.ID .. " " .. mod.FF.Lunksack.Var] = {Anim = "Idle", Frame = 0}, -- Lunksack
	[mod.FF.Primemind.ID .. " " .. mod.FF.Primemind.Var] = {SpriteOffset = Vector(0,-15)}, -- Primemind
	[mod.FF.Jawbone.ID .. " " .. mod.FF.Jawbone.Var] = {SpriteOffset = Vector(0,-5), PositionOffset = Vector(0,-20)}, -- Jawbone
	[mod.FF.Ribbone.ID .. " " .. mod.FF.Ribbone.Var] = {PositionOffset = Vector(0,-30)}, -- Ribbone
	[mod.FF.JawboneCorpse.ID .. " " .. mod.FF.JawboneCorpse.Var] = {Anim = "Die", Frame = 15, SpriteOffset = Vector(0,-17)}, -- Jawbone Corpse
	[mod.FF.Pawn.ID .. " " .. mod.FF.Pawn.Var] = {Anim = "WalkVert", Frame = 0, OverlayAnim = "HeadDown", OverlayFrame = 0}, -- Pawn
	[mod.FF.HollowKnight.ID .. " " .. mod.FF.HollowKnight.Var] = {Anim = "WalkDown", Frame = 0}, -- Hollow Knight
	[mod.FF.Patzer.ID .. " " .. mod.FF.Patzer.Var] = {Anim = "SummonCircle", Frame = 0, Size = 40}, -- Patzer
	[mod.FF.ArcaneCreep.ID .. " " .. mod.FF.ArcaneCreep.Var] = {Anim = "SummonCircle", Frame = 0}, -- Arcane Creep
	[EntityType.ENTITY_VIS_FATTY .. " " .. 0] = {Anim = "WalkVert", Frame = 0}, -- Vis Fatty
	[EntityType.ENTITY_FAT_SACK] = {Anim = "WalkVert", Frame = 0}, -- Fat Sack
	[EntityType.ENTITY_BLUBBER] = {Anim = "WalkVert", Frame = 0}, -- Blubber
	[EntityType.ENTITY_HALF_SACK] = {Anim = "WalkVert", Frame = 0}, -- Half Sack
	[EntityType.ENTITY_BIG_BONY] = {Anim = "WalkVert", Frame = 0}, -- Big Bony
	[EntityType.ENTITY_MRMAW .. " " .. 0] = {Anim = "Idle", Frame = 0}, -- Mr. Maw
	[EntityType.ENTITY_MRMAW .. " " .. 2] = {Anim = "Idle", Frame = 0}, -- Mr. Red Maw
	[EntityType.ENTITY_VIS_VERSA] = {Anim = "WalkVert", Frame = 0}, -- Vis Versa
	[mod.FF.Spinny.ID .. " " .. mod.FF.Spinny.Var] = {Anim = "Idle", Frame = 0}, -- Spinny
	[mod.FF.Rancor.ID .. " " .. mod.FF.Rancor.Var] = {Anim = "IdleU", Frame = 0}, -- Rancor
	[mod.FF.Skulltist.ID .. " " .. mod.FF.Skulltist.Var] = {Anim = "SummonCircle", Frame = 0}, -- Skulltist
	[EntityType.ENTITY_PORTAL .. " " .. 1] = {Anim = "SummonCircle", Frame = 0}, -- Lil Portal
	[EntityType.ENTITY_LITTLE_HORN .. " " .. 1] = {SpriteOffset = Vector(0,-20)}, -- Dark Ball
	[mod.FF.Shi.ID .. " " .. mod.FF.Shi.Var] = {Anim = "SummonCircle", Frame = 0}, -- Shi
	[mod.FF.Madhat.ID .. " " .. mod.FF.Madhat.Var] = {Anim = "Idle", Frame = 0}, -- Madhat
	[mod.FF.Clergy.ID .. " " .. mod.FF.Clergy.Var] = {Anim = "SummonCircle", Frame = 0}, -- Clergy
	[mod.FF.Zissuru.ID .. " " .. mod.FF.Zissuru.Var] = {Anim = "SummonCircle", Frame = 0}, -- Zissuru
	[mod.FF.PsychoFly.ID .. " " .. mod.FF.PsychoFly.Var] = {Anim = "SummonCircle", Frame = 0}, -- Psycho Fly
	[EntityType.ENTITY_MAW .. " " .. 2] = {Anim = "SummonCircle", Frame = 0}, -- Psychic Maw
	[EntityType.ENTITY_PSY_HORF] = {Anim = "SummonCircle", Frame = 0}, -- Psychic Horf
	[EntityType.ENTITY_POLTY .. " " .. 1] = {Anim = "SummonCircle", Frame = 0}, -- Kineti
	[EntityType.ENTITY_CANDLER] = {Anim = "SummonCircle", Frame = 0}, -- Candler
	[EntityType.ENTITY_CULTIST] = {Anim = "SummonCircle", Frame = 0}, -- Cultist
	[EntityType.ENTITY_BISHOP] = {Anim = "SummonCircle", Frame = 0}, -- Bishop
	[mod.FF.Tombit.ID .. " " .. mod.FF.Tombit.Var] = {Anim = "WalkDown", Frame = 0}, -- Tombit
	[mod.FF.Alfil.ID .. " " .. mod.FF.Alfil.Var] = {Anim = "SummonCircle", Frame = 0}, -- Alfil
	[mod.FF.Zealot.ID .. " " .. mod.FF.Zealot.Var] = {Anim = "Idle", Frame = 0}, -- Zealot
	[mod.FF.WarpCultist.ID .. " " .. mod.FF.WarpCultist.Var] = {Anim = "SummonCircle", Frame = 0}, -- Warp Cultist
	[mod.FF.Level0Fly.ID .. " " .. mod.FF.Level0Fly.Var] = {Anim = "Idle", Frame = 0}, -- Level 0 Fly
}

FiendFolio.TriggersSummonsWhitelist = {
	[EntityType.ENTITY_DOPLE .. " " .. 0] = {EntityType.ENTITY_DOPLE, 0}, -- Dople
	[EntityType.ENTITY_DOPLE .. " " .. 1] = {EntityType.ENTITY_DOPLE, 1}, -- Evil Twin
	[mod.FF.Aper.ID .. " " .. mod.FF.Aper.Var] = {mod.FF.Aper.ID, mod.FF.Aper.Var}, -- Aper
	[mod.FF.Poople.ID .. " " .. mod.FF.Poople.Var] = {mod.FF.Poople.ID, mod.FF.Poople.Var}, -- Poople
}

local SummoningCircleState = {
	IDLE = 0,
	ARMED = 1,
	SUMMONING = 2,
	FADING = 3,
}

function mod:isSummoningBlacklist(entity)
	if mod.SummonsWhitelist[entity.Type] or
	   mod.SummonsWhitelist[entity.Type .. " " .. entity.Variant] or
	   mod.SummonsWhitelist[entity.Type .. " " .. entity.Variant .. " " .. entity.SubType]
	then
		return false
	end

	return mod.SummonsBlacklist[entity.Type] or
	       mod.SummonsBlacklist[entity.Type .. " " .. entity.Variant] or
	       mod.SummonsBlacklist[entity.Type .. " " .. entity.Variant .. " " .. entity.SubType]
end

-- Credit to ffscripts/ferrium/enemies/specturn.lua
function mod:getNearestSummoningTarget(position)
	local targets = {}
	local targetDists = {}
	
	local radius = 99999
	local target = nil
	for _, entity in ipairs(Isaac.GetRoomEntities()) do
		if mod:GetEntityData(entity).FFIsCircleSummon or 
		   mod:isFriend(entity) or 
		   (not mod:isCurseOfTheGateKeySpawner(entity) and (mod:isSummoningBlacklist(entity) or entity.Type >= 999 or (entity.Type < 10 and entity.Type ~= 4 and entity.Type ~= 5)))
		then
			-- do nothing
		else
			if mod:isCurseOfTheGateKeySpawner(entity) then
				if not entity.Child then
					local key = Isaac.Spawn(EntityType.ENTITY_PICKUP, FiendFolio.PICKUP.VARIANT.GATECURSE_KEY, 0, entity.Position, Vector(0,0), entity):ToPickup()
					key.Parent = entity
					entity.Child = key
				end
				entity = entity.Child
			end
			
			local distance = position:Distance(entity.Position)
			if distance < radius then
				radius = distance
				target = entity
			end
		end
	end
	return target
end

local needToMarkForSummoning = false
local summoningMarkerInfo = {}
local callbacksEnabled = false
function mod:summoningMarkerPostInit(npc)
	needToMarkForSummoning = true
	table.insert(summoningMarkerInfo, {Position = npc.Position, SubType = npc.SubType})
	npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	npc:Remove()
	
	if not callbacksEnabled then
		mod:EnableManualCallback(ModCallbacks.MC_PRE_PICKUP_UPDATE, mod.handleSummonsPreUpdate)
		mod:EnableManualCallback(ModCallbacks.MC_PRE_BOMB_UPDATE, mod.handleSummonsPreUpdate)
		mod:EnableManualCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.handleSummonsPreUpdate)
		mod:EnableManualCallback(ModCallbacks.MC_PRE_NPC_RENDER, mod.handleSummonsPreRender)
		mod:EnableManualCallback(ModCallbacks.MC_PRE_PICKUP_RENDER, mod.handleSummonsPreRender)
		mod:EnableManualCallback(ModCallbacks.MC_PRE_BOMB_RENDER, mod.handleSummonsPreRender)
		mod:EnableManualCallback(ModCallbacks.MC_POST_UPDATE, mod.handleSummonsSilencing)
		mod:EnableManualCallback(ModCallbacks.MC_PRE_SFX_PLAY, mod.handleSummonsPortalSfx)
		mod:EnableManualCallback(ModCallbacks.MC_PRE_SFX_PLAY, mod.handleSummonsFlySfx)
		mod:EnableManualCallback(ModCallbacks.MC_PRE_NPC_COLLISION, mod.handleSummonsCollision)
		mod:EnableManualCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.handleSummonsCollision)
		mod:EnableManualCallback(ModCallbacks.MC_PRE_BOMB_COLLISION, mod.handleSummonsCollision)
		mod:EnableManualCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.handleSummonsVisFatty)
		mod:EnableManualCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.handleSummonsMrMaw)
		mod:EnableManualCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.handleSummonsGrudge)
		mod:EnableManualCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.handleSummonsWizoob)
		mod:EnableManualCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.handleSummonsBishop)
	end
	callbacksEnabled = true
end

local function handleSummonAnim(entity)
	local data = mod:GetEntityData(entity)
	local sprite = entity:GetSprite()
	
	data.FFSummoningCircleFadeStateFrame = (data.FFSummoningCircleFadeStateFrame or 0)
	data.FFSummoningCircleArmedStateFrame = (data.FFSummoningCircleArmedStateFrame or 0)
	data.FFSummoningCircleSummonStateFrame = (data.FFSummoningCircleSummonStateFrame or 0)
	
	if (entity.Type == mod.FF.PaleGaper.ID and entity.Variant == mod.FF.PaleGaper.Var) or
	   (entity.Type == mod.FF.PaleHorf.ID and entity.Variant == mod.FF.PaleHorf.Var) or
	   (entity.Type == mod.FF.PaleClotty.ID and entity.Variant == mod.FF.PaleClotty.Var)
	then
		sprite:RemoveOverlay()
		if mod.MagnifierActiveInRoom then
			if not (sprite:IsPlaying("Magnify") or sprite:IsFinished("Magnify")) then
				sprite:Play("Magnify", true)
			end
		else
			if not (sprite:IsPlaying("Shrink") or sprite:IsFinished("Shrink")) then
				sprite:Play("Shrink", true)
			end
		end
		
		if not data.FFCircleSummonRenderInit then
			sprite:SetFrame(999)
			sprite:Stop()
			data.FFCircleSummonRenderInit = true
		end
	elseif entity.Type == mod.FF.Magnifier.ID and entity.Variant == mod.FF.Magnifier.Var then
		if data.FFCircleSummonMagnifierActive then
			if not (sprite:IsPlaying("Activate") or sprite:IsFinished("Activate")) then
				sprite:Play("Activate", true)
			end
		else
			if not (sprite:IsPlaying("Deactivate") or sprite:IsFinished("Deactivate")) then
				sprite:Play("Deactivate", true)
			end
		end
		
		if not data.FFCircleSummonRenderInit then
			sprite:SetFrame(999)
			sprite:Stop()
			data.FFCircleSummonRenderInit = true
		end
	elseif entity.Type == mod.FF.BinaryRed.ID and entity.Variant == mod.FF.BinaryRed.Var then
		sprite:Play("WalkVert", true)
		
		local isBlue = entity.SubType == mod.FF.BinaryBlue.Sub
		local isActive
		if not mod.TotemsExist then
			isActive = true
		else
			if (mod.TotemState and isBlue)
			or (not mod.TotemState and not isBlue) then
				isActive = true
			else
				isActive = false
			end
		end
		
		if isActive and not (sprite:IsOverlayPlaying("HeadOn") or sprite:IsOverlayFinished("HeadOn")) then
			sprite:PlayOverlay("HeadOn", true)
		elseif not isActive and not (sprite:IsOverlayPlaying("HeadOff") or sprite:IsOverlayFinished("HeadOff")) then
			sprite:PlayOverlay("HeadOff", true)
		end
		
		if not data.FFCircleSummonRenderInit then
			sprite:SetOverlayFrame(999)
			sprite:Stop()
			data.FFCircleSummonRenderInit = true
		end
	else
		local anim = sprite:GetDefaultAnimation() or "Appear"
		local frame = 999
		local overlayAnim = nil
		local overlayFrame = nil
		
		if entity.Type == EntityType.ENTITY_PICKUP or entity.Type == EntityType.ENTITY_BOMB then
			anim = "Appear"
		end
		
		local compat = FiendFolio.SummonsCompatibilities[entity.Type .. " " .. entity.Variant .. " " .. entity.SubType] or
					   FiendFolio.SummonsCompatibilities[entity.Type .. " " .. entity.Variant] or
					   FiendFolio.SummonsCompatibilities[entity.Type]
		if compat then
			anim = compat.Anim or anim
			frame = compat.Frame or frame
			overlayAnim = compat.OverlayAnim or overlayAnim
			overlayFrame = compat.OverlayFrame or overlayFrame
			
			entity.SpriteOffset = compat.SpriteOffset or entity.SpriteOffset
			if compat.FlipX ~= nil then sprite.FlipX = compat.FlipX end
		end
		if entity.Type == mod.FF.Morsel.ID and entity.Variant == mod.FF.Morsel.Var then
			if data.head == nil then data.head = math.random(177) - 1 end
			overlayFrame = data.head
		end
		if entity.Type == mod.FF.Falafel.ID and entity.Variant == mod.FF.Falafel.Var then
			if data.head == nil then data.head = math.random(60) - 1 end
			overlayFrame = data.head
		end
		if entity.Type == mod.FF.Slick.ID and entity.Variant == mod.FF.Slick.Var then
			if data.head == nil then data.head = math.random(177) - 1 end
			overlayFrame = data.head
		end
		if entity.Type == EntityType.ENTITY_GRUDGE and entity.Variant == 0 then
			if not data.FFSummonsOverrodeAnm2 then
				data.FFSummonsOriginalAnm2 = sprite:GetFilename()
				sprite:Load("gfx/877.000_grudge_summons.anm2", true)
				data.FFSummonsOverrodeAnm2 = true
			end
		end
		if entity.Type == EntityType.ENTITY_DEATHS_HEAD and entity.Variant == 2 then
			if not data.FFSummonsOverrodeAnm2 then
				data.FFSummonsOriginalAnm2 = sprite:GetFilename()
				sprite:Load("gfx/212.002_cursed death head_summons.anm2", true)
				data.FFSummonsOverrodeAnm2 = true
			end
		end
		if entity.Type == EntityType.ENTITY_PORTAL and entity.Variant == 1 then
			if not data.FFSummonsOverrodeAnm2 then
				data.FFSummonsOriginalAnm2 = sprite:GetFilename()
				sprite:Load("gfx/306.001_lil portal_summons.anm2", true)
				data.FFSummonsOverrodeAnm2 = true
			end
		end
		if entity.Type == EntityType.ENTITY_MAW and entity.Variant == 2 then
			if not data.FFSummonsOverrodeAnm2 then
				data.FFSummonsOriginalAnm2 = sprite:GetFilename()
				sprite:Load("gfx/026.002_psychic maw_summons.anm2", true)
				data.FFSummonsOverrodeAnm2 = true
			end
		end
		if entity.Type == EntityType.ENTITY_PSY_HORF and entity.Variant == 0 then
			if not data.FFSummonsOverrodeAnm2 then
				data.FFSummonsOriginalAnm2 = sprite:GetFilename()
				sprite:Load("gfx/248.000_psychic horf_summons.anm2", true)
				data.FFSummonsOverrodeAnm2 = true
			end
		end
		if entity.Type == EntityType.ENTITY_POLTY and entity.Variant == 1 then
			if not data.FFSummonsOverrodeAnm2 then
				data.FFSummonsOriginalAnm2 = sprite:GetFilename()
				sprite:Load("gfx/816.001_kineti_summons.anm2", true)
				data.FFSummonsOverrodeAnm2 = true
			end
		end
		if entity.Type == EntityType.ENTITY_CANDLER and entity.Variant == 0 then
			if not data.FFSummonsOverrodeAnm2 then
				data.FFSummonsOriginalAnm2 = sprite:GetFilename()
				sprite:Load("gfx/833.000_candler_summons.anm2", true)
				data.FFSummonsOverrodeAnm2 = true
			end
		end
		if entity.Type == EntityType.ENTITY_CULTIST and entity.Variant == 0 then
			if not data.FFSummonsOverrodeAnm2 then
				data.FFSummonsOriginalAnm2 = sprite:GetFilename()
				sprite:Load("gfx/885.000_cultist_summons.anm2", true)
				data.FFSummonsOverrodeAnm2 = true
			end
		end
		if entity.Type == EntityType.ENTITY_BISHOP and entity.Variant == 0 then
			if not data.FFSummonsOverrodeAnm2 then
				data.FFSummonsOriginalAnm2 = sprite:GetFilename()
				sprite:Load("gfx/805.000_bishop_summons.anm2", true)
				data.FFSummonsOverrodeAnm2 = true
			end
		end
		if entity.Type == mod.FF.Gravin.ID and entity.Variant == mod.FF.Gravin.Var then
			if data.visVar == nil then data.visVar = mod:RandomInt(0,5,entity:GetDropRNG()) end
			anim = "Summons"..data.visVar
		end
		if entity.Type == mod.FF.ShrunkenHead.ID and entity.Variant == mod.FF.ShrunkenHead.Var then
			if data.SkinPreset == nil then
				data.SkinPreset = mod:RandomInt(1,4,entity:GetDropRNG())
				mod:ReplaceEnemySpritesheet(entity, "gfx/enemies/shrunkenhead/monster_shrunkenhead0"..data.SkinPreset)
			end
		end
		if entity.Type == EntityType.ENTITY_MRMAW then
			if not data.FFSummonsOverrodeAnm2 then
				if entity.Variant == 0 then 
					data.FFSummonsOriginalAnm2 = sprite:GetFilename()
					sprite:Load("gfx/035.000_mr. maw (bestiary).anm2", true)
					data.FFSummonsOverrodeAnm2 = true
				elseif entity.Variant == 2 then
					data.FFSummonsOriginalAnm2 = sprite:GetFilename()
					sprite:Load("gfx/035.002_mr. red maw (bestiary).anm2", true)
					data.FFSummonsOverrodeAnm2 = true
				end
			end
		end
		if entity.Type == mod.FF.Congression.ID then
			local isWestCongression = FiendFolio.GetBits(entity.SubType, 0, 1) == 1
			if isWestCongression then
				sprite.FlipX = true
			end
		end
		
		if anim then
			sprite:SetFrame(anim, frame)
		end
		if overlayAnim then
			sprite:SetOverlayFrame(overlayAnim, overlayFrame)
		end
		sprite:Stop()
	end
end

local summonsInRoom = {}
local forceNoUpdate = {}
local summonsBeingSilenced = {}
local silencePortals = false
local silenceFlies = false
function mod:handleSummonsPreUpdate(entity, data)
	if needToMarkForSummoning then
		local recheckMagnifierState = false
		for _, markerInfo in ipairs(summoningMarkerInfo) do
			-- Credit to ffscripts/ferrium/enemies/specturn.lua
			local searchNum = (markerInfo.SubType & 7)
			local searchPos = markerInfo.Position
			local searchDist = 45
			if searchNum ~= 0 then
				searchPos = markerInfo.Position + Vector(40,0):Rotated(-90 + 90 * searchNum)
				searchDist = 5
			end
			
			local summoningTarget = mod:getNearestSummoningTarget(searchPos)
			if summoningTarget and summoningTarget.Position:Distance(searchPos) <= searchDist then
				local sdata = mod:GetEntityData(summoningTarget)
				sdata.FFIsCircleSummon = true
				sdata.FFWasCircleSummon = true
				
				sdata.FFSummoningCircleState = SummoningCircleState.IDLE
				sdata.FFSummoningCircleFadeStateFrame = 0
				sdata.FFSummoningCircleArmedStateFrame = 0
				sdata.FFSummoningCircleSummonStateFrame = 0
				sdata.FFSummoningCircleLastTouchedFrame = -1

				local xOffset = (((markerInfo.SubType >> 3) & 63) - 32) * 40
				local yOffset = (((markerInfo.SubType >> 9) & 63) - 32) * 40
				sdata.FFSummoningCircleTargetPos = summoningTarget.Position + Vector(xOffset, yOffset)
				
				if summoningTarget.Type == mod.FF.Magnifier.ID and summoningTarget.Variant == mod.FF.Magnifier.Var then
					recheckMagnifierState = true
					mod.MagnifierActiveInRoom = false
				end
				
				summonsInRoom[summoningTarget.Index .. " " .. summoningTarget.InitSeed] = true
			end
		end
		
		summoningMarkerInfo = {}
		needToMarkForSummoning = false
		
		if recheckMagnifierState then
			local magnifiers = Isaac.FindByType(mod.FF.Magnifier.ID, mod.FF.Magnifier.Var)
			for _, magnifier in ipairs(magnifiers) do
				local data = mod:GetEntityData(magnifier)
				if data.FFIsCircleSummon then
					local mode = FiendFolio.GetBits(magnifier.SubType, 0, 1)
					local delay = FiendFolio.GetBits(magnifier.SubType, 1, 8)
					data.FFCircleSummonMagnifierActive = delay == 0 and mode == 0
				else
					mod:magnifierInit(magnifier, magnifier.SubType)
				end
			end
		end
	end
	
	for _, identifier in ipairs(forceNoUpdate) do
		if identifier == entity.Index .. " " .. entity.InitSeed then
			local npc = entity:ToNPC()
			if npc then
				local champColor = npc:GetChampionColorIdx()
				if champColor == 11 or champColor == 16 or champColor == 20 or champColor == 25 then
					local pulses = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.PULLING_EFFECT)
					for _, pulse in ipairs(pulses) do
						if pulse.Parent and pulse.Parent.Index == npc.Index and pulse.Parent.InitSeed == npc.InitSeed then
							pulse:Remove()
						end
					end
				end
			end
			return true
		end
	end
	
	if summonsInRoom[entity.Index .. " " .. entity.InitSeed] then
		local data = data or mod:GetEntityData(entity)
		if data.FFIsCircleSummon then
			local pickup = entity:ToPickup()
			local npc = entity:ToNPC()
			if npc then
				local champColor = npc:GetChampionColorIdx()
				if champColor ~= -1 then
					local championless = Isaac.Spawn(entity.Type, entity.Variant, entity.SubType, entity.Position, nilvector, nil)
					local cdata = mod:GetEntityData(championless)
					cdata.FFIsCircleSummon = data.FFIsCircleSummon
					cdata.FFWasCircleSummon = data.FFWasCircleSummon
					summonsInRoom[championless.Index .. " " .. championless.InitSeed] = true
					cdata.FFSummoningCircleState = data.FFSummoningCircleState
					cdata.FFSummoningCircleFadeStateFrame = data.FFSummoningCircleFadeStateFrame
					cdata.FFSummoningCircleArmedStateFrame = data.FFSummoningCircleArmedStateFrame
					cdata.FFSummoningCircleSummonStateFrame = data.FFSummoningCircleSummonStateFrame
					cdata.FFSummoningCircleLastTouchedFrame = data.FFSummoningCircleLastTouchedFrame
					cdata.FFSummoningCircleTargetPos = data.FFSummoningCircleTargetPos
					championless:Update()
					
					if champColor == 11 or champColor == 16 or champColor == 20 or champColor == 25 then
						local pulses = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.PULLING_EFFECT)
						for _, pulse in ipairs(pulses) do
							if pulse.Parent and pulse.Parent.Index == npc.Index and pulse.Parent.InitSeed == npc.InitSeed then
								pulse:Remove()
							end
						end
					end
					table.insert(forceNoUpdate, npc.Index .. " " .. npc.InitSeed)
					summonsInRoom[entity.Index .. " " .. entity.InitSeed] = nil
					npc:Remove()
					return true
				end
			end
			if pickup then
				if pickup.Variant == PickupVariant.PICKUP_BOMB then
					local bombVariant = nil
					if pickup.SubType == BombSubType.BOMB_TROLL then
						bombVariant = BombVariant.BOMB_TROLL
					elseif pickup.SubType == BombSubType.BOMB_SUPERTROLL then
						bombVariant = BombVariant.BOMB_SUPERTROLL
					elseif pickup.SubType == BombSubType.BOMB_GOLDENTROLL then
						bombVariant = BombVariant.BOMB_GOLDENTROLL
					end
					
					if bombVariant ~= nil then
						local troll = Isaac.Spawn(EntityType.ENTITY_BOMB, bombVariant, 0, entity.Position, nilvector, nil)
						local tdata = mod:GetEntityData(troll)
						tdata.FFIsCircleSummon = data.FFIsCircleSummon
						tdata.FFWasCircleSummon = data.FFWasCircleSummon
						summonsInRoom[troll.Index .. " " .. troll.InitSeed] = true
						tdata.FFSummoningCircleState = data.FFSummoningCircleState
						tdata.FFSummoningCircleFadeStateFrame = data.FFSummoningCircleFadeStateFrame
						tdata.FFSummoningCircleArmedStateFrame = data.FFSummoningCircleArmedStateFrame
						tdata.FFSummoningCircleSummonStateFrame = data.FFSummoningCircleSummonStateFrame
						tdata.FFSummoningCircleLastTouchedFrame = data.FFSummoningCircleLastTouchedFrame
						tdata.FFSummoningCircleTargetPos = data.FFSummoningCircleTargetPos
						troll:Update()
						
						table.insert(forceNoUpdate, pickup.Index .. " " .. pickup.InitSeed)
						summonsInRoom[entity.Index .. " " .. entity.InitSeed] = nil
						pickup:Remove()
						return true
					end
				end
			end
			
			local sprite = entity:GetSprite()
			
			data.FFSummoningCircleFadeStateFrame = (data.FFSummoningCircleFadeStateFrame or 0)
			data.FFSummoningCircleArmedStateFrame = (data.FFSummoningCircleArmedStateFrame or 0)
			data.FFSummoningCircleSummonStateFrame = (data.FFSummoningCircleSummonStateFrame or 0)
			
			local frame = game:GetFrameCount()
			local summonsCapsule = TearFlagsLib.GenerateCapsuleFromEntity(entity)
			for _,v in pairs(FiendFolio.TriggersSummonsWhitelist) do
				for _, summoner in ipairs(Isaac.FindByType(v[1], v[2], -1, true)) do
					if TearFlagsLib.SimulateCapsuleCapsuleCollision(summonsCapsule, TearFlagsLib.GenerateCapsuleFromEntity(summoner)) then
						data.FFSummoningCircleState = SummoningCircleState.ARMED
						data.FFSummoningCircleLastTouchedFrame = frame - 1
						goto afterSummonsTouchedByEnemyCheck
					end
				end
			end
			::afterSummonsTouchedByEnemyCheck::
			
			if data.FFSummoningCircleState == SummoningCircleState.IDLE then
				if entity.FrameCount > 0 and game:GetRoom():IsClear() then
					data.FFSummoningCircleState = SummoningCircleState.FADING
					data.FFSummoningCircleStateFrame = 0
				end
			end
			if data.FFSummoningCircleState == SummoningCircleState.ARMED then
				if data.FFSummoningCircleLastTouchedFrame < frame - 1 then
					data.FFSummoningCircleState = SummoningCircleState.SUMMONING
				end
			end
			
			if data.FFSummoningCircleState == SummoningCircleState.FADING then
				data.FFSummoningCircleFadeStateFrame = data.FFSummoningCircleFadeStateFrame + 1
			end
			if data.FFSummoningCircleState == SummoningCircleState.ARMED or data.FFSummoningCircleState == SummoningCircleState.SUMMONING then
				data.FFSummoningCircleArmedStateFrame = data.FFSummoningCircleArmedStateFrame + 1
				
				if npc then
					if data.FFSummonsOriginalShutDoors ~= nil then npc.CanShutDoors = data.FFSummonsOriginalShutDoors end
				end
			else
				if npc then
					if data.FFSummonsOriginalShutDoors == nil then data.FFSummonsOriginalShutDoors = npc.CanShutDoors end
					npc.CanShutDoors = false
				end
			end
			if data.FFSummoningCircleState == SummoningCircleState.SUMMONING then
				data.FFSummoningCircleSummonStateFrame = data.FFSummoningCircleSummonStateFrame + 1
			end
			
			if entity.Type == mod.FF.Magnifier.ID and entity.Variant == mod.FF.Magnifier.Var then
				if data.FFCircleSummonMagnifierActive and game:GetRoom():IsClear() or mod.areRoomPressurePlatesPressed() then
					data.FFCircleSummonMagnifierActive = false
				end
			end
			
			if data.FFSummoningCircleSummonStateFrame > SUMMON_TIME then
				sprite:ClearCustomShader()
				
				if data.FFSummonsOriginalEntityCollisionClass ~= nil then    entity.EntityCollisionClass = data.FFSummonsOriginalEntityCollisionClass end
				if data.FFSummonsOriginalGridCollisionClass ~= nil then      entity.GridCollisionClass = data.FFSummonsOriginalGridCollisionClass     end
				if data.FFSummonsOriginalVisibility ~= nil then              entity.Visible = data.FFSummonsOriginalVisibility                        end
				if data.FFSummonsOriginalHadNoStatusEffects == false then    entity:ClearEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)               end
				if data.FFSummonsOriginalHadNoTarget == false then           entity:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET)                       end
				if data.FFSummonsOriginalHadNoKnockback == false then        entity:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)                    end
				if data.FFSummonsOriginalHadNoPhysicsKnockback == false then entity:ClearEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)            end
				if data.FFSummonsOriginalHadHideHpBar == false then          entity:ClearEntityFlags(EntityFlag.FLAG_HIDE_HP_BAR)                     end
				if data.FFSummonsOriginalHadNoQuery == false then            entity:ClearEntityFlags(EntityFlag.FLAG_NO_QUERY)                        end
				if data.FFSummonsOriginalColor ~= nil then                   sprite.Color = data.FFSummonsOriginalColor                               end
				if data.FFSummonsOriginalSpriteOffset ~= nil then            entity.SpriteOffset = data.FFSummonsOriginalSpriteOffset                 end
				if data.FFSummonsOriginalPositionOffset ~= nil then          entity.PositionOffset = data.FFSummonsOriginalPositionOffset             end
				if data.FFSummonsOriginalFlipX ~= nil then                   sprite.FlipX = data.FFSummonsOriginalFlipX                               end
				if data.FFSummonsOriginalRotation ~= nil then                sprite.Rotation = data.FFSummonsOriginalRotation                         end
				if data.FFSummonsOriginalSize ~= nil then                    entity.Size = data.FFSummonsOriginalSize                                 end
				if data.FFSummonsOriginalSizeMulti ~= nil then               entity.SizeMulti = data.FFSummonsOriginalSizeMulti                       end
				
				if npc then
					if data.FFSummonsOriginalShutDoors ~= nil then           npc.CanShutDoors = data.FFSummonsOriginalShutDoors                       end
				end
				
				if data.FFSummonsOriginalAnm2 then
					sprite:Load(data.FFSummonsOriginalAnm2, true)
				end
				
				if data.FFCircleSummonLight and data.FFCircleSummonLight:Exists() then
					data.FFCircleSummonLight.Timeout = 15
				end
				
				data.FFIsCircleSummon = nil
				data.FFWasCircleSummon = true
				summonsInRoom[entity.Index .. " " .. entity.InitSeed] = nil
				
				game:MakeShockwave(entity.Position, 0.03, 0.02, 8)
				sfx:Play(SoundEffect.SOUND_SUMMONSOUND, 0.75, 0, false, 1.0 + math.random() * 0.15 - 0.075)
				
				local appearSmoke = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, nilvector, nil)
				appearSmoke:SetColor(Color(1.035, 0.77, 1.487), 99999, 0, false, false)
				
				if data.FFCircleSummonMagnifierActive then
					mod:zapMagThings(entity)
				end
				if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
					sprite:Continue(false)
				end
				if entity.Type == mod.FF.WarpCultist.ID and entity.Variant == mod.FF.WarpCultist.Var then
					sprite:Play("Idle", true)
				end
				if entity.Type == mod.FF.Zealot.ID and entity.Variant == mod.FF.Zealot.Var and npc then
					npc.I1 = 0
					npc.Velocity = Vector.Zero
					npc.SplatColor = mod.ColorDankBlackReal
					data.Vel = 1
					data.Init = true
					
					sprite:Play("Idle", true)
					npc.StateFrame = mod:RandomInt(10,60)
				end
				if entity.Type == EntityType.ENTITY_GRUDGE and entity.Variant == 0 then
					entity:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_BLOOD_SPLASH | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_HIDE_HP_BAR)
					entity:SetInvincible(true)
				end
				if entity.Type == mod.FF.Grievance.ID and entity.Variant == mod.FF.Grievance.Var then
					entity:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_BLOOD_SPLASH | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_HIDE_HP_BAR)
					entity:SetInvincible(true)
				end
				if entity.Type == mod.FF.Level0Fly.ID and entity.Variant == mod.FF.Level0Fly.Var then
					sprite:Play("Idle", true)
				end
				
				return
			elseif data.FFSummoningCircleFadeStateFrame > FADEOUT_TIME then
				summonsInRoom[entity.Index .. " " .. entity.InitSeed] = nil
				entity:Remove()
			end
			
			if data.FFSummonsOriginalEntityCollisionClass == nil then  data.FFSummonsOriginalEntityCollisionClass = entity.EntityCollisionClass                                  end
			if data.FFSummonsOriginalGridCollisionClass == nil then    data.FFSummonsOriginalGridCollisionClass = entity.GridCollisionClass                                      end
			if data.FFSummonsOriginalVisibility == nil then            data.FFSummonsOriginalVisibility = entity.Visible                                                         end
			if data.FFSummonsOriginalHadNoStatusEffects == nil then    data.FFSummonsOriginalHadNoStatusEffects = entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)       end
			if data.FFSummonsOriginalHadNoTarget == nil then           data.FFSummonsOriginalHadNoTarget = entity:HasEntityFlags(EntityFlag.FLAG_NO_TARGET)                      end
			if data.FFSummonsOriginalHadNoKnockback == nil then        data.FFSummonsOriginalHadNoKnockback = entity:HasEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)                end
			if data.FFSummonsOriginalHadNoPhysicsKnockback == nil then data.FFSummonsOriginalHadNoPhysicsKnockback = entity:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) end
			if data.FFSummonsOriginalHadHideHpBar == nil then          data.FFSummonsOriginalHadHideHpBar = entity:HasEntityFlags(EntityFlag.FLAG_HIDE_HP_BAR)                   end
			if data.FFSummonsOriginalHadNoQuery == nil then            data.FFSummonsOriginalHadNoQuery = entity:HasEntityFlags(EntityFlag.FLAG_NO_QUERY)                        end
			if data.FFSummonsOriginalColor == nil then                 data.FFSummonsOriginalColor = Color.Lerp(Color(0,0,0), sprite.Color, 1)                                   end
			if data.FFSummonsOriginalSpriteOffset == nil then          data.FFSummonsOriginalSpriteOffset = Vector(entity.SpriteOffset.X, entity.SpriteOffset.Y)                 end
			if data.FFSummonsOriginalPositionOffset == nil then        data.FFSummonsOriginalPositionOffset = Vector(entity.PositionOffset.X, entity.PositionOffset.Y)           end
			if data.FFSummonsOriginalFlipX == nil then                 data.FFSummonsOriginalFlipX = sprite.FlipX                                                                end
			if data.FFSummonsOriginalRotation == nil then              data.FFSummonsOriginalRotation = sprite.Rotation                                                          end
			if data.FFSummonsOriginalSize == nil then                  data.FFSummonsOriginalSize = entity.Size                                                                  end
			if data.FFSummonsOriginalSizeMulti == nil then             data.FFSummonsOriginalSizeMulti = entity.SizeMulti                                                        end
			
			entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
			entity.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
			entity.Visible = true
			entity:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_KNOCKBACK | 
								  EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_HIDE_HP_BAR)
			entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			
			data.FFSummoningCircleTargetPos = data.FFSummoningCircleTargetPos or entity.Position
			entity.Velocity = nilvector
			
			local compat = FiendFolio.SummonsCompatibilities[entity.Type .. " " .. entity.Variant .. " " .. entity.SubType] or
						   FiendFolio.SummonsCompatibilities[entity.Type .. " " .. entity.Variant] or
						   FiendFolio.SummonsCompatibilities[entity.Type]
			if compat then
				entity.PositionOffset = compat.PositionOffset or entity.PositionOffset
				entity.Size = compat.Size or entity.Size
			end
			
			handleSummonAnim(entity)
			
			if data.FFCircleSummonLight == nil or not data.FFCircleSummonLight:Exists() then
				data.FFCircleSummonLight = EntityEffect.CreateLight(entity.Position + Vector(0, -10), 1.0, -1, nil, Color(0.808, 0.537, 0.898))
			end
			
			if entity.Type == EntityType.ENTITY_BISHOP then
				entity:AddEntityFlags(EntityFlag.FLAG_NO_QUERY)
			end
			
			if entity.Type == EntityType.ENTITY_PORTAL and entity.Variant == 1 then
				entity:AddEntityFlags(EntityFlag.FLAG_FREEZE)
				entity:SetFreezeCountdown(2)
				table.insert(summonsBeingSilenced, entity)
				
				silencePortals = true
			end
			
			if entity.Type == EntityType.ENTITY_POOTER or entity.Type == EntityType.ENTITY_ATTACKFLY or entity.Type == EntityType.ENTITY_BOOMFLY then
				entity:AddEntityFlags(EntityFlag.FLAG_FREEZE)
				entity:SetFreezeCountdown(2)
				table.insert(summonsBeingSilenced, entity)
				
				silenceFlies = true
			end
			
			if entity.Type == EntityType.ENTITY_WALL_CREEP then
				if not data.FFCircleSummonInit then
					local newPos, attachedWall = mod:onlookerNearestWall(entity.Position, 0, 5)
					data.FFSummoningCircleTargetPos = newPos

					if attachedWall == "down" then
						sprite.Rotation = 180
					elseif attachedWall == "left" then
						sprite.Rotation = 270
						entity.PositionOffset = Vector(0,-25)
					elseif attachedWall == "right" then
						sprite.Rotation = 90
						entity.PositionOffset = Vector(0,-25)
					end
					
					data.FFCircleSummonInit = true
				end
				entity.SizeMulti = Vector(1.8, 1)
			end
			
			if entity.Type == mod.FF.Congression.ID then
				if not data.FFCircleSummonInit then
					local positionOffset = FiendFolio.GetBits(entity.SubType, 3, 5) - 10
					entity.Position = Vector(entity.Position.X + (positionOffset * 40), entity.Position.Y)
					data.FFSummoningCircleTargetPos = entity.Position
					data.ignoreOffset = true
					
					data.FFCircleSummonInit = true
				end
			end
			
			if entity.Type == mod.FF.Gutso.ID and entity.Variant == mod.FF.Gutso.Var then
				if not data.FFCircleSummonInit then
					entity.Position = (data.FFSummoningCircleTargetPos or entity.Position) + Vector(0, -20)
					data.FFSummoningCircleTargetPos = entity.Position
					data.FFCircleSummonInit = true
				end
			end
			entity.Position = data.FFSummoningCircleTargetPos
			
			if entity.FrameCount > 0 and
			   ((entity.Type == mod.FF.PaleGaper.ID and entity.Variant == mod.FF.PaleGaper.Var) or
				(entity.Type == mod.FF.PaleHorf.ID and entity.Variant == mod.FF.PaleHorf.Var) or
				(entity.Type == mod.FF.PaleClotty.ID and entity.Variant == mod.FF.PaleClotty.Var))
			then
				if mod.MagnifierActiveInRoom then
					if data.FFCircleSummonUpdateInit and data.FFCircleSummonMag == true then
						data.FFCircleSummonMagFrame = (data.FFCircleSummonMagFrame or 0) + 1
						if data.FFCircleSummonMagFrame == 1 then
							npc:PlaySound(SoundEffect.SOUND_THUMBSUP, 1, 0, false, 0.9)
						elseif data.FFCircleSummonMagFrame == 5 then
							npc:PlaySound(SoundEffect.SOUND_THUMBSUP, 1, 0, false, 1)
							mod.changeMagScale(entity, true)
						elseif data.FFCircleSummonMagFrame == 9 then
							npc:PlaySound(SoundEffect.SOUND_THUMBSUP, 1, 0, false, 1.1)
						end
					end
					
					if data.FFCircleSummonMag ~= true then
						data.FFCircleSummonMag = true
						data.FFCircleSummonMagFrame = 0
					end
				else
					if data.FFCircleSummonUpdateInit and data.FFCircleSummonMag == false then
						data.FFCircleSummonMagFrame = (data.FFCircleSummonMagFrame or 0) + 1
						if data.FFCircleSummonMagFrame == 1 then
							npc:PlaySound(SoundEffect.SOUND_THUMBS_DOWN, 1, 0, false, 0.9)
						elseif data.FFCircleSummonMagFrame == 5 then
							npc:PlaySound(SoundEffect.SOUND_THUMBS_DOWN, 1, 0, false, 0.8)
							mod.changeMagScale(entity, false)
						elseif data.FFCircleSummonMagFrame == 9 then
							npc:PlaySound(SoundEffect.SOUND_THUMBS_DOWN, 1, 0, false, 0.7)
						end
					end
					
					if data.FFCircleSummonMag ~= false then
						data.FFCircleSummonMag = false
						data.FFCircleSummonMagFrame = 0
					end
				end
				
				if not data.FFCircleSummonUpdateInit then
					mod.changeMagScale(entity, data.FFCircleSummonMag)
					data.FFCircleSummonMagFrame = 999
					data.FFCircleSummonUpdateInit = true
				end
			end
			
			return true
		end
	end
end
mod:AddPriorityManualCallback(ModCallbacks.MC_PRE_PICKUP_UPDATE, CallbackPriority.IMPORTANT, mod.handleSummonsPreUpdate)
mod:AddPriorityManualCallback(ModCallbacks.MC_PRE_BOMB_UPDATE, CallbackPriority.IMPORTANT, mod.handleSummonsPreUpdate)
mod:AddPriorityManualCallback(ModCallbacks.MC_PRE_NPC_UPDATE, CallbackPriority.IMPORTANT, mod.handleSummonsPreUpdate)

function mod:handleSummonsPreRender(entity, _, data)
	if summonsInRoom[entity.Index .. " " .. entity.InitSeed] then
		local data = data or mod:GetEntityData(entity)
		if data.FFIsCircleSummon then
			handleSummonAnim(entity)
			
			local sprite = entity:GetSprite()
			sprite:SetCustomShader("shaders/fiendfolio/coloroffset_summoning")
			
			local summonAmount = math.min((data.FFSummoningCircleSummonStateFrame / SUMMON_TIME) ^ (1 + 3 * (data.FFSummoningCircleSummonStateFrame / SUMMON_TIME)), 0.99)
			local pulseAmount = (math.cos(data.FFSummoningCircleArmedStateFrame / PULSE_TIME) * -1.0 + 1.0) / 2.0
			local distortTimer = ((game:GetFrameCount() + data.FFSummoningCircleSummonStateFrame * summonAmount * 10) % (DISTORT_TIME * 2)) / DISTORT_TIME
			local fadeAmount = math.min(data.FFSummoningCircleFadeStateFrame / FADEOUT_TIME, 0.99)
			local pointScale = Isaac.GetScreenPointScale()
			local distortOrigin = Isaac.WorldToScreen(Vector(0,0)) * pointScale
			
			-- look all we get is the colorize to work with atm so we only get 4 variables IM SORRY
			local foldedValues
			if summonAmount > 0 then
				foldedValues = summonAmount + pointScale
			elseif fadeAmount > 0 then
				foldedValues = (fadeAmount + pointScale) * -1
			else
				foldedValues = pointScale
			end
			
			sprite.Color:SetColorize(distortOrigin.X, distortOrigin.Y, foldedValues, distortTimer)
			sprite.Color:SetOffset(30.0/255.0 * pulseAmount, 20.0/255.0 * pulseAmount, 40.0/255.0 * pulseAmount)
		end
	end
end
mod:AddManualCallback(ModCallbacks.MC_PRE_NPC_RENDER, mod.handleSummonsPreRender)
mod:AddManualCallback(ModCallbacks.MC_PRE_PICKUP_RENDER, mod.handleSummonsPreRender)
mod:AddManualCallback(ModCallbacks.MC_PRE_BOMB_RENDER, mod.handleSummonsPreRender)

function mod:handleSummonsSilencing()
	forceNoUpdate = {}
	
	for _, entity in ipairs(summonsBeingSilenced) do
		if entity and entity:Exists() and mod:GetEntityData(entity).FFIsCircleSummon then
			entity:ClearEntityFlags(EntityFlag.FLAG_FREEZE)
			entity:SetFreezeCountdown(0)
		end
	end
	summonsBeingSilenced = {}
end
mod:AddManualCallback(ModCallbacks.MC_POST_UPDATE, mod.handleSummonsSilencing)

function mod:handleSummonsPortalSfx()
	if silencePortals then
		local portals = Isaac.FindByType(EntityType.ENTITY_PORTAL)
		local hasCircleSummon = false
		for _, portal in ipairs(portals) do
			if portal and portal:Exists() then
				if mod:GetEntityData(portal).FFIsCircleSummon then
					hasCircleSummon = true
				else
					return
				end
			end
		end
		if hasCircleSummon then
			return false
		end
	end
end
mod:AddManualCallback(ModCallbacks.MC_PRE_SFX_PLAY, mod.handleSummonsPortalSfx, SoundEffect.SOUND_PORTAL_LOOP)

local function mergeTables(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q)
	local tabs = {a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q} -- I can't get ... notation to work for some reason
	local mergedTab = {}
	for _,tab in pairs(tabs) do
		for _,v in ipairs(tab or {}) do
			table.insert(mergedTab, v)
		end
	end
	return mergedTab
end

function mod:handleSummonsFlySfx()
	if silenceFlies then
		local flies = mergeTables(Isaac.FindByType(EntityType.ENTITY_BOOMFLY),
		                          Isaac.FindByType(EntityType.ENTITY_SUCKER),
		                          Isaac.FindByType(EntityType.ENTITY_POOTER),
		                          Isaac.FindByType(EntityType.ENTITY_FLY),
		                          Isaac.FindByType(EntityType.ENTITY_ATTACKFLY),
		                          Isaac.FindByType(EntityType.ENTITY_MOTER),
		                          Isaac.FindByType(EntityType.ENTITY_RING_OF_FLIES),
		                          Isaac.FindByType(EntityType.ENTITY_FLY_L2),
		                          Isaac.FindByType(EntityType.ENTITY_FULL_FLY),
		                          Isaac.FindByType(EntityType.ENTITY_DART_FLY),
		                          Isaac.FindByType(EntityType.ENTITY_ARMYFLY),
		                          Isaac.FindByType(EntityType.ENTITY_SWARM),
		                          Isaac.FindByType(EntityType.ENTITY_WILLO),
		                          Isaac.FindByType(EntityType.ENTITY_WILLO_L2),
		                          Isaac.FindByType(EntityType.ENTITY_FLY_BOMB),
		                          Isaac.FindByType(EntityType.ENTITY_BEAST, 11),
		                          Isaac.FindByType(EntityType.ENTITY_BEAST, 21))
		
		local hasCircleSummon = false
		for _, fly in ipairs(flies) do
			if fly and fly:Exists() then
				if mod:GetEntityData(fly).FFIsCircleSummon then
					hasCircleSummon = true
				else
					return
				end
			end
		end
		
		if hasCircleSummon then
			return false
		end
	end
end
mod:AddManualCallback(ModCallbacks.MC_PRE_SFX_PLAY, mod.handleSummonsFlySfx, SoundEffect.SOUND_INSECT_SWARM_LOOP)

function mod:handleSummonsCollision(entity, collider)
	local data = mod:GetEntityData(entity)
	if data.FFIsCircleSummon and entity.FrameCount > 0 then
		if collider:ToPlayer() or FiendFolio.TriggersSummonsWhitelist[collider.Type .. " " .. collider.Variant] then 
			if data.FFSummoningCircleState == SummoningCircleState.IDLE then
				data.FFSummoningCircleState = SummoningCircleState.ARMED
			end
			data.FFSummoningCircleLastTouchedFrame = game:GetFrameCount()
		end
		return true
	end
end
mod:AddPriorityManualCallback(ModCallbacks.MC_PRE_NPC_COLLISION, CallbackPriority.IMPORTANT, mod.handleSummonsCollision)
mod:AddPriorityManualCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.IMPORTANT, mod.handleSummonsCollision)
mod:AddPriorityManualCallback(ModCallbacks.MC_PRE_BOMB_COLLISION, CallbackPriority.IMPORTANT, mod.handleSummonsCollision)

function mod:handleSummoningCircleDamage(entity, data)
	if data.FFIsCircleSummon then
		return false
	end
end

function mod:handleSummoningCirclePreRoomExit(entity)
	for _, entity in ipairs(Isaac.GetRoomEntities()) do
		local data = mod:GetEntityData(entity)
		if data.FFIsCircleSummon and data.FFSummoningCircleState == SummoningCircleState.FADING then
			entity:Remove()
		end
	end
	
	summonsBeingSilenced = {}
	summonsInRoom = {}
	silencePortals = false
	silenceFlies = false
	
	if callbacksEnabled then
		mod:DisableManualCallback(ModCallbacks.MC_PRE_PICKUP_UPDATE, mod.handleSummonsPreUpdate)
		mod:DisableManualCallback(ModCallbacks.MC_PRE_BOMB_UPDATE, mod.handleSummonsPreUpdate)
		mod:DisableManualCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.handleSummonsPreUpdate)
		mod:DisableManualCallback(ModCallbacks.MC_PRE_NPC_RENDER, mod.handleSummonsPreRender)
		mod:DisableManualCallback(ModCallbacks.MC_PRE_PICKUP_RENDER, mod.handleSummonsPreRender)
		mod:DisableManualCallback(ModCallbacks.MC_PRE_BOMB_RENDER, mod.handleSummonsPreRender)
		mod:DisableManualCallback(ModCallbacks.MC_POST_UPDATE, mod.handleSummonsSilencing)
		mod:DisableManualCallback(ModCallbacks.MC_PRE_SFX_PLAY, mod.handleSummonsPortalSfx)
		mod:DisableManualCallback(ModCallbacks.MC_PRE_SFX_PLAY, mod.handleSummonsFlySfx)
		mod:DisableManualCallback(ModCallbacks.MC_PRE_NPC_COLLISION, mod.handleSummonsCollision)
		mod:DisableManualCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.handleSummonsCollision)
		mod:DisableManualCallback(ModCallbacks.MC_PRE_BOMB_COLLISION, mod.handleSummonsCollision)
		mod:DisableManualCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.handleSummonsVisFatty)
		mod:DisableManualCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.handleSummonsMrMaw)
		mod:DisableManualCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.handleSummonsGrudge)
		mod:DisableManualCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.handleSummonsWizoob)
		mod:DisableManualCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.handleSummonsBishop)
	end
	callbacksEnabled = false
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_ROOM_EXIT, CallbackPriority.IMPORTANT, mod.handleSummoningCirclePreRoomExit)

function mod:handleSummonsVisFatty(npc)
	if npc.Variant == 1 and npc.Parent and mod:GetEntityData(npc.Parent).FFWasCircleSummon then
		npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	end
end
mod:AddManualCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.handleSummonsVisFatty, EntityType.ENTITY_VIS_FATTY)

function mod:handleSummonsMrMaw(npc)
	if (npc.Variant == 1 or npc.Variant == 3) and npc.Child and mod:GetEntityData(npc.Child).FFWasCircleSummon then
		npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		
		local sprite = npc:GetSprite()
		sprite:Play("Down", true)
	end
end
mod:AddManualCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.handleSummonsMrMaw, EntityType.ENTITY_MRMAW)

function mod:handleSummonsGrudge(npc)
	local data = mod:GetEntityData(npc)
	if data.FFWasCircleSummon and not data.FFCircleSummonInit then
		npc.State = 4
		npc.StateFrame = 0
		npc.TargetPosition = npc.Position
		data.FFCircleSummonInit = true
	end
end
mod:AddManualCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.handleSummonsGrudge, EntityType.ENTITY_GRUDGE)

function mod:handleSummonsWizoob(npc)
	local data = mod:GetEntityData(npc)
	if data.FFWasCircleSummon and not data.FFCircleSummonInit then
		npc.State = 9
		npc.StateFrame = 0
		npc.I1 = 3
		npc.TargetPosition = npc.Position
		npc:GetSprite():Play("VanishDown", true)
		data.FFCircleSummonInit = true
	end
end
mod:AddManualCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.handleSummonsWizoob, EntityType.ENTITY_WIZOOB)

function mod:handleSummonsBishop(npc)
	local data = mod:GetEntityData(npc)
	if data.FFWasCircleSummon and not data.FFCircleSummonInit then
		npc.State = 3
		npc.StateFrame = 0
		npc.I1 = 0
		npc.TargetPosition = npc.Position
		npc:GetSprite():Play("Idle", true)
		data.FFCircleSummonInit = true
	end
end
mod:AddManualCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.handleSummonsBishop, EntityType.ENTITY_BISHOP)