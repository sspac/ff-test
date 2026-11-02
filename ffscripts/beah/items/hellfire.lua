local mod = FiendFolio
local sfx = SFXManager()
local hellframes = 45

local function procChance(player)
    return math.min(0.13 + (player.Luck*0.02),0.33)
end
local shouldMakeDMGCrazy = false
local function OnTakeDMG(_, ent, amount, flags, source, dmgCooldown)
    if shouldMakeDMGCrazy then
        return
    end
    ent = ent:ToNPC()
    if (not ent
    or not ent:IsEnemy()
    or ent:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS))
    --and ent.Type ~= 33 
    then
        return
    end

    local e_data = mod:GetEntityData(ent)
    if e_data.sw_hellfirePrimedFrames ~= nil and e_data.sw_hellfirePrimedFrames < 0 and e_data.sw_hellfireLingerBeams == nil then
        return
    elseif e_data.sw_hellfirePrimedFrames == nil and ent.HitPoints < 0.1 and e_data.sw_hellfireMultishotProofing and e_data.sw_hellfireMultishotProofing > ent.FrameCount+1 then
        return
    end
    local player = PlayerManager.FirstCollectibleOwner(mod.ITEM.COLLECTIBLE.HELLFIRE)
    if player then
        local c_rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.HELLFIRE)
        if e_data.sw_isHellfireMarked == nil then
            e_data.sw_isHellfireMarked = c_rng:RandomFloat() < procChance(player)
            if e_data.sw_isHellfireMarked then
                e_data.sw_hellfireOwner = player
            end
        end
    end
    if e_data.sw_hellfirePrimedFrames ~= nil then
        return false
    end
    if e_data.sw_isHellfireMarked then
        e_data.sw_hellfireMultishotProofing = ent.FrameCount
        return { DamageFlags = flags | DamageFlag.DAMAGE_NOKILL}
    end
end

mod:AddPriorityCollectibleCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.LATE, mod.ITEM.COLLECTIBLE.HELLFIRE, OnTakeDMG)

local function HellfireCOBUpdate(_)
    local entities = mod.GetRoomEntitiesCache()
    for index, ent in ipairs(entities) do
        local e_data = mod:GetEntityData(ent)
        if not e_data.sw_isHellfireMarked then
            goto continue
        end
        if e_data.sw_hellfirePrimedFrames ~= nil then    
            e_data.sw_hellfirePrimedFrames = e_data.sw_hellfirePrimedFrames - 1
            local shouldFlash = e_data.sw_hellfirePrimedFrames % 5 == 4 and e_data.sw_hellfirePrimedFrames > 0
            --[[if e_data.sw_hellfireSwirl == nil then
                e_data.sw_hellfireSwirl = Isaac.Spawn(1000, 71, 0, ent.Position, Vector.Zero, ent)
                e_data.sw_hellfireSwirl.PositionOffset = Vector(0, -24)
                e_data.sw_hellfireSwirl.DepthOffset = -24
            end
            if e_data.sw_hellfireSwirl:Exists() then
                e_data.sw_hellfireSwirl.Position = ent.Position
            end]]
            if shouldFlash then
                local color = Color(1, 1, 1, 1, 1)
                ent:SetColor(color, 5, 0, true, false)
                sfx:Play(SoundEffect.SOUND_BEEP, 1, 0)
            elseif e_data.sw_hellfirePrimedFrames == 0 then
                ent:BloodExplode()
                sfx:Stop(SoundEffect.SOUND_BEEP)
                local player = e_data.sw_hellfireOwner
                if player == nil then
                    e_data.sw_hellfirePrimedFrames = nil
                    ent:TakeDamage(10, 0, EntityRef(ent), 0)
                    goto continue
                end
                local color = Color(1, 1, 1, 1, 1)
                ent:SetColor(color, 30, 0, true, false)
                e_data.sw_hellfireLingerBeams = {}
                for i = 1, 4, 1 do
                    local dir = Vector(0,1):Rotated(90*i)
                    local nl = player:FireBrimstone(dir, player, 1)
                    nl.ParentOffset = (ent.Position -ent.Velocity)  - player.Position
                    nl.TearFlags = TearFlags.TEAR_SPECTRAL
                    nl.Color = Color(1,1,1,1)
                    nl.Timeout = nl.Timeout + 20
                    e_data.sw_hellfireLingerBeams[i] = nl 
                end
                --Game():BombTearflagEffects(ent.Position, 1, TearFlags.TEAR_BRIMSTONE_BOMB, Isaac.GetPlayer(0), 1) we want custom brimstone stuff now
            elseif e_data.sw_hellfireLingerBeams ~= nil then
                local kill = false
                for _, value in ipairs(e_data.sw_hellfireLingerBeams) do
                    if not value:Exists() or value.Timeout <= 0 then
                        kill = true
                    else
                        local player = e_data.sw_hellfireOwner
                        value.ParentOffset = ent.Position - player.Position
                    end
                end
                if kill then
                    e_data.sw_hellfireLingerBeams = nil
                    ---ent:Kill() unfortunately this means it cant remove hosts, but otherwise this breaks mother fight badly
                    ent:TakeDamage(50, DamageFlag.DAMAGE_INVINCIBLE, EntityRef(Isaac.GetPlayer(1)), 0)

                    sfx:Play(SoundEffect.SOUND_MEATY_DEATHS, 0.8, 0)
                    ent:MakeBloodPoof()
                   --blood vfx
                end
            end
        elseif ent.HitPoints < 0.1 then
            e_data.sw_hellfirePrimedFrames = hellframes
        end
        ::continue::
    end
end

mod:AddCollectibleCallback(ModCallbacks.MC_POST_UPDATE, mod.ITEM.COLLECTIBLE.HELLFIRE, HellfireCOBUpdate)