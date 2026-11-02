local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local flag = TearFlagsLib.RegisterTearFlag("CETUS")

function mod:cetusUpdate(player)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.CETUS) then
        local tempEffects = player:GetEffects()
        if tempEffects:HasCollectibleEffect(mod.ITEM.COLLECTIBLE.CETUS) then
            if player.FrameCount % 2 == 0 then
                local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.CETUS)
                local newtear = Isaac.Spawn(2, 0, 0, player.Position, Vector(0,1+rng:RandomInt(15)/3):Rotated(rng:RandomInt(360)), player):ToTear()
                newtear.FallingSpeed = -18 - rng:RandomInt(20)
                newtear.FallingAcceleration = 1.1
                newtear.Height = -10
                newtear.CanTriggerStreakEnd = false
				local params = player:GetTearHitParams(WeaponType.WEAPON_TEARS, 1, (math.random(2) == 1 and 1) or -1, nil)
                newtear.CollisionDamage = params.TearDamage
                newtear.Scale = math.min(1.2, params.TearScale * 7/11)
                newtear.SpawnerEntity = player
				newtear.TearFlags = params.TearFlags
                newtear.Color = params.TearColor
                mod:GetEntityData(newtear).dontCollideBombs = true
				TearFlagsLib.AddTearFlags(newtear, flag)
                TearFlagsLib.CallPollTearFlagCallback(newtear, player, TearFlagsLib.WeaponFlag.TEAR)
				if newtear.Variant ~= 0 then newtear:ChangeVariant(0) end
				newtear:SetInitSound(SoundEffect.SOUND_TEARS_FIRE)
                newtear:Update()
            end
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.ITEM.COLLECTIBLE.CETUS, mod.cetusUpdate)

function mod:cetusPlayerHurt(player)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.CETUS) then
        --sfx:Play(SoundEffect.SOUND_SATAN_HURT, 1, 0, false, 0.5)
        for i = 1, player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.CETUS) do
            player:UseActiveItem(mod.ITEM.COLLECTIBLE.CETUS)
        end
    end
end

local cetusPlayer, cetusTear, cetusOrigPos
function mod:cetusTearDeath(tear,data)
    if TearFlagsLib.HasTearFlags(tear, flag) then
        local spawner = tear.SpawnerEntity
        local player
        if not spawner then
            return
        end
        
        if spawner:ToPlayer() then
            player = spawner:ToPlayer()
        end
        if not player then
            player = Isaac.GetPlayer()
        end
        --Padre forgive me for I have sinned
        cetusPlayer, cetusTear, cetusOrigPos = player, tear, player.Position
        player.Position = tear.Position
		local params = player:GetTearHitParams(WeaponType.WEAPON_TEARS, 1, 1, nil)
		params.TearDamage = tear.CollisionDamage * 2/3
		params.TearFlags = tear:ToTear().TearFlags
		params.TearColor = tear.Color
		if TearFlagsLib.HasTearFlags(tear, TearFlagsLib.Flag.GODS_MARBLE) then
			params.TearColor = Color(1, 1, 1, 1, 0, 0, 0, 1.2, 1.2, 0.8, 1)
		end
        player:SpawnAquariusCreep(params)
        player.Position = cetusOrigPos
		cetusPlayer, cetusTear, cetusOrigPos = nil, nil, nil
    end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, creep)
	if TearFlagsLib.WasEntityFiredByPlayerMimic(creep) and cetusPlayer and cetusTear then
		local data = mod:GetEntityData(creep)
		data.FFAquariusColor = nil
		data.FFAquariusTearColor = nil
		TearFlagsLib.CopyTearFlags(creep, cetusTear, TearFlagsLib.WeaponFlag.AQUARIUS, {wipe = true})
		cetusPlayer.Position = cetusOrigPos
	end
end, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL)

function FiendFolio.HasCetusFlag(ent)
	return TearFlagsLib.HasTearFlags(ent, flag)
end