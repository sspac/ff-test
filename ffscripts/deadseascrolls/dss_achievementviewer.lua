local fiendfoliodirectory = FiendFolio.DSS_DIRECTORY
local dssmod = FiendFolio.DSS_MOD
local mod = FiendFolio

local function fiendUnlocked()
    return FiendFolio.ACHIEVEMENT.FIEND:IsUnlocked(true)
end

local function biendUnlocked()
    return FiendFolio.ACHIEVEMENT.BIEND:IsUnlocked(true)
end

local function golemUnlocked()
    return FiendFolio.ACHIEVEMENT.GOLEM:IsUnlocked(true)
end

local function bolemUnlocked()
    return FiendFolio.ACHIEVEMENT.BOLEM:IsUnlocked(true)
end

local function friendUnlocked()
    return FiendFolio.ACHIEVEMENT.FRIEND:IsUnlocked(true)
end

local function briendUnlocked()
    return FiendFolio.ACHIEVEMENT.BRIEND:IsUnlocked(true)
end

local function inabaUnlocked()
    return FiendFolio.ACHIEVEMENT.INABA:IsUnlocked(true)
end

local function binabaUnlocked()
    return FiendFolio.ACHIEVEMENT.BINABA:IsUnlocked(true)
end

local function skeletalFiendUnlocked()
    return (Epiphany and Epiphany.API and FiendFolio.ACHIEVEMENT.SKELETALFIEND:IsUnlocked(true))
end

local function anyTaintedIsUnlocked()
	local pdata = Isaac.GetPersistentGameData()
	return pdata:Unlocked(Achievement.TAINTED_ISAAC) or
	       pdata:Unlocked(Achievement.TAINTED_MAGDALENE) or
	       pdata:Unlocked(Achievement.TAINTED_CAIN) or
	       pdata:Unlocked(Achievement.TAINTED_JUDAS) or
	       pdata:Unlocked(Achievement.TAINTED_BLUE_BABY) or
	       pdata:Unlocked(Achievement.TAINTED_EVE) or
	       pdata:Unlocked(Achievement.TAINTED_SAMSON) or
	       pdata:Unlocked(Achievement.TAINTED_AZAZEL) or
	       pdata:Unlocked(Achievement.TAINTED_LAZARUS) or
	       pdata:Unlocked(Achievement.TAINTED_EDEN) or
	       pdata:Unlocked(Achievement.TAINTED_LOST) or
	       pdata:Unlocked(Achievement.TAINTED_LILITH) or
	       pdata:Unlocked(Achievement.TAINTED_KEEPER) or
	       pdata:Unlocked(Achievement.TAINTED_APOLLYON) or
	       pdata:Unlocked(Achievement.TAINTED_FORGOTTEN) or
	       pdata:Unlocked(Achievement.TAINTED_BETHANY) or
	       pdata:Unlocked(Achievement.TAINTED_JACOB) or
	       FiendFolio.ACHIEVEMENT.BIEND:IsUnlocked(true) or
	       FiendFolio.ACHIEVEMENT.BOLEM:IsUnlocked(true) or
	       FiendFolio.ACHIEVEMENT.BRIEND:IsUnlocked(true) or
	       FiendFolio.ACHIEVEMENT.BINABA:IsUnlocked(true)
end

local function biendCanDisplayCharacterUnlock()
    return anyTaintedIsUnlocked() and FiendFolio.ACHIEVEMENT.FIEND:IsUnlocked(true)
end

local function bolemCanDisplayCharacterUnlock()
    return anyTaintedIsUnlocked() and FiendFolio.ACHIEVEMENT.GOLEM:IsUnlocked(true)
end

local function briendCanDisplayCharacterUnlock()
    return anyTaintedIsUnlocked() and FiendFolio.ACHIEVEMENT.FIEND:IsUnlocked(true)
end

local function binabaCanDisplayCharacterUnlock()
    return anyTaintedIsUnlocked() and FiendFolio.ACHIEVEMENT.INABA:IsUnlocked(true)
end

