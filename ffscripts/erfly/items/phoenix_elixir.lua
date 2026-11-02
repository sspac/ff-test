local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local phoenixElixirRebornCostume = Isaac.GetCostumeIdByPath("gfx/characters/ff_phoenix_elixir_reborn.anm2")

-- Called from `ffscripts/revives.lua`
function mod.TryPhoenixElixerRevive(player, data, effs)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.PHOENIX_ELIXIR) then
		player:RemoveCollectible(FiendFolio.ITEM.COLLECTIBLE.PHOENIX_ELIXIR)
		player:Revive()
        player:AnimateCollectible(FiendFolio.ITEM.COLLECTIBLE.PHOENIX_ELIXIR)
        player:SetMinDamageCooldown(100)

        data.ffsavedata.empoweredByPhoenixElixir = true
        data.ffsavedata.PhoenixElixirBuffActive = true
        player:AddNullCostume(phoenixElixirRebornCostume)

        player:AddCacheFlags(CacheFlag.CACHE_ALL)
        player:EvaluateItems()

        --Hurt enemies
        game:BombExplosionEffects(player.Position, 20, TearFlags.TEAR_NORMAL, Color.Default, player, 1, false, true, DamageFlag.DAMAGE_EXPLOSION)
        for i = 45, 360, 45 do
            local fire = Isaac.Spawn(1000, 52, 0, player.Position, Vector(0, 5):Rotated(i), player):ToEffect()
            fire.CollisionDamage = 15
            fire:Update()
        end
        for i, entity in pairs(Isaac.GetRoomEntities()) do
            if entity:IsVulnerableEnemy() and (not mod:isFriend(entity:ToNPC())) then
                local distance = (player.Position - entity.Position):Length()

                if distance - entity.Size <= 150 then
                    entity:AddBurn(EntityRef(player),300,player.Damage)
                end
            end
        end

        --Effects
        sfx:Play(mod.Sounds.LezEffectGet, 1, 0, false, 0.75)
		game:MakeShockwave(player.Position, 0.035, 0.025, 10)
	end
end

function mod:handlePhoenixElixirPlayerUpdate(player, data)
    local sdata = data.ffsavedata
    if sdata.empoweredByPhoenixElixir then
        local heartCount = player:GetHearts()
        if mod.IsActiveRoom() then
            if not sdata.PhoenixElixirHealedRooms then
                sdata.PhoenixElixirHealedRooms = {}
            end
            local level = game:GetLevel()
            local listIndex = level:GetRoomByIdx(level:GetPreviousRoomIndex()).ListIndex
            if not sdata.PhoenixElixirHealedRooms[tostring(listIndex)] then
                if heartCount <= 3 and heartCount < player:GetEffectiveMaxHearts() then
                    data.PhoenixElixirTimer = data.PhoenixElixirTimer or 0
                    data.PhoenixElixirTimer = data.PhoenixElixirTimer + 1
                    if data.PhoenixElixirTimer > 120 then
                        player:AddHearts(1)
                        sdata.PhoenixElixirHealedRooms[tostring(listIndex)] = true
                        data.PhoenixElixirTimer = nil
                        --Visuals
                        sfx:Play(SoundEffect.SOUND_VAMP_GULP)
                        local effect = Isaac.Spawn(1000, 49, 0, player.Position, Vector.Zero, player):ToEffect()
			            effect:FollowParent(player)
                        effect.SpriteOffset = Vector(0, -50)
                        effect:Update()
                    end
                end
            end
        end
        local evalCache
        if heartCount <= 2 and not sdata.PhoenixElixirBuffActive then
            sdata.PhoenixElixirBuffActive = true
            player:AddNullCostume(phoenixElixirRebornCostume)
            evalCache = true
        elseif heartCount > 2 and sdata.PhoenixElixirBuffActive then
            sdata.PhoenixElixirBuffActive = false
            player:TryRemoveNullCostume(phoenixElixirRebornCostume)
            evalCache = true
        end
        if evalCache then
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_TEARFLAG | CacheFlag.CACHE_TEARCOLOR)
		    player:EvaluateItems()
        end
    end
end

function mod:phoenixElixirPostNewRoom(player, d, savedata)
    d.PhoenixElixirTimer = nil
end

function mod:phoenixElixirPostNewLevel(player, d)
    if d.ffsavedata then
        local sdata = d.ffsavedata
        sdata.PhoenixElixirHealedRooms = nil
    end
end

FiendFolio.ColorFireTime = Color(1, 1, 1, 1, 0.25, 0, 0)
FiendFolio.ColorFireTime:SetColorize(1, 0.3, 0.1, 1)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, flag)
    local d = mod:GetEntityData(player)
    local sdata = d.ffsavedata
	if sdata and sdata.empoweredByPhoenixElixir then
        if sdata.PhoenixElixirBuffActive then
            sdata.PhoenixElixirBuffActive = true
            if flag == CacheFlag.CACHE_DAMAGE then
                player.Damage = player.Damage + 1
            elseif flag == CacheFlag.CACHE_TEARFLAG then
                player.TearFlags = player.TearFlags | TearFlags.TEAR_BURN
            elseif flag == CacheFlag.CACHE_TEARCOLOR then
                player.TearColor = FiendFolio.ColorFireTime
                player.LaserColor = FiendFolio.ColorFireTime
            end
        else
            sdata.PhoenixElixirBuffActive = nil
        end
	end
end)

--[[function mod:phoenixElixirPlayerHurt(player)
    local d = mod:GetEntityData(player)
    if d.ffsavedata and d.ffsavedata.empoweredByPhoenixElixir then
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
		player:EvaluateItems()
    end
end]]