local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_USE_PILL, function(_, effect, player, flags, pillColor)
	sfx:Play(SoundEffect.SOUND_BOIL_HATCH)
	player:AnimateHappy()

	local doHorseEffect = pillColor & PillColor.PILL_GIANT_FLAG > 0
	local room = game:GetRoom()

	for i = 1, doHorseEffect and 18 or 10 do
		Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_SPIDER, mod.ITEM.FAMILIAR.BLUE_BABY_SPIDER_SUBTYPE, player.Position, RandomVector():Resized(math.random(3, 6)), player)
	end

	for i = 2, 3 do
		player:ThrowBlueSpider(player.Position, player.Position + RandomVector():Resized(math.random(20, 30)))
	end

	if doHorseEffect then
		for i = 1, 4 do
			if i <= 2 then
				player:ThrowBlueSpider(player.Position, player.Position + RandomVector():Resized(math.random(20, 30)))
			else
				local spider = Isaac.Spawn(215, 0, 0, player.Position, RandomVector():Resized(math.random(10, 20)), player)
				spider:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				spider:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM | EntityFlag.FLAG_PERSISTENT)
			end
		end
		
		sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER_AMPLIFIED, 1, 0, false, 1)
		sfx:Play(SoundEffect.SOUND_THUMBSUP_AMPLIFIED, 1, 0, false, 1)
		mod:trySayAnnouncerLine(mod.Sounds.VAPillHorseSpiderUnboxing, flags, 20)
	else
		mod:trySayAnnouncerLine(mod.Sounds.VAPillSpiderUnboxing, flags, 20)
	end

	local position = room:FindFreeTilePosition(player.Position, 180)
	local index = room:GetGridIndex(position)
	room:SpawnGridEntity(index, GridEntityType.GRID_SPIDERWEB, 6, Random(), 1)
end, mod.ITEM.PILL.SPIDER_UNBOXING)