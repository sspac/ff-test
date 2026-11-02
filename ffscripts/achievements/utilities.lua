local mod = FiendFolio

-- Utility functions, to be called on any Fiend Folio or Vanilla item ID to check unlock status

local function IsLocked(conf, xml)
	local achievement = conf.AchievementID

	if achievement <= 0 and xml and xml.achievement then
		local xmlAchievement = tonumber(xml.achievement) or Isaac.GetAchievementIdByName(xml.achievement)
		if xmlAchievement and xmlAchievement > 0 then
			achievement = xmlAchievement
		end
	end

	if achievement > 0 then
		return not Isaac.GetPersistentGameData():Unlocked(achievement)
	end
	return false
end

function mod.IsCollectibleLocked(id)
	local configItem = Isaac.GetItemConfig():GetCollectible(id)
	local xml = XMLData.GetEntryById(XMLNode.ITEM, id)
	return IsLocked(configItem, xml)
end
function mod.IsCollectibleUnlocked(id)
	return not mod.IsCollectibleLocked(id)
end
mod.IsItemUnlocked = mod.IsCollectibleUnlocked

function mod.IsTrinketLocked(id)
	local configItem = Isaac.GetItemConfig():GetTrinket(id)
	local xml = XMLData.GetEntryById(XMLNode.TRINKET, id)
	return IsLocked(configItem, xml)
end
function mod.IsTrinketUnlocked(id)
	return not mod.IsTrinketLocked(id)
end

function mod.IsCardLocked(id)
	local configItem = Isaac.GetItemConfig():GetCard(id)
	local xml = XMLData.GetEntryById(XMLNode.CARD, id)
	return IsLocked(configItem, xml)
end
function mod.IsCardUnlocked(id)
	return not mod.IsCardLocked(id)
end
