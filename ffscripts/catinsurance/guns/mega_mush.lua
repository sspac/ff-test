local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local synergy = {}

local SIZE_SCALE = 2
local HELD_OFFSET = 20
local VERTICAL_OFFSET = 25
local TEAR_OFFSET = 70

function synergy:GunMegaMushSwag(e, player, aim, ammoUsed, held, entities)
    if player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_MEGA_MUSH) then
        game:ShakeScreen(4)
    end
end

mod:AddCallback("POST_GUN_FIRE", synergy.GunMegaMushSwag)

---@param player EntityPlayer
function synergy:GunMegaMushUpdate(gun, player)
    -- Don't trigger for familiars
    if gun.SpawnerType ~= EntityType.ENTITY_PLAYER then
        return
    end

    local gd = mod:GetEntityData(gun)
    local oldHadMegaMush = gd.PlayerHadMegaMush

    local effects = player:GetEffects()
    if effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_MEGA_MUSH) then
        gd.PlayerHadMegaMush = true
    else
        gd.PlayerHadMegaMush = false
    end

    if gd.PlayerHadMegaMush ~= oldHadMegaMush then
        if gd.PlayerHadMegaMush then
            gd.ForceHeldOffset = (mod.FriendGunInfo[gun.SubType] and mod.FriendGunInfo[gun.SubType].HeldOffset or mod.FriendBalancing.DefaultHeldOffset) * SIZE_SCALE + HELD_OFFSET
            gd.ForceVerticalOffset = (mod.FriendGunInfo[gun.SubType] and mod.FriendGunInfo[gun.SubType].VerticalOffset or mod.FriendBalancing.DefaultVerticalOffset) * SIZE_SCALE - VERTICAL_OFFSET
            gd.ForceTearHeight = (mod.FriendGunInfo[gun.SubType] and mod.FriendGunInfo[gun.SubType].TearHeight or mod.FriendBalancing.DefaultTearHeight) * SIZE_SCALE - TEAR_OFFSET
            gd.ForceMuzzleOffset = (mod.FriendGunInfo[gun.SubType] and mod.FriendGunInfo[gun.SubType].MuzzleOffset or mod.FriendBalancing.DefaultMuzzleOffset) * SIZE_SCALE * 0.9
            gd.ForceMuzzleScale = (mod.FriendGunInfo[gun.SubType] and mod.FriendGunInfo[gun.SubType].MuzzleScale or mod.FriendBalancing.DefaultMuzzleScale) * SIZE_SCALE * 1.5
            gun.SpriteScale = gun.SpriteScale * SIZE_SCALE
        else
            gd.ForceHeldOffset = nil
            gd.ForceVerticalOffset = nil
            gd.ForceTearHeight = nil
            gd.ForceMuzzleOffset = nil
            gd.ForceMuzzleScale = nil
            gun.SpriteScale = Vector.One
        end
    end
end

mod:AddCallback("POST_GUN_UPDATE", synergy.GunMegaMushUpdate)