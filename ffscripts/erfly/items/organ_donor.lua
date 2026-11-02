local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

function mod:organDonorPeffectUpdate(player)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.ORGAN_DONOR) then
        if player.FrameCount % 2 == 0 then
            local bloodSplat = Isaac.Spawn(1000, 7, 0, player.Position, Vector.Zero, player):ToEffect()
            bloodSplat.SpriteScale = bloodSplat.SpriteScale * 0.5
            bloodSplat.Rotation = math.random(360)
            bloodSplat:Update()
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.ORGAN_DONOR, mod.organDonorPeffectUpdate)

mod.UnsafeOrganDonorHealthTypes = {
    [HealthType.SOUL] = true,
}

function mod:removeOrganDonorForSoulHeartCharacters(player)
    local healthType = player:GetHealthType()
    if mod.UnsafeOrganDonorHealthTypes[healthType] then
        local itempool = game:GetItemPool()
        if itempool:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.ORGAN_DONOR) then
            itempool:RemoveCollectible(FiendFolio.ITEM.COLLECTIBLE.ORGAN_DONOR)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.removeOrganDonorForSoulHeartCharacters)