--[[local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, function(_, slot)
    local rng = slot:GetDropRNG()
    local d = mod:GetEntityData(slot)
    print(slot.I1, slot.I2, slot:GetTouch())
    if not d.ChangedSlot then
        d.ChangedSlot = true
        if rng:RandomInt(3) == 1 or 1 == 1 then
            local sprite = slot:GetSprite()
            for i = 1, 2 do
                print(sprite:GetLayerFrame(i)) --No way to get this????
            end
            print(sprite:GetAnimation())
            sprite:Load("gfx/items/slots/old revive machine/006.019_revivemachine.anm2", true)
            sprite:SetFrame("Prize", 0)
        end
    end
end, 19)]]