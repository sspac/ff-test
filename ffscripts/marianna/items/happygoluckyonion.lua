local mod = FiendFolio
local game = Game()

local ROLL_CHANCE = 0.03 -- A decimal between 0 and 1 representing the chance (percentage / 100 = this number) 

--========================--
--The Happy-Go-Lucky Onion--
--========================--

mod:AddCollectibleCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.ITEM.COLLECTIBLE.THE_HAPPY_GO_LUCKY_ONION, function()
    local room = game:GetRoom()
    local onions = {
        mod.ITEM.COLLECTIBLE.ONION_DISC,
        CollectibleType.COLLECTIBLE_DEAD_ONION,
        mod.ITEM.COLLECTIBLE.THE_HAPPY_GO_LUCKY_ONION,
        mod.ITEM.COLLECTIBLE.SIDEWAYS_ONION,
        CollectibleType.COLLECTIBLE_SAD_ONION,
    }
    if TaintedTreasure then
        table.insert(onions, TaintedCollectibles.BAD_ONION)
        table.insert(onions, TaintedCollectibles.SORROWFUL_SHALLOT)
--        print("inserted bad onion!")
    end
	if TheSadOnion2 then
        table.insert(onions, TheSadOnion2.Source.Item.TheSadOnion2.ID)
	end
    local firstOwner = PlayerManager.FirstCollectibleOwner(mod.ITEM.COLLECTIBLE.THE_HAPPY_GO_LUCKY_ONION)
    if firstOwner ~= nil and room:IsFirstVisit() == true then
        local rng = firstOwner:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.THE_HAPPY_GO_LUCKY_ONION)
        for _, pedestal in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1)) do
            if pedestal.SubType > 0 then
                local isValid = false
                local itemConfig = Isaac.GetItemConfig():GetCollectible(pedestal.SubType)
                if itemConfig and not itemConfig:HasTags(ItemConfig.TAG_QUEST) then
                    isValid = true
                end

                if isValid and rng:RandomFloat() < ROLL_CHANCE then
                    pedestal:ToPickup():Morph(5, 100, onions[rng:RandomInt(#onions) + 1], true, false, true)
                end
            end
        end
    end
end)
