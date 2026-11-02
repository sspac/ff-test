local Mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local EVENT_NAME = "Heart"
local SPRITESHEET = "heart.png"
local YES_DESCRIPTION = "Heal!"
local NO_DESCRIPTION = "Hurt!"
local EVENT_WEIGHT = 100

Mod:AddCallback("DAYDREAM_POST_CONFIRM_EVENT", function (_, _)
    sfx:Play(SoundEffect.SOUND_VAMP_GULP)

    for _, player in ipairs(PlayerManager.GetPlayers()) do
        player:AddHearts(2)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, player.Position + Vector(-25, -30), Vector.Zero, player)
    end
end, EVENT_NAME)

---@param player EntityPlayer
Mod:AddCallback("DAYDREAM_POST_DENY_EVENT", function (_, player)
    sfx:Play(SoundEffect.SOUND_DEATH_CARD)

    for _, entity in ipairs(Isaac.GetRoomEntities()) do
        if entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
            Mod:makeEnemyGib(entity)
            entity:TakeDamage(20, 0, EntityRef(player), 2)
        end
    end
end, EVENT_NAME)

Mod:RegisterDaydreamEvent(EVENT_NAME, EVENT_WEIGHT, YES_DESCRIPTION, NO_DESCRIPTION, SPRITESHEET)