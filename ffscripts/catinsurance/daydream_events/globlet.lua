local Mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local EVENT_NAME = "Globlet"
local SPRITESHEET = "globlet.png"
local YES_DESCRIPTION = "Friend!"
local NO_DESCRIPTION = "Decoy!"
local EVENT_WEIGHT = 100

Mod:AddCallback("DAYDREAM_POST_CONFIRM_EVENT", function (_, player)
    sfx:Play(SoundEffect.SOUND_SUMMON_POOF)
    local friend = Isaac.Spawn(Mod.FF.Globlet.ID, Mod.FF.Globlet.Var, 0, player.Position + RandomVector() * 40, Vector.Zero, player)
    friend:AddEntityFlags(EntityFlag.FLAG_PERSISTENT | EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)
    friend.MaxHitPoints = friend.MaxHitPoints / 2
    friend.HitPoints = friend.MaxHitPoints
end, EVENT_NAME)

---@param player EntityPlayer
Mod:AddCallback("DAYDREAM_POST_DENY_EVENT", function (_, player)
    sfx:Play(SoundEffect.SOUND_SUMMON_POOF)
    local friend = Isaac.Spawn(Mod.FF.Globlet.ID, Mod.FF.Globlet.Var, 0, player.Position + RandomVector() * 40, Vector.Zero, player)
    friend:AddEntityFlags(EntityFlag.FLAG_PERSISTENT | EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM | EntityFlag.FLAG_BAITED)
    friend.CollisionDamage = 0
    friend.MaxHitPoints = friend.MaxHitPoints * 3
    friend.HitPoints = friend.MaxHitPoints
end, EVENT_NAME)

Mod:RegisterDaydreamEvent(EVENT_NAME, EVENT_WEIGHT, YES_DESCRIPTION, NO_DESCRIPTION, SPRITESHEET)