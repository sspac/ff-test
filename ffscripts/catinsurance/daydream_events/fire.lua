local Mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local EVENT_NAME = "Fire"
local SPRITESHEET = "fire.png"
local YES_DESCRIPTION = "Too hot!"
local NO_DESCRIPTION = "Hotter!"
local EVENT_WEIGHT = 100
local TEXT_OFFSET = Vector(-8, 0)

---@param player EntityPlayer
Mod:AddCallback("DAYDREAM_POST_CONFIRM_EVENT", function (_, player)
    sfx:Play(SoundEffect.SOUND_FREEZE)

    for _, entity in ipairs(Isaac.GetRoomEntities()) do
        if entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
            local data = Mod:GetEntityData(entity)
            
            entity:AddSlowing(EntityRef(player), 150, 0.5, Color(150 / 255, 150 / 255, 150 / 255))
            data.DaydreamFreeze = true
            entity:AddEntityFlags(EntityFlag.FLAG_ICE)

            Isaac.CreateTimer(function ()
                if entity:Exists() and not entity:IsDead() then
                    data.DaydreamFreeze = nil
                    entity:ClearEntityFlags(EntityFlag.FLAG_ICE)
                end
            end, 150, 1, false)
        end
    end
end, EVENT_NAME)

---@param player EntityPlayer
Mod:AddCallback("DAYDREAM_POST_DENY_EVENT", function (_, player)
    sfx:Play(SoundEffect.SOUND_MATCHSTICK)

    for _, entity in ipairs(Isaac.GetRoomEntities()) do
        if entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
            entity:AddBurn(EntityRef(player), 90, player.Damage)
        end
    end
end, EVENT_NAME)

Mod:RegisterDaydreamEvent(EVENT_NAME, EVENT_WEIGHT, YES_DESCRIPTION, NO_DESCRIPTION, SPRITESHEET, nil, TEXT_OFFSET)