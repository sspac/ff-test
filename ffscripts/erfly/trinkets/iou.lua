local mod = FiendFolio
local game = Game()
local nilvector = Vector(0, 0)

function mod:iouGameStart(continuing)
	if not game:AchievementUnlocksDisallowed() then
		--Don't proc during challenges
		if FiendFolio.savedata.playerHadIOU then
			if not continuing then
				local room = Game():GetRoom()
				local spawnpos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 1, true)
				local trinket = Isaac.Spawn(5, 350, mod.isAnyoneCharacter(mod.PLAYER.GOLEM) and mod.GetGolemTrinket() or 0, spawnpos, nilvector, nil):ToPickup()

				if trinket.Type == 5 and trinket.Variant == 350 and FiendFolio.savedata.playerHadGoldenIOU then
					trinket:Morph(5, 350, trinket.SubType + TrinketType.TRINKET_GOLDEN_FLAG)
				end
			end
			FiendFolio.savedata.playerHadIOU = nil
			FiendFolio.savedata.playerHadGoldenIOU = nil
		elseif FiendFolio.savedata.playerHadFossilizedBlessing then
			if not continuing then
				local room = Game():GetRoom()
				for i=1,FiendFolio.savedata.playerHadFossilizedBlessing do
					local spawnpos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 1, true)
					local trinket = Isaac.Spawn(5, 350, mod.GetGolemTrinket(), spawnpos, nilvector, nil):ToPickup()
				end
			end
			FiendFolio.savedata.playerHadFossilizedBlessing = nil
			FiendFolio.shampooDialogue = {}
		end
	end
end

function mod:iouPreExit()
    if mod.anyPlayerHas(mod.ITEM.TRINKET.IOU, true) then
        FiendFolio.savedata.playerHadIOU = true
        for i = 1, game:GetNumPlayers() do
            local player = Isaac.GetPlayer(i - 1)
            if player:GetTrinket(0) == mod.ITEM.TRINKET.IOU + TrinketType.TRINKET_GOLDEN_FLAG or
            player:GetTrinket(1) == mod.ITEM.TRINKET.IOU + TrinketType.TRINKET_GOLDEN_FLAG
            then
                FiendFolio.savedata.playerHadGoldenIOU = true
                break
            end
        end
    end
end