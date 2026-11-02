--oh thank you Connor, this was very helpful
local mod = FiendFolio
local game = Game()

local spellSprite = Sprite()
spellSprite:Load("gfx/ui/spellSlots.anm2", false)
spellSprite:LoadGraphics()

local flashColor = Color(0.3,0.3,0.3,1)
flashColor:SetColorize(1,1,1,1)

local function GetChargebarOffset(slot)
	if slot == ActiveSlot.SLOT_SECONDARY then
		return Vector(-2, 17)
	else
		return Vector(34, 17)
	end
end

local function shouldDisplaySpellSlots(player, slot)
	local activeInfo = mod:GetActiveItemInfo(player, slot)
    local man = activeInfo ~= nil and mod.SPELL[activeInfo.ID] ~= nil
	return man
end

--Spell slots decided per item
--This will mess up with multiple copies of the same spell, however
local function renderSpellSlotsUnderlay(player, slot, pos, alpha)
    local item = player:GetActiveItem(slot)
    local baseInfo = mod.SPELL[item]
    local origData = mod:GetEntityData(player).ffsavedata
    if not origData.SpellSlots then
        origData.SpellSlots = {}
    end
    local savedata = origData.SpellSlots

    if not savedata[item] then
        savedata[item] = mod:makeCopiedTable(baseInfo)
        savedata[item].LastChanged = 0
    end

    spellSprite.Color = Color(1,1,1,alpha,0,0,0)
    spellSprite:SetFrame(savedata[item].MaxSlots .. " Empty", 0)
    spellSprite:Render(pos)
end

local function renderAvailableSpellSlots(player, slot, pos, alpha)
    local item = player:GetActiveItem(slot)
    local baseInfo = mod.SPELL[item]
    local origData = mod:GetEntityData(player).ffsavedata
    if not origData.SpellSlots then
        origData.SpellSlots = {}
    end
    local savedata = origData.SpellSlots

    if savedata[item] == nil then
        savedata[item] = mod:makeCopiedTable(baseInfo)
        savedata[item].LastChanged = 0
	end

    spellSprite:SetFrame(savedata[item].MaxSlots .. " Full", 0)

	if not game:IsPaused() and game:GetFrameCount() - savedata[item].LastChanged < 10 and math.ceil(Isaac.GetFrameCount() * 0.5) % 4 == 0 then
		spellSprite.Color = flashColor
		spellSprite.Color.A = alpha
	else
		spellSprite.Color = Color(1,1,1,alpha,0,0,0)
	end

    local bottomRightClamp = Vector(0, 5)
    local topLeftClamp

    if savedata[item].CurrentSlots and savedata[item].CurrentSlots > 0 then
		local percent = savedata[item].CurrentSlots / savedata[item].MaxSlots
		local x = (29-6) * percent
		topLeftClamp = Vector(0, math.max(25.5 - x, 0))
	else
		topLeftClamp = Vector(0, 30)
	end

	spellSprite:Render(pos, topLeftClamp, bottomRightClamp)
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYERHUD_RENDER_ACTIVE_ITEM, function(_, player, slot, pos, alpha, scale, chargeBarPos)
	if shouldDisplaySpellSlots(player, slot) then
		spellSprite.Scale = Vector(scale, scale)
		--Base Pips of the Spell Slots
		renderSpellSlotsUnderlay(player, slot, chargeBarPos, alpha)
		--Colored in Slots
		renderAvailableSpellSlots(player, slot, chargeBarPos, alpha)
	end
end)
