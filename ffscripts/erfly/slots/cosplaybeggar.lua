local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, function(_, slot)
    local sprite, d = slot:GetSprite(), mod:GetEntityData(slot)
	local data = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'SlotData', tostring(slot.InitSeed), {})


    if sprite:IsFinished("Teleport") then
        slot:Remove()
    elseif slot.SubType == 1 and not (sprite:IsPlaying("Prize") or sprite:IsPlaying("Teleport")) then
        sprite:Play("Teleport")
    elseif sprite:IsFinished("PayNothing") or sprite:IsFinished("Prize") then
        if sprite:IsFinished("PayNothing") then
            mod:fortuneGrubCheck()
        end
        sprite:Play("Idle")
    elseif sprite:IsFinished("PayPrize") then
        sprite:Play("Prize")
    elseif sprite:IsEventTriggered("Prize") then
        mod:fortuneGrubCheck()
        if math.random(3) == 1 then
            game:GetLevel():SetStateFlag(LevelStateFlag.STATE_BUM_LEFT, true)
            sfx:Play(SoundEffect.SOUND_THUMBSUP, 1, 0, false, 1)
            slot.SubType = 1
            local room = game:GetRoom()
            local pos = room:FindFreePickupSpawnPosition(slot.Position, 40, true)
            Isaac.Spawn(5, 100, mod.ITEM.COLLECTIBLE.PERFECTLY_GENERIC_OBJECT_4, pos, nilvector, slot)
            local payouts = 0
			if d.lastCollider and d.lastCollider:ToPlayer() then
				payouts = payouts + math.ceil(FiendFolio.GetGolemTrinketPower(d.lastCollider:ToPlayer(), FiendFolio.ITEM.ROCK.THANK_YOU_FOSSIL))
			end
			for k = 1, payouts do
                local vec = RandomVector() * 3
                for i = 120, 360, 120 do
                    local choices = {10, 20, 30, 40}
                    local rand = math.random(#choices)
                    Isaac.Spawn(5, choices[rand], 0, slot.Position, vec:Rotated(i), slot)
                    table.remove(choices, rand)
                end
            end
        else
            sfx:Play(SoundEffect.SOUND_SLOTSPAWN, 1, 0, false, 1)
            local payouts = 1
			if d.lastCollider and d.lastCollider:ToPlayer() then
				payouts = payouts + math.ceil(FiendFolio.GetGolemTrinketPower(d.lastCollider:ToPlayer(), FiendFolio.ITEM.ROCK.THANK_YOU_FOSSIL))
			end
			for k = 1, payouts do
                local vec = RandomVector() * 3
                for i = 120, 360, 120 do
                    local choices = {10, 20, 30, 40}
                    local rand = math.random(#choices)
                    Isaac.Spawn(5, choices[rand], 0, slot.Position, vec:Rotated(i), slot)
                    table.remove(choices, rand)
                end
            end
        end
    end

	if not d.DropFunc then
		function d.DropFunc()
			if not d.DidDropFunc then
                d.DidDropFunc = true
                game:GetLevel():SetStateFlag(LevelStateFlag.STATE_BUM_KILLED, true)
                game:GetLevel():SetStateFlag(LevelStateFlag.STATE_EVIL_BUM_KILLED, true)
                if math.random(5) == 1 then
                    local spawn = Isaac.Spawn(5, math.random(4) * 10, 0, slot.Position, nilvector, slot)
                    mod:GetEntityData(spawn).DontRemoveRecentReward = true
                end
            end
		end
	end

    FiendFolio.OverrideExplosionHack(slot)
end, mod.FF.CosplayBeggar.Var)

FiendFolio.onMachineTouch(mod.FF.CosplayBeggar.Var, function(player, slot)
    local sprite, d = slot:GetSprite(), mod:GetEntityData(slot)
	local data = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'SlotData', tostring(slot.InitSeed), {})
    
    if sprite:IsPlaying('Idle') and player:GetNumCoins() >= 5 then
        player:AddCoins(-5)
        sfx:Play(SoundEffect.SOUND_SCAMPER, 1, 0, false, 1)
        d.lastCollider = player
        if math.random(3) == 1 then
            sprite:Play("PayNothing")
        else
            sprite:Play("PayPrize")
        end
        mod:doBethEssenceCheck(player, 5)
    end
end)