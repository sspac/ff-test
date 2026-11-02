-- Segmented Enemy Handling --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

function mod:isSegmented(entity)
	return FiendFolio.SegmentedEnemies[entity.Type] or
		   FiendFolio.SegmentedEnemies[entity.Type .. " " .. entity.Variant] or
		   FiendFolio.SegmentedEnemies[entity.Type .. " " .. entity.Variant .. " " .. entity.SubType]
end

function mod:isMainSegment(entity)
	if entity.Type == mod.FF.Kingpin.ID and entity.Variant == mod.FF.Kingpin.Var then
		return entity.Parent == nil
	elseif entity.Type == mod.FF.Tapeworm.ID and entity.Variant == mod.FF.Tapeworm.Var then
		return entity.Parent == nil
	elseif entity.Type == mod.FF.MrBones.ID and entity.Variant == mod.FF.MrBones.Var then
		return entity:ToNPC().State ~= 10
	elseif entity.Type == mod.FF.Prick.ID and entity.Variant == mod.FF.Prick.Var then
		return entity.Parent == nil
	elseif entity.Type == mod.FF.Warble.ID and entity.Variant == mod.FF.Warble.Var then
		return entity.SubType ~= mod.FF.WarbleTail.Sub
	elseif entity.Type == mod.FF.CorruptedLarry.ID and entity.Variant == mod.FF.CorruptedLarry.Var then
		return mod:GetEntityData(entity).corruptedHead
	elseif entity.Type == mod.FF.Trailblazer.ID and entity.Variant == mod.FF.Trailblazer.Var then
		return not mod:GetEntityData(entity).IsSegment
	else
		return FiendFolio.MainSegment[entity.Type] or
			   FiendFolio.MainSegment[entity.Type .. " " .. entity.Variant] or
			   FiendFolio.MainSegment[entity.Type .. " " .. entity.Variant .. " " .. entity.SubType]
	end
end

function mod:isReducedSyncSegment(entity)
	return FiendFolio.ReducedSyncSegments[entity.Type] or
		   FiendFolio.ReducedSyncSegments[entity.Type .. " " .. entity.Variant] or
		   FiendFolio.ReducedSyncSegments[entity.Type .. " " .. entity.Variant .. " " .. entity.SubType]
end

function mod:getSegments(entity)
	local segmentFunction = FiendFolio.GetSegmentsFunctions[entity.Type .. " " .. entity.Variant .. " " .. entity.SubType] or
							FiendFolio.GetSegmentsFunctions[entity.Type .. " " .. entity.Variant] or
							FiendFolio.GetSegmentsFunctions[entity.Type]

	if segmentFunction == nil then
		return {entity}
	else
		return segmentFunction(entity)
	end
end

function mod:isInSegmentsOf(target, entity)
	local segments = mod:getSegments(entity)
	for _, segment in ipairs(segments) do
		if target.InitSeed == segment.InitSeed and target.Index == segment.Index then
			return true
		end
	end
	return false
end

function mod:isBasegameSegmented(entity)
	return mod.BasegameSegmentedEnemies[entity.Type] or
		   mod.BasegameSegmentedEnemies[entity.Type .. " " .. entity.Variant] or
		   mod.BasegameSegmentedEnemies[entity.Type .. " " .. entity.Variant .. " " .. entity.SubType]
end

function mod:isBasegameMainSegment(entity)
	if entity.Type == 19 then -- Larry Jr., The Hollow, Tuff Twins, The Shell
		return entity.Parent == nil
	elseif entity.Type == 28 then -- Chub, C.H.A.D., The Carrion Queen
		return entity.Parent == nil
	elseif entity.Type == 62 then -- Pin, Scolex, The Frail, Wormwood
		return entity.Parent == nil
	elseif entity.Type == 89 then -- Buttlicker
		return entity.Parent == nil
	elseif entity.Type == 239 then -- Grub
		return entity.Parent == nil
	elseif entity.Type == 918 then -- Turdlet
		return entity.Parent == nil
	else
		return mod.BasegameMainSegment[entity.Type] or
			   mod.BasegameMainSegment[entity.Type .. " " .. entity.Variant] or
			   mod.BasegameMainSegment[entity.Type .. " " .. entity.Variant .. " " .. entity.SubType]
	end
end

function mod:isBasegameReducedSyncSegment(entity)
	return mod.BasegameReducedSyncSegments[entity.Type] or
		   mod.BasegameReducedSyncSegments[entity.Type .. " " .. entity.Variant] or
		   mod.BasegameReducedSyncSegments[entity.Type .. " " .. entity.Variant .. " " .. entity.SubType]
end

function mod:getBasegameSegments(entity)
	local segmentFunction = FiendFolio.GetBasegameSegmentsFunctions[entity.Type .. " " .. entity.Variant .. " " .. entity.SubType] or
							FiendFolio.GetBasegameSegmentsFunctions[entity.Type .. " " .. entity.Variant] or
							FiendFolio.GetBasegameSegmentsFunctions[entity.Type]

	if segmentFunction == nil then
		return {entity}
	else
		return segmentFunction(entity)
	end
end

function mod:isInBasegameSegmentsOf(target, entity)
	local segments = mod:getBasegameSegments(entity)
	for _, segment in ipairs(segments) do
		if target.InitSeed == segment.InitSeed and target.Index == segment.Index then
			return true
		end
	end
	return false
end

function mod:basegameSegmentHasMortalDamage(entity)
	if not mod:isBasegameSegmented(entity) then
		return false
	end

	local segments = mod:getBasegameSegments(entity)
	for _, segment in ipairs(segments) do
		if segment:HasMortalDamage() then
			return true
		end
	end
	return false
end

function mod:agnosticIsSegmented(entity)
	return mod:isSegmented(entity) or mod:isBasegameSegmented(entity)
end

function mod:agnosticGetSegments(entity)
	if mod:isSegmented(entity) then
		return mod:getSegments(entity)
	elseif mod:isBasegameSegmented(entity) then
		return mod:getBasegameSegments(entity)
	end
end