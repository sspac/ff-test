local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local skibidi = "toilet"
--I have named it Bog Baby but it will be Skibidi Baby in my heart

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, familiar)
	familiar.IsFollower = true
end, mod.ITEM.FAMILIAR.SKIBIDI_BABY)

local SkibidiState = {
    IDLE = 0,
    POPUP = 1,
    FLUSH = 2
}

local SKIBIDI_COOLDOWN = 3 --Rooms to wait until flush recharges

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
	local d = mod:GetEntityData(familiar)
	local sprite = familiar:GetSprite()
	local isSuperpositioned = mod:isSuperpositionedPlayer(familiar.Player)

	local wasSirenCharmed = d.IsSirenCharmed or false
	local isSirenCharmed = mod:isSirenCharmed(familiar)

    if familiar.State == SkibidiState.IDLE then
        if familiar.Hearts > 0 then
            mod:spritePlay(sprite, "IdleFlushed")
            if familiar.RoomClearCount > 0 then
                familiar.Hearts = math.max(0, familiar.Hearts - 1)
                familiar.RoomClearCount = 0
                if familiar.Hearts <= 0 then
                    familiar.State = SkibidiState.POPUP
                end
            end
        else
            mod:spritePlay(sprite, "Idle")
        end
    elseif familiar.State == SkibidiState.FLUSH then
        if sprite:IsFinished("Flush") then
            familiar.State = SkibidiState.IDLE
            mod:spritePlay(sprite, "IdleFlushed")
        elseif sprite:IsEventTriggered("Flush") then
            familiar.Player:UseActiveItem(CollectibleType.COLLECTIBLE_FLUSH, false)
            ItemOverlay.Show(Giantbook.FLUSH)
        elseif sprite:IsEventTriggered("Pop") then
            sfx:Play(SoundEffect.SOUND_PLOP, 0.75, 0, false, 0.75)
        else
            mod:spritePlay(sprite, "Flush")
        end
    elseif familiar.State == SkibidiState.POPUP   then
        if sprite:IsFinished("PopUp") then
            familiar.State = SkibidiState.IDLE
        elseif sprite:IsEventTriggered("Pop") then
            sfx:Play(SoundEffect.SOUND_PLOP, 0.75, 0, false, 1.2)
        else
            mod:spritePlay(sprite, "PopUp")
        end
    end

	familiar:FollowParent()
	d.IsSirenCharmed = isSirenCharmed
end, mod.ITEM.FAMILIAR.SKIBIDI_BABY)

mod:AddCallback(ModCallbacks.MC_POST_FAMILIAR_COLLISION, function(_, familiar, collider)
    if collider.Type == EntityType.ENTITY_PROJECTILE then
        if familiar.Hearts <= 0 then
            if familiar:GetDropRNG():RandomInt(10) == 0 then
                familiar.Hearts = SKIBIDI_COOLDOWN
                familiar.State = SkibidiState.FLUSH
            end
        end
    end
end, mod.ITEM.FAMILIAR.SKIBIDI_BABY)