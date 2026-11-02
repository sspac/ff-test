---@class ItemDescription
---@field ID integer
---@field Description ItemDescriptionObject | ItemDescriptionObject[] Either one or a list of multiple (for other languages).
---@field EncyclopediaPools table? A list of Encyclopedia pools (for collectibles only)

---@class ItemDescriptionReplacement
---@field TargetNumbers table<number, table<number, number>>[]? If replacing numbers, put {numberToReplace, replacementNumber} into this table. For Golden trinkets, use TargetStrings instead.
---@field TargetMultipliers table<number, number>[]? If multiplying numbers, put each number into this table. Only used for Golden trinkets, and handled automatically.
---@field TargetAdditives ItemDescriptionAdditive? For Golden trinkets only, and for adding numbers instead of multiplying.
---@field TargetStrings string[]? For Golden trinkets only, and all other fields won't apply if set. First entry is string to replace, subsequent ones are the replacement string for each mult. See Bloody Rock description.
---@field Description string[]? A description to append.
---@field FullReplace table<number, string[]>? For Golden trinkets, replaces the ENTIRE description with the list of strings at the multiplier.
---@field PartialReplace table<string, string>? Replace first occurance of a string (key) with another string (value).
---@field GoldOnly boolean? If for a Golden trinket description, setting this to `true` tells EID that this is not affected by Mom's Box.
---@field OverclockOnly boolean? For the rare circumstance when an effect only activates with Overclock.

---@class ItemDescriptionAdditive
---@field AdditiveValues number[] A table where the index is the multiplier and the value is the number that is added to the targets
---@field TargetNumbers number[] List of numbers to add to

---@class ItemDescriptionIcon
---@field Shortcut string | integer The shortcut string ("ffBruise" would be used like {{ffBruise}}). Make it an integer for cards (turns it into {{Card(integer)}})
---@field Sprite Sprite
---@field Animation string
---@field Frame integer Frame in "eid_ff_inline_icons.anm2" that has its icon.
---@field Width integer
---@field Height integer
---@field LeftOffset integer
---@field TopOffset integer

---@class ItemDescriptionStatus
---@field Icon ItemDescriptionIcon
---@field Descriptions ItemDescriptionObject | ItemDescriptionObject[] Only `Description` and `LanguageCode` are used for this.