local function skeletalFiendCanDisplayCharacterUnlock()
    return (Epiphany and Epiphany.API and FiendFolio.ACHIEVEMENT.BIEND:IsUnlocked(true))
end

local function canShowTarnishedUnlocks()
    return Epiphany and Epiphany.API
end

local function allCharUnlocked()
    return (FiendFolio.ACHIEVEMENT.FIEND:IsUnlocked(true) or
	       FiendFolio.ACHIEVEMENT.GOLEM:IsUnlocked(true) or
	       FiendFolio.ACHIEVEMENT.FRIEND:IsUnlocked(true)) and
	       FiendFolio.ACHIEVEMENT.INABA:IsUnlocked(true)
end

local achievementGroups = {
	{
        Name = "everything",
        Icon = "everything",
        TagToName = {
            Misc = "miscellaneous",
            Fiend = "fiend",
            Biend = "tainted fiend",
            SkeletalFiend = "the skeletal fiend",
            Golem = "golem",
            Bolem = "tainted golem",
            Friend = "friend",
            Briend = "tainted friend",
            Inaba = "inaba",
            Binaba = "tainted inaba",
            MechaSatan = "fiendish foes",
            AllClear = "full marks",
            Challenge = "challenge",
            Backdrop = "backdrop",
        },
        TagToDisplayIf = {
			BiendUnlock = biendCanDisplayCharacterUnlock,
			SkeletalFiendUnlock = skeletalFiendCanDisplayCharacterUnlock,
			BolemUnlock = bolemCanDisplayCharacterUnlock,
			BriendUnlock = briendCanDisplayCharacterUnlock,
			InabaUnlock = inabaUnlocked,
			BinabaUnlock = binabaCanDisplayCharacterUnlock,
            FiendDisplay = fiendUnlocked,
            BiendDisplay = biendUnlocked,
            GolemDisplay = golemUnlocked,
            BolemDisplay = bolemUnlocked,
            FriendDisplay = friendUnlocked,
            BriendDisplay = briendUnlocked,
            InabaDisplay = inabaUnlocked,
            BinabaDisplay = binabaUnlocked,
            SkeletalFiendDisplay = skeletalFiendUnlocked,
			MechaSatanTainted = anyTaintedIsUnlocked,
            AllClear = allCharUnlocked,
        },
        Achievements = {}
    },
    {
        Name = "characters",
        Icon = "characters",
        Tag = {"CharacterDisplay"},
        TagToName = {
            Fiend = "fiend",
            Biend = "tainted fiend",
            SkeletalFiend = "the skeletal fiend",
            Golem = "golem",
            Bolem = "tainted golem",
            Friend = "friend",
            Briend = "tainted friend",
            Inaba = "inaba",
            Binaba = "tainted inaba",
        },
        TagToDisplayIf = {
            Biend = biendCanDisplayCharacterUnlock,
            Bolem = bolemCanDisplayCharacterUnlock,
            Briend = briendCanDisplayCharacterUnlock,
            Inaba = inabaUnlocked,
            Binaba = binabaCanDisplayCharacterUnlock,
            SkeletalFiend = skeletalFiendCanDisplayCharacterUnlock,
        },
    },
    {
        Name = "fiend",
        Tag = {"FiendUnlock", "FiendCompletion", "FiendAll"},
        Icon = "fiend",
        DisplayIf = fiendUnlocked
    },
    {
        Name = "tainted fiend",
        Tag = "Biend",
        Icon = "biend",
        DisplayIf = biendUnlocked
    },
    {
        Name = "the skeletal fiend",
        Tag = {"SkeletalFiendUnlock", "SkeletalFiendCompletion", "SkeletalFiendAll"},
        Icon = "skeletalfiend",
        DisplayIf = skeletalFiendUnlocked
    },
    {
        Name = "golem",
        Tag = {"GolemUnlock", "GolemCompletion", "GolemAll"},
        Icon = "golem",
        DisplayIf = golemUnlocked
    },
    {
        Name = "tainted golem",
        Tag = "Bolem",
        Icon = "bolem",
        DisplayIf = bolemUnlocked
    },
    {
        Name = "friend",
        Tag = {"FriendUnlock", "FriendCompletion", "FriendAll"},
        Icon = "friend",
        DisplayIf = friendUnlocked
    },
    {
        Name = "tainted friend",
        Tag = "Briend",
        Icon = "briend",
        DisplayIf = briendUnlocked
    },
    {
        Name = "inaba",
        Tag = {"InabaUnlock", "InabaCompletion", "InabaAll"},
        Icon = "inaba",
        DisplayIf = inabaUnlocked
    },
    {
        Name = "tainted inaba",
        Tag = "Binaba",
        Icon = "binaba",
        DisplayIf = binabaUnlocked
    },
    {
        Name = "fiendish foes",
        Tag = "MechaSatan",
        Icon = "mechasatan",
        TagToDisplayIf = {
			MechaSatanTainted = anyTaintedIsUnlocked,
			MechaSatanTarnished = canShowTarnishedUnlocks,
        },
    },
    {
        Name = "full marks",
        Tag = "AllClear",
        Icon = "allclear",
        DisplayIf = allCharUnlocked
    },
    {
        Name = "challenge",
        Tag = "Challenge",
        Icon = "challenge"
    },
    {
        Name = "backdrop",
        Tag = "Backdrop",
        Icon = "backdrop"
    },
    {
        Name = "miscellaneous",
        Tag = "Misc",
        Icon = "misc"
    },
    {
        Name = "recent",
        ShowRecent = true,
        Icon = "recent",
    }
}

