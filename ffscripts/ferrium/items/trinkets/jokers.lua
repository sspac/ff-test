local mod = FiendFolio
local game = Game()

function mod:GetCardSuitNumber(card, includeMinor, stripExtra)
	local suit,num
	for _,suitr in pairs(mod.CARDSUITS) do
        if includeMinor or not (suitr == "WANDS" or suitr == "PENTACLES" or suitr == "SWORDS" or suitr == "CUPS") then
            for numr,id in pairs(suitr) do
                if id == card then
                    suit = suitr
                    num = numr
                    break
                end
            end
        end
	end
    if stripExtra and num then
        local last = num:sub(-1)
        if last == "M" or last == "J" then
            num = num:sub(1, num:len()-1)
        end
    end
	return suit, num
end

function mod:SurveyJokerStatus()
    local club, spade, diamond, heart = 0, 0, 0, 0
    local exists
    for i = 1, game:GetNumPlayers() do
		local player = Isaac.GetPlayer(i-1)

        if player:HasTrinket(mod.ITEM.TRINKET.GLUTTONOUS_JOKER) then
            local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.GLUTTONOUS_JOKER)
            club = club+mult
            exists = true
        end
        if player:HasTrinket(mod.ITEM.TRINKET.WRATHFUL_JOKER) then
            local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.WRATHFUL_JOKER)
            spade = spade+mult
            exists = true
        end
        if player:HasTrinket(mod.ITEM.TRINKET.GREEDY_JOKER) then
            local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.GREEDY_JOKER)
            diamond = diamond+mult
            exists = true
        end
        if player:HasTrinket(mod.ITEM.TRINKET.LUSTY_JOKER) then
            local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.LUSTY_JOKER)
            heart = heart+mult
            exists = true
        end
    end
    if exists then
        return {{"CLUBS", club}, {"SPADES", spade}, {"DIAMONDS", diamond}, {"HEARTS", heart}}
    end
end