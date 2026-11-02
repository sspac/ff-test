local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
	local data = mod:GetEntityData(player).ffsavedata

	local vec
	local enemy = mod.FindClosestEnemy(player.Position)
	if player:GetMovementVector():Length() > 0 then
		vec = player:GetMovementVector():Resized(30)
	elseif enemy then
		vec = (enemy.Position - player.Position):Resized(30)
	else
		vec = RandomVector():Resized(30)
	end
    for i = 120, 360, 120 do
		FiendFolio.LaunchFireball(player, vec:Rotated(i), "implosion")
	end

	FiendFolio:trySayAnnouncerLine(mod.Sounds.VACardImplosion, flags, 40)
end, mod.ITEM.CARD.IMPLOSION)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
	local buddy = Isaac.Spawn(mod.FF.Psihunter.ID, mod.FF.Psihunter.Var, 10, player.Position, nilvector, player):ToNPC()
	buddy:AddCharmed(EntityRef(player), -1)
	buddy:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
	buddy:Update()

	FiendFolio:trySayAnnouncerLine(mod.Sounds.VACardCallingCard, flags, 20)
end, mod.ITEM.CARD.CALLING_CARD)

--Assumed issue at first
--[[function mod.IsThereARailInTheRoom()
	local foundRail = false
	local room = game:GetRoom()
	for i = 0, room:GetGridSize()-1 do
		local rail = room:GetRail(i)
		if rail and rail <= 101 then
			foundRail = true
			break
		end
	end
	return foundRail
end]]

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
	mod.downloadFailureCarded = true
	sfx:Play(SoundEffect.SOUND_EDEN_GLITCH, 1, 0, false, math.random(90,110)/100)
	--if not mod.IsThereARailInTheRoom() then
		for i = 1, math.random(20,35) do
			local effSubtype = math.random(BackdropType.NUM_BACKDROPS - 1)
			--Isaac.DebugString("Tried to spawn 1000.4." .. effSubtype)
			local particle = Isaac.Spawn(1000, 4, effSubtype, Isaac.GetRandomPosition(), RandomVector()*math.random(10, 350)/100, nil):ToEffect()
			particle.Color = Color(math.random() * 2,math.random() * 2,math.random() * 2,1, math.random() * 2, math.random() * 2, math.random() * 2)
			particle.m_Height = -300 - math.random(1200)
			mod.scheduleForUpdate(function()
				if particle then
					local sprite = particle:GetSprite()
					particle.Color = mod.ColorNormal
					sprite:ReplaceSpritesheet(0, "gfx/grid/rocks_error-1.png.png")
					sprite:LoadGraphics()
				end
			end, math.random(50,100))
			particle:Update()
		end
	--end
	Game():ShakeScreen(15)
	player:QueueExtraAnimation("Glitch")

	if math.random(3) == 1 then
		FiendFolio:trySayAnnouncerLine(mod.Sounds.VACardDownloadFailureRare, flags, 40)
	else
		FiendFolio:trySayAnnouncerLine(mod.Sounds.VACardDownloadFailure, flags, 40)
	end
end, mod.ITEM.CARD.DOWNLOAD_FAILURE)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS, false, false, true, false)
	FiendFolio:trySayAnnouncerLine(mod.Sounds.VAObjectSorry, flags, 20)

	mod.scheduleForUpdate(function()
		player:AnimateCard(FiendFolio.ITEM.CARD.SORRY, "UseItem")

		-- Remove every instance of the card from the player
		for i = 0, 2 do
			if player:GetCard(i) == FiendFolio.ITEM.CARD.SORRY then
				player:SetCard(i, 0)
				break
			end
		end
	end, 2, nil, true)

	-- Queue removal of every instance of the card in the room
	local runData = mod.savedata.run
	local roomIdx = game:GetLevel():GetCurrentRoomIndex()
	local saveIndex = tostring(roomIdx)

	runData.SorryUsedRooms = runData.SorryUsedRooms or {}
	runData.SorryUsedRooms[saveIndex] = true
end, FiendFolio.ITEM.CARD.SORRY)

-- Remove every instance of the card in the room
mod:AddCallback(ModCallbacks.MC_PRE_GLOWING_HOURGLASS_SAVE, function(_, slot)
	local runData = mod.savedata.run

	if runData.SorryUsedRooms then
		local roomIdx = game:GetLevel():GetCurrentRoomIndex()
		local saveIndex = tostring(roomIdx)

		if runData.SorryUsedRooms[saveIndex] then
			local cards = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, FiendFolio.ITEM.CARD.SORRY)

			for i, card in pairs(cards) do
				card:Remove()
			end
		end
	end
end)

-- Clear the tracker for the room
mod:AddCallback(ModCallbacks.MC_POST_GLOWING_HOURGLASS_SAVE, function(_, slot)
	local runData = mod.savedata.run

	if runData.SorryUsedRooms then
		local roomIdx = game:GetLevel():GetCurrentRoomIndex()
		local saveIndex = tostring(roomIdx)
		runData.SorryUsedRooms[saveIndex] = nil

		-- Remove the entire tracker if it's empty
		if mod:GetTableLength(runData.SorryUsedRooms) <= 0 then
			runData.SorryUsedRooms = nil
		end
	end
end)