for _, group in ipairs(achievementGroups) do
    local sprite = Sprite()
    sprite:Load("gfx/ui/achievement/group_icons/group_icon.anm2", false)
    sprite:ReplaceSpritesheet(0, "gfx/ui/achievement/group_icons/icon_" .. group.Icon .. ".png")
    sprite:LoadGraphics()
    sprite:SetFrame("Idle", 0)
    group.Icon = sprite
end

local arrow = Sprite()
arrow:Load("gfx/ui/achievement/group_icons/arrow_icon.anm2", true)

local achievementLockedSprite = Sprite()
achievementLockedSprite:Load("gfx/ui/achievement/_ff_achievement.anm2", false)
achievementLockedSprite:ReplaceSpritesheet(0, "gfx/nothing.png")
achievementLockedSprite:ReplaceSpritesheet(2, "gfx/ui/achievement/achievement_locked.png")
achievementLockedSprite:LoadGraphics()

local achievementTooltipSprites = {
    Shadow = "gfx/ui/achievement/group_note/menu_achievement_shadow.png",
    Back = "gfx/ui/achievement/group_note/menu_achievement_back.png",
    Face = "gfx/ui/achievement/group_note/menu_achievement_face.png",
    Border = "gfx/ui/achievement/group_note/menu_achievement_border.png",
    Mask = "gfx/ui/achievement/group_note/menu_achievement_mask.png",
}

for k, v in pairs(achievementTooltipSprites) do
    local sprite = Sprite()
    sprite:Load("gfx/ui/achievement/group_note/menu_achievement.anm2", false)
    sprite:ReplaceSpritesheet(0, v)
    sprite:LoadGraphics()
    achievementTooltipSprites[k] = sprite
end


local displayIndexToScale = {
    [0] = Vector(1, 1),
    [1] = Vector(0.75, 0.75),
    [2] = Vector(0.5, 0.5),
    [3] = Vector(0, 0),
    [4] = Vector(0, 0)
}

local displayIndexToColor = {
    [0] = Color.Default,
    [1] = Color(0.9, 0.9, 0.9, 1, 0, 0, 0),
    [2] = Color(0.8, 0.8, 0.8, 1, 0, 0, 0),
    [3] = Color(0.8, 0.8, 0.8, 0, 0, 0, 0),
    [4] = Color(0, 0, 0, 0, 0, 0, 0)
}

local displayIndexToYPos = {
    [0] = -50,
    [1] = -40,
    [2] = -30,
    [3] = -20,
    [4] = 5000
}

