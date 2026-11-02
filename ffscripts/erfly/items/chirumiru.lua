local mod = FiendFolio
local game = Game()
local nilvector = mod.nilvector

FiendFolio.AddItemPickupCallback(function(player, added)
    if player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.CHIRUMIRU) == 9 then
        SFXManager():Play(SoundEffect.SOUND_POWERUP_SPEWER)
        game:GetHUD():ShowItemText("Cirno!", "9. Idiot.")
    end
end, nil, mod.ITEM.COLLECTIBLE.CHIRUMIRU)

function mod:tryTriggerCirno()
	if mod.anyPlayerHas(mod.ITEM.COLLECTIBLE.CHIRUMIRU) then
		mod.scheduleForUpdate(function()
			for _, entity in pairs(Isaac.FindInRadius(Isaac.GetPlayer(0).Position, 9999, EntityPartition.ENEMY)) do
				entity:SetColor(Color(0.22, 0.22, 0.22, 1.0, 40/255, 40/255, 40/255), 25, 5, false, false)
			end
		end, 2, ModCallbacks.MC_POST_UPDATE, true)
		mod.scheduleForUpdate(function()
			for _, entity in pairs(Isaac.FindInRadius(Isaac.GetPlayer(0).Position, 9999, EntityPartition.ENEMY)) do
				entity:AddFreeze(EntityRef(Isaac.GetPlayer(0)), 27)
			end
		end, 18, ModCallbacks.MC_POST_UPDATE, true)
		for i = 1, game:GetNumPlayers() do
			local player = Isaac.GetPlayer(i - 1):ToPlayer()
			if player:HasCollectible(mod.ITEM.COLLECTIBLE.CHIRUMIRU) then
				local pulse = Isaac.Spawn(1000, 1960, 20, player.Position, nilvector, player)
				pulse.Color = Color(1,1,1,0.1,0,0,0)
				pulse:Update()
			end
		end
	end
end

function mod:cirnoTime()
	local room = game:GetRoom()
	if not room:IsClear() then
		mod:tryTriggerCirno()
	end
end