---@class ItemDescriptionObject
---@field Description string[]
---@field StatusEffects ItemDescriptionStatus[]? A list of status effects that should be described along with this object.
---@field Name string? Default is the English name defined in xml.
---@field LanguageCode string? Default is English.
---@field Conditional fun(descObj)? Should return the description object.
---@field Virtues string[]? No need to put if it's an inner ring wisp, outer ring, etc.
---@field VirtuesSingleRoom boolean? Set to true if this wisp only lasts for a single room
---@field Abyss string[]? Locusts.
---@field AbyssSpecial string[]? Some abyss synergies are special and should replace the auto-generated Abyss text. 
---@field Belial string[]? Birthright Book of Belial (these don't replace numbers for vanilla items)
---@field Golden ItemDescriptionReplacement? Golden trinkets.
---@field BFFs ItemDescriptionReplacement | false? Familiar BFFs. Set to `false` to denote that there's no effect.
---@field HiveMind ItemDescriptionReplacement | true | false? If set to non-boolean, then ignores BFFs description, as in vanilla these two are the exact same. Set to `true` to copy BFFs description. Set to `false` to denote there's no effect.
---@field CarBattery ItemDescriptionReplacement | false? Car battery active item. Set to `false` to denote that there's no effect.
---@field NoOverclockEffect boolean? If Overclock has no effect for this Golem rock, set this to `true`. Otherwise, leave `nil` or `false`.

local mod = FiendFolio

-- Legacy (for Retribution)
_G.__eidTrinketDescriptions = __eidTrinketDescriptions or {}

local overclockOnly = {}

-- Taken right out of EID (credit to wofsauge probably)
local function swagColors(colors, maxAnimTime)
	maxAnimTime = maxAnimTime or 80
	local animTime = Game():GetFrameCount() % maxAnimTime
	local colorFractions = (maxAnimTime - 1) / #colors
	local subAnm = math.floor(animTime / (colorFractions + 1)) + 1
	local primaryColorIndex = subAnm % (#colors + 1)
	if primaryColorIndex == 0 then
		primaryColorIndex = 1
	end
	local secondaryColorIndex = (subAnm + 1) % (#colors + 1)
	if secondaryColorIndex == 0 then
		secondaryColorIndex = 1
	end
	return EID:interpolateColors(
		colors[primaryColorIndex],
		colors[secondaryColorIndex],
		(animTime % (colorFractions + 1)) / colorFractions
	)
end

function FiendFolio:SplitString(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

FiendFolio.EIDBlacklistedPrefix = {
	"{{Collectible706}}",
	"{{Collectible584}}",
	"{{Collectible59}}",
	"{{Collectible247}}",
	"{{Collectible248}}",
	"{{Collectible356}}",
}

---@param replacement ItemDescriptionReplacement
local function replaceText(obj, replacement, color)
	
    if replacement.TargetNumbers then
        for _, v in ipairs(replacement.TargetNumbers) do
            local target = v[1]
            local replaceWith = v[2]

			local split = mod:SplitString(obj.Description, "#")

			for i, str in ipairs(split) do
				local proceed = true
				for _, prefix in ipairs(FiendFolio.EIDBlacklistedPrefix) do
					if str:sub(1, prefix:len()) == prefix then
						proceed = false
						break
					end
				end

				if proceed then
					split[i] = string.gsub(str, "%d*%.?%d+", function(s)
						if s == tostring(target) then
							return color .. string.format("%.4g", replaceWith) .. "{{CR}}"
						end
					end)
				end
			end

            obj.Description = table.concat(split, "#")
        end
    end

    if replacement.TargetMultipliers then
        for _, v in ipairs(replacement.TargetMultipliers) do
            local target = v[1]
            local mult = v[2]

			local split = mod:SplitString(obj.Description, "#")

			for i, str in ipairs(split) do
				local proceed = true
				for _, prefix in ipairs(FiendFolio.EIDBlacklistedPrefix) do
					if str:sub(1, prefix:len()) == prefix then
						proceed = false
						break
					end
				end

				if proceed then
					split[i] = string.gsub(str, "%d*%.?%d+", function(s)
						if s == tostring(target) then
							if target == 17 then
								if mult == 2 then target = 16.5
								elseif mult == 3 then target = (1/6)*100 end -- convert 17% to 33% or 50%
							elseif v == 33 and (mult == 1.5 or mult == 3) then target = (1/3)*100 end -- convert 33% to 50% or 100%
							return color .. string.format("%.4g",target*mult) .. "{{CR}}"
						end
					end)
				end
			end

            obj.Description = table.concat(split, "#")
        end
    end

	if replacement.PartialReplace then
		for phrase, str in pairs(replacement.PartialReplace) do
			local replaceString = color .. str .. "{{CR}}"
			local startIndex, endIndex = obj.Description:find(phrase)
			if startIndex and endIndex then
				local newStr = obj.Description:sub(1, startIndex - 1) .. replaceString .. obj.Description:sub(endIndex + 1) 
				obj.Description = newStr
			end
		end
	end
end

---@type table<string, ItemDescription[]>
FiendFolio.ExternalDescriptions = {
	Collectibles = {},
	Trinkets = {},
	Rocks = {},
	Cards = {},
	Pills = {},
}

FiendFolio.DescriptionIcons = include("ffscripts.constants.item_descriptions.icons")
FiendFolio.DescriptionIconsCards = include("ffscripts.constants.item_descriptions.icons_cards")
FiendFolio.DescriptionStatuses = include("ffscripts.constants.item_descriptions.statuses")

local function setupIcons(tab)
	for _, icon in pairs(tab) do
		if type(icon.Shortcut) == "number" then
			icon.Shortcut = "Card" .. icon.Shortcut
		end

		-- Explained in icons.lua
		setmetatable(icon, {
			__concat = function (t1, t2)
				if type(t1) == "table" and t1.Shortcut then
					if type(t2) == "table" and t2.Shortcut then
						return "{{" .. t1.Shortcut .. "}} {{" .. t2.Shortcut .. "}}"
					else
						return "{{" .. t1.Shortcut .. "}} " .. t2
					end
				elseif type(t2) == "table" and t2.Shortcut then
					if type(t1) == "table" and t1.Shortcut then
						return "{{" .. t1.Shortcut .. "}} {{" .. t2.Shortcut .. "}}"
					else
						return t1 .. "{{" ..  t2.Shortcut .. "}}"
					end
				end
			end
		})

		EID:addIcon(
			icon.Shortcut,
			icon.Animation,
			icon.Frame,
			icon.Width,
			icon.Height,
			icon.LeftOffset,
			icon.TopOffset,
			icon.Sprite
		)
	end

	-- Separate thing for pills because these are just being pulled from the EntityConfig atm
	-- Slightly lazy since ideally they shouldn't have the shadows
	for _, pillColor in pairs(FiendFolio.PICKUP.PILLCOLOR) do
		local conf = EntityConfig.GetEntity(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, pillColor)
		if conf then
			local sprite = Sprite(conf:GetAnm2Path())
			sprite:GetLayer(0):SetSize(Vector(0.5, 0.5))
			EID:addIcon("Pill"..pillColor , "HUD", -1, 9, 9, 4.5, 7, sprite)
		end
	end
end

-- Handle Overclock copying Golden trinket descriptions, but with some new formatting.
local function overclockModifier(descObj)
	local trinketID = descObj.ObjSubType % TrinketType.TRINKET_GOLDEN_FLAG
	local data = overclockOnly[trinketID] or EID:getDescriptionEntry("goldenTrinketData", trinketID) or EID.GoldenTrinketData[trinketID]
	local overclockIcon = "{{Collectible" .. mod.ITEM.COLLECTIBLE.OVERCLOCK .. "}}"

	if not data then
		return
	end


	local isGolden = descObj.ObjSubType & TrinketType.TRINKET_GOLDEN_FLAG == TrinketType.TRINKET_GOLDEN_FLAG and not data.overclockOnly
	local hasBox = EID.collectiblesOwned[439] and not data.overclockOnly
	local multiplier = 1
	local textChoice = 1
	if isGolden and hasBox then
		multiplier = 3
		textChoice = 3
	elseif hasBox or isGolden then
		multiplier = 2
	end

	if hasBox then
		textChoice = 2
	end

	if data then
		if type(data) == "number" then data = {t={data}} end
		if data.goldenOnly and not isGolden then return descObj end

		--custom multipliers (either manually defined, or just changing the max multiplier
		if data.mults then
			if isGolden and hasBox then multiplier = data.mults[2]
			else multiplier = data.mults[1] end
		elseif data.mult and ((isGolden and hasBox) or data.mult < 2) then multiplier = data.mult end

		local overclockMult = data.mults and (data.mults[textChoice * 2] or data.mults[textChoice]) or multiplier * 2

		--custom additions table (manually defined)
		local addition = 0
		local overclockAdd = 0
		if data.additions then
			if hasBox and not isGolden then
				addition = data.additions[textChoice-1] or 0
				overclockAdd = data.additions[textChoice+1] or data.additions[#data.additions]
			elseif isGolden then
				addition = data.additions[textChoice]
				overclockAdd = data.additions[textChoice+2] or data.additions[#data.additions]
			else
				overclockAdd = data.additions[1]
			end
		end

		-- Adding Overclock multiplier next to Golden/original
		if data.t then
			local count = 0
			descObj.Description = string.gsub(descObj.Description, "%d*%.?%d+", function(s)
				count = 0
				for _,v in ipairs(data.t) do
					-- Keep in mind that this is running *after* EID's golden trinket stuff.
					-- So account for that!
					local target = v * multiplier + addition

					-- Remove ".0" at the end, if it exists.
					if math.floor(target) == target then
						target = math.floor(target)
					end

					--"%d*%.?%d+" will grab every number group (1, 10, 0.5), this will allow us to not replace the "1" in "10" erroneously
					if s == tostring(target) and count == 0 then
						count = count + 1
						if target == 17 then
							if multiplier == 2 then target = 16.5
							elseif multiplier == 3 then target = (1/6)*100 end -- convert 17% to 33% or 50%
						elseif target == 33 and (multiplier == 1.5 or multiplier == 3) then target = (1/3)*100 end -- convert 33% to 50% or 100%
						
						-- Get the number for the original number * (multiplier*2) + (additive*2) (Overclock)
						return s .. " " .. overclockIcon .. "{{ColorOverclock}} (" .. string.format("%.4g", v * overclockMult + overclockAdd) .. "){{CR}}"
					end
				end
			end)
		end
		--replacing a phrase, such as "half a heart"
		if data.findReplace then
			local textTable = data.textTable or EID:getDescriptionEntry("goldenTrinketEffects", trinketID)
			if textTable then
				descObj.Description = string.gsub(descObj.Description, textTable[multiplier], function (s)
					return s .. " " .. overclockIcon .. "{{ColorOverclock}} (" .. (textTable[overclockMult] or textTable[#textTable]) .. "){{ColorText}}"
				end, 1)
			end
		end
		--append some new text to the description
		-- In this case, we'll find the gold text that was appended and replace the bullet point with the Overclock icon.
		if data.append and multiplier > 1 then
			local textTable = data.textTable or EID:getDescriptionEntry("goldenTrinketEffects", trinketID)
			if textTable then
				local split = mod:SplitString(descObj.Description, "#")
				for i, str in ipairs(split) do
					for _, text in ipairs(textTable) do
						if str == "{{ColorGold}}" .. text then
							split[i] = "#" .. overclockIcon .. " {{ColorGold}}" .. text
						end
					end
				end
				descObj.Description = table.concat(split, "#")
			end

		-- Append the description like normal, but with the Overclock color and icon
		elseif data.append then
			local textTable = data.textTable or EID:getDescriptionEntry("goldenTrinketEffects", trinketID)
			if textTable then
				textChoice = math.min(textChoice, #textTable) -- some items have only 1 append description
				if textTable[textChoice] ~= "" then
					local split = mod:SplitString(textTable[textChoice], "#")
					for i, str in ipairs(split) do
						if i == 1 then
							descObj.Description = descObj.Description .. "#" .. overclockIcon .. " {{ColorOverclock}}" .. str
						else
							descObj.Description = descObj.Description .. "#{{ColorOverclock}}" .. str
						end
					end
				end
			end
		end
	end
end

local function concatDescription(description)
	local combined = table.concat(description.Description, "#")

	-- Add status effect descriptions
	if description.StatusEffects then
		for _, status in ipairs(description.StatusEffects) do
			combined =
				combined
				.. "#"
				.. status.Icon
				.. " "
				.. table.concat(status.Descriptions.Description, "#" .. status.Icon .. " ")
		end
	end

	return combined
end

-- Lots of eid icons by Cuerzor
if EID then
	-- Character Info
	EID:addCharacterInfo(FiendFolio.PLAYER.FIEND, "Can't have Red Hearts#{{BlackHeart}} Health ups grant Black Hearts#{{ffImmoralHeart}} Spawns minions when taking damage in an uncleared room#The amount of minions corresponds to how much health he has#{{Collectible" .. FiendFolio.ITEM.COLLECTIBLE.PYROMANCY .. "}} Generates fireballs when dealing 50 damage to enemies#{{ffHalfImmoralHeart}} 50% chance for enemies to drop Half Immoral Hearts when killed by fireballs", "Fiend")
	EID:addCharacterInfo(FiendFolio.PLAYER.BIEND, "Can't have Red Hearts#{{BlackHeart}} Can only have Black Hearts#Can only have 6 heart containers#{{Collectible" .. FiendFolio.ITEM.COLLECTIBLE.MALICE .. "}} Using Malice splits Tainted Fiend into many smaller copies of himself#The amount of copies corresponds to how much health he has#The smaller copies have lower damage, lower invincibility frames, and die from a single hit of damage#If all copies die, Tainted Fiend dies", "Tainted Fiend")
	EID:addCharacterInfo(FiendFolio.PLAYER.GOLEM, "{{Collectible139}} Can hold two trinkets at once#{{ffRock}} All trinkets are replaced with unique Rocks#{{ffCrush}} Can access Golem's Subway, which contains Subway Traders and allows fast travel#Rock trinkets are guaranteed to spawn upon clearing the Boss Room or finding the Secret Room", "Golem")
	EID:addCharacterInfo(FiendFolio.PLAYER.BOLEM, "Can't have Red Hearts#{{SoulHeart}} Health ups grant Soul Hearts#{{Collectible139}} Can hold two trinkets at once#{{ffRock}} Rocks replace items in {{TreasureRoom}} Treasure Rooms and {{BossRoom}} Boss Rooms#Taking damage has a chance to drop or break rocks and items Golem is holding", "Tainted Golem")
	EID:addCharacterInfo(FiendFolio.PLAYER.FRIEND, "Can only have 6 heart containers#{{Heart}} Hearts are ammo and correspond to how many times you can shoot#{{SoulHeart}} Different heart types make Friend shoot different bullets that have special effects", "Friend")
	EID:addCharacterInfo(FiendFolio.PLAYER.BRIEND, "Can only have 6 heart containers#{{Heart}} Friend has two guns that correspond to her health that she can shoot#The two guns have different inventories#When near an item, Friend holds up the gun that gets the item#Gunslinger enemies appear in rooms that shoot Friend", "Tainted Friend")
	EID:addCharacterInfo(FiendFolio.PLAYER.INABA, "Enemies drop Anxiety Residue orbs that Inaba can collect#Inaba can level up from collecting orbs#Taking enough damage decreases her level#Inaba gains more eye satellites with each level#Dealing and taking damage builds up a migraine#When her migraine bar is full, she gains a short stat boost", "Inaba")
	EID:addCharacterInfo(FiendFolio.PLAYER.BINABA, "Cannot shoot tears#Her eye satellite shoots for her#Enemies drop Anxiety Residue orbs that Inaba can collect#Inaba can level up from collecting orbs#Taking enough damage decreases her level#Holding drop ({{ButtonRT}}) will cause her eye to stay in place#Letting go of drop releases a slashing attack that empowers her pocket active", "Tainted Inaba")
	EID:addCharacterInfo(FiendFolio.PLAYER.SLIPPY, "Constantly moves#Shoots 3 tear at once#{{Collectible" .. FiendFolio.ITEM.COLLECTIBLE.FROG_HEAD .. "}} Using Golden Frog Head prevents her from moving", "Slippy")
	EID:addCharacterInfo(FiendFolio.PLAYER.CHINA, "{{BrokenHeart}} Taking damage and touching any solid obstacle, such as walls or rocks, grants +1 Broken Heart#{{Warning}} If China reaches more than 12 Broken Hearts, she will die#{{Collectible" .. FiendFolio.ITEM.COLLECTIBLE.HORSE_PASTE .. "}} Completing a room has a 15% chance to spawn a Horse Push-Pop that can heal China#{{DevilRoom}} One devil deal per room can be taken for free", "China")
	EID:addCharacterInfo(FiendFolio.PLAYER.CRAIG, "{{Collectible68}} Short range technology lasers instead of tears", "Craig")
	EID:addCharacterInfo(FiendFolio.PLAYER.CLASSIC_FIEND, "#Can't have Red Hearts#{{BlackHeart}} Can only have Black Hearts#Spawns minions when taking damage in an uncleared room#The amount of minions corresponds to how much health he has#{{Collectible" .. FiendFolio.ITEM.COLLECTIBLE.DEAL_OF_THE_DEMONS .. "}} Homing tears", "Classic Fiend")
	EID:addCharacterInfo(FiendFolio.PLAYER.IMAGE, "#Forcibly given many items that give you sensory overload#The more floors Image travels, the more items Image gets inundated with#{{Wrning}} {{Warning}} Help! They've trapped me in The Binding of Isaac: Repentance+ {{Collectible" .. FiendFolio.ITEM.COLLECTIBLE.REPENTANCE_PLUS .. "}} mod Fiend Folio: Reloaded and are forcing me to describe characters! Please help! Help!!! It hurts so much... Please...", "Image")
	EID:addCharacterInfo(FiendFolio.PLAYER.SKELETAL_FIEND, "Can't have Red Hearts#{{EmptyBoneHeart}} Can only have empty Bone Hearts#{{EmptyBoneHeart}} Health ups grant empty Bone Hearts#Generates firebones that give bone orbitals when killing enemies#Spawns fires behind him while moving", "The Skeletal Fiend")
	EID:addCharacterInfo(FiendFolio.PLAYER.FEND, "{{Collectible" .. FiendFolio.ITEM.COLLECTIBLE.FENDS_MOP .. "}} You have a melee attack that can be charged for a spin attack + projectile shot#Melee attack can deflect enemy projectiles", "Fend")
	EID:addCharacterInfo(FiendFolio.PLAYER.FROND, "{{Poison}} Poison tears#Sweats tears that leave poison green creep when in an active room", "Frond")
	EID:addCharacterInfo(FiendFolio.PLAYER.FIENT, "{{Confusion}} Concussive tears#Weed", "Fient")
	EID:addCharacterInfo(FiendFolio.PLAYER.MI, "In an active room, tears that fall onto the ground leave a Fiend Minion on impact", "Mi")
	EID:addCharacterInfo(FiendFolio.PLAYER.FREEZERJR, "When Freezer Jr's chargebar is filled, she can crash the entirety of a room", "Freezer Jr.")
	EID:addCharacterInfo(FiendFolio.PLAYER.PEAT, "It seems today, that all you see#Is violence in movies and sex on TV#But where are those good old-fashioned values#On which we used to rely?#Lucky there's a family guy#Lucky there's a man who positively can do#All the things that make us#Laugh and cry#He's a family guy", "Peat")

	-- Birthright
	EID:addBirthright(FiendFolio.PLAYER.FIEND, "Gives Fiend's fireballs increased homing#Fireballs have a chance to spawn Fiend Minions that disappear on room clear")
	EID:addBirthright(FiendFolio.PLAYER.BIEND, "Increases the chance of enemies dropping Half Black Hearts when killed by Malice#When split, Tainted Fiend's minions are randomly assigned hats upon spawning, granting its wearer a differing amount of stats")
	EID:addBirthright(FiendFolio.PLAYER.GOLEM, "↑ +2 Luck#Tinted rocks now drop rock trinkets and Soul Hearts")
	EID:addBirthright(FiendFolio.PLAYER.BOLEM, "{{Collectible" .. FiendFolio.ITEM.COLLECTIBLE.OVERCLOCK .. "}} Overclock now summons Golem's Club#Throw Golem's Club to deal damage to enemies and break rocks#Rocks broken with Golem's Club have a small chance to drop Rock Trinkets")
	EID:addBirthright(FiendFolio.PLAYER.FRIEND, "{{Collectible" .. tostring(FiendFolio.ITEM.COLLECTIBLE.HOT_SHOT) .. "}} Hot Shot's fireball can be shot three times before disappearing#The fireball also lasts longer in motion, and bounces off walls#Immunity to Hot Shot explosions")
	EID:addBirthright(FiendFolio.PLAYER.BRIEND, "65% chance for Gunslinger enemies to drop their gun as a collectible pickup#Gunslinger guns have limited ammo and fire alongside Tainted Friend#Disappears after running out of ammo")
	EID:addBirthright(FiendFolio.PLAYER.INABA, "Inaba's Migrane bar fills up quicker, drains slower, and can fill up when in Migrane Mode#{{Collectible313}} When Inaba is in Migrane Mode, she obtains a Holy Mantle shield#The shield negates the first hit of damage taken once per room")
	EID:addBirthright(FiendFolio.PLAYER.BINABA, "Holding the drop button ({{ButtonRT}}) for long enough fills up another chargebar#If the drop button is released, a shadow satellite is placed#The shadow satellite does not move, only shoots when Inaba shoots, and aims towards enemies that are nearby")
	EID:addBirthright(FiendFolio.PLAYER.SLIPPY, "{{Collectible" .. FiendFolio.ITEM.COLLECTIBLE.FROG_HEAD .. "}} Slippy now spawns lingering poison gas clouds when using Golden Frog Head")
	EID:addBirthright(FiendFolio.PLAYER.CHINA, "{{Collectible" .. tostring(FiendFolio.ITEM.COLLECTIBLE.HORSE_PASTE) .. "}} China gains the ability to use Horse Paste#{{BrokenHeart}} On use, Horse Paste heals one Broken Heart")
	EID:addBirthright(FiendFolio.PLAYER.CRAIG, "{{Collectible" .. tostring(FiendFolio.ITEM.COLLECTIBLE.CRAIGS_BATTERY) .. "}} More bulb lanterns appear in rooms with enemies")
	EID:addBirthright(FiendFolio.PLAYER.CLASSIC_FIEND, "An extra heart minion appears when Classic Fiend takes damage")
	EID:addBirthright(FiendFolio.PLAYER.IMAGE, "Enhances the sensory overload greatly")
	EID:addBirthright(FiendFolio.PLAYER.SKELETAL_FIEND, "{{Damage}} Taunts do The Skeletal Fiend's damage to enemies")
	EID:addBirthright(FiendFolio.PLAYER.FEND, "↑ Fend's libido increases")
	EID:addBirthright(FiendFolio.PLAYER.FROND, "In an active room, Frond spews more tears that leave creep")
	EID:addBirthright(FiendFolio.PLAYER.FIENT, "Drug baggies drop when killing enemies#Drug baggies grant:#↑ +2 Tears#↑ +0.8 Speed#{{Collectible582}} A wavy cap screen distortion")
	EID:addBirthright(FiendFolio.PLAYER.MI, "Mi's tears spawn friends!!!!!!!!")
	EID:addBirthright(FiendFolio.PLAYER.FREEZERJR, "{{Warning}} Freezer Jr's crash ability can affect objects a layer above")
	EID:addBirthright(FiendFolio.PLAYER.PEAT, "Peat's horse spawns#Peat can ride the horse, charging into battle, doing 100 damage to enemies")


	-- Add icons
	setupIcons(mod.DescriptionIcons)
	setupIcons(mod.DescriptionIconsCards)

	EID:setModIndicatorIcon("FiendFolioTitleIcon")

	mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, eff)
		if eff.SubType == 880 or eff.SubType == 881 then
			local descTable = {
				["Name"] = "[Dice Room effect] (12)",
				["Description"] = "For the whole floor, on room clear rerolls all grids in the room into other random grids",
			}
			mod:GetEntityData(eff)["EID_Description"] = descTable
		end
	end, 76)

	EID:addColor("ColorOverclock", KColor(159 / 255, 212 / 255, 222 / 255, 1))
	EID:addColor("ColorBlasphemous", function ()
		return swagColors({
			KColor(1, 0, 0, 1),
			KColor(140 / 255, 0, 0, 1)
		})
	end)

	EID:addDescriptionModifier("FF Blasphemous Trinket", function (descObj)
		if descObj.Entity and descObj.Entity.Type == EntityType.ENTITY_PICKUP and descObj.Entity.Variant == PickupVariant.PICKUP_TRINKET then
			if mod:IsPickupTrinketBlasphemous(descObj.Entity) then
				descObj.Description = descObj.Description .. "#{{Damage}} {{ColorBlasphemous}}+1 Damage"
			end
		end

		return descObj
	end)

	EID:addDescriptionModifier("FF Perfectly Generic Object", function (descObj)
		local anyoneHas = false
		for _, player in ipairs(PlayerManager.GetPlayers()) do
			for _, id in ipairs({
				FiendFolio.ITEM.COLLECTIBLE.PERFECTLY_GENERIC_OBJECT_1,
				FiendFolio.ITEM.COLLECTIBLE.PERFECTLY_GENERIC_OBJECT_2,
				FiendFolio.ITEM.COLLECTIBLE.PERFECTLY_GENERIC_OBJECT_3,
				FiendFolio.ITEM.COLLECTIBLE.PERFECTLY_GENERIC_OBJECT_4,
				FiendFolio.ITEM.COLLECTIBLE.PERFECTLY_GENERIC_OBJECT_5,
				FiendFolio.ITEM.COLLECTIBLE.PERFECTLY_GENERIC_OBJECT_6,
				FiendFolio.ITEM.COLLECTIBLE.PERFECTLY_GENERIC_OBJECT_8,
				FiendFolio.ITEM.COLLECTIBLE.PERFECTLY_GENERIC_OBJECT_12
			}) do
				if player:HasCollectible(id) then
					anyoneHas = true
					break
				end
			end

			if anyoneHas then
				break
			end
		end
		if anyoneHas and descObj.Entity and descObj.Entity.Type == EntityType.ENTITY_PICKUP and descObj.Entity.Variant == PickupVariant.PICKUP_TAROTCARD then
			local config = Isaac.GetItemConfig():GetCard(descObj.Entity.SubType)

			if config and config.CardType == ItemConfig.CARDTYPE_SPECIAL_OBJECT then
				local collectible = "#{{Collectible" .. mod.ITEM.COLLECTIBLE.PERFECTLY_GENERIC_OBJECT_1 .. "}} "
				local prefix = "{{ColorYellow}}Perfectly Generic Object{{CR}} charge: "
				local charge = "{{"..FiendFolio.PocketObjectMimicCharges[descObj.Entity.SubType].."}}{{Battery}}"
				descObj.Description = descObj.Description ..  collectible .. prefix .. charge
			end
		end

		return descObj
	end)

	-- Register our custom transformations
	EID:createTransformation("ffDad", "Who's Your Daddy?")
	for _, dadItem in ipairs(FiendFolio.DadItems) do
		EID:assignTransformation("collectible", dadItem, "ffDad")
	end

	EID:createTransformation("ffSteven", "Time Fcuk'd!")
	for _, stevenItem in ipairs(FiendFolio.TimeFcukItems) do
		EID:assignTransformation("collectible", stevenItem, "ffSteven")
	end

	EID:createTransformation("ffKalu", "#MyDogKalu!")
	for _, kaluItem in ipairs(FiendFolio.KaluItems) do
		EID:assignTransformation("collectible", kaluItem, "ffKalu")
	end

	FiendFolio.LoadScripts({
		"ffscripts.constants.item_descriptions.collectibles",
		"ffscripts.constants.item_descriptions.trinkets",
		"ffscripts.constants.item_descriptions.trinkets_rocks",
		"ffscripts.constants.item_descriptions.trinkets_rocks_vanilla",
		"ffscripts.constants.item_descriptions.cards_pills",
		"ffscripts.constants.item_descriptions.encyclopedia_player_descriptions",
	})

	-- Add descriptions now that they're all loaded
	for descType, descs in pairs(FiendFolio.ExternalDescriptions) do
		for _, data in ipairs(descs) do
			-- TODO: Remove this once all descriptions are converted to new system
			if not data.Description then
				goto continue
			end

			local descriptionTable = #data.Description > 0 and data.Description or {data.Description}
			for _, description in ipairs(descriptionTable) do
				local combined = concatDescription(description)

				if descType == "Collectibles" then
					EID:addCollectible(
						data.ID,
						combined,
						description.Name,
						description.LanguageCode
					)
				elseif descType == "Trinkets" or descType == "Rocks" then
					EID:addTrinket(
						data.ID,
						combined,
						description.Name,
						description.LanguageCode
					)

					if description.Golden then
						local goldenCombined
						if description.Golden.Description then
							goldenCombined = table.concat(description.Golden.Description, "#")
						end

						local additions
						if description.Golden.TargetAdditives then
							additions = description.Golden.TargetAdditives.TargetNumbers
						end

						local goldenData = {
							t = additions or description.Golden.TargetMultipliers,
							append = goldenCombined and not description.Golden.TargetStrings,
							goldenOnly = description.Golden.GoldOnly,
							overclockOnly = description.Golden.OverclockOnly,
							findReplace = description.Golden.TargetStrings and not description.Golden.FullReplace,
							fullReplace = description.Golden.FullReplace and true,
							additions = description.Golden.TargetAdditives and description.Golden.TargetAdditives.AdditiveValues or nil,
							mults = description.Golden.TargetAdditives and {1, 1, 1} or nil,
						}
						if not description.Golden.OverclockOnly then
							EID:addGoldenTrinketTable(data.ID, goldenData)
						else
							overclockOnly[data.ID] = goldenData
						end

						if description.Golden.OverclockOnly then
							if description.Golden.FullReplace then
								overclockOnly[data.ID].textTable = description.Golden.FullReplace
							elseif description.Golden.TargetStrings then
								overclockOnly[data.ID].textTable = description.Golden.TargetStrings
							elseif goldenCombined then
								overclockOnly[data.ID].textTable = {goldenCombined}
							end
						else
							if description.Golden.FullReplace then
								EID.descriptions[description.LanguageCode or "en_us"].goldenTrinketEffects[data.ID] = description.Golden.FullReplace
							elseif description.Golden.TargetStrings then
								EID.descriptions[description.LanguageCode or "en_us"].goldenTrinketEffects[data.ID] = description.Golden.TargetStrings
							elseif goldenCombined then
								EID.descriptions[description.LanguageCode or "en_us"].goldenTrinketEffects[data.ID] = {goldenCombined}
							end
						end
					end
				elseif descType == "Cards" then
					EID:addCard(
						data.ID,
						combined,
						description.Name,
						description.LanguageCode
					)
				elseif descType == "Pills" then
					EID:addPill(
						data.ID,
						combined,
						description.Name,
						description.LanguageCode
					)
				end

				-- Make EID show Virtues wisp stats
				if descType == "Collectibles" then
					local xmlData = XMLData.GetEntryById(XMLNode.WISP, data.ID)
					if xmlData then
						-- The table as EID formats it
						local combinedData = {
							xmlData.hp and tonumber(xmlData.hp) or 2,
							xmlData.layer and tonumber(xmlData.layer) or 1,
							xmlData.damage and tonumber(xmlData.damage) or 3,
							xmlData.stageDamage and tonumber(xmlData.stageDamage) or 0.1, -- Unused???
							xmlData.damageMultiplier2 and tonumber(xmlData.damageMultiplier2) or 1,
							xmlData.shotSpeed and tonumber(xmlData.shotSpeed) or 1,
							xmlData.fireDelay and tonumber(xmlData.fireDelay) or 30,
							xmlData.procChance and tonumber(xmlData.procChance) or 1,
							xmlData.canShoot ~= "false",
							xmlData.count and tonumber(xmlData.count) or 1,
						}

						for _, property in ipairs({"tearFlags", "tearFlags2"}) do
							local final = {}
							local tearFlagData = xmlData[property]
							if tearFlagData then
								local split = mod:SplitString(tearFlagData, " ")
								for _, str in ipairs(split) do
									table.insert(final, tonumber(str))
								end	
							end

							table.insert(combinedData, final)
						end

						EID.XMLWisps[data.ID] = combinedData
					end
				end

				-- Make EID say this wisp only lasts for a single room
				if descType == "Collectibles" and description.VirtuesSingleRoom then
					EID.WispData.SingleRoom[data.ID] = true
				end

				-- Add special description modifiers.
				-- We do this manually so that we can automate some stuff, such as wisp rings.
				local descriptionId = "FiendFolio-" .. tostring(descType) .. tostring(data.ID)
				EID:removeDescriptionModifier(descriptionId)

				EID:addDescriptionModifier(descriptionId, function (descObj)

					if descType == "Collectibles" then
						return descObj.ObjType == EntityType.ENTITY_PICKUP
						and descObj.ObjVariant == PickupVariant.PICKUP_COLLECTIBLE
						and descObj.ObjSubType == data.ID
					elseif descType == "Trinkets" or descType == "Rocks" or descType == "RocksVanilla" then
						return descObj.ObjType == EntityType.ENTITY_PICKUP
						and descObj.ObjVariant == PickupVariant.PICKUP_TRINKET
						and mod:GetRealTrinketId(descObj.ObjSubType) == data.ID
					elseif descType == "Cards" then
						return descObj.ObjType == EntityType.ENTITY_PICKUP
						and descObj.ObjVariant == PickupVariant.PICKUP_TAROTCARD
						and descObj.ObjSubType == data.ID
					elseif descType == "Pills" then
						return descObj.ObjType == EntityType.ENTITY_PICKUP
						and descObj.ObjVariant == PickupVariant.PICKUP_PILL
						and descObj.ObjSubType == data.ID
					end

					return false
				end, function (descObj)
					if description.PlayerSpecificDescription then
						local overwriteDesc = description.PlayerSpecificDescription

						for i, playerType in pairs(overwriteDesc.Players) do
							if PlayerManager.AnyoneIsPlayerType(playerType) then
								descObj.Description = table.concat(overwriteDesc.Description, "#")
								break
							end
						end
					end

					if description.Conditional then
						description.Conditional(descObj)
					end

					local append = ""
					if description.Virtues and PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
						EID.descriptions[description.LanguageCode or "en_us"].bookOfVirtuesWisps[data.ID] = table.concat(description.Virtues, "#")
					end

					if description.Abyss and PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_ABYSS) then
						append = append .. "#{{Collectible" .. data.ID .. "}} {{ColorRed}}" .. table.concat(description.Abyss, "#{{ColorRed}}")
					end

					if description.AbyssSpecial and PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_ABYSS) then
						EID.descriptions[description.LanguageCode or "en_us"].abyssSynergies[data.ID] = table.concat(description.AbyssSpecial, "#")
					end

					if description.Belial and PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
						append = append .. "#{{Collectible59}} " .. table.concat(description.Belial, "#")
					end

					local hasHivemind = PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_HIVE_MIND)
					local hasBffs = PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_BFFS)
					if description.BFFs ~= nil 
					and (hasBffs or (description.HiveMind == true and hasHivemind)) then
						if type(description.BFFs) == "table" then
							if description.BFFs.Description then
								append = append .. "#{{Collectible247}} " .. table.concat(description.BFFs.Description, "#")
							end

							replaceText(descObj, description.BFFs, "{{BlinkPink}}")
						elseif description.BFFs == false then
							EID.BFFSNoSynergy[data.ID] = true
						end

						if hasHivemind then
							EID.HiveMindFamiliars[data.ID] = true
						end
					end

					if description.HiveMind ~= nil and hasHivemind and not hasBffs then
						if type(description.HiveMind) == "table" then
							if description.HiveMind.Description then
								append = append .. "#{{Collectible248}} " .. table.concat(description.HiveMind.Description, "#")
							end

							replaceText(descObj, description.HiveMind, "{{BlinkBlue}}")

							EID.BFFSIgnore[data.ID] = true
						elseif description.HiveMind == false then
							EID.BFFSNoSynergy[data.ID] = true
						end
					end

					if description.CarBattery ~= nil and PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
						if type(description.CarBattery) == "table" then
							if description.CarBattery.Description then
								append = append .. "#{{Collectible356}} " .. table.concat(description.CarBattery.Description, "#")
							end

							replaceText(descObj, description.CarBattery, "{{BlinkYellowGreen}}")
						else
							EID.CarBatteryNoSynergy[data.ID] = true
						end
					end

					if (description.Golden or description.NoOverclockEffect) and PlayerManager.AnyoneHasCollectible(mod.ITEM.COLLECTIBLE.OVERCLOCK) then
						-- We can pull from EID's "no effect" car battery description to avoid having to localize our own.
						if description.NoOverclockEffect then
							append =
								append ..
								"#{{Collectible" ..
								mod.ITEM.COLLECTIBLE.OVERCLOCK ..
								"}} {{ColorOverclock}}" ..
								EID.descriptions[description.LanguageCode or "en_us"].carBattery["No Effect"]
						else
							overclockModifier(descObj)
						end
					end

					if descType == "RocksVanilla"
					and (PlayerManager.AnyoneIsPlayerType(mod.PLAYER.GOLEM) or PlayerManager.AnyoneIsPlayerType(mod.PLAYER.BOLEM)) then
						local prepend = description.RockType == "Geode"  and "{{ffGeode}} {{ColorTransform}}Rock Trinket (Geode)"
									 or description.RockType == "Fossil" and "{{ffFossil}} {{ColorTransform}}Rock Trinket (Fossil)"
									 or "{{ffRock}} {{ColorTransform}}Rock Trinket (Rock)"

						descObj.Description = table.concat({
							prepend,
							descObj.Description,
							table.concat(description.Description, "#"),
						}, "#")
					end

					-- Finally, append description
					if append ~= "" then
						descObj.Description = descObj.Description .. append
					end

					return descObj
				end)
			end

			::continue::
		end
	end
end

-- BUIRTHCAYKE!!!!
mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, function()
	if BirthcakeRebaked then
		local api = BirthcakeRebaked.API
		api:AddEIDDescription(FiendFolio.PLAYER.FIEND, "Taking damage spawns an extra hollow minion familiar")
		api:AddEIDDescription(FiendFolio.PLAYER.BIEND, "Splitting with Malice spawns an extra Malice familiar#The malice familiar does 50% of Tainted Fiend's damage and does not reduce health when he takes damage")
		api:AddEIDDescription(FiendFolio.PLAYER.GOLEM, "Boosts trinket power of other trinkets held in Golem's inventory")
		api:AddEIDDescription(FiendFolio.PLAYER.BOLEM, "If Tainted Golem gets hit, Birthcake drops first before anything else")
		api:AddEIDDescription(FiendFolio.PLAYER.SLIPPY, "Decreases charge time of Golden Frog Head")
		api:AddEIDDescription(FiendFolio.PLAYER.CHINA, "Heals 1 Broken Heart at the start of a floor")
		api:AddEIDDescription(FiendFolio.PLAYER.FRIEND, "Friend gets an extra shot of ammo")
		api:AddEIDDescription(FiendFolio.PLAYER.BRIEND, "The next item Tainted Friend picks up goes to both guns#{{Warning}} The Birthcake then gets consumed")
		api:AddEIDDescription(FiendFolio.PLAYER.CRAIG, "Standing near enemies charges Craig's Battery")
		api:AddEIDDescription(FiendFolio.PLAYER.SKELETAL_FIEND, "Homing tears#Skeletal Fiend's tears can destroy rocks and open doors#Skeletal Fiend's tears bounce off each other and disappear when they stop moving")
		api:AddEIDDescription(FiendFolio.PLAYER.FEND, "↑ Fend's libido increases")
		api:AddEIDDescription(FiendFolio.PLAYER.FIENT, "Decreases wavy cap effectiveness")
		api:AddEIDDescription(FiendFolio.PLAYER.FROND, "In an active room, Frond excretes a small amount tears that leave creep#Frond blows up when taking damage")
		api:AddEIDDescription(FiendFolio.PLAYER.IMAGE, "Gives you Subway Surfers for free")
		api:AddEIDDescription(FiendFolio.PLAYER.MI, "Mi's tears spawn friends!!!!!!!!")
		api:AddEIDDescription(FiendFolio.PLAYER.CLASSIC_FIEND, "Classic Fiend's tears light enemies on fire")
		api:AddEIDDescription(FiendFolio.PLAYER.INABA, "Inaba gains another eye satellite familiar")
		api:AddEIDDescription(FiendFolio.PLAYER.BINABA, "Tears in Migrane Mode gain piercing#The tears deal 30% damage after piercing")
		api:AddEIDDescription(FiendFolio.PLAYER.PEAT, "{{Charm}} Friendly Beeter enemies spawn in each room")
		api:AddEIDDescription(FiendFolio.PLAYER.FREEZERJR, "Freezer Jr's crash ability gets faster")
	end
end)