fiendfoliodirectory.achievementviewer = {
    format = {
        Panels = {
            {
                Panel = {
                    StartAppear = function(panel)
                        dssmod.playSound(dssmod.menusounds.Open)
                        panel.AppearFrame = 0
                        panel.Idle = false
                    end,
                    UpdateAppear = function(panel)
                        if panel.SpriteUpdateFrame then
                            panel.AppearFrame = panel.AppearFrame + 1
                            if panel.AppearFrame >= 10 then
                                panel.AppearFrame = nil
                                panel.Idle = true
                                return true
                            end
                        end
                    end,
                    StartDisappear = function(panel)
                        dssmod.playSound(dssmod.menusounds.Close)
                        panel.DisappearFrame = 0
                    end,
                    UpdateDisappear = function(panel)
                        if panel.SpriteUpdateFrame then
                            panel.DisappearFrame = panel.DisappearFrame + 1
                            if panel.DisappearFrame >= 11 then
                                return true
                            end
                        end
                    end,
                    RenderBack = function(panel, panelPos, tbl)
                        local anim, frame = "TrueIdle", 0
                        if panel.AppearFrame then
                            anim, frame = "AppearVert", panel.AppearFrame
                        elseif panel.DisappearFrame then
                            anim, frame = "DisappearVert", panel.DisappearFrame
                        end

                        if panel.ShiftFrame then
                            panel.ShiftFrame = panel.ShiftFrame + 1
                            if panel.ShiftFrame > panel.ShiftLength then
                                panel.ShiftLength = nil
                                panel.ShiftFrame = nil
                                panel.ShiftDirection = nil
                            end
                        end

                        local item = fiendfoliodirectory.achievementviewer
                        local group = achievementGroups[item.achievementgroupselected]
                        local numAchievements = #group.Achievements

                        local displayedAchievements = {}

                        local displayedCount = 7 - 1
                        for i = -(displayedCount / 2), displayedCount / 2, 1 do
                            local listIndex = #displayedAchievements + 1
                            local indexOffset = 0
                            local shiftPercent
                            if panel.ShiftFrame then
                                shiftPercent = panel.ShiftFrame / panel.ShiftLength
                                indexOffset = ((1 - shiftPercent) * panel.ShiftDirection)
                            end

                            local percent = ((listIndex + indexOffset) - 1) / displayedCount
                            local xPos = mod:Lerp(-280, 280, percent)

                            local scale = displayIndexToScale[math.abs(i)]
                            local color = displayIndexToColor[math.abs(i)]
                            local yPos = displayIndexToYPos[math.abs(i)]
                            if shiftPercent then
                                local shiftedScale = displayIndexToScale[math.abs(i + panel.ShiftDirection)]
                                scale = mod:Lerp(shiftedScale, scale, shiftPercent)
                                local shiftedColor = displayIndexToColor[math.abs(i + panel.ShiftDirection)]
                                color = Color.Lerp(shiftedColor, color, shiftPercent)
                                local shiftedY = displayIndexToYPos[math.abs(i + panel.ShiftDirection)]
                                yPos = mod:Lerp(shiftedY, yPos, shiftPercent)
                            end

                            local index = (((item.selectedingroup[group.Name] + i) - 1) % numAchievements) + 1
                            local achievement = group.Achievements[index]
                            displayedAchievements[#displayedAchievements + 1] = {
                                Achievement = achievement.Achievement,
                                Position = Vector(xPos, yPos),
                                Scale = scale,
                                Color = color
                            }
                        end

                        table.sort(displayedAchievements, function(a, b)
                            return a.Position.Y > b.Position.Y
                        end)

                        for _, display in ipairs(displayedAchievements) do
                            local achievement = display.Achievement
                            local useSprite = achievement.Sprite
                            if not achievement:IsUnlocked(true) then
                                useSprite = achievementLockedSprite
                            end

                            useSprite:SetFrame(anim, frame)
                            useSprite.Scale = display.Scale
                            useSprite.Color = display.Color
                            useSprite:Render(panelPos + display.Position + Vector(0, 30), Vector.Zero, Vector.Zero)
                        end
                    end,
                    HandleInputs = function(panel, input, item, itemswitched, tbl)
                        if not itemswitched then
                            local menuinput = input.menu
                            local rawinput = input.raw
                            if rawinput.left > 0 or rawinput.right > 0 then
                                local group = achievementGroups[item.achievementgroupselected]
                                local name = group.Name
                                local numAchievements = #group.Achievements


                                local change
                                if not panel.ShiftFrame then
                                    local usingInput, setChange
                                    if rawinput.right > 0 then
                                        usingInput = rawinput.right
                                        setChange = 1
                                    elseif rawinput.left > 0 then
                                        usingInput = rawinput.left
                                        setChange = -1
                                    end

                                    local shiftLength = 10
                                    if usingInput >= 88 then
                                        shiftLength = 7
                                    end

                                    if (usingInput == 1 or (usingInput >= 18 and usingInput % (shiftLength + 1) == 0)) then
                                        change = setChange
                                        panel.ShiftLength = shiftLength
                                    end
                                end

                                if change then
                                    panel.ShiftFrame = 0
                                    panel.ShiftDirection = change
                                    item.selectedingroup[name] = ((item.selectedingroup[name] + change -  1) % numAchievements) + 1
                                    dssmod.playSound(dssmod.menusounds.Pop3)
                                end
                            elseif menuinput.down or menuinput.up then
                                local change
                                if menuinput.down then
                                    change = 1
                                elseif menuinput.up then
                                    change = -1
                                end

                                if change then
                                    local done = false
                                    while not done do
                                        item.achievementgroupselected = item.achievementgroupselected or 1
                                        item.achievementgroupselected = ((item.achievementgroupselected + change - 1) % #achievementGroups) + 1
                                        local group = achievementGroups[item.achievementgroupselected]

                                        if not group.DisplayIf or group.DisplayIf() then
                                            done = true
                                        end
                                    end

                                    dssmod.playSound(dssmod.menusounds.Pop2)
                                end
                            end
                        end
                    end
                },
                Offset = Vector.Zero,
                Color = Color.Default
            },
            {
                Panel = {
                    Sprites = achievementTooltipSprites,
                    Bounds = {-153, -22, 153, 22},
                    Height = 44,
                    TopSpacing = 2,
                    BottomSpacing = 0,
                    DefaultFontSize = 2,
                    DrawPositionOffset = Vector(2, 2),
                    Draw = function(panel, pos, item, tbl)
                        local drawings = {}
                        local group = achievementGroups[item.achievementgroupselected]
                        if item.selectedingroup[group.Name] then
                            local achievementDat = group.Achievements[item.selectedingroup[group.Name]]
                            local achievement = achievementDat.Achievement
                            local tooltipConcat = ""
                            local tooltipConcat2 = ""
                            --local singleLineLimit = 3
                            if not achievement.ViewerTooltip then
                                for i, entry in ipairs(achievement.Tooltip) do
                                    local toConcat = entry
                                    if i ~= #achievement.Tooltip and i ~= singleLineLimit then
                                        toConcat = toConcat .. " "
                                    end

                                    --if i > singleLineLimit then
                                    --    tooltipConcat2 = tooltipConcat2 .. toConcat
                                    --else
                                    tooltipConcat = tooltipConcat .. toConcat
                                    --end
                                end
                            end

                            local name = achievement.Name
                            if not achievement:IsUnlocked(true) then
                                name = "locked!"
                            end

                            local buttons = {
                                {str = "- " .. achievementDat.Group .. " -", fsize = 1},
                                {str = name, fsize = 2},
                            }

                            if tooltipConcat ~= "" then
                                buttons[#buttons + 1] = {str = tooltipConcat, fsize = 1}
                            end

                            if tooltipConcat2 ~= "" then
                                buttons[#buttons + 1] = {str = tooltipConcat2, fsize = 1}
                            end

                            if achievement.ViewerTooltip then
                                for _, str in ipairs(achievement.ViewerTooltip) do
                                    buttons[#buttons + 1] = {str = str, fsize = 1}
                                end
                            end

                            local drawItem = {
                                valign = -1,
                                buttons = buttons
                            }
                            drawings = dssmod.generateMenuDraw(drawItem, drawItem.buttons, pos, panel.Panel)
                        end

                        if group then
                            table.insert(drawings, {type = "spr", pos = Vector(-134, 1), sprite = group.Icon, noclip = true, root = pos, usemenuclr = true})
                            table.insert(drawings, {type = "spr", pos = Vector(-134, -14), anim = "Idle", frame = 0, sprite = arrow, noclip = true, root = pos, usemenuclr = true})
                            table.insert(drawings, {type = "spr", pos = Vector(-134, 16), anim = "Idle", frame = 1, sprite = arrow, noclip = true, root = pos, usemenuclr = true})
                        end

                        for _, drawing in ipairs(drawings) do
                            dssmod.drawMenu(tbl, drawing)
                        end
                    end,
                    DefaultRendering = true
                },
                Offset = Vector(0, 100),
                Color = 1
            }
        }
    },
    generate = function(item, tbl)
        for _, group in ipairs(achievementGroups) do
            group.Achievements = {}
        
            local achievements = {}
            if group.Tag then
				if type(group.Tag) == "table" then
					for _, tag in ipairs(group.Tag) do
						for _, achieve in ipairs(FiendFolio.GetAchievementsWithTag(tag)) do
							table.insert(achievements, achieve)
						end
					end
				else
					achievements = FiendFolio.GetAchievementsWithTag(group.Tag)
				end
            elseif group.ShowRecent then
                local achievementCount = 0
                for _, id in ipairs(FiendFolio.savedata.recentAchievements) do
                    -- Find the achievement in the list
                    local achieve = FiendFolio.GetAchievementById(id)
                    if achieve then
                        if not achieve.Tarnished or (Epiphany and Epiphany.API) then
                            table.insert(achievements, achieve)
                        end

                        -- Still count tarnished achievements even though they shouldn't appear
                        achievementCount = achievementCount + 1
                    end
                end

                -- Fill remaining slots
                for _ = achievementCount+1, FiendFolio.ACHIEVEMENT_HISTORY_LENGTH do
                    local default = FiendFolio.GetAchievementById("LOCKED_PLACEHOLDER")
                    table.insert(achievements, default)
                end

                -- Failsafe for when somehow the player has only Epiphany achievements
                if #achievements == 0 then
                    local default = FiendFolio.GetAchievementById("LOCKED_PLACEHOLDER")
                    table.insert(achievements, default)
                end
            else
                achievements = FiendFolio.ACHIEVEMENT_ORDERED
            end
        
            for _, achieve in ipairs(achievements) do
				local shouldDisplay = true
				if not inabaUnlocked() then
					for _, tag in ipairs(achieve.Tags) do
						if tag == "InabaHidden" then
							shouldDisplay = false
							break
						end
					end
				end
				
				if shouldDisplay and achieve.Sprite then
                    local groupName = group.Name
                    if group.TagToName then
                        for tag, name in pairs(group.TagToName) do
                            if achieve.Tags[tag] then
                                groupName = name
								if tag == "MechaSatan" then break end --prioritizing this tag
                            end
                        end
                    end

                    local display = true
                    if group.TagToDisplayIf then
                        for tag, func in pairs(group.TagToDisplayIf) do
                            if achieve.Tags[tag] and not func() then
                                display = false
                                break
                            end
                        end
                    end

                    if achieve.ViewerDisplayIf and not achieve.ViewerDisplayIf(group) then
                        display = false
                    end
                    
                    if display then
                        group.Achievements[#group.Achievements + 1] = {Achievement = achieve, Group = groupName}
                    end
                end
            end
        
            item.selectedingroup[group.Name] = 1
        end
    end,
    achievementgroupselected = 1,
    selectedingroup = {}
}

