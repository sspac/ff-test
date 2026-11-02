local mod = FiendFolio

mod.EdensHeadActives = {
    CollectibleType.COLLECTIBLE_BOBS_ROTTEN_HEAD,
    CollectibleType.COLLECTIBLE_CANDLE,
    CollectibleType.COLLECTIBLE_RED_CANDLE,
    CollectibleType.COLLECTIBLE_BOOMERANG,
    CollectibleType.COLLECTIBLE_GLASS_CANNON,
    CollectibleType.COLLECTIBLE_DOCTORS_REMOTE,
    CollectibleType.COLLECTIBLE_BLACK_HOLE,
    CollectibleType.COLLECTIBLE_GELLO,
    mod.ITEM.COLLECTIBLE.D2,
    mod.ITEM.COLLECTIBLE.SANGUINE_HOOK,
    mod.ITEM.COLLECTIBLE.CHERRY_BOMB,
    --mod.ITEM.COLLECTIBLE.GRAPPLING_HOOK, breaks ):
    mod.ITEM.COLLECTIBLE.FLIP_PHONE,
    mod.ITEM.COLLECTIBLE.GREEN_CANDLE,
    mod.ITEM.COLLECTIBLE.LEMON_MISHUH,
    mod.ITEM.COLLECTIBLE.TOY_CAMERA,
    --Not sure if gaper in a jar is going to work, truthfully. Hot-shot i say no because it is exclusive to friend. if it could be found in the pools i would say eys
    mod.ITEM.COLLECTIBLE.KNIFE_BLOCK,
}

local function useItem(_, id, rng, player, flags)
    if flags & UseFlag.USE_CARBATTERY ~= 0 then
      return
    end

    mod.scheduleForUpdate(function ()
      local i = rng:RandomInt(#mod.EdensHeadActives)+1
      local throwable = mod.EdensHeadActives[i]
      player:UseActiveItem(throwable)

      if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
        player:TriggerBookOfVirtues(throwable)
      end
    end, 0, ModCallbacks.MC_INPUT_ACTION, true) 
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, useItem, mod.ITEM.COLLECTIBLE.EDENS_HEAD)