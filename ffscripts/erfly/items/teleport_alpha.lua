local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local function findRandomPos(rng)
    local room = game:GetRoom()
    local size = room:GetGridSize()
    local validPositions = {}
    for i=0, size do
        local gridpos = room:GetGridPosition(i)
        if room:GetGridCollisionAtPos(gridpos) == GridCollisionClass.COLLISION_NONE and room:IsPositionInRoom(gridpos, 0) then
            table.insert(validPositions, gridpos)
        end
    end
    return validPositions[rng:RandomInt(#validPositions) + 1]
end

function mod:alphaTeleportToPosition(player, targPos)
    sfx:Play(SoundEffect.SOUND_HELL_PORTAL1, 0.65, 0, false, 1)
    local vec = (targPos - player.Position) / 12
    for i = 1, 10 do
        local cloud = Isaac.Spawn(1000, mod.FF.FFWhiteSmoke.Var, mod.FF.FFWhiteSmoke.Sub, player.Position + (vec * i), vec/10, player)
        mod:GetEntityData(cloud).longonly = true
        cloud.SpriteScale = Vector(0.75,0.75) * i/10
        cloud.SpriteOffset = Vector(0,-10)
        cloud.Color = Color(1,1,1,0.5)
        cloud:Update()
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BLACK_POWDER) then
            local powder = Isaac.Spawn(1000, 92, 0, player.Position + (vec * i), Vector.Zero, player)
        end
    end
    player:Teleport(targPos, false)
    player:SetColor(Color(1,1,1,1,1,1,1), 5, 10, true, false)
    player:SetMinDamageCooldown(30)
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if entity:IsVulnerableEnemy() and (not mod:isFriend(entity:ToNPC())) or entity.Type == 33 then
            local distance = (player.Position - entity.Position):Length()
            if entity.Type == 33 then
                if distance - player.Size - entity.Size <= 0 then
                    entity:Die()
                end
            elseif distance - player.Size - entity.Size <= 20 then
                entity:AddEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
                entity:TakeDamage(40 + (player.Damage * 3), 0, EntityRef(player), 0)
                mod.scheduleForUpdate(function()
                    if entity then
                        if not (entity:IsDead() or entity:HasMortalDamage()) then
                            entity:ClearEntityFlags(EntityFlag.FLAG_EXTRA_GORE)
                        end
                    end
                end, 1)
            end
        end
    end
end

function mod:teleportAlphaWispUpdate(fam)
	--fam:RemoveFromOrbit()
    if game:GetRoom():GetFrameCount() == 0 then
        fam:Remove()
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, item, rng, player, useflags, activeslot)
    local targ = findRandomPos(rng)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
        local wisp = Isaac.Spawn(3, FamiliarVariant.WISP, mod.ITEM.COLLECTIBLE.TELEPORT_ALPHA, player.Position, Vector.Zero, player):ToFamiliar()
        wisp:RemoveFromOrbit()
        wisp:Update()
        sfx:Play(SoundEffect.SOUND_CANDLE_LIGHT, 1, 0, false, 1)
    end
    mod:alphaTeleportToPosition(player, targ)
    return true
end, mod.ITEM.COLLECTIBLE.TELEPORT_ALPHA)

function mod:teleportAlphaPlayerUpdate(player)
    local data = mod:GetEntityData(player)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.TELEPORT_ALPHA) then
        local room = game:GetRoom()
        if room:GetFrameCount() <= 1 or not data.SavedAlphaTelePos then
            data.SavedAlphaTelePos = player.Position
        end
    else
        if data.SavedAlphaTelePos then
            mod:alphaTeleportToPosition(player, data.SavedAlphaTelePos)
            data.SavedAlphaTelePos = nil
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.TELEPORT_ALPHA, mod.teleportAlphaPlayerUpdate)
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, mod.teleportAlphaPlayerUpdate, mod.ITEM.COLLECTIBLE.TELEPORT_ALPHA)
