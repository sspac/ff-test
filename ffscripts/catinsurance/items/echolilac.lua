local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local Constants = {
    SECONDS = 30 * 6,
    DEFAULT_SOUNDS = {
        SoundEffect.SOUND_MONSTER_GRUNT_0,
        SoundEffect.SOUND_MONSTER_GRUNT_1,
        SoundEffect.SOUND_MONSTER_GRUNT_2,
        SoundEffect.SOUND_MONSTER_GRUNT_4,
        SoundEffect.SOUND_MONSTER_GRUNT_5,
        SoundEffect.SOUND_MONSTER_ROAR_0,
        SoundEffect.SOUND_MONSTER_ROAR_1,
        SoundEffect.SOUND_MONSTER_ROAR_2,
        SoundEffect.SOUND_MONSTER_ROAR_3,
    }
}

mod.EcholilacSounds = {

}

local function getCombinedId(ent)
    return tostring(ent.Type) .. "." .. tostring(ent.Variant) 
end

local lastUsedCombinedId
function mod:EcholilacUse(_, rng, player, flags)
    local ents = mod.GetRoomEntitiesCache()
    local groups = {}
    local groupIds = {}
    for _, ent in ipairs(ents) do
        if (
            (ent:IsActiveEnemy() and ent:IsVulnerableEnemy())
            and not ent:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
        ) then
            local id = getCombinedId(ent)
            if lastUsedCombinedId ~= id then
                if not groups[id] then
                    groups[id] = {}
                end
    
                table.insert(groups[id], ent)
                table.insert(groupIds, id)
            end
        end
    end

    if flags & UseFlag.USE_CARBATTERY > 0 and lastUsedCombinedId then
        lastUsedCombinedId = nil
    end

    if #groupIds > 0 then
        local times = flags & UseFlag.USE_CARBATTERY > 0 and 2 or 1
        for _ = 1, times do
            if #groupIds == 0 then
                return true
            end

            local index = rng:RandomInt(#groupIds) + 1
            local choiceId = groupIds[index]
            local choiceGroup = groups[choiceId]

            lastUsedCombinedId = choiceId

            if mod.EcholilacSounds[choiceId] then
                sfx:Play(mod.EcholilacSounds[choiceId])
            else
                local sound = Constants.DEFAULT_SOUNDS[rng:RandomInt(#Constants.DEFAULT_SOUNDS) + 1]
                sfx:Play(sound)
            end

            for _, enemy in ipairs(choiceGroup) do
                mod.AddPacified(enemy, player, Constants.SECONDS)
            end

            table.remove(groupIds, index)
        end

        game:MakeShockwave(player.Position, 0.0175, 0.02, 8)
    end

    return true
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.EcholilacUse, mod.ITEM.COLLECTIBLE.ECHOLILAC)