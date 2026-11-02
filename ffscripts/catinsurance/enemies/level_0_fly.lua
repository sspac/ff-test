local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local enemy = {}

local levelZeroFly = mod.FF.Level0Fly
local pixelEffect = mod.FF.AberratedPixel
local sound = mod.Sounds.Level0FlyHit
local deathSound = mod.Sounds.Level0FlyDeath
local swarmSound = mod.Sounds.Level0FlySwarm

local RED = Color(1, 0, 0, 0.4)
local BLUE = Color(0, 1, 1, 0.4)

local Settings = {
    MOVE_COOLDOWN = 5, -- How often does it dash to a new position
    DASH_FORCE = 9, -- It moves by dashing to locations. How far does it dash in whatever direction?
    ATTACK_COOLDOWN = 50, -- How many frames until it can affect an entity again?
    PARTICLE_INTERVAL = 2,
    SOUND_COOLDOWN = 40
}

---@param fly EntityNPC
local function getMovementDirection(fly, targetPos)
    local rng = fly:GetDropRNG()

    if fly:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
        local vector = rng:RandomVector():Resized(Settings.DASH_FORCE / 2)
        return vector
    elseif targetPos then
        local movementDirection = (targetPos - fly.Position):Normalized():Rotated(rng:RandomInt(-65, 65)):Resized(Settings.DASH_FORCE)
        if fly:HasEntityFlags(EntityFlag.FLAG_FEAR) then
            movementDirection = movementDirection:Rotated(180)
        end

        return movementDirection
    elseif fly:HasEntityFlags(EntityFlag.FLAG_FEAR) then
        local movementDirection = (fly.Position - fly:GetPlayerTarget().Position):Normalized():Rotated(rng:RandomInt(-65, 65)):Resized(Settings.DASH_FORCE)
        return movementDirection
    else
        local vector = rng:RandomVector():Resized(Settings.DASH_FORCE)
        return vector
    end
end

local function angrygrrrr(fly)
    if fly.State == NpcState.STATE_MOVE then
        fly.State = NpcState.STATE_ATTACK
    end

    sfx:Play(sound, 0.7, Settings.SOUND_COOLDOWN, false, 0.8)
    if sfx:IsPlaying(sound) then
        fly:GetSprite():SetRenderFlags(AnimRenderFlags.GLITCH)
        Isaac.CreateTimer(function ()
            if fly:Exists() and not fly:HasMortalDamage() then
                fly:GetSprite():SetRenderFlags(0)
            end
        end, 4, 1, false)
    end
end

---@param fly EntityNPC
function mod:LevelZeroFlyInit(fly)
    local data = mod:GetEntityData(fly)
    data.LZFMoveCooldown = Settings.MOVE_COOLDOWN
    data.LZFAttackCooldown = 0
    fly:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH | EntityFlag.FLAG_NO_TARGET)
end

---@param fly EntityNPC
function mod:LevelZeroFlyUpdate(fly)
    mod:beelzebubCheck(fly)
    local isCharm = fly:HasEntityFlags(EntityFlag.FLAG_CHARM) or fly:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)

    local data = mod:GetEntityData(fly)
    local sprite = fly:GetSprite()

    if not sprite:IsPlaying("Appear") and fly.State == NpcState.STATE_INIT then
        fly.State = NpcState.STATE_MOVE
        sfx:Play(deathSound, 0.5, 2, false, 0.8)
    end

    data.LZFMoveCooldown = math.max(data.LZFMoveCooldown - 1, 0)
    data.LZFAttackCooldown = math.max(data.LZFAttackCooldown - 1, 0)

    if sprite:IsFinished("Appear") then
        sprite:Play("Idle")
    end

    if game:GetRoom():IsClear() and fly.SubType ~= 1 then
        fly.State = NpcState.STATE_DEATH
        fly.Velocity = Vector.Zero
        fly.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        sfx:Stop(swarmSound)
        return
    end

    if not sfx:IsPlaying(swarmSound) then
        sfx:Play(swarmSound, 0.6, 2, true)
    end

    -- Attack movement
    if fly.State == NpcState.STATE_ATTACK or isCharm then
        if data.LZFMoveCooldown == 0 then
            local targetPos = fly:GetPlayerTarget().Position
            if isCharm then
                local closestEnemy = mod.FindClosestEnemy(fly.Position, nil, true, nil, nil, nil, nil, true, nil, nil, nil)
                if closestEnemy then
                    targetPos = closestEnemy.Position
                end
            end
            local vector = getMovementDirection(fly, targetPos)
            fly.Velocity = vector
            data.LZFMoveCooldown = Settings.MOVE_COOLDOWN
        end

        if fly.FrameCount % Settings.PARTICLE_INTERVAL == 0 and fly.Velocity:Length() > 1e-3 then
            local randomPixelAngle = math.random(-60, 60)
            local particle = Isaac.Spawn(EntityType.ENTITY_EFFECT, pixelEffect.Var, 0, fly.Position - Vector(0, 30), fly.Velocity:Rotated(180 + randomPixelAngle):Resized(5.5), fly):ToEffect()
            particle.Timeout = 10
        end

    -- Idle movement
    elseif fly.State == NpcState.STATE_MOVE then
        if data.LZFMoveCooldown == 0 then
            local vector = getMovementDirection(fly, nil)
            fly.Velocity = vector
            data.LZFMoveCooldown = Settings.MOVE_COOLDOWN
        end
    end

    fly.Velocity = fly.Velocity * 0.8
end

function mod:LevelZeroFlyRender(fly)
    local sprite = fly:GetSprite()
    if sprite:IsEventTriggered("GlitchOut") then
        sprite:SetRenderFlags(AnimRenderFlags.GLITCH)
    end

    if sprite:IsEventTriggered("GlitchOut") then
        sfx:Play(deathSound, 0.5, 5, false, 0.8)
    end
end

---@param fly EntityNPC
---@param collider Entity
function mod:LevelZeroFlyCollision(fly, collider)
    if fly.State ~= NpcState.STATE_MOVE
    and fly.State ~= NpcState.STATE_ATTACK then
        return
    end

    if mod:IsPlayerWeapon(collider) then
        angrygrrrr(fly)
    end

    -- Devolve enemies if the fly is charmed (now an unused interaction but it was cool while it lasted)
    if fly:HasEntityFlags(EntityFlag.FLAG_CHARM) or fly:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
        local data = mod:GetEntityData(fly)
        if data.LZFAttackCooldown > 0 then
            return
        end

        local npc = collider:ToNPC()
        if npc and npc:IsVulnerableEnemy() and npc:IsActiveEnemy() then
            game:DevolveEnemy(npc)
            -- Move backwards and set on cooldown
            fly.Velocity = (fly.Position - npc.Position):Normalized():Resized(Settings.DASH_FORCE)
            data.LZFAttackCooldown = Settings.ATTACK_COOLDOWN
        end
    
    else
        local player = collider:ToPlayer()
        if player then
            local level = game:GetLevel()
            game:StartRoomTransition(
                level:GetPreviousRoomIndex(),
                Direction.NO_DIRECTION,
                RoomTransitionAnim.TELEPORT,
                player
            )
			
			mod.scheduleForUpdate(function()
				if mod.CanRunUnlockAchievements() and not FiendFolio.ACHIEVEMENT.CORRUPTED_LARVA:IsUnlocked(true) then
					FiendFolio.ACHIEVEMENT.CORRUPTED_LARVA:Unlock()
				end
			end, 1, ModCallbacks.MC_PRE_ROOM_EXIT)

            if PlayerManager.AnyoneHasTrinket(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE) then
                local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE)
                local rand = rng:RandomInt(5)
                if (not mod.shampooDialogue.Dialogue and rand == 1) or mod.ShampooTesting then
                    mod:shampooBottleEnemyCommentary("hit", rng, fly)
                end
            end
        end
    end
end

---@param source EntityRef
function mod:LevelZeroFlyCancelDamage(ent, _, flags, source)
    if flags & DamageFlag.DAMAGE_EXPLOSION > 0 then
        angrygrrrr(ent:ToNPC())
    end

    return false
end

function mod:LevelZeroFlyDie()
    for _, ent in ipairs(Isaac.FindByType(mod.FFID.Cat, levelZeroFly.Var)) do
        if not ent:HasMortalDamage() and not ent:IsDead() then
            return
        end
    end

    sfx:Stop(swarmSound)
end

---@param effect EntityEffect
function enemy:PixelAberrationEffect(effect, offset)
    local sprite = Sprite(effect:GetSprite():GetFilename(), true)
    local pos = Isaac.WorldToScreen(effect.Position)

    sprite:Play("Idle", true)
    sprite.Color = RED
    sprite.Offset = RandomVector() * 1
    sprite:Render(pos)

    sprite.Color = BLUE
    sprite.Offset = RandomVector() * 1
    sprite:Render(pos)
end

mod:AddCallback(ModCallbacks.MC_PRE_EFFECT_RENDER, enemy.PixelAberrationEffect, pixelEffect.Var)

function enemy:UpdatePixelEffect(effect)
    if effect.Timeout == 0 then
        effect:Remove()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, enemy.UpdatePixelEffect, pixelEffect.Var)